# Entidade: Aprovações de Pedido

## Objetivo

Registrar o histórico de aprovações e rejeições de pedidos de venda, com informações do aprovador, nível de alçada e motivo.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/pedido-venda-aprovacoes` | Lista paginada (filtrável por pedido) |
| `POST` | `/api/pedido-venda-aprovacoes` | Registra ação de aprovação |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Aprovacoes.View` (GET) / `Permissions.Vendas.Aprovacoes.Create` (POST)

---

## Parâmetros (GET)

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------:|
| `page` | int | Não | Página |
| `pageSize` | int | Não | Itens por página |
| `pedidoVendaId` | Guid | Não | Filtrar por pedido de venda |

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `pedidoVendaId` | Guid | Sim | FK para pedido de venda |
| `aprovadorId` | Guid | Sim | Usuário que realizou a ação |
| `acao` | string | Sim | Aprovado, Rejeitado |
| `motivo` | string? | Não | Justificativa da decisão |
| `dataAcao` | DateTime | Auto | Data/hora da ação |
| `nivelAlcada` | int | Sim | Nível de alçada do aprovador |

---

## Regras

- Entidade de **audit trail**: imutável (sem PUT, sem DELETE)
- Cada registro é um evento de aprovação ou rejeição
- `NivelAlcada` indica o nível hierárquico do aprovador (1, 2, 3...)
- Permite rastrear todo o histórico de decisões sobre um pedido
- Um pedido pode ter múltiplos registros de aprovação (ex: rejeitado e depois aprovado)
