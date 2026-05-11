# Pesquisa Tributaria Completa - Sistema ERP Brasil

> Documento de referencia para implementacao do modulo fiscal no OpticalCore ERP.
> Pesquisa realizada em 2026-03-02.

---

## Sumario

1. [ICMS - Imposto sobre Circulacao de Mercadorias e Servicos](#1-icms)
2. [IPI - Imposto sobre Produtos Industrializados](#2-ipi)
3. [PIS/COFINS](#3-piscofins)
4. [ISS - Imposto sobre Servicos](#4-iss)
5. [IRPJ e CSLL](#5-irpj-e-csll)
6. [Simples Nacional](#6-simples-nacional)
7. [Reforma Tributaria (EC 132/2023)](#7-reforma-tributaria)
8. [Tabelas Auxiliares Fiscais](#8-tabelas-auxiliares-fiscais)
9. [Padroes de Implementacao em ERP](#9-padroes-de-implementacao-em-erp)

---

## 1. ICMS

### 1.1 Conceito e Base de Calculo

O ICMS (Imposto sobre Circulacao de Mercadorias e Servicos) e um imposto estadual que incide sobre a circulacao de mercadorias, prestacao de servicos de transporte interestadual/intermunicipal e de comunicacao.

**Base de Calculo:**
```
Base ICMS = Valor da Mercadoria + Frete (CIF) + Seguro + Outras Despesas Acessorias - Descontos Incondicionais
```

**ICMS "por dentro"** - O ICMS integra sua propria base de calculo:
```
Base ICMS = Valor da Operacao / (1 - Aliquota ICMS)

Exemplo:
Produto = R$ 100,00, Aliquota = 18%
Base = 100 / (1 - 0,18) = R$ 121,95
ICMS = 121,95 x 18% = R$ 21,95
```

**Formula basica:**
```
ICMS = Base de Calculo x Aliquota ICMS

Exemplo simples:
Valor da operacao: R$ 1.000,00
Aliquota ICMS SP: 18%
ICMS = R$ 1.000,00 x 18% = R$ 180,00
```

### 1.2 Aliquotas Internas por Estado (2026)

| UF | Aliquota Modal | Observacoes |
|----|---------------|-------------|
| AC | 19% | - |
| AL | 19% | - |
| AM | 20% | - |
| AP | 18% | - |
| BA | 20,5% | - |
| CE | 20% | - |
| DF | 20% | - |
| ES | 17% | - |
| GO | 19% | - |
| MA | 22% | - |
| MG | 18% | - |
| MS | 17% | - |
| MT | 17% | - |
| PA | 19% | - |
| PB | 20% | - |
| PE | 20,5% | - |
| PI | 22,5% | A partir de 01/04/2025 (Lei 8558/2024) |
| PR | 19,5% | - |
| RJ | 22% | Inclui 2% FCP em muitos produtos |
| RN | 20% | - |
| RO | 19,5% | - |
| RR | 20% | - |
| RS | 17% | - |
| SC | 17% | - |
| SE | 19% | - |
| SP | 18% | - |
| TO | 20% | - |

**Nota:** Alem da aliquota modal, cada estado possui aliquotas diferenciadas para produtos especificos (combustiveis, energia, telecomunicacoes, bebidas alcoolicas, armas, etc.). Aliquotas reduzidas tambem existem para cesta basica, medicamentos genericos, etc.

### 1.3 Aliquotas Interestaduais

As aliquotas interestaduais sao definidas pelo Senado Federal:

| Origem / Destino | N/NE/CO/ES | S/SE (exceto ES) |
|-------------------|-----------|------------------|
| **S/SE (exceto ES)** | 7% | 12% |
| **N/NE/CO/ES** | 12% | 12% |
| **Produtos importados** | 4% | 4% |

**Regra resumida:**
- **7%**: De estados do Sul/Sudeste (exceto ES) para Norte/Nordeste/Centro-Oeste/ES
- **12%**: Demais operacoes interestaduais
- **4%**: Produtos importados ou com conteudo de importacao > 40% (Resolucao SF 13/2012)

### 1.4 ICMS-ST (Substituicao Tributaria)

Na substituicao tributaria, o imposto de toda a cadeia e recolhido antecipadamente por um unico contribuinte (normalmente o fabricante ou importador).

**Calculo do ICMS-ST:**

```
1. ICMS proprio = Base Calculo Propria x Aliquota Interna (ou Interestadual)

2. Base ICMS-ST = (Valor Produto + IPI + Frete + Seguro + Outras Despesas - Descontos) x (1 + MVA%)

3. ICMS-ST = (Base ICMS-ST x Aliquota Interna Destino) - ICMS Proprio
```

**Exemplo pratico:**
```
Valor do produto: R$ 1.000,00
IPI: R$ 100,00
Frete: R$ 25,00
Seguro: R$ 10,00
Outras despesas: R$ 30,00
MVA: 50%
Aliquota interestadual: 12%
Aliquota interna destino: 18%

Passo 1 - ICMS Proprio:
Base propria = R$ 1.000,00
ICMS proprio = R$ 1.000,00 x 12% = R$ 120,00

Passo 2 - Base ICMS-ST:
Subtotal = R$ 1.000,00 + R$ 100,00 + R$ 25,00 + R$ 10,00 + R$ 30,00 = R$ 1.165,00
Base ST = R$ 1.165,00 x (1 + 0,50) = R$ 1.747,50

Passo 3 - ICMS-ST:
ICMS-ST = (R$ 1.747,50 x 18%) - R$ 120,00
ICMS-ST = R$ 314,55 - R$ 120,00
ICMS-ST = R$ 194,55
```

### 1.5 MVA Ajustada (Operacoes Interestaduais)

Quando a operacao e interestadual, deve-se usar a MVA Ajustada:

```
MVA Ajustada = [(1 + MVA Original) x (1 - ALQ Inter) / (1 - ALQ Intra)] - 1

Exemplo:
MVA Original: 40% (0,40)
ALQ Interestadual: 12% (0,12)
ALQ Interna: 18% (0,18)

MVA Ajustada = [(1 + 0,40) x (1 - 0,12) / (1 - 0,18)] - 1
MVA Ajustada = [1,40 x 0,88 / 0,82] - 1
MVA Ajustada = [1,232 / 0,82] - 1
MVA Ajustada = 1,5024 - 1
MVA Ajustada = 50,24%
```

### 1.6 ICMS DIFAL (Diferencial de Aliquota) - EC 87/2015

O DIFAL e cobrado nas operacoes interestaduais destinadas a consumidor final (contribuinte ou nao).

**Formula (calculo "por dentro"):**
```
ICMS DIFAL = [(Voper - ICMS origem) / (1 - ALQ interna)] x ALQ interna - (Voper x ALQ interestadual)

Exemplo:
Valor operacao: R$ 1.000,00
ALQ Interestadual: 12%
ALQ Interna Destino: 18%

ICMS Origem = R$ 1.000,00 x 12% = R$ 120,00
Base DIFAL = (R$ 1.000,00 - R$ 120,00) / (1 - 0,18) = R$ 880,00 / 0,82 = R$ 1.073,17
ICMS DIFAL = (R$ 1.073,17 x 18%) - (R$ 1.000,00 x 12%)
ICMS DIFAL = R$ 193,17 - R$ 120,00
ICMS DIFAL = R$ 73,17
```

**Destinacao do DIFAL:**
- 100% para o estado de DESTINO (desde 2019)

### 1.7 Reducao de Base de Calculo

Beneficio fiscal que reduz a base sobre a qual o ICMS e calculado.

```
Base Reduzida = Base Original x Percentual de Reducao

Exemplo com reducao para 60%:
Valor da venda: R$ 1.000,00
Reducao: 60% (a base fica em 60% do valor original)
Aliquota ICMS: 18%

Nova base: R$ 1.000,00 x 60% = R$ 600,00
ICMS = R$ 600,00 x 18% = R$ 108,00
(Economia de R$ 72,00 comparado a tributacao integral de R$ 180,00)
```

**Exemplos de reducao por convenio CONFAZ:**
- Cesta basica: reducao para que a carga tributaria efetiva resulte em 7%
- Maquinas e implementos agricolas (Conv. ICMS 52/91): carga efetiva de 7% (interestadual) ou 5,6% (interna)
- Mercadorias usadas: reducao de ate 94% da base

### 1.8 Isencao e Nao Incidencia

**Isencao:** A operacao normalmente seria tributada, mas existe um beneficio fiscal que dispensa o pagamento (ex: medicamentos especificos, produtos da cesta basica em alguns estados).

**Nao Incidencia:** A operacao simplesmente nao se enquadra na hipotese de incidencia do ICMS (ex: exportacoes de mercadorias - CF Art. 155, X, a).

**Imunidade:** Garantia constitucional de nao tributacao (ex: exportacoes, livros, jornais, periodicos e papel destinado a impressao).

### 1.9 Credito de ICMS (Nao Cumulatividade)

O ICMS e um imposto nao cumulativo: compensa-se o valor devido em cada operacao com o montante cobrado nas operacoes anteriores.

```
Sistema de Debito e Credito:

ICMS a Recolher = ICMS nas Saidas (Debitos) - ICMS nas Entradas (Creditos)

Exemplo:
Compra de mercadoria: R$ 1.000,00 (ICMS credito: R$ 180,00)
Venda de mercadoria: R$ 1.500,00 (ICMS debito: R$ 270,00)

ICMS a Recolher = R$ 270,00 - R$ 180,00 = R$ 90,00
```

**Creditos permitidos:**
- Mercadorias adquiridas para revenda
- Insumos utilizados na producao
- Ativo imobilizado (1/48 avos por mes - CIAP)
- Servicos de transporte interestadual/intermunicipal
- Energia eletrica (uso no processo industrial)

**Creditos vedados:**
- Mercadorias para uso/consumo do estabelecimento (vedado ate 2033)
- Mercadorias alheias a atividade do estabelecimento
- Aquisicoes de contribuintes optantes pelo Simples Nacional (credito limitado)

### 1.10 ICMS sobre Frete

**Frete CIF (por conta do remetente):**
- O valor do frete INTEGRA a base de calculo do ICMS da mercadoria
- ICMS recolhido pelo remetente

**Frete FOB (por conta do destinatario):**
- O valor do frete NAO integra a base de calculo do ICMS da mercadoria
- O transportador emite CT-e com ICMS sobre o servico de transporte

**Aliquota ICMS sobre transporte:**
- Operacoes internas: aliquota interna do estado
- Operacoes interestaduais: 7% ou 12% (conforme regra geral)

### 1.11 FCP (Fundo de Combate a Pobreza)

Adicional ao ICMS previsto na EC 31/2000 para financiar programas sociais.

**Aliquotas por estado (variacao geral):**
- Maioria dos estados: 1% a 2%
- Rio de Janeiro: ate 4% (em alguns produtos)
- Amapa, Para, Santa Catarina: nao exigem FCP

```
Calculo FCP:
FCP = Base de Calculo ICMS x Aliquota FCP

Exemplo (RJ):
Base ICMS: R$ 1.000,00
Aliquota FCP: 2%
FCP = R$ 1.000,00 x 2% = R$ 20,00
```

**Campos NF-e:**
- `vBCFCP` - Base de calculo do FCP
- `pFCP` - Percentual do FCP
- `vFCP` - Valor do FCP
- `vBCFCPST` - Base FCP retido por ST
- `pFCPST` - Percentual FCP retido ST
- `vFCPST` - Valor FCP retido ST

### 1.12 Tabela CST ICMS (Tabela B - Tributacao)

| Codigo | Descricao |
|--------|-----------|
| 00 | Tributada integralmente |
| 10 | Tributada e com cobranca do ICMS por substituicao tributaria |
| 20 | Com reducao de base de calculo |
| 30 | Isenta ou nao tributada e com cobranca do ICMS por substituicao tributaria |
| 40 | Isenta |
| 41 | Nao tributada |
| 50 | Suspensao |
| 51 | Diferimento |
| 60 | ICMS cobrado anteriormente por substituicao tributaria |
| 70 | Com reducao de base de calculo e cobranca do ICMS por substituicao tributaria |
| 90 | Outros |

### 1.13 Tabela de Origem da Mercadoria (Tabela A - 1o digito do CST)

| Codigo | Descricao |
|--------|-----------|
| 0 | Nacional, exceto as indicadas nos codigos 3, 4, 5 e 8 |
| 1 | Estrangeira - Importacao direta, exceto a indicada no codigo 6 |
| 2 | Estrangeira - Adquirida no mercado interno, exceto a indicada no codigo 7 |
| 3 | Nacional, mercadoria com Conteudo de Importacao > 40% e <= 70% |
| 4 | Nacional, producao em conformidade com processos produtivos basicos (PPB) |
| 5 | Nacional, mercadoria com Conteudo de Importacao <= 40% |
| 6 | Estrangeira - Importacao direta, sem similar nacional (lista CAMEX) |
| 7 | Estrangeira - Adquirida no mercado interno, sem similar nacional (lista CAMEX) |
| 8 | Nacional, mercadoria com Conteudo de Importacao > 70% |

**Composicao do CST ICMS: `[Origem][Tributacao]` = 3 digitos**

Exemplo: CST `010` = Origem Nacional (0) + Tributada com ST (10)

### 1.14 Tabela CSOSN (Simples Nacional)

| Codigo | Descricao |
|--------|-----------|
| 101 | Tributada pelo Simples Nacional com permissao de credito |
| 102 | Tributada pelo Simples Nacional sem permissao de credito |
| 103 | Isencao do ICMS no Simples Nacional para faixa de receita bruta |
| 201 | Tributada pelo Simples Nacional com permissao de credito e com cobranca do ICMS por ST |
| 202 | Tributada pelo Simples Nacional sem permissao de credito e com cobranca do ICMS por ST |
| 203 | Isencao do ICMS no Simples Nacional para faixa de receita bruta e com cobranca do ICMS por ST |
| 300 | Imune |
| 400 | Nao tributada pelo Simples Nacional |
| 500 | ICMS cobrado anteriormente por substituicao tributaria (substituido) ou por antecipacao |
| 900 | Outros |

### 1.15 Campos ICMS no XML da NF-e

**Grupo ICMS00 (CST 00 - Tributada integralmente):**
```xml
<ICMS>
  <ICMS00>
    <orig>0</orig>          <!-- Origem da mercadoria (Tabela A) -->
    <CST>00</CST>            <!-- Codigo Situacao Tributaria -->
    <modBC>3</modBC>         <!-- Modalidade BC: 0=Margem, 1=Pauta, 2=Preco Tabelado, 3=Valor Operacao -->
    <vBC>1000.00</vBC>       <!-- Base de Calculo do ICMS -->
    <pICMS>18.00</pICMS>     <!-- Aliquota do ICMS -->
    <vICMS>180.00</vICMS>    <!-- Valor do ICMS -->
  </ICMS00>
</ICMS>
```

**Grupo ICMS10 (CST 10 - Tributada com ST):**
```xml
<ICMS>
  <ICMS10>
    <orig>0</orig>
    <CST>10</CST>
    <modBC>3</modBC>
    <vBC>1000.00</vBC>
    <pICMS>12.00</pICMS>
    <vICMS>120.00</vICMS>
    <modBCST>4</modBCST>     <!-- Modalidade BC ST: 4=Margem Valor Agregado -->
    <pMVAST>50.00</pMVAST>   <!-- Percentual MVA -->
    <vBCST>1747.50</vBCST>   <!-- Base de Calculo ST -->
    <pICMSST>18.00</pICMSST> <!-- Aliquota ST -->
    <vICMSST>194.55</vICMSST><!-- Valor ICMS ST -->
  </ICMS10>
</ICMS>
```

**Grupo ICMS20 (CST 20 - Reducao de Base):**
```xml
<ICMS>
  <ICMS20>
    <orig>0</orig>
    <CST>20</CST>
    <modBC>3</modBC>
    <pRedBC>40.00</pRedBC>   <!-- Percentual de Reducao da BC -->
    <vBC>600.00</vBC>
    <pICMS>18.00</pICMS>
    <vICMS>108.00</vICMS>
  </ICMS20>
</ICMS>
```

**Grupo ICMS60 (CST 60 - ICMS cobrado anteriormente por ST):**
```xml
<ICMS>
  <ICMS60>
    <orig>0</orig>
    <CST>60</CST>
    <vBCSTRet>1747.50</vBCSTRet>     <!-- BC ST retida anteriormente -->
    <pST>18.00</pST>                  <!-- Aliquota suportada pelo consumidor -->
    <vICMSSubstituto>120.00</vICMSSubstituto> <!-- ICMS proprio do substituto -->
    <vICMSSTRet>194.55</vICMSSTRet>   <!-- Valor ICMS ST retido anteriormente -->
  </ICMS60>
</ICMS>
```

---

## 2. IPI

### 2.1 Conceito e Base de Calculo

O IPI (Imposto sobre Produtos Industrializados) e um imposto federal que incide sobre produtos industrializados (transformacao, beneficiamento, montagem, acondicionamento, renovacao/recondicionamento).

**Base de Calculo:**
```
Venda: Base IPI = Valor da Operacao (preco do produto + frete + seguro + outras despesas)
Importacao: Base IPI = Valor Aduaneiro + II (Imposto de Importacao) + taxas de alfandega
```

**Formula:**
```
IPI = Base de Calculo x Aliquota IPI (conforme TIPI/NCM)

Exemplo:
Valor do produto: R$ 1.000,00
Aliquota IPI (NCM do produto): 10%
IPI = R$ 1.000,00 x 10% = R$ 100,00
```

**Importante:** O IPI NAO integra a base de calculo do ICMS (exceto quando o destinatario e consumidor final nao contribuinte do ICMS).

### 2.2 Aliquotas por NCM (TIPI)

A Tabela de Incidencia do IPI (TIPI) define as aliquotas por NCM:
- Aliquotas variam de **0% a 330%** (cigarro)
- Mais de 10.000 codigos NCM com aliquotas especificas
- Produtos essenciais tendem a ter aliquotas baixas (0% a 5%)
- Produtos de luxo e fumo tem aliquotas elevadas

**Exemplos de aliquotas:**
| NCM | Produto | Aliquota IPI |
|-----|---------|-------------|
| 9004.10.00 | Oculos de sol | 15% |
| 9004.90.10 | Oculos de protecao | 10% |
| 9001.50.00 | Lentes oftalmicas | 5% |
| 9003.11.00 | Armacoes de plastico | 10% |
| 9003.19.00 | Armacoes de outros materiais | 10% |

### 2.3 Tabela CST IPI

**Entradas:**

| Codigo | Descricao |
|--------|-----------|
| 00 | Entrada com recuperacao de credito |
| 01 | Entrada tributada com aliquota zero |
| 02 | Entrada isenta |
| 03 | Entrada nao tributada |
| 04 | Entrada imune |
| 05 | Entrada com suspensao |
| 49 | Outras entradas |

**Saidas:**

| Codigo | Descricao |
|--------|-----------|
| 50 | Saida tributada |
| 51 | Saida tributada com aliquota zero |
| 52 | Saida isenta |
| 53 | Saida nao tributada |
| 54 | Saida imune |
| 55 | Saida com suspensao |
| 99 | Outras saidas |

### 2.4 Credito de IPI

O IPI tambem e nao cumulativo:
```
IPI a Recolher = IPI nas Saidas (Debitos) - IPI nas Entradas (Creditos)
```

**Creditos permitidos:**
- Materias-primas, produtos intermediarios e material de embalagem (MP, PI, ME) adquiridos para emprego na industrializacao
- IPI pago na importacao de MP, PI, ME

**Creditos vedados:**
- Bens do ativo imobilizado
- Material de uso e consumo do estabelecimento

### 2.5 Suspensao e Isencao do IPI

**Suspensao:**
- Remessa para industrializacao (retorno em ate 180 dias)
- Exportacao (produtos saidos para exportacao)
- Remessa para a Zona Franca de Manaus

**Isencao:**
- Veiculos adaptados para portadores de deficiencia
- Produtos destinados a Zona Franca de Manaus (apos entrada)
- Amostra gratis de valor insignificante

**Imunidade:**
- Exportacao de produtos industrializados
- Livros, jornais, periodicos e o papel destinado a sua impressao
- Ouro como ativo financeiro

### 2.6 Campos IPI no XML da NF-e

```xml
<IPI>
  <cEnq>999</cEnq>           <!-- Codigo de Enquadramento Legal -->
  <IPITrib>                   <!-- Grupo IPI Tributado (CST 00 ou 50) -->
    <CST>50</CST>
    <vBC>1000.00</vBC>        <!-- Base de Calculo -->
    <pIPI>10.00</pIPI>        <!-- Aliquota -->
    <vIPI>100.00</vIPI>       <!-- Valor do IPI -->
  </IPITrib>
</IPI>

<!-- OU para CST 01-05, 49-55, 99 -->
<IPI>
  <cEnq>999</cEnq>
  <IPINT>                     <!-- Grupo IPI Nao Tributado -->
    <CST>52</CST>             <!-- Saida Isenta -->
  </IPINT>
</IPI>
```

---

## 3. PIS/COFINS

### 3.1 Conceito

**PIS** (Programa de Integracao Social) e **COFINS** (Contribuicao para o Financiamento da Seguridade Social) sao contribuicoes federais que incidem sobre o faturamento.

### 3.2 Regime Cumulativo

Aplicavel a empresas no **Lucro Presumido**.

```
Aliquotas:
- PIS: 0,65%
- COFINS: 3,00%
- Total: 3,65%

NAO ha direito a creditos.

Calculo:
PIS = Receita Bruta x 0,65%
COFINS = Receita Bruta x 3,00%

Exemplo:
Faturamento mensal: R$ 100.000,00
PIS = R$ 100.000,00 x 0,65% = R$ 650,00
COFINS = R$ 100.000,00 x 3,00% = R$ 3.000,00
Total = R$ 3.650,00
```

### 3.3 Regime Nao Cumulativo

Aplicavel a empresas no **Lucro Real**.

```
Aliquotas:
- PIS: 1,65%
- COFINS: 7,60%
- Total: 9,25%

HA direito a creditos sobre aquisicoes.

Calculo:
PIS Devido = (Receita Bruta x 1,65%) - Creditos PIS
COFINS Devido = (Receita Bruta x 7,60%) - Creditos COFINS

Exemplo:
Faturamento: R$ 100.000,00
Compras com credito: R$ 60.000,00

PIS Debito = R$ 100.000,00 x 1,65% = R$ 1.650,00
PIS Credito = R$ 60.000,00 x 1,65% = R$ 990,00
PIS a Recolher = R$ 1.650,00 - R$ 990,00 = R$ 660,00

COFINS Debito = R$ 100.000,00 x 7,60% = R$ 7.600,00
COFINS Credito = R$ 60.000,00 x 7,60% = R$ 4.560,00
COFINS a Recolher = R$ 7.600,00 - R$ 4.560,00 = R$ 3.040,00
```

### 3.4 Creditos Permitidos (Regime Nao Cumulativo)

De acordo com as Leis 10.637/2002 e 10.833/2003:

1. **Bens adquiridos para revenda** (exceto sujeitos a ST ou monofasico)
2. **Insumos** utilizados na fabricacao/prestacao de servicos (conceito do STJ: essencialidade ou relevancia)
3. **Energia eletrica** consumida nos estabelecimentos
4. **Alugueis** de predios, maquinas e equipamentos
5. **Depreciacao** de bens do ativo imobilizado adquiridos para uso na atividade
6. **Devolucoes** de vendas com tributacao
7. **Frete** na operacao de venda (quando onus do vendedor)
8. **Armazenagem** de mercadoria
9. **Vale-transporte, vale-refeicao/alimentacao** (quando pagos a empresa fornecedora)
10. **Bens de capital** incorporados ao ativo (credito em 1/48 ou integral em casos especificos)

### 3.5 Tributacao Monofasica

No regime monofasico, o PIS e COFINS sao recolhidos integralmente pelo fabricante/importador, com aliquotas elevadas. Os demais elos da cadeia (distribuidores e varejistas) revendem a **aliquota zero**.

**Setores com incidencia monofasica:**
- Combustiveis e lubrificantes
- Produtos farmaceuticos
- Cosmeticos e higiene pessoal
- Maquinas e veiculos
- Pneus
- Autospecas

**CST para revendedor:** CST 04 (Operacao Tributavel Monofasica - Revenda a Aliquota Zero)

### 3.6 Substituicao Tributaria PIS/COFINS

Similar ao monofasico, mas a responsabilidade pelo recolhimento e atribuida a um terceiro (substituto). CST 05.

### 3.7 Tabela CST PIS/COFINS

| Codigo | Descricao |
|--------|-----------|
| 01 | Operacao Tributavel com Aliquota Basica |
| 02 | Operacao Tributavel com Aliquota Diferenciada |
| 03 | Operacao Tributavel com Aliquota por Unidade de Medida de Produto |
| 04 | Operacao Tributavel Monofasica - Revenda a Aliquota Zero |
| 05 | Operacao Tributavel por Substituicao Tributaria |
| 06 | Operacao Tributavel a Aliquota Zero |
| 07 | Operacao Isenta da Contribuicao |
| 08 | Operacao sem Incidencia da Contribuicao |
| 09 | Operacao com Suspensao da Contribuicao |
| 49 | Outras Operacoes de Saida |
| 50 | Operacao com Direito a Credito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno |
| 51 | Operacao com Direito a Credito - Vinculada Exclusivamente a Receita Nao Tributada no Mercado Interno |
| 52 | Operacao com Direito a Credito - Vinculada Exclusivamente a Receita de Exportacao |
| 53 | Operacao com Direito a Credito - Vinculada a Receitas Tributadas e Nao-Tributadas no Mercado Interno |
| 54 | Operacao com Direito a Credito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportacao |
| 55 | Operacao com Direito a Credito - Vinculada a Receitas Nao-Tributadas no Mercado Interno e de Exportacao |
| 56 | Operacao com Direito a Credito - Vinculada a Receitas Tributadas e Nao-Tributadas no Mercado Interno e de Exportacao |
| 60 | Credito Presumido - Operacao de Aquisicao Vinculada Exclusivamente a Receita Tributada no Mercado Interno |
| 61 | Credito Presumido - Operacao de Aquisicao Vinculada Exclusivamente a Receita Nao-Tributada no Mercado Interno |
| 62 | Credito Presumido - Operacao de Aquisicao Vinculada Exclusivamente a Receita de Exportacao |
| 63 | Credito Presumido - Operacao de Aquisicao Vinculada a Receitas Tributadas e Nao-Tributadas no Mercado Interno |
| 64 | Credito Presumido - Operacao de Aquisicao Vinculada a Receitas Tributadas no Mercado Interno e de Exportacao |
| 65 | Credito Presumido - Operacao de Aquisicao Vinculada a Receitas Nao-Tributadas no Mercado Interno e de Exportacao |
| 66 | Credito Presumido - Operacao de Aquisicao Vinculada a Receitas Tributadas e Nao-Tributadas no Mercado Interno e de Exportacao |
| 67 | Credito Presumido - Outras Operacoes |
| 70 | Operacao de Aquisicao sem Direito a Credito |
| 71 | Operacao de Aquisicao com Isencao |
| 72 | Operacao de Aquisicao com Suspensao |
| 73 | Operacao de Aquisicao a Aliquota Zero |
| 74 | Operacao de Aquisicao sem Incidencia da Contribuicao |
| 75 | Operacao de Aquisicao por Substituicao Tributaria |
| 98 | Outras Operacoes de Entrada |
| 99 | Outras Operacoes |

### 3.8 Campos PIS/COFINS no XML da NF-e

```xml
<!-- PIS -->
<PIS>
  <PISAliq>                  <!-- PIS com aliquota ad valorem -->
    <CST>01</CST>            <!-- CST PIS -->
    <vBC>1000.00</vBC>       <!-- Base de Calculo -->
    <pPIS>1.65</pPIS>        <!-- Aliquota PIS -->
    <vPIS>16.50</vPIS>       <!-- Valor PIS -->
  </PISAliq>
</PIS>

<!-- COFINS -->
<COFINS>
  <COFINSAliq>               <!-- COFINS com aliquota ad valorem -->
    <CST>01</CST>            <!-- CST COFINS -->
    <vBC>1000.00</vBC>       <!-- Base de Calculo -->
    <pCOFINS>7.60</pCOFINS>  <!-- Aliquota COFINS -->
    <vCOFINS>76.00</vCOFINS> <!-- Valor COFINS -->
  </COFINSAliq>
</COFINS>

<!-- Para operacao monofasica (CST 04) -->
<PIS>
  <PISNT>
    <CST>04</CST>
  </PISNT>
</PIS>
<COFINS>
  <COFINSNT>
    <CST>04</CST>
  </COFINSNT>
</COFINS>
```

---

## 4. ISS

### 4.1 Conceito e Base de Calculo

O ISS (Imposto sobre Servicos de Qualquer Natureza) e um imposto municipal que incide sobre a prestacao de servicos listados na LC 116/2003.

**Base de Calculo:**
```
Base ISS = Preco do Servico

ISS = Base de Calculo x Aliquota ISS

Exemplo:
Preco do servico: R$ 5.000,00
Aliquota ISS: 5%
ISS = R$ 5.000,00 x 5% = R$ 250,00
```

### 4.2 Aliquotas

- **Minima:** 2% (fixada pela EC 37/2002)
- **Maxima:** 5% (fixada pela LC 116/2003)
- Cada municipio define suas aliquotas dentro desse intervalo por atividade

### 4.3 Lista de Servicos (LC 116/2003)

A lista contem 40 itens principais com centenas de subitens. Principais grupos:

| Item | Descricao |
|------|-----------|
| 1 | Servicos de informatica e congeneres |
| 2 | Servicos de pesquisas e desenvolvimento de qualquer natureza |
| 3 | Servicos prestados mediante locacao, cessao de direito de uso e congeneres |
| 4 | Servicos de saude, assistencia medica e congeneres |
| 5 | Servicos de medicina e assistencia veterinaria e congeneres |
| 6 | Servicos de cuidados pessoais, estetica, atividades fisicas e congeneres |
| 7 | Servicos relativos a engenharia, arquitetura, geologia, urbanismo e congeneres |
| 8 | Servicos de educacao, ensino, orientacao pedagogica e congeneres |
| 9 | Servicos relativos a hospedagem, turismo, viagens e congeneres |
| 10 | Servicos de intermediacao e congeneres |
| 11 | Servicos de guarda, estacionamento, armazenamento, vigilancia e congeneres |
| 12 | Servicos de diversoes, lazer, entretenimento e congeneres |
| 13 | Servicos relativos a fonografia, fotografia, cinematografia e reprografia |
| 14 | Servicos relativos a bens de terceiros |
| 15 | Servicos relacionados ao setor bancario ou financeiro |
| 16 | Servicos de transporte de natureza municipal |
| 17 | Servicos de apoio tecnico, administrativo, juridico, contabil, comercial e congeneres |
| 18-40 | Demais servicos especializados |

### 4.4 Retencao na Fonte

O ISS deve ser retido na fonte pelo tomador do servico em determinados casos:

**Subitens com retencao obrigatoria (Art. 6o, LC 116/2003):**
- 3.05 - Cessao de andaimes, palcos, coberturas
- 7.02 - Execucao de obra de construcao civil
- 7.04 - Demolicao
- 7.05 - Reparacao e reforma de edificios
- 7.09 - Varrição, coleta de lixo
- 7.10 - Limpeza e dragagem
- 7.12 - Controle e tratamento de efluentes
- 7.14 - Florestamento e reflorestamento
- 7.15 - Escoramento e contencao de encostas
- 7.16 - Limpeza e dragagem
- 7.17 - Acompanhamento e fiscalizacao de obra
- 7.19 - Pesquisa e perfuracao de pocos
- 11.02 - Vigilancia, seguranca ou monitoramento
- 17.05 - Fornecimento de mao-de-obra
- 17.10 - Planejamento, organizacao e administracao de feiras

**Importante:** Municipios podem ampliar a lista por lei local.

### 4.5 Local de Incidencia

**Regra geral:** ISS devido no municipio do estabelecimento prestador (Art. 3o, LC 116/2003).

**Excecoes (ISS devido no local da prestacao):**
- Construcao civil e servicos correlatos
- Servicos de vigilancia e seguranca
- Servicos de limpeza
- Servicos de diversao e lazer
- Servicos de transporte municipal
- Servicos portuarios e aeroportuarios

---

## 5. IRPJ e CSLL

### 5.1 Lucro Real

**IRPJ:**
```
Base de Calculo = Lucro Liquido Contabil + Adicoes - Exclusoes - Compensacoes

Aliquota IRPJ: 15% sobre o lucro
Adicional: 10% sobre a parcela que exceder R$ 20.000,00/mes (R$ 60.000,00/trimestre)

Exemplo (trimestral):
Lucro Real Trimestral: R$ 200.000,00
IRPJ = R$ 200.000,00 x 15% = R$ 30.000,00
Adicional = (R$ 200.000,00 - R$ 60.000,00) x 10% = R$ 14.000,00
Total IRPJ = R$ 30.000,00 + R$ 14.000,00 = R$ 44.000,00
```

**CSLL:**
```
Base de Calculo = Lucro Liquido Contabil ajustado

Aliquota padrao: 9%
Instituicoes financeiras: 20%

Exemplo:
Lucro base CSLL: R$ 200.000,00
CSLL = R$ 200.000,00 x 9% = R$ 18.000,00
```

**Apuracao:** Trimestral (encerramento Mar/Jun/Set/Dez) ou Anual (com estimativas mensais).

### 5.2 Lucro Presumido

No Lucro Presumido, a base de calculo e determinada aplicando percentuais sobre a receita bruta.

**Percentuais de Presuncao - IRPJ:**

| Atividade | Percentual |
|-----------|-----------|
| Revenda de combustiveis e gas natural | 1,6% |
| Comercio em geral | 8% |
| Industria | 8% |
| Transporte de cargas | 8% |
| Servicos hospitalares e de saude | 8% |
| Transporte de passageiros | 16% |
| Prestacao de servicos em geral | 32% |
| Intermediacao de negocios | 32% |
| Administracao, locacao de bens moveis/imoveis | 32% |

**Percentuais de Presuncao - CSLL:**

| Atividade | Percentual |
|-----------|-----------|
| Comercio e industria | 12% |
| Prestacao de servicos em geral | 32% |

**Formula Lucro Presumido:**
```
Base IRPJ = Receita Bruta x Percentual de Presuncao (IRPJ)
IRPJ = Base x 15% + Adicional 10% (se base trimestral > R$ 60.000)

Base CSLL = Receita Bruta x Percentual de Presuncao (CSLL)
CSLL = Base x 9%

Exemplo (Comercio, Trimestral):
Receita Bruta Trimestral: R$ 500.000,00

IRPJ:
Base = R$ 500.000,00 x 8% = R$ 40.000,00
IRPJ = R$ 40.000,00 x 15% = R$ 6.000,00
Adicional = R$ 0 (base < R$ 60.000)
Total IRPJ = R$ 6.000,00

CSLL:
Base = R$ 500.000,00 x 12% = R$ 60.000,00
CSLL = R$ 60.000,00 x 9% = R$ 5.400,00
```

### 5.3 Simples Nacional

No Simples Nacional, IRPJ e CSLL sao recolhidos unificados no DAS, com aliquotas progressivas conforme o faturamento. Veja secao 6.

### 5.4 Mudancas a partir de 2026

A LC 224/2025 introduziu acrescimo de 10% nos percentuais de presuncao para empresas com receita bruta anual acima de R$ 5 milhoes.

---

## 6. Simples Nacional

### 6.1 Visao Geral

Regime tributario simplificado para ME (Microempresas: ate R$ 360.000/ano) e EPP (Empresas de Pequeno Porte: ate R$ 4.800.000/ano).

**Tributos unificados no DAS:**
- IRPJ, CSLL, PIS/Pasep, COFINS, CPP (contribuicao previdenciaria patronal)
- ICMS (Anexos I, II e III)
- ISS (Anexos III, IV e V)
- IPI (Anexo II)

### 6.2 Formula de Calculo

```
Aliquota Efetiva = [(RBT12 x Aliquota Nominal) - Parcela a Deduzir] / RBT12

DAS = Receita Mensal x Aliquota Efetiva

Onde:
- RBT12 = Receita Bruta acumulada nos 12 meses anteriores
- Aliquota Nominal = percentual da tabela do Anexo correspondente
- Parcela a Deduzir = valor fixo da tabela do Anexo correspondente
```

### 6.3 Anexo I - Comercio

| Faixa | Receita Bruta 12 meses (R$) | Aliquota Nominal | Parcela a Deduzir (R$) |
|-------|---------------------------|-----------------|----------------------|
| 1a | Ate 180.000,00 | 4,00% | 0,00 |
| 2a | De 180.000,01 a 360.000,00 | 7,30% | 5.940,00 |
| 3a | De 360.000,01 a 720.000,00 | 9,50% | 13.860,00 |
| 4a | De 720.000,01 a 1.800.000,00 | 10,70% | 22.500,00 |
| 5a | De 1.800.000,01 a 3.600.000,00 | 14,30% | 87.300,00 |
| 6a | De 3.600.000,01 a 4.800.000,00 | 19,00% | 378.000,00 |

**Partilha dos tributos (1a a 5a faixa):**
IRPJ 5,50% | CSLL 3,50% | COFINS 12,74% | PIS/Pasep 2,76% | CPP 41,50% | ICMS 34,00%

**Exemplo Anexo I:**
```
Empresa de comercio
RBT12 = R$ 500.000,00 (3a faixa)
Receita do mes = R$ 50.000,00

Aliquota Efetiva = [(500.000 x 9,50%) - 13.860] / 500.000
Aliquota Efetiva = [47.500 - 13.860] / 500.000
Aliquota Efetiva = 33.640 / 500.000
Aliquota Efetiva = 6,728%

DAS = R$ 50.000,00 x 6,728% = R$ 3.364,00
```

### 6.4 Anexo II - Industria

| Faixa | Receita Bruta 12 meses (R$) | Aliquota Nominal | Parcela a Deduzir (R$) |
|-------|---------------------------|-----------------|----------------------|
| 1a | Ate 180.000,00 | 4,50% | 0,00 |
| 2a | De 180.000,01 a 360.000,00 | 7,80% | 5.940,00 |
| 3a | De 360.000,01 a 720.000,00 | 10,00% | 13.860,00 |
| 4a | De 720.000,01 a 1.800.000,00 | 11,20% | 22.500,00 |
| 5a | De 1.800.000,01 a 3.600.000,00 | 14,70% | 85.500,00 |
| 6a | De 3.600.000,01 a 4.800.000,00 | 30,00% | 720.000,00 |

**Partilha dos tributos (1a a 5a faixa):**
IRPJ 5,50% | CSLL 3,50% | COFINS 11,51% | PIS/Pasep 2,49% | CPP 37,50% | IPI 7,50% | ICMS 32,00%

### 6.5 Anexo III - Servicos (Receitas de locacao de bens moveis, agencias de viagem, etc.)

| Faixa | Receita Bruta 12 meses (R$) | Aliquota Nominal | Parcela a Deduzir (R$) |
|-------|---------------------------|-----------------|----------------------|
| 1a | Ate 180.000,00 | 6,00% | 0,00 |
| 2a | De 180.000,01 a 360.000,00 | 11,20% | 9.360,00 |
| 3a | De 360.000,01 a 720.000,00 | 13,50% | 17.640,00 |
| 4a | De 720.000,01 a 1.800.000,00 | 16,00% | 35.640,00 |
| 5a | De 1.800.000,01 a 3.600.000,00 | 21,00% | 125.640,00 |
| 6a | De 3.600.000,01 a 4.800.000,00 | 33,00% | 648.000,00 |

**Partilha (1a faixa):**
IRPJ 4,00% | CSLL 3,50% | COFINS 12,82% | PIS/Pasep 2,78% | CPP 43,40% | ISS 33,50%

### 6.6 Anexo IV - Servicos (vigilancia, limpeza, obras)

| Faixa | Receita Bruta 12 meses (R$) | Aliquota Nominal | Parcela a Deduzir (R$) |
|-------|---------------------------|-----------------|----------------------|
| 1a | Ate 180.000,00 | 4,50% | 0,00 |
| 2a | De 180.000,01 a 360.000,00 | 9,00% | 8.100,00 |
| 3a | De 360.000,01 a 720.000,00 | 10,20% | 12.420,00 |
| 4a | De 720.000,01 a 1.800.000,00 | 14,00% | 39.780,00 |
| 5a | De 1.800.000,01 a 3.600.000,00 | 22,00% | 183.780,00 |
| 6a | De 3.600.000,01 a 4.800.000,00 | 33,00% | 828.000,00 |

**Importante:** O Anexo IV NAO inclui CPP. A empresa recolhe CPP separadamente (20% sobre a folha).

### 6.7 Anexo V - Servicos (intelectuais, tecnicos)

| Faixa | Receita Bruta 12 meses (R$) | Aliquota Nominal | Parcela a Deduzir (R$) |
|-------|---------------------------|-----------------|----------------------|
| 1a | Ate 180.000,00 | 15,50% | 0,00 |
| 2a | De 180.000,01 a 360.000,00 | 18,00% | 4.500,00 |
| 3a | De 360.000,01 a 720.000,00 | 19,50% | 9.900,00 |
| 4a | De 720.000,01 a 1.800.000,00 | 20,50% | 17.100,00 |
| 5a | De 1.800.000,01 a 3.600.000,00 | 23,00% | 62.100,00 |
| 6a | De 3.600.000,01 a 4.800.000,00 | 30,50% | 540.000,00 |

**Nota:** Empresas do Anexo V com fator "r" (folha de pagamento / receita bruta) >= 28% migram para o Anexo III, com aliquotas menores.

### 6.8 Sublimite Estadual ICMS/ISS

- Sublimite de R$ 3.600.000,00 para ICMS e ISS
- Empresas que ultrapassam o sublimite mas ficam abaixo de R$ 4.800.000 continuam no Simples para tributos federais
- ICMS e ISS passam a ser recolhidos separadamente, conforme legislacao estadual/municipal

### 6.9 Credito de ICMS para Destinatarios

Empresas do Simples Nacional que emitem NF-e com CSOSN 101 ou 201 podem transferir credito de ICMS ao destinatario:
```
Credito permitido = Aliquota efetiva x Percentual de ICMS na partilha do Anexo

Exemplo (Anexo I, 3a faixa):
Aliquota Efetiva: 6,728%
Percentual ICMS na partilha: 34%
Credito ICMS = 6,728% x 34% = 2,2875%
```

---

## 7. Reforma Tributaria (EC 132/2023)

### 7.1 Novos Tributos

A EC 132/2023, regulamentada pela LC 214/2025, cria:

| Tributo | Substitui | Esfera |
|---------|-----------|--------|
| **CBS** (Contribuicao sobre Bens e Servicos) | PIS + COFINS + IPI | Federal |
| **IBS** (Imposto sobre Bens e Servicos) | ICMS + ISS | Estadual + Municipal |
| **IS** (Imposto Seletivo) | (novo) | Federal |

### 7.2 Cronograma de Transicao

| Ano | Evento |
|-----|--------|
| **2026** | Fase de testes: CBS 0,9% + IBS 0,1% (compensaveis com PIS/COFINS) |
| **2027** | CBS em vigor pleno. Extincao de PIS e COFINS. IPI zerado (exceto ZFM). IS em vigor |
| **2028** | CBS continua em vigor. IBS 0,1% mantido |
| **2029** | Inicio da transicao ICMS/ISS -> IBS. IBS com aliquota de 10% da referencia |
| **2030** | IBS com 20% da aliquota de referencia. Reducao proporcional de ICMS/ISS |
| **2031** | IBS com 30% da aliquota de referencia |
| **2032** | IBS com 40% da aliquota de referencia |
| **2033** | Extincao completa de ICMS e ISS. IBS em 100% |

### 7.3 Principios Fundamentais

- **Nao cumulatividade plena**: credito financeiro amplo em toda a cadeia
- **Destino**: tributo pertence ao local de consumo (nao de producao)
- **Aliquota unica por ente federativo**: sem guerra fiscal
- **Cashback tributario**: devolucao de tributos para familias de baixa renda (CadUnico)

### 7.4 Split Payment

O split payment e o mecanismo de recolhimento automatico do tributo no momento do pagamento:

**Modalidades previstas:**
1. **Completo on-line**: Abatimento automatico de creditos no momento do pagamento
2. **Completo off-line**: Retencao temporaria em caso de falha de sistema
3. **Simplificado**: Retencao por media de carga tributaria definida pelo Fisco

**Implementacao:** A partir de 2027, de forma facultativa e gradual. Integracao com meios de pagamento (PIX, cartoes, boletos).

### 7.5 Imposto Seletivo (IS)

Incide sobre produtos prejudiciais a saude ou ao meio ambiente:
- Bebidas alcoolicas
- Tabaco
- Bebidas acucaradas
- Veiculos poluentes
- Mineracao (extracao de minerios)

### 7.6 Impacto em ERPs

**Periodo de transicao (2026-2033):**
- Necessidade de calcular tributos antigos E novos simultaneamente
- Novos campos no XML da NF-e para IBS, CBS e IS (mais de 200 novos campos)
- Novos registros para devolucoes e regimes especiais
- Campo para indicar operacoes sujeitas a cashback tributario
- Dupla escrituracao durante a transicao

**Campos novos no XML NF-e (a partir de 2026):**
```xml
<gIBSCBS>
  <!-- Grupo IBS e CBS por item -->
  <CST>...</CST>
  <vBC>...</vBC>
  <pIBS>...</pIBS>
  <vIBS>...</vIBS>
  <pCBS>...</pCBS>
  <vCBS>...</vCBS>
</gIBSCBS>
<gIS>
  <!-- Grupo Imposto Seletivo -->
  <CST>...</CST>
  <vBC>...</vBC>
  <pIS>...</pIS>
  <vIS>...</vIS>
</gIS>
```

---

## 8. Tabelas Auxiliares Fiscais

### 8.1 NCM (Nomenclatura Comum do Mercosul)

Codigo de 8 digitos que classifica mercadorias:

```
Estrutura: XX.XX.XX.XX
            |  |  |  |
            |  |  |  +-- Subitem (Mercosul)
            |  |  +----- Item (Mercosul)
            |  +-------- Subposicao (SH Internacional)
            +----------- Capitulo.Posicao (SH Internacional)

Exemplo: 9004.10.00 = Oculos de sol
- 90: Capitulo (Instrumentos e aparelhos de optica)
- 04: Posicao (Oculos)
- 10: Subposicao (de sol)
- 00: Item/Subitem
```

**Utilizacao no ERP:**
- Definir aliquota IPI (via TIPI)
- Classificar produto para ICMS-ST (via CEST)
- Apuracao de PIS/COFINS (monofasico, aliquota zero, etc.)
- Determinacao de beneficios fiscais
- Obrigacoes acessorias (SPED, DCTF, etc.)

### 8.2 CFOP (Codigo Fiscal de Operacoes e Prestacoes)

Codigo de 4 digitos que identifica a natureza da operacao:

```
Estrutura: X.XXX
           |
           +-- 1o digito indica tipo e origem/destino:

ENTRADAS:
1.XXX = Entradas/aquisicoes dentro do estado
2.XXX = Entradas/aquisicoes de outros estados
3.XXX = Entradas/aquisicoes do exterior

SAIDAS:
5.XXX = Saidas/prestacoes dentro do estado
6.XXX = Saidas/prestacoes para outros estados
7.XXX = Saidas/prestacoes para o exterior
```

**CFOPs mais utilizados em oticas/comercio:**

| CFOP | Descricao |
|------|-----------|
| **Entradas** | |
| 1.102 / 2.102 | Compra para comercializacao |
| 1.202 / 2.202 | Devolucao de venda de mercadoria |
| 1.401 / 2.401 | Compra para industrializacao com ST |
| 1.403 / 2.403 | Compra para comercializacao com ST |
| 1.556 / 2.556 | Compra de material de uso ou consumo |
| 1.551 / 2.551 | Compra de ativo imobilizado |
| 1.910 / 2.910 | Entrada de bonificacao |
| **Saidas** | |
| 5.102 / 6.102 | Venda de mercadoria adquirida |
| 5.202 / 6.202 | Devolucao de compra para comercializacao |
| 5.405 | Venda de mercadoria adquirida com ST (substituido) |
| 5.910 / 6.910 | Remessa em bonificacao |
| 5.927 | Lancamento a titulo de baixa de estoque |
| 5.949 / 6.949 | Outra saida de mercadoria nao especificada |
| 7.101 | Venda de producao para o exterior (exportacao) |

### 8.3 CEST (Codigo Especificador da Substituicao Tributaria)

Codigo de 7 digitos que identifica mercadorias sujeitas a ST:

```
Estrutura: XX.XXX.XX
           |  |    |
           |  |    +-- Especificacao do item
           |  +------- Item do segmento
           +---------- Segmento da mercadoria

28 segmentos definidos pelo CONFAZ
```

**Exemplos de segmentos:**
| Segmento | Descricao |
|----------|-----------|
| 01 | Autopecas |
| 02 | Bebidas alcoolicas (exceto cerveja e chope) |
| 03 | Cervejas, chopes, refrigerantes e agua |
| 09 | Ferramentas |
| 13 | Materiais de construcao |
| 17 | Produtos alimenticios |
| 20 | Produtos de limpeza |
| 21 | Produtos de perfumaria e higiene pessoal |
| 28 | Veiculos automotores |

### 8.4 CNAE (Classificacao Nacional de Atividades Economicas)

Codigo de 7 digitos que classifica a atividade economica:

```
Estrutura: XXXX-X/XX
           |    | |
           |    | +-- Subclasse (2 digitos)
           |    +---- Classe (1 digito verificador)
           +--------- Divisao.Grupo (4 digitos)

Hierarquia:
Secao (letra A a U) > Divisao (2 digitos) > Grupo (3 digitos) > Classe (5 digitos) > Subclasse (7 digitos)
```

**Exemplos para oticas:**
| CNAE | Descricao |
|------|-----------|
| 4774-1/00 | Comercio varejista de artigos de optica |
| 3250-7/04 | Fabricacao de aparelhos e utensilios para correcao de defeitos fisicos (opticos) |
| 4773-3/00 | Comercio varejista de artigos medicos e ortopedicos |

**Utilizacao no ERP:**
- Enquadramento tributario (Simples Nacional, regimes especiais)
- Definicao de obrigacoes acessorias
- Calculo de contribuicao previdenciaria (desoneracoes)
- Emissao de NF-e e NFS-e
- RAIS, CAGED e outras obrigacoes trabalhistas

### 8.5 Natureza da Operacao

Campo descritivo obrigatorio na NF-e que descreve o tipo de transacao:

| Natureza | CFOP Associado | Descricao |
|----------|---------------|-----------|
| Venda | 5.102 / 6.102 | Venda de mercadoria adquirida ou recebida de terceiros |
| Compra | 1.102 / 2.102 | Compra para comercializacao |
| Devolucao de Venda | 1.202 / 2.202 | Devolucao de venda de mercadoria |
| Devolucao de Compra | 5.202 / 6.202 | Devolucao de compra para comercializacao |
| Transferencia | 5.152 / 6.152 | Transferencia de mercadoria adquirida |
| Remessa para Conserto | 5.915 / 6.915 | Remessa de mercadoria para conserto |
| Retorno de Conserto | 5.916 / 6.916 | Retorno de mercadoria de conserto |
| Remessa em Demonstracao | 5.912 / 6.912 | Remessa de mercadoria em demonstracao |
| Bonificacao | 5.910 / 6.910 | Remessa em bonificacao, doacao ou brinde |
| Amostra Gratis | 5.911 / 6.911 | Remessa de amostra gratis |
| Simples Remessa | 5.949 / 6.949 | Outra saida de mercadoria nao especificada |

---

## 9. Padroes de Implementacao em ERP

### 9.1 Arquitetura do Motor Fiscal

```
+-------------------+     +-------------------+     +-------------------+
| Cadastro Produto  |     | Cadastro Empresa  |     | Cadastro Pessoa   |
| - NCM             |     | - Regime Tributario|    | - UF              |
| - CEST            |     | - CNAE            |     | - Contribuinte?   |
| - Origem (0-8)    |     | - Inscr.Estadual  |     | - Consumidor Final|
| - Aliquota IPI    |     | - UF              |     +-------------------+
| - CST ICMS/IPI/   |     +-------------------+
|   PIS/COFINS      |
+-------------------+

         |                       |                         |
         v                       v                         v
+------------------------------------------------------------------+
|                    MOTOR DE CALCULO FISCAL                        |
|                                                                   |
|  1. Identificar operacao (CFOP / Natureza)                       |
|  2. Determinar regime tributario da empresa                       |
|  3. Identificar UF origem e destino                              |
|  4. Classificar produto (NCM/CEST)                               |
|  5. Aplicar regras de tributacao:                                 |
|     a. ICMS (proprio, ST, DIFAL, reducao, isencao)               |
|     b. IPI (tributado, isento, suspenso, NT)                     |
|     c. PIS/COFINS (cumulativo, nao cumulativo, monofasico)       |
|     d. FCP (adicional por estado)                                |
|  6. Verificar beneficios fiscais (convenios CONFAZ)              |
|  7. Calcular totais                                              |
|  8. Gerar XML NF-e                                               |
+------------------------------------------------------------------+
         |
         v
+-------------------+     +-------------------+     +-------------------+
| XML NF-e          |     | Escrituracao       |    | Apuracao           |
| - ICMS            |     | - Livro Entradas  |     | - ICMS mensal     |
| - IPI             |     | - Livro Saidas    |     | - IPI mensal      |
| - PIS/COFINS      |     | - SPED EFD        |     | - PIS/COFINS      |
| - FCP             |     |                   |     | - DAS (Simples)   |
+-------------------+     +-------------------+     +-------------------+
```

### 9.2 Entidades de Dominio Sugeridas

```
RegraFiscal
  - Id
  - UfOrigem
  - UfDestino
  - NcmDe / NcmAte (faixa)
  - CfopEntrada / CfopSaida
  - CstIcms
  - AliquotaIcms
  - AliquotaIcmsSt
  - MvaOriginal
  - CstIpi
  - AliquotaIpi
  - CstPis / CstCofins
  - AliquotaPis / AliquotaCofins
  - PercentualReducaoBC
  - PercentualFcp
  - Vigencia (DataInicio / DataFim)

ConfiguracaoFiscalEmpresa
  - RegimeTributario (SimplesNacional, LucroPresumido, LucroReal)
  - ContribuinteIcms
  - SubstitutoTributario
  - IncentivadorCultural
  - RegimeEspecial

ParametroFiscalProduto
  - ProdutoId
  - Ncm
  - Cest
  - ExTipi (excecao TIPI)
  - Origem (0-8)
  - UnidadeTributavel
  - CstIcms / CsosnIcms
  - CstIpi
  - CstPis / CstCofins
  - AliquotaIcms
  - PercentualReducaoBC
  - AliquotaIpi
  - AliquotaPis / AliquotaCofins
  - Monofasico (bool)
  - SujeitoST (bool)

AliquotaIcmsInterestadual
  - UfOrigem
  - UfDestino
  - Aliquota (7%, 12% ou 4%)

AliquotaIcmsInterna
  - Uf
  - AliquotaModal
  - AliquotaDiferenciada (por NCM ou segmento)

MvaSubstituicaoTributaria
  - Uf
  - Ncm
  - Cest
  - MvaOriginal
  - MvaAjustada
  - Vigencia
```

### 9.3 Fluxo de Calculo por Operacao

**Venda Interna (mesma UF):**
```
1. Base ICMS = Valor Produto + Frete + Seguro + Outras Despesas - Desconto
2. ICMS = Base x Aliquota Interna
3. Se ST: Calcular ICMS-ST com MVA Original
4. IPI (se industria) = Base IPI x Aliquota NCM
5. PIS = Base x Aliquota PIS
6. COFINS = Base x Aliquota COFINS
7. FCP = Base ICMS x Aliquota FCP (se aplicavel)
```

**Venda Interestadual (para contribuinte):**
```
1. Base ICMS = Valor Produto + Frete + Seguro + Outras Despesas - Desconto
2. ICMS = Base x Aliquota Interestadual (7%, 12% ou 4%)
3. Se ST: Calcular ICMS-ST com MVA Ajustada
4. DIFAL = Se destinatario contribuinte, calcular diferencial
5. IPI = Base IPI x Aliquota NCM
6. PIS/COFINS = conforme regime
7. FCP-ST (se aplicavel)
```

**Venda Interestadual (consumidor final nao contribuinte):**
```
1. Base ICMS = Valor Produto + Frete + Seguro + Outras Despesas - Desconto
2. ICMS = Base x Aliquota Interestadual
3. DIFAL = Base x (Aliquota Interna Destino - Aliquota Interestadual)
   -> 100% para estado de destino
4. FCP DIFAL = Base x Aliquota FCP destino (se aplicavel)
5. PIS/COFINS = conforme regime
```

### 9.4 Edge Cases e Excecoes Comuns

1. **Produto importado**: Aliquota interestadual de 4% (Resolucao SF 13/2012)
2. **Zona Franca de Manaus**: IPI suspenso/isento, ICMS com beneficios especificos
3. **Simples Nacional como substituto tributario**: Empresas do SN podem ser obrigadas a recolher ICMS-ST
4. **ICMS monofasico para combustiveis**: Aliquota unica em centavos por litro (nao ad valorem)
5. **Diferimento parcial**: Parte do ICMS e diferida para etapa posterior (CST 51)
6. **Desoneracoes de ICMS**: CFOP 5.927 para baixa de estoque, sem destaque de ICMS
7. **Cesta basica**: Aliquotas reduzidas variam drasticamente entre estados
8. **Bonificacao**: Pode ter incidencia de ICMS dependendo do estado
9. **Amostra gratis**: IPI suspenso, ICMS pode incidir dependendo da legislacao estadual
10. **Servico com mercadoria**: Operacao mista pode ter incidencia de ICMS + ISS

### 9.5 Obrigacoes Acessorias Principais

| Obrigacao | Periodicidade | Descricao |
|-----------|--------------|-----------|
| SPED EFD ICMS/IPI | Mensal | Escrituracao fiscal digital |
| SPED EFD Contribuicoes | Mensal | Escrituracao de PIS/COFINS |
| SPED ECF | Anual | Escrituracao Contabil Fiscal (IRPJ/CSLL) |
| DCTF | Mensal | Declaracao de debitos e creditos tributarios federais |
| GIA (ou SPED) | Mensal | Guia de informacao e apuracao do ICMS |
| PGDAS-D | Mensal | Apuracao do Simples Nacional |
| DEFIS | Anual | Declaracao de informacoes do Simples Nacional |
| DIRF | Anual | Declaracao do IR retido na fonte |
| DeSTDA | Mensal | Declaracao de ST, DIFAL e antecipacao (Simples Nacional) |

---

## Fontes Consultadas

### ICMS
- [Tabela ICMS 2026 - NSDocs](https://nsdocs.com.br/blog/tabela-icms)
- [ICMS Interestadual 2026 - WebMais](https://webmaissistemas.com.br/blog/icms-interestadual/)
- [Tabela ICMS 2026 - Inforsystem](https://www.inforsystem.com/artigos/33-documentos-fiscais/353-tabela-de-aliquotas-de-icms-internas-e-interestaduais-2026)
- [Tabela ICMS 2026 - Tributo Devido](https://tributodevido.com.br/tabela-icms-2026-aliquotas-atualizadas-todos-estados-brasileiros/)
- [Calculo ICMS ST - Tributei](https://tributei.net/blog/como-calcular-o-icms-substituicao-tributaria-st/)
- [Substituicao Tributaria - Portal ST](https://www.substituicaotributaria.com/SST/substituicao-tributaria/regra-geral/5/calculo-do-icms--st)
- [Calculo MVA - SEFAZ PR](https://www.fazenda.pr.gov.br/Pagina/Calculo-da-MVA)
- [MVA Ajustada - SEFAZ PE](https://www.sefaz.pe.gov.br/Servicos/Substituicao-Tributaria/Paginas/Formula-da-MVA-Ajustada.aspx)
- [DIFAL - SEFAZ SP](https://portal.fazenda.sp.gov.br/servicos/icms/Paginas/DIFAL.aspx)
- [DIFAL 2026 - Genyo](https://genyo.com.br/difal/)
- [Reducao Base Calculo ICMS - SimTax](https://simtax.com.br/reducao-base-calculo-icms/)
- [Credito ICMS - Portal Tributario](https://www.portaltributario.com.br/tributario/creditoicms.htm)
- [ICMS sobre Frete - Contabeis](https://www.contabeis.com.br/artigos/6834/voce-sabe-o-que-e-icms-sobre-o-frete-e-quem-deve-pagar-esse-imposto/)

### CST/CSOSN
- [CST ICMS - CDM Contabilidade](https://cdmcontabilidade.com.br/tabela-cst-icms/)
- [CST ICMS - Webmania](https://ajuda.webmania.com.br/pt-BR/articles/12680777-cst-o-que-significa-cada-codigo-de-situacao-tributaria-do-icms)
- [CST - TecnoSpeed](https://blog.tecnospeed.com.br/tabela-cst/)
- [CSOSN - Sygma](https://www.sygmasistemas.com.br/csosn/)
- [CSOSN - Webmania](https://ajuda.webmania.com.br/pt-BR/articles/12680770-csosn-o-que-significa-cada-codigo-de-situacao-tributaria-do-icms)
- [Origem Mercadoria - SEFAZ PB](https://www.sefaz.pb.gov.br/legislacao/99-regulamentos/anexos-icms/1532-anexo-14-codigo-de-situacao-tributaria-cst)

### FCP
- [FCP - TecnoSpeed](https://blog.tecnospeed.com.br/fundo-de-combate-a-pobreza/)
- [FCP Aliquotas - Avalara](https://www.avalara.com/br/pt/blog/2025/09/fundo-de-combate-a-pobreza-o-que-e-al-quotas.html)
- [FCP - SimTax](https://simtax.com.br/fundo-combate-pobreza-fcp/)

### IPI
- [IPI - Maxiprod](https://maxiprod.com.br/ajuda/fiscal/ipi/)
- [IPI - Serasa](https://www.serasaexperian.com.br/conteudos/calcular-o-imposto-sobre-produtos-industrializados/)
- [CST IPI - CDM](https://cdmcontabilidade.com.br/tabela-cst-ipi/)
- [TIPI - Planalto](https://www.planalto.gov.br/ccivil_03/_Ato2019-2022/2021/Decreto/Anexo/ANDEC10923.pdf)
- [ZFM - SUFRAMA](http://www.suframa.gov.br/noticias/arquivos/cartilha_incentivos_fiscais_port_vf_04_10_2014.pdf)

### PIS/COFINS
- [PIS COFINS Cumulativo/Nao Cumulativo - Jettax](https://www.jettax.com.br/blog/pis-cofins-cumulativo-e-nao-cumulativo/)
- [Monofasico - E-Simples](https://www.esimplesauditoria.com/incidencia-monofasica-de-pis-e-cofins)
- [CST PIS COFINS - CDM](https://cdmcontabilidade.com.br/tabela-cst-pis-cofins/)
- [CST PIS COFINS - Guinzo](https://site.guinzo.com.br/tabela-cst-pis-cofins/)
- [Creditos PIS COFINS - Portal Tributario](https://www.portaltributario.com.br/tributos/cofins_mp135.html)
- [Creditos Nao Cumulativo - RecuperaSimples](https://recuperasimples.com.br/aproveitamento-de-credito-do-pis-e-cofins-no-regime-nao-cumulativo/)

### ISS
- [LC 116/2003 - Planalto](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp116.htm)
- [Retencao ISS - Portal Auditoria](https://portaldeauditoria.com.br/retencao-do-iss/)
- [ISS SP - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/tabela-iss-sp/)

### IRPJ/CSLL
- [IRPJ 2025 - Tax Group](https://www.taxgroup.com.br/intelligence/tabela-irpj-2025-confira-como-funciona-e-suas-aliquotas/)
- [Lucro Presumido - Jettax](https://www.jettax.com.br/blog/tabela-presuncao-do-lucro-presumido/)
- [Lucro Presumido - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/lucro-presumido/)
- [CSLL - Conta Azul](https://contaazul.com/blog/csll-o-que-e/)
- [Lucro Presumido 2026 - CLM Controller](https://portaldacontabilidade.clmcontroller.com.br/como-calcular-o-lucro-presumido/)

### Simples Nacional
- [Tabela Simples Nacional 2026 - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/tabela-simples-nacional-completa/)
- [Anexo I - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/anexo-1-simples-nacional/)
- [Anexo II - Receita Federal](http://normas.receita.fazenda.gov.br/sijut2consulta/anexoOutros.action?idArquivoBinario=48431)
- [Anexo III - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/anexo-3-simples-nacional/)
- [Anexo V - ContaAgil](https://www.contaagil.com/contabilidade-digital/anexo-5-do-simples-nacional-atualizado/)
- [Calculo Simples 2026 - Saipos](https://saipos.com/fiscal/simples-nacional/calculo-simples-nacional)

### Reforma Tributaria
- [Cronograma Reforma - Vinco](https://blog.vinco.com.br/cronograma-da-reforma-tributaria/)
- [Reforma 2026 - Tax Group](https://www.taxgroup.com.br/intelligence/reforma-tributaria-2026-guia-completo-sobre-o-que-muda-e-a-transicao/)
- [CBS IBS 2026 - ClickNotas](https://clicknotas.com.br/reforma-tributaria-cbs-ibs-imposto-seletivo/)
- [Cronograma - Jettax](https://www.jettax.com.br/blog/cronograma-e-fases-da-reforma-tributaria-de-2026-a-2033/)
- [LC 214 - Planalto](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp214.htm)
- [Split Payment - Thomson Reuters](https://www.thomsonreuters.com.br/pt/tax-accounting/onesource-mastersaf/blog/split-payment-reforma-tributaria.html)
- [Split Payment - E-Auditoria](https://www.e-auditoria.com.br/blog/split-payment-reforma-tributaria-o-que-e-como-funciona/)
- [NF-e IBS CBS - ERPServ](https://erpserv.com.br/blog-nfe-xml-ibs-cbs-nova-estrutura/)
- [NF-e XML Reforma - V360](https://v360.io/blog/xml-nota-fiscal/)

### Tabelas Auxiliares
- [NCM - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/aduana-e-comercio-exterior/classificacao-fiscal-de-mercadorias/ncm)
- [CFOP - Contabilizei](https://www.contabilizei.com.br/contabilidade-online/tabela-cfop-completa/)
- [CFOP - CONFAZ](https://www.confaz.fazenda.gov.br/legislacao/ajustes/sinief/cfop_cvsn_70_vigente)
- [CEST - DooTax](https://dootax.com.br/cest/)
- [CEST - TecnoSpeed](https://blog.tecnospeed.com.br/codigo-cest/)
- [CNAE - IBGE](https://concla.ibge.gov.br/busca-online-cnae.html)
- [CNAE - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/cadastros/cnpj/classificacao-nacional-de-atividades-economicas-2013-cnae)
- [Natureza Operacao - TecnoSpeed](https://blog.tecnospeed.com.br/natureza-da-operacao-nf-e-entenda-o-que-e-e-quais-os-tipos/)

### NF-e XML
- [Estrutura XML NF-e - Grid Sistemas](https://gridsistemas.com.br/estruturaxml/)
- [Grupos ICMS NF-e - FlexDocs](https://flexdocs.net/guia-nfe/icms/)
- [PIS COFINS NF-e - TecnoSpeed](https://blog.tecnospeed.com.br/como-calcular-pis-e-cofins-na-nfe-e-nfce/)
- [Preenchimento ICMS NF-e - NSTecnologia](https://documentacao.nstecnologia.com.br/docs/orientacoes-fiscais/materiais-explicativos/como-preencher-os-grupos-de-icms/)

### Modulo Fiscal ERP
- [Modulo Fiscal ERP - TecnoSpeed](https://blog.tecnospeed.com.br/entenda-como-funciona-o-modulo-fiscal-dentro-do-sistema-erp/)
- [ERP Nuvem Gestao Fiscal - Avalara](https://www.avalara.com/br/pt/blog/2025/08/erp-em-nuvem-gestao-fiscal.html)
- [Modulo Fiscal Odoo Brasil - Escodoo](https://escodoo.com.br/blog/blog-1/odoo-no-brasil-um-mergulho-no-modulo-fiscal-brasileiro-l10n-br-fiscal-22)
- [Reforma Tributaria ERP - GestaoClick](https://gestaoclick.com.br/blog/reforma-tributaria-cbs-ibs-is-erp/)
