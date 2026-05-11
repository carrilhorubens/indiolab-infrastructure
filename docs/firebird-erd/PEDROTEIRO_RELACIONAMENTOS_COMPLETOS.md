# Documentação Completa: Tabela PEDROTEIRO

**Fonte:** Schema do Banco de Dados Firebird
**Tabela:** PEDROTEIRO (Roteiro de Produção de Pedidos)
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

A tabela **PEDROTEIRO** armazena o roteiro de produção de cada pedido, definindo as etapas (células/almoxarifados) pelas quais um pedido deve passar durante sua produção.

### Estatísticas

- **Total de Registros:** 11.211.249 (11,2 milhões)
- **Número de Colunas:** 21
- **Primary Key:** Composta (ALXCODIGO, EMPCODIGO, ID_PEDIDO, PDRORDEM)
- **Foreign Keys Out:** 1 (PEDID)
- **Foreign Keys In:** 0
- **Índices:** 5

---

## 🏗️ Estrutura da Tabela

### Primary Key (Composta)

A chave primária é composta por **4 campos**, permitindo múltiplas etapas (PDRORDEM) de um mesmo pedido em diferentes células:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **ALXCODIGO** | UNKNOWN(7) | Código do Almoxarifado/Célula |
| **EMPCODIGO** | UNKNOWN(7) | Código da Empresa |
| **ID_PEDIDO** | UNKNOWN(8) | Identificador do Pedido |
| **PDRORDEM** | UNKNOWN(7) | Ordem de execução no roteiro |

### Colunas Detalhadas

#### 1. Campos de Identificação (PK)

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| 🔑 🔗 **ID_PEDIDO** | UNKNOWN(8) | ✓ | Referência ao pedido (FK para PEDID) |
| 🔑 **ALXCODIGO** | UNKNOWN(7) | ✓ | Código do almoxarifado/célula atual |
| 🔑 **EMPCODIGO** | UNKNOWN(7) | ✓ | Código da empresa |
| 🔑 **PDRORDEM** | UNKNOWN(7) | ✓ | Ordem de execução (sequência) |

#### 2. Campos de Status

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **PDRCONCLUIDO** | UNKNOWN(14) | ✓ | Indica se a etapa foi concluída |

#### 3. Campos de Tempo

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **TEMPOMAXIMO** | UNKNOWN(8) | | Tempo máximo previsto para a etapa |
| **TEMPOGASTO** | UNKNOWN(8) | | Tempo efetivamente gasto |
| **TEMPOREALGASTO** | UNKNOWN(8) | | Tempo real gasto (considerando turnos) |
| **TEMPOESPERA** | UNKNOWN(8) | | Tempo de espera antes de iniciar |

⚠️ **IMPORTANTE:** As unidades de medida dos campos de tempo (segundos, minutos ou horas) **NÃO estão especificadas no schema**. Consultar documentação de negócio.

#### 4. Campos de Data/Hora

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **DTINICIO** | UNKNOWN(35) | | Data/hora de início da etapa |
| **DTTERMINO** | UNKNOWN(35) | | Data/hora de término da etapa |
| **DTDISPONIVEL** | UNKNOWN(35) | | Data/hora em que ficou disponível |

#### 5. Campos de Roteiro Hierárquico

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **ID_ROTEIRO** | UNKNOWN(16) | ✓ | Identificador do tipo de roteiro |
| **ID_ROTEIRO_PAI** | UNKNOWN(16) | | Roteiro pai (estrutura hierárquica) |

#### 6. Campos de Célula Gerada

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **ALXCODIGOGERADO** | UNKNOWN(7) | | Código da célula gerada/destino |
| **EMPCODIGOGERADO** | UNKNOWN(7) | | Código da empresa da célula gerada |

#### 7. Campos de Turno

