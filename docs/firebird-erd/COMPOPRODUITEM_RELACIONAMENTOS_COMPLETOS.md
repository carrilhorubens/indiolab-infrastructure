# COMPOPRODUITEM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOPRODUITEM (Itens de Produtos Compostos)
- **Total de Registros**: 131.181
- **Total de Colunas**: 3
- **Chave Primária**: (COMPPRODUCOD, CPIPROCODIGO) - Composta
- **Chaves Estrangeiras**: 0 (formais)
- **Índices**: 1 (IND_PROCODIGO em CPIPROCODIGO)
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOPRODUITEM** é uma tabela de detalhamento que armazena os itens componentes de produtos compostos, definindo quais produtos e em que quantidades compõem cada produto composto. Com **131.181 registros**, representa a estrutura completa de produtos compostos, permitindo que cada produto composto tenha múltiplos componentes.

Esta tabela funciona como **estrutura de detalhamento de produtos compostos** e permite:
- Definir quais produtos são componentes de cada produto composto
- Especificar quantidades necessárias de cada componente
- Suportar múltiplos componentes por produto composto
- Facilitar cálculo de materiais necessários para produtos compostos
- Suportar gestão de estoque de produtos compostos
- Permitir análise de dependências de produtos

Cada registro representa um item componente específico de um produto composto, contendo:
- Identificação do produto composto (COMPPRODUCOD)
- Identificação do produto componente (CPIPROCODIGO)
- Quantidade necessária do componente (CPIPROQTD)

O sistema utiliza esta tabela em conjunto com COMPOPRODU para determinar a estrutura completa de produtos compostos, permitindo cálculo de materiais necessários e gestão de estoque.

**Observação Importante:** COMPOPRODUITEM trabalha em conjunto com COMPOPRODU para definir produtos compostos. Com 131.181 registros para 51.308 produtos compostos, indica média de 2.56 itens por produto composto, mostrando que produtos compostos têm múltiplos componentes.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPPRODUCOD** 🔑 | INTEGER | ✓ | Código do produto composto (PK, lógica → COMPOPRODU) |
| **CPIPROCODIGO** 🔑 | VARCHAR(37) | ✓ | Código do produto componente (PK, lógica → PRODU) |

### Informações do Item
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPIPROQTD** | NUMERIC(16,4) | ✓ | Quantidade necessária do componente |

**Primary Key:** (COMPPRODUCOD, CPIPROCODIGO)

**Observações sobre Campos:**
- **COMPPRODUCOD**: Produto composto ao qual o item pertence.
- **CPIPROCODIGO**: Produto componente necessário para compor o produto composto.
- **CPIPROQTD**: Quantidade do componente necessária para compor uma unidade do produto composto.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOPRODUITEM Referencia (0 FKs Formais):

**Nenhuma foreign key formal** está definida na tabela COMPOPRODUITEM. No entanto, há relacionamentos lógicos importantes:

#### 1. COMPOPRODU - Produtos Compostos (Lógico)
**Relacionamento Lógico:**
```
COMPOPRODUITEM.COMPPRODUCOD → COMPOPRODU.COMPPRODUCOD (N:1)
```

**Descrição**: Cada item está logicamente vinculado a um produto composto específico.

**Informações da Tabela COMPOPRODU:**
- **Total:** 51.308 produtos compostos
- **PK:** COMPPRODUCOD
- **Colunas:** 2 campos

**Uso:** Identificar o produto composto do item, obter informações do produto composto.

---

#### 2. PRODU - Produtos (Componente) (Lógico)
**Relacionamento Lógico:**
```
COMPOPRODUITEM.CPIPROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição**: Cada item está logicamente vinculado a um produto componente específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto componente do item, obter informações do componente.

---

### COMPOPRODUITEM é Referenciada Por

**Nenhuma tabela** referencia COMPOPRODUITEM diretamente. Esta é uma tabela folha utilizada para detalhamento e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via COMPPRODUCOD → COMPOPRODU → Produtos Compostos

**Fluxo:** COMPOPRODUITEM → COMPOPRODU

**Descrição:** Através do produto composto, é possível obter informações do produto composto.

**Uso:** Obter descrição e informações do produto composto.

---

### Via CPIPROCODIGO → PRODU → COMPO (Composições)

**Fluxo:** COMPOPRODUITEM → PRODU → COMPO

**Descrição:** Através do produto componente, é possível identificar composições relacionadas.

**Uso:** Análise de produtos compostos com composições aninhadas.

---

### Via CPIPROCODIGO → PRODU → ESTOQUE (Estoque)

**Fluxo:** COMPOPRODUITEM → PRODU → ESTOQUE

**Descrição:** Através do produto componente, é possível identificar estoques disponíveis.

**Uso:** Verificar disponibilidade de componentes, cálculo de materiais disponíveis.

---

### Via CPIPROCODIGO → PRODU → PDCAO (Ordens de Produção)

**Fluxo:** COMPOPRODUITEM → PRODU → PDCAO

**Descrição:** Através do produto componente, é possível identificar ordens de produção relacionadas.

**Uso:** Análise de produção de componentes.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Itens de Produto Composto

**Objetivo:** Obter visão completa de todos os itens de um produto composto incluindo informações dos componentes.

**Fluxo:**
```
COMPOPRODUITEM (COMPPRODUCOD, CPIPROCODIGO, CPIPROQTD)
  ↓
