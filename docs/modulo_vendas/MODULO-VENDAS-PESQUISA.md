# Pesquisa: Módulo de Vendas para ERP Genérico

> Levantamento completo de entidades, fluxos, relatórios, KPIs, dashboards, analytics avançado, boas práticas, requisitos fiscais brasileiros e especificidades do setor óptico para implementação do módulo de Vendas no OpticalCore ERP.
> Referências: SAP S/4HANA (SD), Oracle Order Management Cloud, Odoo 19, TOTVS Protheus (SIGAFAT/SIGAVND), Microsoft Dynamics 365 Sales, ERPNext, NetSuite.

---

## 1. Entidades Propostas

### 1.1 Dados Mestres (8 entidades)

| Entidade | Descrição | Schema |
|----------|-----------|--------|
| **Cliente** | Extensão de Pessoa com dados comerciais (limite de crédito, condição padrão, vendedor padrão, classificação) | Tenant |
| **TabelaPreco** | Tabelas de preço com vigência, prioridade e regras de aplicação (por cliente, grupo, região) | Tenant |
| **TabelaPrecoItem** | Itens da tabela de preço com preço unitário por produto | Tenant |
| **MetaVenda** | Metas de vendas por vendedor, equipe, período e tipo (receita, quantidade, margem) | Tenant |
| **MetaVendaDetalhe** | Detalhamento da meta por produto, categoria ou região | Tenant |
| **ComissaoRegra** | Regras de comissão (percentual, escalonada, por produto/categoria, por faixa) | Tenant |
| **ComissaoRegraFaixa** | Faixas escalonadas para cálculo progressivo de comissão | Tenant |
| **RegiaoVenda** | Regiões/territórios de venda para segmentação geográfica | Tenant |

### 1.2 Dados Transacionais — Ciclo Order-to-Cash (12 entidades)

| Entidade | Descrição | Referência ERP |
|----------|-----------|----------------|
| **Orcamento** | Proposta comercial / cotação para o cliente (documento não vinculante) | SAP: Quotation / Protheus: Orçamento de Venda (OV) / Dynamics 365: Quote |
| **OrcamentoItem** | Itens do orçamento com preço, desconto e condições | — |
| **PedidoVenda** | Pedido de venda formal (documento vinculante, compromisso de entrega) | SAP: Sales Order / Protheus: Pedido de Venda (PV) / Oracle: OE_ORDER_HEADERS_ALL |
| **PedidoVendaItem** | Itens do pedido de venda com quantidade, preço, desconto e situação | SAP: SO Item / Oracle: OE_ORDER_LINES_ALL |
| **EntregaVenda** | Documento de expedição/entrega (remessa de mercadoria) | SAP: Delivery (VL01N) / Protheus: Documento de Saída / Oracle: WSH_DELIVERY_DETAILS |
| **EntregaVendaItem** | Itens entregues com quantidade expedida e conferência | — |
| **FaturamentoVenda** | Fatura/nota fiscal de saída (documento fiscal vinculante) | SAP: Billing Document / Protheus: NF de Saída / Oracle: AR_INVOICES_ALL |
| **FaturamentoVendaItem** | Itens faturados com valores fiscais (CFOP, ICMS, IPI, PIS, COFINS) | — |
| **DevolucaoVenda** | Devolução de mercadoria pelo cliente (RMA) | SAP: Return Order / Protheus: Devolução de Venda / Dynamics 365: Return Order |
| **DevolucaoVendaItem** | Itens devolvidos com motivo, quantidade e estado | — |
| **ComissaoVenda** | Registro de comissão calculada por pedido/faturamento por vendedor | SAP: Commission Document / ERPNext: Sales Commission |
| **ComissaoVendaParcela** | Parcelas de pagamento da comissão (integração com Financeiro) | — |

### 1.3 Dados de Suporte (4 entidades)

| Entidade | Descrição |
|----------|-----------|
| **HistoricoPrecoVenda** | Histórico de preços de venda por produto/cliente para análise de tendências e variação |
| **AcompanhamentoMeta** | Snapshot periódico do progresso das metas (diário/semanal/mensal) |
| **LogDescontoEspecial** | Auditoria de descontos acima do limite padrão (quem autorizou, motivo) |
| **PedidoVendaAprovacao** | Log de aprovações/rejeições de pedidos (alçada, motivo) |

### 1.4 Domínios/Lookup (novos)

| Entidade | Descrição | Seeds Sugeridos |
|----------|-----------|-----------------|
| **FormaPagamento** | Formas de pagamento (dinheiro, cartão crédito/débito, PIX, boleto, cheque, transferência) | 8 seeds |
| **CondicaoPagamentoVenda** | Condições de pagamento de venda (à vista, 30 dias, 30/60, 30/60/90, cartão 1x a 12x) | 12 seeds |
| **MotivoDevolucaoVenda** | Motivos para devolução pelo cliente (defeito, insatisfação, troca, garantia, erro de pedido) | 8 seeds |
| **MotivoCancelamento** | Motivos para cancelamento de pedido (desistência, inadimplência, falta estoque, duplicidade) | 6 seeds |
| **StatusOrcamento** | Status do orçamento (domínio se preferir flexibilidade, ou enum se fixo) | — |
| **TipoDesconto** | Tipos de desconto (comercial, promocional, fidelidade, volume, cupom) | 6 seeds |
| **CanalVenda** | Canais de venda (loja física, e-commerce, televendas, representante, marketplace) | 5 seeds |

---

## 2. Campos Chave das Entidades

### 2.1 Orcamento (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| ClienteId | FK | Cliente destinatário |
| VendedorId | FK | Vendedor responsável |
| DataEmissao | date | Data de emissão |
| DataValidade | date | Data de validade da proposta |
| TabelaPrecoId | FK | Tabela de preço utilizada (nullable) |
| CondicaoPagamentoVendaId | FK | Condição de pagamento |
| FormaPagamentoId | FK | Forma de pagamento (nullable) |
| CanalVendaId | FK | Canal de venda (nullable) |
| SubTotal | decimal(18,2) | Soma dos itens antes de descontos |
| DescontoPercentual | decimal(5,2) | Desconto geral em percentual |
| DescontoValor | decimal(18,2) | Desconto geral em valor |
| AcrescimoValor | decimal(18,2) | Acréscimos (juros de parcelamento, etc.) |
| ValorFrete | decimal(18,2) | Valor do frete |
| ValorTotal | decimal(18,2) | SubTotal - Descontos + Acréscimos + Frete |
| Status | enum | Rascunho, Enviado, EmNegociacao, Aprovado, Rejeitado, Convertido, Expirado, Cancelado |
| MotivoRejeicao | string(500) | Motivo se rejeitado (nullable) |
| PedidoVendaId | FK | Pedido gerado após conversão (nullable) |
| Observacoes | text | Observações para o cliente |
| ObservacoesInternas | text | Observações internas (não visíveis ao cliente) |

### 2.2 OrcamentoItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| OrcamentoId | FK | Cabeçalho |
| Sequencia | int | Ordem no documento |
| ProdutoId | FK | Produto cotado |
| Descricao | string(500) | Descrição (pode sobrescrever a do produto) |
| Quantidade | decimal(18,3) | Quantidade |
| UnidadeMedidaId | FK | Unidade de medida |
| PrecoUnitario | decimal(18,4) | Preço unitário |
| DescontoPercentual | decimal(5,2) | Desconto do item em % |
| DescontoValor | decimal(18,2) | Desconto do item em R$ |
| ValorTotal | decimal(18,2) | (Quantidade * PrecoUnitario) - Desconto |
| Observacoes | text | Observações do item |

### 2.3 PedidoVenda (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| OrcamentoId | FK | Orçamento de origem (nullable — pedido pode ser direto) |
| ClienteId | FK | Cliente |
| VendedorId | FK | Vendedor responsável |
| DataEmissao | date | Data de emissão |
| DataEntregaPrevista | date | Data prevista de entrega |
| DataEntregaRealizada | date | Data efetiva de entrega (nullable) |
| TabelaPrecoId | FK | Tabela de preço utilizada (nullable) |
| CondicaoPagamentoVendaId | FK | Condição de pagamento |
| FormaPagamentoId | FK | Forma de pagamento |
| CanalVendaId | FK | Canal de venda (nullable) |
| RegiaoVendaId | FK | Região/território de venda (nullable) |
| SubTotal | decimal(18,2) | Soma dos itens |
| DescontoPercentual | decimal(5,2) | Desconto geral % |
| DescontoValor | decimal(18,2) | Desconto geral R$ |
| AcrescimoValor | decimal(18,2) | Acréscimos |
| ValorFrete | decimal(18,2) | Frete |
| ValorTotal | decimal(18,2) | Total do pedido |
| Prioridade | enum | Normal, Alta, Urgente |
| Status | enum | Pedido, Aprovado, Faturado, Expedido, Entregue, Cancelado |
| MotivoCancelamentoId | FK | Motivo do cancelamento (nullable) |
| AprovadorId | FK | Aprovador (nullable) |
| DataAprovacao | timestamp | Data/hora da aprovação (nullable) |
| Observacoes | text | Observações |
| ObservacoesInternas | text | Observações internas |

### 2.4 PedidoVendaItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| PedidoVendaId | FK | Cabeçalho |
| Sequencia | int | Ordem no documento |
| ProdutoId | FK | Produto |
| Descricao | string(500) | Descrição |
| Quantidade | decimal(18,3) | Quantidade pedida |
| QuantidadeEntregue | decimal(18,3) | Quantidade já entregue |
| QuantidadeFaturada | decimal(18,3) | Quantidade já faturada |
| QuantidadeCancelada | decimal(18,3) | Quantidade cancelada |
| UnidadeMedidaId | FK | Unidade de medida |
| PrecoUnitario | decimal(18,4) | Preço unitário |
| DescontoPercentual | decimal(5,2) | Desconto do item % |
| DescontoValor | decimal(18,2) | Desconto do item R$ |
| ValorTotal | decimal(18,2) | Total do item |
| DataEntregaPrevista | date | Previsão por item (nullable — herda do cabeçalho) |
| DepositoId | FK | Depósito de expedição (nullable) |
| LoteId | FK | Lote específico (nullable) |
| NumeroSerieId | FK | Número de série (nullable) |
| Observacoes | text | Observações do item |
| SituacaoItem | enum | Pendente, EmSeparacao, ParcialmenteEntregue, Entregue, Faturado, Cancelado |

### 2.5 EntregaVenda (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| PedidoVendaId | FK | Pedido de venda de origem |
| ClienteId | FK | Cliente destinatário |
| DataExpedicao | date | Data de expedição |
| DataEntregaPrevista | date | Previsão de entrega |
| DataEntregaRealizada | date | Data efetiva (nullable) |
| DepositoOrigemId | FK | Depósito de saída |
| EnderecoEntregaId | FK | Endereço de entrega (nullable — usa endereço do cliente) |
| TransportadoraId | FK | Transportadora (nullable) |
| ModalidadeFreteId | FK | CIF, FOB, etc. |
| PesoTotal | decimal(18,3) | Peso total em kg |
| VolumesTotal | int | Número de volumes |
| Status | enum | Rascunho, EmSeparacao, Separado, EmTransito, Entregue, ParcialmenteEntregue, Cancelado |
| CodigoRastreio | string(100) | Código de rastreio da transportadora |
| Observacoes | text | Observações |

### 2.6 EntregaVendaItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| EntregaVendaId | FK | Cabeçalho |
| PedidoVendaItemId | FK | Item do pedido correspondente |
| ProdutoId | FK | Produto |
| QuantidadeExpedida | decimal(18,3) | Quantidade expedida |
| LoteId | FK | Lote (nullable) |
| NumeroSerieId | FK | Número de série (nullable) |
| DepositoId | FK | Depósito de origem |
| LocalizacaoId | FK | Localização no depósito (nullable) |

