# PostgreSQL - Extensions

## O que são Extensions?

Extensions (extensões) são módulos empacotados que adicionam funcionalidades
ao PostgreSQL sem necessidade de modificar o código-fonte do banco. Cada
extensão pode incluir tipos de dados, funções, operadores, índices, views e
outros objetos que passam a fazer parte do banco após a instalação.

São instaladas com o comando `CREATE EXTENSION` e gerenciadas pelo sistema
de pacotes do PostgreSQL. Muitas extensões já vêm incluídas na instalação
padrão do PostgreSQL (contrib), enquanto outras precisam ser instaladas
separadamente no sistema operacional antes de serem ativadas no banco.

---

## Ciclo de Vida de uma Extension

```
Instalar no SO  →  CREATE EXTENSION  →  Usar no banco  →  DROP EXTENSION
(apt/yum/dnf)       (dentro do banco)
```

---

## Extensions Incluídas (contrib)

Disponíveis em praticamente toda instalação padrão do PostgreSQL:

| Extension | Finalidade |
|---|---|
| `pg_stat_statements` | Monitoramento e estatísticas de queries |
| `pg_trgm` | Busca por similaridade de texto (trigrams) |
| `uuid-ossp` | Geração de UUIDs |
| `hstore` | Armazenamento de pares chave-valor |
| `ltree` | Dados hierárquicos em árvore |
| `tablefunc` | Funções de tabela (crosstab/pivot) |
| `fuzzystrmatch` | Algoritmos de similaridade fonética |
| `unaccent` | Remoção de acentos em buscas |
| `pgcrypto` | Funções criptográficas |
| `dblink` | Conexão com outros bancos PostgreSQL |
| `postgres_fdw` | Foreign Data Wrapper para PostgreSQL |
| `file_fdw` | Foreign Data Wrapper para arquivos |
| `citext` | Tipo texto case-insensitive |
| `intarray` | Operações em arrays de inteiros |
| `btree_gin` | Suporte GIN para tipos btree |
| `btree_gist` | Suporte GiST para tipos btree |

## Extensions Populares (instalação separada)

| Extension | Finalidade |
|---|---|
| `PostGIS` | Dados geoespaciais e geográficos |
| `TimescaleDB` | Séries temporais e time-series |
| `pg_partman` | Gerenciamento automático de particionamento |
| `pgAudit` | Auditoria avançada de operações |
| `pg_repack` | Reorganização de tabelas sem lock |
| `pg_bouncer` | Pool de conexões (não é extension, mas complementar) |
| `citus` | Banco de dados distribuído |
| `pgvector` | Armazenamento e busca de vetores (IA/ML) |

---

## Comandos Essenciais

### Listar extensions disponíveis no sistema

```sql
SELECT
    name,
    default_version  AS versao_padrao,
    installed_version AS versao_instalada,
    comment          AS descricao
FROM pg_available_extensions
ORDER BY name;
```

### Listar extensions instaladas no banco atual

```sql
SELECT
    extname    AS extensao,
    extversion AS versao,
    n.nspname  AS schema,
    extrelocatable AS relocavel
FROM pg_extension e
JOIN pg_namespace n ON n.oid = e.extnamespace
ORDER BY extname;
```

### Instalar uma extension

```sql
-- Instalar no schema padrão (public ou search_path)
CREATE EXTENSION nome_da_extension;

-- Instalar em schema específico
CREATE EXTENSION nome_da_extension SCHEMA nome_schema;

-- Instalar sem erro se já existir
CREATE EXTENSION IF NOT EXISTS nome_da_extension;

-- Instalar versão específica
CREATE EXTENSION nome_da_extension VERSION '1.5';
```

### Atualizar uma extension

```sql
-- Atualizar para a versão mais recente disponível
ALTER EXTENSION nome_da_extension UPDATE;

-- Atualizar para versão específica
ALTER EXTENSION nome_da_extension UPDATE TO '2.0';
```

### Remover uma extension

```sql
DROP EXTENSION nome_da_extension;

-- Com IF EXISTS
DROP EXTENSION IF EXISTS nome_da_extension;

-- Forçar remoção mesmo com dependências
DROP EXTENSION nome_da_extension CASCADE;
```

---

## Exemplos Práticos por Extension

---

