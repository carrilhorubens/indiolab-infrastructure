# Entidade: Log de Descontos Especiais

## Objetivo

Registrar solicitações de desconto acima do limite permitido pela tabela de preço, com workflow de aprovação/rejeição por um autorizador.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/log-descontos-especiais` | Lista paginada |
| `POST` | `/api/log-descontos-especiais` | Solicita desconto especial |
| `PATCH` | `/api/log-descontos-especiais/{id}/aprovar` | Aprova desconto |
| `PATCH` | `/api/log-descontos-especiais/{id}/rejeitar` | Rejeita desconto |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.View` (GET) / `Permissions.Vendas.Create` (POST) / `Permissions.Vendas.Edit` (PATCH)

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `pedidoVendaId` | Guid? | Cond | Pedido de venda relacionado |
| `orcamentoId` | Guid? | Cond | Orçamento relacionado |
| `produtoId` | Guid | Sim | Produto que necessita desconto |
| `vendedorId` | Guid | Sim | Vendedor solicitante |
| `autorizadoPorId` | Guid? | Auto | Aprovador/Rejeitador (extraído do JWT) |
| `descontoSolicitado` | decimal | Sim | Percentual solicitado |
| `descontoMaximoPermitido` | decimal | Sim | Limite da tabela de preço |
| `descontoAprovado` | decimal | Cond | Valor final aprovado |
| `motivo` | string? | Não | Justificativa do vendedor |
| `status` | string | Auto | Pendente, Aprovado, Rejeitado |
| `dataSolicitacao` | DateTime | Auto | Data da solicitação |
| `dataAprovacao` | DateTime? | Auto | Data da aprovação/rejeição |

---

## Workflow

```
Pendente → Aprovado
        ↘ Rejeitado
```

---

## Regras

- Entidade de **audit trail**: sem delete, sem soft-delete
- Gerada automaticamente quando o vendedor tenta aplicar desconto acima do `descontoMaximoPercentual` da tabela de preço
- `DescontoSolicitado > DescontoMaximoPermitido` sempre é verdadeiro
- Ao aprovar, o autorizador define `descontoAprovado` (pode ser menor que o solicitado)
- `AutorizadoPorId` é extraído automaticamente do JWT (não enviado no request)
- Alimenta o relatório "Análise de Descontos"
