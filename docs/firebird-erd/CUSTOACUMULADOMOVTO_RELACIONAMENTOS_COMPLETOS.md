# CUSTOACUMULADOMOVTO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CUSTOACUMULADOMOVTO (Custo Acumulado de Movimentação)
- **Total de Registros**: 84.902
- **Total de Colunas**: 7
- **Chave Primária**: ID_CAM (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1 (IND_EMPRESA_MOVTO em EMPCODIGO)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CUSTOACUMULADOMOVTO** é uma tabela que armazena custos acumulados de movimentações de produtos por empresa. Com **84.902 registros**, representa histórico de custos acumulados calculados a partir de movimentações de estoque, permitindo análise de custos ao longo do tempo.

Esta tabela funciona como **registro de custos acumulados de movimentações** e permite:
- Armazenar custos acumulados por produto e empresa
- Rastrear saldos de custo ao longo do tempo
- Controlar data das movimentações
- Suportar soma de chave para agregações
- Facilitar análise de custos históricos

Cada registro representa um custo acumulado específico de uma movimentação de um produto (PROCODIGO) para uma empresa (EMPCODIGO), contendo:
- Identificador único (ID_CAM)
- Empresa (EMPCODIGO)
- Data da movimentação (CAMDATA)
- Produto (PROCODIGO)
- Custo acumulado (CAMCUSTO)
- Saldo acumulado (CAMSALDO)
- Soma de chave para agregações (CAMSOMACHAVE)

O sistema utiliza esta tabela para calcular e armazenar custos acumulados de movimentações, facilitando análises de custos históricos e relatórios financeiros.

**Observação Importante:** CUSTOACUMULADOMOVTO é uma tabela importante para análise de custos, com 84.902 registros. Existem variações similares: CUSTOACUMULADOMOVTOCOMB (combinações) e CUSTOACUMULADOMOVTOP (por operação).

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

### CUSTOACUMULADOMOVTO Referencia (1 FK):

#### 1. PRODU - Produtos
**Relacionamento:**
```
CUSTOACUMULADOMOVTO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CUSTOACUMULADOMOVTO
```

**Descrição**: Cada custo acumulado está vinculado a um produto específico.

---

### CUSTOACUMULADOMOVTO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CUSTOACUMULADOMOVTO diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Custo Acumulado

```sql
SELECT
    ID_CAM,
    EMPCODIGO,
    CAMDATA AS DATA_MOVIMENTACAO,
    PROCODIGO,
    CAMCUSTO AS CUSTO_ACUMULADO,
    CAMSALDO AS SALDO_ACUMULADO,
    CAMSOMACHAVE AS SOMA_CHAVE
FROM CUSTOACUMULADOMOVTO
WHERE ID_CAM = ?;
```

---

### 2. Análise de Custos por Produto

```sql
SELECT
    cam.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    cam.EMPCODIGO,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(cam.CAMCUSTO) AS CUSTO_TOTAL_ACUMULADO,
    AVG(cam.CAMCUSTO) AS CUSTO_MEDIO,
    MAX(cam.CAMSALDO) AS SALDO_MAXIMO,
    MIN(cam.CAMDATA) AS PRIMEIRA_MOVIMENTACAO,
    MAX(cam.CAMDATA) AS ULTIMA_MOVIMENTACAO
FROM CUSTOACUMULADOMOVTO cam
INNER JOIN PRODU p ON p.PROCODIGO = cam.PROCODIGO
WHERE cam.PROCODIGO = ?
GROUP BY cam.PROCODIGO, p.PRODESCRICAO, cam.EMPCODIGO;
```

---

### 3. Análise de Custos por Período

```sql
SELECT
    EXTRACT(YEAR FROM CAMDATA) AS ANO,
    EXTRACT(MONTH FROM CAMDATA) AS MES,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    SUM(CAMCUSTO) AS CUSTO_TOTAL_ACUMULADO,
    AVG(CAMCUSTO) AS CUSTO_MEDIO,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS
FROM CUSTOACUMULADOMOVTO
WHERE EMPCODIGO = ?
GROUP BY EXTRACT(YEAR FROM CAMDATA), EXTRACT(MONTH FROM CAMDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CUSTOACUMULADOMOVTO** | 84.902 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | ~178.187 | 1:0.48 | Produtos (média de ~0.48 movimentações por produto) |

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_EMPRESA_MOVTO** - Índice em EMPCODIGO

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto (consultas frequentes)
CREATE INDEX IDX_CAM_PRODUTO ON CUSTOACUMULADOMOVTO(PROCODIGO);

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_CAM_DATA ON CUSTOACUMULADOMOVTO(CAMDATA);

-- Índice 3: Busca composta por empresa e produto
CREATE INDEX IDX_CAM_EMP_PRODUTO ON CUSTOACUMULADOMOVTO(EMPCODIGO, PROCODIGO);

-- Índice 4: Busca composta por empresa e data
CREATE INDEX IDX_CAM_EMP_DATA ON CUSTOACUMULADOMOVTO(EMPCODIGO, CAMDATA);
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

final class FirebirdCustoacumuladomovto extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CUSTOACUMULADOMOVTO';
    
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

