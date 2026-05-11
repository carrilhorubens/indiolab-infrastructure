# Broadcast — Disparo de Mensagem em Massa

> Estudo de viabilidade e plano de implementação. Criado em 2026-03-17. Atualizado em 2026-03-18.
> **Canal de envio:** Chat interno (SignalR) + **WhatsApp via Evolution API** (open-source, self-hosted).

---

## 1. Objetivo

Permitir que um usuário do ERP crie uma mensagem e a envie simultaneamente para **múltiplos contatos selecionados**, via **Chat interno** e/ou **WhatsApp**. Cada destinatário recebe a mensagem em uma **conversa 1:1 individual** (como a Lista de Transmissão do WhatsApp), preservando a privacidade — os destinatários NÃO veem quem mais recebeu.

### Caso de uso principal
O laboratório óptico precisa comunicar algo a várias óticas clientes:
- "Promoção de lentes Essilor esta semana — 15% off"
- "Manutenção programada dia 20/03 — pedidos com atraso de 24h"
- "Novo catálogo de armações disponível no portal"
- "Atualização de tabela de preços a partir de 01/04"

### Canais de envio

| Canal | Destinatário | Como funciona |
|-------|-------------|---------------|
| **Chat interno** | Usuários do ERP (funcionários de óticas com login) | Mensagem via SignalR, aparece no Chat do ERP |
| **WhatsApp** | Qualquer número de celular (óticas sem login no ERP) | Mensagem via Evolution API → WhatsApp da ótica |
| **Ambos** | Broadcast misto na mesma transmissão | Cada destinatário recebe no canal configurado |

---

## 2. Abordagem Escolhida: Lista de Transmissão (1:1 individual)

### Opções avaliadas

| Abordagem | Como funciona | Prós | Contras |
|-----------|---------------|------|---------|
| **A) Grupo** | Cria um grupo com todos os destinatários | Simples de implementar (já existe) | Todos veem uns aos outros, destinatários podem responder no grupo, não adequado para broadcast |
| **B) Lista de Transmissão (1:1)** | Envia a mesma mensagem em conversas 1:1 individuais | Privacidade total, cada ótica responde individualmente, padrão WhatsApp | Mais mensagens no banco, precisa criar/buscar N conversas |
| **C) Canal (read-only)** | Conversa especial onde só admins postam | Um único registro, eficiente | Sem interação, não adequado para comunicação B2B |

**Decisão: Opção B (Lista de Transmissão 1:1)** — é o padrão que o WhatsApp popularizou e que faz mais sentido para B2B. Cada ótica pode responder diretamente ao laboratório sem expor os outros destinatários.

### Integração WhatsApp via Evolution API

A Evolution API (open-source, self-hosted via Docker) é o motor de envio para o canal WhatsApp. Detalhes completos da infraestrutura em [`INTEGRACAO-WHATSAPP.md`](./INTEGRACAO-WHATSAPP.md).

| Aspecto | Detalhe |
|---------|---------|
| **Tecnologia** | Evolution API (Node.js + Baileys) — Docker container |
| **Custo** | Gratuito (self-hosted) |
| **Janela 24h** | Não tem — mensagem livre a qualquer momento |
| **Templates** | Não precisa — diferente da API oficial da Meta |
| **Multi-tenant** | 1 instância Evolution API por número WhatsApp por tenant |
| **Endpoint de envio** | `POST /message/sendText/{instancia}` |
| **Webhook de status** | `MESSAGES_UPDATE` → status enviado/entregue/lido |

---

## 3. Análise da Arquitetura Atual

### O que já existe e pode ser reutilizado

| Componente | Status | Reutilização |
|-----------|--------|--------------|
| `IniciarConversaAsync(userId, destinoId)` | Existente | Criar/buscar conversa 1:1 para destinatários internos |
| `EnviarMensagemAsync(conversaId, remetenteId, texto)` | Existente | Enviar mensagem em cada conversa interna |
| `SendToParticipants(conversaId, "ReceiveMessage", msg)` | Existente | Notificar via SignalR (canal interno) |
| `GetTotalNaoLidasAsync()` | Existente | Badge de não lidas já funciona |
| `ConversaParticipante.NaoLidas++` | Existente | Contador de não lidas por conversa |
| Auto-unarchive em nova mensagem | Existente | Destinatários que arquivaram a conversa são desarquivados |
| Notificações (sino, som, browser) | Existente | Destinatários online recebem alerta |
| `chatService.listarContatos()` | Existente | Lista de contatos internos para seleção |

### O que precisa ser criado

| Componente | Descrição |
|-----------|-----------|
| `Transmissao` (entidade) | Registro do broadcast: texto, canal, remetente, data, lista de destinatários |
| `TransmissaoDestinatario` (entidade) | Vínculo N:N: transmissão ↔ destinatário + canal + status de envio |
| `ITransmissaoService` / `TransmissaoService` | Orquestrar o envio em massa (interno + WhatsApp) |
| `TransmissaoController` | Endpoints REST |
| `ChatHub.SendBroadcast()` | Método SignalR para disparo |
| `TransmissaoListPage.tsx` | Lista de transmissões enviadas |
| `NovaTransmissaoDialog.tsx` | UI para criar e enviar broadcast (wizard 4 etapas) |
| `TransmissaoDetailDialog.tsx` | Detalhes + status de entrega por destinatário |
| **WhatsApp (da `INTEGRACAO-WHATSAPP.md`):** | |
| `WhatsAppInstancia` (entidade) | Conexão WhatsApp por tenant (QR Code) |
| `WhatsAppContato` (entidade) | Vínculo número WhatsApp ↔ Pessoa/Cliente |
| `IWhatsAppService` / `WhatsAppService` | Comunicação com Evolution API via HttpClient |
| `WhatsAppWebhookController` | Receber webhooks da Evolution API (status de mensagem) |

