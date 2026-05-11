# Entidade: Faturamentos de Venda

## Objetivo

Registrar o faturamento (emissão de nota fiscal) dos pedidos de venda, com dados fiscais completos por item incluindo ICMS, IPI, PIS e COFINS.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/faturamentos-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/faturamentos-venda` | Lista paginada |
| `GET` | `/api/faturamentos-venda/{id}` | Detalhes com itens fiscais |
| `POST` | `/api/faturamentos-venda` | Cria faturamento |
| `DELETE` | `/api/faturamentos-venda/{id}` | Remove |
| `PATCH` | `/api/faturamentos-venda/{id}/autorizar` | Rascunho → Autorizada |
| `PATCH` | `/api/faturamentos-venda/{id}/cancelar` | Autorizada/Rascunho → Cancelada |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Faturamentos.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `pedidoVendaId` | Guid | Sim | FK para pedido de venda |
| `entregaVendaId` | Guid? | Não | FK para entrega relacionada |
| `clienteId` | Guid | Sim | FK para cliente |
| `dataFaturamento` | DateTime | Sim | Data do faturamento |
| `dataVencimento` | DateTime | Sim | Data de vencimento |
| `numeroNF` | string? | Não | Número da nota fiscal |
| `serieNF` | string? | Não | Série da NF |
| `chaveAcessoNF` | string? | Não | Chave de acesso eletrônica (44 dígitos) |
| `naturezaOperacao` | string? | Não | Natureza da operação |
| `cfop` | string? | Não | CFOP da operação |
| `subTotal` | decimal | Calc | Soma dos itens |
| `descontos` | decimal | Não | Valor dos descontos |
| `frete` | decimal | Não | Valor do frete |
| `seguro` | decimal | Não | Valor do seguro |
| `valorICMS` | decimal | Calc | Total de ICMS |
| `valorIPI` | decimal | Calc | Total de IPI |
| `valorPIS` | decimal | Calc | Total de PIS |
| `valorCOFINS` | decimal | Calc | Total de COFINS |
| `valorTotal` | decimal | Calc | SubTotal - Descontos + Frete + Seguro + IPI |
| `status` | string | Auto | Rascunho, Autorizada, Cancelada, Inutilizada, Denegada |
| `condicaoPagamentoId` | Guid? | Não | FK condição de pagamento |
| `formaPagamentoId` | Guid? | Não | FK forma de pagamento |
| `observacoes` | string? | Não | Observações |

### Campos do Item (FaturamentoVendaItem)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | FK para produto |
| `unidadeMedidaId` | Guid? | FK unidade de medida |
| `quantidade` | decimal | Quantidade faturada |
| `precoUnitario` | decimal | Preço unitário |
| `descontoPercentual` | decimal | Desconto (%) |
| `cfop` | string? | CFOP do item |
| `ncm` | string? | NCM do produto |
| `cstIcms` | string? | CST ICMS |
| `cstIpi` | string? | CST IPI |
| `cstPis` | string? | CST PIS |
| `cstCofins` | string? | CST COFINS |
| `aliquotaIcms` | decimal | Alíquota ICMS (%) |
| `aliquotaIpi` | decimal | Alíquota IPI (%) |
| `aliquotaPis` | decimal | Alíquota PIS (%) |
| `aliquotaCofins` | decimal | Alíquota COFINS (%) |
| `valorIcms` | decimal | Valor ICMS do item |
| `valorIpi` | decimal | Valor IPI do item |
| `valorPis` | decimal | Valor PIS do item |
| `valorCofins` | decimal | Valor COFINS do item |
| `origemMercadoria` | string? | Origem fiscal (0-8) |

---

## Workflow

```
Rascunho → Autorizada → Cancelada
        ↘ Inutilizada
        ↘ Denegada
```

---

## Regras

- Faturamento está vinculado obrigatoriamente a um pedido de venda
- Ao autorizar, o pedido de venda atualiza as quantidades faturadas dos itens
- Fórmula: `ValorTotal = SubTotal - Descontos + Frete + Seguro + ValorIPI`
- Cada item contém todos os dados fiscais necessários para emissão de NF-e
