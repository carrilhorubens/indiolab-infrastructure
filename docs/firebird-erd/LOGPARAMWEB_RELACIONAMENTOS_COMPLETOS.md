# LOGPARAMWEB - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOGPARAMWEB (Log de Parâmetros Web)
- **Total de Registros**: 383
- **Total de Colunas**: 7
- **Chave Primária**: CODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOGPARAMWEB** é uma tabela que armazena logs de alterações em parâmetros da aplicação web. Com **383 registros**, representa um histórico de mudanças em parâmetros web, incluindo informações sobre usuário, IP e valores antigos e novos.

Esta tabela funciona como **log de alterações de parâmetros web** e permite:
- Registrar todas as alterações em parâmetros da aplicação web
- Armazenar valores antigos e novos de parâmetros
- Identificar usuário e IP da alteração
- Rastrear data/hora da alteração
- Facilitar auditoria de alterações de configuração web
- Manter histórico detalhado de mudanças

Cada registro representa uma alteração específica em um parâmetro web, contendo:
- Código do log (CODIGO)
- Usuário do sistema (SYSTEM_USER)
- Endereço IP (IP)
- Data/hora da alteração (DATAHORA)
- Nome do parâmetro (PARAMETRO)
- Valor antigo (VR_ANTIGO)
- Valor novo (VR_NOVO)

O sistema utiliza esta tabela para manter histórico completo de alterações em parâmetros web, permitindo auditoria detalhada e rastreamento de mudanças.

**Observação Importante:** LOGPARAMWEB é uma tabela de log de alterações de parâmetros web. Com 383 registros, indica uso moderado desta funcionalidade de auditoria. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de usuários através do campo SYSTEM_USER.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGO** 🔑 | INTEGER | ✓ | Código do log de parâmetro web (PK) |

### Informações da Alteração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SYSTEM_USER** | VARCHAR(37) | | Usuário do sistema que realizou a alteração |
| **IP** | VARCHAR(37) | | Endereço IP da alteração |
| **DATAHORA** | TIMESTAMP | | Data/hora da alteração |
| **PARAMETRO** | VARCHAR(37) | | Nome do parâmetro alterado |
| **VR_ANTIGO** | VARCHAR(37) | | Valor antigo do parâmetro |
| **VR_NOVO** | VARCHAR(37) | | Valor novo do parâmetro |

**Primary Key:** CODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOGPARAMWEB Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOGPARAMWEB é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOGPARAMWEB diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via SYSTEM_USER → Tabelas de Usuários

**Fluxo:** LOGPARAMWEB → USUARIO → Operações

**Descrição:** Através do nome do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Parâmetro Web

**Objetivo:** Obter informações de um log específico.

```sql
SELECT
    CODIGO,
    SYSTEM_USER,
    IP,
    DATAHORA,
    PARAMETRO,
    VR_ANTIGO,
    VR_NOVO
FROM LOGPARAMWEB
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
    DATAHORA,
    VR_ANTIGO,
    VR_NOVO
FROM LOGPARAMWEB
WHERE PARAMETRO = ?
ORDER BY DATAHORA DESC;
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
FROM LOGPARAMWEB
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
    EXTRACT(YEAR FROM DATAHORA) AS ANO,
    EXTRACT(MONTH FROM DATAHORA) AS MES,
    COUNT(*) AS TOTAL_ALTERACOES,
    COUNT(DISTINCT PARAMETRO) AS TOTAL_PARAMETROS_AFETADOS
FROM LOGPARAMWEB
WHERE DATAHORA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATAHORA), EXTRACT(MONTH FROM DATAHORA)
ORDER BY ANO DESC, MES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOGPARAMWEB | Tipo |
|--------|-----------|-------------------------|------|
| **LOGPARAMWEB** | 383 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **383 alterações** de parâmetros web registradas no sistema
- Indica uso moderado desta funcionalidade de auditoria

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data/hora (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOGPARAMWEB_DATAHORA ON LOGPARAMWEB(DATAHORA)
    WHERE DATAHORA IS NOT NULL;

-- Índice 2: Busca por parâmetro (consultas frequentes)
CREATE INDEX IDX_LOGPARAMWEB_PARAMETRO ON LOGPARAMWEB(PARAMETRO)
    WHERE PARAMETRO IS NOT NULL;

-- Índice 3: Busca por usuário (consultas frequentes)
CREATE INDEX IDX_LOGPARAMWEB_USUARIO ON LOGPARAMWEB(SYSTEM_USER)
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

final class FirebirdLogparamweb extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOGPARAMWEB';
    
    protected $primaryKey = 'CODIGO';
    public $incrementing = true;

    protected $casts = [
        'CODIGO' => 'integer',
        'SYSTEM_USER' => 'string',
        'IP' => 'string',
        'DATAHORA' => 'datetime',
        'PARAMETRO' => 'string',
        'VR_ANTIGO' => 'string',
        'VR_NOVO' => 'string',
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
        return $query->whereBetween('DATAHORA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('DATAHORA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

