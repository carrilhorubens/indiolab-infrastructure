# CCORR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CCORR (Movimentações de Conta Corrente)
- **Total de Registros**: 208.120
- **Total de Colunas**: 36
- **Chave Primária**: (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR) - Composta
- **Chaves Estrangeiras**: 9
- **Índices**: 3 (INDCCODATA, INDCCODTVENCTO, INDCCONRLANC)
- **Tabelas Dependentes**: 52 (altamente referenciada)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CCORR** é a tabela central de movimentações de conta corrente bancária do sistema. Com **208.120 registros**, registra todas as transações financeiras relacionadas a contas bancárias, incluindo entradas, saídas, transferências, conciliações e controles contábeis.

Esta tabela funciona como **livro-caixa digital** e permite:
- Registrar todas as movimentações bancárias (entradas e saídas)
- Controlar saldos de contas correntes
- Rastrear origem e destino de cada transação
- Integrar com sistemas de conciliação bancária
- Controlar cheques emitidos e recebidos
- Gerenciar transferências entre contas e empresas
- Registrar histórico contábil de cada movimentação

Cada registro representa uma movimentação específica, contendo:
- Identificação da conta (BCOCODIGO, CTANRCONTA, EMPCCORR)
- Número sequencial do lançamento (CCONRLANCTO)
- Data e valor da movimentação
- Tipo de movimentação (entrada/saída)
- Informações de cheque, histórico e conciliação
- Rastreabilidade completa (usuário, cliente, origem)

O sistema utiliza esta tabela como base para todos os processos financeiros, desde o controle de caixa até a conciliação bancária e geração de relatórios contábeis.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **BCOCODIGO** 🔑🔗 | INTEGER | Código do banco (PK + FK → CONTA) |
| **CTANRCONTA** 🔑🔗 | VARCHAR(37) | Número da conta (PK + FK → CONTA) |
| **CCONRLANCTO** 🔑 | INTEGER | Número sequencial do lançamento (PK) |
| **EMPCCORR** 🔑🔗 | INTEGER | Empresa correntista (PK + FK → CONTA) |

### Dados da Movimentação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CCODATA** | DATE | Data da movimentação (INDEXADO) |
| **CCOENTSAI** | VARCHAR(14) | Tipo: Entrada (E) ou Saída (S) |
| **CCOVALOR** | NUMERIC(16) | Valor da movimentação |
| **CCODTVENCTO** | DATE | Data de vencimento (INDEXADO) |
| **CCOORIGEM** | VARCHAR(14) | Origem da movimentação |

### Informações de Cheque
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CCONRCHEQUE** | VARCHAR(37) | Número do cheque |
| **CCOCOMP** | VARCHAR(14) | Compensação do cheque |
| **CCOEMICHE** | VARCHAR(14) | Emissão do cheque |
| **CCONOMINAL** | VARCHAR(37) | Nome do portador do cheque |

### Dados Contábeis e Histórico
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CCOHISTORICO** | VARCHAR(37) | Histórico da movimentação |
| **CCOCOMPLE** | VARCHAR(37) | Complemento do histórico |
| **CCONRDOC** | INTEGER | Número do documento |
| **CCODTDOC** | DATE | Data do documento |
| **CCOPARCELA** | VARCHAR(14) | Parcela do documento |
| **CCODTVENCDOC** | DATE | Data de vencimento do documento |

### Transferências Entre Contas
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CCOTRABCO** | INTEGER | Banco de transferência |
| **CCOTRANRCONTA** | VARCHAR(37) | Conta de transferência |
| **CCOTRANRLANCTO** | INTEGER | Lançamento de transferência |
| **CCOEMPTRANSF** 🔗 | INTEGER | Empresa de transferência (FK → EMPRESA) |

### Controle e Situação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CCOSITUACAO** | VARCHAR(14) | Situação do lançamento |
| **CCODOCTOBX** | VARCHAR(14) | Documento para baixa |
| **CCONAOCONTABILIZAR** | VARCHAR(14) | Flag para não contabilizar |

### Conciliação Bancária
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ID_CONCILIACAO** 🔗 | INTEGER | ID da conciliação (FK → EXTRATOCONCBCO) |
| **CCOCONFERIDO** | VARCHAR(37) | Flag de conferência |
| **CCOCONFERIDOERRO** | VARCHAR(37) | Erro na conferência |
| **CCOCONFERIDOOBS** | VARCHAR(37) | Observações da conferência |
| **CCOCONFERIDOUSU** | INTEGER | Usuário que conferiu |

