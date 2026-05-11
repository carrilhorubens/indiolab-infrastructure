# DELARQCM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DELARQCM (Deletar Arquivo CM)
- **Total de Registros**: 28.305
- **Total de Colunas**: 2
- **Chave Primária**: ID_DELARQCM (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**DELARQCM** é uma tabela que armazena registros de arquivos deletados relacionados a pedidos. Com **28.305 registros**, representa histórico de arquivos que foram marcados para deleção ou deletados, possivelmente relacionados a controle de mensagens ou arquivos de pedidos.

Esta tabela funciona como **registro de arquivos deletados** e permite:
- Rastrear arquivos deletados relacionados a pedidos
- Manter histórico de deleções de arquivos
- Controlar quais arquivos foram deletados de quais pedidos
- Suportar auditoria de deleções
- Facilitar recuperação ou análise de arquivos deletados

Cada registro representa um arquivo deletado relacionado a um pedido específico, contendo:
- Identificador único do registro de deleção (ID_DELARQCM)
- Identificador do pedido relacionado (ID_PEDIDO)

O sistema utiliza esta tabela para manter controle de arquivos deletados, permitindo auditoria e possível recuperação de informações sobre arquivos que foram removidos.

**Observação Importante:** DELARQCM é uma tabela de controle/auditoria que registra deleções de arquivos relacionados a pedidos. Com 28.305 registros, indica uso extensivo desta funcionalidade. Possivelmente relacionada a CTRARQCM (controle de arquivos CM).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_DELARQCM** 🔑 | INTEGER | ✓ | Identificador único do registro de deleção (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PEDIDO** | INTEGER | | Identificador do pedido relacionado (lógica → PEDID) |

**Primary Key:** ID_DELARQCM

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DELARQCM Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DELARQCM é Referenciada Por (0 tabelas):

Nenhuma tabela referencia DELARQCM diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDID → Outras Operações do Pedido

**Fluxo:** DELARQCM → PEDID → Operações

**Descrição:** Através do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de arquivos deletados por pedido.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise de Arquivos Deletados por Pedido

**Objetivo:** Obter visão completa de arquivos deletados incluindo informações do pedido.

**Fluxo:**
```
DELARQCM (ID_PEDIDO)
  ↓
PEDID (PEDCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    del.ID_DELARQCM,
    del.ID_PEDIDO,
    p.PEDCODIGO,
    p.PEDDATA AS DATA_PEDIDO,
    c.CLINOMEFANT AS CLIENTE,
    COUNT(*) OVER (PARTITION BY del.ID_PEDIDO) AS TOTAL_ARQUIVOS_DELETADOS_PEDIDO
FROM DELARQCM del
LEFT JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
WHERE del.ID_PEDIDO = ?
ORDER BY del.ID_DELARQCM DESC;
```

---

### Exemplo 2: Análise de Pedidos com Mais Arquivos Deletados

**Objetivo:** Identificar pedidos que tiveram mais arquivos deletados.

**Query SQL:**
```sql
SELECT
    del.ID_PEDIDO,
    p.PEDCODIGO,
    p.PEDDATA AS DATA_PEDIDO,
    c.CLINOMEFANT AS CLIENTE,
    COUNT(*) AS TOTAL_ARQUIVOS_DELETADOS
FROM DELARQCM del
LEFT JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
WHERE del.ID_PEDIDO IS NOT NULL
GROUP BY del.ID_PEDIDO, p.PEDCODIGO, p.PEDDATA, c.CLINOMEFANT
ORDER BY TOTAL_ARQUIVOS_DELETADOS DESC;
```

---

### Exemplo 3: Análise de Arquivos Deletados por Período

**Objetivo:** Identificar distribuição de arquivos deletados ao longo do tempo através dos pedidos.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM p.PEDDATA) AS ANO,
    EXTRACT(MONTH FROM p.PEDDATA) AS MES,
    COUNT(*) AS TOTAL_ARQUIVOS_DELETADOS,
    COUNT(DISTINCT del.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DELARQCM del
LEFT JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
WHERE p.PEDDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM p.PEDDATA), EXTRACT(MONTH FROM p.PEDDATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Registro de Deleção

**Objetivo:** Obter informações de um registro de deleção específico.

```sql
SELECT
    ID_DELARQCM,
    ID_PEDIDO
FROM DELARQCM
WHERE ID_DELARQCM = ?;
```

---

### 2. Listar Arquivos Deletados de um Pedido

**Objetivo:** Obter todos os arquivos deletados relacionados a um pedido específico.

```sql
SELECT
    ID_DELARQCM,
    ID_PEDIDO
FROM DELARQCM
WHERE ID_PEDIDO = ?
ORDER BY ID_DELARQCM DESC;
```

---

### 3. Análise de Arquivos Deletados por Cliente

**Objetivo:** Identificar distribuição de arquivos deletados por cliente.

**Query SQL:**
```sql
SELECT
    c.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    COUNT(*) AS TOTAL_ARQUIVOS_DELETADOS,
    COUNT(DISTINCT del.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DELARQCM del
LEFT JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
WHERE c.CLICODIGO IS NOT NULL
GROUP BY c.CLICODIGO, c.CLINOMEFANT
ORDER BY TOTAL_ARQUIVOS_DELETADOS DESC;
```

---

### 4. Análise de Pedidos com Arquivos Deletados

**Objetivo:** Identificar pedidos que possuem arquivos deletados.

**Query SQL:**
```sql
SELECT
    p.PEDCODIGO,
    p.PEDDATA AS DATA_PEDIDO,
    c.CLINOMEFANT AS CLIENTE,
    COUNT(*) AS TOTAL_ARQUIVOS_DELETADOS
FROM DELARQCM del
INNER JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
GROUP BY p.PEDCODIGO, p.PEDDATA, c.CLINOMEFANT
ORDER BY TOTAL_ARQUIVOS_DELETADOS DESC;
```

---

### 5. Análise de Arquivos Deletados Órfãos

**Objetivo:** Identificar registros de deleção sem pedido válido.

**Query SQL:**
```sql
SELECT
    del.ID_DELARQCM,
    del.ID_PEDIDO
FROM DELARQCM del
LEFT JOIN PEDID p ON p.PEDCODIGO = del.ID_PEDIDO
WHERE p.PEDCODIGO IS NULL
ORDER BY del.ID_DELARQCM;
```

---

### 6. Relatório Completo de Arquivos Deletados

**Objetivo:** Analisar distribuição completa de arquivos deletados no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_ARQUIVOS_DELETADOS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(CASE WHEN ID_PEDIDO IS NULL THEN 1 END) AS ARQUIVOS_ORFAOS,
    COUNT(CASE WHEN ID_PEDIDO IS NOT NULL THEN 1 END) AS ARQUIVOS_COM_PEDIDO
FROM DELARQCM;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DELARQCM | Tipo |
|--------|-----------|----------------------|------|
| **DELARQCM** | 28.305 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | ~? | ?:1 | Pedidos (relacionamento lógico) |

**Interpretação:**
- **28.305 arquivos deletados** registrados no sistema
- **Tabela de auditoria** - mantém histórico de deleções

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por pedido (consultas frequentes)
CREATE INDEX IDX_DELARQCM_PEDIDO ON DELARQCM(ID_PEDIDO)
    WHERE ID_PEDIDO IS NOT NULL;

-- Índice 2: Busca por ID (já coberto pela PK)
-- A PK já fornece índice eficiente
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdDelarqcm extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DELARQCM';
    
    protected $primaryKey = 'ID_DELARQCM';
    public $incrementing = true;

    protected $casts = [
        'ID_DELARQCM' => 'integer',
        'ID_PEDIDO' => 'integer',
    ];

    // Relacionamento lógico com PEDID
    public function pedido()
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'PEDCODIGO');
    }

    public function scopePorPedido($query, int $pedidoCodigo)
    {
        return $query->where('ID_PEDIDO', $pedidoCodigo);
    }

    public function scopeComPedido($query)
    {
        return $query->whereNotNull('ID_PEDIDO');
    }

    public function scopeOrfaos($query)
    {
        return $query->whereNull('ID_PEDIDO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

