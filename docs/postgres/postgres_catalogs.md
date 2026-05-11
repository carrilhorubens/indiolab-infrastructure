# PostgreSQL - Catalogs

## O que são Catalogs?

Os catálogos do sistema (system catalogs) são as tabelas internas do PostgreSQL
que armazenam todos os metadados do banco de dados. Tudo que define a estrutura
do banco — tabelas, colunas, índices, funções, permissões, tipos, etc. — é
registrado nos catálogos. Eles vivem no schema `pg_catalog` e são atualizados
automaticamente pelo PostgreSQL a cada operação DDL.

O schema `information_schema` é uma camada padronizada (SQL ANSI) sobre o
`pg_catalog`, oferecendo uma visão mais portável entre diferentes SGBDs.

---

## Schemas de Catálogo

| Schema | Descrição |
|---|---|
| `pg_catalog` | Catálogo nativo do PostgreSQL, mais completo e detalhado |
| `information_schema` | Visão padronizada SQL ANSI, portável entre SGBDs |

---

## Principais Tabelas do pg_catalog

### Estrutura do Banco

| Tabela | Conteúdo |
|---|---|
| `pg_database` | Bancos de dados da instância |
| `pg_namespace` | Schemas |
| `pg_class` | Tabelas, views, índices, sequences |
| `pg_attribute` | Colunas de cada relação |
| `pg_type` | Tipos de dados |
| `pg_constraint` | Constraints (PK, FK, UNIQUE, CHECK) |
| `pg_index` | Índices |
| `pg_sequence` | Sequences |

### Código e Rotinas

| Tabela | Conteúdo |
|---|---|
| `pg_proc` | Funções e procedures |
| `pg_trigger` | Triggers |
| `pg_rewrite` | Regras de views |
| `pg_language` | Linguagens procedurais |

### Segurança e Acesso

| Tabela | Conteúdo |
|---|---|
| `pg_roles` | Roles e usuários |
| `pg_auth_members` | Membros de cada role |
| `pg_default_acl` | Permissões padrão |

### Replicação e Conexões

| Tabela | Conteúdo |
|---|---|
| `pg_stat_activity` | Conexões ativas |
| `pg_replication_slots` | Slots de replicação |
| `pg_publication` | Publications (logical replication) |
| `pg_subscription` | Subscriptions (logical replication) |

---

## Exemplos Práticos

### Listar todos os bancos de dados da instância

```sql
SELECT
    datname        AS banco,
    pg_size_pretty(pg_database_size(datname)) AS tamanho,
    datcollate     AS collation,
    datconnlimit   AS limite_conexoes,
    datistemplate  AS eh_template
FROM pg_database
ORDER BY pg_database_size(datname) DESC;
```

### Listar todos os schemas do banco atual

```sql
SELECT
    nspname AS schema,
    pg_catalog.pg_get_userbyid(nspowner) AS dono,
    obj_description(oid, 'pg_namespace') AS descricao
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname != 'information_schema'
ORDER BY nspname;
```

### Listar todas as tabelas com tamanho

```sql
SELECT
    schemaname                            AS schema,
    tablename                             AS tabela,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) AS tamanho_total,
    pg_size_pretty(pg_relation_size(schemaname || '.' || tablename))       AS tamanho_dados,
    pg_size_pretty(
        pg_total_relation_size(schemaname || '.' || tablename) -
        pg_relation_size(schemaname || '.' || tablename)
    ) AS tamanho_indices
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;
```

### Listar colunas de uma tabela específica

```sql
SELECT
    a.attnum                              AS ordem,
    a.attname                             AS coluna,
    pg_catalog.format_type(a.atttypid, a.atttypmod) AS tipo,
    a.attnotnull                          AS not_null,
    pg_get_expr(d.adbin, d.adrelid)       AS valor_default,
    col_description(a.attrelid, a.attnum) AS comentario
FROM pg_attribute a
LEFT JOIN pg_attrdef d
    ON d.adrelid = a.attrelid AND d.adnum = a.attnum
WHERE a.attrelid = 'public.pedidos'::regclass
  AND a.attnum > 0
  AND NOT a.attisdropped
ORDER BY a.attnum;
```

### Listar todos os índices do banco

```sql
SELECT
    schemaname  AS schema,
    tablename   AS tabela,
    indexname   AS indice,
    indexdef    AS definicao,
    pg_size_pretty(pg_relation_size(indexname::text)) AS tamanho
FROM pg_indexes
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY schemaname, tablename, indexname;
```

### Listar todas as constraints

```sql
SELECT
    n.nspname                        AS schema,
    c.relname                        AS tabela,
    con.conname                      AS constraint,
    CASE con.contype
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'f' THEN 'FOREIGN KEY'
        WHEN 'u' THEN 'UNIQUE'
        WHEN 'c' THEN 'CHECK'
        WHEN 'n' THEN 'NOT NULL'
    END                              AS tipo,
    pg_get_constraintdef(con.oid)    AS definicao
FROM pg_constraint con
JOIN pg_class c    ON c.oid = con.conrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY n.nspname, c.relname, con.contype;
```