### 2.7 FaturamentoVenda (Cabeçalho — NF de Saída)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial interno |
| PedidoVendaId | FK | Pedido de origem |
| EntregaVendaId | FK | Entrega correspondente (nullable) |
| ClienteId | FK | Cliente |
| DataFaturamento | date | Data do faturamento |
| DataVencimento | date | Data de vencimento |
| NumeroNF | string(20) | Número da nota fiscal |
| SerieNF | string(5) | Série da NF |
| ChaveAcessoNF | string(44) | Chave de acesso NF-e |
| NaturezaOperacao | string(100) | Natureza da operação (ex: "Venda de mercadoria") |
| CFOP | string(4) | Código Fiscal de Operações e Prestações |
| SubTotal | decimal(18,2) | Subtotal dos itens |
| DescontoTotal | decimal(18,2) | Total de descontos |
| ValorFrete | decimal(18,2) | Frete |
| ValorSeguro | decimal(18,2) | Seguro |
| OutrasDespesas | decimal(18,2) | Outras despesas acessórias |
| BaseCalculoICMS | decimal(18,2) | Base de cálculo ICMS |
| ValorICMS | decimal(18,2) | Valor ICMS |
| BaseCalculoIPI | decimal(18,2) | Base de cálculo IPI |
| ValorIPI | decimal(18,2) | Valor IPI |
| ValorPIS | decimal(18,2) | Valor PIS |
| ValorCOFINS | decimal(18,2) | Valor COFINS |
| ValorTotal | decimal(18,2) | Total da NF |
| Status | enum | Rascunho, Autorizada, Cancelada, Inutilizada, Denegada |
| CondicaoPagamentoVendaId | FK | Condição de pagamento |
| FormaPagamentoId | FK | Forma de pagamento |
| Observacoes | text | Observações (informações complementares da NF) |

### 2.8 FaturamentoVendaItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| FaturamentoVendaId | FK | Cabeçalho |
| PedidoVendaItemId | FK | Item do pedido (nullable) |
| ProdutoId | FK | Produto |
| Sequencia | int | Sequência no documento |
| Quantidade | decimal(18,3) | Quantidade faturada |
| PrecoUnitario | decimal(18,4) | Preço unitário |
| DescontoValor | decimal(18,2) | Desconto |
| ValorTotal | decimal(18,2) | Total do item |
| CFOP | string(4) | CFOP do item |
| NCM | string(8) | NCM do produto |
| CST_ICMS | string(3) | Código Situação Tributária ICMS |
| AliquotaICMS | decimal(5,2) | Alíquota ICMS |
| ValorICMS | decimal(18,2) | ICMS do item |
| CST_IPI | string(2) | CST do IPI |
| AliquotaIPI | decimal(5,2) | Alíquota IPI |
| ValorIPI | decimal(18,2) | IPI do item |
| CST_PIS | string(2) | CST do PIS |
| AliquotaPIS | decimal(5,2) | Alíquota PIS |
| ValorPIS | decimal(18,2) | PIS do item |
| CST_COFINS | string(2) | CST da COFINS |
| AliquotaCOFINS | decimal(5,2) | Alíquota COFINS |
| ValorCOFINS | decimal(18,2) | COFINS do item |
| OrigemMercadoria | string(1) | Origem da mercadoria (0-8) |
| UnidadeMedidaId | FK | Unidade de medida |

### 2.9 DevolucaoVenda (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| PedidoVendaId | FK | Pedido de venda original |
| FaturamentoVendaId | FK | Nota fiscal original (nullable) |
| ClienteId | FK | Cliente |
| DataDevolucao | date | Data da devolução |
| MotivoDevolucaoVendaId | FK | Motivo da devolução |
| ValorTotal | decimal(18,2) | Valor total devolvido |
| TipoCredito | enum | Reembolso, CreditoLoja, Troca |
| Status | enum | Rascunho, PendenteAnalise, Aprovada, Recebida, Creditada, Cancelada |
| AprovadorId | FK | Aprovador (nullable) |
| DataAprovacao | timestamp | Data da aprovação (nullable) |
| Observacoes | text | Observações |
| NumeroNFDevolucao | string(20) | Número da NF de devolução (nullable) |

### 2.10 DevolucaoVendaItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| DevolucaoVendaId | FK | Cabeçalho |
| PedidoVendaItemId | FK | Item original do pedido |
| ProdutoId | FK | Produto devolvido |
| QuantidadeDevolvida | decimal(18,3) | Quantidade devolvida |
| MotivoItemId | FK | Motivo específico do item (nullable — pode herdar do cabeçalho) |
| EstadoMercadoria | enum | Nova, Usada, Danificada, Defeituosa |
| RetornaEstoque | bool | Se deve retornar ao estoque |
| DepositoDestinoId | FK | Depósito de destino (se retorna ao estoque) |
| ValorUnitario | decimal(18,4) | Valor unitário para crédito |
| ValorTotal | decimal(18,2) | Valor total do item devolvido |
| Observacoes | text | Observações do item |

### 2.11 ComissaoVenda

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial |
| VendedorId | FK | Vendedor/representante |
| PedidoVendaId | FK | Pedido de venda (nullable) |
| FaturamentoVendaId | FK | Faturamento (nullable — comissão pode ser sobre faturamento) |
| PeriodoReferencia | string(7) | Período "YYYY-MM" |
| BaseCalculo | decimal(18,2) | Valor base para cálculo (receita líquida ou margem) |
| PercentualComissao | decimal(5,2) | Percentual aplicado |
| ValorComissao | decimal(18,2) | Valor da comissão calculada |
| ComissaoRegraId | FK | Regra de comissão aplicada |
| Status | enum | Calculada, Aprovada, Paga, Cancelada |
| DataCalculo | timestamp | Data do cálculo |
| DataPagamento | timestamp | Data do pagamento (nullable) |
| Observacoes | text | Observações |

### 2.12 TabelaPreco (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial |
| Nome | string(200) | Nome da tabela (ex: "Tabela Padrão", "Atacado", "Funcionários") |
| DataInicio | date | Início da vigência |
| DataFim | date | Fim da vigência (nullable — tabela sem expiração) |
| Ativa | bool | Se a tabela está ativa |
| Prioridade | int | Prioridade de aplicação (menor número = maior prioridade) |
| TipoAplicacao | enum | Geral, PorCliente, PorGrupoCliente, PorRegiao, PorCanalVenda |
| AcrescimoCondicaoPagamento | bool | Se aplica acréscimo automático por condição de pagamento |
| Observacoes | text | Observações |

### 2.13 MetaVenda

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial |
| VendedorId | FK | Vendedor/representante (nullable — pode ser meta de equipe) |
| RegiaoVendaId | FK | Região (nullable) |
| Periodo | string(7) | Período "YYYY-MM" |
| TipoMeta | enum | Receita, Quantidade, MargemBruta, NovosClientes |
| ValorMeta | decimal(18,2) | Valor/quantidade alvo |
| ValorRealizado | decimal(18,2) | Valor/quantidade realizado (atualizado periodicamente) |
| PercentualAtingimento | decimal(5,2) | % de atingimento (calculado) |
| Status | enum | Ativa, Encerrada |

### 2.14 ComissaoRegra

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial |
| Nome | string(200) | Nome da regra (ex: "Comissão Padrão Vendedor", "Comissão Gerente") |
| TipoCalculo | enum | PercentualFixo, Escalonada, PorProduto, PorCategoria, PorMargem |
| BaseCalculo | enum | ReceitaBruta, ReceitaLiquida, MargemBruta, MargemLiquida |
| PercentualFixo | decimal(5,2) | Percentual se tipo = PercentualFixo (nullable) |
| VendedorId | FK | Vendedor específico (nullable — null = regra geral) |
| DataInicio | date | Início da vigência |
| DataFim | date | Fim da vigência (nullable) |
| Ativa | bool | Se está ativa |

---

## 3. Workflows e Fluxos de Estado

### 3.1 Ciclo Order-to-Cash (Fluxo Principal)

```
Orçamento → Pedido de Venda → Entrega → Faturamento (NF-e) → Contas a Receber → Baixa
    ↓              ↓              ↓            ↓
 Expirado      Cancelado      Cancelado    Devolução
 Rejeitado                                 Cancelamento NF
```

**Fluxo Detalhado:**

```
1. ORÇAMENTO (Proposta Comercial)
   ├── Vendedor cria proposta para cliente
   ├── Cliente analisa (pode haver negociação — status EmNegociacao)
   ├── Cliente aprova → Converter em Pedido de Venda
   ├── Cliente rejeita → Registrar motivo de rejeição
   └── Prazo expira → Expirado (automático ou manual)

2. PEDIDO DE VENDA (Compromisso)
   ├── Criado diretamente OU convertido de orçamento
   ├── Verificar crédito do cliente (limite, inadimplência)
   ├── Se valor acima da alçada → PendenteAprovacao
   ├── Aprovado → Disponível para separação
   ├── EmSeparacao → Estoque reserva os itens
   ├── Parcialmente entregue → Backorder dos itens restantes
   ├── Totalmente entregue → Entregue
   └── Cancelado → Liberar reservas, registrar motivo

3. ENTREGA (Expedição)
   ├── Picking (separação no depósito)
   ├── Packing (embalagem, romaneio)
   ├── Shipping (despacho, transportadora)
   ├── Em Trânsito → Rastreamento
   ├── Entregue → Confirmação de recebimento
   └── Entrega parcial → Gera nova entrega para saldo

4. FATURAMENTO (NF-e)
   ├── Gerado automaticamente após entrega OU manualmente
   ├── Emissão da NF-e na SEFAZ
   ├── Geração de parcelas no Contas a Receber
   └── Faturamento parcial permitido

5. DEVOLUÇÃO (Pós-venda)
   ├── Cliente solicita devolução (RMA)
   ├── Análise interna (aprovação)
   ├── Recebimento da mercadoria
   ├── NF de devolução (entrada)
   ├── Crédito ao cliente (reembolso, crédito loja ou troca)
   └── Retorno ao estoque (se aplicável)
```

### 3.2 Workflow do Orçamento

```
                    ┌─────────────┐
                    │  Rascunho   │
                    └──────┬──────┘
                           │ Enviar
                    ┌──────▼──────┐
                    │   Enviado   │
                    └──────┬──────┘
                    ┌──────▼──────┐
              ┌─────┤ EmNegociacao├────────┐
              │     └─────────────┘        │
        ┌─────▼─────┐              ┌──────▼──────┐
        │  Aprovado  │              │  Rejeitado  │
        └─────┬──────┘              └─────────────┘
              │ Converter
        ┌─────▼──────┐
        │ Convertido │ → Gera PedidoVenda
        └────────────┘

        * Expirado: automático quando DataValidade < hoje e Status in (Enviado, EmNegociacao)
        * Cancelado: manual em qualquer status exceto Convertido
```

### 3.3 Workflow do Pedido de Venda

```
        ┌─────────────┐
        │  Rascunho   │
        └──────┬──────┘
               │ Submeter
        ┌──────▼──────────────┐
        │ PendenteAprovacao   │ (se valor > alçada do vendedor)
        └──────┬──────────────┘
               │ Aprovar
        ┌──────▼──────┐
        │  Aprovado   │──────────── Cancelar ──→ Cancelado
        └──────┬──────┘
               │ Iniciar separação
        ┌──────▼──────────┐
        │  EmSeparacao     │
        └──────┬───────────┘
               │ Entregar
        ┌──────▼──────────────────┐
        │ ParcialmenteEntregue    │←──── Entrega parcial (backorder)
        └──────┬──────────────────┘
               │ Entregar saldo
        ┌──────▼──────┐
        │  Entregue   │
        └──────┬──────┘
               │ Faturar
        ┌──────▼──────────────────┐
        │ ParcialmenteFaturado    │
        └──────┬──────────────────┘
               │ Faturar saldo
        ┌──────▼──────┐
        │  Faturado   │
        └──────┬──────┘
               │ Encerrar
        ┌──────▼──────┐
        │  Encerrado  │ (status terminal)
        └─────────────┘
```

### 3.4 Workflow da Devolução de Venda

```
        ┌─────────────┐
        │  Rascunho   │
        └──────┬──────┘
               │ Solicitar análise
        ┌──────▼────────────┐
        │ PendenteAnalise   │
        └──────┬────────────┘
               │ Aprovar
        ┌──────▼──────┐
        │  Aprovada   │──── Rejeitar ──→ Cancelada
        └──────┬──────┘
               │ Receber mercadoria
        ┌──────▼──────┐
        │  Recebida   │ → Gera MovimentacaoEstoque (Entrada)
        └──────┬──────┘
               │ Gerar crédito
        ┌──────▼──────┐
        │  Creditada  │ → Gera crédito no Financeiro
        └─────────────┘
```

---

## 4. Relatórios Padrão do Módulo de Vendas

**API:** `GET /api/relatorios-vendas/{endpoint}`. Índice completo, parâmetros e analytics em [README.md](README.md).

