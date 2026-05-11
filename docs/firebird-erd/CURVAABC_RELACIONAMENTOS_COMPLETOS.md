# CURVAABC - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CURVAABC (Análise de Curva ABC)
- **Total de Registros**: 14.195
- **Total de Colunas**: 9
- **Chave Primária**: Composta (PROCODIGO, EMPCODIGO, CVATIPO)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CURVAABC** é uma tabela que armazena análises de curva ABC de produtos por empresa. A curva ABC é uma técnica de classificação de produtos baseada em valor ou quantidade, permitindo identificar produtos mais importantes para gestão de estoque e vendas. Com **14.195 registros**, representa análises extensivas de classificação ABC de produtos por empresa e tipo de análise.

Esta tabela funciona como **sistema de classificação ABC de produtos** e permite:
- Classificar produtos em categorias A, B ou C baseado em valor ou quantidade
- Armazenar análises por empresa e tipo de análise
- Rastrear valores e quantidades utilizados na classificação
- Controlar data de apuração da análise
- Suportar diferentes tipos de análise (CVATIPO)
- Armazenar custo por CMM (CVACUSTOXCMM)
- Manter opções específicas da análise (CVAOPCAO)

Cada registro representa uma classificação ABC específica de um produto (PROCODIGO) para uma empresa (EMPCODIGO) em um tipo de análise específico (CVATIPO), contendo:
- Identificação do produto (PROCODIGO)
- Empresa (EMPCODIGO)
- Tipo de análise (CVATIPO)
- Classificação ABC (CVACLASSIFICACAO) - A, B ou C
- Valor utilizado na análise (CVAVALOR)
- Quantidade utilizada na análise (CVAQTDADE)
- Data de apuração (CVADTAPURACAO)
- Custo por CMM (CVACUSTOXCMM)
- Opção da análise (CVAOPCAO)

**Classificação ABC:**
- **Classe A**: Produtos mais importantes (geralmente representam ~80% do valor total)
- **Classe B**: Produtos intermediários (geralmente representam ~15% do valor total)
- **Classe C**: Produtos menos importantes (geralmente representam ~5% do valor total)

O sistema utiliza esta tabela para classificar produtos por importância, facilitando gestão de estoque, priorização de vendas e análise de performance.

**Observação Importante:** CURVAABC é uma tabela importante para análise de produtos, permitindo classificação ABC por empresa e tipo de análise. Com 14.195 registros, indica uso extensivo desta funcionalidade.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código do produto (PK + FK → PRODU) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |
| **CVATIPO** 🔑 | VARCHAR(14) | ✓ | Tipo de análise (PK) |

### Informações da Classificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CVACLASSIFICACAO** | VARCHAR(14) | ✓ | Classificação ABC (A, B ou C) |
| **CVAVALOR** | NUMERIC(16,4) | | Valor utilizado na análise |
| **CVAQTDADE** | NUMERIC(16,4) | | Quantidade utilizada na análise |
| **CVADTAPURACAO** | TIMESTAMP | | Data de apuração da análise |
| **CVACUSTOXCMM** | NUMERIC(16,4) | | Custo por CMM |
| **CVAOPCAO** | VARCHAR(37) | | Opção da análise |

