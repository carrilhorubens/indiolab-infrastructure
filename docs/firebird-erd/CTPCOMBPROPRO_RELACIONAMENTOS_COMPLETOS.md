# CTPCOMBPROPRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTPCOMBPROPRO (Combinações Produto-Produto por Tipo de Pedido)
- **Total de Registros**: 29.510
- **Total de Colunas**: 13
- **Chave Primária**: Composta (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID)
- **Chaves Estrangeiras**: 4
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTPCOMBPROPRO** é uma tabela que armazena combinações produto-produto específicas por cliente e tipo de pedido, estendendo CLITPPED com configurações detalhadas de combinações. Com **29.510 registros**, representa configurações personalizadas de combinações de produtos para clientes específicos em tipos de pedido específicos, incluindo índices e preços de venda customizados.

Esta tabela funciona como **configurador de combinações produto-produto por tipo de pedido** e permite:
- Definir combinações de produtos personalizadas por cliente e tipo de pedido
- Armazenar índices específicos para cada produto na combinação
- Configurar preços de venda customizados por cliente e tipo de pedido
- Controlar múltiplos índices e preços para cada produto (índice 1, índice 2, preço 1, preço 2)
- Rastrear data de cadastro de cada combinação
- Suportar precificação diferenciada por cliente e tipo de pedido

Cada registro representa uma combinação específica de dois produtos (PROCODIGOA e PROCODIGOB) para um cliente específico (CLICODIGO) em um tipo de pedido específico (CCPTPPEDID), contendo:
- Identificação do cliente (CLICODIGO)
- Tipo de pedido (CCPTPPEDID)
- Produto A da combinação (PROCODIGOA)
- Produto B da combinação (PROCODIGOB)
- Índices do Produto A (CCINDICEPROA, CCINDICEPROA2)
- Preços de venda do Produto A (CCPCOVENDAPROA, CCPCOVENDAPROA2)
- Índices do Produto B (CCINDICEPROB, CCINDICEPROB2)
- Preços de venda do Produto B (CCPCOVENDAPROB, CCPCOVENDAPROB2)
- Data de cadastro da combinação (CCPDTCADASTRO)

O sistema utiliza esta tabela para personalizar combinações de produtos e precificação por cliente e tipo de pedido, permitindo que diferentes clientes tenham diferentes configurações para as mesmas combinações de produtos em diferentes tipos de pedido.

**Observação Importante:** CTPCOMBPROPRO estende CLITPPED com combinações produto-produto específicas, permitindo que cada cliente tenha suas próprias combinações de produtos com índices e preços específicos por tipo de pedido.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑 🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLITPPED) |
| **PROCODIGOA** 🔑 🔗 | VARCHAR(14) | ✓ | Código do produto A (PK + FK → PRODU) |
| **PROCODIGOB** 🔑 🔗 | VARCHAR(14) | ✓ | Código do produto B (PK + FK → PRODU) |
| **CCPTPPEDID** 🔑 🔗 | SMALLINT | ✓ | Código do tipo de pedido (PK + FK → CLITPPED) |

### Informações do Produto A
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCINDICEPROA** | NUMERIC(16,4) | | Índice 1 do produto A na combinação |
| **CCINDICEPROA2** | NUMERIC(16,4) | | Índice 2 do produto A na combinação |
| **CCPCOVENDAPROA** | NUMERIC(16,4) | | Preço de venda 1 do produto A |
| **CCPCOVENDAPROA2** | NUMERIC(16,4) | | Preço de venda 2 do produto A |

### Informações do Produto B
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCINDICEPROB** | NUMERIC(16,4) | | Índice 1 do produto B na combinação |
| **CCINDICEPROB2** | NUMERIC(16,4) | | Índice 2 do produto B na combinação |
| **CCPCOVENDAPROB** | NUMERIC(16,4) | | Preço de venda 1 do produto B |
| **CCPCOVENDAPROB2** | NUMERIC(16,4) | | Preço de venda 2 do produto B |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCPDTCADASTRO** | TIMESTAMP | | Data de cadastro da combinação |

