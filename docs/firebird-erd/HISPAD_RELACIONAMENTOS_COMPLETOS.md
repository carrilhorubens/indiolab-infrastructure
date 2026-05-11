# HISPAD - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: HISPAD (Histórico Padrão)
- **Total de Registros**: 166
- **Total de Colunas**: 2
- **Chave Primária**: HISCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 4 (CCUSTEMPCTB, INTEGRACTBCONTAS, LACTOCTB, LACTOCTBCC)
- **Banco de Dados**: Firebird

## 📝 Descrição

**HISPAD** é uma tabela mestre que armazena históricos padrão utilizados para categorização e controle de lançamentos contábeis e operações financeiras. Com **166 registros**, representa diferentes tipos de histórico que permitem classificação e rastreamento de operações contábeis.

Esta tabela funciona como **catálogo de históricos padrão** e permite:
- Categorizar lançamentos contábeis por tipo de histórico
- Facilitar rastreamento e controle de operações financeiras
- Suportar classificação de lançamentos contábeis
- Facilitar gestão de histórico contábil
- Suportar integração contábil

Cada registro representa um tipo de histórico padrão específico, contendo:
- Código do histórico (HISCODIGO)
- Descrição do histórico (HISDESCRICAO)

O sistema utiliza esta tabela para organizar lançamentos contábeis e operações financeiras por tipo de histórico, sendo referenciada por CCUSTEMPCTB (centro de custo empresa contábil), INTEGRACTBCONTAS (integração contábil contas), LACTOCTB (lançamento contábil) e LACTOCTBCC (lançamento contábil centro de custo).

**Observação Importante:** HISPAD é uma tabela mestre de históricos padrão. Com 166 registros, indica uso extensivo desta funcionalidade para controle contábil. É referenciada por múltiplas tabelas contábeis para classificação de lançamentos.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISCODIGO** 🔑 | INTEGER | ✓ | Código do histórico padrão (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HISDESCRICAO** | VARCHAR(37) | ✓ | Descrição do histórico padrão |

**Primary Key:** HISCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### HISPAD Referencia (0 FKs):

Nenhuma foreign key direta.

---

### HISPAD é Referenciada Por (4 tabelas):

#### 1. CCUSTEMPCTB - Centro de Custo Empresa Contábil
**Relacionamento:**
```
CCUSTEMPCTB.HISCODIGO → HISPAD.HISCODIGO (N:1)
Constraint: HISPAD_CCUSTEMPCTB
```

**Descrição**: Cada centro de custo empresa contábil pode estar vinculado a um histórico padrão específico.

**Uso:** Vincular centros de custo a históricos para rastreamento contábil.

---

#### 2. INTEGRACTBCONTAS - Integração Contábil Contas
**Relacionamento:**
```
INTEGRACTBCONTAS.HISTCODIGO → HISPAD.HISCODIGO (N:1)
Constraint: FK_INTEGRACTBCONTAS_3
```

**Descrição**: Cada integração contábil pode estar vinculada a um histórico padrão específico.

**Uso:** Vincular integrações contábeis a históricos para rastreamento.

---

#### 3. LACTOCTB - Lançamento Contábil
**Relacionamento:**
```
LACTOCTB.HISCODIGO → HISPAD.HISCODIGO (N:1)
Constraint: HISPAD_LACTOCTB
```

**Descrição**: Cada lançamento contábil pode estar vinculado a um histórico padrão específico.

**Uso:** Vincular lançamentos contábeis a históricos para rastreamento e controle.

---

#### 4. LACTOCTBCC - Lançamento Contábil Centro de Custo
**Relacionamento:**
```
LACTOCTBCC.HISCODIGO → HISPAD.HISCODIGO (N:1)
Constraint: HISPAD_LACTOCTBCC
```

**Descrição**: Cada lançamento contábil de centro de custo pode estar vinculado a um histórico padrão específico.

**Uso:** Vincular lançamentos contábeis de centro de custo a históricos para rastreamento.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via LACTOCTB → Outras Operações Contábeis

**Fluxo:** HISPAD → LACTOCTB → Operações

**Descrição:** Através dos lançamentos contábeis, é possível identificar outras operações relacionadas.

**Uso:** Análise de históricos através de lançamentos contábeis.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Histórico Padrão

**Objetivo:** Obter informações de um histórico padrão específico.

```sql
SELECT
    HISCODIGO,
    HISDESCRICAO AS HISTORICO_PADRAO
FROM HISPAD
WHERE HISCODIGO = ?;
```

---

### 2. Listar Todos os Históricos Padrão

**Objetivo:** Obter catálogo completo de históricos padrão.

```sql
SELECT
    HISCODIGO,
    HISDESCRICAO AS HISTORICO_PADRAO
FROM HISPAD
ORDER BY HISDESCRICAO;
```

---

### 3. Análise de Históricos por Uso

**Objetivo:** Identificar distribuição de históricos por tipo de uso.

**Query SQL:**
```sql
SELECT
    hp.HISCODIGO,
    hp.HISDESCRICAO AS HISTORICO_PADRAO,
    COUNT(DISTINCT cctb.CCUSTEMPCTB_ID) AS TOTAL_CCUSTO,
    COUNT(DISTINCT lactb.LACTOCTB_ID) AS TOTAL_LANCAMENTOS,
    COUNT(DISTINCT lactbcc.LACTOCTBCC_ID) AS TOTAL_LANCAMENTOS_CC
FROM HISPAD hp
LEFT JOIN CCUSTEMPCTB cctb ON cctb.HISCODIGO = hp.HISCODIGO
LEFT JOIN LACTOCTB lactb ON lactb.HISCODIGO = hp.HISCODIGO
LEFT JOIN LACTOCTBCC lactbcc ON lactbcc.HISCODIGO = hp.HISCODIGO
GROUP BY hp.HISCODIGO, hp.HISDESCRICAO
ORDER BY TOTAL_LANCAMENTOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com HISPAD | Tipo |
|--------|-----------|---------------------|------|
| **HISPAD** | 166 | 1:1 | **TABELA PRINCIPAL** |
| CCUSTEMPCTB | Informação não disponível | - | Centros de custo |
| LACTOCTB | Informação não disponível | - | Lançamentos contábeis |
| LACTOCTBCC | Informação não disponível | - | Lançamentos CC |

**Interpretação:**
- **166 históricos padrão** cadastrados no sistema
- Indica uso extensivo desta funcionalidade para controle contábil

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_HISPAD_DESCRICAO ON HISPAD(HISDESCRICAO)
    WHERE HISDESCRICAO IS NOT NULL;
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

final class FirebirdHispad extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'HISPAD';
    
    protected $primaryKey = 'HISCODIGO';
    public $incrementing = true;

    protected $casts = [
        'HISCODIGO' => 'integer',
        'HISDESCRICAO' => 'string',
    ];

    // Relacionamento com LACTOCTB
    public function lancamentosContabeis(): HasMany
    {
        return $this->hasMany(FirebirdLactoctb::class, 'HISCODIGO', 'HISCODIGO');
    }

    // Relacionamento com LACTOCTBCC
    public function lancamentosContabeisCC(): HasMany
    {
        return $this->hasMany(FirebirdLactoctbcc::class, 'HISCODIGO', 'HISCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

