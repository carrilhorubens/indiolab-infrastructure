# MODELONF - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODELONF (Modelos de Nota Fiscal)
- **Total de Registros**: 30
- **Total de Colunas**: 5
- **Chave Primária**: MDMODELO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (MODELONFSER)
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODELONF** é uma tabela que armazena informações sobre modelos de nota fiscal. Com **30 registros**, representa modelos de nota fiscal cadastrados no sistema, incluindo informações sobre descrição, ordem, tipo de serviço e data corrente.

Esta tabela funciona como **mestre de modelos de nota fiscal** e permite:
- Registrar todos os modelos de nota fiscal disponíveis
- Armazenar informações sobre descrição e ordem
- Identificar tipo de serviço e data corrente
- Vincular modelos a séries por empresa
- Facilitar gestão de modelos de nota fiscal
- Manter histórico detalhado de modelos

Cada registro representa um modelo específico de nota fiscal, contendo:
- Código do modelo (MDMODELO)
- Descrição do modelo (MDDESCRICAO)
- Ordem do modelo (MDORDEM)
- Indicador de serviço (MDSERVICO)
- Indicador de data corrente (MDDTCORRENTE)

O sistema utiliza esta tabela para manter histórico completo de modelos de nota fiscal, sendo referenciada por MODELONFSER para vincular séries de nota fiscal por empresa a modelos específicos.

**Observação Importante:** MODELONF é uma tabela mestre de modelos de nota fiscal. Com 30 registros, indica uso moderado desta funcionalidade. Não possui foreign keys diretas, mas é referenciada por MODELONFSER, indicando sua importância no sistema de gestão de notas fiscais.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDMODELO** 🔑 | VARCHAR(14) | ✓ | Código do modelo de nota fiscal (PK) |

### Informações do Modelo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDDESCRICAO** | VARCHAR(37) | | Descrição do modelo |
| **MDORDEM** | INTEGER | ✓ | Ordem de exibição do modelo |
| **MDSERVICO** | VARCHAR(14) | | Indicador de serviço |
| **MDDTCORRENTE** | VARCHAR(14) | | Indicador de data corrente |

**Primary Key:** MDMODELO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODELONF Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MODELONF é Referenciada Por (1 tabela):

#### 1. MODELONFSER - Séries de Nota Fiscal por Empresa
**Relacionamento:**
```
MODELONFSER.MDMODELO → MODELONF.MDMODELO (N:1)
Constraint: FK_MODELONFSER_1
```

**Descrição**: Cada série de nota fiscal por empresa está vinculada a um modelo específico.

**Informações da Tabela MODELONFSER:**
- **Total:** 210 séries
- **PK:** MDMODELO, EMPCODIGO (composta)
- **Colunas:** 6 campos

**Uso:** Vincular séries de nota fiscal por empresa a modelos específicos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via MODELONFSER → EMPRESA

**Fluxo:** MODELONF → MODELONFSER → EMPRESA → Operações

**Descrição:** Através das séries de nota fiscal, é possível identificar empresas relacionadas.

**Uso:** Análise de modelos através de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Modelo de Nota Fiscal

**Objetivo:** Obter informações de um modelo específico.

```sql
SELECT
    MDMODELO,
    MDDESCRICAO,
    MDORDEM,
    MDSERVICO,
    MDDTCORRENTE
FROM MODELONF
WHERE MDMODELO = ?;
```

---

### 2. Listar Séries de um Modelo

**Objetivo:** Obter todas as séries vinculadas a um modelo específico.

```sql
SELECT
    ms.EMPCODIGO,
    ms.MDSSERIE,
    ms.MDSTIPO,
    ms.MDSSERIEPROPRIA,
    ms.MDPROXIMASERIE
FROM MODELONF m
INNER JOIN MODELONFSER ms ON ms.MDMODELO = m.MDMODELO
WHERE m.MDMODELO = ?
ORDER BY ms.EMPCODIGO, ms.MDSSERIE;
```

---

### 3. Análise de Modelos por Tipo

**Objetivo:** Identificar distribuição de modelos por tipo de serviço.

**Query SQL:**
```sql
SELECT
    MDSERVICO,
    COUNT(*) AS TOTAL_MODELOS,
    COUNT(MDDTCORRENTE) AS TOTAL_COM_DATA_CORRENTE
FROM MODELONF
WHERE MDSERVICO IS NOT NULL
GROUP BY MDSERVICO
ORDER BY TOTAL_MODELOS DESC;
```

---

### 4. Buscar Modelos Ordenados

**Objetivo:** Obter modelos ordenados por ordem de exibição.

```sql
SELECT
    MDMODELO,
    MDDESCRICAO,
    MDSERVICO
FROM MODELONF
WHERE MDORDEM IS NOT NULL
ORDER BY MDORDEM, MDDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODELONF | Tipo |
|--------|-----------|---------------------|------|
| **MODELONF** | 30 | 1:1 | **TABELA PRINCIPAL** |
| MODELONFSER | 210 | 1:7 | Séries (média de 7 séries por modelo) |

**Interpretação:**
- **30 modelos** de nota fiscal registrados no sistema
- **Média de 7 séries por modelo** - indica uso extensivo de séries por modelo

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_MODELONF_ORDEM ON MODELONF(MDORDEM)
    WHERE MDORDEM IS NOT NULL;

-- Índice 2: Busca por tipo de serviço (consultas frequentes)
CREATE INDEX IDX_MODELONF_SERVICO ON MODELONF(MDSERVICO)
    WHERE MDSERVICO IS NOT NULL;
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

final class FirebirdModelonf extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODELONF';
    
    protected $primaryKey = 'MDMODELO';
    public $incrementing = false;

    protected $casts = [
        'MDMODELO' => 'string',
        'MDDESCRICAO' => 'string',
        'MDORDEM' => 'integer',
        'MDSERVICO' => 'string',
        'MDDTCORRENTE' => 'string',
    ];

    // Relacionamento com MODELONFSER
    public function seriesPorEmpresa(): HasMany
    {
        return $this->hasMany(FirebirdModelonfser::class, 'MDMODELO', 'MDMODELO');
    }

    public function scopePorTipoServico($query, string $tipoServico)
    {
        return $query->where('MDSERVICO', $tipoServico);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MDORDEM')->orderBy('MDDESCRICAO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

