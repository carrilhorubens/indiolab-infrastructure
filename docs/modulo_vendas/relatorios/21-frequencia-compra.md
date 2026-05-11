# Relatório: Frequência de Compra

## Objetivo

Analisar a frequência de compra de cada cliente, incluindo intervalo médio entre pedidos, dias desde a última compra e ticket médio, para identificar padrões de comportamento.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/frequencia-compra` | Frequência de compra por cliente |

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
| `clienteNome` | string? | Nome do cliente |
| `totalPedidos` | int | Quantidade de pedidos no período |
| `receitaTotal` | decimal | Receita total do cliente |
| `ticketMedio` | decimal | Valor médio por pedido |
| `primeiraCompra` | DateTime | Data da primeira compra |
| `ultimaCompra` | DateTime | Data da última compra |
| `diasDesdeUltimaCompra` | int | Dias desde a última compra até hoje |
| `intervaloMedioDias` | decimal | Intervalo médio em dias entre compras |

---

## Regras

- Considera apenas clientes com pelo menos 1 pedido no período
- `IntervaloMedioDias` = média dos intervalos entre pedidos consecutivos
- Clientes com apenas 1 pedido terão `IntervaloMedioDias = 0`
- `DiasDesdeUltimaCompra` calculado em relação à data atual
- Usado para segmentação de clientes e ações de reativação
- Ordenação padrão: `TotalPedidos` descendente
