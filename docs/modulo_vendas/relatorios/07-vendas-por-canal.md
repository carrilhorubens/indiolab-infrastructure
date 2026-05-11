# Relatório: Vendas por Canal

## Objetivo

Agrupar pedidos de venda por canal de venda em um período, exibindo volume, receita, descontos, ticket médio e participação percentual de cada canal.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-canal` | Vendas agrupadas por canal |

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
| `canalVendaId` | Guid? | ID do canal de venda (nulo = sem canal) |
| `canalVendaNome` | string? | Nome do canal |
| `totalPedidos` | int | Quantidade de pedidos |
| `receitaBruta` | decimal | Receita bruta |
| `descontoTotal` | decimal | Total de descontos |
| `receitaLiquida` | decimal | Receita líquida |
| `ticketMedio` | decimal | Valor médio por pedido |
| `percentualDoTotal` | decimal | % de participação na receita geral |

---

## Regras

- Agrupa por `CanalVendaId` dos pedidos (domínio público)
- Canais possíveis: Loja Física, E-commerce, Televendas, Representante, etc.
- Pedidos sem canal associado aparecem com valores nulos
- Usado para análise de eficiência por canal de distribuição
