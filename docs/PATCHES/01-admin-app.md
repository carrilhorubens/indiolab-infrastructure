# Patch F1 — Admin App (frontend + backend)

> Frente da sessão anterior. Locale pt-BR DataGrid global, sidebar responsiva, 3-dialog pattern, server-side pagination Empresas/Roles.

## Escopo

**Frontend (admin-web):**
- `theme.ts`: import `ptBR` de `@mui/x-data-grid/locales` + 2º arg em `createTheme`; removido `@keyframes shimmer` dead code
- Layout responsivo: `Sidebar` Drawer temporary em mobile, hamburger no `Header`, `MainLayout` width responsivo
- `aria-label` em IconButtons; subtitle escondido em xs
- 3-dialog pattern: `EmpresaDetailDialog`, `RoleDetailDialog` (NEW); row click → DetailDialog; coluna "Ações" removida
- i18n: "Role" → "Perfil de Acesso"
- Server-side pagination em `EmpresasPage` e `RolesListPage` com `paginationMode="server"` + `sortingMode="server"`
- Login: `slotProps.htmlInput` com `name`/`autoComplete`; theme tokens em vez de hex hardcoded

**Backend (admin-api):**
- `EmpresasController.Listar` aceita `page`/`pageSize`/`sortBy`/`sortDirection` (backward-compat: array sem params)
- `RolesController.Listar` idem + busca `search`
- `EmpresaService.ListarPaginadoAsync` + whitelist sort (anti-SQLi)
- `RoleService.ListarPaginadoAsync` + LINQ allowlist sort
- `PagedResult<T>` reutilizado de `UserDtos.cs`

## Arquivos

### Frontend admin-web
```
admin.dev.indiolab.com.br/admin-web/src/presentation/theme/theme.ts
admin.dev.indiolab.com.br/admin-web/src/presentation/components/layout/Sidebar.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/components/layout/MainLayout.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/components/layout/Header.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/EmpresasPage.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/DominioCrudView.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/auth/LoginPage.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/pages/empresas/components/EmpresaDetailDialog.tsx        # NEW
admin.dev.indiolab.com.br/admin-web/src/presentation/pages/roles/RolesListPage.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/pages/roles/components/RoleDetailDialog.tsx              # NEW
admin.dev.indiolab.com.br/admin-web/src/presentation/pages/roles/components/RoleFormDialog.tsx
admin.dev.indiolab.com.br/admin-web/src/presentation/pages/usuarios/UsuariosListPage.tsx
admin.dev.indiolab.com.br/admin-web/src/infrastructure/empresaService.ts
admin.dev.indiolab.com.br/admin-web/src/infrastructure/roleService.ts
admin.dev.indiolab.com.br/admin-web/src/application/AuthContext.tsx
```

### Backend admin-api
```
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/Controllers/EmpresasController.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/Controllers/RolesController.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/Controllers/UsuariosController.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/Controllers/PermissionsCatalogController.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/DependencyInjection.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Persistence/AdminDbContext.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/EmpresaService.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/RoleService.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/RolePermissionsOrchestrator.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/UsuarioService.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/RoleDtos.cs
admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/Services/UserDtos.cs
```

## Comando git

```bash
git add admin.dev.indiolab.com.br/admin-web/src/ \
        admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.API/Controllers/ \
        admin.dev.indiolab.com.br/admin-api/src/IndioLab.Admin.Infrastructure/

# verificar
git status
git diff --cached --stat
```

## Mensagem de commit sugerida

```
feat(admin): hardening UX/UI + paginação server-side

Frontend (admin-web):
- locale pt-BR via createTheme(opts, dataGridPtBR) + remoção de @keyframes shimmer dead code
- sidebar responsiva (Drawer temporary em mobile + hamburger + auto-close em nav)
- aria-label em IconButtons; subtitle escondido em xs; ícone título xs:none
- 3-dialog pattern: EmpresaDetailDialog/RoleDetailDialog read-only; row click → Detail; remoção da coluna "Ações"
- i18n: "Role" → "Perfil de Acesso"
- server-side pagination em EmpresasPage + RolesListPage (paginationMode="server" + sortingMode="server")
- LoginPage: slotProps.htmlInput name+autoComplete; theme tokens em vez de hex hardcoded

Backend (admin-api):
- EmpresasController.Listar + RolesController.Listar aceitam page/pageSize/sortBy/sortDirection
- EmpresaService.ListarPaginadoAsync + RoleService.ListarPaginadoAsync com whitelist de sort (anti-SQLi)
- backward-compat: sem params → array original

Validado: tsc clean, login funcional, 0 console errors, breakpoints 375/768/1024/1440 OK.
```

## Pré-condições

- Os subdiretórios `admin.dev.indiolab.com.br/admin-web/` e `admin-api/` já estão untracked (parte da reestruturação maior). Este patch assume que a reestruturação será comitada antes ou junto.
- Se preferir commit isolado: `git add` apenas os arquivos modificados desta lista (não o diretório inteiro).

## Validação pós-commit

```bash
cd admin.dev.indiolab.com.br/admin-web && npx tsc --noEmit
cd ../admin-api && dotnet build src/IndioLab.Admin.API/IndioLab.Admin.API.csproj
```
