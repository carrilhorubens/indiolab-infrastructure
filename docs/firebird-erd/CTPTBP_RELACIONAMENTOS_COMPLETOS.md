# CTPTBP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTPTBP (Configurações de Tabelas de Preço por Tipo de Pedido)
- **Total de Registros**: 7.909
- **Total de Colunas**: 9
- **Chave Primária**: Composta (CLICODIGO, TPCODIGO, TBPCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTPTBP** é uma tabela que armazena configurações específicas de tabelas de preço por cliente e tipo de pedido, estendendo CLITPPED com configurações detalhadas de tabelas de preço. Com **7.909 registros**, representa configurações personalizadas de tabelas de preço para clientes específicos em tipos de pedido específicos, incluindo descrições e períodos de validade.

Esta tabela funciona como **configurador de tabelas de preço por tipo de pedido** e permite:
- Definir tabelas de preço personalizadas por cliente e tipo de pedido
- Configurar descrições personalizadas de fechamento
- Controlar períodos de validade das tabelas de preço
- Suportar múltiplas tabelas de preço por cliente e tipo de pedido
- Rastrear data de cadastro de cada configuração
- Facilitar gestão de precificação personalizada por tipo de pedido

Cada registro representa uma configuração específica de uma tabela de preço (TBPCODIGO) para um cliente específico (CLICODIGO) em um tipo de pedido específico (TPCODIGO), contendo:
- Identificação do cliente (CLICODIGO)
- Tipo de pedido (TPCODIGO)
- Tabela de preço (TBPCODIGO)
- Descrição de fechamento (TBPDESCFECH)
- Descrições adicionais (TBPDESC, TBPDESC2)
- Período de validade (TBPDTINICIO, TBPDTVALIDADE)
- Data de cadastro da configuração (TBPDTCADASTRO)

O sistema utiliza esta tabela para personalizar tabelas de preço por cliente e tipo de pedido, permitindo que diferentes clientes tenham diferentes tabelas de preço para os mesmos tipos de pedido.

**Observação Importante:** CTPTBP estende CLITPPED com configurações específicas de tabelas de preço, permitindo que cada cliente tenha suas próprias tabelas de preço por tipo de pedido.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑 🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLITPPED) |
| **TPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código do tipo de pedido (PK + FK → CLITPPED) |
| **TBPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da tabela de preço (PK + FK → TABPRECO) |

### Informações da Tabela de Preço
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDESCFECH** | VARCHAR(14) | ✓ | Descrição de fechamento personalizada |
| **TBPDESC** | NUMERIC(16,4) | | Descrição adicional 1 |
| **TBPDESC2** | NUMERIC(16,4) | | Descrição adicional 2 |

### Período de Validade
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDTINICIO** | DATE | ✓ | Data de início da validade |
| **TBPDTVALIDADE** | DATE | | Data de término da validade |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TBPDTCADASTRO** | TIMESTAMP | | Data de cadastro da configuração |

