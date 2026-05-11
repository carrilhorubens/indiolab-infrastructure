# Pesquisa Detalhada: Gestao de Visitas e Despesas de Campo no CRM

**Data da pesquisa:** 31/03/2026
**Complementa:** `estudo_crm.md` (estudo geral do modulo CRM)
**Foco:** Aprofundamento tatico em visitas (check-in/check-out), despesas de viagem, melhores praticas da industria, modelo de dados detalhado e consideracoes mobile-first.

---

## 1. Gestao de Visitas / Check-in

### 1.1 Como consultores de campo registram visitas

A visita e a unidade atomica de trabalho do vendedor externo. Os CRMs de campo modernos tratam a visita como entidade de primeira classe com ciclo de vida proprio.

**Ciclo de vida padrao da visita:**

```
Planejada -> Em Deslocamento -> Check-in -> Em Andamento -> Check-out -> Pendente Relatorio -> Concluida
                                                                              |
                                                                              v
                                                                         Cancelada
```

**Metodos de registro usados pela industria:**

| Metodo | Descricao | Ferramentas que usam |
|--------|-----------|---------------------|
| Check-in manual com GPS | Consultor toca botao "Check-in", app captura lat/lng automaticamente | Repsly, Badger Maps, MapMyCustomers, Salesforce Maps |
| Check-in automatico (geofence) | App detecta entrada em raio de X metros do cliente e sugere check-in | Salesforce Field Service, Repsly Premium |
| Check-in com foto obrigatoria | Alem do GPS, exige foto da fachada/local como prova de presenca | Repsly, VisitBasis, ForceManager |
| QR Code no local | Cliente tem QR code fixo; consultor escaneia para confirmar presenca | Menos comum, usado em logistica |
| NFC Tag | Tag NFC no local do cliente, consultor aproxima celular | Raro em CRM, mais comum em field service tecnico |

### 1.2 Rastreamento GPS de visitas

**Dois modelos coexistem na industria:**

#### Modelo A -- Ponto discreto (recomendado para CRM comercial)
- GPS capturado apenas no momento do check-in e check-out
- Menor consumo de bateria
- Menor preocupacao com privacidade (LGPD)
- Dados armazenados: `check_in_latitude`, `check_in_longitude`, `check_in_precisao_metros`, `check_out_latitude`, `check_out_longitude`
- Validacao: distancia entre GPS capturado e endereco cadastrado do cliente (raio de tolerancia configuravel, tipicamente 200-500m)

#### Modelo B -- Rastreamento continuo (field service / logistica)
- App envia posicao a cada X segundos/minutos
- Permite reconstruir rota percorrida
- Alto consumo de bateria, implicacoes de privacidade
- Usado por: Salesforce Field Service Lightning, SAP Field Service Management
- **NAO recomendado** para CRM comercial puro por questoes de LGPD e aceitacao dos consultores

**Dados GPS por check-in (padrao da industria):**
- Latitude (decimal, 6 casas)
- Longitude (decimal, 6 casas)
- Precisao em metros (fornecida pela API de geolocalizacao)
- Altitude (opcional)
- Timestamp UTC do dispositivo
- Provider (GPS, rede, WiFi)
- Endereco reverso (geocoding reverso para exibicao)

### 1.3 Planejamento e agendamento de visitas

**Funcionalidades encontradas nos principais CRMs de campo:**

#### Planejamento pelo gerente (top-down)
- Gerente define rota semanal/mensal para cada consultor
- Calendario compartilhado com arraste-e-solte
- Criterios de priorizacao: ultimo contato, potencial, proximidade geografica, pendencias
- Salesforce e Dynamics usam "cadencias" (sequencias de atividades pre-programadas)

#### Planejamento pelo consultor (bottom-up)
- Consultor monta propria agenda a partir de sugestoes do sistema
- Sistema sugere: clientes sem visita ha X dias, oportunidades em andamento, clientes com pedidos recentes
- Badger Maps e MapMyCustomers permitem otimizar rota diretamente no mapa

#### Visitas recorrentes (beat plan)
- Muito usado em FMCG/distribuicao, adaptavel para optica B2B
- Define frequencia por cliente: semanal, quinzenal, mensal
- Sistema gera visitas automaticamente com base na frequencia
- Repsly chama de "Schedule" com templates de dias da semana

#### Metricas de planejamento
- Taxa de aderencia: visitas realizadas / visitas planejadas
- Cobertura de carteira: % de clientes visitados no periodo
- Frequencia media por cliente

### 1.4 Relatorio de visita (Visit Report)

O relatorio de visita e o registro estruturado do que aconteceu durante a interacao. A industria converge em campos semi-estruturados.

**Campos padrao do relatorio de visita:**

| Campo | Tipo | Obrigatorio | Descricao |
|-------|------|-------------|-----------|
| Objetivo da visita | Texto/Select | Sim | O que o consultor pretendia alcançar |
| Tipo de visita | Enum | Sim | Prospeccao, manutencao, negociacao, pos-venda, cobranca, suporte |
| Pessoas encontradas | Multi-select (contatos) | Sim | Quem participou da reuniao |
| Assuntos discutidos | Texto longo | Sim | Resumo da conversa |
| Resultado/Outcome | Enum + Texto | Sim | Pedido fechado, proposta solicitada, sem interesse, reagendar, etc. |
| Proximos passos | Texto | Sim | Acoes concretas com prazo |
| Produtos apresentados | Multi-select | Nao | Quais produtos/servicos foram discutidos |
| Concorrentes mencionados | Multi-select/Texto | Nao | Inteligencia competitiva |
| Nivel de interesse | Rating (1-5) ou Enum | Nao | Quente, morno, frio |
| Humor/Sentimento do cliente | Enum | Nao | Satisfeito, neutro, insatisfeito |
| Oportunidade gerada | Link | Nao | Se gerou nova oportunidade no pipeline |
| Pedido realizado | Link | Nao | Se gerou pedido direto |
| Fotos | Anexos | Nao | Fotos do local, prateleira, produto instalado, etc. |
| Assinatura do cliente | Imagem | Nao | Captura de assinatura digital (campo, entrega) |

**Boas praticas para relatorios de visita:**
- Formularios curtos com campos obrigatorios minimos (consultor no campo tem pouco tempo)
- Templates diferentes por tipo de visita (prospeccao vs. manutencao tem campos diferentes)
- Possibilidade de preencher offline e sincronizar depois
- Voz-para-texto como alternativa ao digitacao manual (tendencia crescente)
- Tempo limite para preenchimento (ex: 24h apos check-out, senao alerta ao gerente)

