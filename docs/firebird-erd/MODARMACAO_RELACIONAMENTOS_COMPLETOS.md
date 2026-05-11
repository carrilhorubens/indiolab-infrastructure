# MODARMACAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODARMACAO (Modelos de Armação)
- **Total de Registros**: 31
- **Total de Colunas**: 9
- **Chave Primária**: MODCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (MODARMACAOSISEXT, OCLENTE)
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODARMACAO** é uma tabela que armazena informações sobre modelos de armação de óculos. Com **31 registros**, representa modelos de armação cadastrados no sistema, incluindo informações sobre descrição, pontos, desenho, situação e arquivos relacionados.

Esta tabela funciona como **mestre de modelos de armação** e permite:
- Registrar todos os modelos de armação de óculos
- Armazenar informações sobre descrição, pontos e desenho
- Vincular arquivos de armação e desenhos
- Controlar situação e exibição de arquivos
- Suportar integração com sistemas externos
- Associar modelos a orçamentos de clientes
- Facilitar gestão de modelos de armação
- Manter histórico detalhado de modelos

Cada registro representa um modelo específico de armação, contendo:
- Código do modelo (MODCODIGO)
- Ordem do modelo (MODORDEM)
- Descrição do modelo (MODDESCRICAO)
- Pontos do modelo (MODPONTOS)
- Desenho do modelo (MODDESENHO)
- Situação do modelo (MODSITUACAO)
- Arquivo de armação (MODARQARMACAO)
- Arquivo de desenho de armação (MODDESENHOARQARMACAO)
- Indicador de exibição de arquivo (MODEXIBEARQUIVO)

O sistema utiliza esta tabela para manter histórico completo de modelos de armação, sendo referenciada por MODARMACAOSISEXT para integração com sistemas externos e por OCLENTE para associar modelos a orçamentos de clientes.

**Observação Importante:** MODARMACAO é uma tabela mestre de modelos de armação. Com 31 registros, indica uso moderado desta funcionalidade. Não possui foreign keys diretas, mas é referenciada por 2 tabelas, indicando sua importância no sistema de gestão de armações.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MODCODIGO** 🔑 | INTEGER | ✓ | Código do modelo de armação (PK) |

### Informações do Modelo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MODORDEM** | INTEGER | | Ordem de exibição do modelo |
| **MODDESCRICAO** | VARCHAR(14) | ✓ | Descrição do modelo |
| **MODPONTOS** | VARCHAR(261) | | Pontos do modelo |
| **MODDESENHO** | VARCHAR(261) | | Desenho do modelo |
| **MODSITUACAO** | VARCHAR(14) | | Situação do modelo |
| **MODARQARMACAO** | VARCHAR(261) | | Caminho do arquivo de armação |
| **MODDESENHOARQARMACAO** | VARCHAR(261) | | Caminho do arquivo de desenho de armação |
| **MODEXIBEARQUIVO** | VARCHAR(14) | | Indicador de exibição de arquivo |

**Primary Key:** MODCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODARMACAO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MODARMACAO é Referenciada Por (2 tabelas):

#### 1. MODARMACAOSISEXT - Integração de Modelos de Armação com Sistemas Externos
**Relacionamento:**
```
MODARMACAOSISEXT.MODCODIGO → MODARMACAO.MODCODIGO (N:1)
Constraint: MODARMACAO_MODARMACAOSISEXT
```

**Descrição**: Cada integração de modelo de armação com sistema externo está vinculada a um modelo específico.

**Informações da Tabela MODARMACAOSISEXT:**
- **Total:** 62 integrações
- **PK:** MODCODIGO, MSENOME (composta)
- **Colunas:** 3 campos

**Uso:** Mapear modelos de armação internos para códigos de sistemas externos.

---

#### 2. OCLENTE - Orçamentos de Clientes
**Relacionamento:**
```
OCLENTE.OCLMODELO → MODARMACAO.MODCODIGO (N:1)
Constraint: MODARMACAO_OCLENTE
```

**Descrição**: Cada orçamento de cliente pode estar vinculado a um modelo de armação específico.

**Informações da Tabela OCLENTE:**
- **Total:** 0 orçamentos
- **PK:** EMPCODIGO, ORCDTEMIS, ORCCODIGO, OCLSEQ (composta)
- **Colunas:** 59 campos

**Uso:** Associar modelos de armação a orçamentos de clientes.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via MODARMACAOSISEXT → SISTEMAEXT

**Fluxo:** MODARMACAO → MODARMACAOSISEXT → SISTEMAEXT → Operações

