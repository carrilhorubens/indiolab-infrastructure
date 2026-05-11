# EXTRATOCONCBCO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: EXTRATOCONCBCO (Extrato Conciliação Banco)
- **Total de Registros**: 1.221
- **Total de Colunas**: 11
- **Chave Primária**: IDEXT (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (CCORR)
- **Banco de Dados**: Firebird

## 📝 Descrição

**EXTRATOCONCBCO** é uma tabela que armazena informações de conciliação de extratos bancários. Com **1.221 registros**, representa registros de conciliação entre extratos bancários e lançamentos contábeis, permitindo controle e rastreamento de conciliações bancárias.

Esta tabela funciona como **registro de conciliação de extrato bancário** e permite:
- Armazenar informações de conciliação de extratos bancários
- Controlar status de conciliação (CONCILIADO)
- Rastrear ocorrências e valores de transações
- Suportar processo de conciliação bancária
- Facilitar identificação de transações conciliadas
- Manter histórico de conciliações

Cada registro representa uma conciliação específica de extrato bancário, contendo:
- Identificador único do extrato de conciliação (IDEXT)
- Tipo da transação (TIPO)
- Data da ocorrência (DATAOCOR)
- Data de importação (DATAIMPORT)
- Valor da transação (VALOR)
- Identificador FITID (FITID)
- Número do cheque (CHECKNUM)
- Tipo de ocorrência (OCORRENCIA)
- Status de conciliação (CONCILIADO)
- Banco relacionado (BANCO)
- Conta relacionada (CCONT)

O sistema utiliza esta tabela para controlar conciliações de extratos bancários, sendo referenciada por CCORR para vincular lançamentos contábeis com extratos conciliados.

**Observação Importante:** EXTRATOCONCBCO é uma tabela de conciliação bancária que armazena informações de extratos conciliados. Com 1.221 registros e referenciada por CCORR, indica uso extensivo desta funcionalidade. Não possui foreign keys diretas, mas possui relacionamento lógico com CCORR através de ID_CONCILIACAO.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IDEXT** 🔑 | INTEGER | ✓ | Identificador único do extrato de conciliação (PK) |

### Informações da Transação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TIPO** | VARCHAR(14) | | Tipo da transação |
| **DATAOCOR** | DATE | | Data da ocorrência |
| **DATAIMPORT** | DATE | | Data de importação |
| **VALOR** | NUMERIC(27,2) | | Valor da transação |
| **FITID** | VARCHAR(37) | | Identificador FITID |
| **CHECKNUM** | VARCHAR(37) | | Número do cheque |
| **OCORRENCIA** | VARCHAR(37) | | Tipo de ocorrência |
| **CONCILIADO** | VARCHAR(14) | | Status de conciliação (S/N) |
| **BANCO** | VARCHAR(37) | | Banco relacionado |
| **CCONT** | VARCHAR(37) | | Conta relacionada |

**Primary Key:** IDEXT

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### EXTRATOCONCBCO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### EXTRATOCONCBCO é Referenciada Por (1 tabela):

#### 1. CCORR - Lançamentos Contábeis
**Relacionamento:**
```
CCORR.ID_CONCILIACAO → EXTRATOCONCBCO.IDEXT (N:1)
Constraint: FK_ID_CONCILIACAO
```

**Descrição**: Cada lançamento contábil pode estar vinculado a um extrato de conciliação específico.

**Informações da Tabela CCORR:**
- **Total:** 208.120 lançamentos
- **PK:** (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
- **Colunas:** 36 campos

**Uso:** Vincular lançamentos contábeis com extratos conciliados.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CCORR → Outras Operações Contábeis

**Fluxo:** EXTRATOCONCBCO → CCORR → Operações Contábeis

**Descrição:** Através do lançamento contábil, é possível identificar outras operações relacionadas.

**Uso:** Análise de extratos conciliados através de lançamentos contábeis.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Extrato Conciliação

**Objetivo:** Obter visão completa de um extrato de conciliação incluindo lançamentos contábeis relacionados.

**Fluxo:**
```
EXTRATOCONCBCO (IDEXT)
  ↓
CCORR (ID_CONCILIACAO)
  ↓
BANCO (BCOCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ext.IDEXT,
    ext.TIPO,
    ext.DATAOCOR AS DATA_OCORRENCIA,
    ext.DATAIMPORT AS DATA_IMPORTACAO,
    ext.VALOR AS VALOR_TRANSACAO,
    ext.FITID,
    ext.CHECKNUM AS NUMERO_CHEQUE,
    ext.OCORRENCIA,
    ext.CONCILIADO AS STATUS_CONCILIACAO,
    ext.BANCO,
    ext.CCONT AS CONTA,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL_LANCAMENTOS
FROM EXTRATOCONCBCO ext
LEFT JOIN CCORR cco ON cco.ID_CONCILIACAO = ext.IDEXT
LEFT JOIN BANCO bco ON bco.BCOCODIGO = cco.BCOCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cco.EMPCODIGO
WHERE ext.IDEXT = ?
GROUP BY ext.IDEXT, ext.TIPO, ext.DATAOCOR, ext.DATAIMPORT, ext.VALOR,
         ext.FITID, ext.CHECKNUM, ext.OCORRENCIA, ext.CONCILIADO, ext.BANCO, ext.CCONT;
```

---

### Exemplo 2: Análise de Extratos Conciliação por Status

**Objetivo:** Identificar distribuição de extratos por status de conciliação.

**Query SQL:**
```sql
SELECT
    CONCILIADO AS STATUS_CONCILIACAO,
    COUNT(*) AS TOTAL_EXTRATOS,
    SUM(VALOR) AS VALOR_TOTAL,
    AVG(VALOR) AS VALOR_MEDIO,
    COUNT(DISTINCT BANCO) AS TOTAL_BANCOS,
    COUNT(DISTINCT CCONT) AS TOTAL_CONTAS
FROM EXTRATOCONCBCO
WHERE CONCILIADO IS NOT NULL
GROUP BY CONCILIADO
ORDER BY TOTAL_EXTRATOS DESC;
```

---

### Exemplo 3: Análise de Extratos Conciliação por Período

**Objetivo:** Identificar distribuição de extratos ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DATAOCOR) AS ANO,
    EXTRACT(MONTH FROM DATAOCOR) AS MES,
    COUNT(*) AS TOTAL_EXTRATOS,
    SUM(VALOR) AS VALOR_TOTAL,
    AVG(VALOR) AS VALOR_MEDIO,
    COUNT(CASE WHEN CONCILIADO = 'S' THEN 1 END) AS CONCILIADOS,
    COUNT(CASE WHEN CONCILIADO = 'N' THEN 1 END) AS NAO_CONCILIADOS
FROM EXTRATOCONCBCO
WHERE DATAOCOR IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATAOCOR), EXTRACT(MONTH FROM DATAOCOR)
ORDER BY ANO DESC, MES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Extrato Conciliação