**Primary Key:** (PROCODIGO, EMPCODIGO, CVATIPO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CURVAABC Referencia (2 FKs):

#### 1. PRODU - Produtos
**Relacionamento:**
```
CURVAABC.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: FK_CURVAABC_PRODU
```

**Descrição**: Cada classificação está vinculada a um produto específico.

---

#### 2. EMPRESA - Empresas
**Relacionamento:**
```
CURVAABC.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: FK_CURVAABC_EMPRESA
```

**Descrição**: Cada classificação está vinculada a uma empresa específica.

---

### CURVAABC é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CURVAABC diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Classificação ABC de um Produto

```sql
SELECT
    PROCODIGO,
    EMPCODIGO,
    CVATIPO AS TIPO_ANALISE,
    CVACLASSIFICACAO AS CLASSIFICACAO,
    CVAVALOR AS VALOR,
    CVAQTDADE AS QUANTIDADE,
    CVADTAPURACAO AS DATA_APURACAO
FROM CURVAABC
WHERE PROCODIGO = ?
  AND EMPCODIGO = ?
  AND CVATIPO = ?;
```

---

### 2. Listar Produtos Classe A de uma Empresa

```sql
SELECT
    ca.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    ca.CVATIPO AS TIPO_ANALISE,
    ca.CVAVALOR AS VALOR,
    ca.CVAQTDADE AS QUANTIDADE,
    ca.CVADTAPURACAO AS DATA_APURACAO
FROM CURVAABC ca
INNER JOIN PRODU p ON p.PROCODIGO = ca.PROCODIGO
WHERE ca.EMPCODIGO = ?
  AND ca.CVACLASSIFICACAO = 'A'
ORDER BY ca.CVAVALOR DESC;
```

---

### 3. Análise de Distribuição ABC por Empresa

```sql
SELECT
    EMPCODIGO,
    CVACLASSIFICACAO AS CLASSIFICACAO,
    COUNT(*) AS TOTAL_PRODUTOS,
    SUM(CVAVALOR) AS VALOR_TOTAL,
    SUM(CVAQTDADE) AS QUANTIDADE_TOTAL,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY EMPCODIGO), 2) AS PERCENTUAL_PRODUTOS,
    ROUND(100.0 * SUM(CVAVALOR) / SUM(SUM(CVAVALOR)) OVER (PARTITION BY EMPCODIGO), 2) AS PERCENTUAL_VALOR
FROM CURVAABC
WHERE EMPCODIGO = ?
GROUP BY EMPCODIGO, CVACLASSIFICACAO
ORDER BY CVACLASSIFICACAO;
```

---

### 4. Análise de Produtos por Tipo de Análise

```sql
SELECT
    CVATIPO AS TIPO_ANALISE,
    CVACLASSIFICACAO AS CLASSIFICACAO,
    COUNT(*) AS TOTAL_PRODUTOS,
    SUM(CVAVALOR) AS VALOR_TOTAL,
    AVG(CVAVALOR) AS VALOR_MEDIO
FROM CURVAABC
GROUP BY CVATIPO, CVACLASSIFICACAO
ORDER BY CVATIPO, CVACLASSIFICACAO;
```

---

### 5. Identificar Produtos que Mudaram de Classe

**Query SQL:**
```sql
-- Comparar classificações em diferentes tipos de análise
SELECT
    ca1.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    ca1.CVATIPO AS TIPO_ANALISE_1,
    ca1.CVACLASSIFICACAO AS CLASSIFICACAO_1,
    ca2.CVATIPO AS TIPO_ANALISE_2,
    ca2.CVACLASSIFICACAO AS CLASSIFICACAO_2
FROM CURVAABC ca1
INNER JOIN CURVAABC ca2 ON ca2.PROCODIGO = ca1.PROCODIGO
                        AND ca2.EMPCODIGO = ca1.EMPCODIGO
                        AND ca2.CVATIPO != ca1.CVATIPO
INNER JOIN PRODU p ON p.PROCODIGO = ca1.PROCODIGO
WHERE ca1.EMPCODIGO = ?
  AND ca1.CVACLASSIFICACAO != ca2.CVACLASSIFICACAO
ORDER BY ca1.PROCODIGO;
```

---

### 6. Análise de Produtos por Período de Apuração

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM CVADTAPURACAO) AS ANO,
    EXTRACT(MONTH FROM CVADTAPURACAO) AS MES,
    CVACLASSIFICACAO AS CLASSIFICACAO,
    COUNT(*) AS TOTAL_PRODUTOS,
    SUM(CVAVALOR) AS VALOR_TOTAL
