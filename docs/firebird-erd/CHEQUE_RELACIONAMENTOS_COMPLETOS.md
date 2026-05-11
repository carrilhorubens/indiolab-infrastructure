# CHEQUE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CHEQUE (Cheques)
- **Total de Registros**: 14.537
- **Total de Colunas**: 26
- **Chave Primária**: (CHCODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 10
- **Índices**: 0
- **Tabelas Dependentes**: 2 (Diretas) + Relacionamentos Lógicos
- **Banco de Dados**: Firebird

## 📝 Descrição

**CHEQUE** é uma tabela central que armazena informações completas sobre cheques no sistema. Com **14.537 registros**, representa todos os cheques cadastrados, incluindo cheques emitidos, recebidos, em custódia e em diferentes situações.

Esta tabela funciona como **cadastro mestre de cheques** e permite:
- Cadastrar cheques emitidos e recebidos
- Controlar situação e status de cada cheque
- Rastrear datas de emissão e vencimento
- Vincular cheques a bancos, contas e clientes
- Gerenciar cheques em custódia
- Controlar lotes de cheques
- Integrar com sistema de conta corrente
- Rastrear histórico completo de movimentações

Cada registro representa um cheque específico, contendo:
- Identificação única (CHCODIGO + EMPCODIGO)
- Informações do cheque (número, agência, conta)
- Datas importantes (emissão, vencimento, cadastro)
- Valor e emitente
- Situação atual do cheque
- Relacionamentos com banco, conta, cliente, funcionário
- Informações de custódia e lote
- Histórico e origem

O sistema utiliza esta tabela como base para todos os processos relacionados a cheques, desde o cadastro inicial até a compensação e baixa, permitindo controle financeiro completo e auditoria detalhada.

**Observação Importante:** CHEQUE suporta múltiplos relacionamentos com contas bancárias (BCOPORTADOR, CTANRCONTA/EMPCCORR) e permite rastreamento completo através de CHEBX (baixas) e CHEQUEREC (recebimentos).

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHCODIGO** 🔑 | INTEGER | ✓ | Código único do cheque (PK) |
| **EMPCODIGO** 🔑🔗 | INTEGER | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Informações do Cheque
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHNRCHEQUE** | VARCHAR(14) | ✓ | Número do cheque |
| **CHAGENCIA** | VARCHAR(37) | | Agência do cheque |
| **CHNRCONTA** | VARCHAR(37) | | Número da conta do cheque |
| **CHDIGNRCH** | VARCHAR(14) | | Dígito verificador do número do cheque |

### Datas Importantes
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHDTEMIS** | DATE | ✓ | Data de emissão do cheque |
| **CHDTVENCTO** | DATE | ✓ | Data de vencimento do cheque |
| **CHDTCAD** | DATE | ✓ | Data de cadastro no sistema |
| **DTENVIOCUST** | DATE | | Data de envio para custódia |

### Valores e Emitente
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHVRCHEQUE** | NUMERIC(27,2) | ✓ | Valor do cheque |
| **CHEMITENTE** | VARCHAR(37) | ✓ | Nome do emitente do cheque |

### Situação e Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHSITUACAO** | VARCHAR(14) | ✓ | Situação atual do cheque |
| **CHORIGEM** | VARCHAR(14) | ✓ | Origem do cheque |
| **CHHISTORICO** | VARCHAR(37) | | Histórico/observações do cheque |
| **CUSTODIA** | VARCHAR(14) | | Indica se está em custódia |

### Relacionamentos com Banco e Conta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **BCOCODIGO** 🔗 | INTEGER | ✓ | Código do banco emissor (FK → BANCO) |
| **BCOPORTADOR** 🔗 | INTEGER | ✓ | Banco portador (FK → CONTA.BCOCODIGO) |
| **CTANRCONTA** 🔗 | VARCHAR(37) | ✓ | Número da conta (FK → CONTA) |
| **EMPCCORR** 🔗 | INTEGER | ✓ | Empresa correntista (FK → CONTA) |

### Relacionamentos com Entidades
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔗 | INTEGER | | Código do cliente (FK → CLIEN) |
| **FUNCODIGO** 🔗 | INTEGER | | Código do funcionário (FK → FUNCIO) |

### Relacionamentos com Lote e Custódia
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_LOTECH** 🔗 | INTEGER | | ID do lote de cheques (FK → LOTECH) |
| **BCOCODIGOCUST** 🔗 | INTEGER | | Código do banco de custódia (FK → CHEQUECUST) |
| **COBCODIGOCUST** 🔗 | VARCHAR(37) | | Código do cobrador de custódia (FK → CHEQUECUST) |
| **BCONOMECUST** | VARCHAR(37) | | Nome do banco de custódia |

**Primary Key:** (CHCODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **CHSITUACAO**: Controla o estado atual do cheque (ex: Emitido, Compensado, Devolvido, Cancelado).
- **CHORIGEM**: Indica a origem do cheque (ex: Recebido, Emitido, Terceiros).
- **CUSTODIA**: Flag que indica se o cheque está em custódia de terceiros.
- **Múltiplas contas**: CHEQUE pode referenciar diferentes contas através de BCOPORTADOR e CTANRCONTA/EMPCCORR.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CHEQUE Referencia (10 FKs):

#### 1. EMPRESA - Empresas
**Relacionamento:**
```
CHEQUE.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_CHEQUE
```

**Descrição**: Cada cheque está vinculado a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** Variável (múltiplas empresas)
- **PK:** EMPCODIGO
- **Colunas:** Múltiplos campos
- **FK Out:** Variável
- **FK In:** Muitas tabelas

**Uso:** Controle multi-empresa, identificação da empresa proprietária do cheque.

---

#### 2. BANCO - Bancos
**Relacionamento:**
```
CHEQUE.BCOCODIGO → BANCO.BCOCODIGO (N:1)
Constraint: BANCO_CHEQUE
```

**Descrição**: Cada cheque está vinculado ao banco emissor.

**Informações da Tabela BANCO:**
- **Total:** 109 bancos
- **PK:** BCOCODIGO
- **Colunas:** 4 campos
- **FK Out:** 0
- **FK In:** 28 tabelas

**Campos importantes em BANCO:**
- `BCONOME` - Nome do banco
- `BCOCODIGO` - Código do banco (FEBRABAN)

**Uso:** Identificar o banco emissor do cheque, relatórios por banco.

---

#### 3. CLIEN - Clientes
**Relacionamento:**
```
CHEQUE.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CHEQUE
```

**Descrição**: Cheques podem estar vinculados a clientes específicos (opcional).

**Informações da Tabela CLIEN:**
- **Total:** Variável (muitos clientes)
- **PK:** CLICODIGO
- **Colunas:** Múltiplos campos
- **FK Out:** Variável
- **FK In:** Muitas tabelas

**Uso:** Rastrear cheques por cliente, relatórios de recebimentos por cliente.

---

#### 4. CONTA - Contas Bancárias (3 FKs)

**4.1. BCOPORTADOR - Banco Portador**
```
CHEQUE.BCOPORTADOR → CONTA.BCOCODIGO (N:1)
Constraint: CONTA_CHEQUE
```

**4.2. CTANRCONTA + EMPCCORR - Conta Corrente**
```
CHEQUE.CTANRCONTA → CONTA.CTANRCONTA (N:1)
CHEQUE.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_CHEQUE
```

**Descrição**: CHEQUE pode referenciar múltiplas contas bancárias (portador e conta corrente).

**Informações da Tabela CONTA:**
- **Total:** 55 contas
- **PK:** (BCOCODIGO, CTANRCONTA, EMPCCORR)
- **Colunas:** 19 campos
- **FK Out:** 1 (BANCO)
- **FK In:** 27 tabelas

**Uso:** Identificar contas relacionadas ao cheque, controle de contas correntes.

---

#### 5. FUNCIO - Funcionários
**Relacionamento:**
```
CHEQUE.FUNCODIGO → FUNCIO.FUNCODIGO (N:1)
Constraint: FUNCIO_CHEQUE
```

**Descrição**: Cheques podem estar vinculados a funcionários específicos (opcional).

**Informações da Tabela FUNCIO:**
- **Total:** 435 funcionários
- **PK:** FUNCODIGO
- **Colunas:** 74 campos
- **FK Out:** 6
- **FK In:** 23 tabelas

**Uso:** Rastrear cheques por funcionário, controle de responsáveis.

---

#### 6. LOTECH - Lotes de Cheques
**Relacionamento:**
```
CHEQUE.ID_LOTECH → LOTECH.ID_LOTECH (N:1)
Constraint: LOTECH_CHEQUE
```

**Descrição**: Cheques podem estar agrupados em lotes para processamento em lote.

**Informações da Tabela LOTECH:**
- **Total:** 7.330 lotes
- **PK:** ID_LOTECH
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 5 tabelas

**Campos importantes em LOTECH:**
- `LTDATA` - Data do lote
- `LTVALOR` - Valor total do lote
- `LTSITUACAO` - Situação do lote
- `LTTIPO` - Tipo do lote

**Uso:** Processamento em lote de cheques, controle de remessas.

---

#### 7. CHEQUECUST - Cheques em Custódia (2 FKs Compostas)
**Relacionamentos:**
```
CHEQUE.BCOCODIGOCUST → CHEQUECUST.BCOCODIGOCUST (N:1)
CHEQUE.COBCODIGOCUST → CHEQUECUST.COBCODIGOCUST (N:1)
Constraint: CHEQUECUST_CHEQUE
```

**Descrição**: Cheques em custódia estão vinculados a informações de custódia específicas.

**Informações da Tabela CHEQUECUST:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (BCOCODIGOCUST, COBCODIGOCUST)
- **Colunas:** 11 campos
- **FK Out:** 3 (CONTA - 3 FKs compostas)
- **FK In:** 1 tabela (CHEQUE)

**Campos importantes em CHEQUECUST:**
- `BCONOMECUST` - Nome do banco de custódia
- `BCOAGENCIACUST` - Agência de custódia
- `BCOCONTACUST` - Conta de custódia
- `BCONRCOMPENS` - Número de compensação

**Uso:** Gerenciar cheques em custódia de terceiros, controle de repasse.

---

### CHEQUE é Referenciada Por (2 FKs Diretas):

#### 1. CHEBX - Baixas de Cheques
**Relacionamentos:**
```
CHEBX.CHCODIGO → CHEQUE.CHCODIGO (N:1)
CHEBX.EMPCODIGO → CHEQUE.EMPCODIGO (N:1)
Constraint: CHEQUE_CHEBX
```

**Descrição**: Cada cheque pode ter múltiplas baixas (movimentações) registradas.

**Informações da Tabela CHEBX:**
- **Total:** 17.782 baixas
- **PK:** (CHCODIGO, EMPCODIGO, CHBSEQ)
- **Colunas:** 12 campos
- **FK Out:** 6 (CHEQUE - 2 FKs compostas, CCORR - 4 FKs compostas)

**Uso:** Rastrear histórico completo de movimentações de cada cheque.

---

#### 2. CHEQUEREC - Recebimentos de Cheques
**Relacionamentos:**
```
CHEQUEREC.CHCODIGO → CHEQUE.CHCODIGO (N:1)
CHEQUEREC.EMPCODIGO → CHEQUE.EMPCODIGO (N:1)
Constraint: CHEQUE_CHEQUEREC
```

**Descrição**: Cheques podem ter múltiplos recebimentos vinculados (opcional).

**Informações da Tabela CHEQUEREC:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (EMPCODIGO, CHCODIGO, CHRSEQ)
- **Colunas:** 8 campos
- **FK Out:** 2 (CHEQUE - 2 FKs compostas)

**Campos importantes em CHEQUEREC:**
- `CHRORIGDOC` - Origem do documento
- `CHRNRDOC` - Número do documento
- `CHRDTDOC` - Data do documento
- `CHRVALOR` - Valor do recebimento

**Uso:** Rastrear recebimentos relacionados a cheques específicos.

---

### Relacionamentos Lógicos (Sem FK Direta):

#### 3. PAGBX - Baixas de Pagamento (Lógico)
**Relacionamento Lógico:**
```
PAGBX.PABNRCHEQUE = CHEQUE.CHNRCHEQUE (Lógico)
```

**Descrição**: Baixas de pagamento podem referenciar cheques através do número do cheque.

**Informações da Tabela PAGBX:**
- **Total:** 138.447 baixas
- **PK:** (PAGCODIGO, PABCONTADOR, EMPCODIGO)
- **Colunas:** 19 campos
- **FK Out:** 8 (PAGAR - 2 FKs, BANCO, CCORR - 4 FKs compostas, USUARIO)

**Campos importantes em PAGBX:**
- `PABNRCHEQUE` - Número do cheque utilizado no pagamento
- `PABDTPAGTO` - Data do pagamento
- `PABDTLIQ` - Data de liquidação
- `PABVALOR` - Valor pago

**Uso:** Rastrear pagamentos efetuados com cheques, análise de fluxo de caixa.

---

#### 4. CCORR - Movimentações de Conta Corrente (Lógico)
**Relacionamento Lógico:**
```
CCORR.CCONRCHEQUE = CHEQUE.CHNRCHEQUE (Lógico)
```

**Descrição**: Movimentações bancárias podem referenciar cheques através do número do cheque.

**Informações da Tabela CCORR:**
- **Total:** 208.120 movimentações
- **PK:** (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
- **Colunas:** 36 campos
- **FK Out:** 9
- **FK In:** 52 tabelas

**Campos importantes em CCORR relacionados a cheques:**
- `CCONRCHEQUE` - Número do cheque na movimentação
- `CCOCOMP` - Compensação do cheque
- `CCOEMICHE` - Emissão do cheque
- `CCONOMINAL` - Nome do portador

**Uso:** Rastrear movimentações bancárias relacionadas a cheques específicos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CHEBX → CCORR → CONTA (Contas Bancárias)

**Fluxo:** CHEQUE → CHEBX → CCORR → CONTA

**Descrição:** Através das baixas de cheques, é possível identificar as contas bancárias onde os cheques foram movimentados.

**Campos de junção:**
- `CHEQUE.CHCODIGO + EMPCODIGO` → `CHEBX.CHCODIGO + EMPCODIGO` → `CHEBX.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CCORR.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CONTA.BCOCODIGO + CTANRCONTA + EMPCCORR`

**Uso:** Análises de movimentações de cheques por conta bancária.

---

### Via CHEBX → CCORR → CONTA → BANCO (Bancos)

**Fluxo:** CHEQUE → CHEBX → CCORR → CONTA → BANCO

**Descrição:** Através das baixas e movimentações, é possível identificar os bancos relacionados às movimentações dos cheques.

**Uso:** Análises de movimentações de cheques por banco.

---

### Via CHEBX → CCORR → CLIEN (Clientes)

**Fluxo:** CHEQUE → CHEBX → CCORR → CLIEN

**Descrição:** Através das movimentações bancárias, é possível identificar clientes relacionados às movimentações dos cheques.

**Uso:** Análises de movimentações de cheques por cliente.

---

### Via CHEQUE → FUNCIO → USUARIO (Usuários)

**Fluxo:** CHEQUE → FUNCIO → USUARIO

**Descrição:** Através do funcionário relacionado ao cheque, é possível identificar usuários do sistema.

**Uso:** Rastreabilidade de cheques por usuário responsável.

---

### Via CHEQUE → LOTECH → LOTECHCCORR (Movimentações de Lote)

**Fluxo:** CHEQUE → LOTECH → LOTECHCCORR

**Descrição:** Cheques em lotes podem ter movimentações bancárias relacionadas ao lote.

**Uso:** Processamento em lote de cheques, controle de remessas.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Cheque

**Objetivo:** Obter visão completa de um cheque incluindo todas as baixas, movimentações bancárias e entidades relacionadas.

**Fluxo:**
```
CHEQUE (CHCODIGO, EMPCODIGO)
  ↓
CHEBX (CHCODIGO, EMPCODIGO)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHDTEMIS AS DATA_EMISSAO,
    ch.CHDTVENCTO AS DATA_VENCIMENTO,
    ch.CHSITUACAO AS SITUACAO,
    b.BCONOME AS BANCO_EMISSOR,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    STRING_AGG(TO_CHAR(chbx.CHBDATA, 'DD/MM/YYYY'), ', ') AS DATAS_BAIXAS,
    SUM(cc.CCOVALOR) AS VALOR_TOTAL_MOVIMENTACOES
FROM CHEQUE ch
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ch.CLICODIGO
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
LEFT JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
WHERE ch.CHCODIGO = ?
  AND ch.EMPCODIGO = ?
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHEMITENTE, 
    ch.CHDTEMIS, ch.CHDTVENCTO, ch.CHSITUACAO, b.BCONOME, cl.CLINOMEFANT;
```

---

### Exemplo 2: Análise de Cheques por Banco e Período

**Objetivo:** Identificar todos os cheques de um banco em um período específico com informações de movimentações.

**Fluxo:**
```
BANCO (BCOCODIGO)
  ↓
CHEQUE (BCOCODIGO)
  ↓
CHEBX (CHCODIGO, EMPCODIGO)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    b.BCONOME AS BANCO,
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHDTEMIS AS DATA_EMISSAO,
    ch.CHDTVENCTO AS DATA_VENCIMENTO,
    ch.CHSITUACAO AS SITUACAO,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    MIN(chbx.CHBDATA) AS PRIMEIRA_BAIXA,
    MAX(chbx.CHBDATA) AS ULTIMA_BAIXA
FROM BANCO b
INNER JOIN CHEQUE ch ON ch.BCOCODIGO = b.BCOCODIGO
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
WHERE b.BCOCODIGO = ?
  AND ch.CHDTEMIS BETWEEN ? AND ?
GROUP BY b.BCONOME, ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, 
    ch.CHEMITENTE, ch.CHDTEMIS, ch.CHDTVENCTO, ch.CHSITUACAO
ORDER BY ch.CHDTEMIS DESC;
```

---

### Exemplo 3: Análise de Cheques com Pagamentos Vinculados

**Objetivo:** Identificar cheques que foram utilizados em pagamentos através do número do cheque.

**Fluxo:**
```
CHEQUE (CHNRCHEQUE)
  ↓
PAGBX (PABNRCHEQUE) [Lógico]
  ↓
PAGAR (PAGCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE,
    COUNT(DISTINCT pb.PAGCODIGO) AS TOTAL_PAGAMENTOS,
    SUM(pb.PABVALOR) AS VALOR_TOTAL_PAGAMENTOS,
    MIN(pb.PABDTPAGTO) AS PRIMEIRO_PAGAMENTO,
    MAX(pb.PABDTPAGTO) AS ULTIMO_PAGAMENTO
FROM CHEQUE ch
LEFT JOIN PAGBX pb ON pb.PABNRCHEQUE = ch.CHNRCHEQUE
    AND pb.EMPCODIGO = ch.EMPCODIGO
WHERE ch.EMPCODIGO = ?
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHEMITENTE, ch.CHSITUACAO
HAVING COUNT(DISTINCT pb.PAGCODIGO) > 0
ORDER BY VALOR_TOTAL_PAGAMENTOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Cheque Completo

**Objetivo:** Obter todas as informações de um cheque específico.

```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHAGENCIA AS AGENCIA,
    ch.CHNRCONTA AS CONTA,
    ch.CHDTEMIS AS DATA_EMISSAO,
    ch.CHDTVENCTO AS DATA_VENCIMENTO,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHSITUACAO AS SITUACAO,
    ch.CHORIGEM AS ORIGEM,
    ch.CHHISTORICO AS HISTORICO,
    b.BCONOME AS BANCO,
    cl.CLINOMEFANT AS CLIENTE,
    f.FUNNOME AS FUNCIONARIO,
    lt.LTDATA AS DATA_LOTE,
    lt.LTSITUACAO AS SITUACAO_LOTE
FROM CHEQUE ch
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ch.CLICODIGO
LEFT JOIN FUNCIO f ON f.FUNCODIGO = ch.FUNCODIGO
LEFT JOIN LOTECH lt ON lt.ID_LOTECH = ch.ID_LOTECH
WHERE ch.CHCODIGO = ?
  AND ch.EMPCODIGO = ?;
```

---

### 2. Listar Cheques por Situação

**Objetivo:** Obter todos os cheques de uma situação específica.

```sql
SELECT
    CHCODIGO,
    CHNRCHEQUE AS NUMERO_CHEQUE,
    CHVRCHEQUE AS VALOR_CHEQUE,
    CHEMITENTE AS EMITENTE,
    CHDTEMIS AS DATA_EMISSAO,
    CHDTVENCTO AS DATA_VENCIMENTO,
    CHSITUACAO AS SITUACAO
FROM CHEQUE
WHERE EMPCODIGO = ?
  AND CHSITUACAO = ?
ORDER BY CHDTVENCTO, CHNRCHEQUE;
```

---

### 3. Análise de Cheques por Cliente

**Objetivo:** Identificar todos os cheques relacionados a um cliente específico.

```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHDTEMIS AS DATA_EMISSAO,
    ch.CHDTVENCTO AS DATA_VENCIMENTO,
    ch.CHSITUACAO AS SITUACAO,
    b.BCONOME AS BANCO,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS
FROM CHEQUE ch
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
WHERE ch.CLICODIGO = ?
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHEMITENTE, 
    ch.CHDTEMIS, ch.CHDTVENCTO, ch.CHSITUACAO, b.BCONOME
ORDER BY ch.CHDTVENCTO DESC;
```

---

### 4. Relatório de Cheques por Banco e Período

**Objetivo:** Analisar cheques agrupados por banco e período.

```sql
SELECT
    b.BCOCODIGO,
    b.BCONOME AS BANCO,
    COUNT(DISTINCT ch.CHCODIGO) AS TOTAL_CHEQUES,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    SUM(ch.CHVRCHEQUE) AS VALOR_TOTAL,
    AVG(ch.CHVRCHEQUE) AS VALOR_MEDIO,
    MIN(ch.CHDTEMIS) AS PRIMEIRA_EMISSAO,
    MAX(ch.CHDTEMIS) AS ULTIMA_EMISSAO
FROM BANCO b
INNER JOIN CHEQUE ch ON ch.BCOCODIGO = b.BCOCODIGO
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
WHERE ch.CHDTEMIS BETWEEN ? AND ?
GROUP BY b.BCOCODIGO, b.BCONOME
ORDER BY VALOR_TOTAL DESC;
```

---

### 5. Análise de Cheques em Custódia

**Objetivo:** Identificar cheques que estão em custódia com informações completas.

```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHEMITENTE AS EMITENTE,
    ch.CHSITUACAO AS SITUACAO,
    ch.CUSTODIA AS CUSTODIA,
    ch.BCONOMECUST AS BANCO_CUSTODIA,
    ch.DTENVIOCUST AS DATA_ENVIO_CUSTODIA,
    cc.BCOAGENCIACUST AS AGENCIA_CUSTODIA,
    cc.BCOCONTACUST AS CONTA_CUSTODIA,
    cc.BCONRCOMPENS AS NUMERO_COMPENSACAO
FROM CHEQUE ch
LEFT JOIN CHEQUECUST cc ON cc.BCOCODIGOCUST = ch.BCOCODIGOCUST
    AND cc.COBCODIGOCUST = ch.COBCODIGOCUST
WHERE ch.CUSTODIA = 'S'
  OR ch.BCOCODIGOCUST IS NOT NULL
ORDER BY ch.DTENVIOCUST DESC;
```

---

### 6. Relatório de Cheques por Lote

**Objetivo:** Analisar cheques agrupados por lote.

```sql
SELECT
    lt.ID_LOTECH,
    lt.LTDATA AS DATA_LOTE,
    lt.LTVALOR AS VALOR_LOTE,
    lt.LTSITUACAO AS SITUACAO_LOTE,
    lt.LTTIPO AS TIPO_LOTE,
    COUNT(DISTINCT ch.CHCODIGO) AS TOTAL_CHEQUES,
    SUM(ch.CHVRCHEQUE) AS VALOR_TOTAL_CHEQUES,
    AVG(ch.CHVRCHEQUE) AS VALOR_MEDIO_CHEQUE,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS
FROM LOTECH lt
INNER JOIN CHEQUE ch ON ch.ID_LOTECH = lt.ID_LOTECH
LEFT JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
GROUP BY lt.ID_LOTECH, lt.LTDATA, lt.LTVALOR, lt.LTSITUACAO, lt.LTTIPO
ORDER BY lt.LTDATA DESC;
```

---

### 7. Verificar Cheques com Movimentações Bancárias

**Objetivo:** Identificar cheques que têm movimentações bancárias vinculadas através de CHEBX.

```sql
SELECT
    ch.CHCODIGO,
    ch.CHNRCHEQUE AS NUMERO_CHEQUE,
    ch.CHVRCHEQUE AS VALOR_CHEQUE,
    ch.CHSITUACAO AS SITUACAO_CHEQUE,
    COUNT(chbx.CHBSEQ) AS TOTAL_BAIXAS,
    COUNT(DISTINCT cc.CCONRLANCTO) AS TOTAL_MOVIMENTACOES,
    SUM(cc.CCOVALOR) AS VALOR_TOTAL_MOVIMENTACOES,
    MIN(cc.CCODATA) AS PRIMEIRA_MOVIMENTACAO,
    MAX(cc.CCODATA) AS ULTIMA_MOVIMENTACAO
FROM CHEQUE ch
INNER JOIN CHEBX chbx ON chbx.CHCODIGO = ch.CHCODIGO 
    AND chbx.EMPCODIGO = ch.EMPCODIGO
INNER JOIN CCORR cc ON cc.BCOCODIGO = chbx.BCOCODIGO
    AND cc.CTANRCONTA = chbx.CTANRCONTA
    AND cc.CCONRLANCTO = chbx.CCONRLANCTO
    AND cc.EMPCCORR = chbx.EMPCCORR
WHERE ch.EMPCODIGO = ?
GROUP BY ch.CHCODIGO, ch.CHNRCHEQUE, ch.CHVRCHEQUE, ch.CHSITUACAO
ORDER BY VALOR_TOTAL_MOVIMENTACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CHEQUE | Tipo |
|--------|-----------|---------------------|------|
| **CHEQUE** | 14.537 | 1:1 | **TABELA PRINCIPAL** |
| CHEBX | 17.782 | 1.22:1 | Baixas (média de 1.22 baixas por cheque) |
| CHEQUEREC | 0 | 0:1 | Recebimentos (não utilizado) |
| LOTECH | 7.330 | 0.5:1 | Lotes (média de 0.5 lotes por cheque) |
| PAGBX | 138.447 | 9.5:1 | Pagamentos (relação lógica via número) |

**Interpretação:**
- **14.537 cheques** cadastrados no sistema
- **Média de 1.22 baixas por cheque** - alguns cheques têm múltiplas movimentações
- **Cheques agrupados em lotes** - aproximadamente metade dos cheques estão em lotes
- **Relação lógica com pagamentos** - muitos pagamentos podem referenciar cheques através do número

**Distribuição Esperada:**
- Cheques com 1 baixa: maioria dos cheques
- Cheques com múltiplas baixas: cheques que passaram por diferentes processos
- Cheques em lotes: processamento em lote de remessas

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CHCODIGO, EMPCODIGO** | CHEQUE | Chave primária composta (PK) |
| **CHCODIGO, EMPCODIGO** | [2 tabelas] → CHEQUE | Referência ao cheque (FK composta) |
| **CHNRCHEQUE** | CHEQUE | Número do cheque (relação lógica com PAGBX, CCORR) |
| **BCOCODIGO** | CHEQUE → BANCO | Banco emissor do cheque |
| **CLICODIGO** | CHEQUE → CLIEN | Cliente relacionado ao cheque |
| **ID_LOTECH** | CHEQUE → LOTECH | Lote do cheque |
| **BCOCODIGOCUST, COBCODIGOCUST** | CHEQUE → CHEQUECUST | Custódia do cheque |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CHEQUE.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por banco** - Para buscas por banco emissor
3. **Índice por número do cheque** - Para relações lógicas com PAGBX e CCORR
4. **Índice por situação** - Para filtros por situação
5. **Índice por datas** - Para consultas por período
6. **Índices nas tabelas relacionadas** - Mais críticos que índices em CHEQUE

### Índices Sugeridos

```sql
-- Índice 1: Busca por banco (consultas frequentes)
CREATE INDEX IDX_CHEQUE_BANCO ON CHEQUE(BCOCODIGO);

-- Índice 2: Busca por número do cheque (relações lógicas)
CREATE INDEX IDX_CHEQUE_NUMERO ON CHEQUE(CHNRCHEQUE);

-- Índice 3: Busca por situação (filtros comuns)
CREATE INDEX IDX_CHEQUE_SITUACAO ON CHEQUE(CHSITUACAO);

-- Índice 4: Busca por data de emissão (consultas por período)
CREATE INDEX IDX_CHEQUE_DATA_EMISSAO ON CHEQUE(CHDTEMIS);

-- Índice 5: Busca por data de vencimento (controle de vencimentos)
CREATE INDEX IDX_CHEQUE_DATA_VENCIMENTO ON CHEQUE(CHDTVENCTO);

-- Índice 6: Busca por cliente (relatórios por cliente)
CREATE INDEX IDX_CHEQUE_CLIENTE ON CHEQUE(CLICODIGO) WHERE CLICODIGO IS NOT NULL;

-- Índice 7: Busca por lote (processamento em lote)
CREATE INDEX IDX_CHEQUE_LOTE ON CHEQUE(ID_LOTECH) WHERE ID_LOTECH IS NOT NULL;

-- Índice 8: Busca composta por empresa e situação
CREATE INDEX IDX_CHEQUE_EMP_SITUACAO ON CHEQUE(EMPCODIGO, CHSITUACAO);
```

### Observações sobre Volume

- **Tabela média** (14.537 registros) - Performance moderada
- **Consultas com JOINs** podem ser otimizadas com índices adequados
- **Relações lógicas** (PAGBX, CCORR) requerem índices em CHNRCHEQUE
- **Focar em índices nas tabelas relacionadas** - CHEBX e CCORR têm volumes maiores

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK)
SELECT CHCODIGO, CHNRCHEQUE, CHVRCHEQUE, CHSITUACAO
FROM CHEQUE
WHERE CHCODIGO = ?
  AND EMPCODIGO = ?;

-- ✅ OTIMIZADO (usar índice em BCOCODIGO)
SELECT CHCODIGO, CHNRCHEQUE, CHVRCHEQUE
FROM CHEQUE
WHERE BCOCODIGO = ?
ORDER BY CHDTEMIS DESC;

-- ✅ OTIMIZADO (usar índice em CHNRCHEQUE para relação lógica)
SELECT ch.*
FROM CHEQUE ch
INNER JOIN PAGBX pb ON pb.PABNRCHEQUE = ch.CHNRCHEQUE
WHERE ch.CHNRCHEQUE = ?;

-- ✅ OTIMIZADO (usar índice em CHDTVENCTO)
SELECT CHCODIGO, CHNRCHEQUE, CHVRCHEQUE, CHDTVENCTO
FROM CHEQUE
WHERE CHDTVENCTO BETWEEN ? AND ?
ORDER BY CHDTVENCTO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar cheques sem banco válido
SELECT ch.*
FROM CHEQUE ch
LEFT JOIN BANCO b ON b.BCOCODIGO = ch.BCOCODIGO
WHERE ch.BCOCODIGO IS NOT NULL
  AND b.BCOCODIGO IS NULL;

-- Verificar cheques sem conta válida (quando campos estão preenchidos)
SELECT ch.*
FROM CHEQUE ch
WHERE (ch.CTANRCONTA IS NOT NULL OR ch.EMPCCORR IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 FROM CONTA c 
      WHERE c.CTANRCONTA = ch.CTANRCONTA
        AND c.EMPCCORR = ch.EMPCCORR
  );

-- Verificar cheques sem empresa válida
SELECT ch.*
FROM CHEQUE ch
LEFT JOIN EMPRESA e ON e.EMPCODIGO = ch.EMPCODIGO
WHERE e.EMPCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CHEQUE
WHERE CHCODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR CHNRCHEQUE IS NULL
   OR CHNRCHEQUE = ''
   OR CHDTEMIS IS NULL
   OR CHDTVENCTO IS NULL
   OR CHVRCHEQUE IS NULL
   OR CHEMITENTE IS NULL
   OR CHEMITENTE = ''
   OR CHSITUACAO IS NULL
   OR CHSITUACAO = ''
   OR CHORIGEM IS NULL
   OR CHORIGEM = ''
   OR CHDTCAD IS NULL
   OR BCOCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CHCODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM CHEQUE
GROUP BY CHCODIGO, EMPCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos
SELECT *
FROM CHEQUE
WHERE CHVRCHEQUE < 0
   OR CHDTVENCTO < CHDTEMIS
   OR CHDTCAD < CHDTEMIS;

-- Verificar números de cheque duplicados na mesma empresa
SELECT EMPCODIGO, CHNRCHEQUE, COUNT(*) AS QTD
FROM CHEQUE
GROUP BY EMPCODIGO, CHNRCHEQUE
HAVING COUNT(*) > 1;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por situação
SELECT
    CHSITUACAO AS SITUACAO,
    COUNT(*) AS TOTAL_CHEQUES,
    SUM(CHVRCHEQUE) AS VALOR_TOTAL,
    AVG(CHVRCHEQUE) AS VALOR_MEDIO,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CHEQUE), 0), 2) AS PERCENTUAL
