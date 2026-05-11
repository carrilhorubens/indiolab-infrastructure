# Relatório: Divergências de Inventário

## Objetivo

Analisar as **diferenças entre a contagem física e o saldo do sistema** em inventários já realizados, permitindo identificar perdas, sobras e problemas de acuracidade.

---

## Endpoint

```
GET /api/relatorios/estoque/divergencias-inventario
GET /api/relatorios/estoque/divergencias-inventario?inventarioId={guid}
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `inventarioId` | UUID (query) | Não | ID do inventário para análise |

**Comportamento:**
- **Sem `inventarioId`:** Retorna a lista de inventários fechados/pendentes de aprovação para seleção
- **Com `inventarioId`:** Retorna os itens com divergência do inventário selecionado

---

## Campos Retornados

### Lista de Inventários (quando `inventarioId` não informado)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador do inventário |
| `numero` | int | Número sequencial |
| `dataAbertura` | DateTime | Data de abertura do inventário |
| `dataFechamento` | DateTime? | Data de fechamento |
| `depositoNome` | string? | Depósito inventariado |
| `status` | string | Status (Fechado, PendenteAprovacao) |

### Resultado de Divergências (quando `inventarioId` informado)

#### Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `inventarioId` | UUID | ID do inventário |
| `inventarioCodigo` | int | Número do inventário |
| `dataInventario` | DateTime | Data de abertura |
| `status` | string | Status do inventário |
| `items` | array | Itens com divergência |
| `totalItens` | int | Total de itens contados |
| `totalDivergencias` | int | Itens com diferença ≠ 0 |
| `valorTotalDivergencia` | decimal | Soma dos valores de divergência |

#### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `localizacaoNome` | string? | Localização física contada |
| `loteNumero` | string? | Número do lote (se aplicável) |
| `quantidadeSistema` | decimal | Quantidade registrada no sistema |
| `quantidadeContada` | decimal | Quantidade encontrada na contagem |
| `divergencia` | decimal | Diferença (contada - sistema) |
| `custoUnitario` | decimal | Custo unitário do produto |
| `valorDivergencia` | decimal | Valor financeiro da divergência |
| `justificativa` | string? | Justificativa informada pelo operador |

---

## Regras de Negócio

1. **Inventários elegíveis:** Somente com status "Fechado" ou "PendenteAprovacao"
2. **Filtro de itens:** Somente itens com `Divergencia ≠ 0`
3. **Cálculo:** `Divergencia = QuantidadeContada - QuantidadeSistema`
4. **Valor:** `ValorDivergencia = Divergencia × CustoUnitario`
5. **Ordenação:** Por valor absoluto da divergência decrescente (maior impacto financeiro primeiro)
6. **Inventários em andamento:** Não aparecem na lista

---

## Como Interpretar

| Divergência | Cor no Frontend | Significado |
|-------------|-----------------|-------------|
| Negativa (vermelho) | Vermelho | Falta — menos itens na contagem que no sistema (perda, furto, erro) |
| Positiva (verde) | Verde | Sobra — mais itens na contagem que no sistema (entrada não registrada, erro) |
| Zero | Não aparece | Contagem correta |

**KPIs de referência:**
- **Acuracidade:** `Itens corretos / Total de itens × 100` — meta > 95%
- **Quebra (Shrinkage):** `Divergência negativa total / Valor sistema × 100` — meta < 2%

---

## Exemplo de Uso

**Cenário:** Após inventário anual, o gestor precisa analisar as divergências e aprovar ajustes.

1. Acesse: **Estoque > Relatórios > Divergências de Inventário**
2. Selecione o inventário recém-fechado no dropdown
3. Clique em **Analisar**
4. Observe os KPIs: Total de Divergências e Valor Total
5. Itens com divergência negativa grande → investigar possível furto ou dano
6. Itens com divergência positiva → verificar se houve entrada não registrada
7. Leia as justificativas informadas pelos operadores durante a contagem
8. Após análise, aprove os ajustes no módulo de Inventários

---

## Fonte de Dados

- `InventarioFisico` — dados do inventário (status, depósito, datas)
- `InventarioFisicoItem` — itens contados com quantidades sistema vs contada
- `Produto` — nome e código
- `Localizacao` — endereço físico contado
- `Lote` — número do lote (quando aplicável)
