# LCICMS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LCICMS (Lançamento Contábil ICMS)
- **Total de Registros**: 5
- **Total de Colunas**: 11
- **Chave Primária**: Composta (LCICODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 8 (BLOCOC855, BLOCOE113, BLOCOE240, PROAJUSTE, e outras)
- **Banco de Dados**: Firebird

## 📝 Descrição

**LCICMS** é uma tabela que armazena lançamentos contábeis relacionados a ICMS (Imposto sobre Circulação de Mercadorias e Serviços). Com apenas **5 registros**, representa lançamentos contábeis específicos de ICMS que são utilizados em processos fiscais e contábeis.

Esta tabela funciona como **lançamento contábil de ICMS** e permite:
- Registrar lançamentos contábeis de ICMS
- Controlar valores de ICMS por tipo e unidade federativa
- Identificar origem e finalidade dos lançamentos
- Vincular lançamentos a tipos de ICMS e estados
- Facilitar gestão fiscal de ICMS
- Suportar controle contábil de ICMS

Cada registro representa um lançamento contábil específico de ICMS, contendo:
- Código do lançamento (LCICODIGO) - parte da PK
- Código da empresa (EMPCODIGO) - parte da PK
- Data do lançamento (LCIDATA)
- Código do tipo de ICMS (TPCCODIGO) - FK → TPICMS
- Descrição do lançamento (LCIDESCRICAO)
- Valor do lançamento (LCIVALOR)
- Finalidade do lançamento (LCIFINALIDADE)
- Origem do lançamento (LCIORIGEM)
- Código da unidade federativa (UFCODIGO) - FK → UF
- Código de ajuste (LCCODAJ)
- Inscrição estadual (LCINSCEST)

O sistema utiliza esta tabela para manter lançamentos contábeis de ICMS, sendo referenciada por múltiplas tabelas de blocos fiscais (BLOCOC855, BLOCOE113, BLOCOE240) e outras operações (PROAJUSTE).

**Observação Importante:** LCICMS é uma tabela de lançamento contábil de ICMS. Com apenas 5 registros, indica uso muito limitado desta funcionalidade no momento. Possui chave primária composta e relacionamentos com TPICMS e UF, sendo referenciada por 8 tabelas diferentes.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LCICODIGO** 🔑 | INTEGER | ✓ | Código do lançamento contábil ICMS (PK) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPCCODIGO** 🔗 | INTEGER | ✓ | Código do tipo de ICMS (FK → TPICMS) |
| **UFCODIGO** 🔗 | VARCHAR(37) | ✓ | Código da unidade federativa (FK → UF) |

### Informações do Lançamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LCIDATA** | DATE | ✓ | Data do lançamento |
| **LCIDESCRICAO** | VARCHAR(261) | | Descrição do lançamento |
| **LCIVALOR** | NUMERIC(16,2) | ✓ | Valor do lançamento |
| **LCIFINALIDADE** | VARCHAR(14) | | Finalidade do lançamento |
| **LCIORIGEM** | VARCHAR(14) | ✓ | Origem do lançamento |
| **LCCODAJ** | VARCHAR(14) | | Código de ajuste |
| **LCINSCEST** | VARCHAR(37) | | Inscrição estadual |

**Primary Key:** (LCICODIGO, EMPCODIGO)

**Foreign Keys:**
- `TPCCODIGO` → `TPICMS.TPCCODIGO` (Constraint: TPICMS_LCICMS)
- `UFCODIGO` → `UF.UFCODIGO` (Constraint: UF_LCICMS)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LCICMS Referencia (2 FKs):

#### 1. TPICMS - Tipos de ICMS
**Relacionamento:**
```
LCICMS.TPCCODIGO → TPICMS.TPCCODIGO (N:1)
Constraint: TPICMS_LCICMS
```

**Descrição**: Cada lançamento está vinculado a um tipo de ICMS específico.

**Informações da Tabela TPICMS:**
- **Total:** 11 tipos de ICMS
- **PK:** TPCCODIGO
- **Colunas:** 6 campos

**Uso:** Identificar o tipo de ICMS do lançamento.

---

#### 2. UF - Unidades Federativas
**Relacionamento:**
```
LCICMS.UFCODIGO → UF.UFCODIGO (N:1)
Constraint: UF_LCICMS
```

**Descrição**: Cada lançamento está vinculado a uma unidade federativa específica.

**Informações da Tabela UF:**
- **Total:** 27 unidades federativas
- **PK:** UFCODIGO
- **Colunas:** Informação não disponível

**Uso:** Identificar a unidade federativa do lançamento.

---

### LCICMS é Referenciada Por (8 tabelas):

#### 1. BLOCOC855 - Bloco C855
**Relacionamento:**
```
BLOCOC855.(LCICODIGO, EMPCODIGO) → LCICMS.(LCICODIGO, EMPCODIGO) (N:1)
Constraint: LCICMS_BLOCOC855
```

**Uso:** Vincular blocos fiscais C855 a lançamentos contábeis de ICMS.

---

#### 2. BLOCOE113 - Bloco E113
**Relacionamento:**
```
BLOCOE113.(LCICODIGO, EMPCODIGO) → LCICMS.(LCICODIGO, EMPCODIGO) (N:1)
Constraint: FK_BLOCOE113_1
```

**Uso:** Vincular blocos fiscais E113 a lançamentos contábeis de ICMS.

---

#### 3. BLOCOE240 - Bloco E240
**Relacionamento:**
```
BLOCOE240.(LCICODIGO, EMPCODIGO) → LCICMS.(LCICODIGO, EMPCODIGO) (N:1)
Constraint: FK_BLOCOE240_1
```

**Uso:** Vincular blocos fiscais E240 a lançamentos contábeis de ICMS.

---

#### 4. PROAJUSTE - Produtos Ajuste
**Relacionamento:**
```
PROAJUSTE.(LCICODIGO, EMPCODIGO) → LCICMS.(LCICODIGO, EMPCODIGO) (N:1)
Constraint: FK_PROAJUSTE_3
```

**Uso:** Vincular ajustes de produtos a lançamentos contábeis de ICMS.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Lançamento Contábil ICMS

**Objetivo:** Obter informações de um lançamento específico.

```sql
SELECT
    lc.LCICODIGO,
    lc.EMPCODIGO,
    lc.LCIDATA,
    lc.TPCCODIGO,
    tp.TPCDESCRICAO AS TIPO_ICMS,
    lc.UFCODIGO,
    uf.UFNOME AS ESTADO,
    lc.LCIDESCRICAO,
    lc.LCIVALOR,
    lc.LCIFINALIDADE,
    lc.LCIORIGEM
FROM LCICMS lc
INNER JOIN TPICMS tp ON tp.TPCCODIGO = lc.TPCCODIGO
INNER JOIN UF uf ON uf.UFCODIGO = lc.UFCODIGO
WHERE lc.LCICODIGO = ?
  AND lc.EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LCICMS | Tipo |
|--------|-----------|-------------------|------|
| **LCICMS** | 5 | 1:1 | **TABELA PRINCIPAL** |
| TPICMS | 11 | 1:0.45 | Tipos de ICMS |
| UF | 27 | 1:0.19 | Unidades federativas |

**Interpretação:**
- **5 lançamentos contábeis de ICMS** registrados no sistema
- Indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_LCICMS_EMPRESA ON LCICMS(EMPCODIGO);

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_LCICMS_DATA ON LCICMS(LCIDATA)
    WHERE LCIDATA IS NOT NULL;

-- Índice 3: Busca por tipo de ICMS (consultas frequentes)
CREATE INDEX IDX_LCICMS_TIPO ON LCICMS(TPCCODIGO);
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

final class FirebirdLcicms extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LCICMS';
    
    protected $primaryKey = ['LCICODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'LCICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'LCIDATA' => 'date',
        'TPCCODIGO' => 'integer',
        'LCIDESCRICAO' => 'string',
        'LCIVALOR' => 'decimal:2',
        'LCIFINALIDADE' => 'string',
        'LCIORIGEM' => 'string',
        'UFCODIGO' => 'string',
        'LCCODAJ' => 'string',
        'LCINSCEST' => 'string',
    ];

    // Relacionamento com TPICMS
    public function tipoIcms(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpicms::class, 'TPCCODIGO', 'TPCCODIGO');
    }

    // Relacionamento com UF
    public function unidadeFederativa(): BelongsTo
    {
        return $this->belongsTo(FirebirdUf::class, 'UFCODIGO', 'UFCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

