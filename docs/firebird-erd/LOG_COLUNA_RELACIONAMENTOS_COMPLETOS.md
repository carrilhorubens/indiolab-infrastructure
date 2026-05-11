# LOG_COLUNA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOG_COLUNA (Log de Colunas)
- **Total de Registros**: 242
- **Total de Colunas**: 8
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOG_COLUNA** é uma tabela que armazena logs detalhados de alterações em colunas específicas de tabelas. Com **242 registros**, representa um histórico de mudanças em valores de colunas, permitindo auditoria completa de alterações de dados.

Esta tabela funciona como **log de alterações de colunas** e permite:
- Registrar todas as alterações em colunas específicas
- Armazenar valores antigos e novos de colunas
- Suportar valores BLOB (binários grandes)
- Vincular alterações a operações de log de tabela
- Facilitar auditoria completa de dados
- Manter histórico detalhado de alterações

Cada registro representa uma alteração específica em uma coluna, contendo:
- ID do log de coluna (ID)
- ID da operação de log (OPERATIONLOG_ID) - FK → LOG_TABELA
- Nome da coluna alterada (COLUMN_NAME)
- Valor antigo da coluna (OLD_VALUE)
- Valor novo da coluna (NEW_VALUE)
- Valor antigo BLOB (OLD_VALUE_BLOB)
- Valor novo BLOB (NEW_VALUE_BLOB)
- Data/hora da alteração (DATAHORA)

O sistema utiliza esta tabela para manter histórico completo de alterações em colunas, permitindo auditoria detalhada e rastreamento de mudanças.

**Observação Importante:** LOG_COLUNA é uma tabela de log de alterações de colunas. Com 242 registros, indica uso moderado desta funcionalidade de auditoria. Possui relacionamento direto com LOG_TABELA para vincular alterações de colunas a operações de log de tabela.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | BIGINT | ✓ | ID do log de coluna (PK) |

### Relacionamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **OPERATIONLOG_ID** 🔗 | BIGINT | ✓ | ID da operação de log (FK → LOG_TABELA) |

### Informações da Alteração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COLUMN_NAME** | VARCHAR(37) | | Nome da coluna alterada |
| **OLD_VALUE** | VARCHAR(37) | | Valor antigo da coluna |
| **NEW_VALUE** | VARCHAR(37) | | Valor novo da coluna |
| **OLD_VALUE_BLOB** | VARCHAR(261) | | Valor antigo BLOB |
| **NEW_VALUE_BLOB** | VARCHAR(261) | | Valor novo BLOB |
| **DATAHORA** | TIMESTAMP | ✓ | Data/hora da alteração |

**Primary Key:** ID

**Foreign Keys:**
- `OPERATIONLOG_ID` → `LOG_TABELA.ID` (Constraint: FK_LOG_COLUNA_TABELA)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOG_COLUNA Referencia (1 FK):

#### 1. LOG_TABELA - Log de Tabelas
**Relacionamento:**
```
LOG_COLUNA.OPERATIONLOG_ID → LOG_TABELA.ID (N:1)
Constraint: FK_LOG_COLUNA_TABELA
```

**Descrição**: Cada alteração de coluna está vinculada a uma operação de log de tabela específica.

**Informações da Tabela LOG_TABELA:**
- **Total:** 22 operações de log
- **PK:** ID
- **Colunas:** 21 campos

**Uso:** Identificar a operação de log de tabela à qual a alteração de coluna pertence.

---

### LOG_COLUNA é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOG_COLUNA diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via LOG_TABELA → Outras Operações de Log

**Fluxo:** LOG_COLUNA → LOG_TABELA → Operações

**Descrição:** Através da operação de log de tabela, é possível identificar outras operações relacionadas.

**Uso:** Análise de alterações de colunas através de operações de log.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Alterações de Coluna

**Objetivo:** Obter informações de uma alteração específica de coluna.

```sql
SELECT
    lc.ID,
    lc.OPERATIONLOG_ID,
    lt.TABLE_NAME,
    lt.OPERATION,
    lc.COLUMN_NAME,
    lc.OLD_VALUE,
    lc.NEW_VALUE,
    lc.DATAHORA
FROM LOG_COLUNA lc
INNER JOIN LOG_TABELA lt ON lt.ID = lc.OPERATIONLOG_ID
WHERE lc.ID = ?;
```

---

### 2. Listar Alterações de uma Operação de Log

**Objetivo:** Obter todas as alterações de colunas de uma operação de log específica.

```sql
SELECT
    COLUMN_NAME,
    OLD_VALUE,
    NEW_VALUE,
    DATAHORA
FROM LOG_COLUNA
WHERE OPERATIONLOG_ID = ?
ORDER BY COLUMN_NAME;
```

---

### 3. Análise de Alterações por Coluna

**Objetivo:** Identificar distribuição de alterações por nome de coluna.

**Query SQL:**
```sql
SELECT
    COLUMN_NAME,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT OPERATIONLOG_ID) AS TOTAL_OPERACOES
FROM LOG_COLUNA
WHERE COLUMN_NAME IS NOT NULL
GROUP BY COLUMN_NAME
ORDER BY TOTAL_ALTERACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOG_COLUNA | Tipo |
|--------|-----------|----------------------|------|
| **LOG_COLUNA** | 242 | 1:1 | **TABELA PRINCIPAL** |
| LOG_TABELA | 22 | 1:11 | Operações de log (média de 11 alterações por operação) |

**Interpretação:**
- **242 alterações de colunas** registradas no sistema
- **Média de 11 alterações por operação** - indica que cada operação de log gera múltiplas alterações de colunas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por operação de log (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOG_COLUNA_OPERACAO ON LOG_COLUNA(OPERATIONLOG_ID);

-- Índice 2: Busca por nome de coluna (consultas frequentes)
CREATE INDEX IDX_LOG_COLUNA_COLUNA ON LOG_COLUNA(COLUMN_NAME)
    WHERE COLUMN_NAME IS NOT NULL;

-- Índice 3: Busca por data/hora (consultas frequentes)
CREATE INDEX IDX_LOG_COLUNA_DATAHORA ON LOG_COLUNA(DATAHORA)
    WHERE DATAHORA IS NOT NULL;
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

final class FirebirdLogColuna extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOG_COLUNA';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'OPERATIONLOG_ID' => 'integer',
        'COLUMN_NAME' => 'string',
        'OLD_VALUE' => 'string',
        'NEW_VALUE' => 'string',
        'OLD_VALUE_BLOB' => 'string',
        'NEW_VALUE_BLOB' => 'string',
        'DATAHORA' => 'datetime',
    ];

    // Relacionamento com LOG_TABELA
    public function operacaoLog(): BelongsTo
    {
        return $this->belongsTo(FirebirdLogTabela::class, 'OPERATIONLOG_ID', 'ID');
    }

    public function scopePorOperacao($query, int $operationLogId)
    {
        return $query->where('OPERATIONLOG_ID', $operationLogId);
    }

    public function scopePorColuna($query, string $columnName)
    {
        return $query->where('COLUMN_NAME', $columnName);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATAHORA', [$dataInicial, $dataFinal]);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

