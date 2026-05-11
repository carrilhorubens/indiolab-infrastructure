# Evolution API v2 — Funcionalidades Disponíveis vs Implementadas

**Data:** 2026-03-20 (atualizado — 130/130 endpoints implementados)
**Referência:** https://doc.evolution-api.com/v2/api-reference
**Versão da API:** Evolution API v2 (Baileys/WhatsApp Web)
**Status:** 100% COMPLETO — Todas as 6 fases implementadas

---

## 1. Início

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/get-information` | GET | **Implementado** | Informações da versão da Evolution API |

---

## 2. Instances (Gerenciamento de Instância)

| Endpoint | Método | Status | Nosso Uso / Descrição |
|----------|--------|--------|----------------------|
| `/instance/create` | POST | **Implementado** | Criar instância por departamento |
| `/instance/fetchInstances` | GET | **Implementado** | Listar todas as instâncias na Evolution API |
| `/instance/connect` | GET | **Implementado** | Conectar instância (gerar QR Code) |
| `/instance/restart` | PUT | **Implementado** | Reiniciar instância sem perder sessão |
| `/instance/connectionState` | GET | **Implementado** | Verificar status (connected/disconnected/qrcode) |
| `/instance/logout` | DEL | **Implementado** | Desconectar (logout do WhatsApp) |
| `/instance/delete` | DEL | **Implementado** | Remover instância completamente |
| `/instance/setPresence` | POST | **Implementado** | Definir presença global ("online"/"offline") |

**Cobertura: 8/8 (100%)**

---

## 3. Webhook

| Endpoint | Método | Status | Nosso Uso / Descrição |
|----------|--------|--------|----------------------|
| `/webhook/set` | POST | **Implementado** | Configurar webhook ao criar instância |
| `/webhook/find` | GET | **Implementado** | Consultar webhook configurado |

**Cobertura: 2/2 (100%)**

---

## 4. Settings (Configurações da Instância)

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/settings/set` | POST | **Implementado** | Configurações avançadas: rejeitar chamadas, ler automaticamente, ignorar grupos, always online, sync history |
| `/settings/find` | GET | **Implementado** | Consultar configurações atuais da instância |

**Cobertura: 2/2 (100%)**

### Parâmetros disponíveis em Settings

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `rejectCall` | boolean | Rejeitar chamadas automaticamente |
| `msgCall` | string | Mensagem enviada ao rejeitar chamada |
| `groupsIgnore` | boolean | Ignorar mensagens de grupos |
| `alwaysOnline` | boolean | Manter WhatsApp sempre online |
| `readMessages` | boolean | Enviar recibos de leitura automaticamente |
| `readStatus` | boolean | Mostrar status de leitura em mensagens enviadas |
| `syncFullHistory` | boolean | Sincronizar histórico completo do WhatsApp |

---

## 5. Send Message (Envio de Mensagens)

| Endpoint | Método | Status | Nosso Uso / Descrição |
|----------|--------|--------|----------------------|
| `/message/sendText` | POST | **Implementado** | Enviar texto simples |
| `/message/sendStatus` | POST | **Implementado** | Postar no Status/Stories do WhatsApp |
| `/message/sendMedia` | POST | **Implementado** | Enviar imagem, vídeo, documento (com caption) |
| `/message/sendWhatsAppAudio` | POST | **Implementado** | Enviar áudio (formato PTT/voice note) |
| `/message/sendSticker` | POST | **Implementado** | Enviar stickers (figurinhas) |
| `/message/sendLocation` | POST | **Implementado** | Enviar localização (latitude/longitude com mapa) |
| `/message/sendContact` | POST | **Implementado** | Enviar cartão de contato (vCard) |
| `/message/sendReaction` | POST | **Implementado** | Reagir a mensagem com emoji (👍, ✅, ❤️, etc.) |
| `/message/sendPoll` | POST | **Implementado** | Criar enquete com opções de voto |
| `/message/sendList` | POST | **Implementado** | Enviar lista interativa (menu com seções e botões) |
| `/message/sendButtons` | POST | **Implementado** | Enviar mensagem com botões clicáveis |

