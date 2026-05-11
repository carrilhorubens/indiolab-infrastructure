# COMPOPROROT - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOPROROT (Composição x Produto x Rotina x Empresa)
- **Total de Registros**: 287.936
- **Total de Colunas**: 4
- **Chave Primária**: (PROCODIGO, COMPOCOD, ROTCODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 0 (formais)
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOPROROT** é uma tabela de configuração que relaciona produtos, composições, rotinas de produção e empresas, permitindo definir rotinas específicas de produção para composições de produtos em diferentes empresas. Com **287.936 registros**, representa configurações extensivas de rotinas de produção por composição, produto e empresa.

Esta tabela funciona como **configuração de rotinas de produção por composição** e permite:
- Definir rotinas de produção específicas para composições de produtos
- Suportar múltiplas rotinas por composição
- Permitir configurações específicas por empresa
- Facilitar gestão de processos de produção
- Suportar roteamento de produção por composição

Cada registro representa uma configuração específica de rotina de produção para uma composição de produto em uma empresa, contendo:
- Identificação do produto (PROCODIGO)
- Código da composição (COMPOCOD)
- Código da rotina (ROTCODIGO)
- Código da empresa (EMPCODIGO)

O sistema utiliza esta tabela para determinar qual rotina de produção deve ser utilizada para uma composição específica de produto em uma empresa específica.

**Observação Importante:** COMPOPROROT trabalha em conjunto com outras tabelas de composição (COMPO, COMPOSICAO) e rotinas (ROTEIRO) para definir processos de produção. Com 287.936 registros, indica uso extensivo de configuração de rotinas por composição, essencial para gestão de produção multi-empresa.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔑 | VARCHAR(14) | ✓ | Código do produto (PK, lógica → PRODU) |
| **COMPOCOD** 🔑 | INTEGER | ✓ | Código da composição (PK, lógica → COMPO) |
| **ROTCODIGO** 🔑 | SMALLINT | ✓ | Código da rotina (PK, lógica → ROTEIRO) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK, lógica → EMPRESA) |

