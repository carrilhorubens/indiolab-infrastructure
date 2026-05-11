# GRULENTE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRULENTE (Grupo de Lentes)
- **Total de Registros**: 21
- **Total de Colunas**: 5
- **Chave Primária**: GLCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (GRULENTESISEXT, MATERIAL_LW)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRULENTE** é uma tabela mestre que armazena grupos de lentes utilizados para categorização e organização de produtos óticos. Com **21 registros**, representa diferentes grupos de lentes que permitem classificação e controle de produtos relacionados a lentes.

Esta tabela funciona como **catálogo de grupos de lentes** e permite:
- Categorizar lentes em grupos específicos
- Controlar disponibilidade para internet
- Definir ordem de exibição
- Permitir montagem de produtos diferentes por grupo
- Facilitar organização e busca de produtos por grupo
- Suportar integração com sistemas externos

Cada registro representa um grupo de lentes específico, contendo:
- Código do grupo (GLCODIGO)
- Descrição do grupo (GLDESCRICAO)
- Ordem de exibição (GLORDEM)
- Flag de disponibilidade para internet (GLINTERNET)
- Flag de permissão de montagem de produtos diferentes (GLPERMMONTPRODDIF)

O sistema utiliza esta tabela para organizar produtos relacionados a lentes, permitindo categorização e controle específico por grupo.