### Listar todas as funções customizadas

```sql
SELECT
    n.nspname                                      AS schema,
    p.proname                                      AS funcao,
    pg_catalog.pg_get_function_arguments(p.oid)    AS argumentos,
    pg_catalog.format_type(p.prorettype, NULL)     AS retorno,
    l.lanname                                      AS linguagem,
    p.prosrc                                       AS codigo
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
JOIN pg_language l  ON l.oid = p.prolang
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY n.nspname, p.proname;
```

### Listar roles e suas permissões

```sql
SELECT
    rolname        AS role,
    rolsuper       AS superuser,
    rolcreaterole  AS pode_criar_roles,
    rolcreatedb    AS pode_criar_db,
    rolcanlogin    AS pode_logar,
    rolreplication AS replicacao,
    rolconnlimit   AS limite_conexoes,
    rolvaliduntil  AS validade
FROM pg_roles
ORDER BY rolname;
```

### Listar conexões ativas

```sql
SELECT
    pid,
    usename        AS usuario,
    application_name AS aplicacao,
    client_addr    AS ip_cliente,
    state          AS estado,
    wait_event_type AS tipo_espera,
    wait_event     AS evento_espera,
    query_start    AS inicio_query,
    LEFT(query, 80) AS query
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;
```

### Listar triggers por tabela

```sql
SELECT
    trigger_schema AS schema,
    event_object_table AS tabela,
    trigger_name   AS trigger,
    event_manipulation AS evento,
    action_timing  AS momento,
    action_statement AS acao
FROM information_schema.triggers
WHERE trigger_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY trigger_schema, event_object_table, trigger_name;
```

---

## information_schema — Visão Portável

O `information_schema` oferece views padronizadas compatíveis com o padrão SQL.
Útil quando se deseja portabilidade entre SGBDs.

### Listar tabelas via information_schema

```sql
SELECT
    table_schema  AS schema,
    table_name    AS tabela,
    table_type    AS tipo
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;
```

### Listar colunas via information_schema

```sql
SELECT
    table_schema    AS schema,
    table_name      AS tabela,
    column_name     AS coluna,
    ordinal_position AS ordem,
    data_type       AS tipo,
    character_maximum_length AS tamanho_max,
    is_nullable     AS permite_null,
    column_default  AS valor_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;
```

### Listar foreign keys via information_schema

```sql
SELECT
    tc.table_schema    AS schema,
    tc.table_name      AS tabela,
    kcu.column_name    AS coluna,
    ccu.table_name     AS tabela_referenciada,
    ccu.column_name    AS coluna_referenciada,
    rc.update_rule     AS ao_atualizar,
    rc.delete_rule     AS ao_deletar
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
JOIN information_schema.referential_constraints rc
    ON rc.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;
```

---

## Queries Úteis para DBA

### Verificar bloat de tabelas (espaço desperdiçado)

```sql
SELECT
    schemaname AS schema,
    tablename  AS tabela,
    n_dead_tup AS linhas_mortas,
    n_live_tup AS linhas_vivas,
    ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS pct_mortas,
    last_vacuum,
    last_autovacuum
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;
```

### Verificar uso de índices

```sql
SELECT
    schemaname AS schema,
    tablename  AS tabela,
    indexname  AS indice,
    idx_scan   AS qtd_uso,
    idx_tup_read AS linhas_lidas,
    idx_tup_fetch AS linhas_buscadas
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

### Encontrar índices não utilizados

```sql
SELECT
    schemaname AS schema,
    tablename  AS tabela,
    indexname  AS indice,
    pg_size_pretty(pg_relation_size(indexrelid)) AS tamanho
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_relation_size(indexrelid) DESC;
```

---

## Comparativo: pg_catalog vs information_schema

| Característica | pg_catalog | information_schema |
|---|---|---|
| Padrão | PostgreSQL nativo | SQL ANSI / ISO |
| Portabilidade | Apenas PostgreSQL | Multi-SGBD |
| Detalhamento | Muito detalhado | Mais limitado |
| Performance | Mais rápido | Levemente mais lento |
| Uso recomendado | Scripts DBA PostgreSQL | Código portável |

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Leitura apenas | Nunca modifique diretamente as tabelas do pg_catalog |
| Filtros de schema | Sempre filtre `pg_catalog` e `information_schema` nas suas queries |
| Permissões | Usuários comuns têm acesso de leitura ao pg_catalog por padrão |
| Automatização | Use catálogos para gerar scripts DDL e relatórios automatizados |
| Monitoramento | `pg_stat_*` são suas aliadas para diagnóstico de performance |

---

## Referências

- [PostgreSQL Docs - System Catalogs](https://www.postgresql.org/docs/current/catalogs.html)
- [PostgreSQL Docs - information_schema](https://www.postgresql.org/docs/current/information-schema.html)
- [PostgreSQL Docs - pg_stat_activity](https://www.postgresql.org/docs/current/monitoring-stats.html)