| Relatório | Endpoint |
|-----------|----------|
| R01 Vendas por Período | `vendas-por-periodo` |
| R02 Vendas por Cliente | `vendas-por-cliente` |
| R03 Vendas por Produto | `vendas-por-produto` |
| R04 Vendas por Vendedor | `vendas-por-vendedor` |
| R05 Vendas por Região | `vendas-por-regiao` |
| R06 Vendas por Canal | `vendas-por-canal` |
| R07 Lucratividade/Margem | `lucratividade-produto` |
| R08 Curva ABC Clientes | `curva-abc-clientes` |
| R09 Curva ABC Produtos | `curva-abc-produtos` |
| R10 Análise de Descontos | `analise-descontos` |
| R11 Carteira de Pedidos | `carteira-pedidos` |
| R12 Funil de Vendas | `funil-vendas` |
| R13 Forecast | `forecast` |
| R14 Variação de Preços | `variacao-precos` |
| R15 Devoluções | `devolucoes-venda` |
| R16 Cancelamentos | `cancelamentos` |
| R17 Comissões por Vendedor | `comissoes-por-vendedor` |
| R18 Resumo Comissões | `resumo-comissoes-periodo` |
| R19 Ticket Médio | `ticket-medio` |
| R20 Frequência de Compra | `frequencia-compra` |
| Metas vs Realizado | `metas-vs-realizado` |
| Analytics: RFM, Cohort, CLV, Churn, Sazonalidade, Cross-sell | `rfm`, `cohort`, `clv`, `churn`, `seasonality`, `cross-sell` |

### 4.1 Relatórios de Volume e Receita (6 relatórios)

#### R01 — Vendas por Período

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de receita e volume de vendas segmentada por período temporal |
| **Granularidade** | Diário, Semanal, Mensal, Trimestral, Anual |
| **Métricas** | Receita bruta, Receita líquida, Quantidade de pedidos, Ticket médio, Variação % vs período anterior |
| **Filtros** | Data início/fim, Vendedor, Canal de venda, Região, Status do pedido |
| **Visualização** | Tabela com totalizadores + Gráfico de linha (tendência) + Gráfico de barras (comparativo) |
| **Referência ERP** | SAP: VA05 (List of Sales Orders) / NetSuite: Sales by Period / TOTVS: Relatório de Faturamento por Período |
| **Cálculos** | Receita Líquida = Receita Bruta - Devoluções - Descontos. Variação = ((Atual - Anterior) / Anterior) * 100 |

#### R02 — Vendas por Cliente

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Ranking de clientes por volume de compras com análise de participação |
| **Métricas** | Receita total, Quantidade de pedidos, Ticket médio, Frequência de compra, % de participação no faturamento, Margem por cliente |
| **Filtros** | Período, Vendedor, Região, Canal, Classificação do cliente, Status |
| **Visualização** | Tabela ranqueada + Gráfico de Pareto (80/20) + KPIs de concentração |
| **Referência ERP** | SAP: MCTA (Customer Analysis) / NetSuite: Sales by Customer Summary / TOTVS: Relatório de Vendas por Cliente |
| **Cálculos** | % Participação = (Receita Cliente / Receita Total) * 100. Frequência = Pedidos / Meses do período |

#### R03 — Vendas por Produto/Categoria

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de vendas por produto individual e por categoria de produto |
| **Métricas** | Quantidade vendida, Receita, Margem bruta, Margem %, % de participação, Ranking, Estoque atual |
| **Filtros** | Período, Categoria, Grupo de produtos, Fornecedor, Vendedor |
| **Visualização** | Tabela agrupável por categoria + Gráfico de barras horizontal (top N) + Treemap |
| **Referência ERP** | SAP: MCTC (Material Analysis) / NetSuite: Sales by Item Summary / TOTVS: Relatório por Produto |
| **Cálculos** | Margem Bruta = Receita - CMV. Margem % = (Margem / Receita) * 100 |

#### R04 — Vendas por Vendedor/Representante

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Performance individual de vendedores com comparativo e atingimento de metas |
| **Métricas** | Receita, Quantidade pedidos, Ticket médio, Meta, % Atingimento, Comissão gerada, Novos clientes, Taxa de conversão (orçamentos → pedidos) |
| **Filtros** | Período, Vendedor/Equipe, Região, Canal |
| **Visualização** | Tabela comparativa + Gráfico de barras agrupado + Gauge de meta |
| **Referência ERP** | SAP: Sales by Sales Rep / NetSuite: Sales by Sales Rep Detail / TOTVS: Comissão de Vendedores |
| **Cálculos** | % Atingimento = (Realizado / Meta) * 100. Conversão = (Pedidos / Orçamentos) * 100 |

#### R05 — Vendas por Região/Território

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Distribuição geográfica das vendas por região, estado ou território de venda |
| **Métricas** | Receita por região, Quantidade de clientes ativos, Pedidos por região, Penetração de mercado, Crescimento % |
| **Filtros** | Período, Estado, Cidade, Região de venda, Vendedor |
| **Visualização** | Mapa de calor (bubble map) + Tabela com drill-down estado → cidade + Gráfico de barras |
| **Referência ERP** | SAP: MCTE (Sales Organization Analysis) / NetSuite: Sales by Territory / Dynamics 365: Territory Dashboard |
| **Cálculos** | Penetração = (Clientes Ativos na Região / Total Potencial) * 100 |

#### R06 — Vendas por Canal

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Comparativo de performance entre canais de venda |
| **Métricas** | Receita por canal, Volume, Ticket médio, Margem, Custo de aquisição por canal, ROI por canal |
| **Filtros** | Período, Canal, Região, Produto |
| **Visualização** | Gráfico de pizza/donut + Tabela comparativa + Tendência por canal |
| **Referência ERP** | Oracle: Revenue by Sales Channel / NetSuite: Revenue by Channel |

### 4.2 Relatórios de Rentabilidade e Margem (4 relatórios)

#### R07 — Análise de Lucratividade / Margem

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise detalhada de margens por produto, cliente, categoria e período |
| **Dimensões** | Por Produto, Por Cliente, Por Categoria, Por Vendedor, Por Região, Por Canal |
| **Métricas** | Receita bruta, CMV (Custo da Mercadoria Vendida), Margem bruta, Margem bruta %, Margem de contribuição, Margem líquida |
| **Filtros** | Período, Dimensão de análise, Faixa de margem (negativa, baixa, média, alta) |
| **Visualização** | Tabela com heatmap por margem + Gráfico waterfall + Scatter plot (receita vs margem) |
| **Referência ERP** | SAP: Profitability Analysis (CO-PA) / Oracle: Margin Analysis / TOTVS: Análise de Lucratividade |
| **Cálculos** | CMV = Custo Médio Ponderado * Quantidade. Margem Bruta = Receita - CMV. Margem % = (Margem / Receita) * 100. Margem Contribuição = Margem Bruta - Custos Variáveis Diretos |

#### R08 — Curva ABC de Clientes

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Classificação de clientes por participação no faturamento usando análise de Pareto (80/20) |
| **Classificação** | Classe A: 80% do faturamento (~20% dos clientes). Classe B: 15% do faturamento (~30% dos clientes). Classe C: 5% do faturamento (~50% dos clientes) |
| **Métricas** | Receita acumulada, % acumulado, Quantidade de pedidos, Frequência, Ticket médio, Margem |
| **Filtros** | Período, Região, Canal, Vendedor |
| **Visualização** | Gráfico de Pareto (barras + linha acumulada) + Tabela com classificação + KPIs por classe |
| **Referência ERP** | SAP: Customer ABC Analysis / Oracle: Customer Segmentation / Magento: Customer ABC Analysis Report |
| **Cálculos** | Ordenar clientes por receita DESC. % Acumulado = soma progressiva. Classe A = até 80%. Classe B = 80-95%. Classe C = 95-100% |

#### R09 — Curva ABC de Produtos

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Classificação de produtos por participação no faturamento e/ou na margem |
| **Critérios** | Por Receita, Por Margem Bruta, Por Quantidade Vendida |
| **Classificação** | Classe A: ~65-80% da receita/margem. Classe B: ~15-30%. Classe C: ~5-10% |
| **Métricas** | Receita, Margem, Quantidade, % acumulado, Giro de estoque, Estoque atual |
| **Filtros** | Período, Categoria, Critério de classificação |
| **Visualização** | Gráfico de Pareto + Tabela classificada + Cross-reference com estoque |
| **Referência ERP** | SAP: Material ABC Analysis / ERPNext: Product Profitability / TOTVS: Curva ABC |
| **Cálculos** | Mesmo algoritmo da Curva ABC de Clientes, aplicado a produtos. Cross-reference: Classe A no ABC Vendas vs Classe C no Estoque = alerta de ruptura |

#### R10 — Análise de Descontos

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de impacto dos descontos concedidos na receita e margem |
| **Métricas** | Total de descontos concedidos, % médio de desconto, Impacto na margem, Desconto por vendedor, Desconto por cliente, Desconto por produto |
| **Filtros** | Período, Vendedor, Cliente, Tipo de desconto, Faixa de desconto |
| **Visualização** | Tabela comparativa + Gráfico de dispersão (desconto vs volume) + Histograma de faixas |
| **Referência ERP** | SAP: Pricing Analysis / Oracle: Discount Analysis / TOTVS: Análise de Descontos |
| **Cálculos** | Desconto Médio = Total Descontos / Receita Bruta * 100. Impacto = Receita que seria sem desconto - Receita real. Elasticidade = Δ% Volume / Δ% Preço |

### 4.3 Relatórios de Pipeline e Previsão (4 relatórios)

#### R11 — Carteira de Pedidos / Backlog

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Pedidos de venda abertos aguardando entrega e/ou faturamento |
| **Métricas** | Valor total em carteira, Quantidade de pedidos, Aging (dias de atraso), Valor por status, Previsão de entrega |
| **Filtros** | Status, Vendedor, Cliente, Prioridade, Data de entrega prevista |
| **Visualização** | Tabela com aging colorido + Gráfico de barras empilhadas (por status) + KPI de atraso médio |
| **Referência ERP** | SAP: VA05 (Open Orders) / Oracle: Order Backlog Report / NetSuite: Open Sales Orders |
| **Cálculos** | Backlog = Pedidos com Status in (Aprovado, EmSeparacao, ParcialmenteEntregue). Aging = DataAtual - DataEntregaPrevista. Backlog-to-Billing Ratio = Backlog / Faturamento Médio Mensal |

#### R12 — Funil de Vendas / Conversão

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de conversão em cada etapa do ciclo de vendas (orçamento → pedido → entrega → faturamento) |
| **Etapas** | Orçamentos criados → Orçamentos enviados → Em negociação → Convertidos em pedido → Entregues → Faturados |
| **Métricas** | Volume em cada etapa, Taxa de conversão entre etapas, Tempo médio em cada etapa, Valor potencial, Win rate |
| **Filtros** | Período, Vendedor, Canal, Região, Faixa de valor |
| **Visualização** | Funil gráfico + Tabela de conversão + Gráfico Sankey |
| **Referência ERP** | Dynamics 365: Sales Funnel / Salesforce: Pipeline Report / NetSuite: Sales Pipeline |
| **Cálculos** | Taxa Conversão = (Convertidos / Total da Etapa Anterior) * 100. Win Rate = Pedidos Fechados / Orçamentos Totais * 100. Tempo Médio Ciclo = Média(DataPedido - DataOrcamento) |

#### R13 — Previsão de Vendas / Forecast

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Projeção de vendas futuras baseada em pipeline atual, histórico e tendências |
| **Métodos** | Média móvel simples, Média móvel ponderada, Índice de sazonalidade, Projeção linear |
| **Métricas** | Receita prevista (próximos 1/3/6/12 meses), Intervalo de confiança, Receita do pipeline ativo, Tendência de crescimento |
| **Filtros** | Período de projeção, Método de cálculo, Vendedor, Produto, Região |
| **Visualização** | Gráfico de linha (histórico + projeção com faixa de confiança) + Tabela mensal + KPI de pipeline coverage |
| **Referência ERP** | SAP: Sales Forecasting / Oracle: Demand Forecasting / NetSuite: Sales Forecast |
| **Cálculos** | Média Móvel (3 meses) = (M1 + M2 + M3) / 3. Índice Sazonalidade = Vendas Mês / Média Anual. Pipeline Coverage = Pipeline Ativo / Meta Restante. Forecast = Histórico * Índice Sazonalidade * Fator de Crescimento |

#### R14 — Variação de Preços

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise da evolução de preços de venda e impacto no volume e margem |
| **Métricas** | Preço médio ponderado, Variação % no período, Preço vs tabela base, Volume antes/depois de reajuste, Impacto na margem |
| **Filtros** | Período, Produto, Categoria, Cliente, Tabela de preço |
| **Visualização** | Gráfico de linha (evolução preço) + Tabela comparativa (períodos) + Scatter (preço vs volume) |
| **Referência ERP** | SAP: Pricing Condition Analysis / Oracle: Price Variance Report |
| **Cálculos** | Preço Médio = Σ(Preço * Quantidade) / Σ(Quantidade). Variação = ((Preço Atual - Preço Anterior) / Preço Anterior) * 100. Elasticidade Preço = (Δ% Quantidade / Δ% Preço) |