### 1.5 Duracao da visita

**Calculo automatico:** `duracao = check_out_timestamp - check_in_timestamp`

**Metricas derivadas usadas pela industria:**
- Duracao media por tipo de visita
- Duracao media por consultor (detecta outliers)
- Tempo em deslocamento vs. tempo em visita (se houver rastreamento)
- Visitas com duracao anomala (muito curta = possivel check-in falso; muito longa = possivel esqueceu check-out)

**Alertas automaticos:**
- Visita sem check-out apos X horas -> auto check-out + flag
- Visita com duracao < 5 minutos -> flag para revisao gerencial
- Check-in distante do endereco do cliente -> flag

### 1.6 Fotos e anexos por visita

**Categorias de anexos comuns:**
- Foto da fachada (prova de presenca)
- Foto da prateleira/vitrine (share of shelf)
- Foto do produto instalado/em uso
- Foto de material promocional
- Documento escaneado
- Recibos (vinculados a despesas)

**Requisitos tecnicos:**
- Compressao automatica (JPEG quality 70-80%, max 1-2MB por foto)
- Metadados EXIF preservados (GPS, timestamp -- prova adicional)
- Miniatura (thumbnail) gerada no upload para listagens
- Storage: S3/Azure Blob com lifecycle rules (ex: mover para cold storage apos 1 ano)
- Limite configuravel por visita (ex: max 10 fotos, max 20MB total)

### 1.7 Capacidade offline

**Cenario real:** consultores de campo frequentemente visitam clientes em areas com conectividade ruim (zonas rurais, interior de predios, garagens).

**Padrao da industria (Repsly, Salesforce Mobile, Dynamics Mobile):**

| Funcionalidade | Online | Offline |
|---------------|--------|---------|
| Check-in/check-out | GPS capturado normalmente | GPS capturado, dados salvos localmente |
| Preencher relatorio | Envio imediato | Salvo em fila local |
| Lancar despesa | Envio imediato | Salvo em fila local |
| Tirar foto | Upload imediato | Salvo em fila local |
| Consultar dados do cliente | Tempo real | Cache local (sincronizado antes da rota) |
| Consultar historico de visitas | Tempo real | Ultimas N visitas em cache |
| Criar pedido | Tempo real | Salvo em fila local |

**Estrategia de sincronizacao:**
1. **Pre-sync:** Antes de sair para rota, app baixa dados dos clientes agendados (cache seletivo)
2. **Operacao offline:** Todas as acoes gravadas em banco local (SQLite / IndexedDB / Realm)
3. **Sync oportunista:** Quando detecta conexao, tenta enviar fila automaticamente
4. **Resolucao de conflitos:** Last-write-wins para campos simples, merge para colecoes
5. **Indicador visual:** App mostra quantos itens estao pendentes de sincronizacao
6. **Retry com backoff:** Falhas de sync tentam novamente com intervalo exponencial

**Tecnologias comuns:**
- **React Native/Expo:** AsyncStorage + SQLite (via expo-sqlite) + Background Fetch
- **PWA:** Service Workers + IndexedDB + Background Sync API
- **Nativo:** Realm (MongoDB), Core Data (iOS), Room (Android)

---

## 2. Gestao de Despesas de Viagem

### 2.1 Categorias de despesas (padrao da industria)

A taxonomia abaixo e consenso entre SAP Concur, Zoho Expense, Expensify, Rydoo e Navan:

| Categoria | Subcategorias comuns | Requer recibo? | Observacoes |
|-----------|---------------------|---------------|-------------|
| **Combustivel** | Gasolina, etanol, diesel, GNV | Sim | Pode ser calculado por km tambem |
| **Quilometragem** | Veiculo proprio | Nao (calculo automatico) | Valor por km definido por politica (ex: R$ 0,75/km) |
| **Pedagio** | Pedagio rodoviario | Sim | Pode integrar com TAG automatica |
| **Estacionamento** | Rotativo, estacionamento privado | Sim | |
| **Alimentacao** | Almoco, jantar, cafe, lanche | Sim acima de limite | Limite diario (per diem) ou por refeicao |
| **Hospedagem** | Hotel, pousada, Airbnb | Sim | Limite por noite/cidade |
| **Transporte** | Taxi, Uber/99, onibus, metro | Sim acima de limite | Pode integrar com apps de corrida |
| **Passagem aerea** | Economica, executiva | Sim | Politica define classe permitida |
| **Locacao de veiculo** | Diaria, seguro, combustivel | Sim | |
| **Telefone/Internet** | Creditos, pacote dados | Nao | Geralmente coberto por ajuda de custo |
| **Material de apoio** | Amostras, brindes, impressoes | Sim | |
| **Lavanderia** | Roupa em viagem longa | Sim | Apenas viagens > 3 dias |
| **Representacao** | Almoco com cliente, presente | Sim | Requer justificativa + nome do cliente |
| **Outros** | Diversos | Sim | Requer justificativa detalhada |

### 2.2 Fluxo de criacao de relatorio de despesas

**Fluxo completo (padrao Concur/Expensify adaptado):**

```
                                    +---------+
                    +-------------->| Devolvido|
                    |               +----+----+
                    |                    |
                    |                    v (consultor corrige)
+--------+    +---------+    +---------+    +---------+    +------------+    +-------------+
|Rascunho|--->|Submetido|--->|Em Revisao|--->|Aprovado |--->| Em         |--->| Reembolsado |
+--------+    +---------+    +---------+    +---------+    | Pagamento  |    +-------------+
                                  |                        +------------+
                                  v
                             +---------+
                             |Rejeitado|
                             +---------+
```

**Detalhamento de cada etapa:**

1. **Rascunho (Draft)**
   - Consultor cria itens de despesa ao longo da viagem/semana
   - Pode adicionar/remover/editar itens livremente
   - Fotos de recibos podem ser capturadas e vinculadas
   - Nao visivel para aprovadores

2. **Submetido (Submitted)**
   - Consultor agrupa despesas em relatorio e submete
   - Sistema executa validacoes automaticas (politica, limites, duplicidades)
   - Itens fora de politica sao sinalizados mas nao bloqueados (flag + justificativa)
   - Notificacao push/email para aprovador

