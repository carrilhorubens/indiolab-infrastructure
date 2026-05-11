# Pesquisa: Módulo de Compras para ERP Genérico

> Levantamento completo de entidades, fluxos, relatórios, KPIs, boas práticas, requisitos fiscais brasileiros e especificidades do setor óptico para implementação do módulo de Compras no OpticalCore ERP.
> Referências: SAP S/4HANA (MM), Oracle Procurement Cloud, Odoo 19, TOTVS Protheus (SIGACOM), Microsoft Dynamics 365, ERPNext, NetSuite.

---

## 1. Entidades Propostas

### 1.1 Dados Mestres (6 entidades)

| Entidade | Descrição | Schema |
|----------|-----------|--------|
| **Fornecedor** | Extensão de Pessoa com dados de qualificação, scoring, segmentação e status de aprovação | Tenant |
| **ContratoCompra** | Acordos e contratos com fornecedores (blanket PO, preços, volumes, vigência) | Tenant |
| **ContratoCompraItem** | Itens do contrato com preços, quantidades e descontos acordados | Tenant |
| **CategoriaCompra** | Taxonomia de gastos para classificação e análise de spend | Tenant |
| **FluxoAprovacao** | Definição de workflows de aprovação (níveis, alçadas, delegações) | Tenant |
| **NivelAprovacao** | Níveis individuais dentro de um fluxo de aprovação | Tenant |

### 1.2 Dados Transacionais — Ciclo Procure-to-Pay (10 entidades)

| Entidade | Descrição | Referência ERP |
|----------|-----------|----------------|
| **RequisicaoCompra** | Requisição interna de compra (documento não vinculante) | SAP: Purchase Requisition / Protheus: Solicitação de Compra (SC) / Dynamics 365: Purchase Requisition |
| **RequisicaoCompraItem** | Itens da requisição de compra | — |
| **Cotacao** | Solicitação de cotação (RFQ) enviada a fornecedores | SAP: RFQ / Protheus: Cotação / ERPNext: Request for Quotation |
| **CotacaoFornecedor** | Resposta de um fornecedor específico a uma cotação | SAP: Quotation / ERPNext: Supplier Quotation |
| **CotacaoFornecedorItem** | Itens da resposta do fornecedor (preço, prazo, condições) | — |
| **OrdemCompra** | Pedido de compra formal (documento vinculante) | SAP: Purchase Order / Protheus: Pedido de Compra (PC) / Oracle: PO_HEADERS_ALL |
| **OrdemCompraItem** | Itens do pedido de compra | SAP: PO Item / Oracle: PO_LINES_ALL |
| **RecebimentoMercadoria** | Nota de recebimento de mercadorias (GRN) | SAP: Goods Receipt / Oracle: RCV_SHIPMENT_HEADERS / Protheus: Documento de Entrada |
| **RecebimentoMercadoriaItem** | Itens recebidos com conferência de quantidade/qualidade | SAP: GR Item / Oracle: RCV_TRANSACTIONS |
| **DevolucaoCompra** | Devolução de mercadoria ao fornecedor | SAP: Return PO / Protheus: Devolução de Compra |
| **DevolucaoCompraItem** | Itens da devolução com motivo e quantidade | — |

### 1.3 Dados de Suporte (4 entidades)

| Entidade | Descrição |
|----------|-----------|
| **AprovacaoHistorico** | Log de todas as aprovações/rejeições (auditoria) |
| **AvaliacaoFornecedor** | Scorecard de avaliação de fornecedor (periódica) |
| **AvaliacaoFornecedorCriterio** | Critérios individuais da avaliação com nota e peso |
| **HistoricoPreco** | Histórico de preços por produto/fornecedor para análise de tendências |

### 1.4 Domínios/Lookup (novas)

| Entidade | Descrição |
|----------|-----------|
| **CondicaoPagamento** | Condições de pagamento (à vista, 30/60/90, etc.) |
| **ModalidadeFrete** | Tipos de frete (CIF, FOB, terceiros, sem frete) |
| **MotivoRequisicao** | Motivos para requisição de compra (reposição, projeto, emergência) |
| **MotivoDevolucao** | Motivos para devolução ao fornecedor (defeito, divergência, avaria) |
| **StatusFornecedor** | Status do fornecedor (pendente, aprovado, suspenso, bloqueado) |

---

## 2. Campos Chave das Entidades

### 2.1 RequisicaoCompra (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| DataRequisicao | date | Data da requisição |
| SolicitanteId | FK | Usuário/funcionário solicitante |
| DepartamentoId | FK | Departamento solicitante |
| CentroCustoId | FK | Centro de custo |
| Prioridade | enum | Normal, Alta, Urgente |
| Justificativa | text | Justificativa da compra |
| DataNecessidade | date | Data em que os itens são necessários |
| Status | enum | Rascunho, PendenteAprovacao, Aprovada, Rejeitada, Convertida, Cancelada |
| AprovadorId | FK | Último aprovador (nullable) |
| DataAprovacao | timestamp | Data/hora da aprovação (nullable) |
| OrdemCompraId | FK | Ordem de compra gerada (nullable, preenchido após conversão) |
| Observacoes | text | Observações internas |

### 2.2 RequisicaoCompraItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| RequisicaoCompraId | FK | Cabeçalho |
| Sequencia | int | Ordem no documento |
| ProdutoId | FK | Produto solicitado |
| Descricao | string(500) | Descrição (pode ser item não cadastrado) |
| Quantidade | decimal(18,3) | Quantidade solicitada |
| UnidadeMedidaId | FK | Unidade de medida |
| PrecoEstimado | decimal(18,4) | Preço estimado unitário (nullable) |
| FornecedorSugeridoId | FK | Fornecedor sugerido (nullable) |
| Observacoes | text | Observações do item |

### 2.3 Cotacao (Cabeçalho — RFQ)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| RequisicaoCompraId | FK | Requisição de origem (nullable) |
| DataEmissao | date | Data de emissão |
| DataLimiteResposta | date | Prazo final para resposta dos fornecedores |
| Status | enum | Rascunho, Enviada, EmAnalise, Finalizada, Cancelada |
| Observacoes | text | Instruções aos fornecedores |
| CriterioAvaliacao | string(500) | Critérios de avaliação (preço, prazo, qualidade) |
| VencedorFornecedorId | FK | Fornecedor vencedor (nullable, preenchido após análise) |

### 2.4 CotacaoFornecedor (Resposta de um fornecedor)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| CotacaoId | FK | Cotação pai |
| FornecedorId | FK | Fornecedor que respondeu |
| DataResposta | date | Data da resposta |
| CondicaoPagamentoId | FK | Condição de pagamento oferecida |
| PrazoEntregaDias | int | Prazo de entrega em dias |
| ValidadeProposta | date | Validade da proposta |
| ValorTotal | decimal(18,4) | Valor total da proposta |
| ModalidadeFreteId | FK | Tipo de frete |
| ValorFrete | decimal(18,2) | Valor do frete |
| Observacoes | text | Observações do fornecedor |
| Pontuacao | decimal(5,2) | Pontuação na avaliação comparativa (nullable) |
| Selecionado | bool | Se este fornecedor foi o vencedor |

### 2.5 CotacaoFornecedorItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| CotacaoFornecedorId | FK | Resposta do fornecedor |
| ProdutoId | FK | Produto |
| Quantidade | decimal(18,3) | Quantidade ofertada |
| PrecoUnitario | decimal(18,4) | Preço unitário |
| DescontoPct | decimal(5,2) | Desconto percentual |
| PrazoEntregaDias | int | Prazo específico deste item |
| Observacoes | text | Observações |

### 2.6 OrdemCompra (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| FornecedorId | FK | Fornecedor |
| RequisicaoCompraId | FK | Requisição de origem (nullable) |
| CotacaoId | FK | Cotação de origem (nullable) |
| ContratoCompraId | FK | Contrato vinculado (nullable, para blanket POs) |
| Tipo | enum | Normal, Urgente, Blanket (aberto), Planejado |
| Status | enum | Rascunho, PendenteAprovacao, Aprovada, Enviada, ParcialmenteRecebida, Recebida, Cancelada, Encerrada |
| DataEmissao | date | Data de emissão |
| DataPrevisaoEntrega | date | Data prevista de entrega |
| CondicaoPagamentoId | FK | Condição de pagamento |
| ModalidadeFreteId | FK | Tipo de frete (CIF, FOB) |
| EnderecoEntregaId | FK | Endereço de entrega |
| DepositoId | FK | Depósito de destino |
| CompradorId | FK | Comprador responsável |
| SubTotal | decimal(18,4) | Soma dos itens |
| DescontoTotal | decimal(18,4) | Desconto total |
| ValorFrete | decimal(18,4) | Valor do frete |
| ValorSeguro | decimal(18,4) | Valor do seguro |
| OutrasDespesas | decimal(18,4) | Outras despesas acessórias |
| ValorTotal | decimal(18,4) | Valor total da ordem |
| Moeda | string(3) | Moeda (BRL, USD, EUR) |
| TaxaCambio | decimal(18,6) | Taxa de câmbio (para moeda estrangeira) |
| Observacoes | text | Observações gerais |
| ObservacoesInternas | text | Observações internas (não visíveis ao fornecedor) |

