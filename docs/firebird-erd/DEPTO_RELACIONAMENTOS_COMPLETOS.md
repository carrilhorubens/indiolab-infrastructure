# DEPTO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DEPTO (Departamentos)
- **Total de Registros**: 16
- **Total de Colunas**: 4
- **Chave Primária**: DPTCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 5 (ALMOX, DPTPO, FUNCIO, OCORRFP, SOLICITACAO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**DEPTO** é uma tabela mestre que armazena departamentos da empresa. Com **16 registros**, representa a estrutura organizacional da empresa, permitindo organização hierárquica de funcionários, células de produção, solicitações e ocorrências.

Esta tabela funciona como **catálogo de departamentos** e permite:
- Identificar departamentos da empresa
- Organizar funcionários por departamento
- Associar células de produção a departamentos
- Controlar solicitações e ocorrências por departamento
- Configurar gerente/responsável do departamento
- Controlar percentual de funcionários por departamento

Cada registro representa um departamento específico, contendo:
- Código do departamento (DPTCODIGO)
- Nome do departamento (DPTNOME)
- Código do funcionário responsável (FUNCODIGO) - lógica → FUNCIO
- Percentual de funcionários (DPTPERFUN)

O sistema utiliza esta tabela para organizar a estrutura da empresa, permitindo que funcionários, células, solicitações e ocorrências sejam associados a departamentos específicos.

**Observação Importante:** DEPTO é uma tabela mestre pequena (16 registros) que serve como base para organização hierárquica da empresa. É referenciada por 5 tabelas dependentes, indicando uso extensivo desta funcionalidade.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DPTCODIGO** 🔑 | SMALLINT | ✓ | Código do departamento (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DPTNOME** | VARCHAR(37) | ✓ | Nome do departamento |
| **FUNCODIGO** | INTEGER | | Código do funcionário responsável (lógica → FUNCIO) |
| **DPTPERFUN** | NUMERIC(16,4) | | Percentual de funcionários |

**Primary Key:** DPTCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DEPTO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DEPTO é Referenciada Por (5 tabelas):

#### 1. ALMOX - Células/Almoxarifados
**Relacionamento:**
```
ALMOX.DPTCODIGO → DEPTO.DPTCODIGO (N:1)
Constraint: INTEG_1712
```

**Descrição**: Cada célula pode estar vinculada a um departamento específico.

**Informações da Tabela ALMOX:**
- **Total:** 128 células
- **PK:** (ALXCODIGO, EMPCODIGO)
- **Colunas:** 72 campos

**Uso:** Organizar células de produção por departamento.

---

#### 2. FUNCIO - Funcionários
**Relacionamento:**
```
FUNCIO.DPTCODIGO → DEPTO.DPTCODIGO (N:1)
Constraint: DEPTO_FUNCIO
```

**Descrição**: Cada funcionário pode estar vinculado a um departamento específico.

**Uso:** Organizar funcionários por departamento.

---

#### 3. DPTPO - Departamentos x Pontos
**Relacionamento:**
```
DPTPO.DPTCODIGO → DEPTO.DPTCODIGO (N:1)
Constraint: FK_DPTPO_DEPTO
```

**Descrição**: Cada associação departamento-ponto está vinculada a um departamento específico.

**Uso:** Associar departamentos a pontos específicos.

---

#### 4. OCORRFP - Ocorrências de Funcionários
**Relacionamento:**
```
OCORRFP.DPTCODIGO → DEPTO.DPTCODIGO (N:1)
Constraint: DEPTO_OCORRFP
```

**Descrição**: Cada ocorrência pode estar vinculada a um departamento específico.

**Uso:** Organizar ocorrências de funcionários por departamento.

---

#### 5. SOLICITACAO - Solicitações
**Relacionamento:**
```
SOLICITACAO.DPTCODIGO → DEPTO.DPTCODIGO (N:1)
Constraint: DEPTO_SOLICITACAO
```

**Descrição**: Cada solicitação pode estar vinculada a um departamento específico.

**Uso:** Organizar solicitações por departamento.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via FUNCODIGO → FUNCIO → Outras Operações do Funcionário

**Fluxo:** DEPTO → FUNCIO → Operações

**Descrição:** Através do funcionário responsável, é possível identificar outras operações relacionadas.

**Uso:** Análise de departamentos por responsável.

---

### Via ALMOX → Operações de Produção

**Fluxo:** DEPTO → ALMOX → Operações

**Descrição:** Através das células, é possível identificar operações de produção relacionadas.

**Uso:** Análise de produção por departamento.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Departamento

**Objetivo:** Obter visão completa de um departamento incluindo funcionários, células e ocorrências.

**Fluxo:**
```
DEPTO (DPTCODIGO)
  ↓
FUNCIO (DPTCODIGO)
  ↓
ALMOX (DPTCODIGO)
  ↓
OCORRFP (DPTCODIGO)
```

**Query SQL:**
```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    d.FUNCODIGO AS FUNCIONARIO_RESPONSAVEL,
    f.FUNNOME AS NOME_RESPONSAVEL,
    d.DPTPERFUN AS PERCENTUAL_FUNCIONARIOS,
    COUNT(DISTINCT al.ALXCODIGO) AS TOTAL_CELULAS,
    COUNT(DISTINCT fu.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT oc.OCFCODIGO) AS TOTAL_OCORRENCIAS
FROM DEPTO d
LEFT JOIN FUNCIO f ON f.FUNCODIGO = d.FUNCODIGO
LEFT JOIN ALMOX al ON al.DPTCODIGO = d.DPTCODIGO
LEFT JOIN FUNCIO fu ON fu.DPTCODIGO = d.DPTCODIGO
LEFT JOIN OCORRFP oc ON oc.DPTCODIGO = d.DPTCODIGO
WHERE d.DPTCODIGO = ?
GROUP BY d.DPTCODIGO, d.DPTNOME, d.FUNCODIGO, f.FUNNOME, d.DPTPERFUN;
```

---

### Exemplo 2: Análise de Departamentos por Funcionários

**Objetivo:** Identificar distribuição de funcionários por departamento.

**Query SQL:**
```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    d.DPTPERFUN AS PERCENTUAL_FUNCIONARIOS
FROM DEPTO d
LEFT JOIN FUNCIO f ON f.DPTCODIGO = d.DPTCODIGO
GROUP BY d.DPTCODIGO, d.DPTNOME, d.DPTPERFUN
ORDER BY TOTAL_FUNCIONARIOS DESC;
```

---

### Exemplo 3: Análise de Departamentos por Células

**Objetivo:** Identificar distribuição de células por departamento.

**Query SQL:**
```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    COUNT(DISTINCT al.ALXCODIGO) AS TOTAL_CELULAS,
    COUNT(DISTINCT al.EMPCODIGO) AS TOTAL_EMPRESAS
FROM DEPTO d
LEFT JOIN ALMOX al ON al.DPTCODIGO = d.DPTCODIGO
GROUP BY d.DPTCODIGO, d.DPTNOME
ORDER BY TOTAL_CELULAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Departamento

**Objetivo:** Obter informações de um departamento específico.

```sql
SELECT
    DPTCODIGO,
    DPTNOME AS DEPARTAMENTO,
    FUNCODIGO AS FUNCIONARIO_RESPONSAVEL,
    DPTPERFUN AS PERCENTUAL_FUNCIONARIOS
FROM DEPTO
WHERE DPTCODIGO = ?;
```

---

### 2. Listar Todos os Departamentos

**Objetivo:** Obter catálogo completo de departamentos.

```sql
SELECT
    DPTCODIGO,
    DPTNOME AS DEPARTAMENTO,
    FUNCODIGO AS FUNCIONARIO_RESPONSAVEL,
    DPTPERFUN AS PERCENTUAL_FUNCIONARIOS
FROM DEPTO
ORDER BY DPTNOME;
```

---

### 3. Análise de Departamentos com Funcionários

**Objetivo:** Identificar departamentos e seus funcionários.

**Query SQL:**
```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    f.FUNCODIGO,
    f.FUNNOME AS FUNCIONARIO,
    f.CARCODIGO AS CARGO
FROM DEPTO d
LEFT JOIN FUNCIO f ON f.DPTCODIGO = d.DPTCODIGO
ORDER BY d.DPTNOME, f.FUNNOME;
```

---

### 4. Análise de Departamentos com Células

**Objetivo:** Identificar departamentos e suas células.

**Query SQL:**
```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    al.ALXCODIGO,
    al.ALXDESCRICAO AS CELULA,
    al.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA
FROM DEPTO d
LEFT JOIN ALMOX al ON al.DPTCODIGO = d.DPTCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = al.EMPCODIGO
ORDER BY d.DPTNOME, al.ALXDESCRICAO;
```

---

### 5. Análise de Departamentos por Responsável

**Objetivo:** Identificar departamentos agrupados por funcionário responsável.

**Query SQL:**
```sql
SELECT
    d.FUNCODIGO AS FUNCIONARIO_RESPONSAVEL,
    f.FUNNOME AS NOME_RESPONSAVEL,
    COUNT(*) AS TOTAL_DEPARTAMENTOS,
    STRING_AGG(d.DPTNOME, ', ') AS DEPARTAMENTOS
FROM DEPTO d
LEFT JOIN FUNCIO f ON f.FUNCODIGO = d.FUNCODIGO
WHERE d.FUNCODIGO IS NOT NULL
GROUP BY d.FUNCODIGO, f.FUNNOME
ORDER BY TOTAL_DEPARTAMENTOS DESC;
```

---

### 6. Relatório Completo de Departamentos

**Objetivo:** Analisar distribuição completa de departamentos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_DEPARTAMENTOS,
    COUNT(CASE WHEN FUNCODIGO IS NOT NULL THEN 1 END) AS COM_RESPONSAVEL,
    COUNT(CASE WHEN DPTPERFUN IS NOT NULL THEN 1 END) AS COM_PERCENTUAL,
    (SELECT COUNT(*) FROM FUNCIO WHERE DPTCODIGO IS NOT NULL) AS TOTAL_FUNCIONARIOS_VINCULADOS,
    (SELECT COUNT(*) FROM ALMOX WHERE DPTCODIGO IS NOT NULL) AS TOTAL_CELULAS_VINCULADAS
FROM DEPTO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DEPTO | Tipo |
|--------|-----------|-------------------|------|
| **DEPTO** | 16 | 1:1 | **TABELA PRINCIPAL** |
| FUNCIO | ~? | ?:1 | Funcionários (média de ? funcionários por departamento) |
| ALMOX | 128 | 1:8 | Células (média de 8 células por departamento) |

**Interpretação:**
- **16 departamentos** cadastrados no sistema
- **Média de 8 células por departamento** - indica organização hierárquica clara

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (consultas frequentes)
CREATE INDEX IDX_DEPTO_NOME ON DEPTO(DPTNOME);

-- Índice 2: Busca por funcionário responsável (consultas frequentes)
CREATE INDEX IDX_DEPTO_RESPONSAVEL ON DEPTO(FUNCODIGO)
    WHERE FUNCODIGO IS NOT NULL;
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
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class FirebirdDepto extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DEPTO';
    
    protected $primaryKey = 'DPTCODIGO';
    public $incrementing = true;

    protected $casts = [
        'DPTCODIGO' => 'integer',
        'DPTNOME' => 'string',
        'FUNCODIGO' => 'integer',
        'DPTPERFUN' => 'decimal:4',
    ];

    // Relacionamento lógico com FUNCIO (responsável)
    public function responsavel()
    {
        return $this->belongsTo(FirebirdFuncio::class, 'FUNCODIGO', 'FUNCODIGO');
    }

    // Relacionamento com ALMOX
    public function celulas(): HasMany
    {
        return $this->hasMany(FirebirdAlmox::class, 'DPTCODIGO', 'DPTCODIGO');
    }

    // Relacionamento com FUNCIO
    public function funcionarios(): HasMany
    {
        return $this->hasMany(FirebirdFuncio::class, 'DPTCODIGO', 'DPTCODIGO');
    }

    // Relacionamento com OCORRFP
    public function ocorrencias(): HasMany
    {
        return $this->hasMany(FirebirdOcorrfp::class, 'DPTCODIGO', 'DPTCODIGO');
    }

    // Relacionamento com SOLICITACAO
    public function solicitacoes(): HasMany
    {
        return $this->hasMany(FirebirdSolicitacao::class, 'DPTCODIGO', 'DPTCODIGO');
    }

    public function scopeComResponsavel($query)
    {
        return $query->whereNotNull('FUNCODIGO');
    }

    public function scopePorResponsavel($query, int $funcionarioCodigo)
    {
        return $query->where('FUNCODIGO', $funcionarioCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

