# LOGCUSTOMEDIO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOGCUSTOMEDIO (Log de Custo Médio)
- **Total de Registros**: 1.562
- **Total de Colunas**: 4
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOGCUSTOMEDIO** é uma tabela que armazena logs de execução de cálculos de custo médio. Com **1.562 registros**, representa um histórico de tentativas de cálculo de custo médio, incluindo status de execução e data de sucesso.

Esta tabela funciona como **log de execução de custo médio** e permite:
- Registrar todas as tentativas de cálculo de custo médio
- Armazenar status de execução
- Rastrear data de execução bem-sucedida
- Facilitar auditoria de cálculos de custo médio
- Manter histórico detalhado de execuções
- Suportar análise de performance de cálculos

Cada registro representa uma tentativa específica de cálculo de custo médio, contendo:
- ID do log (ID)
- Número da tentativa (TENTATIVA)
- Status da execução (STATUS)
- Data de execução bem-sucedida (DTEXECEXITO)

O sistema utiliza esta tabela para manter histórico completo de tentativas de cálculo de custo médio, permitindo auditoria detalhada e análise de performance.

**Observação Importante:** LOGCUSTOMEDIO é uma tabela de log de execução de custo médio. Com 1.562 registros, indica uso moderado desta funcionalidade. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de produtos através do campo ID.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | BIGINT | ✓ | ID do log de custo médio (PK) |

### Informações da Execução
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TENTATIVA** | INTEGER | ✓ | Número da tentativa de cálculo |
| **STATUS** | VARCHAR(14) | | Status da execução |
| **DTEXECEXITO** | TIMESTAMP | | Data de execução bem-sucedida |

**Primary Key:** ID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOGCUSTOMEDIO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOGCUSTOMEDIO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOGCUSTOMEDIO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via ID → Tabelas de Produtos

**Fluxo:** LOGCUSTOMEDIO → PRODU → Operações

**Descrição:** Através do ID, é possível identificar produtos relacionados.

**Uso:** Análise de logs através de operações de produtos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Custo Médio

**Objetivo:** Obter informações de um log específico.

```sql
SELECT
    ID,
    TENTATIVA,
    STATUS,
    DTEXECEXITO
FROM LOGCUSTOMEDIO
WHERE ID = ?;
```

---

### 2. Listar Tentativas de um Produto

**Objetivo:** Obter todas as tentativas de cálculo de custo médio de um produto específico.

```sql
SELECT
    TENTATIVA,
    STATUS,
    DTEXECEXITO
FROM LOGCUSTOMEDIO
WHERE ID = ?
ORDER BY TENTATIVA DESC;
```

---

### 3. Análise de Execuções por Status

**Objetivo:** Identificar distribuição de execuções por status.

**Query SQL:**
```sql
SELECT
    STATUS,
    COUNT(*) AS TOTAL_TENTATIVAS,
    COUNT(DTEXECEXITO) AS TOTAL_SUCESSOS,
    COUNT(*) - COUNT(DTEXECEXITO) AS TOTAL_FALHAS
FROM LOGCUSTOMEDIO
WHERE STATUS IS NOT NULL
GROUP BY STATUS
ORDER BY TOTAL_TENTATIVAS DESC;
```

---

### 4. Análise de Execuções por Período

**Objetivo:** Identificar distribuição de execuções ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DTEXECEXITO) AS ANO,
    EXTRACT(MONTH FROM DTEXECEXITO) AS MES,
    COUNT(*) AS TOTAL_EXECUCOES_SUCESSO
FROM LOGCUSTOMEDIO
WHERE DTEXECEXITO IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DTEXECEXITO), EXTRACT(MONTH FROM DTEXECEXITO)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOGCUSTOMEDIO | Tipo |
|--------|-----------|--------------------------|------|
| **LOGCUSTOMEDIO** | 1.562 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **1.562 tentativas** de cálculo de custo médio registradas no sistema
- Indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por ID (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOGCUSTOMEDIO_ID ON LOGCUSTOMEDIO(ID);

-- Índice 2: Busca por status (consultas frequentes)
CREATE INDEX IDX_LOGCUSTOMEDIO_STATUS ON LOGCUSTOMEDIO(STATUS)
    WHERE STATUS IS NOT NULL;

-- Índice 3: Busca por data de execução (consultas frequentes)
CREATE INDEX IDX_LOGCUSTOMEDIO_DTEXECEXITO ON LOGCUSTOMEDIO(DTEXECEXITO)
    WHERE DTEXECEXITO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogcustomedio extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOGCUSTOMEDIO';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'TENTATIVA' => 'integer',
        'STATUS' => 'string',
        'DTEXECEXITO' => 'datetime',
    ];

    public function scopePorProduto($query, int $id)
    {
        return $query->where('ID', $id);
    }

    public function scopePorStatus($query, string $status)
    {
        return $query->where('STATUS', $status);
    }

    public function scopeComSucesso($query)
    {
        return $query->whereNotNull('DTEXECEXITO');
    }

    public function scopeSemSucesso($query)
    {
        return $query->whereNull('DTEXECEXITO');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('TENTATIVA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

