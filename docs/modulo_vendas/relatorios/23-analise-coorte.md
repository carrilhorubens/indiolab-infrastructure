# Relatório: Análise de Coorte

## Objetivo

Analisar a retenção de clientes ao longo do tempo, agrupando-os por mês de primeira compra (coorte) e rastreando quantos continuam comprando nos meses seguintes.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/cohort` | Análise de coorte de clientes |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

### Coortes

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `cohort` | string | Mês de primeira compra (YYYY-MM) |
| `totalClientes` | int | Clientes que fizeram primeira compra no mês |
| `retencaoPercentual` | number[] | Array de % de retenção por período subsequente |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `periodos` | string[] | Labels dos períodos (Mês 0, Mês 1, Mês 2...) |
| `retencaoMediaGeral` | decimal | Média geral de retenção (%) |

---

## Regras

- Cada coorte = grupo de clientes que fizeram sua primeira compra no mesmo mês
- `RetencaoPercentual[0]` = 100% (mês da primeira compra, todos estão ativos)
- `RetencaoPercentual[n]` = % de clientes da coorte que voltaram a comprar no mês n
- Exemplo: coorte "2026-01" com 20 clientes → `[100, 65, 40, 30]` = 65% voltaram no mês 2, 40% no mês 3
- `RetencaoMediaGeral` = média de todas as retenções de todos os períodos
- Formato de tabela triangular: coortes mais antigas têm mais períodos
- Usado para avaliar a capacidade de retenção e o ciclo de vida do cliente
