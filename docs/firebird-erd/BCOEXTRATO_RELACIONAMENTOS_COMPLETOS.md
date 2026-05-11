# BCOEXTRATO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: BCOEXTRATO (Extratos Bancários Importados)
- **Total de Registros**: 100
- **Total de Colunas**: 6
- **Chave Primária**: ID
- **Chaves Estrangeiras**: 5
- **Índices**: 0
- **Tabelas Dependentes**: 2 (EXTDETALHE, EXTCONCILIACAO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**BCOEXTRATO** é a tabela central de armazenamento de extratos bancários importados no sistema. Com **100 registros**, representa arquivos de extrato bancário que foram importados e processados pelo sistema de conciliação bancária.

Esta tabela funciona como **cabeçalho de extrato** e conecta:
- **Bancos** (BANCO) - instituição financeira de origem
- **Empresas** (EMPRESA) - empresa proprietária da conta
- **Contas bancárias** (CONTA) - conta específica do extrato
- **Detalhes do extrato** (EXTDETALHE) - transações individuais
- **Conciliações** (EXTCONCILIACAO) - vinculação com lançamentos contábeis

Cada registro representa um arquivo de extrato importado, contendo:
- Identificação do banco e conta
- Nome do arquivo importado
- Data do extrato
- Empresa relacionada

O sistema de conciliação bancária utiliza esta tabela como ponto de partida para processar e conciliar transações bancárias com lançamentos contábeis.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ID** 🔑 | INTEGER | Identificador único do extrato (PK) |

### Relacionamentos
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BCOCODIGO** 🔗 | INTEGER | Código do banco (FK → BANCO) |
| **NRCONTA** 🔗 | VARCHAR(37) | Número da conta bancária (FK → CONTA) |
| **EMPCODIGO** 🔗 | INTEGER | Código da empresa (FK → EMPRESA) |

### Dados do Arquivo
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BCEARQUIVO** | VARCHAR(37) | Nome do arquivo de extrato importado |
| **BCEDATA** | DATE | Data do extrato bancário |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

BCOEXTRATO possui **5 chaves estrangeiras** organizadas em 3 categorias:

### Categoria 1: Identificação Bancária

#### BANCO - Instituição Financeira
**Volume:** 108 registros

**Relacionamento:**
```
BCOEXTRATO.BCOCODIGO → BANCO.BCOCODIGO (N:1) [FK: BCOEXTRATO_BANCO]
```

**Descrição:** Cada extrato está vinculado ao banco de origem. Identifica a instituição financeira que emitiu o extrato.

**Campos importantes em BANCO:**
- `BCONOME` - Nome do banco
- `BCONRCOMP` - Número de compensação
- `BCOINTERNET` - Flag de internet banking

**Proporção:** ~0.9 extratos por banco em média

---

#### CONTA - Conta Bancária (3 Relacionamentos)

**Relacionamento 1:**
```
BCOEXTRATO.BCOCODIGO → CONTA.BCOCODIGO (N:1) [FK: BCOEXTRATO_CONTA]
```

**Relacionamento 2:**
```
BCOEXTRATO.NRCONTA → CONTA.CTANRCONTA (N:1) [FK: BCOEXTRATO_CONTA]
```

**Relacionamento 3:**
```
BCOEXTRATO.EMPCODIGO → CONTA.EMPCCORR (N:1) [FK: BCOEXTRATO_CONTA]
```

**Descrição:** O extrato está vinculado a uma conta bancária específica através de uma chave composta (BCOCODIGO + CTANRCONTA + EMPCCORR). Os três campos juntos identificam unicamente a conta.

**Campos importantes em CONTA:**
- `CTANRCONTA` - Número da conta
- `CTAAGENCIA` - Agência bancária
- `CTASALDOIMPL` - Saldo inicial
- `CTAVRLIMITE` - Valor limite

**Proporção:** Múltiplos extratos por conta

---

### Categoria 2: Identificação Empresarial

#### EMPRESA - Empresa Proprietária
**Volume:** 6 registros

**Relacionamento:**
```
BCOEXTRATO.EMPCODIGO → EMPRESA.EMPCODIGO (N:1) [FK: BCOEXTRATO_EMPRESA]
```

**Descrição:** Identifica a empresa/filial proprietária da conta bancária do extrato.

**Campos importantes em EMPRESA:**
- `EMPRAZSOCIAL` - Razão social
- `EMPCNPJ` - CNPJ da empresa
- `EMPNOMEFNT` - Nome fantasia

**Proporção:** ~16.7 extratos por empresa em média

---

### Categoria 3: Tabelas Dependentes (Detalhes e Conciliação)

#### EXTDETALHE - Detalhes das Transações
**Volume:** 1.862 registros

**Relacionamento:**
```
EXTDETALHE.IDARQUIVO → BCOEXTRATO.ID (N:1) [FK: EXTDETALHE_BCOEXTRATO]
```

**Descrição:** Cada extrato possui múltiplas transações detalhadas. EXTDETALHE armazena cada movimentação individual do extrato.

**Campos importantes em EXTDETALHE:**
- `EXTSEQ` - Sequência da transação (PK composta com IDARQUIVO)
- `EXTDATA` - Data da transação
- `EXTOCORRENCIA` - Tipo de ocorrência
- `EXTVALOR` - Valor da transação
- `EXTDOCUMENTO` - Número do documento
- `EXTID` - Identificador da transação

**Proporção:** ~18.6 transações por extrato em média

---

#### EXTCONCILIACAO - Conciliação Bancária
**Volume:** 1.782 registros

**Relacionamento:**
```
EXTCONCILIACAO.IDARQUIVO → BCOEXTRATO.ID (N:1) [FK: EXTCONCILIACAO_BCOEXTRATO]
```

**Descrição:** Registra a conciliação entre transações do extrato e lançamentos contábeis (CCORR). Vincula cada transação do extrato com seu lançamento correspondente.

**Campos importantes em EXTCONCILIACAO:**
- `EXTSEQ` - Sequência da transação (FK → EXTDETALHE)
- `BCOCODIGO` - Código do banco (FK → CCORR)
- `CTANRCONTA` - Número da conta (FK → CCORR)
- `CCONRLANCTO` - Número do lançamento (FK → CCORR)
- `EMPCCORR` - Empresa do lançamento (FK → CCORR)

**Proporção:** ~17.8 conciliações por extrato em média

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via EXTDETALHE

#### EXTDETALHE → EXTCONCILIACAO → CCORR
**Fluxo:** BCOEXTRATO → EXTDETALHE → EXTCONCILIACAO → CCORR

**Descrição:** As transações do extrato são conciliadas com lançamentos contábeis através de EXTCONCILIACAO, que referencia tanto EXTDETALHE quanto CCORR.

**Campos de junção:**
- `EXTDETALHE.IDARQUIVO + EXTDETALHE.EXTSEQ` → `EXTCONCILIACAO.IDARQUIVO + EXTCONCILIACAO.EXTSEQ`
- `EXTCONCILIACAO.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR` (chave composta)

---

### Via CONTA

#### CONTA → BANCO
**Fluxo:** BCOEXTRATO → CONTA → BANCO

**Descrição:** A conta bancária está vinculada ao banco, permitindo navegar do extrato até o banco através da conta.

---

### Via EMPRESA

#### EMPRESA → CONTA
**Fluxo:** BCOEXTRATO → EMPRESA → CONTA

**Descrição:** A empresa possui contas bancárias cadastradas, permitindo identificar todas as contas de uma empresa através do extrato.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Fluxo Completo de Conciliação Bancária

**Objetivo:** Identificar todas as transações de um extrato e suas conciliações com lançamentos contábeis.

**Fluxo:**
```
BCOEXTRATO (ID)
  ↓
EXTDETALHE (IDARQUIVO, EXTSEQ)
  ↓
EXTCONCILIACAO (IDARQUIVO, EXTSEQ)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    ext.ID AS EXTRATO_ID,
    ext.BCEARQUIVO AS ARQUIVO,
    ext.BCEDATA AS DATA_EXTRATO,
    b.BCONOME AS BANCO,
    c.CTANRCONTA AS CONTA,
    e.EMPRAZSOCIAL AS EMPRESA,
    det.EXTSEQ AS SEQ_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTDOCUMENTO AS DOCUMENTO,
    conc.CCONRLANCTO AS NUM_LANCTO,
    ccor.CCOVALOR AS VALOR_LANCTO,
    ccor.CCODTLANCTO AS DATA_LANCTO,
    CASE 
        WHEN conc.ID IS NOT NULL THEN 'CONCILIADO'
        ELSE 'PENDENTE'
    END AS STATUS_CONCILIACAO
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
LEFT JOIN CCORR ccor ON ccor.BCOCODIGO = conc.BCOCODIGO
                    AND ccor.CTANRCONTA = conc.CTANRCONTA
                    AND ccor.CCONRLANCTO = conc.CCONRLANCTO
                    AND ccor.EMPCCORR = conc.EMPCCORR
WHERE ext.ID = ?
ORDER BY det.EXTSEQ;
```

---

### Exemplo 2: Análise de Extratos por Banco e Empresa

**Objetivo:** Listar todos os extratos de um banco específico com informações completas.

**Fluxo:**
```
BANCO (BCOCODIGO)
  ↓
BCOEXTRATO (BCOCODIGO)
  ↓
EMPRESA (EMPCODIGO)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    b.BCONOME AS BANCO,
    e.EMPRAZSOCIAL AS EMPRESA,
    c.CTANRCONTA AS CONTA,
    ext.ID AS EXTRATO_ID,
    ext.BCEARQUIVO AS ARQUIVO,
    ext.BCEDATA AS DATA_EXTRATO,
    COUNT(det.EXTSEQ) AS TOTAL_TRANSACOES,
    SUM(det.EXTVALOR) AS VALOR_TOTAL,
    COUNT(conc.ID) AS TRANSACOES_CONCILIADAS,
    COUNT(det.EXTSEQ) - COUNT(conc.ID) AS TRANSACOES_PENDENTES
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
WHERE b.BCOCODIGO = ?
GROUP BY b.BCONOME, e.EMPRAZSOCIAL, c.CTANRCONTA, 
         ext.ID, ext.BCEARQUIVO, ext.BCEDATA
ORDER BY ext.BCEDATA DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Extratos por Empresa

**Objetivo:** Visualizar todos os extratos importados de uma empresa específica.

```sql
SELECT
    ext.ID,
    ext.BCEARQUIVO AS ARQUIVO,
    ext.BCEDATA AS DATA_EXTRATO,
    b.BCONOME AS BANCO,
    c.CTANRCONTA AS CONTA,
    COUNT(det.EXTSEQ) AS TOTAL_TRANSACOES
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
WHERE ext.EMPCODIGO = ?
GROUP BY ext.ID, ext.BCEARQUIVO, ext.BCEDATA, b.BCONOME, c.CTANRCONTA
ORDER BY ext.BCEDATA DESC;
```

---

### 2. Buscar Extrato por Arquivo

**Objetivo:** Localizar um extrato específico pelo nome do arquivo importado.

```sql
SELECT
    ext.*,
    b.BCONOME AS BANCO,
    e.EMPRAZSOCIAL AS EMPRESA,
    c.CTANRCONTA AS CONTA
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
WHERE ext.BCEARQUIVO = ?;
```

---

### 3. Análise de Transações Não Concilidadas

**Objetivo:** Identificar transações do extrato que ainda não foram conciliadas com lançamentos contábeis.

```sql
SELECT
    ext.ID AS EXTRATO_ID,
    ext.BCEARQUIVO AS ARQUIVO,
    det.EXTSEQ AS SEQ_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR,
    det.EXTDOCUMENTO AS DOCUMENTO,
    b.BCONOME AS BANCO,
    c.CTANRCONTA AS CONTA
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
INNER JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
WHERE conc.ID IS NULL
  AND ext.BCEDATA BETWEEN ? AND ?
ORDER BY ext.BCEDATA DESC, det.EXTSEQ;
```

---

### 4. Relatório de Extratos por Período

**Objetivo:** Gerar relatório consolidado de extratos importados em um período.

```sql
SELECT
    b.BCONOME AS BANCO,
    e.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT ext.ID) AS TOTAL_EXTRATOS,
    COUNT(det.EXTSEQ) AS TOTAL_TRANSACOES,
    SUM(det.EXTVALOR) AS VALOR_TOTAL,
    MIN(ext.BCEDATA) AS PRIMEIRA_DATA,
    MAX(ext.BCEDATA) AS ULTIMA_DATA,
    COUNT(conc.ID) AS TRANSACOES_CONCILIADAS,
    ROUND(COUNT(conc.ID) * 100.0 / COUNT(det.EXTSEQ), 2) AS PERCENTUAL_CONCILIADO
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
WHERE ext.BCEDATA BETWEEN ? AND ?
GROUP BY b.BCONOME, e.EMPRAZSOCIAL
ORDER BY TOTAL_EXTRATOS DESC;
```

---

### 5. Verificar Duplicidade de Arquivos

**Objetivo:** Identificar arquivos de extrato duplicados no sistema.

```sql
SELECT
    BCEARQUIVO AS ARQUIVO,
    COUNT(*) AS QUANTIDADE,
    STRING_AGG(CAST(ID AS VARCHAR), ', ') AS IDS_EXTRATOS,
    STRING_AGG(CAST(BCEDATA AS VARCHAR), ', ') AS DATAS
