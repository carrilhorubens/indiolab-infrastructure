# MOVPCTPRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOVPCTPRO (Movimentações de Percentuais de Produtos)
- **Total de Registros**: 16.586
- **Total de Colunas**: 11
- **Chave Primária**: MOVCHAVE, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 2 (EMPRESA, PRODU)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOVPCTPRO** é uma tabela que armazena movimentações de percentuais de produtos. Com **16.586 registros**, representa movimentações de percentuais de produtos cadastradas no sistema, incluindo informações sobre número do percentual, produto, data, entrada/saída, origem, quantidade e documento.

Esta tabela funciona como **log de movimentações de percentuais** e permite:
- Registrar todas as movimentações de percentuais de produtos
- Armazenar informações sobre número do percentual e produto
- Rastrear data, entrada/saída e origem da movimentação
- Controlar quantidade e documento da movimentação
- Vincular movimentações a empresas e produtos
- Facilitar gestão de movimentações de percentuais
- Manter histórico detalhado de movimentações

Cada registro representa uma movimentação específica de percentual de produto, contendo:
- Chave da movimentação (MOVCHAVE)
- Código da empresa (EMPCODIGO)
- Número do percentual (PCTNUMERO)
- Código do produto (PROCODIGO)
- Data da movimentação (MOVDATA)
- Indicador de entrada/saída (MOVENTSAI)
- Origem da movimentação (MOVORIGEM)
- Quantidade movimentada (MOVQTDADE)
- Número do documento (MOVNRDOCTO)
- Data do documento (MOVDTDOCTO)
- Sequência do documento (MOVSQDOCTO)

O sistema utiliza esta tabela para manter histórico completo de movimentações de percentuais de produtos, sendo referenciada por EMPRESA através de EMPCODIGO e por PRODU através de PROCODIGO.

**Observação Importante:** MOVPCTPRO é uma tabela de movimentações de percentuais de produtos. Com 16.586 registros, indica uso moderado desta funcionalidade. Possui chave primária composta (MOVCHAVE, EMPCODIGO) e referencia EMPRESA e PRODU, indicando sua função de rastreamento de movimentações.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MOVCHAVE** 🔑 | INTEGER | ✓ | Chave da movimentação (PK) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK, FK) |

### Relacionamento com PRODU
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔗 | VARCHAR(14) | ✓ | Código do produto (FK) |

### Informações da Movimentação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PCTNUMERO** | INTEGER | ✓ | Número do percentual |
| **MOVDATA** | DATE | ✓ | Data da movimentação |
| **MOVENTSAI** | VARCHAR(14) | ✓ | Indicador de entrada/saída |
| **MOVORIGEM** | VARCHAR(14) | ✓ | Origem da movimentação |
| **MOVQTDADE** | DECIMAL(16,2) | ✓ | Quantidade movimentada |
| **MOVNRDOCTO** | VARCHAR(14) | | Número do documento |
| **MOVDTDOCTO** | DATE | | Data do documento |
| **MOVSQDOCTO** | INTEGER | | Sequência do documento |

**Primary Key:** MOVCHAVE, EMPCODIGO (composta)

**Foreign Keys:**
- `EMPRESA_MOVPCTPRO`: EMPCODIGO → EMPRESA.EMPCODIGO
- `PRODU_MOVPCTPRO`: PROCODIGO → PRODU.PROCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOVPCTPRO Referencia (2 tabelas):

#### 1. EMPRESA - Empresas
**Relacionamento:**
```
MOVPCTPRO.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_MOVPCTPRO
```

**Descrição**: Cada movimentação está vinculada a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos

**Uso:** Vincular movimentações a empresas para organização.

---

#### 2. PRODU - Produtos
**Relacionamento:**
```
MOVPCTPRO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_MOVPCTPRO
```

**Descrição**: Cada movimentação está vinculada a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Vincular movimentações a produtos para rastreamento.

---

### MOVPCTPRO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOVPCTPRO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PRODU → Outras Operações

**Fluxo:** MOVPCTPRO → PRODU → Operações

**Descrição:** Através dos produtos vinculados, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de produtos.

---

### Via EMPRESA → Outras Operações

**Fluxo:** MOVPCTPRO → EMPRESA → Operações

