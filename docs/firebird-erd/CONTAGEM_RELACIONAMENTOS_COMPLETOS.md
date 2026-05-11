# CONTAGEM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CONTAGEM (Contagens Físicas de Estoque)
- **Total de Registros**: 3.098
- **Total de Colunas**: 9
- **Chave Primária**: (ID_BLC, CTGSEQ) - Composta
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 2 (PROCONTAGEM, outras)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CONTAGEM** é uma tabela que armazena informações sobre contagens físicas de estoque realizadas durante balanços. Com **3.098 registros**, representa contagens físicas realizadas, permitindo rastrear cada etapa de contagem em um balanço específico.

Esta tabela funciona como **registro de contagens físicas** e permite:
- Registrar cada contagem física realizada em um balanço
- Associar contagens a equipamentos específicos
- Controlar datas e horários de encerramento de contagens
- Associar contagens a funcionários responsáveis
- Suportar múltiplas contagens por balanço
- Controlar lotes de contagem
- Manter histórico de contagens físicas

Cada registro representa uma contagem física específica realizada durante um balanço, contendo:
- Identificação do balanço (ID_BLC)
- Sequência da contagem (CTGSEQ)
- Equipamento utilizado (EQPCODIGO)
- Funcionário responsável (FUNCODIGO)
- Data e hora de encerramento (CTGDTENCERRAMENTO, CTGHRENCERRAMENTO)
- Descrição da contagem (CTGDESCRICAO)
- Contagem base (CTGCONTAGEMBASE)
- Lote de contagem (CTGLOTECONTAGEM)

O sistema utiliza esta tabela para rastrear todas as contagens físicas realizadas durante balanços, permitindo auditoria completa e controle de qualidade das contagens.

**Observação Importante:** CONTAGEM trabalha em conjunto com BALANCO e PROCONTAGEM para gerenciar contagens físicas de estoque. Com 3.098 registros para 1.110 balanços, indica média de 2.79 contagens por balanço, mostrando que balanços têm múltiplas etapas de contagem.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_BLC** 🔑🔗 | INTEGER | ✓ | Código do balanço (PK + FK → BALANCO) |
| **CTGSEQ** 🔑 | SMALLINT | ✓ | Sequência da contagem (PK) |

### Informações da Contagem
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTGDESCRICAO** | VARCHAR(37) | | Descrição da contagem |
| **CTGCONTAGEMBASE** | SMALLINT | | Código da contagem base |
| **CTGLOTECONTAGEM** | SMALLINT | | Código do lote de contagem |

### Equipamento e Funcionário
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **EQPCODIGO** | SMALLINT | ✓ | Código do equipamento utilizado |
| **FUNCODIGO** | INTEGER | | Código do funcionário responsável |

### Controle Temporal
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTGDTENCERRAMENTO** | DATE | | Data de encerramento da contagem |
| **CTGHRENCERRAMENTO** | TIME | | Hora de encerramento da contagem |

**Primary Key:** (ID_BLC, CTGSEQ)

**Observações sobre Campos:**
- **ID_BLC**: Balanço ao qual a contagem pertence.
- **CTGSEQ**: Sequência que identifica cada contagem dentro do balanço.
- **EQPCODIGO**: Equipamento utilizado para realizar a contagem.
- **FUNCODIGO**: Funcionário responsável pela contagem.
- **CTGDTENCERRAMENTO**: Data em que a contagem foi encerrada.
- **CTGHRENCERRAMENTO**: Hora em que a contagem foi encerrada.
- **CTGDESCRICAO**: Descrição ou observações sobre a contagem.
- **CTGCONTAGEMBASE**: Referência a uma contagem base (para comparação).
- **CTGLOTECONTAGEM**: Lote ao qual a contagem pertence.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CONTAGEM Referencia (1 FK):

#### 1. BALANCO - Balanços
**Relacionamento:**
```
CONTAGEM.ID_BLC → BALANCO.ID_BLC (N:1)
Constraint: BALANCO_CONTAGEM
```

**Descrição**: Cada contagem está vinculada a um balanço específico.

**Informações da Tabela BALANCO:**
- **Total:** 1.110 balanços
- **PK:** ID_BLC
- **Colunas:** 7 campos
- **FK Out:** 0
- **FK In:** 6 tabelas

