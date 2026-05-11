# CFOP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CFOP (Código Fiscal de Operações e Prestações)
- **Total de Registros**: 620
- **Total de Colunas**: 2
- **Chave Primária**: FISCFOP (VARCHAR)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (TBFIS) - Direta, 30+ indiretas via TBFIS
- **Banco de Dados**: Firebird

## 📝 Descrição

**CFOP** é uma tabela mestre que armazena os códigos CFOP (Código Fiscal de Operações e Prestações) utilizados no sistema fiscal brasileiro. Com **620 registros**, representa um catálogo completo de códigos CFOP padronizados pela Receita Federal do Brasil.

Esta tabela funciona como **catálogo fiscal obrigatório** e permite:
- Identificar a natureza fiscal de operações comerciais
- Classificar operações como entrada ou saída
- Distinguir operações estaduais, interestaduais ou com exterior
- Determinar tratamento tributário adequado para cada operação
- Garantir compliance fiscal em documentos fiscais (NFe, NFSe, SPED)
- Suportar cálculos de impostos (ICMS, IPI, PIS, COFINS)

Cada registro representa um código CFOP válido, contendo:
- Código CFOP (FISCFOP) - formato padrão (ex: 5102, 6102, 1102)
- Descrição da operação fiscal (CFODESCRICAO)

**Estrutura do Código CFOP:**
- **1º dígito**: Tipo de operação
  - `1` = Entrada - Estadual
  - `2` = Entrada - Interestadual
  - `3` = Entrada - Exterior
  - `5` = Saída - Estadual
  - `6` = Saída - Interestadual
  - `7` = Saída - Exterior
- **2º dígito**: Grupo de operação
- **3º e 4º dígitos**: Operação específica

O sistema utiliza esta tabela através de TBFIS (Tabela Fiscal) para determinar o tratamento fiscal correto de produtos e serviços em todas as operações comerciais.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FISCFOP** 🔑 | VARCHAR(37) | ✓ | Código CFOP (PK) - Formato padrão brasileiro (ex: 5102, 6102) |

### Informações Fiscais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CFODESCRICAO** | VARCHAR(37) | ✓ | Descrição da operação fiscal conforme legislação |

**Primary Key:** FISCFOP

**Observações sobre Campos:**
- **FISCFOP**: Código alfanumérico que identifica unicamente cada operação fiscal. Geralmente formato numérico de 4 dígitos, mas pode ter variações.
- **CFODESCRICAO**: Descrição oficial da operação conforme tabela da Receita Federal.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CFOP é Referenciada Por (1 FK Direta):

#### 1. TBFIS - Tabela Fiscal
**Relacionamento:**
```
TBFIS.FISCFOP → CFOP.FISCFOP (N:1)
Constraint: CFOP_TBFIS
```

**Descrição**: Cada situação fiscal (TBFIS) está vinculada a um código CFOP específico que define a natureza da operação.

**Informações da Tabela TBFIS:**
- **Total:** 311 situações fiscais
- **PK:** FISCODIGO
- **Colunas:** 81 campos
- **FK Out:** 7 (incluindo CFOP)
- **FK In:** 30 tabelas

**Campos importantes em TBFIS relacionados a CFOP:**
- `FISCFOP` - CFOP principal da situação fiscal (FK → CFOP)
- `FISCFOPREF` - CFOP de referência para operações específicas (FK → TBFIS, indireto → CFOP)
- `FISCFOPREF2` - Segundo CFOP de referência (FK → TBFIS, indireto → CFOP)
- `FISCFOPSBT` - CFOP para Substituição Tributária

**Uso:** Determinar natureza fiscal de produtos e serviços, calcular impostos corretamente, emitir documentos fiscais válidos.

---

### CFOP Referencia

**Nenhuma tabela** é referenciada diretamente por CFOP. Esta é uma tabela mestre sem dependências externas.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos via TBFIS)

### Via TBFIS → 30 Tabelas Dependentes

**Fluxo:** CFOP → TBFIS → [30 Tabelas]

**Descrição:** Através do relacionamento com TBFIS, CFOP está indiretamente relacionado a todas as tabelas que utilizam situações fiscais.

