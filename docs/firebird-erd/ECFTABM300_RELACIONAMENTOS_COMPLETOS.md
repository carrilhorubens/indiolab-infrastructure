# ECFTABM300 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: ECFTABM300 (Tabela M300 do ECF - Escrituração Contábil Fiscal)
- **Total de Registros**: 705
- **Total de Colunas**: 7
- **Chave Primária**: Composta (ETMCODIGO, ETMBLOCO)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**ECFTABM300** é uma tabela que armazena informações da tabela M300 do ECF (Escrituração Contábil Fiscal). Com **705 registros**, representa registros de escrituração contábil fiscal relacionados ao bloco M300, permitindo controle fiscal e contábil detalhado.

Esta tabela funciona como **tabela de escrituração contábil fiscal (bloco M300)** e permite:
- Armazenar informações de escrituração contábil fiscal
- Controlar períodos de validade (data inicial e final)
- Identificar tipos de lançamento e operações
- Organizar registros por blocos
- Suportar escrituração contábil fiscal conforme legislação brasileira
- Facilitar geração de arquivos ECF

Cada registro representa um registro de escrituração contábil fiscal do bloco M300, contendo:
- Código do registro (ETMCODIGO) - parte da PK
- Descrição do registro (ETMDESCRICAO)
- Data inicial de validade (ETMDTINI)
- Data final de validade (ETMDTFIN)
- Tipo do registro (ETMTIPO)
- Tipo de lançamento (ETMTIPOLANC)
- Bloco do registro (ETMBLOCO) - parte da PK

O sistema utiliza esta tabela para controlar escrituração contábil fiscal conforme legislação brasileira, permitindo geração de arquivos ECF e controle fiscal detalhado.

