# COMPOPROROTALX - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOPROROTALX (Composição x Produto x Rotina x Almoxarifado x Empresa)
- **Total de Registros**: 304.442
- **Total de Colunas**: 5
- **Chave Primária**: (PROCODIGO, COMPOCOD, ROTCODIGO, ALXCODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 0 (formais)
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOPROROTALX** é uma tabela de configuração que relaciona produtos, composições, rotinas de produção, almoxarifados/células e empresas, permitindo definir rotinas específicas de produção para composições de produtos em diferentes células e empresas. Com **304.442 registros**, representa configurações extensivas de rotinas de produção por composição, produto, célula e empresa.

Esta tabela funciona como **configuração de rotinas de produção por composição e célula** e permite:
- Definir rotinas de produção específicas para composições de produtos em células específicas
- Suportar múltiplas rotinas por composição e célula
- Permitir configurações específicas por empresa e célula
- Facilitar gestão de processos de produção por célula
- Suportar roteamento de produção por composição e célula

Cada registro representa uma configuração específica de rotina de produção para uma composição de produto em uma célula específica de uma empresa, contendo:
- Identificação do produto (PROCODIGO)
- Código da composição (COMPOCOD)
- Código da rotina (ROTCODIGO)
- Código do almoxarifado/célula (ALXCODIGO)
- Código da empresa (EMPCODIGO)

O sistema utiliza esta tabela para determinar qual rotina de produção deve ser utilizada para uma composição específica de produto em uma célula específica de uma empresa específica.

**Observação Importante:** COMPOPROROTALX é uma extensão de COMPOPROROT que adiciona a dimensão de célula/almoxarifado (ALXCODIGO). Com 304.442 registros (vs 287.936 de COMPOPROROT), indica que a maioria das configurações incluem especificação de célula, essencial para gestão de produção multi-célula e multi-empresa.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔑 | VARCHAR(14) | ✓ | Código do produto (PK, lógica → PRODU) |
| **COMPOCOD** 🔑 | INTEGER | ✓ | Código da composição (PK, lógica → COMPO) |
| **ROTCODIGO** 🔑 | SMALLINT | ✓ | Código da rotina (PK, lógica → ROTEIRO) |
| **ALXCODIGO** 🔑 | SMALLINT | ✓ | Código do almoxarifado/célula (PK, lógica → ALMOX) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK, lógica → EMPRESA) |

