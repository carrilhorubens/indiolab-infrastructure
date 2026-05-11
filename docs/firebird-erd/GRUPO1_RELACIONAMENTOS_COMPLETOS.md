# GRUPO1 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPO1 (Grupo 1 de Produtos)
- **Total de Registros**: 26
- **Total de Colunas**: 6
- **Chave Primária**: GR1CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 3 (GRUPO1SISEXT, TBPGRUPO, VISUALTPLCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPO1** é uma tabela mestre que armazena o primeiro nível de categorização de produtos. Com **26 registros**, representa categorias principais utilizadas para organização hierárquica de produtos, permitindo classificação em múltiplos níveis (GRUPO1, GRUPO2, GRUPO3, GRUPO4).

Esta tabela funciona como **categoria principal de produtos** e permite:
- Categorizar produtos em grupos principais
- Controlar disponibilidade para internet
- Definir ordem de exibição
- Configurar percentual de comissão por grupo
- Vincular grupos a descrições específicas
- Facilitar organização hierárquica de produtos

Cada registro representa um grupo principal de produtos, contendo:
- Código do grupo (GR1CODIGO)
- Descrição do grupo (GR1DESCRICAO)
- Percentual de comissão (GR1PCCOMIS)
- Ordem de exibição (GR1ORDEM)
- Código de descrição (DESCODIGO)
- Flag de disponibilidade para internet (GR1INTERNET)

O sistema utiliza esta tabela como primeiro nível de categorização hierárquica de produtos, sendo complementada por GRUPO2, GRUPO3 e GRUPO4 para formar uma estrutura completa de classificação.

**Observação Importante:** GRUPO1 é parte de uma estrutura hierárquica de categorização de produtos (GRUPO1 → GRUPO2 → GRUPO3 → GRUPO4). Com 26 registros, indica uso moderado desta funcionalidade. É referenciada por TBPGRUPO (tabelas de preço), VISUALTPLCLI (templates visuais) e GRUPO1SISEXT (integrações externas).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR1CODIGO** 🔑 | SMALLINT | ✓ | Código do grupo 1 (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR1DESCRICAO** | VARCHAR(37) | ✓ | Descrição do grupo 1 |
| **GR1PCCOMIS** | NUMERIC(27,2) | | Percentual de comissão |
| **GR1ORDEM** | SMALLINT | ✓ | Ordem de exibição |
| **DESCODIGO** | SMALLINT | | Código de descrição |
| **GR1INTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |

**Primary Key:** GR1CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPO1 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPO1 é Referenciada Por (3 tabelas):

#### 1. GRUPO1SISEXT - Integração com Sistemas Externos
**Relacionamento:**
```
GRUPO1SISEXT.GR1CODIGO → GRUPO1.GR1CODIGO (N:1)
Constraint: GRUPO1_GRUPO1SISEXT
```

**Descrição**: Cada grupo 1 pode ter múltiplos mapeamentos com sistemas externos.

**Uso:** Mapear grupos 1 internos com códigos de sistemas externos.

---

#### 2. TBPGRUPO - Grupos de Tabela de Preço
**Relacionamento:**
```
TBPGRUPO.GR1CODIGO → GRUPO1.GR1CODIGO (N:1)
Constraint: GRUPO1_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preço pode estar vinculado a um grupo 1 específico.

**Uso:** Vincular grupos de tabela de preço a grupos 1 de produtos.

---

#### 3. VISUALTPLCLI - Templates Visuais de Cliente
**Relacionamento:**
```
VISUALTPLCLI.GR1CODIGO → GRUPO1.GR1CODIGO (N:1)
Constraint: GRUPO1_VISUALTPLCLI
```

**Descrição**: Cada template visual pode estar vinculado a um grupo 1 específico.

**Uso:** Vincular templates visuais a grupos 1 de produtos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via TBPGRUPO → TABPRECO → Outras Operações de Preço

**Fluxo:** GRUPO1 → TBPGRUPO → TABPRECO → Operações

**Descrição:** Através dos grupos de tabela de preço, é possível identificar tabelas de preço relacionadas.

**Uso:** Análise de grupos 1 através de tabelas de preço.

---

### Via VISUALTPLCLI → Outras Operações Visuais

**Fluxo:** GRUPO1 → VISUALTPLCLI → Operações

**Descrição:** Através dos templates visuais, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos 1 através de templates visuais.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo 1

**Objetivo:** Obter visão completa de um grupo 1 incluindo tabelas de preço e templates visuais.

**Fluxo:**
```
GRUPO1 (GR1CODIGO)
  ↓
TBPGRUPO (GR1CODIGO)
  ↓
TABPRECO (TBPCODIGO)
```

**Query SQL:**
```sql
SELECT
    g1.GR1CODIGO,
    g1.GR1DESCRICAO AS GRUPO1,
    g1.GR1PCCOMIS AS PERCENTUAL_COMISSAO,
    g1.GR1ORDEM AS ORDEM,
    g1.GR1INTERNET AS DISPONIVEL_INTERNET,
    COUNT(DISTINCT tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO,
    COUNT(DISTINCT vtc.VTCCODIGO) AS TOTAL_TEMPLATES_VISUAIS
FROM GRUPO1 g1
LEFT JOIN TBPGRUPO tbp ON tbp.GR1CODIGO = g1.GR1CODIGO
LEFT JOIN VISUALTPLCLI vtc ON vtc.GR1CODIGO = g1.GR1CODIGO
WHERE g1.GR1CODIGO = ?
GROUP BY g1.GR1CODIGO, g1.GR1DESCRICAO, g1.GR1PCCOMIS, g1.GR1ORDEM, g1.GR1INTERNET;
```

---

### Exemplo 2: Análise de Grupos Disponíveis para Internet

**Objetivo:** Identificar grupos 1 disponíveis para internet.

**Query SQL:**
```sql
SELECT
    GR1CODIGO,
    GR1DESCRICAO AS GRUPO1,
    GR1ORDEM AS ORDEM
FROM GRUPO1
WHERE GR1INTERNET = 'S'
ORDER BY GR1ORDEM;
```

---

### Exemplo 3: Análise de Grupos com Tabelas de Preço

**Objetivo:** Identificar grupos 1 que possuem tabelas de preço vinculadas.

**Query SQL:**
```sql
SELECT
    g1.GR1CODIGO,
    g1.GR1DESCRICAO AS GRUPO1,
    COUNT(DISTINCT tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO
FROM GRUPO1 g1
LEFT JOIN TBPGRUPO tbp ON tbp.GR1CODIGO = g1.GR1CODIGO
GROUP BY g1.GR1CODIGO, g1.GR1DESCRICAO
HAVING COUNT(DISTINCT tbp.TBPCODIGO) > 0
ORDER BY TOTAL_TABELAS_PRECO DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo 1

**Objetivo:** Obter informações de um grupo 1 específico.

```sql
SELECT
    GR1CODIGO,
    GR1DESCRICAO AS GRUPO1,
    GR1PCCOMIS AS PERCENTUAL_COMISSAO,
    GR1ORDEM AS ORDEM,
    DESCODIGO,
    GR1INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO1
WHERE GR1CODIGO = ?;
```

---

### 2. Listar Todos os Grupos 1

**Objetivo:** Obter catálogo completo de grupos 1.

```sql
SELECT
    GR1CODIGO,
    GR1DESCRICAO AS GRUPO1,
    GR1ORDEM AS ORDEM,
    GR1INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO1
ORDER BY GR1ORDEM;
```

---

### 3. Análise de Grupos por Percentual de Comissão

**Objetivo:** Identificar distribuição de grupos por percentual de comissão.

**Query SQL:**
```sql
SELECT
    GR1PCCOMIS AS PERCENTUAL_COMISSAO,
    COUNT(*) AS TOTAL_GRUPOS,
    STRING_AGG(GR1DESCRICAO, ', ') AS GRUPOS
FROM GRUPO1
WHERE GR1PCCOMIS IS NOT NULL
GROUP BY GR1PCCOMIS
ORDER BY PERCENTUAL_COMISSAO DESC;
```

---

### 4. Relatório Completo de Grupos 1

**Objetivo:** Analisar distribuição completa de grupos 1 no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    COUNT(CASE WHEN GR1INTERNET = 'S' THEN 1 END) AS DISPONIVEIS_INTERNET,
    COUNT(CASE WHEN GR1PCCOMIS IS NOT NULL THEN 1 END) AS COM_COMISSAO,
    (SELECT COUNT(*) FROM TBPGRUPO WHERE GR1CODIGO IS NOT NULL) AS TOTAL_TABELAS_PRECO,
    (SELECT COUNT(*) FROM VISUALTPLCLI WHERE GR1CODIGO IS NOT NULL) AS TOTAL_TEMPLATES_VISUAIS
FROM GRUPO1;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPO1 | Tipo |
|--------|-----------|---------------------|------|
| **GRUPO1** | 26 | 1:1 | **TABELA PRINCIPAL** |
| TBPGRUPO | Informação não disponível | - | Grupos de tabela de preço |
| VISUALTPLCLI | Informação não disponível | - | Templates visuais |

**Interpretação:**
- **26 grupos 1** cadastrados no sistema
- Estrutura hierárquica complementada por GRUPO2, GRUPO3 e GRUPO4

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRUPO1_ORDEM ON GRUPO1(GR1ORDEM)
    WHERE GR1ORDEM IS NOT NULL;

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_GRUPO1_INTERNET ON GRUPO1(GR1INTERNET)
    WHERE GR1INTERNET = 'S';

-- Índice 3: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_GRUPO1_DESCRICAO ON GRUPO1(GR1DESCRICAO)
    WHERE GR1DESCRICAO IS NOT NULL;
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

final class FirebirdGrupo1 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPO1';
    
    protected $primaryKey = 'GR1CODIGO';
    public $incrementing = true;

    protected $casts = [
        'GR1CODIGO' => 'integer',
        'GR1DESCRICAO' => 'string',
        'GR1PCCOMIS' => 'decimal:2',
        'GR1ORDEM' => 'integer',
        'DESCODIGO' => 'integer',
        'GR1INTERNET' => 'string',
    ];

    // Relacionamento com TBPGRUPO
    public function gruposTabelaPreco(): HasMany
    {
        return $this->hasMany(FirebirdTbpgrupo::class, 'GR1CODIGO', 'GR1CODIGO');
    }

    // Relacionamento com VISUALTPLCLI
    public function templatesVisuais(): HasMany
    {
        return $this->hasMany(FirebirdVisualtplcli::class, 'GR1CODIGO', 'GR1CODIGO');
    }

    public function scopeDisponivelInternet($query)
    {
        return $query->where('GR1INTERNET', 'S');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GR1ORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

