# INTEGRACTBCONTAS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INTEGRACTBCONTAS (Contas de Integração Contábil)
- **Total de Registros**: 24
- **Total de Colunas**: 13
- **Chave Primária**: Composta (ITCCODIGO, EMPCODIGO, CHAVE)
- **Chaves Estrangeiras**: 5
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**INTEGRACTBCONTAS** é uma tabela que armazena configurações de contas contábeis para integração com sistemas externos. Com **24 registros**, representa mapeamentos de contas contábeis que permitem integração entre o sistema ERP e sistemas contábeis externos.

Esta tabela funciona como **configuração de integração contábil** e permite:
- Mapear contas contábeis para integração
- Definir contas de débito e crédito
- Configurar contas de centro de custo
- Vincular contas a perfis de integração
- Suportar múltiplas origens de dados
- Facilitar gestão de integração contábil

Cada registro representa uma configuração de conta contábil específica, contendo:
- Código do perfil de integração (ITCCODIGO) - FK → INTEGRACTBPERFIL
- Código da empresa (EMPCODIGO) - FK → INTEGRACTBPERFIL
- Chave de integração (CHAVE) - FK → INTEGRACTBCHAVES (parte da PK)
- Origem da chave (ORIGEM) - FK → INTEGRACTBCHAVES
- Descrição da conta (ITRDESCRICAO)
- Conta de crédito (ITRCREDITO)
- Conta de débito (ITRDEBITO)
- Conta de crédito centro de custo (ITRCREDITOCC)
- Conta de débito centro de custo (ITRDEBITOCC)
- Código do histórico padrão (HISTCODIGO) - FK → HISPAD
- Histórico personalizado (ITRHISTORICO)
- Indicador de natureza crédito (PLAINDNATCRE)
- Indicador de natureza débito (PLAINDNATDEB)

O sistema utiliza esta tabela para configurar mapeamentos de contas contábeis para integração com sistemas externos, permitindo controle detalhado de integração contábil.

**Observação Importante:** INTEGRACTBCONTAS é uma tabela de configuração de integração contábil. Com 24 registros, indica uso moderado desta funcionalidade. Possui chave primária composta e relacionamentos com INTEGRACTBPERFIL, INTEGRACTBCHAVES e HISPAD.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITCCODIGO** 🔑 🔗 | VARCHAR(37) | ✓ | Código do perfil de integração (PK + FK → INTEGRACTBPERFIL) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → INTEGRACTBPERFIL) |
| **CHAVE** 🔑 🔗 | VARCHAR(37) | ✓ | Chave de integração (PK + FK → INTEGRACTBCHAVES) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ORIGEM** 🔗 | VARCHAR(37) | ✓ | Origem da chave (FK → INTEGRACTBCHAVES) |
| **HISTCODIGO** 🔗 | SMALLINT | | Código do histórico padrão (FK → HISPAD) |

### Informações da Conta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITRDESCRICAO** | VARCHAR(37) | | Descrição da conta |
| **ITRCREDITO** | VARCHAR(37) | | Conta de crédito |
| **ITRDEBITO** | VARCHAR(37) | | Conta de débito |
| **ITRCREDITOCC** | VARCHAR(37) | | Conta de crédito centro de custo |
| **ITRDEBITOCC** | VARCHAR(37) | | Conta de débito centro de custo |
| **ITRHISTORICO** | VARCHAR(37) | | Histórico personalizado |
| **PLAINDNATCRE** | VARCHAR(37) | | Indicador de natureza crédito |
| **PLAINDNATDEB** | VARCHAR(37) | | Indicador de natureza débito |

**Primary Key:** (ITCCODIGO, EMPCODIGO, CHAVE)

**Foreign Keys:**
- `(ITCCODIGO, EMPCODIGO)` → `INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO)` (Constraint: FK_INTEGRACTBCONTAS_1)
- `(CHAVE, ORIGEM)` → `INTEGRACTBCHAVES.(CHAVE, ORIGEM)` (Constraint: FK_INTEGRACTBCONTAS_2)
- `HISTCODIGO` → `HISPAD.HISCODIGO` (Constraint: FK_INTEGRACTBCONTAS_3)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INTEGRACTBCONTAS Referencia (5 FKs):

#### 1. INTEGRACTBPERFIL - Perfil de Integração Contábil
**Relacionamento:**
```
INTEGRACTBCONTAS.(ITCCODIGO, EMPCODIGO) → INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO) (N:1)
Constraint: FK_INTEGRACTBCONTAS_1
```

**Descrição**: Cada conta de integração está vinculada a um perfil de integração específico de uma empresa.

**Informações da Tabela INTEGRACTBPERFIL:**
- **Total:** 2 perfis
- **PK:** (ITCCODIGO, EMPCODIGO)
- **Colunas:** 4 campos

**Uso:** Identificar o perfil de integração ao qual a conta pertence.

---

#### 2. INTEGRACTBCHAVES - Chaves de Integração Contábil
**Relacionamento:**
```
INTEGRACTBCONTAS.(CHAVE, ORIGEM) → INTEGRACTBCHAVES.(CHAVE, ORIGEM) (N:1)
Constraint: FK_INTEGRACTBCONTAS_2
```

**Descrição**: Cada conta de integração está vinculada a uma chave de integração específica.

