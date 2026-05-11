# CST - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CST (Código de Situação Tributária)
- **Total de Registros**: 101
- **Total de Colunas**: 3
- **Chave Primária**: Composta (CSTIMPOSTO, CSTCST)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0 (Relacionamentos Lógicos)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CST** é uma tabela mestre que armazena os códigos CST (Código de Situação Tributária) utilizados no sistema fiscal brasileiro para diferentes impostos. Com **101 registros**, representa um catálogo completo de códigos CST padronizados pela Receita Federal do Brasil para ICMS, PIS, COFINS e IPI.

Esta tabela funciona como **catálogo fiscal tributário** e permite:
- Identificar códigos CST por tipo de imposto
- Classificar situações tributárias de produtos e serviços
- Determinar tratamento tributário adequado para cada situação
- Garantir compliance fiscal em documentos fiscais (NFe, NFSe, SPED)
- Suportar cálculos de impostos (ICMS, IPI, PIS, COFINS)
- Facilitar consultas e validações fiscais

Cada registro representa um código CST válido para um tipo específico de imposto, contendo:
- Tipo de imposto (CSTIMPOSTO) - ICMS, PIS, COFINS, IPI
- Código CST (CSTCST) - código numérico da situação tributária
- Descrição da situação tributária (CSTDESCRICAO)

**Tipos de Imposto Suportados:**
- **ICMS** - Imposto sobre Circulação de Mercadorias e Serviços
- **PIS** - Programa de Integração Social
- **COFINS** - Contribuição para o Financiamento da Seguridade Social
- **IPI** - Imposto sobre Produtos Industrializados

**Códigos CST Comuns:**
- **00** - Tributada integralmente
- **01** - Tributada com monofásica - retenção anterior
- **02** - Tributada com monofásica - retenção posterior
- **03** - Isenta
- **04** - Não tributada
- **05** - Suspensa
- **06** - Diferida
- **07** - Substituição tributária
- **08** - Sem incidência
- **09** - Outras operações
- **40** - Isenta (ICMS)
- **41** - Não tributada (ICMS)
- **50** - Suspensa (ICMS)
- **51** - Diferida (ICMS)
- **60** - ICMS cobrado anteriormente por substituição tributária
- **70** - Com redução da base de cálculo e cobrança do ICMS por substituição tributária
- **90** - Outras (ICMS)

O sistema utiliza esta tabela como referência para cálculos fiscais e classificação de produtos em documentos fiscais, garantindo que cada produto seja classificado corretamente conforme a legislação brasileira.

**Observação Importante:** CST não possui foreign keys diretas, mas é utilizada logicamente através de códigos CST em outras tabelas fiscais, especialmente em TBFIS, TBICMS, TBPIS, TBCOFINS, TBIPI e em documentos fiscais como NFPRO, NFEPRO, etc.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CSTIMPOSTO** 🔑 | VARCHAR(37) | ✓ | Tipo de imposto (PK) - ICMS, PIS, COFINS, IPI |
| **CSTCST** 🔑 | VARCHAR(14) | ✓ | Código CST (PK) - Código numérico da situação tributária |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CSTDESCRICAO** | VARCHAR(37) | ✓ | Descrição da situação tributária |

**Primary Key:** (CSTIMPOSTO, CSTCST)

**Observações sobre Campos:**
- **CSTIMPOSTO**: Identifica o tipo de imposto ao qual o CST se aplica (ICMS, PIS, COFINS, IPI).
- **CSTCST**: Código numérico da situação tributária conforme legislação brasileira.
- **CSTDESCRICAO**: Descrição textual da situação tributária.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CST Referencia (0 FKs):

Nenhuma foreign key direta.

---

### CST é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CST diretamente através de foreign keys.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via Códigos CST em Tabelas Fiscais

**Fluxo:** CST → Tabelas Fiscais → Documentos Fiscais

**Descrição:** CST é utilizada logicamente através de códigos CST armazenados em tabelas fiscais como TBFIS, TBICMS, TBPIS, TBCOFINS, TBIPI.

**Tabelas que utilizam CST logicamente:**

#### 1. TBFIS - Tabela Fiscal
**Relacionamento Lógico:**
```
TBFIS.CSTICMS → CST.CSTCST (onde CSTIMPOSTO = 'ICMS')
TBFIS.CSTPIS → CST.CSTCST (onde CSTIMPOSTO = 'PIS')
TBFIS.CSTCOFINS → CST.CSTCST (onde CSTIMPOSTO = 'COFINS')
TBFIS.CSTIPI → CST.CSTCST (onde CSTIMPOSTO = 'IPI')
```

