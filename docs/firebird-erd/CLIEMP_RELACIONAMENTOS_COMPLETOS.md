# CLIEMP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIEMP (Cliente x Empresa)
- **Total de Registros**: 3.174
- **Total de Colunas**: 4
- **Chave Primária**: (CLICODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 1 (formal), 1 (lógica)
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIEMP** é uma tabela de relacionamento que associa clientes a empresas no sistema multi-empresa. Com **3.174 registros**, representa a configuração de quais clientes podem ser utilizados em quais empresas/filiais.

Esta tabela funciona como **controlador de acesso multi-empresa** e permite:
- Associar clientes a empresas específicas
- Controlar quais clientes estão disponíveis em cada empresa
- Configurar tabela de faturamento por empresa (TFCODIGO)
- Configurar verificação de faturamento por empresa (CEEMPVRFAT)
- Suportar arquitetura multi-empresa onde um cliente pode estar em múltiplas empresas

Cada registro representa uma associação entre um cliente (CLICODIGO) e uma empresa (EMPCODIGO), contendo:
- Identificação do cliente (CLICODIGO)
- Identificação da empresa (EMPCODIGO)
- Tabela de faturamento específica (TFCODIGO)
- Código de verificação de faturamento (CEEMPVRFAT)

O sistema utiliza esta tabela para controlar o acesso e configuração de clientes em ambientes multi-empresa, permitindo que diferentes empresas tenham diferentes conjuntos de clientes disponíveis.

**Observação Importante:** CLIEMP é uma tabela de configuração multi-empresa. Embora não tenha FK formal para EMPRESA, o campo EMPCODIGO referencia logicamente a tabela EMPRESA. A tabela CLIEMPCMP (68 registros) é uma versão mais completa com mais configurações por empresa.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK, lógica → EMPRESA) |

### Configurações por Empresa
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TFCODIGO** | INTEGER | | Código da tabela de faturamento (lógica → TABFAT) |
| **CEEMPVRFAT** | SMALLINT | | Código de verificação de faturamento por empresa |

