# Relatório: Lucratividade por Produto

## Objetivo

Analisar a margem bruta de cada produto vendido em um período, comparando receita líquida com custo médio para identificar os produtos mais e menos rentáveis.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/lucratividade-produto` | Lucratividade por produto |

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
| `receitaBruta` | decimal | Receita bruta total |
| `descontoTotal` | decimal | Total de descontos |
| `receitaLiquida` | decimal | Receita líquida |
| `custoMedio` | decimal | Custo médio ponderado (do EstoqueSaldo) |
| `margemBruta` | decimal | Margem bruta em R$ |
| `margemBrutaPercentual` | decimal | Margem bruta em % |
| `totalVendas` | int | Quantidade de vendas do produto |

---

## Regras

- `ReceitaLiquida` = `ReceitaBruta - DescontoTotal`
- `MargemBruta` = `ReceitaLiquida - (CustoMedio × QuantidadeVendida)`
- `MargemBrutaPercentual` = `MargemBruta / ReceitaLiquida × 100`
- `CustoMedio` obtido do `EstoqueSaldo.CustoMedioPonderado`
- Produtos sem custo cadastrado terão margem = receita líquida
- Ordenação padrão: `MargemBruta` descendente