### 2.7 OrdemCompraItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| OrdemCompraId | FK | Cabeçalho |
| Sequencia | int | Ordem no documento |
| ProdutoId | FK | Produto |
| Descricao | string(500) | Descrição do item |
| Quantidade | decimal(18,3) | Quantidade pedida |
| QuantidadeRecebida | decimal(18,3) | Quantidade já recebida (acumulada) |
| QuantidadeDevolvida | decimal(18,3) | Quantidade já devolvida |
| UnidadeMedidaId | FK | Unidade de medida |
| PrecoUnitario | decimal(18,4) | Preço unitário |
| DescontoPct | decimal(5,2) | Desconto percentual |
| DescontoValor | decimal(18,4) | Desconto em valor |
| ValorTotal | decimal(18,4) | Valor total do item |
| CFOP | string(4) | Código fiscal da operação (previsão) |
| NCM | string(10) | NCM do produto |
| DepositoId | FK | Depósito de destino específico (nullable, herda do cabeçalho) |
| LocalizacaoId | FK | Localização de destino (nullable) |
| DataPrevisaoEntrega | date | Previsão de entrega específica do item |
| Status | enum | Pendente, ParcialmenteRecebido, Recebido, Cancelado |
| Observacoes | text | Observações |

### 2.8 RecebimentoMercadoria (Cabeçalho — GRN)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| OrdemCompraId | FK | Ordem de compra vinculada |
| FornecedorId | FK | Fornecedor |
| DataRecebimento | timestamp | Data/hora do recebimento |
| NotaFiscalNumero | string(50) | Número da NF-e do fornecedor |
| NotaFiscalChave | string(44) | Chave de acesso da NF-e (44 dígitos) |
| NotaFiscalSerie | string(3) | Série da NF-e |
| NotaFiscalDataEmissao | date | Data de emissão da NF-e |
| DepositoId | FK | Depósito de recebimento |
| ResponsavelId | FK | Usuário que conferiu |
| TipoConferencia | enum | Normal, Cega (sem acesso à NF) |
| Status | enum | Pendente, EmConferencia, ConferenciaFinalizada, Aprovado, Rejeitado |
| ValorTotalNF | decimal(18,4) | Valor total da NF-e |
| Observacoes | text | Observações |

### 2.9 RecebimentoMercadoriaItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| RecebimentoMercadoriaId | FK | Cabeçalho |
| OrdemCompraItemId | FK | Item da OC vinculado |
| ProdutoId | FK | Produto |
| QuantidadeEsperada | decimal(18,3) | Quantidade conforme OC |
| QuantidadeRecebida | decimal(18,3) | Quantidade efetivamente recebida |
| QuantidadeRejeitada | decimal(18,3) | Quantidade rejeitada (avaria, defeito) |
| UnidadeMedidaId | FK | Unidade de medida |
| LoteId | FK | Lote (nullable, se produto controla lote) |
| NumeroSerieId | FK | Número de série (nullable) |
| DataValidade | date | Data de validade (nullable) |
| LocalizacaoId | FK | Localização de destino |
| PrecoUnitario | decimal(18,4) | Preço unitário conforme NF-e |
| CFOP | string(4) | CFOP da entrada |
| Status | enum | Pendente, Conferido, Aprovado, Rejeitado |
| MotivoRejeicao | text | Motivo da rejeição (nullable) |
| Observacoes | text | Observações |

### 2.10 DevolucaoCompra (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| OrdemCompraId | FK | OC de origem |
| RecebimentoMercadoriaId | FK | Recebimento de origem (nullable) |
| FornecedorId | FK | Fornecedor |
| DataDevolucao | date | Data da devolução |
| MotivoDevolucaoId | FK | Motivo da devolução |
| NotaFiscalDevolucaoNumero | string(50) | Número da NF-e de devolução emitida |
| NotaFiscalDevolucaoChave | string(44) | Chave de acesso da NF-e de devolução |
| Status | enum | Rascunho, PendenteAutorizacao, AutorizadaFornecedor, EmTransito, Concluida, Cancelada |
| ValorTotal | decimal(18,4) | Valor total da devolução |
| Observacoes | text | Observações |

### 2.11 DevolucaoCompraItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| DevolucaoCompraId | FK | Cabeçalho |
| ProdutoId | FK | Produto |
| Quantidade | decimal(18,3) | Quantidade devolvida |
| PrecoUnitario | decimal(18,4) | Preço unitário (mesmo da compra original) |
| CFOP | string(4) | CFOP de devolução (5.202/6.202 etc.) |
| LoteId | FK | Lote devolvido (nullable) |
| NumeroSerieId | FK | Número de série devolvido (nullable) |
| MotivoDetalhe | text | Detalhamento do motivo |

### 2.12 ContratoCompra (Cabeçalho)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Número sequencial 8 dígitos |
| FornecedorId | FK | Fornecedor |
| Tipo | enum | BlanketOrder (pedido aberto), Contrato, AcordoPreco |
| Status | enum | Rascunho, Ativo, Suspenso, Expirado, Cancelado |
| DataInicio | date | Data de início da vigência |
| DataFim | date | Data de fim da vigência |
| CondicaoPagamentoId | FK | Condição de pagamento acordada |
| ValorTotalPrevisto | decimal(18,4) | Valor total previsto do contrato |
| ValorTotalConsumido | decimal(18,4) | Valor já consumido via OCs |
| QuantidadeMinima | decimal(18,3) | Quantidade mínima de compra no período |
| QuantidadeMaxima | decimal(18,3) | Quantidade máxima de compra no período |
| RenovacaoAutomatica | bool | Se renova automaticamente ao expirar |
| DiasAlertaVencimento | int | Dias antes do vencimento para alerta |
| Observacoes | text | Observações e termos gerais |

### 2.13 ContratoCompraItem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ContratoCompraId | FK | Cabeçalho |
| ProdutoId | FK | Produto |
| PrecoUnitario | decimal(18,4) | Preço acordado |
| DescontoPct | decimal(5,2) | Desconto percentual |
| QuantidadeMinima | decimal(18,3) | Quantidade mínima por pedido |
| QuantidadeMaxima | decimal(18,3) | Quantidade máxima no contrato |
| QuantidadeConsumida | decimal(18,3) | Quantidade já consumida |

### 2.14 AvaliacaoFornecedor (Scorecard)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| FornecedorId | FK | Fornecedor avaliado |
| DataAvaliacao | date | Data da avaliação |
| PeriodoInicio | date | Início do período avaliado |
| PeriodoFim | date | Fim do período avaliado |
| PontuacaoTotal | decimal(5,2) | Pontuação total ponderada (0-100) |
| Classificacao | enum | A (Excelente), B (Bom), C (Aceitável), D (Em Revisão), F (Desqualificado) |
| AvaliadorId | FK | Usuário avaliador |
| Observacoes | text | Observações e recomendações |

### 2.15 AvaliacaoFornecedorCriterio

| Campo | Tipo | Descrição |
|-------|------|-----------|
| AvaliacaoFornecedorId | FK | Avaliação pai |
| Criterio | string(100) | Nome do critério (Qualidade, Entrega, Preço, Serviço, etc.) |
| Peso | decimal(5,2) | Peso percentual do critério |
| Nota | decimal(5,2) | Nota atribuída (0-10) |
| NotaPonderada | decimal(5,2) | Nota × Peso |
| Justificativa | text | Justificativa da nota |

### 2.16 AprovacaoHistorico

| Campo | Tipo | Descrição |
|-------|------|-----------|
| DocumentoTipo | enum | RequisicaoCompra, OrdemCompra, DevolucaoCompra |
| DocumentoId | guid | ID do documento |
| AprovadorId | FK | Usuário aprovador |
| Acao | enum | Aprovado, Rejeitado, Devolvido, Delegado |
| NivelAprovacao | int | Nível da aprovação |
| DataAcao | timestamp | Data/hora da ação |
| Comentario | text | Comentário do aprovador |
| DelegadoParaId | FK | Delegado para (nullable, se Acao = Delegado) |

---

## 3. Ciclo de Vida e Status

### 3.1 Requisição de Compra

```
Rascunho → PendenteAprovacao → Aprovada → Convertida (em OC)
                              ↓
                           Rejeitada → (pode ser editada e resubmetida)

Qualquer status → Cancelada (exceto Convertida)
```

