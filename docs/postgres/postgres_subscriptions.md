# PostgreSQL - Subscriptions

## O que são Subscriptions?

Subscriptions são o lado receptor da **Replicação Lógica** do PostgreSQL.
Enquanto a Publication define o que será replicado no servidor de origem
(publisher), a Subscription configura o servidor de destino (subscriber)
para se conectar ao publisher, consumir as mudanças publicadas e aplicá-las
localmente.

Introduzidas no PostgreSQL 10 junto com as Publications, as Subscriptions
permitem replicação lógica nativa entre instâncias PostgreSQL, possibilitando
cenários como bancos de relatórios, migrações, alta disponibilidade seletiva
e consolidação de dados de múltiplas origens.

---

## Arquitetura Completa

```
PUBLISHER (produção)                    SUBSCRIBER (relatórios/backup)
┌─────────────────────┐                ┌─────────────────────────────┐
│                     │                │                             │
│  Tabela: pedidos ───┼──► WAL ──────► │  Replication Worker         │
│  Tabela: clientes   │   (pgoutput)   │  aplica mudanças            │
│  Tabela: produtos   │                │                             │
│         │           │                │  Tabela: pedidos  (cópia)   │
│  PUBLICATION        │◄───────────────│  Tabela: clientes (cópia)   │
│  pub_vendas         │  conexão via   │  Tabela: produtos (cópia)   │
│                     │  replicação    │                             │
│  Replication Slot   │                │  SUBSCRIPTION               │
│  (retém WAL)        │                │  sub_vendas                 │
└─────────────────────┘                └─────────────────────────────┘
```

---

## Pré-requisitos

### No Publisher

```ini
# postgresql.conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

```
# pg_hba.conf — permitir conexão do subscriber
host  replication  replicador  192.168.1.0/24  scram-sha-256
```

```sql
-- Usuário de replicação com permissões mínimas
CREATE USER replicador WITH REPLICATION LOGIN PASSWORD 'senha_segura';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO replicador;
```

### No Subscriber

```ini
# postgresql.conf
max_logical_replication_workers = 10
max_worker_processes = 20
```

> O subscriber **não** precisa de `wal_level = logical` a menos que
> ele próprio seja publisher de outra subscription (replicação em cascata).

---

## Criando Subscriptions

### Subscription básica

```sql
-- No servidor subscriber
CREATE SUBSCRIPTION sub_vendas
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura'
PUBLICATION pub_vendas;
```

### Subscription com opções avançadas

```sql
CREATE SUBSCRIPTION sub_vendas
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura sslmode=require'
PUBLICATION pub_vendas
WITH (
    connect            = true,   -- conectar imediatamente ao criar
    enabled            = true,   -- iniciar replicação imediatamente
    copy_data          = true,   -- copiar dados existentes na sincronização inicial
    create_slot        = true,   -- criar replication slot no publisher
    slot_name          = 'sub_vendas_slot',  -- nome do slot
    synchronous_commit = 'off'   -- não esperar confirmação do subscriber
);
```

### Subscription para múltiplas publications

```sql
-- Uma subscription pode consumir várias publications do mesmo publisher
CREATE SUBSCRIPTION sub_completa
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura'
PUBLICATION pub_vendas, pub_financeiro, pub_estoque;
```

### Subscription sem cópia inicial dos dados

```sql
-- Útil quando os dados já existem no subscriber (ex: restaurado de backup)
CREATE SUBSCRIPTION sub_apenas_delta
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura'
PUBLICATION pub_vendas
WITH (copy_data = false);
```

### Subscription usando slot existente

```sql
-- Reutilizar um replication slot já criado manualmente no publisher
CREATE SUBSCRIPTION sub_reuso_slot
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura'
PUBLICATION pub_vendas
WITH (
    create_slot = false,
    slot_name   = 'slot_existente'
);
```

---

## Preparando o Subscriber

Antes de criar a subscription, o schema e as tabelas devem existir no
subscriber. O PostgreSQL **não** cria automaticamente a estrutura DDL.

```sql
-- No subscriber: criar o schema e tabelas manualmente
-- Opção 1: recriar a estrutura manualmente

