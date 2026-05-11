# CLIPROMO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIPROMO (Cliente x Promoção)
- **Total de Registros**: 662
- **Total de Colunas**: 5
- **Chave Primária**: ID_CLIPROMO (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIPROMO** é uma tabela de associação que vincula clientes a promoções. Com **662 registros**, representa clientes que estão associados a promoções específicas, permitindo controle de quais clientes podem participar de cada promoção.

Esta tabela funciona como **associador de clientes a promoções** e permite:
- Associar clientes a promoções específicas
- Controlar quais clientes podem participar de cada promoção
- Suportar grupos de clientes em promoções (GCLCODIGO)
- Permitir exclusão de clientes específicos de promoções (DESCONSIDERAR)
- Facilitar gestão de promoções por cliente
- Suportar múltiplas promoções por cliente

Cada registro representa uma associação entre um cliente e uma promoção, contendo:
- Identificador único da associação (ID_CLIPROMO)
- Promoção associada (ID_PROMO)
- Grupo de clientes (GCLCODIGO) - opcional
- Flag de exclusão (DESCONSIDERAR) - opcional
- Cliente associado (CLICODIGO) - opcional

O sistema utiliza esta tabela para controlar quais clientes podem participar de cada promoção, permitindo inclusão ou exclusão específica de clientes.

**Observação Importante:** CLIPROMO permite controle granular de acesso a promoções por cliente. Com 662 registros para 156 promoções, indica média de aproximadamente 4.2 clientes por promoção, sugerindo promoções específicas para grupos selecionados de clientes.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_CLIPROMO** 🔑 | INTEGER | ✓ | Identificador único da associação cliente-promoção |

### Associação com Promoção
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PROMO** 🔗 | INTEGER | ✓ | Código da promoção (FK → PROMO) |

### Informações Adicionais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GCLCODIGO** | INTEGER | | Código do grupo de clientes |
| **DESCONSIDERAR** | VARCHAR(37) | | Flag indicando se o cliente deve ser desconsiderado da promoção |
| **CLICODIGO** | INTEGER | | Código do cliente (lógica → CLIEN) |

**Primary Key:** ID_CLIPROMO

**Observações sobre Campos:**
- **ID_CLIPROMO**: Identificador único de cada associação cliente-promoção.
- **ID_PROMO**: Promoção à qual o cliente está associado.
- **GCLCODIGO**: Código do grupo de clientes (pode ser usado para associar grupos inteiros).
- **DESCONSIDERAR**: Flag que indica se o cliente deve ser excluído da promoção mesmo que pertença a um grupo incluído.
- **CLICODIGO**: Cliente específico associado (quando não usa grupo).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIPROMO Referencia (1 FK):

#### 1. PROMO - Promoções
**Relacionamento:**
```
CLIPROMO.ID_PROMO → PROMO.ID_PROMO (N:1)
Constraint: XFKCLIPROMO_PROMO
```

**Descrição**: Cada associação está vinculada a uma promoção específica.

**Informações da Tabela PROMO:**
- **Total:** 156 promoções
- **PK:** ID_PROMO
- **Colunas:** 35 campos
- **FK Out:** 1
- **FK In:** 10 tabelas

**Campos importantes em PROMO relacionados a CLIPROMO:**
- `ID_PROMO` - Código da promoção
- `DESCRICAO` - Descrição da promoção
- `DTINICIAL` - Data inicial da promoção
- `DTFINAL` - Data final da promoção
- `TIPO` - Tipo da promoção
- `VALPEDLISTASERV` - Valor mínimo do pedido

**Uso:** Identificar a promoção da associação, obter informações da promoção.

---

### CLIPROMO é Referenciada Por

**Nenhuma tabela** referencia CLIPROMO diretamente. Esta é uma tabela folha utilizada para associação e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PROMO → PEDID (Pedidos)

**Fluxo:** CLIPROMO → PROMO → PEDID

**Descrição:** Através da promoção, é possível identificar pedidos que podem estar relacionados às promoções.

**Uso:** Análises de pedidos considerando promoções, aplicação de promoções em pedidos.

---

### Via CLICODIGO → CLIEN (Clientes)

**Fluxo:** CLIPROMO → CLICODIGO (lógico) → CLIEN

**Descrição:** Através do código do cliente, é possível identificar informações do cliente associado.

**Uso:** Análises de clientes em promoções, relatórios de promoções por cliente.

---

### Via GCLCODIGO → Grupos de Clientes

**Fluxo:** CLIPROMO → GCLCODIGO (lógico) → Grupos

**Descrição:** Através do código do grupo, é possível identificar grupos de clientes associados.

**Uso:** Análises de grupos em promoções, aplicação de promoções a grupos.

---

### Via PROMO → PROMOPROD (Produtos de Promoção)

**Fluxo:** CLIPROMO → PROMO → PROMOPROD

**Descrição:** Através da promoção, é possível identificar produtos incluídos na promoção.

**Uso:** Obter produtos da promoção para clientes associados.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Associação Cliente-Promoção

**Objetivo:** Obter visão completa de uma associação incluindo informações da promoção e cliente.

**Fluxo:**
```
CLIPROMO (ID_CLIPROMO, ID_PROMO, CLICODIGO)
  ↓
PROMO (ID_PROMO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.ID_CLIPROMO,
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    pr.DTINICIAL AS DATA_INICIAL,
    pr.DTFINAL AS DATA_FINAL,
    pr.TIPO AS TIPO_PROMOCAO,
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cp.GCLCODIGO AS GRUPO_CLIENTES,
    cp.DESCONSIDERAR AS DESCONSIDERAR
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
WHERE cp.ID_CLIPROMO = ?;
```

---

### Exemplo 2: Análise de Promoções por Cliente

**Objetivo:** Identificar todas as promoções associadas a um cliente específico.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLIPROMO (CLICODIGO)
  ↓
PROMO (ID_PROMO)
```

**Query SQL:**
```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    pr.DTINICIAL AS DATA_INICIAL,
    pr.DTFINAL AS DATA_FINAL,
    pr.TIPO AS TIPO_PROMOCAO,
    CASE 
        WHEN CURRENT_DATE BETWEEN pr.DTINICIAL AND pr.DTFINAL THEN 'ATIVA'
        WHEN CURRENT_DATE < pr.DTINICIAL THEN 'FUTURA'
        ELSE 'EXPIRADA'
    END AS STATUS_PROMOCAO,
    cp.GCLCODIGO AS GRUPO_CLIENTES,
    cp.DESCONSIDERAR AS DESCONSIDERAR
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE cp.CLICODIGO = ?
  AND (cp.DESCONSIDERAR IS NULL OR cp.DESCONSIDERAR != 'S')
ORDER BY pr.DTINICIAL DESC;
```

---

### Exemplo 3: Análise de Clientes em Promoções com Pedidos

**Objetivo:** Obter clientes associados a promoções com informações de pedidos relacionados.

**Fluxo:**
```
CLIPROMO (ID_PROMO, CLICODIGO)
  ↓
PROMO (ID_PROMO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    COUNT(DISTINCT cp.CLICODIGO) AS TOTAL_CLIENTES_ASSOCIADOS,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS,
    AVG(pd.PEDVRMERC) AS VALOR_MEDIO_PEDIDOS
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = cp.CLICODIGO
WHERE cp.DESCONSIDERAR IS NULL OR cp.DESCONSIDERAR != 'S'
GROUP BY cp.ID_PROMO, pr.DESCRICAO
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Associação Cliente-Promoção

**Objetivo:** Verificar se um cliente está associado a uma promoção específica.

```sql
SELECT
    ID_CLIPROMO,
    ID_PROMO,
    CLICODIGO,
    GCLCODIGO AS GRUPO_CLIENTES,
    DESCONSIDERAR
FROM CLIPROMO
WHERE ID_PROMO = ?
  AND CLICODIGO = ?;
```

---

### 2. Listar Todas as Promoções de um Cliente

**Objetivo:** Obter todas as promoções associadas a um cliente específico.

```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    pr.DTINICIAL AS DATA_INICIAL,
    pr.DTFINAL AS DATA_FINAL,
    pr.TIPO AS TIPO_PROMOCAO,
    CASE 
        WHEN CURRENT_DATE BETWEEN pr.DTINICIAL AND pr.DTFINAL THEN 'ATIVA'
        WHEN CURRENT_DATE < pr.DTINICIAL THEN 'FUTURA'
        ELSE 'EXPIRADA'
    END AS STATUS_PROMOCAO
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE cp.CLICODIGO = ?
  AND (cp.DESCONSIDERAR IS NULL OR cp.DESCONSIDERAR != 'S')
ORDER BY pr.DTINICIAL DESC;
```

---

### 3. Listar Todos os Clientes de uma Promoção

**Objetivo:** Obter todos os clientes associados a uma promoção específica.

```sql
SELECT
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cp.GCLCODIGO AS GRUPO_CLIENTES,
    cp.DESCONSIDERAR
FROM CLIPROMO cp
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
WHERE cp.ID_PROMO = ?
ORDER BY cl.CLINOMEFANT;
```

---

### 4. Análise de Promoções Mais Utilizadas

**Objetivo:** Identificar promoções com mais clientes associados.

```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    pr.DTINICIAL AS DATA_INICIAL,
    pr.DTFINAL AS DATA_FINAL,
    COUNT(DISTINCT cp.CLICODIGO) AS TOTAL_CLIENTES_ASSOCIADOS,
    COUNT(DISTINCT cp.GCLCODIGO) AS TOTAL_GRUPOS_ASSOCIADOS,
    COUNT(*) AS TOTAL_ASSOCIACOES
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE cp.DESCONSIDERAR IS NULL OR cp.DESCONSIDERAR != 'S'
GROUP BY cp.ID_PROMO, pr.DESCRICAO, pr.DTINICIAL, pr.DTFINAL
ORDER BY TOTAL_CLIENTES_ASSOCIADOS DESC;
```

---

### 5. Análise de Clientes Excluídos de Promoções

**Objetivo:** Identificar clientes que foram explicitamente excluídos de promoções.

```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    cp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cp.DESCONSIDERAR
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cp.CLICODIGO
WHERE cp.DESCONSIDERAR IS NOT NULL
  AND cp.DESCONSIDERAR = 'S'
ORDER BY pr.DESCRICAO, cl.CLINOMEFANT;
```

---

### 6. Análise de Promoções por Grupo de Clientes

**Objetivo:** Identificar promoções associadas a grupos de clientes.

```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    cp.GCLCODIGO AS GRUPO_CLIENTES,
    COUNT(DISTINCT cp.CLICODIGO) AS TOTAL_CLIENTES_INDIVIDUAIS,
    COUNT(*) AS TOTAL_ASSOCIACOES
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE cp.GCLCODIGO IS NOT NULL
GROUP BY cp.ID_PROMO, pr.DESCRICAO, cp.GCLCODIGO
ORDER BY cp.ID_PROMO, cp.GCLCODIGO;
```

---

### 7. Relatório de Promoções Ativas por Cliente

**Objetivo:** Obter promoções ativas para um cliente específico.

```sql
SELECT
    cp.ID_PROMO,
    pr.DESCRICAO AS PROMOCAO,
    pr.DTINICIAL AS DATA_INICIAL,
    pr.DTFINAL AS DATA_FINAL,
    pr.TIPO AS TIPO_PROMOCAO,
    pr.VALPEDLISTASERV AS VALOR_MINIMO_PEDIDO,
    CASE 
        WHEN CURRENT_DATE BETWEEN pr.DTINICIAL AND pr.DTFINAL THEN 'ATIVA'
        WHEN CURRENT_DATE < pr.DTINICIAL THEN 'FUTURA'
        ELSE 'EXPIRADA'
    END AS STATUS_PROMOCAO
FROM CLIPROMO cp
INNER JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE cp.CLICODIGO = ?
  AND (cp.DESCONSIDERAR IS NULL OR cp.DESCONSIDERAR != 'S')
  AND CURRENT_DATE BETWEEN pr.DTINICIAL AND pr.DTFINAL
ORDER BY pr.DTINICIAL DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIPROMO | Tipo |
|--------|-----------|---------------------|------|
| **CLIPROMO** | 662 | 1:1 | **TABELA PRINCIPAL** |
| PROMO | 156 | 0.24:1 | Promoções (média de 4.24 clientes por promoção) |
| CLIEN | 9.251 | 13.98:1 | Clientes (média de 0.072 promoções por cliente) |

**Interpretação:**
- **662 associações** cadastradas no sistema
- **Média de 4.24 clientes por promoção** - indica promoções específicas para grupos selecionados
- **7.2% dos clientes** têm pelo menos uma promoção associada (662 de 9.251)
- **Uso específico** - indica promoções direcionadas para clientes específicos

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIPROMO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por promoção** - Para buscas por promoção
3. **Índice por cliente** - Para buscas por cliente
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por promoção (consultas frequentes)
CREATE INDEX IDX_CLIPROMO_PROMOCAO ON CLIPROMO(ID_PROMO);

-- Índice 2: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIPROMO_CLIENTE ON CLIPROMO(CLICODIGO)
    WHERE CLICODIGO IS NOT NULL;

-- Índice 3: Busca por grupo de clientes (consultas frequentes)
CREATE INDEX IDX_CLIPROMO_GRUPO ON CLIPROMO(GCLCODIGO)
    WHERE GCLCODIGO IS NOT NULL;

-- Índice 4: Busca composta por promoção e cliente (consultas de validação)
CREATE INDEX IDX_CLIPROMO_PROM_CLI ON CLIPROMO(ID_PROMO, CLICODIGO);
```

### Observações sobre Volume

- **Tabela pequena** (662 registros) - Performance boa
- **Consultas frequentes** - Associações são consultadas durante criação de pedidos
- **Índices essenciais** - Em ID_PROMO e CLICODIGO para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por promoção e cliente

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar associações sem promoção válida
SELECT cp.*
FROM CLIPROMO cp
LEFT JOIN PROMO pr ON pr.ID_PROMO = cp.ID_PROMO
WHERE pr.ID_PROMO IS NULL;

-- Verificar associações com cliente inválido (quando CLICODIGO está preenchido)
SELECT cp.*
FROM CLIPROMO cp
WHERE cp.CLICODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM CLIEN cl WHERE cl.CLICODIGO = cp.CLICODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIPROMO
WHERE ID_CLIPROMO IS NULL
   OR ID_PROMO IS NULL;

-- Verificar duplicatas de cliente-promoção
SELECT ID_PROMO, CLICODIGO, COUNT(*) AS QTD
FROM CLIPROMO
WHERE CLICODIGO IS NOT NULL
GROUP BY ID_PROMO, CLICODIGO
HAVING COUNT(*) > 1;

-- Verificar associações sem cliente nem grupo
SELECT *
FROM CLIPROMO
WHERE CLICODIGO IS NULL
  AND GCLCODIGO IS NULL;
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

final class FirebirdClipromo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIPROMO';
    
    protected $primaryKey = 'ID_CLIPROMO';
    public $incrementing = true;

    protected $casts = [
        'ID_CLIPROMO' => 'integer',
        'ID_PROMO' => 'integer',
        'GCLCODIGO' => 'integer',
        'DESCONSIDERAR' => 'string',
        'CLICODIGO' => 'integer',
    ];

    // Relacionamento com PROMO
    public function promocao(): BelongsTo
    {
        return $this->belongsTo(FirebirdPromo::class, 'ID_PROMO', 'ID_PROMO');
    }

    // Relacionamento lógico com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Método para verificar se cliente está desconsiderado
    public function estaDesconsiderado(): bool
    {
        return !empty($this->DESCONSIDERAR) && strtoupper($this->DESCONSIDERAR) === 'S';
    }

    // Método para verificar se é associação por grupo
    public function isPorGrupo(): bool
    {
        return !empty($this->GCLCODIGO);
    }

    // Método para verificar se é associação individual
    public function isIndividual(): bool
    {
        return !empty($this->CLICODIGO);
    }

    // Scope para filtrar por promoção
    public function scopePorPromocao($query, int $promocaoId)
    {
        return $query->where('ID_PROMO', $promocaoId);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar apenas ativos (não desconsiderados)
    public function scopeAtivos($query)
    {
        return $query->where(function($q) {
            $q->whereNull('DESCONSIDERAR')
              ->orWhere('DESCONSIDERAR', '!=', 'S');
        });
    }

    // Método estático para verificar se cliente está em promoção
    public static function clienteEstaEmPromocao(int $clienteCodigo, int $promocaoId): bool
    {
        return self::where('ID_PROMO', $promocaoId)
            ->where(function($q) use ($clienteCodigo) {
                $q->where('CLICODIGO', $clienteCodigo)
                  ->orWhere(function($q2) use ($clienteCodigo) {
                      // Verificar se cliente pertence a grupo associado
                      // Implementação depende da estrutura de grupos
                  });
            })
            ->ativos()
            ->exists();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - ID_CLIPROMO identifica unicamente cada associação
2. **Validação antes de inserir** - Verificar se promoção existe
3. **Evitar duplicatas** - Validar cliente-promoção antes de inserir
4. **Validação de flags** - Verificar valores válidos de DESCONSIDERAR

### Performance

1. **Tabela pequena** - 662 registros, performance boa
2. **Índices essenciais** - Em ID_PROMO e CLICODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (promoção + cliente)
4. **Consultas frequentes** - Associações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - Validar cliente-promoção antes de inserir
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de flags** - Verificar valores válidos de DESCONSIDERAR

### Manutenção

1. **Revisão periódica** - Verificar associações de promoções expiradas
2. **Padronização** - Manter estrutura de flags consistente
3. **Documentação** - Documentar significado de cada flag
4. **Backup regular** - Tabela importante para controle de promoções

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

