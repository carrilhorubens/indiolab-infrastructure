# Módulo de Vendas — Documentação Completa

> Documentação de todas as entidades, operações e relatórios do módulo de Vendas do OpticalCore ERP.

---

## Índice de Entidades e Operações

| # | Entidade/Operação | Arquivo | Descrição |
|---|-------------------|---------|-----------|
| 01 | Painel de Vendas | [entidades/01-painel-vendas.md](entidades/01-painel-vendas.md) | Dashboard com KPIs, gráficos e alertas operacionais |
| 02 | Pedidos de Venda | [entidades/03-pedidos-venda.md](entidades/03-pedidos-venda.md) | Ciclo completo de vendas com 9 estados |
| 04 | Entregas de Venda | [entidades/04-entregas-venda.md](entidades/04-entregas-venda.md) | Separação, expedição e entrega |
| 05 | Devoluções de Venda | [entidades/05-devolucoes-venda.md](entidades/05-devolucoes-venda.md) | Devoluções com crédito e retorno ao estoque |
| 06 | Faturamentos de Venda | [entidades/06-faturamentos-venda.md](entidades/06-faturamentos-venda.md) | Emissão de NF-e com dados fiscais completos |
| 07 | Tabelas de Preço | [entidades/07-tabelas-preco.md](entidades/07-tabelas-preco.md) | Política de preços com vigência e prioridade |
| 08 | Regras de Comissão | [entidades/08-regras-comissao.md](entidades/08-regras-comissao.md) | 5 tipos de cálculo com faixas escalonadas |
| 09 | Comissões de Venda | [entidades/09-comissoes-venda.md](entidades/09-comissoes-venda.md) | Cálculo, aprovação e pagamento de comissões |
| 10 | Regiões de Venda | [entidades/10-regioes-venda.md](entidades/10-regioes-venda.md) | Segmentação territorial por UFs |
| 11 | Metas de Venda | [entidades/11-metas-venda.md](entidades/11-metas-venda.md) | Metas com desdobramento e acompanhamento |
| 12 | Histórico de Preços | [entidades/12-historico-precos-venda.md](entidades/12-historico-precos-venda.md) | Evolução de preços praticados (write-once) |
| 13 | Log de Descontos Especiais | [entidades/13-log-descontos-especiais.md](entidades/13-log-descontos-especiais.md) | Aprovação de descontos acima do limite |
| 14 | Aprovações de Pedido | [entidades/14-aprovacoes-pedido.md](entidades/14-aprovacoes-pedido.md) | Histórico de aprovações por alçada |

---

## Índice de Relatórios

### Relatórios Operacionais

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 01 | Vendas por Período | [relatorios/01-vendas-por-periodo.md](relatorios/01-vendas-por-periodo.md) | Histórico de pedidos no período |
| 02 | Carteira de Pedidos | [relatorios/02-carteira-pedidos.md](relatorios/02-carteira-pedidos.md) | Pedidos abertos/em andamento |
| 15 | Devoluções de Venda | [relatorios/15-devolucoes-venda.md](relatorios/15-devolucoes-venda.md) | Devoluções por motivo e produto |
| 16 | Cancelamentos | [relatorios/16-cancelamentos.md](relatorios/16-cancelamentos.md) | Pedidos cancelados por motivo |

### Relatórios por Dimensão

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 03 | Vendas por Cliente | [relatorios/03-vendas-por-cliente.md](relatorios/03-vendas-por-cliente.md) | Volume e valor por cliente |
| 04 | Vendas por Produto | [relatorios/04-vendas-por-produto.md](relatorios/04-vendas-por-produto.md) | Receita bruta/líquida por produto |
| 05 | Vendas por Vendedor | [relatorios/05-vendas-por-vendedor.md](relatorios/05-vendas-por-vendedor.md) | Performance e comissão por vendedor |
| 06 | Vendas por Região | [relatorios/06-vendas-por-regiao.md](relatorios/06-vendas-por-regiao.md) | Receita por região territorial |
| 07 | Vendas por Canal | [relatorios/07-vendas-por-canal.md](relatorios/07-vendas-por-canal.md) | Receita por canal de venda |