**Informações da Tabela INTEGRACTBCHAVES:**
- **Total:** 24 chaves
- **PK:** (CHAVE, ORIGEM)
- **Colunas:** 4 campos

**Uso:** Identificar a chave de integração à qual a conta está mapeada.

---

#### 3. HISPAD - Histórico Padrão
**Relacionamento:**
```
INTEGRACTBCONTAS.HISTCODIGO → HISPAD.HISCODIGO (N:1)
Constraint: FK_INTEGRACTBCONTAS_3
```

**Descrição**: Cada conta de integração pode estar vinculada a um histórico padrão específico.

**Informações da Tabela HISPAD:**
- **Total:** 166 históricos padrão
- **PK:** HISCODIGO
- **Colunas:** 2 campos

**Uso:** Identificar o histórico padrão para lançamentos contábeis gerados pela integração.

---

### INTEGRACTBCONTAS é Referenciada Por (0 tabelas):

Nenhuma tabela referencia INTEGRACTBCONTAS diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via INTEGRACTBPERFIL → Outras Operações de Integração

**Fluxo:** INTEGRACTBCONTAS → INTEGRACTBPERFIL → Operações

**Descrição:** Através do perfil de integração, é possível identificar outras operações relacionadas.

**Uso:** Análise de contas através de operações de integração.

---

### Via INTEGRACTBCHAVES → Outras Operações de Integração

**Fluxo:** INTEGRACTBCONTAS → INTEGRACTBCHAVES → Operações

**Descrição:** Através da chave de integração, é possível identificar outras operações relacionadas.

**Uso:** Análise de contas através de operações de integração.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Conta de Integração

**Objetivo:** Obter informações de uma conta de integração específica.

```sql
SELECT
    ITCCODIGO,
    EMPCODIGO,
    CHAVE,
    ORIGEM,
    ITRDESCRICAO,
    ITRCREDITO,
    ITRDEBITO,
    HISTCODIGO
FROM INTEGRACTBCONTAS
WHERE ITCCODIGO = ?
  AND EMPCODIGO = ?
  AND CHAVE = ?;
```

---

### 2. Listar Contas de um Perfil de Integração

**Objetivo:** Obter todas as contas de um perfil de integração específico.

```sql
SELECT
    icc.CHAVE,
    ich.CAMPO,
    icc.ITRDESCRICAO,
    icc.ITRCREDITO,
    icc.ITRDEBITO,
    icc.HISTCODIGO,
    hp.HISDESCRICAO AS HISTORICO
FROM INTEGRACTBCONTAS icc
INNER JOIN INTEGRACTBCHAVES ich ON ich.CHAVE = icc.CHAVE 
                               AND ich.ORIGEM = icc.ORIGEM
LEFT JOIN HISPAD hp ON hp.HISCODIGO = icc.HISTCODIGO
WHERE icc.ITCCODIGO = ?
  AND icc.EMPCODIGO = ?
ORDER BY ich.ORDEM;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INTEGRACTBCONTAS | Tipo |
|--------|-----------|------------------------------|------|
| **INTEGRACTBCONTAS** | 24 | 1:1 | **TABELA PRINCIPAL** |
| INTEGRACTBPERFIL | 2 | 1:12 | Perfis (média de 12 contas por perfil) |
| INTEGRACTBCHAVES | 24 | 1:1 | Chaves (mapeamento 1:1) |
| HISPAD | 166 | 1:0.14 | Históricos padrão |

**Interpretação:**
- **24 contas de integração** cadastradas no sistema
- **Média de 12 contas por perfil** - indica configuração detalhada por perfil

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por perfil e empresa (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBCONTAS_PERFIL ON INTEGRACTBCONTAS(ITCCODIGO, EMPCODIGO);

-- Índice 2: Busca por chave e origem (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBCONTAS_CHAVE ON INTEGRACTBCONTAS(CHAVE, ORIGEM);
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

final class FirebirdIntegractbcontas extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INTEGRACTBCONTAS';
    
    protected $primaryKey = ['ITCCODIGO', 'EMPCODIGO', 'CHAVE'];
    public $incrementing = false;

    protected $casts = [
        'ITCCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'CHAVE' => 'string',
        'ORIGEM' => 'string',
        'ITRDESCRICAO' => 'string',
        'ITRCREDITO' => 'string',
        'ITRDEBITO' => 'string',
        'ITRCREDITOCC' => 'string',
        'ITRDEBITOCC' => 'string',
        'HISTCODIGO' => 'integer',
        'ITRHISTORICO' => 'string',
        'PLAINDNATCRE' => 'string',
        'PLAINDNATDEB' => 'string',
    ];

    // Relacionamento com INTEGRACTBPERFIL
    public function perfil(): BelongsTo
    {
        return $this->belongsTo(FirebirdIntegractbperfil::class, ['ITCCODIGO', 'EMPCODIGO'], ['ITCCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com INTEGRACTBCHAVES
    public function chaveIntegracao(): BelongsTo
    {
        return $this->belongsTo(FirebirdIntegractbchaves::class, ['CHAVE', 'ORIGEM'], ['CHAVE', 'ORIGEM']);
    }

    // Relacionamento com HISPAD
    public function historicoPadrao(): BelongsTo
    {
        return $this->belongsTo(FirebirdHispad::class, 'HISTCODIGO', 'HISCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

