# COMPOPDC - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOPDC (Composição x Ordem de Produção)
- **Total de Registros**: 2.586.493
- **Total de Colunas**: 7
- **Chave Primária**: SEQ (simples)
- **Chaves Estrangeiras**: 0 (formais)
- **Índices**: 2 (IND_ID_PEDIDO, IND_PDCCODIGO)
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOPDC** é uma tabela de rastreamento que armazena histórico de componentes utilizados em ordens de produção e pedidos. Com **2.586.493 registros**, representa um histórico extensivo de consumo de componentes em produção, permitindo rastreabilidade completa de materiais utilizados.

Esta tabela funciona como **histórico de consumo de componentes em produção** e permite:
- Rastrear quais componentes foram utilizados em cada ordem de produção
- Associar componentes a produtos específicos de pedidos
- Manter histórico temporal de consumo de materiais
- Suportar análise de consumo real vs planejado
- Facilitar auditoria de produção
- Suportar cálculo de custos de produção

Cada registro representa um consumo específico de componente em uma ordem de produção ou pedido, contendo:
- Identificador único do registro (SEQ)
- Código da ordem de produção (PDCCODIGO)
- Código do pedido (ID_PEDIDO)
- Código do produto da ordem de produção (PDCPROCODIGO)
- Código do produto componente utilizado (PROCODIGO)
- Quantidade consumida (QTDE)
- Data do consumo (DATA)

O sistema utiliza esta tabela para manter histórico completo de consumo de componentes, permitindo análise de eficiência de produção, cálculo de custos reais, e auditoria de materiais utilizados.

**Observação Importante:** COMPOPDC é uma tabela de histórico muito volumosa com 2.586.493 registros. Com índices em ID_PEDIDO e PDCCODIGO, indica consultas frequentes por pedido e ordem de produção. Esta tabela é essencial para rastreabilidade e auditoria de produção.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SEQ** 🔑 | INTEGER | ✓ | Identificador único sequencial do registro |

### Relacionamentos com Produção
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PDCCODIGO** | INTEGER | | Código da ordem de produção (lógica → PDCAO) |
| **ID_PEDIDO** | INTEGER | | Código do pedido (lógica → PEDID) |
| **PDCPROCODIGO** | VARCHAR(37) | | Código do produto da ordem de produção (lógica → PRODU) |

### Informações do Componente
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** | VARCHAR(37) | | Código do produto componente utilizado (lógica → PRODU) |
| **QTDE** | NUMERIC(16,4) | | Quantidade consumida do componente |

### Controle Temporal
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATA** | DATE | | Data do consumo do componente |

**Primary Key:** SEQ

**Observações sobre Campos:**
- **SEQ**: Identificador único sequencial gerado automaticamente.
- **PDCCODIGO**: Ordem de produção onde o componente foi utilizado.
- **ID_PEDIDO**: Pedido relacionado ao consumo do componente.
- **PDCPROCODIGO**: Produto que está sendo produzido na ordem de produção.
- **PROCODIGO**: Produto componente que foi consumido/utilizado.
- **QTDE**: Quantidade real do componente que foi consumida.
- **DATA**: Data em que o componente foi consumido/utilizado.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOPDC Referencia (0 FKs Formais):

**Nenhuma foreign key formal** está definida na tabela COMPOPDC. No entanto, há relacionamentos lógicos importantes:

#### 1. PDCAO - Ordens de Produção (Lógico)
**Relacionamento Lógico:**
```
COMPOPDC.PDCCODIGO → PDCAO.PDCCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma ordem de produção específica.

**Informações da Tabela PDCAO:**
- **Total:** 3.201.636 ordens de produção
- **PK:** (PDCCODIGO, EMPCODIGO)
- **Colunas:** 31 campos

**Uso:** Identificar a ordem de produção do consumo, análises de consumo por OP.

---

#### 2. PEDID - Pedidos (Lógico)
**Relacionamento Lógico:**
```
COMPOPDC.ID_PEDIDO → PEDID.ID_PEDIDO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a um pedido específico.

**Informações da Tabela PEDID:**
- **Total:** 3.099.176 pedidos
- **PK:** ID_PEDIDO
- **Colunas:** 173 campos

