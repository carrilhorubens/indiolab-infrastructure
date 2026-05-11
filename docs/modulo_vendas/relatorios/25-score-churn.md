# Relatório: Score de Churn (Risco de Perda)

## Objetivo

Identificar clientes com risco de churn (abandono), calculando um score de risco baseado em recência, frequência e valor, classificando o nível de risco.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/churn` | Score de risco de churn |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clienteId` | Guid | ID do cliente |
| `clienteNome` | string? | Nome do cliente |
| `diasDesdeUltimaCompra` | int | Dias desde a última compra |
| `receitaTotal` | decimal | Receita total do cliente (R$) |
| `totalPedidos` | int | Total de pedidos |
| `scoreRisco` | decimal | Score de risco (0–100, maior = mais risco) |
| `nivelRisco` | string | Baixo, Médio, Alto, Crítico |

---

## Níveis de Risco

| Nível | Score | Significado |
|-------|-------|-------------|
| Baixo | 0–25 | Cliente ativo e recente |
| Médio | 26–50 | Sinais de redução na frequência |
| Alto | 51–75 | Sem compra recente, provável abandono |
| Crítico | 76–100 | Longo período sem compra, risco iminente |

---

## Regras

- `ScoreRisco` combina: recência (peso maior), frequência de compra, e tendência de gastos
- Clientes com alta recência (muitos dias sem compra) recebem score mais alto
- Clientes com frequência declinante também elevam o score
- Ordenação padrão: `ScoreRisco` descendente (mais críticos primeiro)
- Usado para ações proativas de retenção e campanhas de reativação