### Relatórios Analíticos

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 08 | Lucratividade por Produto | [relatorios/08-lucratividade-produto.md](relatorios/08-lucratividade-produto.md) | Margem bruta por produto |
| 09 | Curva ABC de Clientes | [relatorios/09-curva-abc-clientes.md](relatorios/09-curva-abc-clientes.md) | Classificação A/B/C por receita |
| 10 | Curva ABC de Produtos | [relatorios/10-curva-abc-produtos.md](relatorios/10-curva-abc-produtos.md) | Classificação A/B/C por receita |
| 11 | Análise de Descontos | [relatorios/11-analise-descontos.md](relatorios/11-analise-descontos.md) | Descontos regulares e especiais |
| 12 | Funil de Vendas | [relatorios/12-funil-vendas.md](relatorios/12-funil-vendas.md) | Conversão pedido → faturamento |
| 13 | Forecast | [relatorios/13-forecast.md](relatorios/13-forecast.md) | Projeção de vendas futuras |
| 14 | Variação de Preços | [relatorios/14-variacao-precos.md](relatorios/14-variacao-precos.md) | Evolução histórica de preços |
| 20 | Ticket Médio | [relatorios/20-ticket-medio.md](relatorios/20-ticket-medio.md) | Ticket médio por dimensão |

### Relatórios de Comissões e Metas

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 17 | Comissões por Vendedor | [relatorios/17-comissoes-por-vendedor.md](relatorios/17-comissoes-por-vendedor.md) | Comissões detalhadas |
| 18 | Resumo Comissões Período | [relatorios/18-resumo-comissoes-periodo.md](relatorios/18-resumo-comissoes-periodo.md) | Consolidado por vendedor |
| 19 | Metas vs Realizado | [relatorios/19-metas-vs-realizado.md](relatorios/19-metas-vs-realizado.md) | Comparativo meta × atingimento |

### Customer Analytics (Fase 4)

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 21 | Frequência de Compra | [relatorios/21-frequencia-compra.md](relatorios/21-frequencia-compra.md) | Padrão de compra por cliente |
| 22 | Análise RFM | [relatorios/22-analise-rfm.md](relatorios/22-analise-rfm.md) | Segmentação Recência/Frequência/Monetário |
| 23 | Análise de Coorte | [relatorios/23-analise-coorte.md](relatorios/23-analise-coorte.md) | Retenção de clientes ao longo do tempo |
| 24 | Customer Lifetime Value | [relatorios/24-customer-lifetime-value.md](relatorios/24-customer-lifetime-value.md) | Valor do ciclo de vida do cliente |
| 25 | Score de Churn | [relatorios/25-score-churn.md](relatorios/25-score-churn.md) | Risco de perda de clientes |
| 26 | Sazonalidade | [relatorios/26-sazonalidade.md](relatorios/26-sazonalidade.md) | Padrões sazonais de vendas |
| 27 | Cross-sell / Up-sell | [relatorios/27-cross-sell.md](relatorios/27-cross-sell.md) | Produtos comprados juntos |

---

## Base URL

- **Entidades (01-14):** `GET/POST/PUT/DELETE /api/{entidade}`
- **Dashboard (01):** `GET /api/dashboard-vendas`
- **Relatórios (01-27):** `GET /api/relatorios-vendas/{endpoint}`

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.*`

---

## Classificação por Categoria

### Cadastros
- Tabelas de Preço — política de preços com vigência e prioridade
- Regras de Comissão — 5 tipos de cálculo de comissão
- Regiões de Venda — segmentação territorial
- Metas de Venda — definição e acompanhamento de metas

### Operações
- Pedidos de Venda — ciclo completo com 9 estados
- Entregas de Venda — separação, expedição e entrega
- Faturamentos de Venda — emissão de NF-e
- Devoluções de Venda — devoluções com crédito
- Comissões de Venda — cálculo e pagamento

### Audit Trail
- Histórico de Preços — evolução de preços (write-once)
- Log de Descontos Especiais — aprovação de descontos
- Aprovações de Pedido — histórico por alçada

### Consultas
- Painel de Vendas — dashboard com KPIs, gráficos e alertas

### Relatórios Operacionais (4)
- Vendas por Período, Carteira de Pedidos, Devoluções, Cancelamentos

### Relatórios por Dimensão (5)
- Por Cliente, Por Produto, Por Vendedor, Por Região, Por Canal

### Relatórios Analíticos (8)
- Lucratividade, Curva ABC (Clientes/Produtos), Descontos, Funil, Forecast, Variação de Preços, Ticket Médio

### Relatórios de Comissões e Metas (3)
- Comissões por Vendedor, Resumo Comissões, Metas vs Realizado

### Customer Analytics (7)
- Frequência de Compra, RFM, Coorte, CLV, Churn, Sazonalidade, Cross-sell

---

## Referência Completa

Para pesquisa detalhada com entidades, campos, ciclos de vida, fórmulas dos KPIs, design do dashboard e requisitos fiscais, consulte **[MODULO-VENDAS-PESQUISA.md](MODULO-VENDAS-PESQUISA.md)**.