**Transições:**
| De | Para | Ação | Quem |
|-----|------|------|------|
| Rascunho | PendenteAprovacao | Submeter para aprovação | Solicitante |
| PendenteAprovacao | Aprovada | Aprovar | Aprovador (conforme alçada) |
| PendenteAprovacao | Rejeitada | Rejeitar | Aprovador |
| PendenteAprovacao | Rascunho | Devolver para correção | Aprovador |
| Aprovada | Convertida | Gerar OC ou Cotação | Comprador |
| * | Cancelada | Cancelar | Solicitante ou Admin |

### 3.2 Cotação (RFQ)

```
Rascunho → Enviada → EmAnalise → Finalizada
                                     ↓
                              (gera OrdemCompra)

Qualquer status → Cancelada
```

### 3.3 Ordem de Compra

```
Rascunho → PendenteAprovacao → Aprovada → Enviada → ParcialmenteRecebida → Recebida → Encerrada
                              ↓
                           Rejeitada → (pode ser editada)

Qualquer status (exceto Recebida/Encerrada) → Cancelada
```

**Detalhamento:**
| Status | Significado |
|--------|-------------|
| **Rascunho** | Em elaboração, pode ser editada livremente |
| **PendenteAprovacao** | Submetida ao workflow de aprovação |
| **Aprovada** | Aprovada por todos os níveis necessários |
| **Enviada** | Transmitida ao fornecedor |
| **ParcialmenteRecebida** | Alguns itens já foram recebidos |
| **Recebida** | Todos os itens foram recebidos |
| **Encerrada** | Processo finalizado (financeiro concluído) |
| **Cancelada** | Cancelada (com justificativa) |

### 3.4 Recebimento de Mercadoria

```
Pendente → EmConferencia → ConferenciaFinalizada → Aprovado
                                                  ↓
                                               Rejeitado (→ DevolucaoCompra)
```

### 3.5 Devolução de Compra

```
Rascunho → PendenteAutorizacao → AutorizadaFornecedor → EmTransito → Concluida
                                                                       ↓
                                                                 (NF-e devolução emitida)
                                                                 (estoque baixado)
                                                                 (crédito financeiro)
```

---

## 4. Fluxos de Negócio Principais

### 4.1 Ciclo Procure-to-Pay (P2P) Completo

```
1. IDENTIFICAÇÃO DA NECESSIDADE
   |-- Estoque abaixo do ponto de reposição (automático)
   |-- Demanda de departamento/projeto
   |-- Requisição manual de usuário
   |
   v
2. REQUISIÇÃO DE COMPRA
   |-- Preencher: produto, quantidade, justificativa, centro de custo
   |-- Submeter para aprovação
   |
   v
3. APROVAÇÃO DA REQUISIÇÃO
   |-- Workflow conforme alçada de valor
   |-- Multi-nível: Gestor → Diretor → Financeiro → Diretoria
   |-- Verificar: orçamento disponível, necessidade, duplicatas
   |
   v
4. SOURCING / COTAÇÃO
   |-- Selecionar 3-5 fornecedores qualificados
   |-- Emitir RFQ com especificações e prazo
   |-- Receber e comparar propostas
   |-- Selecionar vencedor (menor preço, melhor custo-benefício)
   |
   v
5. ORDEM DE COMPRA
   |-- Gerar OC a partir da cotação vencedora
   |-- Submeter para aprovação (workflow por valor)
   |-- Enviar ao fornecedor
   |
   v
6. RECEBIMENTO DE MERCADORIA
   |-- Conferência física (normal ou cega)
   |-- Comparar: quantidade, produto, lote, qualidade vs. OC
   |-- Inspeção de qualidade (se aplicável)
   |-- Gerar GRN (Goods Receipt Note)
   |
   v
7. CONFERÊNCIA FISCAL (Three-Way Matching)
   |-- NF-e do fornecedor ← vs → Ordem de Compra ← vs → GRN
   |-- Validar: quantidades, preços, valores, impostos
   |-- Tolerâncias configuráveis (+/- 2% quantidade, +/- R$10 valor)
   |-- Aprovação ou exceção para divergências
   |
   v
8. MOVIMENTAÇÃO DE ESTOQUE
   |-- Entrada no depósito (MovimentacaoEstoque tipo Entrada)
   |-- Atualizar EstoqueSaldo
   |-- Recalcular custo médio ponderado
   |-- Rastrear lote/série se aplicável
   |
   v
9. CONTAS A PAGAR
   |-- Gerar títulos conforme condição de pagamento
   |-- Registrar retenções (IRRF, CSRF, INSS, ISS)
   |-- Valor líquido = Valor NF - Retenções
   |
   v
10. PAGAMENTO
    |-- Agendar conforme vencimento
    |-- Aprovar pagamento
    |-- Executar (boleto, transferência, PIX)
    |-- Conciliação bancária
```

### 4.2 Recebimento de Compra (Detalhado)

```
Chegada da mercadoria
    → Conferência vs. OC (quantidade, produto, lote)
        → Conferência vs. NF-e (valores, impostos)
            → Three-Way Matching (OC × GRN × NF-e)
                → Se OK:
                    → MovimentacaoEstoque tipo E01 (Compra)
                    → Atualiza EstoqueSaldo (+QuantidadeDisponivel)
                    → Recalcula custo médio ponderado
                    → Gera ContaPagar
                    → Atualiza OrdemCompra.QuantidadeRecebida
                → Se divergência:
                    → Fila de exceções para análise
                    → Aceitar com tolerância OU
                    → Rejeitar → DevolucaoCompra
```

**Conferência Cega:**
Na conferência cega, o conferente **não tem acesso** às quantidades da NF-e ou OC. Ele conta fisicamente os itens e registra no sistema. Depois, o sistema compara automaticamente com os dados esperados. Isso reduz vieses e aumenta a acuracidade.

### 4.3 Three-Way Matching

| Documento 1 | × | Documento 2 | Validação |
|-------------|---|-------------|-----------|
| **Ordem de Compra** | × | **GRN (Recebimento)** | Quantidades recebidas = quantidades pedidas |
| **Ordem de Compra** | × | **NF-e (Fatura)** | Preços e valores = acordados na OC |
| **GRN (Recebimento)** | × | **NF-e (Fatura)** | Quantidades faturadas = quantidades recebidas |

**Resultados do Matching:**

| Resultado | Ação |
|-----------|------|
| **Match completo** | Aprova automaticamente para pagamento |
| **Dentro da tolerância** | Aprova com alerta |
| **Divergência** | Envia para fila de exceções (revisão manual) |
| **Variância significativa** | Bloqueia pagamento, notifica comprador/fornecedor |

**Four-Way Matching (opcional):** Adiciona laudo de inspeção de qualidade como quarto documento.

### 4.4 Devolução ao Fornecedor

```
Problema identificado (defeito, divergência, avaria)
    → Criar DevolucaoCompra vinculada à OC/Recebimento
    → Solicitar autorização do fornecedor (RMA)
        → Fornecedor autoriza
            → Emitir NF-e de devolução (CFOP 5.202/6.202)
            → Separar mercadoria
            → Enviar ao fornecedor
            → MovimentacaoEstoque tipo S03 (Devolução)
            → Atualiza EstoqueSaldo (-QuantidadeDisponivel)
            → Gerar nota de débito / crédito em ContaPagar
```

### 4.5 Compra Urgente (Emergency Purchase)

```
Solicitação urgente (flag "Urgente" na requisição)
    → Workflow simplificado (único aprovador sênior)
    → Aprovação paralela (primeiro a responder aprova)
    → Justificativa de urgência obrigatória
    → OC gerada imediatamente
    → Validação post-facto em 24-48h
    → Dashboard de compras urgentes para monitoramento
```

---

## 5. Workflow de Aprovação

### 5.1 Hierarquia por Alçada de Valor

| Nível | Aprovador | Faixa de Valor (Exemplo) |
|-------|-----------|--------------------------|
| 1 | Gerente de Departamento | Até R$ 5.000 |
| 2 | Diretor de Área | R$ 5.001 - R$ 25.000 |
| 3 | Gerente Financeiro | R$ 25.001 - R$ 100.000 |
| 4 | CEO / Diretoria | Acima de R$ 100.000 |

### 5.2 Critérios de Roteamento

| Critério | Descrição |
|----------|-----------|
| **Por Valor** | Diferentes alçadas para diferentes faixas |
| **Por Centro de Custo** | Cada centro de custo tem aprovadores designados |
| **Por Departamento** | Hierarquia departamental de aprovação |
| **Por Categoria** | Categorias de compra específicas requerem expertise |
| **Por Fornecedor** | Fornecedores novos requerem aprovação adicional |
| **Por Orçamento** | Compras acima do orçamento requerem aprovação financeira |

### 5.3 Delegação e Escalação

**Delegação:**
- Aprovador pode delegar autoridade a substituto durante ausência
- Delegação tem data início/fim
- Aprovações delegadas são marcadas com ambos (delegador e delegado)

