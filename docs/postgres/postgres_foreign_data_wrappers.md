# PostgreSQL - Foreign Data Wrappers (FDW)

## O que são Foreign Data Wrappers?

Foreign Data Wrappers (FDW) são uma implementação do padrão SQL/MED (Management
of External Data — ISO/IEC 9075-9) que permite ao PostgreSQL acessar dados
externos como se fossem tabelas locais. Com FDW é possível consultar, e em
alguns casos modificar, dados que residem em outras fontes sem precisar
importá-los ou copiá-los para o banco local.

Introduzidos no PostgreSQL 9.1 com suporte somente leitura e expandidos no
9.3 com suporte a escrita, os FDWs são amplamente utilizados em:

- Integração entre instâncias PostgreSQL
- Acesso a bancos de dados heterogêneos (MySQL, Oracle, SQL Server)
- Leitura de arquivos CSV e outros formatos
- Integração com APIs e fontes de dados externas
- Arquiteturas de data warehouse e ETL

---

## Arquitetura FDW

```
PostgreSQL Local
│
├── FOREIGN DATA WRAPPER  (driver/conector)
│       └── SERVER         (conexão com a fonte externa)
│               └── USER MAPPING  (credenciais por usuário)
│                       └── FOREIGN TABLE  (tabela mapeada)
```

---

## FDWs Disponíveis

### Incluídos no contrib (PostgreSQL padrão)

| FDW | Fonte de dados |
|---|---|
| `postgres_fdw` | Outro servidor PostgreSQL |
| `file_fdw` | Arquivos locais (CSV, texto) |

### Terceiros populares

| FDW | Fonte de dados |
|---|---|
| `mysql_fdw` | MySQL / MariaDB |
| `oracle_fdw` | Oracle Database |
| `tds_fdw` | SQL Server / Sybase |
| `mongo_fdw` | MongoDB |
| `redis_fdw` | Redis |
| `jdbc_fdw` | Qualquer banco via JDBC |
| `multicorn` | Python — fontes diversas |
| `odbc_fdw` | Qualquer fonte via ODBC |
| `parquet_s3_fdw` | Arquivos Parquet no S3 |

---

## postgres_fdw — PostgreSQL para PostgreSQL

O caso mais comum: conectar duas instâncias PostgreSQL.

### Instalação

```sql
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
```

### Passo 1 — Criar o Foreign Server

```sql
CREATE SERVER srv_erp_producao
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (
        host '192.168.1.100',
        port '5432',
        dbname 'erp_producao'
    );
```

### Passo 2 — Criar o User Mapping

```sql
-- Mapear o usuário local 'analytics' para o usuário remoto 'readonly_user'
CREATE USER MAPPING FOR analytics
    SERVER srv_erp_producao
    OPTIONS (
        user 'readonly_user',
        password 'senha_segura'
    );

-- Mapear para o usuário atual
CREATE USER MAPPING FOR CURRENT_USER
    SERVER srv_erp_producao
    OPTIONS (
        user 'readonly_user',
        password 'senha_segura'
    );
```

### Passo 3 — Criar Foreign Tables manualmente

```sql
CREATE FOREIGN TABLE ft_pedidos (
    id          BIGINT,
    cliente_id  BIGINT,
    data_pedido DATE,
    valor_total NUMERIC(15,2),
    status      TEXT
)
SERVER srv_erp_producao
OPTIONS (schema_name 'public', table_name 'pedidos');
```

### Passo 4 — Importar schema inteiro automaticamente

```sql
-- Criar schema local para as tabelas remotas
CREATE SCHEMA erp_remoto;

-- Importar todas as tabelas de um schema remoto
IMPORT FOREIGN SCHEMA public
FROM SERVER srv_erp_producao
INTO erp_remoto;

-- Importar apenas tabelas específicas
IMPORT FOREIGN SCHEMA public
LIMIT TO (pedidos, clientes, produtos)
FROM SERVER srv_erp_producao
INTO erp_remoto;

-- Importar excluindo tabelas específicas
IMPORT FOREIGN SCHEMA public
EXCEPT (logs, temp_processamento)
FROM SERVER srv_erp_producao
INTO erp_remoto;
```

### Consultando dados remotos

```sql
-- Consulta simples
SELECT * FROM erp_remoto.pedidos LIMIT 100;

-- JOIN entre tabela local e tabela remota
SELECT
    c.nome              AS cliente,
    p.data_pedido,
    p.valor_total
FROM erp_remoto.pedidos p
JOIN public.clientes c ON c.id = p.cliente_id
WHERE p.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY p.data_pedido DESC;

-- Agregação em dados remotos
SELECT
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*)                         AS qtd_pedidos,
    SUM(valor_total)                 AS total_vendas
FROM erp_remoto.pedidos
GROUP BY 1
ORDER BY 1;
```

### Escrita em tabelas remotas