**Uso:** Identificar o balanço da contagem, obter informações do balanço.

---

### CONTAGEM é Referenciada Por (2 tabelas):

#### 1. PROCONTAGEM - Produtos Contados
**Relacionamento:**
```
PROCONTAGEM.ID_BLC → CONTAGEM.ID_BLC (N:1)
PROCONTAGEM.CTGSEQ → CONTAGEM.CTGSEQ (N:1)
Constraint: CONTAGEM_PROCONTAGEM
```

**Descrição**: PROCONTAGEM referencia CONTAGEM para registrar produtos contados em cada contagem.

**Informações da Tabela PROCONTAGEM:**
- **Total:** 923.382 registros
- **PK:** (ID_BLC, CTGSEQ, PROCODIGO)
- **Colunas:** 5 campos

**Uso:** PROCONTAGEM estende CONTAGEM com produtos específicos contados e quantidades apuradas.

---

#### 2. Outras Tabelas de Contagem

Outras tabelas podem referenciar CONTAGEM para registrar informações adicionais sobre contagens.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ID_BLC → BALANCO → EMPRESA

**Fluxo:** CONTAGEM → BALANCO → EMPRESA

**Descrição:** Através do balanço, é possível identificar a empresa.

**Uso:** Análise de contagens por empresa.

---

### Via PROCONTAGEM → PRODU (Produtos Contados)

**Fluxo:** CONTAGEM → PROCONTAGEM → PRODU

**Descrição:** Através de PROCONTAGEM, é possível identificar produtos que foram contados.

**Uso:** Análise de produtos contados em cada contagem.

---

### Via EQPCODIGO → EQUIPAMENTO (Equipamentos)

**Fluxo:** CONTAGEM → EQUIPAMENTO

**Descrição:** Através do código de equipamento, é possível identificar equipamentos utilizados.

**Uso:** Análise de contagens por equipamento.

---

### Via FUNCODIGO → FUNCIONARIO (Funcionários)

**Fluxo:** CONTAGEM → FUNCIONARIO

**Descrição:** Através do código de funcionário, é possível identificar funcionários responsáveis.

**Uso:** Análise de contagens por funcionário.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Contagem

**Objetivo:** Obter visão completa de uma contagem incluindo informações do balanço, produtos contados e funcionário responsável.

**Fluxo:**
```
CONTAGEM (ID_BLC, CTGSEQ, EQPCODIGO, FUNCODIGO)
  ↓
BALANCO (ID_BLC, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
  ↓
PROCONTAGEM (ID_BLC, CTGSEQ, PROCODIGO)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_ABERTURA_BALANCO,
    blc.BLCDTFECHAMENTO AS DATA_FECHAMENTO_BALANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    eqp.EQPDESCRICAO AS EQUIPAMENTO,
    fun.FUNNOME AS FUNCIONARIO,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    ctg.CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS,
    SUM(pc.CTGAPURADO) AS QUANTIDADE_TOTAL_APURADA
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = blc.EMPCODIGO
LEFT JOIN EQUIPAMENTO eqp ON eqp.EQPCODIGO = ctg.EQPCODIGO
LEFT JOIN FUNCIONARIO fun ON fun.FUNCODIGO = ctg.FUNCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.ID_BLC = ?
  AND ctg.CTGSEQ = ?
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, blc.BLCDTFECHAMENTO, emp.EMPNOMEFANT,
         ctg.CTGSEQ, ctg.CTGDESCRICAO, eqp.EQPDESCRICAO, fun.FUNNOME,
         ctg.CTGDTENCERRAMENTO, ctg.CTGHRENCERRAMENTO;
```

---

### Exemplo 2: Análise de Contagens por Balanço

**Objetivo:** Obter todas as contagens de um balanço específico.

**Query SQL:**
```sql
SELECT
    ctg.ID_BLC,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    eqp.EQPDESCRICAO AS EQUIPAMENTO,
    fun.FUNNOME AS FUNCIONARIO,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    ctg.CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
LEFT JOIN EQUIPAMENTO eqp ON eqp.EQPCODIGO = ctg.EQPCODIGO
LEFT JOIN FUNCIONARIO fun ON fun.FUNCODIGO = ctg.FUNCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.ID_BLC = ?
GROUP BY ctg.ID_BLC, ctg.CTGSEQ, ctg.CTGDESCRICAO, eqp.EQPDESCRICAO, 
         fun.FUNNOME, ctg.CTGDTENCERRAMENTO, ctg.CTGHRENCERRAMENTO
ORDER BY ctg.CTGSEQ;
```

