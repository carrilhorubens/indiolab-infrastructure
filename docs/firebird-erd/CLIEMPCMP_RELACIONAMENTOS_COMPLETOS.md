# CLIEMPCMP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIEMPCMP (Cliente x Empresa - Configuração Completa)
- **Total de Registros**: 68
- **Total de Colunas**: 17
- **Chave Primária**: (CLICODIGO, EMPCODIGO) - Composta
- **Chaves Estrangeiras**: 8
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIEMPCMP** é uma tabela de configuração completa que associa clientes a empresas com configurações detalhadas por empresa. Com apenas **68 registros**, representa uma versão expandida e mais completa de CLIEMP, fornecendo configurações comerciais, financeiras e operacionais específicas por empresa.

Esta tabela funciona como **configurador completo de cliente por empresa** e permite:
- Associar clientes a empresas com configurações detalhadas
- Configurar vendedores primários e secundários por empresa
- Definir forma de pagamento específica por empresa
- Configurar banco e conta bancária por empresa
- Definir tabela de fechamento específica por empresa
- Configurar transportadora específica por empresa
- Controlar status do cliente por empresa
- Configurar valor de frete por empresa
- Controlar abatimento de crédito em notas fiscais e recebimentos
- Configurar cálculo de ISS retido e retido na fonte
- Definir percentuais de faturamento para produtos e serviços

Cada registro representa uma configuração completa de um cliente (CLICODIGO) em uma empresa específica (EMPCODIGO), contendo:
- Identificação do cliente e empresa (CLICODIGO, EMPCODIGO)
- Vendedores responsáveis (FUNCODIGO, FUNCODIGO2)
- Forma de pagamento (PGTCODIGO)
- Banco e conta bancária (BCOCODIGO, COBCODIGO)
- Tabela de fechamento (TBFCODIGO)
- Transportadora (TRACODIGO)
- Status (CECSTATUS)
- Valor de frete (CEVRFRETE)
- Configurações de abatimento de crédito (CEABATECREDNF, CEABATECREDREC)
- Configurações de ISS (CECALCISSRET, CECALCISSRETENT)
- Percentuais de faturamento (CECPERCFATPROD, CECPERCFATSER)

O sistema utiliza esta tabela para personalizar completamente o relacionamento cliente-empresa, permitindo que diferentes empresas tenham diferentes configurações comerciais, financeiras e operacionais para o mesmo cliente.

**Observação Importante:** CLIEMPCMP é uma versão expandida de CLIEMP. Enquanto CLIEMP tem apenas 4 campos e 3.174 registros, CLIEMPCMP tem 17 campos e apenas 68 registros, indicando que apenas alguns clientes têm configuração completa por empresa. A maioria dos clientes usa apenas CLIEMP para configuração básica.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **EMPCODIGO** 🔑🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Configurações de Vendedores
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FUNCODIGO** | INTEGER | | Código do vendedor/funcionário principal (lógica → FUNCIO) |
| **FUNCODIGO2** | INTEGER | | Código do vendedor/funcionário secundário (lógica → FUNCIO) |

### Configurações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PGTCODIGO** 🔗 | SMALLINT | | Código da forma de pagamento (FK → PLPTO) |
| **BCOCODIGO** 🔗 | SMALLINT | | Código do banco (FK → BANCO, também FK → BCOCOB) |
| **COBCODIGO** 🔗 | VARCHAR(14) | | Código da conta bancária/cobrança (FK → BCOCOB) |

### Configurações Operacionais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBFCODIGO** 🔗 | SMALLINT | | Código da tabela de fechamento (FK → TBFECHA) |
| **TRACODIGO** 🔗 | INTEGER | | Código da transportadora (FK → TRANS) |

### Configurações de Status e Valores
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CECSTATUS** | VARCHAR(14) | | Status do cliente na empresa |
| **CEVRFRETE** | NUMERIC(16,4) | | Valor de frete padrão |

### Configurações de Abatimento de Crédito
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CEABATECREDNF** | VARCHAR(14) | | Abate crédito em notas fiscais (S/N) |
| **CEABATECREDREC** | VARCHAR(14) | | Abate crédito em recebimentos (S/N) |

### Configurações de ISS
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CECALCISSRET** | VARCHAR(14) | | Calcula ISS retido (S/N) |
| **CECALCISSRETENT** | VARCHAR(14) | | Calcula ISS retido na fonte (S/N) |

### Configurações de Faturamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CECPERCFATPROD** | NUMERIC(16,4) | | Percentual de faturamento produtos |
| **CECPERCFATSER** | NUMERIC(16,4) | | Percentual de faturamento serviços |

**Primary Key:** (CLICODIGO, EMPCODIGO)

