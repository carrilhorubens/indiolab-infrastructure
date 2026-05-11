# MOVOCORRENCIA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOVOCORRENCIA (Movimentações de Ocorrências)
- **Total de Registros**: 1.971.341
- **Total de Colunas**: 15
- **Chave Primária**: ID_MVOCOCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 1
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOVOCORRENCIA** é uma tabela que armazena movimentações de ocorrências relacionadas a pedidos. Com **1.971.341 registros**, representa um histórico extenso de ocorrências registradas no sistema, incluindo informações sobre pedido, tipo de ocorrência, data/hora, responsável, autor, almoxarifado, empresa, origem, situação, tipo, usuário e tipo de usuário.

Esta tabela funciona como **log de ocorrências** e permite:
- Registrar todas as movimentações de ocorrências
- Armazenar informações sobre pedido e tipo de ocorrência
- Rastrear data/hora e responsável da ocorrência
- Identificar autor, almoxarifado e empresa
- Controlar origem, situação e tipo da ocorrência
- Rastrear usuário e tipo de usuário
- Facilitar auditoria de ocorrências
- Manter histórico detalhado de movimentações

Cada registro representa uma ocorrência específica, contendo:
- ID da ocorrência (ID_MVOCOCODIGO)
- ID do pedido (ID_PEDIDO)
- Código do tipo de ocorrência (TPOCCODIGO)
- Data da ocorrência (MVOCPDATA)
- Hora da ocorrência (MVOCHORA)
- Complemento da ocorrência (MVOCPCOMPLE)
- Código do responsável (RESPCODIGO)
- Código do autor (AUTOCODIGO)
- Código do almoxarifado (ALXCODIGO)
- Código da empresa (EMPCODIGO)
- Origem da ocorrência (MVOCPORIGEM)
- Código da situação (TPSCODIGO)
- Tipo da ocorrência (MVOCTIPO)
- Código do usuário (USUCODIGO)
- Código do tipo de usuário (TPUCODIGO)

O sistema utiliza esta tabela para manter histórico completo de ocorrências, permitindo auditoria detalhada e rastreamento de eventos relacionados a pedidos.

**Observação Importante:** MOVOCORRENCIA é uma tabela de log de ocorrências. Com 1.971.341 registros, indica uso intenso desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com PEDID através de ID_PEDIDO, com TPOCORR através de TPOCCODIGO, com FUNCIO através de RESPCODIGO e AUTOCODIGO, com ALMOX através de ALXCODIGO, com EMPRESA através de EMPCODIGO, com TPSITUACAO através de TPSCODIGO, com USUARIO através de USUCODIGO e com TPUSUARIO através de TPUCODIGO. Possui 1 índice em ID_PEDIDO para otimização de consultas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_MVOCOCODIGO** 🔑 | INTEGER | ✓ | ID da ocorrência (PK) |

### Informações do Pedido e Tipo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PEDIDO** | INTEGER | | ID do pedido relacionado |
| **TPOCCODIGO** | INTEGER | | Código do tipo de ocorrência |

### Informações de Data/Hora
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MVOCPDATA** | DATE | | Data da ocorrência |
| **MVOCHORA** | TIME | | Hora da ocorrência |

### Informações da Ocorrência
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MVOCPCOMPLE** | VARCHAR(37) | | Complemento da ocorrência |
| **MVOCTIPO** | VARCHAR(14) | ✓ | Tipo da ocorrência |
| **MVOCPORIGEM** | VARCHAR(14) | | Origem da ocorrência |

### Informações de Responsáveis
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **RESPCODIGO** | INTEGER | | Código do responsável |
| **AUTOCODIGO** | INTEGER | | Código do autor |
| **USUCODIGO** | INTEGER | | Código do usuário |
| **TPUCODIGO** | INTEGER | | Código do tipo de usuário |

### Informações de Localização
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ALXCODIGO** | INTEGER | | Código do almoxarifado |
| **EMPCODIGO** | INTEGER | | Código da empresa |
| **TPSCODIGO** | INTEGER | | Código da situação |

**Primary Key:** ID_MVOCOCODIGO

**Índices:**
- `INDIDX_PEDIDO` em `ID_PEDIDO` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOVOCORRENCIA Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MOVOCORRENCIA é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOVOCORRENCIA diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDID

**Fluxo:** MOVOCORRENCIA → PEDID → Operações

**Descrição:** Através do ID do pedido, é possível identificar pedidos relacionados.

**Uso:** Análise de ocorrências através de pedidos.

---

### Via TPOCCODIGO → TPOCORR

**Fluxo:** MOVOCORRENCIA → TPOCORR → Operações

**Descrição:** Através do código do tipo de ocorrência, é possível identificar tipos relacionados.

**Uso:** Análise de ocorrências através de tipos.

---

### Via RESPCODIGO, AUTOCODIGO → FUNCIO

**Fluxo:** MOVOCORRENCIA → FUNCIO → Operações

**Descrição:** Através dos códigos de responsável e autor, é possível identificar funcionários relacionados.

**Uso:** Análise de ocorrências através de funcionários.

---

### Via ALXCODIGO → ALMOX

**Fluxo:** MOVOCORRENCIA → ALMOX → Operações

**Descrição:** Através do código do almoxarifado, é possível identificar almoxarifados relacionados.

**Uso:** Análise de ocorrências através de almoxarifados.

---

### Via EMPCODIGO → EMPRESA

