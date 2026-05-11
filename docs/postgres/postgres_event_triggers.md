# PostgreSQL - Event Triggers

## O que são Event Triggers?

Event Triggers são gatilhos que disparam em resposta a eventos DDL (Data
Definition Language) no banco de dados, como `CREATE`, `ALTER`, `DROP`,
`TRUNCATE`, entre outros. Diferente dos triggers comuns (que respondem a
operações DML como INSERT, UPDATE, DELETE em tabelas específicas), os Event
Triggers atuam em nível de banco de dados e capturam mudanças estruturais.

Introduzidos no PostgreSQL 9.3, são amplamente utilizados para:

- Auditoria de mudanças estruturais
- Bloqueio de operações DDL não autorizadas
- Logging automático de deploys e migrações
- Enforçamento de padrões de nomenclatura
- Proteção de objetos críticos contra remoção acidental

---

## Eventos Suportados

| Evento | Quando dispara |
|---|---|
| `ddl_command_start` | Antes da execução de qualquer comando DDL |
| `ddl_command_end` | Após a execução bem-sucedida de um comando DDL |
| `sql_drop` | Quando objetos são removidos (DROP) |
| `table_rewrite` | Quando uma tabela é reescrita (ALTER com mudança de tipo) |

---

## Funções Especiais de Suporte

Dentro de uma função de Event Trigger, funções especiais fornecem contexto
sobre o evento ocorrido:

| Função | Disponível em | Retorna |
|---|---|---|
| `pg_event_trigger_ddl_commands()` | `ddl_command_end` | Detalhes dos comandos DDL executados |
| `pg_event_trigger_dropped_objects()` | `sql_drop` | Objetos que foram removidos |
| `pg_event_trigger_table_rewrite_oid()` | `table_rewrite` | OID da tabela reescrita |
| `pg_event_trigger_table_rewrite_reason()` | `table_rewrite` | Motivo da reescrita |

---

## Estrutura Básica

### 1. Criar a função do Event Trigger

```sql
CREATE OR REPLACE FUNCTION nome_da_funcao()
RETURNS event_trigger
LANGUAGE plpgsql AS $$
BEGIN
    -- lógica aqui
END;
$$;
```

> A função deve retornar `event_trigger` e não aceita parâmetros.
> Variáveis especiais `TG_EVENT` e `TG_TAG` ficam disponíveis automaticamente.

### 2. Criar o Event Trigger

```sql
CREATE EVENT TRIGGER nome_do_trigger
ON evento
-- WHEN TAG IN ('comando1', 'comando2')  -- opcional
EXECUTE FUNCTION nome_da_funcao();
```

---

## Variáveis Automáticas Disponíveis

| Variável | Tipo | Conteúdo |
|---|---|---|
| `TG_EVENT` | text | Nome do evento (`ddl_command_start`, etc.) |
| `TG_TAG` | text | Tipo do comando DDL (`CREATE TABLE`, `DROP INDEX`, etc.) |

---

## Exemplos Práticos

### Exemplo 1 — Log completo de operações DDL

```sql
-- Tabela de auditoria DDL
CREATE TABLE IF NOT EXISTS audit_ddl (
    id          BIGSERIAL PRIMARY KEY,
    evento      TEXT,
    comando     TEXT,
    objeto_tipo TEXT,
    objeto_nome TEXT,
    schema_nome TEXT,
    usuario     TEXT,
    aplicacao   TEXT,
    ip_cliente  TEXT,
    ocorrido_em TIMESTAMPTZ DEFAULT NOW()
);

-- Função de auditoria
CREATE OR REPLACE FUNCTION fn_audit_ddl()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        INSERT INTO audit_ddl (
            evento, comando, objeto_tipo, objeto_nome, schema_nome,
            usuario, aplicacao, ip_cliente
        )
        VALUES (
            TG_EVENT,
            TG_TAG,
            obj.object_type,
            obj.object_identity,
            obj.schema_name,
            current_user,
            current_setting('application_name'),
            inet_client_addr()::text
        );
    END LOOP;
END;
$$;

-- Criar o Event Trigger
CREATE EVENT TRIGGER et_audit_ddl
ON ddl_command_end
EXECUTE FUNCTION fn_audit_ddl();
```

