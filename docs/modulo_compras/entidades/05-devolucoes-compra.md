# Operação: Devoluções de Compra

## Objetivo

Gerenciar o processo de devolução de mercadorias a fornecedores, com workflow de autorização, registro de envio e conclusão. A devolução pode ser vinculada a uma ordem de compra e/ou recebimento de mercadoria.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/devolucoes-compra/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/devolucoes-compra` | Listar devoluções (paginado) |
| `GET` | `/api/devolucoes-compra/{id}` | Detalhes de uma devolução |
| `POST` | `/api/devolucoes-compra` | Criar nova devolução |
| `PUT` | `/api/devolucoes-compra/{id}` | Atualizar devolução |
| `DELETE` | `/api/devolucoes-compra/{id}` | Excluir devolução (soft delete) |
| `PATCH` | `/api/devolucoes-compra/{id}/enviar-autorizacao` | Rascunho → Pendente Autorização |
| `PATCH` | `/api/devolucoes-compra/{id}/autorizar` | Pendente Autorização → Autorizada |
| `PATCH` | `/api/devolucoes-compra/{id}/registrar-envio` | Autorizada → Em Trânsito |
| `PATCH` | `/api/devolucoes-compra/{id}/concluir` | Em Trânsito → Concluída |
| `PATCH` | `/api/devolucoes-compra/{id}/cancelar` | Cancelar devolução |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Devolucoes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |

---

## Campos da Devolução

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `fornecedorId` | Guid | Sim | FK para o fornecedor |
| `dataDevolucao` | DateTime | Sim | Data da devolução |
| `ordemCompraId` | Guid? | Não | FK para ordem de compra de origem |
| `recebimentoMercadoriaId` | Guid? | Não | FK para recebimento de origem |
| `motivoDevolucaoId` | Guid? | Não | FK para motivo (domínio) |
| `depositoId` | Guid? | Não | FK para depósito de saída |
| `responsavelId` | Guid | Auto | ID do responsável (JWT) |
| `status` | string | Auto | Status (padrão: "Rascunho") |
| `valorTotal` | decimal | Auto | Soma dos valores dos itens |
| `observacoes` | string? | Não | Observações |

### Dados da Nota Fiscal de Devolução

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `notaFiscalDevolucaoNumero` | string? | Número da NF de devolução |
| `notaFiscalDevolucaoChave` | string? | Chave de acesso da NF-e de devolução |

### Itens da Devolução

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `produtoId` | Guid | Sim | FK para o produto |
| `quantidade` | decimal | Sim | Quantidade a devolver |
| `precoUnitario` | decimal | Sim | Preço unitário |
| `loteId` | Guid? | Não | FK para lote |
| `numeroSerieId` | Guid? | Não | FK para número de série |
| `motivoDetalhe` | string? | Não | Detalhe do motivo de devolução do item |
| `cfop` | string? | Não | CFOP da devolução |
| `observacoes` | string? | Não | Observações do item |

---

## Workflow de Status

```
Rascunho → [enviar-autorizacao] → PendenteAutorizacao → [autorizar] → Autorizada
                                                                          ↓
                                                              [registrar-envio] → EmTransito
                                                                                      ↓
                                                                              [concluir] → Concluida

Qualquer status → [cancelar] → Cancelada
```

---

## Regras de Negócio

1. **Responsável automático** — Atribuído a partir do JWT na criação.

2. **Vínculo opcional** — A devolução pode ser vinculada a uma ordem de compra e/ou recebimento, mas ambos são opcionais.

3. **Motivo de devolução** — Pode usar o domínio `MotivoDevolucao` no cabeçalho e/ou detalhe por item.

4. **Rastreabilidade** — Itens podem referenciar lote e número de série para rastreabilidade completa.

5. **Nota fiscal de devolução** — Número e chave da NF-e de devolução são registrados para integração fiscal.

6. **Valor total calculado** — Soma de `quantidade × precoUnitario` de todos os itens.

---

## Exemplos de Uso

### Criar devolução

```json
POST /api/devolucoes-compra
{
  "fornecedorId": "...",
  "dataDevolucao": "2026-03-05",
  "ordemCompraId": "...",
  "recebimentoMercadoriaId": "...",
  "motivoDevolucaoId": "...",
  "depositoId": "...",
  "itens": [
    {
      "produtoId": "...",
      "quantidade": 5,
      "precoUnitario": 25.50,
      "motivoDetalhe": "Produto com defeito de fabricação"
    }
  ]
}
```

### Autorizar devolução

```
PATCH /api/devolucoes-compra/{id}/autorizar
```
