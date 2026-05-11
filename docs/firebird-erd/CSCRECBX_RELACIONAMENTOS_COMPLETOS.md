# CSCRECBX - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CSCRECBX (Cobrança x Recebimento/Baixa)
- **Total de Registros**: 243.059
- **Total de Colunas**: 25
- **Chave Primária**: ID_CSCRECBX (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 1 (IDXCSCRECBX em RECCODIGO, EMPCODIGO, REBCONTADOR)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CSCRECBX** é uma tabela que armazena informações sobre reconciliação entre cobranças bancárias (CSC) e recebimentos/baixas (RECBX). Com **243.059 registros**, representa histórico extensivo de reconciliações entre cobranças e recebimentos, permitindo controle completo de conciliação bancária e rastreabilidade de pagamentos.

Esta tabela funciona como **sistema de reconciliação de cobranças bancárias** e permite:
- Registrar reconciliações entre cobranças e recebimentos
- Controlar datas de pagamento e liquidação
- Rastrear valores de títulos, baixas, descontos, juros e abatimentos
- Associar reconciliações a contadores de recebimento
- Identificar CNPJs do laboratório e cliente
- Controlar estornos
- Associar a lotes de cheque
- Suportar informações bancárias (agência, conta, número de compensação)
- Registrar observações e histórico

Cada registro representa uma reconciliação específica entre uma cobrança bancária e um recebimento/baixa, contendo:
- Identificador único da reconciliação (ID_CSCRECBX)
- Cobrança bancária relacionada (ID_CSC)
- Data de log (LOG_DATA)
- Empresa (EMPCODIGO)
- Código do recebimento (RECCODIGO)
- Contador do recebimento (REBCONTADOR)
- Flag de estorno (ESTORNO)
- CNPJ do laboratório (LABCNPJ)
- CNPJ do cliente (CLICNPJ)
- Fatura relacionada (FATURA)
- Datas de pagamento e liquidação (DATAPGT, DATALIQ)
- Valores (VRTITULO, VRBAIXA, VRDESCONTO, VRJUROS, VRABATIMENTO)
- Observações (OBSERVACAO)
- Documento de baixa (DOCTOBX)
- Informações bancárias (BCONRCOMP, BCOAGENCIA, BCONRCONTA)
- Flag de crédito (CREDITO)
- Lote de cheque (IDLOTECH)
- Descrição do histórico (HISDESCRICAO)

O sistema utiliza esta tabela para gerenciar todas as reconciliações entre cobranças bancárias e recebimentos, permitindo controle financeiro completo e rastreabilidade de pagamentos.

**Observação Importante:** CSCRECBX é uma tabela grande (243.059 registros) do sistema financeiro, sendo essencial para reconciliação bancária e controle de recebimentos. Com índice composto em (RECCODIGO, EMPCODIGO, REBCONTADOR), permite buscas eficientes por recebimento.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_CSCRECBX** 🔑 | INTEGER | ✓ | Identificador único da reconciliação |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_CSC** 🔗 | INTEGER | | Código da cobrança bancária (FK → CSC) |
| **EMPCODIGO** | SMALLINT | | Código da empresa |
| **RECCODIGO** | INTEGER | | Código do recebimento (lógica → RECEB) |
| **REBCONTADOR** | SMALLINT | | Contador do recebimento (lógica → RECBX) |
| **IDLOTECH** | INTEGER | | Código do lote de cheque (lógica → LOTECH) |

### Informações Temporais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LOG_DATA** | TIMESTAMP | | Data de registro/log |
| **DATAPGT** | TIMESTAMP | | Data de pagamento |
| **DATALIQ** | TIMESTAMP | | Data de liquidação |

### Informações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **VRTITULO** | NUMERIC(16,2) | | Valor do título |
| **VRBAIXA** | NUMERIC(16,2) | | Valor da baixa |
| **VRDESCONTO** | NUMERIC(16,2) | | Valor do desconto |
| **VRJUROS** | NUMERIC(16,2) | | Valor dos juros |
| **VRABATIMENTO** | NUMERIC(16,2) | | Valor do abatimento |

### Informações de Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **LABCNPJ** | VARCHAR(37) | | CNPJ do laboratório |
| **CLICNPJ** | VARCHAR(37) | | CNPJ do cliente |
| **FATURA** | VARCHAR(37) | | Número da fatura |
| **DOCTOBX** | VARCHAR(37) | | Documento de baixa |

### Informações Bancárias
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **BCONRCOMP** | VARCHAR(37) | | Número de compensação do banco |
| **BCOAGENCIA** | VARCHAR(37) | | Agência do banco |
| **BCONRCONTA** | VARCHAR(37) | | Número da conta bancária |

### Informações de Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ESTORNO** | VARCHAR(14) | | Flag indicando se é estorno |
| **CREDITO** | VARCHAR(14) | | Flag indicando se é crédito |
| **OBSERVACAO** | VARCHAR(37) | | Observações |
| **HISDESCRICAO** | VARCHAR(37) | | Descrição do histórico |

**Primary Key:** ID_CSCRECBX

**Observações sobre Campos:**
- **ID_CSCRECBX**: Identificador único de cada reconciliação.
- **ID_CSC**: Cobrança bancária relacionada à reconciliação.
- **RECCODIGO**: Código do recebimento relacionado.
- **REBCONTADOR**: Contador do recebimento (permite múltiplas baixas por recebimento).
- **DATAPGT**: Data em que o pagamento foi efetuado.
- **DATALIQ**: Data em que o pagamento foi liquidado.
- **VRTITULO**: Valor original do título.
- **VRBAIXA**: Valor efetivamente baixado.
- **VRDESCONTO**: Valor de desconto aplicado.
- **VRJUROS**: Valor de juros aplicado.
- **VRABATIMENTO**: Valor de abatimento aplicado.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CSCRECBX Referencia (1 FK):

#### 1. CSC - Cobranças Bancárias
**Relacionamento:**
```
CSCRECBX.ID_CSC → CSC.ID_CSC (N:1)
Constraint: XFKCSCRECBX_CSC
```

**Descrição**: Cada reconciliação está vinculada a uma cobrança bancária específica.

**Informações da Tabela CSC:**
- **Total:** ~? cobranças bancárias
- **PK:** ID_CSC
- **Colunas:** Múltiplos campos

**Uso:** Identificar a cobrança bancária relacionada, obter informações da cobrança.

---

### CSCRECBX é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CSCRECBX diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ID_CSC → CSC → Informações da Cobrança

**Fluxo:** CSCRECBX → CSC → Informações

**Descrição:** Através da cobrança bancária, é possível identificar informações relacionadas.

**Uso:** Análise de reconciliações por cobrança.

---

### Via RECCODIGO + EMPCODIGO + REBCONTADOR → RECBX → Recebimentos

**Fluxo:** CSCRECBX → RECBX → RECEB

**Descrição:** Através dos campos RECCODIGO, EMPCODIGO e REBCONTADOR, é possível identificar o recebimento relacionado (via RECBX).

**Uso:** Análise de reconciliações por recebimento.

**Nota:** Este é um relacionamento lógico baseado na estrutura da chave primária de RECBX (RECCODIGO, EMPCODIGO, REBCONTADOR).

---

### Via IDLOTECH → LOTECH → Lotes de Cheque

**Fluxo:** CSCRECBX → LOTECH → Informações

**Descrição:** Através do lote de cheque, é possível identificar informações relacionadas.

**Uso:** Análise de reconciliações por lote de cheque.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Reconciliação

**Objetivo:** Obter visão completa de uma reconciliação incluindo informações da cobrança e recebimento.

**Fluxo:**
```
CSCRECBX (ID_CSCRECBX, ID_CSC, RECCODIGO, REBCONTADOR)
  ↓
CSC (ID_CSC)
  ↓
RECBX (RECCODIGO, EMPCODIGO, REBCONTADOR)
  ↓
RECEB (RECCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    csr.ID_CSCRECBX,
    csr.ID_CSC,
    cs.CODIGO AS CODIGO_COBRANCA,
    csr.RECCODIGO,
    csr.REBCONTADOR,
    csr.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    csr.DATAPGT AS DATA_PAGAMENTO,
    csr.DATALIQ AS DATA_LIQUIDACAO,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.VRDESCONTO AS VALOR_DESCONTO,
    csr.VRJUROS AS VALOR_JUROS,
    csr.VRABATIMENTO AS VALOR_ABATIMENTO,
    csr.LABCNPJ AS CNPJ_LABORATORIO,
    csr.CLICNPJ AS CNPJ_CLIENTE,
    csr.FATURA AS FATURA,
    csr.ESTORNO AS ESTORNO,
    csr.CREDITO AS CREDITO
FROM CSCRECBX csr
LEFT JOIN CSC cs ON cs.ID_CSC = csr.ID_CSC
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = csr.EMPCODIGO
LEFT JOIN RECBX rb ON rb.RECCODIGO = csr.RECCODIGO
                 AND rb.EMPCODIGO = csr.EMPCODIGO
                 AND rb.REBCONTADOR = csr.REBCONTADOR
WHERE csr.ID_CSCRECBX = ?;
```

---

### Exemplo 2: Análise de Reconciliações por Cobrança

**Objetivo:** Obter todas as reconciliações relacionadas a uma cobrança bancária específica.

**Query SQL:**
```sql
SELECT
    csr.ID_CSCRECBX,
    csr.RECCODIGO,
    csr.REBCONTADOR,
    csr.DATAPGT AS DATA_PAGAMENTO,
    csr.DATALIQ AS DATA_LIQUIDACAO,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.VRDESCONTO AS VALOR_DESCONTO,
    csr.VRJUROS AS VALOR_JUROS,
    csr.ESTORNO AS ESTORNO
FROM CSCRECBX csr
WHERE csr.ID_CSC = ?
ORDER BY csr.DATAPGT DESC, csr.RECCODIGO, csr.REBCONTADOR;
```

---

### Exemplo 3: Análise de Reconciliações por Recebimento

**Objetivo:** Obter todas as reconciliações relacionadas a um recebimento específico.

**Query SQL:**
```sql
SELECT
    csr.ID_CSCRECBX,
    csr.ID_CSC,
    cs.CODIGO AS CODIGO_COBRANCA,
    csr.DATAPGT AS DATA_PAGAMENTO,
    csr.DATALIQ AS DATA_LIQUIDACAO,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.VRDESCONTO AS VALOR_DESCONTO,
    csr.VRJUROS AS VALOR_JUROS,
    csr.ESTORNO AS ESTORNO
FROM CSCRECBX csr
LEFT JOIN CSC cs ON cs.ID_CSC = csr.ID_CSC
WHERE csr.RECCODIGO = ?
  AND csr.EMPCODIGO = ?
  AND csr.REBCONTADOR = ?
ORDER BY csr.DATAPGT DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Reconciliação

**Objetivo:** Obter informações de uma reconciliação específica.

```sql
SELECT
    ID_CSCRECBX,
    ID_CSC,
    RECCODIGO,
    REBCONTADOR,
    EMPCODIGO,
    DATAPGT AS DATA_PAGAMENTO,
    DATALIQ AS DATA_LIQUIDACAO,
    VRTITULO AS VALOR_TITULO,
    VRBAIXA AS VALOR_BAIXA,
    VRDESCONTO AS VALOR_DESCONTO,
    VRJUROS AS VALOR_JUROS,
    VRABATIMENTO AS VALOR_ABATIMENTO,
    ESTORNO,
    CREDITO
FROM CSCRECBX
WHERE ID_CSCRECBX = ?;
```

---

### 2. Listar Reconciliações por Período

**Objetivo:** Obter reconciliações em um período específico.

```sql
SELECT
    csr.ID_CSCRECBX,
    csr.ID_CSC,
    csr.RECCODIGO,
    csr.REBCONTADOR,
    csr.DATAPGT AS DATA_PAGAMENTO,
    csr.DATALIQ AS DATA_LIQUIDACAO,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.ESTORNO AS ESTORNO
FROM CSCRECBX csr
WHERE csr.DATAPGT >= ?
  AND csr.DATAPGT <= ?
ORDER BY csr.DATAPGT DESC, csr.RECCODIGO, csr.REBCONTADOR;
```

---

### 3. Análise de Reconciliações por Estorno

**Objetivo:** Identificar reconciliações que são estornos.

```sql
SELECT
    csr.ID_CSCRECBX,
    csr.ID_CSC,
    csr.RECCODIGO,
    csr.REBCONTADOR,
    csr.DATAPGT AS DATA_PAGAMENTO,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.ESTORNO AS ESTORNO
FROM CSCRECBX csr
WHERE csr.ESTORNO = 'S'
   OR csr.ESTORNO = 'SIM'
ORDER BY csr.DATAPGT DESC;
```

---

### 4. Análise de Valores por Período

**Objetivo:** Calcular totais de valores por período.

```sql
SELECT
    COUNT(*) AS TOTAL_RECONCILIACOES,
    SUM(VRTITULO) AS VALOR_TOTAL_TITULOS,
    SUM(VRBAIXA) AS VALOR_TOTAL_BAIXAS,
    SUM(VRDESCONTO) AS VALOR_TOTAL_DESCONTOS,
    SUM(VRJUROS) AS VALOR_TOTAL_JUROS,
    SUM(VRABATIMENTO) AS VALOR_TOTAL_ABATIMENTOS,
    COUNT(CASE WHEN ESTORNO = 'S' OR ESTORNO = 'SIM' THEN 1 END) AS TOTAL_ESTORNOS,
    SUM(CASE WHEN ESTORNO = 'S' OR ESTORNO = 'SIM' THEN VRBAIXA ELSE 0 END) AS VALOR_ESTORNOS
FROM CSCRECBX
WHERE DATAPGT >= ?
  AND DATAPGT <= ?;
```

---

### 5. Análise de Reconciliações por Cliente

**Objetivo:** Identificar reconciliações agrupadas por CNPJ do cliente.

**Query SQL:**
```sql
SELECT
    CLICNPJ AS CNPJ_CLIENTE,
    COUNT(*) AS TOTAL_RECONCILIACOES,
    SUM(VRTITULO) AS VALOR_TOTAL_TITULOS,
    SUM(VRBAIXA) AS VALOR_TOTAL_BAIXAS,
    SUM(VRDESCONTO) AS VALOR_TOTAL_DESCONTOS,
    SUM(VRJUROS) AS VALOR_TOTAL_JUROS,
    MIN(DATAPGT) AS PRIMEIRA_RECONCILIACAO,
    MAX(DATAPGT) AS ULTIMA_RECONCILIACAO
FROM CSCRECBX
WHERE CLICNPJ IS NOT NULL
  AND CLICNPJ != ''
GROUP BY CLICNPJ
ORDER BY VALOR_TOTAL_BAIXAS DESC;
```

---

### 6. Identificar Diferenças entre Título e Baixa

**Objetivo:** Identificar reconciliações com diferenças entre valor do título e valor da baixa.

**Query SQL:**
```sql
SELECT
    csr.ID_CSCRECBX,
    csr.ID_CSC,
    csr.RECCODIGO,
    csr.REBCONTADOR,
    csr.VRTITULO AS VALOR_TITULO,
    csr.VRBAIXA AS VALOR_BAIXA,
    csr.VRDESCONTO AS VALOR_DESCONTO,
    csr.VRJUROS AS VALOR_JUROS,
    csr.VRABATIMENTO AS VALOR_ABATIMENTO,
    (csr.VRTITULO - csr.VRBAIXA) AS DIFERENCA,
    (csr.VRDESCONTO + csr.VRJUROS - csr.VRABATIMENTO) AS AJUSTES
FROM CSCRECBX csr
WHERE ABS(csr.VRTITULO - csr.VRBAIXA) > 0.01
ORDER BY ABS(csr.VRTITULO - csr.VRBAIXA) DESC;
```

---

### 7. Relatório Completo de Reconciliações

**Objetivo:** Analisar distribuição completa de reconciliações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_RECONCILIACOES,
    COUNT(DISTINCT ID_CSC) AS TOTAL_COBRANCAS,
    COUNT(DISTINCT RECCODIGO) AS TOTAL_RECEBIMENTOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT CLICNPJ) AS TOTAL_CLIENTES,
    SUM(VRTITULO) AS VALOR_TOTAL_TITULOS,
    SUM(VRBAIXA) AS VALOR_TOTAL_BAIXAS,
    SUM(VRDESCONTO) AS VALOR_TOTAL_DESCONTOS,
    SUM(VRJUROS) AS VALOR_TOTAL_JUROS,
    SUM(VRABATIMENTO) AS VALOR_TOTAL_ABATIMENTOS,
    COUNT(CASE WHEN ESTORNO = 'S' OR ESTORNO = 'SIM' THEN 1 END) AS TOTAL_ESTORNOS,
    COUNT(CASE WHEN CREDITO = 'S' OR CREDITO = 'SIM' THEN 1 END) AS TOTAL_CREDITOS,
    MIN(DATAPGT) AS PRIMEIRA_RECONCILIACAO,
    MAX(DATAPGT) AS ULTIMA_RECONCILIACAO
FROM CSCRECBX;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CSCRECBX | Tipo |
|--------|-----------|----------------------|------|
| **CSCRECBX** | 243.059 | 1:1 | **TABELA PRINCIPAL** |
| CSC | ~? | ?:1 | Cobranças bancárias (média de ? reconciliações por cobrança) |
| RECBX | 216.135 | 1:1.12 | Recebimentos/Baixas (média de ~1.12 reconciliações por recebimento) |

**Interpretação:**
- **243.059 reconciliações** cadastradas no sistema
- **Média de ~1.12 reconciliações por recebimento** - indica que a maioria dos recebimentos tem uma reconciliação
- **Uso extensivo** - tabela grande indica gestão ativa de reconciliação bancária

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IDXCSCRECBX** - Índice composto em (RECCODIGO, EMPCODIGO, REBCONTADOR)

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por cobrança** - Para buscas por cobrança
3. **Índice por data de pagamento** - Para buscas por período
4. **Índice por data de liquidação** - Para buscas por liquidação
5. **Índice por estorno** - Para buscas de estornos
6. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cobrança (consultas frequentes)
CREATE INDEX IDX_CSCRECBX_COBRANCA ON CSCRECBX(ID_CSC)
    WHERE ID_CSC IS NOT NULL;

-- Índice 2: Busca por data de pagamento (consultas frequentes)
CREATE INDEX IDX_CSCRECBX_DATA_PAGAMENTO ON CSCRECBX(DATAPGT)
    WHERE DATAPGT IS NOT NULL;

-- Índice 3: Busca por data de liquidação (consultas frequentes)
CREATE INDEX IDX_CSCRECBX_DATA_LIQUIDACAO ON CSCRECBX(DATALIQ)
    WHERE DATALIQ IS NOT NULL;

-- Índice 4: Busca por estorno (consultas de análise)
CREATE INDEX IDX_CSCRECBX_ESTORNO ON CSCRECBX(ESTORNO)
    WHERE ESTORNO IS NOT NULL AND (ESTORNO = 'S' OR ESTORNO = 'SIM');

-- Índice 5: Busca composta por cobrança e data (consultas frequentes)
CREATE INDEX IDX_CSCRECBX_COB_DATA ON CSCRECBX(ID_CSC, DATAPGT)
    WHERE ID_CSC IS NOT NULL AND DATAPGT IS NOT NULL;

-- Índice 6: Busca por lote de cheque (consultas de análise)
CREATE INDEX IDX_CSCRECBX_LOTE_CHEQUE ON CSCRECBX(IDLOTECH)
    WHERE IDLOTECH IS NOT NULL;
```

### Observações sobre Volume

- **Tabela grande** (243.059 registros) - Performance boa com índices adequados
- **Índice existente** - Em (RECCODIGO, EMPCODIGO, REBCONTADOR) é útil para buscas por recebimento
- **Consultas frequentes** - Reconciliações são consultadas durante análise financeira
- **Índices essenciais** - Em ID_CSC, DATAPGT e DATALIQ para buscas frequentes

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar reconciliações sem cobrança válida (quando informado)
SELECT csr.*
FROM CSCRECBX csr
WHERE csr.ID_CSC IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM CSC cs WHERE cs.ID_CSC = csr.ID_CSC);

