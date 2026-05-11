# CRM para Laboratório Óptico — Pesquisa Específica do Setor

**Data da pesquisa:** 31/03/2026  
**Contexto:** Módulo CRM do OpticalCore ERP, voltado para laboratórios ópticos que vendem para ópticas (B2B).  
**Complementa:** `estudo_crm.md` (estudo genérico de CRM)

---

## 1. O Negócio: Laboratório Óptico B2B

### 1.1 Cadeia de Valor

```
Fornecedores         Laboratório Óptico (TENANT)        Ópticas (CLIENTES)        Consumidor Final
─────────────        ──────────────────────────         ──────────────────        ─────────────────
Blocos de lente      Recebe pedido da óptica            Recebe prescrição do      Usa os óculos
Insumos químicos     Fabrica lente sob medida           consumidor final
Armações (revenda)   Aplica tratamentos                 Faz montagem no aro
Equipamentos         Expede para a óptica               Ajusta e entrega
```

O laboratório óptico opera no modelo **B2B make-to-order**: cada pedido de lente é fabricado sob encomenda conforme a receita oftalmológica do consumidor final. O cliente direto do laboratório é a **óptica** (loja de óculos), que repassa a receita ao laboratório e recebe a lente pronta para montar no aro escolhido pelo consumidor.

### 1.2 Modelo de Receita do Laboratório

| Fonte de Receita | Descrição | % Estimada |
|-------------------|-----------|:----------:|
| **Lentes oftálmicas** | Produto principal: lentes sob medida (visão simples, bifocal, progressiva, ocupacional) | 60-75% |
| **Tratamentos/Coatings** | Antirreflexo, fotossensível, blue light, hidrofóbico — vendidos como add-on à lente | 15-25% |
| **Lentes prontas (surfaçadas)** | Lentes com grau padrão, estoque pronto | 5-10% |
| **Armações (revenda)** | Alguns labs revendem armações para ópticas menores | 0-5% |
| **Serviços** | Retrabalho, montagem especial, consultoria técnica | 2-5% |

### 1.3 Produtos Vendidos — Detalhamento

#### Lentes Oftálmicas (por tipo de design)

| Tipo | Complexidade | Preço Relativo | Volume |
|------|:------------:|:--------------:|:------:|
| **Visão Simples (SV)** | Baixa | $ | Alto |
| **Bifocal** | Média | $$ | Médio (em declínio) |
| **Progressiva** | Alta | $$$ a $$$$ | Médio-Alto (crescendo) |
| **Ocupacional/Office** | Alta | $$$ | Baixo-Médio |
| **Especiais** (prismáticas, lenticulares, esportivas) | Muito alta | $$$$ | Baixo |

#### Materiais de Lente

| Material | Índice de Refração | Faixa de Preço |
|----------|:------------------:|:--------------:|
| CR-39 (resina padrão) | 1.50 | $ |
| Policarbonato | 1.59 | $$ |
| Mid-index | 1.56 / 1.61 | $$ |
| High-index | 1.67 | $$$ |
| Ultra high-index | 1.74 | $$$$ |
| Trivex | 1.53 | $$ |

#### Tratamentos (Coatings)

| Tratamento | Descrição | Modelo de Venda |
|------------|-----------|:---------------:|
| **Antirreflexo (AR)** | Camadas que eliminam reflexos | Add-on obrigatório em progressivas premium |
| **Fotossensível (Transitions)** | Escurece com UV | Add-on opcional muito popular |
| **Blue Light (filtro de luz azul)** | Filtra luz HEV | Add-on de alta demanda |
| **Hidrofóbico** | Repele água e oleosidade | Normalmente incluso no AR premium |
| **Anti-risco (hard coat)** | Proteção mecânica | Incluso como padrão em muitos labs |

### 1.4 Ciclo Típico de um Pedido

```
1. Óptica recebe consumidor → prescrição oftalmológica
2. Óptica monta pedido (receita + lente + tratamentos + armação) via:
   - Portal web do laboratório
   - WhatsApp/telefone (labs menores)
   - Sistema integrado (labs grandes)
3. Laboratório recebe pedido → valida receita → entra na produção
4. Produção: surfaçagem → polimento → tratamento → montagem (se armação enviada) → inspeção
5. Expedição: lente embalada → transportadora ou motoboy
6. Óptica recebe → monta no aro → entrega ao consumidor

Prazo típico: 3 a 7 dias úteis (visão simples: 1-3 dias; progressiva premium: 5-7 dias)
Pedidos urgentes ("express"): 24-48 horas com sobretaxa
```

---

## 2. Processo Comercial B2B do Laboratório Óptico

### 2.1 Como o Laboratório Vende para Ópticas

O processo comercial de um laboratório óptico difere substancialmente de vendas B2B tradicionais:

**Aquisição de clientes (ópticas novas):**
1. **Prospecção ativa** — Vendedor externo identifica ópticas na região que compram de concorrentes
2. **Visita inicial** — Apresentação do portfólio de lentes, tabela de preços, prazos, diferenciais
3. **Demonstração técnica** — Amostras de lentes, comparação de tratamentos, catálogo de marcas
4. **Negociação comercial** — Tabela de preço, condição de pagamento, prazo de entrega, frete
5. **Primeira compra piloto** — Pedido pequeno para validar qualidade e prazo
6. **Cadastro e onboarding** — Acesso ao portal de pedidos, treinamento do sistema, material de apoio

**Manutenção e crescimento da carteira:**
- Visitas regulares para manter relacionamento
- Treinamento contínuo da equipe da óptica sobre novos produtos
- Resolução rápida de problemas (defeitos, atrasos, reclamações)
- Campanhas de upgrade (ex: migrar óptica de lentes básicas para progressivas premium)
- Acompanhamento de volume e mix de produtos

### 2.2 Ciclo de Vendas