> **Nota sobre stickers:** O **recebimento** de stickers já está implementado (extração de mídia WebP + download via `getBase64FromMediaMessage` + renderização 150px no frontend). Apenas o **envio** via `sendSticker` está pendente.

**Cobertura: 11/11 (100%)**

---

## 6. Chat Controller (Gerenciamento de Chat)

| Endpoint | Método | Status | Nosso Uso / Descrição |
|----------|--------|--------|----------------------|
| `/chat/checkIsWhatsApp` | POST | **Implementado** | Verificar se um número possui conta WhatsApp |
| `/chat/markAsRead` | POST | **Implementado** | Marcar mensagem como lida no WhatsApp (tick azul) |
| `/chat/markAsUnread` | POST | **Implementado** | Marcar mensagem como não lida |
| `/chat/archiveChat` | POST | **Implementado** | Arquivar conversa no WhatsApp |
| `/chat/deleteMessageForEveryone` | DEL | **Implementado** | Apagar mensagem para todos os participantes |
| `/chat/updateMessage` | POST | **Implementado** | Editar mensagem já enviada |
| `/chat/sendPresence` | POST | **Implementado** | Indicador "digitando..." / "gravando áudio..." |
| `/chat/updateBlockStatus` | POST | **Implementado** | Bloquear/desbloquear contato |
| `/chat/fetchProfilePictureUrl` | POST | **Implementado** | Buscar foto de perfil do contato |
| `/chat/getBase64` | POST | **Implementado** | Baixar mídia como base64 (usado no sync e stickers) |
| `/chat/findContacts` | POST | **Implementado** | Buscar contatos do WhatsApp |
| `/chat/findMessages` | POST | **Implementado** | Buscar mensagens (sync/polling) |
| `/chat/findStatusMessage` | POST | **Implementado** | Buscar mensagens do Status/Stories |
| `/chat/findChats` | POST | **Implementado** | Listar todos os chats do WhatsApp |

**Cobertura: 14/14 (100%)**

---

## 7. Profile Settings (Perfil do WhatsApp)

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/profile/fetchBusinessProfile` | POST | **Implementado** | Buscar perfil comercial (Business) |
| `/profile/updateProfileName` | POST | **Implementado** | Alterar nome de exibição do WhatsApp |
| `/profile/updateProfileStatus` | POST | **Implementado** | Alterar recado/status ("Disponível", etc.) |
| `/profile/updateProfilePicture` | POST | **Implementado** | Alterar foto de perfil |
| `/profile/removeProfilePicture` | POST | **Implementado** | Remover foto de perfil |
| `/profile/fetchPrivacySettings` | POST | **Implementado** | Buscar configurações de privacidade |
| `/profile/updatePrivacySettings` | POST | **Implementado** | Alterar privacidade (visto por último, foto, recado) |

**Cobertura: 7/7 (100%)**

---

## 8. Group Controller (Grupos WhatsApp)

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/group/create` | POST | **Implementado** | Criar novo grupo |
| `/group/updatePicture` | POST | **Implementado** | Alterar foto do grupo |
| `/group/updateSubject` | POST | **Implementado** | Alterar nome do grupo |
| `/group/updateDescription` | POST | **Implementado** | Alterar descrição do grupo |
| `/group/inviteCode` | GET | **Implementado** | Obter link de convite |
| `/group/revokeInviteCode` | POST | **Implementado** | Revogar link de convite |
| `/group/sendInvite` | POST | **Implementado** | Enviar convite por mensagem |
| `/group/findByInviteCode` | GET | **Implementado** | Buscar grupo pelo link de convite |
| `/group/findByJid` | GET | **Implementado** | Buscar grupo pelo JID |
| `/group/fetchAll` | GET | **Implementado** | Listar todos os grupos |
| `/group/findParticipants` | GET | **Implementado** | Listar membros do grupo |
| `/group/updateParticipant` | POST | **Implementado** | Adicionar/remover/promover membros |
| `/group/updateSetting` | POST | **Implementado** | Alterar configurações (quem pode enviar, etc.) |
| `/group/toggleEphemeral` | POST | **Implementado** | Ativar/desativar mensagens temporárias |
| `/group/leaveGroup` | DEL | **Implementado** | Sair do grupo |

