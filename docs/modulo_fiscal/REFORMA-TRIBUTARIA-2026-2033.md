# Reforma Tributária Brasileira — Guia Completo para o OpticalCore ERP

> Pesquisa realizada em 04/03/2026. Base legal: EC 132/2023, LC 214/2025, LC 224/2025, LC 227/2026.

---

## Índice

1. [Visão Geral](#1-visão-geral)
2. [Os Novos Tributos (CBS, IBS, IS)](#2-os-novos-tributos)
3. [Cronograma Completo (2026-2033)](#3-cronograma-completo)
4. [Não Cumulatividade Ampla](#4-não-cumulatividade-ampla)
5. [Regimes Diferenciados e Específicos](#5-regimes-diferenciados-e-específicos)
6. [Simples Nacional](#6-simples-nacional)
7. [Zona Franca de Manaus](#7-zona-franca-de-manaus)
8. [Cashback Tributário](#8-cashback-tributário)
9. [Cesta Básica Nacional](#9-cesta-básica-nacional)
10. [Medicamentos](#10-medicamentos)
11. [Serviços Financeiros](#11-serviços-financeiros)
12. [Plataformas Digitais](#12-plataformas-digitais)
13. [Importação e Exportação](#13-importação-e-exportação)
14. [Split Payment](#14-split-payment)
15. [Documentos Fiscais — NT 2025.002](#15-documentos-fiscais)
16. [CST e cClassTrib — Tabelas Oficiais](#16-cst-e-cclasstrib)
17. [CFOP, NCM e CEST](#17-cfop-ncm-e-cest)
18. [Obrigações Acessórias](#18-obrigações-acessórias)
19. [Comitê Gestor do IBS](#19-comitê-gestor-do-ibs)
20. [Créditos Tributários](#20-créditos-tributários)
21. [DIFAL e ICMS-ST](#21-difal-e-icms-st)
22. [Tributação Monofásica](#22-tributação-monofásica)
23. [Devolução e Bonificação](#23-devolução-e-bonificação)
24. [Penalidades e Multas](#24-penalidades-e-multas)
25. [Lucro Real e Presumido](#25-lucro-real-e-presumido)
26. [Retenções na Fonte](#26-retenções-na-fonte)
27. [Imunidades e Isenções](#27-imunidades-e-isenções)
28. [ITCMD e IPVA](#28-itcmd-e-ipva)
29. [Certificado Digital](#29-certificado-digital)
30. [Escrituração Fiscal Digital (SPED)](#30-escrituração-fiscal-digital)
31. [Impacto no OpticalCore — Plano de Implementação](#31-impacto-no-opticalcore)

---

## 1. Visão Geral

A Reforma Tributária unifica **cinco tributos** (PIS, COFINS, IPI, ICMS e ISS) em um modelo de **IVA Dual** (CBS + IBS) mais o **Imposto Seletivo (IS)**, com transição gradual de 2026 a 2033.

### Leis Fundamentais

| Lei | Data | Conteúdo |
|-----|------|----------|
| EC 132/2023 | 20/12/2023 | Emenda Constitucional — cria o novo modelo tributário |
| LC 214/2025 | 16/01/2025 | Regulamenta IBS, CBS e IS, incluindo regras de transição |
| LC 224/2025 | 26/12/2025 | Altera Lucro Presumido, JCP e benefícios fiscais federais |
| LC 227/2026 | 13/01/2026 | Institui Comitê Gestor do IBS, regulamenta ITCMD |

---

## 2. Os Novos Tributos

### CBS (Contribuição sobre Bens e Serviços) — Federal

- **Substitui:** PIS + COFINS (+ IPI zerado em 2027)
- **2026:** Alíquota-teste **0,9%** (compensável com PIS/COFINS)
- **2027+:** Alíquota cheia **~8,8%** (PIS/COFINS extintos)

### IBS (Imposto sobre Bens e Serviços) — Estadual + Municipal

- **Substitui:** ICMS + ISS
- **2026:** Alíquota-teste **0,1%**
- **2029-2032:** Transição progressiva (10%→40% da alíquota-referência)
- **2033:** Alíquota cheia **~17,7%** (ICMS/ISS extintos)
- **Composto por:** IBS-UF (estadual) + IBS-Mun (municipal)
- **Princípio do destino:** tributo cobrado no município de consumo

### IS (Imposto Seletivo) — "Imposto do Pecado"

- **Incide sobre:** Cigarros, bebidas alcoólicas, bebidas açucaradas, veículos poluentes, combustíveis fósseis, mineração
- **2027+:** Entra em vigor com cobrança efetiva
- **Monofásico:** incide uma única vez (produção/importação)
- **Não gera créditos** para operações posteriores

### Alíquota Combinada de Referência

**~26,5%** (trava constitucional). Estimativas técnicas: ~27,8%.

---

## 3. Cronograma Completo

| Ano | CBS | IBS | ICMS/ISS | PIS/COFINS | IS |
|-----|-----|-----|----------|------------|-----|
| **2026** | 0,9% (teste) | 0,1% (teste) | 100% | 100% (compensam CBS) | Campos opcionais |
| **2027** | ~8,8% (cheia) | 0,1% (operacional) | 100% | **EXTINTOS** | Em vigor |
| **2028** | ~8,8% | 0,1% | 100% | — | Em vigor |
| **2029** | ~8,8% | 10% ref. | -10% | — | Em vigor |
| **2030** | ~8,8% | 20% ref. | -20% | — | Em vigor |
| **2031** | ~8,8% | 30% ref. | -30% | — | Em vigor |
| **2032** | ~8,8% | 40% ref. | -40% | — | Em vigor |
| **2033** | ~8,8% | 100% (cheia) | **EXTINTOS** | — | Em vigor |

### Marcos Específicos 2026

| Data | Obrigação |
|------|-----------|
| 01/01/2026 | Início dos testes CBS 0,9% + IBS 0,1% |
| 01/01/2026 | Campos IBS/CBS obrigatórios na NF-e (regime normal) |
| 01/01/2026 | NFS-e Nacional obrigatória (5.570 municípios) |
| 01/01/2026 | EFD ICMS/IPI leiaute 020 em vigor |
| Até 4° mês | Período sem penalidades por erros nos campos |
| 31/12/2026 | Encerramento emissão certificados A1/A3 cadeia V10 |

---

## 4. Não Cumulatividade Ampla

A LC 214/2025 adota **crédito financeiro integral** — diferente do crédito físico atual.

| Aspecto | PIS/COFINS Atual | IBS/CBS Novo |
|---------|-----------------|--------------|
| Tipo | Físico (só insumos diretos) | **Financeiro (qualquer aquisição)** |
| Bens de uso e consumo | Limitado | Integral e imediato |
| Bens de capital | 12-48 parcelas | **Integral e imediato** (Art. 108) |
| Serviços tomados | Só "insumo" | Amplo |
| Energia, aluguel, telecom | Parcial | Integral |

### Vedações ao Crédito

- Bens recreativos/estéticos (quando não atividade-fim)
- Hotelaria para consumo pessoal
- Aquisições de não identificados
- Operações isentas geram anulação dos créditos

---

## 5. Regimes Diferenciados e Específicos

### Alíquota Zero (redução de 100%)

| Setor/Produto | Base Legal |
|---------------|-----------|
| Cesta Básica Nacional (26 produtos) | Anexo I, Art. 125 |
| Hortícolas, frutas e ovos | Anexo XV, Art. 148 |
| 383 medicamentos (princípios ativos) | Anexo XIV, Arts. 149-150 |
| Dispositivos médicos/acessibilidade | Anexo XVI |
| Transporte coletivo urbano | Arts. 284-285 |
| Educação sem fins lucrativos (PROUNI) | Art. 131 |

### Redução de 60%

| Setor/Produto | Anexo |
|---------------|-------|
| Serviços de saúde | III |
| Serviços de educação | II |
| Medicamentos não listados no XIV | V |
| Alimentos não essenciais | VII |
| Higiene/limpeza baixa renda | VIII |
| Insumos agropecuários | IX |
| Produções culturais/jornalísticas | X |
| Planos de saúde humana | Art. 237 |
| Nutrição enteral/parenteral | VI |

### Redução de 30%

- Profissionais liberais regulamentados
- Planos de saúde animal

### Regimes Totalmente Específicos

| Setor | Característica |
|-------|---------------|
| **Combustíveis** | Monofásica, ad rem (R$/litro), uniforme nacional |
| **Serviços financeiros** | Spread → regime específico; tarifas → ordinário |
| **Operações imobiliárias** | Locação -70%, compra/venda -50%, redutor social R$600/mês |
| **Cooperativas** | Ato cooperativo = alíquota zero |
| **Telecom, energia, saneamento** | Fato gerador no vencimento |

---

## 6. Simples Nacional

- **Continua existindo** com DAS unificado
- **Opção híbrida:** pode recolher IBS/CBS fora do DAS (regime regular) → transfere créditos cheios
- **Nanoempreendedor (novo):** PF até R$ 40.500/ano, isento de IBS e CBS
- **2026:** Dispensado de informar IBS/CBS na NF-e
- **2027:** Obrigatório

---

## 7. Zona Franca de Manaus

- Incentivos garantidos até **2073** (EC 83/2014)
- Substituição por créditos presumidos: IBS 7,5% (Sul/Sudeste) + CBS 6%
- Créditos só compensam o respectivo tributo

---

## 8. Cashback Tributário

| Produto/Serviço | CBS Devolvida | IBS Devolvido |
|-----------------|---------------|---------------|
| Gás, energia, água, telecom | **100%** | **20%** |
| Demais produtos | **20%** | **20%** |

- Público: CadÚnico, renda até ½ salário mínimo per capita
- CBS: a partir de 2027; IBS: a partir de 2029
- Serviços mensais: desconto direto na fatura

---

## 9. Cesta Básica Nacional

26 produtos com alíquota zero (Anexo I, Art. 125):

1. Arroz (1006.20, 1006.30, 1006.40.00)
2. Leite fluido (0401.10, 0401.20, 0401.40, 0401.50)
3. Leite em pó (0402.10, 0402.21, 0402.29)
4. Fórmulas infantis (cap. 19 e 22)
5. Manteiga (0405.10.00)
6. Margarina (1517.10)
7. Feijões (0713.33)
8. Café (0901)
9. Óleo de soja (1507)
10. Óleo de babaçu (1513.29)
11. Farinha de mandioca e tapioca (1106.20, 1903)
12. Farinha/grumos/sêmolas de milho (1102.20, 1103.13)
13. Grãos de milho (1005.90)
14. Farinha de trigo (1101)
15. Açúcar (1701)
16. Massas alimentícias (1902)
17. Pão francês e pré-misturas (1905.90, 1901.20)
18. Grãos de aveia (1104)
19. Farinha de aveia (1102)
20. Carnes (bovina, suína, ovina, aves) (0201-0204, 0207)
21. Peixes populares (0302-0304)
22. Sal iodado (2501)
23. Mate/erva-mate (0903)
24. Queijos (mussarela, minas, ricota, etc.) (0406)
25. Farinha/pó de peixe (0305)
26. Chás (0902)

**Anexo XV** adiciona: hortícolas, frutas e ovos (também alíquota zero).

---

## 10. Medicamentos

| Faixa | Descrição | Base Legal |
|-------|-----------|-----------|
| **Alíquota Zero** | 383 princípios ativos | Anexo XIV |
| **Redução 60%** | Demais registrados ANVISA | Anexo V |
| **Padrão** | Não classificados | Regra geral |

- Lista baseada em **princípio ativo** (genéricos e referência iguais)
- Revisão a cada **120 dias** pelo Poder Executivo
- Dispositivos médicos: Anexo XVI (alíquota zero)

---

## 11. Serviços Financeiros

| Tipo | Regime | Base de Cálculo |
|------|--------|-----------------|
| Spread (crédito, câmbio, títulos) | Específico | Receitas − deduções |
| Tarifas e comissões | Ordinário | Valor da tarifa |

Abrange: bancos, cooperativas de crédito, seguradoras, previdência, consórcio, leasing, securitizadoras, gestoras, corretoras, fintechs, cripto.

Planos de saúde: base = receita − sinistros, alíquota reduzida em 60%.

---

## 12. Plataformas Digitais

| Cenário | Responsabilidade |
|---------|-----------------|
| Fornecedor emite NF-e | Plataforma é corresponsável solidária |
| Fornecedor NÃO emite NF-e | Plataforma é responsável principal |
| Fornecedor estrangeiro sem cadastro | Plataforma recolhe integralmente |
| Nem fornecedor nem plataforma cadastrados | Instituição de câmbio retém |

---

## 13. Importação e Exportação

- **Exportação:** imune a IBS/CBS, com manutenção integral de créditos (ressarcíveis)
- **Importação:** IBS/CBS na mesma alíquota do similar nacional, crédito permitido
- **Serviços digitais importados:** fornecedor deve se cadastrar no Brasil

---

## 14. Split Payment

| Modalidade | Funcionamento |
|-----------|---------------|
| **Superinteligente** (padrão) | Valida e aplica créditos automaticamente em tempo real |
| **Inteligente** | Valor informado sem validação |
| **Simplificado** | Percentual estimado pelo Fisco |
| **Contingência** | Falha → retenção integral temporária |

Cronograma: 2026 testes → 2027 facultativo B2B → 2033 plenamente obrigatório.

Impacto: empresa recebe valor líquido (tributo segregado automaticamente pelo banco).

---

## 15. Documentos Fiscais — NT 2025.002

### Novo Grupo UB no XML (100+ campos)

| Tag | Descrição |
|-----|-----------|
| `<gIBSCBS>` (UB01) | Grupo principal IBS/CBS/IS por item |
| `CST` (UB02) | Código de Situação Tributária IBS/CBS (3 dígitos) |
| `cClassTrib` (UB03) | Código de Classificação Tributária |
| `vBC` (UB04) | Base de cálculo IBS/CBS |
| `<gIBSUF>` (UB12) | IBS Estadual: pIBSUF, vIBSUF, gRedIBSUF, gDifIBSUF |
| `<gIBSMun>` (UB13) | IBS Municipal: pIBSMun, vIBSMun, gRedIBSMun, gDifIBSMun |
| `<gCBS>` (UB14) | CBS Federal: pCBS, vCBS, gRedCBS, gDifCBS |
| `<IBSCBSTot>` (W03) | Totalizador: vIBSUFTot, vIBSMunTot, vIBS, vCBSTot |

### Fórmula

```
vIBSUF = vBC × pIBSUF
vIBSMun = vBC × pIBSMun
vIBS = vIBSUF + vIBSMun
vCBS = vBC × pCBS
```

### Regras 2026

- Valores **NÃO integram totais da NF-e** (informativos)
- **NÃO aparecem no DANFE** (somente XML)
- Rejeição por omissão desativada (v1.33/v1.34)
- 16 novos eventos autorizados via SVRS

### NFS-e Nacional

- Obrigatória para todos os 5.570 municípios desde 01/01/2026
- NT 004 e NT 005 incluem campos IBS/CBS
- API padronizada nacional

---

## 16. CST e cClassTrib — Tabelas Oficiais

### CST IBS/CBS (3 dígitos)

| Código | Descrição |
|--------|-----------|
| 000 | Tributação integral |
| 010 | Monofásica (alíquotas uniformes) |
| 011 | Monofásica (variação) |
| 020 | Alíquota reduzida |
| 030 | Diferida |
| 040 | Suspensa |
| 050 | Crédito presumido |
| 060 | Regime específico |
| 200 | Alíquota zero / reduzida a zero |
| 300 | Não tributada |
| 400 | Isenção |
| 410 | Imunidade e não incidência |
| 500 | Outros regimes |

### cClassTrib

Detalha a natureza da operação. Os 3 primeiros dígitos são idênticos ao CST. Tabela oficial disponível em:
- Portal da Conformidade Fácil (SVRS)
- Portal NF-e → aba "Documentos" → "Diversos"

### cCredPres

Tabela complementar para classificar tipo de crédito presumido.

---

## 17. CFOP, NCM e CEST

| Item | Status na Reforma |
|------|-------------------|
| **CFOP** | Continua existindo, mas perde protagonismo. `cClassTrib` assume papel central |
| **NCM** | **Ganha importância** — critério para alíquotas diferenciadas e Anexos da LC 214 |
| **CEST** | Continua durante transição (ST), extinto após 2033 |

---

## 18. Obrigações Acessórias

### Extintas

| Obrigação | Status |
|-----------|--------|
| DCTF Mensal (PGD) | Extinta, unificada com DCTFWeb |
| DIRF | Extinta (eSocial + EFD-Reinf) |
| EFD-Contribuições | Descontinuada em 2027 (NT 011/2026) |
| GIA | Extinção gradual com ICMS |

### Mantidas (com adaptações)

| Obrigação | Status |
|-----------|--------|
| DCTFWeb | Absorveu DCTF |
| EFD-ICMS/IPI | Mantida, leiaute 020. CBS/IBS **NÃO escriturados** nela |
| EFD-Reinf | Mantida e ampliada |
| eSocial | Mantido |

### Novas

- Apuração assistida de CBS (a partir de 2027)
- Sistema de Apuração do IBS (em piloto pelo CGIBS)
- Destaque obrigatório em todos os DF-e (NF-e, NFC-e, NFS-e, CT-e, NFCom, NF3e, BP-e)

---

## 19. Comitê Gestor do IBS (CGIBS)

- Instituído pela LC 227/2026
- Portal em operação desde 13/01/2026: https://www.cgibs.gov.br
- Plataforma digital com capacidade de 200 milhões de operações/dia
- Calculadora tributária integrada
- Publica tabelas de alíquotas e códigos oficiais
- Piloto do Sistema de Apuração do IBS em andamento

---

## 20. Créditos Tributários IBS/CBS

- **Crédito financeiro integral** — qualquer aquisição tributada gera crédito
- **Prazo:** 5 anos a partir da data de apuração
- **Ressarcimento:** 60 dias (≤150% média 24m), 30 dias (conformidade), 180 dias (demais)
- **Transferência entre filiais:** NÃO prevista (diferente do ICMS)
- **Créditos PIS/COFINS remanescentes:** utilizáveis por 5 anos após extinção
- **Exportadores:** mantêm créditos integrais (ressarcíveis)

---

## 21. DIFAL e ICMS-ST

### DIFAL

- Continua até 2032, extinto com ICMS em 2033
- IBS já nasce no destino → elimina lógica do DIFAL

### FCP

- Adicional até 2%, recolhimento somente UF destino
- Extinto com ICMS

### Substituição Tributária (ICMS-ST)

- Extinção progressiva 2029-2032, total em 2033
- ERP deve manter toda lógica ST durante transição

---

## 22. Tributação Monofásica

| Produto | Regime |
|---------|--------|
| Combustíveis | Ad rem (R$/litro), uniforme nacional |
| Cigarros e fumígenos | IS até 250% |
| Bebidas alcoólicas | IS entre 46% e 62% |
| Refrigerantes/açucaradas | IS de 32% |

- Incidência concentrada na produção/importação
- Combustíveis de revenda: sem crédito (Art. 180)
- Combustíveis como insumo (transporte, indústria): geram crédito

---

## 23. Devolução e Bonificação

- **Devolução:** mesma alíquota da operação original
- **Bonificação incondicional:** não tributada (redução do preço unitário)
- **Bonificação condicional:** tributada normalmente

---

## 24. Penalidades e Multas

- **Período de tolerância:** até 4° mês após regulamentos, sem multas
- **UPF** = R$ 200 (atualizada anualmente)
- Não inscrição no cadastro: 10 UPF = R$ 2.000
- Regime Especial de Fiscalização: multas em dobro

---

## 25. Lucro Real e Presumido (LC 224/2025)

A reforma do consumo **NÃO altera** IRPJ/CSLL. Porém:

| Mudança | Detalhe | Vigência |
|---------|---------|----------|
| Coeficientes lucro presumido | +10% sobre receita > R$ 5M | IRPJ: 01/01/2026 |
| JCP (Juros sobre Capital Próprio) | IRRF: 15% → **17,5%** | 01/01/2026 |
| Benefícios fiscais | Redução linear de 10% | Variável |

---

## 26. Retenções na Fonte

- Retenções tradicionais (IRRF, INSS, CSLL, PIS/COFINS retidos) **permanecem ativas**
- Split payment substitui a lógica de retenção para IBS/CBS
- ERP deve manter retenções tradicionais + split payment (a partir de 2027)

---

## 27. Imunidades e Isenções

| Operação/Entidade | Imune? |
|-------------------|--------|
| Exportações | Sim (com manutenção de créditos) |
| Templos | Sim |
| Partidos políticos | Sim |
| Sindicatos de trabalhadores | Sim |
| Educação sem fins lucrativos | Sim (Art. 14 CTN) |
| Assistência social sem fins lucrativos | Sim |
| Livros, jornais, periódicos | Sim |

**Limitação:** imunidades não se estendem às aquisições (paga IBS/CBS nas compras).

---

## 28. ITCMD e IPVA

### ITCMD (EC 132 + LC 227/2026)

| Aspecto | Antes | Depois |
|---------|-------|--------|
| Progressividade | Opcional | **Obrigatória** (2% a 8%) |
| Base de cálculo | Valor histórico | **Valor de mercado** |
| Bens no exterior | Não tributados | **Tributados** |
| Trusts | Sem regulamentação | **Regulamentados** |

### IPVA (EC 132/2023)

| Aspecto | Antes | Depois |
|---------|-------|--------|
| Veículos | Apenas terrestres | **Inclui aeronaves e embarcações** |
| Alíquotas | Única por estado | Diferenciadas por impacto ambiental |

---

## 29. Certificado Digital

- ICP-Brasil continua
- Novos modelos: Selo Eletrônico (SE-S software, SE-H hardware)
- Encerramento A1/A3 cadeia V10 em 31/12/2026

---

## 30. Escrituração Fiscal Digital (SPED)

### EFD ICMS/IPI

- Novo leiaute 020 desde 01/01/2026
- CBS/IBS/IS **NÃO escriturados** na EFD ICMS/IPI

### EFD-Contribuições

- **Descontinuada** para novos fatos geradores a partir de janeiro/2027
- Manter/retificar por mínimo 5 anos
- Créditos PIS/COFINS remanescentes devem estar escriturados

### Nova Escrituração IBS/CBS

- Em 2026: apuração via documentos fiscais eletrônicos
- Nova obrigação acessória específica esperada para 2027+

---

## 31. Impacto no OpticalCore — Plano de Implementação

### Estado Atual do Módulo Fiscal

- ConfiguracaoFiscal já possui campos: AliquotaCbsDefault, AliquotaIbsDefault, AliquotaIsDefault, CstCbsDefault, CstIbsDefault, CstIsDefault
- NotaFiscalItemImposto com TipoImposto extensível
- RegraTributaria com RegraTributariaImposto
- 8 domínios fiscais existentes

### Fase 1 — Estrutura Base (Imediata, para 2026)

| Item | Descrição |
|------|-----------|
| Novos domínios | CstCbs, CstIbs, CstIs, ClassificacaoTributaria (cClassTrib) |
| Alíquotas por município | Entidade AliquotaIbsMunicipio (UF, Município, código IBGE, AlíquotaUf, AlíquotaMun) |
| RegraTributariaImposto | Expandir TipoImposto com CBS, IBS_UF, IBS_MUN, IS |
| NotaFiscal | Novos totais: ValorTotalCbs, ValorTotalIbsUf, ValorTotalIbsMun, ValorTotalIs |
| NotaFiscalItem | Campos para CST IBS/CBS, cClassTrib |
| TaxCalculationService | Motor de cálculo IVA Dual |
| Motor híbrido | Calcular tributos antigos E novos simultaneamente |
| Produto | Flag regime tributário (padrão, -60%, -30%, zero, específico, monofásico) |

### Fase 2 — NF-e e XML (2026-2027)

| Item | Descrição |
|------|-----------|
| Grupo UB | Gerar no XML: gIBSCBS, gIBSUF, gIBSMun, gCBS, IBSCBSTot |
| Validações | Regras por ano (2026 informativo, 2027+ obrigatório) |
| DANFE | Em 2026: NÃO exibir IBS/CBS. Futuramente: sim |
| NFS-e | Adequação ao modelo nacional |

### Fase 3 — CBS Plena e Split Payment (2027)

| Item | Descrição |
|------|-----------|
| CBS plena | Substituição de PIS/COFINS no motor de cálculo |
| IS | Cálculo do Imposto Seletivo |
| ApuracaoCbs | Nova entidade e service de apuração mensal |
| Split Payment | Campos na NF-e, integração financeira |
| Cashback CBS | Campos para operações elegíveis |

### Fase 4 — Transição ICMS/ISS → IBS (2029-2032)

| Item | Descrição |
|------|-----------|
| Proporções anuais | Tabela de % IBS vs ICMS/ISS por ano |
| Extinção progressiva ST | Reduzir ST acompanhando ICMS |
| ApuracaoIbs | Nova entidade de apuração mensal |
| Cashback IBS | Desde 2029 |

### Fase 5 — Sistema Final (2033)

| Item | Descrição |
|------|-----------|
| Extinção total | Remover ICMS, ISS, DIFAL, FCP, ST do motor |
| Sistema 100% IVA | Apenas CBS + IBS + IS |

---

## Fontes Principais

- [LC 214/2025 — Texto Integral](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp214.htm)
- [LC 227/2026 — Texto Integral](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp227.htm)
- [LC 224/2025 — Texto Integral](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp224.htm)
- [Portal CGIBS](https://www.cgibs.gov.br)
- [Portal NF-e — NT 2025.002](https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY%3D)
- [Receita Federal — Reforma do Consumo](https://www.gov.br/receitafederal/pt-br/acesso-a-informacao/acoes-e-programas/programas-e-atividades/reforma-consumo/entenda)
- [TOTVS — Espaço Legislação](https://espacolegislacao.totvs.com/reforma-tributaria/)
- [Tax Group — Guia 2026](https://www.taxgroup.com.br/intelligence/reforma-tributaria-2026-guia-completo-sobre-o-que-muda-e-a-transicao/)
- [Tecnospeed — NT 2025.002](https://blog.tecnospeed.com.br/nota-tecnica-reforma-tributaria-nfe-nfce/)
- [Thomson Reuters — IVA Dual](https://www.thomsonreuters.com.br/pt/reforma-tributaria/iva-dual.html)
- [SimTax — Cronograma](https://simtax.com.br/transicao-icms-para-ibs-2029-2032/)
- [Jettax — Fases 2026-2033](https://www.jettax.com.br/blog/cronograma-e-fases-da-reforma-tributaria-de-2026-a-2033/)
