# INTEGRACTBCHAVES - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INTEGRACTBCHAVES (Chaves de Integração Contábil)
- **Total de Registros**: 24
- **Total de Colunas**: 4
- **Chave Primária**: Composta (CHAVE, ORIGEM)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (INTEGRACTBCONTAS)
- **Banco de Dados**: Firebird

## 📝 Descrição

**INTEGRACTBCHAVES** é uma tabela mestre que armazena chaves de integração contábil utilizadas para mapeamento e integração entre sistemas contábeis. Com **24 registros**, representa diferentes chaves de integração que permitem mapear campos e valores entre sistemas.

Esta tabela funciona como **catálogo de chaves de integração contábil** e permite:
- Definir chaves de integração contábil
- Mapear campos entre sistemas
- Suportar integração com sistemas externos
- Facilitar configuração de integração contábil
- Suportar múltiplas origens de dados
- Facilitar gestão de integração contábil

Cada registro representa uma chave de integração específica, contendo:
- Chave de integração (CHAVE) - parte da PK
- Origem da chave (ORIGEM) - parte da PK
- Campo mapeado (CAMPO)
- Ordem de processamento (ORDEM)

O sistema utiliza esta tabela para configurar chaves de integração contábil, sendo referenciada por INTEGRACTBCONTAS para vincular contas contábeis a chaves de integração específicas.

**Observação Importante:** INTEGRACTBCHAVES é uma tabela mestre de chaves de integração contábil. Com 24 registros, indica uso moderado desta funcionalidade. Possui chave primária composta e é referenciada por INTEGRACTBCONTAS através de chave composta (CHAVE, ORIGEM).

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHAVE** 🔑 | VARCHAR(37) | ✓ | Chave de integração (PK) |
| **ORIGEM** 🔑 | VARCHAR(37) | ✓ | Origem da chave (PK) |

### Informações da Chave
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CAMPO** | VARCHAR(37) | ✓ | Campo mapeado |
| **ORDEM** | SMALLINT | ✓ | Ordem de processamento |

**Primary Key:** (CHAVE, ORIGEM)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INTEGRACTBCHAVES Referencia (0 FKs):

Nenhuma foreign key direta.

---

### INTEGRACTBCHAVES é Referenciada Por (1 tabela):

#### 1. INTEGRACTBCONTAS - Integração Contábil Contas
**Relacionamento:**
```
INTEGRACTBCONTAS.(CHAVE, ORIGEM) → INTEGRACTBCHAVES.(CHAVE, ORIGEM) (N:1)
Constraint: FK_INTEGRACTBCONTAS_2
```

**Descrição**: Cada conta de integração contábil está vinculada a uma chave de integração específica.

**Informações da Tabela INTEGRACTBCONTAS:**
- **Total:** 24 contas de integração
- **PK:** (ITCCODIGO, EMPCODIGO, CHAVE)
- **Colunas:** 13 campos

**Uso:** Vincular contas contábeis a chaves de integração para mapeamento e integração.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via INTEGRACTBCONTAS → Outras Operações Contábeis

**Fluxo:** INTEGRACTBCHAVES → INTEGRACTBCONTAS → Operações

**Descrição:** Através das contas de integração, é possível identificar outras operações relacionadas.

**Uso:** Análise de chaves de integração através de operações contábeis.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Chave de Integração

**Objetivo:** Obter informações de uma chave de integração específica.

```sql
SELECT
    CHAVE,
    ORIGEM,
    CAMPO,
    ORDEM
FROM INTEGRACTBCHAVES
WHERE CHAVE = ?
  AND ORIGEM = ?;
```

---

### 2. Listar Todas as Chaves de Integração

**Objetivo:** Obter catálogo completo de chaves de integração disponíveis.

```sql
SELECT
    CHAVE,
    ORIGEM,
    CAMPO,
    ORDEM
FROM INTEGRACTBCHAVES
ORDER BY ORIGEM, ORDEM;
```

---

### 3. Análise de Chaves de Integração com Contas

**Objetivo:** Identificar chaves de integração e suas contas relacionadas.

**Query SQL:**
```sql
SELECT
    ich.CHAVE,
    ich.ORIGEM,
    ich.CAMPO,
    ich.ORDEM,
    COUNT(icc.ITCCODIGO) AS TOTAL_CONTAS
FROM INTEGRACTBCHAVES ich
LEFT JOIN INTEGRACTBCONTAS icc ON icc.CHAVE = ich.CHAVE 
                               AND icc.ORIGEM = ich.ORIGEM
GROUP BY ich.CHAVE, ich.ORIGEM, ich.CAMPO, ich.ORDEM
ORDER BY TOTAL_CONTAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INTEGRACTBCHAVES | Tipo |
|--------|-----------|----------------------------|------|
| **INTEGRACTBCHAVES** | 24 | 1:1 | **TABELA PRINCIPAL** |
| INTEGRACTBCONTAS | 24 | 1:1 | Contas de integração (média de 1 conta por chave) |

**Interpretação:**
- **24 chaves de integração** cadastradas no sistema
- **Média de 1 conta por chave** - indica mapeamento 1:1 entre chaves e contas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por origem (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBCHAVES_ORIGEM ON INTEGRACTBCHAVES(ORIGEM)
    WHERE ORIGEM IS NOT NULL;

-- Índice 2: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBCHAVES_ORDEM ON INTEGRACTBCHAVES(ORDEM)
    WHERE ORDEM IS NOT NULL;
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

final class FirebirdIntegractbchaves extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INTEGRACTBCHAVES';
    
    protected $primaryKey = ['CHAVE', 'ORIGEM'];
    public $incrementing = false;

    protected $casts = [
        'CHAVE' => 'string',
        'ORIGEM' => 'string',
        'CAMPO' => 'string',
        'ORDEM' => 'integer',
    ];

    // Relacionamento com INTEGRACTBCONTAS
    public function contasIntegracao(): HasMany
    {
        return $this->hasMany(FirebirdIntegractbcontas::class, ['CHAVE', 'ORIGEM'], ['CHAVE', 'ORIGEM']);
    }

    public function scopePorOrigem($query, string $origem)
    {
        return $query->where('ORIGEM', $origem);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('ORIGEM')->orderBy('ORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