**Objetivo:** Obter informações de um extrato de conciliação específico.

```sql
SELECT
    IDEXT,
    TIPO,
    DATAOCOR AS DATA_OCORRENCIA,
    DATAIMPORT AS DATA_IMPORTACAO,
    VALOR AS VALOR_TRANSACAO,
    FITID,
    CHECKNUM AS NUMERO_CHEQUE,
    OCORRENCIA,
    CONCILIADO AS STATUS_CONCILIACAO,
    BANCO,
    CCONT AS CONTA
FROM EXTRATOCONCBCO
WHERE IDEXT = ?;
```

---

### 2. Listar Extratos Não Concilidadas

**Objetivo:** Obter todos os extratos que não foram conciliados.

```sql
SELECT
    IDEXT,
    TIPO,
    DATAOCOR AS DATA_OCORRENCIA,
    VALOR AS VALOR_TRANSACAO,
    OCORRENCIA,
    BANCO,
    CCONT AS CONTA
FROM EXTRATOCONCBCO
WHERE CONCILIADO = 'N' OR CONCILIADO IS NULL
ORDER BY DATAOCOR DESC;
```

---

### 3. Análise de Extratos por Banco

**Objetivo:** Identificar distribuição de extratos por banco.

**Query SQL:**
```sql
SELECT
    BANCO,
    COUNT(*) AS TOTAL_EXTRATOS,
    SUM(VALOR) AS VALOR_TOTAL,
    AVG(VALOR) AS VALOR_MEDIO,
    COUNT(CASE WHEN CONCILIADO = 'S' THEN 1 END) AS CONCILIADOS,
    COUNT(CASE WHEN CONCILIADO = 'N' OR CONCILIADO IS NULL THEN 1 END) AS NAO_CONCILIADOS
FROM EXTRATOCONCBCO
WHERE BANCO IS NOT NULL
GROUP BY BANCO
ORDER BY TOTAL_EXTRATOS DESC;
```

---

### 4. Análise de Extratos por Ocorrência

**Objetivo:** Identificar distribuição de extratos por tipo de ocorrência.

**Query SQL:**
```sql
SELECT
    OCORRENCIA,
    COUNT(*) AS TOTAL_EXTRATOS,
    SUM(VALOR) AS VALOR_TOTAL,
    AVG(VALOR) AS VALOR_MEDIO
FROM EXTRATOCONCBCO
WHERE OCORRENCIA IS NOT NULL
GROUP BY OCORRENCIA
ORDER BY TOTAL_EXTRATOS DESC;
```

---

### 5. Análise de Extratos com Lançamentos Contábeis

**Objetivo:** Identificar extratos que possuem lançamentos contábeis vinculados.

