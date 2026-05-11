# COMPOSICAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOSICAO (Composições Gerais)
- **Total de Registros**: 51.308
- **Total de Colunas**: 12
- **Chave Primária**: (COMPOSEQ, COMPOPROCODIGO) - Composta
- **Chaves Estrangeiras**: 0 (formais)
- **Índices**: 3 (IND_COMPOPROCODIGO, IND_COMPOPRODUCODIGO, IND_COMPOSERCODIGO)
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOSICAO** é uma tabela de composições gerais que armazena informações sobre composições de produtos e serviços, permitindo definir estruturas complexas de composição com múltiplos tipos de componentes. Com **51.308 registros**, representa composições extensivas de produtos e serviços, essencial para gestão de estruturas complexas de produção.

Esta tabela funciona como **estrutura de composições gerais** e permite:
- Definir composições de produtos e serviços
- Suportar produtos simples, produtos compostos e serviços compostos como componentes
- Especificar ordem de execução dos componentes
- Controlar envio em pedidos
- Definir regras de tratamento e cor obrigatórios
- Suportar valores de exceção
- Controlar se deve somar apenas produtos

Cada registro representa um item componente específico de uma composição geral, contendo:
- Sequência da composição (COMPOSEQ)
- Código do produto principal (COMPOPROCODIGO)
- Descrição da composição (COMPODESCRICAO)
- Código do produto composto componente (COMPOPRODUCODIGO)
- Código do serviço composto componente (COMPOSERCODIGO)
- Ordem de execução (COMPOORDEM)
- Flag de envio em pedido (COMPOENVSPED)
- Data da última alteração (COMPOULTALT)
- Flag de tratamento obrigatório (COMPOBRIGTRAT)
- Flag de cor obrigatória (COMPOBRIGCOLOR)
- Valor de exceção (COMPOVALEXCECAO)
- Flag de somar apenas produtos (COMPOSOMENTEPROD)

O sistema utiliza esta tabela para definir estruturas complexas de composição que podem incluir produtos simples, produtos compostos e serviços compostos, permitindo flexibilidade máxima na definição de processos de produção.

**Observação Importante:** COMPOSICAO é uma tabela flexível que pode referenciar produtos (PRODU), produtos compostos (COMPOPRODU) e serviços compostos (COMPOSER). Com 51.308 registros e 3 índices em campos de relacionamento, indica uso extensivo de composições gerais, essencial para processos de produção complexos.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPOSEQ** 🔑 | INTEGER | ✓ | Sequência da composição (PK) |
| **COMPOPROCODIGO** 🔑 | VARCHAR(37) | ✓ | Código do produto principal (PK, lógica → PRODU) |

### Informações da Composição
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPODESCRICAO** | VARCHAR(37) | | Descrição da composição |
| **COMPOPRODUCODIGO** | INTEGER | | Código do produto composto componente (lógica → COMPOPRODU) |
| **COMPOSERCODIGO** | INTEGER | | Código do serviço composto componente (lógica → COMPOSER) |
| **COMPOORDEM** | INTEGER | ✓ | Ordem de execução do componente |

### Controle de Processo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPOENVSPED** | VARCHAR(14) | | Flag indicando se deve enviar em pedido |
| **COMPOULTALT** | TIMESTAMP | | Data da última alteração |
| **COMPOBRIGTRAT** | VARCHAR(14) | | Flag indicando se tratamento é obrigatório |
| **COMPOBRIGCOLOR** | VARCHAR(14) | | Flag indicando se cor é obrigatória |
| **COMPOVALEXCECAO** | VARCHAR(14) | | Valor de exceção |
| **COMPOSOMENTEPROD** | VARCHAR(14) | | Flag indicando se deve somar apenas produtos |

**Primary Key:** (COMPOSEQ, COMPOPROCODIGO)

