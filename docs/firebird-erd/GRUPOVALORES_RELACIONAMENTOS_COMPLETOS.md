# GRUPOVALORES - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPOVALORES (Valores de Grupo de Rótulos)
- **Total de Registros**: 309
- **Total de Colunas**: 3
- **Chave Primária**: Composta (GRCODIGO, GRVALORES)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPOVALORES** é uma tabela que armazena valores específicos associados a grupos de rótulos. Com **309 registros**, representa valores individuais que pertencem a grupos de rótulos, permitindo classificação detalhada e organização de produtos e serviços através de valores específicos.

Esta tabela funciona como **valores de grupos de rótulos** e permite:
- Armazenar valores específicos de cada grupo de rótulos
- Definir ordem de exibição de valores
- Facilitar classificação e busca de produtos por valores
- Suportar múltiplos valores por grupo
- Manter estrutura hierárquica de valores
- Facilitar gestão de categorias detalhadas

Cada registro representa um valor específico de um grupo de rótulos, contendo:
- Código do grupo de rótulos (GRCODIGO) - parte da PK + FK → GRUPOROTULOS
- Valor do grupo (GRVALORES) - parte da PK
- Ordem de exibição (GRORDEM)

O sistema utiliza esta tabela para armazenar valores específicos de grupos de rótulos, permitindo classificação detalhada de produtos e serviços.

