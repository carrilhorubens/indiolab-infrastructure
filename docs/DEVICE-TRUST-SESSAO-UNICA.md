# Device Trust + Sessão Única — Documentação Técnica

> Segurança pré-autenticação para o OpticalCore ERP.
> Status: **Planejado** — implementação pendente.

---

## 1. Visão Geral

### Problema

O sistema atual permite login com email + senha de qualquer lugar e dispositivo, sem nenhuma verificação adicional. Riscos:

- Senha vazada → acesso imediato por atacante
- Mesmo usuário logado simultaneamente em vários dispositivos
- Nenhum registro de quais dispositivos acessam o sistema
- Sem forma de revogar acesso remoto

### Solução

Duas camadas complementares:

| Camada | Descrição |
|--------|-----------|
| **Device Trust** | Dispositivo novo requer verificação por código enviado ao email do usuário |
| **Sessão Única** | Apenas 1 sessão ativa por usuário — login em device B invalida device A |

### Resultado esperado

```
Login (email + senha válidos)
    │
    ├── Dispositivo CONFIÁVEL (cookie device_token válido)
    │   ├── Invalida sessões anteriores
    │   └── ✅ Login direto → JWT com sessionId
    │
    └── Dispositivo NOVO (sem cookie ou cookie inválido)
        ├── 📧 Envia código 6 dígitos por email
        ├── Usuário digita o código
        │   ├── ✅ Código válido → salva dispositivo + cookie 90 dias → JWT
        │   └── ❌ Código inválido/expirado → bloqueia
        └── Reenviar código (máximo 3 vezes por tentativa)
```

---

## 2. Entidades

### 2.1 DispositivoConfiavel

Tabela: `public.dispositivos_confiaveis`

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | `Guid` (PK) | Identificador único |
| `usuario_id` | `Guid` (FK → `usuarios.Id`) | Usuário dono do dispositivo |
| `device_token` | `string` (UUID, unique, indexed) | Token salvo no cookie HttpOnly |
| `fingerprint_hash` | `string?` | Hash do fingerprint do navegador (complementar) |
| `nome_dispositivo` | `string` | Ex: "Chrome 120 — Windows 10" |
| `ip_primeiro_acesso` | `string` | IP de quando o dispositivo foi autorizado |
| `ip_ultimo_acesso` | `string?` | IP do último login |
| `ultimo_acesso` | `DateTime` | Data/hora do último login |
| `ativo` | `bool` | Dispositivo pode ser desativado sem deletar |
| `criado_em` | `DateTime` | Data de autorização |
| `expira_em` | `DateTime` | Expiração (90 dias a partir da criação) |

**Índices:**
- `UNIQUE` em `device_token`
- `INDEX` em `usuario_id`

**Regras:**
- Máximo de **5 dispositivos confiáveis** por usuário (configurável)
- Expiração padrão: **90 dias** (configurável)
- Dispositivo expirado requer nova verificação
- Dispositivo inativo (`ativo = false`) requer nova verificação

### 2.2 SessaoAtiva

Tabela: `public.sessoes_ativas`

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | `Guid` (PK) | Identificador da sessão (incluído no JWT como claim `session_id`) |
| `usuario_id` | `Guid` (FK → `usuarios.Id`) | Usuário da sessão |
| `dispositivo_id` | `Guid?` (FK → `dispositivos_confiaveis.Id`) | Dispositivo usado |
| `ip_address` | `string` | IP do login |
| `user_agent` | `string?` | User-Agent do navegador |
| `criado_em` | `DateTime` | Início da sessão |
| `expira_em` | `DateTime` | Expiração (mesmo TTL do JWT) |
| `revogado_em` | `DateTime?` | Se preenchido, sessão foi invalidada |
| `motivo_revogacao` | `string?` | "novo_login", "logout", "admin_revogou", "dispositivo_removido" |

**Índices:**
- `INDEX` em `usuario_id` (filtro por sessões ativas)
- `INDEX` em `dispositivo_id`

**Regras:**
- Apenas **1 sessão ativa** (não revogada e não expirada) por usuário
- Ao criar nova sessão → revogar todas as anteriores com motivo `"novo_login"`
- JWT inclui claim `session_id` → middleware valida a cada request

