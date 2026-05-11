# Cadastro: Estoque Consignado

## Objetivo

Gerenciar produtos em consignação — mercadorias armazenadas no depósito da empresa, mas que pertencem a um fornecedor ou cliente. O controle inclui referência ao contrato, período de vigência e quantidade consignada.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/estoque-consignado` | Listar itens consignados (paginado) |
| `GET` | `/api/estoque-consignado/{id}` | Detalhes de um item consignado |
| `POST` | `/api/estoque-consignado` | Criar registro de consignação |
| `PUT` | `/api/estoque-consignado/{id}` | Atualizar quantidade/datas |
| `DELETE` | `/api/estoque-consignado/{id}` | Excluir registro (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Produto, Depósito, Contrato, Tipo Proprietário |
| `produtoId` | Guid? | Filtro por produto |
| `tipoProprietario` | string? | Filtro por tipo: "Fornecedor" ou "Cliente" |

---

## Campos do Estoque Consignado

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `depositoId` | Guid | Sim | FK para o depósito onde está armazenado |
| `tipoProprietario` | string | Sim | "Fornecedor" ou "Cliente" |
| `proprietarioId` | Guid | Sim | ID do fornecedor ou cliente proprietário |
| `quantidade` | decimal | Sim | Quantidade consignada |
| `contratoRef` | string? | Não | Referência ao contrato de consignação |
| `dataInicio` | DateTime | Auto | Data de início (padrão: data atual se não informada) |
| `dataFim` | DateTime? | Não | Data de fim/vencimento da consignação |
| `observacao` | string? | Não | Observações |

---

## FK Polimórfica

O campo `proprietarioId` é uma **FK polimórfica** que referencia diferentes tabelas conforme o `tipoProprietario`:

| Tipo Proprietário | Tabela Referenciada | Resolução de Nome |
|-------------------|--------------------|--------------------|
| `"Fornecedor"` | Fornecedores → Pessoas | `Fornecedor.Pessoa.Nome` |
| `"Cliente"` | Clientes → Pessoas | `Cliente.Pessoa.Nome` |

> **Nota:** Não existe FK no banco de dados. A integridade é garantida pela aplicação.

---

## Regras de Negócio

1. **Produto e depósito devem existir** — Ambas as entidades referenciadas devem estar cadastradas.

2. **Vínculo único** — A combinação `(ProdutoId, DepositoId, TipoProprietario, ProprietarioId)` deve ser única.

3. **Resolução de nome** — O sistema resolve o nome do proprietário via join duplo (Fornecedor/Cliente → Pessoa). Para tipos desconhecidos, retorna "Tipo desconhecido".

4. **Atualização restrita** — O PUT permite alterar apenas: `quantidade`, `contratoRef`, `dataFim` e `observacao`. Os campos `produtoId`, `depositoId`, `tipoProprietario`, `proprietarioId` e `dataInicio` são imutáveis.

5. **Data de início padrão** — Se não informada na criação, é preenchida automaticamente com a data/hora atual (UTC).

6. **Valor do consignado** — O Dashboard calcula o valor como `Quantidade × Produto.CustoUnitario` (via JOIN com a tabela de produtos).

7. **Ordenação padrão** — Listagem ordenada por Data de Início (mais recente primeiro), depois por Nome do Produto.

---

## Exemplos de Uso

### Criar consignação de fornecedor

```json
POST /api/estoque-consignado
{
  "produtoId": "...",
  "depositoId": "...",
  "tipoProprietario": "Fornecedor",
  "proprietarioId": "...(ID do fornecedor)...",
  "quantidade": 100,
  "contratoRef": "CTR-2026-001",
  "dataInicio": "2026-01-01",
  "dataFim": "2026-06-30"
}
```

### Filtrar por tipo de proprietário

```
GET /api/estoque-consignado?tipoProprietario=Fornecedor
```
