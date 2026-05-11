# IMPRTPPED - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPRTPPED (Impressora x Tipo de Pedido)
- **Total de Registros**: 1
- **Total de Colunas**: 5
- **Chave Primária**: Composta (TPCODIGO, IMPCODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPRTPPED** é uma tabela de relacionamento que vincula impressoras a tipos de pedido. Com apenas **1 registro**, representa configurações de impressão específicas por tipo de pedido e empresa, permitindo que cada tipo de pedido tenha impressoras configuradas.

Esta tabela funciona como **tabela de relacionamento** e permite:
- Vincular impressoras a tipos de pedido
- Configurar impressoras por empresa e tipo de pedido
- Facilitar gestão de impressão por tipo de pedido
- Suportar impressão local ou remota
- Facilitar controle de impressão por tipo de pedido

Cada registro representa uma vinculação específica entre uma impressora e um tipo de pedido, contendo:
- Código do tipo de pedido (TPCODIGO) - FK → TPPEDID
- Código da impressora (IMPCODIGO) - FK → IMPRESSORAS
- Código da empresa (EMPCODIGO) - FK → EMPRESA
- Configuração de impressão local (ITPIMPRIMELOCAL)
- Configuração de nome parcial (ITPNOMEPARCIAL)

O sistema utiliza esta tabela para configurar quais impressoras estão disponíveis para cada tipo de pedido, permitindo controle de impressão específico.

**Observação Importante:** IMPRTPPED é uma tabela de relacionamento com chave primária composta. Com apenas 1 registro, indica uso muito limitado desta funcionalidade no momento. Possui relacionamentos com TPPEDID, IMPRESSORAS e EMPRESA.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código do tipo de pedido (PK + FK → TPPEDID) |
| **IMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da impressora (PK + FK → IMPRESSORAS) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Informações de Configuração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITPIMPRIMELOCAL** | VARCHAR(14) | ✓ | Configuração de impressão local |
| **ITPNOMEPARCIAL** | VARCHAR(14) | ✓ | Configuração de nome parcial |

**Primary Key:** (TPCODIGO, IMPCODIGO, EMPCODIGO)

**Foreign Keys:**
- `TPCODIGO` → `TPPEDID.TPCODIGO` (Constraint: TPPEDID_IMPRTPPED)
- `IMPCODIGO` → `IMPRESSORAS.IMPCODIGO` (Constraint: IMPRESSORAS_IMPRTPPED)
- `EMPCODIGO` → `EMPRESA.EMPCODIGO` (Constraint: EMPRESA_IMPRTPPED)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPRTPPED Referencia (3 FKs):

#### 1. TPPEDID - Tipos de Pedido
**Relacionamento:**
```
IMPRTPPED.TPCODIGO → TPPEDID.TPCODIGO (N:1)
Constraint: TPPEDID_IMPRTPPED
```

**Descrição**: Cada vinculação está relacionada a um tipo de pedido específico.

**Informações da Tabela TPPEDID:**
- **Total:** 17 tipos de pedido
- **PK:** TPCODIGO
- **Colunas:** 22 campos

**Uso:** Identificar o tipo de pedido ao qual a impressora está vinculada.

---

#### 2. IMPRESSORAS - Impressoras
**Relacionamento:**
```
IMPRTPPED.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRTPPED
```

**Descrição**: Cada vinculação está relacionada a uma impressora específica.

**Informações da Tabela IMPRESSORAS:**
- **Total:** 9 impressoras
- **PK:** IMPCODIGO
- **Colunas:** 11 campos

**Uso:** Identificar a impressora vinculada ao tipo de pedido.

---

#### 3. EMPRESA - Empresas
**Relacionamento:**
```
IMPRTPPED.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_IMPRTPPED
```

**Descrição**: Cada vinculação está relacionada a uma empresa específica.

**Informações da Tabela EMPRESA:**
- **Total:** 6 empresas
- **PK:** EMPCODIGO
- **Colunas:** 88 campos

**Uso:** Identificar a empresa à qual a configuração pertence.

---

### IMPRTPPED é Referenciada Por (0 tabelas):

Nenhuma tabela referencia IMPRTPPED diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Impressora por Tipo de Pedido

**Objetivo:** Obter configuração de impressora para um tipo de pedido específico.

```sql
SELECT
    itp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    itp.IMPCODIGO,
    imp.IMPDESCRICAO AS IMPRESSORA,
    itp.EMPCODIGO,
    e.EMPNOMEFANT AS EMPRESA,
    itp.ITPIMPRIMELOCAL,
    itp.ITPNOMEPARCIAL
FROM IMPRTPPED itp
INNER JOIN TPPEDID tp ON tp.TPCODIGO = itp.TPCODIGO
INNER JOIN IMPRESSORAS imp ON imp.IMPCODIGO = itp.IMPCODIGO
INNER JOIN EMPRESA e ON e.EMPCODIGO = itp.EMPCODIGO
WHERE itp.TPCODIGO = ?
  AND itp.EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPRTPPED | Tipo |
|--------|-----------|----------------------|------|
| **IMPRTPPED** | 1 | 1:1 | **TABELA PRINCIPAL** |
| TPPEDID | 17 | 1:17 | Tipos de pedido |
| IMPRESSORAS | 9 | 1:9 | Impressoras |
| EMPRESA | 6 | 1:6 | Empresas |

**Interpretação:**
- **1 configuração** de impressora por tipo de pedido registrada no sistema
- Indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo de pedido e empresa (consultas frequentes)
CREATE INDEX IDX_IMPRTPPED_TIPO_EMPRESA ON IMPRTPPED(TPCODIGO, EMPCODIGO);
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

final class FirebirdImprtpped extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPRTPPED';
    
    protected $primaryKey = ['TPCODIGO', 'IMPCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'TPCODIGO' => 'integer',
        'IMPCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'ITPIMPRIMELOCAL' => 'string',
        'ITPNOMEPARCIAL' => 'string',
    ];

    // Relacionamento com TPPEDID
    public function tipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdTppedid::class, 'TPCODIGO', 'TPCODIGO');
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

