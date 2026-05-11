# Plano de Implementação — Evolution API v2

**Data:** 2026-03-20 (atualizado — 100% COMPLETO)
**Base:** [EVOLUTION-API-FUNCIONALIDADES.md](./EVOLUTION-API-FUNCIONALIDADES.md)
**Estado atual:** 130/130 endpoints implementados (100%)
**Status:** TODAS AS 6 FASES CONCLUÍDAS

---

## Visão Geral das Fases

| Fase | Nome | Endpoints | Status | Commit |
|------|------|-----------|--------|--------|
| 1 | Experiência de Atendimento | 8 | **CONCLUÍDA** | `a5f5c6e` |
| 2 | Gerenciamento de Chat | 8 | **CONCLUÍDA** | `321bd11` |
| 3 | Perfil e Configurações | 11 | **CONCLUÍDA** | `5862ac1` |
| 4 | Grupos WhatsApp | 15 | **CONCLUÍDA** | `377c0ed` |
| 5 | Mensagens Avançadas e Eventos | 9 (+4 webhook) | **CONCLUÍDA** | `de3fa82` |
| 6 | Integrações IA e Mensageria | 77 | **CONCLUÍDA** | `1d7987e` + `84f90cc` |
| | **Total** | **130** | **100%** | |

> **Refatoração Fase 6:** Commit `84f90cc` — 77 métodos individuais por plataforma (substituiu genéricos).

---

## Fase 1 — Experiência de Atendimento (8 endpoints)

**Objetivo:** Melhorar a qualidade da interação com o cliente no dia a dia do laboratório.
**Impacto:** Alto — atendentes ganham ferramentas essenciais que faltam hoje.

### Funcionalidades

| # | Funcionalidade | Endpoint | Método | Descrição |
|---|----------------|----------|--------|-----------|
| 1.1 | Reagir a mensagens | `/message/sendReaction` | POST | Enviar reação com emoji (👍, ✅, ❤️) a qualquer mensagem |
| 1.2 | Indicador "digitando..." | `/chat/sendPresence` | POST | Mostrar "digitando..." ou "gravando áudio..." para o cliente |
| 1.3 | Marcar como lida | `/chat/markAsRead` | POST | Sincronizar tick azul no WhatsApp real |
| 1.4 | Verificar número | `/chat/checkIsWhatsApp` | POST | Validar se número tem WhatsApp antes de enviar |
| 1.5 | Enviar localização | `/message/sendLocation` | POST | Compartilhar endereço do laboratório (mapa) |
| 1.6 | Enviar contato (vCard) | `/message/sendContact` | POST | Compartilhar cartão de contato de representantes |
| 1.7 | Enviar sticker | `/message/sendSticker` | POST | Enviar figurinhas (recebimento já funciona) |
| 1.8 | Foto de perfil do contato | `/chat/fetchProfilePictureUrl` | POST | Exibir avatar real do contato no chat |

### Detalhamento Técnico

#### 1.1 — Reagir a mensagens (`sendReaction`)
- **Backend:** Novo método `EnviarReacaoAsync(instanciaId, messageId, emoji)` no `WhatsAppService`
- **Frontend:** Menu de contexto (right-click) na mensagem → seletor de emoji rápido (👍 ❤️ 😂 😮 😢 🙏)
- **Payload:** `{ key: { remoteJid, fromMe, id }, reaction: "👍" }`

#### 1.2 — Indicador "digitando..." (`sendPresence`)
- **Backend:** Novo método `EnviarPresencaAsync(instanciaId, numero, tipo)` (`composing` | `recording` | `paused`)
- **Frontend:** Chamar ao começar a digitar, parar após 3s sem teclar
- **Payload:** `{ number: "5544...", presence: "composing" }`

