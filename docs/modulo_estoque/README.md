# Módulo de Estoque — Documentação Completa

> Documentação de todas as entidades, operações e relatórios do módulo de Estoque do OpticalCore ERP.

---

## Índice de Entidades e Operações

| # | Entidade/Operação | Arquivo | Descrição |
|---|-------------------|---------|-----------|
| 01 | Painel de Estoque | [entidades/01-painel-estoque.md](entidades/01-painel-estoque.md) | Dashboard com 18 KPIs, alertas e tendências |
| 02 | Produtos | [entidades/02-produtos.md](entidades/02-produtos.md) | Cadastro completo de produtos com classificação, níveis de estoque e dimensões |
| 03 | Depósitos | [entidades/03-depositos.md](entidades/03-depositos.md) | Cadastro de armazéns e locais de armazenamento |
| 04 | Localizações | [entidades/04-localizacoes.md](entidades/04-localizacoes.md) | Endereços internos dentro dos depósitos |
| 05 | Movimentações | [entidades/05-movimentacoes.md](entidades/05-movimentacoes.md) | Entradas, saídas, transferências e ajustes de estoque |
| 06 | Posição de Estoque | [entidades/06-posicao-estoque.md](entidades/06-posicao-estoque.md) | Consulta de saldos disponíveis, reservados e bloqueados |
| 07 | Lotes | [entidades/07-lotes.md](entidades/07-lotes.md) | Rastreabilidade por lote de fabricação |
| 08 | Números de Série | [entidades/08-numeros-serie.md](entidades/08-numeros-serie.md) | Rastreabilidade unitária por número de série |
| 09 | Reservas | [entidades/09-reservas.md](entidades/09-reservas.md) | Reservas de estoque para pedidos e documentos |
| 10 | Inventários Físicos | [entidades/10-inventarios.md](entidades/10-inventarios.md) | Contagem física com aprovação e ajustes automáticos |
| 11 | Ordens de Transferência | [entidades/11-ordens-transferencia.md](entidades/11-ordens-transferencia.md) | Transferência entre depósitos com workflow completo |
| 12 | Conversões de UM | [entidades/12-conversoes-unidade-medida.md](entidades/12-conversoes-unidade-medida.md) | Fatores de conversão entre unidades de medida |
| 13 | Produto-Fornecedor | [entidades/13-produto-fornecedores.md](entidades/13-produto-fornecedores.md) | Vínculos comerciais entre produtos e fornecedores |
| 14 | Estoque Consignado | [entidades/14-consignado.md](entidades/14-consignado.md) | Mercadorias em consignação de fornecedores/clientes |

---

## Índice de Relatórios

| # | Relatório | Arquivo | Descrição |
|---|-----------|---------|-----------|
| 01 | Estoque Mínimo | [relatorios/01-estoque-minimo.md](relatorios/01-estoque-minimo.md) | Produtos abaixo do ponto de reposição |
| 02 | Lotes Vencendo | [relatorios/02-lotes-vencendo.md](relatorios/02-lotes-vencendo.md) | Lotes próximos da data de validade |
| 03 | Curva ABC | [relatorios/03-curva-abc.md](relatorios/03-curva-abc.md) | Classificação de produtos por valor de saídas |
| 04 | Saldo Histórico | [relatorios/04-saldo-historico.md](relatorios/04-saldo-historico.md) | Snapshots históricos de saldo de estoque |
| 05 | Bloco H (SPED Fiscal) | [relatorios/05-bloco-h.md](relatorios/05-bloco-h.md) | Inventário físico para escrituração fiscal digital |
| 06 | Rastreabilidade por Lote | [relatorios/06-rastreabilidade-lote.md](relatorios/06-rastreabilidade-lote.md) | Timeline de movimentações por lote |
| 07 | Rastreabilidade por Série | [relatorios/07-rastreabilidade-serie.md](relatorios/07-rastreabilidade-serie.md) | Timeline de movimentações por número de série |
| 08 | Estoque Morto | [relatorios/08-estoque-morto.md](relatorios/08-estoque-morto.md) | Produtos sem movimentação recente |
| 09 | Giro de Estoque | [relatorios/09-giro-estoque.md](relatorios/09-giro-estoque.md) | Rotatividade e dias de estoque por produto |
| 10 | Valoração de Estoque | [relatorios/10-valoracao.md](relatorios/10-valoracao.md) | Valor do estoque por produto |
| 11 | Movimentações por CFOP | [relatorios/11-movimentacoes-cfop.md](relatorios/11-movimentacoes-cfop.md) | Totais de movimentações agrupados por CFOP |
| 12 | Divergências de Inventário | [relatorios/12-divergencias-inventario.md](relatorios/12-divergencias-inventario.md) | Diferenças entre contagem física e sistema |

---

## Base URL

- **Entidades (01-14):** `GET/POST/PUT/DELETE /api/{entidade}`
- **Dashboard (01):** `GET /api/dashboard/estoque`
- **Relatórios (01-03, 05-12):** `GET/POST /api/relatorios/estoque/{endpoint}`
- **Saldo Histórico (04):** `GET/POST /api/estoque-saldo-historico`

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Estoque.*`

---

## Classificação por Categoria

### Cadastros
- Produtos — catálogo completo com SKU, classificação ABC, controle de lote/série
- Depósitos — armazéns com responsável, tipo e capacidade
- Localizações — endereçamento interno (prateleiras, gavetas, corredores)
- Lotes — rastreabilidade por fabricação e validade
- Números de Série — rastreabilidade unitária
- Conversões de UM — fatores de conversão entre unidades
- Produto-Fornecedor — vínculos comerciais e dados de compra
- Estoque Consignado — mercadorias de terceiros

### Operações
- Movimentações — entradas, saídas, transferências e ajustes (append-only)
- Reservas — comprometimento de saldo para documentos
- Inventários Físicos — contagem com workflow de aprovação
- Ordens de Transferência — movimentação entre depósitos com envio/recebimento

### Consultas
- Posição de Estoque — saldos atuais (somente leitura)
- Painel de Estoque — dashboard com KPIs consolidados

### Relatórios Operacionais
- Estoque Mínimo — reposição de mercadorias
- Lotes Vencendo — controle de validade
- Estoque Morto — capital parado

### Relatórios Analíticos
- Curva ABC — priorização de produtos
- Giro de Estoque — eficiência operacional
- Valoração de Estoque — patrimônio em estoque

### Relatórios Fiscais
- Bloco H (SPED) — obrigação acessória
- Movimentações por CFOP — classificação fiscal

### Relatórios de Rastreabilidade
- Rastreabilidade por Lote — cadeia de custódia
- Rastreabilidade por Série — histórico unitário

### Relatórios de Controle
- Divergências de Inventário — acuracidade de estoque
- Saldo Histórico — evolução temporal