### 4.4 Relatórios de Devoluções e Cancelamentos (2 relatórios)

#### R15 — Devoluções de Venda

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de devoluções por motivo, produto, cliente e período |
| **Métricas** | Volume de devoluções, Valor devolvido, Taxa de devolução (% sobre vendas), Ranking por motivo, Ranking por produto devolvido, Tempo médio de processamento |
| **Filtros** | Período, Motivo, Produto, Cliente, Vendedor, Status |
| **Visualização** | Tabela com drill-down + Gráfico de pizza (motivos) + Gráfico de tendência + KPI de taxa |
| **Referência ERP** | SAP: Return Orders Analysis / Dynamics 365: Returns Report / TOTVS: Devoluções |
| **Cálculos** | Taxa Devolução = (Valor Devolvido / Receita Bruta) * 100. Custo Logístico = Frete Reverso + Custo Reprocessamento. Net Sales = Gross Sales - Returns - Allowances |

#### R16 — Cancelamentos de Pedidos

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise de pedidos cancelados por motivo, etapa e impacto |
| **Métricas** | Volume de cancelamentos, Valor perdido, Taxa de cancelamento, Distribuição por motivo, Etapa do cancelamento |
| **Filtros** | Período, Motivo, Vendedor, Cliente, Etapa (status no momento do cancelamento) |
| **Visualização** | Tabela + Gráfico de barras (motivos) + Gráfico de tendência + Funil com perdas |
| **Cálculos** | Taxa Cancelamento = (Pedidos Cancelados / Pedidos Totais) * 100. Valor Perdido = Σ(ValorTotal dos pedidos cancelados). Recuperação = Pedidos Cancelados depois reativados |

### 4.5 Relatórios de Comissões (2 relatórios)

#### R17 — Comissões por Vendedor

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Detalhamento das comissões por vendedor, com base de cálculo e regra aplicada |
| **Métricas** | Receita base, Percentual aplicado, Valor comissão bruta, Deduções (devoluções), Comissão líquida, Status do pagamento |
| **Filtros** | Período, Vendedor, Status do pagamento, Regra de comissão |
| **Visualização** | Tabela detalhada por vendedor com drill-down por pedido + Resumo de totais |
| **Referência ERP** | SAP: Commission Statement / ERPNext: Sales Commission / TOTVS: Relatório de Comissões |
| **Cálculos** | Comissão Bruta = Base * Percentual. Dedução = Comissão sobre devoluções do período. Comissão Líquida = Bruta - Deduções |

#### R18 — Resumo de Comissões por Período

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Visão consolidada de comissões para folha de pagamento e contabilidade |
| **Métricas** | Total de comissões por período, Por vendedor, Por tipo de regra, Comparativo com períodos anteriores |
| **Filtros** | Período, Status, Vendedor |
| **Visualização** | Tabela resumo + Gráfico de barras comparativo (mês a mês) |

### 4.6 Relatórios de Ticket e Frequência (2 relatórios)

#### R19 — Ticket Médio

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise do valor médio dos pedidos por diferentes dimensões |
| **Dimensões** | Por período, Por vendedor, Por cliente, Por canal, Por região, Por categoria |
| **Métricas** | Ticket médio global, Ticket médio por dimensão, Evolução temporal, Comparativo % |
| **Filtros** | Período, Dimensão de agrupamento, Tipo (orçamento vs pedido) |
| **Visualização** | KPI card + Gráfico de linha (tendência) + Tabela por dimensão |
| **Cálculos** | Ticket Médio = Receita Total / Número de Pedidos. Ticket Mediano = Mediana dos valores dos pedidos. Variação = ((Ticket Atual - Ticket Anterior) / Ticket Anterior) * 100 |

#### R20 — Frequência de Compra por Cliente

| Aspecto | Detalhe |
|---------|---------|
| **Descrição** | Análise da recorrência de compras por cliente |
| **Métricas** | Frequência média (pedidos/mês), Intervalo médio entre compras (dias), Clientes ativos vs inativos, Clientes em risco de churn |
| **Filtros** | Período, Segmento do cliente, Região, Vendedor |
| **Visualização** | Tabela ranqueada + Histograma de frequência + Alerta de inatividade |
| **Cálculos** | Frequência = Pedidos no Período / Meses do Período. Intervalo Médio = Média(Data Pedido N+1 - Data Pedido N). Em Risco = Último Pedido > 2x Intervalo Médio |

---

## 5. Dashboard de Vendas — KPIs

### 5.1 KPIs Primários (Nível Executivo) — 10 indicadores

| # | KPI | Fórmula | Unidade | Meta Típica | Visualização |
|---|-----|---------|---------|-------------|--------------|
| 1 | **Faturamento do Período** | Σ(ValorTotal dos faturamentos autorizados) | R$ | Conforme meta | KPI card com comparativo vs mês anterior e vs meta |
| 2 | **Faturamento Acumulado (YTD)** | Σ(Faturamento do ano até a data atual) | R$ | Meta anual | KPI card com barra de progresso |
| 3 | **Margem Bruta** | (Receita - CMV) / Receita * 100 | % | > 30-40% | KPI card com indicador de tendência |
| 4 | **Número de Pedidos** | Count(PedidosVenda no período) | unid | Variável | KPI card com comparativo |
| 5 | **Ticket Médio** | Faturamento / Número de Pedidos | R$ | Crescente | KPI card com tendência |
| 6 | **Taxa de Conversão** | Pedidos Gerados / Orçamentos Criados * 100 | % | > 25-40% | KPI card + Funil |
| 7 | **Meta vs Realizado** | Faturamento Real / Meta * 100 | % | >= 100% | Gauge / Progress bar |
| 8 | **Valor em Carteira (Backlog)** | Σ(ValorTotal pedidos abertos) | R$ | — | KPI card |
| 9 | **Taxa de Devoluções** | Valor Devolvido / Receita Bruta * 100 | % | < 3-5% | KPI card (vermelho se acima) |
| 10 | **Prazo Médio de Entrega** | Média(DataEntregaRealizada - DataPedido) | dias | Decrescente | KPI card |

### 5.2 KPIs Secundários (Nível Gerencial) — 10 indicadores

| # | KPI | Fórmula | Unidade |
|---|-----|---------|---------|
| 11 | **Top 10 Clientes** | Ranking por receita no período | R$ / ranking |
| 12 | **Top 10 Produtos** | Ranking por quantidade ou receita | unid / R$ |
| 13 | **Entregas Pendentes** | Count(Pedidos com DataEntregaPrevista < Hoje e Status != Entregue) | unid |
| 14 | **Pedidos Atrasados** | Count(Pedidos com DataEntrega ultrapassada) | unid |
| 15 | **Comissões do Período** | Σ(Comissões calculadas no período) | R$ |
| 16 | **Clientes Novos no Período** | Count(Clientes com primeiro pedido no período) | unid |
| 17 | **Desconto Médio Concedido** | Σ(Descontos) / Σ(Receita Bruta) * 100 | % |
| 18 | **Pedidos por Vendedor (Média)** | Total Pedidos / Total Vendedores Ativos | unid |
| 19 | **Orçamentos em Aberto** | Count(Orçamentos com Status in Enviado, EmNegociacao) | unid / R$ |
| 20 | **Taxa de Cancelamento** | Pedidos Cancelados / Pedidos Totais * 100 | % |

### 5.3 KPIs Avançados (Nível Analítico) — 8 indicadores

| # | KPI | Fórmula | Unidade |
|---|-----|---------|---------|
| 21 | **Customer Lifetime Value (CLV)** | Ticket Médio * Frequência Compra * Tempo Vida Médio | R$ |
| 22 | **Custo de Aquisição de Cliente (CAC)** | Custos Comerciais / Novos Clientes | R$ |
| 23 | **Relação CLV/CAC** | CLV / CAC | ratio |
| 24 | **Ciclo Médio de Vendas** | Média(DataPedido - DataOrcamento) | dias |
| 25 | **Pipeline Coverage** | Valor Pipeline Ativo / Meta Restante do Período | ratio |
| 26 | **Receita por Vendedor** | Faturamento Total / Vendedores Ativos | R$ |
| 27 | **Índice de Recorrência** | Clientes com > 1 pedido / Total Clientes Ativos * 100 | % |
| 28 | **Net Promoter Score Vendas** | % Promotores - % Detratores (se pesquisa integrada) | score |

### 5.4 Layout do Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│ DASHBOARD DE VENDAS                                    [Período ▼] │
├─────────┬──────────┬──────────┬──────────┬──────────┬──────────────┤
│Faturamen│ Margem   │ Pedidos  │ Ticket   │Conversão │ Meta vs Real │
│R$ 450K  │ 38.5%    │ 287      │ R$ 1.568 │ 32.4%    │ 87.3%        │
│+12.3%   │ -0.8pp   │ +8.2%    │ +4.1%    │ +2.1pp   │ ████████░░   │
├─────────┴──────────┴──────────┴──────────┴──────────┴──────────────┤
│                                                                     │
│  ┌─────────────────────────┐  ┌──────────────────────────────────┐  │
│  │ Vendas Mensais (12m)    │  │ Top 10 Produtos por Receita      │  │
│  │ BarChart + Line (meta)  │  │ BarChart horizontal              │  │
│  │                         │  │                                  │  │
│  │                         │  │                                  │  │
│  └─────────────────────────┘  └──────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────────────┐  ┌──────────────────────────────────┐  │
│  │ Vendas por Canal        │  │ Top 10 Clientes                  │  │
│  │ PieChart / Donut        │  │ Tabela ranqueada                 │  │
│  │                         │  │                                  │  │
│  └─────────────────────────┘  └──────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────────────┐  ┌──────────────────────────────────┐  │
│  │ Funil de Conversão      │  │ Alertas                          │  │
│  │ FunnelChart             │  │ ⚠ 12 entregas pendentes          │  │
│  │ Orçamento → Pedido →    │  │ ⚠ 5 pedidos atrasados            │  │
│  │ Entrega → Faturamento   │  │ ⚠ 3 clientes inativos >60d      │  │
│  └─────────────────────────┘  └──────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### 5.5 Gráficos do Dashboard

| Gráfico | Tipo | Dados | Posição |
|---------|------|-------|---------|
| Vendas Mensais (12 meses) | BarChart + LineChart (meta) | Faturamento mensal + Linha de meta | Principal, canto superior esquerdo |
| Top 10 Produtos | BarChart horizontal | Receita por produto, top 10 | Superior direito |
| Vendas por Canal | PieChart / Donut | % por canal de venda | Meio esquerdo |
| Top 10 Clientes | Tabela ranqueada | Nome, Receita, % participação | Meio direito |
| Funil de Conversão | FunnelChart | Orçamentos → Pedidos → Entregas → Faturamentos | Inferior esquerdo |
| Alertas Operacionais | Lista com ícones | Entregas pendentes, atrasos, inadimplentes | Inferior direito |
| Tendência Margem Bruta | LineChart | Margem % dos últimos 12 meses | Secundário |
| Performance Vendedores | BarChart agrupado | Realizado vs Meta por vendedor | Secundário |

---

## 6. Analytics Avançado

**Endpoints API:** `GET /api/relatorios-vendas/rfm` | `cohort` | `clv` | `churn` | `seasonality` | `cross-sell`. Ver [README.md](README.md).

### 6.1 Análise de Coorte (Cohort Analysis)

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Agrupamento de clientes pela data do primeiro pedido (mês de aquisição) e acompanhamento da retenção/receita ao longo do tempo |
| **Objetivo** | Medir retenção de clientes, identificar safras melhores/piores, avaliar eficácia de campanhas |
| **Dimensões** | Coorte de aquisição (mês/trimestre), Meses de vida (0, 1, 2, 3... 12) |
| **Métricas** | Taxa de retenção %, Receita por coorte, Ticket médio por coorte, Churn por coorte |
| **Visualização** | Tabela triangular com heatmap (mais escuro = maior retenção) |

**Estrutura da Tabela de Coorte:**

```
Coorte    │ Mês 0 │ Mês 1 │ Mês 2 │ Mês 3 │ Mês 4 │ Mês 5 │ ... │ Mês 12
──────────┼───────┼───────┼───────┼───────┼───────┼───────┼─────┼────────
Jan/2026  │ 100%  │ 72%   │ 58%   │ 51%   │ 45%   │ 42%   │     │ 35%
Fev/2026  │ 100%  │ 68%   │ 55%   │ 48%   │ 43%   │       │     │
Mar/2026  │ 100%  │ 75%   │ 61%   │ 53%   │       │       │     │
Abr/2026  │ 100%  │ 70%   │ 57%   │       │       │       │     │
```

