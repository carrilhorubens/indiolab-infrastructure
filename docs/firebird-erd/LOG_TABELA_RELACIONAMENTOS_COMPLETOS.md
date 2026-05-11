# LOG_TABELA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOG_TABELA (Log de Operações em Tabelas)
- **Total de Registros**: 22
- **Total de Colunas**: 21
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 2
- **Tabelas Dependentes**: 1 (LOG_COLUNA)
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOG_TABELA** é uma tabela que armazena logs de operações realizadas em tabelas do sistema. Com **22 registros**, representa um histórico de operações (INSERT, UPDATE, DELETE) realizadas em tabelas, incluindo informações detalhadas sobre transações, conexões e chaves primárias afetadas.

Esta tabela funciona como **log de operações em tabelas** e permite:
- Registrar todas as operações realizadas em tabelas
- Armazenar informações sobre transações e conexões
- Rastrear chaves primárias afetadas (até 5 chaves)
- Identificar usuário e tabela da operação
- Facilitar auditoria completa de operações
- Manter histórico detalhado de mudanças

Cada registro representa uma operação específica em uma tabela, contendo:
- ID da operação (ID)
- Data/hora da operação (DATETIME)
- Nome do usuário (USER_NAME)
- Nome da tabela (TABLE_NAME)
- Tipo de operação (OPERATION) - INSERT, UPDATE, DELETE
- Chaves primárias afetadas (PKEY1 a PKEY5 e seus valores)
- ID da transação (TRANSACTIONID)
- ID da conexão (CONNECTIONID)
- Endereço do cliente (CLIENT_ADDRESS)
- Protocolo de rede (NETWORK_PROTOCOL)
- Nome do banco de dados (DB_NAME)
- Nível de isolamento (ISOLATION_LEVEL)

O sistema utiliza esta tabela para manter histórico completo de operações em tabelas, sendo referenciada por LOG_COLUNA para vincular alterações detalhadas de colunas a operações específicas.

**Observação Importante:** LOG_TABELA é uma tabela de log de operações em tabelas. Com 22 registros, indica uso moderado desta funcionalidade de auditoria. Possui 2 índices em DATETIME (ascendente e descendente) para otimização de consultas por data e é referenciada por LOG_COLUNA para detalhamento de alterações.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | BIGINT | ✓ | ID da operação de log (PK) |

### Informações da Operação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATETIME** | TIMESTAMP | ✓ | Data/hora da operação |
| **USER_NAME** | VARCHAR(37) | ✓ | Nome do usuário que realizou a operação |
| **TABLE_NAME** | VARCHAR(37) | ✓ | Nome da tabela afetada |
| **OPERATION** | VARCHAR(37) | ✓ | Tipo de operação (INSERT, UPDATE, DELETE) |

### Chaves Primárias Afetadas
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PKEY1** | VARCHAR(37) | | Nome da primeira chave primária |
| **PKEY1_VALUE** | VARCHAR(37) | | Valor da primeira chave primária |
| **PKEY2** | VARCHAR(37) | | Nome da segunda chave primária |
| **PKEY2_VALUE** | VARCHAR(37) | | Valor da segunda chave primária |
| **PKEY3** | VARCHAR(37) | | Nome da terceira chave primária |
| **PKEY3_VALUE** | VARCHAR(37) | | Valor da terceira chave primária |
| **PKEY4** | VARCHAR(37) | | Nome da quarta chave primária |
| **PKEY4_VALUE** | VARCHAR(37) | | Valor da quarta chave primária |
| **PKEY5** | VARCHAR(37) | | Nome da quinta chave primária |
| **PKEY5_VALUE** | VARCHAR(37) | | Valor da quinta chave primária |

### Informações de Transação e Conexão
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TRANSACTIONID** | INTEGER | | ID da transação |
| **CONNECTIONID** | INTEGER | | ID da conexão |
| **CLIENT_ADDRESS** | VARCHAR(37) | | Endereço do cliente |
| **NETWORK_PROTOCOL** | VARCHAR(37) | | Protocolo de rede |
| **DB_NAME** | VARCHAR(37) | | Nome do banco de dados |
| **ISOLATION_LEVEL** | VARCHAR(37) | | Nível de isolamento da transação |

**Primary Key:** ID