**Primary Key:** (CLICODIGO, TPCODIGO, TBPCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTPTBP Referencia (3 FKs):

#### 1. CLITPPED - Configurações Cliente x Tipo de Pedido
**Relacionamento:**
```
CTPTBP.CLICODIGO, CTPTBP.TPCODIGO → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPTBP
```

**Descrição**: Cada configuração está vinculada a uma configuração cliente x tipo de pedido específica.

---

#### 2. TABPRECO - Tabelas de Preço
**Relacionamento:**
```
CTPTBP.TBPCODIGO → TABPRECO.TBPCODIGO (N:1)
Constraint: TABPRECO_CTPTBP
```

**Descrição**: Cada configuração está vinculada a uma tabela de preço específica.

---

### CTPTBP é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTPTBP diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Tabela de Preço

```sql
SELECT
    CLICODIGO,
    TPCODIGO,
    TBPCODIGO,
    TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    TBPDESC AS DESCRICAO1,
    TBPDESC2 AS DESCRICAO2,
    TBPDTINICIO AS DATA_INICIO,
    TBPDTVALIDADE AS DATA_VALIDADE,
    TBPDTCADASTRO AS DATA_CADASTRO
FROM CTPTBP
WHERE CLICODIGO = ?
  AND TPCODIGO = ?
  AND TBPCODIGO = ?;
```

---

### 2. Listar Tabelas de Preço de um Cliente por Tipo de Pedido

```sql
SELECT
    TBPCODIGO,
    TBPDESCFECH AS DESCRICAO_FECHAMENTO,
    TBPDTINICIO AS DATA_INICIO,
    TBPDTVALIDADE AS DATA_VALIDADE
FROM CTPTBP
WHERE CLICODIGO = ?
  AND TPCODIGO = ?
ORDER BY TBPDTINICIO DESC;
```

---

### 3. Análise de Tabelas de Preço Válidas

```sql
SELECT
    ctp.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ctp.TPCODIGO,
    tp.TPDESCRICAO AS TIPO_PEDIDO,
    ctp.TBPCODIGO,
    tb.TBPDESCRICAO AS TABELA_PRECO,
    ctp.TBPDTINICIO AS DATA_INICIO,
    ctp.TBPDTVALIDADE AS DATA_VALIDADE
FROM CTPTBP ctp
INNER JOIN CLIEN cl ON cl.CLICODIGO = ctp.CLICODIGO
INNER JOIN TPPEDID tp ON tp.TPCODIGO = ctp.TPCODIGO
INNER JOIN TABPRECO tb ON tb.TBPCODIGO = ctp.TBPCODIGO
WHERE ctp.TBPDTINICIO <= CURRENT_DATE
  AND (ctp.TBPDTVALIDADE IS NULL OR ctp.TBPDTVALIDADE >= CURRENT_DATE)
ORDER BY ctp.CLICODIGO, ctp.TPCODIGO, ctp.TBPDTINICIO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CTPTBP** | 7.909 | 1:1 | **TABELA PRINCIPAL** |
| CLITPPED | 4.439 | 1:1.78 | Configurações cliente x tipo de pedido |
| TABPRECO | ~? | ?:1 | Tabelas de preço |

**Interpretação:**
- **7.909 configurações** cadastradas no sistema
- **Média de ~1.78 tabelas de preço por configuração cliente x tipo de pedido**

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente e tipo de pedido
CREATE INDEX IDX_CTPTBP_CLI_TIPO ON CTPTBP(CLICODIGO, TPCODIGO);

-- Índice 2: Busca por tabela de preço
CREATE INDEX IDX_CTPTBP_TABELA_PRECO ON CTPTBP(TBPCODIGO);

-- Índice 3: Busca por período de validade
CREATE INDEX IDX_CTPTBP_VALIDADE ON CTPTBP(TBPDTINICIO, TBPDTVALIDADE)
    WHERE TBPDTVALIDADE IS NOT NULL;
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

final class FirebirdCtptbp extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTPTBP';
    
    protected $primaryKey = ['CLICODIGO', 'TPCODIGO', 'TBPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'TPCODIGO' => 'integer',
        'TBPCODIGO' => 'integer',
        'TBPDESCFECH' => 'string',
        'TBPDESC' => 'decimal:4',
        'TBPDESC2' => 'decimal:4',
        'TBPDTINICIO' => 'date',
        'TBPDTVALIDADE' => 'date',
        'TBPDTCADASTRO' => 'datetime',
    ];

    public function clienteTipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdClitpped::class, ['CLICODIGO', 'TPCODIGO'], 
                               ['CLICODIGO', 'TPCODIGO']);
    }

    public function tabelaPreco(): BelongsTo
    {
        return $this->belongsTo(FirebirdTabpreco::class, 'TBPCODIGO', 'TBPCODIGO');
    }

    public function estaValida(): bool
    {
        if ($this->TBPDTINICIO > now()->toDateString()) {
            return false;
        }
        
        if ($this->TBPDTVALIDADE && $this->TBPDTVALIDADE < now()->toDateString()) {
            return false;
        }
        
        return true;
    }

    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    public function scopePorTipoPedido($query, int $tipoPedidoCodigo)
    {
        return $query->where('TPCODIGO', $tipoPedidoCodigo);
    }

    public function scopeValidas($query)
    {
        return $query->where('TBPDTINICIO', '<=', now()->toDateString())
                     ->where(function($q) {
                         $q->whereNull('TBPDTVALIDADE')
                           ->orWhere('TBPDTVALIDADE', '>=', now()->toDateString());
                     });
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

