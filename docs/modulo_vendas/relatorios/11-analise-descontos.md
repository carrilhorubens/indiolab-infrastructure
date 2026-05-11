# Relatório: Análise de Descontos

## Objetivo

Analisar todos os descontos concedidos em um período, tanto os descontos regulares (por vendedor) quanto os descontos especiais (acima do limite), com indicadores de desconto médio e valor total.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/analise-descontos` | Análise de descontos concedidos |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Descontos por Vendedor

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `vendedorId` | Guid | ID do vendedor |
| `vendedorNome` | string? | Nome do vendedor |
| `totalPedidos` | int | Pedidos com desconto |
| `descontoTotal` | decimal | Valor total de descontos (R$) |
| `descontoMedioPercentual` | decimal | Desconto médio em % |

### Descontos Especiais

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID do log de desconto especial |
| `vendedorNome` | string? | Vendedor solicitante |
| `produtoNome` | string? | Produto com desconto especial |
| `descontoSolicitado` | decimal | % solicitado |
| `descontoAprovado` | decimal | % efetivamente aprovado |
| `status` | string | Pendente, Aprovado, Rejeitado |
| `dataSolicitacao` | DateTime | Data da solicitação |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `descontoMedioGeral` | decimal | Desconto médio geral em % |
| `valorTotalDescontos` | decimal | Soma total de descontos (R$) |

---

## Regras

- Combina duas fontes: descontos regulares (dos itens de pedido) e descontos especiais (da entidade `LogDescontoEspecial`)
- `DescontoMedioPercentual` por vendedor = média ponderada dos descontos dos seus pedidos
- Lista de descontos especiais inclui todos os status (Pendente, Aprovado, Rejeitado)
- Alimentado pela entidade `LogDescontoEspecial` (audit trail)
