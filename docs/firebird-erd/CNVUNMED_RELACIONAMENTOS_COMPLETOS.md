# CNVUNMED - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CNVUNMED (Conversão de Unidades de Medida)
- **Total de Registros**: 6
- **Total de Colunas**: 4
- **Chave Primária**: (UNCODIGO, UNCODIGO2) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CNVUNMED** é uma tabela de conversão que armazena fatores de conversão entre diferentes unidades de medida. Com apenas **6 registros**, representa conversões específicas entre unidades de medida, permitindo transformar valores de uma unidade para outra.

Esta tabela funciona como **conversor de unidades de medida** e permite:
- Converter valores entre unidades de medida diferentes
- Armazenar fatores de conversão entre unidades
- Suportar conversões bidirecionais (de UNCODIGO para UNCODIGO2 e vice-versa)
- Controlar sinal da conversão (multiplicação ou divisão)
- Facilitar cálculos de conversão em produtos e serviços
- Suportar conversões em documentos fiscais

Cada registro representa uma conversão específica entre duas unidades de medida, contendo:
- Unidade de medida origem (UNCODIGO)
- Unidade de medida destino (UNCODIGO2)
- Fator de conversão (CUNFATOR)
- Sinal da operação (SINAL)

O sistema utiliza esta tabela para converter valores entre unidades de medida diferentes, permitindo cálculos precisos em produtos, serviços e documentos fiscais.

**Observação Importante:** CNVUNMED é uma tabela de conversão essencial para cálculos de unidades. Com apenas 6 registros, indica uso específico para conversões entre unidades de medida comuns (ex: kg para g, m para cm, etc.).

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **UNCODIGO** 🔑🔗 | VARCHAR(14) | ✓ | Código da unidade de medida origem (PK + FK → UNMED) |
| **UNCODIGO2** 🔑🔗 | VARCHAR(14) | ✓ | Código da unidade de medida destino (PK + FK → UNMED) |

### Fator de Conversão
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CUNFATOR** | NUMERIC(16,4) | | Fator de conversão entre as unidades |
| **SINAL** | VARCHAR(14) | | Sinal da operação (ex: "+", "-", "*", "/") |

**Primary Key:** (UNCODIGO, UNCODIGO2)

**Observações sobre Campos:**
- **UNCODIGO**: Unidade de medida origem (de onde se converte).
- **UNCODIGO2**: Unidade de medida destino (para onde se converte).
- **CUNFATOR**: Fator numérico usado na conversão (ex: 1000 para converter kg para g).
- **SINAL**: Operação matemática a ser aplicada (ex: "*" para multiplicar, "/" para dividir).

**Exemplo de Conversão:**
- **UNCODIGO**: "KG" (quilograma)
- **UNCODIGO2**: "G" (grama)
- **CUNFATOR**: 1000
- **SINAL**: "*"
- **Conversão**: 1 KG * 1000 = 1000 G

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CNVUNMED Referencia (2 FKs):

#### 1. UNMED - Unidades de Medida (Origem)
**Relacionamento:**
```
CNVUNMED.UNCODIGO → UNMED.UNCODIGO (N:1)
Constraint: UNMED_CNVUNMED
```

**Descrição**: Cada conversão está vinculada a uma unidade de medida origem específica.

**Informações da Tabela UNMED:**
- **Total:** 130 unidades de medida
- **PK:** UNCODIGO
- **Colunas:** 3 campos
- **FK Out:** 0
- **FK In:** 10 tabelas

**Campos importantes em UNMED relacionados a CNVUNMED:**
- `UNCODIGO` - Código da unidade de medida
- `UNDESCRICAO` - Descrição da unidade de medida
- `UNFATOR` - Fator padrão da unidade (se houver)

**Uso:** Identificar a unidade de medida origem, obter informações da unidade.

---

#### 2. UNMED - Unidades de Medida (Destino)
**Relacionamento:**
```
CNVUNMED.UNCODIGO2 → UNMED.UNCODIGO (N:1)
Constraint: UNMED2_CNVUNMED
```

**Descrição**: Cada conversão está vinculada a uma unidade de medida destino específica.

**Informações da Tabela UNMED:**
- **Total:** 130 unidades de medida
- **PK:** UNCODIGO
- **Colunas:** 3 campos

**Uso:** Identificar a unidade de medida destino, obter informações da unidade.

---

