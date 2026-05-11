# Auditoria de Segurança e Arquitetura — apli.indiolab.com.br

**Data:** 2026-04-30
**Escopo:** monorepo completo (4 apps web + 4 APIs + shared libs + Keycloak theme)

> **Status das correções críticas (2026-04-30):**
> - ✅ **C1 aplicado** — `RequireSetupTokenFilter` criado nas 3 APIs (chat/crm/erp); endpoints `[AllowAnonymous]` do `AdminController` agora exigem header `X-Setup-Token` (fail-closed se `Admin:SetupToken` não estiver configurado).
> - ✅ **C2 aplicado** — `WhatsAppWebhookController` valida header `apikey` contra `WhatsApp:WebhookApiKey` em tempo constante; rejeita 503 se não configurado.
> - ⚠️ **C3 era falso positivo** — `IsValidSchemaName()` (regex `^\d{11,14}$`) já gate `CreateSchemaAsync`, `DropSchemaAsync` e `MigrateSchemaAsync` em todos os 3 backends. Verificado por inspeção. Permanece como observação de hardening.

---

## 1. Estrutura do Projeto

Monorepo com 4 domínios públicos, cada um com `*-api` (.NET) + `*-web` (React/Vite):

```
apli.indiolab.com.br/
├── admin.apli.indiolab.com.br/   (admin-api .NET 10 + admin-web React)
├── erp.apli.indiolab.com.br/     (erp-api    .NET 10 + erp-web    React)
├── crm.apli.indiolab.com.br/     (crm-api    .NET 10 + crm-web    React)
├── chat.apli.indiolab.com.br/    (ichat-api  .NET 10 + ichat-web  React)
├── indiolab-shared-api/          (libs C# compartilhadas: Domain, Application, Infrastructure)
├── indiolab-shared-ui/           (componentes React compartilhados — MUI 7)
├── keycloak-theme/               (tema Keycloakify, .git aninhado — possível submódulo perdido)
├── docs/                         (29 documentos de arquitetura/decisões)
└── .github/workflows/deploy.yml  (CI → self-hosted runner em produção via SSH)
```

APIs seguem **Clean Architecture + CQRS (MediatR) + DDD** e referenciam a shared lib via path relativo (resolvido com symlink no Dockerfile). Apps front seguem padrão **feature-based** com `application/`, `domain/`, `infrastructure/` em cada um.

`.git` aninhado em `keycloak-theme/` indica submódulo não declarado — investigar antes de merges.

---

## 2. Dependências (principais)

| Camada | Stack | Versão |
|--------|-------|--------|
| Backend | .NET, ASP.NET Core, EF Core, Npgsql | 10.x (com fallback condicional 8.x) |
| Auth | `Microsoft.AspNetCore.Authentication.JwtBearer` 10.x, `System.IdentityModel.Tokens.Jwt` 8.x | OK |
| Frontend | React 19, Vite, MUI 7, axios, `keycloak-js` | recente |
| Banco | PostgreSQL (schema-per-tenant) | — |
| IdP | Keycloak (realm `indiolab`, host `auth.apli.indiolab.com.br`) | — |
| CI | GitHub Actions + self-hosted runner em prod | — |

---

## 3. Como funciona a Autenticação

**Fase atual: Keycloak (OIDC + PKCE)** — migração concluída. Fluxo:

1. App front instancia `Keycloak({url, realm, clientId})`, expõe via `window.__keycloak` para o axios interceptor.
2. Sem token → `keycloak.login()` redireciona para `https://auth.apli.indiolab.com.br/realms/indiolab`.
3. IdP autentica e devolve JWT + refresh token.
4. Axios interceptor chama `keycloak.updateToken(30)` antes de cada request, anexa `Authorization: Bearer <token>`.
5. Em 401, tenta `updateToken(-1)`; se falhar, dispara `keycloak.login()`.
6. Backend valida JWT via `AddJwtBearer` com `Authority = Keycloak:Authority`, `ValidateIssuer/Audience/Lifetime = true`, `RequireHttpsMetadata = !Keycloak:AllowInsecureHttp`.
7. Roles vêm de `resource_access.{clientId}.roles` (claim Keycloak padrão) + claim `roles`.
8. Autorização granular via `[Authorize(Policy = "Permissions.X")]` resolvido por `PermissionPolicyProvider` + `PermissionAuthorizationHandler` consultando `IRolePermissionProvider` (mapa role → permissões em memória, populado de `BaseRolePermissionProvider` + `DbBackedRolePermissionProvider`).

**Resíduo legado preocupante:** erp-web, crm-web e ichat-web ainda contêm `authService.ts` chamando `/auth/login`, `/auth/refresh`, `/auth/logout`, `/auth/me`, `/auth/switch-tenant`, `/auth/permissions` em paralelo ao fluxo Keycloak. Há também `AuthController` com `[AllowAnonymous]` em `/auth/login` e `/auth/refresh`. **Esse caminho legacy ainda é um vetor ativo** — login com senha + JWT próprio coexiste com Keycloak. Decidir se deprecia ou se mantém como break-glass.