**Observação Importante:** GRULENTE é uma tabela mestre de grupos de lentes. Com 21 registros, indica uso moderado desta funcionalidade. É referenciada por GRULENTESISEXT (integração com sistemas externos) e MATERIAL_LW (materiais de lentes).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GLCODIGO** 🔑 | VARCHAR(14) | ✓ | Código do grupo de lentes (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GLDESCRICAO** | VARCHAR(37) | | Descrição do grupo de lentes |
| **GLORDEM** | SMALLINT | | Ordem de exibição do grupo |
| **GLINTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |
| **GLPERMMONTPRODDIF** | VARCHAR(14) | | Flag de permissão de montagem de produtos diferentes (S/N) |

**Primary Key:** GLCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRULENTE Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRULENTE é Referenciada Por (2 tabelas):

#### 1. GRULENTESISEXT - Integração com Sistemas Externos
**Relacionamento:**
```
GRULENTESISEXT.GLCODIGO → GRULENTE.GLCODIGO (N:1)
Constraint: GRULENTE_GRULENTESISEXT
```

**Descrição**: Cada grupo de lentes pode ter múltiplos mapeamentos com sistemas externos.

**Informações da Tabela GRULENTESISEXT:**
- **Total:** 21 mapeamentos
- **PK:** (GLCODIGO, GLSENOME)
- **Colunas:** 3 campos

**Uso:** Mapear grupos de lentes internos com códigos de sistemas externos.

---

#### 2. MATERIAL_LW - Materiais de Lentes
**Relacionamento:**
```
MATERIAL_LW.MLGLCODIGO → GRULENTE.GLCODIGO (N:1)
Constraint: FK_MLGLCODIGO
```

**Descrição**: Cada material de lente pode estar vinculado a um grupo de lentes específico.

**Informações da Tabela MATERIAL_LW:**
- **Total:** Informação não disponível
- **PK:** Informação não disponível
- **Colunas:** Informação não disponível

**Uso:** Vincular materiais de lentes a grupos específicos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via GRULENTESISEXT → SISTEMAEXT → Outras Operações

**Fluxo:** GRULENTE → GRULENTESISEXT → SISTEMAEXT → Operações

**Descrição:** Através da integração com sistemas externos, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos de lentes através de sistemas externos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo de Lentes

**Objetivo:** Obter visão completa de um grupo de lentes incluindo integrações externas.

**Fluxo:**
```
GRULENTE (GLCODIGO)
  ↓
GRULENTESISEXT (GLCODIGO)
  ↓
SISTEMAEXT (GLSENOME)
```

**Query SQL:**
```sql
SELECT
    gl.GLCODIGO,
    gl.GLDESCRICAO AS GRUPO_LENTES,
    gl.GLORDEM AS ORDEM,
    gl.GLINTERNET AS DISPONIVEL_INTERNET,
    gl.GLPERMMONTPRODDIF AS PERMITE_MONTAGEM_DIFERENTE,
    COUNT(DISTINCT gle.GLSENOME) AS TOTAL_SISTEMAS_EXTERNOS,
    COUNT(DISTINCT ml.MLGLCODIGO) AS TOTAL_MATERIAIS
FROM GRULENTE gl
LEFT JOIN GRULENTESISEXT gle ON gle.GLCODIGO = gl.GLCODIGO
LEFT JOIN MATERIAL_LW ml ON ml.MLGLCODIGO = gl.GLCODIGO
WHERE gl.GLCODIGO = ?
GROUP BY gl.GLCODIGO, gl.GLDESCRICAO, gl.GLORDEM, gl.GLINTERNET, gl.GLPERMMONTPRODDIF;
```

---

### Exemplo 2: Análise de Grupos Disponíveis para Internet

**Objetivo:** Identificar grupos de lentes disponíveis para internet.

**Query SQL:**
```sql
SELECT
    GLCODIGO,
    GLDESCRICAO AS GRUPO_LENTES,
    GLORDEM AS ORDEM
FROM GRULENTE
WHERE GLINTERNET = 'S'
ORDER BY GLORDEM;
```

---

### Exemplo 3: Análise de Grupos com Integrações Externas

**Objetivo:** Identificar grupos que possuem integrações com sistemas externos.

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

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Lentes

**Objetivo:** Obter informações de um grupo de lentes específico.

```sql
SELECT
    GLCODIGO,
    GLDESCRICAO AS GRUPO_LENTES,
    GLORDEM AS ORDEM,
    GLINTERNET AS DISPONIVEL_INTERNET,
    GLPERMMONTPRODDIF AS PERMITE_MONTAGEM_DIFERENTE
FROM GRULENTE
WHERE GLCODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Lentes

**Objetivo:** Obter catálogo completo de grupos de lentes.

```sql
SELECT
    GLCODIGO,
    GLDESCRICAO AS GRUPO_LENTES,
    GLORDEM AS ORDEM,
    GLINTERNET AS DISPONIVEL_INTERNET
FROM GRULENTE
ORDER BY GLORDEM;
```

---

### 3. Análise de Grupos por Disponibilidade Internet

**Objetivo:** Identificar distribuição de grupos por disponibilidade para internet.

**Query SQL:**
```sql
SELECT
    GLINTERNET AS DISPONIVEL_INTERNET,
    COUNT(*) AS TOTAL_GRUPOS
FROM GRULENTE
WHERE GLINTERNET IS NOT NULL
GROUP BY GLINTERNET
ORDER BY TOTAL_GRUPOS DESC;
```

---

### 4. Análise de Grupos com Permissão de Montagem Diferente

**Objetivo:** Identificar grupos que permitem montagem de produtos diferentes.

**Query SQL:**
```sql
SELECT
    GLCODIGO,
    GLDESCRICAO AS GRUPO_LENTES,
    GLPERMMONTPRODDIF AS PERMITE_MONTAGEM_DIFERENTE
FROM GRULENTE
WHERE GLPERMMONTPRODDIF = 'S'
ORDER BY GLORDEM;
```

---

### 5. Relatório Completo de Grupos de Lentes

**Objetivo:** Analisar distribuição completa de grupos de lentes no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    COUNT(CASE WHEN GLINTERNET = 'S' THEN 1 END) AS DISPONIVEIS_INTERNET,
    COUNT(CASE WHEN GLPERMMONTPRODDIF = 'S' THEN 1 END) AS PERMITEM_MONTAGEM_DIFERENTE,
    (SELECT COUNT(*) FROM GRULENTESISEXT) AS TOTAL_INTEGRACOES_EXTERNAS,
    (SELECT COUNT(*) FROM MATERIAL_LW WHERE MLGLCODIGO IS NOT NULL) AS TOTAL_MATERIAIS_VINCULADOS
FROM GRULENTE;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRULENTE | Tipo |
|--------|-----------|----------------------|------|
| **GRULENTE** | 21 | 1:1 | **TABELA PRINCIPAL** |
| GRULENTESISEXT | 21 | 1:1 | Integrações externas (média de 1 integração por grupo) |
| MATERIAL_LW | Informação não disponível | - | Materiais vinculados |

**Interpretação:**
- **21 grupos de lentes** cadastrados no sistema
- **Média de 1 integração externa por grupo** - indica uso extensivo de integrações

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRULENTE_ORDEM ON GRULENTE(GLORDEM)
    WHERE GLORDEM IS NOT NULL;

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_GRULENTE_INTERNET ON GRULENTE(GLINTERNET)
    WHERE GLINTERNET = 'S';

-- Índice 3: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_GRULENTE_DESCRICAO ON GRULENTE(GLDESCRICAO)
    WHERE GLDESCRICAO IS NOT NULL;
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

final class FirebirdGrulente extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRULENTE';
    
    protected $primaryKey = 'GLCODIGO';
    public $incrementing = false;

    protected $casts = [
        'GLCODIGO' => 'string',
        'GLDESCRICAO' => 'string',
        'GLORDEM' => 'integer',
        'GLINTERNET' => 'string',
        'GLPERMMONTPRODDIF' => 'string',
    ];

    // Relacionamento com GRULENTESISEXT
    public function integracoesExternas(): HasMany
    {
        return $this->hasMany(FirebirdGrulentesisext::class, 'GLCODIGO', 'GLCODIGO');
    }

    // Relacionamento com MATERIAL_LW
    public function materiais(): HasMany
    {
        return $this->hasMany(FirebirdMaterialLw::class, 'MLGLCODIGO', 'GLCODIGO');
    }

    public function scopeDisponivelInternet($query)
    {
        return $query->where('GLINTERNET', 'S');
    }

    public function scopePermiteMontagemDiferente($query)
    {
        return $query->where('GLPERMMONTPRODDIF', 'S');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GLORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

