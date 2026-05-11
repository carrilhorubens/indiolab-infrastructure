# CUSTOACUMULADOMOVTOP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CUSTOACUMULADOMOVTOP (Custo Acumulado de Movimentação - Por Operação)
- **Total de Registros**: 84.902
- **Total de Colunas**: 7
- **Chave Primária**: ID_CAM (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1 (IND_EMPRESA_MOVTOP em EMPCODIGO)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CUSTOACUMULADOMOVTOP** é uma tabela que armazena custos acumulados de movimentações de produtos por operação por empresa. Com **84.902 registros**, representa histórico de custos acumulados calculados a partir de movimentações de estoque relacionadas a operações específicas.

Esta tabela funciona como **registro de custos acumulados de movimentações por operação** e permite:
- Armazenar custos acumulados por produto e empresa em contexto de operações
- Rastrear saldos de custo ao longo do tempo para operações específicas
- Controlar data das movimentações
- Suportar soma de chave para agregações
- Facilitar análise de custos históricos por operação

Cada registro representa um custo acumulado específico de uma movimentação de um produto (PROCODIGO) para uma empresa (EMPCODIGO) em contexto de operação específica, contendo:
- Identificador único (ID_CAM)
- Empresa (EMPCODIGO)
- Data da movimentação (CAMDATA)
- Produto (PROCODIGO)
- Custo acumulado (CAMCUSTO)
- Saldo acumulado (CAMSALDO)
- Soma de chave para agregações (CAMSOMACHAVE)

O sistema utiliza esta tabela para calcular e armazenar custos acumulados de movimentações relacionadas a operações específicas, facilitando análises de custos históricos e relatórios financeiros por tipo de operação.

**Observação Importante:** CUSTOACUMULADOMOVTOP é similar a CUSTOACUMULADOMOVTO, mas específica para movimentações relacionadas a operações específicas. Com 84.902 registros, indica uso extensivo desta funcionalidade.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_CAM** 🔑 | INTEGER | ✓ | Identificador único do registro |

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

**Primary Key:** ID_CAM

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CUSTOACUMULADOMOVTOP Referencia (1 FK):

#### 1. PRODU - Produtos
**Relacionamento:**
```
CUSTOACUMULADOMOVTOP.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CUSTOACUMULADOMOVTOP
```

**Descrição**: Cada custo acumulado está vinculado a um produto específico.

---

### CUSTOACUMULADOMOVTOP é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CUSTOACUMULADOMOVTOP diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Custo Acumulado por Operação

```sql
SELECT
    ID_CAM,
    EMPCODIGO,
    CAMDATA AS DATA_MOVIMENTACAO,
    PROCODIGO,
    CAMCUSTO AS CUSTO_ACUMULADO,
    CAMSALDO AS SALDO_ACUMULADO,
    CAMSOMACHAVE AS SOMA_CHAVE
FROM CUSTOACUMULADOMOVTOP
WHERE ID_CAM = ?;
```

---

### 2. Análise de Custos por Operação e Produto

```sql
SELECT
    camp.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    camp.EMPCODIGO,
    camp.CAMSOMACHAVE AS OPERACAO,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(camp.CAMCUSTO) AS CUSTO_TOTAL_ACUMULADO,
    AVG(camp.CAMCUSTO) AS CUSTO_MEDIO
FROM CUSTOACUMULADOMOVTOP camp
INNER JOIN PRODU p ON p.PROCODIGO = camp.PROCODIGO
WHERE camp.EMPCODIGO = ?
GROUP BY camp.PROCODIGO, p.PRODESCRICAO, camp.EMPCODIGO, camp.CAMSOMACHAVE
ORDER BY camp.CAMSOMACHAVE, CUSTO_TOTAL_ACUMULADO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CUSTOACUMULADOMOVTOP** | 84.902 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | ~178.187 | 1:0.48 | Produtos |

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_EMPRESA_MOVTOP** - Índice em EMPCODIGO

### Índices Sugeridos

```sql
CREATE INDEX IDX_CAMP_PRODUTO ON CUSTOACUMULADOMOVTOP(PROCODIGO);
CREATE INDEX IDX_CAMP_DATA ON CUSTOACUMULADOMOVTOP(CAMDATA);
CREATE INDEX IDX_CAMP_EMP_PRODUTO ON CUSTOACUMULADOMOVTOP(EMPCODIGO, PROCODIGO);
CREATE INDEX IDX_CAMP_SOMA_CHAVE ON CUSTOACUMULADOMOVTOP(CAMSOMACHAVE);
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

final class FirebirdCustoacumuladomovtop extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CUSTOACUMULADOMOVTOP';
    
    protected $primaryKey = 'ID_CAM';
    public $incrementing = true;

    protected $casts = [
        'ID_CAM' => 'integer',
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

    public function scopePorOperacao($query, string $somaChave)
    {
        return $query->where('CAMSOMACHAVE', $somaChave);
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