**Primary Key:** (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente ao qual a combinação pertence.
- **CCPTPPEDID**: Tipo de pedido para o qual a combinação é válida.
- **PROCODIGOA e PROCODIGOB**: Dois produtos que formam a combinação.
- **Índices**: Valores numéricos que podem representar graus, medidas ou outros parâmetros específicos para produtos ópticos.
- **Preços de venda**: Permite múltiplos preços (1 e 2) para cada produto na combinação.
- **Data de cadastro**: Rastreia quando a combinação foi configurada.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTPCOMBPROPRO Referencia (4 FKs):

#### 1. CLITPPED - Configurações Cliente x Tipo de Pedido
**Relacionamento:**
```
CTPCOMBPROPRO.CLICODIGO, CTPCOMBPROPRO.CCPTPPEDID → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPCOMBPROPRO
```

**Descrição**: Cada combinação está vinculada a uma configuração cliente x tipo de pedido específica.

**Informações da Tabela CLITPPED:**
- **Total:** ~? configurações
- **PK:** (CLICODIGO, TPCODIGO)
- **Colunas:** Múltiplos campos

**Uso:** Obter configuração base do cliente para o tipo de pedido.

---

#### 2. PRODU - Produtos (2 FKs)

**2.1. PROCODIGOA - Produto A**
```
CTPCOMBPROPRO.PROCODIGOA → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CTPCOMBPROPRO
```

**2.2. PROCODIGOB - Produto B**
```
CTPCOMBPROPRO.PROCODIGOB → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CTPCOMBPROPROB
```

**Descrição**: Cada combinação está vinculada a dois produtos específicos (Produto A e Produto B).

**Informações da Tabela PRODU:**
- **Total:** ~178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar os produtos da combinação, validar existência dos produtos.

---

### CTPCOMBPROPRO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTPCOMBPROPRO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLICODIGO → CLIEN → Outras Operações do Cliente

**Fluxo:** CTPCOMBPROPRO → CLITPPED → CLIEN → Operações

**Descrição:** Através do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de combinações por cliente.

---

### Via PROCODIGOA/PROCODIGOB → PRODU → Informações dos Produtos

**Fluxo:** CTPCOMBPROPRO → PRODU → Informações

**Descrição:** Através dos produtos, é possível identificar informações relacionadas.

**Uso:** Análise de combinações por produto.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Combinação

**Objetivo:** Obter visão completa de uma combinação incluindo informações do cliente, tipo de pedido e produtos.

**Fluxo:**
```
CTPCOMBPROPRO (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID)
  ↓
CLITPPED (CLICODIGO, TPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.CCPTPPEDID AS TIPO_PEDIDO,
    tp.TPDESCRICAO AS DESCRICAO_TIPO_PEDIDO,
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.CCINDICEPROA AS INDICE_A1,
    ccp.CCINDICEPROA2 AS INDICE_A2,
    ccp.CCPCOVENDAPROA AS PRECO_A1,
    ccp.CCPCOVENDAPROA2 AS PRECO_A2,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROB AS INDICE_B1,
    ccp.CCINDICEPROB2 AS INDICE_B2,
    ccp.CCPCOVENDAPROB AS PRECO_B1,
    ccp.CCPCOVENDAPROB2 AS PRECO_B2,
    ccp.CCPDTCADASTRO AS DATA_CADASTRO
FROM CTPCOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
INNER JOIN CLITPPED ctp ON ctp.CLICODIGO = ccp.CLICODIGO AND ctp.TPCODIGO = ccp.CCPTPPEDID
INNER JOIN TPPEDID tp ON tp.TPCODIGO = ccp.CCPTPPEDID
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CLICODIGO = ?
  AND ccp.PROCODIGOA = ?
  AND ccp.PROCODIGOB = ?
  AND ccp.CCPTPPEDID = ?;
```

---

### Exemplo 2: Análise de Combinações por Cliente e Tipo de Pedido

**Objetivo:** Obter todas as combinações de um cliente em um tipo de pedido específico.

**Query SQL:**
```sql
SELECT
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROA AS INDICE_A1,
    ccp.CCPCOVENDAPROA AS PRECO_A1,
    ccp.CCINDICEPROB AS INDICE_B1,
    ccp.CCPCOVENDAPROB AS PRECO_B1
FROM CTPCOMBPROPRO ccp
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CLICODIGO = ?
  AND ccp.CCPTPPEDID = ?
ORDER BY ccp.PROCODIGOA, ccp.PROCODIGOB;
```

---

### Exemplo 3: Análise de Combinações por Produto

**Objetivo:** Identificar todas as combinações que incluem um produto específico.

**Query SQL:**
```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.CCPTPPEDID AS TIPO_PEDIDO,
    CASE 
        WHEN ccp.PROCODIGOA = ? THEN ccp.PROCODIGOB
        ELSE ccp.PROCODIGOA
    END AS PRODUTO_COMBINADO,
    CASE 
        WHEN ccp.PROCODIGOA = ? THEN ccp.CCINDICEPROB
        ELSE ccp.CCINDICEPROA
    END AS INDICE_COMBINADO,
    CASE 
        WHEN ccp.PROCODIGOA = ? THEN ccp.CCPCOVENDAPROB
        ELSE ccp.CCPCOVENDAPROA
    END AS PRECO_COMBINADO
FROM CTPCOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
WHERE ccp.PROCODIGOA = ?
   OR ccp.PROCODIGOB = ?
ORDER BY ccp.CLICODIGO, ccp.CCPTPPEDID;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Combinação

**Objetivo:** Obter informações de uma combinação específica.

```sql
SELECT
    CLICODIGO,
    PROCODIGOA,
    PROCODIGOB,
    CCPTPPEDID AS TIPO_PEDIDO,
    CCINDICEPROA AS INDICE_A1,
    CCINDICEPROA2 AS INDICE_A2,
    CCPCOVENDAPROA AS PRECO_A1,
    CCPCOVENDAPROA2 AS PRECO_A2,
    CCINDICEPROB AS INDICE_B1,
    CCINDICEPROB2 AS INDICE_B2,
    CCPCOVENDAPROB AS PRECO_B1,
    CCPCOVENDAPROB2 AS PRECO_B2,
    CCPDTCADASTRO AS DATA_CADASTRO
FROM CTPCOMBPROPRO
WHERE CLICODIGO = ?
  AND PROCODIGOA = ?
  AND PROCODIGOB = ?
  AND CCPTPPEDID = ?;
```

---

### 2. Listar Combinações de um Cliente

**Objetivo:** Obter todas as combinações de um cliente específico.

```sql
SELECT
    CCPTPPEDID AS TIPO_PEDIDO,
    PROCODIGOA,
    PROCODIGOB,
    CCINDICEPROA AS INDICE_A1,
    CCPCOVENDAPROA AS PRECO_A1,
    CCINDICEPROB AS INDICE_B1,
    CCPCOVENDAPROB AS PRECO_B1
FROM CTPCOMBPROPRO
WHERE CLICODIGO = ?
ORDER BY CCPTPPEDID, PROCODIGOA, PROCODIGOB;
```

---

### 3. Análise de Combinações por Tipo de Pedido

**Objetivo:** Identificar distribuição de combinações por tipo de pedido.

```sql
SELECT
    CCPTPPEDID AS TIPO_PEDIDO,
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT PROCODIGOA) AS TOTAL_PRODUTOS_A,
    COUNT(DISTINCT PROCODIGOB) AS TOTAL_PRODUTOS_B
