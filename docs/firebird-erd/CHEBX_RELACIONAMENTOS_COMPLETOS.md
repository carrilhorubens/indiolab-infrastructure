# CHEBX - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CHEBX (Baixas de Cheques)
- **Total de Registros**: 17.782
- **Total de Colunas**: 12
- **Chave Primária**: (CHCODIGO, EMPCODIGO, CHBSEQ) - Composta
- **Chaves Estrangeiras**: 6
- **Índices**: 1 (INDCHBDATA)
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CHEBX** é uma tabela de detalhes que registra as baixas (movimentações) de cheques no sistema. Com **17.782 registros**, representa o histórico de movimentações de cheques, vinculando cada cheque a movimentações bancárias específicas (CCORR).

Esta tabela funciona como **rastreador de movimentações de cheques** e permite:
- Registrar cada baixa/movimentação de um cheque
- Vincular cheques a movimentações bancárias (CCORR)
- Rastrear destino e origem de cada movimentação
- Controlar histórico completo de movimentações por cheque
- Integrar cheques com sistema de conta corrente
- Suportar múltiplas baixas por cheque (sequencial CHBSEQ)

Cada registro representa uma movimentação específica de um cheque, contendo:
- Identificação do cheque (CHCODIGO + EMPCODIGO)
- Sequência da baixa (CHBSEQ)
- Data da baixa (CHBDATA)
- Destino da movimentação (CHBDESTINO)
- Origem da movimentação (CHBORIGEM)
- Vinculação com movimentação bancária (CCORR via chave composta)
- Cliente relacionado (CLICODIGO) - opcional
- Código de modelo/documento (MDCCODIGO) - opcional

O sistema utiliza esta tabela para rastrear todas as movimentações de cheques, desde a emissão até a compensação, permitindo auditoria completa e controle financeiro detalhado.

**Observação Importante:** CHEBX permite múltiplas baixas por cheque através do campo CHBSEQ, permitindo rastrear diferentes movimentações do mesmo cheque (ex: emissão, depósito, compensação, devolução).

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHCODIGO** 🔑🔗 | INTEGER | ✓ | Código do cheque (PK + FK → CHEQUE) |
| **EMPCODIGO** 🔑🔗 | INTEGER | ✓ | Código da empresa (PK + FK → CHEQUE) |
| **CHBSEQ** 🔑 | INTEGER | ✓ | Sequência da baixa/movimentação (PK) |

### Dados da Baixa
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHBDATA** | DATE | ✓ | Data da baixa/movimentação (INDEXADO) |
| **CHBDESTINO** | VARCHAR(37) | | Destino da movimentação |
| **CHBORIGEM** | VARCHAR(14) | ✓ | Origem da movimentação |

### Relacionamentos com Movimentações Bancárias
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **BCOCODIGO** 🔗 | INTEGER | | Código do banco (FK → CCORR) |
| **CTANRCONTA** 🔗 | VARCHAR(37) | | Número da conta (FK → CCORR) |
| **CCONRLANCTO** 🔗 | INTEGER | | Número do lançamento (FK → CCORR) |
| **EMPCCORR** 🔗 | INTEGER | | Empresa correntista (FK → CCORR) |

### Outros Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** | INTEGER | | Código do cliente relacionado (opcional) |
| **MDCCODIGO** | INTEGER | | Código de modelo/documento (opcional) |

**Primary Key:** (CHCODIGO, EMPCODIGO, CHBSEQ)