**Primary Key:** (PROCODIGO, COMPOCOD, ROTCODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **PROCODIGO**: Produto relacionado à composição e rotina.
- **COMPOCOD**: Código da composição relacionada ao produto.
- **ROTCODIGO**: Rotina de produção a ser utilizada para esta composição.
- **EMPCODIGO**: Empresa para a qual esta configuração é válida.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOPROROT Referencia (0 FKs Formais):

**Nenhuma foreign key formal** está definida na tabela COMPOPROROT. No entanto, há relacionamentos lógicos importantes:

#### 1. PRODU - Produtos (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROT.PROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto da configuração, obter informações do produto.

---

#### 2. COMPO - Composições (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROT.COMPOCOD → COMPO.CMPCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma composição específica.

**Informações da Tabela COMPO:**
- **Total:** 108.055 composições
- **PK:** (PROCODIGO, CMPCODIGO)

**Uso:** Identificar a composição da configuração, obter informações da composição.

---

#### 3. ROTEIRO - Rotinas (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROT.ROTCODIGO → ROTEIRO.ROTCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma rotina específica.

**Uso:** Identificar a rotina de produção da configuração, obter informações da rotina.

---

#### 4. EMPRESA - Empresas (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROT.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma empresa específica.

**Uso:** Identificar a empresa da configuração, obter informações da empresa.

---

### COMPOPROROT é Referenciada Por

**Nenhuma tabela** referencia COMPOPROROT diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PROCODIGO → PRODU → PDCAO (Ordens de Produção)

**Fluxo:** COMPOPROROT → PRODU → PDCAO

**Descrição:** Através do produto, é possível identificar ordens de produção relacionadas.

**Uso:** Análise de produção usando rotinas configuradas.

---

### Via COMPOCOD → COMPO → PRODU (Componentes)

**Fluxo:** COMPOPROROT → COMPO → PRODU

**Descrição:** Através da composição, é possível identificar componentes relacionados.

**Uso:** Análise de componentes com rotinas configuradas.

---

### Via ROTCODIGO → ROTEIRO → Processos

**Fluxo:** COMPOPROROT → ROTEIRO → Processos

**Descrição:** Através da rotina, é possível identificar processos relacionados.

**Uso:** Análise de processos de produção.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração de Rotina

**Objetivo:** Obter visão completa de uma configuração de rotina incluindo informações do produto, composição, rotina e empresa.

**Fluxo:**
```
COMPOPROROT (PROCODIGO, COMPOCOD, ROTCODIGO, EMPCODIGO)
  ↓
PRODU (PROCODIGO)
  ↓
COMPO (PROCODIGO, CMPCODIGO)
  ↓
ROTEIRO (ROTCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cpr.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cpr.COMPOCOD,
    co.CMPQTDADE AS QUANTIDADE_COMPOSICAO,
    cpr.ROTCODIGO,
    rot.ROTDESCRICAO AS ROTINA,
    cpr.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA
FROM COMPOPROROT cpr
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpr.PROCODIGO
LEFT JOIN COMPO co ON co.PROCODIGO = cpr.PROCODIGO
  AND co.CMPCODIGO = cpr.COMPOCOD
LEFT JOIN ROTEIRO rot ON rot.ROTCODIGO = cpr.ROTCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cpr.EMPCODIGO
WHERE cpr.PROCODIGO = ?
  AND cpr.EMPCODIGO = ?
ORDER BY cpr.COMPOCOD, cpr.ROTCODIGO;
```

---

### Exemplo 2: Análise de Rotinas por Empresa

**Objetivo:** Obter rotinas configuradas agrupadas por empresa.

**Query SQL:**
```sql
SELECT
    cpr.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cpr.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT cpr.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT cpr.ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROT cpr
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cpr.EMPCODIGO
GROUP BY cpr.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### Exemplo 3: Análise de Rotinas Mais Utilizadas

**Objetivo:** Identificar rotinas mais utilizadas em configurações.

**Query SQL:**
```sql
SELECT
    cpr.ROTCODIGO,
    rot.ROTDESCRICAO AS ROTINA,
    COUNT(DISTINCT cpr.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT cpr.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT cpr.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROT cpr
LEFT JOIN ROTEIRO rot ON rot.ROTCODIGO = cpr.ROTCODIGO
GROUP BY cpr.ROTCODIGO, rot.ROTDESCRICAO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Rotina

**Objetivo:** Obter configuração de rotina para um produto, composição e empresa específicos.

```sql
SELECT
    PROCODIGO,
    COMPOCOD,
    ROTCODIGO,
    EMPCODIGO
FROM COMPOPROROT
WHERE PROCODIGO = ?
  AND COMPOCOD = ?
  AND EMPCODIGO = ?;
```

---

### 2. Listar Rotinas de um Produto

**Objetivo:** Obter todas as rotinas configuradas para um produto específico.

```sql
SELECT
    COMPOCOD,
    ROTCODIGO,
    EMPCODIGO
FROM COMPOPROROT
WHERE PROCODIGO = ?
ORDER BY EMPCODIGO, COMPOCOD, ROTCODIGO;
```

---

### 3. Análise de Configurações por Empresa

**Objetivo:** Obter todas as configurações de rotinas de uma empresa específica.

```sql
SELECT
    PROCODIGO,
    COMPOCOD,
    ROTCODIGO
FROM COMPOPROROT
WHERE EMPCODIGO = ?
ORDER BY PROCODIGO, COMPOCOD, ROTCODIGO;
```

---

### 4. Análise de Produtos com Mais Rotinas

**Objetivo:** Identificar produtos com mais rotinas configuradas.

```sql
SELECT
    PROCODIGO,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROT
GROUP BY PROCODIGO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 5. Análise de Composições com Rotinas

**Objetivo:** Identificar composições com rotinas configuradas.

**Query SQL:**
```sql
SELECT
    COMPOCOD,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROT
GROUP BY COMPOCOD
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 6. Análise de Rotinas por Produto e Empresa

**Objetivo:** Obter rotinas configuradas agrupadas por produto e empresa.

**Query SQL:**
```sql
SELECT
    cpr.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cpr.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cpr.ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT cpr.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROT cpr
LEFT JOIN PRODU pr ON pr.PROCODIGO = cpr.PROCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cpr.EMPCODIGO
GROUP BY cpr.PROCODIGO, pr.PRODESCRICAO, cpr.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY cpr.PROCODIGO, cpr.EMPCODIGO;
```

---

### 7. Relatório de Configurações de Rotinas

**Objetivo:** Analisar distribuição completa de configurações de rotinas.

**Query SQL:**
```sql
SELECT
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(configs_por_produto.TOTAL) AS MEDIA_CONFIGURACOES_POR_PRODUTO
FROM COMPOPROROT
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM COMPOPROROT
    GROUP BY PROCODIGO
) configs_por_produto;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOPROROT | Tipo |
|--------|-----------|---------------------|------|
| **COMPOPROROT** | 287.936 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | 178.187 | 0.62:1 | Produtos (média de 1.62 configurações por produto) |
| COMPO | 108.055 | 0.38:1 | Composições (média de 2.66 configurações por composição) |
| EMPRESA | ~128 | ~2.250:1 | Empresas (média de 2.250 configurações por empresa) |

**Interpretação:**
- **287.936 configurações** cadastradas no sistema
- **Média de 1.62 configurações por produto** - produtos têm múltiplas configurações
- **Média de 2.66 configurações por composição** - composições têm múltiplas rotinas
- **Uso extensivo** - indica configuração detalhada de rotinas de produção

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela COMPOPROROT.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por produto** - Para buscas por produto
3. **Índice por empresa** - Para buscas por empresa
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto (consultas frequentes)
CREATE INDEX IDX_COMPOPROROT_PRODUTO ON COMPOPROROT(PROCODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_COMPOPROROT_EMPRESA ON COMPOPROROT(EMPCODIGO);

-- Índice 3: Busca composta por produto e empresa (consultas frequentes)
CREATE INDEX IDX_COMPOPROROT_PRO_EMP ON COMPOPROROT(PROCODIGO, EMPCODIGO);

-- Índice 4: Busca composta por composição e rotina (consultas frequentes)
CREATE INDEX IDX_COMPOPROROT_COMP_ROT ON COMPOPROROT(COMPOCOD, ROTCODIGO);
```

### Observações sobre Volume

- **Tabela média-grande** (287.936 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Configurações são consultadas durante criação de ordens de produção
- **Índices essenciais** - Em PROCODIGO, EMPCODIGO e combinações para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Lógica

```sql
-- Verificar produtos inexistentes
SELECT DISTINCT cpr.PROCODIGO
FROM COMPOPROROT cpr
WHERE NOT EXISTS (SELECT 1 FROM PRODU pr WHERE pr.PROCODIGO = cpr.PROCODIGO);

-- Verificar composições inexistentes
SELECT DISTINCT cpr.COMPOCOD
FROM COMPOPROROT cpr
WHERE NOT EXISTS (
    SELECT 1 FROM COMPO co 
    WHERE co.PROCODIGO = cpr.PROCODIGO 
      AND co.CMPCODIGO = cpr.COMPOCOD
);

-- Verificar rotinas inexistentes
SELECT DISTINCT cpr.ROTCODIGO
FROM COMPOPROROT cpr
WHERE NOT EXISTS (SELECT 1 FROM ROTEIRO rot WHERE rot.ROTCODIGO = cpr.ROTCODIGO);

-- Verificar empresas inexistentes
SELECT DISTINCT cpr.EMPCODIGO
FROM COMPOPROROT cpr
WHERE NOT EXISTS (SELECT 1 FROM EMPRESA emp WHERE emp.EMPCODIGO = cpr.EMPCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOPROROT
WHERE PROCODIGO IS NULL
   OR PROCODIGO = ''
   OR COMPOCOD IS NULL
   OR ROTCODIGO IS NULL
   OR EMPCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT PROCODIGO, COMPOCOD, ROTCODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM COMPOPROROT
GROUP BY PROCODIGO, COMPOCOD, ROTCODIGO, EMPCODIGO
HAVING COUNT(*) > 1;
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

final class FirebirdCompoprorot extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOPROROT';
    
    protected $primaryKey = ['PROCODIGO', 'COMPOCOD', 'ROTCODIGO', 'EMPCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'PROCODIGO' => 'string',
        'COMPOCOD' => 'integer',
        'ROTCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
    ];

    // Relacionamento lógico com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    // Relacionamento lógico com COMPO
    public function composicao(): BelongsTo
    {
        return $this->belongsTo(FirebirdCompo::class, ['PROCODIGO', 'COMPOCOD'], ['PROCODIGO', 'CMPCODIGO']);
    }

    // Relacionamento lógico com ROTEIRO
    public function rotina(): BelongsTo
    {
        return $this->belongsTo(FirebirdRoteiro::class, 'ROTCODIGO', 'ROTCODIGO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Scope para filtrar por produto
    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por composição
    public function scopePorComposicao($query, int $composicaoCodigo)
    {
        return $query->where('COMPOCOD', $composicaoCodigo);
    }

    // Método estático para buscar rotina de uma configuração
    public static function buscarRotina(string $produtoCodigo, int $composicaoCodigo, int $empresaCodigo): ?self
    {
        return self::where('PROCODIGO', $produtoCodigo)
            ->where('COMPOCOD', $composicaoCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 4 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se entidades relacionadas existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de códigos** - Verificar que códigos são válidos

### Performance

1. **Tabela média-grande** - 287.936 registros, performance boa com índices adequados
2. **Índices essenciais** - Em PROCODIGO, EMPCODIGO e combinações para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (produto + empresa, composição + rotina)
4. **Consultas frequentes** - Configurações são consultadas durante criação de ordens de produção

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura consistente
3. **Documentação** - Documentar significado de cada configuração
4. **Backup regular** - Tabela importante para gestão de produção

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

