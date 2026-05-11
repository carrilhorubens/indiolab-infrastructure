# CLITBP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLITBP (Cliente x Tabela de Preço)
- **Total de Registros**: 8.627
- **Total de Colunas**: 8
- **Chave Primária**: (CLICODIGO, TBPCODIGO) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLITBP** é uma tabela de configuração que associa clientes a tabelas de preço com descrições e períodos de validade. Com **8.627 registros**, representa configurações extensivas de tabelas de preço por cliente, permitindo que diferentes clientes tenham diferentes tabelas de preço ativas.

Esta tabela funciona como **configurador de tabelas de preço por cliente** e permite:
- Associar clientes a tabelas de preço específicas
- Configurar descrições personalizadas de fechamento por cliente-tabela
- Controlar períodos de validade das tabelas de preço por cliente
- Suportar múltiplas tabelas de preço por cliente
- Rastrear data de cadastro de cada configuração
- Facilitar gestão de precificação personalizada

Cada registro representa uma configuração específica de tabela de preço para um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Identificação da tabela de preço (TBPCODIGO)
- Descrições personalizadas (TBPDESC, TBPDESC2)
- Descrição de fechamento (TBPDESCFECH)
- Período de validade (TBPDTINICIO, TBPDTVALIDADE)
- Data de cadastro (TBPDTCADASTRO)

O sistema utiliza esta tabela para determinar qual tabela de preço aplicar para cada cliente, permitindo precificação diferenciada e controle de validade.

**Observação Importante:** CLITBP é uma das tabelas mais utilizadas para configuração cliente-tabela de preço, com 8.627 registros. Isso indica uso extensivo de tabelas de preço personalizadas por cliente, essencial para precificação diferenciada.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **TBPCODIGO** 🔑🔗 | SMALLINT | ✓ | Código da tabela de preço (PK + FK → TABPRECO) |

### Descrições Personalizadas
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDESCFECH** | VARCHAR(14) | ✓ | Descrição de fechamento personalizada |
| **TBPDESC** | VARCHAR(16) | | Descrição adicional 1 |
| **TBPDESC2** | VARCHAR(16) | | Descrição adicional 2 |

### Período de Validade
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDTINICIO** | DATE | ✓ | Data de início da validade da tabela para o cliente |
| **TBPDTVALIDADE** | DATE | | Data de término da validade da tabela para o cliente |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDTCADASTRO** | DATE | | Data de cadastro da configuração |

