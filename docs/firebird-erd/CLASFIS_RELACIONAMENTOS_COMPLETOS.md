# CLASFIS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLASFIS (Classificação Fiscal)
- **Total de Registros**: 11.725
- **Total de Colunas**: 11
- **Chave Primária**: CLFCODIGO (VARCHAR)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0 (Relacionamentos Lógicos)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLASFIS** é uma tabela mestre que armazena informações completas de classificação fiscal brasileira, baseada na **NCM (Nomenclatura Comum do Mercosul)**. Com **11.725 registros**, representa um catálogo completo de códigos de classificação fiscal com informações tributárias detalhadas para cada código.

Esta tabela funciona como **catálogo fiscal tributário** e permite:
- Armazenar códigos NCM com informações tributárias completas
- Controlar classificação IPI (CLFCLASIPI e CLFEXTIPI)
- Gerenciar códigos CEST (Código Especificador da Substituição Tributária)
- Armazenar alíquotas tributárias totais (federal, estadual, municipal)
- Controlar percentuais de ICMS por classificação fiscal
- Gerenciar vigência de cada classificação fiscal
- Suportar cálculos fiscais automatizados
- Garantir compliance tributário em documentos fiscais

Cada registro representa uma classificação fiscal específica (NCM), contendo:
- Código da classificação fiscal (CLFCODIGO) - geralmente código NCM
- Descrição da classificação (CLFDESCRICAO)
- Classificação IPI (CLFCLASIPI e CLFEXTIPI)
- Código CEST (CLFCEST) - quando aplicável
- Alíquotas tributárias totais (federal, estadual, municipal)
- Percentual de ICMS (CLFPCICMS)
- Período de vigência (CLFDTINICIOVIG, CLFDTFIMVIG)

O sistema utiliza esta tabela como referência para cálculos fiscais e classificação de produtos em documentos fiscais, garantindo que cada produto seja classificado corretamente conforme a legislação brasileira.

**Observação Importante:** CLASFIS não possui foreign keys diretas, mas é utilizada logicamente através de códigos NCM em outras tabelas, especialmente em PRODU (campo PROCLASFISCAL) e em documentos fiscais como NFPRO, NFEPRO, etc.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFCODIGO** 🔑 | VARCHAR(14) | ✓ | Código da classificação fiscal (PK) - Geralmente código NCM (8 dígitos) |

### Informações Básicas
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFDESCRICAO** | VARCHAR(37) | | Descrição da classificação fiscal conforme legislação |

### Classificação IPI
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFCLASIPI** | VARCHAR(37) | | Classificação IPI (Código da TIPI - Tabela de Incidência do IPI) |
| **CLFEXTIPI** | VARCHAR(37) | | Extensão IPI (2 dígitos adicionais para especificação) |

### Código CEST
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFCEST** | VARCHAR(37) | | Código CEST (Código Especificador da Substituição Tributária) |

### Alíquotas Tributárias Totais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFALIQTOTTRIB** | NUMERIC(16,4) | | Alíquota total tributária (federal) |
| **CLFALIQTOTTRIBUF** | NUMERIC(16,4) | | Alíquota total tributária estadual |
| **CLFALIQTOTTRIBMUN** | NUMERIC(16,4) | | Alíquota total tributária municipal |

### Percentual ICMS
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFPCICMS** | NUMERIC(16,4) | | Percentual de ICMS da classificação fiscal |

### Vigência
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLFDTINICIOVIG** | DATE | | Data de início de vigência da classificação |
| **CLFDTFIMVIG** | DATE | | Data de fim de vigência da classificação (NULL = vigente) |

**Primary Key:** CLFCODIGO

**Observações sobre Campos:**
- **CLFCODIGO**: Geralmente código NCM de 8 dígitos, mas pode ter variações ou códigos específicos do sistema.
- **CLFCLASIPI + CLFEXTIPI**: Formam a classificação completa IPI (ex: "1234" + "56" = "123456").
- **CLFCEST**: Código de 7 dígitos utilizado para produtos sujeitos à substituição tributária de ICMS.
- **CLFALIQTOTTRIB**: Soma de todos os impostos federais (IPI, PIS, COFINS, etc.).
- **CLFPCICMS**: Percentual de ICMS específico para esta classificação fiscal.
- **Vigência**: Permite controle histórico de mudanças na classificação fiscal ao longo do tempo.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLASFIS Referencia

**Nenhuma tabela** é referenciada diretamente por CLASFIS. Esta é uma tabela mestre sem dependências externas.

---

### CLASFIS é Referenciada Por

**Nenhuma foreign key direta** referencia CLASFIS. No entanto, existem **relacionamentos lógicos** através de códigos NCM/classificação fiscal em outras tabelas.

