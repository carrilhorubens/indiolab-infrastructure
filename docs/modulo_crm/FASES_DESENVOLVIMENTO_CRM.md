# Fases de Desenvolvimento - Modulo CRM

> Plano completo de desenvolvimento do modulo CRM para o OpticalCore ERP.
> Baseado nos documentos de pesquisa em `/docs/modulo_crm/`.
> Data: 2026-03-31

---

## Estrutura do Menu CRM

O modulo CRM sera um menu de primeiro nivel no Sidebar, seguindo o padrao existente (`/vendas/*`, `/estoque/*`, `/financeiro/*`).

### Menu Sidebar

```
CRM
├── Dashboard CRM           /crm/dashboard
├── Contatos                /crm/contatos
├── Leads                   /crm/leads
├── Oportunidades           /crm/oportunidades
├── Pipeline                /crm/pipeline           (Kanban visual)
├── Atividades              /crm/atividades
├── Visitas                 /crm/visitas
├── Despesas de Viagem      /crm/despesas
├── Mapa de Clientes        /crm/mapa
├── Territorios             /crm/territorios
├── Campanhas               /crm/campanhas
├── Comodatos               /crm/comodatos          (equipamentos emprestados)
└── Relatorios CRM          /crm/relatorios
    ├── Funil de Vendas     /crm/relatorios/funil
    ├── Performance Equipe  /crm/relatorios/performance
    ├── Despesas por Rep    /crm/relatorios/despesas
    ├── Cobertura Mapa      /crm/relatorios/cobertura
    └── Forecast            /crm/relatorios/forecast
```

### Icone do Menu

```typescript
// Sidebar.tsx
import { Handshake } from '@mui/icons-material'; // ou ContactPhone, Hub

// NavItem
{ label: 'CRM', icon: <Handshake />, permission: Permissions.CRM.View, children: [...] }
```

### routeTitles (MainLayout.tsx)

```typescript
'/crm/dashboard':      { title: 'Dashboard CRM',      subtitle: 'Visao geral de vendas e relacionamento',    icon: <Dashboard />,     iconBg: '#7C3AED' },
'/crm/contatos':       { title: 'Contatos',            subtitle: 'Gerencie contatos de clientes e prospects', icon: <ContactPhone />,  iconBg: '#7C3AED' },
'/crm/leads':          { title: 'Leads',               subtitle: 'Capture e qualifique oportunidades',        icon: <PersonAdd />,     iconBg: '#7C3AED' },
'/crm/oportunidades':  { title: 'Oportunidades',       subtitle: 'Gerencie o pipeline de vendas',             icon: <TrendingUp />,    iconBg: '#7C3AED' },
'/crm/pipeline':       { title: 'Pipeline',            subtitle: 'Visualizacao Kanban do funil de vendas',    icon: <ViewKanban />,    iconBg: '#7C3AED' },
'/crm/atividades':     { title: 'Atividades',          subtitle: 'Chamadas, reunioes, tarefas e follow-ups',  icon: <EventNote />,     iconBg: '#7C3AED' },
'/crm/visitas':        { title: 'Visitas',             subtitle: 'Registro de visitas a clientes',            icon: <LocationOn />,    iconBg: '#7C3AED' },
'/crm/despesas':       { title: 'Despesas de Viagem',  subtitle: 'Relatorios de despesas e reembolsos',       icon: <Receipt />,       iconBg: '#7C3AED' },
'/crm/mapa':           { title: 'Mapa de Clientes',    subtitle: 'Visualize clientes e territorios no mapa',  icon: <Map />,           iconBg: '#7C3AED' },
'/crm/territorios':    { title: 'Territorios',         subtitle: 'Gerencie areas e regioes de vendas',        icon: <MapOutlined />,   iconBg: '#7C3AED' },
'/crm/campanhas':      { title: 'Campanhas',           subtitle: 'Campanhas de vendas e promocoes',           icon: <Campaign />,      iconBg: '#7C3AED' },
'/crm/comodatos':      { title: 'Comodatos',           subtitle: 'Equipamentos emprestados a clientes',       icon: <Precision ... />, iconBg: '#7C3AED' },
'/crm/relatorios/*':   { title: 'Relatorios CRM',      subtitle: 'Analises e relatorios do CRM',              icon: <Assessment />,    iconBg: '#7C3AED' },
```

---

## Visao Geral das Fases

| Fase | Nome | Foco | Paginas | Estimativa |
|------|------|------|---------|------------|
| **1** | Core CRM | Pipeline, Contatos, Atividades | 8 | Base do modulo |
| **2** | Campo | Visitas, Despesas, Fotos de Recibos | 5 | Consultores de campo |
| **3** | Geo & Mapas | Mapa de Clientes, Territorios, Rotas | 3 | Visualizacao geografica |
| **4** | Dashboard & KPIs | Paineis por role, 50+ KPIs, Graficos | 4 | Inteligencia de vendas |
| **5** | Avancado | Leads, Campanhas, Comodatos, Automacoes | 5 | Funcionalidades avancadas |

---

## FASE 1 — Core CRM

> **Objetivo:** Estabelecer a base do CRM com gestao de contatos, pipeline de oportunidades e atividades de vendas.

### 1.1 Entidades de Dominio (Backend)

#### Dominios (Lookup Tables — `BaseDominio`)

| Dominio | Codigo | Exemplos de Valores |
|---------|--------|---------------------|
| `TipoContato` | `tipos-contato-crm` | Decisor, Influenciador, Tecnico, Financeiro, Compras |
| `OrigemLead` | `origens-lead` | Indicacao, Site, Feira, Telefone, WhatsApp, Visita Espontanea |
| `MotivoPerda` | `motivos-perda` | Preco, Prazo, Qualidade, Concorrente, Sem Orcamento |
| `TipoAtividade` | `tipos-atividade-crm` | Ligacao, E-mail, Reuniao, Visita, Tarefa, WhatsApp |
| `StatusAtividade` | `status-atividade` | Pendente, Concluida, Cancelada |
| `NivelInteresse` | `niveis-interesse` | Frio, Morno, Quente |
| `Segmento` | `segmentos-crm` | Otica Independente, Rede, Franquia, Clinica, Oftalmologista |
| `Porte` | `portes-crm` | Micro, Pequeno, Medio, Grande |
| `ClassificacaoABC` | `classificacao-abc` | A, B, C |

#### Entidades de Negocio

```
PerfilCrmCliente (1:1 com Cliente existente)
├── ClienteId (FK → Cliente)
├── SegmentoId (FK → Dominio)
├── PorteId (FK → Dominio)
├── ClassificacaoId (FK → Dominio)
├── NivelInteresseId (FK → Dominio)
├── OrigemId (FK → Dominio)
├── VendedorResponsavelId (FK → Funcionario)
├── PotencialMensal (decimal) — estimativa de faturamento mensal
├── ParticipacaoMercado (decimal) — % share do lab no cliente
├── QuantidadeFuncionarios (int)
├── LaboratoriosConcorrentes (string) — labs que tambem atendem
├── UltimaVisita (DateTime?)
├── ProximaVisitaPlanejada (DateTime?)
├── Observacoes (string)
├── Latitude (double?)
├── Longitude (double?)
├── GeocodeValidado (bool)
└── DataCadastro, DataAtualizacao, Ativo
```

```
EtapaPipeline
├── Nome (string) — ex: Prospeccao, Qualificacao, Proposta, Negociacao, Fechamento
├── Ordem (int) — sequencia no funil
├── Probabilidade (int) — % de conversao padrao (ex: 10, 25, 50, 75, 90)
├── CorHex (string) — cor para visualizacao no Kanban
├── DiasLimite (int?) — alerta se oportunidade ficar mais que X dias nesta etapa
├── Ativo (bool)
└── Codigo (int, auto-incremental)
```