**Cálculo:**
```
Retenção(Coorte, Mês N) = Clientes da Coorte ativos no Mês N / Total da Coorte * 100

Onde:
- "Ativo" = realizou pelo menos 1 pedido no mês N
- Coorte = mês do primeiro pedido do cliente
```

**Implementação no Backend:**
```sql
-- Identificar coorte (mês do primeiro pedido por cliente)
WITH coortes AS (
  SELECT cliente_id,
         DATE_TRUNC('month', MIN(data_emissao)) AS mes_aquisicao
  FROM pedidos_venda
  WHERE status NOT IN ('Cancelado', 'Rascunho')
  GROUP BY cliente_id
),
-- Atividade mensal
atividade AS (
  SELECT p.cliente_id,
         DATE_TRUNC('month', p.data_emissao) AS mes_atividade
  FROM pedidos_venda p
  WHERE p.status NOT IN ('Cancelado', 'Rascunho')
  GROUP BY p.cliente_id, DATE_TRUNC('month', p.data_emissao)
)
SELECT
  c.mes_aquisicao,
  EXTRACT(MONTH FROM AGE(a.mes_atividade, c.mes_aquisicao)) AS mes_vida,
  COUNT(DISTINCT a.cliente_id) AS clientes_ativos,
  (SELECT COUNT(DISTINCT c2.cliente_id)
   FROM coortes c2
   WHERE c2.mes_aquisicao = c.mes_aquisicao) AS total_coorte
FROM coortes c
JOIN atividade a ON a.cliente_id = c.cliente_id
GROUP BY c.mes_aquisicao, EXTRACT(MONTH FROM AGE(a.mes_atividade, c.mes_aquisicao))
ORDER BY c.mes_aquisicao, mes_vida;
```

### 6.2 Análise RFM (Recency, Frequency, Monetary)

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Segmentação de clientes baseada em 3 dimensões: recência da última compra, frequência de compras e valor monetário |
| **Objetivo** | Identificar melhores clientes, clientes em risco, oportunidades de reativação e priorização comercial |
| **Scoring** | Cada dimensão recebe nota de 1 a 5 (quintis) |

**Dimensões RFM:**

| Dimensão | Sigla | O que mede | Cálculo |
|----------|-------|------------|---------|
| **Recência** | R | Quão recente foi a última compra | DataAtual - DataÚltimoPedido (dias) |
| **Frequência** | F | Quantas vezes o cliente comprou | Count(Pedidos) no período |
| **Monetário** | M | Quanto o cliente gastou | Σ(ValorTotal pedidos) no período |

**Segmentos RFM:**

| Segmento | Score RFM | Descrição | Ação Recomendada |
|----------|-----------|-----------|------------------|
| **Campeões** | R:5, F:5, M:5 | Compram frequente, gastam muito, compraram recentemente | Programas de fidelidade, tratamento VIP |
| **Clientes Fiéis** | R:3-5, F:4-5, M:3-5 | Compram com regularidade | Upsell, cross-sell |
| **Potenciais Fiéis** | R:4-5, F:2-3, M:2-3 | Compraram recentemente, potencial de crescimento | Oferecer programa de fidelidade, incentivos de recompra |
| **Novos Clientes** | R:5, F:1, M:1-2 | Primeira compra recente | Onboarding, boas-vindas, segunda compra |
| **Promissores** | R:4, F:1-2, M:1-3 | Compraram recentemente, poucos pedidos | Campanhas de engajamento |
| **Precisam Atenção** | R:2-3, F:2-3, M:2-3 | Clientes médios que estão esfriando | Ofertas especiais, contato proativo |
| **Em Risco** | R:1-2, F:3-5, M:3-5 | Eram bons clientes mas pararam de comprar | Contato urgente, desconto reativação |
| **Não Perder** | R:1, F:4-5, M:4-5 | Melhores clientes que não compram há muito tempo | Ação imediata, contato pessoal |
| **Hibernando** | R:1-2, F:1-2, M:1-2 | Inativos há muito tempo, baixo valor | E-mail de reativação, avaliar custo de manutenção |
| **Perdidos** | R:1, F:1, M:1 | Clientes efetivamente perdidos | Campanha final de reativação ou reclassificar |

**Implementação:**
```sql
-- Calcular R, F, M por cliente
WITH rfm_base AS (
  SELECT
    cliente_id,
    (CURRENT_DATE - MAX(data_emissao)::date) AS recencia_dias,
    COUNT(*) AS frequencia,
    SUM(valor_total) AS monetario
  FROM pedidos_venda
  WHERE status NOT IN ('Cancelado', 'Rascunho')
    AND data_emissao >= CURRENT_DATE - INTERVAL '12 months'
  GROUP BY cliente_id
),
rfm_scores AS (
  SELECT
    cliente_id,
    recencia_dias, frequencia, monetario,
    NTILE(5) OVER (ORDER BY recencia_dias DESC) AS r_score,  -- Menor recência = melhor
    NTILE(5) OVER (ORDER BY frequencia ASC) AS f_score,
    NTILE(5) OVER (ORDER BY monetario ASC) AS m_score
  FROM rfm_base
)
SELECT
  cliente_id, recencia_dias, frequencia, monetario,
  r_score, f_score, m_score,
  CONCAT(r_score, f_score, m_score) AS rfm_segment,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Campeões'
    WHEN r_score >= 3 AND f_score >= 4 THEN 'Fiéis'
    WHEN r_score >= 4 AND f_score <= 2 THEN 'Novos'
    WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'Em Risco'
    WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'Não Perder'
    WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2 THEN 'Perdidos'
    ELSE 'Precisam Atenção'
  END AS segmento
FROM rfm_scores;
```

### 6.3 Análise de Sazonalidade

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Identificação de padrões recorrentes e previsíveis nas vendas ao longo do ano |
| **Objetivo** | Otimizar estoque, planejamento de compras, campanhas, contratação de pessoal |
| **Método** | Cálculo de índice de sazonalidade por mês/semana |

**Índice de Sazonalidade:**
```
Índice(Mês) = Média de Vendas do Mês (todos os anos) / Média Geral Mensal * 100

Exemplo:
  Média geral mensal = R$ 100.000
  Média de dezembro (todos os anos) = R$ 180.000
  Índice dezembro = 180.000 / 100.000 * 100 = 180 (pico sazonal)

  Índice > 100 = Mês acima da média (pico)
  Índice < 100 = Mês abaixo da média (vale)
  Índice = 100 = Mês na média
```

**Fatores de Sazonalidade Relevantes para Ótica:**
- Janeiro/Fevereiro: volta às aulas (óculos infantis, lentes)
- Maio: Dia das Mães
- Junho: Dia dos Namorados
- Agosto: Dia dos Pais
- Novembro: Black Friday
- Dezembro: Natal, festas (óculos de sol, armações premium)
- Verão: óculos de sol

**Visualização:** Gráfico de linha sobreposta (vendas por mês, cada ano uma linha) + Índice de sazonalidade em barras

### 6.4 Análise Cross-sell / Up-sell

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Identificação de oportunidades para vender produtos complementares (cross-sell) ou versões superiores (up-sell) |
| **Cross-sell** | "Quem comprou X também comprou Y" — análise de associação de produtos em pedidos |
| **Up-sell** | Clientes que compraram produto na faixa A e podem migrar para faixa A+ |

**Métricas:**

| Métrica | Cálculo |
|---------|---------|
| **Attachment Rate** | % de clientes que compraram produto complementar junto ao principal |
| **Up-sell Rate** | % de clientes que migraram para produto de maior valor |
| **Receita Incremental** | Receita adicional gerada por cross-sell/up-sell |
| **Market Basket Size** | Número médio de itens por pedido |

**Implementação Cross-sell (Associação de Produtos):**
```sql
-- Encontrar pares de produtos frequentemente comprados juntos
SELECT
  a.produto_id AS produto_a,
  b.produto_id AS produto_b,
  COUNT(DISTINCT a.pedido_venda_id) AS pedidos_juntos,
  COUNT(DISTINCT a.pedido_venda_id)::FLOAT /
    (SELECT COUNT(DISTINCT pedido_venda_id)
     FROM pedido_venda_itens
     WHERE produto_id = a.produto_id) AS support,
  COUNT(DISTINCT a.pedido_venda_id)::FLOAT /
    NULLIF((SELECT COUNT(DISTINCT pedido_venda_id)
     FROM pedido_venda_itens
     WHERE produto_id = a.produto_id), 0) AS confidence
FROM pedido_venda_itens a
JOIN pedido_venda_itens b ON a.pedido_venda_id = b.pedido_venda_id
  AND a.produto_id < b.produto_id
GROUP BY a.produto_id, b.produto_id
HAVING COUNT(DISTINCT a.pedido_venda_id) >= 5
ORDER BY pedidos_juntos DESC;
```

**Exemplos no Setor Óptico:**
- Cross-sell: Armação + Lentes + Estojo + Spray de limpeza + Flanela
- Up-sell: Lente básica → Lente antirreflexo → Lente multifocal progressiva
- Cross-sell: Óculos de grau + Óculos de sol de grau

### 6.5 Indicadores de Churn (Predição de Perda de Clientes)

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Identificação de sinais precoces de que um cliente pode parar de comprar |
| **Objetivo** | Agir proativamente para reter clientes em risco antes de perdê-los |

**Indicadores de Alerta Precoce (Early Warning Signs):**

| Indicador | Cálculo | Limiar de Alerta |
|-----------|---------|------------------|
| **Declínio de frequência** | Frequência atual / Frequência histórica | < 50% da frequência habitual |
| **Aumento do intervalo entre compras** | Intervalo atual > 2x intervalo médio histórico | > 2x a média |
| **Redução do ticket médio** | Ticket atual / Ticket histórico | < 60% do ticket habitual |
| **Aumento de devoluções** | Taxa devolução recente vs histórica | > 2x a taxa normal |
| **Reclamações/suporte** | Tickets de suporte recentes | > 3 tickets sem resolução |
| **Dias desde última compra** | DataAtual - DataÚltimaCompra | > Intervalo médio + 2 desvios padrão |

**Score de Risco de Churn:**
```
Churn Risk Score = (W1 * Fator_Recência) + (W2 * Fator_Frequência) +
                   (W3 * Fator_Monetário) + (W4 * Fator_Devolução)

Onde:
- W1, W2, W3, W4 = Pesos (ex: 0.35, 0.25, 0.25, 0.15)
- Fator_Recência = Normalizado(dias desde última compra), 0-1
- Fator_Frequência = 1 - Normalizado(frequência atual / média), 0-1
- Fator_Monetário = 1 - Normalizado(ticket atual / média), 0-1
- Fator_Devolução = Normalizado(taxa devolução / taxa normal), 0-1

Score 0.0 - 0.3 = Baixo risco (verde)
Score 0.3 - 0.6 = Risco moderado (amarelo)
Score 0.6 - 0.8 = Alto risco (laranja)
Score 0.8 - 1.0 = Risco crítico (vermelho)
```

### 6.6 Customer Lifetime Value (CLV / LTV)

| Aspecto | Detalhe |
|---------|---------|
| **Definição** | Valor total estimado que um cliente gerará ao longo de toda sua relação com a empresa |
| **Fórmula Básica** | CLV = Ticket Médio * Frequência de Compra (anual) * Tempo de Vida Médio (anos) |
| **Fórmula com Margem** | CLV = (Ticket Médio * Margem Bruta %) * Frequência Anual * Tempo de Vida - CAC |

**Métodos de Cálculo:**

| Método | Fórmula | Quando Usar |
|--------|---------|-------------|
| **Histórico Simples** | Σ(Receita do Cliente desde o primeiro pedido) | Clientes com longo histórico |
| **Preditivo Básico** | Ticket Médio * Freq. Anual * Vida Média | Previsão geral |
| **Preditivo com Margem** | (Ticket * Margem%) * Freq. Anual * Vida Média - CAC | Análise de rentabilidade |
| **Modelo com Desconto** | Σ(Receita Anual * (1 + taxa crescimento)^n / (1 + taxa desconto)^n) | Análise financeira avançada |

**Exemplo Prático (Ótica):**
```
Ticket Médio = R$ 850 (armação + lentes)
Frequência Anual = 0.5 (troca óculos a cada 2 anos)
Margem Bruta = 55%
Tempo de Vida = 15 anos (cliente fiel)
CAC = R$ 80

CLV = (850 * 0.55) * 0.5 * 15 - 80
CLV = 467.50 * 0.5 * 15 - 80
CLV = R$ 3.426,25

Relação CLV/CAC = 3.426,25 / 80 = 42,8x (excelente)
```