**Uso:** Identificar o pedido do consumo, análises de consumo por pedido.

---

#### 3. PRODU - Produtos (Componente) (Lógico)
**Relacionamento Lógico:**
```
COMPOPDC.PROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a um produto componente específico.

**Uso:** Identificar o componente consumido, análises de consumo por componente.

---

#### 4. PRODU - Produtos (Produzido) (Lógico)
**Relacionamento Lógico:**
```
COMPOPDC.PDCPROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado ao produto que está sendo produzido.

**Uso:** Identificar o produto sendo produzido, análises de consumo por produto produzido.

---

### COMPOPDC é Referenciada Por

**Nenhuma tabela** referencia COMPOPDC diretamente. Esta é uma tabela folha utilizada para histórico e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PDCCODIGO → PDCAO → PRODU (Produto Produzido)

**Fluxo:** COMPOPDC → PDCAO → PRODU

**Descrição:** Através da ordem de produção, é possível identificar o produto que está sendo produzido.

**Uso:** Análises de consumo por produto produzido, cálculo de eficiência de produção.

---

### Via ID_PEDIDO → PEDID → CLIEN (Cliente)

**Fluxo:** COMPOPDC → PEDID → CLIEN

**Descrição:** Através do pedido, é possível identificar o cliente que solicitou a produção.

**Uso:** Análises de consumo por cliente, cálculo de custos por cliente.

---

### Via PROCODIGO → PRODU → COMPO (Composição Planejada)

**Fluxo:** COMPOPDC → PRODU → COMPO

**Descrição:** Através do componente, é possível identificar a composição planejada vs consumo real.

**Uso:** Comparar consumo real vs planejado, análise de eficiência.

---

### Via PDCCODIGO → PDCAO → EMPRESA (Empresa)

**Fluxo:** COMPOPDC → PDCAO → EMPRESA

**Descrição:** Através da ordem de produção, é possível identificar a empresa.

**Uso:** Análises de consumo por empresa, relatórios multi-empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Consumo em Ordem de Produção

**Objetivo:** Obter visão completa de consumo de componentes em uma ordem de produção específica.

**Fluxo:**
```
COMPOPDC (PDCCODIGO, PROCODIGO, QTDE, DATA)
  ↓
PDCAO (PDCCODIGO, PROCODIGO)
  ↓
PRODU (PROCODIGO) - Produto Produzido
  ↓
PRODU (PROCODIGO) - Componente
```

**Query SQL:**
```sql
SELECT
    cpd.SEQ,
    cpd.PDCCODIGO,
    pdc.PROCODIGO AS PRODUTO_PRODUZIDO,
    pr1.PRODESCRICAO AS DESCRICAO_PRODUTO_PRODUZIDO,
    cpd.PROCODIGO AS PRODUTO_COMPONENTE,
    pr2.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpd.QTDE AS QUANTIDADE_CONSUMIDA,
    cpd.DATA AS DATA_CONSUMO,
    cpd.ID_PEDIDO,
    pd.PEDCODIGO AS CODIGO_PEDIDO
FROM COMPOPDC cpd
LEFT JOIN PDCAO pdc ON pdc.PDCCODIGO = cpd.PDCCODIGO
LEFT JOIN PRODU pr1 ON pr1.PROCODIGO = pdc.PROCODIGO
LEFT JOIN PRODU pr2 ON pr2.PROCODIGO = cpd.PROCODIGO
LEFT JOIN PEDID pd ON pd.ID_PEDIDO = cpd.ID_PEDIDO
WHERE cpd.PDCCODIGO = ?
ORDER BY cpd.DATA, cpd.PROCODIGO;
```

---

### Exemplo 2: Comparação Consumo Real vs Planejado

**Objetivo:** Comparar consumo real de componentes com a composição planejada.

**Fluxo:**
```
COMPOPDC (PDCCODIGO, PROCODIGO, QTDE)
  ↓
PDCAO (PDCCODIGO, PROCODIGO, PDCQTDEPEDIDO)
  ↓
COMPO (PROCODIGO, PROCODIGO2, CMPQTDADE)
```

