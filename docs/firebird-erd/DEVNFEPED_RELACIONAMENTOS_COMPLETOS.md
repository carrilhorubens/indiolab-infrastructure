# DEVNFEPED - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DEVNFEPED (Devolução de Nota Fiscal Eletrônica x Pedido)
- **Total de Registros**: 10.065
- **Total de Colunas**: 5
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 2 (IDX_DEVNFEPED_ID_PEDIDO, IDX_DEVNFEPED_NFECODIGO)
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**DEVNFEPED** é uma tabela que relaciona devoluções de notas fiscais eletrônicas com pedidos. Com **10.065 registros**, representa registros de devoluções de NFe vinculadas a pedidos específicos, permitindo rastreamento de devoluções e controle fiscal.

Esta tabela funciona como **relacionamento de devolução de NFe x Pedido** e permite:
- Rastrear devoluções de notas fiscais eletrônicas por pedido
- Manter histórico de devoluções de NFe
- Controlar quais pedidos tiveram devoluções de NFe
- Suportar controle fiscal de devoluções
- Facilitar relatórios de devoluções

Cada registro representa uma devolução de NFe relacionada a um pedido específico, contendo:
- Identificador único do registro (ID)
- Sequencial da devolução (NSEQ)
- Identificador do pedido relacionado (ID_PEDIDO) - lógica → PEDID
- Código da nota fiscal eletrônica (NFECODIGO) - lógica → NFE
- Código da empresa (EMPCODIGO) - lógica → EMPRESA

O sistema utiliza esta tabela para controlar devoluções de notas fiscais eletrônicas relacionadas a pedidos, permitindo rastreamento completo de devoluções e controle fiscal.

**Observação Importante:** DEVNFEPED é uma tabela de relacionamento que conecta devoluções de NFe com pedidos. Com 10.065 registros e índices em ID_PEDIDO e NFECODIGO, indica uso extensivo desta funcionalidade. Não possui foreign keys diretas, mas possui relacionamentos lógicos com PEDID, NFE e EMPRESA.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | Identificador único do registro (PK) |

### Relacionamentos Lógicos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_PEDIDO** | INTEGER | | Identificador do pedido relacionado (lógica → PEDID) |
| **NFECODIGO** | INTEGER | | Código da nota fiscal eletrônica (lógica → NFE) |
| **EMPCODIGO** | SMALLINT | ✓ | Código da empresa (lógica → EMPRESA) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NSEQ** | NUMERIC(16,4) | ✓ | Sequencial da devolução |

**Primary Key:** ID

**Índices:**
- `IDX_DEVNFEPED_ID_PEDIDO` em `ID_PEDIDO`
- `IDX_DEVNFEPED_NFECODIGO` em `NFECODIGO`

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DEVNFEPED Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DEVNFEPED é Referenciada Por (0 tabelas):

Nenhuma tabela referencia DEVNFEPED diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDID → Outras Operações do Pedido

**Fluxo:** DEVNFEPED → PEDID → Operações

**Descrição:** Através do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por pedido.

---

### Via NFECODIGO → NFE → Outras Operações da NFe

**Fluxo:** DEVNFEPED → NFE → Operações

**Descrição:** Através da nota fiscal eletrônica, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por NFe.

---

### Via EMPCODIGO → EMPRESA → Outras Operações da Empresa

**Fluxo:** DEVNFEPED → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de devoluções por empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Devolução de NFe

**Objetivo:** Obter visão completa de uma devolução incluindo informações do pedido e da NFe.

**Fluxo:**
```
DEVNFEPED (ID_PEDIDO, NFECODIGO, EMPCODIGO)
  ↓
PEDID (ID_PEDIDO)
  ↓
CLIEN (CLICODIGO)
  ↓
NFE (NFECODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.NSEQ AS SEQUENCIAL_DEVOLUCAO,
    dev.ID_PEDIDO,
    p.PEDCODIGO,
    p.PEDDATA AS DATA_PEDIDO,
    c.CLINOMEFANT AS CLIENTE,
    dev.NFECODIGO,
    nfe.NFENUMERO AS NUMERO_NFE,
    nfe.NFEDATAEMISSAO AS DATA_EMISSAO_NFE,
    dev.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA
FROM DEVNFEPED dev
LEFT JOIN PEDID p ON p.ID_PEDIDO = dev.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
LEFT JOIN NFE nfe ON nfe.NFECODIGO = dev.NFECODIGO
                 AND nfe.EMPCODIGO = dev.EMPCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dev.EMPCODIGO
WHERE dev.ID = ?;
```

---

### Exemplo 2: Análise de Devoluções por Pedido

**Objetivo:** Identificar todas as devoluções de NFe relacionadas a um pedido específico.

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.NSEQ AS SEQUENCIAL_DEVOLUCAO,
    dev.NFECODIGO,
    nfe.NFENUMERO AS NUMERO_NFE,
    nfe.NFEDATAEMISSAO AS DATA_EMISSAO_NFE,
    COUNT(*) OVER (PARTITION BY dev.ID_PEDIDO) AS TOTAL_DEVOLUCOES_PEDIDO
FROM DEVNFEPED dev
LEFT JOIN NFE nfe ON nfe.NFECODIGO = dev.NFECODIGO
                 AND nfe.EMPCODIGO = dev.EMPCODIGO
WHERE dev.ID_PEDIDO = ?
ORDER BY dev.NSEQ DESC;
```

---

### Exemplo 3: Análise de Devoluções por Empresa

**Objetivo:** Identificar distribuição de devoluções de NFe por empresa.

**Query SQL:**
```sql
SELECT
    dev.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(*) AS TOTAL_DEVOLUCOES,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT dev.NFECODIGO) AS TOTAL_NFES_AFETADAS
