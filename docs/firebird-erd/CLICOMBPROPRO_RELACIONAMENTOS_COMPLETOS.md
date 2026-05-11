# CLICOMBPROPRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLICOMBPROPRO (Combinações Cliente-Produto-Produto)
- **Total de Registros**: 14.364
- **Total de Colunas**: 12
- **Chave Primária**: (CLICODIGO, PROCODIGOA, PROCODIGOB) - Composta
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLICOMBPROPRO** é uma tabela de detalhes que armazena combinações específicas de produtos por cliente. Com **14.364 registros**, representa configurações personalizadas de combinações de produtos para clientes específicos, incluindo índices e preços de venda customizados.

Esta tabela funciona como **configurador de combinações cliente-específicas** e permite:
- Definir combinações de produtos personalizadas por cliente
- Armazenar índices específicos para cada produto na combinação
- Configurar preços de venda customizados por cliente
- Controlar múltiplos índices e preços para cada produto (índice 1, índice 2, preço 1, preço 2)
- Rastrear data de cadastro de cada combinação
- Suportar precificação diferenciada por cliente

Cada registro representa uma combinação específica de dois produtos (PROCODIGOA e PROCODIGOB) para um cliente específico (CLICODIGO), contendo:
- Identificação do cliente (CLICODIGO)
- Produto A da combinação (PROCODIGOA)
- Produto B da combinação (PROCODIGOB)
- Índices do Produto A (CCINDICEPROA, CCINDICEPROA2)
- Preços de venda do Produto A (CCPCOVENDAPROA, CCPCOVENDAPROA2)
- Índices do Produto B (CCINDICEPROB, CCINDICEPROB2)
- Preços de venda do Produto B (CCPCOVENDAPROB, CCPCOVENDAPROB2)
- Data de cadastro da combinação (CCPDTCADASTRO)

O sistema utiliza esta tabela para personalizar combinações de produtos e precificação por cliente, permitindo que diferentes clientes tenham diferentes configurações para as mesmas combinações de produtos.

**Observação Importante:** CLICOMBPROPRO permite que cada cliente tenha suas próprias combinações de produtos com índices e preços específicos, diferente de COMBPRODUTOS que armazena combinações gerais do sistema.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **PROCODIGOA** 🔑🔗 | VARCHAR(14) | ✓ | Código do produto A (PK + FK → PRODU) |
| **PROCODIGOB** 🔑🔗 | VARCHAR(14) | ✓ | Código do produto B (PK + FK → PRODU) |

### Informações do Produto A
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCINDICEPROA** | NUMERIC(16,4) | | Índice 1 do produto A na combinação |
| **CCINDICEPROA2** | NUMERIC(16,4) | | Índice 2 do produto A na combinação |
| **CCPCOVENDAPROA** | NUMERIC(16,4) | | Preço de venda 1 do produto A |
| **CCPCOVENDAPROA2** | NUMERIC(16,4) | | Preço de venda 2 do produto A |

### Informações do Produto B
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCINDICEPROB** | NUMERIC(16,4) | | Índice 1 do produto B na combinação |
| **CCINDICEPROB2** | NUMERIC(16,4) | | Índice 2 do produto B na combinação |
| **CCPCOVENDAPROB** | NUMERIC(16,4) | | Preço de venda 1 do produto B |
| **CCPCOVENDAPROB2** | NUMERIC(16,4) | | Preço de venda 2 do produto B |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CCPDTCADASTRO** | DATE | | Data de cadastro da combinação |

**Primary Key:** (CLICODIGO, PROCODIGOA, PROCODIGOB)

