# NFDUP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: NFDUP (Duplicatas de Notas Fiscais)
- **Total de Registros**: 2.621.608
- **Total de Colunas**: 24
- **Chave Primária**: NFCODIGO, NFDSEQ, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 2 (NOTAS - duas vezes)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**NFDUP** é uma tabela que armazena duplicatas de notas fiscais. Com **2.621.608 registros**, representa um histórico extenso de duplicatas cadastradas no sistema, incluindo informações sobre data de vencimento, valor, cheque, banco, conta corrente, cobrança, recebimento antecipado e cartão.

Esta tabela funciona como **detalhamento de duplicatas** e permite:
- Registrar todas as duplicatas de notas fiscais
- Armazenar informações sobre data de vencimento e valor
- Vincular duplicatas a cheques e bancos
- Associar duplicatas a contas correntes e cobranças
- Controlar recebimento antecipado e cartão
- Facilitar gestão de duplicatas
- Manter histórico detalhado de duplicatas

Cada registro representa uma duplicata específica de nota fiscal, contendo:
- Código da nota fiscal (NFCODIGO)
- Código da empresa (EMPCODIGO)
- Data de vencimento (NFDDTVENCTO)
- Valor da duplicata (NFDVALOR)
- Sequência da duplicata (NFDSEQ)
- Número do cheque (NFDNRCHEQUE)
- Dígito do número do cheque (NFDDIGNRCH)
- Agência (NFDAGENCIA)
- Número da conta (NFDNRCONTA)
- Código do banco do cheque (BCOCODIGOCH)
- Emitente do cheque (NFDEMITENTECH)
- Indicador de financiamento (NFDFINANC)
- Código do banco (BCOCODIGO)
- Tipo do documento (NFDTIPODOCTO)
- Código da cobrança (COBCODIGO)
- Indicador de recebimento antecipado (NFDRECANTECIP)
- Número da conta corrente (CTANRCONTA)
- Lançamento de conta corrente (CCONRLANCTO)
- Empresa da conta corrente (EMPCCORR)
- Número de autorização (NFDNRAUTO)
- Dia (NFDDIA)
- Código da forma de recebimento (FRCCODIGO)
- Valor do cartão (NFDVRCARTAO)
- Valor dos juros (NFDVRJUROS)

O sistema utiliza esta tabela para manter histórico completo de duplicatas de notas fiscais, sendo referenciada por NOTAS através de NFCODIGO e EMPCODIGO.

**Observação Importante:** NFDUP é uma tabela de duplicatas de notas fiscais. Com 2.621.608 registros, indica uso intenso desta funcionalidade. Possui chave primária composta (NFCODIGO, NFDSEQ, EMPCODIGO) e referencia NOTAS (duas vezes), indicando sua função de detalhamento de duplicatas.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código da nota fiscal (PK, FK) |
| **NFDSEQ** 🔑 | INTEGER | ✓ | Sequência da duplicata (PK) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK, FK) |

### Informações da Duplicata
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFDDTVENCTO** | TIMESTAMP | ✓ | Data de vencimento |
| **NFDVALOR** | DECIMAL(27,2) | ✓ | Valor da duplicata |

### Informações de Cheque
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFDNRCHEQUE** | VARCHAR(37) | | Número do cheque |
| **NFDDIGNRCH** | VARCHAR(14) | | Dígito do número do cheque |
| **NFDAGENCIA** | VARCHAR(37) | | Agência |
| **NFDNRCONTA** | VARCHAR(37) | | Número da conta |
| **BCOCODIGOCH** | INTEGER | | Código do banco do cheque |
| **NFDEMITENTECH** | VARCHAR(37) | | Emitente do cheque |

### Informações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFDFINANC** | VARCHAR(14) | | Indicador de financiamento |
| **BCOCODIGO** | INTEGER | | Código do banco |
| **NFDTIPODOCTO** | VARCHAR(14) | | Tipo do documento |
| **COBCODIGO** | VARCHAR(14) | | Código da cobrança |
| **NFDRECANTECIP** | VARCHAR(14) | | Indicador de recebimento antecipado |
| **FRCCODIGO** | INTEGER | | Código da forma de recebimento |
| **NFDVRCARTAO** | DECIMAL(16,2) | | Valor do cartão |
| **NFDVRJUROS** | DECIMAL(16,2) | | Valor dos juros |