### pg_stat_statements — Monitoramento de Queries

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Necessário no postgresql.conf:
-- shared_preload_libraries = 'pg_stat_statements'
-- pg_stat_statements.track = all

-- Top 10 queries mais lentas
SELECT
    LEFT(query, 100)                          AS query,
    calls                                     AS chamadas,
    ROUND(total_exec_time::numeric, 2)        AS tempo_total_ms,
    ROUND(mean_exec_time::numeric, 2)         AS tempo_medio_ms,
    ROUND(stddev_exec_time::numeric, 2)       AS desvio_padrao_ms,
    rows                                      AS linhas_retornadas
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Queries com mais I/O
SELECT
    LEFT(query, 100) AS query,
    calls,
    shared_blks_read + shared_blks_written AS total_io_blocks
FROM pg_stat_statements
ORDER BY total_io_blocks DESC
LIMIT 10;

-- Resetar estatísticas
SELECT pg_stat_statements_reset();
```

---

### uuid-ossp — Geração de UUIDs

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Gerar UUID v4 (aleatório) — mais comum
SELECT uuid_generate_v4();

-- Gerar UUID v1 (baseado em timestamp e MAC)
SELECT uuid_generate_v1();

-- Usar como valor default em tabela
CREATE TABLE clientes (
    id      UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    nome    TEXT NOT NULL,
    email   TEXT UNIQUE NOT NULL
);

INSERT INTO clientes (nome, email)
VALUES ('Rubens', 'rubens@empresa.com');

SELECT * FROM clientes;
```

---

### pg_trgm — Busca por Similaridade

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Verificar similaridade entre duas strings
SELECT similarity('PostgreSQL', 'PostGresql');
-- Resultado: ~0.7

-- Busca por similaridade em tabela
SELECT nome, similarity(nome, 'Rubems') AS score
FROM clientes
WHERE nome % 'Rubems'   -- operador de similaridade
ORDER BY score DESC;

-- Criar índice GIN para busca rápida por similaridade
CREATE INDEX idx_clientes_nome_trgm
ON clientes USING GIN (nome gin_trgm_ops);

-- Busca LIKE também se beneficia do índice trgm
CREATE INDEX idx_clientes_nome_trgm2
ON clientes USING GIN (nome gin_trgm_ops);

SELECT * FROM clientes
WHERE nome ILIKE '%ubens%';
```

---

### pgcrypto — Criptografia

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Hash de senha com bcrypt
SELECT crypt('minha_senha_secreta', gen_salt('bf'));

-- Verificar senha
SELECT (crypt('minha_senha_secreta', senha_hash) = senha_hash) AS senha_correta
FROM usuarios
WHERE login = 'rubens';

-- Criptografia simétrica
SELECT pgp_sym_encrypt('dados sensíveis', 'chave_secreta');
SELECT pgp_sym_decrypt(
    pgp_sym_encrypt('dados sensíveis', 'chave_secreta'),
    'chave_secreta'
);

-- Gerar bytes aleatórios
SELECT encode(gen_random_bytes(16), 'hex');

-- Hash MD5 e SHA
SELECT md5('texto');
SELECT encode(digest('texto', 'sha256'), 'hex');
```

---

### hstore — Chave-Valor

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS hstore;

-- Criar tabela com coluna hstore
CREATE TABLE produtos (
    id         SERIAL PRIMARY KEY,
    nome       TEXT,
    atributos  HSTORE
);

-- Inserir dados
INSERT INTO produtos (nome, atributos) VALUES
    ('Notebook', 'marca => Dell, ram => 16GB, ssd => 512GB, cor => prata'),
    ('Monitor',  'marca => LG, tamanho => 27pol, resolucao => 4K');

-- Consultar atributo específico
SELECT nome, atributos -> 'marca' AS marca FROM produtos;

-- Filtrar por atributo
SELECT * FROM produtos WHERE atributos -> 'marca' = 'Dell';

-- Verificar se atributo existe
SELECT * FROM produtos WHERE atributos ? 'ssd';