**Observações sobre Campos:**
- **PROCODIGOA e PROCODIGOB**: Dois produtos que formam a combinação para o cliente específico.
- **Índices**: Valores numéricos que podem representar graus, medidas ou outros parâmetros específicos para produtos ópticos.
- **Preços de venda**: Permite múltiplos preços (1 e 2) para cada produto na combinação, possivelmente para diferentes condições ou quantidades.
- **Data de cadastro**: Rastreia quando a combinação foi configurada para o cliente.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLICOMBPROPRO Referencia (3 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLICOMBPROPRO.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLICOMBPROPRO
```

**Descrição**: Cada combinação está vinculada a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Campos importantes em CLIEN relacionados a CLICOMBPROPRO:**
- `CLICODIGO` - Código do cliente
- `CLINOMEFANT` - Nome fantasia
- `CLIRAZSOCIAL` - Razão social
- `CLICLIENTE` - Flag indicando se é cliente

**Uso:** Identificar o cliente proprietário da combinação, relatórios por cliente, análises de combinações por cliente.

---

#### 2. PRODU - Produtos (2 FKs)

**2.1. PROCODIGOA - Produto A**
```
CLICOMBPROPRO.PROCODIGOA → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CLICOMBPROPRO
```

**2.2. PROCODIGOB - Produto B**
```
CLICOMBPROPRO.PROCODIGOB → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CLICOMBPROPROB
```

**Descrição**: Cada combinação está vinculada a dois produtos específicos (Produto A e Produto B).

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos
- **FK Out:** 0
- **FK In:** 101 tabelas

**Campos importantes em PRODU relacionados a CLICOMBPROPRO:**
- `PROCODIGO` - Código do produto
- `PRODESCRICAO` - Descrição do produto
- `PROTIPO` - Tipo do produto
- `PROSITUACAO` - Situação do produto (ATIVO/INATIVO)

**Uso:** Identificar os produtos da combinação, validar existência dos produtos, obter informações dos produtos.

---

### CLICOMBPROPRO é Referenciada Por

**Nenhuma tabela** referencia CLICOMBPROPRO diretamente. Esta é uma tabela folha utilizada para configuração e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLICOMBPROPRO → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem utilizar as combinações configuradas.

**Campos de junção:**
- `CLICOMBPROPRO.CLICODIGO` → `CLIEN.CLICODIGO` → `PEDID.CLICODIGO`

**Uso:** Análises de pedidos que utilizam combinações específicas por cliente.

---

### Via CLIEN → PDPRD (Produtos em Pedidos)

**Fluxo:** CLICOMBPROPRO → CLIEN → PEDID → PDPRD

**Descrição:** Através do cliente e pedidos, é possível identificar produtos em pedidos que podem estar relacionados às combinações.

**Uso:** Análises de produtos vendidos em combinações por cliente.

---

### Via PRODU → PDPRD (Produtos em Pedidos)

**Fluxo:** CLICOMBPROPRO → PRODU → PDPRD

**Descrição:** Através dos produtos da combinação, é possível identificar pedidos que contêm esses produtos.

**Uso:** Análises de vendas de produtos específicos em combinações.

---

### Via PRODU → TBPPRODU (Tabelas de Preços)

**Fluxo:** CLICOMBPROPRO → PRODU → TBPPRODU

**Descrição:** Através dos produtos, é possível identificar tabelas de preços relacionadas.

**Uso:** Comparação de preços de combinações com tabelas de preços gerais.

---

### Via CLIEN → CLIPRO (Cliente x Produto)

**Fluxo:** CLICOMBPROPRO → CLIEN → CLIPRO

**Descrição:** Através do cliente, é possível identificar produtos associados diretamente ao cliente.

**Uso:** Análises de produtos preferidos por cliente.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Combinação por Cliente

**Objetivo:** Obter visão completa de uma combinação incluindo informações do cliente e produtos.

**Fluxo:**
```
CLICOMBPROPRO (CLICODIGO, PROCODIGOA, PROCODIGOB)
  ↓
CLIEN (CLICODIGO)
  ↓
PRODU (PROCODIGOA, PROCODIGOB)
```

**Query SQL:**
```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.CCINDICEPROA AS INDICE_A_1,
    ccp.CCINDICEPROA2 AS INDICE_A_2,
    ccp.CCPCOVENDAPROA AS PRECO_A_1,
    ccp.CCPCOVENDAPROA2 AS PRECO_A_2,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROB AS INDICE_B_1,
    ccp.CCINDICEPROB2 AS INDICE_B_2,
    ccp.CCPCOVENDAPROB AS PRECO_B_1,
    ccp.CCPCOVENDAPROB2 AS PRECO_B_2,
    ccp.CCPDTCADASTRO AS DATA_CADASTRO
FROM CLICOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CLICODIGO = ?
ORDER BY ccp.CCPDTCADASTRO DESC;
```

---

### Exemplo 2: Análise de Combinações por Produto

**Objetivo:** Identificar todos os clientes que têm combinações com um produto específico.

**Fluxo:**
```
PRODU (PROCODIGO)
  ↓
CLICOMBPROPRO (PROCODIGOA ou PROCODIGOB)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    p.PROCODIGO,
    p.PRODESCRICAO AS PRODUTO,
    COUNT(DISTINCT ccp.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT CASE WHEN ccp.PROCODIGOA = p.PROCODIGO THEN ccp.PROCODIGOB END) AS COMBINACOES_COM_PRODUTO_A,
    COUNT(DISTINCT CASE WHEN ccp.PROCODIGOB = p.PROCODIGO THEN ccp.PROCODIGOA END) AS COMBINACOES_COM_PRODUTO_B,
    COUNT(*) AS TOTAL_COMBINACOES
FROM PRODU p
LEFT JOIN CLICOMBPROPRO ccp ON ccp.PROCODIGOA = p.PROCODIGO 
    OR ccp.PROCODIGOB = p.PROCODIGO
WHERE p.PROCODIGO = ?
GROUP BY p.PROCODIGO, p.PRODESCRICAO;
```

---

### Exemplo 3: Análise de Combinações com Pedidos

**Objetivo:** Identificar combinações que foram utilizadas em pedidos.

**Fluxo:**
```
CLICOMBPROPRO (CLICODIGO, PROCODIGOA, PROCODIGOB)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
  ↓
PDPRD (ID_PEDIDO, PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT pdp.PDPSEQ) AS TOTAL_ITENS_PEDIDOS,
    SUM(CASE WHEN pdp.PROCODIGO = ccp.PROCODIGOA THEN pdp.PDPVRMERC ELSE 0 END) AS VALOR_VENDAS_PRODUTO_A,
    SUM(CASE WHEN pdp.PROCODIGO = ccp.PROCODIGOB THEN pdp.PDPVRMERC ELSE 0 END) AS VALOR_VENDAS_PRODUTO_B
FROM CLICOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
LEFT JOIN PEDID pd ON pd.CLICODIGO = ccp.CLICODIGO
LEFT JOIN PDPRD pdp ON pdp.ID_PEDIDO = pd.ID_PEDIDO
    AND (pdp.PROCODIGO = ccp.PROCODIGOA OR pdp.PROCODIGO = ccp.PROCODIGOB)
WHERE ccp.CLICODIGO = ?
GROUP BY ccp.CLICODIGO, cl.CLINOMEFANT, ccp.PROCODIGOA, pa.PRODESCRICAO, 
    ccp.PROCODIGOB, pb.PRODESCRICAO
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Combinação Completa

**Objetivo:** Obter todas as informações de uma combinação específica.

```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.CCINDICEPROA AS INDICE_A_1,
    ccp.CCINDICEPROA2 AS INDICE_A_2,
    ccp.CCPCOVENDAPROA AS PRECO_A_1,
    ccp.CCPCOVENDAPROA2 AS PRECO_A_2,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROB AS INDICE_B_1,
    ccp.CCINDICEPROB2 AS INDICE_B_2,
    ccp.CCPCOVENDAPROB AS PRECO_B_1,
    ccp.CCPCOVENDAPROB2 AS PRECO_B_2,
    ccp.CCPDTCADASTRO AS DATA_CADASTRO
FROM CLICOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CLICODIGO = ?
  AND ccp.PROCODIGOA = ?
  AND ccp.PROCODIGOB = ?;
```

---

### 2. Listar Todas as Combinações de um Cliente

**Objetivo:** Obter todas as combinações configuradas para um cliente específico.

```sql
SELECT
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROA AS INDICE_A,
    ccp.CCINDICEPROB AS INDICE_B,
    ccp.CCPCOVENDAPROA AS PRECO_A,
    ccp.CCPCOVENDAPROB AS PRECO_B,
    ccp.CCPDTCADASTRO AS DATA_CADASTRO
FROM CLICOMBPROPRO ccp
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CLICODIGO = ?
ORDER BY ccp.CCPDTCADASTRO DESC;
```

---

### 3. Análise de Combinações Mais Utilizadas

**Objetivo:** Identificar combinações de produtos mais comuns entre clientes.

```sql
SELECT
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    COUNT(DISTINCT ccp.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_COMBINACOES,
    AVG(ccp.CCPCOVENDAPROA) AS PRECO_MEDIO_A,
    AVG(ccp.CCPCOVENDAPROB) AS PRECO_MEDIO_B,
    MIN(ccp.CCPDTCADASTRO) AS PRIMEIRA_COMBINACAO,
    MAX(ccp.CCPDTCADASTRO) AS ULTIMA_COMBINACAO
FROM CLICOMBPROPRO ccp
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
GROUP BY ccp.PROCODIGOA, pa.PRODESCRICAO, ccp.PROCODIGOB, pb.PRODESCRICAO
ORDER BY TOTAL_CLIENTES DESC;
```

---

### 4. Relatório de Combinações por Cliente e Período

**Objetivo:** Analisar combinações cadastradas por cliente em um período específico.

```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(DISTINCT ccp.PROCODIGOA) AS TOTAL_PRODUTOS_A,
    COUNT(DISTINCT ccp.PROCODIGOB) AS TOTAL_PRODUTOS_B,
    AVG(ccp.CCPCOVENDAPROA) AS PRECO_MEDIO_A,
    AVG(ccp.CCPCOVENDAPROB) AS PRECO_MEDIO_B,
    MIN(ccp.CCPDTCADASTRO) AS PRIMEIRA_COMBINACAO,
    MAX(ccp.CCPDTCADASTRO) AS ULTIMA_COMBINACAO
FROM CLICOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
WHERE ccp.CCPDTCADASTRO BETWEEN ? AND ?
GROUP BY ccp.CLICODIGO, cl.CLINOMEFANT
ORDER BY TOTAL_COMBINACOES DESC;
```

---

### 5. Análise de Preços de Combinações

**Objetivo:** Comparar preços de combinações entre diferentes clientes.

```sql
SELECT
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    COUNT(DISTINCT ccp.CLICODIGO) AS TOTAL_CLIENTES,
    MIN(ccp.CCPCOVENDAPROA) AS PRECO_MIN_A,
    MAX(ccp.CCPCOVENDAPROA) AS PRECO_MAX_A,
    AVG(ccp.CCPCOVENDAPROA) AS PRECO_MEDIO_A,
    MIN(ccp.CCPCOVENDAPROB) AS PRECO_MIN_B,
    MAX(ccp.CCPCOVENDAPROB) AS PRECO_MAX_B,
    AVG(ccp.CCPCOVENDAPROB) AS PRECO_MEDIO_B
FROM CLICOMBPROPRO ccp
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CCPCOVENDAPROA IS NOT NULL
   OR ccp.CCPCOVENDAPROB IS NOT NULL
GROUP BY ccp.PROCODIGOA, pa.PRODESCRICAO, ccp.PROCODIGOB, pb.PRODESCRICAO
HAVING COUNT(DISTINCT ccp.CLICODIGO) > 1
ORDER BY PRECO_MEDIO_A DESC;
```

---

### 6. Relatório de Combinações com Índices

**Objetivo:** Identificar combinações que possuem índices configurados.

```sql
SELECT
    ccp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ccp.PROCODIGOA,
    pa.PRODESCRICAO AS PRODUTO_A,
    ccp.CCINDICEPROA AS INDICE_A_1,
    ccp.CCINDICEPROA2 AS INDICE_A_2,
    ccp.PROCODIGOB,
    pb.PRODESCRICAO AS PRODUTO_B,
    ccp.CCINDICEPROB AS INDICE_B_1,
    ccp.CCINDICEPROB2 AS INDICE_B_2
FROM CLICOMBPROPRO ccp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
INNER JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
INNER JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE ccp.CCINDICEPROA IS NOT NULL
   OR ccp.CCINDICEPROA2 IS NOT NULL
   OR ccp.CCINDICEPROB IS NOT NULL
   OR ccp.CCINDICEPROB2 IS NOT NULL
ORDER BY ccp.CLICODIGO, ccp.PROCODIGOA, ccp.PROCODIGOB;
```

---

### 7. Verificar Combinações Duplicadas

**Objetivo:** Identificar combinações duplicadas (mesmos produtos em ordem diferente).

```sql
SELECT
    CASE 
        WHEN ccp1.PROCODIGOA < ccp1.PROCODIGOB 
        THEN ccp1.PROCODIGOA || '-' || ccp1.PROCODIGOB
        ELSE ccp1.PROCODIGOB || '-' || ccp1.PROCODIGOA
    END AS COMBINACAO_NORMALIZADA,
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(DISTINCT ccp1.CLICODIGO) AS TOTAL_CLIENTES,
    STRING_AGG(DISTINCT ccp1.CLICODIGO || ':' || ccp1.PROCODIGOA || '-' || ccp1.PROCODIGOB, ', ') AS COMBINACOES
FROM CLICOMBPROPRO ccp1
GROUP BY 
    CASE 
        WHEN ccp1.PROCODIGOA < ccp1.PROCODIGOB 
        THEN ccp1.PROCODIGOA || '-' || ccp1.PROCODIGOB
        ELSE ccp1.PROCODIGOB || '-' || ccp1.PROCODIGOA
    END
HAVING COUNT(*) > 1
ORDER BY TOTAL_COMBINACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLICOMBPROPRO | Tipo |
|--------|-----------|---------------------|------|
| **CLICOMBPROPRO** | 14.364 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 0.64:1 | Clientes (média de 0.64 combinações por cliente) |
| PRODU | 178.187 | 12.4:1 | Produtos (média de 12.4 produtos por combinação) |

**Interpretação:**
- **14.364 combinações** cadastradas no sistema
- **Média de 1.55 combinações por cliente** - alguns clientes têm múltiplas combinações
- **Cada combinação usa 2 produtos** - total de produtos únicos envolvidos é menor
- **Personalização por cliente** - cada cliente pode ter suas próprias combinações

**Distribuição Esperada:**
- Clientes com muitas combinações: clientes com necessidades específicas ou grandes volumes
- Clientes com poucas combinações: clientes com necessidades padrão
- Combinações não utilizadas: podem ser combinações cadastradas mas não utilizadas em pedidos

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLICODIGO, PROCODIGOA, PROCODIGOB** | CLICOMBPROPRO | Chave primária composta (PK) |
| **CLICODIGO** | CLICOMBPROPRO → CLIEN | Cliente da combinação |
| **PROCODIGOA** | CLICOMBPROPRO → PRODU | Produto A da combinação |
| **PROCODIGOB** | CLICOMBPROPRO → PRODU | Produto B da combinação |
| **CCINDICEPROA, CCINDICEPROB** | CLICOMBPROPRO | Índices dos produtos |
| **CCPCOVENDAPROA, CCPCOVENDAPROB** | CLICOMBPROPRO | Preços de venda dos produtos |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLICOMBPROPRO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por produto A** - Para buscas por produto A
4. **Índice por produto B** - Para buscas por produto B
5. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLICOMBPROPRO_CLIENTE ON CLICOMBPROPRO(CLICODIGO);

-- Índice 2: Busca por produto A (consultas por produto)
CREATE INDEX IDX_CLICOMBPROPRO_PRODUTO_A ON CLICOMBPROPRO(PROCODIGOA);

-- Índice 3: Busca por produto B (consultas por produto)
CREATE INDEX IDX_CLICOMBPROPRO_PRODUTO_B ON CLICOMBPROPRO(PROCODIGOB);

-- Índice 4: Busca composta por cliente e produto A
CREATE INDEX IDX_CLICOMBPROPRO_CLI_PROA ON CLICOMBPROPRO(CLICODIGO, PROCODIGOA);

-- Índice 5: Busca composta por cliente e produto B
CREATE INDEX IDX_CLICOMBPROPRO_CLI_PROB ON CLICOMBPROPRO(CLICODIGO, PROCODIGOB);

-- Índice 6: Busca por data de cadastro (consultas por período)
CREATE INDEX IDX_CLICOMBPROPRO_DATA ON CLICOMBPROPRO(CCPDTCADASTRO) 
    WHERE CCPDTCADASTRO IS NOT NULL;
```

### Observações sobre Volume

- **Tabela média** (14.364 registros) - Performance moderada
- **Consultas são rápidas** devido ao volume moderado
- **Índices úteis** para buscas por cliente e produtos
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e produtos

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK composta)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB, CCPCOVENDAPROA, CCPCOVENDAPROB
FROM CLICOMBPROPRO
WHERE CLICODIGO = ?
  AND PROCODIGOA = ?
  AND PROCODIGOB = ?;