### Informações de Conta Corrente
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTANRCONTA** | VARCHAR(37) | | Número da conta corrente |
| **CCONRLANCTO** | INTEGER | | Lançamento de conta corrente |
| **EMPCCORR** | INTEGER | | Empresa da conta corrente |

### Informações Adicionais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFDNRAUTO** | VARCHAR(37) | | Número de autorização |
| **NFDDIA** | INTEGER | | Dia |

**Primary Key:** NFCODIGO, NFDSEQ, EMPCODIGO (composta)

**Foreign Keys:**
- `NOTAS_NFDUP`: NFCODIGO, EMPCODIGO → NOTAS.NFCODIGO, NOTAS.EMPCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### NFDUP Referencia (1 tabela):

#### 1. NOTAS - Notas Fiscais
**Relacionamento:**
```
NFDUP.NFCODIGO, NFDUP.EMPCODIGO → NOTAS.NFCODIGO, NOTAS.EMPCODIGO (N:1)
Constraint: NOTAS_NFDUP
```

**Descrição**: Cada duplicata está vinculada a uma nota fiscal específica.

**Informações da Tabela NOTAS:**
- **Total:** 1.206.013 notas fiscais
- **PK:** NFCODIGO, EMPCODIGO (composta)
- **Colunas:** 172 campos

**Uso:** Vincular duplicatas a notas fiscais para gestão financeira.

---

### NFDUP é Referenciada Por (0 tabelas):

Nenhuma tabela referencia NFDUP diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via BCOCODIGO → BANCO

**Fluxo:** NFDUP → BANCO → Operações

**Descrição:** Através do código do banco, é possível identificar bancos relacionados.

**Uso:** Análise de duplicatas através de bancos.

---

### Via BCOCODIGOCH → BANCO

**Fluxo:** NFDUP → BANCO → Operações

**Descrição:** Através do código do banco do cheque, é possível identificar bancos relacionados.

**Uso:** Análise de duplicatas através de bancos de cheques.

---

### Via COBCODIGO → BCOCOB

**Fluxo:** NFDUP → BCOCOB → Operações

**Descrição:** Através do código da cobrança, é possível identificar cobranças relacionadas.

**Uso:** Análise de duplicatas através de cobranças.

---

### Via CTANRCONTA, CCONRLANCTO, EMPCCORR → CCORR

**Fluxo:** NFDUP → CCORR → Operações

**Descrição:** Através dos dados da conta corrente, é possível identificar lançamentos relacionados.

**Uso:** Análise de duplicatas através de lançamentos de conta corrente.

---

### Via FRCCODIGO → CFORRECEB

**Fluxo:** NFDUP → CFORRECEB → Operações

**Descrição:** Através do código da forma de recebimento, é possível identificar formas relacionadas.

**Uso:** Análise de duplicatas através de formas de recebimento.

---

### Via NOTAS → Outras Operações

**Fluxo:** NFDUP → NOTAS → Operações

**Descrição:** Através das notas fiscais vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de duplicatas através de operações de notas fiscais.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Duplicata de Nota Fiscal

**Objetivo:** Obter informações de uma duplicata específica.

```sql
SELECT
    d.NFCODIGO,
    d.EMPCODIGO,
    d.NFDSEQ,
    d.NFDDTVENCTO,
    d.NFDVALOR,
    d.NFDNRCHEQUE,
    d.BCOCODIGO,
    d.COBCODIGO,
    d.NFDVRCARTAO,
    d.NFDVRJUROS
FROM NFDUP d
WHERE d.NFCODIGO = ? AND d.NFDSEQ = ? AND d.EMPCODIGO = ?;
```

---

### 2. Listar Duplicatas de uma Nota Fiscal

**Objetivo:** Obter todas as duplicatas de uma nota fiscal específica.

```sql
SELECT
    NFDSEQ,
    NFDDTVENCTO,
    NFDVALOR,
    NFDNRCHEQUE,
    BCOCODIGO,
    COBCODIGO
FROM NFDUP
WHERE NFCODIGO = ? AND EMPCODIGO = ?
ORDER BY NFDSEQ;
```

---

### 3. Análise de Duplicatas por Período de Vencimento

