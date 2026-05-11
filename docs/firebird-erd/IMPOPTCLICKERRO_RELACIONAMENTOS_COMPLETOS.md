# IMPOPTCLICKERRO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPOPTCLICKERRO (Erros de Importação OptClick)
- **Total de Registros**: 61.008
- **Total de Colunas**: 7
- **Chave Primária**: SEQ (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPOPTCLICKERRO** é uma tabela que armazena erros ocorridos durante o processamento de importações do sistema OptClick. Com **61.008 registros**, representa um extenso histórico de erros que permite análise e correção de problemas na importação de pedidos.

Esta tabela funciona como **log de erros de importação OptClick** e permite:
- Registrar todos os erros ocorridos durante importações
- Rastrear origem e tipo de erros
- Armazenar informações detalhadas sobre falhas
- Vincular erros a importações específicas
- Facilitar análise e correção de problemas
- Manter histórico completo de erros

Cada registro representa um erro específico ocorrido durante uma importação, contendo:
- Sequencial do erro (SEQ)
- ID da importação (ID) - FK → IMPOPTCLICK
- Descrição do erro (ERRO)
- Status do erro (STATUS)
- Data/hora do erro (DTHORA)
- Origem do erro (ORIGEM)
- CNPJ do cliente (CNPJCLIENTE)

O sistema utiliza esta tabela para manter histórico completo de erros ocorridos durante importações do OptClick, permitindo análise detalhada e correção de problemas.

**Observação Importante:** IMPOPTCLICKERRO é uma tabela de log de erros muito grande (61.008 registros), indicando uso extensivo desta funcionalidade de registro de erros. Possui relacionamento direto com IMPOPTCLICK para vincular erros a importações específicas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SEQ** 🔑 | BIGINT | ✓ | Sequencial do erro (PK) |

### Relacionamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔗 | BIGINT | ✓ | ID da importação OptClick (FK → IMPOPTCLICK) |

### Informações do Erro
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ERRO** | VARCHAR(37) | | Descrição do erro |
| **STATUS** | VARCHAR(37) | | Status do erro |
| **DTHORA** | TIMESTAMP | | Data/hora do erro |
| **ORIGEM** | VARCHAR(37) | | Origem do erro |
| **CNPJCLIENTE** | VARCHAR(14) | | CNPJ do cliente relacionado ao erro |

**Primary Key:** SEQ

**Foreign Keys:**
- `ID` → `IMPOPTCLICK.ID` (Constraint: FK_IMPOPTCLICK)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPOPTCLICKERRO Referencia (1 FK):

#### 1. IMPOPTCLICK - Importação OptClick
**Relacionamento:**
```
IMPOPTCLICKERRO.ID → IMPOPTCLICK.ID (N:1)
Constraint: FK_IMPOPTCLICK
```

**Descrição**: Cada erro está vinculado a uma importação específica.

**Informações da Tabela IMPOPTCLICK:**
- **Total:** 177.890 importações
- **PK:** ID
- **Colunas:** 8 campos

**Uso:** Identificar a importação que gerou o erro.

---

### IMPOPTCLICKERRO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia IMPOPTCLICKERRO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via IMPOPTCLICK → PEDID → Outras Operações de Pedidos

**Fluxo:** IMPOPTCLICKERRO → IMPOPTCLICK → PEDID → Operações

**Descrição:** Através da importação e do pedido, é possível identificar outras operações relacionadas.

**Uso:** Análise de erros através de operações de pedidos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Erro de Importação

**Objetivo:** Obter visão completa de um erro incluindo informações da importação e pedido.

**Fluxo:**
```
IMPOPTCLICKERRO (SEQ, ID)
  ↓
IMPOPTCLICK (ID, ID_PEDIDO)
  ↓
PEDID (ID_PEDIDO)
```

**Query SQL:**
```sql
SELECT
    erro.SEQ,
    erro.ID,
    imp.NRPEDOPTCLICK,
    imp.NOMEARQUIVO,
    imp.ID_PEDIDO,
    p.PEDNUMERO AS NUMERO_PEDIDO,
    erro.ERRO,
    erro.STATUS,
    erro.DTHORA,
    erro.ORIGEM,
    erro.CNPJCLIENTE
FROM IMPOPTCLICKERRO erro
INNER JOIN IMPOPTCLICK imp ON imp.ID = erro.ID
LEFT JOIN PEDID p ON p.ID_PEDIDO = imp.ID_PEDIDO
WHERE erro.SEQ = ?;
```

---

### Exemplo 2: Análise de Erros por Tipo

**Objetivo:** Identificar distribuição de erros por tipo ou origem.

**Query SQL:**
```sql
SELECT
    ERRO,
    ORIGEM,
    STATUS,
    COUNT(*) AS TOTAL_ERROS,
    COUNT(DISTINCT ID) AS TOTAL_IMPORTACOES_AFETADAS
FROM IMPOPTCLICKERRO
WHERE ERRO IS NOT NULL
GROUP BY ERRO, ORIGEM, STATUS
ORDER BY TOTAL_ERROS DESC;
```

---

### Exemplo 3: Análise de Erros por Importação

**Objetivo:** Identificar importações com mais erros.

**Query SQL:**
```sql
SELECT
    imp.ID,
    imp.NRPEDOPTCLICK,
    imp.NOMEARQUIVO,
    imp.STATUS AS STATUS_IMPORTACAO,
    COUNT(erro.SEQ) AS TOTAL_ERROS
FROM IMPOPTCLICK imp
INNER JOIN IMPOPTCLICKERRO erro ON erro.ID = imp.ID
GROUP BY imp.ID, imp.NRPEDOPTCLICK, imp.NOMEARQUIVO, imp.STATUS
ORDER BY TOTAL_ERROS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Erro de Importação

**Objetivo:** Obter informações de um erro específico.

```sql
SELECT
    SEQ,
    ID,
    ERRO,
    STATUS,
    DTHORA,
    ORIGEM,
    CNPJCLIENTE
FROM IMPOPTCLICKERRO
WHERE SEQ = ?;
```

---

### 2. Listar Erros de uma Importação

**Objetivo:** Obter todos os erros de uma importação específica.

```sql
SELECT
    SEQ,
    ERRO,
    STATUS,
    DTHORA,
    ORIGEM,
    CNPJCLIENTE
FROM IMPOPTCLICKERRO
WHERE ID = ?
ORDER BY DTHORA DESC;
```

---

### 3. Análise de Erros por Período

**Objetivo:** Identificar distribuição de erros ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DTHORA) AS ANO,
    EXTRACT(MONTH FROM DTHORA) AS MES,
    COUNT(*) AS TOTAL_ERROS,
    COUNT(DISTINCT ID) AS TOTAL_IMPORTACOES_AFETADAS
FROM IMPOPTCLICKERRO
WHERE DTHORA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DTHORA), EXTRACT(MONTH FROM DTHORA)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Relatório Completo de Erros de Importação

**Objetivo:** Analisar distribuição completa de erros no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_ERROS,
    COUNT(DISTINCT ID) AS TOTAL_IMPORTACOES_COM_ERRO,
    COUNT(DISTINCT ERRO) AS TOTAL_TIPOS_ERRO_DIFERENTES,
    COUNT(DISTINCT ORIGEM) AS TOTAL_ORIGENS_DIFERENTES,
    MIN(DTHORA) AS PRIMEIRO_ERRO,
    MAX(DTHORA) AS ULTIMO_ERRO
FROM IMPOPTCLICKERRO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPOPTCLICKERRO | Tipo |
|--------|-----------|----------------------------|------|
| **IMPOPTCLICKERRO** | 61.008 | 1:1 | **TABELA PRINCIPAL** |
| IMPOPTCLICK | 177.890 | 1:0.34 | Importações (média de 0.34 erros por importação) |

**Interpretação:**
- **61.008 erros** registrados no sistema
- **Média de 0.34 erros por importação** - indica que aproximadamente 34% das importações possuem erros

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por importação (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_IMPOPTCLICKERRO_IMPORTACAO ON IMPOPTCLICKERRO(ID);

-- Índice 2: Busca por data/hora (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICKERRO_DTHORA ON IMPOPTCLICKERRO(DTHORA)
    WHERE DTHORA IS NOT NULL;

-- Índice 3: Busca por erro (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICKERRO_ERRO ON IMPOPTCLICKERRO(ERRO)
    WHERE ERRO IS NOT NULL;

-- Índice 4: Busca por origem (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICKERRO_ORIGEM ON IMPOPTCLICKERRO(ORIGEM)
    WHERE ORIGEM IS NOT NULL;

-- Índice 5: Busca por status (consultas frequentes)
CREATE INDEX IDX_IMPOPTCLICKERRO_STATUS ON IMPOPTCLICKERRO(STATUS)
    WHERE STATUS IS NOT NULL;
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

final class FirebirdImpoptclickerro extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPOPTCLICKERRO';
    
    protected $primaryKey = 'SEQ';
    public $incrementing = true;

    protected $casts = [
        'SEQ' => 'integer',
        'ID' => 'integer',
        'ERRO' => 'string',
        'STATUS' => 'string',
        'DTHORA' => 'datetime',
        'ORIGEM' => 'string',
        'CNPJCLIENTE' => 'string',
    ];

    // Relacionamento com IMPOPTCLICK
    public function importacao(): BelongsTo
    {
        return $this->belongsTo(FirebirdImpoptclick::class, 'ID', 'ID');
    }

    public function scopePorImportacao($query, int $id)
    {
        return $query->where('ID', $id);
    }

    public function scopePorErro($query, string $erro)
    {
        return $query->where('ERRO', $erro);
    }

    public function scopePorOrigem($query, string $origem)
    {
        return $query->where('ORIGEM', $origem);
    }

    public function scopePorStatus($query, string $status)
    {
        return $query->where('STATUS', $status);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DTHORA', [$dataInicial, $dataFinal]);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