**Observações sobre Campos:**
- **COMPOSEQ**: Sequência que identifica cada item da composição.
- **COMPOPROCODIGO**: Produto principal da composição.
- **COMPODESCRICAO**: Descrição do item da composição.
- **COMPOPRODUCODIGO**: Produto composto componente (opcional).
- **COMPOSERCODIGO**: Serviço composto componente (opcional).
- **COMPOORDEM**: Ordem em que o componente deve ser processado.
- **COMPOENVSPED**: Flag indicando se o componente deve ser enviado no pedido.
- **COMPOULTALT**: Data da última alteração do registro.
- **COMPOBRIGTRAT**: Flag indicando se tratamento é obrigatório para este componente.
- **COMPOBRIGCOLOR**: Flag indicando se cor é obrigatória para este componente.
- **COMPOVALEXCECAO**: Valor de exceção específico para este componente.
- **COMPOSOMENTEPROD**: Flag indicando se deve somar apenas produtos na composição.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOSICAO Referencia (0 FKs Formais):

**Nenhuma foreign key formal** está definida na tabela COMPOSICAO. No entanto, há relacionamentos lógicos importantes:

#### 1. PRODU - Produtos (Principal) (Lógico)
**Relacionamento Lógico:**
```
COMPOSICAO.COMPOPROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição**: Cada registro está logicamente vinculado a um produto principal específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto principal da composição, obter informações do produto.

---

#### 2. COMPOPRODU - Produtos Compostos (Componente) (Lógico)
**Relacionamento Lógico:**
```
COMPOSICAO.COMPOPRODUCODIGO → COMPOPRODU.COMPPRODUCOD (N:1)
```

**Descrição**: Cada registro pode estar logicamente vinculado a um produto composto componente específico.

**Informações da Tabela COMPOPRODU:**
- **Total:** 51.308 produtos compostos
- **PK:** COMPPRODUCOD

**Uso:** Identificar o produto composto componente da composição, obter informações do produto composto.

---

#### 3. COMPOSER - Serviços Compostos (Componente) (Lógico)
**Relacionamento Lógico:**
```
COMPOSICAO.COMPOSERCODIGO → COMPOSER.COMPSERCOD (N:1)
```

**Descrição**: Cada registro pode estar logicamente vinculado a um serviço composto componente específico.

**Informações da Tabela COMPOSER:**
- **Total:** 37.938 serviços compostos
- **PK:** COMPSERCOD

**Uso:** Identificar o serviço composto componente da composição, obter informações do serviço composto.

---

### COMPOSICAO é Referenciada Por

**Nenhuma tabela** referencia COMPOSICAO diretamente. Esta é uma tabela folha utilizada para composições e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via COMPOPROCODIGO → PRODU → PDCAO (Ordens de Produção)

**Fluxo:** COMPOSICAO → PRODU → PDCAO

**Descrição:** Através do produto principal, é possível identificar ordens de produção relacionadas.

**Uso:** Análise de produção usando composições.

---

### Via COMPOPRODUCODIGO → COMPOPRODU → COMPOPRODUITEM (Itens de Produtos Compostos)

**Fluxo:** COMPOSICAO → COMPOPRODU → COMPOPRODUITEM

**Descrição:** Através do produto composto componente, é possível identificar itens relacionados.

**Uso:** Análise de produtos compostos em composições.

---

### Via COMPOSERCODIGO → COMPOSER → Serviços Compostos

**Fluxo:** COMPOSICAO → COMPOSER

**Descrição:** Através do serviço composto componente, é possível identificar serviços relacionados.

**Uso:** Análise de serviços compostos em composições.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Composição

**Objetivo:** Obter visão completa de uma composição incluindo informações do produto principal e componentes.

**Fluxo:**
```
COMPOSICAO (COMPOPROCODIGO, COMPOPRODUCODIGO, COMPOSERCODIGO)
  ↓
PRODU (COMPOPROCODIGO)
  ↓
COMPOPRODU (COMPOPRODUCODIGO)
  ↓
