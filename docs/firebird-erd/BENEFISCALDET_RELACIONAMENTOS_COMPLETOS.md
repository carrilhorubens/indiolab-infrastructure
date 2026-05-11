# BENEFISCALDET - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: BENEFISCALDET (Detalhes dos Benefícios Fiscais)
- **Total de Registros**: 51
- **Total de Colunas**: 6
- **Chave Primária**: BFCODIGO + EMPCODIGO + BFSEQ (composta)
- **Chaves Estrangeiras**: 2 (BFCODIGO + EMPCODIGO → BENEFISCAL)
- **Índices**: 1 (BENEFISCALDET_IDX1)
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**BENEFISCALDET** é a tabela de detalhes que armazena as regras específicas de aplicação de cada benefício fiscal. Com **51 registros**, representa as condições detalhadas que determinam quando e como um benefício fiscal deve ser aplicado.

Esta tabela funciona como **regras de negócio fiscais** e permite:
- Definir condições específicas de aplicação de benefícios fiscais
- Associar tabelas de ICMS (BFTABICMS) e CSTs (BFCST) a cada regra
- Vincular códigos fiscais (FISCODIGO) opcionalmente
- Estabelecer múltiplas regras por benefício através da sequência (BFSEQ)

Cada registro representa uma regra específica de um benefício fiscal, contendo:
- Identificação do benefício (BFCODIGO + EMPCODIGO)
- Sequência da regra (BFSEQ)
- Tabela de ICMS aplicável (BFTABICMS)
- Código de Situação Tributária (BFCST)
- Código fiscal relacionado (FISCODIGO) - opcional

O sistema utiliza esta tabela para determinar quais benefícios fiscais se aplicam a operações específicas baseado em critérios como tabela de ICMS, CST e código fiscal.

---

## 🔑 Estrutura de Colunas

### Identificação e Relacionamentos
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BFCODIGO** 🔑🔗 | INTEGER | Código do benefício fiscal (PK + FK → BENEFISCAL) |
| **EMPCODIGO** 🔑🔗 | INTEGER | Código da empresa (PK + FK → BENEFISCAL) |
| **BFSEQ** 🔑 | INTEGER | Sequência da regra dentro do benefício (PK) |

### Condições Fiscais
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BFTABICMS** | INTEGER | Tabela de ICMS aplicável à regra (obrigatório) |
| **BFCST** | VARCHAR(37) | Código de Situação Tributária (CST) aplicável (obrigatório) |
| **FISCODIGO** | VARCHAR(14) | Código fiscal relacionado (opcional, lógico → TBFIS) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

BENEFISCALDET possui **2 chaves estrangeiras** que referenciam BENEFISCAL:

### BENEFISCAL - Benefício Fiscal Mestre
**Volume:** 15 registros

**Relacionamento:**
```
BENEFISCALDET.BFCODIGO + BENEFISCALDET.EMPCODIGO → BENEFISCAL.BFCODIGO + BENEFISCAL.EMPCODIGO (N:1) [FK: FK_BENEFISCAL]
```

**Descrição:** Cada regra detalhada está vinculada a um benefício fiscal específico através de chave composta. Este relacionamento é obrigatório e garante que toda regra pertence a um benefício válido.

**Campos importantes em BENEFISCAL:**
- `BFCODIGOAJUSTE` - Código de ajuste fiscal
- `BFDESCRICAO` - Descrição do benefício

**Proporção:** ~3.4 regras detalhadas por benefício em média

**Observação:** O relacionamento utiliza chave composta (BFCODIGO + EMPCODIGO), garantindo que cada regra esteja vinculada ao benefício correto da empresa correta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via BENEFISCAL

#### BENEFISCAL → EMPRESA (Lógico)
**Fluxo:** BENEFISCALDET → BENEFISCAL → EMPRESA

**Descrição:** Através do relacionamento com BENEFISCAL, é possível identificar a empresa relacionada a cada regra detalhada.

**Campos de junção:**
- `BENEFISCALDET.EMPCODIGO` → `BENEFISCAL.EMPCODIGO` → `EMPRESA.EMPCODIGO` (junção lógica)

**Uso:** Filtrar regras por empresa ou obter informações cadastrais da empresa.

---

### Via FISCODIGO

#### BENEFISCALDET → TBFIS (Lógico)
**Fluxo:** BENEFISCALDET → TBFIS (via FISCODIGO)

