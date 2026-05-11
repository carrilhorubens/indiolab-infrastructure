# HISTCLI - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: HISTCLI (Histórico de Cliente)
- **Total de Registros**: 9
- **Total de Colunas**: 6
- **Chave Primária**: Composta (HISTCLICODIGO, CLICODIGO)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**HISTCLI** é uma tabela que armazena histórico de interações e eventos relacionados a clientes. Com apenas **9 registros**, representa registros históricos de atividades, observações e eventos específicos de clientes, permitindo rastreamento e auditoria de interações.

Esta tabela funciona como **histórico de cliente** e permite:
- Registrar histórico de interações com clientes
- Armazenar observações e eventos relacionados a clientes
- Rastrear atividades por data e hora
- Classificar eventos por tipo
- Facilitar auditoria de interações com clientes
- Manter registro temporal de eventos

Cada registro representa um evento histórico específico de um cliente, contendo:
- Código do histórico (HISTCLICODIGO) - parte da PK
- Código do cliente (CLICODIGO) - parte da PK + FK → CLIEN
- Data do evento (HISTCLIDATA)
- Hora do evento (HISTCLIHORA)
- Observação do evento (HISTCLIOBS)
- Tipo do evento (HISTCLITIPO)

O sistema utiliza esta tabela para manter histórico completo de interações e eventos relacionados a clientes, permitindo rastreamento e auditoria.

**Observação Importante:** HISTCLI é uma tabela de histórico de cliente. Com apenas 9 registros, indica uso muito limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário. Possui chave primária composta e relacionamento com CLIEN.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISTCLICODIGO** 🔑 | INTEGER | ✓ | Código do histórico de cliente (PK) |
| **CLICODIGO** 🔑 🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |

### Informações do Evento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISTCLIDATA** | DATE | ✓ | Data do evento histórico |
| **HISTCLIHORA** | TIME | ✓ | Hora do evento histórico |
| **HISTCLIOBS** | VARCHAR(261) | | Observação do evento histórico |
| **HISTCLITIPO** | VARCHAR(14) | | Tipo do evento histórico |

**Primary Key:** (HISTCLICODIGO, CLICODIGO)

