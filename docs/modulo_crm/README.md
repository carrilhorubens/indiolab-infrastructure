# Modulo CRM - Documentacao de Pesquisa

> Pesquisa completa para desenvolvimento do modulo CRM do OpticalCore ERP.
> Data: 2026-03-31

---

## Indice de Documentos

| # | Documento | Descricao | Linhas |
|---|-----------|-----------|--------|
| 1 | [pesquisa_crm_completa.md](pesquisa_crm_completa.md) | Funcionalidades core de CRM: Contas/Contatos, Leads, Pipeline, Atividades, Automacao, Cotacoes, Segmentacao, SFA, Servico ao Cliente, Integracoes ERP, Comparativo de plataformas, Modelo de dados (48 entidades) | ~1500 |
| 2 | [pesquisa_visitas_despesas.md](pesquisa_visitas_despesas.md) | Gestao de visitas (check-in/check-out GPS), Despesas de viagem, Workflow de aprovacao, OCR de recibos, Modelo de dados (10 entidades), Mobile-first, Offline sync | ~700 |
| 3 | [estudo_mapas_geolocalizacao.md](estudo_mapas_geolocalizacao.md) | Google Maps vs alternativas, Clustering, Territorios, Rotas otimizadas, PostGIS, Heatmaps (deck.gl), Geocoding, React libraries, Custos estimados | ~650 |
| 4 | [dashboard_kpis_detalhado.md](dashboard_kpis_detalhado.md) | 50+ KPIs com formulas (Pipeline, Atividades, Receita, Clientes, Field Sales, Leads), Forecasting (4 metodos), Layout de dashboards por role, Chart-type matrix | ~1500 |
| 5 | [pesquisa_crm_laboratorio_optico.md](pesquisa_crm_laboratorio_optico.md) | CRM especifico para laboratorio optico B2B: ciclo de vendas, mix de produtos, comodato de equipamentos, integracao com modulos existentes do OpticalCore | ~600 |

---

## Resumo Executivo

### O que e o Modulo CRM do OpticalCore?

Modulo de Gestao de Relacionamento com Clientes (CRM) integrado ao ERP, focado no contexto B2B de **laboratorio optico** que vende para **opticas**. Combina funcionalidades classicas de CRM com diferenciais competitivos.

### Diferenciais Planejados

1. **Visitas com Despesas Integradas** - Consultores registram visitas (GPS check-in/check-out), geram relatorios de despesas com fotos de recibos, e submetem para aprovacao - tudo em um unico sistema
2. **Mapa Interativo** - Visualizacao de clientes, territorios de vendas e areas de atendimento em mapa (Google Maps + PostGIS), com heatmaps de performance e rotas otimizadas
3. **Dashboard com 50+ KPIs** - Paineis por role (executivo, gerente, consultor) com metricas de pipeline, atividades, receita, campo e leads
4. **Integracao Nativa com ERP** - Reusa entidades existentes (Cliente, Produto, TabelaPreco, RegiaoVenda, MetaVenda, Chat/WhatsApp)

### Stack Tecnica Recomendada

| Componente | Tecnologia |
|------------|-----------|
| Maps | Google Maps API + `@vis.gl/react-google-maps` + deck.gl |
| Spatial DB | PostGIS (extensao PostgreSQL) |
| Charts | Recharts ou Nivo (React) |
| OCR Recibos | Google Cloud Vision ou Mindee |
| Geocoding | Google Geocoding API |
| Route Optimization | Google Routes API (`optimizeWaypointOrder`) |

### Faseamento Sugerido

| Fase | Escopo | Entidades Principais |
|------|--------|---------------------|
| **Fase 1 - Core** | Contas/Contatos CRM, Pipeline/Oportunidades, Atividades, Visitas com Check-in, Dashboard basico | PerfilCrmCliente, Contato, Oportunidade, Atividade, Visita, Etapa Pipeline |
| **Fase 2 - Campo** | Despesas de viagem, Fotos de recibos, Workflow de aprovacao, Mapa de clientes, Territorios | RelatorioDespesa, DespesaItem, Comprovante, Territorio |
| **Fase 3 - Analytics** | Dashboard completo (50+ KPIs), Forecasting, Segmentacao avancada (RFM/ABC), Heatmaps, Rotas | Views agregadas, Materialized Views |
| **Fase 4 - Avancado** | Lead scoring, Automacao de workflows, Comodato de equipamentos, NPS/CSAT, Knowledge Base | Lead, LeadScore, Automacao, EquipamentoComodato |

### Integracao com Modulos Existentes

```
CRM
 ├── Cadastros (Cliente/Pessoa → PerfilCrmCliente 1:1)
 ├── Produtos (catalogo de lentes/tratamentos)
 ├── Vendas (TabelaPreco, RegiaoVenda, MetaVenda, Pedido)
 ├── Financeiro (ContaReceber, limites de credito)
 ├── Estoque (disponibilidade de produtos)
 └── Chat/WhatsApp (historico de comunicacao)
```

---

## Como Usar Esta Documentacao

1. **Para entender o escopo completo** → Leia `pesquisa_crm_completa.md`
2. **Para planejar visitas e despesas** → Leia `pesquisa_visitas_despesas.md`
3. **Para implementar mapas** → Leia `estudo_mapas_geolocalizacao.md`
4. **Para definir KPIs do dashboard** → Leia `dashboard_kpis_detalhado.md`
5. **Para contexto do setor optico** → Leia `pesquisa_crm_laboratorio_optico.md`
