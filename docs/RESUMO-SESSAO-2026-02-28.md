# Resumo da Sessão — 28/02/2026

## 1. Módulo de Vendas — Fases 1 a 4 Completas

Implementação completa do módulo de vendas conforme spec `MODULO-VENDAS-PESQUISA.md`.

### Backend
- **26 entidades de domínio**: PedidoVenda, OrcamentoItem, FaturamentoVenda, EntregaVenda, DevolucaoVenda, ComissaoVenda, ComissaoRegra, MetaVenda, TabelaPreco, RegiaoVenda, PedidoVendaAprovacao, HistoricoPrecoVenda, LogDescontoEspecial, AcompanhamentoMeta, entre outras
- **16 controllers**: PedidosVenda, Orcamentos, Faturamentos, Entregas, Devoluções, Comissões, ComissaoRegras, MetasVenda, TabelasPreco, RegioesVenda, PedidoVendaAprovacoes, DashboardVendas, RelatoriosVendas, HistoricoPrecoVenda, LogDescontosEspeciais
- **16 services** com lógica de negócio completa (workflows, cálculos, validações)
- **6 domínios públicos**: CanalVenda, FormaPagamento, MotivoCancelamento, MotivoDevolucaoVenda, StatusFornecedor, TipoDesconto
- **Permissions**: sub-classes completas para cada entidade de vendas
- **Migrations**: 4 Application + 4 Tenant

### Frontend
- **16 ListPages** + **16 FormDialogs** + **16 DetailDialogs**
- **6 páginas de domínio** (canais, formas pagamento, motivos, tipos desconto)
- **6 páginas analytics** (RFM, CLV, Cohort, Churn, Cross-Sell, Seasonality)
- **21 páginas de relatórios** (vendas por período/cliente/produto/vendedor/canal/região, comissões, metas vs realizado, funil, forecast, etc.)
- **Dashboard Vendas** com KPIs + gráficos
- **Navegação**: Sidebar com seção Vendas completa + rotas + routeTitles

---

## 2. Módulo de Compras — Extensões

### ResponsavelId nas entidades de compras
- Adicionado `ResponsavelId` (Guid) em 3 entidades faltantes: `DevolucaoCompra`, `Cotacao`, `FluxoAprovacao`
- As 3 outras já tinham (OrdemCompra.CompradorId, RecebimentoMercadoria.ResponsavelId, RequisicaoCompra.SolicitanteId)
- TenantSchemaService: +3 colunas `responsavel_id` via ALTER TABLE
- ComprasSeed atualizado para usar `seedUserId`

### Novas entidades de compras
- CategoriaCompra, ManifestacaoDestinatario, EscrituracaoFiscalEntrada, ConhecimentoTransporte, DeclaracaoImportacao
- 5 controllers + 5 services + frontend completo (pages + dialogs)
- 13 relatórios de compras (análise gastos, comparativo preços, performance fornecedores, etc.)

---

## 3. Associação Usuário ↔ Funcionário

### Backend
- `ApplicationUser.FuncionarioId` (`Guid?` nullable — compatível com usuários existentes sem associação)
- Migration `AddFuncionarioIdToUsuarios` — coluna `funcionario_id UUID nullable` na tabela `usuarios`
- `CreateUserCommand` e `UpdateUserCommand` com `Guid FuncionarioId` (obrigatório na entrada)
- `UserService` atualizado para salvar e retornar FuncionarioId/FuncionarioNome nos DTOs

### Frontend
- `UsuarioFormDialog.tsx` — campo "Nome Completo" substituído por **Autocomplete de busca de funcionários** com debounce (300ms), busca assíncrona no endpoint `GET /funcionarios`
- Ao selecionar um funcionário, `fullName` e `funcionarioId` são preenchidos automaticamente
- Validação: "Selecione um funcionário" obrigatório
- `UsuarioDetailDialog.tsx` — label "Nome" alterado para "Funcionário"
- `usuario.types.ts` — DTOs e requests atualizados

