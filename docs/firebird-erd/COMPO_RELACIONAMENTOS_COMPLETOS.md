# COMPO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPO (Composição de Produtos)
- **Total de Registros**: 108.055
- **Total de Colunas**: 6
- **Chave Primária**: (PROCODIGO, CMPCODIGO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPO** é uma tabela de composição que armazena informações sobre componentes de produtos, definindo quais produtos são necessários para compor outros produtos e em que quantidades. Com **108.055 registros**, representa uma estrutura extensiva de composições de produtos, essencial para o processo de produção e montagem.

Esta tabela funciona como **estrutura de composição de produtos (BOM - Bill of Materials)** e permite:
- Definir quais produtos são componentes de outros produtos
- Especificar quantidades necessárias de cada componente
- Controlar perdas na produção através de percentual de perda
- Prevenir criação automática de novas ordens de produção quando necessário
- Suportar múltiplos componentes por produto
- Facilitar cálculo de materiais necessários para produção

Cada registro representa um componente específico de um produto, contendo:
- Identificação do produto principal (PROCODIGO)
- Código sequencial do componente (CMPCODIGO)
- Identificação do produto componente (PROCODIGO2)
- Quantidade necessária do componente (CMPQTDADE)
- Percentual de perda (CMPPCPERDA)
- Flag para não forçar nova PDC (NAOFORCANOVAPDC)

O sistema utiliza esta tabela para determinar quais materiais são necessários para produzir um produto, calcular quantidades de componentes necessários, e controlar o processo de produção.

**Observação Importante:** COMPO é fundamental para o sistema de produção, permitindo que produtos sejam decompostos em seus componentes. Com 108.055 registros, indica uso extensivo de composições de produtos, essencial para indústria óptica onde produtos finais são compostos por múltiplos componentes.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔑🔗 | VARCHAR(14) | ✓ | Código do produto principal (PK + FK → PRODU) |
| **CMPCODIGO** 🔑 | SMALLINT | ✓ | Código sequencial do componente (PK) |

### Informações do Componente
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO2** 🔗 | VARCHAR(14) | ✓ | Código do produto componente (FK → PRODU) |
| **CMPQTDADE** | NUMERIC(16,4) | ✓ | Quantidade necessária do componente |

### Controle de Produção
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CMPPCPERDA** | SMALLINT | | Percentual de perda na produção |
| **NAOFORCANOVAPDC** | VARCHAR(14) | | Flag indicando se não deve forçar criação de nova ordem de produção |

**Primary Key:** (PROCODIGO, CMPCODIGO)

**Observações sobre Campos:**
- **PROCODIGO**: Produto principal que será composto.
- **CMPCODIGO**: Código sequencial que identifica cada componente do produto (1, 2, 3, etc.).
- **PROCODIGO2**: Produto componente necessário para compor o produto principal.
- **CMPQTDADE**: Quantidade do componente necessária para produzir uma unidade do produto principal.
- **CMPPCPERDA**: Percentual de perda esperado na produção (ex: 5% = 5).
- **NAOFORCANOVAPDC**: Flag que indica se o sistema não deve criar automaticamente uma nova ordem de produção para este componente quando necessário.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPO Referencia (2 FKs):

#### 1. PRODU - Produtos (Principal)
**Relacionamento:**
```
COMPO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_COMPO
```

**Descrição**: Cada composição está vinculada a um produto principal específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos
- **FK Out:** 0
- **FK In:** 101 tabelas

**Uso:** Identificar o produto principal da composição, obter informações do produto.

---

#### 2. PRODU - Produtos (Componente)
**Relacionamento:**
```
COMPO.PROCODIGO2 → PRODU.PROCODIGO (N:1)
Constraint: PRODU2_COMPO
```

**Descrição**: Cada composição está vinculada a um produto componente específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto componente da composição, obter informações do componente.

---

### COMPO é Referenciada Por

**Nenhuma tabela** referencia COMPO diretamente através de foreign keys formais. No entanto, há relacionamentos lógicos com:
- **COMPOPDC** - através de PROCODIGO e PROCODIGO2
- **COMPOPROROT** - através de PROCODIGO e COMPOCOD (lógico)
- **COMPOPROROTALX** - através de PROCODIGO e COMPOCOD (lógico)

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PROCODIGO → PDCAO (Ordens de Produção)

**Fluxo:** COMPO → PRODU → PDCAO

**Descrição:** Através do produto principal, é possível identificar ordens de produção que utilizam esta composição.

**Uso:** Calcular materiais necessários para ordens de produção, análise de consumo de componentes.

---

### Via PROCODIGO2 → PDCAO (Ordens de Produção do Componente)

**Fluxo:** COMPO → PRODU → PDCAO

**Descrição:** Através do produto componente, é possível identificar ordens de produção que produzem este componente.

**Uso:** Análise de dependências de produção, cálculo de lead time.

---

### Via PROCODIGO → PDPRD (Produtos em Pedidos)

**Fluxo:** COMPO → PRODU → PDPRD

**Descrição:** Através do produto principal, é possível identificar pedidos que solicitam produtos compostos.

**Uso:** Análise de demanda de componentes, cálculo de materiais necessários para pedidos.

---

### Via PROCODIGO → ESTOQUE (Estoque)

**Fluxo:** COMPO → PRODU → ESTOQUE

**Descrição:** Através dos produtos, é possível identificar estoques de produtos principais e componentes.

**Uso:** Verificar disponibilidade de componentes, cálculo de materiais disponíveis.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Composição de Produto

**Objetivo:** Obter visão completa de uma composição incluindo informações dos produtos principal e componentes.

**Fluxo:**
```
COMPO (PROCODIGO, CMPCODIGO, PROCODIGO2, CMPQTDADE)
  ↓
PRODU (PROCODIGO) - Produto Principal
  ↓
PRODU (PROCODIGO2) - Produto Componente
```

**Query SQL:**
```sql
SELECT
    co.PROCODIGO,
    pr1.PRODESCRICAO AS PRODUTO_PRINCIPAL,
    co.CMPCODIGO,
    co.PROCODIGO2,
    pr2.PRODESCRICAO AS PRODUTO_COMPONENTE,
    co.CMPQTDADE AS QUANTIDADE_NECESSARIA,
    co.CMPPCPERDA AS PERCENTUAL_PERDA,
    CASE 
        WHEN co.CMPPCPERDA IS NOT NULL THEN co.CMPQTDADE * (1 + co.CMPPCPERDA / 100.0)
        ELSE co.CMPQTDADE
    END AS QUANTIDADE_COM_PERDA,
    co.NAOFORCANOVAPDC AS NAO_FORCAR_NOVA_PDC
FROM COMPO co
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = co.PROCODIGO2
WHERE co.PROCODIGO = ?
ORDER BY co.CMPCODIGO;
```

---

### Exemplo 2: Análise de Componentes com Estoque

**Objetivo:** Obter composição de um produto com informações de estoque dos componentes.

**Fluxo:**
```
COMPO (PROCODIGO, PROCODIGO2)
  ↓
PRODU (PROCODIGO2)
  ↓
ESTOQUE (PROCODIGO2)
```

**Query SQL:**
```sql
SELECT
    co.PROCODIGO,
    pr1.PRODESCRICAO AS PRODUTO_PRINCIPAL,
    co.PROCODIGO2,
    pr2.PRODESCRICAO AS PRODUTO_COMPONENTE,
    co.CMPQTDADE AS QUANTIDADE_NECESSARIA,
    COALESCE(est.ESTQTDADE, 0) AS ESTOQUE_DISPONIVEL,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= co.CMPQTDADE THEN 'SUFICIENTE'
        ELSE 'INSUFICIENTE'
    END AS STATUS_ESTOQUE,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= co.CMPQTDADE THEN 0
        ELSE co.CMPQTDADE - COALESCE(est.ESTQTDADE, 0)
    END AS QUANTIDADE_FALTANTE
FROM COMPO co
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = co.PROCODIGO2
LEFT JOIN ESTOQUE est ON est.PROCODIGO = co.PROCODIGO2
WHERE co.PROCODIGO = ?
ORDER BY co.CMPCODIGO;
```

---

### Exemplo 3: Análise de Composições com Ordens de Produção

**Objetivo:** Obter composições com informações de ordens de produção relacionadas.

**Fluxo:**
```
COMPO (PROCODIGO, PROCODIGO2)
  ↓
PRODU (PROCODIGO)
  ↓
PDCAO (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    co.PROCODIGO,
    pr1.PRODESCRICAO AS PRODUTO_PRINCIPAL,
    co.PROCODIGO2,
    pr2.PRODESCRICAO AS PRODUTO_COMPONENTE,
    co.CMPQTDADE AS QUANTIDADE_NECESSARIA,
    COUNT(DISTINCT pdc.PDCCODIGO) AS TOTAL_ORDENS_PRODUCAO,
    SUM(pdc.PDCQTDEPEDIDO) AS QUANTIDADE_TOTAL_PRODUZIR,
    SUM(pdc.PDCQTDEPEDIDO * co.CMPQTDADE) AS QUANTIDADE_TOTAL_COMPONENTES_NECESSARIOS
FROM COMPO co
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = co.PROCODIGO2
LEFT JOIN PDCAO pdc ON pdc.PROCODIGO = co.PROCODIGO
  AND pdc.PDCSITUACAO IN ('A', 'P')
GROUP BY co.PROCODIGO, pr1.PRODESCRICAO, co.PROCODIGO2, pr2.PRODESCRICAO, co.CMPQTDADE
ORDER BY QUANTIDADE_TOTAL_COMPONENTES_NECESSARIOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Composição de um Produto

**Objetivo:** Obter todos os componentes de um produto específico.

```sql
SELECT
    CMPCODIGO,
    PROCODIGO2 AS PRODUTO_COMPONENTE,
    CMPQTDADE AS QUANTIDADE_NECESSARIA,
    CMPPCPERDA AS PERCENTUAL_PERDA,
    NAOFORCANOVAPDC AS NAO_FORCAR_NOVA_PDC
FROM COMPO
WHERE PROCODIGO = ?
ORDER BY CMPCODIGO;
```

---

### 2. Listar Produtos que Usam um Componente

**Objetivo:** Identificar todos os produtos que utilizam um componente específico.

```sql
SELECT
    co.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO_PRINCIPAL,
    co.CMPQTDADE AS QUANTIDADE_NECESSARIA,
    co.CMPPCPERDA AS PERCENTUAL_PERDA
FROM COMPO co
INNER JOIN PRODU pr ON pr.PROCODIGO = co.PROCODIGO
WHERE co.PROCODIGO2 = ?
ORDER BY pr.PRODESCRICAO;
```

---

### 3. Calcular Materiais Necessários para Produção

**Objetivo:** Calcular quantidade total de componentes necessários para produzir uma quantidade específica de um produto.

```sql
SELECT
    co.PROCODIGO2 AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    SUM(co.CMPQTDADE * ?) AS QUANTIDADE_TOTAL_NECESSARIA,
    SUM(CASE 
        WHEN co.CMPPCPERDA IS NOT NULL THEN co.CMPQTDADE * ? * (1 + co.CMPPCPERDA / 100.0)
        ELSE co.CMPQTDADE * ?
    END) AS QUANTIDADE_COM_PERDA
FROM COMPO co
INNER JOIN PRODU pr ON pr.PROCODIGO = co.PROCODIGO2
WHERE co.PROCODIGO = ?
GROUP BY co.PROCODIGO2, pr.PRODESCRICAO
ORDER BY pr.PRODESCRICAO;
```

---

### 4. Análise de Produtos Mais Compostos

**Objetivo:** Identificar produtos que têm mais componentes na composição.

```sql
SELECT
    co.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    COUNT(*) AS TOTAL_COMPONENTES,
    SUM(co.CMPQTDADE) AS QUANTIDADE_TOTAL_COMPONENTES,
    AVG(co.CMPQTDADE) AS QUANTIDADE_MEDIA_COMPONENTES
FROM COMPO co
INNER JOIN PRODU pr ON pr.PROCODIGO = co.PROCODIGO
GROUP BY co.PROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

### 5. Análise de Componentes Mais Utilizados

**Objetivo:** Identificar componentes que são mais utilizados em diferentes produtos.

```sql
SELECT
    co.PROCODIGO2 AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    COUNT(DISTINCT co.PROCODIGO) AS TOTAL_PRODUTOS_QUE_USAM,
    AVG(co.CMPQTDADE) AS QUANTIDADE_MEDIA_NECESSARIA,
    SUM(co.CMPQTDADE) AS QUANTIDADE_TOTAL_NECESSARIA
FROM COMPO co
INNER JOIN PRODU pr ON pr.PROCODIGO = co.PROCODIGO2
GROUP BY co.PROCODIGO2, pr.PRODESCRICAO
ORDER BY TOTAL_PRODUTOS_QUE_USAM DESC;
```

---

### 6. Verificar Composições com Perdas Configuradas

**Objetivo:** Identificar composições que têm percentual de perda configurado.

```sql
SELECT
    co.PROCODIGO,
    pr1.PRODESCRICAO AS PRODUTO_PRINCIPAL,
    co.PROCODIGO2,
    pr2.PRODESCRICAO AS PRODUTO_COMPONENTE,
    co.CMPQTDADE AS QUANTIDADE_BASE,
    co.CMPPCPERDA AS PERCENTUAL_PERDA,
    co.CMPQTDADE * (1 + co.CMPPCPERDA / 100.0) AS QUANTIDADE_COM_PERDA,
    co.CMPQTDADE * (co.CMPPCPERDA / 100.0) AS QUANTIDADE_PERDA
FROM COMPO co
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = co.PROCODIGO2
WHERE co.CMPPCPERDA IS NOT NULL
  AND co.CMPPCPERDA > 0
ORDER BY co.CMPPCPERDA DESC;
```

---

### 7. Análise de Composições com Dependências de Produção

**Objetivo:** Identificar componentes que também são produtos compostos (composições aninhadas).

**Query SQL:**
```sql
SELECT
    co1.PROCODIGO AS PRODUTO_PRINCIPAL,
    pr1.PRODESCRICAO AS DESCRICAO_PRINCIPAL,
    co1.PROCODIGO2 AS COMPONENTE_NIVEL_1,
    pr2.PRODESCRICAO AS DESCRICAO_COMPONENTE_NIVEL_1,
    co2.PROCODIGO2 AS COMPONENTE_NIVEL_2,
    pr3.PRODESCRICAO AS DESCRICAO_COMPONENTE_NIVEL_2,
    co1.CMPQTDADE AS QTD_NIVEL_1,
    co2.CMPQTDADE AS QTD_NIVEL_2,
    co1.CMPQTDADE * co2.CMPQTDADE AS QTD_TOTAL_NIVEL_2
FROM COMPO co1
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co1.PROCODIGO
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = co1.PROCODIGO2
INNER JOIN COMPO co2 ON co2.PROCODIGO = co1.PROCODIGO2
INNER JOIN PRODU pr3 ON pr3.PROCODIGO = co2.PROCODIGO2
ORDER BY co1.PROCODIGO, co1.CMPCODIGO, co2.CMPCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPO | Tipo |
|--------|-----------|---------------------|------|
| **COMPO** | 108.055 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | 178.187 | 1.65:1 | Produtos (média de 0.61 composições por produto) |
| PDCAO | 3.201.636 | 29.64:1 | Ordens de produção (média de 0.034 composições por OP) |

**Interpretação:**
- **108.055 composições** cadastradas no sistema
- **61% dos produtos** têm pelo menos um componente na composição (108.055 de 178.187)
- **Uso extensivo** - indica que a maioria dos produtos são compostos por outros produtos
- **Média de 0.61 composições por produto** - muitos produtos têm múltiplos componentes

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela COMPO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por produto principal** - Para buscas por produto principal
3. **Índice por produto componente** - Para buscas por componente
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto principal (consultas frequentes)
CREATE INDEX IDX_COMPO_PRODUTO_PRINCIPAL ON COMPO(PROCODIGO);

-- Índice 2: Busca por produto componente (consultas frequentes)
CREATE INDEX IDX_COMPO_PRODUTO_COMPONENTE ON COMPO(PROCODIGO2);

-- Índice 3: Busca composta por produto principal e código (consultas de validação)
CREATE INDEX IDX_COMPO_PRO_COD ON COMPO(PROCODIGO, CMPCODIGO);
```

### Observações sobre Volume

- **Tabela média-grande** (108.055 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Composições são consultadas durante criação de ordens de produção
- **Índices essenciais** - Em PROCODIGO e PROCODIGO2 para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por produto principal

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar composições sem produto principal válido
SELECT co.*
FROM COMPO co
LEFT JOIN PRODU pr1 ON pr1.PROCODIGO = co.PROCODIGO
WHERE pr1.PROCODIGO IS NULL;

-- Verificar composições sem produto componente válido
SELECT co.*
FROM COMPO co
LEFT JOIN PRODU pr2 ON pr2.PROCODIGO = co.PROCODIGO2
WHERE pr2.PROCODIGO IS NULL;

-- Verificar composições onde produto principal é igual ao componente
SELECT *
FROM COMPO
WHERE PROCODIGO = PROCODIGO2;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPO
WHERE PROCODIGO IS NULL
   OR PROCODIGO = ''
   OR CMPCODIGO IS NULL
   OR PROCODIGO2 IS NULL
   OR PROCODIGO2 = ''
   OR CMPQTDADE IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT PROCODIGO, CMPCODIGO, COUNT(*) AS QTD
FROM COMPO
GROUP BY PROCODIGO, CMPCODIGO
HAVING COUNT(*) > 1;

-- Verificar quantidades inválidas
SELECT *
FROM COMPO
WHERE CMPQTDADE <= 0;

-- Verificar percentuais de perda inválidos
SELECT *
FROM COMPO
WHERE CMPPCPERDA < 0
   OR CMPPCPERDA > 100;
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

final class FirebirdCompo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPO';
    
    protected $primaryKey = ['PROCODIGO', 'CMPCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'PROCODIGO' => 'string',
        'CMPCODIGO' => 'integer',
        'PROCODIGO2' => 'string',
        'CMPQTDADE' => 'decimal:4',
        'CMPPCPERDA' => 'integer',
        'NAOFORCANOVAPDC' => 'string',
    ];

    // Relacionamento com PRODU (produto principal)
    public function produtoPrincipal(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Relacionamento com PRODU (produto componente)
    public function produtoComponente(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO2', 'PROCODIGO');
    }

    // Método para calcular quantidade com perda
    public function getQuantidadeComPerda(): float
    {
        $quantidade = (float)$this->CMPQTDADE;
        
        if ($this->CMPPCPERDA) {
            return $quantidade * (1 + ($this->CMPPCPERDA / 100));
        }
        
        return $quantidade;
    }

    // Método para verificar se não deve forçar nova PDC
    public function naoForcarNovaPdc(): bool
    {
        return !empty($this->NAOFORCANOVAPDC) && strtoupper($this->NAOFORCANOVAPDC) === 'S';
    }

    // Scope para filtrar por produto principal
    public function scopePorProdutoPrincipal($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    // Scope para filtrar por produto componente
    public function scopePorProdutoComponente($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO2', $produtoCodigo);
    }

    // Método estático para buscar composição de um produto
    public static function buscarComposicao(string $produtoCodigo): \Illuminate\Support\Collection
    {
        return self::where('PROCODIGO', $produtoCodigo)
            ->with('produtoComponente')
            ->orderBy('CMPCODIGO')
            ->get();
    }

    // Método estático para calcular materiais necessários
    public static function calcularMateriaisNecessarios(string $produtoCodigo, float $quantidade): array
    {
        $componentes = self::where('PROCODIGO', $produtoCodigo)
            ->with('produtoComponente')
            ->get();
        
        $materiais = [];
        
        foreach ($componentes as $componente) {
            $quantidadeNecessaria = $componente->CMPQTDADE * $quantidade;
            $quantidadeComPerda = $componente->getQuantidadeComPerda() * $quantidade;
            
            $materiais[] = [
                'produto' => $componente->PROCODIGO2,
                'descricao' => $componente->produtoComponente->PRODESCRICAO ?? '',
                'quantidade_base' => $quantidadeNecessaria,
                'quantidade_com_perda' => $quantidadeComPerda,
                'percentual_perda' => $componente->CMPPCPERDA,
            ];
        }
        
        return $materiais;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se produtos existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de quantidades** - Verificar valores positivos e válidos
5. **Validação de perdas** - Verificar percentuais entre 0 e 100

### Performance

1. **Tabela média-grande** - 108.055 registros, performance boa com índices adequados
2. **Índices essenciais** - Em PROCODIGO e PROCODIGO2 para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (produto + código)
4. **Consultas frequentes** - Composições são consultadas durante criação de ordens de produção

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se produtos existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de quantidades** - Verificar valores positivos
5. **Validação de perdas** - Verificar percentuais válidos

### Manutenção

1. **Revisão periódica** - Verificar composições não utilizadas
2. **Padronização** - Manter estrutura de códigos consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para processo de produção

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

