# Análise de Melhorias — OpticalCore ERP

> Gerado em 2026-03-24 com base na análise completa do codebase.
> Organizado por prioridade: CRÍTICO > ALTO > MÉDIO > BAIXO

---

## Números do Projeto (snapshot atual)

| Métrica | Valor |
|---------|-------|
| Backend Services | 213 |
| Backend Controllers | ~30+ |
| Backend Entities (Domain) | ~100+ |
| Frontend Pages | ~50+ |
| Frontend Services | 105 |
| Migrations | 210 |
| FluentValidation Validators | **13** |
| Testes automatizados | **0** |
| Background Services | **1** (WhatsAppHealthCheck) |

---

## 1. CRÍTICO — Segurança

### 1.1 Secrets hardcoded no código e docker-compose
**Skills relacionados:** `007`, `security-audit`, `varlock`, `secrets-management`

**Problema:** JWT Secret, senha do PostgreSQL e API keys da Evolution estão hardcoded em `appsettings.json` e `docker-compose.yml`:
```
JwtSettings__Secret=OpticalCoreSecretKeyMuitoLongaESeguraParaJWT2024!@#
POSTGRES_PASSWORD=pegasus
WhatsApp__EvolutionApiKey=opticalcore-whatsapp-key
```

**Risco:** Se o repositório vazar (mesmo privado), todas as credenciais estão expostas.

**Solução:**
- Usar `.env` files (não commitados) + `docker-compose` com `env_file:`
- Ou Docker Secrets / HashiCorp Vault em produção
- Rotacionar TODAS as secrets atuais (já estão no git history)

### 1.2 Sem Rate Limiting na API
**Skills relacionados:** `api-security-best-practices`, `backend-security-coder`

**Problema:** Zero rate limiting encontrado. Qualquer endpoint (login, cadastro, WhatsApp) pode ser bombardeado sem limitação.

**Risco:** Brute-force de login, DDoS na API, abuso do WhatsApp (envio em massa).

**Solução:**
- Adicionar `AspNetCoreRateLimit` ou o built-in `RateLimiter` do .NET 8+
- Regras: login (5/min por IP), API geral (100/min por tenant), WhatsApp (30/min)

### 1.3 CORS muito aberto
**Skills relacionados:** `web-security-testing`, `api-security-best-practices`

**Problema:** CORS permite `AllowAnyMethod()` + `AllowAnyHeader()`. Embora tenha origins específicas, os métodos e headers deveriam ser restritos.

**Solução:** Especificar apenas `GET, POST, PUT, DELETE` e headers necessários (`Authorization`, `Content-Type`).

### 1.4 Swagger exposto em produção
**Skills relacionados:** `security-audit`, `api-security-best-practices`

**Problema:** `app.UseSwagger()` e `app.UseSwaggerUI()` estão fora de qualquer condição `if (env.IsDevelopment())`.

**Solução:** Condicionar ao ambiente de desenvolvimento.

---

## 2. CRÍTICO — Testes

### 2.1 Zero testes automatizados
**Skills relacionados:** `test-driven-development`, `testing-patterns`, `e2e-testing`, `python-testing-patterns`

**Problema:** O projeto tem 213 services, 210 migrations, 100+ entidades e **ZERO** testes. Este é o maior risco técnico do projeto.

**Impacto:**
- Cada mudança pode quebrar funcionalidades existentes sem detecção
- Migrations sem teste podem corromper dados em produção
- Refatorações são arriscadas e lentas

**Solução recomendada (progressiva):**

| Fase | Tipo | Cobertura alvo | Skills |
|------|------|---------------|--------|
| 1 | Unit tests (Domain) | Entidades, Value Objects, regras de negócio | `test-driven-development`, `tdd-workflows-tdd-red` |
| 2 | Integration tests (Services) | Services críticos (Venda, Estoque, Financeiro) | `testing-patterns` |
| 3 | API tests (Controllers) | Endpoints de CRUD + auth + multi-tenant | `api-security-testing` |
| 4 | E2E (Frontend) | Fluxos críticos (login, venda, WhatsApp) | `playwright-skill`, `e2e-testing` |

