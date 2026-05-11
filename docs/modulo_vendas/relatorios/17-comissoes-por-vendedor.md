# Relatório: Comissões por Vendedor

## Objetivo

Detalhar as comissões de venda calculadas para cada vendedor em um período, com informações de pedido, faturamento, base de cálculo, percentual e valor da comissão.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/comissoes-por-vendedor` | Comissões detalhadas por vendedor |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Comissoes.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |
| `vendedorId` | Guid? | Não | Filtrar por vendedor específico |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `comissaoVendaId` | Guid | ID da comissão |
| `codigo` | int | Código da comissão |
| `vendedorId` | Guid | ID do vendedor |
| `vendedorNome` | string? | Nome do vendedor |
| `pedidoCodigo` | int? | Código do pedido de venda |
| `faturamentoCodigo` | int? | Código do faturamento |
| `periodoReferencia` | string | Período de referência (YYYY-MM) |
| `baseCalculo` | decimal | Base de cálculo da comissão (R$) |
| `percentualComissao` | decimal | Percentual aplicado (%) |
| `valorComissao` | decimal | Valor da comissão (R$) |
| `status` | string | Calculada, Aprovada, Contestada, Paga |
| `dataCalculo` | DateTime | Data do cálculo |

---

## Regras

- Lista individual de cada comissão calculada, não agrupada
- Filtra pelo `PeriodoReferencia` ou `DataCalculo` dentro do intervalo
- Sem `vendedorId`, retorna todos os vendedores; com filtro, apenas o selecionado
- Permite autocomplete de vendedor no frontend para facilitar a busca
- Ordenação padrão: `DataCalculo` descendente
