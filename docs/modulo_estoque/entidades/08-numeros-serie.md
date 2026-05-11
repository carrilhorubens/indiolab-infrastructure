# Cadastro: Números de Série

## Objetivo

Gerenciar números de série individuais para rastreabilidade unitária de produtos. Apenas produtos com `controlaNumeroSerie = true` podem ter séries cadastradas.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/numeros-serie` | Listar números de série (paginado) |
| `GET` | `/api/numeros-serie/{id}` | Detalhes de um número de série |
| `GET` | `/api/numeros-serie/por-produto/{produtoId}` | Listar séries de um produto |
| `POST` | `/api/numeros-serie` | Criar novo número de série |
| `PUT` | `/api/numeros-serie/{id}` | Atualizar status/localização |
| `DELETE` | `/api/numeros-serie/{id}` | Excluir número de série (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.NumerosSerie.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Série, Nome do Produto, Número do Lote |
| `produtoId` | Guid? | Filtro por produto |
| `status` | string? | Filtro por status (ex: "Disponível") |

---

## Campos do Número de Série

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto (deve ter `controlaNumeroSerie = true`) |
| `serie` | string | Sim | Identificador único por produto |
| `dataEntrada` | DateTime | Sim | Data de entrada no estoque |
| `dataSaida` | DateTime? | Auto | Preenchido ao alterar status para "Vendido" ou "Sucateado" |
| `loteId` | Guid? | Não | FK para o lote associado |
| `depositoId` | Guid? | Não | FK para o depósito atual |
| `localizacaoId` | Guid? | Não | FK para a localização dentro do depósito |
| `status` | string | Auto | Status do item (padrão: "Disponível") |

---

## Status do Número de Série

| Status | Descrição |
|--------|-----------|
| **Disponível** | Item no estoque, pronto para venda/uso |
| **Vendido** | Item vendido — `dataSaida` preenchida automaticamente |
| **Sucateado** | Item descartado — `dataSaida` preenchida automaticamente |

---

## Regras de Negócio

1. **Produto com controle de série** — O produto deve ter `controlaNumeroSerie = true`. Caso contrário, a criação falha.

2. **Série única por produto** — Não é possível criar duas séries com o mesmo identificador para o mesmo produto (validado na criação e na edição).

3. **Data de saída automática** — Ao alterar o status para "Vendido" ou "Sucateado", o campo `dataSaida` é preenchido automaticamente com a data/hora atual (UTC).

4. **Atualização parcial** — O PUT permite alterar: série, status, loteId, depositoId, localizacaoId e active. O produtoId não pode ser alterado.

5. **Ordenação padrão** — Listagem ordenada por Data de Entrada (mais recente primeiro), depois por Série.

---

## Exemplos de Uso

### Criar número de série

```json
POST /api/numeros-serie
{
  "produtoId": "...",
  "serie": "SN-2026-0001",
  "dataEntrada": "2026-01-15",
  "depositoId": "...",
  "localizacaoId": "..."
}
```

### Listar séries de um produto

```
GET /api/numeros-serie/por-produto/{produtoId}
```

### Atualizar status para vendido

```json
PUT /api/numeros-serie/{id}
{
  "serie": "SN-2026-0001",
  "status": "Vendido",
  "depositoId": null,
  "localizacaoId": null
}
```
