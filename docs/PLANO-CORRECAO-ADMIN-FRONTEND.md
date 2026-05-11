# Plano de Correção — admin.dev.indiolab.com.br (frontend)

> Plano de execução ordenado por arquivo, agrupado por frente.
> Base do diagnóstico: revisão estática + visual review autenticado (Playwright).
> Todos os caminhos relativos a `admin.dev.indiolab.com.br/admin-web/src/`.

---

## Frente 1 — Tema, locale e infraestrutura visual (BASE)

### `presentation/theme/theme.ts`
- **Adicionar** `localeText` global (não existe hoje) — solução é centralizar no theme via `MuiDataGrid.defaultProps.localeText`. Conteúdo:
  - `MuiTablePagination.labelRowsPerPage: 'Linhas por página:'`
  - `MuiTablePagination.labelDisplayedRows: ({from,to,count}) => '${from}-${to} de ${count !== -1 ? count : 'mais de '+to}'`
  - `noRowsLabel: 'Nenhum registro encontrado'`
- **Remover** `@keyframes shimmer` (~linha 315) — dead code, não é referenciado em nenhum componente.
- **Verificar** (validado pelo MUI MCP) que `MuiButton.contained` segue sem `linear-gradient`. Confirmado OK no review — apenas auditar para garantir.
- **Investigar** quando o DataGrid está em container com `width: 0px` em viewport 375px. Provável causa raiz: `Box (p: 3)` + sidebar fixed aplicado mesmo em mobile. Resolver na Frente 2.

---

## Frente 2 — Layout responsivo (CRÍTICO mobile)

### `presentation/components/layout/Sidebar.tsx`
- Aceitar prop `mode: 'permanent' | 'temporary'` (ou inferir via `useMediaQuery(theme.breakpoints.down('md'))`).
- Em `md+`: comportamento atual (Drawer permanent 280px).
- Em `< md`: Drawer temporary com overlay; abrir via state controlado pelo `MainLayout`.

### `presentation/components/layout/MainLayout.tsx`
- Adicionar state `mobileOpen` + handler `handleDrawerToggle`.
- Passar `open` + `onClose` ao `Sidebar` em modo temporary.
- Renderizar botão hamburger no `Header` apenas em `< md` (via `useMediaQuery`).
- Garantir que o container de conteúdo (`<Outlet />`) ocupa 100% width em mobile (sem `marginLeft` para o drawer).

### `presentation/components/layout/Header.tsx`
- Receber `onMenuClick` opcional. Renderizar `IconButton` com `<MenuIcon />` antes do título quando recebido.
- **A11y:** adicionar `aria-label="Abrir menu"` no hamburger; `aria-label` em todos `IconButton` (toggle tema, notificações, perfil).
- Remover cast `as any` em `theme.palette.accent.rose` (linha ~199) — `accent` está declarado em module augmentation.
- Em `< sm` ocultar o subtitle (4 linhas no 375px).

### Investigação SVG negativo
- Identificar gráfico que emite `<rect width="-28">` em 375px (`PainelPage.tsx` é o suspeito — gráfico de "Últimos Cadastros").
- Provável fix: garantir que o container do chart tem `width >= 0` antes de renderizar (Recharts costuma falhar quando `ResponsiveContainer` recebe altura mas não largura útil).

---

## Frente 3 — 3-dialog pattern (CRÍTICO conformidade)

### Empresas

#### `presentation/EmpresasPage.tsx` (mover para `pages/empresas/EmpresasListPage.tsx`)
- Mover de `presentation/EmpresasPage.tsx` para `presentation/pages/empresas/EmpresasListPage.tsx` (alinhar com convenção `pages/{modulo}/`).
- Atualizar import em `MainLayout.tsx` ou onde estiver registrado.
- DataGrid:
  - Adicionar `paginationMode="server"`, `sortingMode="server"`, `rowCount={data?.totalCount ?? 0}`.
  - Adicionar state `paginationModel`/`sortModel` controlados.
  - Reset `page=0` ao mudar `debouncedSearch`.
  - **Remover coluna `AÇÕES`** (botões editar/excluir inline).
  - `onRowClick` → abre `EmpresaDetailDialog` (NÃO `EmpresaFormDialog`).
- Fix `useCallback` deps: incluir `dialog` (linha ~123) e remover o `eslint-disable`.
- Backend dependência: precisa endpoint `GET /empresas?page=&pageSize=&search=&sortBy=&sortDirection=` retornando `{ items, totalCount, page, pageSize }`. Se hoje é só `GET /empresas` retornando array, abrir tarefa correspondente no admin-api.

