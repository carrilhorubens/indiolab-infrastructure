# ARQUITETURA MULTI-TENANT - Sistema OpticalCore

**Data**: 2026-01-26
**Sistema**: OpticalCore ERP
**Stack**: C# .NET 8 / ASP.NET Core / PostgreSQL
**Estrategia**: Schema por Empresa (PostgreSQL)

---

## VISAO GERAL

### O que e Multi-Tenant?

Multi-tenant e uma arquitetura onde uma unica instancia da aplicacao serve
multiplos clientes (tenants/empresas), mantendo os dados isolados entre si.

### Estrategia Escolhida: Schema por Empresa

```
opticalcore (database)
|
+-- public/                    <- Dados GLOBAIS
|   +-- AspNetUsers            <- Identity (usuarios)
|   +-- AspNetRoles            <- Identity (roles)
|   +-- AspNetUserRoles        <- Identity (user-roles)
|   +-- companies              <- Cadastro de empresas
|   +-- tipos_dominio          <- Lookup tables
|   +-- valores_dominio        <- Valores de lookup
|
+-- 79029021000190/            <- Dados da Empresa (CNPJ como nome do schema)
|   +-- enderecos
|   +-- pessoas
|   +-- clientes
|   +-- fornecedores
|   +-- funcionarios
|
+-- 12345678000199/            <- Dados de outra Empresa
    +-- enderecos
    +-- pessoas
    +-- clientes
    +-- fornecedores
    +-- funcionarios
```

---

## COMPONENTES DA IMPLEMENTACAO

### 1. Interfaces (Application Layer)

| Interface | Descricao |
|-----------|-----------|
| `ITenantService` | Gerencia contexto do tenant atual (TenantId, SchemaName) |
| `ITenantDbContext` | DbContext para entidades isoladas por tenant |
| `ITenantSchemaService` | Cria, verifica e remove schemas PostgreSQL |
| `ITenantDataMigrationService` | Migra dados existentes para schemas de tenant |

### 2. Implementacoes (Infrastructure Layer)

| Servico | Descricao |
|---------|-----------|
| `TenantService` | Busca SchemaName da Company pelo tenant_id do JWT |
| `TenantDbContext` | Implementa `SET search_path TO {cnpj}, public` |
| `TenantSchemaService` | SQL para criar schemas com todas as tabelas |
| `TenantDataMigrationService` | Copia dados do schema public para tenant |

### 3. Middleware

| Middleware | Descricao |
|------------|-----------|
| `TenantMiddleware` | Extrai tenant_id do JWT e configura ITenantService |

---

## FLUXO DE AUTENTICACAO

```
+-------------------------------------------------------------+
|                     REQUEST DO FRONTEND                     |
|                                                             |
|  GET /api/clientes                                          |
|  Authorization: Bearer eyJhbGciOiJIUzI1NiIs...             |
|  (JWT contém claim "tenant_id" = CompanyId)                 |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                    TenantMiddleware                         |
|                                                             |
|  1. Extrai "tenant_id" do JWT claims                        |
|  2. Chama ITenantService.SetTenantAsync(tenantId)           |
|  3. TenantService busca Company.SchemaName                  |
|                                                             |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                    TenantDbContext                          |
|                                                             |
|  Antes de qualquer operação:                                |
|  SET search_path TO 79029021000190, public                 |
|                                                             |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                 QUERY EXECUTADA                             |
|                                                             |
|  SELECT * FROM pessoas WHERE is_deleted = false             |
|                    |                                        |
|                    v                                        |
|  Automaticamente resolve para: 79029021000190.pessoas      |
|                                                             |
+-------------------------------------------------------------+
```

---

## CLASSIFICACAO DAS ENTIDADES

### Entidades PUBLIC (Schema public)

Compartilhadas entre todos os tenants. Usam `IApplicationDbContext`.

| Entidade | Tabela | Descricao |
|----------|--------|-----------|
| Company | companies | Cadastro de empresas/tenants |
| ApplicationUser | AspNetUsers | Usuarios (Identity) |
| ApplicationRole | AspNetRoles | Roles (Identity) |
| TipoDominio | tipos_dominio | Tipos de lookup |
| ValorDominio | valores_dominio | Valores de lookup |

