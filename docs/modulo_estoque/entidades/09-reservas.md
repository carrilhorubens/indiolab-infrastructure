# Operação: Reservas de Estoque

## Objetivo

Reservar quantidades de produtos no estoque para pedidos de venda, ordens de serviço ou outros documentos, garantindo que o saldo reservado não seja consumido por outras operações. Reservas são **imutáveis** — uma vez criadas, só podem ser liberadas ou canceladas.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/reservas-estoque/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/reservas-estoque` | Listar reservas (paginado) |
| `GET` | `/api/reservas-estoque/{id}` | Detalhes de uma reserva |
| `POST` | `/api/reservas-estoque` | Criar nova reserva |
| `PATCH` | `/api/reservas-estoque/{id}/liberar` | Liberar reserva ativa |
| `PATCH` | `/api/reservas-estoque/{id}/cancelar` | Cancelar reserva ativa |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Reservas.View / .Create / .Edit`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Produto, Depósito, Tipo Documento, Código |
| `status` | string? | Filtro por status (ex: "Ativa") |

---

## Campos da Reserva

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `produtoId` | Guid | Sim | FK para o produto |
| `depositoId` | Guid | Sim | FK para o depósito |
| `localizacaoId` | Guid? | Não | FK para a localização |
| `quantidade` | decimal | Sim | Quantidade a reservar (> 0) |
| `dataReserva` | DateTime | Sim | Data da reserva |
| `dataExpiracao` | DateTime? | Não | Data de expiração da reserva |
| `documentoOrigemTipo` | string? | Não | Tipo do documento de origem (ex: "PedidoVenda") |
| `documentoOrigemId` | Guid? | Não | ID do documento de origem |
| `status` | string | Auto | Status da reserva (padrão: "Ativa") |
| `observacao` | string? | Não | Observações |

---

## Status da Reserva

| Status | Descrição |
|--------|-----------|
| **Ativa** | Reserva vigente — saldo comprometido |
| **Liberada** | Reserva consumida — saldo devolvido à disponibilidade |
| **Cancelada** | Reserva cancelada — saldo devolvido à disponibilidade |
| **Expirada** | Reserva expirada por data |

---

## Regras de Negócio

1. **Quantidade positiva** — A quantidade deve ser maior que zero.

2. **Produto deve existir** — O produto referenciado deve estar cadastrado.

3. **Saldo suficiente** — O sistema verifica se `QuantidadeDisponivel - QuantidadeReservada >= Quantidade` no registro de saldo. Se insuficiente, retorna erro com o saldo disponível.

4. **Saldo deve existir** — O registro de `EstoqueSaldo` para a combinação (Produto, Depósito, Localização) deve existir previamente.

5. **Atualização atômica** — A criação da reserva e a atualização do saldo (`AplicarReserva`) ocorrem na mesma transação. O mesmo vale para liberar/cancelar (`LiberarReserva`).

6. **Imutabilidade** — Não existe endpoint PUT. Uma reserva criada só pode ser liberada ou cancelada.

7. **Liberar/Cancelar** — Só é permitido quando o status é "Ativa". Qualquer outro status retorna erro.

8. **Ordenação padrão** — Listagem ordenada por Data da Reserva (mais recente primeiro), depois por Código.

---

## Exemplos de Uso

### Criar reserva

```json
POST /api/reservas-estoque
{
  "produtoId": "...",
  "depositoId": "...",
  "quantidade": 5,
  "dataReserva": "2026-03-01T10:00:00",
  "documentoOrigemTipo": "PedidoVenda",
  "documentoOrigemId": "..."
}
```

### Liberar reserva

```
PATCH /api/reservas-estoque/{id}/liberar
```

### Cancelar reserva

```
PATCH /api/reservas-estoque/{id}/cancelar
```
