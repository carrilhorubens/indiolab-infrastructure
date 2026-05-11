# CLIPRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIPRO (Cliente x Produto)
- **Total de Registros**: 693
- **Total de Colunas**: 8
- **Chave Primária**: (CLICODIGO, PROCODIGO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIPRO** é uma tabela de configuração que associa clientes a produtos com preços e índices personalizados. Com **693 registros**, representa configurações específicas de precificação e índices para produtos por cliente.

Esta tabela funciona como **configurador de produtos por cliente** e permite:
- Associar produtos a clientes com configurações específicas
- Armazenar preços de venda personalizados por cliente
- Configurar índices específicos para produtos por cliente
- Suportar múltiplos preços e índices por produto-cliente
- Controlar descrição de fechamento personalizada
- Rastrear data de cadastro de cada configuração

Cada registro representa uma configuração específica de produto para um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Identificação do produto (PROCODIGO)
- Índices do produto (CPINDICE, CPINDICE2)
- Preços de venda (CPPCOVENDA, CPPCOVENDA2)
- Descrição de fechamento (CPDESCFECH)
- Data de cadastro (CPDTCADASTRO)

O sistema utiliza esta tabela para personalizar precificação e índices de produtos por cliente, permitindo que diferentes clientes tenham diferentes preços e configurações para os mesmos produtos.

**Observação Importante:** CLIPRO permite precificação personalizada por cliente. Com 693 registros para 9.251 clientes e 178.187 produtos, indica uso específico para produtos que requerem precificação diferenciada por cliente.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **PROCODIGO** 🔑🔗 | VARCHAR(14) | ✓ | Código do produto (PK + FK → PRODU) |

### Índices do Produto
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPINDICE** | NUMERIC(16,4) | | Índice 1 do produto para o cliente |
| **CPINDICE2** | NUMERIC(16,4) | | Índice 2 do produto para o cliente |

### Preços de Venda
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPPCOVENDA** | NUMERIC(16,4) | | Preço de venda 1 do produto para o cliente |
| **CPPCOVENDA2** | NUMERIC(16,4) | | Preço de venda 2 do produto para o cliente |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPDESCFECH** | VARCHAR(14) | ✓ | Descrição de fechamento personalizada |
| **CPDTCADASTRO** | DATE | | Data de cadastro da configuração |

**Primary Key:** (CLICODIGO, PROCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que terá configuração específica do produto.
- **PROCODIGO**: Produto que será configurado para o cliente.
- **CPINDICE, CPINDICE2**: Índices específicos do produto para o cliente (podem representar graus, medidas ou outros parâmetros).
- **CPPCOVENDA, CPPCOVENDA2**: Preços de venda personalizados do produto para o cliente.
- **CPDESCFECH**: Descrição personalizada de fechamento do produto para o cliente.
- **CPDTCADASTRO**: Data em que a configuração foi cadastrada.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIPRO Referencia (2 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIPRO.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIPRO
```

**Descrição**: Cada configuração está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente da configuração, relatórios de configurações por cliente.

---

#### 2. PRODU - Produtos
**Relacionamento:**
```
CLIPRO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CLIPRO
```

**Descrição**: Cada configuração está vinculada a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos
- **FK Out:** 0
- **FK In:** 101 tabelas

**Uso:** Identificar o produto da configuração, relatórios de configurações por produto.

---

### CLIPRO é Referenciada Por

**Nenhuma tabela** referencia CLIPRO diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIPRO → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados às configurações de produtos.

**Uso:** Aplicar preços e índices personalizados em pedidos, análises de pedidos considerando configurações de produtos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIPRO → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas às configurações de produtos.

**Uso:** Aplicar preços personalizados em notas fiscais, análises de notas considerando configurações de produtos.

---

### Via PRODU → PDPRD (Produtos de Pedido)

**Fluxo:** CLIPRO → PRODU → PDPRD

**Descrição:** Através do produto, é possível identificar itens de pedidos que podem estar relacionados às configurações.

**Uso:** Aplicar preços e índices personalizados em itens de pedidos.

---

### Via PRODU → NFPRO (Produtos de Nota Fiscal)

**Fluxo:** CLIPRO → PRODU → NFPRO

**Descrição:** Através do produto, é possível identificar itens de notas fiscais que podem estar relacionados às configurações.

**Uso:** Aplicar preços personalizados em itens de notas fiscais.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração de Produto

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente e produto.

**Fluxo:**
```
CLIPRO (CLICODIGO, PROCODIGO, CPPCOVENDA, CPINDICE)
  ↓
CLIEN (CLICODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPINDICE AS INDICE_1,
    cp.CPINDICE2 AS INDICE_2,
    cp.CPPCOVENDA AS PRECO_VENDA_1,
    cp.CPPCOVENDA2 AS PRECO_VENDA_2,
    cp.CPDESCFECH AS DESCRICAO_FECHAMENTO,
    cp.CPDTCADASTRO AS DATA_CADASTRO
FROM CLIPRO cp
INNER JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CLICODIGO = ?
  AND cp.PROCODIGO = ?;
```

---

### Exemplo 2: Análise de Configurações por Cliente

**Objetivo:** Identificar todos os produtos configurados para um cliente específico.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLIPRO (CLICODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPINDICE AS INDICE_1,
    cp.CPINDICE2 AS INDICE_2,
    cp.CPPCOVENDA AS PRECO_VENDA_1,
    cp.CPPCOVENDA2 AS PRECO_VENDA_2,
    cp.CPDESCFECH AS DESCRICAO_FECHAMENTO,
    cp.CPDTCADASTRO AS DATA_CADASTRO
FROM CLIPRO cp
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CLICODIGO = ?
ORDER BY pr.PRODESCRICAO;
```

---

### Exemplo 3: Análise de Configurações com Pedidos

**Objetivo:** Obter configurações de produtos com informações de pedidos relacionados.

**Fluxo:**
```
CLIPRO (CLICODIGO, PROCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
  ↓
PDPRD (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPPCOVENDA AS PRECO_CONFIGURADO,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pdp.ID_PDPRD) AS TOTAL_ITENS_PEDIDO,
    SUM(pdp.PDPVRMERC) AS VALOR_TOTAL_ITENS
FROM CLIPRO cp
INNER JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = cp.CLICODIGO
LEFT JOIN PDPRD pdp ON pdp.ID_PEDIDO = pd.ID_PEDIDO
  AND pdp.PROCODIGO = cp.PROCODIGO
GROUP BY cp.CLICODIGO, cl.CLINOMEFANT, cp.PROCODIGO, pr.PRODESCRICAO, cp.CPPCOVENDA
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Produto para Cliente

**Objetivo:** Obter a configuração de um produto específico para um cliente.

```sql
SELECT
    CLICODIGO,
    PROCODIGO,
    CPINDICE AS INDICE_1,
    CPINDICE2 AS INDICE_2,
    CPPCOVENDA AS PRECO_VENDA_1,
    CPPCOVENDA2 AS PRECO_VENDA_2,
    CPDESCFECH AS DESCRICAO_FECHAMENTO,
    CPDTCADASTRO AS DATA_CADASTRO
FROM CLIPRO
WHERE CLICODIGO = ?
  AND PROCODIGO = ?;
```

---

### 2. Listar Todos os Produtos Configurados para um Cliente

**Objetivo:** Obter todos os produtos com configurações personalizadas para um cliente.

```sql
SELECT
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPINDICE AS INDICE_1,
    cp.CPINDICE2 AS INDICE_2,
    cp.CPPCOVENDA AS PRECO_VENDA_1,
    cp.CPPCOVENDA2 AS PRECO_VENDA_2,
    cp.CPDESCFECH AS DESCRICAO_FECHAMENTO
FROM CLIPRO cp
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CLICODIGO = ?
ORDER BY pr.PRODESCRICAO;
```

---

### 3. Buscar Clientes com Configuração de um Produto

**Objetivo:** Identificar todos os clientes que têm configuração específica para um produto.

```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cp.CPINDICE AS INDICE_1,
    cp.CPINDICE2 AS INDICE_2,
    cp.CPPCOVENDA AS PRECO_VENDA_1,
    cp.CPPCOVENDA2 AS PRECO_VENDA_2
FROM CLIPRO cp
INNER JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
WHERE cp.PROCODIGO = ?
ORDER BY cl.CLINOMEFANT;
```

---

### 4. Análise de Produtos Mais Configurados

**Objetivo:** Identificar produtos que têm mais configurações personalizadas por cliente.

```sql
SELECT
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    COUNT(DISTINCT cp.CLICODIGO) AS TOTAL_CLIENTES_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(cp.CPPCOVENDA) AS PRECO_MEDIO,
    MIN(cp.CPPCOVENDA) AS PRECO_MINIMO,
    MAX(cp.CPPCOVENDA) AS PRECO_MAXIMO
FROM CLIPRO cp
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CPPCOVENDA IS NOT NULL
GROUP BY cp.PROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_CLIENTES_CONFIGURADOS DESC;
```

---

### 5. Comparação de Preços Configurados vs Preços Padrão

**Objetivo:** Comparar preços configurados por cliente com preços padrão dos produtos.

**Query SQL:**
```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPPCOVENDA AS PRECO_CONFIGURADO,
    pr.PROLISTAPRECO AS PRECO_PADRAO,
    cp.CPPCOVENDA - pr.PROLISTAPRECO AS DIFERENCA_PRECO,
    ROUND((cp.CPPCOVENDA - pr.PROLISTAPRECO) * 100.0 / pr.PROLISTAPRECO, 2) AS PERCENTUAL_DIFERENCA
FROM CLIPRO cp
INNER JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CPPCOVENDA IS NOT NULL
  AND pr.PROLISTAPRECO IS NOT NULL
ORDER BY ABS(cp.CPPCOVENDA - pr.PROLISTAPRECO) DESC;
```

---

### 6. Análise de Configurações por Data de Cadastro

**Objetivo:** Identificar configurações cadastradas em um período específico.

```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cp.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cp.CPDTCADASTRO AS DATA_CADASTRO,
    cp.CPPCOVENDA AS PRECO_VENDA
FROM CLIPRO cp
INNER JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
INNER JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE cp.CPDTCADASTRO >= ?
  AND cp.CPDTCADASTRO <= ?
ORDER BY cp.CPDTCADASTRO DESC;
```

---

### 7. Relatório de Configurações por Cliente

**Objetivo:** Analisar distribuição de configurações de produtos por cliente.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT cp.PROCODIGO) AS TOTAL_PRODUTOS_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(cp.CPPCOVENDA) AS PRECO_MEDIO_CONFIGURADO,
    MIN(cp.CPPCOVENDA) AS PRECO_MINIMO,
    MAX(cp.CPPCOVENDA) AS PRECO_MAXIMO
FROM CLIEN cl
LEFT JOIN CLIPRO cp ON cp.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
HAVING COUNT(*) > 0
ORDER BY TOTAL_PRODUTOS_CONFIGURADOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIPRO | Tipo |
|--------|-----------|---------------------|------|
| **CLIPRO** | 693 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 13.35:1 | Clientes (média de 0.075 configurações por cliente) |
| PRODU | 178.187 | 257:1 | Produtos (média de 0.004 configurações por produto) |

**Interpretação:**
- **693 configurações** cadastradas no sistema
- **7.5% dos clientes** têm pelo menos uma configuração de produto (693 de 9.251)
- **0.4% dos produtos** têm configuração por cliente (693 de 178.187)
- **Uso específico** - indica produtos que requerem precificação diferenciada por cliente

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIPRO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por produto** - Para buscas por produto
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIPRO_CLIENTE ON CLIPRO(CLICODIGO);

-- Índice 2: Busca por produto (consultas frequentes)
CREATE INDEX IDX_CLIPRO_PRODUTO ON CLIPRO(PROCODIGO);

-- Índice 3: Busca composta por cliente e produto (consultas de validação)
CREATE INDEX IDX_CLIPRO_CLI_PRO ON CLIPRO(CLICODIGO, PROCODIGO);
```

### Observações sobre Volume

- **Tabela pequena** (693 registros) - Performance boa
- **Consultas frequentes** - Configurações são consultadas durante criação de pedidos
- **Índices essenciais** - Em CLICODIGO e PROCODIGO para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e produto

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT cp.*
FROM CLIPRO cp
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem produto válido
SELECT cp.*
FROM CLIPRO cp
LEFT JOIN PRODU pr ON pr.PROCODIGO = cp.PROCODIGO
WHERE pr.PROCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIPRO
WHERE CLICODIGO IS NULL
   OR PROCODIGO IS NULL
   OR PROCODIGO = ''
   OR CPDESCFECH IS NULL
   OR CPDESCFECH = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, PROCODIGO, COUNT(*) AS QTD
FROM CLIPRO
GROUP BY CLICODIGO, PROCODIGO
HAVING COUNT(*) > 1;

-- Verificar preços negativos ou inválidos
SELECT *
FROM CLIPRO
WHERE CPPCOVENDA < 0
   OR CPPCOVENDA2 < 0;
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

final class FirebirdClipro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIPRO';
    
    protected $primaryKey = ['CLICODIGO', 'PROCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'PROCODIGO' => 'string',
        'CPINDICE' => 'decimal:4',
        'CPINDICE2' => 'decimal:4',
        'CPPCOVENDA' => 'decimal:4',
        'CPPCOVENDA2' => 'decimal:4',
        'CPDESCFECH' => 'string',
        'CPDTCADASTRO' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Método para verificar se tem preços configurados
    public function temPrecos(): bool
    {
        return !empty($this->CPPCOVENDA) || !empty($this->CPPCOVENDA2);
    }

    // Método para verificar se tem índices configurados
    public function temIndices(): bool
    {
        return !empty($this->CPINDICE) || !empty($this->CPINDICE2);
    }

    // Método para obter preço principal
    public function getPrecoPrincipal(): ?float
    {
        return $this->CPPCOVENDA ?? $this->CPPCOVENDA2;
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por produto
    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    // Método estático para buscar configuração específica
    public static function buscarConfiguracao(int $clienteCodigo, string $produtoCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('PROCODIGO', $produtoCodigo)
            ->first();
    }

    // Método estático para obter preço configurado
    public static function obterPrecoConfigurado(int $clienteCodigo, string $produtoCodigo): ?float
    {
        $config = self::buscarConfiguracao($clienteCodigo, $produtoCodigo);
        return $config?->getPrecoPrincipal();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e produto existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de preços** - Verificar valores positivos e válidos

### Performance

1. **Tabela pequena** - 693 registros, performance boa
2. **Índices essenciais** - Em CLICODIGO e PROCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + produto)
4. **Consultas frequentes** - Configurações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de preços** - Verificar valores positivos e válidos

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura de preços e índices consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para precificação personalizada

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