3. **Em Revisao (Under Review)**
   - Gerente/aprovador visualiza relatorio consolidado
   - Pode aprovar/rejeitar itens individuais ou relatorio inteiro
   - Pode solicitar informacoes adicionais (devolve ao consultor)
   - Visualiza fotos dos recibos inline

4. **Devolvido (Returned)**
   - Relatorio devolvido com comentarios do aprovador
   - Consultor corrige e resubmete
   - Historico de devolucoes mantido para auditoria

5. **Aprovado (Approved)**
   - Relatorio aprovado pelo gerente
   - Em organizacoes maiores: segundo nivel de aprovacao (financeiro/diretoria) para valores acima de limite
   - Timestamp + aprovador registrados

6. **Em Pagamento (Processing)**
   - Financeiro processa o reembolso
   - Integracao com modulo financeiro (contas a pagar)
   - Geracao de lancamento contabil

7. **Reembolsado (Reimbursed)**
   - Pagamento efetuado
   - Dados de pagamento registrados (data, forma, comprovante)
   - Consultor recebe notificacao

### 2.3 Captura de recibos e OCR

**Fluxo de captura de recibo (mobile-first):**

1. Consultor tira foto do recibo com camera do celular
2. App faz crop automatico (deteccao de bordas do documento)
3. Imagem e comprimida e enviada
4. **MVP:** Campos preenchidos manualmente pelo consultor
5. **Fase 2 (OCR):** Sistema extrai campos automaticamente e sugere valores

**Provedores de OCR por ordem de maturidade:**
| Provedor | Forca | Custo aproximado |
|----------|-------|-----------------|
| Google Document AI | Melhor para NF brasileira, suporta pt-BR | ~$1.50/1000 paginas |
| Azure AI Document Intelligence | Bom para recibos genericos, modelos pre-treinados | ~$1.00/1000 paginas |
| Amazon Textract | Bom para tabelas e formularios | ~$1.50/1000 paginas |
| Mindee | Especializado em recibos/NF, API simples | ~$0.10/pagina |
| Veryfi | Especializado em expense, SDK mobile | ~$0.08/pagina |

**Campos extraiveis por OCR de recibos:**
- Nome do estabelecimento (razao social / nome fantasia)
- CNPJ do estabelecimento
- Data/hora da transacao
- Valor total
- Itens individuais (em cupom fiscal)
- Forma de pagamento
- Numero do documento/cupom

**Recomendacao pratica:**
- **MVP:** Foto + preenchimento manual. Custo zero de OCR.
- **Fase 2:** OCR assistido -- sistema sugere, consultor confirma/corrige. Reduz digitacao em ~70%.
- **Fase 3:** OCR automatico com confianca alta (>95%) preenche direto; confianca baixa pede confirmacao.

### 2.4 Workflow de aprovacao detalhado

**Niveis de aprovacao (padrao corporativo):**

```
Valor da despesa individual:
  <= R$ 100:   Auto-aprovado (apenas auditoria posterior)
  <= R$ 500:   Gerente direto
  > R$ 500:    Gerente + Diretor Comercial
  > R$ 2.000:  Gerente + Diretor + Financeiro

Valor do relatorio total:
  <= R$ 1.000:  Gerente direto
  <= R$ 5.000:  Gerente + Financeiro
  > R$ 5.000:   Gerente + Diretor + Financeiro
```

**Regras de delegacao:**
- Aprovador ausente (ferias/licenca) -> aprovador substituto pre-configurado
- Timeout de aprovacao: se nao aprovado em X dias uteis, escala para proximo nivel
- Aprovacao em lote: gerente pode aprovar multiplos relatorios de uma vez
- Aprovacao mobile: notificacao push com acao rapida (aprovar/rejeitar)

**Automacoes uteis:**
- Pre-validacao automatica contra politica antes de chegar ao aprovador
- Flag automatico para despesas duplicadas (mesmo valor + data + fornecedor)
- Flag para despesas em fins de semana/feriados sem justificativa
- Flag para despesas acima da media historica do consultor (anomaly detection)
- Bloqueio de submissao se faltam recibos obrigatorios

### 2.5 Politicas e limites de despesas

**Estrutura de politica de despesas (padrao corporativo):**

```
Politica de Despesas
├── Limites por categoria
│   ├── Alimentacao: R$ 80/refeicao, R$ 150/dia
│   ├── Hospedagem: R$ 250/noite (capital), R$ 180/noite (interior)
│   ├── Combustivel: R$ 0,75/km ou recibo real (o menor)
│   └── Representacao: R$ 200/evento, requer nome do cliente
├── Regras gerais
│   ├── Recibo obrigatorio acima de R$ 50
│   ├── Prazo de submissao: 5 dias uteis apos a despesa
│   ├── Prazo de submissao do relatorio: ate dia 5 do mes seguinte
│   └── Moeda: BRL (conversao manual para despesas em outras moedas)
├── Restricoes
│   ├── Bebidas alcoolicas: nao reembolsavel
│   ├── Classe executiva: apenas viagens > 6h com autorizacao previa
│   └── Hospedagem Airbnb: permitida se valor <= hotel equivalente
└── Excecoes
    ├── Viagem internacional: limites diferenciados por pais
    └── Evento com cliente: limite de representacao ampliado com justificativa
```

**Implementacao tecnica da politica:**
- Politica e uma entidade configuravel (nao hardcoded)
- Cada regra tem: categoria, tipo (limite, bloqueio, alerta), valor, condicao, mensagem
- Validacao executada no backend no momento da submissao
- Itens fora de politica recebem flag mas NAO sao bloqueados (consultor justifica, aprovador decide)
- Historico de alteracoes da politica mantido para auditoria

### 2.6 Regras de diaria (Per Diem)

**Dois modelos coexistem:**

#### Modelo A -- Per diem fixo
- Valor diario fixo por tipo de cidade/regiao
- Consultor recebe valor sem necessidade de recibos
- Mais simples de administrar
- Exemplo: Capital R$ 200/dia, Interior R$ 150/dia, Viagem internacional USD 80/dia

#### Modelo B -- Reembolso por comprovante
- Consultor gasta e apresenta recibos
- Reembolso ate o limite da politica
- Mais controle, mais burocracia
- Padrao no Brasil para a maioria das empresas

