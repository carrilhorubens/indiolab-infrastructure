# Cadastro: Localizações

## Objetivo

Gerenciar os endereços internos de armazenamento dentro de cada depósito (prateleiras, gavetas, corredores), permitindo rastreabilidade granular da posição dos produtos.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/localizacoes` | Listar localizações (paginado) |
| `GET` | `/api/localizacoes/{id}` | Detalhes de uma localização |
| `POST` | `/api/localizacoes` | Criar nova localização |
| `PUT` | `/api/localizacoes/{id}` | Atualizar localização |
| `DELETE` | `/api/localizacoes/{id}` | Excluir localização (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Localizacoes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome, Código, Descrição, Nome do Depósito |
| `active` | bool? | Filtro por status ativo/inativo |
| `depositoId` | Guid? | Filtro por depósito específico |

---

## Campos da Localização

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | string | Sim | Código de endereçamento (ex: "A-01-03-02"). Único por depósito |
| `nome` | string | Sim | Nome da localização |
| `descricao` | string? | Não | Descrição da localização |
| `tipo` | string? | Não | Tipo (ex: "Prateleira", "Gaveta", "Corredor") |
| `capacidade` | decimal? | Não | Capacidade de armazenamento |
| `depositoId` | Guid | Sim | FK para o depósito pai |

---

## Regras de Negócio

1. **Código único por depósito** — O código da localização deve ser único dentro do mesmo depósito. Diferentes depósitos podem ter o mesmo código.

2. **Depósito obrigatório** — Toda localização pertence a um depósito. O depósito referenciado deve existir.

3. **Ordenação padrão** — Listagem ordenada por Nome do Depósito, depois por Código da Localização.

---

## Exemplos de Uso

### Criar localização

```json
POST /api/localizacoes
{
  "depositoId": "...",
  "codigo": "A-01-03",
  "nome": "Prateleira A, Corredor 1, Nível 3",
  "tipo": "Prateleira",
  "capacidade": 200
}
```

### Filtrar por depósito

```
GET /api/localizacoes?depositoId=abc123&active=true
```
