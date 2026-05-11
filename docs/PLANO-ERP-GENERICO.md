# Plano de Reestruturação — ERP Genérico

> **Versão:** 1.0
> **Data:** 2026-02-20
> **Estratégia:** Construir um ERP convencional completo e, posteriormente, adaptá-lo como módulo vertical para laboratório óptico.

---

## 1. Visão Geral

### 1.1 Por que ERP Genérico Primeiro?

O projeto OpticalCore possui uma base sólida (Clean Architecture, multi-tenancy, autenticação JWT, CQRS) porém ainda não implementou módulos de negócio. Este é o momento ideal para pivotar a estratégia:

| Critério | ERP Direto p/ Ótica | ERP Genérico → Ótica |
|----------|---------------------|-----------------------|
| Reutilização | Baixa | Alta |
| Complexidade inicial | Alta (mistura lógica genérica + específica) | Moderada (foco no essencial) |
| Testabilidade | Difícil (acoplamento) | Fácil (módulos isolados) |
| Tempo até primeiro fluxo funcional | Longo | Curto |
| Manutenibilidade | Frágil | Robusta |
| Expansão futura | Limitada | Ilimitada (outros verticais) |

### 1.2 Arquitetura em Camadas

```
┌─────────────────────────────────────────────────┐
│              CAMADA VERTICAL (Futuro)            │
│   Laboratório Óptico · Clínica · Outro Vertical │
├─────────────────────────────────────────────────┤
│              ERP CORE (Este Plano)               │
│  Cadastros · Vendas · Estoque · Financeiro · NF  │
├─────────────────────────────────────────────────┤
│              INFRAESTRUTURA (Existente)           │
│  Auth · Multi-Tenant · Audit · CQRS · Identity   │
└─────────────────────────────────────────────────┘
```

---

## 2. O Que Já Temos (Estado Atual)

### 2.1 Infraestrutura Pronta

- **Backend:** .NET 10, Clean Architecture, CQRS com MediatR
- **Frontend:** React 19, TypeScript, MUI 7, Vite, React Hook Form + Zod
- **Banco:** PostgreSQL 15 via Docker
- **Auth:** JWT + Refresh Token + Multi-tenant switching
- **Multi-Tenancy:** Schema-per-tenant com isolamento completo
- **Auditoria:** Soft delete, CreatedBy/UpdatedBy/DeletedBy com timestamps
- **Party Pattern:** Entidade `Pessoa` unificada (PF/PJ)
- **Domínios:** 22 tabelas lookup (gênero, estado civil, regime tributário, etc.)
- **Componentes UI:** 17 componentes reutilizáveis (formulários, upload, endereço, contato)

### 2.2 O Que Precisa Mudar

| Item | Ação |
|------|------|
| `TipoMaterial` (domínio) | Remover — é específico de ótica |
| Referências a "optical/ótica" no código | Manter no nome do produto, remover da lógica de negócio |
| Módulos de negócio | Criar do zero (vendas, estoque, financeiro, etc.) |
| Páginas do frontend | Criar CRUD completo para cada módulo |
| Sidebar/Navegação | Reestruturar com menu por módulos |

---

## 3. Módulos do ERP Core

### 3.1 Mapa de Módulos

```
ERP CORE
├── M1. Cadastros (Base)
│   ├── Pessoas (Clientes / Fornecedores / Funcionários)
│   ├── Produtos
│   ├── Categorias de Produto
│   ├── Unidades de Medida
│   └── Tabelas de Preço
│
├── M2. Vendas
│   ├── Pedidos de Venda
│   ├── Orçamentos
│   ├── Itens do Pedido
│   └── Histórico / Status
│
├── M3. Compras
│   ├── Pedidos de Compra
│   ├── Cotações
│   └── Recebimento
│
├── M4. Estoque
│   ├── Movimentações (Entrada / Saída / Transferência)
│   ├── Saldos por Produto/Depósito
│   ├── Depósitos / Locais
│   └── Inventário
│
├── M5. Financeiro
│   ├── Contas a Receber
│   ├── Contas a Pagar
│   ├── Fluxo de Caixa
│   ├── Formas de Pagamento
│   ├── Plano de Contas
│   └── Conciliação Bancária
│
├── M6. Fiscal (Simplificado)
│   ├── NCM / CFOP
│   ├── Configuração Tributária
│   └── (NF-e/NFC-e — fase futura)
│
└── M7. Relatórios & Dashboard
    ├── Dashboard com KPIs
    ├── Relatório de Vendas
    ├── Relatório de Estoque
    ├── Relatório Financeiro
    └── Exportação (PDF / Excel)
```