---

## 4. Bugfix: Filtro de busca por CPF/CNPJ

### Problema
`CpfCnpj.Contains("")` retornava `true` para TODOS os registros quando a busca não continha dígitos (ex: "Rubens Samuel"), anulando completamente o filtro de nome.

### Correção
Adicionado guard `searchDigits.Length > 0 &&` antes de `CpfCnpj.Contains(searchDigits)` em 4 services:
- `FuncionarioService.cs`
- `ClienteService.cs`
- `FornecedorService.cs`
- `PessoaService.cs`

---

## 5. Seeds

- **FuncionariosSeed**: 30 funcionários do setor óptico com dados completos
- **ComprasSeed**: Atualizado com `responsavelId` usando `seedUserId`
- **Seeds de domínios de vendas**: CanalVenda, FormaPagamento, MotivoCancelamento, MotivoDevolucaoVenda, TipoDesconto

---

---

## 6. Expansão dos Seeds para ~2000 registros (Jan/2025 → Fev/2026)

### Motivação
Os dashboards de Compras, Vendas e Estoque precisavam de volume de dados realista para demonstrar tendências, sazonalidade e KPIs. Os seeds anteriores geravam ~350 registros concentrados em 4 meses. A expansão distribui ~2000 registros ao longo de 14 meses.

### Arquitetura da geração
- `new Random(42)` — determinístico e reprodutível
- Loop sobre 14 meses: `(2025,1)...(2025,12),(2026,1),(2026,2)`
- **Multiplicador sazonal**: Jan 0.7×, Fev 0.8×, Mar 1.3×, Jun 1.4×, Set 1.3×, Nov 1.5×, Dez 1.2×
- **Variação preço**: ±15% sobre custo base
- **Status**: distribuição percentual realista (ex: OCs 60% Recebida, 20% Em andamento, 10% Cancelada, 10% Rascunho)

### Resultados

| Entidade | Antes | Depois | Meta |
|----------|-------|--------|------|
| Ordens Compra | 10 | **73** | 80 |
| OC Itens | 38 | ~240 | 240 |
| Recebimentos | 7 | **44** | 55 |
| Recebimento Itens | 26 | ~165 | 165 |
| Requisições | 3 | 20 | 20 |
| Devoluções Compra | 2 | 8 | 8 |
| Cotações + Forn + Itens | 14 | ~84 | 84 |
| Contratos + Itens | 8 | ~40 | 40 |
| Avaliações + Critérios | 30 | ~60 | 60 |
| Histórico Preço | 20 | 200 | 200 |
| Orçamentos + Itens | 14 | ~80 | 80 |
| Pedidos Venda | 10 | **111** | 120 |
| Pedido Itens | 24 | ~360 | 360 |
| Entregas + Itens | 19 | **70** + ~210 | 280 |
| Faturamentos + Itens | 16 | ~50 + ~150 | 200 |
| Devoluções Venda | 4 | ~10 + ~15 | 25 |
| Movimentações Estoque | ~60 | **388** | ~445 |
| Saldo Histórico | 0 | 140 | 140 |
| Lotes | 15 | **40** | 40 |
| Números Série | 10 | **20** | 20 |

### Arquivos modificados

| Arquivo | Natureza |
|---------|----------|
| `Seeds/Estoque/EstoqueSeed.cs` | Lotes 15→40, Séries 10→20 (datas desde Jan/2025) |
| `Seeds/Compras/ComprasSeed.cs` | Reescrita completa — geração por loop (~900 registros) |
| `Seeds/Vendas/VendasSeed.cs` | Novo arquivo — geração por loop (~800 registros) |
| `AdminController.cs` | XML docs atualizadas com contagens expandidas |

### Bugfix
- **ChaveAcessoNF com 49 chars** → corrigido para exatamente 44 dígitos (padrão NFe real: UF+AAMM+CNPJ+Mod+Série+Num+tpEmis+cNF+cDV)

---