### Relacionamentos
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **EMPCODIGO** 🔗 | INTEGER | Empresa (FK → EMPRESA) |
| **CLICODIGO** 🔗 | INTEGER | Cliente (FK → CLIEN) |
| **HISCODIGO** 🔗 | INTEGER | Histórico contábil (FK → HISTO) |
| **USUCODIGO** 🔗 | INTEGER | Usuário responsável (FK → USUARIO) |
| **CUSCODIGO** | VARCHAR(14) | Centro de custo |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CCORR Referencia (9 FKs):

#### 1. CONTA - Contas Bancárias (3 FKs)
**Relacionamentos:**
```
CCORR.BCOCODIGO → CONTA.BCOCODIGO (N:1)
CCORR.CTANRCONTA → CONTA.CTANRCONTA (N:1)
CCORR.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_CCORR
```

**Descrição**: Cada movimentação está vinculada a uma conta bancária específica através de chave composta (banco + conta + empresa).

**Informações da Tabela CONTA:**
- **Total:** 55 contas
- **PK:** (BCOCODIGO, CTANRCONTA, EMPCCORR)
- **Colunas:** 19 campos
- **FK Out:** 1 (BANCO)
- **FK In:** 27 tabelas

**Uso:** Identificar a conta bancária de cada movimentação, calcular saldos, gerar extratos.

---

#### 2. CLIEN - Clientes
**Relacionamento:**
```
CCORR.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CCORR
```

**Descrição**: Movimentações podem estar vinculadas a clientes específicos (ex: recebimentos, pagamentos).

**Uso:** Rastrear movimentações por cliente, relatórios de fluxo de caixa por cliente.

---

#### 3. EMPRESA - Empresas
**Relacionamentos:**
```
CCORR.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
CCORR.CCOEMPTRANSF → EMPRESA.EMPCODIGO (N:1)
Constraints: EMPRESA_CCORR, EMPRESA_CCORRTRANSF
```

**Descrição**: Identifica a empresa relacionada à movimentação e empresa de destino em transferências.

**Uso:** Controle multi-empresa, transferências entre empresas.

---

#### 4. HISTO - Histórico Contábil
**Relacionamento:**
```
CCORR.HISCODIGO → HISTO.HISCODIGO (N:1)
Constraint: HISTO_CCORR
```

**Descrição**: Classificação contábil da movimentação para geração de relatórios contábeis.

**Uso:** Classificação contábil, relatórios de DRE, balanço.

---

#### 5. USUARIO - Usuários
**Relacionamento:**
```
CCORR.USUCODIGO → USUARIO.USUCODIGO (N:1)
Constraint: USUARIO_CCORR
```

**Descrição**: Identifica o usuário responsável pela movimentação.

**Uso:** Auditoria, rastreabilidade de operações.

---

#### 6. EXTRATOCONCBCO - Conciliação Bancária
**Relacionamento:**
```
CCORR.ID_CONCILIACAO → EXTRATOCONCBCO.ID (N:1)
Constraint: FK_ID_CONCILIACAO
```

**Descrição**: Vincula movimentações a processos de conciliação bancária.

**Uso:** Conciliação automática, identificação de divergências.

---

### CCORR é Referenciada Por (52 Tabelas):

#### Categorias de Tabelas Dependentes:

**1. Movimentações de Caixa:**
- CAIXA, CAIXAP - Movimentações de caixa vinculadas a CCORR

**2. Baixas de Títulos:**
- RECBX, RECBXP - Baixas de recebimentos
- PAGBX, PAGBXP - Baixas de pagamentos
- CHEBX - Baixas de cheques

**3. Controle Contábil:**
- CCOCTB - Contabilização de movimentações
- COCCTCUSTO - Centro de custo das movimentações

**4. Duplicatas e Títulos:**
- OCDUP - Ocorrências de duplicatas
- SOLDUP - Solicitadas de duplicatas

**5. Conciliação:**
- EXTCONCILIACAO - Conciliação de extratos bancários

**6. Lotes:**
- LOTECHCCORR - Lotes de cheques vinculados a CCORR

**Todas as 52 tabelas referenciam CCORR através da chave composta:**
```
(BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
```

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CONTA → BANCO

