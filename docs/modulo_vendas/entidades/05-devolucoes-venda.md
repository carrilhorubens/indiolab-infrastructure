# Entidade: Devoluções de Venda

## Objetivo

Registrar e processar devoluções de mercadorias por clientes, com análise, recebimento e geração de crédito (reembolso, crédito em loja ou troca).

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/devolucoes-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/devolucoes-venda` | Lista paginada |
| `GET` | `/api/devolucoes-venda/{id}` | Detalhes com itens |
| `POST` | `/api/devolucoes-venda` | Cria devolução |
| `DELETE` | `/api/devolucoes-venda/{id}` | Soft-delete |
| `PATCH` | `/api/devolucoes-venda/{id}/enviar-analise` | Rascunho → PendenteAnalise |
| `PATCH` | `/api/devolucoes-venda/{id}/aprovar` | PendenteAnalise → Aprovada |
| `PATCH` | `/api/devolucoes-venda/{id}/registrar-recebimento` | Aprovada → Recebida |
| `PATCH` | `/api/devolucoes-venda/{id}/creditar` | Recebida → Creditada |
| `PATCH` | `/api/devolucoes-venda/{id}/cancelar` | Cancela |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Devolucoes.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental (8 dígitos) |
| `pedidoVendaId` | Guid | Sim | Pedido de venda de origem |
| `clienteId` | Guid | Sim | FK para cliente |
| `dataDevolucao` | DateTime | Sim | Data da devolução |
| `motivoDevolucaoVendaId` | Guid | Sim | FK domínio obrigatória |
| `valorTotal` | decimal | Calc | Soma dos itens |
| `tipoCredito` | string | Sim | Reembolso, CreditoLoja, Troca |
| `status` | string | Auto | Status do workflow |
| `observacoes` | string? | Não | Observações |

### Campos do Item (DevolucaoVendaItem)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `pedidoVendaItemId` | Guid | Sim | FK para item do pedido original |
| `produtoId` | Guid | Sim | FK para produto |
| `quantidadeDevolvida` | decimal | Sim | Quantidade devolvida |
| `estadoMercadoria` | string | Sim | Nova, Usada, Danificada, Defeituosa |
| `retornaEstoque` | bool | Sim | Se deve gerar movimentação de entrada |
| `depositoDestinoId` | Guid? | Cond | Obrigatório se retornaEstoque = true |
| `valorUnitario` | decimal | Sim | Valor unitário para crédito |
| `valorTotal` | decimal | Calc | QuantidadeDevolvida × ValorUnitario |
| `observacoes` | string? | Não | Observações do item |

---

## Workflow

```
Rascunho → PendenteAnalise → Aprovada → Recebida → Creditada
                            ↘ Cancelada (qualquer exceto Creditada/Cancelada)
```

---

## Regras

- Somente devoluções em `Rascunho` podem ser editadas
- `MotivoDevolucaoVendaId` é obrigatório (FK para domínio público)
- `TipoCredito` define como o cliente será ressarcido: Reembolso (dinheiro), CreditoLoja (crédito para compras futuras) ou Troca (troca por outro produto)
- Se `RetornaEstoque = true`, o `DepositoDestinoId` é obrigatório e gera movimentação de entrada no estoque ao receber
- O estado da mercadoria (`EstadoMercadoria`) determina se o item volta ao estoque como disponível ou como avariado
