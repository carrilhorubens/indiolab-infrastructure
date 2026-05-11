# Cadastro: Avaliações de Fornecedor

## Objetivo

Avaliar o desempenho dos fornecedores por meio de um scorecard ponderado com múltiplos critérios, gerando classificação automática (A/B/C/D/F) para apoiar decisões de compra e gestão de fornecedores.

---

## Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/avaliacoes-fornecedor` | Listar avaliações (paginado) |
| `GET` | `/api/avaliacoes-fornecedor/{id}` | Detalhes de uma avaliação |
| `GET` | `/api/avaliacoes-fornecedor/por-fornecedor/{fornecedorId}` | Avaliações de um fornecedor |
| `POST` | `/api/avaliacoes-fornecedor` | Criar nova avaliação |
| `PUT` | `/api/avaliacoes-fornecedor/{id}` | Atualizar avaliação |
| `DELETE` | `/api/avaliacoes-fornecedor/{id}` | Excluir avaliação (soft delete) |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Avaliacoes.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `classificacao` | string? | Filtro por classificação (A, B, C, D ou F) |

---

## Campos da Avaliação

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `fornecedorId` | Guid | Sim | FK para o fornecedor avaliado |
| `dataAvaliacao` | DateTime | Sim | Data da avaliação |
| `periodoInicio` | DateTime | Sim | Início do período avaliado |
| `periodoFim` | DateTime | Sim | Fim do período avaliado |
| `avaliadorId` | Guid | Auto | ID do avaliador (JWT) |
| `pontuacaoTotal` | decimal | Auto | Pontuação calculada (média ponderada) |
| `classificacao` | string | Auto | Classificação calculada (A/B/C/D/F) |
| `observacoes` | string? | Não | Observações gerais |

### Critérios de Avaliação

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `criterio` | string | Sim | Nome do critério (ex: "Qualidade", "Entrega") |
| `peso` | decimal | Sim | Peso relativo do critério |
| `nota` | decimal | Sim | Nota atribuída (0 a 100) |
| `justificativa` | string? | Não | Justificativa da nota |

---

## Classificação Automática

A pontuação total é calculada como **média ponderada** dos critérios:

```
PontuacaoTotal = Σ(Peso × Nota) / Σ(Peso)
```

| Faixa | Classificação | Descrição |
|-------|---------------|-----------|
| >= 90 | **A** | Excelente |
| >= 75 | **B** | Bom |
| >= 60 | **C** | Regular |
| >= 40 | **D** | Insatisfatório |
| < 40 | **F** | Crítico |

---

## Regras de Negócio

1. **Avaliador automático** — Atribuído a partir do JWT na criação.

2. **Múltiplos critérios** — Cada avaliação pode ter vários critérios com pesos diferentes. Critérios típicos: Qualidade, Entrega, Preço, Serviço, Comunicação.

3. **Pontuação calculada** — A `pontuacaoTotal` e `classificacao` são recalculadas automaticamente a cada criação/edição.

4. **Período obrigatório** — Define o intervalo de tempo sendo avaliado.

5. **Histórico por fornecedor** — O endpoint `por-fornecedor` permite acompanhar a evolução das avaliações ao longo do tempo.

6. **Resolução de nomes** — Fornecedor e avaliador são resolvidos via joins.

---

## Exemplos de Uso

### Criar avaliação

```json
POST /api/avaliacoes-fornecedor
{
  "fornecedorId": "...",
  "dataAvaliacao": "2026-03-01",
  "periodoInicio": "2026-01-01",
  "periodoFim": "2026-03-31",
  "observacoes": "Avaliação trimestral Q1/2026",
  "criterios": [
    { "criterio": "Qualidade", "peso": 30, "nota": 85, "justificativa": "Poucos defeitos" },
    { "criterio": "Entrega", "peso": 25, "nota": 70, "justificativa": "2 atrasos no período" },
    { "criterio": "Preço", "peso": 25, "nota": 90, "justificativa": "Competitivo" },
    { "criterio": "Serviço", "peso": 10, "nota": 80 },
    { "criterio": "Comunicação", "peso": 10, "nota": 95 }
  ]
}
```

### Listar avaliações por classificação

```
GET /api/avaliacoes-fornecedor?classificacao=A
```
