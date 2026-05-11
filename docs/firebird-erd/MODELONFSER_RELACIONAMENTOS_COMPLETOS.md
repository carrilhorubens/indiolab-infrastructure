# MODELONFSER - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODELONFSER (Séries de Nota Fiscal por Empresa)
- **Total de Registros**: 210
- **Total de Colunas**: 6
- **Chave Primária**: MDMODELO, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 1 (MODELONF)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODELONFSER** é uma tabela que armazena informações sobre séries de nota fiscal por empresa e modelo. Com **210 registros**, representa séries de nota fiscal configuradas para empresas específicas, incluindo informações sobre série, tipo, série própria e próxima série.

Esta tabela funciona como **configuração de séries de nota fiscal** e permite:
- Registrar séries de nota fiscal por empresa e modelo
- Armazenar informações sobre série, tipo e série própria
- Controlar próxima série a ser utilizada
- Vincular séries a modelos de nota fiscal
- Facilitar gestão de séries de nota fiscal
- Manter histórico detalhado de séries

Cada registro representa uma série específica de nota fiscal para uma empresa e modelo, contendo:
- Código do modelo (MDMODELO)
- Código da empresa (EMPCODIGO)
- Série da nota fiscal (MDSSERIE)
- Tipo da série (MDSTIPO)
- Série própria (MDSSERIEPROPRIA)
- Próxima série (MDPROXIMASERIE)

O sistema utiliza esta tabela para manter histórico completo de séries de nota fiscal por empresa e modelo, sendo referenciada por MODELONF através de MDMODELO para vincular séries a modelos específicos.

**Observação Importante:** MODELONFSER é uma tabela de configuração de séries de nota fiscal por empresa e modelo. Com 210 registros, indica uso moderado desta funcionalidade. Possui chave primária composta (MDMODELO, EMPCODIGO) e referencia MODELONF, indicando sua função de configuração por empresa.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDMODELO** 🔑 🔗 | VARCHAR(14) | ✓ | Código do modelo de nota fiscal (PK, FK) |
| **EMPCODIGO** 🔑 | INTEGER | ✓ | Código da empresa (PK) |

### Informações da Série
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDSSERIE** | VARCHAR(37) | | Série da nota fiscal |
| **MDSTIPO** | VARCHAR(14) | ✓ | Tipo da série |
| **MDSSERIEPROPRIA** | VARCHAR(37) | | Série própria |
| **MDPROXIMASERIE** | VARCHAR(37) | | Próxima série a ser utilizada |

**Primary Key:** MDMODELO, EMPCODIGO (composta)

**Foreign Keys:**
- `FK_MODELONFSER_1`: MDMODELO → MODELONF.MDMODELO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODELONFSER Referencia (1 tabela):

#### 1. MODELONF - Modelos de Nota Fiscal
**Relacionamento:**
```
MODELONFSER.MDMODELO → MODELONF.MDMODELO (N:1)
Constraint: FK_MODELONFSER_1
```

**Descrição**: Cada série está vinculada a um modelo de nota fiscal específico.

**Informações da Tabela MODELONF:**
- **Total:** 30 modelos
- **PK:** MDMODELO
- **Colunas:** 5 campos

**Uso:** Vincular séries a modelos de nota fiscal.

---

### MODELONFSER é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MODELONFSER diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via EMPCODIGO → EMPRESA

**Fluxo:** MODELONFSER → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de séries através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Série de Nota Fiscal

**Objetivo:** Obter informações de uma série específica.

```sql
SELECT
    ms.MDMODELO,
    ms.EMPCODIGO,
    ms.MDSSERIE,
    ms.MDSTIPO,
    ms.MDSSERIEPROPRIA,
    ms.MDPROXIMASERIE,
    m.MDDESCRICAO AS MODELO_DESCRICAO
FROM MODELONFSER ms
INNER JOIN MODELONF m ON m.MDMODELO = ms.MDMODELO
WHERE ms.MDMODELO = ? AND ms.EMPCODIGO = ?;
```

---

### 2. Listar Séries de uma Empresa

**Objetivo:** Obter todas as séries de uma empresa específica.

```sql
SELECT
    ms.MDMODELO,
    ms.MDSSERIE,
    ms.MDSTIPO,
    ms.MDSSERIEPROPRIA,
    ms.MDPROXIMASERIE,
    m.MDDESCRICAO AS MODELO_DESCRICAO
FROM MODELONFSER ms
INNER JOIN MODELONF m ON m.MDMODELO = ms.MDMODELO
WHERE ms.EMPCODIGO = ?
ORDER BY ms.MDMODELO, ms.MDSSERIE;
```

---

### 3. Análise de Séries por Tipo

**Objetivo:** Identificar distribuição de séries por tipo.

**Query SQL:**
```sql
SELECT
    MDSTIPO,
    COUNT(*) AS TOTAL_SERIES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS_AFETADAS
FROM MODELONFSER
WHERE MDSTIPO IS NOT NULL
GROUP BY MDSTIPO
ORDER BY TOTAL_SERIES DESC;
```

---

### 4. Buscar Próxima Série

**Objetivo:** Obter próxima série a ser utilizada para um modelo e empresa.

```sql
SELECT
    MDPROXIMASERIE AS PROXIMA_SERIE
FROM MODELONFSER
WHERE MDMODELO = ? AND EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODELONFSER | Tipo |
|--------|-----------|-------------------------|------|
| **MODELONFSER** | 210 | 1:1 | **TABELA PRINCIPAL** |
| MODELONF | 30 | 1:7 | Modelos (média de 7 séries por modelo) |

**Interpretação:**
- **210 séries** de nota fiscal registradas no sistema
- **Média de 7 séries por modelo** - indica uso extensivo de séries por modelo

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MODELONFSER_EMPRESA ON MODELONFSER(EMPCODIGO);

-- Índice 2: Busca por modelo (consultas frequentes)
CREATE INDEX IDX_MODELONFSER_MODELO ON MODELONFSER(MDMODELO);

-- Índice 3: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_MODELONFSER_TIPO ON MODELONFSER(MDSTIPO)
    WHERE MDSTIPO IS NOT NULL;
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

final class FirebirdModelonfser extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODELONFSER';
    
    protected $primaryKey = ['MDMODELO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'MDMODELO' => 'string',
        'EMPCODIGO' => 'integer',
        'MDSSERIE' => 'string',
        'MDSTIPO' => 'string',
        'MDSSERIEPROPRIA' => 'string',
        'MDPROXIMASERIE' => 'string',
    ];

    // Relacionamento com MODELONF
    public function modeloNf(): BelongsTo
    {
        return $this->belongsTo(FirebirdModelonf::class, 'MDMODELO', 'MDMODELO');
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorModelo($query, string $mdModelo)
    {
        return $query->where('MDMODELO', $mdModelo);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('MDSTIPO', $tipo);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MDMODELO')->orderBy('MDSSERIE');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

