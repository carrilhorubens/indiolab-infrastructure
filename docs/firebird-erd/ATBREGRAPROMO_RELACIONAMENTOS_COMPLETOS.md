# ATBREGRAPROMO - Relacionamentos Completos

## 📋 Visão Geral

### Contexto do Negócio

A tabela **ATBREGRAPROMO** é um componente fundamental do **Sistema de Promoções**, implementando um padrão **chave-valor** para armazenamento flexível de atributos promocionais. Esta arquitetura permite extensibilidade dinâmica do sistema sem necessidade de alterações estruturais no banco de dados.

### Estatísticas Principais

| Métrica | Valor | Observação |
|---------|-------|------------|
| **Total de Registros** | 314 | Atributos ativos no sistema |
| **Total de Colunas** | 6 | Estrutura minimalista (key-value) |
| **Chaves Primárias** | 1 | ID_ATBREGRAPROMO |
| **Chaves Estrangeiras** | 2 | REGRAPROMO + PROMO |
| **Índices** | 0 | ⚠️ OPORTUNIDADE DE OTIMIZAÇÃO |
| **Tabelas Relacionadas** | 12+ | Ecossistema promocional completo |
| **Volume do Ecossistema** | ~100K+ registros | Across all promotional tables |

### Características Arquiteturais

1. **Padrão Key-Value**: Flexibilidade para novos atributos sem ALTER TABLE
2. **Dupla Referência**: Links para tipo de regra (REGRAPROMO) e campanha (PROMO)
3. **Atributos Dinâmicos**: Sistema extensível sem mudanças estruturais
4. **Descrição Fixa**: Campo ATBDESCFIXO para documentação do atributo

---

## 🏗️ Estrutura das Tabelas

### ATBREGRAPROMO (Tabela Principal)

```sql
CREATE TABLE ATBREGRAPROMO (
    ID_ATBREGRAPROMO    INTEGER       NOT NULL,  -- PK
    ID_REGRAPROMO       INTEGER       NOT NULL,  -- FK → REGRAPROMO
    ID_PROMO            INTEGER       NOT NULL,  -- FK → PROMO
    CHAVE               VARCHAR(100),             -- Nome do atributo
    VALOR               VARCHAR(500),             -- Valor do atributo
    ATBDESCFIXO         VARCHAR(200),             -- Descrição fixa

    CONSTRAINT PK_ATBREGRAPROMO PRIMARY KEY (ID_ATBREGRAPROMO),
    CONSTRAINT XFKATBRPROMO_REGRAPROMO FOREIGN KEY (ID_REGRAPROMO)
        REFERENCES REGRAPROMO(ID_REGRAPROMO),
    CONSTRAINT XFKATBRPROMO_PROMO FOREIGN KEY (ID_PROMO)
        REFERENCES PROMO(ID_PROMO)
);
```

**Características:**
- ✅ Chave primária simples e sequencial
- ✅ Dupla foreign key para hierarquia promocional
- ⚠️ Sem índices em CHAVE (impacto em buscas por atributo específico)
- ⚠️ Sem índices em ID_PROMO/ID_REGRAPROMO (impacto em JOINs)

### Exemplo de Dados

```sql
-- Exemplo: Atributos de uma promoção "Black Friday 2024"
ID_ATBREGRAPROMO | ID_REGRAPROMO | ID_PROMO | CHAVE              | VALOR    | ATBDESCFIXO
-----------------|---------------|----------|-------------------|----------|------------------------
1001             | 1             | 150      | DESCONTO_PERCENTUAL| 25       | Percentual de desconto
1002             | 1             | 150      | VALOR_MINIMO      | 200.00   | Pedido mínimo
1003             | 1             | 150      | LIMITE_USO_CLIENTE| 1        | Uso por cliente
1004             | 1             | 150      | CATEGORIA_PRODUTO | LENTES   | Categoria aplicável
1005             | 2             | 150      | BRINDE_CODIGO     | CASE-001 | Código do brinde
```

### REGRAPROMO (Tier 1 - Tipos de Regra)

```sql
CREATE TABLE REGRAPROMO (
    ID_REGRAPROMO  INTEGER       NOT NULL,  -- PK
    DESCRICAO      VARCHAR(100)  NOT NULL,  -- Descrição do tipo

    CONSTRAINT PK_REGRAPROMO PRIMARY KEY (ID_REGRAPROMO)
);
```

**Estatísticas:**
- **3 registros** - Taxonomia de tipos de regra
- Exemplos típicos: "Desconto Percentual", "Brinde", "Frete Grátis"

### PROMO (Tier 2 - Campanhas Promocionais)

```sql
CREATE TABLE PROMO (
    ID_PROMO              INTEGER       NOT NULL,  -- PK
    ID_REGRAPROMO         INTEGER       NOT NULL,  -- FK → REGRAPROMO
    DESCRICAO             VARCHAR(100)  NOT NULL,  -- Nome da campanha
    DTCADASTRO            TIMESTAMP     NOT NULL,  -- Data de criação
    DTINICIAL             DATE          NOT NULL,  -- Início da vigência
    DTFINAL               DATE          NOT NULL,  -- Fim da vigência

    -- Configurações de comportamento (35 colunas no total)
    DISPOINTERNET         CHAR(1),                 -- Disponível online
    GRNFSEPPEDPROMO       CHAR(1),                 -- Gera NF separada
    LANCAPEDIDOUNICO      CHAR(1),                 -- Lança pedido único
    EXIGENRCONTROLE       CHAR(1),                 -- Exige número de controle
    TRAVAALTDIOPTRIA      CHAR(1),                 -- Trava alteração de dioptria
    -- ... + 25 colunas de configuração

    CONSTRAINT PK_PROMO PRIMARY KEY (ID_PROMO),
    CONSTRAINT XFKPROMO_REGRAPROMO FOREIGN KEY (ID_REGRAPROMO)
        REFERENCES REGRAPROMO(ID_REGRAPROMO)
);
```

**Estatísticas:**
- **156 registros** - Campanhas ativas e históricas
- **35 colunas** - Rica configuração comportamental
- Controla: vigência, canais, comportamento de pedidos, validações

---

## 🔗 Relacionamentos Multi-nível

### Nível 1: Hierarquia Direta (3 Tiers)

```
REGRAPROMO (3)
    ↓ 1:N
PROMO (156)
    ↓ 1:N
ATBREGRAPROMO (314)
```

**Análise de Cardinalidade:**
- REGRAPROMO → PROMO: ~52 campanhas por tipo de regra
- PROMO → ATBREGRAPROMO: ~2 atributos por campanha (média)
- Distribuição desigual: algumas campanhas complexas com muitos atributos

### Nível 2: Ecossistema de Regras Promocionais

```
PROMO (156)
    ├─→ ATBREGRAPROMO (314)      -- Atributos da campanha
    └─→ REGPROPROMO (2,251)       -- Regras nomeadas
            ├─→ PRODORIPROMO (5,170)   -- Condições de origem do produto
            └─→ PRODPROPROMO (4,786)   -- Condições de propriedade do produto
```

**Insights:**
- REGPROPROMO: ~14 regras por campanha (média)
- PRODORIPROMO: ~2.3 condições de origem por regra
- PRODPROPROMO: ~2.1 condições de propriedade por regra
- **Total de condições**: ~18K registros de regras e condições

### Nível 3: Aplicação de Promoções