### Entidades TENANT (Schema {CNPJ})

Isoladas por empresa. Usam `ITenantDbContext`.

| Entidade | Tabela | Descricao |
|----------|--------|-----------|
| Endereco | enderecos | Enderecos |
| Pessoa | pessoas | Base do Party Pattern |
| Cliente | clientes | Role de Cliente |
| Fornecedor | fornecedores | Role de Fornecedor |
| Funcionario | funcionarios | Role de Funcionario |

---

## CONFIGURACAO DE DI

```csharp
// Infrastructure/DependencyInjection.cs

// DbContext para tabelas públicas
services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(connectionString));
services.AddScoped<IApplicationDbContext>(p =>
    p.GetRequiredService<ApplicationDbContext>());

// DbContext para tabelas de tenant (schema dinâmico)
services.AddDbContext<TenantDbContext>(options =>
    options.UseNpgsql(connectionString));
services.AddScoped<ITenantDbContext>(p =>
    p.GetRequiredService<TenantDbContext>());

// Serviços de Tenant
services.AddScoped<ITenantService, TenantService>();
services.AddScoped<ITenantSchemaService, TenantSchemaService>();
services.AddScoped<ITenantDataMigrationService, TenantDataMigrationService>();
```

---

## PIPELINE DO MIDDLEWARE

```csharp
// API/Program.cs

app.UseAuthentication();
app.UseAuthorization();
app.UseTenantMiddleware();  // <-- Configura contexto do tenant
app.MapControllers();
```

---

## CRIACAO AUTOMATICA DO SCHEMA

Quando uma Company e criada, o schema e criado automaticamente:

```csharp
// CompanyService.CreateAsync()

_context.Companies.Add(company);
await _context.SaveChangesAsync();

// Criar schema PostgreSQL para o novo tenant
await _tenantSchemaService.CreateSchemaAsync(company.SchemaName);
```

### Estrutura do Schema Criado

```sql
-- Schema: 79029021000190

CREATE TABLE 79029021000190.enderecos (
    id UUID PRIMARY KEY,
    cep VARCHAR(10) NOT NULL,
    logradouro VARCHAR(200) NOT NULL,
    -- ... outros campos
);

CREATE TABLE 79029021000190.pessoas (
    id UUID PRIMARY KEY,
    codigo INTEGER NOT NULL,
    tipo_pessoa_id UUID REFERENCES public.valores_dominio(id),
    nome VARCHAR(200) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL,
    endereco_id UUID REFERENCES 79029021000190.enderecos(id),
    -- ... outros campos
    CONSTRAINT uk_79029021000190_pessoas_cpf_cnpj UNIQUE (cpf_cnpj)
);

CREATE TABLE 79029021000190.clientes (
    id UUID PRIMARY KEY,
    pessoa_id UUID REFERENCES 79029021000190.pessoas(id),
    limite_credito DECIMAL(15,2),
    -- ... outros campos
);

CREATE TABLE 79029021000190.fornecedores (
    id UUID PRIMARY KEY,
    pessoa_id UUID REFERENCES 79029021000190.pessoas(id),
    -- ... outros campos
);

CREATE TABLE 79029021000190.funcionarios (
    id UUID PRIMARY KEY,
    pessoa_id UUID REFERENCES 79029021000190.pessoas(id),
    cargo VARCHAR(100) NOT NULL,
    data_admissao TIMESTAMP NOT NULL,
    -- ... outros campos
);
```

---

## API DE ADMINISTRACAO

Endpoints para gerenciamento de schemas e migracao de dados (requer role Admin):

