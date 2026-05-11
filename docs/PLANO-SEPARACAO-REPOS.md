# Plano de Separação — OpticalCore → ERP + CRM + iChat

> Data: 2026-04-11
> Decisões confirmadas pelo Rubens

---

## Decisões Finais

| Item | Decisão |
|------|---------|
| **Repos** | 8 repos sob `carrilhorubens` no GitHub |
| **Domínios** | `erp.apli.indiolab.com.br`, `crm.apli.indiolab.com.br`, `chat.apli.indiolab.com.br` |
| **APIs** | Subpath: `erp.apli.indiolab.com.br/api`, `crm.apli.indiolab.com.br/api`, `chat.apli.indiolab.com.br/api` |
| **SSL** | Certificado wildcard self-signed `*.apli.indiolab.com.br` (válido até 2036) |
| **DNS** | Zona `apli.indiolab.com.br` no AD Microsoft (sem conflito com site público) |
| **Banco** | Mesmo PostgreSQL, mesmo schema-per-tenant (compartilhado) |
| **Auth** | SSO — ERP é o Identity Provider, CRM e iChat validam o JWT do ERP |
| **Servidor** | `10.1.56.56` (formatado, limpo) — SSH porta 2223, user `developer` |
| **Libs** | Pacotes compartilhados: NuGet (`IndioLab.Shared`) + npm (`@indiolab/shared-ui`) |
| **GitHub** | Perfil pessoal `carrilhorubens` |

---

## Repositórios

| # | Repo | Descrição | Domínio |
|---|------|-----------|---------|
| 1 | `indiolab-shared-api` | Lib C# compartilhada (Identity, Multi-Tenancy, BaseDominio, Pessoa, DTOs) | — |
| 2 | `indiolab-shared-ui` | Lib React compartilhada (Tema MUI, StyledDialog, FormSection, DominioSelect, hooks) | — |
| 3 | `erp-api` | Backend ERP (Cadastros, Estoque, Compras, Vendas, Fiscal, Financeiro, Produção) | `erp.apli.indiolab.com.br/api` |
| 4 | `erp-web` | Frontend ERP | `erp.apli.indiolab.com.br` |
| 5 | `crm-api` | Backend CRM (Leads, Oportunidades, Pipeline, Visitas, Despesas) | `crm.apli.indiolab.com.br/api` |
| 6 | `crm-web` | Frontend CRM | `crm.apli.indiolab.com.br` |
| 7 | `ichat-api` | Backend iChat (Chat, WhatsApp, SignalR, Evolution API) | `chat.apli.indiolab.com.br/api` |
| 8 | `ichat-web` | Frontend iChat | `chat.apli.indiolab.com.br` |

---

## Fases de Execução

### Fase 1 — Servidor de Produção (10.1.56.56)

Pré-requisito para tudo. Servidor está formatado, SSH funcionando.

- [ ] 1.1 Instalar Docker + Docker Compose
- [ ] 1.2 Instalar Nginx
- [ ] 1.3 Instalar Certbot (backup — não usado, rede interna)
- [ ] 1.4 Configurar PostgreSQL (container Docker)
- [ ] 1.5 Configurar DNS: zona `apli.indiolab.com.br` no AD Microsoft (registros A: erp, crm, chat → 10.1.56.56)
- [ ] 1.6 Configurar Nginx reverse proxy (3 subdomínios → 6 containers)
- [ ] 1.7 Gerar certificado SSL wildcard self-signed `*.apli.indiolab.com.br` (válido 10 anos)
- [ ] 1.8 Configurar firewall (ufw)

### Fase 2 — Libs Compartilhadas

Extrair código comum antes de criar os repos de módulo.

#### 2A. `indiolab-shared-api` (NuGet)

Código compartilhado entre os 3 backends:

- [ ] 2A.1 Criar repo e estrutura do projeto
- [ ] 2A.2 Extrair entidades base: `BaseDominio`, `Pessoa`, `Endereco`, `Contato`, `Company`
- [ ] 2A.3 Extrair Identity: `ApplicationUser`, `ApplicationRole`, JWT config, token service
- [ ] 2A.4 Extrair Multi-Tenancy: `ITenantEntity`, `TenantMiddleware`, schema resolution
- [ ] 2A.5 Extrair interfaces compartilhadas: `IRepository<T>`, `IUnitOfWork`
- [ ] 2A.6 Extrair Permissions base: constants, `PermissionAuthorizationHandler`
- [ ] 2A.7 Extrair DTOs compartilhados: `PagedResult<T>`, `ErrorResponse`, etc.
- [ ] 2A.8 Extrair Extensions: `QueryableExtensions` (ApplySort, ApplyFilter)
- [ ] 2A.9 Publicar como NuGet package (GitHub Packages ou feed privado)

