# Operação: Cotações (RFQ)

## Objetivo

Gerenciar o processo de cotação de preços (Request for Quotation), enviando solicitações a múltiplos fornecedores, recebendo propostas, comparando condições e selecionando o vencedor para geração de ordem de compra.

---

## Endpoints

### Cotação

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/cotacoes/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/cotacoes` | Listar cotações (paginado) |
| `GET` | `/api/cotacoes/{id}` | Detalhes com fornecedores e itens |
| `POST` | `/api/cotacoes` | Criar nova cotação |
| `PUT` | `/api/cotacoes/{id}` | Atualizar cotação |
| `DELETE` | `/api/cotacoes/{id}` | Excluir cotação (soft delete) |
| `PATCH` | `/api/cotacoes/{id}/enviar` | Rascunho → Enviada |
| `PATCH` | `/api/cotacoes/{id}/iniciar-analise` | Enviada → Em Análise |
| `PATCH` | `/api/cotacoes/{id}/finalizar` | Em Análise → Finalizada |
| `PATCH` | `/api/cotacoes/{id}/cancelar` | Cancelar cotação |

### Fornecedores Participantes

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/api/cotacoes/{id}/fornecedores` | Adicionar fornecedor participante |
| `PUT` | `/api/cotacoes/fornecedores/{cotacaoFornecedorId}/resposta` | Registrar proposta do fornecedor |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Cotacoes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |

---

## Campos da Cotação

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `requisicaoCompraId` | Guid? | Não | FK para requisição de origem |
| `dataEmissao` | DateTime | Sim | Data de emissão |
| `dataLimiteResposta` | DateTime? | Não | Data limite para respostas |
| `criterioAvaliacao` | string? | Não | Critério de avaliação (ex: "Menor Preço", "Melhor Qualidade") |
| `responsavelId` | Guid | Auto | ID do responsável (JWT) |
| `vencedorFornecedorId` | Guid? | Auto | FK para o fornecedor vencedor |
| `ordemCompraId` | Guid? | Auto | FK para OC gerada |
| `status` | string | Auto | Status (padrão: "Rascunho") |
| `observacoes` | string? | Não | Observações |

### Fornecedor Participante

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `fornecedorId` | Guid | FK para o fornecedor |
| `dataResposta` | DateTime? | Data da resposta |
| `condicaoPagamentoId` | Guid? | FK para condição de pagamento |
| `modalidadeFreteId` | Guid? | FK para modalidade de frete |
| `prazoEntregaDias` | int? | Prazo de entrega em dias |
| `validadeProposta` | DateTime? | Validade da proposta |
| `valorTotal` | decimal | Valor total da proposta |
| `valorFrete` | decimal | Valor do frete |
| `pontuacao` | decimal? | Pontuação calculada |
| `selecionado` | bool | Indica se foi o vencedor |

### Itens do Fornecedor

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | FK para o produto |
| `quantidade` | decimal | Quantidade cotada |
| `precoUnitario` | decimal | Preço unitário proposto |
| `descontoPct` | decimal | Percentual de desconto |
| `prazoEntregaDias` | int? | Prazo de entrega do item |

---

## Workflow de Status

```
Rascunho → [enviar] → Enviada → [iniciar-analise] → EmAnalise → [finalizar] → Finalizada
                                                                       ↓
Qualquer status → [cancelar] → Cancelada
```

---

## Regras de Negócio

1. **Múltiplos fornecedores** — Uma cotação pode ter vários fornecedores participantes, cada um com sua proposta independente.

2. **Resposta por fornecedor** — Cada fornecedor registra sua proposta com preços, condições e prazo. Itens são detalhados individualmente.

3. **Finalização com vencedor** — Ao finalizar, o `vencedorFornecedorId` é obrigatório. O fornecedor selecionado é marcado com `selecionado = true`.

4. **Vínculo com requisição** — Uma cotação pode ser originada de uma requisição de compra aprovada.

5. **Geração de OC** — Após finalizada, a cotação pode gerar uma ordem de compra automaticamente (via `ordemCompraId`).

6. **Responsável automático** — Atribuído a partir do JWT na criação.

---

## Exemplos de Uso

### Criar cotação

```json
POST /api/cotacoes
{
  "requisicaoCompraId": "...",
  "dataEmissao": "2026-03-01",
  "dataLimiteResposta": "2026-03-10",
  "criterioAvaliacao": "Menor Preço"
}
```

### Adicionar fornecedor participante

```json
POST /api/cotacoes/{id}/fornecedores
{
  "fornecedorId": "...",
  "observacoes": "Fornecedor preferencial"
}
```

### Registrar proposta do fornecedor

```json
PUT /api/cotacoes/fornecedores/{cotacaoFornecedorId}/resposta
{
  "dataResposta": "2026-03-08",
  "condicaoPagamentoId": "...",
  "prazoEntregaDias": 7,
  "valorFrete": 100.00,
  "itens": [
    {
      "produtoId": "...",
      "quantidade": 100,
      "precoUnitario": 22.00,
      "descontoPct": 3
    }
  ]
}
```

### Finalizar cotação (selecionar vencedor)

```json
PATCH /api/cotacoes/{id}/finalizar
{
  "vencedorFornecedorId": "..."
}
```