CREATE TABLE pedidos (
    id          BIGSERIAL PRIMARY KEY,
    cliente_id  BIGINT,
    data_pedido DATE,
    valor_total NUMERIC(15,2),
    status      TEXT
);

CREATE TABLE clientes (
    id    BIGSERIAL PRIMARY KEY,
    nome  TEXT,
    email TEXT,
    estado CHAR(2)
);

-- Opção 2: usar pg_dump apenas da estrutura (sem dados) do publisher
-- No terminal:
-- pg_dump -h publisher -U postgres -s erp_producao > estrutura.sql
-- psql -h subscriber -U postgres erp_relatorios < estrutura.sql

-- Após criar a estrutura, criar a subscription
CREATE SUBSCRIPTION sub_vendas
CONNECTION 'host=192.168.1.100 port=5432 dbname=erp_producao user=replicador password=senha_segura'
PUBLICATION pub_vendas;
```

---

## Gerenciando Subscriptions

### Listar subscriptions existentes

```sql
SELECT
    subname         AS subscription,
    subenabled      AS habilitada,
    subpublications AS publications,
    subconninfo     AS conexao,
    subslotname     AS slot,
    subsynccommit   AS sync_commit
FROM pg_subscription;
```

### Verificar status de sincronização das tabelas

```sql
-- Estado de cada tabela na subscription
SELECT
    srsubid::regclass,
    srsublsn,
    srrelid::regclass AS tabela,
    CASE srsubstate
        WHEN 'i' THEN 'Inicializando'
        WHEN 'd' THEN 'Copiando dados'
        WHEN 'f' THEN 'Finalizado (sincronizado)'
        WHEN 'n' THEN 'Não iniciado'
        WHEN 'r' THEN 'Pronto'
        WHEN 's' THEN 'Sincronizando'
    END AS estado
FROM pg_subscription_rel
ORDER BY tabela;
```

### Desabilitar subscription temporariamente

```sql
-- Pausar replicação (útil durante manutenções)
ALTER SUBSCRIPTION sub_vendas DISABLE;

-- Reabilitar
ALTER SUBSCRIPTION sub_vendas ENABLE;
```

### Alterar connection string

```sql
ALTER SUBSCRIPTION sub_vendas
CONNECTION 'host=192.168.1.101 port=5432 dbname=erp_producao user=replicador password=nova_senha';
```

### Adicionar ou trocar publication

```sql
-- Adicionar publication à subscription existente
ALTER SUBSCRIPTION sub_vendas
SET PUBLICATION pub_vendas, pub_financeiro;

-- Trocar para outra publication
ALTER SUBSCRIPTION sub_vendas
SET PUBLICATION pub_nova;
```

### Forçar ressincronização de uma tabela

```sql
-- Ressincronizar tabela específica (PostgreSQL 15+)
ALTER SUBSCRIPTION sub_vendas REFRESH PUBLICATION;

-- Ressincronizar tabelas novas adicionadas à publication
ALTER SUBSCRIPTION sub_vendas
REFRESH PUBLICATION WITH (copy_data = true);
```

### Remover subscription

```sql
-- Remover subscription (também remove o replication slot no publisher)
DROP SUBSCRIPTION IF EXISTS sub_vendas;

-- Remover sem dropar o slot (quando publisher está inacessível)
ALTER SUBSCRIPTION sub_vendas DISABLE;
ALTER SUBSCRIPTION sub_vendas SET (slot_name = NONE);
DROP SUBSCRIPTION sub_vendas;
```

---

## Monitoramento

### Status geral das subscriptions

```sql
SELECT
    s.subname          AS subscription,
    s.subenabled       AS habilitada,
    w.pid              AS pid_worker,
    w.received_lsn     AS lsn_recebido,
    w.latest_end_lsn   AS lsn_final,
    w.last_msg_receipt_time AS ultima_mensagem,
    w.latest_end_time  AS ultimo_fim
