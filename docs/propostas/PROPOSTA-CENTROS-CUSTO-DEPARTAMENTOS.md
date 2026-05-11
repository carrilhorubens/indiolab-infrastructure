# Proposta: Vínculo Centro de Custo ↔ Departamentos

**Data:** 09/04/2026
**Autor:** Equipe de Desenvolvimento OpticalCore
**Status:** Aguardando aprovação da Diretoria Financeira

---

## 1. Situação Atual

Hoje o sistema possui duas estruturas **independentes e sem vínculo**:

| Estrutura | Módulo | Finalidade | Exemplo |
|-----------|--------|-----------|---------|
| **Departamento** | R.H. | Organização de funcionários | Montagem, Atendimento, Financeiro |
| **Centro de Custo** | Financeiro | Alocação de custos e despesas | 01.01 Vendas, 01.02 Laboratório |

### Problemas identificados

1. **Requisição de Compra** — O solicitante precisa selecionar manualmente o Departamento e o Centro de Custo, mesmo sendo informações redundantes
2. **Risco de erro humano** — Um funcionário do departamento "Montagem" pode selecionar o centro de custo "Financeiro" por engano
3. **Sem rastreabilidade automática** — Não é possível gerar relatórios de custos por departamento sem cruzar dados manualmente
4. **Duplicidade de informação** — O mesmo conceito organizacional existe em dois cadastros sem conexão

---

## 2. Proposta

### Vincular cada Departamento a um Centro de Custo

Adicionar o campo `Centro de Custo` na tabela de **Departamentos**, estabelecendo que cada departamento pertence a exatamente um centro de custo.

### Modelo proposto

```
CENTRO DE CUSTO (Financeiro)          DEPARTAMENTO (R.H.)
─────────────────────────             ──────────────────────
01 Loja (Sintético)
├── 01.01 Vendas (Analítico)  ←────── Comercial
│                              ←────── Atendimento
├── 01.02 Laboratório         ←────── Montagem
│                              ←────── Surfaçagem
│                              ←────── Surfaçagem Digital
│                              ←────── AR
│                              ←────── Qualidade
│                              ←────── Cálculo e Inspeção
├── 01.03 Marketing           ←────── (a definir)
├── 01.04 Estoque             ←────── Estoque
│                              ←────── Triagem
02 Administrativo (Sintético)
├── 02.01 Financeiro          ←────── Financeiro
│                              ←────── Faturamento
├── 02.02 RH                  ←────── Geral
│                              ←────── TI
├── 02.03 Logística           ←────── Expedição
```

### Relação

| Tipo | Descrição |
|------|-----------|
| **1 Centro de Custo → N Departamentos** | Um centro de custo pode ter vários departamentos associados |
| **1 Departamento → 1 Centro de Custo** | Cada departamento pertence a apenas um centro de custo |

---

## 3. Benefícios

### Para a operação
- **Requisição de Compra simplificada** — O solicitante não precisa mais selecionar Departamento nem Centro de Custo. O sistema resolve automaticamente: `Funcionário → Departamento → Centro de Custo`
- **Zero erro humano** — Impossível selecionar o centro de custo errado
- **Menos campos no formulário** — Experiência do usuário mais rápida e limpa

### Para o financeiro
- **Relatórios automáticos** — Custos por centro de custo são calculados a partir dos departamentos envolvidos
- **Rastreabilidade completa** — Toda despesa, requisição ou conta a pagar vinculada a um departamento automaticamente tem um centro de custo
- **Orçamento por centro de custo** — O orçamento definido para um centro de custo cobre todos os departamentos vinculados
- **DRE por centro de custo** — Demonstrativo de Resultados com detalhamento por departamento dentro de cada centro