#### 2B. `indiolab-shared-ui` (npm)

Código compartilhado entre os 3 frontends:

- [ ] 2B.1 Criar repo e estrutura do projeto
- [ ] 2B.2 Extrair tema MUI (`theme.ts`)
- [ ] 2B.3 Extrair componentes: `StyledDialog`, `FormSection`, `ConfirmDialog`, `EmptyState`, `ErrorState`
- [ ] 2B.4 Extrair `DialogContext` + `useDialog`
- [ ] 2B.5 Extrair `DominioSelect` + variantes (`TipoPessoaSelect`, `GeneroSelect`, etc.)
- [ ] 2B.6 Extrair hooks: `useDebounce`, `useDominio`, `useAuth`, `usePermissions`
- [ ] 2B.7 Extrair `api.ts` (Axios instance com interceptors JWT + tenant)
- [ ] 2B.8 Extrair componentes de endereço/contato: `EnderecosTab`, `ContatosTab`
- [ ] 2B.9 Extrair tipos compartilhados: `PagedResult`, `DominioDto`, `PessoaDto`
- [ ] 2B.10 Publicar como npm package (GitHub Packages ou registry privado)

### Fase 3 — Repos de Módulo (Backend)

#### 3A. `erp-api`

- [ ] 3A.1 Criar repo, referenciar `IndioLab.Shared` NuGet
- [ ] 3A.2 Migrar Domain: Produto, Compras, Estoque, Vendas, Producao, Financeiro, Fiscal
- [ ] 3A.3 Migrar Application: Features de cada módulo ERP (Commands, Queries, Handlers)
- [ ] 3A.4 Migrar Infrastructure: DbContext (apenas entidades ERP), migrations, seeds
- [ ] 3A.5 Migrar API: Controllers ERP + Auth endpoints (ERP é o Identity Provider)
- [ ] 3A.6 Configurar SSO: ERP emite JWT, expõe endpoints de validação
- [ ] 3A.7 Dockerfile + docker-compose.yml
- [ ] 3A.8 GitHub Actions CI/CD

#### 3B. `crm-api`

- [ ] 3B.1 Criar repo, referenciar `IndioLab.Shared` NuGet
- [ ] 3B.2 Migrar Domain: Lead, Oportunidade, Visita, Despesa, Pipeline
- [ ] 3B.3 Migrar Application: Features CRM
- [ ] 3B.4 Migrar Infrastructure: DbContext (entidades CRM + leitura de Clientes/Pessoas)
- [ ] 3B.5 Migrar API: Controllers CRM
- [ ] 3B.6 Configurar SSO: validar JWT emitido pelo ERP
- [ ] 3B.7 Dockerfile + docker-compose.yml
- [ ] 3B.8 GitHub Actions CI/CD

#### 3C. `ichat-api`

- [ ] 3C.1 Criar repo, referenciar `IndioLab.Shared` NuGet
- [ ] 3C.2 Migrar Domain: Chat, Mensagem, WhatsApp, Grupo
- [ ] 3C.3 Migrar Application: Features Chat/WhatsApp
- [ ] 3C.4 Migrar Infrastructure: DbContext (entidades Chat), SignalR hubs
- [ ] 3C.5 Migrar API: Controllers Chat + WhatsApp webhooks
- [ ] 3C.6 Configurar SSO: validar JWT emitido pelo ERP
- [ ] 3C.7 Configurar Evolution API integration
- [ ] 3C.8 Dockerfile + docker-compose.yml
- [ ] 3C.9 GitHub Actions CI/CD

### Fase 4 — Repos de Módulo (Frontend)

#### 4A. `erp-web`

- [ ] 4A.1 Criar repo, instalar `@indiolab/shared-ui`
- [ ] 4A.2 Migrar páginas ERP: Dashboard, Cadastros, Estoque, Compras, Vendas, Fiscal, Financeiro, Produção, Domínios, Biblioteca
- [ ] 4A.3 Migrar páginas de config: Usuários, Roles, Empresas
- [ ] 4A.4 Configurar Sidebar/rotas (apenas módulos ERP)
- [ ] 4A.5 Configurar navegação entre apps (links para CRM e iChat)
- [ ] 4A.6 Login page + SSO (ERP é o auth provider)
- [ ] 4A.7 Vite config + Dockerfile
- [ ] 4A.8 GitHub Actions CI/CD

