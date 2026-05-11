# GRUSET - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUSET (Grupo de Setores)
- **Total de Registros**: 1
- **Total de Colunas**: 3
- **Chave Primária**: GSCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (SETOR)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUSET** é uma tabela mestre que armazena grupos de setores utilizados para categorização e organização de setores. Com apenas **1 registro**, representa diferentes grupos de setores que permitem classificação e agrupamento de setores com valores específicos.

Esta tabela funciona como **catálogo de grupos de setores** e permite:
- Categorizar setores em grupos específicos
- Definir valores por grupo de setores
- Facilitar organização e busca de setores por grupo
- Suportar classificação hierárquica de setores
- Facilitar gestão de setores

Cada registro representa um grupo de setores específico, contendo:
- Código do grupo (GSCODIGO)
- Descrição do grupo (GSDESCRICAO)
- Valor do grupo (GSVALOR)

O sistema utiliza esta tabela para organizar setores em grupos, sendo referenciada por SETOR (setores) para vincular setores a grupos específicos.

**Observação Importante:** GRUSET é uma tabela mestre de grupos de setores. Com apenas 1 registro, indica uso muito limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GSCODIGO** 🔑 | SMALLINT | ✓ | Código do grupo de setores (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GSDESCRICAO** | VARCHAR(37) | ✓ | Descrição do grupo de setores |
| **GSVALOR** | NUMERIC(16,2) | | Valor do grupo de setores |

**Primary Key:** GSCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUSET Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUSET é Referenciada Por (1 tabela):

#### 1. SETOR - Setores
**Relacionamento:**
```
SETOR.GSCODIGO → GRUSET.GSCODIGO (N:1)
Constraint: GRUSET_SETOR
```

**Descrição**: Cada setor pode estar vinculado a um grupo de setores específico.

**Informações da Tabela SETOR:**
- **Total:** 25 setores
- **PK:** SETCODIGO
- **Colunas:** 9 campos

**Uso:** Vincular setores a grupos de setores para organização e classificação.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via SETOR → Outras Operações de Setores

**Fluxo:** GRUSET → SETOR → Operações

**Descrição:** Através dos setores, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos de setores através de operações de setores.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Setores

**Objetivo:** Obter informações de um grupo de setores específico.

```sql
SELECT
    GSCODIGO,
    GSDESCRICAO AS GRUPO_SETORES,
    GSVALOR AS VALOR
FROM GRUSET
WHERE GSCODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Setores

**Objetivo:** Obter catálogo completo de grupos de setores.

```sql
SELECT
    GSCODIGO,
    GSDESCRICAO AS GRUPO_SETORES,
    GSVALOR AS VALOR
FROM GRUSET
ORDER BY GSDESCRICAO;
```

---

### 3. Análise de Grupos com Setores

**Objetivo:** Identificar grupos e seus setores relacionados.

**Query SQL:**
```sql
SELECT
    gs.GSCODIGO,
    gs.GSDESCRICAO AS GRUPO_SETORES,
    gs.GSVALOR AS VALOR,
    COUNT(s.SETCODIGO) AS TOTAL_SETORES
FROM GRUSET gs
LEFT JOIN SETOR s ON s.GSCODIGO = gs.GSCODIGO
GROUP BY gs.GSCODIGO, gs.GSDESCRICAO, gs.GSVALOR
ORDER BY TOTAL_SETORES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUSET | Tipo |
|--------|-----------|---------------------|------|
| **GRUSET** | 1 | 1:1 | **TABELA PRINCIPAL** |
| SETOR | 25 | 1:25 | Setores (média de 25 setores por grupo) |

**Interpretação:**
- **1 grupo de setores** cadastrado no sistema
- **Média de 25 setores por grupo** - indica que quase todos os setores estão vinculados ao mesmo grupo

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_GRUSET_DESCRICAO ON GRUSET(GSDESCRICAO)
    WHERE GSDESCRICAO IS NOT NULL;
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

final class FirebirdGruset extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUSET';
    
    protected $primaryKey = 'GSCODIGO';
    public $incrementing = true;

    protected $casts = [
        'GSCODIGO' => 'integer',
        'GSDESCRICAO' => 'string',
        'GSVALOR' => 'decimal:2',
    ];

    // Relacionamento com SETOR
    public function setores(): HasMany
    {
        return $this->hasMany(FirebirdSetor::class, 'GSCODIGO', 'GSCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