```sql
-- INSERT remoto
INSERT INTO erp_remoto.logs_auditoria (evento, usuario, ocorrido_em)
VALUES ('acesso_relatorio', current_user, NOW());

-- UPDATE remoto
UPDATE erp_remoto.pedidos
SET status = 'processado'
WHERE id = 12345;

-- DELETE remoto
DELETE FROM erp_remoto.temp_cache
WHERE criado_em < NOW() - INTERVAL '1 day';
```

### Opções avançadas de performance

```sql
-- Configurar fetch_size (linhas buscadas por vez)
ALTER SERVER srv_erp_producao
OPTIONS (ADD fetch_size '1000');

-- Habilitar pushdown de agregações para o servidor remoto
ALTER SERVER srv_erp_producao
OPTIONS (ADD use_remote_estimate 'true');

-- Configurar timeout de conexão
ALTER SERVER srv_erp_producao
OPTIONS (ADD connect_timeout '10');
```

---

## file_fdw — Leitura de Arquivos

Permite ler arquivos CSV, TSV e outros formatos de texto diretamente como
tabelas.

### Instalação

```sql
CREATE EXTENSION IF NOT EXISTS file_fdw;
```

### Criar servidor e tabela para CSV

```sql
-- O server para file_fdw não precisa de opções específicas
CREATE SERVER srv_arquivos
    FOREIGN DATA WRAPPER file_fdw;

-- Mapear arquivo CSV como tabela
CREATE FOREIGN TABLE ft_importacao_clientes (
    id       INTEGER,
    nome     TEXT,
    email    TEXT,
    cidade   TEXT,
    estado   CHAR(2)
)
SERVER srv_arquivos
OPTIONS (
    filename '/var/lib/postgresql/imports/clientes.csv',
    format 'csv',
    header 'true',
    delimiter ',',
    null 'NULL',
    encoding 'UTF8'
);

-- Consultar o arquivo como tabela
SELECT * FROM ft_importacao_clientes LIMIT 10;

-- Importar dados do CSV para tabela local
INSERT INTO clientes (id, nome, email, cidade, estado)
SELECT * FROM ft_importacao_clientes;
```

---

## mysql_fdw — Acesso ao MySQL

### Instalação no sistema

```bash
# Ubuntu/Debian
apt install postgresql-16-mysql-fdw

# Compilar do fonte (alternativa)
# https://github.com/EnterpriseDB/mysql_fdw
```

### Configuração

```sql
CREATE EXTENSION mysql_fdw;

CREATE SERVER srv_mysql
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (
        host '192.168.1.200',
        port '3306'
    );

CREATE USER MAPPING FOR CURRENT_USER
    SERVER srv_mysql
    OPTIONS (
        username 'usuario_mysql',
        password 'senha_mysql'
    );

CREATE FOREIGN TABLE ft_mysql_clientes (
    id    INT,
    nome  VARCHAR(200),
    email VARCHAR(200)
)
SERVER srv_mysql
OPTIONS (dbname 'loja', table_name 'clientes');

SELECT * FROM ft_mysql_clientes LIMIT 10;
```

---

## tds_fdw — Acesso ao SQL Server

### Configuração

```sql
CREATE EXTENSION tds_fdw;

CREATE SERVER srv_sqlserver
    FOREIGN DATA WRAPPER tds_fdw
    OPTIONS (
        servername '192.168.1.300',
        port '1433',
        database 'ERP_LEGADO',
        tds_version '7.4'
    );

CREATE USER MAPPING FOR CURRENT_USER
    SERVER srv_sqlserver
    OPTIONS (
        username 'sa',
        password 'senha_sqlserver'
    );

CREATE FOREIGN TABLE ft_ss_notas_fiscais (
    numero     INT,
    data_emissao DATE,
    valor      DECIMAL(15,2),
    cliente_id INT
)
SERVER srv_sqlserver
OPTIONS (schema_name 'dbo', table_name 'NotasFiscais');

SELECT * FROM ft_ss_notas_fiscais
WHERE data_emissao >= '2024-01-01';
```

---

## Gerenciamento de FDWs

### Listar FDWs instalados

```sql
SELECT
    fdwname    AS fdw,
    fdwhandler::regproc AS handler,
    fdwvalidator::regproc AS validator
FROM pg_foreign_data_wrapper;
```

### Listar servidores externos

```sql
SELECT
    srvname    AS servidor,
    fdwname    AS fdw,
    srvoptions AS opcoes,
    pg_catalog.pg_get_userbyid(srvowner) AS dono
FROM pg_foreign_server fs
JOIN pg_foreign_data_wrapper fdw ON fdw.oid = fs.srvfdw;
```

### Listar user mappings

```sql
SELECT
    usename    AS usuario_local,
    srvname    AS servidor,
    umoptions  AS opcoes
FROM pg_user_mappings;
```