```
Oportunidade
├── Codigo (int, auto-incremental, padStart 8)
├── Titulo (string) — ex: "Venda de progressivos para Otica Central"
├── ClienteId (FK → Cliente)
├── PerfilCrmClienteId (FK → PerfilCrmCliente)
├── EtapaPipelineId (FK → EtapaPipeline)
├── VendedorId (FK → Funcionario)
├── ValorEstimado (decimal)
├── ValorFechado (decimal?)
├── DataAbertura (DateTime)
├── DataPrevisaoFechamento (DateTime?)
├── DataFechamento (DateTime?)
├── MotivoPerda (string?)
├── MotivoPerdaId (FK → Dominio, nullable)
├── ConcorrentePrincipal (string?)
├── OrigemId (FK → Dominio)
├── NivelInteresseId (FK → Dominio)
├── Probabilidade (int) — herdada da etapa, editavel
├── Status (enum: Aberta, Ganha, Perdida, Cancelada)
├── Observacoes (string?)
├── PedidoVendaId (FK → PedidoVenda, nullable) — vinculo apos conversao
└── DataCadastro, DataAtualizacao
```

```
ContatoCrm
├── Codigo (int, auto-incremental)
├── Nome (string)
├── Cargo (string?)
├── Email (string?)
├── Telefone (string?)
├── Celular (string?)
├── WhatsApp (string?)
├── ClienteId (FK → Cliente)
├── TipoContatoId (FK → Dominio)
├── Principal (bool) — contato principal do cliente
├── Observacoes (string?)
├── Ativo (bool)
└── DataCadastro, DataAtualizacao
```

```
Atividade
├── Codigo (int, auto-incremental)
├── TipoAtividadeId (FK → Dominio)
├── StatusAtividadeId (FK → Dominio)
├── Titulo (string)
├── Descricao (string?)
├── DataPlanejada (DateTime)
├── DataRealizacao (DateTime?)
├── DuracaoMinutos (int?)
├── VendedorId (FK → Funcionario)
├── ClienteId (FK → Cliente, nullable)
├── OportunidadeId (FK → Oportunidade, nullable)
├── ContatoCrmId (FK → ContatoCrm, nullable)
├── Resultado (string?) — resumo do que foi discutido
├── ProximaAcao (string?) — follow-up definido
├── DataProximaAcao (DateTime?)
└── DataCadastro, DataAtualizacao
```

```
OportunidadeProduto (itens da oportunidade)
├── OportunidadeId (FK → Oportunidade)
├── ProdutoId (FK → Produto)
├── Quantidade (int)
├── ValorUnitario (decimal)
├── ValorTotal (decimal)
├── Observacoes (string?)
└── Ordem (int)
```

```
OportunidadeHistorico (log de mudancas de etapa)
├── OportunidadeId (FK → Oportunidade)
├── EtapaAnteriorId (FK → EtapaPipeline, nullable)
├── EtapaNovaId (FK → EtapaPipeline)
├── UsuarioId (FK → ApplicationUser)
├── DataMudanca (DateTime)
├── Observacao (string?)
└── ValorNaMudanca (decimal) — snapshot do valor na hora da mudanca
```

### 1.2 Paginas Frontend

| Pagina | Rota | Tipo | Descricao |
|--------|------|------|-----------|
| `CrmDashboardPage` | `/crm/dashboard` | Dashboard | KPIs basicos + mini funil + atividades do dia |
| `ContatosCrmListPage` | `/crm/contatos` | ListPage | Lista de contatos com DataGrid server-side |
| `ContatoCrmDetailDialog` | — | Dialog | Visualizacao read-only do contato |
| `ContatoCrmFormDialog` | — | Dialog | Criar/editar contato CRM |
| `OportunidadesListPage` | `/crm/oportunidades` | ListPage | Lista de oportunidades com DataGrid + KPIs |
| `OportunidadeDetailDialog` | — | Dialog | Detalhe read-only com timeline de etapas |
| `OportunidadeFormDialog` | — | Dialog | Criar/editar oportunidade com itens |
| `PipelinePage` | `/crm/pipeline` | Kanban | Visualizacao Kanban com drag-and-drop por etapa |
| `AtividadesListPage` | `/crm/atividades` | ListPage | Calendario + lista de atividades |
| `AtividadeFormDialog` | — | Dialog | Criar/editar atividade |
| `PerfilCrmFormDialog` | — | Dialog | Perfil CRM dentro do ClienteDetailDialog (aba CRM) |

### 1.3 Permissoes

```csharp
public static class CRM
{
    public const string View = "Permissions.CRM.View";

    public static class Dashboard
    {
        public const string View = "Permissions.CRM.Dashboard.View";
    }

    public static class Contatos
    {
        public const string View   = "Permissions.CRM.Contatos.View";
        public const string Create = "Permissions.CRM.Contatos.Create";
        public const string Edit   = "Permissions.CRM.Contatos.Edit";
        public const string Delete = "Permissions.CRM.Contatos.Delete";
    }

    public static class Oportunidades
    {
        public const string View   = "Permissions.CRM.Oportunidades.View";
        public const string Create = "Permissions.CRM.Oportunidades.Create";
        public const string Edit   = "Permissions.CRM.Oportunidades.Edit";
        public const string Delete = "Permissions.CRM.Oportunidades.Delete";
        public const string MudarEtapa = "Permissions.CRM.Oportunidades.MudarEtapa";
        public const string FecharGanha = "Permissions.CRM.Oportunidades.FecharGanha";
        public const string FecharPerdida = "Permissions.CRM.Oportunidades.FecharPerdida";
    }

    public static class Pipeline
    {
        public const string View = "Permissions.CRM.Pipeline.View";
    }

    public static class Atividades
    {
        public const string View   = "Permissions.CRM.Atividades.View";
        public const string Create = "Permissions.CRM.Atividades.Create";
        public const string Edit   = "Permissions.CRM.Atividades.Edit";
        public const string Delete = "Permissions.CRM.Atividades.Delete";
    }

    public static class PerfilCliente
    {
        public const string View = "Permissions.CRM.PerfilCliente.View";
        public const string Edit = "Permissions.CRM.PerfilCliente.Edit";
    }
}
```

### 1.4 Endpoints API

```
GET/POST       /api/crm/contatos
GET/PUT/DELETE  /api/crm/contatos/{id}
GET            /api/crm/contatos/proximo-codigo

GET/POST       /api/crm/oportunidades
GET/PUT/DELETE  /api/crm/oportunidades/{id}
GET            /api/crm/oportunidades/proximo-codigo
PUT            /api/crm/oportunidades/{id}/etapa         (mover no pipeline)
PUT            /api/crm/oportunidades/{id}/fechar-ganha
PUT            /api/crm/oportunidades/{id}/fechar-perdida
GET            /api/crm/oportunidades/{id}/historico

GET/POST       /api/crm/atividades
GET/PUT/DELETE  /api/crm/atividades/{id}
GET            /api/crm/atividades/proximo-codigo
GET            /api/crm/atividades/hoje                  (atividades do dia do vendedor)
GET            /api/crm/atividades/pendentes              (follow-ups pendentes)

GET/PUT        /api/crm/perfil-cliente/{clienteId}

GET/POST       /api/crm/etapas-pipeline
GET/PUT/DELETE  /api/crm/etapas-pipeline/{id}
PUT            /api/crm/etapas-pipeline/reordenar

GET            /api/crm/dashboard/resumo                 (KPIs basicos)
```

### 1.5 Dominios a Criar

| Pagina de Dominio | Rota | Dominios Gerenciados |
|-------------------|------|---------------------|
| Tipos de Contato CRM | `/dominios/crm/tipos-contato` | tipos-contato-crm |
| Origens de Lead | `/dominios/crm/origens-lead` | origens-lead |
| Motivos de Perda | `/dominios/crm/motivos-perda` | motivos-perda |
| Tipos de Atividade | `/dominios/crm/tipos-atividade` | tipos-atividade-crm |
| Status de Atividade | `/dominios/crm/status-atividade` | status-atividade |
| Niveis de Interesse | `/dominios/crm/niveis-interesse` | niveis-interesse |
| Segmentos CRM | `/dominios/crm/segmentos` | segmentos-crm |
| Portes | `/dominios/crm/portes` | portes-crm |