### Exemplo 2 — Log de objetos removidos (DROP)

```sql
CREATE TABLE IF NOT EXISTS audit_drops (
    id          BIGSERIAL PRIMARY KEY,
    objeto_tipo TEXT,
    objeto_nome TEXT,
    schema_nome TEXT,
    usuario     TEXT,
    ocorrido_em TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION fn_audit_drop()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
    LOOP
        INSERT INTO audit_drops (
            objeto_tipo, objeto_nome, schema_nome, usuario
        )
        VALUES (
            obj.object_type,
            obj.object_name,
            obj.schema_name,
            current_user
        );
    END LOOP;
END;
$$;

CREATE EVENT TRIGGER et_audit_drop
ON sql_drop
EXECUTE FUNCTION fn_audit_drop();
```

### Exemplo 3 — Bloquear DROP em ambiente de produção

```sql
CREATE OR REPLACE FUNCTION fn_bloquear_drop()
RETURNS event_trigger
LANGUAGE plpgsql AS $$
BEGIN
    -- Permite apenas superusers fazerem DROP
    IF NOT pg_has_role(current_user, 'pg_maintain', 'MEMBER')
       AND NOT (SELECT rolsuper FROM pg_roles WHERE rolname = current_user)
    THEN
        RAISE EXCEPTION
            'DROP bloqueado em produção. Usuário: %. Contate o DBA.',
            current_user;
    END IF;
END;
$$;

CREATE EVENT TRIGGER et_bloquear_drop
ON sql_drop
EXECUTE FUNCTION fn_bloquear_drop();
```

### Exemplo 4 — Bloquear DROP apenas em tabelas específicas

```sql
CREATE OR REPLACE FUNCTION fn_proteger_tabelas_criticas()
RETURNS event_trigger
LANGUAGE plpgsql AS $$
DECLARE
    obj record;
    tabelas_criticas TEXT[] := ARRAY[
        'public.clientes',
        'public.pedidos',
        'financeiro.lancamentos'
    ];
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
    LOOP
        IF obj.object_type = 'table'
           AND obj.object_identity = ANY(tabelas_criticas)
        THEN
            RAISE EXCEPTION
                'Tabela crítica protegida: %. DROP não permitido.',
                obj.object_identity;
        END IF;
    END LOOP;
END;
$$;

CREATE EVENT TRIGGER et_proteger_criticas
ON sql_drop
EXECUTE FUNCTION fn_proteger_tabelas_criticas();
```

### Exemplo 5 — Enforçar padrão de nomenclatura

```sql
CREATE OR REPLACE FUNCTION fn_validar_nomenclatura()
RETURNS event_trigger
LANGUAGE plpgsql AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        -- Tabelas devem começar com letra minúscula e usar snake_case
        IF obj.object_type = 'table'
           AND obj.object_identity !~ '^[a-z][a-z0-9_]*\.[a-z][a-z0-9_]*$'
        THEN
            RAISE EXCEPTION
                'Nome de tabela inválido: %. Use snake_case (ex: minha_tabela).',
                obj.object_identity;
        END IF;
    END LOOP;
END;
$$;

CREATE EVENT TRIGGER et_validar_nomenclatura
ON ddl_command_end
WHEN TAG IN ('CREATE TABLE')
EXECUTE FUNCTION fn_validar_nomenclatura();
```

### Exemplo 6 — Filtrar eventos por tipo de comando (WHEN TAG)

```sql
-- Disparar apenas para CREATE TABLE e CREATE INDEX
CREATE EVENT TRIGGER et_apenas_creates
ON ddl_command_end
WHEN TAG IN ('CREATE TABLE', 'CREATE INDEX', 'CREATE VIEW')
EXECUTE FUNCTION fn_audit_ddl();

-- Disparar apenas para ALTER TABLE
CREATE EVENT TRIGGER et_apenas_alter
ON ddl_command_end
WHEN TAG IN ('ALTER TABLE')
EXECUTE FUNCTION fn_audit_ddl();
```

