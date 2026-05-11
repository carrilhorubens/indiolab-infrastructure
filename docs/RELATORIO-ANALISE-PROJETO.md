# Relatório Completo — Análise do Projeto OpticalCore ERP

**Data:** 2026-03-20
**Escopo:** Estrutura, dependências, autenticação, frontend, backend, banco de dados e vulnerabilidades de segurança.

---

## 1. Estrutura de Pastas

```
opticalcore.com.br/
├── backend/
│   └── src/
│       ├── OpticalCore.API/           → Controllers, Middlewares, Hubs (SignalR), Program.cs
│       │   ├── Controllers/
│       │   │   ├── Admin/             → UsersController, CompaniesController, RolesController
│       │   │   ├── Dominios/          → ~35 controllers standalone (um por domínio)
│       │   │   ├── AuthController.cs
│       │   │   ├── AdminController.cs → Seeds, migrations, sync
│       │   │   ├── WhatsAppWebhookController.cs
│       │   │   └── ... (Clientes, Fornecedores, Produtos, etc.)
│       │   ├── Middlewares/           → TenantMiddleware, ExceptionHandler
│       │   └── Hubs/                  → ChatHub (SignalR)
│       ├── OpticalCore.Application/   → Interfaces, DTOs, Permissions, Validators (FluentValidation)
│       ├── OpticalCore.Domain/        → Entidades DDD, BaseDominio, enums
│       │   └── Entities/
│       │       ├── Dominios/          → ~35 entidades domínio (BaseDominio)
│       │       ├── Estoque/           → Produto, Depósito, Lote, MovimentacaoEstoque...
│       │       ├── Compras/           → OrdemCompra, Cotacao, ContratoCompra...
│       │       ├── Vendas/            → PedidoVenda, Faturamento, Comissao...
│       │       ├── Fiscal/            → NotaFiscal, RegrasTributarias...
│       │       ├── Financeiro/        → ContasPagar, ContasReceber, PlanoContas...
│       │       └── Producao/          → ListaMaterial, ExplosaoNecessidades
│       └── OpticalCore.Infrastructure/→ DbContexts, Services, Seeds, Migrations
│           ├── Persistence/
│           │   ├── ApplicationDbContext.cs  → Schema public (Identity, domínios)
│           │   ├── TenantDbContext.cs       → Schema tenant (negócio)
│           │   └── Seeds/                   → Seeds por módulo
│           └── Services/
│               ├── AuthService.cs
│               ├── TenantSchemaService.cs   → DDL dinâmico por tenant
│               ├── ChatService.cs
│               ├── WhatsAppService.cs
│               └── ... (~30 services)
├── frontend/
│   └── src/
│       ├── application/               → Contexts (Auth, Dialog, Theme), hooks
│       ├── domain/                    → Types, interfaces por módulo
│       ├── infrastructure/            → API client (Axios), services
│       └── presentation/
│           ├── components/            → Shared (StyledDialog, FormSection, EmptyState)
│           └── pages/                 → ~80 ListPages + ~66 Domínio pages
│               ├── pessoas/           → Clientes, Fornecedores, Funcionários
│               ├── estoque/           → Produtos, Depósitos, Movimentações, Lotes...
│               ├── compras/           → Ordens, Cotações, Contratos...
│               ├── vendas/            → Pedidos, Faturamentos, Entregas...
│               ├── financeiro/        → Contas Pagar/Receber, DRE, CNAB...
│               ├── fiscal/            → Notas Fiscais, Regras Tributárias...
│               └── chat/              → Chat interno + WhatsApp híbrido
├── docs/                              → Documentação por módulo (estoque, compras, vendas, fiscal, produção)
├── scripts/                           → update-whatsapp-version.sh
├── docker-compose.yml                 → Dev (Postgres + Evolution API)
├── docker-compose.prod.yml            → Prod (API + Frontend + Postgres + Evolution)
└── .github/workflows/deploy.yml       → CI/CD GitHub Actions (self-hosted runner)
```

