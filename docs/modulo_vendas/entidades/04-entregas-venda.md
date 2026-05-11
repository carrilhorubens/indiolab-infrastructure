# Entidade: Entregas de Venda

## Objetivo

Gerenciar o processo logístico de entrega dos pedidos de venda, desde a separação no depósito até a confirmação de recebimento pelo cliente, com rastreabilidade de lote e número de série.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/entregas-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/entregas-venda` | Lista paginada |
| `GET` | `/api/entregas-venda/{id}` | Detalhes com itens |
| `POST` | `/api/entregas-venda` | Cria entrega |
| `DELETE` | `/api/entregas-venda/{id}` | Soft-delete |
| `PATCH` | `/api/entregas-venda/{id}/iniciar-separacao` | Rascunho → EmSeparacao |
| `PATCH` | `/api/entregas-venda/{id}/concluir-separacao` | EmSeparacao → Separado |
| `PATCH` | `/api/entregas-venda/{id}/despachar` | Separado → EmTransito |
| `PATCH` | `/api/entregas-venda/{id}/confirmar-entrega` | EmTransito → Entregue |
| `PATCH` | `/api/entregas-venda/{id}/cancelar` | Cancela a entrega |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Entregas.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental (8 dígitos) |
| `pedidoVendaId` | Guid | Sim | FK para pedido de venda |
| `clienteId` | Guid | Sim | FK para cliente |
| `dataExpedicao` | DateTime? | Auto | Preenchida ao despachar |
| `dataEntregaPrevista` | DateTime? | Não | Previsão de entrega |
| `dataEntregaRealizada` | DateTime? | Auto | Preenchida ao confirmar entrega |
| `depositoOrigemId` | Guid? | Não | Depósito de saída |
| `modalidadeFreteId` | Guid? | Não | FK domínio (reutiliza de Compras) |
| `pesoTotal` | decimal | Não | Peso total da carga |
| `volumesTotal` | int | Não | Número de volumes |
| `status` | string | Auto | Status do workflow |
| `codigoRastreio` | string? | Não | Código de rastreamento da transportadora |
| `observacoes` | string? | Não | Observações |

### Campos do Item (EntregaVendaItem)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `pedidoVendaItemId` | Guid | Sim | FK para item do pedido |
| `produtoId` | Guid | Sim | FK para produto |
| `quantidadeExpedida` | decimal | Sim | Quantidade expedida |
| `depositoId` | Guid | Sim | Depósito de saída (obrigatório por item) |
| `loteId` | Guid? | Não | Rastreabilidade de lote |
| `numeroSerieId` | Guid? | Não | Rastreabilidade de série |
| `localizacaoId` | Guid? | Não | Localização física no depósito |

---

## Workflow

```
Rascunho → EmSeparacao → Separado → EmTransito → Entregue
                                               ↘ ParcialmenteEntregue
                      ↘ Cancelado (qualquer exceto Entregue/Cancelado)
```

---

## Regras

- Somente entregas em `Rascunho` podem ser editadas
- `DataExpedicao` é preenchida automaticamente ao despachar (se ainda nula)
- `DataEntregaRealizada` é preenchida ao confirmar entrega
- Cada item obrigatoriamente indica o depósito de saída
- Opcionalmente rastreia lote e número de série por item
- Integração com Estoque: ao confirmar entrega, gera movimentações de saída