**Observação Importante:** GRUPOVALORES complementa GRUPOROTULOS, fornecendo valores específicos de cada grupo. Com 309 registros e chave primária composta, indica uso extensivo desta funcionalidade. Média de 8.83 valores por grupo de rótulos.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GRCODIGO** 🔑 🔗 | INTEGER | ✓ | Código do grupo de rótulos (PK + FK → GRUPOROTULOS) |
| **GRVALORES** 🔑 | VARCHAR(37) | ✓ | Valor do grupo (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GRORDEM** | SMALLINT | ✓ | Ordem de exibição do valor |

**Primary Key:** (GRCODIGO, GRVALORES)

**Foreign Keys:**
- `GRCODIGO` → `GRUPOROTULOS.GRCODIGO` (Constraint: GRUPOROTULOS_GRUPOVALORES)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPOVALORES Referencia (1 FK):

#### 1. GRUPOROTULOS - Grupos de Rótulos
**Relacionamento:**
```
GRUPOVALORES.GRCODIGO → GRUPOROTULOS.GRCODIGO (N:1)
Constraint: GRUPOROTULOS_GRUPOVALORES
```

**Descrição**: Cada valor está vinculado a um grupo de rótulos específico.

**Informações da Tabela GRUPOROTULOS:**
- **Total:** 35 grupos
- **PK:** GRCODIGO
- **Colunas:** 2 campos

**Uso:** Identificar o grupo de rótulos ao qual o valor pertence.

---

### GRUPOVALORES é Referenciada Por (0 tabelas):

Nenhuma tabela referencia GRUPOVALORES diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via GRUPOROTULOS → NGRUPOS, NGRUPOSSERVI → Outras Operações

**Fluxo:** GRUPOVALORES → GRUPOROTULOS → NGRUPOS/NGRUPOSSERVI → Operações

**Descrição:** Através do grupo de rótulos, é possível identificar grupos de produtos e serviços relacionados.

**Uso:** Análise de valores através de grupos de produtos e serviços.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Valor

**Objetivo:** Obter visão completa de um valor incluindo informações do grupo e grupos relacionados.

**Fluxo:**
```
GRUPOVALORES (GRCODIGO, GRVALORES)
  ↓
GRUPOROTULOS (GRCODIGO)
  ↓
NGRUPOS (GRCODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    gv.GRCODIGO,
    gr.GRNOME AS GRUPO_ROTULOS,
    gv.GRVALORES AS VALOR,
    gv.GRORDEM AS ORDEM,
    COUNT(DISTINCT ng.NGCODIGO) AS TOTAL_GRUPOS_PRODUTOS,
    COUNT(DISTINCT ngs.NGSCODIGO) AS TOTAL_GRUPOS_SERVICOS
FROM GRUPOVALORES gv
INNER JOIN GRUPOROTULOS gr ON gr.GRCODIGO = gv.GRCODIGO
LEFT JOIN NGRUPOS ng ON ng.GRCODIGO = gv.GRCODIGO
LEFT JOIN NGRUPOSSERVI ngs ON ngs.GRCODIGO = gv.GRCODIGO
WHERE gv.GRCODIGO = ?
  AND gv.GRVALORES = ?
GROUP BY gv.GRCODIGO, gr.GRNOME, gv.GRVALORES, gv.GRORDEM;
```

---

### Exemplo 2: Análise de Valores por Grupo

**Objetivo:** Identificar todos os valores de um grupo específico.

**Query SQL:**
```sql
SELECT
    GRVALORES AS VALOR,
    GRORDEM AS ORDEM
FROM GRUPOVALORES
WHERE GRCODIGO = ?
ORDER BY GRORDEM;
```

---

### Exemplo 3: Análise de Valores por Ordem

**Objetivo:** Identificar distribuição de valores por ordem de exibição.

**Query SQL:**
```sql
SELECT
    GRORDEM AS ORDEM,
    COUNT(*) AS TOTAL_VALORES,
    STRING_AGG(GRVALORES, ', ') AS VALORES
FROM GRUPOVALORES
GROUP BY GRORDEM
ORDER BY GRORDEM;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Valor

**Objetivo:** Obter informações de um valor específico.

```sql
SELECT
    GRCODIGO,
    GRVALORES AS VALOR,
    GRORDEM AS ORDEM
FROM GRUPOVALORES
WHERE GRCODIGO = ?
  AND GRVALORES = ?;
```

---

### 2. Listar Valores de um Grupo

**Objetivo:** Obter todos os valores de um grupo específico.

```sql
SELECT
    GRVALORES AS VALOR,
    GRORDEM AS ORDEM
FROM GRUPOVALORES
WHERE GRCODIGO = ?
ORDER BY GRORDEM;
```

---

### 3. Análise de Valores por Grupo

**Objetivo:** Identificar distribuição de valores por grupo.

**Query SQL:**
```sql
SELECT
    gr.GRCODIGO,
    gr.GRNOME AS GRUPO_ROTULOS,
    COUNT(gv.GRVALORES) AS TOTAL_VALORES
FROM GRUPOROTULOS gr
LEFT JOIN GRUPOVALORES gv ON gv.GRCODIGO = gr.GRCODIGO
GROUP BY gr.GRCODIGO, gr.GRNOME
ORDER BY TOTAL_VALORES DESC;
```

---

### 4. Relatório Completo de Valores

**Objetivo:** Analisar distribuição completa de valores no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_VALORES,
    COUNT(DISTINCT GRCODIGO) AS TOTAL_GRUPOS,
    AVG(GRORDEM) AS ORDEM_MEDIA,
    MIN(GRORDEM) AS MENOR_ORDEM,
    MAX(GRORDEM) AS MAIOR_ORDEM
FROM GRUPOVALORES;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPOVALORES | Tipo |
|--------|-----------|---------------------------|------|
| **GRUPOVALORES** | 309 | 1:1 | **TABELA PRINCIPAL** |
| GRUPOROTULOS | 35 | 1:8.83 | Grupos (média de 8.83 valores por grupo) |

**Interpretação:**
- **309 valores** cadastrados no sistema
- **Média de 8.83 valores por grupo** - indica uso extensivo de valores por grupo

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por grupo (consultas frequentes)
CREATE INDEX IDX_GRUPOVALORES_GRUPO ON GRUPOVALORES(GRCODIGO);

-- Índice 2: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRUPOVALORES_ORDEM ON GRUPOVALORES(GRCODIGO, GRORDEM);

-- Índice 3: Busca combinada grupo + valor (já coberto pela PK)
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

final class FirebirdGrupovalores extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPOVALORES';
    
    protected $primaryKey = ['GRCODIGO', 'GRVALORES'];
    public $incrementing = false;

    protected $casts = [
        'GRCODIGO' => 'integer',
        'GRVALORES' => 'string',
        'GRORDEM' => 'integer',
    ];

    // Relacionamento com GRUPOROTULOS
    public function grupoRotulos(): BelongsTo
    {
        return $this->belongsTo(FirebirdGruporotulos::class, 'GRCODIGO', 'GRCODIGO');
    }

    public function scopePorGrupo($query, int $grCodigo)
    {
        return $query->where('GRCODIGO', $grCodigo);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GRORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

