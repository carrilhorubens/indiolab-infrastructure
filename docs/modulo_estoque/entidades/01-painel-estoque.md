# Consulta: Painel de Estoque (Dashboard)

## Objetivo

Apresentar uma visão consolidada do módulo de estoque com 18 KPIs, alertas automáticos, tendência de valor e distribuição de movimentações por tipo.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/dashboard/estoque` | KPIs consolidados do estoque |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.View`

---

## Parâmetros

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `dataInicio` | DateTime? | Início do período de análise (padrão: 12 meses antes de dataFim) |
| `dataFim` | DateTime? | Fim do período (padrão: data atual) |

---

## KPIs Retornados

### Estado Atual (não afetados pelo período)

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `valorTotalEstoque` | decimal | Soma de `QuantidadeDisponivel × CustoMedio` de todos os saldos |
| `totalSKUs` | int | Total de produtos cadastrados |
| `totalSKUsAtivos` | int | Produtos com status ativo |
| `totalDepositos` | int | Depósitos ativos |
| `taxaRuptura` | decimal | % de SKUs ativos sem saldo disponível |
| `produtosAbaixoReposicao` | int | SKUs com saldo abaixo do ponto de reposição |
| `lotesVencendo30Dias` | int | Lotes com validade nos próximos 30 dias |
| `produtosClasseA` | int | Produtos classificados como Classe A (Curva ABC) |
| `produtosClasseB` | int | Produtos classificados como Classe B |
| `produtosClasseC` | int | Produtos classificados como Classe C |
| `produtosSemClassificacao` | int | Produtos sem classificação ABC |
| `valorConsignadoTotal` | decimal | Valor total do estoque consignado |
| `itensConsignados` | int | Quantidade de registros de consignação ativos |

### Fluxo (filtrados pelo período)

| KPI | Tipo | Descrição |
|-----|------|-----------|
| `giroEstoque` | decimal | Taxa de giro anualizada: `(CustoSaídas / ValorTotal) × (12 / meses)` |
| `diasEstoque` | decimal | Dias de estoque: `365 / GiroEstoque` |

---

## Alertas Automáticos

O sistema gera alertas com base em regras predefinidas:

| Tipo | Condição | Gravidade |
|------|----------|-----------|
| `EstoqueMinimo` | Produtos abaixo do ponto de reposição | "alta" se > 10, "media" caso contrário |
| `LotesVencendo` | Lotes vencendo nos próximos 30 dias | "alta" se > 5, "media" caso contrário |
| `Ruptura` | SKUs ativos em ruptura de estoque | "alta" se > 20, "baixa" caso contrário |
| `LotesVencidos` | Lotes com data de validade expirada | Sempre "alta" |

Cada alerta contém: `tipo`, `mensagem`, `quantidade` e `gravidade`.

---

## Tendência de Valor

Lista mensal do valor total do estoque histórico:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mes` | string | Formato "YYYY-MM" (ex: "2026-03") |
| `valor` | decimal | Soma de `ValorTotal` do `EstoqueSaldoHistorico` no mês |

Fonte: tabela `EstoqueSaldoHistorico` agrupada por ano/mês.

---

## Movimentações por Tipo

Distribuição das movimentações no período:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `tipo` | string | Nome do tipo de movimentação (ou "Sem Tipo") |
| `quantidade` | int | Quantidade de movimentações |
| `valor` | decimal | Soma do custo total das movimentações |

Exclui movimentações com status "Cancelada".

---

## Fórmulas de Cálculo

### Giro de Estoque
```
CustoSaidas = SUM(CustoTotal) das movimentações de Saída no período
MesesPeriodo = MAX(1, DiasNoPeriodo / 30)
GiroEstoque = (CustoSaidas / ValorTotalEstoque) × (12 / MesesPeriodo)
```

### Taxa de Ruptura
```
SKUsEmRuptura = SKUs ativos sem nenhum registro de saldo com QuantidadeDisponivel > 0
TaxaRuptura = (SKUsEmRuptura / TotalSKUsAtivos) × 100
```

### Valor do Consignado
```
ValorConsignado = SUM(Quantidade × Produto.CustoUnitario)  // via JOIN com tabela de produtos
```

---

## Exemplo de Uso

### Consultar dashboard com período customizado

```
GET /api/dashboard/estoque?dataInicio=2026-01-01&dataFim=2026-03-31
```

### Consultar dashboard padrão (últimos 12 meses)

```
GET /api/dashboard/estoque
```
