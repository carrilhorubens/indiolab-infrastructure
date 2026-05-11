# Relatório: Análise de Gastos

## Objetivo

Analisar os gastos de compras agrupados por categoria de compra em um período, identificando a distribuição do orçamento.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/analise-gastos` | Gastos por categoria |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.OrdensCompra.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Início do período |
| `dataFim` | DateTime | Sim | Fim do período |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `categoriaId` | Guid? | ID da categoria de compra |
| `categoriaNome` | string | Nome da categoria (ou "Sem Categoria") |
| `totalOrdens` | int | Quantidade de ordens na categoria |
| `valorTotal` | decimal | Valor total gasto |
| `percentualTotal` | decimal | Percentual em relação ao total geral |

---

## Regras

- Agrupa ordens de compra pela `categoriaCompraId`
- Ordens sem categoria aparecem como "Sem Categoria"
- Percentual calculado em relação ao valor total de todas as categorias
- Ordenado por valor total (maior primeiro)
