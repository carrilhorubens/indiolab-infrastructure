# PostgreSQL - Publications

## O que são Publications?

Publications fazem parte do sistema de **Logical Replication** (Replicação
Lógica) do PostgreSQL, introduzido na versão 10. Uma publication define um
conjunto de mudanças geradas em uma ou mais tabelas que serão disponibilizadas
para replicação. O servidor que contém a publication é chamado de **publisher**
(publicador).

Diferente da replicação física (streaming replication), que replica byte a
byte todo o cluster, a replicação lógica trabalha em nível de linha e permite:

- Replicar apenas tabelas específicas
- Replicar entre versões diferentes do PostgreSQL
- Replicar entre bancos de dados distintos na mesma instância
- Filtrar operações (apenas INSERT, apenas UPDATE, etc.)
- Replicar para múltiplos subscribers simultaneamente
- Replicar dados para outros sistemas (Kafka, Debezium, etc.)

---

## Arquitetura da Replicação Lógica

```
PUBLISHER (servidor de origem)
│
├── WAL (Write-Ahead Log)
│       └── pgoutput plugin decodifica as mudanças
│
└── PUBLICATION
        └── Define QUAIS tabelas e QUAIS operações replicar
                │
                │  (via rede — protocolo de replicação)
                ▼
SUBSCRIBER (servidor de destino)
│
└── SUBSCRIPTION
        └── Consome a publication e aplica as mudanças localmente
```

---

## Pré-requisitos no Publisher

### Configuração do postgresql.conf

```ini
# Nível de WAL deve ser logical
wal_level = logical

# Quantidade máxima de replication slots simultâneos
max_replication_slots = 10

# Quantidade máxima de processos de WAL sender
max_wal_senders = 10
```

> Após alterar `wal_level`, é necessário **reiniciar** o PostgreSQL.

### Configuração do pg_hba.conf

```
# Permitir conexão de replicação do subscriber
host  replication  usuario_replicacao  192.168.1.0/24  scram-sha-256
```

### Permissões necessárias

```sql
-- Criar usuário dedicado para replicação
CREATE USER replicador WITH REPLICATION LOGIN PASSWORD 'senha_segura';

-- Conceder permissão de leitura nas tabelas a serem publicadas
GRANT SELECT ON ALL TABLES IN SCHEMA public TO replicador;

-- PostgreSQL 16+: permissão mais granular
GRANT pg_read_all_data TO replicador;
```

---

## Criando Publications

### Publicar todas as tabelas do banco

```sql
-- Publica INSERT, UPDATE, DELETE e TRUNCATE de todas as tabelas
CREATE PUBLICATION pub_completa FOR ALL TABLES;
```

### Publicar tabelas específicas

```sql
-- Apenas tabelas selecionadas
CREATE PUBLICATION pub_vendas
FOR TABLE pedidos, clientes, produtos, itens_pedido;
```

### Publicar com filtro de operações

```sql
-- Apenas inserções (sem UPDATE, DELETE, TRUNCATE)
CREATE PUBLICATION pub_apenas_inserts
FOR TABLE logs_auditoria, eventos
WITH (publish = 'insert');

-- Apenas INSERT e UPDATE (sem DELETE)
CREATE PUBLICATION pub_sem_delete
FOR TABLE clientes, produtos
WITH (publish = 'insert, update');

-- Todas as operações explicitamente
CREATE PUBLICATION pub_todas_ops
FOR TABLE pedidos
WITH (publish = 'insert, update, delete, truncate');
```

### Publicar com filtro de linhas (PostgreSQL 15+)

```sql
-- Publicar apenas pedidos aprovados
CREATE PUBLICATION pub_pedidos_aprovados
FOR TABLE pedidos (id, cliente_id, valor_total, status)
WHERE (status = 'aprovado');

-- Publicar apenas clientes ativos de SP
CREATE PUBLICATION pub_clientes_sp
FOR TABLE clientes
WHERE (ativo = true AND estado = 'SP');
```

### Publicar colunas específicas (PostgreSQL 15+)

```sql
-- Publicar apenas colunas selecionadas (ocultar dados sensíveis)
CREATE PUBLICATION pub_clientes_sem_dados_sensiveis
FOR TABLE clientes (id, nome, cidade, estado, ativo);
-- CPF, email e telefone NÃO são replicados
```