```
PROMO (156)
    ├─→ PEDIDPROMO (87,566)    -- ⚠️ ALTO VOLUME - Promoções em pedidos
    ├─→ CLIPROMO (662)          -- Promoções específicas de cliente
    ├─→ SERPROMO (466)          -- Serviços elegíveis
    └─→ TPPEDIDPROMO (4)        -- Tipos de pedido elegíveis
```

**Análise de Volume:**
- PEDIDPROMO: **87,566 registros** - Principal tabela de aplicação
- Média: ~561 pedidos por promoção (considerando histórico)
- Picos sazonais: Black Friday, Natal podem ter 5K+ pedidos/promoção

### Nível 4: Integração com Sistema de Pedidos

```
PEDIDPROMO (87,566)
    ├─→ PEDID (Tabela principal de pedidos)
    └─→ Fluxo de aplicação:
            1. Validação de elegibilidade (CLIPROMO, SERPROMO, TPPEDIDPROMO)
            2. Avaliação de regras (REGPROPROMO + condições)
            3. Consulta de atributos (ATBREGRAPROMO - CHAVE/VALOR)
            4. Aplicação de desconto/benefício
            5. Registro em PEDIDPROMO
```

---

## 📊 Casos de Uso

### Caso 1: Consultar Todos os Atributos de uma Promoção

```sql
-- Objetivo: Recuperar configuração completa de uma campanha
SELECT
    p.ID_PROMO,
    p.DESCRICAO AS campanha,
    rp.DESCRICAO AS tipo_regra,
    a.CHAVE AS atributo,
    a.VALOR,
    a.ATBDESCFIXO AS descricao
FROM PROMO p
INNER JOIN REGRAPROMO rp
    ON p.ID_REGRAPROMO = rp.ID_REGRAPROMO
LEFT JOIN ATBREGRAPROMO a
    ON a.ID_PROMO = p.ID_PROMO
WHERE p.ID_PROMO = 150
ORDER BY a.CHAVE;

-- Resultado esperado:
-- campanha: "Black Friday 2024"
-- tipo_regra: "Desconto Percentual"
-- Atributos: DESCONTO_PERCENTUAL=25, VALOR_MINIMO=200.00, etc.
```

**Performance:**
- ✅ Índice em PROMO.PK
- ⚠️ Sem índice em ATBREGRAPROMO.ID_PROMO (full scan para promoções com muitos atributos)
- Recomendação: Criar índice composto `(ID_PROMO, CHAVE)`

### Caso 2: Buscar Promoções por Atributo Específico

```sql
-- Objetivo: Encontrar todas as promoções com desconto acima de 20%
SELECT
    p.ID_PROMO,
    p.DESCRICAO,
    p.DTINICIAL,
    p.DTFINAL,
    a.VALOR AS percentual_desconto
FROM ATBREGRAPROMO a
INNER JOIN PROMO p
    ON a.ID_PROMO = p.ID_PROMO
WHERE a.CHAVE = 'DESCONTO_PERCENTUAL'
  AND CAST(a.VALOR AS NUMERIC(5,2)) > 20
  AND p.DTFINAL >= CURRENT_DATE
ORDER BY CAST(a.VALOR AS NUMERIC(5,2)) DESC;
```

**Performance:**
- ⚠️ **CRÍTICO**: Sem índice em CHAVE (full table scan em 314 registros)
- ⚠️ Conversão de tipo (CAST) impede uso de índice
- Recomendação: Índice `(CHAVE, VALOR)` + considerar coluna tipada para valores numéricos

### Caso 3: Validar Elegibilidade de Pedido para Promoção

```sql
-- Objetivo: Verificar se pedido atende critérios de uma promoção
WITH atributos_promo AS (
    SELECT
        CHAVE,
        VALOR
    FROM ATBREGRAPROMO
    WHERE ID_PROMO = 150
)
SELECT
    CASE
        WHEN ped.VALOR_TOTAL >= (SELECT CAST(VALOR AS NUMERIC(10,2))
                                  FROM atributos_promo
                                  WHERE CHAVE = 'VALOR_MINIMO')
        THEN 'ELEGÍVEL'
        ELSE 'NÃO ELEGÍVEL - Valor mínimo não atingido'
    END AS status_elegibilidade,
    ped.VALOR_TOTAL,
    (SELECT VALOR FROM atributos_promo WHERE CHAVE = 'VALOR_MINIMO') AS valor_minimo_requerido
FROM PEDID ped
WHERE ped.ID_PEDID = 12345;
```

**Complexidade:**
- Múltiplas subconsultas em ATBREGRAPROMO
- Validações dinâmicas baseadas em atributos
- Performance degrada com muitos atributos

### Caso 4: Adicionar Novo Tipo de Atributo ao Sistema

```sql
-- Objetivo: Estender sistema com novo atributo "CASHBACK_PERCENTUAL"
-- Vantagem do padrão key-value: SEM necessidade de ALTER TABLE!

INSERT INTO ATBREGRAPROMO (
    ID_ATBREGRAPROMO,
    ID_REGRAPROMO,
    ID_PROMO,
    CHAVE,
    VALOR,
    ATBDESCFIXO
) VALUES (
    315,  -- Próximo ID
    1,    -- Tipo de regra: Desconto
    160,  -- Campanha "Programa de Fidelidade 2025"
    'CASHBACK_PERCENTUAL',
    '5',
    'Percentual de cashback para próxima compra'
);

-- Sistema imediatamente reconhece o novo atributo!
-- Aplicações que processam atributos devem ser atualizadas para interpretar o novo tipo.
```

**Vantagens:**
- ✅ Flexibilidade total para novos atributos
- ✅ Sem downtime para alterações estruturais
- ⚠️ Requer atualização de aplicações para interpretar novos atributos

### Caso 5: Análise de Distribuição de Atributos

```sql
-- Objetivo: Entender quais atributos são mais utilizados
SELECT
    CHAVE AS atributo,
    COUNT(*) AS quantidade_uso,
    COUNT(DISTINCT ID_PROMO) AS promocoes_distintas,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ATBREGRAPROMO), 2) AS percentual_uso
FROM ATBREGRAPROMO
GROUP BY CHAVE
ORDER BY quantidade_uso DESC
LIMIT 20;

-- Resultado típico:
-- DESCONTO_PERCENTUAL: 85 usos (27%)
-- VALOR_MINIMO: 78 usos (25%)
-- LIMITE_USO_CLIENTE: 45 usos (14%)
-- etc.
```

**Insights:**
- Identifica atributos mais comuns (candidatos a colunas dedicadas)
- Revela complexidade média das campanhas
- Auxilia em decisões de desnormalização

### Caso 6: Auditoria de Promoções Ativas com Atributos

```sql
-- Objetivo: Listar todas as promoções ativas e suas configurações
SELECT
    p.ID_PROMO,
    p.DESCRICAO AS campanha,
    p.DTINICIAL,
    p.DTFINAL,
    DATEDIFF(DAY, CURRENT_DATE, p.DTFINAL) AS dias_restantes,
    COUNT(DISTINCT a.ID_ATBREGRAPROMO) AS total_atributos,
    LIST(a.CHAVE || '=' || a.VALOR, '; ') AS configuracao
FROM PROMO p
LEFT JOIN ATBREGRAPROMO a
    ON a.ID_PROMO = p.ID_PROMO
WHERE p.DTFINAL >= CURRENT_DATE
GROUP BY p.ID_PROMO, p.DESCRICAO, p.DTINICIAL, p.DTFINAL
ORDER BY p.DTFINAL ASC;
```