**Descrição:** Embora não exista FK direta, o campo FISCODIGO referencia logicamente TBFIS, permitindo vincular regras de benefício a códigos fiscais específicos.

**Campos de junção:**
- `BENEFISCALDET.FISCODIGO` → `TBFIS.FISCODIGO` (junção lógica)

**Uso:** Identificar quais códigos fiscais estão associados a regras de benefício e obter informações fiscais completas.

**Observação:** FISCODIGO é opcional, então nem todas as regras possuem código fiscal vinculado.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Regras de Benefício

**Objetivo:** Obter visão completa de uma regra detalhada incluindo informações do benefício, empresa e código fiscal relacionado.

**Fluxo:**
```
BENEFISCALDET (BFCODIGO, EMPCODIGO, BFSEQ)
  ↓
BENEFISCAL (BFCODIGO, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO) [lógico]
  ↓
TBFIS (FISCODIGO) [lógico]
```

**Query SQL:**
```sql
SELECT
    det.BFCODIGO,
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.FISCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    fis.FISDESCRICAO AS CODIGO_FISCAL,
    fis.FISICMS AS ALIQUOTA_ICMS,
    fis.FISTPNATOP AS NATUREZA_OPERACAO
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
LEFT JOIN TBFIS fis ON fis.FISCODIGO = det.FISCODIGO
WHERE det.BFCODIGO = ?
  AND det.EMPCODIGO = ?
ORDER BY det.BFSEQ;
```

---

### Exemplo 2: Regras por Código Fiscal

**Objetivo:** Identificar todas as regras de benefício que se aplicam a um código fiscal específico.

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
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM TBFIS fis
INNER JOIN BENEFISCALDET det ON det.FISCODIGO = fis.FISCODIGO
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE fis.FISCODIGO = ?
ORDER BY e.EMPRAZSOCIAL, bf.BFCODIGO, det.BFSEQ;
```

---

### Exemplo 3: Análise de Regras por CST e Tabela ICMS

**Objetivo:** Listar todas as regras que utilizam uma combinação específica de CST e tabela de ICMS.

**Fluxo:**
```
BENEFISCALDET (BFCST, BFTABICMS)
  ↓
