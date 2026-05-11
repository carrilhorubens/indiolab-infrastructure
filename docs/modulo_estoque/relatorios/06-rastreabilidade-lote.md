# Relatório: Rastreabilidade por Lote

## Objetivo

Apresentar a **timeline completa de movimentações** de um lote específico, desde o recebimento até o consumo final, permitindo rastreabilidade total na cadeia logística.

---

## Endpoint

```
GET /api/relatorios/estoque/rastreabilidade-lote/{loteId}
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `loteId` | UUID (path) | Sim | Identificador do lote a rastrear |

---

## Campos Retornados

### Dados do Lote

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `loteId` | UUID | Identificador do lote |
| `loteCodigo` | int | Código numérico |
| `numeroLote` | string | Número de identificação (ex: LOT-20260001) |
| `produtoNome` | string? | Nome do produto |
| `produtoCodigo` | int? | Código do produto |
| `dataFabricacao` | DateTime? | Data de fabricação |
| `dataValidade` | DateTime? | Data de validade |
| `fornecedorNome` | string? | Nome do fornecedor de origem |
| `status` | string | Status atual (Ativo, Esgotado, Vencido, Quarentena) |

### Timeline de Movimentações

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador da movimentação |
| `numero` | int | Número sequencial da movimentação |
| `dataMovimentacao` | DateTime | Data/hora da movimentação |
| `tipoMovimentacao` | string? | Tipo (Entrada, Saída, Transferência, Ajuste) |
| `quantidade` | decimal | Quantidade movimentada |
| `unidadeMedidaNome` | string? | Unidade de medida |
| `custoTotal` | decimal | Custo total da movimentação |
| `depositoOrigemNome` | string? | Depósito de origem |
| `depositoDestinoNome` | string? | Depósito de destino |
| `subTipo` | string? | Subtipo (Compra, Venda, TransferênciaInterna, etc.) |
| `cfop` | string? | Código Fiscal de Operações e Prestações |
| `notaFiscalNumero` | string? | Número da nota fiscal |
| `status` | string | Status da movimentação |
| `createdAt` | DateTime | Data de registro no sistema |

---

## Regras de Negócio

1. **Busca:** Lote por ID com includes (Produto, Fornecedor)
2. **Timeline:** Todas as movimentações vinculadas ao `LoteId`, ordenadas por data decrescente
3. **Retorno 404:** Se o lote não existir
4. **Movimentações canceladas:** Incluídas na timeline (com status "Cancelada")

---

## Como Interpretar

- **Primeira movimentação (Entrada):** Recebimento do lote do fornecedor
- **Movimentações intermediárias:** Transferências entre depósitos, ajustes de inventário
- **Últimas movimentações (Saída):** Venda ao cliente final
- **CFOP e NF:** Permitem vincular ao documento fiscal
- **Rastreio reverso:** Em caso de recall, identificar todos os destinos do lote

---

## Exemplo de Uso

**Cenário:** Fornecedor notifica recall de um lote de lentes. A ótica precisa identificar para quais clientes vendeu produtos desse lote.

1. Acesse: **Estoque > Relatórios > Rastreabilidade por Lote**
2. Selecione o lote informado pelo fornecedor
3. Visualize todas as movimentações de saída (vendas)
4. Identifique os clientes através dos documentos fiscais (NF-e)
5. Inicie o processo de recall

---

## Fonte de Dados

- `Lote` — dados do lote (fabricação, validade, fornecedor)
- `MovimentacaoEstoque` — movimentações filtradas por `LoteId`
- `Fornecedor` → `Pessoa` — nome do fornecedor
