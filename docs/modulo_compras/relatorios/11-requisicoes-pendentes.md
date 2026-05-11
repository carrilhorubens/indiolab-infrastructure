# Relatório: Requisições Pendentes

## Objetivo

Listar requisições de compra que estão pendentes de aprovação ou ainda não foram convertidas em ordens de compra, priorizadas por urgência.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/requisicoes-pendentes` | Requisições pendentes priorizadas |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Requisicoes.View`

---

## Parâmetros

Nenhum parâmetro obrigatório.

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID da requisição |
| `codigo` | int | Código da requisição |
| `solicitanteNome` | string | Nome do solicitante |
| `departamentoNome` | string? | Departamento solicitante |
| `prioridade` | string | Prioridade (Normal, Urgente, Crítica) |
| `status` | string | Status atual |
| `dataRequisicao` | DateTime | Data da requisição |
| `dataNecessidade` | DateTime? | Data em que o material é necessário |
| `valorEstimadoTotal` | decimal | Valor estimado total |
| `totalItens` | int | Quantidade de itens |

---

## Regras

- Inclui requisições com status: PendenteAprovacao e Aprovada (não convertidas)
- Ordenado por prioridade (Crítica > Urgente > Normal), depois por data de necessidade