---

## 4. Modelo de Dados

### 4.1 Novas Entidades — Broadcast

```csharp
// Transmissao — registro de cada broadcast enviado (schema public)
public class Transmissao
{
    public Guid Id { get; set; }
    public Guid RemetenteId { get; set; }           // Quem enviou
    public string Texto { get; set; }                // Texto da mensagem
    public string? Assunto { get; set; }             // Assunto/título (opcional, para organização)
    public DateTime CriadoEm { get; set; }
    public DateTime? EnviadoEm { get; set; }         // Quando o envio iniciou
    public DateTime? ConcluidoEm { get; set; }       // Quando todos foram processados
    public string Status { get; set; } = "rascunho"; // "rascunho" | "enviando" | "concluido" | "erro_parcial"
    public int TotalDestinatarios { get; set; }
    public int TotalEnviados { get; set; }
    public int TotalFalhas { get; set; }

    // Anexo (opcional)
    public string? AnexoUrl { get; set; }
    public string? AnexoNome { get; set; }
    public string? AnexoTipo { get; set; }
    public long? AnexoTamanho { get; set; }

    // WhatsApp — instância utilizada para envio (se houver destinatários WhatsApp)
    public Guid? WhatsAppInstanciaId { get; set; }

    public ICollection<TransmissaoDestinatario> Destinatarios { get; set; }

    public static Transmissao Create(Guid remetenteId, string texto, string? assunto = null)
        => new()
        {
            Id = Guid.NewGuid(),
            RemetenteId = remetenteId,
            Texto = texto,
            Assunto = assunto,
            CriadoEm = DateTime.UtcNow
        };
}

// TransmissaoDestinatario — cada destinatário de um broadcast
public class TransmissaoDestinatario
{
    public Guid Id { get; set; }
    public Guid TransmissaoId { get; set; }          // FK → Transmissao
    public string Canal { get; set; } = "interno";   // "interno" | "whatsapp"

    // Canal interno
    public Guid? DestinatarioId { get; set; }        // userId do destinatário (se interno)
    public Guid? ConversaId { get; set; }            // FK → Conversa (1:1 onde a msg foi enviada)
    public Guid? MensagemId { get; set; }            // FK → Mensagem (a msg enviada no chat)

    // Canal WhatsApp
    public string? WhatsAppNumero { get; set; }      // "5511988887777" (se WhatsApp)
    public string? WhatsAppNomeContato { get; set; } // Nome do contato WhatsApp
    public string? WhatsAppMessageId { get; set; }   // ID da msg retornado pela Evolution API

    // Status unificado
    public string Status { get; set; } = "pendente"; // "pendente" | "enviado" | "entregue" | "lido" | "falha"
    public DateTime? EnviadoEm { get; set; }
    public DateTime? EntregueEm { get; set; }
    public DateTime? LidoEm { get; set; }
    public string? Erro { get; set; }                // Mensagem de erro (se falha)

    public Transmissao Transmissao { get; set; }
}
```

### 4.2 Entidades WhatsApp (da `INTEGRACAO-WHATSAPP.md`)

```csharp
// WhatsAppInstancia — 1 por tenant (schema public)
public class WhatsAppInstancia
{
    public Guid Id { get; set; }
    public Guid CompanyId { get; set; }
    public string NomeInstancia { get; set; }       // "lab-{companyId}"
    public string? NumeroWhatsApp { get; set; }     // "5511999999999"
    public string Status { get; set; } = "disconnected"; // "connected" | "disconnected" | "qrcode"
    public string? QrCodeBase64 { get; set; }
    public DateTime CriadoEm { get; set; }
    public DateTime? ConectadoEm { get; set; }
    public DateTime? DesconectadoEm { get; set; }
}

// WhatsAppContato — vínculo número ↔ Pessoa/Cliente do ERP (schema public)
public class WhatsAppContato
{
    public Guid Id { get; set; }
    public string NumeroWhatsApp { get; set; }      // "5511988887777"
    public string? NomePush { get; set; }
    public string? FotoUrl { get; set; }
    public Guid? PessoaId { get; set; }             // FK opcional → Pessoa
    public Guid CompanyId { get; set; }
    public DateTime CriadoEm { get; set; }
    public DateTime? AtualizadoEm { get; set; }
}
```

### 4.3 SQL (schema public)

