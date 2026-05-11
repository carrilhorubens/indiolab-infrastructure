# GRUPO2 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPO2 (Grupo 2 de Produtos)
- **Total de Registros**: 152
- **Total de Colunas**: 4
- **Chave Primária**: GR2CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 3 (GRUPO2SISEXT, TBPGRUPO, VISUALTPLCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPO2** é uma tabela mestre que armazena o segundo nível de categorização de produtos. Com **152 registros**, representa subcategorias utilizadas para organização hierárquica de produtos, complementando GRUPO1 no segundo nível da estrutura hierárquica (GRUPO1 → GRUPO2 → GRUPO3 → GRUPO4).

Esta tabela funciona como **subcategoria de produtos** e permite:
- Categorizar produtos em grupos secundários
- Controlar disponibilidade para internet
- Definir ordem de exibição
- Facilitar organização hierárquica de produtos
- Suportar classificação em múltiplos níveis

Cada registro representa um grupo secundário de produtos, contendo:
- Código do grupo (GR2CODIGO)
- Descrição do grupo (GR2DESCRICAO)
- Ordem de exibição (GR2ORDEM)
- Flag de disponibilidade para internet (GR2INTERNET)

O sistema utiliza esta tabela como segundo nível de categorização hierárquica de produtos, sendo complementada por GRUPO3 e GRUPO4 para formar uma estrutura completa de classificação.

**Observação Importante:** GRUPO2 é parte de uma estrutura hierárquica de categorização de produtos. Com 152 registros, indica uso extensivo desta funcionalidade. É referenciada por TBPGRUPO (tabelas de preço), VISUALTPLCLI (templates visuais) e GRUPO2SISEXT (integrações externas).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR2CODIGO** 🔑 | SMALLINT | ✓ | Código do grupo 2 (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR2DESCRICAO** | VARCHAR(37) | ✓ | Descrição do grupo 2 |
| **GR2ORDEM** | SMALLINT | ✓ | Ordem de exibição |
| **GR2INTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |

**Primary Key:** GR2CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPO2 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPO2 é Referenciada Por (3 tabelas):

#### 1. GRUPO2SISEXT - Integração com Sistemas Externos
**Relacionamento:**
```
GRUPO2SISEXT.GR2CODIGO → GRUPO2.GR2CODIGO (N:1)
Constraint: GRUPO2_GRUPO2SISEXT
```

**Descrição**: Cada grupo 2 pode ter múltiplos mapeamentos com sistemas externos.

**Uso:** Mapear grupos 2 internos com códigos de sistemas externos.

---

#### 2. TBPGRUPO - Grupos de Tabela de Preço
**Relacionamento:**
```
TBPGRUPO.GR2CODIGO → GRUPO2.GR2CODIGO (N:1)
Constraint: GRUPO2_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preço pode estar vinculado a um grupo 2 específico.

**Uso:** Vincular grupos de tabela de preço a grupos 2 de produtos.

---

#### 3. VISUALTPLCLI - Templates Visuais de Cliente
**Relacionamento:**
```
VISUALTPLCLI.GR2CODIGO → GRUPO2.GR2CODIGO (N:1)
Constraint: GRUPO2_VISUALTPLCLI
```

**Descrição**: Cada template visual pode estar vinculado a um grupo 2 específico.

**Uso:** Vincular templates visuais a grupos 2 de produtos.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via TBPGRUPO → TABPRECO → Outras Operações de Preço

**Fluxo:** GRUPO2 → TBPGRUPO → TABPRECO → Operações

**Descrição:** Através dos grupos de tabela de preço, é possível identificar tabelas de preço relacionadas.

**Uso:** Análise de grupos 2 através de tabelas de preço.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo 2

**Objetivo:** Obter visão completa de um grupo 2 incluindo tabelas de preço e templates visuais.

**Query SQL:**
```sql
SELECT
    g2.GR2CODIGO,
    g2.GR2DESCRICAO AS GRUPO2,
    g2.GR2ORDEM AS ORDEM,
    g2.GR2INTERNET AS DISPONIVEL_INTERNET,
    COUNT(DISTINCT tbp.TBPCODIGO) AS TOTAL_TABELAS_PRECO,
    COUNT(DISTINCT vtc.VTCCODIGO) AS TOTAL_TEMPLATES_VISUAIS
FROM GRUPO2 g2
LEFT JOIN TBPGRUPO tbp ON tbp.GR2CODIGO = g2.GR2CODIGO
LEFT JOIN VISUALTPLCLI vtc ON vtc.GR2CODIGO = g2.GR2CODIGO
WHERE g2.GR2CODIGO = ?
GROUP BY g2.GR2CODIGO, g2.GR2DESCRICAO, g2.GR2ORDEM, g2.GR2INTERNET;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo 2

**Objetivo:** Obter informações de um grupo 2 específico.

```sql
SELECT
    GR2CODIGO,
    GR2DESCRICAO AS GRUPO2,
    GR2ORDEM AS ORDEM,
    GR2INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO2
WHERE GR2CODIGO = ?;
```

---

### 2. Listar Todos os Grupos 2

**Objetivo:** Obter catálogo completo de grupos 2.

```sql
SELECT
    GR2CODIGO,
    GR2DESCRICAO AS GRUPO2,
    GR2ORDEM AS ORDEM,
    GR2INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO2
ORDER BY GR2ORDEM;
```

---

### 3. Relatório Completo de Grupos 2

**Objetivo:** Analisar distribuição completa de grupos 2 no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    COUNT(CASE WHEN GR2INTERNET = 'S' THEN 1 END) AS DISPONIVEIS_INTERNET,
    (SELECT COUNT(*) FROM TBPGRUPO WHERE GR2CODIGO IS NOT NULL) AS TOTAL_TABELAS_PRECO,
    (SELECT COUNT(*) FROM VISUALTPLCLI WHERE GR2CODIGO IS NOT NULL) AS TOTAL_TEMPLATES_VISUAIS
FROM GRUPO2;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPO2 | Tipo |
|--------|-----------|---------------------|------|
| **GRUPO2** | 152 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **152 grupos 2** cadastrados no sistema
- Estrutura hierárquica complementada por GRUPO1, GRUPO3 e GRUPO4

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRUPO2_ORDEM ON GRUPO2(GR2ORDEM)
    WHERE GR2ORDEM IS NOT NULL;

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_GRUPO2_INTERNET ON GRUPO2(GR2INTERNET)
    WHERE GR2INTERNET = 'S';
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

final class FirebirdGrupo2 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPO2';
    
    protected $primaryKey = 'GR2CODIGO';
    public $incrementing = true;

    protected $casts = [
        'GR2CODIGO' => 'integer',
        'GR2DESCRICAO' => 'string',
        'GR2ORDEM' => 'integer',
        'GR2INTERNET' => 'string',
    ];

    public function scopeDisponivelInternet($query)
    {
        return $query->where('GR2INTERNET', 'S');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GR2ORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

