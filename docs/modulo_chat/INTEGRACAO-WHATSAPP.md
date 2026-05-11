# Integração Chat + WhatsApp — Pesquisa e Plano de Implementação

> Pesquisa realizada em 2026-03-17. Documento de referência para futura implementação.

---

## 1. Contexto

O módulo Chat do OpticalCore (SignalR, 1:1/grupo, cross-tenant) já está 100% implementado com 6 fases completas. O objetivo desta integração é permitir que os **laboratórios ópticos** (tenants) se comuniquem com as **óticas clientes** diretamente pelo WhatsApp, tudo gerenciado dentro do ERP.

**Caso de uso principal:** Laboratório recebe mensagens das óticas no WhatsApp → responde pelo Chat do ERP → histórico unificado.

---

## 2. Opções Avaliadas

### Opção A: WhatsApp Business API (Cloud API by Meta) — API Oficial

| Aspecto | Detalhe |
|---------|---------|
| **O que é** | API oficial da Meta para enviar/receber mensagens WhatsApp programaticamente |
| **Requisito** | Conta Meta Business Suite + WhatsApp Business Account verificada |
| **Custo** | Pago por **conversa** (não por mensagem). ~US$0.05-0.08/conversa de 24h (varia por país) |
| **Limite** | Até 1.000 conversas/dia inicialmente, escalável até 100k+ com verificação |
| **Hospedagem** | Cloud (Meta hospeda) — sem infra própria |
| **Janela 24h** | Após a última mensagem do cliente, você tem 24h para responder livremente. Depois, só **templates pré-aprovados** |
| **Templates** | Meta revisa cada template (1-24h). Não pode enviar mensagem "livre" fora da janela |
| **Grupos** | NÃO suporta criar/gerenciar grupos WhatsApp via API |
| **Verificação** | Empresa precisa ser verificada pela Meta (CNPJ, site, etc.) |
| **Número** | Precisa de um número de telefone dedicado (não pode ser o pessoal) |

**Custos estimados (Brasil):**

| Item | Custo |
|------|-------|
| Conversa iniciada pelo cliente (service) | ~R$0,25/conversa de 24h |
| Conversa iniciada pelo laboratório (utility) | ~R$0,35/conversa de 24h |
| Conversa marketing | ~R$0,65/conversa de 24h |
| **Estimativa mensal (100 conversas/dia)** | **~R$750-1.050/mês** |

### Opção B: Provedores Intermediários (Twilio, MessageBird, Vonage)

| Aspecto | Detalhe |
|---------|---------|
| **Vantagem** | API mais simples, SDK C# pronto (Twilio tem `Twilio.AspNet.Core`) |
| **Custo** | Twilio: ~US$0.005/msg + US$0.005/msg WhatsApp fee. Mais caro que direto |
| **Vantagem** | Abstrai complexidade do webhook Meta, templates pré-aprovados, sandbox para testes |
| **Desvantagem** | Mesmas limitações da API oficial (janela 24h, templates, sem grupos) |

### Opção C: Evolution API (Open-Source, Self-Hosted) — **Escolhida**

| Aspecto | Detalhe |
|---------|---------|
| **O que é** | API REST self-hosted que conecta ao WhatsApp via QR Code (como WhatsApp Web) |
| **Tecnologia** | Node.js + Baileys (protocolo WhatsApp Web reverse-engineered) |
| **Deploy** | Docker container (uma imagem, um `docker-compose.yml`) |
| **Custo** | **Gratuito** (open-source, MIT license) |
| **Multi-instância** | Sim — cada tenant pode ter seu próprio número |
| **Comunidade** | Enorme no Brasil, 10k+ stars no GitHub, muito usado em ERPs/CRMs brasileiros |
| **Repo** | `EvolutionAPI/evolution-api` no GitHub |
| **Janela 24h** | **Não tem** — pode enviar mensagem a qualquer momento |
| **Templates** | **Não precisa** — mensagem livre sempre |
| **Grupos WhatsApp** | **Sim** — diferente da API oficial |

### Outras alternativas open-source similares

| Projeto | Diferencial |
|---------|------------|
| **WPPConnect Server** | Brasileiro, REST API, mais simples que Evolution |
| **Baileys direto** | Lib Node.js pura — precisaria de um microserviço sidecar |
| **whatsapp-web.js** | Usa Puppeteer (mais pesado, headless browser) |
| **Venom Bot** | Brasileiro, similar ao WPPConnect |