| Fase | Duração Típica | Atividades |
|------|:--------------:|------------|
| **Identificação** | Contínuo | Mapeamento de ópticas na região, referências, Google Maps |
| **Primeiro contato** | 1-2 semanas | Ligação/WhatsApp → visita agendada |
| **Apresentação** | 1 visita | Portfólio, amostras, tabela |
| **Negociação** | 1-4 semanas | Preço, prazo, frete, condição pagamento |
| **Pedido piloto** | 1-2 semanas | Primeira compra, avaliação de qualidade |
| **Ativação** | 1-2 semanas | Cadastro no sistema, onboarding, treinamento |
| **Recorrência** | Indefinida | Pedidos diários/semanais da óptica ativa |

**Observação crítica:** Após a ativação, o "ciclo de vendas" se transforma em **gestão de conta recorrente**. A maioria da receita vem de ópticas que já compram regularmente, não de novas aquisições. O CRM precisa equilibrar prospecção (funil) com gestão de carteira ativa (retenção e crescimento).

### 2.3 Padrões de Pedidos das Ópticas

| Perfil da Óptica | Frequência de Pedidos | Volume Médio/Mês | Características |
|-------------------|-----------------------|:-----------------:|-----------------|
| **Grande rede** | Diário (múltiplos) | 500+ pares | Preço agressivo, exige prazo curto, compra por tabela contratual |
| **Óptica média** | 3-5x por semana | 80-200 pares | Bom mix de produtos, sensível a atendimento e prazo |
| **Óptica pequena** | 1-3x por semana | 20-80 pares | Mais sensível a preço, compra produtos básicos |
| **Óptica eventual** | Esporádica | <20 pares | Compra de outro lab principal, complementar |

---

## 3. Modelo de Precificação do Setor

### 3.1 Estrutura de Preços

A precificação no setor óptico tem múltiplas dimensões:

```
Preço final da lente = Base (design + material + diâmetro) + Tratamentos + Frete

Onde:
- Base: determinada pelo tipo de lente (SV/bifocal/progressiva), material (CR-39 a 1.74) e diâmetro
- Tratamentos: cada coating tem preço adicional (AR, fotossensível, blue light)
- Frete: por pedido ou por período (mensal)
```

### 3.2 Tabelas de Preço por Tier de Cliente

O modelo mais comum é ter **múltiplas tabelas de preço** baseadas no perfil do cliente:

| Tier | Critério | Desconto vs. Tabela Base | Exemplo |
|------|----------|:------------------------:|---------|
| **Premium / Rede** | Volume > 300 pares/mês, contrato | 30-40% | Grandes redes de óptica |
| **Gold** | Volume 100-300 pares/mês, fidelidade | 20-30% | Ópticas médias regulares |
| **Silver** | Volume 50-100 pares/mês | 10-20% | Ópticas menores ativas |
| **Standard** | Qualquer volume | Tabela cheia | Ópticas novas ou eventuais |

**Integração com OpticalCore:** O módulo de Vendas já possui `TabelaPreco` com `TipoAplicacao` (Geral, PorCliente, PorGrupoCliente, PorRegiao, PorCanalVenda) e `Prioridade` para resolver conflitos. O CRM deve alimentar a classificação do cliente que determina qual tabela se aplica.

### 3.3 Descontos e Promoções Específicas do Setor

| Tipo de Desconto | Descrição | Controle Necessário |
|------------------|-----------|---------------------|
| **Volume mensal** | Desconto adicional se atingir meta de volume | Apuração automática mensal |
| **Mix de produtos** | Desconto se comprar % mínimo de progressivas premium | Monitoramento de mix |
| **Pontualidade** | Desconto se pagar sem atraso | Integração com Financeiro |
| **Lançamento** | Preço promocional para novos produtos/tratamentos | Vigência na tabela de preço |
| **Campanha sazonal** | Black Friday, Dia das Mães, volta às aulas | Tabela temporária |
| **Frete grátis** | Para volume acima de X pares/pedido | Regra por cliente/região |

### 3.4 Bonificação e Incentivos

| Mecanismo | Descrição |
|-----------|-----------|
| **Verba de marketing** | Lab financia material da óptica (fachada, display) em troca de exclusividade parcial |
| **Equipamento em comodato** | Lab empresta edger, lensômetro, pupilômetro digital |
| **Treinamento gratuito** | Lab treina equipe da óptica em progressivas, tratamentos |
| **Viagens/eventos** | Convite para congressos ópticos (ABIOPTICA, MIDO, etc.) |
| **Rebate** | Devolução de % sobre compras do período se atingir meta |

---

## 4. Necessidades Específicas de CRM para Laboratório Óptico

### 4.1 Perfil do Cliente (Óptica)

O cadastro de cliente no CRM para laboratório óptico precisa ir além do cadastro genérico de Pessoa/Cliente. Campos e informações adicionais específicos do setor:

#### Dados Básicos (já existem no Cliente)
- Razão social, nome fantasia, CNPJ, IE
- Endereço, contatos, e-mail, telefone, WhatsApp
- Limite de crédito, prazo de pagamento, inadimplência

#### Dados Específicos da Óptica (novos para CRM)

| Campo/Informação | Tipo | Descrição |
|-------------------|------|-----------|
| **Classificação/Tier** | Domínio | Premium, Gold, Silver, Standard |
| **Segmento** | Domínio | Rede, Franquia, Independente, Ótica Popular, Clínica Oftalmológica |
| **Porte** | Domínio | Grande, Médio, Pequeno |
| **Número de lojas** | int | Quantas filiais a rede possui |
| **Faturamento estimado** | decimal | Faturamento mensal estimado da óptica |
| **Volume estimado/mês** | int | Pares de lente estimados por mês |
| **Potencial de crescimento** | Domínio | Alto, Médio, Baixo |
| **Lab principal** | string | Qual laboratório é o fornecedor principal |
| **Labs concorrentes** | string | Quais outros labs atendem essa óptica |
| **% de share estimado** | decimal | % do volume da óptica que vem do nosso lab |
| **Marcas trabalhadas** | N:N | Essilor, Zeiss, Hoya, Tokai, etc. |
| **Principais produtos comprados** | Calculado | Mix de SV/bifocal/progressiva/tratamentos |
| **Tem edger próprio** | bool | Se a óptica faz montagem (corte de lente) |
| **Modelo do edger** | string | Marca e modelo do equipamento de corte |
| **Equipamentos em comodato** | 1:N | Equipamentos emprestados pelo lab |
| **Data de cadastro como cliente** | DateTime | Quando começou a comprar |
| **Origem do cadastro** | Domínio | Prospecção, Indicação, Feira, Site, Outro |
| **Vendedor responsável** | FK Funcionário | Representante que atende a óptica |
| **Região de venda** | FK RegiaoVenda | Região comercial |

