# GRUPOROTULOS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPOROTULOS (Grupo de Rótulos)
- **Total de Registros**: 35
- **Total de Colunas**: 2
- **Chave Primária**: GRCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 3 (GRUPOVALORES, NGRUPOS, NGRUPOSSERVI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPOROTULOS** é uma tabela mestre que armazena grupos de rótulos utilizados para categorização e organização de produtos e serviços. Com **35 registros**, representa diferentes grupos de rótulos que permitem classificação e agrupamento de produtos e serviços através de valores específicos.

Esta tabela funciona como **catálogo de grupos de rótulos** e permite:
- Categorizar produtos e serviços em grupos de rótulos
- Organizar valores específicos por grupo
- Facilitar classificação e busca de produtos
- Suportar agrupamento de produtos e serviços
- Manter estrutura hierárquica de rótulos
- Facilitar gestão de categorias de produtos

Cada registro representa um grupo de rótulos específico, contendo:
- Código do grupo (GRCODIGO)
- Nome do grupo (GRNOME)

O sistema utiliza esta tabela para organizar produtos e serviços em grupos de rótulos, sendo referenciada por GRUPOVALORES (valores do grupo), NGRUPOS (grupos de produtos) e NGRUPOSSERVI (grupos de serviços).

**Observação Importante:** GRUPOROTULOS é uma tabela mestre de grupos de rótulos. Com 35 registros, indica uso moderado desta funcionalidade. É referenciada por GRUPOVALORES (valores), NGRUPOS (produtos) e NGRUPOSSERVI (serviços) para formar uma estrutura completa de categorização.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GRCODIGO** 🔑 | INTEGER | ✓ | Código do grupo de rótulos (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GRNOME** | VARCHAR(37) | ✓ | Nome do grupo de rótulos |

**Primary Key:** GRCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPOROTULOS Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPOROTULOS é Referenciada Por (3 tabelas):

#### 1. GRUPOVALORES - Valores do Grupo
**Relacionamento:**
```
GRUPOVALORES.GRCODIGO → GRUPOROTULOS.GRCODIGO (N:1)
Constraint: GRUPOROTULOS_GRUPOVALORES
```

**Descrição**: Cada grupo de rótulos pode ter múltiplos valores associados.

**Informações da Tabela GRUPOVALORES:**
- **Total:** 309 valores
- **PK:** (GRCODIGO, GRVALORES)
- **Colunas:** 3 campos

**Uso:** Armazenar valores específicos de cada grupo de rótulos.

---

#### 2. NGRUPOS - Grupos de Produtos
**Relacionamento:**
```
NGRUPOS.GRCODIGO → GRUPOROTULOS.GRCODIGO (N:1)
Constraint: GRUPOROTULOS_NGRUPOS
```

**Descrição**: Cada grupo de produtos pode estar vinculado a um grupo de rótulos específico.

**Uso:** Vincular grupos de produtos a grupos de rótulos.

---

#### 3. NGRUPOSSERVI - Grupos de Serviços
**Relacionamento:**
```
NGRUPOSSERVI.GRCODIGO → GRUPOROTULOS.GRCODIGO (N:1)
Constraint: FK_NGRUPOSSERVI_1
```

**Descrição**: Cada grupo de serviços pode estar vinculado a um grupo de rótulos específico.

**Uso:** Vincular grupos de serviços a grupos de rótulos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via GRUPOVALORES → Outras Operações

**Fluxo:** GRUPOROTULOS → GRUPOVALORES → Operações

**Descrição:** Através dos valores do grupo, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos de rótulos através de valores.

---

### Via NGRUPOS → PRODU → Outras Operações de Produtos

**Fluxo:** GRUPOROTULOS → NGRUPOS → PRODU → Operações

**Descrição:** Através dos grupos de produtos, é possível identificar produtos relacionados.

**Uso:** Análise de grupos de rótulos através de produtos.

---

### Via NGRUPOSSERVI → SERVI → Outras Operações de Serviços

**Fluxo:** GRUPOROTULOS → NGRUPOSSERVI → SERVI → Operações

**Descrição:** Através dos grupos de serviços, é possível identificar serviços relacionados.

**Uso:** Análise de grupos de rótulos através de serviços.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo de Rótulos

**Objetivo:** Obter visão completa de um grupo de rótulos incluindo valores, produtos e serviços.

**Fluxo:**
```
GRUPOROTULOS (GRCODIGO)
  ↓
GRUPOVALORES (GRCODIGO)
  ↓
NGRUPOS (GRCODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    gr.GRCODIGO,
    gr.GRNOME AS GRUPO_ROTULOS,
    COUNT(DISTINCT gv.GRVALORES) AS TOTAL_VALORES,
    COUNT(DISTINCT ng.NGCODIGO) AS TOTAL_GRUPOS_PRODUTOS,
    COUNT(DISTINCT ngs.NGSCODIGO) AS TOTAL_GRUPOS_SERVICOS
FROM GRUPOROTULOS gr
LEFT JOIN GRUPOVALORES gv ON gv.GRCODIGO = gr.GRCODIGO
LEFT JOIN NGRUPOS ng ON ng.GRCODIGO = gr.GRCODIGO
LEFT JOIN NGRUPOSSERVI ngs ON ngs.GRCODIGO = gr.GRCODIGO
WHERE gr.GRCODIGO = ?
GROUP BY gr.GRCODIGO, gr.GRNOME;
```

---

### Exemplo 2: Análise de Grupos com Valores

**Objetivo:** Identificar grupos que possuem valores associados.

**Query SQL:**
```sql
SELECT
    gr.GRCODIGO,
    gr.GRNOME AS GRUPO_ROTULOS,
    COUNT(gv.GRVALORES) AS TOTAL_VALORES
FROM GRUPOROTULOS gr
LEFT JOIN GRUPOVALORES gv ON gv.GRCODIGO = gr.GRCODIGO
GROUP BY gr.GRCODIGO, gr.GRNOME
HAVING COUNT(gv.GRVALORES) > 0
ORDER BY TOTAL_VALORES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Rótulos

**Objetivo:** Obter informações de um grupo de rótulos específico.

```sql
SELECT
    GRCODIGO,
    GRNOME AS GRUPO_ROTULOS
FROM GRUPOROTULOS
WHERE GRCODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Rótulos

**Objetivo:** Obter catálogo completo de grupos de rótulos.

```sql
SELECT
    GRCODIGO,
    GRNOME AS GRUPO_ROTULOS
FROM GRUPOROTULOS
ORDER BY GRNOME;
```

---

### 3. Análise de Grupos com Valores

**Objetivo:** Identificar grupos e seus valores associados.

**Query SQL:**
```sql
SELECT
    gr.GRCODIGO,
    gr.GRNOME AS GRUPO_ROTULOS,
    gv.GRVALORES AS VALOR,
    gv.GRORDEM AS ORDEM
FROM GRUPOROTULOS gr
LEFT JOIN GRUPOVALORES gv ON gv.GRCODIGO = gr.GRCODIGO
WHERE gr.GRCODIGO = ?
ORDER BY gv.GRORDEM;
```

---

### 4. Relatório Completo de Grupos de Rótulos

**Objetivo:** Analisar distribuição completa de grupos de rótulos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    (SELECT COUNT(*) FROM GRUPOVALORES) AS TOTAL_VALORES,
    (SELECT COUNT(*) FROM NGRUPOS WHERE GRCODIGO IS NOT NULL) AS TOTAL_GRUPOS_PRODUTOS,
    (SELECT COUNT(*) FROM NGRUPOSSERVI WHERE GRCODIGO IS NOT NULL) AS TOTAL_GRUPOS_SERVICOS
FROM GRUPOROTULOS;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPOROTULOS | Tipo |
|--------|-----------|---------------------------|------|
| **GRUPOROTULOS** | 35 | 1:1 | **TABELA PRINCIPAL** |
| GRUPOVALORES | 309 | 1:8.83 | Valores (média de 8.83 valores por grupo) |
| NGRUPOS | Informação não disponível | - | Grupos de produtos |
| NGRUPOSSERVI | Informação não disponível | - | Grupos de serviços |

**Interpretação:**
- **35 grupos de rótulos** cadastrados no sistema
- **Média de 8.83 valores por grupo** - indica uso extensivo de valores por grupo

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (consultas frequentes)
CREATE INDEX IDX_GRUPOROTULOS_NOME ON GRUPOROTULOS(GRNOME)
    WHERE GRNOME IS NOT NULL;
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

final class FirebirdGruporotulos extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPOROTULOS';
    
    protected $primaryKey = 'GRCODIGO';
    public $incrementing = true;

    protected $casts = [
        'GRCODIGO' => 'integer',
        'GRNOME' => 'string',
    ];

    // Relacionamento com GRUPOVALORES
    public function valores(): HasMany
    {
        return $this->hasMany(FirebirdGrupovalores::class, 'GRCODIGO', 'GRCODIGO');
    }

    // Relacionamento com NGRUPOS
    public function gruposProdutos(): HasMany
    {
        return $this->hasMany(FirebirdNgrupos::class, 'GRCODIGO', 'GRCODIGO');
    }

    // Relacionamento com NGRUPOSSERVI
    public function gruposServicos(): HasMany
    {
        return $this->hasMany(FirebirdNgrupusservi::class, 'GRCODIGO', 'GRCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

