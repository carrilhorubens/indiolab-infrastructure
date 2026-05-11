# MACROS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MACROS (Macros/Configurações)
- **Total de Registros**: 94
- **Total de Colunas**: 5
- **Chave Primária**: MACCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MACROS** é uma tabela que armazena configurações de macros do sistema. Com **94 registros**, representa definições de macros que podem ser utilizadas em diferentes contextos do sistema, incluindo informações sobre tabela, campo, label e chave.

Esta tabela funciona como **mestre de macros/configurações** e permite:
- Registrar configurações de macros do sistema
- Armazenar informações sobre tabela, campo, label e chave
- Facilitar configuração dinâmica de campos
- Suportar personalização de labels e chaves
- Manter histórico detalhado de configurações
- Permitir reutilização de configurações

Cada registro representa uma configuração específica de macro, contendo:
- Código da macro (MACCODIGO)
- Nome da tabela (MACTABELA)
- Nome do campo (MACCAMPO)
- Label do campo (MACLABEL)
- Chave do campo (MACCHAVE)

O sistema utiliza esta tabela para manter configurações de macros que podem ser utilizadas em diferentes partes do sistema, permitindo personalização e reutilização de configurações.

**Observação Importante:** MACROS é uma tabela mestre de macros/configurações. Com 94 registros, indica uso moderado desta funcionalidade. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas mencionadas no campo MACTABELA através de nomes de tabelas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MACCODIGO** 🔑 | INTEGER | ✓ | Código da macro (PK) |

### Informações da Macro
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MACTABELA** | VARCHAR(37) | ✓ | Nome da tabela relacionada |
| **MACCAMPO** | VARCHAR(37) | ✓ | Nome do campo relacionado |
| **MACLABEL** | VARCHAR(37) | ✓ | Label do campo |
| **MACCHAVE** | VARCHAR(37) | ✓ | Chave do campo |

**Primary Key:** MACCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MACROS Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MACROS é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MACROS diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via MACTABELA → Tabelas do Sistema

**Fluxo:** MACROS → Tabelas do Sistema → Operações

**Descrição:** Através do nome da tabela, é possível identificar tabelas relacionadas mencionadas nas macros.

**Uso:** Análise de macros através de tabelas do sistema.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Macro

**Objetivo:** Obter informações de uma macro específica.

```sql
SELECT
    MACCODIGO,
    MACTABELA,
    MACCAMPO,
    MACLABEL,
    MACCHAVE
FROM MACROS
WHERE MACCODIGO = ?;
```

---

### 2. Listar Macros de uma Tabela

**Objetivo:** Obter todas as macros relacionadas a uma tabela específica.

```sql
SELECT
    MACCODIGO,
    MACCAMPO,
    MACLABEL,
    MACCHAVE
FROM MACROS
WHERE MACTABELA = ?
ORDER BY MACCAMPO;
```

---

### 3. Análise de Macros por Tabela

**Objetivo:** Identificar distribuição de macros por tabela.

**Query SQL:**
```sql
SELECT
    MACTABELA,
    COUNT(*) AS TOTAL_MACROS,
    COUNT(DISTINCT MACCAMPO) AS TOTAL_CAMPOS_AFETADOS
FROM MACROS
WHERE MACTABELA IS NOT NULL
GROUP BY MACTABELA
ORDER BY TOTAL_MACROS DESC;
```

---

### 4. Buscar Macros por Campo

**Objetivo:** Identificar macros relacionadas a um campo específico.

**Query SQL:**
```sql
SELECT
    MACCODIGO,
    MACTABELA,
    MACLABEL,
    MACCHAVE
FROM MACROS
WHERE MACCAMPO = ?
ORDER BY MACTABELA;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MACROS | Tipo |
|--------|-----------|---------------------|------|
| **MACROS** | 94 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **94 macros** registradas no sistema
- Indica uso moderado desta funcionalidade de configuração

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por tabela (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MACROS_TABELA ON MACROS(MACTABELA)
    WHERE MACTABELA IS NOT NULL;

-- Índice 2: Busca por campo (consultas frequentes)
CREATE INDEX IDX_MACROS_CAMPO ON MACROS(MACCAMPO)
    WHERE MACCAMPO IS NOT NULL;

-- Índice 3: Busca por chave (consultas frequentes)
CREATE INDEX IDX_MACROS_CHAVE ON MACROS(MACCHAVE)
    WHERE MACCHAVE IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMacros extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MACROS';
    
    protected $primaryKey = 'MACCODIGO';
    public $incrementing = true;

    protected $casts = [
        'MACCODIGO' => 'integer',
        'MACTABELA' => 'string',
        'MACCAMPO' => 'string',
        'MACLABEL' => 'string',
        'MACCHAVE' => 'string',
    ];

    public function scopePorTabela($query, string $tabela)
    {
        return $query->where('MACTABELA', $tabela);
    }

    public function scopePorCampo($query, string $campo)
    {
        return $query->where('MACCAMPO', $campo);
    }

    public function scopePorChave($query, string $chave)
    {
        return $query->where('MACCHAVE', $chave);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('MACTABELA')->orderBy('MACCAMPO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

