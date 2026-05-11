# PRODORIPROMO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: PRODORIPROMO (Produto Origem Promoção)
- **Total de Registros**: 5.170
- **Total de Colunas**: 5
- **Chave Primária**: ID_PRODORIPROMO, ID_REGPROPROMO (composite)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**PRODORIPROMO** é uma tabela de relacionamento que associa regras de promoção de produtos com informações de origem. Com **5.170 registros**, esta tabela registra informações sobre origem de produtos em promoções, incluindo chave, origem e valor relacionados.

Esta tabela é essencial para:
- **Promoções**: Gerenciar origens de produtos em promoções
- **Rastreamento**: Rastrear origens de produtos por regra de promoção
- **Relatórios**: Gerar relatórios de origens de produtos em promoções
- **Auditoria**: Manter histórico de origens

**Contexto de Negócio:**
Regras de promoção de produtos podem ter informações sobre origem dos produtos. Esta tabela gerencia essas informações, permitindo rastrear a origem de produtos em cada regra de promoção.

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ID_PRODORIPROMO** 🔑 | INT | Identificador único da origem (PK) |
| **ID_REGPROPROMO** 🔑 🔗 | INT | Código da regra de promoção de produto (PK, FK → REGPROPROMO) |
| **CHAVE** | VARCHAR(37) | Chave da origem |
| **ORIGEM** | VARCHAR(37) | Descrição da origem |
| **VALOR** | VARCHAR(37) | Valor relacionado à origem |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### REGPROPROMO - Regra Promoção Produto (FK Obrigatória)
**Volume:** 2.251 registros

**Relacionamento:**
```
PRODORIPROMO.ID_REGPROPROMO → REGPROPROMO.ID_REGPROPROMO (N:1)
Constraint: XFK_PRODORIPROMO_REGPROPROMO
```

**Descrição:** Cada registro relaciona uma origem com uma regra de promoção de produto.

**Proporção:** ~2,3 origens por regra de promoção em média (5.170 / 2.251)

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### REGPROPROMO → PROMO (Promoção)
**Volume:** Variável

**Relacionamento:**
```
PRODORIPROMO → REGPROPROMO → PROMO
```

**Descrição:** Através de REGPROPROMO, é possível identificar a promoção relacionada.

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    PRODORIPROMO {
        INT ID_PRODORIPROMO PK
        INT ID_REGPROPROMO PK
        VARCHAR CHAVE
        VARCHAR ORIGEM
        VARCHAR VALOR
    }
    
    REGPROPROMO {
        INT ID_REGPROPROMO PK
        INT ID_PROMO FK
        VARCHAR NOMEREGRA
    }
    
    PRODORIPROMO }o--|| REGPROPROMO : "ID_REGPROPROMO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT ID_PRODORIPROMO, ID_REGPROPROMO, CHAVE, ORIGEM, VALOR
FROM PRODORIPROMO
WHERE ID_REGPROPROMO = ?;
```

### Consulta com Informações da Regra de Promoção

```sql
SELECT 
    po.*,
    rp.NOMEREGRA
FROM PRODORIPROMO po
INNER JOIN REGPROPROMO rp
    ON po.ID_REGPROPROMO = rp.ID_REGPROPROMO
WHERE po.ID_REGPROPROMO = ?;
```

### Consulta de Origens por Regra de Promoção

```sql
SELECT 
    po.*
FROM PRODORIPROMO po
WHERE po.ID_REGPROPROMO = ?
ORDER BY po.ORIGEM;
```

### Inserção de Origem

```sql
INSERT INTO PRODORIPROMO (ID_REGPROPROMO, CHAVE, ORIGEM, VALOR)
VALUES (?, ?, ?, ?);
```

---

## ⚡ Performance e Otimização

### Índices Recomendados

#### 1. Índice Composto na Chave Primária (Já existe implicitamente)
```sql
-- Índice primário já existe implicitamente
```

#### 2. Índice em ID_REGPROPROMO
```sql
CREATE INDEX IDX_PRODORIPROMO_ID_REGPROPROMO 
ON PRODORIPROMO (ID_REGPROPROMO);
```

**Justificativa:** Facilita buscas por regra de promoção.

---

## 📊 Estatísticas e Insights

### Volume de Dados

- **Total de Registros**: 5.170
- **Tamanho Médio Estimado**: ~60 bytes por registro
- **Tamanho Total Estimado**: ~310 KB

### Distribuição de Dados

- **Origens**: 5.170 origens de produtos em promoções
- **Média por Regra**: ~2,3 origens por regra de promoção

---

## 🔧 Integração com Código Laravel

### Model Eloquent

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class ProDoriPromo extends Model
{
    protected $table = 'PRODORIPROMO';
    public $incrementing = false;
    public $timestamps = false;

    protected $primaryKey = ['ID_PRODORIPROMO', 'ID_REGPROPROMO'];

    protected $fillable = [
        'ID_REGPROPROMO',
        'CHAVE',
        'ORIGEM',
        'VALOR',
    ];

    protected $casts = [
        'ID_PRODORIPROMO' => 'integer',
        'ID_REGPROPROMO' => 'integer',
        'CHAVE' => 'string',
        'ORIGEM' => 'string',
        'VALOR' => 'string',
    ];

    /**
     * Relacionamento com Regra Promoção Produto
     */
    public function regraPromocaoProduto(): BelongsTo
    {
        return $this->belongsTo(RegProPromo::class, 'ID_REGPROPROMO', 'ID_REGPROPROMO');
    }

    /**
     * Buscar origens por regra de promoção
     */
    public static function origensPorRegra(int $idRegProPromo)
    {
        return self::where('ID_REGPROPROMO', $idRegProPromo)
            ->with(['regraPromocaoProduto'])
            ->get();
    }
}
```

---

## ✅ Boas Práticas

### Design

1. **Chave Composta**: Manter integridade da chave composta
2. **Validação**: Validar ID_REGPROPROMO antes de inserir
3. **Unicidade**: Garantir que não haja duplicatas

### Performance

1. **Índices**: Usar índices para buscas frequentes
2. **Consultas**: Usar eager loading para relacionamentos

### Segurança

1. **Validação**: Validar valores antes de inserir
2. **Acesso**: Restringir acesso de escrita a usuários autorizados

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

