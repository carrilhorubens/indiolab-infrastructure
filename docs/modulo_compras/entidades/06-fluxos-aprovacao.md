# Cadastro: Fluxos de Aprovação

## Objetivo

Configurar workflows de aprovação por alçada de valor para documentos do módulo de compras (requisições, ordens de compra). Cada fluxo define níveis sequenciais com aprovadores e faixas de valor, e mantém histórico completo das decisões.

---

## Endpoints

### Fluxos

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/fluxos-aprovacao/proximo-codigo` | Próximo código disponível |
| `GET` | `/api/fluxos-aprovacao` | Listar fluxos (paginado) |
| `GET` | `/api/fluxos-aprovacao/{id}` | Detalhes de um fluxo com níveis |
| `POST` | `/api/fluxos-aprovacao` | Criar novo fluxo |
| `PUT` | `/api/fluxos-aprovacao/{id}` | Atualizar fluxo |
| `DELETE` | `/api/fluxos-aprovacao/{id}` | Excluir fluxo (soft delete) |

### Histórico de Aprovações

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/fluxos-aprovacao/historico/todos` | Listar todo o histórico (paginado) |
| `GET` | `/api/fluxos-aprovacao/historico` | Histórico de um documento específico |
| `GET` | `/api/fluxos-aprovacao/historico/{id}` | Detalhes de um registro de aprovação |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Compras.FluxosAprovacao.View / .Create / .Edit / .Delete`

---

## Parâmetros de Listagem

### Fluxos

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `search` | string? | Busca textual |
| `tipoDocumento` | string? | Filtro por tipo de documento |

### Histórico (todos)

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |
| `documentoTipo` | string? | Filtro por tipo de documento |
| `status` | string? | Filtro por status |

### Histórico (por documento)

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `documentoId` | Guid | ID do documento |
| `documentoTipo` | string | Tipo do documento |
| `page` | int | Página (padrão: 1) |
| `pageSize` | int | Itens por página (padrão: 20) |

---

## Campos do Fluxo

### Cabeçalho

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `codigo` | int | Auto | Código sequencial (8 dígitos, zero-padded) |
| `nome` | string | Sim | Nome do fluxo |
| `tipoDocumento` | string | Sim | Tipo de documento (ex: "RequisicaoCompra", "OrdemCompra") |
| `descricao` | string? | Não | Descrição do fluxo |
| `responsavelId` | Guid | Auto | ID do criador (JWT) |

### Níveis de Aprovação

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------|
| `ordem` | int | Sim | Sequência do nível (1, 2, 3...) |
| `nome` | string | Sim | Nome do nível (ex: "Gerente", "Diretor") |
| `valorMinimo` | decimal | Sim | Valor mínimo da alçada |
| `valorMaximo` | decimal | Sim | Valor máximo da alçada |
| `aprovadorId` | Guid? | Não | FK para usuário aprovador |
| `aprovadorRole` | string? | Não | Role alternativa para aprovação |
| `prazoDias` | int | Sim | Prazo em dias para resposta |

### Histórico de Aprovação

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `codigo` | int | Código sequencial |
| `documentoId` | Guid | ID do documento avaliado |
| `documentoTipo` | string | Tipo do documento |
| `fluxoAprovacaoId` | Guid? | FK para o fluxo utilizado |
| `nivelAprovacaoId` | Guid? | FK para o nível avaliado |
| `dataSolicitacao` | DateTime | Data da solicitação |
| `aprovadorId` | Guid? | ID do aprovador |
| `status` | string | Status da decisão |
| `dataResposta` | DateTime? | Data da resposta |
| `comentario` | string? | Comentário do aprovador |
| `valorDocumento` | decimal? | Valor do documento no momento |
| `versao` | int | Versão do registro |

---

## Regras de Negócio

1. **Níveis ordenados** — Os níveis são processados em sequência pela `ordem`. Cada nível cobre uma faixa de valor (`valorMinimo` a `valorMaximo`).

2. **Aprovador por usuário ou role** — Cada nível pode ter um aprovador específico (`aprovadorId`) ou uma role genérica (`aprovadorRole`).

3. **Prazo de resposta** — Cada nível define um prazo em dias para a decisão. Documentos sem resposta dentro do prazo podem ser escalados.

4. **Histórico imutável** — Os registros de aprovação são write-once (append-only). Uma vez criados, não podem ser editados.

5. **Tipo de documento** — Define para qual tipo de documento o fluxo se aplica (ex: "RequisicaoCompra", "OrdemCompra").

---

## Exemplos de Uso

### Criar fluxo de aprovação

```json
POST /api/fluxos-aprovacao
{
  "nome": "Aprovação de Compras",
  "tipoDocumento": "OrdemCompra",
  "descricao": "Fluxo padrão para ordens de compra",
  "niveis": [
    {
      "ordem": 1,
      "nome": "Supervisor",
      "valorMinimo": 0,
      "valorMaximo": 5000,
      "aprovadorRole": "Supervisor",
      "prazoDias": 2
    },
    {
      "ordem": 2,
      "nome": "Gerente",
      "valorMinimo": 5000.01,
      "valorMaximo": 50000,
      "aprovadorId": "...",
      "prazoDias": 3
    }
  ]
}
```

### Consultar histórico de um documento

```
GET /api/fluxos-aprovacao/historico?documentoId=...&documentoTipo=OrdemCompra
```