-- ✅ OTIMIZADO (usar índice em CLICODIGO)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB
FROM CLICOMBPROPRO
WHERE CLICODIGO = ?
ORDER BY CCPDTCADASTRO DESC;

-- ✅ OTIMIZADO (usar índice em PROCODIGOA)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB
FROM CLICOMBPROPRO
WHERE PROCODIGOA = ?
ORDER BY CLICODIGO;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB, CCPCOVENDAPROA, CCPCOVENDAPROB
FROM CLICOMBPROPRO
WHERE CLICODIGO = ?
  AND PROCODIGOA = ?
ORDER BY CCPDTCADASTRO DESC;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar combinações sem cliente válido
SELECT ccp.*
FROM CLICOMBPROPRO ccp
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ccp.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar combinações sem produto A válido
SELECT ccp.*
FROM CLICOMBPROPRO ccp
LEFT JOIN PRODU pa ON pa.PROCODIGO = ccp.PROCODIGOA
WHERE pa.PROCODIGO IS NULL;

-- Verificar combinações sem produto B válido
SELECT ccp.*
FROM CLICOMBPROPRO ccp
LEFT JOIN PRODU pb ON pb.PROCODIGO = ccp.PROCODIGOB
WHERE pb.PROCODIGO IS NULL;

-- Verificar se produto A e B são diferentes
SELECT *
FROM CLICOMBPROPRO
WHERE PROCODIGOA = PROCODIGOB;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLICOMBPROPRO
WHERE CLICODIGO IS NULL
   OR PROCODIGOA IS NULL
   OR PROCODIGOA = ''
   OR PROCODIGOB IS NULL
   OR PROCODIGOB = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, PROCODIGOA, PROCODIGOB, COUNT(*) AS QTD
