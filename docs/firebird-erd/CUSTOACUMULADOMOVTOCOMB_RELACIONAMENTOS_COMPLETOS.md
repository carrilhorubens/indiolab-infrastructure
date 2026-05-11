# CUSTOACUMULADOMOVTOCOMB - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CUSTOACUMULADOMOVTOCOMB (Custo Acumulado de Movimentação - Combinações)
- **Total de Registros**: 84.902
- **Total de Colunas**: 7
- **Chave Primária**: ID_CAMC (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1 (IND_EMPRESA_MOVTOCOMB em EMPCODIGO)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CUSTOACUMULADOMOVTOCOMB** é uma tabela que armazena custos acumulados de movimentações de produtos em combinações por empresa. Com **84.902 registros**, representa histórico de custos acumulados calculados a partir de movimentações de estoque relacionadas a combinações de produtos.

Esta tabela funciona como **registro de custos acumulados de movimentações de combinações** e permite:
- Armazenar custos acumulados por produto e empresa em contexto de combinações
- Rastrear saldos de custo ao longo do tempo para produtos combinados
- Controlar data das movimentações
- Suportar soma de chave para agregações
- Facilitar análise de custos históricos de combinações

Cada registro representa um custo acumulado específico de uma movimentação de um produto (PROCODIGO) para uma empresa (EMPCODIGO) em contexto de combinação, contendo:
- Identificador único (ID_CAMC)
- Empresa (EMPCODIGO)
- Data da movimentação (CAMDATA)
- Produto (PROCODIGO)
- Custo acumulado (CAMCUSTO)
- Saldo acumulado (CAMSALDO)
- Soma de chave para agregações (CAMSOMACHAVE)

O sistema utiliza esta tabela para calcular e armazenar custos acumulados de movimentações relacionadas a combinações de produtos, facilitando análises de custos históricos e relatórios financeiros específicos para produtos combinados.

**Observação Importante:** CUSTOACUMULADOMOVTOCOMB é similar a CUSTOACUMULADOMOVTO, mas específica para movimentações relacionadas a combinações de produtos. Com 84.902 registros, indica uso extensivo desta funcionalidade.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_CAMC** 🔑 | INTEGER | ✓ | Identificador único do registro |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔗 | VARCHAR(14) | ✓ | Código do produto (FK → PRODU) |
| **EMPCODIGO** | SMALLINT | ✓ | Código da empresa |

### Informações da Movimentação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CAMDATA** | TIMESTAMP | ✓ | Data da movimentação |
| **CAMCUSTO** | NUMERIC(16,4) | | Custo acumulado |
| **CAMSALDO** | NUMERIC(16,4) | | Saldo acumulado |
| **CAMSOMACHAVE** | VARCHAR(14) | ✓ | Soma de chave para agregações |

**Primary Key:** ID_CAMC

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CUSTOACUMULADOMOVTOCOMB Referencia (1 FK):

#### 1. PRODU - Produtos
**Relacionamento:**
```
CUSTOACUMULADOMOVTOCOMB.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CUSTOACUMULADOMOVTOCOMB
```

**Descrição**: Cada custo acumulado está vinculado a um produto específico.

---

### CUSTOACUMULADOMOVTOCOMB é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CUSTOACUMULADOMOVTOCOMB diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Custo Acumulado de Combinação

```sql
SELECT
    ID_CAMC,
    EMPCODIGO,
    CAMDATA AS DATA_MOVIMENTACAO,
    PROCODIGO,
    CAMCUSTO AS CUSTO_ACUMULADO,
    CAMSALDO AS SALDO_ACUMULADO,
    CAMSOMACHAVE AS SOMA_CHAVE
FROM CUSTOACUMULADOMOVTOCOMB
WHERE ID_CAMC = ?;
```

---

### 2. Análise de Custos de Combinações por Produto

```sql
SELECT
    camc.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    camc.EMPCODIGO,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(camc.CAMCUSTO) AS CUSTO_TOTAL_ACUMULADO,
    AVG(camc.CAMCUSTO) AS CUSTO_MEDIO,
    MAX(camc.CAMSALDO) AS SALDO_MAXIMO
FROM CUSTOACUMULADOMOVTOCOMB camc
INNER JOIN PRODU p ON p.PROCODIGO = camc.PROCODIGO
WHERE camc.PROCODIGO = ?
GROUP BY camc.PROCODIGO, p.PRODESCRICAO, camc.EMPCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CUSTOACUMULADOMOVTOCOMB** | 84.902 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | ~178.187 | 1:0.48 | Produtos |

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_EMPRESA_MOVTOCOMB** - Índice em EMPCODIGO

### Índices Sugeridos

```sql
CREATE INDEX IDX_CAMC_PRODUTO ON CUSTOACUMULADOMOVTOCOMB(PROCODIGO);
CREATE INDEX IDX_CAMC_DATA ON CUSTOACUMULADOMOVTOCOMB(CAMDATA);
CREATE INDEX IDX_CAMC_EMP_PRODUTO ON CUSTOACUMULADOMOVTOCOMB(EMPCODIGO, PROCODIGO);
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

final class FirebirdCustoacumuladomovtocomb extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CUSTOACUMULADOMOVTOCOMB';
    
    protected $primaryKey = 'ID_CAMC';
    public $incrementing = true;

    protected $casts = [
        'ID_CAMC' => 'integer',
        'EMPCODIGO' => 'integer',
        'PROCODIGO' => 'string',
        'CAMDATA' => 'datetime',
        'CAMCUSTO' => 'decimal:4',
        'CAMSALDO' => 'decimal:4',
        'CAMSOMACHAVE' => 'string',
    ];

    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CAMDATA', [$dataInicio, $dataFim]);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