### 1.6 Seeds

```
EtapaPipeline (seed padrao):
  1. Prospeccao      (10%, #64748B)
  2. Qualificacao    (25%, #3B82F6)
  3. Proposta        (50%, #F59E0B)
  4. Negociacao      (75%, #8B5CF6)
  5. Fechamento      (90%, #10B981)

Dominios seed:
  tipos-contato-crm: Decisor (padrao), Influenciador, Tecnico, Financeiro, Compras
  origens-lead: Indicacao (padrao), Site, Feira, Telefone, WhatsApp, Visita Espontanea
  motivos-perda: Preco (padrao), Prazo, Qualidade, Concorrente, Sem Orcamento, Outro
  tipos-atividade-crm: Ligacao, E-mail, Reuniao (padrao), Visita, Tarefa, WhatsApp
  status-atividade: Pendente (padrao), Concluida, Cancelada
  niveis-interesse: Frio, Morno (padrao), Quente
  segmentos-crm: Otica Independente (padrao), Rede, Franquia, Clinica, Oftalmologista
  portes-crm: Micro, Pequeno (padrao), Medio, Grande
```

### 1.7 Migration

```
AddCrmCoreDomain  — EtapaPipeline, PerfilCrmCliente, ContatoCrm, Oportunidade,
                    OportunidadeProduto, OportunidadeHistorico, Atividade
                    + seeds de dominios + seeds de EtapaPipeline
```

### 1.8 Detalhes do Pipeline Kanban

A pagina `/crm/pipeline` e uma visualizacao Kanban (drag-and-drop) das oportunidades, organizada por etapas.

**Biblioteca recomendada:** `@hello-pangea/dnd` (fork mantido do `react-beautiful-dnd`)

```
Pipeline Kanban Layout:

┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│ PROSPECCAO  │QUALIFICACAO │  PROPOSTA   │ NEGOCIACAO  │ FECHAMENTO  │
│ R$ 45.000   │ R$ 120.000  │ R$ 80.000   │ R$ 200.000  │ R$ 150.000  │
│ 12 opps     │ 8 opps      │ 5 opps      │ 3 opps      │ 2 opps      │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │
│ │ Otica X │ │ │ Otica Y │ │ │ Otica Z │ │ │ Otica W │ │ │ Otica V │ │
│ │ R$5.000 │ │ │ R$15.000│ │ │ R$16.000│ │ │R$100.000│ │ │ R$75.000│ │
│ │ Joao S. │ │ │ Maria L.│ │ │ Joao S. │ │ │ Maria L.│ │ │ Joao S. │ │
│ │ 3 dias  │ │ │ 7 dias  │ │ │ 12 dias │ │ │ 5 dias  │ │ │ 2 dias  │ │
│ └─────────┘ │ └─────────┘ │ └─────────┘ │ └─────────┘ │ └─────────┘ │
│ ┌─────────┐ │ ┌─────────┐ │             │             │             │
│ │ Otica A │ │ │ Otica B │ │             │             │             │
│ │ R$3.000 │ │ │ R$20.000│ │             │             │             │
│ └─────────┘ │ └─────────┘ │             │             │             │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

**Card de oportunidade mostra:**
- Nome do cliente
- Valor estimado (formatCurrency)
- Vendedor responsavel
- Dias na etapa atual (com alerta visual se > DiasLimite da etapa)
- Nivel de interesse (icone colorido)

**Drag-and-drop:** Ao arrastar card para outra coluna, chama `PUT /api/crm/oportunidades/{id}/etapa` e cria registro em `OportunidadeHistorico`.

---

## FASE 2 — Campo (Visitas & Despesas)

> **Objetivo:** Permitir que consultores de campo registrem visitas com GPS, gerem relatorios de despesas com fotos de recibos, e submetam para aprovacao.

### 2.1 Entidades de Dominio

#### Dominios Adicionais

| Dominio | Codigo | Exemplos |
|---------|--------|----------|
| `TipoVisita` | `tipos-visita` | Comercial, Tecnica, Treinamento, Cobranca, Pos-Venda |
| `ResultadoVisita` | `resultados-visita` | Pedido Realizado, Proposta Enviada, Reagendado, Sem Interesse, Ausente |
| `CategoriaDespesa` | `categorias-despesa` | Combustivel, Pedagio, Estacionamento, Alimentacao, Hospedagem, Outros |
| `StatusDespesa` | `status-despesa` | Rascunho, Enviado, Em Analise, Aprovado, Rejeitado, Reembolsado |

#### Entidades de Negocio

```
Visita
├── Codigo (int, auto-incremental)
├── ClienteId (FK → Cliente)
├── VendedorId (FK → Funcionario)
├── OportunidadeId (FK → Oportunidade, nullable)
├── ContatoCrmId (FK → ContatoCrm, nullable)
├── TipoVisitaId (FK → Dominio)
├── ResultadoVisitaId (FK → Dominio, nullable) — preenchido no check-out
├── DataPlanejada (DateTime)
├── DataCheckIn (DateTime?)
├── DataCheckOut (DateTime?)
├── LatitudeCheckIn (double?)
├── LongitudeCheckIn (double?)
├── LatitudeCheckOut (double?)
├── LongitudeCheckOut (double?)
├── DistanciaClienteMetros (int?) — distancia GPS do endereco do cliente no check-in
├── DuracaoMinutos (int?) — calculado: CheckOut - CheckIn
├── Objetivo (string) — o que pretende fazer na visita
├── Relatorio (string?) — preenchido durante/apos a visita
├── ProximaAcao (string?)
├── DataProximaAcao (DateTime?)
├── Status (enum: Planejada, EmAndamento, Concluida, Cancelada, NaoRealizada)
├── AssinaturaNomeContato (string?) — nome de quem recebeu na visita
└── DataCadastro, DataAtualizacao
```

```
VisitaFoto
├── VisitaId (FK → Visita)
├── Url (string) — path no storage
├── Descricao (string?)
├── TipoFoto (enum: Fachada, Vitrine, Produto, Equipamento, Outro)
├── DataUpload (DateTime)
└── Ordem (int)
```

```
RelatorioDespesa
├── Codigo (int, auto-incremental)
├── VendedorId (FK → Funcionario)
├── Titulo (string) — ex: "Despesas Semana 12 - Regiao Sul"
├── DataInicio (DateTime) — periodo coberto
├── DataFim (DateTime)
├── ValorTotal (decimal) — soma dos itens
├── ValorAprovado (decimal?) — apos aprovacao (pode ser parcial)
├── StatusDespesaId (FK → Dominio)
├── AprovadorId (FK → Funcionario, nullable)
├── DataEnvio (DateTime?)
├── DataAprovacao (DateTime?)
├── ObservacaoAprovador (string?)
├── ObservacaoVendedor (string?)
└── DataCadastro, DataAtualizacao
```

```
DespesaItem
├── RelatorioDespesaId (FK → RelatorioDespesa)
├── VisitaId (FK → Visita, nullable) — vinculo com visita especifica
├── CategoriaDespesaId (FK → Dominio)
├── Descricao (string)
├── Data (DateTime) — data da despesa
├── Valor (decimal)
├── ValorAprovado (decimal?) — pode ser diferente se aprovador ajustar
├── Aprovado (bool?) — null = pendente, true = aprovado, false = rejeitado
├── ObservacaoAprovador (string?)
├── Quilometragem (decimal?) — se categoria = Combustivel/Km
├── OrigemEndereco (string?) — ponto de partida
├── DestinoEndereco (string?) — ponto de chegada
└── Ordem (int)
```

```
DespesaComprovante
├── DespesaItemId (FK → DespesaItem)
├── Url (string) — path no storage
├── NomeArquivo (string)
├── TipoArquivo (string) — image/jpeg, image/png, application/pdf
├── TamanhoBytes (long)
├── DataUpload (DateTime)
└── Ordem (int)
```

```
RelatorioDespesaHistorico (log de status)
├── RelatorioDespesaId (FK → RelatorioDespesa)
├── StatusAnteriorId (FK → Dominio, nullable)
├── StatusNovoId (FK → Dominio)
├── UsuarioId (FK → ApplicationUser)
├── DataMudanca (DateTime)
├── Observacao (string?)
```

### 2.2 Paginas Frontend

| Pagina | Rota | Tipo | Descricao |
|--------|------|------|-----------|
| `VisitasListPage` | `/crm/visitas` | ListPage | Lista de visitas com DataGrid server-side, KPIs (planejadas, em andamento, concluidas) |
| `VisitaDetailDialog` | — | Dialog | Detalhe da visita com mapa de localizacao, fotos, timeline |
| `VisitaFormDialog` | — | Dialog | Criar/editar visita com selecao de cliente/oportunidade |
| `VisitaCheckInDialog` | — | Dialog | Check-in com captura GPS, foto da fachada |
| `VisitaCheckOutDialog` | — | Dialog | Check-out com relatorio, resultado, proxima acao |
| `DespesasListPage` | `/crm/despesas` | ListPage | Lista de relatorios de despesa por periodo |
| `DespesaRelatarioFormPage` | `/crm/despesas/novo` | Page | Criar relatorio de despesa com itens + fotos |
| `DespesaRelatarioDetailPage` | `/crm/despesas/:id` | Page | Visualizar relatorio + workflow de aprovacao |
| `DespesaAprovacaoPage` | `/crm/despesas/aprovacao` | Page | Fila de aprovacao para gerentes |

### 2.3 Permissoes Adicionais

```csharp
public static class Visitas
{
    public const string View    = "Permissions.CRM.Visitas.View";
    public const string Create  = "Permissions.CRM.Visitas.Create";
    public const string Edit    = "Permissions.CRM.Visitas.Edit";
    public const string Delete  = "Permissions.CRM.Visitas.Delete";
    public const string CheckIn  = "Permissions.CRM.Visitas.CheckIn";
    public const string CheckOut = "Permissions.CRM.Visitas.CheckOut";
    public const string VerTodos = "Permissions.CRM.Visitas.VerTodos"; // gerente ve de todos os vendedores
}

