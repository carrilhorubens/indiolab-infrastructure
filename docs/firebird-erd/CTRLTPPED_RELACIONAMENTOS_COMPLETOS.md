# CTRLTPPED - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTRLTPPED (Controle x Tipo de Pedido)
- **Total de Registros**: 11
- **Total de Colunas**: 4
- **Chave Primária**: Composta (CTRLCODIGO, TPCODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTRLTPPED** é uma tabela que associa controles (CTRLCODIGO) a tipos de pedido (TPCODIGO) e empresas (EMPCODIGO), possivelmente relacionada a rotinas ou grupos (RGRCODIGO). Com **11 registros**, representa configurações específicas de controles por tipo de pedido e empresa.

Esta tabela funciona como **associador de controles a tipos de pedido** e permite:
- Associar controles a tipos de pedido específicos
- Vincular controles a empresas específicas
- Possivelmente associar a rotinas ou grupos (RGRCODIGO)
- Controlar quais controles são aplicáveis a cada tipo de pedido por empresa

Cada registro representa uma associação específica entre um controle (CTRLCODIGO), um tipo de pedido (TPCODIGO) e uma empresa (EMPCODIGO), contendo:
- Código do controle (CTRLCODIGO)
- Tipo de pedido (TPCODIGO)
- Empresa (EMPCODIGO)
- Código de rotina/grupo (RGRCODIGO) - opcional

O sistema utiliza esta tabela para determinar quais controles são aplicáveis a cada tipo de pedido em cada empresa, permitindo controle granular de processos por tipo de pedido.

**Observação Importante:** CTRLTPPED é uma tabela pequena (11 registros) que associa controles a tipos de pedido e empresas, possivelmente para controle de processos ou rotinas específicas.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTRLCODIGO** 🔑 | INTEGER | ✓ | Código do controle (PK) |
| **TPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código do tipo de pedido (PK + FK → TPPEDID) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → EMPRESA) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **RGRCODIGO** | INTEGER | | Código da rotina/grupo (lógica → ROTINA/GRUPO) |

**Primary Key:** (CTRLCODIGO, TPCODIGO, EMPCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTRLTPPED Referencia (2 FKs):

#### 1. TPPEDID - Tipos de Pedido
**Relacionamento:**
```
CTRLTPPED.TPCODIGO → TPPEDID.TPCODIGO (N:1)
Constraint: TPPEDID_CTRLTPPED
```

**Descrição**: Cada associação está vinculada a um tipo de pedido específico.

---

#### 2. EMPRESA - Empresas
**Relacionamento:**
```
CTRLTPPED.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
Constraint: EMPRESA_CTRLTPPED
```

**Descrição**: Cada associação está vinculada a uma empresa específica.

---

### CTRLTPPED é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTRLTPPED diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Associação de Controle

```sql
SELECT
    CTRLCODIGO,
    TPCODIGO,
    EMPCODIGO,
    RGRCODIGO AS ROTINA_GRUPO
FROM CTRLTPPED
WHERE CTRLCODIGO = ?
  AND TPCODIGO = ?
  AND EMPCODIGO = ?;
```

---

### 2. Listar Controles por Tipo de Pedido

```sql
SELECT
    ctp.CTRLCODIGO,
    ctrl.CTRLDESCRICAO AS DESCRICAO_CONTROLE,
    ctp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    ctp.RGRCODIGO AS ROTINA_GRUPO
FROM CTRLTPPED ctp
LEFT JOIN CONTROL ctrl ON ctrl.CTRLCODIGO = ctp.CTRLCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ctp.EMPCODIGO
WHERE ctp.TPCODIGO = ?
ORDER BY ctp.CTRLCODIGO;
```

---

### 3. Análise de Associações por Empresa

```sql
SELECT
    EMPCODIGO,
    COUNT(*) AS TOTAL_ASSOCIACOES,
    COUNT(DISTINCT TPCODIGO) AS TOTAL_TIPOS_PEDIDO,
    COUNT(DISTINCT CTRLCODIGO) AS TOTAL_CONTROLES
FROM CTRLTPPED
GROUP BY EMPCODIGO
ORDER BY TOTAL_ASSOCIACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CTRLTPPED** | 11 | 1:1 | **TABELA PRINCIPAL** |
| TPPEDID | ~? | ?:1 | Tipos de pedido |
| EMPRESA | ~? | ?:1 | Empresas |

**Interpretação:**
- **11 associações** cadastradas no sistema
- **Uso muito específico** - tabela pequena indica uso pontual desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por tipo de pedido e empresa
CREATE INDEX IDX_CTRLTPPED_TIPO_EMP ON CTRLTPPED(TPCODIGO, EMPCODIGO);

-- Índice 2: Busca por controle
CREATE INDEX IDX_CTRLTPPED_CONTROLE ON CTRLTPPED(CTRLCODIGO);
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

final class FirebirdCtrlTpped extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTRLTPPED';
    
    protected $primaryKey = ['CTRLCODIGO', 'TPCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CTRLCODIGO' => 'integer',
        'TPCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'RGRCODIGO' => 'integer',
    ];

    public function tipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdTppedid::class, 'TPCODIGO', 'TPCODIGO');
    }

    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function scopePorTipoPedido($query, int $tipoPedidoCodigo)
    {
        return $query->where('TPCODIGO', $tipoPedidoCodigo);
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    public function scopePorControle($query, int $controleCodigo)
    {
        return $query->where('CTRLCODIGO', $controleCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