COMPOSER (COMPOSERCODIGO)
```

**Query SQL:**
```sql
SELECT
    co.COMPOSEQ,
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO_PRINCIPAL,
    co.COMPODESCRICAO AS DESCRICAO_COMPOSICAO,
    co.COMPOPRODUCODIGO AS PRODUTO_COMPOSTO_COMPONENTE,
    cp.COMPPRODUDESCRICAO AS DESCRICAO_PRODUTO_COMPOSTO,
    co.COMPOSERCODIGO AS SERVICO_COMPOSTO_COMPONENTE,
    cs.COMPSERDESCRICAO AS DESCRICAO_SERVICO_COMPOSTO,
    co.COMPOORDEM AS ORDEM_EXECUCAO,
    co.COMPOENVSPED AS ENVIAR_EM_PEDIDO,
    co.COMPOBRIGTRAT AS TRATAMENTO_OBRIGATORIO,
    co.COMPOBRIGCOLOR AS COR_OBRIGATORIA,
    co.COMPOVALEXCECAO AS VALOR_EXCECAO,
    co.COMPOSOMENTEPROD AS SOMAR_APENAS_PRODUTOS
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
LEFT JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = co.COMPOPRODUCODIGO
LEFT JOIN COMPOSER cs ON cs.COMPSERCOD = co.COMPOSERCODIGO
WHERE co.COMPOPROCODIGO = ?
ORDER BY co.COMPOORDEM, co.COMPOSEQ;
```

---

### Exemplo 2: Análise de Composições por Tipo de Componente

**Objetivo:** Obter composições agrupadas por tipo de componente (produto composto ou serviço composto).

**Query SQL:**
```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    COUNT(CASE WHEN co.COMPOPRODUCODIGO IS NOT NULL THEN 1 END) AS TOTAL_PRODUTOS_COMPOSTOS,
    COUNT(CASE WHEN co.COMPOSERCODIGO IS NOT NULL THEN 1 END) AS TOTAL_SERVICOS_COMPOSTOS,
    COUNT(*) AS TOTAL_COMPONENTES
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
GROUP BY co.COMPOPROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

### Exemplo 3: Análise de Composições com Produtos Compostos

**Objetivo:** Obter composições que utilizam produtos compostos como componentes.

**Query SQL:**
```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr1.PRODESCRICAO AS DESCRICAO_PRODUTO_PRINCIPAL,
    co.COMPOPRODUCODIGO AS PRODUTO_COMPOSTO_COMPONENTE,
    cp.COMPPRODUDESCRICAO AS DESCRICAO_PRODUTO_COMPOSTO,
    co.COMPOORDEM AS ORDEM_EXECUCAO
FROM COMPOSICAO co
INNER JOIN PRODU pr1 ON pr1.PROCODIGO = co.COMPOPROCODIGO
INNER JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = co.COMPOPRODUCODIGO
WHERE co.COMPOPRODUCODIGO IS NOT NULL
ORDER BY co.COMPOPROCODIGO, co.COMPOORDEM;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Composição de um Produto

**Objetivo:** Obter todos os componentes de uma composição específica.

```sql
SELECT
    COMPOSEQ,
    COMPODESCRICAO AS DESCRICAO_COMPOSICAO,
    COMPOPRODUCODIGO AS PRODUTO_COMPOSTO_COMPONENTE,
    COMPOSERCODIGO AS SERVICO_COMPOSTO_COMPONENTE,
    COMPOORDEM AS ORDEM_EXECUCAO,
    COMPOENVSPED AS ENVIAR_EM_PEDIDO,
    COMPOBRIGTRAT AS TRATAMENTO_OBRIGATORIO,
    COMPOBRIGCOLOR AS COR_OBRIGATORIA
