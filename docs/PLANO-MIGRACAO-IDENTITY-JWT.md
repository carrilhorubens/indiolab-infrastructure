# Plano de Migração — Keycloak → ASP.NET Core Identity + JWT Próprio

> **Decisão:** sair do Keycloak. Autenticação passa a ser controlada inteiramente pelos serviços `.NET` da IndioLab, com JWT emitido pela própria API.
> **Autorização** (permissões/roles) **não muda** — toda a infraestrutura existente em `indiolab-shared-api/Authorization/*` continua igual. Apenas trocamos a fonte do token.

---

## 1. Estado Atual (mapeado)

### Já existe (reaproveitar 100%)
| Camada | Arquivo | Observação |
|--------|---------|------------|
| Domain | `indiolab-shared-api/.../Identity/ApplicationUser.cs` | UUID-keyed, com `RefreshToken`, `RefreshTokenExpiryTime`, `EmpresaId`, `FuncionarioId`, audit fields. **Já preparado para JWT próprio** |
| Domain | `indiolab-shared-api/.../Identity/ApplicationRole.cs` | UUID-keyed, com `EmpresaId`, `IsSystemRole` |
| Authz | `indiolab-shared-api/.../Authorization/PermissionPolicyProvider.cs` | Cria policies dinamicamente para `Permissions.*` |
| Authz | `indiolab-shared-api/.../Authorization/PermissionAuthorizationHandler.cs` | Avalia `PermissionRequirement` — **precisa pequeno ajuste** (ler roles de `ClaimTypes.Role` em vez de `resource_access`) |
| Authz | `indiolab-shared-api/.../Authorization/DbRolePermissionStore.cs` | Tabela `public.role_permissions` (cliente, role_name, permission) |
| Authz | `indiolab-shared-api/.../Authorization/DbBackedRolePermissionProvider.cs` | Cache 60s + fallback code-based |
| Authz | `indiolab-shared-api/.../Authorization/ServiceCollectionExtensions.cs` | `AddIndioLabAuthorization()` / `AddIndioLabAuthorizationDb<TProvider>()` |
| Authz | `erp-api/.../Authorization/ErpRolePermissionProvider.cs` | Catálogo code-based de permissões do ERP |

### A ser substituído
| Onde | O que tem hoje | Vira |
|------|----------------|------|
| `erp-api/Program.cs` + `DependencyInjection.cs` | `AddJwtBearer` apontando para JWKS do Keycloak (`https://auth.apli.indiolab.com.br/realms/indiolab/.well-known/openid-configuration`) | `AddIndioLabAuthentication(config)` (issuer/audience local) |
| `erp-web/src/application/contexts/AuthContext.tsx` | `keycloak-js` (init, updateToken, login redirect) | Login email/senha → `/api/auth/login` → guarda access+refresh |
| `erp-web/src/infrastructure/api/index.ts` | Lê token do `window.__keycloak` | Lê de `AuthContext` + interceptor faz refresh em 401 |
| `admin-web/src/application/AuthContext.tsx` | Idem `erp-web` | Idem |
| `admin-web/package.json` + `erp-web/package.json` | `keycloak-js: ^26.2.3` | Remove |
| `keycloak/`, `keycloak-theme/` (raiz) | Servidor Keycloak local + tema custom | Arquivar/remover ao final |

---

## 2. Arquitetura-alvo

```
┌──────────────┐        login email+senha            ┌─────────────────────────┐
│  erp-web /   │ ──────────────────────────────────▶ │  erp-api / admin-api /  │
│  admin-web   │ ◀─────────────────────────────────  │  chat-api               │
│  (React)     │     access (15min) + refresh (7d)   │  (cada um valida JWT    │
└──────────────┘                                     │   localmente via shared │
       │  GET /qualquer  + Authorization: Bearer …   │   key + emite tokens    │
       └────────────────────────────────────────────▶│   no /auth/login)       │
                                                     └────────────┬────────────┘
                                                                  │
                                                       ┌──────────▼──────────┐
                                                       │  Postgres (public)  │
                                                       │  AspNetUsers        │
                                                       │  AspNetRoles        │
                                                       │  AspNetUserRoles    │
                                                       │  role_permissions   │  ← já existe
                                                       └─────────────────────┘
```

