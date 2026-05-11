# Relatório: Vendas por Região

## Objetivo

Agrupar pedidos de venda por região de venda em um período, exibindo volume, receita e participação percentual de cada região no faturamento total.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/vendas-por-regiao` | Vendas agrupadas por região |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.RegioesVenda.View`

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
| `regiaoVendaId` | Guid? | ID da região de venda (nulo = sem região) |
| `regiaoVendaNome` | string? | Nome da região |
| `totalPedidos` | int | Quantidade de pedidos na região |
| `receitaBruta` | decimal | Receita bruta |
| `receitaLiquida` | decimal | Receita líquida |
| `percentualDoTotal` | decimal | % de participação na receita geral |

---

## Regras

- Agrupa por `RegiaoVendaId` dos pedidos
- Pedidos sem região associada aparecem com `regiaoVendaId` e `regiaoVendaNome` nulos
- Usado para análise de cobertura territorial e definição de metas por região
- Ordenação padrão: `ReceitaLiquida` descendente
