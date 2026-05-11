# Segurança Multi-Tenant — IndioLab

> Como o isolamento entre tenants é garantido nos backends `crm-api`, `erp-api` etc.

## Modelo de tenancy

**Schema-per-tenant.** Cada empresa (`empresas`) tem um schema PostgreSQL com mesmo nome do CNPJ (14 dígitos).

```
opticalcorecombr (database)
├── public                  ← Identity, empresas, dominios compartilhados
├── 00000000000000          ← schema do tenant "default"
├── 79029021000190          ← schema do tenant "Indio Produtos Opticos"
└── ... (mais à medida que empresas são criadas)
```

Tabelas tenant: `crm_leads`, `crm_oportunidades`, `pessoas`, `clientes`, `compra_*`, `estoque_*`, `crm_atividades`, `crm_visitas`, etc.

---

## Camadas de defesa

A aplicação tem **três camadas independentes** garantindo que dados de um tenant não vazem para outro. Falhar uma camada NÃO compromete o isolamento — todas precisam falhar simultaneamente.

### Camada 1 — `search_path` por request

Todo request autenticado resolve o tenant a partir do JWT (claim `empresaId` → busca `empresas.cnpj` → schema name). O backend executa:

```sql
SET search_path TO "<schema>", public
```

A partir desse ponto, queries SEM schema-qualify (`SELECT * FROM crm_leads`) acertam a tabela do schema correto.

**Risco coberto:** queries esquecendo de qualificar schema.

**Risco residual:** se `SET search_path` não rodar (bug, exceção antes do middleware) → queries acertam `public` ou pior.

### Camada 2 — `TenantSearchPathCommandInterceptor`

Localização: `crm-api/src/IndioLab.Crm.Infrastructure/MultiTenancy/TenantSearchPathCommandInterceptor.cs`

Implementa `Microsoft.EntityFrameworkCore.Diagnostics.DbCommandInterceptor`. **Antes de cada comando** EF, executa `SET search_path TO "<schema>", public`. Sem cache cliente-side intencionalmente.

**Por que sem cache:** o Npgsql, ao devolver uma conexão ao pool, executa `DISCARD ALL` (ou similar reset) que zera o `search_path` server-side. Um cache cliente-side por `DbConnection` NÃO detecta esse reset porque o objeto `NpgsqlConnection` segue vivo e em estado `Open` quando volta do pool — a próxima request pegaria o cache "verde" mas o `search_path` real seria `public`, causando `relation does not exist`. O custo da emissão extra do SET é ~0.1ms localhost (1 round-trip por comando) — aceitável dado o ganho de correção.

**Risco coberto:** pool leak — conexão volta ao pool com `search_path` setado e é reutilizada por outro tenant antes que o middleware do novo request rode.

**Validação de schema name:** regex `^\d{11,14}$` antes de interpolar no SQL — proteção SQL injection.

**Skip cases (no-op):**
- Conexão não-Npgsql (ex: testes com SQLite in-memory)
- Request sem tenant (endpoints públicos, boot-time)

### Camada 3 — Row Level Security (RLS) no Postgres

Aplicada em **326 tabelas tenant** (todas as 163 tabelas × 2 schemas atuais). Para cada tabela:

```sql
ALTER TABLE "<schema>".<tabela> ENABLE ROW LEVEL SECURITY;
ALTER TABLE "<schema>".<tabela> FORCE ROW LEVEL SECURITY;

CREATE POLICY <tabela>_tenant_isolation ON "<schema>".<tabela>
USING (current_schema() = '<schema>');
```

**Como funciona:** a policy só permite linhas quando `current_schema()` (resultado do `SET search_path` ativo) bate com o nome do schema dono da tabela. Se a aplicação acidentalmente fizer `SELECT * FROM "tenantA".crm_leads` enquanto `current_schema() = 'tenantB'` → policy retorna 0 linhas.

**`indiolab_app.rolbypassrls = false`** — confirmado. Aplicação NÃO bypassa RLS.

**Superusers (`postgres`)** têm `BYPASSRLS = true` automático. Manutenção manual do DBA não é afetada — comportamento correto.

**Risco coberto:** queries cross-schema explícitas mesmo com `search_path` correto.

**Custo de performance:** mínimo. `current_schema()` é uma chamada constante por linha, otimizada pelo planner. Em benchmarks, < 2% overhead.

---

## Garantias por camada vs ataque

| Cenário de falha | C1 (search_path) | C2 (interceptor) | C3 (RLS) |
|---|---|---|---|
| Handler esquece de chamar `EnsureTenantContextAsync` | ❌ falha | ✅ pega | ✅ pega |
| Conexão volta do pool com search_path antigo | ❌ falha | ✅ pega | ✅ pega |
| Bug que faz `SET search_path TO 'public'` por engano | ❌ falha | ❌ falha (interceptor confia no tenant resolvido) | ✅ pega (current_schema = public ≠ tenant) |
| Query com schema-qualify cruzado: `SELECT * FROM "tenantB".x` rodando como tenant A | ❌ falha | ❌ falha | ✅ pega |
| Atacante com SQL injection conseguindo chamar `SET ROLE postgres` | ❌ falha | ❌ falha | ❌ falha (BYPASSRLS) |

