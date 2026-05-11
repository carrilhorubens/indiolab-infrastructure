# FABRICANTE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: FABRICANTE (Fabricantes)
- **Total de Registros**: 2
- **Total de Colunas**: 5
- **Chave Primária**: IDFABRICANTE (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (MARCA)
- **Banco de Dados**: Firebird

## 📝 Descrição

**FABRICANTE** é uma tabela mestre que armazena fabricantes de produtos. Com apenas **2 registros**, representa um catálogo pequeno de fabricantes utilizados principalmente para organizar marcas de produtos.

Esta tabela funciona como **catálogo de fabricantes** e permite:
- Identificar fabricantes disponíveis no sistema
- Armazenar descrições e informações de cada fabricante
- Vincular fabricantes a marcas de produtos
- Suportar informações visuais (fotos) dos fabricantes
- Controlar disponibilidade para internet
- Facilitar organização hierárquica de marcas por fabricante

Cada registro representa um fabricante específico, contendo:
- Identificador único do fabricante (IDFABRICANTE)
- Descrição do fabricante (DESCFABRICANTE)
- Foto do fabricante (FOTOFABRICANTE)
- Flag de disponibilidade para internet (FABINTERNET)
- Foto de alta resolução do fabricante (FOTOFABRICANTEH)

O sistema utiliza esta tabela para organizar marcas de produtos por fabricante, permitindo uma estrutura hierárquica onde marcas pertencem a fabricantes específicos.

**Observação Importante:** FABRICANTE é uma tabela mestre pequena (2 registros) que serve como catálogo de fabricantes. É referenciada por MARCA, indicando uso em organização hierárquica de marcas por fabricante.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IDFABRICANTE** 🔑 | INTEGER | ✓ | Identificador único do fabricante (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DESCFABRICANTE** | VARCHAR(37) | ✓ | Descrição do fabricante |
| **FOTOFABRICANTE** | VARCHAR(37) | | Caminho/URL da foto do fabricante |
| **FABINTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |
| **FOTOFABRICANTEH** | VARCHAR(37) | | Caminho/URL da foto de alta resolução do fabricante |

**Primary Key:** IDFABRICANTE

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### FABRICANTE Referencia (0 FKs):

Nenhuma foreign key direta.

---

### FABRICANTE é Referenciada Por (1 tabela):

#### 1. MARCA - Marcas de Produtos
**Relacionamento:**
```
MARCA.ID_FABRICANTE → FABRICANTE.IDFABRICANTE (N:1)
Constraint: FK_ID_FABRICANTE
```

**Descrição**: Cada marca pode estar vinculada a um fabricante específico.

**Informações da Tabela MARCA:**
- **Total:** 31 marcas
- **PK:** MARCODIGO
- **Colunas:** 7 campos

**Uso:** Organizar marcas por fabricante, permitindo estrutura hierárquica.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via MARCA → MODELO, TBPGRUPO, MARCASISEXT, VISUALTPLCLI

**Fluxo:** FABRICANTE → MARCA → MODELO/TBPGRUPO/MARCASISEXT/VISUALTPLCLI

**Descrição:** Através das marcas, é possível identificar modelos, grupos de preço, integrações e templates relacionados.

**Uso:** Análise de produtos por fabricante através das marcas.

---

### Via MARCA → PRODU → Outras Operações de Produtos

**Fluxo:** FABRICANTE → MARCA → PRODU → Operações

**Descrição:** Através das marcas e produtos, é possível identificar outras operações relacionadas.

**Uso:** Análise de produtos por fabricante.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Fabricante

**Objetivo:** Obter visão completa de um fabricante incluindo marcas e produtos relacionados.

**Fluxo:**
```
FABRICANTE (IDFABRICANTE)
  ↓
MARCA (ID_FABRICANTE)
  ↓
PRODU (MARCODIGO)
```

**Query SQL:**
```sql
SELECT
    f.IDFABRICANTE,
    f.DESCFABRICANTE AS FABRICANTE,
    f.FABINTERNET AS DISPONIVEL_INTERNET,
    COUNT(DISTINCT m.MARCODIGO) AS TOTAL_MARCAS,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS,
    SUM(CASE WHEN m.MARINTERNET = 'S' THEN 1 ELSE 0 END) AS MARCAS_INTERNET
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
LEFT JOIN PRODU p ON p.MARCODIGO = m.MARCODIGO
WHERE f.IDFABRICANTE = ?
GROUP BY f.IDFABRICANTE, f.DESCFABRICANTE, f.FABINTERNET;
```

---

### Exemplo 2: Análise de Fabricantes com Marcas

**Objetivo:** Identificar distribuição de marcas por fabricante.

**Query SQL:**
```sql
SELECT
    f.IDFABRICANTE,
    f.DESCFABRICANTE AS FABRICANTE,
    COUNT(m.MARCODIGO) AS TOTAL_MARCAS,
    STRING_AGG(m.MARNOME, ', ') AS MARCAS
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
GROUP BY f.IDFABRICANTE, f.DESCFABRICANTE
ORDER BY TOTAL_MARCAS DESC;
```

---

### Exemplo 3: Análise de Fabricantes com Produtos

**Objetivo:** Identificar distribuição de produtos por fabricante através das marcas.

**Query SQL:**
```sql
SELECT
    f.IDFABRICANTE,
    f.DESCFABRICANTE AS FABRICANTE,
    COUNT(DISTINCT m.MARCODIGO) AS TOTAL_MARCAS,
    COUNT(DISTINCT p.PROCODIGO) AS TOTAL_PRODUTOS
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
LEFT JOIN PRODU p ON p.MARCODIGO = m.MARCODIGO
GROUP BY f.IDFABRICANTE, f.DESCFABRICANTE
ORDER BY TOTAL_PRODUTOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Fabricante

**Objetivo:** Obter informações de um fabricante específico.

```sql
SELECT
    IDFABRICANTE,
    DESCFABRICANTE AS FABRICANTE,
    FOTOFABRICANTE AS FOTO,
    FABINTERNET AS DISPONIVEL_INTERNET,
    FOTOFABRICANTEH AS FOTO_ALTA_RESOLUCAO
FROM FABRICANTE
WHERE IDFABRICANTE = ?;
```

---

### 2. Listar Todos os Fabricantes

**Objetivo:** Obter catálogo completo de fabricantes.

```sql
SELECT
    IDFABRICANTE,
    DESCFABRICANTE AS FABRICANTE,
    FABINTERNET AS DISPONIVEL_INTERNET
FROM FABRICANTE
ORDER BY DESCFABRICANTE;
```

---

### 3. Análise de Fabricantes com Marcas

**Objetivo:** Identificar fabricantes e suas marcas relacionadas.

**Query SQL:**
```sql
SELECT
    f.IDFABRICANTE,
    f.DESCFABRICANTE AS FABRICANTE,
    m.MARCODIGO,
    m.MARNOME AS MARCA,
    m.MARINTERNET AS MARCA_INTERNET
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
ORDER BY f.DESCFABRICANTE, m.MARNOME;
```

---

### 4. Análise de Fabricantes Disponíveis para Internet

**Objetivo:** Identificar fabricantes disponíveis para internet.

**Query SQL:**
```sql
SELECT
    IDFABRICANTE,
    DESCFABRICANTE AS FABRICANTE,
    FOTOFABRICANTE AS FOTO,
    COUNT(m.MARCODIGO) AS TOTAL_MARCAS
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
WHERE f.FABINTERNET = 'S'
GROUP BY f.IDFABRICANTE, f.DESCFABRICANTE, f.FOTOFABRICANTE
ORDER BY f.DESCFABRICANTE;
```

---

### 5. Análise de Fabricantes Sem Marcas

**Objetivo:** Identificar fabricantes que não possuem marcas vinculadas.

**Query SQL:**
```sql
SELECT
    f.IDFABRICANTE,
    f.DESCFABRICANTE AS FABRICANTE
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
WHERE m.MARCODIGO IS NULL
ORDER BY f.DESCFABRICANTE;
```

---

### 6. Relatório Completo de Fabricantes

**Objetivo:** Analisar distribuição completa de fabricantes no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_FABRICANTES,
    COUNT(CASE WHEN FABINTERNET = 'S' THEN 1 END) AS DISPONIVEIS_INTERNET,
    COUNT(CASE WHEN FOTOFABRICANTE IS NOT NULL AND FOTOFABRICANTE != '' THEN 1 END) AS COM_FOTO,
    (SELECT COUNT(*) FROM MARCA WHERE ID_FABRICANTE IS NOT NULL) AS TOTAL_MARCAS_VINCULADAS
FROM FABRICANTE;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com FABRICANTE | Tipo |
|--------|-----------|------------------------|------|
| **FABRICANTE** | 2 | 1:1 | **TABELA PRINCIPAL** |
| MARCA | 31 | 1:15.5 | Marcas (média de 15.5 marcas por fabricante) |

**Interpretação:**
- **2 fabricantes** cadastrados no sistema
- **Média de 15.5 marcas por fabricante** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_FABRICANTE_DESCRICAO ON FABRICANTE(DESCFABRICANTE);

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_FABRICANTE_INTERNET ON FABRICANTE(FABINTERNET)
    WHERE FABINTERNET = 'S';
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

final class FirebirdFabricante extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'FABRICANTE';
    
    protected $primaryKey = 'IDFABRICANTE';
    public $incrementing = true;

    protected $casts = [
        'IDFABRICANTE' => 'integer',
        'DESCFABRICANTE' => 'string',
        'FOTOFABRICANTE' => 'string',
        'FABINTERNET' => 'string',
        'FOTOFABRICANTEH' => 'string',
    ];

    // Relacionamento com MARCA
    public function marcas(): HasMany
    {
        return $this->hasMany(FirebirdMarca::class, 'ID_FABRICANTE', 'IDFABRICANTE');
    }

    public function scopeDisponivelInternet($query)
    {
        return $query->where('FABINTERNET', 'S');
    }

    public function scopeComFoto($query)
    {
        return $query->whereNotNull('FOTOFABRICANTE')
                    ->where('FOTOFABRICANTE', '!=', '');
    }

    public function scopeComMarcas($query)
    {
        return $query->whereHas('marcas');
    }

    public function scopeSemMarcas($query)
    {
        return $query->whereDoesntHave('marcas');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

