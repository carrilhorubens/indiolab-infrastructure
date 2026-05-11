# GRUPO3 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPO3 (Grupo 3 de Produtos)
- **Total de Registros**: 39
- **Total de Colunas**: 4
- **Chave Primária**: GR3CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 3 (GRUPO3SISEXT, TBPGRUPO, VISUALTPLCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPO3** é uma tabela mestre que armazena o terceiro nível de categorização de produtos. Com **39 registros**, representa subcategorias terciárias utilizadas para organização hierárquica de produtos, complementando GRUPO1 e GRUPO2 no terceiro nível da estrutura hierárquica (GRUPO1 → GRUPO2 → GRUPO3 → GRUPO4).

Esta tabela funciona como **subcategoria terciária de produtos** e permite:
- Categorizar produtos em grupos terciários
- Controlar disponibilidade para internet
- Definir ordem de exibição
- Facilitar organização hierárquica de produtos
- Suportar classificação em múltiplos níveis

Cada registro representa um grupo terciário de produtos, contendo:
- Código do grupo (GR3CODIGO)
- Descrição do grupo (GR3DESCRICAO)
- Ordem de exibição (GR3ORDEM)
- Flag de disponibilidade para internet (GR3INTERNET)

O sistema utiliza esta tabela como terceiro nível de categorização hierárquica de produtos, sendo complementada por GRUPO4 para formar uma estrutura completa de classificação.

**Observação Importante:** GRUPO3 é parte de uma estrutura hierárquica de categorização de produtos. Com 39 registros, indica uso moderado desta funcionalidade. É referenciada por TBPGRUPO (tabelas de preço), VISUALTPLCLI (templates visuais) e GRUPO3SISEXT (integrações externas).

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR3CODIGO** 🔑 | SMALLINT | ✓ | Código do grupo 3 (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GR3DESCRICAO** | VARCHAR(37) | ✓ | Descrição do grupo 3 |
| **GR3ORDEM** | SMALLINT | ✓ | Ordem de exibição |
| **GR3INTERNET** | VARCHAR(14) | | Flag de disponibilidade para internet (S/N) |

**Primary Key:** GR3CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPO3 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPO3 é Referenciada Por (3 tabelas):

#### 1. GRUPO3SISEXT - Integração com Sistemas Externos
**Relacionamento:**
```
GRUPO3SISEXT.GR3CODIGO → GRUPO3.GR3CODIGO (N:1)
Constraint: GRUPO3_GRUPO3SISEXT
```

**Descrição**: Cada grupo 3 pode ter múltiplos mapeamentos com sistemas externos.

**Uso:** Mapear grupos 3 internos com códigos de sistemas externos.

---

#### 2. TBPGRUPO - Grupos de Tabela de Preço
**Relacionamento:**
```
TBPGRUPO.GR3CODIGO → GRUPO3.GR3CODIGO (N:1)
Constraint: GRUPO3_TBPGRUPO
```

**Descrição**: Cada grupo de tabela de preço pode estar vinculado a um grupo 3 específico.

**Uso:** Vincular grupos de tabela de preço a grupos 3 de produtos.

---

#### 3. VISUALTPLCLI - Templates Visuais de Cliente
**Relacionamento:**
```
VISUALTPLCLI.GR3CODIGO → GRUPO3.GR3CODIGO (N:1)
Constraint: GRUPO3_VISUALTPLCLI
```

**Descrição**: Cada template visual pode estar vinculado a um grupo 3 específico.

**Uso:** Vincular templates visuais a grupos 3 de produtos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo 3

**Objetivo:** Obter informações de um grupo 3 específico.

```sql
SELECT
    GR3CODIGO,
    GR3DESCRICAO AS GRUPO3,
    GR3ORDEM AS ORDEM,
    GR3INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO3
WHERE GR3CODIGO = ?;
```

---

### 2. Listar Todos os Grupos 3

**Objetivo:** Obter catálogo completo de grupos 3.

```sql
SELECT
    GR3CODIGO,
    GR3DESCRICAO AS GRUPO3,
    GR3ORDEM AS ORDEM,
    GR3INTERNET AS DISPONIVEL_INTERNET
FROM GRUPO3
ORDER BY GR3ORDEM;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPO3 | Tipo |
|--------|-----------|---------------------|------|
| **GRUPO3** | 39 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **39 grupos 3** cadastrados no sistema
- Estrutura hierárquica complementada por GRUPO1, GRUPO2 e GRUPO4

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_GRUPO3_ORDEM ON GRUPO3(GR3ORDEM)
    WHERE GR3ORDEM IS NOT NULL;

-- Índice 2: Busca por disponibilidade internet (consultas frequentes)
CREATE INDEX IDX_GRUPO3_INTERNET ON GRUPO3(GR3INTERNET)
    WHERE GR3INTERNET = 'S';
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdGrupo3 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPO3';
    
    protected $primaryKey = 'GR3CODIGO';
    public $incrementing = true;

    protected $casts = [
        'GR3CODIGO' => 'integer',
        'GR3DESCRICAO' => 'string',
        'GR3ORDEM' => 'integer',
        'GR3INTERNET' => 'string',
    ];

    public function scopeDisponivelInternet($query)
    {
        return $query->where('GR3INTERNET', 'S');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('GR3ORDEM');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

