# Cadastro: Histórico de Preços

## Objetivo

Registrar e consultar a evolução de preços de produtos por fornecedor ao longo do tempo, com registros automáticos (originados de cotações, ordens de compra e contratos) e manuais, além de comparativo entre fornecedores.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/historico-precos` | Listar registros (paginado) |
| `GET` | `/api/historico-precos/{id}` | Detalhes de um registro |
| `POST` | `/api/historico-precos` | Entrada manual de preço |
| `DELETE` | `/api/historico-precos/{id}` | Excluir registro (somente manuais) |
| `GET` | `/api/historico-precos/comparativo/{produtoId}` | Comparativo por fornecedor |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.HistoricoPrecos.View / .Create / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `produtoId` | Guid? | Filtro por produto |
| `fornecedorId` | Guid? | Filtro por fornecedor |
| `fonteRegistro` | string? | Filtro por fonte (Cotacao, OrdemCompra, Contrato, Manual) |

## Parâmetros do Comparativo

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `dataInicio` | DateTime? | Início do período |
| `dataFim` | DateTime? | Fim do período |

---

## Campos do Registro

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `fornecedorId` | Guid | Sim | FK para o fornecedor |
| `dataRegistro` | DateTime | Sim | Data do registro de preço |
| `precoUnitario` | decimal | Sim | Preço unitário registrado |
| `quantidadeMinima` | decimal? | Não | Quantidade mínima para esse preço |
| `descontoPct` | decimal | Não | Percentual de desconto |
| `fonteRegistro` | string | Auto | Fonte: "Cotacao", "OrdemCompra", "Contrato" ou "Manual" |
| `fonteId` | Guid? | Auto | ID do documento de origem |
| `observacoes` | string? | Não | Observações |

---

## Fontes de Registro

| Fonte | Descrição | Editável |
|-------|-----------|:--------:|
| `Cotacao` | Gerado automaticamente ao registrar proposta de cotação | Não |
| `OrdemCompra` | Gerado automaticamente ao criar/aprovar OC | Não |
| `Contrato` | Gerado automaticamente ao ativar contrato | Não |
| `Manual` | Entrada manual pelo usuário | Sim |

---

## Comparativo de Preços

O endpoint `comparativo/{produtoId}` retorna estatísticas por fornecedor:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `fornecedorId` | Guid | ID do fornecedor |
| `fornecedorNome` | string | Nome do fornecedor |
| `ultimoPreco` | decimal | Preço mais recente |
| `precoMedio` | decimal | Média de todos os preços |
| `menorPreco` | decimal | Menor preço registrado |
| `maiorPreco` | decimal | Maior preço registrado |
| `totalRegistros` | int | Quantidade de registros |
| `dataUltimoRegistro` | DateTime | Data do último registro |

---

## Regras de Negócio

1. **Write-once para fontes automáticas** — Registros gerados por Cotação, Ordem de Compra ou Contrato não podem ser editados ou excluídos.

2. **Exclusão restrita** — Apenas registros com `fonteRegistro = "Manual"` podem ser excluídos.

3. **Geração automática** — O sistema cria registros automaticamente ao:
   - Registrar proposta em cotação
   - Criar/aprovar ordem de compra
   - Ativar contrato de compra

4. **Comparativo filtrado** — O endpoint de comparativo aceita período para restringir a análise.

5. **Resolução de nomes** — Produto e fornecedor são resolvidos via joins.

---

## Exemplos de Uso

### Entrada manual de preço

```json
POST /api/historico-precos
{
  "produtoId": "...",
  "fornecedorId": "...",
  "dataRegistro": "2026-03-01",
  "precoUnitario": 85.50,
  "quantidadeMinima": 50,
  "descontoPct": 3,
  "observacoes": "Tabela atualizada pelo representante"
}
```

### Comparativo de preços de um produto

```
GET /api/historico-precos/comparativo/{produtoId}?dataInicio=2026-01-01&dataFim=2026-03-31
```