**Descrição:** Através das empresas vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Movimentação de Percentual

**Objetivo:** Obter informações de uma movimentação específica.

```sql
SELECT
    m.MOVCHAVE,
    m.EMPCODIGO,
    m.PCTNUMERO,
    m.PROCODIGO,
    m.MOVDATA,
    m.MOVENTSAI,
    m.MOVORIGEM,
    m.MOVQTDADE,
    m.MOVNRDOCTO,
    p.PRODESCRICAO AS PRODUTO_DESCRICAO
FROM MOVPCTPRO m
INNER JOIN PRODU p ON p.PROCODIGO = m.PROCODIGO
WHERE m.MOVCHAVE = ? AND m.EMPCODIGO = ?;
```

---

### 2. Listar Movimentações de um Produto

**Objetivo:** Obter todas as movimentações de um produto específico.

```sql
SELECT
    MOVCHAVE,
    EMPCODIGO,
    PCTNUMERO,
    MOVDATA,
    MOVENTSAI,
    MOVORIGEM,
    MOVQTDADE
FROM MOVPCTPRO
WHERE PROCODIGO = ?
ORDER BY MOVDATA DESC;
```

---

### 3. Análise de Movimentações por Tipo

**Objetivo:** Identificar distribuição de movimentações por entrada/saída.

**Query SQL:**
```sql
SELECT
    MOVENTSAI,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(MOVQTDADE) AS QUANTIDADE_TOTAL
FROM MOVPCTPRO
WHERE MOVENTSAI IS NOT NULL
GROUP BY MOVENTSAI
ORDER BY TOTAL_MOVIMENTACOES DESC;
```

---

### 4. Análise de Movimentações por Período

**Objetivo:** Identificar distribuição de movimentações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM MOVDATA) AS ANO,
    EXTRACT(MONTH FROM MOVDATA) AS MES,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(MOVQTDADE) AS QUANTIDADE_TOTAL
FROM MOVPCTPRO
WHERE MOVDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM MOVDATA), EXTRACT(MONTH FROM MOVDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOVPCTPRO | Tipo |
|--------|-----------|----------------------|------|
| **MOVPCTPRO** | 16.586 | 1:1 | **TABELA PRINCIPAL** |
| EMPRESA | 6 | 1:2.764 | Empresas (média de 2.764 movimentações por empresa) |
| PRODU | 178.187 | 1:0.09 | Produtos (média de 0.09 movimentações por produto) |

**Interpretação:**
- **16.586 movimentações** registradas no sistema
- **Média de 2.764 movimentações por empresa** - indica uso moderado por empresa
- **Média de 0.09 movimentações por produto** - indica que poucos produtos possuem movimentações de percentuais

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MOVPCTPRO_PRODUTO ON MOVPCTPRO(PROCODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_MOVPCTPRO_EMPRESA ON MOVPCTPRO(EMPCODIGO);

-- Índice 3: Busca por data (consultas frequentes)
CREATE INDEX IDX_MOVPCTPRO_DATA ON MOVPCTPRO(MOVDATA)
    WHERE MOVDATA IS NOT NULL;

-- Índice 4: Busca por entrada/saída (consultas frequentes)
CREATE INDEX IDX_MOVPCTPRO_ENTSAI ON MOVPCTPRO(MOVENTSAI)
    WHERE MOVENTSAI IS NOT NULL;
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

final class FirebirdMovpctpro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOVPCTPRO';
    
    protected $primaryKey = ['MOVCHAVE', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'MOVCHAVE' => 'integer',
        'EMPCODIGO' => 'integer',
        'PCTNUMERO' => 'integer',
        'PROCODIGO' => 'string',
        'MOVDATA' => 'date',
        'MOVENTSAI' => 'string',
        'MOVORIGEM' => 'string',
        'MOVQTDADE' => 'decimal:2',
        'MOVNRDOCTO' => 'string',
        'MOVDTDOCTO' => 'date',
        'MOVSQDOCTO' => 'integer',
    ];

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    public function scopePorProduto($query, string $proCodigo)
    {
        return $query->where('PROCODIGO', $proCodigo);
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorTipo($query, string $entSai)
    {
        return $query->where('MOVENTSAI', $entSai);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('MOVDATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MOVDATA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

