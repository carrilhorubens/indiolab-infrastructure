# INTOPTICLICK - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INTOPTICLICK (Integração OptClick)
- **Total de Registros**: 3.577.751
- **Total de Colunas**: 10
- **Chave Primária**: INTOPCODIGO (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**INTOPTICLICK** é uma tabela que armazena registros de integração com o sistema OptClick. Com **3.577.751 registros**, representa um extenso histórico de integrações, incluindo envios e retornos de arquivos entre o sistema ERP e o OptClick.

Esta tabela funciona como **log de integração OptClick** e permite:
- Registrar todas as integrações com o OptClick
- Armazenar informações de envio e retorno de arquivos
- Rastrear status de processamento de integrações
- Vincular integrações a pedidos do sistema
- Facilitar auditoria de integrações
- Manter histórico completo de integração

Cada registro representa uma integração específica, contendo:
- Código da integração (INTOPCODIGO)
- Data da integração (INTOPDATA)
- ID do pedido no sistema (ID_PEDIDO) - FK → PEDID
- Data de envio (INTOPDTENVIO)
- Hora de envio (INTOPHRAENVIO)
- Data de retorno (INTOPDTRETORNO)
- Hora de retorno (INTOPHRRETORNO)
- Número do pedido OptClick (INTOPNROPTICLICK)
- Arquivo da integração (INTOPARQUIVO)
- Tipo de arquivo (INTOPTPARQUIVO)

O sistema utiliza esta tabela para manter histórico completo de integrações com o OptClick, permitindo rastreamento detalhado e auditoria completa.

**Observação Importante:** INTOPTICLICK é uma tabela de log muito grande (3.577.751 registros), indicando uso extensivo desta funcionalidade de integração. Possui relacionamento direto com PEDID através de ID_PEDIDO e índice em INTOPDATA para otimização de consultas por data.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **INTOPCODIGO** 🔑 | INTEGER | ✓ | Código da integração OptClick (PK) |

### Relacionamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PEDIDO** 🔗 | INTEGER | ✓ | ID do pedido no sistema (FK → PEDID) |

### Informações da Integração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **INTOPDATA** | DATE | | Data da integração |
| **INTOPDTENVIO** | DATE | | Data de envio |
| **INTOPHRAENVIO** | TIME | | Hora de envio |
| **INTOPDTRETORNO** | DATE | | Data de retorno |
| **INTOPHRRETORNO** | TIME | | Hora de retorno |
| **INTOPNROPTICLICK** | INTEGER | | Número do pedido no OptClick |
| **INTOPARQUIVO** | VARCHAR(261) | | Arquivo da integração |
| **INTOPTPARQUIVO** | VARCHAR(14) | ✓ | Tipo de arquivo |

**Primary Key:** INTOPCODIGO

**Foreign Keys:**
- `ID_PEDIDO` → `PEDID.ID_PEDIDO` (Constraint: FK_INTOPTICLICK_PEDID)

**Índices:**
- `IND_INTOPDATA` em `INTOPDATA` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INTOPTICLICK Referencia (1 FK):

#### 1. PEDID - Pedidos
**Relacionamento:**
```
INTOPTICLICK.ID_PEDIDO → PEDID.ID_PEDIDO (N:1)
Constraint: FK_INTOPTICLICK_PEDID
```

**Descrição**: Cada integração está vinculada a um pedido específico.

**Informações da Tabela PEDID:**
- **Total:** 3.099.176 pedidos
- **PK:** ID_PEDIDO
- **Colunas:** 173 campos

**Uso:** Identificar o pedido ao qual a integração pertence.

---

### INTOPTICLICK é Referenciada Por (0 tabelas):

Nenhuma tabela referencia INTOPTICLICK diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PEDID → Outras Operações de Pedidos

**Fluxo:** INTOPTICLICK → PEDID → Operações

**Descrição:** Através do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de integrações através de operações de pedidos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Integração OptClick

**Objetivo:** Obter informações de uma integração específica.

```sql
SELECT
    INTOPCODIGO,
    INTOPDATA,
    ID_PEDIDO,
    INTOPDTENVIO,
    INTOPHRAENVIO,
    INTOPDTRETORNO,
    INTOPHRRETORNO,
    INTOPNROPTICLICK,
    INTOPARQUIVO,
    INTOPTPARQUIVO
FROM INTOPTICLICK
WHERE INTOPCODIGO = ?;
```

---

### 2. Listar Integrações de um Pedido

**Objetivo:** Obter todas as integrações de um pedido específico.

```sql
SELECT
    INTOPCODIGO,
    INTOPDATA,
    INTOPDTENVIO,
    INTOPHRAENVIO,
    INTOPDTRETORNO,
    INTOPHRRETORNO,
    INTOPNROPTICLICK,
    INTOPTPARQUIVO
FROM INTOPTICLICK
WHERE ID_PEDIDO = ?
ORDER BY INTOPDATA DESC, INTOPHRAENVIO DESC;
```

---

### 3. Análise de Integrações por Período

**Objetivo:** Identificar distribuição de integrações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM INTOPDATA) AS ANO,
    EXTRACT(MONTH FROM INTOPDATA) AS MES,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT INTOPTPARQUIVO) AS TOTAL_TIPOS_ARQUIVO
