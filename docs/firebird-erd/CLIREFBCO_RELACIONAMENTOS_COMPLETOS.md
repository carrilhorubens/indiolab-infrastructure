# CLIREFBCO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIREFBCO (Referências Bancárias de Cliente)
- **Total de Registros**: 20
- **Total de Colunas**: 8
- **Chave Primária**: (CLICODIGO, CRBCODIGO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIREFBCO** é uma tabela de referências bancárias que armazena informações de contas bancárias de referência para clientes. Com **20 registros**, representa contas bancárias de referência cadastradas para alguns clientes.

Esta tabela funciona como **cadastro de referências bancárias por cliente** e permite:
- Armazenar múltiplas contas bancárias de referência por cliente
- Manter informações completas de contas bancárias (agência, conta, banco)
- Armazenar informações de contato bancário (DDD, telefone)
- Rastrear data de abertura das contas
- Facilitar verificação de referências bancárias
- Suportar múltiplas contas por cliente

Cada registro representa uma conta bancária de referência de um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Código sequencial da referência (CRBCODIGO)
- Informações bancárias (agência, conta, banco)
- Informações de contato (DDD, telefone)
- Data de abertura da conta (CRBDTABERTURA)

O sistema utiliza esta tabela para armazenar referências bancárias de clientes, permitindo verificação de crédito e análise de relacionamento bancário.

**Observação Importante:** CLIREFBCO complementa CLIEN fornecendo informações bancárias de referência. Com apenas 20 registros, indica uso muito específico para clientes que requerem verificação de referências bancárias.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **CRBCODIGO** 🔑 | SMALLINT | ✓ | Código sequencial da referência bancária (PK) |

### Informações Bancárias
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CRBAGENCIA** | VARCHAR(37) | ✓ | Número da agência bancária |
| **BCOCODIGO** 🔗 | SMALLINT | ✓ | Código do banco (FK → BANCO) |
| **CRBCONTA** | VARCHAR(37) | ✓ | Número da conta bancária |

### Informações de Contato
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CRBDDD** | VARCHAR(14) | | DDD do telefone do banco |
| **CRBFONE** | VARCHAR(37) | | Número de telefone do banco |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CRBDTABERTURA** | DATE | | Data de abertura da conta |

**Primary Key:** (CLICODIGO, CRBCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente ao qual a referência bancária pertence.
- **CRBCODIGO**: Código sequencial que identifica cada referência bancária do cliente (1, 2, 3, etc.).
- **CRBAGENCIA**: Número da agência bancária da referência.
- **BCOCODIGO**: Banco da referência bancária.
- **CRBCONTA**: Número da conta bancária da referência.
- **CRBDDD**: DDD do telefone do banco para contato.
- **CRBFONE**: Número de telefone do banco para contato.
- **CRBDTABERTURA**: Data em que a conta foi aberta.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIREFBCO Referencia (2 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIREFBCO.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIREFBCO
```

**Descrição**: Cada referência bancária está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente da referência bancária, relatórios de referências por cliente.

---

#### 2. BANCO - Bancos
**Relacionamento:**
```
CLIREFBCO.BCOCODIGO → BANCO.BCOCODIGO (N:1)
Constraint: BANCO_CLIREFBANCO
```

**Descrição**: Cada referência bancária está vinculada a um banco específico.

**Informações da Tabela BANCO:**
- **Total:** Múltiplos bancos
- **PK:** BCOCODIGO
- **Colunas:** Múltiplos campos

**Campos importantes em BANCO relacionados a CLIREFBCO:**
- `BCOCODIGO` - Código do banco
- `BCONOME` - Nome do banco
- `BCOCODIGOBCB` - Código do banco no Banco Central

**Uso:** Identificar o banco da referência, obter informações do banco.

---

### CLIREFBCO é Referenciada Por

**Nenhuma tabela** referencia CLIREFBCO diretamente. Esta é uma tabela folha utilizada para armazenamento e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIREFBCO → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados às referências bancárias.

**Uso:** Análises de pedidos considerando referências bancárias, verificação de crédito.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIREFBCO → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas às referências bancárias.

**Uso:** Análises de notas fiscais considerando referências bancárias.

---

### Via BANCO → CONTA (Contas Bancárias)

**Fluxo:** CLIREFBCO → BANCO → CONTA

**Descrição:** Através do banco, é possível identificar contas bancárias relacionadas.

**Uso:** Análises de contas bancárias por banco.

---

### Via CLIEN → CCORR (Conta Corrente)

**Fluxo:** CLIREFBCO → CLIEN → CCORR

**Descrição:** Através do cliente, é possível identificar contas correntes que podem estar relacionadas às referências bancárias.

**Uso:** Análises de contas correntes considerando referências bancárias.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Referência Bancária

**Objetivo:** Obter visão completa de uma referência bancária incluindo informações do cliente e banco.

**Fluxo:**
```
CLIREFBCO (CLICODIGO, CRBCODIGO, BCOCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    crb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    crb.CRBCODIGO,
    crb.CRBAGENCIA AS AGENCIA,
    crb.BCOCODIGO,
    bc.BCONOME AS BANCO,
    bc.BCOCODIGOBCB AS CODIGO_BCB,
    crb.CRBCONTA AS CONTA,
    crb.CRBDDD AS DDD,
    crb.CRBFONE AS TELEFONE,
    crb.CRBDTABERTURA AS DATA_ABERTURA
FROM CLIREFBCO crb
INNER JOIN CLIEN cl ON cl.CLICODIGO = crb.CLICODIGO
INNER JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
WHERE crb.CLICODIGO = ?
  AND crb.CRBCODIGO = ?;
```

---

### Exemplo 2: Análise de Referências Bancárias por Cliente

**Objetivo:** Identificar todas as referências bancárias de um cliente específico.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLIREFBCO (CLICODIGO)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    crb.CRBCODIGO,
    crb.CRBAGENCIA AS AGENCIA,
    crb.BCOCODIGO,
    bc.BCONOME AS BANCO,
    crb.CRBCONTA AS CONTA,
    crb.CRBDDD AS DDD,
    crb.CRBFONE AS TELEFONE,
    crb.CRBDTABERTURA AS DATA_ABERTURA
FROM CLIREFBCO crb
INNER JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
WHERE crb.CLICODIGO = ?
ORDER BY crb.CRBCODIGO;
```

---

### Exemplo 3: Análise de Referências Bancárias por Banco

**Objetivo:** Identificar distribuição de referências bancárias por banco.

**Fluxo:**
```
BANCO (BCOCODIGO)
  ↓
CLIREFBCO (BCOCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    bc.BCOCODIGO,
    bc.BCONOME AS BANCO,
    bc.BCOCODIGOBCB AS CODIGO_BCB,
    COUNT(DISTINCT crb.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_REFERENCIAS
FROM BANCO bc
LEFT JOIN CLIREFBCO crb ON crb.BCOCODIGO = bc.BCOCODIGO
GROUP BY bc.BCOCODIGO, bc.BCONOME, bc.BCOCODIGOBCB
ORDER BY TOTAL_REFERENCIAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Referências Bancárias de um Cliente

**Objetivo:** Obter todas as referências bancárias de um cliente específico.

```sql
SELECT
    CRBCODIGO,
    CRBAGENCIA AS AGENCIA,
    BCOCODIGO,
    CRBCONTA AS CONTA,
    CRBDDD AS DDD,
    CRBFONE AS TELEFONE,
    CRBDTABERTURA AS DATA_ABERTURA
FROM CLIREFBCO
WHERE CLICODIGO = ?
ORDER BY CRBCODIGO;
```

---

### 2. Buscar Referência Bancária Específica

**Objetivo:** Obter uma referência bancária específica de um cliente.

```sql
SELECT
    crb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    crb.CRBCODIGO,
    crb.CRBAGENCIA AS AGENCIA,
    crb.BCOCODIGO,
    bc.BCONOME AS BANCO,
    crb.CRBCONTA AS CONTA,
    crb.CRBDDD AS DDD,
    crb.CRBFONE AS TELEFONE,
    crb.CRBDTABERTURA AS DATA_ABERTURA
FROM CLIREFBCO crb
INNER JOIN CLIEN cl ON cl.CLICODIGO = crb.CLICODIGO
INNER JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
WHERE crb.CLICODIGO = ?
  AND crb.CRBCODIGO = ?;
```

---

### 3. Análise de Clientes Sem Referências Bancárias

**Objetivo:** Identificar clientes que não têm referências bancárias cadastradas.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL
FROM CLIEN cl
LEFT JOIN CLIREFBCO crb ON crb.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
  AND crb.CLICODIGO IS NULL
ORDER BY cl.CLINOMEFANT;
```

---

### 4. Relatório de Referências Bancárias por Banco

**Objetivo:** Analisar distribuição de referências bancárias por banco.

```sql
SELECT
    bc.BCOCODIGO,
    bc.BCONOME AS BANCO,
    COUNT(DISTINCT crb.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_REFERENCIAS,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CLIREFBCO), 2) AS PERCENTUAL
FROM BANCO bc
LEFT JOIN CLIREFBCO crb ON crb.BCOCODIGO = bc.BCOCODIGO
GROUP BY bc.BCOCODIGO, bc.BCONOME
HAVING COUNT(*) > 0
ORDER BY TOTAL_REFERENCIAS DESC;
```

---

### 5. Análise de Referências com Informações de Contato

**Objetivo:** Identificar referências bancárias com informações de contato completas.

```sql
SELECT
    crb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    crb.CRBCODIGO,
    bc.BCONOME AS BANCO,
    crb.CRBAGENCIA AS AGENCIA,
    crb.CRBCONTA AS CONTA,
    crb.CRBDDD AS DDD,
    crb.CRBFONE AS TELEFONE,
    CASE 
        WHEN crb.CRBDDD IS NOT NULL AND crb.CRBFONE IS NOT NULL THEN 'COMPLETO'
        ELSE 'INCOMPLETO'
    END AS STATUS_CONTATO
FROM CLIREFBCO crb
INNER JOIN CLIEN cl ON cl.CLICODIGO = crb.CLICODIGO
INNER JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
ORDER BY STATUS_CONTATO, cl.CLINOMEFANT;
```

---

### 6. Análise de Referências por Data de Abertura

**Objetivo:** Identificar referências bancárias abertas em um período específico.

```sql
SELECT
    crb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    crb.CRBCODIGO,
    bc.BCONOME AS BANCO,
    crb.CRBCONTA AS CONTA,
    crb.CRBDTABERTURA AS DATA_ABERTURA
FROM CLIREFBCO crb
INNER JOIN CLIEN cl ON cl.CLICODIGO = crb.CLICODIGO
INNER JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
WHERE crb.CRBDTABERTURA >= ?
  AND crb.CRBDTABERTURA <= ?
ORDER BY crb.CRBDTABERTURA DESC;
```

---

### 7. Comparação com Outras Referências Bancárias

**Objetivo:** Comparar referências bancárias com outras informações bancárias do cliente.

**Query SQL:**
```sql
SELECT
    'CLIREFBCO' AS TIPO_REFERENCIA,
    COUNT(*) AS TOTAL_REFERENCIAS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES
FROM CLIREFBCO
UNION ALL
SELECT
    'CCORR' AS TIPO_REFERENCIA,
    COUNT(*) AS TOTAL_REFERENCIAS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES
FROM CCORR
WHERE BCOCODIGO IS NOT NULL
ORDER BY TOTAL_REFERENCIAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIREFBCO | Tipo |
|--------|-----------|---------------------|------|
| **CLIREFBCO** | 20 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 462.55:1 | Clientes (média de 0.002 referências por cliente) |
| BANCO | ? | ?:1 | Bancos |

**Interpretação:**
- **Apenas 20 referências bancárias** cadastradas no sistema
- **0.2% dos clientes** têm referências bancárias cadastradas (20 de 9.251)
- **Uso muito específico** - indica uso para verificação de crédito ou análise de relacionamento bancário

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIREFBCO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por banco** - Para buscas por banco

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIREFBCO_CLIENTE ON CLIREFBCO(CLICODIGO);

-- Índice 2: Busca por banco (consultas frequentes)
CREATE INDEX IDX_CLIREFBCO_BANCO ON CLIREFBCO(BCOCODIGO);

-- Índice 3: Busca composta por cliente e código (consultas de validação)
CREATE INDEX IDX_CLIREFBCO_CLI_COD ON CLIREFBCO(CLICODIGO, CRBCODIGO);
```

### Observações sobre Volume

- **Tabela muito pequena** (20 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por cliente e banco

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar referências sem cliente válido
SELECT crb.*
FROM CLIREFBCO crb
LEFT JOIN CLIEN cl ON cl.CLICODIGO = crb.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar referências sem banco válido
SELECT crb.*
FROM CLIREFBCO crb
LEFT JOIN BANCO bc ON bc.BCOCODIGO = crb.BCOCODIGO
WHERE bc.BCOCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIREFBCO
WHERE CLICODIGO IS NULL
   OR CRBCODIGO IS NULL
   OR CRBAGENCIA IS NULL
   OR CRBAGENCIA = ''
   OR BCOCODIGO IS NULL
   OR CRBCONTA IS NULL
   OR CRBCONTA = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, CRBCODIGO, COUNT(*) AS QTD
FROM CLIREFBCO
GROUP BY CLICODIGO, CRBCODIGO
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

final class FirebirdClirefbco extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIREFBCO';
    
    protected $primaryKey = ['CLICODIGO', 'CRBCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'CRBCODIGO' => 'integer',
        'CRBAGENCIA' => 'string',
        'BCOCODIGO' => 'integer',
        'CRBCONTA' => 'string',
        'CRBDDD' => 'string',
        'CRBFONE' => 'string',
        'CRBDTABERTURA' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com BANCO
    public function banco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBanco::class, 'BCOCODIGO', 'BCOCODIGO');
    }

    // Método para verificar se tem informações de contato
    public function temContato(): bool
    {
        return !empty($this->CRBDDD) && !empty($this->CRBFONE);
    }

    // Método para obter telefone completo formatado
    public function getTelefoneCompleto(): ?string
    {
        if ($this->temContato()) {
            return "({$this->CRBDDD}) {$this->CRBFONE}";
        }
        return null;
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por banco
    public function scopePorBanco($query, int $bancoCodigo)
    {
        return $query->where('BCOCODIGO', $bancoCodigo);
    }

    // Método estático para buscar referências de um cliente
    public static function buscarReferenciasCliente(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->with('banco')
            ->orderBy('CRBCODIGO')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e banco existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de dados bancários** - Verificar formato de agência e conta

### Performance

1. **Tabela muito pequena** - 20 registros, performance excelente
2. **Índices úteis** - Em CLICODIGO e BCOCODIGO para buscas frequentes
3. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de dados bancários** - Verificar formato de agência e conta

### Manutenção

1. **Revisão periódica** - Verificar referências desatualizadas
2. **Padronização** - Manter formato de agência e conta consistente
3. **Documentação** - Documentar quando usar referências bancárias
4. **Backup regular** - Tabela importante para verificação de crédito

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