---

## 🔗 Relacionamentos - Nível 2 (Lógicos)

### Relacionamentos Lógicos Identificados

#### 1. PRODU - Produtos (Lógico)
**Relacionamento Lógico:**
```
PRODU.PROCLASFISCAL = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: Produtos podem estar vinculados a uma classificação fiscal específica através do campo PROCLASFISCAL.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos
- **FK Out:** 0
- **FK In:** 101 tabelas

**Campos importantes em PRODU relacionados a CLASFIS:**
- `PROCLASFISCAL` - Classificação fiscal do produto (NCM)
- `PROPCIPI` - Percentual de IPI do produto
- `PROPCICMS` - Percentual de ICMS do produto
- `PROPCPIS` - Percentual de PIS
- `PROPCCOFINS` - Percentual de COFINS

**Uso:** Identificar classificação fiscal de produtos, cálculos fiscais automáticos, emissão de documentos fiscais.

---

#### 2. NFPRO - Produtos em Notas Fiscais (Lógico)
**Relacionamento Lógico:**
```
NFPRO.NFPCNCM = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: Itens de notas fiscais podem referenciar classificação fiscal através do código NCM.

**Informações da Tabela NFPRO:**
- **Total:** Volume muito alto (milhões de registros)
- **PK:** (NFCODIGO, NFPSEQ, EMPCODIGO)
- **Colunas:** 101 campos
- **FK Out:** Múltiplas (PRODU, NOTAS, TBFIS, etc.)

**Campos importantes em NFPRO relacionados a CLASFIS:**
- `NFPCNCM` - Código NCM do produto na nota fiscal
- `NFPCEST` - Código CEST do produto
- `NFPCIPI` - Classificação IPI
- `NFPCIPIEXT` - Extensão IPI

**Uso:** Classificação fiscal de produtos em documentos fiscais, cálculos de impostos em notas fiscais.

---

#### 3. NFEPRO - Produtos em NFe (Lógico)
**Relacionamento Lógico:**
```
NFEPRO.NFEPNCM = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: Itens de notas fiscais eletrônicas podem referenciar classificação fiscal através do código NCM.

**Informações da Tabela NFEPRO:**
- **Total:** Volume muito alto
- **PK:** (EMPCODIGO, NFECODIGO, NFESEQ)
- **Colunas:** Múltiplos campos
- **FK Out:** Múltiplas (PRODU, NOTAS, etc.)

**Campos importantes em NFEPRO relacionados a CLASFIS:**
- `NFEPNCM` - Código NCM do produto na NFe
- `NFEPCEST` - Código CEST do produto
- `NFEPCIPI` - Classificação IPI
- `NFEPCIPIEXT` - Extensão IPI

**Uso:** Classificação fiscal de produtos em NFe, cálculos de impostos em notas fiscais eletrônicas.

---

#### 4. TBNCM - Tabela NCM (Lógico)
**Relacionamento Lógico:**
```
TBNCM.CODNCM = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: TBNCM armazena códigos NCM básicos, enquanto CLASFIS armazena informações tributárias detalhadas para cada NCM.

**Informações da Tabela TBNCM:**
- **Total:** 10.249 registros
- **PK:** ID_TBNCM
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 0

**Campos importantes em TBNCM:**
- `CODNCM` - Código NCM
- `DTINI` - Data início de vigência
- `DTFIM` - Data fim de vigência
- `UNTRIB` - Unidade tributável

**Uso:** CLASFIS complementa TBNCM com informações tributárias detalhadas (alíquotas, CEST, IPI).

---

#### 5. MOVIMENTACAO - Movimentações Fiscais (Lógico)
**Relacionamento Lógico:**
```
MOVIMENTACAO.NCM = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: Movimentações fiscais podem referenciar classificação fiscal através do código NCM.

**Informações da Tabela MOVIMENTACAO:**
- **Total:** 70.939.930 registros (maior volume)
- **PK:** Variável
- **Colunas:** Múltiplos campos
- **FK Out:** Múltiplas

**Campos importantes em MOVIMENTACAO relacionados a CLASFIS:**
- `NCM` - Código NCM da movimentação
- `FISCODIGO` - Código fiscal da movimentação

**Uso:** Rastreamento fiscal de movimentações, cálculos de impostos em movimentações.

---

#### 6. PDPRD - Produtos em Pedidos (Lógico)
**Relacionamento Lógico:**
```
PDPRD.PDPNCM = CLASFIS.CLFCODIGO (Lógico)
```

**Descrição**: Produtos em pedidos podem referenciar classificação fiscal através do código NCM.

**Informações da Tabela PDPRD:**
- **Total:** 6.710.760 registros
- **PK:** (ID_PEDIDO, PDPSEQ)
- **Colunas:** Múltiplos campos
- **FK Out:** Múltiplas (PRODU, PEDID, TBFIS, etc.)

**Uso:** Classificação fiscal de produtos em pedidos, cálculos fiscais em pedidos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Classificação Fiscal

**Objetivo:** Obter visão completa de uma classificação fiscal incluindo produtos e documentos fiscais relacionados.

**Fluxo:**
```
CLASFIS (CLFCODIGO)
  ↓ [Lógico]
