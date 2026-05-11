# LOG_NSNUMERO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOG_NSNUMERO (Log de Número de Nota de Serviço)
- **Total de Registros**: 97.905
- **Total de Colunas**: 14
- **Chave Primária**: ID_NSNUMERO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 1
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOG_NSNUMERO** é uma tabela que armazena logs de alterações em números de nota de serviço. Com **97.905 registros**, representa um extenso histórico de mudanças em números de nota de serviço, permitindo auditoria completa de alterações.

Esta tabela funciona como **log de alterações de número de nota de serviço** e permite:
- Registrar todas as alterações em números de nota de serviço
- Armazenar valores antigos e novos de números de nota
- Rastrear sequenciais de números de nota
- Vincular alterações a contas a receber e empresas
- Facilitar auditoria completa de alterações
- Manter histórico detalhado de mudanças

Cada registro representa uma alteração específica em um número de nota de serviço, contendo:
- ID do log (ID_NSNUMERO)
- Código da conta a receber (RECCODIGO) - lógica → RECEB
- Código da empresa (EMPCODIGO) - lógica → EMPRESA
- Tipo de recebimento (RECTP)
- Data do log (LNS_DATA)
- Hora do log (LNS_HORA)
- Número de nota de serviço antigo (LNS_RECNSNUMERO_OLD)
- Número de nota de serviço novo (LNS_RECNSNUMERO_NEW)
- Sequencial de número de nota antigo (LNS_RECSEQNSNUMERO_OLD)
- Sequencial de número de nota novo (LNS_RECSEQNSNUMERO_NEW)
- Código do banco antigo (LNS_BCOCODIGO_OLD) - lógica → BANCO
- Código de cobrança antigo (LNS_COBCODIGO_OLD)
- Código do banco novo (LNS_BCOCODIGO_NEW) - lógica → BANCO
- Código de cobrança novo (LNS_COBCODIGO_NEW)

O sistema utiliza esta tabela para manter histórico completo de alterações em números de nota de serviço, permitindo auditoria detalhada e rastreamento de mudanças.

**Observação Importante:** LOG_NSNUMERO é uma tabela de log muito grande (97.905 registros), indicando uso extensivo desta funcionalidade de auditoria. Possui índice composto em (RECCODIGO, EMPCODIGO, RECTP) para otimização de consultas e relacionamentos lógicos com RECEB, EMPRESA e BANCO.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_NSNUMERO** 🔑 | INTEGER | ✓ | ID do log de número de nota de serviço (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **RECCODIGO** | INTEGER | ✓ | Código da conta a receber (lógica → RECEB) |
| **EMPCODIGO** | SMALLINT | ✓ | Código da empresa (lógica → EMPRESA) |
| **RECTP** | VARCHAR(14) | | Tipo de recebimento |

### Informações do Log
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LNS_DATA** | DATE | ✓ | Data do log |
| **LNS_HORA** | TIME | ✓ | Hora do log |
| **LNS_RECNSNUMERO_OLD** | VARCHAR(37) | | Número de nota de serviço antigo |
| **LNS_RECNSNUMERO_NEW** | VARCHAR(37) | | Número de nota de serviço novo |
| **LNS_RECSEQNSNUMERO_OLD** | INTEGER | | Sequencial de número de nota antigo |
| **LNS_RECSEQNSNUMERO_NEW** | INTEGER | | Sequencial de número de nota novo |
| **LNS_BCOCODIGO_OLD** | SMALLINT | ✓ | Código do banco antigo (lógica → BANCO) |
| **LNS_COBCODIGO_OLD** | VARCHAR(14) | ✓ | Código de cobrança antigo |
| **LNS_BCOCODIGO_NEW** | SMALLINT | ✓ | Código do banco novo (lógica → BANCO) |
| **LNS_COBCODIGO_NEW** | VARCHAR(14) | ✓ | Código de cobrança novo |

**Primary Key:** ID_NSNUMERO

**Índices:**
- `IND_RECEB_LOG_NSNUMERO` em `(RECCODIGO, EMPCODIGO, RECTP)` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOG_NSNUMERO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOG_NSNUMERO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOG_NSNUMERO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via RECCODIGO → RECEB → Outras Operações de Contas a Receber

**Fluxo:** LOG_NSNUMERO → RECEB → Operações

**Descrição:** Através da conta a receber, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de contas a receber.

---

### Via EMPCODIGO → EMPRESA → Outras Operações da Empresa

**Fluxo:** LOG_NSNUMERO → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações da empresa.

---

### Via LNS_BCOCODIGO_OLD/NEW → BANCO → Outras Operações Bancárias

**Fluxo:** LOG_NSNUMERO → BANCO → Operações

**Descrição:** Através do banco, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações bancárias.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Número de Nota de Serviço

**Objetivo:** Obter informações de um log específico.

```sql
SELECT
    ID_NSNUMERO,
    RECCODIGO,
    EMPCODIGO,
    RECTP,
    LNS_DATA,
    LNS_HORA,
    LNS_RECNSNUMERO_OLD,
    LNS_RECNSNUMERO_NEW,
    LNS_BCOCODIGO_OLD,
    LNS_BCOCODIGO_NEW
FROM LOG_NSNUMERO
WHERE ID_NSNUMERO = ?;
```

---

### 2. Listar Logs de uma Conta a Receber

**Objetivo:** Obter todos os logs de uma conta a receber específica.

```sql
SELECT
    ID_NSNUMERO,
    LNS_DATA,
    LNS_HORA,
    LNS_RECNSNUMERO_OLD,
    LNS_RECNSNUMERO_NEW,
    LNS_BCOCODIGO_OLD,
    LNS_BCOCODIGO_NEW
FROM LOG_NSNUMERO
WHERE RECCODIGO = ?
  AND EMPCODIGO = ?
ORDER BY LNS_DATA DESC, LNS_HORA DESC;
```

---

### 3. Análise de Alterações por Período

**Objetivo:** Identificar distribuição de alterações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM LNS_DATA) AS ANO,
    EXTRACT(MONTH FROM LNS_DATA) AS MES,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT RECCODIGO) AS TOTAL_CONTAS_AFETADAS