### Comparativo Final

| Critério | API Oficial (Meta) | Twilio | Evolution API |
|----------|-------------------|--------|---------------|
| **Custo** | ~R$750-1.050/mês (100 conv/dia) | Mais caro que oficial | Grátis (self-hosted) |
| **Janela 24h** | Sim (limitante) | Sim | Não tem |
| **Templates obrigatórios** | Sim | Sim | Não precisa |
| **Grupos WhatsApp** | Não | Não | Sim |
| **Verificação Meta** | Obrigatória | Obrigatória | Não precisa |
| **Risco de ban** | Zero (oficial) | Zero | Baixo (B2B legítimo) |
| **Estabilidade** | Garantida | Garantida | Boa (patches em 1-3 dias) |
| **Complexidade** | Média | Baixa | Média |
| **SDK C#** | Não oficial | Sim (`Twilio.AspNet.Core`) | Não (REST API pura) |
| **Multi-tenant** | Sim (1 conta por tenant) | Sim | Sim (1 instância por tenant) |

**Decisão: Evolution API** — custo zero, sem limitações de janela/templates, suporta grupos, comunidade BR ativa.

---

## 3. Riscos (Evolution API)

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| **Ban do número** | Baixa-Média | Alto | Número dedicado, não fazer broadcast em massa, uso B2B legítimo |
| **Protocolo quebrar em update** | Média (1-2x/ano) | Médio | Comunidade ativa, patches em 1-3 dias. Manter Docker image atualizada |
| **Perda de sessão** | Baixa | Baixo | Persistência em PostgreSQL, reconexão automática, alerta no ERP |
| **Meta bloquear Baileys** | Muito Baixa | Alto | Existe há 5+ anos, Meta tolera. Se acontecer, migrar para API oficial |
| **Viola ToS da Meta** | Certa (tecnicamente) | Baixo (na prática) | Dezenas de milhares de empresas BR usam. Meta tolera uso B2B legítimo |

**Nota:** O risco real é para quem faz **spam em massa**, não para comunicação B2B legítima entre laboratório e óticas.

---

## 4. Arquitetura Proposta

### 4.1 Visão Geral

```
┌──────────────────────────────────────────────────────────────┐
│                         Docker Compose                        │
│                                                               │
│  ┌─────────────────┐     HTTP/REST      ┌──────────────────┐ │
│  │  OpticalCore    │◄──────────────────►│  Evolution API   │ │
│  │  .NET 8 API     │                    │  (Node.js)       │ │
│  │  porta 5050     │  Webhook POST      │  porta 8080      │ │
│  │                 │◄───────────────────│                  │ │
│  │  /api/whatsapp/ │                    │  QR Code auth    │ │
│  │  webhook        │                    │  Multi-instância │ │
│  │                 │                    │  Baileys engine   │ │
│  └────────┬────────┘                    └──────────────────┘ │
│           │                                      │            │
│           │ SignalR                               │ WebSocket  │
│           ▼                                      ▼            │
│     Usuários ERP                          WhatsApp Servers    │
│     (Chat interno)                        (óticas clientes)   │
└──────────────────────────────────────────────────────────────┘
```

### 4.2 Fluxo de Mensagens

```
RECEBER (ótica → laboratório):
  Ótica envia WhatsApp
    → WhatsApp Servers
      → Evolution API (Baileys WebSocket)
        → Webhook POST /api/whatsapp/webhook/{instancia}
          → WhatsAppWebhookController
            → WhatsAppService.ProcessarMensagemAsync()
              → ChatService (cria/atualiza Conversa + Mensagem com Canal="whatsapp")
                → SignalR hub → UI do Chat no ERP

ENVIAR (laboratório → ótica):
  Usuário digita no Chat do ERP
    → ChatService detecta Conversa.Canal == "whatsapp"
      → WhatsAppService.EnviarTextoAsync(instancia, numero, texto)
        → HTTP POST → Evolution API /message/sendText/{instancia}
          → Baileys → WhatsApp Servers
            → WhatsApp da ótica
```

### 4.3 Endpoints da Evolution API utilizados

