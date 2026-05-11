# CIDADE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CIDADE (Cidades)
- **Total de Registros**: 736
- **Total de Colunas**: 16
- **Chave Primária**: CIDCODIGO (INTEGER)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 10 (Diretas)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CIDADE** é uma tabela mestre que armazena informações completas sobre cidades no sistema. Com **736 registros**, representa o cadastro de cidades utilizadas em endereços, empresas, funcionários, clientes e outras entidades do sistema.

Esta tabela funciona como **catálogo geográfico** e permite:
- Cadastrar cidades com informações completas
- Vincular cidades a países, regiões e estados (UF)
- Armazenar informações fiscais (ISS, códigos contábeis)
- Controlar códigos IBGE e SIAFI para integração governamental
- Suportar informações de NFSe (Nota Fiscal de Serviços Eletrônica)
- Gerenciar rótulos e observações específicas por cidade

Cada registro representa uma cidade específica, contendo:
- Identificação única (CIDCODIGO)
- Nome da cidade (CIDNOME)
- Relacionamentos geográficos (PAISCODIGO, REGCODIGO, CIDUF)
- Informações fiscais (percentuais de ISS)
- Códigos governamentais (IBGE, SIAFI, contábil)
- Informações de fundação e tipo de cidade
- Códigos para integração (NFSe, DIPAM)

O sistema utiliza esta tabela como base para todos os processos que envolvem localização geográfica, desde cadastros de endereços até cálculos fiscais e emissão de documentos.

**Observação Importante:** CIDADE é amplamente referenciada por 10 tabelas diferentes, sendo essencial para cadastros de endereços, empresas, funcionários, clientes, transportadoras e outras entidades que possuem localização geográfica.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CIDCODIGO** 🔑 | INTEGER | ✓ | Código identificador único da cidade (PK) |

### Informações Básicas
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CIDNOME** | VARCHAR(37) | ✓ | Nome da cidade |
| **CIDDTFUND** | DATE | | Data de fundação da cidade |
| **CIDTIPO** | VARCHAR(14) | | Tipo de cidade (ex: Capital, Interior) |
| **CIDROTULO** | VARCHAR(14) | | Rótulo/classificação da cidade |
| **CIDOBSROTULO** | VARCHAR(261) | | Observações sobre o rótulo |

### Relacionamentos Geográficos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PAISCODIGO** 🔗 | INTEGER | ✓ | Código do país (FK → PAIS) |
| **REGCODIGO** 🔗 | INTEGER | ✓ | Código da região (FK → REGIAO) |
| **CIDUF** 🔗 | VARCHAR(14) | | Código da UF/Estado (FK → UF) |

### Informações Fiscais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CIDPCISS** | NUMERIC(27,4) | | Percentual de ISS da cidade |
| **CIDPCBSISS** | NUMERIC(27,4) | | Percentual de base de cálculo de ISS |
| **CIDCODCONTABIL** | VARCHAR(37) | | Código contábil da cidade |

### Códigos Governamentais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CIDMUNIBGE** | VARCHAR(37) | | Código do município IBGE |
| **CIDMUNSIAFI** | VARCHAR(37) | | Código do município SIAFI |
| **CIDCODDIPAM** | VARCHAR(14) | | Código DIPAM |
| **CIDCODNFSE** | VARCHAR(37) | | Código para NFSe (Nota Fiscal de Serviços Eletrônica) |

**Primary Key:** CIDCODIGO

**Observações sobre Campos:**
- **CIDUF**: Código da Unidade Federativa (Estado) - pode ser nulo para cidades de outros países
- **CIDPCISS**: Percentual de ISS utilizado para cálculos fiscais de serviços
- **CIDMUNIBGE**: Código oficial do IBGE para identificação do município
- **CIDCODNFSE**: Código específico para integração com sistemas de NFSe

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CIDADE Referencia (3 FKs):

#### 1. PAIS - Países
**Relacionamento:**
```
CIDADE.PAISCODIGO → PAIS.PAISCODIGO (N:1)
Constraint: PAIS_CIDADE
```

**Descrição**: Cada cidade está vinculada a um país específico.

**Informações da Tabela PAIS:**
- **Total:** 12 países
- **PK:** PAISCODIGO
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 2 tabelas (CIDADE, TBIIMPPAIS)

**Campos importantes em PAIS:**
- `PAISNOME` - Nome do país
- `PAISABREV` - Abreviação do país
- `PAISMASCCEP` - Máscara de CEP
- `PAISCODBC` - Código do país no banco central

**Uso:** Identificar o país de cada cidade, validações de CEP, cálculos fiscais internacionais.

---

#### 2. REGIAO - Regiões
**Relacionamento:**
```
CIDADE.REGCODIGO → REGIAO.REGCODIGO (N:1)
Constraint: REGIAO_CIDADE
```

**Descrição**: Cada cidade está vinculada a uma região geográfica específica.

**Informações da Tabela REGIAO:**
- **Total:** 6 regiões
- **PK:** REGCODIGO
- **Colunas:** 2 campos
- **FK Out:** 0
- **FK In:** 1 tabela (CIDADE)

