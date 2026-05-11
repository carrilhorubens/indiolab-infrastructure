# Relatório: Estoque Mínimo

## Objetivo

Identificar produtos cujo saldo disponível está **abaixo do ponto de reposição**, permitindo ao gestor tomar ações de compra antes que ocorra ruptura de estoque (stockout).

---

## Endpoint

```
GET /api/relatorios/estoque/estoque-minimo
```

**Parâmetros:** Nenhum (carrega automaticamente todos os produtos abaixo do ponto de reposição).

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código numérico do produto |
| `produtoNome` | string | Nome do produto |
| `sku` | string? | SKU do produto |
| `depositoNome` | string? | Nome do depósito onde o saldo está baixo |
| `quantidadeDisponivel` | decimal | Saldo disponível atual |
| `pontoReposicao` | decimal | Ponto de reposição configurado no cadastro |
| `estoqueMinimo` | decimal | Estoque mínimo configurado no cadastro |
| `deficit` | decimal | Diferença entre ponto de reposição e saldo disponível |

---

## Regras de Negócio

1. **Filtro:** Somente produtos onde `QuantidadeDisponivel < PontoReposicao` e `PontoReposicao > 0`
2. **Ordenação:** Por déficit decrescente (produtos mais críticos primeiro)
3. **Granularidade:** Por produto × depósito (o mesmo produto pode aparecer em mais de um depósito)
4. **Movimentações canceladas:** Não afetam o saldo, portanto não impactam o relatório

---

## Como Interpretar

- **Déficit alto (vermelho):** Produto muito abaixo do necessário — ação urgente de compra
- **Déficit baixo (amarelo):** Produto próximo do limite — planejar reposição
- **Ponto de Reposição vs Estoque Mínimo:**
  - *Ponto de Reposição* = quantidade em que se deve disparar o pedido de compra
  - *Estoque Mínimo* = quantidade mínima de segurança (nunca deveria chegar abaixo)

---

## Exemplo de Uso

**Cenário:** Gestor de compras verifica semanalmente quais lentes e armações precisam ser repostas.

1. Acesse o relatório via menu: **Estoque > Relatórios > Estoque Mínimo**
2. A tabela carrega automaticamente os produtos abaixo do ponto de reposição
3. Ordene por "Déficit" para priorizar os pedidos de compra
4. Use o campo "SKU" e "Depósito" para identificar exatamente onde falta mercadoria

---

## Fonte de Dados

- `EstoqueSaldo` — saldo disponível por produto/depósito
- `Produto` — ponto de reposição e estoque mínimo
- `Deposito` — nome do depósito
