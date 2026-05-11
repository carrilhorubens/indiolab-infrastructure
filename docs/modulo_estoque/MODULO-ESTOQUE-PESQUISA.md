do# Pesquisa: Módulo de Estoque para ERP Genérico

> Levantamento completo de entidades, fluxos, relatórios, KPIs, boas práticas e requisitos fiscais brasileiros para implementação do módulo de Estoque no OpticalCore ERP.
> Referências: SAP S/4HANA, Oracle E-Business Suite, Odoo 19, TOTVS Protheus (SIGAEST), NetSuite, MRPeasy, Deskera.

---

## 1. Entidades Propostas

### 1.1 Dados Mestres (8 entidades)

| Entidade | Descrição | Schema |
|----------|-----------|--------|
| **Produto** | Cadastro central do produto (SKU, EAN, NCM, custeio, dimensões, estoque mín/máx) | Tenant |
| **Armazem** | Depósito/almoxarifado (próprio, terceiros, trânsito, consignação) | Tenant |
| **Localizacao** | Endereço dentro do armazém (corredor-prateleira-posição, ex: `A-01-03-02`) | Tenant |
| **Lote** | Rastreamento de lote (fabricação, validade, fornecedor) | Tenant |
| **NumeroSerie** | Rastreamento individual de item (ciclo de vida completo) | Tenant |
| **ConversaoUnidadeMedida** | Conversões de UOM (global ou por produto) | Tenant |
| **ProdutoCodigoBarras** | Múltiplos códigos de barras por produto (EAN-13, Code 128, QR) | Tenant |
| **ProdutoFornecedor** | Relação produto-fornecedor (lead time, custo, código no fornecedor) | Tenant |

### 1.2 Dados Transacionais (7 entidades)

| Entidade | Descrição | Referência ERP |
|----------|-----------|----------------|
| **MovimentacaoEstoque** | Log imutável de toda movimentação (entrada, saída, transferência, ajuste) | SAP: Material Document / Odoo: `stock.move` / Protheus: `SD3` |
| **EstoqueSaldo** | Saldo atual por produto+armazém+localização (projeção materializada) | Oracle: `MTL_ONHAND_QUANTITIES_DETAIL` / Odoo: `stock.quant` / Protheus: `SB2` |
| **ReservaEstoque** | Reservas temporárias (pedidos de venda, produção) | Oracle: `MTL_RESERVATIONS` |
| **OrdemTransferencia** | Cabeçalho de transferência entre armazéns | SAP: Transfer Order |
| **OrdemTransferenciaItem** | Itens da ordem de transferência | — |
| **InventarioFisico** | Cabeçalho de contagem física (completa ou cíclica) | Protheus: Processo de Inventário |
| **InventarioFisicoItem** | Itens contados vs. sistema, com divergência | — |

### 1.3 Dados Especializados (2 entidades)

| Entidade | Descrição |
|----------|-----------|
| **EstoqueConsignado** | Estoque em consignação (fornecedor ou cliente como proprietário) |
| **EstoqueSaldoHistorico** | Snapshot diário para relatórios e SPED Bloco H |

### 1.4 Domínios/Lookup (novas)

| Entidade | Descrição |
|----------|-----------|
| **CategoriaProduto** | Categorias hierárquicas de produto |
| **TipoMovimentacao** | Classificação de tipos de movimentação |
| **MotivoAjuste** | Motivos para ajuste de estoque |

---

## 2. Campos Chave da Entidade Produto

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | int (auto) | Código sequencial 8 dígitos |
| Nome | string(200) | Nome do produto |
| Descricao | text | Descrição detalhada |
| SKU | string(50) | Código interno (Stock Keeping Unit) |
| CodigoBarras | string(50) | EAN-13 principal |
| NCM | string(10) | Classificação fiscal (Nomenclatura Comum do Mercosul) |
| CategoriaId | FK | Categoria do produto |
| UnidadeMedidaId | FK | Unidade primária de medida |
| TipoProduto | enum | Acabado, Matéria-Prima, Semi-Acabado, Serviço, Kit |
| ControlaLote | bool | Habilita rastreio por lote |
| ControlaNumeroSerie | bool | Habilita rastreio por número de série |
| MetodoCusteio | enum | FIFO, Custo Médio Ponderado, Custo Padrão |
| CustoUnitario | decimal(18,4) | Custo unitário atual |
| PrecoVenda | decimal(18,2) | Preço de venda |
| EstoqueMinimo | decimal(18,3) | Estoque mínimo (gera alerta) |
| PontoReposicao | decimal(18,3) | Ponto de reposição (gera sugestão de compra) |
| EstoqueMaximo | decimal(18,3) | Estoque máximo |
| QuantidadeReposicao | decimal(18,3) | Quantidade padrão de reposição |
| LeadTimeDias | int | Prazo de entrega do fornecedor |
| PesoLiquido | decimal(10,3) | Peso líquido |
| PesoBruto | decimal(10,3) | Peso bruto |
| Altura | decimal(10,2) | Altura |
| Largura | decimal(10,2) | Largura |
| Profundidade | decimal(10,2) | Profundidade |
| OrigemFiscal | enum | Nacional, Importado (para cálculo de ICMS) |
| ClasseABC | char(1) | Classificação A, B ou C |
| Ativo | bool | Status ativo/inativo |

