# Cadastro: Produtos

## Objetivo

Gerenciar o catálogo de produtos do estoque, incluindo informações de identificação, classificação, níveis de estoque, dimensões, controle de lote/série e dados fiscais.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/produtos/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/produtos` | Listar produtos (paginado) |
| `GET` | `/api/produtos/{id}` | Detalhes de um produto |
| `POST` | `/api/produtos` | Criar novo produto |
| `PUT` | `/api/produtos/{id}` | Atualizar produto |
| `DELETE` | `/api/produtos/{id}` | Excluir produto (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Produtos.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome, SKU, Código de Barras, Código |
| `active` | bool? | Filtro por status ativo/inativo |

---

## Campos do Produto

### Identificação

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `nome` | string | Sim | Nome do produto |
| `descricao` | string? | Não | Descrição detalhada |
| `sku` | string? | Não | Código SKU (único por tenant) |
| `codigoBarras` | string? | Não | Código de barras (único por tenant) |
| `ncm` | string? | Não | Classificação fiscal NCM |
| `imagemUrl` | string? | Não | URL da imagem do produto |
| `observacoes` | string? | Não | Notas internas |

### Classificação

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `categoriaId` | Guid? | Não | FK para CategoriaProduto (domínio público) |
| `unidadeMedidaId` | Guid | Sim | FK para UnidadeMedida |
| `tipoProdutoId` | Guid | Sim | FK para TipoProduto |
| `metodoCusteio` | string | Não | Método de custeio (padrão: "CustoMedio") |
| `origemFiscal` | string? | Não | Origem fiscal do produto |
| `classeABC` | string? | Auto | Classificação Curva ABC (A/B/C), calculada automaticamente |

### Valores

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `custoUnitario` | decimal | Não | Custo unitário |
| `precoVenda` | decimal | Não | Preço de venda |

### Níveis de Estoque

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `estoqueMinimo` | decimal | Não | Nível mínimo de estoque |
| `pontoReposicao` | decimal | Não | Ponto de reposição (trigger para compra) |
| `estoqueMaximo` | decimal | Não | Nível máximo de estoque |
| `quantidadeReposicao` | decimal | Não | Quantidade padrão de reposição |
| `leadTimeDias` | int | Não | Prazo de entrega em dias |

### Peso e Dimensões

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `pesoLiquido` | decimal? | Peso líquido |
| `pesoBruto` | decimal? | Peso bruto |
| `altura` | decimal? | Altura |
| `largura` | decimal? | Largura |
| `profundidade` | decimal? | Profundidade |

### Controle

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `controlaLote` | bool | Habilita rastreamento por lote |
| `controlaNumeroSerie` | bool | Habilita rastreamento por número de série |

---

## Regras de Negócio

1. **Código auto-incremental** — Gerado pelo banco de dados. Exibido com 8 dígitos (ex: `00000001`). Não enviado na criação.

2. **SKU e Código de Barras únicos** — Se informados, devem ser únicos no tenant. Na edição, a validação exclui o próprio produto.

3. **Soft Delete** — A exclusão marca o registro como deletado (`IsDeleted = true`, `Active = false`). Produtos deletados não aparecem em listagens.

4. **Curva ABC** — A classificação `classeABC` é atualizada automaticamente pelo endpoint de cálculo da Curva ABC (relatório 03), baseado no valor das saídas em um período.

5. **Ordenação padrão** — Listagem ordenada por Nome (A→Z).

---

## Exemplos de Uso

### Criar produto

```json
POST /api/produtos
{
  "nome": "Lente CR-39 Multifocal",
  "unidadeMedidaId": "...",
  "tipoProdutoId": "...",
  "sku": "LCR39-MF-001",
  "custoUnitario": 45.90,
  "precoVenda": 120.00,
  "estoqueMinimo": 10,
  "pontoReposicao": 20,
  "controlaLote": true,
  "controlaNumeroSerie": false
}
```

### Buscar produtos

```
GET /api/produtos?search=multifocal&active=true&page=1&pageSize=20
```