BENEFISCAL (BFCODIGO, EMPCODIGO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    det.BFCST AS CST,
    det.BFTABICMS AS TAB_ICMS,
    COUNT(DISTINCT det.BFCODIGO) AS TOTAL_BENEFICIOS,
    COUNT(DISTINCT det.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_REGRA,
    STRING_AGG(DISTINCT bf.BFDESCRICAO, '; ') AS BENEFICIOS,
    STRING_AGG(DISTINCT e.EMPRAZSOCIAL, '; ') AS EMPRESAS
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.BFCST = ?
  AND det.BFTABICMS = ?
GROUP BY det.BFCST, det.BFTABICMS;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Todas as Regras de um Benefício Fiscal

**Objetivo:** Visualizar todas as regras detalhadas de um benefício fiscal específico.

```sql
SELECT
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.FISCODIGO,
    fis.FISDESCRICAO AS CODIGO_FISCAL
FROM BENEFISCALDET det
LEFT JOIN TBFIS fis ON fis.FISCODIGO = det.FISCODIGO
WHERE det.BFCODIGO = ?
  AND det.EMPCODIGO = ?
ORDER BY det.BFSEQ;
```

---

### 2. Buscar Regra Específica por Sequência

**Objetivo:** Obter uma regra específica de um benefício através de sua sequência.

```sql
SELECT
    det.*,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.BFCODIGO = ?
  AND det.EMPCODIGO = ?
  AND det.BFSEQ = ?;
```

---

### 3. Verificar Regras por CST

**Objetivo:** Identificar quais benefícios fiscais utilizam um CST específico.

```sql
SELECT
    det.BFCST AS CST,
    bf.BFCODIGO,
    bf.BFCODIGOAJUSTE,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    COUNT(*) AS TOTAL_REGRA,
    STRING_AGG(CAST(det.BFSEQ AS VARCHAR), ', ') AS SEQUENCIAS
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.BFCST = ?
GROUP BY det.BFCST, bf.BFCODIGO, bf.BFCODIGOAJUSTE, 
         bf.BFDESCRICAO, e.EMPRAZSOCIAL
ORDER BY bf.BFCODIGO;
```

---

### 4. Análise de Regras por Tabela de ICMS

**Objetivo:** Listar todas as regras que utilizam uma tabela de ICMS específica.

```sql
SELECT
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    bf.BFCODIGO,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT det.FISCODIGO) AS TOTAL_CODIGOS_FISCAIS
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.BFTABICMS = ?
GROUP BY det.BFTABICMS, det.BFCST, bf.BFCODIGO, 
         bf.BFDESCRICAO, e.EMPRAZSOCIAL
ORDER BY det.BFCST, bf.BFCODIGO;
```

---

### 5. Regras com Código Fiscal Vinculado

**Objetivo:** Identificar regras que possuem código fiscal associado.

```sql
SELECT
    det.BFCODIGO,
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    det.FISCODIGO,
    fis.FISDESCRICAO AS CODIGO_FISCAL,
    fis.FISICMS AS ALIQUOTA_ICMS,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
INNER JOIN TBFIS fis ON fis.FISCODIGO = det.FISCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.FISCODIGO IS NOT NULL
ORDER BY e.EMPRAZSOCIAL, bf.BFCODIGO, det.BFSEQ;
```

---

### 6. Regras sem Código Fiscal

**Objetivo:** Identificar regras que não possuem código fiscal vinculado.

```sql
SELECT
    det.BFCODIGO,
    det.BFSEQ AS SEQ_REGRA,
    det.BFTABICMS AS TAB_ICMS,
    det.BFCST AS CST,
    bf.BFDESCRICAO AS BENEFICIO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM BENEFISCALDET det
INNER JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                         AND bf.EMPCODIGO = det.EMPCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = det.EMPCODIGO
WHERE det.FISCODIGO IS NULL
ORDER BY e.EMPRAZSOCIAL, bf.BFCODIGO, det.BFSEQ;
```

---

### 7. Relatório Consolidado de Regras por Empresa

**Objetivo:** Gerar relatório consolidado de todas as regras de benefício por empresa.

```sql
SELECT
    e.EMPRAZSOCIAL AS EMPRESA,
    e.EMPCNPJ AS CNPJ,
    COUNT(DISTINCT bf.BFCODIGO) AS TOTAL_BENEFICIOS,
    COUNT(det.BFSEQ) AS TOTAL_REGRA,
    COUNT(DISTINCT det.BFTABICMS) AS TOTAL_TABELAS_ICMS,
    COUNT(DISTINCT det.BFCST) AS TOTAL_CSTS,
    COUNT(DISTINCT det.FISCODIGO) AS TOTAL_CODIGOS_FISCAIS,
    COUNT(CASE WHEN det.FISCODIGO IS NULL THEN 1 END) AS REGRA_SEM_CODIGO_FISCAL
FROM EMPRESA e
INNER JOIN BENEFISCAL bf ON bf.EMPCODIGO = e.EMPCODIGO
LEFT JOIN BENEFISCALDET det ON det.BFCODIGO = bf.BFCODIGO
                            AND det.EMPCODIGO = bf.EMPCODIGO
GROUP BY e.EMPRAZSOCIAL, e.EMPCNPJ
HAVING COUNT(det.BFSEQ) > 0
ORDER BY TOTAL_REGRA DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com BENEFISCALDET | Tipo |
|--------|-----------|----------------------------|------|
| **BENEFISCALDET** | 51 | 1:1 | **TABELA PRINCIPAL** |
| BENEFISCAL | 15 | 3.4:1 | Benefícios fiscais (média de 3.4 regras por benefício) |
| TBFIS | 311 | 6.1:1 | Códigos fiscais disponíveis |
| EMPRESA | 6 | 8.5:1 | Empresas no sistema |

**Interpretação:**
- Cada benefício fiscal possui em média **3.4 regras detalhadas**
- Aproximadamente **6.1 códigos fiscais** disponíveis para cada regra (se todas tivessem FISCODIGO)
- Cada empresa possui em média **8.5 regras** de benefício fiscal
- Tabela pequena mas crítica para configuração fiscal detalhada

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **BFCODIGO + EMPCODIGO** | BENEFISCALDET → BENEFISCAL | Referência ao benefício fiscal |
| **BFSEQ** | BENEFISCALDET | Sequência da regra (PK composta) |
| **FISCODIGO** | BENEFISCALDET → TBFIS | Código fiscal relacionado (lógico) |
| **BFTABICMS + BFCST + FISCODIGO** | BENEFISCALDET | Índice composto para buscas fiscais |
| **EMPCODIGO** | BENEFISCALDET → EMPRESA | Empresa relacionada (lógico) |

---

## 🚀 Performance e Otimização

### Índice Existente

**BENEFISCALDET_IDX1** em (BFTABICMS, BFCST, FISCODIGO)

**Descrição:** Índice composto que otimiza buscas por condições fiscais específicas. Permite encontrar rapidamente regras que correspondem a uma combinação de tabela de ICMS, CST e código fiscal.

**Uso:** Queries que filtram por condições fiscais específicas.

### Recomendações de Performance

1. **Índice na chave primária composta** - Já existe implicitamente (PK)
2. **Índice existente é adequado** - BENEFISCALDET_IDX1 cobre os principais campos de busca
3. **Considerar índice adicional** - Para buscas apenas por BFCODIGO + EMPCODIGO (se não usar PK)

### Índices Adicionais Sugeridos

```sql
-- Índice 1: Busca por benefício (se não usar PK completa)
CREATE INDEX IDX_BENEFISCALDET_BENEFICIO ON BENEFISCALDET(BFCODIGO, EMPCODIGO, BFSEQ);

-- Índice 2: Busca por CST apenas (se necessário)
CREATE INDEX IDX_BENEFISCALDET_CST ON BENEFISCALDET(BFCST);

-- Índice 3: Busca por código fiscal (se necessário)
CREATE INDEX IDX_BENEFISCALDET_FISCODIGO ON BENEFISCALDET(FISCODIGO)
WHERE FISCODIGO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela pequena** (51 registros) - Performance geralmente não é crítica
- **Índice existente** cobre os principais casos de uso
- **Consultas com JOINs** são rápidas devido ao volume reduzido
- **Focar em clareza e manutenibilidade** ao invés de otimização extrema

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usa índice BENEFISCALDET_IDX1)
SELECT BFCODIGO, BFSEQ, BFTABICMS, BFCST, FISCODIGO
FROM BENEFISCALDET
WHERE BFTABICMS = ?
  AND BFCST = ?
  AND FISCODIGO = ?;

-- ✅ OTIMIZADO (usa PK implícita)
SELECT BFCODIGO, BFSEQ, BFTABICMS, BFCST
FROM BENEFISCALDET
WHERE BFCODIGO = ?
  AND EMPCODIGO = ?
ORDER BY BFSEQ;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar regras sem benefício válido
SELECT det.*
FROM BENEFISCALDET det
LEFT JOIN BENEFISCAL bf ON bf.BFCODIGO = det.BFCODIGO
                        AND bf.EMPCODIGO = det.EMPCODIGO
WHERE bf.BFCODIGO IS NULL;

-- Verificar códigos fiscais inválidos
SELECT det.*
FROM BENEFISCALDET det
WHERE det.FISCODIGO IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM TBFIS fis 
      WHERE fis.FISCODIGO = det.FISCODIGO
  );
