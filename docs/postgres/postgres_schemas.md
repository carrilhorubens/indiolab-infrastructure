# PostgreSQL - Schemas

## O que são Schemas?

Schemas são namespaces lógicos dentro de um banco de dados PostgreSQL que
organizam e agrupam objetos como tabelas, views, funções, sequences, tipos,
índices e outros. Funcionam como "pastas" dentro do banco, permitindo separar
logicamente diferentes partes de uma aplicação sem precisar criar bancos de
dados separados.

Todo banco de dados PostgreSQL possui ao menos dois schemas criados
automaticamente:

| Schema | Descrição |
|---|---|
| `public` | Schema padrão para objetos criados sem especificação de schema |
| `pg_catalog` | Catálogo do sistema — tabelas internas do PostgreSQL |
| `information_schema` | Visão padronizada SQL ANSI dos metadados |
| `pg_temp_*` | Schemas temporários por sessão |

---

## Por que usar Schemas?

- **Organização**: Separar módulos de uma aplicação (vendas, financeiro, rh)
- **Multitenancy**: Isolar dados de múltiplos clientes/empresas no mesmo banco
- **Segurança**: Controle granular de permissões por namespace
- **Evitar conflitos**: Objetos com mesmo nome em schemas diferentes coexistem
- **Manutenção**: Facilita backups e restaurações por módulo
- **Extensions**: Instalar extensions em schema dedicado, fora do `public`

---

## Comandos Essenciais

### Criar schema

```sql
-- Schema simples
CREATE SCHEMA vendas;

-- Schema com dono específico
CREATE SCHEMA financeiro AUTHORIZATION usuario_financeiro;

-- Schema sem erro se já existir
CREATE SCHEMA IF NOT EXISTS rh;

-- Criar schema e objetos em um único comando
CREATE SCHEMA estoque
    CREATE TABLE produtos (
        id    SERIAL PRIMARY KEY,
        nome  TEXT NOT NULL,
        preco NUMERIC(10,2)
    )
    CREATE VIEW vw_produtos_ativos AS
        SELECT * FROM produtos WHERE ativo = true;
```

### Listar schemas

```sql
-- Via catálogo
SELECT
    nspname   AS schema,
    pg_catalog.pg_get_userbyid(nspowner) AS dono,
    nspacl    AS permissoes,
    obj_description(oid, 'pg_namespace') AS descricao
FROM pg_namespace
ORDER BY nspname;

-- Via information_schema
SELECT
    schema_name      AS schema,
    schema_owner     AS dono
FROM information_schema.schemata
ORDER BY schema_name;

-- Comando psql
\dn
\dn+   -- com permissões
```

### Alterar schema

```sql
-- Renomear schema
ALTER SCHEMA vendas RENAME TO comercial;

-- Transferir propriedade
ALTER SCHEMA financeiro OWNER TO novo_dono;
```

### Remover schema

```sql
-- Remover schema vazio
DROP SCHEMA IF EXISTS vendas;

-- Remover schema e todos os seus objetos
DROP SCHEMA IF EXISTS vendas CASCADE;
```

---

## Search Path

O `search_path` define a ordem em que o PostgreSQL procura objetos quando
o schema não é especificado explicitamente. É análogo ao PATH do sistema
operacional.

### Verificar search_path atual

```sql
SHOW search_path;
-- Resultado padrão: "$user", public
-- "$user" = schema com mesmo nome do usuário atual (se existir)
```

### Alterar search_path na sessão

```sql
-- Temporário (apenas para a sessão atual)
SET search_path TO vendas, public;

-- Consultar tabela sem prefixo de schema
SELECT * FROM pedidos;  -- Procura em vendas.pedidos, depois public.pedidos
```

### Alterar search_path permanentemente

```sql
-- Para um usuário específico
ALTER ROLE meu_usuario SET search_path TO vendas, financeiro, public;

-- Para um banco de dados específico
ALTER DATABASE meu_banco SET search_path TO app, public;

-- Para a sessão atual permanentemente (dentro do postgresql.conf)
-- search_path = '"$user", public'
```

### Boas práticas com search_path

```sql
-- Sempre qualifique objetos em código de produção
SELECT * FROM vendas.pedidos;          -- Correto e explícito
SELECT * FROM pedidos;                 -- Depende do search_path

-- Verificar em qual schema um objeto foi encontrado
SELECT n.nspname, c.relname
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relname = 'pedidos';
```

---

## Organização por Módulos de Negócio

### Estrutura recomendada para sistema ERP