---

## 3. Campos Chave das Entidades de Suporte

### 3.1 Armazem

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Codigo | string(20) | Código do armazém |
| Nome | string(100) | Nome do armazém |
| EnderecoId | FK | Endereço físico |
| Tipo | enum | Próprio, Terceiros, Trânsito, Consignação |
| Capacidade | decimal(18,2) | Capacidade máxima |
| Responsavel | string(100) | Nome do responsável |
| Ativo | bool | Status |

### 3.2 Localizacao

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ArmazemId | FK | Armazém pai |
| Codigo | string(50) | Código da localização (ex: `A-01-03-02`) |
| Nome | string(100) | Descrição |
| Tipo | enum | Física, Virtual, Inspeção, Bloqueada, Trânsito |
| Capacidade | decimal(18,2) | Capacidade máxima |
| Ativo | bool | Status |

### 3.3 Lote

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| NumeroLote | string(50) | Número do lote |
| DataFabricacao | date | Data de fabricação |
| DataValidade | date | Data de validade |
| FornecedorId | FK | Fornecedor de origem |
| Status | enum | Ativo, Vencido, Bloqueado, Consumido |
| Observacao | text | Observações |

### 3.4 NumeroSerie

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| NumeroSerie | string(100) | Número de série (único por produto) |
| LoteId | FK | Lote pai (nullable) |
| Status | enum | Disponível, Reservado, Vendido, Manutenção, Devolvido, Sucateado |
| ArmazemId | FK | Armazém atual |
| LocalizacaoId | FK | Localização atual |
| DataEntrada | date | Data de entrada no estoque |
| DataSaida | date | Data de saída (nullable) |

### 3.5 EstoqueSaldo

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| ArmazemId | FK | Armazém |
| LocalizacaoId | FK | Localização (nullable) |
| LoteId | FK | Lote (nullable, se produto controla lote) |
| QuantidadeDisponivel | decimal(18,3) | Quantidade disponível (irrestrita) |
| QuantidadeReservada | decimal(18,3) | Quantidade reservada para pedidos |
| QuantidadeBloqueada | decimal(18,3) | Quantidade bloqueada (qualidade, inspeção) |
| CustoUnitario | decimal(18,4) | Custo unitário nesta posição |
| ValorTotal | decimal(18,4) | Valor total = Qtd × Custo |
| UltimaAtualizacao | timestamp | Data/hora da última atualização |

**Fórmula de disponibilidade:** `QuantidadeDisponivel = QuantidadeFisica - QuantidadeReservada - QuantidadeBloqueada`

### 3.6 MovimentacaoEstoque

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Numero | int | Número sequencial do documento |
| DataMovimentacao | timestamp | Data/hora da movimentação |
| TipoMovimentacao | enum | Entrada, Saída, Transferência, Ajuste, Devolução, Consignação |
| SubTipo | string(50) | Compra, Venda, TransferênciaInterna, AjusteGanho, AjustePerda, etc. |
| ProdutoId | FK | Produto movimentado |
| ArmazemOrigemId | FK | Armazém de origem (nullable para entradas) |
| LocalizacaoOrigemId | FK | Localização de origem (nullable) |
| ArmazemDestinoId | FK | Armazém de destino (nullable para saídas) |
| LocalizacaoDestinoId | FK | Localização de destino (nullable) |
| Quantidade | decimal(18,3) | Quantidade movimentada |
| UnidadeMedidaId | FK | Unidade de medida utilizada |
| CustoUnitario | decimal(18,4) | Custo unitário no momento da movimentação |
| CustoTotal | decimal(18,4) | Custo total |
| LoteId | FK | Referência ao lote (nullable) |
| NumeroSerieId | FK | Referência ao número de série (nullable) |
| DocumentoOrigem | string(100) | Referência ao documento de origem (nº pedido, NF, etc.) |
| DocumentoOrigemTipo | enum | PedidoCompra, PedidoVenda, OrdemTransferencia, Ajuste, Devolução |
| DocumentoOrigemId | guid | FK para o documento de origem |
| CFOP | string(4) | Código fiscal da operação |
| NotaFiscalId | FK | Referência à NF-e (nullable) |
| Observacao | text | Observações |
| UsuarioId | FK | Usuário que realizou a movimentação |
| Status | enum | Pendente, Confirmada, Cancelada |

### 3.7 ReservaEstoque

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| ArmazemId | FK | Armazém |
| LocalizacaoId | FK | Localização (nullable) |
| Quantidade | decimal(18,3) | Quantidade reservada |
| DocumentoOrigemTipo | enum | PedidoVenda, OrdemProducao, OrdemTransferencia |
| DocumentoOrigemId | guid | Referência ao documento |
| DataReserva | timestamp | Quando foi reservado |
| DataExpiracao | timestamp | Quando a reserva expira |
| Status | enum | Ativa, Liberada, Expirada, Cancelada |

### 3.8 OrdemTransferencia + Itens

**Cabeçalho:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Numero | int | Número sequencial |
| ArmazemOrigemId | FK | Armazém de origem |
| ArmazemDestinoId | FK | Armazém de destino |
| DataSolicitacao | date | Data da solicitação |
| DataPrevistaEnvio | date | Previsão de envio |
| DataEnvio | date | Data real de envio (nullable) |
| DataRecebimento | date | Data real de recebimento (nullable) |
| Status | enum | Rascunho, Aprovada, EmTransito, Recebida, Cancelada |
| SolicitanteId | FK | Usuário solicitante |
| Observacao | text | Observações |

