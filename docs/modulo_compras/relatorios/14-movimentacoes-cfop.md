# Relatório: Movimentações por CFOP

## Objetivo

Agrupar os recebimentos de mercadoria por código CFOP (Código Fiscal de Operações e Prestações), permitindo análise fiscal das entradas.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/movimentacoes-cfop` | Recebimentos agrupados por CFOP |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Recebimentos.View`

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
| `cfop` | string | Código CFOP |
| `descricao` | string? | Descrição do CFOP |
| `totalItens` | int | Quantidade de itens com esse CFOP |
| `quantidadeTotal` | decimal | Quantidade total movimentada |
| `valorTotal` | decimal | Valor total das movimentações |

---

## Regras

- Fonte de dados: itens de recebimentos de mercadoria confirmados
- Agrupa pelo campo `cfop` dos itens do recebimento
- Itens sem CFOP aparecem como "Sem CFOP"
- Filtra pela data do recebimento dentro do período
- Ordenado por CFOP (alfanumérico)
