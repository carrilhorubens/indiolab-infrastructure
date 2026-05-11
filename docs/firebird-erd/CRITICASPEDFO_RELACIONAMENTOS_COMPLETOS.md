# CRITICASPEDFO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CRITICASPEDFO (Críticas de Pedidos de Compra)
- **Total de Registros**: 772.777
- **Total de Colunas**: 11
- **Chave Primária**: Composta (ID_PEDIDO, CPFSEQ)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CRITICASPEDFO** é uma tabela que armazena críticas, observações e problemas identificados em pedidos de compra (PEDFO). Com **772.777 registros**, representa histórico extensivo de críticas registradas sobre pedidos de compra, permitindo controle completo de qualidade e rastreabilidade de problemas.

Esta tabela funciona como **sistema de gestão de críticas de pedidos de compra** e permite:
- Registrar críticas identificadas em pedidos de compra
- Controlar datas de lançamento e situação das críticas
- Classificar críticas por tipo
- Rastrear origem e confirmação das críticas
- Controlar situação e resolução das críticas
- Associar críticas a referências específicas
- Suportar múltiplas críticas por pedido

Cada registro representa uma crítica específica identificada em um pedido de compra, contendo:
- Pedido de compra relacionado (ID_PEDIDO)
- Sequência da crítica (CPFSEQ)
- Descrição da crítica (CPFDESCRICAO)
- Data de lançamento (CPFDATALANCAMENTO)
- Situação da crítica (CPFSITUACAO)
- Data da situação (CPFDATASITUACAO)
- Referência relacionada (CPFREF)
- Origem da referência (CPFORIGEMREF)
- Tipo da crítica (CPFTIPO)
- Origem da confirmação (CPFORIGEMCONF)
- Tipo de crítica (TPCCODIGO)

O sistema utiliza esta tabela para gerenciar todas as críticas identificadas em pedidos de compra, permitindo controle de qualidade completo e rastreabilidade de problemas.

**Observação Importante:** CRITICASPEDFO é uma tabela grande (772.777 registros) do sistema de gestão de pedidos de compra, sendo essencial para controle de qualidade e identificação de problemas. Com chave primária composta (ID_PEDIDO, CPFSEQ), permite múltiplas críticas por pedido.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PEDIDO** 🔑 🔗 | INTEGER | ✓ | Código do pedido de compra (FK → PEDFO) |
| **CPFSEQ** 🔑 | SMALLINT | ✓ | Sequência da crítica no pedido |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPCCODIGO** 🔗 | SMALLINT | | Código do tipo de crítica (FK → TPCRITICA) |

### Informações da Crítica
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPFDESCRICAO** | VARCHAR(37) | ✓ | Descrição da crítica |
| **CPFDATALANCAMENTO** | DATE | ✓ | Data de lançamento da crítica |
| **CPFSITUACAO** | VARCHAR(14) | | Situação da crítica |
| **CPFDATASITUACAO** | DATE | | Data da situação |
| **CPFREF** | VARCHAR(14) | | Referência relacionada |
| **CPFORIGEMREF** | VARCHAR(14) | | Origem da referência |
| **CPFTIPO** | VARCHAR(7) | | Tipo da crítica |
| **CPFORIGEMCONF** | VARCHAR(14) | | Origem da confirmação |

**Primary Key:** (ID_PEDIDO, CPFSEQ)

**Observações sobre Campos:**
- **ID_PEDIDO**: Identificador do pedido de compra ao qual a crítica se refere.
- **CPFSEQ**: Sequência numérica que identifica unicamente cada crítica dentro de um pedido.
- **CPFDESCRICAO**: Descrição textual da crítica identificada.
- **CPFDATALANCAMENTO**: Data em que a crítica foi registrada.
- **CPFSITUACAO**: Situação atual da crítica (ex: "PENDENTE", "RESOLVIDA", "CANCELADA").
- **CPFDATASITUACAO**: Data em que a situação foi alterada.
- **CPFREF**: Referência relacionada à crítica.
- **CPFORIGEMREF**: Origem da referência.
- **CPFTIPO**: Tipo específico da crítica.
- **CPFORIGEMCONF**: Origem da confirmação da crítica.
- **TPCCODIGO**: Tipo de crítica conforme cadastro em TPCRITICA.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CRITICASPEDFO Referencia (2 FKs):