**Total estimado:** ~135 tabelas tenant (10 core + 17 estoque + 24 compras + 21 vendas + 36 financeiro + 27 fiscal) + schema public (Identity + ~35 domínios).

---

## 2. Dependências

### Backend (.NET 10)

| Pacote | Versão | Propósito |
|--------|--------|-----------|
| `Microsoft.AspNetCore.Authentication.JwtBearer` | 10.0.2 | Autenticação JWT |
| `Microsoft.AspNetCore.Identity.EntityFrameworkCore` | 10.0.2 | Identity (usuários, roles, claims) |
| `Microsoft.EntityFrameworkCore` | 10.0.2 | ORM |
| `Npgsql.EntityFrameworkCore.PostgreSQL` | 10.0.0 | Provider PostgreSQL |
| `EFCore.NamingConventions` | 10.0.1 | snake_case nas tabelas |
| `QuestPDF` | 2026.2.2 | Geração de DANFE (PDF) |
| `Serilog.AspNetCore` | 10.0.0 | Logging estruturado |
| `FluentValidation` | — | Validação de Commands/Queries |
| `MediatR` | — | CQRS (Application layer) |

### Frontend (React 19 + Vite 7)

| Pacote | Versão | Propósito |
|--------|--------|-----------|
| `react` / `react-dom` | 19.2.0 | UI Framework |
| `@mui/material` | 7.3.7 | Design System (MUI 7) |
| `@mui/x-data-grid` | 8.26.0 | DataGrid server-side |
| `@mui/x-charts` | 8.26.0 | Gráficos (dashboards) |
| `@microsoft/signalr` | 10.0.0 | WebSocket (chat real-time) |
| `axios` | 1.13.2 | HTTP client → backend |
| `react-router-dom` | 7.12.0 | Roteamento SPA |
| `react-hook-form` + `zod` | 7.71 / 4.3 | Formulários + validação |
| `@dnd-kit/*` | 6.3+ | Drag & drop |
| `typescript` | 5.9.3 | Tipagem estática |
| `vite` | 7.2.4 | Build tool / dev server |

---

## 3. Autenticação — Como Funciona

### Fluxo Completo

```
[Frontend]                          [Backend]
    │                                   │
    ├─ POST /api/auth/login ──────────► AuthService.LoginAsync()
    │  { email, password }              │ → Identity.CheckPasswordSignInAsync()
    │                                   │ → Gera JWT (access + refresh token)
    │ ◄── { accessToken, refreshToken,  │
    │       user { permissions, roles }} │
    │                                   │
    ├─ localStorage.setItem(tokens) ──► │
    │                                   │
    ├─ Axios interceptor ─────────────► Authorization: Bearer {jwt}
    │  (todo request subsequente)       │ → JwtBearerHandler valida
    │                                   │ → TenantMiddleware extrai tenant_id do JWT
    │                                   │ → TenantDbContext usa schema do tenant
    │                                   │
    ├─ POST /api/auth/refresh ────────► AuthService.RefreshTokenAsync()
    │  { accessToken, refreshToken }    │ → Gera novo par de tokens
    │                                   │
    ├─ POST /api/auth/switch-tenant ──► AuthService.SwitchTenantAsync()
    │  { novoEmpresaId }                │ → Gera JWT com novo tenant_id
```

### Detalhes Técnicos

- **Identity Provider:** ASP.NET Core Identity (tabelas `public.usuarios`, `public.roles`, `public.user_roles`, `public.role_claims`)
- **Token:** JWT (HS256) com claims: `sub`, `email`, `role`, `tenant_id`, `permissions[]`
- **Expiração:** 60 minutos (access token)
- **Refresh Token:** Salvo no banco, rotação a cada uso
- **SignalR Auth:** JWT extraído da query string `?access_token=` (WebSocket não suporta headers)
- **Role Root:** Bypass total — `TenantMiddleware` ignora, `AuthContext.hasPermission()` retorna `true` para tudo
- **Policies:** Uma policy por permission (gerada dinamicamente via `Permissions.GetAll()`)
- **Password:** Mínimo 6 chars, sem requisitos de caracteres especiais