**Tabelas relacionadas via TBFIS (30 tabelas):**

#### Documentos Fiscais
- **NOTAC** - Notas Fiscais de Saída (Produtos)
- **NOTAE** - Notas Fiscais de Entrada (2 FKs: FISCODIGO1, FISCODIGO2)
- **NFEPRO** - Produtos em NFe
- **NFESER** - Serviços em NFe
- **NFVEI** - Veículos em NFe
- **NFPRO** - Produtos em NF
- **NFSER** - Serviços em NF
- **NFVEI** - Veículos em NF

#### Pedidos e Orçamentos
- **PDPRD** - Produtos do Pedido (via TBFIS)
- **PDSER** - Serviços do Pedido
- **ORCAM** - Orçamentos (2 FKs: FISCODIGO, FISCODIGO2)
- **OCPRD** - Produtos de Orçamento
- **OCSER** - Serviços de Orçamento
- **OCSERPROD** - Serviços-Produtos de Orçamento

#### Movimentações e Controle
- **MOVIMENTACAO** - Movimentações Fiscais
- **MOVTOPRVOS** - Movimentações Provisórias
- **CPPRD** - Produtos de Compra
- **CPSER** - Serviços de Compra
- **CUPOM** - Cupons Fiscais (2 FKs: FISCODIGO, FISCODIGO2)

#### Configurações e Integrações
- **EMPFILIAL** - Filiais de Empresa
- **INTEGRACTBTBFIS** - Integração Contábil x TBFIS
- **PFSER** - Serviços de Pedido de Fornecedor
- **TBFISSISEXT** - TBFIS Sistema Externo
- E outras...

**Uso:** Análises fiscais completas, relatórios de operações por CFOP, auditoria fiscal, compliance tributário.

---

### Via TBFIS → Outras Tabelas Fiscais

**Fluxo:** CFOP → TBFIS → [Tabelas Fiscais]

**Descrição:** Através de TBFIS, CFOP se relaciona com outras tabelas de configuração fiscal.

**Tabelas relacionadas:**
- **CCUST** - Centros de Custo (via TBFIS.CUSCODIGO)
- **OBSER** - Observações Fiscais (via TBFIS.OBSCODIGO)
- **TBPAUTAICMSUB** - Pauta de ICMS ST (via TBFIS.TBPAUTAICMSUBCODIGO)

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de CFOP em Notas Fiscais

**Objetivo:** Obter visão completa de um CFOP incluindo todas as notas fiscais que o utilizam e seus produtos.

**Fluxo:**
```
CFOP (FISCFOP)
  ↓
TBFIS (FISCFOP)
  ↓
NOTAC (FISCODIGO)
  ↓
NFEPRO (FISCODIGO)
```

**Query SQL:**
```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    tf.FISCODIGO,
    tf.FISDESCRICAO AS SITUACAO_FISCAL,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT nfp.NFEPROCODIGO) AS TOTAL_PRODUTOS,
    SUM(nfp.NFEPROQTDADE) AS QUANTIDADE_TOTAL,
    SUM(nfp.NFEPROVLRUNITARIO * nfp.NFEPROQTDADE) AS VALOR_TOTAL
FROM CFOP cf
INNER JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
LEFT JOIN NOTAC nf ON nf.FISCODIGO = tf.FISCODIGO
LEFT JOIN NFEPRO nfp ON nfp.FISCODIGO = tf.FISCODIGO
WHERE cf.FISCFOP = ?
GROUP BY cf.FISCFOP, cf.CFODESCRICAO, tf.FISCODIGO, tf.FISDESCRICAO;
```

---

### Exemplo 2: Análise de CFOP em Pedidos

**Objetivo:** Identificar quais CFOPs são mais utilizados em pedidos e seus valores.

**Fluxo:**
```
CFOP (FISCFOP)
  ↓
TBFIS (FISCFOP)
  ↓
PDPRD (FISCODIGO)
  ↓
PEDID (ID_PEDIDO)
```

