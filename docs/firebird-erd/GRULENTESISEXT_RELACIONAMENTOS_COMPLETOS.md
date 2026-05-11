# GRULENTESISEXT - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRULENTESISEXT (Grupo de Lentes x Sistema Externo)
- **Total de Registros**: 21
- **Total de Colunas**: 3
- **Chave Primária**: Composta (GLCODIGO, GLSENOME)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRULENTESISEXT** é uma tabela de integração que mapeia grupos de lentes internos com códigos de sistemas externos. Com **21 registros**, representa mapeamentos entre grupos de lentes do sistema interno e códigos correspondentes em sistemas externos, permitindo sincronização e integração de dados.

Esta tabela funciona como **mapeamento de grupos de lentes com sistemas externos** e permite:
- Mapear grupos de lentes internos com códigos externos
- Suportar integração com múltiplos sistemas externos
- Facilitar sincronização de dados entre sistemas
- Manter correspondência entre códigos internos e externos
- Suportar integrações específicas por sistema externo
- Facilitar migração e importação de dados

Cada registro representa um mapeamento específico entre um grupo de lentes interno e um código em um sistema externo, contendo:
- Código do grupo de lentes interno (GLCODIGO) - parte da PK + FK → GRULENTE
- Código no sistema externo (GLSECODIGO)
- Nome do sistema externo (GLSENOME) - parte da PK + FK → SISTEMAEXT

O sistema utiliza esta tabela para manter correspondência entre grupos de lentes internos e códigos de sistemas externos, permitindo integração e sincronização de dados.

**Observação Importante:** GRULENTESISEXT é uma tabela de integração que conecta grupos de lentes com sistemas externos. Com 21 registros e chave primária composta, indica uso extensivo de integrações externas. Segue o padrão de outras tabelas de integração como CLIENSISEXT e PRODUSISEXT.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GLCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código do grupo de lentes interno (PK + FK → GRULENTE) |
| **GLSENOME** 🔑 🔗 | VARCHAR(14) | ✓ | Nome do sistema externo (PK + FK → SISTEMAEXT) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GLSECODIGO** | VARCHAR(37) | ✓ | Código do grupo no sistema externo |

**Primary Key:** (GLCODIGO, GLSENOME)

**Foreign Keys:**
- `GLCODIGO` → `GRULENTE.GLCODIGO` (Constraint: GRULENTE_GRULENTESISEXT)
- `GLSENOME` → `SISTEMAEXT.SENOME` (Constraint: SISTEMAEXT_GRULENTESISEXT)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRULENTESISEXT Referencia (2 FKs):

#### 1. GRULENTE - Grupos de Lentes
**Relacionamento:**
```
GRULENTESISEXT.GLCODIGO → GRULENTE.GLCODIGO (N:1)
Constraint: GRULENTE_GRULENTESISEXT
```

**Descrição**: Cada mapeamento está vinculado a um grupo de lentes específico.

**Informações da Tabela GRULENTE:**
- **Total:** 21 grupos
- **PK:** GLCODIGO
- **Colunas:** 5 campos

**Uso:** Identificar o grupo de lentes interno relacionado ao mapeamento.

---

#### 2. SISTEMAEXT - Sistemas Externos
**Relacionamento:**
```
GRULENTESISEXT.GLSENOME → SISTEMAEXT.SENOME (N:1)
Constraint: SISTEMAEXT_GRULENTESISEXT
```

**Descrição**: Cada mapeamento está vinculado a um sistema externo específico.

**Informações da Tabela SISTEMAEXT:**
- **Total:** Informação não disponível
- **PK:** SENOME
- **Colunas:** Informação não disponível

**Uso:** Identificar o sistema externo relacionado ao mapeamento.

---

### GRULENTESISEXT é Referenciada Por (0 tabelas):

Nenhuma tabela referencia GRULENTESISEXT diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via GRULENTE → Outras Operações de Grupos

**Fluxo:** GRULENTESISEXT → GRULENTE → Operações

**Descrição:** Através do grupo de lentes, é possível identificar outras operações relacionadas.

**Uso:** Análise de mapeamentos através de grupos de lentes.

---

### Via SISTEMAEXT → Outras Integrações

**Fluxo:** GRULENTESISEXT → SISTEMAEXT → Outras Integrações

**Descrição:** Através do sistema externo, é possível identificar outras integrações relacionadas.

**Uso:** Análise de mapeamentos através de sistemas externos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Mapeamento

**Objetivo:** Obter visão completa de um mapeamento incluindo informações do grupo e sistema externo.

**Fluxo:**
```
GRULENTESISEXT (GLCODIGO, GLSENOME)
  ↓
GRULENTE (GLCODIGO)
  ↓
SISTEMAEXT (SENOME)
```

**Query SQL:**
```sql
SELECT
    gle.GLCODIGO,
    gl.GLDESCRICAO AS GRUPO_LENTES,
    gle.GLSENOME,
    se.SEDESCRICAO AS SISTEMA_EXTERNO,
    gle.GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT gle
INNER JOIN GRULENTE gl ON gl.GLCODIGO = gle.GLCODIGO
LEFT JOIN SISTEMAEXT se ON se.SENOME = gle.GLSENOME
WHERE gle.GLCODIGO = ?
  AND gle.GLSENOME = ?;
```

---

### Exemplo 2: Análise de Mapeamentos por Grupo

**Objetivo:** Identificar todos os mapeamentos de um grupo específico.