**Fluxo:** CCORR → CONTA → BANCO

**Descrição:** Através do relacionamento com CONTA, é possível identificar o banco de cada movimentação.

**Campos de junção:**
- `CCORR.BCOCODIGO` → `CONTA.BCOCODIGO` → `BANCO.BCOCODIGO`

**Uso:** Análises por banco, relatórios consolidados por instituição financeira.

---

### Via CLIEN → Outras Tabelas

**Fluxo:** CCORR → CLIEN → [Múltiplas tabelas]

**Descrição:** Através do relacionamento com CLIEN, é possível acessar informações completas do cliente.

**Uso:** Análises de movimentações por cliente, relatórios de relacionamento comercial.

---

### Via USUARIO → FUNCIO

**Fluxo:** CCORR → USUARIO → FUNCIO

**Descrição:** Através do relacionamento com USUARIO, é possível identificar o funcionário responsável.

**Campos de junção:**
- `CCORR.USUCODIGO` → `USUARIO.USUCODIGO` → `USUARIO.FUNCODIGO` → `FUNCIO.FUNCODIGO`

**Uso:** Auditoria por funcionário, controle de permissões.

---

### Via EXTCONCILIACAO → BCOEXTRATO

**Fluxo:** CCORR → EXTCONCILIACAO → BCOEXTRATO

**Descrição:** Através da conciliação, é possível rastrear até o extrato bancário original.

**Campos de junção:**
- `CCORR.ID_CONCILIACAO` → `EXTRATOCONCBCO.ID` → `EXTCONCILIACAO.IDARQUIVO` → `BCOEXTRATO.ID`

**Uso:** Rastreamento completo de conciliação, auditoria de extratos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Movimentação

**Objetivo:** Obter visão completa de uma movimentação incluindo conta, banco, cliente e usuário.

**Fluxo:**
```
CCORR (BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
USUARIO (USUCODIGO)
  ↓
FUNCIO (FUNCODIGO)
```

**Query SQL:**
```sql
SELECT
    c.BCOCODIGO,
    c.CTANRCONTA,
    c.CCONRLANCTO,
    c.CCODATA AS DATA_MOVIMENTACAO,
    c.CCOENTSAI AS TIPO,
    c.CCOVALOR / 100.0 AS VALOR,
    c.CCOHISTORICO AS HISTORICO,
    ct.CTANRCONTA AS NUMERO_CONTA,
    b.BCONOME AS BANCO,
    cl.CLINOME AS CLIENTE,
    u.USUNOME AS USUARIO,
    f.FUNNOME AS FUNCIONARIO,
    e.EMPRAZSOCIAL AS EMPRESA
FROM CCORR c
LEFT JOIN CONTA ct ON ct.BCOCODIGO = c.BCOCODIGO 
    AND ct.CTANRCONTA = c.CTANRCONTA 
    AND ct.EMPCCORR = c.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = ct.BCOCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = c.CLICODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = c.USUCODIGO
LEFT JOIN FUNCIO f ON f.FUNCODIGO = u.FUNCODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = c.EMPCODIGO
WHERE c.BCOCODIGO = ?
  AND c.CTANRCONTA = ?
  AND c.CCONRLANCTO = ?
  AND c.EMPCCORR = ?;
```

---

### Exemplo 2: Análise de Saldo por Conta

**Objetivo:** Calcular saldo atual de uma conta corrente considerando todas as movimentações.

**Fluxo:**
```
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
CCORR (Movimentações)
```

**Query SQL:**
```sql
SELECT
    ct.BCOCODIGO,
    ct.CTANRCONTA,
    ct.EMPCCORR,
    b.BCONOME AS BANCO,
    ct.CTASALDOIMPL / 100.0 AS SALDO_IMPLICITO,
    SUM(CASE 
        WHEN c.CCOENTSAI = 'E' THEN c.CCOVALOR 
        ELSE -c.CCOVALOR 
    END) / 100.0 AS SALDO_CALCULADO,
    COUNT(c.CCONRLANCTO) AS TOTAL_MOVIMENTACOES,
    MIN(c.CCODATA) AS PRIMEIRA_MOVIMENTACAO,
    MAX(c.CCODATA) AS ULTIMA_MOVIMENTACAO
FROM CONTA ct
LEFT JOIN BANCO b ON b.BCOCODIGO = ct.BCOCODIGO
LEFT JOIN CCORR c ON c.BCOCODIGO = ct.BCOCODIGO
    AND c.CTANRCONTA = ct.CTANRCONTA
    AND c.EMPCCORR = ct.EMPCCORR
WHERE ct.BCOCODIGO = ?
  AND ct.CTANRCONTA = ?
  AND ct.EMPCCORR = ?
GROUP BY ct.BCOCODIGO, ct.CTANRCONTA, ct.EMPCCORR, b.BCONOME, ct.CTASALDOIMPL;
```