### Frontend

- `AuthContext.tsx`: Provider React com `login()`, `logout()`, `switchTenant()`, `hasPermission()`
- Tokens em `localStorage` (`accessToken`, `refreshToken`)
- Axios interceptor adiciona header `Authorization: Bearer` automaticamente

---

## 4. Frontend — Stack e Comunicação

### Stack
- **React 19** com TypeScript 5.9 e Vite 7.2
- **MUI 7** (Material UI) — único framework de UI (sem Tailwind, estilização via `sx` prop)
- **DataGrid MUI X 8.26** — server-side pagination e sorting em TODAS as tabelas
- **react-router-dom 7.12** — rotas SPA
- **react-hook-form + zod** — formulários com validação
- **SignalR 10** — chat real-time (WebSocket)

### Comunicação com Backend
- **Axios** como HTTP client
- Base URL: `VITE_API_URL` (env var, ex: `http://localhost:5050/api` em dev, `http://10.1.56.56:5050/api` em prod)
- Interceptor automático adiciona JWT no header
- Pattern: `*Service.ts` → `api.get/post/put/delete('/endpoint')` → Controller ASP.NET Core
- SignalR: conexão WebSocket direta para `/hubs/chat` com JWT na query string

### Estrutura de Páginas
- **~80 ListPages** (entidades de negócio) + **~66 Domínio pages** (lookups)
- Cada entidade: `*ListPage.tsx` + `*FormDialog.tsx` + `*DetailDialog.tsx`
- Layout: `MainLayout.tsx` (Sidebar + Header global + Outlet)
- Textos em pt-BR com acentuação

---

## 5. Backend — Stack e Arquitetura

### Stack
- **C# / .NET 10** (preview) — ASP.NET Core
- **EF Core 10** + **Npgsql** (PostgreSQL provider)
- **Clean Architecture**: API → Application → Domain → Infrastructure
- **CQRS:** MediatR (Commands + Queries separados)
- **DDD:** Entidades com comportamento, value objects, enums como classes

### Multi-Tenancy (Schema-per-Tenant)
- Cada empresa = um schema PostgreSQL (`cnpj` como nome do schema)
- `TenantMiddleware` extrai `tenant_id` do JWT claim e configura o `TenantDbContext`
- `TenantSchemaService` gera DDL dinâmico (`CREATE TABLE IF NOT EXISTS`) para cada schema
- Schema `public` = Identity + domínios compartilhados (~35 tabelas)
- Schema tenant = ~135 tabelas de negócio

### Endpoints
- **AuthController** — login, refresh, switch-tenant, logout
- **AdminController** — seeds, migrations, sync-permissions (vários `[AllowAnonymous]`)
- **~30+ controllers de negócio** — CRUD + operações de workflow
- **35 controllers de domínio** — standalone, DTOs inline
- **WhatsAppWebhookController** — recebe webhooks da Evolution API
- **SignalR Hub** — ChatHub para mensagens real-time

---

## 6. Banco de Dados

| Aspecto | Detalhe |
|---------|---------|
| **SGBD** | PostgreSQL 15 |
| **Schema public** | Identity (usuarios, roles, claims) + ~35 domínios + chat interno |
| **Schemas tenant** | ~135 tabelas por empresa (estoque, compras, vendas, financeiro, fiscal) |
| **ORM** | EF Core 10 com snake_case naming |
| **Migrations** | 83 individuais (47 Application + 36 Tenant) |
| **Conexão** | `Host=localhost;Database=opticalcorecombr;Username=postgres;Password=pegasus` |
| **Docker** | `postgres:15` em container com volume persistente |
| **Convenção** | Uma migration por feature/CRUD, NUNCA editar InitialCreate |

---

