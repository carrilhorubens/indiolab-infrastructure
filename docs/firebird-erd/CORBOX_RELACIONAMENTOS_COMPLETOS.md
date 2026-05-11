# CORBOX - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CORBOX (Cores de JitBox)
- **Total de Registros**: 22
- **Total de Colunas**: 4
- **Chave Primária**: CORCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (JETBOX, PLTCTRSER)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CORBOX** é uma tabela mestre que armazena informações sobre cores utilizadas para identificar e diferenciar JitBoxes (caixas de transporte) no sistema. Com **22 registros**, representa um catálogo limitado de cores disponíveis para classificação visual de caixas de transporte.

Esta tabela funciona como **catálogo de cores para JitBoxes** e permite:
- Cadastrar cores disponíveis para JitBoxes
- Associar cores a valores numéricos
- Armazenar código hexadecimal das cores
- Facilitar identificação visual de caixas de transporte
- Suportar sistema de cores padronizado

Cada registro representa uma cor específica disponível para uso em JitBoxes, contendo:
- Código único da cor (CORCODIGO)
- Descrição da cor (CORDESCRICAO)
- Valor numérico da cor (CORVALOR)
- Código hexadecimal da cor (CORHEX)

O sistema utiliza esta tabela como referência para cores de JitBoxes, permitindo identificação visual rápida e organização de caixas de transporte por cor.

**Observação Importante:** CORBOX é uma tabela mestre pequena com apenas 22 cores cadastradas. Com 2 tabelas dependentes (JETBOX com 33.951 registros e PLTCTRSER), indica uso extensivo de cores para identificação visual de caixas de transporte, essencial para organização logística.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CORCODIGO** 🔑 | SMALLINT | ✓ | Código único da cor |

