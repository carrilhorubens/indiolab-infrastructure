# PFCAN - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: PFCAN (Pedido Fornecedor - Cancelamento)
- **Total de Registros**: 82
- **Total de Colunas**: 4
- **Chave Primária**: ID_PEDIDO
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**PFCAN** é uma tabela de auditoria que registra cancelamentos de pedidos de fornecedores. Com **82 registros**, esta tabela armazena informações sobre quando e por que um pedido de fornecedor foi cancelado, mantendo histórico para rastreamento e auditoria.

Esta tabela é essencial para:
- **Auditoria**: Manter histórico de cancelamentos de pedidos de fornecedores
- **Rastreamento**: Rastrear motivos de cancelamento
- **Compliance**: Atender requisitos de auditoria e compliance
- **Análise**: Analisar padrões de cancelamento

**Contexto de Negócio:**
Quando um pedido de fornecedor é cancelado, esta tabela registra a data do cancelamento, o motivo (tipo de cancelamento) e um histórico descritivo do cancelamento.

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ID_PEDIDO** 🔑 🔗 | INT | Código do pedido fornecedor cancelado (PK, FK → PEDFO) |
| **PFCDATA** | TIMESTAMP | Data/hora do cancelamento |
| **PFCHISTORICO** | VARCHAR(37) | Histórico/descrição do cancelamento |
| **TPNCODIGO** 🔗 | INT | Código do tipo de cancelamento (FK → TPCANCELAMENTO) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### PEDFO - Pedido Fornecedor (FK Obrigatória)
**Volume:** 129.041 registros

**Relacionamento:**
```
PFCAN.ID_PEDIDO → PEDFO.ID_PEDIDO (1:1)
Constraint: PEDFO_PFCAN
```

**Descrição:** Cada registro de cancelamento está vinculado a um pedido de fornecedor específico. Relacionamento 1:1, onde cada pedido pode ter no máximo um registro de cancelamento.

**Proporção:** ~0,06% dos pedidos de fornecedores foram cancelados (82 / 129.041)

---

### TPCANCELAMENTO - Tipo de Cancelamento (FK Opcional)
**Volume:** 10 registros

**Relacionamento:**
```
PFCAN.TPNCODIGO → TPCANCELAMENTO.TPNCODIGO (N:1)
Constraint: TPCANCELAMENTO_PFCAN
```

**Descrição:** Define o motivo/tipo do cancelamento.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### PEDFO → CLIEN (Fornecedor)
**Volume:** 9.251 registros

**Relacionamento:**
```
PFCAN → PEDFO → CLIEN
```

**Descrição:** Através de PEDFO, é possível identificar o fornecedor relacionado.

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    PFCAN {
        INT ID_PEDIDO PK
        TIMESTAMP PFCDATA
        VARCHAR PFCHISTORICO
        INT TPNCODIGO FK
    }
    
    PEDFO {
        INT ID_PEDIDO PK
        INT CLICODIGO FK
        VARCHAR PEFCODIGO
    }
    
    TPCANCELAMENTO {
        INT TPNCODIGO PK
        VARCHAR TPNDESCRICAO
    }
    
    CLIEN {
        INT CLICODIGO PK
        VARCHAR CLIRAZSOCIAL
    }
    
    PFCAN }o--|| PEDFO : "ID_PEDIDO"
    PFCAN }o--o| TPCANCELAMENTO : "TPNCODIGO"
    PEDFO }o--|| CLIEN : "CLICODIGO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT ID_PEDIDO, PFCDATA, PFCHISTORICO, TPNCODIGO
FROM PFCAN
WHERE ID_PEDIDO = ?;
```

### Consulta com Informações do Pedido e Tipo de Cancelamento

```sql
SELECT 
    pc.*,
    pf.PEFCODIGO,
    pf.PEFDTEMIS,
    pf.PEFVRTOTAL,
    c.CLIRAZSOCIAL AS FORNECEDOR,
    tp.TPNDESCRICAO
FROM PFCAN pc
INNER JOIN PEDFO pf
    ON pc.ID_PEDIDO = pf.ID_PEDIDO