**Query SQL:**
```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    CASE 
        WHEN SUBSTR(cf.FISCFOP, 1, 1) IN ('1', '2', '3') THEN 'Entrada'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) IN ('5', '6', '7') THEN 'Saída'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pdp.PDPRDCODIGO) AS TOTAL_PRODUTOS,
    SUM(pdp.PDPQTDADE) AS QUANTIDADE_TOTAL,
    SUM(pdp.PDPUNITLIQUIDO * pdp.PDPQTDADE) AS VALOR_TOTAL
FROM CFOP cf
INNER JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
LEFT JOIN PDPRD pdp ON pdp.FISCODIGO = tf.FISCODIGO
LEFT JOIN PEDID pd ON pd.ID_PEDIDO = pdp.ID_PEDIDO
WHERE pd.PEDDTEMIS BETWEEN ? AND ?
GROUP BY cf.FISCFOP, cf.CFODESCRICAO
ORDER BY VALOR_TOTAL DESC;
```

---

### Exemplo 3: Análise de CFOP por Tipo de Operação

**Objetivo:** Identificar distribuição de CFOPs por tipo de operação (Entrada/Saída, Estadual/Interestadual/Exterior).

**Fluxo:**
```
CFOP (FISCFOP)
  ↓
TBFIS (FISCFOP)
  ↓
MOVIMENTACAO (FISCODIGO)
```

**Query SQL:**
```sql
SELECT
    CASE 
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '1' THEN 'Entrada - Estadual'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '2' THEN 'Entrada - Interestadual'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '3' THEN 'Entrada - Exterior'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '5' THEN 'Saída - Estadual'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '6' THEN 'Saída - Interestadual'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) = '7' THEN 'Saída - Exterior'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO,
    COUNT(DISTINCT cf.FISCFOP) AS TOTAL_CFOPS,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS,
    COUNT(DISTINCT mv.MOVCODIGO) AS TOTAL_MOVIMENTACOES,
    SUM(mv.MOVVALOR) AS VALOR_TOTAL_MOVIMENTACOES
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
LEFT JOIN MOVIMENTACAO mv ON mv.FISCODIGO = tf.FISCODIGO
GROUP BY SUBSTR(cf.FISCFOP, 1, 1)
ORDER BY TIPO_OPERACAO;
```

---

## 🔗 Relacionamentos Lógicos (Sem FK Formal)

### Tabelas de CST por CFOP

As seguintes tabelas têm relacionamento lógico com CFOP através de FISCODIGO (que referencia TBFIS, que referencia CFOP):

#### 1. TBICMSCFOP - CST de ICMS por CFOP
**Relacionamento Lógico:**
```
TBICMSCFOP.FISCODIGO → TBFIS.FISCODIGO → TBFIS.FISCFOP → CFOP.FISCFOP
```

**Informações:**
- **Total:** 335 registros
- **PK:** (FISCODIGO, EMPCODIGO)
- **Colunas:** 3 (FISCODIGO, EMPCODIGO, CST)

**Uso:** Determinar CST de ICMS específico por CFOP e empresa.

---

#### 2. TBPISCFOP - CST de PIS por CFOP
**Relacionamento Lógico:**
```
TBPISCFOP.FISCODIGO → TBFIS.FISCODIGO → TBFIS.FISCFOP → CFOP.FISCFOP
```

**Informações:**
- **Total:** 335 registros
- **PK:** (FISCODIGO, EMPCODIGO)
- **Colunas:** 3 (FISCODIGO, EMPCODIGO, CST)

**Uso:** Determinar CST de PIS específico por CFOP e empresa.

---

#### 3. TBCOFINSCFOP - CST de COFINS por CFOP
**Relacionamento Lógico:**
```
TBCOFINSCFOP.FISCODIGO → TBFIS.FISCODIGO → TBFIS.FISCFOP → CFOP.FISCFOP
```

**Informações:**
- **Total:** 335 registros
- **PK:** (FISCODIGO, EMPCODIGO)
- **Colunas:** 3 (FISCODIGO, EMPCODIGO, CST)

**Uso:** Determinar CST de COFINS específico por CFOP e empresa.

---

#### 4. TBIPICFOP - CST de IPI por CFOP
**Relacionamento Lógico:**
```
TBIPICFOP.FISCODIGO → TBFIS.FISCODIGO → TBFIS.FISCFOP → CFOP.FISCFOP
```