**Observações sobre Campos:**
- **CHBSEQ**: Sequência que permite múltiplas baixas por cheque. Cada movimentação do cheque recebe um número sequencial.
- **CHBDATA**: Data da movimentação, indexada para consultas por período.
- **CHBORIGEM**: Origem da movimentação (ex: emissão, depósito, compensação, devolução).
- **CHBDESTINO**: Destino da movimentação, pode indicar conta bancária, cliente, etc.
- **Chave composta CCORR**: Vincula a baixa a uma movimentação bancária específica através de 4 campos (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CHEBX Referencia (6 FKs):

#### 1. CHEQUE - Cheques (2 FKs Compostas)
**Relacionamentos:**
```
CHEBX.CHCODIGO → CHEQUE.CHCODIGO (N:1)
CHEBX.EMPCODIGO → CHEQUE.EMPCODIGO (N:1)
Constraint: CHEQUE_CHEBX
```

**Descrição**: Cada baixa está vinculada a um cheque específico através de chave composta (código + empresa).

**Informações da Tabela CHEQUE:**
- **Total:** 14.537 cheques
- **PK:** (CHCODIGO, EMPCODIGO)
- **Colunas:** 26 campos
- **FK Out:** 10 (BANCO, CLIEN, CONTA - 3 FKs, EMPRESA, FUNCIO, LOTECH, CHEQUECUST - 2 FKs)
- **FK In:** 2 tabelas (CHEBX, CHEQUEREC)

**Campos importantes em CHEQUE:**
- `CHNRCHEQUE` - Número do cheque
- `CHDTEMIS` - Data de emissão
- `CHDTVENCTO` - Data de vencimento
- `CHVRCHEQUE` - Valor do cheque
- `CHEMITENTE` - Nome do emitente
- `CHSITUACAO` - Situação do cheque
- `BCOCODIGO` - Banco do cheque
- `CLICODIGO` - Cliente relacionado

**Uso:** Identificar o cheque relacionado a cada baixa, rastrear histórico completo de movimentações de um cheque.

---

#### 2. CCORR - Movimentações de Conta Corrente (4 FKs Compostas)
**Relacionamentos:**
```
CHEBX.BCOCODIGO → CCORR.BCOCODIGO (N:1)
CHEBX.CTANRCONTA → CCORR.CTANRCONTA (N:1)
CHEBX.CCONRLANCTO → CCORR.CCONRLANCTO (N:1)
CHEBX.EMPCCORR → CCORR.EMPCCORR (N:1)
Constraint: CCORR_CHEBX
```

**Descrição**: Cada baixa está vinculada a uma movimentação bancária específica através de chave composta (banco + conta + lançamento + empresa).

**Informações da Tabela CCORR:**
- **Total:** 208.120 movimentações
- **PK:** (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
- **Colunas:** 36 campos
- **FK Out:** 9 (CONTA - 3 FKs, CLIEN, EMPRESA - 2 FKs, HISTO, USUARIO, EXTRATOCONCBCO)
- **FK In:** 52 tabelas (altamente referenciada)

**Campos importantes em CCORR relacionados a cheques:**
- `CCONRCHEQUE` - Número do cheque na movimentação
- `CCOCOMP` - Compensação do cheque
- `CCOEMICHE` - Emissão do cheque
- `CCONOMINAL` - Nome do portador
- `CCODATA` - Data da movimentação
- `CCOVALOR` - Valor da movimentação
- `CCOENTSAI` - Tipo: Entrada (E) ou Saída (S)

**Uso:** Vincular baixas de cheques a movimentações bancárias específicas, rastrear compensação e movimentação de cheques em contas correntes.

---

### CHEBX é Referenciada Por

**Nenhuma tabela** referencia CHEBX diretamente. Esta é uma tabela folha que não possui tabelas dependentes.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CHEQUE → BANCO (Bancos)

**Fluxo:** CHEBX → CHEQUE → BANCO

**Descrição:** Através do relacionamento com CHEQUE, é possível identificar o banco emissor de cada cheque.

**Campos de junção:**
- `CHEBX.CHCODIGO + EMPCODIGO` → `CHEQUE.CHCODIGO + EMPCODIGO` → `CHEQUE.BCOCODIGO` → `BANCO.BCOCODIGO`

**Uso:** Análises de cheques por banco, relatórios de movimentações por banco.

---

### Via CHEQUE → CLIEN (Clientes)

**Fluxo:** CHEBX → CHEQUE → CLIEN

**Descrição:** Através do relacionamento com CHEQUE, é possível identificar o cliente relacionado a cada cheque.

**Campos de junção:**
- `CHEBX.CHCODIGO + EMPCODIGO` → `CHEQUE.CHCODIGO + EMPCODIGO` → `CHEQUE.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de cheques por cliente, relatórios de movimentações por cliente.

---

### Via CHEQUE → CONTA (Contas Bancárias)

**Fluxo:** CHEBX → CHEQUE → CONTA

**Descrição:** Através do relacionamento com CHEQUE, é possível identificar a conta bancária relacionada a cada cheque.

**Campos de junção:**
- `CHEBX.CHCODIGO + EMPCODIGO` → `CHEQUE.CHCODIGO + EMPCODIGO` → `CHEQUE.BCOPORTADOR + CTANRCONTA + EMPCCORR` → `CONTA.BCOCODIGO + CTANRCONTA + EMPCCORR`

**Uso:** Análises de cheques por conta bancária, controle de contas relacionadas.

---

### Via CCORR → CONTA (Contas Bancárias)

**Fluxo:** CHEBX → CCORR → CONTA

**Descrição:** Através do relacionamento com CCORR, é possível identificar a conta bancária onde a movimentação ocorreu.

**Campos de junção:**
- `CHEBX.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CCORR.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CONTA.BCOCODIGO + CTANRCONTA + EMPCCORR`

**Uso:** Análises de movimentações por conta, controle de contas correntes.

---

### Via CCORR → CONTA → BANCO (Bancos)

**Fluxo:** CHEBX → CCORR → CONTA → BANCO

**Descrição:** Através do relacionamento com CCORR e CONTA, é possível identificar o banco onde a movimentação ocorreu.

**Campos de junção:**
- `CHEBX.BCOCODIGO` → `CCORR.BCOCODIGO` → `CONTA.BCOCODIGO` → `BANCO.BCOCODIGO`

**Uso:** Análises de movimentações por banco, relatórios bancários.

---

### Via CCORR → CLIEN (Clientes)

**Fluxo:** CHEBX → CCORR → CLIEN

**Descrição:** Através do relacionamento com CCORR, é possível identificar o cliente relacionado à movimentação bancária.

**Campos de junção:**
- `CHEBX.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de movimentações por cliente, rastreamento de clientes em movimentações bancárias.

---

### Via CCORR → EMPRESA (Empresas)

**Fluxo:** CHEBX → CCORR → EMPRESA

**Descrição:** Através do relacionamento com CCORR, é possível identificar a empresa relacionada à movimentação.

**Campos de junção:**
- `CHEBX.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR.BCOCODIGO + CTANRCONTA + CCONRLANCTO + EMPCCORR` → `CCORR.EMPCODIGO` → `EMPRESA.EMPCODIGO`

**Uso:** Análises de movimentações por empresa, controle multi-empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Baixa de Cheque

**Objetivo:** Obter visão completa de uma baixa incluindo informações do cheque, movimentação bancária e entidades relacionadas.

**Fluxo:**
```
CHEBX (CHCODIGO, EMPCODIGO, CHBSEQ)
  ↓
CHEQUE (CHCODIGO, EMPCODIGO)
  ↓
BANCO (BCOCODIGO)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    chbx.CHCODIGO,
    chbx.EMPCODIGO,
    chbx.CHBSEQ,
    chbx.CHBDATA AS DATA_BAIXA,
    chbx.CHBDESTINO AS DESTINO,
    chbx.CHBORIGEM AS ORIGEM,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHDTEMIS AS DATA_EMISSAO,
    ch.CHDTVENCTO AS DATA_VENCIMENTO,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE,
    b.BCONOME AS BANCO_CHEQUE,
    cc.CCODATA AS DATA_MOVIMENTACAO,
    cc.CCOVALOR AS VALOR_MOVIMENTACAO,
    cc.CCOENTSAI AS TIPO_MOVIMENTACAO,
    cc.CCONRCHEQUE AS NUMERO_CHEQUE_MOV,
    cc.CCOCOMP AS COMPENSACAO,
    c.CTANRCONTA AS CONTA_MOVIMENTACAO,
    cl.CLINOMEFANT AS CLIENTE
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
LEFT JOIN CONTA c ON c.BCOCODIGO = cc.BCOCODIGO
    AND c.CTANRCONTA = cc.CTANRCONTA
    AND c.EMPCCORR = cc.EMPCCORR
LEFT JOIN CLIEN cl ON cl.CLICODIGO = COALESCE(chbx.CLICODIGO, ch.CLICODIGO)
WHERE chbx.CHCODIGO = ?
  AND chbx.EMPCODIGO = ?
ORDER BY chbx.CHBSEQ;
```

---

### Exemplo 2: Análise de Baixas de Cheques por Período

**Objetivo:** Identificar todas as baixas de cheques em um período específico com informações completas.

**Fluxo:**
```
CHEBX (CHBDATA)
  ↓
CHEQUE (CHCODIGO, EMPCODIGO)
  ↓
BANCO (BCOCODIGO)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    chbx.CHBDATA AS DATA_BAIXA,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    chbx.CHBORIGEM AS ORIGEM,
    chbx.CHBDESTINO AS DESTINO,
    b.BCONOME AS BANCO,
    cc.CCODATA AS DATA_MOVIMENTACAO,
    cc.CCOVALOR AS VALOR_MOVIMENTACAO,
    cc.CCOENTSAI AS TIPO_MOVIMENTACAO,
    COUNT(*) OVER (PARTITION BY chbx.CHCODIGO, chbx.EMPCODIGO) AS TOTAL_BAIXAS_CHEQUE
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
WHERE chbx.CHBDATA BETWEEN ? AND ?
ORDER BY chbx.CHBDATA DESC, ch.CHNRCHEQUE;
```

---

### Exemplo 3: Análise de Cheques com Múltiplas Baixas

**Objetivo:** Identificar cheques que tiveram múltiplas baixas e analisar seu histórico completo.

**Fluxo:**
```
CHEQUE (CHCODIGO, EMPCODIGO)
  ↓
CHEBX (CHCODIGO, EMPCODIGO, CHBSEQ)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    MIN(chbx.CHBDATA) AS PRIMEIRA_BAIXA,
    MAX(chbx.CHBDATA) AS ULTIMA_BAIXA,
    STRING_AGG(chbx.CHBORIGEM, ' → ') AS HISTORICO_ORIGENS,
    STRING_AGG(TO_CHAR(chbx.CHBDATA, 'DD/MM/YYYY'), ', ') AS DATAS_BAIXAS
FROM CHEQUE ch
INNER JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHEMITENTE, ch.CHSITUACAO
HAVING COUNT(chbx.CHBSEQ) > 1
ORDER BY TOTAL_BAIXAS DESC, ch.CHCODIGO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Todas as Baixas de um Cheque

**Objetivo:** Obter histórico completo de movimentações de um cheque específico.

```sql
SELECT
    chbx.CHBSEQ AS SEQUENCIA,
    chbx.CHBDATA AS DATA_BAIXA,
    chbx.CHBDESTINO AS DESTINO,
    chbx.CHBORIGEM AS ORIGEM,
    cc.CCODATA AS DATA_MOVIMENTACAO,
    cc.CCOVALOR AS VALOR_MOVIMENTACAO,
    cc.CCOENTSAI AS TIPO_MOVIMENTACAO,
    c.CTANRCONTA AS CONTA,
    b.BCONOME AS BANCO
FROM CHEBX chbx
LEFT JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
LEFT JOIN CONTA c ON c.BCOCODIGO = cc.BCOCODIGO
    AND c.CTANRCONTA = cc.CTANRCONTA
    AND c.EMPCCORR = cc.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
WHERE chbx.CHCODIGO = ?
  AND chbx.EMPCODIGO = ?
ORDER BY chbx.CHBSEQ;
```

---

### 2. Listar Baixas de Cheques por Período

**Objetivo:** Obter todas as baixas de cheques em um período específico.

```sql
SELECT
    chbx.CHBDATA AS DATA_BAIXA,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    chbx.CHBORIGEM AS ORIGEM,
    chbx.CHBDESTINO AS DESTINO,
    b.BCONOME AS BANCO,
    cc.CCOVALOR AS VALOR_MOVIMENTACAO
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
WHERE chbx.CHBDATA BETWEEN ? AND ?
ORDER BY chbx.CHBDATA DESC, ch.CHNRCHEQUE;
```

---

### 3. Análise de Baixas por Origem

**Objetivo:** Identificar distribuição de baixas por tipo de origem.

```sql
SELECT
    chbx.CHBORIGEM AS ORIGEM,
    COUNT(*) AS TOTAL_BAIXAS,
    COUNT(DISTINCT chbx.CHCODIGO) AS TOTAL_CHEQUES,
    SUM(ch.CHVRCHEQUE) AS VALOR_TOTAL,
    AVG(ch.CHVRCHEQUE) AS VALOR_MEDIO,
    MIN(chbx.CHBDATA) AS PRIMEIRA_BAIXA,
    MAX(chbx.CHBDATA) AS ULTIMA_BAIXA
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
GROUP BY chbx.CHBORIGEM
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 4. Relatório de Cheques com Baixas Vinculadas a Movimentações

**Objetivo:** Verificar quais cheques têm baixas vinculadas a movimentações bancárias.

```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    COUNT(CASE WHEN chbx.BCOCODIGO IS NOT NULL THEN 1 END) AS BAIXAS_COM_MOVIMENTACAO,
    COUNT(CASE WHEN chbx.BCOCODIGO IS NULL THEN 1 END) AS BAIXAS_SEM_MOVIMENTACAO
FROM CHEQUE ch
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHSITUACAO
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 5. Análise de Baixas por Banco

**Objetivo:** Identificar distribuição de baixas de cheques por banco.

```sql
SELECT
    b.BCOCODIGO,
    b.BCONOME AS BANCO,
    COUNT(DISTINCT chbx.CHCODIGO) AS TOTAL_CHEQUES,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    SUM(ch.CHVRCHEQUE) AS VALOR_TOTAL,
    AVG(ch.CHVRCHEQUE) AS VALOR_MEDIO
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
INNER JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
GROUP BY b.BCOCODIGO, b.BCONOME
ORDER BY TOTAL_BAIXAS DESC;
```

---

### 6. Relatório de Baixas por Cliente

**Objetivo:** Analisar baixas de cheques agrupadas por cliente.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT chbx.CHCODIGO) AS TOTAL_CHEQUES,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    SUM(ch.CHVRCHEQUE) AS VALOR_TOTAL,
    AVG(ch.CHVRCHEQUE) AS VALOR_MEDIO,
    MIN(chbx.CHBDATA) AS PRIMEIRA_BAIXA,
    MAX(chbx.CHBDATA) AS ULTIMA_BAIXA
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = COALESCE(chbx.CLICODIGO, ch.CLICODIGO)
WHERE cl.CLICODIGO IS NOT NULL
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
ORDER BY VALOR_TOTAL DESC;
```

---

### 7. Verificar Baixas sem Movimentação Bancária Vinculada

**Objetivo:** Identificar baixas de cheques que não estão vinculadas a movimentações bancárias.

```sql
SELECT
    chbx.CHCODIGO,
    chbx.EMPCODIGO,
    chbx.CHBSEQ,
    chbx.CHBDATA AS DATA_BAIXA,
    chbx.CHBORIGEM AS ORIGEM,
    chbx.CHBDESTINO AS DESTINO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
WHERE chbx.BCOCODIGO IS NULL
   OR chbx.CTANRCONTA IS NULL
   OR chbx.CCONRLANCTO IS NULL
   OR chbx.EMPCCORR IS NULL
ORDER BY chbx.CHBDATA DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CHEBX | Tipo |
|--------|-----------|---------------------|------|
| **CHEBX** | 17.782 | 1:1 | **TABELA PRINCIPAL** |
| CHEQUE | 14.537 | 0.82:1 | Cheques (média de 1.22 baixas por cheque) |
| CCORR | 208.120 | 11.7:1 | Movimentações bancárias (média de 1 baixa por 11.7 movimentações) |

**Interpretação:**
- **17.782 baixas** registradas para **14.537 cheques**
- Média de **1.22 baixas por cheque** - alguns cheques têm múltiplas movimentações
- **Nem todas as movimentações bancárias** estão vinculadas a baixas de cheques
- Tabela essencial para rastreamento de movimentações de cheques

**Distribuição Esperada:**
- Cheques com 1 baixa: maioria dos cheques
- Cheques com múltiplas baixas: cheques que passaram por diferentes processos (emissão, depósito, compensação, devolução)

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CHCODIGO, EMPCODIGO, CHBSEQ** | CHEBX | Chave primária composta (PK) |
| **CHCODIGO, EMPCODIGO** | CHEBX → CHEQUE | Referência ao cheque (FK composta) |
| **BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR** | CHEBX → CCORR | Referência à movimentação bancária (FK composta) |
| **CHBDATA** | CHEBX | Data da baixa (indexado para consultas por período) |
| **CHBORIGEM** | CHEBX | Origem da movimentação (classificação) |
| **CHBDESTINO** | CHEBX | Destino da movimentação |

---

## 🚀 Performance e Otimização

### Índices Existentes

**1 índice** está definido na tabela CHEBX:

| Nome do Índice | Colunas | Tipo | Descrição |
|----------------|---------|------|-----------|
| **INDCHBDATA** | CHBDATA | Não único | Índice para consultas por data |

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice composto cheque** - Para buscas por cheque
3. **Índice composto movimentação** - Para buscas por movimentação bancária
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CHEBX

### Índices Sugeridos

```sql
-- Índice 1: Busca por cheque (consultas frequentes)
CREATE INDEX IDX_CHEBX_CHEQUE ON CHEBX(CHCODIGO, EMPCODIGO, CHBSEQ);

-- Índice 2: Busca por movimentação bancária
CREATE INDEX IDX_CHEBX_MOVIMENTACAO ON CHEBX(BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR);

-- Índice 3: Busca por origem (análises por tipo)
CREATE INDEX IDX_CHEBX_ORIGEM ON CHEBX(CHBORIGEM) WHERE CHBORIGEM IS NOT NULL;

-- Índice 4: Busca por período e origem (consultas combinadas)
CREATE INDEX IDX_CHEBX_DATA_ORIGEM ON CHEBX(CHBDATA, CHBORIGEM);
```

### Observações sobre Volume

- **Tabela média** (17.782 registros) - Performance moderada
- **Consultas com JOINs** podem ser otimizadas com índices adequados
- **Índice em CHBDATA** já existe e otimiza consultas por período
- **Focar em índices nas tabelas relacionadas** - CHEQUE e CCORR têm volumes maiores

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK e índice em CHBDATA)
SELECT CHCODIGO, EMPCODIGO, CHBSEQ, CHBDATA, CHBORIGEM
FROM CHEBX
WHERE CHCODIGO = ?
  AND EMPCODIGO = ?
ORDER BY CHBSEQ;

-- ✅ OTIMIZADO (usar índice em CHBDATA)
SELECT CHCODIGO, EMPCODIGO, CHBSEQ, CHBDATA, CHBORIGEM
FROM CHEBX
WHERE CHBDATA BETWEEN ? AND ?
ORDER BY CHBDATA DESC;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT chbx.*, ch.CHNRCHEQUE, ch.CHVRCHEQUE
FROM CHEBX chbx
INNER JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
WHERE chbx.CHBDATA BETWEEN ? AND ?
ORDER BY chbx.CHBDATA DESC;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar baixas sem cheque válido
SELECT chbx.*
FROM CHEBX chbx
LEFT JOIN CHEQUE ch ON ch.CHCODIGO = chbx.CHCODIGO 
    AND ch.EMPCODIGO = chbx.EMPCODIGO
WHERE ch.CHCODIGO IS NULL;

-- Verificar baixas sem movimentação bancária válida (quando campos estão preenchidos)
SELECT chbx.*
FROM CHEBX chbx
WHERE (chbx.BCOCODIGO IS NOT NULL 
    OR chbx.CTANRCONTA IS NOT NULL 
    OR chbx.CCONRLANCTO IS NOT NULL 
    OR chbx.EMPCCORR IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 FROM CCORR cc 
      WHERE cc.BCOCODIGO = chbx.BCOCODIGO
        AND cc.CTANRCONTA = chbx.CTANRCONTA
        AND cc.CCONRLANCTO = chbx.CCONRLANCTO
        AND cc.EMPCCORR = chbx.EMPCCORR
  );
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CHEBX
WHERE CHCODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR CHBSEQ IS NULL
   OR CHBDATA IS NULL
   OR CHBORIGEM IS NULL
   OR CHBORIGEM = '';

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CHCODIGO, EMPCODIGO, CHBSEQ, COUNT(*) AS QTD
FROM CHEBX
GROUP BY CHCODIGO, EMPCODIGO, CHBSEQ
HAVING COUNT(*) > 1;

-- Verificar sequências inválidas (CHBSEQ deve ser >= 1)
SELECT *
FROM CHEBX
WHERE CHBSEQ < 1;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição de baixas por cheque
SELECT
    CASE 
        WHEN total_baixas = 1 THEN '1 baixa'
        WHEN total_baixas BETWEEN 2 AND 3 THEN '2-3 baixas'
        WHEN total_baixas BETWEEN 4 AND 5 THEN '4-5 baixas'
        ELSE '6+ baixas'
    END AS CATEGORIA,
    COUNT(*) AS TOTAL_CHEQUES,
    SUM(total_baixas) AS TOTAL_BAIXAS
FROM (
    SELECT 
        CHCODIGO, 
        EMPCODIGO, 
        COUNT(*) AS total_baixas
    FROM CHEBX
    GROUP BY CHCODIGO, EMPCODIGO
) sub
GROUP BY 
    CASE 
        WHEN total_baixas = 1 THEN '1 baixa'
        WHEN total_baixas BETWEEN 2 AND 3 THEN '2-3 baixas'
        WHEN total_baixas BETWEEN 4 AND 5 THEN '4-5 baixas'
        ELSE '6+ baixas'
    END
ORDER BY CATEGORIA;

-- Verificar distribuição por origem
SELECT
    CHBORIGEM AS ORIGEM,
    COUNT(*) AS TOTAL_BAIXAS,
    COUNT(DISTINCT CHCODIGO) AS TOTAL_CHEQUES,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CHEBX), 0), 2) AS PERCENTUAL
FROM CHEBX
GROUP BY CHBORIGEM
ORDER BY TOTAL_BAIXAS DESC;
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

final class FirebirdChebx extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CHEBX';
    
    protected $primaryKey = ['CHCODIGO', 'EMPCODIGO', 'CHBSEQ'];
    public $incrementing = false;

    protected $casts = [
        'CHCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'CHBSEQ' => 'integer',
        'CHBDATA' => 'date',
        'MDCCODIGO' => 'integer',
        'BCOCODIGO' => 'integer',
        'CTANRCONTA' => 'string',
        'CCONRLANCTO' => 'integer',
        'EMPCCORR' => 'integer',
        'CLICODIGO' => 'integer',
    ];

    // Relacionamento com CHEQUE (chave composta)
    public function cheque(): BelongsTo
    {
        return $this->belongsTo(FirebirdCheque::class, ['CHCODIGO', 'EMPCODIGO'], ['CHCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com CCORR (chave composta)
    public function movimentacao(): BelongsTo
    {
        return $this->belongsTo(FirebirdCcorr::class, [
            'BCOCODIGO', 
            'CTANRCONTA', 
            'CCONRLANCTO', 
            'EMPCCORR'
        ], [
            'BCOCODIGO', 
            'CTANRCONTA', 
            'CCONRLANCTO', 
            'EMPCCORR'
        ]);
    }

    // Relacionamento com CLIEN (se preenchido)
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Scope para filtrar por cheque
    public function scopePorCheque($query, int $chCodigo, int $empCodigo)
    {
        return $query->where('CHCODIGO', $chCodigo)
            ->where('EMPCODIGO', $empCodigo);
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CHBDATA', [$dataInicio, $dataFim]);
    }

    // Scope para filtrar por origem
    public function scopePorOrigem($query, string $origem)
    {
        return $query->where('CHBORIGEM', $origem);
    }

    // Scope para baixas com movimentação bancária
    public function scopeComMovimentacao($query)
    {
        return $query->whereNotNull('BCOCODIGO')
            ->whereNotNull('CTANRCONTA')
            ->whereNotNull('CCONRLANCTO')
            ->whereNotNull('EMPCCORR');
    }

    // Scope para baixas sem movimentação bancária
    public function scopeSemMovimentacao($query)
    {
        return $query->where(function($q) {
            $q->whereNull('BCOCODIGO')
              ->orWhereNull('CTANRCONTA')
              ->orWhereNull('CCONRLANCTO')
              ->orWhereNull('EMPCCORR');
        });
    }

    // Método para verificar se tem movimentação vinculada
    public function temMovimentacaoVinculada(): bool
    {
        return !empty($this->BCOCODIGO) 
            && !empty($this->CTANRCONTA)
            && !empty($this->CCONRLANCTO)
            && !empty($this->EMPCCORR);
    }

    // Método estático para obter total de baixas de um cheque
    public static function totalBaixasPorCheque(int $chCodigo, int $empCodigo): int
    {
        return self::where('CHCODIGO', $chCodigo)
            ->where('EMPCODIGO', $empCodigo)
            ->count();
    }

    // Método estático para obter próxima sequência
    public static function proximaSequencia(int $chCodigo, int $empCodigo): int
    {
        $ultimaSequencia = self::where('CHCODIGO', $chCodigo)
            ->where('EMPCODIGO', $empCodigo)
            ->max('CHBSEQ');
        
        return ($ultimaSequencia ?? 0) + 1;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 3 campos para identificar unicamente
2. **Sequência obrigatória** - CHBSEQ deve ser sequencial por cheque
3. **Validação antes de inserir** - Verificar se cheque existe
4. **Evitar duplicatas** - PK composta garante unicidade

### Performance

1. **Tabela média** - Requer índices adequados para JOINs
2. **Índice em CHBDATA** - Já existe, otimiza consultas por período
3. **Índices compostos** - Recomendados para buscas por cheque e movimentação
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CHEBX

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cheque e movimentação existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Sequência válida** - CHBSEQ deve ser >= 1 e sequencial

### Manutenção

1. **Revisão periódica** - Verificar baixas sem movimentação vinculada
2. **Padronização** - Manter origens consistentes
3. **Documentação** - Documentar tipos de origem utilizados
4. **Backup regular** - Tabela crítica para auditoria financeira

### Regras de Negócio

1. **Sequência obrigatória** - Cada baixa deve ter sequência única por cheque
2. **Validação em tempo real** - Verificar se cheque existe antes de registrar baixa
3. **Consistência** - Movimentação bancária deve existir quando campos estão preenchidos
4. **Histórico completo** - Manter todas as baixas para auditoria

### Observações Especiais

1. **Múltiplas baixas** - Um cheque pode ter várias baixas (emissão, depósito, compensação, etc.)
2. **Movimentação opcional** - Nem todas as baixas precisam estar vinculadas a CCORR
3. **Rastreabilidade** - Campo CHBORIGEM permite rastrear tipo de movimentação
4. **Auditoria** - Tabela essencial para auditoria de movimentações de cheques

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