FROM CHEQUE
GROUP BY CHSITUACAO
ORDER BY TOTAL_CHEQUES DESC;

-- Verificar distribuição por origem
SELECT
    CHORIGEM AS ORIGEM,
    COUNT(*) AS TOTAL_CHEQUES,
    SUM(CHVRCHEQUE) AS VALOR_TOTAL,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CHEQUE), 0), 2) AS PERCENTUAL
FROM CHEQUE
GROUP BY CHORIGEM
ORDER BY TOTAL_CHEQUES DESC;

-- Verificar cheques vencidos
SELECT
    COUNT(*) AS TOTAL_VENCIDOS,
    SUM(CHVRCHEQUE) AS VALOR_TOTAL_VENCIDOS,
    AVG(CHVRCHEQUE) AS VALOR_MEDIO_VENCIDOS
FROM CHEQUE
WHERE CHDTVENCTO < CURRENT_DATE
  AND CHSITUACAO NOT IN ('Compensado', 'Cancelado');
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Existente

O modelo `FirebirdCheque` já existe em `app/Models/Firebird/FirebirdCheque.php` e inclui estrutura básica.

**Melhorias Sugeridas:**

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCheque extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CHEQUE';
    
    protected $primaryKey = ['EMPCODIGO', 'CHCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'EMPCODIGO' => 'integer',
        'CHCODIGO' => 'integer',
        'BCOCODIGO' => 'integer',
        'CLICODIGO' => 'integer',
        'FUNCODIGO' => 'integer',
        'BCOPORTADOR' => 'integer',
        'EMPCCORR' => 'integer',
        'ID_LOTECH' => 'integer',
        'BCOCODIGOCUST' => 'integer',
        'CHNRCHEQUE' => 'string',
        'CHAGENCIA' => 'string',
        'CHNRCONTA' => 'string',
        'CHDIGNRCH' => 'string',
        'CHDTEMIS' => 'date',
        'CHDTVENCTO' => 'date',
        'CHDTCAD' => 'date',
        'DTENVIOCUST' => 'date',
        'CHVRCHEQUE' => 'decimal:2',
        'CHEMITENTE' => 'string',
        'CHHISTORICO' => 'string',
        'CHORIGEM' => 'string',
        'CHSITUACAO' => 'string',
        'CUSTODIA' => 'string',
        'BCONOMECUST' => 'string',
        'COBCODIGOCUST' => 'string',
        'CTANRCONTA' => 'string',
    ];

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com BANCO
    public function banco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBanco::class, 'BCOCODIGO', 'BCOCODIGO');
    }

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com FUNCIO
    public function funcionario(): BelongsTo
    {
        return $this->belongsTo(FirebirdFuncio::class, 'FUNCODIGO', 'FUNCODIGO');
    }

    // Relacionamento com CONTA (portador)
    public function contaPortador(): BelongsTo
    {
        return $this->belongsTo(FirebirdConta::class, 'BCOPORTADOR', 'BCOCODIGO');
    }

    // Relacionamento com CONTA (conta corrente)
    public function contaCorrente(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdConta::class,
            ['CTANRCONTA', 'EMPCCORR'],
            ['CTANRCONTA', 'EMPCCORR']
        );
    }

    // Relacionamento com LOTECH
    public function lote(): BelongsTo
    {
        return $this->belongsTo(FirebirdLotech::class, 'ID_LOTECH', 'ID_LOTECH');
    }

    // Relacionamento com CHEQUECUST
    public function custodia(): BelongsTo
    {
        return $this->belongsTo(
            FirebirdChequecust::class,
            ['BCOCODIGOCUST', 'COBCODIGOCUST'],
            ['BCOCODIGOCUST', 'COBCODIGOCUST']
        );
    }

    // Relacionamento com CHEBX (baixas)
    public function baixas(): HasMany
    {
        return $this->hasMany(FirebirdChebx::class, ['CHCODIGO', 'EMPCODIGO'], ['CHCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com CHEQUEREC (recebimentos)
    public function recebimentos(): HasMany
    {
        return $this->hasMany(FirebirdChequerec::class, ['CHCODIGO', 'EMPCODIGO'], ['CHCODIGO', 'EMPCODIGO']);
    }

    // Método para verificar se está vencido
    public function isVencido(): bool
    {
        return $this->CHDTVENCTO < now()->toDateString();
    }

    // Método para verificar se está em custódia
    public function isEmCustodia(): bool
    {
        return $this->CUSTODIA === 'S' || !empty($this->BCOCODIGOCUST);
    }

    // Método para obter total de baixas
    public function getTotalBaixas(): int
    {
        return $this->baixas()->count();
    }

    // Scope para filtrar por situação
    public function scopePorSituacao($query, string $situacao)
    {
        return $query->where('CHSITUACAO', $situacao);
    }

    // Scope para filtrar por banco
    public function scopePorBanco($query, int $bancoCodigo)
    {
        return $query->where('BCOCODIGO', $bancoCodigo);
    }

    // Scope para filtrar por período de emissão
    public function scopePorPeriodoEmissao($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CHDTEMIS', [$dataInicio, $dataFim]);
    }

    // Scope para filtrar cheques vencidos
    public function scopeVencidos($query)
    {
        return $query->where('CHDTVENCTO', '<', now()->toDateString())
            ->whereNotIn('CHSITUACAO', ['Compensado', 'Cancelado']);
    }

    // Scope para filtrar cheques em custódia
    public function scopeEmCustodia($query)
    {
        return $query->where(function($q) {
            $q->where('CUSTODIA', 'S')
              ->orWhereNotNull('BCOCODIGOCUST');
        });
    }

    // Scope para buscar por número do cheque (relação lógica)
    public function scopePorNumero($query, string $numeroCheque)
    {
        return $query->where('CHNRCHEQUE', $numeroCheque);
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se banco, conta e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Números únicos** - Validar unicidade de CHNRCHEQUE por empresa

### Performance

1. **Tabela média** - Requer índices adequados para JOINs
2. **Índices em campos de busca** - BCOCODIGO, CHNRCHEQUE, CHSITUACAO, datas
3. **Relações lógicas** - Índices em CHNRCHEQUE para PAGBX e CCORR
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CHEQUE

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de datas** - CHDTVENCTO >= CHDTEMIS, CHDTCAD >= CHDTEMIS

### Manutenção

1. **Revisão periódica** - Verificar cheques vencidos e situação
2. **Padronização** - Manter situações e origens consistentes
3. **Documentação** - Documentar tipos de situação e origem utilizados
4. **Backup regular** - Tabela crítica para controle financeiro

### Regras de Negócio

1. **Validação em tempo real** - Verificar se banco e conta existem antes de cadastrar
2. **Consistência** - Situação deve corresponder ao estado real do cheque
3. **Histórico completo** - Manter todas as baixas para auditoria
4. **Custódia** - Validar informações de custódia quando aplicável

### Observações Especiais

1. **Múltiplas contas** - CHEQUE pode referenciar diferentes contas (portador e corrente)
2. **Relações lógicas** - PAGBX e CCORR referenciam cheques através do número (sem FK)
3. **Lotes** - Cheques podem ser agrupados em lotes para processamento
4. **Custódia** - Suporte a cheques em custódia de terceiros

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