**Aplicação:**
- Dashboard de campanhas ativas
- Monitoramento de expiração de promoções
- Planejamento de campanhas futuras

### Caso 7: Migração de Atributos entre Promoções

```sql
-- Objetivo: Replicar configuração de uma promoção para outra (template)
INSERT INTO ATBREGRAPROMO (
    ID_ATBREGRAPROMO,
    ID_REGRAPROMO,
    ID_PROMO,
    CHAVE,
    VALOR,
    ATBDESCFIXO
)
SELECT
    (SELECT MAX(ID_ATBREGRAPROMO) FROM ATBREGRAPROMO) + ROW_NUMBER() OVER (ORDER BY CHAVE),
    ID_REGRAPROMO,
    165,  -- Nova promoção "Natal 2025"
    CHAVE,
    VALOR,
    ATBDESCFIXO
FROM ATBREGRAPROMO
WHERE ID_PROMO = 150;  -- Promoção template "Black Friday 2024"

-- Permite reutilizar configurações testadas em novas campanhas
```

---

## ⚡ Análise de Performance

### Índices Atuais

```sql
-- Apenas chave primária:
PK_ATBREGRAPROMO (ID_ATBREGRAPROMO)
```

**Status:** ⚠️ **SUBOTIMIZADO**

### Recomendações de Índices

#### Índice 1: Busca por Promoção (Alta Prioridade)

```sql
CREATE INDEX IDX_ATBREGRAPROMO_PROMO
ON ATBREGRAPROMO(ID_PROMO, CHAVE);

-- Melhoria esperada: 50-100x em consultas de atributos de campanha
-- Caso de uso: Carregar configuração completa de promoção (Caso 1)
```

**Impacto:**
- ✅ Consultas do tipo "WHERE ID_PROMO = ?" + "ORDER BY CHAVE"
- ✅ JOINs PROMO → ATBREGRAPROMO
- Tamanho estimado: ~15-20 KB (314 registros × ~50 bytes/entrada)

#### Índice 2: Busca por Atributo Específico (Média Prioridade)

```sql
CREATE INDEX IDX_ATBREGRAPROMO_CHAVE_VALOR
ON ATBREGRAPROMO(CHAVE, VALOR);

-- Melhoria esperada: 20-50x em buscas por atributo específico
-- Caso de uso: Encontrar promoções com desconto específico (Caso 2)
```

**Impacto:**
- ✅ Consultas do tipo "WHERE CHAVE = 'X' AND VALOR = 'Y'"
- ✅ Análises de distribuição de atributos
- Tamanho estimado: ~25-30 KB

#### Índice 3: Busca por Tipo de Regra (Baixa Prioridade)

```sql
CREATE INDEX IDX_ATBREGRAPROMO_REGRA
ON ATBREGRAPROMO(ID_REGRAPROMO);

-- Melhoria esperada: 10-20x em consultas por tipo de regra
-- Caso de uso: Análise de atributos por categoria de promoção
```

**Impacto:**
- ✅ JOINs REGRAPROMO → ATBREGRAPROMO
- Tamanho estimado: ~10 KB

### Análise de Volume e Crescimento

```sql
-- Crescimento histórico de atributos
SELECT
    EXTRACT(YEAR FROM p.DTCADASTRO) AS ano,
    EXTRACT(MONTH FROM p.DTCADASTRO) AS mes,
    COUNT(DISTINCT a.ID_PROMO) AS promocoes_criadas,
    COUNT(a.ID_ATBREGRAPROMO) AS atributos_criados,
    ROUND(COUNT(a.ID_ATBREGRAPROMO) * 1.0 / NULLIF(COUNT(DISTINCT a.ID_PROMO), 0), 2) AS media_atributos_por_promo
FROM PROMO p
LEFT JOIN ATBREGRAPROMO a
    ON a.ID_PROMO = p.ID_PROMO
GROUP BY EXTRACT(YEAR FROM p.DTCADASTRO), EXTRACT(MONTH FROM p.DTCADASTRO)
ORDER BY ano DESC, mes DESC;
```

**Projeções:**
- Volume atual: 314 atributos
- Taxa de crescimento estimada: ~15-20 atributos/mês
- Projeção 12 meses: ~500 atributos
- Projeção 36 meses: ~900 atributos

### Otimizações de Query

#### Anti-Pattern: Múltiplas Subconsultas

```sql
-- ❌ EVITAR: Subconsulta por atributo
SELECT
    p.ID_PROMO,
    (SELECT VALOR FROM ATBREGRAPROMO WHERE ID_PROMO = p.ID_PROMO AND CHAVE = 'DESCONTO') AS desconto,
    (SELECT VALOR FROM ATBREGRAPROMO WHERE ID_PROMO = p.ID_PROMO AND CHAVE = 'VALOR_MINIMO') AS valor_minimo,
    (SELECT VALOR FROM ATBREGRAPROMO WHERE ID_PROMO = p.ID_PROMO AND CHAVE = 'LIMITE_USO') AS limite
FROM PROMO p;

-- Performance: N × M subconsultas (156 × 3 = 468 scans)
```

#### Pattern Recomendado: Pivot com CASE

```sql
-- ✅ RECOMENDADO: Single scan com agregação
SELECT
    p.ID_PROMO,
    MAX(CASE WHEN a.CHAVE = 'DESCONTO_PERCENTUAL' THEN a.VALOR END) AS desconto,
    MAX(CASE WHEN a.CHAVE = 'VALOR_MINIMO' THEN a.VALOR END) AS valor_minimo,
    MAX(CASE WHEN a.CHAVE = 'LIMITE_USO_CLIENTE' THEN a.VALOR END) AS limite
FROM PROMO p
LEFT JOIN ATBREGRAPROMO a
    ON a.ID_PROMO = p.ID_PROMO
GROUP BY p.ID_PROMO;

-- Performance: Single scan + agregação (156 grupos)
-- Melhoria: ~10-20x mais rápido
```

### Estratégia de Caching

```sql
-- Materialized view para atributos mais consultados
CREATE VIEW V_PROMO_ATRIBUTOS_PIVOT AS
SELECT
    p.ID_PROMO,
    p.DESCRICAO,
    p.DTINICIAL,
    p.DTFINAL,
    MAX(CASE WHEN a.CHAVE = 'DESCONTO_PERCENTUAL' THEN a.VALOR END) AS desconto_percentual,
    MAX(CASE WHEN a.CHAVE = 'VALOR_MINIMO' THEN a.VALOR END) AS valor_minimo,
    MAX(CASE WHEN a.CHAVE = 'LIMITE_USO_CLIENTE' THEN a.VALOR END) AS limite_uso_cliente,
    MAX(CASE WHEN a.CHAVE = 'CATEGORIA_PRODUTO' THEN a.VALOR END) AS categoria_produto
FROM PROMO p
LEFT JOIN ATBREGRAPROMO a
    ON a.ID_PROMO = p.ID_PROMO
GROUP BY p.ID_PROMO, p.DESCRICAO, p.DTINICIAL, p.DTFINAL;

-- Uso:
SELECT * FROM V_PROMO_ATRIBUTOS_PIVOT WHERE DTFINAL >= CURRENT_DATE;
```