FROM BCOEXTRATO
GROUP BY BCEARQUIVO
HAVING COUNT(*) > 1
ORDER BY QUANTIDADE DESC;
```

---

### 6. Análise de Conciliação por Banco

**Objetivo:** Verificar taxa de conciliação de extratos por banco.

```sql
SELECT
    b.BCOCODIGO,
    b.BCONOME AS BANCO,
    COUNT(DISTINCT ext.ID) AS TOTAL_EXTRATOS,
    COUNT(det.EXTSEQ) AS TOTAL_TRANSACOES,
    COUNT(conc.ID) AS TRANSACOES_CONCILIADAS,
    COUNT(det.EXTSEQ) - COUNT(conc.ID) AS TRANSACOES_PENDENTES,
    ROUND(COUNT(conc.ID) * 100.0 / NULLIF(COUNT(det.EXTSEQ), 0), 2) AS TAXA_CONCILIACAO
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
GROUP BY b.BCOCODIGO, b.BCONOME
HAVING COUNT(det.EXTSEQ) > 0
ORDER BY TAXA_CONCILIACAO DESC;
```

---

### 7. Detalhamento Completo de Extrato

**Objetivo:** Obter visão completa de um extrato com todas as transações e conciliações.

```sql
SELECT
    ext.ID AS EXTRATO_ID,
    ext.BCEARQUIVO AS ARQUIVO,
    ext.BCEDATA AS DATA_EXTRATO,
    b.BCONOME AS BANCO,
    b.BCONRCOMP AS NUM_COMPENSACAO,
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    c.CTANRCONTA AS CONTA,
    c.CTAAGENCIA AS AGENCIA,
    det.EXTSEQ AS SEQ_TRANSACAO,
    det.EXTDATA AS DATA_TRANSACAO,
    det.EXTOCORRENCIA AS OCORRENCIA,
    det.EXTVALOR AS VALOR_TRANSACAO,
    det.EXTDOCUMENTO AS DOCUMENTO,
    det.EXTID AS ID_TRANSACAO,
    conc.CCONRLANCTO AS NUM_LANCTO,
    ccor.CCOVALOR AS VALOR_LANCTO,
    ccor.CCODTLANCTO AS DATA_LANCTO,
    ccor.CCOHISTORICO AS HISTORICO,
    CASE 
        WHEN conc.ID IS NOT NULL THEN 'CONCILIADO'
        ELSE 'PENDENTE'
    END AS STATUS_CONCILIACAO