| Endpoint | Método | Função |
|----------|--------|--------|
| `/instance/create` | POST | Criar instância (1 por tenant/número) |
| `/instance/connect/{name}` | GET | Obter QR Code para parear |
| `/instance/connectionState/{name}` | GET | Verificar status da conexão |
| `/instance/logout/{name}` | DELETE | Desconectar sessão |
| `/instance/delete/{name}` | DELETE | Remover instância |
| `/message/sendText/{name}` | POST | Enviar mensagem de texto |
| `/message/sendMedia/{name}` | POST | Enviar imagem/vídeo/documento |
| `/message/sendAudio/{name}` | POST | Enviar áudio (mensagem de voz) |
| `/chat/findContacts/{name}` | POST | Listar contatos |
| `/chat/findMessages/{name}` | POST | Buscar mensagens |

**Webhooks recebidos:**

| Evento | Quando |
|--------|--------|
| `MESSAGES_UPSERT` | Nova mensagem recebida |
| `MESSAGES_UPDATE` | Mensagem atualizada (status: enviada, entregue, lida) |
| `CONNECTION_UPDATE` | Status da conexão mudou (connected, disconnected, qrcode) |
| `QRCODE_UPDATED` | Novo QR Code gerado (para exibir no frontend) |
| `CONTACTS_UPDATE` | Contato atualizado |

---

## 5. Modelo de Dados

### 5.1 Novas Entidades

```csharp
// WhatsAppInstancia — 1 por tenant (schema public)
// Gerencia a conexão do número WhatsApp de cada laboratório
public class WhatsAppInstancia
{
    public Guid Id { get; set; }
    public Guid CompanyId { get; set; }            // FK → Company (tenant)
    public string NomeInstancia { get; set; }       // "lab-{companyId}" — identificador na Evolution API
    public string? NumeroWhatsApp { get; set; }     // "5511999999999" — preenchido após parear
    public string Status { get; set; } = "disconnected"; // "connected" | "disconnected" | "qrcode"
    public string? QrCodeBase64 { get; set; }       // QR Code atual (se status == "qrcode")
    public DateTime CriadoEm { get; set; }
    public DateTime? ConectadoEm { get; set; }
    public DateTime? DesconectadoEm { get; set; }
}

// WhatsAppContato — vínculo número WhatsApp ↔ Pessoa/Cliente do ERP (schema public)
public class WhatsAppContato
{
    public Guid Id { get; set; }
    public string NumeroWhatsApp { get; set; }      // "5511988887777" (sem @s.whatsapp.net)
    public string? NomePush { get; set; }           // Nome exibido no WhatsApp
    public string? FotoUrl { get; set; }            // URL da foto do perfil
    public Guid? PessoaId { get; set; }             // FK opcional → Pessoa (vincular com cliente/fornecedor)
    public Guid CompanyId { get; set; }             // FK → Company (tenant que fez o vínculo)
    public DateTime CriadoEm { get; set; }
    public DateTime? AtualizadoEm { get; set; }
}
```

### 5.2 Campos Extras nas Entidades Existentes do Chat

```csharp
// Conversa — adicionar:
public string Canal { get; set; } = "interno";      // "interno" | "whatsapp"
public string? WhatsAppNumero { get; set; }          // número da ótica (se Canal == "whatsapp")
public Guid? WhatsAppInstanciaId { get; set; }       // FK → WhatsAppInstancia (qual número do lab)

// Mensagem — adicionar:
public string? WhatsAppMessageId { get; set; }       // ID da mensagem no WhatsApp (para rastrear status)
public string? WhatsAppStatus { get; set; }          // "sent" | "delivered" | "read" | "failed"
```

### 5.3 Tabelas SQL (schema public)