#### `presentation/pages/empresas/components/EmpresaDetailDialog.tsx` (NEW)
- Criar componente read-only seguindo padrão do `UsuarioDetailDialog.tsx`.
- Props: `open`, `entityId`, `onClose`, `onEdit(id)`, `onDelete(id, nome)`.
- Fetch via `empresaService.buscarPorId(id)` ao abrir.
- Layout: header com `<Visibility />`, seções idênticas ao FormDialog, footer `Remover` + spacer + `Fechar` + `Editar`.
- Chip `Ativo/Inativo` na linha do Código (ver CLAUDE.md "Layout IDÊNTICO ao FormDialog").

#### `presentation/pages/empresas/components/EmpresaFormDialog.tsx` (existir/refatorar)
- Garantir que segue padrão do `UsuarioFormDialog`.
- Botão "Adicionar logo" — **remover gradient inline**; usar `<Button variant="outlined">` ou `variant="contained"` padrão do tema.
- Botão "Salvar" no footer — remover qualquer `sx` com `linear-gradient` ou `boxShadow` customizado.
- Validação prematura no campo Empresa: só exibir erro após blur ou submit.

### Roles (Perfis de Acesso)

#### `presentation/pages/roles/RolesListPage.tsx`
- DataGrid:
  - Trocar `initialState` por `paginationModel`/`sortModel` controlados.
  - Adicionar `paginationMode="server"`, `sortingMode="server"`, `rowCount`.
  - Backend: `roleService.listarPaginado(page, pageSize, search, sortField, sortDir)` (criar se não existir).
  - **Remover coluna `AÇÕES`**.
  - `onRowClick` → abre `RoleDetailDialog` (NÃO `RoleFormDialog`).
- Texto: trocar título de página/breadcrumb e `noRowsLabel` para "Nenhum perfil encontrado" (já era "Nenhuma role encontrada").

#### `presentation/pages/roles/components/RoleDetailDialog.tsx` (NEW)
- Mesma estrutura do `EmpresaDetailDialog` acima.
- Footer com botões: `Remover` + `Fechar` + `Editar` + (opcional) `Gerenciar Permissões`.

#### `presentation/pages/roles/components/RoleFormDialog.tsx`
- Trocar título: `'Editar Role'` → `'Editar Perfil de Acesso'`; `'Nova Role'` → `'Novo Perfil de Acesso'`.
- Trocar `dialog.success('Role atualizada')` → `'Perfil atualizado com sucesso'`; idem cadastrada.

### Domínios

#### `presentation/DominioCrudView.tsx`
- Adicionar `sortingMode="server"`, `sortModel`, `onSortModelChange`.
- Repassar `sortField`/`sortDirection` para `dominioService.listarPaginado`.
- **Remover coluna `AÇÕES`** se houver (a revisão visual encontrou na DominioCrudView Cores).
- `onRowClick` → abre `DominioDetailDialog` (NEW), não `DominioFormDialog`.
- Código: ajustar formatação para `String(item.codigo).padStart(8, '0')` (hoje está com 4 dígitos).
- `valueFormatter` da coluna Código atualizar para o mesmo padrão.

#### `presentation/components/DominioDetailDialog.tsx` (NEW)
- Read-only genérico para qualquer item de domínio.
- Footer com botões padrão.

#### `presentation/DominiosPage.tsx` + `components/layout/dominiosNav.tsx`
- Mapear slugs para labels human-readable em pt-BR. Sugestão: criar `dominioLabels.ts` exportando `Record<string, string>`:
  - `materiais-tipo` → `Tipos de Material`
  - `niveis-interesse` → `Níveis de Interesse`
  - `tipos-entidade-tag` → `Tipos de Entidade (Tags)`
  - `tipos-item-bom` → `Tipos de Item de BOM`
  - `tipos-lista-material` → `Tipos de Lista de Material`
  - `tipos-operacao-auditoria` → `Tipos de Operação de Auditoria`
  - `tipos-visita` → `Tipos de Visita`
  - (e demais — gerar lista completa lendo `dominiosNav.tsx`)
- Backend opcionalmente já pode expor esse label via `GET /dominios/tipos` (se for fonte única).

---

## Frente 4 — Estilo de botões (conformidade tema)

### Auditar todo `sx={{ background: ... linear-gradient ... }}` em `<Button>`