INNER JOIN CLIEN c
    ON pf.CLICODIGO = c.CLICODIGO
LEFT JOIN TPCANCELAMENTO tp
    ON pc.TPNCODIGO = tp.TPNCODIGO
WHERE pc.ID_PEDIDO = ?;
```

### Estatísticas de Cancelamento por Tipo

```sql
SELECT 
    tp.TPNDESCRICAO,
    COUNT(*) AS TOTAL_CANCELAMENTOS,
    SUM(pf.PEFVRTOTAL) AS VALOR_TOTAL_CANCELADO
FROM PFCAN pc
INNER JOIN TPCANCELAMENTO tp
    ON pc.TPNCODIGO = tp.TPNCODIGO
INNER JOIN PEDFO pf
    ON pc.ID_PEDIDO = pf.ID_PEDIDO
GROUP BY tp.TPNCODIGO, tp.TPNDESCRICAO
ORDER BY TOTAL_CANCELAMENTOS DESC;
```

### Inserção de Cancelamento

```sql
INSERT INTO PFCAN (ID_PEDIDO, PFCDATA, PFCHISTORICO, TPNCODIGO)
VALUES (?, CURRENT_TIMESTAMP, ?, ?);
```

---

## ⚡ Performance e Otimização

### Índices Recomendados

#### 1. Índice na Chave Primária (Já existe implicitamente)
```sql
-- Índice primário já existe implicitamente
```

#### 2. Índice em PFCDATA
```sql
CREATE INDEX IDX_PFCAN_PFCDATA 
ON PFCAN (PFCDATA);
```

**Justificativa:** Facilita buscas por data de cancelamento.

---

## 📊 Estatísticas e Insights

### Volume de Dados

- **Total de Registros**: 82
- **Tamanho Médio Estimado**: ~50 bytes por registro
- **Tamanho Total Estimado**: ~4 KB

### Distribuição de Dados

- **Pedidos Cancelados**: 82 pedidos
- **Taxa de Cancelamento**: ~0,06% dos pedidos de fornecedores foram cancelados

---

## 🔧 Integração com Código Laravel

### Model Eloquent

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class PfCan extends Model
{
    protected $table = 'PFCAN';
    protected $primaryKey = 'ID_PEDIDO';
    public $incrementing = false;
    public $timestamps = false;

    protected $fillable = [
        'ID_PEDIDO',
        'PFCDATA',
        'PFCHISTORICO',
        'TPNCODIGO',
    ];

    protected $casts = [
        'ID_PEDIDO' => 'integer',
        'PFCDATA' => 'datetime',
        'PFCHISTORICO' => 'string',
        'TPNCODIGO' => 'integer',
    ];

    /**
     * Relacionamento com Pedido Fornecedor
     */
    public function pedidoFornecedor(): BelongsTo
    {
        return $this->belongsTo(PedFo::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    /**
     * Relacionamento com Tipo de Cancelamento
     */
    public function tipoCancelamento(): BelongsTo
    {
        return $this->belongsTo(TpCancelamento::class, 'TPNCODIGO', 'TPNCODIGO');
    }

    /**
     * Cancelar pedido fornecedor
     */
    public static function cancelar(int $idPedido, int $tpnCodigo, string $historico): self
    {
        return self::create([
            'ID_PEDIDO' => $idPedido,
            'PFCDATA' => now(),
            'PFCHISTORICO' => $historico,
            'TPNCODIGO' => $tpnCodigo,
        ]);
    }
}
```

---

## ✅ Boas Práticas

### Design

1. **Chave Primária**: ID_PEDIDO deve corresponder a um PEDFO válido
2. **Validação**: Validar TPNCODIGO antes de inserir
3. **Histórico**: Sempre preencher PFCHISTORICO com descrição clara

### Performance

1. **Índices**: Usar índice para busca por data
2. **Consultas**: Usar eager loading para relacionamentos

### Segurança

1. **Validação**: Validar todos os valores antes de inserir
2. **Acesso**: Restringir acesso de escrita a usuários autorizados
3. **Auditoria**: Manter histórico completo de cancelamentos

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

