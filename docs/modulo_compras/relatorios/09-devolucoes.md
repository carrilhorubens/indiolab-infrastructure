# Relatório: Devoluções

## Objetivo

Apresentar o histórico de devoluções de compra por período, com totalizadores por status e valor total devolvido.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/devolucoes` | Devoluções por período |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Devolucoes.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Início do período |
| `dataFim` | DateTime | Sim | Fim do período |

---

## Campos Retornados

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalRegistros` | int | Quantidade de devoluções |
| `valorTotal` | decimal | Valor total das devoluções |
| `totaisPorStatus` | Dictionary | Contagem por status (ex: {"Concluida": 5, "EmTransito": 2}) |

### Itens

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID da devolução |
| `codigo` | int | Código da devolução |
| `fornecedorNome` | string | Nome do fornecedor |
| `dataDevolucao` | DateTime | Data da devolução |
| `status` | string | Status atual |
| `valorTotal` | decimal | Valor total da devolução |
| `motivoNome` | string? | Motivo da devolução |

---

## Regras

- Filtra pela `dataDevolucao` dentro do período
- Inclui todos os status para histórico completo
- Totais por status permitem análise de gargalos no processo