- **Access token** (JWT, HS256/RS256, ~15min) com claims: `sub` (UserId), `email`, `preferred_username`, `tenant_id` (EmpresaId), `roles[]`.
- **Refresh token** (opaco, ~7d, rotacionável, persistido em `ApplicationUser.RefreshToken` + expiry).
- **Validação local** em cada API via shared key — sem chamada HTTP entre serviços para validar token.
- **Permissões** continuam vindo do `IRolePermissionProvider` (DB-backed, cache 60s).

---

## 3. Fases

### Fase 1 — Núcleo de Autenticação (`indiolab-shared-api`)
**Objetivo:** ter login/refresh/logout funcionando, com JWT próprio, **sem tocar em nada do Keycloak ainda**.

#### Tarefas
1. Criar pasta `IndioLab.Shared.Infrastructure/Authentication/`:
   - `JwtSettings.cs` — POCO: `Issuer`, `Audience`, `SigningKey`, `AccessTokenMinutes`, `RefreshTokenDays`.
   - `IJwtTokenService.cs` + `JwtTokenService.cs` — `GenerateAccessToken(user, roles)`, `GenerateRefreshToken()`, `ValidateAccessToken(token)`.
   - `IAuthService.cs` + `AuthService.cs`:
     - `LoginAsync(email, password)` → valida via `SignInManager`, retorna `LoginResponse { accessToken, refreshToken, user }`.
     - `RefreshAsync(refreshToken)` → valida + rotaciona (gera novo refresh e invalida o antigo).
     - `LogoutAsync(userId)` → zera `RefreshToken` no banco.
     - `ChangePasswordAsync(userId, current, newPassword)`.
   - `ServiceCollectionExtensions.AddIndioLabAuthentication<TDbContext>(IServiceCollection, IConfiguration)`:
     - `AddIdentity<ApplicationUser, ApplicationRole>()` com lockout, password policy.
     - `AddJwtBearer()` apontando para o próprio issuer + signing key do `JwtSettings`.
     - Registra `IJwtTokenService`, `IAuthService`.
2. Criar `IndioLab.Shared.Application/Dtos/Auth/`:
   - `LoginRequest { Email, Password }`, `LoginResponse { AccessToken, RefreshToken, User }`.
   - `RefreshRequest { RefreshToken }`, `RefreshResponse { AccessToken, RefreshToken }`.
   - `RegisterRequest`, `ChangePasswordRequest`, `UserDto`.
3. Ajustar `PermissionAuthorizationHandler`:
   - Remover bloco que lê `resource_access.{clientId}.roles` do JSON Keycloak.
   - Ficar apenas com `user.FindAll(ClaimTypes.Role)`.

**Critério de aceite:** unit tests do `JwtTokenService` passam (gera + valida); `AuthService` testado contra um `IdentityDbContext` em memória (login OK, login com senha errada falha, refresh rotaciona).

---

### Fase 2 — `erp-api` consome o novo Auth
**Objetivo:** `erp-api` autentica com JWT próprio, mantendo todas as policies de permissão funcionando.

#### Tarefas
1. `IndioLab.Erp.Infrastructure/DependencyInjection.cs`:
   - Trocar bloco `AddAuthentication().AddJwtBearer(...)` (Keycloak JWKS) por `services.AddIndioLabAuthentication<ApplicationDbContext>(configuration)`.
   - Manter `AddIndioLabAuthorizationDb<ErpRolePermissionProvider>(...)`.
2. `appsettings.json` (e `.Development`/`.Production`):
   ```json
   "JwtSettings": {
     "Issuer": "https://api.apli.indiolab.com.br",
     "Audience": "indiolab-erp",
     "SigningKey": "<256-bit secret — env var em prod>",
     "AccessTokenMinutes": 15,
     "RefreshTokenDays": 7
   }
   ```