#### 1.3 — Marcar como lida (`markAsRead`)
- **Backend:** Novo método `MarcarComoLidaAsync(instanciaId, messageIds[])`
- **Frontend:** Chamar automaticamente ao abrir conversa WhatsApp (ou ao visualizar mensagens)
- **Payload:** `{ readMessages: [{ remoteJid, fromMe: false, id }] }`

#### 1.4 — Verificar número (`checkIsWhatsApp`)
- **Backend:** Novo método `VerificarWhatsAppAsync(instanciaId, numeros[])` → retorna lista com `exists: true/false`
- **Frontend:** Usar ao vincular contato ou antes de iniciar nova conversa
- **Payload:** `{ numbers: ["5544..."] }`

#### 1.5 — Enviar localização (`sendLocation`)
- **Backend:** Novo método `EnviarLocalizacaoAsync(instanciaId, numero, lat, lng, nome, endereco)`
- **Frontend:** Botão de localização no input do chat → dialog com campos lat/lng/nome ou mapa
- **Payload:** `{ number, name, address, latitude, longitude }`

#### 1.6 — Enviar contato vCard (`sendContact`)
- **Backend:** Novo método `EnviarContatoAsync(instanciaId, numero, nomeContato, telefoneContato)`
- **Frontend:** Botão de contato no input → dialog para selecionar contato do sistema (Pessoa/Funcionário)
- **Payload:** `{ number, contact: [{ fullName, wuid, phoneNumber }] }`

#### 1.7 — Enviar sticker (`sendSticker`)
- **Backend:** Novo método `EnviarStickerAsync(instanciaId, numero, imageBase64)`
- **Frontend:** Opção no seletor de anexos para enviar imagem como sticker
- **Payload:** `{ number, sticker: base64 }` (imagem é convertida para WebP pela Evolution API)

#### 1.8 — Foto de perfil (`fetchProfilePictureUrl`)
- **Backend:** Novo método `BuscarFotoPerfilAsync(instanciaId, numero)` → retorna URL da foto
- **Frontend:** Chamar ao carregar contatos, salvar URL no `WhatsAppContato.FotoUrl`
- **Payload:** `{ number: "5544..." }`

### Alterações necessárias

| Camada | Arquivo | Alterações |
|--------|---------|------------|
| Backend Service | `WhatsAppService.cs` | +8 métodos novos |
| Backend Interface | `IWhatsAppService.cs` | +8 assinaturas |
| Backend Controller | `WhatsAppConfigController.cs` | +8 endpoints |
| Frontend Service | `whatsappService.ts` | +8 métodos |
| Frontend Chat | `ChatPage.tsx` | Menu reação, presença, marcar lida |
| Frontend Config | `WhatsAppConfigPage.tsx` | Verificar número |

---

## Fase 2 — Gerenciamento de Chat (8 endpoints)

**Objetivo:** Controle total sobre conversas e mensagens no WhatsApp.
**Impacto:** Médio — corrigir erros, gerenciar conversas, importar histórico.

### Funcionalidades

| # | Funcionalidade | Endpoint | Método | Descrição |
|---|----------------|----------|--------|-----------|
| 2.1 | Apagar mensagem para todos | `/chat/deleteMessageForEveryone` | DEL | Apagar mensagem enviada por engano |
| 2.2 | Editar mensagem | `/chat/updateMessage` | POST | Corrigir texto de mensagem já enviada |
| 2.3 | Marcar como não lida | `/chat/markAsUnread` | POST | Marcar conversa para revisão posterior |
| 2.4 | Arquivar conversa (WA) | `/chat/archiveChat` | POST | Sincronizar arquivo com WhatsApp real |
| 2.5 | Bloquear/desbloquear contato | `/chat/updateBlockStatus` | POST | Bloquear spam/contatos indesejados |
| 2.6 | Listar chats | `/chat/findChats` | POST | Importar conversas existentes do WhatsApp |
| 2.7 | Buscar Status/Stories | `/chat/findStatusMessage` | POST | Ver status postados por contatos |
| 2.8 | Listar instâncias (Evolution) | `/instance/fetchInstances` | GET | Listar todas as instâncias na Evolution API |

