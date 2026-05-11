# Relatório: Bloco H (SPED Fiscal)

## Objetivo

Gerar os dados do **Bloco H do SPED Fiscal (EFD-ICMS/IPI)**, que corresponde ao inventário físico de mercadorias. É uma **obrigação acessória** exigida pela Receita Federal para empresas que apuram ICMS e IPI.

---

## Endpoint

```
GET /api/relatorios/estoque/bloco-h?dataInventario=2025-12-31
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `dataInventario` | DateTime | Sim | Data de referência do inventário (normalmente 31/12) |

---

## Campos Retornados

### Resultado Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `dataInventario` | DateTime | Data de referência informada |
| `items` | array | Lista de produtos com saldo na data |
| `totalItens` | int | Total de produtos no inventário |
| `valorTotal` | decimal | Valor total do estoque |
| `usouSnapshotHistorico` | bool | Se usou dados históricos ou saldo atual (fallback) |

### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `ncm` | string? | Código NCM (Nomenclatura Comum do Mercosul) |
| `unidadeMedidaSigla` | string? | Sigla da unidade de medida (UN, PAR, CX) |
| `quantidade` | decimal | Quantidade em estoque na data |
| `custoUnitario` | decimal | Custo unitário na data |
| `valorTotal` | decimal | Valor total (quantidade × custo unitário) |
| `origemFiscal` | string? | Origem da mercadoria (Nacional, Importada, etc.) |
| `propriedade` | string | Indicador de propriedade: "0" = próprio |

---

## Regras de Negócio

1. **Prioridade de dados:**
   - **Primeiro:** Busca snapshot do `EstoqueSaldoHistorico` na data informada
   - **Fallback:** Se não existir snapshot, usa os saldos atuais (`EstoqueSaldo`)
2. **Flag `usouSnapshotHistorico`:** Indica ao usuário se os dados são historicamente precisos
3. **Agrupamento:** Por `ProdutoId` — soma quantidades de todos os depósitos
4. **Custo unitário:** Calculado como valor total / quantidade (média ponderada)
5. **Propriedade:** Sempre "0" (mercadoria própria) — consignação de terceiros deve ser tratada separadamente
6. **Filtro:** Somente produtos com quantidade > 0
7. **Ordenação:** Por código do produto

---

## Registro H (SPED)

O Bloco H é composto por:

| Registro | Descrição |
|----------|-----------|
| **H001** | Abertura do Bloco H |
| **H005** | Totais do inventário |
| **H010** | Inventário — um registro por produto |
| **H990** | Encerramento do Bloco H |

O campo `propriedade` corresponde ao campo `MOT_INV` (motivo do inventário):
- `0` = Final do período
- `1` = Mudança de forma de tributação
- `2` = Baixa cadastral
- `3` = Regime de estimativa
- `4` = Alteração de regime de pagamento
- `5` = Determinação dos fiscos

---

## Como Interpretar

- **`usouSnapshotHistorico = true`:** Dados precisos da data informada
- **`usouSnapshotHistorico = false`:** Usando saldo atual como aproximação — gere o snapshot histórico antes de enviar ao SPED
- **NCM obrigatório:** Verifique se todos os produtos têm NCM preenchido
- **Unidade de medida:** Deve corresponder à tabela de unidades do SPED

---

## Exemplo de Uso

**Cenário:** Contador precisa gerar o Bloco H para a EFD-ICMS/IPI do exercício de 2025.

1. Acesse: **Estoque > Relatórios > Bloco H (SPED Fiscal)**
2. Informe a data `31/12/2025`
3. Verifique se o flag indica uso de snapshot histórico
4. Confira se todos os produtos possuem NCM e unidade de medida
5. Exporte os dados no formato TXT para importação no validador do SPED

---

## Fonte de Dados

- `EstoqueSaldoHistorico` — snapshots por data (prioridade)
- `EstoqueSaldo` — saldo atual (fallback)
- `Produto` — código, nome, NCM, origem fiscal, unidade de medida
