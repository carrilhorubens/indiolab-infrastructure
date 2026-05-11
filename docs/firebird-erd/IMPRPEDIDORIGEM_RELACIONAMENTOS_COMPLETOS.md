# IMPRPEDIDORIGEM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPRPEDIDORIGEM (Impressora x Pedido Origem)
- **Total de Registros**: 1
- **Total de Colunas**: 5
- **Chave Primária**: Composta (PDOCODIGO, IMPCODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPRPEDIDORIGEM** é uma tabela de relacionamento que vincula impressoras a tipos de pedido origem. Com apenas **1 registro**, representa configurações de impressão específicas por tipo de pedido origem e empresa, permitindo que cada tipo de pedido origem tenha impressoras configuradas.

Esta tabela funciona como **tabela de relacionamento** e permite:
- Vincular impressoras a tipos de pedido origem
- Configurar impressoras por empresa e tipo de pedido origem
- Facilitar gestão de impressão por tipo de pedido
- Suportar configurações específicas de impressão
- Facilitar controle de impressão por origem de pedido

Cada registro representa uma vinculação específica entre uma impressora e um tipo de pedido origem, contendo:
- Código do pedido origem (PDOCODIGO) - FK → PEDIDORIGEM
- Código da impressora (IMPCODIGO) - FK → IMPRESSORAS
- Código da empresa (EMPCODIGO) - FK → EMPRESA
- Configuração de origem de pedido origem (IPOCONSORIGEMPEDORIG)
- Modelo de impressão (IMPMODELO)

O sistema utiliza esta tabela para configurar quais impressoras estão disponíveis para cada tipo de pedido origem, permitindo controle de impressão específico.

**Observação Importante:** IMPRPEDIDORIGEM é uma tabela de relacionamento com chave primária composta. Com apenas 1 registro, indica uso muito limitado desta funcionalidade no momento. Possui relacionamentos com PEDIDORIGEM, IMPRESSORAS e EMPRESA.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PDOCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código do pedido origem (PK + FK → PEDIDORIGEM) |
| **IMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da impressora (PK + FK → IMPRESSORAS) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Informações de Configuração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IPOCONSORIGEMPEDORIG** | VARCHAR(14) | | Configuração de origem de pedido origem |
| **IMPMODELO** | VARCHAR(14) | | Modelo de impressão |

**Primary Key:** (PDOCODIGO, IMPCODIGO, EMPCODIGO)

**Foreign Keys:**
- `PDOCODIGO` → `PEDIDORIGEM.PDOCODIGO` (Constraint: PEDIDORIGEM_IMPRPEDIDORIGEM)
- `IMPCODIGO` → `IMPRESSORAS.IMPCODIGO` (Constraint: IMPRESSORAS_IMPRPEDIDORIGEM)
- `EMPCODIGO` → `EMPRESA.EMPCODIGO` (Constraint: EMPRESA_IMPRPEDIDORIGEM)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPRPEDIDORIGEM Referencia (3 FKs):

#### 1. PEDIDORIGEM - Pedidos Origem
**Relacionamento:**
```
IMPRPEDIDORIGEM.PDOCODIGO → PEDIDORIGEM.PDOCODIGO (N:1)
Constraint: PEDIDORIGEM_IMPRPEDIDORIGEM
```

**Descrição**: Cada vinculação está relacionada a um tipo de pedido origem específico.

**Informações da Tabela PEDIDORIGEM:**
- **Total:** 22 tipos de pedido origem
- **PK:** PDOCODIGO
- **Colunas:** 3 campos

**Uso:** Identificar o tipo de pedido origem ao qual a impressora está vinculada.

---

#### 2. IMPRESSORAS - Impressoras
**Relacionamento:**
```
IMPRPEDIDORIGEM.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRPEDIDORIGEM
```

**Descrição**: Cada vinculação está relacionada a uma impressora específica.

**Informações da Tabela IMPRESSORAS:**
- **Total:** 9 impressoras
- **PK:** IMPCODIGO
- **Colunas:** 11 campos

**Uso:** Identificar a impressora vinculada ao tipo de pedido origem.

---

#### 3. EMPRESA - Empresas
**Relacionamento:**
```
IMPRPEDIDORIGEM.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_IMPRPEDIDORIGEM
```

**Descrição**: Cada vinculação está relacionada a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos

**Uso:** Identificar a empresa à qual a configuração pertence.

---

### IMPRPEDIDORIGEM é Referenciada Por (0 tabelas):

Nenhuma tabela referencia IMPRPEDIDORIGEM diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Impressora por Pedido Origem

**Objetivo:** Obter configuração de impressora para um tipo de pedido origem específico.

```sql
SELECT
    ipr.PDOCODIGO,
    po.PDODESCRICAO AS PEDIDO_ORIGEM,
    ipr.IMPCODIGO,
    imp.IMPDESCRICAO AS IMPRESSORA,
    ipr.EMPCODIGO,
    e.EMPNOMEFANT AS EMPRESA,
    ipr.IPOCONSORIGEMPEDORIG,
    ipr.IMPMODELO
FROM IMPRPEDIDORIGEM ipr
INNER JOIN PEDIDORIGEM po ON po.PDOCODIGO = ipr.PDOCODIGO
INNER JOIN IMPRESSORAS imp ON imp.IMPCODIGO = ipr.IMPCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = ipr.EMPCODIGO
WHERE ipr.PDOCODIGO = ?
  AND ipr.EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPRPEDIDORIGEM | Tipo |
|--------|-----------|----------------------------|------|
| **IMPRPEDIDORIGEM** | 1 | 1:1 | **TABELA PRINCIPAL** |
| PEDIDORIGEM | 22 | 1:22 | Tipos de pedido origem |
| IMPRESSORAS | 9 | 1:9 | Impressoras |
| EMPRESA | 6 | 1:6 | Empresas |

**Interpretação:**
- **1 configuração** de impressora por pedido origem registrada no sistema
- Indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por pedido origem e empresa (consultas frequentes)
CREATE INDEX IDX_IMPRPEDIDORIGEM_PEDIDO_EMPRESA ON IMPRPEDIDORIGEM(PDOCODIGO, EMPCODIGO);
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

final class FirebirdImprpedidorigem extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPRPEDIDORIGEM';
    
    protected $primaryKey = ['PDOCODIGO', 'IMPCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'PDOCODIGO' => 'string',
        'IMPCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'IPOCONSORIGEMPEDORIG' => 'string',
        'IMPMODELO' => 'string',
    ];

    // Relacionamento com PEDIDORIGEM
    public function pedidoOrigem(): BelongsTo
    {
        return $this->belongsTo(FirebirdPedidorigem::class, 'PDOCODIGO', 'PDOCODIGO');
    }

    // Relacionamento com IMPRESSORAS
    public function impressora(): BelongsTo
    {
        return $this->belongsTo(FirebirdImpressoras::class, 'IMPCODIGO', 'IMPCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