public static class Despesas
{
    public const string View     = "Permissions.CRM.Despesas.View";
    public const string Create   = "Permissions.CRM.Despesas.Create";
    public const string Edit     = "Permissions.CRM.Despesas.Edit";
    public const string Delete   = "Permissions.CRM.Despesas.Delete";
    public const string Enviar   = "Permissions.CRM.Despesas.Enviar";
    public const string Aprovar  = "Permissions.CRM.Despesas.Aprovar";
    public const string Rejeitar = "Permissions.CRM.Despesas.Rejeitar";
    public const string VerTodos = "Permissions.CRM.Despesas.VerTodos";
}
```

### 2.4 Endpoints API

```
# Visitas
GET/POST       /api/crm/visitas
GET/PUT/DELETE  /api/crm/visitas/{id}
GET            /api/crm/visitas/proximo-codigo
POST           /api/crm/visitas/{id}/check-in            (latitude, longitude, foto?)
POST           /api/crm/visitas/{id}/check-out           (relatorio, resultado, proxima acao)
GET            /api/crm/visitas/hoje                     (visitas do dia do vendedor logado)
GET            /api/crm/visitas/cliente/{clienteId}      (historico de visitas ao cliente)
POST           /api/crm/visitas/{id}/fotos               (upload de fotos)
DELETE         /api/crm/visitas/{id}/fotos/{fotoId}

# Relatorios de Despesa
GET/POST       /api/crm/despesas
GET/PUT/DELETE  /api/crm/despesas/{id}
GET            /api/crm/despesas/proximo-codigo
POST           /api/crm/despesas/{id}/enviar             (submeter para aprovacao)
POST           /api/crm/despesas/{id}/aprovar            (gerente aprova)
POST           /api/crm/despesas/{id}/rejeitar           (gerente rejeita)
POST           /api/crm/despesas/{id}/reembolsar         (financeiro marca como reembolsado)
GET            /api/crm/despesas/aprovacao/pendentes     (fila do gerente)
GET            /api/crm/despesas/{id}/historico

# Itens de Despesa
POST           /api/crm/despesas/{id}/itens
PUT            /api/crm/despesas/{id}/itens/{itemId}
DELETE         /api/crm/despesas/{id}/itens/{itemId}
POST           /api/crm/despesas/{id}/itens/{itemId}/comprovantes   (upload foto recibo)
DELETE         /api/crm/despesas/{id}/itens/{itemId}/comprovantes/{compId}
```

### 2.5 Workflow de Despesas

```
                    ┌──────────────────────────────────────────────────┐
                    │                                                  │
  ┌──────────┐   ┌─▼────────┐   ┌───────────┐   ┌──────────┐   ┌────┴──────┐
  │ RASCUNHO │──▶│ ENVIADO  │──▶│ EM ANALISE│──▶│ APROVADO │──▶│REEMBOLSADO│
  └──────────┘   └──────────┘   └─────┬─────┘   └──────────┘   └───────────┘
       ▲                              │
       │                              ▼
       │                        ┌──────────┐
       └────────────────────────│ REJEITADO│  (volta para rascunho para correcao)
                                └──────────┘
```

**Regras:**
- Vendedor cria rascunho → adiciona itens com fotos → envia
- Gerente recebe notificacao → analisa → aprova (total ou parcial) ou rejeita com motivo
- Se rejeitado, vendedor corrige e reenvia
- Apos aprovacao, financeiro marca como reembolsado
- Item individual pode ser rejeitado (ex: sem comprovante) enquanto outros sao aprovados

### 2.6 Migration

```
AddCrmVisitasDespesas — Visita, VisitaFoto, RelatorioDespesa, DespesaItem,
                         DespesaComprovante, RelatorioDespesaHistorico
                         + seeds de dominios (tipos-visita, resultados-visita,
                           categorias-despesa, status-despesa)
