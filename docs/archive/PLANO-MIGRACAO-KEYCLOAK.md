# Plano de Migração — Autenticação → Keycloak + Painel Admin

> Data: 2026-04-12
> Contexto: 3 apps (ERP/CRM/iChat), 6 empresas, 200 usuários, vai virar SaaS, LGPD contratual

---

## Objetivo

Substituir o sistema de autenticação customizado por **Keycloak** (Identity Provider), e criar um **painel admin customizado** (`admin.apli.indiolab.com.br`) que consome a Admin REST API do Keycloak para gerenciar tudo (usuários, permissões, empresas, configurações, etc.).

---

## Decisões arquiteturais

| Decisão | Escolha | Razão |
|---------|---------|-------|
| **Modelo multi-tenant** | 1 realm `indiolab` + Groups por empresa | Simples, mantém arquitetura schema-per-tenant, fácil de escalar |
| **URL do Keycloak** | `auth.apli.indiolab.com.br` | Consistente com padrão de subdomínios |
| **URL do Admin** | `admin.apli.indiolab.com.br` | Painel customizado próprio (Super Admin) |
| **Clients no Keycloak** | 4 clients: `erp-web`, `crm-web`, `ichat-web`, `admin-web` | 1 por frontend + 1 pro admin |
| **Protocolo** | OIDC + PKCE | Padrão moderno, seguro, pronto para SaaS |
| **Acesso a APIs backend** | JWT validado via JWKS endpoint do Keycloak | Sem mais HMAC com secret compartilhado |
| **Roles** | Roles por client (não realm roles) | Isolamento entre apps |
| **Source of truth de usuário** | Keycloak (ID + credenciais + atributos básicos) | Nossa tabela `usuarios` vira tabela de **perfil** |
| **Sincronização** | Admin API do Keycloak (via backend admin-api) | Controle total, sem complexidade de user federation |
| **Banco do Keycloak** | PostgreSQL 17 (mesmo container) + database separada | Reutiliza infra existente |
| **Tema de login** | Tema customizado Indio Lab | Branding próprio na tela de login |

---

## Nova arquitetura

```
                              ┌──────────────────────────────┐
                              │  Keycloak Admin API          │
                              │  (consumida via backend)      │
                              └──────────────┬───────────────┘
                                             │
                              ┌──────────────▼───────────────┐
                              │  Keycloak IdP                │
                              │  auth.apli.indiolab.com.br    │
                              │                              │
                              │  • Realm: indiolab            │
                              │  • 6 Groups (empresas)        │
                              │  • 4 Clients (erp/crm/ichat/  │
                              │    admin)                    │
                              │  • Roles por client          │
                              │  • 200 Users                 │
                              │  • Custom theme (Indio Lab)   │
                              └──────────────┬───────────────┘
                                             │
                                             │ OIDC
         ┌───────────────┬───────────────────┼─────────────────┐
         │               │                   │                 │
    ┌────▼────┐    ┌─────▼────┐        ┌─────▼─────┐    ┌──────▼──────┐
    │ erp-web │    │ crm-web  │        │ ichat-web │    │ admin-web   │
    └────┬────┘    └─────┬────┘        └─────┬─────┘    └──────┬──────┘
         │               │                   │                 │
         ↓               ↓                   ↓                 ↓
    ┌─────────┐   ┌──────────┐        ┌──────────┐      ┌───────────┐
    │ erp-api │   │ crm-api  │        │ichat-api │      │ admin-api │
    └────┬────┘   └────┬─────┘        └────┬─────┘      └─────┬─────┘
         │             │                   │                  │
         └─────────────┴───────────────────┴──────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   PostgreSQL 17         │
                    │                         │
                    │   • opticalcore (dados) │
                    │   • keycloak (auth)     │
                    └─────────────────────────┘
```

---

## Fases da migração

### Fase 1 — Deploy do Keycloak

**Objetivo:** Ter Keycloak rodando em `auth.apli.indiolab.com.br` com banco separado no Postgres.