```sql
-- Criar schemas por módulo
CREATE SCHEMA vendas;
CREATE SCHEMA financeiro;
CREATE SCHEMA estoque;
CREATE SCHEMA rh;
CREATE SCHEMA fiscal;
CREATE SCHEMA relatorios;
CREATE SCHEMA auditoria;
CREATE SCHEMA extensions;  -- para extensões do PostgreSQL

-- Instalar extensions em schema dedicado
CREATE EXTENSION pg_trgm    SCHEMA extensions;
CREATE EXTENSION uuid-ossp  SCHEMA extensions;
CREATE EXTENSION pgcrypto   SCHEMA extensions;
```

### Criando objetos em schemas específicos

```sql
-- Tabelas no schema vendas
CREATE TABLE vendas.pedidos (
    id          BIGSERIAL PRIMARY KEY,
    cliente_id  BIGINT NOT NULL,
    data_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    valor_total NUMERIC(15,2),
    status      TEXT DEFAULT 'pendente'
);

CREATE TABLE vendas.itens_pedido (
    id         BIGSERIAL PRIMARY KEY,
    pedido_id  BIGINT REFERENCES vendas.pedidos(id),
    produto_id BIGINT NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unit NUMERIC(10,2) NOT NULL
);

-- Tabelas no schema financeiro
CREATE TABLE financeiro.lancamentos (
    id          BIGSERIAL PRIMARY KEY,
    data        DATE NOT NULL,
    descricao   TEXT,
    valor       NUMERIC(15,2) NOT NULL,
    tipo        CHAR(1) CHECK (tipo IN ('D','C')),
    pedido_id   BIGINT REFERENCES vendas.pedidos(id)
);

-- Tabelas no schema auditoria
CREATE TABLE auditoria.log_ddl (
    id          BIGSERIAL PRIMARY KEY,
    evento      TEXT,
    objeto      TEXT,
    usuario     TEXT,
    ocorrido_em TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Multitenancy com Schemas

Padrão comum para SaaS: um schema por cliente/empresa no mesmo banco.

```sql
-- Criar schema por empresa
CREATE SCHEMA empresa_001;
CREATE SCHEMA empresa_002;
CREATE SCHEMA empresa_003;

