# Relatório: Performance de Fornecedores

## Objetivo

Consolidar as avaliações de fornecedores, apresentando pontuação média, classificação e notas por critério para cada fornecedor avaliado.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-compras/performance-fornecedores` | Performance consolidada |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.Avaliacoes.View`

---

## Parâmetros

Nenhum parâmetro obrigatório.

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `fornecedorId` | Guid | ID do fornecedor |
| `fornecedorNome` | string | Nome do fornecedor |
| `totalAvaliacoes` | int | Quantidade de avaliações |
| `pontuacaoMedia` | decimal | Pontuação média geral |
| `classificacao` | string | Classificação (A/B/C/D/F) |
| `notaQualidade` | decimal | Média da nota de qualidade |
| `notaEntrega` | decimal | Média da nota de entrega |
| `notaPreco` | decimal | Média da nota de preço |
| `notaServico` | decimal | Média da nota de serviço |
| `notaComunicacao` | decimal | Média da nota de comunicação |
| `ultimaAvaliacao` | DateTime? | Data da última avaliação |

---

## Regras

- Consolida todas as avaliações de cada fornecedor
- Notas por critério: média de todas as avaliações para cada critério específico
- Classificação baseada na pontuação média: A (>=90), B (>=75), C (>=60), D (>=40), F (<40)
- Ordenado por pontuação média (maior primeiro)