**Observação Importante:** ECFTABM300 é uma tabela de escrituração contábil fiscal relacionada ao bloco M300 do ECF. Com 705 registros e chave primária composta, indica uso extensivo desta funcionalidade. Não possui foreign keys diretas, funcionando como tabela de dados fiscais/contábeis.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ETMCODIGO** 🔑 | VARCHAR(37) | ✓ | Código do registro (PK) |
| **ETMBLOCO** 🔑 | VARCHAR(37) | ✓ | Bloco do registro (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ETMDESCRICAO** | VARCHAR(37) | ✓ | Descrição do registro |
| **ETMDTINI** | DATE | | Data inicial de validade |
| **ETMDTFIN** | DATE | | Data final de validade |
| **ETMTIPO** | VARCHAR(37) | | Tipo do registro |
| **ETMTIPOLANC** | VARCHAR(37) | | Tipo de lançamento |

**Primary Key:** (ETMCODIGO, ETMBLOCO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### ECFTABM300 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### ECFTABM300 é Referenciada Por (0 tabelas):

Nenhuma tabela referencia ECFTABM300 diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ETMCODIGO → Outras Tabelas ECF

**Fluxo:** ECFTABM300 → Outras Tabelas ECF

**Descrição:** Através do código do registro, é possível identificar outras tabelas ECF relacionadas.

**Uso:** Análise de escrituração contábil fiscal completa.

---

### Via ETMBLOCO → Outras Tabelas ECF

**Fluxo:** ECFTABM300 → Outras Tabelas ECF

**Descrição:** Através do bloco, é possível identificar outras tabelas ECF relacionadas.

**Uso:** Análise de escrituração contábil fiscal por bloco.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Registro ECF

**Objetivo:** Obter informações de um registro específico.

```sql
SELECT
    ETMCODIGO,
    ETMBLOCO,
    ETMDESCRICAO AS DESCRICAO,
    ETMDTINI AS DATA_INICIAL,
    ETMDTFIN AS DATA_FINAL,
    ETMTIPO AS TIPO,
    ETMTIPOLANC AS TIPO_LANCAMENTO
FROM ECFTABM300
WHERE ETMCODIGO = ?
  AND ETMBLOCO = ?;
```

---

### 2. Listar Registros por Bloco

**Objetivo:** Obter todos os registros de um bloco específico.

```sql
SELECT
    ETMCODIGO,
    ETMDESCRICAO AS DESCRICAO,
    ETMDTINI AS DATA_INICIAL,
    ETMDTFIN AS DATA_FINAL,
    ETMTIPO AS TIPO,
    ETMTIPOLANC AS TIPO_LANCAMENTO
FROM ECFTABM300
WHERE ETMBLOCO = ?
ORDER BY ETMCODIGO;
```

---

### 3. Análise de Registros por Período

**Objetivo:** Identificar registros válidos em um período específico.

**Query SQL:**
```sql
SELECT
    ETMCODIGO,
    ETMBLOCO,
    ETMDESCRICAO AS DESCRICAO,
    ETMDTINI AS DATA_INICIAL,
    ETMDTFIN AS DATA_FINAL,
    ETMTIPO AS TIPO
FROM ECFTABM300
WHERE (ETMDTINI IS NULL OR ETMDTINI <= ?)
  AND (ETMDTFIN IS NULL OR ETMDTFIN >= ?)
ORDER BY ETMBLOCO, ETMCODIGO;
```

---

### 4. Análise de Registros por Tipo

**Objetivo:** Identificar distribuição de registros por tipo.

**Query SQL:**
```sql
SELECT
    ETMTIPO AS TIPO,
    ETMTIPOLANC AS TIPO_LANCAMENTO,
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(DISTINCT ETMBLOCO) AS TOTAL_BLOCOS
FROM ECFTABM300
WHERE ETMTIPO IS NOT NULL
GROUP BY ETMTIPO, ETMTIPOLANC
ORDER BY TOTAL_REGISTROS DESC;
```

---

### 5. Análise de Registros por Bloco

**Objetivo:** Identificar distribuição de registros por bloco.

**Query SQL:**
```sql
SELECT
    ETMBLOCO AS BLOCO,
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(DISTINCT ETMTIPO) AS TOTAL_TIPOS,
    MIN(ETMDTINI) AS PRIMEIRA_DATA_INICIAL,
    MAX(ETMDTFIN) AS ULTIMA_DATA_FINAL
FROM ECFTABM300
GROUP BY ETMBLOCO
ORDER BY ETMBLOCO;
```

---

### 6. Análise de Registros Vencidos

**Objetivo:** Identificar registros com data final vencida.

**Query SQL:**
```sql
SELECT
    ETMCODIGO,
    ETMBLOCO,
    ETMDESCRICAO AS DESCRICAO,
    ETMDTINI AS DATA_INICIAL,
    ETMDTFIN AS DATA_FINAL,
    ETMTIPO AS TIPO
FROM ECFTABM300
WHERE ETMDTFIN IS NOT NULL
  AND ETMDTFIN < CURRENT_DATE
ORDER BY ETMDTFIN DESC;
```

---

### 7. Relatório Completo de Registros ECF

**Objetivo:** Analisar distribuição completa de registros ECF no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(DISTINCT ETMBLOCO) AS TOTAL_BLOCOS,
    COUNT(DISTINCT ETMTIPO) AS TOTAL_TIPOS,
    COUNT(DISTINCT ETMTIPOLANC) AS TOTAL_TIPOS_LANCAMENTO,
    COUNT(CASE WHEN ETMDTINI IS NOT NULL THEN 1 END) AS COM_DATA_INICIAL,
    COUNT(CASE WHEN ETMDTFIN IS NOT NULL THEN 1 END) AS COM_DATA_FINAL,
    COUNT(CASE WHEN ETMDTFIN IS NOT NULL AND ETMDTFIN < CURRENT_DATE THEN 1 END) AS VENCIDOS
FROM ECFTABM300;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com ECFTABM300 | Tipo |
|--------|-----------|------------------------|------|
| **ECFTABM300** | 705 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **705 registros de escrituração contábil fiscal** no sistema
- **Tabela de dados fiscais/contábeis** - mantém registros de escrituração contábil fiscal

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por bloco (consultas frequentes)
CREATE INDEX IDX_ECFTABM300_BLOCO ON ECFTABM300(ETMBLOCO);

-- Índice 2: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_ECFTABM300_TIPO ON ECFTABM300(ETMTIPO)
    WHERE ETMTIPO IS NOT NULL;

-- Índice 3: Busca por período (consultas frequentes)
CREATE INDEX IDX_ECFTABM300_PERIODO ON ECFTABM300(ETMDTINI, ETMDTFIN)
    WHERE ETMDTINI IS NOT NULL OR ETMDTFIN IS NOT NULL;

-- Índice 4: Busca combinada bloco + código (consultas frequentes)
CREATE INDEX IDX_ECFTABM300_BLOCO_CODIGO ON ECFTABM300(ETMBLOCO, ETMCODIGO);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdEcftabm300 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'ECFTABM300';
    
    protected $primaryKey = ['ETMCODIGO', 'ETMBLOCO'];
    public $incrementing = false;

    protected $casts = [
        'ETMCODIGO' => 'string',
        'ETMBLOCO' => 'string',
        'ETMDESCRICAO' => 'string',
        'ETMDTINI' => 'date',
        'ETMDTFIN' => 'date',
        'ETMTIPO' => 'string',
        'ETMTIPOLANC' => 'string',
    ];

    public function scopePorBloco($query, string $bloco)
    {
        return $query->where('ETMBLOCO', $bloco);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('ETMTIPO', $tipo);
    }

    public function scopeValidosNoPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->where(function($q) use ($dataInicial, $dataFinal) {
            $q->where(function($q2) use ($dataInicial) {
                $q2->whereNull('ETMDTINI')
                   ->orWhere('ETMDTINI', '<=', $dataInicial);
            })
            ->where(function($q2) use ($dataFinal) {
                $q2->whereNull('ETMDTFIN')
                   ->orWhere('ETMDTFIN', '>=', $dataFinal);
            });
        });
    }

    public function scopeVencidos($query)
    {
        return $query->whereNotNull('ETMDTFIN')
                    ->where('ETMDTFIN', '<', now());
    }

    public function scopeAtivos($query)
    {
        return $query->where(function($q) {
            $q->whereNull('ETMDTFIN')
              ->orWhere('ETMDTFIN', '>=', now());
        });
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