PRODU (PROCLASFISCAL)
  ↓ PROCODIGO
NFPRO (PROCODIGO)
  ↓ NFCODIGO
NOTAS (NFCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cf.CLFCODIGO AS CODIGO_NCM,
    cf.CLFDESCRICAO AS DESCRICAO_NCM,
    cf.CLFCLASIPI AS CLASSIFICACAO_IPI,
    cf.CLFEXTIPI AS EXTENSAO_IPI,
    cf.CLFCEST AS CODIGO_CEST,
    cf.CLFPCICMS AS PERCENTUAL_ICMS,
    cf.CLFALIQTOTTRIB AS ALIQUOTA_TOTAL_TRIBUTARIA,
    cf.CLFDTINICIOVIG AS DATA_INICIO_VIGENCIA,
    cf.CLFDTFIMVIG AS DATA_FIM_VIGENCIA,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS_FISCAIS,
    COUNT(DISTINCT nfp.NFPSEQ) AS TOTAL_ITENS_NF,
    SUM(nfp.NFPVRMERC) AS VALOR_TOTAL_VENDAS
FROM CLASFIS cf
LEFT JOIN PRODU p ON p.PROCLASFISCAL = cf.CLFCODIGO
LEFT JOIN NFPRO nfp ON nfp.NFPCNCM = cf.CLFCODIGO
LEFT JOIN NOTAS nf ON nf.NFCODIGO = nfp.NFCODIGO 
    AND nf.EMPCODIGO = nfp.EMPCODIGO
WHERE cf.CLFCODIGO = ?
GROUP BY cf.CLFCODIGO, cf.CLFDESCRICAO, cf.CLFCLASIPI, cf.CLFEXTIPI, 
    cf.CLFCEST, cf.CLFPCICMS, cf.CLFALIQTOTTRIB, cf.CLFDTINICIOVIG, cf.CLFDTFIMVIG;
```

---

### Exemplo 2: Análise de Classificações Fiscais por Vigência

**Objetivo:** Identificar classificações fiscais vigentes e suas utilizações.

**Fluxo:**
```
CLASFIS (CLFCODIGO)
  ↓ [Lógico]
PRODU (PROCLASFISCAL)
```

**Query SQL:**
```sql
SELECT
    cf.CLFCODIGO AS CODIGO_NCM,
    cf.CLFDESCRICAO AS DESCRICAO_NCM,
    cf.CLFDTINICIOVIG AS DATA_INICIO_VIGENCIA,
    cf.CLFDTFIMVIG AS DATA_FIM_VIGENCIA,
    CASE 
        WHEN cf.CLFDTFIMVIG IS NULL THEN 'VIGENTE'
        WHEN cf.CLFDTFIMVIG < CURRENT_DATE THEN 'VENCIDA'
        ELSE 'VIGENTE ATÉ ' || TO_CHAR(cf.CLFDTFIMVIG, 'DD/MM/YYYY')
    END AS STATUS_VIGENCIA,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT CASE WHEN p.PROSITUACAO = 'ATIVO' THEN p.PROCODIGO END) AS PRODUTOS_ATIVOS
FROM CLASFIS cf
LEFT JOIN PRODU p ON p.PROCLASFISCAL = cf.CLFCODIGO
WHERE cf.CLFDTINICIOVIG IS NOT NULL
GROUP BY cf.CLFCODIGO, cf.CLFDESCRICAO, cf.CLFDTINICIOVIG, cf.CLFDTFIMVIG
ORDER BY cf.CLFDTINICIOVIG DESC;
```

---

### Exemplo 3: Análise de Classificações Fiscais com CEST

**Objetivo:** Identificar classificações fiscais que possuem código CEST (Substituição Tributária).

**Fluxo:**
```
CLASFIS (CLFCODIGO, CLFCEST)
  ↓ [Lógico]
PRODU (PROCLASFISCAL)
  ↓ PROCODIGO
