# Relatório: Divergências de Recebimento

## Objetivo

Identificar divergências entre as quantidades esperadas e recebidas nos recebimentos de mercadoria, permitindo análise de conformidade dos fornecedores.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/divergencias-recebimento` | Divergências por período |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Recebimentos.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Início do período |
| `dataFim` | DateTime | Sim | Fim do período |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `recebimentoId` | Guid | ID do recebimento |
| `recebimentoCodigo` | int | Código do recebimento |
| `fornecedorNome` | string | Nome do fornecedor |
| `dataRecebimento` | DateTime | Data do recebimento |
| `produtoNome` | string | Nome do produto |
| `quantidadeEsperada` | decimal | Quantidade esperada (da OC) |
| `quantidadeRecebida` | decimal | Quantidade efetivamente recebida |
| `divergencia` | decimal | Diferença: `recebida - esperada` |
| `percentualDivergencia` | decimal | Percentual de divergência |

---

## Regras

- Inclui apenas itens com divergência (`quantidadeRecebida != quantidadeEsperada`)
- Divergência negativa indica falta, positiva indica excesso
- Filtra pela data do recebimento dentro do período