#### 4B. `crm-web`

- [ ] 4B.1 Criar repo, instalar `@indiolab/shared-ui`
- [ ] 4B.2 Migrar páginas CRM: Pipeline, Leads, Oportunidades, Visitas, Despesas, KPIs
- [ ] 4B.3 Configurar Sidebar/rotas (apenas módulos CRM)
- [ ] 4B.4 Configurar navegação entre apps
- [ ] 4B.5 Login via SSO (redireciona ao ERP para autenticar)
- [ ] 4B.6 Vite config + Dockerfile
- [ ] 4B.7 GitHub Actions CI/CD

#### 4C. `ichat-web`

- [ ] 4C.1 Criar repo, instalar `@indiolab/shared-ui`
- [ ] 4C.2 Migrar páginas iChat: Chat, WhatsApp, Configurações de Chat, Grupos
- [ ] 4C.3 Configurar Sidebar/rotas (apenas módulos iChat)
- [ ] 4C.4 Configurar navegação entre apps
- [ ] 4C.5 Login via SSO (redireciona ao ERP para autenticar)
- [ ] 4C.6 Configurar SignalR client
- [ ] 4C.7 Vite config + Dockerfile
- [ ] 4C.8 GitHub Actions CI/CD

### Fase 5 — Deploy e Go-Live

- [ ] 5.1 Deploy dos 6 containers no servidor
- [ ] 5.2 Restaurar banco de dados PostgreSQL (ou migrar do backup)
- [ ] 5.3 Testar SSO entre os 3 apps
- [ ] 5.4 Testar navegação cross-app
- [ ] 5.5 Testar todas as funcionalidades ERP
- [ ] 5.6 Testar todas as funcionalidades CRM
- [ ] 5.7 Testar todas as funcionalidades iChat + WhatsApp
- [ ] 5.8 Configurar Evolution API no novo ambiente
- [ ] 5.9 Smoke test final
- [ ] 5.10 Desativar repo monolito (`opticalcore.com.br` → archive)

---

## Arquitetura SSO

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   erp-web       │     │   crm-web       │     │   ichat-web     │
│ erp.app.indiolab.   │     │ crm.app.indiolab.   │     │ chat.app.indiolab.  │
└────────┬────────┘     └────────┬────────┘     └────────┬────────┘
         │                       │                       │
         │ JWT                   │ JWT                   │ JWT
         ▼                       ▼                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   erp-api       │     │   crm-api       │     │   ichat-api     │
│ Identity Provider│    │ JWT Validator    │     │ JWT Validator   │
│ Emite tokens    │     │ Valida tokens   │     │ Valida tokens   │
└────────┬────────┘     └────────┬────────┘     └────────┬────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 ▼
                    ┌─────────────────────┐
                    │    PostgreSQL        │
                    │  (schema-per-tenant) │
                    └─────────────────────┘
```

**Fluxo SSO:**
1. Usuário acessa `crm.apli.indiolab.com.br`
2. Não tem token → redireciona para `erp.apli.indiolab.com.br/login?redirect=crm.apli.indiolab.com.br`
3. Login no ERP → JWT emitido com `iss: erp.apli.indiolab.com.br`, `aud: [erp, crm, chat]`
4. Token armazenado em cookie `HttpOnly` com `domain=.apli.indiolab.com.br` (compartilhado entre subdomínios)
5. Redirect de volta para `crm.apli.indiolab.com.br` → token já disponível via cookie
6. CRM API valida o JWT usando a mesma signing key do ERP

---

## Containers Docker (Produção)

```yaml
# docker-compose.prod.yml (servidor 10.1.56.56)
services:
  postgres:
    image: postgres:15
    ports: ["5432:5432"]
    volumes: [pgdata:/var/lib/postgresql/data]

  erp-api:
    image: carrilhorubens/erp-api:latest
    ports: ["5050:8080"]
    environment:
      - ConnectionStrings__DefaultConnection=...
      - JWT__Secret=...

  erp-web:
    image: carrilhorubens/erp-web:latest
    ports: ["3001:80"]

  crm-api:
    image: carrilhorubens/crm-api:latest
    ports: ["5051:8080"]

  crm-web:
    image: carrilhorubens/crm-web:latest
    ports: ["3002:80"]

  ichat-api:
    image: carrilhorubens/ichat-api:latest
    ports: ["5052:8080"]

  ichat-web:
    image: carrilhorubens/ichat-web:latest
    ports: ["3003:80"]

  evolution-api:
    image: atendai/evolution-api:v2.3
    ports: ["8080:8080"]