**Query SQL:**
```sql
SELECT
    ext.IDEXT,
    ext.TIPO,
    ext.DATAOCOR AS DATA_OCORRENCIA,
    ext.VALOR AS VALOR_TRANSACAO,
    ext.CONCILIADO AS STATUS_CONCILIACAO,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL_LANCAMENTOS
FROM EXTRATOCONCBCO ext
LEFT JOIN CCORR cco ON cco.ID_CONCILIACAO = ext.IDEXT
GROUP BY ext.IDEXT, ext.TIPO, ext.DATAOCOR, ext.VALOR, ext.CONCILIADO
HAVING COUNT(cco.CCONRLANCTO) > 0
ORDER BY TOTAL_LANCAMENTOS DESC;
```

---

### 6. Relatório Completo de Extratos Conciliação

**Objetivo:** Analisar distribuição completa de extratos de conciliação no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_EXTRATOS,
    COUNT(DISTINCT BANCO) AS TOTAL_BANCOS,
    COUNT(DISTINCT CCONT) AS TOTAL_CONTAS,
    SUM(VALOR) AS VALOR_TOTAL,
    AVG(VALOR) AS VALOR_MEDIO,
    MIN(VALOR) AS VALOR_MINIMO,
    MAX(VALOR) AS VALOR_MAXIMO,
    COUNT(CASE WHEN CONCILIADO = 'S' THEN 1 END) AS CONCILIADOS,
    COUNT(CASE WHEN CONCILIADO = 'N' OR CONCILIADO IS NULL THEN 1 END) AS NAO_CONCILIADOS,
    (SELECT COUNT(*) FROM CCORR WHERE ID_CONCILIACAO IS NOT NULL) AS TOTAL_LANCAMENTOS_VINCULADOS
FROM EXTRATOCONCBCO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com EXTRATOCONCBCO | Tipo |
|--------|-----------|----------------------------|------|
| **EXTRATOCONCBCO** | 1.221 | 1:1 | **TABELA PRINCIPAL** |
| CCORR | 208.120 | 1:170.5 | Lançamentos (média de 170.5 lançamentos por extrato) |

**Interpretação:**
- **1.221 extratos de conciliação** registrados no sistema
- **Média de 170.5 lançamentos por extrato** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por status de conciliação (consultas frequentes)
CREATE INDEX IDX_EXTRATOCONCBCO_CONCILIADO ON EXTRATOCONCBCO(CONCILIADO)
    WHERE CONCILIADO IS NOT NULL;

-- Índice 2: Busca por banco (consultas frequentes)
CREATE INDEX IDX_EXTRATOCONCBCO_BANCO ON EXTRATOCONCBCO(BANCO)
    WHERE BANCO IS NOT NULL;

-- Índice 3: Busca por conta (consultas frequentes)
CREATE INDEX IDX_EXTRATOCONCBCO_CONTA ON EXTRATOCONCBCO(CCONT)
    WHERE CCONT IS NOT NULL;

-- Índice 4: Busca por data de ocorrência (consultas frequentes)
CREATE INDEX IDX_EXTRATOCONCBCO_DATAOCOR ON EXTRATOCONCBCO(DATAOCOR)
    WHERE DATAOCOR IS NOT NULL;

-- Índice 5: Busca por ocorrência (consultas frequentes)
CREATE INDEX IDX_EXTRATOCONCBCO_OCORRENCIA ON EXTRATOCONCBCO(OCORRENCIA)
    WHERE OCORRENCIA IS NOT NULL;
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

final class FirebirdExtratoconcbco extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'EXTRATOCONCBCO';
    
    protected $primaryKey = 'IDEXT';
    public $incrementing = true;

    protected $casts = [
        'IDEXT' => 'integer',
        'TIPO' => 'string',
        'DATAOCOR' => 'date',
        'DATAIMPORT' => 'date',
        'VALOR' => 'decimal:2',
        'FITID' => 'string',
        'CHECKNUM' => 'string',
        'OCORRENCIA' => 'string',
        'CONCILIADO' => 'string',
        'BANCO' => 'string',
        'CCONT' => 'string',
    ];

    // Relacionamento com CCORR
    public function lancamentosContabeis(): HasMany
    {
        return $this->hasMany(FirebirdCcorr::class, 'ID_CONCILIACAO', 'IDEXT');
    }

    public function scopeConcilidadas($query)
    {
        return $query->where('CONCILIADO', 'S');
    }

    public function scopeNaoConcilidadas($query)
    {
        return $query->where(function($q) {
            $q->where('CONCILIADO', 'N')
              ->orWhereNull('CONCILIADO');
        });
    }

    public function scopePorBanco($query, string $banco)
    {
        return $query->where('BANCO', $banco);
    }

    public function scopePorConta($query, string $conta)
    {
        return $query->where('CCONT', $conta);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATAOCOR', [$dataInicial, $dataFinal]);
    }

    public function scopePorOcorrencia($query, string $ocorrencia)
    {
        return $query->where('OCORRENCIA', $ocorrencia);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