### Listar foreign tables

```sql
SELECT
    n.nspname  AS schema,
    c.relname  AS tabela,
    s.srvname  AS servidor,
    ft.ftoptions AS opcoes
FROM pg_foreign_table ft
JOIN pg_class c         ON c.oid = ft.ftrelid
JOIN pg_namespace n     ON n.oid = c.relnamespace
JOIN pg_foreign_server s ON s.oid = ft.ftserver
ORDER BY n.nspname, c.relname;
```

### Alterar opções de servidor

```sql
-- Adicionar opção
ALTER SERVER srv_erp_producao OPTIONS (ADD fetch_size '500');

-- Modificar opção existente
ALTER SERVER srv_erp_producao OPTIONS (SET host '192.168.1.101');

-- Remover opção
ALTER SERVER srv_erp_producao OPTIONS (DROP fetch_size);
```

### Remover objetos FDW

```sql
-- Remover na ordem correta (dependências)
DROP FOREIGN TABLE IF EXISTS erp_remoto.pedidos;
DROP USER MAPPING IF EXISTS FOR analytics SERVER srv_erp_producao;
DROP SERVER IF EXISTS srv_erp_producao CASCADE;
DROP EXTENSION IF EXISTS postgres_fdw;
```

---

## Pushdown de Operações

O `postgres_fdw` é inteligente o suficiente para enviar parte do processamento
ao servidor remoto (pushdown), evitando trazer todos os dados para filtrar
localmente.

```sql
-- PostgreSQL envia o WHERE para o servidor remoto
-- Apenas os registros filtrados trafegam pela rede
EXPLAIN VERBOSE
SELECT * FROM erp_remoto.pedidos
WHERE data_pedido >= '2024-01-01'
  AND status = 'pendente';

-- Verificar se houve pushdown no plano de execução
-- Procure por "Remote SQL:" no output do EXPLAIN
```

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Usuário somente leitura | Crie um usuário dedicado com permissões mínimas no servidor remoto |
| Schema dedicado | Use um schema separado para todas as foreign tables |
| fetch_size | Ajuste conforme o volume de dados esperado nas queries |
| use_remote_estimate | Habilite para queries complexas com JOINs |
| Timeout | Configure `connect_timeout` para evitar travamentos |
| Monitoramento | Monitore conexões abertas com `pg_stat_activity` |
| Senhas | Use `pg_hba.conf` e SSL para proteger credenciais em trânsito |
| Particionamento | Em grandes volumes, combine FDW com tabelas particionadas |

---

## Caso de Uso: Consolidação de ERPs

Cenário comum em ambientes corporativos com múltiplas instâncias:

```sql
-- Servidor central de relatórios conectado a 3 instâncias de ERP

CREATE SERVER srv_filial_sp   FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.1.10', dbname 'erp');
CREATE SERVER srv_filial_rj   FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.1.20', dbname 'erp');
CREATE SERVER srv_filial_pr   FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '10.0.1.30', dbname 'erp');

-- Importar schemas
IMPORT FOREIGN SCHEMA public LIMIT TO (pedidos, clientes) FROM SERVER srv_filial_sp INTO filial_sp;
IMPORT FOREIGN SCHEMA public LIMIT TO (pedidos, clientes) FROM SERVER srv_filial_rj INTO filial_rj;
IMPORT FOREIGN SCHEMA public LIMIT TO (pedidos, clientes) FROM SERVER srv_filial_pr INTO filial_pr;

-- View consolidada de todas as filiais
CREATE VIEW vw_pedidos_consolidado AS
    SELECT 'SP' AS filial, * FROM filial_sp.pedidos
    UNION ALL
    SELECT 'RJ' AS filial, * FROM filial_rj.pedidos
    UNION ALL
    SELECT 'PR' AS filial, * FROM filial_pr.pedidos;

-- Relatório nacional
SELECT
    filial,
    DATE_TRUNC('month', data_pedido) AS mes,
    COUNT(*)       AS qtd_pedidos,
    SUM(valor_total) AS faturamento
FROM vw_pedidos_consolidado
GROUP BY 1, 2
ORDER BY 2, 1;
```

---

## Referências

- [PostgreSQL Docs - postgres_fdw](https://www.postgresql.org/docs/current/postgres-fdw.html)
- [PostgreSQL Docs - file_fdw](https://www.postgresql.org/docs/current/file-fdw.html)
- [PostgreSQL Docs - CREATE FOREIGN DATA WRAPPER](https://www.postgresql.org/docs/current/sql-createforeigndatawrapper.html)
- [PostgreSQL Docs - SQL/MED](https://www.postgresql.org/docs/current/ddl-foreign-data.html)
- [mysql_fdw - EnterpriseDB](https://github.com/EnterpriseDB/mysql_fdw)
- [tds_fdw - GitHub](https://github.com/tds-fdw/tds_fdw)