---

### Exemplo 3: Análise de Contagens por Funcionário

**Objetivo:** Obter contagens realizadas por um funcionário específico.

**Query SQL:**
```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_BALANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    ctg.CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = blc.EMPCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.FUNCODIGO = ?
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, emp.EMPNOMEFANT, ctg.CTGSEQ,
         ctg.CTGDESCRICAO, ctg.CTGDTENCERRAMENTO, ctg.CTGHRENCERRAMENTO
ORDER BY ctg.CTGDTENCERRAMENTO DESC, ctg.CTGHRENCERRAMENTO DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Contagem

**Objetivo:** Obter informações de uma contagem específica.

```sql
SELECT
    ID_BLC,
    CTGSEQ,
    CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    EQPCODIGO AS EQUIPAMENTO,
    FUNCODIGO AS FUNCIONARIO,
    CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO,
    CTGCONTAGEMBASE AS CONTAGEM_BASE,
    CTGLOTECONTAGEM AS LOTE_CONTAGEM
FROM CONTAGEM
WHERE ID_BLC = ?
  AND CTGSEQ = ?;
```

---

### 2. Listar Contagens de um Balanço

**Objetivo:** Obter todas as contagens de um balanço específico.

```sql
SELECT
    CTGSEQ,
    CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    EQPCODIGO AS EQUIPAMENTO,
    FUNCODIGO AS FUNCIONARIO,
    CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO
FROM CONTAGEM
WHERE ID_BLC = ?
ORDER BY CTGSEQ;
```

---

### 3. Análise de Contagens por Equipamento

**Objetivo:** Identificar contagens realizadas com um equipamento específico.

```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_BALANCO,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.EQPCODIGO = ?
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, ctg.CTGSEQ, ctg.CTGDESCRICAO, ctg.CTGDTENCERRAMENTO
ORDER BY ctg.CTGDTENCERRAMENTO DESC;
```

---

### 4. Análise de Contagens por Período

**Objetivo:** Identificar contagens realizadas em um período específico.

```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_BALANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = blc.EMPCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.CTGDTENCERRAMENTO >= ?
  AND ctg.CTGDTENCERRAMENTO <= ?
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, emp.EMPNOMEFANT, ctg.CTGSEQ,
         ctg.CTGDESCRICAO, ctg.CTGDTENCERRAMENTO
ORDER BY ctg.CTGDTENCERRAMENTO DESC;
```

---

### 5. Análise de Contagens Encerradas

**Objetivo:** Identificar contagens que foram encerradas.

**Query SQL:**
```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_BALANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    ctg.CTGDTENCERRAMENTO AS DATA_ENCERRAMENTO,
    ctg.CTGHRENCERRAMENTO AS HORA_ENCERRAMENTO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = blc.EMPCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.CTGDTENCERRAMENTO IS NOT NULL
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, emp.EMPNOMEFANT, ctg.CTGSEQ,
         ctg.CTGDESCRICAO, ctg.CTGDTENCERRAMENTO, ctg.CTGHRENCERRAMENTO
ORDER BY ctg.CTGDTENCERRAMENTO DESC, ctg.CTGHRENCERRAMENTO DESC;
```

---

### 6. Análise de Contagens Pendentes

**Objetivo:** Identificar contagens que ainda não foram encerradas.

**Query SQL:**
```sql
SELECT
    ctg.ID_BLC,
    blc.BLCDTABERTURA AS DATA_BALANCO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctg.CTGSEQ,
    ctg.CTGDESCRICAO AS DESCRICAO_CONTAGEM,
    eqp.EQPDESCRICAO AS EQUIPAMENTO,
    fun.FUNNOME AS FUNCIONARIO,
    COUNT(pc.PROCODIGO) AS TOTAL_PRODUTOS_CONTADOS
FROM CONTAGEM ctg
INNER JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = blc.EMPCODIGO
LEFT JOIN EQUIPAMENTO eqp ON eqp.EQPCODIGO = ctg.EQPCODIGO
LEFT JOIN FUNCIONARIO fun ON fun.FUNCODIGO = ctg.FUNCODIGO
LEFT JOIN PROCONTAGEM pc ON pc.ID_BLC = ctg.ID_BLC
  AND pc.CTGSEQ = ctg.CTGSEQ