**Primary Key:** (PROCODIGO, COMPOCOD, ROTCODIGO, ALXCODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **PROCODIGO**: Produto relacionado à composição e rotina.
- **COMPOCOD**: Código da composição relacionada ao produto.
- **ROTCODIGO**: Rotina de produção a ser utilizada para esta composição.
- **ALXCODIGO**: Almoxarifado/célula onde esta configuração é válida.
- **EMPCODIGO**: Empresa para a qual esta configuração é válida.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOPROROTALX Referencia (0 FKs Formais):

**Nenhuma foreign key formal** está definida na tabela COMPOPROROTALX. No entanto, há relacionamentos lógicos importantes:

#### 1. PRODU - Produtos (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROTALX.PROCODIGO → PRODU.PROCODIGO (N:1)
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
COMPOPROROTALX.COMPOCOD → COMPO.CMPCODIGO (N:1)
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
COMPOPROROTALX.ROTCODIGO → ROTEIRO.ROTCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma rotina específica.

**Uso:** Identificar a rotina de produção da configuração, obter informações da rotina.

---

#### 4. ALMOX - Almoxarifados/Células (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROTALX.ALXCODIGO → ALMOX.ALXCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a um almoxarifado/célula específico.

**Informações da Tabela ALMOX:**
- **Total:** 128 células
- **PK:** (ALXCODIGO, EMPCODIGO)

**Uso:** Identificar a célula da configuração, obter informações da célula.

---

#### 5. EMPRESA - Empresas (Lógico)
**Relacionamento Lógico:**
```
COMPOPROROTALX.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a uma empresa específica.

**Uso:** Identificar a empresa da configuração, obter informações da empresa.

---

### COMPOPROROTALX é Referenciada Por

**Nenhuma tabela** referencia COMPOPROROTALX diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PROCODIGO → PRODU → PDCAO (Ordens de Produção)

**Fluxo:** COMPOPROROTALX → PRODU → PDCAO

**Descrição:** Através do produto, é possível identificar ordens de produção relacionadas.

**Uso:** Análise de produção usando rotinas configuradas por célula.

---

### Via ALXCODIGO → ALMOX → Células de Produção

**Fluxo:** COMPOPROROTALX → ALMOX → Células

**Descrição:** Através da célula, é possível identificar processos de produção relacionados.

**Uso:** Análise de processos por célula.

---

### Via COMPOCOD → COMPO → PRODU (Componentes)

**Fluxo:** COMPOPROROTALX → COMPO → PRODU

**Descrição:** Através da composição, é possível identificar componentes relacionados.

**Uso:** Análise de componentes com rotinas configuradas por célula.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração de Rotina por Célula

**Objetivo:** Obter visão completa de uma configuração de rotina incluindo informações do produto, composição, rotina, célula e empresa.

**Fluxo:**
```
COMPOPROROTALX (PROCODIGO, COMPOCOD, ROTCODIGO, ALXCODIGO, EMPCODIGO)
  ↓
PRODU (PROCODIGO)
  ↓
COMPO (PROCODIGO, CMPCODIGO)
  ↓
ROTEIRO (ROTCODIGO)
  ↓
ALMOX (ALXCODIGO, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cprx.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cprx.COMPOCOD,
    co.CMPQTDADE AS QUANTIDADE_COMPOSICAO,
    cprx.ROTCODIGO,
    rot.ROTDESCRICAO AS ROTINA,
    cprx.ALXCODIGO,
    alx.ALXDESCRICAO AS CELULA,
    cprx.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA
FROM COMPOPROROTALX cprx
LEFT JOIN PRODU pr ON pr.PROCODIGO = cprx.PROCODIGO
LEFT JOIN COMPO co ON co.PROCODIGO = cprx.PROCODIGO
  AND co.CMPCODIGO = cprx.COMPOCOD
LEFT JOIN ROTEIRO rot ON rot.ROTCODIGO = cprx.ROTCODIGO
LEFT JOIN ALMOX alx ON alx.ALXCODIGO = cprx.ALXCODIGO
  AND alx.EMPCODIGO = cprx.EMPCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cprx.EMPCODIGO
WHERE cprx.PROCODIGO = ?
  AND cprx.EMPCODIGO = ?
ORDER BY cprx.ALXCODIGO, cprx.COMPOCOD, cprx.ROTCODIGO;
```

---

### Exemplo 2: Análise de Rotinas por Célula e Empresa

**Objetivo:** Obter rotinas configuradas agrupadas por célula e empresa.

**Query SQL:**
```sql
SELECT
    cprx.ALXCODIGO,
    alx.ALXDESCRICAO AS CELULA,
    cprx.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cprx.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT cprx.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT cprx.ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROTALX cprx
LEFT JOIN ALMOX alx ON alx.ALXCODIGO = cprx.ALXCODIGO
  AND alx.EMPCODIGO = cprx.EMPCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cprx.EMPCODIGO
GROUP BY cprx.ALXCODIGO, alx.ALXDESCRICAO, cprx.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### Exemplo 3: Análise de Rotinas Mais Utilizadas por Célula

**Objetivo:** Identificar rotinas mais utilizadas em cada célula.

**Query SQL:**
```sql
SELECT
    cprx.ALXCODIGO,
    alx.ALXDESCRICAO AS CELULA,
    cprx.ROTCODIGO,
    rot.ROTDESCRICAO AS ROTINA,
    COUNT(DISTINCT cprx.PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT cprx.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROTALX cprx
LEFT JOIN ALMOX alx ON alx.ALXCODIGO = cprx.ALXCODIGO
LEFT JOIN ROTEIRO rot ON rot.ROTCODIGO = cprx.ROTCODIGO
GROUP BY cprx.ALXCODIGO, alx.ALXDESCRICAO, cprx.ROTCODIGO, rot.ROTDESCRICAO
ORDER BY cprx.ALXCODIGO, TOTAL_CONFIGURACOES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Rotina por Célula

**Objetivo:** Obter configuração de rotina para um produto, composição, célula e empresa específicos.

```sql
SELECT
    PROCODIGO,
    COMPOCOD,
    ROTCODIGO,
    ALXCODIGO,
    EMPCODIGO
FROM COMPOPROROTALX
WHERE PROCODIGO = ?
  AND COMPOCOD = ?
  AND ALXCODIGO = ?
  AND EMPCODIGO = ?;
```

---

### 2. Listar Rotinas de um Produto por Célula

**Objetivo:** Obter todas as rotinas configuradas para um produto específico agrupadas por célula.

```sql
SELECT
    ALXCODIGO,
    COMPOCOD,
    ROTCODIGO,
    EMPCODIGO
FROM COMPOPROROTALX
WHERE PROCODIGO = ?
ORDER BY EMPCODIGO, ALXCODIGO, COMPOCOD, ROTCODIGO;
```

---

### 3. Análise de Configurações por Célula

**Objetivo:** Obter todas as configurações de rotinas de uma célula específica.

```sql
SELECT
    PROCODIGO,
    COMPOCOD,
    ROTCODIGO,
    EMPCODIGO
FROM COMPOPROROTALX
WHERE ALXCODIGO = ?
ORDER BY PROCODIGO, COMPOCOD, ROTCODIGO;
```

---

### 4. Análise de Produtos com Mais Rotinas por Célula

**Objetivo:** Identificar produtos com mais rotinas configuradas por célula.

```sql
SELECT
    PROCODIGO,
    ALXCODIGO,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROTALX
GROUP BY PROCODIGO, ALXCODIGO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 5. Análise de Células Mais Configuradas

**Objetivo:** Identificar células com mais configurações de rotinas.

**Query SQL:**
```sql
SELECT
    ALXCODIGO,
    alx.ALXDESCRICAO AS CELULA,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROTALX cprx
LEFT JOIN ALMOX alx ON alx.ALXCODIGO = cprx.ALXCODIGO
GROUP BY ALXCODIGO, alx.ALXDESCRICAO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 6. Análise de Rotinas por Produto, Célula e Empresa

**Objetivo:** Obter rotinas configuradas agrupadas por produto, célula e empresa.

**Query SQL:**
```sql
SELECT
    cprx.PROCODIGO,
    pr.PRODESCRICAO AS PRODUTO,
    cprx.ALXCODIGO,
    alx.ALXDESCRICAO AS CELULA,
    cprx.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(DISTINCT cprx.ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT cprx.COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM COMPOPROROTALX cprx
LEFT JOIN PRODU pr ON pr.PROCODIGO = cprx.PROCODIGO
LEFT JOIN ALMOX alx ON alx.ALXCODIGO = cprx.ALXCODIGO
  AND alx.EMPCODIGO = cprx.EMPCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cprx.EMPCODIGO
GROUP BY cprx.PROCODIGO, pr.PRODESCRICAO, cprx.ALXCODIGO, alx.ALXDESCRICAO, cprx.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY cprx.PROCODIGO, cprx.ALXCODIGO, cprx.EMPCODIGO;
```

---

### 7. Relatório de Configurações de Rotinas por Célula

**Objetivo:** Analisar distribuição completa de configurações de rotinas por célula.

**Query SQL:**
```sql
SELECT
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT COMPOCOD) AS TOTAL_COMPOSICOES,
    COUNT(DISTINCT ROTCODIGO) AS TOTAL_ROTINAS,
    COUNT(DISTINCT ALXCODIGO) AS TOTAL_CELULAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(configs_por_celula.TOTAL) AS MEDIA_CONFIGURACOES_POR_CELULA
FROM COMPOPROROTALX
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM COMPOPROROTALX
    GROUP BY ALXCODIGO, EMPCODIGO
) configs_por_celula;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOPROROTALX | Tipo |
|--------|-----------|---------------------|------|
| **COMPOPROROTALX** | 304.442 | 1:1 | **TABELA PRINCIPAL** |
| COMPOPROROT | 287.936 | 0.95:1 | Configurações sem célula (95% têm especificação de célula) |
| PRODU | 178.187 | 0.59:1 | Produtos (média de 1.71 configurações por produto) |
| COMPO | 108.055 | 0.35:1 | Composições (média de 2.82 configurações por composição) |
| ALMOX | 128 | ~2.378:1 | Células (média de 2.378 configurações por célula) |

**Interpretação:**
- **304.442 configurações** cadastradas no sistema
- **95% das configurações** incluem especificação de célula (304.442 vs 287.936 de COMPOPROROT)
- **Média de 1.71 configurações por produto** - produtos têm múltiplas configurações por célula
- **Média de 2.82 configurações por composição** - composições têm múltiplas rotinas por célula
- **Uso extensivo** - indica configuração detalhada de rotinas de produção por célula

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela COMPOPROROTALX.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por produto** - Para buscas por produto
3. **Índice por célula** - Para buscas por célula
4. **Índice por empresa** - Para buscas por empresa
5. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto (consultas frequentes)
CREATE INDEX IDX_COMPOPROROTALX_PRODUTO ON COMPOPROROTALX(PROCODIGO);

-- Índice 2: Busca por célula (consultas frequentes)
CREATE INDEX IDX_COMPOPROROTALX_CELULA ON COMPOPROROTALX(ALXCODIGO);

-- Índice 3: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_COMPOPROROTALX_EMPRESA ON COMPOPROROTALX(EMPCODIGO);

-- Índice 4: Busca composta por produto e célula (consultas frequentes)
CREATE INDEX IDX_COMPOPROROTALX_PRO_CEL ON COMPOPROROTALX(PROCODIGO, ALXCODIGO);

-- Índice 5: Busca composta por célula e empresa (consultas frequentes)
CREATE INDEX IDX_COMPOPROROTALX_CEL_EMP ON COMPOPROROTALX(ALXCODIGO, EMPCODIGO);
```

### Observações sobre Volume

- **Tabela média-grande** (304.442 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Configurações são consultadas durante criação de ordens de produção
- **Índices essenciais** - Em PROCODIGO, ALXCODIGO, EMPCODIGO e combinações para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Lógica

```sql
-- Verificar produtos inexistentes
SELECT DISTINCT cprx.PROCODIGO
FROM COMPOPROROTALX cprx
WHERE NOT EXISTS (SELECT 1 FROM PRODU pr WHERE pr.PROCODIGO = cprx.PROCODIGO);

-- Verificar composições inexistentes
SELECT DISTINCT cprx.COMPOCOD
FROM COMPOPROROTALX cprx
WHERE NOT EXISTS (
    SELECT 1 FROM COMPO co 
    WHERE co.PROCODIGO = cprx.PROCODIGO 
      AND co.CMPCODIGO = cprx.COMPOCOD
);

-- Verificar rotinas inexistentes
SELECT DISTINCT cprx.ROTCODIGO
FROM COMPOPROROTALX cprx
WHERE NOT EXISTS (SELECT 1 FROM ROTEIRO rot WHERE rot.ROTCODIGO = cprx.ROTCODIGO);

-- Verificar células inexistentes
SELECT DISTINCT cprx.ALXCODIGO, cprx.EMPCODIGO
FROM COMPOPROROTALX cprx
WHERE NOT EXISTS (
    SELECT 1 FROM ALMOX alx 
    WHERE alx.ALXCODIGO = cprx.ALXCODIGO
      AND alx.EMPCODIGO = cprx.EMPCODIGO
);

-- Verificar empresas inexistentes
SELECT DISTINCT cprx.EMPCODIGO
FROM COMPOPROROTALX cprx
WHERE NOT EXISTS (SELECT 1 FROM EMPRESA emp WHERE emp.EMPCODIGO = cprx.EMPCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOPROROTALX
WHERE PROCODIGO IS NULL
   OR PROCODIGO = ''
   OR COMPOCOD IS NULL
   OR ROTCODIGO IS NULL
   OR ALXCODIGO IS NULL
   OR EMPCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT PROCODIGO, COMPOCOD, ROTCODIGO, ALXCODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM COMPOPROROTALX
GROUP BY PROCODIGO, COMPOCOD, ROTCODIGO, ALXCODIGO, EMPCODIGO
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

final class FirebirdCompoprorotalx extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOPROROTALX';
    
    protected $primaryKey = ['PROCODIGO', 'COMPOCOD', 'ROTCODIGO', 'ALXCODIGO', 'EMPCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'PROCODIGO' => 'string',
        'COMPOCOD' => 'integer',
        'ROTCODIGO' => 'integer',
        'ALXCODIGO' => 'integer',
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

    // Relacionamento lógico com ALMOX
    public function celula(): BelongsTo
    {
        return $this->belongsTo(FirebirdAlmox::class, ['ALXCODIGO', 'EMPCODIGO'], ['ALXCODIGO', 'EMPCODIGO']);
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

    // Scope para filtrar por célula
    public function scopePorCelula($query, int $celulaCodigo)
    {
        return $query->where('ALXCODIGO', $celulaCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Método estático para buscar rotina de uma configuração por célula
    public static function buscarRotinaPorCelula(string $produtoCodigo, int $composicaoCodigo, int $celulaCodigo, int $empresaCodigo): ?self
    {
        return self::where('PROCODIGO', $produtoCodigo)
            ->where('COMPOCOD', $composicaoCodigo)
            ->where('ALXCODIGO', $celulaCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 5 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se entidades relacionadas existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de códigos** - Verificar que códigos são válidos

### Performance

1. **Tabela média-grande** - 304.442 registros, performance boa com índices adequados
2. **Índices essenciais** - Em PROCODIGO, ALXCODIGO, EMPCODIGO e combinações para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (produto + célula, célula + empresa)
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

