# Relatório: Metas vs Realizado

## Objetivo

Comparar as metas de venda definidas com os valores efetivamente realizados, por vendedor e/ou região, exibindo percentual de atingimento e status de cada meta.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/metas-vs-realizado` | Comparativo metas vs realizado |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.MetasVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `periodo` | string? | Não | Período no formato YYYY-MM (nulo = todos) |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `metaVendaId` | Guid | ID da meta de venda |
| `codigo` | int | Código da meta |
| `vendedorId` | Guid? | ID do vendedor (nulo = meta por região) |
| `regiaoNome` | string? | Nome da região (nulo = meta por vendedor) |
| `periodo` | string | Período da meta (YYYY-MM) |
| `tipoMeta` | string | Receita, Quantidade, MargemBruta, NovosClientes |
| `valorMeta` | decimal | Valor/quantidade definido como meta |
| `valorRealizado` | decimal | Valor/quantidade efetivamente atingido |
| `percentualAtingimento` | decimal | % de atingimento (realizado/meta × 100) |
| `status` | string | Ativa, Encerrada |

---

## Regras

- Sem filtro de `periodo`, retorna todas as metas cadastradas
- Com filtro, retorna apenas metas do período informado
- `PercentualAtingimento` = `ValorRealizado / ValorMeta × 100`
- Pode ultrapassar 100% (sobre-atingimento)
- Metas podem ser por vendedor, por região, ou por ambos
- `TipoMeta` define a unidade: Receita (R$), Quantidade (unidades), MargemBruta (R$), NovosClientes (contagem)
