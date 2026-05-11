# BXMANUALCELETQ - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: BXMANUALCELETQ (Baixas Manuais de Células/Estoque)
- **Total de Registros**: 227.380
- **Total de Colunas**: 7
- **Chave Primária**: BMCESEQ
- **Chaves Estrangeiras**: 0 (relacionamentos lógicos)
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela de auditoria/ajustes)
- **Banco de Dados**: Firebird

## 📝 Descrição

**BXMANUALCELETQ** é uma tabela de auditoria e controle que registra baixas manuais de estoque relacionadas a pedidos e produtos. Com **227.380 registros**, representa ajustes manuais realizados no sistema de produção/estoque.

Esta tabela funciona como **log de ajustes manuais** e permite:
- Registrar baixas manuais de estoque por pedido e produto
- Rastrear quem realizou cada ajuste (usuário)
- Identificar a operação relacionada (BMCEOPC)
- Manter histórico de observações sobre os ajustes
- Controlar data e hora de cada baixa manual

Cada registro representa uma baixa manual específica, contendo:
- Sequência única da baixa (BMCESEQ)
- Pedido relacionado (BMCEID_PEDIDO)
- Produto ajustado (BMCEPROCODIGO)
- Operação relacionada (BMCEOPC)
- Data da baixa (BMCEDTBAIXA)
- Usuário responsável (BMCEUSUCODIGO)
- Observações (BMCEOBS)

