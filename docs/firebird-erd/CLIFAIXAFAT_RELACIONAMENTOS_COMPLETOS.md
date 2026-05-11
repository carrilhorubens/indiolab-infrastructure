# CLIFAIXAFAT - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIFAIXAFAT (Cliente x Faixa de Faturamento)
- **Total de Registros**: 46
- **Total de Colunas**: 4
- **Chave Primária**: (CLICODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIFAIXAFAT** é uma tabela de configuração que associa clientes a faixas de faturamento por empresa. Com **46 registros**, representa configurações específicas de verificação de faturamento para clientes em diferentes empresas.

Esta tabela funciona como **configurador de faixas de faturamento por cliente-empresa** e permite:
- Associar clientes a tabelas de faturamento específicas por empresa
- Controlar verificação de faturamento por cliente
- Permitir diferentes configurações de faturamento por empresa para o mesmo cliente
- Suportar regras de negócio específicas por empresa
- Facilitar gestão de faturamento personalizado

Cada registro representa uma configuração específica de faixa de faturamento para um cliente em uma empresa, contendo:
- Identificação do cliente (CLICODIGO)
- Tabela de faturamento associada (TFCODIGO)
- Tipo de verificação (TPVERIFICACAO)
- Empresa da configuração (EMPCODIGO)

O sistema utiliza esta tabela para determinar qual tabela de faturamento e regras de verificação aplicar para cada cliente em cada empresa, permitindo personalização completa do processo de faturamento.

**Observação Importante:** CLIFAIXAFAT complementa CLIEMP e CLIEMPCMP, fornecendo configurações específicas de faixas de faturamento. Com apenas 46 registros, indica uso específico para clientes que requerem configurações especiais de faturamento.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **EMPCODIGO** 🔑🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Configuração de Faturamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TFCODIGO** 🔗 | SMALLINT | ✓ | Código da tabela de faturamento (FK → TABFAT) |
| **TPVERIFICACAO** | SMALLINT | ✓ | Tipo de verificação de faturamento |

**Primary Key:** (CLICODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que terá configuração de faixa de faturamento.
- **EMPCODIGO**: Empresa onde a configuração se aplica.
- **TFCODIGO**: Tabela de faturamento associada ao cliente na empresa.
- **TPVERIFICACAO**: Tipo de verificação aplicada (valores específicos do sistema).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIFAIXAFAT Referencia (3 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIFAIXAFAT.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: XFK_CLIFAIXAFAT_CLIEN
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

#### 2. TABFAT - Tabelas de Faturamento
**Relacionamento:**
```
CLIFAIXAFAT.TFCODIGO → TABFAT.TFCODIGO (N:1)
Constraint: XFK_CLIFAIXAFAT_TABFAT
```

**Descrição**: Cada configuração está vinculada a uma tabela de faturamento específica.

**Informações da Tabela TABFAT:**
- **Total:** 2 tabelas de faturamento
- **PK:** TFCODIGO
- **Colunas:** 2 campos
- **FK Out:** 0
- **FK In:** 2 tabelas

**Campos importantes em TABFAT:**
- `TFCODIGO` - Código da tabela de faturamento
- `TFDESCRICAO` - Descrição da tabela de faturamento

**Uso:** Identificar a tabela de faturamento associada, obter descrição da tabela.

---

#### 3. EMPRESA - Empresas
**Relacionamento:**
```
CLIFAIXAFAT.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: XFK_CLIFAIXAFAT_EMPRESA
```

**Descrição**: Cada configuração está vinculada a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** Múltiplas empresas
- **PK:** EMPCODIGO
- **Colunas:** Múltiplos campos

**Uso:** Identificar a empresa da configuração, relatórios por empresa.

---

### CLIFAIXAFAT é Referenciada Por

**Nenhuma tabela** referencia CLIFAIXAFAT diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIFAIXAFAT → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados à configuração de faturamento.

**Uso:** Análises de pedidos considerando configurações de faturamento, aplicação de regras de faturamento em pedidos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIFAIXAFAT → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas à configuração de faturamento.

**Uso:** Análises de notas fiscais considerando configurações de faturamento.

---

### Via TABFAT → TABFXFAT (Faixas de Faturamento)

**Fluxo:** CLIFAIXAFAT → TABFAT → TABFXFAT

**Descrição:** Através da tabela de faturamento, é possível identificar faixas de valores e descontos aplicáveis.

**Uso:** Obter faixas de valores e descontos da tabela de faturamento associada.

---

### Via EMPRESA → NOTAS (Notas Fiscais)

**Fluxo:** CLIFAIXAFAT → EMPRESA → NOTAS

**Descrição:** Através da empresa, é possível identificar notas fiscais que podem estar relacionadas à configuração.

**Uso:** Análises de notas fiscais por empresa considerando configurações de faturamento.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração de Faturamento

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente, tabela de faturamento e empresa.

**Fluxo:**
```
CLIFAIXAFAT (CLICODIGO, EMPCODIGO, TFCODIGO, TPVERIFICACAO)
  ↓
CLIEN (CLICODIGO)
  ↓
TABFAT (TFCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cff.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cff.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cff.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    cff.TPVERIFICACAO AS TIPO_VERIFICACAO
FROM CLIFAIXAFAT cff
INNER JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
INNER JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cff.EMPCODIGO
WHERE cff.CLICODIGO = ?
  AND cff.EMPCODIGO = ?;
```

---

### Exemplo 2: Análise de Configurações por Empresa

**Objetivo:** Identificar todas as configurações de faturamento de uma empresa específica.

**Fluxo:**
```
EMPRESA (EMPCODIGO)
  ↓
CLIFAIXAFAT (EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
TABFAT (TFCODIGO)
```

**Query SQL:**
```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cff.CLICODIGO) AS TOTAL_CLIENTES_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    STRING_AGG(cl.CLINOMEFANT || ' (' || tf.TFDESCRICAO || ')', ', ') AS CLIENTES_CONFIGURADOS
FROM EMPRESA emp
LEFT JOIN CLIFAIXAFAT cff ON cff.EMPCODIGO = emp.EMPCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
LEFT JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
WHERE emp.EMPCODIGO = ?
GROUP BY emp.EMPCODIGO, emp.EMPNOMEFANT;
```

---

### Exemplo 3: Análise de Configurações com Faixas de Faturamento

**Objetivo:** Obter configurações de faturamento com faixas de valores e descontos aplicáveis.

**Fluxo:**
```
CLIFAIXAFAT (TFCODIGO)
  ↓
TABFAT (TFCODIGO)
  ↓
TABFXFAT (TFCODIGO)
```

**Query SQL:**
```sql
SELECT
    cff.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cff.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    cff.TPVERIFICACAO AS TIPO_VERIFICACAO,
    COUNT(tfx.TFSEQ) AS TOTAL_FAIXAS,
    MIN(tfx.TFVALORINI) AS VALOR_MINIMO,
    MAX(tfx.TFVALORFIN) AS VALOR_MAXIMO,
    AVG(tfx.TFVALORDESCTO) AS DESCONTO_MEDIO
FROM CLIFAIXAFAT cff
INNER JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
INNER JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
LEFT JOIN TABFXFAT tfx ON tfx.TFCODIGO = cff.TFCODIGO
WHERE cff.CLICODIGO = ?
GROUP BY cff.CLICODIGO, cl.CLINOMEFANT, cff.TFCODIGO, tf.TFDESCRICAO, cff.TPVERIFICACAO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Faturamento de Cliente

**Objetivo:** Obter a configuração de faturamento de um cliente em uma empresa específica.

```sql
SELECT
    cff.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cff.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cff.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    cff.TPVERIFICACAO AS TIPO_VERIFICACAO
FROM CLIFAIXAFAT cff
INNER JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cff.EMPCODIGO
INNER JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
WHERE cff.CLICODIGO = ?
  AND cff.EMPCODIGO = ?;
```

---

### 2. Listar Todas as Configurações de um Cliente

**Objetivo:** Obter todas as configurações de faturamento de um cliente em todas as empresas.

```sql
SELECT
    cff.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cff.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    cff.TPVERIFICACAO AS TIPO_VERIFICACAO
FROM CLIFAIXAFAT cff
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cff.EMPCODIGO
INNER JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
WHERE cff.CLICODIGO = ?
ORDER BY emp.EMPNOMEFANT;
```

---

### 3. Relatório de Configurações por Empresa

**Objetivo:** Analisar distribuição de configurações de faturamento por empresa.

```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cff.CLICODIGO) AS TOTAL_CLIENTES_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT cff.TFCODIGO) AS TOTAL_TABELAS_UTILIZADAS
FROM EMPRESA emp
LEFT JOIN CLIFAIXAFAT cff ON cff.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_CLIENTES_CONFIGURADOS DESC;
```

---

### 4. Análise de Clientes Sem Configuração

**Objetivo:** Identificar clientes que não têm configuração de faturamento em uma empresa específica.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL
FROM CLIEN cl
LEFT JOIN CLIFAIXAFAT cff ON cff.CLICODIGO = cl.CLICODIGO
  AND cff.EMPCODIGO = ?
WHERE cl.CLICLIENTE = 'S'
  AND cff.CLICODIGO IS NULL
ORDER BY cl.CLINOMEFANT;
```

---

### 5. Análise de Tabelas de Faturamento Utilizadas

**Objetivo:** Identificar quais tabelas de faturamento são mais utilizadas.

```sql
SELECT
    tf.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    COUNT(DISTINCT cff.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT cff.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM TABFAT tf
LEFT JOIN CLIFAIXAFAT cff ON cff.TFCODIGO = tf.TFCODIGO
GROUP BY tf.TFCODIGO, tf.TFDESCRICAO
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 6. Comparação com Outras Configurações de Cliente

**Objetivo:** Comparar configurações de faturamento com outras configurações de cliente.

**Query SQL:**
```sql
SELECT
    'CLIFAIXAFAT' AS TIPO_CONFIGURACAO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS
FROM CLIFAIXAFAT
UNION ALL
SELECT
    'CLIEMP' AS TIPO_CONFIGURACAO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS
FROM CLIEMP
UNION ALL
SELECT
    'CLIEMPCMP' AS TIPO_CONFIGURACAO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS
FROM CLIEMPCMP
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 7. Análise de Configurações com Faixas de Valores

**Objetivo:** Obter configurações com informações detalhadas de faixas de valores e descontos.

```sql
SELECT
    cff.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cff.TFCODIGO,
    tf.TFDESCRICAO AS TABELA_FATURAMENTO,
    cff.TPVERIFICACAO AS TIPO_VERIFICACAO,
    COUNT(tfx.TFSEQ) AS TOTAL_FAIXAS,
    MIN(tfx.TFVALORINI) AS VALOR_MINIMO,
    MAX(tfx.TFVALORFIN) AS VALOR_MAXIMO,
    AVG(tfx.TFVALORDESCTO) AS DESCONTO_MEDIO,
    MAX(tfx.TFVALORDESCTO) AS DESCONTO_MAXIMO
FROM CLIFAIXAFAT cff
INNER JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
INNER JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
LEFT JOIN TABFXFAT tfx ON tfx.TFCODIGO = cff.TFCODIGO
GROUP BY cff.CLICODIGO, cl.CLINOMEFANT, cff.TFCODIGO, tf.TFDESCRICAO, cff.TPVERIFICACAO
ORDER BY TOTAL_FAIXAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIFAIXAFAT | Tipo |
|--------|-----------|---------------------|------|
| **CLIFAIXAFAT** | 46 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 201:1 | Clientes (média de 0.005 configurações por cliente) |
| TABFAT | 2 | 0.043:1 | Tabelas de faturamento (média de 23 clientes por tabela) |
| EMPRESA | ? | ?:1 | Empresas |

**Interpretação:**
- **Apenas 46 configurações** cadastradas no sistema
- **0.5% dos clientes** têm configuração de faixa de faturamento (46 de 9.251)
- **Uso muito específico** - indica configurações especiais para clientes específicos
- **Média de 23 clientes por tabela** de faturamento

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIFAIXAFAT.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por empresa** - Para buscas por empresa
4. **Índice por tabela de faturamento** - Para buscas por tabela

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIFAIXAFAT_CLIENTE ON CLIFAIXAFAT(CLICODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CLIFAIXAFAT_EMPRESA ON CLIFAIXAFAT(EMPCODIGO);

-- Índice 3: Busca por tabela de faturamento (consultas frequentes)
CREATE INDEX IDX_CLIFAIXAFAT_TABFAT ON CLIFAIXAFAT(TFCODIGO);

-- Índice 4: Busca composta por cliente e empresa (consultas de validação)
CREATE INDEX IDX_CLIFAIXAFAT_CLI_EMP ON CLIFAIXAFAT(CLICODIGO, EMPCODIGO);
```

### Observações sobre Volume

- **Tabela muito pequena** (46 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por cliente, empresa e tabela de faturamento
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e empresa

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT cff.*
FROM CLIFAIXAFAT cff
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cff.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem tabela de faturamento válida
SELECT cff.*
FROM CLIFAIXAFAT cff
LEFT JOIN TABFAT tf ON tf.TFCODIGO = cff.TFCODIGO
WHERE tf.TFCODIGO IS NULL;

-- Verificar configurações sem empresa válida
SELECT cff.*
FROM CLIFAIXAFAT cff
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cff.EMPCODIGO
WHERE emp.EMPCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIFAIXAFAT
WHERE CLICODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR TFCODIGO IS NULL
   OR TPVERIFICACAO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM CLIFAIXAFAT
GROUP BY CLICODIGO, EMPCODIGO
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

final class FirebirdClifaixafat extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIFAIXAFAT';
    
    protected $primaryKey = ['CLICODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'TFCODIGO' => 'integer',
        'TPVERIFICACAO' => 'integer',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com TABFAT
    public function tabelaFaturamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdTabfat::class, 'TFCODIGO', 'TFCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
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

    // Método estático para buscar configuração específica
    public static function buscarConfiguracao(int $clienteCodigo, int $empresaCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente, tabela de faturamento e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Padronização de tipos de verificação** - Manter valores consistentes

### Performance

1. **Tabela muito pequena** - 46 registros, performance excelente
2. **Índices úteis** - Em CLICODIGO, EMPCODIGO e TFCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + empresa)
4. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de tipos de verificação** - Verificar valores válidos

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura de tipos de verificação consistente
3. **Documentação** - Documentar significado de cada tipo de verificação
4. **Backup regular** - Tabela importante para configurações

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