**Cobertura: 15/15 (100%)**

---

## 9. Integrações — Typebot

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/typebot/create` | POST | **Implementado** | Criar bot Typebot |
| `/typebot/start` | POST | **Implementado** | Iniciar sessão Typebot |
| `/typebot/find` | GET | **Implementado** | Buscar Typebot |
| `/typebot/fetch` | GET | **Implementado** | Obter Typebot específico |
| `/typebot/update` | PUT | **Implementado** | Atualizar Typebot |
| `/typebot/delete` | DEL | **Implementado** | Deletar Typebot |
| `/typebot/changeSessionStatus` | POST | **Implementado** | Alterar status da sessão |
| `/typebot/fetchSession` | GET | **Implementado** | Buscar sessão ativa |
| `/typebot/settings` | POST | **Implementado** | Configurações do Typebot |
| `/typebot/fetchSettings` | GET | **Implementado** | Buscar configurações |

**Cobertura: 10/10 (100%)**

---

## 10. Integrações — OpenAI

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/openai/create` | POST | **Implementado** | Criar bot OpenAI |
| `/openai/find` | GET | **Implementado** | Buscar bot |
| `/openai/findAll` | GET | **Implementado** | Listar todos os bots |
| `/openai/update` | PUT | **Implementado** | Atualizar bot |
| `/openai/delete` | DEL | **Implementado** | Deletar bot |
| `/openai/findCreds` | GET | **Implementado** | Buscar credenciais OpenAI |
| `/openai/setCreds` | POST | **Implementado** | Configurar credenciais |
| `/openai/deleteCreds` | DEL | **Implementado** | Remover credenciais |
| `/openai/settings` | POST | **Implementado** | Configurações do OpenAI |
| `/openai/findSettings` | GET | **Implementado** | Buscar configurações |
| `/openai/changeStatus` | POST | **Implementado** | Alterar status do bot |
| `/openai/findSessions` | GET | **Implementado** | Buscar sessões ativas |

**Cobertura: 12/12 (100%)**

---

## 11. Integrações — Evolution Bot

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/evolutionBot/create` | POST | **Implementado** | Criar bot nativo Evolution |
| `/evolutionBot/findAll` | GET | **Implementado** | Listar bots |
| `/evolutionBot/fetch` | GET | **Implementado** | Buscar bot específico |
| `/evolutionBot/update` | PUT | **Implementado** | Atualizar bot |
| `/evolutionBot/delete` | DEL | **Implementado** | Deletar bot |
| `/evolutionBot/setSettings` | POST | **Implementado** | Configurações |
| `/evolutionBot/findSettings` | GET | **Implementado** | Buscar configurações |
| `/evolutionBot/changeStatus` | POST | **Implementado** | Alterar status |
| `/evolutionBot/fetchSession` | GET | **Implementado** | Buscar sessão |

**Cobertura: 9/9 (100%)**

---

## 12. Integrações — Dify

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/dify/create` | POST | **Implementado** | Criar bot Dify |
| `/dify/findAll` | GET | **Implementado** | Listar bots |
| `/dify/find` | GET | **Implementado** | Buscar bot específico |
| `/dify/update` | PUT | **Implementado** | Atualizar bot |
| `/dify/setSettings` | POST | **Implementado** | Configurações |
| `/dify/findSettings` | GET | **Implementado** | Buscar configurações |
| `/dify/changeStatus` | POST | **Implementado** | Alterar status |
| `/dify/findStatus` | GET | **Implementado** | Buscar status |

**Cobertura: 8/8 (100%)**

---

