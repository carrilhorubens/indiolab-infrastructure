# CCUST - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CCUST (Centros de Custo)
- **Total de Registros**: 433
- **Total de Colunas**: 13
- **Chave Primária**: CUSCODIGO
- **Chaves Estrangeiras**: 1 (TPCCODIGO → TPCUSTO)
- **Índices**: 0
- **Tabelas Dependentes**: 16 (altamente referenciada)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CCUST** é uma tabela mestre que armazena informações sobre centros de custo da organização. Com **433 registros**, representa os diferentes centros de custo utilizados para classificação contábil e análise gerencial.

Esta tabela funciona como **catálogo de centros de custo** e permite:
- Classificar transações financeiras por centro de custo
- Organizar despesas e receitas por departamento/projeto
- Gerar relatórios gerenciais por centro de custo
- Controlar orçamentos e previsões por centro
- Integrar com sistemas contábeis
- Rastrear custos de produção e operações

Cada registro representa um centro de custo específico, contendo:
- Código único do centro de custo (CUSCODIGO)
- Descrição do centro de custo (CUSDESCRICAO)
- Tipo de centro de custo (TPCCODIGO)
- Grau hierárquico (CUSGRAU)
- Configurações de impressão e diário auxiliar
- Contas contábeis de débito e crédito
- Código reduzido e código contábil
- Situação (ativo/inativo)

O sistema utiliza esta tabela para classificar todas as movimentações financeiras, permitindo análises detalhadas de custos e receitas por centro de responsabilidade.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CUSCODIGO** 🔑 | VARCHAR(14) | Código único do centro de custo (PK) |

### Dados do Centro de Custo
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CUSDESCRICAO** | VARCHAR(37) | Descrição/nome do centro de custo (obrigatório) |
| **CUSSITUACAO** | VARCHAR(14) | Situação do centro de custo (ativo/inativo) |

### Classificação e Hierarquia
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **TPCCODIGO** 🔗 | INTEGER | Tipo de centro de custo (FK → TPCUSTO) |
| **CUSGRAU** | VARCHAR(14) | Grau hierárquico do centro de custo |
| **CUSCODRED** | INTEGER | Código reduzido do centro de custo |

### Configurações Contábeis
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CUSIMPRIME** | VARCHAR(14) | Flag de impressão |
| **CUSDIARAUX** | VARCHAR(14) | Flag de diário auxiliar |
| **CUSOBRIGRAT** | VARCHAR(14) | Flag de obrigatoriedade de rateio |
| **CUSCODCTB** | VARCHAR(37) | Código contábil |
| **CUSQTDDIASVENC** | INTEGER | Quantidade de dias para vencimento |

### Contas Contábeis
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CUSDEBITO** | NUMERIC(27) | Conta de débito |
| **CUSCREDITO** | NUMERIC(27) | Conta de crédito |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CCUST Referencia (1 FK):

#### TPCUSTO - Tipos de Centro de Custo
**Relacionamento (FK no Schema):**
```
CCUST.TPCCODIGO → TPCUSTO.TPCCODIGO (N:1)
Constraint: TPCUSTO_CCUST
```

**Descrição**: Cada centro de custo pertence a um tipo específico, permitindo classificação e agrupamento.

**Informações da Tabela TPCUSTO:**
- **Total:** 70 tipos
- **PK:** TPCCODIGO
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 3 tabelas (CCUST, PLANO, TPANALISELUC)

**Campos importantes em TPCUSTO:**
- `TPCDESCRICAO` - Descrição do tipo
- `TPCTIPO` - Tipo de classificação
- `TPCCUSTO` - Flag de custo
- `TPCORDEM` - Ordem de exibição

**Uso:** Classificar centros de custo por tipo, gerar relatórios agrupados por tipo.

---

### CCUST é Referenciada Por (16 Tabelas):

#### Categorias de Tabelas Dependentes:

**1. Movimentações Financeiras:**
- **CAIXA, CAIXAP** - Movimentações de caixa vinculadas a centro de custo
- **PAGAR, PAGARP** - Contas a pagar por centro de custo
- **RECEB, RECEBP** - Contas a receber por centro de custo