**Itens:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| OrdemTransferenciaId | FK | Cabeçalho |
| ProdutoId | FK | Produto |
| QuantidadeSolicitada | decimal(18,3) | Quantidade solicitada |
| QuantidadeEnviada | decimal(18,3) | Quantidade enviada |
| QuantidadeRecebida | decimal(18,3) | Quantidade recebida |
| LoteId | FK | Lote (nullable) |

### 3.9 InventarioFisico + Itens

**Cabeçalho:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Numero | int | Número sequencial |
| ArmazemId | FK | Armazém sendo contado |
| DataAbertura | date | Início da contagem |
| DataFechamento | date | Conclusão da contagem (nullable) |
| Tipo | enum | Completo, Cíclico, ABC |
| Status | enum | Aberto, EmAndamento, PendenteAprovacao, Fechado, Cancelado |
| ResponsavelId | FK | Usuário responsável |
| Observacao | text | Observações |

**Itens:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| InventarioId | FK | Cabeçalho |
| ProdutoId | FK | Produto |
| LocalizacaoId | FK | Localização (nullable) |
| LoteId | FK | Lote (nullable) |
| QuantidadeSistema | decimal(18,3) | Quantidade no sistema no momento da contagem |
| QuantidadeContada | decimal(18,3) | Quantidade contada fisicamente |
| Divergencia | decimal(18,3) | Diferença (computada: Contada - Sistema) |
| CustoUnitario | decimal(18,4) | Custo unitário no momento |
| ValorDivergencia | decimal(18,4) | Valor da divergência |
| Status | enum | Pendente, Contado, Aprovado, Rejeitado |
| Justificativa | text | Justificativa para divergência |

### 3.10 EstoqueConsignado

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| ArmazemId | FK | Armazém onde o estoque está |
| Proprietario | enum | Fornecedor, Cliente |
| ProprietarioId | guid | ID do fornecedor ou cliente |
| Quantidade | decimal(18,3) | Quantidade em consignação |
| ContratoRef | string(100) | Referência do contrato |
| DataInicio | date | Data de início |
| DataFim | date | Data de término (nullable) |

### 3.11 EstoqueSaldoHistorico

| Campo | Tipo | Descrição |
|-------|------|-----------|
| DataSnapshot | date | Data do snapshot |
| ProdutoId | FK | Produto |
| ArmazemId | FK | Armazém |
| Quantidade | decimal(18,3) | Quantidade na data |
| CustoUnitario | decimal(18,4) | Custo unitário na data |
| ValorTotal | decimal(18,4) | Valor total = Qtd × Custo |

### 3.12 ConversaoUnidadeMedida

| Campo | Tipo | Descrição |
|-------|------|-----------|
| UnidadeMedidaOrigemId | FK | Unidade de origem |
| UnidadeMedidaDestinoId | FK | Unidade de destino |
| FatorConversao | decimal(18,6) | Fator de conversão |
| ProdutoId | FK | Produto específico (nullable = conversão global) |

### 3.13 ProdutoCodigoBarras

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| CodigoBarras | string(50) | Código de barras |
| Tipo | enum | EAN13, Code128, QRCode, Interno |
| Principal | bool | Se é o código principal |

### 3.14 ProdutoFornecedor

| Campo | Tipo | Descrição |
|-------|------|-----------|
| ProdutoId | FK | Produto |
| FornecedorId | FK | Fornecedor |
| CodigoNoFornecedor | string(50) | Código do produto no fornecedor |
| CustoUnitario | decimal(18,4) | Custo unitário neste fornecedor |
| LeadTimeDias | int | Prazo de entrega |
| QuantidadeMinimaPedido | decimal(18,3) | Quantidade mínima de pedido |
| Principal | bool | Se é o fornecedor principal |

---

## 4. Tipos de Movimentação

Baseado no SAP (simplificado de 300+ para 16 tipos):

| Código | Tipo | Descrição | SAP Equiv. |
|--------|------|-----------|------------|
| E01 | Entrada | Compra (vinculada a pedido de compra) | 101 |
| E02 | Entrada | Recebimento sem pedido | 501 |
| E03 | Entrada | Devolução de cliente | 651 |
| E04 | Entrada | Produção (entrada de produto acabado) | 101 (PP) |
| E05 | Entrada | Ajuste positivo (ganho de inventário) | 561 |
| E06 | Entrada | Consignação (entrada) | 101K |
| S01 | Saída | Venda/entrega | 601 |
| S02 | Saída | Consumo interno | 201 |
| S03 | Saída | Devolução ao fornecedor | 122 |
| S04 | Saída | Perda/sucata/avaria | 551 |
| S05 | Saída | Ajuste negativo (perda de inventário) | 562 |
| S06 | Saída | Amostra/doação | 201 |
| T01 | Transferência | Entre armazéns | 301/302 |
| T02 | Transferência | Entre localizações (mesmo armazém) | 311/312 |
| T03 | Transferência | Para inspeção de qualidade | 321/322 |
| T04 | Transferência | Bloqueio/desbloqueio de estoque | 343/344 |

---

## 5. Fluxos de Negócio Principais