```sql
-- Broadcast
CREATE TABLE IF NOT EXISTS chat_transmissoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    remetente_id UUID NOT NULL,
    texto TEXT NOT NULL,
    assunto VARCHAR(200),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    enviado_em TIMESTAMPTZ,
    concluido_em TIMESTAMPTZ,
    status VARCHAR(20) NOT NULL DEFAULT 'rascunho',
    total_destinatarios INT NOT NULL DEFAULT 0,
    total_enviados INT NOT NULL DEFAULT 0,
    total_falhas INT NOT NULL DEFAULT 0,
    anexo_url VARCHAR(500),
    anexo_nome VARCHAR(200),
    anexo_tipo VARCHAR(100),
    anexo_tamanho BIGINT,
    whatsapp_instancia_id UUID REFERENCES whatsapp_instancias(id)
);

CREATE TABLE IF NOT EXISTS chat_transmissao_destinatarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transmissao_id UUID NOT NULL REFERENCES chat_transmissoes(id) ON DELETE CASCADE,
    canal VARCHAR(20) NOT NULL DEFAULT 'interno',
    -- Canal interno
    destinatario_id UUID,
    conversa_id UUID REFERENCES chat_conversas(id),
    mensagem_id UUID REFERENCES chat_mensagens(id),
    -- Canal WhatsApp
    whatsapp_numero VARCHAR(20),
    whatsapp_nome_contato VARCHAR(200),
    whatsapp_message_id VARCHAR(100),
    -- Status unificado
    status VARCHAR(20) NOT NULL DEFAULT 'pendente',
    enviado_em TIMESTAMPTZ,
    entregue_em TIMESTAMPTZ,
    lido_em TIMESTAMPTZ,
    erro TEXT
);

CREATE INDEX idx_transmissoes_remetente ON chat_transmissoes(remetente_id);
CREATE INDEX idx_transmissoes_status ON chat_transmissoes(status);
CREATE INDEX idx_transmissao_dest_transmissao ON chat_transmissao_destinatarios(transmissao_id);
CREATE INDEX idx_transmissao_dest_canal ON chat_transmissao_destinatarios(canal);
CREATE INDEX idx_transmissao_dest_whatsapp_msg ON chat_transmissao_destinatarios(whatsapp_message_id)
    WHERE whatsapp_message_id IS NOT NULL;

-- WhatsApp (da INTEGRACAO-WHATSAPP.md)
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

CREATE TABLE IF NOT EXISTS whatsapp_contatos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero_whatsapp VARCHAR(20) NOT NULL,
    nome_push VARCHAR(200),
    foto_url VARCHAR(500),
    pessoa_id UUID,
    company_id UUID NOT NULL REFERENCES companies(id),
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    atualizado_em TIMESTAMPTZ,
    UNIQUE(numero_whatsapp, company_id)
);

-- Campo extra na Mensagem existente (para identificar broadcast no chat)
ALTER TABLE chat_mensagens ADD COLUMN IF NOT EXISTS transmissao_id UUID REFERENCES chat_transmissoes(id);
```

**Campo `TransmissaoId` na `Mensagem`:** Para que o remetente saiba, ao ver a conversa 1:1 interna, que aquela mensagem foi enviada via broadcast (indicador visual: "Enviada para 45 contatos").

---

## 5. Backend — Implementação

### 5.1 Interface do Service

```csharp
public interface ITransmissaoService
{
    // CRUD
    Task<TransmissaoDto> CriarAsync(Guid remetenteId, CriarTransmissaoRequest request,
        CancellationToken ct = default);
    Task<TransmissaoDto> BuscarPorIdAsync(Guid transmissaoId, CancellationToken ct = default);
    Task<PagedResult<TransmissaoDto>> ListarAsync(Guid remetenteId, int page, int pageSize,
        string? search = null, CancellationToken ct = default);
    Task ExcluirAsync(Guid transmissaoId, Guid remetenteId, CancellationToken ct = default);

    // Envio
    Task<TransmissaoDto> EnviarAsync(Guid transmissaoId, Guid remetenteId,
        CancellationToken ct = default);

    // Reenvio de falhas
    Task<TransmissaoDto> ReenviarFalhasAsync(Guid transmissaoId, Guid remetenteId,
        CancellationToken ct = default);

    // Relatório
    Task<TransmissaoDetalheDto> ObterDetalheAsync(Guid transmissaoId, CancellationToken ct = default);

    // Webhook WhatsApp — atualizar status de mensagem
    Task AtualizarStatusWhatsAppAsync(string whatsAppMessageId, string novoStatus,
        CancellationToken ct = default);
}
```

### 5.2 Request DTO (suporta ambos os canais)

```csharp
public record CriarTransmissaoRequest(
    string Texto,
    string? Assunto,
    // Destinatários internos (userId)
    IEnumerable<Guid>? DestinatarioIds,
    // Destinatários WhatsApp (número + nome opcional)
    IEnumerable<WhatsAppDestinatarioRequest>? WhatsAppDestinatarios
);

public record WhatsAppDestinatarioRequest(
    string Numero,      // "5511988887777"
    string? Nome        // "Ótica Visão Clara" (opcional, para exibição)
);
```

### 5.3 Lógica de Envio (TransmissaoService)

