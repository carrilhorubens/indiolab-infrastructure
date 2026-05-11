# Plano — `admin.dev.indiolab.com.br` como painel central de autenticação

> **Objetivo:** transformar `admin-api` + `admin-web` no painel oficial de gestão de identidade da plataforma IndioLab.
>
> **Escopo:** CRUDs completos de Usuários e Roles (com matriz de permissões), com o **mesmo padrão visual** do `erp-web` (theme, MainLayout, Sidebar, DataGrid server-side, ListPage de 3 dialogs).
>
> **Pré-requisito já atendido:** `admin-web` já está migrado para JWT (Fase 4 da migração anterior). Login funciona com `admin@indiolab.com.br`.

---

## 1. Estado atual

### admin-api (backend) — o que existe
| Componente | Estado |
|------------|--------|
| Controllers | `UsuariosController`, `RolesController`, `PermissoesController`, `PermissionsCatalogController`, `EmpresasController`, `DominiosController`, `HealthController` |
| Services | `UsuarioService`, `RoleService`, `RolePermissionsOrchestrator`, `EmpresaService`, `DominioService`, `TenantProvisioningClient` |
| Auth | **AINDA Keycloak** (não migrado) — `AddJwtBearer` + `KeycloakAdminClient` |
| DbContext | **NÃO TEM** — usa raw SQL via `AdminDbConnection` ou `KeycloakAdminClient` |
| Authz | `AdminRolePermissionProvider` + `AddIndioLabDbBackedAuthorization` ✅ |

**Limitação atual:** `UsuarioService` e `RoleService` orquestram **Keycloak Admin REST API**. Para descomissionar Keycloak, é preciso migrar essas operações para `UserManager<ApplicationUser>` / `RoleManager<ApplicationRole>` direto na nossa tabela Identity.

### admin-web (frontend) — o que existe
| Componente | Estado |
|------------|--------|
| Auth | ✅ JWT próprio, LoginPage com hero animado igual erp-web |
| Layout | `MainLayout` + `Sidebar` (418 linhas) + `Header` — funcional mas mais simples que erp (930 linhas) |
| Theme | `theme.ts` (1290 linhas — idêntico em wc ao erp; já portado) |
| Pages | `UsuariosPage`, `RolesPage`, `EmpresasPage`, `DominiosPage`, `DominioCrudPage` — single-file, sem o pattern de 3 dialogs |
| Services | `usuarioService`, `roleService`, `empresaService`, `dominioService` |
| Components comuns | `ConfirmDialog`, `FormSection`, `StyledDialog`, `EmptyState`, `LoadingState`, `OpticalCoreLogo` ✅ |

**Limitação atual:** `UsuariosPage` e `RolesPage` foram feitas no padrão antigo (table inline). Não seguem o padrão canônico do CLAUDE.md (DataGrid server-side + KPIs clicáveis + DetailDialog + FormDialog + ConfirmDialog).

---

## 2. Arquitetura-alvo

```
┌────────────────────────────────────────────────────────────────────┐
│                  admin.dev.indiolab.com.br                          │
│  ┌───────────────────────┐         ┌───────────────────────────┐    │
│  │     admin-web         │ ───────►│       admin-api           │    │
│  │ (React 19 + MUI 7)    │         │ (.NET 10 + EF Core)       │    │
│  │                       │  JWT    │                           │    │
│  │  • LoginPage          │         │  • UsuariosController     │    │
│  │  • UsuariosListPage   │         │  • RolesController        │    │
│  │  • RolesListPage      │         │  • PermissionsCatalog…    │    │
│  │  • PermissoesMatrix   │         │  • UserManager / RoleM…   │    │
│  └───────────────────────┘         │  • DbBackedRolePermStore  │    │
│                                    └─────────────┬─────────────┘    │
└──────────────────────────────────────────────────┼──────────────────┘
                                                   │
                                                   ▼
                            ┌─────────────────────────────────────┐
                            │   Postgres (public schema)          │
                            │   AspNetUsers / AspNetRoles /       │
                            │   AspNetUserRoles / role_permissions│
                            └─────────────────────────────────────┘
                                                   ▲
                                                   │
                            ┌──────────────────────┴──────────────┐
                            │   erp-api (IdP) — emite JWT         │
                            │   Outras APIs apenas validam        │
                            └─────────────────────────────────────┘
```