### 5.1 Recebimento de Compra

```
Pedido de Compra (Módulo Compras)
    → Chegada da mercadoria no armazém
        → Conferência vs. Pedido (quantidade, produto, lote)
            → Inspeção de qualidade (opcional)
                → MovimentacaoEstoque tipo E01 (Compra)
                    → Atualiza EstoqueSaldo (+QuantidadeDisponivel)
                        → Recalcula custo (Custo Médio Ponderado)
                            → Vincula NF-e de entrada
```

**Passos detalhados:**
1. Pedido de compra aprovado e enviado ao fornecedor
2. Mercadoria chega no armazém de recebimento
3. Conferente escaneia itens e verifica vs. pedido (quantidade, produto, lote)
4. Sistema cria documento de "Recebimento Pendente"
5. Se inspeção necessária: estoque vai para localização virtual de inspeção
6. Após aprovação da qualidade: estoque move para armazenamento irrestrito
7. `MovimentacaoEstoque` criada (tipo E01)
8. `EstoqueSaldo` atualizado (incrementa `QuantidadeDisponivel`)
9. Custo recalculado (custo médio ponderado ou nova camada FIFO)
10. GRN (Nota de Recebimento) gerada para conferência com a NF-e

### 5.2 Venda/Expedição

```
Pedido de Venda (Módulo Vendas)
    → Verificação de disponibilidade
        → Reserva de estoque (ReservaEstoque)
            → Geração de Pick List
                → Separação (picking)
                    → Embalagem (packing)
                        → Emissão de NF-e
                            → MovimentacaoEstoque tipo S01 (Venda)
                                → Atualiza EstoqueSaldo (-QuantidadeDisponivel)
                                    → Libera reserva
```

**Passos detalhados:**
1. Pedido de venda confirmado
2. Sistema verifica disponibilidade por armazém
3. Estoque reservado (`QuantidadeReservada` incrementada)
4. Pick list gerada (rota otimizada pelo armazém)
5. Separador escaneia e confirma itens (lote/série validados)
6. Itens embalados e etiquetados
7. NF-e emitida com CFOP correto
8. `MovimentacaoEstoque` criada (tipo S01)
9. `EstoqueSaldo` atualizado (decrementa `QuantidadeDisponivel`, libera reserva)
10. Nota de entrega gerada

### 5.3 Transferência Interna

```
Solicitação de Transferência
    → Aprovação (se necessário)
        → Separação no armazém de origem
            → Em Trânsito (localização virtual)
                → Recebimento no armazém de destino
                    → MovimentacaoEstoque tipo T01 (nos dois armazéns)
```

**Dois métodos:**
- **Uma etapa**: Transferência imediata (mesmo local, entre localizações)
- **Duas etapas**: Envio + Recebimento (entre armazéns distantes, com tempo de trânsito)

### 5.4 Inventário Físico

```
Criar documento de Inventário
    → Sistema popula quantidades esperadas (EstoqueSaldo)
        → Operadores contam fisicamente
            → Registram quantidades contadas
                → Sistema calcula divergências
                    → Supervisor revisa e aprova/rejeita
                        → Gera MovimentacaoEstoque (E05 ganho ou S05 perda)
                            → Atualiza EstoqueSaldo
```

**Dois tipos:**
- **Contagem Completa**: Congela operações, conta tudo. Tipicamente anual (exigência fiscal)
- **Contagem Cíclica**: Conta subconjunto regularmente. Baseada em ABC: itens A semanalmente, C trimestralmente. Sem parada de operações

### 5.5 Devoluções

**Devolução de Cliente:**
1. Autorização de devolução (RMA) criada
2. Cliente envia mercadoria de volta
3. Recebimento e inspeção
4. Decisão: reestocar (condição A), recuperar ou sucatear
5. Se reestocado: `MovimentacaoEstoque` tipo E03
6. Se sucateado: `MovimentacaoEstoque` tipo S04
7. NF-e de devolução emitida (CFOP 1.202 / 2.202)

**Devolução ao Fornecedor:**
1. Problema de qualidade identificado
2. Autorização do fornecedor
3. NF-e de devolução emitida (CFOP 5.202 / 6.202)
4. `MovimentacaoEstoque` tipo S03
5. Nota de débito emitida

### 5.6 Ajustes de Estoque

**Motivos:** divergência de inventário, avaria, furto, vencimento, reclassificação.

1. Motivo selecionado (da tabela `MotivoAjuste`)
2. Ajuste positivo: tipo E05 (ganho) / Negativo: tipo S05 (perda)
3. Aprovação do supervisor (threshold configurável)
4. `MovimentacaoEstoque` criada com justificativa
5. `EstoqueSaldo` atualizado
6. Impacto no custo calculado
7. Para compliance fiscal: pode exigir NF-e (CFOP 5.927 para baixa)

---

## 6. Métodos de Custeio

| Método | Funcionamento | Uso no Brasil |
|--------|---------------|---------------|
| **Custo Médio Ponderado** | `Novo Custo = (Qtd Atual × Custo Atual + Qtd Nova × Custo Novo) / (Qtd Atual + Qtd Nova)` | **Mais comum.** Aceito pela Receita Federal |
| **FIFO** (PEPS) | Custo das unidades mais antigas consumido primeiro. Requer manter "camadas" de custo | Aceito pelo IFRS. Obrigatório em alguns setores |
| **Custo Padrão** | Custo pré-determinado; variações registradas separadamente | Ambientes industriais |
| **LIFO** (UEPS) | Custo das unidades mais recentes consumido primeiro | **Proibido** no Brasil (IFRS e legislação fiscal) |
| **Identificação Específica** | Custo real por unidade/lote rastreado | Itens de alto valor, rastreados por série |