```csharp
public async Task<TransmissaoDto> EnviarAsync(Guid transmissaoId, Guid remetenteId, CancellationToken ct)
{
    var transmissao = await _context.ChatTransmissoes
        .Include(t => t.Destinatarios)
        .FirstOrDefaultAsync(t => t.Id == transmissaoId && t.RemetenteId == remetenteId, ct)
        ?? throw new NotFoundException("Transmissão não encontrada");

    if (transmissao.Status != "rascunho")
        throw new BusinessException("Transmissão já foi enviada");

    transmissao.Status = "enviando";
    transmissao.EnviadoEm = DateTime.UtcNow;
    transmissao.TotalDestinatarios = transmissao.Destinatarios.Count;
    await _context.SaveChangesAsync(ct);

    var enviados = 0;
    var falhas = 0;
    var semaphore = new SemaphoreSlim(10); // máximo 10 simultâneos

    var tasks = transmissao.Destinatarios.Select(async dest =>
    {
        await semaphore.WaitAsync(ct);
        try
        {
            switch (dest.Canal)
            {
                case "interno":
                    await EnviarInternoAsync(transmissao, dest, remetenteId, ct);
                    break;

                case "whatsapp":
                    await EnviarWhatsAppAsync(transmissao, dest, ct);
                    break;
            }

            dest.Status = "enviado";
            dest.EnviadoEm = DateTime.UtcNow;
            Interlocked.Increment(ref enviados);
        }
        catch (Exception ex)
        {
            dest.Status = "falha";
            dest.Erro = ex.Message;
            Interlocked.Increment(ref falhas);
        }
        finally { semaphore.Release(); }
    });

    await Task.WhenAll(tasks);

    // Atualizar totais
    transmissao.TotalEnviados = enviados;
    transmissao.TotalFalhas = falhas;
    transmissao.Status = falhas == 0 ? "concluido"
                       : enviados > 0 ? "erro_parcial"
                       : "falha";
    transmissao.ConcluidoEm = DateTime.UtcNow;

    await _context.SaveChangesAsync(ct);
    return transmissao.ToDto();
}

// ── Canal Interno (Chat ERP via SignalR) ──
private async Task EnviarInternoAsync(
    Transmissao transmissao, TransmissaoDestinatario dest,
    Guid remetenteId, CancellationToken ct)
{
    // 1. Criar ou buscar conversa 1:1 existente
    var conversa = await _chatService.IniciarConversaAsync(
        remetenteId, dest.DestinatarioId!.Value, ct);

    // 2. Enviar a mensagem na conversa 1:1
    var mensagem = await _chatService.EnviarMensagemAsync(
        conversa.Id, remetenteId, transmissao.Texto, null, ct);

    // 3. Vincular à transmissão (para indicador "Enviada para X contatos")
    await _context.ChatMensagens
        .Where(m => m.Id == mensagem.Id)
        .ExecuteUpdateAsync(s => s
            .SetProperty(m => m.TransmissaoId, transmissao.Id), ct);

    // 4. Atualizar referências
    dest.ConversaId = conversa.Id;
    dest.MensagemId = mensagem.Id;

    // SignalR já notificou via EnviarMensagemAsync → ChatHub
}

// ── Canal WhatsApp (via Evolution API) ──
private async Task EnviarWhatsAppAsync(
    Transmissao transmissao, TransmissaoDestinatario dest,
    CancellationToken ct)
{
    if (transmissao.WhatsAppInstanciaId == null)
        throw new BusinessException("Instância WhatsApp não configurada");

    // 1. Enviar via Evolution API
    var whatsAppMsgId = await _whatsAppService.EnviarTextoAsync(
        transmissao.WhatsAppInstanciaId.Value,
        dest.WhatsAppNumero!,
        transmissao.Texto,
        ct);

    // 2. Guardar ID da mensagem para rastrear status via webhook
    dest.WhatsAppMessageId = whatsAppMsgId;

    // Status será atualizado para "entregue"/"lido" via webhook MESSAGES_UPDATE
}
```

### 5.4 Webhook WhatsApp — Atualização de Status

Quando a Evolution API recebe confirmação de entrega/leitura do WhatsApp, envia webhook `MESSAGES_UPDATE` para o backend. O `WhatsAppWebhookController` chama `TransmissaoService.AtualizarStatusWhatsAppAsync`:

```csharp
public async Task AtualizarStatusWhatsAppAsync(
    string whatsAppMessageId, string novoStatus, CancellationToken ct)
{
    var dest = await _context.ChatTransmissaoDestinatarios
        .FirstOrDefaultAsync(d => d.WhatsAppMessageId == whatsAppMessageId, ct);

    if (dest == null) return; // mensagem não é de broadcast

    switch (novoStatus)
    {
        case "delivered":
            if (dest.Status is "enviado" or "pendente")
            {
                dest.Status = "entregue";
                dest.EntregueEm = DateTime.UtcNow;
            }
            break;

        case "read":
            dest.Status = "lido";
            dest.LidoEm = DateTime.UtcNow;
            if (dest.EntregueEm == null) dest.EntregueEm = DateTime.UtcNow;
            break;

        case "failed":
            dest.Status = "falha";
            dest.Erro = "Falha no envio WhatsApp";
            break;
    }

    await _context.SaveChangesAsync(ct);
}
```

### 5.5 Controller

```csharp
[ApiController]
[Route("api/chat/transmissoes")]
[Authorize]
public class TransmissaoController : ControllerBase
{
    // GET /api/chat/transmissoes — listar transmissões do usuário
    [HttpGet]
    public async Task<ActionResult<PagedResult<TransmissaoDto>>> Listar(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 10, [FromQuery] string? search = null)
    {
        var userId = GetUserId();
        var result = await _transmissaoService.ListarAsync(userId, page, pageSize, search);
        return Ok(result);
    }

    // POST /api/chat/transmissoes — criar rascunho
    [HttpPost]
    public async Task<ActionResult<TransmissaoDto>> Criar([FromBody] CriarTransmissaoRequest request)
    {
        var userId = GetUserId();
        var result = await _transmissaoService.CriarAsync(userId, request);
        return Created($"/api/chat/transmissoes/{result.Id}", result);
    }

    // POST /api/chat/transmissoes/{id}/enviar — disparar o envio
    [HttpPost("{id}/enviar")]
    public async Task<ActionResult<TransmissaoDto>> Enviar(Guid id)
    {
        var userId = GetUserId();
        var result = await _transmissaoService.EnviarAsync(id, userId);
        return Ok(result);
    }

    // POST /api/chat/transmissoes/{id}/reenviar-falhas — reenviar só as que falharam
    [HttpPost("{id}/reenviar-falhas")]
    public async Task<ActionResult<TransmissaoDto>> ReenviarFalhas(Guid id)
    {
        var userId = GetUserId();
        var result = await _transmissaoService.ReenviarFalhasAsync(id, userId);
        return Ok(result);
    }

    // GET /api/chat/transmissoes/{id} — detalhes com status por destinatário
    [HttpGet("{id}")]
    public async Task<ActionResult<TransmissaoDetalheDto>> Detalhe(Guid id)
    {
        var result = await _transmissaoService.ObterDetalheAsync(id);
        return Ok(result);
    }

    // DELETE /api/chat/transmissoes/{id} — excluir rascunho (só se não enviado)
    [HttpDelete("{id}")]
    public async Task<IActionResult> Excluir(Guid id)
    {
        var userId = GetUserId();
        await _transmissaoService.ExcluirAsync(id, userId);
        return NoContent();
    }
}
```