#### Modelo C -- Hibrido (mais comum)
- Per diem para alimentacao (simplifica)
- Reembolso por comprovante para hospedagem, transporte, combustivel (controle)
- Usado por empresas medias/grandes no Brasil

**Calculo de per diem:**
- Dia completo: 100% do valor
- Meio dia (saida apos 13h ou chegada antes de 13h): 50%
- Apenas jantar (saida apos 18h): 30%
- Configuravel por empresa

### 2.7 Calculo de quilometragem

**Metodo 1 -- Manual (MVP)**
- Consultor informa km inicial e km final do odometro
- Ou informa origem e destino, sistema calcula distancia via Google Directions API
- Valor reembolso = distancia * valor_por_km (definido na politica)

**Metodo 2 -- GPS automatico**
- App registra trajeto via GPS
- Calcula distancia real percorrida
- Mais preciso mas mais invasivo
- Badger Maps e MapMyCustomers usam este metodo

**Metodo 3 -- Distancia planejada (Google/Waze)**
- Sistema calcula distancia entre endereco de origem e endereco do cliente
- Usa rota mais curta ou mais rapida
- Menos preciso (nao considera desvios reais) mas nao invasivo
- Salesforce Maps usa este modelo

**Tabela de valores por km (referencia Brasil 2026):**
- Carro proprio: R$ 0,70 - R$ 1,00/km (varia por empresa)
- Moto propria: R$ 0,40 - R$ 0,60/km
- Referencia tributaria: tabela IRPF permite deducao de despesas com veiculo para autonomos

**Dados a armazenar:**
- Origem (endereco ou coordenadas)
- Destino (endereco ou coordenadas)
- Distancia em km
- Valor por km aplicado
- Valor total calculado
- Metodo de calculo (manual, GPS, API)
- Rota (polyline) se disponivel

### 2.8 Tratamento de moeda

Para o contexto brasileiro (CRM de laboratorio optico B2B):
- Moeda padrao: BRL
- Despesas em viagens internacionais: registrar valor original + moeda + taxa de cambio + valor convertido
- Fonte de cambio: taxa do dia (BCB / API de cambio) ou taxa do cartao corporativo
- **MVP:** Apenas BRL. Conversao manual se necessario.
- **Fase futura:** Campo moeda + conversao automatica

### 2.9 Rastreamento de status da despesa

**Status por item de despesa:**
| Status | Descricao | Cor sugerida |
|--------|-----------|-------------|
| Rascunho | Criado, nao enviado | Cinza |
| Pendente de recibo | Falta comprovante | Amarelo |
| Fora de politica | Excede limite ou regra | Laranja |
| Submetido | Parte de relatorio enviado | Azul |
| Aprovado | Aprovado pelo gerente | Verde |
| Rejeitado | Rejeitado pelo gerente | Vermelho |
| Reembolsado | Pagamento efetuado | Verde escuro |

**Status por relatorio de despesa:**
| Status | Descricao |
|--------|-----------|
| Rascunho | Em construcao |
| Submetido | Enviado para aprovacao |
| Em Revisao | Aprovador esta analisando |
| Devolvido | Devolvido para correcao |
| Parcialmente Aprovado | Alguns itens aprovados, outros rejeitados |
| Aprovado | Todos os itens aprovados |
| Em Pagamento | Financeiro processando |
| Reembolsado | Pago ao consultor |

### 2.10 Integracao com modulo financeiro

**Lancamentos gerados ao aprovar relatorio de despesas:**

```
Debito:  Despesas Comerciais / Despesas de Viagem (por categoria)
Credito: Adiantamentos a Funcionarios (se houve adiantamento)
   ou    Reembolsos a Pagar (se nao houve adiantamento)

Centro de custo: Departamento Comercial / Carteira do consultor
Rateio: por cliente visitado (se desejado)
```

**Pontos de integracao:**
- Aprovacao gera lancamento contabil (Contas a Pagar)
- Reembolso gera baixa do lancamento
- Adiantamento de viagem: valor antecipado antes da viagem, prestacao de contas depois
- Cartao corporativo: despesas do cartao importadas e vinculadas a visitas/relatorios
- Exportacao para contabilidade: arquivo CSV/OFX com lancamentos

---

## 3. Melhores Praticas da Industria

### 3.1 Salesforce Field Service + Salesforce Maps

**Visitas:**
- Objeto `Visit` nativo desde 2020 (parte do Retail Execution)
- Campos: PlannedVisitStartTime, PlannedVisitEndTime, ActualVisitStartTime, ActualVisitEndTime, PlacedId (conta), VisitorId (usuario)
- Visit Tasks: checklist de tarefas por visita (ex: verificar estoque, atualizar preco)
- Visit Templates: modelo reutilizavel de tarefas por tipo de visita
- Salesforce Maps (antigo MapAnything): otimizacao de rota, check-in com GPS, visualizacao de territorio

**Despesas:**
- NAO tem modulo nativo de despesas robusto
- Parceiros no AppExchange: Certify, Expensify, Rydoo
- Salesforce Field Service tem "Expense" como parte de Work Orders (tecnico), nao comercial
- Padrao de mercado: CRM para visitas, ferramenta separada para despesas, integracao via API

**Licoes aprendidas:**
- Visit como entidade separada de Activity/Event e fundamental
- Checklist de tarefas por visita aumenta qualidade dos dados
- Integracao CRM-despesas via API e mais flexivel que modulo monolitico

### 3.2 SAP CRM + SAP Concur

**Visitas (SAP CRM / SAP Sales Cloud):**
- "Activity" com tipo "Visit" no SAP CRM classico
- SAP Sales Cloud V2: "Visits" como objeto dedicado com check-in/check-out
- Integracao com SAP Customer Checkout para vendas no local
- Visit planning com rotas otimizadas (SAP Sales Cloud + HERE Maps)

**Despesas (SAP Concur):**
- Lider mundial em T&E management (60%+ market share enterprise)
- ExpenseIt: foto do recibo -> OCR -> item de despesa automatico
- Politicas configuradas como "rules engine" com condicoes complexas
- Aprovacao multi-nivel com delegacao, substituicao e escalacao
- Integracao nativa com SAP S/4HANA para lancamento contabil
- TripLink: captura automatica de despesas de viagem (hotel, aereo, carro alugado)

