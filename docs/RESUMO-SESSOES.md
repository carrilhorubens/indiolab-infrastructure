# Resumo de Sessões — OpticalCore ERP

> Registro das sessões de desenvolvimento assistido por IA.

---

## Sessão 2026-02-20 — Correção de Acentuação pt-BR

**Commit:** `ca0d934`
**Branch:** `main`

### O que foi feito

1. **Varredura completa do frontend** — 53 arquivos TypeScript/TSX analisados para identificar textos em Português Brasileiro sem acentuação correta.

2. **22 correções de acentuação** em 5 arquivos:

   | Arquivo | Correções |
   |---------|-----------|
   | `DashboardPage.tsx` | "Laboratórios Ópticos" |
   | `CompanySelectorDialog.tsx` | "disponível" |
   | `EmpresasListPage.tsx` | "Código", "Razão Social", "Ações", "página", "ação não" |
   | `EmpresaFormDialog.tsx` | 14 correções (labels, validações, seções) |
   | `AppRoutes.tsx` | "páginas" (comentário) |

3. **Documentação criada/atualizada:**
   - `CLAUDE.md` — Criado na raiz do projeto com todas as regras de desenvolvimento, incluindo acentuação obrigatória em pt-BR
   - `docs/PLANO-ERP-GENERICO.md` — Regra de acentuação adicionada na seção 11 (Convenções de Código)

### Regra estabelecida

> **OBRIGATÓRIO:** Todos os textos visíveis ao usuário no frontend (labels, placeholders, mensagens de erro/validação, títulos, tooltips, headers de tabela) devem utilizar acentuação correta em Português Brasileiro (á, é, í, ó, ú, ã, õ, ç, â, ê, ô).

---

## Sessão 2026-02-20 — Padronização de Layout de Páginas

**Branch:** `main`

### Problema identificado

A página `configuracoes/empresas` apresentava:
1. Header global exibindo "OpticalCore" (fallback) ao invés de "Empresas" — rota desatualizada no `routeTitles` (`/configuracoes/companies` → `/configuracoes/empresas`)
2. Ícone ausente no header global
3. Título + subtítulo duplicados (header global + header interno da página)
4. Botão "+ Nova Empresa" duplicado (barra de busca + EmptyState)

### O que foi feito

1. **`MainLayout.tsx`** — Corrigida rota no `routeTitles` e adicionado suporte a ícones (`icon`) por rota
2. **`Header.tsx`** — Adicionada renderização do ícone (box com gradiente) ao lado do título
3. **`EmpresasListPage.tsx`** — Removido header duplicado (ícone + título + subtítulo), movido botão para dentro do `Paper` da busca, removido botão duplicado do `EmptyState`
4. **`CLAUDE.md`** — Documentados 2 novos padrões obrigatórios:
   - Layout de páginas (Header global centraliza ícone + título + subtítulo)
   - Padrão de listagem (busca + botão no mesmo `Paper`, EmptyState sem botão duplicado)
5. **`docs/PLANO-ERP-GENERICO.md`** — Regras adicionadas na seção de convenções

### Padrões estabelecidos

> **Layout de Páginas:** O `Header.tsx` (via `MainLayout`) é o único responsável por ícone + título + subtítulo. Páginas nunca duplicam. Toda rota deve ser registrada no `routeTitles` com `title`, `subtitle` e `icon`.

> **Padrão de Listagem:** Busca e botão de ação principal ficam juntos no mesmo `Paper`. O `EmptyState` não contém botão de ação duplicado.

---

## Sessão 2026-02-20 — CRUD de Usuários + Convenção de Idioma

**Branch:** `main`

### O que foi feito

1. **CRUD de Usuários (frontend completo)** — Backend já existia (`UsersController`, CQRS, DTOs). Criado todo o módulo frontend:

   | Arquivo | Descrição |
   |---------|-----------|
   | `domain/usuarios/usuario.types.ts` | Types espelhando DTOs do backend |
   | `infrastructure/api/usuarioService.ts` | Serviço API (listar, buscar, criar, atualizar, excluir, resetar senha, listar roles) |
   | `pages/configuracoes/usuarios/UsuariosListPage.tsx` | Página de listagem com busca, paginação, tabela e ações |
   | `pages/configuracoes/usuarios/components/UsuarioFormDialog.tsx` | Dialog de criação/edição com seções (Identificação, Contato, Permissões) |
   | `routes/AppRoutes.tsx` | Adicionada rota `configuracoes/usuarios` |

2. **Investigação de nomenclatura backend** — Analisados 22 arquivos backend com "User/Users". Renomear quebraria ASP.NET Identity (`ApplicationUser extends IdentityUser<Guid>`).

3. **Verificação de arquivos em português no backend** — Confirmado que entidades de domínio de negócio (Pessoa, Contato, Endereço, Domínios) estão corretamente em português, enquanto infraestrutura (User, Company, Role) permanece em inglês.

4. **Convenção de idioma documentada no `CLAUDE.md`:**

### Convenção estabelecida

