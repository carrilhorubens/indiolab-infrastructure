# BI_NOTAS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: BI_NOTAS (Business Intelligence - Notas Fiscais)
- **Total de Registros**: 1.473.539
- **Total de Colunas**: 7
- **Chave Primária**: ID_BI_NOTAS
- **Chaves Estrangeiras**: 0 (relacionamentos lógicos)
- **Índices**: 3
- **Tabelas Dependentes**: 0 (tabela de staging/BI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**BI_NOTAS** é uma tabela de Business Intelligence que armazena dados agregados e otimizados de notas fiscais para fins de relatórios e análises. Com **1.473.539 registros**, representa uma visão simplificada e performática das notas fiscais do sistema.

Esta tabela funciona como **tabela de staging/BI** e permite:
- Consultas rápidas de notas fiscais sem necessidade de JOINs complexos
- Análises de performance e relatórios de Business Intelligence
- Rastreamento de exportação e processamento de notas
- Filtros otimizados por empresa, código de nota e data de emissão

Cada registro representa uma nota fiscal processada para BI, contendo:
- Identificador único (ID_BI_NOTAS)
- Empresa relacionada (EMPCODIGO)
- Código da nota fiscal (NFCODIGO)
- Data de emissão (NFDTEMIS)
- Situação da nota (NFSIT)
- Data de exportação (NFDTEXP) - quando aplicável
- Arquivo relacionado (NFARQUIVO) - quando aplicável

O sistema utiliza esta tabela para otimizar consultas de relatórios e dashboards, evitando a necessidade de acessar tabelas transacionais complexas como NOTAS ou NOTAE diretamente.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ID_BI_NOTAS** 🔑 | INTEGER | Identificador único do registro (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **EMPCODIGO** | INTEGER | Código da empresa (lógico → EMPRESA) |
| **NFCODIGO** | VARCHAR(14) | Código da nota fiscal (lógico → NOTAS/NOTAE) |

### Dados Temporais
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **NFDTEMIS** | DATE | Data de emissão da nota fiscal |
| **NFDTEXP** | DATE | Data de exportação/processamento (opcional) |

### Controle e Status
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **NFSIT** | VARCHAR(14) | Situação da nota fiscal (N=Normal, C=Cancelada, etc.) |
| **NFARQUIVO** | VARCHAR(37) | Nome do arquivo relacionado (opcional) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

BI_NOTAS **não possui chaves estrangeiras formais**, mas possui relacionamentos lógicos através de campos de identificação:

### Relacionamentos Lógicos Identificados

#### EMPCODIGO → EMPRESA (Lógico)
**Fluxo:** BI_NOTAS → EMPRESA

**Descrição:** O campo EMPCODIGO referencia logicamente a tabela EMPRESA, permitindo identificar a empresa/filial relacionada a cada nota.

**Campos de junção:**
- `BI_NOTAS.EMPCODIGO` → `EMPRESA.EMPCODIGO` (junção lógica)

**Uso:** Filtrar notas por empresa ou obter informações cadastrais da empresa.

---

#### NFCODIGO + EMPCODIGO → NOTAS (Lógico)
**Fluxo:** BI_NOTAS → NOTAS

**Descrição:** O campo NFCODIGO combinado com EMPCODIGO referencia logicamente a tabela NOTAS, permitindo obter informações completas da nota fiscal.

**Campos de junção:**
- `BI_NOTAS.NFCODIGO + BI_NOTAS.EMPCODIGO` → `NOTAS.NFCODIGO + NOTAS.EMPCODIGO` (junção lógica)

**Uso:** Obter detalhes completos da nota fiscal quando necessário.

**Observação:** NOTAS possui chave primária composta (NFCODIGO + EMPCODIGO), então ambos os campos são necessários para junção.

---

#### NFCODIGO + EMPCODIGO → NOTAE (Lógico)
**Fluxo:** BI_NOTAS → NOTAE

**Descrição:** O campo NFCODIGO combinado com EMPCODIGO também pode referenciar logicamente a tabela NOTAE (Notas Fiscais de Entrada), dependendo do tipo de nota.

**Campos de junção:**
- `BI_NOTAS.NFCODIGO + BI_NOTAS.EMPCODIGO` → `NOTAE.NFECODIGO + NOTAE.EMPCODIGO` (junção lógica)

**Uso:** Obter informações de notas fiscais de entrada quando aplicável.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via NOTAS

#### NOTAS → CLIEN (Cliente)
**Fluxo:** BI_NOTAS → NOTAS → CLIEN

**Descrição:** Através do relacionamento lógico com NOTAS, é possível identificar o cliente relacionado a cada nota.

**Campos de junção:**
- `BI_NOTAS.NFCODIGO + EMPCODIGO` → `NOTAS.NFCODIGO + EMPCODIGO` → `NOTAS.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de vendas por cliente através de BI_NOTAS.

---

#### NOTAS → FUNCIO (Funcionário/Vendedor)
**Fluxo:** BI_NOTAS → NOTAS → FUNCIO

**Descrição:** Através do relacionamento lógico com NOTAS, é possível identificar o funcionário/vendedor relacionado a cada nota.

**Campos de junção:**
- `BI_NOTAS.NFCODIGO + EMPCODIGO` → `NOTAS.NFCODIGO + EMPCODIGO` → `NOTAS.FUNCODIGO` → `FUNCIO.FUNCODIGO`

**Uso:** Análises de performance de vendedores através de BI_NOTAS.

---

#### NOTAS → NFPRO (Produtos da Nota)
**Fluxo:** BI_NOTAS → NOTAS → NFPRO

**Descrição:** Através do relacionamento lógico com NOTAS, é possível obter os produtos relacionados a cada nota.

**Campos de junção:**
- `BI_NOTAS.NFCODIGO + EMPCODIGO` → `NOTAS.NFCODIGO + EMPCODIGO` → `NFPRO.NFCODIGO + NFPRO.EMPCODIGO`

**Uso:** Análises de produtos vendidos através de BI_NOTAS.

---

### Via EMPRESA

#### EMPRESA → CIDADE
**Fluxo:** BI_NOTAS → EMPRESA → CIDADE

**Descrição:** Através do relacionamento lógico com EMPRESA, é possível identificar a cidade/localização da empresa.

**Campos de junção:**
- `BI_NOTAS.EMPCODIGO` → `EMPRESA.EMPCODIGO` → `EMPRESA.CIDCODIGO` → `CIDADE.CIDCODIGO`

**Uso:** Análises geográficas de vendas.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Notas por Cliente

**Objetivo:** Obter visão completa de notas fiscais incluindo informações do cliente e empresa.

**Fluxo:**
```
BI_NOTAS (ID_BI_NOTAS, NFCODIGO, EMPCODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    bi.ID_BI_NOTAS,
    bi.NFCODIGO,
    bi.NFDTEMIS AS DATA_EMISSAO,
    bi.NFSIT AS SITUACAO,
    bi.NFDTEXP AS DATA_EXPORTACAO,
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ_EMPRESA,
    c.CLINOME AS CLIENTE,
    c.CLICNPJ AS CNPJ_CLIENTE,
    nf.NFVRTOTAL AS VALOR_TOTAL,
    nf.NFVRMERC AS VALOR_MERCADORIA,
    nf.CLICODIGO AS COD_CLIENTE
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN NOTAS nf ON nf.NFCODIGO = bi.NFCODIGO
                  AND nf.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN CLIEN c ON c.CLICODIGO = nf.CLICODIGO
WHERE bi.NFDTEMIS BETWEEN ? AND ?
ORDER BY bi.NFDTEMIS DESC;
```

---

### Exemplo 2: Análise de Notas por Vendedor e Empresa

**Objetivo:** Listar notas fiscais com informações de vendedor e empresa para análise de performance.

**Fluxo:**
```
BI_NOTAS (NFCODIGO, EMPCODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
  ↓
FUNCIO (FUNCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    e.EMPRAZSOCIAL AS EMPRESA,
    fu.FUNNOME AS VENDEDOR,
    COUNT(DISTINCT bi.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'N') AS NOTAS_NORMAIS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'C') AS NOTAS_CANCELADAS,
    SUM(nf.NFVRTOTAL) AS VALOR_TOTAL_VENDAS,
    MIN(bi.NFDTEMIS) AS PRIMEIRA_NOTA,
    MAX(bi.NFDTEMIS) AS ULTIMA_NOTA
FROM BI_NOTAS bi
INNER JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN NOTAS nf ON nf.NFCODIGO = bi.NFCODIGO
                  AND nf.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN FUNCIO fu ON fu.FUNCODIGO = nf.FUNCODIGO
WHERE bi.NFDTEMIS BETWEEN ? AND ?
GROUP BY e.EMPRAZSOCIAL, fu.FUNNOME
ORDER BY VALOR_TOTAL_VENDAS DESC;
```

---

### Exemplo 3: Análise de Produtos Vendidos através de BI_NOTAS

**Objetivo:** Obter análise de produtos vendidos utilizando BI_NOTAS como ponto de partida.

**Fluxo:**
```
BI_NOTAS (NFCODIGO, EMPCODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
  ↓
NFPRO (NFCODIGO, EMPCODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    bi.NFDTEMIS AS DATA_EMISSAO,
    e.EMPRAZSOCIAL AS EMPRESA,
    p.PRODESCRICAO AS PRODUTO,
    SUM(np.NFPQTDADE) AS QUANTIDADE_VENDIDA,
    SUM(np.NFPPCOVENDA * np.NFPQTDADE) AS VALOR_TOTAL,
    COUNT(DISTINCT bi.NFCODIGO) AS TOTAL_NOTAS
FROM BI_NOTAS bi
INNER JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
INNER JOIN NOTAS nf ON nf.NFCODIGO = bi.NFCODIGO
                   AND nf.EMPCODIGO = bi.EMPCODIGO
INNER JOIN NFPRO np ON np.NFCODIGO = bi.NFCODIGO
                   AND np.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN PRODU p ON p.PROCODIGO = np.PROCODIGO
WHERE bi.NFDTEMIS BETWEEN ? AND ?
  AND bi.NFSIT = 'N'
GROUP BY bi.NFDTEMIS, e.EMPRAZSOCIAL, p.PRODESCRICAO
ORDER BY bi.NFDTEMIS DESC, VALOR_TOTAL DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Notas por Período e Empresa

**Objetivo:** Consulta rápida de notas fiscais usando BI_NOTAS para performance otimizada.

```sql
SELECT
    bi.ID_BI_NOTAS,
    bi.NFCODIGO,
    bi.NFDTEMIS AS DATA_EMISSAO,
    bi.NFSIT AS SITUACAO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
WHERE bi.EMPCODIGO = ?
  AND bi.NFDTEMIS BETWEEN ? AND ?
ORDER BY bi.NFDTEMIS DESC;
```

---

### 2. Buscar Nota Específica por Código

**Objetivo:** Localizar uma nota fiscal específica através de BI_NOTAS.

```sql
SELECT
    bi.*,
    e.EMPRAZSOCIAL AS EMPRESA,
    nf.CLICODIGO AS COD_CLIENTE,
    nf.NFVRTOTAL AS VALOR_TOTAL
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
LEFT JOIN NOTAS nf ON nf.NFCODIGO = bi.NFCODIGO
                  AND nf.EMPCODIGO = bi.EMPCODIGO
WHERE bi.NFCODIGO = ?
  AND bi.EMPCODIGO = ?;
```

---

### 3. Análise de Situação de Notas

**Objetivo:** Verificar distribuição de notas por situação (Normal, Cancelada, etc.).

```sql
SELECT
    bi.NFSIT AS SITUACAO,
    COUNT(*) AS TOTAL_NOTAS,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM BI_NOTAS) AS PERCENTUAL,
    MIN(bi.NFDTEMIS) AS PRIMEIRA_DATA,
    MAX(bi.NFDTEMIS) AS ULTIMA_DATA
FROM BI_NOTAS bi
WHERE bi.NFDTEMIS >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY bi.NFSIT
ORDER BY TOTAL_NOTAS DESC;
```

---

### 4. Relatório de Notas Exportadas

**Objetivo:** Identificar notas que foram exportadas/processadas.

```sql
SELECT
    bi.NFCODIGO,
    bi.NFDTEMIS AS DATA_EMISSAO,
    bi.NFDTEXP AS DATA_EXPORTACAO,
    bi.NFARQUIVO AS ARQUIVO,
    e.EMPRAZSOCIAL AS EMPRESA,
    DATEDIFF(DAY, bi.NFDTEMIS, bi.NFDTEXP) AS DIAS_PARA_EXPORTACAO
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
WHERE bi.NFDTEXP IS NOT NULL
  AND bi.NFDTEMIS BETWEEN ? AND ?
ORDER BY bi.NFDTEXP DESC;
```

---

### 5. Análise de Notas por Empresa

**Objetivo:** Gerar relatório consolidado de notas por empresa.

```sql
SELECT
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    COUNT(DISTINCT bi.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'N') AS NOTAS_NORMAIS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'C') AS NOTAS_CANCELADAS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFDTEXP IS NOT NULL) AS NOTAS_EXPORTADAS,
    MIN(bi.NFDTEMIS) AS PRIMEIRA_NOTA,
    MAX(bi.NFDTEMIS) AS ULTIMA_NOTA
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
WHERE bi.NFDTEMIS >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY e.EMPRAZSOCIAL, e.EMPCNPJ
ORDER BY TOTAL_NOTAS DESC;
```

---

### 6. Verificar Notas sem Exportação

**Objetivo:** Identificar notas que ainda não foram exportadas/processadas.

```sql
SELECT
    bi.NFCODIGO,
    bi.NFDTEMIS AS DATA_EMISSAO,
    bi.NFSIT AS SITUACAO,
    e.EMPRAZSOCIAL AS EMPRESA,
    CURRENT_DATE - bi.NFDTEMIS AS DIAS_SEM_EXPORTACAO
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
WHERE bi.NFDTEXP IS NULL
  AND bi.NFSIT = 'N'
  AND bi.NFDTEMIS < CURRENT_DATE - INTERVAL '7 days'
ORDER BY bi.NFDTEMIS ASC;
```

---

### 7. Análise Temporal de Emissão de Notas

**Objetivo:** Analisar tendências temporais de emissão de notas fiscais.

```sql
SELECT
    EXTRACT(YEAR FROM bi.NFDTEMIS) AS ANO,
    EXTRACT(MONTH FROM bi.NFDTEMIS) AS MES,
    COUNT(DISTINCT bi.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT bi.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'N') AS NOTAS_NORMAIS,
    COUNT(DISTINCT bi.NFCODIGO) FILTER (WHERE bi.NFSIT = 'C') AS NOTAS_CANCELADAS
FROM BI_NOTAS bi
WHERE bi.NFDTEMIS >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY EXTRACT(YEAR FROM bi.NFDTEMIS), EXTRACT(MONTH FROM bi.NFDTEMIS)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com BI_NOTAS | Tipo |
|--------|-----------|------------------------|------|
| **BI_NOTAS** | 1.473.539 | 1:1 | **TABELA PRINCIPAL** |
| NOTAS | 1.206.013 | 1.22:1 | Notas fiscais (BI_NOTAS tem mais registros) |
| NOTAE | 204.952 | 7.19:1 | Notas fiscais de entrada |
| EMPRESA | 6 | 245.590:1 | Empresas no sistema |

**Interpretação:**
- BI_NOTAS possui **mais registros** que NOTAS, sugerindo que pode incluir notas de múltiplas fontes ou histórico completo
- Cada empresa possui em média **245.590 notas** processadas para BI
- Tabela grande mas otimizada para consultas rápidas de BI

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **ID_BI_NOTAS** | BI_NOTAS | Identificador único (PK) |
| **NFCODIGO + EMPCODIGO** | BI_NOTAS → NOTAS | Referência lógica à nota fiscal |
| **EMPCODIGO** | BI_NOTAS → EMPRESA | Empresa relacionada (lógico) |
| **NFDTEMIS** | BI_NOTAS | Data de emissão (indexado) |
| **NFSIT** | BI_NOTAS | Situação da nota (filtro comum) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**1. INDBINFCODIGO** em (NFCODIGO)
**Descrição:** Índice no código da nota fiscal para buscas rápidas por NFCODIGO.

**2. INDBINFDTEMIS** em (NFDTEMIS)
**Descrição:** Índice na data de emissão para filtros temporais otimizados.

**3. IND_NOTAEMIS_BI_NOTAS** em (NFCODIGO, EMPCODIGO)
**Descrição:** Índice composto para buscas por nota e empresa simultaneamente.

### Recomendações de Performance

1. **Sempre filtrar por NFDTEMIS** - Use o índice INDBINFDTEMIS
2. **Usar índice composto** - Para buscas por NFCODIGO + EMPCODIGO
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Considerar particionamento** - Tabela grande candidata a particionamento por data

### Índices Adicionais Sugeridos

```sql
-- Índice 1: Busca por situação e data (consultas frequentes)
CREATE INDEX IDX_BI_NOTAS_SIT_DATA ON BI_NOTAS(NFSIT, NFDTEMIS);

-- Índice 2: Busca por empresa e data
CREATE INDEX IDX_BI_NOTAS_EMP_DATA ON BI_NOTAS(EMPCODIGO, NFDTEMIS);

-- Índice 3: Busca por data de exportação (se usado frequentemente)
CREATE INDEX IDX_BI_NOTAS_DTEXP ON BI_NOTAS(NFDTEXP)
WHERE NFDTEXP IS NOT NULL;
```

### Observações sobre Volume

- **Tabela grande** (1.4M registros) - Performance é crítica
- **Índices existentes** cobrem os principais casos de uso
- **Consultas com JOINs** podem ser lentas - considerar materialização de dados
- **Focar em filtros temporais** - Sempre usar NFDTEMIS para limitar resultados

### Exemplo de Query Otimizada

```sql
-- ❌ NÃO OTIMIZADO (table scan completo)
SELECT * FROM BI_NOTAS WHERE EMPCODIGO = 1;

-- ✅ OTIMIZADO (usa índice e limita período)
SELECT
    ID_BI_NOTAS, NFCODIGO, NFDTEMIS, NFSIT
FROM BI_NOTAS
WHERE EMPCODIGO = 1
  AND NFDTEMIS >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY NFDTEMIS DESC;

-- ✅ OTIMIZADO (usa índice composto)
SELECT
    ID_BI_NOTAS, NFDTEMIS, NFSIT
FROM BI_NOTAS
WHERE NFCODIGO = ?
  AND EMPCODIGO = ?;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial Lógica

```sql
-- Verificar notas em BI_NOTAS sem correspondência em NOTAS
SELECT bi.*
FROM BI_NOTAS bi
LEFT JOIN NOTAS nf ON nf.NFCODIGO = bi.NFCODIGO
                  AND nf.EMPCODIGO = bi.EMPCODIGO
WHERE nf.NFCODIGO IS NULL;

-- Verificar empresas inválidas
SELECT bi.*
FROM BI_NOTAS bi
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bi.EMPCODIGO
WHERE e.EMPCODIGO IS NULL;

-- Verificar inconsistências de data
SELECT *
FROM BI_NOTAS
WHERE NFDTEXP IS NOT NULL
  AND NFDTEXP < NFDTEMIS;
```

### Verificar Consistência de Dados

```sql
-- Verificar duplicatas de NFCODIGO + EMPCODIGO
SELECT NFCODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM BI_NOTAS
GROUP BY NFCODIGO, EMPCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores obrigatórios nulos
SELECT *
FROM BI_NOTAS
WHERE ID_BI_NOTAS IS NULL
   OR EMPCODIGO IS NULL
   OR NFCODIGO IS NULL
   OR NFDTEMIS IS NULL;

-- Verificar situações inválidas
SELECT DISTINCT NFSIT
FROM BI_NOTAS
WHERE NFSIT NOT IN ('N', 'C', 'A', 'P', 'F');
```

### Verificar Integridade Temporal

```sql
-- Verificar notas com datas futuras
SELECT *
FROM BI_NOTAS
WHERE NFDTEMIS > CURRENT_DATE;

-- Verificar notas muito antigas (possível inconsistência)
SELECT *
FROM BI_NOTAS
WHERE NFDTEMIS < DATE '2000-01-01';
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

final class FirebirdBiNotas extends Model
{
    protected $connection = 'firebird';
    protected $table = 'BI_NOTAS';
    protected $primaryKey = 'ID_BI_NOTAS';

    protected $casts = [
        'ID_BI_NOTAS' => 'integer',
        'EMPCODIGO' => 'integer',
        'NFCODIGO' => 'string',
        'NFDTEMIS' => 'date',
        'NFDTEXP' => 'date',
        'NFSIT' => 'string',
        'NFARQUIVO' => 'string',
    ];

    // Relacionamento com EMPRESA (lógico)
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com NOTAS (lógico - chave composta)
    public function nota(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdNotas::class,
            ['NFCODIGO', 'EMPCODIGO'],
            ['NFCODIGO', 'EMPCODIGO']
        );
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, $dataInicio, $dataFim)
    {
        return $query->whereBetween('NFDTEMIS', [$dataInicio, $dataFim]);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por situação
    public function scopePorSituacao($query, string $situacao)
    {
        return $query->where('NFSIT', $situacao);
    }

    // Scope para notas normais
    public function scopeNormais($query)
    {
        return $query->where('NFSIT', 'N');
    }

    // Scope para notas canceladas
    public function scopeCanceladas($query)
    {
        return $query->where('NFSIT', 'C');
    }

    // Scope para notas exportadas
    public function scopeExportadas($query)
    {
        return $query->whereNotNull('NFDTEXP');
    }

    // Scope para notas não exportadas
    public function scopeNaoExportadas($query)
    {
        return $query->whereNull('NFDTEXP');
    }

    // Método para verificar se está exportada
    public function estaExportada(): bool
    {
        return $this->NFDTEXP !== null;
    }

    // Método para verificar se está cancelada
    public function estaCancelada(): bool
    {
        return $this->NFSIT === 'C';
    }

    // Método para verificar se está normal
    public function estaNormal(): bool
    {
        return $this->NFSIT === 'N';
    }

    // Método para calcular dias desde emissão
    public function diasDesdeEmissao(): int
    {
        return $this->NFDTEMIS->diffInDays(now());
    }

    // Método para calcular dias até exportação
    public function diasAteExportacao(): ?int
    {
        if ($this->NFDTEXP === null) {
            return null;
        }

        return $this->NFDTEMIS->diffInDays($this->NFDTEXP);
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Manter sincronização** - BI_NOTAS deve estar sincronizada com NOTAS/NOTAE
2. **Validação de dados** - Verificar integridade referencial lógica periodicamente
3. **Campos obrigatórios** - Garantir que EMPCODIGO, NFCODIGO e NFDTEMIS sempre preenchidos
4. **Situação consistente** - NFSIT deve corresponder à situação real da nota

### Performance

1. **Sempre filtrar por data** - Usar NFDTEMIS para limitar resultados
2. **Usar índices existentes** - Aproveitar INDBINFDTEMIS e IND_NOTAEMIS_BI_NOTAS
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Considerar cache** - Para consultas frequentes de relatórios

### Integridade de Dados

1. **Sincronização periódica** - Garantir que BI_NOTAS reflete estado atual de NOTAS
2. **Verificar duplicatas** - Evitar múltiplos registros para mesma nota
3. **Validar datas** - Garantir que NFDTEXP >= NFDTEMIS quando preenchido
4. **Validar situações** - NFSIT deve conter valores válidos

### Manutenção

1. **Processo de atualização** - Estabelecer processo claro de sincronização
2. **Limpeza periódica** - Considerar arquivamento de registros antigos
3. **Monitoramento** - Acompanhar crescimento e performance da tabela
4. **Backup regular** - Tabela grande mas crítica para BI

### Regras de Negócio

1. **Tabela de BI** - Não deve ser usada para transações, apenas consultas
2. **Sincronização** - Deve refletir estado atual das tabelas transacionais
3. **Performance** - Otimizada para leitura, não para escrita frequente
4. **Histórico** - Pode conter histórico completo mesmo após exclusão em NOTAS

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