**Informações:**
- **Total:** 335 registros
- **PK:** (FISCODIGO, EMPCODIGO)
- **Colunas:** 3 (FISCODIGO, EMPCODIGO, CST)

**Uso:** Determinar CST de IPI específico por CFOP e empresa.

---

## 💡 Casos de Uso Práticos

### 1. Buscar CFOP por Código

**Objetivo:** Obter informações completas de um CFOP específico.

```sql
SELECT
    FISCFOP,
    CFODESCRICAO AS DESCRICAO,
    CASE 
        WHEN SUBSTR(FISCFOP, 1, 1) IN ('1', '2', '3') THEN 'Entrada'
        WHEN SUBSTR(FISCFOP, 1, 1) IN ('5', '6', '7') THEN 'Saída'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO,
    CASE 
        WHEN SUBSTR(FISCFOP, 1, 1) IN ('1', '5') THEN 'Estadual'
        WHEN SUBSTR(FISCFOP, 1, 1) IN ('2', '6') THEN 'Interestadual'
        WHEN SUBSTR(FISCFOP, 1, 1) IN ('3', '7') THEN 'Exterior'
        ELSE 'Não identificado'
    END AS ALCANCE_OPERACAO
FROM CFOP
WHERE FISCFOP = ?;
```

---

### 2. Listar CFOPs por Tipo de Operação

**Objetivo:** Obter todos os CFOPs de entrada ou saída.

```sql
SELECT
    FISCFOP,
    CFODESCRICAO AS DESCRICAO,
    CASE 
        WHEN SUBSTR(FISCFOP, 1, 1) = '1' THEN 'Entrada - Estadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '2' THEN 'Entrada - Interestadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '3' THEN 'Entrada - Exterior'
        WHEN SUBSTR(FISCFOP, 1, 1) = '5' THEN 'Saída - Estadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '6' THEN 'Saída - Interestadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '7' THEN 'Saída - Exterior'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO
FROM CFOP
WHERE SUBSTR(FISCFOP, 1, 1) IN ('5', '6', '7') -- Saídas
ORDER BY FISCFOP;
```

---

### 3. Análise de Uso de CFOPs em Notas Fiscais

**Objetivo:** Identificar quais CFOPs são mais utilizados em notas fiscais.

```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT nf.CLICODIGO) AS TOTAL_CLIENTES,
    SUM(nf.NFTOTAL) AS VALOR_TOTAL,
    MIN(nf.NFDTEMIS) AS PRIMEIRA_NOTA,
    MAX(nf.NFDTEMIS) AS ULTIMA_NOTA
FROM CFOP cf
INNER JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
INNER JOIN NOTAC nf ON nf.FISCODIGO = tf.FISCODIGO
WHERE nf.NFDTEMIS BETWEEN ? AND ?
GROUP BY cf.FISCFOP, cf.CFODESCRICAO
ORDER BY TOTAL_NOTAS DESC;
```

---

### 4. Relatório de CFOPs por Situação Fiscal

**Objetivo:** Verificar quantas situações fiscais utilizam cada CFOP.

```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS,
    COUNT(DISTINCT CASE WHEN tf.FISATIVO = 'S' THEN tf.FISCODIGO END) AS SITUACOES_ATIVAS,
    COUNT(DISTINCT CASE WHEN tf.FISATIVO = 'N' THEN tf.FISCODIGO END) AS SITUACOES_INATIVAS
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
GROUP BY cf.FISCFOP, cf.CFODESCRICAO
ORDER BY TOTAL_SITUACOES_FISCAIS DESC;
```

---

### 5. Análise de CFOPs Não Utilizados

**Objetivo:** Identificar CFOPs que não estão sendo utilizados em nenhuma situação fiscal.

```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    CASE 
        WHEN SUBSTR(cf.FISCFOP, 1, 1) IN ('1', '2', '3') THEN 'Entrada'
        WHEN SUBSTR(cf.FISCFOP, 1, 1) IN ('5', '6', '7') THEN 'Saída'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
WHERE tf.FISCODIGO IS NULL
ORDER BY cf.FISCFOP;
```

---

