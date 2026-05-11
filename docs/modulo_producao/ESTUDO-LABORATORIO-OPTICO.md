# Estudo: Produto Fabricado para Laboratório Óptico

> Análise de como o módulo Produto Fabricado (BOM) atende o fluxo de produção de lentes marca própria em um laboratório óptico.

---

## 1. Contexto do Laboratório Óptico

Um laboratório óptico trabalha com três tipos principais de produtos no estoque:

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| **Bloco** | Matéria-prima — lente bruta sem serviços de produção | Bloco Semi-Acabado 1.56 |
| **Insumo** | Material consumido pelos equipamentos de produção | Fluido de Polimento, Lixas |
| **Lente Acabada** | Lente pronta com dioptria correta, mas sem tratamentos/corte | Lente Pronta HMC 1.56 |

### Fluxo de Produção

Para produzir uma lente **marca própria** do laboratório (ex: "Extik One"):

1. Utiliza-se **1 bloco** como matéria-prima
2. O bloco passa pelo **processo de produção** (surfaçagem, polimento, tratamento, corte)
3. O resultado é **1 lente acabada** com a marca do laboratório

**Regra de negócio:** Para produzir 1 par de lentes (necessário para montar 1 óculos), são necessários **2 blocos**.

---

## 2. Diagnóstico: O Que Já Existe no Sistema

O módulo **Produto Fabricado** já está 100% implementado e resolve exatamente o cenário descrito.

### Mapeamento Conceito → Entidade

| Conceito do Laboratório | Entidade no Sistema | Tabela | Campo-chave |
|---|---|---|---|
| **Bloco** (matéria-prima) | `Produto` | `estoque_produtos` | `fabricado = false` |
| **Insumo** | `Produto` | `estoque_produtos` | `fabricado = false` |
| **Lente Acabada (comprada)** | `Produto` | `estoque_produtos` | `fabricado = false` |
| **Lente Marca Própria** | `Produto` | `estoque_produtos` | `fabricado = true` |
| **Receita de fabricação** | `ListaMaterial` (BOM) | `producao_listas_material` | FK → `estoque_produtos` |
| **Bloco usado na receita** | `ListaMaterialItem` | `producao_lista_material_itens` | FK → `estoque_produtos` |
| **Cálculo de necessidades** | Explosão de BOM | Endpoint API | Multi-nível recursivo |

### Entidades Backend

#### Produto (`Domain/Entities/Estoque/Produto.cs`)

Campos específicos para produto fabricado:

```csharp
public bool Fabricado { get; private set; }          // marca o produto como fabricado (marca própria)
public int LeadTimeProducaoDias { get; private set; } // prazo de produção em dias
```

#### ListaMaterial (`Domain/Entities/Producao/ListaMaterial.cs`)

Vincula um produto fabricado aos seus componentes (receita de fabricação):

- `ProdutoId` — FK para o produto fabricado (ex: "Extik One 1.56")
- `Versao` — controle de versões da BOM (ex: "01", "02")
- `TipoListaMaterialId` — "Fabricação", "Kit", "Fantasma", "Fórmula"
- `QuantidadeProducao` — quantas unidades a BOM produz (padrão: 1)
- `UnidadeMedidaId` — unidade de medida da produção
- `DataInicioVigencia` / `DataFimVigencia` — período de validade da BOM
- `Observacoes` — notas sobre o processo

#### ListaMaterialItem (`Domain/Entities/Producao/ListaMaterialItem.cs`)

Cada item representa um componente da receita:

- `ProdutoId` — FK para o componente (ex: "Bloco Semi-Acabado 1.56")
- `Quantidade` — quantas unidades do componente (ex: 1 bloco por lente)
- `UnidadeMedidaId` — unidade de medida do componente
- `TipoItemBomId` — "Normal", "Fantasma", "Sobressalente"
- `PercentualPerda` — perda estimada no processo (ex: 5%)
- `Sequencia` — ordem do item na BOM

### Domínios Auxiliares

| Domínio | Tabela | Seeds |
|---------|--------|-------|
| `TipoListaMaterial` | `public.tipos_lista_material` | Fabricação (padrão), Kit, Fantasma, Fórmula |
| `TipoItemBom` | `public.tipos_item_bom` | Normal (padrão), Fantasma, Sobressalente |