O sistema utiliza esta tabela para manter rastreabilidade completa de ajustes manuais de estoque, permitindo auditoria e controle de alterações não automáticas no sistema.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BMCESEQ** 🔑 | INTEGER | Sequência única da baixa manual (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BMCEID_PEDIDO** | INTEGER | ID do pedido relacionado (lógico → PEDID) |
| **BMCEPROCODIGO** | VARCHAR(37) | Código do produto ajustado (lógico → PRODU) |
| **BMCEUSUCODIGO** | INTEGER | Código do usuário que realizou a baixa (lógico → USUARIO) |

### Dados da Operação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BMCEOPC** | VARCHAR(37) | Código da operação relacionada à baixa |
| **BMCEDTBAIXA** | DATE | Data e hora da baixa manual |
| **BMCEOBS** | VARCHAR(37) | Observações sobre a baixa manual |

---

## 🔗 Relacionamentos - Nível 1 (Diretos - Lógicos)

BXMANUALCELETQ **não possui chaves estrangeiras formais**, mas possui relacionamentos lógicos através de campos de identificação:

### BMCEID_PEDIDO → PEDID (Lógico)
**Fluxo:** BXMANUALCELETQ → PEDID

**Descrição:** O campo BMCEID_PEDIDO referencia logicamente a tabela PEDID, permitindo identificar o pedido relacionado a cada baixa manual.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEID_PEDIDO` → `PEDID.ID_PEDIDO` (junção lógica)

**Uso:** Obter informações completas do pedido relacionado à baixa manual.

---

### BMCEPROCODIGO → PRODU (Lógico)
**Fluxo:** BXMANUALCELETQ → PRODU

**Descrição:** O campo BMCEPROCODIGO referencia logicamente a tabela PRODU, permitindo identificar o produto ajustado em cada baixa manual.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEPROCODIGO` → `PRODU.PROCODIGO` (junção lógica)

**Uso:** Obter informações completas do produto relacionado à baixa manual.

---

### BMCEUSUCODIGO → USUARIO (Lógico)
**Fluxo:** BXMANUALCELETQ → USUARIO

**Descrição:** O campo BMCEUSUCODIGO referencia logicamente a tabela USUARIO, permitindo identificar quem realizou cada baixa manual.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEUSUCODIGO` → `USUARIO.USUCODIGO` (junção lógica)

**Uso:** Auditoria e rastreabilidade de quem realizou cada ajuste manual.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PEDID

#### PEDID → CLIEN (Cliente)
**Fluxo:** BXMANUALCELETQ → PEDID → CLIEN

**Descrição:** Através do relacionamento lógico com PEDID, é possível identificar o cliente relacionado a cada baixa manual.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEID_PEDIDO` → `PEDID.ID_PEDIDO` → `PEDID.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de baixas manuais por cliente.

---

#### PEDID → EMPRESA
**Fluxo:** BXMANUALCELETQ → PEDID → EMPRESA

**Descrição:** Através do relacionamento lógico com PEDID, é possível identificar a empresa relacionada a cada baixa manual.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEID_PEDIDO` → `PEDID.ID_PEDIDO` → `PEDID.EMPCODIGO` → `EMPRESA.EMPCODIGO`

**Uso:** Análises de baixas manuais por empresa/filial.

---

### Via PRODU

#### PRODU → MARCA (Marca do Produto)
**Fluxo:** BXMANUALCELETQ → PRODU → MARCA

**Descrição:** Através do relacionamento lógico com PRODU, é possível identificar a marca do produto ajustado.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEPROCODIGO` → `PRODU.PROCODIGO` → `PRODU.MARCODIGO` → `MARCA.MARCODIGO`

**Uso:** Análises de baixas manuais por marca de produto.

---

### Via USUARIO

#### USUARIO → FUNCIO (Funcionário)
**Fluxo:** BXMANUALCELETQ → USUARIO → FUNCIO

**Descrição:** Através do relacionamento lógico com USUARIO, é possível identificar o funcionário que realizou a baixa.

**Campos de junção:**
- `BXMANUALCELETQ.BMCEUSUCODIGO` → `USUARIO.USUCODIGO` → `USUARIO.FUNCODIGO` → `FUNCIO.FUNCODIGO`

**Uso:** Análises de baixas manuais por funcionário.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Baixa Manual

**Objetivo:** Obter visão completa de uma baixa manual incluindo informações do pedido, produto, cliente e usuário.

**Fluxo:**
```
BXMANUALCELETQ (BMCESEQ, BMCEID_PEDIDO, BMCEPROCODIGO, BMCEUSUCODIGO)
  ↓
PEDID (ID_PEDIDO)
  ↓
CLIEN (CLICODIGO)
  ↓
PRODU (PROCODIGO)
  ↓
USUARIO (USUCODIGO)
  ↓
FUNCIO (FUNCODIGO)
```

**Query SQL:**
```sql
SELECT
    bx.BMCESEQ,
    bx.BMCEDTBAIXA AS DATA_BAIXA,
    bx.BMCEOPC AS OPERACAO,
    bx.BMCEOBS AS OBSERVACOES,
    p.PEDCODIGO AS NUM_PEDIDO,
    p.PEDDTEMIS AS DATA_PEDIDO,
    c.CLINOME AS CLIENTE,
    pr.PRODESCRICAO AS PRODUTO,
    u.USUNOME AS USUARIO,
    fu.FUNDESCRICAO AS FUNCAO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BXMANUALCELETQ bx
LEFT JOIN PEDID p ON p.ID_PEDIDO = bx.BMCEID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
LEFT JOIN PRODU pr ON pr.PROCODIGO = bx.BMCEPROCODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = bx.BMCEUSUCODIGO
LEFT JOIN FUNCIO fu ON fu.FUNCODIGO = u.FUNCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = p.EMPCODIGO
WHERE bx.BMCESEQ = ?;
```

---

### Exemplo 2: Análise de Baixas Manuais por Produto

**Objetivo:** Identificar quais produtos têm mais baixas manuais e analisar padrões.

**Fluxo:**
```
PRODU (PROCODIGO)
  ↓
BXMANUALCELETQ (BMCEPROCODIGO)
  ↓
PEDID (ID_PEDIDO)
```

**Query SQL:**
```sql
SELECT
    pr.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    COUNT(bx.BMCESEQ) AS TOTAL_BAIXAS_MANUAIS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT bx.BMCEUSUCODIGO) AS TOTAL_USUARIOS_DIFERENTES,
    MIN(bx.BMCEDTBAIXA) AS PRIMEIRA_BAIXA,
    MAX(bx.BMCEDTBAIXA) AS ULTIMA_BAIXA,
    STRING_AGG(DISTINCT bx.BMCEOPC, ', ') AS OPERACOES_UTILIZADAS
