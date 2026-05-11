# Operação: Movimentações de Estoque

## Objetivo

Registrar todas as entradas, saídas, transferências e ajustes de estoque. Cada movimentação atualiza automaticamente os saldos de estoque de forma atômica. As movimentações são **imutáveis** (append-only) — uma vez criadas, não podem ser editadas, apenas canceladas.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/movimentacoes-estoque` | Listar movimentações (paginado) |
| `GET` | `/api/movimentacoes-estoque/{id}` | Detalhes de uma movimentação |
| `POST` | `/api/movimentacoes-estoque` | Criar nova movimentação |
| `PATCH` | `/api/movimentacoes-estoque/{id}/cancelar` | Cancelar movimentação |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Movimentacoes.View / .Create / .Edit`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Produto, Documento Origem, Número |
| `produtoId` | Guid? | Filtro por produto |
| `depositoId` | Guid? | Filtro por depósito |
| `dataInicio` | DateTime? | Filtro por data inicial |
| `dataFim` | DateTime? | Filtro por data final |

---

## Campos da Movimentação

### Dados Principais

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `numero` | int | Auto | Número sequencial da movimentação |
| `dataMovimentacao` | DateTime | Sim | Data/hora da movimentação |
| `tipoMovimentacaoEstoqueId` | Guid | Sim | FK para tipo (Entrada/Saída/Transferência/Ajuste) |
| `produtoId` | Guid | Sim | FK para produto |
| `quantidade` | decimal | Sim | Quantidade movimentada (> 0) |
| `unidadeMedidaId` | Guid | Sim | FK para unidade de medida |
| `custoUnitario` | decimal | Sim | Custo unitário |
| `custoTotal` | decimal | Auto | Calculado: `quantidade × custoUnitario` |
| `status` | string | Auto | "Confirmada" (padrão) ou "Cancelada" |

### Depósitos e Localizações

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `depositoOrigemId` | Guid? | Depósito de origem (saída/transferência) |
| `depositoDestinoId` | Guid? | Depósito de destino (entrada/transferência) |
| `localizacaoOrigemId` | Guid? | Localização de origem |
| `localizacaoDestinoId` | Guid? | Localização de destino |

### Rastreabilidade

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `motivoAjusteId` | Guid? | FK para motivo de ajuste (quando tipo = Ajuste) |
| `documentoOrigem` | string? | Referência ao documento de origem |
| `observacao` | string? | Observações gerais |
| `loteId` | Guid? | FK para lote (rastreabilidade por lote) |
| `numeroSerieId` | Guid? | FK para número de série |

### Dados Fiscais

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `subTipo` | string? | Subtipo fiscal |
| `cfop` | string? | Código Fiscal de Operação |
| `documentoOrigemTipo` | string? | Tipo do documento fiscal (NF, Recibo, etc.) |
| `documentoOrigemId` | Guid? | ID do documento fiscal de origem |
| `notaFiscalNumero` | string? | Número da nota fiscal |

---

## Tipos de Movimentação e Impacto no Saldo

| Tipo | Depósitos Usados | Impacto no Saldo |
|------|-----------------|------------------|
| **Entrada** | Destino | +Quantidade no destino. Recalcula custo médio ponderado |
| **Saída** | Origem | -Quantidade na origem. Valida saldo suficiente |
| **Transferência** | Origem + Destino | -Origem, +Destino. Valida saldo na origem |
| **Ajuste** | Origem ou Destino | Positivo: +Destino. Negativo: -Origem |

---

## Regras de Negócio

1. **Imutabilidade** — Movimentações são append-only. Uma vez criadas, não podem ser editadas. Para corrigir, crie uma movimentação de ajuste reverso.

2. **Cancelamento** — O cancelamento marca a movimentação como "Cancelada", mas **não reverte o saldo automaticamente**. Uma movimentação reversa deve ser criada manualmente se necessário.

3. **Validação de saldo** — Para Saída e Transferência, o sistema valida se há saldo suficiente (`QuantidadeDisponivel >= Quantidade`). Se insuficiente, a operação falha.

4. **Custo médio ponderado** — Em Entradas, o custo médio é recalculado: `(qtd_existente × custo_existente + qtd_nova × custo_novo) / qtd_total`.

5. **Transação atômica** — A criação da movimentação e a atualização do saldo ocorrem na mesma transação. Se qualquer parte falhar, tudo é revertido.

6. **Criação automática de saldo** — Se não existir registro de saldo para o produto/depósito, ele é criado automaticamente com quantidade zero antes da aplicação.

7. **Quantidade positiva** — A quantidade deve ser sempre maior que zero.

8. **Ordenação padrão** — Listagem ordenada por Data da Movimentação (mais recente primeiro), depois por Número.

---

## Exemplos de Uso

### Registrar entrada

```json
POST /api/movimentacoes-estoque
{
  "dataMovimentacao": "2026-03-01T10:00:00",
  "tipoMovimentacaoEstoqueId": "...(id do tipo Entrada)...",
  "produtoId": "...",
  "quantidade": 50,
  "unidadeMedidaId": "...",
  "custoUnitario": 25.50,
  "depositoDestinoId": "...",
  "documentoOrigem": "NF 12345"
}
```

### Registrar transferência

```json
POST /api/movimentacoes-estoque
{
  "dataMovimentacao": "2026-03-01T14:00:00",
  "tipoMovimentacaoEstoqueId": "...(id do tipo Transferência)...",
  "produtoId": "...",
  "quantidade": 10,
  "unidadeMedidaId": "...",
  "custoUnitario": 25.50,
  "depositoOrigemId": "...(depósito A)...",
  "depositoDestinoId": "...(depósito B)..."
}
```
