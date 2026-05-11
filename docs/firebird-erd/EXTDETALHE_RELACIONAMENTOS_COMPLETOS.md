# EXTDETALHE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: EXTDETALHE (Detalhes de Extrato Bancário)
- **Total de Registros**: 1.862
- **Total de Colunas**: 7
- **Chave Primária**: Composta (IDARQUIVO, EXTSEQ)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 1 (EXTCONCILIACAO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**EXTDETALHE** é uma tabela que armazena detalhes individuais de transações de extratos bancários importados. Com **1.862 registros**, representa cada movimentação bancária individual presente nos extratos importados, permitindo análise detalhada de transações e suporte ao processo de conciliação bancária.

Esta tabela funciona como **detalhamento de transações do extrato** e permite:
- Armazenar cada transação individual do extrato bancário
- Rastrear movimentações bancárias detalhadas
- Controlar datas, valores e ocorrências de cada transação
- Suportar processo de conciliação bancária
- Facilitar identificação de transações específicas
- Manter histórico completo de transações bancárias

Cada registro representa uma transação específica de um extrato bancário, contendo:
- Identificador do arquivo de extrato (IDARQUIVO) - parte da PK + FK → BCOEXTRATO
- Sequencial da transação no extrato (EXTSEQ) - parte da PK
- Data da transação (EXTDATA)
- Tipo de ocorrência (EXTOCORRENCIA)
- Valor da transação (EXTVALOR)
- Identificador da transação (EXTID)
- Número do documento (EXTDOCUMENTO)

O sistema utiliza esta tabela para armazenar detalhes de cada transação presente nos extratos bancários importados, sendo essencial para o processo de conciliação bancária.

**Observação Importante:** EXTDETALHE é uma tabela de detalhamento que estende BCOEXTRATO com transações individuais. Com 1.862 registros e chave primária composta, indica uso extensivo desta funcionalidade. É referenciada por EXTCONCILIACAO para vincular transações com lançamentos contábeis.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IDARQUIVO** 🔑 🔗 | INTEGER | ✓ | Identificador do arquivo de extrato (PK + FK → BCOEXTRATO) |
| **EXTSEQ** 🔑 | INTEGER | ✓ | Sequencial da transação no extrato (PK) |

### Informações da Transação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **EXTDATA** | DATE | | Data da transação |
| **EXTOCORRENCIA** | VARCHAR(37) | | Tipo de ocorrência da transação |
| **EXTVALOR** | NUMERIC(27,2) | | Valor da transação |
| **EXTID** | VARCHAR(37) | | Identificador da transação |
| **EXTDOCUMENTO** | VARCHAR(37) | | Número do documento da transação |

**Primary Key:** (IDARQUIVO, EXTSEQ)

**Foreign Keys:**
- `IDARQUIVO` → `BCOEXTRATO.ID` (Constraint: EXTDETALHE_BCOEXTRATO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### EXTDETALHE Referencia (1 FK):

#### 1. BCOEXTRATO - Extratos Bancários
**Relacionamento:**
```
EXTDETALHE.IDARQUIVO → BCOEXTRATO.ID (N:1)
Constraint: EXTDETALHE_BCOEXTRATO
```

**Descrição**: Cada transação está vinculada a um arquivo de extrato específico.

**Informações da Tabela BCOEXTRATO:**
- **Total:** 100 extratos
- **PK:** ID
- **Colunas:** 6 campos

**Uso:** Identificar o extrato bancário ao qual a transação pertence.

---

### EXTDETALHE é Referenciada Por (1 tabela):

#### 1. EXTCONCILIACAO - Conciliações Bancárias
**Relacionamento:**
```
EXTCONCILIACAO.IDARQUIVO, EXTCONCILIACAO.EXTSEQ → EXTDETALHE.IDARQUIVO, EXTDETALHE.EXTSEQ (N:1)
Constraint: EXTCONCILIACAO_EXTDETALHE
```

**Descrição**: Cada transação pode estar vinculada a uma conciliação bancária.

**Informações da Tabela EXTCONCILIACAO:**
- **Total:** 1.782 conciliações
- **PK:** ID
- **Colunas:** 7 campos

**Uso:** Vincular transações do extrato com lançamentos contábeis através da conciliação.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via BCOEXTRATO → BANCO, EMPRESA, CONTA

**Fluxo:** EXTDETALHE → BCOEXTRATO → BANCO/EMPRESA/CONTA

**Descrição:** Através do extrato, é possível identificar banco, empresa e conta relacionadas.

**Uso:** Análise de transações por banco, empresa ou conta.

---

### Via EXTCONCILIACAO → CCORR

**Fluxo:** EXTDETALHE → EXTCONCILIACAO → CCORR

**Descrição:** Através da conciliação, é possível identificar lançamentos contábeis relacionados.

**Uso:** Análise de transações conciliadas com lançamentos contábeis.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Transação

**Objetivo:** Obter visão completa de uma transação incluindo informações do extrato, banco e conciliação.

**Fluxo:**
```
EXTDETALHE (IDARQUIVO, EXTSEQ)
  ↓
BCOEXTRATO (ID)
  ↓
BANCO (BCOCODIGO)
  ↓
EXTCONCILIACAO (IDARQUIVO, EXTSEQ)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    det.IDARQUIVO,
    det.EXTSEQ,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTID AS IDENTIFICADOR,
    det.EXTDOCUMENTO AS DOCUMENTO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    bco.BCONOME AS BANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    CASE WHEN exc.ID IS NOT NULL THEN 'CONCILIADO' ELSE 'NAO_CONCILIADO' END AS STATUS_CONCILIACAO,
    exc.CCONRLANCTO AS NUMERO_LANCAMENTO,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO
FROM EXTDETALHE det
INNER JOIN BCOEXTRATO ext ON ext.ID = det.IDARQUIVO
LEFT JOIN BANCO bco ON bco.BCOCODIGO = ext.BCOCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ext.EMPCODIGO
LEFT JOIN EXTCONCILIACAO exc ON exc.IDARQUIVO = det.IDARQUIVO
                             AND exc.EXTSEQ = det.EXTSEQ
LEFT JOIN CCORR cco ON cco.BCOCODIGO = exc.BCOCODIGO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.CCONRLANCTO = exc.CCONRLANCTO
                   AND cco.EMPCCORR = exc.EMPCCORR
WHERE det.IDARQUIVO = ?
  AND det.EXTSEQ = ?;
```

---

### Exemplo 2: Análise de Transações por Extrato

**Objetivo:** Identificar todas as transações de um extrato específico.

**Query SQL:**
```sql
SELECT
    det.EXTSEQ,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTDOCUMENTO AS DOCUMENTO,
    CASE WHEN exc.ID IS NOT NULL THEN 'CONCILIADO' ELSE 'NAO_CONCILIADO' END AS STATUS_CONCILIACAO,
    COUNT(*) OVER (PARTITION BY det.IDARQUIVO) AS TOTAL_TRANSACOES_EXTRATO
FROM EXTDETALHE det
LEFT JOIN EXTCONCILIACAO exc ON exc.IDARQUIVO = det.IDARQUIVO
                             AND exc.EXTSEQ = det.EXTSEQ
WHERE det.IDARQUIVO = ?
ORDER BY det.EXTSEQ;
```

---

### Exemplo 3: Análise de Transações Não Concilidadas

**Objetivo:** Identificar transações que não foram conciliadas com lançamentos contábeis.

**Query SQL:**
```sql
SELECT
    det.IDARQUIVO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    det.EXTSEQ,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTDOCUMENTO AS DOCUMENTO,
    bco.BCONOME AS BANCO
FROM EXTDETALHE det
INNER JOIN BCOEXTRATO ext ON ext.ID = det.IDARQUIVO
LEFT JOIN BANCO bco ON bco.BCOCODIGO = ext.BCOCODIGO
LEFT JOIN EXTCONCILIACAO exc ON exc.IDARQUIVO = det.IDARQUIVO
                             AND exc.EXTSEQ = det.EXTSEQ
WHERE exc.ID IS NULL
ORDER BY det.IDARQUIVO, det.EXTSEQ;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Transação

**Objetivo:** Obter informações de uma transação específica.

```sql
SELECT
    IDARQUIVO,
    EXTSEQ,
    EXTDATA AS DATA_TRANSACAO,
    EXTOCORRENCIA AS OCORRENCIA,
    EXTVALOR AS VALOR_TRANSACAO,
    EXTID AS IDENTIFICADOR,
    EXTDOCUMENTO AS DOCUMENTO
FROM EXTDETALHE
WHERE IDARQUIVO = ?
  AND EXTSEQ = ?;
```

---

### 2. Listar Transações de um Extrato

**Objetivo:** Obter todas as transações de um extrato específico.

```sql
SELECT
    EXTSEQ,
    EXTDATA AS DATA_TRANSACAO,
    EXTOCORRENCIA AS OCORRENCIA,
    EXTVALOR AS VALOR_TRANSACAO,
    EXTDOCUMENTO AS DOCUMENTO
FROM EXTDETALHE
WHERE IDARQUIVO = ?
ORDER BY EXTSEQ;
```

---

### 3. Análise de Transações por Ocorrência

**Objetivo:** Identificar distribuição de transações por tipo de ocorrência.

**Query SQL:**
```sql
SELECT
    EXTOCORRENCIA AS OCORRENCIA,
    COUNT(*) AS TOTAL_TRANSACOES,
    SUM(EXTVALOR) AS VALOR_TOTAL,
    AVG(EXTVALOR) AS VALOR_MEDIO,
    MIN(EXTVALOR) AS VALOR_MINIMO,
    MAX(EXTVALOR) AS VALOR_MAXIMO
FROM EXTDETALHE
WHERE EXTOCORRENCIA IS NOT NULL
GROUP BY EXTOCORRENCIA
ORDER BY TOTAL_TRANSACOES DESC;
```

---

### 4. Análise de Transações por Período

**Objetivo:** Identificar distribuição de transações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM EXTDATA) AS ANO,
    EXTRACT(MONTH FROM EXTDATA) AS MES,
    COUNT(*) AS TOTAL_TRANSACOES,
    SUM(EXTVALOR) AS VALOR_TOTAL,
    AVG(EXTVALOR) AS VALOR_MEDIO
FROM EXTDETALHE
WHERE EXTDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM EXTDATA), EXTRACT(MONTH FROM EXTDATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 5. Análise de Transações por Valor

**Objetivo:** Identificar transações acima ou abaixo de determinado valor.

**Query SQL:**
```sql
SELECT
    IDARQUIVO,
    EXTSEQ,
    EXTDATA AS DATA_TRANSACAO,
    EXTVALOR AS VALOR_TRANSACAO,
    EXTOCORRENCIA AS OCORRENCIA,
    EXTDOCUMENTO AS DOCUMENTO
FROM EXTDETALHE
WHERE EXTVALOR > ?
ORDER BY EXTVALOR DESC;
```

---

### 6. Análise de Transações Concilidadas vs Não Concilidadas

**Objetivo:** Comparar transações conciliadas com não conciliadas.

**Query SQL:**
```sql
SELECT
    CASE WHEN exc.ID IS NOT NULL THEN 'CONCILIADO' ELSE 'NAO_CONCILIADO' END AS STATUS,
    COUNT(*) AS TOTAL_TRANSACOES,
    SUM(det.EXTVALOR) AS VALOR_TOTAL,
    AVG(det.EXTVALOR) AS VALOR_MEDIO,
    COUNT(DISTINCT det.IDARQUIVO) AS TOTAL_EXTRATOS
FROM EXTDETALHE det
LEFT JOIN EXTCONCILIACAO exc ON exc.IDARQUIVO = det.IDARQUIVO
                             AND exc.EXTSEQ = det.EXTSEQ
GROUP BY CASE WHEN exc.ID IS NOT NULL THEN 'CONCILIADO' ELSE 'NAO_CONCILIADO' END;
```

---

### 7. Relatório Completo de Transações

**Objetivo:** Analisar distribuição completa de transações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_TRANSACOES,
    COUNT(DISTINCT IDARQUIVO) AS TOTAL_EXTRATOS,
    SUM(EXTVALOR) AS VALOR_TOTAL,
    AVG(EXTVALOR) AS VALOR_MEDIO,
    MIN(EXTVALOR) AS VALOR_MINIMO,
    MAX(EXTVALOR) AS VALOR_MAXIMO,
    COUNT(DISTINCT EXTOCORRENCIA) AS TOTAL_TIPOS_OCORRENCIA,
    COUNT(CASE WHEN EXTDATA IS NULL THEN 1 END) AS SEM_DATA,
    COUNT(CASE WHEN EXTVALOR IS NULL THEN 1 END) AS SEM_VALOR
FROM EXTDETALHE;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com EXTDETALHE | Tipo |
|--------|-----------|------------------------|------|
| **EXTDETALHE** | 1.862 | 1:1 | **TABELA PRINCIPAL** |
| BCOEXTRATO | 100 | 1:18.62 | Extratos (média de 18.62 transações por extrato) |
| EXTCONCILIACAO | 1.782 | 1:0.96 | Conciliações (média de 0.96 conciliações por transação) |

**Interpretação:**
- **1.862 transações** registradas no sistema
- **Média de 18.62 transações por extrato** - indica extratos com múltiplas transações
- **Média de 0.96 conciliações por transação** - indica que quase todas as transações são conciliadas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por arquivo de extrato (consultas frequentes)
CREATE INDEX IDX_EXTDETALHE_ARQUIVO ON EXTDETALHE(IDARQUIVO)
    WHERE IDARQUIVO IS NOT NULL;

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_EXTDETALHE_DATA ON EXTDETALHE(EXTDATA)
    WHERE EXTDATA IS NOT NULL;

-- Índice 3: Busca por ocorrência (consultas frequentes)
CREATE INDEX IDX_EXTDETALHE_OCORRENCIA ON EXTDETALHE(EXTOCORRENCIA)
    WHERE EXTOCORRENCIA IS NOT NULL;

-- Índice 4: Busca por valor (consultas frequentes)
CREATE INDEX IDX_EXTDETALHE_VALOR ON EXTDETALHE(EXTVALOR)
    WHERE EXTVALOR IS NOT NULL;

-- Índice 5: Busca combinada arquivo + sequencial (já coberto pela PK)
-- A PK já fornece índice eficiente
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

final class FirebirdExtdetalhe extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'EXTDETALHE';
    
    protected $primaryKey = ['IDARQUIVO', 'EXTSEQ'];
    public $incrementing = false;

    protected $casts = [
        'IDARQUIVO' => 'integer',
        'EXTSEQ' => 'integer',
        'EXTDATA' => 'date',
        'EXTOCORRENCIA' => 'string',
        'EXTVALOR' => 'decimal:2',
        'EXTID' => 'string',
        'EXTDOCUMENTO' => 'string',
    ];

    // Relacionamento com BCOEXTRATO
    public function extratoBancario(): BelongsTo
    {
        return $this->belongsTo(FirebirdBcoextrato::class, 'IDARQUIVO', 'ID');
    }

    // Relacionamento com EXTCONCILIACAO
    public function conciliacao(): HasMany
    {
        return $this->hasMany(FirebirdExtconciliacao::class, ['IDARQUIVO', 'EXTSEQ'], ['IDARQUIVO', 'EXTSEQ']);
    }

    public function scopePorExtrato($query, int $idArquivo)
    {
        return $query->where('IDARQUIVO', $idArquivo);
    }

    public function scopePorOcorrencia($query, string $ocorrencia)
    {
        return $query->where('EXTOCORRENCIA', $ocorrencia);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('EXTDATA', [$dataInicial, $dataFinal]);
    }

    public function scopePorValor($query, $valorMinimo, $valorMaximo = null)
    {
        $query->where('EXTVALOR', '>=', $valorMinimo);
        if ($valorMaximo !== null) {
            $query->where('EXTVALOR', '<=', $valorMaximo);
        }
        return $query;
    }

    public function scopeConcilidadas($query)
    {
        return $query->whereHas('conciliacao');
    }

    public function scopeNaoConcilidadas($query)
    {
        return $query->whereDoesntHave('conciliacao');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