**Notas de implementação:**
- **FIFO**: Cada recebimento cria uma nova "camada de custo" consumida em ordem cronológica
- **Custo Médio**: Recalcula automaticamente após cada entrada de compra
- **Custo Padrão**: Requer conta contábil separada para variações de preço
- O campo `MetodoCusteio` no Produto determina qual método é aplicado

---

## 7. Relatórios e KPIs

### 7.1 Relatórios Padrão

| Relatório | Descrição | Fonte de Dados |
|-----------|-----------|---------------|
| **Posição de Estoque** | Saldo atual por produto por armazém | `EstoqueSaldo` |
| **Histórico de Movimentações** | Todas as movimentações em um período | `MovimentacaoEstoque` |
| **Estoque por Validade (Aging)** | Produtos agrupados por proximidade do vencimento | `Lote` + `EstoqueSaldo` |
| **Curva ABC** | Produtos classificados por valor de consumo | `MovimentacaoEstoque` (saídas) agregado |
| **Estoque Mínimo/Crítico** | Itens abaixo do ponto de reposição | `EstoqueSaldo` vs `Produto.PontoReposicao` |
| **Giro de Estoque (Turnover)** | Velocidade de renovação do estoque | `MovimentacaoEstoque` / `EstoqueSaldo` |
| **Estoque Morto (Dead Stock)** | Itens sem movimentação em X dias | `MovimentacaoEstoque` com análise de datas |
| **Divergências de Inventário** | Resultados das contagens físicas | `InventarioFisicoItem` |
| **Valoração de Estoque** | Valor total do estoque por método de custeio | `EstoqueSaldo` × custo |
| **Movimentação por CFOP** | Relatório fiscal de movimentações | `MovimentacaoEstoque` agrupado por CFOP |
| **Rastreabilidade de Lote** | Rastreio completo de um lote na cadeia | `MovimentacaoEstoque` filtrado por `LoteId` |
| **Estoque Consignado** | Posição de estoque em consignação | `EstoqueConsignado` |

### 7.2 KPIs do Dashboard

**KPIs Financeiros:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Giro de Estoque** | CMV / Estoque Médio | Quanto maior, melhor (depende do setor) |
| **Dias de Estoque (DSI)** | 365 / Giro de Estoque | Quanto menor, melhor |
| **GMROI** | Lucro Bruto / Custo Médio de Estoque | > 1.0 |
| **Custo de Manutenção** | (Capital + Risco + Armazenagem + Serviço) / Valor Total × 100 | Tipicamente 20-30% |
| **Quebra (Shrinkage)** | (Estoque Sistema - Estoque Físico) / Estoque Sistema × 100 | < 2% |

**KPIs Operacionais:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Taxa de Ruptura (Stockout)** | SKUs sem estoque / Total SKUs × 100 | < 2% |
| **Fill Rate** | Pedidos atendidos integralmente / Total Pedidos × 100 | > 95% |
| **Taxa de Pedido Perfeito** | Pedidos sem erros / Total Pedidos × 100 | > 90% |
| **Taxa de Backorder** | Pedidos em espera / Total Pedidos × 100 | < 5% |
| **Sell-Through Rate** | Unidades vendidas / Unidades recebidas × 100 | Depende do setor |
| **Semanas de Cobertura** | Estoque em Mãos / Venda Média Semanal | Equilíbrio |
| **Estoque Morto %** | Itens sem mov. 180+ dias / Total Itens × 100 | < 10% |

**KPIs de Recebimento:**

| KPI | Fórmula | Meta |
|-----|---------|------|
| **Tempo de Recebimento** | Tempo médio da doca até a prateleira | < 24 horas |
| **Acuracidade de Recebimento** | Recebimentos corretos / Total Recebimentos × 100 | > 99% |
| **Acuracidade de Contagem** | Itens corretos na contagem / Total Itens × 100 | > 95% |

### 7.3 Design do Dashboard

Um dashboard de estoque típico deve exibir:
- **Barra superior**: Valor total do estoque, total de SKUs, total de armazéns
- **Cards de KPIs**: Giro, DSI, taxa de ruptura, fill rate
- **Gráficos**: Tendência de valor (linha), distribuição ABC (Pareto/pizza), volume por tipo de movimentação (barras)
- **Alertas**: Itens abaixo do ponto de reposição, lotes vencendo, contagens pendentes, estoque morto
- **Tabela**: Top 10 mais movimentados, top 10 menos movimentados

---

## 8. Padrões Arquiteturais Recomendados

### 8.1 Double-Entry Stock (padrão Odoo)

Toda movimentação = transferência entre duas localizações (física ou virtual):
- **Compra**: Localização Fornecedor (virtual) → Armazém (físico)
- **Venda**: Armazém → Localização Cliente (virtual)
- **Transferência**: Armazém A → Armazém B
- **Perda**: Armazém → Localização Perda (virtual)
- **Produção**: Matéria-Prima → Produção → Produto Acabado