NFPRO (PROCODIGO, NFPCEST)
```

**Query SQL:**
```sql
SELECT
    cf.CLFCODIGO AS CODIGO_NCM,
    cf.CLFDESCRICAO AS DESCRICAO_NCM,
    cf.CLFCEST AS CODIGO_CEST,
    cf.CLFPCICMS AS PERCENTUAL_ICMS,
    cf.CLFALIQTOTTRIB AS ALIQUOTA_TOTAL_TRIBUTARIA,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT nfp.NFCODIGO) AS TOTAL_NOTAS_FISCAIS,
    SUM(nfp.NFPVRMERC) AS VALOR_TOTAL_VENDAS
FROM CLASFIS cf
LEFT JOIN PRODU p ON p.PROCLASFISCAL = cf.CLFCODIGO
LEFT JOIN NFPRO nfp ON nfp.NFPCNCM = cf.CLFCODIGO
WHERE cf.CLFCEST IS NOT NULL
  AND cf.CLFCEST <> ''
GROUP BY cf.CLFCODIGO, cf.CLFDESCRICAO, cf.CLFCEST, cf.CLFPCICMS, cf.CLFALIQTOTTRIB
ORDER BY VALOR_TOTAL_VENDAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Classificação Fiscal Completa

**Objetivo:** Obter todas as informações de uma classificação fiscal específica.

```sql
SELECT
    CLFCODIGO AS CODIGO_NCM,
    CLFDESCRICAO AS DESCRICAO,
    CLFCLASIPI AS CLASSIFICACAO_IPI,
    CLFEXTIPI AS EXTENSAO_IPI,
    CLFCEST AS CODIGO_CEST,
    CLFPCICMS AS PERCENTUAL_ICMS,
    CLFALIQTOTTRIB AS ALIQUOTA_TOTAL_TRIBUTARIA,
    CLFALIQTOTTRIBUF AS ALIQUOTA_TOTAL_ESTADUAL,
    CLFALIQTOTTRIBMUN AS ALIQUOTA_TOTAL_MUNICIPAL,
    CLFDTINICIOVIG AS DATA_INICIO_VIGENCIA,
    CLFDTFIMVIG AS DATA_FIM_VIGENCIA
FROM CLASFIS
WHERE CLFCODIGO = ?;
```

---

### 2. Listar Classificações Fiscais Vigentes

**Objetivo:** Obter todas as classificações fiscais que estão atualmente vigentes.

```sql
SELECT
    CLFCODIGO AS CODIGO_NCM,
    CLFDESCRICAO AS DESCRICAO,
    CLFPCICMS AS PERCENTUAL_ICMS,
    CLFALIQTOTTRIB AS ALIQUOTA_TOTAL_TRIBUTARIA,
    CLFDTINICIOVIG AS DATA_INICIO_VIGENCIA,
    CLFDTFIMVIG AS DATA_FIM_VIGENCIA
FROM CLASFIS
WHERE (CLFDTFIMVIG IS NULL OR CLFDTFIMVIG >= CURRENT_DATE)
  AND (CLFDTINICIOVIG IS NULL OR CLFDTINICIOVIG <= CURRENT_DATE)
ORDER BY CLFCODIGO;
```

---

### 3. Análise de Classificações Fiscais por Alíquota ICMS

**Objetivo:** Identificar classificações fiscais agrupadas por percentual de ICMS.

```sql
SELECT
    CLFPCICMS AS PERCENTUAL_ICMS,
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(DISTINCT CASE WHEN CLFCEST IS NOT NULL AND CLFCEST <> '' THEN CLFCODIGO END) AS COM_CEST,
    AVG(CLFALIQTOTTRIB) AS MEDIA_ALIQUOTA_TOTAL_TRIBUTARIA,
    MIN(CLFALIQTOTTRIB) AS MIN_ALIQUOTA_TOTAL_TRIBUTARIA,
    MAX(CLFALIQTOTTRIB) AS MAX_ALIQUOTA_TOTAL_TRIBUTARIA
FROM CLASFIS
WHERE CLFPCICMS IS NOT NULL
GROUP BY CLFPCICMS
ORDER BY CLFPCICMS;
```

---

### 4. Relatório de Classificações Fiscais com Maior Número de Produtos

**Objetivo:** Analisar classificações fiscais com maior concentração de produtos.

