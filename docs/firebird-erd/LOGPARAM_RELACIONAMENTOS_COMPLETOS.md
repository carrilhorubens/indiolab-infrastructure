# LOGPARAM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOGPARAM (Log de Parâmetros)
- **Total de Registros**: 29.816
- **Total de Colunas**: 11
- **Chave Primária**: CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOGPARAM** é uma tabela que armazena logs de alterações em parâmetros do sistema. Com **29.816 registros**, representa um histórico extenso de mudanças em parâmetros, incluindo informações sobre usuário, IP, aplicação, empresa, tabela e valores antigos e novos.

Esta tabela funciona como **log de alterações de parâmetros** e permite:
- Registrar todas as alterações em parâmetros do sistema
- Armazenar valores antigos e novos de parâmetros
- Identificar usuário, aplicação e empresa da alteração
- Rastrear endereço IP e data/hora da alteração
- Associar alterações a tabelas específicas
- Facilitar auditoria de alterações de configuração
- Manter histórico detalhado de mudanças

Cada registro representa uma alteração específica em um parâmetro, contendo:
- Código do log (CODIGO)
- Usuário do sistema (SYSTEM_USER)
- Endereço IP (IP)
- Data da alteração (DATA)
- Hora da alteração (HORA)
- Nome do parâmetro (PARAMETRO)
- Código da empresa (EMPCODIGO)
- Nome da tabela (TABELA)
- Valor antigo (VR_ANTIGO)
- Valor novo (VR_NOVO)
- Aplicação utilizada (APLICACAO)

O sistema utiliza esta tabela para manter histórico completo de alterações em parâmetros, permitindo auditoria detalhada e rastreamento de mudanças por empresa e tabela.

**Observação Importante:** LOGPARAM é uma tabela de log de alterações de parâmetros. Com 29.816 registros, indica uso intenso desta funcionalidade de auditoria. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de empresas através do campo EMPCODIGO e com tabelas de usuários através do campo SYSTEM_USER.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGO** 🔑 | INTEGER | ✓ | Código do log de parâmetro (PK) |

### Informações da Alteração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SYSTEM_USER** | VARCHAR(37) | | Usuário do sistema que realizou a alteração |
| **IP** | VARCHAR(37) | | Endereço IP da alteração |
| **DATA** | DATE | | Data da alteração |
| **HORA** | TIME | | Hora da alteração |
| **PARAMETRO** | VARCHAR(37) | | Nome do parâmetro alterado |
| **EMPCODIGO** | INTEGER | | Código da empresa |
| **TABELA** | VARCHAR(37) | | Nome da tabela relacionada |
| **VR_ANTIGO** | VARCHAR(37) | | Valor antigo do parâmetro |
| **VR_NOVO** | VARCHAR(37) | | Valor novo do parâmetro |
| **APLICACAO** | VARCHAR(37) | | Aplicação utilizada |

**Primary Key:** CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOGPARAM Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOGPARAM é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOGPARAM diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via EMPCODIGO → EMPRESA

**Fluxo:** LOGPARAM → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de empresas.

---

### Via SYSTEM_USER → Tabelas de Usuários

**Fluxo:** LOGPARAM → USUARIO → Operações

**Descrição:** Através do nome do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Parâmetro

**Objetivo:** Obter informações de um log específico.

```sql
SELECT
    CODIGO,
    SYSTEM_USER,
    IP,
    DATA,
    HORA,
    PARAMETRO,
    EMPCODIGO,
    TABELA,
    VR_ANTIGO,
    VR_NOVO,
    APLICACAO
FROM LOGPARAM
WHERE CODIGO = ?;
```

---

### 2. Listar Alterações de um Parâmetro

**Objetivo:** Obter todas as alterações de um parâmetro específico.

```sql
SELECT
    CODIGO,
    SYSTEM_USER,
    IP,
    DATA,
    HORA,
    EMPCODIGO,
    TABELA,
    VR_ANTIGO,
    VR_NOVO,
    APLICACAO
FROM LOGPARAM
WHERE PARAMETRO = ?
ORDER BY DATA DESC, HORA DESC;
```

---

### 3. Análise de Alterações por Empresa

**Objetivo:** Identificar distribuição de alterações por empresa.

**Query SQL:**
```sql
SELECT
    EMPCODIGO,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT PARAMETRO) AS TOTAL_PARAMETROS_AFETADOS,
    COUNT(DISTINCT TABELA) AS TOTAL_TABELAS_AFETADAS
FROM LOGPARAM
WHERE EMPCODIGO IS NOT NULL
GROUP BY EMPCODIGO
ORDER BY TOTAL_ALTERACOES DESC;
```

---

### 4. Análise de Alterações por Período

**Objetivo:** Identificar distribuição de alterações ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DATA) AS ANO,
    EXTRACT(MONTH FROM DATA) AS MES,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT PARAMETRO) AS TOTAL_PARAMETROS_AFETADOS
FROM LOGPARAM
WHERE DATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATA), EXTRACT(MONTH FROM DATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOGPARAM | Tipo |
|--------|-----------|----------------------|------|
| **LOGPARAM** | 29.816 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **29.816 alterações** de parâmetros registradas no sistema
- Indica uso intenso desta funcionalidade de auditoria

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOGPARAM_DATA ON LOGPARAM(DATA)
    WHERE DATA IS NOT NULL;

-- Índice 2: Busca por parâmetro (consultas frequentes)
CREATE INDEX IDX_LOGPARAM_PARAMETRO ON LOGPARAM(PARAMETRO)
    WHERE PARAMETRO IS NOT NULL;

-- Índice 3: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_LOGPARAM_EMPCODIGO ON LOGPARAM(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 4: Busca por tabela (consultas frequentes)
CREATE INDEX IDX_LOGPARAM_TABELA ON LOGPARAM(TABELA)
    WHERE TABELA IS NOT NULL;

-- Índice 5: Busca combinada empresa + data (consultas frequentes)
CREATE INDEX IDX_LOGPARAM_EMPRESA_DATA ON LOGPARAM(EMPCODIGO, DATA);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogparam extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOGPARAM';
    
    protected $primaryKey = 'CODIGO';
    public $incrementing = true;

    protected $casts = [
        'CODIGO' => 'integer',
        'SYSTEM_USER' => 'string',
        'IP' => 'string',
        'DATA' => 'date',
        'HORA' => 'string',
        'PARAMETRO' => 'string',
        'EMPCODIGO' => 'integer',
        'TABELA' => 'string',
        'VR_ANTIGO' => 'string',
        'VR_NOVO' => 'string',
        'APLICACAO' => 'string',
    ];

    public function scopePorParametro($query, string $parametro)
    {
        return $query->where('PARAMETRO', $parametro);
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorTabela($query, string $tabela)
    {
        return $query->where('TABELA', $tabela);
    }

    public function scopePorUsuario($query, string $systemUser)
    {
        return $query->where('SYSTEM_USER', $systemUser);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('DATA', 'desc')->orderBy('HORA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