```sql
-- Nova tabela: instâncias WhatsApp por tenant
CREATE TABLE IF NOT EXISTS whatsapp_instancias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id),
    nome_instancia VARCHAR(100) NOT NULL UNIQUE,
    numero_whatsapp VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'disconnected',
    qr_code_base64 TEXT,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    conectado_em TIMESTAMPTZ,
    desconectado_em TIMESTAMPTZ
);

-- Nova tabela: contatos WhatsApp vinculados a pessoas do ERP
CREATE TABLE IF NOT EXISTS whatsapp_contatos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_whatsapp VARCHAR(20) NOT NULL,
    nome_push VARCHAR(200),
    foto_url VARCHAR(500),
    pessoa_id UUID,  -- FK para pessoa no schema do tenant (cross-schema)
    company_id UUID NOT NULL REFERENCES companies(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ,
    UNIQUE(numero_whatsapp, company_id)
);

-- Alterações em tabelas existentes do Chat
ALTER TABLE chat_conversas ADD COLUMN IF NOT EXISTS canal VARCHAR(20) NOT NULL DEFAULT 'interno';
ALTER TABLE chat_conversas ADD COLUMN IF NOT EXISTS whatsapp_numero VARCHAR(20);
ALTER TABLE chat_conversas ADD COLUMN IF NOT EXISTS whatsapp_instancia_id UUID REFERENCES whatsapp_instancias(id);

ALTER TABLE chat_mensagens ADD COLUMN IF NOT EXISTS whatsapp_message_id VARCHAR(100);
ALTER TABLE chat_mensagens ADD COLUMN IF NOT EXISTS whatsapp_status VARCHAR(20);

CREATE INDEX IF NOT EXISTS idx_chat_conversas_canal ON chat_conversas(canal);
CREATE INDEX IF NOT EXISTS idx_chat_mensagens_whatsapp_id ON chat_mensagens(whatsapp_message_id) WHERE whatsapp_message_id IS NOT NULL;
```

---

## 6. Backend — Implementação

### 6.1 WhatsAppService

```csharp
public interface IWhatsAppService
{
    // Gerenciamento de instância
    Task<WhatsAppInstancia> CriarInstanciaAsync(Guid companyId, CancellationToken ct = default);
    Task<string> ObterQrCodeAsync(Guid instanciaId, CancellationToken ct = default);
    Task<string> VerificarStatusAsync(Guid instanciaId, CancellationToken ct = default);
    Task DesconectarAsync(Guid instanciaId, CancellationToken ct = default);
    Task RemoverInstanciaAsync(Guid instanciaId, CancellationToken ct = default);

    // Mensagens
    Task<string> EnviarTextoAsync(Guid instanciaId, string numero, string texto, CancellationToken ct = default);
    Task<string> EnviarMidiaAsync(Guid instanciaId, string numero, string mediaUrl, string tipo, string? caption, CancellationToken ct = default);
    Task<string> EnviarAudioAsync(Guid instanciaId, string numero, string audioUrl, CancellationToken ct = default);

    // Webhook
    Task ProcessarWebhookAsync(string nomeInstancia, string evento, JsonElement data, CancellationToken ct = default);

    // Contatos
    Task<WhatsAppContato?> VincularContatoAsync(string numero, Guid pessoaId, Guid companyId, CancellationToken ct = default);
    Task<List<WhatsAppContato>> ListarContatosAsync(Guid companyId, CancellationToken ct = default);
}
```

### 6.2 WhatsAppWebhookController

```csharp
[ApiController]
[Route("api/whatsapp")]
public class WhatsAppWebhookController : ControllerBase
{
    private readonly IWhatsAppService _whatsAppService;

    // AllowAnonymous porque Evolution API chama sem JWT
    // Validação por API Key no header
    [HttpPost("webhook/{instancia}")]
    [AllowAnonymous]
    public async Task<IActionResult> Webhook(
        string instancia,
        [FromBody] JsonElement payload,
        [FromHeader(Name = "apikey")] string? apiKey)
    {
        // 1. Validar API Key (mesma configurada no docker-compose)
        if (apiKey != _config.EvolutionApiKey)
            return Unauthorized();

        // 2. Extrair evento do payload
        var evento = payload.GetProperty("event").GetString();

        // 3. Processar
        await _whatsAppService.ProcessarWebhookAsync(instancia, evento, payload);

        return Ok();
    }
}
```

### 6.3 WhatsAppConfigController (Admin, tenant-scoped)

```csharp
[ApiController]
[Route("api/whatsapp/config")]
[Authorize]
public class WhatsAppConfigController : ControllerBase
{
    // GET /api/whatsapp/config — status da instância do tenant atual
    [HttpGet]
    public async Task<ActionResult<WhatsAppInstanciaDto>> GetStatus() { }

    // POST /api/whatsapp/config/conectar — criar instância + obter QR Code
    [HttpPost("conectar")]
    public async Task<ActionResult<QrCodeDto>> Conectar() { }

    // POST /api/whatsapp/config/desconectar — logout do WhatsApp
    [HttpPost("desconectar")]
    public async Task<IActionResult> Desconectar() { }

    // GET /api/whatsapp/config/qrcode — obter QR Code atual
    [HttpGet("qrcode")]
    public async Task<ActionResult<QrCodeDto>> GetQrCode() { }

    // GET /api/whatsapp/contatos — listar contatos WhatsApp vinculados
    [HttpGet("contatos")]
    public async Task<ActionResult<List<WhatsAppContatoDto>>> ListarContatos() { }

    // POST /api/whatsapp/contatos/vincular — vincular número a Pessoa do ERP
    [HttpPost("contatos/vincular")]
    public async Task<ActionResult<WhatsAppContatoDto>> VincularContato(VincularContatoRequest request) { }
}
```

