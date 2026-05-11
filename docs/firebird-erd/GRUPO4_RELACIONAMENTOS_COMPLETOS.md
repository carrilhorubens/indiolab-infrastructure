# GRUPO4 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPO4 (Grupo 4 de Produtos)
- **Total de Registros**: 28
- **Total de Colunas**: 4
- **Chave Primária**: GR4CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 3 (GRUPO4SISEXT, TBPGRUPO, VISUALTPLCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPO4** é uma tabela mestre que armazena o quarto nível de categorização de produtos. Com **28 registros**, representa subcategorias quaternárias utilizadas para organização hierárquica de produtos, completando a estrutura hierárquica (GRUPO1 → GRUPO2 → GRUPO3 → GRUPO4).

Esta tabela funciona como **subcategoria quaternária de produtos** e permite:
- Categorizar produtos em grupos quaternários
- Controlar disponibilidade para internet
- Definir ordem de exibição
- Facilitar organização hierárquica de produtos
- Suportar classificação em múltiplos níveis

Cada registro representa um grupo quaternário de produtos, contendo:
- Código do grupo (GR4CODIGO)
- Descrição do grupo (GR4DESCRICAO)
- Ordem de exibição (GR4ORDEM)
- Flag de disponibilidade para internet (GR4INTERNET)

O sistema utiliza esta tabela como quarto nível de categorização hierárquica de produtos, completando a estrutura de classificação hierárquica.

**Observação Importante:** GRUPO4 é parte de uma estrutura hierárquica de categorização de produtos. Com 28 registros, indica uso moderado desta funcionalidade. É referenciada por TBPGRUPO (tabelas de preço), VISUALTPLCLI (templates visuais) e GRUPO4SISEXT (integrações externas).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR4CODIGO** 🔑 | SMALLINT | ✓ | Código do grupo 4 (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR4DESCRICAO** | VARCHAR(37) | ✓ | Descrição do grupo 4 |
| **GR4ORDEM** | SMALLINT | ✓ | Ordem de exibição |
| **GR4INTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |

**Primary Key:** GR4CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPO4 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPO4 é Referenciada Por (3 tabelas):

#### 1. GRUPO4SISEXT - Integração com Sistemas Externos
**Relacionamento:**
```
GRUPO4SISEXT.GR4CODIGO → GRUPO4.GR4CODIGO (N:1)
Constraint: GRUPO4_GRUPO4SISEXT
```

**Descrição**: Cada grupo 4 pode ter múltiplos mapeamentos com sistemas externos.

**Uso:** Mapear grupos 4 internos com códigos de sistemas externos.

---

#### 2. TBPGRUPO - Grupos de Tabela de Preço
**Relacionamento:**
```
TBPGRUPO.GR4CODIGO → GRUPO4.GR4CODIGO (N:1)
Constraint: GRUPO4_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preço pode estar vinculado a um grupo 4 específico.

**Uso:** Vincular grupos de tabela de preço a grupos 4 de produtos.

---

#### 3. VISUALTPLCLI - Templates Visuais de Cliente
**Relacionamento:**
```
VISUALTPLCLI.GR4CODIGO → GRUPO4.GR4CODIGO (N:1)
Constraint: GRUPO4_VISUALTPLCLI
```

**Descrição**: Cada template visual pode estar vinculado a um grupo 4 específico.

**Uso:** Vincular templates visuais a grupos 4 de produtos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo 4

**Objetivo:** Obter informações de um grupo 4 específico.

```sql
SELECT
    GR4CODIGO,
    GR4DESCRICAO AS GRUPO4,
    GR4ORDEM AS ORDEM,
    GR4INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO4
WHERE GR4CODIGO = ?;
```

---

### 2. Listar Todos os Grupos 4

**Objetivo:** Obter catálogo completo de grupos 4.

```sql
SELECT
    GR4CODIGO,
    GR4DESCRICAO AS GRUPO4,
    GR4ORDEM AS ORDEM,
    GR4INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO4
ORDER BY GR4ORDEM;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPO4 | Tipo |
|--------|-----------|---------------------|------|
| **GRUPO4** | 28 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **28 grupos 4** cadastrados no sistema
- Completa a estrutura hierárquica junto com GRUPO1, GRUPO2 e GRUPO3

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRUPO4_ORDEM ON GRUPO4(GR4ORDEM)
    WHERE GR4ORDEM IS NOT NULL;

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_GRUPO4_INTERNET ON GRUPO4(GR4INTERNET)
    WHERE GR4INTERNET = 'S';
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdGrupo4 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPO4';
    
    protected $primaryKey = 'GR4CODIGO';
    public $incrementing = true;

    protected $casts = [
        'GR4CODIGO' => 'integer',
        'GR4DESCRICAO' => 'string',
        'GR4ORDEM' => 'integer',
        'GR4INTERNET' => 'string',
    ];

    public function scopeDisponivelInternet($query)
    {
        return $query->where('GR4INTERNET', 'S');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GR4ORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

