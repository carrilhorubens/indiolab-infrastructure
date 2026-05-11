# Entidade: Comissões de Venda

## Objetivo

Registrar, aprovar e pagar comissões de vendedores calculadas a partir das vendas realizadas, com suporte a parcelamento do pagamento.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/comissoes-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/comissoes-venda` | Lista paginada |
| `GET` | `/api/comissoes-venda/{id}` | Detalhes com parcelas |
| `POST` | `/api/comissoes-venda` | Cria comissão |
| `DELETE` | `/api/comissoes-venda/{id}` | Remove |
| `PATCH` | `/api/comissoes-venda/{id}/aprovar` | Calculada → Aprovada |
| `PATCH` | `/api/comissoes-venda/{id}/pagar` | Aprovada → Paga |
| `PATCH` | `/api/comissoes-venda/{id}/cancelar` | Cancela a comissão |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Comissoes.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `vendedorId` | Guid | Sim | FK para funcionário/vendedor |
| `pedidoVendaId` | Guid? | Cond | Pedido que gerou a comissão |
| `faturamentoVendaId` | Guid? | Cond | Faturamento que gerou a comissão |
| `periodoReferencia` | string | Sim | Formato YYYY-MM |
| `baseCalculo` | decimal | Sim | Valor base para cálculo |
| `percentualComissao` | decimal | Sim | Percentual aplicado |
| `valorComissao` | decimal | Calc | BaseCalculo × PercentualComissao / 100 |
| `comissaoRegraId` | Guid | Sim | FK para regra aplicada |
| `status` | string | Auto | Calculada, Aprovada, Paga, Cancelada |
| `dataCalculo` | DateTime | Auto | Data do cálculo |
| `dataPagamento` | DateTime? | Auto | Preenchida ao pagar |
| `observacoes` | string? | Não | Observações |

### Parcelas (ComissaoVendaParcela)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `numeroParcela` | int | Número da parcela (1, 2, 3...) |
| `dataVencimento` | DateTime | Data de vencimento da parcela |
| `valorParcela` | decimal | Valor da parcela |
| `status` | string | Pendente, Paga, Cancelada |
| `dataPagamento` | DateTime? | Data efetiva do pagamento |

---

## Workflow

```
Calculada → Aprovada → Paga
         ↘ Cancelada (qualquer exceto Paga)
```

---

## Regras

- `ValorComissao = BaseCalculo × PercentualComissao / 100`
- A comissão pode ser gerada a partir de um pedido ou de um faturamento
- `PeriodoReferencia` agrupa comissões por mês (YYYY-MM)
- `ComissaoRegraId` indica qual regra foi usada para o cálculo
- Cancelamento é possível em qualquer estado exceto `Paga`
- Parcelas permitem pagamento fracionado da comissão