COMPOPRODU (COMPPRODUCOD)
  ↓
PRODU (CPIPROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cpi.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA
FROM COMPOPRODUITEM cpi
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = cpi.COMPPRODUCOD
INNER JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
WHERE cpi.COMPPRODUCOD = ?
ORDER BY cpi.CPIPROCODIGO;
```

---

### Exemplo 2: Análise de Itens com Estoque

**Objetivo:** Obter itens de produto composto com informações de estoque dos componentes.

**Fluxo:**
```
COMPOPRODUITEM (COMPPRODUCOD, CPIPROCODIGO)
  ↓
PRODU (CPIPROCODIGO)
  ↓
ESTOQUE (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cpi.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA,
    COALESCE(est.ESTQTDADE, 0) AS ESTOQUE_DISPONIVEL,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= cpi.CPIPROQTD THEN 'SUFICIENTE'
        ELSE 'INSUFICIENTE'
    END AS STATUS_ESTOQUE,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= cpi.CPIPROQTD THEN 0
        ELSE cpi.CPIPROQTD - COALESCE(est.ESTQTDADE, 0)
    END AS QUANTIDADE_FALTANTE
FROM COMPOPRODUITEM cpi
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = cpi.COMPPRODUCOD
INNER JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
LEFT JOIN ESTOQUE est ON est.PROCODIGO = cpi.CPIPROCODIGO
WHERE cpi.COMPPRODUCOD = ?
ORDER BY STATUS_ESTOQUE, cpi.CPIPROCODIGO;
```

---

### Exemplo 3: Análise de Componentes Mais Utilizados

**Objetivo:** Identificar produtos que são componentes mais utilizados em produtos compostos.

**Query SQL:**
```sql
SELECT
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    COUNT(DISTINCT cpi.COMPPRODUCOD) AS TOTAL_PRODUTOS_COMPOSTOS_QUE_USAM,
    SUM(cpi.CPIPROQTD) AS QUANTIDADE_TOTAL_NECESSARIA,
    AVG(cpi.CPIPROQTD) AS QUANTIDADE_MEDIA_NECESSARIA,
    MIN(cpi.CPIPROQTD) AS QUANTIDADE_MINIMA,
    MAX(cpi.CPIPROQTD) AS QUANTIDADE_MAXIMA
FROM COMPOPRODUITEM cpi
INNER JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
GROUP BY cpi.CPIPROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_PRODUTOS_COMPOSTOS_QUE_USAM DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Itens de um Produto Composto

**Objetivo:** Obter todos os itens componentes de um produto composto específico.

```sql
SELECT
    COMPPRODUCOD,
    CPIPROCODIGO AS PRODUTO_COMPONENTE,
    CPIPROQTD AS QUANTIDADE_NECESSARIA
FROM COMPOPRODUITEM
WHERE COMPPRODUCOD = ?
ORDER BY CPIPROCODIGO;
```

---

### 2. Listar Produtos Compostos que Usam um Componente

**Objetivo:** Identificar todos os produtos compostos que utilizam um componente específico.

```sql
SELECT
    cpi.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA
FROM COMPOPRODUITEM cpi
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = cpi.COMPPRODUCOD
WHERE cpi.CPIPROCODIGO = ?
ORDER BY cp.COMPPRODUDESCRICAO;
```

---

### 3. Calcular Materiais Necessários para Produto Composto

**Objetivo:** Calcular quantidade total de componentes necessários para produzir uma quantidade específica de produto composto.

```sql
SELECT
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD * ? AS QUANTIDADE_TOTAL_NECESSARIA
FROM COMPOPRODUITEM cpi
INNER JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
WHERE cpi.COMPPRODUCOD = ?
ORDER BY pr.PRODESCRICAO;
```

---

### 4. Análise de Produtos Compostos Mais Complexos

**Objetivo:** Identificar produtos compostos com mais componentes.

```sql
SELECT
    cpi.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    COUNT(*) AS TOTAL_COMPONENTES,
    SUM(cpi.CPIPROQTD) AS QUANTIDADE_TOTAL_COMPONENTES,
    AVG(cpi.CPIPROQTD) AS QUANTIDADE_MEDIA_COMPONENTES
FROM COMPOPRODUITEM cpi
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = cpi.COMPPRODUCOD
GROUP BY cpi.COMPPRODUCOD, cp.COMPPRODUDESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

### 5. Análise de Componentes com Disponibilidade

**Objetivo:** Verificar disponibilidade de componentes para produtos compostos.

**Query SQL:**
```sql
SELECT
    cpi.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA,
    COALESCE(est.ESTQTDADE, 0) AS ESTOQUE_DISPONIVEL,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= cpi.CPIPROQTD THEN 'SUFICIENTE'
        ELSE 'INSUFICIENTE'
    END AS STATUS_ESTOQUE
FROM COMPOPRODUITEM cpi
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = cpi.COMPPRODUCOD
INNER JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
LEFT JOIN ESTOQUE est ON est.PROCODIGO = cpi.CPIPROCODIGO
ORDER BY cpi.COMPPRODUCOD, STATUS_ESTOQUE, cpi.CPIPROCODIGO;
```

---

### 6. Análise de Produtos Compostos com Dependências

**Objetivo:** Identificar produtos compostos que têm componentes que também são produtos compostos (dependências aninhadas).

**Query SQL:**
```sql
SELECT
    cpi1.COMPPRODUCOD AS PRODUTO_COMPOSTO_NIVEL_1,
    cp1.COMPPRODUDESCRICAO AS DESCRICAO_NIVEL_1,
    cpi1.CPIPROCODIGO AS COMPONENTE_NIVEL_1,
    pr1.PRODESCRICAO AS DESCRICAO_COMPONENTE_NIVEL_1,
    cpi2.COMPPRODUCOD AS PRODUTO_COMPOSTO_NIVEL_2,
    cp2.COMPPRODUDESCRICAO AS DESCRICAO_NIVEL_2,
    cpi2.CPIPROCODIGO AS COMPONENTE_NIVEL_2,
    pr2.PRODESCRICAO AS DESCRICAO_COMPONENTE_NIVEL_2
FROM COMPOPRODUITEM cpi1
INNER JOIN COMPOPRODU cp1 ON cp1.COMPPRODUCOD = cpi1.COMPPRODUCOD
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = cpi1.CPIPROCODIGO
INNER JOIN COMPOPRODUITEM cpi2 ON cpi2.COMPPRODUCOD = CAST(cpi1.CPIPROCODIGO AS INTEGER)
INNER JOIN COMPOPRODU cp2 ON cp2.COMPPRODUCOD = cpi2.COMPPRODUCOD
INNER JOIN PRODU pr2 ON pr2.PROCODIGO = cpi2.CPIPROCODIGO
ORDER BY cpi1.COMPPRODUCOD, cpi1.CPIPROCODIGO;
```

---

### 7. Relatório de Produtos Compostos

**Objetivo:** Analisar distribuição completa de produtos compostos e seus componentes.

**Query SQL:**
```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    COUNT(cpi.CPIPROCODIGO) AS TOTAL_COMPONENTES,
    SUM(cpi.CPIPROQTD) AS QUANTIDADE_TOTAL_COMPONENTES,
    AVG(cpi.CPIPROQTD) AS QUANTIDADE_MEDIA_COMPONENTES,
    MIN(cpi.CPIPROQTD) AS QUANTIDADE_MINIMA,
    MAX(cpi.CPIPROQTD) AS QUANTIDADE_MAXIMA
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
GROUP BY cp.COMPPRODUCOD, cp.COMPPRODUDESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOPRODUITEM | Tipo |
|--------|-----------|---------------------|------|
| **COMPOPRODUITEM** | 131.181 | 1:1 | **TABELA PRINCIPAL** |
| COMPOPRODU | 51.308 | 0.39:1 | Produtos compostos (média de 2.56 itens por produto composto) |
| PRODU | 178.187 | 1.36:1 | Produtos (média de 0.74 itens por produto) |

**Interpretação:**
- **131.181 itens** cadastrados no sistema
- **Média de 2.56 itens por produto composto** - produtos compostos têm múltiplos componentes
- **74% dos produtos** são componentes de pelo menos um produto composto (131.181 de 178.187)
- **Uso extensivo** - indica estrutura complexa de produtos compostos

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_PROCODIGO** - Índice em CPIPROCODIGO

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por produto composto** - Para buscas por produto composto
3. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto composto (consultas frequentes)
CREATE INDEX IDX_COMPOPRODUITEM_PRODUTO_COMPOSTO ON COMPOPRODUITEM(COMPPRODUCOD);

-- Índice 2: Busca composta por produto composto e componente (consultas de validação)
CREATE INDEX IDX_COMPOPRODUITEM_COMP_PRO ON COMPOPRODUITEM(COMPPRODUCOD, CPIPROCODIGO);
```

### Observações sobre Volume

- **Tabela média-grande** (131.181 registros) - Performance boa com índices adequados
- **Índice existente** - Em CPIPROCODIGO é útil para buscas por componente
- **Consultas frequentes** - Itens são consultados durante criação de pedidos e produção
- **Índices essenciais** - Em COMPPRODUCOD e CPIPROCODIGO para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Lógica

```sql
-- Verificar itens sem produto composto válido
SELECT DISTINCT cpi.COMPPRODUCOD
FROM COMPOPRODUITEM cpi
WHERE NOT EXISTS (SELECT 1 FROM COMPOPRODU cp WHERE cp.COMPPRODUCOD = cpi.COMPPRODUCOD);

-- Verificar itens sem produto componente válido
SELECT DISTINCT cpi.CPIPROCODIGO
FROM COMPOPRODUITEM cpi
WHERE cpi.CPIPROCODIGO IS NOT NULL
  AND cpi.CPIPROCODIGO != ''
  AND NOT EXISTS (SELECT 1 FROM PRODU pr WHERE pr.PROCODIGO = cpi.CPIPROCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOPRODUITEM
WHERE COMPPRODUCOD IS NULL
   OR CPIPROCODIGO IS NULL
   OR CPIPROCODIGO = ''
   OR CPIPROQTD IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT COMPPRODUCOD, CPIPROCODIGO, COUNT(*) AS QTD
FROM COMPOPRODUITEM
GROUP BY COMPPRODUCOD, CPIPROCODIGO
HAVING COUNT(*) > 1;

-- Verificar quantidades inválidas
SELECT *
FROM COMPOPRODUITEM
WHERE CPIPROQTD <= 0;
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

final class FirebirdCompoproduitem extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOPRODUITEM';
    
    protected $primaryKey = ['COMPPRODUCOD', 'CPIPROCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'COMPPRODUCOD' => 'integer',
        'CPIPROCODIGO' => 'string',
        'CPIPROQTD' => 'decimal:4',
    ];

    // Relacionamento lógico com COMPOPRODU
    public function produtoComposto(): BelongsTo
    {
        return $this->belongsTo(FirebirdCompoprodu::class, 'COMPPRODUCOD', 'COMPPRODUCOD');
    }

    // Relacionamento lógico com PRODU
    public function produtoComponente(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'CPIPROCODIGO', 'PROCODIGO');
    }

    // Scope para filtrar por produto composto
    public function scopePorProdutoComposto($query, int $produtoCompostoCodigo)
    {
        return $query->where('COMPPRODUCOD', $produtoCompostoCodigo);
    }

    // Scope para filtrar por produto componente
    public function scopePorProdutoComponente($query, string $produtoCodigo)
    {
        return $query->where('CPIPROCODIGO', $produtoCodigo);
    }

    // Método estático para buscar itens de um produto composto
    public static function buscarItensProdutoComposto(int $produtoCompostoCodigo): \Illuminate\Support\Collection
    {
        return self::where('COMPPRODUCOD', $produtoCompostoCodigo)
            ->with('produtoComponente')
            ->orderBy('CPIPROCODIGO')
            ->get();
    }

    // Método estático para calcular materiais necessários
    public static function calcularMateriaisNecessarios(int $produtoCompostoCodigo, float $quantidade): array
    {
        $itens = self::where('COMPPRODUCOD', $produtoCompostoCodigo)
            ->with('produtoComponente')
            ->get();
        
        $materiais = [];
        
        foreach ($itens as $item) {
            $quantidadeNecessaria = (float)$item->CPIPROQTD * $quantidade;
            
            $materiais[] = [
                'produto' => $item->CPIPROCODIGO,
                'descricao' => $item->produtoComponente->PRODESCRICAO ?? '',
                'quantidade' => $quantidadeNecessaria,
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
2. **Validação antes de inserir** - Verificar se produto composto e componente existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de quantidades** - Verificar valores positivos e válidos

### Performance

1. **Tabela média-grande** - 131.181 registros, performance boa com índices adequados
2. **Índices essenciais** - Em COMPPRODUCOD e CPIPROCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (produto composto + componente)
4. **Consultas frequentes** - Itens são consultados durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de quantidades** - Verificar valores positivos

### Manutenção

1. **Revisão periódica** - Verificar itens não utilizados
2. **Padronização** - Manter estrutura consistente
3. **Documentação** - Documentar significado de cada item
4. **Backup regular** - Tabela importante para gestão de produtos compostos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