---

## 4. Modelagem de Dados — Entidades Novas

### 4.1 Módulo Cadastros (M1)

#### Produto

```
Produto
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK → Company, tenant)
├── Codigo              : string (código interno, unique por tenant)
├── CodigoBarras        : string? (EAN/GTIN)
├── Nome                : string (nome do produto)
├── Descricao           : string? (descrição detalhada)
├── CategoriaId         : Guid (FK → CategoriaProduto)
├── UnidadeMedidaId     : Guid (FK → UnidadeMedida)
├── Tipo                : enum (Produto, Servico, Kit)
├── PrecoCusto          : decimal
├── PrecoVenda          : decimal
├── Ncm                 : string? (classificação fiscal)
├── Cfop                : string? (código fiscal)
├── PesoLiquido         : decimal?
├── PesoBruto           : decimal?
├── Ativo               : bool
├── ControlaEstoque     : bool
├── EstoqueMinimo       : decimal?
├── EstoqueMaximo       : decimal?
├── Observacoes         : string?
├── ImagemUrl           : string?
├── [Campos de auditoria herdados de BaseAuditableEntity]
│
├── Categoria           : CategoriaProduto (nav)
├── UnidadeMedida       : UnidadeMedida (nav)
├── ItensVenda          : List<ItemVenda> (nav)
├── Movimentacoes       : List<MovimentacaoEstoque> (nav)
└── TabelaPrecoItens    : List<TabelaPrecoItem> (nav)
```

#### CategoriaProduto

```
CategoriaProduto
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Nome                : string
├── Descricao           : string?
├── CategoriaPaiId      : Guid? (FK → self, hierarquia)
├── Ativo               : bool
├── Ordem               : int (ordenação visual)
│
├── CategoriaPai        : CategoriaProduto? (nav)
└── SubCategorias       : List<CategoriaProduto> (nav)
```

#### UnidadeMedida

```
UnidadeMedida
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Sigla               : string (UN, CX, KG, LT, MT, etc.)
├── Descricao           : string
└── Ativo               : bool
```

#### TabelaPreco / TabelaPrecoItem

```
TabelaPreco
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Nome                : string
├── Descricao           : string?
├── VigenciaInicio      : DateTime?
├── VigenciaFim         : DateTime?
├── Ativo               : bool
│
└── Itens               : List<TabelaPrecoItem> (nav)

TabelaPrecoItem
├── Id                  : Guid (PK)
├── TabelaPrecoId       : Guid (FK)
├── ProdutoId           : Guid (FK)
├── PrecoVenda          : decimal
├── DescontoMaximo      : decimal? (percentual)
```

### 4.2 Módulo Vendas (M2)

#### Pedido (Venda + Orçamento)

```
Pedido
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Numero              : int (sequencial por tenant, auto)
├── Tipo                : enum (Orcamento, Venda)
├── Status              : enum (Rascunho, Pendente, Aprovado, Faturado, Cancelado)
├── ClienteId           : Guid (FK → Pessoa)
├── VendedorId          : Guid? (FK → Pessoa)
├── TabelaPrecoId       : Guid? (FK)
├── DataEmissao         : DateTime
├── DataEntrega         : DateTime?
├── SubTotal            : decimal (soma dos itens)
├── DescontoTotal       : decimal
├── AcrescimoTotal      : decimal
├── ValorFrete          : decimal
├── ValorTotal          : decimal (subtotal - desconto + acrescimo + frete)
├── FormaPagamentoId    : Guid? (FK → domínio)
├── CondicaoPagamento   : string? (ex: "30/60/90")
├── Observacoes         : string?
├── ObservacoesInternas : string?
│
├── Cliente             : Pessoa (nav)
├── Vendedor            : Pessoa? (nav)
├── Itens               : List<ItemPedido> (nav)
└── Parcelas            : List<ContaReceber> (nav — geradas ao faturar)
```

