# Pesquisa: Módulo de Produção — Lentes Oftálmicas (OpticalCore ERP)

> Documentação do módulo de **Produção** do OpticalCore ERP, orientada ao processo de **fabricação de lentes oftálmicas acabadas** a partir de blocos semiacabados em laboratório óptico. O **Departamento de Produção** é organizado em **Sub-Departamentos chamados Células**; no **Roteiro de Produção** completo o pedido passa pelas **Células 1 a 10**. Cada Célula exige **apontamento de produção** de **início** e de **término** para rastreabilidade. Inclui JitBox, Lensware, Triagem, Expedição, integrações e SPED Bloco K.

---

## 1. Visão Geral do Módulo

O módulo de **Produção** gerencia todo o processo que **transforma matéria-prima em estoque em produto fabricado vendável**. No domínio óptico do OpticalCore:

- **Matéria-prima principal:** **Bloco** (semiacabado em resina ou vidro), com face externa já curvada; a face interna será moldada conforme a receita oftálmica.
- **Produto acabado:** **Lente oftálmica** personalizada (dioptria esférica, cilíndrica, eixo), opcionalmente tratada (antirreflexo, UV, etc.), facetada no formato da armação e montada.

O processo é realizado em **laboratórios ópticos de alta precisão**. Para que o pedido possa ser **rastreado**, a organização do processo é a seguinte:

- **Departamento de Produção:** responsável pelo fluxo do pedido até a lente acabada e expedida.
- **Sub-Departamentos — Células:** o Departamento de Produção é dividido em **Sub-Departamentos chamados Células**. Cada Célula corresponde a uma etapa do processo (ou a um conjunto de atividades realizadas em um mesmo sub-departamento).
- **Roteiro de Produção:** em um **Roteiro de Produção completo**, o pedido passa pelas **Células 1 a 10** em sequência. O Roteiro define a ordem em que o pedido percorre as Células.
- **Apontamento por Célula:** **cada uma das 10 etapas (Células)** precisa ter **apontamento de produção** tanto de **início de processo** quanto de **término**. Assim, todo o processo é rastreado por pedido e por Célula.

**Princípio de rastreabilidade:** Para cada **Célula** (1 a 10), o sistema registra **quando a Célula iniciou** e **quando a Célula terminou** para aquele pedido, permitindo análise de tempos, gargalos e conformidade.

**Conceitos específicos do processo:**

- **JitBox:** Caixa específica para produção na qual a matéria-prima (bloco) é separada e acompanha o pedido ao longo do fluxo; pode ser trocada na Célula de Triagem (ex.: JitBox específico para Tratamento). Na **Expedição** (Célula 10), o JitBox é desvinculado do pedido.
- **Lensware:** Software externo onde as informações do pedido são digitadas e transformadas (cálculos para fabricação); utilizado na **Célula 4 (Cálculo)**; integração via dados exportados/importados ou API, conforme disponibilidade.
- **Triagem (Célula 10):** momento em que o JitBox com a lente pode ser redirecionado conforme o pedido (só Tratamento; Tratamento e Montagem com troca/retorno de JitBox); depois Tratamentos, Facetagem/Montagem e Expedição.
- **Expedição (Célula 10):** verificação da qualidade do produto acabado, desvinculação do JitBox, impressão do certificado de garantia (cartão PVC), faturamento e impressão da nota fiscal.

---

## 2. Células e Roteiro de Produção (10 Células)

No **Roteiro de Produção** completo, o pedido passa pelas **Células 1 a 10**. Cada Célula é um **Sub-Departamento** do Departamento de Produção e exige **apontamento de início** e **apontamento de término**.

### Célula 1 — Pedido de Produção

- **Descrição:** Entrada do pedido do cliente para o laboratório produzir.
- **Atividades:** Registro do pedido de produção (cliente, receita, produto desejado, armação se houver).
- **Apontamento:** Início (recebimento do pedido) e término (pedido registrado e pronto para Célula 2).

### Célula 2 — Aprovação Financeira

- **Descrição:** Consulta se o cliente não possui restrições financeiras (ex.: cliente inadimplente).
- **Atividades:** Verificação de crédito, limite, inadimplência; liberação ou bloqueio para seguir.
- **Apontamento:** Início e término da análise; resultado (aprovado/reprovado) pode ser registrado.

