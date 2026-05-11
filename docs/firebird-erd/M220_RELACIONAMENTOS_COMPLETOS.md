# M220 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: M220 (Ajustes de Apuração de PIS/COFINS)
- **Total de Registros**: 178
- **Total de Colunas**: 12
- **Chave Primária**: MCODIGO, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 2 (LCPISCOFINS)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**M220** é uma tabela que armazena informações sobre ajustes de apuração de PIS/COFINS para o SPED Fiscal. Com **178 registros**, representa ajustes realizados em apurações de PIS/COFINS, incluindo informações sobre tipo de ajuste, valor, código e descrição.

Esta tabela funciona como **detalhamento de ajustes de apuração de PIS/COFINS** e permite:
- Registrar ajustes de apuração de PIS/COFINS
- Armazenar informações sobre tipo, valor e código de ajuste
- Vincular ajustes a lançamentos de PIS/COFINS
- Associar ajustes a notas fiscais eletrônicas
- Rastrear origem e datas de referência e operação
- Facilitar geração de SPED Fiscal
- Manter histórico detalhado de ajustes

Cada registro representa um ajuste específico de apuração de PIS/COFINS, contendo:
- Código do ajuste (MCODIGO)
- Código do lançamento de PIS/COFINS (LCCODIGO)
- Código da empresa (EMPCODIGO)
- Código da NFe (NFECODIGO)
- Indicador de ajuste (MIND_AJ)
- Valor do ajuste (MVL_AJ)
- Código do ajuste (MCOD_AJ)
- Número do documento (MNUM_DOC)
- Descrição do ajuste (MDESCR_AJ)
- Data de referência (MDT_REF)
- Data da operação (MDT_OPER)
- Origem do ajuste (MORIGEM)

O sistema utiliza esta tabela para manter histórico completo de ajustes de apuração de PIS/COFINS, sendo referenciada por LCPISCOFINS através de LCCODIGO e EMPCODIGO para vincular ajustes a lançamentos específicos.

**Observação Importante:** M220 é uma tabela de ajustes de apuração de PIS/COFINS para SPED Fiscal. Com 178 registros, indica uso moderado desta funcionalidade. Possui chave primária composta (MCODIGO, EMPCODIGO) e referencia LCPISCOFINS através de LCCODIGO e EMPCODIGO.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MCODIGO** 🔑 | INTEGER | ✓ | Código do ajuste (PK) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK, FK) |

### Relacionamento com LCPISCOFINS
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LCCODIGO** 🔗 | INTEGER | ✓ | Código do lançamento de PIS/COFINS (FK) |

### Informações do Ajuste
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFECODIGO** | INTEGER | | Código da nota fiscal eletrônica |
| **MIND_AJ** | VARCHAR(14) | ✓ | Indicador de ajuste |
| **MVL_AJ** | DECIMAL(16,2) | ✓ | Valor do ajuste |
| **MCOD_AJ** | VARCHAR(14) | ✓ | Código do ajuste |
| **MNUM_DOC** | VARCHAR(37) | | Número do documento |
| **MDESCR_AJ** | VARCHAR(261) | | Descrição do ajuste |
| **MDT_REF** | TIMESTAMP | | Data de referência |
| **MDT_OPER** | TIMESTAMP | | Data da operação |
| **MORIGEM** | VARCHAR(14) | ✓ | Origem do ajuste |

**Primary Key:** MCODIGO, EMPCODIGO (composta)

**Foreign Keys:**
- `FK_M220_1`: LCCODIGO, EMPCODIGO → LCPISCOFINS.LCCODIGO, LCPISCOFINS.EMPCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### M220 Referencia (1 tabela):

#### 1. LCPISCOFINS - Lançamentos de PIS/COFINS
**Relacionamento:**
```
M220.LCCODIGO, M220.EMPCODIGO → LCPISCOFINS.LCCODIGO, LCPISCOFINS.EMPCODIGO (N:1)
Constraint: FK_M220_1
```

**Descrição**: Cada ajuste está vinculado a um lançamento específico de PIS/COFINS.

**Informações da Tabela LCPISCOFINS:**
- **Total:** 356 lançamentos
- **PK:** LCCODIGO, EMPCODIGO (composta)
- **Colunas:** 3 campos

**Uso:** Vincular ajustes a lançamentos de PIS/COFINS para geração de SPED Fiscal.

---

### M220 é Referenciada Por (0 tabelas):

Nenhuma tabela referencia M220 diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via NFECODIGO → NFE

**Fluxo:** M220 → NFE → Operações

**Descrição:** Através do código da NFe, é possível identificar notas fiscais relacionadas.

**Uso:** Análise de ajustes através de notas fiscais.

---

### Via LCPISCOFINS → TPBLOCO

**Fluxo:** M220 → LCPISCOFINS → TPBLOCO → Operações

