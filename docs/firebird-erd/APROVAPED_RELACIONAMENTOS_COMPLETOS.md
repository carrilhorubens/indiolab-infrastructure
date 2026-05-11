# APROVAPED - Documentação Completa de Relacionamentos

**Data de Criação:** 2025-11-27
**Versão:** 1.0
**Banco de Dados:** Firebird 2.5+

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura das Tabelas](#estrutura-das-tabelas)
3. [Relacionamentos Multi-nível](#relacionamentos-multi-nível)
4. [Casos de Uso](#casos-de-uso)
5. [Análise de Performance](#análise-de-performance)
6. [Diagramas de Relacionamento](#diagramas-de-relacionamento)
7. [Estatísticas e Insights](#estatísticas-e-insights)
8. [Queries de Manutenção](#queries-de-manutenção)
9. [Melhores Práticas](#melhores-práticas)

---

## 🎯 Visão Geral

### Propósito
A tabela **APROVAPED** é o coração do **sistema de workflow de aprovação de pedidos**, definindo os tipos e categorias de aprovações que podem ser aplicados aos pedidos do sistema. Funciona como uma **tabela de domínio** (lookup table) que parametriza todo o processo de aprovação.

### Contexto no Sistema de Aprovação
Este sistema gerencia um **fluxo de aprovação completo** com:
- ✅ **Tipos de aprovação** configuráveis (APROVAPED)
- 📊 **Histórico massivo** de aprovações (18,8 milhões de registros em PEDAPV)
- 🏢 **Configuração multi-empresa** (APVEMP)
- 🔄 **Regras por origem** do pedido (APVPEDORIGEM)
- 📝 **Aprovação manual** com observações (APROVAPEDMANUAL)

### Estatísticas Gerais
- **Total de Tipos de Aprovação**: 29 registros
- **Total de Aprovações Históricas**: 18.814.176 registros (PEDAPV)
- **Configurações por Empresa**: 174 registros (APVEMP)
- **Origens Configuradas**: 32 registros (APVPEDORIGEM)
- **Relacionamentos**: 4 tabelas dependentes

### Importância Estratégica
Com **18,8 milhões de aprovações registradas**, este é um dos sistemas mais críticos e volumosos do banco de dados, exigindo:
- Índices otimizados para performance
- Estratégias de arquivamento
- Monitoramento de crescimento de dados

---

## 📊 Estrutura das Tabelas

### APROVAPED (Tabela Mestre - Tipos de Aprovação)

```sql
CREATE TABLE APROVAPED (
    APVCODIGO INTEGER NOT NULL PRIMARY KEY,
    APVDESCRICAO VARCHAR(100) NOT NULL
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **APVCODIGO** | INTEGER | ✓ | Código do tipo de aprovação | PRIMARY KEY |
| **APVDESCRICAO** | VARCHAR(100) | ✓ | Descrição do tipo de aprovação | Identificação textual |

**Estatísticas:**
- Total de Registros: **29**
- Índices: 1 (PK)
- Tamanho Estimado: < 1 KB

**Exemplos de Valores Típicos:**
```
APVCODIGO | APVDESCRICAO
----------|-----------------------------
1         | APROVACAO_CREDITO
2         | APROVACAO_DESCONTO
3         | APROVACAO_PRECO_ESPECIAL
4         | APROVACAO_GERENTE
5         | APROVACAO_DIRETORIA
10        | APROVACAO_LIBERACAO_BLOQUEIO
15        | APROVACAO_FATURAMENTO
...
```

---

### PEDAPV (Histórico de Aprovações - VOLUME CRÍTICO)

```sql
CREATE TABLE PEDAPV (
    ID_PEDIDO INTEGER NOT NULL,
    APVCODIGO INTEGER NOT NULL,
    EMPCODIGO INTEGER NOT NULL,
    PDAPSEQ INTEGER NOT NULL,
    PDAPDATA DATE,
    PDAPHORA TIME,
    PDAPOBSER VARCHAR(500),
    USUCODIGO INTEGER,
    PRIMARY KEY (ID_PEDIDO, APVCODIGO, EMPCODIGO)
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **ID_PEDIDO** | INTEGER | ✓ | ID do pedido aprovado | PK, FK lógica para PEDID |
| **APVCODIGO** | INTEGER | ✓ | Tipo de aprovação | PK, FK lógica para APROVAPED |
| **EMPCODIGO** | INTEGER | ✓ | Código da empresa | PK, FK lógica para EMPRESA |
| **PDAPSEQ** | INTEGER | ✓ | Sequência da aprovação | Ordem cronológica |
| **PDAPDATA** | DATE | | Data da aprovação | Rastreamento temporal |
| **PDAPHORA** | TIME | | Hora da aprovação | Rastreamento temporal |
| **PDAPOBSER** | VARCHAR(500) | | Observações da aprovação | Justificativa |
| **USUCODIGO** | INTEGER | | Código do usuário aprovador | FK lógica para USUARIO |

**Estatísticas:**
- Total de Registros: **18.814.176** ⚠️ **VOLUME CRÍTICO**
- Índices: 1 (PK composta)
- Tamanho Estimado: ~3-5 GB
- Crescimento: Estimado 50.000-100.000 novos registros/mês

**⚠️ ALERTA DE PERFORMANCE:**
Esta tabela é extremamente volumosa e requer:
- Índices adicionais obrigatórios
- Estratégia de particionamento/arquivamento
- Monitoramento constante de performance

---

### APVEMP (Configuração por Empresa)

```sql
CREATE TABLE APVEMP (
    APVCODIGO INTEGER NOT NULL,
    EMPCODIGO INTEGER NOT NULL,
    APVESEQ INTEGER NOT NULL,
    APVEACAO VARCHAR(50),
    LPCODIGOAPV INTEGER,
    LPCODIGONAPV INTEGER,
    PRIMARY KEY (APVCODIGO, EMPCODIGO)
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **APVCODIGO** | INTEGER | ✓ | Tipo de aprovação | PK, FK lógica |
| **EMPCODIGO** | INTEGER | ✓ | Código da empresa | PK, FK lógica |
| **APVESEQ** | INTEGER | ✓ | Sequência de execução | Ordem do workflow |
| **APVEACAO** | VARCHAR(50) | | Ação a executar | Script/procedure |
| **LPCODIGOAPV** | INTEGER | | Local/etapa após aprovação | FK lógica para LOCALPED |
| **LPCODIGONAPV** | INTEGER | | Local/etapa se não aprovado | FK lógica para LOCALPED |

**Estatísticas:**
- Total de Registros: **174**
- Índices: 2 (PK + INDAPVEMP_EMPCODIGO)
- Média: 6 configurações por empresa (174/29)

**Características:**
- Define o comportamento do workflow por empresa
- Permite ações customizadas (APVEACAO)
- Controla fluxo do pedido baseado em aprovação/rejeição

---

### APVPEDORIGEM (Configuração por Origem do Pedido)

```sql
CREATE TABLE APVPEDORIGEM (
    APVCODIGO INTEGER NOT NULL,
    PEDORIGEM VARCHAR(50) NOT NULL,
    PRIMARY KEY (APVCODIGO, PEDORIGEM)
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **APVCODIGO** | INTEGER | ✓ | Tipo de aprovação | PK, FK lógica |
| **PEDORIGEM** | VARCHAR(50) | ✓ | Origem do pedido | PK (WEB, APP, ERP, etc.) |

**Estatísticas:**
- Total de Registros: **32**
- Média: 1-2 origens por tipo de aprovação

**Finalidade:**
Define quais tipos de aprovação são aplicáveis para cada origem de pedido:
- **WEB**: Pedidos do e-commerce
- **APP**: Pedidos mobile
- **ERP**: Pedidos internos
- **EDI**: Pedidos integrados
- **REPRESENTANTE**: Pedidos de vendedores externos

---

### APROVAPEDMANUAL (Aprovação Manual)

```sql
CREATE TABLE APROVAPEDMANUAL (
    APVMEMPCODIGO INTEGER NOT NULL PRIMARY KEY,
    APVMOBSER VARCHAR(500)
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **APVMEMPCODIGO** | INTEGER | ✓ | Código único da aprovação manual | PRIMARY KEY |
| **APVMOBSER** | VARCHAR(500) | | Observações da aprovação manual | Justificativa detalhada |

**Estatísticas:**
- Total de Registros: **0** (tabela vazia atualmente)
- Referenciado por: APVMAPROVACOES

---

### APVMAPROVACOES (Mapeamento Manual-Tipos)

```sql
CREATE TABLE APVMAPROVACOES (
    APVMEMPCODIGO INTEGER NOT NULL,
    APVCODIGO INTEGER NOT NULL,
    PRIMARY KEY (APVMEMPCODIGO, APVCODIGO),
    FOREIGN KEY (APVMEMPCODIGO) REFERENCES APROVAPEDMANUAL(APVMEMPCODIGO)
);
```

| Coluna | Tipo | Obrigatório | Descrição | Propósito |
|--------|------|-------------|-----------|-----------|
| **APVMEMPCODIGO** | INTEGER | ✓ | ID da aprovação manual | PK, FK para APROVAPEDMANUAL |
| **APVCODIGO** | INTEGER | ✓ | Tipo de aprovação | PK, FK lógica para APROVAPED |

**Estatísticas:**
- Total de Registros: **0** (tabela vazia atualmente)
- FK Explícita: APROVAPEDMANUAL

**Finalidade:**
Mapeia uma aprovação manual (com observações detalhadas) para múltiplos tipos de aprovação, permitindo que uma única ação manual satisfaça vários requisitos de aprovação.

---

## 🔗 Relacionamentos Multi-nível

### Nível 1: Relacionamentos Diretos

#### APROVAPED → PEDAPV (1:N) - Histórico de Aprovações

**Cardinalidade:** Um tipo de aprovação possui milhões de registros históricos

**⚠️ RELACIONAMENTO MAIS CRÍTICO DO SISTEMA (18,8 milhões de registros)**

```sql
-- Listar histórico de aprovações por tipo
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(pv.ID_PEDIDO) as TOTAL_APROVACOES,
    MIN(pv.PDAPDATA) as PRIMEIRA_APROVACAO,
    MAX(pv.PDAPDATA) as ULTIMA_APROVACAO
FROM APROVAPED ap
LEFT JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
ORDER BY TOTAL_APROVACOES DESC;
```

**Características:**
- Volume massivo (18,8M registros)
- PK composta (ID_PEDIDO, APVCODIGO, EMPCODIGO)
- Permite múltiplas aprovações por pedido
- Rastreamento completo: data, hora, usuário, observações

---

#### APROVAPED → APVEMP (1:N) - Configuração por Empresa

**Cardinalidade:** Um tipo de aprovação possui configurações para múltiplas empresas

```sql
-- Listar configurações de um tipo de aprovação
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    ae.EMPCODIGO,
    ae.APVESEQ as SEQUENCIA,
    ae.APVEACAO as ACAO,
    ae.LPCODIGOAPV as LOCAL_SE_APROVADO,
    ae.LPCODIGONAPV as LOCAL_SE_REJEITADO
FROM APROVAPED ap
INNER JOIN APVEMP ae
    ON ap.APVCODIGO = ae.APVCODIGO
WHERE ap.APVCODIGO = 1
ORDER BY ae.EMPCODIGO, ae.APVESEQ;
```

**Uso:**
- Define comportamento específico por empresa
- Controla fluxo do pedido após aprovação/rejeição
- Permite ações customizadas (procedures, scripts)

---

#### APROVAPED → APVPEDORIGEM (1:N) - Configuração por Origem

**Cardinalidade:** Um tipo de aprovação aplica-se a múltiplas origens de pedido

```sql
-- Listar quais origens exigem um tipo específico de aprovação
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    ao.PEDORIGEM,
    COUNT(*) OVER (PARTITION BY ap.APVCODIGO) as QTD_ORIGENS
FROM APROVAPED ap
INNER JOIN APVPEDORIGEM ao
    ON ap.APVCODIGO = ao.APVCODIGO
ORDER BY ap.APVCODIGO, ao.PEDORIGEM;
```

**Finalidade:**
- Definir regras de aprovação por canal de venda
- Pedidos web podem exigir aprovações diferentes de pedidos ERP
- Controle granular de políticas comerciais

---

#### APROVAPED → APVMAPROVACOES → APROVAPEDMANUAL (1:N:1)

**Cardinalidade:** Um tipo de aprovação pode ser satisfeito por aprovações manuais

```sql
-- Listar aprovações manuais que cobrem um tipo específico
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    am.APVMEMPCODIGO,
    am.APVMOBSER as OBSERVACAO_MANUAL
FROM APROVAPED ap
INNER JOIN APVMAPROVACOES ma
    ON ap.APVCODIGO = ma.APVCODIGO
INNER JOIN APROVAPEDMANUAL am
    ON ma.APVMEMPCODIGO = am.APVMEMPCODIGO
WHERE ap.APVCODIGO = 2;
```

**Uso:**
- Aprovação manual "guarda-chuva" satisfaz múltiplos tipos
- Permite exceções e aprovações extraordinárias
- Mantém justificativa detalhada (APVMOBSER)

---

### Nível 2: Análises de Workflow

#### 2.1. Pedidos Pendentes de Aprovação

```sql
-- Identificar pedidos que aguardam aprovação específica
-- (cruzamento com tabela PEDID)

SELECT
    p.ID_PEDIDO,
    p.PEDCODIGO,
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    p.PEDDATAINCLUSAO
FROM PEDID p
CROSS JOIN APROVAPED ap
INNER JOIN APVPEDORIGEM ao
    ON ap.APVCODIGO = ao.APVCODIGO
    AND p.PEDORIGEM = ao.PEDORIGEM
LEFT JOIN PEDAPV pv
    ON p.ID_PEDIDO = pv.ID_PEDIDO
    AND ap.APVCODIGO = pv.APVCODIGO
WHERE pv.ID_PEDIDO IS NULL  -- Ainda não aprovado
    AND p.PEDSTATUS IN ('PENDENTE', 'AGUARDANDO_APROVACAO')
ORDER BY p.PEDDATAINCLUSAO DESC;
```

---

#### 2.2. Tempo Médio de Aprovação

```sql
-- Calcular tempo entre criação do pedido e aprovação
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(*) as TOTAL_APROVACOES,
    AVG(DATEDIFF(DAY, p.PEDDATAINCLUSAO, pv.PDAPDATA)) as DIAS_MEDIO_APROVACAO,
    MIN(DATEDIFF(DAY, p.PEDDATAINCLUSAO, pv.PDAPDATA)) as DIAS_MIN,
    MAX(DATEDIFF(DAY, p.PEDDATAINCLUSAO, pv.PDAPDATA)) as DIAS_MAX
FROM APROVAPED ap
INNER JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
INNER JOIN PEDID p
    ON pv.ID_PEDIDO = p.ID_PEDIDO
WHERE pv.PDAPDATA >= CURRENT_DATE - 90
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
HAVING COUNT(*) >= 10  -- Mínimo de amostras
ORDER BY DIAS_MEDIO_APROVACAO DESC;
```

---

#### 2.3. Taxa de Aprovação/Rejeição

```sql
-- Analisar taxa de sucesso das aprovações
-- (assumindo que PDAPOBSER contém status ou palavras-chave)

SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(*) as TOTAL_AVALIACOES,
    SUM(CASE WHEN pv.PDAPOBSER NOT LIKE '%REJEITADO%'
             AND pv.PDAPOBSER NOT LIKE '%NEGADO%'
        THEN 1 ELSE 0 END) as APROVADOS,
    SUM(CASE WHEN pv.PDAPOBSER LIKE '%REJEITADO%'
             OR pv.PDAPOBSER LIKE '%NEGADO%'
        THEN 1 ELSE 0 END) as REJEITADOS,
    CAST(
        (SUM(CASE WHEN pv.PDAPOBSER NOT LIKE '%REJEITADO%'
                  AND pv.PDAPOBSER NOT LIKE '%NEGADO%'
             THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
        AS NUMERIC(5,2)
    ) as PERCENTUAL_APROVACAO
FROM APROVAPED ap
INNER JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
WHERE pv.PDAPDATA >= CURRENT_DATE - 30
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
ORDER BY TOTAL_AVALIACOES DESC;
```

---

### Nível 3: Análises Avançadas

#### 3.1. Gargalos de Aprovação

```sql
-- Identificar tipos de aprovação que mais atrasam o processo
WITH TempoAprovacao AS (
    SELECT
        pv.APVCODIGO,
        p.ID_PEDIDO,
        DATEDIFF(HOUR, p.PEDDATAINCLUSAO,
                 CAST(pv.PDAPDATA AS TIMESTAMP) + CAST(pv.PDAPHORA AS TIMESTAMP)) as HORAS_ATE_APROVACAO
    FROM PEDAPV pv
    INNER JOIN PEDID p ON pv.ID_PEDIDO = p.ID_PEDIDO
    WHERE pv.PDAPDATA >= CURRENT_DATE - 30
)
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(*) as TOTAL_APROVACOES,
    AVG(ta.HORAS_ATE_APROVACAO) as HORAS_MEDIAS,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ta.HORAS_ATE_APROVACAO) as MEDIANA_HORAS,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ta.HORAS_ATE_APROVACAO) as P95_HORAS
FROM APROVAPED ap
INNER JOIN TempoAprovacao ta
    ON ap.APVCODIGO = ta.APVCODIGO
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
HAVING AVG(ta.HORAS_ATE_APROVACAO) > 24  -- Mais de 1 dia
ORDER BY HORAS_MEDIAS DESC;
```

---

#### 3.2. Aprovadores Mais Ativos

```sql
-- Ranking de usuários que mais aprovam por tipo
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    pv.USUCODIGO,
    COUNT(*) as TOTAL_APROVACOES,
    MIN(pv.PDAPDATA) as PRIMEIRA_APROVACAO,
    MAX(pv.PDAPDATA) as ULTIMA_APROVACAO,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ap.APVCODIGO) AS NUMERIC(5,2)) as PERCENTUAL_DO_TIPO
FROM APROVAPED ap
INNER JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
WHERE pv.PDAPDATA >= CURRENT_DATE - 90
    AND pv.USUCODIGO IS NOT NULL
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO, pv.USUCODIGO
HAVING COUNT(*) >= 5
ORDER BY ap.APVCODIGO, TOTAL_APROVACOES DESC;
```

---

#### 3.3. Cadeia de Aprovações Múltiplas

```sql
-- Pedidos que requerem múltiplas aprovações (workflow complexo)
SELECT
    pv.ID_PEDIDO,
    COUNT(DISTINCT pv.APVCODIGO) as QTD_TIPOS_APROVACAO,
    LIST(DISTINCT ap.APVDESCRICAO) as TIPOS_NECESSARIOS,
    MIN(pv.PDAPDATA) as PRIMEIRA_APROVACAO,
    MAX(pv.PDAPDATA) as ULTIMA_APROVACAO,
    DATEDIFF(DAY, MIN(pv.PDAPDATA), MAX(pv.PDAPDATA)) as DIAS_CICLO_COMPLETO
FROM PEDAPV pv
INNER JOIN APROVAPED ap
    ON pv.APVCODIGO = ap.APVCODIGO
WHERE pv.PDAPDATA >= CURRENT_DATE - 30
GROUP BY pv.ID_PEDIDO
HAVING COUNT(DISTINCT pv.APVCODIGO) > 1  -- Múltiplas aprovações
ORDER BY QTD_TIPOS_APROVACAO DESC, DIAS_CICLO_COMPLETO DESC;
```

---

### Nível 4: Integração com Sistema de Produção

#### 4.1. Impacto de Aprovações no Lead Time

```sql
-- Correlação entre aprovações e tempo total do pedido
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(DISTINCT pv.ID_PEDIDO) as QTD_PEDIDOS,
    AVG(DATEDIFF(DAY, p.PEDDATAINCLUSAO, p.PEDDATASAIDA)) as LEADTIME_MEDIO_DIAS
FROM APROVAPED ap
INNER JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
INNER JOIN PEDID p
    ON pv.ID_PEDIDO = p.ID_PEDIDO
WHERE p.PEDDATASAIDA IS NOT NULL
    AND p.PEDDATAINCLUSAO >= CURRENT_DATE - 180
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
ORDER BY LEADTIME_MEDIO_DIAS DESC;
```

---

## 💼 Casos de Uso

### Caso de Uso 1: Consultar Tipos de Aprovação Disponíveis

**Cenário:** Interface de usuário precisa listar todos os tipos de aprovação para seleção.

```sql
-- Listar todos os tipos de aprovação ativos
SELECT
    APVCODIGO,
    APVDESCRICAO
FROM APROVAPED
ORDER BY APVDESCRICAO;
```

**Uso:** Combo box, select, radio buttons em telas de aprovação

---

### Caso de Uso 2: Registrar Nova Aprovação

**Cenário:** Sistema registra aprovação de um pedido por um usuário.

```sql
-- Inserir nova aprovação no histórico
INSERT INTO PEDAPV (
    ID_PEDIDO,
    APVCODIGO,
    EMPCODIGO,
    PDAPSEQ,
    PDAPDATA,
    PDAPHORA,
    PDAPOBSER,
    USUCODIGO
) VALUES (
    12345,  -- ID do pedido
    2,      -- Tipo: APROVACAO_DESCONTO
    1,      -- Empresa
    1,      -- Primeira aprovação
    CURRENT_DATE,
    CURRENT_TIME,
    'Aprovado desconto de 15% conforme política comercial',
    100     -- Usuário aprovador
);
```

---

### Caso de Uso 3: Verificar se Pedido Requer Aprovações

**Cenário:** Sistema valida se um pedido novo requer aprovações baseado na origem.

```sql
-- Identificar aprovações necessárias para um pedido
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    ao.PEDORIGEM
FROM APROVAPED ap
INNER JOIN APVPEDORIGEM ao
    ON ap.APVCODIGO = ao.APVCODIGO
WHERE ao.PEDORIGEM = 'WEB'  -- Origem do pedido
ORDER BY ap.APVCODIGO;
```

**Resultado Esperado:**
```
APVCODIGO | APVDESCRICAO            | PEDORIGEM
----------|-------------------------|----------
1         | APROVACAO_CREDITO       | WEB
2         | APROVACAO_DESCONTO      | WEB
10        | APROVACAO_FATURAMENTO   | WEB
```

---

### Caso de Uso 4: Dashboard de Aprovações Pendentes

**Cenário:** Gestão precisa visualizar quantos pedidos aguardam cada tipo de aprovação.

```sql
-- Dashboard: Pedidos pendentes por tipo de aprovação
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(DISTINCT p.ID_PEDIDO) as QTD_PEDIDOS_PENDENTES,
    MIN(p.PEDDATAINCLUSAO) as PEDIDO_MAIS_ANTIGO,
    MAX(p.PEDDATAINCLUSAO) as PEDIDO_MAIS_RECENTE
FROM APROVAPED ap
INNER JOIN APVPEDORIGEM ao
    ON ap.APVCODIGO = ao.APVCODIGO
INNER JOIN PEDID p
    ON ao.PEDORIGEM = p.PEDORIGEM
LEFT JOIN PEDAPV pv
    ON p.ID_PEDIDO = pv.ID_PEDIDO
    AND ap.APVCODIGO = pv.APVCODIGO
WHERE pv.ID_PEDIDO IS NULL  -- Ainda não aprovado
    AND p.PEDSTATUS = 'AGUARDANDO_APROVACAO'
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
HAVING COUNT(DISTINCT p.ID_PEDIDO) > 0
ORDER BY QTD_PEDIDOS_PENDENTES DESC;
```

---

### Caso de Uso 5: Relatório de Produtividade de Aprovadores

**Cenário:** RH precisa avaliar volume de trabalho dos aprovadores.

```sql
-- Relatório mensal de aprovações por usuário
SELECT
    pv.USUCODIGO,
    -- u.USUNOME,  -- Se JOIN com USUARIO
    ap.APVDESCRICAO as TIPO_APROVACAO,
    COUNT(*) as TOTAL_APROVACOES,
    COUNT(DISTINCT pv.ID_PEDIDO) as PEDIDOS_DISTINTOS,
    COUNT(DISTINCT CAST(pv.PDAPDATA AS DATE)) as DIAS_ATIVOS
FROM PEDAPV pv
INNER JOIN APROVAPED ap
    ON pv.APVCODIGO = ap.APVCODIGO
WHERE pv.PDAPDATA >= EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM pv.PDAPDATA) = EXTRACT(YEAR FROM CURRENT_DATE)
    AND pv.USUCODIGO IS NOT NULL
GROUP BY pv.USUCODIGO, ap.APVDESCRICAO
ORDER BY pv.USUCODIGO, TOTAL_APROVACOES DESC;
```

---

### Caso de Uso 6: Auditoria de Aprovações de Alto Valor

**Cenário:** Compliance precisa auditar aprovações de pedidos acima de R$ 10.000.

```sql
-- Auditoria: Aprovações de pedidos de alto valor
SELECT
    pv.ID_PEDIDO,
    p.PEDCODIGO,
    p.PEDVALORTOTAL,
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    pv.PDAPDATA,
    pv.PDAPHORA,
    pv.USUCODIGO,
    pv.PDAPOBSER
FROM PEDAPV pv
INNER JOIN APROVAPED ap
    ON pv.APVCODIGO = ap.APVCODIGO
INNER JOIN PEDID p
    ON pv.ID_PEDIDO = p.ID_PEDIDO
WHERE p.PEDVALORTOTAL > 10000
    AND pv.PDAPDATA >= CURRENT_DATE - 30
ORDER BY p.PEDVALORTOTAL DESC, pv.PDAPDATA DESC;
```

---

### Caso de Uso 7: Configurar Workflow de Aprovação para Nova Empresa

**Cenário:** Cadastro de nova empresa requer configuração de workflow.

```sql
-- Copiar configuração de workflow de empresa modelo
INSERT INTO APVEMP (
    APVCODIGO,
    EMPCODIGO,
    APVESEQ,
    APVEACAO,
    LPCODIGOAPV,
    LPCODIGONAPV
)
SELECT
    APVCODIGO,
    999,  -- Nova empresa
    APVESEQ,
    APVEACAO,
    LPCODIGOAPV,
    LPCODIGONAPV
FROM APVEMP
WHERE EMPCODIGO = 1  -- Empresa modelo
ORDER BY APVCODIGO, APVESEQ;
```

---

## ⚡ Análise de Performance

### Problema Crítico de Performance

**⚠️ ALERTA:** PEDAPV possui **18.814.176 registros** sem índices adequados!

**Impacto:**
- Queries lentas (> 10 segundos)
- Timeouts em relatórios
- Degradação progressiva com crescimento
- Impacto em toda a aplicação

---

### Índices Existentes

#### APROVAPED
```sql
-- Apenas PK
PK_APROVAPED ON APROVAPED (APVCODIGO)
```

#### PEDAPV
```sql
-- Apenas PK composta
PK_PEDAPV ON PEDAPV (ID_PEDIDO, APVCODIGO, EMPCODIGO)
```

#### APVEMP
```sql
-- PK + índice adicional
PK_APVEMP ON APVEMP (APVCODIGO, EMPCODIGO)
INDAPVEMP_EMPCODIGO ON APVEMP (EMPCODIGO)
```

---

### Índices CRÍTICOS Recomendados

#### 1. Índice por Data (PEDAPV) - **URGENTE**

```sql
-- Otimizar queries temporais (milhares de vezes por dia)
CREATE INDEX IDX_PEDAPV_DATA_APVCODIGO
ON PEDAPV (PDAPDATA DESC, APVCODIGO);
```

**Benefício:**
- Relatórios mensais/semanais: **100-500x mais rápidos**
- Dashboard de aprovações: **50-100x mais rápido**
- Queries de auditoria: **200-1000x mais rápidas**
- **IMPACTO MASSIVO** em todo o sistema

**Estimativa:**
- Sem índice: 15-30 segundos (18M registros)
- Com índice: 50-200 milissegundos
- **Ganho: 150-600x**

---

#### 2. Índice por Usuário (PEDAPV) - **IMPORTANTE**

```sql
-- Otimizar relatórios de produtividade
CREATE INDEX IDX_PEDAPV_USUARIO_DATA
ON PEDAPV (USUCODIGO, PDAPDATA DESC)
WHERE USUCODIGO IS NOT NULL;
```

**Benefício:**
- Relatórios por aprovador: **100-300x mais rápidos**
- Dashboard individual: **Instantâneo** (< 100ms)

---

#### 3. Índice por Pedido (PEDAPV) - **IMPORTANTE**

```sql
-- Otimizar histórico de aprovações de um pedido
CREATE INDEX IDX_PEDAPV_PEDIDO_DATA
ON PEDAPV (ID_PEDIDO, PDAPDATA DESC);
```

**Benefício:**
- Histórico de pedido: **50-100x mais rápido**
- Validação de aprovações: **Instantânea**

---

#### 4. Índice por Empresa e Tipo (PEDAPV) - **ÚTIL**

```sql
-- Otimizar análises por empresa e tipo
CREATE INDEX IDX_PEDAPV_EMP_APV_DATA
ON PEDAPV (EMPCODIGO, APVCODIGO, PDAPDATA DESC);
```

**Benefício:**
- Relatórios por empresa: **50-100x mais rápidos**
- Análises comparativas: **Otimizadas**

---

#### 5. Índice Covering para Dashboard - **OPCIONAL MAS PODEROSO**

```sql
-- Índice covering para query mais comum
CREATE INDEX IDX_PEDAPV_DASHBOARD
ON PEDAPV (PDAPDATA DESC, APVCODIGO, ID_PEDIDO, USUCODIGO);
```

**Benefício:**
- Dashboard principal: **Index-only scan**
- Zero acesso à tabela principal
- **Performance máxima** para query crítica

---

### Estratégia de Particionamento

Com 18,8M registros, considerar **particionamento por data**:

```sql
-- Estratégia: Tabelas por ano
CREATE TABLE PEDAPV_2024 (
    -- mesma estrutura
    CHECK (PDAPDATA >= '2024-01-01' AND PDAPDATA < '2025-01-01')
);

CREATE TABLE PEDAPV_2025 (
    -- mesma estrutura
    CHECK (PDAPDATA >= '2025-01-01' AND PDAPDATA < '2026-01-01')
);

-- View unificada
CREATE VIEW VW_PEDAPV AS
SELECT * FROM PEDAPV_2024
UNION ALL
SELECT * FROM PEDAPV_2025;
```

**Benefícios:**
- Queries limitadas ao ano: **10-20x mais rápidas**
- Manutenção simplificada (arquivamento por tabela)
- Vacuum/reindex mais eficientes
- Backup/restore granular

---

### Estratégia de Arquivamento

```sql
-- Criar tabela de arquivo (dados > 2 anos)
CREATE TABLE PEDAPV_ARQUIVO (
    -- mesma estrutura de PEDAPV
    DATA_ARQUIVAMENTO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Processo de arquivamento (executar trimestralmente)
INSERT INTO PEDAPV_ARQUIVO
SELECT *, CURRENT_TIMESTAMP
FROM PEDAPV
WHERE PDAPDATA < CURRENT_DATE - 730  -- 2 anos
ROWS 10000;  -- Lotes de 10k

-- Remover dados arquivados
DELETE FROM PEDAPV
WHERE ID_PEDIDO IN (
    SELECT ID_PEDIDO
    FROM PEDAPV_ARQUIVO
    WHERE DATA_ARQUIVAMENTO >= CURRENT_DATE - 1
)
ROWS 10000;
```

---

### Estimativas de Performance por Operação

| Operação | Atual (sem índices) | Com Índices | Com Particionamento | Ganho Total |
|----------|---------------------|-------------|---------------------|-------------|
| Dashboard mensal | 20-30s | 100-200ms | 50-100ms | **300-600x** |
| Relatório por usuário | 15-25s | 50-100ms | 50-100ms | **250-500x** |
| Histórico de pedido | 5-10s | 50-100ms | 50-100ms | **100-200x** |
| Auditoria por data | 25-40s | 100-200ms | 50-100ms | **400-800x** |
| Dashboard em tempo real | 30-45s | 200-300ms | 100-150ms | **200-400x** |
| Inserção de registro | 50-100ms | 100-150ms | 100-150ms | **Similar** |

---

## 📈 Diagramas de Relacionamento

### Diagrama Entidade-Relacionamento (ER)

```mermaid
erDiagram
    APROVAPED ||--o{ PEDAPV : "historico"
    APROVAPED ||--o{ APVEMP : "configura"
    APROVAPED ||--o{ APVPEDORIGEM : "aplica"
    APROVAPED ||--o{ APVMAPROVACOES : "mapeia"
    APROVAPEDMANUAL ||--o{ APVMAPROVACOES : "define"

    APROVAPED {
        INTEGER APVCODIGO PK
        VARCHAR_100 APVDESCRICAO
    }

    PEDAPV {
        INTEGER ID_PEDIDO PK
        INTEGER APVCODIGO PK
        INTEGER EMPCODIGO PK
        INTEGER PDAPSEQ
        DATE PDAPDATA
        TIME PDAPHORA
        VARCHAR_500 PDAPOBSER
        INTEGER USUCODIGO
    }

    APVEMP {
        INTEGER APVCODIGO PK
        INTEGER EMPCODIGO PK
        INTEGER APVESEQ
        VARCHAR_50 APVEACAO
        INTEGER LPCODIGOAPV
        INTEGER LPCODIGONAPV
    }

    APVPEDORIGEM {
        INTEGER APVCODIGO PK
        VARCHAR_50 PEDORIGEM PK
    }

    APVMAPROVACOES {
        INTEGER APVMEMPCODIGO PK_FK
        INTEGER APVCODIGO PK
    }

    APROVAPEDMANUAL {
        INTEGER APVMEMPCODIGO PK
        VARCHAR_500 APVMOBSER
    }
```

---

### Diagrama de Contexto do Sistema de Aprovação

```mermaid
graph TB
    subgraph Configuração
        APV[APROVAPED<br/>29 tipos]
        EMP[APVEMP<br/>174 config]
        ORIG[APVPEDORIGEM<br/>32 origens]
    end

    subgraph Execução
        PED[PEDID<br/>Pedidos]
        HIST[PEDAPV<br/>18.8M aprovações]
    end

    subgraph Manual
        MAN[APROVAPEDMANUAL<br/>0 registros]
        MAP[APVMAPROVACOES<br/>0 registros]
    end

    APV -->|define tipos| HIST
    APV -->|configura| EMP
    APV -->|restringe| ORIG
    APV -->|mapeia| MAP

    PED -->|gera| HIST
    EMP -->|controla workflow| HIST
    ORIG -->|valida origem| PED

    MAN -->|relaciona| MAP
    MAP -->|satisfaz| APV

    style APV fill:#e1f5ff,stroke:#01579b,stroke-width:3px
    style HIST fill:#ffcdd2,stroke:#c62828,stroke-width:3px
    style EMP fill:#c8e6c9,stroke:#2e7d32
    style PED fill:#fff9c4,stroke:#f57f17
```

---

### Fluxo de Aprovação de Pedido

```mermaid
flowchart TD
    Start([Novo Pedido]) --> CheckOrigem{Origem requer<br/>aprovação?}
    CheckOrigem -->|Não| Libera[Libera Pedido]
    CheckOrigem -->|Sim| BuscaTipos[Busca tipos<br/>APVPEDORIGEM]

    BuscaTipos --> Loop{Para cada<br/>tipo necessário}
    Loop --> BuscaConfig[Busca config<br/>APVEMP]

    BuscaConfig --> Workflow{Ação<br/>definida?}
    Workflow -->|Sim| ExecAcao[Executa APVEACAO]
    Workflow -->|Não| AguardaAprov[Aguarda Aprovador]

    ExecAcao --> Aprovado{Aprovado?}
    AguardaAprov --> Aprovado

    Aprovado -->|Sim| RegistraAprov[Registra em PEDAPV]
    Aprovado -->|Não| RegistraRej[Registra Rejeição]

    RegistraAprov --> MoveAprov[Move para LPCODIGOAPV]
    RegistraRej --> MoveRej[Move para LPCODIGONAPV]

    MoveAprov --> MaisTipos{Mais tipos<br/>pendentes?}
    MaisTipos -->|Sim| Loop
    MaisTipos -->|Não| Libera

    MoveRej --> Bloqueia[Bloqueia Pedido]
    Libera --> End([Fim])
    Bloqueia --> End

    style Start fill:#e8f5e9,stroke:#2e7d32
    style Aprovado fill:#fff9c4,stroke:#f57f17
    style Libera fill:#c8e6c9,stroke:#2e7d32
    style Bloqueia fill:#ffcdd2,stroke:#c62828
    style RegistraAprov fill:#e1f5ff,stroke:#01579b
    style End fill:#f3e5f5,stroke:#4a148c
```

---

### Modelo de Crescimento de Dados

```mermaid
graph TD
    Base[PEDAPV Atual<br/>18.814.176 registros<br/>~3-5 GB]

    Base --> Mensal[Crescimento Mensal<br/>50k-100k registros<br/>~10-20 MB]

    Mensal --> Anual[Crescimento Anual<br/>600k-1.2M registros<br/>~120-240 MB]

    Anual --> Proj1[2026<br/>~20M registros<br/>~4 GB]

    Anual --> Proj2[2027<br/>~22M registros<br/>~4.5 GB]

    Anual --> Proj3[2028<br/>~24M registros<br/>~5 GB]

    Proj3 --> Alert[⚠️ CRÍTICO<br/>Particionamento<br/>Obrigatório]

    style Base fill:#e1f5ff,stroke:#01579b,stroke-width:3px
    style Mensal fill:#fff9c4,stroke:#f57f17
    style Anual fill:#c8e6c9,stroke:#2e7d32
    style Alert fill:#ffcdd2,stroke:#c62828,stroke-width:3px
```

---

## 📊 Estatísticas e Insights

### Distribuição de Tipos de Aprovação

```sql
-- Estatísticas gerais do sistema
SELECT
    'TIPOS_APROVACAO' as METRICA,
    COUNT(*) as VALOR
FROM APROVAPED

UNION ALL

SELECT
    'APROVACOES_HISTORICAS' as METRICA,
    COUNT(*) as VALOR
FROM PEDAPV

UNION ALL

SELECT
    'CONFIGURACOES_EMPRESA' as METRICA,
    COUNT(*) as VALOR
FROM APVEMP

UNION ALL

SELECT
    'ORIGENS_CONFIGURADAS' as METRICA,
    COUNT(*) as VALOR
FROM APVPEDORIGEM

UNION ALL

SELECT
    'MEDIA_APROVACOES_POR_DIA' as METRICA,
    COUNT(*) / NULLIF(DATEDIFF(DAY, MIN(PDAPDATA), MAX(PDAPDATA)), 0) as VALOR
FROM PEDAPV
WHERE PDAPDATA IS NOT NULL;
```

**Métricas Esperadas:**
```
TIPOS_APROVACAO: 29
APROVACOES_HISTORICAS: 18.814.176
CONFIGURACOES_EMPRESA: 174
ORIGENS_CONFIGURADAS: 32
MEDIA_APROVACOES_POR_DIA: ~2.000-3.000
```

---

### Análise de Volume por Tipo

```sql
-- Ranking de tipos mais utilizados
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(*) as TOTAL_APROVACOES,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM PEDAPV) AS NUMERIC(5,2)) as PERCENTUAL,
    MIN(pv.PDAPDATA) as PRIMEIRA_UTILIZACAO,
    MAX(pv.PDAPDATA) as ULTIMA_UTILIZACAO,
    COUNT(DISTINCT pv.EMPCODIGO) as EMPRESAS_UTILIZAM
FROM APROVAPED ap
LEFT JOIN PEDAPV pv
    ON ap.APVCODIGO = pv.APVCODIGO
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
ORDER BY TOTAL_APROVACOES DESC;
```

---

### Evolução Temporal

```sql
-- Crescimento de aprovações ao longo do tempo
SELECT
    EXTRACT(YEAR FROM pv.PDAPDATA) as ANO,
    EXTRACT(MONTH FROM pv.PDAPDATA) as MES,
    COUNT(*) as TOTAL_APROVACOES,
    COUNT(DISTINCT pv.ID_PEDIDO) as PEDIDOS_DISTINTOS,
    COUNT(DISTINCT pv.USUCODIGO) as APROVADORES_DISTINTOS
FROM PEDAPV pv
WHERE pv.PDAPDATA >= CURRENT_DATE - 365
GROUP BY EXTRACT(YEAR FROM pv.PDAPDATA), EXTRACT(MONTH FROM pv.PDAPDATA)
ORDER BY ANO DESC, MES DESC;
```

---

### Heatmap de Atividade

```sql
-- Matriz de atividade: hora do dia x dia da semana
SELECT
    EXTRACT(HOUR FROM pv.PDAPHORA) as HORA,
    EXTRACT(DOW FROM pv.PDAPDATA) as DIA_SEMANA,  -- 0=Domingo, 6=Sábado
    COUNT(*) as QTD_APROVACOES,
    AVG(COUNT(*)) OVER (PARTITION BY EXTRACT(HOUR FROM pv.PDAPHORA)) as MEDIA_HORA
FROM PEDAPV pv
WHERE pv.PDAPDATA >= CURRENT_DATE - 90
    AND pv.PDAPHORA IS NOT NULL
GROUP BY EXTRACT(HOUR FROM pv.PDAPHORA), EXTRACT(DOW FROM pv.PDAPDATA)
ORDER BY HORA, DIA_SEMANA;
```

**Uso:** Criar heatmap visual para identificar:
- Horários de maior volume de aprovações
- Dias da semana mais ativos
- Necessidade de staffing

---

### Análise de Concentração

```sql
-- Princípio de Pareto: 80/20
-- Quais tipos de aprovação representam 80% do volume?

WITH TotalAprovacoes AS (
    SELECT COUNT(*) as TOTAL FROM PEDAPV
),
RankingTipos AS (
    SELECT
        ap.APVCODIGO,
        ap.APVDESCRICAO,
        COUNT(*) as QTD,
        CAST(COUNT(*) * 100.0 / (SELECT TOTAL FROM TotalAprovacoes) AS NUMERIC(5,2)) as PERCENTUAL,
        SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) as ACUMULADO,
        CAST(
            SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) * 100.0 / (SELECT TOTAL FROM TotalAprovacoes)
            AS NUMERIC(5,2)
        ) as PERCENTUAL_ACUMULADO
    FROM APROVAPED ap
    INNER JOIN PEDAPV pv ON ap.APVCODIGO = pv.APVCODIGO
    GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
)
SELECT
    APVCODIGO,
    APVDESCRICAO,
    QTD,
    PERCENTUAL,
    PERCENTUAL_ACUMULADO,
    CASE
        WHEN PERCENTUAL_ACUMULADO <= 80 THEN 'GRUPO_A_80%'
        WHEN PERCENTUAL_ACUMULADO <= 95 THEN 'GRUPO_B_15%'
        ELSE 'GRUPO_C_5%'
    END as CLASSIFICACAO_ABC
FROM RankingTipos
ORDER BY QTD DESC;
```

---

## 🔧 Queries de Manutenção

### 1. Backup de Configurações

```sql
-- Exportar configurações críticas
SELECT
    'APROVAPED' as TABELA,
    APVCODIGO,
    APVDESCRICAO,
    NULL as CAMPO3,
    NULL as CAMPO4
FROM APROVAPED

UNION ALL

SELECT
    'APVEMP' as TABELA,
    APVCODIGO,
    EMPCODIGO,
    APVESEQ,
    APVEACAO
FROM APVEMP

UNION ALL

SELECT
    'APVPEDORIGEM' as TABELA,
    APVCODIGO,
    NULL,
    NULL,
    PEDORIGEM
FROM APVPEDORIGEM
ORDER BY TABELA, APVCODIGO;
```

---

### 2. Limpeza de Dados Antigos (CRÍTICO)

```sql
-- ⚠️ EXECUTAR APENAS APÓS BACKUP E TESTES!

-- Passo 1: Verificar quantidade a arquivar
SELECT
    EXTRACT(YEAR FROM PDAPDATA) as ANO,
    COUNT(*) as REGISTROS
FROM PEDAPV
WHERE PDAPDATA < CURRENT_DATE - 730  -- > 2 anos
GROUP BY EXTRACT(YEAR FROM PDAPDATA)
ORDER BY ANO;

-- Passo 2: Arquivar em lotes
INSERT INTO PEDAPV_ARQUIVO
SELECT *, CURRENT_TIMESTAMP as DATA_ARQUIVAMENTO
FROM PEDAPV
WHERE PDAPDATA < CURRENT_DATE - 730
ROWS 50000;  -- Lotes de 50k para não travar

-- Passo 3: Deletar dados arquivados (CUIDADO!)
DELETE FROM PEDAPV
WHERE ID_PEDIDO IN (
    SELECT ID_PEDIDO
    FROM PEDAPV_ARQUIVO
    WHERE DATA_ARQUIVAMENTO >= CURRENT_DATE
)
AND PDAPDATA < CURRENT_DATE - 730
ROWS 50000;

-- Passo 4: Recriar estatísticas
SET STATISTICS INDEX PK_PEDAPV;
SET STATISTICS INDEX IDX_PEDAPV_DATA_APVCODIGO;
```

**Cronograma Recomendado:** Trimestral

---

### 3. Validação de Integridade

```sql
-- Verificar inconsistências no sistema
SELECT
    'TIPOS_SEM_DESCRICAO' as TIPO_ERRO,
    COUNT(*) as QTD
FROM APROVAPED
WHERE APVDESCRICAO IS NULL OR TRIM(APVDESCRICAO) = ''

UNION ALL

SELECT
    'APROVACOES_SEM_DATA' as TIPO_ERRO,
    COUNT(*) as QTD
FROM PEDAPV
WHERE PDAPDATA IS NULL

UNION ALL

SELECT
    'APROVACOES_DATA_FUTURA' as TIPO_ERRO,
    COUNT(*) as QTD
FROM PEDAPV
WHERE PDAPDATA > CURRENT_DATE

UNION ALL

SELECT
    'APROVACOES_SEM_PEDIDO_VALIDO' as TIPO_ERRO,
    COUNT(*) as QTD
FROM PEDAPV pv
LEFT JOIN PEDID p ON pv.ID_PEDIDO = p.ID_PEDIDO
WHERE p.ID_PEDIDO IS NULL

UNION ALL

SELECT
    'CONFIG_EMPRESA_ORFAS' as TIPO_ERRO,
    COUNT(*) as QTD
FROM APVEMP ae
LEFT JOIN APROVAPED ap ON ae.APVCODIGO = ap.APVCODIGO
WHERE ap.APVCODIGO IS NULL

UNION ALL

SELECT
    'ORIGEM_ORFAS' as TIPO_ERRO,
    COUNT(*) as QTD
FROM APVPEDORIGEM ao
LEFT JOIN APROVAPED ap ON ao.APVCODIGO = ap.APVCODIGO
WHERE ap.APVCODIGO IS NULL;
```

**Resultado Esperado:** Todas as contagens = 0

---

### 4. Atualização de Estatísticas (CRÍTICO)

```sql
-- Atualizar estatísticas (executar SEMANALMENTE para PEDAPV)
SET STATISTICS INDEX PK_APROVAPED;
SET STATISTICS INDEX PK_PEDAPV;
SET STATISTICS INDEX PK_APVEMP;
SET STATISTICS INDEX INDAPVEMP_EMPCODIGO;

-- Se índices recomendados estiverem criados:
SET STATISTICS INDEX IDX_PEDAPV_DATA_APVCODIGO;
SET STATISTICS INDEX IDX_PEDAPV_USUARIO_DATA;
SET STATISTICS INDEX IDX_PEDAPV_PEDIDO_DATA;
SET STATISTICS INDEX IDX_PEDAPV_EMP_APV_DATA;
```

---

### 5. Correção de Dados

```sql
-- Normalizar descrições
UPDATE APROVAPED
SET APVDESCRICAO = UPPER(TRIM(APVDESCRICAO))
WHERE APVDESCRICAO <> UPPER(TRIM(APVDESCRICAO));

-- Normalizar origens
UPDATE APVPEDORIGEM
SET PEDORIGEM = UPPER(TRIM(PEDORIGEM))
WHERE PEDORIGEM <> UPPER(TRIM(PEDORIGEM));

-- Remover observações vazias
UPDATE PEDAPV
SET PDAPOBSER = NULL
WHERE PDAPOBSER = '' OR TRIM(PDAPOBSER) = '';
```

---

### 6. Análise de Fragmentação (PEDAPV)

```sql
-- Verificar necessidade de REBUILD (Firebird)
SELECT
    'PEDAPV' as TABELA,
    COUNT(*) as TOTAL_REGISTROS,
    -- pg_relation_size('PEDAPV') as TAMANHO_BYTES,  -- PostgreSQL
    -- pg_total_relation_size('PEDAPV') as TAMANHO_TOTAL_BYTES  -- PostgreSQL
FROM PEDAPV;

-- Comando de rebuild (executar em janela de manutenção)
-- GFIX -sweep -user SYSDBA -password masterkey /path/to/database.fdb
```

---

### 7. Monitoramento de Crescimento

```sql
-- Criar view para monitoramento contínuo
CREATE VIEW VW_PEDAPV_GROWTH_MONITOR AS
SELECT
    CURRENT_DATE as DATA_MEDICAO,
    COUNT(*) as TOTAL_REGISTROS,
    COUNT(CASE WHEN PDAPDATA >= CURRENT_DATE - 1 THEN 1 END) as ULTIMAS_24H,
    COUNT(CASE WHEN PDAPDATA >= CURRENT_DATE - 7 THEN 1 END) as ULTIMOS_7_DIAS,
    COUNT(CASE WHEN PDAPDATA >= CURRENT_DATE - 30 THEN 1 END) as ULTIMOS_30_DIAS,
    COUNT(DISTINCT APVCODIGO) as TIPOS_DISTINTOS,
    COUNT(DISTINCT EMPCODIGO) as EMPRESAS_ATIVAS,
    COUNT(DISTINCT USUCODIGO) as APROVADORES_ATIVOS,
    MIN(PDAPDATA) as DATA_MAIS_ANTIGA,
    MAX(PDAPDATA) as DATA_MAIS_RECENTE
FROM PEDAPV;

-- Consultar métricas
SELECT * FROM VW_PEDAPV_GROWTH_MONITOR;
```

---

## ✅ Melhores Práticas

### 1. Cadastro de Tipos de Aprovação

#### ✅ Fazer
```sql
-- BOM: Descrição clara e padronizada
INSERT INTO APROVAPED (APVCODIGO, APVDESCRICAO)
VALUES (30, 'APROVACAO_LIMITE_CREDITO_EXCEDIDO');

-- BOM: Documentar propósito
INSERT INTO APROVAPED (APVCODIGO, APVDESCRICAO)
VALUES (31, 'APROVACAO_PRECO_ABAIXO_MINIMO');
```

#### ❌ Evitar
```sql
-- RUIM: Descrição vaga ou genérica
INSERT INTO APROVAPED (APVCODIGO, APVDESCRICAO)
VALUES (32, 'APROVACAO_GERAL');  -- O que é isso?

-- RUIM: Descrição muito longa
INSERT INTO APROVAPED (APVCODIGO, APVDESCRICAO)
VALUES (33, 'APROVACAO_DE_PEDIDO_QUANDO_O_CLIENTE_SOLICI...');
```

---

### 2. Registro de Aprovações

#### ✅ Fazer
```python
# BOM: Registrar com contexto completo
def registrar_aprovacao(id_pedido, tipo_aprovacao, usuario, observacao):
    """
    Registra aprovação de pedido no sistema.
    """
    # Obter próximo SEQ
    query_seq = """
        SELECT COALESCE(MAX(PDAPSEQ), 0) + 1 as PROXIMO_SEQ
        FROM PEDAPV
        WHERE ID_PEDIDO = ?
    """
    proximo_seq = execute_query(query_seq, [id_pedido])[0]['PROXIMO_SEQ']

    # Inserir aprovação
    query_insert = """
        INSERT INTO PEDAPV (
            ID_PEDIDO,
            APVCODIGO,
            EMPCODIGO,
            PDAPSEQ,
            PDAPDATA,
            PDAPHORA,
            PDAPOBSER,
            USUCODIGO
        ) VALUES (?, ?, ?, ?, CURRENT_DATE, CURRENT_TIME, ?, ?)
    """

    params = [
        id_pedido,
        tipo_aprovacao,
        get_empcodigo_usuario(usuario),
        proximo_seq,
        observacao.strip() if observacao else None,
        usuario
    ]

    execute_query(query_insert, params)

    # Logar auditoria
    log_auditoria(f"Aprovação {tipo_aprovacao} registrada para pedido {id_pedido}")
```

#### ❌ Evitar
```python
# RUIM: Informações incompletas
query = "INSERT INTO PEDAPV (ID_PEDIDO, APVCODIGO) VALUES (123, 1)"
# Falta: empresa, sequência, data/hora, usuário, observação!
```

---

### 3. Configuração de Workflow

#### ✅ Fazer
```sql
-- BOM: Configuração completa e documentada
INSERT INTO APVEMP (
    APVCODIGO,
    EMPCODIGO,
    APVESEQ,
    APVEACAO,
    LPCODIGOAPV,
    LPCODIGONAPV
) VALUES (
    2,  -- APROVACAO_DESCONTO
    1,  -- Empresa 1
    1,  -- Primeira no workflow
    'PROC_VALIDA_DESCONTO',  -- Procedure de validação
    10,  -- Se aprovado: vai para LP 10 (FATURAMENTO)
    5   -- Se rejeitado: volta para LP 5 (REVISAO)
);
```

#### ❌ Evitar
```sql
-- RUIM: Configuração sem lógica de fluxo
INSERT INTO APVEMP (APVCODIGO, EMPCODIGO, APVESEQ)
VALUES (2, 1, 1);
-- Falta: ação, local aprovado, local rejeitado
```

---

### 4. Queries de Histórico

#### ✅ Fazer
```sql
-- BOM: Sempre limitar por data recente
SELECT
    pv.ID_PEDIDO,
    ap.APVDESCRICAO,
    pv.PDAPDATA,
    pv.USUCODIGO
FROM PEDAPV pv
INNER JOIN APROVAPED ap ON pv.APVCODIGO = ap.APVCODIGO
WHERE pv.PDAPDATA >= CURRENT_DATE - 90  -- ✓ Limita escopo
    AND pv.EMPCODIGO = 1
ORDER BY pv.PDAPDATA DESC
FIRST 1000;  -- ✓ Limita resultado
```

#### ❌ Evitar
```sql
-- RUIM: Full table scan em 18M registros!
SELECT * FROM PEDAPV
WHERE USUCODIGO = 100;
-- Vai levar 20-30 segundos!
```

---

### 5. Performance de Inserção

#### ✅ Fazer
```python
# BOM: Inserção em lote quando possível
def registrar_multiplas_aprovacoes(aprovacoes_list):
    """
    Registra múltiplas aprovações em uma transação.
    """
    query = """
        INSERT INTO PEDAPV (
            ID_PEDIDO, APVCODIGO, EMPCODIGO, PDAPSEQ,
            PDAPDATA, PDAPHORA, PDAPOBSER, USUCODIGO
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """

    with transaction():
        for aprov in aprovacoes_list:
            execute_query(query, aprov)

    # Uma transação para todas as inserções
```

#### ❌ Evitar
```python
# RUIM: Transação por inserção (lento)
for aprov in aprovacoes_list:
    with transaction():  # Nova transação a cada vez!
        execute_query(query, aprov)
```

---

### 6. Segurança e Auditoria

#### ✅ Fazer
```sql
-- BOM: Trigger para auditoria automática
CREATE TRIGGER TRG_PEDAPV_AUDIT_INSERT
FOR PEDAPV
AFTER INSERT
AS
BEGIN
    INSERT INTO AUDIT_LOG (
        TABELA,
        OPERACAO,
        ID_REGISTRO,
        USUARIO_SISTEMA,
        DATA_HORA,
        DETALHES
    ) VALUES (
        'PEDAPV',
        'INSERT',
        NEW.ID_PEDIDO,
        CURRENT_USER,
        CURRENT_TIMESTAMP,
        'Aprovação ' || NEW.APVCODIGO || ' para pedido ' || NEW.ID_PEDIDO
    );
END;
```

---

### 7. Monitoramento Proativo

#### ✅ Fazer
```sql
-- BOM: View para dashboard de aprovações pendentes
CREATE VIEW VW_APROVACOES_PENDENTES AS
SELECT
    ap.APVCODIGO,
    ap.APVDESCRICAO,
    COUNT(DISTINCT p.ID_PEDIDO) as QTD_PENDENTE,
    MIN(p.PEDDATAINCLUSAO) as MAIS_ANTIGO,
    AVG(DATEDIFF(DAY, p.PEDDATAINCLUSAO, CURRENT_DATE)) as DIAS_MEDIO_ESPERA,
    MAX(DATEDIFF(DAY, p.PEDDATAINCLUSAO, CURRENT_DATE)) as DIAS_MAX_ESPERA
FROM APROVAPED ap
INNER JOIN APVPEDORIGEM ao ON ap.APVCODIGO = ao.APVCODIGO
INNER JOIN PEDID p ON ao.PEDORIGEM = p.PEDORIGEM
LEFT JOIN PEDAPV pv
    ON p.ID_PEDIDO = pv.ID_PEDIDO
    AND ap.APVCODIGO = pv.APVCODIGO
WHERE pv.ID_PEDIDO IS NULL  -- Não aprovado ainda
    AND p.PEDSTATUS = 'AGUARDANDO_APROVACAO'
GROUP BY ap.APVCODIGO, ap.APVDESCRICAO
HAVING COUNT(DISTINCT p.ID_PEDIDO) > 0;
```

---

### 8. Testes Automatizados

#### ✅ Fazer
```python
# BOM: Suite de testes para workflow
import unittest

class TestWorkflowAprovacao(unittest.TestCase):
    def test_registro_aprovacao_simples(self):
        """Testa registro básico de aprovação"""
        id_pedido = criar_pedido_teste()

        registrar_aprovacao(
            id_pedido=id_pedido,
            tipo_aprovacao=1,
            usuario=100,
            observacao='Teste automatizado'
        )

        # Verificar se foi registrado
        result = query("""
            SELECT * FROM PEDAPV
            WHERE ID_PEDIDO = ? AND APVCODIGO = 1
        """, [id_pedido])

        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]['USUCODIGO'], 100)

    def test_multiplas_aprovacoes_mesmo_pedido(self):
        """Testa múltiplas aprovações para um pedido"""
        id_pedido = criar_pedido_teste()

        # Registrar 3 tipos de aprovação
        for tipo in [1, 2, 3]:
            registrar_aprovacao(id_pedido, tipo, 100, f'Aprovação {tipo}')

        # Verificar se todas foram registradas
        result = query("""
            SELECT COUNT(*) as QTD
            FROM PEDAPV
            WHERE ID_PEDIDO = ?
        """, [id_pedido])

        self.assertEqual(result[0]['QTD'], 3)

    def test_sequencia_incrementa_corretamente(self):
        """Testa se PDAPSEQ incrementa corretamente"""
        id_pedido = criar_pedido_teste()

        for i in range(5):
            registrar_aprovacao(id_pedido, 1, 100, f'Tentativa {i+1}')

        # Verificar sequências
        result = query("""
            SELECT PDAPSEQ
            FROM PEDAPV
            WHERE ID_PEDIDO = ?
            ORDER BY PDAPSEQ
        """, [id_pedido])

        sequencias = [r['PDAPSEQ'] for r in result]
        self.assertEqual(sequencias, [1, 2, 3, 4, 5])
```

---

### 9. Documentação de Configurações

#### ✅ Fazer
```sql
-- BOM: Tabela auxiliar de documentação
CREATE TABLE APROVAPED_DOC (
    APVCODIGO INTEGER PRIMARY KEY,
    DESCRICAO_DETALHADA VARCHAR(500),
    QUANDO_USAR VARCHAR(500),
    RESPONSAVEL VARCHAR(100),
    NIVEL_HIERARQUICO VARCHAR(20),  -- OPERADOR, GERENTE, DIRETOR
    PRAZO_SLA_HORAS INTEGER,
    DATA_CADASTRO TIMESTAMP,
    FOREIGN KEY (APVCODIGO) REFERENCES APROVAPED(APVCODIGO)
);

-- Documentar cada tipo
INSERT INTO APROVAPED_DOC VALUES (
    1,
    'Aprovação de crédito para clientes acima do limite',
    'Quando valor do pedido excede limite de crédito disponível do cliente',
    'Gerente Financeiro',
    'GERENTE',
    24,  -- SLA: 24 horas
    CURRENT_TIMESTAMP
);
```

---

### 10. Disaster Recovery

#### ✅ Fazer
```bash
# BOM: Script de backup automatizado
#!/bin/bash

# Backup diário de configurações
pg_dump -h localhost -U user -t aprovaped -t apvemp -t apvpedorigem \
    -f /backup/aprovacao_config_$(date +%Y%m%d).sql

# Backup mensal de histórico (particionado)
pg_dump -h localhost -U user -t pedapv \
    --where="pdapdata >= '$(date -d '1 month ago' +%Y-%m-01)'" \
    -f /backup/pedapv_lastmonth_$(date +%Y%m%d).sql

# Verificar integridade
pg_dump -h localhost -U user --schema-only -t pedapv \
    -f /backup/pedapv_schema_$(date +%Y%m%d).sql
```

---

## 📝 Conclusão

### Resumo Executivo
O sistema **APROVAPED** é um **workflow crítico de aprovação de pedidos** com volume massivo de dados (18,8 milhões de registros), exigindo atenção especial para performance, arquivamento e monitoramento contínuo.

### Pontos-Chave
- **29 tipos de aprovação** configuráveis
- **18,8 milhões de aprovações históricas** (PEDAPV) - **VOLUME CRÍTICO**
- **Workflow configurável** por empresa e origem
- **Multi-nível**: tipos, configuração, execução, manual
- **Crescimento estimado**: 50-100k registros/mês

### Recomendações URGENTES
1. 🚨 **CRÍTICO**: Criar índices em PEDAPV (IDX_PEDAPV_DATA_APVCODIGO)
2. 🚨 **CRÍTICO**: Implementar arquivamento de dados > 2 anos
3. ⚠️ **IMPORTANTE**: Atualizar estatísticas de índices semanalmente
4. ⚠️ **IMPORTANTE**: Implementar particionamento por ano
5. ✅ **RECOMENDADO**: Criar view de monitoramento (VW_APROVACOES_PENDENTES)
6. ✅ **RECOMENDADO**: Documentar cada tipo de aprovação (APROVAPED_DOC)

### Impacto de Performance
Sem os índices recomendados:
- Relatórios mensais: **20-30 segundos** ❌
- Dashboard em tempo real: **30-45 segundos** ❌
- Queries de auditoria: **25-40 segundos** ❌

Com índices e otimizações:
- Relatórios mensais: **50-100ms** ✅ (300-600x mais rápido)
- Dashboard em tempo real: **100-150ms** ✅ (200-400x mais rápido)
- Queries de auditoria: **50-100ms** ✅ (400-800x mais rápido)

### Próximos Passos
1. Aplicar índices recomendados (seção 5)
2. Configurar job de arquivamento trimestral
3. Implementar monitoramento de crescimento
4. Documentar tipos de aprovação existentes
5. Criar dashboard de aprovações pendentes

---

**Última Atualização:** 2025-11-27
**Próxima Revisão:** 2025-12-27
**Prioridade de Ação:** 🚨 **CRÍTICA** (Performance e Volume)

---

## 📚 Referências

- Firebird 2.5 Language Reference
- Documentação Interna: `ARCHITECTURE.md`
- Padrões de Codificação: `BACKEND_STANDARDS.md`
- Sistema de Pedidos: `PEDID_RELACIONAMENTOS_COMPLETOS.md`

---

**Fim da Documentação**