**Licoes aprendidas:**
- OCR de recibos e table-stakes em 2026, nao diferencial
- Motor de regras para politica de despesas e essencial para escala
- Captura automatica de dados de fornecedores (hotel, cia aerea) elimina digitacao

### 3.3 Microsoft Dynamics 365 Field Service + Business Central

**Visitas:**
- "Bookings" no Field Service (mais tecnico que comercial)
- Dynamics 365 Sales: "Appointments" com check-in via app mobile
- Integracao com Bing Maps para geocodificacao e roteamento
- Power Apps: permite construir app de visita customizado rapidamente

**Despesas:**
- Dynamics 365 Business Central: modulo "Expense Management" integrado
- Dynamics 365 Finance: "Travel and expense" com politicas, aprovacao, integracao contabil
- Power Automate: automacao de workflows de aprovacao
- Capture de recibos via app Dynamics 365 Expense (OCR com Azure AI)

**Licoes aprendidas:**
- Low-code (Power Apps/Power Automate) acelera customizacoes de workflow
- Modulo de despesas integrado ao ERP e melhor que ferramenta separada quando ja se tem ERP

### 3.4 Ferramentas especializadas em vendas de campo

#### Repsly
- Foco: FMCG / retail execution / vendas de campo
- Check-in com foto obrigatoria + GPS
- Formularios customizaveis por tipo de visita
- Schedule management (beat plan)
- Offline-first architecture
- Dashboards de cobertura e aderencia
- **Nao tem** modulo de despesas robusto

#### Badger Maps
- Foco: planejamento de rota para vendedores externos
- Otimizacao de rota com multiplas paradas
- Integracao com CRMs (Salesforce, HubSpot, Dynamics)
- Check-in com GPS + notas
- Calculo automatico de quilometragem
- **Nao tem** modulo de despesas

#### MapMyCustomers
- Foco: visualizacao geografica de pipeline + rota
- Mapa interativo com filtros (status, valor, ultimo contato)
- Check-in rapido com GPS
- Integracao CRM bidirecional
- **Nao tem** modulo de despesas

#### ForceManager
- Foco: CRM mobile-first para vendas de campo
- Check-in automatico por geofence
- Relatorio de visita com voz (speech-to-text)
- Cartao de visita OCR (captura contato novo)
- Offline completo
- **Tem** modulo basico de despesas por visita

**Conclusao da analise de mercado:**
> Nenhuma ferramenta de campo faz visita + despesas excepcionalmente bem. O mercado e fragmentado: CRM para pipeline, app de campo para visitas, e ferramenta T&E para despesas. Uma solucao integrada (visita + despesa + CRM) e um diferencial competitivo real.

### 3.5 Padroes de integracao Concur/Expensify

**API patterns comuns para integracao de despesas:**

| Padrao | Descricao | Quando usar |
|--------|-----------|-------------|
| Push de despesa | CRM cria item de despesa na ferramenta T&E via API | Quando T&E e sistema principal de despesas |
| Pull de despesa | CRM importa despesas aprovadas da ferramenta T&E | Quando quer consolidar no CRM |
| Webhook de status | T&E notifica CRM quando status muda (aprovado, reembolsado) | Para manter CRM atualizado |
| SSO compartilhado | Mesmo login para CRM e T&E | UX seamless |
| Deep link | CRM linka para relatorio especifico no T&E | Menor integracao, rapido de implementar |

**Para OpticalCore (recomendacao):** Como ja possui ERP proprio com modulo financeiro, o ideal e modulo de despesas integrado (nao ferramenta externa). Isso evita custo de licenca, complexidade de integracao e fragmentacao de dados.

---

## 4. Modelo de Dados Detalhado

### 4.1 Entidade Visita (Visit)

```
Visita
├── Id: Guid (PK)
├── Codigo: int (auto-increment, display)
├── TenantId / CompanyId: Guid (FK -> Empresa, multi-tenant)
├── ConsultorId: Guid (FK -> Usuario)
├── ClienteContaId: Guid (FK -> ClienteConta)
├── ContatoId: Guid? (FK -> Contato, opcional)
├── OportunidadeId: Guid? (FK -> Oportunidade, opcional)
├── PedidoId: Guid? (FK -> Pedido, gerado durante visita)
│
├── TipoVisitaId: Guid (FK -> TipoVisita, dominio)
├── StatusVisita: Enum (Planejada, EmDeslocamento, EmAndamento, PendenteRelatorio, Concluida, Cancelada)
│
├── DataHoraPlanejada: DateTimeOffset
├── DataHoraFimPlanejada: DateTimeOffset?
├── DataHoraCheckIn: DateTimeOffset?
├── DataHoraCheckOut: DateTimeOffset?
│
├── CheckInLatitude: decimal(10,7)?
├── CheckInLongitude: decimal(10,7)?
├── CheckInPrecisaoMetros: decimal?
├── CheckInEnderecoReverso: string? (geocoding reverso)
├── CheckOutLatitude: decimal(10,7)?
├── CheckOutLongitude: decimal(10,7)?
│
├── Objetivo: string (max 500)
├── AssuntosDiscutidos: string? (max 4000)
├── Resultado: string? (max 2000)
├── ProximosPassos: string? (max 2000)
├── ResultadoTipoId: Guid? (FK -> TipoResultadoVisita: PedidoFechado, PropostaSolicitada, SemInteresse, Reagendar, etc.)
├── NivelInteresse: int? (1-5)
│
├── DuracaoMinutos: int? (calculado)
├── DistanciaKm: decimal? (origem->destino)
│
├── Observacoes: string?
├── Ativo: bool (soft delete)
├── CriadoEm: DateTimeOffset
├── AtualizadoEm: DateTimeOffset?
├── CriadoPor: Guid
├── AtualizadoPor: Guid?
│
├── -- Navigation Properties --
├── Consultor: Usuario
├── ClienteConta: ClienteConta
├── Contato: Contato?
├── Oportunidade: Oportunidade?
├── TipoVisita: TipoVisita
├── Despesas: ICollection<Despesa>
├── Anexos: ICollection<VisitaAnexo>
├── ContatosPresentes: ICollection<VisitaContato> (many-to-many)
└── ProdutosApresentados: ICollection<VisitaProduto> (many-to-many)
```

### 4.2 Entidade Relatorio de Despesa (ExpenseReport)