#### 1. PEDFO - Pedidos de Compra
**Relacionamento:**
```
CRITICASPEDFO.ID_PEDIDO → PEDFO.ID_PEDIDO (N:1)
Constraint: FK_CRITICASPEDFO_PEDFO
```

**Descrição**: Cada crítica está vinculada a um pedido de compra específico.

**Informações da Tabela PEDFO:**
- **Total:** 129.753 pedidos de compra
- **PK:** ID_PEDIDO
- **Colunas:** 190 campos

**Uso:** Identificar o pedido de compra relacionado, obter informações do pedido.

**Proporção:** ~6 críticas por pedido em média (772.777 / 129.753)

---

#### 2. TPCRITICA - Tipos de Crítica
**Relacionamento:**
```
CRITICASPEDFO.TPCCODIGO → TPCRITICA.TPCCODIGO (N:1)
Constraint: FK_CRITICASPEDFO_TPCRITICA
```

**Descrição**: Cada crítica pode estar classificada por um tipo específico.

**Informações da Tabela TPCRITICA:**
- **Total:** 13 tipos de crítica
- **PK:** TPCCODIGO
- **Colunas:** 3 campos (TPCCODIGO, TPCDESCRICAO, TPCTIPO)

**Uso:** Classificar e categorizar críticas, facilitar análises e relatórios.

---

### CRITICASPEDFO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CRITICASPEDFO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ID_PEDIDO → PEDFO → Fornecedores e Outras Operações

**Fluxo:** CRITICASPEDFO → PEDFO → FORNE

**Descrição:** Através do pedido de compra, é possível identificar o fornecedor relacionado.

**Uso:** Análise de críticas por fornecedor.

---

### Via ID_PEDIDO → PEDFO → Itens do Pedido

**Fluxo:** CRITICASPEDFO → PEDFO → ITENSPEDFO

**Descrição:** Através do pedido de compra, é possível identificar os itens relacionados.

**Uso:** Análise de críticas por item do pedido.

---

### Via TPCCODIGO → TPCRITICA → Classificação

**Fluxo:** CRITICASPEDFO → TPCRITICA → Classificação

**Descrição:** Através do tipo de crítica, é possível identificar a classificação e tipo da crítica.

**Uso:** Análise de críticas por tipo.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Críticas de um Pedido

**Objetivo:** Obter visão completa de todas as críticas de um pedido incluindo informações do pedido e tipo de crítica.

**Fluxo:**
```
CRITICASPEDFO (ID_PEDIDO, CPFSEQ, CPFDESCRICAO)
  ↓
PEDFO (ID_PEDIDO)
  ↓
FORNE (FORCODIGO)
  ↓
TPCRITICA (TPCCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.ID_PEDIDO,
    pf.PEFCODIGO AS CODIGO_PEDIDO,
    pf.PEFDTEMIS AS DATA_PEDIDO,
    fo.FORNOMEFANT AS FORNECEDOR,
    cp.CPFSEQ AS SEQUENCIA,
    cp.CPFDESCRICAO AS DESCRICAO_CRITICA,
    cp.CPFDATALANCAMENTO AS DATA_LANCAMENTO,
    cp.CPFSITUACAO AS SITUACAO,
    cp.CPFDATASITUACAO AS DATA_SITUACAO,
    tc.TPCDESCRICAO AS TIPO_CRITICA,
    tc.TPCTIPO AS CATEGORIA_TIPO
FROM CRITICASPEDFO cp
INNER JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
LEFT JOIN FORNE fo ON fo.FORCODIGO = pf.FORCODIGO
LEFT JOIN TPCRITICA tc ON tc.TPCCODIGO = cp.TPCCODIGO
WHERE cp.ID_PEDIDO = ?
ORDER BY cp.CPFSEQ;
```

---

### Exemplo 2: Análise de Críticas por Fornecedor

**Objetivo:** Obter todas as críticas relacionadas a pedidos de um fornecedor específico.

