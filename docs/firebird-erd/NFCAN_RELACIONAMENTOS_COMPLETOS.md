# NFCAN - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: NFCAN (Notas Fiscais Canceladas)
- **Total de Registros**: 5.057
- **Total de Colunas**: 5
- **Chave Primária**: NFCODIGO, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 3 (NOTAS - duas vezes, TPCANCELAMENTO)
- **Índices**: 0
- **Tabelas Dependentes**: 1 (NSCCTB)
- **Banco de Dados**: Firebird

## 📝 Descrição

**NFCAN** é uma tabela que armazena informações sobre cancelamentos de notas fiscais. Com **5.057 registros**, representa cancelamentos de notas fiscais realizados no sistema, incluindo informações sobre data, histórico e tipo de cancelamento.

Esta tabela funciona como **log de cancelamentos de notas fiscais** e permite:
- Registrar todos os cancelamentos de notas fiscais
- Armazenar informações sobre data e histórico do cancelamento
- Vincular cancelamentos a notas fiscais específicas
- Associar cancelamentos a tipos de cancelamento
- Facilitar gestão de cancelamentos
- Manter histórico detalhado de cancelamentos

Cada registro representa um cancelamento específico de nota fiscal, contendo:
- Código da nota fiscal (NFCODIGO)
- Código da empresa (EMPCODIGO)
- Data do cancelamento (NFCDATA)
- Histórico do cancelamento (NFCHISTORICO)
- Código do tipo de cancelamento (TPNCODIGO)

O sistema utiliza esta tabela para manter histórico completo de cancelamentos de notas fiscais, sendo referenciada por NOTAS através de NFCODIGO e EMPCODIGO, por TPCANCELAMENTO através de TPNCODIGO e por NSCCTB através de NFCODIGO e EMPCODIGO.

**Observação Importante:** NFCAN é uma tabela de cancelamentos de notas fiscais. Com 5.057 registros, indica uso moderado desta funcionalidade. Possui chave primária composta (NFCODIGO, EMPCODIGO) e referencia NOTAS (duas vezes) e TPCANCELAMENTO, indicando sua função de rastreamento de cancelamentos.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código da nota fiscal (PK, FK) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK, FK) |

### Relacionamento com TPCANCELAMENTO
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPNCODIGO** 🔗 | INTEGER | | Código do tipo de cancelamento (FK) |

### Informações do Cancelamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFCDATA** | TIMESTAMP | ✓ | Data do cancelamento |
| **NFCHISTORICO** | VARCHAR(37) | ✓ | Histórico do cancelamento |

**Primary Key:** NFCODIGO, EMPCODIGO (composta)

**Foreign Keys:**
- `NOTAS_NFCAN`: NFCODIGO, EMPCODIGO → NOTAS.NFCODIGO, NOTAS.EMPCODIGO
- `TPCANCELAMENTO_NFCAN`: TPNCODIGO → TPCANCELAMENTO.TPNCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### NFCAN Referencia (2 tabelas):

#### 1. NOTAS - Notas Fiscais
**Relacionamento:**
```
NFCAN.NFCODIGO, NFCAN.EMPCODIGO → NOTAS.NFCODIGO, NOTAS.EMPCODIGO (1:1)
Constraint: NOTAS_NFCAN
```

**Descrição**: Cada cancelamento está vinculado a uma nota fiscal específica.

**Informações da Tabela NOTAS:**
- **Total:** 1.206.013 notas fiscais
- **PK:** NFCODIGO, EMPCODIGO (composta)
- **Colunas:** 172 campos

**Uso:** Vincular cancelamentos a notas fiscais para rastreamento.

---

#### 2. TPCANCELAMENTO - Tipos de Cancelamento
**Relacionamento:**
```
NFCAN.TPNCODIGO → TPCANCELAMENTO.TPNCODIGO (N:1)
Constraint: TPCANCELAMENTO_NFCAN
```

**Descrição**: Cada cancelamento pode estar vinculado a um tipo específico de cancelamento.

**Informações da Tabela TPCANCELAMENTO:**
- **Total:** 10 tipos
- **PK:** TPNCODIGO
- **Colunas:** 2 campos

**Uso:** Classificar cancelamentos por tipo.

---

### NFCAN é Referenciada Por (1 tabela):

#### 1. NSCCTB - Notas Fiscais x Contabilidade
**Relacionamento:**
```
NSCCTB.NFCODIGO, NSCCTB.EMPCODIGO → NFCAN.NFCODIGO, NFCAN.EMPCODIGO (N:1)
Constraint: NFCAN_NSCCTB
```

**Descrição**: Cada associação de nota fiscal com contabilidade pode estar vinculada a um cancelamento específico.

**Informações da Tabela NSCCTB:**
- **Total:** 0 associações
- **PK:** EMPCODIGO, NFCODIGO, EMPCTB, LACCODIGO (composta)
- **Colunas:** 5 campos

