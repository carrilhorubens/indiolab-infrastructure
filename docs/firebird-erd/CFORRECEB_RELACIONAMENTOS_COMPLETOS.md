# CFORRECEB - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CFORRECEB (Condições de Forma de Recebimento)
- **Total de Registros**: 3
- **Total de Colunas**: 9
- **Chave Primária**: FRCCODIGO (INTEGER)
- **Chaves Estrangeiras**: 1 (TPDCOD → TPDOCTO)
- **Índices**: 0
- **Tabelas Dependentes**: 7 (Diretas)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CFORRECEB** é uma tabela mestre que armazena as condições de formas de recebimento disponíveis no sistema. Com **apenas 3 registros**, representa um catálogo pequeno mas essencial de formas de pagamento configuradas para recebimentos.

Esta tabela funciona como **catálogo de formas de recebimento** e permite:
- Definir formas de pagamento disponíveis para recebimentos
- Configurar prazos de pagamento em dias (FRCDIAS)
- Associar tipo de documento fiscal (TPDCOD)
- Configurar integração bancária e de cartões
- Controlar formas de pagamento ativas/inativas
- Suportar diferentes tipos de pagamento (dinheiro, cartão, boleto, PIX, etc.)

Cada registro representa uma forma de recebimento configurada, contendo:
- Código identificador (FRCCODIGO)
- Descrição da forma de recebimento (FRCDESC)
- Prazo em dias para pagamento (FRCDIAS) - 0 = à vista
- Status ativo/inativo (FRCATIVO)
- Tipo de documento relacionado (TPDCOD)
- Código da forma de pagamento (FRCFORMAPAG)
- Tipo de integração (FRCTPINTEGRA)
- Informações de cartão (FRCCNPJCARTAO, FRCBANDCARTAO)

O sistema utiliza esta tabela para definir como os recebimentos serão processados em pedidos, notas fiscais, parcelas de clientes e outras operações financeiras.

**Observação Importante:** Com apenas 3 registros, esta tabela funciona como configuração básica de formas de recebimento. O volume reduzido sugere que são formas padrão do sistema (ex: Dinheiro, Cartão, Boleto).

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FRCCODIGO** 🔑 | INTEGER | ✓ | Código identificador único da forma de recebimento (PK) |

### Informações da Forma de Recebimento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FRCDESC** | VARCHAR(37) | ✓ | Descrição da forma de recebimento |
| **FRCDIAS** | INTEGER | ✓ | Prazo em dias para pagamento (0 = à vista) |
| **FRCATIVO** | VARCHAR(14) | ✓ | Status ativo/inativo ('S' = Ativo, 'N' = Inativo) |

### Relacionamentos e Configurações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPDCOD** 🔗 | VARCHAR(14) | ✓ | Código do tipo de documento (FK → TPDOCTO) |
| **FRCFORMAPAG** | VARCHAR(37) | | Código da forma de pagamento (ex: '01' = Dinheiro, '03' = Cartão Crédito) |
| **FRCTPINTEGRA** | VARCHAR(14) | | Tipo de integração ('B' = Bancário, 'C' = Cartão, 'P' = PIX, 'N' = Não integra) |

### Informações de Cartão (Opcional)
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FRCCNPJCARTAO** | VARCHAR(37) | | CNPJ da operadora de cartão |
| **FRCBANDCARTAO** | VARCHAR(37) | | Bandeira do cartão (Visa, Mastercard, etc.) |

**Primary Key:** FRCCODIGO

**Observações sobre Campos:**
- **FRCDIAS**: Prazo em dias para pagamento. Valor 0 indica pagamento à vista.
- **FRCATIVO**: Controla se a forma de recebimento está disponível para uso.
- **FRCFORMAPAG**: Código padronizado da forma de pagamento conforme tabela fiscal brasileira.
- **FRCTPINTEGRA**: Define como a forma de pagamento se integra com sistemas externos (bancos, adquirentes).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CFORRECEB Referencia (1 FK):

#### 1. TPDOCTO - Tipo de Documento
**Relacionamento:**
```
CFORRECEB.TPDCOD → TPDOCTO.TPDCOD (N:1)
Constraint: FK_CFORRECEB_1
```

**Descrição**: Cada forma de recebimento está vinculada a um tipo de documento fiscal específico.

**Informações da Tabela TPDOCTO:**
- **Total:** 9 tipos de documento
- **PK:** TPDCOD
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 1 tabela (CFORRECEB)

**Campos importantes em TPDOCTO:**
- `TPDCOD` - Código do tipo de documento
- `TPDTIPO` - Tipo do documento
- `TPDDESC` - Descrição do tipo de documento
- `TPDPOS` - Posição do documento
- `TPDGRUP` - Grupo do documento