```

---

## FASE 3 — Geo & Mapas

> **Objetivo:** Visualizar clientes e territorios no mapa, com heatmaps de performance e rotas otimizadas para visitas.

### 3.1 Pre-requisitos Tecnicos

| Item | Acao |
|------|------|
| **PostGIS** | Habilitar extensao no PostgreSQL (`CREATE EXTENSION postgis`) |
| **NTS** | Adicionar `Npgsql.EntityFrameworkCore.PostgreSQL.NetTopologySuite` ao backend |
| **Google Maps API** | Obter API key com Maps JavaScript, Geocoding, Routes, Places |
| **Frontend** | Instalar `@vis.gl/react-google-maps` + `@googlemaps/markerclusterer` |
| **deck.gl** | Instalar `deck.gl` + `@deck.gl/google-maps` para heatmaps avancados |

### 3.2 Entidades de Dominio

```
Territorio
├── Codigo (int, auto-incremental)
├── Nome (string) — ex: "Zona Sul - SP", "Regiao Metropolitana - BH"
├── Descricao (string?)
├── VendedorId (FK → Funcionario) — responsavel pelo territorio
├── RegiaoVendaId (FK → RegiaoVenda, nullable) — vinculo com RegiaoVenda existente
├── CorHex (string) — cor do poligono no mapa
├── Geometria (Geometry, SRID 4326) — poligono PostGIS
├── Ativo (bool)
└── DataCadastro, DataAtualizacao
```

```
RotaVisita
├── Codigo (int, auto-incremental)
├── VendedorId (FK → Funcionario)
├── DataRota (DateTime) — dia planejado
├── Nome (string?) — ex: "Rota Terça - Centro"
├── DistanciaTotalKm (decimal?)
├── DuracaoEstimadaMinutos (int?)
├── Otimizada (bool) — se foi otimizada pela API de rotas
└── DataCadastro, DataAtualizacao
```

```
RotaVisitaParada
├── RotaVisitaId (FK → RotaVisita)
├── ClienteId (FK → Cliente)
├── VisitaId (FK → Visita, nullable) — vincula se a visita ja foi criada
├── Ordem (int) — sequencia da parada
├── HorarioEstimado (TimeSpan?)
├── DuracaoEstimadaMinutos (int?)
└── Observacao (string?)
```

### 3.3 Paginas Frontend

| Pagina | Rota | Tipo | Descricao |
|--------|------|------|-----------|
| `MapaClientesPage` | `/crm/mapa` | Page | Mapa interativo com clientes, filtros, heatmap, rota |
| `TerritoriosListPage` | `/crm/territorios` | ListPage | Lista de territorios com DataGrid |
| `TerritorioFormDialog` | — | Dialog | Criar/editar territorio com desenho de poligono no mapa |
| `RotaPlanejamentoPage` | `/crm/mapa/rota` | Page | Planejamento de rota com otimizacao |

### 3.4 Funcionalidades do Mapa de Clientes

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Mapa de Clientes                                                        │
│                                                                         │
│  [Filtros: Vendedor ▼] [Segmento ▼] [Classificacao ▼] [Status ▼]      │
│  [🔥 Heatmap] [📍 Territorios] [🔴 Inativos] [🟢 Ativos]              │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                                                                 │    │
│  │              🟢 Otica Central                                   │    │
│  │          🔵 Otica Modelo        🟡 Otica Express               │    │
│  │                                                                 │    │
│  │    🟢🟢🟢 (cluster: 15)                                        │    │
│  │                        🔴 Otica Visao (inativa)                 │    │
│  │                                                                 │    │
│  │  ╔═══════════════╗   Territorio: Zona Sul                      │    │
│  │  ║   Poligono    ║   Vendedor: Joao Silva                      │    │
│  │  ║   colorido    ║   Clientes: 32                              │    │
│  │  ╚═══════════════╝                                              │    │
│  │                                                                 │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  Legenda: 🟢 Ativo  🔵 Prospecto  🟡 Inadimplente  🔴 Inativo         │
│                                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐               │
│  │ 156      │  │ R$2.3M   │  │ 12       │  │ 78%      │               │
│  │ Clientes │  │ Potencial│  │ Sem Visita│  │ Cobertura│               │
│  │ no mapa  │  │ Total    │  │ > 30 dias │  │ Territ.  │               │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘               │
└─────────────────────────────────────────────────────────────────────────┘
```

**Marcadores por cor:**
- 🟢 Verde: Cliente ativo com compras recentes
- 🔵 Azul: Prospecto/Lead (sem pedidos)
- 🟡 Amarelo: Inadimplente ou sem compras > 60 dias
- 🔴 Vermelho: Inativo
- Tamanho do marcador proporcional ao faturamento

**Popup ao clicar no marcador:**
- Nome do cliente, endereco, telefone
- Ultimo pedido (data + valor)
- Ultima visita (data + vendedor)
- Botao "Agendar Visita" → abre VisitaFormDialog

**Heatmap (deck.gl):**
- Camada de calor baseada em faturamento ou frequencia de visitas
- Toggle on/off via botao

### 3.5 Permissoes Adicionais

```csharp
public static class Mapa
{
    public const string View = "Permissions.CRM.Mapa.View";
}

public static class Territorios
{
    public const string View   = "Permissions.CRM.Territorios.View";
    public const string Create = "Permissions.CRM.Territorios.Create";
    public const string Edit   = "Permissions.CRM.Territorios.Edit";
    public const string Delete = "Permissions.CRM.Territorios.Delete";
}
```

### 3.6 Endpoints API

```
# Mapa
GET    /api/crm/mapa/clientes                    (lat, lng, classificacao, segmento para todos os clientes)
GET    /api/crm/mapa/heatmap                     (dados para heatmap: lat, lng, peso)
GET    /api/crm/mapa/clientes-proximos            (lat, lng, raioKm → clientes proximos)

# Territorios
GET/POST       /api/crm/territorios
GET/PUT/DELETE  /api/crm/territorios/{id}
GET            /api/crm/territorios/proximo-codigo
GET            /api/crm/territorios/{id}/clientes        (clientes dentro do poligono)
POST           /api/crm/territorios/verificar-ponto      (lat, lng → retorna territorio)

# Rotas
GET/POST       /api/crm/rotas
GET/PUT/DELETE  /api/crm/rotas/{id}
POST           /api/crm/rotas/{id}/otimizar              (chama Google Routes API)
```

### 3.7 Geocoding de Clientes

- **Batch geocoding:** Script/job para geocodificar enderecos de todos os clientes existentes via Google Geocoding API
- **On-save geocoding:** Ao salvar/editar endereco do cliente, geocodificar automaticamente e salvar `Latitude`/`Longitude` no `PerfilCrmCliente`
- **Validacao:** Flag `GeocodeValidado` para indicar se a coordenada foi verificada

### 3.8 Migration

```
AddCrmGeoTerritorios — Territorio (com coluna Geometry PostGIS), RotaVisita, RotaVisitaParada
                       + adicionar colunas Latitude/Longitude ao PerfilCrmCliente (se nao existirem)
                       + CREATE EXTENSION IF NOT EXISTS postgis (no schema do tenant)
```

---

## FASE 4 — Dashboard & KPIs

> **Objetivo:** Criar paineis com 50+ KPIs, graficos interativos, forecasting e visoes por role.

### 4.1 Pre-requisitos Tecnicos

| Item | Acao |
|------|------|
| **Charts** | Instalar `recharts` (ou `@nivo/core` se preferir) |
| **Date Picker** | Ja existe no MUI X — usar para seletores de periodo |
| **Materialized Views** | Criar views no PostgreSQL para KPIs pesados |

### 4.2 Dashboards por Role

