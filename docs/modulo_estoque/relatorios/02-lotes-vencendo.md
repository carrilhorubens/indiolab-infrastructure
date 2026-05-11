# Relatório: Lotes Vencendo

## Objetivo

Listar lotes de produtos cuja **data de validade está próxima de expirar**, permitindo ações preventivas como promoções, devoluções ou descarte antes do vencimento.

---

## Endpoint

```
GET /api/relatorios/estoque/lotes-vencendo?dias=30
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Default | Descrição |
|-----------|------|-------------|---------|-----------|
| `dias` | int | Não | 30 | Quantidade de dias no futuro para considerar como "vencendo" |

---

## Campos Retornados

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `loteId` | UUID | Identificador do lote |
| `loteCodigo` | int | Código numérico do lote |
| `numeroLote` | string | Número de identificação do lote (ex: LOT-20260001) |
| `produtoId` | UUID | Identificador do produto |
| `produtoCodigo` | int? | Código do produto |
| `produtoNome` | string? | Nome do produto |
| `dataValidade` | DateTime | Data de validade do lote |
| `diasRestantes` | int | Dias restantes até o vencimento (negativo = já vencido) |
| `fornecedorNome` | string? | Nome do fornecedor que enviou o lote |

---

## Regras de Negócio

1. **Filtro:** Lotes com `DataValidade <= hoje + dias` que estejam ativos e não esgotados
2. **Ordenação:** Por data de validade crescente (mais urgentes primeiro)
3. **Lotes sem validade:** Ignorados (não aparecem no relatório)
4. **Lotes esgotados:** Excluídos (status "Esgotado" é filtrado)
5. **Dias negativos:** Lote já vencido — requer ação imediata

---

## Como Interpretar

- **Dias restantes negativos (vermelho):** Lote **já venceu** — verificar se pode ser devolvido ou se precisa de descarte
- **Dias restantes 0-7 (laranja):** Vencimento iminente — priorizar venda ou promoção
- **Dias restantes 8-30 (amarelo):** Atenção — planejar ação
- **Fornecedor:** Útil para negociar devoluções ou trocas com o fornecedor de origem

---

## Exemplo de Uso

**Cenário:** Ótica precisa verificar lentes de contato (validade curta) que vencem nos próximos 60 dias.

1. Acesse: **Estoque > Relatórios > Lotes Vencendo**
2. Informe "60" no campo de dias e clique em **Buscar**
3. Identifique lotes com menos de 7 dias — entre em contato com o fornecedor para devolução
4. Lotes com 8-30 dias — crie promoções para acelerar a venda

---

## Fonte de Dados

- `Lote` — número, data de validade, status
- `Produto` — nome e código do produto
- `Fornecedor` → `Pessoa` — nome do fornecedor