### CNVUNMED é Referenciada Por

**Nenhuma tabela** referencia CNVUNMED diretamente. Esta é uma tabela folha utilizada para conversão e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via UNCODIGO → PRODU (Produtos)

**Fluxo:** CNVUNMED → UNMED → PRODU

**Descrição:** Através da unidade de medida origem, é possível identificar produtos que utilizam essa unidade.

**Uso:** Converter quantidades de produtos entre unidades, cálculos de estoque.

---

### Via UNCODIGO2 → PRODU (Produtos)

**Fluxo:** CNVUNMED → UNMED → PRODU

**Descrição:** Através da unidade de medida destino, é possível identificar produtos que utilizam essa unidade.

**Uso:** Converter quantidades de produtos entre unidades, cálculos de estoque.

---

### Via UNCODIGO → NFPRO (Produtos de Nota Fiscal)

**Fluxo:** CNVUNMED → UNMED → NFPRO

**Descrição:** Através da unidade de medida origem, é possível identificar produtos em notas fiscais que utilizam essa unidade.

**Uso:** Converter quantidades em notas fiscais entre unidades.

---

### Via UNCODIGO → SERVI (Serviços)

**Fluxo:** CNVUNMED → UNMED → SERVI

**Descrição:** Através da unidade de medida origem, é possível identificar serviços que utilizam essa unidade.

**Uso:** Converter quantidades de serviços entre unidades.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Conversão

**Objetivo:** Obter visão completa de uma conversão incluindo informações das unidades de medida.

**Fluxo:**
```
CNVUNMED (UNCODIGO, UNCODIGO2, CUNFATOR, SINAL)
  ↓
UNMED (UNCODIGO) - Origem
  ↓
UNMED (UNCODIGO2) - Destino
```

**Query SQL:**
```sql
SELECT
    cnv.UNCODIGO,
    un1.UNDESCRICAO AS UNIDADE_ORIGEM,
    cnv.UNCODIGO2,
    un2.UNDESCRICAO AS UNIDADE_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO,
    CASE 
        WHEN cnv.SINAL = '*' THEN cnv.UNCODIGO || ' * ' || CAST(cnv.CUNFATOR AS VARCHAR) || ' = ' || cnv.UNCODIGO2
        WHEN cnv.SINAL = '/' THEN cnv.UNCODIGO || ' / ' || CAST(cnv.CUNFATOR AS VARCHAR) || ' = ' || cnv.UNCODIGO2
        ELSE cnv.UNCODIGO || ' ' || cnv.SINAL || ' ' || CAST(cnv.CUNFATOR AS VARCHAR) || ' = ' || cnv.UNCODIGO2
    END AS FORMULA_CONVERSAO
FROM CNVUNMED cnv
INNER JOIN UNMED un1 ON un1.UNCODIGO = cnv.UNCODIGO
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
WHERE cnv.UNCODIGO = ?
  AND cnv.UNCODIGO2 = ?;
```

---

### Exemplo 2: Análise de Conversões por Unidade de Medida

**Objetivo:** Identificar todas as conversões disponíveis para uma unidade de medida específica.

**Query SQL:**
```sql
SELECT
    cnv.UNCODIGO2 AS UNIDADE_DESTINO,
    un2.UNDESCRICAO AS DESCRICAO_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO
FROM CNVUNMED cnv
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
WHERE cnv.UNCODIGO = ?
ORDER BY un2.UNDESCRICAO;
```

---

### Exemplo 3: Análise de Conversões Bidirecionais

**Objetivo:** Identificar conversões bidirecionais (se existe conversão de A para B e de B para A).