| Nome | Tipo | Not Null | Descrição |
|------|------|----------|-----------|
| **TURHRENTRADA** | UNKNOWN(8) | | Hora de entrada do turno |
| **TURHRSAIDA** | UNKNOWN(8) | | Hora de saída do turno |
| **TURHRSAIDAALMOCO** | UNKNOWN(8) | | Hora de saída para almoço |
| **TURHRENTRADAALMOCO** | UNKNOWN(8) | | Hora de retorno do almoço |
| **TURDIASUTEIS** | UNKNOWN(14) | | Dias úteis do turno |

---

## 🔗 Relacionamentos Formais (Foreign Keys)

### FK Out: Tabelas Referenciadas por PEDROTEIRO

PEDROTEIRO possui **apenas 1 Foreign Key formal** saindo:

| Constraint | Coluna | Tabela Destino | Descrição |
|------------|--------|----------------|-----------|
| **PEDID_PEDROTEIRO** | ID_PEDIDO | **PEDID** | Pedido ao qual este roteiro pertence |

### FK In: Tabelas que Referenciam PEDROTEIRO

❌ **Nenhuma tabela** possui Foreign Key formal apontando para PEDROTEIRO.

---

## 🔄 Relacionamentos Implícitos

PEDROTEIRO possui relacionamentos **lógicos/implícitos** (sem constraint FK) com as seguintes tabelas:

### 1. ALMOX (Almoxarifados/Células)

**Relacionamento:** Via campos (ALXCODIGO, EMPCODIGO)

```
PEDROTEIRO (ALXCODIGO, EMPCODIGO) ··> ALMOX (ALXCODIGO, EMPCODIGO)
```

**Observações:**
- ALMOX tem PK composta: (ALXCODIGO, EMPCODIGO)
- **NÃO há FK formal**, mas os campos existem e fazem sentido lógico
- PEDROTEIRO também tem (ALXCODIGOGERADO, EMPCODIGOGERADO) que parecem referenciar ALMOX

**ALMOX - Informações:**
- Total: 128 células/almoxarifados
- 72 colunas
- 15 tabelas dependentes (com FK formal)

### 2. ROTEIRO (Tipos de Roteiro)

**Relacionamento:** Via campo ID_ROTEIRO

```
PEDROTEIRO.ID_ROTEIRO ··> ROTEIRO.ROTCODIGO
```

**Observações:**
- **NÃO há FK formal** entre PEDROTEIRO e ROTEIRO
- ROTEIRO é uma tabela mestre minimalista (apenas 2 registros, 2 colunas)
- Diferença de tipos:
  - ROTEIRO.ROTCODIGO: UNKNOWN(7)
  - PEDROTEIRO.ID_ROTEIRO: UNKNOWN(16)
- Esta diferença de tipo sugere que podem ser conceitos relacionados mas distintos

**ROTEIRO - Informações:**
- Total: 2 registros
- 2 colunas: ROTCODIGO, ROTDESCRICAO
- Sem FK formais (in ou out)

### 3. Auto-Referencial via ID_ROTEIRO_PAI

**Relacionamento:** Hierarquia dentro da própria PEDROTEIRO

```
PEDROTEIRO.ID_ROTEIRO_PAI ··> PEDROTEIRO.ID_ROTEIRO (mesma tabela)
```

**Observações:**
- Permite criar estruturas hierárquicas de roteiros
- Roteiros "filhos" podem ter um roteiro "pai"
- Relacionamento implícito (sem FK formal)

---

## 📑 Tabelas Relacionadas Detalhadas

### 1. PEDID - Pedidos (Relacionamento Formal)

**Tipo de Relacionamento:** N:1 (muitos roteiros para um pedido)

**Informações da Tabela:**
- **Total:** 3.099.038 pedidos
- **PK:** ID_PEDIDO
- **Colunas:** 156 campos
- **FK In:** 66 tabelas diferentes referenciam PEDID