### Publicar schemas inteiros (PostgreSQL 15+)

```sql
-- Publicar todas as tabelas de um schema
CREATE PUBLICATION pub_schema_financeiro
FOR TABLES IN SCHEMA financeiro;

-- Publicar múltiplos schemas
CREATE PUBLICATION pub_schemas_operacional
FOR TABLES IN SCHEMA vendas, estoque, financeiro;
```

---

## Gerenciando Publications

### Listar publications existentes

```sql
SELECT
    pubname         AS publicacao,
    puballtables    AS todas_tabelas,
    pubinsert       AS replica_insert,
    pubupdate       AS replica_update,
    pubdelete       AS replica_delete,
    pubtruncate     AS replica_truncate,
    pubviaroot      AS via_root
FROM pg_publication
ORDER BY pubname;
```

### Listar tabelas de uma publication

```sql
-- Forma 1: pg_publication_tables (view)
SELECT
    pubname    AS publicacao,
    schemaname AS schema,
    tablename  AS tabela
FROM pg_publication_tables
WHERE pubname = 'pub_vendas'
ORDER BY schemaname, tablename;

-- Forma 2: via catálogo
SELECT
    p.pubname   AS publicacao,
    n.nspname   AS schema,
    c.relname   AS tabela
FROM pg_publication p
JOIN pg_publication_rel pr ON pr.prpubid = p.oid
JOIN pg_class c             ON c.oid = pr.prrelid
JOIN pg_namespace n         ON n.oid = c.relnamespace
WHERE p.pubname = 'pub_vendas';
```

### Adicionar tabelas a uma publication existente

```sql
-- Adicionar tabelas
ALTER PUBLICATION pub_vendas ADD TABLE fornecedores, categorias;

-- Adicionar schema inteiro (PostgreSQL 15+)
ALTER PUBLICATION pub_vendas ADD TABLES IN SCHEMA estoque;
```

### Remover tabelas de uma publication

```sql
ALTER PUBLICATION pub_vendas DROP TABLE categorias;
```

### Redefinir tabelas de uma publication

```sql
-- Substituir completamente a lista de tabelas
ALTER PUBLICATION pub_vendas SET TABLE pedidos, clientes, produtos;
```

### Alterar operações publicadas

```sql
-- Mudar para publicar apenas INSERT e UPDATE
ALTER PUBLICATION pub_vendas SET (publish = 'insert, update');
```

### Remover uma publication

```sql
DROP PUBLICATION IF EXISTS pub_vendas;

-- CASCADE remove também os replication slots associados
DROP PUBLICATION IF EXISTS pub_vendas CASCADE;
```

---

## Replication Slots

Publications trabalham em conjunto com **replication slots**, que garantem
que o WAL não seja descartado antes que o subscriber consuma as mudanças.

```sql
-- Listar replication slots ativos
SELECT
    slot_name,
    plugin,
    slot_type,
    database,
    active,
    active_pid,
    restart_lsn,
    confirmed_flush_lsn,
    pg_size_pretty(
        pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)
    ) AS lag_wal
FROM pg_replication_slots;

-- ATENÇÃO: slots inativos acumulam WAL e podem esgotar o disco!
-- Remover slot inativo
SELECT pg_drop_replication_slot('nome_do_slot');
```

---

## Monitoramento

### Verificar status dos WAL senders

```sql
SELECT
    pid,
    usename        AS usuario,
    application_name AS subscriber,
    client_addr    AS ip_subscriber,
    state,
    sent_lsn,
    write_lsn,
    flush_lsn,
    replay_lsn,
    pg_size_pretty(
        pg_wal_lsn_diff(sent_lsn, replay_lsn)
    ) AS lag_replicacao
FROM pg_stat_replication
ORDER BY application_name;
```

### Verificar lag de replicação

```sql
-- Lag em bytes e tempo estimado
SELECT
    application_name AS subscriber,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn))   AS lag_envio,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) AS lag_aplicacao,
    write_lag,
    flush_lag,
    replay_lag
FROM pg_stat_replication;
```

---