```
RelatorioDespesa
├── Id: Guid (PK)
├── Codigo: int (auto-increment)
├── TenantId / CompanyId: Guid
├── ConsultorId: Guid (FK -> Usuario)
├── Titulo: string (max 200, ex: "Viagem SP - Marco 2026")
├── Descricao: string? (max 1000)
├── Periodo: string? (ex: "18/03 a 22/03/2026")
├── DataInicio: DateOnly?
├── DataFim: DateOnly?
│
├── StatusRelatorio: Enum (Rascunho, Submetido, EmRevisao, Devolvido, Aprovado, ParcialmenteAprovado, EmPagamento, Reembolsado)
│
├── ValorTotal: decimal (soma dos itens aprovados)
├── ValorSubmetido: decimal (soma dos itens submetidos)
├── ValorAprovado: decimal (soma dos itens aprovados)
├── ValorReembolsado: decimal
│
├── DataSubmissao: DateTimeOffset?
├── DataAprovacao: DateTimeOffset?
├── DataReembolso: DateTimeOffset?
│
├── AprovadorId: Guid? (FK -> Usuario)
├── ComentarioAprovador: string?
│
├── Ativo: bool
├── CriadoEm: DateTimeOffset
├── AtualizadoEm: DateTimeOffset?
│
├── -- Navigation Properties --
├── Consultor: Usuario
├── Aprovador: Usuario?
├── Itens: ICollection<DespesaItem>
└── Historico: ICollection<RelatorioDespesaHistorico>
```

### 4.3 Entidade Item de Despesa (ExpenseLineItem)

```
DespesaItem
├── Id: Guid (PK)
├── RelatorioDespesaId: Guid (FK -> RelatorioDespesa)
├── VisitaId: Guid? (FK -> Visita, opcional se despesa geral)
├── TenantId / CompanyId: Guid
│
├── CategoriaDespesaId: Guid (FK -> CategoriaDespesa, dominio)
├── Data: DateOnly
├── Descricao: string (max 500)
├── Valor: decimal(18,2)
├── Moeda: string (default "BRL", max 3)
├── TaxaCambio: decimal? (se moeda != BRL)
├── ValorBRL: decimal(18,2) (valor convertido)
│
├── Fornecedor: string? (max 200, nome do estabelecimento)
├── FornecedorCNPJ: string? (max 18)
├── FormaPagamento: Enum (Dinheiro, CartaoCorporativo, CartaoPessoal, PIX, Outro)
│
├── StatusItem: Enum (Rascunho, PendenteRecibo, Submetido, Aprovado, Rejeitado, Reembolsado)
├── ForaDePolitica: bool (flag automatico)
├── JustificativaForaPolitica: string? (preenchido pelo consultor)
├── MotivoRejeicao: string? (preenchido pelo aprovador)
│
├── -- Quilometragem (se categoria = Quilometragem) --
├── OrigemEndereco: string?
├── DestinoEndereco: string?
├── DistanciaKm: decimal?
├── ValorPorKm: decimal?
├── MetodoCalculo: Enum? (Manual, GPS, API)
│
├── Observacoes: string?
├── Ativo: bool
├── CriadoEm: DateTimeOffset
├── AtualizadoEm: DateTimeOffset?
│
├── -- Navigation Properties --
├── RelatorioDespesa: RelatorioDespesa
├── Visita: Visita?
├── CategoriaDespesa: CategoriaDespesa
└── Comprovantes: ICollection<DespesaComprovante>
```

### 4.4 Entidade Comprovante / Recibo (Receipt)

```
DespesaComprovante
├── Id: Guid (PK)
├── DespesaItemId: Guid (FK -> DespesaItem)
├── TenantId / CompanyId: Guid
│
├── NomeArquivo: string (max 255)
├── NomeArquivoOriginal: string (max 255)
├── ContentType: string (max 100, ex: "image/jpeg")
├── TamanhoBytes: long
├── StoragePath: string (caminho no blob storage)
├── ThumbnailPath: string? (miniatura)
├── HashSHA256: string (integridade)
│
├── -- OCR (fase 2+) --
├── OcrProcessado: bool (default false)
├── OcrValorExtraido: decimal?
├── OcrDataExtraida: DateOnly?
├── OcrEstabelecimentoExtraido: string?
├── OcrCnpjExtraido: string?
├── OcrConfianca: decimal? (0-100, confianca do OCR)
├── OcrJsonCompleto: string? (resultado bruto do OCR para debug)
│
├── CriadoEm: DateTimeOffset
├── CriadoPor: Guid
│
├── -- Metadados da foto --
├── Latitude: decimal? (EXIF GPS)
├── Longitude: decimal? (EXIF GPS)
├── DataHoraCaptura: DateTimeOffset? (EXIF DateTime)
└── DispositivoOrigem: string? (EXIF Device)
```

### 4.5 Entidade Historico de Aprovacao (ApprovalHistory)

```
RelatorioDespesaHistorico
├── Id: Guid (PK)
├── RelatorioDespesaId: Guid (FK -> RelatorioDespesa)
│
├── StatusAnterior: Enum
├── StatusNovo: Enum
├── Acao: Enum (Submetido, Aprovado, Rejeitado, Devolvido, Reembolsado, Editado)
├── UsuarioId: Guid (FK -> Usuario, quem executou a acao)
├── Comentario: string? (max 1000)
├── DataHora: DateTimeOffset
│
└── -- Navigation Properties --
    └── Usuario: Usuario
```

### 4.6 Entidades de Dominio / Lookup

```
TipoVisita (BaseDominio)
├── Id, Codigo, Nome, Descricao, Padrao, Ativo, Ordem
├── Valores seed: Prospecção, Manutenção, Negociação, Pós-Venda, Cobrança, Suporte Comercial

TipoResultadoVisita (BaseDominio)
├── Id, Codigo, Nome, Descricao, Padrao, Ativo, Ordem
├── Valores seed: Pedido Fechado, Proposta Solicitada, Sem Interesse, Reagendar, Follow-up Necessário, Visita Informativa

CategoriaDespesa (BaseDominio)
├── Id, Codigo, Nome, Descricao, Padrao, Ativo, Ordem
├── RequerRecibo: bool
├── LimiteValor: decimal? (limite por item, configuravel)
├── LimiteDiario: decimal? (limite por dia, configuravel)
├── PermiteQuilometragem: bool (flag para campos de km)
├── Valores seed: Combustível, Pedágio, Estacionamento, Hospedagem, Alimentação, Passagem Aérea, Transporte App/Táxi, Locação Veículo, Material Apoio, Representação, Outros

PoliticaDespesa
├── Id: Guid
├── TenantId: Guid
├── Nome: string
├── Ativo: bool
├── Regras: ICollection<RegraPoliticaDespesa>

RegraPoliticaDespesa
├── Id: Guid
├── PoliticaDespesaId: Guid
├── CategoriaDespesaId: Guid?
├── TipoRegra: Enum (LimiteValor, LimiteDiario, RequerRecibo, RequerJustificativa, Bloqueio)
├── Valor: decimal?
├── Condicao: string? (JSON, condicoes complexas)
├── Mensagem: string
```

