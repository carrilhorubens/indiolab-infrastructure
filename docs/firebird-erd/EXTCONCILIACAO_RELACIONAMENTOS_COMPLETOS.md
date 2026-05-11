# EXTCONCILIACAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: EXTCONCILIACAO (Conciliação de Extrato Bancário)
- **Total de Registros**: 1.782
- **Total de Colunas**: 7
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 7
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**EXTCONCILIACAO** é uma tabela que armazena registros de conciliação entre transações de extratos bancários e lançamentos contábeis (CCORR). Com **1.782 registros**, representa vinculações entre transações do extrato bancário e seus lançamentos contábeis correspondentes, permitindo controle e rastreamento completo de conciliação bancária.

Esta tabela funciona como **ponte de conciliação** entre extratos bancários e lançamentos contábeis e permite:
- Vincular transações de extrato bancário a lançamentos contábeis
- Rastrear conciliações realizadas
- Controlar quais transações foram conciliadas
- Suportar processo de conciliação bancária automatizado
- Facilitar identificação de transações não conciliadas
- Manter histórico de conciliações

Cada registro representa uma conciliação específica entre uma transação de extrato e um lançamento contábil, contendo:
- Identificador único do registro (ID)
- Identificador do arquivo de extrato (IDARQUIVO) - FK → BCOEXTRATO e EXTDETALHE
- Sequencial da transação no extrato (EXTSEQ) - FK → EXTDETALHE
- Código do banco do lançamento (BCOCODIGO) - FK → CCORR
- Número da conta do lançamento (CTANRCONTA) - FK → CCORR
- Número do lançamento contábil (CCONRLANCTO) - FK → CCORR
- Empresa do lançamento (EMPCCORR) - FK → CCORR

O sistema utiliza esta tabela para realizar e controlar a conciliação bancária, vinculando transações de extratos importados com lançamentos contábeis existentes.

**Observação Importante:** EXTCONCILIACAO é uma tabela intermediária que conecta extratos bancários (BCOEXTRATO/EXTDETALHE) com lançamentos contábeis (CCORR). Com 1.782 registros e 7 foreign keys, indica uso extensivo desta funcionalidade de conciliação bancária.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | Identificador único do registro de conciliação (PK) |

### Relacionamentos com Extrato
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IDARQUIVO** 🔗 | INTEGER | | Identificador do arquivo de extrato (FK → BCOEXTRATO e EXTDETALHE) |
| **EXTSEQ** 🔗 | INTEGER | | Sequencial da transação no extrato (FK → EXTDETALHE) |

### Relacionamentos com Lançamento Contábil
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **BCOCODIGO** 🔗 | SMALLINT | | Código do banco do lançamento (FK → CCORR) |
| **CTANRCONTA** 🔗 | VARCHAR(37) | | Número da conta do lançamento (FK → CCORR) |
| **CCONRLANCTO** 🔗 | INTEGER | | Número do lançamento contábil (FK → CCORR) |
| **EMPCCORR** 🔗 | SMALLINT | | Empresa do lançamento (FK → CCORR) |

**Primary Key:** ID

**Foreign Keys:**
- `IDARQUIVO` → `BCOEXTRATO.ID` (Constraint: EXTCONCILIACAO_BCOEXTRATO)
- `IDARQUIVO` → `EXTDETALHE.IDARQUIVO` (Constraint: EXTCONCILIACAO_EXTDETALHE)
- `EXTSEQ` → `EXTDETALHE.EXTSEQ` (Constraint: EXTCONCILIACAO_EXTDETALHE)
- `BCOCODIGO` → `CCORR.BCOCODIGO` (Constraint: EXTCONCILIACAO_CCORR)
- `CTANRCONTA` → `CCORR.CTANRCONTA` (Constraint: EXTCONCILIACAO_CCORR)
- `CCONRLANCTO` → `CCORR.CCONRLANCTO` (Constraint: EXTCONCILIACAO_CCORR)
- `EMPCCORR` → `CCORR.EMPCCORR` (Constraint: EXTCONCILIACAO_CCORR)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### EXTCONCILIACAO Referencia (7 FKs):