**Descrição:** Através das integrações com sistemas externos, é possível identificar sistemas relacionados.

**Uso:** Análise de modelos através de sistemas externos.

---

### Via OCLENTE → ORCAMENTO

**Fluxo:** MODARMACAO → OCLENTE → ORCAMENTO → Operações

**Descrição:** Através dos orçamentos de clientes, é possível identificar orçamentos relacionados.

**Uso:** Análise de modelos através de orçamentos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Modelo de Armação

**Objetivo:** Obter informações de um modelo específico.

```sql
SELECT
    MODCODIGO,
    MODORDEM,
    MODDESCRICAO,
    MODPONTOS,
    MODDESENHO,
    MODSITUACAO,
    MODARQARMACAO,
    MODDESENHOARQARMACAO,
    MODEXIBEARQUIVO
FROM MODARMACAO
WHERE MODCODIGO = ?;
```

---

### 2. Listar Integrações de um Modelo

**Objetivo:** Obter todas as integrações com sistemas externos de um modelo específico.

```sql
SELECT
    m.MODCODIGO,
    m.MODDESCRICAO,
    ms.MSENOME AS SISTEMA_EXTERNO,
    ms.MSECODIGO AS CODIGO_EXTERNO
FROM MODARMACAO m
INNER JOIN MODARMACAOSISEXT ms ON ms.MODCODIGO = m.MODCODIGO
WHERE m.MODCODIGO = ?
ORDER BY ms.MSENOME;
```

---

### 3. Análise de Modelos por Situação

**Objetivo:** Identificar distribuição de modelos por situação.

**Query SQL:**
```sql
SELECT
    MODSITUACAO,
    COUNT(*) AS TOTAL_MODELOS,
    COUNT(MODARQARMACAO) AS TOTAL_COM_ARQUIVO
FROM MODARMACAO
WHERE MODSITUACAO IS NOT NULL
GROUP BY MODSITUACAO
ORDER BY TOTAL_MODELOS DESC;
```

---

### 4. Buscar Modelos Ordenados

**Objetivo:** Obter modelos ordenados por ordem de exibição.

```sql
SELECT
    MODCODIGO,
    MODDESCRICAO,
    MODSITUACAO
FROM MODARMACAO
WHERE MODORDEM IS NOT NULL
ORDER BY MODORDEM, MODDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODARMACAO | Tipo |
|--------|-----------|------------------------|------|
| **MODARMACAO** | 31 | 1:1 | **TABELA PRINCIPAL** |
| MODARMACAOSISEXT | 62 | 1:2 | Integrações (média de 2 integrações por modelo) |
| OCLENTE | 0 | 0:1 | Orçamentos (nenhum orçamento registrado) |

**Interpretação:**
- **31 modelos** de armação registrados no sistema
- **Média de 2 integrações por modelo** - indica uso extensivo de integração com sistemas externos

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por situação (consultas frequentes)
CREATE INDEX IDX_MODARMACAO_SITUACAO ON MODARMACAO(MODSITUACAO)
    WHERE MODSITUACAO IS NOT NULL;

-- Índice 2: Busca por ordem (consultas frequentes)
CREATE INDEX IDX_MODARMACAO_ORDEM ON MODARMACAO(MODORDEM)
    WHERE MODORDEM IS NOT NULL;
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

final class FirebirdModarmacao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODARMACAO';
    
    protected $primaryKey = 'MODCODIGO';
    public $incrementing = true;

    protected $casts = [
        'MODCODIGO' => 'integer',
        'MODORDEM' => 'integer',
        'MODDESCRICAO' => 'string',
        'MODPONTOS' => 'string',
        'MODDESENHO' => 'string',
        'MODSITUACAO' => 'string',
        'MODARQARMACAO' => 'string',
        'MODDESENHOARQARMACAO' => 'string',
        'MODEXIBEARQUIVO' => 'string',
    ];

    // Relacionamento com MODARMACAOSISEXT
    public function integracoesSistemasExternos(): HasMany
    {
        return $this->hasMany(FirebirdModarmacaosisext::class, 'MODCODIGO', 'MODCODIGO');
    }

    // Relacionamento com OCLENTE
    public function orcamentosClientes(): HasMany
    {
        return $this->hasMany(FirebirdOclente::class, 'OCLMODELO', 'MODCODIGO');
    }

    public function scopePorSituacao($query, string $situacao)
    {
        return $query->where('MODSITUACAO', $situacao);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MODORDEM')->orderBy('MODDESCRICAO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

