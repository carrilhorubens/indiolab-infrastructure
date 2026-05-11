# HISTIDPEDIDO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: HISTIDPEDIDO (Histórico de ID de Pedido)
- **Total de Registros**: 709.981
- **Total de Colunas**: 8
- **Chave Primária**: Composta (SEQ, ID_PEDIDO)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**HISTIDPEDIDO** é uma tabela que armazena histórico completo de alterações e eventos relacionados a pedidos de venda. Com **709.981 registros**, representa um extenso histórico de mudanças de status, observações e eventos de pedidos, permitindo rastreamento completo e auditoria de todas as alterações em pedidos.

Esta tabela funciona como **histórico completo de pedidos** e permite:
- Registrar todas as alterações e eventos de pedidos
- Rastrear mudanças de status ao longo do tempo
- Armazenar observações e comentários sobre pedidos
- Identificar usuários e empresas responsáveis por cada evento
- Facilitar auditoria completa de pedidos
- Manter registro temporal detalhado de eventos

Cada registro representa um evento histórico específico de um pedido, contendo:
- Sequencial do histórico (SEQ) - parte da PK
- ID do pedido (ID_PEDIDO) - parte da PK (lógica → PEDID)
- Código da empresa (EMPCODIGO) - lógica → EMPRESA
- Código do usuário (USUCODIGO) - lógica → USUARIO
- Data do evento (DATA)
- Hora do evento (HORA)
- Status do evento (STATUS)
- Observação do evento (OBSERVACAO)

O sistema utiliza esta tabela para manter histórico completo de todas as alterações e eventos relacionados a pedidos, permitindo rastreamento detalhado e auditoria completa.

**Observação Importante:** HISTIDPEDIDO é uma tabela de histórico muito grande (709.981 registros), indicando uso extensivo desta funcionalidade. Possui chave primária composta e relacionamentos lógicos com PEDID, EMPRESA e USUARIO através de ID_PEDIDO, EMPCODIGO e USUCODIGO.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SEQ** 🔑 | INTEGER | ✓ | Sequencial do histórico (PK) |
| **ID_PEDIDO** 🔑 | INTEGER | ✓ | ID do pedido (PK, lógica → PEDID) |

### Relacionamentos Lógicos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **EMPCODIGO** | INTEGER | ✓ | Código da empresa (lógica → EMPRESA) |
| **USUCODIGO** | INTEGER | ✓ | Código do usuário (lógica → USUARIO) |

### Informações do Evento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATA** | DATE | ✓ | Data do evento histórico |
| **HORA** | TIME | ✓ | Hora do evento histórico |
| **STATUS** | VARCHAR(14) | ✓ | Status do evento histórico |
| **OBSERVACAO** | VARCHAR(37) | | Observação do evento histórico |

