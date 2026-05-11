# MOTDEVCH - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOTDEVCH (Motivos de Devolução de Cheques)
- **Total de Registros**: 16
- **Total de Colunas**: 3
- **Chave Primária**: MDCCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOTDEVCH** é uma tabela que armazena motivos de devolução de cheques. Com **16 registros**, representa motivos cadastrados no sistema para justificar devoluções de cheques, incluindo informações sobre descrição e indicador de reapresentação.

Esta tabela funciona como **mestre de motivos de devolução** e permite:
- Registrar todos os motivos de devolução de cheques
- Armazenar informações sobre descrição e reapresentação
- Controlar se o cheque pode ser reapresentado
- Facilitar gestão de motivos de devolução
- Manter histórico detalhado de motivos

Cada registro representa um motivo específico de devolução, contendo:
- Código do motivo (MDCCODIGO)
- Descrição do motivo (MDCDESCRICAO)
- Indicador de reapresentação (MDCREAPRESENTA)

O sistema utiliza esta tabela para manter histórico completo de motivos de devolução de cheques, permitindo classificação e controle de devoluções.

**Observação Importante:** MOTDEVCH é uma tabela mestre de motivos de devolução de cheques. Com 16 registros, indica uso moderado desta funcionalidade. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de cheques através de campos de motivo de devolução.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDCCODIGO** 🔑 | INTEGER | ✓ | Código do motivo de devolução (PK) |

### Informações do Motivo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MDCDESCRICAO** | VARCHAR(37) | ✓ | Descrição do motivo de devolução |
| **MDCREAPRESENTA** | VARCHAR(14) | ✓ | Indicador se o cheque pode ser reapresentado |

**Primary Key:** MDCCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOTDEVCH Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MOTDEVCH é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOTDEVCH diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via Motivos de Devolução → Tabelas de Cheques

**Fluxo:** MOTDEVCH → CHEQUE → Operações

**Descrição:** Através dos motivos de devolução, é possível identificar cheques relacionados que foram devolvidos.

**Uso:** Análise de motivos através de operações de cheques.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Motivo de Devolução

**Objetivo:** Obter informações de um motivo específico.

```sql
SELECT
    MDCCODIGO,
    MDCDESCRICAO,
    MDCREAPRESENTA
FROM MOTDEVCH
WHERE MDCCODIGO = ?;
```

---

### 2. Listar Motivos que Permitem Reapresentação

**Objetivo:** Obter todos os motivos que permitem reapresentação do cheque.

```sql
SELECT
    MDCCODIGO,
    MDCDESCRICAO
FROM MOTDEVCH
WHERE MDCREAPRESENTA = '1' OR MDCREAPRESENTA = 'S'
ORDER BY MDCDESCRICAO;
```

---

### 3. Análise de Motivos

**Objetivo:** Identificar distribuição de motivos por reapresentação.

**Query SQL:**
```sql
SELECT
    MDCREAPRESENTA,
    COUNT(*) AS TOTAL_MOTIVOS,
    STRING_AGG(MDCDESCRICAO, ', ') AS MOTIVOS
FROM MOTDEVCH
GROUP BY MDCREAPRESENTA
ORDER BY TOTAL_MOTIVOS DESC;
```

---

### 4. Buscar Motivos Ordenados

**Objetivo:** Obter motivos ordenados por descrição.

```sql
SELECT
    MDCCODIGO,
    MDCDESCRICAO,
    MDCREAPRESENTA
FROM MOTDEVCH
ORDER BY MDCDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOTDEVCH | Tipo |
|--------|-----------|---------------------|------|
| **MOTDEVCH** | 16 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **16 motivos** de devolução registrados no sistema
- Indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por reapresentação (consultas frequentes)
CREATE INDEX IDX_MOTDEVCH_REAPRESENTA ON MOTDEVCH(MDCREAPRESENTA)
    WHERE MDCREAPRESENTA IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMotdevch extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOTDEVCH';
    
    protected $primaryKey = 'MDCCODIGO';
    public $incrementing = true;

    protected $casts = [
        'MDCCODIGO' => 'integer',
        'MDCDESCRICAO' => 'string',
        'MDCREAPRESENTA' => 'string',
    ];

    public function scopePermiteReapresentacao($query)
    {
        return $query->whereIn('MDCREAPRESENTA', ['1', 'S', 'TRUE']);
    }

    public function scopeNaoPermiteReapresentacao($query)
    {
        return $query->whereIn('MDCREAPRESENTA', ['0', 'N', 'FALSE']);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MDCDESCRICAO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

