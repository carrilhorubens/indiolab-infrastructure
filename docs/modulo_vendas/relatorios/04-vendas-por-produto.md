# Relatório: Vendas por Produto

## Objetivo

Agrupar itens de pedidos de venda por produto em um período, exibindo quantidade vendida, receita bruta, descontos, receita líquida e participação percentual.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-produto` | Vendas agrupadas por produto |

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
| `produtoId` | Guid | ID do produto |
| `produtoNome` | string? | Nome do produto |
| `totalPedidos` | int | Quantidade de pedidos que incluem o produto |
| `quantidadeTotal` | decimal | Quantidade total vendida |
| `receitaBruta` | decimal | Receita bruta (antes de descontos) |
| `descontoTotal` | decimal | Total de descontos nos itens |
| `receitaLiquida` | decimal | Receita líquida (bruta − desconto) |
| `percentualDoTotal` | decimal | % de participação na receita geral |

---

## Regras

- Agrupa itens de pedido por `ProdutoId`
- `ReceitaLiquida` = `ReceitaBruta - DescontoTotal`
- `PercentualDoTotal` calculado sobre o total geral de todos os produtos
- Ordenação padrão: `ReceitaLiquida` descendente
- Retorna lista (não paginada)