**Primary Key:** (SEQ, ID_PEDIDO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### HISTIDPEDIDO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### HISTIDPEDIDO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia HISTIDPEDIDO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDID → Outras Operações de Pedidos

**Fluxo:** HISTIDPEDIDO → PEDID → Operações

**Descrição:** Através do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de histórico através de operações de pedidos.

---

### Via EMPCODIGO → EMPRESA → Outras Operações da Empresa

**Fluxo:** HISTIDPEDIDO → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de histórico através de operações da empresa.

---

### Via USUCODIGO → USUARIO → Outras Operações do Usuário

**Fluxo:** HISTIDPEDIDO → USUARIO → Operações

**Descrição:** Através do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de histórico através de operações do usuário.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Histórico de Pedido

**Objetivo:** Obter visão completa de um histórico incluindo informações do pedido, empresa e usuário.

**Fluxo:**
```
HISTIDPEDIDO (SEQ, ID_PEDIDO, EMPCODIGO, USUCODIGO)
  ↓
PEDID (ID_PEDIDO)
  ↓
EMPRESA (EMPCODIGO)
  ↓
USUARIO (USUCODIGO)
```

**Query SQL:**
```sql
SELECT
    h.SEQ,
    h.ID_PEDIDO,
    p.PEDNUMERO AS NUMERO_PEDIDO,
    h.EMPCODIGO,
    e.EMPNOMEFANT AS EMPRESA,
    h.USUCODIGO,
    u.USUNOME AS USUARIO,
    h.DATA AS DATA_EVENTO,
    h.HORA AS HORA_EVENTO,
    h.STATUS AS STATUS_EVENTO,
    h.OBSERVACAO AS OBSERVACAO
FROM HISTIDPEDIDO h
LEFT JOIN PEDID p ON p.ID_PEDIDO = h.ID_PEDIDO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = h.EMPCODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = h.USUCODIGO
WHERE h.ID_PEDIDO = ?
ORDER BY h.DATA DESC, h.HORA DESC;
```

---

### Exemplo 2: Análise de Histórico por Pedido

**Objetivo:** Identificar todos os históricos de um pedido específico.

**Query SQL:**
```sql
SELECT
    SEQ,
    DATA AS DATA_EVENTO,
    HORA AS HORA_EVENTO,
    STATUS AS STATUS_EVENTO,
    OBSERVACAO AS OBSERVACAO,
    USUCODIGO,
    EMPCODIGO
FROM HISTIDPEDIDO
WHERE ID_PEDIDO = ?
ORDER BY DATA DESC, HORA DESC;
```

---

### Exemplo 3: Análise de Histórico por Status

**Objetivo:** Identificar distribuição de históricos por status.

**Query SQL:**
```sql
SELECT
    STATUS AS STATUS_EVENTO,
    COUNT(*) AS TOTAL_EVENTOS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT USUCODIGO) AS TOTAL_USUARIOS
FROM HISTIDPEDIDO
GROUP BY STATUS
ORDER BY TOTAL_EVENTOS DESC;
```

---

### Exemplo 4: Análise de Histórico por Usuário

**Objetivo:** Identificar distribuição de históricos por usuário.

**Query SQL:**
```sql
SELECT
    h.USUCODIGO,
    u.USUNOME AS USUARIO,
    COUNT(*) AS TOTAL_EVENTOS,
    COUNT(DISTINCT h.ID_PEDIDO) AS TOTAL_PEDIDOS
FROM HISTIDPEDIDO h
LEFT JOIN USUARIO u ON u.USUCODIGO = h.USUCODIGO
WHERE h.USUCODIGO IS NOT NULL
GROUP BY h.USUCODIGO, u.USUNOME
ORDER BY TOTAL_EVENTOS DESC;
```

---

### Exemplo 5: Análise de Histórico por Período

**Objetivo:** Identificar distribuição de históricos ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DATA) AS ANO,
    EXTRACT(MONTH FROM DATA) AS MES,
    COUNT(*) AS TOTAL_EVENTOS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT USUCODIGO) AS TOTAL_USUARIOS