---

### Exemplo 3: Análise de Conciliação Bancária

**Objetivo:** Identificar movimentações conciliadas e não conciliadas de uma conta.

**Fluxo:**
```
CCORR (ID_CONCILIACAO)
  ↓
EXTRATOCONCBCO (ID)
  ↓
EXTCONCILIACAO (IDARQUIVO)
  ↓
BCOEXTRATO (ID)
```

**Query SQL:**
```sql
SELECT
    c.BCOCODIGO,
    c.CTANRCONTA,
    c.CCONRLANCTO,
    c.CCODATA,
    c.CCOVALOR / 100.0 AS VALOR,
    c.CCOENTSAI AS TIPO,
    c.CCOHISTORICO,
    CASE 
        WHEN c.ID_CONCILIACAO IS NOT NULL THEN 'CONCILIADO'
        ELSE 'NAO_CONCILIADO'
    END AS STATUS_CONCILIACAO,
    ec.ID AS ID_CONCILIACAO,
    be.BEXDATA AS DATA_EXTRATO
FROM CCORR c
LEFT JOIN EXTRATOCONCBCO ec ON ec.ID = c.ID_CONCILIACAO
LEFT JOIN EXTCONCILIACAO ext ON ext.IDARQUIVO = ec.IDARQUIVO
LEFT JOIN BCOEXTRATO be ON be.ID = ext.IDARQUIVO
WHERE c.BCOCODIGO = ?
  AND c.CTANRCONTA = ?
  AND c.EMPCCORR = ?
  AND c.CCODATA BETWEEN ? AND ?
ORDER BY c.CCODATA DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Movimentações por Conta e Período

**Objetivo:** Visualizar todas as movimentações de uma conta em um período específico.

```sql
SELECT
    CCONRLANCTO AS LANCTO,
    CCODATA AS DATA,
    CCOENTSAI AS TIPO,
    CCOVALOR / 100.0 AS VALOR,
    CCOHISTORICO AS HISTORICO,
    CCONOMINAL AS NOMINAL,
    CCOSITUACAO AS SITUACAO
FROM CCORR
WHERE BCOCODIGO = ?
  AND CTANRCONTA = ?
  AND EMPCCORR = ?
  AND CCODATA BETWEEN ? AND ?
ORDER BY CCODATA DESC, CCONRLANCTO DESC;
```

---

### 2. Buscar Movimentação Específica

**Objetivo:** Obter detalhes completos de uma movimentação específica.

```sql
SELECT
    c.*,
    ct.CTANRCONTA AS NUMERO_CONTA,
    b.BCONOME AS BANCO,
    cl.CLINOME AS CLIENTE,
    u.USUNOME AS USUARIO
FROM CCORR c
LEFT JOIN CONTA ct ON ct.BCOCODIGO = c.BCOCODIGO 
    AND ct.CTANRCONTA = c.CTANRCONTA 
    AND ct.EMPCCORR = c.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = ct.BCOCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = c.CLICODIGO
LEFT JOIN USUARIO u ON u.USUCODIGO = c.USUCODIGO
WHERE c.BCOCODIGO = ?
  AND c.CTANRCONTA = ?
  AND c.CCONRLANCTO = ?
  AND c.EMPCCORR = ?;
```

---

### 3. Análise de Entradas e Saídas por Período

**Objetivo:** Calcular totais de entradas e saídas em um período.

```sql
SELECT
    DATE(CCODATA) AS DATA,
    COUNT(CASE WHEN CCOENTSAI = 'E' THEN 1 END) AS TOTAL_ENTRADAS,
    COUNT(CASE WHEN CCOENTSAI = 'S' THEN 1 END) AS TOTAL_SAIDAS,
    SUM(CASE WHEN CCOENTSAI = 'E' THEN CCOVALOR ELSE 0 END) / 100.0 AS VALOR_ENTRADAS,
    SUM(CASE WHEN CCOENTSAI = 'S' THEN CCOVALOR ELSE 0 END) / 100.0 AS VALOR_SAIDAS,
    (SUM(CASE WHEN CCOENTSAI = 'E' THEN CCOVALOR ELSE 0 END) - 
     SUM(CASE WHEN CCOENTSAI = 'S' THEN CCOVALOR ELSE 0 END)) / 100.0 AS SALDO_DIA