-- Verificar reconciliações sem recebimento válido (quando informado)
SELECT csr.*
FROM CSCRECBX csr
WHERE csr.RECCODIGO IS NOT NULL
  AND csr.EMPCODIGO IS NOT NULL
  AND csr.REBCONTADOR IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM RECBX rb 
      WHERE rb.RECCODIGO = csr.RECCODIGO
        AND rb.EMPCODIGO = csr.EMPCODIGO
        AND rb.REBCONTADOR = csr.REBCONTADOR
  );
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos (se aplicável)
SELECT *
FROM CSCRECBX
WHERE ID_CSCRECBX IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT ID_CSCRECBX, COUNT(*) AS QTD
FROM CSCRECBX
GROUP BY ID_CSCRECBX
HAVING COUNT(*) > 1;

-- Verificar valores inválidos
SELECT *
FROM CSCRECBX
WHERE VRTITULO < 0
   OR VRBAIXA < 0
   OR VRDESCONTO < 0
   OR VRJUROS < 0
   OR VRABATIMENTO < 0;

-- Verificar datas inconsistentes
SELECT *
FROM CSCRECBX
WHERE DATALIQ IS NOT NULL
  AND DATAPGT IS NOT NULL
  AND DATALIQ < DATAPGT;
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

final class FirebirdCscrecbx extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CSCRECBX';
    
    protected $primaryKey = 'ID_CSCRECBX';
    public $incrementing = true;

    protected $casts = [
        'ID_CSCRECBX' => 'integer',
        'ID_CSC' => 'integer',
        'EMPCODIGO' => 'integer',
        'RECCODIGO' => 'integer',
        'REBCONTADOR' => 'integer',
        'IDLOTECH' => 'integer',
        'LOG_DATA' => 'datetime',
        'DATAPGT' => 'datetime',
        'DATALIQ' => 'datetime',
        'VRTITULO' => 'decimal:2',
        'VRBAIXA' => 'decimal:2',
        'VRDESCONTO' => 'decimal:2',
        'VRJUROS' => 'decimal:2',
        'VRABATIMENTO' => 'decimal:2',
        'ESTORNO' => 'string',
        'CREDITO' => 'string',
        'LABCNPJ' => 'string',
        'CLICNPJ' => 'string',
        'FATURA' => 'string',
        'DOCTOBX' => 'string',
        'BCONRCOMP' => 'string',
        'BCOAGENCIA' => 'string',
        'BCONRCONTA' => 'string',
        'OBSERVACAO' => 'string',
        'HISDESCRICAO' => 'string',
    ];

    // Relacionamento com CSC
    public function cobranca(): BelongsTo
    {
        return $this->belongsTo(FirebirdCsc::class, 'ID_CSC', 'ID_CSC');
    }

    // Relacionamento lógico com RECBX
    public function recebimentoBaixa()
    {
        return $this->belongsTo(FirebirdRecbx::class, ['RECCODIGO', 'EMPCODIGO', 'REBCONTADOR'], 
                               ['RECCODIGO', 'EMPCODIGO', 'REBCONTADOR']);
    }

    // Método para verificar se é estorno
    public function ehEstorno(): bool
    {
        return !empty($this->ESTORNO) && ($this->ESTORNO === 'S' || $this->ESTORNO === 'SIM');
    }

    // Método para verificar se é crédito
    public function ehCredito(): bool
    {
        return !empty($this->CREDITO) && ($this->CREDITO === 'S' || $this->CREDITO === 'SIM');
    }

    // Método para calcular diferença entre título e baixa
    public function calcularDiferenca(): float
    {
        return (float)($this->VRTITULO - $this->VRBAIXA);
    }

    // Scope para filtrar por cobrança
    public function scopePorCobranca($query, int $cobrancaId)
    {
        return $query->where('ID_CSC', $cobrancaId);
    }

    // Scope para filtrar por recebimento
    public function scopePorRecebimento($query, int $recebimentoCodigo, int $empresaCodigo, int $contador)
    {
        return $query->where('RECCODIGO', $recebimentoCodigo)
                     ->where('EMPCODIGO', $empresaCodigo)
                     ->where('REBCONTADOR', $contador);
    }

    // Scope para filtrar estornos
    public function scopeEstornos($query)
    {
        return $query->where(function($q) {
            $q->where('ESTORNO', 'S')
              ->orWhere('ESTORNO', 'SIM');
        });
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('DATAPGT', [$dataInicio, $dataFim]);
    }

    // Método estático para calcular totais por período
    public static function calcularTotaisPorPeriodo(string $dataInicio, string $dataFim): array
    {
        return self::whereBetween('DATAPGT', [$dataInicio, $dataFim])
            ->selectRaw('
                COUNT(*) as total_reconciliacoes,
                SUM(VRTITULO) as valor_total_titulos,
                SUM(VRBAIXA) as valor_total_baixas,
                SUM(VRDESCONTO) as valor_total_descontos,
                SUM(VRJUROS) as valor_total_juros,
                SUM(VRABATIMENTO) as valor_total_abatimentos
            ')
            ->first()
            ->toArray();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - ID_CSCRECBX identifica unicamente cada reconciliação
2. **Validação antes de inserir** - Verificar se cobrança existe (quando informado)
3. **Evitar duplicatas** - PK previne duplicatas
4. **Validação de valores** - Verificar valores não negativos
5. **Validação de datas** - Verificar que data de liquidação é posterior à pagamento

### Performance

1. **Tabela grande** - 243.059 registros, performance boa com índices adequados
2. **Índices essenciais** - Em ID_CSC, DATAPGT e DATALIQ para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cobrança + data)
4. **Consultas frequentes** - Reconciliações são consultadas durante análise financeira

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cobrança existe (quando informado)
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - Verificar valores não negativos
5. **Validação de datas** - Verificar que datas são válidas e consistentes

### Manutenção

1. **Revisão periódica** - Verificar reconciliações com diferenças significativas
2. **Padronização** - Manter estrutura de flags (ESTORNO, CREDITO) consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para controle financeiro
5. **Arquivamento** - Considerar arquivar reconciliações antigas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