**Query SQL:**
```sql
SELECT
    cpd.PDCCODIGO,
    pdc.PROCODIGO AS PRODUTO_PRODUZIDO,
    pr1.PRODESCRICAO AS DESCRICAO_PRODUTO,
    cpd.PROCODIGO AS PRODUTO_COMPONENTE,
    pr2.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    co.CMPQTDADE * pdc.PDCQTDEPEDIDO AS QUANTIDADE_PLANEJADA,
    SUM(cpd.QTDE) AS QUANTIDADE_REAL_CONSUMIDA,
    SUM(cpd.QTDE) - (co.CMPQTDADE * pdc.PDCQTDEPEDIDO) AS DIFERENCA,
    CASE 
        WHEN SUM(cpd.QTDE) > (co.CMPQTDADE * pdc.PDCQTDEPEDIDO) THEN 'ACIMA_DO_PLANEJADO'
        WHEN SUM(cpd.QTDE) < (co.CMPQTDADE * pdc.PDCQTDEPEDIDO) THEN 'ABAIXO_DO_PLANEJADO'
        ELSE 'DENTRO_DO_PLANEJADO'
    END AS STATUS_CONSUMO
FROM COMPOPDC cpd
INNER JOIN PDCAO pdc ON pdc.PDCCODIGO = cpd.PDCCODIGO
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = pdc.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = cpd.PROCODIGO
LEFT JOIN COMPO co ON co.PROCODIGO = pdc.PROCODIGO
  AND co.PROCODIGO2 = cpd.PROCODIGO
WHERE cpd.PDCCODIGO = ?
GROUP BY cpd.PDCCODIGO, pdc.PROCODIGO, pr1.PRODESCRICAO, cpd.PROCODIGO, pr2.PRODESCRICAO, co.CMPQTDADE, pdc.PDCQTDEPEDIDO
ORDER BY ABS(SUM(cpd.QTDE) - (co.CMPQTDADE * pdc.PDCQTDEPEDIDO)) DESC;
```

---

### Exemplo 3: Análise de Consumo por Pedido

**Objetivo:** Obter consumo total de componentes por pedido.

**Fluxo:**
```
COMPOPDC (ID_PEDIDO, PROCODIGO, QTDE)
  ↓
PEDID (ID_PEDIDO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cpd.ID_PEDIDO,
    pd.PEDCODIGO AS CODIGO_PEDIDO,
    cl.CLINOMEFANT AS CLIENTE,
    cpd.PROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    SUM(cpd.QTDE) AS QUANTIDADE_TOTAL_CONSUMIDA,
    COUNT(*) AS TOTAL_REGISTROS_CONSUMO,
    MIN(cpd.DATA) AS PRIMEIRA_DATA_CONSUMO,
    MAX(cpd.DATA) AS ULTIMA_DATA_CONSUMO
FROM COMPOPDC cpd
LEFT JOIN PEDID pd ON pd.ID_PEDIDO = cpd.ID_PEDIDO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = pd.CLICODIGO
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpd.PROCODIGO
WHERE cpd.ID_PEDIDO = ?
GROUP BY cpd.ID_PEDIDO, pd.PEDCODIGO, cl.CLINOMEFANT, cpd.PROCODIGO, pr.PRODESCRICAO
ORDER BY QUANTIDADE_TOTAL_CONSUMIDA DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Consumo de Componentes em Ordem de Produção

**Objetivo:** Obter todos os componentes consumidos em uma ordem de produção específica.

```sql
SELECT
    SEQ,
    PROCODIGO AS PRODUTO_COMPONENTE,
    QTDE AS QUANTIDADE_CONSUMIDA,
    DATA AS DATA_CONSUMO,
    ID_PEDIDO
FROM COMPOPDC
WHERE PDCCODIGO = ?
ORDER BY DATA, PROCODIGO;
```

---

### 2. Listar Consumo de Componentes por Pedido

**Objetivo:** Obter todos os componentes consumidos relacionados a um pedido específico.

```sql
SELECT
    SEQ,
    PDCCODIGO AS ORDEM_PRODUCAO,
    PROCODIGO AS PRODUTO_COMPONENTE,
    QTDE AS QUANTIDADE_CONSUMIDA,
    DATA AS DATA_CONSUMO