**Stack sugerida:**
- Backend: xUnit + FluentAssertions + Testcontainers (PostgreSQL real)
- Frontend: Vitest + Testing Library + Playwright (E2E)

---

## 3. ALTO — Observabilidade

### 3.1 Logging apenas no Console
**Skills relacionados:** `observability-engineer`, `grafana-dashboards`, `prometheus-configuration`

**Problema:** Serilog está configurado apenas com `WriteTo: Console`. Em produção dentro de Docker, logs se perdem quando o container reinicia.

**Solução:**
- Adicionar sink para arquivo (`Serilog.Sinks.File` com rotação diária)
- Ou melhor: Serilog → Seq / Loki / Elasticsearch
- Adicionar correlation IDs nos requests (middleware)

### 3.2 Sem Health Checks padrão do ASP.NET
**Skills relacionados:** `observability-monitoring-monitor-setup`, `kubernetes-deployment`

**Problema:** O projeto tem um `WhatsAppHealthCheckService` customizado, mas não usa o sistema de Health Checks padrão do ASP.NET (`app.MapHealthChecks`).

**Solução:**
```csharp
builder.Services.AddHealthChecks()
    .AddNpgSql(connectionString)
    .AddCheck<WhatsAppHealthCheck>("whatsapp");
app.MapHealthChecks("/health");
```

### 3.3 Sem métricas de aplicação
**Skills relacionados:** `prometheus-configuration`, `grafana-dashboards`, `slo-implementation`

**Problema:** Nenhuma métrica sendo coletada — response time, request count, error rate, queries/s.

**Solução:**
- OpenTelemetry + Prometheus exporter
- Dashboard Grafana com: latência P50/P95/P99, error rate, throughput por tenant

---

## 4. ALTO — Performance

### 4.1 Sem Response Compression
**Skills relacionados:** `web-performance-optimization`, `performance-optimizer`

**Problema:** A API não comprime respostas. Para listagens grandes (produtos, clientes) com DataGrid, isso causa payloads desnecessariamente grandes.

**Solução:**
```csharp
builder.Services.AddResponseCompression(opts => {
    opts.EnableForHttps = true;
});
app.UseResponseCompression(); // antes de UseStaticFiles
```

### 4.2 Sem caching
**Skills relacionados:** `performance-optimizer`, `database-optimizer`

**Problema:** Zero caching encontrado — nem `IMemoryCache`, nem `IDistributedCache`, nem `ResponseCache`. Dados que raramente mudam (domínios, permissões, configurações) são buscados do banco a cada request.

**Solução:**
- `IMemoryCache` para domínios/lookups (TTL 5-15min)
- `OutputCache` para endpoints read-heavy
- Redis se escalar para múltiplas instâncias

### 4.3 Apenas 13 FluentValidation Validators para 213 Services
**Skills relacionados:** `backend-dev-guidelines`, `clean-code`

**Problema:** Proporção de 13:213 indica que a maioria dos Commands/Queries não tem validação formal. Dados inválidos podem chegar ao banco.

**Solução:** Criar validators para todos os Commands de criação/edição, começando pelos módulos críticos (Vendas, Estoque, Financeiro).

---

## 5. ALTO — CI/CD

### 5.1 Pipeline mínimo demais
**Skills relacionados:** `github-actions-templates`, `deployment-pipeline-design`, `cicd-automation-workflow-automate`

**Problema:** O workflow de deploy é apenas:
```yaml
steps:
  - name: Executar deploy
    run: /home/developer/deploy.sh
```

Não há:
- Build/compile check
- Lint check
- Testes
- Scan de segurança
- Build de imagens Docker
- Rollback automático

**Solução:** Pipeline completo:
```
push → lint → build → test → security-scan → docker-build → deploy → smoke-test
```

### 5.2 Sem ambiente de staging
**Skills relacionados:** `deployment-procedures`, `deployment-engineer`