**Objetivo:** Identificar distribuição de duplicatas por período de vencimento.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM NFDDTVENCTO) AS ANO,
    EXTRACT(MONTH FROM NFDDTVENCTO) AS MES,
    COUNT(*) AS TOTAL_DUPLICATAS,
    SUM(NFDVALOR) AS VALOR_TOTAL
FROM NFDUP
WHERE NFDDTVENCTO IS NOT NULL
GROUP BY EXTRACT(YEAR FROM NFDDTVENCTO), EXTRACT(MONTH FROM NFDDTVENCTO)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Buscar Duplicatas Vencidas

**Objetivo:** Obter duplicatas que estão vencidas.

```sql
SELECT
    NFCODIGO,
    EMPCODIGO,
    NFDSEQ,
    NFDDTVENCTO,
    NFDVALOR,
    COBCODIGO
FROM NFDUP
WHERE NFDDTVENCTO < CURRENT_DATE
ORDER BY NFDDTVENCTO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com NFDUP | Tipo |
|--------|-----------|-------------------|------|
| **NFDUP** | 2.621.608 | 1:1 | **TABELA PRINCIPAL** |
| NOTAS | 1.206.013 | 1:2.17 | Notas fiscais (média de 2.17 duplicatas por nota) |

**Interpretação:**
- **2.621.608 duplicatas** registradas no sistema
- **Média de 2.17 duplicatas por nota** - indica que cada nota possui em média 2 duplicatas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nota fiscal (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_NFDUP_NOTA ON NFDUP(NFCODIGO, EMPCODIGO);

-- Índice 2: Busca por data de vencimento (consultas frequentes)
CREATE INDEX IDX_NFDUP_VENCTO ON NFDUP(NFDDTVENCTO)
    WHERE NFDDTVENCTO IS NOT NULL;

-- Índice 3: Busca por cobrança (consultas frequentes)
CREATE INDEX IDX_NFDUP_COBRANCA ON NFDUP(COBCODIGO)
    WHERE COBCODIGO IS NOT NULL;

-- Índice 4: Busca por banco (consultas frequentes)
CREATE INDEX IDX_NFDUP_BANCO ON NFDUP(BCOCODIGO)
    WHERE BCOCODIGO IS NOT NULL;
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

final class FirebirdNfdup extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'NFDUP';
    
    protected $primaryKey = ['NFCODIGO', 'NFDSEQ', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'NFCODIGO' => 'string',
        'NFDSEQ' => 'integer',
        'EMPCODIGO' => 'integer',
        'NFDDTVENCTO' => 'datetime',
        'NFDVALOR' => 'decimal:2',
        'NFDNRCHEQUE' => 'string',
        'NFDDIGNRCH' => 'string',
        'NFDAGENCIA' => 'string',
        'NFDNRCONTA' => 'string',
        'BCOCODIGOCH' => 'integer',
        'NFDEMITENTECH' => 'string',
        'NFDFINANC' => 'string',
        'BCOCODIGO' => 'integer',
        'NFDTIPODOCTO' => 'string',
        'COBCODIGO' => 'string',
        'NFDRECANTECIP' => 'string',
        'CTANRCONTA' => 'string',
        'CCONRLANCTO' => 'integer',
        'EMPCCORR' => 'integer',
        'NFDNRAUTO' => 'string',
        'NFDDIA' => 'integer',
        'FRCCODIGO' => 'integer',
        'NFDVRCARTAO' => 'decimal:2',
        'NFDVRJUROS' => 'decimal:2',
    ];

    // Relacionamento com NOTAS
    public function notaFiscal(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdNotas::class,
            ['NFCODIGO', 'EMPCODIGO'],
            ['NFCODIGO', 'EMPCODIGO']
        );
    }

    public function scopePorNotaFiscal($query, string $nfCodigo, int $empCodigo)
    {
        return $query->where('NFCODIGO', $nfCodigo)
                     ->where('EMPCODIGO', $empCodigo);
    }

    public function scopeVencidas($query)
    {
        return $query->where('NFDDTVENCTO', '<', now());
    }

    public function scopePorCobranca($query, string $cobCodigo)
    {
        return $query->where('COBCODIGO', $cobCodigo);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('NFDDTVENCTO', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('NFDDTVENCTO')->orderBy('NFDSEQ');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