| Endpoint | Metodo | Descricao |
|----------|--------|-----------|
| `/api/admin/schema/list` | GET | Lista todos os schemas de tenant |
| `/api/admin/schema/exists/{schemaName}` | GET | Verifica se schema existe |
| `/api/admin/migration/status/{companyId}` | GET | Status da migracao |
| `/api/admin/migration/create-schema/{companyId}` | POST | Criar schema |
| `/api/admin/migration/migrate/{companyId}` | POST | Migrar dados de uma empresa |
| `/api/admin/migration/migrate-all` | POST | Migrar todas as empresas |

### Exemplo: Verificar Status

```bash
GET /api/admin/migration/status/12345678-1234-1234-1234-123456789abc

Response:
{
  "companyId": "12345678-1234-1234-1234-123456789abc",
  "schemaName": "79029021000190",
  "schemaExists": true,
  "pessoasNoPublic": 150,
  "pessoasNoSchema": 150,
  "migracaoCompleta": true
}
```

### Exemplo: Migrar Empresa

```bash
POST /api/admin/migration/migrate/12345678-1234-1234-1234-123456789abc

Response:
{
  "message": "Migracao concluida com sucesso",
  "companyId": "12345678-...",
  "schemaName": "79029021000190",
  "statistics": {
    "pessoas": 150,
    "enderecos": 120,
    "clientes": 80,
    "fornecedores": 40,
    "funcionarios": 30
  },
  "durationMs": 1234
}
```

---

## HANDLERS E CONTROLLERS

### ⚠️ REGRA CRITICA: EnsureTenantContextAsync()

> **OBRIGATORIO**: Todo handler que usa `ITenantDbContext` DEVE chamar
> `EnsureTenantContextAsync()` como PRIMEIRA linha do método Handle().

**Por que isso é necessário?**

O `TenantDbContext` precisa executar `SET search_path TO "{CNPJ}", public` antes
de qualquer query para que o PostgreSQL saiba em qual schema buscar as tabelas.

Sem essa chamada, o PostgreSQL procura no schema `public` (padrão), onde as
tabelas de tenant NÃO existem, resultando no erro:

```
42P01: relation "nome_tabela" does not exist
```

### Padrao de Handler (Application Layer)

```csharp
public class GetClientesQueryHandler : IRequestHandler<GetClientesQuery, PaginatedClientesDto>
{
    private readonly ITenantDbContext _context;  // <-- Usa ITenantDbContext

    public GetClientesQueryHandler(ITenantDbContext context)
    {
        _context = context;
    }

    public async Task<PaginatedClientesDto> Handle(
        GetClientesQuery request,
        CancellationToken cancellationToken)
    {
        // ⚠️ OBRIGATORIO: Configurar search_path ANTES de qualquer query
        await _context.EnsureTenantContextAsync(cancellationToken);

        // Agora sim, queries funcionam no schema correto
        var query = _context.Clientes
            .Include(c => c.Pessoa)
            .Where(c => !c.IsDeleted);
        // ... resto da implementação
    }
}
```

### Exemplos: Handler Correto vs Incorreto

```csharp
// ❌ INCORRETO - VAI FALHAR COM "relation does not exist"
public class GetDepositosQueryHandler : IRequestHandler<GetDepositosQuery, PaginatedList<DepositoDto>>
{
    private readonly ITenantDbContext _context;

    public async Task<PaginatedList<DepositoDto>> Handle(GetDepositosQuery request, CancellationToken cancellationToken)
    {
        // ❌ ERRO: Falta EnsureTenantContextAsync()!
        var query = _context.Depositos  // <-- PostgreSQL não sabe qual schema usar
            .Where(d => !d.IsDeleted);
        // ...
    }
}

// ✅ CORRETO - FUNCIONA PERFEITAMENTE
public class GetDepositosQueryHandler : IRequestHandler<GetDepositosQuery, PaginatedList<DepositoDto>>
{
    private readonly ITenantDbContext _context;

    public async Task<PaginatedList<DepositoDto>> Handle(GetDepositosQuery request, CancellationToken cancellationToken)
    {
        // ✅ CORRETO: Configura search_path PRIMEIRO
        await _context.EnsureTenantContextAsync(cancellationToken);

        var query = _context.Depositos  // <-- Agora PostgreSQL sabe buscar em "79029021000190".depositos
            .Where(d => !d.IsDeleted);
        // ...
    }
}
```

