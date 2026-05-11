# DEVNFPFO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DEVNFPFO (Devolução de Nota Fiscal de Pedido de Fornecedor)
- **Total de Registros**: 47.684
- **Total de Colunas**: 8
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 1 (PRODU)
- **Índices**: 3 (IDX_DEVNFPFO_ID_PEDIDO, IDX_DEVNFPFO_NFCODIGO, IDX_DEVNFPFO_NSEQ)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**DEVNFPFO** é uma tabela que armazena devoluções de notas fiscais de pedidos de fornecedores, detalhadas por produto. Com **47.684 registros**, representa registros de devoluções de notas fiscais de pedidos de fornecedores vinculadas a produtos específicos, permitindo rastreamento detalhado de devoluções e controle fiscal.

Esta tabela funciona como **detalhamento de devolução de nota fiscal de pedido de fornecedor** e permite:
- Rastrear devoluções de notas fiscais de pedidos de fornecedores por produto
- Manter histórico de devoluções detalhadas por item
- Controlar quais produtos foram devolvidos em cada devolução
- Suportar controle fiscal de devoluções detalhadas
- Facilitar relatórios de devoluções por produto

Cada registro representa um item de devolução de nota fiscal de pedido de fornecedor relacionado a um produto específico, contendo:
- Identificador único do registro (ID)
- Sequencial da devolução (NSEQ)
- Identificador do pedido relacionado (ID_PEDIDO) - lógica → PEDFO
- Código da nota fiscal (NFCODIGO) - lógica → NOTAS
- Código da empresa (EMPCODIGO) - lógica → EMPRESA
- Código do produto (PROCODIGO) - FK → PRODU
- Quantidade devolvida (QTDADE)
- Sequencial do item no documento (SEQITEMDOC)

O sistema utiliza esta tabela para controlar devoluções detalhadas de notas fiscais de pedidos de fornecedores, permitindo rastreamento completo de devoluções por produto e controle fiscal.

**Observação Importante:** DEVNFPFO é uma tabela de detalhamento que conecta devoluções de notas fiscais de pedidos de fornecedores com produtos. Com 47.684 registros e índices em ID_PEDIDO, NFCODIGO e NSEQ, indica uso extensivo desta funcionalidade. Possui foreign key direta para PRODU e relacionamentos lógicos com PEDFO, NOTAS e EMPRESA.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | Identificador único do registro (PK) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔗 | VARCHAR(14) | | Código do produto (FK → PRODU) |
| **ID_PEDIDO** | INTEGER | | Identificador do pedido relacionado (lógica → PEDFO) |
| **NFCODIGO** | VARCHAR(14) | | Código da nota fiscal (lógica → NOTAS) |
| **EMPCODIGO** | SMALLINT | ✓ | Código da empresa (lógica → EMPRESA) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NSEQ** | NUMERIC(16,4) | ✓ | Sequencial da devolução |
| **QTDADE** | NUMERIC(16,4) | | Quantidade devolvida |
| **SEQITEMDOC** | INTEGER | | Sequencial do item no documento |

**Primary Key:** ID

**Foreign Keys:**
- `PROCODIGO` → `PRODU.PROCODIGO` (Constraint: PRODU_DEVNFPFO)

**Índices:**
- `IDX_DEVNFPFO_ID_PEDIDO` em `ID_PEDIDO`
- `IDX_DEVNFPFO_NFCODIGO` em `NFCODIGO`
- `IDX_DEVNFPFO_NSEQ` em `NSEQ`

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DEVNFPFO Referencia (1 FK):

#### 1. PRODU - Produtos
**Relacionamento:**
```
DEVNFPFO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_DEVNFPFO
```

**Descrição**: Cada item de devolução está vinculado a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto devolvido em cada item de devolução.

---

### DEVNFPFO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia DEVNFPFO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDFO → Outras Operações do Pedido de Fornecedor

**Fluxo:** DEVNFPFO → PEDFO → Operações

**Descrição:** Através do pedido de fornecedor, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por pedido de fornecedor.

---

### Via NFCODIGO → NOTAS → Outras Operações da Nota Fiscal

**Fluxo:** DEVNFPFO → NOTAS → Operações

**Descrição:** Através da nota fiscal, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por nota fiscal.

---

### Via EMPCODIGO → EMPRESA → Outras Operações da Empresa

**Fluxo:** DEVNFPFO → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Devolução de Nota Fiscal

**Objetivo:** Obter visão completa de uma devolução incluindo informações do pedido de fornecedor, nota fiscal e produto.

