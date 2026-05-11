# Relatório: Cotações em Andamento

## Objetivo

Listar cotações que ainda não foram finalizadas ou canceladas, permitindo acompanhamento do processo de cotação.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/cotacoes-andamento` | Cotações não finalizadas |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Cotacoes.View`

---

## Parâmetros

Nenhum parâmetro obrigatório.

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID da cotação |
| `codigo` | int | Código da cotação |
| `dataEmissao` | DateTime | Data de emissão |
| `dataLimiteResposta` | DateTime? | Data limite para respostas |
| `status` | string | Status atual |
| `totalFornecedores` | int | Quantidade de fornecedores participantes |
| `fornecedoresComResposta` | int | Fornecedores que já responderam |
| `responsavelNome` | string | Nome do responsável |

---

## Regras

- Inclui cotações com status: Rascunho, Enviada e EmAnalise
- Exclui: Finalizada e Cancelada
- Ordenado por data limite de resposta (mais urgente primeiro)