#### Passos:
1. **Criar database `keycloak`** no PostgreSQL existente
2. **Adicionar container Keycloak** ao `docker-compose.yml`
3. **Variáveis de ambiente:**
   - `KC_DB=postgres`
   - `KC_DB_URL=jdbc:postgresql://localhost:5432/keycloak`
   - `KC_DB_USERNAME=opticalcore`
   - `KC_DB_PASSWORD=...`
   - `KC_HOSTNAME=auth.apli.indiolab.com.br`
   - `KC_HOSTNAME_STRICT=true`
   - `KC_PROXY_HEADERS=xforwarded`
   - `KC_HTTP_ENABLED=true` (Nginx faz TLS termination)
   - `KC_BOOTSTRAP_ADMIN_USERNAME=admin`
   - `KC_BOOTSTRAP_ADMIN_PASSWORD=...` (forte)
4. **Nginx reverse proxy** para `auth.apli.indiolab.com.br`:
   - Proxy para `localhost:8080`
   - WebSocket support (para admin console)
   - SSL via cert wildcard existente
5. **Health check** e restart policy
6. **Firewall:** 8080 interno (Nginx faz proxy)
7. **Backup** da database `keycloak` incluído no backup Postgres

**Entregável:** `https://auth.apli.indiolab.com.br` acessível, admin console funcionando.

---

### Fase 2 — Configuração do Realm + Clients

**Objetivo:** Configurar o realm `indiolab` com estrutura completa (clients, roles, groups, policies).

#### Passos:

**2.1 — Criar realm `indiolab`**
- Nome: `indiolab`
- Display name: "Indio Lab"
- Frontend URL: `https://auth.apli.indiolab.com.br`

**2.2 — Configurar políticas de segurança do realm**
- **Password policy:** min 10 chars, 1 upper, 1 lower, 1 digit, 1 special, não pode ser username/email, histórico de 5
- **Brute force protection:** ativar, 5 tentativas, bloqueio 15 min
- **Session timeout:** SSO idle 30min, max 8h
- **Token lifespan:** access 5min, refresh 30min
- **Email:** SMTP configurado (para reset de senha)
- **Login theme:** `indiolab` (criado na fase 5)
- **Account theme:** `indiolab`
- **Internationalization:** pt-BR default, fallback en

**2.3 — Criar 4 clients**

Para cada client (`erp-web`, `crm-web`, `ichat-web`, `admin-web`):
- **Client type:** OpenID Connect
- **Client authentication:** ON (confidential) para admin-web / OFF (public) para os 3 webs
- **Authentication flow:** Standard flow + Direct access grants (off)
- **Valid redirect URIs:** `https://{app}.apli.indiolab.com.br/*`
- **Web origins:** `+` (CORS)
- **PKCE:** S256 (obrigatório)
- **Client scopes:** openid, profile, email, + scope customizado `tenant`

Client adicional:
- **`keycloak-admin-api`** (confidential, service account) — usado pelo `admin-api` backend para chamar Admin API

**2.4 — Criar roles por client**

**erp-web:**
- `super-admin`, `admin`, `gerente`, `vendedor`, `comprador`, `financeiro`, `fiscal`, `estoquista`, `produtor`, `usuario-basico`

**crm-web:**
- `admin-crm`, `gerente-comercial`, `consultor`, `vendedor-externo`

**ichat-web:**
- `admin-chat`, `atendente`, `supervisor`

**admin-web:**
- `super-admin-sistema` (único role — apenas para equipe Indio Lab)

**2.5 — Criar groups (empresas)**

Para cada uma das 6 empresas:
- Group: `empresa-{codigo}` (ex: `empresa-00000000000000`)
- Attributes do group:
  - `tenantId`: GUID da empresa
  - `schemaName`: nome do schema no Postgres
  - `razaoSocial`: nome completo
  - `planoAtivo`: basic / pro / enterprise (preparação pra SaaS)
  - `modulosHabilitados`: erp,crm,chat (lista)

**2.6 — Protocol Mapper customizado**

Adicionar ao JWT gerado pelo Keycloak:
- `tenant_id` → vem do group attribute
- `schema_name` → vem do group attribute
- `modulos_habilitados` → vem do group attribute
- `empresa_razao_social` → vem do group attribute
- `roles` → roles do client correspondente