FROM PRODU pr
INNER JOIN BXMANUALCELETQ bx ON bx.BMCEPROCODIGO = pr.PROCODIGO
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY pr.PROCODIGO, pr.PRODESCRICAO
HAVING COUNT(bx.BMCESEQ) > 0
ORDER BY TOTAL_BAIXAS_MANUAIS DESC;
```

---

### Exemplo 3: Análise de Baixas Manuais por Usuário e Período

**Objetivo:** Identificar padrões de uso de baixas manuais por usuário para auditoria.

**Fluxo:**
```
USUARIO (USUCODIGO)
  ↓
BXMANUALCELETQ (BMCEUSUCODIGO)
  ↓
FUNCIO (FUNCODIGO)
```

**Query SQL:**
```sql
SELECT
    u.USUCODIGO,
    u.USUNOME AS USUARIO,
    fu.FUNDESCRICAO AS FUNCAO,
    COUNT(bx.BMCESEQ) AS TOTAL_BAIXAS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT bx.BMCEPROCODIGO) AS TOTAL_PRODUTOS_DIFERENTES,
    MIN(bx.BMCEDTBAIXA) AS PRIMEIRA_BAIXA,
    MAX(bx.BMCEDTBAIXA) AS ULTIMA_BAIXA,
    ROUND(COUNT(bx.BMCESEQ) * 1.0 / NULLIF(COUNT(DISTINCT DATE(bx.BMCEDTBAIXA)), 0), 2) AS MEDIA_BAIXAS_POR_DIA
FROM USUARIO u
INNER JOIN BXMANUALCELETQ bx ON bx.BMCEUSUCODIGO = u.USUCODIGO
LEFT JOIN FUNCIO fu ON fu.FUNCODIGO = u.FUNCODIGO
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY u.USUCODIGO, u.USUNOME, fu.FUNDESCRICAO
ORDER BY TOTAL_BAIXAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Baixas Manuais por Pedido

**Objetivo:** Visualizar todas as baixas manuais relacionadas a um pedido específico.

```sql
SELECT
    bx.BMCESEQ,
    bx.BMCEDTBAIXA AS DATA_BAIXA,
    bx.BMCEPROCODIGO AS PRODUTO,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    bx.BMCEOPC AS OPERACAO,
    bx.BMCEOBS AS OBSERVACOES,
    u.USUNOME AS USUARIO
FROM BXMANUALCELETQ bx
LEFT JOIN PRODU pr ON pr.PROCODIGO = bx.BMCEPROCODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = bx.BMCEUSUCODIGO
WHERE bx.BMCEID_PEDIDO = ?
ORDER BY bx.BMCEDTBAIXA DESC;
```

---

### 2. Buscar Baixa Manual Específica

**Objetivo:** Obter detalhes completos de uma baixa manual específica.

```sql
SELECT
    bx.*,
    p.PEDCODIGO AS NUM_PEDIDO,
    pr.PRODESCRICAO AS PRODUTO,
    u.USUNOME AS USUARIO,
    c.CLINOME AS CLIENTE
FROM BXMANUALCELETQ bx
LEFT JOIN PEDID p ON p.ID_PEDIDO = bx.BMCEID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
LEFT JOIN PRODU pr ON pr.PROCODIGO = bx.BMCEPROCODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = bx.BMCEUSUCODIGO
WHERE bx.BMCESEQ = ?;
```

---

### 3. Análise de Baixas Manuais por Operação

**Objetivo:** Identificar quais operações geram mais baixas manuais.

```sql
SELECT
    bx.BMCEOPC AS OPERACAO,
    COUNT(*) AS TOTAL_BAIXAS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT bx.BMCEPROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT bx.BMCEUSUCODIGO) AS TOTAL_USUARIOS,
    MIN(bx.BMCEDTBAIXA) AS PRIMEIRA_OCORRENCIA,
    MAX(bx.BMCEDTBAIXA) AS ULTIMA_OCORRENCIA
FROM BXMANUALCELETQ bx
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY bx.BMCEOPC
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 4. Relatório de Baixas Manuais por Período

**Objetivo:** Gerar relatório consolidado de baixas manuais em um período.

```sql
SELECT
    DATE(bx.BMCEDTBAIXA) AS DATA,
    COUNT(*) AS TOTAL_BAIXAS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT bx.BMCEPROCODIGO) AS TOTAL_PRODUTOS_DIFERENTES,
    COUNT(DISTINCT bx.BMCEUSUCODIGO) AS TOTAL_USUARIOS_DIFERENTES,
    COUNT(DISTINCT bx.BMCEOPC) AS TOTAL_OPERACOES_DIFERENTES
