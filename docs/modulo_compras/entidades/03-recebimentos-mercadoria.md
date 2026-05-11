# Operação: Recebimentos de Mercadoria

## Objetivo

Registrar o recebimento físico de mercadorias vinculadas a ordens de compra, com conferência de quantidades, dados de nota fiscal e integração automática com o estoque ao confirmar.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/recebimentos-mercadoria/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/recebimentos-mercadoria` | Listar recebimentos (paginado) |
| `GET` | `/api/recebimentos-mercadoria/{id}` | Detalhes de um recebimento |
| `POST` | `/api/recebimentos-mercadoria` | Criar novo recebimento |
| `PUT` | `/api/recebimentos-mercadoria/{id}` | Atualizar recebimento |
| `DELETE` | `/api/recebimentos-mercadoria/{id}` | Excluir recebimento (soft delete) |
| `PATCH` | `/api/recebimentos-mercadoria/{id}/conferir` | Rascunho → Conferido |
| `PATCH` | `/api/recebimentos-mercadoria/{id}/confirmar` | Conferido → Confirmado |
| `PATCH` | `/api/recebimentos-mercadoria/{id}/cancelar` | Cancelar recebimento |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Recebimentos.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `status` | string? | Filtro por status |
| `ordemCompraId` | Guid? | Filtro por ordem de compra |

---

## Campos do Recebimento

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `ordemCompraId` | Guid | Sim | FK para a ordem de compra |
| `dataRecebimento` | DateTime | Sim | Data do recebimento |
| `depositoId` | Guid? | Não | FK para o depósito de destino |
| `responsavelId` | Guid | Auto | ID do usuário que criou (JWT) |
| `tipoConferencia` | string | Auto | Tipo de conferência (padrão: "Normal") |
| `status` | string | Auto | Status (padrão: "Rascunho") |
| `observacoes` | string? | Não | Observações |

### Dados da Nota Fiscal

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `notaFiscalNumero` | string? | Não | Número da NF |
| `notaFiscalChave` | string? | Não | Chave de acesso da NF-e |
| `notaFiscalSerie` | string? | Não | Série da NF |
| `notaFiscalDataEmissao` | DateTime? | Não | Data de emissão da NF |
| `valorTotalNF` | decimal | Auto | Valor total da nota fiscal |

### Itens do Recebimento

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `sequencia` | int | Auto | Sequência do item |
| `ordemCompraItemId` | Guid? | Não | FK para o item da OC |
| `produtoId` | Guid | Sim | FK para o produto |
| `quantidadeEsperada` | decimal | Sim | Quantidade esperada (da OC) |
| `quantidadeRecebida` | decimal | Sim | Quantidade efetivamente recebida |
| `quantidadeAceita` | decimal | Auto | Quantidade aceita na conferência |
| `quantidadeRejeitada` | decimal | Auto | Quantidade rejeitada |
| `precoUnitario` | decimal | Sim | Preço unitário |
| `valorTotal` | decimal | Auto | Calculado: `quantidadeRecebida × precoUnitario` |
| `loteId` | Guid? | Não | FK para lote |
| `localizacaoId` | Guid? | Não | FK para localização |
| `unidadeMedidaId` | Guid? | Não | FK para unidade de medida |
| `numeroSerieId` | Guid? | Não | FK para número de série |
| `dataValidade` | DateTime? | Não | Data de validade do item |
| `cfop` | string? | Não | CFOP do item |
| `motivoRejeicao` | string? | Não | Motivo da rejeição |

---

## Workflow de Status

```
Rascunho → [conferir] → Conferido → [confirmar] → Confirmado
                                          ↓
Qualquer status → [cancelar] → Cancelado
```

---

## Regras de Negócio

1. **Vínculo com ordem de compra** — Todo recebimento deve estar vinculado a uma ordem de compra existente.

2. **Responsável automático** — Atribuído a partir do JWT na criação.

3. **Conferência de quantidades** — A conferência compara `quantidadeEsperada` vs `quantidadeRecebida`, permitindo registrar aceitas e rejeitadas.

4. **Confirmação gera movimentação de estoque** — Ao confirmar, o sistema cria movimentações de entrada no estoque para cada item aceito, atualizando saldos e custo médio ponderado.

5. **Atualização da OC** — A confirmação atualiza as quantidades recebidas nos itens da ordem de compra e pode alterar o status da OC para "ParcialmenteRecebida" ou "Recebida".

6. **Dados fiscais** — Número, chave, série e data da nota fiscal são registrados para rastreabilidade fiscal.

---

## Exemplos de Uso

### Criar recebimento

```json
POST /api/recebimentos-mercadoria
{
  "ordemCompraId": "...",
  "dataRecebimento": "2026-03-15T10:00:00",
  "depositoId": "...",
  "notaFiscalNumero": "12345",
  "notaFiscalChave": "35260201234567000100550010000123451234567890",
  "itens": [
    {
      "produtoId": "...",
      "quantidadeEsperada": 100,
      "quantidadeRecebida": 98,
      "precoUnitario": 25.50,
      "ordemCompraItemId": "..."
    }
  ]
}
```

### Confirmar recebimento (gera entrada no estoque)

```
PATCH /api/recebimentos-mercadoria/{id}/confirmar
```
