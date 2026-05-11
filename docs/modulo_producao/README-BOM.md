# Módulo Produto Fabricado — Documentação

Documentação do módulo **Produto Fabricado** do ERP OpticalCore. Este é o módulo em que o **laboratório/empresa cria e gerencia produtos próprios fabricados a partir de matéria-prima**.

## Conceito central

Um **produto fabricado** é definido por uma **Lista de Materiais (BOM)** que especifica **quais componentes** e **em que quantidades** são necessários para produzir uma unidade do produto. Exemplo: o produto **"Bicicleta Caloi 10"** é fabricado a partir de tubo de metal, banco, corrente, câmbio 10 marchas, etc. O módulo cobre a estrutura do produto (BOM), o custeio (rollup), a explosão de necessidades de material e as integrações com Estoque, Compras, Vendas, Financeiro e Produção.

## Documentos

| Documento | Descrição |
|-----------|-----------|
| [MODULO-PRODUTO-FABRICADO-PESQUISA.md](./MODULO-PRODUTO-FABRICADO-PESQUISA.md) | Pesquisa completa: entidades (Produto, ListaMaterial, ListaMaterialItem), tipos de BOM (single-level, multi-level, fantasma, co-produto), campos, fluxos (cadastro, explosão, integração com OP), relatórios/KPIs, custeio, SPED Bloco K, **normas técnicas (ISO 10303-44, estrutura de produto)**, **TOTVS Protheus (PCPA200, nomenclatura BOM)**, **ficha técnica e boas práticas no Brasil** (contabilidade, BPF, associações), e integrações com Estoque, Compras, Vendas, Financeiro, Produção e Fiscal. Base para implementação. |

## Resumo do módulo

- **Mestres:** Produto (TipoProduto Acabado/Semi-Acabado, Fabricado, ListaMaterialId), **ListaMaterial (BOM)** (produto pai, versão, quantidade base, vigência), **ListaMaterialItem** (componente, quantidade por unidade, tipo de item).
- **Custeio:** Custo do produto fabricado = rollup da BOM (material) + mão de obra e overhead (quando houver roteiro); CustoProduto, HistoricoCustoProduto.
- **Explosão:** Cálculo da necessidade de materiais para uma quantidade a produzir (para Compras e Produção).
- **Integrações:** Estoque (produto, movimentações via Produção), Compras (necessidade de MP), Vendas (venda do produto fabricado, make-to-order), Financeiro (custeio, CPV), Produção (OP usa BOM para consumo e saída do produto), Fiscal (Bloco K).

## Referências cruzadas

- [Módulo Estoque](../modulo_estoque/) — Cadastro de Produto, movimentações e saldos.
- [Módulo Produção](../modulo_producao/) — Ordem de produção utiliza BOM para consumo de MP e geração do produto fabricado.
- [Módulo Compras](../modulo_compras/) — Compra de matéria-prima a partir da explosão da BOM.
- [Módulo Fiscal](../modulo_fiscal/) — SPED Bloco K (produção e estoque).
