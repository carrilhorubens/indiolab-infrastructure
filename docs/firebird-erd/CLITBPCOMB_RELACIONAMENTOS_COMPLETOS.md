# CLITBPCOMB - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLITBPCOMB (Cliente x Tabela de Preço Combinação)
- **Total de Registros**: 4.987
- **Total de Colunas**: 6
- **Chave Primária**: (CLICODIGO, TBPCODIGO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLITBPCOMB** é uma tabela de configuração que associa clientes a tabelas de preço de combinações com descrições personalizadas. Com **4.987 registros**, representa configurações específicas de tabelas de preço de combinações por cliente, permitindo precificação diferenciada para combinações de produtos.

Esta tabela funciona como **configurador de tabelas de preço de combinações por cliente** e permite:
- Associar clientes a tabelas de preço de combinações específicas
- Configurar descrições personalizadas de fechamento por cliente-tabela
- Suportar múltiplas tabelas de preço de combinações por cliente
- Facilitar gestão de precificação de combinações personalizada
- Rastrear data de cadastro de cada configuração

Cada registro representa uma configuração específica de tabela de preço de combinação para um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Identificação da tabela de preço de combinação (TBPCODIGO)
- Descrições personalizadas (TBPDESC, TBPDESC2)
- Descrição de fechamento (TBPDESCFECH)
- Data de cadastro (CLITBPCOMBDTCADASTRO)

O sistema utiliza esta tabela para determinar qual tabela de preço de combinação aplicar para cada cliente, permitindo precificação diferenciada para combinações de produtos.

**Observação Importante:** CLITBPCOMB é similar a CLITBP, mas específica para tabelas de preço de combinações. Com 4.987 registros, indica uso extensivo de precificação diferenciada para combinações de produtos por cliente.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **TBPCODIGO** 🔑🔗 | SMALLINT | ✓ | Código da tabela de preço de combinação (PK + FK → TABPRECO) |

### Descrições Personalizadas
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDESCFECH** | VARCHAR(14) | ✓ | Descrição de fechamento personalizada |
| **TBPDESC** | VARCHAR(16) | | Descrição adicional 1 |
| **TBPDESC2** | VARCHAR(16) | | Descrição adicional 2 |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLITBPCOMBDTCADASTRO** | DATE | | Data de cadastro da configuração |

**Primary Key:** (CLICODIGO, TBPCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que terá a tabela de preço de combinação configurada.
- **TBPCODIGO**: Tabela de preço de combinação que será associada ao cliente.
- **TBPDESCFECH**: Descrição personalizada de fechamento para esta combinação cliente-tabela.
- **TBPDESC, TBPDESC2**: Descrições adicionais personalizadas.
- **CLITBPCOMBDTCADASTRO**: Data em que a configuração foi cadastrada.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLITBPCOMB Referencia (2 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLITBPCOMB.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLITBPCOMB
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

#### 2. TABPRECO - Tabelas de Preço
**Relacionamento:**
```
CLITBPCOMB.TBPCODIGO → TABPRECO.TBPCODIGO (N:1)
Constraint: TABPRECO_CLITBPCOMB
```

**Descrição**: Cada configuração está vinculada a uma tabela de preço específica (deve ser do tipo combinação).

**Informações da Tabela TABPRECO:**
- **Total:** 112 tabelas de preço
- **PK:** TBPCODIGO
- **Colunas:** 8 campos
- **FK Out:** 0
- **FK In:** 13 tabelas

**Campos importantes em TABPRECO relacionados a CLITBPCOMB:**
- `TBPCODIGO` - Código da tabela de preço
- `TBPDESCRICAO` - Descrição da tabela de preço
- `TBPTABCOMB` - Flag indicando se é tabela de combinação
- `TBPTIPO` - Tipo da tabela de preço

**Uso:** Identificar a tabela de preço de combinação da configuração, obter informações da tabela.

---

### CLITBPCOMB é Referenciada Por

**Nenhuma tabela** referencia CLITBPCOMB diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLITBPCOMB → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados às tabelas de preço de combinações configuradas.

**Uso:** Aplicar tabelas de preço de combinações em pedidos, análises de pedidos considerando tabelas de combinações.

---

### Via CLIEN → CLICOMBPROPRO (Combinações Cliente-Produto-Produto)

**Fluxo:** CLITBPCOMB → CLIEN → CLICOMBPROPRO

**Descrição:** Através do cliente, é possível identificar combinações de produtos que podem estar relacionadas às tabelas de preço.

**Uso:** Aplicar tabelas de preço de combinações em combinações de produtos do cliente.

---

### Via TABPRECO → TBPPRODU (Produtos da Tabela de Preço)

**Fluxo:** CLITBPCOMB → TABPRECO → TBPPRODU

**Descrição:** Através da tabela de preço, é possível identificar produtos e preços configurados.

**Uso:** Obter preços de produtos da tabela de preço de combinação para o cliente.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração Cliente-Tabela de Combinação

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente e tabela de preço.

**Fluxo:**
```
CLITBPCOMB (CLICODIGO, TBPCODIGO, TBPDESCFECH)
  ↓
CLIEN (CLICODIGO)
  ↓
TABPRECO (TBPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctbc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ctbc.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO_COMBINACAO,
    tp.TBPTIPO AS TIPO_TABELA,
    tp.TBPTABCOMB AS E_TABELA_COMBINACAO,
    ctbc.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctbc.TBPDESC AS DESCRICAO_1,
    ctbc.TBPDESC2 AS DESCRICAO_2,
    ctbc.CLITBPCOMBDTCADASTRO AS DATA_CADASTRO
FROM CLITBPCOMB ctbc
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctbc.CLICODIGO
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE ctbc.CLICODIGO = ?
  AND ctbc.TBPCODIGO = ?;
```

---

### Exemplo 2: Análise de Tabelas de Combinação por Cliente

**Objetivo:** Identificar todas as tabelas de preço de combinações configuradas para um cliente específico.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLITBPCOMB (CLICODIGO)
  ↓
TABPRECO (TBPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctbc.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO_COMBINACAO,
    tp.TBPTIPO AS TIPO_TABELA,
    ctbc.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctbc.TBPDESC AS DESCRICAO_1,
    ctbc.TBPDESC2 AS DESCRICAO_2,
    ctbc.CLITBPCOMBDTCADASTRO AS DATA_CADASTRO
FROM CLITBPCOMB ctbc
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE ctbc.CLICODIGO = ?
ORDER BY ctbc.CLITBPCOMBDTCADASTRO DESC;
```

---

### Exemplo 3: Comparação CLITBP vs CLITBPCOMB

**Objetivo:** Comparar uso de tabelas de preço normais vs tabelas de combinação por cliente.

**Query SQL:**
```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT ctb.TBPCODIGO) AS TOTAL_TABELAS_NORMAIS,
    COUNT(DISTINCT ctbc.TBPCODIGO) AS TOTAL_TABELAS_COMBINACAO,
    COUNT(DISTINCT ctb.TBPCODIGO) + COUNT(DISTINCT ctbc.TBPCODIGO) AS TOTAL_TABELAS
FROM CLIEN cl
LEFT JOIN CLITBP ctb ON ctb.CLICODIGO = cl.CLICODIGO
LEFT JOIN CLITBPCOMB ctbc ON ctbc.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
HAVING COUNT(DISTINCT ctb.TBPCODIGO) > 0 OR COUNT(DISTINCT ctbc.TBPCODIGO) > 0
ORDER BY TOTAL_TABELAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração Cliente-Tabela de Combinação

**Objetivo:** Obter a configuração de uma tabela de preço de combinação específica para um cliente.

```sql
SELECT
    CLICODIGO,
    TBPCODIGO,
    TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    TBPDESC AS DESCRICAO_1,
    TBPDESC2 AS DESCRICAO_2,
    CLITBPCOMBDTCADASTRO AS DATA_CADASTRO
FROM CLITBPCOMB
WHERE CLICODIGO = ?
  AND TBPCODIGO = ?;
```

---

### 2. Listar Todas as Tabelas de Combinação de um Cliente

**Objetivo:** Obter todas as tabelas de preço de combinações configuradas para um cliente.

```sql
SELECT
    ctbc.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO_COMBINACAO,
    tp.TBPTIPO AS TIPO_TABELA,
    ctbc.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctbc.CLITBPCOMBDTCADASTRO AS DATA_CADASTRO
FROM CLITBPCOMB ctbc
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE ctbc.CLICODIGO = ?
ORDER BY ctbc.CLITBPCOMBDTCADASTRO DESC;
```

---

### 3. Análise de Tabelas de Combinação Mais Utilizadas

**Objetivo:** Identificar tabelas de preço de combinações com mais clientes associados.

```sql
SELECT
    ctbc.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO_COMBINACAO,
    tp.TBPTIPO AS TIPO_TABELA,
    COUNT(DISTINCT ctbc.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM CLITBPCOMB ctbc
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
GROUP BY ctbc.TBPCODIGO, tp.TBPDESCRICAO, tp.TBPTIPO
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 4. Análise de Clientes com Tabelas de Combinação

**Objetivo:** Identificar clientes que têm tabelas de preço de combinações configuradas.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    COUNT(DISTINCT ctbc.TBPCODIGO) AS TOTAL_TABELAS_COMBINACAO
FROM CLIEN cl
INNER JOIN CLITBPCOMB ctbc ON ctbc.CLICODIGO = cl.CLICODIGO
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT, cl.CLIRAZSOCIAL
ORDER BY TOTAL_TABELAS_COMBINACAO DESC;
```

---

### 5. Comparação com CLITBP

**Objetivo:** Comparar uso de tabelas normais vs tabelas de combinação.

**Query SQL:**
```sql
SELECT
    'CLITBP' AS TIPO_TABELA,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT TBPCODIGO) AS TOTAL_TABELAS
FROM CLITBP
UNION ALL
SELECT
    'CLITBPCOMB' AS TIPO_TABELA,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT TBPCODIGO) AS TOTAL_TABELAS
FROM CLITBPCOMB
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 6. Análise de Configurações por Data de Cadastro

**Objetivo:** Identificar configurações cadastradas em um período específico.

```sql
SELECT
    ctbc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctbc.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO_COMBINACAO,
    ctbc.CLITBPCOMBDTCADASTRO AS DATA_CADASTRO
FROM CLITBPCOMB ctbc
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctbc.CLICODIGO
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE ctbc.CLITBPCOMBDTCADASTRO >= ?
  AND ctbc.CLITBPCOMBDTCADASTRO <= ?
ORDER BY ctbc.CLITBPCOMBDTCADASTRO DESC;
```

---

### 7. Relatório de Configurações por Cliente

**Objetivo:** Analisar distribuição de configurações de tabelas de combinação por cliente.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT ctbc.TBPCODIGO) AS TOTAL_TABELAS_COMBINACAO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    MIN(ctbc.CLITBPCOMBDTCADASTRO) AS PRIMEIRA_CONFIGURACAO,
    MAX(ctbc.CLITBPCOMBDTCADASTRO) AS ULTIMA_CONFIGURACAO
FROM CLIEN cl
LEFT JOIN CLITBPCOMB ctbc ON ctbc.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
HAVING COUNT(*) > 0
ORDER BY TOTAL_TABELAS_COMBINACAO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLITBPCOMB | Tipo |
|--------|-----------|---------------------|------|
| **CLITBPCOMB** | 4.987 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 1.86:1 | Clientes (média de 0.54 configurações por cliente) |
| TABPRECO | 112 | 0.022:1 | Tabelas de preço (média de 44.5 configurações por tabela) |
| CLITBP | 8.627 | 1.73:1 | Tabelas normais (57% mais que combinações) |

**Interpretação:**
- **4.987 configurações** cadastradas no sistema
- **54% dos clientes** têm pelo menos uma configuração de tabela de combinação (4.987 de 9.251)
- **Uso extensivo** - indica precificação diferenciada importante para combinações
- **57% menos que CLITBP** - tabelas normais são mais utilizadas que tabelas de combinação

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLITBPCOMB.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por tabela de preço** - Para buscas por tabela

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLITBPCOMB_CLIENTE ON CLITBPCOMB(CLICODIGO);

-- Índice 2: Busca por tabela de preço (consultas frequentes)
CREATE INDEX IDX_CLITBPCOMB_TABELA_PRECO ON CLITBPCOMB(TBPCODIGO);

-- Índice 3: Busca composta por cliente e tabela (consultas de validação)
CREATE INDEX IDX_CLITBPCOMB_CLI_TAB ON CLITBPCOMB(CLICODIGO, TBPCODIGO);
```

### Observações sobre Volume

- **Tabela média** (4.987 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Configurações são consultadas durante criação de pedidos
- **Índices essenciais** - Em CLICODIGO e TBPCODIGO para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e tabela

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT ctbc.*
FROM CLITBPCOMB ctbc
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ctbc.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem tabela de preço válida
SELECT ctbc.*
FROM CLITBPCOMB ctbc
LEFT JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE tp.TBPCODIGO IS NULL;

-- Verificar se tabela é realmente de combinação
SELECT ctbc.*
FROM CLITBPCOMB ctbc
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctbc.TBPCODIGO
WHERE tp.TBPTABCOMB IS NULL OR tp.TBPTABCOMB != 'S';
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLITBPCOMB
WHERE CLICODIGO IS NULL
   OR TBPCODIGO IS NULL
   OR TBPDESCFECH IS NULL
   OR TBPDESCFECH = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, TBPCODIGO, COUNT(*) AS QTD
FROM CLITBPCOMB
GROUP BY CLICODIGO, TBPCODIGO
HAVING COUNT(*) > 1;
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

final class FirebirdClitbpcomb extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLITBPCOMB';
    
    protected $primaryKey = ['CLICODIGO', 'TBPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'TBPCODIGO' => 'integer',
        'TBPDESCFECH' => 'string',
        'TBPDESC' => 'string',
        'TBPDESC2' => 'string',
        'CLITBPCOMBDTCADASTRO' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com TABPRECO
    public function tabelaPreco(): BelongsTo
    {
        return $this->belongsTo(FirebirdTabpreco::class, 'TBPCODIGO', 'TBPCODIGO');
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por tabela de preço
    public function scopePorTabelaPreco($query, int $tabelaCodigo)
    {
        return $query->where('TBPCODIGO', $tabelaCodigo);
    }

    // Método estático para buscar configuração específica
    public static function buscarConfiguracao(int $clienteCodigo, int $tabelaCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('TBPCODIGO', $tabelaCodigo)
            ->first();
    }

    // Método estático para buscar tabelas de combinação de um cliente
    public static function buscarTabelasCliente(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->with('tabelaPreco')
            ->orderBy('CLITBPCOMBDTCADASTRO', 'desc')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e tabela de preço existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de tipo** - Verificar que tabela é realmente de combinação

### Performance

1. **Tabela média** - 4.987 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO e TBPCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + tabela)
4. **Consultas frequentes** - Configurações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de tipo** - Verificar que tabela é de combinação

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura de descrições consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para precificação de combinações

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