**Foreign Keys:**
- `CLICODIGO` → `CLIEN.CLICODIGO` (Constraint: CLIEN_HISTCLI)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### HISTCLI Referencia (1 FK):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
HISTCLI.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_HISTCLI
```

**Descrição**: Cada histórico está vinculado a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 119 campos

**Uso:** Identificar o cliente ao qual o histórico pertence.

---

### HISTCLI é Referenciada Por (0 tabelas):

Nenhuma tabela referencia HISTCLI diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → Outras Operações de Clientes

**Fluxo:** HISTCLI → CLIEN → Operações

**Descrição:** Através do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de histórico através de operações de clientes.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Histórico de Cliente

**Objetivo:** Obter visão completa de um histórico incluindo informações do cliente.

**Fluxo:**
```
HISTCLI (HISTCLICODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    hc.HISTCLICODIGO,
    hc.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    c.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    hc.HISTCLIDATA AS DATA_EVENTO,
    hc.HISTCLIHORA AS HORA_EVENTO,
    hc.HISTCLITIPO AS TIPO_EVENTO,
    hc.HISTCLIOBS AS OBSERVACAO
FROM HISTCLI hc
INNER JOIN CLIEN c ON c.CLICODIGO = hc.CLICODIGO
WHERE hc.HISTCLICODIGO = ?
  AND hc.CLICODIGO = ?;
```

---

### Exemplo 2: Análise de Histórico por Cliente

**Objetivo:** Identificar todos os históricos de um cliente específico.

**Query SQL:**
```sql
SELECT
    HISTCLICODIGO,
    HISTCLIDATA AS DATA_EVENTO,
    HISTCLIHORA AS HORA_EVENTO,
    HISTCLITIPO AS TIPO_EVENTO,
    HISTCLIOBS AS OBSERVACAO
FROM HISTCLI
WHERE CLICODIGO = ?
ORDER BY HISTCLIDATA DESC, HISTCLIHORA DESC;
```

---

### Exemplo 3: Análise de Histórico por Tipo

**Objetivo:** Identificar distribuição de históricos por tipo de evento.

**Query SQL:**
```sql
SELECT
    HISTCLITIPO AS TIPO_EVENTO,
    COUNT(*) AS TOTAL_EVENTOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES
FROM HISTCLI
WHERE HISTCLITIPO IS NOT NULL
GROUP BY HISTCLITIPO
ORDER BY TOTAL_EVENTOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Histórico de Cliente

**Objetivo:** Obter informações de um histórico específico.

```sql
SELECT
    HISTCLICODIGO,
    CLICODIGO,
    HISTCLIDATA AS DATA_EVENTO,
    HISTCLIHORA AS HORA_EVENTO,
    HISTCLITIPO AS TIPO_EVENTO,
    HISTCLIOBS AS OBSERVACAO
FROM HISTCLI
WHERE HISTCLICODIGO = ?
  AND CLICODIGO = ?;
```

---

### 2. Listar Históricos de um Cliente

**Objetivo:** Obter todos os históricos de um cliente específico.

```sql
SELECT
    HISTCLICODIGO,
    HISTCLIDATA AS DATA_EVENTO,
    HISTCLIHORA AS HORA_EVENTO,
    HISTCLITIPO AS TIPO_EVENTO,
    HISTCLIOBS AS OBSERVACAO
FROM HISTCLI
WHERE CLICODIGO = ?
ORDER BY HISTCLIDATA DESC, HISTCLIHORA DESC;
```

---

### 3. Análise de Histórico por Período

**Objetivo:** Identificar históricos em um período específico.

**Query SQL:**
```sql
SELECT
    hc.HISTCLICODIGO,
    hc.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    hc.HISTCLIDATA AS DATA_EVENTO,
    hc.HISTCLITIPO AS TIPO_EVENTO,
    hc.HISTCLIOBS AS OBSERVACAO
FROM HISTCLI hc
INNER JOIN CLIEN c ON c.CLICODIGO = hc.CLICODIGO
WHERE hc.HISTCLIDATA BETWEEN ? AND ?
ORDER BY hc.HISTCLIDATA DESC, hc.HISTCLIHORA DESC;
```

---

### 4. Relatório Completo de Histórico de Clientes

**Objetivo:** Analisar distribuição completa de históricos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_HISTORICOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_COM_HISTORICO,
    COUNT(DISTINCT HISTCLITIPO) AS TOTAL_TIPOS_EVENTO,
    MIN(HISTCLIDATA) AS PRIMEIRA_DATA,
    MAX(HISTCLIDATA) AS ULTIMA_DATA
FROM HISTCLI;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com HISTCLI | Tipo |
|--------|-----------|---------------------|------|
| **HISTCLI** | 9 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 1:0.001 | Clientes (média de 0.001 históricos por cliente) |

**Interpretação:**
- **9 registros históricos** cadastrados no sistema
- **Média de 0.001 históricos por cliente** - indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_HISTCLI_CLIENTE ON HISTCLI(CLICODIGO);

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_HISTCLI_DATA ON HISTCLI(HISTCLIDATA)
    WHERE HISTCLIDATA IS NOT NULL;

-- Índice 3: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_HISTCLI_TIPO ON HISTCLI(HISTCLITIPO)
    WHERE HISTCLITIPO IS NOT NULL;

-- Índice 4: Busca combinada cliente + data (consultas frequentes)
CREATE INDEX IDX_HISTCLI_CLIENTE_DATA ON HISTCLI(CLICODIGO, HISTCLIDATA);
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

final class FirebirdHistcli extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'HISTCLI';
    
    protected $primaryKey = ['HISTCLICODIGO', 'CLICODIGO'];
    public $incrementing = false;

    protected $casts = [
        'HISTCLICODIGO' => 'integer',
        'CLICODIGO' => 'integer',
        'HISTCLIDATA' => 'date',
        'HISTCLIHORA' => 'string',
        'HISTCLIOBS' => 'string',
        'HISTCLITIPO' => 'string',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    public function scopePorCliente($query, int $cliCodigo)
    {
        return $query->where('CLICODIGO', $cliCodigo);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('HISTCLITIPO', $tipo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('HISTCLIDATA', [$dataInicial, $dataFinal]);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