FROM BCOEXTRATO ext
INNER JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
INNER JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
LEFT JOIN EXTCONCILIACAO conc ON conc.IDARQUIVO = det.IDARQUIVO
                              AND conc.EXTSEQ = det.EXTSEQ
LEFT JOIN CCORR ccor ON ccor.BCOCODIGO = conc.BCOCODIGO
                    AND ccor.CTANRCONTA = conc.CTANRCONTA
                    AND ccor.CCONRLANCTO = conc.CCONRLANCTO
                    AND ccor.EMPCCORR = conc.EMPCCORR
WHERE ext.ID = ?
ORDER BY det.EXTSEQ;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com BCOEXTRATO | Tipo |
|--------|-----------|--------------------------|------|
| **BCOEXTRATO** | 100 | 1:1 | **TABELA PRINCIPAL** |
| EXTDETALHE | 1.862 | 18.6:1 | Transações por extrato |
| EXTCONCILIACAO | 1.782 | 17.8:1 | Conciliações por extrato |
| BANCO | 108 | 0.9:1 | Bancos disponíveis |
| EMPRESA | 6 | 16.7:1 | Empresas no sistema |
| CONTA | 55 | 1.8:1 | Contas bancárias |

**Interpretação:**
- Cada extrato possui em média **18.6 transações** (EXTDETALHE)
- Cada extrato possui em média **17.8 conciliações** (EXTCONCILIACAO)
- Taxa de conciliação: **~95.7%** (17.8 / 18.6)
- Cada banco possui em média **0.9 extratos** importados
- Cada empresa possui em média **16.7 extratos** importados

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **ID** | BCOEXTRATO | Identificador único do extrato (PK) |
| **IDARQUIVO** | EXTDETALHE → BCOEXTRATO | Referência ao extrato |
| **IDARQUIVO + EXTSEQ** | EXTCONCILIACAO → EXTDETALHE | Referência à transação |
| **BCOCODIGO** | BCOEXTRATO → BANCO, CONTA | Código do banco |
| **NRCONTA** | BCOEXTRATO → CONTA | Número da conta |
| **EMPCODIGO** | BCOEXTRATO → EMPRESA, CONTA | Código da empresa |
| **BCEDATA** | BCOEXTRATO | Data do extrato |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela BCOEXTRATO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice composto para buscas por banco e data** - Melhora consultas filtradas
3. **Índice em BCEARQUIVO** - Para buscas por nome de arquivo
4. **Índice em BCEDATA** - Para filtros por período
5. **Índice composto empresa + data** - Para relatórios por empresa

