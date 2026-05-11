# Módulo de Produção — Documentação

Documentação do módulo de **Produção** do ERP OpticalCore, orientada ao processo de **fabricação de lentes oftálmicas** em laboratório óptico.

## Conceito central

**Bloco** (matéria-prima em estoque) é transformado em **lente oftálmica acabada** (produto vendável). O **Departamento de Produção** é organizado em **Sub-Departamentos chamados Células**. No **Roteiro de Produção** completo o pedido passa pelas **Células 1 a 10**. Cada uma das **10 etapas (Células)** exige **apontamento de produção** de **início** e de **término** para rastreabilidade total.

## Células e Roteiro de Produção (10 Células)

1. Pedido de Produção  
2. Aprovação Financeira  
3. Aprovação do Pedido  
4. Cálculo (Lensware)  
5. Estoque (separação MP, JitBox)  
6. Inspeção  
7. Blocagem (Fixação)  
8. Surfaçagem (Corte/Geração de Curva)  
9. Polimento, Marcação Indelével, Deblocagem e Lavagem, Inspeção Final  
10. Triagem, Tratamentos, Facetagem e Montagem, Expedição  

Cada Célula exige **apontamento de produção** de **início** e de **término**.

## Conceitos específicos

- **Célula:** Sub-Departamento do Departamento de Produção; no roteiro completo o pedido percorre as Células 1 a 10.
- **Roteiro de Produção:** sequência das 10 Células que o pedido percorre.
- **JitBox:** Caixa específica para produção; MP é alocada na Célula 5; na Célula 10 (Triagem) pode haver troca para JitBox de Tratamento; na Expedição o JitBox é desvinculado do pedido.
- **Lensware:** Software externo onde as informações do pedido são transformadas (cálculo para fabricação) — Célula 4.
- **Triagem / Expedição:** Dentro da Célula 10; redirecionamento do fluxo, troca de JitBox quando aplicável; verificação de qualidade, certificado de garantia (cartão PVC), faturamento e nota fiscal.

## Documentos

| Documento | Descrição |
|-----------|-----------|
| [MODULO-PRODUCAO-PESQUISA.md](./MODULO-PRODUCAO-PESQUISA.md) | Pesquisa completa: Departamento de Produção, Células (1 a 10), Roteiro de Produção, JitBox, Lensware, Triagem, Expedição, entidades (CelulaProducao, ReceitaOftalmica, ApontamentoProducao início/fim por Célula, BOM, OP, JitBox), campos, ciclo de vida, fluxos, rastreabilidade, relatórios/KPIs, SPED Bloco K e integrações. Base para implementação. |

## Resumo do módulo

- **Mestres:** CelulaProducao (10 Células), RoteiroProducao (sequência das 10 Células), BOM (bloco + insumos → lente), CentroTrabalho, TratamentoLente, JitBox.
- **Transacionais:** OrdemProducao/PedidoProducao (com ReceitaOftalmica, JitBox, RoteiroProducaoId), OrdemProducaoConsumo (bloco/insumos), OrdemProducaoSaida (lente acabada), **ApontamentoProducao** (início e término por **Célula**).
- **Ciclo:** Pedido (Célula 1) → Aprovação Financeira (2) → Aprovação do Pedido (3) → Em produção (Células 4–9) → Célula 10 (Triagem a Expedição) → Expedido.
- **Rastreabilidade:** Cada uma das **10 Células (etapas)** deve ter apontamento de **início** e **término** registrados; JitBox vinculada ao pedido até a Expedição.
- **Integrações:** Estoque (consumo bloco/insumos, entrada/saída lente, reserva), Compras (blocos e insumos), Vendas (pedido e faturamento na Expedição), Financeiro (custeio e receita), Fiscal (Bloco K e NF).

## Referências cruzadas

- [Módulo Estoque](../modulo_estoque/) — Movimentações de entrada/saída por produção (bloco, lente acabada).
- [Módulo Compras](../modulo_compras/) — Compras de blocos e insumos; industrialização por terceiros (se aplicável).
- [Módulo Fiscal](../modulo_fiscal/) — SPED Bloco K (produção e estoque); emissão de NF na Expedição.
