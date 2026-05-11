# Relatório: Curva ABC de Produtos

## Objetivo

Classificar os produtos em categorias A, B e C com base na receita gerada no período, seguindo o princípio de Pareto (80/20), para identificar os produtos mais relevantes no portfólio.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/curva-abc-produtos` | Curva ABC de produtos |

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
| `produtoId` | Guid | ID do produto |
| `produtoNome` | string? | Nome do produto |
| `receitaTotal` | decimal | Receita total do produto no período |
| `quantidadeVendida` | decimal | Quantidade total vendida |
| `percentualDoTotal` | decimal | % individual da receita geral |
| `percentualAcumulado` | decimal | % acumulado (para curva ABC) |
| `classeAbc` | string | Classificação: A, B ou C |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalProdutos` | int | Total de produtos analisados |
| `receitaTotal` | decimal | Receita total do período |
| `produtosA` | int | Quantidade de produtos classe A |
| `produtosB` | int | Quantidade de produtos classe B |
| `produtosC` | int | Quantidade de produtos classe C |

---

## Regras

- Produtos ordenados por `ReceitaTotal` descendente
- Classificação: **A** = percentual acumulado até 80%, **B** = 80–95%, **C** = 95–100%
- `PercentualAcumulado` é calculado somando sequencialmente os `PercentualDoTotal`
- Usado para decisões de estoque, compras e estratégia de portfólio
