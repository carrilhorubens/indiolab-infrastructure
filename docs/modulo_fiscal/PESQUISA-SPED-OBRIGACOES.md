# Pesquisa Completa: SPED e Obrigações Acessórias para ERP

> Pesquisa realizada em 02/03/2026 — Dados atualizados para 2025/2026.

---

## Sumário

1. [Visão Geral do SPED](#1-visão-geral-do-sped)
2. [SPED Fiscal (EFD-ICMS/IPI)](#2-sped-fiscal-efd-icmsipi)
3. [EFD-Contribuições (PIS/COFINS)](#3-efd-contribuições-piscofins)
4. [ECD (Escrituração Contábil Digital)](#4-ecd-escrituração-contábil-digital)
5. [ECF (Escrituração Contábil Fiscal)](#5-ecf-escrituração-contábil-fiscal)
6. [EFD-Reinf](#6-efd-reinf)
7. [DCTFWeb e MIT](#7-dctfweb-e-mit)
8. [DIRF, DCTF, DEFIS e Outras Obrigações](#8-dirf-dctf-defis-e-outras-obrigações)
9. [Formato dos Arquivos SPED](#9-formato-dos-arquivos-sped)
10. [Multas e Penalidades](#10-multas-e-penalidades)
11. [Mapeamento: Módulos ERP x Obrigações](#11-mapeamento-módulos-erp-x-obrigações)
12. [Reforma Tributária (CBS/IBS) — Impacto 2026+](#12-reforma-tributária-cbsibs--impacto-2026)
13. [Recomendações de Implementação](#13-recomendações-de-implementação)

---

## 1. Visão Geral do SPED

O **Sistema Público de Escrituração Digital (SPED)** foi instituído pelo Decreto nº 6.022/2007 e é composto por diversos subprojetos que digitalizam obrigações fiscais, contábeis e previdenciárias das empresas brasileiras.

### Componentes do SPED

| Componente | Sigla | Periodicidade | Foco |
|---|---|---|---|
| SPED Fiscal | EFD-ICMS/IPI | Mensal | ICMS e IPI |
| EFD-Contribuições | EFD-PIS/COFINS | Mensal | PIS e COFINS |
| SPED Contábil | ECD | Anual | Livros contábeis |
| Escrituração Contábil Fiscal | ECF | Anual | IRPJ e CSLL |
| EFD-Reinf | Reinf | Mensal | Retenções na fonte |
| NF-e / NFC-e / NFS-e | DFe | Tempo real | Documentos fiscais eletrônicos |
| CT-e | CT-e | Tempo real | Conhecimento de transporte |
| DCTFWeb | DCTFWeb | Mensal | Débitos e créditos tributários |

### Formato Padrão

Todos os arquivos SPED seguem o padrão:
- **Formato**: Arquivo texto (`.txt`)
- **Codificação**: ASCII ISO 8859-1 (Latin-1)
- **Delimitador**: Pipe `|` (caractere barra vertical)
- **Final de linha**: CR+LF
- **Estrutura**: Hierárquica de registros (pai-filho)
- **Transmissão**: Via PVA (Programa Validador e Assinador) + ReceitaNet
- **Assinatura**: Certificado digital A1 ou A3 (e-CNPJ ou e-CPF)

---

## 2. SPED Fiscal (EFD-ICMS/IPI)

### 2.1 Conceito e Obrigatoriedade

A **Escrituração Fiscal Digital do ICMS e IPI** substitui os livros fiscais em papel (Registro de Entradas, Registro de Saídas, Registro de Inventário, Registro de Apuração do ICMS, Registro de Apuração do IPI, Controle de Crédito de ICMS do Ativo Permanente — CIAP e Controle de Produção e Estoque).

- **Periodicidade**: Mensal
- **Prazo de entrega**: Até o dia 15 do mês subsequente ao período de referência (varia por estado)
- **Versão atual**: Guia Prático v3.2.1 (vigência a partir de 01/01/2026, Leiaute 020)
- **Programa**: PVA-EFD ICMS/IPI
- **Transmissão**: ReceitaNet (com certificado digital)

### 2.2 Perfis de Enquadramento

Os fiscos estaduais determinam o enquadramento dos contribuintes:

| Perfil | Detalhamento | Observação |
|---|---|---|
| **A** | Mais detalhado | Registros analíticos item a item |
| **B** | Intermediário | Consolidação por documento |
| **C** | Mais sintético | Consolidação máxima |

O perfil afeta quais registros são obrigatórios. Perfil A exige maior granularidade de dados.

### 2.3 Blocos e Registros

#### Bloco 0 — Abertura, Identificação e Referências

Contém dados cadastrais do contribuinte, tabelas de referência, cadastro de participantes, produtos e itens.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **0000** | Abertura do arquivo digital | CNPJ, IE, período, razão social, UF |
| **0001** | Abertura do Bloco 0 | Indicador de movimento |
| **0002** | Classificação do estabelecimento industrial | Código CNAE, tipo de atividade |
| **0005** | Dados complementares da entidade | Endereço, CEP, telefone, e-mail |
| **0015** | Dados do contribuinte substituto | IE do substituto tributário (por UF) |
| **0100** | Dados do contabilista | CRC, CNPJ/CPF do contador |
| **0150** | Tabela de cadastro do participante | Clientes e fornecedores: CNPJ/CPF, nome, endereço |
| **0190** | Identificação das unidades de medida | Tabela de unidades de medida do sistema |
| **0200** | Tabela de identificação do item | Produtos: código, descrição, NCM, tipo, unidade |
| **0205** | Alteração do item | Histórico de alterações do cadastro de produtos |
| **0206** | Código produto ANP | Código ANP para combustíveis |
| **0220** | Fatores de conversão de unidades | Conversão entre unidades de medida |
| **0300** | Cadastro de bens ou componentes do ativo imobilizado | Bens do ativo permanente (para Bloco G) |
| **0305** | Informação sobre utilização do bem | Tipo de utilização no processo |
| **0400** | Tabela de natureza da operação/prestação | CFOPs utilizados |
| **0450** | Tabela de informação complementar do documento fiscal | Textos de informação complementar |
| **0460** | Tabela de observações do lançamento fiscal | Textos de observação |
| **0500** | Plano de contas contábeis | Plano de contas (integração contábil) |
| **0600** | Centro de custos | Cadastro de centros de custo |
| **0990** | Encerramento do Bloco 0 | Quantidade de registros |

**Módulos ERP alimentadores**: Cadastros (Pessoas, Produtos), Contabilidade, Patrimônio.

---

#### Bloco C — Documentos Fiscais (Mercadorias — ICMS/IPI)

Registra todos os documentos fiscais de entrada e saída de mercadorias e produtos.

| Registro | Descrição | Modelo NF | Dados do ERP |
|---|---|---|---|
| **C100** | Documento — NF/NF-e | 01, 1B, 04, 55, 65 | NF-e: chave, CNPJ, valores ICMS/IPI, frete |
| **C101** | Informação complementar (FCP) | 55 | Fundo de Combate à Pobreza |
| **C110** | Informação complementar da NF | Diversos | Textos complementares |
| **C120** | Operações de importação | 01, 55 | DI, data registro, local desembaraço |
| **C170** | Itens do documento | 01, 1B, 04, 55 | Código produto, quantidade, NCM, CFOP, CST, valores |
| **C176** | Ressarcimento ICMS-ST | — | Valores de ressarcimento |
| **C190** | Registro analítico do documento | 01, 1B, 04, 55, 65 | Consolidação por CST+CFOP+alíquota |
| **C300** | Resumo diário — NF Venda a Consumidor | 02 | Consolidação diária |
| **C400** | Equipamento ECF | 02, 2D, 60 | Número série ECF, modelo |
| **C405** | Redução Z | 02, 2D | Totalizadores diários |
| **C420** | Registro dos totalizadores parciais da Redução Z | — | Detalhes dos totalizadores |
| **C425** | Resumo de itens do movimento diário | — | Consolidação por produto |
| **C460** | Documento fiscal emitido por ECF | 02, 2D | Cupom fiscal individual |
| **C470** | Itens do documento fiscal emitido por ECF | — | Itens de cada cupom |
| **C500** | NF/Conta de Energia/Água/Gás | 06, 28, 29 | Documentos de utilidades |
| **C600** | Consolidação diária (energia/água/gás) | 06, 28, 29 | Resumo diário |
| **C700** | Consolidação dos documentos — NF/Conta | 06, 28, 29 | Consolidação por municio |
| **C800** | Cupom Fiscal Eletrônico — SAT (CF-e-SAT) | 59 | Dados do cupom |
| **C860** | Identificação do equipamento SAT | 59 | Série SAT |

**Módulos ERP alimentadores**: Vendas (NF-e de saída), Compras (NF-e de entrada), PDV (cupom fiscal), Estoque.

---

#### Bloco D — Documentos Fiscais (Serviços — ICMS)

Documentos de prestação de serviços de transporte e comunicação.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **D100** | NF de serviço de transporte / CT-e | CT-e: chave, valores, CFOP |
| **D110** | Itens do documento — serviço de transporte | Detalhes dos itens |
| **D120** | Complemento do CT-e | Municípios de origem/destino |
| **D190** | Registro analítico dos documentos | Consolidação CST+CFOP+alíquota |
| **D300** | Resumo diário — Bilhetes consolidados | Passagens, bilhetes |
| **D500** | NF de serviço de comunicação/telecomunicação | Telecomunicações |
| **D600** | Consolidação diária — comunicação/telecom | Resumo diário |

**Módulos ERP alimentadores**: Compras (frete), Logística, Financeiro (telecomunicações).

---

#### Bloco E — Apuração do ICMS e IPI

O bloco de apuração é o "coração fiscal" da EFD.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **E100** | Período da apuração do ICMS | Datas início/fim do período |
| **E110** | Apuração do ICMS — Operações Próprias | Débitos, créditos, saldo credor, imposto a recolher |
| **E111** | Ajuste/benefício/incentivo da apuração ICMS | Valores de ajuste |
| **E112** | Informações adicionais dos ajustes | Detalhes complementares |
| **E113** | Informações adicionais dos ajustes — documentos | Documentos vinculados |
| **E115** | Informações adicionais da apuração ICMS — Valores declaratórios | Valores informativos |
| **E116** | Obrigações do ICMS recolhido ou a recolher | Guias de recolhimento |
| **E200** | Período da apuração do ICMS — Substituição Tributária | Datas início/fim |
| **E210** | Apuração do ICMS — Substituição Tributária | Débitos/créditos de ST |
| **E220** | Ajuste/benefício da apuração ICMS-ST | Ajustes de ST |
| **E250** | Obrigações do ICMS-ST recolhido ou a recolher | Guias de recolhimento ST |
| **E300** | Período de apuração do ICMS — Diferencial de Alíquota (UF destino/EC 87/15) | Datas |
| **E310** | Apuração do ICMS-DIFAL | Valores do diferencial |
| **E500** | Período de apuração do IPI | Datas do período IPI |
| **E510** | Consolidação dos valores do IPI | Consolidação por CFOP |
| **E520** | Apuração do IPI | Débitos, créditos, saldo IPI |

**Módulos ERP alimentadores**: Fiscal (apuração de impostos), Vendas, Compras, Financeiro (guias de recolhimento).

---

#### Bloco G — CIAP (Controle de Crédito de ICMS do Ativo Permanente)

Demonstra o cálculo da parcela mensal do crédito de ICMS apropriado, decorrente de aquisição de bens para o ativo imobilizado.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **G001** | Abertura do Bloco G | Indicador de movimento |
| **G110** | ICMS — Ativo Permanente — CIAP | Saldo inicial, parcelas, fator, crédito apropriado |
| **G125** | Movimentação de bem do ativo imobilizado | Tipo movimentação, valor ICMS, parcela |
| **G126** | Outros créditos CIAP | Valores adicionais |
| **G130** | Identificação do documento fiscal | NF vinculada ao bem |
| **G140** | Identificação do item do documento fiscal | Item da NF (produto/bem) |

**Cálculo**: Crédito mensal = (ICMS do bem / 48 meses) x (saídas tributadas / total de saídas)

**Módulos ERP alimentadores**: Patrimônio (Ativo Imobilizado), Compras, Fiscal, Contabilidade.

---

#### Bloco H — Inventário Físico

Informa o inventário físico do estabelecimento (posição de estoques).

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **H001** | Abertura do Bloco H | Indicador de movimento |
| **H005** | Totais do inventário | Data do inventário, valor total, motivo |
| **H010** | Inventário | Código item, unidade, quantidade, valor unitário, valor total |
| **H020** | Informação complementar do inventário | Complementos (motivos 02 a 05) |
| **H030** | Informações complementares — ST | Dados de substituição tributária |

**Motivos do inventário (campo MOT_INV)**:
| Código | Motivo |
|---|---|
| 01 | No final do período |
| 02 | Na mudança de forma de tributação da mercadoria |
| 03 | Na solicitação da baixa cadastral, paralisação temporária e outras situações |
| 04 | Na alteração de regime de pagamento (condição do contribuinte) |
| 05 | Por determinação dos fiscos |
| 06 | Para controle das mercadorias sujeitas ao regime de ST — Loss/Inventory |

**Periodicidade**: Obrigatório no mínimo anualmente (fevereiro, referente a 31/12 do ano anterior). Pode ser mensal dependendo da legislação estadual.

**Módulos ERP alimentadores**: Estoque (posição de saldo, inventário físico), Cadastro de Produtos.

---

#### Bloco K — Controle da Produção e do Estoque

Registra a escrituração mensal da produção e respectivo consumo de insumos, bem como do estoque escriturado.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **K001** | Abertura do Bloco K | Indicador de movimento |
| **K010** | Informação sobre o tipo de leiaute (completo/simplificado) | Tipo de escrituração |
| **K100** | Período de apuração do ICMS/IPI | Datas início/fim |
| **K200** | Estoque escriturado | Código item, quantidade, tipo proprietário/posse |
| **K210** | Desmontagem de mercadorias — Item de origem | Produto desmontado |
| **K215** | Desmontagem de mercadorias — Item de destino | Itens resultantes |
| **K220** | Outras movimentações internas entre mercadorias | Transferências internas |
| **K230** | Itens produzidos — Ordem de produção | Produto acabado, quantidade |
| **K235** | Insumos consumidos — Ordem de produção | Matérias-primas consumidas |
| **K250** | Industrialização efetuada por terceiros — Itens produzidos | Produção terceirizada |
| **K255** | Industrialização em terceiros — Insumos consumidos | Insumos da terceirização |
| **K260** | Reprocessamento/reparo de produto/insumo | Item reprocessado |
| **K265** | Reprocessamento/reparo — Insumos consumidos/retornados | Insumos do reprocesso |
| **K270** | Correção de apontamento — Itens produzidos | Ajustes de produção |
| **K275** | Correção de apontamento — Insumos consumidos | Ajustes de consumo |
| **K280** | Correção de apontamento — Estoque escriturado | Ajustes de saldo |
| **K290** | Produção conjunta — Ordem de produção | Produção conjunta |
| **K291** | Produção conjunta — Itens produzidos | Itens da produção conjunta |
| **K292** | Produção conjunta — Insumos consumidos | Insumos da produção conjunta |
| **K300** | Produção conjunta — Industrialização por terceiros | Terceirização conjunta |
| **K301/K302** | Itens produzidos e insumos consumidos (terceirização conjunta) | Detalhes |

**Obrigatoriedade escalonada** (Ajuste SINIEF 25/2016):
- **Janeiro/2017**: Estabelecimentos industriais CNAE 10 a 32 (escrituração simplificada — K200 e K280)
- **Janeiro/2019**: Escrituração completa (todos os registros K) para grandes estabelecimentos industriais
- Obrigatoriedade depende do faturamento e do CNAE

**Tipos de estoque escriturado (K200)**:
| Código | Tipo |
|---|---|
| 0 | Estoque de propriedade do informante e em seu poder |
| 1 | Estoque de propriedade do informante e em posse de terceiros |
| 2 | Estoque de propriedade de terceiros e em posse do informante |

**Módulos ERP alimentadores**: Estoque (saldos, movimentações), Produção/PCP (ordens de produção, BOM), Compras (industrialização por terceiros).

---

#### Bloco 1 — Outras Informações

Informações complementares exigidas por legislação específica.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **1001** | Abertura do Bloco 1 | Indicador de movimento |
| **1010** | Obrigatoriedade de registros do Bloco 1 | Indicadores S/N para cada sub-bloco |
| **1100** | Registro de informações sobre exportação | Dados de exportação |
| **1200** | Controle de créditos fiscais — ICMS | Saldo de créditos acumulados |
| **1210** | Utilização de créditos fiscais — ICMS | Aplicação dos créditos |
| **1300** | Movimentação diária de combustíveis (postos) | Tanques, bombas |
| **1310** | Movimentação diária de combustíveis por tanque | Litros por tanque |
| **1320** | Volume de vendas | Litros vendidos |
| **1350-1370** | Bombas, lacres, bicos | Equipamentos de abastecimento |
| **1390** | Controle de produção de usina | Produção de usinas |
| **1400** | Informação sobre valores agregados | DIPAM/valores agregados por município |
| **1500** | Nota fiscal/Conta de energia — operações interestaduais | Energia interestadual |
| **1600** | Total das operações com cartão de crédito/débito | Valores por administradora de cartão |
| **1700** | Documentos fiscais utilizados | Numeração de documentos |
| **1710** | Documentos fiscais cancelados/inutilizados | Cancelamentos |
| **1800** | DCTA — Demonstrativo de crédito do ICMS sobre transporte aéreo | Transporte aéreo |
| **1900** | Indicador de sub-apuração do ICMS | Sub-apurações especiais |

**Módulos ERP alimentadores**: Financeiro (cartões), Vendas (exportação), Estoque (combustíveis), Fiscal (créditos).

---

#### Bloco 9 — Controle e Encerramento do Arquivo

| Registro | Descrição |
|---|---|
| **9001** | Abertura do Bloco 9 |
| **9900** | Registros do arquivo (contagem por tipo) |
| **9990** | Encerramento do Bloco 9 |
| **9999** | Encerramento do arquivo digital |

---

### 2.4 Dados Necessários do ERP para EFD-ICMS/IPI

| Módulo ERP | Dados Necessários |
|---|---|
| **Cadastros** | Empresas (CNPJ, IE, endereço), Clientes, Fornecedores, Produtos (NCM, código interno, unidade), Contador |
| **Vendas** | NF-e de saída (itens, valores, ICMS, IPI, CFOP, CST), Cupom fiscal |
| **Compras** | NF-e de entrada (itens, valores, créditos ICMS/IPI), Importações (DI) |
| **Estoque** | Posição de estoque (inventário), Movimentações, Custo médio/último custo |
| **Produção** | Ordens de produção, BOM, Consumo de insumos, Industrialização por terceiros |
| **Patrimônio** | Ativo imobilizado (bens, NF entrada, valor ICMS, parcelas CIAP) |
| **Fiscal** | Apuração ICMS, Apuração IPI, Substituição tributária, Ajustes, Guias de recolhimento |
| **Financeiro** | Operações com cartão de crédito/débito (Registro 1600) |
| **Contabilidade** | Plano de contas, Centros de custo |

---

## 3. EFD-Contribuições (PIS/COFINS)

### 3.1 Conceito e Obrigatoriedade

A **Escrituração Fiscal Digital das Contribuições** incidentes sobre a receita (PIS/Pasep e Cofins) e da Contribuição Previdenciária sobre a Receita Bruta (CPRB).

- **Periodicidade**: Mensal
- **Prazo de entrega**: Até o 10o dia útil do 2o mês subsequente ao período de referência
- **Obrigatória para**: Pessoas jurídicas de direito privado (Lucro Real e Lucro Presumido)
- **Dispensa**: Simples Nacional, imunes e isentas (com receita bruta mensal <= R$ 10.000), MEI
- **Versão atual**: Guia Prático versão 1.35+
- **Transmissão**: PVA-EFD Contribuições + ReceitaNet

### 3.2 Regimes de Apuração

| Aspecto | Regime Cumulativo | Regime Não-Cumulativo |
|---|---|---|
| **Tributação** | Lucro Presumido | Lucro Real |
| **Alíquota PIS** | 0,65% | 1,65% |
| **Alíquota COFINS** | 3,00% | 7,60% |
| **Direito a crédito** | NÃO | SIM |
| **Base de cálculo** | Faturamento | Receita total |
| **Blocos utilizados** | F500/F510 (consolidado) | Blocos A, C, D, F (analítico) |
| **Apuração** | Bloco M (simplificado) | Bloco M (detalhado com créditos) |

### 3.3 Blocos e Registros

#### Bloco 0 — Abertura, Identificação e Referências

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **0000** | Abertura do arquivo digital | CNPJ, regime tributário, período |
| **0001** | Abertura do Bloco 0 | Indicador de movimento |
| **0100** | Dados do contabilista | CRC, CNPJ/CPF |
| **0110** | Regimes de apuração da contribuição social | Cumulativo, não-cumulativo, CPRB |
| **0111** | Tabela de receita bruta mensal | Receita cumulativa e não-cumulativa |
| **0120** | Identificação de EFD-Contribuições sem dados | Períodos sem movimento |
| **0140** | Tabela de cadastro de estabelecimento | Filiais (CNPJ, IE) |
| **0150** | Tabela de cadastro do participante | Clientes e fornecedores |
| **0190** | Identificação das unidades de medida | Tabela de UMs |
| **0200** | Tabela de identificação do item | Produtos/serviços com NCM |
| **0400** | Tabela de natureza da operação/prestação | CFOPs |
| **0450** | Tabela de informação complementar | Textos complementares |
| **0500** | Plano de contas contábeis | Integração contábil |
| **0600** | Centro de custos | Centros de custo |

---

#### Bloco A — Documentos Fiscais — Serviços (ISS)

Operações de prestação e contratação de serviços não escrituradas nos Blocos C, D e F.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **A010** | Identificação do estabelecimento | CNPJ do estabelecimento |
| **A100** | Documento — NFS-e | NFS emitida/recebida, valores PIS/COFINS |
| **A110** | Complemento do documento — informação complementar | Textos complementares |
| **A120** | Complemento do documento — operações de importação | Dados de importação de serviços |
| **A170** | Complemento do documento — Itens do documento | Itens de serviço, CST, base PIS/COFINS |

---

#### Bloco C — Documentos Fiscais — Mercadorias (ICMS/IPI)

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **C010** | Identificação do estabelecimento | CNPJ, indicador crédito |
| **C100** | Documento — NF/NF-e de entrada e saída | Chave NF-e, valores, participante |
| **C110** | Complemento do documento — informação complementar | Textos |
| **C120** | Complemento do documento — operações de importação | DI, data registro |
| **C170** | Complemento do documento — Itens do documento | Código produto, quantidade, NCM, CST PIS/COFINS, valores |
| **C175** | Registro analítico NF-e (código 55) — Operações de aquisição com crédito | Resumo de créditos |
| **C180** | Consolidação de NF-e emitidas (código 55) — Operações de vendas | Consolidação de saídas |
| **C181** | Detalhamento da consolidação — PIS/Pasep | Por CST, base, alíquota |
| **C185** | Detalhamento da consolidação — COFINS | Por CST, base, alíquota |
| **C190** | Consolidação de NF-e (código 55) — Operações de aquisição | Consolidação de entradas |
| **C191** | Detalhamento da consolidação — PIS/Pasep (créditos) | Créditos por CST |
| **C195** | Detalhamento da consolidação — COFINS (créditos) | Créditos por CST |
| **C380** | NF de venda a consumidor em lote (código 02) | Consolidação |
| **C395** | Detalhamento da consolidação — Cupom Fiscal | Detalhes por item |
| **C400** | Equipamento ECF (códigos 02 e 2D) | Série ECF |
| **C489** | Processo referenciado | Processos judiciais |
| **C490** | Consolidação de documentos emitidos por ECF | Consolidação diária |
| **C491** | Detalhamento PIS — ECF | Valores PIS |
| **C495** | Detalhamento COFINS — ECF | Valores COFINS |
| **C500** | NF/Conta de energia elétrica, gás e água | Utilidades |
| **C501** | Complemento — PIS/Pasep | Crédito de PIS sobre utilidades |
| **C505** | Complemento — COFINS | Crédito de COFINS sobre utilidades |
| **C600** | Consolidação diária (energia, gás, água) | Resumo diário |
| **C601** | Complemento PIS — Energia | Valores PIS |
| **C605** | Complemento COFINS — Energia | Valores COFINS |
| **C800** | Cupom Fiscal Eletrônico — SAT (CF-e-SAT) | Dados SAT |
| **C810** | Detalhamento CF-e-SAT — PIS | Valores PIS SAT |
| **C820** | Detalhamento CF-e-SAT — COFINS | Valores COFINS SAT |
| **C860** | Identificação do equipamento SAT | Série equipamento |
| **C870** | Resumo diário — SAT — PIS | Totais PIS SAT |
| **C880** | Resumo diário — SAT — COFINS | Totais COFINS SAT |

---

#### Bloco D — Documentos Fiscais — Serviços (ICMS)

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **D010** | Identificação do estabelecimento | CNPJ |
| **D100** | Aquisição de serviços de transporte — CT-e | CT-e, valores |
| **D101** | Complemento — PIS/Pasep | Crédito PIS sobre frete |
| **D105** | Complemento — COFINS | Crédito COFINS sobre frete |
| **D200** | Resumo da escrituração diária — Prestação de serviços de transporte | Consolidação |
| **D201** | Totalização PIS | Valores PIS |
| **D205** | Totalização COFINS | Valores COFINS |
| **D300** | Resumo — Bilhetes consolidados de passagem | Passagens |
| **D309** | Processo referenciado | Processos |
| **D350** | Resumo — Equipamento ECF (Bilhetes) | ECF bilhetes |
| **D500** | NF de serviço de comunicação/telecom | Telecom |
| **D501** | Complemento PIS | Crédito PIS telecom |
| **D505** | Complemento COFINS | Crédito COFINS telecom |
| **D600** | Consolidação diária — Comunicação | Resumo diário |
| **D601** | Complemento PIS | Valores PIS |
| **D605** | Complemento COFINS | Valores COFINS |

---

#### Bloco F — Demais Documentos e Operações

Operações geradoras de contribuição/crédito não escrituradas nos Blocos A, C e D.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **F010** | Identificação do estabelecimento | CNPJ |
| **F100** | Demais documentos e operações geradoras de contribuição e créditos | Receitas financeiras, aluguéis, aplicações financeiras, depreciação, contratos de serviço |
| **F120** | Bens incorporados ao ativo imobilizado — Créditos com base em depreciação | Bens do imobilizado, encargos de depreciação |
| **F130** | Bens incorporados ao ativo imobilizado — Créditos com base no valor de aquisição | Valor de aquisição dos bens |
| **F150** | Crédito presumido sobre estoque de abertura | Estoque na data de adesão ao não-cumulativo |
| **F200** | Operações da atividade imobiliária | Receitas imobiliárias |
| **F205** | Custo incorrido — Atividade imobiliária | Custos de empreendimentos |
| **F210** | Operações da atividade imobiliária — Custo orçado | Custos orçados |
| **F500** | Consolidação das operações — Regime cumulativo | **Para Lucro Presumido**: consolidação por CST |
| **F509** | Processo referenciado | Processos judiciais |
| **F510** | Consolidação das operações — Regime cumulativo (detalhamento PIS) | Detalhes PIS |
| **F525** | Composição da receita escriturada no período — Detalhamento | Receita detalhada por natureza |
| **F550** | Consolidação das operações — Regime não-cumulativo | **Para Lucro Real**: consolidação por CST |
| **F559** | Processo referenciado | Processos |
| **F560** | Consolidação das operações — Não-cumulativo (detalhamento COFINS) | Detalhes COFINS |
| **F600** | Contribuição retida na fonte | Retenções de PIS/COFINS sofridas |
| **F700** | Deduções diversas | Deduções da contribuição |
| **F800** | Créditos decorrentes de eventos de incorporação, fusão e cisão | Reorganizações societárias |

---

#### Bloco I — Operações de Instituições Financeiras e Assemelhadas

Exclusivo para bancos, seguradoras e entidades do SFN. Não se aplica a empresas comerciais.

---

#### Bloco M — Apuração da Contribuição e Crédito de PIS/Pasep e da Cofins

O Bloco M é o **núcleo de apuração** — centraliza débitos, créditos, ajustes e valor a pagar.

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **M001** | Abertura do Bloco M | Indicador |
| **M100** | Crédito de PIS/Pasep relativo ao período | Total de créditos PIS |
| **M105** | Detalhamento da base de cálculo do crédito de PIS | Base por tipo de crédito |
| **M110** | Ajustes do crédito de PIS apurado | Ajustes |
| **M200** | Consolidação — Contribuição para o PIS/Pasep do período | Débito total PIS |
| **M205** | Contribuição PIS sobre receitas não-cumulativas | Detalhamento por CST |
| **M210** | Detalhamento — Contribuição PIS no período | Base, alíquota, contribuição |
| **M211** | Sociedades cooperativas — PIS | Específico cooperativas |
| **M220** | Ajustes da contribuição PIS apurada | Ajustes de débito |
| **M230** | Informações adicionais de diferimento | Diferimento PIS |
| **M300** | Contribuição PIS diferida em períodos anteriores | Valores diferidos |
| **M350** | PIS — Folha de salários | PIS sobre folha (entidades sem fins lucrativos) |
| **M400** | Receitas isentas, não alcançadas, com alíquota zero — PIS | Receitas sem incidência |
| **M410** | Detalhamento — Receitas isentas PIS | Detalhes por CST |
| **M500** | Crédito de COFINS relativo ao período | Total créditos COFINS |
| **M505** | Detalhamento da base de crédito COFINS | Base por tipo |
| **M510** | Ajustes do crédito de COFINS | Ajustes |
| **M600** | Consolidação — Contribuição COFINS do período | Débito total COFINS |
| **M605** | COFINS sobre receitas não-cumulativas | Detalhamento por CST |
| **M610** | Detalhamento — Contribuição COFINS no período | Base, alíquota, contribuição |
| **M620** | Ajustes da contribuição COFINS | Ajustes de débito |
| **M630** | Informações adicionais de diferimento COFINS | Diferimento |
| **M700** | COFINS diferida em períodos anteriores | Valores diferidos |
| **M800** | Receitas isentas, não alcançadas, com alíquota zero — COFINS | Receitas sem incidência |
| **M810** | Detalhamento — Receitas isentas COFINS | Detalhes por CST |

---

#### Bloco P — Apuração da CPRB (Contribuição Previdenciária sobre a Receita Bruta)

| Registro | Descrição |
|---|---|
| **P001** | Abertura do Bloco P |
| **P010** | Identificação do estabelecimento |
| **P100** | Contribuição Previdenciária sobre a Receita Bruta |
| **P110** | Complemento — detalhamento por atividade |
| **P199** | Processo referenciado |
| **P200** | Consolidação da CPRB |
| **P210** | Ajuste da CPRB — detalhamento |

---

#### Bloco 1 — Complemento da Escrituração

| Registro | Descrição |
|---|---|
| **1001** | Abertura do Bloco 1 |
| **1010** | Processo referenciado — Ação judicial |
| **1011** | Detalhamento — Ações judiciais |
| **1020** | Processo referenciado — Processo administrativo |
| **1050** | Detalhamento do ajuste da contribuição — PIS |
| **1100** | Controle de créditos fiscais — PIS |
| **1101** | Apuração de crédito extemporâneo |
| **1102** | Detalhamento por item |
| **1300** | Controle de créditos fiscais — COFINS |
| **1500** | Controle de valores retidos na fonte — PIS |
| **1600** | Controle de valores retidos na fonte — COFINS |
| **1700** | Controle dos valores retidos na fonte — CPRB |
| **1800** | Incorporação imobiliária — RET |
| **1900** | Consolidação dos documentos emitidos por PDV |

---

### 3.4 Dados Necessários do ERP para EFD-Contribuições

| Módulo ERP | Dados Necessários |
|---|---|
| **Cadastros** | Empresas, Clientes, Fornecedores, Produtos (NCM, tipo contribuição) |
| **Vendas** | NF-e de saída (itens com CST PIS/COFINS, base de cálculo, alíquota, valor) |
| **Compras** | NF-e de entrada (itens com CST PIS/COFINS para créditos), Frete (CT-e) |
| **Financeiro** | Receitas financeiras (juros, descontos obtidos), Retenções PIS/COFINS sofridas |
| **Patrimônio** | Bens do ativo imobilizado (créditos F120/F130), Depreciação |
| **Estoque** | Estoque de abertura (crédito presumido F150) |
| **Fiscal** | Apuração PIS/COFINS, CSTs, Ajustes, Base de cálculo |
| **Contabilidade** | Plano de contas, Centros de custo, Receitas contábeis |

---

## 4. ECD (Escrituração Contábil Digital)

### 4.1 Conceito e Obrigatoriedade

A **Escrituração Contábil Digital** substitui a escrituração em papel dos seguintes livros:
- Livro Diário e seus auxiliares
- Livro Razão e seus auxiliares
- Livro Balancetes Diários, Balanços e fichas de lançamento comprobatórias

- **Periodicidade**: Anual
- **Prazo de entrega**: Até 30 de junho do ano subsequente (referente ao ano-calendário anterior)
  - **ECD 2026** (ano-calendário 2025): até 30/06/2026
- **Obrigatória para**: Todas as PJs tributadas pelo Lucro Real; PJs tributadas pelo Lucro Presumido que distribuam lucros acima da presunção; SCP; entidades imunes/isentas
- **Dispensa**: Simples Nacional, MEI, órgãos públicos
- **Programa**: PVA-SPED Contábil (versão 10.3.4 para ano-calendário 2025)
- **Transmissão**: ReceitaNet + SPED (com certificado digital)

### 4.2 Blocos e Registros

#### Bloco 0 — Abertura e Identificação

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **0000** | Abertura do arquivo digital | CNPJ, período, tipo escrituração |
| **0001** | Abertura do Bloco 0 | Indicador |
| **0007** | Outras inscrições cadastrais | IE, IM de filiais |
| **0020** | Escrituração contábil descentralizada | Filiais escrituradoras |
| **0035** | Identificação das SCP | Sociedades em conta de participação |
| **0150** | Tabela de cadastro do participante | Pessoas relacionadas |
| **0180** | Identificação do relacionamento com o participante | Tipo de relação |

---

#### Bloco I — Lançamentos Contábeis

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **I001** | Abertura do Bloco I | Indicador |
| **I010** | Identificação da escrituração contábil | Tipo de livro (G=Diário Geral, R=Razão, etc.) |
| **I012** | Livros auxiliares ao Diário / Razão Auxiliar | Tipos auxiliares |
| **I015** | Identificação das contas da escrituração resumida | Contas do diário resumido |
| **I020** | Campos adicionais | Campos extras do lançamento |
| **I030** | Termo de abertura | Texto do termo de abertura |
| **I050** | **Plano de contas** | Código, descrição, natureza (A/S), nível, conta sintética pai |
| **I051** | Plano de contas referencial | Mapeamento para plano referencial RFB |
| **I052** | Indicação dos códigos de aglutinação | Vinculação com demonstrações (J100/J150) |
| **I053** | Subcontas correlatas | Subcontas do CPC |
| **I075** | Tabela de histórico padronizado | Históricos padrão |
| **I100** | **Centro de custos** | Código e descrição dos centros de custo |
| **I150** | **Saldos periódicos — Identificação do período** | Data início/fim do período |
| **I155** | **Detalhes dos saldos periódicos** | Conta, saldo inicial, débitos, créditos, saldo final |
| **I157** | Transferência de saldos do plano de contas anterior | Saldos migrados |
| **I200** | **Lançamento contábil** | Data, número, tipo (N=Normal, E=Encerramento, F=Fechamento) |
| **I250** | **Partidas do lançamento** | Conta débito/crédito, valor, histórico, participante |
| **I310** | Detalhes dos saldos das contas de resultado antes do encerramento | DRE detalhada |
| **I350** | Saldos das contas de resultado antes do encerramento — Identificação | Período de encerramento |
| **I355** | Detalhes dos saldos — Resultado | Contas de resultado |

---

#### Bloco J — Demonstrações Contábeis

| Registro | Descrição | Dados do ERP |
|---|---|---|
| **J001** | Abertura do Bloco J | Indicador |
| **J005** | **Demonstrações contábeis** | Identificação (Balanço, DRE, etc.), data início/fim |
| **J100** | **Balanço Patrimonial** | Código aglutinação, descrição, saldo 1o dia, saldo último dia, natureza |
| **J150** | **Demonstração do Resultado do Exercício (DRE)** | Código aglutinação, descrição, valor |
| **J200** | Tabela de histórico de fatos contábeis que modificam a conta lucros acumulados | Destinação do lucro |
| **J210** | DLPA — Demonstração de Lucros ou Prejuízos Acumulados | Valores DLPA |
| **J215** | Fato contábil que altera a conta lucros acumulados | Detalhes alterações |
| **J800** | Outras informações — Notas Explicativas | DFC, DVA em formato livre |
| **J801** | Termo de verificação para fins de substituição da ECD | Termo de substituição |
| **J900** | Termo de encerramento | Texto do termo de encerramento |
| **J930** | Identificação dos signatários da escrituração | Contabilista, administradores (CPF, CRC) |
| **J935** | Identificação dos auditores independentes | Dados de auditoria |

---

#### Bloco K — Contas Referenciais (específico da ECD)

| Registro | Descrição |
|---|---|
| **K001** | Abertura do Bloco K |
| **K030** | Período da escrituração contábil consolidada |
| **K100** | Relação das empresas consolidadas |
| **K110** | Relação das empresas consolidadas — saldo contábil |
| **K115** | Empresas participantes do consolidado |
| **K200** | Plano de contas consolidado |
| **K210** | Mapeamento para contas referenciais |
| **K300** | Saldos das contas contábeis consolidadas |
| **K310** | Empresas participantes — saldos |
| **K315** | Empresas participantes do consolidado (detalhamento) |

---

### 4.3 Dados Necessários do ERP para ECD

| Módulo ERP | Dados Necessários |
|---|---|
| **Contabilidade** | Plano de contas completo (com mapeamento referencial), Lançamentos contábeis diários, Saldos periódicos, Encerramento do exercício, Demonstrações (BP, DRE, DLPA, DFC, DVA) |
| **Cadastros** | Dados da empresa, Contador/auditor, Participantes |
| **Financeiro** | Lançamentos financeiros integrados com contabilidade |
| **Patrimônio** | Depreciação, Amortização (reflexo contábil) |

---

## 5. ECF (Escrituração Contábil Fiscal)

### 5.1 Conceito e Obrigatoriedade

A **Escrituração Contábil Fiscal** substitui a DIPJ (Declaração de Informações Econômico-Fiscais da Pessoa Jurídica) e tem como objetivo demonstrar a apuração do IRPJ e da CSLL.

- **Periodicidade**: Anual
- **Prazo de entrega**: Até o último dia útil de julho do ano subsequente
  - **ECF 2026** (ano-calendário 2025): até 31/07/2026
- **Obrigatória para**: Todas as PJs, inclusive imunes e isentas (exceto Simples Nacional, órgãos públicos, PJs inativas)
- **Programa**: PVA-ECF (versão 12.0.1 para ano-calendário 2025)
- **Vinculação**: Recupera dados da ECD do mesmo período (obrigatório para Lucro Real)
- **Transmissão**: ReceitaNet + SPED (certificado digital)

### 5.2 Blocos e Registros

A ECF é composta por **14 blocos** e é a obrigação mais complexa do SPED.

#### Bloco 0 — Abertura e Identificação

| Registro | Descrição |
|---|---|
| **0000** | Abertura do arquivo digital |
| **0001** | Abertura do Bloco 0 |
| **0010** | Parâmetros de tributação (forma tributação, qualificação PJ, forma apuração) |
| **0020** | Parâmetros complementares |
| **0030** | Dados cadastrais |
| **0035** | Identificação das SCP |

---

#### Bloco C — Informações Recuperadas da ECF Anterior

Dados recuperados automaticamente do arquivo ECF do exercício anterior (saldos finais que se tornam iniciais).

---

#### Bloco E — Informações Recuperadas da ECD

Saldos contábeis recuperados da ECD para construir os balanços e demonstrações fiscais.

| Registro | Descrição |
|---|---|
| **E010** | Identificação do período recuperado |
| **E015** | Contas contábeis mapeadas |
| **E020** | Saldos finais recuperados |
| **E030** | Identificação do período (ECF anterior) |

---

#### Bloco J — Plano de Contas e Mapeamento

| Registro | Descrição |
|---|---|
| **J050** | Plano de contas do contribuinte |
| **J051** | Plano de contas referencial |
| **J053** | Subcontas correlatas |
| **J100** | Centro de custos |

---

#### Bloco K — Saldos das Contas Contábeis e Referenciais

| Registro | Descrição |
|---|---|
| **K030** | Identificação dos períodos e formas de apuração |
| **K155** | Detalhes dos saldos contábeis — Contas patrimoniais e de resultado |
| **K156** | Mapeamento referencial dos saldos |
| **K355** | Saldos finais das contas — Resultado após apuração do IRPJ/CSLL |
| **K356** | Mapeamento referencial dos saldos de resultado |

---

#### Bloco L — Lucro Líquido — Lucro Real

Balanço Patrimonial, DRE e cálculo do lucro líquido para empresas do Lucro Real.

| Registro | Descrição |
|---|---|
| **L030** | Identificação do período |
| **L100** | Balanço Patrimonial |
| **L200** | Método de avaliação do estoque final |
| **L210** | Informativo da composição de custos |
| **L300** | Demonstração do Resultado do Exercício |

---

#### Bloco M — e-LALUR e e-LACS (Livros de Apuração)

Livros eletrônicos de apuração do Lucro Real (LALUR) e da Base de Cálculo da CSLL (LACS).

| Registro | Descrição |
|---|---|
| **M010** | Identificação da SCP |
| **M030** | Identificação do período (mensal ou trimestral) |
| **M300** | e-LALUR — Parte A (adições e exclusões do lucro líquido) |
| **M305** | Conta da Parte B do e-LALUR |
| **M310** | Contas contábeis relacionadas ao lançamento da Parte A |
| **M312** | Números da conta contábil |
| **M315** | Identificação de processos judiciais/administrativos — LALUR |
| **M350** | e-LACS — Parte A (adições e exclusões para CSLL) |
| **M355** | Conta da Parte B do e-LACS |
| **M360** | Contas contábeis relacionadas — LACS |
| **M362** | Números da conta contábil — LACS |
| **M365** | Identificação de processos — LACS |
| **M410** | Lançamento na Parte B — e-LALUR (prejuízos, incentivos) |
| **M415** | Identificação de processos — LALUR Parte B |
| **M500** | Controle de saldos das contas da Parte B do e-LALUR |
| **M510** | Controle de saldos das contas da Parte B do e-LACS |

---

#### Bloco N — Cálculo do IRPJ e da CSLL — Lucro Real

| Registro | Descrição |
|---|---|
| **N030** | Identificação do período |
| **N500** | Base de cálculo do IRPJ — Estimativa mensal |
| **N600** | Demonstração do lucro da exploração |
| **N610** | Cálculo do IRPJ — Lucro Real mensal/trimestral |
| **N615** | Informações da base de cálculo de incentivos fiscais |
| **N620** | Cálculo do IRPJ — Lucro Real (pagamento por estimativa) |
| **N630** | Cálculo do IRPJ — Lucro Real (ajuste anual) |
| **N650** | Base de cálculo da CSLL — Lucro Real |
| **N660** | Cálculo da CSLL — Lucro Real |
| **N670** | Cálculo da CSLL — Estimativa mensal |

---

#### Bloco P — Lucro Presumido

| Registro | Descrição |
|---|---|
| **P030** | Identificação do período |
| **P100** | Balanço Patrimonial |
| **P130** | Demonstração das receitas incentivadas |
| **P150** | Demonstração do Resultado |
| **P200** | Apuração da base de cálculo do Lucro Presumido (IRPJ) |
| **P230** | Cálculo da isenção e redução do Lucro Presumido |
| **P300** | Cálculo do IRPJ — Lucro Presumido |
| **P400** | Apuração da base de cálculo da CSLL — Lucro Presumido |
| **P500** | Cálculo da CSLL — Lucro Presumido |

---

#### Bloco Q — Livro Caixa

Para empresas do Lucro Presumido que utilizam livro caixa.

| Registro | Descrição |
|---|---|
| **Q100** | Demonstrativo do livro caixa |

---

#### Bloco T — Lucro Arbitrado

| Registro | Descrição |
|---|---|
| **T030** | Identificação do período |
| **T120** | Apuração da base de cálculo — IRPJ |
| **T150** | Cálculo do IRPJ — Lucro Arbitrado |
| **T170** | Apuração da base de cálculo — CSLL |
| **T181** | Cálculo da CSLL — Lucro Arbitrado |

---

#### Bloco U — Imunes e Isentas

| Registro | Descrição |
|---|---|
| **U030** | Identificação do período |
| **U100** | Balanço Patrimonial |
| **U150** | Demonstração do resultado |
| **U180** | Cálculo do IRPJ — Imunes e isentas |
| **U182** | Cálculo da CSLL — Imunes e isentas |

---

#### Bloco W — Declaração País-a-País (CbCR)

Relatório Country-by-Country Report (para multinacionais com receita > R$ 2,26 bilhões).

---

#### Bloco X — Informações Econômicas

| Registro | Descrição |
|---|---|
| **X280** | Atividades incentivadas (Lucro da Exploração) |
| **X291** | Operações com o exterior — Contratantes |
| **X292** | Operações com o exterior — Contratados |
| **X300** | Operações com o exterior — Exportação |
| **X310** | Operações com o exterior — Contratantes das exportações |
| **X320** | Operações com o exterior — Importação |
| **X330** | Operações com o exterior — Contratantes das importações |
| **X340** | Identificação da participação no exterior |
| **X350** | Participações no exterior — Resultado |
| **X351** | Demonstrativo de resultados e imposto pago no exterior |
| **X352** | Demonstrativo de resultados no exterior consolidados |
| **X353** | Demonstrativo de resultados — Detalhamento |
| **X354** | Demonstrativo de prejuízos acumulados no exterior |
| **X355** | Demonstrativo de rendas ativas e passivas — País por país |
| **X356** | Demonstrativo consolidado de rendas |

---

#### Bloco Y — Informações Gerais

| Registro | Descrição |
|---|---|
| **Y520** | Pagamentos/Remessas ao exterior |
| **Y540** | Discriminação da receita de vendas — Por atividade econômica |
| **Y550** | Vendas a comercial exportadora (detalhamento) |
| **Y560** | Detalhamento das exportações da comercial exportadora |
| **Y570** | Demonstrativo do IRPJ/CSLL retido na fonte |
| **Y580** | Doações a campanhas eleitorais |
| **Y590** | Ativos no exterior |
| **Y600** | Identificação e remuneração de sócios, dirigentes e conselheiros |
| **Y612** | Identificação e rendimentos de dirigentes e conselheiros |
| **Y620** | Participações avaliadas pelo método de equivalência patrimonial |
| **Y630** | Fundos / Clubes de investimento |
| **Y640** | Participações em consórcios de empresas |
| **Y650** | Participantes do consórcio |
| **Y660** | Dados de sucessoras |
| **Y671** | Outras informações (e.g. operações com pessoa vinculada) |
| **Y672** | Outras informações da pessoa jurídica |
| **Y680** | Meses em que a PJ esteve inativa ou não teve débitos a declarar |
| **Y690** | Informações sobre atividades incentivadas |
| **Y720** | Informações de períodos anteriores |
| **Y750** | Inventário — Razão auxiliar |
| **Y770** | Informações contratuais — Assistência técnica, científica, administrativa |
| **Y780** | Declaração de pagamentos efetuados a título de JCP (Juros sobre Capital Próprio) |
| **Y790** | Identificação dos beneficiários dos JCP |
| **Y800** | Outras informações — ECF |

---

### 5.3 Dados Necessários do ERP para ECF

| Módulo ERP | Dados Necessários |
|---|---|
| **Contabilidade** | ECD transmitida, Plano de contas referencial, Balanço patrimonial, DRE, Encerramento |
| **Fiscal** | Apuração IRPJ (estimativa mensal ou trimestral), Apuração CSLL, LALUR Parte A e B, LACS Parte A e B |
| **Financeiro** | Receitas financeiras, JCP (Juros sobre Capital Próprio), Operações com o exterior |
| **RH** | Remuneração de sócios, dirigentes, conselheiros |
| **Estoque** | Método de avaliação, Composição de custos |
| **Cadastros** | Sócios/participações, Participações societárias, Dados de controladas/coligadas |

---

## 6. EFD-Reinf

### 6.1 Conceito e Obrigatoriedade

A **Escrituração Fiscal Digital de Retenções e Outras Informações Fiscais** complementa o eSocial com dados de retenções sobre pagamentos a terceiros (serviços) e outras informações tributárias.

- **Periodicidade**: Mensal (eventos enviados até o dia 15 do mês subsequente)
- **Formato**: XML (não é TXT como os demais SPED)
- **Transmissão**: Web Service REST (API com certificado digital)
- **Integração**: Alimenta a DCTFWeb automaticamente
- **Substituiu a DIRF**: A partir de janeiro/2025 (fatos geradores de 2024 em diante)

### 6.2 Eventos

#### Série R-1000 — Eventos de Tabela

| Evento | Descrição | Dados do ERP |
|---|---|---|
| **R-1000** | Informações do contribuinte | CNPJ, classificação tributária, contato, validade |
| **R-1050** | Tabela de entidades ligadas | Entidades vinculadas ao contribuinte |
| **R-1070** | Tabela de processos administrativos/judiciais | Processos com decisão/liminar suspensiva |

#### Série R-2000 — Retenções Previdenciárias

| Evento | Descrição | Dados do ERP |
|---|---|---|
| **R-2010** | Retenção contribuição previdenciária — **Serviços Tomados** | NFs de serviço tomados, CNPJ prestador, valor bruto, retenção INSS (11%) |
| **R-2020** | Retenção contribuição previdenciária — **Serviços Prestados** | NFs de serviço prestados, CNPJ tomador, retenção |
| **R-2030** | Recursos recebidos por associação desportiva | Patrocínios, publicidade |
| **R-2040** | Recursos repassados para associação desportiva | Repasses a clubes |
| **R-2050** | Comercialização da produção — Produtor rural PJ/agroindústria | Vendas de produção rural |
| **R-2055** | Aquisição de produção rural — PF | Compras de produtor rural PF |
| **R-2060** | CPRB — Contribuição Previdenciária sobre a Receita Bruta | Receita bruta por atividade (CNAE) |
| **R-2098** | Reabertura dos eventos da série R-2000 | Reabertura de período fechado |
| **R-2099** | Fechamento dos eventos da série R-2000 | Fechamento mensal |

#### Série R-4000 — Retenções na Fonte (IR, CSLL, PIS, COFINS)

**Substituiu a DIRF** a partir de setembro/2023.

| Evento | Descrição | Dados do ERP |
|---|---|---|
| **R-4010** | Pagamentos/créditos a beneficiário **Pessoa Física** | Pagamentos PF: aluguéis, serviços autônomos, comissões. IR retido |
| **R-4020** | Pagamentos/créditos a beneficiário **Pessoa Jurídica** | Pagamentos PJ: serviços profissionais, aluguéis. Retenções IR/CSLL/PIS/COFINS |
| **R-4040** | Pagamentos/créditos a beneficiários **não identificados** | Pagamentos sem identificação do beneficiário |
| **R-4080** | Retenção no recebimento (**Auto Retenção**) | Retenções sofridas pela própria empresa (agências, factoring) |
| **R-4099** | Fechamento/reabertura dos eventos da série R-4000 | Fechamento mensal dos eventos de retenção na fonte |

#### Evento de Controle

| Evento | Descrição |
|---|---|
| **R-9000** | Exclusão de eventos | Cancelamento de evento enviado anteriormente |
| **R-9001** | Bases e tributos — Totalizador (retorno) | Totalizador calculado pela RFB |
| **R-9005** | Bases e tributos — Retenções na fonte (retorno) | Totalizador R-4000 |
| **R-9011** | Consolidação de bases e tributos — Previdenciária | Totalizador R-2000 |
| **R-9015** | Consolidação de bases e tributos — Retenções na fonte | Totalizador R-4000 |

### 6.3 Dados Necessários do ERP para EFD-Reinf

| Módulo ERP | Dados Necessários |
|---|---|
| **Financeiro (Contas a Pagar)** | Pagamentos a PF (R-4010): aluguéis, autônomos, comissões, serviços. Pagamentos a PJ (R-4020): serviços profissionais, aluguéis. Valores brutos, retenções IR/CSLL/PIS/COFINS |
| **Compras** | NFs de serviço tomados com retenção INSS (R-2010): CNPJ prestador, valor, retenção |
| **Vendas** | NFs de serviço prestados com retenção INSS (R-2020): CNPJ tomador, valor, retenção |
| **RH** | Pagamentos a autônomos (se não no eSocial) |
| **Fiscal** | CPRB (R-2060): receita bruta por atividade |
| **Cadastros** | Processos judiciais/administrativos (R-1070) |

---

## 7. DCTFWeb e MIT

### 7.1 DCTFWeb

A **Declaração de Débitos e Créditos Tributários Federais Previdenciários e de Outras Entidades e Fundos** é gerada automaticamente a partir dos dados enviados pelo eSocial e EFD-Reinf.

- **Periodicidade**: Mensal
- **Prazo**: Até o último dia útil do mês subsequente ao fato gerador (alterado em 2025)
- **Acesso**: Portal e-CAC (certificado digital)
- **Função**: Confissão de dívida tributária + geração do DARF para pagamento
- **Tributos originais**: Contribuições previdenciárias (INSS patronal, terceiros, SAT/RAT, CPRB)

### 7.2 MIT (Módulo de Inclusão de Tributos)

O **MIT** é a grande novidade de 2025, substituindo o antigo PGD-DCTF (programa de preenchimento offline).

**Tributos incorporados ao MIT/DCTFWeb**:
- IRPJ (Imposto de Renda Pessoa Jurídica)
- CSLL (Contribuição Social sobre o Lucro Líquido)
- PIS/Pasep
- COFINS
- IPI (Imposto sobre Produtos Industrializados)
- IOF (Imposto sobre Operações Financeiras)
- CIDE (Contribuição de Intervenção no Domínio Econômico)
- CONDECINE
- CPSS (Contribuição para o Plano de Seguridade Social)
- RET/Pagamento Unificado

**Funcionamento**:
1. Empresa preenche o MIT (online ou importação de arquivo)
2. MIT envia dados para a DCTFWeb
3. DCTFWeb consolida: eSocial + EFD-Reinf + MIT
4. Contribuinte transmite a DCTFWeb
5. DARF numerado é gerado para pagamento

**Novidade 2025/2026**: DARF numerado pode ser emitido antes da transmissão final da DCTFWeb, após envio do eSocial e EFD-Reinf.

### 7.3 Dados Necessários do ERP

| Módulo ERP | Dados para DCTFWeb/MIT |
|---|---|
| **RH/eSocial** | Folha de pagamento, encargos, INSS, FGTS |
| **Financeiro** | Retenções (INSS, IR, CSLL, PIS, COFINS) |
| **Fiscal** | IRPJ, CSLL, PIS/COFINS, IPI, IOF (valores de cada competência) |
| **Contabilidade** | Conciliação de débitos e créditos tributários |

---

## 8. DIRF, DCTF, DEFIS e Outras Obrigações

### 8.1 DIRF (Declaração do Imposto sobre a Renda Retido na Fonte)

- **Status**: **EXTINTA** para fatos geradores a partir de 01/01/2025
- **Substituída por**: eSocial + EFD-Reinf (série R-4000)
- **Última DIRF**: Referente ao ano-calendário 2024, entregue em fevereiro/2025
- **Impacto no ERP**: Os dados que antes iam para a DIRF agora devem alimentar a EFD-Reinf mensalmente (não mais anualmente)

### 8.2 DCTF Mensal (PGD)

- **Status**: **SUBSTITUÍDA** pelo MIT/DCTFWeb a partir de janeiro/2025
- **Última DCTF PGD**: Referente a dezembro/2024
- **Impacto no ERP**: Tributos federais (IRPJ, CSLL, PIS, COFINS, IPI, IOF) agora são declarados via MIT integrado à DCTFWeb

### 8.3 DEFIS (Declaração de Informações Socioeconômicas e Fiscais)

- **Obrigatória para**: Empresas optantes pelo Simples Nacional
- **Periodicidade**: Anual
- **Prazo**: Até 31 de março do ano subsequente (DEFIS 2025: até 31/03/2026)
- **Formato**: Preenchimento online no portal do Simples Nacional
- **Multas (a partir de 2026)**: 2% ao mês-calendário ou fração de atraso, mínimo R$ 50,00/mês. Informações incorretas: R$ 100,00 para cada grupo de 10 informações. Redução de 50% para entrega espontânea antes da fiscalização.

**Dados do ERP**:
- Receita bruta por atividade
- Folha de pagamento (total)
- Ganhos de capital
- Exportações
- ISS retido
- Quantidade de empregados

### 8.4 PGDAS-D (Programa Gerador do Documento de Arrecadação do Simples Nacional)

- **Obrigatória para**: Simples Nacional
- **Periodicidade**: Mensal
- **Prazo**: Até o dia 20 do mês subsequente
- **Multas (2026)**: 2% ao mês-calendário, mínimo R$ 50,00/mês

### 8.5 DIMOB (Declaração de Informações sobre Atividades Imobiliárias)

- **Obrigatória para**: Empresas imobiliárias
- **Periodicidade**: Anual (até fevereiro)
- **Dados**: Vendas, aluguéis intermediados, incorporações

### 8.6 DOI (Declaração sobre Operações Imobiliárias)

- **Obrigatória para**: Cartórios
- **Prazo**: Até último dia útil do mês subsequente à operação

### 8.7 DMED (Declaração de Serviços Médicos e de Saúde)

- **Obrigatória para**: Prestadores de serviços de saúde
- **Periodicidade**: Anual

### 8.8 DME (Declaração de Operações Liquidadas com Moeda em Espécie)

- **Obrigatória para**: PJ e PF que receberem valores >= R$ 30.000,00 em espécie
- **Prazo**: Até último dia útil do mês subsequente

---

## 9. Formato dos Arquivos SPED

### 9.1 Especificação Técnica — Arquivos TXT (EFD-ICMS/IPI, EFD-Contribuições, ECD, ECF)

```
Formato:         Arquivo texto plano (.txt)
Codificação:     ASCII — ISO 8859-1 (Latin-1)
Delimitador:     | (pipe / barra vertical)
Final de linha:  CR+LF (\r\n)
Campos numéricos: Sem separador de milhar, decimal com vírgula
Campos data:      ddmmaaaa (sem barras)
Campos alfanum.:  Sem aspas, máximo 255 caracteres
```

### 9.2 Estrutura de um Registro

```
|REG|CAMPO1|CAMPO2|CAMPO3|...|CAMPON|
```

**Exemplo — Registro 0000 (EFD-ICMS/IPI)**:
```
|0000|020|0|01012026|31012026|EMPRESA EXEMPLO LTDA|12345678000199|SP|1234567890||3550308|55|35||A|1|
```

Onde:
- `020` = código do leiaute
- `0` = tipo de finalidade (0=remessa original)
- `01012026` = data início do período
- `31012026` = data final do período
- E assim por diante...

### 9.3 Hierarquia de Registros

Os registros seguem uma hierarquia pai-filho. Por exemplo:
```
C001 (Abertura Bloco C)
  C100 (NF-e)
    C170 (Itens da NF-e)
    C190 (Registro Analítico)
  C100 (outra NF-e)
    C170 ...
    C190 ...
C990 (Encerramento Bloco C)
```

### 9.4 Formato XML — EFD-Reinf e eSocial

A EFD-Reinf e o eSocial utilizam formato **XML** (não TXT), transmitidos via **Web Service REST/SOAP**.

```xml
<!-- Exemplo simplificado R-4020 -->
<Reinf xmlns="http://www.reinf.esocial.gov.br/schemas/evt4020PagtoBeneficiarioPJ/v2_01_02">
  <evtRetPJ>
    <ideEvento>
      <indRetif>1</indRetif>
      <perApur>2026-01</perApur>
    </ideEvento>
    <ideContri>
      <tpInsc>1</tpInsc>
      <nrInsc>12345678000199</nrInsc>
    </ideContri>
    <ideBenef>
      <cnpjBenef>98765432000188</cnpjBenef>
      <nmBenef>PRESTADOR LTDA</nmBenef>
    </ideBenef>
    <ideEstab>
      <tpInscEstab>1</tpInscEstab>
      <nrInscEstab>12345678000199</nrInscEstab>
      <idePgto>
        <natRend>15008</natRend>
        <infoPgto>
          <dtFG>2026-01-15</dtFG>
          <vlrBruto>10000.00</vlrBruto>
          <retencoes>
            <vlrBaseIR>10000.00</vlrBaseIR>
            <vlrIR>150.00</vlrIR>
          </retencoes>
        </infoPgto>
      </idePgto>
    </ideEstab>
  </evtRetPJ>
</Reinf>
```

### 9.5 Transmissão

| Obrigação | Método de Transmissão | Programa |
|---|---|---|
| EFD-ICMS/IPI | PVA + ReceitaNet | PVA versão específica por ano |
| EFD-Contribuições | PVA + ReceitaNet | PVA versão específica |
| ECD | PVA + ReceitaNet | PVA-SPED Contábil (v10.3.4) |
| ECF | PVA + ReceitaNet | PVA-ECF (v12.0.1) |
| EFD-Reinf | Web Service REST | API com certificado digital |
| DCTFWeb | Portal e-CAC (online) | Acesso online + MIT |
| NF-e/NFC-e | Web Service SOAP | SEFAZ estadual |

---

## 10. Multas e Penalidades

### 10.1 EFD-ICMS/IPI

| Infração | Penalidade |
|---|---|
| Atraso na entrega | 0,02% por dia de atraso sobre a receita bruta, limitada a 1% |
| Multa mínima | R$ 500,00/mês (Lucro Presumido) ou R$ 1.500,00/mês (Lucro Real) |
| Informações incorretas | R$ 100,00 para cada grupo de 10 informações incorretas/omitidas |
| Arquivo com omissões ou incorreções | Multa de 0,5% do valor da receita bruta da PJ |
| Entrega com dados inconsistentes | 0,02% sobre a receita bruta do período |

### 10.2 EFD-Contribuições

| Infração | Penalidade |
|---|---|
| Atraso na entrega | 0,02% por dia de atraso sobre a receita bruta, limitada a 1% |
| Multa mínima | R$ 500,00/mês (Lucro Presumido) ou R$ 1.500,00/mês (Lucro Real) |
| Informações incorretas | R$ 100,00 para cada grupo de 10 informações incorretas/omitidas |
| Multa automática | PVA gera a multa automaticamente na transmissão extemporânea |
| Redução | 50% se entregue antes de intimação fiscal |

### 10.3 ECD (SPED Contábil)

| Infração | Penalidade |
|---|---|
| Não apresentação no prazo | Multa equivalente a 0,02% por dia de atraso, sobre a receita bruta (limitada a 1%) |
| Multa mínima | R$ 500,00 (Lucro Presumido) ou R$ 1.500,00 (Lucro Real) |
| Informações inexatas, incompletas ou omitidas | 3% do valor das transações correspondentes (não inferior a R$ 100,00) |

### 10.4 ECF (Escrituração Contábil Fiscal)

| Infração | Penalidade |
|---|---|
| Atraso na entrega | 0,25% por mês-calendário ou fração sobre o lucro líquido antes do IRPJ/CSLL |
| Multa mínima | R$ 500,00 (Lucro Presumido) ou R$ 1.500,00 (Lucro Real) |
| Informações inexatas, incompletas ou omitidas | 3% do valor omitido, inexato ou incorreto (não inferior a R$ 100,00) |
| Redução | 90% para Lucro Presumido; 75% se corrigido antes de procedimento fiscal |

### 10.5 EFD-Reinf

| Infração | Penalidade |
|---|---|
| Atraso na entrega | 2% ao mês sobre os tributos informados, limitada a 20% |
| Multa mínima | R$ 200,00 (inativas) ou R$ 500,00 (ativas) |
| Informações incorretas | R$ 20,00 para cada grupo de 10 informações incorretas/omitidas |

### 10.6 DCTFWeb

| Infração | Penalidade |
|---|---|
| Atraso na entrega | 2% ao mês sobre o total de contribuições, limitada a 20% |
| Multa mínima | R$ 200,00 (inativas) ou R$ 500,00 (ativas) |
| Omissão/Inexatidão | R$ 20,00 para cada grupo de 10 informações |

---

## 11. Mapeamento: Módulos ERP x Obrigações

### 11.1 Matriz de Dependência

| Módulo ERP | EFD-ICMS/IPI | EFD-Contrib. | ECD | ECF | EFD-Reinf | DCTFWeb |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Cadastros (Pessoas, Produtos)** | X | X | X | X | X | — |
| **Vendas (NF-e saída)** | X | X | — | — | X* | — |
| **Compras (NF-e entrada)** | X | X | — | — | X | — |
| **Estoque (Saldos, Inventário)** | X | X* | — | X* | — | — |
| **Produção/PCP** | X | — | — | — | — | — |
| **Financeiro (CP/CR)** | X* | X | — | — | X | X |
| **Contabilidade** | X* | X* | X | X | — | — |
| **Patrimônio (Imobilizado)** | X | X | X* | X* | — | — |
| **Fiscal (Apuração)** | X | X | — | X | X | X |
| **RH/Folha** | — | — | — | X* | — | X |

*Legenda*: X = Alimenta diretamente | X* = Alimenta indiretamente/parcialmente | — = Não se aplica

### 11.2 Fluxo de Dados — Visão Integrada

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                     MÓDULOS DO ERP                       │
                    ├──────────┬──────────┬──────────┬──────────┬─────────────┤
                    │ Vendas   │ Compras  │ Estoque  │Financeiro│Contabilidade│
                    │ (NF-e)   │ (NF-e)   │ (Saldos) │ (CP/CR)  │ (Lctos)     │
                    └────┬─────┴────┬─────┴────┬─────┴────┬─────┴──────┬──────┘
                         │          │          │          │            │
                    ┌────▼──────────▼──────────▼──────────▼────────────▼──────┐
                    │               MÓDULO FISCAL DO ERP                       │
                    │  (Apuração ICMS/IPI/PIS/COFINS/IRPJ/CSLL)              │
                    └────┬──────┬──────┬──────┬──────┬──────┬────────────────┘
                         │      │      │      │      │      │
                    ┌────▼──┐┌──▼──┐┌──▼──┐┌──▼──┐┌──▼──┐┌──▼──┐
                    │EFD    ││EFD  ││ECD  ││ECF  ││Reinf││DCTF │
                    │ICMS   ││Contr││     ││     ││     ││Web  │
                    │IPI    ││     ││     ││     ││     ││+MIT │
                    └───┬───┘└──┬──┘└──┬──┘└──┬──┘└──┬──┘└──┬──┘
                        │       │      │      │      │      │
                    ┌───▼───────▼──────▼──────▼──────▼──────▼───┐
                    │          RECEITA FEDERAL / SEFAZ            │
                    │  (PVA + ReceitaNet / Web Service / e-CAC)  │
                    └────────────────────────────────────────────┘
```

---

## 12. Reforma Tributária (CBS/IBS) — Impacto 2026+

### 12.1 Cronograma de Transição

| Ano | Evento |
|---|---|
| **2026** | Fase de testes: CBS 0,9% + IBS 0,1% (compensáveis com PIS/COFINS). Obrigação acessória real (campos CBS/IBS em NF-e) |
| **2027** | CBS entra em vigor. Extinção de PIS e COFINS. Split payment pode iniciar |
| **2028** | IBS entra em vigor com alíquota reduzida. ICMS e ISS começam a ser reduzidos |
| **2029-2032** | Redução gradual de ICMS e ISS |
| **2033** | Extinção completa de ICMS e ISS. IBS em alíquota plena |

### 12.2 Impacto no ERP

**Curto prazo (2026)**:
- NF-e e NFS-e com novos campos de tributação (cClassTrib, CST de IBS/CBS)
- Novos grupos de tributação nos XMLs
- EFD-ICMS/IPI e EFD-Contribuições continuam existindo (para ICMS/IPI e PIS/COFINS residuais)
- Nova obrigação acessória para CBS/IBS (formato a definir)

**Médio prazo (2027-2032)**:
- Convivência de sistemas: ICMS + ISS + IBS + CBS simultaneamente
- ERP precisa calcular e registrar múltiplos tributos por operação
- Split payment: tributo retido automaticamente na liquidação financeira (não transita pelo caixa)
- Novas regras de crédito (IBS/CBS: crédito financeiro amplo)

**Longo prazo (2033+)**:
- IVA Dual pleno (IBS + CBS)
- Simplificação das obrigações acessórias (provável unificação)
- Extinção da EFD-ICMS/IPI (sem ICMS/IPI para escriturar)
- Nova EFD para IBS/CBS

### 12.3 Recomendações para o ERP

1. **Preparar a estrutura fiscal para múltiplos tributos por operação** (ICMS + CBS + IBS no mesmo documento)
2. **Implementar o split payment** (integração com bancos/adquirentes para retenção automática)
3. **Manter compatibilidade retroativa** (obrigações atuais existirão até 2033)
4. **Modularizar o motor de cálculo fiscal** para absorver mudanças regulatórias

---

## 13. Recomendações de Implementação

### 13.1 Arquitetura Sugerida para Módulo Fiscal/SPED no ERP

```
ERP
├── Módulo Fiscal
│   ├── Motor de Cálculo de Impostos
│   │   ├── ICMS (CST, base, alíquota, valor)
│   │   ├── IPI (CST, enquadramento, base, alíquota, valor)
│   │   ├── PIS/COFINS (CST, base, alíquota, valor, créditos)
│   │   ├── ISS (base, alíquota, retenção)
│   │   ├── IRPJ/CSLL (apuração, LALUR/LACS)
│   │   ├── CBS/IBS (novo — 2026+)
│   │   └── Retenções (INSS, IR, CSLL, PIS, COFINS)
│   │
│   ├── Livros Fiscais Digitais
│   │   ├── Livro de Entradas (Bloco C — entradas)
│   │   ├── Livro de Saídas (Bloco C — saídas)
│   │   ├── Livro de Inventário (Bloco H)
│   │   ├── Livro de Apuração ICMS (Bloco E)
│   │   ├── Livro de Apuração IPI (Bloco E)
│   │   └── CIAP (Bloco G)
│   │
│   ├── Gerador de Arquivos SPED
│   │   ├── EFD-ICMS/IPI (.txt)
│   │   ├── EFD-Contribuições (.txt)
│   │   ├── ECD (.txt)
│   │   ├── ECF (.txt)
│   │   ├── EFD-Reinf (.xml)
│   │   └── MIT/DCTFWeb (importação/API)
│   │
│   ├── Tabelas Fiscais
│   │   ├── NCM (Nomenclatura Comum do Mercosul)
│   │   ├── CFOP (Código Fiscal de Operações e Prestações)
│   │   ├── CST ICMS/IPI/PIS/COFINS
│   │   ├── Natureza da Receita
│   │   ├── Código de Ajuste (tabela 5.1.1)
│   │   ├── Código de Recolhimento
│   │   └── CEST (Código Especificador da ST)
│   │
│   └── Validação e Auditoria
│       ├── Validação pré-envio (regras do PVA)
│       ├── Cruzamento entre obrigações
│       ├── Relatório de inconsistências
│       └── Log de transmissão/protocolo
│
├── Integração com DocumentosFiscais Eletrônicos (DFe)
│   ├── Emissão NF-e (modelo 55)
│   ├── Emissão NFC-e (modelo 65)
│   ├── Emissão NFS-e
│   ├── Emissão CT-e
│   ├── Recepção/Manifestação de NF-e
│   └── Armazenamento XML (5 anos)
│
└── Dashboard Fiscal
    ├── Status de obrigações (pendentes, enviadas, retificadas)
    ├── Calendário fiscal
    ├── Alertas de prazo
    └── Indicadores de risco fiscal
```

### 13.2 Tabelas de Domínio Necessárias

Para uma implementação completa do SPED em um ERP, são necessárias as seguintes tabelas de domínio:

| Tabela | Descrição | Quantidade aprox. |
|---|---|---|
| NCM | Nomenclatura Comum do Mercosul | ~13.000 códigos |
| CFOP | Código Fiscal de Operações | ~600 códigos |
| CST ICMS | Código de Situação Tributária ICMS | ~30 códigos |
| CSOSN | Código de Situação da Operação (Simples Nacional) | ~15 códigos |
| CST IPI | Código de Situação Tributária IPI | ~55 códigos |
| CST PIS/COFINS | Código de Situação Tributária PIS/COFINS | ~99 códigos |
| CEST | Código Especificador da Substituição Tributária | ~800 códigos |
| CNAE | Classificação Nacional de Atividades Econômicas | ~1.300 códigos |
| Natureza da Receita | Códigos para EFD-Contribuições | ~200 códigos |
| Código de Ajuste | Tabela 5.1.1 do SPED Fiscal | ~2.000+ códigos (por UF) |
| Código de Recolhimento | DARF, GNRE | ~400 códigos |
| Código ANP | Agência Nacional do Petróleo | ~100 códigos |
| Alíquotas ICMS | Por UF/produto/operação | Variável (milhares) |

### 13.3 Priorização de Implementação

| Fase | Obrigação | Complexidade | Prioridade |
|---|---|---|---|
| **1** | NF-e/NFC-e (emissão e recepção) | Alta | Crítica |
| **2** | EFD-ICMS/IPI | Alta | Crítica |
| **3** | EFD-Contribuições | Alta | Crítica |
| **4** | EFD-Reinf | Média | Alta |
| **5** | DCTFWeb/MIT | Média | Alta |
| **6** | ECD | Média-Alta | Alta |
| **7** | ECF | Alta | Alta |
| **8** | CBS/IBS (Reforma Tributária) | Alta | Média (preparar agora) |
| **9** | DEFIS/PGDAS-D | Baixa | Condicional (Simples Nacional) |

### 13.4 Padrões de Implementação Comuns em ERPs

1. **Gerador de arquivo TXT**: Classe/service que monta o arquivo SPED registro a registro, com validação de campos obrigatórios, formatação de tipos (N, C, data), e contagem de registros para o Bloco 9
2. **Importação de retorno**: Leitura do protocolo de recepção (número de protocolo, status, mensagens de erro)
3. **Retificação**: Capacidade de gerar arquivo retificador (campo FINALIDADE = 1) com todos os dados corrigidos
4. **Versionamento de leiaute**: Cada ano pode ter um leiaute diferente. O sistema deve suportar geração conforme a versão vigente no período
5. **Auditoria pré-envio**: Relatórios que simulam as validações do PVA para detectar erros antes da transmissão
6. **Certificado digital**: Integração com e-CNPJ/e-CPF para assinatura digital dos arquivos

---

## Referências e Fontes

- [Portal Nacional do SPED — Receita Federal](http://sped.rfb.gov.br/)
- [Guia Prático EFD-ICMS/IPI — Versão 3.2.1](http://sped.rfb.gov.br/estatico/63/6041DD7FE00A75F263BAD0595E7081B42E32F9/Guia%20Pr%C3%A1tico%20EFD%20-%20Vers%C3%A3o%203.2.1.pdf)
- [Manuais e Guias Práticos — SPED](http://sped.rfb.gov.br/pasta/show/1573)
- [EFD ICMS IPI: Principais Blocos e Registros — TecnoSpeed](https://blog.tecnospeed.com.br/sped-fiscal-efd-icms-ipi/)
- [EFD-ICMS/IPI Nota Técnica 2025.001 e Leiaute 020](https://blog.tecnospeed.com.br/novo-leiaute-do-sped-fiscal-para-2026/)
- [EFD Contribuições: Blocos e Funções — SAAM](https://saamauditoria.com.br/noticias/efd-contribuicoes-blocos-e-suas-funcoes/)
- [Bloco M da EFD Contribuições — SAAM](https://saamauditoria.com.br/noticias/bloco-m-da-efd-contribuicoes-tudo-que-voce-precisa-saber/)
- [ECD 2026 — Makrosystem](https://makrosystem.com.br/blog/escrituracao-contabil-digital-ecd/)
- [ECF 2025: Blocos — Jornal Contábil](https://www.jornalcontabil.com.br/noticia/ecf-2025-entenda-os-blocos-e-atencao-no-preenchimento/)
- [ECF Blocos de Composição — TOTVS](https://centraldeatendimento.totvs.com/hc/pt-br/articles/4410627721495-WINT-Quais-os-Blocos-de-Composi%C3%A7%C3%A3o-da-ECF)
- [ECF 2026: Prazos e Exigências — ContaJá](https://contaja.com.br/blog/ecf-e-ecd/)
- [EFD-Reinf em 2026 — InventSoftware](https://inventsoftware.com.br/en/financeiro/efd-reinf-em-2026-obrigacao-recorrente-cruzamentos-ativos-e-o-novo-padrao-de-governanca-fiscal)
- [EFD-Reinf: Guia Completo — Qive](https://qive.com.br/blog/efd-reinf)
- [Eventos EFD-Reinf — Questor](https://docs.questor.com.br/Produtos/Gest%C3%A3oCont%C3%A1bil/Fiscal/EFDReinf/Legisla%C3%A7%C3%A3o/eventos)
- [DCTFWeb x eSocial x EFD-Reinf — THS Brasil](https://thsbrasil.com.br/dctfweb-esocial-efd-reinf-diferencas-o-que-vai-em-cada-obrigacao/)
- [MIT — Módulo de Inclusão de Tributos — CFC](https://cfc.org.br/wp-content/uploads/2025/02/MIT-DCTFWeb-JAN-2025.pdf)
- [Manual DCTFWeb — e-Auditoria](https://www.e-auditoria.com.br/blog/manual-dctfweb-sobreviva-ao-mit-e-aos-novos-prazos-da-receita/)
- [DIRF em 2026 após extinção — Praxio](https://blog.praxio.com.br/dirf/)
- [PGDAS-D e DEFIS: novas regras de multa 2026 — Contábeis](https://www.contabeis.com.br/noticias/74391/pgdas-d-e-defis-novas-regras-de-multa-comecam-em-2026/)
- [Obrigações Acessórias 2026: Calendário — Questor](https://blog.questor.com.br/obrigacoes-acessorias-2026/)
- [Calendário Fiscal 2026 — ESN](https://escolasuperioresn.com.br/calendario-obrigacoes-fiscais-2026/)
- [Bloco H Inventário — SEFAZ-CE](https://www.sefaz.ce.gov.br/wp-content/uploads/sites/61/2024/09/Cartilha_Inventario_05.pdf)
- [Bloco H SPED Fiscal — TecnoSpeed](https://blog.tecnospeed.com.br/bloco-h/)
- [Bloco K do SPED Fiscal — Nomus](https://www.nomus.com.br/blog-industrial/bloco-k-do-sped-fiscal-entenda-o-que-e-para-que-serve/)
- [CIAP Bloco G — GESIF](https://www.gesif.com.br/2020/08/06/ciap-icms-como-calcular-como-entregar-bloco-g-2020/)
- [Reforma Tributária 2026: Guia Completo — Tax Group](https://www.taxgroup.com.br/intelligence/reforma-tributaria-2026-guia-completo-sobre-o-que-muda-e-a-transicao/)
- [Reforma Tributária: Guia de Sobrevivência — Jettax](https://www.jettax.com.br/blog/reforma-tributaria-guia-de-sobrevivencia-para-a-transicao-2026-2033/)
- [Estrutura de um arquivo SPED — LinkedIn](https://www.linkedin.com/pulse/qual-estrutura-de-um-arquivo-sped-rafael-botossi)