FROM CLICOMBPROPRO
GROUP BY CLICODIGO, PROCODIGOA, PROCODIGOB
HAVING COUNT(*) > 1;

-- Verificar valores inválidos de preços
SELECT *
FROM CLICOMBPROPRO
WHERE (CCPCOVENDAPROA IS NOT NULL AND CCPCOVENDAPROA < 0)
   OR (CCPCOVENDAPROA2 IS NOT NULL AND CCPCOVENDAPROA2 < 0)
   OR (CCPCOVENDAPROB IS NOT NULL AND CCPCOVENDAPROB < 0)
   OR (CCPCOVENDAPROB2 IS NOT NULL AND CCPCOVENDAPROB2 < 0);

-- Verificar valores inválidos de índices
SELECT *
FROM CLICOMBPROPRO
WHERE (CCINDICEPROA IS NOT NULL AND CCINDICEPROA < 0)
   OR (CCINDICEPROA2 IS NOT NULL AND CCINDICEPROA2 < 0)
   OR (CCINDICEPROB IS NOT NULL AND CCINDICEPROB < 0)
   OR (CCINDICEPROB2 IS NOT NULL AND CCINDICEPROB2 < 0);
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por cliente
SELECT
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_COMBINACOES,
    AVG(COMBINACOES_POR_CLIENTE) AS MEDIA_COMBINACOES_POR_CLIENTE,
    MAX(COMBINACOES_POR_CLIENTE) AS MAX_COMBINACOES_POR_CLIENTE,
    MIN(COMBINACOES_POR_CLIENTE) AS MIN_COMBINACOES_POR_CLIENTE
