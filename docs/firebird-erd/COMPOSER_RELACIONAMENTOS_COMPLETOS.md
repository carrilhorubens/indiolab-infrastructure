# COMPOSER - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: COMPOSER (Serviços Compostos)
- **Total de Registros**: 37.938
- **Total de Colunas**: 2
- **Chave Primária**: COMPSERCOD (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**COMPOSER** é uma tabela mestre que armazena informações sobre serviços compostos do sistema. Com **37.938 registros**, representa serviços compostos cadastrados, permitindo gerenciar serviços que são formados por combinações de outros serviços ou produtos.

Esta tabela funciona como **catálogo de serviços compostos** e permite:
- Cadastrar serviços compostos com descrições específicas
- Identificar serviços que são combinações de outros serviços/produtos
- Suportar estrutura hierárquica de serviços compostos
- Facilitar gestão de serviços complexos
- Suportar múltiplos itens por serviço composto

Cada registro representa um serviço composto específico, contendo:
- Código único do serviço composto (COMPSERCOD)
- Descrição do serviço composto (COMPSERDESCRICAO)

O sistema utiliza esta tabela como referência para serviços compostos, que podem ser detalhados em outras tabelas relacionadas (como COMPOSICAO) com seus componentes específicos.

**Observação Importante:** COMPOSER é uma tabela mestre complementar a SERVI. Enquanto SERVI tem apenas 13 serviços, COMPOSER tem 37.938 serviços compostos, indicando que a maioria dos serviços são serviços compostos. Esta tabela trabalha em conjunto com COMPOSICAO para definir a estrutura completa dos serviços compostos quando necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPSERCOD** 🔑 | INTEGER | ✓ | Código único do serviço composto |

### Informações do Serviço Composto
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **COMPSERDESCRICAO** | VARCHAR(37) | | Descrição do serviço composto |

**Primary Key:** COMPSERCOD

**Observações sobre Campos:**
- **COMPSERCOD**: Identificador único de cada serviço composto.
- **COMPSERDESCRICAO**: Descrição ou nome do serviço composto.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### COMPOSER Referencia

**Nenhuma foreign key formal** está definida na tabela COMPOSER.

---

### COMPOSER é Referenciada Por

**Relacionamento Lógico com COMPOSICAO:**
```
COMPOSICAO.COMPOSERCODIGO → COMPOSER.COMPSERCOD (N:1)
```

**Descrição**: COMPOSICAO pode referenciar COMPOSER para obter informações do serviço composto e adicionar itens componentes.

**Informações da Tabela COMPOSICAO:**
- **Total:** 51.308 registros
- **PK:** (COMPOSEQ, COMPOPROCODIGO)
- **Colunas:** 12 campos

**Uso:** COMPOSICAO estende COMPOSER com itens componentes específicos (produtos e quantidades).

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via COMPOSICAO → PRODU (Produtos Componentes)

**Fluxo:** COMPOSER → COMPOSICAO → PRODU

**Descrição:** Através de COMPOSICAO, é possível identificar produtos que são componentes dos serviços compostos.

**Uso:** Obter lista de componentes de um serviço composto, análises de dependências.

---

### Via COMPOSICAO → COMPOPRODU (Produtos Compostos)

**Fluxo:** COMPOSER → COMPOSICAO → COMPOPRODU

**Descrição:** Através de COMPOSICAO, é possível identificar produtos compostos relacionados.

**Uso:** Análise de serviços compostos com produtos compostos.

---

### Via COMPOSICAO → SERVI (Serviços)

**Fluxo:** COMPOSER → COMPOSICAO → SERVI

**Descrição:** Através de COMPOSICAO, é possível identificar serviços relacionados.

**Uso:** Análise de serviços compostos com serviços.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Serviço Composto

**Objetivo:** Obter visão completa de um serviço composto incluindo todos os seus itens componentes através de COMPOSICAO.

**Fluxo:**
```
COMPOSER (COMPSERCOD, COMPSERDESCRICAO)
  ↓
COMPOSICAO (COMPOSERCODIGO, COMPOPROCODIGO, COMPOPRODUCODIGO)
  ↓
PRODU (PROCODIGO) ou COMPOPRODU (COMPPRODUCOD) ou SERVI (SERCODIGO)
```

**Query SQL:**
```sql
SELECT
    cs.COMPSERCOD,
    cs.COMPSERDESCRICAO AS SERVICO_COMPOSTO,
    co.COMPOPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    co.COMPOPRODUCODIGO AS PRODUTO_COMPOSTO_COMPONENTE,
    cp.COMPPRODUDESCRICAO AS DESCRICAO_PRODUTO_COMPOSTO,
    co.COMPOORDEM AS ORDEM_EXECUCAO
FROM COMPOSER cs
LEFT JOIN COMPOSICAO co ON co.COMPOSERCODIGO = cs.COMPSERCOD
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
LEFT JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = co.COMPOPRODUCODIGO
WHERE cs.COMPSERCOD = ?
ORDER BY co.COMPOORDEM;
```

---

### Exemplo 2: Análise de Serviços Compostos Mais Complexos

**Objetivo:** Identificar serviços compostos com mais componentes.

**Query SQL:**
```sql
SELECT
    cs.COMPSERCOD,
    cs.COMPSERDESCRICAO AS SERVICO_COMPOSTO,
    COUNT(co.COMPOPROCODIGO) + COUNT(co.COMPOPRODUCODIGO) AS TOTAL_COMPONENTES,
    COUNT(DISTINCT co.COMPOPROCODIGO) AS TOTAL_PRODUTOS,
    COUNT(DISTINCT co.COMPOPRODUCODIGO) AS TOTAL_PRODUTOS_COMPOSTOS
FROM COMPOSER cs
LEFT JOIN COMPOSICAO co ON co.COMPOSERCODIGO = cs.COMPSERCOD
GROUP BY cs.COMPSERCOD, cs.COMPSERDESCRICAO
ORDER BY TOTAL_COMPONENTES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Serviço Composto

**Objetivo:** Obter informações de um serviço composto específico.

```sql
SELECT
    COMPSERCOD,
    COMPSERDESCRICAO AS SERVICO_COMPOSTO
FROM COMPOSER
WHERE COMPSERCOD = ?;
```

---

### 2. Listar Todos os Serviços Compostos

**Objetivo:** Obter todos os serviços compostos cadastrados.

```sql
SELECT
    COMPSERCOD,
    COMPSERDESCRICAO AS SERVICO_COMPOSTO
FROM COMPOSER
ORDER BY COMPSERDESCRICAO;
```

---

### 3. Buscar Serviços Compostos com Componentes

**Objetivo:** Obter serviços compostos com seus componentes através de COMPOSICAO.

```sql
SELECT
    cs.COMPSERCOD,
    cs.COMPSERDESCRICAO AS SERVICO_COMPOSTO,
    co.COMPOPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    co.COMPOPRODUCODIGO AS PRODUTO_COMPOSTO_COMPONENTE,
    cp.COMPPRODUDESCRICAO AS DESCRICAO_PRODUTO_COMPOSTO,
    co.COMPOORDEM AS ORDEM_EXECUCAO
FROM COMPOSER cs
LEFT JOIN COMPOSICAO co ON co.COMPOSERCODIGO = cs.COMPSERCOD
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
LEFT JOIN COMPOPRODU cp ON cp.COMPPRODUCOD = co.COMPOPRODUCODIGO
ORDER BY cs.COMPSERDESCRICAO, co.COMPOORDEM;
```

---

### 4. Análise de Serviços Compostos Sem Componentes

**Objetivo:** Identificar serviços compostos que não têm componentes cadastrados.

```sql
SELECT
    cs.COMPSERCOD,
    cs.COMPSERDESCRICAO AS SERVICO_COMPOSTO
FROM COMPOSER cs
LEFT JOIN COMPOSICAO co ON co.COMPOSERCODIGO = cs.COMPSERCOD
WHERE co.COMPOSERCODIGO IS NULL
ORDER BY cs.COMPSERDESCRICAO;
```

---

### 5. Análise de Componentes Mais Utilizados

**Objetivo:** Identificar produtos que são componentes mais utilizados em serviços compostos.

**Query SQL:**
```sql
SELECT
    co.COMPOPROCODIGO AS PRODUTO_COMPONENTE,
    pr.PRODESCRICAO AS DESCRICAO_PRODUTO,
    COUNT(DISTINCT co.COMPOSERCODIGO) AS TOTAL_SERVICOS_COMPOSTOS_QUE_USAM
FROM COMPOSICAO co
LEFT JOIN PRODU pr ON pr.PROCODIGO = co.COMPOPROCODIGO
WHERE co.COMPOPROCODIGO IS NOT NULL
GROUP BY co.COMPOPROCODIGO, pr.PRODESCRICAO
ORDER BY TOTAL_SERVICOS_COMPOSTOS_QUE_USAM DESC;
```

---

### 6. Relatório de Serviços Compostos

**Objetivo:** Analisar distribuição completa de serviços compostos.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_SERVICOS_COMPOSTOS,
    COUNT(DISTINCT co.COMPOSERCODIGO) AS SERVICOS_COM_COMPONENTES,
    COUNT(*) - COUNT(DISTINCT co.COMPOSERCODIGO) AS SERVICOS_SEM_COMPONENTES,
    COUNT(co.COMPOPROCODIGO) + COUNT(co.COMPOPRODUCODIGO) AS TOTAL_ITENS_COMPONENTES,
    COUNT(DISTINCT co.COMPOPROCODIGO) AS TOTAL_PRODUTOS_DIFERENTES,
    COUNT(DISTINCT co.COMPOPRODUCODIGO) AS TOTAL_PRODUTOS_COMPOSTOS_DIFERENTES
FROM COMPOSER cs
LEFT JOIN COMPOSICAO co ON co.COMPOSERCODIGO = cs.COMPSERCOD;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com COMPOSER | Tipo |
|--------|-----------|---------------------|------|
| **COMPOSER** | 37.938 | 1:1 | **TABELA PRINCIPAL** |
| COMPOSICAO | 51.308 | 1.35:1 | Composições (média de 1.35 itens por serviço composto) |
| SERVI | 13 | 0.0003:1 | Serviços (2.917 vezes mais serviços compostos que serviços básicos) |

**Interpretação:**
- **37.938 serviços compostos** cadastrados no sistema
- **2.917 vezes mais serviços compostos** que serviços básicos (37.938 vs 13)
- **Média de 1.35 itens por serviço composto** - serviços compostos têm componentes
- **Uso extensivo** - indica estrutura complexa de serviços

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela COMPOSER.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por descrição** - Para buscas por descrição

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_COMPOSER_DESCRICAO ON COMPOSER(COMPSERDESCRICAO)
    WHERE COMPSERDESCRICAO IS NOT NULL AND COMPSERDESCRICAO != '';
```

### Observações sobre Volume

- **Tabela média** (37.938 registros) - Performance boa
- **Consultas frequentes** - Serviços compostos são consultados durante criação de pedidos e produção
- **Índices úteis** - Em COMPSERDESCRICAO para buscas por nome

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM COMPOSER
WHERE COMPSERCOD IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT COMPSERCOD, COUNT(*) AS QTD
FROM COMPOSER
GROUP BY COMPSERCOD
HAVING COUNT(*) > 1;

-- Verificar serviços compostos sem descrição
SELECT *
FROM COMPOSER
WHERE COMPSERDESCRICAO IS NULL
   OR COMPSERDESCRICAO = '';
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdComposer extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'COMPOSER';
    
    protected $primaryKey = 'COMPSERCOD';
    public $incrementing = true;

    protected $casts = [
        'COMPSERCOD' => 'integer',
        'COMPSERDESCRICAO' => 'string',
    ];

    // Relacionamento lógico com COMPOSICAO
    public function composicoes(): HasMany
    {
        return $this->hasMany(FirebirdComposicao::class, 'COMPOSERCODIGO', 'COMPSERCOD');
    }

    // Método para verificar se tem componentes
    public function temComponentes(): bool
    {
        return $this->composicoes()->exists();
    }

    // Método para obter total de componentes
    public function getTotalComponentes(): int
    {
        return $this->composicoes()->count();
    }

    // Scope para filtrar serviços com componentes
    public function scopeComComponentes($query)
    {
        return $query->whereHas('composicoes');
    }

    // Scope para filtrar serviços sem componentes
    public function scopeSemComponentes($query)
    {
        return $query->whereDoesntHave('composicoes');
    }

    // Método estático para buscar serviço composto por código
    public static function buscarPorCodigo(int $codigo): ?self
    {
        return self::where('COMPSERCOD', $codigo)->first();
    }

    // Método estático para buscar serviços compostos por descrição
    public static function buscarPorDescricao(string $descricao): \Illuminate\Support\Collection
    {
        return self::where('COMPSERDESCRICAO', 'LIKE', '%' . $descricao . '%')
            ->orderBy('COMPSERDESCRICAO')
            ->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - COMPSERCOD identifica unicamente cada serviço composto
2. **Validação antes de inserir** - Verificar se código não existe
3. **Evitar duplicatas** - PK garante unicidade
4. **Validação de descrição** - Verificar que descrição não está vazia

### Performance

1. **Tabela média** - 37.938 registros, performance boa
2. **Índices úteis** - Em COMPSERDESCRICAO para buscas por nome
3. **Consultas frequentes** - Serviços compostos são consultados durante criação de pedidos

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se código não existe
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que descrições sejam únicas quando apropriado

### Manutenção

1. **Revisão periódica** - Verificar serviços compostos não utilizados
2. **Padronização** - Manter estrutura de descrições consistente
3. **Documentação** - Documentar significado de cada serviço composto
4. **Backup regular** - Tabela importante para gestão de serviços compostos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