**Query SQL:**
```sql
SELECT
    cp.ID_PEDIDO,
    pf.PEFCODIGO AS CODIGO_PEDIDO,
    cp.CPFSEQ AS SEQUENCIA,
    cp.CPFDESCRICAO AS DESCRICAO_CRITICA,
    cp.CPFDATALANCAMENTO AS DATA_LANCAMENTO,
    cp.CPFSITUACAO AS SITUACAO,
    tc.TPCDESCRICAO AS TIPO_CRITICA
FROM CRITICASPEDFO cp
INNER JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
INNER JOIN FORNE fo ON fo.FORCODIGO = pf.FORCODIGO
LEFT JOIN TPCRITICA tc ON tc.TPCCODIGO = cp.TPCCODIGO
WHERE pf.FORCODIGO = ?
ORDER BY cp.CPFDATALANCAMENTO DESC, cp.CPFSEQ;
```

---

### Exemplo 3: Análise de Críticas por Tipo

**Objetivo:** Obter críticas agrupadas por tipo de crítica.

**Query SQL:**
```sql
SELECT
    tc.TPCCODIGO,
    tc.TPCDESCRICAO AS TIPO_CRITICA,
    tc.TPCTIPO AS CATEGORIA,
    COUNT(*) AS TOTAL_CRITICAS,
    COUNT(DISTINCT cp.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'PENDENTE' THEN 1 END) AS CRITICAS_PENDENTES,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'RESOLVIDA' THEN 1 END) AS CRITICAS_RESOLVIDAS
FROM CRITICASPEDFO cp
LEFT JOIN TPCRITICA tc ON tc.TPCCODIGO = cp.TPCCODIGO
GROUP BY tc.TPCCODIGO, tc.TPCDESCRICAO, tc.TPCTIPO
ORDER BY TOTAL_CRITICAS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Críticas de um Pedido

**Objetivo:** Obter todas as críticas de um pedido de compra específico.

```sql
SELECT
    CPFSEQ AS SEQUENCIA,
    CPFDESCRICAO AS DESCRICAO,
    CPFDATALANCAMENTO AS DATA_LANCAMENTO,
    CPFSITUACAO AS SITUACAO,
    CPFDATASITUACAO AS DATA_SITUACAO,
    TPCCODIGO AS TIPO_CRITICA
FROM CRITICASPEDFO
WHERE ID_PEDIDO = ?
ORDER BY CPFSEQ;
```

---

### 2. Listar Críticas Pendentes

**Objetivo:** Obter todas as críticas pendentes de resolução.

```sql
SELECT
    cp.ID_PEDIDO,
    pf.PEFCODIGO AS CODIGO_PEDIDO,
    cp.CPFSEQ AS SEQUENCIA,
    cp.CPFDESCRICAO AS DESCRICAO,
    cp.CPFDATALANCAMENTO AS DATA_LANCAMENTO,
    DATEDIFF(DAY, cp.CPFDATALANCAMENTO, CURRENT_DATE) AS DIAS_PENDENTE
FROM CRITICASPEDFO cp
INNER JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
WHERE cp.CPFSITUACAO = 'PENDENTE'
   OR cp.CPFSITUACAO IS NULL
ORDER BY cp.CPFDATALANCAMENTO;
```

---

### 3. Análise de Críticas por Período

**Objetivo:** Obter críticas lançadas em um período específico.

```sql
SELECT
    cp.ID_PEDIDO,
    pf.PEFCODIGO AS CODIGO_PEDIDO,
    cp.CPFSEQ AS SEQUENCIA,
    cp.CPFDESCRICAO AS DESCRICAO,
    cp.CPFDATALANCAMENTO AS DATA_LANCAMENTO,
    cp.CPFSITUACAO AS SITUACAO,
    tc.TPCDESCRICAO AS TIPO_CRITICA
FROM CRITICASPEDFO cp
INNER JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
LEFT JOIN TPCRITICA tc ON tc.TPCCODIGO = cp.TPCCODIGO
WHERE cp.CPFDATALANCAMENTO >= ?
  AND cp.CPFDATALANCAMENTO <= ?
ORDER BY cp.CPFDATALANCAMENTO DESC, cp.CPFSEQ;
```

---

### 4. Análise de Críticas por Situação

**Objetivo:** Identificar distribuição de críticas por situação.

```sql
SELECT
    CPFSITUACAO AS SITUACAO,
    COUNT(*) AS TOTAL_CRITICAS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    MIN(CPFDATALANCAMENTO) AS PRIMEIRA_CRITICA,
    MAX(CPFDATALANCAMENTO) AS ULTIMA_CRITICA