**Campos Principais:**
- ID_PEDIDO (PK)
- PEDCODIGO (número do pedido)
- CLICODIGO (cliente)
- PEDDTEMIS (data de emissão)
- PEDSITPED (situação)
- PEDVRTOTAL (valor total)
- PEDORIGEM (origem do pedido)

**Índices em PEDID:**
- INDPEDDTEMIS (data de emissão)
- INDPEDDTSAIDA (data de saída)
- INDPEDPZENTRE (prazo de entrega)
- Múltiplos outros índices para performance

**Fluxo:**
```
PEDROTEIRO.ID_PEDIDO → PEDID.ID_PEDIDO
```

Um pedido pode ter múltiplas etapas de roteiro (múltiplos registros em PEDROTEIRO).

### 2. ALMOX - Células/Almoxarifados (Relacionamento Implícito)

**Tipo de Relacionamento:** N:1 (muitos roteiros para uma célula)

**Informações da Tabela:**
- **Total:** 128 células/almoxarifados
- **PK:** (ALXCODIGO, EMPCODIGO)
- **Colunas:** 72 campos
- **FK Out:** 1 (DEPTO)
- **FK In:** 15 tabelas

**Campos Principais:**
- ALXCODIGO, EMPCODIGO (PK composta)
- ALXDESCRICAO (descrição da célula)
- TEMPOMAXIMO (SLA da célula)
- DPTCODIGO (departamento)

**Tabelas que Dependem de ALMOX (com FK):**
1. ALMOXPROCED
2. CELTPOCOR
3. FUNCIO
4. JETBOX
5. LPEDALX
6. PDCROTEIRO
7. PROCES
8. PRODUCAO
9. E outras 7 tabelas

**Fluxo:**
```
PEDROTEIRO (ALXCODIGO, EMPCODIGO) ··> ALMOX (ALXCODIGO, EMPCODIGO)
```

### 3. ROTEIRO - Tipos de Roteiro (Relacionamento Implícito)

**Tipo de Relacionamento:** N:1 (muitos registros PEDROTEIRO para um tipo ROTEIRO)

**Informações da Tabela:**
- **Total:** 2 registros apenas
- **Colunas:** 2 (ROTCODIGO, ROTDESCRICAO)
- **FK:** Nenhuma (in ou out)

**Observação Crítica:**
- Tabela extremamente simples
- Sem constraints FK formais
- PEDROTEIRO usa ID_ROTEIRO mas não há FK
- Diferença de tipos pode indicar evolução do sistema

**Outras Tabelas com "ROTEIRO" no Nome:**

1. **ROTEIROPEDTEMP** (3 registros)
   - Campos: ID_ROTEIRO, ID_ROTEIRO_PAI
   - Também sem FK formal para ROTEIRO

2. **JBXROTEIRO** (1.175 registros)
   - **NÃO possui campo ID_ROTEIRO**
   - Possui ALXCODIGO/EMPCODIGO (FK para ALMOX)

3. **PDCROTEIRO** (169.063 registros)
   - **NÃO possui campo ID_ROTEIRO**
   - Possui ALXCODIGO/EMPCODIGO (FK para ALMOX)

---

## 🌊 Fluxos de Relacionamento Multi-Nível

### Fluxo 1: Do Roteiro ao Cliente (via PEDID)

```
PEDROTEIRO
    ↓ (FK)
PEDID (3,1M registros)
    ↓ (FK - CLICODIGO)
CLIEN (Cliente)
    ↓ (FK)
[Outras tabelas de cliente...]
```

**Via PEDID, PEDROTEIRO se conecta a:**
- CLIEN (clientes)
- FUNCIO (vendedores)
- Tabelas de produtos (PDPRD)
- Tabelas de financeiro (PDDUP)
- Tabelas de nota fiscal (PDNF)
- E outras 60+ tabelas

### Fluxo 2: Do Roteiro à Célula e Processos (via ALMOX)

