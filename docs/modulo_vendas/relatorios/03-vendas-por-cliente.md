# Relatório: Vendas por Cliente

## Objetivo

Agrupar pedidos de venda por cliente em um período, exibindo volume, valor, ticket médio e participação percentual de cada cliente no faturamento total.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-cliente` | Vendas agrupadas por cliente |

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

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clienteId` | Guid | ID do cliente |
| `clienteNome` | string | Nome do cliente |
| `totalPedidos` | int | Quantidade de pedidos |
| `valorTotal` | decimal | Valor total de vendas |
| `descontoTotal` | decimal | Total de descontos concedidos |
| `ticketMedio` | decimal | Valor médio por pedido |
| `percentualDoTotal` | decimal | % de participação no faturamento geral |
| `ultimaVenda` | DateTime? | Data da última venda para o cliente |

---

## Regras

- Agrupa por `ClienteId` todos os pedidos no período
- `TicketMedio` = `ValorTotal / TotalPedidos`
- `PercentualDoTotal` = `ValorTotal do Cliente / ValorTotal Geral × 100`
- Ordenação padrão: `ValorTotal` descendente (maiores clientes primeiro)
- Retorna lista (não paginada)