FROM CCORR
WHERE BCOCODIGO = ?
  AND CTANRCONTA = ?
  AND EMPCCORR = ?
  AND CCODATA BETWEEN ? AND ?
GROUP BY DATE(CCODATA)
ORDER BY DATA DESC;
```

---

### 4. Relatório de Cheques por Conta

**Objetivo:** Listar todos os cheques relacionados a uma conta.

```sql
SELECT
    CCONRLANCTO AS LANCTO,
    CCODATA AS DATA,
    CCONRCHEQUE AS NUMERO_CHEQUE,
    CCONOMINAL AS PORTADOR,
    CCOVALOR / 100.0 AS VALOR,
    CCOCOMP AS COMPENSACAO,
    CCOEMICHE AS EMISSAO,
    CCODTVENCTO AS VENCIMENTO,
    CCOSITUACAO AS SITUACAO
FROM CCORR
WHERE BCOCODIGO = ?
  AND CTANRCONTA = ?
  AND EMPCCORR = ?
  AND CCONRCHEQUE IS NOT NULL
ORDER BY CCODTVENCTO DESC, CCONRLANCTO DESC;
```

---

### 5. Análise de Transferências Entre Contas

**Objetivo:** Identificar transferências realizadas entre contas.

```sql
SELECT
    c.BCOCODIGO AS BANCO_ORIGEM,
    c.CTANRCONTA AS CONTA_ORIGEM,
    c.CCONRLANCTO AS LANCTO_ORIGEM,
    c.CCODATA AS DATA,
    c.CCOVALOR / 100.0 AS VALOR,
    c.CCOTRABCO AS BANCO_DESTINO,
    c.CCOTRANRCONTA AS CONTA_DESTINO,
    c.CCOTRANRLANCTO AS LANCTO_DESTINO,
    e.EMPRAZSOCIAL AS EMPRESA_TRANSFERENCIA
FROM CCORR c
LEFT JOIN EMPRESA e ON e.EMPCODIGO = c.CCOEMPTRANSF
WHERE c.CCOTRABCO IS NOT NULL
  AND c.CCODATA BETWEEN ? AND ?
ORDER BY c.CCODATA DESC;
```

---

### 6. Verificar Movimentações Não Conciliadas

**Objetivo:** Identificar movimentações que ainda não foram conciliadas.

```sql
SELECT
    c.BCOCODIGO,
    c.CTANRCONTA,
    c.CCONRLANCTO,
    c.CCODATA,
    c.CCOVALOR / 100.0 AS VALOR,
    c.CCOENTSAI AS TIPO,
    c.CCOHISTORICO,
    CAST(CURRENT_DATE - c.CCODATA AS INTEGER) AS DIAS_SEM_CONCILIAR
FROM CCORR c
WHERE c.ID_CONCILIACAO IS NULL
  AND c.CCODATA < CURRENT_DATE - 7
ORDER BY c.CCODATA ASC;
```

---

### 7. Auditoria de Movimentações por Usuário

**Objetivo:** Listar todas as movimentações realizadas por um usuário específico.

```sql
SELECT
    c.CCONRLANCTO AS LANCTO,
    c.CCODATA AS DATA,
    c.CCOENTSAI AS TIPO,
    c.CCOVALOR / 100.0 AS VALOR,
    c.CCOHISTORICO,
    u.USUNOME AS USUARIO,
    f.FUNNOME AS FUNCIONARIO,
    cl.CLINOME AS CLIENTE
FROM CCORR c
LEFT JOIN USUARIO u ON u.USUCODIGO = c.USUCODIGO
LEFT JOIN FUNCIO f ON f.FUNCODIGO = u.FUNCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = c.CLICODIGO
WHERE c.USUCODIGO = ?
  AND c.CCODATA BETWEEN ? AND ?
