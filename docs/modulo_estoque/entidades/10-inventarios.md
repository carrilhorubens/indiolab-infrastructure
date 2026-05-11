# Operação: Inventários Físicos

## Objetivo

Realizar contagens físicas do estoque, comparar com os saldos do sistema e gerar ajustes automáticos para as divergências encontradas. O inventário segue um workflow de 5 estados com aprovação obrigatória.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/inventarios-fisicos/proximo-numero` | Próximo número disponível |
| `GET` | `/api/inventarios-fisicos` | Listar inventários (paginado) |
| `GET` | `/api/inventarios-fisicos/{id}` | Detalhes com todos os itens |
| `POST` | `/api/inventarios-fisicos` | Criar novo inventário |
| `PATCH` | `/api/inventarios-fisicos/{id}/iniciar` | Aberto → Em Andamento |
| `PATCH` | `/api/inventarios-fisicos/{id}/finalizar` | Em Andamento → Pendente Aprovação |
| `PATCH` | `/api/inventarios-fisicos/{id}/aprovar` | Pendente Aprovação → Fechado |
| `PATCH` | `/api/inventarios-fisicos/{id}/cancelar` | Cancelar inventário |
| `PUT` | `/api/inventarios-fisicos/{id}/itens/{itemId}/contagem` | Registrar contagem de item |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Inventarios.View / .Create / .Edit`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca em Nome do Depósito, Número, Tipo |
| `status` | string? | Filtro por status (ex: "EmAndamento") |

---

## Campos do Inventário

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `numero` | int | Auto | Número sequencial |
| `depositoId` | Guid | Sim | FK para o depósito a inventariar |
| `tipo` | string | Sim | Tipo do inventário (ex: "Completo", "Parcial", "Cíclico") |
| `dataAbertura` | DateTime | Auto | Data/hora de criação |
| `dataFechamento` | DateTime? | Auto | Preenchido ao aprovar |
| `responsavelId` | Guid | Auto | ID do usuário que criou |
| `status` | string | Auto | Status do inventário (padrão: "Aberto") |
| `observacao` | string? | Não | Observações |

### Itens do Inventário

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid | FK para o produto |
| `localizacaoId` | Guid? | FK para a localização |
| `loteId` | Guid? | FK para o lote |
| `quantidadeSistema` | decimal | Snapshot do saldo no momento da criação |
| `quantidadeContada` | decimal | Quantidade informada pelo operador |
| `custoUnitario` | decimal | Snapshot do custo médio |
| `status` | string | "Pendente", "Contado", "Aprovado" ou "Rejeitado" |
| `justificativa` | string? | Justificativa para divergência |
| `divergencia` | decimal | Calculado: `quantidadeContada - quantidadeSistema` |
| `valorDivergencia` | decimal | Calculado: `divergencia × custoUnitario` |

---

## Workflow de Status

```
Aberto → [iniciar] → Em Andamento → [finalizar] → Pendente Aprovação → [aprovar] → Fechado
   ↓                       ↓                              ↓
 [cancelar]            [cancelar]                     [cancelar]
   ↓                       ↓                              ↓
Cancelado              Cancelado                      Cancelado
```

**Restrição:** Não é possível cancelar inventários com status "Fechado" ou "Cancelado".

---

## Regras de Negócio

1. **Auto-população de itens** — Ao criar o inventário, o sistema busca todos os registros de `EstoqueSaldo` do depósito selecionado com `QuantidadeDisponivel > 0` e cria um item para cada, com snapshot de `QuantidadeSistema` e `CustoMedio`.

2. **Registrar contagem** — Só é permitido quando o inventário está "Em Andamento". O item deve pertencer ao inventário informado.

3. **Finalizar exige contagem completa** — Todos os itens devem estar contados (`status != "Pendente"`). Caso contrário, retorna erro com o número de itens pendentes.

4. **Aprovação gera movimentações** — Para cada item com divergência:
   - **Divergência positiva (ganho):** Cria movimentação de Entrada e aplica `saldo.AplicarEntrada(abs(divergencia), custoUnitario)`.
   - **Divergência negativa (perda):** Cria movimentação de Saída e aplica `saldo.AplicarSaida(abs(divergencia))`.
   - **Divergência zero:** Aprova o item sem gerar movimentação.
   - Busca `TipoMovimentacaoEstoque` por "entrada"/"saída" e `MotivoAjuste` por "inventário".

5. **Data de fechamento** — Preenchida automaticamente ao aprovar.

6. **Responsável** — Atribuído automaticamente como o usuário do JWT na criação.

7. **Ordenação padrão** — Listagem ordenada por Data de Abertura (mais recente primeiro), depois por Número.

---

## Exemplos de Uso

### Criar inventário

```json
POST /api/inventarios-fisicos
{
  "depositoId": "...",
  "tipo": "Completo",
  "observacao": "Inventário mensal de março/2026"
}
```

### Registrar contagem de item

```json
PUT /api/inventarios-fisicos/{id}/itens/{itemId}/contagem
{
  "quantidadeContada": 48,
  "justificativa": "2 unidades danificadas encontradas"
}
```

### Aprovar inventário (gera ajustes automáticos)

```
PATCH /api/inventarios-fisicos/{id}/aprovar
```