#### ItemPedido

```
ItemPedido
├── Id                  : Guid (PK)
├── PedidoId            : Guid (FK)
├── ProdutoId           : Guid (FK)
├── Sequencia           : int (ordem no pedido)
├── Quantidade          : decimal
├── PrecoUnitario       : decimal
├── DescontoPct         : decimal (%)
├── DescontoValor       : decimal (R$)
├── ValorTotal          : decimal
├── Observacoes         : string?
│
├── Pedido              : Pedido (nav)
└── Produto             : Produto (nav)
```

### 4.3 Módulo Compras (M3)

#### PedidoCompra

```
PedidoCompra
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Numero              : int (sequencial)
├── Status              : enum (Rascunho, Enviado, Parcial, Recebido, Cancelado)
├── FornecedorId        : Guid (FK → Pessoa)
├── DataEmissao         : DateTime
├── DataPrevisao        : DateTime?
├── SubTotal            : decimal
├── DescontoTotal       : decimal
├── ValorFrete          : decimal
├── ValorTotal          : decimal
├── Observacoes         : string?
│
├── Fornecedor          : Pessoa (nav)
├── Itens               : List<ItemPedidoCompra> (nav)
└── Parcelas            : List<ContaPagar> (nav)
```

#### ItemPedidoCompra

```
ItemPedidoCompra
├── Id                  : Guid (PK)
├── PedidoCompraId      : Guid (FK)
├── ProdutoId           : Guid (FK)
├── Sequencia           : int
├── Quantidade          : decimal
├── QuantidadeRecebida  : decimal
├── PrecoUnitario       : decimal
├── DescontoPct         : decimal
├── ValorTotal          : decimal
│
├── PedidoCompra        : PedidoCompra (nav)
└── Produto             : Produto (nav)
```

### 4.4 Módulo Estoque (M4)

#### Deposito

```
Deposito
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Nome                : string
├── Descricao           : string?
├── Principal           : bool (depósito padrão)
├── Ativo               : bool
```

#### MovimentacaoEstoque

```
MovimentacaoEstoque
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── ProdutoId           : Guid (FK)
├── DepositoId          : Guid (FK)
├── Tipo                : enum (Entrada, Saida, Transferencia, Ajuste)
├── Origem              : enum (Venda, Compra, Manual, Inventario, Devolucao)
├── OrigemId            : Guid? (FK genérico — PedidoId ou PedidoCompraId)
├── Quantidade          : decimal
├── CustoUnitario       : decimal?
├── DataMovimentacao    : DateTime
├── Observacoes         : string?
│
├── Produto             : Produto (nav)
└── Deposito            : Deposito (nav)
```

#### SaldoEstoque (visão materializada ou calculada)

```
SaldoEstoque
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── ProdutoId           : Guid (FK)
├── DepositoId          : Guid (FK)
├── QuantidadeAtual     : decimal
├── CustoMedio          : decimal
├── UltimaAtualizacao   : DateTime
│
├── Produto             : Produto (nav)
└── Deposito            : Deposito (nav)
```

### 4.5 Módulo Financeiro (M5)

#### ContaReceber

```
ContaReceber
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Numero              : string (identificador)
├── PessoaId            : Guid (FK → Pessoa / Cliente)
├── PedidoId            : Guid? (FK → Pedido)
├── Descricao           : string
├── DataEmissao         : DateTime
├── DataVencimento      : DateTime
├── DataPagamento       : DateTime?
├── ValorOriginal       : decimal
├── ValorDesconto       : decimal
├── ValorJuros          : decimal
├── ValorMulta          : decimal
├── ValorPago           : decimal
├── Status              : enum (Aberta, PagaParcial, Paga, Vencida, Cancelada)
├── FormaPagamentoId    : Guid?
├── PlanoContaId        : Guid? (FK)
├── Observacoes         : string?
│
├── Pessoa              : Pessoa (nav)
└── Pedido              : Pedido? (nav)
```

#### ContaPagar