### Detalhamento Técnico

#### 2.1 — Apagar mensagem (`deleteMessageForEveryone`)
- **Backend:** `ApagarMensagemAsync(instanciaId, messageId, remoteJid)`
- **Frontend:** Menu de contexto na mensagem → "Apagar para todos" (só para mensagens enviadas `fromMe`)
- **Impacto DB:** Atualizar `WhatsAppMensagem.Texto` para "" e `AnexoUrl` para null (ou soft delete)

#### 2.2 — Editar mensagem (`updateMessage`)
- **Backend:** `EditarMensagemAsync(instanciaId, messageId, remoteJid, novoTexto)`
- **Frontend:** Menu de contexto → "Editar" (só para mensagens de texto enviadas)
- **Impacto DB:** Atualizar `WhatsAppMensagem.Texto` e adicionar flag `Editada`

#### 2.5 — Bloquear contato (`updateBlockStatus`)
- **Backend:** `BloquearContatoAsync(instanciaId, numero, bloquear: bool)`
- **Frontend:** Botão no perfil do contato ou menu de contexto da conversa
- **Impacto DB:** Novo campo `Bloqueado` em `WhatsAppContato`

---

## Fase 3 — Perfil e Configurações (11 endpoints)

**Objetivo:** Gerenciar o perfil do laboratório no WhatsApp e configurações da instância.
**Impacto:** Médio — profissionalismo e automação de configurações.

### Funcionalidades

| # | Funcionalidade | Endpoint | Método | Descrição |
|---|----------------|----------|--------|-----------|
| 3.1 | Buscar perfil comercial | `/profile/fetchBusinessProfile` | POST | Ver perfil Business atual |
| 3.2 | Alterar nome de exibição | `/profile/updateProfileName` | POST | Mudar nome no WhatsApp |
| 3.3 | Alterar recado/status | `/profile/updateProfileStatus` | POST | Mudar "Disponível", horário, etc. |
| 3.4 | Alterar foto de perfil | `/profile/updateProfilePicture` | POST | Atualizar logo do laboratório |
| 3.5 | Remover foto de perfil | `/profile/removeProfilePicture` | POST | Remover foto |
| 3.6 | Buscar privacidade | `/profile/fetchPrivacySettings` | POST | Ver configurações de privacidade |
| 3.7 | Alterar privacidade | `/profile/updatePrivacySettings` | POST | Visto por último, foto, recado |
| 3.8 | Configurações da instância | `/settings/set` | POST | rejectCall, alwaysOnline, readMessages, etc. |
| 3.9 | Buscar configurações | `/settings/find` | GET | Consultar configurações atuais |
| 3.10 | Definir presença global | `/instance/setPresence` | POST | Manter "online" permanentemente |
| 3.11 | Reiniciar instância | `/instance/restart` | PUT | Reiniciar sem perder sessão |

### Frontend

Nova seção na página `/configuracoes/whatsapp`:
- **Aba "Perfil":** Nome, foto, recado, perfil Business
- **Aba "Configurações":** Toggle switches para rejectCall, alwaysOnline, readMessages, groupsIgnore, syncFullHistory
- **Aba "Privacidade":** Visto por último, foto, recado (quem pode ver)

---

## Fase 4 — Grupos WhatsApp (15 endpoints)

**Objetivo:** Gerenciar grupos de clientes (ex: grupo de óticas parceiras, avisos de promoção).
**Impacto:** Médio — comunicação em massa organizada por grupo.

### Funcionalidades