**Uso:** Determinar situação tributária de produtos em operações fiscais.

---

#### 2. TBICMS - Tabela de ICMS
**Relacionamento Lógico:**
```
TBICMS.CST → CST.CSTCST (onde CSTIMPOSTO = 'ICMS')
```

**Uso:** Determinar situação tributária de ICMS.

---

#### 3. TBPIS - Tabela de PIS
**Relacionamento Lógico:**
```
TBPIS.CST → CST.CSTCST (onde CSTIMPOSTO = 'PIS')
```

**Uso:** Determinar situação tributária de PIS.

---

#### 4. TBCOFINS - Tabela de COFINS
**Relacionamento Lógico:**
```
TBCOFINS.CST → CST.CSTCST (onde CSTIMPOSTO = 'COFINS')
```

**Uso:** Determinar situação tributária de COFINS.

---

#### 5. TBIPI - Tabela de IPI
**Relacionamento Lógico:**
```
TBIPI.CST → CST.CSTCST (onde CSTIMPOSTO = 'IPI')
```

**Uso:** Determinar situação tributária de IPI.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise de CST por Tipo de Imposto

**Objetivo:** Obter todos os códigos CST disponíveis para cada tipo de imposto.

**Query SQL:**
```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
ORDER BY CSTIMPOSTO, CSTCST;
```

---

### Exemplo 2: Buscar CST Específico

**Objetivo:** Obter informações de um CST específico para um tipo de imposto.

**Query SQL:**
```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
WHERE CSTIMPOSTO = ?
  AND CSTCST = ?;
```

---

### Exemplo 3: Análise de Uso de CST em TBFIS

**Objetivo:** Identificar quais CSTs estão sendo utilizados em TBFIS.

**Query SQL:**
```sql
-- CST de ICMS
SELECT
    c.CSTIMPOSTO,
    c.CSTCST,
    c.CSTDESCRICAO,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS
FROM CST c
LEFT JOIN TBFIS tf ON tf.CSTICMS = c.CSTCST
WHERE c.CSTIMPOSTO = 'ICMS'
GROUP BY c.CSTIMPOSTO, c.CSTCST, c.CSTDESCRICAO
ORDER BY TOTAL_SITUACOES_FISCAIS DESC;

-- CST de PIS
SELECT
    c.CSTIMPOSTO,
    c.CSTCST,
    c.CSTDESCRICAO,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS
FROM CST c
LEFT JOIN TBFIS tf ON tf.CSTPIS = c.CSTCST
WHERE c.CSTIMPOSTO = 'PIS'
GROUP BY c.CSTIMPOSTO, c.CSTCST, c.CSTDESCRICAO
ORDER BY TOTAL_SITUACOES_FISCAIS DESC;

-- CST de COFINS
SELECT
    c.CSTIMPOSTO,
    c.CSTCST,
    c.CSTDESCRICAO,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS
FROM CST c
LEFT JOIN TBFIS tf ON tf.CSTCOFINS = c.CSTCST
WHERE c.CSTIMPOSTO = 'COFINS'
GROUP BY c.CSTIMPOSTO, c.CSTCST, c.CSTDESCRICAO
ORDER BY TOTAL_SITUACOES_FISCAIS DESC;

-- CST de IPI
SELECT
    c.CSTIMPOSTO,
    c.CSTCST,
    c.CSTDESCRICAO,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_SITUACOES_FISCAIS
FROM CST c
LEFT JOIN TBFIS tf ON tf.CSTIPI = c.CSTCST
WHERE c.CSTIMPOSTO = 'IPI'
GROUP BY c.CSTIMPOSTO, c.CSTCST, c.CSTDESCRICAO
ORDER BY TOTAL_SITUACOES_FISCAIS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar CST por Tipo de Imposto

**Objetivo:** Obter todos os códigos CST disponíveis para um tipo de imposto específico.

```sql
SELECT
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
WHERE CSTIMPOSTO = ?
ORDER BY CSTCST;
```

---

### 2. Validar CST Válido

**Objetivo:** Verificar se um código CST é válido para um tipo de imposto.

```sql
SELECT
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
WHERE CSTIMPOSTO = ?
  AND CSTCST = ?;