### 5.6 Permissões

```csharp
// Permissions.cs
public static class Chat
{
    public const string Broadcast = "Permissions.Chat.Broadcast";
}
```

Apenas usuários com permissão `Chat.Broadcast` podem criar e enviar transmissões.

---

## 6. Fluxo de Envio por Canal

### 6.1 Diagrama

```
TransmissaoService.EnviarAsync()
    │
    ├─── dest.Canal == "interno"
    │       │
    │       ├─ ChatService.IniciarConversaAsync(remetente, destinatario)
    │       │    → Cria ou busca conversa 1:1 existente
    │       │
    │       ├─ ChatService.EnviarMensagemAsync(conversa, remetente, texto)
    │       │    → Cria Mensagem no banco
    │       │    → Incrementa NaoLidas do destinatário
    │       │    → Auto-unarchive se necessário
    │       │
    │       └─ ChatHub.SendToParticipants("ReceiveMessage", msg)
    │            → SignalR notifica destinatário online em tempo real
    │            → Notificação (sino, som, browser) se não silenciado
    │
    └─── dest.Canal == "whatsapp"
            │
            ├─ WhatsAppService.EnviarTextoAsync(instancia, numero, texto)
            │    → HTTP POST → Evolution API /message/sendText/{instancia}
            │    → Retorna whatsAppMessageId
            │
            └─ (assíncrono) Evolution API → WhatsApp Servers → celular da ótica
                 │
                 └─ Webhook MESSAGES_UPDATE → WhatsAppWebhookController
                      → TransmissaoService.AtualizarStatusWhatsAppAsync()
                      → dest.Status = "entregue" / "lido"
```

### 6.2 O que cada destinatário vê

**Destinatário interno (Chat ERP):**
```
┌──────────────────────────────────────────────────┐
│  Laboratório OpticalCore                   14:30 │
│  Olá! Promoção Essilor 15% off...                │
│                                                  │
│  (mensagem normal, NÃO sabe que foi broadcast)   │
└──────────────────────────────────────────────────┘
```

**Destinatário WhatsApp (celular):**
```
┌──────────────────────────────────────────────────┐
│  +55 11 99999-9999                         14:30 │
│  Olá! Promoção Essilor 15% off...                │
│                                                  │
│  (mensagem WhatsApp normal, do número do lab)    │
└──────────────────────────────────────────────────┘
```

**Remetente vê no Chat do ERP (conversa interna 1:1):**
```
┌──────────────────────────────────────────────────┐
│  Você                                     14:30  │
│  Olá! Promoção Essilor 15% off...                │
│  📢 Enviada para 45 contatos                     │ ← indicador (só remetente vê)
└──────────────────────────────────────────────────┘
```

### 6.3 Quando o destinatário responde

**Canal interno:** A resposta aparece na conversa 1:1 normalmente (SignalR).

**Canal WhatsApp:** A resposta chega via webhook `MESSAGES_UPSERT` da Evolution API → `WhatsAppService.ProcessarMensagemAsync()` → cria Conversa WhatsApp no Chat do ERP → SignalR notifica o remetente. (Detalhes em [`INTEGRACAO-WHATSAPP.md`](./INTEGRACAO-WHATSAPP.md) seção 4.2.)

---

## 7. Frontend — Implementação

### 7.1 Types

```typescript
// transmissao.types.ts
export type CanalTransmissao = 'interno' | 'whatsapp';
export type StatusTransmissao = 'rascunho' | 'enviando' | 'concluido' | 'erro_parcial' | 'falha';
export type StatusDestinatario = 'pendente' | 'enviado' | 'entregue' | 'lido' | 'falha';

export interface TransmissaoDto {
  id: string;
  remetenteId: string;
  remetenteNome: string;
  texto: string;
  assunto: string | null;
  criadoEm: string;
  enviadoEm: string | null;
  concluidoEm: string | null;
  status: StatusTransmissao;
  totalDestinatarios: number;
  totalEnviados: number;
  totalFalhas: number;
  totalInternos: number;
  totalWhatsApp: number;
  anexoUrl: string | null;
  anexoNome: string | null;
}

export interface TransmissaoDetalheDto extends TransmissaoDto {
  destinatarios: TransmissaoDestinatarioDto[];
}

export interface TransmissaoDestinatarioDto {
  id: string;
  canal: CanalTransmissao;
  // Interno
  destinatarioId: string | null;
  destinatarioNome: string | null;
  // WhatsApp
  whatsAppNumero: string | null;
  whatsAppNomeContato: string | null;
  // Status
  status: StatusDestinatario;
  enviadoEm: string | null;
  entregueEm: string | null;
  lidoEm: string | null;
  erro: string | null;
}

// Request
export interface CriarTransmissaoRequest {
  texto: string;
  assunto?: string;
  destinatarioIds?: string[];        // internos
  whatsAppDestinatarios?: {          // WhatsApp
    numero: string;
    nome?: string;
  }[];
}
```