FROM BXMANUALCELETQ bx
WHERE bx.BMCEDTBAIXA BETWEEN ? AND ?
GROUP BY DATE(bx.BMCEDTBAIXA)
ORDER BY DATA DESC;
```

---

### 5. Verificar Baixas Manuais por Produto

**Objetivo:** Identificar produtos com maior frequência de baixas manuais.

```sql
SELECT
    pr.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    COUNT(bx.BMCESEQ) AS TOTAL_BAIXAS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS,
    STRING_AGG(DISTINCT bx.BMCEOPC, ', ') AS OPERACOES
FROM PRODU pr
INNER JOIN BXMANUALCELETQ bx ON bx.BMCEPROCODIGO = pr.PROCODIGO
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY pr.PROCODIGO, pr.PRODESCRICAO
HAVING COUNT(bx.BMCESEQ) > 10
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 6. Análise de Baixas Manuais por Cliente

**Objetivo:** Identificar clientes cujos pedidos têm mais baixas manuais.

```sql
SELECT
    c.CLICODIGO,
    c.CLINOME AS CLIENTE,
    COUNT(bx.BMCESEQ) AS TOTAL_BAIXAS,
    COUNT(DISTINCT bx.BMCEID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT bx.BMCEPROCODIGO) AS TOTAL_PRODUTOS_DIFERENTES,
    MIN(bx.BMCEDTBAIXA) AS PRIMEIRA_BAIXA,
    MAX(bx.BMCEDTBAIXA) AS ULTIMA_BAIXA
FROM CLIEN c
INNER JOIN PEDID p ON p.CLICODIGO = c.CLICODIGO
INNER JOIN BXMANUALCELETQ bx ON bx.BMCEID_PEDIDO = p.ID_PEDIDO
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.CLICODIGO, c.CLINOME
HAVING COUNT(bx.BMCESEQ) > 0
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 7. Auditoria de Baixas Manuais Recentes

**Objetivo:** Listar todas as baixas manuais recentes para auditoria.

```sql
SELECT
    bx.BMCESEQ,
    bx.BMCEDTBAIXA AS DATA_BAIXA,
    p.PEDCODIGO AS NUM_PEDIDO,
    pr.PRODESCRICAO AS PRODUTO,
    bx.BMCEOPC AS OPERACAO,
    u.USUNOME AS USUARIO,
    fu.FUNDESCRICAO AS FUNCAO,
    bx.BMCEOBS AS OBSERVACOES,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BXMANUALCELETQ bx
LEFT JOIN PEDID p ON p.ID_PEDIDO = bx.BMCEID_PEDIDO
LEFT JOIN PRODU pr ON pr.PROCODIGO = bx.BMCEPROCODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = bx.BMCEUSUCODIGO
LEFT JOIN FUNCIO fu ON fu.FUNCODIGO = u.FUNCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = p.EMPCODIGO
WHERE bx.BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY bx.BMCEDTBAIXA DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com BXMANUALCELETQ | Tipo |
|--------|-----------|------------------------------|------|
| **BXMANUALCELETQ** | 227.380 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | 3.099.176 | 13.6:1 | Pedidos (média de 0.07 baixas por pedido) |
| PRODU | 178.187 | 1.28:1 | Produtos (média de 1.28 baixas por produto) |
| USUARIO | 297 | 765:1 | Usuários (média de 765 baixas por usuário) |