```
ContaPagar
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Numero              : string
├── PessoaId            : Guid (FK → Pessoa / Fornecedor)
├── PedidoCompraId      : Guid? (FK)
├── Descricao           : string
├── DataEmissao         : DateTime
├── DataVencimento      : DateTime
├── DataPagamento       : DateTime?
├── ValorOriginal       : decimal
├── ValorDesconto       : decimal
├── ValorJuros          : decimal
├── ValorMulta          : decimal
├── ValorPago           : decimal
├── Status              : enum (Aberta, PagaParcial, Paga, Vencida, Cancelada)
├── FormaPagamentoId    : Guid?
├── PlanoContaId        : Guid? (FK)
├── Observacoes         : string?
│
├── Pessoa              : Pessoa (nav)
└── PedidoCompra        : PedidoCompra? (nav)
```

#### PlanoConta

```
PlanoConta
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Codigo              : string (ex: "1.1.01")
├── Nome                : string
├── Tipo                : enum (Receita, Despesa)
├── ContaPaiId          : Guid? (FK → self, hierarquia)
├── Ativo               : bool
│
├── ContaPai            : PlanoConta? (nav)
└── SubContas           : List<PlanoConta> (nav)
```

#### MovimentacaoCaixa

```
MovimentacaoCaixa
├── Id                  : Guid (PK)
├── CompanyId           : Guid (FK)
├── Tipo                : enum (Entrada, Saida)
├── Origem              : enum (ContaReceber, ContaPagar, Manual)
├── OrigemId            : Guid?
├── PlanoContaId        : Guid? (FK)
├── Descricao           : string
├── Valor               : decimal
├── DataMovimentacao    : DateTime
├── FormaPagamentoId    : Guid?
├── Observacoes         : string?
```

---

## 5. Estrutura de Pastas (Backend)

```
backend/src/OpticalCore.Domain/Entities/
├── Common/
│   ├── BaseEntity.cs                    (existente)
│   ├── BaseAuditableEntity.cs           (existente)
│   └── ITenantEntity.cs                 (existente)
├── Dominios/
│   ├── BaseDominio.cs                   (existente)
│   ├── [domínios existentes]
│   ├── TipoProduto.cs                   (NOVO — Produto, Servico, Kit)
│   └── StatusPedido.cs                  (NOVO — Rascunho, Pendente, etc.)
├── Cadastros/
│   ├── Pessoa.cs                        (mover de Entities/)
│   ├── Contato.cs                       (mover de Entities/)
│   ├── Endereco.cs                      (mover de Entities/)
│   ├── Produto.cs                       (NOVO)
│   ├── CategoriaProduto.cs              (NOVO)
│   ├── UnidadeMedida.cs                 (NOVO)
│   ├── TabelaPreco.cs                   (NOVO)
│   └── TabelaPrecoItem.cs              (NOVO)
├── Vendas/
│   ├── Pedido.cs                        (NOVO)
│   └── ItemPedido.cs                    (NOVO)
├── Compras/
│   ├── PedidoCompra.cs                  (NOVO)
│   └── ItemPedidoCompra.cs              (NOVO)
├── Estoque/
│   ├── Deposito.cs                      (NOVO)
│   ├── MovimentacaoEstoque.cs           (NOVO)
│   └── SaldoEstoque.cs                  (NOVO)
├── Financeiro/
│   ├── ContaReceber.cs                  (NOVO)
│   ├── ContaPagar.cs                    (NOVO)
│   ├── PlanoConta.cs                    (NOVO)
│   └── MovimentacaoCaixa.cs             (NOVO)
└── Sistema/
    ├── Company.cs                       (mover de Entities/)
    ├── Module.cs                        (mover de Entities/)
    ├── Permission.cs                    (mover de Entities/)
    ├── AuditLog.cs                      (mover de Entities/)
    └── Tag.cs                           (mover de Entities/)
```

### Estrutura de Pastas (Frontend — Novas Páginas)