## 13. Integrações — Flowise

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/flowise/create` | POST | **Implementado** | Criar bot Flowise |
| `/flowise/findAll` | GET | **Implementado** | Listar bots |
| `/flowise/find` | GET | **Implementado** | Buscar bot específico |
| `/flowise/update` | PUT | **Implementado** | Atualizar bot |
| `/flowise/delete` | DEL | **Implementado** | Deletar bot |
| `/flowise/setSettings` | POST | **Implementado** | Configurações |
| `/flowise/findSettings` | GET | **Implementado** | Buscar configurações |
| `/flowise/changeStatus` | POST | **Implementado** | Alterar status |
| `/flowise/findSessions` | GET | **Implementado** | Buscar sessões |

**Cobertura: 9/9 (100%)**

---

## 14. Integrações — n8n

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/n8n/create` | POST | **Implementado** | Criar bot n8n |
| `/n8n/findAll` | GET | **Implementado** | Listar bots |
| `/n8n/update` | PUT | **Implementado** | Atualizar bot |
| `/n8n/setSettings` | POST | **Implementado** | Configurações |
| `/n8n/findSettings` | GET | **Implementado** | Buscar configurações |
| `/n8n/changeStatus` | POST | **Implementado** | Alterar status |
| `/n8n/findStatus` | GET | **Implementado** | Buscar status |

**Cobertura: 7/7 (100%)**

---

## 15. Integrações — EvoAI

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/evoai/create` | POST | **Implementado** | Criar bot EvoAI |
| `/evoai/findAll` | GET | **Implementado** | Listar bots |
| `/evoai/update` | PUT | **Implementado** | Atualizar bot |
| `/evoai/setSettings` | POST | **Implementado** | Configurações |
| `/evoai/findSettings` | GET | **Implementado** | Buscar configurações |
| `/evoai/changeStatus` | POST | **Implementado** | Alterar status |
| `/evoai/findStatus` | GET | **Implementado** | Buscar status |

**Cobertura: 7/7 (100%)**

---

## 16. Integrações — Chatwoot

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/chatwoot/set` | POST | **Implementado** | Configurar integração Chatwoot |
| `/chatwoot/find` | GET | **Implementado** | Buscar configuração Chatwoot |

**Cobertura: 2/2 (100%)**

---

## 17. Websocket

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/websocket/set` | POST | **Implementado** | Configurar Websocket (alternativa ao webhook) |
| `/websocket/find` | GET | **Implementado** | Buscar configuração Websocket |

**Cobertura: 2/2 (100%)**

---

## 18. SQS (Amazon Simple Queue Service)

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/sqs/set` | POST | **Implementado** | Configurar fila SQS |
| `/sqs/find` | GET | **Implementado** | Buscar configuração SQS |

**Cobertura: 2/2 (100%)**

---

## 19. RabbitMQ

| Endpoint | Método | Status | Descrição |
|----------|--------|--------|-----------|
| `/rabbitmq/set` | POST | **Implementado** | Configurar fila RabbitMQ |
| `/rabbitmq/find` | GET | **Implementado** | Buscar configuração RabbitMQ |

**Cobertura: 2/2 (100%)**

---

## Resumo Geral

| # | Categoria | Total | Implementado | Cobertura |
|---|-----------|-------|-------------|-----------|
| 1 | Início | 1 | 1 | 100% |
| 2 | Instances | 8 | 8 | 100% |
| 3 | Webhook | 2 | 2 | 100% |
| 4 | Settings | 2 | 2 | 100% |
| 5 | Send Message | 11 | 11 | 100% |
| 6 | Chat Controller | 14 | 14 | 100% |
| 7 | Profile Settings | 7 | 7 | 100% |
| 8 | Group Controller | 15 | 15 | 100% |
| 9 | Typebot | 10 | 10 | 100% |
| 10 | OpenAI | 12 | 12 | 100% |
| 11 | Evolution Bot | 9 | 9 | 100% |
| 12 | Dify | 8 | 8 | 100% |
| 13 | Flowise | 9 | 9 | 100% |
| 14 | n8n | 7 | 7 | 100% |
| 15 | EvoAI | 7 | 7 | 100% |
| 16 | Chatwoot | 2 | 2 | 100% |
| 17 | Websocket | 2 | 2 | 100% |
| 18 | SQS | 2 | 2 | 100% |
| 19 | RabbitMQ | 2 | 2 | 100% |
| | **TOTAL** | **130** | **130** | **100%** |

