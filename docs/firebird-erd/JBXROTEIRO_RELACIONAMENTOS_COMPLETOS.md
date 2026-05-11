# Documentação Completa: Tabela JBXROTEIRO

**Fonte:** Schema do Banco de Dados Firebird
**Tabela:** JBXROTEIRO (Roteiro de JitBox)
**Versão:** 1.0
**Data:** 2025-11-09

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura da Tabela](#estrutura-da-tabela)
3. [Relacionamentos Formais (Foreign Keys)](#relacionamentos-formais)
4. [Relacionamentos Implícitos](#relacionamentos-implícitos)
5. [Tabelas Relacionadas Detalhadas](#tabelas-relacionadas-detalhadas)
6. [Fluxos de Relacionamento Multi-Nível](#fluxos-multi-nível)
7. [Exemplos de Consultas](#exemplos-de-consultas)
8. [Diagrama de Relacionamentos](#diagrama-de-relacionamentos)
9. [Observações Importantes](#observações-importantes)

---

## 📊 Visão Geral

A tabela **JBXROTEIRO** armazena o roteiro de produção específico para **JitBox** (Just-in-Time Box), definindo as etapas pelas quais cada caixa JIT deve passar durante o processo produtivo.

### Estatísticas

- **Total de Registros:** 5.707
- **Número de Colunas:** 6
- **Primary Key:** Composta (JBCODIGO, EMPCODIGO, ALXCODIGO, ID_PEDIDO, JBRORDEM)
- **Foreign Keys Out:** 2 (JETBOX, ALMOX)
- **Foreign Keys In:** 0
- **Índices:** 1

### Conceito: O que é JitBox?

**JitBox (Just-in-Time Box)** é um sistema de caixas utilizadas para gerenciamento de produção just-in-time, onde materiais/produtos são organizados em caixas identificadas por cores (CORBOX) e seguem um roteiro específico de células de produção.

---

## 🏗️ Estrutura da Tabela

### Primary Key (Composta - 5 Campos)

A chave primária é composta por **5 campos**, permitindo múltiplas etapas (JBRORDEM) de uma mesma caixa JIT em diferentes células:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **JBCODIGO** | UNKNOWN(8) | Código da JitBox |
| **EMPCODIGO** | UNKNOWN(7) | Código da Empresa |
| **ALXCODIGO** | UNKNOWN(7) | Código do Almoxarifado/Célula |
| **ID_PEDIDO** | UNKNOWN(8) | Identificador do Pedido |
| **JBRORDEM** | UNKNOWN(7) | Ordem de execução no roteiro |

### Colunas Detalhadas (6 Total)

| Nome | Tipo | Not Null | PK | FK | Descrição |
|------|------|----------|----|----|-----------|
| 🔑 🔗 **JBCODIGO** | UNKNOWN(8) | ✓ | ✓ | ✓ | Código da JitBox (FK para JETBOX) |
| 🔑 🔗 **EMPCODIGO** | UNKNOWN(7) | ✓ | ✓ | ✓ | Código da Empresa (FK para JETBOX e ALMOX) |
| 🔑 🔗 **ALXCODIGO** | UNKNOWN(7) | ✓ | ✓ | ✓ | Código da Célula/Almoxarifado (FK para ALMOX) |
| 🔑 **ID_PEDIDO** | UNKNOWN(8) | ✓ | ✓ | | Identificador do Pedido (sem FK formal) |
| **JBRCONCLUIDO** | UNKNOWN(14) | ✓ | | | Indica se a etapa foi concluída |
| 🔑 **JBRORDEM** | UNKNOWN(7) | ✓ | ✓ | | Ordem de execução da etapa |

### Categorização das Colunas

#### 1. Campos de Identificação (PK)
- JBCODIGO, EMPCODIGO (identifica a JitBox)
- ALXCODIGO (identifica a célula atual)
- ID_PEDIDO (identifica o pedido)
- JBRORDEM (sequência da etapa)

#### 2. Campos de Status
- JBRCONCLUIDO (indica conclusão da etapa)

---

## 🔗 Relacionamentos Formais (Foreign Keys)

### FK Out: Tabelas Referenciadas por JBXROTEIRO

JBXROTEIRO possui **2 Foreign Keys formais** saindo:

| Constraint | Colunas | Tabela Destino | Descrição |
|------------|---------|----------------|-----------|
| **JETBOX_JBXROTEIRO** | JBCODIGO, EMPCODIGO | **JETBOX** | JitBox à qual este roteiro pertence |
| **ALMOX_JBXROTEIRO** | ALXCODIGO, EMPCODIGO | **ALMOX** | Célula/Almoxarifado onde a etapa ocorre |

### FK In: Tabelas que Referenciam JBXROTEIRO

❌ **Nenhuma tabela** possui Foreign Key formal apontando para JBXROTEIRO.

---

## 🔄 Relacionamentos Implícitos

JBXROTEIRO possui relacionamento **lógico/implícito** (sem constraint FK) com:

### PEDID (Pedidos)

**Relacionamento:** Via campo ID_PEDIDO

```
JBXROTEIRO.ID_PEDIDO ··> PEDID.ID_PEDIDO
```

**Observações:**
- **NÃO há FK formal**, mas o campo ID_PEDIDO existe e está na PK
- Há um índice criado (INDID_PEDIDO) que otimiza consultas por pedido
- JETBOX também possui FK formal para PEDID

**Fluxo Lógico:**
```
JBXROTEIRO.ID_PEDIDO (implícito) ··> PEDID
JBXROTEIRO.JBCODIGO (FK formal) → JETBOX → PEDID (FK formal)
```

Ou seja, há dois caminhos para o pedido:
1. **Direto (implícito):** via ID_PEDIDO
2. **Indireto (formal):** via JETBOX que tem FK para PEDID

---

## 📑 Tabelas Relacionadas Detalhadas

### 1. JETBOX - JitBoxes (Relacionamento Formal)

**Tipo de Relacionamento:** N:1 (muitos roteiros para uma JitBox)

**Informações da Tabela:**
- **Total:** 33.951 JitBoxes
- **PK:** (JBCODIGO, EMPCODIGO)
- **Colunas:** 8 campos
- **FK Out:** 3 (ALMOX, CORBOX, PEDID)
- **FK In:** 1 (JBXROTEIRO)

**Campos Principais:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| JBCODIGO, EMPCODIGO | PK | Identificação da JitBox |
| CORCODIGO | FK | Cor da caixa (FK para CORBOX) |
| ALXCODIGO | FK | Célula/Almoxarifado atual (FK para ALMOX) |
| ID_PEDIDO | FK | Pedido associado (FK para PEDID) |
| JBEXPPEDCALC | | Flag de cálculo de expedição |
| ALXCODIGORET | | Código da célula de retorno |
| EMPCODIGORET | | Código da empresa de retorno |

**Foreign Keys de JETBOX:**
```
JETBOX → ALMOX (via ALXCODIGO, EMPCODIGO)
JETBOX → CORBOX (via CORCODIGO)
JETBOX → PEDID (via ID_PEDIDO)
```

**Observação Importante:**
- JBXROTEIRO é a **ÚNICA tabela** que referencia JETBOX
- JETBOX serve como hub central conectando:
  - Caixas (CORBOX)
  - Células (ALMOX)
  - Pedidos (PEDID)
  - Roteiros (JBXROTEIRO)

### 2. ALMOX - Células/Almoxarifados (Relacionamento Formal)

**Tipo de Relacionamento:** N:1 (muitos roteiros para uma célula)

**Informações da Tabela:**
- **Total:** 128 células/almoxarifados
- **PK:** (ALXCODIGO, EMPCODIGO)
- **Colunas:** 72 campos
- **FK Out:** 1 (DEPTO)
- **FK In:** 15 tabelas (incluindo JBXROTEIRO e JETBOX)

**Campos Principais:**
- ALXCODIGO, EMPCODIGO (PK composta)
- ALXDESCRICAO (descrição da célula)
- TEMPOMAXIMO (SLA da célula)
- DPTCODIGO (departamento - FK)

**Tabelas que Dependem de ALMOX:**
1. ALMOXPROCED
2. CELTPOCOR
3. FUNCIO
4. **JETBOX** (caixa atual)
5. **JBXROTEIRO** (roteiro de JitBox)
6. LPEDALX
7. PDCROTEIRO
8. PEDROTEIRO
9. PROCES
10. PRODUCAO
11. E outras 5 tabelas

**Fluxo:**
```
JBXROTEIRO (ALXCODIGO, EMPCODIGO) → ALMOX (ALXCODIGO, EMPCODIGO)
```

### 3. CORBOX - Cores de Caixas (Relacionamento Indireto via JETBOX)

**Tipo de Relacionamento:** Indireto via JETBOX

**Informações da Tabela:**
- **Total:** 22 cores
- **PK:** CORCODIGO
- **Colunas:** 4 campos
- **FK Out:** 0 (tabela mestre)
- **FK In:** 2 tabelas (JETBOX, PLTCTRSER)

**Campos:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| CORCODIGO | PK | Código da cor |
| CORDESCRICAO | NOT NULL | Descrição da cor |
| CORVALOR | | Valor numérico da cor |
| CORHEX | | Código hexadecimal da cor |

**Fluxo:**
```
JBXROTEIRO → JETBOX → CORBOX
```

Permite identificar a cor da caixa JIT associada a cada etapa do roteiro.

### 4. PEDID - Pedidos (Relacionamento Implícito/Indireto)

**Tipo de Relacionamento:**
- Implícito via ID_PEDIDO (sem FK)
- Indireto formal via JETBOX

**Informações da Tabela:**
- **Total:** 3.099.038 pedidos
- **PK:** ID_PEDIDO
- **Colunas:** 156 campos
- **FK In:** 66 tabelas

**Caminhos para PEDID:**

**Caminho 1 (Implícito):**
```
JBXROTEIRO.ID_PEDIDO ··> PEDID.ID_PEDIDO
```

**Caminho 2 (Formal):**
```
JBXROTEIRO.JBCODIGO → JETBOX.JBCODIGO
JETBOX.ID_PEDIDO → PEDID.ID_PEDIDO
```

**Observação:**
- Índice INDID_PEDIDO em JBXROTEIRO otimiza o caminho implícito
- O caminho formal via JETBOX garante integridade referencial
- Ambos os caminhos devem resultar no mesmo pedido

### 5. JETBOXHISTORICO - Histórico de JitBox (Relacionamento Indireto)

**Informações da Tabela:**
- **Total:** 1.825.728 registros históricos
- **PK:** ID
- **Colunas:** 6 campos
- **FK:** Nenhuma (sem constraints formais)

**Campos:**
- ID (PK)
- DATA, HORA (timestamp)
- ID_PEDIDO
- EMPCODIGO, JBCODIGO (identificam a JitBox)

**Índice:** IND_JETDATA (otimiza consultas por data)

**Relacionamento Lógico:**
```
JBXROTEIRO (JBCODIGO, EMPCODIGO) ··> JETBOXHISTORICO (JBCODIGO, EMPCODIGO)
```

Permite rastrear histórico de movimentações das JitBoxes.

---

## 🌊 Fluxos de Relacionamento Multi-Nível

### Fluxo 1: Da Etapa do Roteiro ao Cliente (via JETBOX → PEDID)

```
JBXROTEIRO
    ↓ (FK formal)
JETBOX (33.9k registros)
    ↓ (FK formal)
PEDID (3,1M registros)
    ↓ (FK)
CLIEN (Cliente)
    ↓
[Outras 65 tabelas via PEDID]
```

**Via JETBOX → PEDID, JBXROTEIRO conecta a:**
- CLIEN (clientes)
- PDPRD (produtos do pedido)
- PDDUP (duplicatas/financeiro)
- PDNF (notas fiscais)
- FUNCIO (vendedores)
- E outras 60+ tabelas

### Fluxo 2: Do Roteiro à Célula e Processos (via ALMOX)

```
JBXROTEIRO (ALXCODIGO, EMPCODIGO)
    ↓ (FK formal)
ALMOX (128 células)
    ↓ (FK)
DEPTO (Departamento)

ALMOX também conecta a:
    - PROCES (processos de produção)
    - PRODUCAO (registros de produção)
    - LPEDALX (eventos por célula)
    - JETBOX (caixas na célula)
    - PEDROTEIRO (roteiro de pedidos)
    - E outras 10 tabelas
```

### Fluxo 3: Do Roteiro à Cor da Caixa (via JETBOX → CORBOX)

```
JBXROTEIRO
    ↓ (FK - JBCODIGO, EMPCODIGO)
JETBOX
    ↓ (FK - CORCODIGO)
CORBOX (22 cores)
```

**Utilidade:**
- Identificar visualmente as caixas por cor
- Organizar fluxo por tipo de caixa
- Segregar materiais/produtos diferentes

### Fluxo 4: Histórico de Movimentação

```
JBXROTEIRO (JBCODIGO, EMPCODIGO)
    ↓ (implícito - sem FK)
JETBOXHISTORICO (1,8M registros)
```

**Permite:**
- Rastrear todas as movimentações históricas da JitBox
- Auditar tempo de permanência em cada etapa
- Analisar padrões de fluxo

### Fluxo 5: Caminho Duplo para Pedido

**Caminho Implícito (Direto):**
```
JBXROTEIRO.ID_PEDIDO ··> PEDID.ID_PEDIDO
```

**Caminho Formal (via JETBOX):**
```
JBXROTEIRO → JETBOX → PEDID
```

**Vantagens de cada caminho:**
- **Implícito:** Performance (índice INDID_PEDIDO)
- **Formal:** Integridade referencial garantida

---

## 💡 Exemplos de Consultas

### 1. Consultar Roteiro Completo de uma JitBox

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    JR.ID_PEDIDO,
    JR.JBRCONCLUIDO
FROM JBXROTEIRO JR
WHERE JR.JBCODIGO = 12345
  AND JR.EMPCODIGO = 1
ORDER BY JR.JBRORDEM;
```

### 2. Buscar Todas as JitBoxes em uma Célula Específica

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    JR.ID_PEDIDO,
    JR.JBRORDEM,
    JR.JBRCONCLUIDO
FROM JBXROTEIRO JR
WHERE JR.ALXCODIGO = 10
  AND JR.EMPCODIGO = 1
ORDER BY JR.JBRORDEM;
```

### 3. Junção com JETBOX para Informações Completas da Caixa

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    JR.ALXCODIGO,
    JR.JBRORDEM,
    JR.JBRCONCLUIDO,
    JB.CORCODIGO,
    JB.ID_PEDIDO AS PEDIDO_JETBOX,
    JB.ALXCODIGO AS CELULA_ATUAL_JETBOX
FROM JBXROTEIRO JR
INNER JOIN JETBOX JB
    ON JR.JBCODIGO = JB.JBCODIGO
    AND JR.EMPCODIGO = JB.EMPCODIGO
WHERE JR.JBCODIGO = 12345;
```

### 4. Incluir Cor da Caixa (via JETBOX → CORBOX)

```sql
SELECT
    JR.JBCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    JR.JBRCONCLUIDO,
    CB.CORCODIGO,
    CB.CORDESCRICAO,
    CB.CORHEX
FROM JBXROTEIRO JR
INNER JOIN JETBOX JB
    ON JR.JBCODIGO = JB.JBCODIGO
    AND JR.EMPCODIGO = JB.EMPCODIGO
INNER JOIN CORBOX CB
    ON JB.CORCODIGO = CB.CORCODIGO
WHERE JR.JBCODIGO = 12345
ORDER BY JR.JBRORDEM;
```

### 5. Buscar Informações do Pedido (Caminho Implícito)

```sql
-- Usa índice INDID_PEDIDO para performance
SELECT
    JR.JBCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    P.PEDCODIGO,
    P.CLICODIGO,
    P.PEDDTEMIS,
    P.PEDVRTOTAL
FROM JBXROTEIRO JR
INNER JOIN PEDID P
    ON JR.ID_PEDIDO = P.ID_PEDIDO
WHERE JR.ID_PEDIDO = 98765
ORDER BY JR.JBRORDEM;
```

### 6. Buscar Informações do Pedido (Caminho Formal via JETBOX)

```sql
-- Usa FK formal para garantir integridade
SELECT
    JR.JBCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    P.PEDCODIGO,
    P.CLICODIGO,
    P.PEDDTEMIS
FROM JBXROTEIRO JR
INNER JOIN JETBOX JB
    ON JR.JBCODIGO = JB.JBCODIGO
    AND JR.EMPCODIGO = JB.EMPCODIGO
INNER JOIN PEDID P
    ON JB.ID_PEDIDO = P.ID_PEDIDO
WHERE JR.JBCODIGO = 12345
ORDER BY JR.JBRORDEM;
```

### 7. Etapas Pendentes (Não Concluídas)

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    JR.ALXCODIGO,
    JR.JBRORDEM,
    JR.ID_PEDIDO,
    JR.JBRCONCLUIDO
FROM JBXROTEIRO JR
WHERE JR.JBRCONCLUIDO <> 'S'
   OR JR.JBRCONCLUIDO IS NULL
ORDER BY JR.JBCODIGO, JR.JBRORDEM;
```

### 8. Estatísticas por Célula

```sql
SELECT
    JR.ALXCODIGO,
    JR.EMPCODIGO,
    COUNT(*) AS TOTAL_ETAPAS,
    COUNT(DISTINCT JR.JBCODIGO) AS TOTAL_JITBOXES,
    SUM(CASE WHEN JR.JBRCONCLUIDO = 'S' THEN 1 ELSE 0 END) AS ETAPAS_CONCLUIDAS,
    SUM(CASE WHEN JR.JBRCONCLUIDO <> 'S' OR JR.JBRCONCLUIDO IS NULL THEN 1 ELSE 0 END) AS ETAPAS_PENDENTES
FROM JBXROTEIRO JR
GROUP BY JR.ALXCODIGO, JR.EMPCODIGO
ORDER BY TOTAL_JITBOXES DESC;
```

### 9. Histórico de Movimentação da JitBox

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    JH.DATA,
    JH.HORA,
    JH.ID_PEDIDO
FROM JBXROTEIRO JR
LEFT JOIN JETBOXHISTORICO JH
    ON JR.JBCODIGO = JH.JBCODIGO
    AND JR.EMPCODIGO = JH.EMPCODIGO
WHERE JR.JBCODIGO = 12345
ORDER BY JH.DATA DESC, JH.HORA DESC;
```

### 10. JitBoxes com Múltiplas Etapas

```sql
SELECT
    JR.JBCODIGO,
    JR.EMPCODIGO,
    COUNT(*) AS NUMERO_ETAPAS
FROM JBXROTEIRO JR
GROUP BY JR.JBCODIGO, JR.EMPCODIGO
HAVING COUNT(*) > 3
ORDER BY NUMERO_ETAPAS DESC;
```

### 11. Detalhamento Completo: Roteiro + Caixa + Pedido + Cliente

```sql
SELECT
    JR.JBCODIGO,
    JR.JBRORDEM,
    JR.ALXCODIGO,
    JR.JBRCONCLUIDO,
    CB.CORDESCRICAO AS COR_CAIXA,
    P.PEDCODIGO,
    P.PEDDTEMIS,
    C.CLINOME
FROM JBXROTEIRO JR
INNER JOIN JETBOX JB
    ON JR.JBCODIGO = JB.JBCODIGO
    AND JR.EMPCODIGO = JB.EMPCODIGO
INNER JOIN CORBOX CB
    ON JB.CORCODIGO = CB.CORCODIGO
INNER JOIN PEDID P
    ON JB.ID_PEDIDO = P.ID_PEDIDO
INNER JOIN CLIEN C
    ON P.CLICODIGO = C.CLICODIGO
WHERE JR.JBCODIGO = 12345
ORDER BY JR.JBRORDEM;
```

### 12. Análise de Cores de Caixa por Célula

```sql
SELECT
    JR.ALXCODIGO,
    CB.CORDESCRICAO,
    COUNT(*) AS TOTAL_ETAPAS,
    COUNT(DISTINCT JR.JBCODIGO) AS TOTAL_CAIXAS
FROM JBXROTEIRO JR
INNER JOIN JETBOX JB
    ON JR.JBCODIGO = JB.JBCODIGO
    AND JR.EMPCODIGO = JB.EMPCODIGO
INNER JOIN CORBOX CB
    ON JB.CORCODIGO = CB.CORCODIGO
GROUP BY JR.ALXCODIGO, CB.CORDESCRICAO
ORDER BY JR.ALXCODIGO, TOTAL_CAIXAS DESC;
```

---

## 📊 Diagrama de Relacionamentos

```mermaid
erDiagram
    JBXROTEIRO {
        UNKNOWN8 JBCODIGO PK_FK
        UNKNOWN7 EMPCODIGO PK_FK
        UNKNOWN7 ALXCODIGO PK_FK
        UNKNOWN8 ID_PEDIDO PK
        UNKNOWN7 JBRORDEM PK
        UNKNOWN14 JBRCONCLUIDO
    }

    JETBOX {
        UNKNOWN8 JBCODIGO PK
        UNKNOWN7 EMPCODIGO PK
        UNKNOWN7 CORCODIGO FK
        UNKNOWN7 ALXCODIGO FK
        UNKNOWN8 ID_PEDIDO FK
        UNKNOWN14 JBEXPPEDCALC
        UNKNOWN7 ALXCODIGORET
        UNKNOWN7 EMPCODIGORET
    }

    ALMOX {
        UNKNOWN7 ALXCODIGO PK
        UNKNOWN7 EMPCODIGO PK
        UNKNOWN37 ALXDESCRICAO
        UNKNOWN8 TEMPOMAXIMO
        UNKNOWN7 DPTCODIGO FK
        string mais_67_campos
    }

    CORBOX {
        UNKNOWN7 CORCODIGO PK
        UNKNOWN37 CORDESCRICAO
        UNKNOWN8 CORVALOR
        UNKNOWN37 CORHEX
    }

    PEDID {
        UNKNOWN8 ID_PEDIDO PK
        UNKNOWN14 PEDCODIGO
        UNKNOWN8 CLICODIGO FK
        UNKNOWN35 PEDDTEMIS
        UNKNOWN14 PEDSITPED
        UNKNOWN27 PEDVRTOTAL
        string mais_150_campos
    }

    CLIEN {
        UNKNOWN8 CLICODIGO PK
        UNKNOWN37 CLINOME
        string outros_campos
    }

    DEPTO {
        UNKNOWN7 DPTCODIGO PK
        UNKNOWN37 DPTDESCRICAO
    }

    JETBOXHISTORICO {
        UNKNOWN8 ID PK
        UNKNOWN12 DATA
        UNKNOWN13 HORA
        UNKNOWN8 ID_PEDIDO
        UNKNOWN7 EMPCODIGO
        UNKNOWN8 JBCODIGO
    }

    %% Relacionamentos Formais (com FK constraint)
    JBXROTEIRO ||--o{ JETBOX : "JBCODIGO+EMPCODIGO (FK)"
    JBXROTEIRO ||--o{ ALMOX : "ALXCODIGO+EMPCODIGO (FK)"
    JETBOX ||--o{ ALMOX : "ALXCODIGO+EMPCODIGO (FK)"
    JETBOX ||--o{ CORBOX : "CORCODIGO (FK)"
    JETBOX ||--o{ PEDID : "ID_PEDIDO (FK)"
    ALMOX ||--o{ DEPTO : "DPTCODIGO (FK)"
    PEDID ||--o{ CLIEN : "CLICODIGO (FK)"

    %% Relacionamentos Implícitos (sem FK constraint)
    JBXROTEIRO ||..o{ PEDID : "ID_PEDIDO (implícito - com índice)"
    JBXROTEIRO ||..o{ JETBOXHISTORICO : "JBCODIGO+EMPCODIGO (implícito)"

    %% Notação:
    %% ||--o{ = Relacionamento formal (com FK constraint)
    %% ||..o{ = Relacionamento implícito (sem FK constraint)
```

### Legenda do Diagrama

- **Linha sólida (`||--o{`)**: Relacionamento formal com Foreign Key constraint
- **Linha pontilhada (`||..o{`)**: Relacionamento lógico/implícito sem FK constraint
- **PK**: Primary Key
- **FK**: Foreign Key

---

## ⚠️ Observações Importantes

### 1. Diferença entre JBXROTEIRO e PEDROTEIRO

Existem duas tabelas de roteiro no sistema:

| Característica | JBXROTEIRO | PEDROTEIRO |
|----------------|------------|------------|
| **Propósito** | Roteiro de **JitBoxes** | Roteiro de **Pedidos** |
| **Registros** | 5.707 | 11.211.249 |
| **PK Campos** | 5 campos | 4 campos |
| **FK Formais** | JETBOX + ALMOX | PEDID apenas |
| **Inclui JBCODIGO** | ✓ | ✗ |
| **Campo ID_ROTEIRO** | ✗ | ✓ |

**Importante:** Apesar do nome similar, são conceitos diferentes:
- **JBXROTEIRO:** Rastreia movimento de **caixas JIT** específicas
- **PEDROTEIRO:** Rastreia etapas de produção de **pedidos** em geral

### 2. Relacionamento ID_PEDIDO sem FK Formal

```
JBXROTEIRO.ID_PEDIDO ··> PEDID.ID_PEDIDO (SEM FK)
```

**Por que não há FK?**
- Pode ser design deliberado para flexibilidade
- Sistema legado que evoluiu
- Performance (evitar overhead de validação)

**Mas há compensação:**
- Índice INDID_PEDIDO otimiza consultas
- FK formal existe via JETBOX (caminho alternativo)

### 3. Caminho Duplo para Pedido

Há **dois caminhos** para acessar dados do pedido:

**Caminho 1 - Direto (Implícito):**
```sql
FROM JBXROTEIRO JR
JOIN PEDID P ON JR.ID_PEDIDO = P.ID_PEDIDO
```
- ✓ Mais rápido (usa índice INDID_PEDIDO)
- ✗ Sem garantia de integridade referencial

**Caminho 2 - Via JETBOX (Formal):**
```sql
FROM JBXROTEIRO JR
JOIN JETBOX JB ON JR.JBCODIGO = JB.JBCODIGO
JOIN PEDID P ON JB.ID_PEDIDO = P.ID_PEDIDO
```
- ✓ Integridade garantida (FK formal)
- ✗ Um JOIN a mais

**Recomendação:**
- Usar caminho 1 para consultas de performance
- Usar caminho 2 para validações e integridade

### 4. JETBOX como Hub Central

```
           CORBOX (cores)
               ↑
               |
          JETBOX ← JBXROTEIRO
           ↙  ↓  ↘
      ALMOX PEDID (único FK in)
```

**JETBOX centraliza:**
- Identificação da caixa (JBCODIGO)
- Cor da caixa (CORCODIGO → CORBOX)
- Localização atual (ALXCODIGO → ALMOX)
- Pedido associado (ID_PEDIDO → PEDID)
- Roteiro de movimentação (← JBXROTEIRO)

### 5. Primary Key com 5 Campos

A PK composta por 5 campos permite:
- Múltiplas etapas (JBRORDEM) da mesma caixa (JBCODIGO)
- Mesma caixa em diferentes células (ALXCODIGO)
- Mesmo pedido com múltiplas caixas (ID_PEDIDO)
- Separação por empresa (EMPCODIGO)

**Implica em:**
- JOINs devem considerar todos os campos necessários
- Consultas de performance devem usar índices apropriados

### 6. Volume Moderado de Dados

Com **5.707 registros**, JBXROTEIRO é uma tabela de volume moderado:

**Comparação:**
- PEDROTEIRO: 11,2 milhões (maior)
- JBXROTEIRO: 5,7 mil
- JETBOX: 33,9 mil
- JETBOXHISTORICO: 1,8 milhões

**Interpretação:**
- Nem todas as JitBoxes têm roteiro complexo
- Média de ~0,17 etapas de roteiro por JitBox (5707/33951)
- Sistema pode ter roteiros simples ou fluxo direto

### 7. Campo JBRCONCLUIDO

Único campo de status, indica se a etapa foi concluída.

**Valores Possíveis (inferidos):**
- 'S' = Sim (concluído)
- 'N' = Não (pendente)
- NULL = Indefinido

**Uso:**
- Rastrear progresso das JitBoxes
- Identificar gargalos (etapas não concluídas)
- Calcular tempo de permanência em células

### 8. Ausência de Campos Temporais

**JBXROTEIRO NÃO possui:**
- DTINICIO (data de início)
- DTTERMINO (data de término)
- TEMPOMAXIMO (SLA)
- TEMPOGASTO (tempo consumido)

**Diferente de PEDROTEIRO que possui:**
- DTINICIO, DTTERMINO, DTDISPONIVEL
- TEMPOMAXIMO, TEMPOGASTO, TEMPOREALGASTO

**Possível Razão:**
- Controle temporal pode estar em JETBOXHISTORICO (1,8M registros)
- JitBox pode ter rastreamento mais simples
- Timestamps podem estar em outras tabelas

### 9. Índice INDID_PEDIDO

Único índice além da PK:

```
IND_PEDIDO: ID_PEDIDO
```

**Utilidade:**
- Otimiza buscas por pedido
- Compensa ausência de FK formal para PEDID
- Permite queries eficientes: "Quais JitBoxes do pedido X?"

### 10. Sistema JitBox Completo

Para entender completamente o fluxo JitBox:

**Tabelas Envolvidas:**
1. **CORBOX** (22 cores) - Master de cores
2. **JETBOX** (33.9k caixas) - Cadastro de caixas
3. **JBXROTEIRO** (5.7k etapas) - Roteiro das caixas
4. **JETBOXHISTORICO** (1.8M movimentos) - Histórico de movimentações
5. **ALMOX** (128 células) - Localizações possíveis
6. **PEDID** (3.1M pedidos) - Pedidos associados

**Fluxo Completo:**
```
1. Criar JitBox (JETBOX) com cor (CORBOX)
2. Associar ao pedido (PEDID)
3. Definir roteiro (JBXROTEIRO)
4. Movimentar por células (ALMOX)
5. Registrar histórico (JETBOXHISTORICO)
```

---

## 📚 Referências Cruzadas

Para informações completas sobre tabelas relacionadas, consultar:

- **[ALMOX_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela ALMOX
- **[PEDID_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela PEDID (se disponível)
- **[PEDROTEIRO_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela PEDROTEIRO

---

## 🔍 Diferenças Principais: JBXROTEIRO vs PEDROTEIRO

| Aspecto | JBXROTEIRO | PEDROTEIRO |
|---------|------------|------------|
| **Conceito** | Roteiro de caixas JIT | Roteiro de pedidos |
| **Volume** | 5.707 registros | 11.211.249 registros |
| **PK** | 5 campos (inclui JBCODIGO) | 4 campos (sem JBCODIGO) |
| **Campos** | 6 colunas | 21 colunas |
| **FK para PEDID** | Implícita (sem constraint) | Formal (com constraint) |
| **Campos de Tempo** | ✗ Nenhum | ✓ 7 campos (datas, tempos, SLA) |
| **Campos de Turno** | ✗ Nenhum | ✓ 5 campos (horários, dias úteis) |
| **Hierarquia** | ✗ Não | ✓ Sim (ID_ROTEIRO_PAI) |
| **Campo ID_ROTEIRO** | ✗ Não possui | ✓ Possui |
| **Célula Gerada** | ✗ Não | ✓ ALXCODIGOGERADO |
| **Índices** | 1 (ID_PEDIDO) | 5 (datas, roteiros) |

---

**Fim da Documentação**

*Esta documentação foi gerada exclusivamente a partir do schema do banco de dados Firebird, sem interpretações de código-fonte local.*