**Princípio:** o `admin-api` é o **CRUD authority** sobre Identity. O `erp-api` continua sendo o **token issuer** (mantém `/auth/login`, `/auth/refresh`, etc.). Ambos compartilham a mesma DB e a mesma `ApplicationDbContext`.

**Decisão:** mover `ApplicationDbContext` (a versão Identity-aware com FKs de auditoria) para a `indiolab-shared-api` ou criar versão simétrica no `admin-api`. Recomendado: **referenciar diretamente o projeto `IndioLab.Erp.Infrastructure` é antiacoplamento** → criar `IndioLab.Admin.Infrastructure.Persistence.AdminDbContext` com a mesma configuração Identity.

---

## 3. Fases

### Fase A — Backend `admin-api` (3 sub-fases)

#### A1. Migração para JWT próprio (mesmo padrão crm/chat)
| Item | Mudança |
|------|---------|
| `DependencyInjection.cs` | Trocar `AddJwtBearer` Keycloak por `services.AddIndioLabAuthenticationValidation(configuration)` |
| `appsettings.json` / `Development` | Substituir seção `Keycloak` por `JwtSettings` (mesma chave pública RS256 do erp-api) |
| `Program.cs` | CORS já liberado para `localhost:5174` (admin-web) |

**Critério:** `curl /api/usuarios` com token do erp-api retorna 200; sem token, 401.

#### A2. Adicionar Identity DbContext + EF Core
| Item | Mudança |
|------|---------|
| `IndioLab.Admin.Infrastructure.csproj` | Adicionar `Microsoft.EntityFrameworkCore`, `Microsoft.AspNetCore.Identity.EntityFrameworkCore`, `Npgsql.EntityFrameworkCore.PostgreSQL`, `EFCore.NamingConventions` |
| Novo `Persistence/AdminDbContext.cs` | Herda `IdentityDbContext<ApplicationUser, ApplicationRole, Guid>`. Configura FKs de auditoria + índices nomeados (`ix_asp_net_*`) iguais ao erp |
| `DependencyInjection.cs` | `services.AddDbContext<AdminDbContext>(options => UseNpgsql(...).UseSnakeCaseNamingConvention())` + `AddIdentityCore<ApplicationUser>().AddRoles<ApplicationRole>().AddEntityFrameworkStores<AdminDbContext>()` |

**Sem migration nova** — admin-api compartilha as mesmas tabelas que o erp-api criou em Phase 2.

#### A3. Refatorar `UsuarioService` + `RoleService` → Identity-based
| Service | Antes (Keycloak) | Depois (Identity) |
|---------|------------------|-------------------|
| `UsuarioService.ListarAsync` | `_keycloak.ListUsersAsync` | `_userManager.Users.Where(...).Skip().Take()` |
| `UsuarioService.CriarAsync` | `_keycloak.CreateUserAsync` | `_userManager.CreateAsync(user, password)` |
| `UsuarioService.AtualizarAsync` | `_keycloak.UpdateUserAsync` | `_userManager.UpdateAsync(user)` |
| `UsuarioService.DeletarAsync` | `_keycloak.DeleteUserAsync` | Soft delete: `user.DeletedAt = now; UpdateAsync` |
| `UsuarioService.AtribuirRoleAsync` | `_keycloak.AssignRoleAsync` | `_userManager.AddToRoleAsync(user, role)` |
| `UsuarioService.RemoverRoleAsync` | idem | `_userManager.RemoveFromRoleAsync` |
| `UsuarioService.ResetPasswordAsync` (novo) | — | `_userManager.GeneratePasswordResetTokenAsync` + `ResetPasswordAsync` |
| `UsuarioService.BloquearAsync` (novo) | — | `_userManager.SetLockoutEnabledAsync` + `SetLockoutEndDateAsync` |
| `RoleService.ListarAsync` | `_keycloak.ListClientRolesAsync` | `_roleManager.Roles` |
| `RoleService.CriarAsync` | `_keycloak.CreateRoleAsync` | `_roleManager.CreateAsync(new ApplicationRole(...))` |
| `RoleService.DeletarAsync` | `_keycloak.DeleteRoleAsync` | `_roleManager.DeleteAsync` |