FROM CURVAABC
WHERE CVADTAPURACAO IS NOT NULL
GROUP BY EXTRACT(YEAR FROM CVADTAPURACAO), 
         EXTRACT(MONTH FROM CVADTAPURACAO),
         CVACLASSIFICACAO
ORDER BY ANO DESC, MES DESC, CVACLASSIFICACAO;
```

---

### 7. Relatório Completo de Curva ABC

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CLASSIFICACOES,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT CVATIPO) AS TOTAL_TIPOS_ANALISE,
    COUNT(CASE WHEN CVACLASSIFICACAO = 'A' THEN 1 END) AS TOTAL_CLASSE_A,
    COUNT(CASE WHEN CVACLASSIFICACAO = 'B' THEN 1 END) AS TOTAL_CLASSE_B,
    COUNT(CASE WHEN CVACLASSIFICACAO = 'C' THEN 1 END) AS TOTAL_CLASSE_C,
    SUM(CVAVALOR) AS VALOR_TOTAL,
    SUM(CVAQTDADE) AS QUANTIDADE_TOTAL,
    MIN(CVADTAPURACAO) AS PRIMEIRA_APURACAO,
    MAX(CVADTAPURACAO) AS ULTIMA_APURACAO
FROM CURVAABC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CURVAABC** | 14.195 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | ~178.187 | 1:0.08 | Produtos (média de ~0.08 classificações por produto) |
| EMPRESA | ~? | ?:1 | Empresas |

**Interpretação:**
- **14.195 classificações** cadastradas no sistema
- **Média de ~0.08 classificações por produto** - indica uso seletivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa e classificação
CREATE INDEX IDX_CURVAABC_EMP_CLASS ON CURVAABC(EMPCODIGO, CVACLASSIFICACAO);

-- Índice 2: Busca por tipo de análise
CREATE INDEX IDX_CURVAABC_TIPO ON CURVAABC(CVATIPO);

-- Índice 3: Busca por data de apuração
CREATE INDEX IDX_CURVAABC_DATA_APURACAO ON CURVAABC(CVADTAPURACAO)
    WHERE CVADTAPURACAO IS NOT NULL;

-- Índice 4: Busca composta por empresa e tipo
CREATE INDEX IDX_CURVAABC_EMP_TIPO ON CURVAABC(EMPCODIGO, CVATIPO);
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

final class FirebirdCurvaabc extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CURVAABC';
    
    protected $primaryKey = ['PROCODIGO', 'EMPCODIGO', 'CVATIPO'];
    public $incrementing = false;

    protected $casts = [
        'PROCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'CVATIPO' => 'string',
        'CVACLASSIFICACAO' => 'string',
        'CVAVALOR' => 'decimal:4',
        'CVAQTDADE' => 'decimal:4',
        'CVADTAPURACAO' => 'datetime',
        'CVACUSTOXCMM' => 'decimal:4',
        'CVAOPCAO' => 'string',
    ];

    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function ehClasseA(): bool
    {
        return $this->CVACLASSIFICACAO === 'A';
    }

    public function ehClasseB(): bool
    {
        return $this->CVACLASSIFICACAO === 'B';
    }

    public function ehClasseC(): bool
    {
        return $this->CVACLASSIFICACAO === 'C';
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    public function scopePorTipo($query, string $tipoAnalise)
    {
        return $query->where('CVATIPO', $tipoAnalise);
    }

    public function scopePorClassificacao($query, string $classificacao)
    {
        return $query->where('CVACLASSIFICACAO', $classificacao);
    }

    public function scopeClasseA($query)
    {
        return $query->where('CVACLASSIFICACAO', 'A');
    }

    public function scopeClasseB($query)
    {
        return $query->where('CVACLASSIFICACAO', 'B');
    }

    public function scopeClasseC($query)
    {
        return $query->where('CVACLASSIFICACAO', 'C');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