### 6. Relatório de CFOPs por Movimentação Fiscal

**Objetivo:** Analisar movimentações fiscais agrupadas por CFOP.

```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    COUNT(DISTINCT mv.MOVCODIGO) AS TOTAL_MOVIMENTACOES,
    SUM(mv.MOVVALOR) AS VALOR_TOTAL,
    AVG(mv.MOVVALOR) AS VALOR_MEDIO,
    MIN(mv.MOVVALOR) AS VALOR_MINIMO,
    MAX(mv.MOVVALOR) AS VALOR_MAXIMO,
    COUNT(DISTINCT mv.EMPCODIGO) AS TOTAL_EMPRESAS
FROM CFOP cf
INNER JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
INNER JOIN MOVIMENTACAO mv ON mv.FISCODIGO = tf.FISCODIGO
WHERE mv.MOVDATA BETWEEN ? AND ?
GROUP BY cf.FISCFOP, cf.CFODESCRICAO
ORDER BY VALOR_TOTAL DESC;
```

---

### 7. Análise de CFOPs com CSTs Específicos

**Objetivo:** Verificar CFOPs que têm CSTs específicos configurados (ICMS, PIS, COFINS, IPI).

```sql
SELECT
    cf.FISCFOP,
    cf.CFODESCRICAO AS DESCRICAO_CFOP,
    COUNT(DISTINCT tic.FISCODIGO) AS TOTAL_COM_CST_ICMS,
    COUNT(DISTINCT tpi.FISCODIGO) AS TOTAL_COM_CST_PIS,
    COUNT(DISTINCT tco.FISCODIGO) AS TOTAL_COM_CST_COFINS,
    COUNT(DISTINCT tip.FISCODIGO) AS TOTAL_COM_CST_IPI
FROM CFOP cf
INNER JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
LEFT JOIN TBICMSCFOP tic ON tic.FISCODIGO = tf.FISCODIGO
LEFT JOIN TBPISCFOP tpi ON tpi.FISCODIGO = tf.FISCODIGO
LEFT JOIN TBCOFINSCFOP tco ON tco.FISCODIGO = tf.FISCODIGO
LEFT JOIN TBIPICFOP tip ON tip.FISCODIGO = tf.FISCODIGO
GROUP BY cf.FISCFOP, cf.CFODESCRICAO
HAVING COUNT(DISTINCT tic.FISCODIGO) > 0
    OR COUNT(DISTINCT tpi.FISCODIGO) > 0
    OR COUNT(DISTINCT tco.FISCODIGO) > 0
    OR COUNT(DISTINCT tip.FISCODIGO) > 0
ORDER BY cf.FISCFOP;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CFOP | Tipo |
|--------|-----------|-------------------|------|
| **CFOP** | 620 | 1:1 | **TABELA PRINCIPAL** |
| TBFIS | 311 | 0.5:1 | Situações fiscais (média de 0.5 situações por CFOP) |
| MOVIMENTACAO | ~70M | ~113k:1 | Movimentações fiscais |
| NOTAC | ~1.4M | ~2.3k:1 | Notas fiscais de saída |
| PDPRD | ~3M | ~4.8k:1 | Produtos de pedidos |

**Interpretação:**
- **620 CFOPs** cadastrados - catálogo completo
- Cada CFOP pode ter múltiplas situações fiscais (TBFIS)
- CFOPs são amplamente utilizados em movimentações fiscais
- Tabela mestre essencial para compliance fiscal

**Distribuição Esperada por Tipo:**
- **Entrada (1xx, 2xx, 3xx)**: ~310 CFOPs (50%)
- **Saída (5xx, 6xx, 7xx)**: ~310 CFOPs (50%)
- **Estadual (1xx, 5xx)**: ~207 CFOPs (33%)
- **Interestadual (2xx, 6xx)**: ~207 CFOPs (33%)
- **Exterior (3xx, 7xx)**: ~207 CFOPs (33%)

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **FISCFOP** | CFOP | Chave primária (PK) |
| **FISCFOP** | TBFIS → CFOP | Referência ao CFOP (FK) |
| **FISCODIGO** | TBFIS | Situação fiscal que referencia CFOP |
| **FISCODIGO** | [30 tabelas] → TBFIS | Referência indireta a CFOP |
| **CFODESCRICAO** | CFOP | Descrição do CFOP (exibição) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CFOP.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por primeiro dígito** - Para buscas por tipo de operação
3. **Índice em descrição** - Para buscas textuais (se necessário)
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CFOP

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo de operação (primeiro dígito)
CREATE INDEX IDX_CFOP_TIPO_OPERACAO ON CFOP(SUBSTR(FISCFOP, 1, 1));

-- Índice 2: Busca por descrição (se buscas textuais forem frequentes)
CREATE INDEX IDX_CFOP_DESCRICAO ON CFOP(UPPER(CFODESCRICAO));

-- Índice 3: Busca por código completo (já existe via PK, mas pode ser útil para LIKE)
CREATE INDEX IDX_CFOP_CODIGO ON CFOP(FISCFOP);
```

