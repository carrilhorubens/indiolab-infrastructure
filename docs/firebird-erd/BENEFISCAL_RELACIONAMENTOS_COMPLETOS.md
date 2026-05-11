# BENEFISCAL - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: BENEFISCAL (Benefícios Fiscais)
- **Total de Registros**: 15
- **Total de Colunas**: 4
- **Chave Primária**: BFCODIGO + EMPCODIGO (composta)
- **Chaves Estrangeiras**: 0 (tabela mestre)
- **Índices**: 0
- **Tabelas Dependentes**: 1 (BENEFISCALDET)
- **Banco de Dados**: Firebird

## 📝 Descrição

**BENEFISCAL** é a tabela mestre de configuração de benefícios fiscais por empresa. Com apenas **15 registros**, armazena configurações de ajustes fiscais específicos para cada empresa/filial do sistema.

Esta tabela funciona como **catálogo de benefícios fiscais** e permite:
- Configurar diferentes tipos de benefícios fiscais por empresa
- Associar códigos de ajuste fiscal específicos
- Manter descrições detalhadas de cada benefício
- Vincular regras detalhadas através de BENEFISCALDET

Cada registro representa um benefício fiscal específico para uma empresa, contendo:
- Código do benefício (BFCODIGO)
- Empresa relacionada (EMPCODIGO)
- Código de ajuste fiscal (BFCODIGOAJUSTE)
- Descrição do benefício (BFDESCRICAO)

O sistema utiliza esta tabela para aplicar regras fiscais específicas, especialmente relacionadas a ICMS, CST e códigos fiscais (FISCODIGO) através da tabela de detalhes BENEFISCALDET.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BFCODIGO** 🔑 | INTEGER | Código único do benefício fiscal (PK) |
| **EMPCODIGO** 🔑 | INTEGER | Código da empresa/filial (PK) |

### Informações do Benefício
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BFCODIGOAJUSTE** | VARCHAR(37) | Código de ajuste fiscal relacionado ao benefício |
| **BFDESCRICAO** | VARCHAR(37) | Descrição detalhada do benefício fiscal |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

BENEFISCAL possui apenas **1 tabela dependente**:

### BENEFISCALDET - Detalhes dos Benefícios Fiscais
**Volume:** 51 registros

**Relacionamento:**
```
BENEFISCALDET.BFCODIGO + BENEFISCALDET.EMPCODIGO → BENEFISCAL.BFCODIGO + BENEFISCAL.EMPCODIGO (N:1) [FK: FK_BENEFISCAL]
```

**Descrição:** Cada benefício fiscal possui múltiplas regras detalhadas que definem condições específicas de aplicação. BENEFISCALDET armazena as condições detalhadas de cada benefício.

**Campos importantes em BENEFISCALDET:**
- `BFSEQ` - Sequência da regra (PK composta)
- `BFTABICMS` - Tabela de ICMS aplicável
- `BFCST` - Código de Situação Tributária (CST)
- `FISCODIGO` - Código fiscal relacionado (opcional)

**Proporção:** ~3.4 regras detalhadas por benefício em média

**Índice em BENEFISCALDET:**
- `BENEFISCALDET_IDX1` em (BFTABICMS, BFCST, FISCODIGO) - Otimiza buscas por condições fiscais

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via BENEFISCALDET

#### BENEFISCALDET → TBFIS (Lógico)
**Fluxo:** BENEFISCAL → BENEFISCALDET → TBFIS (via FISCODIGO)

**Descrição:** Embora não exista FK direta, BENEFISCALDET possui campo FISCODIGO que pode referenciar TBFIS logicamente. Isso permite vincular benefícios fiscais a códigos fiscais específicos.

**Campos de junção:**
- `BENEFISCALDET.FISCODIGO` → `TBFIS.FISCODIGO` (junção lógica)

**Uso:** Identificar quais códigos fiscais estão associados a cada benefício fiscal.

---

### Via EMPCODIGO

#### BENEFISCAL → EMPRESA (Lógico)
**Fluxo:** BENEFISCAL → EMPRESA

**Descrição:** Embora não exista FK direta, EMPCODIGO referencia logicamente EMPRESA, permitindo identificar a empresa relacionada a cada benefício.

**Campos de junção:**
- `BENEFISCAL.EMPCODIGO` → `EMPRESA.EMPCODIGO` (junção lógica)

**Uso:** Listar benefícios fiscais por empresa com informações cadastrais completas.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Benefícios Fiscais

**Objetivo:** Obter visão completa de um benefício fiscal incluindo todas as regras detalhadas e códigos fiscais relacionados.

**Fluxo:**
```
BENEFISCAL (BFCODIGO, EMPCODIGO)
  ↓
BENEFISCALDET (BFCODIGO, EMPCODIGO, BFSEQ)
  ↓
TBFIS (FISCODIGO) [lógico]
  ↓
EMPRESA (EMPCODIGO) [lógico]
```