### 2.3 CodigoVerificacaoDispositivo

Tabela: `public.codigos_verificacao_dispositivo`

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id` | `Guid` (PK) | Identificador |
| `usuario_id` | `Guid` (FK) | Usuário que solicitou |
| `codigo` | `string` (6 dígitos) | Código enviado por email |
| `fingerprint_hash` | `string?` | Fingerprint do dispositivo que solicitou |
| `ip_address` | `string` | IP de onde solicitou |
| `user_agent` | `string?` | Navegador |
| `criado_em` | `DateTime` | Hora do envio |
| `expira_em` | `DateTime` | 5 minutos após criação |
| `usado_em` | `DateTime?` | Se preenchido, código já foi utilizado |
| `tentativas` | `int` | Quantas vezes tentou validar (máx: 5) |

**Regras:**
- Código expira em **5 minutos**
- Máximo **5 tentativas** de validação por código
- Máximo **3 códigos** por email em 15 minutos (anti-spam)
- Após usar, marcar `usado_em` (não pode reutilizar)

---

## 3. Serviços

### 3.1 IDeviceTrustService

```csharp
public interface IDeviceTrustService
{
    /// Verifica se o device_token é de um dispositivo confiável e ativo do usuário
    Task<DispositivoConfiavel?> ValidarDispositivoAsync(Guid usuarioId, string deviceToken, CancellationToken ct);

    /// Gera código de 6 dígitos, salva no banco e envia por email
    Task<Guid> EnviarCodigoVerificacaoAsync(Guid usuarioId, string ipAddress, string? userAgent, string? fingerprintHash, CancellationToken ct);

    /// Valida o código digitado. Se válido, cria dispositivo confiável e retorna o device_token
    Task<(bool valido, string? deviceToken, string? erro)> ValidarCodigoAsync(Guid codigoId, string codigo, string? fingerprintHash, CancellationToken ct);

    /// Lista dispositivos confiáveis do usuário
    Task<IReadOnlyList<DispositivoConfiavel>> ListarDispositivosAsync(Guid usuarioId, CancellationToken ct);

    /// Revoga um dispositivo (marca como inativo + revoga sessão associada)
    Task RevogarDispositivoAsync(Guid usuarioId, Guid dispositivoId, CancellationToken ct);

    /// Remove dispositivos expirados (job periódico ou manual)
    Task LimparExpiradosAsync(CancellationToken ct);
}
```

### 3.2 ISessionService

```csharp
public interface ISessionService
{
    /// Cria sessão ativa para o usuário, revogando todas as anteriores
    Task<SessaoAtiva> CriarSessaoAsync(Guid usuarioId, Guid? dispositivoId, string ipAddress, string? userAgent, DateTime expiraEm, CancellationToken ct);

    /// Verifica se a sessão ainda está ativa (não revogada, não expirada)
    Task<bool> SessaoAtivaAsync(Guid sessaoId, CancellationToken ct);

    /// Revoga sessão por logout
    Task RevogarSessaoAsync(Guid sessaoId, string motivo, CancellationToken ct);