### Célula 3 — Aprovação do Pedido

- **Descrição:** Verifica se todos os dados do pedido estão corretos para enviar à produção.
- **Atividades:** Conferência de receita, produto, armação, prazos; aprovação para liberar ao Cálculo.
- **Apontamento:** Início e término da verificação/aprovação.

### Célula 4 — Cálculo

- **Descrição:** As informações do pedido são digitadas em um software externo chamado **Lensware**, onde as informações são transformadas (cálculos para a fabricação da lente).
- **Atividades:** Entrada dos dados no Lensware; obtenção dos parâmetros de fabricação (curvatura interna, etc.); retorno dos dados para o ERP quando houver integração.
- **Apontamento:** Início (início do cálculo no Lensware) e término (cálculo concluído e dados disponíveis).

### Célula 5 — Estoque

- **Descrição:** A matéria-prima é separada e colocada em uma caixa específica para produção chamada **JitBox**.
- **Atividades:** Separação do bloco (e insumos conforme BOM); alocação em JitBox; vinculação JitBox ↔ Pedido; consumo ou reserva no estoque.
- **Apontamento:** Início e término da separação e alocação na JitBox.

### Célula 6 — Inspeção

- **Descrição:** Com a matéria-prima e o JitBox definidos, uma inspeção geral é feita para certificar a qualidade antes da Blocagem.
- **Atividades:** Inspeção do bloco e do conjunto (JitBox); certificação de qualidade; liberação para Blocagem.
- **Apontamento:** Início e término da inspeção; resultado (aprovado/refugado) pode ser registrado.

### Célula 7 — Blocagem (Fixação)

- **Descrição:** A lente é fixada em um suporte metálico (bloco) usando liga metálica ou cera especial, para que a máquina de corte segure com precisão e crie a curvatura correta na face interna.
- **Atividades:** Fixação da lente no suporte; preparação para Surfaçagem.
- **Apontamento:** Início e término da blocagem.

### Célula 8 — Surfaçagem (Corte / Geração de Curva)

- **Descrição:** Etapa principal, realizada por geradores de alta precisão (computadorizados). A máquina desbasta a face interna do bloco, gerando a curva interna e reduzindo diâmetro e espessura conforme o cálculo da receita. Em lentes mais modernas: tecnologia **Freeform** (corte ponto a ponto com ponta de diamante).
- **Atividades:** Corte/surfaçagem conforme dados do Lensware.
- **Apontamento:** Início e término da surfaçagem.

### Célula 9 — Polimento, Marcação Indelével, Deblocagem e Lavagem, Inspeção Final

Esta Célula agrupa as atividades de acabamento e inspeção óptica antes da triagem:

- **Polimento:** Após o corte, a lente está opaca. Passa por máquinas cilíndricas de polimento (lixas especiais e pasta de polimento), removendo ranhuras e tornando a superfície transparente e lisa.
- **Marcação Indelével:** Equipamento de marcação a laser certifica que a lente é o produto correto.
- **Deblocagem e Lavagem:** A lente é removida do suporte de metal (deblocagem) e lavada para retirar resíduos de polimento.
- **Inspeção Final:** A lente é conferida no lensômetro e/ou mapeador para verificar a dioptria esférica, cilíndrica e o eixo.

- **Apontamento:** Um único par **início/término** para a Célula 9 (quando o pedido entra na Célula 9 e quando todas as atividades acima foram concluídas para esse pedido). O resultado da Inspeção Final (Aprovado/Refugado) pode ser registrado no apontamento de término.

### Célula 10 — Triagem, Tratamentos, Facetagem e Montagem, Expedição

Esta Célula agrupa a triagem, os tratamentos opcionais, a facetagem/montagem e a expedição:

- **Triagem:** O JitBox com a lente pode ser redirecionado conforme o pedido:  
  - Se o pedido tem **apenas Tratamento:** o JitBox é trocado por um JitBox específico para Tratamento e encaminhado ao nível de Tratamentos.  
  - Se o pedido tem **Tratamento e Montagem:** troca para JitBox específico para Tratamento; com o término do tratamento retorna ao nível da Triagem, retorna ao JitBox original e é encaminhado ao nível de Facetagem e Montagem.  
  - Se não há tratamento: encaminha direto à Facetagem e Montagem.
