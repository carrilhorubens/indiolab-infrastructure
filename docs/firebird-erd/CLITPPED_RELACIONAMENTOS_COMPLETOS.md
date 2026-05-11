# CLITPPED - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLITPPED (Cliente x Tipo de Pedido)
- **Total de Registros**: 4.439
- **Total de Colunas**: 13
- **Chave Primária**: (CLICODIGO, TPCODIGO) - Composta
- **Chaves Estrangeiras**: 1 (formal)
- **Índices**: 0
- **Tabelas Dependentes**: 10 (CTPPRO, CTPTBP, CTPTBPE, CTPCOMBPROPRO, CTPCOMBPROSER, etc.)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLITPPED** é uma tabela de configuração central que associa clientes a tipos de pedido com configurações financeiras, operacionais e comerciais detalhadas. Com **4.439 registros**, representa configurações extensivas de tipos de pedido por cliente, permitindo personalização completa do processo de pedidos.

Esta tabela funciona como **configurador central de tipos de pedido por cliente** e permite:
- Associar clientes a tipos de pedido específicos
- Configurar formas de pagamento por tipo de pedido-cliente
- Configurar tabelas de fechamento por tipo de pedido-cliente
- Configurar bancos e contas bancárias por tipo de pedido-cliente
- Controlar status e descontos por tipo de pedido-cliente
- Configurar vendedores e percentuais de faturamento
- Suportar múltiplas configurações por cliente

Cada registro representa uma configuração específica de tipo de pedido para um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Identificação do tipo de pedido (TPCODIGO)
- Configurações financeiras (PGTCODIGO, TBFCODIGO, BCOCODIGO, COBCODIGO)
- Status da configuração (CTPSTATUS)
- Descontos (CTPPCDESCTO, CTPPCDESCTOSER)
- Vendedores (FUNCODIGO, FUNCODIGO2)
- Percentuais de faturamento (CTPPERCFATPROD, CTPPERCFATSER)

O sistema utiliza esta tabela como ponto central para determinar todas as configurações aplicáveis quando um cliente cria um pedido de um tipo específico, permitindo personalização completa do processo comercial.

**Observação Importante:** CLITPPED é uma tabela intermediária central que é referenciada por 10 tabelas dependentes (CTPPRO, CTPTBP, CTPTBPE, CTPCOMBPROPRO, CTPCOMBPROSER, etc.). Com 4.439 registros, indica uso extensivo de configuração de tipos de pedido por cliente, essencial para personalização comercial.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **TPCODIGO** 🔑 | SMALLINT | ✓ | Código do tipo de pedido (PK, lógica → TPPEDID) |

### Configurações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PGTCODIGO** | SMALLINT | | Código da forma de pagamento (lógica → PLPTO) |
| **TBFCODIGO** | SMALLINT | | Código da tabela de fechamento (lógica → TBFECHA) |
| **BCOCODIGO** | SMALLINT | | Código do banco (lógica → BANCO) |
| **COBCODIGO** | VARCHAR(14) | | Código da conta bancária/cobrança (lógica → BCOCOB) |

### Status e Descontos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTPSTATUS** | VARCHAR(14) | ✓ | Status da configuração (ex: "ATIVO", "INATIVO") |
| **CTPPCDESCTO** | NUMERIC(16,4) | | Percentual de desconto para produtos |
| **CTPPCDESCTOSER** | NUMERIC(16,4) | | Percentual de desconto para serviços |

### Vendedores
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FUNCODIGO** | INTEGER | | Código do vendedor/funcionário principal (lógica → FUNCIO) |
| **FUNCODIGO2** | INTEGER | | Código do vendedor/funcionário secundário (lógica → FUNCIO) |

### Percentuais de Faturamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTPPERCFATPROD** | NUMERIC(16,4) | | Percentual de faturamento para produtos |
| **CTPPERCFATSER** | NUMERIC(16,4) | | Percentual de faturamento para serviços |