FROM DEVNFEPED dev
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dev.EMPCODIGO
WHERE dev.EMPCODIGO IS NOT NULL
GROUP BY dev.EMPCODIGO, emp.EMPNOMEFANT
ORDER BY TOTAL_DEVOLUCOES DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Devolução de NFe

**Objetivo:** Obter informações de uma devolução específica.

```sql
SELECT
    ID,
    NSEQ AS SEQUENCIAL_DEVOLUCAO,
    ID_PEDIDO,
    NFECODIGO,
    EMPCODIGO
FROM DEVNFEPED
WHERE ID = ?;
```

---

### 2. Listar Devoluções de um Pedido

**Objetivo:** Obter todas as devoluções de NFe relacionadas a um pedido específico.

```sql
SELECT
    ID,
    NSEQ AS SEQUENCIAL_DEVOLUCAO,
    NFECODIGO,
    EMPCODIGO
FROM DEVNFEPED
WHERE ID_PEDIDO = ?
ORDER BY NSEQ DESC;
```

---

### 3. Análise de Devoluções por Cliente

**Objetivo:** Identificar distribuição de devoluções de NFe por cliente.

**Query SQL:**
```sql
SELECT
    c.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    COUNT(*) AS TOTAL_DEVOLUCOES,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DEVNFEPED dev
LEFT JOIN PEDID p ON p.ID_PEDIDO = dev.ID_PEDIDO
LEFT JOIN CLIEN c ON c.CLICODIGO = p.CLICODIGO
WHERE c.CLICODIGO IS NOT NULL
GROUP BY c.CLICODIGO, c.CLINOMEFANT
ORDER BY TOTAL_DEVOLUCOES DESC;
```

---

### 4. Análise de Devoluções por Período

**Objetivo:** Identificar distribuição de devoluções ao longo do tempo através dos pedidos.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM p.PEDDATA) AS ANO,
    EXTRACT(MONTH FROM p.PEDDATA) AS MES,
    COUNT(*) AS TOTAL_DEVOLUCOES,
    COUNT(DISTINCT dev.ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS
FROM DEVNFEPED dev
LEFT JOIN PEDID p ON p.ID_PEDIDO = dev.ID_PEDIDO
WHERE p.PEDDATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM p.PEDDATA), EXTRACT(MONTH FROM p.PEDDATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 5. Análise de Devoluções Órfãs

**Objetivo:** Identificar devoluções sem pedido ou NFe válidos.

**Query SQL:**
```sql
SELECT
    dev.ID,
    dev.ID_PEDIDO,
    dev.NFECODIGO,
    dev.EMPCODIGO,
    CASE
        WHEN p.ID_PEDIDO IS NULL THEN 'SEM_PEDIDO'
        WHEN nfe.NFECODIGO IS NULL THEN 'SEM_NFE'
        ELSE 'OK'
    END AS STATUS
FROM DEVNFEPED dev
LEFT JOIN PEDID p ON p.ID_PEDIDO = dev.ID_PEDIDO
LEFT JOIN NFE nfe ON nfe.NFECODIGO = dev.NFECODIGO
                 AND nfe.EMPCODIGO = dev.EMPCODIGO
WHERE p.ID_PEDIDO IS NULL OR nfe.NFECODIGO IS NULL
ORDER BY dev.ID;
```

---

### 6. Relatório Completo de Devoluções

**Objetivo:** Analisar distribuição completa de devoluções de NFe no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_DEVOLUCOES,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_AFETADOS,
    COUNT(DISTINCT NFECODIGO) AS TOTAL_NFES_AFETADAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS_AFETADAS,
    COUNT(CASE WHEN ID_PEDIDO IS NULL THEN 1 END) AS DEVOLUCOES_SEM_PEDIDO,
    COUNT(CASE WHEN NFECODIGO IS NULL THEN 1 END) AS DEVOLUCOES_SEM_NFE
FROM DEVNFEPED;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DEVNFEPED | Tipo |
|--------|-----------|------------------------|------|
| **DEVNFEPED** | 10.065 | 1:1 | **TABELA PRINCIPAL** |
| PEDID | ~3.099.176 | 1:308 | Pedidos (média de 1 devolução a cada 308 pedidos) |
| NFE | ~? | ?:1 | Notas fiscais eletrônicas |

**Interpretação:**
- **10.065 devoluções de NFe** registradas no sistema
- **Média de 1 devolução a cada 308 pedidos** - indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Existentes

1. **IDX_DEVNFEPED_ID_PEDIDO** em `ID_PEDIDO` - Otimiza consultas por pedido
2. **IDX_DEVNFEPED_NFECODIGO** em `NFECODIGO` - Otimiza consultas por NFe

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_DEVNFEPED_EMP ON DEVNFEPED(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 2: Busca combinada pedido + empresa (consultas frequentes)
CREATE INDEX IDX_DEVNFEPED_PEDIDO_EMP ON DEVNFEPED(ID_PEDIDO, EMPCODIGO)
    WHERE ID_PEDIDO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdDevnfeped extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DEVNFEPED';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'NSEQ' => 'decimal:4',
        'ID_PEDIDO' => 'integer',
        'NFECODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
    ];

    // Relacionamento lógico com PEDID
    public function pedido()
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento lógico com NFE
    public function notaFiscalEletronica()
    {
        return $this->belongsTo(FirebirdNfe::class, 'NFECODIGO', 'NFECODIGO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    public function scopePorPedido($query, int $pedidoCodigo)
    {
        return $query->where('ID_PEDIDO', $pedidoCodigo);
    }

    public function scopePorNFe($query, int $nfeCodigo)
    {
        return $query->where('NFECODIGO', $nfeCodigo);
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