```

### Verificar Consistência de Dados

```sql
-- Verificar duplicatas de sequência por benefício
SELECT BFCODIGO, EMPCODIGO, BFSEQ, COUNT(*) AS QTD
FROM BENEFISCALDET
GROUP BY BFCODIGO, EMPCODIGO, BFSEQ
HAVING COUNT(*) > 1;

-- Verificar valores obrigatórios nulos
SELECT *
FROM BENEFISCALDET
WHERE BFCODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR BFSEQ IS NULL
   OR BFTABICMS IS NULL
   OR BFCST IS NULL;

-- Verificar sequências não consecutivas
SELECT 
    BFCODIGO,
    EMPCODIGO,
    BFSEQ,
    LAG(BFSEQ) OVER (PARTITION BY BFCODIGO, EMPCODIGO ORDER BY BFSEQ) AS SEQ_ANTERIOR
FROM BENEFISCALDET
WHERE BFSEQ - LAG(BFSEQ) OVER (PARTITION BY BFCODIGO, EMPCODIGO ORDER BY BFSEQ) > 1;
```

### Verificar Regras Órfãs

```sql
-- Verificar regras sem benefício correspondente
SELECT det.*
FROM BENEFISCALDET det
WHERE NOT EXISTS (
    SELECT 1 FROM BENEFISCAL bf
    WHERE bf.BFCODIGO = det.BFCODIGO
      AND bf.EMPCODIGO = det.EMPCODIGO
);
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

final class FirebirdBenefiscalDet extends Model
{
    protected $connection = 'firebird';
    protected $table = 'BENEFISCALDET';
    protected $primaryKey = ['BFCODIGO', 'EMPCODIGO', 'BFSEQ'];