```
frontend/src/presentation/pages/
├── auth/
│   └── LoginPage.tsx                    (existente)
├── dashboard/
│   └── DashboardPage.tsx                (existente — será expandido)
├── cadastros/
│   ├── pessoas/
│   │   ├── PessoasListPage.tsx
│   │   ├── PessoaFormPage.tsx
│   │   └── components/
│   │       ├── PessoaForm.tsx
│   │       ├── PessoaFilters.tsx
│   │       └── PessoaTable.tsx
│   ├── produtos/
│   │   ├── ProdutosListPage.tsx
│   │   ├── ProdutoFormPage.tsx
│   │   └── components/
│   │       ├── ProdutoForm.tsx
│   │       ├── ProdutoFilters.tsx
│   │       └── ProdutoTable.tsx
│   └── categorias/
│       └── CategoriasPage.tsx
├── vendas/
│   ├── pedidos/
│   │   ├── PedidosListPage.tsx
│   │   ├── PedidoFormPage.tsx
│   │   └── components/
│   │       ├── PedidoForm.tsx
│   │       ├── PedidoItens.tsx
│   │       ├── PedidoResumo.tsx
│   │       └── PedidoFilters.tsx
│   └── orcamentos/
│       └── OrcamentosListPage.tsx
├── compras/
│   ├── PedidosCompraListPage.tsx
│   ├── PedidoCompraFormPage.tsx
│   └── components/
│       └── ...
├── estoque/
│   ├── MovimentacoesListPage.tsx
│   ├── SaldosPage.tsx
│   ├── DepositosPage.tsx
│   └── components/
│       └── ...
├── financeiro/
│   ├── contas-receber/
│   │   ├── ContasReceberListPage.tsx
│   │   └── ContaReceberFormPage.tsx
│   ├── contas-pagar/
│   │   ├── ContasPagarListPage.tsx
│   │   └── ContaPagarFormPage.tsx
│   ├── fluxo-caixa/
│   │   └── FluxoCaixaPage.tsx
│   └── components/
│       └── ...
└── relatorios/
    ├── RelatorioVendasPage.tsx
    ├── RelatorioEstoquePage.tsx
    ├── RelatorioFinanceiroPage.tsx
    └── components/
        └── ...
```

---

## 6. Fases de Implementação

### Fase 1 — Cadastros Base (Fundação)

**Objetivo:** CRUD completo de Pessoas, Produtos, Categorias e Unidades de Medida.

**Backend:**
- [ ] Reorganizar entidades existentes nas novas pastas (Cadastros/, Sistema/)
- [ ] Remover domínio `TipoMaterial` (específico de ótica)
- [ ] Criar entidades: `Produto`, `CategoriaProduto`, `UnidadeMedida`
- [ ] Criar enums: `TipoProduto` (Produto, Servico, Kit)
- [ ] Configurar EF Core: mappings, índices, relacionamentos
- [ ] Gerar migration
- [ ] Criar Commands/Queries CQRS para cada entidade
- [ ] Criar Controllers: `PessoasController`, `ProdutosController`, `CategoriasController`, `UnidadesMedidaController`
- [ ] Seeds: unidades de medida padrão (UN, CX, KG, LT, MT, PC, PAR)
- [ ] Validações: código único por tenant, campos obrigatórios

**Frontend:**
- [ ] Criar página de listagem de Pessoas com DataGrid (filtros, busca, paginação)
- [ ] Criar formulário de Pessoa (tabs: Dados, Contatos, Endereços)
- [ ] Criar página de listagem de Produtos
- [ ] Criar formulário de Produto (com seleção de categoria e unidade)
- [ ] Criar página de Categorias (árvore hierárquica)
- [ ] Criar página de Unidades de Medida
- [ ] Atualizar Sidebar com menu de Cadastros
- [ ] Componente de busca/seleção de Pessoa (reutilizável em Vendas/Compras)

**Entregável:** Cadastrar clientes, fornecedores, produtos e categorias.

---

### Fase 2 — Vendas & Orçamentos

**Objetivo:** Fluxo completo de orçamento → venda → faturamento.

**Backend:**
- [ ] Criar entidades: `Pedido`, `ItemPedido`
- [ ] Criar enums: `TipoPedido`, `StatusPedido`
- [ ] Criar entidades: `TabelaPreco`, `TabelaPrecoItem`
- [ ] Lógica de numeração sequencial por tenant
- [ ] Cálculos automáticos: subtotal, desconto, total
- [ ] Transição de status com validação (Rascunho → Pendente → Aprovado → Faturado)
- [ ] Converter orçamento em venda (duplicar com novo tipo)
- [ ] Commands/Queries CQRS
- [ ] Controller: `PedidosController`, `TabelasPrecosController`