- **Tratamentos (opcionais, mas comuns):** Antirreflexo/antirrisco, proteção UV e luz azul.
- **Facetagem e Montagem:** A lente é cortada (facetada) na forma da armação e montada.
- **Expedição:** Verificação da qualidade do produto acabado, desvinculação do JitBox do pedido, impressão do certificado de garantia (cartão PVC), faturamento e impressão da nota fiscal.

- **Apontamento:** Um único par **início/término** para a Célula 10 (entrada na Triagem até conclusão da Expedição). Ao término: produto expedido; integração com Estoque (saída para entrega), Vendas (faturamento) e Fiscal (NF).

---

## 3. Entidades Propostas

### 3.1 Dados Mestres (Cadastros do Processo)

| Entidade | Descrição | Schema |
|----------|-----------|--------|
| **CelulaProducao** | Cadastro das **10 Células** (Sub-Departamentos do Departamento de Produção): Pedido de Produção, Aprovação Financeira, Aprovação do Pedido, Cálculo, Estoque, Inspeção, Blocagem, Surfaçagem, Célula 9 (Polimento a Inspeção Final), Célula 10 (Triagem a Expedição), com ordem de sequência (1 a 10) | Tenant |
| **RoteiroProducao** | Roteiro de Produção: sequência das 10 Células para fabricação de lente (vinculado ao produto “lente acabada” ou genérico). Em um roteiro completo o pedido passa pelas Células 1 a 10 | Tenant |
| **RoteiroProducaoOperacao** | Cada operação do roteiro = uma CelulaProducao (sequência 1 a 10) | Tenant |
| **ListaMaterial (BOM)** | Estrutura do produto: 1 lente acabada = 1 bloco (+ insumos opcionais: cera/liga, lixas, pasta, etc.) | Tenant |
| **ListaMaterialItem** | Itens da BOM: bloco (obrigatório), demais insumos e quantidades | Tenant |
| **CentroTrabalho** | Recurso/estação onde a Célula é executada (ex.: Lensware, Estoque/JitBox, Gerador Freeform, Polimento, Lensômetro, Triagem, Bancada de Montagem, Expedição) | Tenant |
| **TratamentoLente** | Cadastro de tipos de tratamento (Antirreflexo, UV, Luz Azul, etc.) para uso na Célula 10 (Tratamentos) | Tenant |
| **JitBox** | Cadastro de tipos ou códigos de JitBox (caixa de produção); JitBox “padrão” e JitBox “para Tratamento” para controle na Triagem | Tenant |

### 3.2 Dados da Receita, do Pedido e da Ordem

| Entidade | Descrição |
|----------|-----------|
| **ReceitaOftalmica** | Dados ópticos da receita: esférico, cilíndrico, eixo, base, adição (multifocal), DNP; vinculada ao Pedido de Produção / Ordem de Produção |
| **PedidoProducao / OrdemProducao** | Pedido/ordem de fabricação de lente(s): cliente, produto (lente acabada), quantidade, receita, status, datas; vinculado a **JitBox**; referência a PedidoVenda quando make-to-order; **RoteiroProducaoId** (roteiro com as 10 Células) |
| **OrdemProducaoConsumo** | Consumo de matéria-prima por OP: bloco (1 un.) e demais insumos da BOM; gera saída no Estoque (na Célula 5 Estoque quando a MP é alocada na JitBox) |
| **OrdemProducaoSaida** | Saída do produto acabado (lente); na Expedição (Célula 10) gera saída para entrega/faturamento conforme regra de negócio |

### 3.3 JitBox e Vínculo com o Pedido

| Entidade | Descrição |
|----------|-----------|
| **JitBoxAlocacao** (ou atributo em OrdemProducao) | Vínculo entre Pedido/OP e a JitBox utilizada. Na **Célula 10 (Triagem)** pode haver troca de JitBox (ex.: JitBox Tratamento); após Tratamento retorno ao JitBox original. Na **Expedição** o JitBox é **desvinculado** do pedido. |

