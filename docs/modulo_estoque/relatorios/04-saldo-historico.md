# Relatório: Saldo Histórico

## Objetivo

Consultar **snapshots históricos** do saldo de estoque em datas passadas, permitindo análise de tendências, comparação entre períodos e auditoria de estoques anteriores.

---

## Endpoints

### Listar snapshots (com paginação e filtros)

```
GET /api/estoque-saldo-historico
```

**Parâmetros de query:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `page` | int | Não (default: 1) | Página da paginação |
| `pageSize` | int | Não (default: 20) | Itens por página |
| `dataInicio` | DateTime | Não | Data inicial do período |
| `dataFim` | DateTime | Não | Data final do período |
| `produtoId` | UUID | Não | Filtrar por produto |

**Exemplo:** `GET /api/estoque-saldo-historico?page=1&pageSize=20&dataInicio=2025-11-01&dataFim=2026-02-01`

### Gerar snapshot atual

```
POST /api/estoque-saldo-historico/gerar-snapshot
```

Gera um snapshot do saldo de estoque na data/hora atual. Retorna `{ "count": N }` com a quantidade de registros gerados.

---

## Resposta (listagem)

A listagem é **paginada**. Corpo da resposta:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `items` | array | Lista de snapshots (ver tabela abaixo) |
| `totalCount` | int | Total de registros (sem paginação) |
| `page` | int | Página atual |
| `pageSize` | int | Tamanho da página |

**Campos de cada item em `items`:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador do registro |
| `dataSnapshot` | DateTime | Data do snapshot |
| `produtoId` | UUID | Identificador do produto |
| `produtoNome` | string | Nome do produto |
| `depositoId` | UUID | Identificador do depósito |
| `depositoNome` | string | Nome do depósito |
| `quantidade` | decimal | Quantidade em estoque na data |
| `custoUnitario` | decimal | Custo unitário na data |
| `valorTotal` | decimal | Valor total (quantidade × custo unitário) |

---

## Regras de Negócio

1. **Fonte:** Entidade `EstoqueSaldoHistorico` — registros imutáveis (write-once)
2. **Granularidade:** Um registro por produto × depósito × data de snapshot
3. **Geração:** Os snapshots são gerados periodicamente (diário/semanal/mensal conforme configuração)
4. **Sem soft delete:** Registros históricos nunca são excluídos
5. **Filtro por período:** Retorna apenas snapshots dentro do intervalo informado

---

## Como Interpretar

- **Tendência crescente:** Estoque acumulando — verificar se vendas estão acompanhando
- **Tendência decrescente:** Estoque diminuindo — pode indicar aumento de vendas ou falta de reposição
- **Picos e vales:** Sazonalidade — útil para planejar compras futuras
- **Comparação mês a mês:** Permite identificar sazonalidade e planejar reposições

---

## Exemplo de Uso

**Cenário:** Contador precisa do valor do estoque no último dia de cada mês para apuração contábil.

1. Acesse: **Estoque > Relatórios > Saldo Histórico**
2. Defina o período (trimestre ou semestre)
3. Visualize a evolução do saldo de cada produto ao longo do tempo
4. Exporte os dados para uso em planilhas contábeis

---

## Fonte de Dados

- `EstoqueSaldoHistorico` — snapshots periódicos
- `Produto` — nome do produto
- `Deposito` — nome do depósito