FROM CRITICASPEDFO
GROUP BY CPFSITUACAO
ORDER BY TOTAL_CRITICAS DESC;
```

---

### 5. Análise de Críticas por Tipo

**Objetivo:** Identificar distribuição de críticas por tipo.

**Query SQL:**
```sql
SELECT
    tc.TPCCODIGO,
    tc.TPCDESCRICAO AS TIPO_CRITICA,
    tc.TPCTIPO AS CATEGORIA,
    COUNT(*) AS TOTAL_CRITICAS,
    COUNT(DISTINCT cp.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'PENDENTE' THEN 1 END) AS CRITICAS_PENDENTES,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'RESOLVIDA' THEN 1 END) AS CRITICAS_RESOLVIDAS,
    ROUND(100.0 * COUNT(CASE WHEN cp.CPFSITUACAO = 'RESOLVIDA' THEN 1 END) / COUNT(*), 2) AS PERCENTUAL_RESOLVIDO
FROM CRITICASPEDFO cp
LEFT JOIN TPCRITICA tc ON tc.TPCCODIGO = cp.TPCCODIGO
GROUP BY tc.TPCCODIGO, tc.TPCDESCRICAO, tc.TPCTIPO
ORDER BY TOTAL_CRITICAS DESC;
```

---

### 6. Identificar Pedidos com Mais Críticas

**Objetivo:** Identificar pedidos que apresentam mais críticas.

**Query SQL:**
```sql
SELECT
    cp.ID_PEDIDO,
    pf.PEFCODIGO AS CODIGO_PEDIDO,
    pf.PEFDTEMIS AS DATA_PEDIDO,
    COUNT(*) AS TOTAL_CRITICAS,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'PENDENTE' THEN 1 END) AS CRITICAS_PENDENTES,
    COUNT(CASE WHEN cp.CPFSITUACAO = 'RESOLVIDA' THEN 1 END) AS CRITICAS_RESOLVIDAS
