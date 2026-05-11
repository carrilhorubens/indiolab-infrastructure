# Relatório: Carteira de Pedidos

## Objetivo

Exibir todos os pedidos de venda em aberto (não entregues nem cancelados), com indicadores de progresso e tempo em aberto, permitindo acompanhamento da carteira ativa.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/carteira-pedidos` | Pedidos abertos/em andamento |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro obrigatório. Retorna toda a carteira ativa.

---

## Campos Retornados

### Items

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `pedidoVendaId` | Guid | ID do pedido de venda |
| `codigo` | int | Código do pedido |
| `clienteNome` | string? | Nome do cliente |
| `vendedorNome` | string? | Nome do vendedor |
| `status` | string | Status atual |
| `prioridade` | string | Prioridade do pedido |
| `dataEmissao` | DateTime | Data de emissão |
| `dataEntregaPrevista` | DateTime? | Data prevista de entrega |
| `valorTotal` | decimal | Valor total do pedido |
| `percentualEntregue` | decimal | % já entregue (0–100) |
| `diasAberto` | int | Dias desde a emissão |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalPedidos` | int | Total de pedidos na carteira |
| `valorTotalCarteira` | decimal | Soma dos valores da carteira |
| `totaisPorStatus` | Record<string, int> | Contagem de pedidos por status |

---

## Regras

- Inclui pedidos com status: Pedido, Aprovado, Faturado, Expedido
- Exclui: Entregue, Cancelado
- `PercentualEntregue` é calculado via `QuantidadeEntregue / Quantidade` dos itens
- `DiasAberto` = diferença em dias entre `DataEmissao` e a data atual
- `TotaisPorStatus` retorna um dicionário `{ "Pedido": 5, "Aprovado": 3, ... }`