### 3.4 Apontamento de Produção (Rastreabilidade por Célula)

| Entidade | Descrição |
|----------|-----------|
| **ApontamentoProducao** | Registro de **início** ou **término** de uma **Célula** para um **Pedido/Ordem de Produção**. Cada **Célula** (1 a 10) gera **dois** apontamentos: um de início e um de término. Campos: PedidoProducaoId/OrdemProducaoId, **CelulaProducaoId**, TipoApontamento (Inicio, Termino), DataHora, ResponsavelId, CentroTrabalhoId, JitBoxId (opcional), ResultadoInspecao (Células Inspeção e 9), ResultadoAprovacao (Célula 2), Observacao. |

**Regra de rastreabilidade:** Todo o processo precisa ser rastreado: para **cada uma das 10 Células (etapas)** deve existir apontamento de **início** e apontamento de **término**.

### 3.5 Dados de Suporte

| Entidade | Descrição |
|----------|-----------|
| **LoteProducao** | Lote de fabricação (rastreabilidade: OP → lote da lente; lotes de blocos/insumos consumidos) |
| **CustoProduto** | Custo do produto (bloco + insumos + mão de obra), para integração com Financeiro |
| **ReservaEstoque** | Reserva de bloco (e insumos) para a OP antes da Célula 5 (integrado ao módulo Estoque) |

### 3.6 Domínios / Lookup

| Entidade | Descrição |
|----------|-----------|
| **StatusOrdemProducao** | Rascunho, Planejada, Liberada, EmProdução, Encerrada, Cancelada (ou equivalentes: AguardandoAprovacaoFinanceira, AguardandoAprovacaoPedido, etc.) |
| **TipoApontamentoProducao** | Inicio, Termino |
| **ResultadoInspecao** | Aprovado, Refugado (Células Inspeção e 9 — Inspeção Final) |
| **ResultadoAprovacaoFinanceira** | Aprovado, Reprovado (Célula 2) |

---

## 4. Campos Chave das Entidades

### 4.1 CelulaProducao

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid | PK |
| Codigo | string(20) | Código (ex.: PEDIDO, APROV_FIN, APROV_PED, CALC, ESTOQUE, INSP, BLOC, SURF, ACAB_INSP, TRIAG_EXPED) |
| Nome | string(200) | Nome da Célula (ex.: Pedido de Produção, Célula 9 — Polimento a Inspeção Final, Célula 10 — Triagem a Expedição) |
| Sequencia | int | Ordem no Roteiro de Produção (1 a 10) |
| Obrigatoria | bool | Se a Célula é obrigatória para todo pedido |
| CentroTrabalhoId | FK | Centro de trabalho padrão (nullable) |
| PermiteTrocaJitBox | bool | Para Célula 10 (Triagem): indica que nesta Célula pode haver troca de JitBox |
| Ativo | bool | Se está ativa para novos pedidos |

### 4.2 ReceitaOftalmica

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid | PK |
| EsfericoOD | decimal(8,2) | Esférico olho direito |
| CilindricoOD | decimal(8,2) | Cilíndrico OD |
| EixoOD | int | Eixo OD (graus) |
| EsfericoOE | decimal(8,2) | Esférico olho esquerdo |
| CilindricoOE | decimal(8,2) | Cilíndrico OE |
| EixoOE | int | Eixo OE |
| Adicao | decimal(6,2) | Adição (multifocal) |
| DNP | decimal(6,2) | Distância naso-pupilar (opcional) |
| Observacoes | text | Observações da receita |

