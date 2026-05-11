# LOTECH - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOTECH (Lote de Cheques)
- **Total de Registros**: 7.330
- **Total de Colunas**: 5
- **Chave Primária**: ID_LOTECH (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 5 (CHEQUE, LOTECHCAN, LOTECHCCORR, LOTECHCREDCLI, RECBXP)
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOTECH** é uma tabela que armazena informações sobre lotes de cheques. Com **7.330 registros**, representa um histórico de lotes de cheques criados no sistema, incluindo informações sobre data, valor, situação e tipo.

Esta tabela funciona como **mestre de lotes de cheques** e permite:
- Registrar todos os lotes de cheques criados
- Armazenar informações sobre data, valor, situação e tipo
- Vincular cheques a lotes específicos
- Rastrear cancelamentos de lotes
- Associar lançamentos de conta corrente a lotes
- Vincular créditos de clientes a lotes
- Facilitar gestão de lotes de cheques
- Manter histórico detalhado de lotes

Cada registro representa um lote específico de cheques, contendo:
- ID do lote (ID_LOTECH)
- Data do lote (LTDATA)
- Valor do lote (LTVALOR)
- Situação do lote (LTSITUACAO)
- Tipo do lote (LTTIPO)

O sistema utiliza esta tabela para manter histórico completo de lotes de cheques, sendo referenciada por CHEQUE para vincular cheques a lotes, por LOTECHCAN para registrar cancelamentos, por LOTECHCCORR para associar lançamentos de conta corrente, por LOTECHCREDCLI para vincular créditos de clientes e por RECBXP para associar recebimentos a lotes.

**Observação Importante:** LOTECH é uma tabela mestre de lotes de cheques. Com 7.330 registros, indica uso moderado desta funcionalidade. Possui 5 tabelas dependentes que referenciam ID_LOTECH, indicando sua importância central no sistema de gestão de cheques.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_LOTECH** 🔑 | INTEGER | ✓ | ID do lote de cheques (PK) |

### Informações do Lote
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LTDATA** | TIMESTAMP | ✓ | Data do lote |
| **LTVALOR** | DECIMAL(16,2) | ✓ | Valor total do lote |
| **LTSITUACAO** | VARCHAR(14) | ✓ | Situação do lote |
| **LTTIPO** | VARCHAR(14) | ✓ | Tipo do lote |

**Primary Key:** ID_LOTECH

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOTECH Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOTECH é Referenciada Por (5 tabelas):

#### 1. CHEQUE - Cheques
**Relacionamento:**
```
CHEQUE.ID_LOTECH → LOTECH.ID_LOTECH (N:1)
Constraint: LOTECH_CHEQUE
```

**Descrição**: Cada cheque pode estar vinculado a um lote específico.

**Informações da Tabela CHEQUE:**
- **Total:** 14.537 cheques
- **PK:** CHCODIGO, EMPCODIGO (composta)
- **Colunas:** 26 campos

**Uso:** Vincular cheques a lotes para gestão e controle.

---

#### 2. LOTECHCAN - Cancelamentos de Lotes
**Relacionamento:**
```
LOTECHCAN.ID_LOTECH → LOTECH.ID_LOTECH (1:1)
Constraint: LOTECH_LOTECHCAN
```

**Descrição**: Cada cancelamento de lote está vinculado a um lote específico.

**Informações da Tabela LOTECHCAN:**
- **Total:** 0 cancelamentos
- **PK:** ID_LOTECH
- **Colunas:** 2 campos

**Uso:** Registrar cancelamentos de lotes com motivo.

---

#### 3. LOTECHCCORR - Lotes x Conta Corrente
**Relacionamento:**
```
LOTECHCCORR.ID_LOTECH → LOTECH.ID_LOTECH (N:1)
Constraint: LOTECH_LOTECHCCORR
```

**Descrição**: Cada associação de lote com lançamento de conta corrente está vinculada a um lote específico.

**Informações da Tabela LOTECHCCORR:**
- **Total:** 0 associações
- **PK:** ID_LOTECH, BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR (composta)
- **Colunas:** 5 campos

**Uso:** Associar lotes a lançamentos de conta corrente.

---

#### 4. LOTECHCREDCLI - Lotes x Créditos de Clientes
**Relacionamento:**
```
LOTECHCREDCLI.ID_LOTECH → LOTECH.ID_LOTECH (N:1)
Constraint: LOTECH_LOTECHCREDCLI
```

**Descrição**: Cada associação de lote com crédito de cliente está vinculada a um lote específico.

**Informações da Tabela LOTECHCREDCLI:**
- **Total:** 0 associações
- **PK:** ID_LOTECH, CRECODIGO (composta)
- **Colunas:** 2 campos

**Uso:** Vincular lotes a créditos de clientes.

---

#### 5. RECBXP - Recebimentos
**Relacionamento:**
```
RECBXP.ID_LOTECH → LOTECH.ID_LOTECH (N:1)
Constraint: LOTECH_RECBXP
```

**Descrição**: Cada recebimento pode estar vinculado a um lote específico.

**Informações da Tabela RECBXP:**
- **Total:** 0 recebimentos
- **PK:** EMPCODIGO, RECCODIGO, REBCONTADOR (composta)
- **Colunas:** 21 campos

**Uso:** Associar recebimentos a lotes de cheques.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CHEQUE → Outras Operações

**Fluxo:** LOTECH → CHEQUE → Operações

**Descrição:** Através dos cheques vinculados, é possível identificar outras operações relacionadas.

**Uso:** Análise de lotes através de operações de cheques.

---

### Via LOTECHCCORR → CCORR

**Fluxo:** LOTECH → LOTECHCCORR → CCORR → Operações

**Descrição:** Através das associações com conta corrente, é possível identificar lançamentos relacionados.

**Uso:** Análise de lotes através de lançamentos de conta corrente.

---

### Via LOTECHCREDCLI → CREDCLI

**Fluxo:** LOTECH → LOTECHCREDCLI → CREDCLI → Operações

**Descrição:** Através das associações com créditos de clientes, é possível identificar créditos relacionados.

**Uso:** Análise de lotes através de créditos de clientes.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Lote de Cheques

**Objetivo:** Obter informações de um lote específico.

```sql
SELECT
    ID_LOTECH,
    LTDATA,
    LTVALOR,
    LTSITUACAO,
    LTTIPO
FROM LOTECH
WHERE ID_LOTECH = ?;
```

---

### 2. Listar Cheques de um Lote

**Objetivo:** Obter todos os cheques vinculados a um lote específico.

```sql
SELECT
    c.CHCODIGO,
    c.CHNRCHEQUE,
    c.CHDTEMIS,
    c.CHDTVENCTO,
    c.CHVRCHEQUE,
    c.CHEMITENTE
FROM LOTECH l
INNER JOIN CHEQUE c ON c.ID_LOTECH = l.ID_LOTECH
WHERE l.ID_LOTECH = ?
ORDER BY c.CHNRCHEQUE;
```

---

### 3. Análise de Lotes por Situação

**Objetivo:** Identificar distribuição de lotes por situação.

**Query SQL:**
```sql
SELECT
    LTSITUACAO,
    COUNT(*) AS TOTAL_LOTES,
    SUM(LTVALOR) AS VALOR_TOTAL,
    AVG(LTVALOR) AS VALOR_MEDIO
FROM LOTECH
WHERE LTSITUACAO IS NOT NULL
GROUP BY LTSITUACAO
ORDER BY TOTAL_LOTES DESC;
```

---

### 4. Análise de Lotes por Período

**Objetivo:** Identificar distribuição de lotes ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM LTDATA) AS ANO,
    EXTRACT(MONTH FROM LTDATA) AS MES,
    COUNT(*) AS TOTAL_LOTES,
    SUM(LTVALOR) AS VALOR_TOTAL
