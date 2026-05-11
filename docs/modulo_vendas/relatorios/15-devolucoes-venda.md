# Relatório: Devoluções de Venda

## Objetivo

Analisar as devoluções de venda em um período, agrupadas por motivo e por produto, com taxa de devolução e totalizadores de valor devolvido.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/devolucoes-venda` | Devoluções de venda no período |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Devolucoes.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Devoluções por Motivo

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `motivoNome` | string | Nome do motivo de devolução |
| `totalDevolucoes` | int | Quantidade de devoluções |
| `valorTotal` | decimal | Valor total devolvido por motivo |
| `percentualDoTotal` | decimal | % em relação ao total de devoluções |

### Devoluções por Produto

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | ID do produto devolvido |
| `produtoNome` | string? | Nome do produto |
| `totalDevolucoes` | int | Quantidade de devoluções do produto |
| `quantidadeDevolvida` | decimal | Quantidade total devolvida |
| `valorDevolvido` | decimal | Valor total devolvido |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalDevolucoes` | int | Total geral de devoluções |
| `valorTotalDevolvido` | decimal | Soma dos valores devolvidos |
| `taxaDevolucao` | decimal | % de devoluções em relação ao total de vendas |

---

## Regras

- `TaxaDevolucao` = `TotalDevolucoes / TotalVendasNoPeriodo × 100`
- Agrupa devoluções por `MotivoDevolucao` (domínio) e por `ProdutoId` dos itens
- Considera devoluções pela `DataDevolucao` dentro do período
- Alimenta decisões de qualidade, estoque e atendimento ao cliente