FROM COMPOSICAO
WHERE COMPOPROCODIGO = ?
ORDER BY COMPOORDEM, COMPOSEQ;
```

---

### 2. Listar Composições que Usam um Produto Composto

**Objetivo:** Identificar todas as composições que utilizam um produto composto específico como componente.

```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO_PRINCIPAL,
    co.COMPOORDEM AS ORDEM_EXECUCAO,
    co.COMPODESCRICAO AS DESCRICAO_COMPOSICAO
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
WHERE co.COMPOPRODUCODIGO = ?
ORDER BY pr.PRODESCRICAO, co.COMPOORDEM;
```

---

### 3. Listar Composições que Usam um Serviço Composto

**Objetivo:** Identificar todas as composições que utilizam um serviço composto específico como componente.

```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO_PRINCIPAL,
    co.COMPOORDEM AS ORDEM_EXECUCAO,
    co.COMPODESCRICAO AS DESCRICAO_COMPOSICAO
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
WHERE co.COMPOSERCODIGO = ?
ORDER BY pr.PRODESCRICAO, co.COMPOORDEM;
```

---

### 4. Análise de Composições Mais Complexas

**Objetivo:** Identificar composições com mais componentes.

```sql
SELECT
    COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    COUNT(*) AS TOTAL_COMPONENTES,
    COUNT(DISTINCT COMPOPRODUCODIGO) AS TOTAL_PRODUTOS_COMPOSTOS_DIFERENTES,
    COUNT(DISTINCT COMPOSERCODIGO) AS TOTAL_SERVICOS_COMPOSTOS_DIFERENTES,
    MAX(COMPOORDEM) AS ORDEM_MAXIMA
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
GROUP BY COMPOPROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

### 5. Análise de Composições com Tratamento Obrigatório

**Objetivo:** Identificar composições que têm componentes com tratamento obrigatório.

**Query SQL:**
```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    co.COMPODESCRICAO AS DESCRICAO_COMPOSICAO,
    co.COMPOORDEM AS ORDEM_EXECUCAO,
    co.COMPOBRIGTRAT AS TRATAMENTO_OBRIGATORIO
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
WHERE co.COMPOBRIGTRAT IS NOT NULL
  AND UPPER(co.COMPOBRIGTRAT) = 'S'
ORDER BY co.COMPOPROCODIGO, co.COMPOORDEM;
```

---

### 6. Análise de Composições com Cor Obrigatória

**Objetivo:** Identificar composições que têm componentes com cor obrigatória.

**Query SQL:**
```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_PRINCIPAL,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    co.COMPODESCRICAO AS DESCRICAO_COMPOSICAO,
    co.COMPOORDEM AS ORDEM_EXECUCAO,
    co.COMPOBRIGCOLOR AS COR_OBRIGATORIA
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
WHERE co.COMPOBRIGCOLOR IS NOT NULL
  AND UPPER(co.COMPOBRIGCOLOR) = 'S'
ORDER BY co.COMPOPROCODIGO, co.COMPOORDEM;
```

---

### 7. Relatório de Composições

**Objetivo:** Analisar distribuição completa de composições.