**Frontend:**
- [ ] Criar listagem de Pedidos/Orçamentos com filtros por status, data, cliente
- [ ] Criar formulário de Pedido:
  - Seleção de cliente (autocomplete)
  - Adição de itens (busca de produto, quantidade, preço, desconto)
  - Cálculos em tempo real
  - Resumo do pedido
- [ ] Ações de status (Aprovar, Faturar, Cancelar) com confirmação
- [ ] Impressão/PDF do pedido (layout básico)
- [ ] Dashboard de vendas: total do dia/mês, últimos pedidos

**Entregável:** Criar orçamentos, converter em vendas, controlar status.

---

### Fase 3 — Estoque

**Objetivo:** Controle de estoque com movimentações e saldos.

**Backend:**
- [ ] Criar entidades: `Deposito`, `MovimentacaoEstoque`, `SaldoEstoque`
- [ ] Criar enums: `TipoMovimentacao`, `OrigemMovimentacao`
- [ ] Lógica de atualização automática de saldo ao movimentar
- [ ] Cálculo de custo médio ponderado
- [ ] Trigger de movimentação ao faturar pedido de venda (saída)
- [ ] Trigger de movimentação ao receber compra (entrada)
- [ ] Validação de saldo (não permitir saldo negativo — configurável)
- [ ] Commands/Queries CQRS
- [ ] Controller: `EstoqueController`, `DepositosController`

**Frontend:**
- [ ] Criar listagem de movimentações (filtros: produto, tipo, período)
- [ ] Criar página de saldos por produto/depósito
- [ ] Criar cadastro de depósitos
- [ ] Movimentação manual (ajuste de estoque, transferência)
- [ ] Indicadores visuais: estoque baixo (< mínimo), sem estoque
- [ ] Widget no Dashboard: produtos abaixo do estoque mínimo

**Entregável:** Visualizar saldos, movimentar estoque, alertas de reposição.

---

### Fase 4 — Compras

**Objetivo:** Fluxo de compra com geração de entrada no estoque e contas a pagar.

**Backend:**
- [ ] Criar entidades: `PedidoCompra`, `ItemPedidoCompra`
- [ ] Criar enums: `StatusPedidoCompra`
- [ ] Lógica de recebimento parcial (quantidade recebida vs. pedida)
- [ ] Integração: ao receber → movimentação de estoque (entrada)
- [ ] Integração: ao receber → gera contas a pagar
- [ ] Commands/Queries CQRS
- [ ] Controller: `ComprasController`

**Frontend:**
- [ ] Criar listagem de Pedidos de Compra
- [ ] Criar formulário de Pedido de Compra (similar ao de venda)
- [ ] Tela de recebimento (conferência de itens)
- [ ] Histórico de compras por fornecedor

**Entregável:** Registrar compras, dar entrada no estoque, gerar contas a pagar.

---

### Fase 5 — Financeiro

**Objetivo:** Contas a pagar/receber, fluxo de caixa e plano de contas.

**Backend:**
- [ ] Criar entidades: `ContaReceber`, `ContaPagar`, `PlanoConta`, `MovimentacaoCaixa`
- [ ] Geração automática de parcelas ao faturar venda
- [ ] Geração automática ao confirmar compra
- [ ] Lógica de baixa (pagamento total, parcial, com juros/multa)
- [ ] Cálculo de juros e multa por atraso (configurável)
- [ ] Fluxo de caixa: consolidação por período
- [ ] Commands/Queries CQRS
- [ ] Controllers: `ContasReceberController`, `ContasPagarController`, `FluxoCaixaController`, `PlanoContasController`

**Frontend:**
- [ ] Listagem de Contas a Receber (filtros: status, vencimento, cliente)
- [ ] Listagem de Contas a Pagar (filtros: status, vencimento, fornecedor)
- [ ] Tela de baixa de título (registrar pagamento)
- [ ] Cadastro de Plano de Contas (árvore hierárquica)
- [ ] Fluxo de Caixa: gráfico temporal (entradas vs. saídas)
- [ ] Indicadores: títulos vencidos, a vencer esta semana, saldo projetado
- [ ] Dashboard financeiro completo

