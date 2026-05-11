# MOVPDCAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOVPDCAO (Movimentações de Ordens de Produção)
- **Total de Registros**: 5.131.548
- **Total de Colunas**: 8
- **Chave Primária**: MOVCHAVE (simples)
- **Chaves Estrangeiras**: 3 (PRODU, PDCAO - duas vezes)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOVPDCAO** é uma tabela que armazena movimentações de ordens de produção. Com **5.131.548 registros**, representa um histórico extenso de movimentações de ordens de produção cadastradas no sistema, incluindo informações sobre quantidade, produto, origem, entrada/saída, data e ordem de produção.

Esta tabela funciona como **log de movimentações de ordens de produção** e permite:
- Registrar todas as movimentações de ordens de produção
- Armazenar informações sobre quantidade e produto
- Rastrear origem, entrada/saída e data da movimentação
- Vincular movimentações a produtos e ordens de produção
- Facilitar gestão de movimentações de ordens de produção
- Manter histórico detalhado de movimentações

Cada registro representa uma movimentação específica de ordem de produção, contendo:
- Chave da movimentação (MOVCHAVE)
- Quantidade movimentada (MOVQTDADE)
- Código do produto (PROCODIGO)
- Origem da movimentação (MOVORIGEM)
- Indicador de entrada/saída (MOVENTSAI)
- Data da movimentação (MOVDATA)
- Código da ordem de produção (PDCCODIGO)
- Código da empresa (EMPCODIGO)

O sistema utiliza esta tabela para manter histórico completo de movimentações de ordens de produção, sendo referenciada por PRODU através de PROCODIGO e por PDCAO através de PDCCODIGO e EMPCODIGO.

**Observação Importante:** MOVPDCAO é uma tabela de movimentações de ordens de produção. Com 5.131.548 registros, indica uso intenso desta funcionalidade. Possui chave primária simples (MOVCHAVE) e referencia PRODU e PDCAO (duas vezes), indicando sua função de rastreamento detalhado de movimentações.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MOVCHAVE** 🔑 | INTEGER | ✓ | Chave da movimentação (PK) |

### Relacionamento com PRODU
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔗 | VARCHAR(14) | | Código do produto (FK) |

### Relacionamento com PDCAO
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PDCCODIGO** 🔗 | INTEGER | ✓ | Código da ordem de produção (FK) |
| **EMPCODIGO** 🔗 | INTEGER | ✓ | Código da empresa (FK) |

### Informações da Movimentação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MOVQTDADE** | DECIMAL(16,2) | ✓ | Quantidade movimentada |
| **MOVORIGEM** | VARCHAR(14) | | Origem da movimentação |
| **MOVENTSAI** | VARCHAR(14) | ✓ | Indicador de entrada/saída |
| **MOVDATA** | TIMESTAMP | ✓ | Data da movimentação |

**Primary Key:** MOVCHAVE

**Foreign Keys:**
- `PRODU_MOVPDCAO`: PROCODIGO → PRODU.PROCODIGO
- `PDCAO_MOVPDCAO`: PDCCODIGO, EMPCODIGO → PDCAO.PDCCODIGO, PDCAO.EMPCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOVPDCAO Referencia (2 tabelas):

#### 1. PRODU - Produtos
**Relacionamento:**
```
MOVPDCAO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_MOVPDCAO
```

**Descrição**: Cada movimentação pode estar vinculada a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Vincular movimentações a produtos para rastreamento.

---

#### 2. PDCAO - Ordens de Produção
**Relacionamento:**
```
MOVPDCAO.PDCCODIGO, MOVPDCAO.EMPCODIGO → PDCAO.PDCCODIGO, PDCAO.EMPCODIGO (N:1)
Constraint: PDCAO_MOVPDCAO
```

**Descrição**: Cada movimentação está vinculada a uma ordem de produção específica.

**Informações da Tabela PDCAO:**
- **Total:** 3.201.636 ordens de produção
- **PK:** PDCCODIGO, EMPCODIGO (composta)
- **Colunas:** 31 campos

**Uso:** Vincular movimentações a ordens de produção para rastreamento.