### Template para Novo Handler de Tenant

Use este template como base para novos handlers:

```csharp
namespace OpticalCore.Application.Features.NomeModulo.Queries;

using MediatR;
using Microsoft.EntityFrameworkCore;
using OpticalCore.Application.Interfaces;

public record GetEntidadesQuery : IRequest<List<EntidadeDto>>
{
    // ... propriedades da query
}

public class GetEntidadesQueryHandler : IRequestHandler<GetEntidadesQuery, List<EntidadeDto>>
{
    private readonly ITenantDbContext _context;

    public GetEntidadesQueryHandler(ITenantDbContext context)
    {
        _context = context;
    }

    public async Task<List<EntidadeDto>> Handle(GetEntidadesQuery request, CancellationToken cancellationToken)
    {
        // ⚠️ LINHA 1 OBRIGATÓRIA - NUNCA ESQUECER!
        await _context.EnsureTenantContextAsync(cancellationToken);

        // Agora pode fazer queries normalmente
        return await _context.Entidades
            .Where(e => !e.IsDeleted)
            .Select(e => new EntidadeDto(...))
            .ToListAsync(cancellationToken);
    }
}
```

### Padrao de Controller (API Layer)

```csharp
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ClientesController : ControllerBase
{
    private readonly IMediator _mediator;

    public ClientesController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpGet]
    public async Task<ActionResult<PaginatedClientesDto>> GetAll(
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 10)
    {
        // Não precisa passar EmpresaId - isolamento é via schema
        var query = new GetClientesQuery
        {
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        var result = await _mediator.Send(query);
        return Ok(result);
    }
}
```

---

## REGRAS IMPORTANTES

### Ao Criar Novo Modulo

1. **Pergunte**: Este modulo e PUBLIC ou TENANT?
2. **PUBLIC**: Use `IApplicationDbContext` no Handler
3. **TENANT**: Use `ITenantDbContext` no Handler
4. **TENANT**: Adicione a tabela no `TenantSchemaService.GetCreateTablesSql()`

### Ao Consultar Dados

```csharp
// ERRADO - Acessa schema public
var clientes = _applicationDbContext.Clientes.ToList();

// CORRETO - Acessa schema do tenant
var clientes = _tenantDbContext.Clientes.ToList();
```

### Usuario sem Empresa

Se um usuario nao tem `tenant_id` no JWT, o TenantMiddleware retorna 403:

```json
{
  "error": "Tenant inválido ou não configurado"
}
```

### Tabelas de Referencia

Tabelas de referencia (TipoDominio, ValorDominio) ficam no schema `public`
e sao acessiveis por todos os tenants atraves do fallback no search_path:

```sql
SET search_path TO 79029021000190, public;

-- Esta query funciona porque valores_dominio esta em public
SELECT * FROM pessoas p
JOIN valores_dominio v ON p.tipo_pessoa_id = v.id;
```

---

## SEGURANCA

### Validacao do Schema Name

Para prevenir SQL injection, o schema name e validado com regex:

```csharp
private static bool IsValidSchemaName(string schemaName)
{
    if (string.IsNullOrEmpty(schemaName)) return false;
    // Schema name deve ser o CNPJ da empresa (14 digitos numericos)
    return Regex.IsMatch(schemaName, @"^[0-9]{14}$");
}
```

### Formato do Schema Name

O schema name e o CNPJ da empresa (apenas numeros, sem pontuacao):

```csharp
// Company.Create()
// O SchemaName e o CNPJ da empresa sem pontuacao
// Exemplo: CNPJ 79.029.021/0001-90 -> SchemaName: 79029021000190
SchemaName = cnpj.Replace(".", "").Replace("/", "").Replace("-", "");
// Resultado: 79029021000190
```

### Identificando Schemas de Tenant

Para identificar schemas de tenant no banco de dados, use o padrao numerico de 14 digitos:

```sql
-- Listar todos os schemas de tenant (CNPJ)
SELECT nspname FROM pg_namespace WHERE nspname ~ '^[0-9]{14}$';

-- Verificar se um schema especifico existe
SELECT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = '79029021000190');
```

---

## MIGRACAO DE DADOS EXISTENTES

### Processo de Migracao

Para empresas existentes com dados no schema public:

1. **Criar schema**: `POST /api/admin/migration/create-schema/{companyId}`
2. **Verificar status**: `GET /api/admin/migration/status/{companyId}`
3. **Executar migracao**: `POST /api/admin/migration/migrate/{companyId}`
4. **Validar dados**: Comparar contagens entre public e tenant

### Migracao em Lote

Para migrar todas as empresas de uma vez:

```bash
POST /api/admin/migration/migrate-all
```

---

## ERROS COMUNS E SOLUCOES

### Erro: "relation 'nome_tabela' does not exist" (42P01)

**Sintoma**: O endpoint retorna erro 500 com a mensagem:
```
42P01: relation "depositos" does not exist
```

**Causa**: O handler NÃO está chamando `EnsureTenantContextAsync()` antes das queries.

**Solução**: Adicionar a chamada como PRIMEIRA linha do método Handle():
```csharp
public async Task<Result> Handle(Command request, CancellationToken cancellationToken)
{
    await _context.EnsureTenantContextAsync(cancellationToken);  // <-- ADICIONAR ISSO

    // ... resto do código
}
```

**Verificação Rápida**: A tabela existe no banco? Use o endpoint de debug:
```bash
GET /api/admin/schema/tables/{schemaName}
```

Se a tabela existir mas o erro persistir, é 100% certeza que falta o `EnsureTenantContextAsync()`.

---

## CHECKLIST PARA NOVOS DESENVOLVEDORES

### Antes de Criar um Modulo

- [ ] Definir se e PUBLIC ou TENANT
- [ ] Escolher o DbContext correto (`IApplicationDbContext` ou `ITenantDbContext`)
- [ ] Se TENANT, adicionar tabela no `TenantSchemaService.GetMigrationSql()`
- [ ] Testar com usuarios de diferentes empresas

### Ao Criar Handler com ITenantDbContext

- [ ] **OBRIGATORIO**: Chamar `await _context.EnsureTenantContextAsync(cancellationToken);` como PRIMEIRA linha do Handle()
- [ ] Verificar se o handler compila sem erros
- [ ] Testar endpoint e verificar se não há erro 500

### Ao Fazer Code Review

- [ ] Verificar se DbContext esta correto para o tipo de modulo
- [ ] **CRITICO**: Verificar se TODOS os handlers com `ITenantDbContext` chamam `EnsureTenantContextAsync()`
- [ ] Verificar se queries nao vazam dados entre tenants
- [ ] Verificar se Handler nao recebe/filtra por EmpresaId (deve ser automatico)

---

## ARQUIVOS DA IMPLEMENTACAO

### Interfaces (Application)

| Arquivo | Descricao |
|---------|-----------|
| `Interfaces/ITenantService.cs` | Contexto do tenant |
| `Interfaces/ITenantDbContext.cs` | DbContext de tenant |
| `Interfaces/ITenantSchemaService.cs` | Operacoes de schema |
| `Interfaces/ITenantDataMigrationService.cs` | Migracao de dados |

### Servicos (Infrastructure)

| Arquivo | Descricao |
|---------|-----------|
| `Services/TenantService.cs` | Busca SchemaName |
| `Persistence/TenantDbContext.cs` | SET search_path |
| `Services/TenantSchemaService.cs` | Cria schemas |
| `Services/TenantDataMigrationService.cs` | Migra dados |
| `Services/CompanyService.cs` | Cria schema ao criar Company |

### API

| Arquivo | Descricao |
|---------|-----------|
| `Middlewares/TenantMiddleware.cs` | Extrai tenant do JWT |
| `Controllers/AdminController.cs` | Endpoints de admin |

---

**Implementado por**: Claude Code
**Status**: Implementacao Completa
**Data**: 2026-01-26
