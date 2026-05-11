# Relatório: Forecast de Vendas

## Objetivo

Projetar o volume de vendas futuro com base no histórico recente, utilizando regressão linear para estimar tendência e valores projetados para os próximos meses.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/forecast` | Previsão de vendas |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `mesesProjecao` | int | Não | Quantidade de meses a projetar (padrão: 3) |

---

## Campos Retornados

### Meses

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `periodo` | string | Período no formato YYYY-MM |
| `valorRealizado` | decimal | Valor efetivamente vendido (meses passados) |
| `valorProjetado` | decimal | Valor projetado (meses futuros) |
| `isProjecao` | bool | `true` se o valor é projeção, `false` se é realizado |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mediaMensal` | decimal | Média mensal de vendas no histórico |
| `tendenciaPercentual` | decimal | Tendência em % (positiva = crescimento, negativa = queda) |

---

## Regras

- Utiliza os últimos 12 meses de vendas como base histórica
- Projeção via regressão linear simples sobre o valor mensal
- `TendenciaPercentual` indica se as vendas estão crescendo ou diminuindo
- Meses históricos têm `isProjecao = false` e `valorProjetado = 0`
- Meses futuros têm `isProjecao = true` e `valorRealizado = 0`
- Usado para planejamento de estoque, compras e metas