#### 4.2.1 Dashboard Executivo (`/crm/dashboard` — visao padrao para diretores)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Dashboard CRM — Visao Executiva                     [Periodo: Mar 2026 ▼] │
│                                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ R$580K   │  │ R$1.2M   │  │ 42%      │  │ 38       │  │ 15 dias  │     │
│  │ Receita  │  │ Pipeline │  │ Win Rate │  │ Novos    │  │ Ciclo    │     │
│  │ Mes ▲12% │  │ Total    │  │ ▲5pp     │  │ Clientes │  │ Medio    │     │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  └──────────┘     │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Funil de Vendas (Funnel Chart) │  │ Receita vs Meta (Bar + Line)   │   │
│  │ Prospeccao:   45 │ R$280K      │  │                                │   │
│  │ Qualificacao: 28 │ R$420K      │  │  ▓▓▓▓▓▓▓▓░░ 78% da meta      │   │
│  │ Proposta:     15 │ R$380K      │  │  Jan  Fev  Mar  Abr  Mai      │   │
│  │ Negociacao:    8 │ R$520K      │  │                                │   │
│  │ Fechamento:    5 │ R$180K      │  │                                │   │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Top 10 Clientes (Horizontal    │  │ Performance por Vendedor        │   │
│  │ Bar Chart)                     │  │ (Grouped Bar: meta vs real)     │   │
│  │                                │  │                                │   │
│  │ Otica Central    ▓▓▓▓▓ R$45K  │  │ Joao  ▓▓▓▓░░ 82%              │   │
│  │ Otica Modelo     ▓▓▓▓ R$38K   │  │ Maria ▓▓▓▓▓░ 91%              │   │
│  │ Otica Express    ▓▓▓ R$28K    │  │ Pedro ▓▓▓░░░ 65%              │   │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Motivos de Perda (Donut)       │  │ Forecast Proximo Trimestre      │   │
│  │ 🔴 Preco 35%                   │  │                                │   │
│  │ 🟡 Concorrencia 25%           │  │ Commit:    R$320K              │   │
│  │ 🔵 Prazo 20%                  │  │ Best Case: R$480K              │   │
│  │ ⚪ Outros 20%                  │  │ Pipeline:  R$780K              │   │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 4.2.2 Dashboard Gerente (`/crm/dashboard` — visao para gerentes de vendas)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Dashboard CRM — Minha Equipe                  [Vendedor: Todos ▼] [Mar ▼] │
│                                                                             │
│  KPIs: Visitas Hoje (12) | Atividades Pendentes (28) | Despesas p/ Aprovar │
│        Oportunidades Abertas (45) | Valor Pipeline (R$1.2M)                │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ Atividades da Equipe (DataGrid)                                     │   │
│  │ Vendedor | Visitas Mes | Ligacoes | Opp Abertas | Win Rate | Meta % │   │
│  │ Joao S.  |     18     |    45    |     12      |   42%   |  82%   │   │
│  │ Maria L. |     22     |    38    |      8      |   48%   |  91%   │   │
│  │ Pedro R. |     14     |    52    |     15      |   35%   |  65%   │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Visitas por Dia (Line Chart)   │  │ Despesas por Vendedor (Stacked) │   │
│  │ Semana atual vs anterior       │  │ Combustivel | Alimentacao | Outros│  │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
│                                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ Clientes sem Visita > 30 dias (Lista com botao "Agendar")          │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 4.2.3 Dashboard Consultor (`/crm/dashboard` — visao para vendedor/consultor)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Meu Dashboard                                                   [Mar ▼]   │
│                                                                             │
│  KPIs: Minhas Visitas Hoje (3) | Atividades Pendentes (5) | Meta Mes 78%  │
│        Minhas Oportunidades (8) | Meu Pipeline (R$180K)                    │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Agenda do Dia (Timeline)       │  │ Meu Funil (Mini Funnel)        │   │
│  │                                │  │                                │   │
│  │ 09:00 - Visita Otica Central  │  │ Prosp: 3 | R$25K              │   │
│  │ 11:00 - Ligacao Sr. Carlos    │  │ Qualif: 2 | R$45K             │   │
│  │ 14:00 - Visita Otica Express  │  │ Propos: 2 | R$80K             │   │
│  │ 16:00 - Reuniao Otica Modelo  │  │ Negoc:  1 | R$30K             │   │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────┐  ┌─────────────────────────────────┐   │
│  │ Minhas Despesas do Mes         │  │ Proximos Follow-ups             │   │
│  │ Total: R$1.280                 │  │                                │   │
│  │ Combustivel: R$620             │  │ Amanha - Ligar Otica Modelo    │   │
│  │ Alimentacao: R$380             │  │ Qua - Enviar proposta Express  │   │
│  │ Outros: R$280                  │  │ Sex - Visita Otica Visao       │   │
│  │ [Novo Relatorio de Despesa]    │  │                                │   │
│  └─────────────────────────────────┘  └─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 KPIs Detalhados

#### KPIs do Pipeline

| KPI | Formula | Grafico | Refresh |
|-----|---------|---------|---------|
| Valor Total Pipeline | `SUM(ValorEstimado) WHERE Status = Aberta` | Card com sparkline | Tempo real |
| Pipeline Ponderado | `SUM(ValorEstimado × Probabilidade / 100)` | Card | Tempo real |
| Velocidade do Pipeline | `(QtdOppsGanhas × TicketMedio) / CicloMedioDias` | Card com trend | Diario |
| Win Rate | `OppsGanhas / (OppsGanhas + OppsPerdidas) × 100` | Gauge | Mensal |
| Taxa Conversao por Etapa | `OppsQueAvancaram / TotalNaEtapa × 100` | Funnel | Semanal |
| Ticket Medio | `SUM(ValorFechado) / COUNT(OppsGanhas)` | Card com comparativo | Mensal |
| Ciclo Medio de Venda | `AVG(DataFechamento - DataAbertura) em dias` | Card | Mensal |
| Oportunidades Estagnadas | `COUNT WHERE diasNaEtapa > EtapaPipeline.DiasLimite` | Badge alerta | Diario |
| Cobertura Pipeline | `ValorPipeline / MetaMes × 100` | Bullet chart | Semanal |
| Top Motivos de Perda | `COUNT GROUP BY MotivoPerda ORDER BY DESC LIMIT 5` | Donut | Mensal |

#### KPIs de Atividades

| KPI | Formula | Grafico | Refresh |
|-----|---------|---------|---------|
| Atividades por Rep/Mes | `COUNT GROUP BY VendedorId, TipoAtividade` | Grouped bar | Diario |
| Visitas por Rep/Mes | `COUNT(Visita) WHERE Status = Concluida GROUP BY VendedorId` | Bar | Diario |
| Atividades Pendentes | `COUNT WHERE Status = Pendente AND Data < HOJE` | Badge | Tempo real |
| Follow-ups Atrasados | `COUNT WHERE DataProximaAcao < HOJE AND Status != Concluida` | Badge alerta | Tempo real |
| Tempo Medio de Resposta | `AVG(DataRealizacao - DataCriacao) para primeiras atividades` | Card | Semanal |

#### KPIs de Receita

| KPI | Formula | Grafico | Refresh |
|-----|---------|---------|---------|
| Receita Mensal | `SUM(PedidoVenda.ValorTotal) do mes` | Bar + Line (meta) | Diario |
| Receita por Vendedor | `SUM(PedidoVenda.ValorTotal) GROUP BY Vendedor` | Grouped bar | Diario |
| Receita por Territorio | `SUM GROUP BY Territorio` | Choropleth map | Semanal |
| Novos vs Recorrentes | `Receita de clientes com 1o pedido vs demais` | Stacked bar | Mensal |
| Atingimento de Meta | `ReceitaReal / MetaVenda × 100` | Bullet chart por vendedor | Diario |
| CLV (Customer Lifetime Value) | `ReceitaMedia × FrequenciaCompra × TempoVidaCliente` | Card | Mensal |

#### KPIs de Campo (Visitas + Despesas)

| KPI | Formula | Grafico | Refresh |
|-----|---------|---------|---------|
| Visitas Hoje | `COUNT WHERE Data = HOJE AND VendedorId = logado` | Card destaque | Tempo real |
| Efetividade de Visitas | `VisitasComPedido / TotalVisitas × 100` | Gauge | Semanal |
| Custo por Visita | `TotalDespesas / TotalVisitas` | Card com trend | Mensal |
| Despesa Total Mes | `SUM(DespesaItem.Valor) do mes GROUP BY Vendedor` | Stacked bar | Diario |
| Despesas Pendentes Aprovacao | `COUNT(RelatorioDespesa) WHERE Status = Enviado` | Badge | Tempo real |
| Cobertura Geografica | `ClientesVisitados / TotalClientesTerritorio × 100` | Gauge por territorio | Mensal |
| Clientes sem Visita > 30d | `COUNT WHERE UltimaVisita < HOJE - 30` | Lista com acao | Diario |
| ROI de Visitas | `ReceitaGeradaPosVisita / CustoDasVisitas` | Card | Mensal |

#### KPIs de Clientes

| KPI | Formula | Grafico | Refresh |
|-----|---------|---------|---------|
| Total de Clientes Ativos | `COUNT WHERE Ativo = true AND ultimoPedido < 90 dias` | Card | Diario |
| Novos Clientes no Mes | `COUNT WHERE DataCadastro no mes corrente` | Card com trend | Diario |
| Churn (Clientes Perdidos) | `Clientes que nao compraram nos ultimos 90 dias / Total` | Card alerta | Mensal |
| Classificacao ABC | `% receita por grupo A/B/C` | Donut | Mensal |
| NPS (futuro) | `(Promotores - Detratores) / Total × 100` | Gauge | Trimestral |

### 4.4 Paginas Frontend

