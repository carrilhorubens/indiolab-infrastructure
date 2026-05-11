# Relatório: Sazonalidade

## Objetivo

Identificar padrões sazonais nas vendas, calculando o índice de sazonalidade de cada mês do ano para apoiar o planejamento de estoque, compras e campanhas.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/seasonality` | Análise de sazonalidade |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

### Meses

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mes` | int | Número do mês (1–12) |
| `mesNome` | string | Nome do mês em português |
| `indicesSazonalidade` | decimal | Índice sazonal (1.0 = média, >1.0 = acima, <1.0 = abaixo) |
| `mediaReceita` | decimal | Receita média histórica do mês (R$) |
| `mediaPedidos` | decimal | Média de pedidos no mês |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mediaAnualReceita` | decimal | Receita média anual (R$) |
| `mesPico` | string | Mês com maior índice de sazonalidade |
| `mesBaixo` | string | Mês com menor índice de sazonalidade |

---

## Regras

- `IndiceSazonalidade` = `MediaReceitaMes / MediaMensalGeral`
- Índice > 1.0 = mês acima da média (alta temporada)
- Índice < 1.0 = mês abaixo da média (baixa temporada)
- Índice = 1.0 = exatamente na média
- Requer pelo menos 12 meses de histórico para resultados significativos
- `MesPico` e `MesBaixo` identificam automaticamente a sazonalidade extrema
- Usado para planejamento de compras, estoque e campanhas promocionais