```
PEDROTEIRO (ALXCODIGO, EMPCODIGO)
    ↓ (implícito)
ALMOX (128 células)
    ↓ (FK)
DEPTO (Departamento)

ALMOX também conecta a:
    ↓ (FK)
    - PROCES (processos)
    - LPEDALX (eventos por célula)
    - PRODUCAO (registros de produção)
    - JETBOX (caixas JIT)
    - E outras 11 tabelas
```

### Fluxo 3: Hierarquia de Roteiros

```
PEDROTEIRO (Roteiro Pai)
    ↓ (ID_ROTEIRO_PAI - auto-referencial)
PEDROTEIRO (Roteiro Filho)
    ↓
PEDROTEIRO (Roteiro Neto)
    ...
```

**Permite:**
- Roteiros compostos
- Sub-roteiros
- Estruturas complexas de produção

### Fluxo 4: Célula de Origem → Célula de Destino

```
PEDROTEIRO
    ALXCODIGO/EMPCODIGO (Célula atual)
        ↓ (implícito para ALMOX)
    ALXCODIGOGERADO/EMPCODIGOGERADO (Célula destino)
        ↓ (implícito para ALMOX)
```

Permite rastrear o fluxo entre células durante a produção.

---

## 💡 Exemplos de Consultas

### 1. Consultar Roteiro Completo de um Pedido

```sql
SELECT
    PR.ID_PEDIDO,
    PR.PDRORDEM,
    PR.ALXCODIGO,
    PR.EMPCODIGO,
    PR.PDRCONCLUIDO,
    PR.DTINICIO,
    PR.DTTERMINO,
    PR.TEMPOMAXIMO,
    PR.TEMPOGASTO,
    PR.ID_ROTEIRO
FROM PEDROTEIRO PR
WHERE PR.ID_PEDIDO = 12345
ORDER BY PR.PDRORDEM;
```

### 2. Buscar Todas as Etapas de uma Célula Específica

```sql
SELECT
    PR.ID_PEDIDO,
    PR.PDRORDEM,
    PR.ALXCODIGO,
    PR.PDRCONCLUIDO,
    PR.DTINICIO,
    PR.DTTERMINO
FROM PEDROTEIRO PR
WHERE PR.ALXCODIGO = 10
  AND PR.EMPCODIGO = 1
ORDER BY PR.DTINICIO DESC;
```

### 3. Identificar Etapas Atrasadas (Tempo Gasto > Tempo Máximo)

```sql
SELECT
    PR.ID_PEDIDO,
    PR.ALXCODIGO,
    PR.PDRORDEM,
    PR.TEMPOMAXIMO,
    PR.TEMPOGASTO,
    (PR.TEMPOGASTO - PR.TEMPOMAXIMO) AS ATRASO
FROM PEDROTEIRO PR
WHERE PR.TEMPOGASTO > PR.TEMPOMAXIMO
  AND PR.TEMPOMAXIMO IS NOT NULL
  AND PR.TEMPOGASTO IS NOT NULL
ORDER BY ATRASO DESC;
```

### 4. Junção com PEDID para Informações Completas

```sql
SELECT
    P.ID_PEDIDO,
    P.PEDCODIGO,
    P.CLICODIGO,
    P.PEDDTEMIS,
    PR.PDRORDEM,
    PR.ALXCODIGO,
    PR.PDRCONCLUIDO,
    PR.DTINICIO,
    PR.DTTERMINO
FROM PEDROTEIRO PR
INNER JOIN PEDID P ON PR.ID_PEDIDO = P.ID_PEDIDO
WHERE P.CLICODIGO = 5000
ORDER BY P.PEDDTEMIS DESC, PR.PDRORDEM;
```

### 5. Analisar Etapas em Andamento (Iniciadas mas Não Concluídas)

```sql
SELECT
    PR.ID_PEDIDO,
    PR.ALXCODIGO,
    PR.PDRORDEM,
    PR.DTINICIO,
    PR.PDRCONCLUIDO
FROM PEDROTEIRO PR
WHERE PR.DTINICIO IS NOT NULL
  AND PR.DTTERMINO IS NULL
ORDER BY PR.DTINICIO;
```