FROM COMPOPDC
WHERE ID_PEDIDO = ?
ORDER BY DATA, PDCCODIGO;
```

---

### 3. Análise de Consumo por Componente

**Objetivo:** Identificar consumo total de um componente específico em todas as ordens de produção.

```sql
SELECT
    PDCCODIGO AS ORDEM_PRODUCAO,
    COUNT(*) AS TOTAL_REGISTROS,
    SUM(QTDE) AS QUANTIDADE_TOTAL_CONSUMIDA,
    MIN(DATA) AS PRIMEIRA_DATA_CONSUMO,
    MAX(DATA) AS ULTIMA_DATA_CONSUMO
FROM COMPOPDC
WHERE PROCODIGO = ?
GROUP BY PDCCODIGO
ORDER BY QUANTIDADE_TOTAL_CONSUMIDA DESC;
```

---

### 4. Análise de Consumo por Período

**Objetivo:** Identificar consumo de componentes em um período específico.

```sql
SELECT
    PROCODIGO AS PRODUTO_COMPONENTE,
    COUNT(DISTINCT PDCCODIGO) AS TOTAL_ORDENS_PRODUCAO,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(*) AS TOTAL_REGISTROS_CONSUMO,
    SUM(QTDE) AS QUANTIDADE_TOTAL_CONSUMIDA,
    AVG(QTDE) AS QUANTIDADE_MEDIA_CONSUMO
FROM COMPOPDC
WHERE DATA >= ?
  AND DATA <= ?
GROUP BY PROCODIGO
ORDER BY QUANTIDADE_TOTAL_CONSUMIDA DESC;
```

---

### 5. Análise de Consumo por Produto Produzido

**Objetivo:** Identificar consumo de componentes agrupado por produto produzido.

**Query SQL:**
```sql
SELECT
    cpd.PDCPROCODIGO AS PRODUTO_PRODUZIDO,
    pr1.PRODESCRICAO AS DESCRICAO_PRODUTO_PRODUZIDO,
    cpd.PROCODIGO AS PRODUTO_COMPONENTE,
    pr2.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    COUNT(DISTINCT cpd.PDCCODIGO) AS TOTAL_ORDENS_PRODUCAO,
    COUNT(*) AS TOTAL_REGISTROS_CONSUMO,
    SUM(cpd.QTDE) AS QUANTIDADE_TOTAL_CONSUMIDA,
    AVG(cpd.QTDE) AS QUANTIDADE_MEDIA_CONSUMO
FROM COMPOPDC cpd
LEFT JOIN PRODU pr1 ON pr1.PROCODIGO = cpd.PDCPROCODIGO
LEFT JOIN PRODU pr2 ON pr2.PROCODIGO = cpd.PROCODIGO
WHERE cpd.PDCPROCODIGO IS NOT NULL
GROUP BY cpd.PDCPROCODIGO, pr1.PRODESCRICAO, cpd.PROCODIGO, pr2.PRODESCRICAO
ORDER BY QUANTIDADE_TOTAL_CONSUMIDA DESC;
```

---

### 6. Análise de Consumo com Informações de Pedido

**Objetivo:** Obter consumo de componentes com informações completas do pedido.

**Query SQL:**
```sql
SELECT
    cpd.ID_PEDIDO,
    pd.PEDCODIGO AS CODIGO_PEDIDO,
    cl.CLINOMEFANT AS CLIENTE,
    cpd.PROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    SUM(cpd.QTDE) AS QUANTIDADE_TOTAL_CONSUMIDA,
    COUNT(*) AS TOTAL_REGISTROS_CONSUMO
FROM COMPOPDC cpd
LEFT JOIN PEDID pd ON pd.ID_PEDIDO = cpd.ID_PEDIDO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = pd.CLICODIGO
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpd.PROCODIGO
WHERE cpd.ID_PEDIDO IS NOT NULL
GROUP BY cpd.ID_PEDIDO, pd.PEDCODIGO, cl.CLINOMEFANT, cpd.PROCODIGO, pr.PRODESCRICAO
ORDER BY QUANTIDADE_TOTAL_CONSUMIDA DESC;
```

---

### 7. Relatório de Consumo por Ordem de Produção

**Objetivo:** Analisar consumo completo de componentes por ordem de produção.

**Query SQL:**
```sql
SELECT
    cpd.PDCCODIGO,
    pdc.PROCODIGO AS PRODUTO_PRODUZIDO,
    pr1.PRODESCRICAO AS DESCRICAO_PRODUTO,
    pdc.PDCQTDEPEDIDO AS QUANTIDADE_PRODUZIR,
    COUNT(DISTINCT cpd.PROCODIGO) AS TOTAL_COMPONENTES_DIFERENTES,
    COUNT(*) AS TOTAL_REGISTROS_CONSUMO,
    SUM(cpd.QTDE) AS QUANTIDADE_TOTAL_COMPONENTES_CONSUMIDOS,
    MIN(cpd.DATA) AS PRIMEIRA_DATA_CONSUMO,
    MAX(cpd.DATA) AS ULTIMA_DATA_CONSUMO