**Uso:** Identificar qual tipo de documento fiscal está associado a cada forma de recebimento, validar documentos em operações financeiras.

---

### CFORRECEB é Referenciada Por (7 FKs):

#### 1. CFORRECEBCONTA - Contas Bancárias por Forma de Recebimento
**Relacionamento:**
```
CFORRECEBCONTA.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: FK_CFORRECEBCONTA_1
```

**Descrição**: Vincula contas bancárias específicas a cada forma de recebimento.

**Informações da Tabela CFORRECEBCONTA:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (FRCCODIGO, BCOCODIGO, CTANRCONTA, EMPCCORR)
- **Colunas:** 5 campos
- **FK Out:** 6 (CFORRECEB, CONTA - 3 FKs compostas, BCOCOB, COBRADOR)

**Uso:** Configurar em quais contas bancárias cada forma de recebimento deve ser depositada.

---

#### 2. NFINFRECEB - Informações de Recebimento em Notas Fiscais
**Relacionamento:**
```
NFINFRECEB.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: CFORRECEB_NFINFRECEB
```

**Descrição**: Define a forma de recebimento utilizada em cada nota fiscal.

**Informações da Tabela NFINFRECEB:**
- **Total:** 1.051.559 registros
- **PK:** (NFCODIGO, EMPCODIGO, SEQ)
- **Colunas:** 16 campos
- **FK Out:** 3 (NOTAS - 2 FKs compostas, CFORRECEB)

**Campos importantes em NFINFRECEB:**
- `NFCODIGO` - Código da nota fiscal
- `EMPCODIGO` - Código da empresa
- `SEQ` - Sequência do recebimento
- `FRCCODIGO` - Forma de recebimento (FK → CFORRECEB)
- `VALOR` - Valor do recebimento
- `CAUT` - Código de autorização
- `NSU` - Número sequencial único
- `DATAHORATRANS` - Data e hora da transação

**Uso:** Rastrear formas de pagamento utilizadas em notas fiscais, análise de recebimentos por forma de pagamento.

---

#### 3. NFINFRECEBANT - Informações de Recebimento Anteriores em Notas Fiscais
**Relacionamento:**
```
NFINFRECEBANT.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: CFORRECEB_NFINFRECEBANT
```

**Descrição**: Armazena histórico de formas de recebimento anteriores em notas fiscais.

**Informações da Tabela NFINFRECEBANT:**
- **Total:** Volume não especificado
- **PK:** (NFCODIGO, EMPCODIGO, SEQ)
- **Colunas:** Similar a NFINFRECEB
- **FK Out:** Similar a NFINFRECEB

**Uso:** Manter histórico de alterações de formas de recebimento em notas fiscais, auditoria de mudanças.

---

#### 4. PEDINFRECEB - Informações de Recebimento em Pedidos
**Relacionamento:**
```
PEDINFRECEB.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: CFORRECEB_PEDINFRECEB
```

**Descrição**: Define a forma de recebimento utilizada em cada pedido.

**Informações da Tabela PEDINFRECEB:**
- **Total:** 2.269.119 registros
- **PK:** (ID_PEDIDO, SEQ)
- **Colunas:** 15 campos
- **FK Out:** 2 (PEDID, CFORRECEB)

**Campos importantes em PEDINFRECEB:**
- `ID_PEDIDO` - Código do pedido (FK → PEDID)
- `SEQ` - Sequência do recebimento
- `FRCCODIGO` - Forma de recebimento (FK → CFORRECEB)
- `VALOR` - Valor do recebimento
- `CAUT` - Código de autorização
- `NSU` - Número sequencial único
- `DATAHORATRANS` - Data e hora da transação

**Uso:** Rastrear formas de pagamento em pedidos, análise de recebimentos por forma de pagamento, controle de pagamentos antecipados.

---

#### 5. PCTINFRECEB - Informações de Recebimento em Parcelas de Cliente
**Relacionamento:**
```
PCTINFRECEB.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: CFORRECEB_PCTINFRECEB
```

**Descrição**: Define a forma de recebimento utilizada em parcelas de clientes (PCTCLI).

**Informações da Tabela PCTINFRECEB:**
- **Total:** 1.301 registros
- **PK:** (PCTNUMERO, SEQ)
- **Colunas:** 4 campos
- **FK Out:** 2 (PCTCLI, CFORRECEB)

**Campos importantes em PCTINFRECEB:**
- `PCTNUMERO` - Número da parcela de cliente (FK → PCTCLI)
- `SEQ` - Sequência do recebimento
- `FRCCODIGO` - Forma de recebimento (FK → CFORRECEB)
- `VALOR` - Valor do recebimento

**Uso:** Rastrear formas de pagamento em parcelas de clientes, controle de recebimentos parcelados.

---

