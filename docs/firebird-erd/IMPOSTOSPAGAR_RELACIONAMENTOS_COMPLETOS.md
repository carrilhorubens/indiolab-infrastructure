# IMPOSTOSPAGAR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPOSTOSPAGAR (Impostos a Pagar)
- **Total de Registros**: 2
- **Total de Colunas**: 7
- **Chave Primária**: IPGCODIGO (simples)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPOSTOSPAGAR** é uma tabela que armazena informações de impostos vinculados a contas a pagar. Com apenas **2 registros**, representa impostos específicos que são calculados e registrados mensalmente para contas a pagar.

Esta tabela funciona como **registro de impostos a pagar** e permite:
- Registrar impostos vinculados a contas a pagar
- Controlar valores de impostos por mês e ano
- Identificar tipo de imposto
- Vincular impostos a contas a pagar específicas
- Facilitar gestão fiscal de impostos
- Suportar controle mensal de impostos

Cada registro representa um imposto específico vinculado a uma conta a pagar, contendo:
- Código do imposto (IPGCODIGO)
- Ano do imposto (IPGANO)
- Mês do imposto (IPGMES)
- Valor do imposto (IPGVALOR)
- Tipo de imposto (IPGIMPOSTO)
- Código da conta a pagar (PAGCODIGO) - FK → PAGAR
- Código da empresa (EMPCODIGO) - FK → PAGAR

O sistema utiliza esta tabela para manter controle de impostos vinculados a contas a pagar, permitindo gestão fiscal detalhada.

**Observação Importante:** IMPOSTOSPAGAR é uma tabela de impostos a pagar. Com apenas 2 registros, indica uso muito limitado desta funcionalidade no momento. Possui relacionamento com PAGAR através de chave composta (PAGCODIGO, EMPCODIGO).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IPGCODIGO** 🔑 | INTEGER | ✓ | Código do imposto a pagar (PK) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PAGCODIGO** 🔗 | INTEGER | | Código da conta a pagar (FK → PAGAR) |
| **EMPCODIGO** 🔗 | SMALLINT | | Código da empresa (FK → PAGAR) |

### Informações do Imposto
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IPGANO** | INTEGER | ✓ | Ano do imposto |
| **IPGMES** | INTEGER | ✓ | Mês do imposto |
| **IPGVALOR** | NUMERIC(16,2) | | Valor do imposto |
| **IPGIMPOSTO** | INTEGER | | Tipo de imposto |

**Primary Key:** IPGCODIGO

**Foreign Keys:**
- `(PAGCODIGO, EMPCODIGO)` → `PAGAR.(PAGCODIGO, EMPCODIGO)` (Constraint: IMPOSTOSPAGAR_PAGAR)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPOSTOSPAGAR Referencia (2 FKs):

#### 1. PAGAR - Contas a Pagar
**Relacionamento:**
```
IMPOSTOSPAGAR.(PAGCODIGO, EMPCODIGO) → PAGAR.(PAGCODIGO, EMPCODIGO) (N:1)
Constraint: IMPOSTOSPAGAR_PAGAR
```

**Descrição**: Cada imposto está vinculado a uma conta a pagar específica de uma empresa.

**Informações da Tabela PAGAR:**
- **Total:** 259.801 contas a pagar
- **PK:** (PAGCODIGO, EMPCODIGO)
- **Colunas:** 52 campos

**Uso:** Identificar a conta a pagar à qual o imposto pertence.

---

### IMPOSTOSPAGAR é Referenciada Por (0 tabelas):

Nenhuma tabela referencia IMPOSTOSPAGAR diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PAGAR → Outras Operações de Contas a Pagar

**Fluxo:** IMPOSTOSPAGAR → PAGAR → Operações

**Descrição:** Através da conta a pagar, é possível identificar outras operações relacionadas.

**Uso:** Análise de impostos através de operações de contas a pagar.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Imposto a Pagar

**Objetivo:** Obter informações de um imposto específico.

```sql
SELECT
    IPGCODIGO,
    PAGCODIGO,
    EMPCODIGO,
    IPGANO,
    IPGMES,
    IPGVALOR,
    IPGIMPOSTO
FROM IMPOSTOSPAGAR
WHERE IPGCODIGO = ?;
```

---

### 2. Listar Impostos de uma Conta a Pagar

**Objetivo:** Obter todos os impostos de uma conta a pagar específica.

```sql
SELECT
    IPGCODIGO,
    IPGANO,
    IPGMES,
    IPGVALOR,
    IPGIMPOSTO
FROM IMPOSTOSPAGAR
WHERE PAGCODIGO = ?
  AND EMPCODIGO = ?
ORDER BY IPGANO DESC, IPGMES DESC;
```

---

### 3. Análise de Impostos por Período

**Objetivo:** Identificar distribuição de impostos por mês e ano.

**Query SQL:**
```sql
SELECT
    IPGANO,
    IPGMES,
    COUNT(*) AS TOTAL_IMPOSTOS,
    SUM(IPGVALOR) AS VALOR_TOTAL
FROM IMPOSTOSPAGAR
GROUP BY IPGANO, IPGMES
ORDER BY IPGANO DESC, IPGMES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPOSTOSPAGAR | Tipo |
|--------|-----------|---------------------------|------|
| **IMPOSTOSPAGAR** | 2 | 1:1 | **TABELA PRINCIPAL** |
| PAGAR | 259.801 | 1:129900.5 | Contas a pagar (média de 0.000008 impostos por conta) |

**Interpretação:**
- **2 impostos** registrados no sistema
- **Uso muito limitado** desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por conta a pagar (consultas frequentes)
CREATE INDEX IDX_IMPOSTOSPAGAR_PAGAR ON IMPOSTOSPAGAR(PAGCODIGO, EMPCODIGO);

-- Índice 2: Busca por período (consultas frequentes)
CREATE INDEX IDX_IMPOSTOSPAGAR_PERIODO ON IMPOSTOSPAGAR(IPGANO, IPGMES);
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

final class FirebirdImpostospagar extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPOSTOSPAGAR';
    
    protected $primaryKey = 'IPGCODIGO';
    public $incrementing = true;

    protected $casts = [
        'IPGCODIGO' => 'integer',
        'PAGCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'IPGANO' => 'integer',
        'IPGMES' => 'integer',
        'IPGVALOR' => 'decimal:2',
        'IPGIMPOSTO' => 'integer',
    ];

    // Relacionamento com PAGAR
    public function contaPagar(): BelongsTo
    {
        return $this->belongsTo(FirebirdPagar::class, ['PAGCODIGO', 'EMPCODIGO'], ['PAGCODIGO', 'EMPCODIGO']);
    }

    public function scopePorContaPagar($query, int $pagCodigo, int $empCodigo)
    {
        return $query->where('PAGCODIGO', $pagCodigo)
                     ->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorPeriodo($query, int $ano, int $mes = null)
    {
        $query->where('IPGANO', $ano);
        if ($mes !== null) {
            $query->where('IPGMES', $mes);
        }
        return $query;
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