**Entregável:** Gestão financeira completa com visibilidade de fluxo de caixa.

---

### Fase 6 — Relatórios & Dashboard

**Objetivo:** Relatórios gerenciais e dashboard consolidado.

**Backend:**
- [ ] Queries otimizadas para relatórios (views/procedures se necessário)
- [ ] Endpoint de KPIs consolidados para o Dashboard
- [ ] Exportação: PDF (via biblioteca) e Excel (EPPlus/ClosedXML)

**Frontend:**
- [ ] Dashboard principal com KPIs:
  - Vendas do mês (valor, quantidade)
  - Contas vencidas / a vencer
  - Estoque crítico
  - Top 5 produtos vendidos
  - Gráfico de vendas (últimos 6 meses)
  - Gráfico de fluxo de caixa
- [ ] Relatório de vendas por período, cliente, vendedor, produto
- [ ] Relatório de estoque (posição atual, movimentações)
- [ ] Relatório financeiro (DRE simplificado, contas vencidas)
- [ ] Filtros por período em todos os relatórios
- [ ] Botões de exportação PDF/Excel

**Entregável:** Visão gerencial completa do negócio.

---

## 7. Fase Futura — Adaptação para Laboratório Óptico

> Esta fase só deve ser iniciada após a conclusão do ERP Core (Fases 1-6).

### 7.1 Módulos Específicos de Ótica

```
CAMADA VERTICAL — ÓTICA
├── Receituário
│   ├── Receita do paciente (OD/OE)
│   ├── Dioptrias (Esférico, Cilíndrico, Eixo, Adição)
│   ├── DNP, Altura, DP
│   └── Vínculo com pedido de venda
│
├── Ordem de Serviço (OS)
│   ├── Dados da receita
│   ├── Tipo de lente (material, tratamento, design)
│   ├── Tipo de armação
│   ├── Status da OS (Recebida, Em Produção, Pronta, Entregue)
│   ├── Rastreabilidade por etapa
│   └── Prazo de entrega
│
├── Catálogo de Lentes
│   ├── Materiais (CR-39, Policarbonato, Trivex, Alto Índice)
│   ├── Tratamentos (AR, Fotocromático, Blue Cut, etc.)
│   ├── Designs (Monofocal, Bifocal, Progressivo)
│   └── Tabela de base/curva por dioptria
│
├── Gestão de Armações
│   ├── Extensão de Produto com campos específicos
│   ├── Marca, modelo, cor, tamanho (aro, ponte, haste)
│   └── Foto do produto
│
└── Relatórios Ópticos
    ├── OS por status
    ├── Produtividade do laboratório
    ├── Tempo médio de produção
    └── Receitas por período
```

### 7.2 Estratégia de Implementação

A adaptação será feita como **extensão** dos módulos existentes, sem modificar o core:

- **Produto → ProdutoOtico:** Herança ou composição para adicionar campos de lente/armação
- **Pedido → PedidoOtico:** Extensão com vínculo à receita e OS
- **Novo módulo OS:** Entidade independente vinculada ao Pedido

---

## 8. Regras de Negócio Transversais

### 8.1 Numeração Sequencial

Todos os documentos (pedido, compra, OS) devem ter numeração sequencial por tenant, sem gaps. Implementar via `SELECT ... FOR UPDATE` ou sequence do PostgreSQL por schema.

### 8.2 Integrações Entre Módulos

```
Venda (Faturar)
├── → Estoque (Saída automática)
├── → Financeiro (Gera Contas a Receber)
└── → Caixa (Movimentação de entrada)

Compra (Receber)
├── → Estoque (Entrada automática)
├── → Financeiro (Gera Contas a Pagar)
└── → Caixa (Movimentação de saída — ao pagar)

Cancelamento (Venda/Compra)
├── → Estoque (Estorno da movimentação)
└── → Financeiro (Cancelamento dos títulos)
```

### 8.3 Multi-Tenancy

Todas as novas entidades devem:
- Implementar `ITenantEntity` (CompanyId)
- Ter query filter global por tenant no DbContext
- Ser criadas no schema do tenant (TenantDbContext)

### 8.4 Auditoria