### 6.4 Adaptação no ChatService

```csharp
// No método EnviarMensagemAsync — adicionar branch por canal:
public async Task<MensagemDto> EnviarMensagemAsync(Guid conversaId, Guid userId, string texto, Guid? respostaParaId)
{
    var conversa = await GetConversaAsync(conversaId);

    // Criar mensagem no banco (igual ao atual)
    var mensagem = new Mensagem { /* ... */ };
    await _context.SaveChangesAsync();

    // Enviar pelo canal correto
    if (conversa.Canal == "whatsapp")
    {
        // Enviar via Evolution API
        var whatsAppMsgId = await _whatsAppService.EnviarTextoAsync(
            conversa.WhatsAppInstanciaId!.Value,
            conversa.WhatsAppNumero!,
            texto
        );
        mensagem.WhatsAppMessageId = whatsAppMsgId;
        mensagem.WhatsAppStatus = "sent";
        await _context.SaveChangesAsync();
    }

    // Notificar via SignalR (sempre, para atualizar a UI)
    await NotificarParticipantesAsync(conversaId, "ReceiveMessage", mensagem.ToDto());

    return mensagem.ToDto();
}
```

---

## 7. Docker Compose

```yaml
# Adicionar ao docker-compose.yml existente
services:
  # ... serviços existentes (api, db, frontend) ...

  evolution-api:
    image: atendai/evolution-api:latest
    container_name: evolution-api
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      # Autenticação
      - AUTHENTICATION_API_KEY=${EVOLUTION_API_KEY:-chave-secreta-opticalcore}
      - AUTHENTICATION_EXPOSE_IN_FETCH_INSTANCES=true

      # Banco de dados (mesmo PostgreSQL do ERP)
      - DATABASE_ENABLED=true
      - DATABASE_PROVIDER=postgresql
      - DATABASE_CONNECTION_URI=postgresql://${DB_USER}:${DB_PASS}@db:5432/evolution

      # Webhook global → backend OpticalCore
      - WEBHOOK_GLOBAL_URL=http://opticalcore-api:5050/api/whatsapp/webhook
      - WEBHOOK_GLOBAL_ENABLED=true
      - WEBHOOK_GLOBAL_WEBHOOK_BY_EVENTS=false
      - WEBHOOK_EVENTS_APPLICATION_STARTUP=false
      - WEBHOOK_EVENTS_QRCODE_UPDATED=true
      - WEBHOOK_EVENTS_MESSAGES_SET=false
      - WEBHOOK_EVENTS_MESSAGES_UPSERT=true
      - WEBHOOK_EVENTS_MESSAGES_UPDATE=true
      - WEBHOOK_EVENTS_MESSAGES_DELETE=false
      - WEBHOOK_EVENTS_SEND_MESSAGE=true
      - WEBHOOK_EVENTS_CONTACTS_SET=false
      - WEBHOOK_EVENTS_CONTACTS_UPSERT=false
      - WEBHOOK_EVENTS_CONTACTS_UPDATE=true
      - WEBHOOK_EVENTS_PRESENCE_UPDATE=false
      - WEBHOOK_EVENTS_CHATS_SET=false
      - WEBHOOK_EVENTS_CHATS_UPSERT=false
      - WEBHOOK_EVENTS_CHATS_UPDATE=false
      - WEBHOOK_EVENTS_CHATS_DELETE=false
      - WEBHOOK_EVENTS_GROUPS_UPSERT=false
      - WEBHOOK_EVENTS_GROUPS_UPDATE=false
      - WEBHOOK_EVENTS_GROUP_PARTICIPANTS_UPDATE=false
      - WEBHOOK_EVENTS_CONNECTION_UPDATE=true
      - WEBHOOK_EVENTS_CALL=false

      # Storage
      - S3_ENABLED=false
      - STORE_MESSAGES=true
      - STORE_MESSAGE_UP=true
      - STORE_CONTACTS=true
      - STORE_CHATS=true

      # Configurações gerais
      - DEL_INSTANCE=false
      - LOG_LEVEL=WARN
    volumes:
      - evolution_instances:/evolution/instances
    networks:
      - opticalcore-network

volumes:
  evolution_instances:

networks:
  opticalcore-network:
    driver: bridge
```