```

---

### 3. Listar Todos os CSTs Disponíveis

**Objetivo:** Obter catálogo completo de códigos CST.

```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
ORDER BY CSTIMPOSTO, CSTCST;
```

---

### 4. Análise de Distribuição de CSTs por Tipo

**Objetivo:** Identificar quantos códigos CST existem para cada tipo de imposto.

```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    COUNT(*) AS TOTAL_CSTS,
    MIN(CSTCST) AS PRIMEIRO_CST,
    MAX(CSTCST) AS ULTIMO_CST
FROM CST
GROUP BY CSTIMPOSTO
ORDER BY CSTIMPOSTO;
```

---

### 5. Buscar CSTs por Descrição

**Objetivo:** Encontrar códigos CST que contenham uma palavra-chave na descrição.

**Query SQL:**
```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    CSTCST AS CODIGO_CST,
    CSTDESCRICAO AS DESCRICAO
FROM CST
WHERE UPPER(CSTDESCRICAO) LIKE UPPER('%?%')
ORDER BY CSTIMPOSTO, CSTCST;
```

---

### 6. Análise de CSTs Mais Utilizados

**Objetivo:** Identificar quais CSTs são mais utilizados em TBFIS.

**Query SQL:**
```sql
-- CST de ICMS mais utilizados
SELECT
    c.CSTCST AS CODIGO_CST,
    c.CSTDESCRICAO AS DESCRICAO,
    COUNT(DISTINCT tf.FISCODIGO) AS TOTAL_USOS
FROM CST c
INNER JOIN TBFIS tf ON tf.CSTICMS = c.CSTCST
WHERE c.CSTIMPOSTO = 'ICMS'
GROUP BY c.CSTCST, c.CSTDESCRICAO
ORDER BY TOTAL_USOS DESC;
```

---

### 7. Relatório Completo de CSTs

**Objetivo:** Analisar distribuição completa de códigos CST no sistema.

**Query SQL:**
```sql
SELECT
    CSTIMPOSTO AS TIPO_IMPOSTO,
    COUNT(*) AS TOTAL_CSTS,
    COUNT(DISTINCT CSTCST) AS CSTS_UNICOS,
    COUNT(CASE WHEN CSTDESCRICAO IS NULL OR CSTDESCRICAO = '' THEN 1 END) AS SEM_DESCRICAO
FROM CST
GROUP BY CSTIMPOSTO
ORDER BY CSTIMPOSTO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CST | Tipo |
|--------|-----------|------------------|------|
| **CST** | 101 | 1:1 | **TABELA PRINCIPAL** |
| TBFIS | ~? | ?:1 | Situações fiscais (média de ? usos por CST) |

**Interpretação:**
- **101 códigos CST** cadastrados no sistema
- **Distribuídos entre 4 tipos de impostos** - ICMS, PIS, COFINS, IPI
- **Catálogo completo** - representa todos os códigos CST padrão brasileiros

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por tipo de imposto** - Para buscas por tipo
3. **Índice por código CST** - Para buscas por código
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo de imposto (consultas frequentes)
CREATE INDEX IDX_CST_IMPOSTO ON CST(CSTIMPOSTO);

-- Índice 2: Busca por código CST (consultas frequentes)
CREATE INDEX IDX_CST_CODIGO ON CST(CSTCST);