FROM pg_subscription s
LEFT JOIN pg_stat_subscription w ON w.subid = s.oid
ORDER BY s.subname;
```

### Lag de replicação no subscriber

```sql
-- Ver atraso entre publisher e subscriber
SELECT
    subname       AS subscription,
    received_lsn  AS lsn_recebido,
    pg_wal_lsn_diff(
        pg_current_wal_lsn(),
        received_lsn
    ) AS lag_bytes,
    pg_size_pretty(
        pg_wal_lsn_diff(
            pg_current_wal_lsn(),
            received_lsn
        )
    ) AS lag_legivel
FROM pg_stat_subscription;
```

### Verificar workers de replicação

```sql
SELECT
    pid,
    application_name,
    state,
    wait_event_type,
    wait_event,
    query
FROM pg_stat_activity
WHERE backend_type = 'logical replication worker';
```

### Verificar replication slots no publisher

```sql
-- Executar NO PUBLISHER para ver o estado do slot
SELECT
    slot_name,
    plugin,
    slot_type,
    active,
    active_pid,
    restart_lsn,
    confirmed_flush_lsn,
    pg_size_pretty(
        pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)
    ) AS wal_acumulado
FROM pg_replication_slots
WHERE slot_type = 'logical';
```

---

## Casos de Uso Práticos

### Caso 1 — Banco de relatórios dedicado

```sql
-- No subscriber (servidor de relatórios)

-- Preparar estrutura
CREATE SCHEMA relatorios;

-- Criar tabelas espelho
CREATE TABLE pedidos   (LIKE pedidos   INCLUDING ALL);
CREATE TABLE clientes  (LIKE clientes  INCLUDING ALL);
CREATE TABLE produtos  (LIKE produtos  INCLUDING ALL);

-- Criar subscription
CREATE SUBSCRIPTION sub_relatorios
CONNECTION 'host=prod-db port=5432 dbname=erp user=replicador password=senha sslmode=require'
PUBLICATION pub_relatorios
WITH (copy_data = true, synchronous_commit = 'off');

-- Views analíticas sobre dados replicados (sem impacto na produção)
CREATE VIEW vw_faturamento_mensal AS
SELECT
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*)                         AS qtd_pedidos,
    SUM(valor_total)                 AS faturamento
FROM pedidos
GROUP BY 1
ORDER BY 1;
```

### Caso 2 — Migração entre versões do PostgreSQL

```sql
-- Migrar do PostgreSQL 14 para PostgreSQL 16

-- No PG16 (subscriber): criar estrutura
-- pg_dump -h pg14-server -U postgres -s meu_banco | psql -h pg16-server -U postgres meu_banco

-- No PG16: criar subscription apontando para PG14
CREATE SUBSCRIPTION sub_migracao
CONNECTION 'host=pg14-server port=5432 dbname=meu_banco user=replicador password=senha'
PUBLICATION pub_migracao_total
WITH (copy_data = true);

-- Monitorar sincronização
SELECT srrelid::regclass AS tabela, srsubstate AS estado
FROM pg_subscription_rel;

-- Quando todas as tabelas estiverem em estado 'r' (ready):
-- 1. Parar aplicações
-- 2. Confirmar que lag é zero
-- 3. Apontar aplicação para PG16
-- 4. Remover subscription
DROP SUBSCRIPTION sub_migracao;
```

### Caso 3 — Consolidação de múltiplas filiais

```sql
-- Servidor central recebe dados de todas as filiais
-- Cada filial tem sua própria publication

CREATE SCHEMA filial_sp;
CREATE SCHEMA filial_rj;
CREATE SCHEMA filial_pr;

-- Criar tabelas em cada schema
-- (estrutura idêntica em todos)

-- Subscription para cada filial
CREATE SUBSCRIPTION sub_filial_sp
CONNECTION 'host=10.0.1.10 port=5432 dbname=erp user=replicador password=senha'
PUBLICATION pub_dados_filial;

CREATE SUBSCRIPTION sub_filial_rj
CONNECTION 'host=10.0.1.20 port=5432 dbname=erp user=replicador password=senha'
PUBLICATION pub_dados_filial;

CREATE SUBSCRIPTION sub_filial_pr
CONNECTION 'host=10.0.1.30 port=5432 dbname=erp user=replicador password=senha'
PUBLICATION pub_dados_filial;

