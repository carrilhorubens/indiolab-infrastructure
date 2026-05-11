# PostgreSQL - Casts

## O que são Casts?

Casts definem como o PostgreSQL converte um valor de um tipo de dado em outro.
Essa conversão pode ocorrer de forma automática pelo banco ou de forma explícita
pelo desenvolvedor/DBA. O sistema de casts é fundamental para garantir
compatibilidade entre tipos distintos em expressões, funções e comparações.

---

## Tipos de Cast

### 1. Implicit Cast (Implícito)
O PostgreSQL realiza a conversão automaticamente, sem necessidade de sintaxe
adicional. Ocorre em contextos de atribuição ou em expressões onde os tipos
são compatíveis.

### 2. Assignment Cast
Realizado automaticamente apenas em contextos de atribuição (INSERT, UPDATE).
Não ocorre em expressões gerais.

### 3. Explicit Cast (Explícito)
Requer que o desenvolvedor declare explicitamente a conversão desejada.

---

## Sintaxe

```sql
-- Forma padrão SQL
CAST(valor AS tipo)

-- Forma abreviada PostgreSQL
valor::tipo
```

---

## Exemplos Práticos

### Conversão entre tipos numéricos

```sql
-- Integer para Bigint (implícito)
SELECT 42::bigint;

-- Numeric para Integer (trunca decimais)
SELECT CAST(9.99 AS integer);
-- Resultado: 9

-- Float para Numeric
SELECT 3.14::float8::numeric(10,2);
-- Resultado: 3.14
```

### Conversão entre texto e tipos numéricos

```sql
-- Text para Integer
SELECT CAST('123' AS integer);
SELECT '456'::integer;

-- Integer para Text
SELECT 789::text;
SELECT CAST(100 AS text);

-- Numeric para Text formatado
SELECT 1234567.89::numeric::text;
```

### Conversão com datas e timestamps

```sql
-- Text para Date
SELECT '2024-01-15'::date;
SELECT CAST('2024-01-15' AS date);

-- Text para Timestamp
SELECT '2024-01-15 14:30:00'::timestamp;

-- Date para Timestamp
SELECT CURRENT_DATE::timestamp;

-- Timestamp para Date (descarta horário)
SELECT NOW()::date;

-- Timestamp para Text
SELECT NOW()::text;
```

### Conversão com booleanos

```sql
-- Text para Boolean
SELECT 'true'::boolean;
SELECT 'false'::boolean;
SELECT '1'::boolean;
SELECT '0'::boolean;

-- Boolean para Integer
SELECT true::integer;   -- Resultado: 1
SELECT false::integer;  -- Resultado: 0

-- Boolean para Text
SELECT true::text;   -- Resultado: 'true'
SELECT false::text;  -- Resultado: 'false'
```

### Conversão de tipos geométricos e especiais

```sql
-- Text para UUID
SELECT 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid;

-- Text para JSON
SELECT '{"nome": "Rubens", "ativo": true}'::json;
SELECT '{"nome": "Rubens", "ativo": true}'::jsonb;

-- Text para INET (endereço IP)
SELECT '192.168.1.1'::inet;

-- Bigint para OID
SELECT 12345::oid;
```

---

## Consultando Casts Existentes

### Listar todos os casts do banco

```sql
SELECT
    pg_catalog.format_type(castsource, NULL) AS tipo_origem,
    pg_catalog.format_type(casttarget, NULL) AS tipo_destino,
    CASE castcontext
        WHEN 'e' THEN 'Explícito'
        WHEN 'a' THEN 'Atribuição'
        WHEN 'i' THEN 'Implícito'
    END AS contexto,
    CASE
        WHEN castfunc = 0 THEN 'Binário (sem função)'
        ELSE p.proname
    END AS funcao
FROM pg_catalog.pg_cast c
LEFT JOIN pg_catalog.pg_proc p ON c.castfunc = p.oid
ORDER BY tipo_origem, tipo_destino;
```

