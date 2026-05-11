# Entidade: Metas de Venda

## Objetivo

Definir metas de vendas por vendedor ou região, com acompanhamento de progresso, desdobramento por produto/categoria e snapshots periódicos de atingimento.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/metas-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/metas-venda` | Lista paginada com filtros |
| `GET` | `/api/metas-venda/{id}` | Detalhes com desdobramentos |
| `POST` | `/api/metas-venda` | Cria meta |
| `PUT` | `/api/metas-venda/{id}` | Atualiza (somente Ativa) |
| `DELETE` | `/api/metas-venda/{id}` | Remove |
| `PATCH` | `/api/metas-venda/{id}/encerrar` | Ativa → Encerrada |
| `PATCH` | `/api/metas-venda/{id}/reabrir` | Encerrada → Ativa |
| `GET` | `/api/metas-venda/{id}/acompanhamentos` | Lista snapshots de progresso |
| `POST` | `/api/metas-venda/{id}/gerar-snapshot` | Gera snapshot instantâneo |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.MetasVenda.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `vendedorId` | Guid? | Cond | Meta individual por vendedor |
| `regiaoVendaId` | Guid? | Cond | Meta por região |
| `periodo` | string | Sim | Formato YYYY-MM |
| `tipoMeta` | string | Sim | Receita, Quantidade, MargemBruta, NovosClientes |
| `valorMeta` | decimal | Sim | Valor/quantidade a atingir |
| `valorRealizado` | decimal | Auto | Atualizado pelo serviço |
| `percentualAtingimento` | decimal | Calc | ValorRealizado / ValorMeta × 100 |
| `status` | string | Auto | Ativa, Encerrada |

### Detalhes (MetaVendaDetalhe)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `produtoId` | Guid? | Meta por produto específico |
| `categoriaProdutoId` | Guid? | Meta por categoria |
| `valorMeta` | decimal | Meta parcial |
| `valorRealizado` | decimal | Realizado parcial |

### Acompanhamentos (AcompanhamentoMeta) — Write-once

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `metaVendaId` | Guid | FK para meta |
| `dataSnapshot` | DateTime | Data do snapshot |
| `valorRealizado` | decimal | Realizado até a data |
| `percentualAtingimento` | decimal | % atingido |
| `tendenciaProjetada` | decimal | Projeção de fechamento |
| `criadoEm` | DateTime | Timestamp de criação |

---

## Workflow

```
Ativa ↔ Encerrada (pode reabrir)
```

---

## Regras

- Meta pode ser por vendedor OU por região (ou ambas)
- Somente metas `Ativas` podem ser editadas
- `TipoMeta` define a métrica: Receita (R$), Quantidade (unidades), MargemBruta (R$), NovosClientes (count)
- Detalhes permitem desdobrar a meta por produto ou categoria de produto
- Acompanhamentos são snapshots imutáveis (write-once) gerados manual ou automaticamente
- `TendenciaProjetada` calcula a projeção linear até o fim do período