**Escalação:**
- Trigger automático quando aprovação fica pendente além do SLA
- Cadeia: Gestor direto → Superior → Diretor de área
- Tempos de escalação configuráveis (24h rotina, 4h urgente)
- Notificações em cada etapa de escalação

**SLAs Alvo:**

| Tipo de Compra | Tempo Alvo de Aprovação |
|----------------|------------------------|
| Rotina (< R$ 5.000) | 24-48 horas |
| Padrão (R$ 5.000 - R$ 50.000) | 3-5 dias úteis |
| Capital/Estratégica (> R$ 50.000) | 7-10 dias úteis |
| Emergência | 2-4 horas |

---

## 6. Gestão de Fornecedores

### 6.1 Ciclo de Vida do Fornecedor

```
Novo/Pendente → Em Avaliação → Aprovado → Ativo
                                           ↓
                                    Suspenso → Re-Qualificado → Ativo
                                           ↓
                                    Desqualificado/Bloqueado
```

| Status | Descrição | Criação de OC |
|--------|-----------|---------------|
| **Pendente** | Aguardando qualificação | Bloqueado |
| **Em Avaliação** | Em processo de avaliação | Bloqueado |
| **Aprovado** | Qualificado e aprovado | Permitido |
| **Ativo** | Aprovado e com pedidos ativos | Permitido |
| **Suspenso** | Temporariamente bloqueado (performance, compliance) | Bloqueado |
| **Desqualificado** | Falhou na avaliação ou não-conformidade reincidente | Bloqueado |
| **Bloqueado** | Bloqueado manualmente (legal, ético, financeiro) | Bloqueado |
| **Inativo** | Sem transações por período estendido | Alerta |

**Regra no ERP:** O sistema impede criação de OC para fornecedores não aprovados/bloqueados.

### 6.2 Scorecard de Avaliação (Critérios)

| Critério | Peso Sugerido | KPIs |
|----------|---------------|------|
| **Qualidade** | 25-30% | Taxa de defeitos, taxa de rejeição, conformidade com especificações |
| **Entrega** | 20-25% | Pontualidade, consistência de lead time, acuracidade do pedido |
| **Preço/Custo** | 15-20% | Competitividade, custo total de propriedade, estabilidade de preço |
| **Serviço** | 10-15% | Tempo de resposta, resolução de problemas, comunicação |
| **Flexibilidade** | 5-10% | Pedidos urgentes, variações de volume, alterações de especificação |
| **Estabilidade Financeira** | 5-10% | Rating de crédito, tendência de receita, anos de mercado |
| **Compliance** | 5-10% | Conformidade regulatória, certificações, práticas éticas |

**Classificação:**
- **A (Excelente/Estratégico):** 85-100 pontos — Parceria estratégica
- **B (Bom/Preferencial):** 70-84 pontos — Fornecedor preferencial
- **C (Aceitável):** 55-69 pontos — Sob monitoramento
- **D (Em Revisão):** 40-54 pontos — Plano de ação corretiva
- **F (Desqualificado):** < 40 pontos — Substituir fornecedor

**Frequência:**
- Fornecedores estratégicos: Trimestral
- Fornecedores regulares: Semestral
- Fornecedores de baixo valor: Anual

### 6.3 Segmentação de Fornecedores (Matriz Kraljic)

| Quadrante | Impacto no Lucro | Risco de Suprimento | Estratégia |
|-----------|------------------|---------------------|------------|
| **Estratégico** | Alto | Alto | Parceria de longo prazo, inovação conjunta |
| **Alavancagem** | Alto | Baixo | Explorar poder de compra, licitação competitiva |
| **Gargalo** | Baixo | Alto | Garantir suprimento, desenvolver alternativas |
| **Rotina** | Baixo | Baixo | Simplificar processo, automatizar pedidos |

### 6.4 Documentos do Fornecedor

| Documento | Frequência de Renovação |
|-----------|------------------------|
| Contrato Social / Estatuto | Na alteração |
| Cartão CNPJ | Na alteração |
| Inscrição Estadual / Municipal | Na alteração |
| Certidão Negativa de Débitos (CND) | Mensal/Trimestral |
| Certidão FGTS | Mensal |
| Alvará de Funcionamento | Anual |
| Certificação ISO (se aplicável) | 3 anos |
| Seguro de Responsabilidade Civil | Anual |
| Licença Ambiental (se aplicável) | Anual/Bienal |
| Certidão de Débitos Trabalhistas | Mensal |
| Laudo Técnico ANVISA (produtos de saúde) | Na renovação |

---

## 7. Contratos e Acordos de Preço

### 7.1 Tipos de Acordos

| Tipo | Descrição | Uso |
|------|-----------|-----|
| **Blanket Purchase Order** | Preços e itens conhecidos, entregas flexíveis | Itens de compra recorrente |
| **Contrato de Fornecimento** | Termos e condições gerais, sem itens específicos | Relacionamentos de longo prazo |
| **Acordo de Preço** | Tabela de preços fixos por período | Estabilidade de custo |
| **Pedido Planejado** | Itens com datas tentativas de entrega | Planejamento de produção |

### 7.2 Estruturas de Preço

| Estrutura | Descrição |
|-----------|-----------|
| **Preço Fixo** | Preço unitário definido para o período do contrato |
| **Preço Escalonado** | Preço diminui conforme volume (ex: 1-100 un = R$10, 101-500 = R$8,50) |
| **Custo + Margem** | Custo base + percentual de markup |
| **Indexado** | Preço vinculado a índice de mercado/commodity |
| **Sazonal** | Preços diferenciados para alta/baixa temporada |

### 7.3 Bonificações e Rebates

- **Descontos por volume:** Aplicados no momento da compra (refletidos na fatura)
- **Rebates:** Devolvidos ao final do período com base em volume realizado
  - Tipos: por volume, por crescimento, por mix, por fidelidade
  - Requerem rastreamento de acumulação durante o período
  - Conciliação e liquidação no encerramento

---

## 8. Relatórios e KPIs

**API de relatórios:** `GET /api/relatorios-compras/{endpoint}`. Índice completo em [README.md](README.md).

### 8.1 Relatórios Padrão

| Relatório | Endpoint | Descrição | Fonte de Dados |
|-----------|-----------|---------------|
| **Pedidos em Aberto** | `pedidos-abertos` | Ordens de compra pendentes de recebimento | `OrdemCompra` (status Enviada/ParcialmenteRecebida) |
| **Histórico de Compras** | `historico-compras` | Todas as compras em um período | `OrdemCompra` + `OrdemCompraItem` |
| **Compras por Fornecedor** | `compras-por-fornecedor` | Volume e valor por fornecedor | `OrdemCompra` agrupado por fornecedor |
| **Compras por Produto** | `compras-por-produto` | Histórico de compras por produto | `OrdemCompraItem` agrupado por produto |
| **Comparativo de Preços** | `comparativo-precos` | Evolução de preços por produto/fornecedor | `HistoricoPreco` |
| **Entregas Pendentes** | `entregas-pendentes` | Itens aguardando recebimento | `OrdemCompraItem` (QuantidadeRecebida < Quantidade) |
| **Performance de Fornecedores** | `performance-fornecedores` | Scorecard consolidado | `AvaliacaoFornecedor` |
| **Análise de Gastos (Spend)** | `analise-gastos` | Gastos por categoria, departamento, período | `OrdemCompra` + `CategoriaCompra` |
| **Requisições Pendentes** | `requisicoes-pendentes` | Requisições aguardando aprovação/processamento | `RequisicaoCompra` (status Pendente) |
| **Cotações em Andamento** | `cotacoes-andamento` | Cotações abertas e comparativos | `Cotacao` + `CotacaoFornecedor` |
| **Divergências de Recebimento** | `divergencias-recebimento` | Diferenças entre pedido vs. recebido | `RecebimentoMercadoriaItem` |
| **Devoluções** | `devolucoes` | Devoluções por período, fornecedor, motivo | `DevolucaoCompra` |
| **Contratos Vencendo** | `contratos-vencendo` | Contratos próximos do vencimento | `ContratoCompra` (DataFim) |
| **Movimentação por CFOP** | `movimentacoes-cfop` | Relatório fiscal de entradas | `RecebimentoMercadoriaItem` agrupado por CFOP |

### 8.2 KPIs do Dashboard

**KPIs de Eficiência:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Cycle Time da OC** | Tempo médio da requisição até emissão da OC | < 5h (top), < 2 dias (média) |
| **Taxa de Three-Way Match** | OCs com match automático / Total OCs × 100 | > 85% |
| **Requisições Pendentes** | Nº de requisições aguardando ação | Minimizar |
| **Tempo de Aprovação** | Tempo médio de aprovação por nível | Conforme SLAs |
| **Acuracidade de OC** | OCs sem emendas / Total OCs × 100 | > 95% |