### Índices Sugeridos

```sql
-- Índice 1: Busca por banco e data (consultas mais comuns)
CREATE INDEX IDX_BCOEXTRATO_BANCO_DATA ON BCOEXTRATO(BCOCODIGO, BCEDATA);

-- Índice 2: Busca por empresa e data
CREATE INDEX IDX_BCOEXTRATO_EMPRESA_DATA ON BCOEXTRATO(EMPCODIGO, BCEDATA);

-- Índice 3: Busca por arquivo (evitar duplicatas)
CREATE INDEX IDX_BCOEXTRATO_ARQUIVO ON BCOEXTRATO(BCEARQUIVO);

-- Índice 4: Busca por conta e data
CREATE INDEX IDX_BCOEXTRATO_CONTA_DATA ON BCOEXTRATO(BCOCODIGO, NRCONTA, BCEDATA);
```

### Exemplo de Query Otimizada

```sql
-- ❌ NÃO OTIMIZADO (table scan completo)
SELECT * FROM BCOEXTRATO WHERE EMPCODIGO = 1;

-- ✅ OTIMIZADO (usa índice e limita colunas)
SELECT
    ID, BCEARQUIVO, BCEDATA, BCOCODIGO, NRCONTA
FROM BCOEXTRATO
WHERE EMPCODIGO = 1
  AND BCEDATA >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY BCEDATA DESC;
```

