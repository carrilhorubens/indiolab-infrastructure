# COMPOPRODU - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOPRODU (Produtos Compostos)
- **Total de Registros**: 51.308
- **Total de Colunas**: 2
- **Chave Primária**: COMPPRODUCOD (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (COMPOPRODUITEM)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOPRODU** é uma tabela mestre que armazena informações sobre produtos compostos do sistema. Com **51.308 registros**, representa produtos compostos cadastrados, permitindo gerenciar produtos que são formados por combinações de outros produtos.

Esta tabela funciona como **catálogo de produtos compostos** e permite:
- Cadastrar produtos compostos com descrições específicas
- Identificar produtos que são combinações de outros produtos
- Suportar estrutura hierárquica de produtos compostos
- Facilitar gestão de produtos complexos
- Suportar múltiplos itens por produto composto

Cada registro representa um produto composto específico, contendo:
- Código único do produto composto (COMPPRODUCOD)
- Descrição do produto composto (COMPPRODUDESCRICAO)

O sistema utiliza esta tabela como referência para produtos compostos, que são detalhados na tabela COMPOPRODUITEM com seus componentes específicos.

**Observação Importante:** COMPOPRODU é uma tabela mestre complementar a PRODU. Enquanto PRODU tem 178.187 produtos, COMPOPRODU tem 51.308 produtos compostos, indicando que aproximadamente 29% dos produtos são produtos compostos. Esta tabela trabalha em conjunto com COMPOPRODUITEM para definir a estrutura completa dos produtos compostos.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPPRODUCOD** 🔑 | INTEGER | ✓ | Código único do produto composto |

### Informações do Produto Composto
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPPRODUDESCRICAO** | VARCHAR(37) | | Descrição do produto composto |

**Primary Key:** COMPPRODUCOD

**Observações sobre Campos:**
- **COMPPRODUCOD**: Identificador único de cada produto composto.
- **COMPPRODUDESCRICAO**: Descrição ou nome do produto composto.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOPRODU Referencia

**Nenhuma foreign key formal** está definida na tabela COMPOPRODU.

---

### COMPOPRODU é Referenciada Por (1 tabela):

#### 1. COMPOPRODUITEM - Itens de Produtos Compostos
**Relacionamento Lógico:**
```
COMPOPRODUITEM.COMPPRODUCOD → COMPOPRODU.COMPPRODUCOD (N:1)
```

**Descrição**: COMPOPRODUITEM referencia COMPOPRODU para obter informações do produto composto e adicionar itens componentes.

**Informações da Tabela COMPOPRODUITEM:**
- **Total:** 131.181 registros
- **PK:** (COMPPRODUCOD, CPIPROCODIGO)
- **Colunas:** 3 campos

**Uso:** COMPOPRODUITEM estende COMPOPRODU com itens componentes específicos (produtos e quantidades).

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via COMPOPRODUITEM → PRODU (Produtos Componentes)

**Fluxo:** COMPOPRODU → COMPOPRODUITEM → PRODU

**Descrição:** Através de COMPOPRODUITEM, é possível identificar produtos que são componentes dos produtos compostos.

**Uso:** Obter lista de componentes de um produto composto, análises de dependências.

---

### Via COMPOPRODUITEM → PRODU → COMPO (Composições)

**Fluxo:** COMPOPRODU → COMPOPRODUITEM → PRODU → COMPO

**Descrição:** Através dos produtos componentes, é possível identificar composições relacionadas.

**Uso:** Análise de produtos compostos com composições aninhadas.

---

### Via COMPOPRODUITEM → PRODU → PDCAO (Ordens de Produção)

**Fluxo:** COMPOPRODU → COMPOPRODUITEM → PRODU → PDCAO

**Descrição:** Através dos produtos componentes, é possível identificar ordens de produção relacionadas.

**Uso:** Análise de produção de produtos compostos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Produto Composto

**Objetivo:** Obter visão completa de um produto composto incluindo todos os seus itens componentes.

**Fluxo:**
```
COMPOPRODU (COMPPRODUCOD, COMPPRODUDESCRICAO)
  ↓
COMPOPRODUITEM (COMPPRODUCOD, CPIPROCODIGO, CPIPROQTD)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
WHERE cp.COMPPRODUCOD = ?
ORDER BY cpi.CPIPROCODIGO;
```

---

### Exemplo 2: Análise de Produtos Compostos com Estoque

**Objetivo:** Obter produtos compostos com informações de estoque dos componentes.

**Fluxo:**
```
COMPOPRODU (COMPPRODUCOD)
  ↓
COMPOPRODUITEM (COMPPRODUCOD, CPIPROCODIGO)
  ↓
PRODU (PROCODIGO)
  ↓
ESTOQUE (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA,
    COALESCE(est.ESTQTDADE, 0) AS ESTOQUE_DISPONIVEL,
    CASE 
        WHEN COALESCE(est.ESTQTDADE, 0) >= cpi.CPIPROQTD THEN 'SUFICIENTE'
        ELSE 'INSUFICIENTE'
    END AS STATUS_ESTOQUE
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
LEFT JOIN ESTOQUE est ON est.PROCODIGO = cpi.CPIPROCODIGO
WHERE cp.COMPPRODUCOD = ?
ORDER BY STATUS_ESTOQUE, cpi.CPIPROCODIGO;
```

---

### Exemplo 3: Análise de Produtos Compostos Mais Complexos

**Objetivo:** Identificar produtos compostos com mais componentes.

**Query SQL:**
```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    COUNT(cpi.CPIPROCODIGO) AS TOTAL_COMPONENTES,
    SUM(cpi.CPIPROQTD) AS QUANTIDADE_TOTAL_COMPONENTES,
    AVG(cpi.CPIPROQTD) AS QUANTIDADE_MEDIA_COMPONENTES
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
GROUP BY cp.COMPPRODUCOD, cp.COMPPRODUDESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Produto Composto

**Objetivo:** Obter informações de um produto composto específico.

```sql
SELECT
    COMPPRODUCOD,
    COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO
FROM COMPOPRODU
WHERE COMPPRODUCOD = ?;
```

---

### 2. Listar Todos os Produtos Compostos

**Objetivo:** Obter todos os produtos compostos cadastrados.

```sql
SELECT
    COMPPRODUCOD,
    COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO
FROM COMPOPRODU
ORDER BY COMPPRODUDESCRICAO;
```

---

### 3. Buscar Produtos Compostos com Componentes

**Objetivo:** Obter produtos compostos com seus componentes.

```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    cpi.CPIPROQTD AS QUANTIDADE_NECESSARIA
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
ORDER BY cp.COMPPRODUDESCRICAO, cpi.CPIPROCODIGO;
```

---

### 4. Análise de Produtos Compostos Sem Componentes

**Objetivo:** Identificar produtos compostos que não têm componentes cadastrados.

```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
WHERE cpi.COMPPRODUCOD IS NULL
ORDER BY cp.COMPPRODUDESCRICAO;
```

---

### 5. Análise de Componentes Mais Utilizados

**Objetivo:** Identificar produtos que são componentes mais utilizados em produtos compostos.

**Query SQL:**
```sql
SELECT
    cpi.CPIPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_COMPONENTE,
    COUNT(DISTINCT cpi.COMPPRODUCOD) AS TOTAL_PRODUTOS_COMPOSTOS_QUE_USAM,
    SUM(cpi.CPIPROQTD) AS QUANTIDADE_TOTAL_NECESSARIA,
    AVG(cpi.CPIPROQTD) AS QUANTIDADE_MEDIA_NECESSARIA
FROM COMPOPRODUITEM cpi
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpi.CPIPROCODIGO
GROUP BY cpi.CPIPROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_PRODUTOS_COMPOSTOS_QUE_USAM DESC;
```

---

### 6. Análise de Produtos Compostos com Disponibilidade

**Objetivo:** Verificar disponibilidade de componentes para produtos compostos.

**Query SQL:**
```sql
SELECT
    cp.COMPPRODUCOD,
    cp.COMPPRODUDESCRICAO AS PRODUTO_COMPOSTO,
    COUNT(DISTINCT cpi.CPIPROCODIGO) AS TOTAL_COMPONENTES,
    COUNT(CASE WHEN COALESCE(est.ESTQTDADE, 0) >= cpi.CPIPROQTD THEN 1 END) AS COMPONENTES_DISPONIVEIS,
    COUNT(CASE WHEN COALESCE(est.ESTQTDADE, 0) < cpi.CPIPROQTD THEN 1 END) AS COMPONENTES_FALTANTES,
    CASE 
        WHEN COUNT(CASE WHEN COALESCE(est.ESTQTDADE, 0) < cpi.CPIPROQTD THEN 1 END) = 0 THEN 'DISPONIVEL'
        ELSE 'FALTANTE'
    END AS STATUS_DISPONIBILIDADE
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
LEFT JOIN ESTOQUE est ON est.PROCODIGO = cpi.CPIPROCODIGO
GROUP BY cp.COMPPRODUCOD, cp.COMPPRODUDESCRICAO
ORDER BY STATUS_DISPONIBILIDADE, cp.COMPPRODUDESCRICAO;
```

---

### 7. Relatório de Produtos Compostos

**Objetivo:** Analisar distribuição completa de produtos compostos.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_PRODUTOS_COMPOSTOS,
    COUNT(DISTINCT cpi.COMPPRODUCOD) AS PRODUTOS_COM_COMPONENTES,
    COUNT(*) - COUNT(DISTINCT cpi.COMPPRODUCOD) AS PRODUTOS_SEM_COMPONENTES,
    COUNT(cpi.CPIPROCODIGO) AS TOTAL_ITENS_COMPONENTES,
    COUNT(DISTINCT cpi.CPIPROCODIGO) AS TOTAL_COMPONENTES_DIFERENTES,
    AVG(componentes_por_produto.TOTAL) AS MEDIA_COMPONENTES_POR_PRODUTO
FROM COMPOPRODU cp
LEFT JOIN COMPOPRODUITEM cpi ON cpi.COMPPRODUCOD = cp.COMPPRODUCOD
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM COMPOPRODUITEM
    GROUP BY COMPPRODUCOD
) componentes_por_produto;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOPRODU | Tipo |
|--------|-----------|---------------------|------|
| **COMPOPRODU** | 51.308 | 1:1 | **TABELA PRINCIPAL** |
| COMPOPRODUITEM | 131.181 | 2.56:1 | Itens de produtos compostos (média de 2.56 itens por produto composto) |
| PRODU | 178.187 | 3.47:1 | Produtos (29% são produtos compostos) |

**Interpretação:**
- **51.308 produtos compostos** cadastrados no sistema
- **29% dos produtos** são produtos compostos (51.308 de 178.187)
- **Média de 2.56 itens por produto composto** - produtos compostos têm múltiplos componentes
- **Uso extensivo** - indica estrutura complexa de produtos

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela COMPOPRODU.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por descrição** - Para buscas por descrição

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_COMPOPRODU_DESCRICAO ON COMPOPRODU(COMPPRODUDESCRICAO)
    WHERE COMPPRODUDESCRICAO IS NOT NULL AND COMPPRODUDESCRICAO != '';
```

### Observações sobre Volume

- **Tabela média** (51.308 registros) - Performance boa
- **Consultas frequentes** - Produtos compostos são consultados durante criação de pedidos e produção
- **Índices úteis** - Em COMPPRODUDESCRICAO para buscas por nome

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOPRODU
WHERE COMPPRODUCOD IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT COMPPRODUCOD, COUNT(*) AS QTD
FROM COMPOPRODU
GROUP BY COMPPRODUCOD
HAVING COUNT(*) > 1;

-- Verificar produtos compostos sem descrição
SELECT *
FROM COMPOPRODU
WHERE COMPPRODUDESCRICAO IS NULL
   OR COMPPRODUDESCRICAO = '';
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCompoprodu extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOPRODU';
    
    protected $primaryKey = 'COMPPRODUCOD';
    public $incrementing = true;

    protected $casts = [
        'COMPPRODUCOD' => 'integer',
        'COMPPRODUDESCRICAO' => 'string',
    ];

    // Relacionamento com COMPOPRODUITEM
    public function itens(): HasMany
    {
        return $this->hasMany(FirebirdCompoproduitem::class, 'COMPPRODUCOD', 'COMPPRODUCOD');
    }

    // Método para verificar se tem componentes
    public function temComponentes(): bool
    {
        return $this->itens()->exists();
    }

    // Método para obter total de componentes
    public function getTotalComponentes(): int
    {
        return $this->itens()->count();
    }

    // Scope para filtrar produtos com componentes
    public function scopeComComponentes($query)
    {
        return $query->whereHas('itens');
    }

    // Scope para filtrar produtos sem componentes
    public function scopeSemComponentes($query)
    {
        return $query->whereDoesntHave('itens');
    }

    // Método estático para buscar produto composto por código
    public static function buscarPorCodigo(int $codigo): ?self
    {
        return self::where('COMPPRODUCOD', $codigo)->first();
    }

    // Método estático para buscar produtos compostos por descrição
    public static function buscarPorDescricao(string $descricao): \Illuminate\Support\Collection
    {
        return self::where('COMPPRODUDESCRICAO', 'LIKE', '%' . $descricao . '%')
            ->orderBy('COMPPRODUDESCRICAO')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - COMPPRODUCOD identifica unicamente cada produto composto
2. **Validação antes de inserir** - Verificar se código não existe
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de descrição** - Verificar que descrição não está vazia

### Performance

1. **Tabela média** - 51.308 registros, performance boa
2. **Índices úteis** - Em COMPPRODUDESCRICAO para buscas por nome
3. **Consultas frequentes** - Produtos compostos são consultados durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código não existe
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que descrições sejam únicas quando apropriado

### Manutenção

1. **Revisão periódica** - Verificar produtos compostos não utilizados
2. **Padronização** - Manter estrutura de descrições consistente
3. **Documentação** - Documentar significado de cada produto composto
4. **Backup regular** - Tabela importante para gestão de produtos compostos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