---

## Endpoints que Utilizamos Hoje (12)

```
POST /instance/create                          → Criar instância por departamento
GET  /instance/connect/{nome}                  → Conectar (gerar QR Code)
GET  /instance/connectionState/{nome}          → Verificar status
DEL  /instance/logout/{nome}                   → Desconectar
DEL  /instance/delete/{nome}                   → Remover instância
POST /webhook/set/{nome}                       → Configurar webhook
POST /message/sendText/{nome}                  → Enviar texto
POST /message/sendMedia/{nome}                 → Enviar mídia (imagem/vídeo/doc)
POST /message/sendWhatsAppAudio/{nome}         → Enviar áudio PTT
POST /chat/getBase64FromMediaMessage/{nome}    → Baixar mídia (base64) — stickers + sync
POST /chat/findContacts/{nome}                 → Buscar contatos
POST /chat/findMessages/{nome}                 → Sync de mensagens (polling)
```

### Funcionalidades implementadas no OpticalCore (além dos endpoints)

| Funcionalidade | Descrição |
|----------------|-----------|
| Recebimento de stickers | Extração de mídia WebP + download automático + renderização 150px fundo transparente |
| Multi-departamento | Instância por departamento com filtro de visibilidade |
| Alterar departamento | Endpoint PUT para mudar departamento de instância existente |
| Resolução LID | @lid → número real via banco de contatos |
| Contatos WhatsApp | Auto-cadastro + edição de nome + vinculação com Pessoa |
| Conversas unificadas | WhatsApp e chat interno na mesma aba |
| Soft delete conversas | Arquivar conversa WhatsApp (right-click) |
| Status delivery/read | Atualização via polling (MESSAGES_UPDATE) |
| QR Code com polling | Auto-refresh do QR Code + detecção de conexão |

---

## Eventos de Webhook Suportados

Eventos que a Evolution API pode enviar via webhook:

| Evento | Status no nosso sistema | Descrição |
|--------|------------------------|-----------|
| `MESSAGES_UPSERT` | **Ativo — Processado** | Mensagem recebida/enviada |
| `MESSAGES_UPDATE` | **Ativo — Processado** | Status atualizado (delivered/read) |
| `CONNECTION_UPDATE` | **Ativo — Processado** | Mudança de status da conexão |
| `QRCODE_UPDATED` | **Ativo — Processado** | QR Code atualizado |
| `SEND_MESSAGE` | **Ativo** | Confirmação de envio |
| `CONTACTS_UPDATE` | **Ativo** | Contato atualizado |
| `APPLICATION_STARTUP` | Desativado | API iniciou |
| `MESSAGES_SET` | Desativado | Batch de mensagens (histórico) |
| `MESSAGES_DELETE` | **Ativo — Processado** | Mensagem deletada (handler limpa texto/anexo) |
| `CONTACTS_SET` | Desativado | Batch de contatos |
| `CONTACTS_UPSERT` | **Ativo** | Contato criado/atualizado |
| `PRESENCE_UPDATE` | **Ativo** | Presença online/offline do contato |
| `CHATS_SET` | Desativado | Batch de chats |
| `CHATS_UPSERT` | Desativado | Chat criado |
| `CHATS_UPDATE` | Desativado | Chat atualizado |
| `CHATS_DELETE` | Desativado | Chat deletado |
| `GROUPS_UPSERT` | Desativado | Grupo criado |
| `GROUPS_UPDATE` | Desativado | Grupo atualizado |
| `GROUP_PARTICIPANTS_UPDATE` | Desativado | Participante adicionado/removido |
| `CALL` | **Ativo** | Chamada de voz/vídeo recebida |

### Eventos recomendados para ativar

| Evento | Prioridade | Justificativa |
|--------|-----------|---------------|
| `MESSAGES_DELETE` | Alta | Sincronizar exclusão de mensagens no chat |
| `PRESENCE_UPDATE` | Média | Mostrar "online"/"digitando" do contato |
| `CALL` | Média | Notificar chamadas recebidas no painel |
| `CONTACTS_UPSERT` | Baixa | Manter contatos atualizados automaticamente |

