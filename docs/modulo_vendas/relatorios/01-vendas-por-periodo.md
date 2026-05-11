# Relatório: Vendas por Período

## Objetivo

Listar todos os pedidos de venda realizados em um intervalo de datas, com totalizadores de valor e desconto, permitindo análise do volume de vendas no período.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-periodo` | Pedidos de venda no período |

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

### Items

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `pedidoVendaId` | Guid | ID do pedido de venda |
| `codigo` | int | Código do pedido |
| `dataEmissao` | DateTime | Data de emissão |
| `clienteNome` | string? | Nome do cliente |
| `vendedorNome` | string? | Nome do vendedor |
| `prioridade` | string | Prioridade (Normal, Alta, Urgente) |
| `status` | string | Status atual do pedido |
| `totalItens` | int | Quantidade de itens no pedido |
| `subTotal` | decimal | Subtotal antes de desconto |
| `descontoValor` | decimal | Valor do desconto aplicado |
| `valorFrete` | decimal | Valor do frete |
| `valorTotal` | decimal | Valor total do pedido |
| `dataEntregaPrevista` | DateTime? | Data prevista de entrega |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalRegistros` | int | Total de pedidos no período |
| `valorTotal` | decimal | Soma dos valores de todos os pedidos |
| `descontoTotal` | decimal | Soma dos descontos concedidos |

---

## Regras

- Filtra pedidos pela `DataEmissao` dentro do intervalo informado
- Inclui pedidos de todos os status (inclusive Cancelados)
- Resolve nomes de cliente e vendedor via join com Pessoa
- Ordenação padrão: `DataEmissao` descendente