**Interpretação:**
- Cada pedido possui em média **0.07 baixas manuais** (baixa frequência)
- Cada produto possui em média **1.28 baixas manuais** (alguns produtos têm múltiplas baixas)
- Cada usuário realizou em média **765 baixas manuais** (alta concentração)
- Tabela de auditoria com volume significativo

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **BMCESEQ** | BXMANUALCELETQ | Identificador único (PK) |
| **BMCEID_PEDIDO** | BXMANUALCELETQ → PEDID | Referência lógica ao pedido |
| **BMCEPROCODIGO** | BXMANUALCELETQ → PRODU | Referência lógica ao produto |
| **BMCEUSUCODIGO** | BXMANUALCELETQ → USUARIO | Referência lógica ao usuário |
| **BMCEDTBAIXA** | BXMANUALCELETQ | Data da baixa (filtro temporal) |
| **BMCEOPC** | BXMANUALCELETQ | Código da operação (agrupamento) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela BXMANUALCELETQ.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice em BMCEID_PEDIDO** - Para buscas por pedido
3. **Índice em BMCEPROCODIGO** - Para buscas por produto
4. **Índice em BMCEDTBAIXA** - Para filtros temporais
5. **Índice em BMCEUSUCODIGO** - Para auditoria por usuário
6. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por pedido (consultas frequentes)
CREATE INDEX IDX_BXMANUALCELETQ_PEDIDO ON BXMANUALCELETQ(BMCEID_PEDIDO);

-- Índice 2: Busca por produto
CREATE INDEX IDX_BXMANUALCELETQ_PRODUTO ON BXMANUALCELETQ(BMCEPROCODIGO);

-- Índice 3: Busca por data (filtros temporais)
CREATE INDEX IDX_BXMANUALCELETQ_DATA ON BXMANUALCELETQ(BMCEDTBAIXA);

-- Índice 4: Busca por usuário (auditoria)
CREATE INDEX IDX_BXMANUALCELETQ_USUARIO ON BXMANUALCELETQ(BMCEUSUCODIGO);

-- Índice 5: Busca composta pedido + data
CREATE INDEX IDX_BXMANUALCELETQ_PEDIDO_DATA ON BXMANUALCELETQ(BMCEID_PEDIDO, BMCEDTBAIXA);

-- Índice 6: Busca composta produto + data
CREATE INDEX IDX_BXMANUALCELETQ_PRODUTO_DATA ON BXMANUALCELETQ(BMCEPROCODIGO, BMCEDTBAIXA);
```

### Observações sobre Volume

- **Tabela média-grande** (227K registros) - Performance pode ser crítica em consultas sem filtros
- **Consultas com JOINs** podem ser lentas - sempre usar filtros adequados
- **Focar em filtros temporais** - Sempre usar BMCEDTBAIXA para limitar resultados
- **Considerar particionamento** - Por data se volume crescer significativamente

### Exemplo de Query Otimizada

```sql
-- ❌ NÃO OTIMIZADO (table scan completo)
SELECT * FROM BXMANUALCELETQ WHERE BMCEID_PEDIDO = 3362598;

-- ✅ OTIMIZADO (usa índice e limita período)
SELECT
    BMCESEQ, BMCEPROCODIGO, BMCEOPC, BMCEDTBAIXA, BMCEOBS
FROM BXMANUALCELETQ
WHERE BMCEID_PEDIDO = 3362598
  AND BMCEDTBAIXA >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY BMCEDTBAIXA DESC;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial Lógica

```sql
-- Verificar baixas sem pedido válido
SELECT bx.*
FROM BXMANUALCELETQ bx
LEFT JOIN PEDID p ON p.ID_PEDIDO = bx.BMCEID_PEDIDO
WHERE p.ID_PEDIDO IS NULL;

-- Verificar baixas sem produto válido
SELECT bx.*
FROM BXMANUALCELETQ bx
LEFT JOIN PRODU pr ON pr.PROCODIGO = bx.BMCEPROCODIGO
WHERE pr.PROCODIGO IS NULL;

-- Verificar baixas sem usuário válido
SELECT bx.*
FROM BXMANUALCELETQ bx
LEFT JOIN USUARIO u ON u.USUCODIGO = bx.BMCEUSUCODIGO
WHERE u.USUCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM BXMANUALCELETQ
WHERE BMCESEQ IS NULL
   OR BMCEID_PEDIDO IS NULL
   OR BMCEPROCODIGO IS NULL
   OR BMCEOPC IS NULL
   OR BMCEDTBAIXA IS NULL
   OR BMCEUSUCODIGO IS NULL;

-- Verificar datas futuras (inconsistência)
SELECT *
FROM BXMANUALCELETQ
WHERE BMCEDTBAIXA > CURRENT_TIMESTAMP;

-- Verificar datas muito antigas (possível inconsistência)
SELECT *
FROM BXMANUALCELETQ
WHERE BMCEDTBAIXA < DATE '2000-01-01';
```