### Informações da Cor
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CORDESCRICAO** | VARCHAR(37) | ✓ | Descrição da cor (ex: Vermelho, Azul, Verde) |
| **CORVALOR** | INTEGER | | Valor numérico da cor |
| **CORHEX** | VARCHAR(37) | | Código hexadecimal da cor (ex: #FF0000) |

**Primary Key:** CORCODIGO

**Observações sobre Campos:**
- **CORCODIGO**: Identificador único de cada cor.
- **CORDESCRICAO**: Nome descritivo da cor (ex: "Vermelho", "Azul", "Verde").
- **CORVALOR**: Valor numérico que pode ser usado para ordenação ou classificação.
- **CORHEX**: Código hexadecimal da cor no formato RGB (ex: #FF0000 para vermelho).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CORBOX Referencia

**Nenhuma foreign key formal** está definida na tabela CORBOX.

---

### CORBOX é Referenciada Por (2 tabelas):

#### 1. JETBOX - Caixas de Transporte (JitBoxes)
**Relacionamento:**
```
JETBOX.CORCODIGO → CORBOX.CORCODIGO (N:1)
Constraint: CORBOX_JETBOX
```

**Descrição**: Cada JitBox pode estar vinculada a uma cor específica para identificação visual.

**Informações da Tabela JETBOX:**
- **Total:** 33.951 JitBoxes
- **PK:** (JBCODIGO, EMPCODIGO)
- **Colunas:** 8 campos
- **FK Out:** 4
- **FK In:** 2 tabelas

**Uso:** Identificar a cor da JitBox, obter informações da cor para exibição visual.

**Proporção:** Média de 1.543 JitBoxes por cor (33.951 de 22)

---

#### 2. PLTCTRSER - Placas de Controle de Serviços
**Relacionamento:**
```
PLTCTRSER.CORCODIGO → CORBOX.CORCODIGO (N:1)
Constraint: CORBOX_PLTCTRSER
```

**Descrição**: Placas de controle de serviços podem estar vinculadas a cores específicas.

**Uso:** Identificar a cor da placa, obter informações da cor para exibição visual.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via JETBOX → PEDID (Pedidos)

**Fluxo:** CORBOX → JETBOX → PEDID

**Descrição:** Através das JitBoxes, é possível identificar pedidos relacionados por cor.

**Uso:** Análise de pedidos por cor de caixa de transporte.

---

### Via JETBOX → ALMOX (Células)

**Fluxo:** CORBOX → JETBOX → ALMOX

**Descrição:** Através das JitBoxes, é possível identificar células relacionadas por cor.

**Uso:** Análise de células por cor de caixa de transporte.

---

### Via JETBOX → EMPRESA (Empresas)

**Fluxo:** CORBOX → JETBOX → EMPRESA

**Descrição:** Através das JitBoxes, é possível identificar empresas relacionadas por cor.

**Uso:** Análise de empresas por cor de caixa de transporte.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Cor

**Objetivo:** Obter visão completa de uma cor incluindo informações de JitBoxes que a utilizam.

**Fluxo:**
```
CORBOX (CORCODIGO, CORDESCRICAO, CORVALOR, CORHEX)
  ↓
JETBOX (CORCODIGO, JBCODIGO, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cb.CORCODIGO,
    cb.CORDESCRICAO AS COR,
    cb.CORVALOR AS VALOR_COR,
    cb.CORHEX AS HEXADECIMAL,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES,
    COUNT(DISTINCT jb.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT jb.ID_PEDIDO) AS TOTAL_PEDIDOS_DIFERENTES
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
WHERE cb.CORCODIGO = ?
GROUP BY cb.CORCODIGO, cb.CORDESCRICAO, cb.CORVALOR, cb.CORHEX;
```

---

### Exemplo 2: Análise de Cores Mais Utilizadas

**Objetivo:** Identificar cores mais utilizadas em JitBoxes.

**Query SQL:**
```sql
SELECT
    cb.CORCODIGO,
    cb.CORDESCRICAO AS COR,
    cb.CORVALOR AS VALOR_COR,
    cb.CORHEX AS HEXADECIMAL,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES,
    COUNT(DISTINCT jb.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT jb.ID_PEDIDO) AS TOTAL_PEDIDOS_DIFERENTES
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
GROUP BY cb.CORCODIGO, cb.CORDESCRICAO, cb.CORVALOR, cb.CORHEX
ORDER BY TOTAL_JITBOXES DESC;
```

---

### Exemplo 3: Análise de Cores por Empresa

**Objetivo:** Obter distribuição de cores por empresa.

**Query SQL:**
```sql
SELECT
    cb.CORCODIGO,
    cb.CORDESCRICAO AS COR,
    jb.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES
FROM CORBOX cb
INNER JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = jb.EMPCODIGO
GROUP BY cb.CORCODIGO, cb.CORDESCRICAO, jb.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY cb.CORCODIGO, jb.EMPCODIGO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Cor

**Objetivo:** Obter informações de uma cor específica.

```sql
SELECT
    CORCODIGO,
    CORDESCRICAO AS COR,
    CORVALOR AS VALOR_COR,
    CORHEX AS HEXADECIMAL
FROM CORBOX
WHERE CORCODIGO = ?;
```

---

### 2. Listar Todas as Cores

**Objetivo:** Obter todas as cores cadastradas.

```sql
SELECT
    CORCODIGO,
    CORDESCRICAO AS COR,
    CORVALOR AS VALOR_COR,
    CORHEX AS HEXADECIMAL
FROM CORBOX
ORDER BY CORVALOR, CORDESCRICAO;
```

---

### 3. Buscar Cores por Descrição

**Objetivo:** Buscar cores por nome ou descrição.

```sql
SELECT
    CORCODIGO,
    CORDESCRICAO AS COR,
    CORVALOR AS VALOR_COR,
    CORHEX AS HEXADECIMAL
FROM CORBOX
WHERE CORDESCRICAO LIKE ?
ORDER BY CORDESCRICAO;
```

---

### 4. Análise de Cores Não Utilizadas

**Objetivo:** Identificar cores que não estão sendo utilizadas em JitBoxes.

```sql
SELECT
    cb.CORCODIGO,
    cb.CORDESCRICAO AS COR,
    cb.CORVALOR AS VALOR_COR,
    cb.CORHEX AS HEXADECIMAL
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
WHERE jb.CORCODIGO IS NULL
ORDER BY cb.CORDESCRICAO;
```

---

### 5. Análise de Cores com JitBoxes

**Objetivo:** Obter cores com informações de JitBoxes que as utilizam.

**Query SQL:**
```sql
SELECT
    cb.CORCODIGO,
    cb.CORDESCRICAO AS COR,
    cb.CORVALOR AS VALOR_COR,
    cb.CORHEX AS HEXADECIMAL,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES,
    COUNT(DISTINCT jb.EMPCODIGO) AS TOTAL_EMPRESAS
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
GROUP BY cb.CORCODIGO, cb.CORDESCRICAO, cb.CORVALOR, cb.CORHEX
ORDER BY TOTAL_JITBOXES DESC;
```

---

### 6. Análise de Cores por Valor

**Objetivo:** Obter cores ordenadas por valor numérico.

**Query SQL:**
```sql
SELECT
    CORCODIGO,
    CORDESCRICAO AS COR,
    CORVALOR AS VALOR_COR,
    CORHEX AS HEXADECIMAL,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
GROUP BY CORCODIGO, CORDESCRICAO, CORVALOR, CORHEX
ORDER BY CORVALOR;
```

---

### 7. Relatório de Cores

**Objetivo:** Analisar distribuição completa de cores.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CORES,
    COUNT(DISTINCT jb.CORCODIGO) AS CORES_UTILIZADAS,
    COUNT(*) - COUNT(DISTINCT jb.CORCODIGO) AS CORES_NAO_UTILIZADAS,
    COUNT(DISTINCT jb.JBCODIGO) AS TOTAL_JITBOXES,
    COUNT(DISTINCT jb.EMPCODIGO) AS TOTAL_EMPRESAS,
    AVG(jitboxes_por_cor.TOTAL) AS MEDIA_JITBOXES_POR_COR
FROM CORBOX cb
LEFT JOIN JETBOX jb ON jb.CORCODIGO = cb.CORCODIGO
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM JETBOX
    GROUP BY CORCODIGO
) jitboxes_por_cor;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CORBOX | Tipo |
|--------|-----------|---------------------|------|
| **CORBOX** | 22 | 1:1 | **TABELA PRINCIPAL** |
| JETBOX | 33.951 | 1.543:1 | JitBoxes (média de 1.543 JitBoxes por cor) |
| PLTCTRSER | ~? | ?:1 | Placas de controle |

**Interpretação:**
- **22 cores** cadastradas no sistema
- **Média de 1.543 JitBoxes por cor** - uso extensivo de cores para identificação
- **Uso extensivo** - indica sistema de cores bem estabelecido

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CORBOX além da chave primária.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por descrição** - Para buscas por nome

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_CORBOX_DESCRICAO ON CORBOX(CORDESCRICAO)
    WHERE CORDESCRICAO IS NOT NULL AND CORDESCRICAO != '';

-- Índice 2: Busca por valor (consultas de ordenação)
CREATE INDEX IDX_CORBOX_VALOR ON CORBOX(CORVALOR)
    WHERE CORVALOR IS NOT NULL;
```

### Observações sobre Volume

- **Tabela muito pequena** (22 registros) - Performance excelente
- **Consultas frequentes** - Cores são consultadas durante exibição de JitBoxes
- **Índices úteis** - Em CORDESCRICAO para buscas por nome

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CORBOX
WHERE CORCODIGO IS NULL
   OR CORDESCRICAO IS NULL
   OR CORDESCRICAO = '';

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CORCODIGO, COUNT(*) AS QTD
FROM CORBOX
GROUP BY CORCODIGO
HAVING COUNT(*) > 1;

-- Verificar cores sem descrição
SELECT *
FROM CORBOX
WHERE CORDESCRICAO IS NULL
   OR CORDESCRICAO = '';

-- Verificar códigos hexadecimais inválidos
SELECT *
FROM CORBOX
WHERE CORHEX IS NOT NULL
  AND CORHEX != ''
  AND NOT (CORHEX LIKE '#______');
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

final class FirebirdCorbox extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CORBOX';
    
    protected $primaryKey = 'CORCODIGO';
    public $incrementing = true;

    protected $casts = [
        'CORCODIGO' => 'integer',
        'CORDESCRICAO' => 'string',
        'CORVALOR' => 'integer',
        'CORHEX' => 'string',
    ];

    // Relacionamento com JETBOX
    public function jitboxes(): HasMany
    {
        return $this->hasMany(FirebirdJetbox::class, 'CORCODIGO', 'CORCODIGO');
    }

    // Relacionamento com PLTCTRSER
    public function placasControle(): HasMany
    {
        return $this->hasMany(FirebirdPltctrser::class, 'CORCODIGO', 'CORCODIGO');
    }

    // Método para obter total de JitBoxes
    public function getTotalJitboxes(): int
    {
        return $this->jitboxes()->count();
    }

    // Método para verificar se tem código hexadecimal
    public function temHex(): bool
    {
        return !empty($this->CORHEX);
    }

    // Método para obter cor em formato RGB
    public function getRgbColor(): ?array
    {
        if (empty($this->CORHEX) || !preg_match('/^#([0-9A-F]{6})$/i', $this->CORHEX, $matches)) {
            return null;
        }
        
        $hex = $matches[1];
        return [
            'r' => hexdec(substr($hex, 0, 2)),
            'g' => hexdec(substr($hex, 2, 2)),
            'b' => hexdec(substr($hex, 4, 2)),
        ];
    }

    // Scope para filtrar cores utilizadas
    public function scopeUtilizadas($query)
    {
        return $query->whereHas('jitboxes');
    }

    // Scope para filtrar cores não utilizadas
    public function scopeNaoUtilizadas($query)
    {
        return $query->whereDoesntHave('jitboxes');
    }

    // Método estático para buscar cor por código
    public static function buscarPorCodigo(int $codigo): ?self
    {
        return self::where('CORCODIGO', $codigo)->first();
    }

    // Método estático para buscar cor por descrição
    public static function buscarPorDescricao(string $descricao): \Illuminate\Support\Collection
    {
        return self::where('CORDESCRICAO', 'LIKE', '%' . $descricao . '%')
            ->orderBy('CORDESCRICAO')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - CORCODIGO identifica unicamente cada cor
2. **Validação antes de inserir** - Verificar se código não existe
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de descrição** - Verificar que descrição não está vazia
5. **Validação de hexadecimal** - Verificar formato válido quando preenchido

### Performance

1. **Tabela muito pequena** - 22 registros, performance excelente
2. **Índices úteis** - Em CORDESCRICAO para buscas por nome
3. **Consultas frequentes** - Cores são consultadas durante exibição de JitBoxes

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código não existe
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que descrições sejam únicas quando apropriado
4. **Validação de hexadecimal** - Verificar formato válido (#RRGGBB)

### Manutenção

1. **Revisão periódica** - Verificar cores não utilizadas
2. **Padronização** - Manter estrutura de descrições consistente
3. **Documentação** - Documentar significado de cada cor
4. **Backup regular** - Tabela importante para identificação visual

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