-- Adicionar atributo
UPDATE produtos
SET atributos = atributos || 'garantia => 2anos'::hstore
WHERE id = 1;
```

---

### tablefunc — Tabelas Pivô (Crosstab)

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Dados de exemplo
CREATE TABLE vendas_mensais (
    vendedor TEXT,
    mes      TEXT,
    valor    NUMERIC
);

INSERT INTO vendas_mensais VALUES
    ('Ana',   'Jan', 10000),
    ('Ana',   'Fev', 12000),
    ('Bruno', 'Jan',  8000),
    ('Bruno', 'Fev',  9500);

-- Gerar relatório pivô
SELECT *
FROM crosstab(
    'SELECT vendedor, mes, valor FROM vendas_mensais ORDER BY 1, 2',
    'SELECT DISTINCT mes FROM vendas_mensais ORDER BY 1'
) AS pivot (vendedor TEXT, "Jan" NUMERIC, "Fev" NUMERIC);
```

---

### unaccent — Busca sem Acentos

```sql
-- Instalar
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Remover acentos
SELECT unaccent('São Paulo é incrível');
-- Resultado: Sao Paulo e incrivel

-- Criar configuração de busca full-text sem acentos
CREATE TEXT SEARCH CONFIGURATION pt_unaccent (COPY = portuguese);
ALTER TEXT SEARCH CONFIGURATION pt_unaccent
    ALTER MAPPING FOR hword, hword_part, word
    WITH unaccent, portuguese_stem;

-- Busca insensível a acentos
SELECT * FROM clientes
WHERE unaccent(nome) ILIKE unaccent('%joao%');
```

---

### pgvector — Vetores para IA/ML

```sql
-- Requer instalação no SO: apt install postgresql-16-pgvector
-- Instalar
CREATE EXTENSION IF NOT EXISTS vector;

-- Criar tabela com coluna de vetor
CREATE TABLE documentos (
    id        SERIAL PRIMARY KEY,
    conteudo  TEXT,
    embedding VECTOR(1536)  -- dimensão para OpenAI embeddings
);

-- Inserir vetor
INSERT INTO documentos (conteudo, embedding)
VALUES ('Texto de exemplo', '[0.1, 0.2, 0.3, ...]');

-- Busca por similaridade coseno (mais próximo)
SELECT conteudo, 1 - (embedding <=> '[0.1, 0.2, ...]'::vector) AS similaridade
FROM documentos
ORDER BY embedding <=> '[0.1, 0.2, ...]'::vector
LIMIT 5;

-- Criar índice HNSW para busca aproximada rápida
CREATE INDEX idx_documentos_embedding
ON documentos USING hnsw (embedding vector_cosine_ops);
```

---

## Instalando Extensions no Sistema Operacional

### Debian / Ubuntu

```bash
# Extensions contrib (incluídas no pacote contrib)
apt install postgresql-contrib

# PostGIS
apt install postgresql-16-postgis-3

# pgvector
apt install postgresql-16-pgvector

# pg_partman
apt install postgresql-16-partman

# TimescaleDB
apt install timescaledb-2-postgresql-16
```

### RHEL / CentOS / Rocky Linux

```bash
# Repositório PGDG
dnf install postgresql16-contrib
dnf install postgis33_16
dnf install pgvector_16
```

---

## Configurações no postgresql.conf

Algumas extensions requerem configuração prévia:

```ini
# pg_stat_statements — deve ser carregada no startup
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000

# TimescaleDB
shared_preload_libraries = 'timescaledb'

# pgAudit
shared_preload_libraries = 'pgaudit'
pgaudit.log = 'write, ddl'
```

> Após alterar `shared_preload_libraries`, é necessário reiniciar o PostgreSQL.

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Schema dedicado | Instale extensions em schema separado (ex: `extensions`) |
| Controle de versão | Registre a versão de cada extension no seu runbook |
| Ambientes iguais | Mantenha as mesmas extensions em dev, homolog e produção |
| Teste antes de atualizar | Sempre teste `ALTER EXTENSION UPDATE` em homologação |
| CASCADE com cuidado | `DROP EXTENSION CASCADE` remove todos os objetos dependentes |
| `shared_preload_libraries` | Reinicialização necessária para extensions que usam hooks |

---

## Referências

- [PostgreSQL Docs - Extensions](https://www.postgresql.org/docs/current/extend-extensions.html)
- [PostgreSQL Docs - CREATE EXTENSION](https://www.postgresql.org/docs/current/sql-createextension.html)
- [PostgreSQL Extension Network - PGXN](https://pgxn.org/)
- [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html)
- [pgvector GitHub](https://github.com/pgvector/pgvector)
