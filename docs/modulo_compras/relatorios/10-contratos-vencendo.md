# Relatório: Contratos Vencendo

## Objetivo

Listar contratos de compra ativos que estão próximos da data de vencimento, permitindo ações preventivas de renovação ou renegociação.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/contratos-vencendo` | Contratos próximos do vencimento |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Contratos.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dias` | int | Não | Dias de antecedência (padrão: 30) |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID do contrato |
| `codigo` | int | Código do contrato |
| `fornecedorNome` | string | Nome do fornecedor |
| `tipo` | string | Tipo do contrato |
| `dataInicio` | DateTime | Data de início |
| `dataFim` | DateTime | Data de vencimento |
| `diasParaVencimento` | int | Dias restantes até o vencimento |
| `valorTotalPrevisto` | decimal | Valor previsto |
| `valorTotalConsumido` | decimal | Valor já consumido |
| `renovacaoAutomatica` | bool | Se tem renovação automática |

---

## Regras

- Inclui apenas contratos com status "Ativo"
- Filtra contratos com `dataFim` entre hoje e `hoje + dias`
- Ordenado por dias para vencimento (mais urgente primeiro)