**Campos importantes em REGIAO:**
- `REGNOME` - Nome da região

**Uso:** Agrupamento geográfico de cidades, relatórios por região, análises regionais.

---

#### 3. UF - Unidades Federativas (Estados)
**Relacionamento:**
```
CIDADE.CIDUF → UF.UFCODIGO (N:1)
Constraint: UF_CIDADE
```

**Descrição**: Cada cidade está vinculada a uma UF/Estado específica (opcional, pode ser nulo para cidades de outros países).

**Informações da Tabela UF:**
- **Total:** 26 UFs (estados brasileiros)
- **PK:** UFCODIGO
- **Colunas:** 2 campos
- **FK Out:** 0
- **FK In:** 6 tabelas (CIDADE, TBICMS, LCICMS, PROPAUTAICMSUB, BLOCOE316, PARTMEDICO)

**Campos importantes em UF:**
- `UFNOME` - Nome completo do estado
- `UFCODIGO` - Código da UF (ex: SP, RJ, MG)

**Uso:** Identificar o estado de cada cidade, cálculos fiscais por estado, validações de documentos.

---

### CIDADE é Referenciada Por (10 FKs):

#### 1. EMPRESA - Empresas
**Relacionamento:**
```
EMPRESA.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_EMPRESA
```

**Descrição**: Cada empresa está localizada em uma cidade específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos
- **FK Out:** 9
- **FK In:** 53 tabelas

**Campos importantes em EMPRESA relacionados a CIDADE:**
- `CIDCODIGO` - Cidade da empresa
- `EMPENDERECO` - Endereço da empresa
- `EMPBAIRRO` - Bairro da empresa
- `EMPCEP` - CEP da empresa

**Uso:** Identificar localização de empresas, cálculos fiscais por cidade, relatórios por localização.

---

#### 2. FUNCIO - Funcionários
**Relacionamento:**
```
FUNCIO.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_FUNCIO
```

**Descrição**: Funcionários podem estar vinculados a uma cidade específica (opcional).

**Informações da Tabela FUNCIO:**
- **Total:** 435 funcionários
- **PK:** FUNCODIGO
- **Colunas:** 74 campos
- **FK Out:** 6
- **FK In:** 23 tabelas

**Campos importantes em FUNCIO relacionados a CIDADE:**
- `CIDCODIGO` - Cidade do funcionário
- `FUNENDERECO` - Endereço do funcionário
- `FUNBAIRRO` - Bairro do funcionário
- `FUNCEP` - CEP do funcionário

**Uso:** Rastrear localização de funcionários, relatórios por cidade, análises de distribuição geográfica.

---

#### 3. ENDCLI - Endereços de Clientes
**Relacionamento:**
```
ENDCLI.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_ENDCLI
```

**Descrição**: Cada endereço de cliente está vinculado a uma cidade específica.

**Informações da Tabela ENDCLI:**
- **Total:** 9.272 endereços
- **PK:** (CLICODIGO, ENDCODIGO)
- **Colunas:** 57 campos
- **FK Out:** 6
- **FK In:** 38 tabelas

**Campos importantes em ENDCLI relacionados a CIDADE:**
- `CIDCODIGO` - Cidade do endereço
- `ENDENDERECO` - Logradouro
- `ENDBAIRRO` - Bairro
- `ENDCEP` - CEP
- `ENDFAT` - Flag de endereço de faturamento
- `ENDCOB` - Flag de endereço de cobrança
- `ENDENT` - Flag de endereço de entrega

**Uso:** Identificar localização de clientes, cálculos de frete, análises de distribuição geográfica de clientes.

---

#### 4. ENDERECO - Endereços Genéricos
**Relacionamento:**
```
ENDERECO.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_ENDERECO
```

**Descrição**: Endereços genéricos estão vinculados a uma cidade específica.

**Informações da Tabela ENDERECO:**
- **Total:** 3.439 endereços
- **PK:** ENDID
- **Colunas:** 9 campos
- **FK Out:** 2 (CIDADE, TPRUA)
- **FK In:** 3 tabelas

**Campos importantes em ENDERECO:**
- `CIDCODIGO` - Cidade do endereço
- `ENDNOME` - Nome do endereço
- `ENDBAIRRO` - Bairro
- `ENDCEP` - CEP
- `ENDENDERECO` - Logradouro
- `ENDNUMERO` - Número

**Uso:** Endereços genéricos para uso em diferentes contextos do sistema.

---

#### 5. ORCAM - Orçamentos
**Relacionamento:**
```
ORCAM.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_ORCAM
```

**Descrição**: Orçamentos podem estar vinculados a uma cidade específica (opcional).

**Informações da Tabela ORCAM:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (EMPCODIGO, ORCDTEMIS, ORCCODIGO)
- **Colunas:** 93 campos
- **FK Out:** 17
- **FK In:** 30 tabelas

**Campos importantes em ORCAM relacionados a CIDADE:**
- `CIDCODIGO` - Cidade do cliente no orçamento
- `ORCCLIENDERECO` - Endereço do cliente
- `ORCCLIBAIRRO` - Bairro do cliente

