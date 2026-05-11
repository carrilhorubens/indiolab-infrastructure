# CRM Dashboard: KPIs, Formulas e Design - Pesquisa Detalhada

**Data:** 31/03/2026
**Objetivo:** Definir KPIs com formulas exatas, visualizacoes recomendadas e padroes de layout para o dashboard do modulo CRM do OpticalCore ERP (B2B, laboratorio optico).
**Complementa:** `estudo_crm.md` (secao 6 - Dashboard e KPIs)

---

## Indice

1. [Pipeline de Vendas](#1-pipeline-de-vendas)
2. [Atividades Comerciais](#2-atividades-comerciais)
3. [Receita e Metas](#3-receita-e-metas)
4. [Clientes](#4-clientes)
5. [Vendas de Campo / Visitas](#5-vendas-de-campo--visitas)
6. [Gestao de Leads](#6-gestao-de-leads)
7. [Forecasting](#7-forecasting)
8. [Design do Dashboard](#8-design-do-dashboard)
9. [Dashboards de Referencia](#9-dashboards-de-referencia)

---

## 1. Pipeline de Vendas

### 1.1 Valor Total do Pipeline

**Definicao:** Soma do valor estimado de todas as oportunidades abertas (nao encerradas) em um dado periodo.

```
Pipeline Total = SUM(valor_estimado) WHERE status = 'aberta'
```

**Segmentacoes obrigatorias:**
- Por etapa do funil (Prospeccao, Qualificacao, Proposta, Negociacao, Fechamento)
- Por periodo (mes, trimestre, ano)
- Por vendedor/consultor
- Por territorio/regiao
- Por segmento de cliente (porte, canal, setor)
- Por produto/linha de produto

**Visualizacao:** Stacked bar chart (etapas empilhadas) + KPI card com valor total + sparkline de tendencia 30 dias.

---

### 1.2 Pipeline Ponderado (Weighted Pipeline)

**Definicao:** Valor ajustado pela probabilidade de fechamento de cada etapa.

```
Pipeline Ponderado = SUM(valor_estimado * probabilidade_etapa)
```

**Probabilidades tipicas por etapa (referencia Salesforce/HubSpot):**

| Etapa | Probabilidade Tipica |
|-------|---------------------|
| Prospeccao / Lead Qualificado | 10% |
| Descoberta / Qualificacao | 20% |
| Proposta Enviada | 40% |
| Negociacao / Avaliacao | 60% |
| Compromisso Verbal | 80% |
| Contrato / Fechamento | 90-95% |

**Nota:** Essas probabilidades devem ser calibradas com dados historicos reais do laboratorio. Revisao trimestral recomendada.

**Visualizacao:** KPI card comparando Pipeline Ponderado vs Meta do periodo. Gauge chart mostrando cobertura.

---

### 1.3 Velocidade do Pipeline (Pipeline Velocity)

**Definicao:** Indica quanto dinheiro o pipeline gera por dia. Metrica composta que combina volume, conversao, ticket e velocidade.

```
Pipeline Velocity = (Nro_Oportunidades * Win_Rate * Ticket_Medio) / Ciclo_Medio_Dias
```

**Exemplo pratico:**
- 50 oportunidades abertas
- Win rate: 25%
- Ticket medio: R$ 15.000
- Ciclo medio: 45 dias
- Velocity = (50 * 0.25 * 15000) / 45 = R$ 4.166,67/dia

**Por que importa:** Unica metrica que captura saude geral do pipeline. Se qualquer um dos 4 componentes melhora, a velocity sobe.

**Visualizacao:** KPI card com tendencia (sparkline). Line chart mensal mostrando evolucao. Decomposicao em 4 componentes lado a lado.

---

### 1.4 Taxas de Conversao

#### Lead para Oportunidade (L2O)

```
L2O Rate = (Leads convertidos em oportunidade no periodo / Total de leads no periodo) * 100
```

**Benchmark B2B:** 10-20% (varia por industria; optica/laboratorio tende a 15-25% por ser nicho).

#### Oportunidade para Ganho (Win Rate)

```
Win Rate = (Oportunidades ganhas / Oportunidades decididas) * 100
```

**IMPORTANTE:** "Oportunidades decididas" = ganhas + perdidas. NAO incluir oportunidades ainda abertas. Incluir oportunidades abandonadas e "sem decisao" distorceria a metrica.

**Variante alternativa (mais conservadora):**
```
Win Rate (conservador) = Oportunidades ganhas / (Ganhas + Perdidas + Abandonadas) * 100
```

**Benchmark B2B:** 20-30% (media geral). Empresas de alto desempenho: 35-45%.

#### Conversao Etapa-a-Etapa (Stage-to-Stage)

```
Conversao_Etapa[N→N+1] = (Oportunidades que avancarao de N para N+1) / (Oportunidades que entraram em N) * 100
```

**Aplicacao:** Identificar gargalos no funil. Se a conversao de "Proposta" para "Negociacao" e muito baixa, o problema pode ser precificacao, proposta mal elaborada ou falta de follow-up.

**Visualizacao:** Funnel chart com percentuais entre etapas. Tabela detalhada com volume e % por etapa. Heatmap mensal por etapa.

---

### 1.5 Win Rate

Ja definido acima (1.4). Segmentacoes adicionais recomendadas:

- **Por vendedor:** Identifica quem precisa de coaching
- **Por fonte do lead:** Qual canal gera leads de maior qualidade
- **Por produto/servico:** Quais ofertas tem maior aceitacao
- **Por porte de cliente:** Grandes deals tem win rate diferente de pequenos
- **Por concorrente:** Quando o concorrente X esta envolvido, qual o win rate

**Visualizacao:** Donut chart geral + bar chart comparativo por vendedor. Trend line mensal.

---

### 1.6 Analise de Motivos de Perda (Loss Reasons)

**Definicao:** Categorizacao estruturada de por que oportunidades foram perdidas.

**Categorias recomendadas:**
1. Preco / Orcamento
2. Timing (cliente nao esta pronto)
3. Concorrente escolhido
4. Requisitos tecnicos nao atendidos
5. Falta de decisao (ghosting)
6. Mudanca de prioridade do cliente
7. Relacionamento / confianca
8. Produto/servico inadequado
9. Processo de compra interno do cliente
10. Outro (com campo texto obrigatorio)

**Metricas derivadas:**
```
% Perda por Motivo = (Perdas por motivo X / Total de perdas) * 100
Valor Perdido por Motivo = SUM(valor) WHERE motivo_perda = X
```

**Visualizacao:** Horizontal bar chart (Pareto) ordenado por frequencia. Donut chart por valor perdido. Trend line por motivo ao longo do tempo.

---

### 1.7 Ticket Medio (Average Deal Size)

```
Ticket Medio = SUM(valor_oportunidades_ganhas) / COUNT(oportunidades_ganhas)
```

**Segmentacoes:**
- Por periodo (detectar tendencia de aumento/queda)
- Por vendedor
- Por produto/linha
- Por segmento de cliente
- Por territorio

**Visualizacao:** KPI card com comparativo periodo anterior (seta verde/vermelha). Box plot por segmento.

---

### 1.8 Cobertura de Pipeline (Pipeline Coverage Ratio)

```
Pipeline Coverage = Valor Total do Pipeline / Meta do Periodo
```

**Benchmarks:**
- < 2x: Pipeline insuficiente (risco de nao atingir meta)
- 2x - 3x: Saudavel
- 3x - 4x: Ideal para ciclos longos
- > 5x: Pipeline inflado (revisar qualidade das oportunidades)

**Variante ponderada:**
```
Pipeline Coverage Ponderado = Pipeline Ponderado / Meta do Periodo
```

**Recomendacao:** Usar a versao ponderada como metrica principal e a absoluta como secundaria.

**Visualizacao:** Gauge chart com faixas coloridas (vermelho < 2x, amarelo 2-3x, verde 3-4x). KPI card.

---

### 1.9 Ciclo de Vendas (Sales Cycle Length)

```
Ciclo Medio = AVG(data_fechamento - data_criacao_oportunidade) em dias
```

**Variantes importantes:**
```
Ciclo por Etapa = AVG(data_saida_etapa - data_entrada_etapa) em dias
Ciclo Lead-to-Close = AVG(data_fechamento - data_criacao_lead) em dias
Ciclo por Porte = AVG agrupado por porte do cliente
```

**Benchmark B2B:**
- Deals pequenos (< R$ 5k): 14-30 dias
- Deals medios (R$ 5k-50k): 30-90 dias
- Deals grandes (> R$ 50k): 90-180+ dias

**Visualizacao:** KPI card (media geral). Box plot por segmento/porte. Histogram de distribuicao. Heatmap por etapa mostrando onde os deals "empacam".

---

### 1.10 Oportunidades Paradas (Stalled Deals)

**Definicao:** Oportunidades que nao mudaram de etapa alem de um limiar definido.

```
Stalled = oportunidades WHERE (HOJE - data_ultima_mudanca_etapa) > limiar_dias_por_etapa
```

**Limiares sugeridos:**
| Etapa | Limiar (dias) |
|-------|--------------|
| Prospeccao | 14 |
| Qualificacao | 21 |
| Proposta | 14 |
| Negociacao | 21 |
| Fechamento | 7 |

**Visualizacao:** Lista/tabela com destaque em vermelho. Badge no KPI card mostrando quantidade de deals parados.

---

### 1.11 Pipeline por Idade (Aging Analysis)

```
Idade da Oportunidade = HOJE - data_criacao_oportunidade
```

**Faixas recomendadas:** 0-30 dias, 31-60 dias, 61-90 dias, 91-120 dias, 120+ dias.

**Visualizacao:** Stacked bar chart por faixa de idade. Correlacionar com win rate (deals mais velhos tem win rate menor).

---

## 2. Atividades Comerciais

### 2.1 Volume de Atividades por Vendedor

```
Atividades_Rep = COUNT(atividades) WHERE vendedor = X AND periodo = Y
```

**Tipos de atividade a rastrear:**
- Ligacoes (realizadas, atendidas, duracao)
- E-mails (enviados, abertos, respondidos)
- Reunioes (presenciais, video, telefone)
- Visitas de campo
- Propostas enviadas
- Follow-ups
- Demonstracoes / apresentacoes
- Mensagens WhatsApp

**Granularidade:** Dia, semana, mes. Comparativo por vendedor.

**Visualizacao:** Bar chart agrupado por tipo de atividade e vendedor. Heatmap semanal (dia vs hora) mostrando picos de atividade.

---

### 2.2 Frequencia de Visita por Cliente

```
Frequencia_Visita = COUNT(visitas ao cliente X) / periodo_em_meses
Intervalo_Medio = AVG(data_visita[N+1] - data_visita[N]) em dias
```

**Classificacao por frequencia planejada:**
- Clientes A (alto valor): visita semanal ou quinzenal
- Clientes B (medio valor): visita mensal
- Clientes C (baixo valor): visita trimestral
- Clientes D (prospect): sob demanda

```
Compliance_Visita = (Visitas realizadas no prazo / Visitas planejadas) * 100
```

**Visualizacao:** Tabela com semaforo (verde = em dia, amarelo = proximo do vencimento, vermelho = atrasado). Calendar heatmap.

---

### 2.3 Atividades para Fechar um Negocio

```
Atividades_por_Deal = AVG(COUNT(atividades vinculadas a oportunidade ganhas))
```

**Segmentado por:** Tipo de atividade, porte do deal, produto, vendedor.

**Insight:** Se vendedores de alto desempenho fazem em media 12 touchpoints antes de fechar, e vendedores de baixo desempenho fazem 5, ha uma oportunidade de coaching.

**Visualizacao:** Bar chart comparativo (top performers vs media vs bottom). Scatter plot (atividades vs valor do deal).

---

### 2.4 Tempo de Resposta a Leads

```
Tempo_Resposta = AVG(data_primeiro_contato - data_criacao_lead) em minutos/horas
```

**Benchmarks (Harvard Business Review / InsideSales.com):**
- Contato em < 5 minutos: 21x mais chance de qualificar vs 30 min
- Contato em < 1 hora: 7x mais chance vs 2 horas
- Apos 24h: lead praticamente frio

**Distribuicao recomendada:**
- < 5 min (excelente)
- 5-30 min (bom)
- 30 min - 2h (aceitavel)
- 2h - 24h (ruim)
- > 24h (critico)

**Visualizacao:** KPI card (tempo medio). Histogram de distribuicao. Alerta automatico para leads sem contato > 1h.

---

### 2.5 Taxa de Follow-up

```
Follow_Up_Rate = (Leads/Oportunidades com follow-up no prazo / Total que precisavam de follow-up) * 100
```

**Visualizacao:** KPI card com trend. Lista de pendencias por vendedor.

---

### 2.6 Ratio Atividade-para-Oportunidade

```
Activity_to_Opp = COUNT(atividades no periodo) / COUNT(novas oportunidades no periodo)
```

**Interpretacao:** Quantas atividades sao necessarias para gerar uma nova oportunidade. Quanto menor, mais eficiente o vendedor.

**Visualizacao:** Bar chart por vendedor. Trend line mensal.

---

### 2.7 Touchpoints ate Conversao

```
Touchpoints_Conversao = AVG(COUNT(interacoes com lead) para leads que converteram em oportunidade)
```

**Tipos de touchpoint:** Qualquer interacao registrada (ligacao, email, visita, reuniao, WhatsApp, evento).

**Visualizacao:** Histogram de distribuicao. Comparativo entre leads convertidos vs nao convertidos.

---

## 3. Receita e Metas

### 3.1 Receita Realizada vs Meta

```
Receita_Periodo = SUM(valor_oportunidades_ganhas) WHERE data_fechamento IN periodo
Meta_Atingimento = (Receita_Periodo / Meta_Periodo) * 100
Gap = Meta_Periodo - Receita_Periodo
```

**Periodos:** Mensal (MRR), Trimestral (QRR), Anual (ARR).

**Visualizacao:** Bullet chart (realizado vs meta vs stretch). Line chart com acumulado mensal + meta acumulada. KPI card com % de atingimento e valor faltante.

---

### 3.2 Receita por Dimensao

**Segmentacoes obrigatorias:**
- Por vendedor/consultor (quota attainment individual)
- Por territorio/regiao
- Por produto/linha de produto
- Por segmento de cliente (porte, canal, setor)
- Por canal de aquisicao (indicacao, cold call, inbound, evento)

```
Receita_Dimensao = SUM(valor_ganho) GROUP BY dimensao
% Participacao = Receita_Dimensao / Receita_Total * 100
```

**Visualizacao:** Treemap (proporcao visual por dimensao). Stacked bar chart mensal. Tabela com ranking.

---

### 3.3 Receita Nova vs Recorrente

```
Receita_Nova = SUM(valor) WHERE cliente.primeira_compra = TRUE no periodo
Receita_Recorrente = SUM(valor) WHERE cliente.primeira_compra = FALSE no periodo
% Nova = Receita_Nova / Receita_Total * 100
```

**Em B2B (laboratorio optico):** A maior parte da receita tende a ser recorrente (clientes opticas comprando repetidamente). Receita nova vem de aquisicao de novos clientes opticas.

**Meta saudavel B2B:** 70-80% recorrente, 20-30% nova. Se receita nova cai abaixo de 15%, ha risco de estagnacao.

**Visualizacao:** Donut chart (nova vs recorrente). Stacked area chart mensal mostrando composicao ao longo do tempo.

---

### 3.4 Customer Lifetime Value (CLV / LTV)

```
CLV Simples = Ticket Medio * Frequencia de Compra Anual * Tempo Medio de Retencao (anos)
```

```
CLV com Margem = (Receita Media Anual por Cliente * Margem Bruta %) * Tempo Medio de Retencao
```

```
CLV Detalhado = SUM(t=1 ate T) [ (Receita_t - Custo_t) / (1 + taxa_desconto)^t ]
```

**Para laboratorio optico (B2B):**
- Receita media mensal por optica cliente: R$ X
- Tempo medio de retencao: Y anos
- Margem bruta: Z%
- CLV = X * 12 * Y * Z

**Segmentacoes:** Por porte de cliente, por regiao, por produto principal, por canal de aquisicao.

**Visualizacao:** KPI card (CLV medio). Histogram de distribuicao. Cohort analysis (CLV por safra de aquisicao).

---

### 3.5 Receita Media por Conta (ARPA)

```
ARPA Mensal = Receita Total Mensal / Numero de Contas Ativas
ARPA Anual = Receita Total Anual / Numero de Contas Ativas
```

**Variante por segmento:**
```
ARPA_Segmento = Receita_Segmento / Contas_Ativas_Segmento
```

**Visualizacao:** KPI card com trend. Bar chart por segmento. Line chart mensal.

---

### 3.6 Crescimento de Receita

```
Crescimento MoM = ((Receita_Mes_Atual - Receita_Mes_Anterior) / Receita_Mes_Anterior) * 100
Crescimento QoQ = ((Receita_Trimestre_Atual - Receita_Trimestre_Anterior) / Receita_Trimestre_Anterior) * 100
Crescimento YoY = ((Receita_Ano_Atual - Receita_Ano_Anterior) / Receita_Ano_Anterior) * 100
```

**CAGR (Compound Annual Growth Rate):**
```
CAGR = (Receita_Final / Receita_Inicial) ^ (1 / Numero_Anos) - 1
```

**Visualizacao:** Line chart com marcadores de periodo. KPI card com seta de tendencia e % de crescimento. Waterfall chart mostrando contribuicao por fator.

---

### 3.7 Quota Attainment (Atingimento de Meta)

```
Quota_Attainment = (Receita_Realizada / Meta_Individual) * 100
```

**Distribuicao da equipe:**
```
% Acima da Meta = COUNT(vendedores com QA >= 100%) / Total de vendedores * 100
```

**Benchmarks:**
- < 60%: Desempenho critico
- 60-80%: Abaixo da meta
- 80-100%: Proximo da meta
- 100-120%: Atingiu/superou
- > 120%: Destaque (possivel meta subdimensionada)

**Meta organizacional:** 60-70% dos vendedores devem atingir ou superar a meta. Se menos de 50% atingem, as metas podem estar irrealistas.

**Visualizacao:** Bullet chart por vendedor. Ranking table. Histogram de distribuicao de QA na equipe.

---

## 4. Clientes

### 4.1 Novos Clientes Adquiridos

```
Novos_Clientes = COUNT(clientes com primeira_compra no periodo)
Taxa_Aquisicao = Novos_Clientes / Total_Leads_Periodo * 100
```

**Segmentacoes:** Por vendedor, por canal de aquisicao, por territorio, por segmento.

**Visualizacao:** KPI card com comparativo periodo anterior. Bar chart mensal. Line chart de tendencia.

---

### 4.2 Taxa de Retencao de Clientes

```
Retencao = ((Clientes_Fim_Periodo - Novos_Clientes_Periodo) / Clientes_Inicio_Periodo) * 100
```

**Alternativa (Net Retention Rate para B2B com receita):**
```
NRR = (Receita_Inicio + Expansao - Contracao - Churn) / Receita_Inicio * 100
```

**Benchmarks B2B:**
- Retencao bruta > 85%: saudavel
- NRR > 100%: excelente (expansao compensa churn)
- NRR > 110%: classe mundial

**Visualizacao:** KPI card com trend. Cohort retention chart (tabela de retencao por safra). Line chart mensal.

---

### 4.3 Taxa de Churn

```
Churn Rate = (Clientes perdidos no periodo / Clientes no inicio do periodo) * 100
Revenue Churn = (Receita perdida no periodo / Receita no inicio do periodo) * 100
```

**Para laboratorio optico:** "Churn" = optica que parou de comprar por mais de X meses (definir limiar: 60, 90 ou 120 dias sem pedido).

**Net Revenue Churn:**
```
Net Revenue Churn = (Receita Perdida - Receita de Expansao) / Receita Inicio Periodo * 100
```
Se negativo, significa que a expansao supera o churn (excelente).

**Visualizacao:** KPI card (churn mensal). Trend line. Waterfall mostrando impacto de churn + expansao.

---

### 4.4 NPS e CSAT

#### Net Promoter Score (NPS)
```
NPS = % Promotores (9-10) - % Detratores (0-6)
```
Escala: -100 a +100. Benchmark B2B: > 30 e bom, > 50 e excelente, > 70 e classe mundial.

#### Customer Satisfaction Score (CSAT)
```
CSAT = (Respostas satisfeitas / Total de respostas) * 100
```

**Coleta:** Pesquisa pos-venda, pos-entrega, pos-visita. Integracao com WhatsApp para envio automatico.

**Visualizacao:** Gauge chart (NPS). Donut chart (promotores/neutros/detratores). Trend line mensal. Heatmap por vendedor/territorio.

---

### 4.5 Customer Engagement Score

**Definicao:** Score composto que mede o nivel de engajamento do cliente com base em multiplos sinais.

**Componentes sugeridos (pesos configuraveis):**

| Sinal | Peso Sugerido |
|-------|--------------|
| Pedidos nos ultimos 90 dias | 25% |
| Valor dos pedidos (vs historico) | 20% |
| Interacoes (ligacoes, emails, visitas) | 15% |
| Tempo desde ultima compra | 15% |
| Abertura de tickets/suporte | 10% |
| Resposta a pesquisas NPS/CSAT | 5% |
| Participacao em eventos/treinamentos | 5% |
| Login no portal (se houver) | 5% |

```
Engagement Score = SUM(sinal_normalizado * peso) => escala 0-100
```

**Classificacao:**
- 80-100: Altamente engajado (verde)
- 60-79: Engajado (azul)
- 40-59: Atencao necessaria (amarelo)
- 20-39: Risco (laranja)
- 0-19: Critico (vermelho)

**Visualizacao:** Distribuicao por faixa (bar chart). Lista de clientes em risco. Bubble chart (engagement vs receita vs tempo de retencao).

---

### 4.6 Top Clientes por Receita

```
Ranking = ORDER BY SUM(receita) DESC
Pareto = Top 20% dos clientes que geram ~80% da receita
```

**Analise ABC:**
- Classe A: Top 20% (geram ~80% receita)
- Classe B: Proximos 30% (geram ~15% receita)
- Classe C: Restantes 50% (geram ~5% receita)

**Visualizacao:** Pareto chart (barras + linha acumulada). Tabela rankeada com receita, % acumulado e classificacao ABC.

---

### 4.7 Clientes em Risco (Declining Orders)

```
Risco_Queda = clientes WHERE receita_periodo_atual < (receita_periodo_anterior * 0.7)
Risco_Inatividade = clientes WHERE dias_desde_ultimo_pedido > limiar
```

**Sinais de alerta combinados:**
1. Queda de > 30% na receita vs periodo anterior
2. Aumento no tempo entre pedidos
3. Reducao no mix de produtos comprados
4. Queda no engagement score
5. Reclamacoes/tickets abertos nao resolvidos
6. NPS detrator

**Score de Risco:**
```
Risco_Score = weighted_sum(sinais_normalizados) => 0-100 (maior = mais risco)
```

**Visualizacao:** Tabela com semaforo e ordenacao por risco. Alert cards para os mais criticos. Trend chart individual por cliente em risco.

---

### 4.8 Concentracao de Clientes (Customer Concentration Risk)

```
Herfindahl_Index = SUM((Receita_Cliente_i / Receita_Total)^2)
Top_Client_Share = Receita_Top_1_Cliente / Receita_Total * 100
Top_5_Share = SUM(Receita_Top_5) / Receita_Total * 100
Top_10_Share = SUM(Receita_Top_10) / Receita_Total * 100
```

**Limiares de risco:**
- Top 1 cliente > 15% da receita: risco alto
- Top 5 clientes > 40% da receita: risco moderado
- Top 10 clientes > 60% da receita: atencao

**Visualizacao:** Donut chart (top 5 + "outros"). Pareto chart. KPI card com % de concentracao e alerta visual.

---

## 5. Vendas de Campo / Visitas

### 5.1 Visitas por Dia/Semana por Vendedor

```
Visitas_Dia = COUNT(visitas concluidas) WHERE vendedor = X AND data = Y
Visitas_Semana = COUNT(visitas concluidas) WHERE vendedor = X AND semana = Y
Media_Visitas_Dia = Visitas_Periodo / Dias_Uteis_Periodo
```

**Benchmarks vendas de campo B2B:**
- Vendedor interno: 8-12 contatos/dia
- Vendedor de campo urbano: 4-6 visitas/dia
- Vendedor de campo regional: 2-4 visitas/dia (distancias maiores)

**Visualizacao:** Bar chart por vendedor (ranking). Calendar heatmap (intensidade por dia). KPI card com media.

---

### 5.2 Efetividade de Visita

```
Efetividade = (Visitas que geraram pedido / Total de visitas) * 100
Efetividade_Valor = SUM(valor_pedidos_gerados) / COUNT(visitas) => valor medio por visita
```

**Variantes:**
```
Efetividade_Pipeline = (Visitas que geraram ou avancaram oportunidade / Total de visitas) * 100
Efetividade_Ativacao = (Visitas a prospects que geraram primeira compra / Visitas a prospects) * 100
```

**Visualizacao:** KPI card com %. Bar chart por vendedor. Scatter plot (quantidade de visitas vs receita gerada).

---

### 5.3 Duracao Media de Visita

```
Duracao_Media = AVG(hora_saida - hora_entrada) em minutos
```

**Segmentado por:** Tipo de visita (prospeccao, manutencao, entrega, treinamento), vendedor, porte do cliente.

**Correlacao util:** Duracao vs efetividade. Visitas muito curtas (< 15 min) podem indicar falta de preparo. Muito longas (> 2h) podem indicar ineficiencia.

**Visualizacao:** Histogram de distribuicao. Box plot por vendedor. Scatter plot (duracao vs resultado).

---

### 5.4 Distancia e Custo por Visita

```
Distancia_Total = SUM(km_percorridos) no periodo
Custo_Km = Despesa_Deslocamento / Distancia_Total
Custo_por_Visita = Despesa_Total_Campo / Numero_Visitas
```

**Decomposicao de custo:**
- Combustivel / quilometragem
- Pedagio
- Estacionamento
- Alimentacao
- Hospedagem (se viagem)

```
Expense_to_Revenue = (Custo_Total_Campo / Receita_Gerada_Campo) * 100
```

**Benchmark:** Expense-to-revenue de vendas de campo entre 5-15% e aceitavel. Acima de 20% merece revisao.

**Visualizacao:** KPI card (custo medio por visita). Mapa com rotas e custos. Bar chart por categoria de despesa. Trend line mensal.

---

### 5.5 Cobertura Geografica

```
Cobertura = (Clientes visitados no periodo / Total clientes ativos no territorio) * 100
Cobertura_Territorial = (Territorios com pelo menos 1 visita / Total de territorios) * 100
```

**Frequencia vs Plano:**
```
Compliance_Frequencia = (Clientes visitados dentro da frequencia planejada / Total clientes com plano) * 100
```

**Visualizacao:** Mapa de calor (heatmap geografico) com intensidade de visitas. Mapa com clientes nao visitados destacados em vermelho. KPI card com % de cobertura.

---

### 5.6 Compliance de Visita (Planejado vs Realizado)

```
Visitas_Planejadas = COUNT(visitas agendadas no periodo)
Visitas_Realizadas = COUNT(visitas concluidas no periodo)
Compliance = (Realizadas / Planejadas) * 100
```

**Motivos de nao realizacao (categorizados):**
1. Cliente nao disponivel
2. Reagendamento pelo vendedor
3. Problema de deslocamento
4. Priorizacao de outro cliente
5. Emergencia/imprevisto

**Visualizacao:** Gauge chart (% compliance). Stacked bar (realizadas, canceladas, reagendadas). Trend line semanal.

---

## 6. Gestao de Leads

### 6.1 Volume de Leads

```
Leads_Periodo = COUNT(leads criados no periodo)
```

**Segmentacoes obrigatorias:**
- Por fonte (indicacao, site, evento, cold call, WhatsApp, parceiro, midia social)
- Por vendedor responsavel
- Por territorio/regiao
- Por produto de interesse
- Por status (novo, contatado, qualificado, desqualificado, convertido)

**Visualizacao:** Line chart mensal (tendencia). Stacked bar por fonte. Funnel (novo → qualificado → convertido).

---

### 6.2 Taxa de Conversao de Lead

```
Conversao_Lead = (Leads convertidos em oportunidade / Total leads no periodo) * 100
```

**Por fonte:**
```
Conversao_Fonte = (Leads convertidos da fonte X / Total leads da fonte X) * 100
```

**Insight critico:** A fonte com maior volume nao e necessariamente a melhor. Uma fonte com poucos leads mas alta conversao pode ser mais valiosa.

**Visualizacao:** Bar chart por fonte (volume vs conversao em eixo duplo). Funnel geral. Table com detalhamento.

---

### 6.3 Tempo de Resposta a Leads

Ja detalhado na secao 2.4. Complementos para gestao de leads:

```
SLA_Cumprimento = (Leads contatados dentro do SLA / Total leads) * 100
```

**SLA sugerido para B2B:**
- Lead inbound (site/WhatsApp): < 1 hora
- Lead de evento: < 24 horas
- Lead de indicacao: < 4 horas
- Lead de parceiro: < 2 horas

---

### 6.4 Custo por Lead (CPL)

```
CPL = Investimento_Marketing_Periodo / Leads_Gerados_Periodo
CPL_por_Fonte = Investimento_Fonte / Leads_Fonte
```

**Variantes avancadas:**
```
Custo por Lead Qualificado = Investimento / Leads Qualificados (MQL)
Custo por Oportunidade = Investimento / Oportunidades Geradas
CAC (Customer Acquisition Cost) = Investimento Total (Marketing + Vendas) / Novos Clientes
```

**Relacao critica:**
```
LTV:CAC Ratio = Customer Lifetime Value / Customer Acquisition Cost
```
- LTV:CAC > 3: Saudavel
- LTV:CAC 1-3: Aceitavel, mas precisa melhorar
- LTV:CAC < 1: Insustentavel

**Visualizacao:** KPI card (CPL medio). Bar chart por fonte. Scatter plot (CPL vs conversao por fonte). LTV:CAC gauge.

---

### 6.5 Tempo Lead-to-Customer

```
Lead_to_Customer = AVG(data_primeira_compra - data_criacao_lead) em dias
```

**Segmentado por:** Fonte, vendedor, territorio, porte do prospect.

**Visualizacao:** Histogram de distribuicao. Box plot por fonte. KPI card com media e mediana.

---

### 6.6 Lead Scoring

**Definicao:** Score numerico que prioriza leads com base em sinais demograficos (fit) e comportamentais (interesse).

**Componentes de Fit (perfil demografico):**

| Criterio | Pontos |
|----------|--------|
| Porte ideal (optica media/grande) | +20 |
| Regiao atendida | +15 |
| Segmento alvo | +15 |
| Tomador de decisao identificado | +10 |
| Orcamento declarado compativel | +10 |

**Componentes de Interesse (comportamento):**

| Criterio | Pontos |
|----------|--------|
| Solicitou orcamento | +25 |
| Respondeu a contato | +15 |
| Participou de evento/demonstracao | +10 |
| Visitou site (se rastreado) | +5 |
| Interagiu via WhatsApp | +10 |
| Indicacao de cliente existente | +20 |

```
Lead Score = SUM(pontos_fit) + SUM(pontos_interesse) => 0-100+
```

**Classificacao:**
- Hot (>= 80): Prioridade maxima, contatar imediatamente
- Warm (50-79): Prioridade alta, nutrir ativamente
- Cool (25-49): Monitorar, nutricao automatica
- Cold (< 25): Baixa prioridade

**Visualizacao:** Distribuicao por faixa (donut ou bar). Lista priorizada de leads quentes. Scatter plot (score vs tempo sem contato).

---

### 6.7 MQL vs SQL

```
MQL (Marketing Qualified Lead) = Lead com score >= limiar_marketing (ex: 40)
SQL (Sales Qualified Lead) = Lead aceito pelo vendedor apos qualificacao manual
MQL_to_SQL = (SQLs gerados / MQLs gerados) * 100
SQL_to_Opp = (Oportunidades geradas / SQLs) * 100
```

**Funil completo:**
```
Lead → MQL → SQL → Oportunidade → Cliente
```

Com taxas de conversao em cada etapa.

**Visualizacao:** Funnel chart com volumes e % em cada transicao. Trend line mensal de MQL e SQL. KPI cards pareados.

---

## 7. Forecasting

### 7.1 Metodos de Previsao de Vendas

#### Metodo 1: Pipeline Ponderado (mais comum)

```
Forecast = SUM(valor_oportunidade * probabilidade_etapa) para oportunidades com data_fechamento no periodo
```

**Prós:** Simples, intuitivo, facil de implementar.
**Contras:** Depende de probabilidades calibradas. Vendedores podem manipular etapas.

#### Metodo 2: Categorias de Forecast (Salesforce-style)

Cada vendedor classifica suas oportunidades em categorias:

| Categoria | Definicao | Peso Tipico |
|-----------|-----------|-------------|
| **Closed** | Ja fechado | 100% |
| **Commit** | Vendedor garante que fecha no periodo | 90-95% |
| **Best Case** | Provavel, mas nao garantido | 60-70% |
| **Pipeline** | Possivel, depende de varios fatores | 30-40% |
| **Upside** | Bonus inesperado, baixa probabilidade | 10-20% |

```
Forecast_Commit = SUM(valor) WHERE categoria IN ('Closed', 'Commit')
Forecast_Best_Case = Forecast_Commit + SUM(valor * peso) WHERE categoria = 'Best Case'
Forecast_Pipeline = Forecast_Best_Case + SUM(valor * peso) WHERE categoria = 'Pipeline'
```

**Prós:** Combina dados objetivos com julgamento do vendedor.
**Contras:** Subjetivo. Requer disciplina e calibracao.

#### Metodo 3: Tendencia Historica

```
Forecast_Historico = Media_Movel(receita, N_periodos) * (1 + taxa_crescimento_esperada)
```

**Variantes:**
- Media movel simples (SMA)
- Media movel exponencial (EMA - mais peso para periodos recentes)
- Regressao linear sobre dados historicos
- Sazonalidade (ex: meses de pico para laboratorios opticos)

```
Forecast_Sazonal = Receita_Mesmo_Periodo_Ano_Anterior * (1 + crescimento_YoY)
```

**Prós:** Objetivo, baseado em dados reais.
**Contras:** Nao captura mudancas de mercado ou eventos atipicos.

#### Metodo 4: Hibrido (Recomendado)

```
Forecast_Final = w1 * Pipeline_Ponderado + w2 * Categorias_Vendedor + w3 * Tendencia_Historica
```

Pesos (w1, w2, w3) calibrados trimestralmente com base na acuracia historica de cada metodo.

#### Metodo 5: AI-Based (Futuro)

- Modelos de machine learning treinados com dados historicos
- Features: etapa, idade do deal, vendedor, porte do cliente, sazonalidade, atividades registradas, engagement score
- Output: probabilidade individual por oportunidade (nao por etapa generica)
- Requer volume minimo de dados (tipicamente 500+ oportunidades historicas)

---

### 7.2 Categorias de Forecast

**Tres visoes para gestao:**

1. **Commit (Piso):** O que temos certeza de que vai entrar. Base para decisoes financeiras.
2. **Best Case (Alvo):** O que esperamos se as coisas correrem razoavelmente bem. Base para planejamento.
3. **Upside (Teto):** O que pode entrar se tudo der certo. Base para planejamento de capacidade.

```
Gap_Commit = Meta - Forecast_Commit
Gap_Best_Case = Meta - Forecast_Best_Case
```

**Visualizacao:** Stacked bar chart (commit + best case + upside empilhados vs linha de meta). Waterfall chart decompondo o forecast. Table detalhada com drill-down por vendedor.

---

### 7.3 Acuracia do Forecast

```
Forecast_Accuracy = 1 - ABS(Forecast - Realizado) / Realizado
```

**Variante MAPE:**
```
MAPE = (1/N) * SUM(ABS(Forecast_i - Realizado_i) / Realizado_i) * 100
```

**Bias (vies):**
```
Bias = (Forecast - Realizado) / Realizado * 100
```
- Positivo: forecast otimista (superestima)
- Negativo: forecast conservador (subestima)

**Rastrear por:**
- Por vendedor (quem e otimista vs conservador)
- Por metodo de forecast
- Por periodo (acuracia melhora com dados?)

**Benchmarks:**
- Acuracia > 85%: Excelente
- 75-85%: Bom
- 60-75%: Aceitavel
- < 60%: Precisa melhorar processo

**Visualizacao:** KPI card (acuracia geral). Bar chart por vendedor. Scatter plot (forecast vs realizado com linha de 45 graus perfeitos). Trend line de acuracia ao longo do tempo.

---

### 7.4 Rolling Forecasts

**Definicao:** Previsao continuamente atualizada que olha sempre N periodos a frente (tipicamente 12 meses), em vez de apenas ate o final do ano fiscal.

```
Rolling_Forecast_12M = SUM(forecast_mes_i) para i = mes_atual ate mes_atual + 11
```

**Atualizacao:** Mensal. A cada mes, remove o mes que passou e adiciona um novo mes no final.

**Vantagem:** Elimina o "efeito dezembro" onde a visibilidade encolhe ao longo do ano. Sempre 12 meses de visibilidade.

**Visualizacao:** Line chart com 12 barras (meses futuros) + linha de meta mensal. Area chart mostrando faixa de confianca (commit a upside).

---

## 8. Design do Dashboard

### 8.1 Padroes de Layout por Papel

#### Dashboard Executivo (CEO/Diretoria)

**Objetivo:** Visao de alto nivel, responder "como estamos vs meta?" em 5 segundos.

**Layout (1 tela, sem scroll):**
```
+-------------------------------------------------------+
| [Periodo: Mes/Tri/Ano] [Comparar: vs anterior/vs meta]|
+-------------------------------------------------------+
| KPI Card    | KPI Card    | KPI Card    | KPI Card    |
| Receita     | Win Rate    | Pipeline    | Forecast    |
| vs Meta     |             | Coverage    | Accuracy    |
+-------------------------------------------------------+
| Receita Acumulada vs Meta          | Forecast         |
| (line chart com area)              | Commit/Best/Up   |
| 60% largura                        | (stacked bar)    |
|                                    | 40% largura      |
+-------------------------------------------------------+
| Top 5 Vendedores  | Pipeline por   | Novos Clientes   |
| (ranking table)   | Etapa (funnel) | vs Churn         |
| 33%               | 34%            | (donut) 33%      |
+-------------------------------------------------------+
```

**Principios:**
- Maximo 6-8 KPI cards no topo
- 2-3 charts grandes no meio
- 2-3 charts menores na base
- Cor verde/vermelho para indicar bom/ruim vs meta
- Sparklines em KPI cards para tendencia
- Zero jargao tecnico (mostrar "Receita" nao "ARR")

#### Dashboard Gerencial (Gerente de Vendas)

**Objetivo:** Monitorar equipe, identificar problemas, tomar acoes taticas.

**Layout (scroll permitido, 2-3 telas):**
```
Tela 1:
+-------------------------------------------------------+
| [Periodo] [Equipe/Territorio] [Produto] [Comparar]    |
+-------------------------------------------------------+
| KPI Card x 8 (Receita, Pipeline, Win Rate, Ciclo,     |
| Visitas, Conversao, Ticket, QA)                        |
+-------------------------------------------------------+
| Pipeline por Etapa x Vendedor     | Quota Attainment   |
| (heatmap ou grouped bar)          | por Vendedor       |
| 60%                               | (bullet chart) 40% |
+-------------------------------------------------------+

Tela 2:
+-------------------------------------------------------+
| Funil de Conversao    | Atividades por Vendedor        |
| (funnel com %)        | (stacked bar)                  |
+-------------------------------------------------------+
| Deals Parados (tabela com semaforo e dias parado)      |
+-------------------------------------------------------+

Tela 3:
+-------------------------------------------------------+
| Clientes em Risco      | Loss Reasons     | Visitas    |
| (tabela)               | (pareto)         | Compliance |
+-------------------------------------------------------+
| Mapa de Cobertura Territorial (se aplicavel)           |
+-------------------------------------------------------+
```

**Principios:**
- Filtros: equipe, vendedor individual, territorio, produto, periodo
- Drill-down: clicar em vendedor abre visao individual
- Alertas: badges em KPIs que estao abaixo de limiar
- Comparativo: periodo anterior e meta lado a lado

#### Dashboard do Vendedor/Consultor

**Objetivo:** "O que eu preciso fazer hoje?" + "Como estou vs minha meta?"

**Layout (1-2 telas, mobile-first):**
```
Tela 1:
+-------------------------------------------------------+
| Minha Meta: R$ XX.XXX | Realizado: R$ XX.XXX | XX%    |
| [===========----------] progress bar                   |
+-------------------------------------------------------+
| Agenda do Dia              | Minhas Oportunidades     |
| (lista com horarios)       | Quentes (top 5 por valor)|
| 50%                        | 50%                      |
+-------------------------------------------------------+
| Leads Pendentes de Contato (lista com SLA countdown)   |
+-------------------------------------------------------+

Tela 2:
+-------------------------------------------------------+
| Meu Pipeline por Etapa    | Minhas Atividades (semana) |
| (funnel pessoal)          | (bar chart por tipo)       |
+-------------------------------------------------------+
| Clientes sem Visita Recente (tabela com dias)          |
+-------------------------------------------------------+
```

**Principios:**
- Mobile-responsive obrigatorio (vendedor de campo usa celular)
- Foco em acao, nao em analise
- Alertas e lembretes no topo
- Minimalista (nao sobrecarregar)

---

### 8.2 Tipos de Grafico por KPI

| KPI | Tipo de Grafico Primario | Tipo Secundario |
|-----|--------------------------|-----------------|
| Receita vs Meta | Bullet chart | Line chart (acumulado) |
| Pipeline Total | KPI card com sparkline | Stacked bar (por etapa) |
| Pipeline Ponderado | KPI card | Gauge chart |
| Win Rate | Donut chart | Bar chart (por vendedor) |
| Conversao por Etapa | Funnel chart | Tabela com % |
| Ciclo de Vendas | KPI card | Box plot / Histogram |
| Ticket Medio | KPI card com trend | Bar chart (por segmento) |
| Pipeline Velocity | KPI card | Line chart (mensal) |
| Pipeline Coverage | Gauge chart | KPI card |
| Loss Reasons | Pareto (horizontal bar) | Donut chart |
| Atividades por Rep | Stacked bar chart | Heatmap (dia x hora) |
| Lead Response Time | KPI card | Histogram |
| Lead Volume | Line chart (tendencia) | Stacked bar (por fonte) |
| Lead Conversion | Funnel chart | Bar chart (por fonte) |
| Lead Scoring | Donut (por faixa) | Scatter plot |
| Quota Attainment | Bullet chart (por rep) | Histogram (distribuicao) |
| Novos Clientes | KPI card + bar mensal | Line chart (tendencia) |
| Retencao / Churn | Line chart | Cohort table |
| NPS/CSAT | Gauge chart | Trend line |
| Top Clientes | Pareto chart | Treemap |
| Clientes em Risco | Tabela com semaforo | Scatter plot |
| Concentracao | Donut chart | Pareto chart |
| Visitas/Dia | Bar chart (por rep) | Calendar heatmap |
| Efetividade Visita | KPI card | Scatter plot |
| Cobertura Geografica | Mapa de calor | KPI card |
| Compliance Visita | Gauge chart | Stacked bar |
| Custo por Visita | KPI card | Bar (por categoria) |
| Forecast | Stacked bar (categorias) | Line (rolling) |
| Forecast Accuracy | KPI card | Scatter (forecast vs real) |
| CLV | KPI card | Histogram / Cohort |
| ARPA | KPI card + trend | Bar (por segmento) |
| Crescimento Receita | Line chart | Waterfall chart |

---

### 8.3 Refresh e Performance

| Tipo de Dado | Frequencia de Refresh |
|--------------|----------------------|
| KPIs operacionais (leads, atividades) | Tempo real ou < 5 min |
| Pipeline e oportunidades | A cada 15-30 min |
| Receita e forecast | Diario (agregacao noturna) |
| Metricas de periodo (retencao, churn, NPS) | Semanal ou mensal |
| Benchmarks e tendencias | Mensal |

**Estrategia tecnica:**
- Views materializadas no PostgreSQL para KPIs pesados
- Cache de queries frequentes (Redis)
- Refresh assincrono com timestamp "Atualizado em: HH:MM"
- Pre-agregacao diaria em tabelas de fato (star schema)
- Server-side pagination para tabelas de drill-down

---

### 8.4 Drill-Down

**Hierarquia padrao:**
```
Dashboard Executivo
  → Clica em KPI "Pipeline"
    → Dashboard Gerencial filtrado por pipeline
      → Clica em vendedor
        → Visao individual do vendedor
          → Clica em oportunidade
            → Detalhe da oportunidade
```

**Padroes de drill-down:**
1. **Click-through:** KPI card ou chart clicavel que abre nova visao filtrada
2. **Expand-in-place:** Tabela que expande detalhes na propria linha
3. **Side panel:** Click abre painel lateral com detalhes sem perder contexto
4. **Breadcrumbs:** Navegacao hierarquica para voltar facilmente

**Regra:** Todo numero no dashboard deve ser "clicavel" e levar ao detalhe que o compoe.

---

### 8.5 Seletores e Filtros

**Filtros globais (topo do dashboard, sticky):**
- Periodo (predefinidos: Hoje, Esta Semana, Este Mes, Este Trimestre, Este Ano, Customizado)
- Comparacao (vs periodo anterior, vs mesmo periodo ano anterior, vs meta)
- Equipe / Territorio
- Vendedor individual

**Filtros contextuais (dentro de secoes):**
- Produto / Linha de produto
- Segmento de cliente
- Fonte de lead
- Etapa do pipeline

**Comportamento:**
- Filtros globais afetam toda a pagina
- Filtros contextuais afetam apenas a secao
- Estado dos filtros salvo por usuario (preferencia)
- URL com query params para compartilhar visao filtrada
- Reset para valores padrao com 1 clique

---

### 8.6 Comparacoes

**Tipos de comparacao:**

1. **Periodo-sobre-Periodo:** Este mes vs mes anterior; Este trimestre vs trimestre anterior
2. **Ano-sobre-Ano:** Este mes vs mesmo mes do ano anterior (captura sazonalidade)
3. **Vs Meta:** Realizado vs planejado
4. **Rep-vs-Rep:** Ranking de vendedores lado a lado
5. **Territorio-vs-Territorio:** Comparar regioes
6. **Cohort:** Clientes adquiridos no mes X vs mes Y (mesma idade)

**Representacao visual:**
- Setas verdes (para cima) / vermelhas (para baixo) nos KPI cards
- Percentual de variacao ao lado do valor
- Linhas tracejadas para meta/referencia em charts
- Cores contrastantes em series comparadas

---

### 8.7 Codificacao Visual e Hierarquia

**Cores padrao:**
| Significado | Cor | Uso |
|-------------|-----|-----|
| Positivo / meta atingida | Verde (success.main) | Valores acima da meta |
| Neutro / em andamento | Azul (primary.main) | Valores normais |
| Atencao / proximo do limiar | Amarelo/Laranja (warning.main) | Valores abaixo de 80% da meta |
| Negativo / abaixo da meta | Vermelho (error.main) | Valores abaixo de 60% da meta |
| Informativo | Cinza (text.secondary) | Labels, subtitulos, metadados |

**Hierarquia visual:**
1. **KPI cards no topo:** Maiores, numeros grandes (fontSize 28-32px), com sparkline
2. **Charts principais no meio:** Maiores, 60-100% da largura
3. **Charts secundarios embaixo:** Menores, 33-50% da largura
4. **Tabelas de detalhe:** Com scroll, no final
5. **Espacamento consistente:** 16-24px entre secoes (theme.spacing(2-3))

**Tipografia:**
- Valores de KPI: fontWeight 700, fontSize 28-32px
- Labels de KPI: fontWeight 400, fontSize 12-14px, text.secondary
- Titulos de secao: fontWeight 600, fontSize 16-18px
- Dados em tabela: fontSize 13-14px

---

### 8.8 Responsividade Mobile

**Breakpoints (MUI):**
- `xs` (0-600px): 1 coluna, KPI cards empilhados, charts fullWidth
- `sm` (600-900px): 2 colunas, KPI cards em grid 2x
- `md` (900-1200px): 3-4 colunas, layout quase completo
- `lg` (1200+): Layout completo

**Regras para mobile:**
1. KPI cards: Scroll horizontal ou grid 2x2
2. Charts complexos (funnel, heatmap): Substituir por versao simplificada ou tabela
3. Filtros: Colapsar em "Filtros" com drawer lateral
4. Tabelas: Scroll horizontal com colunas prioritarias fixas a esquerda
5. Touch targets: Minimo 44x44px
6. Swipe: Permitir swipe entre secoes do dashboard

**Dashboard do vendedor e mobile-first:** Layout pensado para celular, expandido para desktop.

---

### 8.9 Dashboards por Papel (Role-Based)

| Papel | Dashboards Visiveis | KPIs Prioritarios |
|-------|--------------------|--------------------|
| **CEO/Diretor** | Executivo | Receita vs Meta, Forecast, Pipeline Coverage, Win Rate, Crescimento |
| **Gerente Comercial** | Executivo + Gerencial | Quota Attainment por Rep, Pipeline Velocity, Loss Reasons, Deals Parados, Compliance Visita |
| **Vendedor/Consultor** | Pessoal | Minha Meta, Agenda, Leads Pendentes, Meu Pipeline, Clientes sem Visita |
| **Marketing** | Leads + Campanhas | Lead Volume, Conversao por Fonte, CPL, MQL/SQL, Tempo de Resposta |
| **Financeiro** | Receita + Despesas | Receita Realizada, Forecast, Despesas de Campo, Expense-to-Revenue |
| **Operacional** | Visitas + Territorio | Cobertura, Compliance, Efetividade, Custo por Visita, Mapa |

**Implementacao:** Sistema de permissoes (RBAC) controla quais dashboards cada papel pode acessar. Widgets configuraveis por usuario dentro do dashboard permitido.

---

## 9. Dashboards de Referencia

### 9.1 Salesforce — Melhores Praticas

**Padroes observados:**
- **Pagina inicial:** 4-6 KPI cards com sparklines, 2 charts grandes (pipeline + forecast), lista de oportunidades urgentes
- **Pipeline Inspection:** Tabela interativa com filtros por etapa, aging, vendedor. Inline editing de campos
- **Forecast Page:** Grid com vendedores nas linhas e categorias de forecast nas colunas (Closed, Commit, Best Case, Pipeline). Totais por equipe
- **Einstein Analytics (AI):** Win probability por oportunidade (nao por etapa). Recommended actions. Anomaly detection
- **Reports Builder:** Drag-and-drop. Groupings, filters, charts, summary formulas. Scheduling e email delivery

**Leituras-chave:**
- Dashboard deve responder uma pergunta especifica, nao "mostrar tudo"
- Maximo 8-10 componentes por dashboard
- Componentes actionable (clicaveis, com drill-down)
- Alertas baseados em threshold (ex: pipeline coverage < 2x)

### 9.2 HubSpot — CRM Analytics

**Padroes observados:**
- **Deal Pipeline Dashboard:** Funnel visual arrastavel (kanban). KPIs no topo (total pipeline, weighted, velocity)
- **Sales Performance:** Leaderboard de vendedores com quota attainment. Activity tracking automatico (emails, calls, meetings rastreados)
- **Contact Analytics:** Timeline de interacoes. Engagement score. Lifecycle stage tracking
- **Custom Dashboards:** Widget library com 30+ tipos de visualizacao. Filtros globais. Auto-refresh
- **Forecast:** Pipeline ponderado + categorias manuais. Comparacao mensal. Accuracy tracking

**Diferenciais:**
- Timeline unificada do contato (todas interacoes em ordem cronologica)
- Automacao de captura de atividades (integracao email/calendario)
- Sequences (automacao de follow-up)

### 9.3 Zoho Analytics / Zoho CRM

**Padroes observados:**
- **Pre-built dashboards:** 40+ KPIs prontos para CRM. Separados por: Vendas, Leads, Campanhas, Suporte
- **Funnel Analysis:** Multi-step funnel com filtros temporais e dimensionais
- **Cohort Analysis:** Retencao de clientes por safra de aquisicao
- **Anomaly Detection:** Alerta automatico quando KPI desvia do padrao historico
- **Embedded Analytics:** Dashboards embutidos em telas do CRM (nao precisam ir a pagina separada)
- **AI (Zia):** Ask a question em linguagem natural e recebe chart/resposta

**Diferenciais:**
- Blend de dados (CRM + financeiro + suporte em um dashboard)
- Pivot tables interativas
- White-label/embedded analytics para clientes

### 9.4 Power BI — Templates CRM

**Padroes observados:**
- **Sales Pipeline Template:** Pagina 1: Executive Summary (KPIs + forecast). Pagina 2: Pipeline Detail (funnel + aging + etapa). Pagina 3: Rep Performance (ranking + trend). Pagina 4: Products/Territory
- **Slicers (filtros):** Date range, vendedor, territorio, produto, etapa — aplicados globalmente
- **Tooltips ricos:** Hover sobre barra mostra mini-dashboard com detalhes
- **Conditional formatting:** Cores automaticas baseadas em regras (verde/amarelo/vermelho)
- **Bookmarks:** Visoes salvas (ex: "Pipeline Q1", "Minha Equipe", "Territorio Sul")
- **Row-Level Security:** Vendedor so ve seus dados. Gerente ve equipe. Diretor ve tudo

**Padroes de layout Power BI:**
- Header fixo com titulo, filtros e ultima atualizacao
- Grid de cards 4 colunas no topo
- 2-3 visuais grandes no meio (70-80% da area)
- Tabela com detalhes no rodape
- Navegacao por abas no topo (Overview, Pipeline, Performance, Territory)

### 9.5 Tableau CRM

**Padroes observados:**
- **Story-driven dashboards:** Sequencia de dashboards que contam uma historia (Overview → Detalhe → Acao)
- **Set actions:** Selecionar ponto em um chart filtra todos os outros automaticamente
- **Parameters:** Seletores que alteram metricas/dimensoes em tempo real (ex: "Mostrar por: Vendedor / Territorio / Produto")
- **Animacao:** Transicoes suaves ao filtrar/trocar periodo
- **LOD Expressions (Level of Detail):** Calculos em diferentes niveis de agregacao no mesmo visual
- **Mobile layout:** Layout separado otimizado para dispositivos moveis

**Principios de design Tableau:**
- 5-second rule: O insight principal deve ser visivel em 5 segundos
- Pre-attentive attributes: Tamanho, cor, posicao (os 3 mais eficazes)
- Data-ink ratio: Maximizar dados, minimizar decoracao
- Z-pattern ou F-pattern de leitura

---

## 10. Dicionario de Metricas (Template)

Toda metrica implementada deve ter uma ficha no dicionario:

```
Nome: [Nome da metrica]
Codigo: [KPI_001]
Categoria: [Pipeline / Atividade / Receita / Cliente / Visita / Lead / Forecast]
Formula: [Formula exata]
Fonte de dados: [Tabelas/entidades envolvidas]
Frequencia de calculo: [Real-time / Diario / Semanal / Mensal]
Responsavel: [Quem define a meta]
Meta: [Valor alvo]
Limiar de alerta: [Valor abaixo do qual gera alerta]
Segmentacoes: [Dimensoes disponiveis para filtro]
Visualizacao: [Tipo de chart recomendado]
Notas: [Observacoes, excecoes, regras de calculo]
```

---

## 11. Resumo de KPIs por Categoria

### Contagem Total: 65+ KPIs definidos

| Categoria | Qtd | KPIs Principais |
|-----------|-----|-----------------|
| Pipeline | 11 | Pipeline Total, Ponderado, Velocity, Conversao, Win Rate, Loss Reasons, Ticket Medio, Coverage, Ciclo, Stalled, Aging |
| Atividades | 7 | Volume/Rep, Frequencia Visita, Atividades/Deal, Tempo Resposta, Follow-up Rate, Activity-to-Opp, Touchpoints |
| Receita | 7 | Receita vs Meta, Por Dimensao, Nova vs Recorrente, CLV, ARPA, Crescimento, Quota Attainment |
| Clientes | 8 | Novos, Retencao, Churn, NPS/CSAT, Engagement Score, Top Clientes, Em Risco, Concentracao |
| Visitas | 6 | Visitas/Dia, Efetividade, Duracao, Custo/Visita, Cobertura Geo, Compliance |
| Leads | 7 | Volume, Conversao, Tempo Resposta, CPL, Lead-to-Customer, Lead Scoring, MQL/SQL |
| Forecast | 4 | Pipeline Ponderado, Categorias, Acuracia, Rolling |

---

## 12. Proximos Passos Recomendados

1. **Priorizar KPIs para MVP:** Selecionar 15-20 KPIs mais criticos para o primeiro release
2. **Definir metas iniciais:** Mesmo estimativas servem como baseline
3. **Modelar dados:** Garantir que o schema suporte todas as metricas (tabelas de fato + dimensao)
4. **Prototipar layout:** Wireframe do dashboard executivo e do vendedor
5. **Definir refresh strategy:** Quais metricas precisam de real-time vs batch
6. **Calibrar probabilidades:** Usar dados historicos para definir probabilidades por etapa
7. **Implementar dicionario de metricas:** Documentar cada KPI formalmente antes de codificar

---

## Referencias

- Salesforce Sales Cloud — Dashboard Best Practices & Pipeline Management
- HubSpot CRM — Sales Analytics & Reporting Documentation
- Zoho Analytics — CRM Dashboard Templates & Embedded Analytics
- Power BI — Sales Pipeline & CRM Template Gallery
- Tableau — CRM Dashboard Design Patterns
- Harvard Business Review — "The Short Life of Online Sales Leads" (lead response time)
- InsideSales.com — "Lead Response Management Study"
- Forrester Research — B2B Sales Metrics & Benchmarking
- Gartner — Sales Operations & Forecasting Best Practices
- BANT/MEDDIC/SPIN — Sales qualification frameworks influencing lead scoring
