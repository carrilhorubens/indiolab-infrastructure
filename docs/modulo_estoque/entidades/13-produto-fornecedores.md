# Cadastro: Produto-Fornecedor

## Objetivo

Gerenciar os vínculos comerciais entre produtos e fornecedores, registrando custo unitário, lead time, quantidade mínima de pedido e fornecedor principal para cada produto.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/produto-fornecedores` | Listar vínculos (paginado) |
| `GET` | `/api/produto-fornecedores/{id}` | Detalhes de um vínculo |
| `GET` | `/api/produto-fornecedores/por-produto/{produtoId}` | Fornecedores de um produto |
| `GET` | `/api/produto-fornecedores/por-fornecedor/{fornecedorId}` | Produtos de um fornecedor |
| `POST` | `/api/produto-fornecedores` | Criar novo vínculo |
| `PUT` | `/api/produto-fornecedores/{id}` | Atualizar dados comerciais |
| `DELETE` | `/api/produto-fornecedores/{id}` | Excluir vínculo (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Produtos.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Produto, Nome do Fornecedor, Código no Fornecedor |
| `produtoId` | Guid? | Filtro por produto |
| `fornecedorId` | Guid? | Filtro por fornecedor |

---

## Campos do Vínculo

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `fornecedorId` | Guid | Sim | FK para o fornecedor |
| `codigoNoFornecedor` | string? | Não | Código do produto na tabela do fornecedor |
| `custoUnitario` | decimal | Sim | Preço de compra unitário |
| `leadTimeDias` | int | Sim | Prazo de entrega em dias |
| `quantidadeMinimaPedido` | decimal | Sim | Quantidade mínima de pedido (MOQ) |
| `principal` | bool | Sim | Indica o fornecedor preferencial para este produto |

---

## Regras de Negócio

1. **Produto e fornecedor devem existir** — Ambas as entidades referenciadas devem estar cadastradas.

2. **Vínculo único** — A combinação `(ProdutoId, FornecedorId)` deve ser única. Não é possível duplicar o vínculo.

3. **Nome do fornecedor** — Resolvido via `Fornecedor.Pessoa.Nome` (join duplo: Fornecedor → Pessoa).

4. **Atualização parcial** — O PUT permite alterar apenas os dados comerciais (custoUnitario, leadTimeDias, quantidadeMinimaPedido, codigoNoFornecedor, principal). ProdutoId e FornecedorId são imutáveis.

5. **Ordenação por endpoint:**
   - **Listagem paginada:** Data de criação (mais recente primeiro), depois Nome do Produto
   - **Por produto:** Nome do Fornecedor (A→Z)
   - **Por fornecedor:** Nome do Produto (A→Z)

---

## Exemplos de Uso

### Criar vínculo produto-fornecedor

```json
POST /api/produto-fornecedores
{
  "produtoId": "...",
  "fornecedorId": "...",
  "codigoNoFornecedor": "ESS-LNT-001",
  "custoUnitario": 85.50,
  "leadTimeDias": 7,
  "quantidadeMinimaPedido": 10,
  "principal": true
}
```

### Listar fornecedores de um produto

```
GET /api/produto-fornecedores/por-produto/{produtoId}
```

### Listar produtos de um fornecedor

```
GET /api/produto-fornecedores/por-fornecedor/{fornecedorId}
```