**Observações sobre Campos:**
- **FUNCODIGO e FUNCODIGO2**: Permite dois vendedores responsáveis pelo cliente na empresa.
- **PGTCODIGO**: Forma de pagamento específica para o cliente na empresa.
- **BCOCODIGO e COBCODIGO**: Banco e conta bancária específicos para recebimentos do cliente na empresa.
- **TBFCODIGO**: Tabela de fechamento específica para o cliente na empresa.
- **TRACODIGO**: Transportadora padrão para entregas do cliente na empresa.
- **CECSTATUS**: Status específico do cliente na empresa (pode diferir do status geral em CLIEN).
- **CEVRFRETE**: Valor de frete padrão para o cliente na empresa.
- **CEABATECREDNF e CEABATECREDREC**: Controlam se créditos devem ser abatidos automaticamente.
- **CECALCISSRET e CECALCISSRETENT**: Controlam cálculo de ISS retido.
- **CECPERCFATPROD e CECPERCFATSER**: Percentuais específicos de faturamento por tipo.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIEMPCMP Referencia (8 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIEMPCMP.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIEMPCMP
```

**Descrição**: Cada configuração está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente da configuração, relatórios por cliente, análises de configurações por cliente.

---

#### 2. EMPRESA - Empresas/Filiais
**Relacionamento:**
```
CLIEMPCMP.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_CLIEMPCMP
```

**Descrição**: Cada configuração está vinculada a uma empresa/filial específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos
- **FK Out:** 9
- **FK In:** 53 tabelas

**Uso:** Identificar a empresa da configuração, relatórios por empresa, análises de configurações por empresa.

---

#### 3. PLPTO - Formas de Pagamento
**Relacionamento:**
```
CLIEMPCMP.PGTCODIGO → PLPTO.PGTCODIGO (N:1)
Constraint: PLPTO_CLIEMPCMP
```

**Descrição**: Forma de pagamento específica para o cliente na empresa.

**Informações da Tabela PLPTO:**
- **Total:** 173 formas de pagamento
- **PK:** PGTCODIGO
- **Colunas:** 13 campos
- **FK Out:** 0
- **FK In:** 10 tabelas

**Uso:** Identificar forma de pagamento padrão, aplicar condições de pagamento em pedidos e notas.

---

#### 4. BANCO - Bancos
**Relacionamento:**
```
CLIEMPCMP.BCOCODIGO → BANCO.BCOCODIGO (N:1)
Constraint: BANCO_CLIEMPCMP
```

**Descrição**: Banco específico para recebimentos do cliente na empresa.

**Informações da Tabela BANCO:**
- **Total:** 1.000 bancos
- **PK:** BCOCODIGO
- **Colunas:** 3 campos
- **FK Out:** 0
- **FK In:** 28 tabelas

**Uso:** Identificar banco para recebimentos, gerar boletos, processar pagamentos.

---

#### 5. BCOCOB - Contas Bancárias (2 FKs)

**5.1. BCOCODIGO → BCOCOB**
```
CLIEMPCMP.BCOCODIGO → BCOCOB.BCOCODIGO (N:1)
Constraint: BCOCOB_CLIEMPCMP
```

**5.2. COBCODIGO → BCOCOB**
```
CLIEMPCMP.COBCODIGO → BCOCOB.COBCODIGO (N:1)
Constraint: BCOCOB_CLIEMPCMP
```

**Descrição**: Conta bancária específica para recebimentos do cliente na empresa.

**Informações da Tabela BCOCOB:**
- **Total:** 11 contas bancárias
- **PK:** (BCOCODIGO, COBCODIGO)
- **Colunas:** 84 campos
- **FK Out:** 6
- **FK In:** 24 tabelas

**Uso:** Identificar conta bancária específica, gerar boletos, processar recebimentos.

---

#### 6. TBFECHA - Tabela de Fechamento
**Relacionamento:**
```
CLIEMPCMP.TBFCODIGO → TBFECHA.TBFCODIGO (N:1)
Constraint: TBFECHA_CLIEMPCMP
```

**Descrição**: Tabela de fechamento específica para o cliente na empresa.

**Informações da Tabela TBFECHA:**
- **Total:** 7 tabelas de fechamento
- **PK:** TBFCODIGO
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 3 tabelas

**Uso:** Identificar tabela de fechamento padrão, aplicar condições de fechamento em pedidos.

---

#### 7. TRANS - Transportadoras
**Relacionamento:**
```
CLIEMPCMP.TRACODIGO → TRANS.TRACODIGO (N:1)
Constraint: TRANS_CLIEMPCMP
```

**Descrição**: Transportadora padrão para entregas do cliente na empresa.

**Informações da Tabela TRANS:**
- **Total:** 115 transportadoras
- **PK:** TRACODIGO
- **Colunas:** 27 campos
- **FK Out:** 3
- **FK In:** 4 tabelas

**Uso:** Identificar transportadora padrão, calcular frete, gerar etiquetas de envio.

---

### Relacionamentos Lógicos Adicionais:

#### 8. FUNCIO - Funcionários/Vendedores (2 Lógicas)

**8.1. FUNCODIGO → FUNCIO**
```
CLIEMPCMP.FUNCODIGO → FUNCIO.FUNCODIGO (N:1)
Constraint: NÃO FORMAL (relacionamento lógico)
```

**8.2. FUNCODIGO2 → FUNCIO**
```
CLIEMPCMP.FUNCODIGO2 → FUNCIO.FUNCODIGO (N:1)
Constraint: NÃO FORMAL (relacionamento lógico)
```

**Descrição**: Vendedores responsáveis pelo cliente na empresa.

**Informações da Tabela FUNCIO:**
- **Total:** 435 funcionários
- **PK:** FUNCODIGO
- **Colunas:** 74 campos
- **FK Out:** 6
- **FK In:** 23 tabelas

**Uso:** Identificar vendedores responsáveis, calcular comissões, relatórios de vendas por vendedor.

---

### CLIEMPCMP é Referenciada Por

**Nenhuma tabela** referencia CLIEMPCMP diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIEMPCMP → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados à empresa configurada em CLIEMPCMP.

**Uso:** Análises de pedidos por empresa e cliente, aplicar configurações em pedidos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIEMPCMP → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas à empresa configurada.

**Uso:** Análises de notas fiscais por empresa e cliente, aplicar configurações em notas.

---

### Via EMPRESA → PEDID (Pedidos)

**Fluxo:** CLIEMPCMP → EMPRESA → PEDID

**Descrição:** Através da empresa, é possível identificar pedidos que podem estar relacionados ao cliente configurado.

**Uso:** Análises de pedidos por empresa, validação de acesso de empresas em pedidos.

---

### Via FUNCIO → PEDID (Pedidos)

**Fluxo:** CLIEMPCMP → FUNCIO → PEDID

**Descrição:** Através dos vendedores, é possível identificar pedidos que podem estar relacionados ao cliente configurado.

**Uso:** Análises de pedidos por vendedor, cálculo de comissões.

---

### Via PLPTO → RECEB (Recebimentos)

**Fluxo:** CLIEMPCMP → PLPTO → RECEB

**Descrição:** Através da forma de pagamento, é possível identificar recebimentos relacionados.

**Uso:** Análises de recebimentos por forma de pagamento.

---

### Via BCOCOB → RECBX (Baixas de Recebimento)

**Fluxo:** CLIEMPCMP → BCOCOB → RECBX

**Descrição:** Através da conta bancária, é possível identificar baixas de recebimento relacionadas.

**Uso:** Análises de recebimentos por conta bancária.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração por Cliente e Empresa

**Objetivo:** Obter visão completa de uma configuração incluindo informações do cliente, empresa e todas as configurações relacionadas.

**Fluxo:**
```
CLIEMPCMP (CLICODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
EMPRESA (EMPCODIGO)
  ↓
PLPTO (PGTCODIGO)
BANCO (BCOCODIGO)
BCOCOB (BCOCODIGO, COBCODIGO)
TBFECHA (TBFCODIGO)
TRANS (TRACODIGO)
FUNCIO (FUNCODIGO, FUNCODIGO2)
```

**Query SQL:**
```sql
SELECT
    cec.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    emp.EMPNOMEFNT AS EMPRESA_FANTASIA,
    cec.FUNCODIGO,
    fun1.FUNNOME AS VENDEDOR_PRINCIPAL,
    cec.FUNCODIGO2,
    fun2.FUNNOME AS VENDEDOR_SECUNDARIO,
    cec.PGTCODIGO,
    pgt.PGTDESCRICAO AS FORMA_PAGAMENTO,
    cec.BCOCODIGO,
    ban.BCODESCRICAO AS BANCO,
    cec.COBCODIGO,
    cob.COBAGCONTA AS CONTA_BANCARIA,
    cec.TBFCODIGO,
    tbf.TBFDESCRICAO AS TABELA_FECHAMENTO,
    cec.TRACODIGO,
    tra.TRANOME AS TRANSPORTADORA,
    cec.CECSTATUS AS STATUS,
    cec.CEVRFRETE AS VALOR_FRETE,
    cec.CEABATECREDNF AS ABATE_CREDITO_NF,
    cec.CEABATECREDREC AS ABATE_CREDITO_REC,
    cec.CECALCISSRET AS CALCULA_ISS_RETIDO,
    cec.CECALCISSRETENT AS CALCULA_ISS_RETIDO_FONTE,
    cec.CECPERCFATPROD AS PERCENTUAL_FAT_PROD,
    cec.CECPERCFATSER AS PERCENTUAL_FAT_SER
FROM CLIEMPCMP cec
INNER JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
LEFT JOIN FUNCIO fun1 ON fun1.FUNCODIGO = cec.FUNCODIGO
LEFT JOIN FUNCIO fun2 ON fun2.FUNCODIGO = cec.FUNCODIGO2
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = cec.PGTCODIGO
LEFT JOIN BANCO ban ON ban.BCOCODIGO = cec.BCOCODIGO
LEFT JOIN BCOCOB cob ON cob.BCOCODIGO = cec.BCOCODIGO 
    AND cob.COBCODIGO = cec.COBCODIGO
LEFT JOIN TBFECHA tbf ON tbf.TBFCODIGO = cec.TBFCODIGO
LEFT JOIN TRANS tra ON tra.TRACODIGO = cec.TRACODIGO
WHERE cec.CLICODIGO = ?
  AND cec.EMPCODIGO = ?;
```

---

### Exemplo 2: Análise de Configurações por Empresa

**Objetivo:** Identificar todas as configurações completas de clientes em uma empresa específica.

**Fluxo:**
```
EMPRESA (EMPCODIGO)
  ↓
CLIEMPCMP (EMPCODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT cec.CLICODIGO) AS TOTAL_CLIENTES_CONFIGURADOS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN cec.FUNCODIGO IS NOT NULL THEN 1 END) AS COM_VENDEDOR_PRINCIPAL,
    COUNT(CASE WHEN cec.FUNCODIGO2 IS NOT NULL THEN 1 END) AS COM_VENDEDOR_SECUNDARIO,
    COUNT(CASE WHEN cec.PGTCODIGO IS NOT NULL THEN 1 END) AS COM_FORMA_PAGAMENTO,
    COUNT(CASE WHEN cec.BCOCODIGO IS NOT NULL THEN 1 END) AS COM_BANCO,
    COUNT(CASE WHEN cec.COBCODIGO IS NOT NULL THEN 1 END) AS COM_CONTA_BANCARIA,
    COUNT(CASE WHEN cec.TBFCODIGO IS NOT NULL THEN 1 END) AS COM_TABELA_FECHAMENTO,
    COUNT(CASE WHEN cec.TRACODIGO IS NOT NULL THEN 1 END) AS COM_TRANSPORTADORA
FROM EMPRESA emp
LEFT JOIN CLIEMPCMP cec ON cec.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPRAZSOCIAL
ORDER BY TOTAL_CLIENTES_CONFIGURADOS DESC;
```

---

### Exemplo 3: Análise de Configurações com Pedidos

**Objetivo:** Identificar configurações que foram utilizadas em pedidos e analisar eficácia.

**Fluxo:**
```
CLIEMPCMP (CLICODIGO, EMPCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    cec.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    cec.FUNCODIGO,
    fun1.FUNNOME AS VENDEDOR_PRINCIPAL,
    cec.PGTCODIGO,
    pgt.PGTDESCRICAO AS FORMA_PAGAMENTO,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS,
    AVG(pd.PEDVRMERC) AS VALOR_MEDIO_PEDIDOS
FROM CLIEMPCMP cec
INNER JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
LEFT JOIN FUNCIO fun1 ON fun1.FUNCODIGO = cec.FUNCODIGO
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = cec.PGTCODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = cec.CLICODIGO 
    AND pd.EMPCODIGO = cec.EMPCODIGO
GROUP BY cec.CLICODIGO, cl.CLINOMEFANT, cec.EMPCODIGO, emp.EMPRAZSOCIAL,
    cec.FUNCODIGO, fun1.FUNNOME, cec.PGTCODIGO, pgt.PGTDESCRICAO
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração Completa

**Objetivo:** Obter todas as informações de uma configuração específica.

```sql
SELECT
    cec.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    cec.FUNCODIGO,
    fun1.FUNNOME AS VENDEDOR_PRINCIPAL,
    cec.FUNCODIGO2,
    fun2.FUNNOME AS VENDEDOR_SECUNDARIO,
    cec.PGTCODIGO,
    pgt.PGTDESCRICAO AS FORMA_PAGAMENTO,
    cec.BCOCODIGO,
    ban.BCODESCRICAO AS BANCO,
    cec.COBCODIGO,
    cob.COBAGCONTA AS CONTA_BANCARIA,
    cec.TBFCODIGO,
    tbf.TBFDESCRICAO AS TABELA_FECHAMENTO,
    cec.TRACODIGO,
    tra.TRANOME AS TRANSPORTADORA,
    cec.CECSTATUS AS STATUS,
    cec.CEVRFRETE AS VALOR_FRETE,
    cec.CEABATECREDNF AS ABATE_CREDITO_NF,
    cec.CEABATECREDREC AS ABATE_CREDITO_REC,
    cec.CECALCISSRET AS CALCULA_ISS_RETIDO,
    cec.CECALCISSRETENT AS CALCULA_ISS_RETIDO_FONTE,
    cec.CECPERCFATPROD AS PERCENTUAL_FAT_PROD,
    cec.CECPERCFATSER AS PERCENTUAL_FAT_SER
FROM CLIEMPCMP cec
INNER JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
LEFT JOIN FUNCIO fun1 ON fun1.FUNCODIGO = cec.FUNCODIGO
LEFT JOIN FUNCIO fun2 ON fun2.FUNCODIGO = cec.FUNCODIGO2
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = cec.PGTCODIGO
LEFT JOIN BANCO ban ON ban.BCOCODIGO = cec.BCOCODIGO
LEFT JOIN BCOCOB cob ON cob.BCOCODIGO = cec.BCOCODIGO 
    AND cob.COBCODIGO = cec.COBCODIGO
LEFT JOIN TBFECHA tbf ON tbf.TBFCODIGO = cec.TBFCODIGO
LEFT JOIN TRANS tra ON tra.TRACODIGO = cec.TRACODIGO
WHERE cec.CLICODIGO = ?
  AND cec.EMPCODIGO = ?;
```

---

### 2. Listar Todas as Configurações de um Cliente

**Objetivo:** Obter todas as configurações completas de um cliente em diferentes empresas.

```sql
SELECT
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    cec.FUNCODIGO,
    fun1.FUNNOME AS VENDEDOR_PRINCIPAL,
    cec.PGTCODIGO,
    pgt.PGTDESCRICAO AS FORMA_PAGAMENTO,
    cec.CECSTATUS AS STATUS,
    cec.CEVRFRETE AS VALOR_FRETE
FROM CLIEMPCMP cec
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
LEFT JOIN FUNCIO fun1 ON fun1.FUNCODIGO = cec.FUNCODIGO
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = cec.PGTCODIGO
WHERE cec.CLICODIGO = ?
ORDER BY cec.EMPCODIGO;
```

---

### 3. Relatório de Configurações por Empresa

**Objetivo:** Analisar configurações completas de clientes por empresa.

```sql
SELECT
    emp.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    COUNT(DISTINCT cec.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN cec.FUNCODIGO IS NOT NULL THEN 1 END) AS COM_VENDEDOR_PRINCIPAL,
    COUNT(CASE WHEN cec.PGTCODIGO IS NOT NULL THEN 1 END) AS COM_FORMA_PAGAMENTO,
    COUNT(CASE WHEN cec.BCOCODIGO IS NOT NULL THEN 1 END) AS COM_BANCO,
    COUNT(CASE WHEN cec.TRACODIGO IS NOT NULL THEN 1 END) AS COM_TRANSPORTADORA,
    AVG(cec.CEVRFRETE) AS VALOR_MEDIO_FRETE,
    COUNT(CASE WHEN cec.CECSTATUS = 'ATIVO' THEN 1 END) AS CLIENTES_ATIVOS
FROM EMPRESA emp
LEFT JOIN CLIEMPCMP cec ON cec.EMPCODIGO = emp.EMPCODIGO
GROUP BY emp.EMPCODIGO, emp.EMPRAZSOCIAL
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 4. Análise de Configurações por Vendedor

**Objetivo:** Identificar clientes configurados por vendedor.

```sql
SELECT
    fun.FUNCODIGO,
    fun.FUNNOME AS VENDEDOR,
    COUNT(DISTINCT cec.CLICODIGO) AS TOTAL_CLIENTES_PRINCIPAL,
    COUNT(DISTINCT CASE WHEN cec.FUNCODIGO2 = fun.FUNCODIGO THEN cec.CLICODIGO END) AS TOTAL_CLIENTES_SECUNDARIO,
    COUNT(DISTINCT cec.CLICODIGO) + COUNT(DISTINCT CASE WHEN cec.FUNCODIGO2 = fun.FUNCODIGO THEN cec.CLICODIGO END) AS TOTAL_CLIENTES
FROM FUNCIO fun
LEFT JOIN CLIEMPCMP cec ON cec.FUNCODIGO = fun.FUNCODIGO 
    OR cec.FUNCODIGO2 = fun.FUNCODIGO
WHERE fun.FUNVENDEDOR = 'S'
GROUP BY fun.FUNCODIGO, fun.FUNNOME
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 5. Comparação CLIEMP vs CLIEMPCMP

**Objetivo:** Identificar clientes que têm configuração básica (CLIEMP) mas não têm configuração completa (CLIEMPCMP).

```sql
SELECT
    ce.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ce.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    CASE 
        WHEN cec.CLICODIGO IS NOT NULL THEN 'SIM'
        ELSE 'NÃO'
    END AS TEM_CONFIGURACAO_COMPLETA,
    ce.TFCODIGO AS TABELA_FATURAMENTO_BASICA,
    cec.TBFCODIGO AS TABELA_FECHAMENTO_COMPLETA
FROM CLIEMP ce
INNER JOIN CLIEN cl ON cl.CLICODIGO = ce.CLICODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ce.EMPCODIGO
LEFT JOIN CLIEMPCMP cec ON cec.CLICODIGO = ce.CLICODIGO 
    AND cec.EMPCODIGO = ce.EMPCODIGO
ORDER BY ce.CLICODIGO, ce.EMPCODIGO;
```

---

### 6. Análise de Configurações de Abatimento de Crédito

**Objetivo:** Identificar clientes configurados com abatimento automático de crédito.

```sql
SELECT
    cec.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    cec.CEABATECREDNF AS ABATE_CREDITO_NF,
    cec.CEABATECREDREC AS ABATE_CREDITO_REC,
    CASE 
        WHEN cec.CEABATECREDNF = 'S' AND cec.CEABATECREDREC = 'S' THEN 'AMBOS'
        WHEN cec.CEABATECREDNF = 'S' THEN 'APENAS NF'
        WHEN cec.CEABATECREDREC = 'S' THEN 'APENAS RECEBIMENTO'
        ELSE 'NENHUM'
    END AS TIPO_ABATIMENTO
FROM CLIEMPCMP cec
INNER JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
WHERE cec.CEABATECREDNF = 'S'
   OR cec.CEABATECREDREC = 'S'
ORDER BY cec.CLICODIGO, cec.EMPCODIGO;
```

---

### 7. Análise de Configurações de ISS

**Objetivo:** Identificar clientes configurados com cálculo de ISS retido.

```sql
SELECT
    cec.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cec.EMPCODIGO,
    emp.EMPRAZSOCIAL AS EMPRESA,
    cec.CECALCISSRET AS CALCULA_ISS_RETIDO,
    cec.CECALCISSRETENT AS CALCULA_ISS_RETIDO_FONTE,
    CASE 
        WHEN cec.CECALCISSRET = 'S' AND cec.CECALCISSRETENT = 'S' THEN 'AMBOS'
        WHEN cec.CECALCISSRET = 'S' THEN 'APENAS RETIDO'
        WHEN cec.CECALCISSRETENT = 'S' THEN 'APENAS RETIDO FONTE'
        ELSE 'NENHUM'
    END AS TIPO_CALCULO_ISS
FROM CLIEMPCMP cec
INNER JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
WHERE cec.CECALCISSRET = 'S'
   OR cec.CECALCISSRETENT = 'S'
ORDER BY cec.CLICODIGO, cec.EMPCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIEMPCMP | Tipo |
|--------|-----------|---------------------|------|
| **CLIEMPCMP** | 68 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 136:1 | Clientes (média de 0.007 configurações por cliente) |
| EMPRESA | 6 | 0.088:1 | Empresas (média de 11.3 configurações por empresa) |
| CLIEMP | 3.174 | 46.7:1 | Configuração básica (muito maior que CLIEMPCMP) |

**Interpretação:**
- **68 configurações completas** cadastradas no sistema
- **Apenas 0.73% dos clientes** têm configuração completa (68 de 9.251)
- **Apenas 2.14% das configurações básicas** têm versão completa (68 de 3.174)
- **Média de 11.3 configurações por empresa** - algumas empresas têm mais configurações completas
- **Configuração especializada** - apenas clientes com necessidades específicas têm CLIEMPCMP

**Distribuição Esperada:**
- Clientes com configuração completa: clientes importantes ou com necessidades específicas
- Empresas com muitas configurações: empresas principais do grupo
- Maioria usa CLIEMP: configuração básica é suficiente para a maioria dos clientes

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLICODIGO, EMPCODIGO** | CLIEMPCMP | Chave primária composta (PK) |
| **CLICODIGO** | CLIEMPCMP → CLIEN | Cliente da configuração |
| **EMPCODIGO** | CLIEMPCMP → EMPRESA | Empresa da configuração |
| **FUNCODIGO, FUNCODIGO2** | CLIEMPCMP → FUNCIO | Vendedores responsáveis |
| **PGTCODIGO** | CLIEMPCMP → PLPTO | Forma de pagamento |
| **BCOCODIGO, COBCODIGO** | CLIEMPCMP → BCOCOB | Banco e conta bancária |
| **TBFCODIGO** | CLIEMPCMP → TBFECHA | Tabela de fechamento |
| **TRACODIGO** | CLIEMPCMP → TRANS | Transportadora |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIEMPCMP.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por empresa** - Para buscas por empresa
4. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIEMPCMP_CLIENTE ON CLIEMPCMP(CLICODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CLIEMPCMP_EMPRESA ON CLIEMPCMP(EMPCODIGO);

-- Índice 3: Busca composta por cliente e empresa (consultas de validação)
CREATE INDEX IDX_CLIEMPCMP_CLI_EMP ON CLIEMPCMP(CLICODIGO, EMPCODIGO);

-- Índice 4: Busca por vendedor principal (consultas por vendedor)
CREATE INDEX IDX_CLIEMPCMP_VENDEDOR ON CLIEMPCMP(FUNCODIGO) 
    WHERE FUNCODIGO IS NOT NULL;

-- Índice 5: Busca por forma de pagamento (consultas específicas)
CREATE INDEX IDX_CLIEMPCMP_PAGAMENTO ON CLIEMPCMP(PGTCODIGO) 
    WHERE PGTCODIGO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela muito pequena** (68 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por cliente, empresa e vendedor
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e empresa

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK composta)
SELECT CLICODIGO, EMPCODIGO, FUNCODIGO, PGTCODIGO
FROM CLIEMPCMP
WHERE CLICODIGO = ?
  AND EMPCODIGO = ?;

-- ✅ OTIMIZADO (usar índice em CLICODIGO)
SELECT CLICODIGO, EMPCODIGO
FROM CLIEMPCMP
WHERE CLICODIGO = ?
ORDER BY EMPCODIGO;

-- ✅ OTIMIZADO (usar índice em EMPCODIGO)
SELECT CLICODIGO, EMPCODIGO
FROM CLIEMPCMP
WHERE EMPCODIGO = ?
ORDER BY CLICODIGO;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CLICODIGO, EMPCODIGO, FUNCODIGO, PGTCODIGO
FROM CLIEMPCMP
WHERE CLICODIGO = ?
  AND EMPCODIGO = ?
ORDER BY FUNCODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem cliente válido
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cec.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar configurações sem empresa válida
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = cec.EMPCODIGO
WHERE emp.EMPCODIGO IS NULL;

-- Verificar configurações com forma de pagamento inválida
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN PLPTO pgt ON pgt.PGTCODIGO = cec.PGTCODIGO
WHERE cec.PGTCODIGO IS NOT NULL
  AND pgt.PGTCODIGO IS NULL;

-- Verificar configurações com banco inválido
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN BANCO ban ON ban.BCOCODIGO = cec.BCOCODIGO
WHERE cec.BCOCODIGO IS NOT NULL
  AND ban.BCOCODIGO IS NULL;

-- Verificar configurações com conta bancária inválida
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN BCOCOB cob ON cob.BCOCODIGO = cec.BCOCODIGO 
    AND cob.COBCODIGO = cec.COBCODIGO
WHERE cec.BCOCODIGO IS NOT NULL
  AND cec.COBCODIGO IS NOT NULL
  AND cob.BCOCODIGO IS NULL;

-- Verificar configurações com vendedor inválido
SELECT cec.*
FROM CLIEMPCMP cec
LEFT JOIN FUNCIO fun ON fun.FUNCODIGO = cec.FUNCODIGO
WHERE cec.FUNCODIGO IS NOT NULL
  AND fun.FUNCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIEMPCMP
WHERE CLICODIGO IS NULL
   OR EMPCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, EMPCODIGO, COUNT(*) AS QTD
FROM CLIEMPCMP
GROUP BY CLICODIGO, EMPCODIGO
HAVING COUNT(*) > 1;

-- Verificar valores inválidos de percentuais
SELECT *
FROM CLIEMPCMP
WHERE (CECPERCFATPROD IS NOT NULL AND (CECPERCFATPROD < 0 OR CECPERCFATPROD > 100))
   OR (CECPERCFATSER IS NOT NULL AND (CECPERCFATSER < 0 OR CECPERCFATSER > 100));

-- Verificar valores inválidos de frete
SELECT *
FROM CLIEMPCMP
WHERE CEVRFRETE IS NOT NULL
  AND CEVRFRETE < 0;

-- Verificar valores inválidos de status
SELECT DISTINCT CECSTATUS
FROM CLIEMPCMP
WHERE CECSTATUS IS NOT NULL
ORDER BY CECSTATUS;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por cliente
SELECT
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(CONFIGURACOES_POR_CLIENTE) AS MEDIA_CONFIGURACOES_POR_CLIENTE,
    MAX(CONFIGURACOES_POR_CLIENTE) AS MAX_CONFIGURACOES_POR_CLIENTE,
    MIN(CONFIGURACOES_POR_CLIENTE) AS MIN_CONFIGURACOES_POR_CLIENTE
FROM (
    SELECT 
        CLICODIGO,
        COUNT(*) AS CONFIGURACOES_POR_CLIENTE
    FROM CLIEMPCMP
    GROUP BY CLICODIGO
);

-- Verificar distribuição por empresa
SELECT
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(CONFIGURACOES_POR_EMPRESA) AS MEDIA_CONFIGURACOES_POR_EMPRESA,
    MAX(CONFIGURACOES_POR_EMPRESA) AS MAX_CONFIGURACOES_POR_EMPRESA,
    MIN(CONFIGURACOES_POR_EMPRESA) AS MIN_CONFIGURACOES_POR_EMPRESA
FROM (
    SELECT 
        EMPCODIGO,
        COUNT(*) AS CONFIGURACOES_POR_EMPRESA
    FROM CLIEMPCMP
    GROUP BY EMPCODIGO
);

-- Verificar configurações com campos preenchidos
SELECT
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(CASE WHEN FUNCODIGO IS NOT NULL THEN 1 END) AS COM_VENDEDOR_PRINCIPAL,
    COUNT(CASE WHEN FUNCODIGO2 IS NOT NULL THEN 1 END) AS COM_VENDEDOR_SECUNDARIO,
    COUNT(CASE WHEN PGTCODIGO IS NOT NULL THEN 1 END) AS COM_FORMA_PAGAMENTO,
    COUNT(CASE WHEN BCOCODIGO IS NOT NULL THEN 1 END) AS COM_BANCO,
    COUNT(CASE WHEN COBCODIGO IS NOT NULL THEN 1 END) AS COM_CONTA_BANCARIA,
    COUNT(CASE WHEN TBFCODIGO IS NOT NULL THEN 1 END) AS COM_TABELA_FECHAMENTO,
    COUNT(CASE WHEN TRACODIGO IS NOT NULL THEN 1 END) AS COM_TRANSPORTADORA,
    COUNT(CASE WHEN CECSTATUS IS NOT NULL THEN 1 END) AS COM_STATUS,
    COUNT(CASE WHEN CEVRFRETE IS NOT NULL THEN 1 END) AS COM_VALOR_FRETE
FROM CLIEMPCMP;
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

final class FirebirdCliempcmp extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIEMPCMP';
    
    protected $primaryKey = ['CLICODIGO', 'EMPCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'FUNCODIGO' => 'integer',
        'FUNCODIGO2' => 'integer',
        'PGTCODIGO' => 'integer',
        'BCOCODIGO' => 'integer',
        'COBCODIGO' => 'string',
        'TBFCODIGO' => 'integer',
        'TRACODIGO' => 'integer',
        'CECSTATUS' => 'string',
        'CEVRFRETE' => 'decimal:4',
        'CEABATECREDNF' => 'string',
        'CEABATECREDREC' => 'string',
        'CECALCISSRET' => 'string',
        'CECALCISSRETENT' => 'string',
        'CECPERCFATPROD' => 'decimal:4',
        'CECPERCFATSER' => 'decimal:4',
    ];

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

    // Relacionamento com FUNCIO (vendedor principal)
    public function vendedorPrincipal(): BelongsTo
    {
        return $this->belongsTo(FirebirdFuncio::class, 'FUNCODIGO', 'FUNCODIGO');
    }

    // Relacionamento com FUNCIO (vendedor secundário)
    public function vendedorSecundario(): BelongsTo
    {
        return $this->belongsTo(FirebirdFuncio::class, 'FUNCODIGO2', 'FUNCODIGO');
    }

    // Relacionamento com PLPTO
    public function formaPagamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdPlpto::class, 'PGTCODIGO', 'PGTCODIGO');
    }

    // Relacionamento com BANCO
    public function banco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBanco::class, 'BCOCODIGO', 'BCOCODIGO');
    }

    // Relacionamento com BCOCOB
    public function contaBancaria(): BelongsTo
    {
        return $this->belongsTo(FirebirdBcocob::class, ['BCOCODIGO', 'COBCODIGO'], ['BCOCODIGO', 'COBCODIGO']);
    }

    // Relacionamento com TBFECHA
    public function tabelaFechamento(): BelongsTo
    {
        return $this->belongsTo(FirebirdTbfecha::class, 'TBFCODIGO', 'TBFCODIGO');
    }

    // Relacionamento com TRANS
    public function transportadora(): BelongsTo
    {
        return $this->belongsTo(FirebirdTrans::class, 'TRACODIGO', 'TRACODIGO');
    }

    // Método para verificar se tem vendedor configurado
    public function temVendedor(): bool
    {
        return !empty($this->FUNCODIGO);
    }

    // Método para verificar se tem dois vendedores configurados
    public function temDoisVendedores(): bool
    {
        return !empty($this->FUNCODIGO) && !empty($this->FUNCODIGO2);
    }

    // Método para verificar se abate crédito em NF
    public function abateCreditoNF(): bool
    {
        return $this->CEABATECREDNF === 'S';
    }

    // Método para verificar se abate crédito em recebimento
    public function abateCreditoRec(): bool
    {
        return $this->CEABATECREDREC === 'S';
    }

    // Método para verificar se calcula ISS retido
    public function calculaISSRetido(): bool
    {
        return $this->CECALCISSRET === 'S';
    }

    // Método para verificar se calcula ISS retido na fonte
    public function calculaISSRetidoFonte(): bool
    {
        return $this->CECALCISSRETENT === 'S';
    }

    // Método para verificar se está ativo
    public function estaAtivo(): bool
    {
        return $this->CECSTATUS === 'ATIVO';
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por cliente e empresa
    public function scopePorClienteEmpresa($query, int $clienteCodigo, int $empresaCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo);
    }

    // Scope para filtrar por vendedor principal
    public function scopePorVendedorPrincipal($query, int $vendedorCodigo)
    {
        return $query->where('FUNCODIGO', $vendedorCodigo);
    }

    // Scope para filtrar por vendedor (principal ou secundário)
    public function scopePorVendedor($query, int $vendedorCodigo)
    {
        return $query->where(function($q) use ($vendedorCodigo) {
            $q->where('FUNCODIGO', $vendedorCodigo)
              ->orWhere('FUNCODIGO2', $vendedorCodigo);
        });
    }

    // Scope para filtrar configurações ativas
    public function scopeAtivas($query)
    {
        return $query->where('CECSTATUS', 'ATIVO');
    }

    // Scope para filtrar configurações com abatimento de crédito
    public function scopeComAbatimentoCredito($query)
    {
        return $query->where(function($q) {
            $q->where('CEABATECREDNF', 'S')
              ->orWhere('CEABATECREDREC', 'S');
        });
    }

    // Método estático para buscar configuração específica
    public static function buscarConfiguracao(int $clienteCodigo, int $empresaCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->first();
    }

    // Método estático para verificar se cliente tem configuração completa em empresa
    public static function clienteTemConfiguracaoCompleta(int $clienteCodigo, int $empresaCodigo): bool
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('EMPCODIGO', $empresaCodigo)
            ->exists();
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_configuracoes' => self::count(),
            'total_clientes' => self::distinct('CLICODIGO')->count(),
            'total_empresas' => self::distinct('EMPCODIGO')->count(),
            'com_vendedor_principal' => self::whereNotNull('FUNCODIGO')->count(),
            'com_vendedor_secundario' => self::whereNotNull('FUNCODIGO2')->count(),
            'com_forma_pagamento' => self::whereNotNull('PGTCODIGO')->count(),
            'com_banco' => self::whereNotNull('BCOCODIGO')->count(),
            'com_conta_bancaria' => self::whereNotNull('COBCODIGO')->count(),
            'com_transportadora' => self::whereNotNull('TRACODIGO')->count(),
            'com_abatimento_credito' => self::comAbatimentoCredito()->count(),
            'ativas' => self::ativas()->count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Configuração completa** - CLIEMPCMP é versão expandida de CLIEMP

### Performance

1. **Tabela muito pequena** - 68 registros, performance excelente
2. **Índices úteis** - Em CLICODIGO e EMPCODIGO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + empresa)
4. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - Percentuais devem estar entre 0 e 100, frete >= 0

### Manutenção

1. **Revisão periódica** - Verificar configurações não utilizadas
2. **Padronização** - Manter estrutura de configurações consistente
3. **Documentação** - Documentar significado de cada campo de configuração
4. **Backup regular** - Tabela importante para configuração multi-empresa

### Regras de Negócio

1. **Validação em tempo real** - Verificar se cliente tem configuração completa antes de usar
2. **Consistência** - Garantir que configurações usadas em pedidos/notas estão corretas
3. **Multi-empresa** - Cada empresa pode ter diferentes configurações para o mesmo cliente
4. **Configuração opcional** - A maioria dos campos são opcionais

### Observações Especiais

1. **Configuração especializada** - CLIEMPCMP é para clientes com necessidades específicas
2. **Versão expandida** - CLIEMPCMP expande CLIEMP com mais configurações
3. **Volume baixo** - Apenas 68 registros indicam uso especializado
4. **Sem dependentes** - Tabela folha utilizada para configuração e consulta

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

