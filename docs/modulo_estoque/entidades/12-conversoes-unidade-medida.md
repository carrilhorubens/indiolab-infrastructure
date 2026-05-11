# Cadastro: Conversões de Unidade de Medida

## Objetivo

Gerenciar fatores de conversão entre unidades de medida, permitindo conversões globais (aplicáveis a todos os produtos) ou específicas por produto. Utilizado para converter quantidades entre diferentes unidades em operações de estoque e compras.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/conversoes-unidade-medida` | Listar conversões (paginado) |
| `GET` | `/api/conversoes-unidade-medida/{id}` | Detalhes de uma conversão |
| `POST` | `/api/conversoes-unidade-medida` | Criar nova conversão |
| `PUT` | `/api/conversoes-unidade-medida/{id}` | Atualizar fator de conversão |
| `DELETE` | `/api/conversoes-unidade-medida/{id}` | Excluir conversão (soft delete) |
| `GET` | `/api/conversoes-unidade-medida/converter` | Consultar fator entre duas UMs |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome da UM Origem, UM Destino, Produto |
| `produtoId` | Guid? | Filtro por produto específico |

---

## Campos da Conversão

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `unidadeMedidaOrigemId` | Guid | Sim | FK para a unidade de medida de origem |
| `unidadeMedidaDestinoId` | Guid | Sim | FK para a unidade de medida de destino |
| `fatorConversao` | decimal | Sim | Fator multiplicador (ex: 12 para Caixa→Unidade) |
| `produtoId` | Guid? | Não | FK para produto (null = conversão global) |

---

## Endpoint de Conversão

### `GET /api/conversoes-unidade-medida/converter`

Retorna o fator de conversão entre duas unidades de medida.

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `origemId` | Guid | Sim | ID da unidade de origem |
| `destinoId` | Guid | Sim | ID da unidade de destino |
| `produtoId` | Guid? | Não | ID do produto (prioriza conversão específica) |

**Lógica de busca:**
1. Se `produtoId` informado, busca primeiro a conversão específica do produto
2. Se não encontrar, busca a conversão global (`produtoId = null`)
3. Retorna `404` se nenhuma conversão for encontrada

---

## Regras de Negócio

1. **Unidades diferentes** — Origem e destino devem ser unidades de medida distintas.

2. **Unicidade** — A combinação `(OrigemId, DestinoId, ProdutoId)` deve ser única, incluindo o caso onde `ProdutoId` é nulo (conversão global).

3. **Prioridade por produto** — O endpoint `converter` busca primeiro a conversão específica do produto antes da global.

4. **Atualização restrita** — O PUT permite alterar somente o `fatorConversao`. As unidades de medida e o produto não podem ser modificados.

5. **Ordenação padrão** — Listagem ordenada por data de criação (mais recente primeiro).

---

## Exemplos de Uso

### Criar conversão global (Caixa → Unidade)

```json
POST /api/conversoes-unidade-medida
{
  "unidadeMedidaOrigemId": "...(Caixa)...",
  "unidadeMedidaDestinoId": "...(Unidade)...",
  "fatorConversao": 12
}
```

### Criar conversão específica por produto

```json
POST /api/conversoes-unidade-medida
{
  "unidadeMedidaOrigemId": "...(Caixa)...",
  "unidadeMedidaDestinoId": "...(Unidade)...",
  "fatorConversao": 6,
  "produtoId": "...(lente específica)..."
}
```

### Consultar fator de conversão

```
GET /api/conversoes-unidade-medida/converter?origemId=...&destinoId=...&produtoId=...
```
