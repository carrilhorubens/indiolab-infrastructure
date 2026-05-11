# CLIFORCTB - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIFORCTB (Cliente x Fornecedor Contábil)
- **Total de Registros**: 12.901
- **Total de Colunas**: 4
- **Chave Primária**: (CLICODIGO, EMPCODIGO, CFCTBTIPO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIFORCTB** é uma tabela de configuração contábil que associa clientes/fornecedores a códigos contábeis específicos por empresa e tipo. Com **12.901 registros**, representa configurações contábeis detalhadas para integração com sistemas contábeis externos.

Esta tabela funciona como **mapeador de códigos contábeis cliente-empresa-tipo** e permite:
- Associar clientes/fornecedores a códigos contábeis específicos por empresa
- Suportar múltiplos tipos de códigos contábeis por cliente-empresa
- Facilitar integração com sistemas contábeis externos
- Permitir diferentes códigos contábeis por empresa para o mesmo cliente
- Suportar exportação de dados contábeis padronizados

Cada registro representa um código contábil específico para um cliente/fornecedor em uma empresa, contendo:
- Identificação do cliente/fornecedor (CLICODIGO)
- Código contábil (CFCCODCTB)
- Tipo de código contábil (CFCTBTIPO)
- Empresa da configuração (EMPCODIGO)

O sistema utiliza esta tabela para determinar qual código contábil usar ao exportar dados para sistemas contábeis externos, permitindo integração precisa e padronizada.

**Observação Importante:** CLIFORCTB é uma das tabelas mais utilizadas para configuração cliente-empresa, com 12.901 registros. Isso indica uso extensivo de códigos contábeis personalizados, essencial para integração contábil.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente/fornecedor (PK + FK → CLIEN) |
| **EMPCODIGO** 🔑🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |
| **CFCTBTIPO** 🔑 | VARCHAR(14) | ✓ | Tipo de código contábil (PK) |

### Código Contábil
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CFCCODCTB** | VARCHAR(37) | ✓ | Código contábil usado no sistema contábil externo |

**Primary Key:** (CLICODIGO, EMPCODIGO, CFCTBTIPO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente/fornecedor que terá código contábil configurado.
- **EMPCODIGO**: Empresa onde a configuração se aplica.
- **CFCTBTIPO**: Tipo de código contábil (ex: "CLIENTE", "FORNECEDOR", "RECEBER", "PAGAR", etc.).
- **CFCCODCTB**: Código usado no sistema contábil externo para identificar o cliente/fornecedor.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIFORCTB Referencia (2 FKs):

#### 1. CLIEN - Clientes/Fornecedores
**Relacionamento:**
```
CLIFORCTB.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIFORCTB
```

**Descrição**: Cada código contábil está vinculado a um cliente/fornecedor específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes/fornecedores
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente/fornecedor da configuração, relatórios de códigos contábeis por cliente.

---

#### 2. EMPRESA - Empresas
**Relacionamento:**
```
CLIFORCTB.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_CLIFORCTB
```

**Descrição**: Cada código contábil está vinculado a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** Múltiplas empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos

**Uso:** Identificar a empresa da configuração, relatórios por empresa.

---

### CLIFORCTB é Referenciada Por

**Nenhuma tabela** referencia CLIFORCTB diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIFORCTB → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados ao código contábil.

**Uso:** Análises de pedidos considerando códigos contábeis, exportação de dados contábeis de pedidos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIFORCTB → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas ao código contábil.

**Uso:** Análises de notas fiscais considerando códigos contábeis, exportação de dados contábeis de notas.

---

### Via CLIEN → RECEB (Contas a Receber)

**Fluxo:** CLIFORCTB → CLIEN → RECEB

**Descrição:** Através do cliente, é possível identificar contas a receber que podem estar relacionadas ao código contábil.

**Uso:** Análises de contas a receber considerando códigos contábeis, exportação de dados contábeis.

---

### Via CLIEN → PAGAR (Contas a Pagar)

**Fluxo:** CLIFORCTB → CLIEN → PAGAR

**Descrição:** Através do fornecedor, é possível identificar contas a pagar que podem estar relacionadas ao código contábil.

**Uso:** Análises de contas a pagar considerando códigos contábeis, exportação de dados contábeis.

---

### Via EMPRESA → NOTAS (Notas Fiscais)

**Fluxo:** CLIFORCTB → EMPRESA → NOTAS

**Descrição:** Através da empresa, é possível identificar notas fiscais que podem estar relacionadas ao código contábil.

**Uso:** Análises de notas fiscais por empresa considerando códigos contábeis.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Código Contábil

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente/fornecedor e empresa.

**Fluxo:**
```
CLIFORCTB (CLICODIGO, EMPCODIGO, CFCTBTIPO, CFCCODCTB)
  ↓
CLIEN (CLICODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cfc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_FORNECEDOR,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cl.CLICLIENTE AS E_CLIENTE,
    cl.CLIFORNEC AS E_FORNECEDOR,
    cfc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cfc.CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    cfc.CFCCODCTB AS CODIGO_CONTABIL
FROM CLIFORCTB cfc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cfc.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cfc.EMPCODIGO
WHERE cfc.CLICODIGO = ?
  AND cfc.EMPCODIGO = ?
  AND cfc.CFCTBTIPO = ?;
```

---

### Exemplo 2: Análise de Códigos Contábeis por Empresa

**Objetivo:** Identificar todos os códigos contábeis de uma empresa específica.

**Fluxo:**
```
EMPRESA (EMPCODIGO)
  ↓
CLIFORCTB (EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cfc.CLICODIGO) AS TOTAL_CLIENTES_FORNECEDORES,
    COUNT(DISTINCT cfc.CFCTBTIPO) AS TOTAL_TIPOS_CODIGOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    STRING_AGG(DISTINCT cfc.CFCTBTIPO, ', ') AS TIPOS_UTILIZADOS
FROM EMPRESA emp
LEFT JOIN CLIFORCTB cfc ON cfc.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### Exemplo 3: Análise de Códigos Contábeis com Notas Fiscais

**Objetivo:** Obter códigos contábeis com informações de notas fiscais relacionadas.

**Fluxo:**
```
CLIFORCTB (CLICODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
NOTAS (CLICODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cfc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_FORNECEDOR,
    cfc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cfc.CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    cfc.CFCCODCTB AS CODIGO_CONTABIL,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS_FISCAIS,
    SUM(nf.NFVRMERC) AS VALOR_TOTAL_NOTAS
FROM CLIFORCTB cfc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cfc.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cfc.EMPCODIGO
LEFT JOIN NOTAS nf ON nf.CLICODIGO = cfc.CLICODIGO
  AND nf.EMPCODIGO = cfc.EMPCODIGO
WHERE cfc.CFCTBTIPO = 'CLIENTE'
GROUP BY cfc.CLICODIGO, cl.CLINOMEFANT, cfc.EMPCODIGO, emp.EMPNOMEFANT, cfc.CFCTBTIPO, cfc.CFCCODCTB
ORDER BY TOTAL_NOTAS_FISCAIS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Código Contábil de Cliente/Fornecedor

**Objetivo:** Obter o código contábil de um cliente/fornecedor em uma empresa e tipo específicos.

```sql
SELECT
    cfc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_FORNECEDOR,
    cfc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cfc.CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    cfc.CFCCODCTB AS CODIGO_CONTABIL
FROM CLIFORCTB cfc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cfc.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cfc.EMPCODIGO
WHERE cfc.CLICODIGO = ?
  AND cfc.EMPCODIGO = ?
  AND cfc.CFCTBTIPO = ?;
```

---

### 2. Listar Todos os Códigos Contábeis de um Cliente/Fornecedor

**Objetivo:** Obter todos os códigos contábeis de um cliente/fornecedor em todas as empresas e tipos.

```sql
SELECT
    cfc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cfc.CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    cfc.CFCCODCTB AS CODIGO_CONTABIL
FROM CLIFORCTB cfc
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cfc.EMPCODIGO
WHERE cfc.CLICODIGO = ?
ORDER BY emp.EMPNOMEFANT, cfc.CFCTBTIPO;
```

---

### 3. Relatório de Códigos Contábeis por Empresa

**Objetivo:** Analisar distribuição de códigos contábeis por empresa e tipo.

```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cfc.CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    COUNT(DISTINCT cfc.CLICODIGO) AS TOTAL_CLIENTES_FORNECEDORES,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM EMPRESA emp
LEFT JOIN CLIFORCTB cfc ON cfc.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPNOMEFANT, cfc.CFCTBTIPO
ORDER BY emp.EMPNOMEFANT, TOTAL_CONFIGURACOES DESC;
```

---

### 4. Análise de Clientes/Fornecedores Sem Código Contábil

**Objetivo:** Identificar clientes/fornecedores que não têm código contábil configurado em uma empresa e tipo específicos.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_FORNECEDOR,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL
FROM CLIEN cl
LEFT JOIN CLIFORCTB cfc ON cfc.CLICODIGO = cl.CLICODIGO
  AND cfc.EMPCODIGO = ?
  AND cfc.CFCTBTIPO = ?
WHERE (cl.CLICLIENTE = 'S' OR cl.CLIFORNEC = 'S')
  AND cfc.CLICODIGO IS NULL
ORDER BY cl.CLINOMEFANT;
```

---

### 5. Análise de Tipos de Códigos Contábeis Utilizados

**Objetivo:** Identificar quais tipos de códigos contábeis são mais utilizados.

```sql
SELECT
    CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_FORNECEDORES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM CLIFORCTB
GROUP BY CFCTBTIPO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 6. Comparação com Outras Configurações de Cliente

**Objetivo:** Comparar códigos contábeis com outras configurações de cliente.

**Query SQL:**
```sql
SELECT
    'CLIFORCTB' AS TIPO_CONFIGURACAO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS
FROM CLIFORCTB
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

### 7. Análise de Códigos Contábeis Duplicados

**Objetivo:** Identificar códigos contábeis duplicados que podem indicar inconsistências.

```sql
SELECT
    EMPCODIGO,
    CFCTBTIPO AS TIPO_CODIGO_CONTABIL,
    CFCCODCTB AS CODIGO_CONTABIL,
    COUNT(*) AS TOTAL_OCORRENCIAS,
    STRING_AGG(CAST(CLICODIGO AS VARCHAR), ', ') AS CLIENTES_FORNECEDORES
FROM CLIFORCTB
GROUP BY EMPCODIGO, CFCTBTIPO, CFCCODCTB
HAVING COUNT(*) > 1
ORDER BY TOTAL_OCORRENCIAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIFORCTB | Tipo |
|--------|-----------|---------------------|------|
| **CLIFORCTB** | 12.901 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 0.72:1 | Clientes/Fornecedores (média de 1.39 configurações por cliente) |
| EMPRESA | 6 | 0.0005:1 | Empresas (média de 2.150 configurações por empresa) |

**Interpretação:**
- **12.901 configurações** cadastradas no sistema
- **139% dos clientes** têm pelo menos uma configuração de código contábil (média de 1.39 por cliente)
- **Uso extensivo** - indica integração contábil importante
- **Média de 2.150 configurações por empresa** - uso muito intenso

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIFORCTB.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por empresa** - Para buscas por empresa
4. **Índice por tipo** - Para buscas por tipo de código contábil
5. **Índice por código contábil** - Para buscas reversas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIFORCTB_CLIENTE ON CLIFORCTB(CLICODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CLIFORCTB_EMPRESA ON CLIFORCTB(EMPCODIGO);

-- Índice 3: Busca por tipo de código contábil (consultas frequentes)
CREATE INDEX IDX_CLIFORCTB_TIPO ON CLIFORCTB(CFCTBTIPO);

-- Índice 4: Busca por código contábil (consultas reversas)
CREATE INDEX IDX_CLIFORCTB_CODIGO_CONTABIL ON CLIFORCTB(CFCCODCTB)
    WHERE CFCCODCTB IS NOT NULL AND CFCCODCTB != '';

-- Índice 5: Busca composta por cliente e empresa (consultas de validação)
CREATE INDEX IDX_CLIFORCTB_CLI_EMP ON CLIFORCTB(CLICODIGO, EMPCODIGO);

-- Índice 6: Busca composta por empresa e tipo (consultas frequentes)
CREATE INDEX IDX_CLIFORCTB_EMP_TIPO ON CLIFORCTB(EMPCODIGO, CFCTBTIPO);
```

### Observações sobre Volume

- **Tabela média** (12.901 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Códigos contábeis são consultados frequentemente
- **Índices essenciais** - Em CLICODIGO, EMPCODIGO, CFCTBTIPO e CFCCODCTB
- **Focar em índices compostos** - Consultas geralmente filtram por múltiplos campos

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT cfc.*
FROM CLIFORCTB cfc
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cfc.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem empresa válida
SELECT cfc.*
FROM CLIFORCTB cfc
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cfc.EMPCODIGO
WHERE emp.EMPCODIGO IS NULL;

-- Verificar códigos contábeis vazios
SELECT *
FROM CLIFORCTB
WHERE CFCCODCTB IS NULL
   OR CFCCODCTB = '';
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIFORCTB
WHERE CLICODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR CFCTBTIPO IS NULL
   OR CFCTBTIPO = ''
   OR CFCCODCTB IS NULL
   OR CFCCODCTB = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, EMPCODIGO, CFCTBTIPO, COUNT(*) AS QTD
FROM CLIFORCTB
GROUP BY CLICODIGO, EMPCODIGO, CFCTBTIPO
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

final class FirebirdCliforctb extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIFORCTB';
    
    protected $primaryKey = ['CLICODIGO', 'EMPCODIGO', 'CFCTBTIPO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'CFCTBTIPO' => 'string',
        'CFCCODCTB' => 'string',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
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

    // Scope para filtrar por tipo de código contábil
    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('CFCTBTIPO', $tipo);
    }

    // Scope para filtrar por cliente, empresa e tipo
    public function scopePorClienteEmpresaTipo($query, int $clienteCodigo, int $empresaCodigo, string $tipo)
    {
        return $query->where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->where('CFCTBTIPO', $tipo);
    }

    // Método estático para buscar código contábil específico
    public static function buscarCodigoContabil(int $clienteCodigo, int $empresaCodigo, string $tipo): ?string
    {
        $config = self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->where('CFCTBTIPO', $tipo)
            ->first();
        return $config?->CFCCODCTB;
    }

    // Método estático para definir código contábil
    public static function definirCodigoContabil(int $clienteCodigo, int $empresaCodigo, string $tipo, string $codigoContabil): bool
    {
        return self::updateOrCreate(
            ['CLICODIGO' => $clienteCodigo, 'EMPCODIGO' => $empresaCodigo, 'CFCTBTIPO' => $tipo],
            ['CFCCODCTB' => $codigoContabil]
        ) !== null;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 3 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Padronização de tipos** - Manter valores de CFCTBTIPO consistentes

### Performance

1. **Tabela média** - 12.901 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO, EMPCODIGO, CFCTBTIPO e CFCCODCTB
3. **Índices compostos** - Para consultas combinadas (cliente + empresa + tipo)
4. **Consultas frequentes** - Códigos contábeis são consultados frequentemente

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de tipos** - Verificar valores válidos de CFCTBTIPO

### Manutenção

1. **Revisão periódica** - Verificar códigos contábeis não utilizados
2. **Padronização** - Manter estrutura de tipos consistente
3. **Documentação** - Documentar significado de cada tipo de código contábil
4. **Backup regular** - Tabela importante para integração contábil

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