    public $incrementing = false;

    protected $casts = [
        'BFCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'BFSEQ' => 'integer',
        'BFTABICMS' => 'integer',
        'BFCST' => 'string',
        'FISCODIGO' => 'string',
    ];

    // Relacionamento com BENEFISCAL (chave composta)
    public function benefiscal(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdBenefiscal::class,
            ['BFCODIGO', 'EMPCODIGO'],
            ['BFCODIGO', 'EMPCODIGO']
        );
    }

    // Relacionamento com TBFIS (lógico)
    public function codigoFiscal(): BelongsTo
    {
        return $this->belongsTo(FirebirdTbfis::class, 'FISCODIGO', 'FISCODIGO');
    }

    // Relacionamento com EMPRESA (através de BENEFISCAL)
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Scope para filtrar por benefício
    public function scopePorBeneficio($query, int $beneficioCodigo, int $empresaCodigo)
    {
        return $query->where('BFCODIGO', $beneficioCodigo)
                     ->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por CST
    public function scopePorCST($query, string $cst)
    {
        return $query->where('BFCST', $cst);
    }

    // Scope para filtrar por tabela ICMS
    public function scopePorTabelaICMS($query, int $tabelaICMS)
    {
        return $query->where('BFTABICMS', $tabelaICMS);
    }

    // Scope para filtrar por código fiscal
    public function scopePorCodigoFiscal($query, string $fisCodigo)
    {
        return $query->where('FISCODIGO', $fisCodigo);
    }

    // Scope para regras com código fiscal
    public function scopeComCodigoFiscal($query)
    {
        return $query->whereNotNull('FISCODIGO');
    }

    // Scope para regras sem código fiscal
    public function scopeSemCodigoFiscal($query)
    {
        return $query->whereNull('FISCODIGO');
    }

    // Método para verificar se corresponde a condições fiscais
    public function correspondeCondicoes(int $tabelaICMS, string $cst, ?string $fisCodigo = null): bool
    {
        if ($this->BFTABICMS !== $tabelaICMS || $this->BFCST !== $cst) {
            return false;
        }

        // Se FISCODIGO está preenchido na regra, deve corresponder
        if ($this->FISCODIGO !== null) {
            return $this->FISCODIGO === $fisCodigo;
        }

        // Se FISCODIGO não está preenchido na regra, aplica a qualquer código fiscal
        return true;
    }

    // Método para obter próxima sequência disponível
    public static function proximaSequencia(int $beneficioCodigo, int $empresaCodigo): int
    {
        $ultimaSequencia = self::where('BFCODIGO', $beneficioCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->max('BFSEQ');

        return ($ultimaSequencia ?? 0) + 1;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Validação de chave composta** - Sempre validar que BFCODIGO + EMPCODIGO + BFSEQ são únicos
2. **Sequência consecutiva** - Manter BFSEQ consecutivo dentro de cada benefício
3. **Campos obrigatórios** - BFTABICMS e BFCST são obrigatórios e devem ser válidos
4. **Código fiscal opcional** - FISCODIGO pode ser NULL para regras genéricas

### Performance

1. **Usar índice existente** - BENEFISCALDET_IDX1 para buscas por condições fiscais
2. **Filtrar por benefício primeiro** - Usar BFCODIGO + EMPCODIGO antes de outros filtros
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Cache quando apropriado** - Regras fiscais mudam raramente

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se benefício existe
2. **Verificar duplicatas** - Antes de inserir nova regra
3. **Validar CST** - Verificar se CST é válido conforme legislação
4. **Validar tabela ICMS** - Verificar se BFTABICMS é válida
5. **Validar código fiscal** - Se FISCODIGO preenchido, verificar se existe em TBFIS

### Manutenção

1. **Documentação clara** - Manter comentários sobre propósito de cada regra
2. **Revisão periódica** - Verificar regras não utilizadas
3. **Backup regular** - Tabela pequena mas crítica para configuração fiscal
4. **Auditoria** - Registrar alterações em regras fiscais

### Regras de Negócio

1. **Ordem de aplicação** - Regras são aplicadas na ordem de BFSEQ
2. **CST e Tabela ICMS** - Devem ser consistentes com legislação fiscal
3. **Código fiscal específico** - Quando FISCODIGO está preenchido, regra aplica apenas àquele código
4. **Regra genérica** - Quando FISCODIGO é NULL, regra aplica a qualquer código fiscal que corresponda CST e tabela ICMS

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