#### Contatos Relevantes da Óptica

Uma óptica possui diferentes perfis de contato, cada um com papel distinto:

| Papel do Contato | Relevância para o CRM |
|-------------------|----------------------|
| **Proprietário/Sócio** | Decisor de compra, negociação de tabela, pagamentos |
| **Gerente da loja** | Operação diária, pedidos, reclamações |
| **Optometrista/Oftalmologista** | Influenciador técnico, decide grau de complexidade das lentes |
| **Técnico óptico (montador)** | Faz pedidos operacionais, reporta defeitos |
| **Vendedor(a) de balcão** | Recomenda tipo de lente/tratamento ao consumidor |
| **Financeiro** | Pagamentos, conciliação, negociação de prazo |

**Integração com OpticalCore:** O modelo atual (`Pessoa` + `Cliente`) já suporta o cadastro básico. Os campos específicos da óptica podem ser adicionados como entidade `PerfilCrmCliente` (1:1 com Cliente) ou como extensão da própria entidade Cliente. Os contatos múltiplos devem usar a entidade `Contato` já existente no modelo `Pessoa`, com um campo adicional `Papel/Cargo` (domínio) para classificar.

### 4.2 Classificação e Segmentação de Clientes

#### Modelo de Classificação Multidimensional

```
Eixo 1 — Valor (volume x ticket x mix)
├── A: Top 20% em faturamento
├── B: Próximos 30%
├── C: Próximos 30%
└── D: Últimos 20%

Eixo 2 — Potencial de Crescimento
├── Alto: < 30% share, grande volume total estimado
├── Médio: 30-60% share OU volume moderado
└── Baixo: > 60% share, óptica pequena sem crescimento

Eixo 3 — Engajamento/Risco
├── Ativo: comprou nos últimos 30 dias
├── Em risco: 30-60 dias sem compra
├── Inativo: 60-90 dias sem compra
└── Perdido: > 90 dias sem compra

Resultado → Matriz 4x3x4 = estratégia de atendimento diferenciada
```

**Integração com OpticalCore:** Os relatórios já documentados (Curva ABC de Clientes, Análise RFM, Score de Churn, CLV) fornecem os dados analíticos. O CRM deve consumir esses indicadores para classificar automaticamente os clientes e disparar alertas/ações.

### 4.3 Análise de Mix de Produtos por Cliente

Um dos indicadores mais valiosos no setor óptico é o **mix de produtos** que cada óptica compra:

| Métrica | Cálculo | Importância |
|---------|---------|:-----------:|
| **% Progressivas** | Pedidos progressivas / Total pedidos | Alta — indica maturidade da óptica |
| **% Premium (1.67+)** | Pedidos alto índice / Total pedidos | Alta — indica ticket médio |
| **% com AR premium** | Pedidos com antirreflexo top / Total | Média — indica upsell |
| **% Fotossensível** | Pedidos com Transitions / Total | Média — indica penetração de add-on |
| **Ticket médio por par** | Receita total / Total de pares | Alta — saúde da conta |
| **Tendência de volume** | Volume mês atual vs. 3 meses anteriores | Alta — detecta churn |

**Por que isso importa:** Uma óptica que compra 80% visão simples em CR-39 tem potencial de upgrade enorme. O vendedor pode focar em treinar a equipe da óptica para oferecer progressivas e tratamentos premium ao consumidor final, aumentando o ticket médio para ambos (óptica e laboratório).

### 4.4 Gestão de Reclamações e Devoluções

No setor óptico, reclamações são frequentes e têm impacto direto na retenção:

| Tipo de Reclamação | Frequência | Impacto | Resolução Típica |
|--------------------|:----------:|:-------:|-------------------|
| **Lente com defeito visual** | Média | Alto | Refação gratuita |
| **Grau errado** | Baixa-Média | Alto | Verificar receita → refação |
| **Tratamento descascando** | Média | Médio | Garantia → troca |
| **Atraso na entrega** | Alta | Médio | Comunicação proativa + compensação |
| **Lente não encaixa no aro** | Baixa | Médio | Retrabalho ou refação |
| **Divergência de preço** | Baixa | Baixo | Acerto financeiro |
| **Embalagem danificada** | Baixa | Baixo | Reenvio |

**Métricas de qualidade por cliente:**
- Taxa de refação (% de pedidos que precisaram ser refeitos)
- Tempo médio de resolução de reclamação
- Motivos mais frequentes (por cliente e por período)
- Custo de refação por cliente

**Integração com OpticalCore:** O módulo de Vendas já prevê `Devoluções de Venda` com motivos. O CRM deve agregar esses dados por cliente para dar visibilidade ao vendedor e ao gerente sobre a saúde da conta.

### 4.5 Equipamentos em Comodato

Laboratórios frequentemente emprestam equipamentos para ópticas como estratégia de fidelização:

| Equipamento | Valor Estimado | Finalidade | Condição |
|-------------|:--------------:|------------|----------|
| **Edger (cortadora de lente)** | R$ 15.000 - 80.000 | Permite à óptica montar óculos | Comodato vinculado a volume mínimo |
| **Lensômetro digital** | R$ 3.000 - 15.000 | Medir grau de lentes | Empréstimo para fidelização |
| **Pupilômetro digital** | R$ 2.000 - 8.000 | Medir distância pupilar | Empréstimo ou bonificação |
| **Display de lentes** | R$ 500 - 2.000 | Expositor de demonstração | Material de marketing |
| **Totem/tablet de demonstração** | R$ 1.000 - 5.000 | Simulador de lentes para consumidor | Marketing conjunto |