#### 1. BCOEXTRATO - Extratos Bancários
**Relacionamento:**
```
EXTCONCILIACAO.IDARQUIVO → BCOEXTRATO.ID (N:1)
Constraint: EXTCONCILIACAO_BCOEXTRATO
```

**Descrição**: Cada conciliação está vinculada a um arquivo de extrato específico.

**Informações da Tabela BCOEXTRATO:**
- **Total:** 100 extratos
- **PK:** ID
- **Colunas:** 6 campos

**Uso:** Identificar o extrato bancário relacionado à conciliação.

---

#### 2. EXTDETALHE - Detalhes das Transações do Extrato (2 campos da FK composta)
**Relacionamento:**
```
EXTCONCILIACAO.IDARQUIVO, EXTCONCILIACAO.EXTSEQ → EXTDETALHE.IDARQUIVO, EXTDETALHE.EXTSEQ (N:1)
Constraint: EXTCONCILIACAO_EXTDETALHE
```

**Descrição**: Cada conciliação está vinculada a uma transação específica do extrato através de chave composta.

**Informações da Tabela EXTDETALHE:**
- **Total:** 1.862 transações
- **PK:** (IDARQUIVO, EXTSEQ)
- **Colunas:** 7 campos

**Uso:** Identificar a transação específica do extrato que foi conciliada.

---

#### 3. CCORR - Lançamentos Contábeis (4 campos da FK composta)
**Relacionamento:**
```
EXTCONCILIACAO.BCOCODIGO, EXTCONCILIACAO.CTANRCONTA, EXTCONCILIACAO.CCONRLANCTO, EXTCONCILIACAO.EMPCCORR → CCORR.BCOCODIGO, CCORR.CTANRCONTA, CCORR.CCONRLANCTO, CCORR.EMPCCORR (N:1)
Constraint: EXTCONCILIACAO_CCORR
```

**Descrição**: Cada conciliação está vinculada a um lançamento contábil específico através de chave composta.