### 6. Buscar Roteiros com Hierarquia (Pai → Filho)

```sql
SELECT
    PAI.ID_PEDIDO,
    PAI.ID_ROTEIRO AS ROTEIRO_PAI,
    FILHO.ID_ROTEIRO AS ROTEIRO_FILHO,
    PAI.PDRORDEM AS ORDEM_PAI,
    FILHO.PDRORDEM AS ORDEM_FILHO
FROM PEDROTEIRO PAI
INNER JOIN PEDROTEIRO FILHO
    ON FILHO.ID_ROTEIRO_PAI = PAI.ID_ROTEIRO
    AND FILHO.ID_PEDIDO = PAI.ID_PEDIDO
WHERE PAI.ID_PEDIDO = 12345
ORDER BY PAI.PDRORDEM, FILHO.PDRORDEM;
```

### 7. Estatísticas por Célula (Média de Tempo)

```sql
SELECT
    PR.ALXCODIGO,
    PR.EMPCODIGO,
    COUNT(*) AS TOTAL_ETAPAS,
    AVG(PR.TEMPOGASTO) AS MEDIA_TEMPO_GASTO,
    AVG(PR.TEMPOMAXIMO) AS MEDIA_TEMPO_MAXIMO,
    SUM(CASE WHEN PR.PDRCONCLUIDO = 'S' THEN 1 ELSE 0 END) AS CONCLUIDAS
FROM PEDROTEIRO PR
GROUP BY PR.ALXCODIGO, PR.EMPCODIGO
ORDER BY TOTAL_ETAPAS DESC;
```

### 8. Rastrear Fluxo Entre Células (Origem → Destino)

```sql
SELECT
    PR.ID_PEDIDO,
    PR.ALXCODIGO AS CELULA_ORIGEM,
    PR.ALXCODIGOGERADO AS CELULA_DESTINO,
    PR.PDRORDEM,
    PR.DTINICIO,
    PR.DTTERMINO
FROM PEDROTEIRO PR
WHERE PR.ALXCODIGOGERADO IS NOT NULL
ORDER BY PR.ID_PEDIDO, PR.PDRORDEM;
```

### 9. Pedidos com Múltiplas Etapas (Mais de 5 Células)

```sql
SELECT
    PR.ID_PEDIDO,
    COUNT(*) AS NUMERO_ETAPAS
FROM PEDROTEIRO PR
GROUP BY PR.ID_PEDIDO
HAVING COUNT(*) > 5
ORDER BY NUMERO_ETAPAS DESC;
```

### 10. Usar Índices para Performance - Busca por Data Disponível

```sql
-- Aproveita índice IND_PEDROTEIRO_DTDISPONIVEL
SELECT
    PR.ID_PEDIDO,
    PR.ALXCODIGO,
    PR.PDRORDEM,
    PR.DTDISPONIVEL,
    PR.DTINICIO
FROM PEDROTEIRO PR
WHERE PR.DTDISPONIVEL BETWEEN '2025-01-01' AND '2025-01-31'
ORDER BY PR.DTDISPONIVEL;
```

### 11. Análise de Turnos por Célula

```sql
SELECT
    PR.ALXCODIGO,
    PR.TURHRENTRADA,
    PR.TURHRSAIDA,
    PR.TURDIASUTEIS,
    COUNT(*) AS TOTAL_REGISTROS
FROM PEDROTEIRO PR
WHERE PR.TURHRENTRADA IS NOT NULL
GROUP BY
    PR.ALXCODIGO,
    PR.TURHRENTRADA,
    PR.TURHRSAIDA,
    PR.TURDIASUTEIS
ORDER BY PR.ALXCODIGO;
```

---

## 📊 Diagrama de Relacionamentos