### Observações sobre Volume

- **Tabela média** (620 registros) - Performance não é crítica
- **Consultas são rápidas** devido ao volume moderado
- **Cache pode ser útil** - Tabela pode ser mantida em memória
- **Focar em índices nas tabelas relacionadas** - TBFIS e tabelas dependentes têm volumes maiores

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK)
SELECT FISCFOP, CFODESCRICAO
FROM CFOP
WHERE FISCFOP = ?;

-- ✅ OTIMIZADO (usar índice por tipo)
SELECT FISCFOP, CFODESCRICAO
FROM CFOP
WHERE SUBSTR(FISCFOP, 1, 1) IN ('5', '6', '7')
ORDER BY FISCFOP;

-- ✅ OTIMIZADO (JOIN com tabelas pequenas é rápido)
SELECT cf.*, COUNT(tf.FISCODIGO) AS TOTAL_SITUACOES
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
GROUP BY cf.FISCFOP, cf.CFODESCRICAO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar situações fiscais sem CFOP válido
SELECT tf.*
FROM TBFIS tf
LEFT JOIN CFOP cf ON cf.FISCFOP = tf.FISCFOP
WHERE tf.FISCFOP IS NOT NULL
  AND cf.FISCFOP IS NULL;

-- Verificar CFOPs não utilizados
SELECT cf.*
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
WHERE tf.FISCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CFOP
WHERE FISCFOP IS NULL
   OR FISCFOP = ''
   OR CFODESCRICAO IS NULL
   OR CFODESCRICAO = '';

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT FISCFOP, COUNT(*) AS QTD
FROM CFOP
GROUP BY FISCFOP
HAVING COUNT(*) > 1;

-- Verificar formato do código CFOP
SELECT *
FROM CFOP
WHERE LENGTH(FISCFOP) < 4
   OR LENGTH(FISCFOP) > 4
   OR NOT REGEXP_LIKE(FISCFOP, '^[0-9]+$');
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por tipo de operação
SELECT
    CASE 
        WHEN SUBSTR(FISCFOP, 1, 1) = '1' THEN 'Entrada - Estadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '2' THEN 'Entrada - Interestadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '3' THEN 'Entrada - Exterior'
        WHEN SUBSTR(FISCFOP, 1, 1) = '5' THEN 'Saída - Estadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '6' THEN 'Saída - Interestadual'
        WHEN SUBSTR(FISCFOP, 1, 1) = '7' THEN 'Saída - Exterior'
        ELSE 'Não identificado'
    END AS TIPO_OPERACAO,
    COUNT(*) AS TOTAL_CFOPS,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS
FROM CFOP cf
LEFT JOIN TBFIS tf ON tf.FISCFOP = cf.FISCFOP
GROUP BY SUBSTR(FISCFOP, 1, 1)
ORDER BY TIPO_OPERACAO;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Existente

O modelo `FirebirdCfop` já existe em `app/Models/Firebird/FirebirdCfop.php` e inclui:

**Funcionalidades Implementadas:**
- ✅ Relacionamento com TBFIS
- ✅ Métodos de classificação (isInternalOperation, isInterstateOperation, etc.)
- ✅ Scopes para filtros comuns (inputOperations, outputOperations, etc.)
- ✅ Formatação de código CFOP
- ✅ Método de estatísticas