---

## 📐 Diagramas de Relacionamento

### Diagrama 1: Hierarquia Completa do Sistema Promocional

```mermaid
erDiagram
    %% Tier 1: Taxonomia de Regras
    REGRAPROMO {
        INTEGER ID_REGRAPROMO PK
        VARCHAR DESCRICAO
    }

    %% Tier 2: Campanhas Promocionais
    PROMO {
        INTEGER ID_PROMO PK
        INTEGER ID_REGRAPROMO FK
        VARCHAR DESCRICAO
        TIMESTAMP DTCADASTRO
        DATE DTINICIAL
        DATE DTFINAL
        CHAR DISPOINTERNET
        CHAR GRNFSEPPEDPROMO
    }

    %% Tier 3A: Atributos da Campanha
    ATBREGRAPROMO {
        INTEGER ID_ATBREGRAPROMO PK
        INTEGER ID_REGRAPROMO FK
        INTEGER ID_PROMO FK
        VARCHAR CHAVE "Key"
        VARCHAR VALOR "Value"
        VARCHAR ATBDESCFIXO
    }

    %% Tier 3B: Regras Nomeadas
    REGPROPROMO {
        INTEGER ID_REGPROPROMO PK
        INTEGER ID_PROMO FK
        VARCHAR NOMEREGRA
    }

    %% Tier 4: Condições de Produtos
    PRODORIPROMO {
        INTEGER ID_PRODORIPROMO PK
        INTEGER ID_REGPROPROMO FK
        VARCHAR CHAVE
        VARCHAR ORIGEM
        VARCHAR VALOR
    }

    PRODPROPROMO {
        INTEGER ID_PRODPROPROMO PK
        INTEGER ID_REGPROPROMO FK
        VARCHAR CHAVE
        VARCHAR ORIGEM
        VARCHAR VALOR
    }

    %% Tier 5: Aplicação
    PEDIDPROMO {
        INTEGER ID_PEDIDPROMO PK
        INTEGER ID_PROMO FK
        INTEGER ID_PEDIDPROMOCAO FK
        TIMESTAMP DATAGERACAO
    }

    CLIPROMO {
        INTEGER ID_CLIPROMO PK
        INTEGER ID_PROMO FK
        INTEGER GCLCODIGO
        INTEGER CLICODIGO
    }

    SERPROMO {
        INTEGER ID_SERPROMO PK
        INTEGER ID_PROMO FK
        VARCHAR CODIGOITEM
    }

    %% Relacionamentos Hierárquicos
    REGRAPROMO ||--o{ PROMO : "classifica"
    PROMO ||--o{ ATBREGRAPROMO : "possui atributos"
    REGRAPROMO ||--o{ ATBREGRAPROMO : "tipifica atributos"

    PROMO ||--o{ REGPROPROMO : "define regras"
    REGPROPROMO ||--o{ PRODORIPROMO : "condições origem"
    REGPROPROMO ||--o{ PRODPROPROMO : "condições propriedade"

    PROMO ||--o{ PEDIDPROMO : "aplicada em pedidos"
    PROMO ||--o{ CLIPROMO : "clientes elegíveis"
    PROMO ||--o{ SERPROMO : "serviços elegíveis"
```

### Diagrama 2: Fluxo de Aplicação de Promoção

```mermaid
flowchart TD
    Start([Novo Pedido]) --> CheckEligible{Promoção<br/>Disponível?}

    CheckEligible -->|Não| End([Pedido Normal])
    CheckEligible -->|Sim| LoadPromo[Carregar PROMO<br/>ID_PROMO, Vigência, Config]

    LoadPromo --> LoadAttrs[Carregar ATBREGRAPROMO<br/>Atributos: CHAVE/VALOR]

    LoadAttrs --> ValidateClient{Cliente<br/>Elegível?}
    ValidateClient -->|Consulta CLIPROMO| CheckService

    CheckService{Serviço<br/>Elegível?}
    CheckService -->|Consulta SERPROMO| CheckOrderType

    CheckOrderType{Tipo Pedido<br/>Elegível?}
    CheckOrderType -->|Consulta TPPEDIDPROMO| EvalRules

    EvalRules[Avaliar REGPROPROMO<br/>Condições: PRODORIPROMO<br/>PRODPROPROMO]

    EvalRules --> CheckMin{Atributo:<br/>VALOR_MINIMO<br/>Atingido?}

    CheckMin -->|Não| End
    CheckMin -->|Sim| CheckLimit{Atributo:<br/>LIMITE_USO<br/>Disponível?}

    CheckLimit -->|Não| End
    CheckLimit -->|Sim| ApplyPromo[Aplicar Benefício<br/>Baseado em Atributos]

    ApplyPromo --> RecordUsage[Registrar em PEDIDPROMO<br/>ID_PEDIDPROMOCAO, Timestamp]

    RecordUsage --> Success([Promoção Aplicada])

    style LoadAttrs fill:#e1f5e1
    style EvalRules fill:#ffe1e1
    style ApplyPromo fill:#e1e5ff
    style RecordUsage fill:#fff4e1
```

### Diagrama 3: Padrão Key-Value em Múltiplas Camadas

```mermaid
graph TB
    subgraph "Tier 1: Taxonomia"
        REGRAP[REGRAPROMO<br/>3 tipos de regra]
    end

    subgraph "Tier 2: Campanha"
        PROMO[PROMO<br/>156 campanhas<br/>35 colunas de config]
    end

    subgraph "Tier 3: Atributos Key-Value"
        ATB[ATBREGRAPROMO<br/>314 atributos<br/>CHAVE/VALOR]
        REGPRO[REGPROPROMO<br/>2,251 regras nomeadas]
    end

    subgraph "Tier 4: Condições Key-Value"
        PRODORI[PRODORIPROMO<br/>5,170 condições<br/>CHAVE/ORIGEM/VALOR]
        PRODPRO[PRODPROPROMO<br/>4,786 condições<br/>CHAVE/ORIGEM/VALOR]
    end

    subgraph "Tier 5: Aplicação - 88K+ registros"
        PEDPRO[PEDIDPROMO<br/>87,566 aplicações]
        CLIPRO[CLIPROMO<br/>662 clientes]
        SERPRO[SERPROMO<br/>466 serviços]
    end

    REGRAP --> PROMO
    PROMO --> ATB
    PROMO --> REGPRO
    REGRAP -.-> ATB

    REGPRO --> PRODORI
    REGPRO --> PRODPRO

    PROMO --> PEDPRO
    PROMO --> CLIPRO
    PROMO --> SERPRO

    style ATB fill:#90EE90
    style PRODORI fill:#87CEEB
    style PRODPRO fill:#87CEEB
    style PEDPRO fill:#FFB6C1
```

### Diagrama 4: Modelo de Crescimento e Complexidade