**2.7 — Configurar email SMTP**
- Host do provedor (Gmail, SendGrid, Amazon SES, etc.)
- Templates customizados em pt-BR

**Entregável:** Realm completo, pronto para receber usuários.

---

### Fase 3 — Migração dos 200 usuários existentes

**Objetivo:** Importar todos os usuários atuais do Postgres para o Keycloak.

#### Passos:

**3.1 — Script de migração**
- Ler tabela `usuarios` do Postgres
- Para cada usuário:
  - Criar user no Keycloak via Admin API (`POST /admin/realms/indiolab/users`)
  - Setar email, username, firstName, lastName, enabled
  - **Senhas:** importar hash (Keycloak suporta import de hash PBKDF2/Argon2 via API)
    - Se incompatível: forçar reset de senha no primeiro login (mais seguro)
  - Atribuir ao group correspondente à empresa
  - Atribuir roles por client baseado nas flags `tem_acesso_erp/crm/chat` e roles atuais
- Mapear ID antigo → novo Keycloak ID (tabela `usuarios_keycloak_map`)

**3.2 — Validação**
- Verificar contagem (200 no Postgres → 200 no Keycloak)
- Testar login de amostras de cada empresa
- Verificar claims do JWT (tenant_id, schema_name, roles)

**3.3 — Plano B (rollback)**
- Manter tabela `usuarios` intocada durante teste
- Se problema: apenas voltar apps para usar auth antigo
- Não deletar dados até validar 100%

**Entregável:** 200 usuários importados com sucesso no Keycloak.

---

### Fase 4 — Migração dos 3 backends .NET

**Objetivo:** `erp-api`, `crm-api`, `ichat-api` validam JWT do Keycloak em vez de gerar/validar JWT próprio.

#### Passos para cada backend:

**4.1 — Remover código de auth custom**
- Deletar `AuthService`, `JwtService`, `AuthController`
- Manter apenas: validação de permissões por policy
- Deletar `LoginDto`, `RegisterRequest`
- Manter `UsersController` mas só para **queries** (não cria/deleta — isso é no admin-api)

**4.2 — Configurar JWT Bearer**
```csharp
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => {
        options.Authority = "https://auth.apli.indiolab.com.br/realms/indiolab";
        options.Audience = "erp-web"; // ou crm-web, ichat-web
        options.RequireHttpsMetadata = true;
        options.TokenValidationParameters = new TokenValidationParameters {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            NameClaimType = "preferred_username",
            RoleClaimType = "resource_access.{client}.roles",
        };
    });
```

**4.3 — Claims transformer**
- Extrair `tenant_id`, `schema_name`, `modulos_habilitados` do JWT
- Popular `HttpContext.Items["TenantId"]` (compatível com código atual)

**4.4 — Policies de autorização**
- Manter o sistema atual de permissões (`Permissions.Clientes.View`, etc.)
- Policies passam a ler roles do JWT em vez de tabela local

**4.5 — Validação de acesso ao módulo**
- Substituir `TemAcessoErp/Crm/Chat` por verificação de `modulos_habilitados` no JWT
- Middleware rejeita token se o módulo não estiver habilitado para a empresa

**4.6 — Multi-tenancy**
- Middleware existente (`TenantMiddleware`) continua funcionando
- Agora lê `tenant_id` do JWT validado em vez do token custom

**Entregável:** 3 APIs validando JWT do Keycloak, mantendo toda a lógica de negócio intacta.

---

### Fase 5 — Migração dos 3 frontends React

**Objetivo:** `erp-web`, `crm-web`, `ichat-web` usam Keycloak para login em vez do AuthContext atual.

#### Passos para cada frontend:

**5.1 — Instalar keycloak-js**
```bash
npm install keycloak-js
```