**Uso:** Identificar localização do cliente em orçamentos, cálculos de frete em orçamentos.

---

#### 6. TRANS - Transportadoras
**Relacionamento:**
```
TRANS.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_TRANS
```

**Descrição**: Cada transportadora está localizada em uma cidade específica.

**Informações da Tabela TRANS:**
- **Total:** 115 transportadoras
- **PK:** TRACODIGO
- **Colunas:** 27 campos
- **FK Out:** 3 (CIDADE, CLIEN, TPRUA)
- **FK In:** 4 tabelas

**Campos importantes em TRANS relacionados a CIDADE:**
- `CIDCODIGO` - Cidade da transportadora
- `TRAENDERECO` - Endereço da transportadora
- `TRABAIRRO` - Bairro
- `TRACEP` - CEP

**Uso:** Identificar localização de transportadoras, cálculos de frete, seleção de transportadoras por região.

---

#### 7. CLIREFCOM - Referências Comerciais de Clientes
**Relacionamento:**
```
CLIREFCOM.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADES_CLIREFCOM
```

**Descrição**: Referências comerciais de clientes estão vinculadas a uma cidade específica.

**Informações da Tabela CLIREFCOM:**
- **Total:** 0 registros (configurada mas não utilizada ainda)
- **PK:** (CLICODIGO, CRCCODIGO)
- **Colunas:** 21 campos
- **FK Out:** 2 (CIDADE, CLIEN)
- **FK In:** 0 tabelas

**Campos importantes em CLIREFCOM relacionados a CIDADE:**
- `CIDCODIGO` - Cidade da referência comercial
- `CRCENDERECO` - Endereço da referência
- `CRCBAIRRO` - Bairro
- `CRCCEP` - CEP

**Uso:** Cadastro de referências comerciais de clientes com localização geográfica.

---

#### 8. SDREFCOM - Referências Comerciais de Fornecedores
**Relacionamento:**
```
SDREFCOM.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_SDREFCOM
```

**Descrição**: Referências comerciais de fornecedores estão vinculadas a uma cidade específica.

**Informações da Tabela SDREFCOM:**
- **Total:** Volume não especificado
- **PK:** (SDCODIGO, SRCCODIGO)
- **Colunas:** Similar a CLIREFCOM
- **FK Out:** Similar a CLIREFCOM

**Uso:** Cadastro de referências comerciais de fornecedores com localização geográfica.

---

#### 9. SOCDEP - Sócios/Dependentes
**Relacionamento:**
```
SOCDEP.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_SOCDEP
```

**Descrição**: Sócios e dependentes estão vinculados a uma cidade específica.

**Informações da Tabela SOCDEP:**
- **Total:** Volume não especificado
- **PK:** Variável
- **Colunas:** Múltiplos campos
- **FK Out:** Variável

**Uso:** Cadastro de sócios e dependentes com localização geográfica.

---

#### 10. AGTEL - Agentes de Telemarketing
**Relacionamento:**
```
AGTEL.CIDCODIGO → CIDADE.CIDCODIGO (N:1)
Constraint: CIDADE_AGTEL
```

**Descrição**: Agentes de telemarketing estão vinculados a uma cidade específica.

**Informações da Tabela AGTEL:**
- **Total:** Volume não especificado
- **PK:** Variável
- **Colunas:** Múltiplos campos
- **FK Out:** Variável

**Uso:** Cadastro de agentes de telemarketing com localização geográfica.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ENDCLI → CLIEN (Clientes)

**Fluxo:** CIDADE → ENDCLI → CLIEN

**Descrição:** Através dos endereços de clientes, é possível identificar todos os clientes de cada cidade.

**Campos de junção:**
- `CIDADE.CIDCODIGO` → `ENDCLI.CIDCODIGO` → `ENDCLI.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de clientes por cidade, relatórios de distribuição geográfica de clientes.

---

### Via ENDCLI → CLIEN → PEDID (Pedidos)

**Fluxo:** CIDADE → ENDCLI → CLIEN → PEDID

**Descrição:** Através dos endereços e clientes, é possível identificar todos os pedidos por cidade.

**Campos de junção:**
- `CIDADE.CIDCODIGO` → `ENDCLI.CIDCODIGO` → `ENDCLI.CLICODIGO` → `CLIEN.CLICODIGO` → `PEDID.CLICODIGO`

**Uso:** Análises de vendas por cidade, relatórios de distribuição geográfica de pedidos.

---

### Via ENDCLI → CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CIDADE → ENDCLI → CLIEN → NOTAS

**Descrição:** Através dos endereços e clientes, é possível identificar todas as notas fiscais por cidade.

**Campos de junção:**
- `CIDADE.CIDCODIGO` → `ENDCLI.CIDCODIGO` → `ENDCLI.CLICODIGO` → `CLIEN.CLICODIGO` → `NOTAS.CLICODIGO`

**Uso:** Análises fiscais por cidade, relatórios de distribuição geográfica de vendas.

---

### Via FUNCIO → USUARIO (Usuários)

**Fluxo:** CIDADE → FUNCIO → USUARIO

**Descrição:** Através dos funcionários, é possível identificar usuários do sistema por cidade.

**Uso:** Análises de usuários por cidade, relatórios de distribuição geográfica de funcionários.

---

### Via EMPRESA → Múltiplas Tabelas Financeiras

**Fluxo:** CIDADE → EMPRESA → [Tabelas Financeiras]

**Descrição:** Através das empresas, é possível identificar operações financeiras por cidade.

**Uso:** Análises financeiras por cidade, relatórios de distribuição geográfica de operações.

---

### Via TRANS → PEDID (Pedidos com Transportadora)

**Fluxo:** CIDADE → TRANS → PEDID

**Descrição:** Através das transportadoras, é possível identificar pedidos por cidade de origem da transportadora.

**Uso:** Análises de logística por cidade, relatórios de distribuição geográfica de transportadoras.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Cidade

**Objetivo:** Obter visão completa de uma cidade incluindo todas as entidades relacionadas.

**Fluxo:**
```
CIDADE (CIDCODIGO)
  ↓