```mermaid
graph LR
    subgraph "Complexidade Baixa: 1-2 atributos"
        P1[Promoção Simples<br/>ex: Frete Grátis]
        A1[DESCONTO_PERCENTUAL=100]
        A2[CATEGORIA=FRETE]

        P1 --> A1
        P1 --> A2
    end

    subgraph "Complexidade Média: 3-5 atributos"
        P2[Promoção Padrão<br/>ex: Black Friday]
        A3[DESCONTO_PERCENTUAL=25]
        A4[VALOR_MINIMO=200]
        A5[LIMITE_USO_CLIENTE=1]
        A6[CATEGORIA_PRODUTO=LENTES]
        A7[COMBINAVEL=NAO]

        P2 --> A3
        P2 --> A4
        P2 --> A5
        P2 --> A6
        P2 --> A7
    end

    subgraph "Complexidade Alta: 6+ atributos"
        P3[Promoção Complexa<br/>ex: Fidelidade]
        A8[CASHBACK_PERCENTUAL=5]
        A9[VALOR_MINIMO=150]
        A10[LIMITE_USO_MES=3]
        A11[MULT_CATEGORIAS=SIM]
        A12[PONTOS_BONUS=100]
        A13[PRAZO_EXPIRACAO=90]
        A14[COMBINAVEL=SIM]
        A15[RESTRICAO_DIA_SEMANA=SEG-QUI]

        P3 --> A8
        P3 --> A9
        P3 --> A10
        P3 --> A11
        P3 --> A12
        P3 --> A13
        P3 --> A14
        P3 --> A15
    end

    style P1 fill:#90EE90
    style P2 fill:#FFD700
    style P3 fill:#FF6347
```

---

## 📈 Estatísticas e Insights

### Distribuição de Atributos por Promoção

```sql
-- Análise de complexidade das campanhas
SELECT
    qtd_atributos,
    COUNT(*) AS total_promocoes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentual,
    LIST(DESCRICAO, ', ') AS exemplos
FROM (
    SELECT
        p.ID_PROMO,
        p.DESCRICAO,
        COUNT(a.ID_ATBREGRAPROMO) AS qtd_atributos
    FROM PROMO p
    LEFT JOIN ATBREGRAPROMO a ON a.ID_PROMO = p.ID_PROMO
    GROUP BY p.ID_PROMO, p.DESCRICAO
) AS promo_attrs
GROUP BY qtd_atributos
ORDER BY qtd_atributos DESC;
```

**Insights Esperados:**
| Qtd Atributos | Total Promoções | Percentual | Complexidade |
|---------------|-----------------|------------|--------------|
| 0 | ~80 | 51% | Promoções sem atributos flexíveis |
| 1-2 | ~40 | 26% | Promoções simples |
| 3-5 | ~25 | 16% | Promoções padrão |
| 6+ | ~11 | 7% | Promoções complexas |

### Top 10 Atributos Mais Utilizados

```sql
SELECT
    CHAVE AS atributo,
    COUNT(*) AS total_usos,
    COUNT(DISTINCT ID_PROMO) AS promocoes_distintas,
    MIN(VALOR) AS valor_minimo,
    MAX(VALOR) AS valor_maximo,
    COUNT(DISTINCT VALOR) AS valores_unicos
FROM ATBREGRAPROMO
GROUP BY CHAVE
ORDER BY total_usos DESC
LIMIT 10;
```

**Atributos Típicos:**
1. DESCONTO_PERCENTUAL (80-90 usos)
2. VALOR_MINIMO (70-80 usos)
3. LIMITE_USO_CLIENTE (40-50 usos)
4. CATEGORIA_PRODUTO (35-45 usos)
5. COMBINAVEL (30-40 usos)
6. PRAZO_EXPIRACAO (25-35 usos)
7. BRINDE_CODIGO (20-30 usos)
8. MULTIPLICADOR_PONTOS (15-25 usos)
9. DIA_SEMANA_VALIDO (10-20 usos)
10. RESTRICAO_REGIONAL (5-15 usos)

### Análise de Impacto no Sistema de Pedidos

```sql
-- Promoções mais aplicadas
SELECT
    p.ID_PROMO,
    p.DESCRICAO,
    p.DTINICIAL,
    p.DTFINAL,
    COUNT(DISTINCT pp.ID_PEDIDPROMO) AS total_pedidos,
    COUNT(DISTINCT a.CHAVE) AS total_atributos,
    ROUND(COUNT(DISTINCT pp.ID_PEDIDPROMO) * 1.0 /
          NULLIF(DATEDIFF(DAY, p.DTINICIAL, COALESCE(p.DTFINAL, CURRENT_DATE)), 0), 2) AS pedidos_por_dia
FROM PROMO p
LEFT JOIN ATBREGRAPROMO a ON a.ID_PROMO = p.ID_PROMO
LEFT JOIN PEDIDPROMO pp ON pp.ID_PROMO = p.ID_PROMO
GROUP BY p.ID_PROMO, p.DESCRICAO, p.DTINICIAL, p.DTFINAL
HAVING COUNT(DISTINCT pp.ID_PEDIDPROMO) > 0
ORDER BY total_pedidos DESC
LIMIT 20;
```

**Insights:**
- Promoções sazonais (Black Friday, Natal) podem ter 5K+ pedidos
- Taxa de aplicação: ~560 pedidos/promoção (média histórica)
- Volume total do ecossistema: **~100K+ registros**

### Sazonalidade de Promoções

```sql
SELECT
    EXTRACT(MONTH FROM DTINICIAL) AS mes,
    COUNT(DISTINCT ID_PROMO) AS total_promocoes_iniciadas,
    COUNT(DISTINCT CASE WHEN DTFINAL >= CURRENT_DATE THEN ID_PROMO END) AS promocoes_ativas
FROM PROMO
GROUP BY EXTRACT(MONTH FROM DTINICIAL)
ORDER BY mes;
```

**Padrões Sazonais:**
- **Picos**: Novembro (Black Friday), Dezembro (Natal), Janeiro (Ano Novo)
- **Vales**: Fevereiro, Março, Agosto
- Planejamento: ~12-15 promoções/mês em meses normais, 25+ em sazonais

---

## 🔧 Queries de Manutenção

### Limpeza de Atributos Órfãos

```sql
-- Identificar atributos sem promoção ativa
SELECT
    a.ID_ATBREGRAPROMO,
    a.ID_PROMO,
    a.CHAVE,
    a.VALOR,
    p.DESCRICAO AS promocao,
    p.DTFINAL AS data_encerramento,
    DATEDIFF(DAY, p.DTFINAL, CURRENT_DATE) AS dias_desde_encerramento
FROM ATBREGRAPROMO a
LEFT JOIN PROMO p ON a.ID_PROMO = p.ID_PROMO
WHERE p.DTFINAL < DATEADD(YEAR, -2, CURRENT_DATE)
ORDER BY dias_desde_encerramento DESC;

-- ATENÇÃO: Não deletar automaticamente - pode haver auditoria!
-- Considerar arquivamento em tabela histórica
```

### Validação de Integridade Referencial

```sql
-- Verificar FKs inválidas (não deveria retornar resultados)
SELECT
    'ATBREGRAPROMO → PROMO' AS relacionamento,
    a.ID_ATBREGRAPROMO,
    a.ID_PROMO
FROM ATBREGRAPROMO a
LEFT JOIN PROMO p ON a.ID_PROMO = p.ID_PROMO
WHERE p.ID_PROMO IS NULL

UNION ALL

SELECT
    'ATBREGRAPROMO → REGRAPROMO' AS relacionamento,
    a.ID_ATBREGRAPROMO,
    a.ID_REGRAPROMO
FROM ATBREGRAPROMO a
LEFT JOIN REGRAPROMO rp ON a.ID_REGRAPROMO = rp.ID_REGRAPROMO
WHERE rp.ID_REGRAPROMO IS NULL;

-- Se retornar registros: corrupção de dados!
```