---

## Prioridades Sugeridas para Implementação

### Alta Prioridade (impacto direto no atendimento ao cliente)

| Funcionalidade | Endpoint(s) | Justificativa |
|----------------|-------------|---------------|
| Reagir a mensagens | `sendReaction` | Feedback rápido ao cliente (👍, ✅, ❤️) |
| Enviar localização | `sendLocation` | Compartilhar endereço do laboratório |
| Enviar contato (vCard) | `sendContact` | Compartilhar contatos de representantes/vendedores |
| Verificar número | `checkIsWhatsApp` | Validar número antes de enviar (evita erro) |
| Marcar como lida | `markAsRead` | Sincronizar tick azul no WhatsApp real |
| Indicador "digitando..." | `sendPresence` | Feedback visual para o cliente enquanto digita |
| Enviar sticker | `sendSticker` | Complementa o recebimento já implementado |
| Listar chats | `findChats` | Importar conversas existentes do WhatsApp |

### Média Prioridade (funcionalidades complementares)

| Funcionalidade | Endpoint(s) | Justificativa |
|----------------|-------------|---------------|
| Foto de perfil | `fetchProfilePictureUrl` | Exibir avatar real do contato no chat |
| Apagar mensagem | `deleteMessageForEveryone` | Corrigir mensagem enviada por engano |
| Editar mensagem | `updateMessage` | Corrigir texto após envio |
| Criar enquete | `sendPoll` | Pesquisa rápida com clientes (satisfação, etc.) |
| Bloquear contato | `updateBlockStatus` | Bloquear spam/contatos indesejados |
| Arquivar conversa (WA) | `archiveChat` | Sincronizar arquivo com WhatsApp real |
| Perfil do negócio | `fetchBusinessProfile` | Gerenciar perfil do laboratório no WhatsApp |
| Configurações | `settings/set` | Rejeitar chamadas, always online, read receipts |

### Baixa Prioridade (avançado / futuro)

| Funcionalidade | Endpoint(s) | Justificativa |
|----------------|-------------|---------------|
| Módulo de Grupos (15 endpoints) | `group/*` | Gerenciar grupos WhatsApp do laboratório |
| Lista interativa | `sendList` | Menu estruturado (limitação: só funciona no Business API) |
| Botões interativos | `sendButtons` | Botões clicáveis (limitação: só funciona no Business API) |
| Postar Status/Stories | `sendStatus` | Marketing via Status do WhatsApp |
| Mensagens temporárias | `toggleEphemeral` | Auto-destruição de mensagens |
| Privacidade | `updatePrivacySettings` | Controlar visto por último, foto, recado |

### Integrações (futuro — quando houver necessidade de chatbot)

| Plataforma | Endpoints | Descrição |
|------------|-----------|-----------|
| **Typebot** (10 endpoints) | CRUD + sessões + settings | Chatbot visual no-code |
| **OpenAI** (12 endpoints) | CRUD + credenciais + settings + sessões | Bot com IA (GPT) |
| **Evolution Bot** (9 endpoints) | CRUD + settings + sessões | Bot nativo da Evolution |
| **Dify** (8 endpoints) | CRUD + settings + status | Plataforma de agentes IA |
| **Flowise** (9 endpoints) | CRUD + settings + sessões | Chatbot com LangChain |
| **n8n** (7 endpoints) | CRUD + settings + status | Automação de workflows |
| **EvoAI** (7 endpoints) | CRUD + settings + status | IA integrada Evolution |

### Mensageria alternativa (futuro — quando houver necessidade de escalar)

| Plataforma | Endpoints | Descrição |
|------------|-----------|-----------|
| **Chatwoot** (2 endpoints) | Set + Find | Plataforma de atendimento ao cliente |
| **Websocket** (2 endpoints) | Set + Find | Alternativa real-time ao webhook |
| **SQS** (2 endpoints) | Set + Find | Fila Amazon para processamento assíncrono |
| **RabbitMQ** (2 endpoints) | Set + Find | Fila de mensagens para alta escala |
