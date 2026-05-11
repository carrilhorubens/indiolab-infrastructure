# Pesquisa Fiscal e Tributaria - Modulo Financeiro ERP Optico

> Pesquisa completa sobre requisitos fiscais, tributarios, bancarios e de compliance para o modulo financeiro de um ERP de varejo optico brasileiro.
> Data da pesquisa: 2026-02-28

---

## Indice

1. [Obrigacoes SPED e Escrituracoes Digitais](#1-obrigacoes-sped-e-escrituracoes-digitais)
2. [Impostos e Retencoes na Fonte](#2-impostos-e-retencoes-na-fonte)
3. [Regimes Tributarios](#3-regimes-tributarios)
4. [Boleto Bancario e CNAB](#4-boleto-bancario-e-cnab)
5. [PIX para Empresas](#5-pix-para-empresas)
6. [Integracao com NF-e/NFS-e](#6-integracao-com-nf-e-nfs-e)
7. [Obrigacoes Acessorias Mensais/Anuais](#7-obrigacoes-acessorias-mensais-anuais)
8. [Compliance e Auditoria](#8-compliance-e-auditoria)
9. [Reforma Tributaria 2026-2033 (IBS/CBS)](#9-reforma-tributaria-2026-2033-ibs-cbs)
10. [Conciliacao Bancaria](#10-conciliacao-bancaria)
11. [Requisitos Especificos para Varejo Optico](#11-requisitos-especificos-para-varejo-optico)
12. [Resumo de Entidades e Tabelas](#12-resumo-de-entidades-e-tabelas)

---

## 1. Obrigacoes SPED e Escrituracoes Digitais

O Sistema Publico de Escrituracao Digital (SPED) e o ecossistema unificado da Receita Federal para escrituracoes fiscais e contabeis. O modulo financeiro do ERP precisa gerar dados compativeis com todos os sub-projetos do SPED.

### 1.1 ECD - Escrituracao Contabil Digital (SPED Contabil)

**O que e:** Substituicao dos livros contabeis em papel (Diario, Razao, Balancetes, Balancos) por arquivos digitais padronizados.

**Quem entrega:**
- Empresas de Lucro Real (obrigatorio)
- Empresas de Lucro Presumido que distribuam lucros acima da presuncao (obrigatorio)
- Empresas de Lucro Presumido que escriturem Livro Caixa (facultativo)
- Empresas do Simples Nacional: DISPENSADAS

**Prazo de entrega:** Ultimo dia util de junho do ano seguinte ao ano-calendario (ex: ano-calendario 2025 -> ate 30/06/2026).

**Formato:** Arquivo texto com leiaute definido pela RFB. Versao do PVA (Programa Validador e Assinador) 10.3.5 para ano-calendario 2025.

**Registros relevantes para o modulo financeiro:**
- Plano de Contas (registro I050)
- Lancamentos contabeis (registros I200, I250)
- Saldos periodicos (registro I150, I155)
- Demonstracoes contabeis (Balanco, DRE)

**O que o ERP precisa fornecer:**
- Plano de contas estruturado e mapeado para contas referenciais da RFB
- Lancamentos contabeis com historico padrao, data, valor, partidas dobradas
- Saldos mensais por conta contabil e centro de custo
- Exportacao em formato texto conforme leiaute ECD
- Cada conta contabil/centro de custo so pode ser mapeada para UMA conta referencial

**Recomendacao para o ERP:** O modulo financeiro deve manter a contabilidade integrada (lancamentos automaticos de contas a pagar/receber, movimentacoes bancarias, impostos) e exportar dados no formato SPED. A geracao do arquivo ECD pode ser delegada a software contabil externo, mas os dados devem ser exportaveis.

### 1.2 EFD ICMS/IPI (SPED Fiscal)

**O que e:** Escrituracao fiscal digital que substitui os livros de entrada, saida, apuracao ICMS e IPI.

**Quem entrega:**
- Contribuintes de ICMS e/ou IPI (obrigatorio conforme regulamentacao estadual)
- Empresas de varejo optico: SIM (vendem mercadorias com ICMS)

**Prazo:** Ate o 15o dia do segundo mes subsequente ao periodo de apuracao.

**Versao do PVA:** 6.0.3 obrigatorio a partir de 01/01/2026 (Leiaute 020 com Nota Tecnica 2025.001).

**Relacao com o modulo financeiro:**
- O SPED Fiscal cruza dados com a EFD-Contribuicoes e a ECD
- Os lancamentos fiscais devem ser consistentes com os lancamentos financeiros
- O modulo financeiro deve fornecer: valores de ICMS a recolher/creditar, IPI, substituicao tributaria
- O estorno/cancelamento de NF-e no financeiro impacta diretamente os registros do SPED Fiscal

**Novidade 2026:** A EFD ICMS/IPI NAO apurara CBS, IBS e IS (novos tributos da reforma). Em 2026, esses valores NAO integram o total do documento fiscal.

**Blocos relevantes para financeiro:**
- Bloco C: Documentos fiscais de mercadorias (NF-e)
- Bloco E: Apuracao do ICMS e IPI
- Bloco H: Inventario fisico (integracao com estoque)
- Bloco K: Controle de producao e estoque

### 1.3 EFD-Contribuicoes (PIS/COFINS)

**O que e:** Escrituracao mensal das contribuicoes PIS/PASEP e COFINS, alem da CPRB.

**Quem entrega:**
- Empresas de Lucro Real e Lucro Presumido (obrigatorio)
- Simples Nacional: DISPENSADO
- Pessoas juridicas imunes/isentas com receita mensal <= R$ 10.000: DISPENSADAS

**Prazo:** Ate o 10o dia util do segundo mes subsequente ao mes de referencia.

**Impacto no modulo financeiro:**
- **Lucro Real (nao cumulativo):** PIS 1,65% + COFINS 7,6% = 9,25%, COM creditos sobre insumos
- **Lucro Presumido (cumulativo):** PIS 0,65% + COFINS 3% = 3,65%, SEM creditos
- O financeiro deve rastrear creditos e debitos de PIS/COFINS para regimes nao cumulativos
- Receitas financeiras, venda de ativos e outras receitas tem tratamento diferenciado

**Descontinuidade prevista:** PIS e COFINS serao extintos a partir de 2027 (reforma tributaria), porem a EFD-Contribuicoes continuara vigente para gerir saldos credores remanescentes e atender prazos de fiscalizacao/retificacao.

**Registros-chave:**
- Bloco A: Documentos de servicos (NFS-e)
- Bloco C: Documentos de mercadorias (NF-e)
- Bloco D: Documentos de transporte
- Bloco F: Demais receitas e creditos
- Bloco M: Apuracao da contribuicao e credito

### 1.4 ECF - Escrituracao Contabil Fiscal

**O que e:** Substituiu a antiga DIPJ. Demonstra a apuracao do IRPJ e da CSLL.

**Quem entrega:**
- Todas as empresas de Lucro Real, Presumido e Arbitrado
- Simples Nacional: DISPENSADO
- Orgaos publicos, autarquias, fundacoes: DISPENSADOS
- Empresas inativas: DISPENSADAS

**Prazo:** Ultimo dia util de julho do ano seguinte (ex: ano-calendario 2025 -> ate 31/07/2026).

**IMPORTANTE:** A ECF DEPENDE da ECD. A ordem de entrega e obrigatoria: primeiro ECD, depois ECF.

**Versao 2026:** Leiaute 12 para transmissao das informacoes do ano-calendario 2025.

**Multas por nao cumprimento:**
- 0,25% sobre a receita bruta, limitada a 10% do lucro liquido antes do IRPJ e CSLL
- Declaracoes com erros/omissoes tambem geram penalidades

**Relacao com o modulo financeiro:**
- Os dados de receita bruta, despesas dedutíveis, adicoes/exclusoes ao lucro real
- LALUR (Livro de Apuracao do Lucro Real) - Parte A (ajustes) e Parte B (controle)
- Compensacoes de prejuizo fiscal
- Calculos de IRPJ e CSLL

### 1.5 EFD-Reinf (Retencoes e Informacoes Fiscais)

**O que e:** Escrituracao mensal de retencoes na fonte e outras informacoes fiscais. SUBSTITUIU A DIRF a partir de fatos geradores de 01/01/2025.

**Quem entrega:** Todas as pessoas juridicas que realizam retencoes ou pagamentos sujeitos a informacao.

**Prazo:** Mensal, ate o 15o dia util do mes subsequente ao de referencia.

**Eventos principais:**
- R-1000: Informacoes do contribuinte
- R-2010: Retencao sobre servicos tomados (INSS)
- R-2020: Retencao sobre servicos prestados (INSS)
- R-4010: Pagamentos/creditos a beneficiarios PF (IRRF)
- R-4020: Pagamentos/creditos a beneficiarios PJ (IRRF, PIS, COFINS, CSLL)
- R-4040: Pagamentos/creditos a beneficiarios nao identificados
- R-4080: Retencao no recebimento (auto-retencao)
- R-4099: Fechamento/reabertura dos eventos da serie R-4000
- R-9000: Exclusao de eventos

**O que o ERP precisa fazer:**
- Calcular automaticamente retencoes em cada titulo de contas a pagar
- Classificar pagamentos por natureza (servico PF, servico PJ, aluguel, etc.)
- Gerar eventos da EFD-Reinf com base nos pagamentos realizados
- Manter historico de retencoes com vinculo ao titulo financeiro

### 1.6 DIRF (em extincao)

**Status:** EXTINTA para fatos geradores a partir de 01/01/2025. A ultima DIRF (ano-calendario 2024) foi entregue em 2025. A partir de 2026, NAO ha mais entrega de DIRF.

**Substituida por:** eSocial (rendimentos de empregados) + EFD-Reinf (retencoes de terceiros PF/PJ).

**Impacto no ERP:** Nao e necessario implementar geracao de DIRF. O ERP deve focar na geracao correta dos eventos R-4010/R-4020 da EFD-Reinf.

---

## 2. Impostos e Retencoes na Fonte

### 2.1 IRRF - Imposto de Renda Retido na Fonte

**Quando se aplica:** Pagamentos a pessoas fisicas e juridicas por servicos prestados.

**Aliquotas para servicos de PJ:**
| Tipo de Servico | Aliquota IRRF |
|---|---|
| Servicos profissionais (advocacia, contabilidade, consultoria, etc.) | 1,5% |
| Limpeza, conservacao, seguranca, vigilancia | 1,0% |
| Servicos de propaganda e publicidade | 1,5% |
| Comissoes e corretagens | 1,5% |
| Servicos pessoais (PF - tabela progressiva) | 0% a 27,5% |

**Fato gerador:** Pagamento ou credito, o que ocorrer primeiro.

**Dispensa:** Retencao dispensada quando o valor do IRRF for inferior a R$ 10,00 por operacao.

**Prazo de recolhimento (DARF):** Ate o ultimo dia util do 2o decendio do mes subsequente ao fato gerador. Codigo DARF: 1708 (PJ) ou conforme natureza.

### 2.2 PIS/COFINS/CSLL Retidos na Fonte (Lei 10.833/2003)

**Quando se aplica:** Pagamentos efetuados por PJ a outra PJ pela prestacao de servicos profissionais, limpeza, conservacao, manutencao, seguranca, vigilancia, transporte de valores, locacao de mao-de-obra.

**Aliquotas:**
| Contribuicao | Aliquota |
|---|---|
| PIS/PASEP | 0,65% |
| COFINS | 3,00% |
| CSLL | 1,00% |
| **TOTAL** | **4,65%** |

**Dispensa de retencao:**
- Valor da retencao (4,65% sobre o bruto) igual ou inferior a R$ 10,00 -> DISPENSADA
- Pagamentos a empresas do Simples Nacional -> NAO ha retencao de PIS/COFINS/CSLL
- Pagamentos a cooperativas (exceto trabalho) -> regras especificas

**Fato gerador:** Pagamento (e nao o credito, diferente do IRRF).

**Prazo de recolhimento (DARF):** Ate o ultimo dia util da quinzena subsequente ao pagamento. Codigo DARF: 5952 (servicos profissionais) ou conforme natureza.

**O que o ERP deve fazer:**
1. Identificar se o fornecedor e PJ ou PF
2. Verificar se o fornecedor e optante do Simples Nacional (se sim, NAO reter PIS/COFINS/CSLL)
3. Verificar a natureza do servico (se e passivel de retencao)
4. Calcular automaticamente a retencao sobre o valor bruto da nota
5. Gerar o valor liquido a pagar (bruto - retencoes)
6. Gerar DARF automatico para cada tipo de retencao
7. Registrar a retencao para fins de EFD-Reinf

### 2.3 ISS Retido na Fonte

**Quando se aplica:** Servicos prestados por empresa sediada em municipio diferente do local da prestacao, conforme Lei Complementar 116/2003.

**Aliquota:** 2% a 5%, conforme legislacao do municipio do local da prestacao.

**Regra geral:**
- ISS retido pelo TOMADOR quando o servico e prestado em municipio diferente do estabelecimento do prestador
- Cada municipio tem legislacao propria sobre quais servicos sofrem retencao
- A retencao ocorre na emissao da NFS-e

**Para oticas (varejo optico):**
- Oticas que contratam servicos de laboratorio optico em outro municipio podem ser obrigadas a reter ISS
- Servicos de montagem de lentes, surfacagem, coloracao de lentes: verificar legislacao municipal

**Recolhimento:** Guia de ISS do municipio do local da prestacao, conforme prazo definido pela legislacao municipal (geralmente ate o dia 10 ou 15 do mes seguinte).

### 2.4 INSS Retido na Fonte (Servicos de PF)

**Quando se aplica:** Pagamentos a pessoa fisica pela prestacao de servicos (autonomos, profissionais liberais).

**Aliquota:** 11% sobre o valor bruto do servico, limitado ao teto do INSS (R$ 8.157,41 em 2025 — verificar atualizacao anual).

**Fato gerador:** Pagamento ao segurado.

**Recolhimento:** GPS (Guia da Previdencia Social) ate o dia 20 do mes subsequente. A partir de 2025, a informacao e declarada no eSocial (evento S-1210) e recolhida via DCTFWeb/DARF.

### 2.5 INSS Retido na Fonte (Servicos de PJ - cessao de mao-de-obra)

**Quando se aplica:** Servicos de cessao de mao-de-obra e empreitada prestados por PJ (limpeza, vigilancia, etc.)

**Aliquota:** 11% sobre o valor bruto da nota fiscal (3,5% se optante do Simples Nacional em atividades do Anexo IV).

**Recolhimento:** GPS/DARF ate o dia 20 do mes subsequente.

### 2.6 Guias de Recolhimento

| Guia | Tributo | Formato |
|---|---|---|
| **DARF** | IRRF, PIS, COFINS, CSLL, IRPJ, CSLL, IPI, IOF, etc. | Codigo de barras padrao FEBRABAN. Gerado via Sicalc ou sistema ERP |
| **GPS** | INSS (contribuicoes previdenciarias) | Codigo de barras. Em transicao para DARF via DCTFWeb |
| **DAS** | Simples Nacional (todos os tributos unificados) | Gerado exclusivamente via PGDAS-D (portal do Simples) |
| **Guia ISS** | ISS municipal | Formato varia por municipio |
| **GNRE** | ICMS interestadual / ST | Guia Nacional de Recolhimento de Tributos Estaduais |

**O que o ERP deve implementar:**
- Geracao automatica de DARF com codigo de barras para retencoes federais
- Calculo de acrescimos legais (juros SELIC + multa) para pagamento em atraso
- Controle de vencimento das guias por tipo de tributo
- Integracao com agenda tributaria (calendario de vencimentos)

### 2.7 Tabela Resumo de Retencoes por Tipo de Fornecedor

| Tipo | IRRF | PIS/COFINS/CSLL | ISS | INSS |
|---|---|---|---|---|
| PJ Lucro Real/Presumido (servicos) | 1% a 1,5% | 4,65% | 2% a 5% (se aplicavel) | 11% (cessao mao-de-obra) |
| PJ Simples Nacional (servicos) | 1% a 1,5% | ISENTO | 2% a 5% (se aplicavel) | 11% (Anexo IV) ou ISENTO |
| PJ MEI | ISENTO | ISENTO | Conforme municipio | ISENTO (na maioria) |
| PF Autonomo | Tabela progressiva | N/A | 2% a 5% | 11% (limitado ao teto) |
| PJ (mercadorias, sem servico) | N/A | N/A | N/A | N/A |

---

## 3. Regimes Tributarios

### 3.1 Simples Nacional

**Limites:** Receita bruta anual ate R$ 4.800.000,00.

**CNAE aplicavel a oticas:** 4774-1/00 (Comercio varejista de artigos de optica) -> Anexo I.

**Tabela do Anexo I (Comercio) - Aliquotas 2025-2026:**

| Faixa | Receita Bruta 12 meses (RBT12) | Aliquota Nominal | Parcela a Deduzir |
|---|---|---|---|
| 1a | Ate R$ 180.000 | 4,00% | R$ 0 |
| 2a | R$ 180.000,01 a R$ 360.000 | 7,30% | R$ 5.940 |
| 3a | R$ 360.000,01 a R$ 720.000 | 9,50% | R$ 13.860 |
| 4a | R$ 720.000,01 a R$ 1.800.000 | 10,70% | R$ 22.500 |
| 5a | R$ 1.800.000,01 a R$ 3.600.000 | 14,30% | R$ 87.300 |
| 6a | R$ 3.600.000,01 a R$ 4.800.000 | 19,00% | R$ 378.000 |

**Formula da aliquota efetiva:**
```
Aliquota Efetiva = [(RBT12 x Aliquota Nominal) - Parcela a Deduzir] / RBT12
Valor DAS = Receita Bruta do Mes x Aliquota Efetiva
```

**Impacto no modulo financeiro:**
- Calculo automatico do DAS mensal (via integracao PGDAS-D ou calculo local)
- NAO faz retencoes de PIS/COFINS/CSLL quando PAGA a fornecedores
- NAO sofre retencao de PIS/COFINS/CSLL quando RECEBE (com excecoes)
- ICMS, ISS, PIS, COFINS, IRPJ, CSLL, CPP, IPI: todos incluidos no DAS
- ICMS-ST e ICMS-DIFAL: cobrados SEPARADAMENTE (fora do DAS)
- O ERP nao precisa gerar ECD, ECF, EFD-Contribuicoes, DCTF para Simples Nacional
- SPED Fiscal: depende da UF (alguns estados obrigam, outros dispensam)

**Sublimite ICMS/ISS:** Receitas acima de R$ 3.600.000 -> ICMS e ISS apurados separadamente (fora do DAS).

### 3.2 Lucro Presumido

**Limite:** Receita bruta anual ate R$ 78.000.000 (a partir de 2026, LC 224/2025 pode alterar).

**Percentuais de presuncao (base de calculo):**

| Atividade | Presuncao IRPJ | Presuncao CSLL |
|---|---|---|
| Comercio (venda de mercadorias) | 8% | 12% |
| Prestacao de servicos em geral | 32% | 32% |
| Servicos hospitalares e de saude | 8% | 12% |
| Transporte de cargas | 8% | 12% |
| Transporte de passageiros | 16% | 12% |
| Revenda de combustiveis | 1,6% | 12% |

**Calculo IRPJ trimestral (para otica = comercio, presuncao 8%):**
```
Base de calculo = Receita Bruta Trimestral x 8% + Ganhos de Capital + Receitas Financeiras
IRPJ = Base x 15%
Adicional = (Base - R$ 60.000) x 10%  [se Base > R$ 60.000 no trimestre]
```

**Calculo CSLL trimestral (para otica = comercio, presuncao 12%):**
```
Base de calculo = Receita Bruta Trimestral x 12% + Ganhos de Capital + Receitas Financeiras
CSLL = Base x 9%
```

**PIS/COFINS (regime cumulativo):**
```
PIS = Receita Bruta Mensal x 0,65%  (SEM creditos)
COFINS = Receita Bruta Mensal x 3%  (SEM creditos)
```

**Alteracao 2026 (LC 224/2025):** Adicional de 10% sobre base que exceder R$ 1.250.000 por trimestre (R$ 5.000.000 anuais).

**Prazos de recolhimento:**
- IRPJ e CSLL: ultimo dia util do mes seguinte ao trimestre (ex: 1o trim -> 30/04)
- PIS: 25o dia do mes seguinte
- COFINS: 25o dia do mes seguinte

**O que o ERP precisa fazer:**
- Apuracao trimestral automatica de IRPJ e CSLL
- Apuracao mensal de PIS e COFINS (cumulativo)
- Geracao de DARFs com codigos corretos
- Calculo do adicional de IRPJ quando aplicavel
- Entrega de: ECD, ECF, EFD-Contribuicoes, DCTFWeb, EFD-Reinf

### 3.3 Lucro Real

**Obrigatorio para:** Receita bruta anual > R$ 78 milhoes, bancos, empresas com beneficios fiscais, ou por opcao.

**Modalidades de apuracao:**
- **Lucro Real Trimestral:** Apuracao definitiva a cada trimestre
- **Lucro Real Anual:** Apuracao anual com estimativas mensais (recolhimento antecipado)

**IRPJ e CSLL - Lucro Real:**
```
Lucro Real = Lucro Contabil + Adicoes - Exclusoes - Compensacoes
IRPJ = Lucro Real x 15% + Adicional 10% (excedente R$ 20.000/mes ou R$ 60.000/trim)
CSLL = Lucro Real x 9%
```

**PIS/COFINS (regime nao cumulativo):**
```
PIS = (Receitas - Creditos) x 1,65%
COFINS = (Receitas - Creditos) x 7,6%
Total = 9,25% (sem creditos)
```

**Creditos permitidos (insumos):**
- Mercadorias adquiridas para revenda
- Energia eletrica
- Alugueis pagos a PJ
- Depreciacao de bens do ativo
- Servicos de transporte de mercadorias
- Armazenagem de mercadorias

**LALUR (Livro de Apuracao do Lucro Real):**
- Parte A: Registro dos ajustes (adicoes e exclusoes) ao lucro liquido
- Parte B: Controle de valores que compoem a base em periodos futuros (prejuizos fiscais, depreciacoes)

**O que o ERP precisa fazer:**
- Contabilidade completa integrada
- Controle de creditos de PIS/COFINS por natureza de despesa
- LALUR automatizado (Parte A e Parte B)
- Compensacao de prejuizos fiscais (limitada a 30% do lucro)
- Todas as obrigacoes: ECD, ECF, EFD-Contribuicoes, SPED Fiscal, DCTFWeb, EFD-Reinf

### 3.4 MEI - Microempreendedor Individual

**Limite:** Receita bruta anual ate R$ 81.000 (proposta de aumento para R$ 130.000 em tramitacao).

**CNAE:** 4774-1/00 PERMITE MEI, porem com limitacoes (1 empregado, sem filial).

**Tributacao:** Valor fixo mensal (DAS-MEI):
- R$ 75,90 (INSS) + R$ 1,00 (ICMS comercio) + R$ 5,00 (ISS servico)
- Total aproximado: R$ 76,90 a R$ 81,90/mes (valores 2025, reajustaveis)

**Impacto no ERP:**
- Modulo financeiro simplificado
- Sem obrigacao de escrituracao contabil (facultativo)
- Sem retencoes na fonte
- Declaracao anual DASN-SIMEI (faturamento e empregados)
- NFC-e: obrigatorio dependendo da UF

---

## 4. Boleto Bancario e CNAB

### 4.1 Estrutura do Boleto Bancario

**Componentes obrigatorios:**
- Codigo de barras (44 posicoes numericas)
- Linha digitavel (47 posicoes numericas, formatada em 5 campos)
- Dados do beneficiario (cedente): nome, CNPJ, agencia/conta
- Dados do pagador (sacado): nome, CPF/CNPJ, endereco
- Valor do documento
- Data de vencimento
- Nosso numero (identificacao unica no banco)
- Numero do documento (identificacao da empresa)
- Instrucoes de cobranca (juros, multa, protesto)

**Codigo de barras (44 posicoes):**
```
Posicoes 1-3:   Codigo do banco (ex: 001=BB, 033=Santander, 341=Itau, 237=Bradesco)
Posicao 4:      Codigo da moeda (9 = Real)
Posicao 5:      Digito verificador geral
Posicoes 6-9:   Fator de vencimento (dias desde data-base)
Posicoes 10-19: Valor (10 posicoes, 2 decimais, sem separador)
Posicoes 20-44: Campo livre (definido por cada banco — agencia, conta, nosso numero, carteira)
```

**IMPORTANTE - Fator de vencimento:**
A partir de 22/02/2025, o fator de vencimento RETORNOU para "1000", sendo esta a nova data-base. Cada dia subsequente adiciona 1.
```
Fator de Vencimento = Data de Vencimento - 22/02/2025 + 1000
```

**Linha digitavel (47 digitos, 5 campos):**
```
Campo 1 (10 dig): Banco + Moeda + 5 primeiros do campo livre + DV
Campo 2 (11 dig): Posicoes 6-15 do campo livre + DV
Campo 3 (11 dig): Posicoes 16-25 do campo livre + DV
Campo 4 (1 dig):  Digito verificador geral do codigo de barras
Campo 5 (14 dig): Fator de vencimento + Valor
```

### 4.2 CNAB 240 - Formato de Remessa (Geracao de Boletos)

**Estrutura do arquivo CNAB 240:**

| Registro | Descricao | Posicoes |
|---|---|---|
| Header de Arquivo | Dados do banco e empresa | 240 |
| Header de Lote | Tipo de servico (cobranca) | 240 |
| **Segmento P** | Dados do boleto (nosso numero, vencimento, valor, juros, multa) | 240 |
| **Segmento Q** | Dados do pagador (nome, CPF/CNPJ, endereco) | 240 |
| **Segmento R** | Dados adicionais (desconto, protesto, multa mora) | 240 |
| Trailer de Lote | Totais do lote | 240 |
| Trailer de Arquivo | Totais do arquivo | 240 |

**Segmentos principais:**
- **Segmento P:** Nosso numero, codigo de barras, data vencimento, valor nominal, especie titulo, data emissao, juros de mora (tipo + data + valor/%), tipo de multa + data + valor/%
- **Segmento Q:** Nome do pagador, CPF/CNPJ, endereco completo (logradouro, bairro, CEP, cidade, UF), sacador/avalista
- **Segmento R:** Desconto 2 e 3, protesto (tipo + dias), devolucao (tipo + dias), dados do PIX QR Code (em boletos hibridos)

### 4.3 CNAB 240/400 - Formato de Retorno

**Ocorrencias comuns no retorno (CNAB 240):**

| Codigo | Descricao | Acao no Financeiro |
|---|---|---|
| 02 | Entrada confirmada | Boleto registrado com sucesso |
| 03 | Entrada rejeitada | Notificar erro, reprocessar |
| 06 | Liquidacao | Baixar titulo, registrar pagamento |
| 09 | Baixa | Cancelamento do boleto |
| 10 | Baixa por ter sido pago diretamente | Baixar titulo |
| 14 | Alteracao de vencimento | Atualizar titulo |
| 19 | Confirmacao de protesto | Titulo protestado |
| 20 | Confirmacao de sustacao | Protesto sustado |
| 23 | Encaminhado a cartorio | Em processo de protesto |

**CNAB 400:** Cada registro tem 400 posicoes. Formato mais antigo, ainda suportado por bancos mas em desuso. Descontinuacao progressiva. Estrutura:
- Tipo 0: Header
- Tipo 1: Transacao (dados do boleto + ocorrencia)
- Tipo 9: Trailer

### 4.4 Registro de Boletos: API vs CNAB

| Aspecto | CNAB (arquivo) | API (webservice) |
|---|---|---|
| **Registro** | Arquivo de remessa -> banco processa -> retorno | Request HTTP -> resposta imediata |
| **Tempo** | Horas/minutos (lote) | Segundos (tempo real) |
| **Confirmacao** | Via arquivo de retorno | Na resposta da API |
| **Seguranca** | Arquivo texto, sem criptografia nativa | HTTPS, OAuth2, certificado digital |
| **Flexibilidade** | Layout fixo por banco | JSON/XML padronizado |
| **Tendencia** | Legado, em desuso | Padrao moderno, Open Banking |

**Recomendacao para o ERP:** Implementar AMBOS:
1. **API como padrao** para bancos que suportam (Itau, Bradesco, Santander, BB, Inter, Sicoob, Sicredi)
2. **CNAB 240 como fallback** para bancos sem API ou para clientes com integracao legada
3. Manter parser de retorno CNAB 240/400 para processar arquivos antigos

### 4.5 Boleto Hibrido (PIX + Boleto)

**O que e:** Boleto bancario padrao acrescido de QR Code Dinamico PIX. Regulamentado pelo Banco Central, padronizado pela FEBRABAN, vigente desde 03/02/2025.

**Estrutura:**
- Codigo de barras convencional + linha digitavel
- QR Code Dinamico PIX (com txid unico)
- Codigo "Copia e Cola" PIX
- O pagador escolhe: pagar pelo codigo de barras OU pelo PIX

**Vantagens:**
- Liquidacao imediata quando pago por PIX (vs D+1 a D+3 do boleto convencional)
- Conciliacao automatica (txid vinculado ao titulo)
- Reducao de inadimplencia (mais opcoes de pagamento)

**No CNAB 240:** O Segmento R foi atualizado para conter os dados do QR Code PIX.

**O que o ERP deve fazer:**
1. Gerar boleto convencional com codigo de barras
2. Gerar QR Code PIX dinamico vinculado ao mesmo titulo
3. Incluir ambos no layout de impressao do boleto
4. Processar pagamento via qualquer canal (boleto OU PIX)
5. Baixar titulo independente do canal de pagamento

### 4.6 Protesto Automatico

**O que e:** Envio automatico de titulos inadimplentes para protesto em cartorio, via integracao eletronica com o IEPTB (Instituto de Estudos de Protesto de Titulos do Brasil) ou CRA (Central de Remessa de Arquivos).

**Fluxo:**
1. Titulo vence e nao e pago (apos periodo de carencia configuravel)
2. ERP gera remessa eletronica para o cartorio (via IEPTB/CRA do estado)
3. Cartorio emite carta de intimacao ao devedor (fisica)
4. Se nao pago em 3 dias uteis, titulo e protestado
5. Retorno eletronico confirma protesto
6. Para cancelar protesto apos pagamento: emissao de anuencia eletronica

**Parametros configuraveis no ERP:**
- Dias de carencia apos vencimento para envio a protesto
- Valor minimo para protesto
- Tipos de titulo que podem ser protestados
- Cartorio de protesto (por comarca do devedor)

**O que o ERP deve implementar:**
- Regra automatica de envio a protesto (dias + valor minimo)
- Geracao de arquivo de remessa no formato IEPTB/CRA
- Processamento de arquivo de retorno (confirmacao de protesto, pagamento no cartorio)
- Emissao de anuencia eletronica apos pagamento
- Dashboard de titulos em protesto / protestados

---

## 5. PIX para Empresas

### 5.1 Tipos de QR Code PIX

| Tipo | Uso | Valor | Validade | Conciliacao |
|---|---|---|---|---|
| **QR Code Estatico** | Loja fisica (balcao), doacao | Fixo ou aberto | Reutilizavel (permanente) | Manual (sem txid unico) |
| **QR Code Dinamico** | Cobranca, e-commerce, boleto | Definido na emissao | Uso unico | Automatica (txid unico) |
| **PIX Copia e Cola** | Alternativa ao QR Code | Igual ao QR Code | Igual ao QR Code | Igual ao QR Code |

### 5.2 API PIX (Especificacao do BACEN)

**Endpoints principais (padrao BACEN):**

| Endpoint | Metodo | Descricao |
|---|---|---|
| `/cob` | POST | Criar cobranca imediata (QR Code dinamico) |
| `/cob/{txid}` | PUT | Criar cobranca com txid especifico |
| `/cob/{txid}` | GET | Consultar cobranca |
| `/cob/{txid}` | PATCH | Alterar cobranca |
| `/cobv` | POST | Criar cobranca com vencimento |
| `/cobv/{txid}` | GET | Consultar cobranca com vencimento |
| `/pix` | GET | Listar PIX recebidos |
| `/pix/{e2eid}` | GET | Consultar PIX recebido |
| `/pix/{e2eid}/devolucao/{id}` | PUT | Devolver PIX |
| `/webhook/{chave}` | PUT | Configurar webhook |
| `/webhook/{chave}` | GET | Consultar webhook |

**Autenticacao:** OAuth2 (Client Credentials) com certificado digital mTLS.

**Webhook:** Notificacao em tempo real quando PIX e recebido. O banco envia POST para a URL cadastrada com:
```json
{
  "pix": [{
    "endToEndId": "E123456782025022810...",
    "txid": "identificador-unico-da-cobranca",
    "valor": "150.00",
    "horario": "2026-02-28T14:30:00.000Z",
    "pagador": {
      "cpf": "12345678909",
      "nome": "Joao Silva"
    }
  }]
}
```

### 5.3 PIX Cobranca (com vencimento)

**Funcionalidades:**
- PIX com data de vencimento (similar a boleto)
- Juros e multa por atraso (configuravel)
- Desconto por antecipacao (configuravel)
- Abatimentos
- Validade definida (expira apos data limite)

**Payload da cobranca com vencimento:**
```json
{
  "calendario": {
    "dataDeVencimento": "2026-03-15",
    "validadeAposVencimento": 30
  },
  "devedor": {
    "cnpj": "12345678000190",
    "nome": "Otica Exemplo Ltda"
  },
  "valor": {
    "original": "1500.00",
    "multa": { "modalidade": 2, "valorPerc": "2.00" },
    "juros": { "modalidade": 2, "valorPerc": "1.00" },
    "desconto": { "modalidade": 1, "descontoDataFixa": [
      { "data": "2026-03-10", "valorPerc": "5.00" }
    ]}
  },
  "chave": "empresa@pix.com",
  "solicitacaoPagador": "Pedido #12345"
}
```

### 5.4 Conciliacao Automatica de PIX

**O que o ERP deve implementar:**

1. **Webhook listener:** Endpoint que recebe notificacoes do banco em tempo real
2. **Matching automatico:** Cruzar `txid` do PIX recebido com o titulo em aberto no contas a receber
3. **Baixa automatica:** Marcar titulo como pago quando PIX for confirmado
4. **Tratamento de divergencias:**
   - PIX com valor menor que o titulo -> baixa parcial, gerar titulo residual
   - PIX com valor maior -> baixa total + credito residual
   - PIX sem txid (transferencia direta) -> conciliacao manual
5. **Estorno/devolucao:** API para devolver PIX parcial ou totalmente
6. **Relatorio de conciliacao:** PIX recebidos vs titulos baixados

### 5.5 PIX Agendado e PIX Parcelado

**PIX Agendado:** Pagamento programado para data futura. Disponivel via API dos bancos. O ERP pode agendar pagamentos de contas a pagar via PIX.

**PIX Parcelado:** Ainda nao e padronizado pelo BACEN para todos os bancos. Depende da instituicao financeira. O ERP pode simular parcelamento gerando multiplas cobrancas PIX com datas diferentes.

---

## 6. Integracao com NF-e/NFS-e

### 6.1 NF-e e Modulo Financeiro

**Fluxo de integracao:**

```
Venda realizada
  |
  v
Emissao NF-e (modulo fiscal/vendas)
  |
  v
Geracao automatica de titulo no Contas a Receber
  |-> Boleto gerado automaticamente
  |-> QR Code PIX gerado
  |-> Prazo conforme condicao de pagamento
  |
  v
Pagamento recebido (boleto, PIX, cartao)
  |
  v
Baixa automatica do titulo
  |
  v
Lancamento contabil automatico (Debito Banco / Credito Clientes)
```

**Para compras (NF-e de entrada):**

```
NF-e recebida do fornecedor
  |
  v
Manifestacao do Destinatario (MDe)
  |
  v
Geracao automatica de titulo no Contas a Pagar
  |-> Calculo de retencoes (IRRF, PIS, COFINS, CSLL, INSS, ISS)
  |-> Valor liquido = Bruto - Retencoes
  |-> Vencimento conforme condicao de pagamento
  |
  v
Pagamento efetuado (boleto, PIX, TED, debito)
  |
  v
Baixa do titulo + geracao de DARFs das retencoes
```

### 6.2 Manifestacao do Destinatario (MDe)

**Eventos:**

| Evento | Codigo | Descricao | Prazo |
|---|---|---|---|
| **Ciencia da Emissao** | 210210 | Tomar ciencia sem confirmar | Sem prazo (adia obrigacao de escrituracao) |
| **Confirmacao da Operacao** | 210200 | Confirma que a operacao foi realizada e mercadoria recebida | Ate 180 dias da autorizacao da NF-e |
| **Operacao nao Realizada** | 210220 | A operacao existia mas nao se concretizou | Ate 180 dias |
| **Desconhecimento da Operacao** | 210240 | Nao reconhece a NF-e (possivel fraude) | Ate 180 dias |

**Impacto no financeiro:**
- **Ciencia da Emissao:** Cria rascunho de titulo a pagar (pendente de confirmacao)
- **Confirmacao:** Efetiva o titulo a pagar, agenda pagamento
- **Operacao nao Realizada:** Cancela/exclui titulo a pagar
- **Desconhecimento:** Cancela titulo + alerta de seguranca

**O que o ERP deve fazer:**
1. Consultar DFe (Distribuicao de DF-e) da SEFAZ periodicamente para buscar NF-es emitidas contra o CNPJ da empresa
2. Apresentar NF-es pendentes de manifestacao ao usuario
3. Permitir registrar os 4 eventos via API da SEFAZ
4. Criar/cancelar titulos a pagar conforme a manifestacao
5. Vincular NF-e ao titulo financeiro para rastreabilidade

### 6.3 Cancelamento de NF-e - Impacto Financeiro

**Prazo para cancelamento:** Ate 24 horas apos autorizacao (varia por UF — SP permite 24h, outros ate 48h).

**Quando NF-e e cancelada pelo emitente (venda):**
1. Titulo a receber deve ser cancelado/estornado
2. Boleto registrado deve ser baixado no banco
3. Se PIX ja recebido, processar devolucao
4. Lancamento contabil de estorno

**Quando NF-e e cancelada pelo fornecedor (compra):**
1. Titulo a pagar deve ser cancelado
2. Se ja pago, gerar titulo a receber (credito) ou solicitar restituicao
3. Estorno de retencoes (se aplicavel)

### 6.4 Carta de Correcao (CC-e)

**O que pode corrigir:** Dados de transportadora, data de saida, CFOP, dados adicionais, dados do emitente (exceto CNPJ).

**O que NAO pode corrigir:** Valor, quantidade, dados do destinatario, aliquotas, base de calculo.

**Impacto financeiro:** Em geral, NENHUM (pois valores nao podem ser alterados por CC-e). Se o CFOP for corrigido, pode haver impacto na apuracao de impostos.

### 6.5 NFS-e e Modulo Financeiro

**Padrao Nacional NFS-e (obrigatorio a partir de 01/01/2026):**
- Todos os municipios devem aderir ao Ambiente Nacional da NFS-e
- Webservice padronizado (substituindo os diversos sistemas municipais)
- A ABRASF encerrou atualizacoes do modelo proprio

**Integracao com financeiro:**
1. Emissao de NFS-e gera titulo a receber (servicos prestados)
2. NFS-e recebida gera titulo a pagar (servicos tomados) com retencoes
3. ISS retido na NFS-e impacta o valor liquido a pagar/receber
4. Dados da NFS-e alimentam EFD-Contribuicoes (Bloco A) e EFD-Reinf

---

## 7. Obrigacoes Acessorias Mensais/Anuais

### 7.1 Calendario de Obrigacoes

| Obrigacao | Frequencia | Prazo | Regime Aplicavel |
|---|---|---|---|
| **DAS** | Mensal | Dia 20 do mes seguinte | Simples Nacional |
| **DCTFWeb** | Mensal | Dia 15 do mes seguinte (contribuicoes previd.) | Todos (exceto Simples) |
| **DCTFWeb-MIT** | Mensal | Ultimo dia util do mes seguinte (demais tributos) | Todos (exceto Simples) |
| **EFD-Reinf** | Mensal | Dia 15 do mes seguinte | Todos (exceto Simples) |
| **EFD-Contribuicoes** | Mensal | 10o dia util do 2o mes subsequente | Lucro Real/Presumido |
| **EFD ICMS/IPI** | Mensal | Dia 15 do 2o mes subsequente | Contribuintes ICMS/IPI |
| **GIA** | Mensal | Varia por UF | Contribuintes ICMS (por UF) |
| **SINTEGRA** | Mensal | Dia 15 do mes seguinte | Dispensado se entrega EFD |
| **IRPJ/CSLL** | Trimestral | Ultimo dia util do mes seguinte ao trimestre | Lucro Presumido |
| **IRPJ/CSLL** | Mensal (estimativa) ou Anual | Mensal ate o ultimo dia do mes seguinte | Lucro Real |
| **ECD** | Anual | Ultimo dia util de junho | Lucro Real/Presumido |
| **ECF** | Anual | Ultimo dia util de julho | Lucro Real/Presumido |
| **DASN-SIMEI** | Anual | 31 de maio | MEI |
| **DEFIS** | Anual | 31 de marco | Simples Nacional |
| **RAIS/eSocial** | Anual | Substituida pelo eSocial | Todos |

### 7.2 DCTFWeb (substituiu DCTF PGD)

**Status 2025-2026:** A DCTF PGD foi EXTINTA para fatos geradores a partir de 01/01/2025. Todos os tributos federais agora sao declarados na DCTFWeb.

**Como funciona:**
1. eSocial e EFD-Reinf alimentam automaticamente a DCTFWeb
2. O MIT (Modulo de Inclusao de Tributos) permite inserir debitos que NAO vem do eSocial/EFD-Reinf:
   - IRPJ, CSLL (Lucro Presumido/Real)
   - IPI
   - IOF
   - CIDE
   - PIS/COFINS (contribuicoes proprias)
   - Outros tributos federais
3. A DCTFWeb gera o DARF unificado para recolhimento

**O que o ERP precisa fazer:**
- Calcular corretamente todos os tributos devidos
- Gerar dados para alimentar o MIT (valores de IRPJ, CSLL, PIS, COFINS, IPI)
- Integrar com eSocial (contribuicoes previdenciarias da folha)
- Integrar com EFD-Reinf (retencoes de terceiros)

### 7.3 GIA (Guia de Informacao e Apuracao do ICMS)

**O que e:** Obrigacao estadual para informar a apuracao mensal do ICMS.

**Status:** Alguns estados ja dispensam a GIA quando o contribuinte entrega o SPED Fiscal. Outros ainda exigem (ex: SP, RS).

**Prazo:** Varia por UF (geralmente ate o dia 15 ou 20 do mes seguinte).

**O que o ERP precisa fornecer:**
- Valores de ICMS (debitos e creditos)
- Operacoes interestaduais
- Substituicao tributaria
- ICMS-DIFAL

### 7.4 SINTEGRA

**O que e:** Sistema Integrado de Informacoes sobre Operacoes Interestaduais com Mercadorias e Servicos.

**Status:** DISPENSADO na maioria dos estados para contribuintes que entregam EFD ICMS/IPI. Verificar por UF.

**Prazo (quando exigido):** Ate o dia 15 do mes seguinte.

### 7.5 Livros Fiscais Digitais

Os livros fiscais tradicionais foram substituidos pelo SPED Fiscal:
- **Livro de Entradas** -> SPED Fiscal (Bloco C)
- **Livro de Saidas** -> SPED Fiscal (Bloco C)
- **Livro de Apuracao do ICMS** -> SPED Fiscal (Bloco E)
- **Livro de Apuracao do IPI** -> SPED Fiscal (Bloco E)
- **Livro de Inventario** -> SPED Fiscal (Bloco H) + Bloco K
- **LALUR** -> ECF

---

## 8. Compliance e Auditoria

### 8.1 Prazos de Guarda de Documentos

| Tipo de Documento | Prazo Minimo | Base Legal |
|---|---|---|
| **Documentos fiscais eletronicos (XML NF-e, NFS-e, CT-e)** | **132 meses (11 anos)** a partir de 01/05/2025 | Ajuste SINIEF (novo) |
| **Documentos contabeis** | 5 anos (prescricao tributaria) | CTN art. 174 |
| **Livros contabeis** | Permanente (enquanto durar a PJ) | Codigo Civil art. 1.194 |
| **Documentos trabalhistas (FGTS, rescisoes)** | 30 anos (FGTS) / 5 anos (demais) | CLT / CF |
| **Notas fiscais (papel)** | 5 anos | CTN |
| **Comprovantes de recolhimento (DARF, GPS)** | 5 anos (10 anos recomendado) | CTN |
| **Documentos patrimoniais** | Enquanto durar a vida util + ate 20 anos apos baixa | Legislacao contabil |
| **Contratos** | 5 anos apos termino | Codigo Civil |
| **Escrituracoes SPED** | 5 anos (minimo legal), 11 anos (recomendado) | CTN + Ajuste SINIEF |

**IMPORTANTE:** A partir de 01/05/2025, o prazo de guarda de documentos fiscais eletronicos aumentou de 5 para 11 anos (132 meses).

### 8.2 Certificacao Digital

**Tipos de certificado digital para empresas:**

| Tipo | Armazenamento | Validade | Uso Recomendado |
|---|---|---|---|
| **A1** | Arquivo digital (computador) | 1 ano | Automacao, servidores, ERP em nuvem |
| **A3** | Token USB ou smart card | 3 a 5 anos | Uso presencial, assinatura manual |
| **Selo Eletronico** (futuro) | Digital | A definir | PJ (a partir de 2029) |

**Para que e usado:**
- Assinatura de NF-e, NFS-e, CT-e
- Transmissao de SPED (ECD, ECF, EFD)
- Login no e-CAC da Receita Federal
- Transmissao de eSocial e EFD-Reinf
- Autenticacao em APIs bancarias (mTLS)

**Mudancas previstas (ICP-Brasil):**
- Ate 31/12/2026: Encerramento da emissao de certificados A1 e A3 na cadeia V10
- A partir de 02/03/2029: Certificados A3/A4 apenas para PF; PJ usara "Selo Eletronico"

**Recomendacao para o ERP:**
- Suportar certificado A1 como padrao (melhor para automacao server-side)
- Permitir configurar certificado por empresa/tenant
- Usar certificado para assinar documentos fiscais e para autenticacao mTLS em APIs bancarias
- Alertar sobre vencimento proximo do certificado

### 8.3 Audit Trail (Trilha de Auditoria)

**Requisitos legais brasileiros para ERP financeiro:**

1. **Imutabilidade:** Lancamentos contabeis NAO podem ser excluidos, apenas estornados com novo lancamento
2. **Rastreabilidade:** Todo lancamento deve ter: usuario, data/hora, origem (documento), historico
3. **Numeracao sequencial:** Documentos financeiros devem ter numeracao sequencial sem lacunas
4. **Registro de alteracoes:** Qualquer modificacao em titulo, vencimento, valor deve ser registrada com "antes" e "depois"
5. **Backup:** Backups periodicos com retencao conforme prazos legais
6. **Assinatura digital:** SPED exige assinatura digital (certificado e-CNPJ)
7. **Log de acesso:** Registro de quem acessou dados financeiros/fiscais

**O que o ERP deve implementar:**
- Soft-delete obrigatorio (nunca excluir registros financeiros)
- Tabela de audit log com: entidade, campo, valor anterior, valor novo, usuario, timestamp
- Numeracao automatica sequencial de documentos (sem gaps)
- Controle de permissoes granular (quem pode alterar lancamentos, estornar, etc.)
- Hash de integridade em registros criticos (opcional mas recomendado)
- Exportacao de logs para auditoria externa

### 8.4 Compliance Fiscal

**Cruzamentos que a Receita Federal faz automaticamente:**

| Origem | Destino | O que cruza |
|---|---|---|
| NF-e (SEFAZ) | SPED Fiscal | Todas as notas emitidas/recebidas devem constar |
| SPED Fiscal | EFD-Contribuicoes | PIS/COFINS deve ser consistente |
| EFD-Contribuicoes | ECF | Receitas e creditos devem bater |
| EFD-Reinf | DCTFWeb | Retencoes declaradas vs. recolhidas |
| eSocial | DCTFWeb | Contribuicoes previdenciarias |
| DIRF (historico) | IRPF dos beneficiarios | Retencoes informadas vs. declaradas |
| Cartoes de credito | DECRED/e-Financeira | Vendas por cartao vs. receita declarada |

**Risco para oticas:** A Receita cruza vendas por cartao de credito/debito (informadas pelas credenciadoras via e-Financeira) com o faturamento declarado. Se as vendas no cartao forem maiores que o faturamento, a empresa e autuada.

---

## 9. Reforma Tributaria 2026-2033 (IBS/CBS)

### 9.1 Visao Geral

A Lei Complementar 214/2025 instituiu o IVA Dual brasileiro: CBS (federal) + IBS (estadual/municipal), substituindo gradualmente PIS, COFINS, IPI, ICMS e ISS.

**Cronograma de transicao:**

| Ano | CBS (federal) | IBS (est/mun) | PIS/COFINS | ICMS | ISS |
|---|---|---|---|---|---|
| 2026 | 0,9% (teste) | 0,1% (teste) | Normal | Normal | Normal |
| 2027 | Aliquota cheia | 0,1% | EXTINTOS | Normal | Normal |
| 2028 | Aliquota cheia | Parcial | - | Reducao | Reducao |
| 2029-2032 | Aliquota cheia | Crescente | - | Decrescente | Decrescente |
| 2033 | Aliquota cheia | Aliquota cheia | - | EXTINTO | EXTINTO |

**Aliquota de referencia:** Estimada em 26,5% (CBS + IBS somados). Pode variar com reducoes setoriais.

### 9.2 Split Payment (a partir de 2027)

**O que e:** No momento do pagamento (cartao, PIX, boleto), o sistema financeiro automaticamente separa a parcela do imposto (CBS/IBS) e envia diretamente ao governo. O comerciante recebe apenas o valor liquido.

**Impacto CRITICO para oticas:**
- **Fim do "float financeiro":** Hoje, a empresa recebe 100% da venda e paga o imposto semanas depois. Com split payment, o imposto e retido na hora.
- **Reducao do capital de giro:** O caixa da empresa recebe menos dinheiro por venda.
- **ERPs e PDVs devem estar integrados** a "calculadora" do Fisco para informar o valor correto do imposto em cada transacao.

**O que o ERP deve preparar:**
1. Campos para CBS e IBS na NF-e/NFC-e (ja obrigatorios em 2026)
2. Logica de split payment nos recebimentos
3. Conciliacao de valores recebidos (liquido) vs. valor da venda (bruto)
4. Calculo de creditos de IBS/CBS (nao cumulatividade plena)
5. Novo plano de contas contabeis para os novos tributos

### 9.3 Impacto nos Documentos Fiscais (NF-e/NFC-e)

A partir de 2026, a NF-e e NFC-e devem conter novos campos:
- CST (Codigo de Situacao Tributaria) para IBS e CBS
- cClassTrib (Classificacao Tributaria)
- Aliquotas de CBS e IBS
- Valor de CBS e IBS
- Informacoes para split payment

### 9.4 Creditos Fiscais

Diferente do sistema atual, a reforma permite credito amplo (nao cumulatividade plena):
- Todo tributo pago na aquisicao de bens e servicos gera credito
- Creditos financeiros (nao fisicos) — nao depende de saida tributada
- Ressarcimento de creditos acumulados em ate 60 dias
- Impacto positivo para varejo optico (credito sobre compra de lentes, armacoes, insumos)

---

## 10. Conciliacao Bancaria

### 10.1 Metodos de Conciliacao

| Metodo | Descricao | Automacao |
|---|---|---|
| **OFX** | Importacao manual de arquivo OFX do internet banking | Semi-automatica |
| **API bancaria** | Integracao direta via API Open Banking | Automatica |
| **CNAB retorno** | Arquivo de retorno de cobranca | Semi-automatica |
| **Extrato eletronico** | Integracao com internet banking | Automatica |

### 10.2 Formato OFX

**O que e:** Open Financial Exchange — formato padronizado para troca de dados financeiros entre bancos e softwares.

**Estrutura do arquivo OFX:**
```xml
<OFX>
  <BANKMSGSRSV1>
    <STMTTRNRS>
      <STMTRS>
        <CURDEF>BRL</CURDEF>
        <BANKACCTFROM>
          <BANKID>341</BANKID>
          <ACCTID>12345-6</ACCTID>
          <ACCTTYPE>CHECKING</ACCTTYPE>
        </BANKACCTFROM>
        <BANKTRANLIST>
          <DTSTART>20260201</DTSTART>
          <DTEND>20260228</DTEND>
          <STMTTRN>
            <TRNTYPE>CREDIT</TRNTYPE>
            <DTPOSTED>20260215</DTPOSTED>
            <TRNAMT>1500.00</TRNAMT>
            <FITID>20260215001</FITID>
            <MEMO>PIX RECEBIDO - OTICA EXEMPLO</MEMO>
          </STMTTRN>
        </BANKTRANLIST>
        <LEDGERBAL>
          <BALAMT>45000.00</BALAMT>
          <DTASOF>20260228</DTASOF>
        </LEDGERBAL>
      </STMTRS>
    </STMTTRNRS>
  </BANKMSGSRSV1>
</OFX>
```

### 10.3 O que o ERP deve implementar

1. **Importacao OFX:** Parser para importar extratos bancarios no formato OFX
2. **Matching automatico:** Algoritmo para casar lancamentos do extrato com titulos do financeiro:
   - Por valor + data + descricao
   - Por nosso numero (boletos)
   - Por txid (PIX)
   - Por identificador da transacao (FITID)
3. **Conciliacao manual assistida:** Interface para o usuario casar lancamentos nao identificados automaticamente
4. **Regras de conciliacao:** Configuracao de tolerancias (diferenca de centavos, datas)
5. **Relatorio de pendencias:** Lancamentos no banco sem correspondencia no ERP e vice-versa
6. **Integracao contabil:** Lancamento automatico de taxas bancarias, juros, tarifas

---

## 11. Requisitos Especificos para Varejo Optico

### 11.1 CNAE e Enquadramento

- **CNAE principal:** 4774-1/00 (Comercio varejista de artigos de optica)
- **Atividades:** Armacoes para oculos, lentes oftalmicas, lentes de contato, oculos de sol, produtos de limpeza optica
- **Permite Simples Nacional:** SIM
- **Permite MEI:** SIM (com limitacoes)
- **Anexo Simples:** I (Comercio)
- **RAT (Risco Acidente Trabalho):** 2,00%
- **NAO esta sujeito ao Fator-R**

### 11.2 Particularidades Fiscais

1. **ICMS:** Aplicavel na venda de mercadorias (lentes, armacoes, acessorios)
2. **ICMS-ST:** Substituicao tributaria pode se aplicar a lentes e armacoes em alguns estados (verificar NCM + protocolo/convenio ICMS)
3. **ISS:** Pode se aplicar quando a otica presta servico de montagem/adaptacao de lentes (servico de saude optica)
4. **IPI:** Nao incide no varejo (apenas na industria)
5. **NCM relevantes:**
   - 9001.50 — Lentes de contato
   - 9001.40 — Lentes oftalmicas de vidro
   - 9001.50 — Lentes oftalmicas de plastico
   - 9003.11 — Armacoes de plastico
   - 9003.19 — Armacoes de metal
   - 9004.10 — Oculos de sol

### 11.3 NFC-e / SAT / MFe

**Para vendas ao consumidor final, oticas devem emitir:**
- **NFC-e** (nota fiscal do consumidor eletronica) — padrao na maioria dos estados
- **SAT/CF-e-SAT** — obrigatorio em Sao Paulo (hardware fiscal)
- **MFe** — obrigatorio no Ceara (modulo fiscal eletronico)

**O que o ERP precisa:**
- Emissao de NFC-e integrada ao modulo de vendas
- Contingencia offline (EPEC ou NFC-e em contingencia)
- Impressao simplificada (cupom fiscal eletronico)
- QR Code na NFC-e (obrigatorio)

### 11.4 Fluxo Financeiro Tipico de uma Otica

```
VENDAS (Contas a Receber):
  |-- Venda a vista (dinheiro, PIX, debito) -> Baixa imediata
  |-- Venda a prazo (cartao credito) -> Titulo com vencimento D+30
  |-- Venda parcelada (boleto/carne) -> Multiplos titulos
  |-- Convenio empresa -> Fatura mensal consolidada
  |-- Plano de saude -> Fatura com glosas possiveis
  |
COMPRAS (Contas a Pagar):
  |-- Fornecedor lentes (Essilor, Hoya, Zeiss) -> Boleto/duplicata
  |-- Fornecedor armacoes (Luxottica, Safilo) -> Boleto/duplicata
  |-- Laboratorio optico (surfacagem) -> NFS-e, pode ter ISS retido
  |-- Aluguel loja -> Boleto/debito automatico, IRRF sobre PF
  |-- Servicos contabeis -> NFS-e com retencoes
  |-- Despesas gerais -> Cartao corporativo, PIX, debito
```

---

## 12. Resumo de Entidades e Tabelas

### 12.1 Entidades Financeiras Sugeridas para o ERP

**Contas a Receber:**
- TituloReceber (ContaReceber)
- ParcelaReceber
- BaixaReceber
- NegociacaoReceber (renegociacao de divida)

**Contas a Pagar:**
- TituloPagar (ContaPagar)
- ParcelaPagar
- BaixaPagar
- RetencaoFiscal (vinculada ao titulo)

**Bancario:**
- ContaBancaria
- LancamentoBancario (extrato)
- ConciliacaoBancaria
- ConciliacaoItem (matching)
- TransferenciaBancaria

**Cobranc:**
- ConfiguracaoBoleto (por banco)
- RemessaBancaria (CNAB)
- RetornoBancario (CNAB)
- ProtestoTitulo

**PIX:**
- ChavePIX (por conta bancaria)
- CobrancaPIX (QR Code gerado)
- RecebimentoPIX (webhook)

**Fiscal/Tributario:**
- RegimeTributario (Simples, Presumido, Real — por empresa)
- ApuracaoTributo (mensal/trimestral)
- GuiaRecolhimento (DARF, GPS, DAS, ISS)
- RetencaoFiscal (IRRF, PIS, COFINS, CSLL, INSS, ISS)
- CreditoFiscal (PIS, COFINS, ICMS, IBS, CBS)

**Contabilidade:**
- PlanoContas
- ContaContabil
- LancamentoContabil
- CentroCusto
- PartidaContabil (debito/credito)

**Caixa:**
- CaixaControle (abertura/fechamento)
- MovimentacaoCaixa

---

## Fontes

### SPED e Escrituracoes
- [ECD - SPED - Receita Federal](http://sped.rfb.gov.br/projeto/show/273)
- [ECF - SPED - Receita Federal](http://sped.rfb.gov.br/projeto/show/269)
- [EFD ICMS IPI - SPED](http://sped.rfb.gov.br/projeto/show/274)
- [EFD Contribuicoes - SPED](http://sped.rfb.gov.br/projeto/show/268)
- [SPED Contabil 2026 - Contabilidade Financeira](https://contabilidadefinanceira.com.br/declaracoes-e-demonstrativos/sped-contabil-2026/)
- [ECD 2025: Prazos e Regras | Qive](https://qive.com.br/blog/sped-contabil-ecd/)
- [ECF 2026 - Contaja](https://contaja.com.br/blog/ecf-e-ecd/)
- [EFD ICMS IPI - Nota Tecnica 2025.001 Leiaute 020](https://blog.tecnospeed.com.br/novo-leiaute-do-sped-fiscal-para-2026/)
- [EFD Contribuicoes 2025 | Qive](https://qive.com.br/blog/efd-contribuicoes-entenda-de-uma-vez)
- [Nota Tecnica 011/2026: Descontinuidade EFD-Contribuicoes](https://spedbrasil.com.br/nota-tecnica-011-2026-efd-contribuicoes/)
- [SPED ECD - Microsoft Dynamics 365](https://learn.microsoft.com/pt-br/dynamics365/finance/localizations/brazil/latam-bra-sped-ecd)
- [EFD ICMS IPI Atualizacao 2026 - Contabeis](https://www.contabeis.com.br/noticias/73131/efd-icms-ipi-ganha-atualizacao-para-2026/)

### Reinf e DIRF
- [Fim da DIRF - O que muda em 2026](https://inventsoftware.com.br/en/financeiro/fim-da-dirf-o-que-muda-em-2026-e-como-organizar-esocial-e-efd-reinf-sem-perder-controle)
- [Receita Federal - Fim da DIRF](https://www.gov.br/receitafederal/pt-br/assuntos/noticias/2025/julho/a-declaracao-do-imposto-sobre-a-renda-retido-na-fonte-dirf-nao-sera-mais-utilizada)
- [EFD-Reinf 2026 - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/efd-reinf-2025/)
- [EFD Reinf 2025 Guia | Qive](https://qive.com.br/blog/efd-reinf)

### Retencoes e Impostos
- [Retencoes na Fonte - Portal Tributario](https://www.portaltributario.com.br/artigos/retencoesservicos.htm)
- [Retencoes Federais 2025 - JetTax](https://www.jettax.com.br/blog/retencoes-federais-2025/)
- [Retencao de Impostos NFS-e - TecnoSpeed](https://blog.tecnospeed.com.br/entenda-tudo-sobre-a-retencao-de-impostos-na-nota-fiscal-de-servico-eletronica/)
- [Retencao de Impostos - Conta Azul](https://contaazul.com/blog/retencao-de-impostos/)
- [Retencoes Simples Nacional | Qive](https://qive.com.br/blog/simples-nacional-quais-as-retencoes-em-geral/)
- [ISS Retido - Focus NFe](https://focusnfe.com.br/blog/quando-o-iss-e-retido-na-nfse-e-como-calcular-o-valor/)
- [ISS - TOTVS](https://www.totvs.com/blog/adequacao-a-legislacao/iss/)

### Regimes Tributarios
- [Simples Nacional Lucro Presumido Lucro Real - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/simples-nacional-lucro-presumido-e-lucro-real/)
- [CNAE 4774-1/00 Simples Nacional - Contabeis](https://www.contabeis.com.br/ferramentas/simples-nacional/4774100/)
- [Anexo I Simples Nacional 2026 - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/anexo-1-simples-nacional/)
- [IRPJ Lucro Presumido - Portal Tributario](https://www.portaltributario.com.br/guia/lucro_presumido_irpj.html)
- [Como Calcular Lucro Presumido 2026](https://portaldacontabilidade.clmcontroller.com.br/como-calcular-o-lucro-presumido/)
- [Lucro Real - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/lucro-real/)
- [Tabela Simples Nacional 2026 - Contaja](https://contaja.com.br/blog/tabela-simples-nacional/)

### Boleto e CNAB
- [CNAB 240 e CNAB 400 - TecnoSpeed](https://blog.tecnospeed.com.br/padroes-de-remessa-e-de-retorno/)
- [Boleto Hibrido PIX - TecnoSpeed](https://blog.tecnospeed.com.br/cluster-boleto-hibrido/)
- [Padrao FEBRABAN 240 V6.0 - Banese](https://www.banese.com.br/conteudo/uploads/2024/01/Layout-do-Servico-de-Cobranca-CNAB240.pdf)
- [Layout CNAB 240 Santander Abril 2025](https://cms.santander.com.br/sites/WPS/documentos/arq-layout-de-arquivos-download-cob240ptbr/25-06-13_130421_cnab-240-abril-2025-ptbr.pdf)
- [Boleto Bancario Completo - TecnoSpeed](https://blog.tecnospeed.com.br/boleto-bancario-tudo-que-voce-precisa-saber/)
- [Guia Boletos CNAB API - Guinzo](https://site.guinzo.com.br/boletos-cnab-api/)
- [API vs CNAB - TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/30763435298327-Cross-Segmentos-Backoffice-Linha-Protheus-SIGAFIN-Qual-a-diferen%C3%A7a-entre-CNAB-e-API)

### PIX
- [API PIX Guia Completo - ValidaPix](https://blog.validapix.com.br/guia-completo-sobre-api-pix)
- [API PIX - TOTVS](https://www.totvs.com/blog/servicos-financeiros/api-pix/)
- [PIX QR Code Estatico Dinamico - Neofin](https://www.neofin.com.br/blog/pix-dinamico-e-estatico-diferencas)
- [QR Code PIX - Efi](https://sejaefi.com.br/blog/qr-code-estatico-qr-code-dinamico-no-pix)
- [API PIX Inter](https://developers.inter.co/references/pix)
- [Manual Padroes Iniciacao PIX - BACEN](https://www.bcb.gov.br/content/estabilidadefinanceira/pix/Regulamento_Pix/II_ManualdePadroesparaIniciacaodoPix.pdf)
- [PIX para Empresas - Transfeera](https://transfeera.com/blog/pix-para-empresas/)
- [PIX para ERP - OpenPix](https://openpix.com.br/pix/erp/)
- [PIX Webhook - OpenPix](https://openpix.com.br/modulos/webhook/)
- [PIX ERP Automacao - E-Commerce Brasil](https://www.ecommercebrasil.com.br/artigos/como-integrar-pix-ao-erp-e-alcancar-a-automacao-financeira)

### NF-e / NFS-e
- [Manifestacao Destinatario | Qive](https://qive.com.br/blog/manifestacao-do-destinatario-tudo-voce-precisa-saber)
- [MDe Tipos e Prazos - TecnoSpeed](https://atendimento.tecnospeed.com.br/hc/pt-br/articles/12554354052119-MDe-Tipos-e-prazos-dos-eventos-de-manifesta%C3%A7%C3%A3o-do-destinat%C3%A1rio)
- [MDe - Focus NFe](https://focusnfe.com.br/blog/manifestacao-do-destinatario/)
- [ABRASF Fim Modelo NFS-e](https://abrasf.org.br/comunicacao/noticias/nova-fase-nfs-e-adesao-ao-modelo-nacional-encerra-atualizacoes-do-modelo-abrasf)
- [NFS-e Padrao Nacional 2026 - TOTVS](https://www.totvs.com/blog/fiscal-clientes/abrasf-anuncia-fim-de-atualizacoes-do-modelo-proprio-de-nfs-e-e-reforca-adocao-do-padrao-nacional/)
- [Ambiente Nacional NFS-e 2026 - Omie](https://ajuda.omie.com.br/pt-BR/articles/12270528-ambiente-nacional-da-nfs-e-o-que-muda-a-partir-de-2026)

### DCTFWeb e Obrigacoes
- [DCTFWeb 2026 - JetTax](https://www.jettax.com.br/blog/dctfweb-o-que-e-e-o-que-muda-em-2026/)
- [DCTF Extinta 2025 - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/noticias/2024/dezembro/publicada-instrucao-normativa-que-institui-o-modulo-de-inclusao-de-tributos-2013-mit-na-dctfweb-e-substitui-a-dctf)
- [MIT Modulo Inclusao Tributos - CFC](https://cfc.org.br/wp-content/uploads/2025/02/MIT-DCTFWeb-JAN-2025.pdf)
- [Obrigacoes Acessorias Federais 2026](https://escolasuperioresn.com.br/obrigacoes-acessorias-federais-2026-calendario-completo/)
- [Calendario Fiscal 2026](https://rolmyjuncontabilidade.com.br/fiscal-e-tributario/calendario-fiscal-2026/)
- [Obrigacoes Fiscais 2025 | Qive](https://qive.com.br/blog/obrigacoes-fiscais)

### Reforma Tributaria
- [Reforma Tributaria 2026 Guia Completo - Tax Group](https://www.taxgroup.com.br/intelligence/reforma-tributaria-2026-guia-completo-sobre-o-que-muda-e-a-transicao/)
- [Reforma Tributaria Guia Transicao - JetTax](https://www.jettax.com.br/blog/reforma-tributaria-guia-de-sobrevivencia-para-a-transicao-2026-2033/)
- [Reforma Tributaria Varejo - TOTVS](https://espacolegislacao.totvs.com/reforma-tributaria-segmento-varejo/)
- [Split Payment - Thomson Reuters](https://www.thomsonreuters.com.br/pt/tax-accounting/onesource-mastersaf/blog/split-payment-reforma-tributaria.html)
- [Split Payment - EY](https://www.ey.com/pt_br/newsroom/2026/01/reforma-tributaria-split-payment-vai-alterar-gestao-caixa-empresas)
- [Reforma Tributaria Fluxo Caixa - Contabeis](https://www.contabeis.com.br/artigos/74516/reforma-tributaria-2026-impacto-no-fluxo-de-caixa-e-preparo)
- [Reforma Tributaria Conta Azul](https://contaazul.com/blog/reforma-tributaria/)

### Compliance e Auditoria
- [Prazos Guarda Documentos - Access](https://www.accesscorp.com/pt-br/blog/prazos-para-guarda-de-documentos-tributarios/)
- [11 Anos Guarda Documentos Fiscais - Contabeis](https://www.contabeis.com.br/artigos/70492/novo-ajuste-sinief-exige-guarda-de-documentos-fiscais-por-11-anos/)
- [Prazos Guarda Documentos Fiscais - JetTax](https://www.jettax.com.br/blog/prazos-de-guarda-de-documentos/)
- [Certificado Digital e-CNPJ - Certisign](https://certisign.com.br/certificados/e-cnpj)
- [ICP-Brasil Novos Modelos 2025](https://portalspedbrasil.com.br/forum/icp-brasil-contara-com-novos-modelos-de-certificado-digital-a-partir-de-2025-fim-dos-certificados-a1-a2-e-a3/)
- [Certificado Digital NF-e - Portal NF-e](https://www.nfe.fazenda.gov.br/portal/perguntasFrequentes.aspx?tipoConteudo=FBya9bipr34%3D)

### Conciliacao Bancaria
- [Extrato OFX - Conta Azul](https://contaazul.com/blog/extrato-ofx/)
- [Conciliacao Bancaria OFX - Nomus](https://atendimento.nomus.com.br/hc/pt-br/articles/35194002807451--Guia-r%C3%A1pido-Concilia%C3%A7%C3%A3o-banc%C3%A1ria-com-arquivo-OFX)
- [Conciliacao Bancaria - Omie](https://www.omie.com.br/funcionalidades/conciliacao-bancaria/)
- [Conciliacao Extrato - Sankhya](https://ajuda.sankhya.com.br/hc/pt-br/articles/360044606214-Concilia%C3%A7%C3%A3o-Extrato-Banc%C3%A1rio)

### Guias de Recolhimento
- [GPS Previdencia Social - Gov.br](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/pagamentos-e-parcelamentos/emissao-e-pagamento-de-darf-das-gps-e-dae/gps-guia-da-previdencia-social-orientacoes-1)
- [DARF - Gov.br](https://www.gov.br/pt-br/servicos/emitir-darf-para-pagamento-de-tributos-federais)
- [Guias Recolhimento ERP - Senior](https://suporte.senior.com.br/hc/pt-br/articles/4408629359508-ERP-Guias-de-Recolhimento-Como-gerar-Guias-de-recolhimento-DARF)

### Protesto
- [Protesto Digital - Neofin](https://www.neofin.com.br/neofin-academy/como-aumentar-seu-caixa-com-protesto-digital)
- [Integracao Cartorio Protesto IEPTB - Senior](https://documentacao.senior.com.br/gestaoempresarialerp/5.10.2/integracoes/integracao-cra.htm)
- [Protesto Cartorio 2025 - Neofin](https://www.neofin.com.br/blog/protesto-em-cartorio-2025)