**Dados necessários no CRM:**
- Equipamento: modelo, número de série, valor patrimonial
- Cliente: qual óptica está com o equipamento
- Contrato: volume mínimo exigido, prazo, condições de devolução
- Status: em uso, devolvido, em manutenção
- Histórico: movimentações, manutenções

### 4.6 Treinamento e Capacitação de Ópticas

O treinamento é uma ferramenta de vendas fundamental:

| Tipo de Treinamento | Público-alvo na Óptica | Impacto Comercial |
|---------------------|------------------------|-------------------|
| **Lentes progressivas** | Vendedores de balcão | Aumento de prescrições de progressivas |
| **Novos tratamentos** | Vendedores + optometristas | Aumento de add-ons |
| **Uso do portal de pedidos** | Técnico/gerente | Redução de erros, mais pedidos via portal |
| **Adaptação de lentes especiais** | Optometristas | Abre mercado de lentes especiais |
| **Técnicas de venda** | Vendedores de balcão | Aumento de ticket médio do consumidor |
| **Montagem e ajuste** | Técnico óptico | Redução de reclamações |

**Dados necessários no CRM:**
- Registro de treinamentos realizados por óptica
- Participantes e suas funções
- Tema e data
- Resultado percebido (feedback, impacto em vendas)
- Próximo treinamento recomendado

---

## 5. Vendas Externas no Setor Óptico

### 5.1 Perfil do Vendedor Externo de Laboratório

O vendedor externo (também chamado de "consultor comercial" ou "representante") é o elo principal entre laboratório e óptica.

**Atividades típicas:**
- Visitar ópticas da carteira regularmente
- Prospectar novas ópticas na região
- Apresentar novos produtos e promoções
- Treinar equipe da óptica
- Resolver problemas (reclamações, atrasos, devoluções)
- Negociar tabela de preço e condições
- Acompanhar volume e mix de compras
- Coletar inteligência competitiva
- Demonstrar produtos com amostras e catálogos
- Participar de eventos do setor

### 5.2 Frequência de Visitas

| Classificação do Cliente | Frequência Recomendada | Tipo de Visita |
|--------------------------|:----------------------:|----------------|
| **Conta-chave (Top 10)** | Semanal | Relacionamento, acompanhamento, resolução |
| **Ativo A (alta receita)** | Quinzenal | Manutenção, novos produtos, treinamento |
| **Ativo B (média receita)** | Mensal | Manutenção, busca de crescimento |
| **Ativo C (baixa receita)** | Bimestral | Tentativa de upgrade, verificação de satisfação |
| **Prospect quente** | Conforme pipeline | Apresentação, negociação |
| **Inativo/em risco** | Urgente | Recuperação, entendimento do problema |

### 5.3 Território Comercial

A divisão territorial no setor óptico brasileiro geralmente segue:

| Nível | Exemplo | Responsável |
|-------|---------|:-----------:|
| **Nacional** | Todo o Brasil | Diretor comercial |
| **Macro-região** | Sul, Sudeste, Nordeste | Gerente regional |
| **Estado/UF** | SP, RJ, MG | Gerente estadual (labs grandes) |
| **Micro-região** | Interior de SP, Grande SP, Litoral SP | Vendedor externo |
| **Cidade** | São Paulo Capital, Campinas | Vendedor externo (em mercados densos) |

**Integração com OpticalCore:** O módulo de Vendas já possui `RegiaoVenda` com UFs e `VendedorResponsavel`. O CRM deve estender isso para micro-regiões e permitir vinculação da óptica ao território.

### 5.4 Material que o Vendedor Carrega

| Item | Finalidade |
|------|------------|
| Catálogo de lentes (físico/digital) | Apresentar portfólio |
| Amostras de lentes com tratamentos | Demonstração visual |
| Tabela de preço atualizada | Negociação |
| Tablet com sistema CRM | Registro de visitas, pedidos, consultas |
| Material de marketing (folders, displays) | Deixar na óptica |
| Formulário de pedido simplificado | Backup se sistema offline |

### 5.5 Inteligência Competitiva

O vendedor coleta informações valiosas sobre a concorrência em cada visita:

| Informação | Como Obtém | Valor para o CRM |
|------------|------------|-------------------|
| Qual lab principal da óptica | Conversa com proprietário | Identificar oportunidade |
| Quais outros labs atendem | Observação + conversa | Mapa competitivo |
| Preço praticado pelo concorrente | Proprietário compartilha | Ajustar tabela |
| Prazo de entrega do concorrente | Feedback da óptica | Benchmark operacional |
| Problemas com concorrente | Reclamação espontânea | Oportunidade de captura |
| Novos produtos do concorrente | Catálogos na óptica | Roadmap de produtos |

**Entidade sugerida no CRM:** `InteligenciaCompetitiva` vinculada à Visita, com campos: concorrente, tipo de informação, detalhe, data, vendedor.

---

## 6. Entidades Específicas do CRM para Laboratório Óptico

### 6.1 Mapa de Entidades