**Fluxo:**
```
DEVNFPFO (ID_PEDIDO, NFCODIGO, EMPCODIGO, PROCODIGO)
  ↓
PEDFO (PEFCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.NSEQ AS SEQUENCIAL_DEVOLUCAO,
    dev.ID_PEDIDO,
    pf.PEFCODIGO,
    pf.PEFDTEMIS AS DATA_PEDIDO,
    c.CLINOMEFANT AS FORNECEDOR,
    dev.NFCODIGO,
    n.NFNUMERO AS NUMERO_NOTA,
    n.NFDATAEMISSAO AS DATA_EMISSAO_NOTA,
    dev.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    dev.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    dev.QTDADE AS QUANTIDADE_DEVOLVIDA,
    dev.SEQITEMDOC AS SEQUENCIAL_ITEM
FROM DEVNFPFO dev
INNER JOIN PRODU p ON p.PROCODIGO = dev.PROCODIGO
LEFT JOIN PEDFO pf ON pf.PEFCODIGO = dev.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = pf.CLICODIGO
LEFT JOIN NOTAS n ON n.NFCODIGO = dev.NFCODIGO
                 AND n.EMPCODIGO = dev.EMPCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dev.EMPCODIGO
WHERE dev.ID = ?;
```

---

### Exemplo 2: Análise de Devoluções por Pedido de Fornecedor

**Objetivo:** Identificar todas as devoluções de notas fiscais relacionadas a um pedido de fornecedor específico.

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.NSEQ AS SEQUENCIAL_DEVOLUCAO,
    dev.NFCODIGO,
    n.NFNUMERO AS NUMERO_NOTA,
    dev.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    dev.QTDADE AS QUANTIDADE_DEVOLVIDA,
    COUNT(*) OVER (PARTITION BY dev.ID_PEDIDO) AS TOTAL_ITENS_DEVOLUCAO_PEDIDO
FROM DEVNFPFO dev
INNER JOIN PRODU p ON p.PROCODIGO = dev.PROCODIGO
LEFT JOIN NOTAS n ON n.NFCODIGO = dev.NFCODIGO
                 AND n.EMPCODIGO = dev.EMPCODIGO
WHERE dev.ID_PEDIDO = ?
ORDER BY dev.NSEQ DESC, dev.SEQITEMDOC;
```

---

### Exemplo 3: Análise de Devoluções por Produto

**Objetivo:** Identificar distribuição de devoluções por produto.

**Query SQL:**
```sql
SELECT
    dev.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    COUNT(*) AS TOTAL_DEVOLUCOES,
    SUM(dev.QTDADE) AS QUANTIDADE_TOTAL_DEVOLVIDA,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT dev.NFCODIGO) AS TOTAL_NOTAS_AFETADAS
FROM DEVNFPFO dev
INNER JOIN PRODU p ON p.PROCODIGO = dev.PROCODIGO
WHERE dev.PROCODIGO IS NOT NULL
GROUP BY dev.PROCODIGO, p.PRODESCRICAO
ORDER BY TOTAL_DEVOLUCOES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Item de Devolução

**Objetivo:** Obter informações de um item de devolução específico.

```sql
SELECT
    ID,
    NSEQ AS SEQUENCIAL_DEVOLUCAO,
    ID_PEDIDO,
    NFCODIGO,
    EMPCODIGO,
    PROCODIGO,
    QTDADE AS QUANTIDADE_DEVOLVIDA,
    SEQITEMDOC AS SEQUENCIAL_ITEM
FROM DEVNFPFO
WHERE ID = ?;
```

---

### 2. Listar Itens de Devolução de um Pedido

**Objetivo:** Obter todos os itens de devolução relacionados a um pedido de fornecedor específico.

```sql
SELECT
    ID,
    NSEQ AS SEQUENCIAL_DEVOLUCAO,
    NFCODIGO,
    PROCODIGO,
    QTDADE AS QUANTIDADE_DEVOLVIDA,
    SEQITEMDOC AS SEQUENCIAL_ITEM
FROM DEVNFPFO
WHERE ID_PEDIDO = ?
ORDER BY NSEQ DESC, SEQITEMDOC;
```

---

### 3. Análise de Devoluções por Fornecedor

**Objetivo:** Identificar distribuição de devoluções por fornecedor.

**Query SQL:**
```sql
SELECT
    c.CLICODIGO,
    c.CLINOMEFANT AS FORNECEDOR,
    COUNT(*) AS TOTAL_ITENS_DEVOLVIDOS,
    SUM(dev.QTDADE) AS QUANTIDADE_TOTAL_DEVOLVIDA,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DEVNFPFO dev
LEFT JOIN PEDFO pf ON pf.PEFCODIGO = dev.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = pf.CLICODIGO
WHERE c.CLICODIGO IS NOT NULL
GROUP BY c.CLICODIGO, c.CLINOMEFANT
ORDER BY TOTAL_ITENS_DEVOLVIDOS DESC;
```

---

### 4. Análise de Devoluções por Período

**Objetivo:** Identificar distribuição de devoluções ao longo do tempo através dos pedidos de fornecedores.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM pf.PEFDTEMIS) AS ANO,
    EXTRACT(MONTH FROM pf.PEFDTEMIS) AS MES,
    COUNT(*) AS TOTAL_ITENS_DEVOLVIDOS,
    SUM(dev.QTDADE) AS QUANTIDADE_TOTAL_DEVOLVIDA,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DEVNFPFO dev
