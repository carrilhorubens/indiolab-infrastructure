# Relatório: Valoração de Estoque

## Objetivo

Calcular o **valor total do estoque** agrupado por produto, mostrando quantidade, custo médio e participação percentual de cada produto sobre o patrimônio total em estoque.

---

## Endpoint

```
GET /api/relatorios/estoque/valoracao
```

**Parâmetros:** Nenhum (carrega automaticamente todos os produtos com saldo).

---

## Campos Retornados

### Resultado Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `items` | array | Lista de produtos com valoração |
| `valorTotalEstoque` | decimal | Valor total de todo o estoque |
| `totalProdutos` | int | Total de produtos com saldo > 0 |

### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `sku` | string? | SKU |
| `unidadeMedidaSigla` | string? | Sigla da unidade de medida |
| `quantidadeTotal` | decimal | Quantidade total em todos os depósitos |
| `custoMedio` | decimal | Custo médio ponderado |
| `valorTotal` | decimal | Valor total (quantidade × custo médio) |
| `percentualDoTotal` | decimal | Participação percentual sobre o valor total do estoque |

---

## Regras de Negócio

1. **Agrupamento:** Saldos agrupados por `ProdutoId` — soma quantidades de todos os depósitos
2. **Custo médio:** Calculado como `ValorTotal / QuantidadeTotal` (média ponderada entre depósitos)
3. **Percentual:** `ValorTotal do produto / ValorTotal do estoque × 100`
4. **Filtro:** Somente produtos com `QuantidadeDisponivel > 0`
5. **Ordenação:** Por valor total decrescente (maior valor primeiro)
6. **Método:** Custo médio ponderado (padrão do sistema)

---

## Como Interpretar

- **Top 10 produtos:** Os 10 produtos com maior valor são destacados no frontend — representam a maior parte do capital investido
- **Percentual do total:** Permite identificar concentração — se poucos produtos representam muito valor, há risco de perda concentrada
- **Custo médio alto + quantidade baixa:** Produto premium com estoque enxuto
- **Custo médio baixo + quantidade alta:** Produto popular com alto volume

**Para fins contábeis:**
- O valor total do estoque deve coincidir com o saldo contábil da conta de estoques
- Diferenças indicam necessidade de inventário físico

---

## Exemplo de Uso

**Cenário:** Gerente financeiro precisa do valor do estoque para fechamento mensal.

1. Acesse: **Estoque > Relatórios > Valoração de Estoque**
2. O relatório carrega automaticamente
3. Observe o KPI "Valor Total do Estoque" para o número consolidado
4. Analise os top 10 produtos para entender onde está concentrado o capital
5. Compare com o mês anterior (via Saldo Histórico) para identificar variação

---

## Fonte de Dados

- `EstoqueSaldo` — quantidade disponível e custo médio
- `Produto` — nome, código, SKU, unidade de medida