## Exemplos de Casos de Uso

### Caso 1 — Replicação para banco de relatórios

```sql
-- No publisher (servidor de produção)
-- Replicar apenas dados necessários para relatórios
CREATE PUBLICATION pub_relatorios
FOR TABLE
    pedidos,
    clientes,
    produtos,
    itens_pedido,
    categorias
WITH (publish = 'insert, update, delete');

-- No subscriber (servidor de relatórios)
-- (ver documento de Subscriptions para a configuração completa)
```

### Caso 2 — Replicação parcial com filtro de linhas

```sql
-- Replicar apenas pedidos dos últimos 2 anos para o DW
-- (PostgreSQL 15+)
CREATE PUBLICATION pub_pedidos_recentes
FOR TABLE pedidos
WHERE (data_pedido >= CURRENT_DATE - INTERVAL '2 years');
```

### Caso 3 — Publicação para múltiplos subscribers

```sql
-- Uma publication pode alimentar vários subscribers simultaneamente
-- Publisher cria uma publication
CREATE PUBLICATION pub_master FOR ALL TABLES;

-- Subscriber 1: banco de relatórios
-- Subscriber 2: banco de backup lógico
-- Subscriber 3: sistema de analytics
-- Todos consomem a mesma publication
```

### Caso 4 — Migração de versão do PostgreSQL

```sql
-- Publisher: PostgreSQL 14
CREATE PUBLICATION pub_migracao FOR ALL TABLES;

-- Subscriber: PostgreSQL 16 (novo servidor)
-- Após sincronização completa, fazer o failover
-- Replicação lógica suporta versões diferentes do PostgreSQL
```

### Caso 5 — Replicação de dados sensíveis sem expor colunas

```sql
-- Publicar tabela de clientes sem CPF, cartão e senha
CREATE PUBLICATION pub_clientes_analytics
FOR TABLE clientes (
    id, nome, cidade, estado,
    data_cadastro, segmento, ativo
);
-- Colunas CPF, cartao_hash e senha_hash NÃO são replicadas
```

---

## Limitações das Publications

| Limitação | Detalhe |
|---|---|
| Sequences | Sequences não são replicadas automaticamente |
| DDL | Alterações de estrutura (ALTER TABLE) não são replicadas |
| Large Objects | Large Objects não são suportados |
| UNLOGGED tables | Tabelas UNLOGGED não podem ser publicadas |
| Chaves primárias | Tabelas sem PK só replicam INSERT (UPDATE/DELETE exigem PK ou REPLICA IDENTITY) |
| Schemas | O schema de destino deve existir previamente no subscriber |

### Configurar REPLICA IDENTITY para tabelas sem PK

```sql
-- Usar todas as colunas como identidade (menos eficiente)
ALTER TABLE minha_tabela REPLICA IDENTITY FULL;

-- Usar índice único como identidade
CREATE UNIQUE INDEX idx_minha_tabela_codigo ON minha_tabela (codigo);
ALTER TABLE minha_tabela REPLICA IDENTITY USING INDEX idx_minha_tabela_codigo;
```

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Usuário dedicado | Crie um usuário específico para replicação com permissões mínimas |
| PK em todas as tabelas | Sempre tenha chave primária para replicar UPDATE e DELETE |
| Monitorar slots | Monitore slots inativos — acumulam WAL e podem encher o disco |
| Publications específicas | Prefira publicar tabelas específicas a usar FOR ALL TABLES em produção |
| SSL | Sempre use SSL na conexão entre publisher e subscriber |
| Nomenclatura | Use nomes descritivos como `pub_<finalidade>` |
| Filtros | Use filtros de linha/coluna (PG 15+) para reduzir tráfego de rede |

---

## Referências

- [PostgreSQL Docs - Logical Replication](https://www.postgresql.org/docs/current/logical-replication.html)
- [PostgreSQL Docs - CREATE PUBLICATION](https://www.postgresql.org/docs/current/sql-createpublication.html)
- [PostgreSQL Docs - pg_publication](https://www.postgresql.org/docs/current/catalog-pg-publication.html)
- [PostgreSQL Docs - Monitoring Replication](https://www.postgresql.org/docs/current/monitoring-replication.html)