**Query SQL:**
```sql
SELECT
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO,
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.FISCODIGO,
    fis.FISDESCRICAO AS DESCRICAO_FISCAL,
    fis.FISICMS AS ALIQUOTA_ICMS,
    fis.FISTPNATOP AS NATUREZA_OPERACAO
FROM BENEFISCAL bf
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN TBFIS fis ON fis.FISCODIGO = det.FISCODIGO
WHERE bf.BFCODIGO = ?
  AND bf.EMPCODIGO = ?
ORDER BY det.BFSEQ;
```

---

### Exemplo 2: Benefícios Fiscais por Empresa com Estatísticas

**Objetivo:** Listar todos os benefícios fiscais de uma empresa com contagem de regras e códigos fiscais relacionados.

**Fluxo:**
```
EMPRESA (EMPCODIGO)
  ↓
BENEFISCAL (EMPCODIGO)
  ↓
BENEFISCALDET (BFCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO,
    COUNT(DISTINCT det.BFSEQ) AS TOTAL_REGRA,
    COUNT(DISTINCT det.FISCODIGO) AS TOTAL_CODIGOS_FISCAIS,
    STRING_AGG(DISTINCT CAST(det.BFCST AS VARCHAR), ', ') AS CSTS_APLICAVEIS
FROM EMPRESA e
INNER JOIN BENEFISCAL bf ON bf.EMPCODIGO = e.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
WHERE e.EMPCODIGO = ?
GROUP BY e.EMPRAZSOCIAL, e.EMPCNPJ, bf.BFCODIGO, 
         bf.BFCODIGOAJUSTE, bf.BFDESCRICAO
ORDER BY bf.BFCODIGO;
```

---

### Exemplo 3: Buscar Benefícios por Código Fiscal

**Objetivo:** Identificar quais benefícios fiscais se aplicam a um código fiscal específico.

**Fluxo:**
```
TBFIS (FISCODIGO)
  ↓
BENEFISCALDET (FISCODIGO)
  ↓
BENEFISCAL (BFCODIGO, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    fis.FISCODIGO,
    fis.FISDESCRICAO AS CODIGO_FISCAL,
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.BFSEQ AS SEQ_REGRA
FROM TBFIS fis
INNER JOIN BENEFISCALDET det ON det.FISCODIGO = fis.FISCODIGO
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
WHERE fis.FISCODIGO = ?
ORDER BY e.EMPRAZSOCIAL, bf.BFCODIGO, det.BFSEQ;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Benefícios Fiscais por Empresa

**Objetivo:** Visualizar todos os benefícios fiscais configurados para uma empresa específica.

```sql
SELECT
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO,
    COUNT(det.BFSEQ) AS TOTAL_REGRA
FROM BENEFISCAL bf
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
WHERE bf.EMPCODIGO = ?
GROUP BY bf.BFCODIGO, bf.BFCODIGOAJUSTE, bf.BFDESCRICAO
ORDER BY bf.BFCODIGO;
```

---

### 2. Buscar Benefício por Código de Ajuste

**Objetivo:** Localizar um benefício fiscal específico pelo código de ajuste.

```sql
SELECT
    bf.*,
    e.EMPRAZSOCIAL AS EMPRESA,
    COUNT(det.BFSEQ) AS TOTAL_REGRA
FROM BENEFISCAL bf
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
WHERE bf.BFCODIGOAJUSTE = ?
GROUP BY bf.BFCODIGO, bf.EMPCODIGO, bf.BFCODIGOAJUSTE, 
         bf.BFDESCRICAO, e.EMPRAZSOCIAL;
```

---

### 3. Detalhamento Completo de Benefício Fiscal

**Objetivo:** Obter todas as regras detalhadas de um benefício fiscal específico.

```sql
SELECT
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.FISCODIGO,
    fis.FISDESCRICAO AS CODIGO_FISCAL,
    fis.FISICMS AS ALIQUOTA_ICMS
FROM BENEFISCAL bf
INNER JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN TBFIS fis ON fis.FISCODIGO = det.FISCODIGO
WHERE bf.BFCODIGO = ?
  AND bf.EMPCODIGO = ?
