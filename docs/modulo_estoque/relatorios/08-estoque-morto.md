# Relatório: Estoque Morto (Dead Stock)

## Objetivo

Identificar produtos com saldo em estoque que **não tiveram nenhuma movimentação** nos últimos X dias, representando capital parado e potencial obsolescência.

---

## Endpoint

```
GET /api/relatorios/estoque/estoque-morto?dias=90
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Default | Descrição |
|-----------|------|-------------|---------|-----------|
| `dias` | int | Não | 90 | Quantidade de dias sem movimentação para considerar "morto" |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `sku` | string? | SKU do produto |
| `depositoNome` | string? | Depósito onde está parado |
| `quantidadeDisponivel` | decimal | Saldo disponível parado |
| `custoMedio` | decimal | Custo médio unitário |
| `valorParado` | decimal | Valor total parado (quantidade × custo médio) |
| `ultimaMovimentacao` | DateTime? | Data da última movimentação registrada |
| `diasParado` | int | Dias desde a última movimentação (999 se nunca movimentou) |

---

## Regras de Negócio

1. **Filtro primário:** Produtos com `QuantidadeDisponivel > 0` que **não** possuem movimentação nos últimos X dias
2. **Exclusão:** Movimentações com status "Cancelada" são ignoradas
3. **Ordenação:** Por valor parado decrescente (maior capital parado primeiro)
4. **Dias parado = 999:** Produto nunca teve movimentação registrada
5. **Granularidade:** Por produto × depósito

---

## Como Interpretar

| Dias Parado | Classificação | Ação Recomendada |
|-------------|---------------|-----------------|
| 90 - 180 | Atenção | Avaliar promoção ou reposicionamento |
| 180 - 365 | Crítico | Promoção agressiva, devolução ao fornecedor ou desconto |
| > 365 | Obsoleto | Descarte, doação ou liquidação |

**Métricas de referência:**
- **Meta:** Estoque morto < 10% do valor total do estoque
- **KPI:** `Valor Parado / Valor Total Estoque × 100`

---

## Exemplo de Uso

**Cenário:** Gestor quer liberar capital preso em mercadorias encalhadas para investir em produtos com maior giro.

1. Acesse: **Estoque > Relatórios > Estoque Morto**
2. Defina 180 dias no filtro para identificar produtos parados há mais de 6 meses
3. Ordene por "Valor Parado" para priorizar ações nos itens de maior valor
4. Para armações de modelos antigos → crie promoção de queima de estoque
5. Para insumos sem uso → negocie devolução com o fornecedor

---

## Fonte de Dados

- `EstoqueSaldo` — saldo disponível por produto/depósito
- `MovimentacaoEstoque` — data da última movimentação (excluindo canceladas)
- `Produto` — nome, código, SKU
- `Deposito` — nome do depósito