---

## 8. Frontend — Adaptações

### 8.1 Tipos

```typescript
// whatsapp.types.ts
export interface WhatsAppInstanciaDto {
  id: string;
  companyId: string;
  nomeInstancia: string;
  numeroWhatsApp: string | null;
  status: 'connected' | 'disconnected' | 'qrcode';
  qrCodeBase64: string | null;
  criadoEm: string;
  conectadoEm: string | null;
}

export interface WhatsAppContatoDto {
  id: string;
  numeroWhatsApp: string;
  nomePush: string | null;
  fotoUrl: string | null;
  pessoaId: string | null;
  pessoaNome: string | null;
}
```

### 8.2 Chat Page — Indicador de Canal

```tsx
// No sidebar de conversas — ícone diferenciador
<ListItemIcon>
  {conversa.canal === 'whatsapp' ? (
    <WhatsAppIcon sx={{ color: '#25D366' }} />  // ícone verde WhatsApp
  ) : (
    <ChatIcon color="primary" />                 // ícone padrão
  )}
</ListItemIcon>

// No header da conversa ativa
{conversaAtiva?.canal === 'whatsapp' && (
  <Chip
    icon={<WhatsAppIcon />}
    label={formatPhoneNumber(conversaAtiva.whatsAppNumero)}
    size="small"
    sx={{ bgcolor: alpha('#25D366', 0.1), color: '#25D366' }}
  />
)}
```

### 8.3 Tela de Configuração WhatsApp (Admin)

```
┌──────────────────────────────────────────────┐
│  ⚙️ Configuração WhatsApp                    │
│                                              │
│  Status: 🟢 Conectado                        │
│  Número: +55 (11) 99999-9999                 │
│  Conectado desde: 17/03/2026 14:30           │
│                                              │
│  [Desconectar]                               │
│                                              │
│  ── ou, se desconectado: ──                  │
│                                              │
│  Status: 🔴 Desconectado                     │
│                                              │
│  [Conectar WhatsApp]                         │
│                                              │
│  ┌──────────────┐                            │
│  │  ██████████  │  Escaneie o QR Code        │
│  │  ██      ██  │  com seu WhatsApp          │
│  │  ██  ██  ██  │                            │
│  │  ██      ██  │  1. Abra o WhatsApp        │
│  │  ██████████  │  2. Toque em ⋮ > Aparelhos │
│  └──────────────┘  3. Escaneie o código      │
│                                              │
│  ─── Contatos Vinculados ───                 │
│                                              │
│  📱 (11) 98888-7777 → Ótica Visão Clara     │
│  📱 (21) 97777-6666 → Ótica Olhar Certo     │
│  📱 (31) 96666-5555 → (não vinculado)       │
│                                              │
└──────────────────────────────────────────────┘
```

### 8.4 Iniciar Conversa WhatsApp

```
┌──────────────────────────────────────────────┐
│  Nova Conversa WhatsApp                       │
│                                              │
│  🔍 Buscar por nome ou número...             │
│                                              │
│  Contatos vinculados:                        │
│  📱 Ótica Visão Clara — (11) 98888-7777     │
│  📱 Ótica Olhar Certo — (21) 97777-6666     │
│                                              │
│  Ou digite um número:                        │
│  [+55] [(__)_____-____]                      │
│                                              │
│  [Cancelar]  [Iniciar Conversa]              │
└──────────────────────────────────────────────┘
```

---

## 9. Fases de Implementação

### Fase 0 — Infraestrutura (1 dia)
- [ ] Adicionar Evolution API ao `docker-compose.yml`
- [ ] Subir container, testar conexão com QR Code manualmente
- [ ] Testar envio/recebimento via Postman/curl
- [ ] Configurar banco PostgreSQL separado para Evolution API