**Benefícios:**
- Soma de todo estoque (incluindo localizações virtuais) = sempre zero
- Detecção de erros embutida (desbalanceamentos indicam problemas)
- Modelo unificado para todos os tipos de movimentação
- Trilha de auditoria clara
- Permite valoração sofisticada rastreando fluxo de custo

### 8.2 Event Sourcing (padrão CQRS)

- `MovimentacaoEstoque` = **event store** (append-only, imutável)
- `EstoqueSaldo` = **projeção materializada** (atualizada em tempo real)
- Cancelamentos geram movimentação reversa (nunca DELETE)
- Snapshots periódicos em `EstoqueSaldoHistorico` para evitar replay de milhares de eventos

**Eventos de domínio:**
- `EstoqueRecebido` — mercadoria entrou no estoque
- `EstoqueExpedido` — mercadoria saiu do estoque
- `EstoqueTransferido` — mercadoria movida entre localizações
- `EstoqueAjustado` — correção aplicada
- `EstoqueReservado` — quantidade reservada para pedido
- `ReservaLiberada` — reserva cancelada/cumprida
- `CustoRecalculado` — custo unitário atualizado

**Compatibilidade:** Encaixa perfeitamente no CQRS + MediatR existente no projeto.

### 8.3 Concorrência

- **Pessimistic locking** (`SELECT FOR UPDATE`) para itens de alta movimentação
- **Optimistic concurrency** (coluna de versão) para reservas
- Mesma transação para `INSERT MovimentacaoEstoque` + `UPDATE EstoqueSaldo`

```sql
-- Exemplo: Pessimistic locking para atualização de saldo
BEGIN;
SELECT * FROM estoque_saldo
WHERE produto_id = @produtoId AND armazem_id = @armazemId
FOR UPDATE;

UPDATE estoque_saldo
SET quantidade_disponivel = quantidade_disponivel - @quantidade,
    ultima_atualizacao = NOW()
WHERE produto_id = @produtoId AND armazem_id = @armazemId
  AND quantidade_disponivel >= @quantidade;

-- Se affected rows = 0, estoque insuficiente → rollback
INSERT INTO movimentacao_estoque (...) VALUES (...);
COMMIT;
```

### 8.4 Híbrido Real-Time + Batch

- **Real-time**: `EstoqueSaldo` atualizado sincronamente a cada movimentação (operacional)
- **Batch noturno**: `EstoqueSaldoHistorico` — snapshots diários para analytics e SPED
- **Materialized Views**: Para relatórios pesados (posição consolidada, curva ABC)

```sql
-- Exemplo: Materialized View para posição de estoque
CREATE MATERIALIZED VIEW mv_estoque_posicao AS
SELECT
    p.id as produto_id, p.nome as produto_nome, p.sku,
    a.id as armazem_id, a.nome as armazem_nome,
    es.quantidade_disponivel, es.quantidade_reservada, es.quantidade_bloqueada,
    es.custo_unitario,
    (es.quantidade_disponivel * es.custo_unitario) as valor_disponivel,
    p.estoque_minimo, p.ponto_reposicao,
    CASE
        WHEN es.quantidade_disponivel <= 0 THEN 'SemEstoque'
        WHEN es.quantidade_disponivel <= p.estoque_minimo THEN 'Critico'
        WHEN es.quantidade_disponivel <= p.ponto_reposicao THEN 'BaixoEstoque'
        ELSE 'Normal'
    END as situacao
FROM estoque_saldo es
JOIN produtos p ON es.produto_id = p.id
JOIN armazens a ON es.armazem_id = a.id;

-- Refresh após batch de movimentações ou por agendamento
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_estoque_posicao;
```

### 8.5 Trilha de Auditoria

Toda movimentação de estoque deve registrar:
- **Quem**: ID do usuário, timestamp
- **O quê**: Produto, quantidade, custo
- **Onde**: Localizações de origem e destino
- **Por quê**: Referência ao documento, tipo de movimentação, motivo
- **Quando**: Data/hora da movimentação

**Requisitos de compliance:**
- Movimentações são **imutáveis** — cancelamentos criam movimentações reversas, nunca DELETE
- Todas as alterações em dados mestres (produto, armazém) registradas na tabela de auditoria
- Retenção mínima: 5 anos (exigência fiscal brasileira) ou 7 anos (SOX)
- Numeração sequencial sem lacunas para compliance fiscal

---

## 9. Requisitos Fiscais Brasileiros

### 9.1 NF-e e Movimentação

Toda entrada/saída física de mercadorias requer NF-e:

| Operação | NF-e Necessária | Direção |
|----------|-----------------|---------|
| Recebimento de compra | Sim (fornecedor emite) | Entrada |
| Venda/entrega | Sim (empresa emite) | Saída |
| Transferência entre filiais | Sim | Saída + Entrada |
| Devolução de cliente | Sim (cliente ou empresa emite) | Entrada |
| Devolução ao fornecedor | Sim (empresa emite) | Saída |
| Baixa de estoque (perda) | Sim (CFOP 5.927) | Saída |
| Envio de consignação | Sim | Saída |
| Amostra/demonstração | Sim | Saída |
| Transferência interna (mesmo CNPJ, mesmo local) | Não | Interna |