ORDER BY c.CCODATA DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CCORR | Tipo |
|--------|-----------|---------------------|------|
| **CCORR** | 208.120 | 1:1 | **TABELA PRINCIPAL** |
| CONTA | 55 | 3.784:1 | Contas (média de 3.784 movimentações por conta) |
| CLIEN | ~50k | ~4:1 | Clientes (média de 4 movimentações por cliente) |
| USUARIO | 297 | 700:1 | Usuários (média de 700 movimentações por usuário) |
| Tabelas Dependentes | 52 | - | Tabelas que referenciam CCORR |

**Interpretação:**
- Cada conta possui em média **3.784 movimentações** (alta atividade)
- Tabela central do sistema financeiro
- **52 tabelas dependentes** indicam importância crítica
- Volume médio-grande requer atenção à performance

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **BCOCODIGO, CTANRCONTA, CCONRLANCTO, EMPCCORR** | CCORR | Chave primária composta (PK) |
| **BCOCODIGO, CTANRCONTA, EMPCCORR** | CCORR → CONTA | Referência à conta bancária |
| **CLICODIGO** | CCORR → CLIEN | Referência ao cliente |
| **USUCODIGO** | CCORR → USUARIO | Referência ao usuário responsável |
| **ID_CONCILIACAO** | CCORR → EXTRATOCONCBCO | Referência à conciliação |
| **CCODATA** | CCORR | Data da movimentação (filtro temporal - INDEXADO) |
| **CCOENTSAI** | CCORR | Tipo de movimentação (E/S) |

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **INDCCODATA** - Índice em CCODATA
   - Otimiza consultas por data
   - Essencial para relatórios temporais

2. **INDCCODTVENCTO** - Índice em CCODTVENCTO
   - Otimiza consultas por data de vencimento
   - Útil para relatórios de vencimentos

3. **INDCCONRLANC** - Índice em CCONRLANCTO
   - Otimiza buscas por número de lançamento
   - Útil para consultas específicas

### Recomendações de Performance

1. **Índice composto na chave primária** - Já existe implicitamente (PK)
2. **Índice composto conta + data** - Para consultas por conta e período
3. **Índice em CCOENTSAI** - Para filtros por tipo (entrada/saída)
4. **Índice em ID_CONCILIACAO** - Para consultas de conciliação
5. **Índice em CLICODIGO** - Para análises por cliente
6. **Índice em USUCODIGO** - Para auditoria por usuário

### Índices Sugeridos

```sql
-- Índice 1: Busca por conta e data (consultas frequentes)
CREATE INDEX IDX_CCORR_CONTA_DATA ON CCORR(BCOCODIGO, CTANRCONTA, EMPCCORR, CCODATA);

-- Índice 2: Busca por tipo e data
CREATE INDEX IDX_CCORR_TIPO_DATA ON CCORR(CCOENTSAI, CCODATA);

-- Índice 3: Busca por conciliação
CREATE INDEX IDX_CCORR_CONCILIACAO ON CCORR(ID_CONCILIACAO) WHERE ID_CONCILIACAO IS NOT NULL;

-- Índice 4: Busca por cliente
CREATE INDEX IDX_CCORR_CLIENTE ON CCORR(CLICODIGO) WHERE CLICODIGO IS NOT NULL;

-- Índice 5: Busca por usuário
CREATE INDEX IDX_CCORR_USUARIO ON CCORR(USUCODIGO) WHERE USUCODIGO IS NOT NULL;

-- Índice 6: Busca por cheque
CREATE INDEX IDX_CCORR_CHEQUE ON CCORR(CCONRCHEQUE) WHERE CCONRCHEQUE IS NOT NULL;
```

### Observações sobre Volume

- **Tabela média-grande** (208K registros) - Performance pode ser crítica em consultas sem filtros
- **Consultas com JOINs** podem ser lentas - sempre usar filtros adequados
- **Focar em filtros temporais** - Sempre usar CCODATA para limitar resultados
- **Considerar particionamento** - Por data se volume crescer significativamente
- **Valores em centavos** - CCOVALOR está em centavos, dividir por 100 ao exibir

### Exemplo de Query Otimizada

