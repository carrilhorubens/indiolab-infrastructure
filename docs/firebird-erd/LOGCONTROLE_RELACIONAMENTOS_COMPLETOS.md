# LOGCONTROLE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOGCONTROLE (Log de Controle)
- **Total de Registros**: 226
- **Total de Colunas**: 9
- **Chave Primária**: CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOGCONTROLE** é uma tabela que armazena logs de alterações em parâmetros de controle do sistema. Com **226 registros**, representa um histórico de mudanças em parâmetros, incluindo informações sobre usuário, IP, aplicação e valores antigos e novos.

Esta tabela funciona como **log de alterações de parâmetros de controle** e permite:
- Registrar todas as alterações em parâmetros de controle
- Armazenar valores antigos e novos de parâmetros
- Identificar usuário e aplicação da alteração
- Rastrear endereço IP e data/hora da alteração
- Facilitar auditoria de alterações de configuração
- Manter histórico detalhado de mudanças

Cada registro representa uma alteração específica em um parâmetro de controle, contendo:
- Código do log (CODIGO)
- Usuário do sistema (SYSTEM_USER)
- Endereço IP (IP)
- Data da alteração (DATA)
- Hora da alteração (HORA)
- Nome do parâmetro (PARAMETRO)
- Valor antigo (VR_ANTIGO)
- Valor novo (VR_NOVO)
- Aplicação utilizada (APLICACAO)

O sistema utiliza esta tabela para manter histórico completo de alterações em parâmetros de controle, permitindo auditoria detalhada e rastreamento de mudanças.

**Observação Importante:** LOGCONTROLE é uma tabela de log de alterações de parâmetros de controle. Com 226 registros, indica uso moderado desta funcionalidade de auditoria. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de usuários através do campo SYSTEM_USER.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGO** 🔑 | INTEGER | ✓ | Código do log de controle (PK) |

### Informações da Alteração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SYSTEM_USER** | VARCHAR(37) | | Usuário do sistema que realizou a alteração |
| **IP** | VARCHAR(37) | | Endereço IP da alteração |
| **DATA** | DATE | | Data da alteração |
| **HORA** | TIME | | Hora da alteração |
| **PARAMETRO** | VARCHAR(37) | | Nome do parâmetro alterado |
| **VR_ANTIGO** | VARCHAR(37) | | Valor antigo do parâmetro |
| **VR_NOVO** | VARCHAR(37) | | Valor novo do parâmetro |
| **APLICACAO** | VARCHAR(37) | | Aplicação utilizada |

**Primary Key:** CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOGCONTROLE Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOGCONTROLE é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOGCONTROLE diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via SYSTEM_USER → Tabelas de Usuários

**Fluxo:** LOGCONTROLE → USUARIO → Operações

**Descrição:** Através do nome do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Controle

**Objetivo:** Obter informações de um log específico.

```sql
SELECT
    CODIGO,
    SYSTEM_USER,
    IP,
    DATA,
    HORA,
    PARAMETRO,
    VR_ANTIGO,
    VR_NOVO,
    APLICACAO
FROM LOGCONTROLE
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
    VR_ANTIGO,
    VR_NOVO,
    APLICACAO
FROM LOGCONTROLE
WHERE PARAMETRO = ?
ORDER BY DATA DESC, HORA DESC;
```

---

### 3. Análise de Alterações por Usuário

**Objetivo:** Identificar distribuição de alterações por usuário.

**Query SQL:**
```sql
SELECT
    SYSTEM_USER,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT PARAMETRO) AS TOTAL_PARAMETROS_AFETADOS
FROM LOGCONTROLE
WHERE SYSTEM_USER IS NOT NULL
GROUP BY SYSTEM_USER
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
FROM LOGCONTROLE
WHERE DATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATA), EXTRACT(MONTH FROM DATA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOGCONTROLE | Tipo |
|--------|-----------|-------------------------|------|
| **LOGCONTROLE** | 226 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **226 alterações** de parâmetros de controle registradas no sistema
- Indica uso moderado desta funcionalidade de auditoria

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes)
CREATE INDEX IDX_LOGCONTROLE_DATA ON LOGCONTROLE(DATA)
    WHERE DATA IS NOT NULL;

-- Índice 2: Busca por parâmetro (consultas frequentes)
CREATE INDEX IDX_LOGCONTROLE_PARAMETRO ON LOGCONTROLE(PARAMETRO)
    WHERE PARAMETRO IS NOT NULL;

-- Índice 3: Busca por usuário (consultas frequentes)
CREATE INDEX IDX_LOGCONTROLE_USUARIO ON LOGCONTROLE(SYSTEM_USER)
    WHERE SYSTEM_USER IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogcontrole extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOGCONTROLE';
    
    protected $primaryKey = 'CODIGO';
    public $incrementing = true;

    protected $casts = [
        'CODIGO' => 'integer',
        'SYSTEM_USER' => 'string',
        'IP' => 'string',
        'DATA' => 'date',
        'HORA' => 'string',
        'PARAMETRO' => 'string',
        'VR_ANTIGO' => 'string',
        'VR_NOVO' => 'string',
        'APLICACAO' => 'string',
    ];

    public function scopePorParametro($query, string $parametro)
    {
        return $query->where('PARAMETRO', $parametro);
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