**KPIs de Custo:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Economia (Savings)** | (Preço Referência - Preço Negociado) / Preço Referência × 100 | 5-15% YoY |
| **Spend sob Gestão** | Gasto gerenciado / Gasto total × 100 | > 80% |
| **Compras Avulsas (Maverick)** | Gasto fora de contratos / Gasto total × 100 | < 5% |
| **Compliance Contratual** | Compras via contrato / Total compras × 100 | > 90% |
| **Custo por OC** | Custo administrativo total / Nº de OCs | Reduzir |

**KPIs de Fornecedor:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Entrega no Prazo** | Entregas no prazo / Total entregas × 100 | > 95% |
| **Lead Time Médio** | Tempo médio da OC ao recebimento | Reduzir |
| **Taxa de Defeitos** | Itens defeituosos / Total itens recebidos × 100 | < 1% |
| **Taxa de Devolução** | Devoluções / Total recebimentos × 100 | < 2% |
| **Nº de Fornecedores Ativos** | Fornecedores com OC no período | Monitorar consolidação |

**KPIs Financeiros:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Tempo de Processamento de Fatura** | Tempo do recebimento da NF-e ao pagamento | < 5 dias |
| **Aderência ao Orçamento** | Gasto real / Gasto planejado × 100 | 95-105% |
| **Valor de Pedidos em Aberto** | Σ valor de OCs pendentes | Monitorar |
| **Dias Médios de Pagamento (DPO)** | Média de dias entre recebimento e pagamento | Conforme negociado |

### 8.3 Design do Dashboard de Compras

**Layout sugerido:**
- **Barra superior**: Total comprado no mês, nº de OCs emitidas, nº de fornecedores ativos
- **Cards KPI**: Cycle time, taxa de match, entrega no prazo, economia
- **Gráficos**:
  - Evolução de gastos (linha, últimos 12 meses)
  - Distribuição por categoria (pizza/donut)
  - Top 10 fornecedores por volume (barras horizontais)
  - Requisições/OCs por status (barras empilhadas)
- **Alertas**: Contratos vencendo, aprovações pendentes, entregas atrasadas
- **Tabela**: Últimas OCs emitidas, próximas entregas esperadas

---

## 9. Requisitos Fiscais Brasileiros

### 9.1 NF-e de Entrada

Toda compra de mercadoria requer NF-e emitida pelo fornecedor. O comprador deve:
1. **Capturar** o XML da NF-e (via DistribuiçãoDFe da SEFAZ ou upload manual)
2. **Manifestar** ciência da operação (evento 210210)
3. **Validar** schema XML, assinatura digital e situação na SEFAZ
4. **Conferir** dados comerciais vs. pedido de compra
5. **Escriturar** no Livro de Entradas (SPED Fiscal)
6. **Confirmar** a operação (evento 210200)
7. **Armazenar** XML por 5 anos (obrigação legal)

**Campos Fiscais Relevantes da NF-e de Entrada:**

| Grupo | Campos Chave |
|-------|-------------|
| **Identificação** | Modelo (55), Série, Número, Data Emissão, Natureza Operação, CFOP |
| **Emitente** | CNPJ, Razão Social, IE, UF, Regime Tributário |
| **Destinatário** | CNPJ, Razão Social, IE, UF |
| **Produtos** | Código, NCM, CFOP, Unidade, Quantidade, Valor Unitário, Valor Total |
| **ICMS** | CST, Base Cálculo, Alíquota, Valor, ICMS-ST (BC, Alíquota, Valor) |
| **IPI** | CST, Base Cálculo, Alíquota, Valor |
| **PIS** | CST, Base Cálculo, Alíquota, Valor |
| **COFINS** | CST, Base Cálculo, Alíquota, Valor |
| **Totais** | Produtos, Frete, Seguro, Desconto, Outras Despesas, IPI, ICMS-ST, Total NF |
| **Transporte** | Modalidade Frete (CIF/FOB), Transportadora, Volumes |
| **Cobrança** | Duplicatas (número, vencimento, valor) |

### 9.2 CFOPs de Compra (Entrada)

| CFOP | Operação |
|------|----------|
| **1.101 / 2.101** | Compra para industrialização |
| **1.102 / 2.102** | Compra para comercialização (revenda) |
| **1.126 / 2.126** | Compra para utilização na prestação de serviço |
| **1.128 / 2.128** | Compra para industrialização sob regime de drawback |
| **1.151 / 2.151** | Transferência para industrialização |
| **1.152 / 2.152** | Transferência para comercialização |
| **1.201 / 2.201** | Devolução de venda de produção do estabelecimento |
| **1.202 / 2.202** | Devolução de venda de mercadoria de terceiros |
| **1.252 / 2.252** | Compra de energia elétrica por estab. comercial |
| **1.353 / 2.353** | Aquisição de serviço de transporte por estab. comercial |
| **1.401 / 2.401** | Compra para industrialização em operação com ST |
| **1.403 / 2.403** | Compra para comercialização em operação com ST |
| **1.411 / 2.411** | Devolução de venda em operação com ST |
| **1.501 / 2.501** | Entrada de mercadoria recebida com fim específico de exportação |
| **1.551 / 2.551** | Compra de ativo imobilizado |
| **1.556 / 2.556** | Compra de material de uso e consumo |
| **1.910 / 2.910** | Entrada de bonificação/doação/brinde |
| **1.917 / 2.917** | Entrada de consignação mercantil |
| **1.949 / 2.949** | Outra entrada não especificada |
| **3.101** | Compra para industrialização (importação) |
| **3.102** | Compra para comercialização (importação) |
| **3.551** | Compra de ativo imobilizado (importação) |
| **3.556** | Compra de material de uso e consumo (importação) |

**CFOPs de Devolução de Compra (Saída):**

| CFOP | Operação |
|------|----------|
| **5.201 / 6.201** | Devolução de compra para industrialização |
| **5.202 / 6.202** | Devolução de compra para comercialização |
| **5.411 / 6.411** | Devolução de compra para comercialização em operação com ST |
| **5.413 / 6.413** | Devolução de compra para industrialização em operação com ST |
| **5.553 / 6.553** | Devolução de compra de ativo imobilizado |
| **5.556 / 6.556** | Devolução de compra de material de uso e consumo |

### 9.3 Impostos nas Compras

#### 9.3.1 ICMS

| Aspecto | Detalhe |
|---------|---------|
| **Alíquotas interestaduais** | 4% (importados), 7% (Sul/SE → N/NE/CO/ES), 12% (demais) |
| **Alíquotas internas** | Variam por estado (17% a 22%) |
| **Crédito de ICMS** | Lucro Presumido e Real: crédito integral pelas entradas tributadas |
| **ICMS-ST** | Substituição tributária: ICMS cobrado antecipadamente pelo fornecedor |
| **DIFAL** | Diferencial de alíquota para compras interestaduais de uso/consumo ou ativo |
| **MVA** | Margem de Valor Agregado para cálculo da base de ST |
| **CST ICMS** | Código de Situação Tributária: 00 (tributada), 10 (com ST), 20 (redução BC), 30 (isenta+ST), 40 (isenta), 41 (não tributada), 50 (suspensão), 60 (ICMS cobrado por ST), 70 (redução+ST), 90 (outros) |

**Fórmula DIFAL:**
```
DIFAL = (BC × Alíquota Interna) - (BC × Alíquota Interestadual)
```

**Fórmula MVA Ajustada:**
```
MVA Ajustada = [(1 + MVA Original) × (1 - ALQ Inter) / (1 - ALQ Interna)] - 1
```

#### 9.3.2 IPI

| Aspecto | Detalhe |
|---------|---------|
| **Incidência** | Sobre produtos industrializados na saída do estabelecimento industrial |
| **Crédito** | Apenas para estabelecimentos industriais ou equiparados |
| **Alíquota** | Definida pela TIPI (Tabela IPI), varia por NCM |
| **Base de cálculo** | Valor da operação + frete + seguro + outras despesas |
| **CST IPI** | 00 (tributada), 01 (tributada ZFM), 02 (isenta), 03 (não tributada), 04 (imune), 05 (suspensa), 49 (outras entradas), 50-99 (saídas) |

#### 9.3.3 PIS/COFINS

| Regime | PIS | COFINS | Crédito na Compra |
|--------|-----|--------|-------------------|
| **Cumulativo** (Lucro Presumido) | 0,65% | 3,00% | NÃO |
| **Não-Cumulativo** (Lucro Real) | 1,65% | 7,60% | SIM |

**Direito a crédito de PIS/COFINS (Lucro Real):**
- Bens adquiridos para revenda
- Bens e serviços utilizados como insumo
- Energia elétrica
- Aluguéis de prédios e equipamentos
- Arrendamento mercantil (leasing)
- Depreciação de máquinas e equipamentos
- Frete na operação de venda
- Armazenagem de mercadorias

