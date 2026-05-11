# Relatório: Histórico de Compras

## Objetivo

Apresentar o histórico completo de ordens de compra em um período, com totalizadores de valor e desconto.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/historico-compras` | Histórico por período |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.OrdensCompra.View`

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
| `totalRegistros` | int | Quantidade de ordens no período |
| `valorTotal` | decimal | Valor total das compras |
| `descontoTotal` | decimal | Total de descontos aplicados |

### Itens

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID da ordem |
| `codigo` | int | Código da OC |
| `fornecedorNome` | string | Nome do fornecedor |
| `dataEmissao` | DateTime | Data de emissão |
| `status` | string | Status da OC |
| `valorTotal` | decimal | Valor total |
| `descontoTotal` | decimal | Desconto aplicado |

---

## Regras

- Filtra ordens pela `dataEmissao` dentro do período informado
- Inclui todos os status (inclusive canceladas, para histórico completo)