FROM HISTIDPEDIDO
WHERE DATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATA), EXTRACT(MONTH FROM DATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Histórico de Pedido

**Objetivo:** Obter informações de um histórico específico.

```sql
SELECT
    SEQ,
    ID_PEDIDO,
    EMPCODIGO,
    USUCODIGO,
    DATA AS DATA_EVENTO,
    HORA AS HORA_EVENTO,
    STATUS AS STATUS_EVENTO,
    OBSERVACAO AS OBSERVACAO
FROM HISTIDPEDIDO
WHERE SEQ = ?
  AND ID_PEDIDO = ?;
```

---

### 2. Listar Históricos de um Pedido

**Objetivo:** Obter todos os históricos de um pedido específico.

```sql
SELECT
    SEQ,
    DATA AS DATA_EVENTO,
    HORA AS HORA_EVENTO,
    STATUS AS STATUS_EVENTO,
    OBSERVACAO AS OBSERVACAO,
    USUCODIGO,
    EMPCODIGO
FROM HISTIDPEDIDO
WHERE ID_PEDIDO = ?
ORDER BY DATA DESC, HORA DESC;
```

---

### 3. Análise de Histórico por Empresa

**Objetivo:** Identificar distribuição de históricos por empresa.

**Query SQL:**
```sql
SELECT
    h.EMPCODIGO,
    e.EMPNOMEFANT AS EMPRESA,
    COUNT(*) AS TOTAL_EVENTOS,
    COUNT(DISTINCT h.ID_PEDIDO) AS TOTAL_PEDIDOS
FROM HISTIDPEDIDO h
LEFT JOIN EMPRESA e ON e.EMPCODIGO = h.EMPCODIGO
WHERE h.EMPCODIGO IS NOT NULL
GROUP BY h.EMPCODIGO, e.EMPNOMEFANT
ORDER BY TOTAL_EVENTOS DESC;
```

---

### 4. Relatório Completo de Histórico de Pedidos

**Objetivo:** Analisar distribuição completa de históricos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_HISTORICOS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_COM_HISTORICO,
    COUNT(DISTINCT STATUS) AS TOTAL_STATUS_DIFERENTES,
    COUNT(DISTINCT USUCODIGO) AS TOTAL_USUARIOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    MIN(DATA) AS PRIMEIRA_DATA,
    MAX(DATA) AS ULTIMA_DATA
FROM HISTIDPEDIDO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com HISTIDPEDIDO | Tipo |
|--------|-----------|---------------------------|------|
| **HISTIDPEDIDO** | 709.981 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | 3.099.176 | 1:0.23 | Pedidos (média de 0.23 históricos por pedido) |

**Interpretação:**
- **709.981 registros históricos** cadastrados no sistema
- **Média de 0.23 históricos por pedido** - indica que nem todos os pedidos possuem histórico registrado

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por pedido (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_HISTIDPEDIDO_PEDIDO ON HISTIDPEDIDO(ID_PEDIDO);

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_HISTIDPEDIDO_DATA ON HISTIDPEDIDO(DATA)
    WHERE DATA IS NOT NULL;

-- Índice 3: Busca por status (consultas frequentes)
CREATE INDEX IDX_HISTIDPEDIDO_STATUS ON HISTIDPEDIDO(STATUS)
    WHERE STATUS IS NOT NULL;

-- Índice 4: Busca por usuário (consultas frequentes)
CREATE INDEX IDX_HISTIDPEDIDO_USUARIO ON HISTIDPEDIDO(USUCODIGO)
    WHERE USUCODIGO IS NOT NULL;

-- Índice 5: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_HISTIDPEDIDO_EMPRESA ON HISTIDPEDIDO(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 6: Busca combinada pedido + data (consultas frequentes)
CREATE INDEX IDX_HISTIDPEDIDO_PEDIDO_DATA ON HISTIDPEDIDO(ID_PEDIDO, DATA);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdHistidpedido extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'HISTIDPEDIDO';
    
    protected $primaryKey = ['SEQ', 'ID_PEDIDO'];
    public $incrementing = false;

    protected $casts = [
        'SEQ' => 'integer',
        'ID_PEDIDO' => 'integer',
        'EMPCODIGO' => 'integer',
        'USUCODIGO' => 'integer',
        'DATA' => 'date',
        'HORA' => 'string',
        'STATUS' => 'string',
        'OBSERVACAO' => 'string',
    ];

    // Relacionamento lógico com PEDID
    public function pedido()
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento lógico com USUARIO
    public function usuario()
    {
        return $this->belongsTo(FirebirdUsuario::class, 'USUCODIGO', 'USUCODIGO');
    }

    public function scopePorPedido($query, int $idPedido)
    {
        return $query->where('ID_PEDIDO', $idPedido);
    }

    public function scopePorStatus($query, string $status)
    {
        return $query->where('STATUS', $status);
    }

    public function scopePorUsuario($query, int $usuCodigo)
    {
        return $query->where('USUCODIGO', $usuCodigo);
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('DATA', 'desc')->orderBy('HORA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

