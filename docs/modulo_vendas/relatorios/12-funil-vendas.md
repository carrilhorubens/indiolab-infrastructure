# Relatório: Funil de Vendas

## Objetivo

Analisar a conversão do pipeline comercial, desde orçamentos até pedidos efetivados, exibindo cada etapa do funil com quantidade, valor e taxa de conversão.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/funil-vendas` | Funil de conversão de vendas |

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

### Etapas do Funil

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `etapa` | string | Nome da etapa (ex: Orçamento, Enviado, Aprovado, Pedido) |
| `quantidade` | int | Quantidade de registros na etapa |
| `valorTotal` | decimal | Valor total na etapa |
| `percentualConversao` | decimal | % de conversão em relação à etapa anterior |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `taxaConversaoGeral` | decimal | Taxa de conversão orçamento → pedido (%) |
| `totalOrcamentos` | int | Total de orçamentos no período |
| `totalPedidos` | int | Total de pedidos gerados |
| `valorOrcamentos` | decimal | Valor total dos orçamentos |
| `valorPedidos` | decimal | Valor total dos pedidos |

---

## Regras

- Etapas do funil: Orçamento → Enviado → Em Negociação → Aprovado → Convertido (Pedido)
- `TaxaConversaoGeral` = `TotalPedidos / TotalOrcamentos × 100`
- `PercentualConversao` de cada etapa calculado em relação à etapa imediatamente anterior
- Considera orçamentos criados no período (pela `DataEmissao`)
- Orçamentos convertidos são rastreados pelo campo `PedidoVendaId` (FK preenchida)
