# Consulta: Painel de Compras (Dashboard)

## Objetivo

Apresentar uma visão consolidada do módulo de compras com KPIs de ordens, recebimentos, requisições, devoluções, cotações, contratos e fornecedores, além de tendência mensal e ranking dos maiores fornecedores.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/dashboard-compras` | Dashboard consolidado de compras |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.View`

---

## Parâmetros

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `dataInicio` | string? | Início do período (formato `yyyy-MM-dd`) |
| `dataFim` | string? | Fim do período (formato `yyyy-MM-dd`) |

---

## KPIs Retornados

### Ordens de Compra

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalOrdensCompra` | int | Total de ordens no período |
| `ordensRascunho` | int | Ordens em rascunho |
| `ordensAprovadas` | int | Ordens aprovadas |
| `ordensEnviadas` | int | Ordens enviadas ao fornecedor |
| `ordensParcialmenteRecebidas` | int | Ordens com recebimento parcial |
| `ordensRecebidas` | int | Ordens totalmente recebidas |
| `ordensCanceladas` | int | Ordens canceladas |
| `valorTotalOrdensAbertas` | decimal | Valor total das ordens em aberto |
| `valorMedioOrdem` | decimal | Valor médio por ordem |

### Recebimentos

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalRecebimentos` | int | Total de recebimentos |
| `recebimentosPendentes` | int | Recebimentos pendentes de confirmação |
| `recebimentosConfirmados` | int | Recebimentos confirmados |

### Requisições

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalRequisicoes` | int | Total de requisições |
| `requisicoesPendentesAprovacao` | int | Requisições aguardando aprovação |
| `requisicoesAprovadas` | int | Requisições aprovadas |

### Devoluções

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalDevolucoes` | int | Total de devoluções |
| `devolucoesPendentes` | int | Devoluções pendentes |
| `valorTotalDevolucoes` | decimal | Valor total das devoluções |

### Cotações

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalCotacoes` | int | Total de cotações |
| `cotacoesEnviadas` | int | Cotações enviadas |
| `cotacoesEmAnalise` | int | Cotações em análise |
| `cotacoesFinalizadas` | int | Cotações finalizadas |

### Contratos

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalContratos` | int | Total de contratos |
| `contratosAtivos` | int | Contratos ativos |
| `contratosVencendo30Dias` | int | Contratos vencendo nos próximos 30 dias |
| `valorTotalContratosAtivos` | decimal | Valor total dos contratos ativos |

### Fornecedores

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `totalFornecedoresAtivos` | int | Fornecedores ativos |
| `mediaAvaliacaoFornecedores` | decimal | Média de avaliação dos fornecedores |

### Operacionais

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `leadTimeMedioDias` | decimal | Lead time médio de entrega (dias) |
| `taxaConformidade` | decimal | Taxa de conformidade dos recebimentos (%) |

---

## Tendência Mensal

Lista dos últimos 12 meses com:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mes` | string | Mês no formato "YYYY-MM" |
| `valorTotal` | decimal | Valor total das compras no mês |
| `totalOrdens` | int | Quantidade de ordens no mês |

---

## Top 10 Fornecedores

Ranking dos 10 maiores fornecedores por valor:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `fornecedorId` | Guid | ID do fornecedor |
| `fornecedorNome` | string | Nome do fornecedor |
| `valorTotal` | decimal | Valor total de compras |
| `totalOrdens` | int | Quantidade de ordens |
| `classificacao` | string | Classificação (A/B/C/D/F) |

---

## Exemplo de Uso

### Consultar dashboard com período customizado

```
GET /api/dashboard-compras?dataInicio=2026-01-01&dataFim=2026-03-31
```

### Consultar dashboard padrão

```
GET /api/dashboard-compras
```