ORDER BY det.BFSEQ;
```

---

### 4. Análise de Benefícios por CST

**Objetivo:** Identificar quais benefícios fiscais utilizam um CST específico.

```sql
SELECT
    det.BFCST AS CST,
    COUNT(DISTINCT bf.BFCODIGO) AS TOTAL_BENEFICIOS,
    COUNT(DISTINCT bf.EMPCODIGO) AS TOTAL_EMPRESAS,
    STRING_AGG(DISTINCT bf.BFDESCRICAO, '; ') AS BENEFICIOS
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
WHERE det.BFCST = ?
GROUP BY det.BFCST;
```

---

### 5. Relatório de Benefícios por Empresa

**Objetivo:** Gerar relatório consolidado de benefícios fiscais por empresa.

```sql
SELECT
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    COUNT(DISTINCT bf.BFCODIGO) AS TOTAL_BENEFICIOS,
    COUNT(det.BFSEQ) AS TOTAL_REGRA,
    COUNT(DISTINCT det.FISCODIGO) AS TOTAL_CODIGOS_FISCAIS,
    COUNT(DISTINCT det.BFCST) AS TOTAL_CSTS_DIFERENTES
FROM EMPRESA e
LEFT JOIN BENEFISCAL bf ON bf.EMPCODIGO = e.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
GROUP BY e.EMPRAZSOCIAL, e.EMPCNPJ
HAVING COUNT(DISTINCT bf.BFCODIGO) > 0
ORDER BY TOTAL_BENEFICIOS DESC;
```

---

### 6. Verificar Benefícios sem Regras Detalhadas

**Objetivo:** Identificar benefícios fiscais que não possuem regras detalhadas configuradas.

```sql
SELECT
    bf.*,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BENEFISCAL bf
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
WHERE det.BFCODIGO IS NULL;
```

---

### 7. Buscar Benefícios por Tabela de ICMS

**Objetivo:** Listar benefícios fiscais que utilizam uma tabela de ICMS específica.

```sql
SELECT
    det.BFTABICMS AS TAB_ICMS,
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT det.BFCST) AS TOTAL_CSTS,
    STRING_AGG(DISTINCT det.BFCST, ', ') AS CSTS
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
WHERE det.BFTABICMS = ?
GROUP BY det.BFTABICMS, bf.BFCODIGO, bf.BFCODIGOAJUSTE, 
         bf.BFDESCRICAO, e.EMPRAZSOCIAL
ORDER BY bf.BFCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com BENEFISCAL | Tipo |
|--------|-----------|--------------------------|------|
| **BENEFISCAL** | 15 | 1:1 | **TABELA PRINCIPAL** |
| BENEFISCALDET | 51 | 3.4:1 | Regras detalhadas por benefício |
| EMPRESA | 6 | 2.5:1 | Empresas no sistema |

**Interpretação:**
- Cada benefício fiscal possui em média **3.4 regras detalhadas** (BENEFISCALDET)
- Cada empresa possui em média **2.5 benefícios fiscais** configurados
- Tabela pequena mas crítica para configuração fiscal

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **BFCODIGO + EMPCODIGO** | BENEFISCAL | Chave primária composta |
| **BFCODIGO + EMPCODIGO** | BENEFISCALDET → BENEFISCAL | Referência ao benefício |
| **BFSEQ** | BENEFISCALDET | Sequência da regra (PK composta) |
| **FISCODIGO** | BENEFISCALDET → TBFIS | Código fiscal relacionado (lógico) |
| **EMPCODIGO** | BENEFISCAL → EMPRESA | Empresa relacionada (lógico) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela BENEFISCAL.

### Recomendações de Performance

1. **Índice na chave primária composta** - Já existe implicitamente (PK)
2. **Índice em BFCODIGOAJUSTE** - Para buscas por código de ajuste
3. **Índice em EMPCODIGO** - Para filtros por empresa
4. **Índice composto empresa + código** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por código de ajuste (consultas frequentes)
CREATE INDEX IDX_BENEFISCAL_AJUSTE ON BENEFISCAL(BFCODIGOAJUSTE);

-- Índice 2: Busca por empresa (relatórios por empresa)
CREATE INDEX IDX_BENEFISCAL_EMPRESA ON BENEFISCAL(EMPCODIGO);