---

### MOVPDCAO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOVPDCAO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PRODU → Outras Operações

**Fluxo:** MOVPDCAO → PRODU → Operações

**Descrição:** Através dos produtos vinculados, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de produtos.

---

### Via PDCAO → Outras Operações

**Fluxo:** MOVPDCAO → PDCAO → Operações

**Descrição:** Através das ordens de produção vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de ordens de produção.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Movimentação de Ordem de Produção

**Objetivo:** Obter informações de uma movimentação específica.

```sql
SELECT
    m.MOVCHAVE,
    m.MOVQTDADE,
    m.PROCODIGO,
    m.MOVORIGEM,
    m.MOVENTSAI,
    m.MOVDATA,
    m.PDCCODIGO,
    m.EMPCODIGO,
    p.PRODESCRICAO AS PRODUTO_DESCRICAO
FROM MOVPDCAO m
LEFT JOIN PRODU p ON p.PROCODIGO = m.PROCODIGO
WHERE m.MOVCHAVE = ?;
```

---

### 2. Listar Movimentações de uma Ordem de Produção

**Objetivo:** Obter todas as movimentações de uma ordem de produção específica.

```sql
SELECT
    MOVCHAVE,
    MOVQTDADE,
    PROCODIGO,
    MOVORIGEM,
    MOVENTSAI,
    MOVDATA
FROM MOVPDCAO
WHERE PDCCODIGO = ? AND EMPCODIGO = ?
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
FROM MOVPDCAO
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
FROM MOVPDCAO
WHERE MOVDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM MOVDATA), EXTRACT(MONTH FROM MOVDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOVPDCAO | Tipo |
|--------|-----------|---------------------|------|
| **MOVPDCAO** | 5.131.548 | 1:1 | **TABELA PRINCIPAL** |
| PDCAO | 3.201.636 | 1:1.6 | Ordens de produção (média de 1.6 movimentações por ordem) |
| PRODU | 178.187 | 1:28.8 | Produtos (média de 28.8 movimentações por produto) |

**Interpretação:**
- **5.131.548 movimentações** registradas no sistema
- **Média de 1.6 movimentações por ordem** - indica que cada ordem possui poucas movimentações
- **Média de 28.8 movimentações por produto** - indica uso extensivo de movimentações por produto

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem de produção (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MOVPDCAO_ORDEM ON MOVPDCAO(PDCCODIGO, EMPCODIGO);

-- Índice 2: Busca por produto (consultas frequentes)
CREATE INDEX IDX_MOVPDCAO_PRODUTO ON MOVPDCAO(PROCODIGO)
    WHERE PROCODIGO IS NOT NULL;

-- Índice 3: Busca por data (consultas frequentes)
CREATE INDEX IDX_MOVPDCAO_DATA ON MOVPDCAO(MOVDATA)
    WHERE MOVDATA IS NOT NULL;

-- Índice 4: Busca por entrada/saída (consultas frequentes)
CREATE INDEX IDX_MOVPDCAO_ENTSAI ON MOVPDCAO(MOVENTSAI)
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

final class FirebirdMovpdcao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOVPDCAO';
    
    protected $primaryKey = 'MOVCHAVE';
    public $incrementing = true;

    protected $casts = [
        'MOVCHAVE' => 'integer',
        'MOVQTDADE' => 'decimal:2',
        'PROCODIGO' => 'string',
        'MOVORIGEM' => 'string',
        'MOVENTSAI' => 'string',
        'MOVDATA' => 'datetime',
        'PDCCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
    ];

    // Relacionamento com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Relacionamento com PDCAO
    public function ordemProducao(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdPdcao::class,
            ['PDCCODIGO', 'EMPCODIGO'],
            ['PDCCODIGO', 'EMPCODIGO']
        );
    }

    public function scopePorOrdemProducao($query, int $pdcCodigo, int $empCodigo)
    {
        return $query->where('PDCCODIGO', $pdcCodigo)
                     ->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorProduto($query, string $proCodigo)
    {
        return $query->where('PROCODIGO', $proCodigo);
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

