# Documentação Completa: Tabela SITUACAO

**Fonte:** Schema do Banco de Dados Firebird
**Tabela:** SITUACAO (Situações/Status de Clientes)
**Versão:** 1.0
**Data:** 2025-11-09

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura da Tabela](#estrutura-da-tabela)
3. [Relacionamentos Formais (Foreign Keys)](#relacionamentos-formais)
4. [Tabelas Relacionadas Detalhadas](#tabelas-relacionadas-detalhadas)
5. [Fluxos de Relacionamento Multi-Nível](#fluxos-multi-nível)
6. [Exemplos de Consultas](#exemplos-de-consultas)
7. [Diagrama de Relacionamentos](#diagrama-de-relacionamentos)
8. [Observações Importantes](#observações-importantes)

---

## 📊 Visão Geral

A tabela **SITUACAO** é uma **tabela mestre/lookup** extremamente minimalista que define os **tipos de situações** que podem ser atribuídas a clientes no sistema.

### Estatísticas

- **Total de Registros:** 5 (tabela mestre minimal)
- **Número de Colunas:** 3
- **Primary Key:** SITCODIGO (simples)
- **Foreign Keys Out:** 0
- **Foreign Keys In:** 1 (SITCLI)
- **Índices:** Nenhum além da PK

### Conceito: Tabela de Domínio

SITUACAO implementa o padrão de **tabela de domínio** (domain table) para categorização de status/situações de clientes.

**Exemplos possíveis de situações** (valores reais não disponíveis no schema):
- Ativo
- Inativo
- Bloqueado
- Suspenso
- Em análise

---

## 🏗️ Estrutura da Tabela

### Primary Key (Simples)

A chave primária é composta por **1 campo único**:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **SITCODIGO** | UNKNOWN(7) | Código da situação |

### Colunas Detalhadas (3 Total)

| Nome | Tipo | Not Null | PK | Descrição |
|------|------|----------|----|-----------|
| 🔑 **SITCODIGO** | UNKNOWN(7) | ✓ | ✓ | Código único da situação |
| **SITDESCRICAO** | UNKNOWN(37) | ✓ | | Descrição da situação |
| **SITTIPO** | UNKNOWN(14) | ✓ | | Tipo da situação |

### Categorização das Colunas

#### 1. Identificação
- **SITCODIGO:** Código numérico único (PK)

#### 2. Informações Descritivas
- **SITDESCRICAO:** Nome/descrição legível da situação
- **SITTIPO:** Classificação ou categoria da situação

**Observação:** Com apenas 5 registros, SITUACAO serve como um **enum de banco de dados** para limitar valores possíveis de situações de clientes.

---

## 🔗 Relacionamentos Formais (Foreign Keys)

### FK Out: Tabelas Referenciadas por SITUACAO

❌ **SITUACAO NÃO possui Foreign Keys formais** saindo.

### FK In: Tabelas que Referenciam SITUACAO

✅ **SITUACAO é referenciada por 1 tabela**:

| Tabela | Constraint | Coluna | Descrição |
|--------|------------|--------|-----------|
| **SITCLI** | SITUACAO_SITCLI | SITCODIGO | Histórico de situações de clientes |

---

## 📑 Tabelas Relacionadas Detalhadas

### 1. SITCLI - Histórico de Situações de Clientes (Relacionamento Formal)

**Tipo de Relacionamento:** 1:N (uma situação para muitos registros históricos)

**Informações da Tabela:**
- **Total:** 11.256 registros históricos
- **PK:** (CLICODIGO, SITDATA, SITSEQ)
- **Colunas:** 7 campos
- **FK Out:** 3 (CLIEN, SITUACAO, USUARIO)

**Campos Principais:**

| Campo | Tipo | PK/FK | Descrição |
|-------|------|-------|-----------|
| CLICODIGO | UNKNOWN(8) | PK/FK | Código do cliente |
| SITCODIGO | UNKNOWN(7) | FK | Código da situação (FK → SITUACAO) |
| SITDATA | UNKNOWN(35) | PK | Data da mudança de situação |
| SITSEQ | UNKNOWN(7) | PK | Sequência (múltiplas mudanças no mesmo dia) |
| SITOBSERVACAO | UNKNOWN(37) | | Observação curta |
| SITHISTO | UNKNOWN(261) | | Histórico detalhado |
| USUCODIGO | UNKNOWN(7) | FK | Usuário que registrou |

**Foreign Keys de SITCLI:**
```
SITCLI.SITCODIGO → SITUACAO.SITCODIGO (FK formal)
SITCLI.CLICODIGO → CLIEN.CLICODIGO (FK formal)
SITCLI.USUCODIGO → USUARIO.USUCODIGO (FK formal)
```

**Conceito:**
- SITCLI é uma **tabela de auditoria/histórico**
- Registra **quando** (SITDATA) cada cliente mudou de situação
- Registra **quem** (USUCODIGO) fez a mudança
- Permite múltiplas mudanças no mesmo dia via SITSEQ
- PK composta garante unicidade: cliente + data + sequência

**Fluxo:**
```
SITUACAO (5 tipos) ← SITCLI (11.2k históricos) → CLIEN (9.2k clientes)
```

### 2. CLIEN - Clientes (Relacionamento Indireto via SITCLI)

**Tipo de Relacionamento:** Indireto via SITCLI

**Informações da Tabela:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** Muitas (tabela complexa com dados cadastrais completos)

**Campos Principais (Selecionados):**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| CLICODIGO | UNKNOWN(8) PK | Código único do cliente |
| CLIRAZSOCIAL | UNKNOWN(37) | Razão social |
| CLINOMEFANT | UNKNOWN(37) | Nome fantasia |
| CLICNPJCPF | UNKNOWN(37) | CPF/CNPJ |
| CLICLIENTE | UNKNOWN(14) | Flag: é cliente? |
| CLIFORNEC | UNKNOWN(14) | Flag: é fornecedor? |
| CLISTATUS | UNKNOWN(14) | Status atual do cliente |

**Observação Importante:**
- CLIEN tem campo **CLISTATUS** que provavelmente armazena a situação **atual**
- SITCLI armazena o **histórico completo** de mudanças de situação
- SITUACAO define os **tipos possíveis** de situação

**Fluxo Lógico:**
```
Cliente cadastrado → CLISTATUS recebe valor inicial
Mudança de situação → Registro em SITCLI + atualiza CLISTATUS
Histórico completo → Consulta SITCLI
```

### 3. USUARIO - Usuários (Relacionamento Indireto via SITCLI)

**Tipo de Relacionamento:** Indireto via SITCLI.USUCODIGO

**Informações:**
- Registra **quem** fez cada mudança de situação
- Permite auditoria completa de alterações

**Fluxo:**
```
USUARIO → registra mudança em SITCLI → referencia SITUACAO
```

---

## 🌊 Fluxos de Relacionamento Multi-Nível

### Fluxo 1: Cadastro Inicial de Cliente

```
1. Cliente cadastrado em CLIEN
2. CLISTATUS recebe situação inicial (ex: "Ativo")
3. Registro inicial criado em SITCLI:
   - CLICODIGO (cliente)
   - SITCODIGO (situação inicial)
   - SITDATA (data de cadastro)
   - USUCODIGO (quem cadastrou)
```

### Fluxo 2: Mudança de Situação de Cliente

```
SITUACAO (tabela mestre)
    ↓ (define tipos possíveis)
SITCLI (registra mudança)
    ↓ (atualiza)
CLIEN.CLISTATUS (situação atual)
```

**Exemplo:**
```sql
-- Cliente 12345 muda de "Ativo" (1) para "Bloqueado" (3)

-- 1. Inserir histórico
INSERT INTO SITCLI (CLICODIGO, SITCODIGO, SITDATA, SITSEQ, USUCODIGO, SITHISTO)
VALUES (12345, 3, CURRENT_TIMESTAMP, 1, 5, 'Bloqueado por inadimplência');

-- 2. Atualizar status atual
UPDATE CLIEN SET CLISTATUS = '3' WHERE CLICODIGO = 12345;
```

### Fluxo 3: Auditoria Completa de Cliente

```
CLIEN (cliente específico)
    ↓ (todas mudanças)
SITCLI (histórico completo)
    ↓ (para cada registro)
SITUACAO (descrição da situação)
    +
USUARIO (quem fez a mudança)
```

**Permite responder:**
- Quando o cliente foi bloqueado?
- Quem bloqueou o cliente?
- Quantas vezes o cliente mudou de situação?
- Qual era a situação em determinada data?

### Fluxo 4: Relatório de Clientes por Situação

```
SITUACAO (todas as situações)
    ↓ (LEFT JOIN)
SITCLI (situação atual - última data)
    ↓ (INNER JOIN)
CLIEN (dados do cliente)
```

**Gera:** Lista de clientes agrupados por situação atual.

### Fluxo 5: Análise de Permanência em Situação

```
SITCLI (histórico ordenado por data)
    ↓ (calcular diferença entre mudanças)
Tempo médio em cada situação
    ↓ (agrupar por)
SITUACAO (descrição)
```

**Permite análise:**
- Tempo médio que clientes ficam em cada situação
- Identificar situações de longa duração
- Métricas de gestão de clientes

---

## 💡 Exemplos de Consultas

### 1. Listar Todas as Situações Disponíveis

```sql
SELECT
    S.SITCODIGO,
    S.SITDESCRICAO,
    S.SITTIPO
FROM SITUACAO S
ORDER BY S.SITCODIGO;
```

### 2. Contar Clientes por Situação Atual

```sql
SELECT
    S.SITCODIGO,
    S.SITDESCRICAO,
    COUNT(DISTINCT C.CLICODIGO) AS TOTAL_CLIENTES
FROM SITUACAO S
LEFT JOIN SITCLI SC
    ON S.SITCODIGO = SC.SITCODIGO
LEFT JOIN CLIEN C
    ON SC.CLICODIGO = C.CLICODIGO
WHERE SC.SITDATA = (
    SELECT MAX(SC2.SITDATA)
    FROM SITCLI SC2
    WHERE SC2.CLICODIGO = SC.CLICODIGO
)
GROUP BY S.SITCODIGO, S.SITDESCRICAO
ORDER BY TOTAL_CLIENTES DESC;
```

### 3. Histórico Completo de Situações de um Cliente

```sql
SELECT
    SC.SITDATA,
    SC.SITSEQ,
    S.SITCODIGO,
    S.SITDESCRICAO,
    SC.SITOBSERVACAO,
    SC.SITHISTO,
    U.USUNOME AS USUARIO_RESPONSAVEL
FROM SITCLI SC
INNER JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
LEFT JOIN USUARIO U
    ON SC.USUCODIGO = U.USUCODIGO
WHERE SC.CLICODIGO = 12345
ORDER BY SC.SITDATA DESC, SC.SITSEQ DESC;
```

### 4. Última Situação de Cada Cliente

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    SC.SITDATA AS DATA_ULTIMA_MUDANCA,
    S.SITCODIGO,
    S.SITDESCRICAO
FROM CLIEN C
LEFT JOIN SITCLI SC
    ON C.CLICODIGO = SC.CLICODIGO
    AND SC.SITDATA = (
        SELECT MAX(SC2.SITDATA)
        FROM SITCLI SC2
        WHERE SC2.CLICODIGO = C.CLICODIGO
    )
LEFT JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
ORDER BY C.CLIRAZSOCIAL;
```

### 5. Clientes que Mudaram de Situação no Último Mês

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    S.SITDESCRICAO AS SITUACAO_ATUAL,
    SC.SITDATA AS DATA_MUDANCA,
    SC.SITHISTO AS MOTIVO,
    U.USUNOME AS RESPONSAVEL
FROM SITCLI SC
INNER JOIN CLIEN C
    ON SC.CLICODIGO = C.CLICODIGO
INNER JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
LEFT JOIN USUARIO U
    ON SC.USUCODIGO = U.USUCODIGO
WHERE SC.SITDATA >= DATEADD(MONTH, -1, CURRENT_DATE)
ORDER BY SC.SITDATA DESC;
```

### 6. Frequência de Mudanças de Situação por Cliente

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    COUNT(*) AS TOTAL_MUDANCAS,
    MIN(SC.SITDATA) AS PRIMEIRA_MUDANCA,
    MAX(SC.SITDATA) AS ULTIMA_MUDANCA
FROM CLIEN C
INNER JOIN SITCLI SC
    ON C.CLICODIGO = SC.CLICODIGO
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL
HAVING COUNT(*) > 5
ORDER BY TOTAL_MUDANCAS DESC;
```

### 7. Distribuição de Mudanças por Situação

```sql
SELECT
    S.SITCODIGO,
    S.SITDESCRICAO,
    COUNT(*) AS TOTAL_REGISTROS,
    COUNT(DISTINCT SC.CLICODIGO) AS CLIENTES_DISTINTOS,
    MIN(SC.SITDATA) AS PRIMEIRA_OCORRENCIA,
    MAX(SC.SITDATA) AS ULTIMA_OCORRENCIA
FROM SITCLI SC
INNER JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
GROUP BY S.SITCODIGO, S.SITDESCRICAO
ORDER BY TOTAL_REGISTROS DESC;
```

### 8. Clientes com Situação Específica

```sql
-- Exemplo: Buscar todos os clientes "Bloqueados" (supondo SITCODIGO = 3)
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLICNPJCPF,
    SC.SITDATA AS DATA_BLOQUEIO,
    SC.SITHISTO AS MOTIVO_BLOQUEIO,
    U.USUNOME AS BLOQUEADO_POR
FROM SITCLI SC
INNER JOIN CLIEN C
    ON SC.CLICODIGO = C.CLICODIGO
INNER JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
LEFT JOIN USUARIO U
    ON SC.USUCODIGO = U.USUCODIGO
WHERE SC.SITCODIGO = 3
  AND SC.SITDATA = (
      SELECT MAX(SC2.SITDATA)
      FROM SITCLI SC2
      WHERE SC2.CLICODIGO = SC.CLICODIGO
  )
ORDER BY SC.SITDATA DESC;
```

### 9. Tempo Médio em Cada Situação

```sql
-- Análise de permanência em situações
WITH MudancasOrdenadas AS (
    SELECT
        SC.CLICODIGO,
        SC.SITCODIGO,
        SC.SITDATA,
        LEAD(SC.SITDATA) OVER (PARTITION BY SC.CLICODIGO ORDER BY SC.SITDATA) AS PROXIMA_DATA
    FROM SITCLI SC
)
SELECT
    S.SITCODIGO,
    S.SITDESCRICAO,
    AVG(DATEDIFF(DAY, MO.SITDATA, MO.PROXIMA_DATA)) AS DIAS_MEDIOS,
    COUNT(*) AS TOTAL_PERIODOS
FROM MudancasOrdenadas MO
INNER JOIN SITUACAO S
    ON MO.SITCODIGO = S.SITCODIGO
WHERE MO.PROXIMA_DATA IS NOT NULL
GROUP BY S.SITCODIGO, S.SITDESCRICAO
ORDER BY DIAS_MEDIOS DESC;
```

### 10. Auditoria: Quem Mais Alterou Situações

```sql
SELECT
    U.USUCODIGO,
    U.USUNOME,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT SC.CLICODIGO) AS CLIENTES_DISTINTOS,
    MIN(SC.SITDATA) AS PRIMEIRA_ALTERACAO,
    MAX(SC.SITDATA) AS ULTIMA_ALTERACAO
FROM SITCLI SC
INNER JOIN USUARIO U
    ON SC.USUCODIGO = U.USUCODIGO
GROUP BY U.USUCODIGO, U.USUNOME
ORDER BY TOTAL_ALTERACOES DESC
LIMIT 10;
```

### 11. Clientes que Nunca Mudaram de Situação

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLIDTCAD AS DATA_CADASTRO,
    COUNT(SC.SITCODIGO) AS MUDANCAS_SITUACAO
FROM CLIEN C
LEFT JOIN SITCLI SC
    ON C.CLICODIGO = SC.CLICODIGO
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL, C.CLIDTCAD
HAVING COUNT(SC.SITCODIGO) <= 1
ORDER BY C.CLIDTCAD DESC;
```

### 12. Situação Atual vs Situação em Data Específica

```sql
-- Comparar situação atual com situação em 01/01/2025
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    S_ATUAL.SITDESCRICAO AS SITUACAO_ATUAL,
    S_PASSADO.SITDESCRICAO AS SITUACAO_EM_01012025
FROM CLIEN C
LEFT JOIN SITCLI SC_ATUAL
    ON C.CLICODIGO = SC_ATUAL.CLICODIGO
    AND SC_ATUAL.SITDATA = (
        SELECT MAX(SC2.SITDATA)
        FROM SITCLI SC2
        WHERE SC2.CLICODIGO = C.CLICODIGO
    )
LEFT JOIN SITUACAO S_ATUAL
    ON SC_ATUAL.SITCODIGO = S_ATUAL.SITCODIGO
LEFT JOIN SITCLI SC_PASSADO
    ON C.CLICODIGO = SC_PASSADO.CLICODIGO
    AND SC_PASSADO.SITDATA = (
        SELECT MAX(SC3.SITDATA)
        FROM SITCLI SC3
        WHERE SC3.CLICODIGO = C.CLICODIGO
          AND SC3.SITDATA <= '2025-01-01'
    )
LEFT JOIN SITUACAO S_PASSADO
    ON SC_PASSADO.SITCODIGO = S_PASSADO.SITCODIGO
WHERE S_ATUAL.SITCODIGO <> S_PASSADO.SITCODIGO
ORDER BY C.CLIRAZSOCIAL;
```

---

## 📊 Diagrama de Relacionamentos

```mermaid
erDiagram
    SITUACAO {
        UNKNOWN7 SITCODIGO PK
        UNKNOWN37 SITDESCRICAO
        UNKNOWN14 SITTIPO
    }

    SITCLI {
        UNKNOWN8 CLICODIGO PK_FK
        UNKNOWN7 SITCODIGO FK
        UNKNOWN35 SITDATA PK
        UNKNOWN7 SITSEQ PK
        UNKNOWN37 SITOBSERVACAO
        UNKNOWN261 SITHISTO
        UNKNOWN7 USUCODIGO FK
    }

    CLIEN {
        UNKNOWN8 CLICODIGO PK
        UNKNOWN37 CLIRAZSOCIAL
        UNKNOWN37 CLINOMEFANT
        UNKNOWN37 CLICNPJCPF
        UNKNOWN14 CLICLIENTE
        UNKNOWN14 CLIFORNEC
        UNKNOWN14 CLISTATUS
        UNKNOWN35 CLIDTCAD
        string mais_campos
    }

    USUARIO {
        UNKNOWN7 USUCODIGO PK
        UNKNOWN37 USUNOME
        string outros_campos
    }

    PEDID {
        UNKNOWN8 ID_PEDIDO PK
        UNKNOWN8 CLICODIGO FK
        string outros_campos
    }

    %% Relacionamentos Formais (com FK constraint)
    SITUACAO ||--o{ SITCLI : "SITCODIGO (FK)"
    SITCLI }o--|| CLIEN : "CLICODIGO (FK)"
    SITCLI }o--|| USUARIO : "USUCODIGO (FK)"

    %% Relacionamentos de CLIEN (contexto adicional)
    CLIEN ||--o{ PEDID : "CLICODIGO (FK)"

    %% Notação:
    %% ||--o{ = Um para muitos (com FK constraint)
    %% }o--|| = Muitos para um (com FK constraint)
```

### Legenda do Diagrama

- **Linha sólida (`||--o{` ou `}o--||`)**: Relacionamento formal com Foreign Key constraint
- **PK**: Primary Key
- **FK**: Foreign Key

---

## ⚠️ Observações Importantes

### 1. Tabela Mestre Minimalista

**SITUACAO possui apenas 5 registros!**

```
Característica: Enum de Banco de Dados
Função: Limitar valores possíveis
Abordagem: Domain Table Pattern
```

**Comparação com outras tabelas mestre:**
- ROTEIRO: 2 registros (ainda menor!)
- CORBOX: 22 registros
- SITUACAO: 5 registros ✓
- LOCALPED: 142 registros

**Vantagens:**
- ✅ Integridade referencial
- ✅ Descrições centralizadas
- ✅ Fácil manutenção
- ✅ Documentação implícita

### 2. Ausência de Foreign Keys Saindo

```
SITUACAO possui 0 FKs Out
```

SITUACAO é uma **tabela independente** (não depende de outras):
- Não referencia outras tabelas
- Valores são auto-contidos
- Pode ser populada independentemente

### 3. SITCLI como Tabela de Auditoria

**Padrão de Design:** Audit Trail / History Table

**Benefícios:**
- ✅ **Auditoria completa:** Quem, quando, por quê
- ✅ **Histórico preservado:** Nunca perde informação
- ✅ **Análise temporal:** Situação em qualquer data
- ✅ **Compliance:** Rastreabilidade regulatória

**Estrutura:**
```
PK Composta = Cliente + Data + Sequência
├─ CLICODIGO: Quem mudou
├─ SITDATA: Quando mudou
└─ SITSEQ: Sequência (múltiplas mudanças no mesmo dia)
```

### 4. Duplicação Provável: CLISTATUS vs SITCLI

**CLIEN tem campo CLISTATUS** que provavelmente duplica informação:

```
CLIEN.CLISTATUS → Situação ATUAL (snapshot)
SITCLI → Histórico COMPLETO (audit trail)
```

**Por que duplicar?**
- **Performance:** Acesso rápido ao status atual sem JOIN
- **Denormalização:** Evitar consultas complexas em queries frequentes
- **Trade-off:** Espaço vs Velocidade

**Sincronização necessária:**
```sql
-- Ao mudar situação, fazer ambas operações:
UPDATE CLIEN SET CLISTATUS = '3' WHERE CLICODIGO = 12345;
INSERT INTO SITCLI (...) VALUES (...);
```

### 5. Campo SITTIPO - Categorização Adicional

**SITTIPO categoriza as 5 situações** em tipos/grupos:

**Possíveis interpretações:**
- 'A' = Ativo, 'I' = Inativo, 'B' = Bloqueado
- '1' = Operacional, '2' = Administrativo
- Agrupamento para relatórios

**Sem dados reais, não podemos confirmar, mas permite:**
- Agrupar situações similares
- Filtros por tipo
- Lógica de negócio diferenciada

### 6. Volume de Histórico: 11.256 Registros

**Análise:**
```
9.251 clientes × média de mudanças = 11.256 registros
11.256 / 9.251 ≈ 1,22 mudanças por cliente
```

**Interpretação:**
- Maioria dos clientes (≈82%) nunca mudou de situação
- Ou: Maioria tem apenas registro inicial
- Clientes ativos têm poucas mudanças

**Possíveis cenários:**
1. Sistema novo (pouco histórico acumulado)
2. Clientes estáveis (poucas mudanças de status)
3. Situações bem definidas (não precisam mudanças frequentes)

### 7. Sequenciamento: SITSEQ

**Permite múltiplas mudanças no mesmo dia:**

```sql
Cliente 12345 em 2025-11-09:
(12345, '2025-11-09', 1, ...) → Primeira mudança do dia
(12345, '2025-11-09', 2, ...) → Segunda mudança do dia
(12345, '2025-11-09', 3, ...) → Terceira mudança do dia
```

**Casos de uso:**
- Bloqueio temporário seguido de desbloqueio no mesmo dia
- Correções de situação
- Processos complexos com múltiplas etapas

### 8. Campos de Texto: SITOBSERVACAO vs SITHISTO

**Dois campos para documentação:**

| Campo | Tamanho | Uso Provável |
|-------|---------|--------------|
| SITOBSERVACAO | UNKNOWN(37) | Resumo curto (título) |
| SITHISTO | UNKNOWN(261) | Detalhamento completo |

**Exemplo:**
```
SITOBSERVACAO: "Inadimplência"
SITHISTO: "Cliente bloqueado devido a 3 faturas vencidas há mais de 60 dias. Total em atraso: R$ 15.000,00. Contato feito em 01/11/2025 sem retorno."
```

### 9. Ausência de Índices Adicionais

**SITCLI não tem índices além da PK!**

**Implicações:**
- Consultas por SITCODIGO: **não otimizadas**
- Consultas por USUCODIGO: **não otimizadas**
- Apenas busca por (CLICODIGO, SITDATA, SITSEQ) é eficiente

**Recomendação (se performance for crítica):**
```sql
CREATE INDEX IDX_SITCLI_SITCODIGO ON SITCLI(SITCODIGO);
CREATE INDEX IDX_SITCLI_USUCODIGO ON SITCLI(USUCODIGO);
CREATE INDEX IDX_SITCLI_SITDATA ON SITCLI(SITDATA);
```

### 10. Conexão com Sistema de Vendas

**Via CLIEN, SITUACAO conecta ao sistema de vendas:**

```
SITUACAO → SITCLI → CLIEN → PEDID (3,1M pedidos)
```

**Permite análises como:**
- Faturamento por situação de cliente
- Taxa de conversão por situação
- Identificar situações mais lucrativas
- Bloquear vendas para clientes em situações específicas

---

## 📚 Casos de Uso Práticos

### Caso de Uso 1: Workflow de Aprovação de Crédito

```
1. Cliente cadastrado → SITUACAO = "Em Análise"
2. Análise de crédito → SITUACAO = "Aprovado" ou "Reprovado"
3. Cliente compra → SITUACAO permanece "Aprovado"
4. Inadimplência → SITUACAO = "Bloqueado"
5. Pagamento → SITUACAO = "Aprovado" novamente
```

**Cada mudança registrada em SITCLI com:**
- Data da mudança
- Usuário responsável
- Motivo detalhado

### Caso de Uso 2: Relatório Gerencial

**Pergunta:** "Quantos clientes foram bloqueados no último mês?"

```sql
SELECT COUNT(DISTINCT SC.CLICODIGO) AS CLIENTES_BLOQUEADOS
FROM SITCLI SC
INNER JOIN SITUACAO S ON SC.SITCODIGO = S.SITCODIGO
WHERE S.SITDESCRICAO = 'Bloqueado'
  AND SC.SITDATA >= DATEADD(MONTH, -1, CURRENT_DATE);
```

### Caso de Uso 3: Integração com CRM

**Sistema externo consulta situação via API:**

```sql
-- API endpoint: GET /clientes/12345/situacao
SELECT
    S.SITCODIGO,
    S.SITDESCRICAO,
    SC.SITDATA AS DATA_SITUACAO,
    SC.SITHISTO AS DETALHES
FROM SITCLI SC
INNER JOIN SITUACAO S ON SC.SITCODIGO = S.SITCODIGO
WHERE SC.CLICODIGO = 12345
  AND SC.SITDATA = (
      SELECT MAX(SITDATA) FROM SITCLI WHERE CLICODIGO = 12345
  );
```

---

**Fim da Documentação**

*Esta documentação foi gerada exclusivamente a partir do schema do banco de dados Firebird, sem interpretações de código-fonte local.*
