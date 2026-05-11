# Pesquisa Completa: Modulo Financeiro para ERP Brasileiro

> Pesquisa realizada em 2026-02-28 para fundamentar o desenvolvimento do modulo financeiro do OpticalCore ERP.

---

## Indice

1. [Entidades Propostas](#1-entidades-propostas)
2. [Contas a Pagar](#2-contas-a-pagar)
3. [Contas a Receber](#3-contas-a-receber)
4. [Parcelas e Condicoes de Pagamento](#4-parcelas-e-condicoes-de-pagamento)
5. [Conciliacao Bancaria](#5-conciliacao-bancaria)
6. [Fluxo de Caixa](#6-fluxo-de-caixa)
7. [Plano de Contas](#7-plano-de-contas)
8. [Centro de Custo](#8-centro-de-custo)
9. [DRE — Demonstracao do Resultado do Exercicio](#9-dre--demonstracao-do-resultado-do-exercicio)
10. [Tesouraria](#10-tesouraria)
11. [Lancamentos Contabeis](#11-lancamentos-contabeis)
12. [Integracao Entre Modulos](#12-integracao-entre-modulos)
13. [Dashboard Financeiro — KPIs](#13-dashboard-financeiro--kpis)
14. [Relatorios Padrao](#14-relatorios-padrao)
15. [Requisitos Fiscais Brasileiros](#15-requisitos-fiscais-brasileiros)
16. [Especificidades do Setor Optico](#16-especificidades-do-setor-optico)
17. [Comparativo com ERPs de Referencia](#17-comparativo-com-erps-de-referencia)
18. [Modelo de Entidades Proposto](#18-modelo-de-entidades-proposto)
19. [Bibliotecas .NET Recomendadas](#19-bibliotecas-net-recomendadas)
20. [Fases de Implementacao Recomendadas](#20-fases-de-implementacao-recomendadas)
21. [Fontes da Pesquisa](#21-fontes-da-pesquisa)

---

## 1. Entidades Propostas

### 1.1 Dados Mestres

| Entidade | Descrição |
|----------|-----------|
| **PlanoConta** | Plano de contas hierárquico (5 níveis), padrão CPC/IFRS |
| **CentroCusto** | Centros de custo hierárquicos (departamento, filial, projeto) |
| **ContaBancaria** | Contas bancárias da empresa (corrente, poupança, investimento) |
| **NaturezaFinanceira** | Classificação da natureza (receita/despesa operacional, financeira, etc.) |

### 1.2 Dados Transacionais

| Entidade | Descrição |
|----------|-----------|
| **ContaPagar** | Títulos a pagar (fornecedores, despesas, impostos, comissões) |
| **ContaReceber** | Títulos a receber (vendas, serviços, crediário) |
| **BaixaFinanceira** | Registro de cada pagamento/recebimento (parcial ou total) |
| **MovimentoBancario** | Movimentações em contas bancárias (créditos e débitos) |
| **TransferenciaBancaria** | Transferências entre contas da mesma empresa |
| **LancamentoContabil** | Lançamentos contábeis (partida dobrada) |
| **PartidaLancamento** | Partidas de débito/crédito de cada lançamento |
| **ChequeEmitido** | Cheques emitidos pela empresa |
| **ChequeRecebido** | Cheques recebidos de terceiros |
| **RecebiveisCartao** | Recebíveis de operadoras de cartão (crédito/débito) |

### 1.3 Dados de Suporte

| Entidade | Descrição |
|----------|-----------|
| **DespesaRecorrente** | Template para geração automática de contas a pagar recorrentes |
| **ReguaCobranca** | Régua de cobrança configurável (etapas de dunning) |
| **ReguaCobrancaEtapa** | Etapas individuais da régua (D-3, D+7, D+30, etc.) |
| **ExtratoBancario** | Extratos importados (OFX/CNAB) para conciliação |
| **ConciliacaoBancaria** | Registro de conciliação (match entre ERP e banco) |
| **RateioModelo** | Modelos de rateio de centro de custo |
| **OrcamentoFinanceiro** | Orçamento financeiro por período e plano de contas |
| **TaxaCartao** | Taxas por operadora/bandeira para cálculo de recebíveis |

### 1.4 Domínios / Lookup Tables

| Domínio | Seeds | Observação |
|---------|-------|-----------|
| **FormaPagamento** | 8 (existente) | Dinheiro, Cartão Crédito/Débito, PIX, Boleto, Cheque, Transferência, Vale/Crédito Loja |
| **CondicaoPagamento** | 12 (existente) | À Vista, 30d, 60d, 30/60/90, Cartão 1-12x |
| **TipoDocumentoFinanceiro** | 8 | NF, Duplicata, Boleto, Cheque, Recibo, Nota Crédito, Fatura, Nota Promissória |
| **CategoriaFinanceira** | 10 | Receita Vendas, CMV, Despesa Operacional, Despesa Administrativa, Despesa Comercial, Receita Financeira, Despesa Financeira, Impostos, Pessoal, Outros |
| **NaturezaContabil** | 2 | Devedora, Credora |
| **TipoCentroCusto** | 4 | Departamento, Filial, Projeto, Atividade |

### 1.5 Resumo Numérico

| Categoria | Quantidade |
|-----------|-----------|
| Entidades Mestres | 4 |
| Entidades Transacionais | 10 |
| Entidades Suporte | 8 |
| Domínios (novos) | 4 |
| Domínios (existentes reutilizados) | 2 |
| **Total** | **28** |

---

## 2. Contas a Pagar

### 2.1 Campos Chave

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `Id` | Guid (PK) | Identificador único |
| `Codigo` | int | Auto-incremental, 8 dígitos zero-padded |
| `NumeroDocumento` | string | Número da NF, duplicata, boleto |
| `Parcela` | string | Identificação da parcela "01", "02", etc. |
| `TipoDocumentoId` | Guid? | FK → TipoDocumentoFinanceiro |
| `FornecedorId` | Guid | FK → Pessoa (fornecedor) |
| `CompradorId` | Guid? | FK → Funcionário (responsável) |
| `DataEmissao` | DateTime | Data de emissão do documento |
| `DataEntrada` | DateTime | Data de entrada no sistema |
| `DataVencimento` | DateTime | Data de vencimento original |
| `DataVencimentoReal` | DateTime? | Data de vencimento prorrogada |
| `DataPagamento` | DateTime? | Data do pagamento efetivo |
| `DataCompetencia` | DateTime? | Mês/ano de competência contábil |
| `ValorOriginal` | decimal | Valor do título |
| `ValorDesconto` | decimal | Desconto concedido |
| `ValorJuros` | decimal | Juros de mora |
| `ValorMulta` | decimal | Multa de atraso (max 2% CDC) |
| `ValorAcrescimos` | decimal | Outros acréscimos |
| `ValorAbatimento` | decimal | Abatimento negociado |
| `ValorPago` | decimal | Total efetivamente pago |
| `Saldo` | decimal | Valor em aberto |
| `FormaPagamentoId` | Guid? | FK → FormaPagamento |
| `CondicaoPagamentoId` | Guid? | FK → CondicaoPagamento |
| `PlanoContaId` | Guid? | FK → PlanoConta |
| `CentroCustoId` | Guid? | FK → CentroCusto |
| `ContaBancariaId` | Guid? | FK → ContaBancaria |
| `CategoriaFinanceiraId` | Guid? | FK → CategoriaFinanceira |
| `OrigemTipo` | string | "OrdemCompra", "RecebimentoMercadoria", "ContratoCompra", "DespesaRecorrente", "Manual" |
| `OrigemId` | Guid? | FK polimórfica para documento de origem |
| `OrdemCompraId` | Guid? | FK direta → OrdemCompra |
| `RecebimentoMercadoriaId` | Guid? | FK direta → RecebimentoMercadoria |
| `Status` | string | Status do título (ver workflow) |
| `Recorrente` | bool | Se é título recorrente |
| `Renegociada` | bool | Se foi renegociada |
| `TituloOrigemId` | Guid? | FK para título original (se renegociação) |
| `Observacoes` | string? | Observações livres |

### 2.2 Workflow / Ciclo de Vida

```
                         ┌──────────────┐
                         │   Rascunho   │
                         └──────┬───────┘
                                │ (confirmar)
                         ┌──────▼───────┐
                    ┌────│    Aberta    │◄───────────────────┐
                    │    └──────┬───────┘                    │
                    │           │                            │
          (venceu)  │    ┌──────┼──────────────┐             │
                    │    │      │              │             │
             ┌──────▼────▼┐ ┌──▼──────┐ ┌─────▼──────┐     │
             │   Vencida  │ │  Paga   │ │PagaParcial │     │
             │(automático)│ │(total)  │ │            │     │
             └──────┬─────┘ └─────────┘ └─────┬──────┘     │
                    │                          │ (pagar     │
             ┌──────▼──────┐            ┌──────▼──────┐     │
             │ Renegociada │            │    Paga     │     │
             │(gera novos  │────────────►             │     │
             │  títulos)   │            └─────────────┘     │
             └──────┬──────┘                                │
                    └───────────────────────────────────────┘
                          (novos títulos)

             ┌─────────────┐
             │  Cancelada  │ (de qualquer status exceto Paga)
             └─────────────┘
```

**Status:** Rascunho → Aberta → Vencida (automático) → PagaParcial → Paga → Renegociada → Cancelada

### 2.3 Tipos de Baixa

| Tipo | Descrição | Efeito |
|------|-----------|--------|
| **Baixa Normal** | Pagamento total | Status → Paga, Saldo = 0 |
| **Baixa Parcial** | Pagamento de parte | Status → PagaParcial, Saldo reduzido |
| **Baixa por Substituição** | Renegociação | Status → Renegociada, gera novos títulos |
| **Baixa por Cancelamento** | Cancelamento | Status → Cancelada |
| **Baixa por Abatimento** | Desconto/crédito aplicado | Reduz ValorOriginal |

### 2.4 Aprovação de Pagamento

Reutiliza o padrão `FluxoAprovacao` + `NivelAprovacao` + `AprovacaoHistorico` do módulo Compras:
- **Nível 1:** Analista Financeiro (até R$ 5.000)
- **Nível 2:** Coordenador Financeiro (até R$ 20.000)
- **Nível 3:** Gerente Financeiro (até R$ 100.000)
- **Nível 4:** Diretor/Proprietário (acima de R$ 100.000)

### 2.5 Despesas Recorrentes

```
DespesaRecorrente
├── Id                       : Guid (PK)
├── Descricao                : string ("Aluguel", "Internet", "Energia")
├── FornecedorId             : Guid? (FK)
├── ValorBase                : decimal
├── FormaPagamentoId         : Guid?
├── PlanoContaId             : Guid?
├── CentroCustoId            : Guid?
├── Frequencia               : string ("Mensal", "Quinzenal", "Anual")
├── DiaVencimento            : int (1-31)
├── DataInicio               : DateTime
├── DataFim                  : DateTime? (null = indefinido)
├── ProximaGeracao           : DateTime
├── Ativo                    : bool
│
└── Titulos                  : List<ContaPagar> (nav)
```

Um job/service gera ContaPagar automaticamente com base nos templates ativos.

### 2.6 Aging de Contas a Pagar

| Faixa | Descrição |
|-------|-----------|
| A Vencer (0-30d) | Títulos com vencimento nos próximos 30 dias |
| A Vencer (31-60d) | Títulos com vencimento em 31-60 dias |
| A Vencer (61-90d) | Títulos com vencimento em 61-90 dias |
| A Vencer (91+d) | Títulos com vencimento em 91+ dias |
| Vencidos (1-30d) | Títulos vencidos há 1-30 dias |
| Vencidos (31-60d) | Títulos vencidos há 31-60 dias |
| Vencidos (61-90d) | Títulos vencidos há 61-90 dias |
| Vencidos (91-120d) | Títulos vencidos há 91-120 dias |
| Vencidos (121+d) | Títulos vencidos há mais de 120 dias |

---

## 3. Contas a Receber

### 3.1 Campos Chave

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `Id` | Guid (PK) | Identificador único |
| `Codigo` | int | Auto-incremental, 8 dígitos |
| `NumeroDocumento` | string | Número da NF de saída |
| `Parcela` | string | Identificação "01", "02" |
| `TipoDocumentoId` | Guid? | FK → TipoDocumentoFinanceiro |
| `ClienteId` | Guid | FK → Pessoa (cliente) |
| `VendedorId` | Guid? | FK → Funcionário |
| `DataEmissao` | DateTime | Data de emissão |
| `DataVencimento` | DateTime | Data de vencimento |
| `DataVencimentoProrrogado` | DateTime? | Vencimento prorrogado |
| `DataRecebimento` | DateTime? | Data do recebimento efetivo |
| `DataCompetencia` | DateTime? | Mês/ano de competência |
| `ValorOriginal` | decimal | Valor nominal |
| `ValorDesconto` | decimal | Desconto concedido |
| `ValorJuros` | decimal | Juros cobrados (max 1%/mês) |
| `ValorMulta` | decimal | Multa cobrada (max 2% CDC) |
| `ValorAcrescimos` | decimal | Outros acréscimos |
| `ValorAbatimento` | decimal | Abatimento/crédito |
| `ValorRecebido` | decimal | Total efetivamente recebido |
| `Saldo` | decimal | Valor em aberto |
| `FormaPagamentoId` | Guid? | FK → FormaPagamento |
| `CondicaoPagamentoId` | Guid? | FK → CondicaoPagamento |
| `PlanoContaId` | Guid? | FK → PlanoConta |
| `CentroCustoId` | Guid? | FK → CentroCusto |
| `ContaBancariaId` | Guid? | FK → ContaBancaria |
| `OrigemTipo` | string | "PedidoVenda", "FaturamentoVenda", "Crediario", "Manual" |
| `OrigemId` | Guid? | FK polimórfica |
| `PedidoVendaId` | Guid? | FK direta → PedidoVenda |
| `FaturamentoVendaId` | Guid? | FK direta → FaturamentoVenda |
| `NossoNumero` | string? | Nosso número do boleto |
| `CodigoBarras` | string? | Código de barras do boleto |
| `LinhaDigitavel` | string? | Linha digitável |
| `PixCopiaECola` | string? | Código PIX copia e cola |
| `PixTxId` | string? | Transaction ID do PIX |
| `SituacaoCobranca` | string? | "Carteira", "EmBanco", "Protestada", "Negativada" |
| `DataProtesto` | DateTime? | Data de envio para protesto |
| `DataNegativacao` | DateTime? | Data de negativação SPC/Serasa |
| `Status` | string | Status do título |
| `Renegociada` | bool | Se foi renegociada |
| `TituloOrigemId` | Guid? | FK para título original |
| `Observacoes` | string? | |

### 3.2 Workflow / Ciclo de Vida

```
                         ┌──────────────┐
                         │   Rascunho   │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                    ┌────│    Aberta    │◄───────────────────┐
                    │    └──────┬───────┘                    │
                    │           │                            │
          (venceu)  │    ┌──────┼──────────────┐             │
                    │    │      │              │             │
             ┌──────▼────▼┐ ┌──▼───────┐ ┌────▼───────┐    │
             │   Vencida  │ │ Recebida │ │ Recebida   │    │
             │(automático)│ │ (total)  │ │ Parcial    │    │
             └──────┬─────┘ └──────────┘ └─────┬──────┘    │
                    │                           │           │
             ┌──────▼──────┐             ┌──────▼──────┐    │
             │ Em Cobrança │             │  Recebida   │    │
             │(régua cobr.)│             └─────────────┘    │
             └──────┬──────┘                                │
                    │                                       │
             ┌──────▼──────┐    ┌──────────────┐            │
             │ Negativada  │    │ Renegociada  │────────────┘
             │(SPC/Serasa) │    └──────────────┘
             └──────┬──────┘
                    │
             ┌──────▼──────┐
             │  Protestada │
             └─────────────┘

             ┌─────────────┐    ┌─────────────┐
             │  Cancelada  │    │   Perdida   │ (PDD - Provisão Devedores Duvidosos)
             └─────────────┘    └─────────────┘
```

### 3.3 Régua de Cobrança (Dunning)

| Dia | Ação | Canal |
|-----|------|-------|
| D-3 | Lembrete preventivo | WhatsApp/SMS |
| D+0 | Notificação de vencimento | Email |
| D+3 | Primeiro aviso de atraso | Email |
| D+7 | Segundo aviso | WhatsApp + SMS |
| D+15 | Terceiro aviso formal | Telefone/Email |
| D+30 | Negativação SPC/Serasa | Sistema |
| D+60 | Protesto em cartório | Sistema |
| D+90 | Análise para baixa como perda (PDD) | Manual |

### 3.4 Negativação (SPC/Serasa)

- Dívida só pode ser reportada **após** o vencimento
- Devedor **deve ser notificado** antes da negativação
- Prazo máximo em cadastro: **5 anos** da data de vencimento
- Após pagamento, credor tem **5 dias úteis** para remover registro
- Negativação indevida gera **danos morais** (indenização)

### 3.5 Crediário Próprio (Específico Varejo Óptico)

O crediário próprio é financiamento direto da loja, sem intermediários. Essencial para óticas:
- Ticket médio alto (R$ 400 a R$ 2.000+)
- Muitos clientes sem cartão com limite suficiente
- Fidelização (cliente retorna para novas compras)
- Margem de lentes absorve risco de inadimplência

**Fluxo:** Venda → Análise de Crédito → Geração do Carnê → Parcelas mensais (boleto, PIX ou caixa)

---

## 4. Parcelas e Condições de Pagamento

### 4.1 Geração Automática de Parcelas

Cada parcela é um registro individual de ContaPagar/ContaReceber, seguindo o padrão brasileiro (TOTVS, Senior, Omie):

```
FaturamentoVenda (Autorizado)
    │
    ├── CondicaoPagamento = "À Vista"     → 1 parcela, venc = data emissão
    ├── CondicaoPagamento = "30 dias"     → 1 parcela, venc = +30d
    ├── CondicaoPagamento = "30/60/90"    → 3 parcelas (33.33% cada)
    ├── CondicaoPagamento = "Entrada+2x"  → 3 parcelas (à vista + 30d + 60d)
    └── CondicaoPagamento = "12x c/juros" → 12 parcelas (Tabela Price)
```

### 4.2 Evolução de CondicaoPagamento

A entidade atual `CondicaoPagamento` (BaseDominio) precisa ser estendida com regras de parcelamento:

```
CondicaoPagamentoRegra
├── Id                      : Guid
├── CondicaoPagamentoId     : Guid (FK)
├── NumeroParcela           : int (1, 2, 3...)
├── DiasParaVencimento      : int (0, 30, 60, 90...)
├── PercentualValor         : decimal (33.33, 33.33, 33.34)
├── FormaPagamentoId        : Guid? (pode variar por parcela)
```

### 4.3 Métodos de Cálculo de Juros

| Método | Fórmula | Uso |
|--------|---------|-----|
| **Juros Simples** | `J = V × (taxa/30) × diasAtraso` | Padrão para títulos vencidos |
| **Juros Compostos** | `VF = V × (1 + taxa)^(dias/30)` | Crediário com juros |
| **Tabela Price** | `PMT = PV × [i(1+i)^n] / [(1+i)^n - 1]` | Parcelamento com juros fixos |
| **Multa de Mora** | `Multa = V × 2%` (máximo CDC) | Aplicada uma vez sobre atraso |

### 4.4 Formas de Pagamento — Especificidades Brasileiras

| Forma | Recebimento | Considerações |
|-------|-------------|---------------|
| **Dinheiro** | Imediato (D+0) | Risco de conferência de caixa |
| **PIX** | Imediato (D+0) | QR Code dinâmico, webhook automático, reconciliação por txid |
| **Cartão Débito** | D+1 | Taxa operadora ~1.5% |
| **Cartão Crédito 1x** | D+30 | Taxa operadora ~2-3.5% |
| **Cartão Crédito Nx** | D+30/60/90... | Cada parcela recebida mensalmente pela operadora |
| **Boleto** | D+1 após compensação | CNAB remessa/retorno, nosso número, protesto automático |
| **Cheque** | D+1 a D+2 compensação | Controle de custódia, compensação, devolução |
| **Crediário** | Conforme parcelas | Análise de crédito, carnê, risco próprio |
| **Convênio** | Mensal (desconto folha) | Acordo empresa ↔ ótica, planilha mensal |

---

## 5. Conciliacao Bancaria

### 5.1 Conceito

A conciliacao bancaria e o processo de confrontar as movimentacoes registradas no ERP (contas a pagar/receber, transferencias, taxas) com as transacoes reais reportadas pelo extrato bancario. O objetivo e identificar divergencias, lancamentos faltantes e garantir a integridade dos dados financeiros.

### 5.2 Formatos de Arquivo Brasileiros

#### OFX (Open Financial Exchange)

- **Versoes**: 1.x (SGML) e 2.x (XML puro)
- **Suporte**: Todos os principais bancos brasileiros exportam OFX (Banco do Brasil, Bradesco, Itau, Santander, Caixa, Sicoob, Sicredi, Inter, BTG, Stone, PagSeguro)
- **Estrutura principal**:
  - `<OFX>` — raiz do documento
  - `<BANKACCTFROM>` — identificacao da conta: `<BANKID>` (codigo banco), `<ACCTID>` (numero conta), `<ACCTTYPE>` (CHECKING/SAVINGS)
  - `<BANKTRANLIST>` — lista de transacoes do periodo
  - `<STMTTRN>` — cada transacao individual:
    - `<TRNTYPE>` — DEBIT, CREDIT, INT, DIV, FEE, SRVCHG, DEP, ATM, POS, XFER, CHECK, PAYMENT, CASH, DIRECTDEP, DIRECTDEBIT, REPEATPMT, OTHER
    - `<DTPOSTED>` — data (YYYYMMDDHHMMSS)
    - `<TRNAMT>` — valor (positivo = credito, negativo = debito)
    - `<FITID>` — identificador unico da transacao no banco
    - `<CHECKNUM>` — numero do cheque (quando aplicavel)
    - `<NAME>` — descricao/favorecido
    - `<MEMO>` — informacoes adicionais
  - `<LEDGERBAL>` — saldo do extrato: `<BALAMT>` (valor), `<DTASOF>` (data)

#### CNAB 240 (Febraban)

- **Tamanho**: 240 posicoes (caracteres) por linha
- **Estrutura hierarquica**:
  - **Tipo 0** — Header do Arquivo: banco, empresa, data geracao, sequencial
  - **Tipo 1** — Header do Lote: tipo servico (cobranca, pagamento), forma lancamento
  - **Tipo 3** — Detalhe (segmentos):
    - **Segmento P** — Dados do titulo (nosso numero, valor, vencimento, especie) — OBRIGATORIO remessa
    - **Segmento Q** — Dados do sacado/pagador (nome, CPF/CNPJ, endereco) — OBRIGATORIO para novos titulos
    - **Segmento R** — Instrucoes adicionais (multa, juros, desconto) — opcional remessa
    - **Segmento S** — Mensagens ao sacado — opcional
    - **Segmento T** — Dados de liquidacao no retorno — OBRIGATORIO retorno
    - **Segmento U** — Complemento do retorno (juros, multa, desconto, valor pago) — OBRIGATORIO retorno
    - **Segmento A** — Pagamento a fornecedores (credito em conta)
    - **Segmento B** — Dados complementares do favorecido (CPF/CNPJ, endereco)
    - **Segmento J** — Pagamento de titulos (boleto) com codigo de barras
    - **Segmento O** — Pagamento de tributos/concessionarias com codigo de barras
  - **Tipo 5** — Trailer do Lote: totais do lote
  - **Tipo 9** — Trailer do Arquivo: totais gerais
- **Formatacao**: Numeros alinhados a direita com zeros a esquerda; Alfanumericos alinhados a esquerda com brancos a direita
- **Uso principal**: Cobranca (boletos) e Pagamentos (fornecedores, tributos, folha)

#### CNAB 400

- **Tamanho**: 400 posicoes por linha
- **Estrutura mais simples**: Header (tipo 0), Detalhes (tipo 1/7), Trailer (tipo 9)
- **Uso**: Empresas com menor volume transacional
- **Tendencia**: Sendo gradualmente substituido pelo CNAB 240
- **Diferenca pratica**: Cada banco tem variacoes especificas no layout

#### Remessa vs Retorno

| Aspecto | Remessa | Retorno |
|---------|---------|---------|
| **Direcao** | Empresa -> Banco | Banco -> Empresa |
| **Proposito** | Registrar cobrancas/pagamentos | Informar status (pago, rejeitado, etc.) |
| **Conteudo** | Dados do titulo/pagamento | Status + valores efetivos (juros, multa, desconto) |
| **Segmentos CNAB 240** | P, Q, R, S (cobranca) / A, B, J, O (pagamento) | T, U (cobranca) |

### 5.3 Algoritmos de Conciliacao (Matching)

#### Regras de Matching Automatico

1. **Match exato (1:1)**: Valor + Data + Documento identicos entre ERP e banco
2. **Match por valor e data**: Mesmo valor e data, descricao diferente (match provavel)
3. **Match por valor com tolerancia de data**: Mesmo valor, data +/- N dias uteis
4. **Match N:1 (agrupamento)**: Soma de N lancamentos do ERP = 1 credito/debito no banco (ex: deposito consolidado)
5. **Match 1:N (desdobramento)**: 1 lancamento do ERP = N transacoes no banco (ex: boleto com juros/multa em linhas separadas)
6. **Match por referencia**: Nosso Numero do boleto, numero do cheque, ID de transferencia

#### Criterios de Pontuacao (Scoring)

```
Score = peso_valor * match_valor + peso_data * match_data + peso_descricao * match_descricao + peso_referencia * match_referencia
```

- `match_valor`: 1.0 (exato), 0.8 (diferenca < 1%), 0.5 (diferenca < 5%), 0.0 (maior)
- `match_data`: 1.0 (mesmo dia), 0.8 (1 dia util), 0.5 (2-3 dias uteis), 0.0 (maior)
- `match_descricao`: 0.0 a 1.0 (similaridade textual — Levenshtein ou fuzzy match)
- `match_referencia`: 1.0 (match exato nosso numero/cheque), 0.0 (sem match)

#### Status da Conciliacao

| Status | Descricao |
|--------|-----------|
| `Pendente` | Transacao importada, aguardando conciliacao |
| `ConciliadoAutomatico` | Match automatico com score >= threshold |
| `ConciliadoManual` | Vinculado manualmente pelo usuario |
| `NaoIdentificado` | Sem match no ERP (deposito desconhecido, taxa bancaria) |
| `Divergente` | Match encontrado mas com diferenca de valor |
| `Ignorado` | Marcado pelo usuario como irrelevante |

### 5.4 Fluxo de Conciliacao no ERP

```
1. Importar extrato (OFX ou CNAB retorno)
2. Para cada transacao do banco:
   a. Buscar candidatos no ERP (titulos a pagar/receber, transferencias)
   b. Aplicar algoritmo de scoring
   c. Se score >= threshold -> conciliar automaticamente
   d. Se score < threshold -> marcar como pendente para revisao manual
3. Exibir dashboard:
   - Total conciliado automaticamente
   - Total pendente de revisao
   - Total nao identificado
   - Saldo do banco vs saldo do ERP
4. Revisao manual: usuario confirma, ajusta ou cria lancamento
5. Gerar relatorio de divergencias
```

### 5.5 Entidades para Conciliacao Bancaria

```
ContaBancaria
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── BancoId (Guid -> Banco dominio)
├── Agencia (string 10)
├── AgenciaDigito (string 2)
├── Conta (string 15)
├── ContaDigito (string 2)
├── TipoConta (enum: Corrente, Poupanca, Investimento, Caixa)
├── Descricao (string 100) — "Itau AG 1234 CC 56789-0"
├── SaldoInicial (decimal)
├── DataSaldoInicial (DateTime)
├── SaldoAtual (decimal) — atualizado por trigger/servico
├── Ativo (bool)
├── Padrao (bool) — conta padrao para recebimentos
├── ChavePix (string 100, nullable)
├── TipoChavePix (enum: CPF, CNPJ, Email, Telefone, Aleatoria, null)
├── CodigoBeneficiario (string 20) — para boletos CNAB
├── ConvenioCobranca (string 20) — numero convenio banco
└── CarteiraCnab (string 5) — carteira de cobranca

ExtratoBancario
├── Id (Guid)
├── ContaBancariaId (Guid FK)
├── DataImportacao (DateTime)
├── DataInicio (DateTime)
├── DataFim (DateTime)
├── SaldoInicial (decimal)
├── SaldoFinal (decimal)
├── FormatoOrigem (enum: OFX, CNAB240, CNAB400, Manual, API)
├── ArquivoOriginal (string) — path do arquivo importado
├── TotalCreditos (decimal)
├── TotalDebitos (decimal)
├── QuantidadeTransacoes (int)
├── Status (enum: Importado, EmConciliacao, Conciliado, Fechado)
└── Transacoes (List<TransacaoBancaria>)

TransacaoBancaria
├── Id (Guid)
├── ExtratoBancarioId (Guid FK)
├── ContaBancariaId (Guid FK)
├── Data (DateTime)
├── DataProcessamento (DateTime, nullable)
├── Tipo (enum: Credito, Debito)
├── Valor (decimal)
├── Descricao (string 200)
├── Memo (string 500, nullable)
├── FitId (string 50) — ID unico da transacao no banco (OFX FITID)
├── NumeroCheque (string 20, nullable)
├── NumeroDocumento (string 50, nullable)
├── CodigoTransacao (string 20, nullable)
├── TipoTransacao (string 50) — DEBIT, CREDIT, FEE, XFER, etc.
├── StatusConciliacao (enum: Pendente, ConciliadoAuto, ConciliadoManual, NaoIdentificado, Divergente, Ignorado)
├── ScoreConciliacao (decimal, nullable)
├── ConciliacaoId (Guid, nullable FK)
├── DataConciliacao (DateTime, nullable)
└── UsuarioConciliacao (Guid, nullable)

Conciliacao
├── Id (Guid)
├── TransacaoBancariaId (Guid FK)
├── TipoOrigem (string) — "TituloPagar", "TituloReceber", "Transferencia", "LancamentoManual"
├── OrigemId (Guid) — FK polimorfica
├── TipoConciliacao (enum: Automatica, Manual)
├── Score (decimal, nullable)
├── DiferencaValor (decimal) — diferenca entre banco e ERP (juros, multa, desconto)
├── Observacao (string 500, nullable)
└── DataConciliacao (DateTime)
```

---

## 6. Fluxo de Caixa

### 6.1 Conceito

O fluxo de caixa registra todas as entradas e saidas de dinheiro da empresa em regime de caixa (quando o dinheiro efetivamente entra ou sai). Divide-se em:

- **Realizado**: Movimentacoes que ja ocorreram (fato)
- **Projetado (Previsto)**: Movimentacoes futuras baseadas em titulos a pagar/receber e estimativas

### 6.2 Categorias do Fluxo de Caixa (CPC 03/IAS 7)

#### Atividades Operacionais
- **Entradas**: Recebimento de vendas, recebimento de clientes, juros recebidos
- **Saidas**: Pagamento a fornecedores, salarios, impostos, aluguel, despesas operacionais

#### Atividades de Investimento
- **Entradas**: Venda de ativos imobilizados, recebimento de emprestimos concedidos
- **Saidas**: Compra de equipamentos, investimentos em participacoes

#### Atividades de Financiamento
- **Entradas**: Emprestimos bancarios, aporte de capital
- **Saidas**: Pagamento de emprestimos, juros, dividendos, leasing

### 6.3 Modelo de 13 Semanas (Rolling Forecast)

O modelo de 13 semanas e o padrao para gestao de liquidez de curto/medio prazo:
- **Horizonte**: 13 semanas (trimestre)
- **Granularidade**: Semanal (colunas = semanas)
- **Atualizacao**: Semanal — toda semana a primeira semana vira "realizado" e uma nova semana e adicionada ao final
- **Linhas**: Categorias de entrada e saida agrupadas
- **Comparacao**: Projetado vs Realizado semana a semana

### 6.4 Visoes do Fluxo de Caixa

| Visao | Granularidade | Uso |
|-------|--------------|-----|
| Diaria | Por dia | Gestao de caixa imediata (proximos 30 dias) |
| Semanal | Por semana | Rolling 13 weeks, planejamento tatico |
| Mensal | Por mes | Planejamento estrategico, orcamento |
| Anual | Por ano | Visao macro, tendencias |

### 6.5 KPIs do Dashboard de Fluxo de Caixa

1. **Saldo Atual** — soma de todas as contas bancarias + caixa
2. **Saldo Projetado (7/15/30 dias)** — saldo atual + recebimentos previstos - pagamentos previstos
3. **Necessidade de Capital de Giro** — ativo circulante operacional - passivo circulante operacional
4. **Dias de Caixa** — saldo atual / media de saidas diarias
5. **Indice de Cobertura** — entradas previstas / saidas previstas (proximos 30 dias)
6. **Recebimentos em Atraso** — titulos vencidos a receber
7. **Pagamentos em Atraso** — titulos vencidos a pagar
8. **Saldo por Conta** — composicao do saldo por conta bancaria
9. **Tendencia 12 Meses** — grafico de evolucao do saldo
10. **Burn Rate** — taxa de consumo de caixa mensal

### 6.6 Entidades para Fluxo de Caixa

```
CategoriaFluxoCaixa
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── Nome (string 100) — "Vendas de Mercadorias", "Pagamento Fornecedores"
├── Tipo (enum: Entrada, Saida)
├── GrupoAtividade (enum: Operacional, Investimento, Financiamento)
├── CategoriaPaiId (Guid, nullable FK) — hierarquia
├── Ordem (int) — para ordenacao no relatorio
├── Ativo (bool)
└── Padrao (bool)

FluxoCaixa
├── Id (Guid)
├── Data (DateTime)
├── Tipo (enum: Realizado, Projetado)
├── CategoriaId (Guid FK)
├── ContaBancariaId (Guid FK, nullable)
├── Valor (decimal) — positivo para entradas, negativo para saidas
├── Descricao (string 200)
├── TituloOrigemTipo (string, nullable) — "TituloPagar", "TituloReceber"
├── TituloOrigemId (Guid, nullable) — FK polimorfica
├── Recorrente (bool)
├── RecorrenciaId (Guid, nullable) — para lancamentos recorrentes
└── Observacao (string 500, nullable)

ProjecaoFluxoCaixa
├── Id (Guid)
├── DataReferencia (DateTime) — data base da projecao
├── DataInicio (DateTime)
├── DataFim (DateTime)
├── Granularidade (enum: Diaria, Semanal, Mensal)
├── SaldoInicial (decimal)
├── TotalEntradas (decimal)
├── TotalSaidas (decimal)
├── SaldoFinal (decimal)
├── GeradoPor (Guid FK -> Usuario)
└── Itens (List<ProjecaoFluxoCaixaItem>)

ProjecaoFluxoCaixaItem
├── Id (Guid)
├── ProjecaoId (Guid FK)
├── Periodo (DateTime) — data do dia/semana/mes
├── CategoriaId (Guid FK)
├── ValorProjetado (decimal)
├── ValorRealizado (decimal, nullable) — preenchido quando o periodo passa
└── Desvio (decimal, computed) — realizado - projetado
```

---

## 7. Plano de Contas

### 7.1 Conceito e Base Legal

O Plano de Contas e a estrutura que organiza todas as contas contabeis da empresa, conforme:
- **Lei 6.404/1976** (Lei das S.A.)
- **CPC 26** (Apresentacao das Demonstracoes Contabeis)
- **Resolucao CFC 1.255/2009** (NBC TG 1000 — PMEs)
- **SPED Contabil (ECD)** — Registro 0500

### 7.2 Estrutura Hierarquica

```
Nivel 1: Classe (1 digito)          — 1 Ativo, 2 Passivo, 3 Receitas, 4 Despesas
Nivel 2: Grupo (2 digitos)          — 1.1 Circulante, 1.2 Nao Circulante
Nivel 3: Subgrupo (3 digitos)       — 1.1.1 Caixa e Equivalentes
Nivel 4: Conta Sintetica (4 dig.)   — 1.1.1.01 Caixa Geral
Nivel 5: Conta Analitica (5+ dig.)  — 1.1.1.01.001 Caixa Loja Centro
```

- **Contas Sinteticas**: Agrupam valores (nao recebem lancamentos diretos)
- **Contas Analiticas**: Recebem lancamentos contabeis

### 7.3 Natureza das Contas

| Grupo | Natureza | Saldo Normal | Aumenta com | Diminui com |
|-------|----------|-------------|-------------|-------------|
| Ativo | Devedora | Devedor | Debito | Credito |
| Passivo | Credora | Credor | Credito | Debito |
| Patrimonio Liquido | Credora | Credor | Credito | Debito |
| Receitas | Credora | Credor | Credito | Debito |
| Despesas | Devedora | Devedor | Debito | Credito |
| Custos | Devedora | Devedor | Debito | Credito |

### 7.4 Plano de Contas Modelo para Comercio Optico

```
1 ATIVO
  1.1 ATIVO CIRCULANTE
    1.1.1 CAIXA E EQUIVALENTES DE CAIXA
      1.1.1.01 Caixa Geral
      1.1.1.02 Caixa Pequeno (Fundo Fixo)
      1.1.1.03 Bancos Conta Movimento
        1.1.1.03.001 Banco do Brasil
        1.1.1.03.002 Itau
        1.1.1.03.003 Bradesco
        1.1.1.03.004 Santander
      1.1.1.04 Aplicacoes Financeiras de Liquidez Imediata
    1.1.2 CONTAS A RECEBER
      1.1.2.01 Clientes a Receber
      1.1.2.02 Cartoes de Credito a Receber
      1.1.2.03 Cartoes de Debito a Receber
      1.1.2.04 Cheques a Receber
      1.1.2.05 Convenios / Planos de Saude a Receber
      1.1.2.06 (-) Provisao para Devedores Duvidosos (PDD)
    1.1.3 ESTOQUES
      1.1.3.01 Mercadorias para Revenda — Armacoes
      1.1.3.02 Mercadorias para Revenda — Lentes Oftalmicas
      1.1.3.03 Mercadorias para Revenda — Lentes de Contato
      1.1.3.04 Mercadorias para Revenda — Oculos de Sol
      1.1.3.05 Mercadorias para Revenda — Acessorios Opticos
      1.1.3.06 Materiais de Consumo (Laboratorio)
      1.1.3.07 (-) Provisao para Perdas em Estoques
    1.1.4 TRIBUTOS A RECUPERAR
      1.1.4.01 ICMS a Recuperar
      1.1.4.02 PIS a Recuperar
      1.1.4.03 COFINS a Recuperar
      1.1.4.04 IRPJ Antecipado
      1.1.4.05 CSLL Antecipada
    1.1.5 OUTROS ATIVOS CIRCULANTES
      1.1.5.01 Adiantamento a Fornecedores
      1.1.5.02 Adiantamento a Funcionarios
      1.1.5.03 Despesas Antecipadas (seguros, alugueis)
  1.2 ATIVO NAO CIRCULANTE
    1.2.1 REALIZAVEL A LONGO PRAZO
      1.2.1.01 Clientes LP
      1.2.1.02 Depositos Judiciais
    1.2.2 IMOBILIZADO
      1.2.2.01 Moveis e Utensilios
      1.2.2.02 Equipamentos de Informatica
      1.2.2.03 Equipamentos Opticos (refratores, lensometros, etc.)
      1.2.2.04 Veiculos
      1.2.2.05 Instalacoes e Benfeitorias
      1.2.2.06 (-) Depreciacao Acumulada
    1.2.3 INTANGIVEL
      1.2.3.01 Softwares e Licencas
      1.2.3.02 Ponto Comercial / Luvas
      1.2.3.03 (-) Amortizacao Acumulada

2 PASSIVO
  2.1 PASSIVO CIRCULANTE
    2.1.1 FORNECEDORES
      2.1.1.01 Fornecedores Nacionais
      2.1.1.02 Fornecedores de Lentes
      2.1.1.03 Fornecedores de Armacoes
    2.1.2 OBRIGACOES TRABALHISTAS
      2.1.2.01 Salarios a Pagar
      2.1.2.02 INSS a Recolher
      2.1.2.03 FGTS a Recolher
      2.1.2.04 IRRF a Recolher (sobre salarios)
      2.1.2.05 Provisao de Ferias
      2.1.2.06 Provisao de 13o Salario
    2.1.3 OBRIGACOES TRIBUTARIAS
      2.1.3.01 ICMS a Recolher
      2.1.3.02 PIS a Recolher
      2.1.3.03 COFINS a Recolher
      2.1.3.04 Simples Nacional a Recolher
      2.1.3.05 ISS a Recolher
      2.1.3.06 IRPJ a Recolher
      2.1.3.07 CSLL a Recolher
    2.1.4 EMPRESTIMOS E FINANCIAMENTOS CP
      2.1.4.01 Emprestimos Bancarios CP
      2.1.4.02 Financiamentos CP
      2.1.4.03 Cartao de Credito Corporativo
    2.1.5 OUTRAS OBRIGACOES CP
      2.1.5.01 Adiantamento de Clientes
      2.1.5.02 Cheques a Compensar
      2.1.5.03 Alugueis a Pagar
      2.1.5.04 Energia/Telefone a Pagar
  2.2 PASSIVO NAO CIRCULANTE
    2.2.1 EMPRESTIMOS E FINANCIAMENTOS LP
      2.2.1.01 Emprestimos Bancarios LP
      2.2.1.02 Financiamentos LP
    2.2.2 OUTRAS OBRIGACOES LP
  2.3 PATRIMONIO LIQUIDO
    2.3.1 CAPITAL SOCIAL
      2.3.1.01 Capital Social Subscrito
      2.3.1.02 (-) Capital Social a Integralizar
    2.3.2 RESERVAS
      2.3.2.01 Reserva Legal
      2.3.2.02 Reserva de Lucros
    2.3.3 LUCROS/PREJUIZOS ACUMULADOS
      2.3.3.01 Lucros Acumulados
      2.3.3.02 (-) Prejuizos Acumulados

3 RECEITAS
  3.1 RECEITA OPERACIONAL BRUTA
    3.1.1 VENDA DE MERCADORIAS
      3.1.1.01 Venda de Armacoes
      3.1.1.02 Venda de Lentes Oftalmicas
      3.1.1.03 Venda de Lentes de Contato
      3.1.1.04 Venda de Oculos de Sol
      3.1.1.05 Venda de Acessorios
    3.1.2 PRESTACAO DE SERVICOS
      3.1.2.01 Servicos de Montagem e Ajuste
      3.1.2.02 Servicos de Adaptacao de Lentes de Contato
      3.1.2.03 Servicos de Exame Optometrico
  3.2 DEDUCOES DA RECEITA
    3.2.1.01 (-) Devolucoes de Vendas
    3.2.1.02 (-) Abatimentos
    3.2.1.03 (-) Descontos Incondicionais Concedidos
    3.2.1.04 (-) ICMS sobre Vendas
    3.2.1.05 (-) PIS sobre Faturamento
    3.2.1.06 (-) COFINS sobre Faturamento
    3.2.1.07 (-) ISS sobre Servicos
    3.2.1.08 (-) Simples Nacional sobre Faturamento
  3.3 RECEITAS FINANCEIRAS
    3.3.1.01 Juros Ativos
    3.3.1.02 Descontos Obtidos
    3.3.1.03 Rendimentos de Aplicacoes Financeiras
    3.3.1.04 Juros de Mora Recebidos
  3.4 OUTRAS RECEITAS OPERACIONAIS
    3.4.1.01 Recuperacao de Despesas
    3.4.1.02 Receita de Consignacao

4 CUSTOS E DESPESAS
  4.1 CUSTO DAS MERCADORIAS VENDIDAS (CMV)
    4.1.1.01 CMV — Armacoes
    4.1.1.02 CMV — Lentes Oftalmicas
    4.1.1.03 CMV — Lentes de Contato
    4.1.1.04 CMV — Oculos de Sol
    4.1.1.05 CMV — Acessorios
  4.2 DESPESAS COM PESSOAL
    4.2.1.01 Salarios e Ordenados
    4.2.1.02 Encargos Sociais (INSS Patronal)
    4.2.1.03 FGTS
    4.2.1.04 Vale Transporte
    4.2.1.05 Vale Alimentacao/Refeicao
    4.2.1.06 Plano de Saude
    4.2.1.07 Provisao de Ferias
    4.2.1.08 Provisao de 13o Salario
    4.2.1.09 Comissoes sobre Vendas
  4.3 DESPESAS ADMINISTRATIVAS
    4.3.1.01 Aluguel
    4.3.1.02 Condominio
    4.3.1.03 Energia Eletrica
    4.3.1.04 Agua e Esgoto
    4.3.1.05 Telefone e Internet
    4.3.1.06 Material de Escritorio
    4.3.1.07 Material de Limpeza
    4.3.1.08 Servicos Contabeis
    4.3.1.09 Seguros
    4.3.1.10 Depreciacao
    4.3.1.11 Software e Sistemas (mensalidades)
    4.3.1.12 Manutencao e Reparos
  4.4 DESPESAS COMERCIAIS (VENDAS)
    4.4.1.01 Publicidade e Marketing
    4.4.1.02 Brindes e Promocoes
    4.4.1.03 Frete sobre Vendas
    4.4.1.04 Embalagens
    4.4.1.05 Taxas de Cartao de Credito/Debito
    4.4.1.06 Comissoes de Vendas
  4.5 DESPESAS FINANCEIRAS
    4.5.1.01 Juros Passivos
    4.5.1.02 Descontos Concedidos
    4.5.1.03 Tarifas Bancarias
    4.5.1.04 IOF
    4.5.1.05 Multas e Juros de Mora (pagos)
    4.5.1.06 Taxa de Antecipacao de Recebiveis
  4.6 OUTRAS DESPESAS
    4.6.1.01 Perdas com Devedores Duvidosos
    4.6.1.02 Perdas em Estoque
    4.6.1.03 Despesas Extraordinarias

5 APURACAO DE RESULTADO
  5.1.1.01 Apuracao do Resultado do Exercicio (ARE)
```

### 7.5 Entidades para Plano de Contas

```
PlanoConta
├── Id (Guid)
├── Codigo (string 20) — "1.1.1.03.002" — hierarquico
├── Nome (string 150) — "Banco Itau"
├── Tipo (enum: Sintetica, Analitica)
├── Natureza (enum: Devedora, Credora)
├── ClasseConta (enum: Ativo, Passivo, PatrimonioLiquido, Receita, Despesa, Custo, ApuracaoResultado)
├── GrupoConta (enum: Circulante, NaoCirculante, ResultadoBruto, ResultadoOperacional, ResultadoFinanceiro, ResultadoLiquido)
├── ContaPaiId (Guid, nullable FK) — hierarquia
├── Nivel (int) — calculado automaticamente
├── PermiteLancamento (bool) — true apenas para analiticas
├── ContaBancariaId (Guid, nullable FK) — vinculo com conta bancaria (para contas 1.1.1.03.xxx)
├── CentroCustoObrigatorio (bool) — exige centro de custo nos lancamentos
├── Ativo (bool)
├── CodigoSped (string 20, nullable) — codigo referencial para SPED ECD
├── Ordem (int) — para ordenacao na DRE/Balanco
├── SaldoAtual (decimal) — atualizado por trigger/servico
└── NaturezaSaldo (enum: Devedor, Credor) — saldo atual
```

---

## 8. Centro de Custo

### 8.1 Conceito

Centro de custo e uma divisao contabil que segmenta a empresa em unidades de responsabilidade financeira, permitindo analise detalhada de receitas e despesas por area, departamento, projeto ou unidade de negocio.

### 8.2 Hierarquia Tipica para Otica

```
01 EMPRESA
  01.01 LOJA CENTRO
    01.01.01 Vendas Loja Centro
    01.01.02 Laboratorio Loja Centro
    01.01.03 Administrativo Loja Centro
  01.02 LOJA SHOPPING
    01.02.01 Vendas Loja Shopping
    01.02.02 Administrativo Loja Shopping
  01.03 ADMINISTRATIVO GERAL
    01.03.01 Financeiro
    01.03.02 RH
    01.03.03 TI
    01.03.04 Diretoria
  01.04 MARKETING
  01.05 COMPRAS / LOGISTICA
```

### 8.3 Rateio (Apportionment)

O rateio distribui custos compartilhados entre multiplos centros de custo. Tipos:

| Tipo de Rateio | Descricao | Exemplo |
|----------------|-----------|---------|
| **Percentual fixo** | % predefinido por centro de custo | Aluguel: 60% Loja Centro, 40% Loja Shopping |
| **Proporcional a receita** | Distribuido conforme faturamento | Marketing rateado pela receita de cada loja |
| **Proporcional a headcount** | Distribuido pelo numero de funcionarios | RH rateado por numero de funcionarios |
| **Proporcional a area** | Distribuido pela area ocupada (m2) | Condominio rateado pela area de cada setor |
| **Direto** | Alocacao integral a um CC | Comissao de vendedor -> CC da loja dele |

### 8.4 Entidades para Centro de Custo

```
CentroCusto
├── Id (Guid)
├── Codigo (string 20) — "01.01.01"
├── Nome (string 100) — "Vendas Loja Centro"
├── CentroCustoPaiId (Guid, nullable FK) — hierarquia
├── Nivel (int) — calculado
├── Tipo (enum: Sintetico, Analitico)
├── ResponsavelId (Guid, nullable FK -> Funcionario)
├── Ativo (bool)
├── AceitaLancamento (bool) — true para analiticos
├── OrcamentoMensal (decimal, nullable)
└── Ordem (int)

RateioModelo
├── Id (Guid)
├── Nome (string 100) — "Rateio Aluguel"
├── TipoRateio (enum: PercentualFixo, ProporcionalReceita, ProporcionalHeadcount, ProporcionalArea)
├── PlanoContaId (Guid, nullable FK) — conta contabil associada
├── Ativo (bool)
└── Itens (List<RateioModeloItem>)

RateioModeloItem
├── Id (Guid)
├── RateioModeloId (Guid FK)
├── CentroCustoId (Guid FK)
├── Percentual (decimal) — para PercentualFixo
└── Ordem (int)
```

---

## 9. DRE -- Demonstracao do Resultado do Exercicio

### 9.1 Base Legal

- **Lei 6.404/1976, Art. 187** — estrutura obrigatoria
- **CPC 26 (R1)** — Apresentacao das Demonstracoes Contabeis (equivalente IAS 1)
- **CVM** — obrigatoria para S.A. de capital aberto

### 9.2 Estrutura da DRE Brasileira

```
(+) RECEITA OPERACIONAL BRUTA
    Venda de Mercadorias
    Prestacao de Servicos

(-) DEDUCOES DA RECEITA BRUTA
    Devolucoes e Abatimentos
    Impostos sobre Vendas (ICMS, PIS, COFINS, ISS, Simples)
    Descontos Incondicionais

(=) RECEITA OPERACIONAL LIQUIDA

(-) CUSTO DAS MERCADORIAS/SERVICOS VENDIDOS (CMV/CSP)

(=) LUCRO BRUTO (Resultado Bruto)

(-) DESPESAS OPERACIONAIS
    Despesas com Vendas (Comerciais)
    Despesas Administrativas (Gerais)
    Outras Despesas Operacionais
(+) Outras Receitas Operacionais

(=) RESULTADO OPERACIONAL (EBIT)

(+) EBITDA = EBIT + Depreciacao + Amortizacao (indicador gerencial, nao e linha da DRE legal)

(+/-) RESULTADO FINANCEIRO
    (+) Receitas Financeiras
    (-) Despesas Financeiras

(=) RESULTADO ANTES DO IR E CSLL (LAIR)

(-) PROVISAO PARA IR E CSLL
    IRPJ
    CSLL

(=) RESULTADO LIQUIDO DO EXERCICIO (Lucro ou Prejuizo)
```

### 9.3 DRE Gerencial vs Contabil

| Aspecto | DRE Contabil | DRE Gerencial |
|---------|-------------|---------------|
| **Formato** | Padrao legal (CPC 26) | Livre, customizavel |
| **Destinatarios** | Fisco, auditores, investidores | Gestores internos |
| **Periodicidade** | Anual (obrigatoria) | Mensal, semanal, diaria |
| **Detalhamento** | Por conta contabil | Por centro de custo, produto, loja, vendedor |
| **Comparacoes** | Exercicio anterior | Orcado vs Realizado, mensal, YTD, acumulado |
| **Indicadores** | Margem bruta, margem liquida | EBITDA, margem de contribuicao, ponto de equilibrio |
| **Regime** | Competencia | Pode ser caixa ou competencia |

### 9.4 Comparacoes Tipicas

1. **Mensal**: Janeiro vs Fevereiro vs Marco (evolucao)
2. **Ano anterior**: Jan/2026 vs Jan/2025 (sazonalidade)
3. **Orcado vs Realizado**: Budget aprovado vs numeros reais
4. **Acumulado (YTD)**: Jan-Jun/2026 vs Jan-Jun/2025
5. **Por loja**: DRE Loja Centro vs DRE Loja Shopping
6. **Por categoria**: DRE Armacoes vs DRE Lentes vs DRE Acessorios

### 9.5 Entidades para DRE

```
DreModelo
├── Id (Guid)
├── Nome (string 100) — "DRE Gerencial Padrao"
├── Tipo (enum: Contabil, Gerencial)
├── Ativo (bool)
└── Linhas (List<DreModeloLinha>)

DreModeloLinha
├── Id (Guid)
├── DreModeloId (Guid FK)
├── Codigo (string 20) — "1", "1.1", "2"
├── Descricao (string 150) — "RECEITA OPERACIONAL BRUTA"
├── Tipo (enum: Grupo, Subtotal, Total, Indicador)
├── Operador (enum: Soma, Subtracao, Formula)
├── Formula (string 200, nullable) — "(L3 - L4)" para linhas calculadas
├── LinhaPaiId (Guid, nullable FK) — hierarquia
├── ContasVinculadas (string 500, nullable) — "3.1.1.*, 3.1.2.*" — contas do plano que compoem essa linha
├── Ordem (int)
├── Negrito (bool)
├── ExibirPercentual (bool) — % sobre receita liquida
└── Nivel (int)

DreResultado
├── Id (Guid)
├── DreModeloId (Guid FK)
├── Periodo (DateTime) — mes/ano de referencia
├── Tipo (enum: Mensal, Trimestral, Anual, Acumulado)
├── CentroCustoId (Guid, nullable FK) — se filtrado por CC
├── GeradoEm (DateTime)
└── Linhas (List<DreResultadoLinha>)

DreResultadoLinha
├── Id (Guid)
├── DreResultadoId (Guid FK)
├── DreModeloLinhaId (Guid FK)
├── ValorRealizado (decimal)
├── ValorOrcado (decimal, nullable) — se houver orcamento
├── ValorAnterior (decimal, nullable) — mesmo periodo ano anterior
├── PercentualReceita (decimal, nullable) — % sobre receita liquida (analise vertical)
├── VariacaoOrcado (decimal, nullable) — (realizado - orcado) / orcado * 100
└── VariacaoAnterior (decimal, nullable) — (realizado - anterior) / anterior * 100
```

---

## 10. Tesouraria

### 10.1 Conceito

A tesouraria gerencia os recursos financeiros da empresa no dia a dia: contas bancarias, movimentacoes, cheques, cartoes, e posicao de caixa em tempo real.

### 10.2 Funcionalidades Principais

#### Gestao de Contas Bancarias
- Cadastro de multiplas contas em multiplos bancos
- Saldo atualizado por conta
- Classificacao: Corrente, Poupanca, Investimento, Caixa Fisico
- Dados bancarios completos (agencia, conta, digito, convenio)

#### Transferencias entre Contas
- Debito na conta de origem, credito na conta de destino
- Geracao automatica de lancamento contabil (D: Banco destino / C: Banco origem)
- Historico de transferencias

#### Gestao de Cheques

**Cheques Emitidos**:
- Talonario (talao de cheques) com faixa numerica
- Status: Emitido, Compensado, Cancelado, Devolvido, Sustado
- Vinculo com titulo a pagar (baixa)
- Data de emissao vs data de apresentacao (pre-datado)

**Cheques de Terceiros (Recebidos)**:
- Cadastro: numero, banco, agencia, conta, valor, emitente
- Status: Recebido, EmCustodia, Depositado, Compensado, Devolvido, Repassado
- Custodia bancaria (guarda no banco)
- Reapresentacao apos devolucao
- Repasse a fornecedor (endosso)

#### Recebíveis de Cartao

- Registro por operadora/adquirente (Cielo, Rede, Stone, PagSeguro, etc.)
- Bandeira (Visa, Mastercard, Elo, Amex, Hipercard)
- Modalidade: Credito a vista, Credito parcelado, Debito
- Previsao de recebimento (D+1 debito, D+30 credito, D+N parcelas)
- Taxas por operadora/bandeira/modalidade (MDR — Merchant Discount Rate)
- Antecipacao de recebiveis: valor bruto, taxa, valor liquido antecipado

#### Tarifas Bancarias
- Registro automatico via OFX/CNAB
- Classificacao por tipo (DOC/TED, manutencao de conta, emissao de boleto, etc.)
- Vinculo com conta contabil de despesa financeira

### 10.3 Entidades para Tesouraria

```
Banco (dominio publico)
├── Id (Guid)
├── Codigo (int) — codigo FEBRABAN (001=BB, 033=Santander, 104=Caixa, 237=Bradesco, 341=Itau, etc.)
├── Nome (string 100)
├── Padrao (bool)
└── Ativo (bool)

TalonarioCheque
├── Id (Guid)
├── ContaBancariaId (Guid FK)
├── NumeroInicio (int) — primeira folha
├── NumeroFim (int) — ultima folha
├── QuantidadeFolhas (int)
├── FolhasUtilizadas (int)
├── DataRecebimento (DateTime)
├── Status (enum: EmUso, Encerrado, Cancelado)
└── Observacao (string 200, nullable)

ChequeEmitido
├── Id (Guid)
├── TalonarioId (Guid FK)
├── ContaBancariaId (Guid FK)
├── NumeroCheque (int)
├── Valor (decimal)
├── NominalA (string 200) — favorecido
├── DataEmissao (DateTime)
├── DataBomPara (DateTime, nullable) — data de apresentacao (pre-datado)
├── DataCompensacao (DateTime, nullable)
├── Status (enum: Emitido, Compensado, Cancelado, Devolvido, Sustado)
├── TituloPagarId (Guid, nullable FK) — vinculo com titulo
├── BaixaId (Guid, nullable FK)
├── MotivoSustacao (string 200, nullable)
└── Observacao (string 500, nullable)

ChequeRecebido
├── Id (Guid)
├── NumeroCheque (string 20)
├── BancoId (Guid FK -> Banco)
├── Agencia (string 10)
├── Conta (string 15)
├── Valor (decimal)
├── Emitente (string 200)
├── CpfCnpjEmitente (string 14)
├── DataRecebimento (DateTime)
├── DataBomPara (DateTime, nullable)
├── DataDeposito (DateTime, nullable)
├── DataCompensacao (DateTime, nullable)
├── DataDevolucao (DateTime, nullable)
├── ContaDestinoId (Guid, nullable FK) — conta onde foi depositado
├── Status (enum: Recebido, EmCustodia, Depositado, Compensado, Devolvido, Repassado)
├── MotivoDevolucao (string 200, nullable) — "Falta de fundos", "Conta encerrada"
├── TituloReceberId (Guid, nullable FK)
├── BaixaId (Guid, nullable FK)
├── RepassadoParaId (Guid, nullable FK) — fornecedor
└── Observacao (string 500, nullable)

OperadoraCartao (dominio publico)
├── Id (Guid)
├── Codigo (int)
├── Nome (string 100) — "Cielo", "Rede", "Stone"
├── Padrao (bool)
└── Ativo (bool)

BandeiraCartao (dominio publico)
├── Id (Guid)
├── Codigo (int)
├── Nome (string 100) — "Visa", "Mastercard", "Elo"
├── Padrao (bool)
└── Ativo (bool)

TaxaCartao
├── Id (Guid)
├── OperadoraCartaoId (Guid FK)
├── BandeiraCartaoId (Guid FK)
├── Modalidade (enum: CreditoAVista, CreditoParcelado, Debito, Pix)
├── ParcelaDe (int) — 1
├── ParcelaAte (int) — 12
├── TaxaPercentual (decimal) — 2.99%
├── PrazoDias (int) — D+30 para credito 1x, D+1 para debito
├── VigenciaInicio (DateTime)
├── VigenciaFim (DateTime, nullable)
└── Ativo (bool)

RecebiveisCartao
├── Id (Guid)
├── VendaId (Guid, nullable FK)
├── TituloReceberId (Guid FK)
├── OperadoraCartaoId (Guid FK)
├── BandeiraCartaoId (Guid FK)
├── Modalidade (enum: CreditoAVista, CreditoParcelado, Debito, Pix)
├── ValorBruto (decimal)
├── TaxaMdr (decimal) — percentual aplicado
├── ValorTaxa (decimal) — valor da taxa
├── ValorLiquido (decimal) — bruto - taxa
├── NumeroParcelas (int)
├── ParcelaAtual (int) — para parcelado
├── DataVenda (DateTime)
├── DataPrevisaoRecebimento (DateTime)
├── DataRecebimentoEfetivo (DateTime, nullable)
├── Antecipado (bool)
├── DataAntecipacao (DateTime, nullable)
├── TaxaAntecipacao (decimal, nullable) — taxa da antecipacao
├── ValorAntecipadoLiquido (decimal, nullable)
├── Nsu (string 20) — Numero Sequencial Unico
├── CodigoAutorizacao (string 20)
├── ContaBancariaId (Guid FK) — conta onde sera creditado
├── Status (enum: Pendente, AguardandoDeposito, Recebido, Antecipado, Cancelado, Contestado)
└── Observacao (string 200, nullable)

TransferenciaBancaria
├── Id (Guid)
├── ContaOrigemId (Guid FK)
├── ContaDestinoId (Guid FK)
├── Valor (decimal)
├── Data (DateTime)
├── TipoTransferencia (enum: TED, DOC, Pix, TransferenciaInterna)
├── NumeroDocumento (string 50, nullable)
├── Descricao (string 200)
├── TarifaBancaria (decimal)
├── LancamentoContabilId (Guid, nullable FK)
└── Observacao (string 200, nullable)
```

---

## 11. Lancamentos Contabeis

### 11.1 Partida Dobrada (Double-Entry Bookkeeping)

Principio fundamental: todo lancamento afeta no minimo 2 contas — um debito e um credito de igual valor. `Total Debitos = Total Creditos` (sempre).

### 11.2 Tipos de Lancamento

| Tipo | Descricao | Exemplo |
|------|-----------|---------|
| **Automatico** | Gerado pelo sistema a partir de transacoes | Venda gera D: Clientes / C: Receita de Vendas |
| **Manual** | Criado pelo contador/financeiro | Provisoes, ajustes, reclassificacoes |
| **Reversao (Estorno)** | Inverte lancamento anterior | Estorno de lancamento errado |
| **Encerramento** | Zera contas de resultado no fim do exercicio | D: Receitas / C: ARE; D: ARE / C: Despesas |
| **Abertura** | Carrega saldos iniciais no novo exercicio | D/C contas patrimoniais com saldos iniciais |

### 11.3 Lancamentos Automaticos Tipicos

```
VENDA A VISTA:
  D 1.1.1.01 Caixa                    R$ 500,00
  C 3.1.1.01 Receita de Vendas        R$ 500,00
  D 4.1.1.01 CMV                      R$ 200,00
  C 1.1.3.01 Estoque de Mercadorias   R$ 200,00

VENDA NO CARTAO DE CREDITO:
  D 1.1.2.02 Cartoes a Receber        R$ 485,00 (liquido)
  D 4.5.1.05 Taxa de Cartao           R$  15,00 (taxa)
  C 3.1.1.01 Receita de Vendas        R$ 500,00

PAGAMENTO A FORNECEDOR:
  D 2.1.1.01 Fornecedores             R$ 1.000,00
  C 1.1.1.03 Banco c/ Movimento       R$ 1.000,00

RECEBIMENTO DE CLIENTE:
  D 1.1.1.03 Banco c/ Movimento       R$ 500,00
  C 1.1.2.01 Clientes a Receber       R$ 500,00

RECEBIMENTO COM JUROS:
  D 1.1.1.03 Banco c/ Movimento       R$ 520,00
  C 1.1.2.01 Clientes a Receber       R$ 500,00
  C 3.3.1.04 Juros de Mora Recebidos  R$  20,00

PAGAMENTO COM DESCONTO:
  D 2.1.1.01 Fornecedores             R$ 1.000,00
  C 1.1.1.03 Banco c/ Movimento       R$   950,00
  C 3.3.1.02 Descontos Obtidos        R$    50,00

PAGAMENTO DE SALARIOS:
  D 4.2.1.01 Salarios e Ordenados     R$ 5.000,00
  C 1.1.1.03 Banco c/ Movimento       R$ 5.000,00

FOLHA DE PAGAMENTO (PROVISAO):
  D 4.2.1.01 Salarios e Ordenados     R$ 5.000,00
  D 4.2.1.02 INSS Patronal            R$ 1.400,00
  D 4.2.1.03 FGTS                     R$   400,00
  C 2.1.2.01 Salarios a Pagar         R$ 5.000,00
  C 2.1.2.02 INSS a Recolher          R$ 1.400,00
  C 2.1.2.03 FGTS a Recolher          R$   400,00

ENCERRAMENTO DO EXERCICIO:
  D 3.x.x.xx Todas as contas de Receita   (saldo total)
  C 5.1.1.01 ARE                           (saldo total receitas)
  D 5.1.1.01 ARE                           (saldo total desp/custos)
  C 4.x.x.xx Todas as contas de Despesa   (saldo total)
  -- Se ARE credor (lucro):
  D 5.1.1.01 ARE                           (lucro)
  C 2.3.3.01 Lucros Acumulados            (lucro)
```

### 11.4 Entidades para Lancamentos Contabeis

```
LancamentoContabil
├── Id (Guid)
├── Numero (int, auto-incremento) — sequencial unico no exercicio
├── DataLancamento (DateTime) — data contabil (competencia)
├── DataRegistro (DateTime) — data/hora do registro no sistema
├── Tipo (enum: Automatico, Manual, Reversao, Encerramento, Abertura)
├── OrigemTipo (string, nullable) — "Venda", "Compra", "Pagamento", "Recebimento", "Transferencia"
├── OrigemId (Guid, nullable) — FK polimorfica para o documento original
├── Historico (string 500) — descricao do lancamento
├── TotalDebito (decimal)
├── TotalCredito (decimal)
├── Status (enum: Rascunho, Confirmado, Estornado)
├── LancamentoEstornoId (Guid, nullable FK) — referencia ao lancamento estornado
├── ExercicioContabil (int) — ano fiscal
├── PeriodoContabil (int) — mes fiscal (1-12, 13 para encerramento)
├── Lote (string 20, nullable) — agrupamento de lancamentos
└── Partidas (List<PartidaLancamento>)

PartidaLancamento
├── Id (Guid)
├── LancamentoContabilId (Guid FK)
├── PlanoContaId (Guid FK)
├── CentroCustoId (Guid, nullable FK)
├── Tipo (enum: Debito, Credito)
├── Valor (decimal)
├── Historico (string 200, nullable) — complemento especifico desta partida
├── NumeroDocumento (string 50, nullable) — NF, cheque, etc.
└── Ordem (int) — sequencial dentro do lancamento
```

---

## 12. Integracao Entre Modulos

### 12.1 Vendas → Financeiro (Contas a Receber)

| Evento no Módulo Vendas | Ação no Financeiro |
|-------------------------|-------------------|
| **FaturamentoVenda (Autorizar)** | Gera parcelas em ContaReceber usando CondicaoPagamentoId |
| **DevolucaoVenda (Creditar)** | Cria nota de crédito ou estorno em ContaReceber |
| **ComissaoVenda (Aprovar)** | Gera parcelas em ContaPagar (vendedor como credor) |
| **ComissaoVenda (Pagar)** | Registra BaixaFinanceira + MovimentoBancario (Saída) |
| **Cancelamento NF-e** | Cancela todos os títulos ContaReceber vinculados |

**Campos de integração em FaturamentoVenda (já existentes):**
- `CondicaoPagamentoId` — define regras de parcelamento
- `FormaPagamentoId` — método de pagamento
- `DataVencimento` — base para cálculo das parcelas
- `ValorTotal` — base para geração dos títulos
- `ValorICMS, ValorIPI, ValorPIS, ValorCOFINS` — alimentam apuração fiscal

### 12.2 Compras → Financeiro (Contas a Pagar)

| Evento no Módulo Compras | Ação no Financeiro |
|--------------------------|-------------------|
| **RecebimentoMercadoria (Confirmar)** | Gera parcelas em ContaPagar usando CondicaoPagamento da OC |
| **DevolucaoCompra (Aprovar)** | Cria nota de crédito em ContaPagar |
| **ContratoCompra (Ativo)** | Pode gerar ContaPagar recorrente |
| **Cancelamento de OC** | Cancela títulos ContaPagar vinculados |

**Campos de integração em OrdemCompra (já existentes):**
- `CondicaoPagamentoId` — define parcelamento
- `ValorTotal` — base para os títulos
- `Moeda + TaxaCambio` — conversão cambial (compras internacionais)

### 12.3 Estoque → Financeiro

| Evento no Módulo Estoque | Ação no Financeiro |
|--------------------------|-------------------|
| **MovimentacaoEstoque (Entrada via Compra)** | ContaPagar já gerada pelo Recebimento |
| **MovimentacaoEstoque (Saída via Venda)** | ContaReceber já gerada pelo Faturamento |
| **Inventário (Divergências)** | Pode gerar lançamento contábil de ajuste |
| **EstoqueSaldo** | Alimenta cálculo de CMV e valoração do DRE |

### 12.4 Fluxo Completo: Order-to-Cash

```
PedidoVenda → FaturamentoVenda (Autorizar)
    │
    ├── Gera ContaReceber (1 a N parcelas)
    │   └── CondicaoPagamento define: qtd parcelas, dias, percentuais
    │
    ├── Gera MovimentacaoEstoque (Saída)
    │   └── Decrementa EstoqueSaldo
    │
    └── Cliente Paga (PIX/Boleto/Cartão/Caixa)
        │
        ├── Registra BaixaFinanceira (parcial ou total)
        ├── Atualiza ContaReceber.Saldo e Status
        └── Gera MovimentoBancario (Crédito na conta)
```

### 12.5 Fluxo Completo: Procure-to-Pay

```
OrdemCompra → RecebimentoMercadoria (Confirmar)
    │
    ├── Gera ContaPagar (1 a N parcelas)
    │   └── CondicaoPagamento define: qtd parcelas, dias, percentuais
    │
    ├── Gera MovimentacaoEstoque (Entrada)
    │   └── Incrementa EstoqueSaldo
    │
    └── Empresa Paga (Boleto/Transferência/PIX)
        │
        ├── Registra BaixaFinanceira
        ├── Atualiza ContaPagar.Saldo e Status
        └── Gera MovimentoBancario (Débito na conta)
```

---

## 13. Dashboard Financeiro -- KPIs

### 13.1 KPIs Principais (Linha 1)

| KPI | Fórmula | Visualização |
|-----|---------|-------------|
| **Saldo de Caixa** | `SUM(ContaBancaria.SaldoAtual)` | Card com trend ↑↓ |
| **Contas a Receber** | `SUM(ContaReceber.Saldo) WHERE Status IN ('Aberta','Vencida')` | Card + mini donut (a vencer vs vencido) |
| **Contas a Pagar** | `SUM(ContaPagar.Saldo) WHERE Status IN ('Aberta','Vencida')` | Card + mini donut |
| **Inadimplência %** | `(Receber Vencido / Total Receber) × 100` | Card + gauge (verde <5%, amarelo 5-15%, vermelho >15%) |

### 13.2 KPIs Secundários (Linha 2)

| KPI | Fórmula | Visualização |
|-----|---------|-------------|
| **Capital de Giro** | `Ativos Circulantes - Passivos Circulantes` | Card com R$ + trend |
| **Liquidez Corrente** | `Ativos Circulantes / Passivos Circulantes` | Card (verde >1.5, amarelo 1-1.5, vermelho <1) |
| **PMR (Dias a Receber)** | `(ContasAReceber / ReceitaBruta) × DiasPeriodo` | Card + comparação MoM |
| **Ciclo Financeiro** | `PMR + PME - PMP` | Card (dias) |

### 13.3 KPIs Avançados (Linha 3)

| KPI | Fórmula |
|-----|---------|
| **EBITDA** | `ReceitaLíquida - CMV - DespesasOperacionais + Depreciação` |
| **Margem Líquida %** | `(LucroLíquido / ReceitaLíquida) × 100` |
| **PMP (Dias a Pagar)** | `(ContasAPagar / ComprasBrutas) × DiasPeriodo` |
| **Cash Runway** | `SaldoCaixa / BurnRateMensal` (meses) |

### 13.4 Gráficos

| Gráfico | Tipo | Descrição |
|---------|------|-----------|
| **Fluxo de Caixa** | LineChart (2 séries) | Realizado (sólido) vs Projetado (tracejado), 12 meses |
| **Receitas vs Despesas** | BarChart agrupado | Barras verdes (receitas) e vermelhas (despesas), 12 meses |
| **Composição de Despesas** | PieChart/Donut | Top 8 categorias + "Outros" |
| **Aging Receber** | StackedBar horizontal | Faixas de 0-30, 31-60, 61-90, 91-120, 121+ dias |
| **Evolução Saldo Bancário** | AreaChart | Uma série por conta bancária |
| **Top 10 Pagamentos** | HorizontalBar | Maiores pagamentos do período |
| **Top 10 Recebimentos** | HorizontalBar | Maiores recebimentos do período |

### 13.5 Alertas Operacionais

| Alerta | Condição | Nível |
|--------|----------|-------|
| Títulos vencidos | ContaReceber/Pagar com DataVencimento < hoje e Status = Aberta | Warning/Critical |
| Saldo bancário baixo | ContaBancaria.SaldoAtual < SaldoMinimo configurado | Critical |
| Fluxo projetado negativo | Projeção < 0 nos próximos 7/15/30 dias | Warning |
| Limite crédito atingido | SUM(títulos abertos cliente) >= LimiteCredito × 90% | Warning |
| Cheques a compensar | ChequeRecebido com DataBomPara <= hoje e Status = EmCustódia | Info |

---

## 14. Relatorios Padrao

### 14.1 Relatórios Operacionais

| Relatório | Descrição | Filtros |
|-----------|-----------|---------|
| **Aging Contas a Receber** | Títulos por faixa de vencimento/atraso | Cliente, período, faixa |
| **Aging Contas a Pagar** | Títulos por faixa de vencimento/atraso | Fornecedor, período, faixa |
| **Títulos a Vencer** | Próximos vencimentos (7/15/30 dias) | Tipo (pagar/receber), período |
| **Inadimplentes** | Clientes com títulos vencidos | Faixa atraso, valor mínimo |
| **Extrato Conta Bancária** | Movimentações por conta | Conta, período |
| **Conciliação Bancária** | Status matching ERP vs banco | Conta, período |

### 14.2 Relatórios Gerenciais

| Relatório | Descrição |
|-----------|-----------|
| **Fluxo de Caixa Realizado** | Entradas vs saídas por período (diário/semanal/mensal) |
| **Fluxo de Caixa Projetado** | Projeção baseada em títulos abertos |
| **DRE Gerencial** | Mensal/trimestral/anual com orçado vs realizado |
| **Comparativo Receitas vs Despesas** | 12 meses lado a lado |
| **Rentabilidade por Centro de Custo** | Receitas - Custos por departamento/filial |
| **Comissões a Pagar** | Por vendedor, período, percentual, status |
| **Retenções Fiscais** | ISS, IRRF, PIS/COFINS/CSLL retidos por período |

### 14.3 Relatórios Contábeis

| Relatório | Descrição |
|-----------|-----------|
| **Balancete** | Saldos por conta contábil (débitos, créditos, saldo) |
| **Razão Contábil** | Movimentações analíticas por conta |
| **Diário Contábil** | Todos os lançamentos em ordem cronológica |
| **Balanço Patrimonial** | Ativo vs Passivo + PL |
| **DRE Contábil** | Formato legal CPC 26 |

---

## 15. Requisitos Fiscais Brasileiros

> Detalhamento completo no documento complementar: [`PESQUISA-FISCAL-TRIBUTARIA.md`](./PESQUISA-FISCAL-TRIBUTARIA.md)

### 15.1 Resumo dos Requisitos

| Obrigação | Frequência | Impacto no Financeiro |
|-----------|-----------|----------------------|
| **ECD (SPED Contábil)** | Anual (jun) | Exportar plano de contas + lançamentos contábeis |
| **EFD ICMS/IPI** | Mensal | Valores de ICMS/IPI devem casar com NF-e |
| **EFD-Contribuições** | Mensal | PIS/COFINS créditos e débitos |
| **ECF** | Anual (jul) | IRPJ/CSLL, depende da ECD |
| **EFD-Reinf** | Mensal | Retenções na fonte (substituiu DIRF) |
| **DCTFWeb + MIT** | Mensal | Todos os tributos federais |

### 15.2 Retenções Automáticas no Contas a Pagar

| Imposto | Alíquota | Quando Reter |
|---------|----------|-------------|
| **ISS** | 2-5% | Serviços, quando tomador retém |
| **IRRF** | 1-1.5% (PJ), tabela progressiva (PF) | Serviços, aluguel |
| **PIS/COFINS/CSLL** | 4.65% combinado | Serviços PJ > R$ 215,05 (exceto Simples) |
| **INSS** | 11% (PF), 3.5% (Simples Anexo IV) | Serviços de mão de obra |

### 15.3 Reforma Tributária 2026-2033

- **2026:** CBS 0,9% + IBS 0,1% em teste. Campos novos em NF-e/NFC-e
- **2027:** Split Payment automático — imposto retido na hora do pagamento (cartão/PIX)
- **2033:** Extinção completa ICMS/ISS

**Impacto no ERP:** O módulo financeiro deve preparar campos para CBS/IBS e adaptar fluxo de caixa para Split Payment (empresa recebe valor líquido).

---

## 16. Especificidades do Setor Optico

### 16.1 Ticket Médio e Parcelamento

- Óculos completos: R$ 400 a R$ 2.000+
- Lentes multifocais premium: R$ 1.500 a R$ 4.000
- Parcelamento em até 10-12x é padrão no setor
- Crediário próprio é diferencial competitivo

### 16.2 Formas de Pagamento Comuns em Óticas

| Forma | Frequência | Observação |
|-------|-----------|-----------|
| Cartão crédito parcelado | ~40% | Mais comum, 3-10x sem juros |
| PIX | ~25% | Crescimento acelerado |
| Dinheiro | ~10% | Em declínio |
| Crediário próprio | ~15% | Diferencial para óticas populares |
| Convênio empresa | ~5% | Desconto em folha |
| Boleto | ~5% | Clientes PJ |

### 16.3 Convênio Empresarial

Modelo específico: empresas firmam convênios com óticas para funcionários comprarem com desconto em folha.

```
Convênio: Empresa ↔ Ótica
├── Desconto: 4-5% sobre preço tabela
├── Limite por funcionário: R$ 2.000-5.000
├── Parcelas: até 10x sem juros (desconto em folha)
├── Fluxo mensal: ótica envia planilha → empresa desconta → repassa
```

### 16.4 Sazonalidade Financeira do Setor Óptico

| Período | Demanda | Motivo |
|---------|---------|--------|
| Jan-Fev | Alta | Volta às aulas, exames oftalmológicos |
| Mar-Abr | Média-baixa | Pós-volta às aulas |
| Mai | Alta | Dia das Mães |
| Jun-Jul | Média | Inverno, menos demanda |
| Ago | Alta | Dia dos Pais |
| Set-Out | Média | Transição |
| Nov-Dez | Muito alta | Black Friday, Natal, 13º salário |

### 16.5 CNAE e Enquadramento

- **CNAE 4774-1/00:** Comércio varejista de artigos de óptica
- Permite Simples Nacional e MEI
- Anexo I (Comércio): alíquota 4% a 19%
- RAT (Risco Acidente Trabalho): 2,00%

### 16.6 NCMs Relevantes

| NCM | Produto | ICMS-ST |
|-----|---------|---------|
| 9001.40 | Lentes oftálmicas de vidro | Verificar protocolo estadual |
| 9001.50 | Lentes oftálmicas de plástico | Verificar protocolo estadual |
| 9003.11 | Armações de plástico | Verificar protocolo estadual |
| 9003.19 | Armações de outros materiais | Verificar protocolo estadual |
| 9004.10 | Óculos de sol | Verificar protocolo estadual |

---

## 17. Comparativo com ERPs de Referencia

> *(Renumerado de §8)*

### 17.1 TOTVS Protheus vs Omie vs SAP Business One

### 17.2 TOTVS Protheus

**Modulo SIGAFIN (Financeiro) + SIGACTB (Contabilidade)**

| Aspecto | Detalhes |
|---------|----------|
| **Tabelas financeiras** | SE1 (Contas a Receber), SE2 (Contas a Pagar), SE5/FK5 (Movimentacao Bancaria), SA6 (Bancos), SE8 (Saldos Bancarios) |
| **Tabelas contabeis** | CT1 (Plano de Contas), CT2 (Lancamentos Contabeis), CT3 (Saldo Centro de Custo), CTD (Centro de Custo) |
| **Conciliacao bancaria** | Importacao OFX e CNAB, matching por data/documento/valor, reconciliacao manual |
| **Fluxo de caixa** | Projetado (baseado em SE1/SE2) e realizado (baseado em SE5), visao diaria/semanal/mensal |
| **DRE** | Configuravel por layout de plano de contas, comparativo orcado vs realizado, mensal e acumulado |
| **Tesouraria** | Controle de cheques (emitidos, custodia, compensacao), borderaux, transferencias |
| **Porte** | Grande, complexo, altamente customizavel, foco em medio/grande porte |
| **Pontos fortes** | Abrangencia total, parametrizacao extensiva, atende qualquer cenario brasileiro |
| **Pontos fracos** | Curva de aprendizado alta, interface desktop legada, custo elevado |

### 17.3 Omie

| Aspecto | Detalhes |
|---------|----------|
| **Conciliacao bancaria** | Automatica para bancos integrados (Itau, Bradesco, Santander, Caixa) via API; manual via OFX para outros |
| **Plano de contas** | Plano padrao pre-configurado, editavel, vinculado a categorias financeiras |
| **Fluxo de caixa** | Projetado e realizado, dashboard visual, integrado com contas a pagar/receber |
| **DRE** | DRE gerencial automatico a partir das categorias, comparativo periodos |
| **Centro de custo** | Suporte a departamentos com rateio, vinculacao com plano de contas |
| **Integracoes bancarias** | CNAB cobranca e pagamento, extrato via API, boleto automatico via Omie.Cash |
| **Porte** | PMEs, interface moderna web/cloud |
| **Pontos fortes** | UX excelente, setup rapido, integracao bancaria nativa, automacao de boletos |
| **Pontos fracos** | Menor flexibilidade contabil que Protheus, sem cheques detalhado, sem ECD nativo |

### 17.4 SAP Business One

| Aspecto | Detalhes |
|---------|----------|
| **Chart of Accounts** | Hierarquico ate 10 niveis, 8 categorias nivel 1 (Assets, Liabilities, Equity, Revenues, CoS, Expenses, Financing, Other), contas sinteticas (titulos) e analiticas (ativas para posting) |
| **G/L Account Determination** | Contas padrao por processo (Sales, Purchasing, Inventory) — automatiza lancamentos |
| **Journal Entries** | Automaticos (de Sales/Purchasing/Inventory) e manuais, numeracao sequencial |
| **Bank Statement** | Importacao e reconciliacao com matching rules configuráveis |
| **Cash Flow** | Dashboard de fluxo de caixa com previsoes baseadas em A/R e A/P |
| **Cost Centers** | Dimensoes de distribuicao (Distribution Rules), ate 5 dimensoes, rateio proporcional |
| **Localizacao Brasil** | FinancialOne (add-on) — boletos, CNAB 240/400, DRE, SPED |
| **Porte** | Medio porte, processo robusto, custo moderado-alto |
| **Pontos fortes** | Estrutura contabil solida, Journal Entry automaticos bem definidos, integracao global |
| **Pontos fracos** | Localizacao brasileira depende de add-ons, complexidade de implementacao |

### 17.5 Resumo Comparativo

| Feature | TOTVS Protheus | Omie | SAP B1 |
|---------|---------------|------|--------|
| Conciliacao OFX | Sim | Sim (auto) | Sim (com add-on) |
| CNAB 240/400 | Sim (nativo) | Sim (cobranca/pgto) | Sim (add-on) |
| Plano de Contas | CT1 (flexivel) | Pre-config + edit | Hierarquico 10 niveis |
| Centro de Custo | CTD (multinivel) | Departamentos | Dimensoes (ate 5) |
| DRE | Layout config. | Gerencial auto | P&L Report |
| Fluxo de Caixa | SE1+SE2+SE5 | Dashboard auto | A/R + A/P forecast |
| Cheques | Controle completo | Basico | Basico + add-on |
| Cartao Recebiveis | Sim | Sim | Add-on |
| Lancamento Contabil | CT2 (auto+manual) | Integrado | Journal Entry |
| Boletos | Sim (nativo) | Sim (Omie.Cash) | Add-on |
| Porte alvo | Medio/Grande | PME | Medio |
| UX | Desktop legado | Web moderno | Desktop/Web |

---

## 18. Modelo de Entidades Proposto

### 18.1 Contas a Pagar / Contas a Receber

```
NaturezaFinanceira (dominio publico)
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── Nome (string 100) — "Venda de Mercadorias", "Pagamento Fornecedores", "Tarifa Bancaria"
├── Tipo (enum: Receita, Despesa)
├── PlanoContaId (Guid, nullable FK) — conta contabil padrao
├── CategoriaFluxoCaixaId (Guid, nullable FK)
├── Padrao (bool)
└── Ativo (bool)

FormaPagamento (dominio publico)
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── Nome (string 100) — "Dinheiro", "Cartao Credito", "Cartao Debito", "Boleto", "Cheque", "Pix", "Transferencia"
├── Tipo (enum: Dinheiro, CartaoCredito, CartaoDebito, Boleto, Cheque, Pix, Transferencia, Convenio, Outro)
├── ContaBancariaId (Guid, nullable FK) — conta padrao para essa forma
├── GeraParcela (bool) — cartao parcelado = true, dinheiro = false
├── MaxParcelas (int) — maximo de parcelas permitidas
├── Padrao (bool)
└── Ativo (bool)

TituloPagar
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── FornecedorId (Guid FK)
├── NumeroDocumento (string 50) — numero NF, duplicata, etc.
├── TipoDocumento (enum: NotaFiscal, Duplicata, Boleto, Fatura, Recibo, ContratoAluguel, Outro)
├── DataEmissao (DateTime)
├── DataEntrada (DateTime)
├── ValorOriginal (decimal)
├── ValorAbatimento (decimal)
├── ValorDesconto (decimal)
├── ValorJuros (decimal)
├── ValorMulta (decimal)
├── ValorPago (decimal)
├── ValorSaldo (decimal) — original - abatimento - pago
├── NaturezaFinanceiraId (Guid FK)
├── CentroCustoId (Guid, nullable FK)
├── PlanoContaId (Guid, nullable FK) — conta contabil especifica (override da natureza)
├── ContaBancariaId (Guid, nullable FK) — conta para pagamento
├── FormaPagamentoId (Guid FK)
├── OrdemCompraId (Guid, nullable FK) — vinculo com compras
├── RecebimentoMercadoriaId (Guid, nullable FK) — vinculo com NF entrada
├── Observacao (string 500, nullable)
├── CodigoBarras (string 48, nullable) — codigo de barras do boleto
├── LinhaDigitavel (string 54, nullable)
├── Status (enum: Aberto, PagoParcial, Pago, Cancelado, Renegociado)
├── NumeroParcelas (int)
├── ChavePix (string 100, nullable)
└── Parcelas (List<ParcelaPagar>)

ParcelaPagar
├── Id (Guid)
├── TituloPagarId (Guid FK)
├── NumeroParcela (int) — 1, 2, 3...
├── DataVencimento (DateTime)
├── ValorParcela (decimal)
├── ValorDesconto (decimal)
├── ValorJuros (decimal)
├── ValorMulta (decimal)
├── ValorPago (decimal)
├── ValorSaldo (decimal)
├── DataPagamento (DateTime, nullable)
├── ContaBancariaId (Guid, nullable FK) — conta utilizada para pagamento
├── FormaPagamentoId (Guid FK)
├── Status (enum: Aberto, Vencido, PagoParcial, Pago, Cancelado, Renegociado)
├── BaixaId (Guid, nullable FK)
├── ChequeEmitidoId (Guid, nullable FK)
├── NumeroDocumentoBaixa (string 50, nullable)
└── Observacao (string 200, nullable)

TituloReceber
├── Id (Guid)
├── Codigo (int, auto-incremento)
├── ClienteId (Guid FK)
├── NumeroDocumento (string 50)
├── TipoDocumento (enum: NotaFiscal, Duplicata, Boleto, Fatura, Recibo, Convenio, Outro)
├── DataEmissao (DateTime)
├── ValorOriginal (decimal)
├── ValorAbatimento (decimal)
├── ValorDesconto (decimal)
├── ValorJuros (decimal)
├── ValorMulta (decimal)
├── ValorRecebido (decimal)
├── ValorSaldo (decimal)
├── NaturezaFinanceiraId (Guid FK)
├── CentroCustoId (Guid, nullable FK)
├── PlanoContaId (Guid, nullable FK)
├── ContaBancariaId (Guid, nullable FK) — conta para recebimento
├── FormaPagamentoId (Guid FK)
├── VendaId (Guid, nullable FK) — vinculo com vendas
├── NossoNumero (string 20, nullable) — para boletos
├── LinhaDigitavel (string 54, nullable) — para boletos
├── CodigoBarras (string 48, nullable)
├── Observacao (string 500, nullable)
├── Status (enum: Aberto, RecebidoParcial, Recebido, Cancelado, Renegociado, EmProtesto, Protestado)
├── DataProtesto (DateTime, nullable)
├── NumeroParcelas (int)
└── Parcelas (List<ParcelaReceber>)

ParcelaReceber
├── Id (Guid)
├── TituloReceberId (Guid FK)
├── NumeroParcela (int)
├── DataVencimento (DateTime)
├── ValorParcela (decimal)
├── ValorDesconto (decimal)
├── ValorJuros (decimal)
├── ValorMulta (decimal)
├── ValorRecebido (decimal)
├── ValorSaldo (decimal)
├── DataRecebimento (DateTime, nullable)
├── ContaBancariaId (Guid, nullable FK)
├── FormaPagamentoId (Guid FK)
├── Status (enum: Aberto, Vencido, RecebidoParcial, Recebido, Cancelado, Renegociado)
├── BaixaId (Guid, nullable FK)
├── ChequeRecebidoId (Guid, nullable FK)
├── RecebiveisCartaoId (Guid, nullable FK)
├── NumeroDocumentoBaixa (string 50, nullable)
└── Observacao (string 200, nullable)

BaixaFinanceira
├── Id (Guid)
├── Numero (int, auto-incremento)
├── Data (DateTime)
├── Tipo (enum: Pagamento, Recebimento)
├── TituloTipo (string) — "TituloPagar" ou "TituloReceber"
├── TituloId (Guid) — FK polimorfica
├── ParcelaId (Guid) — FK
├── ValorBaixa (decimal)
├── ValorDesconto (decimal)
├── ValorJuros (decimal)
├── ValorMulta (decimal)
├── ValorTotal (decimal) — baixa + juros + multa - desconto
├── ContaBancariaId (Guid FK)
├── FormaPagamentoId (Guid FK)
├── NumeroDocumento (string 50, nullable)
├── LancamentoContabilId (Guid, nullable FK) — lancamento gerado
├── TransacaoBancariaId (Guid, nullable FK) — vinculo com extrato
├── Observacao (string 200, nullable)
└── Status (enum: Efetivada, Estornada)

MovimentoBancario
├── Id (Guid)
├── ContaBancariaId (Guid FK)
├── Data (DateTime)
├── Tipo (enum: Credito, Debito)
├── Valor (decimal)
├── SaldoApos (decimal) — saldo da conta apos o movimento
├── Descricao (string 200)
├── OrigemTipo (string) — "Baixa", "Transferencia", "TarifaBancaria", "AntecipacaoCartao", "Manual"
├── OrigemId (Guid, nullable)
├── NumeroDocumento (string 50, nullable)
├── LancamentoContabilId (Guid, nullable FK)
└── Observacao (string 200, nullable)
```

### 18.2 Orcamento

```
Orcamento
├── Id (Guid)
├── Exercicio (int) — 2026
├── Nome (string 100) — "Orcamento 2026"
├── Status (enum: Elaboracao, Aprovado, Revisado, Encerrado)
├── DataAprovacao (DateTime, nullable)
├── AprovadoPor (Guid, nullable FK)
└── Itens (List<OrcamentoItem>)

OrcamentoItem
├── Id (Guid)
├── OrcamentoId (Guid FK)
├── PlanoContaId (Guid FK)
├── CentroCustoId (Guid, nullable FK)
├── Mes (int) — 1 a 12
├── ValorOrcado (decimal)
├── ValorRealizado (decimal) — calculado automaticamente
├── Desvio (decimal, computed)
└── Observacao (string 200, nullable)
```

### 18.3 Resumo de Entidades

| Submodulo | Entidades | Dominio Publico |
|-----------|-----------|-----------------|
| **Plano de Contas** | PlanoConta | -- |
| **Centro de Custo** | CentroCusto, RateioModelo, RateioModeloItem | -- |
| **Contas a Pagar** | TituloPagar, ParcelaPagar | NaturezaFinanceira, FormaPagamento |
| **Contas a Receber** | TituloReceber, ParcelaReceber | NaturezaFinanceira, FormaPagamento |
| **Tesouraria** | ContaBancaria, MovimentoBancario, BaixaFinanceira, TransferenciaBancaria | Banco |
| **Cheques** | TalonarioCheque, ChequeEmitido, ChequeRecebido | -- |
| **Cartoes** | RecebiveisCartao, TaxaCartao | OperadoraCartao, BandeiraCartao |
| **Conciliacao** | ExtratoBancario, TransacaoBancaria, Conciliacao | -- |
| **Fluxo de Caixa** | FluxoCaixa, CategoriaFluxoCaixa, ProjecaoFluxoCaixa, ProjecaoFluxoCaixaItem | -- |
| **DRE** | DreModelo, DreModeloLinha, DreResultado, DreResultadoLinha | -- |
| **Contabilidade** | LancamentoContabil, PartidaLancamento | -- |
| **Orcamento** | Orcamento, OrcamentoItem | -- |

**Total: ~35 entidades tenant + ~6 dominios publicos**

---

## 19. Bibliotecas .NET Recomendadas

### OFX Parsing

| Biblioteca | NuGet | Compatibilidade | Observacao |
|-----------|-------|-----------------|------------|
| **OFXParser** | `Install-Package OFXParser` | .NET Standard | Simples, converte OFX em objetos .NET |
| **OFXNet.Parser** | `Install-Package OFXNet.Parser` | .NET 6+ | Fork moderno do OFXSharp |
| **RFD.OFX-Tool** | `Install-Package RFD.OFX-Tool` | .NET 6+ | Sem dependencias, MIT license |
| **Mocoding.Ofx** | `Install-Package Mocoding.Ofx` | .NET Standard | Suporta SGML (OFX 1.x) e XML (OFX 2.x) |

### CNAB 240/400 e Boletos

| Biblioteca | NuGet | Compatibilidade | Observacao |
|-----------|-------|-----------------|------------|
| **BoletoNetCore** | `Install-Package BoletoNetCore` | .NET Core/.NET 6+ | Geracao de boletos + CNAB 240/400 remessa/retorno. Bancos: BB, Itau, Bradesco, Santander, Caixa, Banrisul, Sicoob, Sicredi |
| **Boleto.Net** | `Install-Package Boleto.Net` | .NET Framework | Versao legada (Framework only) |
| **Boleto2.Net** | `Install-Package Boleto2.Net` | .NET Standard | Alternativa mantida |

### Recomendacao para OpticalCore

- **OFX**: Usar `OFXNet.Parser` (mais moderno) ou `RFD.OFX-Tool` (zero dependencies)
- **CNAB/Boletos**: Usar `BoletoNetCore` (mais completo, suporte a todos os grandes bancos)
- **Alternativa**: Implementar parser OFX customizado (formato e simples — XML com tags fixas) e usar BoletoNetCore para CNAB

---

## 20. Fases de Implementacao Recomendadas

### Fase 1 — MVP Financeiro (Fundacao)
1. **Plano de Contas** — CRUD hierarquico com seed padrao para comercio optico
2. **Centro de Custo** — CRUD hierarquico
3. **Contas Bancarias** — CRUD com saldo
4. **Natureza Financeira** — Dominio publico com seed
5. **Forma de Pagamento** — Dominio publico com seed
6. **Contas a Pagar** — Titulo + Parcelas + Baixa manual
7. **Contas a Receber** — Titulo + Parcelas + Baixa manual
8. **Movimento Bancario** — Registro automatico nas baixas

### Fase 2 — Operacional
9. **Fluxo de Caixa** — Realizado (a partir de MovimentoBancario) + Projetado (a partir de titulos abertos)
10. **Transferencias Bancarias** — Entre contas
11. **Conciliacao Bancaria** — Import OFX + matching automatico + revisao manual
12. **Importacao CNAB Retorno** — Baixa automatica de boletos
13. **Dashboard Financeiro** — KPIs (saldo, vencidos, projecao 30 dias)

### Fase 3 — Avancado
14. **Lancamentos Contabeis** — Partida dobrada automatica e manual
15. **DRE** — Modelo configuravel + geracao mensal/anual
16. **Gestao de Cheques** — Emitidos e recebidos
17. **Recebiveis de Cartao** — Por operadora/bandeira com taxas
18. **Antecipacao de Recebiveis** — Calculo de taxa e valor liquido
19. **Orcamento** — Orcado vs realizado por conta/CC

### Fase 4 — Contabil/Fiscal
20. **Encerramento de Exercicio** — Zeramento de contas de resultado
21. **CNAB Remessa** — Geracao de arquivo de cobranca
22. **Rateio de Custos** — Distribuicao automatica por modelos
23. **Projecao de Fluxo de Caixa 13 Semanas** — Rolling forecast
24. **DRE Comparativo** — Orcado vs Realizado vs Ano Anterior
25. **Relatorios Contabeis** — Balancete, Razao, Diario

---

## 21. Fontes da Pesquisa

### Conciliacao Bancaria e OFX
- [CNAB 240 e CNAB 400: padroes de remessa e retorno — TecnoSpeed](https://blog.tecnospeed.com.br/padroes-de-remessa-e-de-retorno/)
- [CNAB 240 e 400: o que sao e diferencas — Vindi](https://blog.vindi.com.br/cnab-240-e-cnab-400/)
- [Layout Padrao Febraban 240 V10.9 (PDF)](https://cmsarquivos.febraban.org.br/Arquivos/documentos/PDF/Layout%20padrao%20CNAB240%20V%2010%2011%20-%2021_08_2023.pdf)
- [CNAB Layouts (open source)](https://glauberportella.github.io/cnab-layouts/)
- [Conciliacao bancaria OFX — Maxiprod](https://maxiprod.com.br/ajuda/financeiro/conciliacao-bancaria-por-importacao-de-arquivo-ofx/)
- [Extrato OFX — Conta Azul](https://contaazul.com/blog/extrato-ofx/)
- [OFX Format — FileFormat.com](https://docs.fileformat.com/finance/ofx/)
- [OFX Wikipedia](https://en.wikipedia.org/wiki/Open_Financial_Exchange)
- [Auto-Matching Algorithms — Cashbook](https://www.cashbook.com/auto-matching-algorithms-in-accounts-reconciliation/)
- [Conciliacao bancaria em ERP — SIG 2000](https://www.sig2000.com.br/conciliacao-bancaria-em-sistemas-erp-uma-abordagem-pratica/)
- [Santander CNAB 240 Layout (PDF)](https://cms.santander.com.br/sites/WPS/documentos/arq-layout-de-arquivos-download-cob240ptbr/25-06-13_130421_cnab-240-abril-2025-ptbr.pdf)

### Plano de Contas
- [Modelo Plano de Contas IFRS/CPC — Premier Cursos](https://premiercursos.com.br/cadastrar-artigos/modelo-do-plano-de-contas-de-acordo-com-as-normas-internacionais-de-contabilidade-em-ifrs-cpc-cfc/)
- [Plano de Contas Simplificado CFC — Lefisc](https://www.lefisc.com.br/plano_de_contas/html/plano_de_contas_simplificado_2016.htm)
- [Como Elaborar Plano de Contas — Portal de Contabilidade](https://www.portaldecontabilidade.com.br/guia/planodecontas.htm)
- [Plano de Contas: Estrutura e Modelo — Conta Azul](https://contaazul.com/blog/o-que-e-plano-de-contas/)
- [Plano de Contas Empresa — Sevilha (PDF)](https://www.sevilha.com.br/planodecontas.pdf)

### DRE
- [CPC 26 (R1) — Apresentacao Demonstracoes Contabeis](https://www.cpc.org.br/CPC/Documentos-Emitidos/Pronunciamentos/Pronunciamento?Id=57)
- [DRE: Estrutura Completa — LeverPro](https://blog.leverpro.com.br/post/estrutura-dre)
- [Modelo de DRE — Cora](https://www.cora.com.br/blog/modelo-de-dre-o-que-e/)
- [DRE na Contabilidade — Planning](https://planning.com.br/dre-contabilidade/)
- [DRE Gerencial vs Contabil — Kamino](https://kamino.com.br/blog/dre-o-que-e/)

### Centro de Custo
- [Centro de Custo: exemplos e implementacao — Omie](https://www.omie.com.br/blog/o-que-centro-de-custo/)
- [Rateio de Centro de Custos — DNA Financeiro](https://dnafinanceiro.com/funcionalidades/financeiro/rateio-centro-de-custos)
- [Criterio de Rateio — IXC Software](https://wiki-erp.ixcsoft.com.br/documentacao/menu-sistema/contabilidade/centro-de-custos-e-resultados/criterio-de-rateio.html)

### Tesouraria e Fluxo de Caixa
- [Tesouraria — Senior Sistemas](https://documentacao.senior.com.br/seniorxplatform/manual-do-usuario/erp/financas/tesouraria/tesouraria.htm)
- [Fluxo de Caixa Projetado 13 Semanas — VBMC](https://vbmc.com.br/fluxo-de-caixa-projetado/)
- [Fluxo de Caixa — WebMais](https://webmaissistemas.com.br/sistema-fluxo-de-caixa/)
- [Antecipacao de Recebiveis — Sankhya](https://www.sankhya.com.br/blog/antecipacao-de-recebiveis-saiba-o-que-e-e-como-fazer/)
- [Controle de Cheques de Terceiros — ERPFlex](https://docsnew.erpflex.com.br/controle-de-cheques/)
- [Compensacao e Devolucao de Cheques — CIGAM](https://www.cigam.com.br/wiki/index.php?title=GF_-_Como_Fazer_-_Compensa%C3%A7%C3%A3o_e_Devolu%C3%A7%C3%A3o_de_cheques)

### Lancamentos Contabeis
- [Lancamento Contabil — Senior](https://documentacao.senior.com.br/seniorxplatform/manual-do-usuario/erp/controladoria/gestao-contabilidade/lancamento-contabil.htm)
- [Lancamentos Contabeis — Sankhya](https://ajuda.sankhya.com.br/hc/pt-br/articles/360045116173-Lan%C3%A7amentos-Cont%C3%A1beis)
- [Partida Dobrada — Wikipedia](https://pt.wikipedia.org/wiki/M%C3%A9todo_das_partidas_dobradas)
- [Encerramento Exercicio — Calima ERP](https://ajuda.calimaerp.com/pt/article/como-encerrar-as-contas-de-resultado-zhxwwx/)

### Comparativo ERP
- [Modulo Financeiro TOTVS Protheus — BirdIT](https://birdit.com.br/tudo-sobre-o-modulo-financeiro-totvs-protheus/)
- [TOTVS Protheus Financeiro — GlobalGCS](https://www.globalgcs.com.br/erp-totvs-protheus/modulos/financeiro)
- [Tabelas Financeiro Protheus — FBSolutions](http://www.fbsolutions.com.br/erp-totvs-protheus/tabelas-financeiro-protheus/)
- [Tabela CT2 Lancamentos Contabeis Protheus](https://sempreju.com.br/tabelas_protheus/tabelas/tabela_ct2.html)
- [Funcionalidades Omie ERP](https://www.omie.com.br/funcionalidades/)
- [Conciliacao Bancaria Omie](https://www.omie.com.br/funcionalidades/conciliacao-bancaria/)
- [Omie API Developer Portal](https://developer.omie.com.br/service-list/)
- [SAP B1 Chart of Accounts](https://help.sap.com/docs/SAP_BUSINESS_ONE/68a2e87fb29941b5bf959a184d9c6727/4510c6960b9941dfe10000000a1553f6.html)
- [SAP B1 Accounting — InterGate](https://www.intergate.net.br/blog/sap-business-one/)
- [SAP B1 Automatic Journal Entries](https://learning.sap.com/courses/handling-accounting-in-sap-business-one/exploring-automatic-journal-entries-in-sap-business-one-1)

### Bibliotecas .NET
- [OFXParser.NET — GitHub](https://github.com/leonardomelosantos/ofxparser.net)
- [OFXParser — NuGet](https://www.nuget.org/packages/OFXParser)
- [OFXNet.Parser — NuGet](https://www.nuget.org/packages/OFXNet.Parser)
- [RFD.OFX-Tool — NuGet](https://www.nuget.org/packages/RFD.OFX-Tool/0.1.2)
- [BoletoNetCore — GitHub](https://github.com/BoletoNet/BoletoNetCore)
- [BoletoNetCore — NuGet](https://www.nuget.org/packages/BoletoNetCore/3.0.1.107)

### Modelagem ERP Financeiro
- [Modelando um ERP — Bloco Financeiro — Albert Eije](https://medium.com/@alberteije/modelando-um-erp-005-a79846238113)
- [T2Ti ERP Fenix — Financeiro](https://t2ti.com/erp3/)
- [T2Ti ERP Modulo Financeiro (PDF)](https://t2ti.com/erp/artigos/Financeiro.pdf)

### Contas a Pagar e Receber
- [Contas a Pagar — Sankhya](https://ajuda.sankhya.com.br/hc/pt-br/sections/360004102534-Contas-a-Pagar)
- [Contas a Receber — Sankhya](https://ajuda.sankhya.com.br/hc/pt-br/sections/360004102554-Contas-a-Receber)
- [Titulos a Pagar e Receber — Bling](https://ajuda.bling.com.br/hc/pt-br/sections/4402497985037-Contas-a-Receber)
- [Aging Report — Investopedia](https://www.investopedia.com/terms/a/aging.asp)
- [Regua de Cobranca — Conta Azul](https://contaazul.com/blog/regua-de-cobranca/)
- [Crediario Proprio — CDPV](https://cdpv.com.br/blog/crediario-proprio/)
- [Negativacao SPC/Serasa — SPC Brasil](https://www.spcbrasil.org.br/)

### Dashboard e KPIs Financeiros
- [KPIs Financeiros — Treasy](https://www.treasy.com.br/blog/indicadores-financeiros/)
- [Indice de Liquidez — Portal de Contabilidade](https://www.portaldecontabilidade.com.br/tematicas/indices-de-liquidez.htm)
- [Dashboard Financeiro — Conta Azul](https://contaazul.com/blog/dashboard-financeiro/)
- [Working Capital — Investopedia](https://www.investopedia.com/terms/w/workingcapital.asp)
- [EBITDA — Investopedia](https://www.investopedia.com/terms/e/ebitda.asp)

### Requisitos Fiscais e Tributarios
- Documento complementar: `PESQUISA-FISCAL-TRIBUTARIA.md` (58KB, 12 secoes)
- [SPED — Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/declaracoes-e-demonstrativos/sped-sistema-publico-de-escrituracao-digital)
- [EFD-Reinf — Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/declaracoes-e-demonstrativos/sped-sistema-publico-de-escrituracao-digital/escrituracao-fiscal-digital-de-retencoes-e-outras-informacoes-fiscais-efd-reinf)
- [Reforma Tributaria 2026 — Planalto](https://www.planalto.gov.br/ccivil_03/constituicao/emendas/emc/emc132.htm)
- [Split Payment IBS/CBS — Serpro](https://www.serpro.gov.br/menu/noticias/noticias-2024/split-payment-reforma-tributaria)
- [PIX API — Banco Central](https://www.bcb.gov.br/estabilidadefinanceira/pix)
- [Retencao ISS/IRRF/PIS/COFINS/CSLL — Portal Tributario](https://www.portaltributario.com.br/)