**5.2 — Criar KeycloakProvider**
```tsx
// src/application/contexts/KeycloakContext.tsx
import Keycloak from 'keycloak-js';

const keycloak = new Keycloak({
  url: 'https://auth.apli.indiolab.com.br',
  realm: 'indiolab',
  clientId: 'erp-web', // ou crm-web, ichat-web
});

// Provider que inicializa Keycloak com PKCE
// onRedirect = check-sso (SSO entre subdomínios)
// silent check via iframe
```

**5.3 — Substituir AuthContext**
- `useAuth()` passa a ler do Keycloak:
  - `user.name` → `keycloak.tokenParsed.name`
  - `user.email` → `keycloak.tokenParsed.email`
  - `user.permissions` → extraídas das roles do JWT
  - `hasPermission(perm)` → valida contra roles do client
- `login()` → `keycloak.login()`
- `logout()` → `keycloak.logout()`
- Auto-refresh de token (a cada 4min, antes dos 5min de expiração)

**5.4 — Deletar LoginPage**
- Fluxo novo: usuário acessa `/` → detecta sem token → redirect para Keycloak
- Keycloak mostra tela de login (tema custom)
- Depois do login, redirect de volta com `code`
- keycloak-js troca code por token automaticamente

**5.5 — Axios interceptor**
- Substituir leitura de `localStorage.getItem('accessToken')` por `keycloak.token`
- Em caso de 401: `keycloak.updateToken(30)` (renova se expira em menos de 30s)

**5.6 — SSO automático entre apps**
- Keycloak compartilha sessão via cookie HttpOnly no domínio `auth.apli.indiolab.com.br`
- Usuário loga no CRM → vai pro ERP → Keycloak detecta sessão → redirect transparente sem pedir senha
- `check-sso` via iframe silent

**Entregável:** 3 frontends autenticando via Keycloak, SSO funcionando entre os 3.

---

### Fase 6 — Criação do `admin-web` + `admin-api` (Painel Admin)

**Objetivo:** Painel customizado `admin.apli.indiolab.com.br` para Super Admin gerenciar tudo.

#### admin-api (novo repo)

**6.1 — Tecnologia**
- .NET 8 (mesmo stack dos outros backends)
- Autenticação: JWT do Keycloak com role `super-admin-sistema`

**6.2 — Funcionalidades (endpoints REST)**

**Gestão de empresas (tenants):**
- `POST /admin/empresas` — criar nova empresa
  - Cria schema no Postgres (`CreateTenantSchema`)
  - Cria group no Keycloak via Admin API
  - Configura atributos (tenantId, schemaName, planoAtivo, modulosHabilitados)
- `GET /admin/empresas` — listar todas
- `PUT /admin/empresas/{id}` — editar (nome, plano, módulos)
- `DELETE /admin/empresas/{id}` — desativar (soft delete)
- `POST /admin/empresas/{id}/migrate` — rodar migrations no schema

**Gestão de usuários:**
- `POST /admin/usuarios` — criar usuário
  - Cria user no Keycloak (via Admin API)
  - Atribui group (empresa) + roles por client
  - Cria registro de perfil no Postgres (dados específicos do negócio)
  - Envia email de boas-vindas com link de ativação
- `GET /admin/usuarios` — listar com filtros (por empresa, módulo, role)
- `PUT /admin/usuarios/{id}` — editar (nome, roles, módulos habilitados)
- `POST /admin/usuarios/{id}/reset-password` — forçar reset
- `POST /admin/usuarios/{id}/disable` — desativar
- `POST /admin/usuarios/{id}/enable` — reativar
- `POST /admin/usuarios/{id}/impersonate` — impersonar (admin vira o usuário)

**Gestão de roles e permissões:**
- `GET /admin/roles` — listar todas as roles dos 4 clients
- `POST /admin/roles` — criar role customizada
- `PUT /admin/roles/{id}/permissions` — editar permissões de uma role

**Gestão de domínios (public tenant):**
- CRUD completo de todos os domínios do sistema (o que hoje está no ERP, migra pro admin)
- Gêneros, TiposPessoa, Estados, Países, Cargos, Departamentos, etc.
- TODOS os domínios hoje em `Dominios` (100+ entidades)