| # | Funcionalidade | Endpoint | Método |
|---|----------------|----------|--------|
| 4.1 | Criar grupo | `/group/create` | POST |
| 4.2 | Alterar foto do grupo | `/group/updatePicture` | POST |
| 4.3 | Alterar nome do grupo | `/group/updateSubject` | POST |
| 4.4 | Alterar descrição | `/group/updateDescription` | POST |
| 4.5 | Obter link de convite | `/group/inviteCode` | GET |
| 4.6 | Revogar link de convite | `/group/revokeInviteCode` | POST |
| 4.7 | Enviar convite por mensagem | `/group/sendInvite` | POST |
| 4.8 | Buscar grupo por link | `/group/findByInviteCode` | GET |
| 4.9 | Buscar grupo por JID | `/group/findByJid` | GET |
| 4.10 | Listar todos os grupos | `/group/fetchAll` | GET |
| 4.11 | Listar membros | `/group/findParticipants` | GET |
| 4.12 | Gerenciar membros | `/group/updateParticipant` | POST |
| 4.13 | Configurações do grupo | `/group/updateSetting` | POST |
| 4.14 | Mensagens temporárias | `/group/toggleEphemeral` | POST |
| 4.15 | Sair do grupo | `/group/leaveGroup` | DEL |

### Frontend

Nova página `/configuracoes/whatsapp/grupos`:
- Lista de grupos com membros, link de convite
- Dialog para criar grupo, adicionar/remover membros
- Ações: renomear, alterar foto, gerar link de convite

### Entidades Backend

| Entidade | Campos principais |
|----------|-------------------|
| `WhatsAppGrupo` | Id, JID, Nome, Descricao, FotoUrl, InstanciaId, CriadoEm |
| `WhatsAppGrupoParticipante` | GrupoId, Numero, IsAdmin, AdicionadoEm |

---

## Fase 5 — Mensagens Avançadas e Eventos (9 endpoints)

**Objetivo:** Tipos de mensagem interativos + eventos webhook adicionais.
**Impacto:** Médio-baixo — funcionalidades complementares.

### Mensagens Avançadas

| # | Funcionalidade | Endpoint | Método | Descrição |
|---|----------------|----------|--------|-----------|
| 5.1 | Criar enquete | `/message/sendPoll` | POST | Pesquisa com opções de voto (satisfação, preferência) |
| 5.2 | Enviar lista interativa | `/message/sendList` | POST | Menu com seções e itens clicáveis |
| 5.3 | Enviar botões | `/message/sendButtons` | POST | Mensagem com botões de ação |
| 5.4 | Postar Status/Stories | `/message/sendStatus` | POST | Marketing no Status do WhatsApp |

> **Limitação:** `sendList` e `sendButtons` podem não funcionar no Baileys (apenas WhatsApp Business API oficial). Testar antes de implementar.

### Eventos Webhook Adicionais

| # | Evento | Configuração | Descrição |
|---|--------|-------------|-----------|
| 5.5 | `MESSAGES_DELETE` | docker-compose.yml | Sincronizar exclusão de mensagens |
| 5.6 | `PRESENCE_UPDATE` | docker-compose.yml | Mostrar "online"/"digitando" do contato |
| 5.7 | `CALL` | docker-compose.yml | Notificar chamadas recebidas no painel |
| 5.8 | `CONTACTS_UPSERT` | docker-compose.yml | Manter contatos atualizados automaticamente |
| 5.9 | `MESSAGES_SET` | docker-compose.yml | Importar histórico completo |

### Detalhamento Eventos

#### 5.5 — MESSAGES_DELETE
- **Backend:** Novo case no `ProcessarWebhookAsync` → soft delete da mensagem no banco
- **Frontend:** Atualizar mensagem para "Mensagem apagada" via SignalR

#### 5.6 — PRESENCE_UPDATE
- **Backend:** Novo case → enviar via SignalR para o frontend
- **Frontend:** Mostrar "online" / "digitando..." / "gravando..." abaixo do nome do contato

#### 5.7 — CALL
- **Backend:** Novo case → criar notificação no sistema
- **Frontend:** Toast/notificação "Chamada recebida de +55..."
- **Opcional:** Auto-rejeitar com mensagem (usa `settings/set` da Fase 3)