FROM COMPOPDC cpd
LEFT JOIN PDCAO pdc ON pdc.PDCCODIGO = cpd.PDCCODIGO
LEFT JOIN PRODU pr1 ON pr1.PROCODIGO = pdc.PROCODIGO
WHERE cpd.PDCCODIGO IS NOT NULL
GROUP BY cpd.PDCCODIGO, pdc.PROCODIGO, pr1.PRODESCRICAO, pdc.PDCQTDEPEDIDO
ORDER BY QUANTIDADE_TOTAL_COMPONENTES_CONSUMIDOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOPDC | Tipo |
|--------|-----------|---------------------|------|
| **COMPOPDC** | 2.586.493 | 1:1 | **TABELA PRINCIPAL** |
| PDCAO | 3.201.636 | 1.24:1 | Ordens de produção (média de 0.81 registros por OP) |
| PEDID | 3.099.176 | 1.20:1 | Pedidos (média de 0.83 registros por pedido) |
| PRODU | 178.187 | 0.069:1 | Produtos (média de 14.5 registros por produto) |

**Interpretação:**
- **2.586.493 registros de consumo** no histórico
- **81% das ordens de produção** têm pelo menos um registro de consumo (2.586.493 de 3.201.636)
- **83% dos pedidos** têm pelo menos um registro de consumo (2.586.493 de 3.099.176)
- **Uso extensivo** - indica rastreamento detalhado de consumo de componentes
- **Média de 14.5 registros por produto** - muitos produtos têm histórico extensivo de consumo

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_ID_PEDIDO** - Índice em ID_PEDIDO
2. **IND_PDCCODIGO** - Índice em PDCCODIGO

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por produto componente** - Para buscas por componente
3. **Índice por data** - Para buscas por período
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto componente (consultas frequentes)
CREATE INDEX IDX_COMPOPDC_PRODUTO_COMPONENTE ON COMPOPDC(PROCODIGO)
    WHERE PROCODIGO IS NOT NULL AND PROCODIGO != '';

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_COMPOPDC_DATA ON COMPOPDC(DATA)
    WHERE DATA IS NOT NULL;

-- Índice 3: Busca composta por ordem de produção e produto (consultas frequentes)
CREATE INDEX IDX_COMPOPDC_PDC_PRO ON COMPOPDC(PDCCODIGO, PROCODIGO);

-- Índice 4: Busca composta por pedido e produto (consultas frequentes)
CREATE INDEX IDX_COMPOPDC_PED_PRO ON COMPOPDC(ID_PEDIDO, PROCODIGO);

-- Índice 5: Busca composta por data e produto (consultas de período)
CREATE INDEX IDX_COMPOPDC_DATA_PRO ON COMPOPDC(DATA, PROCODIGO);
```

### Observações sobre Volume

- **Tabela muito grande** (2.586.493 registros) - Performance crítica
- **Índices existentes** - Em ID_PEDIDO e PDCCODIGO são essenciais
- **Consultas frequentes** - Histórico é consultado frequentemente para análises
- **Focar em índices compostos** - Consultas geralmente filtram por múltiplos campos
- **Considerar particionamento** - Por data para melhor performance em consultas históricas

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOPDC
WHERE SEQ IS NULL;

-- Verificar quantidades inválidas
SELECT *
FROM COMPOPDC
WHERE QTDE IS NOT NULL
  AND QTDE <= 0;

-- Verificar registros sem ordem de produção nem pedido
SELECT *
FROM COMPOPDC
WHERE PDCCODIGO IS NULL
  AND ID_PEDIDO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT SEQ, COUNT(*) AS QTD
FROM COMPOPDC
GROUP BY SEQ
HAVING COUNT(*) > 1;
```