FROM (
    SELECT 
        CLICODIGO,
        COUNT(*) AS COMBINACOES_POR_CLIENTE
    FROM CLICOMBPROPRO
    GROUP BY CLICODIGO
);

-- Verificar combinações com preços configurados
SELECT
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(CASE WHEN CCPCOVENDAPROA IS NOT NULL THEN 1 END) AS COM_PRECO_A_1,
    COUNT(CASE WHEN CCPCOVENDAPROA2 IS NOT NULL THEN 1 END) AS COM_PRECO_A_2,
    COUNT(CASE WHEN CCPCOVENDAPROB IS NOT NULL THEN 1 END) AS COM_PRECO_B_1,
    COUNT(CASE WHEN CCPCOVENDAPROB2 IS NOT NULL THEN 1 END) AS COM_PRECO_B_2,
    COUNT(CASE WHEN CCPCOVENDAPROA IS NOT NULL OR CCPCOVENDAPROB IS NOT NULL THEN 1 END) AS COM_ALGUM_PRECO
FROM CLICOMBPROPRO;

-- Verificar combinações com índices configurados
SELECT
    COUNT(*) AS TOTAL_COMBINACOES,
    COUNT(CASE WHEN CCINDICEPROA IS NOT NULL THEN 1 END) AS COM_INDICE_A_1,
    COUNT(CASE WHEN CCINDICEPROA2 IS NOT NULL THEN 1 END) AS COM_INDICE_A_2,
    COUNT(CASE WHEN CCINDICEPROB IS NOT NULL THEN 1 END) AS COM_INDICE_B_1,
    COUNT(CASE WHEN CCINDICEPROB2 IS NOT NULL THEN 1 END) AS COM_INDICE_B_2,
    COUNT(CASE WHEN CCINDICEPROA IS NOT NULL OR CCINDICEPROB IS NOT NULL THEN 1 END) AS COM_ALGUM_INDICE
