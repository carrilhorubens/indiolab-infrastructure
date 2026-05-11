# Entidade: Histórico de Preços de Venda

## Objetivo

Registrar a evolução histórica dos preços praticados nas vendas, por produto e opcionalmente por cliente, com rastreabilidade da fonte do registro.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/historico-precos-venda` | Lista filtrada e paginada |
| `POST` | `/api/historico-precos-venda` | Cria registro manual |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.HistoricoPrecos.View` (GET) / `Permissions.Vendas.View` (POST)

---

## Parâmetros (GET)

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------:|
| `produtoId` | Guid | Não | Filtrar por produto |
| `clienteId` | Guid | Não | Filtrar por cliente |
| `dataInicio` | DateTime | Não | Início do período |
| `dataFim` | DateTime | Não | Fim do período |
| `page` | int | Não | Página |
| `pageSize` | int | Não | Itens por página |

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `produtoId` | Guid | Sim | FK para produto |
| `clienteId` | Guid? | Não | Preço específico para cliente (nulo = preço geral) |
| `precoUnitario` | decimal | Sim | Preço praticado |
| `fonteRegistro` | string | Sim | PedidoVenda, Faturamento, TabelaPreco, Manual |
| `fonteId` | Guid? | Cond | ID da entidade de origem (automática) |
| `dataRegistro` | DateTime | Auto | Data do registro |

---

## Regras

- Entidade **write-once**: sem edição, sem soft-delete
- Não herda de BaseAuditableEntity
- Registros automáticos são criados pelo sistema ao faturar ou atualizar tabela de preço
- Registros manuais são criados via POST com `fonteRegistro = "Manual"`
- `ClienteId` nulo indica preço geral; preenchido indica preço negociado para aquele cliente
- Usado pelo relatório "Variação de Preços" para análise de tendência