### 4.3 OrdemProducao / PedidoProducao

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid | PK |
| Codigo | int (auto) | Número sequencial 8 dígitos |
| ClienteId | FK | Cliente (quando gerado a partir de pedido de venda) |
| ProdutoId | FK | Produto a produzir (lente acabada) |
| ListaMaterialId | FK | BOM utilizada |
| RoteiroProducaoId | FK | Roteiro de Produção (sequência das 10 Células) |
| ReceitaOftalmicaId | FK | Receita aplicada à lente |
| QuantidadePlanejada | decimal(18,3) | Quantidade (geralmente 1 par ou 1 un.) |
| QuantidadeProduzida | decimal(18,3) | Quantidade já concluída/expedida |
| JitBoxId | FK | JitBox atualmente vinculada ao pedido (pode mudar na Célula 10 — Triagem) |
| DataPrevistaInicio | date | Previsão início |
| DataPrevistaFim | date | Previsão fim |
| DataLiberacao | datetime | Quando foi liberado para produção |
| DataExpedicao | datetime | Quando foi expedido (Célula 10 término) |
| Status | enum | Conforme ciclo de vida |
| DepositoId | FK | Depósito de consumo (bloco) e saída (lente) |
| PedidoVendaId | FK | Opcional: make-to-order |
| PossuiTratamento | bool | Se o pedido inclui tratamento (impacta Triagem na Célula 10) |
| PossuiMontagem | bool | Se o pedido inclui facetagem/montagem |
| Observacoes | text | Observações |

### 4.4 ApontamentoProducao

| Campo | Tipo | Descrição |
|-------|------|-----------|
| Id | Guid | PK |
| OrdemProducaoId | FK | Ordem/Pedido de produção |
| CelulaProducaoId | FK | Célula (1 a 10) |
| TipoApontamento | enum | **Inicio** ou **Termino** |
| DataHora | datetime | Data e hora do apontamento |
| ResponsavelId | FK | Usuário/operador que apontou (opcional) |
| CentroTrabalhoId | FK | Recurso/estação utilizada (opcional) |
| JitBoxId | FK | JitBox associada no momento (opcional; útil na Célula 10 Triagem) |
| ResultadoInspecao | enum | Células Inspeção (6) e 9 (Inspeção Final): Aprovado, Refugado (nullable) |
| ResultadoAprovacao | enum | Célula 2 (Aprovação Financeira): Aprovado, Reprovado (nullable) |
| Observacao | text | Observações |

**Regra de negócio:** Para cada Célula, no máximo um apontamento de **Inicio** e um de **Termino** por OP. O término da Célula N pode ser condição para permitir início da Célula N+1 (fluxo sequencial do Roteiro de Produção).

### 4.5 OrdemProducaoConsumo, OrdemProducaoSaida, JitBox

- **OrdemProducaoConsumo:** OrdemProducaoId, ProdutoId (bloco/insumo), QuantidadePlanejada/Consumida, DepositoId, CustoUnitario, LoteId.
- **OrdemProducaoSaida:** OrdemProducaoId, ProdutoId (lente acabada), Quantidade, DepositoId, CustoUnitario, LoteProducaoId.
- **JitBox:** Id, Codigo, Nome, TipoJitBox (Padrao, Tratamento), Ativo.

---

## 5. Ciclo de Vida da Ordem / Pedido de Produção

O pedido percorre o **Roteiro de Produção** (Células 1 a 10). O ciclo pode ser representado assim:

```
Pedido registrado (Célula 1) → Aprovação Financeira (Célula 2) → Aprovação do Pedido (Célula 3) → Em produção (Células 4 a 9) → Célula 10 (Triagem a Expedição) → Expedido
        ↓                                    ↓                                ↓
   Cancelado                             Reprovado                        Reprovado
```

| Status (exemplos) | Significado |
|-------------------|-------------|
| **Rascunho / Pedido** | Pedido de produção registrado (Célula 1); aguardando Célula 2. |
| **Aprovado Financeiro** | Célula 2 concluída; aguardando Célula 3. |
| **Aprovado** | Célula 3 concluída; liberado para Células 4 a 10. |
| **EmProdução** | Percorrendo Células 4 a 10; apontamentos de início e término em cada Célula. |
| **Expedido** | Célula 10 concluída: qualidade verificada, JitBox desvinculado, certificado impresso, faturamento e NF realizados. |
| **Cancelado** | Pedido/ordem cancelado; reservas liberadas. |

---

## 6. Fluxos de Negócio

### 6.1 Fluxo Geral: Roteiro de Produção (Células 1 a 10)

