# Relatório: Pedidos Abertos

## Objetivo

Listar todas as ordens de compra pendentes de recebimento, permitindo filtrar por fornecedor para acompanhamento de entregas.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/pedidos-abertos` | OCs pendentes de recebimento |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.OrdensCompra.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `fornecedorId` | Guid? | Não | Filtro por fornecedor específico |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID da ordem de compra |
| `codigo` | int | Código da OC |
| `fornecedorNome` | string | Nome do fornecedor |
| `status` | string | Status atual da OC |
| `dataEmissao` | DateTime | Data de emissão |
| `dataPrevisaoEntrega` | DateTime? | Data prevista de entrega |
| `valorTotal` | decimal | Valor total da OC |
| `totalItens` | int | Quantidade de itens |

---

## Regras

- Inclui ordens com status: Aprovada, Enviada e ParcialmenteRecebida
- Exclui: Rascunho, Recebida, Encerrada e Cancelada