**Decisão sobre "cliente":** o conceito atual de "client role" do Keycloak (`erp-web`, `crm-web`, etc.) **continua válido** mas via metadado: cada `ApplicationRole` ganha campo `Cliente` (string, ex: `"erp-web"`). Já temos `EmpresaId` e `IsSystemRole` em `ApplicationRole`. Adicionamos uma migration `AddClienteToRoles` na próxima passada.

A tabela `role_permissions` (cliente, role_name, permission) **continua** sendo a fonte das permissões granulares — não muda nada lá.

#### A4. Endpoints novos / ajustados
| Endpoint | Função |
|----------|--------|
| `POST /api/usuarios/{id}/reset-password` | Admin força reset (gera token, retorna ou envia email) |
| `POST /api/usuarios/{id}/bloquear` | Lockout permanente até admin desbloquear |
| `POST /api/usuarios/{id}/desbloquear` | Reseta lockout |
| `POST /api/usuarios/{id}/ativar` / `/desativar` | Toggle `Active` flag |
| `GET /api/usuarios/proximo-codigo` | Para AutoCódigo no FormDialog (igual erp) |
| `GET /api/permissoes-catalog?cliente=erp-web` | Lista permissões code-based de um cliente (já existe; revisar) |

---

### Fase B — Frontend `admin-web`

#### B1. Portar layout idêntico ao erp-web

| Componente | Origem | Ação |
|------------|--------|------|
| `Sidebar.tsx` | `erp-web/.../Sidebar.tsx` (930 linhas) | Copiar + ajustar items para o admin: Início, Usuários, Roles & Permissões, Empresas, Domínios |
| `Header.tsx` | `erp-web/.../Header.tsx` | Copiar idêntico |
| `MainLayout.tsx` | `erp-web/.../MainLayout.tsx` | Atualizar `routeTitles` para rotas do admin |
| `theme.ts` | (já idêntico) | sem mudança |
| Componentes comuns | `EmptyState`, `ErrorState`, `FormSection`, `StyledDialog` etc. | Já existem; garantir paridade com erp |

**Resultado visual:** painel idêntico ao ERP — mesmo gradient header, mesma sidebar collapsible, mesmo padrão de breadcrumb/título.

#### B2. Refatorar Pages para padrão canônico (DataGrid server-side + 3 dialogs)

##### B2.1 — Usuários
```
src/presentation/pages/usuarios/
├── UsuariosListPage.tsx
├── components/
│   ├── UsuarioDetailDialog.tsx     # read-only + botões Editar/Remover/Reset Senha/Bloquear
│   ├── UsuarioFormDialog.tsx       # criar/editar (email, fullName, password, empresaId)
│   ├── UsuarioRolesDialog.tsx      # checkbox matrix de roles disponíveis
│   └── UsuarioResetPasswordDialog.tsx
```

**KPIs clicáveis:**
- Total
- Ativos
- Inativos
- Bloqueados (lockout)
- Super-admins

**Colunas:** Código, E-mail, Nome Completo, Empresa, Roles, Último Login, Ativo (chip), Bloqueado (chip).

##### B2.2 — Roles & Permissões
```
src/presentation/pages/roles/
├── RolesListPage.tsx
├── components/
│   ├── RoleDetailDialog.tsx        # read-only + lista permissões + botão Editar Permissões
│   ├── RoleFormDialog.tsx          # criar/editar (nome, descrição, cliente, IsSystemRole)
│   ├── RolePermissoesDialog.tsx    # checkbox matrix agrupada por área (Permissions.Vendas.*)
│   └── RoleUsuariosDialog.tsx      # lista usuários que têm essa role (read-only)
```

**KPIs:**
- Total de roles
- Roles do erp-web / crm-web / ichat-web / admin-web (cards informativos)
- Roles do sistema (não-deletáveis)

**Colunas:** Código, Cliente, Nome, Descrição, Tipo (Sistema/Custom), Nº Permissões, Nº Usuários.

