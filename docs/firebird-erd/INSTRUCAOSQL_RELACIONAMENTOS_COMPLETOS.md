# INSTRUCAOSQL - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INSTRUCAOSQL (Instruções SQL)
- **Total de Registros**: 40
- **Total de Colunas**: 4
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (USUINSTRUCAOSQL)
- **Banco de Dados**: Firebird

## 📝 Descrição

**INSTRUCAOSQL** é uma tabela mestre que armazena instruções SQL pré-definidas utilizadas no sistema. Com **40 registros**, representa diferentes consultas SQL que podem ser executadas por usuários, permitindo acesso controlado a consultas específicas.

Esta tabela funciona como **catálogo de instruções SQL** e permite:
- Armazenar consultas SQL pré-definidas
- Facilitar execução de consultas por usuários
- Controlar acesso a consultas específicas
- Suportar reutilização de consultas
- Facilitar gestão de consultas SQL
- Manter histórico de cadastro de consultas

Cada registro representa uma instrução SQL específica, contendo:
- ID da instrução (ID)
- Descrição da instrução (DESCRICAO)
- Comando SQL (INSTRUCAO)
- Data de cadastro (DTCADASTRO)

O sistema utiliza esta tabela para fornecer instruções SQL pré-definidas, sendo referenciada por USUINSTRUCAOSQL para vincular usuários a instruções SQL específicas.

**Observação Importante:** INSTRUCAOSQL é uma tabela mestre de instruções SQL. Com 40 registros, indica uso moderado desta funcionalidade. É referenciada por USUINSTRUCAOSQL para controle de acesso de usuários a consultas SQL.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID da instrução SQL (PK) |

### Informações da Instrução
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DESCRICAO** | VARCHAR(37) | ✓ | Descrição da instrução SQL |
| **INSTRUCAO** | VARCHAR(37) | ✓ | Comando SQL da instrução |
| **DTCADASTRO** | DATE | | Data de cadastro da instrução |

**Primary Key:** ID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INSTRUCAOSQL Referencia (0 FKs):

Nenhuma foreign key direta.

---

### INSTRUCAOSQL é Referenciada Por (1 tabela):

#### 1. USUINSTRUCAOSQL - Usuário x Instrução SQL
**Relacionamento:**
```
USUINSTRUCAOSQL.ID → INSTRUCAOSQL.ID (N:1)
Constraint: XFK_USUSQL_INSTRUCAOSQL
```

**Descrição**: Cada vinculação usuário-instrução SQL está relacionada a uma instrução SQL específica.

**Informações da Tabela USUINSTRUCAOSQL:**
- **Total:** 130 vinculações
- **PK:** (USUCODIGO, ID)
- **Colunas:** 2 campos

**Uso:** Vincular usuários a instruções SQL para controle de acesso.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via USUINSTRUCAOSQL → USUARIO → Outras Operações de Usuários

**Fluxo:** INSTRUCAOSQL → USUINSTRUCAOSQL → USUARIO → Operações

**Descrição:** Através dos usuários, é possível identificar outras operações relacionadas.

**Uso:** Análise de instruções SQL através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Instrução SQL

**Objetivo:** Obter informações de uma instrução SQL específica.

```sql
SELECT
    ID,
    DESCRICAO,
    INSTRUCAO,
    DTCADASTRO
FROM INSTRUCAOSQL
WHERE ID = ?;
```

---

### 2. Listar Todas as Instruções SQL

**Objetivo:** Obter catálogo completo de instruções SQL disponíveis.

```sql
SELECT
    ID,
    DESCRICAO,
    INSTRUCAO,
    DTCADASTRO
FROM INSTRUCAOSQL
ORDER BY DESCRICAO;
```

---

### 3. Análise de Instruções SQL com Usuários

**Objetivo:** Identificar instruções SQL e seus usuários relacionados.

**Query SQL:**
```sql
SELECT
    i.ID,
    i.DESCRICAO,
    i.INSTRUCAO,
    COUNT(ui.USUCODIGO) AS TOTAL_USUARIOS
FROM INSTRUCAOSQL i
LEFT JOIN USUINSTRUCAOSQL ui ON ui.ID = i.ID
GROUP BY i.ID, i.DESCRICAO, i.INSTRUCAO
ORDER BY TOTAL_USUARIOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INSTRUCAOSQL | Tipo |
|--------|-----------|--------------------------|------|
| **INSTRUCAOSQL** | 40 | 1:1 | **TABELA PRINCIPAL** |
| USUINSTRUCAOSQL | 130 | 1:3.25 | Usuários (média de 3.25 usuários por instrução) |

**Interpretação:**
- **40 instruções SQL** cadastradas no sistema
- **Média de 3.25 usuários por instrução** - indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_INSTRUCAOSQL_DESCRICAO ON INSTRUCAOSQL(DESCRICAO)
    WHERE DESCRICAO IS NOT NULL;
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

final class FirebirdInstrucaosql extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INSTRUCAOSQL';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'DESCRICAO' => 'string',
        'INSTRUCAO' => 'string',
        'DTCADASTRO' => 'date',
    ];

    // Relacionamento com USUINSTRUCAOSQL
    public function usuarios(): HasMany
    {
        return $this->hasMany(FirebirdUsuinstrucaosql::class, 'ID', 'ID');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