### Observações sobre Volume

- **Tabela pequena** (100 registros) - Performance geralmente não é crítica
- **Consultas com JOINs** podem ser mais lentas devido às múltiplas tabelas relacionadas
- **EXTDETALHE e EXTCONCILIACAO** têm volumes maiores (1.8K registros cada)
- **Focar otimização nos JOINs** com tabelas dependentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar extratos sem banco válido
SELECT ext.*
FROM BCOEXTRATO ext
LEFT JOIN BANCO b ON b.BCOCODIGO = ext.BCOCODIGO
WHERE b.BCOCODIGO IS NULL;

-- Verificar extratos sem empresa válida
SELECT ext.*
FROM BCOEXTRATO ext
LEFT JOIN EMPRESA e ON e.EMPCODIGO = ext.EMPCODIGO
WHERE e.EMPCODIGO IS NULL;

-- Verificar extratos sem conta válida
SELECT ext.*
FROM BCOEXTRATO ext
LEFT JOIN CONTA c ON c.BCOCODIGO = ext.BCOCODIGO
                AND c.CTANRCONTA = ext.NRCONTA
                AND c.EMPCCORR = ext.EMPCODIGO
WHERE c.BCOCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar extratos sem transações
SELECT ext.*
FROM BCOEXTRATO ext
LEFT JOIN EXTDETALHE det ON det.IDARQUIVO = ext.ID
WHERE det.IDARQUIVO IS NULL;