-- View consolidada nacional
CREATE VIEW vw_vendas_nacional AS
    SELECT 'SP' AS filial, * FROM filial_sp.pedidos
    UNION ALL
    SELECT 'RJ' AS filial, * FROM filial_rj.pedidos
    UNION ALL
    SELECT 'PR' AS filial, * FROM filial_pr.pedidos;
```

### Caso 4 — Alta disponibilidade com failover manual

```sql
-- Subscriber configurado como standby lógico
-- Em caso de falha do publisher, promover o subscriber

-- Verificar que replicação está em dia
SELECT * FROM pg_stat_subscription;

-- Promover subscriber para produção:
-- 1. Desabilitar subscription (não dropar — preserva consistência)
ALTER SUBSCRIPTION sub_ha DISABLE;

-- 2. Remover subscription sem dropar slot
ALTER SUBSCRIPTION sub_ha SET (slot_name = NONE);
DROP SUBSCRIPTION sub_ha;

-- 3. O subscriber agora opera de forma independente
-- 4. Aplicações apontam para o ex-subscriber
```

---

## Conflitos na Replicação

Conflitos ocorrem quando o subscriber tenta aplicar uma mudança que viola
uma constraint local (ex: chave duplicada).

```sql
-- Verificar conflitos de replicação nos logs
-- Os erros aparecem no postgresql.log do subscriber como:
-- ERROR: duplicate key value violates unique constraint "pedidos_pkey"

-- Resolver conflito: avançar o LSN para pular a transação problemática
-- CUIDADO: use apenas quando entender o motivo do conflito

-- Identificar o LSN a ser pulado nos logs de erro
-- Em seguida, no subscriber:
SELECT pg_replication_origin_advance(
    'pg_' || (SELECT oid FROM pg_subscription WHERE subname = 'sub_vendas')::text,
    'LSN_DO_ERRO/AQUI'::pg_lsn
);

-- Reiniciar o worker de replicação
ALTER SUBSCRIPTION sub_vendas DISABLE;
ALTER SUBSCRIPTION sub_vendas ENABLE;
```

---

## Diferenças entre Replicação Física e Lógica

| Característica | Replicação Física | Replicação Lógica |
|---|---|---|
| Nível | Bloco/byte | Linha (row-level) |
| Granularidade | Cluster inteiro | Tabelas específicas |
| Versão PostgreSQL | Deve ser igual ou superior | Pode ser diferente |
| DDL | Replicado automaticamente | NÃO replicado |
| Sequences | Replicadas | NÃO replicadas |
| Filtros | Não suporta | Suporta (linhas e colunas) |
| Múltiplos destinos | Sim | Sim |
| Escrita no subscriber | Não (somente leitura) | Sim (tabelas não replicadas) |
| Uso de CPU | Menor | Maior |
| Casos de uso | HA / DR | Relatórios / Migração / ETL |

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| SSL obrigatório | Use `sslmode=require` na connection string |
| Usuário dedicado | Crie usuário exclusivo para replicação com permissões mínimas |
| Monitorar slots | Slots inativos acumulam WAL — monitore e remova os desnecessários |
| Sincronização inicial | Use `copy_data=false` quando restaurar de backup para evitar recarga total |
| DDL manual | Aplique mudanças de estrutura manualmente no subscriber antes do publisher |
| Alertas de lag | Configure alertas quando o lag ultrapassar um threshold aceitável |
| Documentar LSN | Registre o LSN de cada subscription para facilitar troubleshooting |
| Conflitos | Tenha um runbook para resolução de conflitos de replicação |

---

## Referências

- [PostgreSQL Docs - Logical Replication](https://www.postgresql.org/docs/current/logical-replication.html)
- [PostgreSQL Docs - CREATE SUBSCRIPTION](https://www.postgresql.org/docs/current/sql-createsubscription.html)
- [PostgreSQL Docs - pg_subscription](https://www.postgresql.org/docs/current/catalog-pg-subscription.html)
- [PostgreSQL Docs - Monitoring Subscriptions](https://www.postgresql.org/docs/current/monitoring-replication.html)
- [PostgreSQL Docs - Replication Conflicts](https://www.postgresql.org/docs/current/logical-replication-conflicts.html)