### Verificar Integridade Lógica

```sql
-- Verificar ordens de produção inexistentes
SELECT DISTINCT cpd.PDCCODIGO
FROM COMPOPDC cpd
WHERE cpd.PDCCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM PDCAO pdc WHERE pdc.PDCCODIGO = cpd.PDCCODIGO);

-- Verificar pedidos inexistentes
SELECT DISTINCT cpd.ID_PEDIDO
FROM COMPOPDC cpd
WHERE cpd.ID_PEDIDO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM PEDID pd WHERE pd.ID_PEDIDO = cpd.ID_PEDIDO);

-- Verificar produtos componentes inexistentes
SELECT DISTINCT cpd.PROCODIGO
FROM COMPOPDC cpd
WHERE cpd.PROCODIGO IS NOT NULL
  AND cpd.PROCODIGO != ''
  AND NOT EXISTS (SELECT 1 FROM PRODU pr WHERE pr.PROCODIGO = cpd.PROCODIGO);
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

final class FirebirdCompopdc extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOPDC';
    
    protected $primaryKey = 'SEQ';
    public $incrementing = true;

    protected $casts = [
        'SEQ' => 'integer',
        'PDCCODIGO' => 'integer',
        'ID_PEDIDO' => 'integer',
        'PDCPROCODIGO' => 'string',
        'PROCODIGO' => 'string',
        'QTDE' => 'decimal:4',
        'DATA' => 'date',
    ];

    // Relacionamento lógico com PDCAO
    public function ordemProducao(): BelongsTo
    {
        return $this->belongsTo(FirebirdPdcao::class, 'PDCCODIGO', 'PDCCODIGO');
    }

    // Relacionamento lógico com PEDID
    public function pedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento lógico com PRODU (componente)
    public function produtoComponente(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Relacionamento lógico com PRODU (produzido)
    public function produtoProduzido(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PDCPROCODIGO', 'PROCODIGO');
    }

    // Scope para filtrar por ordem de produção
    public function scopePorOrdemProducao($query, int $pdcCodigo)
    {
        return $query->where('PDCCODIGO', $pdcCodigo);
    }

    // Scope para filtrar por pedido
    public function scopePorPedido($query, int $pedidoId)
    {
        return $query->where('ID_PEDIDO', $pedidoId);
    }

    // Scope para filtrar por produto componente
    public function scopePorProdutoComponente($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('DATA', [$dataInicio, $dataFim]);
    }

    // Método estático para buscar consumo de uma ordem de produção
    public static function buscarConsumoOrdemProducao(int $pdcCodigo): \Illuminate\Support\Collection
    {
        return self::where('PDCCODIGO', $pdcCodigo)
            ->with('produtoComponente')
            ->orderBy('DATA')
            ->orderBy('PROCODIGO')
            ->get();
    }

    // Método estático para calcular consumo total por componente
    public static function calcularConsumoTotalComponente(string $produtoCodigo, ?string $dataInicio = null, ?string $dataFim = null): float
    {
        $query = self::where('PROCODIGO', $produtoCodigo);
        
        if ($dataInicio && $dataFim) {
            $query->whereBetween('DATA', [$dataInicio, $dataFim]);
        }
        
        return (float)$query->sum('QTDE');
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - SEQ identifica unicamente cada registro
2. **Validação antes de inserir** - Verificar se entidades relacionadas existem
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de quantidades** - Verificar valores positivos e válidos

### Performance

1. **Tabela muito grande** - 2.586.493 registros, performance crítica
2. **Índices essenciais** - Em PDCCODIGO, ID_PEDIDO, PROCODIGO e DATA
3. **Índices compostos** - Para consultas combinadas frequentes
4. **Considerar particionamento** - Por data para melhor performance
5. **Consultas frequentes** - Histórico é consultado frequentemente

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de quantidades** - Verificar valores positivos

### Manutenção

1. **Revisão periódica** - Verificar registros órfãos
2. **Padronização** - Manter estrutura consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para auditoria
5. **Arquivamento** - Considerar arquivar registros antigos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