**Descrição:** Através do lançamento de PIS/COFINS, é possível identificar tipos de bloco relacionados.

**Uso:** Análise de ajustes através de tipos de bloco.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Ajuste de Apuração

**Objetivo:** Obter informações de um ajuste específico.

```sql
SELECT
    m.MCODIGO,
    m.EMPCODIGO,
    m.LCCODIGO,
    m.NFECODIGO,
    m.MIND_AJ,
    m.MVL_AJ,
    m.MCOD_AJ,
    m.MNUM_DOC,
    m.MDESCR_AJ,
    m.MDT_REF,
    m.MDT_OPER,
    m.MORIGEM
FROM M220 m
WHERE m.MCODIGO = ? AND m.EMPCODIGO = ?;
```

---

### 2. Listar Ajustes de um Lançamento

**Objetivo:** Obter todos os ajustes vinculados a um lançamento específico de PIS/COFINS.

```sql
SELECT
    m.MCODIGO,
    m.MIND_AJ,
    m.MVL_AJ,
    m.MCOD_AJ,
    m.MDESCR_AJ,
    m.MDT_REF,
    m.MDT_OPER,
    m.MORIGEM
FROM M220 m
WHERE m.LCCODIGO = ? AND m.EMPCODIGO = ?
ORDER BY m.MCODIGO;
```

---

### 3. Análise de Ajustes por Tipo

**Objetivo:** Identificar distribuição de ajustes por tipo de ajuste.

**Query SQL:**
```sql
SELECT
    MCOD_AJ,
    COUNT(*) AS TOTAL_AJUSTES,
    SUM(MVL_AJ) AS VALOR_TOTAL,
    AVG(MVL_AJ) AS VALOR_MEDIO
FROM M220
WHERE MCOD_AJ IS NOT NULL
GROUP BY MCOD_AJ
ORDER BY TOTAL_AJUSTES DESC;
```

---

### 4. Análise de Ajustes por Período

**Objetivo:** Identificar distribuição de ajustes ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM MDT_OPER) AS ANO,
    EXTRACT(MONTH FROM MDT_OPER) AS MES,
    COUNT(*) AS TOTAL_AJUSTES,
    SUM(MVL_AJ) AS VALOR_TOTAL
FROM M220
WHERE MDT_OPER IS NOT NULL
GROUP BY EXTRACT(YEAR FROM MDT_OPER), EXTRACT(MONTH FROM MDT_OPER)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com M220 | Tipo |
|--------|-----------|-------------------|------|
| **M220** | 178 | 1:1 | **TABELA PRINCIPAL** |
| LCPISCOFINS | 356 | 1:2 | Lançamentos (média de 2 ajustes por lançamento) |

**Interpretação:**
- **178 ajustes** de apuração de PIS/COFINS registrados no sistema
- **Média de 2 ajustes por lançamento** - indica que cada lançamento pode ter múltiplos ajustes

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por lançamento (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_M220_LANCAMENTO ON M220(LCCODIGO, EMPCODIGO);

-- Índice 2: Busca por NFe (consultas frequentes)
CREATE INDEX IDX_M220_NFE ON M220(NFECODIGO)
    WHERE NFECODIGO IS NOT NULL;

-- Índice 3: Busca por tipo de ajuste (consultas frequentes)
CREATE INDEX IDX_M220_TIPO_AJUSTE ON M220(MCOD_AJ)
    WHERE MCOD_AJ IS NOT NULL;

-- Índice 4: Busca por data de operação (consultas frequentes)
CREATE INDEX IDX_M220_DATA_OPER ON M220(MDT_OPER)
    WHERE MDT_OPER IS NOT NULL;
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

final class FirebirdM220 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'M220';
    
    protected $primaryKey = ['MCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'MCODIGO' => 'integer',
        'LCCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'NFECODIGO' => 'integer',
        'MIND_AJ' => 'string',
        'MVL_AJ' => 'decimal:2',
        'MCOD_AJ' => 'string',
        'MNUM_DOC' => 'string',
        'MDESCR_AJ' => 'string',
        'MDT_REF' => 'datetime',
        'MDT_OPER' => 'datetime',
        'MORIGEM' => 'string',
    ];

    // Relacionamento com LCPISCOFINS
    public function lancamentoPisCofins(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdLcpiscofins::class,
            ['LCCODIGO', 'EMPCODIGO'],
            ['LCCODIGO', 'EMPCODIGO']
        );
    }

    public function scopePorLancamento($query, int $lcCodigo, int $empCodigo)
    {
        return $query->where('LCCODIGO', $lcCodigo)
                     ->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorNFe($query, int $nfeCodigo)
    {
        return $query->where('NFECODIGO', $nfeCodigo);
    }

    public function scopePorTipoAjuste($query, string $codAjuste)
    {
        return $query->where('MCOD_AJ', $codAjuste);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('MDT_OPER', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MDT_OPER', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