FROM CRITICASPEDFO cp
INNER JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
GROUP BY cp.ID_PEDIDO, pf.PEFCODIGO, pf.PEFDTEMIS
HAVING COUNT(*) > 1
ORDER BY TOTAL_CRITICAS DESC;
```

---

### 7. Relatório Completo de Críticas

**Objetivo:** Analisar distribuição completa de críticas no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CRITICAS,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_COM_CRITICAS,
    COUNT(DISTINCT TPCCODIGO) AS TOTAL_TIPOS_CRITICAS,
    COUNT(CASE WHEN CPFSITUACAO = 'PENDENTE' THEN 1 END) AS CRITICAS_PENDENTES,
    COUNT(CASE WHEN CPFSITUACAO = 'RESOLVIDA' THEN 1 END) AS CRITICAS_RESOLVIDAS,
    COUNT(CASE WHEN CPFSITUACAO IS NULL THEN 1 END) AS CRITICAS_SEM_SITUACAO,
    MIN(CPFDATALANCAMENTO) AS PRIMEIRA_CRITICA,
    MAX(CPFDATALANCAMENTO) AS ULTIMA_CRITICA,
    ROUND(AVG(CAST(EXTRACT(EPOCH FROM (CURRENT_DATE - CPFDATALANCAMENTO)) / 86400 AS NUMERIC)), 2) AS MEDIA_DIAS_DESDE_LANCAMENTO
FROM CRITICASPEDFO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CRITICASPEDFO | Tipo |
|--------|-----------|----------------------------|------|
| **CRITICASPEDFO** | 772.777 | 1:1 | **TABELA PRINCIPAL** |
| PEDFO | 129.753 | 1:6 | Pedidos de compra (média de ~6 críticas por pedido) |
| TPCRITICA | 13 | 1:59.444 | Tipos de crítica (média de ~59.444 críticas por tipo) |

**Interpretação:**
- **772.777 críticas** cadastradas no sistema
- **Média de ~6 críticas por pedido** - indica sistema ativo de controle de qualidade
- **13 tipos de crítica** - permite categorização adequada
- **Uso extensivo** - tabela grande indica gestão rigorosa de qualidade

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por pedido** - Para buscas por pedido (já coberto pela PK)
3. **Índice por tipo de crítica** - Para buscas por tipo
4. **Índice por data de lançamento** - Para buscas por período
5. **Índice por situação** - Para buscas de críticas pendentes
6. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo de crítica (consultas frequentes)
CREATE INDEX IDX_CRITICASPEDFO_TIPO ON CRITICASPEDFO(TPCCODIGO)
    WHERE TPCCODIGO IS NOT NULL;

-- Índice 2: Busca por data de lançamento (consultas frequentes)
CREATE INDEX IDX_CRITICASPEDFO_DATA_LANCAMENTO ON CRITICASPEDFO(CPFDATALANCAMENTO);

-- Índice 3: Busca por situação (consultas de críticas pendentes)
CREATE INDEX IDX_CRITICASPEDFO_SITUACAO ON CRITICASPEDFO(CPFSITUACAO)
    WHERE CPFSITUACAO IS NOT NULL;

-- Índice 4: Busca composta por pedido e sequência (já coberto pela PK, mas útil para ordenação)
-- A PK já cobre (ID_PEDIDO, CPFSEQ), mas podemos criar índice adicional para ordenação inversa
CREATE INDEX IDX_CRITICASPEDFO_PED_SEQ_DESC ON CRITICASPEDFO(ID_PEDIDO, CPFSEQ DESC);

-- Índice 5: Busca composta por tipo e situação (consultas de análise)
CREATE INDEX IDX_CRITICASPEDFO_TIPO_SITUACAO ON CRITICASPEDFO(TPCCODIGO, CPFSITUACAO)
    WHERE TPCCODIGO IS NOT NULL AND CPFSITUACAO IS NOT NULL;

-- Índice 6: Busca por data de situação (consultas de histórico)
CREATE INDEX IDX_CRITICASPEDFO_DATA_SITUACAO ON CRITICASPEDFO(CPFDATASITUACAO)
    WHERE CPFDATASITUACAO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela muito grande** (772.777 registros) - Performance crítica, índices essenciais
- **Sem índices específicos** - Recomendado criar índices para buscas frequentes
- **Consultas frequentes** - Críticas são consultadas durante análise de pedidos
- **Índices essenciais** - Em ID_PEDIDO (já coberto pela PK), TPCCODIGO, CPFDATALANCAMENTO e CPFSITUACAO para buscas frequentes
- **Chave primária composta** - (ID_PEDIDO, CPFSEQ) já fornece índice eficiente para buscas por pedido

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar críticas sem pedido válido
SELECT cp.*
FROM CRITICASPEDFO cp
LEFT JOIN PEDFO pf ON pf.ID_PEDIDO = cp.ID_PEDIDO
WHERE pf.ID_PEDIDO IS NULL;

-- Verificar críticas sem tipo válido (quando informado)
SELECT cp.*
FROM CRITICASPEDFO cp
WHERE cp.TPCCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM TPCRITICA tc WHERE tc.TPCCODIGO = cp.TPCCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CRITICASPEDFO
WHERE ID_PEDIDO IS NULL
   OR CPFSEQ IS NULL
   OR CPFDESCRICAO IS NULL
   OR CPFDESCRICAO = ''
   OR CPFDATALANCAMENTO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT ID_PEDIDO, CPFSEQ, COUNT(*) AS QTD
FROM CRITICASPEDFO
GROUP BY ID_PEDIDO, CPFSEQ
HAVING COUNT(*) > 1;

-- Verificar sequências inconsistentes (gaps ou sobreposições)
SELECT 
    cp1.ID_PEDIDO,
    cp1.CPFSEQ AS SEQ_ATUAL,
    MAX(cp2.CPFSEQ) AS SEQ_MAX_ANTERIOR
FROM CRITICASPEDFO cp1
LEFT JOIN CRITICASPEDFO cp2 
    ON cp2.ID_PEDIDO = cp1.ID_PEDIDO 
    AND cp2.CPFSEQ < cp1.CPFSEQ
GROUP BY cp1.ID_PEDIDO, cp1.CPFSEQ
HAVING MAX(cp2.CPFSEQ) IS NOT NULL 
   AND MAX(cp2.CPFSEQ) + 1 != cp1.CPFSEQ
ORDER BY cp1.ID_PEDIDO, cp1.CPFSEQ;

-- Verificar datas inconsistentes
SELECT *
FROM CRITICASPEDFO
WHERE CPFDATASITUACAO IS NOT NULL
  AND CPFDATALANCAMENTO IS NOT NULL
  AND CPFDATASITUACAO < CPFDATALANCAMENTO;
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

final class FirebirdCriticaspedfo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CRITICASPEDFO';
    
    protected $primaryKey = ['ID_PEDIDO', 'CPFSEQ'];
    public $incrementing = false;

    protected $casts = [
        'ID_PEDIDO' => 'integer',
        'CPFSEQ' => 'integer',
        'TPCCODIGO' => 'integer',
        'CPFDESCRICAO' => 'string',
        'CPFDATALANCAMENTO' => 'date',
        'CPFSITUACAO' => 'string',
        'CPFDATASITUACAO' => 'date',
        'CPFREF' => 'string',
        'CPFORIGEMREF' => 'string',
        'CPFTIPO' => 'string',
        'CPFORIGEMCONF' => 'string',
    ];

    // Relacionamento com PEDFO
    public function pedidoCompra(): BelongsTo
    {
        return $this->belongsTo(FirebirdPedfo::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento com TPCRITICA
    public function tipoCritica(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpcritica::class, 'TPCCODIGO', 'TPCCODIGO');
    }

    // Método para verificar se está pendente
    public function estaPendente(): bool
    {
        return empty($this->CPFSITUACAO) || $this->CPFSITUACAO === 'PENDENTE';
    }

    // Método para verificar se foi resolvida
    public function foiResolvida(): bool
    {
        return $this->CPFSITUACAO === 'RESOLVIDA';
    }

    // Scope para filtrar por pedido
    public function scopePorPedido($query, int $pedidoId)
    {
        return $query->where('ID_PEDIDO', $pedidoId);
    }

    // Scope para filtrar críticas pendentes
    public function scopePendentes($query)
    {
        return $query->where(function($q) {
            $q->whereNull('CPFSITUACAO')
              ->orWhere('CPFSITUACAO', 'PENDENTE');
        });
    }

    // Scope para filtrar críticas resolvidas
    public function scopeResolvidas($query)
    {
        return $query->where('CPFSITUACAO', 'RESOLVIDA');
    }

    // Scope para filtrar por tipo de crítica
    public function scopePorTipo($query, int $tipoCodigo)
    {
        return $query->where('TPCCODIGO', $tipoCodigo);
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CPFDATALANCAMENTO', [$dataInicio, $dataFim]);
    }

    // Método estático para contar críticas de um pedido
    public static function contarPorPedido(int $pedidoId): int
    {
        return self::where('ID_PEDIDO', $pedidoId)->count();
    }

    // Método estático para buscar próxima sequência para um pedido
    public static function proximaSequencia(int $pedidoId): int
    {
        $maxSeq = self::where('ID_PEDIDO', $pedidoId)->max('CPFSEQ');
        return ($maxSeq ?? 0) + 1;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - (ID_PEDIDO, CPFSEQ) identifica unicamente cada crítica
2. **Validação antes de inserir** - Verificar se pedido existe
3. **Evitar duplicatas** - PK composta previne duplicatas
4. **Sequência automática** - Garantir que CPFSEQ seja sequencial por pedido
5. **Validação de datas** - Verificar que data de situação é posterior à lançamento

### Performance

1. **Tabela muito grande** - 772.777 registros, performance crítica sem índices adequados
2. **Índices essenciais** - Em ID_PEDIDO (já coberto pela PK), TPCCODIGO, CPFDATALANCAMENTO e CPFSITUACAO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (tipo + situação)
4. **Consultas frequentes** - Críticas são consultadas durante análise de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se pedido existe
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Sequência consistente** - Garantir que CPFSEQ seja sequencial por pedido
5. **Validação de datas** - Verificar que datas são válidas e consistentes

### Manutenção

1. **Revisão periódica** - Verificar críticas pendentes há muito tempo
2. **Padronização** - Manter estrutura de situações e tipos consistente
3. **Documentação** - Documentar significado de cada tipo de crítica
4. **Backup regular** - Tabela importante para controle de qualidade
5. **Arquivamento** - Considerar arquivar críticas antigas resolvidas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

