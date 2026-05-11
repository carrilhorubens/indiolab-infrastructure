# Operação: Requisições de Compra

## Objetivo

Formalizar a solicitação interna de aquisição de materiais, com workflow de aprovação, priorização e possibilidade de geração automática a partir de produtos abaixo do ponto de reposição.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/requisicoes-compra/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/requisicoes-compra` | Listar requisições (paginado) |
| `GET` | `/api/requisicoes-compra/{id}` | Detalhes de uma requisição |
| `POST` | `/api/requisicoes-compra` | Criar nova requisição |
| `PUT` | `/api/requisicoes-compra/{id}` | Atualizar requisição |
| `DELETE` | `/api/requisicoes-compra/{id}` | Excluir requisição (soft delete) |
| `POST` | `/api/requisicoes-compra/gerar-automatica` | Gerar requisição automática por estoque mínimo |
| `PATCH` | `/api/requisicoes-compra/{id}/enviar-aprovacao` | Rascunho → Pendente Aprovação |
| `PATCH` | `/api/requisicoes-compra/{id}/aprovar` | Pendente Aprovação → Aprovada |
| `PATCH` | `/api/requisicoes-compra/{id}/rejeitar` | Pendente Aprovação → Rejeitada |
| `PATCH` | `/api/requisicoes-compra/{id}/cancelar` | Cancelar requisição |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Requisicoes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |

---

## Campos da Requisição

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `solicitanteId` | Guid | Auto | ID do solicitante (JWT) |
| `dataRequisicao` | DateTime | Sim | Data da requisição |
| `dataNecessidade` | DateTime? | Não | Data em que o material é necessário |
| `prioridade` | string | Sim | Prioridade (ex: "Normal", "Urgente", "Crítica") |
| `departamentoId` | Guid? | Não | FK para departamento solicitante |
| `centroCustoId` | Guid? | Não | FK para centro de custo |
| `motivoRequisicaoId` | Guid? | Não | FK para motivo (domínio) |
| `justificativa` | string? | Não | Justificativa da requisição |
| `status` | string | Auto | Status (padrão: "Rascunho") |
| `aprovadorId` | Guid? | Auto | ID do aprovador |
| `dataAprovacao` | DateTime? | Auto | Data da aprovação/rejeição |
| `ordemCompraId` | Guid? | Auto | FK para OC gerada (quando convertida) |
| `observacoes` | string? | Não | Observações |

### Itens da Requisição

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `descricao` | string? | Não | Descrição complementar |
| `quantidade` | decimal | Sim | Quantidade solicitada |
| `unidadeMedidaId` | Guid? | Não | FK para unidade de medida |
| `precoEstimado` | decimal | Sim | Preço estimado unitário |
| `fornecedorSugeridoId` | Guid? | Não | FK para fornecedor sugerido |

### Valores Calculados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `valorEstimadoTotal` | decimal | Soma de `quantidade × precoEstimado` de todos os itens |

---

## Workflow de Status

```
Rascunho → [enviar-aprovacao] → PendenteAprovacao → [aprovar] → Aprovada → Convertida (ao gerar OC)
                                       ↓
                                   [rejeitar] → Rejeitada

Qualquer status → [cancelar] → Cancelada
```

---

## Regras de Negócio

1. **Solicitante automático** — Atribuído a partir do JWT na criação.

2. **Geração automática** — O endpoint `gerar-automatica` consulta produtos com saldo abaixo do ponto de reposição e cria uma requisição com esses itens, usando o preço do fornecedor principal.

3. **Aprovação registra aprovador** — Ao aprovar, o `aprovadorId` e `dataAprovacao` são preenchidos automaticamente.

4. **Conversão para OC** — Uma requisição aprovada pode ser convertida em ordem de compra. O vínculo é mantido via `ordemCompraId`.

5. **Prioridade** — Classifica a urgência da requisição para ordenação nos relatórios.

6. **Resolução de nomes** — Solicitante, aprovador, departamento e motivo são resolvidos via joins.

---

## Exemplos de Uso

### Criar requisição

```json
POST /api/requisicoes-compra
{
  "dataRequisicao": "2026-03-01",
  "prioridade": "Urgente",
  "departamentoId": "...",
  "dataNecessidade": "2026-03-10",
  "justificativa": "Estoque de lentes abaixo do mínimo",
  "motivoRequisicaoId": "...",
  "itens": [
    {
      "produtoId": "...",
      "quantidade": 50,
      "precoEstimado": 85.00,
      "fornecedorSugeridoId": "..."
    }
  ]
}
```

### Gerar requisição automática por estoque mínimo

```
POST /api/requisicoes-compra/gerar-automatica
```