```
CÉLULA 1 — Pedido de Produção
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 2 — Aprovação Financeira
   |-- Apontamento INÍCIO → Apontamento TÉRMINO (Aprovado/Reprovado)
   v
CÉLULA 3 — Aprovação do Pedido
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 4 — Cálculo (Lensware)
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 5 — Estoque (JitBox)
   |-- Separação MP; alocação JitBox; consumo/reserva; MovimentacaoEstoque Saída
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 6 — Inspeção
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 7 — Blocagem
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 8 — Surfaçagem
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 9 — Polimento, Marcação, Deblocagem/Lavagem, Inspeção Final
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
CÉLULA 10 — Triagem, Tratamentos, Facetagem/Montagem, Expedição
   |-- Triagem (troca JitBox se aplicável); Tratamentos; Facetagem e Montagem; Expedição
   |-- Apontamento INÍCIO → Apontamento TÉRMINO
   v
   Status: Expedido; integração Vendas (faturamento), Fiscal (NF), Estoque (saída para entrega)
```

### 6.2 Rastreabilidade Obrigatória

- **Cada uma das 10 Células** deve ter **apontamento de início** e **apontamento de término**.
- O **Roteiro de Produção** define a sequência (Células 1 a 10); o término da Célula N pode ser condição para permitir início da Célula N+1.
- Células de inspeção (6 e 9) podem registrar resultado (Aprovado/Refugado). Célula 10 (Triagem) registra troca de JitBox quando houver; na Expedição o JitBox é desvinculado.

### 6.3 Integração Produção ↔ Estoque

- **Saída (consumo):** Na Célula 5 (Estoque), bloco e insumos alocados na JitBox geram consumo: `MovimentacaoEstoque` tipo **Saída (Produção)** e redução de `EstoqueSaldo`.
- **Entrada/Saída (produto acabado):** Após Célula 10 (Facetagem/Montagem e Expedição), registro de produto acabado e saída para entrega; conforme regra de negócio, movimentações de entrada (produção) e saída (faturamento).
- **Reserva:** Antes da Célula 5, `ReservaEstoque` para bloco e insumos; liberada ao cancelar ou ao consumir.

### 6.4 Integração com Lensware

- **Célula 4 (Cálculo):** Dados do pedido são enviados ou digitados no Lensware; o Lensware retorna parâmetros de fabricação. Integração pode ser: arquivo (export/import), API ou processo manual com registro de “cálculo concluído” no ERP.

### 6.5 Expedição e Faturamento (Célula 10)

- Na **Expedição** (dentro da Célula 10): verificação de qualidade, desvinculação do JitBox, impressão do certificado de garantia (cartão PVC), **faturamento** (módulo Vendas/Financeiro) e **emissão/impressão da nota fiscal** (módulo Fiscal).

---

## 7. Relatórios e KPIs

### 7.1 Relatórios Operacionais

| Relatório | Descrição |
|-----------|-----------|
| Pedidos/Ordens em aberto | Por status (aguardando aprovação, em produção) com datas e receita |
| Apontamentos por OP | Listagem de todos os apontamentos (início/fim) por ordem e por **Célula** |
| Tempo por Célula | Duração (término − início) por Célula e por OP; médias por período |
| Consumo por OP | Bloco e insumos consumidos por ordem |
| Produção por período | Quantidade de lentes produzidas/expedidas por produto e período |
| Pedidos sem apontamento completo | Pedidos EmProdução com Células faltando início ou término |
| JitBox por pedido | Rastreio de qual JitBox está vinculada a cada pedido; histórico de trocas na Célula 10 |

### 7.2 Relatórios de Rastreabilidade

| Relatório | Descrição |
|-----------|-----------|
| Rastreio OP → Células | Para uma OP: sequência das 10 Células com data/hora de início e término |
| Rastreio Lote → OP | Dado um lote de lente ou de bloco: qual OP e em qual Célula |
| Rastreio JitBox | Movimentação do JitBox entre Células (Estoque, Triagem, Expedição) |

### 7.3 KPIs