**2. Configurações Bancárias:**
- **BCOCOB** - Configurações de cobrança bancária (CUSCODIGO e CUSCODIGO2)

**3. Notas Fiscais:**
- **NOTAE** - Notas fiscais de entrada por centro de custo

**4. Controle Contábil:**
- **LANCUSTO** - Lançamentos contábeis por centro de custo
- **CCCRITERIOS** - Critérios de rateio por centro de custo
- **CCUSTEMPCTB** - Empresas contábeis por centro de custo
- **CCUSTESSILOR** - Rateio por centro de custo

**5. Planejamento:**
- **PREVORCAMENTO** - Previsão orçamentária por centro de custo

**6. Fiscal:**
- **TBFIS** - Tabelas fiscais por centro de custo
- **INFCLITBFECHA** - Informações de fechamento por centro de custo

**Todas as 16 tabelas referenciam CCUST através do campo CUSCODIGO.**

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via TPCUSTO → PLANO

**Fluxo:** CCUST → TPCUSTO → PLANO

**Descrição:** Através do relacionamento com TPCUSTO, é possível identificar planos de contas relacionados.

**Campos de junção:**
- `CCUST.TPCCODIGO` → `TPCUSTO.TPCCODIGO` → `PLANO.TPCCODIGO`

**Uso:** Integração com plano de contas, relatórios contábeis consolidados.

---

### Via PAGAR → CLIEN (Clientes)

**Fluxo:** CCUST → PAGAR → CLIEN

**Descrição:** Através do relacionamento com PAGAR, é possível identificar fornecedores por centro de custo.

**Campos de junção:**
- `CCUST.CUSCODIGO` → `PAGAR.CUSCODIGO` → `PAGAR.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de despesas por fornecedor e centro de custo.

---

### Via RECEB → CLIEN (Clientes)

**Fluxo:** CCUST → RECEB → CLIEN

**Descrição:** Através do relacionamento com RECEB, é possível identificar clientes por centro de custo.

**Campos de junção:**
- `CCUST.CUSCODIGO` → `RECEB.CUSCODIGO` → `RECEB.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de receitas por cliente e centro de custo.

---

### Via NOTAE → CLIEN (Fornecedores)

**Fluxo:** CCUST → NOTAE → CLIEN

**Descrição:** Através do relacionamento com NOTAE, é possível identificar fornecedores por centro de custo.

**Campos de junção:**
- `CCUST.CUSCODIGO` → `NOTAE.CUSCODIGO` → `NOTAE.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de compras por fornecedor e centro de custo.

---

### Via BCOCOB → CONTA (Contas Bancárias)

**Fluxo:** CCUST → BCOCOB → CONTA

**Descrição:** Através do relacionamento com BCOCOB, é possível identificar contas bancárias por centro de custo.

**Campos de junção:**
- `CCUST.CUSCODIGO` → `BCOCOB.CUSCODIGO` → `BCOCOB.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CONTA`

**Uso:** Análises de movimentações bancárias por centro de custo.

---

### Via CAIXA → CCORR (Movimentações Bancárias)

**Fluxo:** CCUST → CAIXA → CCORR

**Descrição:** Através do relacionamento com CAIXA, é possível identificar movimentações bancárias por centro de custo.

**Campos de junção:**
- `CCUST.CUSCODIGO` → `CAIXA.CUSCODIGO` → `CAIXA.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR`

**Uso:** Análises de fluxo de caixa por centro de custo.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Centro de Custo

**Objetivo:** Obter visão completa de um centro de custo incluindo tipo, movimentações financeiras e relacionamentos.

**Fluxo:**
```
CCUST (CUSCODIGO, CUSDESCRICAO, TPCCODIGO)
  ↓
TPCUSTO (TPCCODIGO)
  ↓