**Primary Key:** (CLICODIGO, TPCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente que terá a configuração de tipo de pedido.
- **TPCODIGO**: Tipo de pedido que será configurado para o cliente.
- **PGTCODIGO**: Forma de pagamento padrão para este tipo de pedido-cliente.
- **TBFCODIGO**: Tabela de fechamento padrão para este tipo de pedido-cliente.
- **BCOCODIGO**: Banco padrão para este tipo de pedido-cliente.
- **COBCODIGO**: Conta bancária/cobrança padrão para este tipo de pedido-cliente.
- **CTPSTATUS**: Status da configuração (controla se está ativa ou não).
- **CTPPCDESCTO, CTPPCDESCTOSER**: Descontos padrão para produtos e serviços.
- **FUNCODIGO, FUNCODIGO2**: Vendedores associados a este tipo de pedido-cliente.
- **CTPPERCFATPROD, CTPPERCFATSER**: Percentuais de faturamento para produtos e serviços.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLITPPED Referencia (1 FK Formal):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLITPPED.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLITPPED
```

**Descrição**: Cada configuração está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente da configuração, relatórios de configurações por cliente.

---

### CLITPPED é Referenciada Por (10 tabelas):

#### 1. CTPPRO - Configurações de Produtos por Tipo de Pedido
**Relacionamento:**
```
CTPPRO.CLICODIGO, CTPPRO.TPCODIGO → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPPRO
```

**Descrição**: CTPPRO referencia CLITPPED para obter a configuração base e adicionar configurações específicas de produtos.

**Informações da Tabela CTPPRO:**
- **Total:** 105 registros
- **PK:** (CLICODIGO, TPCODIGO, PROCODIGO)
- **Colunas:** 9 campos

**Uso:** CTPPRO estende CLITPPED com configurações específicas de produtos (preços, índices).

---

#### 2. CTPTBP - Configurações de Tabelas de Preço por Tipo de Pedido
**Relacionamento:**
```
CTPTBP.CLICODIGO, CTPTBP.TPCODIGO → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPTBP
```

**Descrição**: CTPTBP referencia CLITPPED para obter a configuração base e adicionar configurações específicas de tabelas de preço.

**Informações da Tabela CTPTBP:**
- **Total:** 7.909 registros
- **PK:** (CLICODIGO, TPCODIGO, TBPCODIGO)
- **Colunas:** 9 campos

**Uso:** CTPTBP estende CLITPPED com configurações específicas de tabelas de preço.

---

#### 3. CTPTBPE - Configurações de Tabelas de Preço Especiais
**Relacionamento:**
```
CTPTBPE.CLICODIGO, CTPTBPE.TPCODIGO → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPTBPE
```

**Descrição**: CTPTBPE referencia CLITPPED para configurações especiais de tabelas de preço.

**Informações da Tabela CTPTBPE:**
- **Total:** 0 registros
- **PK:** (CLICODIGO, TPCODIGO, TBPCODIGO)
- **Colunas:** 4 campos

**Uso:** CTPTBPE estende CLITPPED com configurações especiais de tabelas de preço (não utilizado atualmente).

---

#### 4. CTPCOMBPROPRO - Combinações Produto-Produto por Tipo de Pedido
**Relacionamento:**
```
CTPCOMBPROPRO.CLICODIGO, CTPCOMBPROPRO.CCPTPPEDID → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPCOMBPROPRO
```

**Descrição**: CTPCOMBPROPRO referencia CLITPPED para obter a configuração base e adicionar combinações produto-produto.

**Informações da Tabela CTPCOMBPROPRO:**
- **Total:** 29.510 registros
- **PK:** (CLICODIGO, PROCODIGOA, PROCODIGOB, CCPTPPEDID)
- **Colunas:** 13 campos

**Uso:** CTPCOMBPROPRO estende CLITPPED com combinações produto-produto específicas.

---

#### 5. CTPCOMBPROSER - Combinações Produto-Serviço por Tipo de Pedido
**Relacionamento:**
```
CTPCOMBPROSER.CLICODIGO, CTPCOMBPROSER.CCPTPPEDID → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPCOMBPROSER
```

**Descrição**: CTPCOMBPROSER referencia CLITPPED para obter a configuração base e adicionar combinações produto-serviço.

**Informações da Tabela CTPCOMBPROSER:**
- **Total:** 0 registros
- **PK:** (CLICODIGO, PROCODIGO, SERCODIGO, CCPTPPEDID)
- **Colunas:** 11 campos

**Uso:** CTPCOMBPROSER estende CLITPPED com combinações produto-serviço (não utilizado atualmente).

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLITPPED → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que utilizam as configurações de tipo de pedido.

**Uso:** Aplicar configurações em pedidos, análises de pedidos considerando configurações de tipo.

---

### Via TPCODIGO → TPPEDID (Tipos de Pedido)

**Fluxo:** CLITPPED → TPCODIGO (lógico) → TPPEDID

**Descrição:** Através do código do tipo de pedido, é possível identificar informações do tipo de pedido.

**Uso:** Obter informações do tipo de pedido, validar configurações.

---

### Via PGTCODIGO → PLPTO (Formas de Pagamento)

**Fluxo:** CLITPPED → PGTCODIGO (lógico) → PLPTO

**Descrição:** Através do código da forma de pagamento, é possível identificar informações da forma de pagamento.

**Uso:** Obter informações da forma de pagamento padrão.

---

### Via TBFCODIGO → TBFECHA (Tabelas de Fechamento)

**Fluxo:** CLITPPED → TBFCODIGO (lógico) → TBFECHA

**Descrição:** Através do código da tabela de fechamento, é possível identificar informações da tabela.

**Uso:** Obter informações da tabela de fechamento padrão.

---

### Via BCOCODIGO → BANCO (Bancos)

**Fluxo:** CLITPPED → BCOCODIGO (lógico) → BANCO

**Descrição:** Através do código do banco, é possível identificar informações do banco.

**Uso:** Obter informações do banco padrão.

---

### Via FUNCODIGO → FUNCIO (Funcionários/Vendedores)

**Fluxo:** CLITPPED → FUNCODIGO (lógico) → FUNCIO

**Descrição:** Através do código do funcionário, é possível identificar informações do vendedor.

**Uso:** Obter informações dos vendedores associados.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração Cliente-Tipo de Pedido

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente e todas as configurações relacionadas.

**Fluxo:**
```
CLITPPED (CLICODIGO, TPCODIGO, PGTCODIGO, TBFCODIGO, BCOCODIGO, etc.)
  ↓
CLIEN (CLICODIGO)
  ↓
TPPEDID (TPCODIGO - lógico)
  ↓
PLPTO (PGTCODIGO - lógico)
  ↓
TBFECHA (TBFCODIGO - lógico)
  ↓
BANCO (BCOCODIGO - lógico)
```

**Query SQL:**
```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    ctp.PGTCODIGO,
    pgt.PGTDESCRICAO AS FORMA_PAGAMENTO,
    ctp.TBFCODIGO,
    tbf.TBFDESCRICAO AS TABELA_FECHAMENTO,
    ctp.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ctp.COBCODIGO AS CONTA_COBRANCA,
    ctp.CTPPCDESCTO AS DESCONTO_PRODUTOS,
    ctp.CTPPCDESCTOSER AS DESCONTO_SERVICOS,
    ctp.FUNCODIGO AS VENDEDOR_PRINCIPAL,
    fun1.FUNNOME AS NOME_VENDEDOR_PRINCIPAL,
    ctp.FUNCODIGO2 AS VENDEDOR_SECUNDARIO,
    fun2.FUNNOME AS NOME_VENDEDOR_SECUNDARIO,
    ctp.CTPPERCFATPROD AS PERCENTUAL_FATURAMENTO_PRODUTOS,
    ctp.CTPPERCFATSER AS PERCENTUAL_FATURAMENTO_SERVICOS
FROM CLITPPED ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = ctp.PGTCODIGO
LEFT JOIN TBFECHA tbf ON tbf.TBFCODIGO = ctp.TBFCODIGO
LEFT JOIN BANCO bc ON bc.BCOCODIGO = ctp.BCOCODIGO
LEFT JOIN FUNCIO fun1 ON fun1.FUNCODIGO = ctp.FUNCODIGO
LEFT JOIN FUNCIO fun2 ON fun2.FUNCODIGO = ctp.FUNCODIGO2
WHERE ctp.CLICODIGO = ?
  AND ctp.TPCODIGO = ?;
```

---

### Exemplo 2: Análise de Configurações com Tabelas Dependentes

**Objetivo:** Obter configuração completa incluindo todas as tabelas dependentes.

**Fluxo:**
```
CLITPPED (CLICODIGO, TPCODIGO)
  ↓
CTPPRO (CLICODIGO, TPCODIGO)
  ↓
CTPTBP (CLICODIGO, TPCODIGO)
  ↓
CTPCOMBPROPRO (CLICODIGO, CCPTPPEDID)
```

**Query SQL:**
```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    COUNT(DISTINCT ctp_pro.PROCODIGO) AS TOTAL_PRODUTOS_CONFIGURADOS,
    COUNT(DISTINCT ctp_tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO_CONFIGURADAS,
    COUNT(DISTINCT ctp_comb.PROCODIGOA || '-' || ctp_comb.PROCODIGOB) AS TOTAL_COMBINACOES_PRODUTO_PRODUTO
FROM CLITPPED ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPPRO ctp_pro ON ctp_pro.CLICODIGO = ctp.CLICODIGO
  AND ctp_pro.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPTBP ctp_tbp ON ctp_tbp.CLICODIGO = ctp.CLICODIGO
  AND ctp_tbp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPCOMBPROPRO ctp_comb ON ctp_comb.CLICODIGO = ctp.CLICODIGO
  AND ctp_comb.CCPTPPEDID = ctp.TPCODIGO
WHERE ctp.CLICODIGO = ?
GROUP BY ctp.CLICODIGO, cl.CLINOMEFANT, ctp.TPCODIGO, tp.TPDESCRICAO, ctp.CTPSTATUS;
```

---

### Exemplo 3: Análise de Configurações com Pedidos

**Objetivo:** Obter configurações com informações de pedidos relacionados.

**Fluxo:**
```
CLITPPED (CLICODIGO, TPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO, TPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS,
    AVG(pd.PEDVRMERC) AS VALOR_MEDIO_PEDIDOS
FROM CLITPPED ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = ctp.CLICODIGO
  AND pd.TPCODIGO = ctp.TPCODIGO
WHERE ctp.CTPSTATUS = 'ATIVO'
GROUP BY ctp.CLICODIGO, cl.CLINOMEFANT, ctp.TPCODIGO, tp.TPDESCRICAO, ctp.CTPSTATUS
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração Cliente-Tipo de Pedido

**Objetivo:** Obter a configuração completa de um tipo de pedido específico para um cliente.

```sql
SELECT
    CLICODIGO,
    TPCODIGO,
    PGTCODIGO AS FORMA_PAGAMENTO,
    TBFCODIGO AS TABELA_FECHAMENTO,
    BCOCODIGO AS BANCO,
    COBCODIGO AS CONTA_COBRANCA,
    CTPSTATUS AS STATUS,
    CTPPCDESCTO AS DESCONTO_PRODUTOS,
    CTPPCDESCTOSER AS DESCONTO_SERVICOS,
    FUNCODIGO AS VENDEDOR_PRINCIPAL,
    FUNCODIGO2 AS VENDEDOR_SECUNDARIO,
    CTPPERCFATPROD AS PERCENTUAL_FATURAMENTO_PRODUTOS,
    CTPPERCFATSER AS PERCENTUAL_FATURAMENTO_SERVICOS
FROM CLITPPED
WHERE CLICODIGO = ?
  AND TPCODIGO = ?;
```

---

### 2. Listar Todas as Configurações de um Cliente

**Objetivo:** Obter todas as configurações de tipos de pedido para um cliente específico.

```sql
SELECT
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    ctp.PGTCODIGO AS FORMA_PAGAMENTO,
    ctp.TBFCODIGO AS TABELA_FECHAMENTO,
    ctp.BCOCODIGO AS BANCO,
    ctp.CTPPCDESCTO AS DESCONTO_PRODUTOS,
    ctp.CTPPERCFATPROD AS PERCENTUAL_FATURAMENTO_PRODUTOS
FROM CLITPPED ctp
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
WHERE ctp.CLICODIGO = ?
ORDER BY ctp.TPCODIGO;
```

---

### 3. Buscar Configurações Ativas por Cliente

**Objetivo:** Identificar configurações ativas de tipos de pedido para um cliente.

```sql
SELECT
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.PGTCODIGO AS FORMA_PAGAMENTO,
    ctp.TBFCODIGO AS TABELA_FECHAMENTO,
    ctp.BCOCODIGO AS BANCO,
    ctp.CTPPCDESCTO AS DESCONTO_PRODUTOS,
    ctp.CTPPERCFATPROD AS PERCENTUAL_FATURAMENTO_PRODUTOS
FROM CLITPPED ctp
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
WHERE ctp.CLICODIGO = ?
  AND ctp.CTPSTATUS = 'ATIVO'
ORDER BY ctp.TPCODIGO;
```

---

### 4. Análise de Tipos de Pedido Mais Configurados

**Objetivo:** Identificar tipos de pedido com mais configurações por cliente.

```sql
SELECT
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    COUNT(DISTINCT ctp.CLICODIGO) AS TOTAL_CLIENTES_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN ctp.CTPSTATUS = 'ATIVO' THEN 1 END) AS CONFIGURACOES_ATIVAS
FROM CLITPPED ctp
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
GROUP BY ctp.TPCODIGO, tp.TPDESCRICAO
ORDER BY TOTAL_CLIENTES_CONFIGURADOS DESC;
```

---

### 5. Análise de Configurações com Produtos Configurados

**Objetivo:** Obter configurações com informações de produtos configurados em CTPPRO.

```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    COUNT(DISTINCT ctp_pro.PROCODIGO) AS TOTAL_PRODUTOS_CONFIGURADOS
FROM CLITPPED ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPPRO ctp_pro ON ctp_pro.CLICODIGO = ctp.CLICODIGO
  AND ctp_pro.TPCODIGO = ctp.TPCODIGO
GROUP BY ctp.CLICODIGO, cl.CLINOMEFANT, ctp.TPCODIGO, tp.TPDESCRICAO, ctp.CTPSTATUS
ORDER BY TOTAL_PRODUTOS_CONFIGURADOS DESC;
```

---

### 6. Análise de Configurações com Tabelas de Preço

**Objetivo:** Obter configurações com informações de tabelas de preço configuradas em CTPTBP.

```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.CTPSTATUS AS STATUS,
    COUNT(DISTINCT ctp_tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO_CONFIGURADAS
FROM CLITPPED ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
LEFT JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPTBP ctp_tbp ON ctp_tbp.CLICODIGO = ctp.CLICODIGO
  AND ctp_tbp.TPCODIGO = ctp.TPCODIGO
GROUP BY ctp.CLICODIGO, cl.CLINOMEFANT, ctp.TPCODIGO, tp.TPDESCRICAO, ctp.CTPSTATUS
ORDER BY TOTAL_TABELAS_PRECO_CONFIGURADAS DESC;
```

---

### 7. Relatório Completo de Configurações por Cliente

**Objetivo:** Analisar distribuição completa de configurações incluindo todas as tabelas dependentes.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(DISTINCT ctp.TPCODIGO) AS TOTAL_TIPOS_PEDIDO_CONFIGURADOS,
    COUNT(DISTINCT ctp_pro.PROCODIGO) AS TOTAL_PRODUTOS_CONFIGURADOS,
    COUNT(DISTINCT ctp_tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO_CONFIGURADAS,
    COUNT(DISTINCT ctp_comb.PROCODIGOA || '-' || ctp_comb.PROCODIGOB) AS TOTAL_COMBINACOES_PRODUTO_PRODUTO,
    COUNT(CASE WHEN ctp.CTPSTATUS = 'ATIVO' THEN 1 END) AS CONFIGURACOES_ATIVAS
FROM CLIEN cl
LEFT JOIN CLITPPED ctp ON ctp.CLICODIGO = cl.CLICODIGO
LEFT JOIN CTPPRO ctp_pro ON ctp_pro.CLICODIGO = ctp.CLICODIGO
  AND ctp_pro.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPTBP ctp_tbp ON ctp_tbp.CLICODIGO = ctp.CLICODIGO
  AND ctp_tbp.TPCODIGO = ctp.TPCODIGO
LEFT JOIN CTPCOMBPROPRO ctp_comb ON ctp_comb.CLICODIGO = ctp.CLICODIGO
  AND ctp_comb.CCPTPPEDID = ctp.TPCODIGO
WHERE cl.CLICLIENTE = 'S'
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT
HAVING COUNT(DISTINCT ctp.TPCODIGO) > 0
ORDER BY TOTAL_TIPOS_PEDIDO_CONFIGURADOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLITPPED | Tipo |
|--------|-----------|---------------------|------|
| **CLITPPED** | 4.439 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 2.08:1 | Clientes (média de 0.48 configurações por cliente) |
| TPPEDID | 17 | 0.004:1 | Tipos de pedido (média de 261 configurações por tipo) |
| CTPPRO | 105 | 0.024:1 | Produtos configurados (média de 0.024 produtos por configuração) |
| CTPTBP | 7.909 | 1.78:1 | Tabelas de preço configuradas (média de 1.78 tabelas por configuração) |
| CTPCOMBPROPRO | 29.510 | 6.65:1 | Combinações produto-produto (média de 6.65 combinações por configuração) |

**Interpretação:**
- **4.439 configurações** cadastradas no sistema
- **48% dos clientes** têm pelo menos uma configuração de tipo de pedido (4.439 de 9.251)
- **Uso extensivo** - indica personalização importante de tipos de pedido por cliente
- **Média de 261 configurações por tipo de pedido** - uso muito intenso
- **Média de 6.65 combinações por configuração** - uso extensivo de combinações

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLITPPED.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por tipo de pedido** - Para buscas por tipo
4. **Índice por status** - Para buscas por status

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLITPPED_CLIENTE ON CLITPPED(CLICODIGO);

-- Índice 2: Busca por tipo de pedido (consultas frequentes)
CREATE INDEX IDX_CLITPPED_TIPO_PEDIDO ON CLITPPED(TPCODIGO);

-- Índice 3: Busca por status (consultas frequentes)
CREATE INDEX IDX_CLITPPED_STATUS ON CLITPPED(CTPSTATUS)
    WHERE CTPSTATUS IS NOT NULL AND CTPSTATUS != '';

-- Índice 4: Busca composta por cliente e tipo (consultas de validação)
CREATE INDEX IDX_CLITPPED_CLI_TIPO ON CLITPPED(CLICODIGO, TPCODIGO);

-- Índice 5: Busca por cliente e status (consultas frequentes)
CREATE INDEX IDX_CLITPPED_CLI_STATUS ON CLITPPED(CLICODIGO, CTPSTATUS);
```

### Observações sobre Volume

- **Tabela média** (4.439 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Configurações são consultadas durante criação de pedidos
- **Índices essenciais** - Em CLICODIGO, TPCODIGO e CTPSTATUS para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e tipo

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT ctp.*
FROM CLITPPED ctp
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações com tipo de pedido inválido
SELECT ctp.*
FROM CLITPPED ctp
WHERE NOT EXISTS (SELECT 1 FROM TPPEDID tp WHERE tp.TPCODIGO = ctp.TPCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLITPPED
WHERE CLICODIGO IS NULL
   OR TPCODIGO IS NULL
   OR CTPSTATUS IS NULL
   OR CTPSTATUS = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, TPCODIGO, COUNT(*) AS QTD
FROM CLITPPED
GROUP BY CLICODIGO, TPCODIGO
HAVING COUNT(*) > 1;

-- Verificar percentuais inválidos
SELECT *
FROM CLITPPED
WHERE CTPPERCFATPROD < 0 OR CTPPERCFATPROD > 100
   OR CTPPERCFATSER < 0 OR CTPPERCFATSER > 100
   OR CTPPCDESCTO < 0 OR CTPPCDESCTO > 100
   OR CTPPCDESCTOSER < 0 OR CTPPCDESCTOSER > 100;
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

final class FirebirdClitpped extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLITPPED';
    
    protected $primaryKey = ['CLICODIGO', 'TPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'TPCODIGO' => 'integer',
        'PGTCODIGO' => 'integer',
        'TBFCODIGO' => 'integer',
        'BCOCODIGO' => 'integer',
        'COBCODIGO' => 'string',
        'CTPSTATUS' => 'string',
        'CTPPCDESCTO' => 'decimal:4',
        'CTPPCDESCTOSER' => 'decimal:4',
        'FUNCODIGO' => 'integer',
        'FUNCODIGO2' => 'integer',
        'CTPPERCFATPROD' => 'decimal:4',
        'CTPPERCFATSER' => 'decimal:4',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento lógico com TPPEDID
    public function tipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdTppedid::class, 'TPCODIGO', 'TPCODIGO');
    }

    // Relacionamento com CTPPRO
    public function produtos(): HasMany
    {
        return $this->hasMany(FirebirdCtppro::class, 'CLICODIGO', 'CLICODIGO')
            ->where('TPCODIGO', $this->TPCODIGO);
    }

    // Relacionamento com CTPTBP
    public function tabelasPreco(): HasMany
    {
        return $this->hasMany(FirebirdCtptbp::class, 'CLICODIGO', 'CLICODIGO')
            ->where('TPCODIGO', $this->TPCODIGO);
    }

    // Relacionamento com CTPCOMBPROPRO
    public function combinacoesProdutoProduto(): HasMany
    {
        return $this->hasMany(FirebirdCtpcombpropro::class, 'CLICODIGO', 'CLICODIGO')
            ->where('CCPTPPEDID', $this->TPCODIGO);
    }

    // Método para verificar se está ativo
    public function estaAtivo(): bool
    {
        return strtoupper($this->CTPSTATUS) === 'ATIVO';
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por tipo de pedido
    public function scopePorTipoPedido($query, int $tipoCodigo)
    {
        return $query->where('TPCODIGO', $tipoCodigo);
    }

    // Scope para filtrar apenas ativos
    public function scopeAtivos($query)
    {
        return $query->where('CTPSTATUS', 'ATIVO');
    }

    // Método estático para buscar configuração específica
    public static function buscarConfiguracao(int $clienteCodigo, int $tipoCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('TPCODIGO', $tipoCodigo)
            ->first();
    }

    // Método estático para buscar configuração ativa
    public static function buscarConfiguracaoAtiva(int $clienteCodigo, int $tipoCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('TPCODIGO', $tipoCodigo)
            ->ativos()
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente existe
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de percentuais** - Verificar valores entre 0 e 100

### Performance

1. **Tabela média** - 4.439 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO, TPCODIGO e CTPSTATUS para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + tipo, cliente + status)
4. **Consultas frequentes** - Configurações são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de percentuais** - Verificar valores válidos

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura de status consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para personalização comercial

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