Todas as novas entidades devem herdar `BaseAuditableEntity` para garantir:
- `CreatedAt`, `CreatedBy`
- `UpdatedAt`, `UpdatedBy`
- `IsDeleted`, `DeletedAt`, `DeletedBy` (soft delete)

---

## 9. Stack Técnica (Confirmada)

| Camada | Tecnologia |
|--------|-----------|
| Backend | .NET 10, ASP.NET Core, EF Core |
| Frontend | React 19, TypeScript, Vite 7, MUI 7 |
| Banco de Dados | PostgreSQL 15 (`opticalcorecombr`) |
| Autenticação | JWT + Refresh Token (já implementado) |
| Padrão Backend | Clean Architecture + CQRS (MediatR) |
| Padrão Frontend | Feature-based (pages por módulo) |
| Validação Backend | FluentValidation |
| Validação Frontend | React Hook Form + Zod |
| Containerização | Docker Compose |
| DataGrid | MUI X DataGrid |
| Gráficos | MUI X Charts |
| PDF Export | A definir (QuestPDF ou similar) |
| Excel Export | A definir (ClosedXML ou EPPlus) |

---

## 10. Prioridade de Execução

```
Fase 1: Cadastros          ████████████░░░░░░░░  Fundação — tudo depende disso
Fase 2: Vendas             ████████░░░░░░░░░░░░  Core do negócio
Fase 3: Estoque            ██████░░░░░░░░░░░░░░  Controle operacional
Fase 4: Compras            █████░░░░░░░░░░░░░░░  Ciclo completo
Fase 5: Financeiro         ████████░░░░░░░░░░░░  Gestão de caixa
Fase 6: Relatórios         ████░░░░░░░░░░░░░░░░  Visão gerencial
──────────────────────────────────────────────────
Futuro: Módulos Óticos     ██████████░░░░░░░░░░  Vertical especializado
```

**Dependências:**
- Fase 2 (Vendas) depende de Fase 1 (Cadastros)
- Fase 3 (Estoque) depende de Fase 1 (Cadastros)
- Fase 4 (Compras) depende de Fase 1 + Fase 3
- Fase 5 (Financeiro) depende de Fase 2 + Fase 4
- Fase 6 (Relatórios) depende de todas as anteriores

---

## 11. Convenções de Código

### Backend (C#)
- Entidades em **português** (Produto, Pedido, etc.) — padrão já estabelecido
- Nomes de propriedades em **PascalCase**
- Enums como classes de domínio (não `enum` nativo) — padrão existente
- Um Command/Query por arquivo
- Validators separados em classes FluentValidation
- Respostas da API sempre em DTO (nunca expor entidade)

### Frontend (TypeScript/React)
- Componentes em **PascalCase** com extensão `.tsx`
- Types/interfaces em arquivos `.types.ts` separados
- Services em arquivos `.service.ts`
- Hooks customizados prefixados com `use`
- Páginas terminando em `Page` (ex: `ProdutosListPage.tsx`)
- Componentes de formulário terminando em `Form` (ex: `ProdutoForm.tsx`)
- **OBRIGATÓRIO:** Todos os textos visíveis ao usuário (labels, placeholders, mensagens, títulos, tooltips) devem utilizar **acentuação correta em Português Brasileiro** (á, é, í, ó, ú, ã, õ, ç, â, ê, ô). Exemplos: "Código", "Razão Social", "Ações", "Endereço", "Identificação", "Inscrição Estadual"
- **OBRIGATÓRIO — Layout de Páginas:** O header global (`Header.tsx` via `MainLayout`) é o único responsável por exibir ícone + título + subtítulo da página. Toda nova rota deve ser registrada no `routeTitles` do `MainLayout.tsx` com `title`, `subtitle` e `icon`. As páginas individuais (`*Page.tsx`) **NUNCA** devem duplicar título/subtítulo/ícone — devem conter apenas conteúdo específico (botões de ação, filtros, tabelas, formulários)
- **OBRIGATÓRIO — Padrão de Listagem:** Em páginas de lista (`*ListPage.tsx`), a busca e o botão de ação principal ficam juntos no mesmo `Paper` (busca `fullWidth` à esquerda, botão à direita). O `EmptyState` **NÃO** deve conter botão de ação duplicado — apenas texto orientando o uso do botão na barra de busca