### Fase 1 — Backend Base (3-4 dias)
- [ ] Entidades: `WhatsAppInstancia`, `WhatsAppContato`
- [ ] Migration: `AddWhatsAppIntegration` (Application, schema public)
- [ ] `IWhatsAppService` + `WhatsAppService` (comunicação com Evolution API via HttpClient)
- [ ] `WhatsAppWebhookController` (receber webhooks, validar API Key)
- [ ] `WhatsAppConfigController` (admin: criar instância, QR Code, status)
- [ ] Configuração em `appsettings.json`: URL da Evolution API + API Key

### Fase 2 — Integração com Chat (2-3 dias)
- [ ] Adicionar campos `Canal`, `WhatsAppNumero`, `WhatsAppInstanciaId` em `Conversa`
- [ ] Adicionar campos `WhatsAppMessageId`, `WhatsAppStatus` em `Mensagem`
- [ ] Migration: `AddWhatsAppChatFields` (Application)
- [ ] Adaptar `ChatService.EnviarMensagemAsync()` — branch por canal
- [ ] Webhook `MESSAGES_UPSERT` → criar Conversa (se não existe) + Mensagem + SignalR
- [ ] Webhook `MESSAGES_UPDATE` → atualizar status (enviada, entregue, lida)
- [ ] Webhook `CONNECTION_UPDATE` → atualizar `WhatsAppInstancia.Status`

### Fase 3 — Frontend Chat (2-3 dias)
- [ ] Ícone de canal (WhatsApp verde vs Chat azul) no sidebar de conversas
- [ ] Chip com número WhatsApp no header da conversa
- [ ] Status de entrega WhatsApp (✓ enviada, ✓✓ entregue, ✓✓ azul = lida)
- [ ] Dialog "Nova Conversa WhatsApp" (buscar contato ou digitar número)
- [ ] Filtro por canal no sidebar (tabs: Todos / Interno / WhatsApp)

### Fase 4 — Mídia (2 dias)
- [ ] Enviar imagens via Evolution API (`/message/sendMedia`)
- [ ] Enviar documentos (PDF, etc.)
- [ ] Enviar áudio (mensagem de voz)
- [ ] Receber mídia do webhook e salvar em `/wwwroot/uploads/chat/`
- [ ] Exibir mídia recebida na UI (reutilizar componentes do Chat existente)

### Fase 5 — Configuração Multi-Tenant (1-2 dias)
- [ ] Página de configuração WhatsApp (Admin > Configurações > WhatsApp)
- [ ] Exibição de QR Code em tempo real (polling ou SignalR)
- [ ] Gerenciamento de contatos vinculados (número ↔ Pessoa/Cliente)
- [ ] Permissões: `Permissions.WhatsApp.Configurar`, `Permissions.WhatsApp.Enviar`

### Fase 6 — Polimento (1-2 dias)
- [ ] Notificações de nova mensagem WhatsApp (sino, som, browser notification)
- [ ] Indicador de "digitando..." do WhatsApp (se Evolution API suportar presence)
- [ ] Reconexão automática com alerta visual se instância desconectar
- [ ] Testes de carga e estabilidade

**Total estimado: 11-16 dias de desenvolvimento.**

---

## 10. Configuração `appsettings.json`

```json
{
  "WhatsApp": {
    "EvolutionApiUrl": "http://localhost:8080",
    "EvolutionApiKey": "chave-secreta-opticalcore",
    "WebhookValidationEnabled": true
  }
}
```

---

## 11. Referências

- **Evolution API:** https://github.com/EvolutionAPI/evolution-api
- **Evolution API Docs:** https://doc.evolution-api.com/
- **Baileys (engine):** https://github.com/WhiskeySockets/Baileys
- **WhatsApp Business API (oficial, referência):** https://developers.facebook.com/docs/whatsapp/cloud-api
- **Chat Module (OpticalCore):** Módulo 100% implementado, 6 fases, ver `memory/project_chat_module.md`

---

## 12. Decisões Pendentes

- [ ] Usar banco PostgreSQL separado para Evolution API ou mesmo banco do ERP?
- [ ] Permitir que múltiplos usuários do ERP respondam na mesma conversa WhatsApp? (atribuição de atendente)
- [ ] Implementar fila de atendimento (round-robin) para distribuir mensagens WhatsApp?
- [ ] Integrar com módulo de Vendas (pedido via WhatsApp → OrdemVenda)?
- [ ] Implementar chatbot automático (respostas prontas para perguntas frequentes)?
- [ ] Limitar horário de atendimento WhatsApp por tenant?
