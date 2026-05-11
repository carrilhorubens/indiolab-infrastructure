# Módulo de Compras — Documentação Completa

> Documentação de todas as entidades, operações e relatórios do módulo de Compras do OpticalCore ERP.

---

## Índice de Entidades e Operações

| # | Entidade/Operação | Arquivo | Descrição |
|---|-------------------|---------|-----------|
| 01 | Painel de Compras | [entidades/01-painel-compras.md](entidades/01-painel-compras.md) | Dashboard com KPIs, tendência mensal e top 10 fornecedores |
| 02 | Ordens de Compra | [entidades/02-ordens-compra.md](entidades/02-ordens-compra.md) | Ciclo completo de pedidos de compra |
| 03 | Recebimentos de Mercadoria | [entidades/03-recebimentos-mercadoria.md](entidades/03-recebimentos-mercadoria.md) | Conferência e entrada de mercadorias |
| 04 | Requisições de Compra | [entidades/04-requisicoes-compra.md](entidades/04-requisicoes-compra.md) | Solicitações internas com aprovação |
| 05 | Devoluções de Compra | [entidades/05-devolucoes-compra.md](entidades/05-devolucoes-compra.md) | Devoluções a fornecedores |
| 06 | Fluxos de Aprovação | [entidades/06-fluxos-aprovacao.md](entidades/06-fluxos-aprovacao.md) | Workflows de aprovação por alçada de valor |
| 07 | Cotações (RFQ) | [entidades/07-cotacoes.md](entidades/07-cotacoes.md) | Solicitação e comparação de propostas |
| 08 | Contratos de Compra | [entidades/08-contratos-compra.md](entidades/08-contratos-compra.md) | Contratos de fornecimento com vigência |
| 09 | Avaliações de Fornecedor | [entidades/09-avaliacoes-fornecedor.md](entidades/09-avaliacoes-fornecedor.md) | Scorecard ponderado com classificação A-F |
| 10 | Histórico de Preços | [entidades/10-historico-precos.md](entidades/10-historico-precos.md) | Evolução de preços por produto e fornecedor |

---

## Índice de Relatórios

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 01 | Pedidos Abertos | [relatorios/01-pedidos-abertos.md](relatorios/01-pedidos-abertos.md) | OCs pendentes de recebimento |
| 02 | Histórico de Compras | [relatorios/02-historico-compras.md](relatorios/02-historico-compras.md) | Todas as compras por período |
| 03 | Compras por Fornecedor | [relatorios/03-compras-por-fornecedor.md](relatorios/03-compras-por-fornecedor.md) | Volume e valor por fornecedor |
| 04 | Compras por Produto | [relatorios/04-compras-por-produto.md](relatorios/04-compras-por-produto.md) | Histórico de compras por produto |
| 05 | Comparativo de Preços | [relatorios/05-comparativo-precos.md](relatorios/05-comparativo-precos.md) | Preços entre fornecedores |
| 06 | Entregas Pendentes | [relatorios/06-entregas-pendentes.md](relatorios/06-entregas-pendentes.md) | Itens aguardando recebimento |
| 07 | Performance de Fornecedores | [relatorios/07-performance-fornecedores.md](relatorios/07-performance-fornecedores.md) | Scorecard consolidado |
| 08 | Divergências de Recebimento | [relatorios/08-divergencias-recebimento.md](relatorios/08-divergencias-recebimento.md) | Diferenças pedido vs. recebido |
| 09 | Devoluções | [relatorios/09-devolucoes.md](relatorios/09-devolucoes.md) | Devoluções por período |
| 10 | Contratos Vencendo | [relatorios/10-contratos-vencendo.md](relatorios/10-contratos-vencendo.md) | Contratos próximos do vencimento |
| 11 | Requisições Pendentes | [relatorios/11-requisicoes-pendentes.md](relatorios/11-requisicoes-pendentes.md) | Requisições aguardando aprovação |
| 12 | Cotações em Andamento | [relatorios/12-cotacoes-andamento.md](relatorios/12-cotacoes-andamento.md) | Cotações abertas |
| 13 | Análise de Gastos | [relatorios/13-analise-gastos.md](relatorios/13-analise-gastos.md) | Gastos por categoria |
| 14 | Movimentações por CFOP | [relatorios/14-movimentacoes-cfop.md](relatorios/14-movimentacoes-cfop.md) | Entradas agrupadas por CFOP |

---

## Base URL

- **Entidades (01-10):** `GET/POST/PUT/DELETE /api/{entidade}`
- **Dashboard (01):** `GET /api/dashboard-compras`
- **Relatórios (01-14):** `GET /api/relatorios-compras/{endpoint}`

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.*`

---

## Classificação por Categoria

### Cadastros
- Contratos de Compra — fornecimento com vigência e consumo
- Fluxos de Aprovação — workflows por alçada de valor
- Avaliações de Fornecedor — scorecard ponderado
- Histórico de Preços — evolução de preços

### Operações
- Ordens de Compra — pedidos com workflow completo
- Recebimentos de Mercadoria — conferência com integração estoque
- Requisições de Compra — solicitações internas com aprovação
- Devoluções de Compra — devoluções a fornecedores
- Cotações (RFQ) — comparação de propostas

### Consultas
- Painel de Compras — dashboard com KPIs consolidados

### Relatórios Operacionais
- Pedidos Abertos — acompanhamento de OCs
- Entregas Pendentes — itens a receber
- Requisições Pendentes — fila de aprovação
- Cotações em Andamento — RFQs abertas

### Relatórios Analíticos
- Histórico de Compras — volume e valor no período
- Compras por Fornecedor — concentração de gastos
- Compras por Produto — histórico por item
- Comparativo de Preços — evolução de preços
- Análise de Gastos — spend por categoria

### Relatórios de Fornecedores
- Performance de Fornecedores — scorecard
- Contratos Vencendo — renovação de contratos

### Relatórios de Controle e Fiscal
- Divergências de Recebimento — conferência vs. NF
- Devoluções — devoluções ao fornecedor
- Movimentações por CFOP — escrituração fiscal

---

## Referência Completa

Para pesquisa detalhada com entidades, campos, ciclos de vida, workflow de aprovação, KPIs e requisitos fiscais, consulte **[MODULO-COMPRAS-PESQUISA.md](MODULO-COMPRAS-PESQUISA.md)**.