#### 6. OCDUP - Duplicatas de Orçamento
**Relacionamento:**
```
OCDUP.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: FK_OCDUP_1
```

**Descrição**: Define a forma de recebimento para duplicatas geradas a partir de orçamentos.

**Informações da Tabela OCDUP:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (ORCDTEMIS, ORCCODIGO, EMPCODIGO, ORSEQ)
- **Colunas:** 25 campos
- **FK Out:** 11 (ORCAM - 3 FKs compostas, BANCO, BCOCOB - 2 FKs, CCORR - 4 FKs compostas, CFORRECEB)

**Uso:** Configurar formas de recebimento para duplicatas de orçamentos quando convertidos em pedidos.

---

#### 7. TXCARTAO - Taxas de Cartão
**Relacionamento:**
```
TXCARTAO.FRCCODIGO → CFORRECEB.FRCCODIGO (N:1)
Constraint: FK_TXCARTAO_1
```

**Descrição**: Define taxas de cartão por faixa de parcelas para cada forma de recebimento.

**Informações da Tabela TXCARTAO:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (FRCCODIGO, TXCPARINI, TXCPARFIN)
- **Colunas:** 5 campos
- **FK Out:** 1 (CFORRECEB)

**Campos importantes em TXCARTAO:**
- `FRCCODIGO` - Forma de recebimento (FK → CFORRECEB)
- `TXCPARINI` - Parcela inicial da faixa
- `TXCPARFIN` - Parcela final da faixa
- `TXCPERC` - Percentual de taxa
- `TXCINDICE` - Índice utilizado

**Uso:** Configurar taxas de cartão por faixa de parcelas, cálculo de taxas em vendas parceladas.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via NFINFRECEB → NOTAS (Notas Fiscais)

**Fluxo:** CFORRECEB → NFINFRECEB → NOTAS

**Descrição:** Através do relacionamento com NFINFRECEB, é possível identificar todas as notas fiscais que utilizam cada forma de recebimento.

**Campos de junção:**
- `CFORRECEB.FRCCODIGO` → `NFINFRECEB.FRCCODIGO` → `NFINFRECEB.NFCODIGO + EMPCODIGO` → `NOTAS.NFCODIGO + EMPCODIGO`

**Uso:** Análises de recebimentos por forma de pagamento em notas fiscais, relatórios financeiros por forma de recebimento.

---

### Via PEDINFRECEB → PEDID (Pedidos)

**Fluxo:** CFORRECEB → PEDINFRECEB → PEDID

**Descrição:** Através do relacionamento com PEDINFRECEB, é possível identificar todos os pedidos que utilizam cada forma de recebimento.

**Campos de junção:**
- `CFORRECEB.FRCCODIGO` → `PEDINFRECEB.FRCCODIGO` → `PEDINFRECEB.ID_PEDIDO` → `PEDID.ID_PEDIDO`

**Uso:** Análises de recebimentos por forma de pagamento em pedidos, relatórios de vendas por forma de pagamento.

---

### Via PCTINFRECEB → PCTCLI (Parcelas de Cliente)

**Fluxo:** CFORRECEB → PCTINFRECEB → PCTCLI

**Descrição:** Através do relacionamento com PCTINFRECEB, é possível identificar todas as parcelas de clientes que utilizam cada forma de recebimento.

**Campos de junção:**
- `CFORRECEB.FRCCODIGO` → `PCTINFRECEB.FRCCODIGO` → `PCTINFRECEB.PCTNUMERO` → `PCTCLI.PCTNUMERO`

**Uso:** Análises de recebimentos parcelados por forma de pagamento, controle de parcelas de clientes.

---

### Via CFORRECEBCONTA → CONTA (Contas Bancárias)

**Fluxo:** CFORRECEB → CFORRECEBCONTA → CONTA

**Descrição:** Através do relacionamento com CFORRECEBCONTA, é possível identificar as contas bancárias configuradas para cada forma de recebimento.

**Campos de junção:**
- `CFORRECEB.FRCCODIGO` → `CFORRECEBCONTA.FRCCODIGO` → `CFORRECEBCONTA.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CONTA.BCOCODIGO + CTANRCONTA + EMPCCORR`

**Uso:** Configuração de depósitos automáticos por forma de recebimento, integração bancária.

---

### Via CFORRECEBCONTA → CONTA → BANCO (Bancos)

**Fluxo:** CFORRECEB → CFORRECEBCONTA → CONTA → BANCO

**Descrição:** Através do relacionamento com CFORRECEBCONTA e CONTA, é possível identificar os bancos relacionados a cada forma de recebimento.

**Campos de junção:**
- `CFORRECEB.FRCCODIGO` → `CFORRECEBCONTA.FRCCODIGO` → `CFORRECEBCONTA.BCOCODIGO` → `CONTA.BCOCODIGO` → `BANCO.BCOCODIGO`

