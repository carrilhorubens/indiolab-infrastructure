# Pesquisa Completa: CRM para ERP B2B (Indústria Óptica)

**Data da pesquisa:** 31/03/2026
**Complemento a:** `estudo_crm.md` (pesquisa inicial com foco em visitas de campo, despesas, mapas e segurança)
**Objetivo:** cobrir todos os módulos, funcionalidades, integrações com ERP, automações, serviço ao cliente, analytics avançado e comparativo entre plataformas líderes para fundamentar a documentação técnica completa do módulo CRM do OpticalCore.

---

## Sumário

1. [Módulos Centrais do CRM — Detalhamento Completo](#1-módulos-centrais-do-crm--detalhamento-completo)
2. [Automação da Força de Vendas (SFA)](#2-automação-da-força-de-vendas-sfa)
3. [Atendimento ao Cliente dentro do CRM](#3-atendimento-ao-cliente-dentro-do-crm)
4. [Relatórios e Analytics](#4-relatórios-e-analytics)
5. [Pontos de Integração com ERP](#5-pontos-de-integração-com-erp)
6. [Comparativo entre Plataformas Líderes](#6-comparativo-entre-plataformas-líderes)
7. [Classificação: Essencial vs Desejável](#7-classificação-essencial-vs-desejável)
8. [Modelo de Dados Expandido](#8-modelo-de-dados-expandido)
9. [Referências](#9-referências)

---

## 1. Módulos Centrais do CRM — Detalhamento Completo

### 1.1 Gestão de Contas e Contatos (Account & Contact Management)

#### 1.1.1 Hierarquia de Contas

No contexto B2B de laboratório óptico, a hierarquia é fundamental:

```
Grupo Econômico (opcional)
└── Empresa-Mãe (Conta Principal / Parent Account)
    ├── Filial A (Conta Filha / Child Account)
    │   ├── Contato 1 — Comprador
    │   ├── Contato 2 — Gerente Técnico
    │   └── Contato 3 — Financeiro
    ├── Filial B
    │   ├── Contato 4 — Proprietário
    │   └── Contato 5 — Balconista
    └── Filial C
```

**Campos essenciais da Conta (empresa/ótica):**

| Campo | Tipo | Obrigatório | Observação |
|-------|------|:-----------:|-----------|
| Código | int (auto) | Sim | padStart(8, '0') — padrão OpticalCore |
| Razão Social | string | Sim | |
| Nome Fantasia | string | Não | Usado no dia-a-dia |
| CNPJ/CPF | string | Sim | Validação por tipo de pessoa |
| Inscrição Estadual | string | Não | |
| Tipo de Pessoa | domínio | Sim | Física / Jurídica |
| Segmento | domínio | Sim | Ótica, Clínica, Hospital, Distribuidor, etc. |
| Porte | domínio | Não | MEI, ME, EPP, Médio, Grande |
| Origem | domínio | Sim | Indicação, Feira, Site, Prospecção, etc. |
| Status | enum | Sim | Ativo, Inativo, Prospect, Bloqueado |
| Proprietário (owner) | FK usuário | Sim | Consultor responsável |
| Gerente responsável | FK usuário | Não | Hierarquia |
| Território | FK território | Não | Área de atendimento |
| Conta-pai | FK conta | Não | Hierarquia de contas |
| Data de cadastro | datetime | Sim | Automático |
| Data da última interação | datetime | Não | Calculado |
| Limite de crédito | decimal | Não | Integração financeiro |
| Saldo devedor | decimal | Não | Calculado |
| Potencial mensal estimado | decimal | Não | Valor estimado de compras/mês |
| Classificação (rating) | enum | Não | A, B, C, D — ou estrelas |
| Tags | string[] | Não | Classificação livre |
| Observações | text | Não | |
| Latitude/Longitude | decimal | Não | Geocodificação |

**Campos essenciais do Contato (pessoa física dentro da conta):**

| Campo | Tipo | Obrigatório | Observação |
|-------|------|:-----------:|-----------|
| Nome completo | string | Sim | |
| Cargo/Função | string | Não | Proprietário, Comprador, Técnico, etc. |
| Departamento | string | Não | |
| E-mail | string | Não | Pode ter múltiplos |
| Telefone | string | Não | Pode ter múltiplos |
| WhatsApp | string | Não | Integração iChat |
| É decisor? | boolean | Não | Influencia scoring |
| É contato principal? | boolean | Não | |
| Aniversário | date | Não | Para ações de relacionamento |
| Preferência de contato | enum | Não | WhatsApp, E-mail, Telefone, Presencial |
| LinkedIn | string | Não | |
| Conta vinculada | FK conta | Sim | |
| Status | enum | Sim | Ativo, Inativo |
| Tags | string[] | Não | |

#### 1.1.2 Endereços Múltiplos

Cada conta pode ter N endereços com tipo (comercial, entrega, cobrança, filial):

| Campo | Tipo |
|-------|------|
| Tipo | domínio (Comercial, Entrega, Cobrança, Correspondência) |
| CEP | string |
| Logradouro | string |
| Número | string |
| Complemento | string |
| Bairro | string |
| Cidade | string |
| UF | string |
| País | string (default: Brasil) |
| É principal? | boolean |
| Latitude | decimal |
| Longitude | decimal |

#### 1.1.3 Comunicação Multicanal

O registro de contatos deve suportar múltiplos canais por contato:

| Canal | Estrutura |
|-------|-----------|
| Telefone | Tipo (Fixo/Celular/Recado) + Número + WhatsApp? |
| E-mail | Tipo (Pessoal/Corporativo) + Endereço |
| WhatsApp | Número + Vinculado ao iChat |
| Rede social | Tipo (LinkedIn/Instagram) + URL/Handle |

---

### 1.2 Gestão de Leads (Lead Management)

#### 1.2.1 Conceito de Lead no B2B Óptico

Um **lead** é uma oportunidade de negócio ainda não qualificada. No contexto de laboratório óptico, leads podem vir de:

- Feiras do setor (ABIÓTICA, etc.)
- Indicação de clientes existentes
- Site/landing pages
- Prospecção ativa (cold call/visit)
- Redes sociais
- Parcerias com fornecedores

#### 1.2.2 Campos do Lead

| Campo | Tipo | Obrigatório | Observação |
|-------|------|:-----------:|-----------|
| Código | int (auto) | Sim | |
| Nome do contato | string | Sim | |
| Nome da empresa | string | Não | Pode não saber ainda |
| CNPJ | string | Não | |
| Telefone | string | Não | |
| E-mail | string | Não | |
| WhatsApp | string | Não | |
| Cidade/UF | string | Não | |
| Origem (source) | domínio | Sim | Feira, Site, Indicação, Prospecção, etc. |
| Canal de entrada | domínio | Não | WhatsApp, Telefone, E-mail, Presencial |
| Campanha | FK campanha | Não | Se veio de campanha específica |
| Interesse | text | Não | O que o lead procura |
| Potencial estimado | decimal | Não | R$/mês estimado |
| Score | int | Não | 0-100 (lead scoring) |
| Status | enum | Sim | Novo, Contatado, Qualificado, Desqualificado, Convertido |
| Motivo de desqualificação | domínio | Não | Fora do perfil, Sem interesse, Concorrente, etc. |
| Proprietário (owner) | FK usuário | Sim | Consultor atribuído |
| Data de criação | datetime | Sim | |
| Data de primeiro contato | datetime | Não | |
| Data de qualificação | datetime | Não | |
| Data de conversão | datetime | Não | |
| Convertido para conta | FK conta | Não | |
| Convertido para oportunidade | FK oportunidade | Não | |
| Tags | string[] | Não | |
| Observações | text | Não | |

#### 1.2.3 Lead Scoring (Pontuação de Leads)

O lead scoring classifica leads por probabilidade de conversão. Existem dois tipos:

**Scoring Explícito (dados fornecidos pelo lead):**

| Critério | Pontos | Lógica |
|----------|--------|--------|
| Tem CNPJ | +15 | Empresa formalizada |
| Porte da empresa (ME/EPP/Médio) | +5/+10/+20 | Maior porte = maior potencial |
| Segmento-alvo (Ótica) | +20 | Perfil ideal |
| Cidade com presença do laboratório | +10 | Logística favorável |
| Decisor identificado | +15 | Acesso ao decisor |
| Potencial estimado > R$5k/mês | +20 | Alto valor |
| Já é cliente de laboratório concorrente | +10 | Mercado validado |

**Scoring Comportamental (ações do lead):**

| Ação | Pontos | Lógica |
|------|--------|--------|
| Respondeu contato em < 24h | +10 | Engajamento |
| Solicitou tabela de preços | +15 | Intenção de compra |
| Agendou visita | +20 | Alta intenção |
| Visitou stand em feira | +10 | Interesse demonstrado |
| Não responde há > 30 dias | -15 | Decaimento |
| Pediu para não ser contatado | -50 | Sem interesse |

**Faixas de classificação:**

| Faixa | Score | Ação recomendada |
|-------|-------|-----------------|
| Frio | 0-25 | Nurturing / acompanhamento passivo |
| Morno | 26-50 | Follow-up periódico |
| Quente | 51-75 | Agendar visita / enviar proposta |
| Super quente | 76-100 | Prioridade máxima / contato imediato |

**Regras de implementação:**
- Score recalculado a cada interação ou periodicamente (batch diário)
- Score decai com o tempo sem interação (time decay)
- Regras de scoring configuráveis por administrador
- Threshold de qualificação automática configurável (ex: score >= 60 → status "Qualificado")

#### 1.2.4 Conversão de Lead

Quando qualificado, o lead é convertido em:
1. **Conta** (empresa) — se não existir
2. **Contato** (pessoa) — vinculado à conta
3. **Oportunidade** — com dados pré-preenchidos do lead

O lead original mantém status "Convertido" com referências às entidades criadas. Nunca é deletado — preserva histórico e métricas.

**Regras de conversão:**
- Verificar duplicidade de CNPJ antes de criar conta
- Se conta já existe, vincular contato à conta existente
- Transferir tags, observações e histórico de atividades
- Manter rastreabilidade: `Lead.ConvertidoParaContaId`, `Lead.ConvertidoParaOportunidadeId`

---

### 1.3 Pipeline de Oportunidades/Negócios (Opportunity/Deal Pipeline)

#### 1.3.1 Conceito de Pipeline

O pipeline representa o funil de vendas com estágios configuráveis. Para laboratório óptico B2B:

**Pipeline padrão sugerido:**

| Etapa | Ordem | Probabilidade | Descrição |
|-------|-------|:------------:|-----------|
| Prospecção | 1 | 10% | Lead identificado, primeiro contato |
| Qualificação | 2 | 20% | Necessidade confirmada, perfil validado |
| Apresentação | 3 | 40% | Apresentação do laboratório / produtos / diferenciais |
| Proposta | 4 | 60% | Proposta comercial enviada |
| Negociação | 5 | 80% | Discussão de preços, prazos, condições |
| Fechamento | 6 | 90% | Acordo verbal, aguardando formalização |
| Ganho | 7 | 100% | Negócio fechado — cliente ativo |
| Perdido | 8 | 0% | Negócio perdido |

**Múltiplos pipelines:**
O sistema deve suportar múltiplos pipelines para diferentes processos:
- Pipeline de Novos Clientes (prospecção completa)
- Pipeline de Upsell/Cross-sell (clientes existentes)
- Pipeline de Reativação (clientes inativos)
- Pipeline de Grandes Contas (ciclo longo, mais etapas)

#### 1.3.2 Campos da Oportunidade

| Campo | Tipo | Obrigatório | Observação |
|-------|------|:-----------:|-----------|
| Código | int (auto) | Sim | |
| Título | string | Sim | Ex: "Ótica Visão Clara — Surfaçagem" |
| Conta | FK conta | Sim | |
| Contato principal | FK contato | Não | |
| Pipeline | FK pipeline | Sim | |
| Etapa atual | FK etapa | Sim | |
| Valor estimado | decimal | Sim | R$ |
| Valor recorrente mensal | decimal | Não | Para contratos recorrentes |
| Probabilidade (%) | int | Sim | Automática pela etapa ou manual |
| Valor ponderado | decimal | Calculado | valor * probabilidade |
| Data de criação | datetime | Sim | |
| Data prevista de fechamento | date | Sim | |
| Data real de fechamento | date | Não | |
| Resultado | enum | Não | Ganho, Perdido, Cancelado |
| Motivo de perda | domínio | Condicional | Obrigatório se Perdido |
| Concorrente que ganhou | string | Não | |
| Origem do lead | FK lead | Não | Rastreabilidade |
| Proprietário (consultor) | FK usuário | Sim | |
| Equipe de vendas | FK equipe | Não | |
| Tipo de negócio | domínio | Não | Novo cliente, Upsell, Reativação |
| Produtos de interesse | N:N produto | Não | Integração com catálogo |
| Próxima ação | string | Não | |
| Data da próxima ação | date | Não | |
| Score da oportunidade | int | Não | |
| Tags | string[] | Não | |
| Observações | text | Não | |

#### 1.3.3 Motivos de Perda (Win/Loss Analysis)

Tabela de domínio configurável:

| Motivo | Categoria |
|--------|-----------|
| Preço mais alto que concorrente | Preço |
| Condição de pagamento desfavorável | Preço |
| Prazo de entrega longo | Operação |
| Qualidade do produto insatisfatória | Produto |
| Falta de produto/serviço desejado | Produto |
| Relacionamento com concorrente | Relacionamento |
| Atendimento ruim | Atendimento |
| Cliente não tinha perfil | Qualificação |
| Cliente desistiu de comprar | Mercado |
| Mudança de prioridade do cliente | Mercado |
| Fechou com laboratório próprio | Mercado |
| Sem resposta / ghosting | Processo |
| Outro | Outro |

#### 1.3.4 Forecast (Previsão de Vendas)

Três métodos principais:

**Método 1 — Forecast por Etapa do Pipeline:**
```
Forecast = SUM(valor_oportunidade * probabilidade_da_etapa)
```
Simples, mas impreciso — assume que a probabilidade da etapa é igual para todos.

**Método 2 — Forecast por Categoria (Salesforce-style):**
O consultor classifica manualmente cada oportunidade:

| Categoria | Descrição | Peso sugerido |
|-----------|-----------|:------------:|
| Pipeline | Início do processo | 10-20% |
| Best Case | Cenário otimista | 50-70% |
| Commit | Alta confiança de fechamento | 80-95% |
| Closed | Fechado no período | 100% |
| Omitted | Não incluir no forecast | 0% |

**Método 3 — Forecast Histórico (avançado):**
Usa taxas históricas de conversão por etapa, consultor, segmento e sazonalidade. Requer dados acumulados — adequado para fase posterior.

**Recomendação:** Começar com Método 1 (automático) + Método 2 (manual) para permitir ajuste pelo consultor/gerente.

**Visões de forecast:**
- Por consultor
- Por gerente/equipe
- Por território
- Por período (mês/trimestre/semestre/ano)
- Por pipeline
- Por segmento de cliente
- Comparativo previsto vs realizado (accuracy)

---

### 1.4 Gestão de Atividades (Activity Management)

#### 1.4.1 Tipos de Atividade

| Tipo | Ícone sugerido | Campos específicos |
|------|----------------|-------------------|
| Ligação | Phone | Direção (entrada/saída), duração, resultado |
| E-mail | Email | Assunto, corpo, destinatários, anexos |
| Reunião | Groups | Local, participantes, pauta, ata |
| Visita | DirectionsWalk | (ver estudo_crm.md — entidade central) |
| Tarefa | Assignment | Tipo, prioridade, prazo, responsável |
| WhatsApp | WhatsApp | Conversa vinculada ao iChat |
| Nota | Note | Texto livre + anexos |
| Proposta enviada | Description | FK proposta |
| Follow-up | FollowUp | Data planejada, tipo (ligação/email/visita) |

#### 1.4.2 Campos Comuns de Atividade

| Campo | Tipo | Obrigatório |
|-------|------|:-----------:|
| Tipo | enum | Sim |
| Título/Assunto | string | Sim |
| Descrição | text | Não |
| Data/hora | datetime | Sim |
| Duração (min) | int | Não |
| Conta vinculada | FK conta | Não |
| Contato vinculado | FK contato | Não |
| Oportunidade vinculada | FK oportunidade | Não |
| Lead vinculado | FK lead | Não |
| Responsável | FK usuário | Sim |
| Status | enum | Sim (Planejada, Concluída, Cancelada) |
| Resultado | text | Não |
| Próximos passos | text | Não |
| Prioridade | enum | Não (Baixa, Normal, Alta, Urgente) |
| Lembrete | datetime | Não |
| Recorrência | config | Não (Fase posterior) |
| Anexos | file[] | Não |

#### 1.4.3 Timeline de Comunicação (Communication History)

A timeline é a visão cronológica de **todas** as interações com uma conta, contato ou oportunidade. Ela agrega:

- Atividades (ligações, emails, reuniões, visitas)
- Notas internas
- Mudanças de etapa da oportunidade
- Propostas enviadas
- Pedidos de venda (integração ERP)
- Faturas emitidas (integração ERP)
- Mensagens do WhatsApp (integração iChat)
- Tickets de suporte
- Alterações cadastrais relevantes

**Implementação técnica:**
```
TimelineEntry {
  id: guid
  tipo: enum (Atividade, Nota, MudancaEtapa, Proposta, Pedido, Fatura, Mensagem, Ticket, Alteracao)
  data: datetime
  titulo: string
  descricao: string
  usuario: FK
  entidadeOrigem: string (nome da tabela)
  entidadeOrigemId: guid
  metadados: jsonb (campos extras por tipo)
}
```

**Filtros da timeline:**
- Por tipo de evento
- Por período
- Por usuário responsável
- Apenas atividades com resultado
- Apenas interações externas (excluir notas internas)

---

### 1.5 Processo de Vendas e Automação de Workflow

#### 1.5.1 Automações Essenciais

**Automações baseadas em evento (triggers):**

| Trigger | Ação automática | Prioridade |
|---------|----------------|:----------:|
| Lead criado | Atribuir ao consultor do território | Essencial |
| Lead sem contato há 48h | Alerta ao consultor + gerente | Essencial |
| Lead score >= 60 | Mudar status para "Qualificado" | Essencial |
| Oportunidade criada | Criar tarefa de follow-up em 3 dias | Essencial |
| Oportunidade parada na etapa há X dias | Alerta ao consultor | Essencial |
| Oportunidade perdida | Solicitar motivo de perda | Essencial |
| Oportunidade ganha | Criar pedido de venda (integração) | Desejável |
| Visita concluída sem próximos passos | Alerta ao consultor | Desejável |
| Cliente sem interação há 60 dias | Criar tarefa de follow-up | Desejável |
| Despesa submetida | Notificar gerente para aprovação | Essencial |
| Aniversário do contato | Lembrete ao consultor | Desejável |

**Automações baseadas em tempo (scheduled):**

| Regra | Frequência | Ação |
|-------|-----------|------|
| Decaimento de lead score | Diário | Reduzir score de leads sem interação |
| Recálculo de KPIs | Diário/Horário | Atualizar snapshots de métricas |
| Relatório semanal de pipeline | Semanal | E-mail para gerentes |
| Clientes sem pedido há 90 dias | Semanal | Criar alerta de inatividade |
| Oportunidades com previsão vencida | Diário | Alertar consultor para atualizar |

#### 1.5.2 Regras de Atribuição (Assignment Rules)

| Critério | Método |
|----------|--------|
| Território geográfico | Lead/conta atribuído ao consultor do território |
| Round-robin | Distribuição sequencial entre consultores |
| Carga de trabalho | Atribuir ao consultor com menos leads/oportunidades abertos |
| Segmento específico | Ex: leads de hospitais → consultor especializado |
| Manual | Gerente atribui manualmente |

#### 1.5.3 Templates e Documentos

| Template | Uso |
|----------|-----|
| Template de e-mail | Prospecção, follow-up, proposta, agradecimento |
| Template de proposta | Documento PDF com dados do cliente e produtos |
| Template de visita | Pauta padrão por tipo de visita |
| Template de tarefa | Checklist por tipo de atividade |

**Variáveis de merge (mail merge):**
```
{{contato.nome}}, {{conta.nomeFantasia}}, {{oportunidade.valor}},
{{consultor.nome}}, {{consultor.telefone}}, {{data.hoje}}
```

---

### 1.6 Gestão de Cotações e Propostas (Quotation/Proposal Management)

#### 1.6.1 Fluxo de Proposta

```
Oportunidade → Criar Proposta → Adicionar Itens → Revisar → Enviar ao Cliente
→ Cliente Aceita → Converter em Pedido de Venda
→ Cliente Rejeita → Registrar motivo → Criar nova versão ou perder oportunidade
→ Cliente não responde → Follow-up automático
```

#### 1.6.2 Campos da Proposta/Cotação

| Campo | Tipo | Obrigatório |
|-------|------|:-----------:|
| Número | int (auto) | Sim |
| Oportunidade | FK | Sim |
| Conta | FK | Sim |
| Contato | FK | Não |
| Data de emissão | date | Sim |
| Validade | date | Sim |
| Versão | int | Sim (auto-incremento por oportunidade) |
| Status | enum | Sim |
| Condição de pagamento | domínio | Sim |
| Prazo de entrega | string | Não |
| Observações | text | Não |
| Desconto global (%) | decimal | Não |
| Valor total | decimal | Calculado |
| Responsável | FK usuário | Sim |
| Aprovador (se necessário) | FK usuário | Não |

**Status da proposta:**
- Rascunho
- Em revisão (aprovação interna)
- Enviada
- Visualizada (se houver tracking)
- Aceita
- Rejeitada
- Expirada
- Revisada (nova versão criada)

#### 1.6.3 Itens da Proposta

| Campo | Tipo |
|-------|------|
| Produto/Serviço | FK produto |
| Descrição | string |
| Quantidade | decimal |
| Unidade | domínio |
| Preço unitário | decimal |
| Desconto (%) | decimal |
| Valor total | decimal (calculado) |
| Observação do item | string |

#### 1.6.4 Versionamento

Cada proposta revisada gera nova versão (v1, v2, v3...) mantendo histórico completo. A oportunidade referencia a versão mais recente, mas todas são acessíveis na timeline.

---

### 1.7 Segmentação e Classificação de Clientes

#### 1.7.1 Critérios de Segmentação

**Segmentação Firmográfica (dados da empresa):**

| Critério | Valores típicos |
|----------|----------------|
| Segmento de mercado | Ótica, Clínica Oftalmológica, Hospital, Rede de Óticas, Distribuidor |
| Porte | MEI, ME, EPP, Médio, Grande |
| Faturamento estimado | Faixas configuráveis |
| Região geográfica | Estado, Cidade, Microrregião |
| Tempo como cliente | Novo (<6m), Recente (6m-2a), Estabelecido (>2a) |
| Número de filiais | 1, 2-5, 6-20, 20+ |

**Segmentação Comportamental (interações e compras):**

| Critério | Valores típicos |
|----------|----------------|
| Volume de compras (mensal) | Faixas em R$ |
| Frequência de pedidos | Diário, Semanal, Quinzenal, Mensal, Esporádico |
| Mix de produtos | Surfaçagem, Tratamento, Montagem, Lentes prontas |
| Ticket médio | Faixas em R$ |
| Pontualidade de pagamento | Em dia, Eventual atraso, Frequente atraso |
| Engajamento | Responde rápido, Proativo, Reativo, Difícil contato |
| NPS/Satisfação | Promotor, Neutro, Detrator |

#### 1.7.2 Classificação ABC (Curva de Pareto)

Aplicar análise ABC sobre o faturamento dos últimos 12 meses:

| Classe | Critério | % clientes (típico) | % faturamento (típico) | Ação |
|--------|----------|:-------------------:|:----------------------:|------|
| A | Top 20% faturamento | ~20% | ~80% | Visita mensal, atendimento premium |
| B | Próximos 30% | ~30% | ~15% | Visita bimestral, acompanhamento regular |
| C | Últimos 50% | ~50% | ~5% | Contato trimestral, autoatendimento |

**Reclassificação:** automática, mensal ou trimestral, com alerta quando cliente muda de classe.

#### 1.7.3 Classificação por Potencial (Opportunity-based)

| Classificação | Critério | Ação |
|---------------|----------|------|
| Estrela | Alto faturamento + Alto potencial restante | Expandir carteira |
| Vaca leiteira | Alto faturamento + Potencial saturado | Manter e fidelizar |
| Promessa | Baixo faturamento + Alto potencial | Desenvolver agressivamente |
| Interrogação | Baixo faturamento + Baixo potencial | Avaliar custo de servir |

#### 1.7.4 RFM (Recency, Frequency, Monetary)

| Dimensão | O que mede | Score 1-5 |
|----------|-----------|:---------:|
| Recency | Tempo desde último pedido | 5 = recente, 1 = antigo |
| Frequency | Frequência de pedidos | 5 = frequente, 1 = raro |
| Monetary | Valor total gasto | 5 = alto, 1 = baixo |

Combinação RFM gera segmentos automáticos:
- **555** = Campeão (melhor cliente)
- **511** = Não pode perder (era ótimo, parou de comprar)
- **155** = Novo cliente de alto valor
- **111** = Hibernando/Perdido

---

### 1.8 Tags e Campos Personalizados

#### 1.8.1 Sistema de Tags

Tags são labels livres que permitem classificação cruzada sem alterar o schema:

**Regras de tags:**
- Tags disponíveis para: Contas, Contatos, Leads, Oportunidades, Atividades
- Cores configuráveis por tag (para identificação visual)
- Tags predefinidas (administrador) + tags livres (consultor)
- Filtro por tag em todas as listagens
- Múltiplas tags por entidade

**Tags predefinidas sugeridas (ótica):**

| Categoria | Tags |
|-----------|------|
| Produto | surfaçagem, tratamento, montagem, lentes-prontas, acessórios |
| Comportamento | inadimplente, bom-pagador, volume-alto, primeiro-pedido |
| Relacionamento | indicador, parceiro, ex-cliente, vip |
| Ação necessária | requer-visita, pendência-financeira, reclamação-aberta |
| Campanha | feira-2026, promo-verao, lancamento-digital |

#### 1.8.2 Campos Personalizados (Custom Fields)

Para manter flexibilidade sem migrations a cada novo campo:

| Tipo suportado | Exemplo |
|----------------|---------|
| Texto curto | Nome do contador |
| Texto longo | Observações especiais de entrega |
| Número inteiro | Quantidade de funcionários |
| Número decimal | Distância do laboratório (km) |
| Data | Data da última auditoria |
| Booleano | Aceita lentes importadas? |
| Lista (dropdown) | Rede de filiação |
| Lista múltipla | Serviços de interesse |
| URL | Site da ótica |
| Arquivo | Contrato social |

**Implementação técnica recomendada:**
- Tabela `CampoPersonalizado` com definição (nome, tipo, entidade, obrigatório, opções)
- Tabela `ValorCampoPersonalizado` com FK para entidade + FK para campo + valor (jsonb ou colunas tipadas)
- Alternativa: coluna `customFields jsonb` diretamente na entidade (mais simples, menos estruturado)
- Para ERP com schema-per-tenant: cada tenant pode ter seus próprios campos personalizados

---

### 1.9 Notas e Anexos

#### 1.9.1 Sistema de Notas

| Campo | Tipo |
|-------|------|
| Conteúdo | text (rich text) |
| Tipo | enum (Geral, Interna, Importante, Alerta) |
| Entidade vinculada | polimórfico (Conta/Contato/Lead/Oportunidade/Visita) |
| Autor | FK usuário |
| Fixada (pinned) | boolean |
| Menções (@) | FK[] usuários |
| Data | datetime |

#### 1.9.2 Sistema de Anexos

| Campo | Tipo |
|-------|------|
| Nome do arquivo | string |
| Tipo MIME | string |
| Tamanho | long |
| Categoria | domínio (Contrato, Proposta, Recibo, Foto, Documento, Outro) |
| Entidade vinculada | polimórfico |
| Upload por | FK usuário |
| Data de upload | datetime |
| URL/Path | string |

**Restrições:**
- Tipos permitidos: PDF, DOC(X), XLS(X), JPG, PNG, WEBP
- Tamanho máximo por arquivo: configurável (sugestão: 10MB)
- Storage: Object storage (S3/Azure Blob/MinIO) com URLs assinadas

---

## 2. Automação da Força de Vendas (SFA)

### 2.1 Gestão de Territórios (Territory Management)

#### 2.1.1 Conceito

Território é a unidade geográfica ou lógica de atribuição comercial. Define quem é responsável por quais clientes/regiões.

#### 2.1.2 Hierarquia de Territórios

```
Nacional
├── Região Sul
│   ├── PR — Curitiba e RMC (Consultor A)
│   ├── PR — Interior (Consultor B)
│   ├── SC — Litoral (Consultor C)
│   ├── SC — Interior (Consultor D)
│   └── RS — Todo estado (Consultor E)
├── Região Sudeste
│   ├── SP — Capital (Equipe F)
│   ├── SP — Interior Leste (Consultor G)
│   ├── SP — Interior Oeste (Consultor H)
│   ├── RJ — Todo estado (Consultor I)
│   └── MG — Todo estado (Consultor J)
└── ...
```

#### 2.1.3 Campos do Território

| Campo | Tipo |
|-------|------|
| Código | int (auto) |
| Nome | string |
| Tipo | enum (País, Região, Estado, Cidade, Microrregião, Customizado) |
| Território-pai | FK território |
| Geometria | GeoJSON (para visualização em mapa) |
| Gerente responsável | FK usuário |
| Consultores atribuídos | N:N usuário |
| Status | enum (Ativo, Inativo) |
| Meta mensal | decimal |
| Meta trimestral | decimal |
| Meta anual | decimal |

#### 2.1.4 Regras de Território

| Regra | Descrição |
|-------|-----------|
| Exclusividade | Cada conta pertence a exatamente 1 território ativo |
| Herança | Conta sem território explícito herda pelo endereço principal |
| Conflito | Sistema alerta quando conta está em área de sobreposição |
| Reatribuição | Ao mudar território de uma conta, transferir oportunidades abertas? (configurável) |
| Visualização | Consultor vê apenas seu território; gerente vê territórios subordinados |

### 2.2 Estrutura da Equipe de Vendas (Sales Team Structure)

#### 2.2.1 Hierarquia

```
Diretor Comercial
├── Gerente Regional Sul
│   ├── Consultor Sênior A (carteira de grandes contas)
│   ├── Consultor Pleno B (carteira mista)
│   └── Consultor Júnior C (prospecção)
├── Gerente Regional Sudeste
│   ├── ...
└── Coordenador de Inside Sales
    ├── SDR 1 (qualificação de leads)
    └── SDR 2
```

#### 2.2.2 Papéis no Processo Comercial

| Papel | Responsabilidade | Visibilidade |
|-------|-----------------|-------------|
| SDR (Sales Dev Rep) | Qualificar leads, agendar reuniões/visitas | Seus leads |
| Consultor de Vendas | Ciclo completo: visita → proposta → fechamento | Sua carteira + território |
| Key Account Manager | Grandes contas estratégicas | Suas contas designadas |
| Inside Sales | Vendas remotas, reativação, suporte comercial | Contas atribuídas |
| Gerente Regional | Gestão de equipe, aprovações, coaching | Toda a equipe |
| Diretor Comercial | Estratégia, forecast, grandes decisões | Toda a operação |

#### 2.2.3 Modelo de Equipe de Vendas (Entidade)

| Campo | Tipo |
|-------|------|
| Nome da equipe | string |
| Tipo | enum (Field Sales, Inside Sales, Key Accounts, Prospecção) |
| Líder | FK usuário |
| Membros | N:N usuário com papel (Membro, Líder, Backup) |
| Territórios atribuídos | N:N território |
| Ativo | boolean |

### 2.3 Metas e Objetivos de Vendas (Sales Goals & Targets)

#### 2.3.1 Tipos de Meta

| Tipo | Métrica | Exemplo |
|------|---------|---------|
| Receita | R$ faturado | R$ 150.000/mês |
| Quantidade | Pedidos fechados | 20 pedidos/mês |
| Novos clientes | Contas novas ativadas | 5 clientes novos/mês |
| Visitas | Visitas realizadas | 40 visitas/mês |
| Conversão | % de leads convertidos | 30% de conversão |
| Reativação | Clientes reativados | 3 clientes reativados/mês |
| Mix de produtos | Receita por categoria | 40% surfaçagem, 30% tratamento, 30% montagem |
| Ticket médio | R$/pedido | R$ 2.500 por pedido |

#### 2.3.2 Campos da Meta

| Campo | Tipo |
|-------|------|
| Tipo de meta | domínio |
| Responsável | FK (usuário, equipe ou território) |
| Período | enum (Mensal, Trimestral, Semestral, Anual) |
| Data início | date |
| Data fim | date |
| Valor alvo | decimal |
| Valor realizado | decimal (calculado) |
| % atingido | decimal (calculado) |
| Meta-pai | FK meta (para desdobramento) |
| Status | enum (Em andamento, Atingida, Não atingida, Cancelada) |

#### 2.3.3 Desdobramento de Metas (Target Cascading)

```
Meta Anual da Empresa: R$ 10.000.000
├── Região Sul: R$ 4.000.000 (40%)
│   ├── Consultor A: R$ 2.000.000 (Q1: 450k, Q2: 500k, Q3: 500k, Q4: 550k)
│   ├── Consultor B: R$ 1.200.000
│   └── Consultor C: R$ 800.000
├── Região Sudeste: R$ 5.000.000 (50%)
│   └── ...
└── Inside Sales: R$ 1.000.000 (10%)
    └── ...
```

**Regra:** A soma das metas individuais pode ser >= meta do nível superior (stretch goals).

### 2.4 Rastreamento de Comissões (Commission Tracking)

#### 2.4.1 Modelos de Comissão

| Modelo | Descrição | Uso típico |
|--------|-----------|-----------|
| Percentual fixo | X% sobre todo faturamento | Mais simples |
| Percentual escalonado | % aumenta com volume | Incentiva mais vendas |
| Percentual por produto | % varia por categoria/produto | Direciona mix de vendas |
| Fixo por pedido | R$ fixo por pedido fechado | Para inside sales |
| Meta + Bônus | Comissão base + bônus ao atingir meta | Mais completo |
| Split (divisão) | Dois ou mais consultores dividem | Para contas compartilhadas |

#### 2.4.2 Tabela de Comissão (exemplo escalonado)

| Faixa de faturamento mensal | % Comissão |
|:---------------------------:|:----------:|
| Até R$ 50.000 | 2,0% |
| R$ 50.001 — R$ 100.000 | 2,5% |
| R$ 100.001 — R$ 200.000 | 3,0% |
| Acima de R$ 200.000 | 3,5% |

#### 2.4.3 Campos do Registro de Comissão

| Campo | Tipo |
|-------|------|
| Consultor | FK usuário |
| Período de referência | date (mês/ano) |
| Base de cálculo (faturamento) | decimal |
| Regra aplicada | FK tabela de comissão |
| Valor calculado | decimal |
| Ajustes manuais | decimal |
| Valor final | decimal |
| Status | enum (Calculado, Aprovado, Pago, Contestado) |
| Aprovador | FK usuário |
| Data de pagamento | date |
| Observações | text |

#### 2.4.4 Integração com ERP

A comissão depende de dados do módulo financeiro:
- Faturamento efetivo (NF emitida, não apenas pedido)
- Recebimento confirmado (opção: comissionar só após pagamento)
- Devoluções e cancelamentos (estorno de comissão)

### 2.5 Planejamento de Rotas (Route Planning)

#### 2.5.1 Funcionalidades

| Funcionalidade | Prioridade | Descrição |
|----------------|:----------:|-----------|
| Agenda de visitas no mapa | Essencial | Visualizar visitas do dia/semana no mapa |
| Ordenação manual | Essencial | Consultor define ordem de visitação |
| Distância entre pontos | Essencial | Exibir distância e tempo estimado |
| Otimização automática | Desejável | Sugerir melhor rota (TSP simplificado) |
| Navegação integrada | Desejável | Abrir rota no Google Maps/Waze |
| Comparação planejado vs realizado | Desejável | Acompanhar desvios de rota |
| Sugestão de clientes próximos | Fase posterior | "Clientes sem visita há 60 dias a 5km da sua rota" |

#### 2.5.2 Entidade Rota

| Campo | Tipo |
|-------|------|
| Data | date |
| Consultor | FK usuário |
| Ponto de partida | endereço/coordenada |
| Visitas ordenadas | FK[] visita (com sequência) |
| Distância total estimada | decimal (km) |
| Tempo total estimado | int (minutos) |
| Distância real percorrida | decimal (km) |
| Status | enum (Planejada, Em execução, Concluída) |
| Observações | text |

---

## 3. Atendimento ao Cliente dentro do CRM

### 3.1 Gestão de Tickets/Chamados (Ticket/Case Management)

#### 3.1.1 Contexto B2B Óptico

Diferente de CRMs B2C, no B2B de laboratório óptico os "tickets" geralmente tratam de:
- Reclamação de qualidade (lente com defeito, tratamento descascando)
- Atraso de entrega
- Divergência de pedido (produto errado, quantidade errada)
- Dúvida técnica sobre produto/prescrição
- Solicitação de troca/devolução
- Problema de faturamento
- Suporte a sistema (portal do cliente)

#### 3.1.2 Campos do Ticket

| Campo | Tipo | Obrigatório |
|-------|------|:-----------:|
| Número | int (auto) | Sim |
| Assunto | string | Sim |
| Descrição detalhada | text | Sim |
| Conta | FK conta | Sim |
| Contato solicitante | FK contato | Não |
| Tipo | domínio | Sim |
| Categoria | domínio | Sim (Qualidade, Entrega, Faturamento, Técnico, Sistema, Outro) |
| Subcategoria | domínio | Não |
| Prioridade | enum | Sim (Baixa, Normal, Alta, Crítica) |
| Status | enum | Sim |
| Canal de abertura | domínio | Sim (WhatsApp, Telefone, E-mail, Portal, Presencial) |
| Responsável | FK usuário | Sim |
| Equipe | FK equipe | Não |
| Pedido relacionado | FK pedido | Não |
| Produto relacionado | FK produto | Não |
| Oportunidade impactada | FK oportunidade | Não |
| SLA aplicável | FK regra SLA | Não |
| Data de abertura | datetime | Sim |
| Data prevista de resolução | datetime | Calculado (SLA) |
| Data real de resolução | datetime | Não |
| Resolução | text | Condicional (ao fechar) |
| Satisfação (CSAT) | int (1-5) | Não |
| Tags | string[] | Não |
| Anexos | file[] | Não |

#### 3.1.3 Fluxo de Status do Ticket

```
Novo → Em análise → Em andamento → Aguardando cliente → Aguardando terceiro
→ Resolvido → Fechado
         ↘ Reaberto → Em andamento → ...
```

| Status | Descrição | SLA pausa? |
|--------|-----------|:----------:|
| Novo | Acabou de ser criado | Não |
| Em análise | Sendo avaliado pela equipe | Não |
| Em andamento | Ação em progresso | Não |
| Aguardando cliente | Pendente de informação do cliente | Sim |
| Aguardando terceiro | Pendente de fornecedor/outro departamento | Configurável |
| Resolvido | Solução aplicada, aguardando confirmação do cliente | Sim |
| Fechado | Confirmado como resolvido ou auto-fechado após X dias | Sim |
| Reaberto | Cliente não concordou com a resolução | Não |
| Cancelado | Ticket inválido ou duplicado | Sim |

### 3.2 SLA (Service Level Agreement)

#### 3.2.1 Métricas de SLA

| Métrica | Definição |
|---------|-----------|
| Tempo de primeira resposta | Tempo entre criação e primeira resposta ao cliente |
| Tempo de resolução | Tempo entre criação e resolução |
| Tempo em espera | Tempo acumulado em status "Aguardando cliente" |
| Tempo de atribuição | Tempo entre criação e atribuição a um responsável |

#### 3.2.2 Regras de SLA (exemplo)

| Prioridade | Primeira Resposta | Resolução |
|------------|:-----------------:|:---------:|
| Crítica | 1 hora | 4 horas |
| Alta | 4 horas | 1 dia útil |
| Normal | 8 horas (1 dia útil) | 3 dias úteis |
| Baixa | 24 horas | 5 dias úteis |

#### 3.2.3 Configuração de SLA

| Campo | Tipo |
|-------|------|
| Nome da regra | string |
| Prioridade aplicável | enum |
| Tipo de ticket aplicável | domínio |
| Cliente aplicável | FK conta / segmento |
| Tempo de primeira resposta | int (minutos) |
| Tempo de resolução | int (minutos) |
| Horário comercial? | boolean |
| Ações de escalação | config |

#### 3.2.4 Escalação

| Nível | Tempo excedido | Ação |
|-------|:-------------:|------|
| Alerta | 75% do SLA | Notificação ao responsável |
| Escalação 1 | 100% do SLA | Notificação ao gerente + mudança de cor/badge |
| Escalação 2 | 150% do SLA | Notificação ao diretor + reatribuição automática |

### 3.3 Satisfação do Cliente (CSAT / NPS)

#### 3.3.1 CSAT (Customer Satisfaction Score)

Pesquisa enviada após resolução de ticket ou conclusão de pedido:

**Pergunta:** "De 1 a 5, como você avalia o atendimento/produto?"

| Score | Classificação | Ação |
|:-----:|:-------------|------|
| 1-2 | Insatisfeito | Alerta ao gerente, follow-up obrigatório |
| 3 | Neutro | Follow-up recomendado |
| 4-5 | Satisfeito | Registro positivo, sem ação |

**Cálculo CSAT:**
```
CSAT = (respostas 4 + respostas 5) / total de respostas * 100
```

#### 3.3.2 NPS (Net Promoter Score)

Pesquisa periódica (trimestral ou semestral):

**Pergunta:** "De 0 a 10, o quanto você recomendaria nosso laboratório?"

| Score | Classificação |
|:-----:|:-------------|
| 0-6 | Detrator |
| 7-8 | Neutro |
| 9-10 | Promotor |

**Cálculo NPS:**
```
NPS = % Promotores - % Detratores   (resultado de -100 a +100)
```

**Benchmarks B2B:**
- NPS > 50: Excelente
- NPS 30-50: Bom
- NPS 0-30: Precisa melhorar
- NPS < 0: Crítico

#### 3.3.3 Campos da Pesquisa de Satisfação

| Campo | Tipo |
|-------|------|
| Tipo | enum (CSAT, NPS) |
| Conta | FK |
| Contato respondente | FK |
| Ticket/Pedido relacionado | FK |
| Score | int |
| Comentário | text |
| Data da resposta | datetime |
| Canal | enum (E-mail, WhatsApp, Portal) |
| Ação tomada | text |

### 3.4 Base de Conhecimento (Knowledge Base)

#### 3.4.1 Uso no B2B Óptico

| Público | Conteúdo típico |
|---------|----------------|
| Interno (equipe) | Scripts de atendimento, procedimentos, FAQ técnico, tabela de compatibilidade de lentes |
| Externo (cliente) | Guia de pedidos, tabela de preços, informações de entrega, FAQ |

#### 3.4.2 Estrutura de Artigo

| Campo | Tipo |
|-------|------|
| Título | string |
| Categoria | domínio (hierárquico) |
| Conteúdo | rich text |
| Tags | string[] |
| Status | enum (Rascunho, Publicado, Arquivado) |
| Visibilidade | enum (Interno, Público, Clientes) |
| Autor | FK usuário |
| Data de publicação | datetime |
| Última revisão | datetime |
| Visualizações | int |
| Útil? (feedback) | int sim / int não |
| Artigos relacionados | FK[] artigo |
| Anexos | file[] |

#### 3.4.3 Integração com Tickets

- Ao criar/resolver ticket, sugerir artigos relacionados
- Permitir vincular artigo à resolução de um ticket
- Se a mesma dúvida aparece > N vezes, sugerir criação de artigo

---

## 4. Relatórios e Analytics

### 4.1 Relatórios Padrão de CRM

#### 4.1.1 Relatórios de Pipeline

| Relatório | Descrição | Frequência típica |
|-----------|-----------|:-----------------:|
| Pipeline por etapa | Quantidade e valor por etapa do funil | Diário |
| Pipeline por consultor | Valor e quantidade por vendedor | Semanal |
| Pipeline por território | Distribuição geográfica de oportunidades | Semanal |
| Aging de oportunidades | Tempo médio em cada etapa | Semanal |
| Oportunidades estagnadas | Oportunidades sem atividade > X dias | Diário |
| Pipeline trend | Evolução do pipeline ao longo do tempo | Mensal |

#### 4.1.2 Relatórios de Conversão

| Relatório | Descrição |
|-----------|-----------|
| Funil de conversão completo | Lead → Qualificado → Oportunidade → Proposta → Fechado |
| Taxa de conversão por etapa | % que avança entre cada etapa |
| Taxa de conversão por consultor | Comparativo de performance |
| Taxa de conversão por origem | Quais fontes de lead convertem melhor |
| Taxa de conversão por segmento | Quais segmentos têm melhor conversão |
| Tempo médio de conversão por etapa | Onde o processo "trava" |
| Lead-to-close time | Tempo total do ciclo de vendas |

#### 4.1.3 Relatórios de Atividade

| Relatório | Descrição |
|-----------|-----------|
| Atividades por consultor | Volume de ligações, visitas, emails |
| Atividades por tipo | Distribuição entre canais de contato |
| Taxa de execução de visitas | Visitas realizadas / planejadas |
| Produtividade por hora/dia | Distribuição temporal de atividades |
| Clientes sem interação | Há quantos dias sem contato |
| Ranking de atividades | Top consultores por volume de atividades |
| Efetividade de atividades | Atividades que resultaram em avanço de oportunidade |

### 4.2 Métodos de Forecast (Sales Forecasting)

#### 4.2.1 Comparativo de Métodos

| Método | Precisão | Esforço | Quando usar |
|--------|:--------:|:-------:|------------|
| **Pipeline Stage** | Média | Baixo | Default, pipeline maduro |
| **Forecast Category** (manual) | Média-Alta | Médio | Ajuste pelo consultor |
| **Histórico + Sazonalidade** | Alta | Baixo (automático) | Com 12+ meses de dados |
| **Weighted Pipeline** | Média | Baixo | Múltiplas oportunidades |
| **AI/ML Predictive** | Alta | Alto (setup) | Datasets grandes, fase avançada |

#### 4.2.2 Forecast por Pipeline Stage (detalhado)

```
Para cada oportunidade aberta:
  valor_ponderado = valor * probabilidade_da_etapa
  
Forecast do período = SUM(valor_ponderado) para oportunidades com data_prevista_fechamento no período
```

**Limitações:** assume probabilidade uniforme por etapa (consultor bom e ruim na mesma etapa = mesma probabilidade).

#### 4.2.3 Forecast por Categoria + Ajuste

```
Consultor classifica cada oportunidade:
  - Commit: 90% confiança
  - Best Case: 60% confiança  
  - Pipeline: 20% confiança
  - Upside: 10% confiança

Gerente pode ajustar em +/- X%

Forecast = SUM(valor * confiança_categoria) +/- ajuste_gerencial
```

#### 4.2.4 Forecast Histórico

```
Base: faturamento dos últimos 12-24 meses
Aplicar:
  - Média móvel (simples ou ponderada)
  - Sazonalidade (% de cada mês sobre o total anual)
  - Tendência (crescimento ou declínio YoY)
  
Forecast_mês = média_mensal * fator_sazonalidade * fator_tendência
```

#### 4.2.5 Acurácia de Forecast

```
Forecast Accuracy = 1 - |forecast - realizado| / realizado

Exemplo:
  Previsto: R$ 120.000
  Realizado: R$ 100.000
  Accuracy = 1 - |120k - 100k| / 100k = 1 - 0.20 = 80%
```

**Meta de acurácia saudável:** > 80% (benchmark de mercado: 70-85%)

### 4.3 Análise de Ganhos e Perdas (Win/Loss Analysis)

#### 4.3.1 Dimensões de Análise

| Dimensão | Perguntas que responde |
|----------|----------------------|
| Por motivo de perda | Qual a principal razão? Preço? Produto? Atendimento? |
| Por concorrente | Para quem estamos perdendo? |
| Por consultor | Algum consultor perde significativamente mais? |
| Por segmento | Em qual segmento perdemos mais? |
| Por valor | Perdemos mais negócios grandes ou pequenos? |
| Por território | Alguma região tem taxa de perda maior? |
| Por etapa de perda | Em qual momento do funil perdemos? |
| Por tempo no pipeline | Oportunidades que ficam muito tempo convertem menos? |
| Por origem do lead | Leads de quais fontes convertem melhor/pior? |

#### 4.3.2 Relatórios de Win/Loss

| Relatório | Visualização |
|-----------|-------------|
| Win rate geral | Card + trend line |
| Win rate por consultor | Barra horizontal comparativa |
| Top motivos de perda | Pareto chart (80/20) |
| Concorrentes mais mencionados | Barra horizontal |
| Valor perdido por motivo | Treemap |
| Win rate por etapa de origem | Funil com taxas |
| Correlação tamanho x win rate | Scatter plot |
| Tempo médio: ganhos vs perdidos | Box plot comparativo |

#### 4.3.3 Ações Baseadas em Win/Loss

| Insight | Ação sugerida |
|---------|--------------|
| Perda por preço > 40% | Revisar posicionamento / criar argumentário de valor |
| Win rate < 20% em segmento X | Reavaliar se é target-market viável |
| Consultor Y com win rate muito abaixo | Coaching / acompanhamento / treinamento |
| Perda concentrada na etapa "Proposta" | Revisar qualidade das propostas / processo de follow-up |
| Concorrente Z ganhando 60% dos deals | Análise competitiva profunda / diferenciação |

---

## 5. Pontos de Integração com ERP

### 5.1 Visão Geral da Integração CRM ↔ ERP

```
┌─────────────────────────────────────────────────────────────────┐
│                        CRM (Módulo Novo)                        │
│                                                                 │
│  Leads → Oportunidades → Propostas → [INTEGRAÇÃO] → Pedidos    │
│  Contas ←──────────────────────────────────────────→ Clientes   │
│  Produtos de interesse ←───────────────────────────→ Produtos   │
│  Faturamento ←─────────────────────────────────────→ Financeiro │
│  Tickets ←─────────────────────────────────────────→ Produção   │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 CRM → Pedidos de Venda (Sales Orders)

#### 5.2.1 Fluxo de Conversão

```
Oportunidade (CRM) → Proposta Aceita (CRM) → Pedido de Venda (ERP Vendas)
```

**Dados transferidos:**
- Cliente (conta) → FK do cliente no módulo de vendas
- Contato → contato de referência do pedido
- Itens da proposta → itens do pedido (produto, quantidade, preço, desconto)
- Condição de pagamento → condição do pedido
- Consultor → vendedor do pedido (para comissão)
- Oportunidade → referência para rastreabilidade

**Regras:**
- A conversão pode ser automática (oportunidade marcada como "ganha") ou manual (botão "Gerar Pedido")
- Após gerar pedido, a oportunidade recebe status "Convertida em Pedido" com FK do pedido
- Ajustes no pedido após conversão NÃO retroagem para a proposta/oportunidade

#### 5.2.2 Sincronização Bidirecional de Status

| Evento no ERP | Reflexo no CRM |
|---------------|---------------|
| Pedido confirmado | Oportunidade → "Pedido Confirmado" |
| Pedido faturado (NF emitida) | Oportunidade → "Faturado" / Timeline entry |
| Pedido cancelado | Alerta ao consultor, oportunidade pode ser reaberta |
| Devolução/Troca | Ticket automático ou alerta |

### 5.3 CRM ↔ Cadastro de Clientes (Customer Master Data)

#### 5.3.1 Fonte Única de Verdade (Single Source of Truth)

**Decisão arquitetural crítica:** O cadastro de clientes deve ter UMA fonte de verdade. Opções:

| Opção | Prós | Contras | Recomendação |
|-------|------|---------|:------------:|
| **A: Entidade única compartilhada** | Sem duplicidade, simples | CRM e ERP acoplados | **Recomendado para OpticalCore** |
| B: Cadastro duplicado com sync | Módulos independentes | Complexidade de sincronização | Não recomendado |
| C: Módulo de cadastro centralizado (MDM) | Mais escalável | Overengineering para o contexto | Talvez no futuro |

**Recomendação para OpticalCore:** O cadastro de clientes (`Pessoa` / `Cliente`) já existe no ERP. O CRM deve **estender** essa entidade com campos comerciais (owner, território, classificação, potencial, etc.) sem duplicar o cadastro base.

#### 5.3.2 Campos do ERP vs Campos do CRM

| Módulo | Campos que gerencia |
|--------|-------------------|
| **ERP (cadastro base)** | Razão Social, CNPJ, IE, Endereços, Contatos, Tipo de Pessoa, Status fiscal |
| **CRM (extensão comercial)** | Owner (consultor), Território, Classificação ABC, Potencial, Score, Tags comerciais, Última interação, Pipeline info, Segmento comercial |
| **Financeiro (extensão)** | Limite de crédito, Saldo devedor, Pontualidade, Condição padrão |

### 5.4 CRM ↔ Catálogo de Produtos (Product Catalog)

#### 5.4.1 Uso do Catálogo no CRM

O CRM consome o catálogo de produtos do ERP para:
- Vincular produtos às oportunidades ("O cliente tem interesse em surfaçagem digital")
- Montar propostas/cotações com itens reais
- Analisar mix de vendas por cliente/território
- Sugerir cross-sell ("Clientes de surfaçagem que também usam tratamento")

#### 5.4.2 Dados do Produto necessários no CRM

| Campo | Fonte | Uso no CRM |
|-------|-------|-----------|
| Código | Estoque/Produto | Identificação |
| Nome | Estoque/Produto | Exibição |
| Categoria | Estoque/Produto | Segmentação |
| Preço de lista | Vendas/Tabela | Propostas |
| Estoque disponível | Estoque | Viabilidade |
| Ativo/Inativo | Estoque/Produto | Filtro |
| Imagem | Estoque/Produto | Visual |
| Descrição | Estoque/Produto | Proposta |

#### 5.4.3 Tabelas de Preço no CRM

O CRM precisa respeitar as tabelas de preço do módulo de vendas:
- Preço de lista (referência)
- Preço especial por cliente/grupo
- Descontos permitidos por consultor (faixa máxima)
- Descontos que requerem aprovação gerencial

### 5.5 CRM ↔ Faturamento e Financeiro

#### 5.5.1 Dados do Financeiro no CRM

| Dado | Uso no CRM |
|------|-----------|
| Faturamento mensal/anual por cliente | Classificação ABC, KPIs, metas |
| Saldo devedor | Alerta ao consultor, bloqueio de proposta |
| Pontualidade de pagamento | Classificação do cliente |
| Histórico de NFs | Timeline do cliente |
| Comissões devidas | Módulo de comissão |
| Crédito disponível | Validação de proposta |

#### 5.5.2 Alertas Financeiros no CRM

| Alerta | Trigger | Destinatário |
|--------|---------|-------------|
| Cliente inadimplente | Título vencido > X dias | Consultor + Gerente |
| Limite de crédito excedido | Saldo > Limite | Consultor |
| Queda de faturamento | Faturamento < 70% da média dos últimos 3 meses | Consultor |
| Primeira compra | Primeiro pedido faturado | Consultor (parabenizar) |
| Cliente reativado | Pedido após 90+ dias sem compra | Consultor |

### 5.6 CRM ↔ Estoque

#### 5.6.1 Dados do Estoque no CRM

| Dado | Uso no CRM |
|------|-----------|
| Disponibilidade do produto | Validar proposta antes de enviar |
| Previsão de chegada | Informar cliente sobre prazo |
| Produtos novos | Campanha de divulgação |
| Produtos em promoção | Oportunidade de venda |

### 5.7 CRM ↔ Produção (específico para laboratório óptico)

#### 5.7.1 Dados da Produção no CRM

| Dado | Uso no CRM |
|------|-----------|
| Status do pedido na produção | Informar cliente proativamente |
| Prazo de entrega realizado | SLA do cliente, CSAT |
| Reclamações de qualidade | Ticket/caso no CRM |
| Capacidade produtiva | Limitar promessas de prazo |

### 5.8 CRM ↔ iChat / WhatsApp

#### 5.8.1 Integração com Comunicação

| Funcionalidade | Direção |
|----------------|---------|
| Mensagens WhatsApp na timeline do cliente | iChat → CRM |
| Abrir conversa WhatsApp a partir do CRM | CRM → iChat |
| Criar lead a partir de mensagem WhatsApp | iChat → CRM |
| Notificar consultor via WhatsApp sobre atividade | CRM → iChat |
| Enviar proposta via WhatsApp | CRM → iChat |
| Registrar mensagem como atividade | iChat → CRM |

---

## 6. Comparativo entre Plataformas Líderes

### 6.1 Matriz de Funcionalidades

| Funcionalidade | Salesforce | HubSpot | Pipedrive | Zoho CRM | Dynamics 365 | Freshsales |
|----------------|:----------:|:-------:|:---------:|:--------:|:------------:|:----------:|
| **Contas/Contatos** | Completo | Completo | Básico | Completo | Completo | Completo |
| **Hierarquia de contas** | Sim | Limitado | Não | Sim | Sim | Limitado |
| **Lead Management** | Completo | Completo | Parcial* | Completo | Completo | Completo |
| **Lead Scoring** | Avançado (Einstein) | Preditivo | Não nativo | Sim (Zia) | Sim (AI) | Sim (Freddy) |
| **Pipeline/Deals** | Multi-pipeline | Multi-pipeline | Excelente (core) | Multi-pipeline | Multi-pipeline | Multi-pipeline |
| **Atividades** | Completo | Completo | Bom | Completo | Completo | Bom |
| **Timeline** | Excelente | Excelente | Boa | Boa | Excelente | Boa |
| **Forecast** | 3 métodos | Automático | Básico | Sim | Avançado | Sim |
| **Cotações/Propostas** | CPQ nativo | Quotes | Limitado (addon) | Quotes | Quotes | Limitado |
| **Territórios** | Enterprise Tier | Não nativo | Não | Sim | Sim | Não |
| **Equipes de Vendas** | Sim | Sim | Sim | Sim | Sim | Sim |
| **Metas/Targets** | Sim | Sim | Básico | Sim | Sim | Sim |
| **Comissões** | Spiff/addon | Addon | Addon | Não nativo | Não nativo | Não nativo |
| **Automação** | Flow Builder | Workflows | Automações | Blueprint | Power Automate | Workflows |
| **Tickets/Cases** | Service Cloud | Service Hub | Não | Desk integration | Customer Service | Freshdesk |
| **SLA** | Sim | Sim | Não | Sim | Sim | Sim (Freshdesk) |
| **CSAT/NPS** | Sim | Sim | Não | Sim | Customer Voice | Sim |
| **Knowledge Base** | Sim | Sim | Não | Sim | Sim | Sim |
| **Mapas/Geo** | Maps addon | Não nativo | Não | Sim (básico) | Sim (Power BI) | Não |
| **Despesas** | Addon | Não | Não | Zoho Expense | Expense module | Não |
| **Custom Fields** | Ilimitado | Sim | Sim | Sim | Sim | Sim |
| **Tags** | Tags | Sim | Labels | Tags | Tags | Tags |
| **API** | REST + SOAP | REST | REST | REST | REST + OData | REST |
| **Mobile** | Nativo | Nativo | Excelente | Nativo | Nativo | Nativo |
| **AI/ML** | Einstein | Breeze AI | AI (beta) | Zia | Copilot | Freddy AI |
| **Preço (por usuário/mês)** | $25-$500 | Free-$150 | $14-$99 | $14-$65 | $65-$162 | $9-$59 |

`*` Pipedrive trata leads e deals de forma unificada por design.

### 6.2 Destaques por Plataforma

#### Salesforce
- **Referência de mercado** para CRM enterprise
- **CPQ** (Configure, Price, Quote) mais maduro
- **Einstein AI** para scoring preditivo e recomendações
- **Territory Management** nativo (Enterprise+)
- **Mais caro** e mais complexo de implementar
- **App ecosystem** (AppExchange) incomparável

#### HubSpot
- **Melhor UX** — interface mais intuitiva
- **CRM gratuito** funcional para equipes pequenas
- **Marketing + Sales + Service** integrados nativamente
- **Sequences** (cadências de prospecção) excelentes
- **Deal pipeline** visual e simples
- **Limitações** em hierarquia de contas e territórios

#### Pipedrive
- **Pipeline-first** — desenhado em torno do funil visual
- **Mais simples** de todos — setup em minutos
- **Mobile excelente** para equipes de campo
- **Automações** poderosas para o tamanho
- **Limitações** em reporting avançado, tickets, territórios
- **Melhor custo-benefício** para equipes pequenas/médias

#### Zoho CRM
- **Mais completo no custo** — muitas features incluídas
- **Zia AI** para scoring e sugestões
- **Blueprint** para automação de processos
- **Integração nativa** com Zoho Suite (Expense, Desk, etc.)
- **Canvas** para personalização visual de telas
- **Desafio:** interface menos polida que HubSpot/Pipedrive

#### Microsoft Dynamics 365
- **Integração Microsoft** (Office 365, Teams, Power BI, Power Automate)
- **Customer Insights** para segmentação avançada
- **Copilot AI** integrado
- **ERP + CRM** no mesmo ecossistema (Finance, Supply Chain)
- **Mais adequado** para empresas já no ecossistema Microsoft
- **Curva de aprendizado** alta

#### Freshsales (Freshworks)
- **Freddy AI** para scoring e next-best-action
- **Preço agressivo** para funcionalidades oferecidas
- **Built-in phone** e email
- **Freshdesk integration** para tickets
- **Menos maduro** em territórios, comissões, forecast avançado
- **Bom para** equipes que querem CRM + helpdesk integrado

### 6.3 Lições-Chave para o OpticalCore

1. **Pipeline visual** é core — todos os CRMs convergem nisso (inspiração: Pipedrive + HubSpot)
2. **Lead scoring** diferencia CRMs modernos — Salesforce Einstein, HubSpot Predictive, Zoho Zia
3. **Timeline unificada** é obrigatória — sem exceção entre as plataformas
4. **Automação de workflow** é o que gera valor real — triggers + ações = menos trabalho manual
5. **Territórios e comissões** são geralmente addons ou tiers premium — construir nativamente é diferencial
6. **Tickets/atendimento** são parte do CRM moderno — não módulo separado
7. **Custom fields** são essenciais para B2B — cada negócio tem campos específicos
8. **Mobile-first** para equipe de campo — performance importa mais que features
9. **AI/Scoring** é tendência irreversível — planejar para fase posterior
10. **Integração ERP nativa** é o maior diferencial de construir CRM dentro do ERP vs CRM standalone

---

## 7. Classificação: Essencial vs Desejável

### 7.1 Funcionalidades Essenciais (MVP / Fase 1)

Estas funcionalidades são obrigatórias para um CRM B2B funcional:

| # | Funcionalidade | Justificativa |
|---|---------------|--------------|
| 1 | Gestão de Contas (empresas) | Base de tudo — cadastro de clientes |
| 2 | Gestão de Contatos | Saber com quem falar em cada empresa |
| 3 | Gestão de Leads | Capturar e qualificar oportunidades |
| 4 | Conversão de Lead | Lead → Conta + Contato + Oportunidade |
| 5 | Pipeline de Oportunidades | Visualizar e gerenciar funil de vendas |
| 6 | Múltiplas etapas configuráveis | Cada processo comercial é diferente |
| 7 | Atividades (tarefa, ligação, nota) | Registrar e planejar interações |
| 8 | Timeline do cliente | Visão cronológica completa |
| 9 | Visitas de campo | Core do B2B de laboratório óptico |
| 10 | Check-in/check-out com geo | Validação de presença |
| 11 | Despesas por visita | Controle financeiro de campo |
| 12 | Upload de foto de recibo | Comprovação de gastos |
| 13 | Aprovação de despesas | Workflow gerencial |
| 14 | Mapa de clientes | Visualização geográfica |
| 15 | Territórios | Organização comercial |
| 16 | Atribuição de consultor por território | Governança de carteira |
| 17 | Propostas/Cotações básicas | Documentar ofertas |
| 18 | Motivo de perda | Análise de perdas |
| 19 | Forecast por etapa (automático) | Previsão mínima |
| 20 | Dashboard básico (pipeline, atividades, metas) | Visibilidade |
| 21 | Relatórios essenciais (funil, conversão, atividades) | Gestão |
| 22 | RBAC + escopo de dados | Segurança e privacidade |
| 23 | Auditoria de alterações críticas | Compliance |
| 24 | Integração com cadastro de clientes do ERP | Fonte única de verdade |
| 25 | Integração com catálogo de produtos | Propostas com itens reais |
| 26 | Tags | Classificação flexível |
| 27 | Notas e anexos | Documentação |
| 28 | Busca global | Encontrar qualquer coisa rápido |

### 7.2 Funcionalidades Desejáveis (Fase 2)

| # | Funcionalidade | Justificativa |
|---|---------------|--------------|
| 1 | Lead scoring (manual/regras) | Priorização de esforço |
| 2 | Múltiplos pipelines | Processos diferentes |
| 3 | Forecast por categoria (commit/best case) | Previsão mais precisa |
| 4 | Equipes de vendas | Organização por time |
| 5 | Metas e desdobramento | Acompanhar performance |
| 6 | Tickets/chamados | Atendimento pós-venda |
| 7 | SLA de atendimento | Nível de serviço |
| 8 | CSAT pós-ticket | Medir satisfação |
| 9 | Classificação ABC automática | Segmentação inteligente |
| 10 | Segmentação RFM | Análise comportamental |
| 11 | Automação de workflows (triggers) | Menos trabalho manual |
| 12 | Templates de e-mail/proposta | Padronização |
| 13 | Versionamento de propostas | Histórico de negociação |
| 14 | Conversão proposta → pedido de venda | Integração ERP |
| 15 | Comissões (cálculo básico) | Remuneração variável |
| 16 | Alertas financeiros no CRM | Inadimplência, crédito |
| 17 | Campos personalizados | Flexibilidade |
| 18 | Win/Loss analysis | Inteligência competitiva |
| 19 | Planejamento de rotas | Eficiência de campo |
| 20 | Integração WhatsApp/iChat na timeline | Comunicação unificada |
| 21 | NPS periódico | Voz do cliente |
| 22 | Base de conhecimento | Autoatendimento |
| 23 | Relatórios avançados | BI operacional |

### 7.3 Funcionalidades Futuras (Fase 3+)

| # | Funcionalidade | Justificativa |
|---|---------------|--------------|
| 1 | Lead scoring preditivo (ML) | Automação inteligente |
| 2 | Forecast histórico + sazonalidade | Previsão precisa |
| 3 | OCR de recibos | Redução de digitação |
| 4 | Otimização de rotas (TSP) | Logística eficiente |
| 5 | Heatmap de clientes/receita | Inteligência geográfica |
| 6 | Portal do cliente | Autoatendimento |
| 7 | Comissões avançadas (escalonado, split) | Modelos complexos |
| 8 | Email marketing integrado | Campanhas |
| 9 | Chatbot para qualificação de leads | Automação de entrada |
| 10 | Dashboard executivo com drill-down | BI avançado |
| 11 | Integração com BI externo | Power BI, Metabase |
| 12 | Gamificação de vendas | Engajamento da equipe |
| 13 | Social selling | Prospecção via redes sociais |
| 14 | Document AI para propostas | Geração automática |

---

## 8. Modelo de Dados Expandido

### 8.1 Diagrama de Entidades (ER simplificado)

```
┌─────────────┐     ┌──────────────┐     ┌──────────────────┐
│  Territorio │     │  EquipeVenda │     │  Meta            │
│             │◄───►│              │◄───►│                  │
└──────┬──────┘     └──────┬───────┘     └──────────────────┘
       │                   │
       │    ┌──────────────┤
       │    │              │
       ▼    ▼              ▼
┌──────────────┐    ┌──────────────┐
│   Conta      │    │   Usuario    │
│  (Cliente)   │◄──►│ (Consultor)  │
└──────┬───────┘    └──────┬───────┘
       │                   │
       ├───────────────────┤
       │                   │
       ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│   Contato    │    │   Lead       │───►│ Conversão        │
│              │    │              │    │ (Lead→Conta+Opp) │
└──────────────┘    └──────────────┘    └──────────────────┘
       │
       ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│ Oportunidade │───►│   Proposta   │───►│  ItemProposta    │
│              │    │              │    │                  │
└──────┬───────┘    └──────────────┘    └──────────────────┘
       │                                        │
       │                                        ▼
       │                                ┌──────────────────┐
       │                                │ Produto (ERP)    │
       │                                └──────────────────┘
       │
       ├──────────────────────────────────┐
       │                                  │
       ▼                                  ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│  Atividade   │    │   Visita     │───►│    Despesa       │
│              │    │              │    │                  │
└──────────────┘    └──────────────┘    └──────┬───────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│    Nota      │    │   Rota       │    │  Comprovante     │
│              │    │              │    │                  │
└──────────────┘    └──────────────┘    └──────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│   Ticket     │    │ PesquisaSat  │    │   Artigo KB      │
│              │    │ (CSAT/NPS)   │    │                  │
└──────────────┘    └──────────────┘    └──────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│  Comissao    │    │   Tag        │    │ CampoPersonaliz  │
│              │    │              │    │                  │
└──────────────┘    └──────────────┘    └──────────────────┘

┌──────────────┐    ┌──────────────┐
│  Pipeline    │───►│ EtapaPipeline│
│              │    │              │
└──────────────┘    └──────────────┘

┌──────────────┐    ┌──────────────┐
│ Automacao    │    │  Auditoria   │
│ (WorkflowRule│    │              │
└──────────────┘    └──────────────┘
```

### 8.2 Entidades Totais do Módulo CRM

| # | Entidade | Categoria | Fase |
|---|----------|-----------|:----:|
| 1 | Conta (extensão de Cliente ERP) | Core CRM | 1 |
| 2 | Contato | Core CRM | 1 |
| 3 | Lead | Core CRM | 1 |
| 4 | Oportunidade | Core CRM | 1 |
| 5 | Pipeline | Core CRM | 1 |
| 6 | EtapaPipeline | Core CRM | 1 |
| 7 | Atividade | Core CRM | 1 |
| 8 | Nota | Core CRM | 1 |
| 9 | Anexo | Core CRM | 1 |
| 10 | Tag | Core CRM | 1 |
| 11 | TagEntidade (N:N polimórfico) | Core CRM | 1 |
| 12 | TimelineEntry | Core CRM | 1 |
| 13 | Visita | Campo | 1 |
| 14 | Despesa | Campo | 1 |
| 15 | ComprovanteDespesa | Campo | 1 |
| 16 | CategoriaDespesa | Campo | 1 |
| 17 | RelatorioDespesa | Campo | 1 |
| 18 | Territorio | Territórios | 1 |
| 19 | AtribuicaoTerritorial | Territórios | 1 |
| 20 | Proposta | Vendas | 1 |
| 21 | ItemProposta | Vendas | 1 |
| 22 | MotivoPerda | Config | 1 |
| 23 | OrigemLead | Config | 1 |
| 24 | SegmentoCliente | Config | 1 |
| 25 | EquipeVenda | SFA | 2 |
| 26 | MembroEquipe | SFA | 2 |
| 27 | Meta | SFA | 2 |
| 28 | MetaSnapshot (realizado) | SFA | 2 |
| 29 | Comissao | SFA | 2 |
| 30 | TabelaComissao | SFA | 2 |
| 31 | FaixaComissao | SFA | 2 |
| 32 | Rota | Campo | 2 |
| 33 | RotaVisita (N:N com ordem) | Campo | 2 |
| 34 | Ticket | Atendimento | 2 |
| 35 | SLARegra | Atendimento | 2 |
| 36 | PesquisaSatisfacao | Atendimento | 2 |
| 37 | ArtigoKB | Atendimento | 2 |
| 38 | CategoriaArtigoKB | Atendimento | 2 |
| 39 | CampoPersonalizado | Config | 2 |
| 40 | ValorCampoPersonalizado | Config | 2 |
| 41 | RegraLeadScoring | Config | 2 |
| 42 | AutomacaoRegra | Workflow | 2 |
| 43 | AutomacaoAcao | Workflow | 2 |
| 44 | AutomacaoLog | Workflow | 2 |
| 45 | ClassificacaoABC | Analytics | 2 |
| 46 | ForecastSnapshot | Analytics | 2 |
| 47 | Campanha | Marketing | 3 |
| 48 | CampanhaDestinatario | Marketing | 3 |

### 8.3 Tabelas de Domínio do CRM

| Domínio | Exemplos de valores |
|---------|-------------------|
| TipoAtividade | Ligação, E-mail, Reunião, Visita, Tarefa, Nota |
| StatusLead | Novo, Contatado, Qualificado, Desqualificado, Convertido |
| OrigemLead | Feira, Site, Indicação, Prospecção, WhatsApp, Parceiro |
| MotivoDesqualificacao | Fora do perfil, Sem interesse, Concorrente, Sem orçamento |
| MotivoPerda | Preço, Prazo, Qualidade, Relacionamento, Outro |
| SegmentoCliente | Ótica, Clínica, Hospital, Rede, Distribuidor |
| PorteEmpresa | MEI, ME, EPP, Médio, Grande |
| ClassificacaoCliente | A, B, C, D |
| TipoVisita | Prospecção, Manutenção, Negociação, Pós-venda, Cobrança |
| StatusVisita | Planejada, Em andamento, Concluída, Cancelada |
| CategoriaDespesa | Combustível, Pedágio, Alimentação, Hotel, Transporte, Outro |
| StatusDespesa | Rascunho, Enviado, Aprovado, Rejeitado, Reembolsado |
| TipoTicket | Qualidade, Entrega, Faturamento, Técnico, Sistema |
| PrioridadeTicket | Baixa, Normal, Alta, Crítica |
| StatusTicket | Novo, Em análise, Em andamento, Aguardando, Resolvido, Fechado |
| CanalContato | Telefone, E-mail, WhatsApp, Presencial, Portal |
| TipoMeta | Receita, Quantidade, Novos clientes, Visitas, Conversão |
| PeriodoMeta | Mensal, Trimestral, Semestral, Anual |
| CategoriaForecast | Pipeline, Best Case, Commit, Closed, Omitted |
| TipoProposta | Nova, Renovação, Upsell |
| StatusProposta | Rascunho, Em revisão, Enviada, Aceita, Rejeitada, Expirada |

---

## 9. Referências

### 9.1 Plataformas de CRM analisadas

| Plataforma | URL principal |
|------------|--------------|
| Salesforce Sales Cloud | https://www.salesforce.com/sales/ |
| Salesforce Service Cloud | https://www.salesforce.com/service/ |
| HubSpot CRM | https://www.hubspot.com/products/crm |
| HubSpot Sales Hub | https://www.hubspot.com/products/sales |
| HubSpot Service Hub | https://www.hubspot.com/products/service |
| Pipedrive | https://www.pipedrive.com/ |
| Zoho CRM | https://www.zoho.com/crm/ |
| Zoho Desk | https://www.zoho.com/desk/ |
| Zoho Expense | https://www.zoho.com/expense/ |
| Microsoft Dynamics 365 Sales | https://dynamics.microsoft.com/sales/ |
| Microsoft Dynamics 365 Customer Service | https://dynamics.microsoft.com/customer-service/ |
| Freshsales (Freshworks) | https://www.freshworks.com/crm/sales/ |
| Freshdesk (Freshworks) | https://www.freshworks.com/freshdesk/ |

### 9.2 Conceitos e best practices

| Conceito | Fonte de referência |
|----------|-------------------|
| Lead Scoring | Salesforce Einstein Lead Scoring, HubSpot Predictive Lead Scoring |
| Pipeline Management | Pipedrive best practices, HubSpot Deal Pipeline |
| Sales Forecasting | Salesforce Collaborative Forecasting, Gartner Research |
| Win/Loss Analysis | Clozd, Salesforce Reports, HubSpot Analytics |
| Territory Management | Salesforce Enterprise Territory Management, Dynamics 365 |
| Commission Tracking | Spiff, CaptivateIQ, Xactly (integrações Salesforce) |
| CSAT/NPS | Qualtrics, SurveyMonkey, Freshworks Customer Satisfaction |
| SLA Management | Freshdesk SLA, Zendesk SLA, Dynamics 365 SLA |
| RFM Analysis | Conceito clássico de marketing (Bult & Wansbeek, 1995) |
| ABC Classification | Análise de Pareto (Vilfredo Pareto, 1896) |
| BANT Qualification | IBM, amplamente adotado |
| MEDDIC/MEDDPICC | Salesforce, PTC (metodologia enterprise) |

### 9.3 Documentação complementar (projeto OpticalCore)

| Documento | Path |
|-----------|------|
| Estudo CRM inicial | `docs/modulo_crm/estudo_crm.md` |
| Plano ERP completo | `docs/PLANO-ERP-GENERICO.md` |
| Arquitetura multi-tenant | `docs/MULTI_TENANT_ARCHITECTURE.md` |
| Módulo de Vendas | `docs/modulo_vendas/` |
| Módulo de Estoque | `docs/modulo_estoque/` |
| Módulo Financeiro | `docs/modulo_financeiro/` |
| Módulo de Produção | `docs/modulo_producao/` |
| iChat/WhatsApp | `docs/modulo_chat/` |

---

*Este documento complementa o `estudo_crm.md` e juntos formam a base completa de requisitos para o módulo CRM do OpticalCore ERP.*
