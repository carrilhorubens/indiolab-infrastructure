# CREDFOR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CREDFOR (Créditos de Fornecedores)
- **Total de Registros**: 9.320
- **Total de Colunas**: 14
- **Chave Primária**: CRECODIGO (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 1 (CREDFORCTB)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CREDFOR** é uma tabela que armazena informações sobre créditos concedidos a fornecedores. Com **9.320 registros**, representa histórico de créditos concedidos a fornecedores, permitindo gestão completa de créditos e abatimentos de fornecedores.

Esta tabela funciona como **cadastro de créditos de fornecedores** e permite:
- Registrar créditos concedidos a fornecedores
- Controlar datas de cadastro e abatimento
- Associar créditos a documentos específicos
- Rastrear origem dos créditos
- Classificar créditos por tipo
- Controlar baixas de créditos
- Suportar autorizações específicas
- Integrar com sistema contábil

Cada registro representa um crédito específico concedido a um fornecedor, contendo:
- Código único do crédito (CRECODIGO)
- Fornecedor beneficiário (FORCODIGO)
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

O sistema utiliza esta tabela para gerenciar todos os créditos concedidos a fornecedores, permitindo controle financeiro completo e rastreabilidade de abatimentos.

**Observação Importante:** CREDFOR é uma tabela importante do sistema financeiro, sendo referenciada por 1 tabela (CREDFORCTB). Com 9.320 registros, indica gestão ativa de créditos de fornecedores, essencial para controle financeiro e relatórios.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CRECODIGO** 🔑 | INTEGER | ✓ | Código único do crédito |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FORCODIGO** 🔗 | INTEGER | ✓ | Código do fornecedor (FK → FORNE) |
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
- **FORCODIGO**: Fornecedor ao qual o crédito foi concedido.
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

### CREDFOR Referencia (1 FK):

#### 1. FORNE - Fornecedores
**Relacionamento:**
```
CREDFOR.FORCODIGO → FORNE.FORCODIGO (N:1)
Constraint: CLIEN_CREDFOR (nome da constraint indica origem histórica)
```

**Descrição**: Cada crédito está vinculado a um fornecedor específico.

**Informações da Tabela FORNE:**
- **Total:** ~? fornecedores
- **PK:** FORCODIGO
- **Colunas:** Múltiplos campos

**Uso:** Identificar o fornecedor do crédito, obter informações do fornecedor.

**Nota:** A constraint `CLIEN_CREDFOR` sugere que originalmente esta tabela poderia ter sido projetada para clientes, mas foi adaptada para fornecedores. O campo correto é `FORCODIGO`.

---

### CREDFOR é Referenciada Por (1 tabela):

#### 1. CREDFORCTB - Créditos de Fornecedores Contábeis
**Relacionamento:**
```
CREDFORCTB.CRECODIGO → CREDFOR.CRECODIGO (N:1)
Constraint: CREDFOR_CREDFORCTB
```

**Descrição**: CREDFORCTB referencia CREDFOR para registrar informações contábeis dos créditos.

**Uso:** Integração contábil dos créditos de fornecedores.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via FORCODIGO → FORNE → Outras Operações do Fornecedor

**Fluxo:** CREDFOR → FORNE → Operações

**Descrição:** Através do fornecedor, é possível identificar outras operações relacionadas.

**Uso:** Análise de créditos por fornecedor.

---

### Via CREDFORCTB → Informações Contábeis

**Fluxo:** CREDFOR → CREDFORCTB → Contábil

**Descrição:** Através de CREDFORCTB, é possível identificar informações contábeis relacionadas.

**Uso:** Análise contábil de créditos de fornecedores.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Crédito de Fornecedor

**Objetivo:** Obter visão completa de um crédito incluindo informações do fornecedor e informações contábeis.

**Fluxo:**
```
CREDFOR (CRECODIGO, FORCODIGO, CREVALOR)
  ↓
FORNE (FORCODIGO)
  ↓
CREDFORCTB (CRECODIGO)
  ↓
LACTOCTB (LACCODIGO)
```

**Query SQL:**
```sql
SELECT
    cf.CRECODIGO,
    cf.FORCODIGO,
    fo.FORNOMEFANT AS FORNECEDOR,
    cf.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    cf.CREDTCAD AS DATA_CADASTRO,
    cf.CREDTABATIMENTO AS DATA_ABATIMENTO,
    cf.CREVALOR AS VALOR_CREDITO,
    cf.CREORIGEM AS ORIGEM,
    cf.CRETIPO AS TIPO,
    cf.CREHISTORICO AS HISTORICO,
    COUNT(DISTINCT cfc.LACCODIGO) AS TOTAL_LANCAMENTOS_CONTABEIS
FROM CREDFOR cf
INNER JOIN FORNE fo ON fo.FORCODIGO = cf.FORCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cf.EMPCODIGO
LEFT JOIN CREDFORCTB cfc ON cfc.CRECODIGO = cf.CRECODIGO
WHERE cf.CRECODIGO = ?
GROUP BY cf.CRECODIGO, cf.FORCODIGO, fo.FORNOMEFANT, cf.EMPCODIGO, emp.EMPNOMEFANT,
         cf.CREDTCAD, cf.CREDTABATIMENTO, cf.CREVALOR, cf.CREORIGEM, cf.CRETIPO, cf.CREHISTORICO;
```

---

### Exemplo 2: Análise de Créditos por Fornecedor

**Objetivo:** Obter todos os créditos de um fornecedor específico.

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
FROM CREDFOR
WHERE FORCODIGO = ?
ORDER BY CREDTCAD DESC;
```

---

### Exemplo 3: Análise de Créditos por Período

**Objetivo:** Obter créditos cadastrados em um período específico.

**Query SQL:**
```sql
SELECT
    cf.CRECODIGO,
    cf.FORCODIGO,
    fo.FORNOMEFANT AS FORNECEDOR,
    cf.CREDTCAD AS DATA_CADASTRO,
    cf.CREDTABATIMENTO AS DATA_ABATIMENTO,
    cf.CREVALOR AS VALOR_CREDITO,
    cf.CREORIGEM AS ORIGEM,
    cf.CRETIPO AS TIPO
FROM CREDFOR cf
INNER JOIN FORNE fo ON fo.FORCODIGO = cf.FORCODIGO
WHERE cf.CREDTCAD >= ?
  AND cf.CREDTCAD <= ?
ORDER BY cf.CREDTCAD DESC, cf.CREVALOR DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Crédito de Fornecedor

**Objetivo:** Obter informações de um crédito específico.

```sql
SELECT
    CRECODIGO,
    FORCODIGO,
    EMPCODIGO,
    CREDTCAD AS DATA_CADASTRO,
    CREDTABATIMENTO AS DATA_ABATIMENTO,
    CREVALOR AS VALOR_CREDITO,
    CREORIGEM AS ORIGEM,
    CRETIPO AS TIPO,
    CREHISTORICO AS HISTORICO
FROM CREDFOR
WHERE CRECODIGO = ?;
```

---

### 2. Listar Créditos de um Fornecedor

**Objetivo:** Obter todos os créditos de um fornecedor específico.

```sql
SELECT
    CRECODIGO,
    CREDTCAD AS DATA_CADASTRO,
    CREDTABATIMENTO AS DATA_ABATIMENTO,
    CREVALOR AS VALOR_CREDITO,
    CREORIGEM AS ORIGEM,
    CRETIPO AS TIPO,
    CREHISTORICO AS HISTORICO
FROM CREDFOR
WHERE FORCODIGO = ?
ORDER BY CREDTCAD DESC;
```

---

### 3. Calcular Saldo de Créditos de um Fornecedor

**Objetivo:** Calcular saldo total de créditos disponíveis de um fornecedor.

```sql
SELECT
    FORCODIGO,
    COUNT(*) AS TOTAL_CREDITOS,
    SUM(CREVALOR) AS VALOR_TOTAL_CREDITOS,
    SUM(CASE WHEN CREDTABATIMENTO IS NULL THEN CREVALOR ELSE 0 END) AS SALDO_DISPONIVEL,
    SUM(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN CREVALOR ELSE 0 END) AS VALOR_ABATIDO
FROM CREDFOR
WHERE FORCODIGO = ?
GROUP BY FORCODIGO;
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
FROM CREDFOR
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
FROM CREDFOR
GROUP BY CRETIPO
ORDER BY VALOR_TOTAL DESC;
```

---

### 6. Análise de Créditos Pendentes de Abatimento

**Objetivo:** Identificar créditos que ainda não foram abatidos.

**Query SQL:**
```sql
SELECT
    cf.CRECODIGO,
    cf.FORCODIGO,
    fo.FORNOMEFANT AS FORNECEDOR,
    cf.CREDTCAD AS DATA_CADASTRO,
    cf.CREVALOR AS VALOR_CREDITO,
    cf.CREORIGEM AS ORIGEM,
    cf.CRETIPO AS TIPO,
    DATEDIFF(DAY, cf.CREDTCAD, CURRENT_DATE) AS DIAS_DESDE_CADASTRO
FROM CREDFOR cf
INNER JOIN FORNE fo ON fo.FORCODIGO = cf.FORCODIGO
WHERE cf.CREDTABATIMENTO IS NULL
ORDER BY cf.CREDTCAD, cf.CREVALOR DESC;
```

---

### 7. Relatório de Créditos de Fornecedores

**Objetivo:** Analisar distribuição completa de créditos de fornecedores.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CREDITOS,
    COUNT(DISTINCT FORCODIGO) AS TOTAL_FORNECEDORES_COM_CREDITO,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    SUM(CREVALOR) AS VALOR_TOTAL_CREDITOS,
    AVG(CREVALOR) AS VALOR_MEDIO_CREDITO,
    COUNT(CASE WHEN CREDTABATIMENTO IS NULL THEN 1 END) AS CREDITOS_DISPONIVEIS,
    SUM(CASE WHEN CREDTABATIMENTO IS NULL THEN CREVALOR ELSE 0 END) AS SALDO_TOTAL_DISPONIVEL,
    COUNT(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN 1 END) AS CREDITOS_ABATIDOS,
    SUM(CASE WHEN CREDTABATIMENTO IS NOT NULL THEN CREVALOR ELSE 0 END) AS VALOR_TOTAL_ABATIDO
FROM CREDFOR;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CREDFOR | Tipo |
|--------|-----------|---------------------|------|
| **CREDFOR** | 9.320 | 1:1 | **TABELA PRINCIPAL** |
| FORNE | ~? | ?:1 | Fornecedores (média de ? créditos por fornecedor) |
| CREDFORCTB | ~? | ?:1 | Créditos contábeis (média de ? lançamentos por crédito) |

**Interpretação:**
- **9.320 créditos** cadastrados no sistema
- **Uso moderado** - indica gestão ativa de créditos de fornecedores
- **Média de créditos por fornecedor** - varia conforme necessidade

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por fornecedor** - Para buscas por fornecedor
3. **Índice por empresa** - Para buscas por empresa
4. **Índice por data de cadastro** - Para buscas por período
5. **Índice por data de abatimento** - Para buscas de créditos pendentes
6. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por fornecedor (consultas frequentes)
CREATE INDEX IDX_CREDFOR_FORNECEDOR ON CREDFOR(FORCODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CREDFOR_EMPRESA ON CREDFOR(EMPCODIGO);

-- Índice 3: Busca por data de cadastro (consultas frequentes)
CREATE INDEX IDX_CREDFOR_DATA_CADASTRO ON CREDFOR(CREDTCAD);

-- Índice 4: Busca por data de abatimento (consultas de créditos pendentes)
CREATE INDEX IDX_CREDFOR_DATA_ABATIMENTO ON CREDFOR(CREDTABATIMENTO)
    WHERE CREDTABATIMENTO IS NULL;

-- Índice 5: Busca composta por fornecedor e data (consultas frequentes)
CREATE INDEX IDX_CREDFOR_FOR_DATA ON CREDFOR(FORCODIGO, CREDTCAD);

-- Índice 6: Busca por origem (consultas de análise)
CREATE INDEX IDX_CREDFOR_ORIGEM ON CREDFOR(CREORIGEM)
    WHERE CREORIGEM IS NOT NULL AND CREORIGEM != '';
```

### Observações sobre Volume

- **Tabela média** (9.320 registros) - Performance boa com índices adequados
- **Sem índices específicos** - Recomendado criar índices para buscas frequentes
- **Consultas frequentes** - Créditos são consultados durante abatimentos e relatórios
- **Índices essenciais** - Em FORCODIGO, EMPCODIGO, CREDTCAD e CREDTABATIMENTO para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar créditos sem fornecedor válido
SELECT cf.*
FROM CREDFOR cf
LEFT JOIN FORNE fo ON fo.FORCODIGO = cf.FORCODIGO
WHERE fo.FORCODIGO IS NULL;

-- Verificar créditos sem empresa válida
SELECT cf.*
FROM CREDFOR cf
WHERE cf.EMPCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM EMPRESA emp WHERE emp.EMPCODIGO = cf.EMPCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CREDFOR
WHERE CRECODIGO IS NULL
   OR FORCODIGO IS NULL
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
FROM CREDFOR
GROUP BY CRECODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos
SELECT *
FROM CREDFOR
WHERE CREVALOR <= 0;

-- Verificar datas inconsistentes
SELECT *
FROM CREDFOR
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

final class FirebirdCredfor extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CREDFOR';
    
    protected $primaryKey = 'CRECODIGO';
    public $incrementing = true;

    protected $casts = [
        'CRECODIGO' => 'integer',
        'FORCODIGO' => 'integer',
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

    // Relacionamento com FORNE
    public function fornecedor(): BelongsTo
    {
        return $this->belongsTo(FirebirdForne::class, 'FORCODIGO', 'FORCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com CREDFORCTB
    public function creditoContabil(): HasMany
    {
        return $this->hasMany(FirebirdCredforctb::class, 'CRECODIGO', 'CRECODIGO');
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

    // Scope para filtrar por fornecedor
    public function scopePorFornecedor($query, int $fornecedorCodigo)
    {
        return $query->where('FORCODIGO', $fornecedorCodigo);
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

    // Método estático para calcular saldo de créditos de um fornecedor
    public static function calcularSaldoFornecedor(int $fornecedorCodigo): float
    {
        return (float)self::where('FORCODIGO', $fornecedorCodigo)
            ->whereNull('CREDTABATIMENTO')
            ->sum('CREVALOR');
    }

    // Método estático para buscar créditos disponíveis de um fornecedor
    public static function buscarCreditosDisponiveis(int $fornecedorCodigo): \Illuminate\Support\Collection
    {
        return self::where('FORCODIGO', $fornecedorCodigo)
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
2. **Validação antes de inserir** - Verificar se fornecedor existe
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de valores** - Verificar valores positivos
5. **Validação de datas** - Verificar que data de abatimento é posterior à cadastro

### Performance

1. **Tabela média** - 9.320 registros, performance boa com índices adequados
2. **Índices essenciais** - Em FORCODIGO, EMPCODIGO, CREDTCAD e CREDTABATIMENTO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (fornecedor + data)
4. **Consultas frequentes** - Créditos são consultados durante abatimentos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se fornecedor existe
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