**Uso:** Vincular cancelamentos a associações contábeis.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via NOTAS → Outras Operações

**Fluxo:** NFCAN → NOTAS → Operações

**Descrição:** Através das notas fiscais vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de cancelamentos através de operações de notas fiscais.

---

### Via TPCANCELAMENTO → Outras Operações

**Fluxo:** NFCAN → TPCANCELAMENTO → Operações

**Descrição:** Através dos tipos de cancelamento vinculados, é possível identificar outros cancelamentos relacionados.

**Uso:** Análise de cancelamentos através de tipos.

---

### Via NSCCTB → LACTOCTB

**Fluxo:** NFCAN → NSCCTB → LACTOCTB → Operações

**Descrição:** Através das associações contábeis, é possível identificar lançamentos relacionados.

**Uso:** Análise de cancelamentos através de lançamentos contábeis.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Cancelamento de Nota Fiscal

**Objetivo:** Obter informações de um cancelamento específico.

```sql
SELECT
    n.NFCODIGO,
    n.EMPCODIGO,
    n.NFCDATA,
    n.NFCHISTORICO,
    n.TPNCODIGO,
    t.TPNDESCRICAO AS TIPO_CANCELAMENTO
FROM NFCAN n
LEFT JOIN TPCANCELAMENTO t ON t.TPNCODIGO = n.TPNCODIGO
WHERE n.NFCODIGO = ? AND n.EMPCODIGO = ?;
```

---

### 2. Listar Cancelamentos por Tipo

**Objetivo:** Obter todos os cancelamentos de um tipo específico.

```sql
SELECT
    n.NFCODIGO,
    n.EMPCODIGO,
    n.NFCDATA,
    n.NFCHISTORICO
FROM NFCAN n
WHERE n.TPNCODIGO = ?
ORDER BY n.NFCDATA DESC;
```

---

### 3. Análise de Cancelamentos por Tipo

**Objetivo:** Identificar distribuição de cancelamentos por tipo.

**Query SQL:**
```sql
SELECT
    t.TPNDESCRICAO AS TIPO_CANCELAMENTO,
    COUNT(n.NFCODIGO) AS TOTAL_CANCELAMENTOS
FROM TPCANCELAMENTO t
LEFT JOIN NFCAN n ON n.TPNCODIGO = t.TPNCODIGO
GROUP BY t.TPNDESCRICAO
ORDER BY TOTAL_CANCELAMENTOS DESC;
```

---

### 4. Análise de Cancelamentos por Período

**Objetivo:** Identificar distribuição de cancelamentos ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM NFCDATA) AS ANO,
    EXTRACT(MONTH FROM NFCDATA) AS MES,
    COUNT(*) AS TOTAL_CANCELAMENTOS
FROM NFCAN
WHERE NFCDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM NFCDATA), EXTRACT(MONTH FROM NFCDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com NFCAN | Tipo |
|--------|-----------|-------------------|------|
| **NFCAN** | 5.057 | 1:1 | **TABELA PRINCIPAL** |
| NOTAS | 1.206.013 | 1:238.5 | Notas fiscais (média de 0.42% de cancelamentos) |
| TPCANCELAMENTO | 10 | 1:505.7 | Tipos (média de 505.7 cancelamentos por tipo) |
| NSCCTB | 0 | 0:1 | Associações contábeis (nenhuma associação registrada) |

**Interpretação:**
- **5.057 cancelamentos** registrados no sistema
- **0.42% de taxa de cancelamento** - indica baixa taxa de cancelamento de notas fiscais
- **Média de 505.7 cancelamentos por tipo** - indica distribuição equilibrada entre tipos

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_NFCAN_DATA ON NFCAN(NFCDATA)
    WHERE NFCDATA IS NOT NULL;

-- Índice 2: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_NFCAN_TIPO ON NFCAN(TPNCODIGO)
    WHERE TPNCODIGO IS NOT NULL;
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

final class FirebirdNfcan extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'NFCAN';
    
    protected $primaryKey = ['NFCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'NFCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'NFCDATA' => 'datetime',
        'NFCHISTORICO' => 'string',
        'TPNCODIGO' => 'integer',
    ];

    // Relacionamento com NOTAS
    public function notaFiscal(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdNotas::class,
            ['NFCODIGO', 'EMPCODIGO'],
            ['NFCODIGO', 'EMPCODIGO']
        );
    }

    // Relacionamento com TPCANCELAMENTO
    public function tipoCancelamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpcancelamento::class, 'TPNCODIGO', 'TPNCODIGO');
    }

    // Relacionamento com NSCCTB
    public function associacoesContabeis(): HasMany
    {
        return $this->hasMany(
            FirebirdNscctb::class,
            ['NFCODIGO', 'EMPCODIGO'],
            ['NFCODIGO', 'EMPCODIGO']
        );
    }

    public function scopePorTipo($query, int $tpnCodigo)
    {
        return $query->where('TPNCODIGO', $tpnCodigo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('NFCDATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('NFCDATA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

