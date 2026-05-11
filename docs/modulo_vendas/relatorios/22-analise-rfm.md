# Relatório: Análise RFM

## Objetivo

Segmentar clientes utilizando a metodologia RFM (Recência, Frequência, Monetário), atribuindo scores de 1 a 5 para cada dimensão e classificando em segmentos comportamentais.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/rfm` | Análise RFM de clientes |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

### Clientes

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clienteId` | Guid | ID do cliente |
| `clienteNome` | string? | Nome do cliente |
| `recencia` | int | Dias desde a última compra |
| `frequencia` | int | Total de pedidos (histórico completo) |
| `monetario` | decimal | Valor total gasto (R$) |
| `scoreR` | int | Score de Recência (1–5, 5 = mais recente) |
| `scoreF` | int | Score de Frequência (1–5, 5 = mais frequente) |
| `scoreM` | int | Score Monetário (1–5, 5 = maior gasto) |
| `segmento` | string | Segmento do cliente (ex: Campeões, Em Risco) |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `segmentoContagem` | Record<string, int> | Contagem de clientes por segmento |
| `totalClientes` | int | Total de clientes analisados |

---

## Segmentos

| Segmento | Critério |
|----------|----------|
| Campeões | R≥4, F≥4, M≥4 |
| Leais | F≥3, M≥3 |
| Potenciais Leais | R≥3, F≥2 |
| Novos Clientes | R≥4, F=1 |
| Precisam de Atenção | R=2-3, F=2-3 |
| Em Risco | R=1-2, F≥3 |
| Hibernando | R=1-2, F=1-2 |
| Perdidos | R=1, F=1 |

---

## Regras

- Scores calculados por quintis (distribuição em 5 faixas iguais)
- Recência: score alto = compra mais recente
- Frequência: score alto = mais pedidos
- Monetário: score alto = maior gasto total
- `SegmentoContagem` retorna um dicionário `{ "Campeões": 5, "Em Risco": 12, ... }`
- Usado para estratégias de marketing, retenção e fidelização