WHERE ctg.CTGDTENCERRAMENTO IS NULL
GROUP BY ctg.ID_BLC, blc.BLCDTABERTURA, emp.EMPNOMEFANT, ctg.CTGSEQ,
         ctg.CTGDESCRICAO, eqp.EQPDESCRICAO, fun.FUNNOME
ORDER BY ctg.ID_BLC, ctg.CTGSEQ;
```

---

### 7. Relatório de Contagens

**Objetivo:** Analisar distribuição completa de contagens.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CONTAGENS,
    COUNT(DISTINCT ID_BLC) AS TOTAL_BALANCOS,
    COUNT(CASE WHEN CTGDTENCERRAMENTO IS NOT NULL THEN 1 END) AS CONTAGENS_ENCERRADAS,
    COUNT(CASE WHEN CTGDTENCERRAMENTO IS NULL THEN 1 END) AS CONTAGENS_PENDENTES,
    COUNT(DISTINCT EQPCODIGO) AS TOTAL_EQUIPAMENTOS_DIFERENTES,
    COUNT(DISTINCT FUNCODIGO) AS TOTAL_FUNCIONARIOS_DIFERENTES,
    AVG(contagens_por_balanco.TOTAL) AS MEDIA_CONTAGENS_POR_BALANCO
FROM CONTAGEM
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM CONTAGEM
    GROUP BY ID_BLC
) contagens_por_balanco;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CONTAGEM | Tipo |
|--------|-----------|---------------------|------|
| **CONTAGEM** | 3.098 | 1:1 | **TABELA PRINCIPAL** |
| BALANCO | 1.110 | 0.36:1 | Balanços (média de 2.79 contagens por balanço) |
| PROCONTAGEM | 923.382 | 298.18:1 | Produtos contados (média de 298 produtos por contagem) |

**Interpretação:**
- **3.098 contagens** cadastradas no sistema
- **279% dos balanços** têm pelo menos uma contagem (3.098 de 1.110)
- **Média de 2.79 contagens por balanço** - balanços têm múltiplas etapas de contagem
- **Média de 298 produtos por contagem** - contagens incluem muitos produtos
- **Uso extensivo** - indica processo detalhado de contagem física

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CONTAGEM além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por balanço** - Para buscas por balanço
3. **Índice por equipamento** - Para buscas por equipamento
4. **Índice por funcionário** - Para buscas por funcionário
5. **Índice por data** - Para buscas por período

### Índices Sugeridos

```sql
-- Índice 1: Busca por balanço (consultas frequentes)
CREATE INDEX IDX_CONTAGEM_BALANCO ON CONTAGEM(ID_BLC);

-- Índice 2: Busca por equipamento (consultas frequentes)
CREATE INDEX IDX_CONTAGEM_EQUIPAMENTO ON CONTAGEM(EQPCODIGO)
    WHERE EQPCODIGO IS NOT NULL;

-- Índice 3: Busca por funcionário (consultas frequentes)
CREATE INDEX IDX_CONTAGEM_FUNCIONARIO ON CONTAGEM(FUNCODIGO)
    WHERE FUNCODIGO IS NOT NULL;

-- Índice 4: Busca por data de encerramento (consultas de período)
CREATE INDEX IDX_CONTAGEM_DATA_ENCERRAMENTO ON CONTAGEM(CTGDTENCERRAMENTO)
    WHERE CTGDTENCERRAMENTO IS NOT NULL;

