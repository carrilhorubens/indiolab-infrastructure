# Relatório: Comparativo de Preços

## Objetivo

Comparar os preços praticados por diferentes fornecedores para um produto específico, exibindo último preço, média, menor e maior valor.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/comparativo-precos` | Comparativo entre fornecedores |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.HistoricoPrecos.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | ID do produto a comparar |

---

## Campos Retornados

### Cabeçalho

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | ID do produto |
| `produtoCodigo` | int | Código do produto |
| `produtoNome` | string | Nome do produto |
| `menorPreco` | decimal | Menor preço entre todos os fornecedores |
| `maiorPreco` | decimal | Maior preço entre todos os fornecedores |
| `precoMedio` | decimal | Preço médio geral |

### Itens (por fornecedor)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `fornecedorId` | Guid | ID do fornecedor |
| `fornecedorNome` | string | Nome do fornecedor |
| `ultimoPreco` | decimal | Preço mais recente |
| `precoMedio` | decimal | Preço médio do fornecedor |
| `menorPreco` | decimal | Menor preço do fornecedor |
| `maiorPreco` | decimal | Maior preço do fornecedor |
| `totalRegistros` | int | Quantidade de registros |
| `dataUltimoRegistro` | DateTime | Data do último registro |

---

## Regras

- Fonte de dados: tabela `HistoricoPrecos`
- Inclui todas as fontes (Cotação, OC, Contrato, Manual)
- Ordenado por último preço (menor primeiro)