### Endpoints da API

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/api/listas-material` | Listar BOMs (paginado, filtro por produto) |
| GET | `/api/listas-material/{id}` | Detalhe de uma BOM |
| POST | `/api/listas-material` | Criar nova BOM |
| PUT | `/api/listas-material/{id}` | Atualizar BOM |
| DELETE | `/api/listas-material/{id}` | Excluir BOM |
| GET | `/api/listas-material/proximo-codigo` | Próximo código disponível |
| GET | `/api/listas-material/{id}/explosao?quantidade=N` | Explosão de necessidades |

### Frontend

| Página | Rota | Função |
|--------|------|--------|
| Listas de Material | `/producao/listas-material` | CRUD completo de BOMs |
| Explosão de Necessidades | `/producao/explosao-necessidades` | Calcula materiais para produzir N unidades |

---

## 3. Arquitetura: "Módulo Separado Foi Errado?"

**Não.** A separação é uma decisão arquitetural válida e segue padrões de mercado:

- O **Produto** continua sendo uma entidade do **Estoque** (tabela `estoque_produtos`)
- A **ListaMaterial** é uma entidade de **manufatura/produção** que **referencia** produtos do estoque via FK
- A pasta `Domain/Entities/Producao/` contém apenas as entidades de BOM, não duplica o Produto
- As foreign keys apontam para `estoque_produtos` — integração perfeita com o estoque

### Padrão de ERPs de Mercado

| ERP | Módulo de BOM | Integração com Estoque |
|-----|---------------|----------------------|
| **SAP** | PP (Production Planning) — módulo separado | Referencia materiais do MM (Materials Management) |
| **TOTVS Protheus** | Engenharia (SG1) — módulo separado | Referencia produtos do Estoque (SB1) |
| **Oracle EBS** | BOM Module — módulo separado | Referencia itens do Inventory (INV) |

O OpticalCore segue o mesmo padrão: o cadastro de BOM é um módulo de **Engenharia/Produção** separado do módulo de Estoque, mas referenciando os mesmos produtos.

---

## 4. Exemplo Prático: Cadastrando "Extik One"

### Passo 1 — Cadastrar o Bloco no Estoque

| Campo | Valor |
|-------|-------|
| Nome | Bloco Semi-Acabado 1.56 |
| Fabricado | `false` (matéria-prima comprada) |
| Categoria | Matéria-Prima / Lentes |
| Unidade de Medida | UN (unidade) |

### Passo 2 — Cadastrar a Lente Marca Própria

| Campo | Valor |
|-------|-------|
| Nome | Extik One 1.56 |
| Fabricado | `true` |
| Lead Time Produção | 3 dias |
| Categoria | Lentes Acabadas |
| Unidade de Medida | UN (unidade) |

### Passo 3 — Criar a Lista de Material (BOM)

| Campo | Valor |
|-------|-------|
| Produto | Extik One 1.56 |
| Versão | 01 |
| Tipo | Fabricação |
| Quantidade de Produção | 1 (1 lente por BOM) |

**Item 1 da BOM:**

| Campo | Valor |
|-------|-------|
| Produto (componente) | Bloco Semi-Acabado 1.56 |
| Quantidade | 1 |
| Tipo Item | Normal |
| Perda | 5% |
| Unidade de Medida | UN |

### Passo 4 — Calcular necessidades para 1 par (2 lentes)

Acessar **Explosão de Necessidades** → selecionar BOM "Extik One 1.56" → Quantidade: **2**

**Resultado:**

| Nível | Produto | Qtd. Necessária | Perda % | Qtd. com Perda |
|-------|---------|-----------------|---------|----------------|
| N1 | Bloco Semi-Acabado 1.56 | 2,0000 | 5% | 2,1000 |

Ou seja: para produzir 2 lentes "Extik One", são necessários **2,10 blocos** (considerando 5% de perda).

---

## 5. BOM Avançada: Exemplo com Múltiplos Componentes

Para uma lente mais complexa que utiliza bloco + insumos:

### BOM "Extik Premium 1.67 AR" (Versão 01)

| Seq | Componente | Tipo | Qtd | UM | Perda % |
|-----|-----------|------|-----|-----|---------|
| 1 | Bloco Semi-Acabado 1.67 | Normal | 1 | UN | 5% |
| 2 | Tratamento Antirreflexo (AR) | Normal | 1 | UN | 2% |
| 3 | Fluido de Polimento | Normal | 0,05 | L | 10% |
| 4 | Lixa de Polimento | Sobressalente | 0,5 | UN | 0% |

**Explosão para 100 lentes:**

| Nível | Componente | Qtd. Necessária | Qtd. com Perda |
|-------|-----------|-----------------|----------------|
| N1 | Bloco Semi-Acabado 1.67 | 100 | 105 |
| N1 | Tratamento Antirreflexo | 100 | 102 |
| N1 | Fluido de Polimento | 5 L | 5,5 L |
| N1 | Lixa de Polimento | 50 | 50 |

---

## 6. Funcionalidades Avançadas Já Implementadas

### BOM Multi-Nível (até 10 níveis)

Se um componente também for fabricado (ex: "Bloco Preparado" que vem de um "Bloco Bruto"), o sistema faz explosão recursiva:

```
Extik One 1.56
├── Bloco Preparado 1.56 (Fabricado = true, tem sua própria BOM)
│   ├── Bloco Bruto 1.56 × 1
│   └── Primer de Aderência × 0.02 L
└── Tratamento AR × 1
```

A explosão calcula automaticamente os materiais de todos os níveis.

### Itens Fantasma

Itens do tipo "Fantasma" são sub-montagens intermediárias que não geram estoque próprio. O sistema expande automaticamente seus componentes na explosão.

### Versionamento de BOM

Cada BOM tem uma versão (ex: "01", "02") e datas de vigência, permitindo:
- Manter histórico de receitas anteriores
- Planejar mudanças futuras com data de início
- Comparar versões

---

## 7. Melhorias Sugeridas para Fases Futuras

O módulo base atende o cenário descrito. Para um laboratório óptico **profissional**, há melhorias possíveis:

### Prioridade Alta

| Melhoria | Descrição |
|----------|-----------|
| **Ordem de Produção** | Registrar a execução real da fabricação: consumo de MP do estoque, apontamento de produção (operador, máquina, tempos), entrada do produto acabado no estoque. Workflow: Planejada → Em Produção → Finalizada. |
| **Consumo automático de estoque** | Ao finalizar a Ordem de Produção, dar baixa automática nos blocos/insumos consumidos e dar entrada no produto acabado. |

### Prioridade Média

| Melhoria | Descrição |
|----------|-----------|
| **Categorias específicas ópticas** | Criar categorias de produto: "Bloco", "Lente Acabada", "Insumo de Produção", "Acessório" |
| **Ficha Técnica do Produto** | Campos específicos da lente: índice de refração, diâmetro, curva base, faixa de adição, design (esférico, asférico, progressivo), material (CR-39, policarbonato, resina) |
| **Dashboard de Produção** | KPIs: produção diária, taxa de perda real vs estimada, produtos mais fabricados, lead time médio |

### Prioridade Futura

| Melhoria | Descrição |
|----------|-----------|
| **Roteiro de Produção** | Sequência de operações: surfaçagem → polimento → tratamento → corte → montagem. Cada operação com tempo padrão e centro de trabalho. |
| **Rastreabilidade lote→produção** | Vincular lote de MP ao lote do produto acabado (ex: "Lote de blocos X gerou lentes Y") |
| **Planejamento de Produção (MRP)** | Calcular automaticamente ordens de produção com base em pedidos de venda + estoque mínimo |
| **Custo de Produção** | Calcular custo do produto fabricado = custo MP + custo mão de obra + custos indiretos |

---

## 8. Conclusão

O sistema **já possui** a solução completa para o cenário descrito:

1. Cadastrar produtos marca própria → `Produto` com `Fabricado = true`
2. Definir quais blocos/MPs compõem cada produto → `ListaMaterial` (BOM)
3. Calcular necessidades de materiais → Explosão de Necessidades (multi-nível, com perda)

**Não é necessário criar nada novo para atender o requisito atual.**

O próximo passo natural seria implementar **Ordens de Produção** para registrar a execução real da fabricação (consumo de MP do estoque + entrada do produto acabado), o que completaria o ciclo produtivo do laboratório.