**Query SQL:**
```sql
SELECT
    COUNT(DISTINCT COMPOPROCODIGO) AS TOTAL_PRODUTOS_COM_COMPOSICAO,
    COUNT(*) AS TOTAL_COMPONENTES,
    COUNT(DISTINCT COMPOPRODUCODIGO) AS TOTAL_PRODUTOS_COMPOSTOS_UTILIZADOS,
    COUNT(DISTINCT COMPOSERCODIGO) AS TOTAL_SERVICOS_COMPOSTOS_UTILIZADOS,
    COUNT(CASE WHEN COMPOBRIGTRAT IS NOT NULL AND UPPER(COMPOBRIGTRAT) = 'S' THEN 1 END) AS TOTAL_COM_TRATAMENTO_OBRIGATORIO,
    COUNT(CASE WHEN COMPOBRIGCOLOR IS NOT NULL AND UPPER(COMPOBRIGCOLOR) = 'S' THEN 1 END) AS TOTAL_COM_COR_OBRIGATORIA,
    AVG(componentes_por_produto.TOTAL) AS MEDIA_COMPONENTES_POR_PRODUTO
FROM COMPOSICAO
CROSS JOIN (
    SELECT COUNT(*) AS TOTAL
    FROM COMPOSICAO
    GROUP BY COMPOPROCODIGO
) componentes_por_produto;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOSICAO | Tipo |
|--------|-----------|---------------------|------|
| **COMPOSICAO** | 51.308 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | 178.187 | 3.47:1 | Produtos (29% têm composições) |
| COMPOPRODU | 51.308 | 1:1 | Produtos compostos (mesmo número de registros) |
| COMPOSER | 37.938 | 0.74:1 | Serviços compostos (média de 1.35 itens por serviço composto) |

**Interpretação:**
- **51.308 composições** cadastradas no sistema
- **29% dos produtos** têm composições cadastradas (51.308 de 178.187)
- **Mesmo número de registros** que COMPOPRODU - possível relação direta
- **Uso extensivo** - indica estrutura complexa de composições

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IND_COMPOPROCODIGO** - Índice em COMPOPROCODIGO
2. **IND_COMPOPRODUCODIGO** - Índice em COMPOPRODUCODIGO
3. **IND_COMPOSERCODIGO** - Índice em COMPOSERCODIGO

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índices existentes** - Em COMPOPROCODIGO, COMPOPRODUCODIGO e COMPOSERCODIGO são essenciais
3. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca composta por produto principal e ordem (consultas frequentes)
CREATE INDEX IDX_COMPOSICAO_PRO_ORDEM ON COMPOSICAO(COMPOPROCODIGO, COMPOORDEM);

-- Índice 2: Busca por sequência (consultas de validação)
CREATE INDEX IDX_COMPOSICAO_SEQ ON COMPOSICAO(COMPOSEQ);
```

### Observações sobre Volume

- **Tabela média** (51.308 registros) - Performance boa com índices adequados
- **Índices existentes** - Em COMPOPROCODIGO, COMPOPRODUCODIGO e COMPOSERCODIGO são essenciais
- **Consultas frequentes** - Composições são consultadas durante criação de pedidos e produção
- **Índices compostos** - Para consultas combinadas (produto + ordem)

---

## 🔍 Validações e Integridade

### Verificar Integridade Lógica