## 7. Correções de importação no frontend (6 services)

`import api from './api'` corrigido para `import api from './index'` em 6 services de vendas que não carregavam:
- `tabelaPrecoService.ts`, `historicoPrecoVendaService.ts`, `comissaoRegraService.ts`, `comissaoVendaService.ts`, `logDescontoEspecialService.ts`, `faturamentoVendaService.ts`

---

## 8. Seeds expandidos para ~4000 registros (volume duplicado)

Todos os multiplicadores de geração foram duplicados para produzir volume mais realista nos dashboards:

| Entidade | Antes | Depois |
|----------|-------|--------|
| Ordens Compra | 73 | **146** |
| Recebimentos | 44 | **88** |
| Requisições | 17 | **34** |
| Devoluções Compra | 8 | **16** |
| Cotações | 6 | **12** |
| Contratos | 8 | **16** |
| Avaliações | 10 | **20** |
| Hist. Preços | 200 | **351** |
| Orçamentos | 20 | **39** |
| Pedidos Venda | 111 | **219** |
| Entregas | 70 | **140** |
| Faturamentos | 50 | **100** |
| Devoluções Venda | 10 | **20** |
| Comissões | 30 | **60** |
| Metas | 28 | **56** |
| Movimentações | 388 | **736** |

---

## 9. VendedorNome nas Comissões de Venda

`ComissaoVendaService.cs` — campo `VendedorNome` estava hardcoded `null`, mostrando "–" no relatório. Corrigido com resolução via `Funcionario → Pessoa.Nome`:
- `ListAsync()`: batch resolve com `ToDictionaryAsync`
- `GetByIdAsync()`: resolve individual
- `MapToResponse()`: assinatura atualizada para aceitar `string? vendedorNome`

---

## 10. Relatório Comissões por Vendedor — filtro DataCalculo

- **Problema**: `DataCalculo` era `DateTime.UtcNow` (momento do seed), todas comissões tinham mesma data. Filtro `<= dataFim` excluía registros do mesmo dia com hora > 00:00.
- **Correção seed**: `DataCalculo` agora é último dia do período de referência (distribuído pelos 14 meses)
- **Correção service**: `<= dataFim` → `< dataFim.Date.AddDays(1)` em 2 queries de `ComissoesVenda`

---

## 11. Resumo Comissões por Período — filtro por Data Início / Data Fim

- **Antes**: campo único "Período Referência (AAAA-MM)" filtrando por `PeriodoReferencia == string`
- **Depois**: dois campos `type="date"` (Data Início e Data Fim) filtrando por `DataCalculo` range
- **Default**: 1º dia do mês corrente → hoje (01/02/2026 → 28/02/2026)
- Backend: `IRelatorioVendasService`, `RelatorioVendasService`, `RelatoriosVendasController` — assinatura alterada
- Frontend: `relatorioVendasService.ts`, `ResumoComissoesPeriodoPage.tsx`

---

## 12. Autocomplete de Vendedor no Relatório Comissões por Vendedor

- **Antes**: campo TextField de texto livre "ID do Vendedor (opcional)" — usuário precisava digitar o UUID manualmente
- **Depois**: `<Autocomplete>` MUI com busca assíncrona de funcionários
  - Carrega 20 funcionários ao abrir a página
  - Debounce de 300ms na digitação
  - Spinner de loading durante busca
  - Label "Vendedor (opcional)" — limpar = sem filtro
  - Envia `id` do funcionário selecionado como `vendedorId` na API
- **Arquivo**: `frontend/src/presentation/pages/vendas/relatorios/ComissoesPorVendedorPage.tsx`

---

## Verificação

- `dotnet build` — 0 errors
- `POST /api/admin/seed/integracao` — HTTP 200, ~4000 registros gerados em 14 meses
- Relatório comissões-por-vendedor: 60 registros com nomes de vendedores
- Resumo comissões: filtro por datas funcionando (4 comissões em Fev/2026, 60 no período completo)