---

## 4. Frontend ↔ Backend

- Axios instance única por app em `src/infrastructure/api.ts`, baseURL = `import.meta.env.VITE_API_URL` (build-time, embutido no bundle).
- Interceptor request: pega token de `window.__keycloak`, chama `updateToken(30)`, anexa Bearer.
- Interceptor response: 401 → tenta refresh, falha → redireciona ao Keycloak.
- Multi-tenant: `CompanyId` resolvido no backend via `TenantMiddleware` (claim do JWT/empresa ativa) → `ITenantService.TenantId` → `EnsureTenantContextAsync` seta `search_path` para o schema do tenant.
- Webhooks externos (Evolution API): rota `/api/whatsapp/webhook/{instancia}` é exceção isenta no `TenantMiddleware` e marcada `[AllowAnonymous]`.

---

## 5. Vulnerabilidades & Riscos — por Prioridade

### 🔴 CRÍTICO

**C1. ✅ AdminController endpoints `[AllowAnonymous]` agora protegidos por X-Setup-Token**
Arquivos: `*/Controllers/AdminController.cs` em chat/crm/erp APIs.
- Endpoints afetados: `database/initialize`, `database/status`, `schema/migrate-all-public`, `permissions/sync-admin`, `permissions/list`, `seed/all`.

**Correção aplicada (2026-04-30):**
- Novo filter `OpticalCore.API.Filters.RequireSetupTokenFilter` em cada API (`*/Filters/RequireSetupTokenFilter.cs`) — `IAuthorizationFilter` que compara header `X-Setup-Token` contra `Configuration["Admin:SetupToken"]` em tempo constante.
- Fail-closed: se `Admin:SetupToken` não estiver definido, retorna 503.
- Endpoints originais mantêm `[AllowAnonymous]` (para bypassar `[Authorize(Roles="Root,Admin")]` herdado da classe) + `[ServiceFilter(typeof(RequireSetupTokenFilter))]`.
- Filter registrado via `AddScoped` em cada `Program.cs` logo após `AddControllers`.

**Operação em produção:** definir variável de ambiente `Admin__SetupToken=<valor-secreto>` no servidor antes do bootstrap; remover/rotacionar após uso.

**C2. ✅ Webhook WhatsApp agora valida `apikey`**
`WhatsAppWebhookController.cs` no `chat-api`.

**Correção aplicada (2026-04-30):**
- Método privado `ValidateApiKey(string?)` injeta `IConfiguration`, lê `WhatsApp:WebhookApiKey` e compara em tempo constante (`FixedTimeEquals`).
- Chamado no início de `Webhook(...)` e `WebhookGlobal(...)` — short-circuit antes de qualquer broadcast SignalR ou processamento de payload.
- Fail-closed: se `WhatsApp:WebhookApiKey` não estiver definido, retorna 503; se header `apikey` ausente ou diferente, retorna 401.

**Operação em produção:** definir `WhatsApp__WebhookApiKey=<valor>` em ambos os lados (instância Evolution + chat-api).

**Próximo passo recomendado:** trocar API key por HMAC-SHA256 do payload — protege contra replay e vazamento da key em logs.

**C3. ⚠️ Falso positivo — `TenantSchemaService` já valida nomes de schema**
Verificação por inspeção (chat/crm/erp): todos os caminhos públicos (`CreateSchemaAsync`, `DropSchemaAsync`, `MigrateSchemaAsync`, `SchemaExistsAsync`) chamam `IsValidSchemaName(schemaName)` no início, que aplica regex `^\d{11,14}$` (CNPJ ou CPF). Nomes que não casarem com esse padrão são rejeitados com `ArgumentException` antes de qualquer `ExecuteSqlRawAsync`. **Sem injeção possível pelo formato atual.**

**Hardening sugerido (não-bloqueante):** mover a validação para o método público da interface (`ITenantSchemaService`) para impedir bypass por implementações futuras, e adicionar testes unitários cobrindo nomes maliciosos (`'; DROP DATABASE--`, schemaName com escape sequences).

### 🟠 ALTO

**H1. Duas pilhas de autenticação convivendo**
- Keycloak (PKCE, JWT remoto) ✓
- AuthController legado com `/auth/login` e `/auth/refresh` ainda `[AllowAnonymous]` — usa `PasswordHasher` próprio, JWT próprio, refresh tokens locais.
Risco: se o legado emite tokens válidos pela mesma `TokenValidationParameters` que valida Keycloak, há dois issuers. Confirmar se está desativado em prod ou removê-lo.

**H2. CORS hardcoded no código**
`Program.cs` de cada API: `WithOrigins("http://localhost:3000", "http://localhost:5173", "http://10.1.56.56")`. Origens de dev e um IP de intranet (`10.1.56.56`) ficam ativos em produção. Se a API estiver pública, qualquer atacante na mesma LAN pode usar XHR cross-origin.
**Ação:** Mover lista para `appsettings.{env}.json` e por ambiente; remover `localhost` em produção.

