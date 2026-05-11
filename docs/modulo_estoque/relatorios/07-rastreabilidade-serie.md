# Relatório: Rastreabilidade por Número de Série

## Objetivo

Apresentar o **histórico completo** de um número de série específico, desde a entrada no estoque até a venda ou saída, incluindo localização atual e todas as movimentações.

---

## Endpoint

```
GET /api/relatorios/estoque/rastreabilidade-serie/{serieId}
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `serieId` | UUID (path) | Sim | Identificador do número de série |

---

## Campos Retornados

### Dados do Número de Série

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `numeroSerieId` | UUID | Identificador do registro |
| `serie` | string | Número de série (ex: SN-ARM-202600001) |
| `produtoNome` | string? | Nome do produto |
| `produtoCodigo` | int? | Código do produto |
| `status` | string | Status atual (Disponível, Vendido, Em Garantia, Defeituoso) |
| `depositoNome` | string? | Depósito onde se encontra atualmente |
| `localizacaoNome` | string? | Localização (prateleira) atual |
| `dataEntrada` | DateTime | Data de entrada no estoque |
| `dataSaida` | DateTime? | Data de saída (se vendido) |

### Timeline de Movimentações

Mesma estrutura do relatório de Rastreabilidade por Lote (veja campos em [06-rastreabilidade-lote.md](06-rastreabilidade-lote.md)).

---

## Regras de Negócio

1. **Busca:** Número de série por ID com includes (Produto, Depósito, Localização)
2. **Timeline:** Movimentações vinculadas ao `NumeroSerieId`, ordenadas por data decrescente
3. **Retorno 404:** Se o número de série não existir
4. **Unicidade:** Cada número de série é único no sistema — rastreia uma unidade individual

---

## Como Interpretar

- **Status "Disponível":** Produto em estoque, localização indicada
- **Status "Vendido":** Produto vendido, `dataSaida` preenchida
- **Status "Em Garantia":** Produto retornou para assistência
- **Status "Defeituoso":** Produto com defeito identificado

A timeline permite reconstruir todo o caminho do item individual, desde o recebimento do fornecedor até a entrega ao cliente.

---

## Exemplo de Uso

**Cenário:** Cliente traz uma armação Ray-Ban para garantia. A ótica precisa verificar a procedência e data de compra.

1. Acesse: **Estoque > Relatórios > Rastreabilidade por Série**
2. Pesquise pelo número de série da armação
3. Verifique a data de entrada (recebimento do fornecedor)
4. Verifique a data de saída (venda ao cliente)
5. Confirme se está no período de garantia
6. Se procedente, inicie o processo de garantia com o fornecedor

---

## Fonte de Dados

- `NumeroSerie` — dados do item (série, status, localização, datas)
- `MovimentacaoEstoque` — movimentações filtradas por `NumeroSerieId`
- `Deposito` — depósito atual
- `Localizacao` — localização física atual