-- Verificar transações sem extrato válido
SELECT det.*
FROM EXTDETALHE det
LEFT JOIN BCOEXTRATO ext ON ext.ID = det.IDARQUIVO
WHERE ext.ID IS NULL;

-- Verificar conciliações sem extrato válido
SELECT conc.*
FROM EXTCONCILIACAO conc
LEFT JOIN BCOEXTRATO ext ON ext.ID = conc.IDARQUIVO
WHERE ext.ID IS NULL;
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

final class FirebirdBcoExtrato extends Model
{
    protected $connection = 'firebird';
    protected $table = 'BCOEXTRATO';
    protected $primaryKey = 'ID';

    protected $casts = [
        'ID' => 'integer',
        'BCOCODIGO' => 'integer',
        'NRCONTA' => 'string',
        'EMPCODIGO' => 'integer',
        'BCEARQUIVO' => 'string',
        'BCEDATA' => 'date',
    ];

    // Relacionamento com BANCO
    public function banco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBanco::class, 'BCOCODIGO', 'BCOCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com CONTA (chave composta)
    public function conta(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdConta::class,
            ['BCOCODIGO', 'NRCONTA', 'EMPCODIGO'],
            ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR']
        );
    }

    // Relacionamento com EXTDETALHE (transações)
    public function detalhes(): HasMany
    {
        return $this->hasMany(FirebirdExtDetalhe::class, 'IDARQUIVO', 'ID');
    }

    // Relacionamento com EXTCONCILIACAO (conciliações)
    public function conciliacoes(): HasMany
    {
        return $this->hasMany(FirebirdExtConciliacao::class, 'IDARQUIVO', 'ID');
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, $dataInicio, $dataFim)
    {
        return $query->whereBetween('BCEDATA', [$dataInicio, $dataFim]);
    }

    // Scope para filtrar por banco
    public function scopePorBanco($query, $bancoCodigo)
    {
        return $query->where('BCOCODIGO', $bancoCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Método para verificar se está totalmente conciliado
    public function estaTotalmenteConciliado(): bool
    {
        $totalTransacoes = $this->detalhes()->count();
        $totalConciliadas = $this->conciliacoes()->count();
        
        return $totalTransacoes > 0 && $totalTransacoes === $totalConciliadas;
    }

    // Método para calcular taxa de conciliação
    public function taxaConciliacao(): float
    {
        $totalTransacoes = $this->detalhes()->count();
        
        if ($totalTransacoes === 0) {
            return 0.0;
        }
        
        $totalConciliadas = $this->conciliacoes()->count();
        
        return ($totalConciliadas / $totalTransacoes) * 100;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Validação de chaves compostas** - Sempre validar que BCOCODIGO + NRCONTA + EMPCODIGO correspondem a uma CONTA válida
2. **Controle de duplicatas** - Verificar BCEARQUIVO antes de importar para evitar arquivos duplicados
3. **Integridade temporal** - BCEDATA deve ser consistente com as datas das transações em EXTDETALHE
4. **Nomenclatura de arquivos** - Estabelecer padrão para BCEARQUIVO facilitar identificação

### Performance

1. **Sempre filtrar por período** - Usar BCEDATA para limitar resultados
2. **Usar índices compostos** - Para consultas que combinam múltiplos campos
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Considerar cache** - Para consultas frequentes de extratos antigos

### Integridade de Dados

1. **Validação antes de importar** - Verificar se banco, empresa e conta existem
2. **Verificar duplicatas** - Antes de inserir novo extrato
3. **Manter consistência** - Garantir que EXTDETALHE e EXTCONCILIACAO referenciam extratos válidos
4. **Auditoria** - Registrar quem e quando importou cada extrato

### Manutenção

1. **Arquivamento** - Considerar arquivar extratos antigos após período de retenção
2. **Limpeza periódica** - Remover extratos órfãos sem transações
3. **Backup regular** - Tabela pequena mas crítica para conciliação bancária
4. **Monitoramento** - Acompanhar taxa de conciliação por banco/empresa

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