```sql
-- ❌ NÃO OTIMIZADO (table scan completo)
SELECT * FROM CCORR WHERE CLICODIGO = 12345;

-- ✅ OTIMIZADO (usa índices e limita período)
SELECT
    CCONRLANCTO, CCODATA, CCOENTSAI, CCOVALOR / 100.0 AS VALOR, CCOHISTORICO
FROM CCORR
WHERE CLICODIGO = 12345
  AND CCODATA >= CURRENT_DATE - INTERVAL '1 year'
ORDER BY CCODATA DESC;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar movimentações sem conta válida
SELECT c.*
FROM CCORR c
LEFT JOIN CONTA ct ON ct.BCOCODIGO = c.BCOCODIGO 
    AND ct.CTANRCONTA = c.CTANRCONTA 
    AND ct.EMPCCORR = c.EMPCCORR
WHERE ct.BCOCODIGO IS NULL;

-- Verificar movimentações sem cliente válido (quando informado)
SELECT c.*
FROM CCORR c
WHERE c.CLICODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM CLIEN cl WHERE cl.CLICODIGO = c.CLICODIGO);

-- Verificar movimentações sem usuário válido (quando informado)
SELECT c.*
FROM CCORR c
WHERE c.USUCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM USUARIO u WHERE u.USUCODIGO = c.USUCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CCORR
WHERE BCOCODIGO IS NULL
   OR CTANRCONTA IS NULL
   OR CCONRLANCTO IS NULL
   OR EMPCCORR IS NULL
   OR CCODATA IS NULL
   OR CCOENTSAI IS NULL
   OR CCOVALOR IS NULL;

-- Verificar valores negativos ou zero
SELECT *
FROM CCORR
WHERE CCOVALOR <= 0;

-- Verificar datas futuras (inconsistência)
SELECT *
FROM CCORR
WHERE CCODATA > CURRENT_TIMESTAMP;

-- Verificar tipo de movimentação inválido
SELECT *
FROM CCORR
WHERE CCOENTSAI NOT IN ('E', 'S');
```

### Verificar Integridade de Transferências

```sql
-- Verificar transferências sem conta de destino válida
SELECT c.*
FROM CCORR c
WHERE c.CCOTRABCO IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM CONTA ct 
      WHERE ct.BCOCODIGO = c.CCOTRABCO
        AND ct.CTANRCONTA = c.CCOTRANRCONTA
        AND ct.EMPCCORR = c.CCOEMPTRANSF
  );

-- Verificar transferências sem lançamento de destino
SELECT c.*
FROM CCORR c
WHERE c.CCOTRABCO IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM CCORR c2
      WHERE c2.BCOCODIGO = c.CCOTRABCO
        AND c2.CTANRCONTA = c.CCOTRANRCONTA
        AND c2.CCONRLANCTO = c.CCOTRANRLANCTO
        AND c2.EMPCCORR = c.CCOEMPTRANSF
  );
```

### Verificar Padrões de Uso