### 4.7 Tabelas Auxiliares (Many-to-Many e Junction)

```
VisitaContato (junction)
├── VisitaId: Guid (FK)
├── ContatoId: Guid (FK)

VisitaProduto (junction)
├── VisitaId: Guid (FK)
├── ProdutoId: Guid (FK)
├── Observacao: string?

VisitaAnexo
├── Id: Guid
├── VisitaId: Guid (FK)
├── TipoAnexo: Enum (FotoFachada, FotoPrateleira, FotoProduto, Documento, Outro)
├── NomeArquivo: string
├── StoragePath: string
├── ThumbnailPath: string?
├── TamanhoBytes: long
├── CriadoEm: DateTimeOffset
```

### 4.8 Diagrama de Relacionamentos (texto)

```
Usuario (Consultor/Gerente)
    |
    ├── 1:N Visita (como consultor)
    ├── 1:N RelatorioDespesa (como consultor)
    └── 1:N RelatorioDespesaHistorico (como ator)

ClienteConta
    |
    └── 1:N Visita

Visita
    |
    ├── N:M Contato (via VisitaContato)
    ├── N:M Produto (via VisitaProduto)
    ├── 1:N VisitaAnexo
    ├── 1:N DespesaItem (despesas desta visita)
    └── N:1 Oportunidade (opcional)

RelatorioDespesa
    |
    ├── 1:N DespesaItem
    └── 1:N RelatorioDespesaHistorico

DespesaItem
    |
    ├── N:1 RelatorioDespesa
    ├── N:1 Visita (opcional)
    ├── N:1 CategoriaDespesa
    └── 1:N DespesaComprovante

DespesaComprovante
    |
    └── N:1 DespesaItem

PoliticaDespesa
    |
    └── 1:N RegraPoliticaDespesa
         └── N:1 CategoriaDespesa
```

---

## 5. Consideracoes Mobile-First

### 5.1 Integracao com camera

**Fluxo de captura de foto (recibo ou visita):**

1. Usuario toca icone de camera no app
2. App solicita permissao de camera (se primeira vez)
3. Abre camera nativa com overlay guia (bordas do recibo)
4. Usuario captura foto
5. App faz:
   - Crop automatico (deteccao de bordas via ML Kit / Vision API)
   - Compressao (JPEG 70-80%, max 1-2MB)
   - Extracao de metadados EXIF (GPS, timestamp, device)
   - Geracao de thumbnail (200x200px)
6. Preview para usuario confirmar ou recapturar
7. Salva localmente (offline-ready)
8. Envia ao servidor quando online

**Tecnologias recomendadas:**
- **React Native/Expo:** `expo-camera` + `expo-image-manipulator` + `expo-file-system`
- **PWA:** `navigator.mediaDevices.getUserMedia()` + Canvas API + File API
- **Crop automatico:** Google ML Kit Document Scanner (Android/iOS) ou OpenCV.js (PWA)

### 5.2 GPS para check-in/check-out

**Fluxo de captura GPS:**

1. Ao tocar "Check-in", app solicita permissao de localizacao
2. Configura requisicao de alta precisao (`enableHighAccuracy: true`)
3. Aguarda fix com precisao <= 50 metros (timeout 15 segundos)
4. Se timeout: aceita melhor posicao disponivel + flag de baixa precisao
5. Armazena: latitude, longitude, precisao, altitude, timestamp, provider

**Validacoes de GPS:**
- Distancia entre posicao e endereco do cliente > raio configuravel -> aviso (nao bloqueio)
- Precisao > 100 metros -> flag no check-in
- Timestamp do GPS muito diferente do timestamp do servidor -> flag (possivel fraude)
- GPS desabilitado -> permitir check-in sem GPS + flag obrigatorio

**Tecnologias:**
- **React Native/Expo:** `expo-location` (foreground only para CRM)
- **PWA:** Geolocation API (`navigator.geolocation.getCurrentPosition()`)
- **Geocoding reverso:** Google Geocoding API ou Nominatim (OSM, gratuito)

### 5.3 Sincronizacao offline (arquitetura detalhada)

```
+-------------------+     +------------------+     +------------------+
|  UI Layer         |     |  Sync Engine     |     |  Remote API      |
|  (React/RN)       |     |  (Background)    |     |  (ASP.NET Core)  |
+-------------------+     +------------------+     +------------------+
         |                        |                        |
         v                        v                        v
+-------------------+     +------------------+     +------------------+
|  Local DB         |<--->|  Sync Queue      |<--->|  PostgreSQL      |
|  (SQLite/IndexDB) |     |  (pending ops)   |     |  (source of      |
+-------------------+     +------------------+     |   truth)         |
                                                   +------------------+
```

**Operacoes offline suportadas (prioridade):**

| Operacao | Prioridade | Complexidade | Conflito possivel? |
|----------|-----------|--------------|-------------------|
| Check-in/check-out | P0 | Baixa | Nao (append-only) |
| Preencher relatorio visita | P0 | Baixa | Raro |
| Tirar foto | P0 | Media (upload) | Nao |
| Lancar despesa | P0 | Baixa | Raro |
| Consultar dados cliente | P1 | Media (cache) | N/A (read) |
| Criar pedido | P1 | Alta | Possivel |
| Editar relatorio submetido | P2 | Alta | Sim |

**Estrategia de resolucao de conflitos:**
- **Append-only** (check-in, fotos, despesas): sem conflito, sempre aceita
- **Last-write-wins** (campos simples como notas): versao mais recente vence
- **Manual merge** (edicoes concorrentes em campos criticos): apresenta diff para usuario resolver
- **Server-wins** (status de aprovacao): servidor sempre tem autoridade

### 5.4 Push notifications para aprovacoes