**Índices:**
- `LOG_TABELA_ASC_IDX` em `DATETIME` (ascendente, não único)
- `LOG_TABELA_DESC_IDX` em `DATETIME` (descendente, não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOG_TABELA Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOG_TABELA é Referenciada Por (1 tabela):

#### 1. LOG_COLUNA - Log de Colunas
**Relacionamento:**
```
LOG_COLUNA.OPERATIONLOG_ID → LOG_TABELA.ID (N:1)
Constraint: FK_LOG_COLUNA_TABELA
```

**Descrição**: Cada alteração de coluna está vinculada a uma operação de log de tabela específica.

**Informações da Tabela LOG_COLUNA:**
- **Total:** 242 alterações de colunas
- **PK:** ID
- **Colunas:** 8 campos

**Uso:** Vincular alterações detalhadas de colunas a operações de log de tabela.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via LOG_COLUNA → Outras Operações de Log

**Fluxo:** LOG_TABELA → LOG_COLUNA → Operações

**Descrição:** Através das alterações de colunas, é possível identificar outras operações relacionadas.

**Uso:** Análise de operações através de alterações de colunas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Operação de Log

**Objetivo:** Obter informações de uma operação específica.

```sql
SELECT
    ID,
    DATETIME,
    USER_NAME,
    TABLE_NAME,
    OPERATION,
    PKEY1,
    PKEY1_VALUE,
    TRANSACTIONID,
    CLIENT_ADDRESS
FROM LOG_TABELA
WHERE ID = ?;
```

---

### 2. Listar Operações de uma Tabela

**Objetivo:** Obter todas as operações realizadas em uma tabela específica.

```sql
SELECT
    ID,
    DATETIME,
    USER_NAME,
    OPERATION,
    PKEY1_VALUE,
    PKEY2_VALUE,
    PKEY3_VALUE
FROM LOG_TABELA
WHERE TABLE_NAME = ?
ORDER BY DATETIME DESC;
```

---

### 3. Análise de Operações por Tipo

**Objetivo:** Identificar distribuição de operações por tipo.

**Query SQL:**
```sql
SELECT
    OPERATION,
    COUNT(*) AS TOTAL_OPERACOES,
    COUNT(DISTINCT TABLE_NAME) AS TOTAL_TABELAS_AFETADAS,
    COUNT(DISTINCT USER_NAME) AS TOTAL_USUARIOS
FROM LOG_TABELA
GROUP BY OPERATION
ORDER BY TOTAL_OPERACOES DESC;
```

---

### 4. Análise de Operações por Usuário

**Objetivo:** Identificar distribuição de operações por usuário.

**Query SQL:**
```sql
SELECT
    USER_NAME,
    COUNT(*) AS TOTAL_OPERACOES,
    COUNT(DISTINCT TABLE_NAME) AS TOTAL_TABELAS_AFETADAS,
    COUNT(DISTINCT OPERATION) AS TOTAL_TIPOS_OPERACAO
FROM LOG_TABELA
WHERE USER_NAME IS NOT NULL
GROUP BY USER_NAME
ORDER BY TOTAL_OPERACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOG_TABELA | Tipo |
|--------|-----------|------------------------|------|
| **LOG_TABELA** | 22 | 1:1 | **TABELA PRINCIPAL** |
| LOG_COLUNA | 242 | 1:11 | Alterações de colunas (média de 11 alterações por operação) |

**Interpretação:**
- **22 operações de log** registradas no sistema
- **Média de 11 alterações de colunas por operação** - indica que cada operação gera múltiplas alterações de colunas

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índices existentes: Busca por data (consultas frequentes)
-- LOG_TABELA_ASC_IDX em DATETIME (ascendente)
-- LOG_TABELA_DESC_IDX em DATETIME (descendente)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por tabela (consultas frequentes)
CREATE INDEX IDX_LOG_TABELA_TABELA ON LOG_TABELA(TABLE_NAME)
    WHERE TABLE_NAME IS NOT NULL;

-- Índice 2: Busca por usuário (consultas frequentes)
CREATE INDEX IDX_LOG_TABELA_USUARIO ON LOG_TABELA(USER_NAME)
    WHERE USER_NAME IS NOT NULL;

-- Índice 3: Busca por tipo de operação (consultas frequentes)
CREATE INDEX IDX_LOG_TABELA_OPERACAO ON LOG_TABELA(OPERATION)
    WHERE OPERATION IS NOT NULL;

-- Índice 4: Busca combinada tabela + data (consultas frequentes)
CREATE INDEX IDX_LOG_TABELA_TABELA_DATA ON LOG_TABELA(TABLE_NAME, DATETIME);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdLogTabela extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOG_TABELA';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'DATETIME' => 'datetime',
        'USER_NAME' => 'string',
        'TABLE_NAME' => 'string',
        'OPERATION' => 'string',
        'PKEY1' => 'string',
        'PKEY1_VALUE' => 'string',
        'PKEY2' => 'string',
        'PKEY2_VALUE' => 'string',
        'PKEY3' => 'string',
        'PKEY3_VALUE' => 'string',
        'PKEY4' => 'string',
        'PKEY4_VALUE' => 'string',
        'PKEY5' => 'string',
        'PKEY5_VALUE' => 'string',
        'TRANSACTIONID' => 'integer',
        'CONNECTIONID' => 'integer',
        'CLIENT_ADDRESS' => 'string',
        'NETWORK_PROTOCOL' => 'string',
        'DB_NAME' => 'string',
        'ISOLATION_LEVEL' => 'string',
    ];

    // Relacionamento com LOG_COLUNA
    public function alteracoesColunas(): HasMany
    {
        return $this->hasMany(FirebirdLogColuna::class, 'OPERATIONLOG_ID', 'ID');
    }

    public function scopePorTabela($query, string $tableName)
    {
        return $query->where('TABLE_NAME', $tableName);
    }

    public function scopePorUsuario($query, string $userName)
    {
        return $query->where('USER_NAME', $userName);
    }

    public function scopePorOperacao($query, string $operation)
    {
        return $query->where('OPERATION', $operation);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATETIME', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query, string $direcao = 'desc')
    {
        return $query->orderBy('DATETIME', $direcao);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

