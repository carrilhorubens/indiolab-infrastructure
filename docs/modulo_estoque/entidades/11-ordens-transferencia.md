# Operação: Ordens de Transferência

## Objetivo

Gerenciar a transferência de produtos entre depósitos, controlando o envio e recebimento de cada item com rastreabilidade completa. A ordem segue um workflow de 5 estados com validação de saldo e geração automática de movimentações.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/ordens-transferencia/proximo-numero` | Próximo número disponível |
| `GET` | `/api/ordens-transferencia` | Listar ordens (paginado) |
| `GET` | `/api/ordens-transferencia/{id}` | Detalhes com itens |
| `POST` | `/api/ordens-transferencia` | Criar nova ordem (Rascunho) |
| `PUT` | `/api/ordens-transferencia/{id}` | Atualizar ordem (somente Rascunho) |
| `DELETE` | `/api/ordens-transferencia/{id}` | Excluir ordem (somente Rascunho) |
| `PATCH` | `/api/ordens-transferencia/{id}/aprovar` | Rascunho → Aprovada |
| `PATCH` | `/api/ordens-transferencia/{id}/enviar` | Aprovada → Em Trânsito |
| `PATCH` | `/api/ordens-transferencia/{id}/receber` | Em Trânsito → Recebida |
| `PATCH` | `/api/ordens-transferencia/{id}/cancelar` | Cancelar ordem |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.OrdensTransferencia.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Depósito Origem, Destino, Número |
| `status` | string? | Filtro por status (ex: "Aprovada") |

---

## Campos da Ordem

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `numero` | int | Auto | Número sequencial |
| `depositoOrigemId` | Guid | Sim | FK para o depósito de origem |
| `depositoDestinoId` | Guid | Sim | FK para o depósito de destino |
| `dataSolicitacao` | DateTime | Auto | Data/hora de criação |
| `dataPrevistaEnvio` | DateTime? | Não | Data prevista para envio |
| `dataEnvio` | DateTime? | Auto | Preenchido ao enviar |
| `dataRecebimento` | DateTime? | Auto | Preenchido ao receber |
| `solicitanteId` | Guid | Auto | ID do usuário que criou |
| `status` | string | Auto | Status da ordem (padrão: "Rascunho") |
| `observacao` | string? | Não | Observações |

### Itens da Ordem

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `quantidadeSolicitada` | decimal | Sim | Quantidade solicitada (> 0) |
| `quantidadeEnviada` | decimal | Auto | Quantidade efetivamente enviada |
| `quantidadeRecebida` | decimal | Auto | Quantidade efetivamente recebida |
| `loteId` | Guid? | Não | FK para o lote |

---

## Workflow de Status

```
Rascunho → [aprovar] → Aprovada → [enviar] → Em Trânsito → [receber] → Recebida
    ↓                      ↓
 [cancelar]            [cancelar]
    ↓                      ↓
Cancelado              Cancelado
    ↑
 [delete] (soft delete, somente Rascunho)
```

**Restrições:**
- Cancelar é bloqueado para "Em Trânsito", "Recebida" e "Cancelada"
- Editar e excluir só são permitidos no status "Rascunho"

---

## Regras de Negócio

1. **Depósitos diferentes** — Origem e destino devem ser depósitos distintos.

2. **Ao menos um item** — A ordem deve conter pelo menos um item.

3. **Quantidade positiva** — Cada item deve ter `quantidadeSolicitada > 0`.

4. **Aprovação valida saldo** — Para cada item, verifica se `saldo.QuantidadeDisponivel >= item.QuantidadeSolicitada` no depósito de origem. Retorna erro por produto com nome e quantidades.

5. **Envio gera movimentações de saída** — Para cada item:
   - Valida saldo na origem
   - Cria `MovimentacaoEstoque` de Transferência (saída)
   - Debita `saldo.AplicarSaida()` na origem
   - Aceita quantidades parciais via `EnvioRequest`; se não informado, usa `QuantidadeSolicitada`

6. **Recebimento gera movimentações de entrada** — Para cada item:
   - Cria `MovimentacaoEstoque` de Transferência (entrada)
   - Aplica `saldo.AplicarEntrada()` no destino com custo médio da origem
   - Cria saldo no destino automaticamente se não existir
   - Aceita quantidades recebidas diferentes do enviado (recebimento parcial)

7. **Atualização faz replace dos itens** — O PUT remove todos os itens existentes e recria com os novos.

8. **Solicitante automático** — Atribuído a partir do JWT na criação.

9. **Datas automáticas** — `dataEnvio` preenchida ao enviar, `dataRecebimento` preenchida ao receber.

---

## Exemplos de Uso

### Criar ordem de transferência

```json
POST /api/ordens-transferencia
{
  "depositoOrigemId": "...(depósito central)...",
  "depositoDestinoId": "...(filial)...",
  "dataPrevistaEnvio": "2026-03-10",
  "itens": [
    {
      "produtoId": "...",
      "quantidadeSolicitada": 20,
      "loteId": "..."
    },
    {
      "produtoId": "...",
      "quantidadeSolicitada": 10
    }
  ]
}
```

### Enviar com quantidades parciais

```json
PATCH /api/ordens-transferencia/{id}/enviar
{
  "itens": [
    { "itemId": "...", "quantidadeEnviada": 15 },
    { "itemId": "...", "quantidadeEnviada": 10 }
  ]
}
```

### Receber

```json
PATCH /api/ordens-transferencia/{id}/receber
{
  "itens": [
    { "itemId": "...", "quantidadeRecebida": 15 },
    { "itemId": "...", "quantidadeRecebida": 9 }
  ]
}
```