### 7.2 Service

```typescript
// transmissaoService.ts
export const transmissaoService = {
  async listar(page = 1, pageSize = 10, search?: string) {
    const params = { page, pageSize, ...(search && { search }) };
    const response = await api.get<PagedResult<TransmissaoDto>>('/chat/transmissoes', { params });
    return response.data;
  },

  async criar(request: CriarTransmissaoRequest) {
    const response = await api.post<TransmissaoDto>('/chat/transmissoes', request);
    return response.data;
  },

  async enviar(id: string) {
    const response = await api.post<TransmissaoDto>(`/chat/transmissoes/${id}/enviar`);
    return response.data;
  },

  async reenviarFalhas(id: string) {
    const response = await api.post<TransmissaoDto>(`/chat/transmissoes/${id}/reenviar-falhas`);
    return response.data;
  },

  async detalhe(id: string) {
    const response = await api.get<TransmissaoDetalheDto>(`/chat/transmissoes/${id}`);
    return response.data;
  },

  async excluir(id: string) {
    await api.delete(`/chat/transmissoes/${id}`);
  },
};
```

### 7.3 Fluxo do Usuário — Wizard 4 Etapas

```
┌──────────────────────────────────────────────────────────────┐
│  📢 Nova Transmissão                                    [X]  │
│                                                              │
│  ── Etapa 1: Mensagem ──                                     │
│                                                              │
│  Assunto (opcional):                                         │
│  ┌──────────────────────────────────────────────────────┐    │
│  │ Promoção Essilor Março                                │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                              │
│  Mensagem: *                                                 │
│  ┌──────────────────────────────────────────────────────┐    │
│  │ Olá! Temos uma promoção especial de lentes Essilor   │    │
│  │ este mês. Desconto de 15% em toda a linha Varilux.   │    │
│  │ Entre em contato para mais detalhes!                  │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                              │
│  📎 Anexar arquivo                                           │
│                                                              │
│                                    [Cancelar] [Próximo →]    │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  📢 Nova Transmissão                                    [X]  │
│                                                              │
│  ── Etapa 2: Destinatários ──                                │
│                                                              │
│  Canais:  [Chat Interno]  [WhatsApp]                         │
│           ─────────────   ──────────                         │
│                                                              │
│  🔍 Buscar contato...                                        │
│                                                              │
│  [Selecionar Todos] [Limpar Seleção]                         │
│                                                              │
│  ── Quando aba "Chat Interno": ──                            │
│  ☑ 💬 Ana Silva — Ótica Visão Clara                         │
│  ☑ 💬 Carlos Souza — Ótica Olhar Certo                      │
│  ☐ 💬 Maria Santos — Ótica Sol Nascente                     │
│                                                              │
│  ── Quando aba "WhatsApp": ──                                │
│  ☑ 📱 (11) 98888-7777 — Ótica Visão Clara                  │
│  ☑ 📱 (21) 97777-6666 — Ótica Olhar Certo                  │
│  ☐ 📱 (31) 96666-5555 — (não vinculado)                    │
│                                                              │
│  ── Ou adicionar número manualmente: ──                      │
│  [+55] [(__)_____-____]  [+ Adicionar]                       │
│                                                              │
│  ✅ 2 internos + 2 WhatsApp = 4 destinatários               │
│                                                              │
│                              [← Voltar] [Próximo →]         │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  📢 Nova Transmissão                                    [X]  │
│                                                              │
│  ── Etapa 3: Confirmação ──                                  │
│                                                              │
│  📝 Mensagem:                                                │
│  "Olá! Temos uma promoção especial de lentes Essilor..."     │
│                                                              │
│  👥 Destinatários: 4 contatos                                │
│                                                              │
│  💬 Chat Interno (2):                                        │
│    • Ana Silva — Ótica Visão Clara                           │
│    • Carlos Souza — Ótica Olhar Certo                        │
│                                                              │
│  📱 WhatsApp (2):                                            │
│    • (11) 98888-7777 — Ótica Visão Clara                    │
│    • (21) 97777-6666 — Ótica Olhar Certo                    │
│                                                              │
│  ⚠️ Chat: mensagem enviada como conversa 1:1 individual.    │
│  ⚠️ WhatsApp: mensagem enviada via Evolution API.            │
│     Cada destinatário poderá responder diretamente a você.   │
│                                                              │
│                       [← Voltar] [📢 Enviar Transmissão]    │
└──────────────────────────────────────────────────────────────┘
```

### 7.4 Lista de Transmissões (DataGrid server-side)

```
┌──────────────────────────────────────────────────────────────┐
│  📢 Transmissões                          [+ Nova Transmissão]│
│                                                              │
│  🔍 Buscar...                                                │
│                                                              │
│  ┌── KPIs ──────────────────────────────────────────────┐    │
│  │ 📊 Total: 12 │ ✅ Enviadas: 10 │ 📝 Rascunhos: 2   │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌──────────────────────────────────────────────────────────┐│
│  │ Assunto        │ Canais    │ Dest. │ Enviados │ Data     ││
│  ├──────────────────────────────────────────────────────────┤│
│  │ Promoção Essilor│ 💬📱     │  45   │  45/45   │ 18/03   ││
│  │ Manutenção     │ 💬📱     │  120  │  118/120 │ 15/03   ││
│  │ Catálogo Abril  │ 📱       │   0   │   —      │ 18/03   ││
│  │ Reunião        │ 💬       │  8    │   8/8    │ 10/03   ││
│  └──────────────────────────────────────────────────────────┘│
└──────────────────────────────────────────────────────────────┘
```