**Primary Key:** (CLICODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que será associado à empresa.
- **EMPCODIGO**: Empresa/filial onde o cliente estará disponível.
- **TFCODIGO**: Tabela de faturamento específica para o cliente nesta empresa (opcional).
- **CEEMPVRFAT**: Código de verificação de faturamento específico por empresa (opcional).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIEMP Referencia (1 FK Formal + 1 Lógica):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIEMP.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIEMP
```

**Descrição**: Cada registro está vinculado a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Campos importantes em CLIEN relacionados a CLIEMP:**
- `CLICODIGO` - Código do cliente
- `CLINOMEFANT` - Nome fantasia
- `CLIRAZSOCIAL` - Razão social
- `CLICLIENTE` - Flag indicando se é cliente

**Uso:** Identificar o cliente associado à empresa, relatórios por cliente, análises de distribuição de clientes por empresa.

---

#### 2. EMPRESA - Empresas/Filiais (Lógica)
**Relacionamento Lógico:**
```
CLIEMP.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: NÃO FORMAL (relacionamento lógico)
```

**Descrição**: Cada registro está logicamente vinculado a uma empresa/filial específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos
- **FK Out:** 9
- **FK In:** 53 tabelas

**Campos importantes em EMPRESA relacionados a CLIEMP:**
- `EMPCODIGO` - Código da empresa
- `EMPRAZSOCIAL` - Razão social da empresa
- `EMPNOMEFNT` - Nome fantasia da empresa
- `EMPCNPJ` - CNPJ da empresa

**Uso:** Identificar a empresa onde o cliente está disponível, relatórios por empresa, análises de distribuição de clientes.

**Observação:** Embora não exista FK formal, o campo EMPCODIGO claramente referencia EMPRESA. A ausência de FK pode ser intencional para flexibilidade ou herança de sistema legado.

---

### Relacionamentos Lógicos Adicionais:

#### 3. TABFAT - Tabela de Faturamento (Lógica)
**Relacionamento Lógico:**
```
CLIEMP.TFCODIGO → TABFAT.TFCODIGO (N:1)
Constraint: NÃO FORMAL (relacionamento lógico)
```

**Descrição**: Campo TFCODIGO referencia logicamente a tabela TABFAT para configuração de tabela de faturamento específica por empresa.

**Uso:** Configurar tabela de faturamento específica para o cliente em cada empresa.

---

### CLIEMP é Referenciada Por

**Nenhuma tabela** referencia CLIEMP diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIEMP → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados à empresa configurada em CLIEMP.

**Campos de junção:**
- `CLIEMP.CLICODIGO` → `CLIEN.CLICODIGO` → `PEDID.CLICODIGO`
- `CLIEMP.EMPCODIGO` → `PEDID.EMPCODIGO` (validação lógica)

**Uso:** Análises de pedidos por empresa e cliente, validação de acesso de clientes em pedidos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIEMP → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas à empresa configurada.

**Uso:** Análises de notas fiscais por empresa e cliente, validação de acesso de clientes em notas.

---

### Via CLIEN → CLIFORCTB (Cliente x Contabilidade)

**Fluxo:** CLIEMP → CLIEN → CLIFORCTB

**Descrição:** Através do cliente, é possível identificar configurações contábeis que podem estar relacionadas à empresa.

**Uso:** Análises de configurações contábeis por empresa e cliente.

---

### Via CLIEN → CLIEMPCMP (Cliente x Empresa Completo)

**Fluxo:** CLIEMP → CLIEN → CLIEMPCMP

**Descrição:** CLIEMPCMP é uma versão mais completa de CLIEMP com mais configurações por empresa.

**Uso:** Comparação entre configurações básicas (CLIEMP) e completas (CLIEMPCMP).

---

### Via EMPRESA → PEDID (Pedidos)

**Fluxo:** CLIEMP → EMPRESA → PEDID

**Descrição:** Através da empresa, é possível identificar pedidos que podem estar relacionados ao cliente configurado.

**Uso:** Análises de pedidos por empresa, validação de acesso de empresas em pedidos.

---

### Via EMPRESA → NOTAS (Notas Fiscais)

**Fluxo:** CLIEMP → EMPRESA → NOTAS

**Descrição:** Através da empresa, é possível identificar notas fiscais que podem estar relacionadas ao cliente configurado.

**Uso:** Análises de notas fiscais por empresa, validação de acesso de empresas em notas.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Cliente por Empresa

**Objetivo:** Obter visão completa de um cliente incluindo informações da empresa e configurações.

**Fluxo:**
```
CLIEMP (CLICODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    emp.EMPNOMEFNT AS EMPRESA_FANTASIA,
    ce.TFCODIGO,
    tf.TFCODIGO AS TABELA_FATURAMENTO,
    ce.CEEMPVRFAT AS VERIFICACAO_FATURAMENTO
FROM CLIEMP ce
INNER JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
LEFT JOIN TABFAT tf ON tf.TFCODIGO = ce.TFCODIGO
WHERE ce.CLICODIGO = ?
ORDER BY ce.EMPCODIGO;
```

---

### Exemplo 2: Análise de Distribuição de Clientes por Empresa

**Objetivo:** Identificar quantos clientes cada empresa possui e quais são.

**Fluxo:**
```
EMPRESA (EMPCODIGO)
  ↓
CLIEMP (EMPCODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    emp.EMPNOMEFNT AS EMPRESA_FANTASIA,
    COUNT(DISTINCT ce.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_ASSOCIACOES,
    STRING_AGG(DISTINCT cl.CLINOMEFANT, ', ') AS CLIENTES
FROM EMPRESA emp
LEFT JOIN CLIEMP ce ON ce.EMPCODIGO = emp.EMPCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
GROUP BY emp.EMPCODIGO, emp.EMPRAZSOCIAL, emp.EMPNOMEFNT
ORDER BY TOTAL_CLIENTES DESC;
```

---

### Exemplo 3: Análise de Clientes com Pedidos por Empresa

**Objetivo:** Identificar clientes que têm pedidos em empresas específicas e validar configuração em CLIEMP.

**Fluxo:**
```
CLIEMP (CLICODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS,
    CASE 
        WHEN ce.CLICODIGO IS NOT NULL THEN 'SIM'
        ELSE 'NÃO'
    END AS CONFIGURADO_EM_CLIEMP
FROM CLIEN cl
INNER JOIN PEDID pd ON pd.CLICODIGO = cl.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = pd.EMPCODIGO
LEFT JOIN CLIEMP ce ON ce.CLICODIGO = cl.CLICODIGO 
    AND ce.EMPCODIGO = pd.EMPCODIGO
WHERE pd.EMPCODIGO = ?
GROUP BY ce.CLICODIGO, cl.CLINOMEFANT, ce.EMPCODIGO, emp.EMPRAZSOCIAL
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Empresas de um Cliente

**Objetivo:** Obter todas as empresas onde um cliente está disponível.

```sql
SELECT
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    emp.EMPNOMEFNT AS EMPRESA_FANTASIA,
    ce.TFCODIGO,
    ce.CEEMPVRFAT AS VERIFICACAO_FATURAMENTO
FROM CLIEMP ce
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
WHERE ce.CLICODIGO = ?
ORDER BY ce.EMPCODIGO;
```

---

### 2. Listar Clientes de uma Empresa

**Objetivo:** Obter todos os clientes disponíveis em uma empresa específica.

```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cl.CLICNPJCPF AS CNPJ_CPF,
    ce.TFCODIGO,
    ce.CEEMPVRFAT AS VERIFICACAO_FATURAMENTO
FROM CLIEMP ce
INNER JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
WHERE ce.EMPCODIGO = ?
ORDER BY cl.CLINOMEFANT;
```

---

### 3. Verificar Se Cliente Está Configurado em Empresa

**Objetivo:** Validar se um cliente pode ser usado em uma empresa específica.

```sql
SELECT
    ce.CLICODIGO,
    ce.EMPCODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    emp.EMPRAZSOCIAL AS EMPRESA,
    CASE 
        WHEN ce.CLICODIGO IS NOT NULL THEN 'SIM'
        ELSE 'NÃO'
    END AS CONFIGURADO
FROM CLIEN cl
CROSS JOIN EMPRESA emp
LEFT JOIN CLIEMP ce ON ce.CLICODIGO = cl.CLICODIGO 
    AND ce.EMPCODIGO = emp.EMPCODIGO
WHERE cl.CLICODIGO = ?
  AND emp.EMPCODIGO = ?;
```

---

### 4. Relatório de Distribuição de Clientes por Empresa

**Objetivo:** Analisar como os clientes estão distribuídos entre as empresas.

```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT ce.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_ASSOCIACOES,
    ROUND(COUNT(DISTINCT ce.CLICODIGO) * 100.0 / (SELECT COUNT(DISTINCT CLICODIGO) FROM CLIEN), 2) AS PERCENTUAL_CLIENTES,
    COUNT(CASE WHEN ce.TFCODIGO IS NOT NULL THEN 1 END) AS COM_TABELA_FATURAMENTO,
    COUNT(CASE WHEN ce.CEEMPVRFAT IS NOT NULL THEN 1 END) AS COM_VERIFICACAO_FATURAMENTO
FROM EMPRESA emp
LEFT JOIN CLIEMP ce ON ce.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPRAZSOCIAL
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 5. Análise de Clientes com Configurações Específicas

**Objetivo:** Identificar clientes que têm tabela de faturamento ou verificação configurada.

```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    ce.TFCODIGO,
    tf.TFCODIGO AS TABELA_FATURAMENTO,
    ce.CEEMPVRFAT AS VERIFICACAO_FATURAMENTO
FROM CLIEMP ce
INNER JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
LEFT JOIN TABFAT tf ON tf.TFCODIGO = ce.TFCODIGO
WHERE ce.TFCODIGO IS NOT NULL
   OR ce.CEEMPVRFAT IS NOT NULL
ORDER BY ce.CLICODIGO, ce.EMPCODIGO;
```

---

### 6. Comparação CLIEMP vs CLIEMPCMP

**Objetivo:** Identificar clientes que têm configuração básica (CLIEMP) mas não têm configuração completa (CLIEMPCMP).

```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    CASE 
        WHEN cec.CLICODIGO IS NOT NULL THEN 'SIM'
        ELSE 'NÃO'
    END AS TEM_CONFIGURACAO_COMPLETA
FROM CLIEMP ce
INNER JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
LEFT JOIN CLIEMPCMP cec ON cec.CLICODIGO = ce.CLICODIGO 
    AND cec.EMPCODIGO = ce.EMPCODIGO
ORDER BY ce.CLICODIGO, ce.EMPCODIGO;
```

---

### 7. Análise de Clientes Sem Configuração em Empresa

**Objetivo:** Identificar clientes que não estão configurados em nenhuma empresa ou em empresas específicas.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    COUNT(DISTINCT ce.EMPCODIGO) AS TOTAL_EMPRESAS_CONFIGURADAS,
    STRING_AGG(DISTINCT emp.EMPRAZSOCIAL, ', ') AS EMPRESAS_CONFIGURADAS
FROM CLIEN cl
LEFT JOIN CLIEMP ce ON ce.CLICODIGO = cl.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT, cl.CLIRAZSOCIAL
HAVING COUNT(DISTINCT ce.EMPCODIGO) = 0
   OR COUNT(DISTINCT ce.EMPCODIGO) < (SELECT COUNT(*) FROM EMPRESA)
ORDER BY cl.CLINOMEFANT;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIEMP | Tipo |
|--------|-----------|---------------------|------|
| **CLIEMP** | 3.174 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 2.91:1 | Clientes (média de 0.34 empresas por cliente) |
| EMPRESA | 6 | 0.002:1 | Empresas (média de 529 clientes por empresa) |
| CLIEMPCMP | 68 | 0.021:1 | Configuração completa (muito menor que CLIEMP) |

**Interpretação:**
- **3.174 associações** cliente-empresa cadastradas no sistema
- **Média de 0.34 empresas por cliente** - maioria dos clientes está em apenas uma empresa
- **Média de 529 clientes por empresa** - distribuição concentrada
- **CLIEMPCMP tem apenas 68 registros** - muito menor que CLIEMP, indicando que poucos clientes têm configuração completa

**Distribuição Esperada:**
- Clientes em múltiplas empresas: clientes que operam com várias filiais
- Clientes em uma empresa: clientes específicos de uma filial
- Empresas com muitos clientes: empresas principais do grupo
- Empresas com poucos clientes: empresas novas ou específicas

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLICODIGO, EMPCODIGO** | CLIEMP | Chave primária composta (PK) |
| **CLICODIGO** | CLIEMP → CLIEN | Cliente da associação |
| **EMPCODIGO** | CLIEMP → EMPRESA | Empresa da associação |
| **TFCODIGO** | CLIEMP → TABFAT | Tabela de faturamento específica |
| **CEEMPVRFAT** | CLIEMP | Verificação de faturamento por empresa |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIEMP.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por empresa** - Para buscas por empresa
4. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIEMP_CLIENTE ON CLIEMP(CLICODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CLIEMP_EMPRESA ON CLIEMP(EMPCODIGO);

-- Índice 3: Busca composta por cliente e empresa (consultas de validação)
CREATE INDEX IDX_CLIEMP_CLI_EMP ON CLIEMP(CLICODIGO, EMPCODIGO);

-- Índice 4: Busca por tabela de faturamento (consultas específicas)
CREATE INDEX IDX_CLIEMP_TABFAT ON CLIEMP(TFCODIGO) 
    WHERE TFCODIGO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela pequena** (3.174 registros) - Performance excelente
- **Consultas são muito rápidas** devido ao volume pequeno
- **Índices úteis** para buscas por cliente e empresa
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e empresa

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK composta)
SELECT CLICODIGO, EMPCODIGO, TFCODIGO, CEEMPVRFAT
FROM CLIEMP
WHERE CLICODIGO = ?
  AND EMPCODIGO = ?;

-- ✅ OTIMIZADO (usar índice em CLICODIGO)
SELECT CLICODIGO, EMPCODIGO
FROM CLIEMP
WHERE CLICODIGO = ?
ORDER BY EMPCODIGO;

-- ✅ OTIMIZADO (usar índice em EMPCODIGO)
SELECT CLICODIGO, EMPCODIGO
FROM CLIEMP
WHERE EMPCODIGO = ?
ORDER BY CLICODIGO;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CLICODIGO, EMPCODIGO, TFCODIGO
FROM CLIEMP
WHERE CLICODIGO = ?
  AND EMPCODIGO = ?
ORDER BY TFCODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar associações sem cliente válido
SELECT ce.*
FROM CLIEMP ce
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar associações sem empresa válida
SELECT ce.*
FROM CLIEMP ce
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
WHERE emp.EMPCODIGO IS NULL;

-- Verificar associações com tabela de faturamento inválida
SELECT ce.*
FROM CLIEMP ce
LEFT JOIN TABFAT tf ON tf.TFCODIGO = ce.TFCODIGO
WHERE ce.TFCODIGO IS NOT NULL
  AND tf.TFCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIEMP
WHERE CLICODIGO IS NULL
   OR EMPCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM CLIEMP
GROUP BY CLICODIGO, EMPCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos de verificação de faturamento
SELECT *
FROM CLIEMP
WHERE CEEMPVRFAT IS NOT NULL
  AND (CEEMPVRFAT < 0 OR CEEMPVRFAT > 999);
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por cliente
SELECT
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_ASSOCIACOES,
    AVG(ASSOCIACOES_POR_CLIENTE) AS MEDIA_ASSOCIACOES_POR_CLIENTE,
    MAX(ASSOCIACOES_POR_CLIENTE) AS MAX_ASSOCIACOES_POR_CLIENTE,
    MIN(ASSOCIACOES_POR_CLIENTE) AS MIN_ASSOCIACOES_POR_CLIENTE
FROM (
    SELECT 
        CLICODIGO,
        COUNT(*) AS ASSOCIACOES_POR_CLIENTE
    FROM CLIEMP
    GROUP BY CLICODIGO
);

-- Verificar distribuição por empresa
SELECT
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_ASSOCIACOES,
    AVG(ASSOCIACOES_POR_EMPRESA) AS MEDIA_ASSOCIACOES_POR_EMPRESA,
    MAX(ASSOCIACOES_POR_EMPRESA) AS MAX_ASSOCIACOES_POR_EMPRESA,
    MIN(ASSOCIACOES_POR_EMPRESA) AS MIN_ASSOCIACOES_POR_EMPRESA
FROM (
    SELECT 
        EMPCODIGO,
        COUNT(*) AS ASSOCIACOES_POR_EMPRESA
    FROM CLIEMP
    GROUP BY EMPCODIGO
);

-- Verificar associações com configurações específicas
SELECT
    COUNT(*) AS TOTAL_ASSOCIACOES,
    COUNT(CASE WHEN TFCODIGO IS NOT NULL THEN 1 END) AS COM_TABELA_FATURAMENTO,
    COUNT(CASE WHEN CEEMPVRFAT IS NOT NULL THEN 1 END) AS COM_VERIFICACAO_FATURAMENTO,
    COUNT(CASE WHEN TFCODIGO IS NOT NULL AND CEEMPVRFAT IS NOT NULL THEN 1 END) AS COM_AMBAS_CONFIGURACOES
FROM CLIEMP;
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

final class FirebirdCliemp extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIEMP';
    
    protected $primaryKey = ['CLICODIGO', 'EMPCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'TFCODIGO' => 'integer',
        'CEEMPVRFAT' => 'integer',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com EMPRESA (lógico)
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com TABFAT (lógico)
    public function tabelaFaturamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdTabfat::class, 'TFCODIGO', 'TFCODIGO');
    }

    // Método para verificar se tem tabela de faturamento configurada
    public function temTabelaFaturamento(): bool
    {
        return !empty($this->TFCODIGO);
    }

    // Método para verificar se tem verificação de faturamento configurada
    public function temVerificacaoFaturamento(): bool
    {
        return !empty($this->CEEMPVRFAT);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por cliente e empresa
    public function scopePorClienteEmpresa($query, int $clienteCodigo, int $empresaCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar associações com tabela de faturamento
    public function scopeComTabelaFaturamento($query)
    {
        return $query->whereNotNull('TFCODIGO');
    }

    // Scope para filtrar associações com verificação de faturamento
    public function scopeComVerificacaoFaturamento($query)
    {
        return $query->whereNotNull('CEEMPVRFAT');
    }

    // Método estático para buscar associação específica
    public static function buscarAssociacao(int $clienteCodigo, int $empresaCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->first();
    }

    // Método estático para verificar se cliente está em empresa
    public static function clienteEstaEmEmpresa(int $clienteCodigo, int $empresaCodigo): bool
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->exists();
    }

    // Método estático para obter empresas de um cliente
    public static function getEmpresasDoCliente(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->with('empresa')
            ->get()
            ->pluck('empresa');
    }

    // Método estático para obter clientes de uma empresa
    public static function getClientesDaEmpresa(int $empresaCodigo): \Illuminate\Support\Collection
    {
        return self::where('EMPCODIGO', $empresaCodigo)
            ->with('cliente')
            ->get()
            ->pluck('cliente');
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_associacoes' => self::count(),
            'total_clientes' => self::distinct('CLICODIGO')->count(),
            'total_empresas' => self::distinct('EMPCODIGO')->count(),
            'com_tabela_faturamento' => self::comTabelaFaturamento()->count(),
            'com_verificacao_faturamento' => self::comVerificacaoFaturamento()->count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Relacionamento lógico** - EMPCODIGO referencia EMPRESA mesmo sem FK formal

### Performance

1. **Tabela pequena** - 3.174 registros, performance excelente
2. **Índices úteis** - Em CLICODIGO e EMPCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + empresa)
4. **Consultas rápidas** - Volume pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - CEEMPVRFAT deve estar em range válido

### Manutenção

1. **Revisão periódica** - Verificar associações não utilizadas
2. **Padronização** - Manter estrutura de configurações consistente
3. **Documentação** - Documentar significado de TFCODIGO e CEEMPVRFAT
4. **Backup regular** - Tabela importante para configuração multi-empresa

### Regras de Negócio

1. **Validação em tempo real** - Verificar se cliente está em empresa antes de usar
2. **Consistência** - Garantir que clientes usados em pedidos/notas estão configurados
3. **Multi-empresa** - Cada empresa pode ter diferentes conjuntos de clientes
4. **Configuração opcional** - TFCODIGO e CEEMPVRFAT são opcionais

### Observações Especiais

1. **Arquitetura multi-empresa** - CLIEMP é fundamental para controle de acesso
2. **Relacionamento lógico** - EMPCODIGO referencia EMPRESA sem FK formal
3. **Configuração básica** - CLIEMP é versão básica, CLIEMPCMP é versão completa
4. **Sem dependentes** - Tabela folha utilizada para configuração e consulta

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