FROM CLICOMBPROPRO;
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

final class FirebirdClicombpropro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLICOMBPROPRO';
    
    protected $primaryKey = ['CLICODIGO', 'PROCODIGOA', 'PROCODIGOB'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'PROCODIGOA' => 'string',
        'PROCODIGOB' => 'string',
        'CCINDICEPROA' => 'decimal:4',
        'CCINDICEPROA2' => 'decimal:4',
        'CCINDICEPROB' => 'decimal:4',
        'CCINDICEPROB2' => 'decimal:4',
        'CCPCOVENDAPROA' => 'decimal:4',
        'CCPCOVENDAPROA2' => 'decimal:4',
        'CCPCOVENDAPROB' => 'decimal:4',
        'CCPCOVENDAPROB2' => 'decimal:4',
        'CCPDTCADASTRO' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com PRODU (Produto A)
    public function produtoA(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGOA', 'PROCODIGO');
    }

    // Relacionamento com PRODU (Produto B)
    public function produtoB(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGOB', 'PROCODIGO');
    }

    // Método para verificar se tem preços configurados
    public function temPrecos(): bool
    {
        return !empty($this->CCPCOVENDAPROA) 
            || !empty($this->CCPCOVENDAPROA2)
            || !empty($this->CCPCOVENDAPROB)
            || !empty($this->CCPCOVENDAPROB2);
    }

    // Método para verificar se tem índices configurados
    public function temIndices(): bool
    {
        return !empty($this->CCINDICEPROA) 
            || !empty($this->CCINDICEPROA2)
            || !empty($this->CCINDICEPROB)
            || !empty($this->CCINDICEPROB2);
    }

    // Método para obter preço principal do produto A
    public function getPrecoProdutoA(): ?float
    {
        return $this->CCPCOVENDAPROA ?? $this->CCPCOVENDAPROA2;
    }

    // Método para obter preço principal do produto B
    public function getPrecoProdutoB(): ?float
    {
        return $this->CCPCOVENDAPROB ?? $this->CCPCOVENDAPROB2;
    }

    // Método para obter índice principal do produto A
    public function getIndiceProdutoA(): ?float
    {
        return $this->CCINDICEPROA ?? $this->CCINDICEPROA2;
    }

    // Método para obter índice principal do produto B
    public function getIndiceProdutoB(): ?float
    {
        return $this->CCINDICEPROB ?? $this->CCINDICEPROB2;
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por produto A
    public function scopePorProdutoA($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGOA', $produtoCodigo);
    }

    // Scope para filtrar por produto B
    public function scopePorProdutoB($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGOB', $produtoCodigo);
    }

    // Scope para filtrar por qualquer produto (A ou B)
    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where(function($q) use ($produtoCodigo) {
            $q->where('PROCODIGOA', $produtoCodigo)
              ->orWhere('PROCODIGOB', $produtoCodigo);
        });
    }

    // Scope para filtrar combinações com preços
    public function scopeComPrecos($query)
    {
        return $query->where(function($q) {
            $q->whereNotNull('CCPCOVENDAPROA')
              ->orWhereNotNull('CCPCOVENDAPROA2')
              ->orWhereNotNull('CCPCOVENDAPROB')
              ->orWhereNotNull('CCPCOVENDAPROB2');
        });
    }

    // Scope para filtrar combinações com índices
    public function scopeComIndices($query)
    {
        return $query->where(function($q) {
            $q->whereNotNull('CCINDICEPROA')
              ->orWhereNotNull('CCINDICEPROA2')
              ->orWhereNotNull('CCINDICEPROB')
              ->orWhereNotNull('CCINDICEPROB2');
        });
    }

    // Scope para filtrar por período de cadastro
    public function scopePorPeriodo($query, string $dataInicio, string $dataFim)
    {
        return $query->whereBetween('CCPDTCADASTRO', [$dataInicio, $dataFim]);
    }

    // Método estático para buscar combinação específica
    public static function buscarCombinacao(int $clienteCodigo, string $produtoA, string $produtoB): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('PROCODIGOA', $produtoA)
            ->where('PROCODIGOB', $produtoB)
            ->first();
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_combinacoes' => self::count(),
            'total_clientes' => self::distinct('CLICODIGO')->count(),
            'total_produtos_unicos' => self::selectRaw('COUNT(DISTINCT PROCODIGOA) + COUNT(DISTINCT PROCODIGOB) as total')
                ->first()->total ?? 0,
            'com_precos' => self::comPrecos()->count(),
            'com_indices' => self::comIndices()->count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 3 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e produtos existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Produtos diferentes** - Validar que PROCODIGOA ≠ PROCODIGOB

### Performance

1. **Tabela média** - 14.364 registros, performance moderada
2. **Índices úteis** - Em CLICODIGO, PROCODIGOA, PROCODIGOB para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + produto)
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CLICOMBPROPRO

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de valores** - Preços e índices devem ser >= 0

### Manutenção

1. **Revisão periódica** - Verificar combinações não utilizadas
2. **Padronização** - Manter estrutura de índices e preços consistente
3. **Documentação** - Documentar significado dos índices e preços
4. **Backup regular** - Tabela importante para configuração comercial

### Regras de Negócio

1. **Validação em tempo real** - Verificar se combinação existe antes de usar
2. **Consistência** - Preços e índices devem corresponder à configuração do cliente
3. **Personalização** - Cada cliente pode ter suas próprias combinações
4. **Histórico** - Manter data de cadastro para rastreabilidade

### Observações Especiais

1. **Personalização por cliente** - CLICOMBPROPRO permite configurações específicas por cliente
2. **Múltiplos índices e preços** - Suporta 2 índices e 2 preços por produto
3. **Combinações de 2 produtos** - Sempre combina exatamente 2 produtos
4. **Sem dependentes** - Tabela folha utilizada para configuração e consulta

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