**Matriz de permissões (PermissoesDialog):**
- Backend retorna catálogo do cliente da role + permissões atualmente atribuídas.
- Frontend renderiza checkbox grid agrupado por área.
- "Selecionar tudo da área", "Selecionar todas", "Limpar".
- Botão Salvar dispara `PUT /api/roles/{id}/permissoes` que invalida cache do provider correspondente.

##### B2.3 — Empresas (já existe — refatorar pro padrão de 3 dialogs)
```
src/presentation/pages/empresas/
├── EmpresasListPage.tsx
├── components/
│   ├── EmpresaDetailDialog.tsx
│   └── EmpresaFormDialog.tsx
```

##### B2.4 — Domínios (já existe — manter ou portar conforme o padrão erp)

#### B3. Convenções de UI (do CLAUDE.md, obrigatórias)
- DataGrid server-side com `paginationMode="server"`, `sortingMode="server"`
- KPIs clicáveis (filterKey) substituem dropdown de status
- Sem coluna "Ações" — clicar na linha abre o DetailDialog
- Botão "Novo" no Paper junto da busca
- pt-BR com acentuação correta em todos os textos
- `dialog.success`/`error`/`confirm` para feedback (nunca `alert()` ou Snackbar)
- `autoSelectDefault={!isEditing}` em todo `DominioSelect`

---

### Fase C — Integração (cross-service)

| Item | Como |
|------|------|
| Após admin criar/editar role no `role_permissions` | admin-api chama webhook em erp-api/crm-api/chat-api `/api/internal/permissions/invalidate` para refresh imediato do cache (60s timeout senão) |
| Quando admin bloqueia usuário | erp-api precisa rejeitar refresh tokens daquele usuário — adicionar check em `RefreshAsync`: `if (user.LockoutEnd > now) throw` |
| Audit log | Toda operação CRUD no admin-api grava em `auth_events` (Fase 5 da migração anterior) |

---

### Fase D — Decommission Keycloak (final)

Após admin-api migrado:
1. Remover `KeycloakAdminClient` do shared-api
2. Apagar `keycloak/` e `keycloak-theme/` (foi adiado na fase 6 anterior)
3. Atualizar `docs/PLANO-MIGRACAO-IDENTITY-JWT.md` marcando esta fase concluída

---

## 4. Estrutura de arquivos final

### admin-api
```
admin-api/src/
├── IndioLab.Admin.API/
│   └── Controllers/
│       ├── UsuariosController.cs           [refatorar]
│       ├── RolesController.cs              [refatorar]
│       ├── PermissionsCatalogController.cs [já existe]
│       ├── EmpresasController.cs
│       └── DominiosController.cs
└── IndioLab.Admin.Infrastructure/
    ├── Persistence/
    │   ├── AdminDbContext.cs               [NOVO]
    │   └── AdminDbConnection.cs            [manter para queries raw legadas]
    ├── Services/
    │   ├── UsuarioService.cs               [reescrever c/ UserManager]
    │   ├── RoleService.cs                  [reescrever c/ RoleManager]
    │   └── RolePermissionsOrchestrator.cs  [manter, adapta inputs]
    └── DependencyInjection.cs              [trocar Keycloak → Validation + Identity]
```

### admin-web
```
admin-web/src/
├── application/
│   ├── AuthContext.tsx                     [já feito]
│   └── contexts/
├── infrastructure/
│   ├── auth/                               [já feito]
│   ├── api.ts                              [já feito]
│   ├── usuarioService.ts                   [refatorar shape]
│   ├── roleService.ts                      [refatorar shape]
│   └── permissionsCatalogService.ts        [NOVO]
└── presentation/
    ├── components/layout/
    │   ├── MainLayout.tsx                  [portar do erp]
    │   ├── Sidebar.tsx                     [portar do erp]
    │   └── Header.tsx                      [portar do erp]
    ├── pages/
    │   ├── usuarios/
    │   │   ├── UsuariosListPage.tsx        [NOVO — padrão canônico]
    │   │   └── components/                 [Detail/Form/Roles/ResetPassword]
    │   ├── roles/
    │   │   ├── RolesListPage.tsx           [NOVO — padrão canônico]
    │   │   └── components/                 [Detail/Form/Permissoes/Usuarios]
    │   ├── empresas/                       [refatorar]
    │   └── dominios/                       [manter]
    └── routes/
        └── AppRoutes.tsx                   [adicionar rotas]
```