3. Criar `Controllers/AuthController.cs`:
   - `POST /api/auth/login` → `IAuthService.LoginAsync`
   - `POST /api/auth/refresh` → `IAuthService.RefreshAsync`
   - `POST /api/auth/logout` → `IAuthService.LogoutAsync`
   - `GET /api/auth/me` → retorna `UserDto` com permissões resolvidas
   - `POST /api/auth/change-password` (autenticado)
4. Migration EF Core: tabelas Identity (`AspNetUsers`, `AspNetRoles`, `AspNetUserRoles`, `AspNetUserClaims`, `AspNetRoleClaims`, `AspNetUserLogins`, `AspNetUserTokens`) no schema `public` — uma única migration `AddIdentitySchema`.
5. `SeedData.cs`: criar role `super-admin-sistema` + usuário `admin@indiolab.com.br` (senha temporária via env var) em ambiente novo.
6. `CurrentUserService` — nenhuma mudança, claims `sub`/`preferred_username`/`email` permanecem.

**Critério de aceite:**
- `POST /api/auth/login` com seed retorna access+refresh.
- `GET /api/clientes` com `Authorization: Bearer <access>` retorna 200.
- `GET /api/clientes` sem token retorna 401.
- Refresh em endpoint expirado funciona; refresh com token rotacionado falha.

---

### Fase 3 — `erp-web` substitui `keycloak-js`
**Objetivo:** ERP web usa formulário próprio de login.

#### Tarefas
1. `erp-web/package.json`: remover `keycloak-js`.
2. `src/infrastructure/keycloak.ts`: deletar.
3. Reescrever `src/application/contexts/AuthContext.tsx`:
   - Estado: `user`, `accessToken`, `refreshToken`, `isLoading`.
   - `login(email, password)` → POST `/api/auth/login` → guarda em estado + `localStorage` (refresh apenas) ou `sessionStorage` (access).
     - **Decisão de segurança:** access em memória (perdido no refresh da página → re-fetch via refresh); refresh em `httpOnly` cookie seria ideal mas exige backend setando cookie — alternativa: refresh em `localStorage` com expiração curta (7d) e rotação a cada uso.
   - `logout()` → POST `/api/auth/logout` + clear state.
   - `bootstrap()` no mount: se há refresh válido em storage, faz `/auth/refresh` para hidratar `user` + access.
4. Reescrever `src/infrastructure/api/index.ts`:
   - Interceptor de request: lê access do `AuthContext` (via `getAccessToken()` callback registrado pelo provider).
   - Interceptor de response: em 401, chama `/auth/refresh` uma vez; se falhar, dispatcha logout + redireciona `/login`.
5. Criar `src/presentation/pages/auth/LoginPage.tsx`:
   - Form MUI (email, senha, botão "Entrar").
   - Usa `useDialog().error('Credenciais inválidas')` em falha.
6. `src/presentation/routes/AppRoutes.tsx`:
   - Rota pública `/login`.
   - `<RequireAuth>` wrapper redireciona para `/login` quando `!isAuthenticated`.
7. `Sidebar.tsx`: botão de logout → `auth.logout()` + `navigate('/login')`.

**Critério de aceite:**
- Login funciona via form.
- Refresh transparente (deixa página aberta 16+ min, próxima request renova access).
- Logout limpa storage + redireciona.
- Hard refresh com refresh válido restaura sessão.

---

### Fase 4 — `admin-web` idem
Mesmo escopo da Fase 3 aplicado a `admin.dev.indiolab.com.br/admin-web`.

---

### Fase 5 — Hardening (recomendado, pós-cutover)
| Item | Esforço |
|------|---------|
| **Lockout**: 5 tentativas → 15min bloqueio (config nativa do Identity) | Baixo |
| **Reset de senha**: `POST /auth/forgot-password` (envia token por email via SendGrid/SMTP) + `POST /auth/reset-password` | Médio |
| **MFA TOTP**: usa `UserManager.GenerateTwoFactorToken` + QR code no front (Google Authenticator) | Médio |
| **Política de senha**: 10+ chars, maiúscula, número, símbolo (já no Identity) | Baixo |
| **Audit log**: tabela `auth_events` (login, logout, refresh, fail, lockout, password change) | Baixo |
| **Refresh token revogação**: lista de blocked tokens (alternativa: rotação já invalida o anterior) | Baixo |
| **HTTP-only cookie para refresh**: backend seta cookie + frontend não lida com refresh | Médio (mais seguro, mas requer CORS configurado para credentials) |