## 7. Vulnerabilidades de Segurança (por Prioridade)

### CRÍTICA (resolver imediatamente)

#### 7.1 — Segredos hardcoded e commitados no Git
- **Arquivo:** `appsettings.json` (commitado no repositório)
- **Dados expostos:**
  - JWT Secret: `OpticalCoreSecretKeyMuitoLongaESeguraParaJWT2024!@#`
  - DB Password: `pegasus`
  - WhatsApp API Key: `opticalcore-whatsapp-key`
- **Impacto:** Qualquer pessoa com acesso ao repositório pode forjar JWTs válidos, acessar o banco de dados diretamente e controlar a API do WhatsApp
- **Correção:** Mover para `appsettings.Production.json` (no `.gitignore`), variáveis de ambiente ou Azure Key Vault / AWS Secrets Manager. Rotacionar TODAS as secrets expostas

#### 7.2 — Endpoints administrativos sem autenticação (`[AllowAnonymous]`)
- **Arquivo:** `AdminController.cs`
- **Endpoints expostos:**
  - `POST /api/admin/initialize-database` — inicializa banco
  - `GET /api/admin/database-status` — status do banco
  - `POST /api/admin/migrate-all-schemas` — executa migrations
  - `POST /api/admin/permissions/sync-admin` — sincroniza permissions
  - `GET /api/admin/permissions/list-all` — lista todas as permissions
  - `POST /api/admin/seed-all` — seed completo do sistema
- **Impacto:** Qualquer pessoa na rede pode executar seeds, migrations, resetar dados e obter a lista completa de permissions do sistema
- **Correção:** Proteger com `[Authorize(Roles = "Root")]` ou restringir por IP/ambiente. Deixar `[AllowAnonymous]` APENAS para setup inicial com flag de primeira execução

