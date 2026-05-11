# Operação: Ordens de Compra

## Objetivo

Gerenciar o ciclo completo de compras, desde a criação do pedido até o encerramento após recebimento. A ordem de compra é o documento central do módulo, vinculando fornecedor, produtos, condições comerciais e integrando com recebimentos, cotações, requisições e contratos.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/ordens-compra/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/ordens-compra` | Listar ordens (paginado) |
| `GET` | `/api/ordens-compra/{id}` | Detalhes de uma ordem |
| `POST` | `/api/ordens-compra` | Criar nova ordem (Rascunho) |
| `PUT` | `/api/ordens-compra/{id}` | Atualizar ordem |
| `DELETE` | `/api/ordens-compra/{id}` | Excluir ordem (soft delete) |
| `PATCH` | `/api/ordens-compra/{id}/aprovar` | Rascunho → Aprovada |
| `PATCH` | `/api/ordens-compra/{id}/enviar` | Aprovada → Enviada |
| `PATCH` | `/api/ordens-compra/{id}/cancelar` | Cancelar ordem |
| `PATCH` | `/api/ordens-compra/{id}/encerrar` | Encerrar ordem |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.OrdensCompra.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |

---

## Campos da Ordem de Compra

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `fornecedorId` | Guid | Sim | FK para o fornecedor |
| `tipo` | string | Sim | Tipo da ordem |
| `dataEmissao` | DateTime | Sim | Data de emissão |
| `dataPrevisaoEntrega` | DateTime? | Não | Data prevista de entrega |
| `condicaoPagamentoId` | Guid? | Não | FK para condição de pagamento |
| `modalidadeFreteId` | Guid? | Não | FK para modalidade de frete |
| `depositoId` | Guid? | Não | FK para depósito de destino |
| `compradorId` | Guid | Auto | ID do usuário que criou (JWT) |
| `status` | string | Auto | Status da ordem (padrão: "Rascunho") |
| `moeda` | string | Auto | Moeda (padrão: "BRL") |
| `taxaCambio` | decimal | Auto | Taxa de câmbio (padrão: 1) |
| `valorFrete` | decimal | Não | Valor do frete |
| `valorSeguro` | decimal | Não | Valor do seguro |
| `outrasDespesas` | decimal | Não | Outras despesas |
| `observacoes` | string? | Não | Observações externas |
| `observacoesInternas` | string? | Não | Observações internas |
| `categoriaCompraId` | Guid? | Não | FK para categoria de compra |

### Vínculos Opcionais

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `requisicaoCompraId` | Guid? | FK para requisição de origem |
| `cotacaoId` | Guid? | FK para cotação de origem |
| `contratoCompraId` | Guid? | FK para contrato vinculado |
| `enderecoEntregaId` | Guid? | FK para endereço de entrega |

### Valores Calculados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `subTotal` | decimal | Soma dos itens |
| `descontoTotal` | decimal | Total de descontos |
| `valorTotal` | decimal | SubTotal - Descontos + Frete + Despesas |

### Itens da Ordem

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `sequencia` | int | Auto | Sequência do item |
| `produtoId` | Guid | Sim | FK para o produto |
| `descricao` | string? | Não | Descrição complementar |
| `quantidade` | decimal | Sim | Quantidade solicitada |
| `quantidadeRecebida` | decimal | Auto | Quantidade já recebida |
| `unidadeMedidaId` | Guid | Sim | FK para unidade de medida |
| `precoUnitario` | decimal | Sim | Preço unitário |
| `descontoPct` | decimal | Não | Percentual de desconto |
| `descontoValor` | decimal | Auto | Valor do desconto calculado |
| `valorTotal` | decimal | Auto | Valor total do item |
| `status` | string | Auto | Status do item |
| `cfop` | string? | Não | Código fiscal da operação |
| `ncm` | string? | Não | NCM do produto |
| `depositoId` | Guid? | Não | Depósito específico do item |
| `localizacaoId` | Guid? | Não | Localização específica |
| `dataPrevisaoEntrega` | DateTime? | Não | Previsão de entrega do item |

---

## Workflow de Status

```
Rascunho → [aprovar] → Aprovada → [enviar] → Enviada
                                                 ↓
                                   ParcialmenteRecebida (automático via recebimento)
                                                 ↓
                                            Recebida (automático quando 100% recebido)
                                                 ↓
                                         [encerrar] → Encerrada

Qualquer status (exceto Encerrada) → [cancelar] → Cancelada
```

---

## Regras de Negócio

1. **Comprador automático** — Atribuído a partir do JWT na criação.

2. **Ao menos um item** — A ordem deve conter pelo menos um item.

3. **Valores calculados** — SubTotal, DescontoValor e ValorTotal são recalculados a cada operação.

4. **Status parcial/recebido** — Atualizados automaticamente pelo módulo de recebimentos ao confirmar entregas.

5. **Resolução de nomes** — Fornecedor, comprador, condição de pagamento e modalidade de frete são resolvidos via joins.

6. **Atualização faz replace dos itens** — O PUT remove todos os itens existentes e recria.

7. **Integração com recebimentos** — Cada recebimento referencia uma ordem de compra e atualiza as quantidades recebidas dos itens.

---

## Exemplos de Uso

### Criar ordem de compra

```json
POST /api/ordens-compra
{
  "fornecedorId": "...",
  "tipo": "Normal",
  "dataEmissao": "2026-03-01",
  "dataPrevisaoEntrega": "2026-03-15",
  "condicaoPagamentoId": "...",
  "modalidadeFreteId": "...",
  "depositoId": "...",
  "valorFrete": 150.00,
  "itens": [
    {
      "produtoId": "...",
      "quantidade": 100,
      "unidadeMedidaId": "...",
      "precoUnitario": 25.50,
      "descontoPct": 5
    }
  ]
}
```

### Aprovar ordem

```
PATCH /api/ordens-compra/{id}/aprovar
```
