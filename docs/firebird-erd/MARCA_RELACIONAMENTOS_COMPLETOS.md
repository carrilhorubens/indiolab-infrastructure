# MARCA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MARCA (Marcas de Produtos)
- **Total de Registros**: 31
- **Total de Colunas**: 7
- **Chave Primária**: MARCODIGO (simples)
- **Chaves Estrangeiras**: 1 (FABRICANTE)
- **Índices**: 0
- **Tabelas Dependentes**: 4 (MARCASISEXT, MODELO, TBPGRUPO, VISUALTPLCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**MARCA** é uma tabela que armazena informações sobre marcas de produtos. Com **31 registros**, representa marcas cadastradas no sistema, incluindo informações sobre nome, observações, fotos e fabricante associado.

Esta tabela funciona como **mestre de marcas** e permite:
- Registrar todas as marcas de produtos
- Armazenar informações sobre nome, observações e fotos
- Vincular marcas a fabricantes específicos
- Suportar integração com sistemas externos
- Associar marcas a modelos de produtos
- Vincular marcas a grupos de tabela de preços
- Associar marcas a templates visuais de clientes
- Facilitar gestão de marcas
- Manter histórico detalhado de marcas

Cada registro representa uma marca específica, contendo:
- Código da marca (MARCODIGO)
- Nome da marca (MARNOME)
- Observações (MAROBSER)
- Foto da marca (MARFOTO)
- ID do fabricante (ID_FABRICANTE)
- Indicador de internet (MARINTERNET)
- Foto horizontal (MARFOTOH)

O sistema utiliza esta tabela para manter histórico completo de marcas, sendo referenciada por MARCASISEXT para integração com sistemas externos, por MODELO para vincular modelos a marcas, por TBPGRUPO para associar marcas a grupos de tabela de preços e por VISUALTPLCLI para associar marcas a templates visuais de clientes.

**Observação Importante:** MARCA é uma tabela mestre de marcas de produtos. Com 31 registros, indica uso moderado desta funcionalidade. Possui 1 foreign key para FABRICANTE e é referenciada por 4 tabelas, indicando sua importância central no sistema de gestão de produtos.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MARCODIGO** 🔑 | INTEGER | ✓ | Código da marca (PK) |

### Informações da Marca
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MARNOME** | VARCHAR(37) | ✓ | Nome da marca |
| **MAROBSER** | VARCHAR(37) | | Observações sobre a marca |
| **MARFOTO** | VARCHAR(37) | | Caminho da foto da marca |
| **MARINTERNET** | VARCHAR(14) | | Indicador de disponibilidade na internet |
| **MARFOTOH** | VARCHAR(37) | | Caminho da foto horizontal da marca |

### Relacionamento com FABRICANTE
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_FABRICANTE** 🔗 | INTEGER | | ID do fabricante (FK) |

**Primary Key:** MARCODIGO

**Foreign Keys:**
- `FK_ID_FABRICANTE`: ID_FABRICANTE → FABRICANTE.IDFABRICANTE

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MARCA Referencia (1 tabela):

#### 1. FABRICANTE - Fabricantes
**Relacionamento:**
```
MARCA.ID_FABRICANTE → FABRICANTE.IDFABRICANTE (N:1)
Constraint: FK_ID_FABRICANTE
```

**Descrição**: Cada marca pode estar vinculada a um fabricante específico.

**Informações da Tabela FABRICANTE:**
- **Total:** 2 fabricantes
- **PK:** IDFABRICANTE
- **Colunas:** 5 campos

**Uso:** Vincular marcas a fabricantes para organização e gestão.

---

### MARCA é Referenciada Por (4 tabelas):

#### 1. MARCASISEXT - Integração de Marcas com Sistemas Externos
**Relacionamento:**
```
MARCASISEXT.MARCODIGO → MARCA.MARCODIGO (N:1)
Constraint: MARCA_MARCASISEXT
```

**Descrição**: Cada integração de marca com sistema externo está vinculada a uma marca específica.

**Informações da Tabela MARCASISEXT:**
- **Total:** Varia conforme integrações
- **PK:** MARCODIGO, MSENOME (composta)
- **Colunas:** 3 campos

**Uso:** Mapear marcas internas para códigos de sistemas externos.

---

#### 2. MODELO - Modelos de Produtos
**Relacionamento:**
```
MODELO.MARCODIGO → MARCA.MARCODIGO (N:1)
Constraint: MARCA_MODELO
```

**Descrição**: Cada modelo está vinculado a uma marca específica.

**Informações da Tabela MODELO:**
- **Total:** Varia conforme modelos
- **PK:** MODCODIGO
- **Colunas:** Varia conforme estrutura

**Uso:** Vincular modelos a marcas para organização hierárquica.

---

#### 3. TBPGRUPO - Grupos de Tabela de Preços
**Relacionamento:**
```
TBPGRUPO.MARCODIGO → MARCA.MARCODIGO (N:1)
Constraint: MARCODIGO_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preços pode estar vinculado a uma marca específica.

**Informações da Tabela TBPGRUPO:**
- **Total:** 1.328 grupos
- **PK:** TBPCODIGO, MARCODIGO (composta)
- **Colunas:** 11 campos

**Uso:** Associar marcas a grupos de tabela de preços para precificação.

---

#### 4. VISUALTPLCLI - Templates Visuais de Clientes
**Relacionamento:**
```
VISUALTPLCLI.MARCODIGO → MARCA.MARCODIGO (N:1)
Constraint: MARCA_VISUALTPLCLI
```

**Descrição**: Cada template visual de cliente pode estar vinculado a uma marca específica.

**Informações da Tabela VISUALTPLCLI:**
- **Total:** 0 templates
- **PK:** VTPCODIGO
- **Colunas:** 10 campos

**Uso:** Associar marcas a templates visuais de clientes para personalização.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via FABRICANTE → Outras Operações

**Fluxo:** MARCA → FABRICANTE → Operações

**Descrição:** Através do fabricante vinculado, é possível identificar outras operações relacionadas.

**Uso:** Análise de marcas através de operações de fabricantes.

---

### Via MODELO → PRODU

**Fluxo:** MARCA → MODELO → PRODU → Operações

**Descrição:** Através dos modelos vinculados, é possível identificar produtos relacionados.

**Uso:** Análise de marcas através de produtos.

---

### Via MARCASISEXT → SISTEMAEXT

**Fluxo:** MARCA → MARCASISEXT → SISTEMAEXT → Operações

**Descrição:** Através das integrações com sistemas externos, é possível identificar sistemas relacionados.

**Uso:** Análise de marcas através de sistemas externos.

---

### Via TBPGRUPO → TABPRECO

**Fluxo:** MARCA → TBPGRUPO → TABPRECO → Operações

**Descrição:** Através dos grupos de tabela de preços, é possível identificar tabelas de preços relacionadas.

**Uso:** Análise de marcas através de tabelas de preços.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Marca

**Objetivo:** Obter informações de uma marca específica.

```sql
SELECT
    m.MARCODIGO,
    m.MARNOME,
    m.MAROBSER,
    m.MARFOTO,
    m.ID_FABRICANTE,
    m.MARINTERNET,
    m.MARFOTOH,
    f.FABNOME AS FABRICANTE_NOME
FROM MARCA m
LEFT JOIN FABRICANTE f ON f.IDFABRICANTE = m.ID_FABRICANTE
WHERE m.MARCODIGO = ?;
```

---

### 2. Listar Modelos de uma Marca

**Objetivo:** Obter todos os modelos vinculados a uma marca específica.

```sql
SELECT
    mo.MODCODIGO,
    mo.MODNOME,
    mo.MODDESCRICAO
FROM MARCA m
INNER JOIN MODELO mo ON mo.MARCODIGO = m.MARCODIGO
WHERE m.MARCODIGO = ?
ORDER BY mo.MODNOME;
```

---

### 3. Análise de Marcas por Fabricante

**Objetivo:** Identificar distribuição de marcas por fabricante.

**Query SQL:**
```sql
SELECT
    f.FABNOME AS FABRICANTE,
    COUNT(m.MARCODIGO) AS TOTAL_MARCAS,
    STRING_AGG(m.MARNOME, ', ') AS MARCAS
FROM FABRICANTE f
LEFT JOIN MARCA m ON m.ID_FABRICANTE = f.IDFABRICANTE
GROUP BY f.FABNOME
ORDER BY TOTAL_MARCAS DESC;
```

---

### 4. Buscar Integrações de uma Marca

**Objetivo:** Obter todas as integrações com sistemas externos de uma marca específica.

```sql
SELECT
    m.MARCODIGO,
    m.MARNOME,
    ms.MSENOME AS SISTEMA_EXTERNO,
    ms.MSECODIGO AS CODIGO_EXTERNO
FROM MARCA m
INNER JOIN MARCASISEXT ms ON ms.MARCODIGO = m.MARCODIGO
WHERE m.MARCODIGO = ?
ORDER BY ms.MSENOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MARCA | Tipo |
|--------|-----------|-------------------|------|
| **MARCA** | 31 | 1:1 | **TABELA PRINCIPAL** |
| FABRICANTE | 2 | 1:15.5 | Fabricantes (média de 15.5 marcas por fabricante) |
| MARCASISEXT | Varia | 1:N | Integrações com sistemas externos |
| MODELO | Varia | 1:N | Modelos de produtos |
| TBPGRUPO | 1.328 | 1:42.8 | Grupos de tabela de preços (média de 42.8 grupos por marca) |
| VISUALTPLCLI | 0 | 0:1 | Templates visuais (nenhum template registrado) |

**Interpretação:**
- **31 marcas** registradas no sistema
- **Média de 15.5 marcas por fabricante** - indica concentração de marcas em poucos fabricantes
- **Média de 42.8 grupos de tabela de preços por marca** - indica uso extensivo de marcas em precificação

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por fabricante (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MARCA_FABRICANTE ON MARCA(ID_FABRICANTE)
    WHERE ID_FABRICANTE IS NOT NULL;

-- Índice 2: Busca por nome (consultas frequentes)
CREATE INDEX IDX_MARCA_NOME ON MARCA(MARNOME)
    WHERE MARNOME IS NOT NULL;
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
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdMarca extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MARCA';
    
    protected $primaryKey = 'MARCODIGO';
    public $incrementing = true;

    protected $casts = [
        'MARCODIGO' => 'integer',
        'MARNOME' => 'string',
        'MAROBSER' => 'string',
        'MARFOTO' => 'string',
        'ID_FABRICANTE' => 'integer',
        'MARINTERNET' => 'string',
        'MARFOTOH' => 'string',
    ];

    // Relacionamento com FABRICANTE
    public function fabricante(): BelongsTo
    {
        return $this->belongsTo(FirebirdFabricante::class, 'ID_FABRICANTE', 'IDFABRICANTE');
    }

    // Relacionamento com MARCASISEXT
    public function integracoesSistemasExternos(): HasMany
    {
        return $this->hasMany(FirebirdMarcasisext::class, 'MARCODIGO', 'MARCODIGO');
    }

    // Relacionamento com MODELO
    public function modelos(): HasMany
    {
        return $this->hasMany(FirebirdModelo::class, 'MARCODIGO', 'MARCODIGO');
    }

    // Relacionamento com TBPGRUPO
    public function gruposTabelaPreco(): HasMany
    {
        return $this->hasMany(FirebirdTbpgrupo::class, 'MARCODIGO', 'MARCODIGO');
    }

    // Relacionamento com VISUALTPLCLI
    public function templatesVisuaisClientes(): HasMany
    {
        return $this->hasMany(FirebirdVisualtplcli::class, 'MARCODIGO', 'MARCODIGO');
    }

    public function scopePorFabricante($query, int $idFabricante)
    {
        return $query->where('ID_FABRICANTE', $idFabricante);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MARNOME');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