**Gestão de instâncias WhatsApp (Evolution API):**
- `POST /admin/whatsapp/instancias` — criar nova instância
- `GET /admin/whatsapp/instancias` — listar
- `POST /admin/whatsapp/instancias/{id}/qrcode` — gerar QR Code
- `DELETE /admin/whatsapp/instancias/{id}`

**Audit log & observability:**
- `GET /admin/audit` — logs de todas as ações (Keycloak events + nossos logs)
- `GET /admin/audit/user/{id}` — histórico de 1 usuário
- `GET /admin/metrics` — métricas (usuários ativos, logins/dia, etc.)

**Configurações globais do sistema:**
- `GET/PUT /admin/config/smtp` — configuração de envio de email
- `GET/PUT /admin/config/storage` — S3/local para uploads
- `GET/PUT /admin/config/backup` — agendamento de backups

**SaaS features (futuro):**
- `POST /admin/planos` — criar plano (basic/pro/enterprise)
- `POST /admin/empresas/{id}/assinatura` — gerenciar assinatura
- `GET /admin/faturamento` — relatório financeiro

#### admin-web (novo repo)

**6.3 — Tecnologia**
- React 19 + TypeScript + Vite + MUI 7 (mesmo stack)
- keycloak-js para autenticação
- Somente acessível por usuários com role `super-admin-sistema`

**6.4 — Páginas**
- Dashboard com métricas globais
- Gestão de empresas (CRUD)
- Gestão de usuários (CRUD, filtros avançados)
- Gestão de roles e permissões
- Gestão de domínios (migrado do ERP)
- Configuração WhatsApp / Evolution API
- Audit trail
- Configurações do sistema
- Impersonation (botão "entrar como")

**Entregável:** Painel admin completo, substituindo telas de configuração espalhadas no ERP.

---

### Fase 7 — Remoção de duplicidades do ERP

**Objetivo:** Agora que o admin-web tem gestão centralizada, remover essas telas do ERP.

#### Passos:
1. Remover páginas de **Usuários** do ERP (agora só no admin)
2. Remover páginas de **Empresas** do ERP (agora só no admin)
3. Remover páginas de **Roles** do ERP (agora só no admin)
4. Remover páginas de **Domínios** do ERP (agora só no admin)
5. Remover controladores correspondentes do `erp-api`
6. ERP fica focado em: Cadastros operacionais (Clientes, Fornecedores, Funcionários, Produtos), Compras, Vendas, Estoque, Financeiro, Fiscal, Produção

**Decisão importante:** usuários normais do ERP **não precisam mais** de acesso a essas configurações. Se admin da empresa precisa gerenciar seus usuários (delegação), cria uma role especial `admin-empresa` que permite acessar o admin-web com escopo limitado (ver só a própria empresa).

**Entregável:** ERP limpo, focado em operação. Admin centralizado no `admin-web`.

---

### Fase 8 — Tema customizado Indio Lab no Keycloak

**Objetivo:** Tela de login do Keycloak com branding Indio Lab.

#### Passos:
1. Criar tema `indiolab/` em `/opt/indiolab/keycloak/themes/indiolab/`
2. Estrutura:
   ```
   indiolab/
   ├── login/
   │   ├── theme.properties
   │   ├── template.ftl
   │   ├── login.ftl
   │   ├── resources/
   │   │   ├── css/login.css
   │   │   ├── img/logo.png
   │   │   └── img/background.jpg
   ├── account/
   ├── email/
   │   └── messages/ (pt-BR)
   ```
3. Montar volume no container Keycloak: `/opt/indiolab/keycloak/themes:/opt/keycloak/themes`
4. Ativar tema no realm: Admin → Realm Settings → Themes → Login Theme: `indiolab`

**Entregável:** Tela de login com logo, cores, background Indio Lab. Emails com template próprio.

---

### Fase 9 — Testes e Go-Live

#### 9.1 — Testes em staging
- Usar tenant de teste `empresa-test`
- 1 usuário de cada role
- Testar fluxo completo: login → usar cada app → logout
- Testar SSO (login em 1 app → acesso automático aos outros)
- Testar reset de senha
- Testar 2FA
- Testar impersonation (admin → usuário)