---

## Fase 6 — Integrações IA e Mensageria (77 endpoints)

**Objetivo:** Chatbots automatizados e infraestrutura de mensageria escalável.
**Impacto:** Alto a longo prazo — automação de atendimento, mas requer planejamento de produto.
**Pré-requisito:** Fases 1-3 completas + definição de produto (qual chatbot usar).

### 6A — Chatbots (63 endpoints)

| Plataforma | Endpoints | Tipo | Melhor para |
|------------|-----------|------|-------------|
| **Typebot** | 10 | No-code visual | Fluxos simples de atendimento (FAQ, triagem) |
| **OpenAI** | 12 | IA generativa | Atendimento inteligente com GPT |
| **Evolution Bot** | 9 | Bot nativo | Respostas automáticas básicas |
| **Dify** | 8 | Agente IA | Workflows complexos com IA |
| **Flowise** | 9 | LangChain visual | RAG e consultas em documentos |
| **n8n** | 7 | Automação | Workflows de integração (CRM, ERP) |
| **EvoAI** | 7 | IA Evolution | IA integrada nativa |

#### Recomendação para o OpticalCore

| Cenário | Plataforma recomendada | Justificativa |
|---------|----------------------|---------------|
| FAQ do laboratório | **Typebot** | Visual, fácil de criar, sem código |
| Atendimento com IA | **OpenAI** | GPT pode responder sobre pedidos, status, etc. |
| Integração com ERP | **n8n** | Conectar WhatsApp com módulos de Vendas/Estoque |
| Consulta de pedidos | **Dify** ou **Flowise** | RAG sobre dados do ERP |

#### Implementação sugerida

1. **Fase 6A.1 — Typebot** (10 endpoints): Chatbot visual para FAQ e triagem
2. **Fase 6A.2 — OpenAI** (12 endpoints): Atendimento inteligente
3. **Fase 6A.3 — n8n** (7 endpoints): Automação de workflows
4. Demais plataformas: sob demanda

### 6B — Mensageria Alternativa (8 endpoints)

| Plataforma | Endpoints | Quando usar |
|------------|-----------|-------------|
| **Chatwoot** | 2 | Se precisar de plataforma de atendimento multi-canal |
| **Websocket** | 2 | Se webhook causar gargalo (real-time puro) |
| **SQS** | 2 | Se precisar de fila assíncrona na AWS |
| **RabbitMQ** | 2 | Se precisar de fila de mensagens de alta escala |

#### Recomendação

- **Curto prazo:** Manter webhook (funciona bem para volume atual)
- **Médio prazo:** Avaliar Websocket se latência for problema
- **Longo prazo:** RabbitMQ/SQS se volume ultrapassar 1000 mensagens/minuto

---

## Cronograma — CONCLUÍDO

| Fase | Nome | Endpoints | Status | Commit |
|------|------|-----------|--------|--------|
| 1 | Experiência de Atendimento | 8 | **CONCLUÍDA** | `a5f5c6e` |
| 2 | Gerenciamento de Chat | 8 | **CONCLUÍDA** | `321bd11` |
| 3 | Perfil e Configurações | 11 | **CONCLUÍDA** | `5862ac1` |
| 4 | Grupos WhatsApp | 15 | **CONCLUÍDA** | `377c0ed` |
| 5 | Mensagens Avançadas + Eventos | 9 (+4 webhook) | **CONCLUÍDA** | `de3fa82` |
| 6 | Integrações IA + Mensageria | 77 | **CONCLUÍDA** | `84f90cc` |
| | **Total** | **130** | **100%** | Implementado em 2026-03-20 |

---

## Execução Realizada