**Uso:** Análises de recebimentos por banco, relatórios de depósitos por forma de pagamento.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Forma de Recebimento

**Objetivo:** Obter visão completa de uma forma de recebimento incluindo todas as notas fiscais e pedidos que a utilizam.

**Fluxo:**
```
CFORRECEB (FRCCODIGO)
  ↓
NFINFRECEB (FRCCODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    cf.FRCDIAS AS PRAZO_DIAS,
    cf.FRCFORMAPAG AS CODIGO_FORMA_PAG,
    td.TPDDESC AS TIPO_DOCUMENTO,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(nfr.VALOR) AS VALOR_TOTAL_NOTAS,
    SUM(pfr.VALOR) AS VALOR_TOTAL_PEDIDOS,
    COUNT(DISTINCT nf.CLICODIGO) AS TOTAL_CLIENTES
FROM CFORRECEB cf
LEFT JOIN TPDOCTO td ON td.TPDCOD = cf.TPDCOD
LEFT JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN NOTAS nf ON nf.NFCODIGO = nfr.NFCODIGO 
    AND nf.EMPCODIGO = nfr.EMPCODIGO
LEFT JOIN PEDINFRECEB pfr ON pfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PEDID pd ON pd.ID_PEDIDO = pfr.ID_PEDIDO
WHERE cf.FRCCODIGO = ?
GROUP BY cf.FRCCODIGO, cf.FRCDESC, cf.FRCDIAS, cf.FRCFORMAPAG, td.TPDDESC;
```

---

### Exemplo 2: Análise de Formas de Recebimento por Cliente

**Objetivo:** Identificar quais formas de recebimento são mais utilizadas por cada cliente.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
NOTAS (CLICODIGO)
  ↓
NFINFRECEB (NFCODIGO, EMPCODIGO)
  ↓