**Informações da Tabela CCORR:**
- **Total:** 208.120 lançamentos
- **PK:** (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
- **Colunas:** 36 campos

**Uso:** Identificar o lançamento contábil que foi conciliado com a transação do extrato.

---

### EXTCONCILIACAO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia EXTCONCILIACAO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via BCOEXTRATO → BANCO, EMPRESA, CONTA

**Fluxo:** EXTCONCILIACAO → BCOEXTRATO → BANCO/EMPRESA/CONTA

**Descrição:** Através do extrato, é possível identificar banco, empresa e conta relacionadas.

**Uso:** Análise de conciliações por banco, empresa ou conta.

---

### Via EXTDETALHE → BCOEXTRATO → Outras Operações

**Fluxo:** EXTCONCILIACAO → EXTDETALHE → BCOEXTRATO → Operações

**Descrição:** Através da transação do extrato, é possível identificar outras operações relacionadas.

**Uso:** Análise de transações conciliadas.

---

### Via CCORR → Outras Operações Contábeis

**Fluxo:** EXTCONCILIACAO → CCORR → Operações Contábeis

**Descrição:** Através do lançamento contábil, é possível identificar outras operações relacionadas.

**Uso:** Análise de lançamentos contábeis conciliados.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Conciliação

**Objetivo:** Obter visão completa de uma conciliação incluindo informações do extrato, transação e lançamento contábil.

**Fluxo:**
```
EXTCONCILIACAO (IDARQUIVO, EXTSEQ, BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
  ↓
EXTDETALHE (IDARQUIVO, EXTSEQ)
  ↓
BCOEXTRATO (ID)
  ↓
BANCO (BCOCODIGO)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    exc.ID AS ID_CONCILIACAO,
    exc.IDARQUIVO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    bco.BCONOME AS BANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    exc.EXTSEQ AS SEQUENCIAL_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTDOCUMENTO AS DOCUMENTO_TRANSACAO,
    exc.BCOCODIGO AS BCO_LANCAMENTO,
    exc.CTANRCONTA AS CONTA_LANCAMENTO,
    exc.CCONRLANCTO AS NUMERO_LANCAMENTO,
    exc.EMPCCORR AS EMP_LANCAMENTO,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    cco.CCOHISTORICO AS HISTORICO_LANCAMENTO
FROM EXTCONCILIACAO exc
INNER JOIN EXTDETALHE det ON det.IDARQUIVO = exc.IDARQUIVO
                         AND det.EXTSEQ = exc.EXTSEQ
INNER JOIN BCOEXTRATO ext ON ext.ID = exc.IDARQUIVO
LEFT JOIN BANCO bco ON bco.BCOCODIGO = ext.BCOCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ext.EMPCODIGO
LEFT JOIN CCORR cco ON cco.BCOCODIGO = exc.BCOCODIGO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.CCONRLANCTO = exc.CCONRLANCTO
                   AND cco.EMPCCORR = exc.EMPCCORR
WHERE exc.ID = ?;
```

---

### Exemplo 2: Análise de Conciliações por Extrato

**Objetivo:** Identificar todas as conciliações relacionadas a um extrato específico.

**Query SQL:**
```sql
SELECT
    exc.ID AS ID_CONCILIACAO,
    exc.EXTSEQ AS SEQUENCIAL_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    exc.CCONRLANCTO AS NUMERO_LANCAMENTO,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    COUNT(*) OVER (PARTITION BY exc.IDARQUIVO) AS TOTAL_CONCILIACOES_EXTRATO
FROM EXTCONCILIACAO exc
INNER JOIN EXTDETALHE det ON det.IDARQUIVO = exc.IDARQUIVO
                         AND det.EXTSEQ = exc.EXTSEQ
LEFT JOIN CCORR cco ON cco.BCOCODIGO = exc.BCOCODIGO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.CCONRLANCTO = exc.CCONRLANCTO
                   AND cco.EMPCCORR = exc.EMPCCORR
WHERE exc.IDARQUIVO = ?
ORDER BY exc.EXTSEQ;
```

---

### Exemplo 3: Análise de Conciliações por Lançamento Contábil

**Objetivo:** Identificar todas as conciliações relacionadas a um lançamento contábil específico.

**Query SQL:**
```sql
SELECT
    exc.ID AS ID_CONCILIACAO,
    exc.IDARQUIVO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    exc.EXTSEQ AS SEQUENCIAL_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    cco.CCOHISTORICO AS HISTORICO_LANCAMENTO,
    COUNT(*) OVER (PARTITION BY exc.BCOCODIGO, exc.CTANRCONTA, exc.CCONRLANCTO, exc.EMPCCORR) AS TOTAL_CONCILIACOES_LANCAMENTO
FROM EXTCONCILIACAO exc
INNER JOIN EXTDETALHE det ON det.IDARQUIVO = exc.IDARQUIVO
                         AND det.EXTSEQ = exc.EXTSEQ
LEFT JOIN BCOEXTRATO ext ON ext.ID = exc.IDARQUIVO
LEFT JOIN CCORR cco ON cco.BCOCODIGO = exc.BCOCODIGO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.CCONRLANCTO = exc.CCONRLANCTO
                   AND cco.EMPCCORR = exc.EMPCCORR
WHERE exc.BCOCODIGO = ?
  AND exc.CTANRCONTA = ?
  AND exc.CCONRLANCTO = ?
  AND exc.EMPCCORR = ?
ORDER BY exc.IDARQUIVO, exc.EXTSEQ;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Conciliação

**Objetivo:** Obter informações de uma conciliação específica.

```sql
SELECT
    ID,
    IDARQUIVO,
    EXTSEQ,
    BCOCODIGO,
    CTANRCONTA,
    CCONRLANCTO,
    EMPCCORR
FROM EXTCONCILIACAO
WHERE ID = ?;
```

---

### 2. Listar Conciliações de um Extrato

**Objetivo:** Obter todas as conciliações relacionadas a um extrato específico.

```sql
SELECT
    ID,
    EXTSEQ,
    BCOCODIGO,
    CTANRCONTA,
    CCONRLANCTO,
    EMPCCORR
FROM EXTCONCILIACAO
WHERE IDARQUIVO = ?
ORDER BY EXTSEQ;
```

---

### 3. Análise de Conciliações por Banco

**Objetivo:** Identificar distribuição de conciliações por banco.

**Query SQL:**
```sql
SELECT
    exc.BCOCODIGO,
    bco.BCONOME AS BANCO,
    COUNT(*) AS TOTAL_CONCILIACOES,
    COUNT(DISTINCT exc.IDARQUIVO) AS TOTAL_EXTRATOS,
    COUNT(DISTINCT exc.CCONRLANCTO) AS TOTAL_LANCAMENTOS
FROM EXTCONCILIACAO exc
LEFT JOIN BANCO bco ON bco.BCOCODIGO = exc.BCOCODIGO
WHERE exc.BCOCODIGO IS NOT NULL
GROUP BY exc.BCOCODIGO, bco.BCONOME
ORDER BY TOTAL_CONCILIACOES DESC;
```

---

### 4. Análise de Transações Não Concilidadas

**Objetivo:** Identificar transações de extrato que não foram conciliadas.

**Query SQL:**
```sql
SELECT
    det.IDARQUIVO,
    det.EXTSEQ,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTDOCUMENTO AS DOCUMENTO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO
FROM EXTDETALHE det
INNER JOIN BCOEXTRATO ext ON ext.ID = det.IDARQUIVO
LEFT JOIN EXTCONCILIACAO exc ON exc.IDARQUIVO = det.IDARQUIVO
                             AND exc.EXTSEQ = det.EXTSEQ
WHERE exc.ID IS NULL
ORDER BY det.IDARQUIVO, det.EXTSEQ;
```

---

### 5. Análise de Lançamentos Não Conciliados

**Objetivo:** Identificar lançamentos contábeis que não foram conciliados com extratos.

**Query SQL:**
```sql
SELECT
    cco.BCOCODIGO,
    cco.CTANRCONTA,
    cco.CCONRLANCTO,
    cco.EMPCCORR,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    cco.CCOHISTORICO AS HISTORICO,
    bco.BCONOME AS BANCO
FROM CCORR cco
LEFT JOIN BANCO bco ON bco.BCOCODIGO = cco.BCOCODIGO
LEFT JOIN EXTCONCILIACAO exc ON exc.BCOCODIGO = cco.BCOCODIGO
                             AND exc.CTANRCONTA = cco.CTANRCONTA
                             AND exc.CCONRLANCTO = cco.CCONRLANCTO
                             AND exc.EMPCCORR = cco.EMPCCORR
WHERE exc.ID IS NULL
  AND cco.CCOENTSAI = 'E'  -- Apenas entradas (ajustar conforme necessário)
ORDER BY cco.CCODATA DESC;
```

---

### 6. Análise de Conciliações por Período

**Objetivo:** Identificar distribuição de conciliações ao longo do tempo através dos extratos.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM ext.BCEDATA) AS ANO,
    EXTRACT(MONTH FROM ext.BCEDATA) AS MES,
    COUNT(*) AS TOTAL_CONCILIACOES,
    COUNT(DISTINCT exc.IDARQUIVO) AS TOTAL_EXTRATOS,
    COUNT(DISTINCT exc.CCONRLANCTO) AS TOTAL_LANCAMENTOS
FROM EXTCONCILIACAO exc
LEFT JOIN BCOEXTRATO ext ON ext.ID = exc.IDARQUIVO
WHERE ext.BCEDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM ext.BCEDATA), EXTRACT(MONTH FROM ext.BCEDATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 7. Relatório Completo de Conciliações

**Objetivo:** Analisar distribuição completa de conciliações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CONCILIACOES,
    COUNT(DISTINCT IDARQUIVO) AS TOTAL_EXTRATOS_CONCILIADOS,
    COUNT(DISTINCT CCONRLANCTO) AS TOTAL_LANCAMENTOS_CONCILIADOS,
    COUNT(DISTINCT BCOCODIGO) AS TOTAL_BANCOS,
    COUNT(CASE WHEN IDARQUIVO IS NULL THEN 1 END) AS SEM_EXTRATO,
    COUNT(CASE WHEN CCONRLANCTO IS NULL THEN 1 END) AS SEM_LANCAMENTO
FROM EXTCONCILIACAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com EXTCONCILIACAO | Tipo |
|--------|-----------|----------------------------|------|
| **EXTCONCILIACAO** | 1.782 | 1:1 | **TABELA PRINCIPAL** |
| BCOEXTRATO | 100 | 1:17.82 | Extratos (média de 17.82 conciliações por extrato) |
| EXTDETALHE | 1.862 | 1:0.96 | Transações (média de 0.96 conciliações por transação) |
| CCORR | 208.120 | 1:0.0086 | Lançamentos (média de 0.0086 conciliações por lançamento) |

**Interpretação:**
- **1.782 conciliações** registradas no sistema
- **Média de 17.82 conciliações por extrato** - indica uso extensivo desta funcionalidade
- **Média de 0.96 conciliações por transação** - indica que quase todas as transações são conciliadas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por arquivo de extrato (consultas frequentes)
CREATE INDEX IDX_EXTCONCILIACAO_ARQUIVO ON EXTCONCILIACAO(IDARQUIVO)
    WHERE IDARQUIVO IS NOT NULL;

-- Índice 2: Busca por transação do extrato (consultas frequentes)
CREATE INDEX IDX_EXTCONCILIACAO_TRANSACAO ON EXTCONCILIACAO(IDARQUIVO, EXTSEQ)
    WHERE IDARQUIVO IS NOT NULL AND EXTSEQ IS NOT NULL;

-- Índice 3: Busca por lançamento contábil (consultas frequentes)
CREATE INDEX IDX_EXTCONCILIACAO_LANCAMENTO ON EXTCONCILIACAO(BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
    WHERE BCOCODIGO IS NOT NULL AND CCONRLANCTO IS NOT NULL;

-- Índice 4: Busca combinada arquivo + transação (consultas frequentes)
CREATE INDEX IDX_EXTCONCILIACAO_ARQUIVO_TRANSACAO ON EXTCONCILIACAO(IDARQUIVO, EXTSEQ);
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

final class FirebirdExtconciliacao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'EXTCONCILIACAO';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'IDARQUIVO' => 'integer',
        'EXTSEQ' => 'integer',
        'BCOCODIGO' => 'integer',
        'CTANRCONTA' => 'string',
        'CCONRLANCTO' => 'integer',
        'EMPCCORR' => 'integer',
    ];

    // Relacionamento com BCOEXTRATO
    public function extratoBancario(): BelongsTo
    {
        return $this->belongsTo(FirebirdBcoextrato::class, 'IDARQUIVO', 'ID');
    }

    // Relacionamento com EXTDETALHE
    public function detalheExtrato()
    {
        return $this->belongsTo(FirebirdExtdetalhe::class, ['IDARQUIVO', 'EXTSEQ'], ['IDARQUIVO', 'EXTSEQ']);
    }

    // Relacionamento com CCORR
    public function lancamentoContabil()
    {
        return $this->belongsTo(FirebirdCcorr::class, 
                               ['BCOCODIGO', 'CTANRCONTA', 'CCONRLANCTO', 'EMPCCORR'],
                               ['BCOCODIGO', 'CTANRCONTA', 'CCONRLANCTO', 'EMPCCORR']);
    }

    public function scopePorExtrato($query, int $idArquivo)
    {
        return $query->where('IDARQUIVO', $idArquivo);
    }

    public function scopePorTransacao($query, int $idArquivo, int $extSeq)
    {
        return $query->where('IDARQUIVO', $idArquivo)
                    ->where('EXTSEQ', $extSeq);
    }

    public function scopePorLancamento($query, int $bcoCodigo, string $ctaNrConta, int $cconrLancto, int $empCcorr)
    {
        return $query->where('BCOCODIGO', $bcoCodigo)
                    ->where('CTANRCONTA', $ctaNrConta)
                    ->where('CCONRLANCTO', $cconrLancto)
                    ->where('EMPCCORR', $empCcorr);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

