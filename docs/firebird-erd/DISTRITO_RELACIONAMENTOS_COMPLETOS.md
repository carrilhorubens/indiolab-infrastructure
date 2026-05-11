# DISTRITO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DISTRITO (Distritos)
- **Total de Registros**: 7
- **Total de Colunas**: 2
- **Chave Primária**: DISCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (ENDCLI)
- **Banco de Dados**: Firebird

## 📝 Descrição

**DISTRITO** é uma tabela mestre que armazena distritos utilizados no sistema. Com apenas **7 registros**, representa um catálogo pequeno de distritos utilizados principalmente em endereços de clientes.

Esta tabela funciona como **catálogo de distritos** e permite:
- Identificar distritos disponíveis no sistema
- Armazenar descrições de cada distrito
- Vincular distritos a endereços de clientes
- Suportar localização geográfica mais detalhada
- Facilitar organização de endereços por distrito

Cada registro representa um distrito específico, contendo:
- Código do distrito (DISCODIGO)
- Descrição do distrito (DISDESCRICAO)

O sistema utiliza esta tabela para fornecer informações de distrito em endereços de clientes, permitindo localização geográfica mais precisa.

**Observação Importante:** DISTRITO é uma tabela mestre pequena (7 registros) que serve como catálogo de distritos. É referenciada por ENDCLI (endereços de clientes), indicando uso em cadastros de endereços.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DISCODIGO** 🔑 | SMALLINT | ✓ | Código do distrito (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DISDESCRICAO** | VARCHAR(37) | ✓ | Descrição do distrito |

**Primary Key:** DISCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DISTRITO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DISTRITO é Referenciada Por (1 tabela):

#### 1. ENDCLI - Endereços de Clientes
**Relacionamento:**
```
ENDCLI.DISCODIGO → DISTRITO.DISCODIGO (N:1)
Constraint: DISTRITO_ENDCLI
```

**Descrição**: Cada endereço de cliente pode estar vinculado a um distrito específico.

**Informações da Tabela ENDCLI:**
- **Total:** ~9.272 endereços
- **PK:** (CLICODIGO, ENDCODIGO)
- **Colunas:** Múltiplos campos

**Uso:** Identificar o distrito de cada endereço de cliente, permitindo localização geográfica mais precisa.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ENDCLI → CLIEN → Outras Operações do Cliente

**Fluxo:** DISTRITO → ENDCLI → CLIEN → Operações

**Descrição:** Através dos endereços de clientes, é possível identificar clientes relacionados e suas operações.

**Uso:** Análise de clientes por distrito.

---

### Via ENDCLI → CIDADE → Outras Operações Geográficas

**Fluxo:** DISTRITO → ENDCLI → CIDADE → Operações

**Descrição:** Através dos endereços de clientes e cidades, é possível identificar outras operações geográficas relacionadas.

**Uso:** Análise geográfica por distrito.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Distrito

**Objetivo:** Obter visão completa de um distrito incluindo endereços e clientes relacionados.

**Fluxo:**
```
DISTRITO (DISCODIGO)
  ↓
ENDCLI (DISCODIGO, CLICODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
CIDADE (CIDCODIGO)
```

**Query SQL:**
```sql
SELECT
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO,
    COUNT(DISTINCT e.CLICODIGO) AS TOTAL_CLIENTES,
    COUNT(*) AS TOTAL_ENDERECOS,
    COUNT(DISTINCT e.CIDCODIGO) AS TOTAL_CIDADES
FROM DISTRITO d
LEFT JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
LEFT JOIN CLIEN c ON c.CLICODIGO = e.CLICODIGO
LEFT JOIN CIDADE ci ON ci.CIDCODIGO = e.CIDCODIGO
WHERE d.DISCODIGO = ?
GROUP BY d.DISCODIGO, d.DISDESCRICAO;
```

---

### Exemplo 2: Análise de Distritos por Cidade

**Objetivo:** Identificar distribuição de distritos por cidade.

**Query SQL:**
```sql
SELECT
    ci.CIDCODIGO,
    ci.CIDNOME AS CIDADE,
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO,
    COUNT(*) AS TOTAL_ENDERECOS
FROM DISTRITO d
INNER JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
LEFT JOIN CIDADE ci ON ci.CIDCODIGO = e.CIDCODIGO
WHERE ci.CIDCODIGO IS NOT NULL
GROUP BY ci.CIDCODIGO, ci.CIDNOME, d.DISCODIGO, d.DISDESCRICAO
ORDER BY ci.CIDNOME, d.DISDESCRICAO;
```

---

### Exemplo 3: Análise de Distritos por Estado

**Objetivo:** Identificar distribuição de distritos por estado através das cidades.

**Query SQL:**
```sql
SELECT
    uf.UFCODIGO,
    uf.UFNOME AS ESTADO,
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO,
    COUNT(*) AS TOTAL_ENDERECOS
FROM DISTRITO d
INNER JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
LEFT JOIN CIDADE ci ON ci.CIDCODIGO = e.CIDCODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = ci.CIDUF
WHERE uf.UFCODIGO IS NOT NULL
GROUP BY uf.UFCODIGO, uf.UFNOME, d.DISCODIGO, d.DISDESCRICAO
ORDER BY uf.UFNOME, d.DISDESCRICAO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Distrito

**Objetivo:** Obter informações de um distrito específico.

```sql
SELECT
    DISCODIGO,
    DISDESCRICAO AS DISTRITO
FROM DISTRITO
WHERE DISCODIGO = ?;
```

---

### 2. Listar Todos os Distritos

**Objetivo:** Obter catálogo completo de distritos.

```sql
SELECT
    DISCODIGO,
    DISDESCRICAO AS DISTRITO
FROM DISTRITO
ORDER BY DISDESCRICAO;
```

---

### 3. Análise de Distritos com Endereços

**Objetivo:** Identificar distritos e seus endereços relacionados.

**Query SQL:**
```sql
SELECT
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO,
    COUNT(*) AS TOTAL_ENDERECOS,
    COUNT(DISTINCT e.CLICODIGO) AS TOTAL_CLIENTES
FROM DISTRITO d
LEFT JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
GROUP BY d.DISCODIGO, d.DISDESCRICAO
ORDER BY TOTAL_ENDERECOS DESC;
```

---

### 4. Análise de Distritos com Clientes

**Objetivo:** Identificar distritos e seus clientes relacionados.

**Query SQL:**
```sql
SELECT
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO,
    c.CLICODIGO,
    c.CLINOMEFANT AS CLIENTE,
    e.ENDENDERECO AS ENDERECO
FROM DISTRITO d
INNER JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
LEFT JOIN CLIEN c ON c.CLICODIGO = e.CLICODIGO
ORDER BY d.DISDESCRICAO, c.CLINOMEFANT;
```

---

### 5. Análise de Distritos Não Utilizados

**Objetivo:** Identificar distritos que não possuem endereços vinculados.

**Query SQL:**
```sql
SELECT
    d.DISCODIGO,
    d.DISDESCRICAO AS DISTRITO
FROM DISTRITO d
LEFT JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO
WHERE e.DISCODIGO IS NULL
ORDER BY d.DISDESCRICAO;
```

---

### 6. Relatório Completo de Distritos

**Objetivo:** Analisar distribuição completa de distritos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_DISTRITOS,
    COUNT(CASE WHEN e.DISCODIGO IS NOT NULL THEN 1 END) AS DISTRITOS_COM_ENDERECOS,
    COUNT(CASE WHEN e.DISCODIGO IS NULL THEN 1 END) AS DISTRITOS_SEM_ENDERECOS,
    (SELECT COUNT(*) FROM ENDCLI WHERE DISCODIGO IS NOT NULL) AS TOTAL_ENDERECOS_COM_DISTRITO
FROM DISTRITO d
LEFT JOIN ENDCLI e ON e.DISCODIGO = d.DISCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DISTRITO | Tipo |
|--------|-----------|----------------------|------|
| **DISTRITO** | 7 | 1:1 | **TABELA PRINCIPAL** |
| ENDCLI | ~9.272 | ~1.324:1 | Endereços de clientes (média de ~1.324 endereços por distrito) |

**Interpretação:**
- **7 distritos** cadastrados no sistema
- **Média de ~1.324 endereços por distrito** - indica uso extensivo desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_DISTRITO_DESCRICAO ON DISTRITO(DISDESCRICAO);
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

final class FirebirdDistrito extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DISTRITO';
    
    protected $primaryKey = 'DISCODIGO';
    public $incrementing = true;

    protected $casts = [
        'DISCODIGO' => 'integer',
        'DISDESCRICAO' => 'string',
    ];

    // Relacionamento com ENDCLI
    public function enderecosClientes(): HasMany
    {
        return $this->hasMany(FirebirdEndcli::class, 'DISCODIGO', 'DISCODIGO');
    }

    public function scopeComEnderecos($query)
    {
        return $query->whereHas('enderecosClientes');
    }

    public function scopeSemEnderecos($query)
    {
        return $query->whereDoesntHave('enderecosClientes');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