    /// Revoga todas as sessões do usuário (admin ou troca de senha)
    Task RevogarTodasSessoesAsync(Guid usuarioId, string motivo, CancellationToken ct);
}
```

### 3.3 IEmailService

```csharp
public interface IEmailService
{
    /// Envia email com código de verificação de dispositivo
    Task EnviarCodigoVerificacaoDispositivoAsync(string email, string nomeUsuario, string codigo, string nomeDispositivo, string ipAddress, CancellationToken ct);
}
```

**Implementação:**
- **Produção:** SMTP configurável via `appsettings.json` (host, porta, user, senha, SSL)
- **Desenvolvimento:** Log no console + salvar em `/tmp/opticalcore-emails.log` (sem envio real)
- Template HTML do email com branding OpticalCore

---

## 4. Fluxo de Login (Modificado)

### 4.1 Endpoint Atual: `POST /api/auth/login`

**Request (modificado):**
```json
{
    "email": "usuario@empresa.com",
    "password": "Senha@123",
    "deviceToken": "uuid-do-cookie-ou-null",
    "fingerprintHash": "hash-do-navegador-ou-null"
}
```

**Responses possíveis:**

#### A) Dispositivo confiável → Login direto
```json
{
    "accessToken": "eyJ...",
    "refreshToken": "abc...",
    "expiration": "2026-03-24T...",
    "user": { ... },
    "deviceToken": "uuid-existente"
}
```
- HTTP 200
- Cookie `device_token` renovado (90 dias)
- Sessões anteriores invalidadas

#### B) Dispositivo novo → Requer verificação
```json
{
    "requiresDeviceVerification": true,
    "verificationId": "guid-do-codigo",
    "emailMasked": "r***@empresa.com",
    "message": "Código de verificação enviado para seu email"
}
```
- HTTP 200 (não é erro — é step intermediário)
- Email enviado com código de 6 dígitos
- Frontend exibe dialog de verificação

#### C) Credenciais inválidas
```json
{
    "message": "Email ou senha inválidos"
}
```
- HTTP 401

### 4.2 Novo Endpoint: `POST /api/auth/verify-device`

**Request:**
```json
{
    "verificationId": "guid-do-codigo",
    "code": "123456",
    "fingerprintHash": "hash-do-navegador"
}
```

**Response (sucesso):**
```json
{
    "accessToken": "eyJ...",
    "refreshToken": "abc...",
    "expiration": "2026-03-24T...",
    "user": { ... },
    "deviceToken": "novo-uuid"
}
```
- HTTP 200
- Cookie `device_token` setado (HttpOnly, Secure, SameSite=Strict, 90 dias)
- Dispositivo salvo como confiável

**Response (código inválido):**
```json
{
    "message": "Código inválido",
    "attemptsRemaining": 3
}
```
- HTTP 400

### 4.3 Novo Endpoint: `POST /api/auth/resend-code`

**Request:**
```json
{
    "verificationId": "guid-do-codigo"
}
```
- Gera novo código, invalida o anterior
- Máximo 3 reenvios por tentativa de login
- HTTP 200 com novo `verificationId`

### 4.4 Endpoint Existente: `POST /api/auth/logout` (Modificado)

- Revoga a sessão ativa (marca `revogado_em` + motivo `"logout"`)
- Resposta: HTTP 200

---

## 5. Middleware de Validação de Sessão

### SessionValidationMiddleware

Intercepta **todas** as requests autenticadas (exceto `/api/auth/*`).

```
Request com JWT
    │
    ├── JWT tem claim "session_id"?
    │   ├── NÃO → 401 (JWT legado, sem sessão)
    │   └── SIM → Sessão ativa no banco?
    │       ├── SIM → ✅ Continua
    │       └── NÃO → 401 + header "X-Session-Revoked: true"
    │                  + body: { "message": "Sessão encerrada. Login realizado em outro dispositivo." }
    │
    └── Request não autenticada → passa direto
```

**Claim no JWT:**
```csharp
new Claim("session_id", sessao.Id.ToString())
```

**Performance:** Cache em memória (IMemoryCache) com TTL de 30 segundos para evitar query a cada request.

---

## 6. Frontend

### 6.1 LoginPage.tsx (Modificado)

Após `POST /api/auth/login`:

```
if (response.requiresDeviceVerification) {
    // Abrir DeviceVerificationDialog
    setVerificationId(response.verificationId);
    setShowVerification(true);
} else {
    // Login normal — salvar JWT + navegar
    localStorage.setItem('device_token', response.deviceToken);
}
```

### 6.2 DeviceVerificationDialog.tsx (Novo)

- Dialog modal centralizado (não pode fechar sem verificar ou cancelar)
- Input de 6 dígitos (auto-focus, aceita paste)
- Botão "Verificar"
- Link "Reenviar código" (com countdown de 60s entre reenvios)
- Mensagem: "Enviamos um código de verificação para r***@empresa.com"
- Após sucesso: salvar `device_token` no localStorage, fechar dialog, continuar login

### 6.3 AuthContext.tsx (Modificado)

- Enviar `device_token` do localStorage em toda request de login
- Gerar `fingerprintHash` via biblioteca (ex: `@fingerprintjs/fingerprintjs`)
- Interceptor Axios: se receber 401 com header `X-Session-Revoked`, mostrar dialog:
  > "Sua sessão foi encerrada porque um login foi realizado em outro dispositivo."
  > [Ir para Login]

### 6.4 MeusDispositivosPage.tsx (Novo)

Rota: `/configuracoes/meus-dispositivos`

**Layout:**
```
┌──────────────────────────────────────────────────────────┐
│ Meus Dispositivos                                         │
│ Gerencie os dispositivos autorizados para sua conta        │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  🖥️ Chrome 120 — Windows 10           ★ Dispositivo atual │
│     IP: 187.45.xx.xx                                       │
│     Último acesso: Hoje, 10:30                             │
│     Autorizado em: 20/03/2026                              │
│                                                            │
│  📱 Safari — iPhone                         [Revogar]     │
│     IP: 189.12.xx.xx                                       │
│     Último acesso: 21/03/2026, 14:22                       │
│     Autorizado em: 15/03/2026                              │
│                                                            │
│  💻 Firefox 119 — macOS              [Revogar]            │
│     IP: 200.18.xx.xx                                       │
│     Último acesso: 18/03/2026, 09:15                       │
│     Autorizado em: 10/03/2026                              │
│     ⚠️ Expira em 5 dias                                   │
│                                                            │
│  [Revogar Todos os Dispositivos]                           │
└──────────────────────────────────────────────────────────┘
```

- DataGrid com dispositivos do usuário logado
- Dispositivo atual marcado (comparar `device_token` do localStorage com lista)
- Não pode revogar o dispositivo atual
- Botão "Revogar Todos" (exceto o atual) com confirmação

---

## 7. Configuração por Empresa

Tabela `public.\"Companies\"` — novos campos:

| Campo | Tipo | Default | Descrição |
|-------|------|---------|-----------|
| `DeviceTrustAtivo` | `bool` | `true` | Habilita/desabilita verificação de dispositivo |
| `SessaoUnicaAtiva` | `bool` | `true` | Habilita/desabilita sessão única |
| `MaxDispositivosPorUsuario` | `int` | `5` | Máximo de dispositivos confiáveis |
| `DiasExpiracaoDispositivo` | `int` | `90` | Dias até expirar o dispositivo |
| `MinutosExpiracaoCodigo` | `int` | `5` | Minutos para expirar código de verificação |

**Tela:** Configurações → Empresas → aba "Segurança" no EmpresaFormDialog.

**Bypass:** Usuário Root ignora Device Trust (acessa de qualquer dispositivo sem código).

---

## 8. Email — Template do Código

### Assunto
`OpticalCore — Código de verificação: 123456`

### Corpo (HTML)
```
┌──────────────────────────────────────┐
│        🔒 OpticalCore                 │
│    Verificação de Dispositivo         │
├──────────────────────────────────────┤
│                                        │
│  Olá, {NomeUsuario}!                   │
│                                        │
│  Detectamos um login na sua conta      │
│  a partir de um novo dispositivo.      │
│                                        │
│  Seu código de verificação:            │
│                                        │
│      ┌─────────────────────┐           │
│      │      1 2 3 4 5 6    │           │
│      └─────────────────────┘           │
│                                        │
│  Este código expira em 5 minutos.      │
│                                        │
│  Dispositivo: Chrome — Windows 10      │
│  IP: 187.45.123.456                    │
│  Data: 23/03/2026 às 10:30             │
│                                        │
│  Se você NÃO tentou fazer login,       │
│  altere sua senha imediatamente.       │
│                                        │
└──────────────────────────────────────┘
```

---

## 9. Configuração SMTP (`appsettings.json`)

```json
{
    "EmailSettings": {
        "SmtpHost": "smtp.gmail.com",
        "SmtpPort": 587,
        "SmtpUser": "noreply@opticalcore.com",
        "SmtpPassword": "app-password-aqui",
        "UseSsl": true,
        "FromName": "OpticalCore",
        "FromEmail": "noreply@opticalcore.com",
        "Enabled": true
    }
}
```

Em **desenvolvimento** (`Enabled: false`):
- Não envia email real
- Loga código no console: `[EMAIL DEV] Código 123456 para usuario@empresa.com`
- Salva em `/tmp/opticalcore-emails.log`

---

## 10. Migration

Nome: `AddDeviceTrustAndActiveSessions`

**Application context (public):**
- `CREATE TABLE dispositivos_confiaveis` (8 colunas + índices)
- `CREATE TABLE sessoes_ativas` (9 colunas + índices)
- `CREATE TABLE codigos_verificacao_dispositivo` (9 colunas + índices)
- `ALTER TABLE "Companies" ADD COLUMN "DeviceTrustAtivo" boolean DEFAULT true`
- `ALTER TABLE "Companies" ADD COLUMN "SessaoUnicaAtiva" boolean DEFAULT true`
- `ALTER TABLE "Companies" ADD COLUMN "MaxDispositivosPorUsuario" int DEFAULT 5`
- `ALTER TABLE "Companies" ADD COLUMN "DiasExpiracaoDispositivo" int DEFAULT 90`
- `ALTER TABLE "Companies" ADD COLUMN "MinutosExpiracaoCodigo" int DEFAULT 5`

---

## 11. Permissões

Adicionar em `Permissions.cs`:

```csharp
public static class Seguranca
{
    public const string ViewDispositivos = "Permissions.Seguranca.ViewDispositivos";
    public const string ManageDispositivos = "Permissions.Seguranca.ManageDispositivos";
    public const string ViewSessoes = "Permissions.Seguranca.ViewSessoes";
    public const string RevokeSessoes = "Permissions.Seguranca.RevokeSessoes";
}
```

Adicionar módulo SEGURANCA no `ModulesPermissionsSeed.cs`.

---

## 12. Endpoints Resumo

| Método | Rota | Descrição | Auth |
|--------|------|-----------|------|
| `POST` | `/api/auth/login` | Login (modificado — verifica device) | Público |
| `POST` | `/api/auth/verify-device` | Validar código de verificação | Público |
| `POST` | `/api/auth/resend-code` | Reenviar código de verificação | Público |
| `POST` | `/api/auth/logout` | Logout (revoga sessão) | JWT |
| `GET` | `/api/auth/dispositivos` | Listar dispositivos do usuário | JWT |
| `DELETE` | `/api/auth/dispositivos/{id}` | Revogar dispositivo | JWT |
| `DELETE` | `/api/auth/dispositivos` | Revogar todos (exceto atual) | JWT |
| `GET` | `/api/admin/sessoes` | Listar sessões ativas (admin) | Admin |
| `DELETE` | `/api/admin/sessoes/{userId}` | Revogar sessões de um usuário | Admin |

---

## 13. Sequência de Implementação

| Fase | Descrição | Estimativa |
|------|-----------|-----------|
| **1** | Entidades + Migration + DbContext | Backend |
| **2** | EmailService (SMTP + dev fallback) | Backend |
| **3** | DeviceTrustService + SessionService | Backend |
| **4** | Modificar AuthController (login flow) | Backend |
| **5** | SessionValidationMiddleware | Backend |
| **6** | DeviceTrustController (CRUD dispositivos) | Backend |
| **7** | LoginPage + DeviceVerificationDialog | Frontend |
| **8** | AuthContext (device_token + sessão expirada) | Frontend |
| **9** | MeusDispositivosPage | Frontend |
| **10** | Configurações empresa (aba Segurança) | Full-stack |
| **11** | Testes e ajustes | Full-stack |

---

## 14. Considerações de Segurança

- **Cookie `device_token`:** HttpOnly + Secure + SameSite=Strict (não acessível por JS)
- **Código de verificação:** 6 dígitos numéricos, gerados com `RandomNumberGenerator` (criptograficamente seguro)
- **Tentativas limitadas:** 5 tentativas por código, 3 códigos por 15 minutos
- **Fingerprint:** Complementar ao cookie — detecta se alguém clonou o cookie para outro navegador
- **Root bypass:** Root não precisa de verificação de dispositivo
- **Logout em cascade:** Revogar dispositivo → revoga sessão associada → usuário é desconectado
- **Auditoria:** Todos os eventos (novo dispositivo, verificação, revogação, sessão expirada) logados