```sql
SELECT
    cf.CLFCODIGO AS CODIGO_NCM,
    cf.CLFDESCRICAO AS DESCRICAO_NCM,
    cf.CLFPCICMS AS PERCENTUAL_ICMS,
    cf.CLFCEST AS CODIGO_CEST,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT CASE WHEN p.PROSITUACAO = 'ATIVO' THEN p.PROCODIGO END) AS PRODUTOS_ATIVOS,
    ROUND(COUNT(DISTINCT p.PROCODIGO) * 100.0 / NULLIF((SELECT COUNT(*) FROM PRODU), 0), 2) AS PERCENTUAL_PRODUTOS
FROM CLASFIS cf
LEFT JOIN PRODU p ON p.PROCLASFISCAL = cf.CLFCODIGO
GROUP BY cf.CLFCODIGO, cf.CLFDESCRICAO, cf.CLFPCICMS, cf.CLFCEST
HAVING COUNT(DISTINCT p.PROCODIGO) > 0
ORDER BY TOTAL_PRODUTOS DESC;
```

---

### 5. Análise de Classificações Fiscais com IPI

**Objetivo:** Identificar classificações fiscais que possuem classificação IPI configurada.

```sql
SELECT
    CLFCODIGO AS CODIGO_NCM,
    CLFDESCRICAO AS DESCRICAO,
    CLFCLASIPI AS CLASSIFICACAO_IPI,
    CLFEXTIPI AS EXTENSAO_IPI,
    CLFCLASIPI || COALESCE(CLFEXTIPI, '') AS CLASSIFICACAO_IPI_COMPLETA,
    CLFPCICMS AS PERCENTUAL_ICMS,
    CLFALIQTOTTRIB AS ALIQUOTA_TOTAL_TRIBUTARIA
FROM CLASFIS
WHERE CLFCLASIPI IS NOT NULL
  AND CLFCLASIPI <> ''
ORDER BY CLFCLASIPI, CLFEXTIPI;
```

---

### 6. Relatório de Classificações Fiscais por Período de Vigência

**Objetivo:** Analisar distribuição de classificações fiscais por período de vigência.

```sql
SELECT
    CASE 
        WHEN CLFDTFIMVIG IS NULL THEN 'VIGENTE INDEFINIDAMENTE'
        WHEN CLFDTFIMVIG < CURRENT_DATE THEN 'VENCIDA'
        WHEN CLFDTFIMVIG >= CURRENT_DATE THEN 'VIGENTE ATÉ ' || TO_CHAR(CLFDTFIMVIG, 'DD/MM/YYYY')
        ELSE 'SEM DATA DE VIGÊNCIA'
    END AS STATUS_VIGENCIA,
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(CASE WHEN CLFCEST IS NOT NULL AND CLFCEST <> '' THEN 1 END) AS COM_CEST,
    AVG(CLFPCICMS) AS MEDIA_PERCENTUAL_ICMS,
    AVG(CLFALIQTOTTRIB) AS MEDIA_ALIQUOTA_TOTAL_TRIBUTARIA
FROM CLASFIS
GROUP BY 
    CASE 
        WHEN CLFDTFIMVIG IS NULL THEN 'VIGENTE INDEFINIDAMENTE'
        WHEN CLFDTFIMVIG < CURRENT_DATE THEN 'VENCIDA'
        WHEN CLFDTFIMVIG >= CURRENT_DATE THEN 'VIGENTE ATÉ ' || TO_CHAR(CLFDTFIMVIG, 'DD/MM/YYYY')
        ELSE 'SEM DATA DE VIGÊNCIA'
    END
ORDER BY STATUS_VIGENCIA;
```

---

### 7. Verificar Classificações Fiscais Não Utilizadas

**Objetivo:** Identificar classificações fiscais que não estão sendo utilizadas em produtos.

