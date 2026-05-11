# Consulta: Posição de Estoque (Saldos)

## Objetivo

Consultar a posição atual de estoque, exibindo os saldos disponíveis, reservados e bloqueados por produto, depósito e localização, com o custo médio ponderado atualizado.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/posicao-estoque` | Listar posição de estoque (paginado) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.Posicoes.View`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca por Nome do Produto |
| `produtoId` | Guid? | Filtro por produto específico |
| `depositoId` | Guid? | Filtro por depósito específico |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | Guid | ID do registro de saldo |
| `produtoId` | Guid | ID do produto |
| `produtoNome` | string? | Nome do produto |
| `produtoCodigo` | int? | Código do produto |
| `depositoId` | Guid | ID do depósito |
| `depositoNome` | string? | Nome do depósito |
| `localizacaoId` | Guid? | ID da localização (pode ser nulo) |
| `localizacaoNome` | string? | Código da localização |
| `loteId` | Guid? | ID do lote associado |
| `loteNumero` | string? | Número do lote |
| `quantidadeDisponivel` | decimal | Quantidade disponível para uso |
| `quantidadeReservada` | decimal | Quantidade reservada (comprometida) |
| `quantidadeBloqueada` | decimal | Quantidade bloqueada (indisponível) |
| `custoMedio` | decimal | Custo médio ponderado |
| `ultimaAtualizacao` | DateTime | Data/hora da última movimentação |

---

## Regras de Negócio

1. **Projeção materializada** — Os saldos são atualizados automaticamente a cada movimentação de estoque. Não são calculados sob demanda.

2. **Unicidade** — Existe um registro de saldo por combinação de (Produto, Depósito, Localização). Localização pode ser nula.

3. **Custo médio ponderado** — O custo médio é recalculado a cada entrada: `(qtd_antiga × custo_antigo + qtd_nova × custo_novo) / qtd_total`.

4. **Quantidade disponível** — Representa o saldo livre para movimentação. Reservas e bloqueios reduzem a disponibilidade efetiva.

5. **Somente leitura** — A posição de estoque não pode ser alterada diretamente. Todas as alterações ocorrem via movimentações ou operações (reservas, inventários).

6. **Ordenação padrão** — Listagem ordenada por Nome do Produto (A→Z), depois por Nome do Depósito.

---

## Exemplos de Uso

### Consultar posição geral

```
GET /api/posicao-estoque?page=1&pageSize=50
```

### Consultar por produto específico

```
GET /api/posicao-estoque?produtoId=abc123
```

### Consultar por depósito

```
GET /api/posicao-estoque?depositoId=def456&search=lente
```