**CST PIS/COFINS:** 50 (crédito vinculado à receita tributada), 51 (crédito vinculado à receita não tributada), 52 (crédito vinculado à receita de exportação), 53 (crédito vinculado a receita tributada e não tributada), 70-75 (sem crédito)

#### 9.3.4 Impostos de Importação

| Imposto | Descrição |
|---------|-----------|
| **II** | Imposto de Importação (alíquota por NCM na TEC) |
| **IPI** | Sobre produto importado |
| **PIS-Importação** | 2,10% (regime especial) |
| **COFINS-Importação** | 9,65% (regime especial) |
| **ICMS** | Sobre valor total + II + IPI + PIS/COFINS |
| **AFRMM** | Adicional ao Frete para Renovação da Marinha Mercante (25% sobre frete marítimo) |
| **Taxa Siscomex** | R$ 214,50 por Declaração + R$ 107,50 por adição |

### 9.4 Manifestação do Destinatário (MDe)

| Código | Evento | Descrição |
|--------|--------|-----------|
| 210200 | Confirmação da Operação | Confirma que a operação ocorreu e a mercadoria foi recebida |
| 210210 | Ciência da Operação | Declara ciência (não confirma nem nega). Permite download do XML |
| 210220 | Desconhecimento da Operação | Não reconhece a operação (uso indevido do CNPJ) |
| 210240 | Operação não Realizada | Reconhece a NF-e mas a operação não foi efetuada |

**Workflow no ERP:**
```
1. Consulta DistribuiçãoDFe na SEFAZ (periódica)
   → NF-e identificada para o CNPJ
2. Evento 210210 - Ciência (automático ao processar)
   → Download do XML completo
3. Conferência no ERP
   → Comparar com pedido de compra
   → Validar dados fiscais
4. Se OK: Evento 210200 - Confirmação
   Se não reconhece: Evento 210220 - Desconhecimento
   Se não realizada: Evento 210240 - Operação não Realizada
```

**Prazos:**

| Operação | Ciência | Confirmação | Desconhecimento |
|----------|---------|-------------|-----------------|
| Intraestadual | 5 dias | 20 dias | 10 dias |
| Interestadual | 10 dias | 35 dias | 15 dias |
| Prazo máximo pós-ciência | — | 180 dias | 180 dias |

### 9.5 Retenções na Fonte

| Tributo | Alíquota | Fato Gerador | Limite Mínimo | Simples Isento? |
|---------|----------|-------------|---------------|-----------------|
| **IRRF** | 1% a 1,5% | Pagamento | IR < R$ 10,00 | SIM (ME/EPP) |
| **PIS retido** | 0,65% | Pagamento | Total < R$ 215,05 | SIM (ME/EPP) |
| **COFINS retida** | 3,00% | Pagamento | Total < R$ 215,05 | SIM (ME/EPP) |
| **CSLL retida** | 1,00% | Pagamento | Total < R$ 215,05 | SIM (ME/EPP) |
| **INSS** | 11% | Emissão NF | Sem limite | NÃO |
| **ISS** | 2% a 5% | Prestação serviço | Conforme município | Conforme município |

**CSRF (PIS + COFINS + CSLL) = 4,65%** — retido sobre serviços profissionais, consultoria, limpeza, manutenção, segurança, etc.

**Impacto no ERP:** Ao gerar Contas a Pagar, o valor líquido = Valor NF - Retenções. As retenções devem ser registradas separadamente para recolhimento via DARF.

### 9.6 Impacto por Regime Tributário

| Imposto na Compra | Simples Nacional | Lucro Presumido | Lucro Real |
|-------------------|-----------------|-----------------|------------|
| ICMS (crédito) | Limitado (alíq. Simples) | SIM (integral) | SIM (integral) |
| ICMS-ST | Não gera crédito | Não gera crédito | Não gera crédito |
| DIFAL | Recolhe | Recolhe | Recolhe |
| IPI (crédito) | NÃO | NÃO (exceto equiparado) | SIM (industriais) |
| PIS/COFINS (crédito) | NÃO | NÃO | SIM (1,65% + 7,60%) |
| IRRF retido | Isento (ME/EPP) | Retido conforme serviço | Retido conforme serviço |
| CSRF retido | Isento (ME/EPP) | Retido se > R$ 215,05 | Retido se > R$ 215,05 |

### 9.7 SPED Fiscal — Integração com Compras

**EFD ICMS/IPI (Blocos relevantes):**

| Bloco | Registros | Descrição |
|-------|-----------|-----------|
| **C** | C100, C170, C190 | Documentos fiscais de mercadoria (NF-e entrada) |
| **D** | D100, D190 | Documentos fiscais de transporte (CT-e) |
| **E** | E100, E110, E116 | Apuração de ICMS (débitos, créditos, saldo) |
| **H** | H005, H010 | Inventário físico (Bloco H — já implementado no estoque) |

**EFD-Contribuições (Blocos relevantes):**

| Bloco | Registros | Descrição |
|-------|-----------|-----------|
| **C** | C100, C170, C190 | Documentos de aquisição com direito a crédito PIS/COFINS |
| **M** | M100, M500 | Apuração de créditos de PIS e COFINS |

### 9.8 CT-e (Conhecimento de Transporte Eletrônico)

| Aspecto | Detalhe |
|---------|---------|
| **Modelo** | 57 (CT-e) |
| **Crédito ICMS** | SIM, para contribuintes em operações tributadas |
| **CFOP frete** | 1.353/2.353 (aquisição serviço transporte) |
| **PIS/COFINS** | Crédito no Lucro Real sobre frete de compra |
| **SPED** | Registrado no Bloco D da EFD ICMS/IPI |
| **Vinculação** | CT-e vinculado à chave da NF-e transportada |

**Modalidade de Frete (modFrete na NF-e):**
- 0 = CIF (frete por conta do remetente/fornecedor)
- 1 = FOB (frete por conta do destinatário/comprador)
- 2 = Frete por conta de terceiros
- 9 = Sem frete

### 9.9 Reforma Tributária 2026 (IBS/CBS)

| Tributo Novo | Substitui | Início |
|-------------|-----------|--------|
| **IBS** (Imposto sobre Bens e Serviços) | ICMS + ISS | 2026 (teste), 2027-2032 (transição) |
| **CBS** (Contribuição sobre Bens e Serviços) | PIS + COFINS | 2026 (teste), 2027-2032 (transição) |
| **IS** (Imposto Seletivo) | Parcialmente IPI | 2026 |

**Novos campos obrigatórios na NF-e (a partir de 05/01/2026):** CST-IBS/CBS, cClassTrib, gIBS, gCBS, gIS, vBC_IBSCBS, pIBS, vIBS, pCBS, vCBS.

**Impacto no módulo de Compras:**
1. Recepção de XML deve ler novos grupos IBS/CBS/IS
2. Novos registros no SPED para IBS/CBS
3. IBS e CBS seguem não-cumulatividade ampla (crédito financeiro)
4. De 2027 a 2032: ERP apura TANTO tributos antigos QUANTO novos

---

## 10. Funcionalidades Avançadas

### 10.1 Requisição Automática (Ponto de Reposição)

**Fórmula:** `Ponto de Reposição = (Demanda Média Diária × Lead Time) + Estoque de Segurança`

**Integração com Estoque:**
- Sistema monitora continuamente `EstoqueSaldo` vs. `Produto.PontoReposicao`
- Quando estoque cai abaixo do ponto, gera `RequisicaoCompra` automaticamente
- Requisição segue workflow normal de aprovação
- Quantidade sugerida = `Produto.QuantidadeReposicao` ou `EstoqueMaximo - EstoqueAtual`

### 10.2 Compra em Consignação

```
Acordo de consignação com fornecedor
    → Fornecedor envia mercadoria (NF-e com CFOP 1.917)
    → Estoque consignado (propriedade do fornecedor)
    → Ao consumir/vender:
        → Transferir de consignado para próprio
        → Gerar NF-e de compra efetiva
        → Gerar ContaPagar
    → Ao devolver:
        → NF-e de devolução (CFOP 5.918)
```

### 10.3 Drop Shipping (Entrega Direta)

```
Cliente faz pedido → Empresa cria OC para fornecedor com endereço do cliente
    → Fornecedor envia diretamente ao cliente
    → Recebimento é virtual (sem passagem pelo depósito)
    → Empresa fatura o cliente
    → Empresa paga o fornecedor
```

### 10.4 Portal do Fornecedor (Fase Futura)

Funcionalidades de um portal self-service:
- Consultar e aceitar/rejeitar OCs
- Submeter faturas (NF-e)
- Atualizar catálogo de produtos
- Visualizar status de pagamentos
- Comunicação estruturada com o comprador
- Atualizar dados cadastrais e documentos
- Acompanhar avaliações de performance

### 10.5 Compras Intercompany

