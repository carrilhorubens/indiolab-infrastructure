# EXTRCONC - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: EXTRCONC (Extrato Conciliação)
- **Total de Registros**: 1.782
- **Total de Colunas**: 8
- **Chave Primária**: CODIGOEXTCONC (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 2 (EXTRCONC_IDX1, EXTRCONC_IDX2)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**EXTRCONC** é uma tabela que armazena registros de conciliação entre extratos bancários e lançamentos contábeis (CCORR). Com **1.782 registros**, representa vinculações entre extratos bancários e lançamentos contábeis, permitindo controle e rastreamento de conciliações bancárias.

Esta tabela funciona como **relacionamento de conciliação entre extratos e lançamentos contábeis** e permite:
- Vincular extratos bancários a lançamentos contábeis
- Rastrear conciliações realizadas
- Controlar tipos e valores de conciliações
- Suportar processo de conciliação bancária
- Facilitar identificação de extratos e lançamentos conciliados
- Manter histórico de conciliações

Cada registro representa uma conciliação específica entre um extrato bancário e um lançamento contábil, contendo:
- Identificador único da conciliação (CODIGOEXTCONC)
- Código do extrato relacionado (CODIGOEXTRATO) - lógica → BCOEXTRATO
- Código do lançamento contábil relacionado (CODIGOCCO) - lógica → CCORR
- Tipo da conciliação (TIPO)
- Valor da conciliação (VLR)
- Código do banco (CODBANCO) - lógica → BANCO
- Número da conta (CTANRCONTA) - lógica → CONTA
- Código da empresa (EMPCODIGO) - lógica → EMPRESA

O sistema utiliza esta tabela para realizar e controlar a conciliação bancária, vinculando extratos bancários com lançamentos contábeis existentes.

**Observação Importante:** EXTRCONC é uma tabela de relacionamento que conecta extratos bancários com lançamentos contábeis. Com 1.782 registros e índices em CODIGOEXTRATO/CODIGOCCO, indica uso extensivo desta funcionalidade. Não possui foreign keys diretas, mas possui relacionamentos lógicos com BCOEXTRATO e CCORR através de CODIGOEXTRATO e CODIGOCCO.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGOEXTCONC** 🔑 | INTEGER | ✓ | Identificador único da conciliação (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGOEXTRATO** | INTEGER | ✓ | Código do extrato relacionado (lógica → BCOEXTRATO) |
| **CODIGOCCO** | INTEGER | ✓ | Código do lançamento contábil relacionado (lógica → CCORR) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TIPO** | VARCHAR(14) | | Tipo da conciliação |
| **VLR** | NUMERIC(27,2) | | Valor da conciliação |
| **CODBANCO** | INTEGER | | Código do banco (lógica → BANCO) |
| **CTANRCONTA** | VARCHAR(37) | | Número da conta (lógica → CONTA) |
| **EMPCODIGO** | INTEGER | | Código da empresa (lógica → EMPRESA) |

**Primary Key:** CODIGOEXTCONC

**Índices:**
- `EXTRCONC_IDX1` em `(CODIGOEXTRATO, CODIGOCCO)`
- `EXTRCONC_IDX2` em `(CODIGOCCO, CODIGOEXTRATO)`

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### EXTRCONC Referencia (0 FKs):

Nenhuma foreign key direta.

---

### EXTRCONC é Referenciada Por (0 tabelas):

Nenhuma tabela referencia EXTRCONC diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via CODIGOEXTRATO → BCOEXTRATO → Outras Operações do Extrato

**Fluxo:** EXTRCONC → BCOEXTRATO → Operações

**Descrição:** Através do extrato, é possível identificar outras operações relacionadas.

**Uso:** Análise de conciliações por extrato.

---

### Via CODIGOCCO → CCORR → Outras Operações Contábeis

**Fluxo:** EXTRCONC → CCORR → Operações Contábeis

**Descrição:** Através do lançamento contábil, é possível identificar outras operações relacionadas.

**Uso:** Análise de conciliações por lançamento contábil.

---

### Via CODBANCO → BANCO → Outras Operações do Banco

**Fluxo:** EXTRCONC → BANCO → Operações

**Descrição:** Através do banco, é possível identificar outras operações relacionadas.

**Uso:** Análise de conciliações por banco.

---

### Via CTANRCONTA → CONTA → Outras Operações da Conta

**Fluxo:** EXTRCONC → CONTA → Operações

**Descrição:** Através da conta, é possível identificar outras operações relacionadas.

**Uso:** Análise de conciliações por conta.

---

### Via EMPCODIGO → EMPRESA → Outras Operações da Empresa

**Fluxo:** EXTRCONC → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de conciliações por empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Conciliação

**Objetivo:** Obter visão completa de uma conciliação incluindo informações do extrato e do lançamento contábil.

**Fluxo:**
```
EXTRCONC (CODIGOEXTRATO, CODIGOCCO, CODBANCO, CTANRCONTA, EMPCODIGO)
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
    exc.CODIGOEXTCONC,
    exc.CODIGOEXTRATO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    exc.CODIGOCCO,
    exc.TIPO AS TIPO_CONCILIACAO,
    exc.VLR AS VALOR_CONCILIACAO,
    exc.CODBANCO,
    bco.BCONOME AS BANCO,
    exc.CTANRCONTA,
    exc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    cco.CCOHISTORICO AS HISTORICO_LANCAMENTO
FROM EXTRCONC exc
LEFT JOIN BCOEXTRATO ext ON ext.ID = exc.CODIGOEXTRATO
LEFT JOIN BANCO bco ON bco.BCOCODIGO = exc.CODBANCO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = exc.EMPCODIGO
LEFT JOIN CCORR cco ON cco.CCONRLANCTO = exc.CODIGOCCO
                   AND cco.BCOCODIGO = exc.CODBANCO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.EMPCCORR = exc.EMPCODIGO
WHERE exc.CODIGOEXTCONC = ?;
```

---

### Exemplo 2: Análise de Conciliações por Extrato

**Objetivo:** Identificar todas as conciliações relacionadas a um extrato específico.

**Query SQL:**
```sql
SELECT
    exc.CODIGOEXTCONC,
    exc.CODIGOCCO,
    exc.TIPO AS TIPO_CONCILIACAO,
    exc.VLR AS VALOR_CONCILIACAO,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    COUNT(*) OVER (PARTITION BY exc.CODIGOEXTRATO) AS TOTAL_CONCILIACOES_EXTRATO
FROM EXTRCONC exc
LEFT JOIN CCORR cco ON cco.CCONRLANCTO = exc.CODIGOCCO
                   AND cco.BCOCODIGO = exc.CODBANCO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.EMPCCORR = exc.EMPCODIGO
WHERE exc.CODIGOEXTRATO = ?
ORDER BY exc.CODIGOEXTCONC;
```

---

### Exemplo 3: Análise de Conciliações por Lançamento Contábil

**Objetivo:** Identificar todas as conciliações relacionadas a um lançamento contábil específico.

**Query SQL:**
```sql
SELECT
    exc.CODIGOEXTCONC,
    exc.CODIGOEXTRATO,
    ext.BCEARQUIVO AS ARQUIVO_EXTRATO,
    ext.BCEDATA AS DATA_EXTRATO,
    exc.TIPO AS TIPO_CONCILIACAO,
    exc.VLR AS VALOR_CONCILIACAO,
    cco.CCODATA AS DATA_LANCAMENTO,
    cco.CCOVALOR AS VALOR_LANCAMENTO,
    COUNT(*) OVER (PARTITION BY exc.CODIGOCCO) AS TOTAL_CONCILIACOES_LANCAMENTO
FROM EXTRCONC exc
LEFT JOIN BCOEXTRATO ext ON ext.ID = exc.CODIGOEXTRATO
LEFT JOIN CCORR cco ON cco.CCONRLANCTO = exc.CODIGOCCO
                   AND cco.BCOCODIGO = exc.CODBANCO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.EMPCCORR = exc.EMPCODIGO
WHERE exc.CODIGOCCO = ?
ORDER BY exc.CODIGOEXTCONC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Conciliação

**Objetivo:** Obter informações de uma conciliação específica.

```sql
SELECT
    CODIGOEXTCONC,
    CODIGOEXTRATO,
    CODIGOCCO,
    TIPO AS TIPO_CONCILIACAO,
    VLR AS VALOR_CONCILIACAO,
    CODBANCO,
    CTANRCONTA,
    EMPCODIGO
FROM EXTRCONC
WHERE CODIGOEXTCONC = ?;
```

---

### 2. Listar Conciliações de um Extrato

**Objetivo:** Obter todas as conciliações relacionadas a um extrato específico.

```sql
SELECT
    CODIGOEXTCONC,
    CODIGOCCO,
    TIPO AS TIPO_CONCILIACAO,
    VLR AS VALOR_CONCILIACAO
FROM EXTRCONC
WHERE CODIGOEXTRATO = ?
ORDER BY CODIGOEXTCONC;
```

---

### 3. Análise de Conciliações por Tipo

**Objetivo:** Identificar distribuição de conciliações por tipo.

**Query SQL:**
```sql
SELECT
    TIPO AS TIPO_CONCILIACAO,
    COUNT(*) AS TOTAL_CONCILIACOES,
    SUM(VLR) AS VALOR_TOTAL,
    AVG(VLR) AS VALOR_MEDIO
FROM EXTRCONC
WHERE TIPO IS NOT NULL
GROUP BY TIPO
ORDER BY TOTAL_CONCILIACOES DESC;
```

---

### 4. Análise de Conciliações por Banco

**Objetivo:** Identificar distribuição de conciliações por banco.

**Query SQL:**
```sql
SELECT
    exc.CODBANCO,
    bco.BCONOME AS BANCO,
    COUNT(*) AS TOTAL_CONCILIACOES,
    SUM(exc.VLR) AS VALOR_TOTAL,
    AVG(exc.VLR) AS VALOR_MEDIO
FROM EXTRCONC exc
LEFT JOIN BANCO bco ON bco.BCOCODIGO = exc.CODBANCO
WHERE exc.CODBANCO IS NOT NULL
GROUP BY exc.CODBANCO, bco.BCONOME
ORDER BY TOTAL_CONCILIACOES DESC;
```

---

### 5. Análise de Conciliações por Empresa

**Objetivo:** Identificar distribuição de conciliações por empresa.

**Query SQL:**
```sql
SELECT
    exc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(*) AS TOTAL_CONCILIACOES,
    SUM(exc.VLR) AS VALOR_TOTAL,
    AVG(exc.VLR) AS VALOR_MEDIO
FROM EXTRCONC exc
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = exc.EMPCODIGO
WHERE exc.EMPCODIGO IS NOT NULL
GROUP BY exc.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_CONCILIACOES DESC;
```

---

### 6. Análise de Conciliações Órfãs

**Objetivo:** Identificar conciliações sem extrato ou lançamento válidos.

**Query SQL:**
```sql
SELECT
    exc.CODIGOEXTCONC,
    exc.CODIGOEXTRATO,
    exc.CODIGOCCO,
    CASE
        WHEN ext.ID IS NULL THEN 'SEM_EXTRATO'
        WHEN cco.CCONRLANCTO IS NULL THEN 'SEM_LANCAMENTO'
        ELSE 'OK'
    END AS STATUS
FROM EXTRCONC exc
LEFT JOIN BCOEXTRATO ext ON ext.ID = exc.CODIGOEXTRATO
LEFT JOIN CCORR cco ON cco.CCONRLANCTO = exc.CODIGOCCO
                   AND cco.BCOCODIGO = exc.CODBANCO
                   AND cco.CTANRCONTA = exc.CTANRCONTA
                   AND cco.EMPCCORR = exc.EMPCODIGO
WHERE ext.ID IS NULL OR cco.CCONRLANCTO IS NULL
ORDER BY exc.CODIGOEXTCONC;
```

---

### 7. Relatório Completo de Conciliações

**Objetivo:** Analisar distribuição completa de conciliações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CONCILIACOES,
    COUNT(DISTINCT CODIGOEXTRATO) AS TOTAL_EXTRATOS_CONCILIADOS,
    COUNT(DISTINCT CODIGOCCO) AS TOTAL_LANCAMENTOS_CONCILIADOS,
    COUNT(DISTINCT CODBANCO) AS TOTAL_BANCOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    SUM(VLR) AS VALOR_TOTAL,
    AVG(VLR) AS VALOR_MEDIO,
    COUNT(CASE WHEN CODIGOEXTRATO IS NULL THEN 1 END) AS SEM_EXTRATO,
    COUNT(CASE WHEN CODIGOCCO IS NULL THEN 1 END) AS SEM_LANCAMENTO
FROM EXTRCONC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com EXTRCONC | Tipo |
|--------|-----------|----------------------|------|
| **EXTRCONC** | 1.782 | 1:1 | **TABELA PRINCIPAL** |
| BCOEXTRATO | 100 | 1:17.82 | Extratos (média de 17.82 conciliações por extrato) |
| CCORR | 208.120 | 1:0.0086 | Lançamentos (média de 0.0086 conciliações por lançamento) |

**Interpretação:**
- **1.782 conciliações** registradas no sistema
- **Média de 17.82 conciliações por extrato** - indica uso extensivo desta funcionalidade
- **Média de 0.0086 conciliações por lançamento** - indica que poucos lançamentos são conciliados com extratos

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **EXTRCONC_IDX1** em `(CODIGOEXTRATO, CODIGOCCO)` - Otimiza consultas por extrato e lançamento
2. **EXTRCONC_IDX2** em `(CODIGOCCO, CODIGOEXTRATO)` - Otimiza consultas por lançamento e extrato

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por banco (consultas frequentes)
CREATE INDEX IDX_EXTRCONC_BANCO ON EXTRCONC(CODBANCO)
    WHERE CODBANCO IS NOT NULL;

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_EXTRCONC_EMP ON EXTRCONC(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 3: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_EXTRCONC_TIPO ON EXTRCONC(TIPO)
    WHERE TIPO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdExtrconc extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'EXTRCONC';
    
    protected $primaryKey = 'CODIGOEXTCONC';
    public $incrementing = true;

    protected $casts = [
        'CODIGOEXTCONC' => 'integer',
        'CODIGOEXTRATO' => 'integer',
        'CODIGOCCO' => 'integer',
        'TIPO' => 'string',
        'VLR' => 'decimal:2',
        'CODBANCO' => 'integer',
        'CTANRCONTA' => 'string',
        'EMPCODIGO' => 'integer',
    ];

    // Relacionamento lógico com BCOEXTRATO
    public function extratoBancario()
    {
        return $this->belongsTo(FirebirdBcoextrato::class, 'CODIGOEXTRATO', 'ID');
    }

    // Relacionamento lógico com CCORR
    public function lancamentoContabil()
    {
        return $this->belongsTo(FirebirdCcorr::class, 'CODIGOCCO', 'CCONRLANCTO');
    }

    // Relacionamento lógico com BANCO
    public function banco()
    {
        return $this->belongsTo(FirebirdBanco::class, 'CODBANCO', 'BCOCODIGO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function scopePorExtrato($query, int $codigoExtrato)
    {
        return $query->where('CODIGOEXTRATO', $codigoExtrato);
    }

    public function scopePorLancamento($query, int $codigoCco)
    {
        return $query->where('CODIGOCCO', $codigoCco);
    }

    public function scopePorBanco($query, int $codigoBanco)
    {
        return $query->where('CODBANCO', $codigoBanco);
    }

    public function scopePorEmpresa($query, int $codigoEmpresa)
    {
        return $query->where('EMPCODIGO', $codigoEmpresa);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('TIPO', $tipo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