FROM LOG_NSNUMERO
WHERE LNS_DATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM LNS_DATA), EXTRACT(MONTH FROM LNS_DATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Análise de Alterações por Banco

**Objetivo:** Identificar distribuição de alterações por banco.

**Query SQL:**
```sql
SELECT
    LNS_BCOCODIGO_NEW AS BANCO,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT RECCODIGO) AS TOTAL_CONTAS_AFETADAS
FROM LOG_NSNUMERO
WHERE LNS_BCOCODIGO_NEW IS NOT NULL
GROUP BY LNS_BCOCODIGO_NEW
ORDER BY TOTAL_ALTERACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOG_NSNUMERO | Tipo |
|--------|-----------|-------------------------|------|
| **LOG_NSNUMERO** | 97.905 | 1:1 | **TABELA PRINCIPAL** |
| RECEB | Informação não disponível | - | Contas a receber |

**Interpretação:**
- **97.905 alterações** de número de nota de serviço registradas no sistema
- Indica uso extensivo desta funcionalidade de auditoria

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índice existente: Busca por conta a receber, empresa e tipo (consultas frequentes)
-- IND_RECEB_LOG_NSNUMERO em (RECCODIGO, EMPCODIGO, RECTP)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por data (consultas frequentes)
CREATE INDEX IDX_LOG_NSNUMERO_DATA ON LOG_NSNUMERO(LNS_DATA)
    WHERE LNS_DATA IS NOT NULL;

-- Índice 2: Busca por banco novo (consultas frequentes)
CREATE INDEX IDX_LOG_NSNUMERO_BANCO_NEW ON LOG_NSNUMERO(LNS_BCOCODIGO_NEW)
    WHERE LNS_BCOCODIGO_NEW IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogNsnumero extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOG_NSNUMERO';
    
    protected $primaryKey = 'ID_NSNUMERO';
    public $incrementing = true;

    protected $casts = [
        'ID_NSNUMERO' => 'integer',
        'RECCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'RECTP' => 'string',
        'LNS_DATA' => 'date',
        'LNS_HORA' => 'string',
        'LNS_RECNSNUMERO_OLD' => 'string',
        'LNS_RECNSNUMERO_NEW' => 'string',
        'LNS_RECSEQNSNUMERO_OLD' => 'integer',
        'LNS_RECSEQNSNUMERO_NEW' => 'integer',
        'LNS_BCOCODIGO_OLD' => 'integer',
        'LNS_COBCODIGO_OLD' => 'string',
        'LNS_BCOCODIGO_NEW' => 'integer',
        'LNS_COBCODIGO_NEW' => 'string',
    ];

    // Relacionamento lógico com RECEB
    public function contaReceber()
    {
        return $this->belongsTo(FirebirdReceb::class, 'RECCODIGO', 'RECCODIGO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function scopePorContaReceber($query, int $recCodigo, int $empCodigo)
    {
        return $query->where('RECCODIGO', $recCodigo)
                     ->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('LNS_DATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('LNS_DATA', 'desc')->orderBy('LNS_HORA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