| Pagina | Rota | Descricao |
|--------|------|-----------|
| `CrmDashboardPage` | `/crm/dashboard` | Dashboard principal com tabs por role ou auto-deteccao |
| `RelatorioFunilPage` | `/crm/relatorios/funil` | Funil detalhado com drill-down por periodo/vendedor |
| `RelatorioPerformancePage` | `/crm/relatorios/performance` | Comparativo de vendedores + ranking |
| `RelatorioDespesasPage` | `/crm/relatorios/despesas` | Analise de despesas por vendedor/categoria/periodo |
| `RelatorioForecastPage` | `/crm/relatorios/forecast` | Previsao de vendas (3 metodos) |

### 4.5 Endpoints API

```
# Dashboard
GET  /api/crm/dashboard/resumo                  (KPIs principais)
GET  /api/crm/dashboard/pipeline-summary         (funil com valores por etapa)
GET  /api/crm/dashboard/atividades-hoje           (agenda do dia)
GET  /api/crm/dashboard/receita-periodo           (receita com comparativo)
GET  /api/crm/dashboard/performance-vendedores    (ranking de vendedores)
GET  /api/crm/dashboard/clientes-sem-visita       (lista de clientes inativos)
GET  /api/crm/dashboard/despesas-resumo           (despesas por vendedor/categoria)
GET  /api/crm/dashboard/forecast                  (previsao de vendas)

# Relatorios
GET  /api/crm/relatorios/funil                    (dados completos do funil)
GET  /api/crm/relatorios/conversao-etapas         (taxa conversao por etapa)
GET  /api/crm/relatorios/motivos-perda            (analise de perdas)
GET  /api/crm/relatorios/performance-detalhado    (metricas por vendedor)
GET  /api/crm/relatorios/despesas-detalhado       (despesas com filtros)
GET  /api/crm/relatorios/forecast-detalhado       (forecast com 3 metodos)
```

### 4.6 Permissoes Adicionais

```csharp
public static class DashboardCRM
{
    public const string View         = "Permissions.CRM.Dashboard.View";
    public const string ViewEquipe   = "Permissions.CRM.Dashboard.ViewEquipe";   // gerente
    public const string ViewEmpresa  = "Permissions.CRM.Dashboard.ViewEmpresa";  // diretor
}

public static class Relatorios
{
    public const string View          = "Permissions.CRM.Relatorios.View";
    public const string Funil         = "Permissions.CRM.Relatorios.Funil";
    public const string Performance   = "Permissions.CRM.Relatorios.Performance";
    public const string Despesas      = "Permissions.CRM.Relatorios.Despesas";
    public const string Forecast      = "Permissions.CRM.Relatorios.Forecast";
    public const string Exportar      = "Permissions.CRM.Relatorios.Exportar";
}
```

### 4.7 Migration

```
AddCrmDashboardViews — Materialized Views para KPIs pesados:
  mv_crm_pipeline_summary, mv_crm_receita_mensal,
  mv_crm_performance_vendedor, mv_crm_visitas_stats
  + indices para consultas frequentes
```

---

## FASE 5 — Avancado

> **Objetivo:** Lead management, campanhas de vendas, comodatos de equipamentos e automacoes.

### 5.1 Entidades de Dominio

#### Dominios Adicionais

| Dominio | Codigo | Exemplos |
|---------|--------|----------|
| `StatusLead` | `status-lead` | Novo, Contatado, Qualificado, Convertido, Descartado |
| `TipoCampanha` | `tipos-campanha` | Promocao, Lancamento, Reativacao, Fidelizacao |
| `StatusEquipamento` | `status-equipamento-comodato` | Em Uso, Em Manutencao, Devolvido, Extraviado |
| `TipoEquipamento` | `tipos-equipamento-comodato` | Edger, Lensometer, Auto Refractor, Display |

#### Entidades de Negocio

```
Lead
├── Codigo (int, auto-incremental)
├── NomeEmpresa (string) — nome da otica/prospect
├── NomeContato (string)
├── Cargo (string?)
├── Email (string?)
├── Telefone (string?)
├── Celular (string?)
├── Endereco, Cidade, Estado, CEP
├── OrigemId (FK → Dominio)
├── StatusLeadId (FK → Dominio)
├── NivelInteresseId (FK → Dominio)
├── VendedorDesignadoId (FK → Funcionario, nullable)
├── Score (int, 0-100) — pontuacao de qualificacao
├── PotencialMensal (decimal?) — estimativa de faturamento
├── QuantidadeFuncionarios (int?)
├── Observacoes (string?)
├── DataPrimeiroContato (DateTime?)
├── DataUltimoContato (DateTime?)
├── DataConversao (DateTime?) — quando virou cliente
├── ClienteConvertidoId (FK → Cliente, nullable) — vinculo apos conversao
├── MotivoDescarte (string?) — se descartado
└── DataCadastro, DataAtualizacao, Ativo
```

```
LeadHistorico
├── LeadId (FK → Lead)
├── StatusAnteriorId (FK → Dominio, nullable)
├── StatusNovoId (FK → Dominio)
├── UsuarioId (FK → ApplicationUser)
├── DataMudanca (DateTime)
├── Observacao (string?)
```

```
Campanha
├── Codigo (int, auto-incremental)
├── Nome (string)
├── TipoCampanhaId (FK → Dominio)
├── Descricao (string?)
├── DataInicio (DateTime)
├── DataFim (DateTime)
├── MetaReceita (decimal?)
├── MetaNovasContas (int?)
├── OrcamentoTotal (decimal?)
├── ResponsavelId (FK → Funcionario)
├── Ativa (bool)
└── DataCadastro, DataAtualizacao
```

```
CampanhaCliente (clientes-alvo da campanha)
├── CampanhaId (FK → Campanha)
├── ClienteId (FK → Cliente)
├── VendedorId (FK → Funcionario) — responsavel por este cliente na campanha
├── Contatado (bool)
├── DataContato (DateTime?)
├── Resultado (string?)
├── PedidoGeradoId (FK → PedidoVenda, nullable)
└── ValorGerado (decimal?)
```

```
EquipamentoComodato
├── Codigo (int, auto-incremental)
├── ClienteId (FK → Cliente)
├── TipoEquipamentoId (FK → Dominio)
├── StatusEquipamentoId (FK → Dominio)
├── Marca (string?)
├── Modelo (string?)
├── NumeroSerie (string?)
├── DataEntrega (DateTime)
├── DataDevolucaoPrevista (DateTime?)
├── DataDevolucaoReal (DateTime?)
├── ValorEquipamento (decimal) — valor patrimonial
├── CondicaoContratual (string?) — volume minimo, exclusividade, etc.
├── VendedorResponsavelId (FK → Funcionario)
├── Observacoes (string?)
├── UltimaManutencao (DateTime?)
├── ProximaManutencao (DateTime?)
└── DataCadastro, DataAtualizacao, Ativo
```

```
EquipamentoComodatoHistorico
├── EquipamentoComodatoId (FK → EquipamentoComodato)
├── StatusAnteriorId (FK → Dominio, nullable)
├── StatusNovoId (FK → Dominio)
├── UsuarioId (FK → ApplicationUser)
├── DataMudanca (DateTime)
├── Observacao (string?)
```

### 5.2 Paginas Frontend

| Pagina | Rota | Tipo | Descricao |
|--------|------|------|-----------|
| `LeadsListPage` | `/crm/leads` | ListPage | Lista de leads com scoring, KPIs (novos, contatados, convertidos) |
| `LeadDetailDialog` | — | Dialog | Detalhe com timeline de interacoes |
| `LeadFormDialog` | — | Dialog | Criar/editar lead + converter para cliente |
| `CampanhasListPage` | `/crm/campanhas` | ListPage | Campanhas ativas e encerradas |
| `CampanhaDetailPage` | `/crm/campanhas/:id` | Page | Detalhe da campanha com progresso e clientes-alvo |
| `CampanhaFormDialog` | — | Dialog | Criar/editar campanha |
| `ComodatosListPage` | `/crm/comodatos` | ListPage | Equipamentos em comodato com status |
| `ComodatoDetailDialog` | — | Dialog | Detalhe do equipamento com historico |
| `ComodatoFormDialog` | — | Dialog | Registrar novo comodato |