```

---

## Nginx Config (Produção)

```nginx
# /etc/nginx/sites-available/erp.apli.indiolab.com.br
server {
    listen 443 ssl;
    server_name erp.apli.indiolab.com.br;

    ssl_certificate /etc/nginx/ssl/apli.indiolab.com.br.crt;
    ssl_certificate_key /etc/nginx/ssl/apli.indiolab.com.br.key;

    location /api/ {
        proxy_pass http://localhost:5050/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location / {
        proxy_pass http://localhost:3001/;
    }
}

# Repetir para crm.apli.indiolab.com.br (:5051/:3002) e chat.apli.indiolab.com.br (:5052/:3003)
```

---

## CI/CD — Pipelines de Deploy e Rollback (GitHub Actions)

Cada repo possui `.github/workflows/deploy.yml` com deploy automático e rollback.

### Comportamento

| Trigger | Ação |
|---------|------|
| Push na `main` | Deploy automático no servidor de produção |
| Workflow Dispatch → `deploy` | Deploy manual (botão no GitHub Actions) |
| Workflow Dispatch → `rollback` | Rollback para a versão anterior |
| Health check falha (container não sobe em 5s) | Auto-rollback automático |

### Versionamento de imagens

Antes de cada deploy, a imagem atual é tagueada como `:rollback`. Assim sempre existe uma versão anterior para reverter:

```
imagem:latest   → versão nova (deploy atual)
imagem:rollback → versão anterior (para reverter)
```

### Fluxo de deploy

```
Push main → GitHub Actions → SSH no servidor (10.1.56.56:2223)
  → rsync do código → docker build → docker stop old → docker run new
  → health check (5s) → OK ✅ ou auto-rollback ❌
```

### Containers e portas

| Repo | Container | Porta | Domínio |
|------|-----------|-------|---------|
| `erp-api` | `indiolab-erp-api` | `5050:8080` | `erp.apli.indiolab.com.br/api` |
| `erp-web` | `indiolab-erp-web` | `3001:80` | `erp.apli.indiolab.com.br` |
| `crm-api` | `indiolab-crm-api` | `5051:8080` | `crm.apli.indiolab.com.br/api` |
| `crm-web` | `indiolab-crm-web` | `3002:80` | `crm.apli.indiolab.com.br` |
| `ichat-api` | `indiolab-ichat-api` | `5052:8080` | `chat.apli.indiolab.com.br/api` |
| `ichat-web` | `indiolab-ichat-web` | `3003:80` | `chat.apli.indiolab.com.br` |

### Variáveis de ambiente

Carregadas de `/opt/indiolab/.env` no servidor:

```env
# PostgreSQL
POSTGRES_PASSWORD=OpticalCore2026!
ConnectionStrings__DefaultConnection=Host=localhost;Port=5432;Database=opticalcore;Username=opticalcore;Password=OpticalCore2026!

# JWT (SSO — mesmo secret para os 3 backends)
JWT__Secret=TROCAR_POR_CHAVE_SEGURA
JWT__Issuer=erp.apli.indiolab.com.br
JWT__Audience=erp,crm,chat

# Evolution API (WhatsApp)
EVOLUTION_API_KEY=indiolab-evolution-2026
```

### Pré-requisitos para funcionar

1. **GitHub Secret `SSH_PRIVATE_KEY`** — adicionar em cada repo (Settings → Secrets → Actions). É o conteúdo de `~/.ssh/id_developer` (chave privada)
2. **Diretórios no servidor** — `/opt/indiolab/<container>/source/` para cada container
3. **Arquivo `.env`** no servidor em `/opt/indiolab/.env` com as variáveis acima

### Como fazer rollback manual

1. Ir no repo no GitHub → tab **Actions**
2. Clicar em **Deploy to Production** (workflow)
3. Clicar **Run workflow**
4. Selecionar `rollback` no dropdown
5. Clicar **Run workflow**

---

## Ordem de Prioridade

1. ~~**Fase 1** (Servidor)~~ ✅ Concluída (2026-04-11)
2. ~~**Fase 2** (Libs)~~ ✅ Concluída (2026-04-11)
3. ~~**Fase 3 + 4** (Repos)~~ ✅ Concluída (2026-04-11)
4. **Fase 5** (Deploy) — configurar secrets, .env, testar pipelines