### 7.5 Detalhe da Transmissão (clique na linha)

```
┌──────────────────────────────────────────────────────────────┐
│  📢 Promoção Essilor Março                              [X]  │
│                                                              │
│  Status: ✅ Concluída                                        │
│  Enviada em: 18/03/2026 14:30                                │
│  Duração do envio: 12 segundos                               │
│                                                              │
│  📝 Mensagem:                                                │
│  "Olá! Temos uma promoção especial de lentes Essilor..."     │
│                                                              │
│  ── Tabs: [Todos (45)] [💬 Internos (20)] [📱 WhatsApp (25)] ──│
│                                                              │
│  ┌──────────────────────────────────────────────────────┐    │
│  │ Canal│ Nome/Número       │ Status    │ Enviado│ Lido │    │
│  ├──────────────────────────────────────────────────────┤    │
│  │ 💬   │ Ana Silva         │ ✅ Lida    │ 14:30 │ 14:32│    │
│  │ 📱   │ (11) 98888-7777   │ ✓✓ Entregue│ 14:30 │  —  │    │
│  │ 💬   │ Carlos Souza      │ ✓ Enviada │ 14:31 │  —  │    │
│  │ 📱   │ (21) 97777-6666   │ ✅ Lida    │ 14:30 │ 15:10│    │
│  │ 📱   │ (31) 96666-5555   │ ❌ Falha   │  —    │  —  │    │
│  └──────────────────────────────────────────────────────┘    │
│                                                              │
│  📊 Resumo:                                                  │
│  💬 Interno: 18 lidas • 1 entregue • 1 enviada              │
│  📱 WhatsApp: 22 lidas • 2 entregues • 0 enviadas • 1 falha │
│                                                              │
│                      [🔄 Reenviar Falhas]        [Fechar]    │
└──────────────────────────────────────────────────────────────┘
```

---

## 8. Integração com Status de Leitura

### Canal interno (via SignalR events existentes)

```csharp
// No ChatService.MarcarComoLidaAsync — adicionar:
if (mensagem.TransmissaoId.HasValue)
{
    var dest = await _context.ChatTransmissaoDestinatarios
        .FirstOrDefaultAsync(d => d.MensagemId == mensagem.Id, ct);
    if (dest != null)
    {
        dest.Status = "lido";
        dest.LidoEm = DateTime.UtcNow;
        await _context.SaveChangesAsync(ct);
    }
}

// No ChatHub.MarkDelivered — adicionar:
if (mensagem.TransmissaoId.HasValue)
{
    var dest = await _context.ChatTransmissaoDestinatarios
        .FirstOrDefaultAsync(d => d.MensagemId == mensagem.Id, ct);
    if (dest != null && dest.Status == "enviado")
    {
        dest.Status = "entregue";
        dest.EntregueEm = DateTime.UtcNow;
        await _context.SaveChangesAsync(ct);
    }
}
```

### Canal WhatsApp (via webhook Evolution API)

```csharp
// No WhatsAppWebhookController, evento MESSAGES_UPDATE:
case "MESSAGES_UPDATE":
    var messageId = data.GetProperty("key").GetProperty("id").GetString();
    var status = data.GetProperty("update").GetProperty("status").GetString();
    // status: "sent" | "delivered" | "read"

    await _transmissaoService.AtualizarStatusWhatsAppAsync(messageId, status, ct);
    break;
```

---

## 9. Riscos do Broadcast via WhatsApp (Evolution API)

| Risco | Probabilidade | Mitigação |
|-------|--------------|-----------|
| **Ban do número por spam** | Média (broadcast é o maior risco) | Limitar volume: máx 200 destinatários/broadcast, intervalo mínimo entre broadcasts, uso B2B legítimo |
| **Rate limit da Evolution API** | Baixa | `SemaphoreSlim(10)` já controla concorrência. Adicionar delay de 100-500ms entre envios se necessário |
| **Protocolo quebrar** | Média (1-2x/ano) | Manter Docker image atualizada, comunidade BR ativa patcha em 1-3 dias |
| **Perda de sessão** | Baixa | Verificar `WhatsAppInstancia.Status == "connected"` antes de enviar. Alertar no frontend se desconectado |

### Boas práticas para evitar ban

| Prática | Detalhe |
|---------|---------|
| **Número dedicado** | NUNCA usar número pessoal para broadcast |
| **Volume gradual** | Começar com poucos destinatários e ir aumentando semana a semana |
| **Conteúdo relevante** | Apenas comunicações B2B legítimas (não spam de marketing genérico) |
| **Horário comercial** | Enviar apenas em horário comercial (8h-18h) |
| **Opt-out** | Permitir que a ótica peça para sair da lista de transmissão |
| **Intervalo entre broadcasts** | Mínimo 1 hora entre broadcasts para o mesmo destinatário |

---

## 10. Considerações de Performance

| Cenário | Destinatários | Tempo estimado | Estratégia |
|---------|--------------|----------------|-----------|
| Pequeno | 1-30 | < 3 seg | Loop sequencial |
| Médio | 30-200 | 3-20 seg | Paralelo com `SemaphoreSlim(10)` |
| Grande | 200-500 | 20-60 seg | Background job com progress |
| Muito grande | 500+ | > 1 min | Background job + fila + progress bar |

**Para o MVP:** Paralelo controlado com `SemaphoreSlim(10)`. Se o laboratório tiver 200+ óticas, evoluir para background job.

