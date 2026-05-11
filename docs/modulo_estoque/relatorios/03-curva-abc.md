# Relatório: Curva ABC

## Objetivo

Classificar os produtos em categorias **A, B e C** com base no valor acumulado das saídas em um período, aplicando o princípio de Pareto (80/20) para priorizar gestão de estoque.

---

## Endpoint

```
POST /api/relatorios/estoque/curva-abc?dataInicio=2025-01-01&dataFim=2026-01-01
```

> **Nota:** Este endpoint usa método **POST** porque além de consultar, ele **atualiza** o campo `ClasseABC` de cada produto no banco de dados.

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período de análise |
| `dataFim` | DateTime | Sim | Data final do período de análise |

---

## Campos Retornados

### Resultado Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `items` | array | Lista de produtos classificados |
| `produtosA` | int | Quantidade de produtos classe A |
| `produtosB` | int | Quantidade de produtos classe B |
| `produtosC` | int | Quantidade de produtos classe C |
| `valorTotalSaidas` | decimal | Soma total das saídas no período |

### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `codigo` | int | Código do produto |
| `nome` | string | Nome do produto |
| `valorSaidas` | decimal | Valor total das saídas (custo) no período |
| `percentualAcumulado` | decimal | Percentual acumulado sobre o total |
| `classeAbc` | string | Classificação: "A", "B" ou "C" |

---

## Regras de Negócio

1. **Fonte de dados:** Movimentações de **saída** no período informado (excluindo canceladas)
2. **Cálculo:**
   - Ordenar produtos por valor de saída decrescente
   - Calcular percentual acumulado sobre o total
   - **Classe A:** Até 80% do valor acumulado (~20% dos produtos)
   - **Classe B:** De 80% a 95% do valor acumulado (~30% dos produtos)
   - **Classe C:** Acima de 95% (~50% dos produtos)
3. **Atualização:** O campo `ClasseABC` de cada produto é atualizado no banco de dados
4. **Produtos sem saída:** Classificados como "C"

---

## Como Interpretar

| Classe | % do Valor | % dos Itens | Gestão Recomendada |
|--------|-----------|-------------|-------------------|
| **A** | ~80% | ~20% | Controle rígido, contagem frequente, estoque de segurança preciso |
| **B** | ~15% | ~30% | Controle moderado, contagem periódica |
| **C** | ~5% | ~50% | Controle simplificado, contagem anual, lotes maiores |

---

## Exemplo de Uso

**Cenário:** Gerente quer saber quais produtos merecem atenção especial de compra e controle de estoque.

1. Acesse: **Estoque > Relatórios > Curva ABC**
2. Defina o período (últimos 12 meses)
3. Clique em **Calcular**
4. Produtos classe A (ex: Lente Progressiva Premium) devem ter ponto de reposição bem calibrado
5. Produtos classe C podem ter compras menos frequentes, em lotes maiores

---

## Fonte de Dados

- `MovimentacaoEstoque` — saídas (tipo "Saída") no período
- `Produto` — dados do produto e campo `ClasseABC` atualizado