### Exemplo 7 — Detectar reescrita de tabela

```sql
CREATE OR REPLACE FUNCTION fn_detectar_rewrite()
RETURNS event_trigger
LANGUAGE plpgsql AS $$
DECLARE
    tabela_oid OID;
    razao INT;
BEGIN
    tabela_oid := pg_event_trigger_table_rewrite_oid();
    razao      := pg_event_trigger_table_rewrite_reason();

    RAISE NOTICE
        'Reescrita de tabela detectada. OID: %, Tabela: %, Razão: %',
        tabela_oid,
        tabela_oid::regclass,
        razao;
END;
$$;

CREATE EVENT TRIGGER et_rewrite
ON table_rewrite
EXECUTE FUNCTION fn_detectar_rewrite();
```

---

## Gerenciando Event Triggers

### Listar Event Triggers existentes

```sql
SELECT
    evtname        AS nome,
    evtevent       AS evento,
    evtenabled     AS habilitado,
    evtfoid::regproc AS funcao,
    evttags        AS filtros_tag,
    pg_catalog.pg_get_userbyid(evtowner) AS dono
FROM pg_event_trigger
ORDER BY evtname;
```

### Desabilitar um Event Trigger temporariamente

```sql
-- Útil durante manutenções ou migrações
ALTER EVENT TRIGGER et_audit_ddl DISABLE;

-- Reabilitar depois
ALTER EVENT TRIGGER et_audit_ddl ENABLE;

-- Habilitar apenas para réplicas
ALTER EVENT TRIGGER et_audit_ddl ENABLE REPLICA;

-- Habilitar sempre (inclusive em réplicas)
ALTER EVENT TRIGGER et_audit_ddl ENABLE ALWAYS;
```

### Remover um Event Trigger

```sql
DROP EVENT TRIGGER IF EXISTS et_audit_ddl;
DROP EVENT TRIGGER IF EXISTS et_audit_drop;
```

---

## Considerações de Segurança

### SECURITY DEFINER
Funções de Event Trigger geralmente são criadas com `SECURITY DEFINER` para
garantir que tenham permissão de inserir na tabela de auditoria,
independentemente de quem executou o DDL.

```sql
CREATE OR REPLACE FUNCTION fn_minha_funcao()
RETURNS event_trigger
LANGUAGE plpgsql
SECURITY DEFINER AS $$
BEGIN
    -- Executa com os privilégios do dono da função
END;
$$;
```

### Quem pode criar Event Triggers?
Apenas **superusers** podem criar Event Triggers por padrão.

```sql
-- Verificar se o usuário atual é superuser
SELECT rolsuper FROM pg_roles WHERE rolname = current_user;
```

---

## Limitações

| Limitação | Detalhe |
|---|---|
| Sem acesso a DML | Event Triggers não são acionados por INSERT/UPDATE/DELETE |
| Apenas DDL | Focados exclusivamente em operações de estrutura |
| Superuser obrigatório | Somente superusers criam Event Triggers |
| Sem parâmetros | A função não recebe parâmetros; usa variáveis automáticas |
| Loop infinito | Cuidado com triggers que executam DDL dentro de si mesmos |

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Desabilite durante manutenção | Use `DISABLE` antes de migrações pesadas |
| Use WHEN TAG | Filtre apenas os comandos relevantes para evitar overhead |
| Tabela de auditoria particionada | Em produção, particione `audit_ddl` por data |
| Nunca bloqueie no `ddl_command_start` | Prefira `ddl_command_end` para ter mais contexto |
| Teste em homologação | Triggers bloqueantes mal configurados travam o banco |

---

## Referências

- [PostgreSQL Docs - Event Triggers](https://www.postgresql.org/docs/current/event-triggers.html)
- [PostgreSQL Docs - CREATE EVENT TRIGGER](https://www.postgresql.org/docs/current/sql-createeventtrigger.html)
- [PostgreSQL Docs - pg_event_trigger_ddl_commands](https://www.postgresql.org/docs/current/functions-event-triggers.html)