**Melhorias Sugeridas:**

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCfop extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CFOP';
    
    protected $primaryKey = 'FISCFOP';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'FISCFOP' => 'string',
        'CFODESCRICAO' => 'string',
    ];

    // Relacionamento com TBFIS
    public function situacoesFiscais(): HasMany
    {
        return $this->hasMany(FirebirdTbfis::class, 'FISCFOP', 'FISCFOP');
    }

    // Relacionamento com movimentações (via TBFIS)
    public function movimentacoes(): HasManyThrough
    {
        return $this->hasManyThrough(
            FirebirdMovimentacao::class,
            FirebirdTbfis::class,
            'FISCFOP', // FK em TBFIS
            'FISCODIGO', // FK em MOVIMENTACAO
            'FISCFOP', // PK em CFOP
            'FISCODIGO' // PK em TBFIS
        );
    }

    // Relacionamento com notas fiscais (via TBFIS)
    public function notasFiscais(): HasManyThrough
    {
        return $this->hasManyThrough(
            FirebirdNotac::class,
            FirebirdTbfis::class,
            'FISCFOP',
            'FISCODIGO',
            'FISCFOP',
            'FISCODIGO'
        );
    }

    // Método para obter CSTs específicos por empresa
    public function getCstIcms(int $empCodigo): ?string
    {
        $situacao = $this->situacoesFiscais()
            ->whereHas('cstIcms', function($q) use ($empCodigo) {
                $q->where('EMPCODIGO', $empCodigo);
            })
            ->first();
        
        return $situacao?->cstIcms?->CST;
    }

    // Método para obter total de uso
    public function getTotalUso(): int
    {
        return $this->situacoesFiscais()
            ->withCount('movimentacoes')
            ->get()
            ->sum('movimentacoes_count');
    }

    // Scope para CFOPs mais utilizados
    public function scopeMaisUtilizados($query, int $limit = 10)
    {
        return $query->withCount('situacoesFiscais')
            ->orderBy('situacoes_fiscais_count', 'desc')
            ->limit($limit);
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Tabela mestre** - Catálogo oficial de códigos CFOP
2. **Códigos padronizados** - Seguir tabela oficial da Receita Federal
3. **Validação obrigatória** - CFOP deve estar cadastrado antes de uso
4. **Descrições atualizadas** - Manter descrições conforme legislação

### Segurança

1. **Dados fiscais críticos** - Não permitir alterações sem auditoria
2. **Validação de códigos** - Verificar formato e validade dos CFOPs
3. **Acesso restrito** - Limitar alterações a usuários autorizados
4. **Auditoria** - Registrar todas as alterações em CFOPs

### Performance

1. **Tabela pequena** - Não requer otimização especial (620 registros)
2. **Cache útil** - Pode ser mantida em memória permanentemente
3. **Índices nas tabelas relacionadas** - Mais importante que índices em CFOP
4. **Consultas simples** - Queries são rápidas devido ao volume moderado

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código já existe
2. **Verificar duplicatas** - PK garante unicidade
3. **Manter consistência** - Garantir que CFOPs referenciados existem
4. **Backup regular** - Tabela crítica para compliance fiscal

### Manutenção

1. **Atualização periódica** - Verificar novos CFOPs da Receita Federal
2. **Revisão de uso** - Identificar CFOPs não utilizados
3. **Documentação** - Manter descrições atualizadas conforme legislação
4. **Testes** - Validar CFOPs antes de usar em produção

### Regras de Negócio

1. **CFOP obrigatório** - Todas as operações fiscais devem ter CFOP
2. **Validação em tempo real** - Verificar se CFOP existe antes de usar
3. **Consistência** - CFOP deve corresponder ao tipo de operação
4. **Compliance** - Seguir tabela oficial da Receita Federal

### Observações Especiais

1. **Tabela oficial** - Códigos CFOP são padronizados pela Receita Federal
2. **Não modificar códigos** - Apenas adicionar novos quando necessário
3. **Relacionamento indireto** - CFOP é usado através de TBFIS
4. **Uso amplo** - CFOP está presente em praticamente todas as operações fiscais

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

