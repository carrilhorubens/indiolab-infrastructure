# Pesquisa: Módulo Fiscal para ERP Genérico

> Levantamento completo de entidades, fluxos, cálculos tributários, documentos fiscais eletrônicos, obrigações acessórias, integrações entre módulos, boas práticas e requisitos legais brasileiros para implementação do módulo Fiscal no OpticalCore ERP.
> Referências: SAP S/4HANA (FI/SD/MM), Oracle Fusion Tax, TOTVS Protheus (SIGAFIS/SIGAFAT), Microsoft Dynamics 365 Finance (Brazilian Localization), Odoo l10n_br, ERPNext (Brazil), Zeus.Net.NFe.NFCe (open source .NET).

---

## Sumário

1. [Entidades Propostas](#1-entidades-propostas)
2. [Campos Chave das Entidades](#2-campos-chave-das-entidades)
3. [Documentos Fiscais Eletrônicos](#3-documentos-fiscais-eletrônicos)
4. [Cálculo de Impostos (Tax Engine)](#4-cálculo-de-impostos-tax-engine)
5. [Tabelas Auxiliares Fiscais](#5-tabelas-auxiliares-fiscais)
6. [Regimes Tributários](#6-regimes-tributários)
7. [Substituição Tributária e DIFAL](#7-substituição-tributária-e-difal)
8. [Obrigações Acessórias (SPED)](#8-obrigações-acessórias-sped)
9. [Certificado Digital](#9-certificado-digital)
10. [Comunicação com SEFAZ](#10-comunicação-com-sefaz)
11. [Integração Entre Módulos](#11-integração-entre-módulos)
12. [Relatórios e KPIs](#12-relatórios-e-kpis)
13. [Especificidades do Setor Óptico](#13-especificidades-do-setor-óptico)
14. [Reforma Tributária (EC 132/2023)](#14-reforma-tributária-ec-1322023)
15. [Implicações Multi-Tenant](#15-implicações-multi-tenant)
16. [Padrões Arquiteturais](#16-padrões-arquiteturais)
17. [Priorização Sugerida para Implementação](#17-priorização-sugerida-para-implementação)
18. [Fontes da Pesquisa](#18-fontes-da-pesquisa)

---

## 1. Entidades Propostas

### 1.1 Configuração Tributária (7 entidades)

| Entidade | Descrição | Schema |
|----------|-----------|--------|
| **ConfiguracaoFiscal** | Configurações fiscais gerais da empresa (regime, ambiente, série NF-e, certificado) | Tenant |
| **RegraTributaria** | Regras de tributação parametrizáveis (NCM × UF × CFOP × Regime → alíquotas) | Tenant |
| **RegraTributariaImposto** | Detalhes de impostos por regra (CST, alíquota, redução, MVA, cBenef) | Tenant |
| **InscricaoEstadual** | Inscrições estaduais por UF/filial | Tenant |
| **SequencialNfe** | Controle de numeração sequencial por série/modelo | Tenant |
| **CertificadoDigital** | Certificados A1 por empresa (PFX encriptado) | Public |
| **PerfilFiscal** | Perfil fiscal do destinatário (Contribuinte, Não Contribuinte, Isento, Consumidor Final) | Tenant |

### 1.2 Documentos Fiscais (9 entidades)

| Entidade | Descrição | Referência ERP |
|----------|-----------|----------------|
| **NotaFiscal** | Cabeçalho da NF-e/NFC-e (modelo 55/65) com status, XML, protocolo | SAP: J_1BNFDOC / Protheus: SF2/SD2 / Dynamics: FiscalDocument |
| **NotaFiscalItem** | Itens da nota fiscal com produto, CFOP, NCM, quantidades | SAP: J_1BNFLIN / Protheus: SD2 |
| **NotaFiscalItemImposto** | Impostos calculados por item (ICMS, ST, PIS, COFINS, IPI, DIFAL, FCP) | SAP: J_1BTAX / Protheus: SFT |
| **NotaFiscalPagamento** | Formas de pagamento da NF-e (grupo YA do XML) | — |
| **NotaFiscalTransporte** | Dados de transporte: modalidade frete, transportadora, volumes | — |
| **NotaFiscalReferenciada** | NF-e referenciadas em devoluções/complementares | — |
| **EventoNotaFiscal** | Eventos: cancelamento, carta de correção, manifestação do destinatário | SAP: J_1BNFE_EVENTS |
| **InutilizacaoNfe** | Faixas de numeração inutilizadas | — |
| **NotaFiscalServico** | NFS-e (Nota Fiscal de Serviço Eletrônica) — padrão nacional | — |

### 1.3 Apuração de Impostos (6 entidades)

| Entidade | Descrição |
|----------|-----------|
| **ApuracaoIcms** | Apuração mensal do ICMS por UF (débitos, créditos, saldo devedor/credor) |
| **ApuracaoIcmsDetalhe** | Detalhamento NF por NF da apuração ICMS |
| **ApuracaoPisCofins** | Apuração mensal de PIS e COFINS (cumulativo e não-cumulativo) |
| **ApuracaoPisCofinsDetalhe** | Detalhamento NF por NF da apuração PIS/COFINS |
| **ApuracaoSimplesNacional** | Apuração mensal do DAS (receita bruta, faixa, alíquota efetiva) |
| **RetencaoFonte** | Retenções calculadas por título financeiro (IRRF, PIS, COFINS, CSLL, ISS, INSS) |

### 1.4 Guias e Recolhimento (2 entidades)

| Entidade | Descrição |
|----------|-----------|
| **GuiaRecolhimento** | DARF, GNRE, DAS, GPS geradas — código de receita, vencimento, código de barras |
| **ArquivoSped** | Arquivos SPED gerados/transmitidos (EFD-ICMS/IPI, EFD-Contribuições, ECD, ECF) |

### 1.5 Auditoria Fiscal (1 entidade)

| Entidade | Descrição |
|----------|-----------|
| **AuditTrailFiscal** | Trilha de auditoria fiscal imutável (append-only): criação, assinatura, envio, autorização, cancelamento, impressão DANFE |

### 1.6 Domínios/Lookup — Schema Public (9 tabelas)

| Entidade | Descrição |
|----------|-----------|
| **NcmTributacao** | Tabela NCM nacional (8 dígitos) com descrição e alíquota IPI |
| **CfopOperacao** | Tabela CFOP (4 dígitos) com tipo de movimento |
| **CestTributacao** | CEST (7 dígitos) vinculado ao NCM para Substituição Tributária |
| **CstIcms** | Códigos de Situação Tributária do ICMS (00 a 90) |
| **CsosnIcms** | Códigos CSOSN para Simples Nacional (101 a 900) |
| **CstPisCofins** | Códigos CST de PIS e COFINS (01 a 99) |
| **CstIpi** | Códigos CST de IPI (00 a 99) |
| **AliquotaInterestadual** | Alíquotas ICMS interestadual (UF origem × UF destino) |
| **CodigoServicoNacional** | Códigos de serviço da LC 116/2003 (NFS-e) |

---

## 2. Campos Chave das Entidades

### 2.1 ConfiguracaoFiscal

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| RegimeTributario | string(20) | "SimplesNacional", "LucroPresumido", "LucroReal" |
| CRT | int | Código Regime Tributário: 1=SN, 2=SN Excesso, 3=Normal, 4=MEI |
| AmbienteNfe | int | 1=Produção, 2=Homologação |
| SerieNfe | int | Série padrão NF-e (1-999) |
| SerieNfce | int | Série padrão NFC-e |
| ProximoNumeroNfe | int | Próximo número NF-e |
| ProximoNumeroNfce | int | Próximo número NFC-e |
| CertificadoDigitalId | Guid? (FK) | Certificado ativo |
| AliquotaPisCumulativo | decimal(5,2) | 0.65% (padrão) |
| AliquotaCofinsCumulativo | decimal(5,2) | 3.00% (padrão) |
| AliquotaPisNaoCumulativo | decimal(5,2) | 1.65% (padrão) |
| AliquotaCofinsNaoCumulativo | decimal(5,2) | 7.60% (padrão) |
| InformacoesComplementares | text | Informações adicionais padrão da NF-e |

### 2.2 RegraTributaria

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| Codigo | int (auto) | Código sequencial |
| Nome | string(200) | Nome descritivo da regra |
| TipoOperacao | string(30) | Venda, Compra, Devolução, Transferência, Bonificação |
| NcmDe | string(8) | NCM inicial (faixa, nullable) |
| NcmAte | string(8) | NCM final (faixa, nullable) |
| UfOrigem | string(2) | UF origem (nullable = qualquer) |
| UfDestino | string(2) | UF destino (nullable = qualquer) |
| RegimeFiscal | string(20) | SimplesNacional, LucroPresumido, LucroReal (nullable = qualquer) |
| PerfilDestinatario | string(30) | Contribuinte, NaoContribuinte, Isento, ConsumidorFinal |
| CfopEntrada | string(4) | CFOP para operações de entrada |
| CfopSaida | string(4) | CFOP para operações de saída |
| Prioridade | int | Prioridade de aplicação (maior = mais específica) |
| DataVigenciaInicio | date | Início da vigência |
| DataVigenciaFim | date? | Fim da vigência (nullable = indeterminado) |
| Ativo | bool | Se a regra está ativa |

### 2.3 RegraTributariaImposto

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| RegraTributariaId | Guid (FK) | Regra pai |
| TipoImposto | string(20) | ICMS, ICMS_ST, IPI, PIS, COFINS, DIFAL, FCP |
| CST | string(3) | CST ou CSOSN |
| Aliquota | decimal(7,4) | Alíquota do imposto |
| ReducaoBase | decimal(7,4) | Percentual de redução da base de cálculo |
| MVA | decimal(7,4) | Margem de Valor Agregado (para ST) |
| BaseCalculo | string(30) | Tipo: ValorOperacao, ValorProduto, BaseReduzida |
| CodigoBeneficio | string(10) | cBenef (quando há incentivo fiscal estadual) |
| Observacao | string(500) | Observação da regra |

### 2.4 NotaFiscal (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| Codigo | int (auto) | Código sequencial interno 8 dígitos |
| ChaveAcesso | string(44) | Chave de acesso (44 dígitos numéricos) |
| Modelo | int | 55=NF-e, 65=NFC-e |
| Serie | int | Série do documento (0-999) |
| Numero | int | Número da NF-e (1-999999999) |
| DataEmissao | timestamp | Data e hora de emissão |
| DataSaidaEntrada | timestamp? | Data e hora de saída/entrada |
| TipoOperacao | int | 0=Entrada, 1=Saída |
| DestinoOperacao | int | 1=Interna, 2=Interestadual, 3=Exterior |
| NaturezaOperacao | string(60) | "Venda", "Devolução", "Remessa", etc. |
| FinalidadeEmissao | int | 1=Normal, 2=Complementar, 3=Ajuste, 4=Devolução |
| IndicadorConsumidorFinal | int | 0=Não, 1=Sim |
| IndicadorPresenca | int | 0=N/A, 1=Presencial, 2=Internet, 3=Telemarketing, etc. |
| TipoEmissao | int | 1=Normal, 4=EPEC, 5=FS-DA, 6=SVC-AN, 7=SVC-RS, 9=Offline |
| Status | string(20) | EmDigitacao, Validada, Transmitida, Autorizada, Rejeitada, Cancelada, Denegada, Inutilizada |
| ProtocoloAutorizacao | string(20) | Número do protocolo SEFAZ |
| DataAutorizacao | timestamp? | Data/hora da autorização |
| CodigoRejeicao | int? | Código de rejeição SEFAZ |
| MotivoRejeicao | string(500) | Motivo da rejeição |
| XmlEnviado | text | XML assinado enviado |
| XmlAutorizado | text | XML + protocolo (nfeProc) |
| XmlCancelamento | text? | XML do evento de cancelamento |
| Ambiente | int | 1=Produção, 2=Homologação |
| EmitenteId | Guid (FK) | Pessoa emitente |
| DestinatarioId | Guid? (FK) | Pessoa destinatário (nullable para NFC-e) |
| DestinatarioCpfCnpj | string(14) | CPF/CNPJ do destinatário |
| DestinatarioNome | string(60) | Nome/razão social do destinatário |
| DestinatarioIE | string(14) | IE do destinatário |
| DestinatarioIndicadorIE | int | 1=Contribuinte, 2=Isento, 9=Não Contribuinte |
| ModalidadeFrete | int | 0=CIF, 1=FOB, 2=Terceiros, 9=Sem frete |
| TransportadoraId | Guid? (FK) | Pessoa transportadora |
| ValorProdutos | decimal(18,2) | Valor total dos produtos |
| ValorFrete | decimal(18,2) | Valor do frete |
| ValorSeguro | decimal(18,2) | Valor do seguro |
| ValorDesconto | decimal(18,2) | Valor do desconto |
| ValorOutrasDespesas | decimal(18,2) | Outras despesas acessórias |
| TotalIcms | decimal(18,2) | Total ICMS |
| TotalIcmsSt | decimal(18,2) | Total ICMS ST |
| TotalIpi | decimal(18,2) | Total IPI |
| TotalPis | decimal(18,2) | Total PIS |
| TotalCofins | decimal(18,2) | Total COFINS |
| TotalDifal | decimal(18,2) | Total DIFAL |
| TotalFcp | decimal(18,2) | Total FCP |
| ValorTotalNota | decimal(18,2) | Valor total da NF-e |
| InformacoesContribuinte | text? | Informações adicionais de interesse do contribuinte |
| InformacoesFisco | text? | Informações adicionais de interesse do fisco |
| ContingenciaTipo | string(10)? | Tipo de contingência ativa |
| ContingenciaMotivo | string(500)? | Motivo da contingência |
| ContingenciaDataHora | timestamp? | Data/hora de entrada em contingência |
| PedidoVendaId | Guid? (FK) | Pedido de venda de origem |
| RecebimentoMercadoriaId | Guid? (FK) | Recebimento de mercadoria (NF entrada) |

### 2.5 NotaFiscalItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| NotaFiscalId | Guid (FK) | Cabeçalho da NF-e |
| NumeroItem | int | Sequencial do item (1 a 990) |
| ProdutoId | Guid (FK) | Produto |
| CodigoProduto | string(60) | Código interno do produto |
| Descricao | string(120) | Descrição do produto |
| NCM | string(8) | NCM do produto |
| CEST | string(7) | CEST (quando aplicável) |
| CFOP | string(4) | CFOP do item |
| UnidadeComercial | string(6) | Unidade comercial |
| Quantidade | decimal(18,4) | Quantidade comercial |
| ValorUnitario | decimal(18,10) | Valor unitário |
| ValorTotal | decimal(18,2) | Valor total do item |
| ValorDesconto | decimal(18,2) | Desconto do item |
| ValorFrete | decimal(18,2) | Frete rateado |
| ValorSeguro | decimal(18,2) | Seguro rateado |
| ValorOutro | decimal(18,2) | Outras despesas rateadas |
| OrigemMercadoria | int | Tabela A do CST (0=Nacional, 1=Importação direta, 2=Importação mercado interno, etc.) |
| CodigoEan | string(14) | GTIN/EAN |
| NumeroPedidoCompra | string(15)? | Número do pedido de compra (xPed) |
| ItemPedidoCompra | int? | Item do pedido de compra (nItemPed) |
| InformacoesAdicionais | string(500)? | Informações adicionais do item |

### 2.6 NotaFiscalItemImposto

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| NotaFiscalItemId | Guid (FK) | Item da NF-e |
| TipoImposto | string(20) | ICMS, ICMS_ST, IPI, PIS, COFINS, DIFAL, FCP, II |
| CST | string(3) | CST ou CSOSN |
| BaseCalculo | decimal(18,2) | Base de cálculo |
| Aliquota | decimal(7,4) | Alíquota aplicada |
| Valor | decimal(18,2) | Valor do imposto |
| ReducaoBase | decimal(7,4) | Redução da base de cálculo |
| BaseCalculoST | decimal(18,2)? | Base de cálculo ST |
| AliquotaST | decimal(7,4)? | Alíquota interna (ST) |
| ValorST | decimal(18,2)? | Valor ICMS ST |
| MVAST | decimal(7,4)? | MVA utilizado |
| ValorDifal | decimal(18,2)? | Valor DIFAL (destino) |
| ValorFcp | decimal(18,2)? | Valor FCP |
| ModalidadeBaseCalculo | int? | 0=Margem VA, 1=Pauta, 2=Preço tabelado, 3=Valor operação |

### 2.7 EventoNotaFiscal

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| NotaFiscalId | Guid (FK) | NF-e vinculada |
| ChaveAcesso | string(44) | Chave de acesso |
| TipoEvento | int | 110111=Cancelamento, 110110=CC-e, 110140=EPEC, 210200=Ciência, 210210=Confirmação, 210220=Desconhecimento, 210240=Op.NãoRealizada |
| SequenciaEvento | int | Sequencial do evento |
| DataEvento | timestamp | Data/hora do evento |
| Justificativa | string(255)? | Justificativa (min 15 caracteres para cancelamento) |
| CorrecaoTexto | text? | Texto da carta de correção (cada nova CC-e SUBSTITUI a anterior) |
| ProtocoloEvento | string(20) | Protocolo de registro do evento |
| XmlEvento | text | XML do evento enviado |
| XmlRetorno | text | XML de retorno da SEFAZ |
| StatusProcessamento | string(20) | Autorizado, Rejeitado |

### 2.8 ApuracaoIcms

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| Codigo | int (auto) | Código sequencial |
| Competencia | string(6) | MMAAAA (ex: "032026") |
| UF | string(2) | UF da apuração |
| TotalDebitos | decimal(18,2) | Total de débitos (saídas) |
| TotalCreditos | decimal(18,2) | Total de créditos (entradas) |
| SaldoCredorAnterior | decimal(18,2) | Saldo credor do mês anterior |
| DebitosEspeciais | decimal(18,2) | Débitos especiais (ajustes) |
| CreditosEspeciais | decimal(18,2) | Créditos especiais (ajustes) |
| EstornoDebitos | decimal(18,2) | Estornos de débitos |
| EstornoCreditos | decimal(18,2) | Estornos de créditos |
| SaldoDevedor | decimal(18,2) | Saldo devedor a recolher |
| SaldoCredor | decimal(18,2) | Saldo credor a transportar |
| ValorRecolher | decimal(18,2) | Valor a recolher |
| DataVencimento | date | Data de vencimento da guia |
| CodigoReceita | string(10) | Código de receita do ICMS |
| Status | string(20) | Pendente, Calculada, Fechada |

### 2.9 GuiaRecolhimento

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| Codigo | int (auto) | Código sequencial |
| TipoGuia | string(10) | DARF, GNRE, DAS, GPS, GuiaISS |
| CodigoReceita | string(10) | Código da receita |
| Competencia | string(6) | MMAAAA |
| DataVencimento | date | Data de vencimento |
| ValorPrincipal | decimal(18,2) | Valor principal |
| ValorMulta | decimal(18,2) | Valor de multa |
| ValorJuros | decimal(18,2) | Valor de juros |
| ValorTotal | decimal(18,2) | Valor total |
| CodigoBarras | string(60)? | Código de barras |
| LinhaDigitavel | string(60)? | Linha digitável |
| StatusPagamento | string(20) | Pendente, Paga, Vencida |
| DataPagamento | date? | Data de pagamento |
| ApuracaoId | Guid? (FK) | Apuração de origem |
| ContaPagarId | Guid? (FK) | Título no contas a pagar |
| Observacao | string(500)? | Observação |

### 2.10 CertificadoDigital

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| EmpresaId | Guid (FK) | Empresa/tenant |
| TipoCertificado | string(2) | "A1" ou "A3" |
| NumeroSerie | string(50) | Número de série do certificado |
| Emissor | string(200) | Autoridade certificadora |
| Titular | string(200) | Nome do titular |
| CNPJ | string(14) | CNPJ vinculado |
| DataValidade | date | Data de expiração |
| ArquivoPfxEncriptado | bytea | Arquivo .pfx encriptado com AES-256 |
| SenhaEncriptada | string | Senha encriptada com AES-256 |
| Thumbprint | string(64) | Thumbprint para identificação rápida |
| Ambiente | string(10) | Producao, Homologacao |
| Ativo | bool | Se está ativo |
| UltimaVerificacao | timestamp? | Última verificação de validade |

### 2.11 AuditTrailFiscal

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid (PK) | Identificador único |
| TipoDocumento | string(10) | NFe, NFCe, NFSe, CTe, MDFe |
| DocumentoId | Guid | FK para o documento |
| ChaveAcesso | string(44)? | Chave de acesso |
| Acao | string(30) | CRIACAO, CALCULO_IMPOSTOS, ASSINATURA, ENVIO_SEFAZ, AUTORIZACAO, REJEICAO, CANCELAMENTO, CARTA_CORRECAO, INUTILIZACAO, IMPRESSAO_DANFE |
| DataHora | timestamp | Data/hora da ação |
| UsuarioId | Guid | Usuário que executou |
| IpOrigem | string(45)? | IP de origem |
| Detalhes | jsonb? | Detalhes (request/response SEFAZ, erros, dados alterados) |
| Ambiente | string(10) | Producao, Homologacao |

**Regras do AuditTrail: IMUTÁVEL (append-only). Sem UPDATE ou DELETE. Retenção mínima: 5 anos.**

---

## 3. Documentos Fiscais Eletrônicos

### 3.1 NF-e (Nota Fiscal Eletrônica) — Modelo 55

**Visão geral:** Documento digital que documenta operações de circulação de mercadorias. Substituiu notas em papel (modelos 1 e 1A). Formato XML v4.00 com assinatura digital ICP-Brasil.

#### Estrutura XML Hierárquica

```xml
<nfeProc>
  <NFe>
    <infNFe versao="4.00" Id="NFe{chave44}">
      <ide/>        <!-- Identificação da NF-e (modelo, série, número, tipo, finalidade, emissão) -->
      <emit/>       <!-- Emitente (CNPJ, IE, CRT, endereço) -->
      <dest/>       <!-- Destinatário (CNPJ/CPF, IE, endereço) -->
      <det nItem="1..990">  <!-- Detalhes dos itens -->
        <prod/>     <!-- Dados do produto (cProd, NCM, CFOP, quantidade, valor) -->
        <imposto/>  <!-- Tributos: ICMS, IPI, PIS, COFINS, ICMSUFDest -->
      </det>
      <total/>      <!-- Totais (ICMSTot) -->
      <transp/>     <!-- Transporte (modalidade frete, transportadora, volumes) -->
      <cobr/>       <!-- Cobrança (duplicatas) — opcional -->
      <pag/>        <!-- Pagamento (forma, valor, dados cartão) -->
      <infAdic/>    <!-- Informações adicionais -->
    </infNFe>
    <Signature/>    <!-- Assinatura digital XML-DSig -->
  </NFe>
  <protNFe>         <!-- Protocolo de autorização SEFAZ -->
    <infProt>
      <chNFe/>      <!-- Chave de acesso 44 dígitos -->
      <nProt/>      <!-- Número do protocolo -->
      <cStat/>      <!-- 100=Autorizada -->
    </infProt>
  </protNFe>
</nfeProc>
```

#### Chave de Acesso (44 dígitos)

```
Posição | Tam | Campo  | Descrição
01-02   | 2   | cUF    | Código IBGE da UF
03-06   | 4   | AAMM   | Ano/mês emissão
07-20   | 14  | CNPJ   | CNPJ do emitente
21-22   | 2   | mod    | Modelo (55 ou 65)
23-25   | 3   | serie  | Série
26-34   | 9   | nNF    | Número da NF-e
35-35   | 1   | tpEmis | Tipo emissão (1=normal)
36-43   | 8   | cNF    | Código numérico aleatório
44-44   | 1   | cDV    | Dígito verificador (mod 11)
```

#### Status da NF-e

| Status | Código | Descrição | Tratamento ERP |
|--------|--------|-----------|----------------|
| **Autorizada** | 100 | Válida juridicamente | Armazenar XML+protocolo, gerar DANFE |
| **Cancelada** | 101/135 | Cancelada via evento | Prazo: 24h (varia por UF). Estornar financeiro/estoque |
| **Denegada** | 110/301/302 | Irregularidade fiscal | Definitivo. Número consumido |
| **Rejeitada** | Vários | Erro de validação | Corrigir e reenviar com mesma numeração |
| **Inutilizada** | 102 | Quebra de sequência | Registrar faixa. Números indisponíveis |

#### Eventos da NF-e

| Evento | tpEvento | Prazo | Observação |
|--------|----------|-------|------------|
| Cancelamento | 110111 | 24h (varia UF) | Mercadoria não pode ter circulado |
| Carta de Correção | 110110 | Até 20 por NF-e | Cada nova SUBSTITUI a anterior. Não corrige valores/identidade |
| EPEC | 110140 | NF-e deve ser autorizada em 7 dias | Contingência |
| Ciência da Operação | 210210 | — | Destinatário tomou conhecimento |
| Confirmação | 210200 | — | Operação confirmada |
| Desconhecimento | 210220 | — | Desconhece a operação |
| Op. Não Realizada | 210240 | — | Operação não ocorreu |

#### Contingência

| Modalidade | tpEmis | Descrição |
|------------|--------|-----------|
| SVC-AN | 6 | SEFAZ Virtual Nacional. Para: AC,AL,AP,DF,ES,MG,PB,RJ,RS,RO,RR,SC,SE,SP,TO |
| SVC-RS | 7 | SEFAZ Virtual RS. Para: AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR,RN |
| EPEC | 4 | Evento prévio no Ambiente Nacional. NF-e deve ser autorizada em 7 dias |
| FS-DA | 5 | Formulário de segurança. Última opção (sem internet) |
| Offline | 9 | **Somente NFC-e**. Transmitir em até 24h |

### 3.2 NFC-e (Nota Fiscal do Consumidor) — Modelo 65

Mesmo layout XML da NF-e, mas para vendas presenciais ao consumidor final:

| Diferença | NF-e (55) | NFC-e (65) |
|-----------|-----------|------------|
| Destinatário | Obrigatório | Opcional (CPF para >R$200 em alguns estados) |
| DANFE | A4 completo | Extrato/bobina com QR Code |
| Transporte | Detalhado | Sem (modFrete=9) |
| IPI | Pode ter | Não possui |
| Operação | Interna/interestadual/exterior | Somente interna |
| Contingência | SVC-AN/RS, EPEC | **Offline** (tpEmis=9) |
| QR Code | Não | Obrigatório (v3 a partir de 2025) |

### 3.3 NFS-e (Nota Fiscal de Serviço) — Padrão Nacional

Competência **municipal** (ISS). A partir de 01/01/2026, o Padrão Nacional é obrigatório (LC 214/2025).

**Ambiente único:** `https://www.nfse.gov.br` — API REST (JSON) com mTLS.

**Fluxo:** Contribuinte envia **DPS** (Declaração de Prestação de Serviço) → Sistema gera **NFS-e**.

| Campo DPS | Descrição |
|-----------|-----------|
| codigoTributacaoNacional | Código do serviço (LC 116) |
| valorServicos | Valor total dos serviços |
| issRetido | S/N — se ISS retido pelo tomador |
| aliquotaISS | 2% a 5% |
| municipioIncidencia | Município de incidência do ISS |

**RPS (Recibo Provisório de Serviço):** Contingência. Deve ser convertido em NFS-e no prazo do município (geralmente 10 dias).

### 3.4 CT-e e MDF-e (Prioridade Baixa para Óticas)

**CT-e (modelo 57):** Transporte de carga. Obrigatório para transportadoras. Referencia chaves de NF-e transportadas.

**MDF-e (modelo 58):** Manifesto que agrupa NF-e/CT-e por viagem/veículo. Obrigatório para transporte próprio interestadual/intermunicipal.

**Recomendação:** Implementar somente se necessário. Maioria das óticas NÃO emite CT-e ou MDF-e.

---

## 4. Cálculo de Impostos (Tax Engine)

### 4.1 Arquitetura do Motor de Cálculo

```
                     ┌──────────────────────┐
                     │ ITaxCalculationService│
                     │   (Orquestrador)      │
                     └──────────┬───────────┘
                                │
               ┌────────────────┼────────────────┐
               │                │                │
        ┌──────▼──────┐ ┌──────▼──────┐ ┌───────▼──────┐
        │IcmsCalculator│ │PisCalculator│ │IpiCalculator │
        └──────┬──────┘ └──────┬──────┘ └───────┬──────┘
               │                │                │
        ┌──────▼────────────────▼────────────────▼──────┐
        │            ITaxRuleResolver                    │
        │  (consulta RegraTributaria no banco)           │
        └───────────────────────────────────────────────┘
```

**Padrão:** Strategy por tipo de imposto + Chain of Responsibility para prioridade de regras.

### 4.2 Fórmulas de Cálculo

#### ICMS Próprio
```
Base ICMS = ValorProduto + Frete + Seguro + OutrasDespesas - Desconto
ICMS = Base × Alíquota × (1 - ReducaoBase)

Exemplo:
Produto: R$ 1.000, Frete: R$ 100, Alíquota SP: 18%
Base = R$ 1.100
ICMS = R$ 1.100 × 18% = R$ 198,00
```

#### ICMS-ST (Substituição Tributária)
```
Base ST = (ValorProduto + IPI + Frete + Seguro + OutrasDespesas) × (1 + MVA)
ICMS-ST = (Base ST × AlíquotaInterna) - ICMS Próprio

MVA Ajustado (operação interestadual):
MVA Ajustado = [(1 + MVA Original) × (1 - AlíquotaInterestadual) / (1 - AlíquotaInterna)] - 1

Exemplo:
Produto: R$ 1.000, MVA: 40%, AlíquotaInterna: 18%, ICMS Próprio: R$ 120
Base ST = R$ 1.000 × 1,40 = R$ 1.400
ICMS ST = (R$ 1.400 × 18%) - R$ 120 = R$ 252 - R$ 120 = R$ 132,00
```

#### DIFAL (Diferencial de Alíquota) — EC 87/2015
```
Aplica-se: Operação interestadual para consumidor final não contribuinte

Base DIFAL = ValorProduto + Frete + Seguro + OutrasDespesas - Desconto
DIFAL = Base × (AlíquotaInterna_Destino - AlíquotaInterestadual)
FCP = Base × AlíquotaFCP_Destino (ex: 2% RJ)

100% para UF destino (a partir de 2019)

Exemplo:
Venda SP→RJ, Produto: R$ 1.000
AlíquotaInterestadual SP→RJ: 12%
AlíquotaInterna RJ: 20% (+2% FCP)
DIFAL = R$ 1.000 × (20% - 12%) = R$ 80,00
FCP = R$ 1.000 × 2% = R$ 20,00
Total recolhido para RJ: R$ 100,00
```

#### IPI
```
Base IPI = ValorProduto + Frete + Seguro + OutrasDespesas
IPI = Base × Alíquota (conforme TIPI/NCM)

Exemplo (armação de óculos NCM 9003.11.00, alíquota 10%):
IPI = R$ 500 × 10% = R$ 50,00

IMPORTANTE: IPI integra a base do ICMS-ST mas NÃO integra a base do ICMS próprio
```

#### PIS e COFINS
```
Regime Cumulativo (Lucro Presumido):
  PIS = Receita Bruta × 0,65%
  COFINS = Receita Bruta × 3,00%
  SEM direito a crédito

Regime Não-Cumulativo (Lucro Real):
  PIS = Receita Bruta × 1,65%
  COFINS = Receita Bruta × 7,60%
  COM direito a crédito sobre insumos

Monofásico (tributação concentrada):
  Fabricante/importador recolhe PIS/COFINS com alíquota majorada
  Revendedor usa CST 04 (alíquota zero) — NÃO recolhe novamente
  Comum em: combustíveis, medicamentos, cosméticos, bebidas
```

#### ISS (Nota Fiscal de Serviço)
```
ISS = Valor do Serviço × Alíquota Municipal (2% a 5%)

Retido na fonte: Tomador retém e recolhe ao município competente
Local de incidência: Regra geral = município do prestador
  Exceções (Art. 3° LC 116): construção civil, vigilância, informática, etc.
```

### 4.3 Tabela CST ICMS (Regime Normal)

| CST | Descrição | Campos XML |
|-----|-----------|------------|
| 00 | Tributada integralmente | orig, CST, modBC, vBC, pICMS, vICMS |
| 10 | Tributada + ST | + modBCST, pMVAST, vBCST, pICMSST, vICMSST |
| 20 | Redução de base de cálculo | + pRedBC |
| 30 | Isenta/não tributada + ST | Sem ICMS próprio, com ST |
| 40 | Isenta | vICMSDeson, motDesICMS |
| 41 | Não tributada | vICMSDeson, motDesICMS |
| 50 | Suspensão | — |
| 51 | Diferimento | pDif, vICMSDif |
| 60 | Cobrado anteriormente por ST | vBCSTRet, vICMSSTRet |
| 70 | Redução BC + ST | Combinação de 20 + 10 |
| 90 | Outros | Campos genéricos |

### 4.4 Tabela CSOSN (Simples Nacional)

| CSOSN | Descrição | Equivalência CST |
|-------|-----------|------------------|
| 101 | Tributada SN com permissão de crédito | 00/20 |
| 102 | Tributada SN sem permissão de crédito | 00/20 |
| 103 | Isenção ICMS no SN | 40 |
| 201 | Tributada SN com crédito + ST | 10/70 |
| 202 | Tributada SN sem crédito + ST | 10/70 |
| 203 | Isenção ICMS no SN + ST | 30 |
| 300 | Imune | 40 |
| 400 | Não tributada pelo SN | 41/50 |
| 500 | ICMS cobrado anteriormente por ST | 60 |
| 900 | Outros | 90 |

### 4.5 Tabela CST PIS/COFINS

| CST | Descrição |
|-----|-----------|
| 01 | Operação tributável (BC = valor operação) |
| 02 | Operação tributável (alíquota diferenciada) |
| 03 | Operação tributável (qtde × alíquota por unidade) |
| 04 | Operação tributável — Substituição Tributária |
| 05 | Operação tributável — Substituído |
| 06 | Operação tributável — Alíquota zero |
| 07 | Operação isenta |
| 08 | Operação sem incidência |
| 09 | Operação com suspensão |
| 49 | Outras operações de saída |
| 50-66 | Operações de crédito (entrada) |
| 70-75 | Crédito presumido |
| 98 | Outras operações de entrada |
| 99 | Outras operações |

---

## 5. Tabelas Auxiliares Fiscais

### 5.1 NCM (Nomenclatura Comum do Mercosul)

Código de 8 dígitos: `CC.PP.SS.II` (Capítulo, Posição, Subposição, Item).

**NCMs do setor óptico:**

| NCM | Produto | Alíquota IPI |
|-----|---------|-------------|
| 9001.40.00 | Lentes oftálmicas de vidro | 5% |
| 9001.50.00 | Lentes de contato | 5% |
| 9001.50.10 | Lentes de contato intraoculares | 0% |
| 9003.11.00 | Armações de plástico | 10% |
| 9003.19.00 | Armações de outros materiais | 10% |
| 9004.10.00 | Óculos de sol | 15% |
| 9004.90.10 | Óculos de proteção/correção | 5% |
| 9018.50.00 | Instrumentos oftalmológicos | 0% |

### 5.2 CFOP (Código Fiscal de Operações e Prestações)

Código de 4 dígitos: `X.YZZ`

```
1° dígito:
  1.xxx = Entrada interna     5.xxx = Saída interna
  2.xxx = Entrada interestadual 6.xxx = Saída interestadual
  3.xxx = Entrada exterior     7.xxx = Saída exterior
```

**CFOPs mais usados no varejo óptico:**

| CFOP | Descrição | Uso |
|------|-----------|-----|
| 5.102 | Venda de mercadoria adquirida | Venda interna no balcão |
| 5.405 | Venda com ST já recolhido | Venda de produto substituído |
| 6.102 | Venda interestadual | Venda para outro estado |
| 1.102 | Compra para comercialização | Compra de fornecedor no estado |
| 2.102 | Compra interestadual | Compra de fornecedor de outro estado |
| 5.202 | Devolução de compra | Devolução ao fornecedor |
| 1.202 | Devolução de venda | Cliente devolveu produto |
| 5.949 | Outra saída não especificada | Remessa para conserto, empréstimo |

### 5.3 CEST (Código Especificador da Substituição Tributária)

7 dígitos: `SS.III.EE` (Segmento, Item, Especificação). Obrigatório quando o produto está sujeito a ST (Convênio ICMS 142/2018).

### 5.4 Alíquotas Interestaduais de ICMS

| De \ Para | N/NE/CO/ES | S/SE (exceto ES) |
|-----------|------------|------------------|
| **N/NE/CO/ES** | — | 12% |
| **S/SE (exceto ES)** | 7% | 12% |
| **Importados (qualquer)** | 4% | 4% |

### 5.5 Alíquotas Internas Modais por UF (2026)

| UF | Alíquota | UF | Alíquota | UF | Alíquota |
|----|----------|----|-----------|----|----------|
| AC | 19% | MA | 22% | RJ | 22% |
| AL | 19% | MG | 18% | RN | 20% |
| AM | 20% | MS | 17% | RO | 19,5% |
| AP | 18% | MT | 17% | RR | 20% |
| BA | 20,5% | PA | 19% | RS | 17% |
| CE | 20% | PB | 20% | SC | 17% |
| DF | 20% | PE | 20,5% | SE | 19% |
| ES | 17% | PI | 22,5% | SP | 18% |
| GO | 19% | PR | 19,5% | TO | 20% |

### 5.6 Meios de Pagamento (tPag da NF-e)

| Código | Descrição |
|--------|-----------|
| 01 | Dinheiro |
| 02 | Cheque |
| 03 | Cartão de Crédito |
| 04 | Cartão de Débito |
| 05 | Crédito Loja |
| 14 | Duplicata Mercantil |
| 15 | Boleto Bancário |
| 17 | PIX |
| 18 | Transferência/Carteira Digital |
| 90 | Sem pagamento |
| 99 | Outros |

---

## 6. Regimes Tributários

### 6.1 Simples Nacional

**Faturamento:** Até R$ 4.800.000,00/ano. Sublimite estadual ICMS/ISS: R$ 3.600.000,00.

**Fórmula da alíquota efetiva:**
```
Alíquota Efetiva = (RBT12 × Alíquota Nominal - Parcela a Deduzir) / RBT12

RBT12 = Receita Bruta Total dos últimos 12 meses
```

**Anexo I (Comércio) — exemplo:**

| Faixa | RBT12 (R$) | Alíquota Nominal | Parcela a Deduzir |
|-------|------------|------------------|-------------------|
| 1ª | Até 180.000 | 4,00% | 0 |
| 2ª | 180.001 a 360.000 | 7,30% | 5.940,00 |
| 3ª | 360.001 a 720.000 | 9,50% | 13.860,00 |
| 4ª | 720.001 a 1.800.000 | 10,70% | 22.500,00 |
| 5ª | 1.800.001 a 3.600.000 | 14,30% | 87.300,00 |
| 6ª | 3.600.001 a 4.800.000 | 19,00% | 378.000,00 |

**Na NF-e:** Emitente com CRT=1 usa CSOSN (não CST).

### 6.2 Lucro Presumido

**Base presumida para IRPJ:**
| Atividade | Percentual |
|-----------|-----------|
| Comércio/Indústria | 8% |
| Serviços (geral) | 32% |
| Transporte de cargas | 8% |
| Serviços hospitalares | 8% |

**Impostos:** IRPJ (15% + 10% adicional acima R$ 60.000/trim), CSLL (9%), PIS (0,65% cumulativo), COFINS (3% cumulativo).

### 6.3 Lucro Real

Imposto calculado sobre o lucro contábil ajustado (adições e exclusões do LALUR).
PIS (1,65%) e COFINS (7,60%) no regime não-cumulativo, COM direito a créditos.

---

## 7. Substituição Tributária e DIFAL

### 7.1 ICMS-ST

O fabricante/importador recolhe antecipadamente o ICMS de toda a cadeia comercial. O revendedor (substituído) vende com CST 60 (ICMS já cobrado por ST).

**MVA (Margem de Valor Agregado):** Definido por Convênio ICMS ou Protocolo entre estados. Varia por NCM e UF.

**Exemplo prático (armação de óculos):**
```
Fabricante SP vende para ótica SP:
Produto: R$ 500, IPI: R$ 50, MVA: 40%
Base ST = (500 + 50) × 1,40 = R$ 770
ICMS ST = (770 × 18%) - (500 × 18%) = R$ 138,60 - R$ 90,00 = R$ 48,60
NF-e: valor total = R$ 500 + R$ 50 (IPI) + R$ 48,60 (ST) = R$ 598,60
```

### 7.2 DIFAL (EC 87/2015)

Aplica-se em vendas interestaduais para consumidor final não contribuinte:
```
DIFAL = Base × (AlíquotaInterna_Destino - AlíquotaInterestadual)
FCP = Base × AlíquotaFCP (quando aplicável, ex: 2% RJ)
```

Recolhimento: 100% para UF destino via GNRE.

---

## 8. Obrigações Acessórias (SPED)

### 8.1 EFD-ICMS/IPI (SPED Fiscal)

**Periodicidade:** Mensal (até dia 15 do mês subsequente).
**Quem entrega:** Contribuintes de ICMS e/ou IPI.
**Versão:** Leiaute 020 a partir de 01/01/2026.

| Bloco | Descrição | Dados do ERP |
|-------|-----------|-------------|
| 0 | Abertura e cadastros | Empresa, produtos, clientes, fornecedores |
| C | Documentos fiscais mercadorias | NF-e de entrada e saída |
| D | Documentos fiscais transporte | CT-e |
| E | Apuração ICMS e IPI | Débitos, créditos, ajustes, saldo |
| G | CIAP (Ativo Imobilizado) | Crédito ICMS em 48 parcelas |
| H | Inventário físico | **Estoque** — saldos valorizados |
| K | Produção e estoque | Movimentações de produção |
| 1 | Complementares | Exportação, ST, combustíveis |
| 9 | Encerramento | Totalizadores |

### 8.2 EFD-Contribuições (PIS/COFINS)

**Periodicidade:** Mensal (até 10° dia útil do 2° mês subsequente).
**Quem entrega:** Lucro Real e Lucro Presumido. SN: dispensado.

| Bloco | Descrição | Dados do ERP |
|-------|-----------|-------------|
| A | Documentos de serviços | NFS-e |
| C | Documentos de mercadorias | NF-e de entrada e saída |
| D | Documentos de transporte | CT-e |
| F | Demais receitas e créditos | Financeiro (receitas financeiras, aluguéis) |
| M | Apuração PIS/COFINS | Débitos, créditos, ajustes, valor a pagar |

### 8.3 ECD (SPED Contábil)

**Periodicidade:** Anual (até 30/06 do ano seguinte).
Livro Diário, Razão, Balancetes, Balanço Patrimonial, DRE.
**Dados do ERP:** Módulo Financeiro/Contábil (plano de contas, lançamentos, saldos).

### 8.4 ECF (Escrituração Contábil Fiscal)

**Periodicidade:** Anual (até 31/07 do ano seguinte). **Depende da ECD** (entregar ECD primeiro).
Apuração IRPJ e CSLL. LALUR (Lucro Real). Base presumida (Lucro Presumido).

### 8.5 EFD-Reinf

**Periodicidade:** Mensal (até dia 15 do mês subsequente).
**Substituiu a DIRF** desde 01/01/2025.

| Evento | Descrição | Dados do ERP |
|--------|-----------|-------------|
| R-1000 | Informações do contribuinte | Cadastro da empresa |
| R-2010 | Retenção INSS — serviços tomados | Contas a pagar (serviços) |
| R-2020 | Retenção INSS — serviços prestados | Contas a receber (serviços) |
| R-4010 | Pagamentos/créditos a PF (IRRF) | Contas a pagar (pessoas físicas) |
| R-4020 | Pagamentos/créditos a PJ (IRRF, PIS, COFINS, CSLL) | Contas a pagar (pessoas jurídicas) |

### 8.6 DCTFWeb + MIT

**MIT substitui o PGD-DCTF** desde janeiro/2025. Consolida dados de eSocial + EFD-Reinf.
Incorpora IRPJ, CSLL, PIS, COFINS, IPI, IOF e outros tributos.

### 8.7 Módulos do ERP que Alimentam cada Obrigação

| Obrigação | Vendas | Compras | Estoque | Financeiro | Contábil | Fiscal |
|-----------|--------|---------|---------|------------|----------|--------|
| EFD-ICMS/IPI | ✓ | ✓ | ✓ (Bloco H/K) | — | — | ✓ |
| EFD-Contribuições | ✓ | ✓ | — | ✓ (Bloco F) | — | ✓ |
| ECD | — | — | — | ✓ | ✓ | — |
| ECF | — | — | — | ✓ | ✓ | ✓ |
| EFD-Reinf | — | ✓ | — | ✓ | — | ✓ |
| DCTFWeb/MIT | — | — | — | ✓ | — | ✓ |

---

## 9. Certificado Digital

### 9.1 Tipos

| Tipo | Formato | Validade | Uso | Custo |
|------|---------|----------|-----|-------|
| **A1** | .pfx/.p12 (arquivo) | 1 ano | Ideal para servidores/nuvem. Copiável. Múltiplas instâncias | R$ 150-250/ano |
| **A3** | Token USB/SmartCard | 1-5 anos | Requer presença física. 1 instância por vez | R$ 200-500 + dispositivo |

**Recomendação para ERP multi-tenant em nuvem: SEMPRE A1.**

### 9.2 Armazenamento Seguro (.NET)

```
CertificadoDigital (banco de dados)
├── ArquivoPfxEncriptado (byte[]) ← AES-256 com chave do Key Vault
├── SenhaEncriptada (string)      ← AES-256 com chave do Key Vault
└── Thumbprint (string)            ← Identificação rápida

Fluxo:
1. Ler PFX encriptado do banco
2. Descriptografar com chave do vault (Azure/AWS KMS)
3. new X509Certificate2(pfxBytes, password, EphemeralKeySet)
4. Assinar XML
5. Dispose()
```

### 9.3 Monitoramento de Validade

Job diário verifica DataValidade. Alertas: 60, 30, 15, 7 dias antes. Certificado expirado bloqueia emissão.

---

## 10. Comunicação com SEFAZ

### 10.1 Web Services NF-e v4.00

| Web Service | Descrição |
|-------------|-----------|
| `NFeAutorizacao` | Autoriza lote de NF-e (síncrono/assíncrono) |
| `NFeRetAutorizacao` | Consulta resultado de lote assíncrono |
| `NFeConsultaProtocolo` | Consulta situação por chave de acesso |
| `NFeInutilizacao` | Inutiliza faixa de numeração |
| `NFeStatusServico` | Verifica disponibilidade SEFAZ |
| `NFeConsultaCadastro` | Consulta cadastro contribuinte |
| `NFeRecepcaoEvento` | Eventos (cancelamento, CC-e, manifestação) |
| `NFeDistribuicaoDFe` | Download de NF-e destinadas |

**Comunicação:** SOAP sobre TLS 1.2+ com autenticação mútua (certificado ICP-Brasil).

**Autorizadores por UF:** AM, BA, GO, MG, MS, MT, PE, PR, RS, SP possuem SEFAZ própria. Demais UFs usam SVRS (SEFAZ Virtual RS) ou SVAN.

### 10.2 Estratégia de Resiliência

```
1. StatusServico a cada 5 minutos
2. Se indisponível por 3 verificações consecutivas:
   → Ativar contingência (SVC-AN ou SVC-RS)
   → Logar evento
3. Retry com backoff exponencial: 5s → 15s → 30s
4. Timeout HTTP: NUNCA reenviar. Consultar protocolo primeiro
5. Quando SEFAZ volta: retransmitir NF-e pendentes
```

### 10.3 Recomendação: Middleware/Gateway

Para simplificar a implementação, recomenda-se usar um gateway de documentos fiscais:

| Gateway | Tipo | Cobertura |
|---------|------|-----------|
| TecnoSpeed | SaaS/API REST | NF-e/NFC-e/NFS-e/CT-e/MDF-e |
| FocusNFe | SaaS/API REST | Ampla, boa documentação |
| Webmania | SaaS/API REST | Integração REST simples |
| eNotas | SaaS/API REST | Foco em NFS-e |

**Benefícios:** Abstrai certificados, gerencia URLs por UF, trata contingência, suporta NFS-e multi-município, armazena XML por 5+ anos.

---

## 11. Integração Entre Módulos

### 11.1 Vendas → Faturamento → NF-e (Saída)

```
PedidoVenda (aprovado)
    │
    ▼
FaturamentoVenda → Gerar XML NF-e → Assinar → Transmitir SEFAZ
    │                                              │
    ├── Autorizada (cStat=100):                    │
    │   ├── Salvar protocolo + XML                 │
    │   ├── Gerar DANFE                            │
    │   ├── Criar ContaReceber (parcelas)          │
    │   ├── Baixar Estoque                         │
    │   ├── Registrar Livro Fiscal Saída           │
    │   └── Gerar Lançamento Contábil              │
    │                                              │
    └── Rejeitada:                                 │
        └── Notificar usuário com motivo           │
```

### 11.2 Compras → Recebimento → NF-e (Entrada)

```
XML NF-e Fornecedor (manifesto ou upload)
    │
    ▼
Validar × OrdemCompra (qtde, preços, NCM)
    │
    ▼
Escriturar NF-e Entrada:
    ├── Registrar Livro Fiscal Entrada
    ├── Calcular créditos: ICMS, PIS, COFINS, IPI
    ├── ICMS-ST retido → registrar como custo
    ├── Criar ContaPagar:
    │   ├── Calcular retenções (IRRF, PIS/COFINS/CSLL, ISS, INSS)
    │   ├── Valor líquido = Valor nota - Retenções
    │   └── Gerar DARF para cada retenção
    ├── Entrada no Estoque (custo aquisição)
    └── Gerar Lançamento Contábil
```

### 11.3 Estoque → Inventário → SPED

```
InventarioFisico → Valorização → SPED Fiscal Bloco H
    ├── H005: Totais do inventário
    ├── H010: Item (código, descrição, unidade, qtde, valor unitário, valor total)
    └── H020: Complementar (lote, validade)
```

### 11.4 Financeiro → Impostos → Guias

```
Apuração Periódica (mensal):
    ├── ICMS: débitos (saídas) - créditos (entradas) = saldo → GNRE/DARE
    ├── PIS/COFINS: débitos - créditos = valor a pagar → DARF
    ├── IRPJ/CSLL: base presumida ou real → DARF
    ├── Simples Nacional: receita bruta × alíquota efetiva → DAS
    └── Guias geram títulos no Contas a Pagar
```

### 11.5 Lançamentos Contábeis Automáticos

| Evento | Débito | Crédito |
|--------|--------|---------|
| Venda (NF-e saída) | Clientes | Receita de Vendas |
| ICMS sobre vendas | ICMS s/ Vendas | ICMS a Recolher |
| PIS sobre vendas | PIS s/ Vendas | PIS a Recolher |
| COFINS sobre vendas | COFINS s/ Vendas | COFINS a Recolher |
| CMV | CMV | Estoque Mercadorias |
| Compra (NF-e entrada) | Estoque Mercadorias | Fornecedores |
| Crédito ICMS | ICMS a Recuperar | Fornecedores |
| Crédito PIS | PIS a Recuperar | Fornecedores |
| Pagamento fornecedor | Fornecedores | Banco |
| Recolhimento imposto | ICMS a Recolher | Banco |

---

## 12. Relatórios e KPIs

### 12.1 Relatórios Operacionais

| Relatório | Descrição |
|-----------|-----------|
| **Livro de Entradas** | NF-e de entrada escrituradas por período |
| **Livro de Saídas** | NF-e de saída emitidas por período |
| **Apuração ICMS** | Demonstrativo mensal de débitos × créditos |
| **Apuração PIS/COFINS** | Demonstrativo mensal por regime |
| **Mapa de NF-e** | Status de todas as NF-e emitidas (autorizada, cancelada, rejeitada, inutilizada) |
| **NF-e Rejeitadas** | Notas rejeitadas com motivo e ação pendente |
| **Retenções na Fonte** | Retenções calculadas por fornecedor/período |
| **Guias de Recolhimento** | Guias geradas com status de pagamento |
| **Validade Certificado** | Alerta de certificados próximos ao vencimento |

### 12.2 Dashboard KPIs

| KPI | Descrição |
|-----|-----------|
| NF-e emitidas (mês) | Total de NF-e autorizadas no mês |
| NF-e rejeitadas (mês) | Total de rejeições e taxa de sucesso |
| Valor faturado (mês) | Soma dos valores das NF-e de saída |
| ICMS a recolher | Saldo devedor do ICMS |
| PIS/COFINS a recolher | Valor das contribuições |
| Guias pendentes | Guias não pagas vencidas ou a vencer |
| Créditos acumulados | Saldo credor de ICMS, PIS, COFINS |
| Status SEFAZ | Disponibilidade da SEFAZ da UF |

---

## 13. Especificidades do Setor Óptico

### 13.1 Tributação de Produtos Ópticos

| Produto | NCM | ICMS | IPI | ST | Observação |
|---------|-----|------|-----|-----|------------|
| Lentes oftálmicas | 9001.40/50 | Normal | 5% | Varia por UF | Algumas UFs concedem isenção/redução |
| Armações | 9003.11/19 | Normal | 10% | Varia por UF | ST comum (CEST 20.xxx) |
| Óculos de sol | 9004.10 | Normal | 15% | Varia por UF | IPI mais alto |
| Óculos de correção | 9004.90 | Normal | 5% | Varia por UF | Pode ter redução BC |
| Lentes de contato | 9001.50 | Normal | 5% | Varia por UF | Regime monofásico PIS/COFINS em alguns casos |
| Soluções para lentes | 3307.90 | Normal | 0% | Varia por UF | — |
| Acessórios (cases, cordões) | 4202/6307 | Normal | 5-15% | Varia por UF | — |

### 13.2 Serviços Ópticos

| Serviço | Tributação |
|---------|-----------|
| Consulta optométrica | NFS-e com ISS (2-5%) |
| Montagem/ajuste de óculos | Incluso na venda (NF-e) ou NFS-e separada |
| Assistência técnica | NFS-e com ISS |
| Surfaçagem de lentes | NF-e (industrialização por encomenda) |

### 13.3 Benefícios Fiscais Comuns

- Redução de base ICMS para produtos médicos/ópticos em alguns estados
- Convênio ICMS 01/99: Isenção ICMS para equipamentos/insumos para pessoas com deficiência (inclui lentes oftálmicas em alguns casos)
- Simples Nacional: maioria das óticas pequenas são optantes

---

## 14. Reforma Tributária (EC 132/2023)

### 14.1 Novos Tributos

| Tributo | Substitui | Competência |
|---------|-----------|-------------|
| **CBS** (Contribuição sobre Bens e Serviços) | PIS + COFINS | Federal |
| **IBS** (Imposto sobre Bens e Serviços) | ICMS + ISS | Estadual + Municipal |
| **IS** (Imposto Seletivo) | Novo | Federal (produtos prejudiciais à saúde/meio ambiente) |

### 14.2 Cronograma de Transição

| Ano | Evento |
|-----|--------|
| 2026 | Campos opcionais na NF-e (período de testes) |
| 2027 | CBS e IBS com alíquota teste (0,1% CBS + 0,1% IBS). PIS e COFINS extintos |
| 2029-2032 | Transição gradual: ICMS e ISS reduzem, IBS aumenta |
| 2033 | Extinção completa de ICMS e ISS |

### 14.3 Impacto no ERP

- **Coexistência de tributos** durante a transição (2027-2032): calcular ICMS + IBS + CBS simultaneamente
- **Novos grupos XML** na NF-e (cClassTrib, grupos IBS/CBS — NT 2025.002)
- **Split payment** automático via PIX (previsto para 2027+)
- **Requisito arquitetural:** Regras de tributação 100% parametrizáveis com vigência temporal. NUNCA hardcoded

---

## 15. Implicações Multi-Tenant

### 15.1 Configuração por Tenant

Cada tenant pode ter regime fiscal diferente:

```
Tenant A (Ótica pequena)           Tenant B (Rede de óticas)
├── Regime: Simples Nacional        ├── Regime: Lucro Real
├── ICMS: dentro do DAS             ├── PIS: 1,65% (não-cumulativo)
├── Certificado: cert_A.pfx         ├── COFINS: 7,60%
├── UF: SP                          ├── Certificado: cert_B.pfx
├── SPED Fiscal: dispensado          ├── UFs: SP, RJ, MG (3 IEs)
└── Obrigações: DASN-SIMEI          ├── SPED Fiscal: obrigatório
                                    └── EFD-Contribuições: obrigatório
```

### 15.2 Tabelas Public vs Tenant

**Schema PUBLIC (compartilhado, read-only):**
- `ncm_tributacao`, `cfop_operacao`, `cest_tributacao`
- `cst_icms`, `csosn_icms`, `cst_pis_cofins`, `cst_ipi`
- `aliquota_interestadual`, `codigo_servico_nacional`
- `certificados_digitais` (com FK para empresa)

**Schema TENANT (read-write):**
- `configuracao_fiscal`, `inscricoes_estaduais`
- `regras_tributarias`, `regras_tributarias_impostos`
- `sequencial_nfe`, `perfil_fiscal`
- `notas_fiscais`, `nota_fiscal_itens`, `nota_fiscal_item_impostos`
- `nota_fiscal_pagamentos`, `nota_fiscal_transportes`
- `nota_fiscal_referenciadas`, `eventos_nota_fiscal`
- `inutilizacoes_nfe`, `notas_fiscais_servico`
- `apuracoes_icms`, `apuracoes_icms_detalhes`
- `apuracoes_pis_cofins`, `apuracoes_pis_cofins_detalhes`
- `apuracoes_simples_nacional`
- `retencoes_fonte`, `guias_recolhimento`
- `arquivos_sped`, `audit_trail_fiscal`

**Total: ~9 tabelas public + ~22 tabelas tenant = ~31 tabelas**

---

## 16. Padrões Arquiteturais

### 16.1 Tax Calculation as a Service

```csharp
// Interface principal
public interface ITaxCalculationService
{
    Task<ResultadoCalculo> CalcularImpostosAsync(CalculoRequest request);
}

// Request: NCM, UF origem/destino, regime, perfil destinatário, CFOP, valores
// Response: CST, base de cálculo, alíquota, valor por imposto (ICMS, ST, IPI, PIS, COFINS, DIFAL, FCP)
```

### 16.2 Event-Driven Fiscal Processing

```
VendaFaturadaEvent
  ├── GerarNotaFiscalHandler → cria NotaFiscal "Pendente"
  ├── CalcularImpostosHandler → TaxCalculationService
  └── EnfileirarAutorizacaoHandler → fila

NfeAutorizacaoPendenteEvent (fila)
  ├── AssinarXmlHandler → certificado digital
  ├── TransmitirSefazHandler → SOAP/TLS
  └── ProcessarRetornoHandler → NfeAutorizadaEvent ou NfeRejeitadaEvent

NfeAutorizadaEvent
  ├── SalvarProtocoloHandler
  ├── GerarDanfeHandler
  ├── CriarContaReceberHandler
  ├── BaixarEstoqueHandler
  ├── RegistrarLivroFiscalHandler
  └── GerarLancamentoContabilHandler
```

### 16.3 XML Generation

**Recomendação:** Usar biblioteca de classes tipadas (ex: [Zeus.Net.NFe.NFCe](https://www.nuget.org/packages/Zeus.Net.NFe.NFCe) — NuGet, LGPL, atualizada para NFe 4.0).

### 16.4 XML Storage

**Abordagem híbrida recomendada:**
- Metadados + XML recente no banco (últimos 3-6 meses)
- XML histórico em Object Storage (S3/MinIO)
- **Retenção obrigatória:** Mínimo 5 anos (legislação geral), até 11 anos (nova regra 2025)

### 16.5 Audit Trail

Entidade `AuditTrailFiscal` — IMUTÁVEL (append-only). Registra TODAS as ações: criação, assinatura, envio, autorização, rejeição, cancelamento, impressão. Inclui request/response SEFAZ para debug.

---

## 17. Priorização Sugerida para Implementação

### Fase 1 — Fundação (MVP Fiscal)

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| ConfiguracaoFiscal | Crítica | Regime tributário, ambiente, série, certificado |
| RegraTributaria + RegraTributariaImposto | Crítica | Engine de regras parametrizáveis |
| TaxCalculationService | Crítica | Motor de cálculo de impostos |
| NotaFiscal + Item + Impostos + Pagamento | Crítica | Entidades de NF-e/NFC-e |
| CertificadoDigital | Crítica | Armazenamento seguro A1 |
| Integração com Gateway (TecnoSpeed/FocusNFe) | Crítica | Emissão, cancelamento, consulta |
| Tabelas auxiliares (NCM, CFOP, CST) | Crítica | Seeds com dados fiscais nacionais |

### Fase 2 — Operacional

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| EventoNotaFiscal | Alta | Cancelamento, CC-e, manifestação |
| InutilizacaoNfe | Alta | Controle de numeração |
| ApuracaoIcms | Alta | Apuração mensal com livros fiscais |
| ApuracaoPisCofins | Alta | Apuração por regime |
| GuiaRecolhimento | Alta | DARF, GNRE, DAS |
| RetencaoFonte | Alta | IRRF, PIS/COFINS/CSLL, ISS, INSS |
| NotaFiscalServico (NFS-e) | Alta | Padrão Nacional |

### Fase 3 — Avançado

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| ApuracaoSimplesNacional | Média | Cálculo DAS |
| ArquivoSped | Média | Geração EFD-ICMS/IPI, EFD-Contribuições |
| AuditTrailFiscal | Média | Trilha de auditoria completa |
| InscricaoEstadual | Média | Múltiplas UFs/filiais |
| Contingência automática | Média | SVC-AN/RS, EPEC, Offline NFC-e |

### Fase 4 — Compliance Total

| Item | Prioridade | Descrição |
|------|-----------|-----------|
| ECD + ECF | Baixa | Exportação para SPED Contábil/Fiscal |
| EFD-Reinf | Baixa | Eventos de retenções |
| CT-e + MDF-e | Baixa | Somente se necessário |
| Reforma Tributária (IBS/CBS) | Baixa | Campos opcionais 2026, obrigatórios 2027+ |
| DANFE (geração PDF) | Baixa | Pode usar gateway |
| Dashboard Fiscal | Baixa | KPIs e monitoramento |

---

## 18. Fontes da Pesquisa

### Legislação e Normas
- [Portal Nacional da NF-e — SEFAZ](https://www.nfe.fazenda.gov.br/)
- [MOC NF-e 4.00 — Leiaute](http://moc.sped.fazenda.pr.gov.br/Leiaute.html)
- [Lei Complementar 116/2003 — ISS](https://www.planalto.gov.br/ccivil_03/leis/lcp/lcp116.htm)
- [EC 87/2015 — DIFAL](https://www.planalto.gov.br/ccivil_03/constituicao/emendas/emc/emc87.htm)
- [EC 132/2023 — Reforma Tributária](https://www.planalto.gov.br/ccivil_03/constituicao/emendas/emc/emc132.htm)
- [Portal NFS-e Nacional](https://www.gov.br/nfse/pt-br)
- [SPED — Receita Federal](http://sped.rfb.gov.br/)

### ERPs de Referência
- [Microsoft Dynamics 365 — Brazil Tax Reform](https://learn.microsoft.com/en-us/dynamics365/finance/localizations/brazil/brazil-reform-overview)
- [SAP S/4HANA — Brazilian Localization](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE)
- [TOTVS Protheus — SIGAFIS](https://tdn.totvs.com/)
- [Senior — Parametrização Reforma Tributária](https://documentacao.senior.com.br/)

### Implementação Técnica
- [Zeus.Net.NFe.NFCe — NuGet](https://www.nuget.org/packages/Zeus.Net.NFe.NFCe)
- [Zeus DFe.NET — GitHub](https://github.com/ZeusAutomacao/DFe.NET)
- [TecnoSpeed — NF-e](https://blog.tecnospeed.com.br/nota-fiscal-eletronica-nf-e/)
- [FocusNFe — Documentação](https://focusnfe.com.br/doc/)
- [eNotas — Emitir NF-e em C#](https://enotas.com.br/blog/emitir-nfe-c-sharp/)

### Tributação e Cálculos
- [Contabilizei — Tabela CFOP Completa](https://www.contabilizei.com.br/contabilidade-online/tabela-cfop-completa/)
- [Portal Tributário — ISS](https://www.portaltributario.com.br/tributos/iss.html)
- [Tributei — NCM e CEST](https://tributei.net/blog/ncm-e-cest/)
- [Qive — Status NF-e](https://qive.com.br/blog/status-nota-fiscal-eletronica-sefaz)
- [NetCPA — ISS Retido](https://netcpa.com.br/colunas/iss-retido/)
- [Conta Azul — CST](https://contaazul.com/blog/codigos-de-situacao-tributaria/)
- [Guinzo — CST e CSOSN](https://site.guinzo.com.br/cst-e-csosn-de-icms/)

### Obrigações Acessórias
- [TecnoSpeed — SPED Fiscal Guia Completo](https://blog.tecnospeed.com.br/sped-fiscal-o-guia-completo/)
- [RFB — EFD-Contribuições](http://sped.rfb.gov.br/pagina/show/284)
- [RFB — EFD-Reinf](http://sped.rfb.gov.br/pagina/show/2965)
- [RFB — ECD](http://sped.rfb.gov.br/pagina/show/499)
- [RFB — ECF](http://sped.rfb.gov.br/pagina/show/1285)

### Segurança e Certificados
- [TecnoSpeed — Certificado A1 e A3](https://blog.tecnospeed.com.br/certificado-a1-a3/)
- [TOTVS — Certificado A1](https://www.totvs.com/blog/gestao-para-assinatura-de-documentos/certificado-a1/)

### Reforma Tributária
- [Avalara — ERP em Nuvem e Gestão Fiscal](https://www.avalara.com/br/pt/blog/2025/08/erp-em-nuvem-gestao-fiscal.html)
- [e-Auditoria — NF-e na Reforma Tributária](https://www.e-auditoria.com.br/blog/guia-completo-para-a-emissao-de-nota-fiscal-na-reforma-tributaria/)
- [TecnoSpeed — Reforma Tributária NF-e](https://blog.tecnospeed.com.br/nota-tecnica-reforma-tributaria-nfe-nfce/)
- [Fiscal Requirements — Brazil Tax Reform 2026](https://www.fiscal-requirements.com/news/4809)