---

## 7. Integração com Outros Módulos

### 7.1 Integração Vendas ↔ Estoque

| Evento | Ação no Estoque |
|--------|-----------------|
| Pedido aprovado | Reservar itens (ReservaEstoque) |
| Pedido cancelado | Liberar reservas |
| Entrega confirmada | Gerar MovimentacaoEstoque (Saída) + Baixar EstoqueSaldo |
| Devolução recebida | Gerar MovimentacaoEstoque (Entrada) + Atualizar EstoqueSaldo |
| Verificação na criação do pedido | Validar disponibilidade em EstoqueSaldo |

### 7.2 Integração Vendas ↔ Financeiro (Futuro)

| Evento | Ação no Financeiro |
|--------|-------------------|
| Faturamento autorizado | Gerar parcelas em Contas a Receber |
| Devolução creditada | Gerar crédito / estorno no Contas a Receber |
| Comissão aprovada | Gerar parcelas em Contas a Pagar |
| Baixa de pagamento | Atualizar status do faturamento |
| Cancelamento de NF | Estornar parcelas |

### 7.3 Integração Vendas ↔ Compras

| Evento | Ação em Compras |
|--------|-----------------|
| Pedido de venda sem estoque | Gerar sugestão de Requisição de Compra |
| Análise de demanda | Alimentar forecast de compras |
| Devolução ao fornecedor | Originada por devolução do cliente (defeito) |

### 7.4 Integração Vendas ↔ Fiscal (Futuro)

| Evento | Ação Fiscal |
|--------|-------------|
| Faturamento | Emissão NF-e via SEFAZ (webservice ou API terceira) |
| Cancelamento NF | Evento de cancelamento na SEFAZ (até 24h) |
| Devolução | Emissão NF de entrada (devolução) |
| Carta de Correção | CC-e para correção de dados da NF |
| Inutilização | Inutilização de faixa de numeração |

---

## 8. Requisitos Fiscais Brasileiros

### 8.1 NF-e (Nota Fiscal Eletrônica — Modelo 55)

#### Estrutura XML (Layout 4.00)

```
<nfeProc>
  <NFe>
    <infNFe versao="4.00" Id="NFe...44digitos...">
      <ide>        — Identificação da NF-e
      <emit>       — Dados do emitente
      <dest>       — Dados do destinatário
      <retirada>   — Endereço de retirada (se diferente)
      <entrega>    — Endereço de entrega (se diferente)
      <det>        — Itens (1..990)
        <prod>     — Produto/serviço
        <imposto>  — Impostos por item
          <ICMS>   — Grupo ICMS
          <IPI>    — Grupo IPI
          <PIS>    — Grupo PIS
          <COFINS> — Grupo COFINS
      <total>      — Totalizadores
        <ICMSTot>  — Totais dos impostos
      <transp>     — Dados de transporte
      <cobr>       — Cobrança/Parcelas
        <fat>      — Fatura
        <dup>      — Duplicatas (parcelas)
      <pag>        — Informações de pagamento
        <detPag>   — Detalhe do pagamento
      <infAdic>    — Informações adicionais
    </infNFe>
    <Signature>    — Assinatura digital (ICP-Brasil)
  </NFe>
  <protNFe>        — Protocolo de autorização SEFAZ
</nfeProc>
```

#### Grupo `<ide>` — Campos Obrigatórios

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `cUF` | int(2) | Código UF (IBGE) |
| `natOp` | string(60) | Natureza da operação ("Venda", "Remessa", etc.) |
| `mod` | int(2) | Modelo: 55 (NF-e) ou 65 (NFC-e) |
| `serie` | int(3) | Série (0-999) |
| `nNF` | int(9) | Número sequencial |
| `dhEmi` | datetime | Data/hora de emissão |
| `tpNF` | int(1) | 0=Entrada, 1=Saída |
| `idDest` | int(1) | 1=Interna, 2=Interestadual, 3=Exterior |
| `finNFe` | int(1) | 1=Normal, 2=Complementar, 3=Ajuste, 4=Devolução |
| `indFinal` | int(1) | 0=Não, 1=Consumidor Final |
| `indPres` | int(1) | 0=N/A, 1=Presencial, 2=Internet, 3=Telemarketing, 9=Outros |
| `tpEmis` | int(1) | 1=Normal, 4=EPEC, 9=Offline |
| `tpAmb` | int(1) | 1=Produção, 2=Homologação |
| `CRT` | int(1) | 1=Simples Nacional, 2=SN excesso, 3=Regime Normal, 4=MEI |

#### Chave de Acesso (44 dígitos)

| Posição | Tamanho | Campo | Descrição |
|---------|---------|-------|-----------|
| 1-2 | 2 | cUF | Código do estado |
| 3-6 | 4 | AAMM | Ano e mês de emissão |
| 7-20 | 14 | CNPJ | CNPJ do emitente |
| 21-22 | 2 | mod | Modelo (55 ou 65) |
| 23-25 | 3 | serie | Série |
| 26-34 | 9 | nNF | Número |
| 35 | 1 | tpEmis | Tipo de emissão |
| 36-43 | 8 | cNF | Código numérico aleatório |
| 44 | 1 | cDV | Dígito verificador (mod 11) |

#### Status da NF-e

| Status | Código | Descrição | Regras |
|--------|--------|-----------|--------|
| **Autorizada** | 100 | Autorizada para uso | Mercadoria pode transitar |
| **Cancelada** | 101/135 | Cancelada | Até 24h, mercadoria não expedida |
| **Denegada** | 110/301/302 | Uso denegado | Irregularidade fiscal, número não reutilizável |
| **Inutilizada** | 102 | Inutilizada | Para gaps na sequência numérica |
| **Rejeitada** | Vários | Rejeitada | Erros de validação, pode reenviar |

#### Eventos Pós-Autorização

| Evento | Descrição |
|--------|-----------|
| Cancelamento | Cancelar NF-e (evento, até 24h) |
| Carta de Correção (CC-e) | Corrigir campos não financeiros (até 20 CC-e por NF-e) |
| Ciência da Emissão | Destinatário toma ciência |
| Confirmação da Operação | Destinatário confirma (bloqueia cancelamento) |
| Desconhecimento da Operação | Destinatário desconhece |
| Operação não Realizada | Destinatário informa que operação não ocorreu |

### 8.2 NFC-e (Nota Fiscal de Consumidor Eletrônica — Modelo 65)

| Aspecto | NF-e (Modelo 55) | NFC-e (Modelo 65) |
|---------|-------------------|-------------------|
| **Público** | B2B e B2C (não presencial) | B2C varejo (presencial/delivery) |
| **CPF/CNPJ destino** | CNPJ ou CPF obrigatório | CPF opcional; CNPJ **proibido desde nov/2025** |
| **Operações** | Interna, interestadual, internacional | **Somente interna** (mesmo estado) |
| **DANFE** | A4 completo | Simplificado (impressora térmica 80mm, QR Code) |
| **Contingência** | EPEC, FS-DA, SVC-AN, SVC-RS | **Offline**, EPEC |
| **Transmissão** | Síncrona ou Assíncrona | **Somente síncrona** |

#### Formas de Pagamento (`<pag>`)

| Código (tPag) | Forma de Pagamento |
|---------------|--------------------|
| 01 | Dinheiro |
| 02 | Cheque |
| 03 | Cartão de Crédito |
| 04 | Cartão de Débito |
| 05 | Crédito Loja |
| 10 | Vale Alimentação |
| 12 | Vale Presente |
| 15 | Boleto Bancário |
| 16 | Depósito Bancário |
| 17 | Pagamento Instantâneo (PIX) |
| 18 | Transferência Bancária / Carteira Digital |
| 90 | Sem Pagamento |
| 99 | Outros |

### 8.3 Cálculos Tributários

#### ICMS

```
Base ICMS = Valor Produto + Frete + Seguro + Outras Despesas - Desconto
ICMS = Base ICMS x Alíquota ICMS
```

**Alíquotas interestaduais:**

| Origem | Destino | Alíquota |
|--------|---------|----------|
| Sul/Sudeste (exceto ES) | Norte/Nordeste/Centro-Oeste/ES | **7%** |
| Norte/Nordeste/Centro-Oeste/ES | Qualquer estado | **12%** |
| Sul/Sudeste (exceto ES) | Sul/Sudeste (exceto ES) | **12%** |
| Qualquer | Qualquer (produtos importados, CI > 40%) | **4%** |

#### ICMS-ST (Substituição Tributária)

```
Base ICMS-ST = (Valor Produto + IPI + Frete + Seguro + Outras Despesas - Desconto) x (1 + MVA/100)
ICMS-ST = (Base ICMS-ST x Alíquota Interna) - ICMS Próprio
```

#### DIFAL (Diferencial de Alíquota — EC 87/2015)

```
DIFAL = Valor da Operação x (Alíquota Interna Destino - Alíquota Interestadual)
```

Desde 2019: 100% do DIFAL vai para o estado de destino. Para consumidor final **não contribuinte**, o **vendedor** calcula e recolhe.

#### IPI (calculado "por fora")

```
Base IPI = Valor do Produto + Frete + Seguro + Outras Despesas
IPI = Base IPI x Alíquota IPI
```

#### PIS/COFINS

| Regime | PIS | COFINS | Observação |
|--------|-----|--------|------------|
| Cumulativo (Lucro Presumido) | 0,65% | 3,00% | Sem créditos |
| Não Cumulativo (Lucro Real) | 1,65% | 7,60% | Com créditos de insumos |

### 8.4 CST ICMS (Código de Situação Tributária)

**Tabela A — Origem da Mercadoria:**

| Código | Descrição |
|--------|-----------|
| 0 | Nacional, exceto indicadas nos códigos 3 a 5 e 8 |
| 1 | Estrangeira - Importação direta |
| 2 | Estrangeira - Adquirida no mercado interno |
| 3 | Nacional - Conteúdo de Importação superior a 40% e ≤ 70% |
| 4 | Nacional - Produção conforme PPB |
| 5 | Nacional - Conteúdo de Importação ≤ 40% |
| 6 | Estrangeira - Importação direta, sem similar nacional (CAMEX) |
| 7 | Estrangeira - Adquirida mercado interno, sem similar nacional (CAMEX) |
| 8 | Nacional - Conteúdo de Importação superior a 70% |

**Tabela B — Tributação ICMS (Regime Normal):**

| Código | Descrição |
|--------|-----------|
| 00 | Tributada integralmente |
| 10 | Tributada com cobrança do ICMS por ST |
| 20 | Com redução de base de cálculo |
| 30 | Isenta ou não tributada com cobrança do ICMS por ST |
| 40 | Isenta |
| 41 | Não tributada |
| 50 | Suspensão |
| 51 | Diferimento |
| 60 | ICMS cobrado anteriormente por ST |
| 70 | Com redução de base de cálculo e cobrança do ICMS por ST |
| 90 | Outras |

### 8.5 CSOSN (Simples Nacional)

| Código | Descrição | Permite Crédito? |
|--------|-----------|------------------|
| 101 | Tributada com permissão de crédito | Sim |
| 102 | Tributada sem permissão de crédito | Não |
| 103 | Isenção do ICMS para faixa de receita bruta | N/A |
| 201 | Tributada com crédito e cobrança de ICMS por ST | Sim + ST |
| 202 | Tributada sem crédito e cobrança de ICMS por ST | Não + ST |
| 300 | Imune | N/A |
| 400 | Não tributada pelo Simples Nacional | N/A |
| 500 | ICMS cobrado anteriormente por ST | N/A |
| 900 | Outros | Variável |

### 8.6 CFOP de Saída (Vendas) — Completo

**5.xxx = Interna (mesmo estado) | 6.xxx = Interestadual | 7.xxx = Exportação**

#### Vendas Normais (5.1xx / 6.1xx)

| CFOP | Descrição |
|------|-----------|
| 5.101 / 6.101 / 7.101 | Venda de produção do estabelecimento |
| 5.102 / 6.102 / 7.102 | Venda de mercadoria adquirida ou recebida de terceiros |
| 5.103 / 6.103 | Venda de produção efetuada fora do estabelecimento |
| 5.104 / 6.104 | Venda de mercadoria de terceiros, efetuada fora do estabelecimento |

#### Venda para Entrega Futura

