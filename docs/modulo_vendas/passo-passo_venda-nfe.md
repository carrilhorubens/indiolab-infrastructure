# Manual de Teste: Fluxo Completo de Venda → NF-e

> **Login:** `ti@indiolab.com.br` / `Admin@123`

---

## Etapa 1 — Orçamento (opcional)

**Menu:** Vendas → Orçamentos

1. Clique em **"Novo Orçamento"**
2. Preencha:
   - **Cliente** — selecione um cliente existente
   - **Vendedor** — selecione um funcionário
   - **Condição de Pagamento** — ex: "À Vista"
   - **Forma de Pagamento** — ex: "Dinheiro"
   - **Canal de Venda** — ex: "Loja Física"
3. Adicione **itens** (produto, quantidade, preço unitário)
4. Clique **Salvar** (status = `Rascunho`)
5. Abra o orçamento criado (clique na linha)
6. No DetailDialog, avance o workflow:
   - **Enviar** → status `Enviado`
   - **Aprovar** → status `Aprovado`
   - **Converter para Pedido** → status `Convertido` (cria o Pedido de Venda automaticamente)

> Se quiser pular o orçamento, crie o pedido diretamente na Etapa 2.

---

## Etapa 2 — Pedido de Venda

**Menu:** Vendas → Pedidos de Venda

1. Clique em **"Novo Pedido de Venda"** (ou use o gerado pelo orçamento)
2. Preencha:
   - **Cliente**, **Vendedor**
   - **Data de Entrega Prevista**
   - **Condição de Pagamento**, **Forma de Pagamento**
   - **Prioridade** — Normal / Alta / Urgente
3. Adicione **itens** (produto, quantidade, preço, depósito)
4. Clique **Salvar** (status = `Rascunho`)
5. Abra o pedido e avance o workflow:
   - **Enviar para Aprovação** → `PendenteAprovação`
   - **Aprovar** → `Aprovado`
   - **Iniciar Separação** → `EmSeparação`

---

## Etapa 3 — Entrega de Venda

**Menu:** Vendas → Entregas

1. Clique em **"Nova Entrega"**
2. Preencha:
   - **Pedido de Venda** — selecione o pedido da Etapa 2
   - **Cliente** (auto-preenchido)
   - **Depósito de Origem** — ex: "Depósito Principal"
   - **Modalidade de Frete** — ex: "CIF"
   - **Data de Entrega Prevista**
3. Adicione os **itens** (mesmos do pedido, com lote/localização se aplicável)
4. Clique **Salvar** (status = `Rascunho`)
5. Avance o workflow:
   - **Iniciar Separação** → `EmSeparação`
   - **Concluir Separação** → `Separado`
   - **Despachar** → `EmTrânsito`
   - **Confirmar Entrega** → `Entregue`

> Isso gera **MovimentacaoEstoque de SAÍDA** e atualiza o saldo.

---

## Etapa 4 — Faturamento de Venda

**Menu:** Vendas → Faturamentos

1. Clique em **"Novo Faturamento"**
2. Preencha:
   - **Pedido de Venda** — selecione o pedido
   - **Entrega** (opcional) — vincule a entrega
   - **Cliente** (auto-preenchido)
   - **Data de Faturamento**, **Data de Vencimento**
   - **Condição de Pagamento**, **Forma de Pagamento**
   - **Seção Documento Fiscal:**
     - **Número NF** — ex: `000001`
     - **Série NF** — ex: `1`
     - **Chave de Acesso** — pode deixar vazio por enquanto
     - **Natureza da Operação** — ex: `Venda de mercadoria`
     - **CFOP** — ex: `5102`
3. Adicione os **itens** (mesmos do pedido)
4. Clique **Salvar** (status = `Rascunho`)
5. Abra o faturamento e clique **Autorizar** → status `Autorizada`

> Isso gera automaticamente: HistóricoPreço, ComissãoVenda e ContaReceber.

---

## Etapa 5 — Emissão da NF-e

**Menu:** Fiscal → Notas Fiscais

1. Clique no botão **"Emitir NF-e"** (canto superior direito)
2. **Passo 1 — Selecionar Cliente:**
   - Digite o nome do cliente no campo de busca
   - Selecione-o na lista
   - Clique **Próximo**
3. **Passo 2 — Selecionar Faturamentos:**
   - A tabela mostra os faturamentos **autorizados** pendentes de NF-e
   - Marque o(s) checkbox(es) dos faturamentos desejados
   - Clique **Próximo**
4. **Passo 3 — Emissão:**
   - Escolha o modo:
     - **Individual** — 1 NF-e por faturamento
     - **Agrupada** — 1 NF-e para todos os selecionados
   - Confira o resumo (Qtd faturamentos, Valor total, NF-es a gerar)
   - Clique **Emitir**
5. A NF-e é criada com status `Rascunho` e aparece na lista

---

## Resumo do Fluxo

```
Orçamento (opcional)
  └→ Rascunho → Enviado → Aprovado → Convertido
        ↓
Pedido de Venda
  └→ Rascunho → PendenteAprovação → Aprovado → EmSeparação
        ↓
Entrega de Venda
  └→ Rascunho → EmSeparação → Separado → EmTrânsito → Entregue
        ↓
Faturamento de Venda
  └→ Rascunho → Autorizada
        ↓
Nota Fiscal (NF-e)
  └→ Emitir NF-e (wizard 3 passos) → Rascunho
```