FROM INTOPTICLICK
WHERE INTOPDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM INTOPDATA), EXTRACT(MONTH FROM INTOPDATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Análise de Integrações com Retorno

**Objetivo:** Identificar integrações que possuem retorno.

**Query SQL:**
```sql
SELECT
    INTOPTPARQUIVO,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(INTOPDTRETORNO) AS TOTAL_COM_RETORNO,
    COUNT(*) - COUNT(INTOPDTRETORNO) AS TOTAL_SEM_RETORNO
FROM INTOPTICLICK
GROUP BY INTOPTPARQUIVO
ORDER BY TOTAL_INTEGRACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INTOPTICLICK | Tipo |
|--------|-----------|--------------------------|------|
| **INTOPTICLICK** | 3.577.751 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | 3.099.176 | 1:1.15 | Pedidos (média de 1.15 integrações por pedido) |

**Interpretação:**
- **3.577.751 integrações** registradas no sistema
- **Média de 1.15 integrações por pedido** - indica que a maioria dos pedidos possui integração com OptClick

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índice existente: Busca por data (consultas frequentes)
-- IND_INTOPDATA em INTOPDATA
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por pedido (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_INTOPTICLICK_PEDIDO ON INTOPTICLICK(ID_PEDIDO)
    WHERE ID_PEDIDO IS NOT NULL;

-- Índice 2: Busca por tipo de arquivo (consultas frequentes)
CREATE INDEX IDX_INTOPTICLICK_TIPO_ARQUIVO ON INTOPTICLICK(INTOPTPARQUIVO)
    WHERE INTOPTPARQUIVO IS NOT NULL;

-- Índice 3: Busca combinada pedido + data (consultas frequentes)
CREATE INDEX IDX_INTOPTICLICK_PEDIDO_DATA ON INTOPTICLICK(ID_PEDIDO, INTOPDATA);
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

final class FirebirdIntopticlick extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INTOPTICLICK';
    
    protected $primaryKey = 'INTOPCODIGO';
    public $incrementing = true;

    protected $casts = [
        'INTOPCODIGO' => 'integer',
        'INTOPDATA' => 'date',
        'ID_PEDIDO' => 'integer',
        'INTOPDTENVIO' => 'date',
        'INTOPHRAENVIO' => 'string',
        'INTOPDTRETORNO' => 'date',
        'INTOPHRRETORNO' => 'string',
        'INTOPNROPTICLICK' => 'integer',
        'INTOPARQUIVO' => 'string',
        'INTOPTPARQUIVO' => 'string',
    ];

    // Relacionamento com PEDID
    public function pedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    public function scopePorPedido($query, int $idPedido)
    {
        return $query->where('ID_PEDIDO', $idPedido);
    }

    public function scopePorTipoArquivo($query, string $tipoArquivo)
    {
        return $query->where('INTOPTPARQUIVO', $tipoArquivo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('INTOPDATA', [$dataInicial, $dataFinal]);
    }

    public function scopeComRetorno($query)
    {
        return $query->whereNotNull('INTOPDTRETORNO');
    }

    public function scopeSemRetorno($query)
    {
        return $query->whereNull('INTOPDTRETORNO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

