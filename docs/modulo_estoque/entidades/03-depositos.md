# Cadastro: Depósitos

## Objetivo

Gerenciar os depósitos (armazéns) da empresa, definindo locais físicos de armazenamento com responsável, tipo e capacidade.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/depositos/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/depositos` | Listar depósitos (paginado) |
| `GET` | `/api/depositos/{id}` | Detalhes de um depósito |
| `POST` | `/api/depositos` | Criar novo depósito |
| `PUT` | `/api/depositos/{id}` | Atualizar depósito |
| `DELETE` | `/api/depositos/{id}` | Excluir depósito (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Depositos.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome, Descrição, Responsável, Código |
| `active` | bool? | Filtro por status ativo/inativo |

---

## Campos do Depósito

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `nome` | string | Sim | Nome do depósito (único por tenant) |
| `descricao` | string? | Não | Descrição do depósito |
| `responsavel` | string? | Não | Nome do responsável |
| `tipo` | string? | Não | Tipo do depósito (ex: "Principal", "Filial") |
| `capacidade` | decimal? | Não | Capacidade de armazenamento |
| `enderecoId` | Guid? | Não | FK para endereço (opcional) |

---

## Regras de Negócio

1. **Nome único** — O nome do depósito deve ser único por tenant (case-insensitive).

2. **Proteção contra exclusão** — Não é possível excluir um depósito que possui localizações vinculadas. Remova as localizações primeiro.

3. **Código auto-incremental** — Gerado pelo banco de dados. Exibido com 8 dígitos.

4. **Ordenação padrão** — Listagem ordenada por Nome (A→Z).

---

## Exemplos de Uso

### Criar depósito

```json
POST /api/depositos
{
  "nome": "Depósito Central",
  "responsavel": "João Silva",
  "tipo": "Principal",
  "capacidade": 5000
}
```
