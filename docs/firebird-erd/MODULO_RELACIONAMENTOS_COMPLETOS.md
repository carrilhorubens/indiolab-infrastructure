# MODULO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODULO (Módulos do Sistema)
- **Total de Registros**: 2
- **Total de Colunas**: 4
- **Chave Primária**: MODID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (CONFIGURACAO, RECURSOMODULO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODULO** é uma tabela que armazena informações sobre módulos do sistema. Com **2 registros**, representa módulos cadastrados no sistema, incluindo informações sobre nome, palavra-chave e prioridade.

Esta tabela funciona como **mestre de módulos** e permite:
- Registrar todos os módulos do sistema
- Armazenar informações sobre nome e palavra-chave
- Controlar prioridade de módulos
- Vincular módulos a configurações
- Associar módulos a recursos
- Facilitar gestão de módulos
- Manter histórico detalhado de módulos

Cada registro representa um módulo específico do sistema, contendo:
- ID do módulo (MODID)
- Nome do módulo (MODNOME)
- Palavra-chave do módulo (MODPALAVRACHAVE)
- Prioridade do módulo (MODPRIORIDADE)

O sistema utiliza esta tabela para manter histórico completo de módulos, sendo referenciada por CONFIGURACAO para vincular configurações a módulos e por RECURSOMODULO para associar recursos a módulos.

**Observação Importante:** MODULO é uma tabela mestre de módulos do sistema. Com apenas 2 registros, indica uso limitado desta funcionalidade. Não possui foreign keys diretas, mas é referenciada por 2 tabelas, indicando sua importância no sistema de gestão de módulos.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MODID** 🔑 | INTEGER | ✓ | ID do módulo (PK) |

### Informações do Módulo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MODNOME** | VARCHAR(37) | ✓ | Nome do módulo |
| **MODPALAVRACHAVE** | VARCHAR(37) | ✓ | Palavra-chave do módulo |
| **MODPRIORIDADE** | INTEGER | ✓ | Prioridade do módulo |

**Primary Key:** MODID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODULO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MODULO é Referenciada Por (2 tabelas):

#### 1. CONFIGURACAO - Configurações
**Relacionamento:**
```
CONFIGURACAO.MODID → MODULO.MODID (N:1)
Constraint: MODULO_CONFIGURACAO
```

**Descrição**: Cada configuração está vinculada a um módulo específico.

**Informações da Tabela CONFIGURACAO:**
- **Total:** Varia conforme configurações
- **PK:** Varia conforme estrutura
- **Colunas:** Varia conforme estrutura

**Uso:** Vincular configurações a módulos para organização.

---

#### 2. RECURSOMODULO - Recursos de Módulos
**Relacionamento:**
```
RECURSOMODULO.MODID → MODULO.MODID (N:1)
Constraint: MODULO_RECURSOMODULO
```

**Descrição**: Cada recurso está vinculado a um módulo específico.

**Informações da Tabela RECURSOMODULO:**
- **Total:** Varia conforme recursos
- **PK:** Varia conforme estrutura
- **Colunas:** Varia conforme estrutura

**Uso:** Associar recursos a módulos para gestão de permissões.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CONFIGURACAO → Outras Operações

**Fluxo:** MODULO → CONFIGURACAO → Operações

**Descrição:** Através das configurações vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de módulos através de configurações.

---

### Via RECURSOMODULO → Outras Operações

**Fluxo:** MODULO → RECURSOMODULO → Operações

**Descrição:** Através dos recursos vinculados, é possível identificar outras operações relacionadas.

**Uso:** Análise de módulos através de recursos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Módulo

**Objetivo:** Obter informações de um módulo específico.

```sql
SELECT
    MODID,
    MODNOME,
    MODPALAVRACHAVE,
    MODPRIORIDADE
FROM MODULO
WHERE MODID = ?;
```

---

### 2. Listar Configurações de um Módulo

**Objetivo:** Obter todas as configurações vinculadas a um módulo específico.

```sql
SELECT
    c.*
FROM MODULO m
INNER JOIN CONFIGURACAO c ON c.MODID = m.MODID
WHERE m.MODID = ?;
```

---

### 3. Análise de Módulos por Prioridade

**Objetivo:** Identificar distribuição de módulos por prioridade.

**Query SQL:**
```sql
SELECT
    MODPRIORIDADE,
    COUNT(*) AS TOTAL_MODULOS,
    STRING_AGG(MODNOME, ', ') AS MODULOS
FROM MODULO
WHERE MODPRIORIDADE IS NOT NULL
GROUP BY MODPRIORIDADE
ORDER BY MODPRIORIDADE;
```

---

### 4. Buscar Módulos Ordenados

**Objetivo:** Obter módulos ordenados por prioridade.

```sql
SELECT
    MODID,
    MODNOME,
    MODPALAVRACHAVE,
    MODPRIORIDADE
FROM MODULO
ORDER BY MODPRIORIDADE, MODNOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODULO | Tipo |
|--------|-----------|-------------------|------|
| **MODULO** | 2 | 1:1 | **TABELA PRINCIPAL** |
| CONFIGURACAO | Varia | 1:N | Configurações |
| RECURSOMODULO | Varia | 1:N | Recursos |

**Interpretação:**
- **2 módulos** registrados no sistema
- Indica uso limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por prioridade (consultas frequentes)
CREATE INDEX IDX_MODULO_PRIORIDADE ON MODULO(MODPRIORIDADE)
    WHERE MODPRIORIDADE IS NOT NULL;

-- Índice 2: Busca por palavra-chave (consultas frequentes)
CREATE INDEX IDX_MODULO_PALAVRACHAVE ON MODULO(MODPALAVRACHAVE)
    WHERE MODPALAVRACHAVE IS NOT NULL;
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

final class FirebirdModulo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODULO';
    
    protected $primaryKey = 'MODID';
    public $incrementing = true;

    protected $casts = [
        'MODID' => 'integer',
        'MODNOME' => 'string',
        'MODPALAVRACHAVE' => 'string',
        'MODPRIORIDADE' => 'integer',
    ];

    // Relacionamento com CONFIGURACAO
    public function configuracoes(): HasMany
    {
        return $this->hasMany(FirebirdConfiguracao::class, 'MODID', 'MODID');
    }

    // Relacionamento com RECURSOMODULO
    public function recursos(): HasMany
    {
        return $this->hasMany(FirebirdRecursomodulo::class, 'MODID', 'MODID');
    }

    public function scopePorPrioridade($query, int $prioridade)
    {
        return $query->where('MODPRIORIDADE', $prioridade);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MODPRIORIDADE')->orderBy('MODNOME');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