A `MovimentacaoEstoque` deve armazenar `NotaFiscalId` e `CFOP` para todas as movimentações fiscalmente relevantes.

### 9.2 CFOPs Relevantes

CFOP (Código Fiscal de Operações e Prestações) — 4 dígitos obrigatórios em toda NF-e:

| Primeiro Dígito | Significado |
|-----------------|-------------|
| 1.xxx | Entrada — dentro do estado |
| 2.xxx | Entrada — de outro estado |
| 3.xxx | Entrada — do exterior |
| 5.xxx | Saída — dentro do estado |
| 6.xxx | Saída — para outro estado |
| 7.xxx | Saída — para o exterior |

**CFOPs principais para operações de estoque:**

| CFOP | Operação |
|------|----------|
| 1.102 / 2.102 | Compra de mercadoria para revenda |
| 1.202 / 2.202 | Devolução de cliente (mercadoria vendida anteriormente) |
| 1.409 / 2.409 | Transferência de mercadoria entre filiais (entrada) |
| 1.551 / 2.551 | Compra de ativo imobilizado |
| 1.556 / 2.556 | Compra de material de uso e consumo |
| 1.917 / 2.917 | Consignação (entrada) |
| 5.102 / 6.102 | Venda de mercadoria |
| 5.202 / 6.202 | Devolução ao fornecedor |
| 5.409 / 6.409 | Transferência de mercadoria entre filiais (saída) |
| 5.551 / 6.551 | Venda de ativo imobilizado |
| 5.910 / 6.910 | Envio de amostra/brinde |
| 5.917 / 6.917 | Consignação (saída) |
| 5.927 | Baixa de estoque (perda, avaria, furto) |
| 5.949 / 6.949 | Outra saída não especificada |

### 9.3 ICMS

- **ICMS** (Imposto sobre Circulação de Mercadorias e Serviços): Imposto estadual sobre movimentação de mercadorias
- Toda movimentação que cruza fronteiras estaduais tem implicações de ICMS
- **ICMS-ST** (Substituição Tributária): Imposto recolhido antecipadamente pelo fabricante/importador
  - Ao receber mercadoria com ST, o comprador já pagou ICMS embutido no preço de compra
  - Deve rastrear estoque ST separadamente para apuração fiscal
  - Ao mudar regime (sem-ST → com-ST), exige "levantamento de estoque"
- **Origem fiscal** do produto (nacional vs. importado) afeta o cálculo do ICMS
- **NCM** determina alíquotas e políticas comerciais

### 9.4 SPED Fiscal — Bloco H (Registro de Inventário)

Empresas brasileiras devem submeter dados de inventário à Receita via SPED Fiscal (EFD ICMS/IPI):

**Estrutura do Bloco H:**
- **H001**: Abertura do bloco
- **H005**: Totais do inventário (data, valor total, motivo)
- **H010**: Detalhes por item (produto, quantidade, unidade, valor unitário, valor total, indicador de propriedade)
- **H020**: Informações complementares (base ICMS-ST, ICMS próprio, ICMS-ST)
- **H990**: Fechamento do bloco

**Frequência:**
- Lucro Real: trimestral (31/mar, 30/jun, 30/set, 31/dez)
- Lucro Presumido / Simples Nacional: anual (31/dez)
- Transmissão em até 60 dias após o encerramento do período

**Penalidades por descumprimento:**
- Falta de envio: multa de 1% sobre o valor do estoque
- Envio atrasado: 0,02% por dia sobre a receita bruta

**Requisito do sistema:** O ERP deve gerar dados do Bloco H no formato exigido, usando `EstoqueSaldoHistorico` + dados mestres do produto + classificação fiscal.

### 9.5 Outros Requisitos Brasileiros

- **CEST** (Código Especificador da Substituição Tributária): Obrigatório para produtos com ST
- **EAN/GTIN**: Obrigatório para emissão de NF-e
- **Inventário fiscal vs. gerencial**: Inventário fiscal segue regras específicas (custo por CFOP), enquanto o gerencial pode usar métodos diferentes
- **Livro Registro de Inventário**: Livro legal que deve coincidir com o SPED Bloco H

---

## 10. Comparativo com ERPs de Referência

| Aspecto | SAP S/4HANA | Oracle EBS | Odoo 19 | TOTVS Protheus | **OpticalCore (proposta)** |
|---------|-------------|------------|---------|----------------|---------------------------|
| Hierarquia | Plant > Storage Location > Bin | Org > Subinventory > Locator | Warehouse > Location (hierárquico + virtual) | Filial > Armazém > Endereço | Armazem > Localizacao |
| Movimentações | 300+ tipos | Transaction Types | stock.move (source→dest) | SD3 | 16 tipos codificados |
| Tabela de Saldo | MARC/MARD | MTL_ONHAND | stock.quant | SB2 | EstoqueSaldo |
| Double-entry | Não | Não | **Sim** | Não | **Sim** (recomendado) |
| Custeio | Standard/Moving Avg | Standard/Avg/FIFO | Standard/Avg/FIFO | Médio/FIFO/Padrão | Médio/FIFO/Padrão |
| Lote/Série | Sim | Sim | Sim | Sim (SB8/SD5) | Sim |
| Produto Master | Material Master (25+ views) | MTL_SYSTEM_ITEMS_B | product.template | SB1 | Produto |
| Reserva | Sim | MTL_RESERVATIONS | stock.move (draft) | Sim | ReservaEstoque |
| Inventário | Physical Inventory Doc | Cycle Count | Inventory Adjustment | Processo de Inventário | InventarioFisico |