LEFT JOIN PEDFO pf ON pf.PEFCODIGO = dev.ID_PEDIDO
WHERE pf.PEFDTEMIS IS NOT NULL
GROUP BY EXTRACT(YEAR FROM pf.PEFDTEMIS), EXTRACT(MONTH FROM pf.PEFDTEMIS)
ORDER BY ANO DESC, MES DESC;
```

---

### 5. Análise de Devoluções Órfãs

**Objetivo:** Identificar itens de devolução sem pedido, nota fiscal ou produto válidos.

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.ID_PEDIDO,
    dev.NFCODIGO,
    dev.PROCODIGO,
    dev.EMPCODIGO,
    CASE
        WHEN pf.PEFCODIGO IS NULL THEN 'SEM_PEDIDO'
        WHEN n.NFCODIGO IS NULL THEN 'SEM_NOTA'
        WHEN p.PROCODIGO IS NULL THEN 'SEM_PRODUTO'
        ELSE 'OK'
    END AS STATUS
FROM DEVNFPFO dev
LEFT JOIN PEDFO pf ON pf.PEFCODIGO = dev.ID_PEDIDO
LEFT JOIN NOTAS n ON n.NFCODIGO = dev.NFCODIGO
                 AND n.EMPCODIGO = dev.EMPCODIGO
LEFT JOIN PRODU p ON p.PROCODIGO = dev.PROCODIGO
WHERE pf.PEFCODIGO IS NULL OR n.NFCODIGO IS NULL OR p.PROCODIGO IS NULL
ORDER BY dev.ID;
```

---

### 6. Relatório Completo de Devoluções

**Objetivo:** Analisar distribuição completa de devoluções de notas fiscais de pedidos de fornecedores no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_ITENS_DEVOLVIDOS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT NFCODIGO) AS TOTAL_NOTAS_AFETADAS,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS_AFETADOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS_AFETADAS,
    SUM(QTDADE) AS QUANTIDADE_TOTAL_DEVOLVIDA,
    COUNT(CASE WHEN ID_PEDIDO IS NULL THEN 1 END) AS ITENS_SEM_PEDIDO,
    COUNT(CASE WHEN NFCODIGO IS NULL THEN 1 END) AS ITENS_SEM_NOTA,
    COUNT(CASE WHEN PROCODIGO IS NULL THEN 1 END) AS ITENS_SEM_PRODUTO
FROM DEVNFPFO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DEVNFPFO | Tipo |
|--------|-----------|----------------------|------|
| **DEVNFPFO** | 47.684 | 1:1 | **TABELA PRINCIPAL** |
| PEDFO | 129.041 | 1:2.7 | Pedidos de fornecedores (média de 2.7 itens de devolução por pedido) |
| PRODU | 178.187 | 1:0.27 | Produtos (média de 0.27 itens de devolução por produto) |

**Interpretação:**
- **47.684 itens de devolução** registrados no sistema
- **Média de 2.7 itens de devolução por pedido de fornecedor** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IDX_DEVNFPFO_ID_PEDIDO** em `ID_PEDIDO` - Otimiza consultas por pedido
2. **IDX_DEVNFPFO_NFCODIGO** em `NFCODIGO` - Otimiza consultas por nota fiscal
3. **IDX_DEVNFPFO_NSEQ** em `NSEQ` - Otimiza consultas por sequencial

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_DEVNFPFO_EMP ON DEVNFPFO(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 2: Busca combinada pedido + produto (consultas frequentes)
CREATE INDEX IDX_DEVNFPFO_PEDIDO_PRODUTO ON DEVNFPFO(ID_PEDIDO, PROCODIGO)
    WHERE ID_PEDIDO IS NOT NULL AND PROCODIGO IS NOT NULL;
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

final class FirebirdDevnfpfo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DEVNFPFO';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'NSEQ' => 'decimal:4',
        'ID_PEDIDO' => 'integer',
        'NFCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'PROCODIGO' => 'string',
        'QTDADE' => 'decimal:4',
        'SEQITEMDOC' => 'integer',
    ];

    // Relacionamento com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Relacionamento lógico com PEDFO
    public function pedidoFornecedor()
    {
        return $this->belongsTo(FirebirdPedfo::class, 'ID_PEDIDO', 'PEFCODIGO');
    }

    // Relacionamento lógico com NOTAS
    public function notaFiscal()
    {
        return $this->belongsTo(FirebirdNotas::class, 'NFCODIGO', 'NFCODIGO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function scopePorPedido($query, int $pedidoCodigo)
    {
        return $query->where('ID_PEDIDO', $pedidoCodigo);
    }

    public function scopePorNotaFiscal($query, string $notaFiscalCodigo)
    {
        return $query->where('NFCODIGO', $notaFiscalCodigo);
    }

    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