```sql
-- Verificar produtos principais inexistentes
SELECT DISTINCT co.COMPOPROCODIGO
FROM COMPOSICAO co
WHERE NOT EXISTS (SELECT 1 FROM PRODU pr WHERE pr.PROCODIGO = co.COMPOPROCODIGO);

-- Verificar produtos compostos componentes inexistentes
SELECT DISTINCT co.COMPOPRODUCODIGO
FROM COMPOSICAO co
WHERE co.COMPOPRODUCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM COMPOPRODU cp WHERE cp.COMPPRODUCOD = co.COMPOPRODUCODIGO);

-- Verificar serviços compostos componentes inexistentes
SELECT DISTINCT co.COMPOSERCODIGO
FROM COMPOSICAO co
WHERE co.COMPOSERCODIGO IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM COMPOSER cs WHERE cs.COMPSERCOD = co.COMPOSERCODIGO);
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOSICAO
WHERE COMPOSEQ IS NULL
   OR COMPOPROCODIGO IS NULL
   OR COMPOPROCODIGO = ''
   OR COMPOORDEM IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT COMPOSEQ, COMPOPROCODIGO, COUNT(*) AS QTD
FROM COMPOSICAO
GROUP BY COMPOSEQ, COMPOPROCODIGO
HAVING COUNT(*) > 1;

-- Verificar composições sem componentes definidos
SELECT *
FROM COMPOSICAO
WHERE COMPOPRODUCODIGO IS NULL
  AND COMPOSERCODIGO IS NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class FirebirdComposicao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOSICAO';
    
    protected $primaryKey = ['COMPOSEQ', 'COMPOPROCODIGO'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'COMPOSEQ' => 'integer',
        'COMPOPROCODIGO' => 'string',
        'COMPODESCRICAO' => 'string',
        'COMPOPRODUCODIGO' => 'integer',
        'COMPOSERCODIGO' => 'integer',
        'COMPOORDEM' => 'integer',
        'COMPOENVSPED' => 'string',
        'COMPOULTALT' => 'datetime',
        'COMPOBRIGTRAT' => 'string',
        'COMPOBRIGCOLOR' => 'string',
        'COMPOVALEXCECAO' => 'string',
        'COMPOSOMENTEPROD' => 'string',
    ];

    // Relacionamento lógico com PRODU
    public function produtoPrincipal(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'COMPOPROCODIGO', 'PROCODIGO');
    }

    // Relacionamento lógico com COMPOPRODU
    public function produtoComposto(): BelongsTo
    {
        return $this->belongsTo(FirebirdCompoprodu::class, 'COMPOPRODUCODIGO', 'COMPPRODUCOD');
    }

    // Relacionamento lógico com COMPOSER
    public function servicoComposto(): BelongsTo
    {
        return $this->belongsTo(FirebirdComposer::class, 'COMPOSERCODIGO', 'COMPSERCOD');
    }

    // Método para verificar se tem produto composto
    public function temProdutoComposto(): bool
    {
        return !empty($this->COMPOPRODUCODIGO);
    }

    // Método para verificar se tem serviço composto
    public function temServicoComposto(): bool
    {
        return !empty($this->COMPOSERCODIGO);
    }

    // Método para verificar se tratamento é obrigatório
    public function tratamentoObrigatorio(): bool
    {
        return !empty($this->COMPOBRIGTRAT) && strtoupper($this->COMPOBRIGTRAT) === 'S';
    }

    // Método para verificar se cor é obrigatória
    public function corObrigatoria(): bool
    {
        return !empty($this->COMPOBRIGCOLOR) && strtoupper($this->COMPOBRIGCOLOR) === 'S';
    }

    // Scope para filtrar por produto principal
    public function scopePorProdutoPrincipal($query, string $produtoCodigo)
    {
        return $query->where('COMPOPROCODIGO', $produtoCodigo);
    }

    // Scope para filtrar por produto composto componente
    public function scopePorProdutoComposto($query, int $produtoCompostoCodigo)
    {
        return $query->where('COMPOPRODUCODIGO', $produtoCompostoCodigo);
    }

    // Scope para filtrar por serviço composto componente
    public function scopePorServicoComposto($query, int $servicoCompostoCodigo)
    {
        return $query->where('COMPOSERCODIGO', $servicoCompostoCodigo);
    }

    // Método estático para buscar composição de um produto
    public static function buscarComposicao(string $produtoCodigo): \Illuminate\Support\Collection
    {
        return self::where('COMPOPROCODIGO', $produtoCodigo)
            ->with(['produtoComposto', 'servicoComposto'])
            ->orderBy('COMPOORDEM')
            ->orderBy('COMPOSEQ')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se entidades relacionadas existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de ordem** - Verificar que ordem é válida e sequencial

### Performance

1. **Tabela média** - 51.308 registros, performance boa com índices adequados
2. **Índices existentes** - Em COMPOPROCODIGO, COMPOPRODUCODIGO e COMPOSERCODIGO são essenciais
3. **Índices compostos** - Para consultas combinadas (produto + ordem)
4. **Consultas frequentes** - Composições são consultadas durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de componentes** - Verificar que pelo menos um componente está definido

### Manutenção

1. **Revisão periódica** - Verificar composições não utilizadas
2. **Padronização** - Manter estrutura consistente
3. **Documentação** - Documentar significado de cada composição
4. **Backup regular** - Tabela importante para gestão de composições

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