**Query SQL:**
```sql
SELECT
    cnv1.UNCODIGO AS UNIDADE_A,
    un1.UNDESCRICAO AS DESCRICAO_A,
    cnv1.UNCODIGO2 AS UNIDADE_B,
    un2.UNDESCRICAO AS DESCRICAO_B,
    cnv1.CUNFATOR AS FATOR_A_PARA_B,
    cnv1.SINAL AS OPERACAO_A_PARA_B,
    cnv2.CUNFATOR AS FATOR_B_PARA_A,
    cnv2.SINAL AS OPERACAO_B_PARA_A,
    CASE 
        WHEN cnv2.UNCODIGO IS NOT NULL THEN 'BIDIRECIONAL'
        ELSE 'UNIDIRECIONAL'
    END AS TIPO_CONVERSAO
FROM CNVUNMED cnv1
INNER JOIN UNMED un1 ON un1.UNCODIGO = cnv1.UNCODIGO
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv1.UNCODIGO2
LEFT JOIN CNVUNMED cnv2 ON cnv2.UNCODIGO = cnv1.UNCODIGO2
  AND cnv2.UNCODIGO2 = cnv1.UNCODIGO
ORDER BY cnv1.UNCODIGO, cnv1.UNCODIGO2;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Conversão entre Unidades

**Objetivo:** Obter o fator de conversão entre duas unidades de medida específicas.

```sql
SELECT
    UNCODIGO AS UNIDADE_ORIGEM,
    UNCODIGO2 AS UNIDADE_DESTINO,
    CUNFATOR AS FATOR_CONVERSAO,
    SINAL AS OPERACAO
FROM CNVUNMED
WHERE UNCODIGO = ?
  AND UNCODIGO2 = ?;
```

---

### 2. Listar Todas as Conversões Disponíveis

**Objetivo:** Obter todas as conversões cadastradas no sistema.

```sql
SELECT
    cnv.UNCODIGO,
    un1.UNDESCRICAO AS UNIDADE_ORIGEM,
    cnv.UNCODIGO2,
    un2.UNDESCRICAO AS UNIDADE_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO
FROM CNVUNMED cnv
INNER JOIN UNMED un1 ON un1.UNCODIGO = cnv.UNCODIGO
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
ORDER BY cnv.UNCODIGO, cnv.UNCODIGO2;
```

---

### 3. Buscar Conversões de uma Unidade Específica

**Objetivo:** Identificar todas as unidades para as quais é possível converter a partir de uma unidade específica.

```sql
SELECT
    cnv.UNCODIGO2 AS UNIDADE_DESTINO,
    un2.UNDESCRICAO AS DESCRICAO_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO
FROM CNVUNMED cnv
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
WHERE cnv.UNCODIGO = ?
ORDER BY un2.UNDESCRICAO;
```

---

### 4. Análise de Conversões Mais Utilizadas

**Objetivo:** Identificar conversões mais comuns baseado em uso em produtos.

**Query SQL:**
```sql
SELECT
    cnv.UNCODIGO,
    un1.UNDESCRICAO AS UNIDADE_ORIGEM,
    cnv.UNCODIGO2,
    un2.UNDESCRICAO AS UNIDADE_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO,
    COUNT(DISTINCT pr.PROCODIGO) AS TOTAL_PRODUTOS_USANDO_ORIGEM,
    COUNT(DISTINCT pr2.PROCODIGO) AS TOTAL_PRODUTOS_USANDO_DESTINO
FROM CNVUNMED cnv
INNER JOIN UNMED un1 ON un1.UNCODIGO = cnv.UNCODIGO
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
LEFT JOIN PRODU pr ON pr.PROUN = cnv.UNCODIGO
LEFT JOIN PRODU pr2 ON pr2.PROUN = cnv.UNCODIGO2
GROUP BY cnv.UNCODIGO, un1.UNDESCRICAO, cnv.UNCODIGO2, un2.UNDESCRICAO, cnv.CUNFATOR, cnv.SINAL
ORDER BY TOTAL_PRODUTOS_USANDO_ORIGEM DESC;
```

---

### 5. Verificar Conversões Faltantes

**Objetivo:** Identificar pares de unidades de medida que não têm conversão cadastrada mas são utilizadas em produtos.

**Query SQL:**
```sql
SELECT DISTINCT
    pr1.PROUN AS UNIDADE_1,
    un1.UNDESCRICAO AS DESCRICAO_1,
    pr2.PROUN AS UNIDADE_2,
    un2.UNDESCRICAO AS DESCRICAO_2
FROM PRODU pr1
INNER JOIN UNMED un1 ON un1.UNCODIGO = pr1.PROUN
CROSS JOIN PRODU pr2
INNER JOIN UNMED un2 ON un2.UNCODIGO = pr2.PROUN
WHERE pr1.PROUN < pr2.PROUN
  AND NOT EXISTS (
      SELECT 1 FROM CNVUNMED cnv
      WHERE (cnv.UNCODIGO = pr1.PROUN AND cnv.UNCODIGO2 = pr2.PROUN)
         OR (cnv.UNCODIGO = pr2.PROUN AND cnv.UNCODIGO2 = pr1.PROUN)
  )
