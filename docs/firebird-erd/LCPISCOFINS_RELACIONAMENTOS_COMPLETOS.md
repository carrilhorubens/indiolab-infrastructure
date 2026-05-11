# LCPISCOFINS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LCPISCOFINS (Lançamento Contábil PIS/COFINS)
- **Total de Registros**: 356
- **Total de Colunas**: 3
- **Chave Primária**: Composta (LCCODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 36 (BLOCO1050, BLOCO1100, BLOCO1200, BLOCO1300, F100, F120, F130, F150, F600, F700, F800, M110, M215, M220, M510, M615, M620, P210, e outras)
- **Banco de Dados**: Firebird

## 📝 Descrição

**LCPISCOFINS** é uma tabela que armazena lançamentos contábeis relacionados a PIS (Programa de Integração Social) e COFINS (Contribuição para o Financiamento da Seguridade Social). Com **356 registros**, representa lançamentos contábeis específicos de PIS/COFINS que são utilizados em processos fiscais e contábeis.

Esta tabela funciona como **lançamento contábil de PIS/COFINS** e permite:
- Registrar lançamentos contábeis de PIS/COFINS
- Controlar valores de PIS/COFINS por tipo de bloco
- Vincular lançamentos a tipos de bloco fiscal
- Facilitar gestão fiscal de PIS/COFINS
- Suportar controle contábil de PIS/COFINS
- Suportar múltiplos blocos fiscais

Cada registro representa um lançamento contábil específico de PIS/COFINS, contendo:
- Código do lançamento (LCCODIGO) - parte da PK
- Código da empresa (EMPCODIGO) - parte da PK
- Código do tipo de bloco (TPBCODIGO) - FK → TPBLOCO

O sistema utiliza esta tabela para manter lançamentos contábeis de PIS/COFINS, sendo referenciada por 36 tabelas diferentes de blocos fiscais (BLOCO1050, BLOCO1100, BLOCO1200, BLOCO1300, F100, F120, F130, F150, F600, F700, F800, M110, M215, M220, M510, M615, M620, P210, e outras).

**Observação Importante:** LCPISCOFINS é uma tabela de lançamento contábil de PIS/COFINS. Com 356 registros, indica uso moderado desta funcionalidade. Possui chave primária composta e relacionamento com TPBLOCO, sendo referenciada por 36 tabelas diferentes de blocos fiscais, o que indica sua importância central no sistema fiscal.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LCCODIGO** 🔑 | INTEGER | ✓ | Código do lançamento contábil PIS/COFINS (PK) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK) |

### Relacionamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPBCODIGO** 🔗 | INTEGER | ✓ | Código do tipo de bloco (FK → TPBLOCO) |

**Primary Key:** (LCCODIGO, EMPCODIGO)

**Foreign Keys:**
- `TPBCODIGO` → `TPBLOCO.TPBCODIGO` (Constraint: TPBLOCO_LCPISCOFINS)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LCPISCOFINS Referencia (1 FK):

#### 1. TPBLOCO - Tipos de Bloco
**Relacionamento:**
```
LCPISCOFINS.TPBCODIGO → TPBLOCO.TPBCODIGO (N:1)
Constraint: TPBLOCO_LCPISCOFINS
```

**Descrição**: Cada lançamento está vinculado a um tipo de bloco fiscal específico.

**Informações da Tabela TPBLOCO:**
- **Total:** 18 tipos de bloco
- **PK:** TPBCODIGO
- **Colunas:** 2 campos

**Uso:** Identificar o tipo de bloco fiscal do lançamento.

---

### LCPISCOFINS é Referenciada Por (36 tabelas):

#### Principais Tabelas de Blocos Fiscais:
- **BLOCO1050, BLOCO1100, BLOCO1200, BLOCO1300** - Blocos de escrituração fiscal
- **F100, F120, F130, F150, F600, F700, F800** - Tabelas F de escrituração fiscal
- **M110, M215, M220, M510, M615, M620** - Tabelas M de escrituração fiscal
- **P210** - Tabela P de escrituração fiscal
- E outras tabelas de blocos fiscais

**Relacionamento padrão:**
```
[TABELA_BLOCO].(LCCODIGO, EMPCODIGO) → LCPISCOFINS.(LCCODIGO, EMPCODIGO) (N:1)
```

**Uso:** Vincular blocos fiscais a lançamentos contábeis de PIS/COFINS.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Lançamento Contábil PIS/COFINS

**Objetivo:** Obter informações de um lançamento específico.

```sql
SELECT
    lc.LCCODIGO,
    lc.EMPCODIGO,
    lc.TPBCODIGO,
    tb.TPBDESCRICAO AS TIPO_BLOCO
FROM LCPISCOFINS lc
INNER JOIN TPBLOCO tb ON tb.TPBCODIGO = lc.TPBCODIGO
WHERE lc.LCCODIGO = ?
  AND lc.EMPCODIGO = ?;
```

---

### 2. Análise de Lançamentos por Tipo de Bloco

**Objetivo:** Identificar distribuição de lançamentos por tipo de bloco.

**Query SQL:**
```sql
SELECT
    tb.TPBDESCRICAO AS TIPO_BLOCO,
    COUNT(lc.LCCODIGO) AS TOTAL_LANCAMENTOS,
    COUNT(DISTINCT lc.EMPCODIGO) AS TOTAL_EMPRESAS
FROM LCPISCOFINS lc
INNER JOIN TPBLOCO tb ON tb.TPBCODIGO = lc.TPBCODIGO
GROUP BY tb.TPBDESCRICAO
ORDER BY TOTAL_LANCAMENTOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LCPISCOFINS | Tipo |
|--------|-----------|-------------------------|------|
| **LCPISCOFINS** | 356 | 1:1 | **TABELA PRINCIPAL** |
| TPBLOCO | 18 | 1:19.78 | Tipos de bloco (média de 19.78 lançamentos por tipo) |

**Interpretação:**
- **356 lançamentos contábeis de PIS/COFINS** registrados no sistema
- **Média de 19.78 lançamentos por tipo de bloco** - indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_LCPISCOFINS_EMPRESA ON LCPISCOFINS(EMPCODIGO);

-- Índice 2: Busca por tipo de bloco (consultas frequentes)
CREATE INDEX IDX_LCPISCOFINS_TIPO_BLOCO ON LCPISCOFINS(TPBCODIGO);
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

final class FirebirdLcpiscofins extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LCPISCOFINS';
    
    protected $primaryKey = ['LCCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'LCCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'TPBCODIGO' => 'integer',
    ];

    // Relacionamento com TPBLOCO
    public function tipoBloco(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpbloco::class, 'TPBCODIGO', 'TPBCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