-- Índice 3: Busca composta por tipo e código (consultas frequentes)
-- A PK já cobre (CSTIMPOSTO, CSTCST), mas podemos criar índice adicional para ordenação inversa
CREATE INDEX IDX_CST_IMPOSTO_CODIGO_DESC ON CST(CSTIMPOSTO, CSTCST DESC);
```

### Observações sobre Volume

- **Tabela pequena** (101 registros) - Performance excelente mesmo sem índices adicionais
- **Chave primária composta** - (CSTIMPOSTO, CSTCST) já fornece índice eficiente
- **Consultas frequentes** - CSTs são consultados durante cálculos fiscais
- **Índices opcionais** - Devido ao volume pequeno, índices adicionais são opcionais mas podem melhorar performance em consultas específicas

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CST
WHERE CSTIMPOSTO IS NULL
   OR CSTIMPOSTO = ''
   OR CSTCST IS NULL
   OR CSTCST = ''
   OR CSTDESCRICAO IS NULL
   OR CSTDESCRICAO = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CSTIMPOSTO, CSTCST, COUNT(*) AS QTD
FROM CST
GROUP BY CSTIMPOSTO, CSTCST
HAVING COUNT(*) > 1;

-- Verificar tipos de imposto válidos
SELECT DISTINCT CSTIMPOSTO
FROM CST
WHERE CSTIMPOSTO NOT IN ('ICMS', 'PIS', 'COFINS', 'IPI');

-- Verificar códigos CST válidos (formato numérico)
SELECT *
FROM CST
WHERE CSTCST NOT SIMILAR TO '[0-9]+';
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdCst extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CST';
    
    protected $primaryKey = ['CSTIMPOSTO', 'CSTCST'];
    public $incrementing = false;

    protected $casts = [
        'CSTIMPOSTO' => 'string',
        'CSTCST' => 'string',
        'CSTDESCRICAO' => 'string',
    ];

    // Constantes para tipos de imposto
    public const IMPOSTO_ICMS = 'ICMS';
    public const IMPOSTO_PIS = 'PIS';
    public const IMPOSTO_COFINS = 'COFINS';
    public const IMPOSTO_IPI = 'IPI';

    // Constantes para códigos CST comuns
    public const CST_00 = '00'; // Tributada integralmente
    public const CST_01 = '01'; // Tributada com monofásica - retenção anterior
    public const CST_02 = '02'; // Tributada com monofásica - retenção posterior
    public const CST_03 = '03'; // Isenta
    public const CST_04 = '04'; // Não tributada
    public const CST_05 = '05'; // Suspensa
    public const CST_06 = '06'; // Diferida
    public const CST_07 = '07'; // Substituição tributária
    public const CST_08 = '08'; // Sem incidência
    public const CST_09 = '09'; // Outras operações
    public const CST_40 = '40'; // Isenta (ICMS)
    public const CST_41 = '41'; // Não tributada (ICMS)
    public const CST_50 = '50'; // Suspensa (ICMS)
    public const CST_51 = '51'; // Diferida (ICMS)
    public const CST_60 = '60'; // ICMS cobrado anteriormente por substituição tributária
    public const CST_70 = '70'; // Com redução da base de cálculo e cobrança do ICMS por substituição tributária
    public const CST_90 = '90'; // Outras (ICMS)

    // Scope para filtrar por tipo de imposto
    public function scopePorImposto($query, string $tipoImposto)
    {
        return $query->where('CSTIMPOSTO', $tipoImposto);
    }

    // Scope para filtrar por código CST
    public function scopePorCodigo($query, string $codigoCst)
    {
        return $query->where('CSTCST', $codigoCst);
    }

    // Método estático para buscar CST por tipo e código
    public static function buscarPorTipoECodigo(string $tipoImposto, string $codigoCst): ?self
    {
        return self::where('CSTIMPOSTO', $tipoImposto)
            ->where('CSTCST', $codigoCst)
            ->first();
    }

    // Método estático para validar CST
    public static function validarCst(string $tipoImposto, string $codigoCst): bool
    {
        return self::where('CSTIMPOSTO', $tipoImposto)
            ->where('CSTCST', $codigoCst)
            ->exists();
    }

    // Método estático para listar CSTs por tipo de imposto
    public static function listarPorTipo(string $tipoImposto): \Illuminate\Support\Collection
    {
        return self::where('CSTIMPOSTO', $tipoImposto)
            ->orderBy('CSTCST')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - (CSTIMPOSTO, CSTCST) identifica unicamente cada CST
2. **Validação antes de inserir** - Verificar se CST já existe para o tipo de imposto
3. **Evitar duplicatas** - PK composta previne duplicatas
4. **Padronização** - Manter tipos de imposto padronizados (ICMS, PIS, COFINS, IPI)
5. **Descrições claras** - Manter descrições consistentes com legislação brasileira

### Performance

1. **Tabela pequena** - 101 registros, performance excelente mesmo sem índices adicionais
2. **Índices opcionais** - Devido ao volume pequeno, índices adicionais são opcionais
3. **Consultas frequentes** - CSTs são consultados durante cálculos fiscais
4. **Cache recomendado** - Tabela pequena e estável, ideal para cache em memória

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se CST já existe para o tipo de imposto
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que tipos de imposto sejam válidos
4. **Validação de códigos** - Verificar que códigos CST seguem padrão brasileiro
5. **Descrições obrigatórias** - Garantir que todas as descrições sejam preenchidas

### Manutenção

1. **Revisão periódica** - Verificar se novos CSTs foram adicionados pela Receita Federal
2. **Padronização** - Manter estrutura de tipos de imposto consistente
3. **Documentação** - Documentar significado de cada código CST
4. **Backup regular** - Tabela importante para compliance fiscal
5. **Atualização conforme legislação** - Manter códigos CST atualizados conforme mudanças na legislação brasileira

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