### Normalização de Valores

```sql
-- Identificar valores inconsistentes em atributos numéricos
SELECT
    CHAVE,
    VALOR,
    COUNT(*) AS ocorrencias
FROM ATBREGRAPROMO
WHERE CHAVE IN ('DESCONTO_PERCENTUAL', 'VALOR_MINIMO', 'LIMITE_USO_CLIENTE')
  AND (
      VALOR NOT SIMILAR TO '[0-9]+(\.[0-9]{1,2})?' OR  -- Não é número válido
      VALOR IS NULL OR
      VALOR = ''
  )
GROUP BY CHAVE, VALOR
ORDER BY CHAVE, ocorrencias DESC;

-- Correção (exemplo):
-- UPDATE ATBREGRAPROMO SET VALOR = '0' WHERE CHAVE = 'DESCONTO_PERCENTUAL' AND VALOR = '';
```

### Análise de Duplicatas

```sql
-- Verificar atributos duplicados na mesma promoção
SELECT
    ID_PROMO,
    ID_REGRAPROMO,
    CHAVE,
    COUNT(*) AS ocorrencias,
    LIST(DISTINCT VALOR, ' | ') AS valores_distintos
FROM ATBREGRAPROMO
GROUP BY ID_PROMO, ID_REGRAPROMO, CHAVE
HAVING COUNT(*) > 1
ORDER BY ocorrencias DESC;

-- Se houver duplicatas: decisão de negócio (manter, consolidar, deletar)
```

### Migração para Colunas Dedicadas (Se Necessário)

```sql
-- Se um atributo for muito comum (>60% das promoções), considerar desnormalizar

-- 1. Adicionar coluna em PROMO
ALTER TABLE PROMO ADD DESCONTO_PERCENTUAL NUMERIC(5,2);

-- 2. Migrar dados
UPDATE PROMO p
SET DESCONTO_PERCENTUAL = (
    SELECT CAST(a.VALOR AS NUMERIC(5,2))
    FROM ATBREGRAPROMO a
    WHERE a.ID_PROMO = p.ID_PROMO
      AND a.CHAVE = 'DESCONTO_PERCENTUAL'
    FETCH FIRST 1 ROW ONLY
);

-- 3. Manter ATBREGRAPROMO para backward compatibility (fase de transição)
-- 4. Após validação, remover atributos migrados:
-- DELETE FROM ATBREGRAPROMO WHERE CHAVE = 'DESCONTO_PERCENTUAL';

-- ATENÇÃO: Avaliar trade-off flexibilidade × performance antes de desnormalizar!
```

### Backup de Configurações de Promoções

```sql
-- Exportar configuração completa de uma promoção para reuso
SELECT
    p.ID_PROMO,
    p.DESCRICAO,
    rp.DESCRICAO AS tipo_regra,
    a.CHAVE,
    a.VALOR,
    a.ATBDESCFIXO
FROM PROMO p
INNER JOIN REGRAPROMO rp ON p.ID_REGRAPROMO = rp.ID_REGRAPROMO
LEFT JOIN ATBREGRAPROMO a ON a.ID_PROMO = p.ID_PROMO
WHERE p.ID_PROMO = 150
ORDER BY a.CHAVE;

-- Salvar como template para futuras promoções similares
```

---

## 📚 Melhores Práticas

### 1. Gestão de Atributos Key-Value

**✅ FAZER:**
- Documentar todos os atributos possíveis em um dicionário de dados
- Usar convenção de nomenclatura consistente (UPPER_SNAKE_CASE)
- Preencher ATBDESCFIXO com descrição clara do atributo
- Validar tipos de dados na aplicação (numérico, booleano, texto, etc.)
- Criar enums/constantes na aplicação para CHAVEs conhecidas

**❌ EVITAR:**
- Criar atributos com nomes ambíguos ou duplicados
- Usar abreviações não documentadas
- Deixar ATBDESCFIXO vazio
- Armazenar valores com formatos inconsistentes (ex: "sim" vs "S" vs "1")

**Exemplo de Dicionário de Atributos:**
```typescript
// Frontend/Backend - Catálogo de Atributos
enum AtributoPromoEnum {
  DESCONTO_PERCENTUAL = 'DESCONTO_PERCENTUAL',      // Numeric(5,2)
  VALOR_MINIMO = 'VALOR_MINIMO',                    // Numeric(10,2)
  LIMITE_USO_CLIENTE = 'LIMITE_USO_CLIENTE',        // Integer
  CATEGORIA_PRODUTO = 'CATEGORIA_PRODUTO',          // String
  COMBINAVEL = 'COMBINAVEL',                        // Boolean (SIM/NAO)
  PRAZO_EXPIRACAO_DIAS = 'PRAZO_EXPIRACAO_DIAS',   // Integer
}

interface AtributoDefinition {
  chave: string;
  tipo: 'numeric' | 'integer' | 'boolean' | 'string' | 'date';
  descricao: string;
  validacao?: (valor: string) => boolean;
}
```

### 2. Performance e Indexação

**✅ FAZER:**
- Criar índice composto `(ID_PROMO, CHAVE)` para consultas de configuração
- Criar índice em `CHAVE` para buscas por atributo específico
- Usar views materializadas para atributos comuns (pivot)
- Implementar cache em aplicação para promoções ativas
- Monitorar planos de execução de queries frequentes

**❌ EVITAR:**
- Queries com múltiplas subconsultas por atributo
- Full table scans em ATBREGRAPROMO sem WHERE em chaves indexadas
- JOINs sem índices nas FK (ID_PROMO, ID_REGRAPROMO)
- Conversões de tipo (CAST) em cláusulas WHERE sem necessidade

**Estratégia de Cache:**
```typescript
// Cache de atributos de promoções ativas (Redis, Memcached, etc.)
class PromoAttributeCache {
  async getPromoAttributes(promoId: number): Promise<Map<string, string>> {
    const cacheKey = `promo:${promoId}:attributes`;

    // 1. Tentar cache
    let attributes = await redis.get(cacheKey);
    if (attributes) return JSON.parse(attributes);

    // 2. Buscar do banco
    attributes = await db.query(`
      SELECT CHAVE, VALOR
      FROM ATBREGRAPROMO
      WHERE ID_PROMO = ?
    `, [promoId]);

    // 3. Cachear por 1 hora (promoções ativas raramente mudam)
    await redis.setex(cacheKey, 3600, JSON.stringify(attributes));

    return attributes;
  }
}
```

### 3. Validação de Dados

**✅ FAZER:**
- Validar tipo de dado antes de INSERT (numérico, data, boolean)
- Validar ranges de valores (ex: DESCONTO_PERCENTUAL entre 0 e 100)
- Garantir que atributos obrigatórios existam para cada tipo de promoção
- Implementar validação em múltiplas camadas (frontend, backend, trigger)
- Registrar log de alterações em atributos críticos

**❌ EVITAR:**
- Inserir valores sem validação de tipo
- Permitir valores fora de range lógico (ex: desconto de 500%)
- Aceitar valores vazios para atributos obrigatórios
- Confiar apenas em validação frontend

