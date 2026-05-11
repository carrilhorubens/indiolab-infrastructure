# CLIENINFO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIENINFO (Informações Adicionais de Cliente)
- **Total de Registros**: 6.679
- **Total de Colunas**: 3
- **Chave Primária**: (CLICODIGO, CHAVE) - Composta
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIENINFO** é uma tabela de armazenamento flexível no formato chave-valor (key-value) que armazena informações adicionais de clientes que não estão na estrutura fixa da tabela CLIEN. Com **6.679 registros**, representa dados complementares e extensíveis para clientes.

Esta tabela funciona como **armazenamento flexível de informações adicionais** e permite:
- Armazenar informações customizadas por cliente
- Adicionar campos dinâmicos sem modificar a estrutura de CLIEN
- Suportar diferentes tipos de informações (texto, números, datas, etc.)
- Permitir múltiplas informações por cliente através de diferentes chaves
- Facilitar extensibilidade do sistema sem alterações de schema
- Suportar integrações e dados externos

Cada registro representa uma informação adicional de um cliente (CLICODIGO) identificada por uma chave (CHAVE) com um valor correspondente (VALOR), contendo:
- Identificação do cliente (CLICODIGO)
- Chave da informação (CHAVE) - identifica o tipo/campo da informação
- Valor da informação (VALOR) - conteúdo da informação

O sistema utiliza esta tabela para armazenar informações complementares que não se encaixam na estrutura fixa de CLIEN, permitindo flexibilidade e extensibilidade sem necessidade de alterações no schema principal.

**Observação Importante:** CLIENINFO utiliza um padrão de armazenamento chave-valor (EAV - Entity-Attribute-Value), que permite flexibilidade máxima mas pode impactar performance em consultas complexas. A chave (CHAVE) identifica o tipo de informação, enquanto o valor (VALOR) armazena o conteúdo.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **CHAVE** 🔑 | VARCHAR(37) | ✓ | Chave identificadora da informação (PK) |

### Valor da Informação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **VALOR** | VARCHAR(37) | ✓ | Valor da informação armazenada |

**Primary Key:** (CLICODIGO, CHAVE)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente ao qual a informação pertence.
- **CHAVE**: Identificador único do tipo de informação (ex: "EMAIL_ALTERNATIVO", "OBSERVACAO_ESPECIAL", "CODIGO_EXTERNO", etc.).
- **VALOR**: Conteúdo da informação. Pode conter texto, números, datas formatadas, JSON, ou qualquer outro formato textual.