| KPI | Descrição |
|-----|-----------|
| Tempo médio por Célula | Média da duração (término − início) por CelulaProducao no período |
| Tempo total (pedido → expedição) | Média do tempo entre Célula 1 término e Célula 10 término |
| Taxa de refugo (Inspeção Final — Célula 9) | % de pedidos com resultado Refugado na Célula 9 |
| Taxa de reprovação (Aprovação Financeira — Célula 2) | % de pedidos reprovados na Célula 2 |
| Pedidos atrasados | Quantidade de pedidos com DataPrevistaFim &lt; hoje e não expedidos |
| Eficiência | (Quantidade expedida / Quantidade planejada) × 100 |

---

## 8. Requisitos Fiscais — SPED Bloco K

O **Bloco K** do SPED Fiscal exige escrituração da produção e do consumo de insumos. O módulo de Produção deve alimentar:

| Registro | Uso no processo de lentes |
|----------|----------------------------|
| **K230** | Itens produzidos: lente acabada, quantidade, OP, data |
| **K235** | Insumos consumidos: bloco e demais insumos por OP, quantidade, valor/custo |
| **K250/K255** | Industrialização por terceiros (se houver etapa terceirizada) |

Integração com o módulo **Fiscal**: a partir dos eventos de consumo (OrdemProducaoConsumo) e de saída do produto acabado (OrdemProducaoSaida / Expedição na Célula 10), gerar os registros do Bloco K. A **Expedição** (faturamento e NF) integra com a escrituração fiscal de saída (NF-e, SPED).

---

## 9. Integração Entre Módulos

```
PRODUÇÃO → ESTOQUE
├── Consumo de bloco e insumos (Célula 5): MovimentacaoEstoque (Saída/Produção), EstoqueSaldo (-)
├── Entrada/saída de lente acabada (Célula 10): conforme regra de negócio
├── Reserva de bloco/insumos (ReservaEstoque)
└── Rastreabilidade: LoteProducao, JitBox, lotes de blocos consumidos

PRODUÇÃO ← ESTOQUE
├── Disponibilidade de blocos e insumos para Célula 5
└── Saldos por depósito

PRODUÇÃO ← COMPRAS
├── Compras de blocos e insumos
└── Industrialização por terceiros (se aplicável)

PRODUÇÃO ← VENDAS
├── Pedido de venda → geração de Pedido de Produção (make-to-order)
└── Expedição (Célula 10) → Faturamento (módulo Vendas)

PRODUÇÃO → FINANCEIRO
├── Custo da OP → custo do produto acabado
└── Faturamento na Expedição gera receita e títulos a receber

PRODUÇÃO → FISCAL
├── SPED Bloco K: K230, K235
└── Expedição: emissão da nota fiscal (NF-e) e escrituração
```

---

## 10. Resumo: Especificidade do Módulo para Lentes Oftálmicas

- **Departamento de Produção:** organizado em **Sub-Departamentos chamados Células**.
- **Roteiro de Produção:** em um roteiro completo o pedido passa pelas **Células 1 a 10** (10 etapas).
- **10 Células:** (1) Pedido de Produção, (2) Aprovação Financeira, (3) Aprovação do Pedido, (4) Cálculo (Lensware), (5) Estoque (JitBox), (6) Inspeção, (7) Blocagem, (8) Surfaçagem, (9) Polimento + Marcação + Deblocagem/Lavagem + Inspeção Final, (10) Triagem + Tratamentos + Facetagem/Montagem + Expedição.
- **Apontamento obrigatório:** Em **cada** uma das **10 Células (etapas)**, registro de **início** e de **término** (ApontamentoProducao com CelulaProducaoId e TipoApontamento = Inicio | Termino).
- **JitBox:** Caixa de produção vinculada ao pedido (Célula 5); troca possível na Célula 10 (Triagem); desvinculação na Expedição (Célula 10).
- **Lensware:** Software externo para cálculo (Célula 4).
- **Triagem e Expedição:** Dentro da Célula 10; redirecionamento por tipo de pedido; qualidade, certificado, faturamento e NF.
- **Integração:** Estoque (consumo e entrada/saída), Vendas (pedido e faturamento), Financeiro (custeio e receita), Fiscal (Bloco K e NF).

---

*Documento alinhado ao processo real de produção de lentes oftálmicas em laboratório óptico: Departamento de Produção, Células (1 a 10), Roteiro de Produção e apontamento de início e término em cada uma das 10 etapas.*