-- Índice 5: Busca composta por balanço e sequência (consultas de validação)
CREATE INDEX IDX_CONTAGEM_BALANCO_SEQ ON CONTAGEM(ID_BLC, CTGSEQ);
```

### Observações sobre Volume

- **Tabela média** (3.098 registros) - Performance boa
- **Consultas frequentes** - Contagens são consultadas durante balanços
- **Índices úteis** - Em ID_BLC, EQPCODIGO, FUNCODIGO e CTGDTENCERRAMENTO para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar contagens sem balanço válido
SELECT ctg.*
FROM CONTAGEM ctg
LEFT JOIN BALANCO blc ON blc.ID_BLC = ctg.ID_BLC
WHERE blc.ID_BLC IS NULL;

-- Verificar contagens sem equipamento válido
SELECT ctg.*
FROM CONTAGEM ctg
WHERE ctg.EQPCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM EQUIPAMENTO eqp WHERE eqp.EQPCODIGO = ctg.EQPCODIGO);

-- Verificar contagens sem funcionário válido
SELECT ctg.*
FROM CONTAGEM ctg
WHERE ctg.FUNCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM FUNCIONARIO fun WHERE fun.FUNCODIGO = ctg.FUNCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CONTAGEM
WHERE ID_BLC IS NULL
   OR CTGSEQ IS NULL
   OR EQPCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT ID_BLC, CTGSEQ, COUNT(*) AS QTD
FROM CONTAGEM
GROUP BY ID_BLC, CTGSEQ
HAVING COUNT(*) > 1;

-- Verificar contagens com data de encerramento mas sem hora
SELECT *
FROM CONTAGEM
WHERE CTGDTENCERRAMENTO IS NOT NULL
  AND CTGHRENCERRAMENTO IS NULL;

-- Verificar contagens com hora de encerramento mas sem data
SELECT *
FROM CONTAGEM
WHERE CTGHRENCERRAMENTO IS NOT NULL
  AND CTGDTENCERRAMENTO IS NULL;
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
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdContagem extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CONTAGEM';
    
    protected $primaryKey = ['ID_BLC', 'CTGSEQ'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'ID_BLC' => 'integer',
        'CTGSEQ' => 'integer',
        'EQPCODIGO' => 'integer',
        'FUNCODIGO' => 'integer',
        'CTGDESCRICAO' => 'string',
        'CTGCONTAGEMBASE' => 'integer',
        'CTGLOTECONTAGEM' => 'integer',
        'CTGDTENCERRAMENTO' => 'date',
        'CTGHRENCERRAMENTO' => 'time',
    ];

    // Relacionamento com BALANCO
    public function balanco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBalanco::class, 'ID_BLC', 'ID_BLC');
    }

    // Relacionamento com EQUIPAMENTO
    public function equipamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdEquipamento::class, 'EQPCODIGO', 'EQPCODIGO');
    }

    // Relacionamento com FUNCIONARIO
    public function funcionario(): BelongsTo
    {
        return $this->belongsTo(FirebirdFuncionario::class, 'FUNCODIGO', 'FUNCODIGO');
    }

    // Relacionamento com PROCONTAGEM
    public function produtosContados(): HasMany
    {
        return $this->hasMany(FirebirdProcontagem::class, ['ID_BLC', 'CTGSEQ'], ['ID_BLC', 'CTGSEQ']);
    }

    // Método para verificar se está encerrada
    public function isEncerrada(): bool
    {
        return !empty($this->CTGDTENCERRAMENTO);
    }

    // Método para obter total de produtos contados
    public function getTotalProdutosContados(): int
    {
        return $this->produtosContados()->count();
    }

    // Scope para filtrar por balanço
    public function scopePorBalanco($query, int $balancoId)
    {
        return $query->where('ID_BLC', $balancoId);
    }

    // Scope para filtrar contagens encerradas
    public function scopeEncerradas($query)
    {
        return $query->whereNotNull('CTGDTENCERRAMENTO');
    }

    // Scope para filtrar contagens pendentes
    public function scopePendentes($query)
    {
        return $query->whereNull('CTGDTENCERRAMENTO');
    }

    // Método estático para buscar contagem por chave completa
    public static function buscarPorChave(int $balancoId, int $sequencia): ?self
    {
        return self::where('ID_BLC', $balancoId)
            ->where('CTGSEQ', $sequencia)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se balanço existe
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de datas** - Verificar que data e hora de encerramento são consistentes

### Performance

1. **Tabela média** - 3.098 registros, performance boa
2. **Índices úteis** - Em ID_BLC, EQPCODIGO, FUNCODIGO e CTGDTENCERRAMENTO para buscas frequentes
3. **Consultas frequentes** - Contagens são consultadas durante balanços

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se balanço existe
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de datas** - Verificar que data e hora são consistentes

### Manutenção

1. **Revisão periódica** - Verificar contagens não encerradas
2. **Padronização** - Manter estrutura consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para auditoria de estoque

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

