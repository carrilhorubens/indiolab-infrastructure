# Relatório: Cancelamentos

## Objetivo

Analisar os pedidos de venda cancelados em um período, agrupados por motivo, com taxa de cancelamento e totalizadores de valor perdido.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/cancelamentos` | Cancelamentos de pedidos no período |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Cancelamentos por Motivo

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `motivoNome` | string? | Motivo do cancelamento |
| `totalCancelamentos` | int | Quantidade de pedidos cancelados |
| `valorTotal` | decimal | Valor total cancelado |
| `percentualDoTotal` | decimal | % em relação ao total de cancelamentos |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalCancelamentos` | int | Total geral de cancelamentos |
| `valorTotalCancelado` | decimal | Soma dos valores cancelados |
| `taxaCancelamento` | decimal | % de cancelamentos em relação ao total de pedidos |

---

## Regras

- `TaxaCancelamento` = `TotalCancelamentos / TotalPedidosNoPeriodo × 100`
- Agrupa por `MotivoCancelamento` (campo texto no pedido de venda)
- Pedidos cancelados são identificados pelo status `Cancelado`
- Motivos sem nome aparecem como nulo (cancelamentos sem justificativa)
- Usado para análise de perda de receita e melhoria de processos
