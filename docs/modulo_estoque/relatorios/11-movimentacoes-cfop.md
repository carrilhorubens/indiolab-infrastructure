# Relatório: Movimentações por CFOP

## Objetivo

Agrupar as movimentações de estoque por **CFOP (Código Fiscal de Operações e Prestações)**, totalizando quantidades e valores por código fiscal em um período. Essencial para conferência fiscal e apuração de impostos.

---

## Endpoint

```
GET /api/relatorios/estoque/movimentacoes-cfop?dataInicio=2025-01-01&dataFim=2026-01-01
```

**Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `dataInicio` | DateTime | Sim | Data inicial do período |
| `dataFim` | DateTime | Sim | Data final do período |

---

## Campos Retornados

### Resultado Global

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `items` | array | Lista agrupada por CFOP |
| `totalMovimentacoes` | int | Total de movimentações no período |
| `valorTotal` | decimal | Valor total de todas as movimentações |

### Cada Item

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `cfop` | string | Código CFOP (ex: 5102) |
| `descricaoCfop` | string | Descrição do CFOP (ex: "Venda de mercadoria") |
| `quantidade` | decimal | Quantidade total movimentada |
| `quantidadeMovimentacoes` | int | Número de movimentações |
| `valorTotal` | decimal | Valor total (soma de CustoTotal) |

---

## CFOPs Reconhecidos

O sistema possui um dicionário interno com as descrições dos CFOPs mais comuns no segmento óptico:

| CFOP | Descrição |
|------|-----------|
| 1102 | Compra para comercialização |
| 1202 | Devolução de venda de mercadoria |
| 1403 | Compra para comercialização em operação com ST |
| 1556 | Compra para ativo imobilizado |
| 2102 | Compra para comercialização (interestadual) |
| 5102 | Venda de mercadoria |
| 5202 | Devolução de compra para comercialização |
| 5403 | Venda com ST |
| 5405 | Venda de mercadoria adquirida com ST |
| 5910 | Remessa em bonificação |
| 5911 | Remessa de amostra grátis |
| 5917 | Remessa de mercadoria em consignação |
| 5918 | Devolução de mercadoria recebida em consignação |
| 5949 | Outra saída não especificada |
| 6102 | Venda de mercadoria (interestadual) |
| 6403 | Venda com ST (interestadual) |

> CFOPs não listados recebem a descrição genérica "CFOP {código}".

---

## Regras de Negócio

1. **Filtro:** Movimentações no período com status diferente de "Cancelada" e CFOP preenchido
2. **Agrupamento:** Por `Cfop` — soma quantidade e valor, conta registros
3. **Ordenação:** Por código CFOP crescente
4. **Movimentações sem CFOP:** Excluídas (ajustes internos, transferências sem nota)

---

## Como Interpretar

- **CFOP 1xxx:** Entradas (compras, devoluções recebidas) — operações estaduais
- **CFOP 2xxx:** Entradas — operações interestaduais
- **CFOP 5xxx:** Saídas (vendas, devoluções enviadas) — operações estaduais
- **CFOP 6xxx:** Saídas — operações interestaduais
- **Valor total:** Deve ser compatível com os livros fiscais de entrada e saída

---

## Exemplo de Uso

**Cenário:** Contador precisa conferir os valores de entrada e saída por CFOP para apuração de ICMS.

1. Acesse: **Estoque > Relatórios > Movimentações por CFOP**
2. Defina o período do mês fiscal
3. Compare CFOPs de entrada (1xxx, 2xxx) com os livros fiscais
4. Compare CFOPs de saída (5xxx, 6xxx) com as NF-e emitidas
5. Identifique divergências entre estoque e fiscal

---

## Fonte de Dados

- `MovimentacaoEstoque` — movimentações com CFOP preenchido
- Dicionário interno — descrições dos CFOPs mais comuns