> **Backend (C#):** Inglês para infraestrutura e CQRS (User, Company, Role). Português para entidades de domínio de negócio (Produto, Pedido, Pessoa).
>
> **Frontend (TypeScript):** Português para tudo — nomes de arquivos, types, services, páginas. Textos visíveis ao usuário sempre em pt-BR com acentuação correta.

---

## Sessão 2026-02-20 — Melhorias Empresas, Usuários e Padrões de Campos

**Branch:** `main`

### O que foi feito

#### 1. Padrão Código 8 dígitos com zero-padding
- **Empresas e Usuários:** Campo Código com máscara de 8 dígitos numéricos, preenchimento automático com zeros à esquerda (`padStart(8, '0')`) no `onBlur`
- **Datatable de Usuários:** Exibição do Código com zero-padding
- **Documentação:** Padrão documentado no `CLAUDE.md` para futuras implementações

#### 2. Associação Usuário-Empresa
- **UsuarioFormDialog:** Autocomplete para associar usuário a uma empresa (busca empresas ativas via `empresaService.listarAtivas()`)
- Integração com toggle `acessoMultiempresas` (desabilita seleção quando multi-empresa está ativo)

#### 3. Filtro por Empresa e CNPJ na lista de Usuários
- **Backend:** Adicionado `EmpresaId` ao `GetUsersQuery`, `EmpresaNomeFantasia` e `EmpresaCnpj` ao `UserListDto`, filtro e join com Companies no `UserService`
- **Frontend:** Autocomplete de filtro por empresa na barra de busca, coluna "Empresa" no datatable mostrando nome fantasia + CNPJ

#### 4. CEP com busca online (ViaCEP)
- **Utilitário criado:** `application/utils/cep.ts` — `limparCep`, `formatarCep`, `buscarCep` (API ViaCEP)
- **EmpresaFormDialog:** Máscara no `onChange`, busca automática no `onBlur`, auto-preenchimento de Endereço/Bairro/Cidade/UF, indicador CircularProgress

#### 5. Campos Complemento e Bairro (full-stack)
- **Complemento:** Adicionado em toda a stack (Entity, DbContext, Commands, Validators, Handlers, DTOs, Service, Migration, frontend types e form)
- **Bairro:** Mesmo tratamento full-stack — 10 arquivos backend + 2 frontend

#### 6. Layout da seção Endereço
- CEP: `sm: 3` (1/4 da linha)
- Endereço: `xs: 12` (linha inteira, editável)
- Complemento: `xs: 12` (linha inteira, editável)
- Bairro (`sm: 4`) + Cidade (`sm: 6`) + UF (`sm: 2`): mesma linha, `readOnly` (preenchidos pelo CEP)

#### 7. Utilitário CNPJ
- `application/utils/cnpj.ts` — `limparCnpj`, `formatarCnpj`, `validarCnpj` (validação algorítmica)

### Arquivos modificados

| Camada | Arquivos |
|--------|----------|
| **Backend Domain** | `Company.cs` (+Complemento, +Bairro) |
| **Backend Application** | `CreateCompanyCommand/Validator/Handler`, `UpdateCompanyCommand/Handler`, `ICompanyService.cs`, `CompanyDtos.cs`, `GetUsersQuery/Handler`, `UserDtos.cs`, `IUserService.cs` |
| **Backend Infrastructure** | `ApplicationDbContext.cs`, `CompanyService.cs`, `UserService.cs`, Migration regenerada |
| **Frontend Types** | `empresa.types.ts`, `usuario.types.ts` |
| **Frontend Services** | `empresaService.ts`, `usuarioService.ts` |
| **Frontend Pages** | `EmpresaFormDialog.tsx`, `UsuarioFormDialog.tsx`, `UsuariosListPage.tsx` |
| **Frontend Utils** | `cep.ts` (novo), `cnpj.ts` (novo) |
| **Config** | `CLAUDE.md`, `AppRoutes.tsx`, `Sidebar.tsx` |

### Padrões estabelecidos

> **Campo Código:** 8 dígitos numéricos, `handleCodigoChange` (digits only, max 8), `handleCodigoBlur` (`padStart(8, '0')`), `inputMode: 'numeric'`, placeholder `00000000`. No datatable: `String(codigo).padStart(8, '0')`.

> **Campo CEP:** Máscara `00000-000` no `onChange`, busca ViaCEP no `onBlur`, auto-preenche Endereço/Bairro/Cidade/UF. Campos auto-preenchidos usam `readOnly: true` (aparência normal, não editáveis).

---

## Sessão 2026-02-20 — Layout Identificação + Correção Schema PostgreSQL + CRUD Roles

**Branch:** `main`

### O que foi feito

#### 1. Layout da seção Identificação (EmpresaFormDialog)
- **Código** sozinho na linha (`xs: 12, sm: 4`) com Grid espaçador invisível (`sm: 8`, `display: none` no mobile) para forçar quebra de linha
- **Razão Social** + **Nome Fantasia** na mesma linha (`xs: 12, sm: 6` cada)
- **CNPJ** + **Inscrição Estadual** na mesma linha (`xs: 12, sm: 6` cada)

#### 2. Correção de bug no TenantSchemaService (Schema PostgreSQL)
O schema-per-tenant usa dígitos do CNPJ como nome do schema (ex: `79029021000190`). PostgreSQL requer aspas duplas para identificadores numéricos.

Três correções:
- `CREATE SCHEMA IF NOT EXISTS {schemaName}` → `CREATE SCHEMA IF NOT EXISTS "{schemaName}"`
- `DROP SCHEMA IF EXISTS {schemaName} CASCADE` → `DROP SCHEMA IF EXISTS "{schemaName}" CASCADE`
- **SQL Injection** em `SchemaExistsAsync`: string concatenada → query parametrizada (`@schemaName`)

#### 3. CRUD de Roles (frontend completo)
Backend já existia (`RolesController`, CQRS, DTOs). Criado módulo frontend:

| Arquivo | Descrição |
|---------|-----------|
| `domain/roles/role.types.ts` | Types espelhando DTOs do backend |
| `infrastructure/api/roleService.ts` | Serviço API (listar, buscar, criar, atualizar, excluir) |
| `pages/configuracoes/roles/RolesListPage.tsx` | Página de listagem com busca, paginação e ações |
| `pages/configuracoes/roles/components/RoleFormDialog.tsx` | Dialog de criação/edição |

#### 4. Documentação Multi-Tenant
- `docs/MULTI_TENANT_ARCHITECTURE.md` — Documentação completa da arquitetura schema-per-tenant

### Arquivos modificados/criados

| Camada | Arquivos |
|--------|----------|
| **Backend Infrastructure** | `TenantSchemaService.cs` (aspas duplas + query parametrizada) |
| **Frontend Layout** | `EmpresaFormDialog.tsx` (reordenação Identificação + espaçador Grid) |
| **Frontend Roles** | `role.types.ts`, `roleService.ts`, `RolesListPage.tsx`, `RoleFormDialog.tsx` (novos) |
| **Documentação** | `MULTI_TENANT_ARCHITECTURE.md` (novo) |

### Padrão estabelecido

> **Grid espaçador para campo sozinho na linha:** Quando um campo ocupa menos de 12 colunas e deve ficar sozinho, adicionar `<Grid size={{ sm: N }} sx={{ display: { xs: 'none', sm: 'block' } }} />` após ele, onde N = 12 - tamanho do campo.

---

## Sessão 2026-02-20 — Domínios: Sidebar 3 Níveis, Remoção de Campos, Codigo Auto-Incremento

**Branch:** `main`

### O que foi feito

#### 1. Sidebar com navegação de 3 níveis para Domínios
- Menu lateral com categorias expansíveis: Pessoa, Trabalhista, Fiscal, Financeiro
- Cada categoria lista seus domínios como subitens clicáveis
- Navegação direta para `/dominios/:contexto/:tipo` (ex: `/dominios/pessoa/generos`)

#### 2. Páginas de CRUD para Domínios (frontend completo)
- **`DominiosPage.tsx`** — Página de listagem com tabela, botão novo, edição, toggle ativo/inativo
- **`DominioFormDialog.tsx`** — Dialog de criação/edição com campos Descrição, Descrição Curta, Padrão
- **`DominioTabPanel.tsx`** — Componente accordion para exibição agrupada de domínios

#### 3. CRUD Genérico no Backend
- **`DominiosController.cs`** — Controller com endpoints GET individuais para 21 domínios + CRUD genérico (POST/PUT/PATCH toggle-active) usando switch expressions e reflexão

#### 4. Remoção do campo `Ordem` de todas as entidades de domínio
- Removido de `BaseDominio.cs`, 21 entidades, 21 seeds, controller, DTOs, frontend
- Migration regenerada

#### 5. Remoção do campo `CodigoExterno` de todas as entidades de domínio
- Mesmo padrão: `BaseDominio.cs`, 21 entidades, 21 seeds, controller, DTOs, DbContexts, frontend
- Migration regenerada

#### 6. Campo `Codigo` alterado de `string` para `int` auto-incremento
- **`BaseDominio.cs`** — `string Codigo` → `int Codigo`
- **21 entidades** — Removido `string codigo` do `Create()` e `Codigo = codigo.ToUpperInvariant()`
- **21 seeds** — Removido primeiro argumento string (102 chamadas `Create()`)
- **`ApplicationDbContext.cs`** e **`TenantDbContext.cs`** — `HasMaxLength(20)` → `ValueGeneratedOnAdd()`
- **`DominiosController.cs`** — `DominioDto.Codigo`: `string` → `int`; `CreateDominioRequest` sem `Codigo`
- **`AuditService.cs`** — Lookup por `Descricao` em vez de `Codigo` (agora `int`)
- **Frontend** — `codigo: string` → `codigo: number`; exibição com `padStart(8, '0')`; campo removido do formulário
- **`CLAUDE.md`** — Documentados dois cenários: manual (negócio) e auto-incremento (domínio)

#### 7. Correção: 6 endpoints GET faltantes no DominiosController
Domínios adicionados posteriormente não tinham endpoint GET de listagem:
- `tipos-contato`, `tipos-endereco`, `tipos-movimentacao`, `tipos-dependente`, `tipos-operacao-auditoria`, `tipos-entidade-tag`

### Arquivos modificados/criados

| Camada | Arquivos |
|--------|----------|
| **Backend Domain** | `BaseDominio.cs`, 21 entidades de domínio (Genero, TipoPessoa, etc.) |
| **Backend API** | `DominiosController.cs` (CRUD genérico + 21 GET endpoints) |
| **Backend Infrastructure** | `ApplicationDbContext.cs`, `TenantDbContext.cs`, `AuditService.cs`, 21 seeds, migrations regeneradas |
| **Frontend Types** | `dominio.types.ts`, `dominioService.ts` |
| **Frontend Pages** | `DominiosPage.tsx`, `DominioFormDialog.tsx`, `DominioTabPanel.tsx` (novos) |
| **Frontend Layout** | `Sidebar.tsx` (3 níveis), `MainLayout.tsx` (rotas), `AppRoutes.tsx` |
| **Documentação** | `CLAUDE.md` (campo Código auto-incremento para domínios) |

### Padrões estabelecidos

> **Entidades de Domínio (BaseDominio):** Campo `Codigo` é `int` com `ValueGeneratedOnAdd()` (auto-incremento). Não aparece no formulário de criação. Exibido com `padStart(8, '0')` nas tabelas.

> **CRUD Genérico de Domínios:** Um único controller (`DominiosController`) atende todas as 21 entidades usando switch expressions para roteamento por tipo.

---

## Sessão 2026-02-23 — Módulo Pessoas (Party Pattern) + Código Auto-Incremental

**Commits:** `c998396`, `9fa1b62`
**Branch:** `main`

### O que foi feito

#### 1. Módulo Pessoas — CRUD Clientes, Fornecedores, Funcionários (Party Pattern)

Full-stack completo para os 3 papéis do Party Pattern:

| Entidade | Backend | Frontend | Campos específicos |
|----------|---------|----------|--------------------|
| **Cliente** | Controller, Commands, Queries, Handlers, Validators, Service, DTOs | Types, Service, ListPage, FormDialog | LimiteCredito, Inadimplente, DataNascimento, IndicadorIe, ConsumidorFinal, PrazoPagamento |
| **Fornecedor** | Controller, Commands, Queries, Handlers, Validators, Service, DTOs | Types, Service, ListPage, FormDialog | ContatoRepresentante, TelefoneRepresentante, EmailRepresentante, CNAE, RegimeTributacao, Banco/Agência/Conta/Pix, PrazoPagamento |
| **Funcionário** | Controller, Commands, Queries, Handlers, Validators, Service, DTOs | Types, Service, ListPage, FormDialog | NIS, CTPS, CBO, Cargo, Departamento, DataAdmissão, Salário, TipoContrato, RegimeJornada, dados eSocial completos |

- **Pessoa** é a entidade central (CPF/CNPJ, Nome, Endereço, Contato)
- **Cliente/Fornecedor/Funcionário** são papéis (role tables) com FK 1:1 para Pessoa
- Reuso de Pessoa: se CPF/CNPJ já existe, cria apenas o novo papel

#### 2. Fix: DateTime Kind=Unspecified (Npgsql 6+)

- **Problema:** Npgsql 6+ rejeita `DateTime` com `Kind=Unspecified` para colunas `timestamp with time zone`
- **Fix:** `AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true)` em `Program.cs`
- **Fix adicional:** `.ConfigureWarnings(w => w.Ignore(RelationalEventId.PendingModelChangesWarning))` em `DependencyInjection.cs` (falso positivo do EF Core)

#### 3. Código Auto-Incremental em Cliente, Fornecedor e Funcionário

Migração do campo `Codigo` de entrada manual para auto-incremento (mesmo padrão de BaseDominio):

| Camada | Alteração |
|--------|-----------|
| **Domain** | Removido `int codigo` de `Create()` em Cliente, Fornecedor, Funcionário |
| **Application** | Removido `Codigo` de Commands, Handlers, Validators, ServiceRequests |
| **Infrastructure** | `ValueGeneratedOnAdd()` no TenantDbContext; `GENERATED BY DEFAULT AS IDENTITY` no SQL de migração (6 ocorrências) |
| **Frontend** | Removido campo Código dos FormDialogs (FormData, handlers, validação, TextField, API call) e dos types (CriarXxxRequest) |

### Arquivos modificados/criados

| Camada | Arquivos |
|--------|----------|
| **Backend Domain** | `Pessoa.cs`, `Endereco.cs`, `Contato.cs`, `Cliente.cs`, `Fornecedor.cs`, `Funcionario.cs`, `Cargo.cs`, `Departamento.cs`, `Tag.cs`, `PessoaTag.cs` |
| **Backend API** | `PessoasController.cs`, `ClientesController.cs` (novos) — FornecedoresController e FuncionariosController incluídos |
| **Backend Application** | Commands/Queries/Handlers/Validators/DTOs para Clientes, Fornecedores, Funcionários + PessoaDtos |
| **Backend Infrastructure** | `TenantDbContext.cs`, `TenantSchemaService.cs`, `ClienteService.cs`, `FornecedorService.cs`, `FuncionarioService.cs`, `PessoaService.cs`, `DependencyInjection.cs` |
| **Backend API Config** | `Program.cs` (Npgsql legacy timestamp) |
| **Frontend Types** | `pessoa.types.ts`, `cliente.types.ts`, `fornecedor.types.ts`, `funcionario.types.ts` |
| **Frontend Services** | `pessoaService.ts`, `clienteService.ts`, `fornecedorService.ts`, `funcionarioService.ts` |
| **Frontend Pages** | `ClientesListPage.tsx`, `ClienteFormDialog.tsx`, `FornecedoresListPage.tsx`, `FornecedorFormDialog.tsx`, `FuncionariosListPage.tsx`, `FuncionarioFormDialog.tsx` |
| **Frontend Utils** | `cpfCnpj.ts` (validação e formatação CPF/CNPJ) |
| **Frontend Layout** | `Sidebar.tsx`, `MainLayout.tsx`, `AppRoutes.tsx` |

### Padrões estabelecidos

> **Party Pattern:** Pessoa é a entidade central. Papéis (Cliente, Fornecedor, Funcionário) são tabelas separadas com FK 1:1 para Pessoa. Se CPF/CNPJ já existe, reutiliza a Pessoa e cria apenas o novo papel.

> **Campo Código (Cenário 2 — Auto-incremento):** Aplica-se agora também a Cliente, Fornecedor e Funcionário (não apenas BaseDominio). Campo não aparece no formulário de criação, é gerado pelo banco (`GENERATED BY DEFAULT AS IDENTITY`), exibido read-only nas listagens com `padStart(8, '0')`.

> **Npgsql DateTime:** `AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true)` em `Program.cs` para aceitar `DateTime` com `Kind=Unspecified`.

---

## Sessão 2026-02-23 — Padronização de Layout para Todas as Páginas

**Branch:** `main`

### O que foi feito

Replicação do padrão de layout profissional (já implementado em Clientes, Fornecedores, Funcionários) para **todas** as páginas restantes: Empresas, Usuários, Roles, Pessoas e Domínios.

#### 1. DetailDialogs criados (4 novos componentes)

| Componente | Seções read-only |
|------------|-----------------|
| `EmpresaDetailDialog.tsx` | Identificação (Código, Razão Social, Nome Fantasia, CNPJ, IE, Status), Contato, Endereço, Informações (Schema, Criado em, Atualizado em) |
| `UsuarioDetailDialog.tsx` | Identificação (Código, Nome, E-mail, Telefone, Status), Acesso (Empresa, Multiempresas, Perfis como chips), Permissões (chips), Informações (Criado em, Último acesso) |
| `RoleDetailDialog.tsx` | Identificação (Nome, Descrição, Tipo Sistema/Personalizado, Status), Permissões agrupadas por módulo (chips). Botões Editar/Remover ocultos para perfis do sistema |
| `PessoaDetailDialog.tsx` | Identificação (Tipo Pessoa, Nome, CPF/CNPJ, RG, IE, IM, Status), Contato, Endereço, Observações. Genérico com `contextoLabel` |

#### 2. ListPages atualizadas (5 páginas)

| Página | Mudanças aplicadas |
|--------|--------------------|
| **EmpresasListPage** | +KPIs (Total, Ativas), +TableSortLabel (5 colunas), +zebra-striping, +row click → DetailDialog, +barra de informações, -coluna Ações |
| **UsuariosListPage** | +KPIs (Total, Ativos), +TableSortLabel (4 colunas), +zebra-striping, +row click → DetailDialog, +barra de informações, -coluna Ações. Mantém Autocomplete de empresa |
| **RolesListPage** | +KPIs (Total, Ativos, Sistema), +TableSortLabel (nome, permissões), +zebra-striping, +row click → DetailDialog, +barra de informações, -coluna Ações. Sem paginação (API retorna tudo) |
| **PessoasListPage** | +KPIs (Total, Ativos), +TableSortLabel (4 colunas), +zebra-striping, +row click → DetailDialog, +barra de informações, -coluna Ações |
| **DominiosPage** | +Paper com busca + KPIs (Total, Ativos) + botão Novo, +TableSortLabel (Código, Descrição), +zebra-striping, +row click → FormDialog (editar), +busca local, +barra de informações, +filtro toggle ativos/inativos. Mantém coluna Ações (Editar + Toggle com stopPropagation) |

#### 3. Padrão visual unificado em todas as páginas

Todas as páginas agora seguem o mesmo layout:
```
Paper (busca + KPIs clicáveis + botão "Novo")
Barra de informações ("Exibindo X de Y")
Tabela (TableSortLabel + zebra-striping + row click)
DetailDialog (read-only) ou FormDialog (Domínios)
FormDialog (criação/edição)
ConfirmDialog (exclusão)
```

### Arquivos criados

| Arquivo |
|---------|
| `configuracoes/empresas/components/EmpresaDetailDialog.tsx` |
| `configuracoes/usuarios/components/UsuarioDetailDialog.tsx` |
| `configuracoes/roles/components/RoleDetailDialog.tsx` |
| `pessoas/components/PessoaDetailDialog.tsx` |

### Arquivos modificados

| Arquivo | Natureza |
|---------|----------|
| `EmpresasListPage.tsx` | Padrão completo (KPIs, sort, zebra, DetailDialog) |
| `UsuariosListPage.tsx` | Padrão completo (KPIs, sort, zebra, DetailDialog) |
| `RolesListPage.tsx` | Padrão completo (KPIs, sort, zebra, DetailDialog) |
| `PessoasListPage.tsx` | Padrão completo (KPIs, sort, zebra, DetailDialog) |
| `DominiosPage.tsx` | Paper busca + KPIs + sort + zebra + row click |

### Padrão estabelecido

> **Layout padrão de ListPage:** Toda página de listagem segue a arquitetura de 3 dialogs com KPIs clicáveis (toggle filtro), TableSortLabel, zebra-striping, row click → DetailDialog (read-only) com footer (Remover + Fechar + Editar), e barra de informações com count filtrado. Referência canônica: `ClientesListPage.tsx` + `ClienteDetailDialog.tsx`.

---

## Sessão 2026-02-25 — Módulo de Estoque: Fase 1 (MVP) + Fase 2 (Operacional)

**Commits:** `1610987`, `8750958`, `bd33715`
**Branch:** `main`

### O que foi feito

#### Fase 1 — MVP (commit `1610987`)
6 entidades tenant + 3 domínios públicos para o módulo de estoque:

| Entidade | Tipo | Descrição |
|----------|------|-----------|
| Produto | Tenant | Cadastro mestre (SKU, código de barras, NCM, custo, preço, limites de estoque) |
| CategoriaProduto | Tenant | Hierárquica com auto-referência (pai/filho) |
| Depósito | Tenant | Armazéns/almoxarifados |
| Localização | Tenant | Endereços dentro dos depósitos |
| MovimentacaoEstoque | Tenant | Registro imutável (append-only) de entradas, saídas, transferências e ajustes |
| EstoqueSaldo | Tenant | Projeção materializada com custo médio ponderado |
| TipoProduto | Público | Domínio |
| MotivoAjuste | Público | Domínio |
| TipoMovimentacaoEstoque | Público | Domínio (SEPARADO de TipoMovimentacao RH) |

#### Fase 2 — Operacional (commit `bd33715`)
5 entidades tenant + relatórios para capacidades operacionais avançadas:

| Entidade | Tipo | Descrição |
|----------|------|-----------|
| Lote | Tenant | Rastreabilidade por lote de fabricação (validade, fornecedor) |
| NumeroSerie | Tenant | Rastreabilidade individual por unidade |
| ReservaEstoque | Tenant | Reservas de saldo para documentos (vendas, produção) |
| InventarioFisico + Item | Tenant | Contagem física com auto-população e geração de ajustes |
| OrdemTransferencia + Item | Tenant | Workflow Rascunho→Aprovada→EmTransito→Recebida |

Relatórios: Estoque Mínimo, Lotes Vencendo.

---

## Sessão 2026-02-26 — Módulo de Estoque: Fase 3 (Avançado)

**Branch:** `main`

### O que foi feito

Implementação completa da Fase 3 do módulo de estoque — capacidades avançadas com 5 novas entidades, 6 controllers, 5 services, dashboard com KPIs e 6 migrations.

#### 1. ClasseABC no Produto
- Campo `ClasseABC` (varchar 1) adicionado à entidade `Produto`
- Método `AtualizarClasseABC()` para atualização programática
- Migration: `AddClasseAbcToProduto` (ALTER TABLE)

#### 2. ConversaoUnidadeMedida
- Fatores de conversão entre unidades (ex: Caixa → Unidade = 12)
- Conversão global (ProdutoId = null) ou específica por produto
- UNIQUE: (OrigemId, DestinoId, ProdutoId)
- Frontend: ListPage + FormDialog + DetailDialog com 3 KPIs

#### 3. ProdutoCodigoBarras
- Múltiplos códigos de barras por produto (EAN13, Code128, QRCode, Interno)
- Flag `Principal` para código padrão
- Endpoint `buscar-por-codigo` para lookup reverso
- UNIQUE: (ProdutoId, CodigoBarras)

#### 4. ProdutoFornecedor
- Many-to-many entre Produto e Fornecedor com dados comerciais
- CustoUnitario, LeadTimeDias, QuantidadeMinimaPedido, CodigoNoFornecedor
- Flag `Principal` para fornecedor preferencial
- Frontend: ListPage + FormDialog + DetailDialog

#### 5. Curva ABC (Cálculo + Relatório)
- `CalcularCurvaAbcAsync()` no ProdutoService
- Query MovimentacoesEstoque confirmadas de saída no período
- Classificação: A (≤80%), B (80-95%), C (>95%)
- Atualiza `Produto.ClasseABC` para cada produto
- Frontend: CurvaAbcPage com BarChart + PieChart (@mui/x-charts)

#### 6. EstoqueSaldoHistorico
- Entidade write-once (sem BaseAuditableEntity, sem soft delete)
- Snapshots de saldo em data específica
- `GerarSnapshotAsync()` copia EstoqueSaldo atual para histórico
- Frontend: SaldoHistoricoPage com filtros + botão "Gerar Snapshot"

#### 7. EstoqueConsignado
- FK polimórfica via `TipoProprietario` ("Fornecedor"/"Cliente") + `ProprietarioId`
- Sem FK no banco (mesmo padrão ReservaEstoque.DocumentoOrigemTipo)
- ContratoRef, DataInicio, DataFim
- Frontend: ListPage com seleção dinâmica de proprietário

#### 8. Dashboard KPIs
- Reescrita completa de `DashboardPage.tsx`
- 18 KPIs agregados via `DashboardEstoqueController`
- 3 gráficos: BarChart (movimentações), PieChart (curva ABC), LineChart (tendência 12 meses)
- Alertas coloridos por gravidade
- Seção de estoque consignado

### Arquivos criados (Backend: ~23, Frontend: ~18)

| Camada | Arquivos |
|--------|----------|
| **Domain/Entities** | ConversaoUnidadeMedida, ProdutoCodigoBarras, ProdutoFornecedor, EstoqueSaldoHistorico, EstoqueConsignado |
| **Application/Interfaces** | IConversaoUnidadeMedidaService, IProdutoCodigoBarrasService, IProdutoFornecedorService, IEstoqueSaldoHistoricoService, IEstoqueConsignadoService |
| **Infrastructure/Services** | 5 implementações |
| **API/Controllers** | ConversoesUnidadeMedida, ProdutoCodigosBarras, ProdutoFornecedores, EstoqueSaldoHistorico, EstoqueConsignado, DashboardEstoque |
| **Migrations** | AddClasseAbcToProduto, AddConversaoUnidadeMedida, AddProdutoCodigoBarras, AddProdutoFornecedor, AddEstoqueSaldoHistorico, AddEstoqueConsignado |
| **Frontend Types** | 6 arquivos (domain/estoque/) |
| **Frontend Services** | 6 arquivos (infrastructure/api/) |
| **Frontend Pages** | ConversãoUM (3), ProdutoFornecedor (3), Consignado (3), CurvaAbc (1), SaldoHistorico (1), Dashboard (rewrite) |

### Arquivos modificados

| Arquivo | Edições |
|---------|---------|
| `Produto.cs` | +ClasseABC + AtualizarClasseABC() |
| `IProdutoService.cs` | +CalcularCurvaAbcAsync() + records |
| `ProdutoService.cs` | +CalcularCurvaAbcAsync() impl |
| `TenantDbContext.cs` | +5 DbSets + OnModelCreating + ClasseABC |
| `TenantSchemaService.cs` | +5 CREATE TABLE + ALTER TABLE |
| `DependencyInjection.cs` | +5 services |
| `RelatoriosEstoqueController.cs` | +endpoint curva-abc |
| `Sidebar.tsx` | +5 itens Estoque |
| `MainLayout.tsx` | +5 routeTitles |
| `AppRoutes.tsx` | +7 routes |
| `DashboardPage.tsx` | Reescrita completa |

### Verificação
- Backend: `dotnet build` → 0 errors
- Frontend: `npx tsc --noEmit` → 0 errors
- 6 migrations geradas sequencialmente com técnica Ignore
- TenantSchemaService: 26 tabelas tenant (5 novas)

---

## Sessão 2026-02-26 — Módulo de Compras: Fase 1 MVP

**Commit:** `d71485d`
**Branch:** `main`

### O que foi feito

Implementação completa da Fase 1 MVP do módulo de compras — ordens de compra com workflow completo, recebimento de mercadorias com integração ao estoque, 2 domínios novos, relatório de pedidos abertos.

#### 1. Domínios de Compras (2 entidades públicas)

| Entidade | Seed | Padrão |
|----------|------|--------|
| CondicaoPagamento | 12 condições (À Vista, 30 dias, 30/60/90 dias, etc.) | À Vista |
| ModalidadeFrete | 4 modalidades (CIF, FOB, Terceiros, Sem Frete) | CIF |

- Controllers standalone: `DominiosCondicaoPagamentoController`, `DominiosModalidadeFreteController`
- Frontend: Page + FormDialog + DetailDialog para cada domínio
- Registrados em `dominioService.ts` ('condicoes-pagamento', 'modalidades-frete')

#### 2. OrdemCompra + OrdemCompraItem (entidades tenant)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Identificador sequencial |
| FornecedorId | FK | Fornecedor (Party Pattern) |
| Tipo | string | Normal / Urgente / Planejado |
| Status | string | Workflow completo (ver abaixo) |
| CondicaoPagamentoId | FK cross-schema | Domínio público |
| ModalidadeFreteId | FK cross-schema | Domínio público |
| DepositoId | FK | Depósito de destino |
| SubTotal/DescontoTotal/ValorFrete/OutrasDespesas/ValorTotal | decimal(18,4) | Totalizadores |

**Workflow OrdemCompra:**
```
Rascunho → Aprovada → Enviada → ParcialmenteRecebida → Recebida → Encerrada
                                                                  ↘ Cancelada
```

**OrdemCompraItem:** Sequencia, ProdutoId, Quantidade, QuantidadeRecebida, UnidadeMedidaId, PrecoUnitario, DescontoPct/Valor, ValorTotal, Status (Pendente/ParcialmenteRecebido/Recebido/Cancelado).

#### 3. RecebimentoMercadoria + RecebimentoMercadoriaItem (entidades tenant)

**Workflow RecebimentoMercadoria:**
```
Rascunho → Conferido → Confirmado
                     ↘ Cancelado
```

**Integração com Estoque (ConfirmarAsync):**
- Cria `MovimentacaoEstoque` (tipo "Entrada") para cada item aceito
- Atualiza `EstoqueSaldo` via `AplicarEntrada()` ou cria novo saldo
- Atualiza `OrdemCompraItem.QuantidadeRecebida`
- Recalcula status da OrdemCompra (ParcialmenteRecebida / Recebida)

**RecebimentoMercadoriaItem:** QuantidadeEsperada/Recebida/Aceita/Rejeitada, PrecoUnitario, LoteId, LocalizacaoId, MotivoRejeicao.

#### 4. Backend

| Componente | Arquivos |
|------------|----------|
| **Domain** | OrdemCompra.cs, OrdemCompraItem.cs, RecebimentoMercadoria.cs, RecebimentoMercadoriaItem.cs, CondicaoPagamento.cs, ModalidadeFrete.cs |
| **Application** | IOrdemCompraService.cs, IRecebimentoMercadoriaService.cs (interfaces + record DTOs) |
| **Infrastructure** | OrdemCompraService.cs, RecebimentoMercadoriaService.cs, TenantDbContext (+4 DbSets + configs), TenantSchemaService (+4 tabelas), DependencyInjection (+2 services) |
| **API** | OrdensCompraController, RecebimentosMercadoriaController, RelatoriosComprasController, 2 domain controllers |
| **Permissions** | Compras.OrdensCompra (View/Create/Edit/Delete), Compras.Recebimentos (View/Create/Edit/Delete) |
| **Seeds** | CondicaoPagamentoSeed (12), ModalidadeFreteSeed (4) |
| **Migrations** | AddCondicaoPagamentoDominio, AddModalidadeFreteDominio (Application), AddOrdemCompra, AddRecebimentoMercadoria (Tenant) |

#### 5. Frontend

| Componente | Arquivos |
|------------|----------|
| **Types** | ordemCompra.types.ts, recebimentoMercadoria.types.ts |
| **Services** | ordemCompraService.ts, recebimentoMercadoriaService.ts |
| **Ordens de Compra** | OrdensCompraListPage (KPIs: Total/Rascunhos/Enviadas/Recebidas, status colors), OrdemCompraFormDialog (seções: Dados Gerais + Itens inline + Obs), OrdemCompraDetailDialog (workflow buttons por status) |
| **Recebimentos** | RecebimentosListPage (KPIs: Total/Rascunho/Conferido/Confirmado), RecebimentoFormDialog (seções: Dados + NF + Itens + Obs), RecebimentoDetailDialog (workflow: Conferir→Confirmar, color-coding aceita/rejeitada) |
| **Relatório** | PedidosAbertosPage (OCs pendentes com LinearProgress % recebido, color-coding por faixa) |
| **Domínios** | CondicoesPagamento (Page/Form/Detail), ModalidadesFrete (Page/Form/Detail) |
| **Navegação** | Sidebar (+Compras section + Domínios/Compras), AppRoutes (+7 rotas), MainLayout (+7 routeTitles) |

#### 6. Bug fix

- **RecebimentoMercadoriaService.cs**: Corrigido `saldo.AdicionarQuantidade()` → `saldo.AplicarEntrada()` e `EstoqueSaldo.Create()` → `new EstoqueSaldo { ... }` (métodos não existiam na entidade)

### Verificação
- Backend: `dotnet build` → 0 errors
- Frontend: `npx tsc --noEmit` → 0 errors, `npx vite build` → OK (9.14s)
- 4 migrations geradas sequencialmente com técnica Ignore
- TenantSchemaService: 29 tabelas tenant (4 novas)
- 62 arquivos no commit, 29.209 linhas adicionadas

---

## Sessão 2026-02-26 (cont.) — Módulo de Compras: Fase 2 Operacional

**Branch:** `main`

### Escopo

Implementação completa da **Fase 2 — Operacional** do módulo de Compras, incluindo:
- Requisição de Compra (solicitações internas de materiais)
- Devolução de Compra (retorno de mercadoria ao fornecedor)
- Fluxo de Aprovação (aprovação por alçada de valor)
- Domínios: MotivoRequisicao, MotivoDevolucao

### Entidades criadas (9)

| Entidade | Tabela | Workflow |
|----------|--------|----------|
| RequisicaoCompra | requisicoes_compra | Rascunho → PendenteAprovacao → Aprovada → Convertida/Rejeitada/Cancelada |
| RequisicaoCompraItem | requisicao_compra_itens | — |
| DevolucaoCompra | devolucoes_compra | Rascunho → PendenteAutorizacao → Autorizada → EmTransito → Concluida/Cancelada |
| DevolucaoCompraItem | devolucao_compra_itens | — |
| FluxoAprovacao | fluxos_aprovacao | — |
| NivelAprovacao | niveis_aprovacao | — |
| AprovacaoHistorico | aprovacoes_historico | Pendente → Aprovado/Rejeitado |
| MotivoRequisicao | motivos_requisicao (público) | 7 seeds |
| MotivoDevolucao | motivos_devolucao (público) | 7 seeds |

### Backend

| Camada | Arquivos |
|--------|----------|
| Domain | 7 entidades Compras + 2 domínios públicos + 2 seeds |
| Application | 3 interfaces (IRequisicaoCompraService, IDevolucaoCompraService, IFluxoAprovacaoService) |
| Infrastructure | 3 services + TenantDbContext (7 DbSets + 7 configs Fluent API) + TenantSchemaService (7 tabelas SQL) + Permissions (3 sub-classes) + DI |
| API | 3 controllers Compras + 2 controllers Domínios |

### Frontend

| Componente | Detalhes |
|------------|----------|
| Types | requisicaoCompra.types.ts, devolucaoCompra.types.ts, fluxoAprovacao.types.ts |
| Services | requisicaoCompraService.ts, devolucaoCompraService.ts, fluxoAprovacaoService.ts |
| Requisições | ListPage (KPIs: Total/Rascunho/Pendentes/Aprovadas), FormDialog, DetailDialog (workflow actions) |
| Devoluções | ListPage (KPIs: Total/Rascunho/Pendentes/Autorizadas/Concluídas), FormDialog, DetailDialog (workflow actions) |
| Fluxos | ListPage (filter por TipoDocumento), FormDialog (níveis dinâmicos), DetailDialog |
| Domínios | MotivosRequisicao (Page/Form/Detail), MotivosDevolucao (Page/Form/Detail) |
| Navegação | Sidebar (+3 items + 2 domínios), AppRoutes (+5 rotas), MainLayout (+5 routeTitles) |

### Migrations (5)

| Contexto | Migration | Tabelas |
|----------|-----------|---------|
| Application | AddMotivoRequisicaoDominio | motivos_requisicao |
| Application | AddMotivoDevolucaoDominio | motivos_devolucao |
| Tenant | AddRequisicaoCompra | requisicoes_compra + requisicao_compra_itens |
| Tenant | AddDevolucaoCompra | devolucoes_compra + devolucao_compra_itens |
| Tenant | AddFluxoAprovacao | fluxos_aprovacao + niveis_aprovacao + aprovacoes_historico |

### Verificação
- Backend: `dotnet build` → 0 errors
- Frontend: `npx tsc --noEmit` → 0 errors
- 5 migrations geradas sequencialmente com técnica Ignore
- TenantSchemaService: 36 tabelas tenant (7 novas)
- ~60 arquivos novos/modificados

---

## Sessão 2026-02-26 (cont.) — Módulo de Compras: Fase 3 Avançado

**Branch:** `main`

### Escopo

Implementação completa da **Fase 3 — Avançado** do módulo de Compras, incluindo:
- Cotação (RFQ) com workflow multi-fornecedor
- Contrato de Compra (Blanket PO, acordos de preço)
- Avaliação de Fornecedor (scorecard com critérios ponderados)
- Histórico de Preços (analytics + comparativo)
- Dashboard de Compras (24 KPIs + gráficos)

### Entidades criadas (8)

| Entidade | Tabela | Workflow/Descrição |
|----------|--------|--------------------|
| Cotacao | cotacoes | Rascunho → Enviada → EmAnalise → Finalizada / Cancelada |
| CotacaoFornecedor | cotacao_fornecedores | Resposta do fornecedor à cotação (preços, pontuação, seleção) |
| CotacaoFornecedorItem | cotacao_fornecedor_itens | Itens da resposta (produto, preço, desconto) |
| ContratoCompra | contratos_compra | Rascunho → Ativo → Suspenso → Expirado / Cancelado |
| ContratoCompraItem | contrato_compra_itens | Itens do contrato (preço, quantidades min/max/consumida) |
| AvaliacaoFornecedor | avaliacoes_fornecedor | Scorecard com pontuação total e classificação A/B/C/D/F |
| AvaliacaoFornecedorCriterio | avaliacao_fornecedor_criterios | Critérios ponderados (Nota × Peso = NotaPonderada) |
| HistoricoPreco | historico_precos | Write-once analytics (fonte: Cotação/OC/Contrato/Manual) |

### Backend

| Camada | Arquivos |
|--------|----------|
| Domain | 8 entidades Compras (Cotacao, CotacaoFornecedor, CotacaoFornecedorItem, ContratoCompra, ContratoCompraItem, AvaliacaoFornecedor, AvaliacaoFornecedorCriterio, HistoricoPreco) |
| Application | 5 interfaces (ICotacaoService, IContratoCompraService, IAvaliacaoFornecedorService, IHistoricoPrecoService, IDashboardComprasService) |
| Infrastructure | 5 services + TenantDbContext (8 DbSets + 8 configs Fluent API) + TenantSchemaService (8 tabelas SQL) + Permissions (4 sub-classes) + DI (5 registrations) |
| API | 5 controllers (Cotacoes, ContratosCompra, AvaliacoesFornecedor, HistoricoPrecos, DashboardCompras) |

### Frontend

| Componente | Detalhes |
|------------|----------|
| Types | cotacao.types.ts, contratoCompra.types.ts, avaliacaoFornecedor.types.ts, historicoPreco.types.ts |
| Services | cotacaoService.ts, contratoCompraService.ts, avaliacaoFornecedorService.ts, historicoPrecoService.ts, dashboardComprasService.ts |
| Cotações | ListPage (KPIs: Total/Rascunho/Enviadas/EmAnálise/Finalizadas), FormDialog, DetailDialog (fornecedores expansíveis + workflow buttons) |
| Contratos | ListPage (KPIs: Total/Rascunho/Ativos/Suspensos/Expirados), FormDialog (itens dinâmicos), DetailDialog (LinearProgress consumo + workflow) |
| Avaliações | ListPage (KPIs por classificação A/B/C/D/F), FormDialog (critérios dinâmicos com peso/nota), DetailDialog (pontuação + Chip classificação) |
| Histórico Preços | Page com 2 tabs: Histórico (tabela + entrada manual) + Comparativo (agrupado por fornecedor com min/max/avg) |
| Dashboard | Page com 8 KPI cards + BarChart (12 meses) + PieChart (status OC) + Top 10 fornecedores |
| Navegação | Sidebar (+5 items), AppRoutes (+5 rotas), MainLayout (+5 routeTitles) |

### Migrations (4 tenant)

| Migration | Tabelas |
|-----------|---------|
| AddCotacao | cotacoes + cotacao_fornecedores + cotacao_fornecedor_itens |
| AddContratoCompra | contratos_compra + contrato_compra_itens |
| AddAvaliacaoFornecedor | avaliacoes_fornecedor + avaliacao_fornecedor_criterios |
| AddHistoricoPreco | historico_precos |

### Verificação
- Backend: `dotnet build` → 0 errors
- Frontend: `npx tsc --noEmit` → 0 errors
- 4 migrations geradas sequencialmente com técnica Ignore
- TenantSchemaService: 44 tabelas tenant (8 novas)
- ~55 arquivos novos/modificados

---

## Sessão 2026-03-01 — Módulo Financeiro Completo + 3 Gaps Finais

**Branch:** `main`

### Escopo

Implementação completa do **Módulo Financeiro** com todas as 4 fases + resolução dos 3 gaps finais (CNAB Retorno, Encerramento do Exercício, Rateio Execução).

### Módulo Financeiro — Base (Fases 1-4)

#### Entidades criadas (~30+ tenant + 8 domínios públicos)

| Categoria | Entidades |
|-----------|-----------|
| **Contas a Pagar/Receber** | ContaPagar, ContaReceber, BaixaFinanceira, Cheque |
| **Bancos** | ContaBancaria, MovimentoBancario, TransferenciaBancaria |
| **Cartões** | RecebiveisCartao |
| **Orçamento/DRE** | OrcamentoFinanceiro, Dre |
| **Contabilidade** | PlanoContas, LancamentoContabil, PartidaLancamento, CentroCusto |
| **Fluxo Caixa** | FluxoCaixa |
| **Cobrança** | ReguaCobranca, DespesaRecorrente |
| **CNAB** | CnabRemessa, CnabRemessaItem |
| **Rateio** | RateioModelo, RateioModeloItem |
| **Conciliação** | ConciliacaoBancaria |
| **Domínios (8)** | Banco, BandeiraCartao, CategoriaFinanceira, CategoriaFluxoCaixa, NaturezaFinanceira, OperadoraCartao, TipoCentroCusto, TipoDocumentoFinanceiro |

#### Backend

| Camada | Quantidade |
|--------|-----------|
| Controllers | 21 tenant + 8 domínios |
| Services | 21 implementações |
| Interfaces | 21 interfaces |
| Permissions | ~15 sub-classes |
| Migrations | 3 Application + 3 Tenant |

#### Frontend

| Componente | Quantidade |
|------------|-----------|
| ListPages | ~21 |
| FormDialogs | ~21 |
| DetailDialogs | ~21 |
| Páginas de domínio | 8 |
| Dashboard Financeiro | 1 |
| Relatórios | DRE, Fluxo de Caixa, Relatórios Contábeis |

### 3 Gaps Finais

#### Gap 1: CNAB Retorno
- **Entidades:** RetornoCnab, RetornoCnabItem
- **Parser CNAB 240:** segmentos T (identificação) + U (valores), match por NossoNumero
- **Integração:** liquidação → BaixaFinanceiraService, rejeição → StatusRetorno
- **Frontend:** ListPage + DetailDialog + ProcessarRetornoDialog (upload + conta bancária)

#### Gap 2: Encerramento do Exercício
- **Entidade:** ExercicioContabil (year, status, resultado)
- **Service:** EncerramentoExercicioService wrapping LancamentoContabilService existente
- **Operações:** Preview (sem persistir), Encerrar (lançamento automático), Reabrir (estorno)
- **Frontend:** EncerramentoExercicioPage + PreviewEncerramentoDialog

#### Gap 3: Rateio Execução
- **Entidade:** RateioExecucao (modelo, período, totais)
- **Lógica:** lançamentos sem centro de custo × modelo de rateio → novos lançamentos tipo "Rateio"
- **Frontend:** ExecutarRateioDialog + HistoricoExecucaoDialog (integrados ao RateioModelosListPage)

### Seeds

- **FinanceiroSeed:** Seeds de domínios financeiros (Bancos, Bandeiras, Categorias, etc.)
- **ModulesPermissionsSeed:** Permissions do módulo financeiro

### Verificação
- Backend: `dotnet build` → 0 errors
- Frontend: compila sem erros
- 172 arquivos (31 modificados + 141 novos)

---

## Sessão 2026-03-02 — Documentação Módulo Fiscal (Pesquisa Completa)

**Branch:** `main`

### Escopo

Pesquisa extensiva na internet sobre o Módulo Fiscal para o ERP, seguindo o mesmo padrão dos módulos anteriores (Compras, Estoque, Vendas, Financeiro). Criação de documentação detalhada em `docs/modulo_fiscal/`.

### Documentos criados (4 arquivos, ~188KB)

| Arquivo | Tamanho | Conteúdo |
|---------|---------|----------|
| `docs/modulo_fiscal/README.md` | 38 linhas | Índice geral do módulo |
| `docs/modulo_fiscal/MODULO-FISCAL-PESQUISA.md` | 1.324 linhas (57KB) | **Documento principal** — 18 seções |
| `docs/modulo_fiscal/PESQUISA-TRIBUTARIA-BRASIL.md` | 1.492 linhas (75KB) | Cálculos tributários detalhados |
| `docs/modulo_fiscal/PESQUISA-SPED-OBRIGACOES.md` | 1.484 linhas (55KB) | Obrigações acessórias SPED |

### MODULO-FISCAL-PESQUISA.md — 18 Seções

1. **Entidades propostas (~34)**: ConfiguracaoFiscal, RegraTributaria, NotaFiscal, NotaFiscalItem, NotaFiscalItemImposto, EventoNotaFiscal, ApuracaoIcms, GuiaRecolhimento, CertificadoDigital, AuditTrailFiscal, etc.
2. **Documentos fiscais eletrônicos**: NF-e v4.00, NFC-e, NFS-e, CT-e, MDF-e — XML structures, eventos, contingência
3. **Tax Engine**: Strategy + Chain of Responsibility, parametrizável por NCM × UF × CFOP × Regime
4. **Tabelas auxiliares (domínios públicos ~9)**: NCM, CFOP, CEST, CST ICMS/PIS/COFINS, alíquotas por UF
5. **Regimes tributários**: Simples Nacional (Anexos I-V), Lucro Presumido, Lucro Real
6. **ST/DIFAL**: Cálculos com MVA, protocolo ICMS, FCP
7. **SPED**: EFD-ICMS/IPI, EFD-Contribuições, ECD, ECF, EFD-Reinf
8. **Certificado digital**: A1 (.pfx) com AES-256 em banco, EphemeralKeySet .NET
9. **Comunicação SEFAZ**: SOAP/TLS mútuo, contingência SVC-AN/RS, EPEC
10. **Integrações**: Vendas→NF-e, Compras→escrituração, Estoque→SPED H, Financeiro→guias
11. **Reforma tributária**: CBS/IBS/IS substituindo PIS/COFINS/ICMS/ISS (EC 132/2023, 2026-2033)
12. **Multi-tenant**: Certificado/regime/inscrições por tenant
13. **Padrões arquiteturais**: Gateway SEFAZ (TecnoSpeed/FocusNFe), Tax Engine Service

### PESQUISA-TRIBUTARIA-BRASIL.md — 9 Seções

- Fórmulas completas com exemplos trabalhados para ICMS, IPI, PIS/COFINS, ISS, IRPJ/CSLL
- Simples Nacional: tabelas Anexos I-V com todas as faixas de receita
- Lucro Presumido e Real: exemplos de cálculo
- Reforma tributária 2026-2033: timeline completa

### PESQUISA-SPED-OBRIGACOES.md — 13 Seções

- EFD-ICMS/IPI: blocos 0-9, registros detalhados
- EFD-Contribuições, ECD, ECF
- EFD-Reinf: eventos R-1000 a R-9000
- DCTFWeb/MIT
- Prazos, multas, matriz de obrigações por módulo

### Priorização proposta (4 fases)

1. **Fase 1 (MVP):** Config tributária, Tax Engine, NF-e/NFC-e, Certificado, Gateway
2. **Fase 2 (Operacional):** Eventos, inutilização, apuração ICMS/PIS/COFINS, guias, NFS-e
3. **Fase 3 (Avançado):** Simples Nacional, SPED, audit trail, contingência
4. **Fase 4 (Compliance):** ECD/ECF, Reinf, CT-e/MDF-e, reforma tributária

---

## Sessão 2026-04-22 — Migração de domínio `app.` → `apli.` + plano Infrastructure as Code

**Branch:** `main`
**Contexto:** DNS trocado de `app.indiolab.com.br` para `apli.indiolab.com.br`. Restructure monolito → microserviços (8 subprojetos) já estava em curso no working tree (2205 deleções de `backend/` + 8 subprojetos untracked). Esta sessão adiciona a troca de domínio por cima e formaliza o plano de deploy.

### 1. Substituição `app.` → `apli.` em 29 arquivos

Referências ao domínio antigo em **configs, código e docs**:

| Categoria | Arquivos |
|---|---|
| `appsettings.json` (Keycloak Authority) | erp-api, crm-api, ichat-api, admin-api |
| `Dockerfile` (VITE_API_URL / VITE_KEYCLOAK_URL) | erp-web, crm-web, ichat-web, admin-web |
| `AuthContext.tsx` (KEYCLOAK_URL fallback) | erp-web, crm-web, ichat-web, admin-web |
| Código backend | `erp-api/DependencyInjection.cs`, `admin-api/Program.cs` (CORS), 4× `ApplicationDbContext.cs`, 3× `SeedData.cs`, `crm-api/UsersController.cs`, `indiolab-shared-api/KeycloakAdminOptions.cs` |
| Código frontend | `erp-web/empresaService.ts`, `erp-web/Sidebar.tsx`, `crm-web/usuarioService.ts`, `ichat-web/Sidebar.tsx` |
| Docs | `PLANO-MIGRACAO-KEYCLOAK.md`, `PLANO-SEPARACAO-REPOS.md`, `admin-web/visao-geral.md` |

### 2. Renomeação dos 4 diretórios de subprojeto

- `crm.app.indiolab.com.br/` → `crm.apli.indiolab.com.br/`
- `erp.app.indiolab.com.br/` → `erp.apli.indiolab.com.br/`
- `chat.app.indiolab.com.br/` → `chat.apli.indiolab.com.br/`
- `admin.app.indiolab.com.br/` → `admin.apli.indiolab.com.br/`

(O repo raiz já estava em `apli.indiolab.com.br/`.)

### 3. Recon SSH do servidor `10.1.56.56` (test env)

Descobertas que informaram o plano:

- Ubuntu 24.04, Docker 29.4, compose v5.1.3
- Deploy dir: `/opt/indiolab/` (docker-compose.yml + .env manual)
- **APIs** `network_mode: host` — erp:5050, crm:5051, ichat:5052, admin:5053
- **Webs** bridge + port-forward — erp:3001, crm:3002, ichat:3003, admin:3004
- **Keycloak** `localhost:8180 → 8080`, `KC_HOSTNAME=https://auth.app.indiolab.com.br` (a atualizar)
- **Nginx** vhosts à mão em `/etc/nginx/sites-available/{erp,crm,chat,admin,auth}.app.indiolab.com.br`
- **Cert** atual `/etc/nginx/ssl/app.indiolab.com.br.{crt,key}` — self-signed wildcard, válido até 2036

### 4. Plano aprovado — Infrastructure as Code (pendente de implementação)

Decisão: abandonar edição manual no servidor. Criar `deploy/` versionado no repo:

```
deploy/
├── nginx/                  # 5 vhosts + snippet TLS
├── compose/                # docker-compose.yml + .env.example
├── scripts/                # bootstrap.sh, gerar-cert.sh, deploy.sh
└── keycloak/               # realm-indiolab.json exportado (opcional)
```

Fluxo: `git push` → servidor: `git pull && sudo ./deploy/scripts/deploy.sh` (idempotente). Nada editado à mão em produção.

### 5. Artefatos criados em `docs/deploy/` (rascunhos que vão migrar pra `deploy/`)

- `MIGRACAO-APLI.md` — runbook de cutover
- `nginx-apli.conf` — template vhosts com placeholders `<PORT_*>` (depois preenchidos com os valores reais: 5050/5051/5052/5053/3001/3002/3003/3004/8180)
- `gerar-cert-wildcard-apli.sh` — cert wildcard self-signed + CA
- `KEYCLOAK-MIGRACAO-APLI.md` — checklist admin console (realm Frontend URL, Redirect URIs, Web Origins dos 4 clients)

### 6. Execução end-to-end no servidor de produção (test env)

Migração completa feita via SSH (sudo via `echo pegasus | sudo -S`). O IaC formal (`deploy/` versionado) ficou para depois — este cutover foi executado diretamente no servidor.

**DNS** (já pronto antes da sessão — confirmado via `dig @10.1.10.10`):
- Zona `apli.indiolab.com.br` no AD Microsoft, A records `{erp,crm,chat,admin,auth} → 10.1.56.56`
- Zona `app.indiolab.com.br` já removida

**Cert:**
- `openssl req -x509` self-signed 10 anos com SANs pros 5 subdomínios + `*.apli.indiolab.com.br`
- Instalado em `/etc/nginx/ssl/apli.indiolab.com.br.{crt,key}` (cert antigo `app.*` mantido lado a lado, inativo)

**Nginx:**
- 5 vhosts novos em `/etc/nginx/sites-available/{erp,crm,chat,admin,auth}.apli.indiolab.com.br` (gerados via `sed` dos vhosts antigos; o `admin.app` que era arquivo direto em `sites-enabled` precisou ser reconstruído do template)
- Symlinks ativados em `sites-enabled`, vhosts `app.*` desativados
- `nginx -t && systemctl reload nginx`

**`/etc/hosts`:** `127.0.0.1 auth.app.indiolab.com.br` → `auth.apli.indiolab.com.br` (usado pelo admin-api pra falar com Keycloak via loopback).

**`/opt/indiolab/docker-compose.yml`:**
- `KC_HOSTNAME`: `https://auth.apli.indiolab.com.br`
- `Keycloak__Authority` adicionada em `erp-api`, `crm-api`, `ichat-api` (antes só existia no `admin-api`; as outras APIs dependiam do `appsettings.json` da imagem, que estava desatualizado)

**Keycloak (via `kcadm.sh` dentro do container):**
- Realm `indiolab` → `attributes.frontendUrl` = `https://auth.apli.indiolab.com.br`
- 4 clients (`erp-web`, `crm-web`, `ichat-web`, `admin-web`): `rootUrl`, `baseUrl`, `adminUrl`, `redirectUris`, `webOrigins`, `attributes.post.logout.redirect.uris` → `apli.`

**Rebuild dos 4 webs** (não havia source no servidor — só imagens; nem havia `build:` section no compose):
- Build local no Mac com `docker build --build-arg VITE_KEYCLOAK_URL=https://auth.apli.indiolab.com.br --build-arg VITE_API_URL=https://{sub}.apli.indiolab.com.br/api ...`
- `docker save | gzip | ssh 'gunzip | docker load'` — 4 imagens transferidas via stream SSH
- `docker compose up -d --force-recreate` de cada web

**Restart:** keycloak + admin-api (fase 4) → erp-web + ichat-web + admin-web (fase 6) → erp-api + crm-api + ichat-api (fase 7). Todos os 10 containers `running`.

### 7. Verificação end-to-end

HTTP local (via `curl --resolve ...:127.0.0.1`):

| Endpoint | Status |
|---|---|
| `https://admin.apli.indiolab.com.br/usuarios` | 200 |
| `https://erp/crm/chat/admin.apli.indiolab.com.br/` | 200 |
| `https://auth.apli.indiolab.com.br/realms/indiolab/.well-known/openid-configuration` | 200, `issuer: https://auth.apli.indiolab.com.br/...` |

Bundles JS dos 4 webs verificados com `grep` — contêm apenas URLs `auth.apli.indiolab.com.br` + `{sub}.apli.indiolab.com.br/api`.

### 8. Pendências residuais

- [ ] Instalar CA self-signed no trust store das máquinas dos usuários (hoje dá aviso SSL no browser — clicar em "Avançado → Prosseguir")
- [ ] Implementar estrutura `deploy/` IaC (próxima sessão — artefatos em `docs/deploy/` ficam como rascunho)
- [ ] Renomear repo `github.com/carrilhorubens/opticalcore.com.br` → `apli.indiolab.com.br` (ou nome novo) pra alinhar com o diretório local
- [ ] Pro restructure backend (2205 deleções em `backend/` + sub-repos com edits concorrentes) seguir plano separado de commit — fora do escopo dessa sessão