### Para a gestão
- **Visão consolidada** — O centro de custo "Laboratório" agrega automaticamente os custos de Montagem, Surfaçagem, Surfaçagem Digital, AR, etc.
- **Visão detalhada** — Drill-down do centro de custo para ver quanto cada departamento gastou
- **Consistência** — Um único ponto de configuração (cadastro de departamento) define tanto a hierarquia organizacional quanto a alocação financeira

---

## 4. Alterações Técnicas

### 4.1 Banco de Dados
| Alteração | Detalhes |
|-----------|---------|
| Adicionar coluna `centro_custo_id` na tabela `departamentos` | FK para `financeiro_centros_custo`, nullable inicialmente |
| Migration nova | `AddCentroCustoToDepartamento` |

### 4.2 Backend
| Alteração | Detalhes |
|-----------|---------|
| Entidade `Departamento` | Adicionar propriedade `CentroCustoId` e navegação |
| Requisição de Compra | Remover `DepartamentoId` e `CentroCustoId` do request — resolver automaticamente via Funcionário |
| Contas a Pagar/Receber | Opcionalmente preencher Centro de Custo a partir do departamento do solicitante |

### 4.3 Frontend
| Alteração | Detalhes |
|-----------|---------|
| Cadastro de Departamento | Adicionar campo "Centro de Custo" (select) |
| Cadastro de Centro de Custo | Exibir seção "Departamentos vinculados" (read-only, lista) |
| Requisição de Compra | Remover campos Departamento e Centro de Custo do formulário |
| Detail de Requisição | Continua exibindo Departamento e Centro de Custo (preenchidos automaticamente) |

---

## 5. Fluxo Proposto — Requisição de Compra

### Antes (atual)
```
Solicitante preenche:
  [Prioridade] [Data Necessidade] [Departamento ▼] [Centro de Custo ▼]
  [Justificativa]
  [Itens...]
```

### Depois (proposto)
```
Solicitante preenche:
  [Prioridade] [Data Necessidade]
  [Justificativa]
  [Itens...]

Sistema resolve automaticamente:
  Solicitante (login) → Funcionário → Departamento → Centro de Custo
```

**Resultado:** 2 campos a menos no formulário, zero possibilidade de erro.

---

## 6. Impacto nos Módulos

| Módulo | Impacto | Risco |
|--------|---------|-------|
| **R.H. — Departamentos** | Adicionar campo Centro de Custo | Baixo — campo novo, sem quebra |
| **Financeiro — Centros de Custo** | Exibir departamentos vinculados | Baixo — apenas visualização |
| **Compras — Requisições** | Remover 2 campos do formulário | Baixo — melhoria de UX |
| **Financeiro — Contas a Pagar** | Sem alteração imediata | Nenhum |
| **Financeiro — Orçamentos** | Sem alteração imediata | Nenhum |
| **Financeiro — DRE** | Potencial drill-down por departamento (futuro) | Nenhum |

---

## 7. Cronograma Estimado

| Etapa | Descrição |
|-------|-----------|
| 1 | Aprovação da diretoria financeira |
| 2 | Migration + backend (entidade, service, controller) |
| 3 | Frontend (formulários de departamento e centro de custo) |
| 4 | Ajuste na requisição de compra (remoção dos campos) |
| 5 | Associação dos 16 departamentos aos centros de custo existentes |
| 6 | Testes e validação |

---

## 8. Decisões Pendentes

A diretoria financeira precisa definir:

1. **Mapeamento inicial** — Qual departamento pertence a qual centro de custo? (sugestão na seção 2)
2. **Centros de custo faltantes** — Existem departamentos que precisam de um novo centro de custo? (ex: "02.03 Logística" para Expedição)
3. **Obrigatoriedade** — Todo departamento deve ter um centro de custo, ou pode ser opcional?
4. **Contas a Pagar** — Desejam que o centro de custo seja preenchido automaticamente também nas contas a pagar, quando o lançamento vier de uma requisição?

---

*Documento gerado para análise da Diretoria Financeira. Aguardando aprovação para início da implementação.*