#### 7.3 — Sem HTTPS em produção
- **Evidência:** Nenhuma referência a `UseHttpsRedirection`, `HSTS`, `TLS` ou `SSL` no `Program.cs`
- **Produção:** Frontend serve em porta 80 (HTTP), API em porta 5050 (HTTP)
- **Impacto:** JWTs, credenciais e dados trafegam em texto plano na rede. Vulnerável a MITM (man-in-the-middle)
- **Correção:** Configurar HTTPS com certificado (Let's Encrypt) via reverse proxy (Nginx/Caddy) na frente dos containers

### ALTA (resolver em curto prazo)

#### 7.4 — Webhook WhatsApp sem validação de API Key
- **Arquivo:** `WhatsAppWebhookController.cs`
- **Problema:** Recebe `apiKey` no header mas **nunca valida** contra a key configurada
- **Impacto:** Qualquer pessoa pode enviar payloads falsos para `/api/whatsapp/webhook`, injetando mensagens falsas no sistema
- **Correção:** Validar `apiKey == configuration["WhatsApp:EvolutionApiKey"]` e retornar 401 se inválido

#### 7.5 — SQL com string interpolation no TenantSchemaService
- **Arquivo:** `TenantSchemaService.cs` (linhas 46, 99)
- **Código:** `$"CREATE SCHEMA IF NOT EXISTS \"{schemaName}\""` e `$"DROP SCHEMA IF EXISTS \"{schemaName}\" CASCADE"`
- **Problema:** `schemaName` é interpolado diretamente no SQL (vem do CNPJ do tenant)
- **Impacto:** Se um CNPJ malicioso for cadastrado, SQL injection no nível de DDL (DROP SCHEMA CASCADE, por exemplo)
- **Atenuante:** Schema name é validado com regex `^\d{11,14}$` em outro ponto
- **Correção:** Centralizar validação com whitelist antes de qualquer uso em SQL

#### 7.6 — CORS permissivo com IP interno hardcoded
- **Arquivo:** `Program.cs`
- **Config:** `WithOrigins("http://localhost:3000", "http://localhost:5173", "http://10.1.56.56")`
- **Problema:** IP de produção hardcoded sem HTTPS. `AllowAnyMethod()` + `AllowAnyHeader()` + `AllowCredentials()` é amplo demais
- **Correção:** Mover origins para configuração, restringir métodos/headers necessários, usar HTTPS

#### 7.7 — Containers Docker rodam como root
- **Arquivo:** `Dockerfile` (backend e frontend)
- **Problema:** Nenhum dos Dockerfiles tem instrução `USER` para rodar como non-root
- **Impacto:** Se o container for comprometido, o atacante tem acesso root no container
- **Correção:** Adicionar `RUN adduser --disabled-password appuser` + `USER appuser`

### MÉDIA (resolver em médio prazo)

#### 7.8 — Sem Rate Limiting
- **Evidência:** Rate limiting disponível como pacote NuGet mas **não configurado** no `Program.cs`
- **Impacto:** Endpoints de login e API vulneráveis a brute force e DDoS
- **Correção:** `builder.Services.AddRateLimiter()` com policy por endpoint (login: 5/min, API: 100/min)

#### 7.9 — Sem Security Headers
- **Problema:** Nenhum header de segurança configurado:
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY`
  - `Content-Security-Policy`
  - `Strict-Transport-Security` (HSTS)
  - `X-XSS-Protection`
- **Correção:** Middleware customizado ou pacote `NWebsec`

#### 7.10 — Política de senha fraca
- **Arquivo:** `DependencyInjection.cs`
- **Config:** `RequireNonAlphanumeric = false`, `RequiredLength = 6`
- **Impacto:** Senhas como `123456` são aceitas
- **Correção:** Mínimo 8 chars, exigir maiúscula + número + especial

#### 7.11 — JWT ClockSkew = Zero sem proteção contra replay
- **Problema:** `ClockSkew = TimeSpan.Zero` é bom (sem margem extra), mas não há blacklist de tokens revogados
- **Impacto:** Tokens de usuários que fizeram logout continuam válidos até expirar (60 min)
- **Correção:** Implementar token blacklist (Redis) ou reduzir expiração para 15 min com refresh token

#### 7.12 — Tokens JWT armazenados em localStorage
- **Problema:** localStorage é acessível por qualquer JavaScript na página (XSS → roubo de token)
- **Correção:** Migrar para httpOnly cookies (não acessíveis por JS) ou sessionStorage como mínimo

### BAIXA (melhorias recomendadas)

#### 7.13 — Swagger habilitado em produção
- **Problema:** Swagger UI acessível sem autenticação em todos os ambientes
- **Impacto:** Expõe toda a superfície de API (endpoints, DTOs, schemas)
- **Correção:** Restringir a ambiente de desenvolvimento ou proteger com autenticação

#### 7.14 — PostgreSQL exposto na porta 5432
- **Problema:** `docker-compose.yml` mapeia porta 5432 para o host
- **Impacto:** Banco acessível externamente se firewall não estiver configurado
- **Correção:** Remover mapeamento de porta em produção (apenas rede Docker interna)

#### 7.15 — `AllowedHosts: "*"` no appsettings
- **Problema:** Aceita requisições de qualquer hostname
- **Correção:** Restringir para domínios conhecidos em produção

#### 7.16 — Kestrel MaxRequestLineSize aumentado (32KB)
- **Problema:** Aumentado para acomodar JWT no WebSocket, mas amplia superfície de ataque para header injection
- **Atenuante:** Necessário para SignalR com JWT grande
- **Correção:** Monitorar e considerar separar auth do SignalR

---

## Resumo Executivo

| Categoria | Quantidade |
|-----------|------------|
| Vulnerabilidades CRÍTICAS | 3 |
| Vulnerabilidades ALTAS | 4 |
| Vulnerabilidades MÉDIAS | 5 |
| Vulnerabilidades BAIXAS | 4 |
| **Total** | **16** |

**Ação imediata requerida:** Rotacionar secrets, proteger endpoints admin, configurar HTTPS.
