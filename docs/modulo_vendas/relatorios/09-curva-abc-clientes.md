# Relatório: Curva ABC de Clientes

## Objetivo

Classificar os clientes em categorias A, B e C com base na receita gerada no período, seguindo o princípio de Pareto (80/20), para identificar os clientes mais estratégicos.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/relatorios-vendas/curva-abc-clientes` | Curva ABC de clientes |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.PedidosVenda.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Items

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clienteId` | Guid | ID do cliente |
| `clienteNome` | string? | Nome do cliente |
| `receitaTotal` | decimal | Receita total do cliente no período |
| `percentualDoTotal` | decimal | % individual da receita geral |
| `percentualAcumulado` | decimal | % acumulado (para curva ABC) |
| `classeAbc` | string | Classificação: A, B ou C |

### Totalizadores

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalClientes` | int | Total de clientes analisados |
| `receitaTotal` | decimal | Receita total do período |
| `clientesA` | int | Quantidade de clientes classe A |
| `clientesB` | int | Quantidade de clientes classe B |
| `clientesC` | int | Quantidade de clientes classe C |

---

## Regras

- Clientes ordenados por `ReceitaTotal` descendente
- Classificação: **A** = percentual acumulado até 80%, **B** = 80–95%, **C** = 95–100%
- `PercentualAcumulado` é calculado somando sequencialmente os `PercentualDoTotal`
- Usado para estratégias de fidelização e alocação de recursos comerciais