**Eventos que geram notificacao push:**

| Evento | Destinatario | Prioridade |
|--------|-------------|-----------|
| Novo relatorio para aprovacao | Gerente/Aprovador | Alta |
| Relatorio aprovado | Consultor | Media |
| Relatorio rejeitado/devolvido | Consultor | Alta |
| Reembolso efetuado | Consultor | Media |
| Lembrete: relatorio pendente | Consultor | Baixa |
| Lembrete: aprovacao pendente ha X dias | Gerente | Media |
| Visita planejada em 1 hora | Consultor | Media |
| Despesa fora de politica submetida | Gerente | Alta |

**Tecnologias:**
- **Push nativo (iOS/Android):** Firebase Cloud Messaging (FCM) + APNs
- **Web push:** Web Push API + Service Worker
- **In-app:** SignalR (ja usado no OpticalCore para chat)
- **Email fallback:** Para notificacoes de aprovacao (criticas)

**Payload de notificacao (exemplo):**
```json
{
  "type": "EXPENSE_REPORT_SUBMITTED",
  "title": "Novo relatório de despesas",
  "body": "João Silva submeteu relatório 'Viagem SP - Março' (R$ 1.850,00)",
  "data": {
    "relatorioId": "guid-here",
    "consultorNome": "João Silva",
    "valorTotal": 1850.00,
    "deepLink": "/crm/despesas/relatorios/guid-here"
  }
}
```

---

## 6. Recomendacoes Especificas para OpticalCore

### 6.1 Contexto do negocio

O OpticalCore e um ERP para laboratorios opticos (B2B). Os consultores de campo visitam oticas (clientes) para:
- Manter relacionamento e fidelizar
- Apresentar novos produtos/lentes
- Negociar precos e condicoes
- Coletar pedidos
- Resolver problemas de qualidade/prazo
- Prospectar novas oticas

### 6.2 MVP recomendado (Fase 1)

| Funcionalidade | Incluir no MVP? | Justificativa |
|---------------|----------------|---------------|
| Visita com check-in/check-out GPS | Sim | Core do modulo |
| Relatorio de visita (campos basicos) | Sim | Core |
| Tipos de visita (dominio) | Sim | Segmentacao |
| Fotos por visita | Sim | Prova de presenca |
| Lancamento de despesas por visita | Sim | Core |
| Categorias de despesa (dominio) | Sim | Organizacao |
| Foto de recibo (manual) | Sim | Comprovacao |
| Relatorio de despesas (agrupamento) | Sim | Core |
| Workflow aprovacao (1 nivel: gerente) | Sim | Controle minimo |
| Status tracking (rascunho->reembolsado) | Sim | Visibilidade |
| Quilometragem manual | Sim | Despesa mais comum |
| Politica basica (limites por categoria) | Sim | Controle |
| OCR de recibos | NAO (Fase 2) | Custo e complexidade |
| Quilometragem GPS automatica | NAO (Fase 2) | Invasividade |
| Offline completo | NAO (Fase 2) | Complexidade alta |
| Per diem automatico | NAO (Fase 2) | Regras variadas |
| Multi-nivel aprovacao | NAO (Fase 2) | Overengineering para MVP |
| Otimizacao de rota | NAO (Fase 3) | Depende de mapa |
| Integracao financeira | NAO (Fase 2) | Depende de Contas a Pagar |

### 6.3 Fase 2 (apos validacao do MVP)

- OCR assistido para recibos (Azure AI, ja no ecossistema .NET)
- Quilometragem por Google Directions API
- Offline basico (check-in + despesas + fotos)
- Aprovacao multi-nivel
- Per diem configuravel
- Integracao com modulo financeiro (Contas a Pagar)
- Dashboards de despesas

### 6.4 Fase 3 (escala)

- Geofence para check-in automatico
- Otimizacao de rota (Google Routes API)
- OCR automatico com alta confianca
- Offline completo com sync engine
- Cartao corporativo (importacao de extratos)
- Analytics avancado (anomaly detection em despesas)
- App mobile nativo ou PWA dedicado

---

## 7. Referencias e Fontes

### CRM e Vendas de Campo
- Salesforce Retail Execution / Visits: https://help.salesforce.com/s/articleView?id=sf.retail_visit.htm
- SAP Sales Cloud Visit Management: https://help.sap.com/docs/SAP_SALES_CLOUD
- Microsoft Dynamics 365 Field Service: https://learn.microsoft.com/en-us/dynamics365/field-service/
- Repsly (field execution): https://www.repsly.com/
- Badger Maps (route planning): https://www.badgermapping.com/
- MapMyCustomers (field sales CRM): https://mapmycustomers.com/
- ForceManager (mobile CRM): https://www.forcemanager.com/

### Gestao de Despesas (T&E)
- SAP Concur: https://www.concur.com/
- Expensify: https://www.expensify.com/
- Rydoo: https://www.rydoo.com/
- Zoho Expense: https://www.zoho.com/expense/
- Navan (formerly TripActions): https://navan.com/
- Brex (corporate card + expense): https://www.brex.com/

### OCR e Document AI
- Google Document AI: https://cloud.google.com/document-ai
- Azure AI Document Intelligence: https://azure.microsoft.com/en-us/products/ai-services/ai-document-intelligence
- Amazon Textract: https://aws.amazon.com/textract/
- Mindee (receipt OCR): https://mindee.com/
- Veryfi (expense OCR): https://www.veryfi.com/

### Geolocalizacao e Mapas
- Google Maps Platform: https://developers.google.com/maps
- Google Directions API: https://developers.google.com/maps/documentation/directions
- Google Geocoding API: https://developers.google.com/maps/documentation/geocoding
- Nominatim (OSM geocoding): https://nominatim.org/

### Mobile e Offline
- Expo Location: https://docs.expo.dev/versions/latest/sdk/location/
- Expo Camera: https://docs.expo.dev/versions/latest/sdk/camera/
- Web Push API: https://developer.mozilla.org/en-US/docs/Web/API/Push_API
- Background Sync API: https://developer.mozilla.org/en-US/docs/Web/API/Background_Synchronization_API
- IndexedDB: https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API

### LGPD e Privacidade (GPS)
- Lei 13.709/2018 (LGPD): http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm
- LGPD e geolocalizacao de funcionarios: consentimento explicito necessario, finalidade especifica, minimizacao de dados
