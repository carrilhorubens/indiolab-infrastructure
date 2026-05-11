# LOGINTEGRACAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOGINTEGRACAO (Log de Integrações)
- **Total de Registros**: 6.069
- **Total de Colunas**: 9
- **Chave Primária**: Nenhuma (tabela sem PK formal)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOGINTEGRACAO** é uma tabela que armazena logs de integrações com sistemas externos. Com **6.069 registros**, representa um histórico de integrações, incluindo informações sobre requisições, respostas, erros e códigos HTTP.

Esta tabela funciona como **log de integrações** e permite:
- Registrar todas as integrações com sistemas externos
- Armazenar requisições e respostas completas
- Rastrear erros e códigos HTTP
- Identificar cliente, sistema e usuário da integração
- Facilitar auditoria de integrações
- Manter histórico detalhado de comunicações

Cada registro representa uma integração específica, contendo:
- Data do log (DATALOG)
- Descrição da integração (DESCRICAO)
- Cliente da integração (CLIENTE)
- Log de erro (LOGERRO)
- Sistema integrado (SISTEMA)
- Requisição HTTP (REQUEST)
- Resposta HTTP (RESPONSE)
- Código HTTP (HTTPCODE)
- Usuário da integração (USUARIO)

O sistema utiliza esta tabela para manter histórico completo de integrações com sistemas externos, permitindo auditoria detalhada e análise de problemas.

**Observação Importante:** LOGINTEGRACAO é uma tabela de log de integrações. Com 6.069 registros, indica uso moderado desta funcionalidade. Não possui chave primária formal, o que pode indicar que é uma tabela de log puro sem necessidade de identificação única. Não possui relacionamentos diretos com outras tabelas.

---

## 🔑 Estrutura de Colunas

### Informações da Integração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATALOG** | TIMESTAMP | ✓ | Data do log de integração |
| **DESCRICAO** | VARCHAR(37) | ✓ | Descrição da integração |
| **CLIENTE** | VARCHAR(37) | ✓ | Cliente da integração |
| **LOGERRO** | VARCHAR(261) | ✓ | Log de erro da integração |
| **SISTEMA** | VARCHAR(37) | ✓ | Sistema integrado |
| **REQUEST** | VARCHAR(261) | | Requisição HTTP |
| **RESPONSE** | VARCHAR(261) | | Resposta HTTP |
| **HTTPCODE** | VARCHAR(37) | | Código HTTP da resposta |
| **USUARIO** | VARCHAR(37) | | Usuário da integração |

**Primary Key:** Nenhuma (tabela sem PK formal)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOGINTEGRACAO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOGINTEGRACAO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOGINTEGRACAO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via CLIENTE → Tabelas de Clientes

**Fluxo:** LOGINTEGRACAO → CLIEN → Operações

**Descrição:** Através do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de clientes.

---

### Via USUARIO → Tabelas de Usuários

**Fluxo:** LOGINTEGRACAO → USUARIO → Operações

**Descrição:** Através do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de logs através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Logs de Integração

**Objetivo:** Obter logs de integração filtrados por critérios específicos.

```sql
SELECT
    DATALOG,
    DESCRICAO,
    CLIENTE,
    SISTEMA,
    HTTPCODE,
    USUARIO
FROM LOGINTEGRACAO
WHERE DATALOG >= ?
ORDER BY DATALOG DESC
ROWS 100;
```

---

### 2. Listar Integrações de um Sistema

**Objetivo:** Obter todas as integrações de um sistema específico.

```sql
SELECT
    DATALOG,
    DESCRICAO,
    CLIENTE,
    HTTPCODE,
    LOGERRO
FROM LOGINTEGRACAO
WHERE SISTEMA = ?
ORDER BY DATALOG DESC;
```

---

### 3. Análise de Integrações por Status HTTP

**Objetivo:** Identificar distribuição de integrações por código HTTP.

**Query SQL:**
```sql
SELECT
    HTTPCODE,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT CLIENTE) AS TOTAL_CLIENTES,
    COUNT(DISTINCT SISTEMA) AS TOTAL_SISTEMAS
FROM LOGINTEGRACAO
WHERE HTTPCODE IS NOT NULL
GROUP BY HTTPCODE
ORDER BY TOTAL_INTEGRACOES DESC;
```

---

### 4. Análise de Integrações com Erros

**Objetivo:** Identificar integrações que possuem erros.

**Query SQL:**
```sql
SELECT
    SISTEMA,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(CASE WHEN LOGERRO IS NOT NULL AND LOGERRO != '' THEN 1 END) AS TOTAL_COM_ERRO,
    COUNT(CASE WHEN HTTPCODE NOT IN ('200', '201', '204') THEN 1 END) AS TOTAL_COM_ERRO_HTTP
FROM LOGINTEGRACAO
GROUP BY SISTEMA
ORDER BY TOTAL_COM_ERRO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOGINTEGRACAO | Tipo |
|--------|-----------|---------------------------|------|
| **LOGINTEGRACAO** | 6.069 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **6.069 integrações** registradas no sistema
- Indica uso moderado desta funcionalidade de integração

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_LOGINTEGRACAO_DATALOG ON LOGINTEGRACAO(DATALOG)
    WHERE DATALOG IS NOT NULL;

-- Índice 2: Busca por sistema (consultas frequentes)
CREATE INDEX IDX_LOGINTEGRACAO_SISTEMA ON LOGINTEGRACAO(SISTEMA)
    WHERE SISTEMA IS NOT NULL;

-- Índice 3: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_LOGINTEGRACAO_CLIENTE ON LOGINTEGRACAO(CLIENTE)
    WHERE CLIENTE IS NOT NULL;

-- Índice 4: Busca por código HTTP (consultas frequentes)
CREATE INDEX IDX_LOGINTEGRACAO_HTTPCODE ON LOGINTEGRACAO(HTTPCODE)
    WHERE HTTPCODE IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogintegracao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOGINTEGRACAO';
    
    public $incrementing = false;
    public $timestamps = false;

    protected $casts = [
        'DATALOG' => 'datetime',
        'DESCRICAO' => 'string',
        'CLIENTE' => 'string',
        'LOGERRO' => 'string',
        'SISTEMA' => 'string',
        'REQUEST' => 'string',
        'RESPONSE' => 'string',
        'HTTPCODE' => 'string',
        'USUARIO' => 'string',
    ];

    public function scopePorSistema($query, string $sistema)
    {
        return $query->where('SISTEMA', $sistema);
    }

    public function scopePorCliente($query, string $cliente)
    {
        return $query->where('CLIENTE', $cliente);
    }

    public function scopePorHttpCode($query, string $httpCode)
    {
        return $query->where('HTTPCODE', $httpCode);
    }

    public function scopeComErro($query)
    {
        return $query->whereNotNull('LOGERRO')
                     ->where('LOGERRO', '!=', '');
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATALOG', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('DATALOG', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