A última linha é **fora do escopo de RLS**. Mitigação: nunca expor SQL dinâmico user-controlled. Backend usa parametrização Npgsql + whitelist de coluna em sort (`QueryableExtensions.ApplySort`).

---

## Provisionar um novo tenant

Operação atômica feita pelo `TenantSchemaService` (`crm-api/src/IndioLab.Crm.Infrastructure/Services/TenantSchemaService.cs`):

1. Validar nome do schema contra regex `^\d{11,14}$`
2. `CREATE SCHEMA IF NOT EXISTS "<schema>"`
3. `CREATE TABLE IF NOT EXISTS ...` para cada tabela tenant
4. Aplicar índices (trigram pg_trgm, parciais soft-delete, compostos FK)
5. **`ENABLE ROW LEVEL SECURITY` + `CREATE POLICY tenant_isolation`** para cada tabela

Idempotente — pode rodar múltiplas vezes sem efeito colateral.

## Migrar tenants existentes

`RunIncrementalMigrationsAsync` em `TenantSchemaService` aplica migrations incrementais (rename de coluna, novos índices, RLS) idempotentemente. Cada bloco em `try/catch` isolado — uma falha não bloqueia as demais.

---

## Monitoramento recomendado

### O que alertar

1. **Query falhando com `42501 permission denied`** ou retornando **0 linhas inesperadamente**
   → indica RLS bloqueando algo legítimo (provável bug no `search_path`).

2. **Conexão retornando da pool com `current_schema()` diferente do esperado** — log via interceptor para detectar leaks reais.

3. **Tentativas de bypass:** queries usando `SET ROLE` ou `SET LOCAL ROLE` por usuário não-DBA → red flag.

### Métricas relevantes

- Taxa de queries por tenant (para detectar tenant órfão recebendo queries)
- Distribuição de `current_schema()` por connection no pool (verificar leaks)
- Rate de cache hit no interceptor

---

## Rollback de RLS (operação manual, raro)

Se RLS estiver bloqueando legitimamente um caso edge e precisar desabilitar TEMPORARIAMENTE:

```sql
DO $$ DECLARE t RECORD; BEGIN
  FOR t IN SELECT tablename FROM pg_tables WHERE schemaname = '<schema>' LOOP
    EXECUTE format('ALTER TABLE %I.%I DISABLE ROW LEVEL SECURITY',
                   '<schema>', t.tablename);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I',
                   t.tablename || '_tenant_isolation', '<schema>', t.tablename);
  END LOOP;
END; $$;
```

Reabilitar: rodar `RunIncrementalMigrationsAsync` novamente.

---

## Histórico

- **2026-05-06:** Implementação das 3 camadas. RLS aplicada em 326 tabelas. `TenantSearchPathCommandInterceptor` substitui chamadas manuais a `EnsureTenantContextAsync` (marcado `[Obsolete]`). `indiolab_app` confirmado sem `BYPASSRLS`.

## Gap conhecido — RLS (Row-Level Security) sem efeito

**Status (2026-05-11)**: P3 backlog — adiado até cutover pra cliente externo.

### Contexto

O `TenantSchemaService` cria policies `{tabela}_tenant_isolation` em cada schema tenant ao provisionar (`USING (current_schema() = '{schemaName}')`). MAS:

- O role do banco usado pelos 4 APIs em prod (`opticalcore`) é **Superuser + Bypass RLS**
- Postgres ignora RLS para roles com `BYPASSRLS` — policies viram decoração
- Auditoria DBA confirmou: 158 tabelas tenant com `ENABLE ROW LEVEL SECURITY=true`, **0 policies de fato em pg_policies**

### Impacto

Isolamento multi-tenant depende **exclusivamente** do `TenantSearchPathCommandInterceptor` (EF Core, re-emite `SET search_path` por comando). Se um caminho de código escapar do interceptor (background job sem header de tenant, query raw, connection pool reciclando search_path), **vaza dados cross-tenant**.

### Plano de remediação (antes de prod cliente externo)

1. Criar role `indiolab_app` no postgres (sem Superuser, sem Bypass RLS)
2. `GRANT SELECT, INSERT, UPDATE, DELETE` em todas as tabelas de cada schema tenant
3. Manter `opticalcore` (Superuser) só pra **provisionamento** (admin-api ao criar tenant novo roda DDL via `TenantSchemaService`)
4. Trocar connection string dos 4 APIs (`/opt/indiolab/.env`) pra usar `indiolab_app`
5. Re-rodar `TenantSchemaService.RunIncrementalMigrationsAsync` para criar as policies via `DO $rls$` block (que agora terá efeito)
6. Smoke test: tentar SELECT cross-tenant — deve retornar 0 rows

### Workaround atual

Confiar no interceptor + revisão de código. Não adicionar endpoints/jobs sem o `[Authorize]` + `TenantContextInterceptor` no scope.
