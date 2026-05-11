# CTPPRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTPPRO (Configurações de Produtos por Tipo de Pedido)
- **Total de Registros**: 105
- **Total de Colunas**: 9
- **Chave Primária**: Composta (CLICODIGO, TPCODIGO, PROCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTPPRO** é uma tabela que armazena configurações específicas de produtos por cliente e tipo de pedido, estendendo CLITPPED com configurações detalhadas de produtos. Com **105 registros**, representa configurações personalizadas de produtos para clientes específicos em tipos de pedido específicos, incluindo índices e preços de venda customizados.

Esta tabela funciona como **configurador de produtos por tipo de pedido** e permite:
- Definir configurações de produtos personalizadas por cliente e tipo de pedido
- Armazenar índices específicos para cada produto
- Configurar preços de venda customizados por cliente e tipo de pedido
- Controlar múltiplos índices e preços para cada produto (índice 1, índice 2, preço 1, preço 2)
- Rastrear data de cadastro de cada configuração
- Suportar descrição de fechamento específica

Cada registro representa uma configuração específica de um produto (PROCODIGO) para um cliente específico (CLICODIGO) em um tipo de pedido específico (TPCODIGO), contendo:
- Identificação do cliente (CLICODIGO)
- Tipo de pedido (TPCODIGO)
- Produto (PROCODIGO)
- Índices do produto (CPINDICE, CPINDICE2)
- Preços de venda do produto (CPPCOVENDA, CPPCOVENDA2)
- Descrição de fechamento (CPDESCFECH)
- Data de cadastro da configuração (CPDTCADASTRO)

O sistema utiliza esta tabela para personalizar configurações de produtos e precificação por cliente e tipo de pedido, permitindo que diferentes clientes tenham diferentes configurações para os mesmos produtos em diferentes tipos de pedido.

**Observação Importante:** CTPPRO estende CLITPPED com configurações específicas de produtos, permitindo que cada cliente tenha suas próprias configurações de produtos com índices e preços específicos por tipo de pedido.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑 🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLITPPED) |
| **TPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código do tipo de pedido (PK + FK → CLITPPED) |
| **PROCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código do produto (PK + FK → PRODU) |

### Informações do Produto
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPINDICE** | NUMERIC(16,4) | | Índice 1 do produto |
| **CPINDICE2** | NUMERIC(16,4) | | Índice 2 do produto |
| **CPPCOVENDA** | NUMERIC(16,4) | | Preço de venda 1 do produto |
| **CPPCOVENDA2** | NUMERIC(16,4) | | Preço de venda 2 do produto |

### Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CPDESCFECH** | VARCHAR(14) | ✓ | Descrição de fechamento |
| **CPDTCADASTRO** | TIMESTAMP | | Data de cadastro da configuração |

**Primary Key:** (CLICODIGO, TPCODIGO, PROCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTPPRO Referencia (3 FKs):

#### 1. CLITPPED - Configurações Cliente x Tipo de Pedido
**Relacionamento:**
```
CTPPRO.CLICODIGO, CTPPRO.TPCODIGO → CLITPPED.CLICODIGO, CLITPPED.TPCODIGO (N:1)
Constraint: CLITPPED_CTPPRO
```

**Descrição**: Cada configuração está vinculada a uma configuração cliente x tipo de pedido específica.

---

#### 2. PRODU - Produtos
**Relacionamento:**
```
CTPPRO.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: PRODU_CTPPRO
```

**Descrição**: Cada configuração está vinculada a um produto específico.

---

### CTPPRO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTPPRO diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Produto

```sql
SELECT
    CLICODIGO,
    TPCODIGO,
    PROCODIGO,
    CPINDICE AS INDICE1,
    CPINDICE2 AS INDICE2,
    CPPCOVENDA AS PRECO1,
    CPPCOVENDA2 AS PRECO2,
    CPDESCFECH AS DESCRICAO_FECHAMENTO,
    CPDTCADASTRO AS DATA_CADASTRO
FROM CTPPRO
WHERE CLICODIGO = ?
  AND TPCODIGO = ?
  AND PROCODIGO = ?;
```

---

### 2. Listar Configurações de um Cliente

```sql
SELECT
    TPCODIGO AS TIPO_PEDIDO,
    PROCODIGO,
    CPINDICE AS INDICE1,
    CPPCOVENDA AS PRECO1,
    CPDESCFECH AS DESCRICAO_FECHAMENTO
FROM CTPPRO
WHERE CLICODIGO = ?
ORDER BY TPCODIGO, PROCODIGO;
```

---

### 3. Análise de Configurações por Tipo de Pedido

```sql
SELECT
    TPCODIGO AS TIPO_PEDIDO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS
FROM CTPPRO
GROUP BY TPCODIGO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CTPPRO** | 105 | 1:1 | **TABELA PRINCIPAL** |
| CLITPPED | 4.439 | 1:0.02 | Configurações cliente x tipo de pedido |
| PRODU | ~178.187 | 1:0.0006 | Produtos |

**Interpretação:**
- **105 configurações** cadastradas no sistema
- **Uso seletivo** - tabela pequena indica uso específico desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente e tipo de pedido
CREATE INDEX IDX_CTPPRO_CLI_TIPO ON CTPPRO(CLICODIGO, TPCODIGO);

-- Índice 2: Busca por produto
CREATE INDEX IDX_CTPPRO_PRODUTO ON CTPPRO(PROCODIGO);
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

final class FirebirdCtppro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTPPRO';
    
    protected $primaryKey = ['CLICODIGO', 'TPCODIGO', 'PROCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'TPCODIGO' => 'integer',
        'PROCODIGO' => 'string',
        'CPINDICE' => 'decimal:4',
        'CPINDICE2' => 'decimal:4',
        'CPPCOVENDA' => 'decimal:4',
        'CPPCOVENDA2' => 'decimal:4',
        'CPDESCFECH' => 'string',
        'CPDTCADASTRO' => 'datetime',
    ];

    public function clienteTipoPedido(): BelongsTo
    {
        return $this->belongsTo(FirebirdClitpped::class, ['CLICODIGO', 'TPCODIGO'], 
                               ['CLICODIGO', 'TPCODIGO']);
    }

    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    public function scopePorTipoPedido($query, int $tipoPedidoCodigo)
    {
        return $query->where('TPCODIGO', $tipoPedidoCodigo);
    }

    public function scopePorProduto($query, string $produtoCodigo)
    {
        return $query->where('PROCODIGO', $produtoCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