---

### Fase 6 — Decommission Keycloak

**Concluído:**
- ✅ `erp-web` e `admin-web` não importam mais `keycloak-js` (removido do `package.json`).
- ✅ `erp-api` removeu o JwtBearer apontando pro Keycloak; emite tokens próprios.
- ✅ `docs/PLANO-MIGRACAO-KEYCLOAK.md` arquivado em `docs/archive/`.

**Pendente (fora do escopo desta migração):**
- ⚠️ `crm-api` e `admin-api` ainda usam `IndioLab.Shared.Infrastructure.Keycloak` (KeycloakAdminClient para gerenciar usuários do Keycloak). Esses serviços precisam ser migrados de forma análoga ao `erp-api` antes de remover a pasta `Keycloak/` da shared lib.
- ⚠️ `chat-web` e `crm-web` ainda têm `keycloak-js` (não tocado aqui).
- ⚠️ Diretórios `keycloak/` (binários do servidor) e `keycloak-theme/` (custom theme) na raiz: deletar manualmente quando todos os serviços migrarem. Comando sugerido (após migrar tudo):
  ```bash
  rm -rf keycloak/ keycloak-theme/
  rm -rf indiolab-shared-api/src/IndioLab.Shared.Infrastructure/Keycloak/
  ```
- ⚠️ DNS `auth.apli.indiolab.com.br` e env vars `KEYCLOAK_*` de deploys: remover na rodada de IaC quando o cutover estiver completo.

---

## 4. Riscos e mitigações

| Risco | Mitigação |
|-------|-----------|
| Senha vazada (sem MFA) | Política forte + lockout + Fase 5 (MFA) o quanto antes |
| Roubo de refresh token (XSS) | CSP estrito no front + considerar httpOnly cookie em prod |
| Múltiplos serviços precisam validar JWT | Shared key via secret manager (não commitar `SigningKey` real) |
| Migrar usuários existentes do Keycloak | Script de import: dump users do Keycloak → INSERT em `AspNetUsers` com hash compatível ou senha temporária + reset obrigatório no primeiro login |
| `chat-api`, futuro `crm-api`, `admin-api` precisam do mesmo auth | Já está em `indiolab-shared-api` — basta `AddIndioLabAuthentication` em cada um |

---

## 5. Estimativa

| Fase | Esforço |
|------|---------|
| Fase 1 — Núcleo Auth shared | 1 dia |
| Fase 2 — `erp-api` integra | meio dia |
| Fase 3 — `erp-web` reescreve AuthContext | meio dia |
| Fase 4 — `admin-web` idem | 2h |
| Fase 5 — Hardening (lockout/reset/MFA) | 1-2 dias |
| Fase 6 — Decommission | 2h |
| **Total mínimo (Fases 1-4 + 6):** | **~2,5 dias** |

---

## 6. Decisões pendentes (preciso confirmar)

1. **Algoritmo do JWT:** HS256 (chave simétrica, mais simples) ou RS256 (par RSA, melhor para múltiplos serviços validando)?
   → **Sugestão:** RS256 — chave privada só na API que emite, públicas distribuídas para os outros validarem.
2. **Onde guardar refresh token no front:** `localStorage` (vulnerável a XSS) vs `httpOnly` cookie (mais seguro, mais setup)?
   → **Sugestão:** `localStorage` na Fase 3 (rápido); migrar para httpOnly cookie na Fase 5.
3. **Migração de usuários existentes do Keycloak:** import com reset obrigatório vs recriação manual via admin-web?
   → **Sugestão:** se há <50 usuários, admin recadastra; caso contrário, script de import.
4. **Tempo de access token:** 15min (padrão) ou maior?
   → **Sugestão:** 15min com refresh transparente.
5. **Rate limiting no `/auth/login`:** ASP.NET Core RateLimiter (5 tentativas/min por IP)?
   → **Sugestão:** sim, na Fase 2.