```mermaid
erDiagram
    PEDROTEIRO {
        UNKNOWN7 ALXCODIGO PK
        UNKNOWN7 EMPCODIGO PK
        UNKNOWN8 ID_PEDIDO PK_FK
        UNKNOWN7 PDRORDEM PK
        UNKNOWN14 PDRCONCLUIDO
        UNKNOWN8 TEMPOMAXIMO
        UNKNOWN35 DTINICIO
        UNKNOWN35 DTTERMINO
        UNKNOWN8 TEMPOESPERA
        UNKNOWN8 TEMPOGASTO
        UNKNOWN35 DTDISPONIVEL
        UNKNOWN16 ID_ROTEIRO
        UNKNOWN16 ID_ROTEIRO_PAI
        UNKNOWN7 ALXCODIGOGERADO
        UNKNOWN7 EMPCODIGOGERADO
        UNKNOWN8 TEMPOREALGASTO
        UNKNOWN8 TURHRENTRADA
        UNKNOWN8 TURHRSAIDA
        UNKNOWN8 TURHRSAIDAALMOCO
        UNKNOWN8 TURHRENTRADAALMOCO
        UNKNOWN14 TURDIASUTEIS
    }

    PEDID {
        UNKNOWN8 ID_PEDIDO PK
        UNKNOWN14 PEDCODIGO
        UNKNOWN8 CLICODIGO
        UNKNOWN35 PEDDTEMIS
        UNKNOWN14 PEDSITPED
        UNKNOWN27 PEDVRTOTAL
        string mais_156_campos
    }

    ALMOX {
        UNKNOWN7 ALXCODIGO PK
        UNKNOWN7 EMPCODIGO PK
        UNKNOWN37 ALXDESCRICAO
        UNKNOWN8 TEMPOMAXIMO
        UNKNOWN7 DPTCODIGO FK
        string mais_67_campos
    }

    ROTEIRO {
        UNKNOWN7 ROTCODIGO PK
        UNKNOWN37 ROTDESCRICAO
    }

    DEPTO {
        UNKNOWN7 DPTCODIGO PK
        UNKNOWN37 DPTDESCRICAO
    }

    %% Relacionamento Formal (com FK)
    PEDROTEIRO ||--o{ PEDID : "ID_PEDIDO (FK)"

    %% Relacionamentos Implícitos (sem FK)
    PEDROTEIRO ||..o{ ALMOX : "ALXCODIGO+EMPCODIGO (implícito)"
    PEDROTEIRO ||..o{ ALMOX : "ALXCODIGOGERADO+EMPCODIGOGERADO (implícito)"
    PEDROTEIRO ||..o{ ROTEIRO : "ID_ROTEIRO (implícito)"
    PEDROTEIRO ||..o{ PEDROTEIRO : "ID_ROTEIRO_PAI (auto-ref implícito)"

    %% Relacionamento de ALMOX
    ALMOX ||--o{ DEPTO : "DPTCODIGO (FK)"

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

### 1. Ausência de Foreign Keys Formais

- **PEDROTEIRO NÃO possui FK formal para ALMOX**, apesar de usar (ALXCODIGO, EMPCODIGO) que formam a PK de ALMOX
- **PEDROTEIRO NÃO possui FK formal para ROTEIRO**, apesar de usar ID_ROTEIRO
- **ID_ROTEIRO_PAI não tem FK auto-referencial**, apesar de parecer uma hierarquia

Esta ausência pode ser:
- Design deliberado para permitir maior flexibilidade
- Sistema legado que evoluiu sem constraints
- Performance (evitar overhead de validação FK)

### 2. Campos de Tempo Sem Unidade Especificada

Os campos abaixo **NÃO têm unidade especificada no schema**:
- TEMPOMAXIMO
- TEMPOGASTO
- TEMPOREALGASTO
- TEMPOESPERA

**Ação Necessária:** Consultar documentação de negócio ou código da aplicação para confirmar se são segundos, minutos ou horas.

### 3. Diferença de Tipos - ROTEIRO vs ID_ROTEIRO

```
ROTEIRO.ROTCODIGO: UNKNOWN(7)
PEDROTEIRO.ID_ROTEIRO: UNKNOWN(16)
```

Esta diferença pode indicar:
- Conceitos relacionados mas distintos
- Evolução do sistema (campo foi expandido)
- ID_ROTEIRO pode armazenar valores compostos

### 4. Chave Primária Composta por 4 Campos

A PK composta permite:
- Múltiplas etapas (PDRORDEM) do mesmo pedido (ID_PEDIDO)
- Mesmo pedido em diferentes células (ALXCODIGO)
- Separação por empresa (EMPCODIGO)

**Implica em:**
- Consultas devem usar todos os 4 campos para máxima performance
- JOINs com PEDROTEIRO podem ser mais complexos

### 5. Volume de Dados

Com **11,2 milhões de registros**, PEDROTEIRO é uma tabela de alto volume:

**Recomendações:**
- Usar índices apropriados (já existem 5 índices criados)
- Filtrar por datas para consultas históricas
- Considerar particionamento se performance degradar
- Avaliar arquivamento de dados antigos

### 6. Índices Disponíveis

Aproveitar os índices criados para performance:

| Índice | Coluna(s) | Uso Recomendado |
|--------|-----------|-----------------|
| IND_PEDROTEIRO_DTDISPONIVEL | DTDISPONIVEL | Buscar por disponibilidade |
| IND_PEDROTEIRO_DTINICIO | DTINICIO | Buscar por data de início |
| IND_PEDROTEIRO_DTTERMINO | DTTERMINO | Buscar por data de término |
| IND_PEDROTEIRO_ID | ID_ROTEIRO | Buscar por tipo de roteiro |
| IND_PEDROTEIRO_IDPAI | ID_ROTEIRO_PAI | Navegar hierarquia |

### 7. Campos ALXCODIGOGERADO/EMPCODIGOGERADO

Estes campos sugerem um **fluxo de célula para célula**:

```
Célula Atual (ALXCODIGO) → Célula Gerada/Destino (ALXCODIGOGERADO)
```

**Utilidade:**
- Rastrear movimento de produtos entre células
- Identificar próxima etapa de produção
- Mapear fluxo completo de produção

### 8. Estrutura Hierárquica via ID_ROTEIRO_PAI

Permite roteiros complexos:

```
Roteiro Principal
    ├── Sub-roteiro 1
    │   ├── Sub-roteiro 1.1
    │   └── Sub-roteiro 1.2
    └── Sub-roteiro 2
