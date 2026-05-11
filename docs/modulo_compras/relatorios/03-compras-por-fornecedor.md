# Relatório: Compras por Fornecedor

## Objetivo

Agrupar o volume de compras por fornecedor em um período, identificando os maiores fornecedores e o total gasto com cada um.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/compras-por-fornecedor` | Agrupado por fornecedor |

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
| `fornecedorId` | Guid | ID do fornecedor |
| `fornecedorNome` | string | Nome do fornecedor |
| `totalOrdens` | int | Quantidade de ordens |
| `valorTotal` | decimal | Valor total de compras |

---

## Regras

- Agrupa por fornecedor todas as OCs no período
- Ordenado por valor total (maior primeiro)
