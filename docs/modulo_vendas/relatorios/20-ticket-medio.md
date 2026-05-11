# Relatório: Ticket Médio

## Objetivo

Calcular o ticket médio de vendas em um período, com possibilidade de agrupamento por dimensão (geral, por vendedor, por cliente, por canal), exibindo mínimo e máximo para análise de dispersão.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/ticket-medio` | Ticket médio por dimensão |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |
| `agrupamento` | string? | Não | Dimensão: vendedor, cliente, canal (nulo = geral) |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `dimensao` | string | ID da dimensão (vendedorId, clienteId, canalId, ou "geral") |
| `dimensaoNome` | string? | Nome da dimensão |
| `totalPedidos` | int | Quantidade de pedidos |
| `receitaTotal` | decimal | Receita total |
| `ticketMedio` | decimal | Valor médio por pedido |
| `ticketMinimo` | decimal | Menor valor de pedido |
| `ticketMaximo` | decimal | Maior valor de pedido |

---

## Regras

- `TicketMedio` = `ReceitaTotal / TotalPedidos`
- Sem `agrupamento`, retorna uma única linha com o ticket médio geral
- Com `agrupamento = "vendedor"`, agrupa por vendedor
- Com `agrupamento = "cliente"`, agrupa por cliente
- Com `agrupamento = "canal"`, agrupa por canal de venda
- `TicketMinimo` e `TicketMaximo` indicam a dispersão dos valores
- Ordenação padrão: `TicketMedio` descendente
