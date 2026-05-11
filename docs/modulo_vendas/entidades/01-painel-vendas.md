# Entidade: Painel de Vendas (Dashboard)

## Objetivo

Dashboard consolidado com KPIs, gráficos de tendência, ranking de clientes/produtos/vendedores e alertas operacionais do módulo de Vendas.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/dashboard-vendas` | Retorna todos os KPIs e gráficos |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.View`

---

## Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|:-----------:|-----------:|
| `dataInicio` | DateTime | Não | Início do período (padrão: 12 meses atrás) |
| `dataFim` | DateTime | Não | Fim do período (padrão: hoje) |

---

## KPIs Retornados

### Orçamentos
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalOrcamentos` | int | Total de orçamentos no período |
| `orcamentosRascunho` | int | Em rascunho |
| `orcamentosEnviados` | int | Enviados ao cliente |
| `orcamentosEmNegociacao` | int | Em negociação |
| `orcamentosAprovados` | int | Aprovados |
| `orcamentosConvertidos` | int | Convertidos em pedido |
| `orcamentosCancelados` | int | Cancelados |
| `valorTotalOrcamentosAbertos` | decimal | Valor total dos orçamentos em aberto |

### Pedidos de Venda
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalPedidosVenda` | int | Total de pedidos |
| `pedidosPedido` | int | Aguardando aprovação |
| `pedidosAprovados` | int | Aprovados |
| `pedidosFaturados` | int | Faturados |
| `pedidosCancelados` | int | Cancelados |
| `valorTotalPedidosAbertos` | decimal | Valor total em aberto (Pedido + Aprovado) |

### Entregas e Devoluções
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `totalEntregas` | int | Total de entregas |
| `entregasPendentes` | int | Pendentes de despacho |
| `entregasEmTransito` | int | Em trânsito |
| `entregasConcluidas` | int | Entregues |
| `totalDevolucoes` | int | Total de devoluções |
| `devolucoesPendentes` | int | Pendentes de análise |
| `devolucoesRecebidas` | int | Recebidas |

### Indicadores Operacionais
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `margemBrutaPercentual` | decimal | Margem bruta média |
| `taxaDevolucoes` | decimal | Taxa de devoluções (%) |
| `descontoMedioPercentual` | decimal | Desconto médio concedido (%) |
| `comissoesDoPeriodo` | decimal | Total de comissões |
| `totalFaturamentos` | int | Total de faturamentos |
| `faturamentosAutorizados` | int | Faturamentos autorizados |

### Indicadores Estratégicos
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `taxaConversaoOrcPedido` | decimal | Taxa de conversão orçamento → pedido (%) |
| `metaVsRealizadoPercentual` | decimal | Atingimento das metas (%) |
| `prazoMedioEntregaDias` | decimal | Prazo médio de entrega (dias) |
| `novosClientesPeriodo` | int | Novos clientes no período |
| `pedidosPorVendedorMedia` | decimal | Média de pedidos por vendedor |

### Analytics Avançados
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `clvMedio` | decimal | Customer Lifetime Value médio |
| `cac` | decimal | Custo de aquisição de cliente |
| `relacaoClvCac` | decimal | Relação CLV/CAC |
| `cicloMedioVendasDias` | decimal | Ciclo médio de vendas (dias) |
| `pipelineCoverage` | decimal | Cobertura do pipeline |
| `receitaPorVendedor` | decimal | Receita média por vendedor |
| `indiceRecorrencia` | decimal | Índice de recorrência de compra |
| `taxaCancelamento` | decimal | Taxa de cancelamento (%) |
| `faturamentoAcumuladoYtd` | decimal | Faturamento acumulado no ano |
| `ticketMedio` | decimal | Ticket médio |
| `valorCarteira` | decimal | Valor da carteira de pedidos |
| `pedidosAtrasados` | int | Pedidos com entrega atrasada |

---

## Gráficos

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `vendasMensais` | array | Últimos 12 meses: `{ mes, valorTotal, totalPedidos }` |
| `topClientes` | array | Top 10: `{ clienteId, clienteNome, valorTotal, totalPedidos }` |
| `topProdutos` | array | Top 10: `{ produtoId, produtoNome, valorTotal, quantidadeTotal, totalPedidos }` |
| `vendasPorCanal` | array | Por canal: `{ canalVendaId, canalVendaNome, valorTotal, totalPedidos, percentualParticipacao }` |
| `margensMensais` | array | Últimos 12 meses: `{ mes, margemPercentual }` |
| `performanceVendedores` | array | Meta vs realizado: `{ vendedorId, vendedorNome, metaValor, realizadoValor }` |
| `alertasOperacionais` | array | Alertas: `{ tipo, mensagem, nivel, quantidade }` |