```
Fase 1 (Atendimento)     ██████████████████████████████  CONCLUÍDA ✓
Fase 2 (Chat)             ██████████████████████████████  CONCLUÍDA ✓
Fase 3 (Perfil/Config)    ██████████████████████████████  CONCLUÍDA ✓
Fase 4 (Grupos)           ██████████████████████████████  CONCLUÍDA ✓
Fase 5 (Avançado+Eventos) ██████████████████████████████  CONCLUÍDA ✓
Fase 6 (Integrações)      ██████████████████████████████  CONCLUÍDA ✓
  ↓
```

---

## Critérios de Conclusão por Fase

### Fase 1 — Experiência de Atendimento
- [x] Reagir a mensagens com emoji (6 emojis rápidos)
- [x] "Digitando..." aparece no WhatsApp do cliente enquanto atendente digita
- [x] Mensagens marcadas como lidas automaticamente ao abrir conversa
- [x] Verificar número antes de enviar primeira mensagem
- [x] Enviar localização do laboratório
- [x] Enviar vCard de contato do sistema
- [x] Enviar sticker (imagem → WebP)
- [x] Avatar real do contato exibido no chat

### Fase 2 — Gerenciamento de Chat
- [x] Apagar mensagem para todos (menu de contexto)
- [x] Editar mensagem enviada (menu de contexto)
- [x] Marcar conversa como não lida
- [x] Arquivar conversa no WhatsApp real
- [x] Bloquear/desbloquear contato
- [x] Importar conversas existentes do WhatsApp
- [x] Ver Status/Stories dos contatos
- [x] Listar instâncias na Evolution API

### Fase 3 — Perfil e Configurações
- [x] Página de perfil WhatsApp (nome, foto, recado)
- [x] Configurações da instância (toggles: rejectCall, alwaysOnline, readMessages, groupsIgnore)
- [x] Configurações de privacidade (visto por último, foto, recado)
- [x] Reiniciar instância sem perder sessão

### Fase 4 — Grupos WhatsApp
- [x] Criar grupo com membros
- [x] Gerenciar membros (adicionar, remover, promover admin)
- [x] Alterar nome, descrição, foto do grupo
- [x] Gerar e compartilhar link de convite
- [x] Configurar mensagens temporárias
- [x] Sair do grupo

### Fase 5 — Mensagens Avançadas e Eventos
- [x] Criar e enviar enquetes
- [x] Sincronizar exclusão de mensagens (webhook MESSAGES_DELETE)
- [x] Mostrar "online"/"digitando" do contato (webhook PRESENCE_UPDATE)
- [x] Notificar chamadas recebidas (webhook CALL)
- [x] Auto-atualizar contatos (webhook CONTACTS_UPSERT)

---

## Dependências Externas

| Dependência | Fase | Descrição |
|-------------|------|-----------|
| Evolution API v2 atualizada | Todas | Manter container Docker atualizado |
| WhatsApp Business (opcional) | 5 | `sendList` e `sendButtons` podem requerer Business API |
| Typebot Server | 6A | Requer instância Typebot rodando (Docker) |
| OpenAI API Key | 6A | Requer conta OpenAI com créditos |
| n8n Server | 6A | Requer instância n8n rodando (Docker) |

---

## Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|-------|-------------|---------|-----------|
| `sendList`/`sendButtons` não funcionam no Baileys | Alta | Baixo | Testar antes, ter fallback para texto formatado |
| Rate limiting da Evolution API | Média | Médio | Implementar debounce no `sendPresence` (max 1x/3s) |
| Sticker muito grande (>500KB) | Baixa | Baixo | Comprimir imagem antes de converter para WebP |
| Grupo com muitos membros (>256) | Baixa | Baixo | Validar limite do WhatsApp antes de adicionar |
| WhatsApp bane número por spam | Média | Alto | Implementar rate limiting de mensagens por contato (max 10/min) |
| Webhook PRESENCE_UPDATE gera muito tráfego | Alta | Médio | Filtrar apenas contatos com conversa ativa, usar debounce |
