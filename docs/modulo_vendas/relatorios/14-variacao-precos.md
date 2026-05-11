# Relatório: Variação de Preços

## Objetivo

Analisar a evolução histórica dos preços praticados nas vendas, por produto e opcionalmente por cliente, com rastreabilidade da fonte de cada registro de preço.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/variacao-precos` | Variação de preços de venda |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.HistoricoPrecos.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `produtoId` | Guid? | Não | Filtrar por produto específico |
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | ID do produto |
| `produtoNome` | string? | Nome do produto |
| `dataRegistro` | DateTime | Data do registro de preço |
| `precoUnitario` | decimal | Preço praticado |
| `fonteRegistro` | string | Fonte: PedidoVenda, Faturamento, TabelaPreco, Manual |
| `clienteNome` | string? | Cliente (nulo = preço geral) |

---

## Regras

- Dados alimentados pela entidade `HistoricoPrecoVenda` (write-once)
- Fontes de preço: `PedidoVenda` (ao confirmar pedido), `Faturamento` (ao emitir NF), `TabelaPreco` (ao atualizar tabela), `Manual` (via POST)
- `ClienteNome` nulo indica preço geral do produto; preenchido indica preço negociado
- Ordenação padrão: `DataRegistro` descendente
- Sem `produtoId`, retorna todos os produtos; com filtro, retorna apenas o produto selecionado
- Usado para análise de tendência e comparação de preços ao longo do tempo