ORDER BY pr1.PROUN, pr2.PROUN;
```

---

### 6. Análise de Conversões com Produtos

**Objetivo:** Obter conversões com informações de produtos que utilizam as unidades.

**Query SQL:**
```sql
SELECT
    cnv.UNCODIGO,
    un1.UNDESCRICAO AS UNIDADE_ORIGEM,
    cnv.UNCODIGO2,
    un2.UNDESCRICAO AS UNIDADE_DESTINO,
    cnv.CUNFATOR AS FATOR_CONVERSAO,
    cnv.SINAL AS OPERACAO,
    COUNT(DISTINCT pr.PROCODIGO) AS TOTAL_PRODUTOS_USANDO_ORIGEM,
    COUNT(DISTINCT pr2.PROCODIGO) AS TOTAL_PRODUTOS_USANDO_DESTINO
FROM CNVUNMED cnv
INNER JOIN UNMED un1 ON un1.UNCODIGO = cnv.UNCODIGO
INNER JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
LEFT JOIN PRODU pr ON pr.PROUN = cnv.UNCODIGO
LEFT JOIN PRODU pr2 ON pr2.PROUN = cnv.UNCODIGO2
GROUP BY cnv.UNCODIGO, un1.UNDESCRICAO, cnv.UNCODIGO2, un2.UNDESCRICAO, cnv.CUNFATOR, cnv.SINAL
ORDER BY TOTAL_PRODUTOS_USANDO_ORIGEM DESC;
```

---

### 7. Função de Conversão de Valores

**Objetivo:** Criar função para converter valores entre unidades.

**Query SQL:**
```sql
-- Exemplo de uso da conversão
SELECT
    cnv.UNCODIGO AS DE,
    cnv.UNCODIGO2 AS PARA,
    cnv.CUNFATOR AS FATOR,
    cnv.SINAL AS OPERACAO,
    10 AS VALOR_ORIGEM,
    CASE 
        WHEN cnv.SINAL = '*' THEN 10 * cnv.CUNFATOR
        WHEN cnv.SINAL = '/' THEN 10 / cnv.CUNFATOR
        WHEN cnv.SINAL = '+' THEN 10 + cnv.CUNFATOR
        WHEN cnv.SINAL = '-' THEN 10 - cnv.CUNFATOR
        ELSE 10
    END AS VALOR_CONVERTIDO
FROM CNVUNMED cnv
WHERE cnv.UNCODIGO = ?
  AND cnv.UNCODIGO2 = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CNVUNMED | Tipo |
|--------|-----------|---------------------|------|
| **CNVUNMED** | 6 | 1:1 | **TABELA PRINCIPAL** |
| UNMED | 130 | 21.67:1 | Unidades de medida (média de 0.046 conversões por unidade) |

**Interpretação:**
- **Apenas 6 conversões** cadastradas no sistema
- **4.6% das unidades** têm pelo menos uma conversão cadastrada (6 de 130)
- **Uso muito específico** - indica conversões entre unidades de medida comuns
- **Cobertura limitada** - maioria das unidades não tem conversão cadastrada

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CNVUNMED.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por unidade origem** - Para buscas por unidade origem
3. **Índice por unidade destino** - Para buscas por unidade destino

### Índices Sugeridos

```sql
-- Índice 1: Busca por unidade origem (consultas frequentes)
CREATE INDEX IDX_CNVUNMED_ORIGEM ON CNVUNMED(UNCODIGO);

-- Índice 2: Busca por unidade destino (consultas frequentes)
CREATE INDEX IDX_CNVUNMED_DESTINO ON CNVUNMED(UNCODIGO2);

-- Índice 3: Busca composta por origem e destino (consultas de validação)
CREATE INDEX IDX_CNVUNMED_ORIGEM_DESTINO ON CNVUNMED(UNCODIGO, UNCODIGO2);
```

### Observações sobre Volume

