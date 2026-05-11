# Relatório: Customer Lifetime Value (CLV)

## Objetivo

Estimar o valor do ciclo de vida de cada cliente (CLV), calculando quanto cada cliente vale para o negócio com base em receita, frequência e tempo como cliente.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/clv` | Customer Lifetime Value |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

### Clientes

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clienteId` | Guid | ID do cliente |
| `clienteNome` | string? | Nome do cliente |
| `receitaTotal` | decimal | Receita total histórica (R$) |
| `totalPedidos` | int | Total de pedidos do cliente |
| `ticketMedio` | decimal | Valor médio por pedido |
| `frequenciaAnual` | decimal | Pedidos por ano |
| `clvEstimado` | decimal | CLV projetado (R$) |
| `mesesComoCliente` | int | Tempo como cliente (meses) |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clvMedio` | decimal | CLV médio de todos os clientes |
| `clvMediano` | decimal | CLV mediano (percentil 50) |
| `clvTotal` | decimal | Soma de todos os CLVs |

---

## Regras

- `FrequenciaAnual` = `TotalPedidos / (MesesComoCliente / 12)`
- `ClvEstimado` = `TicketMedio × FrequenciaAnual × Horizonte` (horizonte padrão: 3 anos)
- `MesesComoCliente` = diferença em meses entre a primeira compra e a data atual
- Clientes com menos de 1 mês são normalizados para 1
- `ClvMediano` é mais resistente a outliers que o `ClvMedio`
- Ordenação padrão: `ClvEstimado` descendente
- Usado para priorização de investimento em retenção e aquisição