FROM LOTECH
WHERE LTDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM LTDATA), EXTRACT(MONTH FROM LTDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOTECH | Tipo |
|--------|-----------|---------------------|------|
| **LOTECH** | 7.330 | 1:1 | **TABELA PRINCIPAL** |
| CHEQUE | 14.537 | 1:2 | Cheques (média de 2 cheques por lote) |
| LOTECHCAN | 0 | 0:1 | Cancelamentos (nenhum cancelamento registrado) |
| LOTECHCCORR | 0 | 0:1 | Associações com conta corrente (nenhuma associação registrada) |
| LOTECHCREDCLI | 0 | 0:1 | Associações com créditos (nenhuma associação registrada) |
| RECBXP | 0 | 0:1 | Recebimentos (nenhum recebimento registrado) |

**Interpretação:**
- **7.330 lotes** de cheques registrados no sistema
- **Média de 2 cheques por lote** - indica que cada lote contém poucos cheques
- **Nenhum cancelamento, associação ou recebimento registrado** - indica que essas funcionalidades podem não estar sendo utilizadas ou foram implementadas recentemente

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOTECH_LTDATA ON LOTECH(LTDATA)
    WHERE LTDATA IS NOT NULL;

-- Índice 2: Busca por situação (consultas frequentes)
CREATE INDEX IDX_LOTECH_LTSITUACAO ON LOTECH(LTSITUACAO)
    WHERE LTSITUACAO IS NOT NULL;

-- Índice 3: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_LOTECH_LTTIPO ON LOTECH(LTTIPO)
    WHERE LTTIPO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdLotech extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOTECH';
    
    protected $primaryKey = 'ID_LOTECH';
    public $incrementing = true;

    protected $casts = [
        'ID_LOTECH' => 'integer',
        'LTDATA' => 'datetime',
        'LTVALOR' => 'decimal:2',
        'LTSITUACAO' => 'string',
        'LTTIPO' => 'string',
    ];

    // Relacionamento com CHEQUE
    public function cheques(): HasMany
    {
        return $this->hasMany(FirebirdCheque::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    // Relacionamento com LOTECHCAN
    public function cancelamento(): HasOne
    {
        return $this->hasOne(FirebirdLotechcan::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    // Relacionamento com LOTECHCCORR
    public function lancamentosContaCorrente(): HasMany
    {
        return $this->hasMany(FirebirdLotechccorr::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    // Relacionamento com LOTECHCREDCLI
    public function creditosClientes(): HasMany
    {
        return $this->hasMany(FirebirdLotechcredcli::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    // Relacionamento com RECBXP
    public function recebimentos(): HasMany
    {
        return $this->hasMany(FirebirdRecbxp::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    public function scopePorSituacao($query, string $situacao)
    {
        return $query->where('LTSITUACAO', $situacao);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('LTTIPO', $tipo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('LTDATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('LTDATA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