#### 9.2 — Plano de Go-Live
1. **Janela de manutenção** (aviso 48h antes aos usuários)
2. **Backup completo** do Postgres antes de tudo
3. **Deploy sequencial:**
   - Keycloak (já deve estar rodando da fase 1)
   - Importar usuários (fase 3)
   - Deploy do `admin-api` + `admin-web` novos
   - Deploy dos 3 backends atualizados (erp-api, crm-api, ichat-api)
   - Deploy dos 3 frontends atualizados (erp-web, crm-web, ichat-web)
4. **Smoke test** com cada role de cada empresa
5. **Monitoramento** intensivo nas primeiras 24h

#### 9.3 — Rollback plan
- Se falhar: reverter containers para versão anterior (tag `:rollback`)
- Banco Postgres não é tocado na migração (exceto importação — reversível)
- Keycloak fica rodando sem afetar auth antigo (coexistência durante período de observação)

**Entregável:** Sistema em produção, 200 usuários usando Keycloak, 3 apps + admin funcionando.

---

## Estimativa de esforço

| Fase | Descrição | Horas | Dependências |
|------|-----------|-------|--------------|
| 1 | Deploy Keycloak | 4h | DNS pronto |
| 2 | Config realm/clients/roles/groups | 8h | Fase 1 |
| 3 | Migração de 200 usuários | 6h | Fase 2 |
| 4 | Migração de 3 backends .NET | 12h | Fase 3 |
| 5 | Migração de 3 frontends React | 12h | Fase 4 |
| 6 | Criação admin-api + admin-web | 40h | Fase 2 |
| 7 | Limpeza do ERP (remove admin pages) | 8h | Fase 6 |
| 8 | Tema customizado Keycloak | 6h | Fase 2 |
| 9 | Testes + Go-Live | 8h | Todas |
| **Total** | | **104h** | ~3 semanas |

---

## Riscos e mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| Hash de senhas incompatível na importação | Alta | Médio | Forçar reset de senha no primeiro login |
| Curva de aprendizado OIDC | Alta | Médio | Estudar docs antes das fases 4-5 |
| Keycloak não aceita alguma customização | Média | Alto | Sempre ter plano B (extension ou admin API) |
| 2FA bloqueia usuários em produção | Média | Alto | Deixar 2FA opcional na primeira fase, obrigatório depois |
| Tema custom quebra em update do Keycloak | Média | Baixo | Lock na versão 26.6.0, atualização manual |
| Admin API do Keycloak muda | Baixa | Alto | Wrapper no admin-api isola as chamadas |
| Perder acesso ao admin do Keycloak | Baixa | Crítico | Senha de bootstrap em gerenciador de senhas + 2 pessoas sabem |

---

## Benefícios esperados

### Imediatos (após go-live)
- ✅ SSO real entre os 3 apps (login 1x)
- ✅ Reset de senha self-service (elimina 80% dos tickets)
- ✅ Brute force protection
- ✅ Audit trail completo
- ✅ Admin centralizado com UX própria
- ✅ 6 empresas como groups isolados

### Curto prazo (3-6 meses)
- 🎯 2FA para usuários sensíveis (financeiro, fiscal)
- 🎯 Compliance LGPD documentada (argumento de venda)
- 🎯 Delegação de admin por empresa
- 🎯 Themes por empresa (white-label)

### Médio prazo (6-12 meses)
- 🚀 SaaS multi-tenant com onboarding self-service
- 🚀 Planos de assinatura integrados
- 🚀 API pública para integrações
- 🚀 SSO com AD/Google/Microsoft (quando cliente pedir)
- 🚀 Certificações (ISO 27001, SOC 2) viáveis

---

## Próximos passos

1. ✅ DNS `admin.apli.indiolab.com.br` + `auth.apli.indiolab.com.br` no AD (em andamento)
2. ⏳ Começar Fase 1 (deploy Keycloak)
3. ⏳ Aprovar este plano
4. ⏳ Definir janela de go-live
5. ⏳ Comunicar usuários sobre mudança (reset de senha)
