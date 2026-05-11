# Relatório: Entregas Pendentes

## Objetivo

Listar todos os itens de ordens de compra com quantidade pendente de entrega, calculando dias de atraso em relação à previsão.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/entregas-pendentes` | Itens pendentes de entrega |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.OrdensCompra.View`

---

## Parâmetros

Nenhum parâmetro obrigatório.

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `ordemCompraId` | Guid | ID da ordem de compra |
| `ordemCompraCodigo` | int | Código da OC |
| `fornecedorNome` | string | Nome do fornecedor |
| `produtoId` | Guid | ID do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `quantidadePedida` | decimal | Quantidade total pedida |
| `quantidadeRecebida` | decimal | Quantidade já recebida |
| `quantidadePendente` | decimal | Quantidade ainda pendente |
| `precoUnitario` | decimal | Preço unitário |
| `valorPendente` | decimal | Valor pendente: `quantidadePendente × precoUnitario` |
| `dataPrevisaoEntrega` | DateTime? | Data prevista de entrega |
| `diasAtraso` | int | Dias de atraso (0 se dentro do prazo) |

---

## Regras

- Inclui apenas itens com `quantidadePendente > 0` (pedida - recebida)
- Dias de atraso calculado: `max(0, hoje - dataPrevisaoEntrega)`
- Ordenado por dias de atraso (maior primeiro)
