# Relatório: Giro de Estoque

## Objetivo

Medir a **rotatividade** (turnover) do estoque por produto, indicando quantas vezes o estoque é renovado em um período. Produtos com alto giro vendem rápido; produtos com baixo giro acumulam.

---

## Endpoint

```
GET /api/relatorios/estoque/giro-estoque?meses=12
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Default | Descrição |
|-----------|------|-------------|---------|-----------|
| `meses` | int | Não | 12 | Período de análise em meses |

---

## Campos Retornados

### Resultado Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `items` | array | Lista de produtos com giro calculado |
| `giroMedio` | decimal | Giro médio de todos os produtos |
| `diasEstoqueMedio` | decimal | Dias de estoque médio |
| `totalProdutos` | int | Total de produtos analisados |

### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `sku` | string? | SKU |
| `valorSaidas` | decimal | Custo total das saídas no período |
| `valorMedioEstoque` | decimal | Valor médio do estoque atual |
| `giro` | decimal | Índice de giro (saídas / estoque médio) |
| `diasEstoque` | decimal | Dias de cobertura de estoque |
| `classeAbc` | string? | Classificação ABC do produto |

---

## Regras de Negócio

1. **Saídas:** Soma do `CustoTotal` das movimentações de saída no período (excluindo canceladas)
2. **Estoque médio:** `Quantidade × CustoMedio` dos saldos atuais agrupados por produto
3. **Fórmula do Giro:** `Valor das Saídas / Valor Médio do Estoque`
4. **Dias de Estoque:** `(meses × 30) / Giro` — quantos dias o estoque cobre
5. **Giro = 0:** Produto sem saídas no período (dias de estoque = 999)
6. **Ordenação:** Por giro decrescente (mais rotativos primeiro)

---

## Como Interpretar

| Giro | Classificação | Cor no Frontend | Significado |
|------|---------------|-----------------|-------------|
| ≥ 6 | Alto | Verde | Produto com boa rotatividade |
| 3 - 6 | Médio | Amarelo | Rotatividade aceitável |
| < 3 | Baixo | Vermelho | Estoque parado, avaliar ação |

**Dias de Estoque:**
- **< 30 dias:** Risco de ruptura — aumentar ponto de reposição
- **30 - 90 dias:** Cobertura adequada
- **> 90 dias:** Excesso de estoque — reduzir compras

---

## Exemplo de Uso

**Cenário:** Gestor quer otimizar o capital investido em estoque, priorizando produtos com maior retorno.

1. Acesse: **Estoque > Relatórios > Giro de Estoque**
2. Defina o período de 12 meses e clique em **Calcular**
3. Observe os KPIs globais: Giro Médio e Dias de Estoque Médio
4. Produtos com giro alto + classe A = manter estoque bem abastecido
5. Produtos com giro baixo + classe C = reduzir compras, avaliar promoção
6. Cruzar com Curva ABC para decisões de compra estratégicas

---

## Fonte de Dados

- `MovimentacaoEstoque` — saídas no período
- `EstoqueSaldo` — saldo atual por produto
- `Produto` — dados do produto e classe ABC
