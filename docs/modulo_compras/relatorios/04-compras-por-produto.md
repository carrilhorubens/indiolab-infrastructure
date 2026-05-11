# Relatório: Compras por Produto

## Objetivo

Agrupar o volume de compras por produto em um período, identificando os itens mais comprados e o valor total gasto com cada um.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/compras-por-produto` | Agrupado por produto |

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
| `produtoId` | Guid | ID do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `totalOrdens` | int | Quantidade de ordens que incluem o produto |
| `quantidadeTotal` | decimal | Quantidade total comprada |
| `valorTotal` | decimal | Valor total gasto com o produto |

---

## Regras

- Agrupa por produto todos os itens de OCs no período
- Ordenado por valor total (maior primeiro)
