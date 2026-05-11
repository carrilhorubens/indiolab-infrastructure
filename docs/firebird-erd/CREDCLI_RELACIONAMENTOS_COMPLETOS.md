# CREDCLI - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CREDCLI (Créditos de Clientes)
- **Total de Registros**: 34.345
- **Total de Colunas**: 14
- **Chave Primária**: CRECODIGO (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1 (IDX_CREDCL_CREDTCAD em CREDTCAD)
- **Tabelas Dependentes**: 4 (CREDCTB, LOTECHCREDCLI, NOTACRED, PEDXCREDCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CREDCLI** é uma tabela que armazena informações sobre créditos concedidos a clientes. Com **34.345 registros**, representa histórico extensivo de créditos concedidos, permitindo gestão completa de créditos e abatimentos de clientes.

Esta tabela funciona como **cadastro de créditos de clientes** e permite:
- Registrar créditos concedidos a clientes
- Controlar datas de cadastro e abatimento
- Associar créditos a documentos específicos
- Rastrear origem dos créditos
- Classificar créditos por tipo
- Controlar baixas de créditos
- Suportar autorizações específicas
- Integrar com sistema contábil

Cada registro representa um crédito específico concedido a um cliente, contendo:
- Código único do crédito (CRECODIGO)
- Cliente beneficiário (CLICODIGO)
- Empresa (EMPCODIGO)
- Datas de cadastro e abatimento (CREDTCAD, CREDTABATIMENTO)
- Valor do crédito (CREVALOR)
- Origem e tipo do crédito (CREORIGEM, CRETIPO)
- Documento relacionado (CRECODDOCTO)
- Número de baixa (CRENRBAIXA)
- Histórico e observações (CREHISTORICO)
- Tipo de movimento (CRETIPOMOV)
- Número de autorização (CRENRAUTORIZACAO)
- Tipo de ocorrência (TPOCCODIGO)

O sistema utiliza esta tabela para gerenciar todos os créditos concedidos a clientes, permitindo controle financeiro completo e rastreabilidade de abatimentos.

**Observação Importante:** CREDCLI é uma tabela importante do sistema financeiro, sendo referenciada por 4 tabelas diferentes. Com 34.345 registros e índice em CREDTCAD, indica consultas frequentes por data, essencial para gestão de créditos e relatórios financeiros.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CRECODIGO** 🔑 | INTEGER | ✓ | Código único do crédito |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔗 | INTEGER | ✓ | Código do cliente (FK → CLIEN) |
| **EMPCODIGO** | SMALLINT | ✓ | Código da empresa |
| **TPOCCODIGO** | SMALLINT | | Código do tipo de ocorrência (lógica → TPOCCO) |

### Informações Temporais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CREDTCAD** | DATE | ✓ | Data de cadastro do crédito |
| **CREDTABATIMENTO** | DATE | ✓ | Data de abatimento do crédito |

### Informações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CREVALOR** | NUMERIC(16,2) | ✓ | Valor do crédito |

### Informações de Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CREORIGEM** | VARCHAR(37) | ✓ | Origem do crédito |
| **CRETIPO** | VARCHAR(14) | ✓ | Tipo do crédito |
| **CRETIPOMOV** | VARCHAR(14) | | Tipo de movimento |
| **CRECODDOCTO** | INTEGER | | Código do documento relacionado |
| **CRENRBAIXA** | INTEGER | | Número da baixa |
| **CRENRAUTORIZACAO** | VARCHAR(37) | | Número de autorização |
| **CREHISTORICO** | VARCHAR(37) | | Histórico ou observações |

**Primary Key:** CRECODIGO

**Observações sobre Campos:**
- **CRECODIGO**: Identificador único de cada crédito.
- **CLICODIGO**: Cliente ao qual o crédito foi concedido.
- **EMPCODIGO**: Empresa que concedeu o crédito.
- **CREDTCAD**: Data em que o crédito foi cadastrado.
- **CREDTABATIMENTO**: Data em que o crédito foi abatido/utilizado.
- **CREVALOR**: Valor do crédito concedido.
- **CREORIGEM**: Origem do crédito (ex: "NOTA_CREDITO", "DEVOLUCAO", "AJUSTE").
- **CRETIPO**: Tipo do crédito (ex: "CREDITO", "ABATIMENTO").
- **CRECODDOCTO**: Código do documento que originou o crédito.
- **CRENRBAIXA**: Número da baixa que utilizou o crédito.
- **CRENRAUTORIZACAO**: Número de autorização quando necessário.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CREDCLI Referencia (1 FK):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CREDCLI.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CREDCLI
```

**Descrição**: Cada crédito está vinculado a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** ~? clientes
- **PK:** CLICODIGO
- **Colunas:** Múltiplos campos

**Uso:** Identificar o cliente do crédito, obter informações do cliente.

---

### CREDCLI é Referenciada Por (4 tabelas):

#### 1. CREDCTB - Créditos Contábeis
**Relacionamento:**
```
CREDCTB.CRECODIGO → CREDCLI.CRECODIGO (N:1)
Constraint: CREDCLI_CREDCTB
```

**Descrição**: CREDCTB referencia CREDCLI para registrar informações contábeis dos créditos.

**Uso:** Integração contábil dos créditos.

---

#### 2. LOTECHCREDCLI - Lotes de Cheque x Créditos de Clientes
**Relacionamento:**
```
LOTECHCREDCLI.CRECODIGO → CREDCLI.CRECODIGO (N:1)
Constraint: CREDCLI_LOTECHCREDCLI
```

**Descrição**: LOTECHCREDCLI referencia CREDCLI para associar créditos a lotes de cheque.

**Uso:** Associar créditos a lotes de cheque.

---

#### 3. NOTACRED - Notas de Crédito
**Relacionamento:**
```
NOTACRED.CRECODIGO → CREDCLI.CRECODIGO (N:1)
Constraint: NOTACRED_CREDCLI
```

**Descrição**: NOTACRED referencia CREDCLI para associar créditos a notas de crédito.

**Uso:** Associar créditos a notas de crédito fiscais.

---

#### 4. PEDXCREDCLI - Pedidos x Créditos de Clientes
**Relacionamento:**
```
PEDXCREDCLI.CRECODIGO → CREDCLI.CRECODIGO (N:1)
Constraint: FK_CREDCLI_PEDXCREDCLI
```

**Descrição**: PEDXCREDCLI referencia CREDCLI para associar créditos a pedidos.

**Uso:** Associar créditos a pedidos específicos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLICODIGO → CLIEN → Outras Operações do Cliente

**Fluxo:** CREDCLI → CLIEN → Operações

**Descrição:** Através do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de créditos por cliente.

---

### Via CREDCTB → Informações Contábeis

**Fluxo:** CREDCLI → CREDCTB → Contábil

**Descrição:** Através de CREDCTB, é possível identificar informações contábeis relacionadas.

**Uso:** Análise contábil de créditos.

---

### Via NOTACRED → Notas Fiscais

**Fluxo:** CREDCLI → NOTACRED → Notas Fiscais

**Descrição:** Através de NOTACRED, é possível identificar notas fiscais relacionadas.

**Uso:** Análise de créditos por nota fiscal.

---

### Via PEDXCREDCLI → PEDID (Pedidos)

**Fluxo:** CREDCLI → PEDXCREDCLI → PEDID

**Descrição:** Através de PEDXCREDCLI, é possível identificar pedidos relacionados.

**Uso:** Análise de créditos por pedido.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Crédito

**Objetivo:** Obter visão completa de um crédito incluindo informações do cliente e documentos relacionados.

**Fluxo:**
```
CREDCLI (CRECODIGO, CLICODIGO, CREVALOR)
  ↓
CLIEN (CLICODIGO)
  ↓
NOTACRED (CRECODIGO)
  ↓
PEDXCREDCLI (CRECODIGO)
  ↓
PEDID (ID_PEDIDO)
```

**Query SQL:**
```sql
SELECT
    cc.CRECODIGO,
    cc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cc.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cc.CREDTCAD AS DATA_CADASTRO,
    cc.CREDTABATIMENTO AS DATA_ABATIMENTO,
    cc.CREVALOR AS VALOR_CREDITO,
    cc.CREORIGEM AS ORIGEM,
    cc.CRETIPO AS TIPO,
    cc.CREHISTORICO AS HISTORICO,
    COUNT(DISTINCT nc.NOTCODIGO) AS TOTAL_NOTAS_CREDITO,
    COUNT(DISTINCT pxc.ID_PEDIDO) AS TOTAL_PEDIDOS_RELACIONADOS
FROM CREDCLI cc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cc.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cc.EMPCODIGO
LEFT JOIN NOTACRED nc ON nc.CRECODIGO = cc.CRECODIGO
LEFT JOIN PEDXCREDCLI pxc ON pxc.CRECODIGO = cc.CRECODIGO
WHERE cc.CRECODIGO = ?
GROUP BY cc.CRECODIGO, cc.CLICODIGO, cl.CLINOMEFANT, cc.EMPCODIGO, emp.EMPNOMEFANT,
         cc.CREDTCAD, cc.CREDTABATIMENTO, cc.CREVALOR, cc.CREORIGEM, cc.CRETIPO, cc.CREHISTORICO;
```

---

### Exemplo 2: Análise de Créditos por Cliente

**Objetivo:** Obter todos os créditos de um cliente específico.

**Query SQL:**
```sql
SELECT
    CRECODIGO,
    CREDTCAD AS DATA_CADASTRO,
    CREDTABATIMENTO AS DATA_ABATIMENTO,
    CREVALOR AS VALOR_CREDITO,
    CREORIGEM AS ORIGEM,
    CRETIPO AS TIPO,
    CREHISTORICO AS HISTORICO,
    CRECODDOCTO AS DOCUMENTO,
    CRENRBAIXA AS NUMERO_BAIXA
FROM CREDCLI
WHERE CLICODIGO = ?
ORDER BY CREDTCAD DESC;
```

---

### Exemplo 3: Análise de Créditos por Período

**Objetivo:** Obter créditos cadastrados em um período específico.

**Query SQL:**
```sql
SELECT
    cc.CRECODIGO,
    cc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cc.CREDTCAD AS DATA_CADASTRO,
    cc.CREDTABATIMENTO AS DATA_ABATIMENTO,
    cc.CREVALOR AS VALOR_CREDITO,
    cc.CREORIGEM AS ORIGEM,
    cc.CRETIPO AS TIPO
FROM CREDCLI cc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cc.CLICODIGO
WHERE cc.CREDTCAD >= ?
  AND cc.CREDTCAD <= ?
ORDER BY cc.CREDTCAD DESC, cc.CREVALOR DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Crédito

**Objetivo:** Obter informações de um crédito específico.

```sql
SELECT
    CRECODIGO,
    CLICODIGO,
    EMPCODIGO,
    CREDTCAD AS DATA_CADASTRO,
    CREDTABATIMENTO AS DATA_ABATIMENTO,
    CREVALOR AS VALOR_CREDITO,
    CREORIGEM AS ORIGEM,
    CRETIPO AS TIPO,
    CREHISTORICO AS HISTORICO
FROM CREDCLI
WHERE CRECODIGO = ?;
```

---

### 2. Listar Créditos de um Cliente

**Objetivo:** Obter todos os créditos de um cliente específico.

```sql
SELECT
    CRECODIGO,
    CREDTCAD AS DATA_CADASTRO,
    CREDTABATIMENTO AS DATA_ABATIMENTO,
    CREVALOR AS VALOR_CREDITO,
    CREORIGEM AS ORIGEM,
    CRETIPO AS TIPO,
    CREHISTORICO AS HISTORICO
FROM CREDCLI
WHERE CLICODIGO = ?
ORDER BY CREDTCAD DESC;
```

---

### 3. Calcular Saldo de Créditos de um Cliente

**Objetivo:** Calcular saldo total de créditos disponíveis de um cliente.

```sql
SELECT
    CLICODIGO,
    COUNT(*) AS TOTAL_CREDITOS,
    SUM(CREVALOR) AS VALOR_TOTAL_CREDITOS,
    SUM(CASE WHEN CREDTABATIMENTO IS NULL THEN CREVALOR ELSE 0 END) AS SALDO_DISPONIVEL,
    SUM(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN CREVALOR ELSE 0 END) AS VALOR_ABATIDO
FROM CREDCLI
WHERE CLICODIGO = ?
GROUP BY CLICODIGO;
```

---

### 4. Análise de Créditos por Origem

**Objetivo:** Identificar créditos agrupados por origem.

```sql
SELECT
    CREORIGEM AS ORIGEM,
    COUNT(*) AS TOTAL_CREDITOS,
    SUM(CREVALOR) AS VALOR_TOTAL,
    AVG(CREVALOR) AS VALOR_MEDIO,
    MIN(CREVALOR) AS VALOR_MINIMO,
    MAX(CREVALOR) AS VALOR_MAXIMO
FROM CREDCLI
GROUP BY CREORIGEM
ORDER BY VALOR_TOTAL DESC;
```

---

### 5. Análise de Créditos por Tipo

**Objetivo:** Identificar créditos agrupados por tipo.

**Query SQL:**
```sql
SELECT
    CRETIPO AS TIPO,
    COUNT(*) AS TOTAL_CREDITOS,
    SUM(CREVALOR) AS VALOR_TOTAL,
    AVG(CREVALOR) AS VALOR_MEDIO,
    COUNT(CASE WHEN CREDTABATIMENTO IS NULL THEN 1 END) AS CREDITOS_DISPONIVEIS,
    SUM(CASE WHEN CREDTABATIMENTO IS NULL THEN CREVALOR ELSE 0 END) AS SALDO_DISPONIVEL
FROM CREDCLI
GROUP BY CRETIPO
ORDER BY VALOR_TOTAL DESC;
```

---

### 6. Análise de Créditos Pendentes de Abatimento

**Objetivo:** Identificar créditos que ainda não foram abatidos.

**Query SQL:**
```sql
SELECT
    cc.CRECODIGO,
    cc.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cc.CREDTCAD AS DATA_CADASTRO,
    cc.CREVALOR AS VALOR_CREDITO,
    cc.CREORIGEM AS ORIGEM,
    cc.CRETIPO AS TIPO,
    DATEDIFF(DAY, cc.CREDTCAD, CURRENT_DATE) AS DIAS_DESDE_CADASTRO
FROM CREDCLI cc
INNER JOIN CLIEN cl ON cl.CLICODIGO = cc.CLICODIGO
WHERE cc.CREDTABATIMENTO IS NULL
ORDER BY cc.CREDTCAD, cc.CREVALOR DESC;
```

---

### 7. Relatório de Créditos

**Objetivo:** Analisar distribuição completa de créditos.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CREDITOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_COM_CREDITO,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    SUM(CREVALOR) AS VALOR_TOTAL_CREDITOS,
    AVG(CREVALOR) AS VALOR_MEDIO_CREDITO,
    COUNT(CASE WHEN CREDTABATIMENTO IS NULL THEN 1 END) AS CREDITOS_DISPONIVEIS,
    SUM(CASE WHEN CREDTABATIMENTO IS NULL THEN CREVALOR ELSE 0 END) AS SALDO_TOTAL_DISPONIVEL,
    COUNT(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN 1 END) AS CREDITOS_ABATIDOS,
    SUM(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN CREVALOR ELSE 0 END) AS VALOR_TOTAL_ABATIDO
FROM CREDCLI;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CREDCLI | Tipo |
|--------|-----------|---------------------|------|
| **CREDCLI** | 34.345 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | ~? | ?:1 | Clientes (média de ? créditos por cliente) |
| NOTACRED | ~? | ?:1 | Notas de crédito (média de ? créditos por nota) |
| PEDXCREDCLI | ~? | ?:1 | Pedidos x Créditos (média de ? créditos por pedido) |

**Interpretação:**
- **34.345 créditos** cadastrados no sistema
- **Uso extensivo** - indica gestão ativa de créditos de clientes
- **Média de créditos por cliente** - varia conforme necessidade

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IDX_CREDCL_CREDTCAD** - Índice em CREDTCAD

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por empresa** - Para buscas por empresa
4. **Índice por data de abatimento** - Para buscas de créditos pendentes
5. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CREDCLI_CLIENTE ON CREDCLI(CLICODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CREDCLI_EMPRESA ON CREDCLI(EMPCODIGO);

-- Índice 3: Busca por data de abatimento (consultas de créditos pendentes)
CREATE INDEX IDX_CREDCLI_DATA_ABATIMENTO ON CREDCLI(CREDTABATIMENTO)
    WHERE CREDTABATIMENTO IS NULL;

-- Índice 4: Busca composta por cliente e data (consultas frequentes)
CREATE INDEX IDX_CREDCLI_CLI_DATA ON CREDCLI(CLICODIGO, CREDTCAD);

-- Índice 5: Busca por origem (consultas de análise)
CREATE INDEX IDX_CREDCLI_ORIGEM ON CREDCLI(CREORIGEM)
    WHERE CREORIGEM IS NOT NULL AND CREORIGEM != '';
```

### Observações sobre Volume

- **Tabela média-grande** (34.345 registros) - Performance boa com índices adequados
- **Índice existente** - Em CREDTCAD é útil para buscas por data
- **Consultas frequentes** - Créditos são consultados durante abatimentos e relatórios
- **Índices essenciais** - Em CLICODIGO, EMPCODIGO e CREDTABATIMENTO para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar créditos sem cliente válido
SELECT cc.*
FROM CREDCLI cc
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cc.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar créditos sem empresa válida
SELECT cc.*
FROM CREDCLI cc
WHERE cc.EMPCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM EMPRESA emp WHERE emp.EMPCODIGO = cc.EMPCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CREDCLI
WHERE CRECODIGO IS NULL
   OR CLICODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR CREDTCAD IS NULL
   OR CREDTABATIMENTO IS NULL
   OR CREORIGEM IS NULL
   OR CREORIGEM = ''
   OR CRETIPO IS NULL
   OR CRETIPO = ''
   OR CREVALOR IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CRECODIGO, COUNT(*) AS QTD
FROM CREDCLI
GROUP BY CRECODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos
SELECT *
FROM CREDCLI
WHERE CREVALOR <= 0;

-- Verificar datas inconsistentes
SELECT *
FROM CREDCLI
WHERE CREDTABATIMENTO IS NOT NULL
  AND CREDTABATIMENTO < CREDTCAD;
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
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCredcli extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CREDCLI';
    
    protected $primaryKey = 'CRECODIGO';
    public $incrementing = true;

    protected $casts = [
        'CRECODIGO' => 'integer',
        'CLICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'TPOCCODIGO' => 'integer',
        'CREDTCAD' => 'date',
        'CREDTABATIMENTO' => 'date',
        'CREVALOR' => 'decimal:2',
        'CREORIGEM' => 'string',
        'CRETIPO' => 'string',
        'CRETIPOMOV' => 'string',
        'CRECODDOCTO' => 'integer',
        'CRENRBAIXA' => 'integer',
        'CRENRAUTORIZACAO' => 'string',
        'CREHISTORICO' => 'string',
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

    // Relacionamento com CREDCTB
    public function creditoContabil(): HasMany
    {
        return $this->hasMany(FirebirdCredctb::class, 'CRECODIGO', 'CRECODIGO');
    }

    // Relacionamento com NOTACRED
    public function notasCredito(): HasMany
    {
        return $this->hasMany(FirebirdNotacred::class, 'CRECODIGO', 'CRECODIGO');
    }

    // Relacionamento com PEDXCREDCLI
    public function pedidosRelacionados(): HasMany
    {
        return $this->hasMany(FirebirdPedxcredcli::class, 'CRECODIGO', 'CRECODIGO');
    }

    // Método para verificar se foi abatido
    public function foiAbatido(): bool
    {
        return !empty($this->CREDTABATIMENTO);
    }

    // Método para verificar se está disponível
    public function estaDisponivel(): bool
    {
        return empty($this->CREDTABATIMENTO);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar créditos disponíveis
    public function scopeDisponiveis($query)
    {
        return $query->whereNull('CREDTABATIMENTO');
    }

    // Scope para filtrar créditos abatidos
    public function scopeAbatidos($query)
    {
        return $query->whereNotNull('CREDTABATIMENTO');
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CREDTCAD', [$dataInicio, $dataFim]);
    }

    // Método estático para calcular saldo de créditos de um cliente
    public static function calcularSaldoCliente(int $clienteCodigo): float
    {
        return (float)self::where('CLICODIGO', $clienteCodigo)
            ->whereNull('CREDTABATIMENTO')
            ->sum('CREVALOR');
    }

    // Método estático para buscar créditos disponíveis de um cliente
    public static function buscarCreditosDisponiveis(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->whereNull('CREDTABATIMENTO')
            ->orderBy('CREDTCAD')
            ->orderBy('CREVALOR', 'desc')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - CRECODIGO identifica unicamente cada crédito
2. **Validação antes de inserir** - Verificar se cliente existe
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de valores** - Verificar valores positivos
5. **Validação de datas** - Verificar que data de abatimento é posterior à cadastro

### Performance

1. **Tabela média-grande** - 34.345 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO, EMPCODIGO, CREDTCAD e CREDTABATIMENTO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + data)
4. **Consultas frequentes** - Créditos são consultados durante abatimentos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cliente existe
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - Verificar valores positivos
5. **Validação de datas** - Verificar que datas são válidas e consistentes

### Manutenção

1. **Revisão periódica** - Verificar créditos não abatidos há muito tempo
2. **Padronização** - Manter estrutura de origens e tipos consistente
3. **Documentação** - Documentar significado de cada origem e tipo
4. **Backup regular** - Tabela importante para gestão financeira

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

