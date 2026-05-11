# Relatório: Vendas por Vendedor

## Objetivo

Agrupar pedidos de venda por vendedor em um período, exibindo volume, receita, descontos, ticket médio, comissão e participação percentual de cada vendedor.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-vendedor` | Vendas agrupadas por vendedor |

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
| `vendedorId` | Guid | ID do vendedor |
| `vendedorNome` | string? | Nome do vendedor |
| `totalPedidos` | int | Quantidade de pedidos |
| `receitaBruta` | decimal | Receita bruta |
| `descontoTotal` | decimal | Total de descontos concedidos |
| `receitaLiquida` | decimal | Receita líquida |
| `ticketMedio` | decimal | Valor médio por pedido |
| `comissaoTotal` | decimal | Total de comissões calculadas |
| `percentualDoTotal` | decimal | % de participação na receita geral |

---

## Regras

- Agrupa pedidos por `VendedorId`
- `TicketMedio` = `ReceitaLiquida / TotalPedidos`
- `ComissaoTotal` calculada a partir das comissões vinculadas ao vendedor no período
- Ordenação padrão: `ReceitaLiquida` descendente
- Retorna lista (não paginada)