### Verificar Padrões de Uso

```sql
-- Verificar operações mais utilizadas
SELECT BMCEOPC, COUNT(*) AS QTD, COUNT(DISTINCT BMCEID_PEDIDO) AS PEDIDOS
FROM BXMANUALCELETQ
GROUP BY BMCEOPC
ORDER BY QTD DESC;

-- Verificar usuários com mais baixas
SELECT BMCEUSUCODIGO, COUNT(*) AS QTD
FROM BXMANUALCELETQ
GROUP BY BMCEUSUCODIGO
ORDER BY QTD DESC;
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

final class FirebirdBxManualCeletq extends Model
{
    protected $connection = 'firebird';
    protected $table = 'BXMANUALCELETQ';
    protected $primaryKey = 'BMCESEQ';

    protected $casts = [
        'BMCESEQ' => 'integer',
        'BMCEID_PEDIDO' => 'integer',
        'BMCEPROCODIGO' => 'string',
        'BMCEOPC' => 'string',
        'BMCEDTBAIXA' => 'datetime',
        'BMCEUSUCODIGO' => 'integer',
        'BMCEOBS' => 'string',
    ];

    // Relacionamento com PEDID (lógico)
    public function pedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdPedido::class, 'BMCEID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento com PRODU (lógico)
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'BMCEPROCODIGO', 'PROCODIGO');
    }

    // Relacionamento com USUARIO (lógico)
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(FirebirdUsuario::class, 'BMCEUSUCODIGO', 'USUCODIGO');
    }

    // Scope para filtrar por pedido
    public function scopePorPedido($query, int $pedidoId)
    {
        return $query->where('BMCEID_PEDIDO', $pedidoId);
    }

    // Scope para filtrar por produto
    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('BMCEPROCODIGO', $produtoCodigo);
    }

    // Scope para filtrar por usuário
    public function scopePorUsuario($query, int $usuarioCodigo)
    {
        return $query->where('BMCEUSUCODIGO', $usuarioCodigo);
    }

    // Scope para filtrar por operação
    public function scopePorOperacao($query, string $operacao)
    {
        return $query->where('BMCEOPC', $operacao);
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, $dataInicio, $dataFim)
    {
        return $query->whereBetween('BMCEDTBAIXA', [$dataInicio, $dataFim]);
    }

    // Scope para baixas recentes
    public function scopeRecentes($query, int $dias = 30)
    {
        return $query->where('BMCEDTBAIXA', '>=', now()->subDays($dias));
    }

    // Método para verificar se tem observações
    public function temObservacoes(): bool
    {
        return !empty($this->BMCEOBS);
    }

    // Método para calcular dias desde a baixa
    public function diasDesdeBaixa(): int
    {
        return $this->BMCEDTBAIXA->diffInDays(now());
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Manter rastreabilidade** - Todos os campos obrigatórios devem ser preenchidos
2. **Observações claras** - BMCEOBS deve explicar o motivo da baixa manual
3. **Operação específica** - BMCEOPC deve identificar claramente o tipo de operação
4. **Data precisa** - BMCEDTBAIXA deve refletir momento exato da baixa

### Performance

1. **Sempre filtrar por data** - Usar BMCEDTBAIXA para limitar resultados
2. **Usar índices** - Criar índices nos campos de busca frequente
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Considerar cache** - Para relatórios de auditoria frequentes

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se pedido, produto e usuário existem
2. **Verificar duplicatas** - Evitar múltiplas baixas idênticas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Auditoria** - Registrar todas as alterações nesta tabela

### Manutenção

1. **Revisão periódica** - Verificar padrões de uso de baixas manuais
2. **Arquivamento** - Considerar arquivar registros antigos (> 5 anos)
3. **Backup regular** - Tabela crítica para auditoria
4. **Monitoramento** - Acompanhar frequência de baixas manuais

### Regras de Negócio

1. **Tabela de auditoria** - Não deve ser modificada após inserção
2. **Rastreabilidade** - Todo ajuste manual deve ser registrado aqui
3. **Observações obrigatórias** - BMCEOBS deve explicar motivo da baixa
4. **Aprovação** - Baixas manuais podem requerer aprovação antes de processar

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

