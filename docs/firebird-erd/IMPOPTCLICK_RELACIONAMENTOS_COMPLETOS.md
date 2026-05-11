# IMPOPTCLICK - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPOPTCLICK (Importação OptClick)
- **Total de Registros**: 177.890
- **Total de Colunas**: 8
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (IMPOPTCLICKERRO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPOPTCLICK** é uma tabela que armazena registros de importação de pedidos do sistema OptClick. Com **177.890 registros**, representa um extenso histórico de importações de pedidos, incluindo arquivos XML processados e seus status.

Esta tabela funciona como **log de importações OptClick** e permite:
- Registrar todas as importações de pedidos do OptClick
- Armazenar arquivos XML importados
- Rastrear status de processamento de importações
- Vincular importações a pedidos do sistema
- Facilitar auditoria de importações
- Manter histórico completo de integração

Cada registro representa uma importação específica, contendo:
- ID da importação (ID)
- Número do pedido OptClick (NRPEDOPTCLICK)
- Nome do arquivo importado (NOMEARQUIVO)
- Data/hora de leitura (DTHOTALEITURA)
- ID do pedido no sistema (ID_PEDIDO) - lógica → PEDID
- Status da importação (STATUS)
- Conteúdo XML (XML)
- Empresa (EMPRESA) - lógica → EMPRESA

O sistema utiliza esta tabela para manter histórico completo de importações do OptClick, sendo referenciada por IMPOPTCLICKERRO para registrar erros ocorridos durante o processamento.

**Observação Importante:** IMPOPTCLICK é uma tabela de log muito grande (177.890 registros), indicando uso extensivo desta funcionalidade de integração. Possui relacionamento lógico com PEDID através de ID_PEDIDO e relacionamento direto com IMPOPTCLICKERRO para registro de erros.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | BIGINT | ✓ | ID da importação OptClick (PK) |

### Informações da Importação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NRPEDOPTCLICK** | VARCHAR(37) | | Número do pedido no OptClick |
| **NOMEARQUIVO** | VARCHAR(37) | | Nome do arquivo importado |
| **DTHOTALEITURA** | TIMESTAMP | | Data/hora de leitura do arquivo |
| **ID_PEDIDO** | INTEGER | | ID do pedido no sistema (lógica → PEDID) |
| **STATUS** | VARCHAR(37) | | Status da importação |
| **XML** | VARCHAR(261) | | Conteúdo XML do arquivo importado |
| **EMPRESA** | INTEGER | | Código da empresa (lógica → EMPRESA) |

**Primary Key:** ID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPOPTCLICK Referencia (0 FKs):

Nenhuma foreign key direta.

---

### IMPOPTCLICK é Referenciada Por (1 tabela):

#### 1. IMPOPTCLICKERRO - Erros de Importação OptClick
**Relacionamento:**
```
IMPOPTCLICKERRO.ID → IMPOPTCLICK.ID (N:1)
Constraint: FK_IMPOPTCLICK
```

**Descrição**: Cada erro de importação está vinculado a uma importação específica.

**Informações da Tabela IMPOPTCLICKERRO:**
- **Total:** 61.008 erros
- **PK:** SEQ
- **Colunas:** 7 campos

**Uso:** Vincular erros de processamento a importações específicas para análise e correção.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID_PEDIDO → PEDID → Outras Operações de Pedidos

**Fluxo:** IMPOPTCLICK → PEDID → Operações

**Descrição:** Através do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de importações através de operações de pedidos.

---

### Via EMPRESA → EMPRESA → Outras Operações da Empresa

**Fluxo:** IMPOPTCLICK → EMPRESA → Operações

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de importações através de operações da empresa.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Importação OptClick

**Objetivo:** Obter visão completa de uma importação incluindo erros, pedido e empresa.

**Fluxo:**
```
IMPOPTCLICK (ID, ID_PEDIDO, EMPRESA)
  ↓
IMPOPTCLICKERRO (ID)
  ↓
PEDID (ID_PEDIDO)
  ↓
EMPRESA (EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    imp.ID,
    imp.NRPEDOPTCLICK,
    imp.NOMEARQUIVO,
    imp.DTHOTALEITURA,
    imp.STATUS,
    imp.ID_PEDIDO,
    p.PEDNUMERO AS NUMERO_PEDIDO,
    imp.EMPRESA,
    e.EMPNOMEFANT AS EMPRESA_NOME,
    COUNT(erro.SEQ) AS TOTAL_ERROS
FROM IMPOPTCLICK imp
LEFT JOIN PEDID p ON p.ID_PEDIDO = imp.ID_PEDIDO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = imp.EMPRESA
LEFT JOIN IMPOPTCLICKERRO erro ON erro.ID = imp.ID
WHERE imp.ID = ?
GROUP BY imp.ID, imp.NRPEDOPTCLICK, imp.NOMEARQUIVO, imp.DTHOTALEITURA, 
         imp.STATUS, imp.ID_PEDIDO, p.PEDNUMERO, imp.EMPRESA, e.EMPNOMEFANT;
```

---

### Exemplo 2: Análise de Importações com Erros

**Objetivo:** Identificar importações que possuem erros.

**Query SQL:**
```sql
SELECT
    imp.ID,
    imp.NRPEDOPTCLICK,
    imp.NOMEARQUIVO,
    imp.STATUS,
    COUNT(erro.SEQ) AS TOTAL_ERROS
FROM IMPOPTCLICK imp
INNER JOIN IMPOPTCLICKERRO erro ON erro.ID = imp.ID
GROUP BY imp.ID, imp.NRPEDOPTCLICK, imp.NOMEARQUIVO, imp.STATUS
HAVING COUNT(erro.SEQ) > 0
ORDER BY TOTAL_ERROS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Importação OptClick

**Objetivo:** Obter informações de uma importação específica.

```sql
SELECT
    ID,
    NRPEDOPTCLICK,
    NOMEARQUIVO,
    DTHOTALEITURA,
    ID_PEDIDO,
    STATUS,
    EMPRESA
FROM IMPOPTCLICK
WHERE ID = ?;
```

---

### 2. Listar Importações por Status

**Objetivo:** Obter importações filtradas por status.

```sql
SELECT
    ID,
    NRPEDOPTCLICK,
    NOMEARQUIVO,
    DTHOTALEITURA,
    STATUS
FROM IMPOPTCLICK
WHERE STATUS = ?
ORDER BY DTHOTALEITURA DESC;
```

---

### 3. Análise de Importações por Período

**Objetivo:** Identificar distribuição de importações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DTHOTALEITURA) AS ANO,
    EXTRACT(MONTH FROM DTHOTALEITURA) AS MES,
    COUNT(*) AS TOTAL_IMPORTACOES,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS,
    COUNT(DISTINCT EMPRESA) AS TOTAL_EMPRESAS
FROM IMPOPTCLICK
WHERE DTHOTALEITURA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DTHOTALEITURA), EXTRACT(MONTH FROM DTHOTALEITURA)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Relatório Completo de Importações OptClick

**Objetivo:** Analisar distribuição completa de importações no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_IMPORTACOES,
    COUNT(DISTINCT ID_PEDIDO) AS TOTAL_PEDIDOS_IMPORTADOS,
    COUNT(DISTINCT EMPRESA) AS TOTAL_EMPRESAS,
    COUNT(DISTINCT STATUS) AS TOTAL_STATUS_DIFERENTES,
    MIN(DTHOTALEITURA) AS PRIMEIRA_IMPORTACAO,
    MAX(DTHOTALEITURA) AS ULTIMA_IMPORTACAO,
    (SELECT COUNT(*) FROM IMPOPTCLICKERRO) AS TOTAL_ERROS
FROM IMPOPTCLICK;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPOPTCLICK | Tipo |
|--------|-----------|-------------------------|------|
| **IMPOPTCLICK** | 177.890 | 1:1 | **TABELA PRINCIPAL** |
| IMPOPTCLICKERRO | 61.008 | 1:0.34 | Erros (média de 0.34 erros por importação) |
| PEDID | 3.099.176 | 1:0.06 | Pedidos (média de 0.06 importações por pedido) |

**Interpretação:**
- **177.890 importações** registradas no sistema
- **Média de 0.34 erros por importação** - indica que aproximadamente 34% das importações possuem erros
- **Média de 0.06 importações por pedido** - indica que nem todos os pedidos são importados do OptClick

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por pedido (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_IMPOPTCLICK_PEDIDO ON IMPOPTCLICK(ID_PEDIDO)
    WHERE ID_PEDIDO IS NOT NULL;

-- Índice 2: Busca por data/hora (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICK_DTHORA ON IMPOPTCLICK(DTHOTALEITURA)
    WHERE DTHOTALEITURA IS NOT NULL;

-- Índice 3: Busca por status (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICK_STATUS ON IMPOPTCLICK(STATUS)
    WHERE STATUS IS NOT NULL;

-- Índice 4: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICK_EMPRESA ON IMPOPTCLICK(EMPRESA)
    WHERE EMPRESA IS NOT NULL;

-- Índice 5: Busca por número pedido OptClick (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICK_NRPEDOPTCLICK ON IMPOPTCLICK(NRPEDOPTCLICK)
    WHERE NRPEDOPTCLICK IS NOT NULL;
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
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class FirebirdImpoptclick extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPOPTCLICK';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'NRPEDOPTCLICK' => 'string',
        'NOMEARQUIVO' => 'string',
        'DTHOTALEITURA' => 'datetime',
        'ID_PEDIDO' => 'integer',
        'STATUS' => 'string',
        'XML' => 'string',
        'EMPRESA' => 'integer',
    ];

    // Relacionamento com IMPOPTCLICKERRO
    public function erros(): HasMany
    {
        return $this->hasMany(FirebirdImpoptclickerro::class, 'ID', 'ID');
    }

    // Relacionamento lógico com PEDID
    public function pedido()
    {
        return $this->belongsTo(FirebirdPedid::class, 'ID_PEDIDO', 'ID_PEDIDO');
    }

    // Relacionamento lógico com EMPRESA
    public function empresa()
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPRESA', 'EMPCODIGO');
    }

    public function scopePorPedido($query, int $idPedido)
    {
        return $query->where('ID_PEDIDO', $idPedido);
    }

    public function scopePorStatus($query, string $status)
    {
        return $query->where('STATUS', $status);
    }

    public function scopePorEmpresa($query, int $empresa)
    {
        return $query->where('EMPRESA', $empresa);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DTHOTALEITURA', [$dataInicial, $dataFinal]);
    }

    public function scopeComErros($query)
    {
        return $query->has('erros');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