FROM CTPCOMBPROPRO
GROUP BY CCPTPPEDID
ORDER BY TOTAL_COMBINACOES DESC;
```

---

### 4. Análise de Preços por Cliente

**Objetivo:** Calcular médias de preços de combinações por cliente.

```sql
SELECT
    CLICODIGO,
    COUNT(*) AS TOTAL_COMBINACOES,
    AVG(CCPCOVENDAPROA) AS MEDIA_PRECO_A1,
    AVG(CCPCOVENDAPROA2) AS MEDIA_PRECO_A2,
    AVG(CCPCOVENDAPROB) AS MEDIA_PRECO_B1,
    AVG(CCPCOVENDAPROB2) AS MEDIA_PRECO_B2
FROM CTPCOMBPROPRO
WHERE CLICODIGO = ?
GROUP BY CLICODIGO;
```

---

### 5. Análise de Combinações Mais Utilizadas

**Objetivo:** Identificar combinações produto-produto mais utilizadas.

**Query SQL:**
```sql
SELECT
    PROCODIGOA,
    PROCODIGOB,
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT CCPTPPEDID) AS TOTAL_TIPOS_PEDIDO
FROM CTPCOMBPROPRO
GROUP BY PROCODIGOA, PROCODIGOB
ORDER BY TOTAL_COMBINACOES DESC;
```

---

### 6. Análise de Combinações por Período

**Objetivo:** Identificar combinações cadastradas em um período específico.

**Query SQL:**
```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.PROCODIGOA,
    ccp.PROCODIGOB,
    ccp.CCPTPPEDID AS TIPO_PEDIDO,
    ccp.CCPDTCADASTRO AS DATA_CADASTRO
