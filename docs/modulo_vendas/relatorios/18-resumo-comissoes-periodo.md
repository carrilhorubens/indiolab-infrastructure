# Relatório: Resumo de Comissões por Período

## Objetivo

Consolidar as comissões de venda por vendedor em um período, exibindo totais, base de cálculo, percentual médio e distribuição por status (Calculada, Aprovada, Paga).

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/resumo-comissoes-periodo` | Resumo consolidado de comissões |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Comissoes.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Por Vendedor

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `vendedorId` | Guid | ID do vendedor |
| `vendedorNome` | string? | Nome do vendedor |
| `totalComissoes` | int | Quantidade de comissões |
| `valorTotalComissao` | decimal | Valor total de comissões (R$) |
| `baseCalculoTotal` | decimal | Soma das bases de cálculo |
| `percentualMedio` | decimal | Percentual médio de comissão |
| `comissoesCalculadas` | int | Comissões com status Calculada |
| `comissoesAprovadas` | int | Comissões com status Aprovada |
| `comissoesPagas` | int | Comissões com status Paga |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `periodoReferencia` | string | Período consolidado |
| `totalComissoes` | int | Total geral de comissões |
| `valorTotalComissoes` | decimal | Valor total geral |

---

## Regras

- Agrupa comissões por `VendedorId` no período
- `PercentualMedio` = média dos percentuais de comissão do vendedor
- Distribuição por status permite acompanhar o pipeline de pagamento
- Diferente do relatório 17 (detalhado), este é um resumo consolidado