- **Tabela muito pequena** (6 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por unidade origem e destino

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar conversões sem unidade origem válida
SELECT cnv.*
FROM CNVUNMED cnv
LEFT JOIN UNMED un1 ON un1.UNCODIGO = cnv.UNCODIGO
WHERE un1.UNCODIGO IS NULL;

-- Verificar conversões sem unidade destino válida
SELECT cnv.*
FROM CNVUNMED cnv
LEFT JOIN UNMED un2 ON un2.UNCODIGO = cnv.UNCODIGO2
WHERE un2.UNCODIGO IS NULL;

-- Verificar conversões de uma unidade para ela mesma
SELECT *
FROM CNVUNMED
WHERE UNCODIGO = UNCODIGO2;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CNVUNMED
WHERE UNCODIGO IS NULL
   OR UNCODIGO = ''
   OR UNCODIGO2 IS NULL
   OR UNCODIGO2 = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT UNCODIGO, UNCODIGO2, COUNT(*) AS QTD
FROM CNVUNMED
GROUP BY UNCODIGO, UNCODIGO2
HAVING COUNT(*) > 1;

-- Verificar fatores de conversão inválidos
SELECT *
FROM CNVUNMED
WHERE CUNFATOR IS NULL
   OR CUNFATOR <= 0;

-- Verificar sinais inválidos
SELECT *
FROM CNVUNMED
WHERE SINAL IS NOT NULL
  AND SINAL NOT IN ('*', '/', '+', '-');
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

final class FirebirdCnvunmed extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CNVUNMED';
    
    protected $primaryKey = ['UNCODIGO', 'UNCODIGO2'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'UNCODIGO' => 'string',
        'UNCODIGO2' => 'string',
        'CUNFATOR' => 'decimal:4',
        'SINAL' => 'string',
    ];

    // Relacionamento com UNMED (origem)
    public function unidadeOrigem(): BelongsTo
    {
        return $this->belongsTo(FirebirdUnmed::class, 'UNCODIGO', 'UNCODIGO');
    }

    // Relacionamento com UNMED (destino)
    public function unidadeDestino(): BelongsTo
    {
        return $this->belongsTo(FirebirdUnmed::class, 'UNCODIGO2', 'UNCODIGO');
    }

    // Método para converter valor
    public function converter(float $valor): float
    {
        return match($this->SINAL) {
            '*' => $valor * $this->CUNFATOR,
            '/' => $valor / $this->CUNFATOR,
            '+' => $valor + $this->CUNFATOR,
            '-' => $valor - $this->CUNFATOR,
            default => $valor,
        };
    }

    // Método para obter fórmula de conversão
    public function getFormula(): string
    {
        return sprintf(
            '%s %s %s = %s',
            $this->UNCODIGO,
            $this->SINAL ?? '*',
            (string)$this->CUNFATOR,
            $this->UNCODIGO2
        );
    }

    // Scope para filtrar por unidade origem
    public function scopePorOrigem($query, string $unidadeCodigo)
    {
        return $query->where('UNCODIGO', $unidadeCodigo);
    }

    // Scope para filtrar por unidade destino
    public function scopePorDestino($query, string $unidadeCodigo)
    {
        return $query->where('UNCODIGO2', $unidadeCodigo);
    }

    // Método estático para buscar conversão específica
    public static function buscarConversao(string $unidadeOrigem, string $unidadeDestino): ?self
    {
        return self::where('UNCODIGO', $unidadeOrigem)
            ->where('UNCODIGO2', $unidadeDestino)
            ->first();
    }

    // Método estático para converter valor
    public static function converterValor(float $valor, string $unidadeOrigem, string $unidadeDestino): ?float
    {
        $conversao = self::buscarConversao($unidadeOrigem, $unidadeDestino);
        return $conversao?->converter($valor);
    }

    // Método estático para verificar se conversão existe
    public static function conversaoExiste(string $unidadeOrigem, string $unidadeDestino): bool
    {
        return self::where('UNCODIGO', $unidadeOrigem)
            ->where('UNCODIGO2', $unidadeDestino)
            ->exists();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se unidades de medida existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de fatores** - Verificar valores positivos e válidos
5. **Validação de sinais** - Verificar valores válidos de operação

### Performance

1. **Tabela muito pequena** - 6 registros, performance excelente
2. **Índices úteis** - Em UNCODIGO e UNCODIGO2 para buscas frequentes
3. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se unidades de medida existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de fatores** - Verificar valores positivos e válidos
5. **Validação de sinais** - Verificar valores válidos de operação

### Manutenção

1. **Revisão periódica** - Verificar conversões não utilizadas
2. **Padronização** - Manter estrutura de sinais consistente
3. **Documentação** - Documentar significado de cada conversão
4. **Backup regular** - Tabela importante para cálculos de conversão

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