PAIS (PAISCODIGO)
  ↓
REGIAO (REGCODIGO)
  ↓
UF (CIDUF)
  ↓
ENDCLI (CIDCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    u.UFNOME AS ESTADO,
    r.REGNOME AS REGIAO,
    p.PAISNOME AS PAIS,
    c.CIDPCISS AS PERCENTUAL_ISS,
    c.CIDMUNIBGE AS CODIGO_IBGE,
    c.CIDMUNSIAFI AS CODIGO_SIAFI,
    COUNT(DISTINCT e.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT emp.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT t.TRACODIGO) AS TOTAL_TRANSPORTADORAS
FROM CIDADE c
LEFT JOIN PAIS p ON p.PAISCODIGO = c.PAISCODIGO
LEFT JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
LEFT JOIN ENDCLI e ON e.CIDCODIGO = c.CIDCODIGO
LEFT JOIN FUNCIO f ON f.CIDCODIGO = c.CIDCODIGO
LEFT JOIN EMPRESA emp ON emp.CIDCODIGO = c.CIDCODIGO
LEFT JOIN TRANS t ON t.CIDCODIGO = c.CIDCODIGO
WHERE c.CIDCODIGO = ?
GROUP BY c.CIDCODIGO, c.CIDNOME, c.CIDUF, u.UFNOME, r.REGNOME, 
    p.PAISNOME, c.CIDPCISS, c.CIDMUNIBGE, c.CIDMUNSIAFI;
```

---

### Exemplo 2: Análise de Vendas por Cidade

**Objetivo:** Identificar todas as vendas (notas fiscais) agrupadas por cidade.

**Fluxo:**
```
CIDADE (CIDCODIGO)
  ↓
ENDCLI (CIDCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
NOTAS (CLICODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    u.UFNOME AS ESTADO,
    COUNT(DISTINCT n.NFCODIGO) AS TOTAL_NOTAS,
    COUNT(DISTINCT cl.CLICODIGO) AS TOTAL_CLIENTES,
    SUM(n.NFVRMERCADORIA) AS VALOR_TOTAL_VENDAS,
    AVG(n.NFVRMERCADORIA) AS VALOR_MEDIO_VENDAS,
    MIN(n.NFDTEMIS) AS PRIMEIRA_VENDA,
    MAX(n.NFDTEMIS) AS ULTIMA_VENDA
FROM CIDADE c
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
LEFT JOIN ENDCLI e ON e.CIDCODIGO = c.CIDCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = e.CLICODIGO
LEFT JOIN NOTAS n ON n.CLICODIGO = cl.CLICODIGO
WHERE n.NFDTEMIS BETWEEN ? AND ?
GROUP BY c.CIDCODIGO, c.CIDNOME, c.CIDUF, u.UFNOME
ORDER BY VALOR_TOTAL_VENDAS DESC;
```

---

### Exemplo 3: Análise de Distribuição Geográfica de Clientes

**Objetivo:** Analisar distribuição de clientes por cidade, estado e região.

**Fluxo:**
```
CIDADE (CIDCODIGO)
  ↓
UF (CIDUF)
  ↓
REGIAO (REGCODIGO)
  ↓
ENDCLI (CIDCODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
SELECT
    r.REGNOME AS REGIAO,
    u.UFNOME AS ESTADO,
    c.CIDNOME AS CIDADE,
    COUNT(DISTINCT cl.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT e.ENDCODIGO) AS TOTAL_ENDERECOS,
    ROUND(COUNT(DISTINCT cl.CLICODIGO) * 100.0 / NULLIF((SELECT COUNT(*) FROM CLIEN), 0), 2) AS PERCENTUAL_CLIENTES
FROM CIDADE c
LEFT JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
LEFT JOIN ENDCLI e ON e.CIDCODIGO = c.CIDCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = e.CLICODIGO
WHERE cl.CLICODIGO IS NOT NULL
GROUP BY r.REGNOME, u.UFNOME, c.CIDNOME
ORDER BY TOTAL_CLIENTES DESC;

---

## 💡 Casos de Uso Práticos

### 1. Buscar Cidade Completa

**Objetivo:** Obter todas as informações de uma cidade específica.

```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    u.UFNOME AS ESTADO,
    r.REGNOME AS REGIAO,
    p.PAISNOME AS PAIS,
    c.CIDDTFUND AS DATA_FUNDACAO,
    c.CIDPCISS AS PERCENTUAL_ISS,
    c.CIDPCBSISS AS PERCENTUAL_BASE_ISS,
    c.CIDMUNIBGE AS CODIGO_IBGE,
    c.CIDMUNSIAFI AS CODIGO_SIAFI,
    c.CIDCODCONTABIL AS CODIGO_CONTABIL,
    c.CIDCODNFSE AS CODIGO_NFSE,
    c.CIDTIPO AS TIPO_CIDADE,
    c.CIDROTULO AS ROTULO
FROM CIDADE c
LEFT JOIN PAIS p ON p.PAISCODIGO = c.PAISCODIGO
LEFT JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
WHERE c.CIDCODIGO = ?;
```

---

### 2. Listar Cidades por Estado

**Objetivo:** Obter todas as cidades de um estado específico.

```sql
SELECT
    CIDCODIGO,
    CIDNOME AS CIDADE,
    CIDUF AS UF,
    CIDPCISS AS PERCENTUAL_ISS,
    CIDMUNIBGE AS CODIGO_IBGE
FROM CIDADE
WHERE CIDUF = ?
ORDER BY CIDNOME;
```

---

### 3. Análise de Cidades por Região

**Objetivo:** Identificar distribuição de cidades por região.

```sql
SELECT
    r.REGNOME AS REGIAO,
    COUNT(DISTINCT c.CIDCODIGO) AS TOTAL_CIDADES,
    COUNT(DISTINCT c.CIDUF) AS TOTAL_ESTADOS,
    STRING_AGG(DISTINCT u.UFNOME, ', ') AS ESTADOS
FROM CIDADE c
INNER JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
GROUP BY r.REGNOME
ORDER BY TOTAL_CIDADES DESC;
```

---

### 4. Relatório de Cidades com Maior Número de Clientes

**Objetivo:** Analisar cidades com maior concentração de clientes.

```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    u.UFNOME AS ESTADO,
    COUNT(DISTINCT e.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT e.ENDCODIGO) AS TOTAL_ENDERECOS,
    ROUND(COUNT(DISTINCT e.CLICODIGO) * 100.0 / NULLIF((SELECT COUNT(*) FROM CLIEN), 0), 2) AS PERCENTUAL_CLIENTES
FROM CIDADE c
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
LEFT JOIN ENDCLI e ON e.CIDCODIGO = c.CIDCODIGO
GROUP BY c.CIDCODIGO, c.CIDNOME, c.CIDUF, u.UFNOME
HAVING COUNT(DISTINCT e.CLICODIGO) > 0
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 5. Análise de Cidades com Informações Fiscais

**Objetivo:** Identificar cidades que possuem configurações fiscais (ISS).

```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    c.CIDPCISS AS PERCENTUAL_ISS,
    c.CIDPCBSISS AS PERCENTUAL_BASE_ISS,
    c.CIDCODNFSE AS CODIGO_NFSE,
    COUNT(DISTINCT emp.EMPCODIGO) AS TOTAL_EMPRESAS
FROM CIDADE c
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
LEFT JOIN EMPRESA emp ON emp.CIDCODIGO = c.CIDCODIGO
WHERE c.CIDPCISS IS NOT NULL
   OR c.CIDCODNFSE IS NOT NULL
GROUP BY c.CIDCODIGO, c.CIDNOME, c.CIDUF, c.CIDPCISS, c.CIDPCBSISS, c.CIDCODNFSE
ORDER BY c.CIDNOME;
```

---

### 6. Relatório de Cidades por País

**Objetivo:** Analisar distribuição de cidades por país.

```sql
SELECT
    p.PAISNOME AS PAIS,
    COUNT(DISTINCT c.CIDCODIGO) AS TOTAL_CIDADES,
    COUNT(DISTINCT c.CIDUF) AS TOTAL_ESTADOS,
    COUNT(DISTINCT c.REGCODIGO) AS TOTAL_REGIOES
FROM CIDADE c
INNER JOIN PAIS p ON p.PAISCODIGO = c.PAISCODIGO
GROUP BY p.PAISNOME
ORDER BY TOTAL_CIDADES DESC;
```

---

### 7. Verificar Cidades Não Utilizadas

**Objetivo:** Identificar cidades que não estão sendo utilizadas em nenhuma entidade.

```sql
SELECT
    c.CIDCODIGO,
    c.CIDNOME AS CIDADE,
    c.CIDUF AS UF,
    COUNT(DISTINCT e.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT emp.EMPCODIGO) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT t.TRACODIGO) AS TOTAL_TRANSPORTADORAS
FROM CIDADE c
LEFT JOIN ENDCLI e ON e.CIDCODIGO = c.CIDCODIGO
LEFT JOIN FUNCIO f ON f.CIDCODIGO = c.CIDCODIGO
LEFT JOIN EMPRESA emp ON emp.CIDCODIGO = c.CIDCODIGO
LEFT JOIN TRANS t ON t.CIDCODIGO = c.CIDCODIGO
GROUP BY c.CIDCODIGO, c.CIDNOME, c.CIDUF
HAVING COUNT(DISTINCT e.CLICODIGO) = 0
   AND COUNT(DISTINCT f.FUNCODIGO) = 0
   AND COUNT(DISTINCT emp.EMPCODIGO) = 0
   AND COUNT(DISTINCT t.TRACODIGO) = 0
ORDER BY c.CIDNOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CIDADE | Tipo |
|--------|-----------|---------------------|------|
| **CIDADE** | 736 | 1:1 | **TABELA PRINCIPAL** |
| ENDCLI | 9.272 | 12.6:1 | Endereços de clientes (média de 12.6 endereços por cidade) |
| ENDERECO | 3.439 | 4.7:1 | Endereços genéricos (média de 4.7 endereços por cidade) |
| FUNCIO | 435 | 0.59:1 | Funcionários (média de 0.59 funcionários por cidade) |
| EMPRESA | 6 | 0.008:1 | Empresas (média de 0.008 empresas por cidade) |
| TRANS | 115 | 0.16:1 | Transportadoras (média de 0.16 transportadoras por cidade) |

**Interpretação:**
- **736 cidades** cadastradas no sistema
- **Alta concentração** de endereços de clientes por cidade (média de 12.6 endereços)
- **Distribuição geográfica ampla** - cidades utilizadas em múltiplos contextos
- **Tabela essencial** para localização geográfica de todas as entidades

**Distribuição Esperada:**
- Cidades com muitos clientes: grandes centros urbanos
- Cidades com poucos clientes: cidades menores ou rurais
- Cidades não utilizadas: podem ser cidades cadastradas mas não utilizadas ainda

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CIDCODIGO** | CIDADE | Chave primária (PK) |
| **CIDCODIGO** | [10 tabelas] → CIDADE | Referência à cidade (FK) |
| **CIDNOME** | CIDADE | Nome da cidade (exibição, busca) |
| **CIDUF** | CIDADE → UF | Estado da cidade |
| **PAISCODIGO** | CIDADE → PAIS | País da cidade |
| **REGCODIGO** | CIDADE → REGIAO | Região da cidade |
| **CIDPCISS** | CIDADE | Percentual de ISS (cálculos fiscais) |
| **CIDMUNIBGE** | CIDADE | Código IBGE (integração governamental) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CIDADE.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por UF** - Para buscas por estado
3. **Índice por nome** - Para buscas textuais
4. **Índice por região** - Para análises regionais
5. **Índices nas tabelas relacionadas** - Mais críticos que índices em CIDADE

### Índices Sugeridos

```sql
-- Índice 1: Busca por UF (consultas frequentes)
CREATE INDEX IDX_CIDADE_UF ON CIDADE(CIDUF) WHERE CIDUF IS NOT NULL;

-- Índice 2: Busca por nome (consultas textuais)
CREATE INDEX IDX_CIDADE_NOME ON CIDADE(CIDNOME);

-- Índice 3: Busca por região (análises regionais)
CREATE INDEX IDX_CIDADE_REGIAO ON CIDADE(REGCODIGO);

-- Índice 4: Busca por país (análises internacionais)
CREATE INDEX IDX_CIDADE_PAIS ON CIDADE(PAISCODIGO);

-- Índice 5: Busca por código IBGE (integração governamental)
CREATE INDEX IDX_CIDADE_IBGE ON CIDADE(CIDMUNIBGE) WHERE CIDMUNIBGE IS NOT NULL;

-- Índice 6: Busca composta por UF e nome (consultas combinadas)
CREATE INDEX IDX_CIDADE_UF_NOME ON CIDADE(CIDUF, CIDNOME) WHERE CIDUF IS NOT NULL;
```

### Observações sobre Volume

- **Tabela pequena** (736 registros) - Performance não é crítica
- **Consultas são rápidas** devido ao volume moderado
- **Índices úteis** para buscas textuais e por UF
- **Focar em índices nas tabelas relacionadas** - ENDCLI e ENDERECO têm volumes maiores

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK)
SELECT CIDCODIGO, CIDNOME, CIDUF
FROM CIDADE
WHERE CIDCODIGO = ?;

-- ✅ OTIMIZADO (usar índice em CIDUF)
SELECT CIDCODIGO, CIDNOME, CIDUF
FROM CIDADE
WHERE CIDUF = ?
ORDER BY CIDNOME;

-- ✅ OTIMIZADO (usar índice em CIDNOME)
SELECT CIDCODIGO, CIDNOME, CIDUF
FROM CIDADE
WHERE UPPER(CIDNOME) LIKE UPPER(?)
ORDER BY CIDNOME;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CIDCODIGO, CIDNOME, CIDUF
FROM CIDADE
WHERE CIDUF = ?
  AND UPPER(CIDNOME) LIKE UPPER(?)
ORDER BY CIDNOME;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar cidades sem país válido
SELECT c.*
FROM CIDADE c
LEFT JOIN PAIS p ON p.PAISCODIGO = c.PAISCODIGO
WHERE c.PAISCODIGO IS NOT NULL
  AND p.PAISCODIGO IS NULL;

-- Verificar cidades sem região válida
SELECT c.*
FROM CIDADE c
LEFT JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
WHERE c.REGCODIGO IS NOT NULL
  AND r.REGCODIGO IS NULL;

-- Verificar cidades sem UF válida (quando CIDUF está preenchido)
SELECT c.*
FROM CIDADE c
WHERE c.CIDUF IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM UF u 
      WHERE u.UFCODIGO = c.CIDUF
  );
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CIDADE
WHERE CIDCODIGO IS NULL
   OR CIDNOME IS NULL
   OR CIDNOME = ''
   OR PAISCODIGO IS NULL
   OR REGCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CIDCODIGO, COUNT(*) AS QTD
FROM CIDADE
GROUP BY CIDCODIGO
HAVING COUNT(*) > 1;

-- Verificar nomes duplicados (pode ser válido em diferentes estados)
SELECT CIDNOME, CIDUF, COUNT(*) AS QTD
FROM CIDADE
GROUP BY CIDNOME, CIDUF
HAVING COUNT(*) > 1;

-- Verificar valores inválidos de ISS
SELECT *
FROM CIDADE
WHERE CIDPCISS IS NOT NULL
  AND (CIDPCISS < 0 OR CIDPCISS > 100);
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por UF
SELECT
    u.UFNOME AS ESTADO,
    COUNT(*) AS TOTAL_CIDADES,
    COUNT(CASE WHEN CIDPCISS IS NOT NULL THEN 1 END) AS CIDADES_COM_ISS,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CIDADE), 0), 2) AS PERCENTUAL