**Problema:** Deploy direto na produção (`push main → deploy`). Qualquer bug vai direto para o cliente.

**Solução:** Branch `develop` → staging → `main` → produção.

---

## 6. MÉDIO — Arquitetura Backend

### 6.1 Sem API Versioning
**Skills relacionados:** `api-design-principles`, `api-patterns`

**Problema:** Nenhum versionamento de API encontrado. Quando precisar mudar contratos, quebrará clientes existentes.

**Solução:** Adicionar `Asp.Versioning.Mvc` com URL path versioning (`/api/v1/clientes`).

### 6.2 Sem Outbox Pattern para eventos
**Skills relacionados:** `event-sourcing-architect`, `microservices-patterns`

**Problema:** Operações que envolvem múltiplos passos (ex: criar venda + atualizar estoque + enviar WhatsApp) não têm garantia de consistência.

**Solução (futuro):** Implementar Outbox Pattern com MediatR notifications para garantir que side-effects sejam processados mesmo em caso de falha.

### 6.3 Apenas 1 Background Service
**Skills relacionados:** `workflow-orchestration-patterns`, `bullmq-specialist`

**Problema:** Apenas `WhatsAppHealthCheckService` roda em background. Operações pesadas (relatórios, sync, importação) provavelmente bloqueiam threads de request.

**Solução:** Criar background services ou usar Hangfire/Quartz para:
- Geração de relatórios pesados
- Sync periódico de dados
- Limpeza de uploads antigos
- Notificações agendadas

---

## 7. MÉDIO — Frontend

### 7.1 Sem PWA
**Skills relacionados:** `progressive-web-app`, `mobile-design`

**Problema:** Zero configuração PWA. Para um ERP usado por laboratórios, funcionalidade offline (consulta de estoque, pedidos pendentes) seria muito útil.

**Solução:** Adicionar `vite-plugin-pwa` com cache de assets + manifest + service worker básico.

### 7.2 Sem i18n (por enquanto OK, mas planejar)
**Skills relacionados:** `i18n-localization`

**Problema:** Textos hardcoded em pt-BR. Hoje é aceitável, mas impossibilita internacionalização futura.

**Decisão:** Se o plano for sempre pt-BR, ignorar. Se houver planos de expansão, implementar `react-i18next` desde já.

### 7.3 ESLint com configuração mínima
**Skills relacionados:** `frontend-dev-guidelines`, `cc-skill-coding-standards`

**Problema:** ESLint tem apenas `recommended` + `react-hooks` + `react-refresh`. Sem regras de:
- Import ordering
- Unused imports auto-fix
- Naming conventions
- Accessibility (eslint-plugin-jsx-a11y)

**Solução:** Adicionar plugins de import, accessibility e custom rules do projeto.

### 7.4 Sem Error Tracking no Frontend
**Skills relacionados:** `error-debugging-error-analysis`, `sentry-automation`

**Problema:** Erros no frontend do cliente vão para `console.error` e se perdem.

**Solução:** Integrar Sentry ou similar para capturar erros em produção com stack traces e contexto do usuário/tenant.

---

## 8. MÉDIO — Docker e Infraestrutura

### 8.1 Dockerfile frontend pula TypeScript check
**Skills relacionados:** `docker-expert`, `typescript-expert`

**Problema:** O Dockerfile do frontend tem o comentário "Pular tsc (erros de imports não usados) e rodar Vite direto". Isso significa que erros de TypeScript passam sem detecção no build.

**Solução:** Corrigir os erros de TypeScript e restaurar `tsc -b` no build.

### 8.2 Sem Docker image scanning
**Skills relacionados:** `docker-expert`, `security-scanning-security-dependencies`

**Problema:** Imagens Docker não são escaneadas por vulnerabilidades.

**Solução:** Adicionar Trivy ou Snyk no pipeline CI.

### 8.3 PostgreSQL 15 (considerar upgrade)
**Skills relacionados:** `postgresql-optimization`, `database-admin`

