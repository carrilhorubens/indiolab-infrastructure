# ITPRODUPDC - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: ITPRODUPDC (Itens de Produto PDC)
- **Total de Registros**: 5
- **Total de Colunas**: 5
- **Chave Primária**: Composta (PPCODIGO, IPPSEQ)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**ITPRODUPDC** é uma tabela que armazena itens de produtos PDC (Plano de Controle de Produção). Com apenas **5 registros**, representa itens específicos que compõem produtos PDC, permitindo configuração de sequência e concatenação de itens.

Esta tabela funciona como **tabela de itens de produto PDC** e permite:
- Armazenar itens que compõem produtos PDC
- Definir sequência e ordem de itens
- Configurar concatenação de itens
- Vincular itens a tipos de produto PDC
- Facilitar gestão de composição de produtos PDC
- Suportar configuração de itens por produto

Cada registro representa um item específico de um produto PDC, contendo:
- Código do produto PDC (PPCODIGO) - FK → PRODUPDC (parte da PK)
- Sequencial do item (IPPSEQ) - parte da PK
- Código do tipo de produto PDC (TPPCODIGO) - FK → TPPRODUPDC
- Configuração de concatenação (IPPCONCATENA)
- Ordem do item (IPPORDEM)

O sistema utiliza esta tabela para manter itens que compõem produtos PDC, permitindo configuração detalhada de composição.

**Observação Importante:** ITPRODUPDC é uma tabela de itens de produto PDC. Com apenas 5 registros, indica uso muito limitado desta funcionalidade no momento. Possui chave primária composta e relacionamentos com PRODUPDC e TPPRODUPDC.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código do produto PDC (PK + FK → PRODUPDC) |
| **IPPSEQ** 🔑 | SMALLINT | ✓ | Sequencial do item (PK) |

### Relacionamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPPCODIGO** 🔗 | SMALLINT | ✓ | Código do tipo de produto PDC (FK → TPPRODUPDC) |

### Informações do Item
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IPPCONCATENA** | VARCHAR(14) | | Configuração de concatenação |
| **IPPORDEM** | SMALLINT | | Ordem do item |

**Primary Key:** (PPCODIGO, IPPSEQ)

**Foreign Keys:**
- `PPCODIGO` → `PRODUPDC.PPCODIGO` (Constraint: PRODUPDC_ITPRODUPDC)
- `TPPCODIGO` → `TPPRODUPDC.TPPCODIGO` (Constraint: TPPRODUPDC_ITPRODUPDC)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### ITPRODUPDC Referencia (2 FKs):

#### 1. PRODUPDC - Produtos PDC
**Relacionamento:**
```
ITPRODUPDC.PPCODIGO → PRODUPDC.PPCODIGO (N:1)
Constraint: PRODUPDC_ITPRODUPDC
```

**Descrição**: Cada item está vinculado a um produto PDC específico.

**Informações da Tabela PRODUPDC:**
- **Total:** 1 produto PDC
- **PK:** PPCODIGO
- **Colunas:** 4 campos

**Uso:** Identificar o produto PDC ao qual o item pertence.

---

#### 2. TPPRODUPDC - Tipos de Produto PDC
**Relacionamento:**
```
ITPRODUPDC.TPPCODIGO → TPPRODUPDC.TPPCODIGO (N:1)
Constraint: TPPRODUPDC_ITPRODUPDC
```

**Descrição**: Cada item está vinculado a um tipo de produto PDC específico.

**Informações da Tabela TPPRODUPDC:**
- **Total:** 5 tipos de produto PDC
- **PK:** TPPCODIGO
- **Colunas:** 7 campos

**Uso:** Identificar o tipo de produto PDC ao qual o item pertence.

---

### ITPRODUPDC é Referenciada Por (0 tabelas):

Nenhuma tabela referencia ITPRODUPDC diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Itens de um Produto PDC

**Objetivo:** Obter todos os itens de um produto PDC específico.

```sql
SELECT
    itp.PPCODIGO,
    pp.PPDESCRICAO AS PRODUTO_PDC,
    itp.IPPSEQ,
    itp.TPPCODIGO,
    tpp.TPPDESCRICAO AS TIPO_PRODUTO_PDC,
    itp.IPPCONCATENA,
    itp.IPPORDEM
FROM ITPRODUPDC itp
INNER JOIN PRODUPDC pp ON pp.PPCODIGO = itp.PPCODIGO
INNER JOIN TPPRODUPDC tpp ON tpp.TPPCODIGO = itp.TPPCODIGO
WHERE itp.PPCODIGO = ?
ORDER BY itp.IPPORDEM, itp.IPPSEQ;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com ITPRODUPDC | Tipo |
|--------|-----------|------------------------|------|
| **ITPRODUPDC** | 5 | 1:1 | **TABELA PRINCIPAL** |
| PRODUPDC | 1 | 1:5 | Produtos PDC (média de 5 itens por produto) |
| TPPRODUPDC | 5 | 1:1 | Tipos de produto PDC (mapeamento 1:1) |

**Interpretação:**
- **5 itens** de produto PDC cadastrados no sistema
- **Média de 5 itens por produto** - indica que o único produto PDC possui 5 itens

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto PDC (consultas frequentes)
CREATE INDEX IDX_ITPRODUPDC_PRODUTO ON ITPRODUPDC(PPCODIGO);

-- Índice 2: Busca por tipo de produto PDC (consultas frequentes)
CREATE INDEX IDX_ITPRODUPDC_TIPO ON ITPRODUPDC(TPPCODIGO);
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

final class FirebirdItprodupdc extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'ITPRODUPDC';
    
    protected $primaryKey = ['PPCODIGO', 'IPPSEQ'];
    public $incrementing = false;

    protected $casts = [
        'PPCODIGO' => 'integer',
        'IPPSEQ' => 'integer',
        'TPPCODIGO' => 'integer',
        'IPPCONCATENA' => 'string',
        'IPPORDEM' => 'integer',
    ];

    // Relacionamento com PRODUPDC
    public function produtoPdc(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdupdc::class, 'PPCODIGO', 'PPCODIGO');
    }

    // Relacionamento com TPPRODUPDC
    public function tipoProdutoPdc(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpprodupdc::class, 'TPPCODIGO', 'TPPCODIGO');
    }

    public function scopePorProduto($query, int $ppCodigo)
    {
        return $query->where('PPCODIGO', $ppCodigo);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('IPPORDEM')->orderBy('IPPSEQ');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