FROM CIDADE c
LEFT JOIN UF u ON u.UFCODIGO = c.CIDUF
GROUP BY u.UFNOME
ORDER BY TOTAL_CIDADES DESC;

-- Verificar distribuição por região
SELECT
    r.REGNOME AS REGIAO,
    COUNT(*) AS TOTAL_CIDADES,
    COUNT(DISTINCT c.CIDUF) AS TOTAL_ESTADOS,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM CIDADE), 0), 2) AS PERCENTUAL
FROM CIDADE c
INNER JOIN REGIAO r ON r.REGCODIGO = c.REGCODIGO
GROUP BY r.REGNOME
ORDER BY TOTAL_CIDADES DESC;

-- Verificar cidades com código IBGE
SELECT
    COUNT(*) AS TOTAL_CIDADES,
    COUNT(CIDMUNIBGE) AS CIDADES_COM_IBGE,
    COUNT(CIDMUNSIAFI) AS CIDADES_COM_SIAFI,
    COUNT(CIDCODNFSE) AS CIDADES_COM_NFSE,
    ROUND(COUNT(CIDMUNIBGE) * 100.0 / NULLIF(COUNT(*), 0), 2) AS PERCENTUAL_IBGE
FROM CIDADE;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Existente

O modelo `FirebirdCidade` já existe em `app/Models/Firebird/FirebirdCidade.php` e inclui:

**Funcionalidades Implementadas:**
- ✅ Métodos de formatação (getFormattedData)
- ✅ Métodos de estado (getStateName)
- ✅ Scopes para filtros comuns (byName, byState, byRegion, withISS, withFoundationDate)
- ✅ Relacionamento com endereços (addresses)
- ✅ Método de estatísticas (getStatistics)

**Melhorias Sugeridas:**

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

final class FirebirdCidade extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CIDADE';
    
    protected $primaryKey = 'CIDCODIGO';
    public $incrementing = true;
    protected $keyType = 'int';

    protected $casts = [
        'CIDCODIGO' => 'integer',
        'CIDNOME' => 'string',
        'CIDUF' => 'string',
        'REGCODIGO' => 'integer',
        'PAISCODIGO' => 'integer',
        'CIDDTFUND' => 'date',
        'CIDPCISS' => 'decimal:4',
        'CIDPCBSISS' => 'decimal:4',
        'CIDMUNIBGE' => 'string',
        'CIDMUNSIAFI' => 'string',
        'CIDCODCONTABIL' => 'string',
        'CIDCODNFSE' => 'string',
        'CIDTIPO' => 'string',
        'CIDROTULO' => 'string',
        'CIDCODDIPAM' => 'string',
    ];

    // Relacionamento com PAIS
    public function pais(): BelongsTo
    {
        return $this->belongsTo(FirebirdPais::class, 'PAISCODIGO', 'PAISCODIGO');
    }

    // Relacionamento com REGIAO
    public function regiao(): BelongsTo
    {
        return $this->belongsTo(FirebirdRegiao::class, 'REGCODIGO', 'REGCODIGO');
    }

    // Relacionamento com UF
    public function uf(): BelongsTo
    {
        return $this->belongsTo(FirebirdUf::class, 'CIDUF', 'UFCODIGO');
    }

    // Relacionamento com ENDCLI
    public function enderecosClientes(): HasMany
    {
        return $this->hasMany(FirebirdEndcli::class, 'CIDCODIGO', 'CIDCODIGO');
    }

    // Relacionamento com ENDERECO
    public function enderecos(): HasMany
    {
        return $this->hasMany(FirebirdEndereco::class, 'CIDCODIGO', 'CIDCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresas(): HasMany
    {
        return $this->hasMany(FirebirdEmpresa::class, 'CIDCODIGO', 'CIDCODIGO');
    }

    // Relacionamento com FUNCIO
    public function funcionarios(): HasMany
    {
        return $this->hasMany(FirebirdFuncio::class, 'CIDCODIGO', 'CIDCODIGO');
    }

    // Relacionamento com TRANS
    public function transportadoras(): HasMany
    {
        return $this->hasMany(FirebirdTrans::class, 'CIDCODIGO', 'CIDCODIGO');
    }

    // Relacionamento com clientes (via ENDCLI)
    public function clientes(): HasManyThrough
    {
        return $this->hasManyThrough(
            FirebirdClien::class,
            FirebirdEndcli::class,
            'CIDCODIGO', // FK em ENDCLI
            'CLICODIGO', // FK em CLIEN
            'CIDCODIGO', // PK em CIDADE
            'CLICODIGO' // PK em ENDCLI
        );
    }

    // Método para verificar se tem ISS configurado
    public function temISS(): bool
    {
        return !empty($this->CIDPCISS) && $this->CIDPCISS > 0;
    }

    // Método para verificar se tem código IBGE
    public function temCodigoIBGE(): bool
    {
        return !empty($this->CIDMUNIBGE);
    }

    // Método para obter total de clientes
    public function getTotalClientes(): int
    {
        return $this->enderecosClientes()->distinct('CLICODIGO')->count('CLICODIGO');
    }

    // Método para obter total de funcionários
    public function getTotalFuncionarios(): int
    {
        return $this->funcionarios()->count();
    }

    // Scope para filtrar por UF
    public function scopePorUF($query, string $uf)
    {
        return $query->where('CIDUF', $uf);
    }

    // Scope para filtrar por região
    public function scopePorRegiao($query, int $regiaoCodigo)
    {
        return $query->where('REGCODIGO', $regiaoCodigo);
    }

    // Scope para filtrar por país
    public function scopePorPais($query, int $paisCodigo)
    {
        return $query->where('PAISCODIGO', $paisCodigo);
    }

    // Scope para buscar por nome (case insensitive)
    public function scopePorNome($query, string $nome)
    {
        return $query->whereRaw('UPPER(CIDNOME) LIKE UPPER(?)', ['%' . $nome . '%']);
    }

    // Scope para cidades com ISS
    public function scopeComISS($query)
    {
        return $query->whereNotNull('CIDPCISS')
            ->where('CIDPCISS', '>', 0);
    }

    // Scope para cidades com código IBGE
    public function scopeComCodigoIBGE($query)
    {
        return $query->whereNotNull('CIDMUNIBGE')
            ->where('CIDMUNIBGE', '<>', '');
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_cidades' => self::count(),
            'total_estados' => self::whereNotNull('CIDUF')->distinct('CIDUF')->count(),
            'total_regioes' => self::distinct('REGCODIGO')->count(),
            'total_paises' => self::distinct('PAISCODIGO')->count(),
            'cidades_com_iss' => self::comISS()->count(),
            'cidades_com_ibge' => self::comCodigoIBGE()->count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - CIDCODIGO é único e sequencial
2. **Validação antes de inserir** - Verificar se país, região e UF existem
3. **Evitar duplicatas** - PK garante unicidade
4. **Nomes únicos por UF** - Validar unicidade de CIDNOME por CIDUF (se necessário)

### Performance

1. **Tabela pequena** - 736 registros, performance não é crítica
2. **Índices úteis** - Em CIDUF, CIDNOME, REGCODIGO para buscas frequentes
3. **Cache útil** - Tabela pode ser mantida em memória permanentemente
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CIDADE

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de códigos** - Validar formatos de códigos IBGE, SIAFI, NFSe

### Manutenção

1. **Revisão periódica** - Verificar cidades não utilizadas
2. **Padronização** - Manter nomes de cidades consistentes
3. **Atualização de códigos** - Manter códigos IBGE e SIAFI atualizados
4. **Documentação** - Documentar configurações fiscais por cidade

### Regras de Negócio

1. **Validação em tempo real** - Verificar se cidade existe antes de usar em endereços
2. **Consistência geográfica** - UF deve corresponder à região
3. **Cálculos fiscais** - Usar CIDPCISS para cálculos de ISS quando disponível
4. **Integração governamental** - Usar códigos IBGE e SIAFI para integrações

### Observações Especiais

1. **Amplamente utilizada** - CIDADE é referenciada por 10 tabelas diferentes
2. **Informações fiscais** - Armazena percentuais de ISS para cálculos fiscais
3. **Códigos governamentais** - Suporta códigos IBGE, SIAFI, NFSe para integrações
4. **Hierarquia geográfica** - País → Região → UF → Cidade

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