---

## 5. Estimativa de esforço

| Fase | Esforço |
|------|---------|
| A1 — admin-api migra para JWT validation | 30min |
| A2 — admin-api ganha AdminDbContext | 1h |
| A3 — UsuarioService/RoleService → Identity | 3-4h |
| A4 — Endpoints novos | 1h |
| **Total backend** | **~5-6h** |
| B1 — Portar layout do erp (Sidebar, MainLayout) | 1-2h |
| B2.1 — UsuariosListPage + 4 dialogs | 4-5h |
| B2.2 — RolesListPage + 4 dialogs (incl. matriz permissões) | 5-6h |
| B2.3 — EmpresasListPage refatorada | 1-2h |
| **Total frontend** | **~12-15h** |
| C — Integração cache invalidation | 2h |
| D — Decommission Keycloak | 1h |
| **Total geral** | **~20-25h** (3-4 dias úteis) |

---

## 6. Ordem de execução sugerida

1. **A1 + A2** (preparação): admin-api passa a validar JWT e tem DbContext. Build verde.
2. **B1** (visual): admin-web ganha visual idêntico ao erp. Páginas atuais continuam funcionando.
3. **A3** (backend services): refatorar Usuario/Role services. Endpoints existentes continuam funcionando.
4. **B2.1** (Usuários): nova UsuariosListPage canônica. Substitui a atual.
5. **B2.2** (Roles): nova RolesListPage canônica. Inclui matriz de permissões.
6. **A4 + endpoints novos**: reset password, bloquear, etc.
7. **B2.3 + B2.4**: refatorar Empresas, manter Domínios.
8. **C**: cache invalidation cross-service.
9. **D**: remover Keycloak da árvore.

Cada passo deixa o app funcional — sem big-bang.

---

## 7. Decisões pendentes (preciso confirmar)

1. **`ApplicationRole.Cliente` (string)**: aceito adicionar esse campo + migration? Alternativa: continuar com `IsSystemRole` apenas e usar o nome como prefixo (`erp:vendedor`, `crm:supervisor`). **Recomendado:** campo `Cliente` explícito.
2. **Reset de senha**: admin gera token e mostra na UI (copy-to-clipboard) ou envia direto por email via SMTP? Email exige Fase 5 hardening (SMTP). **Sugerido para v1:** mostrar token na UI; SMTP posterior.
3. **Auditoria**: criar tabela `auth_events` agora ou só log no Serilog? **Sugerido:** apenas Serilog na v1; tabela depois.
4. **Soft-delete de usuários**: bloqueia login (já implementado em `LoginAsync` que checa `DeletedAt`) — confirmar UX (botão "Excluir" = soft delete, "Excluir Permanentemente" não existe).
5. **MFA**: incluir UI nesta rodada ou só Fase 5 dedicada? **Sugerido:** fora do escopo desta entrega.

---

## 8. Critérios de aceite

- [ ] admin-api roda sem `KeycloakAdminClient` (build verde sem references)
- [ ] `GET /api/usuarios` retorna lista paginada do `AspNetUsers`
- [ ] `POST /api/usuarios` cria usuário em `AspNetUsers` com hash via Identity
- [ ] `POST /api/roles` cria entrada em `AspNetRoles`
- [ ] `PUT /api/roles/{id}/permissoes` atualiza `role_permissions` e invalida cache do provider
- [ ] Login no erp-web com usuário criado pelo admin-web funciona
- [ ] admin-web visualmente idêntico ao erp (mesmo Sidebar, Header, padrão de DataGrid)
- [ ] UsuariosListPage e RolesListPage seguem o padrão canônico (DataGrid server + KPIs + DetailDialog + FormDialog + ConfirmDialog)
- [ ] Reset de senha funciona via UI
- [ ] Bloquear/Desbloquear usuário funciona