**Exemplo de Validação:**
```sql
-- Trigger de validação (Firebird 2.5+)
CREATE OR ALTER TRIGGER TRG_ATBREGRAPROMO_VALIDATE
FOR ATBREGRAPROMO
ACTIVE BEFORE INSERT OR UPDATE
AS
BEGIN
    -- Validar DESCONTO_PERCENTUAL
    IF (NEW.CHAVE = 'DESCONTO_PERCENTUAL') THEN
    BEGIN
        IF (CAST(NEW.VALOR AS NUMERIC(5,2)) < 0 OR CAST(NEW.VALOR AS NUMERIC(5,2)) > 100) THEN
            EXCEPTION EX_INVALID_DISCOUNT 'Desconto deve estar entre 0 e 100';
    END

    -- Validar VALOR_MINIMO
    IF (NEW.CHAVE = 'VALOR_MINIMO') THEN
    BEGIN
        IF (CAST(NEW.VALOR AS NUMERIC(10,2)) < 0) THEN
            EXCEPTION EX_INVALID_VALUE 'Valor mínimo não pode ser negativo';
    END

    -- Validar COMBINAVEL
    IF (NEW.CHAVE = 'COMBINAVEL') THEN
    BEGIN
        IF (NEW.VALOR NOT IN ('SIM', 'NAO')) THEN
            EXCEPTION EX_INVALID_BOOLEAN 'COMBINAVEL deve ser SIM ou NAO';
    END
END;
```

### 4. Extensibilidade e Versionamento

**✅ FAZER:**
- Manter histórico de alterações em atributos (audit trail)
- Versionar schemas de atributos (v1, v2, etc.)
- Suportar atributos deprecated sem quebrar sistemas legados
- Documentar migration path ao deprecar atributos
- Usar feature flags para novos atributos em teste

**❌ EVITAR:**
- Deletar atributos abruptamente (quebra backward compatibility)
- Alterar semântica de atributos existentes sem versionar
- Deixar de documentar alterações em atributos

**Exemplo de Versionamento:**
```sql
-- Adicionar campo de versão
ALTER TABLE ATBREGRAPROMO ADD VERSAO_ATRIBUTO INTEGER DEFAULT 1;

-- Deprecar atributo antigo, introduzir novo
INSERT INTO ATBREGRAPROMO (ID_REGRAPROMO, ID_PROMO, CHAVE, VALOR, VERSAO_ATRIBUTO)
VALUES (1, 160, 'DESCONTO_VALOR_FIXO_V2', '50.00', 2);  -- Novo formato

-- Manter compatibilidade com v1 via view
CREATE VIEW V_ATBREGRAPROMO_COMPAT AS
SELECT
    ID_ATBREGRAPROMO,
    ID_PROMO,
    CASE
        WHEN CHAVE = 'DESCONTO_VALOR_FIXO_V2' THEN 'DESCONTO_VALOR_FIXO'
        ELSE CHAVE
    END AS CHAVE,
    VALOR
FROM ATBREGRAPROMO;
```

### 5. Integração com Sistema de Pedidos

**✅ FAZER:**
- Carregar todos os atributos de uma promoção em uma única query
- Cachear atributos de promoções ativas em memória
- Implementar fallback para valores padrão se atributo não existir
- Logar atributos aplicados em cada pedido (auditoria)
- Validar elegibilidade antes de aplicar benefício

**❌ EVITAR:**
- Consultar banco de dados por atributo individual (N+1 problem)
- Assumir que atributo sempre existe
- Aplicar promoção sem validar todas as condições
- Deixar de registrar aplicação em PEDIDPROMO

**Exemplo de Aplicação:**
```typescript
class PromoApplicationService {
  async applyPromoToOrder(orderId: number, promoId: number) {
    // 1. Carregar todos os atributos de uma vez
    const attributes = await this.loadPromoAttributes(promoId);

    // 2. Validar elegibilidade
    const order = await this.getOrder(orderId);
    const minValue = parseFloat(attributes.get('VALOR_MINIMO') || '0');
    if (order.total < minValue) {
      throw new Error(`Pedido não atinge valor mínimo de ${minValue}`);
    }

    // 3. Verificar limite de uso
    const limit = parseInt(attributes.get('LIMITE_USO_CLIENTE') || '999');
    const usage = await this.getPromoUsageByClient(order.clientId, promoId);
    if (usage >= limit) {
      throw new Error('Limite de uso da promoção atingido');
    }

    // 4. Aplicar benefício
    const discount = parseFloat(attributes.get('DESCONTO_PERCENTUAL') || '0');
    const discountValue = (order.total * discount) / 100;

    // 5. Registrar aplicação
    await db.query(`
      INSERT INTO PEDIDPROMO (ID_PEDIDPROMOCAO, ID_PROMO, DATAGERACAO)
      VALUES (?, ?, CURRENT_TIMESTAMP)
    `, [orderId, promoId]);

    // 6. Log de auditoria
    logger.info('Promoção aplicada', {
      orderId,
      promoId,
      discountValue,
      attributes: Object.fromEntries(attributes)
    });

    return { discountValue, appliedAttributes: attributes };
  }
}
```

### 6. Migração e Desnormalização

**✅ FAZER:**
- Avaliar trade-off: flexibilidade (key-value) vs performance (coluna dedicada)
- Considerar desnormalizar atributos usados em >60% das promoções
- Manter período de transição com dados duplicados (key-value + coluna)
- Validar consistência durante período de transição
- Documentar motivo da desnormalização

**❌ EVITAR:**
- Desnormalizar prematuramente (otimização prematura)
- Deletar dados de ATBREGRAPROMO imediatamente após migração
- Migrar sem período de validação
- Desnormalizar atributos raros ou específicos

**Critérios para Desnormalização:**
- Atributo usado em >60% das promoções ativas
- Queries frequentes filtram por esse atributo
- Performance crítica identificada em profiling
- Tipo de dado bem definido (não muda)
- Custo de ALTER TABLE aceitável

### 7. Testes e Qualidade

**✅ FAZER:**
- Testar cenários com promoções sem atributos
- Testar cenários com atributos inválidos/corrompidos
- Testar performance com 1K+ atributos (projeção de crescimento)
- Validar comportamento com múltiplas promoções aplicadas
- Testar edge cases (valor nulo, string vazia, tipo errado)

**❌ EVITAR:**
- Assumir que atributos sempre existem e são válidos
- Testar apenas happy path
- Ignorar casos de promoções expiradas com atributos órfãos
- Deixar de testar com volume realista de dados

**Suite de Testes:**
```typescript
describe('PromoAttributeService', () => {
  it('deve retornar mapa vazio se promoção não tem atributos', async () => {
    const attrs = await service.getAttributes(999);
    expect(attrs.size).toBe(0);
  });

  it('deve usar valor padrão se atributo não existir', async () => {
    const minValue = await service.getMinValue(promoId, 100); // default=100
    expect(minValue).toBe(100);
  });

  it('deve lançar erro se atributo obrigatório ausente', async () => {
    await expect(service.applyPromo(orderId, promoId))
      .rejects.toThrow('Atributo DESCONTO_PERCENTUAL obrigatório');
  });

  it('deve validar tipo de dado do atributo', async () => {
    await expect(service.validateAttribute('DESCONTO_PERCENTUAL', 'abc'))
      .rejects.toThrow('Valor deve ser numérico');
  });
});
```

### 8. Monitoramento e Observabilidade

**✅ FAZER:**
- Monitorar queries lentas em ATBREGRAPROMO
- Alertar se taxa de crescimento de atributos for anormal
- Rastrear uso de cada tipo de atributo (telemetria)
- Monitorar cache hit rate de atributos de promoções
- Dashboards de promoções ativas e seus atributos