```
CRM Module (M8)
├── PerfilCrmCliente (1:1 com Cliente)
│   ├── Classificação/Tier
│   ├── Segmento
│   ├── Potencial
│   ├── Lab principal
│   ├── Labs concorrentes
│   ├── Share estimado
│   ├── Volume estimado
│   └── Flags (tem edger, etc.)
│
├── ContatoCliente (1:N de Cliente — estende Contato existente)
│   ├── Papel (Proprietário, Gerente, Optometrista, Técnico, Vendedor, Financeiro)
│   ├── É decisor?
│   ├── É influenciador técnico?
│   └── Preferência de contato
│
├── Oportunidade
│   ├── Cliente (FK)
│   ├── Vendedor (FK)
│   ├── Valor estimado
│   ├── Etapa do funil
│   ├── Probabilidade
│   ├── Produto/serviço alvo
│   ├── Previsão de fechamento
│   └── Motivo de ganho/perda
│
├── EtapaPipeline (Domínio)
│   ├── Identificação
│   ├── Primeiro Contato
│   ├── Apresentação
│   ├── Negociação
│   ├── Pedido Piloto
│   ├── Ativação
│   ├── Ganho / Perdido
│   └── (configurável por processo)
│
├── Visita
│   ├── Cliente (FK)
│   ├── Contato principal (FK)
│   ├── Oportunidade (FK, opcional)
│   ├── Vendedor (FK)
│   ├── Tipo (Prospecção, Manutenção, Treinamento, Reclamação, Cobrança)
│   ├── Data/hora planejada e realizada
│   ├── Check-in/check-out (GPS)
│   ├── Objetivo
│   ├── Resultado/Notas
│   ├── Próximos passos
│   ├── Status (Planejada, Realizada, Cancelada, Reagendada)
│   ├── Despesas vinculadas
│   └── Anexos/Fotos
│
├── DespesaVisita
│   ├── Visita (FK)
│   ├── Categoria (combustível, pedágio, alimentação, etc.)
│   ├── Valor
│   ├── Comprovante (foto)
│   └── Status de aprovação
│
├── EquipamentoComodato
│   ├── Equipamento (tipo, modelo, série, valor)
│   ├── Cliente (FK)
│   ├── Data de instalação
│   ├── Volume mínimo contratual
│   ├── Status (em uso, devolvido, manutenção)
│   └── Histórico de movimentações
│
├── TreinamentoCliente
│   ├── Cliente (FK)
│   ├── Vendedor (FK)
│   ├── Visita (FK, opcional)
│   ├── Tema
│   ├── Data
│   ├── Participantes
│   └── Resultado/Feedback
│
├── InteligenciaCompetitiva
│   ├── Cliente (FK)
│   ├── Vendedor (FK)
│   ├── Visita (FK, opcional)
│   ├── Concorrente (Domínio)
│   ├── Tipo de informação
│   ├── Detalhe
│   └── Data
│
├── AtividadeCrm (Tarefas/Follow-ups)
│   ├── Cliente (FK)
│   ├── Vendedor (FK)
│   ├── Tipo (Ligação, E-mail, WhatsApp, Tarefa, Lembrete)
│   ├── Descrição
│   ├── Data prevista / realizada
│   └── Status
│
├── Meta (estende MetaVenda existente)
│   ├── Vendedor (FK)
│   ├── Região (FK)
│   ├── Período
│   ├── Tipo (Receita, Volume, Novos Clientes, Mix Progressivas)
│   ├── Valor meta vs. realizado
│   └── Status
│
└── Domínios (tabelas de lookup)
    ├── ClassificacaoCliente (Premium, Gold, Silver, Standard)
    ├── SegmentoOptica (Rede, Franquia, Independente, Popular, Clínica)
    ├── PorteCliente (Grande, Médio, Pequeno)
    ├── PotencialCrescimento (Alto, Médio, Baixo)
    ├── TipoVisita (Prospecção, Manutenção, Treinamento, Reclamação, Cobrança)
    ├── StatusVisita (Planejada, Realizada, Cancelada, Reagendada)
    ├── CategoriaDespesa (Combustível, Pedágio, Alimentação, Hotel, etc.)
    ├── StatusDespesa (Rascunho, Enviada, Aprovada, Rejeitada, Reembolsada)
    ├── PapelContato (Proprietário, Gerente, Optometrista, Técnico, Vendedor, Financeiro)
    ├── ConcorrenteLab (Essilor/LOLA, Zeiss, Hoya, Carl Zeiss, labs regionais)
    ├── TipoEquipamento (Edger, Lensômetro, Pupilômetro, Display, Totem)
    ├── StatusEquipamento (Em Uso, Devolvido, Manutenção)
    ├── OrigemCadastro (Prospecção, Indicação, Feira, Site, Outro)
    └── MotivoPerda (Preço, Prazo, Qualidade, Atendimento, Concorrente, Outro)
```

### 6.2 Relações com Módulos Existentes do OpticalCore

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   CADASTROS │     │    VENDAS    │     │   ESTOQUE    │
│   (M1)      │     │   (M2)       │     │   (M4)       │
│             │     │              │     │              │
│ Pessoa ◄────┼──── │ PedidoVenda  │     │ Saldo        │
│ Cliente ◄───┼──── │ TabelaPreco  │     │ Movimentação │
│ Produto     │     │ RegiaoVenda  │     │              │
│ Funcionário │     │ MetaVenda    │     │              │
└──────┬──────┘     └──────┬───────┘     └──────────────┘
       │                   │
       │    ┌──────────────┼───────────────┐
       │    │              │               │
       ▼    ▼              ▼               ▼
┌─────────────────────────────────────────────────┐
│                    CRM (M8)                      │
│                                                  │
│  PerfilCrmCliente ── liga Cliente ↔ CRM          │
│  Oportunidade ── usa Cliente, Vendedor           │
│  Visita ── usa Cliente, Vendedor, Oportunidade   │
│  DespesaVisita ── vinculada à Visita             │
│  EquipamentoComodato ── vinculado ao Cliente     │
│  TreinamentoCliente ── vinculado ao Cliente      │
│  InteligenciaCompetitiva ── via Visita           │
│  AtividadeCrm ── usa Cliente, Vendedor           │
│                                                  │
│  CONSOME:                                        │
│  - PedidoVenda → volume, mix, ticket por cliente │
│  - TabelaPreco → tier de preço do cliente        │
│  - RegiaoVenda → território do vendedor          │
│  - MetaVenda → metas do vendedor/região          │
│  - Saldo Estoque → disponibilidade para promessa │
│  - ContaReceber → inadimplência, crédito         │
│  - DevolucaoVenda → taxa de refação              │
│  - Chat/WhatsApp → histórico de comunicação      │
│                                                  │
│  ALIMENTA:                                       │
│  - Classificação → determina TabelaPreco         │
│  - Oportunidade ganha → gera PedidoVenda         │
│  - Visita → pode gerar PedidoVenda               │
│  - Alertas → notifica via Chat/WhatsApp          │
└─────────────────────────────────────────────────┘
       │                               │
       ▼                               ▼