### Verificar se um cast específico existe

```sql
SELECT EXISTS (
    SELECT 1
    FROM pg_cast
    WHERE castsource = 'integer'::regtype
      AND casttarget = 'text'::regtype
) AS cast_existe;
```

---

## Criando Casts Customizados

### Passo 1: Criar os tipos e a função de conversão

```sql
-- Criar um tipo customizado
CREATE TYPE status_pedido AS ENUM ('pendente', 'aprovado', 'cancelado');

-- Criar função de conversão de integer para o tipo customizado
CREATE OR REPLACE FUNCTION integer_to_status(integer)
RETURNS status_pedido AS $$
BEGIN
    RETURN CASE $1
        WHEN 0 THEN 'pendente'::status_pedido
        WHEN 1 THEN 'aprovado'::status_pedido
        WHEN 2 THEN 'cancelado'::status_pedido
        ELSE RAISE EXCEPTION 'Valor inválido: %', $1
    END;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;
```

### Passo 2: Registrar o Cast

```sql
-- Cast explícito (requer ::tipo ou CAST())
CREATE CAST (integer AS status_pedido)
    WITH FUNCTION integer_to_status(integer)
    AS ASSIGNMENT;
```

### Passo 3: Utilizar o Cast

```sql
-- Usando o cast criado
SELECT 1::status_pedido;
-- Resultado: aprovado

INSERT INTO pedidos (id, status) VALUES (1, 1);
-- O valor inteiro 1 é convertido automaticamente para 'aprovado'
```

---

## Cast Binário (sem função)

Quando dois tipos têm representação interna idêntica, é possível criar um
cast binário, que é mais eficiente pois não executa nenhuma função:

```sql
-- Exemplo conceitual de cast binário
CREATE CAST (meu_tipo_a AS meu_tipo_b)
    WITHOUT FUNCTION
    AS IMPLICIT;
```

> **Atenção:** Use cast binário apenas quando tiver certeza absoluta de que
> a representação interna dos dois tipos é idêntica. Uso incorreto pode
> causar corrupção de dados.

---

## Removendo um Cast

```sql
DROP CAST (integer AS status_pedido);

-- Com IF EXISTS para evitar erro
DROP CAST IF EXISTS (integer AS status_pedido);
```

---

## Comportamento em Situações Comuns

### Cast em cláusula WHERE

```sql
-- Comparar coluna text com integer (cast implícito pode não ocorrer)
SELECT * FROM pedidos WHERE id = '123';       -- Pode funcionar com cast implícito
SELECT * FROM pedidos WHERE id = '123'::integer; -- Forma segura e explícita
```

### Cast em funções e operadores

```sql
-- Concatenação com tipos mistos
SELECT 'Pedido número: ' || 42::text;
SELECT 'Valor: R$ ' || 199.90::numeric(10,2)::text;
```

### Cast e índices

```sql
-- Cast em WHERE pode impedir uso de índice
-- Evitar:
SELECT * FROM clientes WHERE id::text = '123';

-- Preferir:
SELECT * FROM clientes WHERE id = 123;
```

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Legibilidade | Prefira `CAST(x AS tipo)` em código SQL formal |
| Performance | Prefira `x::tipo` em queries interativas |
| Índices | Nunca aplique cast em colunas indexadas no WHERE |
| Dados externos | Sempre valide antes de converter TEXT para tipos estritos |
| Casts customizados | Documente e teste exaustivamente antes de usar AS IMPLICIT |

---

## Referências

- [PostgreSQL Docs - Type Casts](https://www.postgresql.org/docs/current/sql-expressions.html#SQL-SYNTAX-TYPE-CASTS)
- [PostgreSQL Docs - CREATE CAST](https://www.postgresql.org/docs/current/sql-createcast.html)
- [PostgreSQL Docs - pg_cast catalog](https://www.postgresql.org/docs/current/catalog-pg-cast.html)