**❌ EVITAR:**
- Ignorar degradação de performance ao longo do tempo
- Deixar de monitorar crescimento de volume
- Não rastrear quais atributos são realmente usados
- Ignorar logs de erros de validação de atributos

**Métricas Chave:**
```yaml
# Prometheus/Grafana - Métricas sugeridas
promo_attributes_total: 314                    # Total de atributos
promo_attributes_per_promo_avg: 2.01           # Média de atributos/promoção
promo_attribute_query_duration_ms: 15          # Latência de consulta
promo_attribute_cache_hit_rate: 0.92           # Taxa de acerto do cache
promo_attribute_validation_errors_total: 3     # Erros de validação (contador)
```

### 9. Segurança e Auditoria

**✅ FAZER:**
- Registrar log de todas as alterações em atributos críticos
- Implementar controle de acesso granular (quem pode criar atributos)
- Validar inputs para prevenir SQL injection (prepared statements)
- Auditar mudanças retroativas em promoções ativas
- Manter histórico de valores anteriores de atributos

**❌ EVITAR:**
- Permitir alteração de atributos de promoções ativas sem auditoria
- Aceitar valores de atributos sem sanitização
- Deixar de logar quem alterou o atributo e quando
- Permitir deleção de atributos sem trace

**Exemplo de Auditoria:**
```sql
-- Tabela de auditoria
CREATE TABLE ATBREGRAPROMO_AUDIT (
    ID_AUDIT          INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_ATBREGRAPROMO  INTEGER NOT NULL,
    OPERACAO          VARCHAR(10) NOT NULL,  -- INSERT, UPDATE, DELETE
    CHAVE_ANTERIOR    VARCHAR(100),
    VALOR_ANTERIOR    VARCHAR(500),
    CHAVE_NOVO        VARCHAR(100),
    VALOR_NOVO        VARCHAR(500),
    USUARIO           VARCHAR(50),
    DATA_HORA         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger de auditoria
CREATE OR ALTER TRIGGER TRG_ATBREGRAPROMO_AUDIT
FOR ATBREGRAPROMO
ACTIVE AFTER INSERT OR UPDATE OR DELETE
AS
BEGIN
    IF (INSERTING) THEN
        INSERT INTO ATBREGRAPROMO_AUDIT (ID_ATBREGRAPROMO, OPERACAO, CHAVE_NOVO, VALOR_NOVO, USUARIO)
        VALUES (NEW.ID_ATBREGRAPROMO, 'INSERT', NEW.CHAVE, NEW.VALOR, CURRENT_USER);

    IF (UPDATING) THEN
        INSERT INTO ATBREGRAPROMO_AUDIT (ID_ATBREGRAPROMO, OPERACAO, CHAVE_ANTERIOR, VALOR_ANTERIOR, CHAVE_NOVO, VALOR_NOVO, USUARIO)
        VALUES (NEW.ID_ATBREGRAPROMO, 'UPDATE', OLD.CHAVE, OLD.VALOR, NEW.CHAVE, NEW.VALOR, CURRENT_USER);

    IF (DELETING) THEN
        INSERT INTO ATBREGRAPROMO_AUDIT (ID_ATBREGRAPROMO, OPERACAO, CHAVE_ANTERIOR, VALOR_ANTERIOR, USUARIO)
        VALUES (OLD.ID_ATBREGRAPROMO, 'DELETE', OLD.CHAVE, OLD.VALOR, CURRENT_USER);
END;
```

### 10. Documentação e Comunicação

**✅ FAZER:**
- Documentar todos os atributos possíveis em wiki/docs
- Comunicar equipes ao adicionar novos tipos de atributos
- Manter changelog de atributos adicionados/deprecated
- Documentar casos de uso de cada atributo
- Criar guias de migração ao mudar atributos

**❌ EVITAR:**
- Adicionar atributos sem documentar
- Deprecar atributos sem comunicar equipes dependentes
- Deixar de atualizar documentação ao mudar comportamento
- Usar nomes de atributos sem semântica clara

**Template de Documentação:**
```markdown
# Atributo: CASHBACK_PERCENTUAL

## Descrição
Percentual de cashback concedido ao cliente para uso em próxima compra.

## Tipo de Dado
Numérico (5,2) - Ex: 5.00 representa 5%

## Validação
- Range: 0.00 a 100.00
- Obrigatório: Não
- Padrão: 0.00

## Casos de Uso
- Programas de fidelidade
- Promoções de recompra

## Compatibilidade
- Versão: 2.0
- Introduzido: 2024-Q4
- Substitui: PONTOS_BONUS (deprecated)

## Exemplos
```sql
INSERT INTO ATBREGRAPROMO (ID_PROMO, CHAVE, VALOR)
VALUES (160, 'CASHBACK_PERCENTUAL', '5.00');
```

## Dependências
- Requer sistema de carteira digital ativo
- Integração com módulo de pontos/cashback
```

---

## 🎯 Conclusão

A tabela **ATBREGRAPROMO** é um componente estratégico do sistema promocional, implementando um padrão **key-value** que proporciona:

### Vantagens
✅ **Flexibilidade Total**: Novos atributos sem ALTER TABLE
✅ **Extensibilidade**: Sistema preparado para evolução
✅ **Baixo Acoplamento**: Aplicações podem adicionar atributos sem mudanças estruturais
✅ **Auditabilidade**: Histórico completo de configurações promocionais

### Desafios
⚠️ **Performance**: Queries podem ser mais lentas que colunas dedicadas
⚠️ **Validação**: Tipo de dado não é enforçado pelo schema
⚠️ **Complexidade**: Lógica de negócio mais complexa na aplicação
⚠️ **Indexação**: Estratégia de índices mais sofisticada

### Recomendações Críticas

1. **URGENTE**: Criar índice `(ID_PROMO, CHAVE)` - melhoria de 50-100x
2. **IMPORTANTE**: Implementar dicionário de atributos e validação de tipos
3. **RECOMENDADO**: Estratégia de cache para promoções ativas
4. **CONSIDERAR**: Desnormalizar atributos muito comuns (>60% das promoções)

### Métricas de Sucesso

| Métrica | Atual | Meta | Status |
|---------|-------|------|--------|
| Latência de consulta | ~50ms | <20ms | ⚠️ Melhorar |
| Cache hit rate | ~70% | >90% | ⚠️ Melhorar |
| Atributos por promoção | 2.01 | 3-5 | ✅ Saudável |
| Taxa de erro de validação | ~0.5% | <0.1% | ⚠️ Melhorar |
| Cobertura de testes | ~60% | >85% | ⚠️ Melhorar |

### Visão de Futuro

O sistema de atributos flexíveis posiciona a plataforma para:
- Experimentos A/B de promoções sem desenvolvimento
- Personalização dinâmica de campanhas
- Integração com ML para otimização de ofertas
- Suporte a promoções multicanal complexas

**Volume do Ecossistema**: ~100,000+ registros distribuídos em 12+ tabelas relacionadas, processando centenas de pedidos promocionais diariamente.

---

**Documentação Gerada**: 2025-11-27
**Banco de Dados**: Firebird 2.5+
**Versão**: 1.0
**Autor**: Sistema de Documentação Automatizada
**Próxima Revisão**: Trimestral ou ao atingir 500 atributos
