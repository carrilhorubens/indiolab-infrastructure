# DCTICMS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DCTICMS (Desconto de ICMS)
- **Total de Registros**: 4
- **Total de Colunas**: 3
- **Chave Primária**: DCTCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (DCTIPERC)
- **Banco de Dados**: Firebird

## 📝 Descrição

**DCTICMS** é uma tabela mestre que armazena tipos de desconto de ICMS disponíveis no sistema. Com **4 registros**, representa um catálogo de tipos de desconto de ICMS utilizados para cálculos fiscais e tributários.

Esta tabela funciona como **catálogo de tipos de desconto de ICMS** e permite:
- Identificar tipos de desconto de ICMS disponíveis
- Armazenar descrições de cada tipo de desconto
- Manter observações sobre cada tipo de desconto
- Suportar cálculos fiscais e tributários
- Facilitar gestão de descontos de ICMS

Cada registro representa um tipo de desconto de ICMS específico, contendo:
- Código do desconto (DCTCODIGO)
- Descrição do desconto (DCTDESCRICAO)
- Observações sobre o desconto (DCTOBSER)

O sistema utiliza esta tabela como referência para tipos de desconto de ICMS, sendo utilizada principalmente por DCTIPERC para cálculos fiscais detalhados.

**Observação Importante:** DCTICMS é uma tabela mestre pequena (4 registros) que serve como catálogo de tipos de desconto de ICMS. É referenciada por DCTIPERC que armazena percentuais e configurações detalhadas de desconto por ICMS, UF e empresa.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCTCODIGO** 🔑 | INTEGER | ✓ | Código do tipo de desconto de ICMS (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCTDESCRICAO** | VARCHAR(37) | | Descrição do tipo de desconto |
| **DCTOBSER** | VARCHAR(261) | | Observações sobre o desconto |

**Primary Key:** DCTCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DCTICMS Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DCTICMS é Referenciada Por (1 tabela):

#### 1. DCTIPERC - Percentuais de Desconto de ICMS
**Relacionamento:**
```
DCTIPERC.DCTCODIGO → DCTICMS.DCTCODIGO (N:1)
Constraint: DCTICMS_DCTIPERC
```

**Descrição**: Cada percentual de desconto está vinculado a um tipo de desconto específico.

**Informações da Tabela DCTIPERC:**
- **Total:** 338 registros
- **PK:** (DCTCODIGO, ICMCODIGO, ICMUF, EMPCODIGO)
- **Colunas:** 28 campos
- **FKs:** 4 (DCTICMS, TBICMS, EMPRESA, OBSER)

**Uso:** DCTIPERC estende DCTICMS com percentuais e configurações detalhadas de desconto por ICMS, UF e empresa.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via DCTIPERC → TBICMS → Outras Tabelas Fiscais

**Fluxo:** DCTICMS → DCTIPERC → TBICMS → Tabelas Fiscais

**Descrição:** Através de DCTIPERC e TBICMS, é possível identificar outras tabelas fiscais relacionadas.

**Uso:** Análise de descontos de ICMS em contexto fiscal completo.

---

### Via DCTIPERC → EMPRESA → Outras Operações da Empresa

**Fluxo:** DCTICMS → DCTIPERC → EMPRESA → Operações

**Descrição:** Através de DCTIPERC e EMPRESA, é possível identificar outras operações relacionadas.

**Uso:** Análise de descontos de ICMS por empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Desconto de ICMS

**Objetivo:** Obter visão completa de um tipo de desconto incluindo todos os percentuais configurados.

**Fluxo:**
```
DCTICMS (DCTCODIGO)
  ↓
DCTIPERC (DCTCODIGO, ICMCODIGO, ICMUF, EMPCODIGO)
  ↓
TBICMS (ICMCODIGO, ICMUF, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    dct.DCTCODIGO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    dct.DCTOBSER AS OBSERVACOES,
    dcp.ICMCODIGO,
    dcp.ICMUF,
    uf.UFDESCRICAO AS ESTADO,
    dcp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    dcp.DCPPCICMSINSC AS PC_ICMS_INSC,
    dcp.DCPPCICMSCONS AS PC_ICMS_CONS,
    dcp.DCPPCBSICMS AS PC_BS_ICMS,
    dcp.DCPPCBSICMSSUB AS PC_BS_ICMS_SUB,
    dcp.DCPSUBSTTRIB AS SUBST_TRIB,
    dcp.DCPPCICMSSUB AS PC_ICMS_SUB
FROM DCTICMS dct
LEFT JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
LEFT JOIN TBICMS tb ON tb.ICMCODIGO = dcp.ICMCODIGO
                  AND tb.ICMUF = dcp.ICMUF
                  AND tb.EMPCODIGO = dcp.EMPCODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = dcp.ICMUF
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dcp.EMPCODIGO
WHERE dct.DCTCODIGO = ?;
```

---

### Exemplo 2: Análise de Descontos por Empresa

**Objetivo:** Identificar todos os tipos de desconto configurados para uma empresa específica.

**Query SQL:**
```sql
SELECT
    dct.DCTCODIGO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    COUNT(DISTINCT dcp.ICMCODIGO) AS TOTAL_ICMS,
    COUNT(DISTINCT dcp.ICMUF) AS TOTAL_UFS,
    COUNT(*) AS TOTAL_CONFIGURACOES
FROM DCTICMS dct
INNER JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
WHERE dcp.EMPCODIGO = ?
GROUP BY dct.DCTCODIGO, dct.DCTDESCRICAO
ORDER BY dct.DCTCODIGO;
```

---

### Exemplo 3: Análise de Descontos por UF

**Objetivo:** Identificar distribuição de descontos por estado.

**Query SQL:**
```sql
SELECT
    dcp.ICMUF,
    uf.UFDESCRICAO AS ESTADO,
    dct.DCTCODIGO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(dcp.DCPPCICMSINSC) AS MEDIA_PC_ICMS_INSC,
    AVG(dcp.DCPPCICMSCONS) AS MEDIA_PC_ICMS_CONS
FROM DCTICMS dct
INNER JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = dcp.ICMUF
GROUP BY dcp.ICMUF, uf.UFDESCRICAO, dct.DCTCODIGO, dct.DCTDESCRICAO
ORDER BY dcp.ICMUF, dct.DCTCODIGO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Tipo de Desconto

**Objetivo:** Obter informações de um tipo de desconto específico.

```sql
SELECT
    DCTCODIGO,
    DCTDESCRICAO AS DESCRICAO,
    DCTOBSER AS OBSERVACOES
FROM DCTICMS
WHERE DCTCODIGO = ?;
```

---

### 2. Listar Todos os Tipos de Desconto

**Objetivo:** Obter catálogo completo de tipos de desconto.

```sql
SELECT
    DCTCODIGO,
    DCTDESCRICAO AS DESCRICAO,
    DCTOBSER AS OBSERVACOES
FROM DCTICMS
ORDER BY DCTCODIGO;
```

---

### 3. Análise de Uso de Tipos de Desconto

**Objetivo:** Identificar quais tipos de desconto estão sendo utilizados em DCTIPERC.

**Query SQL:**
```sql
SELECT
    dct.DCTCODIGO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT dcp.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT dcp.ICMUF) AS TOTAL_UFS