FROM CTPCOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
WHERE ccp.CCPDTCADASTRO >= ?
  AND ccp.CCPDTCADASTRO <= ?
ORDER BY ccp.CCPDTCADASTRO DESC;
```

---

### 7. Relatório Completo de Combinações

**Objetivo:** Analisar distribuição completa de combinações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT CCPTPPEDID) AS TOTAL_TIPOS_PEDIDO,
    COUNT(DISTINCT PROCODIGOA) AS TOTAL_PRODUTOS_A,
    COUNT(DISTINCT PROCODIGOB) AS TOTAL_PRODUTOS_B,
    AVG(CCPCOVENDAPROA) AS MEDIA_PRECO_A1,
    AVG(CCPCOVENDAPROB) AS MEDIA_PRECO_B1,
    MIN(CCPDTCADASTRO) AS PRIMEIRA_COMBINACAO,
    MAX(CCPDTCADASTRO) AS ULTIMA_COMBINACAO
FROM CTPCOMBPROPRO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CTPCOMBPROPRO | Tipo |
|--------|-----------|---------------------------|------|
| **CTPCOMBPROPRO** | 29.510 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | ~9.251 | 1:3.19 | Clientes (média de ~3.19 combinações por cliente) |
| PRODU | ~178.187 | 1:0.17 | Produtos (média de ~0.17 combinações por produto) |
| CLITPPED | ~? | ?:1 | Configurações cliente x tipo de pedido |

**Interpretação:**
- **29.510 combinações** cadastradas no sistema
- **Média de ~3.19 combinações por cliente** - indica uso moderado desta funcionalidade
- **Uso extensivo** - tabela média-grande indica gestão ativa de combinações

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente (já coberto pela PK)
3. **Índice por tipo de pedido** - Para buscas por tipo de pedido
4. **Índice por produto** - Para buscas por produto
5. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente e tipo de pedido (consultas frequentes)
CREATE INDEX IDX_CTPCOMBPROPRO_CLI_TIPO ON CTPCOMBPROPRO(CLICODIGO, CCPTPPEDID);

-- Índice 2: Busca por produto A (consultas frequentes)
CREATE INDEX IDX_CTPCOMBPROPRO_PRODUTO_A ON CTPCOMBPROPRO(PROCODIGOA);

-- Índice 3: Busca por produto B (consultas frequentes)
CREATE INDEX IDX_CTPCOMBPROPRO_PRODUTO_B ON CTPCOMBPROPRO(PROCODIGOB);

-- Índice 4: Busca por data de cadastro (consultas de análise)
CREATE INDEX IDX_CTPCOMBPROPRO_DATA_CADASTRO ON CTPCOMBPROPRO(CCPDTCADASTRO)
    WHERE CCPDTCADASTRO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela média-grande** (29.510 registros) - Performance boa com índices adequados
- **Chave primária composta** - (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID) já fornece índice eficiente
- **Consultas frequentes** - Combinações são consultadas durante criação de pedidos
- **Índices essenciais** - Em CLICODIGO, CCPTPPEDID e PROCODIGOA/PROCODIGOB para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar combinações sem cliente válido
SELECT ccp.*
FROM CTPCOMBPROPRO ccp
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar combinações sem tipo de pedido válido
SELECT ccp.*
FROM CTPCOMBPROPRO ccp
WHERE NOT EXISTS (
    SELECT 1 FROM CLITPPED ctp 
    WHERE ctp.CLICODIGO = ccp.CLICODIGO
      AND ctp.TPCODIGO = ccp.CCPTPPEDID
);

-- Verificar combinações sem produto A válido
SELECT ccp.*
FROM CTPCOMBPROPRO ccp
LEFT JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
WHERE pa.PROCODIGO IS NULL;

-- Verificar combinações sem produto B válido
SELECT ccp.*
FROM CTPCOMBPROPRO ccp
LEFT JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE pb.PROCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CTPCOMBPROPRO
WHERE CLICODIGO IS NULL
   OR PROCODIGOA IS NULL
   OR PROCODIGOA = ''
   OR PROCODIGOB IS NULL
   OR PROCODIGOB = ''
   OR CCPTPPEDID IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID, COUNT(*) AS QTD
FROM CTPCOMBPROPRO
GROUP BY CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID
HAVING COUNT(*) > 1;

-- Verificar valores inválidos (preços negativos)
SELECT *
FROM CTPCOMBPROPRO
WHERE CCPCOVENDAPROA < 0
   OR CCPCOVENDAPROA2 < 0
   OR CCPCOVENDAPROB < 0
   OR CCPCOVENDAPROB2 < 0;
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

final class FirebirdCtpcombpropro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTPCOMBPROPRO';
    
    protected $primaryKey = ['CLICODIGO', 'PROCODIGOA', 'PROCODIGOB', 'CCPTPPEDID'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'PROCODIGOA' => 'string',
        'PROCODIGOB' => 'string',
        'CCPTPPEDID' => 'integer',
        'CCINDICEPROA' => 'decimal:4',
        'CCINDICEPROA2' => 'decimal:4',
        'CCPCOVENDAPROA' => 'decimal:4',
        'CCPCOVENDAPROA2' => 'decimal:4',
        'CCINDICEPROB' => 'decimal:4',
        'CCINDICEPROB2' => 'decimal:4',
        'CCPCOVENDAPROB' => 'decimal:4',
        'CCPCOVENDAPROB2' => 'decimal:4',
        'CCPDTCADASTRO' => 'datetime',
    ];

    // Relacionamento com CLITPPED
    public function clienteTipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdClitpped::class, ['CLICODIGO', 'CCPTPPEDID'], 
                               ['CLICODIGO', 'TPCODIGO']);
    }

    // Relacionamento com PRODU (Produto A)
    public function produtoA(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGOA', 'PROCODIGO');
    }

    // Relacionamento com PRODU (Produto B)
    public function produtoB(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGOB', 'PROCODIGO');
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por tipo de pedido
    public function scopePorTipoPedido($query, int $tipoPedidoCodigo)
    {
        return $query->where('CCPTPPEDID', $tipoPedidoCodigo);
    }

    // Scope para filtrar por produto A
    public function scopePorProdutoA($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGOA', $produtoCodigo);
    }

    // Scope para filtrar por produto B
    public function scopePorProdutoB($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGOB', $produtoCodigo);
    }

    // Método estático para buscar combinação
    public static function buscarCombinacao(int $clienteCodigo, string $produtoA, string $produtoB, int $tipoPedido): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('PROCODIGOA', $produtoA)
            ->where('PROCODIGOB', $produtoB)
            ->where('CCPTPPEDID', $tipoPedido)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID) identifica unicamente cada combinação
2. **Validação antes de inserir** - Verificar se cliente, produtos e tipo de pedido existem
3. **Evitar duplicatas** - PK composta previne duplicatas
4. **Validação de valores** - Verificar que preços e índices são válidos
5. **Validação de produtos** - Verificar que PROCODIGOA ≠ PROCODIGOB

### Performance

1. **Tabela média-grande** - 29.510 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO, CCPTPPEDID e PROCODIGOA/PROCODIGOB para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + tipo de pedido)
4. **Consultas frequentes** - Combinações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cliente, produtos e tipo de pedido existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - Verificar que preços e índices são válidos
5. **Validação de produtos** - Verificar que produtos são diferentes

### Manutenção

1. **Revisão periódica** - Verificar combinações não utilizadas
2. **Padronização** - Manter estrutura de dados consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para gestão de precificação
5. **Limpeza** - Considerar arquivar combinações antigas não utilizadas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