```

**Casos de Uso:**
- Roteiros alternativos
- Processos paralelos
- Retrabalho/correções

### 9. Conexão Indireta com 66 Tabelas

Via PEDID, PEDROTEIRO tem acesso indireto a:
- Dados de clientes
- Produtos do pedido
- Informações financeiras
- Notas fiscais
- Transportadoras
- E muito mais

### 10. Tabelas com Nome "ROTEIRO" Sem Relação Direta

As tabelas abaixo têm "ROTEIRO" no nome mas **NÃO usam ID_ROTEIRO**:
- **JBXROTEIRO** (roteiro de JitBox) - relaciona com ALMOX
- **PDCROTEIRO** (roteiro de ??) - relaciona com ALMOX

Não confundir com a tabela ROTEIRO ou o campo ID_ROTEIRO de PEDROTEIRO.

---

## 📚 Referências Cruzadas

Para informações completas sobre tabelas relacionadas, consultar:

- **[PEDID_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela PEDID (se disponível)
- **[ALMOX_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela ALMOX
- **[ROTEIRO_RELACIONAMENTOS_COMPLETOS.md]** - Documentação da tabela ROTEIRO

---

**Fim da Documentação**

*Esta documentação foi gerada exclusivamente a partir do schema do banco de dados Firebird, sem interpretações de código-fonte local.*