```sql
SELECT
    cf.CLFCODIGO AS CODIGO_NCM,
    cf.CLFDESCRICAO AS DESCRICAO_NCM,
    cf.CLFPCICMS AS PERCENTUAL_ICMS,
    cf.CLFDTINICIOVIG AS DATA_INICIO_VIGENCIA,
    cf.CLFDTFIMVIG AS DATA_FIM_VIGENCIA,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT nfp.NFCODIGO) AS TOTAL_NOTAS_FISCAIS
FROM CLASFIS cf
LEFT JOIN PRODU p ON p.PROCLASFISCAL = cf.CLFCODIGO
LEFT JOIN NFPRO nfp ON nfp.NFPCNCM = cf.CLFCODIGO
GROUP BY cf.CLFCODIGO, cf.CLFDESCRICAO, cf.CLFPCICMS, cf.CLFDTINICIOVIG, cf.CLFDTFIMVIG
HAVING COUNT(DISTINCT p.PROCODIGO) = 0
   AND COUNT(DISTINCT nfp.NFCODIGO) = 0
ORDER BY cf.CLFCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLASFIS | Tipo |
|--------|-----------|---------------------|------|
| **CLASFIS** | 11.725 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | 178.187 | 15.2:1 | Produtos (média de 15.2 produtos por classificação) |
| TBNCM | 10.249 | 0.87:1 | Tabela NCM básica (relação próxima) |
| NFPRO | Milhões | Muito alta | Itens de notas fiscais |
| NFEPRO | Milhões | Muito alta | Itens de NFe |
| MOVIMENTACAO | 70.939.930 | Muito alta | Movimentações fiscais |

**Interpretação:**
- **11.725 classificações fiscais** cadastradas no sistema
- **Alta concentração** de produtos por classificação (média de 15.2 produtos)
- **Relação próxima com TBNCM** - CLASFIS complementa TBNCM com informações tributárias
- **Amplamente utilizada** em documentos fiscais e movimentações

**Distribuição Esperada:**
- Classificações com muitos produtos: NCMs comuns no negócio
- Classificações com poucos produtos: NCMs específicos ou pouco utilizados
- Classificações não utilizadas: podem ser NCMs cadastrados mas não utilizados ainda

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLFCODIGO** | CLASFIS | Chave primária (PK) |
| **CLFCODIGO** | [Lógico] → PRODU.PROCLASFISCAL | Classificação fiscal de produtos |
| **CLFCODIGO** | [Lógico] → NFPRO.NFPCNCM | Classificação fiscal em notas fiscais |
| **CLFCODIGO** | [Lógico] → NFEPRO.NFEPNCM | Classificação fiscal em NFe |
| **CLFCODIGO** | [Lógico] → MOVIMENTACAO.NCM | Classificação fiscal em movimentações |
| **CLFCEST** | CLASFIS | Código CEST (Substituição Tributária) |
| **CLFCLASIPI + CLFEXTIPI** | CLASFIS | Classificação IPI completa |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLASFIS.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por código NCM** - Para buscas por código
3. **Índice por CEST** - Para buscas por código CEST
4. **Índice por vigência** - Para consultas por período de vigência
5. **Índices nas tabelas relacionadas** - Mais críticos que índices em CLASFIS

### Índices Sugeridos

```sql
-- Índice 1: Busca por código NCM (consultas frequentes)
CREATE INDEX IDX_CLASFIS_CODIGO ON CLASFIS(CLFCODIGO);

-- Índice 2: Busca por CEST (consultas de substituição tributária)
CREATE INDEX IDX_CLASFIS_CEST ON CLASFIS(CLFCEST) WHERE CLFCEST IS NOT NULL;

-- Índice 3: Busca por classificação IPI (consultas fiscais)
CREATE INDEX IDX_CLASFIS_IPI ON CLASFIS(CLFCLASIPI, CLFEXTIPI) 
    WHERE CLFCLASIPI IS NOT NULL;

-- Índice 4: Busca por vigência (consultas por período)
CREATE INDEX IDX_CLASFIS_VIGENCIA ON CLASFIS(CLFDTINICIOVIG, CLFDTFIMVIG);

-- Índice 5: Busca por percentual ICMS (análises fiscais)
CREATE INDEX IDX_CLASFIS_ICMS ON CLASFIS(CLFPCICMS) WHERE CLFPCICMS IS NOT NULL;