| CFOP | Descrição |
|------|-----------|
| 5.116 / 6.116 | Venda de produção originada de encomenda para entrega futura |
| 5.117 / 6.117 | Venda de mercadoria de terceiros originada de entrega futura |
| 5.922 / 6.922 | Simples faturamento decorrente de venda para entrega futura |

#### Venda à Ordem (Triangular)

| CFOP | Descrição |
|------|-----------|
| 5.118 / 6.118 | Venda entregue ao destinatário por conta e ordem do adquirente originário |
| 5.119 / 6.119 | Venda de mercadoria de terceiros entregue por conta e ordem |
| 5.120 / 6.120 | Venda entregue pelo vendedor remetente, em venda à ordem |
| 5.923 / 6.923 | Remessa de mercadoria por conta e ordem de terceiros |

#### Consignação

| CFOP | Descrição |
|------|-----------|
| 5.113 / 6.113 | Venda de produção remetida anteriormente em consignação |
| 5.114 / 6.114 | Venda de mercadoria de terceiros em consignação |
| 5.917 / 6.917 | Remessa de mercadoria em consignação mercantil ou industrial |
| 5.918 / 6.918 | Devolução de mercadoria recebida em consignação |
| 5.919 / 6.919 | Devolução simbólica de mercadoria vendida em consignação |

#### Vendas com ST (5.4xx / 6.4xx)

| CFOP | Descrição |
|------|-----------|
| 5.401 / 6.401 | Venda de produção com ST (contribuinte substituto) |
| 5.403 / 6.403 | Venda de mercadoria de terceiros com ST (substituto) |
| 5.405 | Venda de mercadoria com ST (contribuinte substituído) |

#### Remessas Especiais (5.9xx / 6.9xx)

| CFOP | Descrição |
|------|-----------|
| 5.904 / 6.904 | Remessa para venda fora do estabelecimento |
| 5.910 / 6.910 | Remessa em bonificação, doação ou brinde |
| 5.911 / 6.911 | Remessa de amostra grátis |
| 5.912 / 6.912 | Remessa para demonstração, mostruário ou treinamento |
| 5.913 / 6.913 | Retorno de mercadoria recebida para demonstração |
| 5.949 / 6.949 | Outra saída não especificada |

### 8.7 Tipos de Operação de Venda no Brasil

| Tipo de Operação | finNFe | # NF-e | CFOPs | Impacto Estoque | Impacto Financeiro |
|------------------|--------|--------|-------|-----------------|-------------------|
| Venda Normal | 1 | 1 | 5.1xx/6.1xx | Baixa | Receita |
| Entrega Futura (faturamento) | 1 | 1 | 5.922/6.922 | Nenhum | Receita |
| Entrega Futura (remessa) | 1 | 1 | 5.116/6.116 | Baixa | Nenhum |
| Venda à Ordem (venda) | 1 | 1 | 5.118/6.118 | Nenhum | Receita |
| Venda à Ordem (remessa) | 1 | 1 | 5.923/6.923 | Baixa | Nenhum |
| Demonstração (envio) | 1 | 1 | 5.912/6.912 | Baixa* | Nenhum |
| Demonstração (retorno) | 1 | 1 | 5.913/6.913 | Entrada* | Nenhum |
| Consignação (envio) | 1 | 1 | 5.917/6.917 | Baixa* | Nenhum |
| Consignação (venda efetiva) | 1 | 1 | 5.113/6.113 | Nenhum | Receita |
| Bonificação | 1 | 1 | 5.910/6.910 | Baixa | Nenhum (custo) |
| NF-e Complementar | 2 | 1 | Mesmo da original | Nenhum | Ajuste |
| NF-e Devolução | 4 | 1 | 5.201-5.209 | Entrada | Crédito |

*Estoque marcado com asterisco usa contas de estoque transitório/consignação.*

### 8.8 Regime Tributário e Impacto

| Regime | ICMS | IPI | PIS/COFINS | Impacto no Módulo |
|--------|------|-----|------------|-------------------|
| **Simples Nacional** | CSOSN (101, 102, 103...) | Não destaca | Não destaca | DAS único, CST simplificado |
| **Lucro Presumido** | CST normal (00, 10, 20...) | Se industrial | Cumulativo (0,65% + 3%) | Cálculo por item |
| **Lucro Real** | CST normal | Se industrial | Não cumulativo (1,65% + 7,6%) | Cálculo complexo com créditos |

### 8.9 SPED Fiscal — Blocos Relacionados a Vendas

| Bloco | Conteúdo | Registros Principais |
|-------|----------|---------------------|
| **C** | Documentos Fiscais de Mercadorias | C100 (cabeçalho NF-e), C170 (itens), C190 (resumo analítico por CST+CFOP+Alíquota) |
| **E** | Apuração ICMS e IPI | E100 (período), E110 (apuração operações próprias), E200/E210 (apuração ST) |
| **H** | Inventário Físico | H010 (itens do inventário) |
| **K** | Controle de Produção/Estoque | K200 (estoque escriturado) |

### 8.10 Reforma Tributária 2026

A partir de 2026, novos impostos estão sendo introduzidos:
- **IBS** (Imposto sobre Bens e Serviços) — substitui ICMS e ISS
- **CBS** (Contribuição sobre Bens e Serviços) — substitui PIS e COFINS
- **IS** (Imposto Seletivo) — sobre bens específicos (tabaco, álcool, etc.)

O sistema deve estar preparado para **tributação dual** (impostos antigos + novos) durante o período de transição (2026-2033).

---

## 9. Especificidades do Setor Óptico

### 9.1 Fluxo de Venda Óptica (Diferencial)

```
Atendimento/Recepção
    ↓
Exame de Vista (Prescrição / Receita)
    ↓
Escolha da Armação (Provar modelos)
    ↓
Escolha das Lentes (Tipo, Tratamento, Material)
    ↓
Orçamento (Armação + Lente + Tratamentos + Acessórios)
    ↓
Pedido de Venda (confirmado)
    ↓
Pedido ao Laboratório (se lente sob medida → surfaçagem)
    ↓
Recebimento do Laboratório
    ↓
Montagem (encaixar lente na armação)
    ↓
Conferência / Controle de Qualidade
    ↓
Entrega ao Cliente (com ajuste de armação)
    ↓
Pós-venda (recall para próximo exame, garantia)
```

### 9.2 Entidades Específicas (Futuras — Camada Vertical)

| Entidade | Descrição |
|----------|-----------|
| **Receita/Prescricao** | Dados do exame: OD/OE, Esférico, Cilíndrico, Eixo, Adição, DP, Altura |
| **PedidoLaboratorio** | Pedido de surfaçagem enviado ao laboratório óptico |
| **OrdemServico** | Ordem de serviço interna (montagem, reparo, ajuste) |
| **Garantia** | Registro de garantia de armação e lente |
| **RecallExame** | Agenda de retorno para exame (anual/bianual) |

### 9.3 Características de Venda Óptica no ERP Core

| Característica | Como Atender no ERP Genérico |
|----------------|------------------------------|
| Venda com múltiplos componentes (armação + lentes + acessórios) | Itens do pedido com diferentes categorias/tipos |
| Prazo de entrega variável (lente pronta vs sob medida) | Campo DataEntregaPrevista por item |
| Pedido dependente de laboratório externo | Status EmSeparacao com sub-status (AguardandoLaboratorio) |
| Garantia por componente | Integração com módulo de garantia (futuro) |
| Receita médica vinculada | Campo de observação ou FK para Receita (futuro) |
| Alto índice de personalização | Campos de observação + atributos flexíveis |

---

## 10. Modelos de Comissão Detalhados

### 10.1 Tipos de Cálculo

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| **Percentual Fixo** | Percentual único sobre toda a base | 5% sobre receita líquida |
| **Escalonada (Tiered)** | Percentuais crescentes por faixa de atingimento | Até 80% meta = 3%, 80-100% = 5%, >100% = 7% |
| **Por Produto/Categoria** | Percentuais diferentes por tipo de produto | Armações = 4%, Lentes = 6%, Acessórios = 3% |
| **Por Margem** | Comissão sobre a margem bruta (não sobre receita) | 10% da margem bruta do pedido |
| **Mista** | Base fixa + variável por atingimento | R$ 1.500 fixo + 3% sobre vendas acima da meta |
| **Por Canal** | Percentuais diferentes por canal de venda | Loja = 5%, E-commerce = 2%, Representante = 8% |

### 10.2 Base de Cálculo

| Base | Quando Usar | Vantagem |
|------|-------------|----------|
| **Receita Bruta** | Simplicidade | Fácil de calcular e entender |
| **Receita Líquida** | Descontos relevantes | Evita comissão sobre descontos |
| **Margem Bruta** | Rentabilidade importa | Alinha vendedor com lucratividade |
| **Margem Líquida** | Controle total de custos | Mais justo, mais complexo |
| **Valor Faturado** | Garantia de recebimento | Comissão após emissão da NF |
| **Valor Recebido** | Risco de inadimplência | Comissão apenas após pagamento |

### 10.3 Exemplo de Tabela Escalonada

| Faixa de Atingimento | Percentual de Comissão |
|----------------------|----------------------|
| 0% a 79% da meta | 3,0% |
| 80% a 99% da meta | 5,0% |
| 100% a 119% da meta | 7,0% |
| 120% ou mais da meta | 10,0% |

**Cálculo Exemplo:**
```
Meta mensal: R$ 50.000
Vendas realizadas: R$ 62.000
Atingimento: 124%

Comissão:
  Faixa 1 (0-79%): R$ 39.500 * 3% = R$ 1.185,00
  Faixa 2 (80-99%): R$ 10.000 * 5% = R$ 500,00
  Faixa 3 (100-119%): R$ 10.000 * 7% = R$ 700,00
  Faixa 4 (120%+): R$ 2.500 * 10% = R$ 250,00
  Total: R$ 2.635,00

OU (modelo não-escalonado, percentual da faixa atingida):
  R$ 62.000 * 10% = R$ 6.200,00
```

---

## 11. Fases de Implementação Recomendadas

### Fase 1 — MVP (Pedido de Venda Básico)

**Objetivo:** Fluxo completo de orçamento → pedido → entrega → faturamento.

**Entidades:**
- Orcamento + OrcamentoItem
- PedidoVenda + PedidoVendaItem
- EntregaVenda + EntregaVendaItem
- DevolucaoVenda + DevolucaoVendaItem

**Domínios:**
- FormaPagamento (8 seeds)
- CondicaoPagamentoVenda (12 seeds)
- MotivoDevolucaoVenda (8 seeds)
- MotivoCancelamento (6 seeds)
- CanalVenda (5 seeds)

**Funcionalidades:**
- [x] CRUD completo de Orçamento com workflow (Rascunho → Enviado → Aprovado → Convertido)
- [x] Conversão automática Orçamento → Pedido de Venda
- [x] CRUD completo de Pedido de Venda com workflow (Rascunho → Aprovado → EmSeparacao → Entregue → Faturado)
- [x] Verificação de disponibilidade no estoque ao aprovar pedido
- [x] Reserva automática de estoque ao aprovar pedido (integração Estoque)
- [x] Liberação de reserva ao cancelar
- [x] Entrega de mercadoria com geração de movimentação de estoque (saída)
- [x] Entrega parcial com backorder
- [x] Faturamento simples (sem emissão NF-e real — apenas registro)
- [x] Devolução de venda com recebimento e crédito
- [x] Retorno ao estoque (movimentação de entrada)

**Relatórios Fase 1 (3):**
- R01 — Vendas por Período
- R02 — Vendas por Cliente
- R11 — Carteira de Pedidos (Backlog)