**Nota WhatsApp:** O envio via Evolution API é mais lento que SignalR (~200-500ms por mensagem vs ~10ms). Para 100 destinatários WhatsApp com paralelismo 10: ~5-10 segundos.

### Impacto no banco

Cada broadcast de N destinatários gera:
- 1 registro em `chat_transmissoes`
- N registros em `chat_transmissao_destinatarios`
- Até N registros em `chat_conversas` (apenas internos, se não existirem)
- Até 2N registros em `chat_participantes` (apenas internos)
- Até N registros em `chat_mensagens` (apenas internos)
- 0 registros extras para WhatsApp (mensagem fica na Evolution API)

---

## 11. Fases de Implementação

### Fase 0 — Infraestrutura WhatsApp (1-2 dias)
- [ ] Adicionar Evolution API ao `docker-compose.yml`
- [ ] Subir container, testar conexão com QR Code manualmente
- [ ] Testar envio/recebimento via Postman/curl
- [ ] Entidades: `WhatsAppInstancia`, `WhatsAppContato`
- [ ] Migration: `AddWhatsAppIntegration` (Application)
- [ ] `IWhatsAppService` + `WhatsAppService` (HttpClient → Evolution API)
- [ ] `WhatsAppWebhookController` (receber webhooks, validar API Key)
- [ ] Configuração `appsettings.json`: URL + API Key

### Fase 1 — Backend Broadcast (2-3 dias)
- [ ] Entidades: `Transmissao`, `TransmissaoDestinatario`
- [ ] Migration: `AddChatTransmissao` (Application)
- [ ] Campo `TransmissaoId` na `Mensagem`
- [ ] `ITransmissaoService` + `TransmissaoService` (envio dual: interno + WhatsApp)
- [ ] `TransmissaoController` (CRUD + enviar + reenviar falhas)
- [ ] Envio paralelo com `SemaphoreSlim(10)`
- [ ] Permissão `Chat.Broadcast`
- [ ] Integração com status de leitura (interno + webhook WhatsApp)

### Fase 2 — Frontend Broadcast (2-3 dias)
- [ ] Types: `transmissao.types.ts`
- [ ] Service: `transmissaoService.ts`
- [ ] `NovaTransmissaoDialog.tsx` (wizard 3 etapas: mensagem → destinatários com tabs interno/WhatsApp → confirmação)
- [ ] `TransmissoesListPage.tsx` (DataGrid server-side com KPIs + ícones de canal)
- [ ] `TransmissaoDetailDialog.tsx` (status por destinatário com tabs por canal)
- [ ] Indicador "📢 Enviada para X contatos" na mensagem do chat

### Fase 3 — Frontend WhatsApp Config (1-2 dias)
- [ ] Página de configuração WhatsApp (Admin > Configurações > WhatsApp)
- [ ] Exibição de QR Code em tempo real
- [ ] Gerenciamento de contatos WhatsApp vinculados (número ↔ Pessoa/Cliente)
- [ ] Verificação de conexão antes de permitir broadcast WhatsApp

### Fase 4 — Polimento (1-2 dias)
- [ ] Progress bar durante envio (SignalR event `BroadcastProgress`)
- [ ] Botão "Reenviar Falhas"
- [ ] Validação: verificar instância conectada antes de enviar
- [ ] Rota, sidebar, routeTitle no MainLayout
- [ ] Limites de segurança: máx destinatários, intervalo entre broadcasts

### Fase 5 — Funcionalidades Avançadas (futuro)
- [ ] Templates de mensagem reutilizáveis
- [ ] Agendamento de envio (data/hora futura)
- [ ] Listas de contatos salvas ("Óticas SP", "Óticas Premium")
- [ ] Variáveis personalizadas (`{nome}`, `{empresa}`)
- [ ] Relatório de engajamento (% lidos, taxa de resposta)
- [ ] Envio de mídia (imagem, PDF) via WhatsApp
- [ ] Opt-out automático (ótica responde "SAIR" → remove da lista)

**Total MVP (Fases 0-4): ~7-12 dias de desenvolvimento.**

---

## 12. Decisões Pendentes

- [ ] Broadcast deve aparecer como aba dentro do ChatPage ou como página separada no menu?
- [ ] Limitar quantidade máxima de destinatários por broadcast? (sugestão: 200 WhatsApp, 500 interno)
- [ ] Permitir broadcast com anexo/mídia no MVP ou só texto?
- [ ] O destinatário interno deve ver que a mensagem veio de broadcast ou deve parecer mensagem normal?
- [ ] Implementar "não perturbe" — respeitar `SilenciadoAte` do destinatário no broadcast interno?
- [ ] Quem pode fazer broadcast? Apenas Admin? Ou qualquer usuário com permissão `Chat.Broadcast`?
- [ ] Permitir editar rascunho (mudar texto/destinatários) antes de enviar?
- [ ] Intervalo mínimo entre broadcasts para o mesmo destinatário WhatsApp? (sugestão: 1h)
- [ ] Adicionar delay entre envios WhatsApp para reduzir risco de ban? (sugestão: 200ms)
- [ ] Permitir broadcast misto (interno + WhatsApp) na mesma transmissão ou separar?

---

## 13. Referências

- **Evolution API:** https://github.com/EvolutionAPI/evolution-api
- **Evolution API Docs:** https://doc.evolution-api.com/
- **Integração WhatsApp (OpticalCore):** [`INTEGRACAO-WHATSAPP.md`](./INTEGRACAO-WHATSAPP.md) — arquitetura, Docker, entidades, webhooks
- **Chat Module (OpticalCore):** Módulo 100% implementado, 6 fases
