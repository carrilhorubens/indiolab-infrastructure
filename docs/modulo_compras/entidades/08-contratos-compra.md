# Cadastro: Contratos de Compra

## Objetivo

Gerenciar contratos de fornecimento com vigência, valores previstos, itens contratados e acompanhamento de consumo. Suporta diferentes tipos (Blanket Order, Contrato, Acordo de Preço) com workflow de ativação, suspensão e reativação.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/contratos-compra/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/contratos-compra` | Listar contratos (paginado) |
| `GET` | `/api/contratos-compra/{id}` | Detalhes de um contrato |
| `POST` | `/api/contratos-compra` | Criar novo contrato |
| `PUT` | `/api/contratos-compra/{id}` | Atualizar contrato |
| `DELETE` | `/api/contratos-compra/{id}` | Excluir contrato (soft delete) |
| `PATCH` | `/api/contratos-compra/{id}/ativar` | Rascunho → Ativo |
| `PATCH` | `/api/contratos-compra/{id}/suspender` | Ativo → Suspenso |
| `PATCH` | `/api/contratos-compra/{id}/reativar` | Suspenso → Ativo |
| `PATCH` | `/api/contratos-compra/{id}/cancelar` | Cancelar contrato |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Contratos.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |

---

## Campos do Contrato

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `fornecedorId` | Guid | Sim | FK para o fornecedor |
| `tipo` | string | Sim | Tipo: "BlanketOrder", "Contrato" ou "AcordoPreco" |
| `dataInicio` | DateTime | Sim | Data de início da vigência |
| `dataFim` | DateTime | Sim | Data de término da vigência |
| `condicaoPagamentoId` | Guid? | Não | FK para condição de pagamento |
| `valorTotalPrevisto` | decimal | Sim | Valor total previsto do contrato |
| `valorTotalConsumido` | decimal | Auto | Valor já consumido via OCs |
| `quantidadeMinima` | decimal? | Não | Quantidade mínima contratada |
| `quantidadeMaxima` | decimal? | Não | Quantidade máxima contratada |
| `renovacaoAutomatica` | bool | Sim | Se deve renovar automaticamente |
| `diasAlertaVencimento` | int | Sim | Dias de antecedência para alerta |
| `status` | string | Auto | Status (padrão: "Rascunho") |
| `observacoes` | string? | Não | Observações |

### Itens do Contrato

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `precoUnitario` | decimal | Sim | Preço unitário contratado |
| `descontoPct` | decimal | Não | Percentual de desconto |
| `quantidadeMinima` | decimal? | Não | Quantidade mínima do item |
| `quantidadeMaxima` | decimal? | Não | Quantidade máxima do item |

---

## Tipos de Contrato

| Tipo | Descrição |
|------|-----------|
| **BlanketOrder** | Pedido aberto com quantidade e valor pré-acordados |
| **Contrato** | Contrato formal de fornecimento por período |
| **AcordoPreco** | Acordo de preços fixos sem compromisso de quantidade |

---

## Workflow de Status

```
Rascunho → [ativar] → Ativo → [suspender] → Suspenso → [reativar] → Ativo
                                                              ↓
                                                        (expiração) → Expirado

Qualquer status (exceto Expirado) → [cancelar] → Cancelado
```

---

## Regras de Negócio

1. **Vigência obrigatória** — `dataInicio` e `dataFim` são obrigatórios. O sistema calcula automaticamente o status "Expirado" quando `dataFim` é ultrapassada.

2. **Consumo rastreado** — O `valorTotalConsumido` é atualizado automaticamente quando ordens de compra são vinculadas ao contrato.

3. **Alerta de vencimento** — O `diasAlertaVencimento` define quantos dias antes do vencimento o contrato aparece no relatório de contratos vencendo.

4. **Renovação automática** — Flag indicativa para processos de renovação.

5. **Reativação** — Um contrato suspenso pode ser reativado, voltando ao status "Ativo".

6. **Resolução de nomes** — Fornecedor e condição de pagamento são resolvidos via joins.

---

## Exemplos de Uso

### Criar contrato

```json
POST /api/contratos-compra
{
  "fornecedorId": "...",
  "tipo": "BlanketOrder",
  "dataInicio": "2026-01-01",
  "dataFim": "2026-12-31",
  "condicaoPagamentoId": "...",
  "valorTotalPrevisto": 500000.00,
  "renovacaoAutomatica": true,
  "diasAlertaVencimento": 30,
  "itens": [
    {
      "produtoId": "...",
      "precoUnitario": 85.00,
      "descontoPct": 5,
      "quantidadeMinima": 100,
      "quantidadeMaxima": 1000
    }
  ]
}
```

### Ativar contrato

```
PATCH /api/contratos-compra/{id}/ativar
```