### 5.3 Funcionalidade: Conversao Lead → Cliente

Quando um lead e qualificado e convertido:

1. Vendedor clica "Converter para Cliente" no `LeadDetailDialog`
2. Sistema abre `ClienteFormDialog` pre-preenchido com dados do lead (nome, endereco, contato)
3. Vendedor completa dados adicionais (CNPJ, IE, etc.)
4. Ao salvar, sistema:
   - Cria o `Cliente` + `Pessoa`
   - Cria o `PerfilCrmCliente` vinculado
   - Cria `ContatoCrm` com dados do lead
   - Atualiza `Lead.ClienteConvertidoId` e `Lead.Status = Convertido`
   - Cria `OportunidadeHistorico` com evento de conversao

### 5.4 Permissoes Adicionais

```csharp
public static class Leads
{
    public const string View     = "Permissions.CRM.Leads.View";
    public const string Create   = "Permissions.CRM.Leads.Create";
    public const string Edit     = "Permissions.CRM.Leads.Edit";
    public const string Delete   = "Permissions.CRM.Leads.Delete";
    public const string Converter = "Permissions.CRM.Leads.Converter";
    public const string Descartar = "Permissions.CRM.Leads.Descartar";
}

public static class Campanhas
{
    public const string View   = "Permissions.CRM.Campanhas.View";
    public const string Create = "Permissions.CRM.Campanhas.Create";
    public const string Edit   = "Permissions.CRM.Campanhas.Edit";
    public const string Delete = "Permissions.CRM.Campanhas.Delete";
}

public static class Comodatos
{
    public const string View   = "Permissions.CRM.Comodatos.View";
    public const string Create = "Permissions.CRM.Comodatos.Create";
    public const string Edit   = "Permissions.CRM.Comodatos.Edit";
    public const string Delete = "Permissions.CRM.Comodatos.Delete";
}
```

### 5.5 Endpoints API

```
# Leads
GET/POST       /api/crm/leads
GET/PUT/DELETE  /api/crm/leads/{id}
GET            /api/crm/leads/proximo-codigo
POST           /api/crm/leads/{id}/converter              (converter para cliente)
POST           /api/crm/leads/{id}/descartar              (descartar lead)
GET            /api/crm/leads/{id}/historico

# Campanhas
GET/POST       /api/crm/campanhas
GET/PUT/DELETE  /api/crm/campanhas/{id}
GET            /api/crm/campanhas/proximo-codigo
GET            /api/crm/campanhas/{id}/clientes           (clientes-alvo)
POST           /api/crm/campanhas/{id}/clientes           (adicionar clientes)
PUT            /api/crm/campanhas/{id}/clientes/{cId}     (atualizar resultado)

# Comodatos
GET/POST       /api/crm/comodatos
GET/PUT/DELETE  /api/crm/comodatos/{id}
GET            /api/crm/comodatos/proximo-codigo
GET            /api/crm/comodatos/cliente/{clienteId}     (comodatos de um cliente)
GET            /api/crm/comodatos/{id}/historico
POST           /api/crm/comodatos/{id}/manutencao         (registrar manutencao)
POST           /api/crm/comodatos/{id}/devolver           (registrar devolucao)
```

### 5.6 Migration

```
AddCrmLeadsCampanhasComodatos — Lead, LeadHistorico, Campanha, CampanhaCliente,
                                 EquipamentoComodato, EquipamentoComodatoHistorico
                                 + seeds de dominios
```

---

## Resumo de Entidades por Fase

| Fase | Entidades de Negocio | Dominios | Total |
|------|---------------------|----------|-------|
| **1** | PerfilCrmCliente, EtapaPipeline, Oportunidade, OportunidadeProduto, OportunidadeHistorico, ContatoCrm, Atividade | 8 | **15** |
| **2** | Visita, VisitaFoto, RelatorioDespesa, DespesaItem, DespesaComprovante, RelatorioDespesaHistorico | 4 | **10** |
| **3** | Territorio, RotaVisita, RotaVisitaParada | 0 | **3** |
| **4** | (Materialized Views, sem entidades novas) | 0 | **0** |
| **5** | Lead, LeadHistorico, Campanha, CampanhaCliente, EquipamentoComodato, EquipamentoComodatoHistorico | 4 | **10** |
| **Total** | **22 entidades** | **16 dominios** | **38** |

## Resumo de Paginas por Fase

| Fase | Paginas/Dialogs | Rotas |
|------|-----------------|-------|
| **1** | CrmDashboardPage, ContatosCrmListPage, ContatoCrmDetail/Form, OportunidadesListPage, OportunidadeDetail/Form, PipelinePage (Kanban), AtividadesListPage, AtividadeForm, PerfilCrmForm | 5 rotas |
| **2** | VisitasListPage, VisitaDetail/Form, CheckIn/CheckOut, DespesasListPage, DespesaRelatorioForm/Detail, DespesaAprovacao | 4 rotas |
| **3** | MapaClientesPage, TerritoriosListPage, TerritorioForm, RotaPlanejamento | 3 rotas |
| **4** | CrmDashboardPage (expandido), 4 paginas de relatorio | 5 rotas |
| **5** | LeadsListPage, LeadDetail/Form, CampanhasListPage, CampanhaDetail/Form, ComodatosListPage, ComodatoDetail/Form | 3 rotas |
| **Total** | **~30 componentes** | **20 rotas** |

## Resumo de Permissoes

| Fase | Modulo | Permissoes |
|------|--------|------------|
| **1** | CRM, Dashboard, Contatos, Oportunidades, Pipeline, Atividades, PerfilCliente | ~22 |
| **2** | Visitas, Despesas | ~16 |
| **3** | Mapa, Territorios | ~6 |
| **4** | DashboardCRM, Relatorios | ~8 |
| **5** | Leads, Campanhas, Comodatos | ~14 |
| **Total** | | **~66 permissoes** |

---

## Dependencias com Modulos Existentes

```
CRM depende de:
├── Cadastros
│   ├── Cliente (FK em PerfilCrmCliente, Oportunidade, Visita, Lead, Campanha, Comodato)
│   ├── Pessoa (via Cliente.PessoaId — dados de endereco, contato)
│   └── Funcionario (como Vendedor em todas as entidades)
│
├── Vendas
│   ├── PedidoVenda (vinculo em Oportunidade.PedidoVendaId apos conversao)
│   ├── TabelaPreco (referencia para valores em oportunidades)
│   ├── RegiaoVenda (vinculo com Territorio)
│   └── MetaVenda (para KPIs de atingimento)
│
├── Produtos
│   └── Produto (itens da oportunidade em OportunidadeProduto)
│
├── Financeiro
│   └── ContaReceber (para KPIs de inadimplencia e CLV)
│
└── Chat
    └── WhatsApp/iChat (historico de comunicacao no timeline do cliente)
```

---

## Tecnologias a Instalar por Fase

### Fase 1
```bash
# Frontend - Kanban
npm install @hello-pangea/dnd
```

### Fase 2
```bash
# Backend - nenhuma nova dependencia
# Frontend - nenhuma nova dependencia (upload de fotos via API existente)
```

### Fase 3
```bash
# Backend - PostGIS + NTS
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.NetTopologySuite

# Frontend - Google Maps
npm install @vis.gl/react-google-maps @googlemaps/markerclusterer
npm install deck.gl @deck.gl/google-maps    # para heatmaps
```

### Fase 4
```bash
# Frontend - Charts
npm install recharts
# ou
npm install @nivo/core @nivo/bar @nivo/line @nivo/pie @nivo/funnel @nivo/geo
```

### Fase 5
```bash
# Nenhuma nova dependencia
```
