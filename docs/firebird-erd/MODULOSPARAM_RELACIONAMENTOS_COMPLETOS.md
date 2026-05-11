# MODULOSPARAM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODULOSPARAM (Parâmetros de Módulos)
- **Total de Registros**: 105
- **Total de Colunas**: 7
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 1 (VERSAOERP)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODULOSPARAM** é uma tabela que armazena parâmetros de configuração de módulos do sistema. Com **105 registros**, representa parâmetros cadastrados para diferentes versões do ERP, incluindo informações sobre nome, valor, descrição e proposta.

Esta tabela funciona como **configuração de parâmetros de módulos** e permite:
- Registrar parâmetros de configuração de módulos
- Armazenar informações sobre nome, valor e descrição
- Vincular parâmetros a versões específicas do ERP
- Suportar propostas de configuração
- Facilitar gestão de parâmetros de módulos
- Manter histórico detalhado de parâmetros

Cada registro representa um parâmetro específico de módulo, contendo:
- ID do parâmetro (ID)
- Nome do parâmetro (NOME)
- Valor do parâmetro (VALOR)
- Descrição do parâmetro (DESCRICAO)
- Proposta do parâmetro (PROPOSTA)
- ID da versão do ERP (ID_VERSAO)
- Descrição completa (DESCRICAOCOMPLETA)

O sistema utiliza esta tabela para manter histórico completo de parâmetros de módulos, sendo referenciada por VERSAOERP através de ID_VERSAO para vincular parâmetros a versões específicas do ERP.

**Observação Importante:** MODULOSPARAM é uma tabela de configuração de parâmetros de módulos. Com 105 registros, indica uso moderado desta funcionalidade. Possui 1 foreign key para VERSAOERP, indicando sua função de configuração por versão do ERP.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID do parâmetro (PK) |

### Informações do Parâmetro
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NOME** | VARCHAR(37) | ✓ | Nome do parâmetro |
| **VALOR** | VARCHAR(37) | | Valor do parâmetro |
| **DESCRICAO** | VARCHAR(37) | | Descrição do parâmetro |
| **PROPOSTA** | VARCHAR(37) | | Proposta do parâmetro |
| **DESCRICAOCOMPLETA** | VARCHAR(37) | | Descrição completa do parâmetro |

### Relacionamento com VERSAOERP
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_VERSAO** 🔗 | INTEGER | ✓ | ID da versão do ERP (FK) |

**Primary Key:** ID

**Foreign Keys:**
- `XFK_VERSAOERP`: ID_VERSAO → VERSAOERP.ID_VERSAO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODULOSPARAM Referencia (1 tabela):

#### 1. VERSAOERP - Versões do ERP
**Relacionamento:**
```
MODULOSPARAM.ID_VERSAO → VERSAOERP.ID_VERSAO (N:1)
Constraint: XFK_VERSAOERP
```

**Descrição**: Cada parâmetro está vinculado a uma versão específica do ERP.

**Informações da Tabela VERSAOERP:**
- **Total:** 6 versões
- **PK:** ID_VERSAO
- **Colunas:** 2 campos

**Uso:** Vincular parâmetros a versões do ERP para controle de configuração.

---

### MODULOSPARAM é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MODULOSPARAM diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via VERSAOERP → Outras Operações

**Fluxo:** MODULOSPARAM → VERSAOERP → Operações

**Descrição:** Através das versões do ERP vinculadas, é possível identificar outras operações relacionadas.

**Uso:** Análise de parâmetros através de versões do ERP.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Parâmetro de Módulo

**Objetivo:** Obter informações de um parâmetro específico.

```sql
SELECT
    mp.ID,
    mp.NOME,
    mp.VALOR,
    mp.DESCRICAO,
    mp.PROPOSTA,
    mp.ID_VERSAO,
    mp.DESCRICAOCOMPLETA,
    v.VERDESCRICAO AS VERSAO_DESCRICAO
FROM MODULOSPARAM mp
INNER JOIN VERSAOERP v ON v.ID_VERSAO = mp.ID_VERSAO
WHERE mp.ID = ?;
```

---

### 2. Listar Parâmetros de uma Versão

**Objetivo:** Obter todos os parâmetros de uma versão específica do ERP.

```sql
SELECT
    mp.ID,
    mp.NOME,
    mp.VALOR,
    mp.DESCRICAO,
    mp.PROPOSTA
FROM MODULOSPARAM mp
WHERE mp.ID_VERSAO = ?
ORDER BY mp.NOME;
```

---

### 3. Análise de Parâmetros por Versão

**Objetivo:** Identificar distribuição de parâmetros por versão do ERP.

**Query SQL:**
```sql
SELECT
    v.VERDESCRICAO AS VERSAO,
    COUNT(mp.ID) AS TOTAL_PARAMETROS,
    COUNT(mp.VALOR) AS TOTAL_COM_VALOR
FROM VERSAOERP v
LEFT JOIN MODULOSPARAM mp ON mp.ID_VERSAO = v.ID_VERSAO
GROUP BY v.VERDESCRICAO
ORDER BY TOTAL_PARAMETROS DESC;
```

---

### 4. Buscar Parâmetros com Proposta

**Objetivo:** Obter parâmetros que possuem proposta.

```sql
SELECT
    ID,
    NOME,
    VALOR,
    PROPOSTA,
    DESCRICAOCOMPLETA
FROM MODULOSPARAM
WHERE PROPOSTA IS NOT NULL AND PROPOSTA != ''
ORDER BY NOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODULOSPARAM | Tipo |
|--------|-----------|--------------------------|------|
| **MODULOSPARAM** | 105 | 1:1 | **TABELA PRINCIPAL** |
| VERSAOERP | 6 | 1:17.5 | Versões (média de 17.5 parâmetros por versão) |

**Interpretação:**
- **105 parâmetros** registrados no sistema
- **Média de 17.5 parâmetros por versão** - indica uso extensivo de parâmetros por versão

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por versão (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MODULOSPARAM_VERSAO ON MODULOSPARAM(ID_VERSAO);

-- Índice 2: Busca por nome (consultas frequentes)
CREATE INDEX IDX_MODULOSPARAM_NOME ON MODULOSPARAM(NOME)
    WHERE NOME IS NOT NULL;
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

final class FirebirdModulosparam extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODULOSPARAM';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'NOME' => 'string',
        'VALOR' => 'string',
        'DESCRICAO' => 'string',
        'PROPOSTA' => 'string',
        'ID_VERSAO' => 'integer',
        'DESCRICAOCOMPLETA' => 'string',
    ];

    // Relacionamento com VERSAOERP
    public function versaoErp(): BelongsTo
    {
        return $this->belongsTo(FirebirdVersaoerp::class, 'ID_VERSAO', 'ID_VERSAO');
    }

    public function scopePorVersao($query, int $idVersao)
    {
        return $query->where('ID_VERSAO', $idVersao);
    }

    public function scopeComProposta($query)
    {
        return $query->whereNotNull('PROPOSTA')
                     ->where('PROPOSTA', '!=', '');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('NOME');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

