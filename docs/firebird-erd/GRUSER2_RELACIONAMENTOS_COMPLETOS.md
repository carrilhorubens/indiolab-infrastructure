# GRUSER2 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUSER2 (Grupo de Serviços 2)
- **Total de Registros**: 1
- **Total de Colunas**: 2
- **Chave Primária**: GS2CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (SERVI, TBSGRUPO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUSER2** é uma tabela mestre que armazena o segundo nível de grupos de serviços utilizados para categorização hierárquica de serviços. Com apenas **1 registro**, representa subcategorias de serviços que complementam GRUSER no segundo nível da estrutura hierárquica.

Esta tabela funciona como **subcategoria de grupos de serviços** e permite:
- Categorizar serviços em grupos secundários
- Facilitar organização hierárquica de serviços
- Suportar classificação em múltiplos níveis
- Vincular grupos a tabelas de preço de serviços
- Complementar GRUSER na estrutura hierárquica

Cada registro representa um grupo secundário de serviços, contendo:
- Código do grupo (GS2CODIGO)
- Nome do grupo (GS2NOME)

O sistema utiliza esta tabela como segundo nível de categorização hierárquica de serviços, sendo referenciada por SERVI (serviços) e TBSGRUPO (grupos de tabela de preço de serviços).

**Observação Importante:** GRUSER2 complementa GRUSER formando uma estrutura hierárquica de categorização de serviços. Com apenas 1 registro, indica uso muito limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GS2CODIGO** 🔑 | SMALLINT | ✓ | Código do grupo de serviços 2 (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GS2NOME** | VARCHAR(37) | ✓ | Nome do grupo de serviços 2 |

**Primary Key:** GS2CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUSER2 Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUSER2 é Referenciada Por (2 tabelas):

#### 1. SERVI - Serviços
**Relacionamento:**
```
SERVI.GS2CODIGO → GRUSER2.GS2CODIGO (N:1)
Constraint: GRUSER2_SERVI
```

**Descrição**: Cada serviço pode estar vinculado a um grupo de serviços 2 específico.

**Informações da Tabela SERVI:**
- **Total:** 13 serviços
- **PK:** SERCODIGO
- **Colunas:** 51 campos

**Uso:** Vincular serviços a grupos secundários de serviços para organização hierárquica.

---

#### 2. TBSGRUPO - Grupos de Tabela de Preço de Serviços
**Relacionamento:**
```
TBSGRUPO.TBSGS2CODIGO → GRUSER2.GS2CODIGO (N:1)
Constraint: GS2GRUPO_TBGRUPO
```

**Descrição**: Cada grupo de tabela de preço de serviços pode estar vinculado a um grupo de serviços 2 específico.

**Informações da Tabela TBSGRUPO:**
- **Total:** 0 registros
- **PK:** (TBSCODIGO, TBSSEQ)
- **Colunas:** 5 campos

**Uso:** Vincular grupos de tabela de preço de serviços a grupos secundários de serviços.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Serviços 2

**Objetivo:** Obter informações de um grupo de serviços 2 específico.

```sql
SELECT
    GS2CODIGO,
    GS2NOME AS GRUPO_SERVICOS_2
FROM GRUSER2
WHERE GS2CODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Serviços 2

**Objetivo:** Obter catálogo completo de grupos de serviços 2.

```sql
SELECT
    GS2CODIGO,
    GS2NOME AS GRUPO_SERVICOS_2
FROM GRUSER2
ORDER BY GS2NOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUSER2 | Tipo |
|--------|-----------|---------------------|------|
| **GRUSER2** | 1 | 1:1 | **TABELA PRINCIPAL** |
| SERVI | 13 | 1:13 | Serviços (média de 13 serviços por grupo) |

**Interpretação:**
- **1 grupo de serviços 2** cadastrado no sistema
- Complementa GRUSER na estrutura hierárquica

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (consultas frequentes)
CREATE INDEX IDX_GRUSER2_NOME ON GRUSER2(GS2NOME)
    WHERE GS2NOME IS NOT NULL;
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

final class FirebirdGruser2 extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUSER2';
    
    protected $primaryKey = 'GS2CODIGO';
    public $incrementing = true;

    protected $casts = [
        'GS2CODIGO' => 'integer',
        'GS2NOME' => 'string',
    ];

    // Relacionamento com SERVI
    public function servicos(): HasMany
    {
        return $this->hasMany(FirebirdServi::class, 'GS2CODIGO', 'GS2CODIGO');
    }

    // Relacionamento com TBSGRUPO
    public function gruposTabelaPreco(): HasMany
    {
        return $this->hasMany(FirebirdTbsgrupo::class, 'TBSGS2CODIGO', 'GS2CODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

