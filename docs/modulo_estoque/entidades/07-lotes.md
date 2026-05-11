# Cadastro: Lotes

## Objetivo

Gerenciar lotes de produtos para rastreabilidade por fabricação, controle de validade e vínculo com fornecedores. Apenas produtos com `controlaLote = true` podem ter lotes cadastrados.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/lotes/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/lotes` | Listar lotes (paginado) |
| `GET` | `/api/lotes/{id}` | Detalhes de um lote |
| `GET` | `/api/lotes/por-produto/{produtoId}` | Listar lotes de um produto |
| `POST` | `/api/lotes` | Criar novo lote |
| `PUT` | `/api/lotes/{id}` | Atualizar lote |
| `DELETE` | `/api/lotes/{id}` | Excluir lote (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Lotes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Número do Lote, Nome do Produto, Código |
| `produtoId` | Guid? | Filtro por produto |
| `status` | string? | Filtro por status (ex: "Ativo") |

---

## Campos do Lote

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `produtoId` | Guid | Sim | FK para o produto (deve ter `controlaLote = true`) |
| `numeroLote` | string | Sim | Número do lote (único por produto) |
| `dataFabricacao` | DateTime? | Não | Data de fabricação |
| `dataValidade` | DateTime? | Não | Data de validade |
| `fornecedorId` | Guid? | Não | FK para o fornecedor de origem |
| `status` | string | Auto | Status do lote (padrão: "Ativo") |
| `observacao` | string? | Não | Observações |

---

## Regras de Negócio

1. **Produto com controle de lote** — O produto deve ter `controlaLote = true`. Caso contrário, a criação falha.

2. **Número de lote único por produto** — Não é possível criar dois lotes com o mesmo `numeroLote` para o mesmo produto.

3. **Status** — Padrão "Ativo" na criação. Pode ser alterado via `AlterarStatus()`.

4. **Vínculo com movimentações** — Lotes podem ser referenciados em movimentações de estoque via `loteId`, permitindo rastreabilidade completa (ver relatórios 06 e 12).

5. **Ordenação padrão** — Listagem ordenada por data de criação (mais recente primeiro), depois por Número do Lote.

---

## Exemplos de Uso

### Criar lote

```json
POST /api/lotes
{
  "produtoId": "...",
  "numeroLote": "LOT-2026-001",
  "dataFabricacao": "2026-01-15",
  "dataValidade": "2027-01-15",
  "fornecedorId": "..."
}
```

### Listar lotes de um produto

```
GET /api/lotes/por-produto/{produtoId}
```