**Padrão EAV (Entity-Attribute-Value):**
- **Entity**: CLICODIGO (entidade cliente)
- **Attribute**: CHAVE (atributo/tipo de informação)
- **Value**: VALOR (valor do atributo)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIENINFO Referencia (1 FK):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIENINFO.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIENINFO
```

**Descrição**: Cada informação adicional está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Campos importantes em CLIEN relacionados a CLIENINFO:**
- `CLICODIGO` - Código do cliente
- `CLINOMEFANT` - Nome fantasia
- `CLIRAZSOCIAL` - Razão social
- `CLICLIENTE` - Flag indicando se é cliente

**Uso:** Identificar o cliente proprietário da informação, relatórios por cliente, análises de informações adicionais por cliente.

**Relação com CLIEN:**
- CLIENINFO complementa CLIEN com informações adicionais
- Múltiplas informações podem existir para o mesmo cliente
- Permite extensibilidade sem modificar CLIEN

---

### CLIENINFO é Referenciada Por

**Nenhuma tabela** referencia CLIENINFO diretamente. Esta é uma tabela folha utilizada para armazenamento e consulta de informações adicionais.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIENINFO → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados às informações adicionais armazenadas.

**Uso:** Análises de pedidos considerando informações adicionais do cliente, filtros baseados em informações customizadas.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIENINFO → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas às informações adicionais.

**Uso:** Análises de notas fiscais considerando informações adicionais do cliente.

---

### Via CLIEN → ENDCLI (Endereços)

**Fluxo:** CLIENINFO → CLIEN → ENDCLI

**Descrição:** Através do cliente, é possível identificar endereços que podem estar relacionados às informações adicionais.

**Uso:** Análises de endereços considerando informações adicionais do cliente.

---

### Via CLIEN → CLINET (Contatos)

**Fluxo:** CLIENINFO → CLIEN → CLINET

**Descrição:** Através do cliente, é possível identificar contatos que podem estar relacionados às informações adicionais.

**Uso:** Análises de contatos considerando informações adicionais do cliente.

---

### Via CLIEN → SITCLI (Situações)

**Fluxo:** CLIENINFO → CLIEN → SITCLI

**Descrição:** Através do cliente, é possível identificar situações que podem estar relacionadas às informações adicionais.

**Uso:** Análises de situações considerando informações adicionais do cliente.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Informações Adicionais por Cliente

**Objetivo:** Obter visão completa de todas as informações adicionais de um cliente.

**Fluxo:**
```
CLIENINFO (CLICODIGO, CHAVE, VALOR)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ci.CHAVE AS TIPO_INFORMACAO,
    ci.VALOR AS VALOR_INFORMACAO,
    CASE 
        WHEN ci.CHAVE LIKE '%EMAIL%' THEN 'EMAIL'
        WHEN ci.CHAVE LIKE '%TELEFONE%' THEN 'TELEFONE'
        WHEN ci.CHAVE LIKE '%OBS%' THEN 'OBSERVACAO'
        WHEN ci.CHAVE LIKE '%CODIGO%' THEN 'CODIGO'
        ELSE 'OUTRO'
    END AS CATEGORIA
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
WHERE ci.CLICODIGO = ?
ORDER BY ci.CHAVE;
```

---

### Exemplo 2: Análise de Distribuição de Informações por Tipo

**Objetivo:** Identificar quais tipos de informações adicionais são mais comuns.

**Fluxo:**
```
CLIENINFO (CHAVE, VALOR)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    ci.CHAVE AS TIPO_INFORMACAO,
    COUNT(DISTINCT ci.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_INFORMACOES,
    COUNT(DISTINCT CASE WHEN ci.VALOR IS NOT NULL AND ci.VALOR != '' THEN ci.CLICODIGO END) AS COM_VALOR_PREENCHIDO,
    STRING_AGG(DISTINCT SUBSTRING(ci.VALOR, 1, 50), ', ') AS EXEMPLOS_VALORES
FROM CLIENINFO ci
GROUP BY ci.CHAVE
ORDER BY TOTAL_CLIENTES DESC;
```

---

### Exemplo 3: Análise de Informações com Pedidos

**Objetivo:** Identificar informações adicionais de clientes que têm pedidos e analisar correlações.

**Fluxo:**
```
CLIENINFO (CLICODIGO, CHAVE, VALOR)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    ci.CHAVE AS TIPO_INFORMACAO,
    COUNT(DISTINCT ci.CLICODIGO) AS TOTAL_CLIENTES_COM_INFO,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pd.ID_PEDIDO) * 1.0 / COUNT(DISTINCT ci.CLICODIGO) AS MEDIA_PEDIDOS_POR_CLIENTE,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = ci.CLICODIGO
GROUP BY ci.CHAVE
ORDER BY TOTAL_CLIENTES_COM_INFO DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Todas as Informações de um Cliente

**Objetivo:** Obter todas as informações adicionais de um cliente específico.

```sql
SELECT
    ci.CHAVE AS TIPO_INFORMACAO,
    ci.VALOR AS VALOR_INFORMACAO
FROM CLIENINFO ci
WHERE ci.CLICODIGO = ?
ORDER BY ci.CHAVE;
```

---

### 2. Buscar Informação Específica de um Cliente

**Objetivo:** Obter uma informação específica de um cliente usando a chave.

```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ci.CHAVE AS TIPO_INFORMACAO,
    ci.VALOR AS VALOR_INFORMACAO
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
WHERE ci.CLICODIGO = ?
  AND ci.CHAVE = ?;
```

---

### 3. Buscar Clientes com Informação Específica

**Objetivo:** Identificar clientes que possuem uma informação específica.

```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ci.VALOR AS VALOR_INFORMACAO
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
WHERE ci.CHAVE = ?
  AND ci.VALOR IS NOT NULL
  AND ci.VALOR != ''
ORDER BY cl.CLINOMEFANT;
```

---

### 4. Análise de Tipos de Informações Mais Utilizadas

**Objetivo:** Identificar quais tipos de informações são mais comuns no sistema.

```sql
SELECT
    ci.CHAVE AS TIPO_INFORMACAO,
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(DISTINCT ci.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(CASE WHEN ci.VALOR IS NOT NULL AND ci.VALOR != '' THEN 1 END) AS COM_VALOR_PREENCHIDO,
    COUNT(CASE WHEN ci.VALOR IS NULL OR ci.VALOR = '' THEN 1 END) AS SEM_VALOR,
    ROUND(COUNT(CASE WHEN ci.VALOR IS NOT NULL AND ci.VALOR != '' THEN 1 END) * 100.0 / COUNT(*), 2) AS PERCENTUAL_PREENCHIDO
FROM CLIENINFO ci
GROUP BY ci.CHAVE
ORDER BY TOTAL_REGISTROS DESC;
```

