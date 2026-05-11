# Entidade: Pedidos de Venda

## Objetivo

Gerenciar o ciclo completo de pedidos de venda, desde a criação até a entrega, passando por aprovação, faturamento e expedição.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/pedidos-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/pedidos-venda` | Lista paginada |
| `GET` | `/api/pedidos-venda/{id}` | Detalhes com itens |
| `POST` | `/api/pedidos-venda` | Cria pedido (status: Pedido) |
| `PUT` | `/api/pedidos-venda/{id}` | Atualiza (somente status Pedido) |
| `DELETE` | `/api/pedidos-venda/{id}` | Soft-delete (somente status Pedido) |
| `PATCH` | `/api/pedidos-venda/{id}/aprovar` | Pedido → Aprovado |
| `PATCH` | `/api/pedidos-venda/{id}/faturar` | Aprovado → Faturado |
| `PATCH` | `/api/pedidos-venda/{id}/expedir` | Faturado → Expedido |
| `PATCH` | `/api/pedidos-venda/{id}/entregar` | Expedido → Entregue |
| `PATCH` | `/api/pedidos-venda/{id}/cancelar` | Cancela (somente Pedido ou Aprovado) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental (8 dígitos) |
| `clienteId` | Guid | Sim | FK para cliente |
| `vendedorId` | Guid? | Não | FK para funcionário/vendedor |
| `dataEmissao` | DateTime | Sim | Data de emissão |
| `dataEntregaPrevista` | DateTime? | Não | Previsão de entrega |
| `dataEntregaRealizada` | DateTime? | Auto | Preenchida ao confirmar entrega |
| `condicaoPagamentoId` | Guid? | Não | FK condição de pagamento |
| `formaPagamentoId` | Guid? | Não | FK forma de pagamento |
| `canalVendaId` | Guid? | Não | FK canal de venda |
| `subTotal` | decimal | Calc | Soma dos itens |
| `descontoPercentual` | decimal | Não | Desconto geral (%) |
| `descontoValor` | decimal | Não | Desconto geral (R$) |
| `valorFrete` | decimal | Não | Valor do frete |
| `valorTotal` | decimal | Calc | SubTotal - DescontoValor + ValorFrete |
| `prioridade` | string | Sim | Normal, Alta, Urgente |
| `status` | string | Auto | Status do workflow |
| `motivoCancelamentoId` | Guid? | Cond | Preenchido ao cancelar (opcional) |
| `observacoes` | string? | Não | Observações gerais |
| `observacoesInternas` | string? | Não | Uso interno |

### Campos do Item (PedidoVendaItem)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `sequencia` | int | Auto | Ordem do item |
| `produtoId` | Guid | Sim | FK para produto |
| `descricao` | string? | Não | Descrição livre |
| `quantidade` | decimal | Sim | Quantidade pedida |
| `quantidadeEntregue` | decimal | Auto | Acumulado de entregas |
| `quantidadeFaturada` | decimal | Auto | Acumulado de faturamentos |
| `quantidadeCancelada` | decimal | Auto | Quantidade cancelada |
| `unidadeMedidaId` | Guid | Sim | FK unidade de medida |
| `precoUnitario` | decimal | Sim | Preço por unidade |
| `descontoPct` | decimal | Não | Desconto do item (%) |
| `descontoValor` | decimal | Calc | Calculado |
| `valorTotal` | decimal | Calc | Calculado |
| `dataEntregaPrevista` | DateTime? | Não | Previsão por item |
| `depositoId` | Guid? | Não | Depósito preferencial |
| `situacaoItem` | string | Auto | Pendente, ParcialmenteEntregue, Entregue, Cancelado |

---

## Workflow

```
Pedido → Aprovado → Faturado → Expedido → Entregue
  ↘ Cancelado    ↘ Cancelado
```

### Fluxo de Transições Cross-Module

| Etapa | Módulo/Página | Transição | Método |
|-------|--------------|-----------|--------|
| 1. Criação | vendas/pedidos-venda | → Pedido | `PedidoVenda.Create()` |
| 2. Aprovação | vendas/pedido-aprovacoes | Pedido → Aprovado | `pedido.Aprovar()` |
| 3. Faturamento | vendas/faturamentos-venda | Aprovado → Faturado | `FaturamentoVendaService.AutorizarAsync()` |
| 4. Nota Fiscal | fiscal/notas-fiscais | Faturado → Expedido | `NotaFiscalService.GerarNfeDeVendaAsync()` |
| 5. Entrega | vendas/entregas-venda | Expedido → Entregue | `EntregaVendaService.ConfirmarEntregaAsync()` |

---

## Regras

- Somente pedidos com status `Pedido` podem ser editados (PUT) ou excluídos (DELETE)
- Cancelamento só é permitido para status `Pedido` ou `Aprovado`
- Cancelamento não exige motivo obrigatório (`motivoCancelamentoId` é opcional)
- `DataEntregaRealizada` é preenchida automaticamente ao chamar `Entregar()`
- Fórmula: `ValorTotal = SubTotal - DescontoValor + ValorFrete`
