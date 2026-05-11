# MONXAPLICACOES - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MONXAPLICACOES (Monitoramento de Aplicações)
- **Total de Registros**: 16
- **Total de Colunas**: 7
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MONXAPLICACOES** é uma tabela que armazena informações sobre monitoramento de aplicações conectadas ao banco de dados Firebird. Com **16 registros**, representa aplicações atualmente conectadas ou recentemente conectadas, incluindo informações sobre versão do engine, endereço do cliente, processo e configurações de lock.

Esta tabela funciona como **monitoramento de aplicações** e permite:
- Monitorar aplicações conectadas ao banco de dados
- Armazenar informações sobre versão do engine e cliente
- Rastrear processos e PIDs de aplicações
- Controlar configurações de lock e timeout
- Identificar aplicações em modo somente leitura
- Facilitar gestão e monitoramento de conexões
- Manter histórico detalhado de aplicações

Cada registro representa uma aplicação específica conectada, contendo:
- ID da aplicação (ID)
- Versão do engine (ENGINE_VERSION)
- Endereço do cliente (CLIENT_ADDRESS)
- Processo do cliente (CLIENT_PROCESS)
- PID do cliente (CLIENT_PID)
- Timeout de lock (LOCK_TIMEOUT)
- Indicador de somente leitura (READ_ONLY)

O sistema utiliza esta tabela para manter histórico completo de aplicações conectadas, permitindo monitoramento e gestão de conexões.

**Observação Importante:** MONXAPLICACOES é uma tabela de monitoramento de aplicações. Com 16 registros, indica uso moderado desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com outras tabelas de monitoramento através de campos como CLIENT_ADDRESS e CLIENT_PROCESS.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID da aplicação (PK) |

### Informações da Aplicação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ENGINE_VERSION** | VARCHAR(37) | | Versão do engine do Firebird |
| **CLIENT_ADDRESS** | VARCHAR(37) | | Endereço IP do cliente |
| **CLIENT_PROCESS** | VARCHAR(37) | | Nome do processo do cliente |
| **CLIENT_PID** | VARCHAR(37) | | PID do processo do cliente |
| **LOCK_TIMEOUT** | VARCHAR(37) | | Timeout de lock em segundos |
| **READ_ONLY** | VARCHAR(37) | | Indicador de modo somente leitura |

**Primary Key:** ID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MONXAPLICACOES Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MONXAPLICACOES é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MONXAPLICACOES diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via CLIENT_ADDRESS → Outras Operações

**Fluxo:** MONXAPLICACOES → Operações por Endereço

**Descrição:** Através do endereço do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de aplicações através de endereços de cliente.

---

### Via CLIENT_PROCESS → Outras Operações

**Fluxo:** MONXAPLICACOES → Operações por Processo

**Descrição:** Através do processo do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de aplicações através de processos.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Aplicação

**Objetivo:** Obter informações de uma aplicação específica.

```sql
SELECT
    ID,
    ENGINE_VERSION,
    CLIENT_ADDRESS,
    CLIENT_PROCESS,
    CLIENT_PID,
    LOCK_TIMEOUT,
    READ_ONLY
FROM MONXAPLICACOES
WHERE ID = ?;
```

---

### 2. Listar Aplicações por Endereço

**Objetivo:** Obter todas as aplicações de um endereço específico.

```sql
SELECT
    ID,
    CLIENT_PROCESS,
    CLIENT_PID,
    LOCK_TIMEOUT,
    READ_ONLY
FROM MONXAPLICACOES
WHERE CLIENT_ADDRESS = ?
ORDER BY CLIENT_PROCESS;
```

---

### 3. Análise de Aplicações por Versão

**Objetivo:** Identificar distribuição de aplicações por versão do engine.

**Query SQL:**
```sql
SELECT
    ENGINE_VERSION,
    COUNT(*) AS TOTAL_APLICACOES,
    COUNT(DISTINCT CLIENT_ADDRESS) AS TOTAL_ENDERECOS
FROM MONXAPLICACOES
WHERE ENGINE_VERSION IS NOT NULL
GROUP BY ENGINE_VERSION
ORDER BY TOTAL_APLICACOES DESC;
```

---

### 4. Buscar Aplicações em Modo Somente Leitura

**Objetivo:** Obter aplicações que estão em modo somente leitura.

```sql
SELECT
    ID,
    CLIENT_ADDRESS,
    CLIENT_PROCESS,
    CLIENT_PID
FROM MONXAPLICACOES
WHERE READ_ONLY = '1' OR READ_ONLY = 'TRUE';
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MONXAPLICACOES | Tipo |
|--------|-----------|---------------------------|------|
| **MONXAPLICACOES** | 16 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **16 aplicações** registradas no sistema
- Indica uso moderado desta funcionalidade de monitoramento

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por endereço (consultas frequentes)
CREATE INDEX IDX_MONXAPLICACOES_ENDERECO ON MONXAPLICACOES(CLIENT_ADDRESS)
    WHERE CLIENT_ADDRESS IS NOT NULL;

-- Índice 2: Busca por processo (consultas frequentes)
CREATE INDEX IDX_MONXAPLICACOES_PROCESSO ON MONXAPLICACOES(CLIENT_PROCESS)
    WHERE CLIENT_PROCESS IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMonxaplicacoes extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MONXAPLICACOES';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'ENGINE_VERSION' => 'string',
        'CLIENT_ADDRESS' => 'string',
        'CLIENT_PROCESS' => 'string',
        'CLIENT_PID' => 'string',
        'LOCK_TIMEOUT' => 'string',
        'READ_ONLY' => 'string',
    ];

    public function scopePorEndereco($query, string $endereco)
    {
        return $query->where('CLIENT_ADDRESS', $endereco);
    }

    public function scopePorProcesso($query, string $processo)
    {
        return $query->where('CLIENT_PROCESS', $processo);
    }

    public function scopeSomenteLeitura($query)
    {
        return $query->whereIn('READ_ONLY', ['1', 'TRUE']);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('CLIENT_ADDRESS')->orderBy('CLIENT_PROCESS');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