---

### 5. Relatório de Clientes com Mais Informações Adicionais

**Objetivo:** Identificar clientes que têm mais informações adicionais cadastradas.

```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    COUNT(*) AS TOTAL_INFORMACOES,
    COUNT(CASE WHEN ci.VALOR IS NOT NULL AND ci.VALOR != '' THEN 1 END) AS INFORMACOES_PREENCHIDAS,
    STRING_AGG(ci.CHAVE, ', ') AS TIPOS_INFORMACOES
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
GROUP BY ci.CLICODIGO, cl.CLINOMEFANT, cl.CLIRAZSOCIAL
ORDER BY TOTAL_INFORMACOES DESC;
```

---

### 6. Buscar Informações por Padrão de Chave

**Objetivo:** Identificar informações que seguem um padrão específico na chave.

```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ci.CHAVE AS TIPO_INFORMACAO,
    ci.VALOR AS VALOR_INFORMACAO
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
WHERE ci.CHAVE LIKE '%EMAIL%'
   OR ci.CHAVE LIKE '%TELEFONE%'
   OR ci.CHAVE LIKE '%CONTATO%'
ORDER BY ci.CLICODIGO, ci.CHAVE;
```

---

### 7. Análise de Informações Duplicadas ou Inconsistentes

**Objetivo:** Identificar informações duplicadas ou inconsistentes para o mesmo cliente.

```sql
SELECT
    ci.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ci.CHAVE AS TIPO_INFORMACAO,
    COUNT(*) AS TOTAL_DUPLICATAS,
    STRING_AGG(DISTINCT ci.VALOR, ' | ') AS VALORES_DIFERENTES
FROM CLIENINFO ci
INNER JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
GROUP BY ci.CLICODIGO, cl.CLINOMEFANT, ci.CHAVE
HAVING COUNT(*) > 1
ORDER BY TOTAL_DUPLICATAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIENINFO | Tipo |
|--------|-----------|---------------------|------|
| **CLIENINFO** | 6.679 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 1.38:1 | Clientes (média de 0.72 informações por cliente) |

**Interpretação:**
- **6.679 informações adicionais** cadastradas no sistema
- **Média de 0.72 informações por cliente** - nem todos os clientes têm informações adicionais
- **72% dos clientes** têm pelo menos uma informação adicional (6.679 de 9.251)
- **Armazenamento flexível** - permite múltiplas informações por cliente sem limite fixo

**Distribuição Esperada:**
- Clientes com muitas informações: clientes importantes ou com necessidades específicas
- Clientes com poucas informações: clientes padrão ou novos
- Tipos de informações variados: diferentes chaves para diferentes propósitos

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLICODIGO, CHAVE** | CLIENINFO | Chave primária composta (PK) |
| **CLICODIGO** | CLIENINFO → CLIEN | Cliente da informação |
| **CHAVE** | CLIENINFO | Tipo/identificador da informação |
| **VALOR** | CLIENINFO | Conteúdo da informação |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIENINFO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por chave** - Para buscas por tipo de informação
4. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIENINFO_CLIENTE ON CLIENINFO(CLICODIGO);

-- Índice 2: Busca por chave (consultas por tipo de informação)
CREATE INDEX IDX_CLIENINFO_CHAVE ON CLIENINFO(CHAVE);

-- Índice 3: Busca composta por cliente e chave (consultas de validação)
CREATE INDEX IDX_CLIENINFO_CLI_CHAVE ON CLIENINFO(CLICODIGO, CHAVE);

-- Índice 4: Busca por valor (consultas específicas - usar com cuidado)
CREATE INDEX IDX_CLIENINFO_VALOR ON CLIENINFO(VALOR) 
    WHERE VALOR IS NOT NULL AND VALOR != '';
```

### Observações sobre Volume

- **Tabela média** (6.679 registros) - Performance moderada
- **Consultas são rápidas** devido ao volume moderado
- **Índices úteis** para buscas por cliente e chave
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e chave
- **Cuidado com LIKE em VALOR** - Buscas por conteúdo podem ser lentas

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK composta)
SELECT CLICODIGO, CHAVE, VALOR
FROM CLIENINFO
WHERE CLICODIGO = ?
  AND CHAVE = ?;

-- ✅ OTIMIZADO (usar índice em CLICODIGO)
SELECT CLICODIGO, CHAVE, VALOR
FROM CLIENINFO
WHERE CLICODIGO = ?
ORDER BY CHAVE;