┌──────────────┐              ┌──────────────┐
│  FINANCEIRO  │              │  CHAT/WHATS  │
│   (M5)       │              │              │
│              │              │              │
│ ContaReceber │              │ Mensagens    │
│ FluxoCaixa   │              │ Notificações │
│ Pagamentos   │              │ Grupos       │
└──────────────┘              └──────────────┘
```

---

## 7. KPIs Específicos do CRM Óptico

### 7.1 KPIs de Carteira de Clientes

| KPI | Fórmula | Meta Sugerida |
|-----|---------|:-------------:|
| **Clientes ativos** | Comprou nos últimos 30 dias | > 80% da base |
| **Taxa de churn** | Clientes perdidos / Total | < 5% ao mês |
| **Share of wallet** | Nossa receita / Receita total estimada da óptica | > 50% nas contas-chave |
| **NPS (Net Promoter Score)** | Pesquisa periódica | > 70 |
| **Taxa de refação** | Pedidos refeitos / Total de pedidos | < 3% |
| **Tempo médio de resolução** | Dias entre reclamação e resolução | < 3 dias |
| **Clientes novos/mês** | Ópticas ativadas no mês | Conforme meta |
| **Clientes recuperados/mês** | Inativos que voltaram a comprar | Conforme meta |

### 7.2 KPIs de Vendas por Cliente

| KPI | Fórmula | Importância |
|-----|---------|:-----------:|
| **Ticket médio por par** | Receita / Pares vendidos | Alta |
| **% de progressivas** | Pedidos progressiva / Total | Alta |
| **% de alto índice (1.67+)** | Pedidos HI / Total | Alta |
| **% com AR premium** | Pedidos com AR top / Total | Média |
| **% fotossensível** | Pedidos Transitions / Total | Média |
| **Receita por cliente/mês** | Faturamento mensal | Alta |
| **Crescimento vs. período anterior** | Receita atual / Receita anterior | Alta |

### 7.3 KPIs de Vendas Externas

| KPI | Fórmula | Meta Sugerida |
|-----|---------|:-------------:|
| **Visitas realizadas/mês** | Total por vendedor | 40-60 |
| **Taxa de execução** | Realizadas / Planejadas | > 85% |
| **Custo por visita** | Despesas / Visitas | Monitorar |
| **Receita por visita** | Receita carteira / Visitas | Maximizar |
| **Clientes visitados/mês** | Clientes únicos visitados | > 70% da carteira ativa |
| **Cobertura territorial** | Clientes visitados / Total na região | > 80% |
| **Pipeline ativo** | Valor total de oportunidades abertas | Conforme meta |
| **Win rate** | Oportunidades ganhas / Decididas | > 40% |
| **Ciclo médio de ativação** | Dias do primeiro contato até primeiro pedido | < 45 dias |
| **Custo de aquisição de cliente** | Despesas + comissão até ativação / Novos clientes | Monitorar |

### 7.4 KPIs Estratégicos

| KPI | Descrição |
|-----|-----------|
| **Receita por território** | Comparação entre regiões |
| **Penetração de progressivas por região** | Maturidade do mercado local |
| **Concentração de receita (Gini)** | Dependência de poucos clientes |
| **Lifetime Value por segmento** | Valor acumulado por tipo de óptica |
| **Payback de equipamento em comodato** | Meses para recuperar investimento via receita incremental |

---

## 8. Dashboards do CRM

### 8.1 Dashboard do Vendedor (Consultor Externo)

```
┌──────────────────────────────────────────────────────────┐
│ MINHA CARTEIRA                                           │
├──────────┬──────────┬──────────┬──────────┬─────────────┤
│ Clientes │ Receita  │ Meta     │ Ating.   │ Visitas Mês │
│ Ativos   │ Mês      │ Mês      │ %        │ Realizadas  │
│ 42       │ R$180k   │ R$200k   │ 90%      │ 38/45       │
├──────────┴──────────┴──────────┴──────────┴─────────────┤
│                                                          │
│ ALERTAS                                                  │
│ 🔴 3 clientes sem compra há 30+ dias                    │
│ 🟡 2 clientes com queda > 20% no volume                 │
│ 🟢 1 oportunidade próxima do fechamento                 │
│ 📋 5 visitas pendentes esta semana                      │
│                                                          │
├──────────────────────────────────────────────────────────┤
│ AGENDA DA SEMANA                                         │
│ Seg: Óptica ABC (manutenção) | Óptica XYZ (treinamento) │
│ Ter: Prospect Nova Visão (apresentação)                  │
│ Qua: Rede Olhar (negociação tabela)                     │
│ ...                                                      │
├──────────────────────────────────────────────────────────┤
│ TOP 10 CLIENTES (receita mês)        │ PIPELINE          │
│ 1. Rede Olhar      R$ 32.000         │ Apresentação: 3   │
│ 2. Óptica Premium  R$ 18.500         │ Negociação: 2     │
│ 3. VejaBem         R$ 15.200         │ Pedido Piloto: 1  │
│ ...                                  │ Total: R$ 45k     │
└──────────────────────────────────────┴───────────────────┘
```

### 8.2 Dashboard do Gerente Comercial

```
┌──────────────────────────────────────────────────────────┐
│ VISÃO DA EQUIPE                                          │
├──────────┬──────────┬──────────┬──────────┬─────────────┤
│ Vendedor │ Receita  │ Meta     │ Ating.   │ Visitas     │
│ João     │ R$180k   │ R$200k   │ 90%      │ 38          │
│ Maria    │ R$220k   │ R$200k   │ 110%     │ 45          │
│ Pedro    │ R$150k   │ R$200k   │ 75%      │ 32          │
├──────────┴──────────┴──────────┴──────────┴─────────────┤
│                                                          │
│ ALERTAS GERENCIAIS                                       │
│ 🔴 12 clientes em risco de churn (região Sul)           │
│ 🟡 Pedro abaixo de 80% da meta — 3 meses consecutivos  │
│ 🟢 5 novas ópticas ativadas no mês                      │
│ 💰 R$ 23k em despesas pendentes de aprovação            │
│                                                          │
├──────────────────────────────────────────────────────────┤
│ RECEITA POR REGIÃO (gráfico)  │ MIX DE PRODUTOS         │
│ Grande SP: R$ 420k            │ Progressivas: 35%       │
│ Interior SP: R$ 280k         │ Visão Simples: 45%      │
│ Litoral: R$ 120k             │ Bifocal: 8%             │
│                               │ Outros: 12%            │
├──────────────────────────────────────────────────────────┤
│ FUNIL DE OPORTUNIDADES        │ EQUIPAMENTOS COMODATO   │
│ Identificação: 15             │ Em uso: 28              │
│ Apresentação: 8               │ Volume abaixo do min: 4 │
│ Negociação: 5                 │ Manutenção: 2           │
│ Ativação: 3                   │                         │
│ Total pipeline: R$ 180k      │                         │
└──────────────────────────────┴──────────────────────────┘
```

---

## 9. Integração com Módulos Existentes do OpticalCore

### 9.1 Mapa de Integração Detalhado

| Módulo Existente | Dados que o CRM Consome | Dados que o CRM Alimenta |
|------------------|------------------------|--------------------------|
| **Cadastros (M1)** | Pessoa, Cliente, Funcionário, Produto | PerfilCrmCliente (extensão do Cliente) |
| **Vendas (M2)** | PedidoVenda (volume, mix, ticket), TabelaPreco, RegiaoVenda, MetaVenda, ComissaoVenda | Classificação do cliente (determina tabela), Oportunidade ganha (pode gerar pedido) |
| **Compras (M3)** | — | — |
| **Estoque (M4)** | Saldo por produto (disponibilidade para promessa ao cliente) | — |
| **Financeiro (M5)** | ContaReceber (inadimplência, histórico pagamento, limite crédito), DespesaVisita (aprovação/reembolso) | DespesaVisita (gerada no CRM, aprovada pelo gerente, processada no financeiro) |
| **Fiscal (M6)** | — | — |
| **Produção** | Status de ordens de produção (para informar cliente sobre prazo) | — |
| **Chat/WhatsApp** | Histórico de mensagens com o cliente | Alertas automáticos (churn risk, aniversário, promoção), Follow-up pós-visita |

### 9.2 Fluxos de Integração Críticos

#### Fluxo 1: Classificação Automática de Cliente
```
PedidoVenda (últimos 12 meses)
  → Calcular: volume total, ticket médio, mix de progressivas, frequência
    → Aplicar regras de classificação (A/B/C/D, Tier)
      → Atualizar PerfilCrmCliente.Classificacao
        → Ajustar TabelaPreco associada (se tier mudou)
          → Notificar vendedor responsável