-- Índice 6: Busca por descrição (consultas textuais)
CREATE INDEX IDX_CLASFIS_DESCRICAO ON CLASFIS(CLFDESCRICAO);
```

### Observações sobre Volume

- **Tabela média** (11.725 registros) - Performance moderada
- **Consultas são rápidas** devido ao volume moderado
- **Índices úteis** para buscas por código, CEST e IPI
- **Focar em índices nas tabelas relacionadas** - PRODU e NFPRO têm volumes muito maiores

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK)
SELECT CLFCODIGO, CLFDESCRICAO, CLFPCICMS
FROM CLASFIS
WHERE CLFCODIGO = ?;

-- ✅ OTIMIZADO (usar índice em CLFCEST)
SELECT CLFCODIGO, CLFDESCRICAO, CLFCEST
FROM CLASFIS
WHERE CLFCEST = ?;

-- ✅ OTIMIZADO (usar índice em CLFCLASIPI)
SELECT CLFCODIGO, CLFDESCRICAO, CLFCLASIPI, CLFEXTIPI
FROM CLASFIS
WHERE CLFCLASIPI = ?
ORDER BY CLFEXTIPI;

-- ✅ OTIMIZADO (usar índice em vigência)
SELECT CLFCODIGO, CLFDESCRICAO, CLFDTINICIOVIG, CLFDTFIMVIG
FROM CLASFIS
WHERE CLFDTINICIOVIG <= CURRENT_DATE
  AND (CLFDTFIMVIG IS NULL OR CLFDTFIMVIG >= CURRENT_DATE)
ORDER BY CLFCODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLASFIS
WHERE CLFCODIGO IS NULL
   OR CLFCODIGO = '';

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CLFCODIGO, COUNT(*) AS QTD
FROM CLASFIS
GROUP BY CLFCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos de alíquotas
SELECT *
FROM CLASFIS
WHERE CLFPCICMS IS NOT NULL
  AND (CLFPCICMS < 0 OR CLFPCICMS > 100)
   OR (CLFALIQTOTTRIB IS NOT NULL AND (CLFALIQTOTTRIB < 0 OR CLFALIQTOTTRIB > 100))
   OR (CLFALIQTOTTRIBUF IS NOT NULL AND (CLFALIQTOTTRIBUF < 0 OR CLFALIQTOTTRIBUF > 100))
   OR (CLFALIQTOTTRIBMUN IS NOT NULL AND (CLFALIQTOTTRIBMUN < 0 OR CLFALIQTOTTRIBMUN > 100));

-- Verificar datas de vigência inconsistentes
SELECT *
FROM CLASFIS
WHERE CLFDTINICIOVIG IS NOT NULL
  AND CLFDTFIMVIG IS NOT NULL
  AND CLFDTFIMVIG < CLFDTINICIOVIG;

-- Verificar formato de código NCM (geralmente 8 dígitos)
SELECT *
FROM CLASFIS
WHERE CLFCODIGO IS NOT NULL
  AND LENGTH(TRIM(CLFCODIGO)) NOT IN (8, 10); -- 8 dígitos NCM ou 10 com extensão

-- Verificar formato de CEST (deve ser 7 dígitos quando preenchido)
SELECT *
FROM CLASFIS
WHERE CLFCEST IS NOT NULL
  AND CLFCEST <> ''
  AND LENGTH(TRIM(CLFCEST)) <> 7;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por percentual ICMS
SELECT
    CLFPCICMS AS PERCENTUAL_ICMS,
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(CASE WHEN CLFCEST IS NOT NULL AND CLFCEST <> '' THEN 1 END) AS COM_CEST,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CLASFIS), 0), 2) AS PERCENTUAL
FROM CLASFIS
WHERE CLFPCICMS IS NOT NULL
GROUP BY CLFPCICMS
ORDER BY CLFPCICMS;

-- Verificar classificações com IPI
SELECT
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(CASE WHEN CLFCLASIPI IS NOT NULL AND CLFCLASIPI <> '' THEN 1 END) AS COM_IPI,
    COUNT(CASE WHEN CLFCEST IS NOT NULL AND CLFCEST <> '' THEN 1 END) AS COM_CEST,
    ROUND(COUNT(CASE WHEN CLFCLASIPI IS NOT NULL AND CLFCLASIPI <> '' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS PERCENTUAL_COM_IPI,
    ROUND(COUNT(CASE WHEN CLFCEST IS NOT NULL AND CLFCEST <> '' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS PERCENTUAL_COM_CEST
FROM CLASFIS;

-- Verificar classificações vigentes vs vencidas
SELECT
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(CASE WHEN CLFDTFIMVIG IS NULL OR CLFDTFIMVIG >= CURRENT_DATE THEN 1 END) AS VIGENTES,
    COUNT(CASE WHEN CLFDTFIMVIG IS NOT NULL AND CLFDTFIMVIG < CURRENT_DATE THEN 1 END) AS VENCIDAS,
    COUNT(CASE WHEN CLFDTINICIOVIG IS NULL THEN 1 END) AS SEM_DATA_INICIO
FROM CLASFIS;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdClasfis extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLASFIS';
    
    protected $primaryKey = 'CLFCODIGO';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLFCODIGO' => 'string',
        'CLFDESCRICAO' => 'string',
        'CLFCLASIPI' => 'string',
        'CLFEXTIPI' => 'string',
        'CLFCEST' => 'string',
        'CLFPCICMS' => 'decimal:4',
        'CLFALIQTOTTRIB' => 'decimal:4',
        'CLFALIQTOTTRIBUF' => 'decimal:4',
        'CLFALIQTOTTRIBMUN' => 'decimal:4',
        'CLFDTINICIOVIG' => 'date',
        'CLFDTFIMVIG' => 'date',
    ];

    // Relacionamento lógico com produtos (via PROCLASFISCAL)
    public function produtos(): HasMany
    {
        return $this->hasMany(FirebirdProdu::class, 'PROCLASFISCAL', 'CLFCODIGO');
    }

    // Método para verificar se está vigente
    public function isVigente(): bool
    {
        $hoje = now()->toDateString();
        
        if ($this->CLFDTINICIOVIG && $this->CLFDTINICIOVIG > $hoje) {
            return false;
        }
        
        if ($this->CLFDTFIMVIG && $this->CLFDTFIMVIG < $hoje) {
            return false;
        }
        
        return true;
    }

    // Método para verificar se tem CEST
    public function temCEST(): bool
    {
        return !empty($this->CLFCEST);
    }

    // Método para verificar se tem IPI
    public function temIPI(): bool
    {
        return !empty($this->CLFCLASIPI);
    }

    // Método para obter classificação IPI completa
    public function getClassificacaoIPICompleta(): ?string
    {
        if (!$this->CLFCLASIPI) {
            return null;
        }
        
        return $this->CLFCLASIPI . ($this->CLFEXTIPI ?? '');
    }

    // Método para obter total de produtos
    public function getTotalProdutos(): int
    {
        return $this->produtos()->count();
    }

    // Scope para filtrar classificações vigentes
    public function scopeVigentes($query)
    {
        $hoje = now()->toDateString();
        
        return $query->where(function($q) use ($hoje) {
            $q->whereNull('CLFDTINICIOVIG')
              ->orWhere('CLFDTINICIOVIG', '<=', $hoje);
        })
        ->where(function($q) use ($hoje) {
            $q->whereNull('CLFDTFIMVIG')
              ->orWhere('CLFDTFIMVIG', '>=', $hoje);
        });
    }

    // Scope para filtrar por CEST
    public function scopeComCEST($query)
    {
        return $query->whereNotNull('CLFCEST')
            ->where('CLFCEST', '<>', '');
    }

    // Scope para filtrar por IPI
    public function scopeComIPI($query)
    {
        return $query->whereNotNull('CLFCLASIPI')
            ->where('CLFCLASIPI', '<>', '');
    }

    // Scope para buscar por código NCM
    public function scopePorCodigo($query, string $codigo)
    {
        return $query->where('CLFCODIGO', $codigo);
    }

    // Scope para buscar por CEST
    public function scopePorCEST($query, string $cest)
    {
        return $query->where('CLFCEST', $cest);
    }

    // Scope para buscar por classificação IPI
    public function scopePorIPI($query, string $clasIPI, ?string $extIPI = null)
    {
        $query->where('CLFCLASIPI', $clasIPI);
        
        if ($extIPI !== null) {
            $query->where('CLFEXTIPI', $extIPI);
        }
        
        return $query;
    }

    // Scope para buscar por percentual ICMS
    public function scopePorICMS($query, float $percentual)
    {
        return $query->where('CLFPCICMS', $percentual);
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_classificacoes' => self::count(),
            'com_cest' => self::comCEST()->count(),
            'com_ipi' => self::comIPI()->count(),
            'vigentes' => self::vigentes()->count(),
            'vencidas' => self::whereNotNull('CLFDTFIMVIG')
                ->where('CLFDTFIMVIG', '<', now()->toDateString())
                ->count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - CLFCODIGO é único e identifica cada classificação fiscal
2. **Validação antes de inserir** - Verificar formato de código NCM (8 dígitos)
3. **Evitar duplicatas** - PK garante unicidade
4. **Manter consistência** - Códigos NCM devem seguir padrão brasileiro

### Performance

1. **Tabela média** - 11.725 registros, performance moderada
2. **Índices úteis** - Em CLFCODIGO, CLFCEST, CLFCLASIPI para buscas frequentes
3. **Cache útil** - Tabela pode ser mantida em memória para consultas rápidas
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CLASFIS

### Integridade de Dados

1. **Validação antes de inserir** - Verificar formato de códigos (NCM, CEST, IPI)
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Códigos devem seguir padrões brasileiros
4. **Validação de alíquotas** - Valores entre 0 e 100

### Manutenção

1. **Revisão periódica** - Verificar classificações vencidas e atualizar vigências
2. **Padronização** - Manter códigos NCM atualizados conforme legislação
3. **Atualização de alíquotas** - Manter alíquotas tributárias atualizadas
4. **Documentação** - Documentar mudanças na legislação fiscal

### Regras de Negócio

1. **Validação em tempo real** - Verificar se classificação fiscal existe antes de usar
2. **Consistência fiscal** - Classificação deve corresponder à legislação vigente
3. **Cálculos fiscais** - Usar alíquotas de CLASFIS para cálculos automáticos
4. **Vigência** - Verificar vigência antes de usar classificação fiscal

### Observações Especiais

1. **Sem FKs diretas** - CLASFIS não possui foreign keys, mas é usada logicamente
2. **Relacionamentos lógicos** - Relacionamentos através de códigos NCM em outras tabelas
3. **Informações tributárias** - Armazena alíquotas e percentuais para cálculos fiscais
4. **Compliance fiscal** - Essencial para compliance tributário brasileiro

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