Para empresas com múltiplas filiais/CNPJs:
- Entidade compradora cria OC intercompany
- Sistema gera automaticamente pedido de venda na entidade vendedora
- Entidade vendedora envia (NF-e com CFOP 5.152/6.152)
- Faturamento e escrituração automáticos em ambos os lados
- Transfer pricing conforme regras fiscais

---

## 11. Especificidades do Setor Óptico

### 11.1 Compras de Lentes

| Tipo de Lente | Modelo de Compra | Lead Time | Estratégia de Estoque |
|---------------|-----------------|-----------|----------------------|
| **Lentes Prontas (stock)** | Compra em lote do fabricante | Imediato (do estoque) | Min/Max reorder |
| **Lentes Surfaçadas/Digitais** | Pedido por receita ao laboratório | 3-7 dias úteis | Sob demanda |
| **Lentes Free-Form/Progressivas** | Pedido por receita (surfaçagem digital) | 5-10 dias úteis | Sob demanda |
| **Lentes de Contato (padrão)** | Compra do distribuidor | 1-3 dias | PAR level reorder |
| **Lentes de Contato (especial)** | Pedido por paciente | 5-15 dias úteis | Sob demanda |

**Compra de Lentes Prontas:**
- Matriz de estoque: dioptria (ESF, CIL) × diâmetro × material × tratamento
- Alto volume, baixo valor unitário — ideal para Blanket POs
- Fornecedores principais: Essilor, Hoya, Zeiss, Carl Zeiss, Rodenstock

**Pedido de Lente ao Laboratório (Lab Order):**
- Dados transmitidos: Rx (ESF, CIL, Eixo, Adição), DP, DNP, altura, medidas da armação
- Material, tratamento, design da lente
- Workflow: Rx → Seleção → Pedido → Surfaçagem → Tratamento → Montagem → Envio

### 11.2 Compras de Armações

**Atributos de armação (matriz de estoque):**
- Marca / Coleção / Modelo
- Cor / Código de cor
- Tamanho (aro, ponte, haste)
- Material (metal, acetato, TR90, titânio)
- Forma (redondo, quadrado, aviador, etc.)
- Gênero (M, F, unissex)
- Categoria (grau, solar, segurança)

**Características de compra:**
- Coleções sazonais (primavera/verão, outono/inverno)
- Mínimos de marca (quantidade mínima por pedido, SKUs mínimos)
- Displays/demonstradores (geralmente fornecidos pela marca)
- Programas de consignação comuns com marcas premium
- Políticas de devolução para estoque não vendido

**Fornecedores típicos:**
- Luxottica/EssilorLuxottica (Ray-Ban, Oakley, Prada, Versace)
- Safilo (Dior, Fendi, Hugo Boss)
- Marchon (Nike, Calvin Klein, Lacoste)
- Brands nacionais e independentes

### 11.3 Suprimentos de Laboratório

| Categoria | Exemplos | Frequência de Compra |
|-----------|----------|---------------------|
| **Materiais de surfaçagem** | Blocos de lentes, materiais de bloqueio | Semanal/Mensal |
| **Materiais de tratamento** | Soluções AR, hard coat | Mensal |
| **Materiais de montagem** | Rodas diamantadas, pads de polimento, coolant | Mensal |
| **Limpeza** | Soluções de limpeza, microfibras | Mensal |
| **Embalagem** | Estojos, bolsas, kits de limpeza | Mensal |
| **Ferramentas** | Lensômetros, pupilômetros, aquecedores | Sob demanda |
| **Nose pads e parafusos** | Diversos tamanhos e materiais | Mensal |

### 11.4 Desafios Específicos

- **Complexidade de Rx:** Milhares de combinações possíveis (dioptria × material × tratamento)
- **Matriz de armações:** Marca × cor × tamanho = enorme quantidade de SKUs
- **Ciclos sazonais de compra** com tendências de moda
- **Consignação:** Comum com marcas premium
- **Controle de qualidade:** Precisão de receita é crítica
- **Regulamentação ANVISA:** Produtos de saúde requerem conformidade
- **Integração com sistema de gestão de pacientes** para Rx

---

## 12. Comparativo com ERPs de Referência

| Aspecto | SAP MM | Oracle Procurement | TOTVS Protheus (SIGACOM) | Dynamics 365 | **OpticalCore (proposta)** |
|---------|--------|-------------------|-------------------------|-------------|---------------------------|
| Requisição | Purchase Requisition | Purchase Requisition | Solicitação de Compra (SC) | Purchase Requisition | RequisicaoCompra |
| Cotação | RFQ/Quotation | RFQ/Quotation | Cotação | RFQ | Cotacao + CotacaoFornecedor |
| Ordem | Purchase Order | Purchase Order | Pedido de Compra (PC) | Purchase Order | OrdemCompra |
| Recebimento | Goods Receipt (MIGO) | Receiving (RCV) | Documento de Entrada | Product Receipt | RecebimentoMercadoria |
| Matching | 3-Way Match (MIRO) | 3-Way Match | NF × PC | 3-Way Match | Three-Way Match |
| Contrato | Outline Agreement | Purchase Agreement | Contrato de Parceria | Purchase Agreement | ContratoCompra |
| Aprovação | Workflow Builder | AME (Approval Mgmt) | MVC (Workflow) | Power Automate | FluxoAprovacao |
| Avaliação Fornecedor | Vendor Evaluation | Supplier Qualification | Avaliação de Fornecedor | Vendor Evaluation | AvaliacaoFornecedor |
| Devolução | Return PO | Return to Vendor | Devolução de Compra | Purchase Return | DevolucaoCompra |

---

## 13. Priorização Sugerida para Implementação

### Fase 1 — Fundação (MVP)

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 1 | OrdemCompra + Itens | Pedido de compra com todos os campos |
| 2 | RecebimentoMercadoria + Itens | Recebimento e conferência de mercadoria |
| 3 | Integração com Estoque | Entrada automática no estoque ao receber |
| 4 | Integração com Financeiro | Geração de Contas a Pagar ao receber |
| 5 | Three-Way Matching básico | OC × Recebimento × NF-e |
| 6 | Relatório: Pedidos em Aberto | OCs pendentes de recebimento |

### Fase 2 — Operacional

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 7 | RequisicaoCompra + Itens | Requisição interna de compra |
| 8 | Workflow de Aprovação | Aprovação por alçada de valor |
| 9 | DevolucaoCompra + Itens | Devolução ao fornecedor com NF-e |
| 10 | Relatórios operacionais | Compras por fornecedor, produto, divergências |
| 11 | Dashboard de Compras | KPIs e gráficos |

### Fase 3 — Avançado

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 12 | Cotacao + CotacaoFornecedor | Processo de cotação/RFQ |
| 13 | ContratoCompra + Itens | Contratos e blanket POs |
| 14 | AvaliacaoFornecedor | Scorecard de fornecedores |
| 15 | HistoricoPreco | Rastreamento de evolução de preços |
| 16 | Requisição Automática | Integração com ponto de reposição do estoque |

### Fase 4 — Fiscal

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 17 | Manifestação do Destinatário | Integração com SEFAZ para MDe |
| 18 | Escrituração Fiscal de Entrada | Integração com SPED Fiscal |
| 19 | Cálculo de Impostos | ICMS, IPI, PIS/COFINS, retenções |
| 20 | CT-e | Escrituração de frete |
| 21 | Importação | Impostos de importação |

---

## 14. Integração Entre Módulos

```
COMPRAS → ESTOQUE
├── Recebimento gera MovimentacaoEstoque (tipo Entrada/E01)
├── Atualiza EstoqueSaldo (+QuantidadeDisponivel)
├── Recalcula custo médio ponderado
├── Rastreia lote/série
└── Devolução gera MovimentacaoEstoque (tipo Saída/S03)

COMPRAS → FINANCEIRO
├── Recebimento aprovado gera ContaPagar
├── Condições de pagamento definem parcelas
├── Retenções (IRRF, CSRF, INSS, ISS) reduzem valor líquido
├── Devolução gera crédito em ContaPagar
└── Cancelamento de OC cancela títulos pendentes

COMPRAS → FISCAL
├── Escrituração no Livro de Entradas
├── Créditos de ICMS, IPI, PIS/COFINS
├── MDe (manifestação do destinatário)
├── SPED Fiscal (Blocos C, D, E)
└── SPED Contribuições (Blocos C, M)

COMPRAS ← ESTOQUE
├── Ponto de reposição gera RequisicaoCompra automática
└── Saldos informam necessidades de compra

COMPRAS ← VENDAS
├── Pedido de venda pode gerar requisição de compra (make-to-order)
└── Drop shipping: OC com entrega direta ao cliente
```

---

## 15. Padrões Arquiteturais

### 15.1 Event Sourcing (Padrão CQRS — já implementado)