-- Cada empresa tem sua própria estrutura isolada
CREATE TABLE empresa_001.clientes (
    id   SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE empresa_002.clientes (
    id   SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

-- Função para provisionar novo cliente
CREATE OR REPLACE FUNCTION fn_provisionar_empresa(p_codigo TEXT)
RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
    -- Criar schema para a empresa
    EXECUTE format('CREATE SCHEMA %I', 'empresa_' || p_codigo);

    -- Criar estrutura de tabelas
    EXECUTE format('
        CREATE TABLE %I.clientes (
            id   SERIAL PRIMARY KEY,
            nome TEXT NOT NULL,
            email TEXT UNIQUE
        )', 'empresa_' || p_codigo);

    EXECUTE format('
        CREATE TABLE %I.pedidos (
            id          SERIAL PRIMARY KEY,
            cliente_id  INTEGER REFERENCES %I.clientes(id),
            data_pedido DATE DEFAULT CURRENT_DATE,
            valor_total NUMERIC(15,2)
        )', 'empresa_' || p_codigo, 'empresa_' || p_codigo);

    RAISE NOTICE 'Schema empresa_% provisionado com sucesso.', p_codigo;
END;
$$;

-- Provisionar nova empresa
SELECT fn_provisionar_empresa('004');

-- Acessar dados de uma empresa específica
SET search_path TO empresa_001;
SELECT * FROM clientes;

-- Ou com schema explícito
SELECT * FROM empresa_002.pedidos;
```

---

## Controle de Permissões por Schema

```sql
-- Revogar acesso público ao schema public (boa prática de segurança)
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;

-- Criar roles por módulo
CREATE ROLE role_vendas;
CREATE ROLE role_financeiro;
CREATE ROLE role_relatorios;

-- Conceder uso e criação no schema correspondente
GRANT USAGE  ON SCHEMA vendas      TO role_vendas;
GRANT CREATE ON SCHEMA vendas      TO role_vendas;
GRANT USAGE  ON SCHEMA financeiro  TO role_financeiro;
GRANT CREATE ON SCHEMA financeiro  TO role_financeiro;

-- Role de relatórios pode LER de múltiplos schemas
GRANT USAGE ON SCHEMA vendas      TO role_relatorios;
GRANT USAGE ON SCHEMA financeiro  TO role_relatorios;
GRANT USAGE ON SCHEMA estoque     TO role_relatorios;

-- Conceder SELECT em todas as tabelas existentes
GRANT SELECT ON ALL TABLES IN SCHEMA vendas     TO role_relatorios;
GRANT SELECT ON ALL TABLES IN SCHEMA financeiro TO role_relatorios;

-- Conceder SELECT em tabelas futuras automaticamente
ALTER DEFAULT PRIVILEGES IN SCHEMA vendas
    GRANT SELECT ON TABLES TO role_relatorios;

ALTER DEFAULT PRIVILEGES IN SCHEMA financeiro
    GRANT SELECT ON TABLES TO role_relatorios;

-- Associar usuários às roles
GRANT role_vendas      TO usuario_vendas;
GRANT role_financeiro  TO usuario_financeiro;
GRANT role_relatorios  TO usuario_bi, usuario_gerente;
```

---

## Listando Objetos por Schema

### Tabelas por schema

```sql
SELECT
    table_schema  AS schema,
    table_name    AS tabela,
    table_type    AS tipo
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_schema, table_name;
```

### Tamanho total por schema

```sql
SELECT
    n.nspname AS schema,
    pg_size_pretty(SUM(pg_total_relation_size(c.oid))) AS tamanho_total,
    COUNT(*) AS qtd_tabelas
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'
  AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
GROUP BY n.nspname
ORDER BY SUM(pg_total_relation_size(c.oid)) DESC;
```

### Funções por schema

```sql
SELECT
    n.nspname  AS schema,
    p.proname  AS funcao,
    pg_get_function_arguments(p.oid) AS argumentos,
    l.lanname  AS linguagem
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
JOIN pg_language l  ON l.oid = p.prolang
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY n.nspname, p.proname;
```

### Permissões por schema

```sql
SELECT
    nspname   AS schema,
    pg_catalog.pg_get_userbyid(nspowner) AS dono,
    ARRAY(
        SELECT pg_catalog.pg_get_userbyid(acl.grantee)
               || ': ' || string_agg(acl.privilege_type, ', ')
        FROM (
            SELECT (aclexplode(nspacl)).*
        ) acl
        GROUP BY acl.grantee
    ) AS permissoes
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname != 'information_schema'
ORDER BY nspname;
```

---

## Movendo Objetos entre Schemas

```sql
-- Mover tabela de schema
ALTER TABLE public.pedidos SET SCHEMA vendas;

-- Mover função de schema
ALTER FUNCTION public.fn_calcular_total(NUMERIC, NUMERIC)
    SET SCHEMA vendas;

-- Mover view de schema
ALTER VIEW public.vw_resumo_vendas SET SCHEMA relatorios;

-- Mover sequence de schema
ALTER SEQUENCE public.pedidos_id_seq SET SCHEMA vendas;
```

---

## Clonando Estrutura de Schema

```sql
-- Script para gerar DDL de todos os objetos de um schema
-- (útil para criar schema de homologação baseado em produção)

SELECT
    'CREATE TABLE ' || quote_ident(schemaname) || '.' ||
    quote_ident(tablename) || ' (LIKE ' ||
    quote_ident(schemaname) || '.' || quote_ident(tablename) ||
    ' INCLUDING ALL);' AS ddl
FROM pg_tables
WHERE schemaname = 'vendas'
ORDER BY tablename;
```

---

## Schemas Temporários

```sql
-- Tabelas temporárias vão automaticamente para pg_temp_<n>
CREATE TEMP TABLE tmp_processamento (
    id    SERIAL,
    dados TEXT
);

-- Visíveis sem prefixo de schema na sessão atual
INSERT INTO tmp_processamento (dados) VALUES ('teste');
SELECT * FROM tmp_processamento;

-- Removidas automaticamente ao final da sessão
-- Para remover antes:
DROP TABLE IF EXISTS tmp_processamento;
```

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Prefixo explícito | Sempre use `schema.tabela` em código de produção |
| Schema para extensions | Instale extensions em schema dedicado (`extensions`) |
| Revogar public | Remova o acesso padrão ao schema `public` em produção |
| Roles por schema | Crie roles alinhadas aos schemas de negócio |
| Default privileges | Configure `ALTER DEFAULT PRIVILEGES` para automatizar permissões |
| Sem espaços | Use snake_case nos nomes de schemas |
| Documentação | Use `COMMENT ON SCHEMA` para documentar a finalidade |

```sql
-- Documentar schemas
COMMENT ON SCHEMA vendas     IS 'Módulo de vendas: pedidos, clientes, produtos';
COMMENT ON SCHEMA financeiro IS 'Módulo financeiro: lançamentos, contas, fluxo de caixa';
COMMENT ON SCHEMA auditoria  IS 'Logs de auditoria DDL e DML';
```

---

## Referências

- [PostgreSQL Docs - Schemas](https://www.postgresql.org/docs/current/ddl-schemas.html)
- [PostgreSQL Docs - CREATE SCHEMA](https://www.postgresql.org/docs/current/sql-createschema.html)
- [PostgreSQL Docs - search_path](https://www.postgresql.org/docs/current/runtime-config-client.html#GUC-SEARCH-PATH)
- [PostgreSQL Docs - Privileges](https://www.postgresql.org/docs/current/ddl-priv.html)