**Query SQL:**
```sql
SELECT
    gle.GLSENOME,
    se.SEDESCRICAO AS SISTEMA_EXTERNO,
    gle.GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT gle
LEFT JOIN SISTEMAEXT se ON se.SENOME = gle.GLSENOME
WHERE gle.GLCODIGO = ?
ORDER BY gle.GLSENOME;
```

---

### Exemplo 3: Análise de Mapeamentos por Sistema Externo

**Objetivo:** Identificar todos os mapeamentos de um sistema externo específico.

**Query SQL:**
```sql
SELECT
    gle.GLCODIGO,
    gl.GLDESCRICAO AS GRUPO_LENTES,
    gle.GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT gle
INNER JOIN GRULENTE gl ON gl.GLCODIGO = gle.GLCODIGO
WHERE gle.GLSENOME = ?
ORDER BY gle.GLCODIGO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Mapeamento

**Objetivo:** Obter informações de um mapeamento específico.

```sql
SELECT
    GLCODIGO,
    GLSENOME,
    GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT
WHERE GLCODIGO = ?
  AND GLSENOME = ?;
```

---

### 2. Listar Mapeamentos de um Grupo

**Objetivo:** Obter todos os mapeamentos de um grupo específico.

```sql
SELECT
    GLSENOME,
    GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT
WHERE GLCODIGO = ?
ORDER BY GLSENOME;
```

---

### 3. Análise de Mapeamentos por Sistema Externo

**Objetivo:** Identificar distribuição de mapeamentos por sistema externo.

**Query SQL:**
```sql
SELECT
    gle.GLSENOME,
    se.SEDESCRICAO AS SISTEMA_EXTERNO,
    COUNT(*) AS TOTAL_MAPEAMENTOS
FROM GRULENTESISEXT gle
LEFT JOIN SISTEMAEXT se ON se.SENOME = gle.GLSENOME
GROUP BY gle.GLSENOME, se.SEDESCRICAO
ORDER BY TOTAL_MAPEAMENTOS DESC;
```

---

### 4. Análise de Grupos com Mapeamentos

**Objetivo:** Identificar grupos que possuem mapeamentos com sistemas externos.

**Query SQL:**
```sql
SELECT
    gl.GLCODIGO,
    gl.GLDESCRICAO AS GRUPO_LENTES,
    COUNT(gle.GLSENOME) AS TOTAL_SISTEMAS_EXTERNOS
FROM GRULENTE gl
LEFT JOIN GRULENTESISEXT gle ON gle.GLCODIGO = gl.GLCODIGO
GROUP BY gl.GLCODIGO, gl.GLDESCRICAO
HAVING COUNT(gle.GLSENOME) > 0
ORDER BY TOTAL_SISTEMAS_EXTERNOS DESC;
```

---

### 5. Buscar Código Externo por Código Interno

**Objetivo:** Obter código externo de um grupo para um sistema específico.

**Query SQL:**
```sql
SELECT
    GLSECODIGO AS CODIGO_EXTERNO
FROM GRULENTESISEXT
WHERE GLCODIGO = ?
  AND GLSENOME = ?;
```

---

### 6. Relatório Completo de Mapeamentos

**Objetivo:** Analisar distribuição completa de mapeamentos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_MAPEAMENTOS,
    COUNT(DISTINCT GLCODIGO) AS TOTAL_GRUPOS_MAPEADOS,
    COUNT(DISTINCT GLSENOME) AS TOTAL_SISTEMAS_EXTERNOS,
    COUNT(CASE WHEN GLSECODIGO IS NULL OR GLSECODIGO = '' THEN 1 END) AS SEM_CODIGO_EXTERNO
FROM GRULENTESISEXT;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRULENTESISEXT | Tipo |
|--------|-----------|----------------------------|------|
| **GRULENTESISEXT** | 21 | 1:1 | **TABELA PRINCIPAL** |
| GRULENTE | 21 | 1:1 | Grupos (média de 1 mapeamento por grupo) |
| SISTEMAEXT | Informação não disponível | - | Sistemas externos |

**Interpretação:**
- **21 mapeamentos** registrados no sistema
- **Média de 1 mapeamento por grupo** - indica uso extensivo de integrações externas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por grupo (consultas frequentes)
CREATE INDEX IDX_GRULENTESISEXT_GRUPO ON GRULENTESISEXT(GLCODIGO);

-- Índice 2: Busca por sistema externo (consultas frequentes)
CREATE INDEX IDX_GRULENTESISEXT_SISTEMA ON GRULENTESISEXT(GLSENOME);

-- Índice 3: Busca combinada grupo + sistema (já coberto pela PK)
-- A PK já fornece índice eficiente
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

final class FirebirdGrulentesisext extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRULENTESISEXT';
    
    protected $primaryKey = ['GLCODIGO', 'GLSENOME'];
    public $incrementing = false;

    protected $casts = [
        'GLCODIGO' => 'string',
        'GLSENOME' => 'string',
        'GLSECODIGO' => 'string',
    ];

    // Relacionamento com GRULENTE
    public function grupoLentes(): BelongsTo
    {
        return $this->belongsTo(FirebirdGrulente::class, 'GLCODIGO', 'GLCODIGO');
    }

    // Relacionamento com SISTEMAEXT
    public function sistemaExterno(): BelongsTo
    {
        return $this->belongsTo(FirebirdSistemaext::class, 'GLSENOME', 'SENOME');
    }

    public function scopePorGrupo($query, string $glCodigo)
    {
        return $query->where('GLCODIGO', $glCodigo);
    }

    public function scopePorSistema($query, string $glseNome)
    {
        return $query->where('GLSENOME', $glseNome);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