- Todas as transações de compra geram eventos de domínio
- `OrdemCompraCriada`, `OrdemCompraAprovada`, `OrdemCompraEnviada`
- `RecebimentoRegistrado`, `RecebimentoAprovado`
- `DevolucaoCriada`, `DevolucaoConcluida`
- Compatível com o MediatR existente no projeto

### 15.2 Concorrência

- **Pessimistic locking** no recebimento (evitar recebimento duplicado)
- **Optimistic concurrency** em aprovações (coluna de versão)
- Mesma transação para: INSERT RecebimentoMercadoria + UPDATE OrdemCompra.QuantidadeRecebida + INSERT MovimentacaoEstoque + UPDATE EstoqueSaldo

### 15.3 Numeração Sequencial

- Todos os documentos (requisição, cotação, OC, recebimento, devolução) com numeração sequencial por tenant
- Sem gaps para compliance fiscal
- Implementar via `SELECT ... FOR UPDATE` ou sequence do PostgreSQL por schema

### 15.4 Trilha de Auditoria

- Todas as transições de status registradas em `AprovacaoHistorico`
- Quem, quando, o quê, por quê (comentário)
- Documentos imutáveis após aprovação (alterações geram nova versão ou aditivo)
- Retenção mínima: 5 anos (exigência fiscal)

---

## 16. Futuras Implementações

Itens planejados para o módulo de Compras, ainda não implementados.

### 16.1 Importação automática de itens da NF-e no Recebimento de Mercadoria

**Objetivo:** Ao informar a chave de acesso da NF-e do fornecedor (ou fazer upload do XML), a aplicação deve **identificar e importar automaticamente** os itens e quantidades da nota, preenchendo a grade de itens do Recebimento de Mercadoria.

**Situação atual:** Os dados da NF (número, chave, série, data de emissão) são informados manualmente e armazenados apenas como referência. Os itens do recebimento são preenchidos manualmente pelo usuário (produto, quantidade esperada, quantidade recebida, preço unitário, etc.). Não há integração com XML da NF-e nem com serviço de consulta à SEFAZ para obter os itens da nota.

**Implementação futura (desejada):**

1. **Entrada:** Usuário informa a chave da NF-e (44 dígitos) e/ou faz upload do XML da NF-e de entrada.
2. **Processamento:** Sistema obtém o XML (via Distribuição DFe, webservice de consulta por chave, ou parse do arquivo enviado), valida schema e assinatura, e extrai:
   - Dados do emitente (CNPJ, razão social) — conferência com fornecedor da OC;
   - Número, série, data de emissão, valor total da NF;
   - Itens: código do produto (referência ao cadastro ou NCM/EAN), descrição, quantidade, unidade, valor unitário, valor total, CFOP, NCM, dados de impostos.
3. **Preenchimento automático:** Com base nos itens da NF-e:
   - Preencher cabeçalho do recebimento (número NF, chave, série, data, valor total);
   - Preencher/criar linhas de itens do recebimento: produto (via match por EAN/código/NCM), quantidade esperada e quantidade recebida (inicialmente igual à da NF), preço unitário, CFOP;
   - Quando o recebimento estiver vinculado a uma OC, opcionalmente cruzar itens da NF com itens da OC (match por produto) para preencher `OrdemCompraItemId` e quantidade esperada da OC.
4. **Conferência:** Usuário mantém a possibilidade de ajustar quantidades recebidas (conferência física), rejeitar itens e incluir observações antes de confirmar o recebimento.

**Benefícios:** Redução de erros de digitação, agilidade na conferência e alinhamento automático entre NF-e e documento de recebimento (base para Three-Way Matching e escrituração fiscal).

---

## 17. Fontes da Pesquisa

### Procure-to-Pay e Processos
- Kissflow — P2P Process Guide (9 Steps)
- Simfoni — Procure-to-Pay Guide 2026
- Procurify — Complete P2P Process
- Amazon Business — P2P Guide 2026
- Basware — P2P Cycle Explained
- ZipHQ — P2P Step-by-Step Guide
- Pipefy — P2P Key Steps & Best Practices
- Stampli — Purchase Requisition Best Practices

### Gestão de Fornecedores
- Precoro — Vendor Scorecard 101
- Ivalua — Vendor Scorecards Complete Guide
- Ramp — Supplier Scorecard Template
- HighRadius — Supplier Scorecard Best Practices
- Kodiak Hub — Supplier Document Management
- Kodiak Hub — Supplier Evaluation
- ESGrid — Supplier Evaluation Criteria
- Art of Procurement — Kraljic Matrix
- CIPS — Kraljic Matrix
- SAP — Supplier Qualification Status Flow

### Contratos e Acordos
- NetSuite — Blanket PO Contracts
- Kissflow — Blanket Purchase Order Guide
- Tipalti — Ultimate Guide to BPOs
- Oracle — Purchase Orders vs Agreements
- ISP Next — Rebate Management
- Enable — Volume Incentive Rebate Examples
- Sievo — Contract Lifecycle Management 5 Stages
- Ivalua — CLM Explained
- Microsoft Dynamics 365 — Purchase Agreements

### Workflows e Aprovação
- CFlowApps — Procurement Approval Process
- Zycus — Best-in-Class Procurement Approval Workflow
- Stampli — Purchase Order Approval Workflow
- Hyperbots — PO Approval Process Policies
- ProcureDesk — Procurement Approval Workflows
- Microsoft Dynamics 365 — Purchase Requisition Workflow

### Three-Way Matching e Recebimento
- NetSuite — Three-Way Matching
- Tipalti — 3-Way Match
- Ramp — 3-Way Matching
- HighRadius — Goods Received Note
- Emagia — GRN in Procurement
- CFlowApps — Goods Received Note

### KPIs e Analytics
- Ivalua — Procurement KPIs That Drive Outcomes
- Fraxion — 7 Spend Management KPIs
- ThoughtSpot — 11 Procurement KPIs
- Kissflow — 11 Must-Know Procurement KPIs
- Procurify — Improve PO Cycle Time
- ZipHQ — 16 Procurement KPIs
- Sievo — Spend Data Categorization

### ERPs de Referência
- Oracle Purchasing User's Guide
- Oracle — Creating Purchase Orders
- SAP Community — Purchase Requisition Workflows
- SAP — Purchase Order Process
- Microsoft Dynamics 365 — Purchase Requisition Overview
- ERPNext — Purchase Order
- TOTVS — Módulos Protheus (SIGACOM)
- TOTVS — Conferência de Mercadorias
- Senior — Registrar NF Entrada
- ERP.net — Procurement Entities

### Fiscal Brasileiro
- Grid Sistemas — Estrutura XML NF-e
- SEFAZ PE — Tabela CFOP
- Contabilizei — Tabela CFOP Completa
- Focus NFe — CFOP de Entrada
- SEFAZ PR — ICMS Substituição Tributária
- Portal Tributário — DIFAL
- Portal Tributário — Retenções Serviços
- Portal Tributário — INSS Retenção 11%
- Conta Azul — Retenção de Impostos
- Escola Superior ESN — Créditos PIS/COFINS Lucro Real
- Nuvem ERP — Manifestação Destinatário
- Focus NFe — Manifestação Destinatário
- Tecnospeed — Tipos e Prazos MDe
- Senior — Bloco C SPED Fiscal
- Tecnospeed — EFD ICMS IPI
- Logcomex — AFRMM Importação
- LDC Comex — Cálculo Tributos Importação

### Reforma Tributária 2026
- Escola Superior ESN — NF-e 2026 IBS CBS
- FENACON — IBS CBS 2026
- Receita Federal — Orientações 2026
- COMSEFAZ — Reforma 2026
- Tecnospeed — Nota Técnica 2025.002 IBS/CBS

### Setor Óptico
- PWI — Lente sob Encomenda ERP Fluxo Óptico
- Arquem — Dicas para Fornecedores da Ótica
- Grupo Acert — ERP SGO para Ópticas
- Grupo Acert — Laboratórios e Óticas Integrados
- SerpentCS — Optical Shop Management with Odoo
- VAI — Eyewear ERP Software
- Frames Data — For Optical Retailers
- Crystal PM — Optical Inventory Management
- Laramy-K — Lens Edging/Finishing e Surfacing
- Pepperi — Optical & Eyewear B2B Wholesale

### Devolução de Compra
- ERPFlex — Nota de Devolução de Compras
- Nomus — Nota Fiscal de Devolução
- Senior — Nota Fiscal de Devolução
- Click Notas — Nota Fiscal de Devolução Guia
- Loggi — Nota de Devolução

### Funcionalidades Avançadas
- Procurify — PunchOut Catalogs
- TradeCentric — PunchOut Catalog Complete Guide
- Fulfil.io — Reorder Points Automated Replenishment
- Oracle — Drop Ship Overview
- SAP Community — Vendor Consignment Process
- GEP — Purchase Return Notes
- Aixtor — Supplier Portal Solutions
- Knack — Best Supplier Portal Software 2026