**Fluxo:** MOVOCORRENCIA → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de ocorrências através de operações de empresas.

---

### Via TPSCODIGO → TPSITUACAO

**Fluxo:** MOVOCORRENCIA → TPSITUACAO → Operações

**Descrição:** Através do código da situação, é possível identificar situações relacionadas.

**Uso:** Análise de ocorrências através de situações.

---

### Via USUCODIGO → USUARIO

**Fluxo:** MOVOCORRENCIA → USUARIO → Operações

**Descrição:** Através do código do usuário, é possível identificar usuários relacionados.

**Uso:** Análise de ocorrências através de usuários.

---

### Via TPUCODIGO → TPUSUARIO

**Fluxo:** MOVOCORRENCIA → TPUSUARIO → Operações

**Descrição:** Através do código do tipo de usuário, é possível identificar tipos relacionados.

**Uso:** Análise de ocorrências através de tipos de usuário.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Ocorrência

**Objetivo:** Obter informações de uma ocorrência específica.

```sql
SELECT
    ID_MVOCOCODIGO,
    ID_PEDIDO,
    TPOCCODIGO,
    MVOCPDATA,
    MVOCHORA,
    MVOCPCOMPLE,
    RESPCODIGO,
    AUTOCODIGO,
    ALXCODIGO,
    EMPCODIGO,
    MVOCPORIGEM,
    TPSCODIGO,
    MVOCTIPO,
    USUCODIGO,
    TPUCODIGO
FROM MOVOCORRENCIA
WHERE ID_MVOCOCODIGO = ?;
```

---

### 2. Listar Ocorrências de um Pedido

**Objetivo:** Obter todas as ocorrências de um pedido específico.

```sql
SELECT
    ID_MVOCOCODIGO,
    TPOCCODIGO,
    MVOCPDATA,
    MVOCHORA,
    MVOCPCOMPLE,
    RESPCODIGO,
    MVOCTIPO
FROM MOVOCORRENCIA
WHERE ID_PEDIDO = ?
ORDER BY MVOCPDATA DESC, MVOCHORA DESC;
```

---

### 3. Análise de Ocorrências por Tipo

**Objetivo:** Identificar distribuição de ocorrências por tipo.

**Query SQL:**
```sql
SELECT
    MVOCTIPO,
    COUNT(*) AS TOTAL_OCORRENCIAS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM MOVOCORRENCIA
WHERE MVOCTIPO IS NOT NULL
GROUP BY MVOCTIPO
ORDER BY TOTAL_OCORRENCIAS DESC;
```

---

### 4. Análise de Ocorrências por Período

**Objetivo:** Identificar distribuição de ocorrências ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM MVOCPDATA) AS ANO,
    EXTRACT(MONTH FROM MVOCPDATA) AS MES,
    COUNT(*) AS TOTAL_OCORRENCIAS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM MOVOCORRENCIA
WHERE MVOCPDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM MVOCPDATA), EXTRACT(MONTH FROM MVOCPDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOVOCORRENCIA | Tipo |
|--------|-----------|---------------------------|------|
| **MOVOCORRENCIA** | 1.971.341 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | 3.099.176 | 1:0.64 | Pedidos (média de 0.64 ocorrências por pedido) |

**Interpretação:**
- **1.971.341 ocorrências** registradas no sistema
- **Média de 0.64 ocorrências por pedido** - indica que nem todos os pedidos possuem ocorrências

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índice existente: Busca por pedido (consultas frequentes - CRÍTICO)
-- INDIDX_PEDIDO em ID_PEDIDO (não único)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_MOVOCORRENCIA_TIPO ON MOVOCORRENCIA(MVOCTIPO)
    WHERE MVOCTIPO IS NOT NULL;

-- Índice 2: Busca por data (consultas frequentes)
CREATE INDEX IDX_MOVOCORRENCIA_DATA ON MOVOCORRENCIA(MVOCPDATA)
    WHERE MVOCPDATA IS NOT NULL;

-- Índice 3: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_MOVOCORRENCIA_EMPRESA ON MOVOCORRENCIA(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 4: Busca combinada pedido + data (consultas frequentes)
CREATE INDEX IDX_MOVOCORRENCIA_PEDIDO_DATA ON MOVOCORRENCIA(ID_PEDIDO, MVOCPDATA);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMovocorrencia extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOVOCORRENCIA';
    
    protected $primaryKey = 'ID_MVOCOCODIGO';
    public $incrementing = true;

    protected $casts = [
        'ID_MVOCOCODIGO' => 'integer',
        'ID_PEDIDO' => 'integer',
        'TPOCCODIGO' => 'integer',
        'MVOCPDATA' => 'date',
        'MVOCHORA' => 'string',
        'MVOCPCOMPLE' => 'string',
        'RESPCODIGO' => 'integer',
        'AUTOCODIGO' => 'integer',
        'ALXCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'MVOCPORIGEM' => 'string',
        'TPSCODIGO' => 'integer',
        'MVOCTIPO' => 'string',
        'USUCODIGO' => 'integer',
        'TPUCODIGO' => 'integer',
    ];

    public function scopePorPedido($query, int $idPedido)
    {
        return $query->where('ID_PEDIDO', $idPedido);
    }

    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('MVOCTIPO', $tipo);
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('MVOCPDATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MVOCPDATA', 'desc')->orderBy('MVOCHORA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