CFORRECEB (FRCCODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    SUM(nfr.VALOR) AS VALOR_TOTAL,
    AVG(nfr.VALOR) AS VALOR_MEDIO
FROM CLIEN c
INNER JOIN NOTAS nf ON nf.CLICODIGO = c.CLICODIGO
INNER JOIN NFINFRECEB nfr ON nfr.NFCODIGO = nf.NFCODIGO 
    AND nfr.EMPCODIGO = nf.EMPCODIGO
INNER JOIN CFORRECEB cf ON cf.FRCCODIGO = nfr.FRCCODIGO
WHERE c.CLICODIGO = ?
GROUP BY c.CLICODIGO, c.CLINOMEFANT, cf.FRCCODIGO, cf.FRCDESC
ORDER BY VALOR_TOTAL DESC;
```

---

### Exemplo 3: Análise de Formas de Recebimento por Período

**Objetivo:** Analisar evolução do uso de formas de recebimento ao longo do tempo.

**Fluxo:**
```
CFORRECEB (FRCCODIGO)
  ↓
NFINFRECEB (FRCCODIGO)
  ↓
NOTAS (NFCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    EXTRACT(YEAR FROM nf.NFDTEMIS) AS ANO,
    EXTRACT(MONTH FROM nf.NFDTEMIS) AS MES,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT nfr.SEQ) AS TOTAL_RECEBIMENTOS,
    SUM(nfr.VALOR) AS VALOR_TOTAL,
    AVG(nfr.VALOR) AS VALOR_MEDIO
FROM CFORRECEB cf
INNER JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
INNER JOIN NOTAS nf ON nf.NFCODIGO = nfr.NFCODIGO 
    AND nf.EMPCODIGO = nfr.EMPCODIGO
WHERE nf.NFDTEMIS BETWEEN ? AND ?
GROUP BY cf.FRCCODIGO, cf.FRCDESC, 
    EXTRACT(YEAR FROM nf.NFDTEMIS), 
    EXTRACT(MONTH FROM nf.NFDTEMIS)
ORDER BY ANO DESC, MES DESC, VALOR_TOTAL DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Forma de Recebimento

**Objetivo:** Obter informações completas de uma forma de recebimento específica.

```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS DESCRICAO,
    cf.FRCDIAS AS PRAZO_DIAS,
    CASE 
        WHEN cf.FRCDIAS = 0 THEN 'À Vista'
        ELSE CONCAT(cf.FRCDIAS, ' dias')
    END AS PRAZO_FORMATADO,
    cf.FRCATIVO AS STATUS,
    td.TPDDESC AS TIPO_DOCUMENTO,
    cf.FRCFORMAPAG AS CODIGO_FORMA_PAG,
    cf.FRCTPINTEGRA AS TIPO_INTEGRACAO
FROM CFORRECEB cf
LEFT JOIN TPDOCTO td ON td.TPDCOD = cf.TPDCOD
WHERE cf.FRCCODIGO = ?;
```

---

### 2. Listar Formas de Recebimento Ativas

**Objetivo:** Obter todas as formas de recebimento disponíveis para uso.

```sql
SELECT
    FRCCODIGO,
    FRCDESC AS DESCRICAO,
    FRCDIAS AS PRAZO_DIAS,
    CASE 
        WHEN FRCDIAS = 0 THEN 'À Vista'
        ELSE CONCAT(FRCDIAS, ' dias')
    END AS PRAZO_FORMATADO,
    FRCFORMAPAG AS CODIGO_FORMA_PAG,
    FRCTPINTEGRA AS TIPO_INTEGRACAO
FROM CFORRECEB
WHERE FRCATIVO = 'S'
ORDER BY FRCDIAS, FRCDESC;
```

---

### 3. Análise de Uso de Formas de Recebimento

**Objetivo:** Identificar quais formas de recebimento são mais utilizadas.

```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    COUNT(DISTINCT nfr.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT pfr.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pct.PCTNUMERO) AS TOTAL_PARCELAS,
    COALESCE(SUM(nfr.VALOR), 0) + COALESCE(SUM(pfr.VALOR), 0) + COALESCE(SUM(pct.VALOR), 0) AS VALOR_TOTAL
FROM CFORRECEB cf
LEFT JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PEDINFRECEB pfr ON pfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PCTINFRECEB pct ON pct.FRCCODIGO = cf.FRCCODIGO
GROUP BY cf.FRCCODIGO, cf.FRCDESC
ORDER BY VALOR_TOTAL DESC;
```

---

### 4. Relatório de Recebimentos por Forma e Cliente

**Objetivo:** Analisar recebimentos agrupados por forma de recebimento e cliente.

```sql
SELECT
    c.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    SUM(nfr.VALOR) AS VALOR_TOTAL,
    AVG(nfr.VALOR) AS VALOR_MEDIO,
    MIN(nf.NFDTEMIS) AS PRIMEIRA_NOTA,
    MAX(nf.NFDTEMIS) AS ULTIMA_NOTA
FROM CLIEN c
INNER JOIN NOTAS nf ON nf.CLICODIGO = c.CLICODIGO
INNER JOIN NFINFRECEB nfr ON nfr.NFCODIGO = nf.NFCODIGO 
    AND nfr.EMPCODIGO = nf.EMPCODIGO
INNER JOIN CFORRECEB cf ON cf.FRCCODIGO = nfr.FRCCODIGO
WHERE nf.NFDTEMIS BETWEEN ? AND ?
GROUP BY c.CLICODIGO, c.CLINOMEFANT, cf.FRCCODIGO, cf.FRCDESC
ORDER BY VALOR_TOTAL DESC;
```

---

### 5. Análise de Formas de Recebimento Não Utilizadas

**Objetivo:** Identificar formas de recebimento que não estão sendo utilizadas.

```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    cf.FRCATIVO AS STATUS,
    COUNT(DISTINCT nfr.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT pfr.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pct.PCTNUMERO) AS TOTAL_PARCELAS
FROM CFORRECEB cf
LEFT JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PEDINFRECEB pfr ON pfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PCTINFRECEB pct ON pct.FRCCODIGO = cf.FRCCODIGO
GROUP BY cf.FRCCODIGO, cf.FRCDESC, cf.FRCATIVO
HAVING COUNT(DISTINCT nfr.NFCODIGO) = 0
   AND COUNT(DISTINCT pfr.ID_PEDIDO) = 0
   AND COUNT(DISTINCT pct.PCTNUMERO) = 0
ORDER BY cf.FRCCODIGO;
```

---

### 6. Relatório de Recebimentos por Forma e Período

**Objetivo:** Analisar recebimentos agrupados por forma de recebimento e período.

```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    EXTRACT(YEAR FROM nf.NFDTEMIS) AS ANO,
    EXTRACT(MONTH FROM nf.NFDTEMIS) AS MES,
    COUNT(DISTINCT nf.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT nfr.SEQ) AS TOTAL_RECEBIMENTOS,
    SUM(nfr.VALOR) AS VALOR_TOTAL,
    AVG(nfr.VALOR) AS VALOR_MEDIO,
    MIN(nfr.VALOR) AS VALOR_MINIMO,
    MAX(nfr.VALOR) AS VALOR_MAXIMO
FROM CFORRECEB cf
INNER JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
INNER JOIN NOTAS nf ON nf.NFCODIGO = nfr.NFCODIGO 
    AND nf.EMPCODIGO = nfr.EMPCODIGO
WHERE nf.NFDTEMIS BETWEEN ? AND ?
GROUP BY cf.FRCCODIGO, cf.FRCDESC, 
    EXTRACT(YEAR FROM nf.NFDTEMIS), 
    EXTRACT(MONTH FROM nf.NFDTEMIS)
ORDER BY ANO DESC, MES DESC, VALOR_TOTAL DESC;
```

---

### 7. Análise de Formas de Recebimento com Contas Bancárias Configuradas

**Objetivo:** Verificar quais formas de recebimento têm contas bancárias configuradas.

```sql
SELECT
    cf.FRCCODIGO,
    cf.FRCDESC AS FORMA_RECEBIMENTO,
    COUNT(DISTINCT crc.BCOCODIGO) AS TOTAL_CONTAS_BANCARIAS,
    STRING_AGG(DISTINCT b.BCONOME, ', ') AS BANCOS,
    STRING_AGG(DISTINCT c.CTANRCONTA, ', ') AS NUMEROS_CONTAS
FROM CFORRECEB cf
LEFT JOIN CFORRECEBCONTA crc ON crc.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN CONTA c ON c.BCOCODIGO = crc.BCOCODIGO
    AND c.CTANRCONTA = crc.CTANRCONTA
    AND c.EMPCCORR = crc.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
GROUP BY cf.FRCCODIGO, cf.FRCDESC
ORDER BY TOTAL_CONTAS_BANCARIAS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CFORRECEB | Tipo |
|--------|-----------|-------------------------|------|
| **CFORRECEB** | 3 | 1:1 | **TABELA PRINCIPAL** |
| NFINFRECEB | 1.051.559 | ~350k:1 | Recebimentos em notas fiscais |
| PEDINFRECEB | 2.269.119 | ~756k:1 | Recebimentos em pedidos |
| PCTINFRECEB | 1.301 | ~433:1 | Recebimentos em parcelas |
| CFORRECEBCONTA | 0 | 0:1 | Contas bancárias (não configuradas) |
| TXCARTAO | 0 | 0:1 | Taxas de cartão (não configuradas) |
| OCDUP | 0 | 0:1 | Duplicatas de orçamento (não utilizadas) |

**Interpretação:**
- **Apenas 3 formas de recebimento** cadastradas - configuração básica
- **Amplamente utilizadas** em notas fiscais e pedidos
- **Formas de recebimento essenciais** para operações financeiras
- Tabela pequena mas crítica para o sistema financeiro

**Distribuição Esperada:**
- Formas básicas: Dinheiro (à vista), Cartão, Boleto/Parcelado
- Cada forma pode ter múltiplas configurações (contas bancárias, taxas)

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **FRCCODIGO** | CFORRECEB | Chave primária (PK) |
| **FRCCODIGO** | [7 tabelas] → CFORRECEB | Referência à forma de recebimento (FK) |
| **FRCDESC** | CFORRECEB | Descrição da forma (exibição) |
| **FRCDIAS** | CFORRECEB | Prazo em dias (cálculo de vencimento) |
| **TPDCOD** | CFORRECEB → TPDOCTO | Tipo de documento relacionado |
| **FRCFORMAPAG** | CFORRECEB | Código da forma de pagamento |
| **FRCTPINTEGRA** | CFORRECEB | Tipo de integração |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CFORRECEB.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por status** - Para buscas de formas ativas
3. **Índice em descrição** - Para buscas textuais (se necessário)
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CFORRECEB

### Índices Sugeridos

```sql
-- Índice 1: Busca por status ativo (consultas frequentes)
CREATE INDEX IDX_CFORRECEB_ATIVO ON CFORRECEB(FRCATIVO) WHERE FRCATIVO = 'S';

-- Índice 2: Busca por tipo de integração
CREATE INDEX IDX_CFORRECEB_INTEGRACAO ON CFORRECEB(FRCTPINTEGRA);

-- Índice 3: Busca por forma de pagamento
CREATE INDEX IDX_CFORRECEB_FORMA_PAG ON CFORRECEB(FRCFORMAPAG);
```

### Observações sobre Volume

- **Tabela muito pequena** (3 registros) - Performance não é crítica
- **Consultas são instantâneas** devido ao volume mínimo
- **Cache útil** - Tabela pode ser mantida em memória permanentemente
- **Focar em índices nas tabelas relacionadas** - NFINFRECEB e PEDINFRECEB têm volumes grandes

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK)
SELECT FRCCODIGO, FRCDESC, FRCDIAS
FROM CFORRECEB
WHERE FRCCODIGO = ?;

-- ✅ OTIMIZADO (usar índice por status)
SELECT FRCCODIGO, FRCDESC, FRCDIAS
FROM CFORRECEB
WHERE FRCATIVO = 'S'
ORDER BY FRCDIAS, FRCDESC;

-- ✅ OTIMIZADO (JOIN com tabela pequena é instantâneo)
SELECT cf.*, COUNT(nfr.SEQ) AS TOTAL_RECEBIMENTOS
FROM CFORRECEB cf
LEFT JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
GROUP BY cf.FRCCODIGO, cf.FRCDESC, cf.FRCDIAS;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar recebimentos sem forma válida
SELECT nfr.*
FROM NFINFRECEB nfr
LEFT JOIN CFORRECEB cf ON cf.FRCCODIGO = nfr.FRCCODIGO
WHERE nfr.FRCCODIGO IS NOT NULL
  AND cf.FRCCODIGO IS NULL;

-- Verificar formas de recebimento não utilizadas
SELECT cf.*
FROM CFORRECEB cf
LEFT JOIN NFINFRECEB nfr ON nfr.FRCCODIGO = cf.FRCCODIGO
LEFT JOIN PEDINFRECEB pfr ON pfr.FRCCODIGO = cf.FRCCODIGO
WHERE nfr.FRCCODIGO IS NULL
  AND pfr.FRCCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CFORRECEB
WHERE FRCCODIGO IS NULL
   OR FRCDESC IS NULL
   OR FRCDESC = ''
   OR FRCDIAS IS NULL
   OR FRCATIVO IS NULL
   OR TPDCOD IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT FRCCODIGO, COUNT(*) AS QTD
FROM CFORRECEB
GROUP BY FRCCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos
SELECT *
FROM CFORRECEB
WHERE FRCDIAS < 0
   OR FRCATIVO NOT IN ('S', 'N');
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por prazo
SELECT
    CASE 
        WHEN FRCDIAS = 0 THEN 'À Vista'
        WHEN FRCDIAS <= 30 THEN 'Curto Prazo (até 30 dias)'
        WHEN FRCDIAS <= 90 THEN 'Médio Prazo (31 a 90 dias)'
        ELSE 'Longo Prazo (acima de 90 dias)'
    END AS CATEGORIA_PRAZO,
    COUNT(*) AS TOTAL_FORMAS,
    COUNT(CASE WHEN FRCATIVO = 'S' THEN 1 END) AS FORMAS_ATIVAS
FROM CFORRECEB
GROUP BY 
    CASE 
        WHEN FRCDIAS = 0 THEN 'À Vista'
        WHEN FRCDIAS <= 30 THEN 'Curto Prazo (até 30 dias)'
        WHEN FRCDIAS <= 90 THEN 'Médio Prazo (31 a 90 dias)'
        ELSE 'Longo Prazo (acima de 90 dias)'
    END;

-- Verificar distribuição por tipo de integração
SELECT
    FRCTPINTEGRA AS TIPO_INTEGRACAO,
    COUNT(*) AS TOTAL_FORMAS,
    COUNT(CASE WHEN FRCATIVO = 'S' THEN 1 END) AS FORMAS_ATIVAS,
    STRING_AGG(FRCDESC, ', ') AS FORMAS
FROM CFORRECEB
GROUP BY FRCTPINTEGRA
ORDER BY TOTAL_FORMAS DESC;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Existente

O modelo `FirebirdCforreceb` já existe em `app/Models/Firebird/FirebirdCforreceb.php` e inclui:

**Funcionalidades Implementadas:**
- ✅ Métodos de verificação (isActive, hasTerm, isCash)
- ✅ Métodos de descrição (getPaymentFormDescription, getIntegrationTypeDescription)
- ✅ Métodos de cálculo (getPaymentDeadline)
- ✅ Scopes para filtros comuns (active, inactive, cash, term, byDescription)

**Melhorias Sugeridas:**

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

final class FirebirdCforreceb extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CFORRECEB';
    
    protected $primaryKey = 'FRCCODIGO';
    public $incrementing = true;
    protected $keyType = 'int';

    protected $casts = [
        'FRCCODIGO' => 'integer',
        'FRCDESC' => 'string',
        'FRCDIAS' => 'integer',
        'FRCATIVO' => 'string',
        'TPDCOD' => 'string',
        'FRCFORMAPAG' => 'string',
        'FRCTPINTEGRA' => 'string',
        'FRCCNPJCARTAO' => 'string',
        'FRCBANDCARTAO' => 'string',
    ];

    // Relacionamento com TPDOCTO
    public function tipoDocumento(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpdocto::class, 'TPDCOD', 'TPDCOD');
    }

    // Relacionamento com NFINFRECEB
    public function recebimentosNotas(): HasMany
    {
        return $this->hasMany(FirebirdNfinfreceb::class, 'FRCCODIGO', 'FRCCODIGO');
    }

    // Relacionamento com PEDINFRECEB
    public function recebimentosPedidos(): HasMany
    {
        return $this->hasMany(FirebirdPedinfreceb::class, 'FRCCODIGO', 'FRCCODIGO');
    }

    // Relacionamento com PCTINFRECEB
    public function recebimentosParcelas(): HasMany
    {
        return $this->hasMany(FirebirdPctinfreceb::class, 'FRCCODIGO', 'FRCCODIGO');
    }

    // Relacionamento com CFORRECEBCONTA
    public function contasBancarias(): HasMany
    {
        return $this->hasMany(FirebirdCforrecebconta::class, 'FRCCODIGO', 'FRCCODIGO');
    }

    // Relacionamento com TXCARTAO
    public function taxasCartao(): HasMany
    {
        return $this->hasMany(FirebirdTxcartao::class, 'FRCCODIGO', 'FRCCODIGO');
    }

    // Relacionamento com notas fiscais (via NFINFRECEB)
    public function notasFiscais(): HasManyThrough
    {
        return $this->hasManyThrough(
            FirebirdNotas::class,
            FirebirdNfinfreceb::class,
            'FRCCODIGO', // FK em NFINFRECEB
            'NFCODIGO', // FK em NOTAS
            'FRCCODIGO', // PK em CFORRECEB
            'NFCODIGO' // PK em NFINFRECEB
        );
    }

    // Relacionamento com pedidos (via PEDINFRECEB)
    public function pedidos(): HasManyThrough
    {
        return $this->hasManyThrough(
            FirebirdPedido::class,
            FirebirdPedinfreceb::class,
            'FRCCODIGO', // FK em PEDINFRECEB
            'ID_PEDIDO', // FK em PEDID
            'FRCCODIGO', // PK em CFORRECEB
            'ID_PEDIDO' // PK em PEDINFRECEB
        );
    }

    // Método para obter total de uso
    public function getTotalUso(): int
    {
        return $this->recebimentosNotas()->count() 
            + $this->recebimentosPedidos()->count()
            + $this->recebimentosParcelas()->count();
    }

    // Método para obter valor total recebido
    public function getValorTotalRecebido(): float
    {
        $valorNotas = $this->recebimentosNotas()->sum('VALOR') ?? 0;
        $valorPedidos = $this->recebimentosPedidos()->sum('VALOR') ?? 0;
        $valorParcelas = $this->recebimentosParcelas()->sum('VALOR') ?? 0;
        
        return $valorNotas + $valorPedidos + $valorParcelas;
    }

    // Scope para formas mais utilizadas
    public function scopeMaisUtilizadas($query, int $limit = 10)
    {
        return $query->withCount([
            'recebimentosNotas',
            'recebimentosPedidos',
            'recebimentosParcelas'
        ])
        ->orderByRaw('(recebimentos_notas_count + recebimentos_pedidos_count + recebimentos_parcelas_count) DESC')
        ->limit($limit);
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Tabela pequena** - Apenas 3 registros, configuração básica
2. **Formas padrão** - Dinheiro, Cartão, Boleto/Parcelado
3. **Validação obrigatória** - Forma deve estar cadastrada antes de uso
4. **Status ativo** - Controlar disponibilidade de formas

### Segurança

1. **Dados financeiros críticos** - Não permitir alterações sem auditoria
2. **Validação de prazos** - Verificar valores válidos de dias
3. **Acesso restrito** - Limitar alterações a usuários autorizados
4. **Auditoria** - Registrar todas as alterações em formas de recebimento

### Performance

1. **Tabela muito pequena** - Não requer otimização especial (3 registros)
2. **Cache útil** - Pode ser mantida em memória permanentemente
3. **Índices nas tabelas relacionadas** - Mais importante que índices em CFORRECEB
4. **Consultas simples** - Queries são instantâneas devido ao volume mínimo

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código já existe
2. **Verificar duplicatas** - PK garante unicidade
3. **Manter consistência** - Garantir que formas referenciadas existem
4. **Backup regular** - Tabela crítica para operações financeiras

### Manutenção

1. **Revisão periódica** - Verificar formas não utilizadas
2. **Atualização de configurações** - Manter informações de integração atualizadas
3. **Documentação** - Documentar configurações de integração bancária
4. **Testes** - Validar formas antes de usar em produção

### Regras de Negócio

1. **Forma obrigatória** - Todas as operações financeiras devem ter forma de recebimento
2. **Validação em tempo real** - Verificar se forma existe e está ativa antes de usar
3. **Consistência** - Forma deve corresponder ao tipo de operação
4. **Prazo válido** - Dias devem ser >= 0

### Observações Especiais

1. **Tabela básica** - Apenas 3 formas configuradas (configuração mínima)
2. **Amplamente utilizada** - Presente em milhões de registros de recebimentos
3. **Configurações futuras** - CFORRECEBCONTA e TXCARTAO preparadas para uso futuro
4. **Integração bancária** - Suporte a diferentes tipos de integração (Bancário, Cartão, PIX)

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

