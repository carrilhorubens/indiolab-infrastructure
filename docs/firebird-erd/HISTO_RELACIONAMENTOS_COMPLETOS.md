# HISTO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: HISTO (Histórico)
- **Total de Registros**: 20
- **Total de Colunas**: 2
- **Chave Primária**: HISCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (CCORR)
- **Banco de Dados**: Firebird

## 📝 Descrição

**HISTO** é uma tabela mestre que armazena tipos de histórico utilizados para categorização e controle de lançamentos contábeis. Com **20 registros**, representa diferentes tipos de histórico que permitem classificação e rastreamento de lançamentos contábeis.

Esta tabela funciona como **catálogo de tipos de histórico** e permite:
- Categorizar lançamentos contábeis por tipo de histórico
- Facilitar rastreamento e controle de operações financeiras
- Suportar classificação de lançamentos contábeis
- Facilitar gestão de histórico contábil
- Suportar controle financeiro detalhado

Cada registro representa um tipo de histórico específico, contendo:
- Código do histórico (HISCODIGO)
- Descrição do histórico (HISDESCRICAO)

O sistema utiliza esta tabela para organizar lançamentos contábeis por tipo de histórico, sendo referenciada por CCORR (lançamentos contábeis) para vincular lançamentos a tipos de histórico específicos.

**Observação Importante:** HISTO é uma tabela mestre de tipos de histórico. Com 20 registros, indica uso moderado desta funcionalidade para controle contábil. É referenciada por CCORR (208.120 lançamentos) para classificação de lançamentos contábeis.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISCODIGO** 🔑 | SMALLINT | ✓ | Código do histórico (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISDESCRICAO** | VARCHAR(37) | ✓ | Descrição do histórico |

**Primary Key:** HISCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### HISTO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### HISTO é Referenciada Por (1 tabela):

#### 1. CCORR - Lançamentos Contábeis
**Relacionamento:**
```
CCORR.HISCODIGO → HISTO.HISCODIGO (N:1)
Constraint: HISTO_CCORR
```

**Descrição**: Cada lançamento contábil pode estar vinculado a um tipo de histórico específico.

**Informações da Tabela CCORR:**
- **Total:** 208.120 lançamentos
- **PK:** (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
- **Colunas:** 36 campos

**Uso:** Vincular lançamentos contábeis a tipos de histórico para rastreamento e controle.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CCORR → Outras Operações Contábeis

**Fluxo:** HISTO → CCORR → Operações

**Descrição:** Através dos lançamentos contábeis, é possível identificar outras operações relacionadas.

**Uso:** Análise de históricos através de operações contábeis.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Histórico

**Objetivo:** Obter visão completa de um histórico incluindo lançamentos contábeis relacionados.

**Fluxo:**
```
HISTO (HISCODIGO)
  ↓
CCORR (HISCODIGO)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    h.HISCODIGO,
    h.HISDESCRICAO AS HISTORICO,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL,
    COUNT(DISTINCT cco.BCOCODIGO) AS TOTAL_BANCOS,
    COUNT(DISTINCT cco.EMPCCORR) AS TOTAL_EMPRESAS
FROM HISTO h
LEFT JOIN CCORR cco ON cco.HISCODIGO = h.HISCODIGO
WHERE h.HISCODIGO = ?
GROUP BY h.HISCODIGO, h.HISDESCRICAO;
```

---

### Exemplo 2: Análise de Históricos com Lançamentos

**Objetivo:** Identificar históricos que possuem lançamentos contábeis vinculados.

**Query SQL:**
```sql
SELECT
    h.HISCODIGO,
    h.HISDESCRICAO AS HISTORICO,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL
FROM HISTO h
LEFT JOIN CCORR cco ON cco.HISCODIGO = h.HISCODIGO
GROUP BY h.HISCODIGO, h.HISDESCRICAO
HAVING COUNT(cco.CCONRLANCTO) > 0
ORDER BY TOTAL_LANCAMENTOS DESC;
```

---

### Exemplo 3: Análise de Históricos por Valor

**Objetivo:** Identificar distribuição de valores por histórico.

**Query SQL:**
```sql
SELECT
    h.HISCODIGO,
    h.HISDESCRICAO AS HISTORICO,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL,
    AVG(cco.CCOVALOR) AS VALOR_MEDIO,
    MIN(cco.CCOVALOR) AS VALOR_MINIMO,
    MAX(cco.CCOVALOR) AS VALOR_MAXIMO
FROM HISTO h
LEFT JOIN CCORR cco ON cco.HISCODIGO = h.HISCODIGO
GROUP BY h.HISCODIGO, h.HISDESCRICAO
ORDER BY VALOR_TOTAL DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Histórico

**Objetivo:** Obter informações de um histórico específico.

```sql
SELECT
    HISCODIGO,
    HISDESCRICAO AS HISTORICO
FROM HISTO
WHERE HISCODIGO = ?;
```

---

### 2. Listar Todos os Históricos

**Objetivo:** Obter catálogo completo de históricos.

```sql
SELECT
    HISCODIGO,
    HISDESCRICAO AS HISTORICO
FROM HISTO
ORDER BY HISDESCRICAO;
```

---

### 3. Análise de Históricos com Lançamentos

**Objetivo:** Identificar históricos e seus lançamentos relacionados.

**Query SQL:**
```sql
SELECT
    h.HISCODIGO,
    h.HISDESCRICAO AS HISTORICO,
    COUNT(cco.CCONRLANCTO) AS TOTAL_LANCAMENTOS,
    SUM(cco.CCOVALOR) AS VALOR_TOTAL
FROM HISTO h
LEFT JOIN CCORR cco ON cco.HISCODIGO = h.HISCODIGO
GROUP BY h.HISCODIGO, h.HISDESCRICAO
ORDER BY TOTAL_LANCAMENTOS DESC;
```

---

### 4. Relatório Completo de Históricos

**Objetivo:** Analisar distribuição completa de históricos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_HISTORICOS,
    (SELECT COUNT(*) FROM CCORR WHERE HISCODIGO IS NOT NULL) AS TOTAL_LANCAMENTOS_VINCULADOS,
    (SELECT COUNT(DISTINCT HISCODIGO) FROM CCORR WHERE HISCODIGO IS NOT NULL) AS TOTAL_HISTORICOS_UTILIZADOS
FROM HISTO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com HISTO | Tipo |
|--------|-----------|-------------------|------|
| **HISTO** | 20 | 1:1 | **TABELA PRINCIPAL** |
| CCORR | 208.120 | 1:10406 | Lançamentos (média de 10406 lançamentos por histórico) |

**Interpretação:**
- **20 tipos de histórico** cadastrados no sistema
- **Média de 10406 lançamentos por histórico** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_HISTO_DESCRICAO ON HISTO(HISDESCRICAO)
    WHERE HISDESCRICAO IS NOT NULL;
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

final class FirebirdHisto extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'HISTO';
    
    protected $primaryKey = 'HISCODIGO';
    public $incrementing = true;

    protected $casts = [
        'HISCODIGO' => 'integer',
        'HISDESCRICAO' => 'string',
    ];

    // Relacionamento com CCORR
    public function lancamentosContabeis(): HasMany
    {
        return $this->hasMany(FirebirdCcorr::class, 'HISCODIGO', 'HISCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