-- ✅ OTIMIZADO (usar índice em CHAVE)
SELECT CLICODIGO, CHAVE, VALOR
FROM CLIENINFO
WHERE CHAVE = ?
ORDER BY CLICODIGO;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CLICODIGO, CHAVE, VALOR
FROM CLIENINFO
WHERE CLICODIGO = ?
  AND CHAVE LIKE 'EMAIL%'
ORDER BY CHAVE;

-- ⚠️ CUIDADO (busca por conteúdo pode ser lenta)
SELECT CLICODIGO, CHAVE, VALOR
FROM CLIENINFO
WHERE VALOR LIKE '%@%'
ORDER BY CLICODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar informações sem cliente válido
SELECT ci.*
FROM CLIENINFO ci
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ci.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar informações com chave vazia ou nula
SELECT *
FROM CLIENINFO
WHERE CHAVE IS NULL
   OR CHAVE = '';

-- Verificar informações com valor vazio (pode ser válido dependendo do contexto)
SELECT *
FROM CLIENINFO
WHERE VALOR IS NULL
   OR VALOR = '';
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIENINFO
WHERE CLICODIGO IS NULL
   OR CHAVE IS NULL
   OR CHAVE = ''
   OR VALOR IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, CHAVE, COUNT(*) AS QTD
FROM CLIENINFO
GROUP BY CLICODIGO, CHAVE
HAVING COUNT(*) > 1;

-- Verificar chaves muito longas (pode indicar problema)
SELECT *
FROM CLIENINFO
WHERE LENGTH(CHAVE) > 30;

-- Verificar valores muito longos (pode indicar problema)
SELECT *
FROM CLIENINFO
WHERE LENGTH(VALOR) > 30;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por cliente
SELECT
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_INFORMACOES,
    AVG(INFORMACOES_POR_CLIENTE) AS MEDIA_INFORMACOES_POR_CLIENTE,
    MAX(INFORMACOES_POR_CLIENTE) AS MAX_INFORMACOES_POR_CLIENTE,
    MIN(INFORMACOES_POR_CLIENTE) AS MIN_INFORMACOES_POR_CLIENTE
FROM (
    SELECT 
        CLICODIGO,
        COUNT(*) AS INFORMACOES_POR_CLIENTE
    FROM CLIENINFO
    GROUP BY CLICODIGO
);

-- Verificar distribuição por tipo de informação (chave)
SELECT
    COUNT(DISTINCT CHAVE) AS TOTAL_TIPOS_INFORMACAO,
    COUNT(*) AS TOTAL_INFORMACOES,
    AVG(INFORMACOES_POR_TIPO) AS MEDIA_INFORMACOES_POR_TIPO,
    MAX(INFORMACOES_POR_TIPO) AS MAX_INFORMACOES_POR_TIPO,
    MIN(INFORMACOES_POR_TIPO) AS MIN_INFORMACOES_POR_TIPO
FROM (
    SELECT 
        CHAVE,
        COUNT(*) AS INFORMACOES_POR_TIPO
    FROM CLIENINFO
    GROUP BY CHAVE
);

-- Verificar informações com valores preenchidos vs vazios
SELECT
    COUNT(*) AS TOTAL_INFORMACOES,
    COUNT(CASE WHEN VALOR IS NOT NULL AND VALOR != '' THEN 1 END) AS COM_VALOR_PREENCHIDO,
    COUNT(CASE WHEN VALOR IS NULL OR VALOR = '' THEN 1 END) AS SEM_VALOR,
    ROUND(COUNT(CASE WHEN VALOR IS NOT NULL AND VALOR != '' THEN 1 END) * 100.0 / COUNT(*), 2) AS PERCENTUAL_PREENCHIDO
FROM CLIENINFO;
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
use Illuminate\Support\Collection;