Comando de auditoria (rodar antes do fix):
```
grep -rn "linear-gradient" presentation/ --include="*.tsx" | grep -i "button\|Button"
```

Locais já identificados:
- `EmpresasPage.tsx` / `EmpresaFormDialog.tsx` — botão "Adicionar logo" e "Salvar"
- `UsuarioFormDialog.tsx` — botão "Salvar" com gradient
- `UsuarioDetailDialog.tsx` — botões "Bloquear", "Desbloquear", "Redefinir Senha", "Gerenciar Roles" com `sx` de border/gradient inline → trocar para `variant="outlined"` + `color`/`startIcon`

**Regra a aplicar:** sempre `<Button variant="contained|outlined">` + `color="primary|error|warning|success"`. Sem `sx` de `background`/`boxShadow`. Theme cuida.

---

## Frente 5 — Pequenos polimentos

### `presentation/auth/LoginPage.tsx`
- Substituir hex hardcoded (linhas ~172-173): `#0D1B21` → `theme.palette.background.default`; `#142730` → `theme.palette.background.paper`.
- Adicionar `slotProps={{ htmlInput: { name: 'email', autoComplete: 'username' } }}` no email; `name: 'password', autoComplete: 'current-password'` no campo de senha — habilita autofill nativo do browser.
- Validar que o `boxShadow` "orbital" está em `Box::before` decorativo (já confirmado OK pelo review).

### `presentation/components/layout/Header.tsx`
- (já citado na Frente 2) — `aria-label` em IconButtons + remover `as any` accent.

### `presentation/pages/usuarios/UsuariosListPage.tsx`
- **Não tocar** — é a referência canônica. Apenas validar que `localeText` global do tema substituiu o local sem quebrar.

### `presentation/pages/painel/PainelPage.tsx`
- Investigar `<rect width="-28">` em 375px (gráfico de Recharts).
- Provável fix: condicionar render do chart a `containerWidth > 0` ou usar `ResponsiveContainer` com `minWidth`.

---

## Ordem de execução sugerida

1. **Tema + locale global** (Frente 1) — base para todas as listas mostrarem paginação em pt-BR de imediato.
2. **Sidebar responsiva** (Frente 2) — destrava mobile.
3. **Backend endpoints** — adicionar `listarPaginado` em `empresaService` e `roleService` (depende do admin-api expor `?page=&pageSize=&...`). **Bloqueador** das próximas etapas.
4. **3-dialog Empresas** (Frente 3 — Empresas) — reaproveita padrão de Usuários como template.
5. **3-dialog Roles** (Frente 3 — Roles) — mesma técnica + i18n "Role" → "Perfil de Acesso".
6. **3-dialog Domínios** (Frente 3 — Domínios) — mais complexo (genérico + labels).
7. **Estilo de botões** (Frente 4) — aplicar varredura de gradient em buttons.
8. **Pequenos polimentos** (Frente 5).
9. **Re-validação visual** via Playwright (mesmo roteiro do review) para confirmar fixes.

---

## Riscos / dependências

- Frente 3 depende de endpoints paginados no `admin-api`. Sem isso, manter client-side temporário **só** se volume real ainda for baixo.
- Sidebar responsiva pode quebrar testes E2E existentes se houver — verificar antes.
- Renomear `EmpresasPage.tsx` → `pages/empresas/EmpresasListPage.tsx` requer ajustar import no router/MainLayout.
- Tradução de "Role" → "Perfil de Acesso" pode aparecer em URL/rota (ex: `/admin/roles`) — manter rota técnica em inglês, mas todos textos visíveis em pt-BR.

---

## Critérios de aceite (DoD)

- [ ] Paginação MUI exibe "Linhas por página" e "X-Y de Z" em todas as ListPages.
- [ ] Sidebar vira Drawer hamburger em viewport `< md`.
- [ ] Em 375px todas ListPages renderizam DataGrid com `width > 0`.
- [ ] Empresas, Perfis e Domínios abrem `*DetailDialog` ao clicar na linha (read-only); coluna "Ações" não existe.
- [ ] FormDialog "Salvar" e demais botões sem gradient/`boxShadow` inline.
- [ ] Nenhum texto visível mostra "Role"; somente "Perfil de Acesso" (URL e código podem manter `role`).
- [ ] Domínios exibem labels human-readable em vez de slugs.
- [ ] Código em Domínios formata 8 dígitos.
- [ ] Console limpo (zero error reais) em todas as telas e breakpoints.
- [ ] Re-run do Playwright review confirma os 6 itens críticos resolvidos.