**H3. `AllowInsecureHttp` configurável**
`options.RequireHttpsMetadata = !configuration.GetValue<bool>("Keycloak:AllowInsecureHttp")` — flag existe. Se ativada em produção (acidente de copy-paste de dev), JWT é validado sobre HTTP — possibilita MitM e roubo de JWKS.
**Ação:** Forçar `RequireHttpsMetadata = true` em prod via `IHostEnvironment.IsProduction()`, ignorando o flag.

**H4. CI desativa rigor de tipos e build**
`.github/workflows/deploy.yml`: `npx tsc --noEmit || true` (~726 erros TS pré-existentes ignorados); `dotnet build --warnaserror:false`. Bugs de tipo não barram deploy.
**Ação:** Plano de redução incremental (delta-tsc), travar warnings novos como erro.

**H5. Self-hosted runner em produção**
Job `deploy` roda em `self-hosted, linux, production` e executa `/home/developer/deploy.sh` arbitrário. Comprometimento do runner = RCE direto em prod. Não vi assinatura/verificação de commits.
**Ação:** Runner ephemeral isolado, deploy via OIDC para cloud provider em vez de SSH.

### 🟡 MÉDIO

**M1. Rate limiter existe, mas não vi escopo aplicado a `/auth/*`**
`AddRateLimiter` registrado em todas as APIs, `app.UseRateLimiter()` chamado, mas a política aplicada precisa ser conferida — endpoints de login/refresh são alvos clássicos de brute-force/credential-stuffing.
**Ação:** Política específica `auth-policy` com janela curta + 5 tentativas/min por IP em `/auth/*` (mesmo após depreciar legado, manter para webhook).

**M2. `MigrateAllSchemasAsync` itera todos os tenants em uma única request**
Mesmo após proteger o endpoint, executar migration em N schemas dentro de um HTTP request é frágil (timeout, lock contention, rollback parcial).
**Ação:** Mover para job em background (Hangfire/Quartz) ou comando CLI.

**M3. `localStorage` para refresh token no caminho legado**
`authService.ts` retorna `LoginResponse` com `accessToken`/`refreshToken` que o `AuthContext` legado persiste. Vetor para XSS — qualquer script malicioso lê e exfiltra.
**Ação:** Concluir migração para Keycloak e remover authService legacy.

**M4. `VITE_API_URL` embutido no bundle**
Não é vulnerabilidade por si só, mas qualquer `VITE_*` adicionado por engano vaza para o cliente. CRM já documentou que migrou Google Maps API key para endpoint runtime — bom precedente. Auditar `.env*` antes de cada release.

**M5. Webhook SignalR broadcast `Clients.All`**
`WhatsAppMessageReceived` é enviado para `Clients.All` (todos os usuários online de qualquer tenant), com filtragem provável no front. Vazamento cross-tenant possível se o front for comprometido ou tiver bug.
**Ação:** Usar `Clients.Group(tenantId)` no servidor.

### 🟢 BAIXO

- **L1.** `keycloak-theme/.git` aninhado — clarificar se é submódulo, repo separado, ou erro.
- **L2.** `CLAUDE 2.md` duplicado no root — provável artefato do macOS, remover.
- **L3.** `.DS_Store` aparece no `git status` — adicionar regra global no `.gitignore` (`**/.DS_Store`).
- **L4.** `MSBuildTemp/` e `node-compile-cache/` no root — caches de build commitados; mover para `.gitignore`.
- **L5.** `.env.production.example` ainda menciona `JWT_SECRET`, `JWT_ISSUER`, `JWT_AUDIENCE` (modelo pré-Keycloak). Atualizar para refletir vars do Keycloak.
- **L6.** Ausência de testes automatizados visíveis em CI (job `Tests` no workflow precisa ser confirmado com cobertura).

---

## 6. Resumo de Ações Recomendadas (ordem)

1. **Hoje:** remover `[AllowAnonymous]` do `AdminController`; validar `apiKey` no `WhatsAppWebhookController`.
2. **Esta semana:** validar nome de schema antes de `ExecuteSqlRawAsync` em todos os caminhos; mover CORS origins para `appsettings`; forçar `RequireHttpsMetadata` em prod.
3. **Próximo sprint:** depreciar `AuthController` legado e `authService.ts`; aplicar rate limit dedicado em `/auth/*`; migrar `MigrateAllSchemas` para job background; trocar `Clients.All` por `Clients.Group`.
4. **Roadmap:** runner ephemeral em CI; reduzir 726 erros TS; remover `keycloak-theme/.git` ou declarar submódulo.

---

*Relatório gerado a partir de análise estática (sem execução). Recomenda-se complementar com SAST (Snyk Code, SonarQube) e DAST (OWASP ZAP) antes da próxima release.*