```sql
-- Verificar movimentações sem histórico
SELECT COUNT(*) AS TOTAL_SEM_HISTORICO
FROM CCORR
WHERE CCOHISTORICO IS NULL OR TRIM(CCOHISTORICO) = '';

-- Verificar movimentações não conciliadas antigas
SELECT COUNT(*) AS TOTAL_NAO_CONCILIADAS
FROM CCORR
WHERE ID_CONCILIACAO IS NULL
  AND CCODATA < CURRENT_DATE - INTERVAL '30 days';

-- Verificar distribuição de tipos
SELECT CCOENTSAI, COUNT(*) AS QTD, SUM(CCOVALOR) / 100.0 AS VALOR_TOTAL
FROM CCORR
GROUP BY CCOENTSAI;
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

final class FirebirdCcorr extends Model
{
    protected $connection = 'firebird';
    protected $table = 'CCORR';
    
    protected $primaryKey = ['BCOCODIGO', 'CTANRCONTA', 'CCONRLANCTO', 'EMPCCORR'];
    public $incrementing = false;

    protected $casts = [
        'BCOCODIGO' => 'integer',
        'CTANRCONTA' => 'string',
        'CCONRLANCTO' => 'integer',
        'EMPCCORR' => 'integer',
        'CCODATA' => 'date',
        'CCOVALOR' => 'decimal:2',
        'CCODTVENCTO' => 'date',
        'CCODTDOC' => 'date',
        'CCODTVENCDOC' => 'date',
        'EMPCODIGO' => 'integer',
        'CLICODIGO' => 'integer',
        'HISCODIGO' => 'integer',
        'USUCODIGO' => 'integer',
        'CCOEMPTRANSF' => 'integer',
        'ID_CONCILIACAO' => 'integer',
        'CCOTRABCO' => 'integer',
        'CCOTRANRLANCTO' => 'integer',
        'CCONRDOC' => 'integer',
        'CCOCONFERIDOUSU' => 'integer',
    ];

    // Relacionamento com CONTA (chave composta)
    public function conta(): BelongsTo
    {
        return $this->belongsTo(FirebirdConta::class, ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR'], ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR']);
    }

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com HISTO
    public function historico(): BelongsTo
    {
        return $this->belongsTo(FirebirdHisto::class, 'HISCODIGO', 'HISCODIGO');
    }

    // Relacionamento com USUARIO
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(FirebirdUsuario::class, 'USUCODIGO', 'USUCODIGO');
    }

    // Relacionamento com EXTRATOCONCBCO
    public function conciliacao(): BelongsTo
    {
        return $this->belongsTo(FirebirdExtratoConcBco::class, 'ID_CONCILIACAO', 'ID');
    }

    // Scope para filtrar por conta
    public function scopePorConta($query, int $bancoCodigo, string $contaNumero, int $empresaCodigo)
    {
        return $query->where('BCOCODIGO', $bancoCodigo)
            ->where('CTANRCONTA', $contaNumero)
            ->where('EMPCCORR', $empresaCodigo);
    }

    // Scope para filtrar por período
    public function scopePorPeriodo($query, $dataInicio, $dataFim)
    {
        return $query->whereBetween('CCODATA', [$dataInicio, $dataFim]);
    }

    // Scope para entradas
    public function scopeEntradas($query)
    {
        return $query->where('CCOENTSAI', 'E');
    }

    // Scope para saídas
    public function scopeSaidas($query)
    {
        return $query->where('CCOENTSAI', 'S');
    }

    // Scope para não conciliadas
    public function scopeNaoConciliadas($query)
    {
        return $query->whereNull('ID_CONCILIACAO');
    }

    // Scope para conciliadas
    public function scopeConciliadas($query)
    {
        return $query->whereNotNull('ID_CONCILIACAO');
    }

    // Scope para movimentações recentes
    public function scopeRecentes($query, int $dias = 30)
    {
        return $query->where('CCODATA', '>=', now()->subDays($dias));
    }

    // Método para calcular valor em reais
    public function getValorReaisAttribute(): float
    {
        return $this->CCOVALOR / 100.0;
    }

    // Método para verificar se é entrada
    public function isEntrada(): bool
    {
        return $this->CCOENTSAI === 'E';
    }

    // Método para verificar se é saída
    public function isSaida(): bool
    {
        return $this->CCOENTSAI === 'S';
    }

    // Método para verificar se está conciliada
    public function isConciliada(): bool
    {
        return $this->ID_CONCILIACAO !== null;
    }

    // Método para verificar se tem cheque
    public function temCheque(): bool
    {
        return !empty($this->CCONRCHEQUE);
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 4 campos para identificar unicamente
2. **Valores em centavos** - CCOVALOR está em centavos, sempre dividir por 100 ao exibir
3. **Histórico obrigatório** - CCOHISTORICO deve ser preenchido para rastreabilidade
4. **Tipo claro** - CCOENTSAI deve ser sempre 'E' ou 'S'

### Performance

1. **Sempre filtrar por data** - Usar CCODATA para limitar resultados
2. **Usar índices** - Criar índices nos campos de busca frequente
3. **Evitar SELECT *** - Especificar apenas colunas necessárias
4. **Considerar cache** - Para relatórios de saldo e totais

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se conta existe
2. **Verificar duplicatas** - Evitar lançamentos duplicados
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Auditoria** - Registrar todas as alterações críticas

### Manutenção

1. **Revisão periódica** - Verificar movimentações não conciliadas
2. **Arquivamento** - Considerar arquivar registros antigos (> 5 anos)
3. **Backup regular** - Tabela crítica para sistema financeiro
4. **Monitoramento** - Acompanhar crescimento e performance

### Regras de Negócio

1. **Tabela transacional** - Não deve ser modificada após inserção (exceto conciliação)
2. **Rastreabilidade** - Todo movimento financeiro deve ser registrado aqui
3. **Conciliação obrigatória** - Movimentações devem ser conciliadas periodicamente
4. **Validação de saldo** - Saldo calculado deve bater com saldo implícito da conta

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