final class FirebirdClieninfo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIENINFO';
    
    protected $primaryKey = ['CLICODIGO', 'CHAVE'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'CHAVE' => 'string',
        'VALOR' => 'string',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Método para verificar se tem valor preenchido
    public function temValor(): bool
    {
        return !empty($this->VALOR);
    }

    // Método para obter valor como array (se for JSON)
    public function getValorComoArray(): ?array
    {
        if (empty($this->VALOR)) {
            return null;
        }
        
        $decoded = json_decode($this->VALOR, true);
        return json_last_error() === JSON_ERROR_NONE ? $decoded : null;
    }

    // Método para obter valor como número (se for numérico)
    public function getValorComoNumero(): ?float
    {
        if (empty($this->VALOR)) {
            return null;
        }
        
        return is_numeric($this->VALOR) ? (float) $this->VALOR : null;
    }

    // Método para obter valor como boolean (se for booleano)
    public function getValorComoBoolean(): ?bool
    {
        if (empty($this->VALOR)) {
            return null;
        }
        
        $lower = strtolower($this->VALOR);
        if (in_array($lower, ['true', '1', 's', 'sim', 'yes'])) {
            return true;
        }
        if (in_array($lower, ['false', '0', 'n', 'nao', 'no'])) {
            return false;
        }
        
        return null;
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por chave
    public function scopePorChave($query, string $chave)
    {
        return $query->where('CHAVE', $chave);
    }

    // Scope para filtrar por padrão de chave
    public function scopePorPadraoChave($query, string $padrao)
    {
        return $query->where('CHAVE', 'LIKE', $padrao);
    }

    // Scope para filtrar informações com valor preenchido
    public function scopeComValor($query)
    {
        return $query->whereNotNull('VALOR')
            ->where('VALOR', '!=', '');
    }

    // Scope para filtrar informações sem valor
    public function scopeSemValor($query)
    {
        return $query->where(function($q) {
            $q->whereNull('VALOR')
              ->orWhere('VALOR', '');
        });
    }

    // Scope para filtrar por valor (busca exata)
    public function scopePorValor($query, string $valor)
    {
        return $query->where('VALOR', $valor);
    }

    // Scope para filtrar por padrão de valor (busca parcial)
    public function scopePorPadraoValor($query, string $padrao)
    {
        return $query->where('VALOR', 'LIKE', $padrao);
    }

    // Método estático para buscar informação específica
    public static function buscarInformacao(int $clienteCodigo, string $chave): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('CHAVE', $chave)
            ->first();
    }

    // Método estático para obter valor de informação específica
    public static function obterValor(int $clienteCodigo, string $chave): ?string
    {
        $info = self::buscarInformacao($clienteCodigo, $chave);
        return $info?->VALOR;
    }

    // Método estático para definir informação
    public static function definirInformacao(int $clienteCodigo, string $chave, string $valor): bool
    {
        return self::updateOrCreate(
            ['CLICODIGO' => $clienteCodigo, 'CHAVE' => $chave],
            ['VALOR' => $valor]
        ) !== null;
    }

    // Método estático para remover informação
    public static function removerInformacao(int $clienteCodigo, string $chave): bool
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('CHAVE', $chave)
            ->delete() > 0;
    }

    // Método estático para obter todas as informações de um cliente como array associativo
    public static function obterInformacoesDoCliente(int $clienteCodigo): array
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->comValor()
            ->pluck('VALOR', 'CHAVE')
            ->toArray();
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_informacoes' => self::count(),
            'total_clientes' => self::distinct('CLICODIGO')->count(),
            'total_tipos_informacao' => self::distinct('CHAVE')->count(),
            'com_valor_preenchido' => self::comValor()->count(),
            'sem_valor' => self::semValor()->count(),
        ];
    }

    // Método estático para obter tipos de informações mais utilizadas
    public static function getTiposMaisUtilizados(int $limite = 10): Collection
    {
        return self::selectRaw('CHAVE, COUNT(*) as total')
            ->groupBy('CHAVE')
            ->orderByDesc('total')
            ->limit($limite)
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente existe
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Padronização de chaves** - Usar nomes consistentes e descritivos

### Performance

1. **Tabela média** - 6.679 registros, performance moderada
2. **Índices úteis** - Em CLICODIGO e CHAVE para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + chave)
4. **Cuidado com LIKE** - Buscas por conteúdo podem ser lentas

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de chaves** - Padronizar nomes de chaves

### Manutenção

1. **Revisão periódica** - Verificar informações não utilizadas
2. **Padronização** - Manter estrutura de chaves consistente
3. **Documentação** - Documentar significado de cada chave utilizada
4. **Backup regular** - Tabela importante para informações complementares

### Regras de Negócio

1. **Validação em tempo real** - Verificar se informação existe antes de usar
2. **Consistência** - Garantir que informações usadas estão corretas
3. **Flexibilidade** - Permitir diferentes tipos de informações
4. **Extensibilidade** - Facilita adicionar novos tipos sem alterar schema

### Observações Especiais

1. **Padrão EAV** - Entity-Attribute-Value permite flexibilidade máxima
2. **Armazenamento flexível** - Permite múltiplas informações por cliente
3. **Sem dependentes** - Tabela folha utilizada para armazenamento e consulta
4. **Complemento de CLIEN** - Estende informações sem modificar estrutura fixa

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