```

#### Fluxo 2: Alerta de Churn
```
Score de Churn (relatório existente)
  → Cliente com risco Alto ou Crítico
    → Criar AtividadeCrm (tipo: Recuperação) para o vendedor
      → Enviar notificação via Chat/WhatsApp para o vendedor
        → Vendedor planeja Visita de recuperação
```

#### Fluxo 3: Oportunidade → Pedido de Venda
```
Oportunidade marcada como Ganha
  → Sistema oferece criar PedidoVenda
    → Preenche automaticamente: Cliente, Vendedor, TabelaPreco
      → Vendedor completa itens do pedido
```

#### Fluxo 4: Visita → Pedido de Venda
```
Vendedor conclui Visita de manutenção
  → Registra que óptica quer fazer pedido
    → Cria PedidoVenda vinculado à Visita
      → Pedido segue workflow normal (Aprovação → Faturamento → Expedição)
```

#### Fluxo 5: Despesa de Visita → Financeiro
```
Vendedor registra DespesaVisita com comprovante
  → Gerente aprova/rejeita
    → Despesa aprovada → gera ContaPagar no módulo Financeiro
      → Financeiro processa reembolso
```

---

## 10. Particularidades do Mercado Óptico Brasileiro

### 10.1 Panorama do Setor

| Aspecto | Detalhe |
|---------|---------|
| **Tamanho do mercado** | ~R$ 25 bilhões/ano (varejo óptico total) |
| **Número de ópticas** | ~40.000 no Brasil |
| **Laboratórios ópticos** | ~300-500 laboratórios (variados portes) |
| **Concentração** | Essilor/Luxottica (EssilorLuxottica) domina ~40% do mercado de lentes |
| **Tendência** | Consolidação via aquisições, crescimento de progressivas, digitalização |

### 10.2 Principais Players (Concorrentes)

| Lab/Grupo | Porte | Cobertura | Diferenciais |
|-----------|:-----:|:---------:|-------------|
| **Essilor/LOLA** | Gigante | Nacional | Varilux, Crizal, Transitions, maior portfólio |
| **Hoya** | Grande | Nacional | Tecnologia japonesa, foco em premium |
| **Zeiss** | Grande | Nacional | Precisão alemã, foco em inovação |
| **Tokai** | Grande | Nacional | Custo-benefício, forte no Brasil |
| **Labs regionais** | Médio-Pequeno | Regional | Agilidade, atendimento, preço competitivo |

### 10.3 Sazonalidade

| Período | Impacto | Razão |
|---------|:-------:|-------|
| **Jan-Fev** | Baixo | Férias, menor fluxo nas ópticas |
| **Mar-Abr** | Alto | Volta às aulas, exames escolares |
| **Mai (Dia das Mães)** | Alto | Presente popular |
| **Jun-Jul** | Médio | Período regular |
| **Ago (Dia dos Pais)** | Médio-Alto | Presente popular |
| **Set-Nov** | Médio-Alto | Período regular, preparação para Black Friday |
| **Nov (Black Friday)** | Alto | Promoções agressivas |
| **Dez (Natal)** | Alto | Presente, 13º salário |

### 10.4 Regulamentação e Certificações

| Item | Descrição | Impacto no CRM |
|------|-----------|:---------------:|
| **ANVISA** | Lentes oftálmicas são produtos de saúde regulados | Registro obrigatório |
| **INMETRO** | Certificação de conformidade para óculos/lentes | Rastreabilidade |
| **Conselho Regional de Óptica** | Regula profissionais ópticos | Cadastro de optometristas |
| **Receita médica** | Prescrição válida por até 1 ano (oftalmo) / 6 meses (optometrista) | Controle de validade |
| **ISO 8980** | Norma para lentes oftálmicas | Parâmetros de qualidade |

---

## 11. Roadmap Sugerido para o Módulo CRM

### Fase 1 — CRM Base (MVP)

| Item | Prioridade | Descrição |
|------|:----------:|-----------|
| PerfilCrmCliente | Alta | Extensão do Cliente com dados específicos da óptica |
| ContatoCliente com papéis | Alta | Múltiplos contatos por óptica com classificação |
| Oportunidade + Pipeline | Alta | Funil de vendas para novas ópticas |
| Visita (CRUD + check-in) | Alta | Registro de visitas com resultado e próximos passos |
| AtividadeCrm | Alta | Tarefas, follow-ups, lembretes |
| Dashboard do vendedor | Alta | Resumo da carteira, alertas, agenda |
| Domínios CRM | Alta | Todas as tabelas de lookup |

### Fase 2 — Gestão Avançada

| Item | Prioridade | Descrição |
|------|:----------:|-----------|
| DespesaVisita + Aprovação | Média | Controle de gastos com comprovante por foto |
| EquipamentoComodato | Média | Gestão de equipamentos emprestados |
| TreinamentoCliente | Média | Registro de capacitações |
| InteligenciaCompetitiva | Média | Informações coletadas sobre concorrentes |
| Dashboard do gerente | Média | Visão consolidada da equipe |
| Classificação automática | Média | Regras baseadas em volume/mix/frequência |
| Alertas de churn | Média | Integração com Score de Churn |

### Fase 3 — Inteligência e Geolocalização

| Item | Prioridade | Descrição |
|------|:----------:|-----------|
| Mapa de clientes (Google Maps) | Média | Visualização geográfica da carteira |
| Territórios com polígonos | Média | Áreas de atendimento por vendedor |
| Análise de mix por cliente | Média | Monitoramento de % progressivas, AR, etc. |
| Forecast do CRM | Baixa | Previsão de pipeline + tendência de carteira |
| Roteirização de visitas | Baixa | Otimização de rota para vendedor |
| OCR de recibos | Baixa | Extração automática de dados de comprovantes |
| App mobile dedicado | Baixa | Versão mobile-first para vendedores em campo |

---

## 12. Decisões Técnicas Importantes

### 12.1 PerfilCrmCliente: Entidade separada ou extensão do Cliente?

**Recomendação: Entidade separada (1:1 com Cliente).**

Razões:
- O módulo de Cadastros (M1) é genérico — serve para qualquer tipo de empresa
- Os campos do CRM são específicos do setor óptico e do processo comercial
- Separar permite ativar/desativar o módulo CRM sem impactar o cadastro base
- Facilita migrations independentes (uma migration para CRM, sem tocar em Cliente)
- Mantém o princípio de responsabilidade única (SRP)

### 12.2 Oportunidade vs. Pedido de Venda

| Oportunidade (CRM) | Pedido de Venda (Vendas) |
|---------------------|-------------------------|
| Representa intenção/possibilidade | Representa compromisso concreto |
| Pode nunca se concretizar | Sempre se concretiza em faturamento |
| Tem probabilidade e etapas | Tem status e workflow rígido |
| Controlada pelo vendedor | Controlada pelo backoffice/produção |
| Mede eficácia comercial | Mede operação |

**Regra:** Oportunidade ganha pode gerar PedidoVenda, mas são entidades diferentes.

### 12.3 Visita como Entidade Central

Conforme já recomendado no `estudo_crm.md`, a **Visita** deve ser entidade de primeira classe, não apenas uma atividade. No contexto óptico, a visita é onde acontece:
- Relacionamento com o proprietário
- Treinamento da equipe
- Coleta de inteligência competitiva
- Identificação de oportunidades de upgrade
- Resolução de problemas
- Despesas operacionais

### 12.4 Reutilização de Entidades Existentes

| Necessidade do CRM | Entidade Existente | Como Reutilizar |
|--------------------|-------------------|-----------------|
| Cliente óptica | `Cliente` + `Pessoa` | Adicionar `PerfilCrmCliente` 1:1 |
| Vendedor externo | `Funcionario` + `Pessoa` | Já existe, vincular via FK |
| Território | `RegiaoVenda` | Já existe, pode estender para micro-regiões |
| Meta | `MetaVenda` | Já existe, pode adicionar tipos CRM-específicos |
| Tabela de preço | `TabelaPreco` | Já existe, classificação CRM determina qual tabela |
| Devoluções | `DevolucaoVenda` | Já existe, CRM consome para taxa de refação |
| Comunicação | `Chat/WhatsApp` | Já existe, CRM envia alertas e consome histórico |
| Pagamentos | `ContaReceber` | Já existe, CRM consome para inadimplência |

---

## 13. Referências do Setor

| Referência | Descrição |
|------------|-----------|
| ABIOPTICA | Associação Brasileira da Indústria Óptica — dados de mercado |
| ABIÓPTICA Anuário | Relatório anual com números do setor |
| Conselho Brasileiro de Óptica e Optometria (CBOO) | Regulação profissional |
| MIDO (Milão) | Maior feira óptica do mundo — tendências |
| Vision Expo (EUA) | Feira óptica norte-americana |
| Lensware | Software de gestão de laboratório óptico (referência de fluxo produtivo) |
| Optinet | Sistema para ópticas (referência de integração lab-óptica) |