---

## 11. Priorização Sugerida para Implementação

### Fase 1 — Fundação (MVP)

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 1 | Produto | Cadastro completo com todos os campos mestres |
| 2 | Armazem | Cadastro de armazéns/depósitos |
| 3 | Localizacao | Endereços dentro dos armazéns |
| 4 | MovimentacaoEstoque | Entradas, saídas e ajustes manuais |
| 5 | EstoqueSaldo | Saldo em tempo real (projeção) |
| 6 | Relatório: Posição de Estoque | Consulta de saldos por produto/armazém |

### Fase 2 — Operacional

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 7 | OrdemTransferencia + Itens | Transferências planejadas entre armazéns |
| 8 | ReservaEstoque | Reservas para pedidos de venda |
| 9 | InventarioFisico + Itens | Contagem física e ajustes |
| 10 | Lote | Rastreamento de lotes |
| 11 | NumeroSerie | Rastreamento de números de série |
| 12 | Relatórios: Movimentações, Estoque Mínimo | Relatórios operacionais |

### Fase 3 — Avançado

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 13 | ConversaoUnidadeMedida | Conversões de unidades de medida |
| 14 | ProdutoCodigoBarras | Múltiplos códigos de barras |
| 15 | ProdutoFornecedor | Relação produto-fornecedor |
| 16 | Curva ABC automática | Cálculo e classificação automática |
| 17 | EstoqueSaldoHistorico | Snapshots diários para relatórios |
| 18 | EstoqueConsignado | Controle de consignação |
| 19 | Dashboard com KPIs completos | Painel gerencial |

### Fase 4 — Fiscal

| # | Entidade/Feature | Descrição |
|---|------------------|-----------|
| 20 | Integração NF-e | CFOP em movimentações, vínculo com NF-e |
| 21 | Geração Bloco H | SPED Fiscal — registro de inventário |
| 22 | Rastreabilidade completa | Rastreio de lote end-to-end |

---

## 12. Fontes da Pesquisa

### Arquitetura e Design de Banco de Dados
- Redgate — Creating a Database Model for an Inventory Management System
- GeeksforGeeks — How to Design ER Diagrams for Inventory and Warehouse Management
- System Design Handbook — Design Inventory Management System
- Kladana — ER Diagram for Inventory Management System

### SAP
- SAP S/4HANA Inventory Management Module Overview (ERPResearch)
- SAP Inventory Management (TutorialsPoint)
- SAP Good Movement Types (SAP Community)
- SAP WM Complete Guide (FocusTribes)

### Oracle
- Oracle Apps Inventory Tables R12 (Enodeas)
- Oracle MTL_ONHAND_QUANTITIES_DETAIL (Oracle Docs)

### Odoo
- Odoo Inventory Features
- Odoo Double-Entry Stock Management (OpenERP 6.1 Docs)
- Odoo Inventory Management Documentation v19

### TOTVS Protheus
- TOTVS Protheus — Estoque e Custos
- TOTVS — Conceito e tabelas de controle de Lote e Endereço
- TOTVS — Processo de Inventário
- EPV Consulting — Tabelas do Protheus

### Event Sourcing e Padrões
- Azure Architecture Center — Event Sourcing Pattern
- Salesforce Engineering — Event Sourcing for Inventory Availability
- Martin Fowler — Event Sourcing
- Walmart Global Tech — Design Inventory Availability with Event Sourcing
- Tinybird — Real-Time Inventory Management with Lambda Architecture

### KPIs e Relatórios
- NetSuite — 33 Inventory Management KPIs
- AltexSoft — Inventory KPIs: Turnover, Return Rate, Shrinkage
- MRPeasy — 11 Inventory Management KPIs in 2026
- Deskera — 27 Inventory Management KPIs
- NetSuite — ABC Inventory Analysis

### Operações
- Finale Inventory — Inventory Costing Methods
- NetSuite — FIFO LIFO Average Costing Comparison
- NetSuite — Cycle Counting Best Practices
- NetSuite — Reverse Logistics
- Zapro — Managing Returns in Inventory 2026
- Pulpo WMS — Lot Number Control
- Shipedge — Serial Numbers, Lot Numbers, Batch Numbers
- Mar-Kov — Unit of Measure Conversion in ERP
- Oracle — Defining UOM Conversions
- NetSuite — Consignment Inventory
- Aptean — Consignment Inventory Management
- Modulus 365 — Pick Pack Ship from ERP
- Shopify — Barcode Inventory Management 2026

### Concorrência e Performance
- WJAETS — Isolation Levels and Locking Strategies for Inventory

### Fiscal Brasileiro
- Contabilizei — Tabela CFOP Completa
- FocusNFe — CFOP Códigos Fiscais
- VHSys — CFOP Tabela Completa 2026
- TOTVS Espaço Legislação — Bloco H EFD ICMS/IPI
- TecnoSpeed — Bloco H SPED Fiscal
- e-Auditoria — Inventário no SPED Fiscal Bloco H
- Portal Tributário — ICMS

### Auditoria
- InScope — Audit Trail Requirements and Best Practices