**Problema:** Docker usa PostgreSQL 15. A versão 16/17 traz melhorias significativas de performance (parallel query, logical replication).

**Solução:** Planejar upgrade para PostgreSQL 17 com testes de compatibilidade.

---

## 9. BAIXO — Nice to Have

### 9.1 Sem documentação de API automatizada
**Skills relacionados:** `api-documentation`, `openapi-spec-generation`

**Solução:** Swagger já existe, mas gerar SDK client TypeScript automaticamente com `openapi-typescript-codegen` eliminaria a necessidade de manter services frontend manualmente (105 services).

### 9.2 Sem backup automatizado do banco
**Skills relacionados:** `database-admin`, `devops-deploy`

**Solução:** CronJob com `pg_dump` + upload para S3/MinIO com retenção de 30 dias.

### 9.3 Sem monitoramento de uptime
**Skills relacionados:** `observability-monitoring-monitor-setup`, `incident-responder`

**Solução:** UptimeKuma ou Grafana Alerting monitorando `/health` endpoint.

### 9.4 Sem audit log
**Skills relacionados:** `security-audit`, `event-sourcing-architect`

**Solução:** Middleware ou interceptor EF Core para registrar quem alterou o quê e quando (compliance, LGPD).

---

## Matriz de Priorização

| # | Melhoria | Esforço | Impacto | Prioridade |
|---|----------|---------|---------|------------|
| 1.1 | Remover secrets do código | Baixo | Crítico | **P0** |
| 1.4 | Swagger só em dev | Baixo | Alto | **P0** |
| 1.2 | Rate Limiting | Médio | Crítico | **P0** |
| 2.1 | Testes automatizados (fase 1) | Alto | Crítico | **P1** |
| 4.1 | Response Compression | Baixo | Alto | **P1** |
| 4.2 | Caching de domínios | Médio | Alto | **P1** |
| 3.1 | Logging persistente | Baixo | Alto | **P1** |
| 3.2 | Health Checks ASP.NET | Baixo | Médio | **P1** |
| 5.1 | Pipeline CI/CD completo | Médio | Alto | **P2** |
| 1.3 | CORS restritivo | Baixo | Médio | **P2** |
| 4.3 | Validators faltando | Médio | Alto | **P2** |
| 8.1 | Fix TypeScript build | Médio | Médio | **P2** |
| 7.4 | Error tracking frontend | Baixo | Médio | **P2** |
| 6.1 | API Versioning | Médio | Médio | **P3** |
| 6.3 | Background jobs | Médio | Médio | **P3** |
| 7.1 | PWA | Médio | Médio | **P3** |
| 9.2 | Backup automatizado | Baixo | Alto | **P3** |
| 9.3 | Monitoramento uptime | Baixo | Médio | **P3** |
| 9.4 | Audit log | Alto | Médio | **P3** |

---

## Skills Mais Relevantes para este Projeto

Com base na análise, estes são os skills instalados que trariam mais valor imediato:

| Skill | Aplicação |
|-------|-----------|
| `007` / `security-audit` | Auditoria completa de segurança |
| `test-driven-development` | Implementar testes do zero |
| `playwright-skill` | Testes E2E dos fluxos críticos |
| `observability-engineer` | Setup de logging + métricas + tracing |
| `github-actions-templates` | Pipeline CI/CD robusto |
| `docker-expert` | Otimização e segurança dos containers |
| `api-security-best-practices` | Rate limiting, CORS, headers |
| `database-optimizer` | Caching, query optimization |
| `performance-optimizer` | Compression, lazy loading, bundle size |
| `dotnet-backend` | Patterns .NET modernos |
| `react-best-practices` | Performance frontend |
| `whatsapp-cloud-api` | Melhorias na integração WhatsApp |
| `postgresql-optimization` | Tuning do PostgreSQL |
| `devops-deploy` | Infraestrutura de deploy |
| `sentry-automation` | Error tracking em produção |

---

*Este documento deve ser revisitado mensalmente para acompanhar o progresso das melhorias.*
