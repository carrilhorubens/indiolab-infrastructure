# Relatório: Cross-sell / Up-sell

## Objetivo

Identificar associações entre produtos comprados juntos (market basket analysis), calculando métricas de confiança e suporte para sugerir vendas cruzadas e complementares.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/cross-sell` | Análise de cross-sell |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

Nenhum parâmetro. Analisa todo o histórico de vendas.

---

## Campos Retornados

### Associações

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoAId` | Guid | ID do produto A |
| `produtoANome` | string? | Nome do produto A |
| `produtoBId` | Guid | ID do produto B |
| `produtoBNome` | string? | Nome do produto B |
| `ocorrenciasJuntas` | int | Vezes que A e B foram comprados juntos |
| `confianca` | decimal | Confiança da regra: P(B|A) (0–1) |
| `suporte` | decimal | Suporte: % de pedidos com ambos (0–1) |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalPedidosAnalisados` | int | Total de pedidos na base de análise |

---

## Métricas

| Métrica | Fórmula | Significado |
|---------|---------|-------------|
| **Suporte** | Pedidos(A∧B) / TotalPedidos | % de pedidos que contêm ambos os produtos |
| **Confiança** | Pedidos(A∧B) / Pedidos(A) | Probabilidade de B dado que A foi comprado |

---

## Regras

- Analisa pares de produtos que aparecem no mesmo pedido de venda
- Pares com `ocorrenciasJuntas` abaixo de um limite mínimo são filtrados
- `Confianca` alta indica forte associação: quem compra A quase sempre compra B
- `Suporte` alto indica que o par é frequente na base geral
- Ordenação padrão: `OcorrenciasJuntas` descendente
- Usado para recomendações de venda, combos e estratégias de merchandising
- Exemplo no setor óptico: Armação + Lente, Lente + Tratamento Antirreflexo