**Dashboard Fase 1 (8 KPIs):**
- Faturamento do Período (KPI #1)
- Número de Pedidos (KPI #4)
- Ticket Médio (KPI #5)
- Valor em Carteira (KPI #8)
- Entregas Pendentes (KPI #13)
- Pedidos Atrasados (KPI #14)
- Vendas Mensais (gráfico BarChart 12 meses)
- Top 10 Clientes (tabela)

**Estimativa:** ~8-10 entidades, ~4-6 controllers, ~8-12 páginas frontend

---

### Fase 2 — Operacional (Tabela de Preço, Comissões, Métricas)

**Objetivo:** Gestão de preços, comissões e métricas operacionais.

**Entidades Novas:**
- TabelaPreco + TabelaPrecoItem
- ComissaoRegra + ComissaoRegraFaixa
- ComissaoVenda + ComissaoVendaParcela
- FaturamentoVenda + FaturamentoVendaItem (separação do faturamento como entidade própria)
- HistoricoPrecoVenda
- LogDescontoEspecial

**Domínios Novos:**
- TipoDesconto (6 seeds)

**Funcionalidades:**
- [x] CRUD de Tabelas de Preço com vigência e prioridade
- [x] Aplicação automática de tabela de preço no pedido (por cliente, grupo, região)
- [x] Acréscimo/desconto por condição de pagamento vinculada à tabela
- [x] CRUD de Regras de Comissão (percentual fixo e escalonada)
- [x] Cálculo automático de comissão ao faturar
- [x] Relatório de comissões por vendedor
- [x] Faturamento como entidade separada (preparação para NF-e)
- [x] Histórico de preços de venda
- [x] Log de descontos especiais (auditoria)
- [x] Aprovação de pedidos com alçada de desconto

**Relatórios Fase 2 (+7, total 10):**
- R03 — Vendas por Produto/Categoria
- R04 — Vendas por Vendedor/Representante
- R10 — Análise de Descontos
- R14 — Variação de Preços
- R15 — Devoluções de Venda
- R17 — Comissões por Vendedor
- R18 — Resumo de Comissões por Período

**Dashboard Fase 2 (+6 KPIs, total 14):**
- Margem Bruta (KPI #3)
- Taxa de Devoluções (KPI #9)
- Top 10 Produtos (KPI #12)
- Comissões do Período (KPI #15)
- Desconto Médio Concedido (KPI #17)
- Vendas por Canal (PieChart)

---

### Fase 3 — Avançado (Metas, Território, Pipeline)

**Objetivo:** Gestão de metas, territórios e análise avançada de pipeline.

**Entidades Novas:**
- MetaVenda + MetaVendaDetalhe
- AcompanhamentoMeta
- RegiaoVenda
- PedidoVendaAprovacao

**Funcionalidades:**
- [x] CRUD de Regiões de Venda / Territórios
- [x] CRUD de Metas de Vendas por vendedor, equipe e período
- [x] Acompanhamento automático de metas (atualização diária/semanal)
- [x] Workflow de aprovação de pedidos com alçada e log
- [x] Funil de vendas (orçamento → pedido → entrega → faturamento)
- [x] Previsão de vendas (forecast com média móvel e sazonalidade)

**Relatórios Fase 3 (+6, total 16):**
- R05 — Vendas por Região/Território
- R06 — Vendas por Canal
- R07 — Análise de Lucratividade / Margem
- R12 — Funil de Vendas / Conversão
- R13 — Previsão de Vendas / Forecast
- R16 — Cancelamentos de Pedidos

**Dashboard Fase 3 (+6 KPIs, total 20):**
- Taxa de Conversão (KPI #6)
- Meta vs Realizado (KPI #7)
- Prazo Médio de Entrega (KPI #10)
- Clientes Novos no Período (KPI #16)
- Pedidos por Vendedor (KPI #18)
- Orçamentos em Aberto (KPI #19)
- Funil de Conversão (gráfico FunnelChart)
- Performance Vendedores vs Meta (gráfico BarChart agrupado)

---

### Fase 4 — Analytics (RFM, Coorte, CLV, Churn, Curva ABC)

**Objetivo:** Inteligência comercial avançada e análises preditivas.

**Funcionalidades:**
- [x] Curva ABC de Clientes (classificação automática)
- [x] Curva ABC de Produtos (por receita, margem, quantidade)
- [x] Análise RFM com segmentação automática de clientes
- [x] Análise de Coorte (retenção por safra de aquisição)
- [x] Cálculo de CLV (Customer Lifetime Value)
- [x] Score de risco de churn
- [x] Análise de sazonalidade com índice mensal
- [x] Análise de cross-sell / up-sell (associação de produtos)
- [x] Ticket médio e frequência por dimensões

**Relatórios Fase 4 (+4, total 20):**
- R08 — Curva ABC de Clientes
- R09 — Curva ABC de Produtos
- R19 — Ticket Médio
- R20 — Frequência de Compra por Cliente

**Dashboard Fase 4 (+8 KPIs, total 28):**
- CLV médio (KPI #21)
- CAC (KPI #22)
- Relação CLV/CAC (KPI #23)
- Ciclo Médio de Vendas (KPI #24)
- Pipeline Coverage (KPI #25)
- Receita por Vendedor (KPI #26)
- Índice de Recorrência (KPI #27)
- Taxa de Cancelamento (KPI #20)

**Páginas Analytics (6):**
- RFM Analysis Page (tabela + gráfico de segmentos)
- Cohort Analysis Page (tabela triangular com heatmap)
- CLV Dashboard (distribuição, ranking, tendência)
- Churn Risk Page (lista de clientes em risco + score)
- Seasonality Analysis Page (índice mensal + sobreposição anos)
- Cross-sell / Up-sell Page (associação de produtos + recomendações)

---

## 12. Resumo de Totais

| Categoria | Fase 1 (MVP) | Fase 2 (Operacional) | Fase 3 (Avançado) | Fase 4 (Analytics) | **Total** |
|-----------|:---:|:---:|:---:|:---:|:---:|
| **Entidades novas** | 8 | 8 | 5 | 0 | **21** |
| **Domínios novos** | 5 | 1 | 1 | 0 | **7** |
| **Controllers** | 5 | 5 | 4 | 3 | **17** |
| **Relatórios** | 3 | 7 | 6 | 4 | **20** |
| **Dashboard KPIs** | 8 | 6 | 6 | 8 | **28** |
| **Páginas frontend** | ~12 | ~10 | ~10 | ~8 | **~40** |
| **Gráficos dashboard** | 2 | 1 | 2 | 3 | **8** |

---

## 13. Fontes e Referências

### ERPs de Referência
- [SAP S/4HANA SD (Sales and Distribution)](https://help.sap.com/doc/863abf53d25ab64ce10000000a174cb4/700_SFIN3E%20006/en-US/frameset.htm) — Standard SD Reports (MCTA, MCTC, MCTE, MCTK), Pricing Conditions, Commission Management
- [Oracle NetSuite — Sales Reports](https://docs.oracle.com/en/cloud/saas/netsuite/ns-online-help/chapter_N1101968.html) — Sales by Customer, by Item, by Sales Rep, Pipeline reports
- [Oracle Order Management](https://docs.oracle.com/cd/E26401_01/doc.122/e48842/T373258T377250.htm) — Order lifecycle, partial deliveries, backorder management
- [TOTVS Protheus SIGAFAT](https://bnlsolution.com.br/vendas-e-faturamento/) — Vendas e Faturamento, NF-e, Comissões
- [Microsoft Dynamics 365 Sales](https://www.randgroup.com/insights/microsoft/how-to-increase-cross-selling-and-upselling-with-dynamics-365-sales/) — Cross-sell/Up-sell, Pipeline, Territory Management
- [ERPNext Sales Module](https://erpnext.com/erp-guide/sales-system) — Quote → Order → Delivery → Invoice cycle
- [Odoo Sales](https://www.comstarusa.com/odoo-erp/sales-erp/) — Quotation, Sales Order, Delivery, Invoicing workflow

### KPIs e Métricas
- [NetSuite — 21 Sales KPIs](https://www.netsuite.com/portal/resource/articles/accounting/sales-kpis.shtml) — Comprehensive sales KPI list
- [NetSuite — Sales Metrics](https://www.netsuite.com/portal/resource/articles/accounting/sales-metrics.shtml) — 20 sales metrics explained
- [ThoughtSpot — Top 16 Sales Metrics](https://www.thoughtspot.com/data-trends/kpi/sales-metrics-kpis) — Sales metrics and KPIs for 2026
- [Improvado — Essential Sales Metrics](https://improvado.io/blog/sales-metrics) — Sales metrics and KPIs for performance tracking
- [HubSpot — Sales Metrics](https://blog.hubspot.com/sales/sales-metrics) — What to track, how to track, and why
- [Klipfolio — Sales Quota Attainment](https://www.klipfolio.com/resources/kpi-examples/sales/sales-quota-attainment) — Quota attainment KPI definition and calculation

### Analytics e Segmentação
- [CleverTap — RFM Analysis Guide](https://clevertap.com/blog/rfm-analysis/) — Comprehensive RFM implementation guide
- [Optimove — RFM Segmentation](https://www.optimove.com/resources/learning-center/rfm-segmentation) — RFM model marketing
- [Peel Insights — Cohort Analysis Guide](https://www.peelinsights.com/post/your-guide-to-cohort-analysis) — Customer retention cohort analysis
- [Mixpanel — Cohort Analysis](https://mixpanel.com/blog/cohort-analysis/) — Reducing churn through cohort analysis
- [NetSuite — Customer Lifetime Value](https://www.netsuite.com/portal/resource/articles/ecommerce/customer-lifetime-value-clv.shtml) — CLV calculation methods
- [HubSpot — CLV Calculation](https://blog.hubspot.com/service/how-to-calculate-customer-lifetime-value) — How to calculate CLV
- [Sigma Computing — Churn Prediction](https://www.sigmacomputing.com/blog/predict-customer-churn) — How to predict customer churn
- [Priceva — ABC Analysis](https://priceva.com/blog/abc-analysis) — Unlocking profit margins with ABC analysis

### Dashboard e Visualização
- [HubSpot — Sales Dashboard Examples](https://blog.hubspot.com/sales/sales-dashboard) — 13 examples + how to build
- [Klipfolio — Sales Performance Dashboard](https://www.klipfolio.com/resources/dashboard-examples/sales/sales-performance) — KPIs, examples, best practices
- [Tableau — Sales Dashboard Templates](https://www.tableau.com/dashboard/sales-dashboard-examples-and-templates) — 7 great examples

### Fiscal Brasileiro
- [Conta Azul — NF-e Campos](https://ajuda.contaazul.com/hc/pt-br/articles/7931903975693-NF-e-como-preencher-a-nota-fiscal-de-venda-produto) — Como preencher a NF-e
- [vhsys — Tabela CFOP Completa 2026](https://blog.vhsys.com.br/tabela-cfop-completa/) — CFOP completo com descrições
- [Focus NFe — CFOP](https://focusnfe.com.br/blog/o-que-e-o-codigo-de-natureza-de-operacao-ou-cfop/) — Explicação CFOP
- [Sistemas Nano — NF-e no ERP](https://www.sistemasnano.com.br/como-emitir-nfe-no-erp/) — Emissão de NF-e sem travar operação

### Setor Óptico
- [iVend — Optical Retail POS](https://ivend.com/retail-optical-pos-software/) — POS features for optical retail
- [ChainDrive — Optical ERP Software](https://chaindrive.com/tag/optical-erp-software/) — ERP solutions for optical retail
- [SerpentCS — Optical Management System](https://www.serpentcs.com/blog/optical-erp-514/optimize-your-vision-care-workflow-with-a-dedicated-optical-management-system-675) — Optical shop management with Odoo

### Comissões
- [Everstage — Sales Commission Guide](https://www.everstage.com/incentive-compensation/how-to-calculate-sales-commissions) — Complete guide to calculating sales commissions
- [CaptivateIQ — Commission Calculator](https://www.captivateiq.com/explainer/sales-commission-calculator) — Rates, percentages, and pay
- [ERP Connect — Commissions Management](https://erpconnectconsulting.com/products/commissions-management) — ERP commission management
- [ERP Software Blog — Commission Structures](https://erpsoftwareblog.com/2024/08/sales-commission-structures-advantages-and-disadvantages/) — Advantages and disadvantages of different structures

### Previsão e Pipeline
- [ERP Focus — Sales Forecasting](https://www.erpfocus.com/sales-demand-forecasting-erp.html) — Sales demand forecasting in ERP
- [DealHub — Sales Backlog](https://dealhub.io/glossary/sales-backlog/) — What is sales backlog
- [VLC Solutions — Sales Backlog](https://www.vlcsolutions.com/blog/sales-backlog-measure-optimize/) — Measure, optimize sales efficiency
- [First Page Sage — Funnel Conversion Benchmarks](https://firstpagesage.com/seo-blog/sales-funnel-conversion-rate-benchmarks-2025-report/) — 2026 conversion rate benchmarks

### Sazonalidade e Cross-sell
- [Inventory Planner — Seasonal Analysis](https://www.inventory-planner.com/seasonal-trend-analysis-retail/) — Seasonal and trend analysis in retail
- [Flieber — Seasonality Forecasting](https://www.flieber.com/blog/seasonality-forecasting-know-exactly-when-to-push-sales-and-when-not-to) — When to push sales
- [Solutyics — Cross-sell Analytics](https://solutyics.com/data-analytics-in-cross-selling-and-upselling-everything-you-need-to-know/) — Data analytics in cross-selling and upselling
- [Pecan AI — Cross-sell Opportunities](https://www.pecan.ai/blog/customer-cross-sell-opportunities-analytics/) — Uncovering opportunities with analytics