FROM DCTICMS dct
LEFT JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
GROUP BY dct.DCTCODIGO, dct.DCTDESCRICAO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 4. Análise de Descontos por Empresa e UF

**Objetivo:** Identificar configurações de desconto por empresa e estado.

**Query SQL:**
```sql
SELECT
    dcp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    dcp.ICMUF,
    uf.UFDESCRICAO AS ESTADO,
    dct.DCTCODIGO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    dcp.DCPPCICMSINSC AS PC_ICMS_INSC,
    dcp.DCPPCICMSCONS AS PC_ICMS_CONS
FROM DCTICMS dct
INNER JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dcp.EMPCODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = dcp.ICMUF
WHERE dcp.EMPCODIGO = ?
ORDER BY dcp.ICMUF, dct.DCTCODIGO;
```

---

### 5. Relatório Completo de Tipos de Desconto

**Objetivo:** Analisar distribuição completa de tipos de desconto no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_TIPOS_DESCONTO,
    COUNT(CASE WHEN DCTDESCRICAO IS NOT NULL AND DCTDESCRICAO != '' THEN 1 END) AS COM_DESCRICAO,
    COUNT(CASE WHEN DCTOBSER IS NOT NULL AND DCTOBSER != '' THEN 1 END) AS COM_OBSERVACOES,
    (SELECT COUNT(*) FROM DCTIPERC) AS TOTAL_CONFIGURACOES_DETALHADAS