PAGAR (CUSCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
RECEB (CUSCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    c.CUSGRAU AS GRAU,
    c.CUSSITUACAO AS SITUACAO,
    tp.TPCDESCRICAO AS TIPO_CUSTO,
    tp.TPCTIPO AS TIPO,
    COUNT(DISTINCT p.PAGCODIGO) AS TOTAL_CONTAS_PAGAR,
    COUNT(DISTINCT r.RECCODIGO) AS TOTAL_CONTAS_RECEBER,
    COUNT(DISTINCT n.NFECODIGO) AS TOTAL_NOTAS_ENTRADA,
    SUM(p.PAGVALOR) / 100.0 AS TOTAL_PAGAR,
    SUM(r.RECVALOR) / 100.0 AS TOTAL_RECEBER,
    (SUM(r.RECVALOR) - SUM(p.PAGVALOR)) / 100.0 AS SALDO_CENTRO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
LEFT JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
LEFT JOIN RECEB r ON r.CUSCODIGO = c.CUSCODIGO
LEFT JOIN NOTAE n ON n.CUSCODIGO = c.CUSCODIGO
WHERE c.CUSCODIGO = ?
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, c.CUSGRAU, c.CUSSITUACAO, tp.TPCDESCRICAO, tp.TPCTIPO;
```

---

### Exemplo 2: Análise de Despesas por Centro de Custo e Fornecedor

**Objetivo:** Identificar principais fornecedores por centro de custo.

**Fluxo:**
```
CCUST (CUSCODIGO)
  ↓
PAGAR (CUSCODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    cl.CLICODIGO,
    cl.CLINOME AS FORNECEDOR,
    COUNT(p.PAGCODIGO) AS TOTAL_TITULOS,
    SUM(p.PAGVALOR) / 100.0 AS VALOR_TOTAL,
    SUM(p.PAGVALORABERTO) / 100.0 AS VALOR_ABERTO,
    MIN(p.PAGDTVENCTO) AS PRIMEIRO_VENCIMENTO,
    MAX(p.PAGDTVENCTO) AS ULTIMO_VENCIMENTO
FROM CCUST c
INNER JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = p.CLICODIGO
WHERE c.CUSCODIGO = ?
  AND p.PAGDTEMISSAO >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, cl.CLICODIGO, cl.CLINOME
ORDER BY VALOR_TOTAL DESC;
```

---

### Exemplo 3: Análise de Receitas por Centro de Custo e Cliente

**Objetivo:** Identificar principais clientes por centro de custo.

**Fluxo:**
```
CCUST (CUSCODIGO)
  ↓
RECEB (CUSCODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    cl.CLICODIGO,
    cl.CLINOME AS CLIENTE,
    COUNT(r.RECCODIGO) AS TOTAL_TITULOS,
    SUM(r.RECVALOR) / 100.0 AS VALOR_TOTAL,
    SUM(r.RECVALORABERTO) / 100.0 AS VALOR_ABERTO,
    MIN(r.RECDTVENCTO) AS PRIMEIRO_VENCIMENTO,
    MAX(r.RECDTVENCTO) AS ULTIMO_VENCIMENTO
FROM CCUST c
INNER JOIN RECEB r ON r.CUSCODIGO = c.CUSCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = r.CLICODIGO
WHERE c.CUSCODIGO = ?
  AND r.RECDTEMISSAO >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, cl.CLICODIGO, cl.CLINOME
ORDER BY VALOR_TOTAL DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Todos os Centros de Custo

**Objetivo:** Visualizar todos os centros de custo cadastrados no sistema.

```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    tp.TPCDESCRICAO AS TIPO,
    c.CUSGRAU AS GRAU,
    c.CUSSITUACAO AS SITUACAO,
    c.CUSCODRED AS CODIGO_REDUZIDO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
ORDER BY c.CUSGRAU, c.CUSDESCRICAO;
```

---

### 2. Buscar Centro de Custo Específico

**Objetivo:** Obter detalhes completos de um centro de custo específico.

```sql
SELECT
    c.*,
    tp.TPCDESCRICAO AS TIPO_DESCRICAO,
    tp.TPCTIPO AS TIPO_CLASSIFICACAO,
    COUNT(DISTINCT p.PAGCODIGO) AS TOTAL_CONTAS_PAGAR,
    COUNT(DISTINCT r.RECCODIGO) AS TOTAL_CONTAS_RECEBER
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
LEFT JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
LEFT JOIN RECEB r ON r.CUSCODIGO = c.CUSCODIGO
WHERE c.CUSCODIGO = ?
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, c.CUSGRAU, c.CUSIMPRIME, 
         c.CUSDIARAUX, c.CUSCODRED, c.TPCCODIGO, c.CUSDEBITO, 
         c.CUSCREDITO, c.CUSOBRIGRAT, c.CUSCODCTB, c.CUSQTDDIASVENC, 
         c.CUSSITUACAO, tp.TPCDESCRICAO, tp.TPCTIPO;
```

---

### 3. Análise de Despesas por Centro de Custo

**Objetivo:** Calcular totais de despesas por centro de custo em um período.

```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    tp.TPCDESCRICAO AS TIPO,
    COUNT(p.PAGCODIGO) AS TOTAL_TITULOS,
    SUM(p.PAGVALOR) / 100.0 AS VALOR_TOTAL,
    SUM(p.PAGVALORABERTO) / 100.0 AS VALOR_ABERTO,
    SUM(p.PAGVALOR - p.PAGVALORABERTO) / 100.0 AS VALOR_PAGO,
    MIN(p.PAGDTVENCTO) AS PRIMEIRO_VENCIMENTO,
    MAX(p.PAGDTVENCTO) AS ULTIMO_VENCIMENTO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
LEFT JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
WHERE p.PAGDTEMISSAO BETWEEN ? AND ?
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, tp.TPCDESCRICAO
HAVING COUNT(p.PAGCODIGO) > 0
ORDER BY VALOR_TOTAL DESC;
```

---

### 4. Análise de Receitas por Centro de Custo

**Objetivo:** Calcular totais de receitas por centro de custo em um período.

```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    tp.TPCDESCRICAO AS TIPO,
    COUNT(r.RECCODIGO) AS TOTAL_TITULOS,
    SUM(r.RECVALOR) / 100.0 AS VALOR_TOTAL,
    SUM(r.RECVALORABERTO) / 100.0 AS VALOR_ABERTO,
    SUM(r.RECVALOR - r.RECVALORABERTO) / 100.0 AS VALOR_RECEBIDO,
    MIN(r.RECDTVENCTO) AS PRIMEIRO_VENCIMENTO,
    MAX(r.RECDTVENCTO) AS ULTIMO_VENCIMENTO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
LEFT JOIN RECEB r ON r.CUSCODIGO = c.CUSCODIGO
WHERE r.RECDTEMISSAO BETWEEN ? AND ?
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, tp.TPCDESCRICAO
HAVING COUNT(r.RECCODIGO) > 0
ORDER BY VALOR_TOTAL DESC;
```

---

### 5. Relatório de Resultado por Centro de Custo

**Objetivo:** Calcular resultado (receitas - despesas) por centro de custo.

```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    tp.TPCDESCRICAO AS TIPO,
    COALESCE(SUM(r.RECVALOR), 0) / 100.0 AS TOTAL_RECEITAS,
    COALESCE(SUM(p.PAGVALOR), 0) / 100.0 AS TOTAL_DESPESAS,
    (COALESCE(SUM(r.RECVALOR), 0) - COALESCE(SUM(p.PAGVALOR), 0)) / 100.0 AS RESULTADO,
    CASE 
        WHEN COALESCE(SUM(r.RECVALOR), 0) > COALESCE(SUM(p.PAGVALOR), 0) THEN 'LUCRO'
        WHEN COALESCE(SUM(r.RECVALOR), 0) < COALESCE(SUM(p.PAGVALOR), 0) THEN 'PREJUIZO'
        ELSE 'EQUILIBRIO'
    END AS SITUACAO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
LEFT JOIN RECEB r ON r.CUSCODIGO = c.CUSCODIGO
    AND r.RECDTEMISSAO BETWEEN ? AND ?
LEFT JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
    AND p.PAGDTEMISSAO BETWEEN ? AND ?
WHERE c.CUSSITUACAO = 'A' OR c.CUSSITUACAO IS NULL
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO, tp.TPCDESCRICAO
HAVING COALESCE(SUM(r.RECVALOR), 0) > 0 OR COALESCE(SUM(p.PAGVALOR), 0) > 0
ORDER BY RESULTADO DESC;
```

---

### 6. Análise de Centros de Custo por Tipo

**Objetivo:** Identificar distribuição de centros de custo por tipo.

```sql
SELECT
    tp.TPCCODIGO,
    tp.TPCDESCRICAO AS TIPO_CUSTO,
    COUNT(c.CUSCODIGO) AS TOTAL_CENTROS,
    COUNT(CASE WHEN c.CUSSITUACAO = 'A' OR c.CUSSITUACAO IS NULL THEN 1 END) AS CENTROS_ATIVOS,
    COUNT(CASE WHEN c.CUSSITUACAO != 'A' THEN 1 END) AS CENTROS_INATIVOS
FROM TPCUSTO tp
LEFT JOIN CCUST c ON c.TPCCODIGO = tp.TPCCODIGO
GROUP BY tp.TPCCODIGO, tp.TPCDESCRICAO
ORDER BY TOTAL_CENTROS DESC;
```

---

### 7. Verificar Centros de Custo Não Utilizados

**Objetivo:** Identificar centros de custo que não possuem movimentações.

```sql
SELECT
    c.CUSCODIGO,
    c.CUSDESCRICAO AS CENTRO_CUSTO,
    tp.TPCDESCRICAO AS TIPO,
    c.CUSSITUACAO AS SITUACAO
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
WHERE NOT EXISTS (SELECT 1 FROM PAGAR p WHERE p.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM RECEB r WHERE r.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM CAIXA cx WHERE cx.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM NOTAE n WHERE n.CUSCODIGO = c.CUSCODIGO)
ORDER BY c.CUSDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CCUST | Tipo |
|--------|-----------|---------------------|------|
| **CCUST** | 433 | 1:1 | **TABELA PRINCIPAL** |
| TPCUSTO | 70 | 6.2:1 | Tipos (média de 6.2 centros por tipo) |
| PAGAR | 259.801 | 600:1 | Contas a pagar (média de 600 títulos por centro) |
| RECEB | 200.335 | 463:1 | Contas a receber (média de 463 títulos por centro) |
| NOTAE | 204.952 | 474:1 | Notas fiscais entrada (média de 474 notas por centro) |
| CAIXA | 0 | - | Movimentações de caixa (sem registros) |

**Interpretação:**
- Cada tipo possui em média **6.2 centros de custo** (distribuição equilibrada)
- Cada centro possui em média **600 contas a pagar** (alta atividade)
- Cada centro possui em média **463 contas a receber** (alta atividade)
- Tabela média mas crítica para controle gerencial

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CUSCODIGO** | CCUST | Identificador único (PK) |
| **CUSCODIGO** | [16 tabelas] → CCUST | Referência ao centro de custo |
| **TPCCODIGO** | CCUST → TPCUSTO | Referência ao tipo de centro de custo |
| **CUSDESCRICAO** | CCUST | Descrição do centro (busca e exibição) |
| **CUSSITUACAO** | CCUST | Situação do centro (filtro) |
| **CUSGRAU** | CCUST | Grau hierárquico (agrupamento) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CCUST.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice em TPCCODIGO** - Para buscas por tipo
3. **Índice em CUSSITUACAO** - Para filtros por situação
4. **Índice em CUSGRAU** - Para agrupamentos hierárquicos
5. **Índices nas tabelas relacionadas** - Mais críticos que índices em CCUST

### Observações sobre Volume

- **Tabela média** (433 registros) - Performance não é crítica
- **Consultas com JOINs** são rápidas devido ao volume reduzido
- **Focar em índices nas tabelas relacionadas** - PAGAR, RECEB têm volumes maiores
- **Cache pode ser útil** - Tabela pequena pode ser mantida em memória

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_CCUST_TIPO ON CCUST(TPCCODIGO);

-- Índice 2: Busca por situação
CREATE INDEX IDX_CCUST_SITUACAO ON CCUST(CUSSITUACAO) WHERE CUSSITUACAO IS NOT NULL;

-- Índice 3: Busca por grau (hierarquia)
CREATE INDEX IDX_CCUST_GRAU ON CCUST(CUSGRAU);

-- Índice 4: Busca por código reduzido
CREATE INDEX IDX_CCUST_CODRED ON CCUST(CUSCODRED) WHERE CUSCODRED IS NOT NULL;
```

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (tabela pequena, não precisa de otimização especial)
SELECT CUSCODIGO, CUSDESCRICAO
FROM CCUST
WHERE TPCCODIGO = ?
  AND (CUSSITUACAO = 'A' OR CUSSITUACAO IS NULL);

-- ✅ OTIMIZADO (JOIN com tabela pequena é rápido)
SELECT c.CUSDESCRICAO, COUNT(p.PAGCODIGO) AS TOTAL
FROM CCUST c
LEFT JOIN PAGAR p ON p.CUSCODIGO = c.CUSCODIGO
WHERE c.TPCCODIGO = ?
GROUP BY c.CUSCODIGO, c.CUSDESCRICAO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar centros de custo sem tipo válido
SELECT c.*
FROM CCUST c
LEFT JOIN TPCUSTO tp ON tp.TPCCODIGO = c.TPCCODIGO
WHERE tp.TPCCODIGO IS NULL;

-- Verificar movimentações sem centro de custo válido
SELECT p.*
FROM PAGAR p
LEFT JOIN CCUST c ON c.CUSCODIGO = p.CUSCODIGO
WHERE c.CUSCODIGO IS NULL;

SELECT r.*
FROM RECEB r
LEFT JOIN CCUST c ON c.CUSCODIGO = r.CUSCODIGO
WHERE c.CUSCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CCUST
WHERE CUSCODIGO IS NULL
   OR CUSDESCRICAO IS NULL
   OR CUSGRAU IS NULL
   OR CUSIMPRIME IS NULL
   OR CUSDIARAUX IS NULL
   OR TPCCODIGO IS NULL
   OR CUSOBRIGRAT IS NULL;

-- Verificar códigos duplicados
SELECT CUSCODIGO, COUNT(*) AS QTD
FROM CCUST
GROUP BY CUSCODIGO
HAVING COUNT(*) > 1;

-- Verificar códigos reduzidos duplicados
SELECT CUSCODRED, COUNT(*) AS QTD
FROM CCUST
WHERE CUSCODRED IS NOT NULL
GROUP BY CUSCODRED
HAVING COUNT(*) > 1;
```

### Verificar Padrões de Uso

```sql
-- Verificar centros de custo sem movimentações
SELECT c.*
FROM CCUST c
WHERE NOT EXISTS (SELECT 1 FROM PAGAR p WHERE p.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM RECEB r WHERE r.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM CAIXA cx WHERE cx.CUSCODIGO = c.CUSCODIGO)
  AND NOT EXISTS (SELECT 1 FROM NOTAE n WHERE n.CUSCODIGO = c.CUSCODIGO);

-- Verificar distribuição por tipo
SELECT tp.TPCDESCRICAO, COUNT(c.CUSCODIGO) AS QTD
FROM TPCUSTO tp
LEFT JOIN CCUST c ON c.TPCCODIGO = tp.TPCCODIGO
GROUP BY tp.TPCDESCRICAO
ORDER BY QTD DESC;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCcust extends Model
{
    protected $connection = 'firebird';
    protected $table = 'CCUST';
    protected $primaryKey = 'CUSCODIGO';

    protected $casts = [
        'CUSCODIGO' => 'string',
        'TPCCODIGO' => 'integer',
        'CUSGRAU' => 'string',
        'CUSCODRED' => 'integer',
        'CUSDEBITO' => 'decimal:2',
        'CUSCREDITO' => 'decimal:2',
        'CUSQTDDIASVENC' => 'integer',
        'CUSIMPRIME' => 'string',
        'CUSDIARAUX' => 'string',
        'CUSOBRIGRAT' => 'string',
        'CUSSITUACAO' => 'string',
    ];

    // Relacionamento com TPCUSTO
    public function tipoCusto(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpcusto::class, 'TPCCODIGO', 'TPCCODIGO');
    }

    // Relacionamento com PAGAR
    public function contasPagar(): HasMany
    {
        return $this->hasMany(FirebirdPagar::class, 'CUSCODIGO', 'CUSCODIGO');
    }

    // Relacionamento com RECEB
    public function contasReceber(): HasMany
    {
        return $this->hasMany(FirebirdReceb::class, 'CUSCODIGO', 'CUSCODIGO');
    }

    // Relacionamento com NOTAE
    public function notasEntrada(): HasMany
    {
        return $this->hasMany(FirebirdNotae::class, 'CUSCODIGO', 'CUSCODIGO');
    }

    // Relacionamento com CAIXA
    public function movimentacoesCaixa(): HasMany
    {
        return $this->hasMany(FirebirdCaixa::class, 'CUSCODIGO', 'CUSCODIGO');
    }

    // Scope para buscar por tipo
    public function scopePorTipo($query, int $tipoCodigo)
    {
        return $query->where('TPCCODIGO', $tipoCodigo);
    }

    // Scope para centros ativos
    public function scopeAtivos($query)
    {
        return $query->where(function($q) {
            $q->where('CUSSITUACAO', 'A')
              ->orWhereNull('CUSSITUACAO');
        });
    }

    // Scope para centros inativos
    public function scopeInativos($query)
    {
        return $query->where('CUSSITUACAO', '!=', 'A')
            ->whereNotNull('CUSSITUACAO');
    }

    // Scope para buscar por grau
    public function scopePorGrau($query, string $grau)
    {
        return $query->where('CUSGRAU', $grau);
    }

    // Scope para buscar por descrição
    public function scopePorDescricao($query, string $descricao)
    {
        return $query->whereRaw('UPPER(CUSDESCRICAO) LIKE UPPER(?)', ['%' . $descricao . '%']);
    }

    // Método para verificar se está ativo
    public function isAtivo(): bool
    {
        return $this->CUSSITUACAO === 'A' || $this->CUSSITUACAO === null;
    }

    // Método para contar contas a pagar
    public function contarContasPagar(): int
    {
        return $this->contasPagar()->count();
    }

    // Método para contar contas a receber
    public function contarContasReceber(): int
    {
        return $this->contasReceber()->count();
    }

    // Método para calcular total de despesas
    public function calcularTotalDespesas(): float
    {
        return $this->contasPagar()->sum('PAGVALOR') / 100.0;
    }

    // Método para calcular total de receitas
    public function calcularTotalReceitas(): float
    {
        return $this->contasReceber()->sum('RECVALOR') / 100.0;
    }

    // Método para calcular resultado
    public function calcularResultado(): float
    {
        return $this->calcularTotalReceitas() - $this->calcularTotalDespesas();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Manter consistência** - CUSDESCRICAO deve ser único e descritivo
2. **Grau hierárquico** - CUSGRAU deve refletir estrutura organizacional
3. **Tipo obrigatório** - TPCCODIGO deve sempre ser preenchido
4. **Código reduzido** - CUSCODRED deve ser único quando informado

### Performance

1. **Tabela pequena** - Não requer otimização especial
2. **Cache útil** - Pode ser mantida em memória
3. **Índices nas tabelas relacionadas** - Mais importante que índices em CCUST
4. **Evitar SELECT *** - Especificar apenas colunas necessárias

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se tipo existe
2. **Verificar referências** - Antes de excluir, verificar se há movimentações
3. **Manter consistência** - Garantir que tipo é válido
4. **Auditoria** - Registrar alterações em centros críticos

### Manutenção

1. **Revisão periódica** - Verificar centros não utilizados
2. **Padronização** - Manter nomenclatura consistente
3. **Documentação** - Documentar significado de cada centro
4. **Backup regular** - Tabela crítica para controle gerencial

### Regras de Negócio

1. **Centros únicos** - Não devem existir centros duplicados
2. **Referências obrigatórias** - Movimentações devem sempre ter centro de custo
3. **Hierarquia** - CUSGRAU deve refletir estrutura organizacional
4. **Integridade referencial** - Não excluir centro com movimentações vinculadas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