-- Índice 3: Busca combinada empresa + código
CREATE INDEX IDX_BENEFISCAL_EMP_COD ON BENEFISCAL(EMPCODIGO, BFCODIGO);
```

### Observações sobre Volume

- **Tabela muito pequena** (15 registros) - Performance geralmente não é crítica
- **Consultas com JOINs** são rápidas devido ao volume reduzido
- **BENEFISCALDET** tem volume maior (51 registros) mas ainda pequeno
- **Focar em clareza e manutenibilidade** ao invés de otimização extrema

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usa índice implícito da PK)
SELECT BFCODIGO, BFCODIGOAJUSTE, BFDESCRICAO
FROM BENEFISCAL
WHERE BFCODIGO = ?
  AND EMPCODIGO = ?;

-- ✅ OTIMIZADO (filtro por empresa primeiro)
SELECT BFCODIGO, BFCODIGOAJUSTE, BFDESCRICAO
FROM BENEFISCAL
WHERE EMPCODIGO = ?
ORDER BY BFCODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar benefícios sem empresa válida (lógica)
SELECT bf.*
FROM BENEFISCAL bf
LEFT JOIN EMPRESA e ON e.EMPCODIGO = bf.EMPCODIGO
WHERE e.EMPCODIGO IS NULL;

-- Verificar regras detalhadas sem benefício válido
SELECT det.*
FROM BENEFISCALDET det
LEFT JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                        AND bf.EMPCODIGO = det.EMPCODIGO
WHERE bf.BFCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar benefícios sem regras detalhadas
SELECT bf.*
FROM BENEFISCAL bf
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
WHERE det.BFCODIGO IS NULL;

-- Verificar códigos fiscais inválidos em BENEFISCALDET
SELECT det.*
FROM BENEFISCALDET det
WHERE det.FISCODIGO IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM TBFIS fis 
      WHERE fis.FISCODIGO = det.FISCODIGO
  );

-- Verificar duplicatas de sequência por benefício
SELECT BFCODIGO, EMPCODIGO, BFSEQ, COUNT(*) AS QTD
FROM BENEFISCALDET
GROUP BY BFCODIGO, EMPCODIGO, BFSEQ
HAVING COUNT(*) > 1;
```

### Verificar Valores Obrigatórios

```sql
-- Verificar campos obrigatórios nulos
SELECT *
FROM BENEFISCAL
WHERE BFCODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR BFCODIGOAJUSTE IS NULL
   OR BFDESCRICAO IS NULL;
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
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdBenefiscal extends Model
{
    protected $connection = 'firebird';
    protected $table = 'BENEFISCAL';
    protected $primaryKey = ['BFCODIGO', 'EMPCODIGO'];

    public $incrementing = false;

    protected $casts = [
        'BFCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'BFCODIGOAJUSTE' => 'string',
        'BFDESCRICAO' => 'string',
    ];

    // Relacionamento com EMPRESA (lógico)
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com BENEFISCALDET (regras detalhadas)
    public function detalhes(): HasMany
    {
        return $this->hasMany(
            FirebirdBenefiscalDet::class,
            ['BFCODIGO', 'EMPCODIGO'],
            ['BFCODIGO', 'EMPCODIGO']
        );
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para buscar por código de ajuste
    public function scopePorCodigoAjuste($query, string $codigoAjuste)
    {
        return $query->where('BFCODIGOAJUSTE', $codigoAjuste);
    }

    // Método para verificar se possui regras detalhadas
    public function possuiRegrasDetalhadas(): bool
    {
        return $this->detalhes()->count() > 0;
    }

    // Método para obter total de regras
    public function totalRegras(): int
    {
        return $this->detalhes()->count();
    }

    // Método para obter CSTs únicos
    public function cstsUnicos(): array
    {
        return $this->detalhes()
            ->whereNotNull('BFCST')
            ->distinct()
            ->pluck('BFCST')
            ->toArray();
    }

    // Método para obter códigos fiscais relacionados
    public function codigosFiscais(): array
    {
        return $this->detalhes()
            ->whereNotNull('FISCODIGO')
            ->distinct()
            ->pluck('FISCODIGO')
            ->toArray();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Validação de chave composta** - Sempre validar que BFCODIGO + EMPCODIGO são únicos
2. **Código de ajuste único** - Considerar tornar BFCODIGOAJUSTE único por empresa
3. **Descrição clara** - BFDESCRICAO deve ser descritiva e clara
4. **Relacionamento com detalhes** - Sempre criar pelo menos uma regra em BENEFISCALDET

### Performance

1. **Tabela pequena** - Performance não é crítica, focar em clareza
2. **Usar índices** - Para campos de busca frequente (BFCODIGOAJUSTE, EMPCODIGO)
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Cache quando apropriado** - Benefícios fiscais mudam raramente

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se empresa existe
2. **Verificar duplicatas** - Antes de inserir novo benefício
3. **Manter consistência** - Garantir que BENEFISCALDET referencia benefícios válidos
4. **Validação de códigos fiscais** - Verificar se FISCODIGO existe em TBFIS quando preenchido

### Manutenção

1. **Documentação clara** - Manter BFDESCRICAO atualizada e descritiva
2. **Revisão periódica** - Verificar benefícios não utilizados
3. **Backup regular** - Tabela pequena mas crítica para configuração fiscal
4. **Auditoria** - Registrar alterações em benefícios fiscais

### Regras de Negócio

1. **Benefícios por empresa** - Cada empresa pode ter seus próprios benefícios
2. **Regras detalhadas obrigatórias** - Todo benefício deve ter pelo menos uma regra em BENEFISCALDET
3. **CST e Tabela ICMS** - Devem ser consistentes com legislação fiscal
4. **Código de ajuste** - Deve seguir padrões fiscais estabelecidos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

