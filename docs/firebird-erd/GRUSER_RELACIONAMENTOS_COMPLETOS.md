# GRUSER - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUSER (Grupo de Serviços)
- **Total de Registros**: 2
- **Total de Colunas**: 2
- **Chave Primária**: GSCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (SERVI, TBSGRUPO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUSER** é uma tabela mestre que armazena grupos de serviços utilizados para categorização e organização de serviços. Com apenas **2 registros**, representa diferentes grupos de serviços que permitem classificação e agrupamento de serviços.

Esta tabela funciona como **catálogo de grupos de serviços** e permite:
- Categorizar serviços em grupos específicos
- Facilitar organização e busca de serviços por grupo
- Suportar classificação hierárquica de serviços
- Vincular grupos a tabelas de preço de serviços
- Facilitar gestão de catálogo de serviços

Cada registro representa um grupo de serviços específico, contendo:
- Código do grupo (GSCODIGO)
- Nome do grupo (GSNOME)

O sistema utiliza esta tabela para organizar serviços em grupos, sendo referenciada por SERVI (serviços) e TBSGRUPO (grupos de tabela de preço de serviços).

**Observação Importante:** GRUSER é uma tabela mestre de grupos de serviços. Com apenas 2 registros, indica uso limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário. É complementada por GRUSER2 para formar uma estrutura hierárquica de categorização de serviços.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GSCODIGO** 🔑 | SMALLINT | ✓ | Código do grupo de serviços (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GSNOME** | VARCHAR(37) | ✓ | Nome do grupo de serviços |

**Primary Key:** GSCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUSER Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUSER é Referenciada Por (2 tabelas):

#### 1. SERVI - Serviços
**Relacionamento:**
```
SERVI.GSCODIGO → GRUSER.GSCODIGO (N:1)
Constraint: GRUSER_SERVI
```

**Descrição**: Cada serviço pode estar vinculado a um grupo de serviços específico.

**Informações da Tabela SERVI:**
- **Total:** 13 serviços
- **PK:** SERCODIGO
- **Colunas:** 51 campos

**Uso:** Vincular serviços a grupos de serviços para organização e classificação.

---

#### 2. TBSGRUPO - Grupos de Tabela de Preço de Serviços
**Relacionamento:**
```
TBSGRUPO.TBSGSCODIGO → GRUSER.GSCODIGO (N:1)
Constraint: GSGRUPO_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preço de serviços pode estar vinculado a um grupo de serviços específico.

**Informações da Tabela TBSGRUPO:**
- **Total:** 0 registros
- **PK:** (TBSCODIGO, TBSSEQ)
- **Colunas:** 5 campos

**Uso:** Vincular grupos de tabela de preço de serviços a grupos de serviços.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via SERVI → Outras Operações de Serviços

**Fluxo:** GRUSER → SERVI → Operações

**Descrição:** Através dos serviços, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos de serviços através de operações de serviços.

---

### Via TBSGRUPO → TABPRECO → Outras Operações de Preço

**Fluxo:** GRUSER → TBSGRUPO → TABPRECO → Operações

**Descrição:** Através dos grupos de tabela de preço, é possível identificar tabelas de preço relacionadas.

**Uso:** Análise de grupos de serviços através de tabelas de preço.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo de Serviços

**Objetivo:** Obter visão completa de um grupo de serviços incluindo serviços e tabelas de preço relacionadas.

**Fluxo:**
```
GRUSER (GSCODIGO)
  ↓
SERVI (GSCODIGO)
  ↓
TBSGRUPO (TBSGSCODIGO)
  ↓
TABPRECO (TBSCODIGO)
```

**Query SQL:**
```sql
SELECT
    gs.GSCODIGO,
    gs.GSNOME AS GRUPO_SERVICOS,
    COUNT(DISTINCT s.SERCODIGO) AS TOTAL_SERVICOS,
    COUNT(DISTINCT tbs.TBSCODIGO) AS TOTAL_TABELAS_PRECO
FROM GRUSER gs
LEFT JOIN SERVI s ON s.GSCODIGO = gs.GSCODIGO
LEFT JOIN TBSGRUPO tbs ON tbs.TBSGSCODIGO = gs.GSCODIGO
WHERE gs.GSCODIGO = ?
GROUP BY gs.GSCODIGO, gs.GSNOME;
```

---

### Exemplo 2: Análise de Grupos com Serviços

**Objetivo:** Identificar grupos que possuem serviços vinculados.

**Query SQL:**
```sql
SELECT
    gs.GSCODIGO,
    gs.GSNOME AS GRUPO_SERVICOS,
    COUNT(s.SERCODIGO) AS TOTAL_SERVICOS
FROM GRUSER gs
LEFT JOIN SERVI s ON s.GSCODIGO = gs.GSCODIGO
GROUP BY gs.GSCODIGO, gs.GSNOME
HAVING COUNT(s.SERCODIGO) > 0
ORDER BY TOTAL_SERVICOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Serviços

**Objetivo:** Obter informações de um grupo de serviços específico.

```sql
SELECT
    GSCODIGO,
    GSNOME AS GRUPO_SERVICOS
FROM GRUSER
WHERE GSCODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Serviços

**Objetivo:** Obter catálogo completo de grupos de serviços.

```sql
SELECT
    GSCODIGO,
    GSNOME AS GRUPO_SERVICOS
FROM GRUSER
ORDER BY GSNOME;
```

---

### 3. Análise de Grupos com Serviços

**Objetivo:** Identificar grupos e seus serviços relacionados.

**Query SQL:**
```sql
SELECT
    gs.GSCODIGO,
    gs.GSNOME AS GRUPO_SERVICOS,
    s.SERCODIGO,
    s.SERDESCRICAO AS SERVICO
FROM GRUSER gs
LEFT JOIN SERVI s ON s.GSCODIGO = gs.GSCODIGO
ORDER BY gs.GSNOME, s.SERDESCRICAO;
```

---

### 4. Relatório Completo de Grupos de Serviços

**Objetivo:** Analisar distribuição completa de grupos de serviços no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    (SELECT COUNT(*) FROM SERVI WHERE GSCODIGO IS NOT NULL) AS TOTAL_SERVICOS_VINCULADOS,
    (SELECT COUNT(*) FROM TBSGRUPO WHERE TBSGSCODIGO IS NOT NULL) AS TOTAL_TABELAS_PRECO_VINCULADAS
FROM GRUSER;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUSER | Tipo |
|--------|-----------|---------------------|------|
| **GRUSER** | 2 | 1:1 | **TABELA PRINCIPAL** |
| SERVI | 13 | 1:6.5 | Serviços (média de 6.5 serviços por grupo) |
| TBSGRUPO | 0 | - | Grupos de tabela de preço |

**Interpretação:**
- **2 grupos de serviços** cadastrados no sistema
- **Média de 6.5 serviços por grupo** - indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (consultas frequentes)
CREATE INDEX IDX_GRUSER_NOME ON GRUSER(GSNOME)
    WHERE GSNOME IS NOT NULL;
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

final class FirebirdGruser extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUSER';
    
    protected $primaryKey = 'GSCODIGO';
    public $incrementing = true;

    protected $casts = [
        'GSCODIGO' => 'integer',
        'GSNOME' => 'string',
    ];

    // Relacionamento com SERVI
    public function servicos(): HasMany
    {
        return $this->hasMany(FirebirdServi::class, 'GSCODIGO', 'GSCODIGO');
    }

    // Relacionamento com TBSGRUPO
    public function gruposTabelaPreco(): HasMany
    {
        return $this->hasMany(FirebirdTbsgrupo::class, 'TBSGSCODIGO', 'GSCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