**Primary Key:** (CLICODIGO, TBPCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que terá a tabela de preço configurada.
- **TBPCODIGO**: Tabela de preço que será associada ao cliente.
- **TBPDESCFECH**: Descrição personalizada de fechamento para esta combinação cliente-tabela.
- **TBPDESC, TBPDESC2**: Descrições adicionais personalizadas.
- **TBPDTINICIO**: Data a partir da qual a tabela de preço é válida para o cliente.
- **TBPDTVALIDADE**: Data até a qual a tabela de preço é válida para o cliente (opcional).
- **TBPDTCADASTRO**: Data em que a configuração foi cadastrada.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLITBP Referencia (2 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLITBP.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLITBP
```

**Descrição**: Cada configuração está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente da configuração, relatórios de configurações por cliente.

---

#### 2. TABPRECO - Tabelas de Preço
**Relacionamento:**
```
CLITBP.TBPCODIGO → TABPRECO.TBPCODIGO (N:1)
Constraint: TABPRECO_CLITBP
```

**Descrição**: Cada configuração está vinculada a uma tabela de preço específica.

**Informações da Tabela TABPRECO:**
- **Total:** 112 tabelas de preço
- **PK:** TBPCODIGO
- **Colunas:** 8 campos
- **FK Out:** 0
- **FK In:** 13 tabelas

**Campos importantes em TABPRECO relacionados a CLITBP:**
- `TBPCODIGO` - Código da tabela de preço
- `TBPDESCRICAO` - Descrição da tabela de preço
- `TBPTIPO` - Tipo da tabela de preço
- `TBPSITUACAO` - Situação da tabela de preço
- `TBPDTVALIDADE` - Data de validade geral da tabela
- `TBPDTINICIO` - Data de início geral da tabela

**Uso:** Identificar a tabela de preço da configuração, obter informações da tabela.

---

### CLITBP é Referenciada Por

**Nenhuma tabela** referencia CLITBP diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLITBP → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados às tabelas de preço configuradas.

**Uso:** Aplicar tabelas de preço em pedidos, análises de pedidos considerando tabelas de preço.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLITBP → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas às tabelas de preço.

**Uso:** Aplicar tabelas de preço em notas fiscais, análises de notas considerando tabelas de preço.

---

### Via TABPRECO → TBPPRODU (Produtos da Tabela de Preço)

**Fluxo:** CLITBP → TABPRECO → TBPPRODU

**Descrição:** Através da tabela de preço, é possível identificar produtos e preços configurados.

**Uso:** Obter preços de produtos da tabela de preço para o cliente.

---

### Via TABPRECO → TBPSERVI (Serviços da Tabela de Preço)

**Fluxo:** CLITBP → TABPRECO → TBPSERVI

**Descrição:** Através da tabela de preço, é possível identificar serviços e preços configurados.

**Uso:** Obter preços de serviços da tabela de preço para o cliente.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração Cliente-Tabela de Preço

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente e tabela de preço.

**Fluxo:**
```
CLITBP (CLICODIGO, TBPCODIGO, TBPDTINICIO, TBPDTVALIDADE)
  ↓
CLIEN (CLICODIGO)
  ↓
TABPRECO (TBPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    tp.TBPTIPO AS TIPO_TABELA,
    tp.TBPSITUACAO AS SITUACAO_TABELA,
    ctb.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctb.TBPDESC AS DESCRICAO_1,
    ctb.TBPDESC2 AS DESCRICAO_2,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE,
    ctb.TBPDTCADASTRO AS DATA_CADASTRO,
    CASE 
        WHEN CURRENT_DATE BETWEEN ctb.TBPDTINICIO AND COALESCE(ctb.TBPDTVALIDADE, CURRENT_DATE + 365) THEN 'VIGENTE'
        WHEN CURRENT_DATE < ctb.TBPDTINICIO THEN 'FUTURA'
        ELSE 'EXPIRADA'
    END AS STATUS_VIGENCIA
FROM CLITBP ctb
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctb.CLICODIGO
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.CLICODIGO = ?
  AND ctb.TBPCODIGO = ?;
```

---

### Exemplo 2: Análise de Tabelas de Preço por Cliente

**Objetivo:** Identificar todas as tabelas de preço configuradas para um cliente específico.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLITBP (CLICODIGO)
  ↓
TABPRECO (TBPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    tp.TBPTIPO AS TIPO_TABELA,
    ctb.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE,
    CASE 
        WHEN CURRENT_DATE BETWEEN ctb.TBPDTINICIO AND COALESCE(ctb.TBPDTVALIDADE, CURRENT_DATE + 365) THEN 'VIGENTE'
        WHEN CURRENT_DATE < ctb.TBPDTINICIO THEN 'FUTURA'
        ELSE 'EXPIRADA'
    END AS STATUS_VIGENCIA
FROM CLITBP ctb
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.CLICODIGO = ?
ORDER BY ctb.TBPDTINICIO DESC;
```

---

### Exemplo 3: Análise de Tabelas de Preço Vigentes

**Objetivo:** Obter tabelas de preço vigentes para um cliente em uma data específica.

**Query SQL:**
```sql
SELECT
    ctb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE
FROM CLITBP ctb
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctb.CLICODIGO
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.CLICODIGO = ?
  AND ctb.TBPDTINICIO <= CURRENT_DATE
  AND (ctb.TBPDTVALIDADE IS NULL OR ctb.TBPDTVALIDADE >= CURRENT_DATE)
ORDER BY ctb.TBPDTINICIO DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração Cliente-Tabela de Preço

**Objetivo:** Obter a configuração de uma tabela de preço específica para um cliente.

```sql
SELECT
    CLICODIGO,
    TBPCODIGO,
    TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    TBPDESC AS DESCRICAO_1,
    TBPDESC2 AS DESCRICAO_2,
    TBPDTINICIO AS DATA_INICIO,
    TBPDTVALIDADE AS DATA_VALIDADE,
    TBPDTCADASTRO AS DATA_CADASTRO
FROM CLITBP
WHERE CLICODIGO = ?
  AND TBPCODIGO = ?;
```

---

### 2. Listar Todas as Tabelas de Preço de um Cliente

**Objetivo:** Obter todas as tabelas de preço configuradas para um cliente.

```sql
SELECT
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    tp.TBPTIPO AS TIPO_TABELA,
    ctb.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE
FROM CLITBP ctb
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.CLICODIGO = ?
ORDER BY ctb.TBPDTINICIO DESC;
```

---

### 3. Buscar Tabela de Preço Vigente para Cliente

**Objetivo:** Identificar a tabela de preço vigente para um cliente em uma data específica.

```sql
SELECT
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    tp.TBPTIPO AS TIPO_TABELA,
    ctb.TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE
FROM CLITBP ctb
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.CLICODIGO = ?
  AND ctb.TBPDTINICIO <= ?
  AND (ctb.TBPDTVALIDADE IS NULL OR ctb.TBPDTVALIDADE >= ?)
ORDER BY ctb.TBPDTINICIO DESC
ROWS 1;
```

---

### 4. Análise de Tabelas de Preço Mais Utilizadas

**Objetivo:** Identificar tabelas de preço com mais clientes associados.

```sql
SELECT
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    tp.TBPTIPO AS TIPO_TABELA,
    COUNT(DISTINCT ctb.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN CURRENT_DATE BETWEEN ctb.TBPDTINICIO AND COALESCE(ctb.TBPDTVALIDADE, CURRENT_DATE + 365) THEN 1 END) AS CONFIGURACOES_VIGENTES
FROM CLITBP ctb
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
GROUP BY ctb.TBPCODIGO, tp.TBPDESCRICAO, tp.TBPTIPO
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 5. Análise de Configurações Expiradas

**Objetivo:** Identificar configurações de tabelas de preço que expiraram.

```sql
SELECT
    ctb.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctb.TBPCODIGO,
    tp.TBPDESCRICAO AS TABELA_PRECO,
    ctb.TBPDTINICIO AS DATA_INICIO,
    ctb.TBPDTVALIDADE AS DATA_VALIDADE,
    CURRENT_DATE - ctb.TBPDTVALIDADE AS DIAS_EXPIRADOS
FROM CLITBP ctb
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctb.CLICODIGO
INNER JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE ctb.TBPDTVALIDADE IS NOT NULL
  AND ctb.TBPDTVALIDADE < CURRENT_DATE
ORDER BY ctb.TBPDTVALIDADE DESC;
```

---

### 6. Análise de Configurações com Sobreposição

**Objetivo:** Identificar configurações de tabelas de preço com períodos sobrepostos para o mesmo cliente.

**Query SQL:**
```sql
SELECT
    ctb1.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctb1.TBPCODIGO AS TABELA_1,
    tp1.TBPDESCRICAO AS DESCRICAO_TABELA_1,
    ctb1.TBPDTINICIO AS INICIO_1,
    ctb1.TBPDTVALIDADE AS VALIDADE_1,
    ctb2.TBPCODIGO AS TABELA_2,
    tp2.TBPDESCRICAO AS DESCRICAO_TABELA_2,
    ctb2.TBPDTINICIO AS INICIO_2,
    ctb2.TBPDTVALIDADE AS VALIDADE_2
FROM CLITBP ctb1
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctb1.CLICODIGO
INNER JOIN TABPRECO tp1 ON tp1.TBPCODIGO = ctb1.TBPCODIGO
INNER JOIN CLITBP ctb2 ON ctb2.CLICODIGO = ctb1.CLICODIGO
  AND ctb2.TBPCODIGO != ctb1.TBPCODIGO
INNER JOIN TABPRECO tp2 ON tp2.TBPCODIGO = ctb2.TBPCODIGO
WHERE ctb1.TBPDTINICIO <= COALESCE(ctb2.TBPDTVALIDADE, CURRENT_DATE + 365)
  AND COALESCE(ctb1.TBPDTVALIDADE, CURRENT_DATE + 365) >= ctb2.TBPDTINICIO
ORDER BY ctb1.CLICODIGO, ctb1.TBPDTINICIO;
```

---

### 7. Relatório de Configurações por Cliente

**Objetivo:** Analisar distribuição de configurações de tabelas de preço por cliente.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT ctb.TBPCODIGO) AS TOTAL_TABELAS_PRECO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN CURRENT_DATE BETWEEN ctb.TBPDTINICIO AND COALESCE(ctb.TBPDTVALIDADE, CURRENT_DATE + 365) THEN 1 END) AS CONFIGURACOES_VIGENTES,
    MIN(ctb.TBPDTINICIO) AS PRIMEIRA_CONFIGURACAO,
    MAX(COALESCE(ctb.TBPDTVALIDADE, ctb.TBPDTINICIO)) AS ULTIMA_VALIDADE
FROM CLIEN cl
LEFT JOIN CLITBP ctb ON ctb.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
HAVING COUNT(*) > 0
ORDER BY TOTAL_TABELAS_PRECO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLITBP | Tipo |
|--------|-----------|---------------------|------|
| **CLITBP** | 8.627 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 1.07:1 | Clientes (média de 0.93 configurações por cliente) |
| TABPRECO | 112 | 0.013:1 | Tabelas de preço (média de 77 configurações por tabela) |

**Interpretação:**
- **8.627 configurações** cadastradas no sistema
- **93% dos clientes** têm pelo menos uma configuração de tabela de preço (8.627 de 9.251)
- **Uso extensivo** - indica precificação diferenciada importante
- **Média de 77 configurações por tabela** - uso muito intenso

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLITBP.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por tabela de preço** - Para buscas por tabela
4. **Índice por período** - Para buscas por data

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLITBP_CLIENTE ON CLITBP(CLICODIGO);

-- Índice 2: Busca por tabela de preço (consultas frequentes)
CREATE INDEX IDX_CLITBP_TABELA_PRECO ON CLITBP(TBPCODIGO);

-- Índice 3: Busca por período de validade (consultas frequentes)
CREATE INDEX IDX_CLITBP_PERIODO ON CLITBP(TBPDTINICIO, TBPDTVALIDADE);

-- Índice 4: Busca composta por cliente e período (consultas de validação)
CREATE INDEX IDX_CLITBP_CLI_PERIODO ON CLITBP(CLICODIGO, TBPDTINICIO, TBPDTVALIDADE);
```

### Observações sobre Volume

- **Tabela média-grande** (8.627 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Configurações são consultadas durante criação de pedidos
- **Índices essenciais** - Em CLICODIGO, TBPCODIGO e períodos para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e período

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT ctb.*
FROM CLITBP ctb
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ctb.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem tabela de preço válida
SELECT ctb.*
FROM CLITBP ctb
LEFT JOIN TABPRECO tp ON tp.TBPCODIGO = ctb.TBPCODIGO
WHERE tp.TBPCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLITBP
WHERE CLICODIGO IS NULL
   OR TBPCODIGO IS NULL
   OR TBPDESCFECH IS NULL
   OR TBPDESCFECH = ''
   OR TBPDTINICIO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, TBPCODIGO, COUNT(*) AS QTD
FROM CLITBP
GROUP BY CLICODIGO, TBPCODIGO
HAVING COUNT(*) > 1;

-- Verificar períodos inválidos (data de término antes de início)
SELECT *
FROM CLITBP
WHERE TBPDTVALIDADE IS NOT NULL
  AND TBPDTVALIDADE < TBPDTINICIO;
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

final class FirebirdClitbp extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLITBP';
    
    protected $primaryKey = ['CLICODIGO', 'TBPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'TBPCODIGO' => 'integer',
        'TBPDESCFECH' => 'string',
        'TBPDESC' => 'string',
        'TBPDESC2' => 'string',
        'TBPDTINICIO' => 'date',
        'TBPDTVALIDADE' => 'date',
        'TBPDTCADASTRO' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com TABPRECO
    public function tabelaPreco(): BelongsTo
    {
        return $this->belongsTo(FirebirdTabpreco::class, 'TBPCODIGO', 'TBPCODIGO');
    }

    // Método para verificar se está vigente
    public function estaVigente(?string $data = null): bool
    {
        $dataVerificacao = $data ? \Carbon\Carbon::parse($data) : now();
        $inicio = \Carbon\Carbon::parse($this->TBPDTINICIO);
        $validade = $this->TBPDTVALIDADE ? \Carbon\Carbon::parse($this->TBPDTVALIDADE) : null;
        
        if ($validade) {
            return $dataVerificacao->between($inicio, $validade);
        }
        
        return $dataVerificacao->gte($inicio);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por tabela de preço
    public function scopePorTabelaPreco($query, int $tabelaCodigo)
    {
        return $query->where('TBPCODIGO', $tabelaCodigo);
    }

    // Scope para filtrar apenas vigentes
    public function scopeVigentes($query, ?string $data = null)
    {
        $dataVerificacao = $data ? \Carbon\Carbon::parse($data) : now();
        
        return $query->where('TBPDTINICIO', '<=', $dataVerificacao->format('Y-m-d'))
            ->where(function($q) use ($dataVerificacao) {
                $q->whereNull('TBPDTVALIDADE')
                  ->orWhere('TBPDTVALIDADE', '>=', $dataVerificacao->format('Y-m-d'));
            });
    }

    // Método estático para buscar tabela de preço vigente
    public static function buscarTabelaPrecoVigente(int $clienteCodigo, ?string $data = null): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->vigentes($data)
            ->orderBy('TBPDTINICIO', 'desc')
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e tabela de preço existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de períodos** - Verificar que data de término não é anterior à de início

### Performance

1. **Tabela média-grande** - 8.627 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO, TBPCODIGO e períodos para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + período)
4. **Consultas frequentes** - Configurações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de períodos** - Verificar que períodos são válidos

### Manutenção

1. **Revisão periódica** - Verificar configurações expiradas
2. **Padronização** - Manter estrutura de descrições consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para precificação personalizada

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