FROM DCTICMS;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DCTICMS | Tipo |
|--------|-----------|---------------------|------|
| **DCTICMS** | 4 | 1:1 | **TABELA PRINCIPAL** |
| DCTIPERC | 338 | 1:84.5 | Configurações detalhadas (média de ~84.5 configurações por tipo de desconto) |

**Interpretação:**
- **4 tipos de desconto** cadastrados no sistema
- **Média de ~84.5 configurações detalhadas por tipo de desconto** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Tabela pequena** - 4 registros, performance excelente mesmo sem índices adicionais
3. **Cache recomendado** - Tabela pequena e estável, ideal para cache em memória

### Observações sobre Volume

- **Tabela muito pequena** (4 registros) - Performance excelente mesmo sem índices adicionais
- **Chave primária simples** - DCTCODIGO já fornece índice eficiente
- **Consultas frequentes** - Tipos de desconto são consultados durante cálculos fiscais
- **Índices desnecessários** - Devido ao volume muito pequeno, índices adicionais não são necessários

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM DCTICMS
WHERE DCTCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT DCTCODIGO, COUNT(*) AS QTD
FROM DCTICMS
GROUP BY DCTCODIGO
HAVING COUNT(*) > 1;

-- Verificar tipos de desconto sem configurações detalhadas
SELECT dct.*
FROM DCTICMS dct
LEFT JOIN DCTIPERC dcp ON dcp.DCTCODIGO = dct.DCTCODIGO
WHERE dcp.DCTCODIGO IS NULL;
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

final class FirebirdDcticms extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DCTICMS';
    
    protected $primaryKey = 'DCTCODIGO';
    public $incrementing = true;

    protected $casts = [
        'DCTCODIGO' => 'integer',
        'DCTDESCRICAO' => 'string',
        'DCTOBSER' => 'string',
    ];

    // Relacionamento com DCTIPERC
    public function percentuais(): HasMany
    {
        return $this->hasMany(FirebirdDctiperc::class, 'DCTCODIGO', 'DCTCODIGO');
    }

    // Método estático para buscar tipo de desconto
    public static function buscarPorCodigo(int $codigo): ?self
    {
        return self::find($codigo);
    }

    // Método estático para listar todos os tipos
    public static function listarTodos(): \Illuminate\Support\Collection
    {
        return self::orderBy('DCTCODIGO')->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - DCTCODIGO identifica unicamente cada tipo de desconto
2. **Validação antes de inserir** - Verificar se código já existe
3. **Evitar duplicatas** - PK previne duplicatas
4. **Manter descrições claras** - Garantir que descrições sejam compreensíveis
5. **Observações detalhadas** - Usar DCTOBSER para informações importantes

### Performance

1. **Tabela muito pequena** - 4 registros, performance excelente mesmo sem índices adicionais
2. **Cache recomendado** - Tabela pequena e estável, ideal para cache em memória
3. **Consultas frequentes** - Tipos de desconto são consultados durante cálculos fiscais
4. **Índices desnecessários** - Devido ao volume muito pequeno, índices adicionais não são necessários

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código já existe
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que tipos de desconto sejam válidos
4. **Validação de descrições** - Garantir que descrições sejam preenchidas quando possível

### Manutenção

1. **Revisão periódica** - Verificar se novos tipos de desconto são necessários
2. **Padronização** - Manter estrutura de dados consistente
3. **Documentação** - Documentar significado de cada tipo de desconto
4. **Backup regular** - Tabela importante para cálculos fiscais
5. **Atualização conforme legislação** - Manter tipos de desconto atualizados conforme mudanças na legislação brasileira

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

