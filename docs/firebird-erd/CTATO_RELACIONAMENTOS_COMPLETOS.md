# CTATO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTATO (Contatos Adicionais)
- **Total de Registros**: 705
- **Total de Colunas**: 9
- **Chave Primária**: Composta (CLICODIGO, CTOCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTATO** é uma tabela que armazena informações detalhadas de contatos adicionais de clientes, estendendo os dados básicos de CLINET. Com **705 registros**, representa contatos detalhados com informações como nome completo, data de nascimento, ramal, cargo, DDD e telefone.

Esta tabela funciona como **extensão de contatos de clientes** e permite:
- Armazenar informações detalhadas de contatos
- Associar contatos a CLINET (contatos base)
- Manter dados pessoais de contatos (nome, data de nascimento)
- Armazenar informações profissionais (cargo, ramal)
- Gerenciar informações de contato (DDD, telefone)
- Suportar múltiplos contatos por cliente

Cada registro representa um contato detalhado de um cliente, contendo:
- Cliente relacionado (CLICODIGO)
- Código do contato (CTOCODIGO)
- Nome do contato (CTONOME)
- Data de nascimento (CTODTNASCTO)
- Ramal (CTORAMAL)
- Cargo (CTOCARGO)
- DDD (CTODDD)
- Telefone (CTOFONE)
- Código do contato base em CLINET (NETCODIGO)

O sistema utiliza esta tabela para gerenciar informações detalhadas de contatos de clientes, complementando CLINET com dados adicionais.

**Observação Importante:** CTATO estende CLINET fornecendo informações detalhadas de contatos. Com 705 registros e chave primária composta (CLICODIGO, CTOCODIGO), permite múltiplos contatos detalhados por cliente.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑 🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **CTOCODIGO** 🔑 | SMALLINT | ✓ | Código sequencial do contato (PK) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NETCODIGO** 🔗 | SMALLINT | | Código do contato base em CLINET (FK → CLINET) |

### Informações Pessoais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTONOME** | VARCHAR(37) | ✓ | Nome completo do contato |
| **CTODTNASCTO** | DATE | | Data de nascimento do contato |

### Informações Profissionais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTOCARGO** | VARCHAR(37) | | Cargo do contato |
| **CTORAMAL** | VARCHAR(37) | | Ramal do contato |

### Informações de Contato
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTODDD** | VARCHAR(37) | | DDD (código de área) |
| **CTOFONE** | VARCHAR(37) | | Número de telefone |

**Primary Key:** (CLICODIGO, CTOCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente ao qual o contato pertence.
- **CTOCODIGO**: Código sequencial que identifica cada contato detalhado do cliente.
- **NETCODIGO**: Código do contato base em CLINET ao qual este contato detalhado está associado.
- **CTONOME**: Nome completo do contato.
- **CTODTNASCTO**: Data de nascimento do contato.
- **CTOCARGO**: Cargo ou função do contato na empresa do cliente.
- **CTORAMAL**: Ramal telefônico do contato.
- **CTODDD**: Código de área (DDD) do telefone.
- **CTOFONE**: Número de telefone do contato.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTATO Referencia (3 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CTATO.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CTATO
```

**Descrição**: Cada contato detalhado está vinculado a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** ~9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos

**Uso:** Identificar o cliente do contato, obter informações do cliente.

---

#### 2. CLINET - Contatos Base (via CLICODIGO)
**Relacionamento:**
```
CTATO.CLICODIGO → CLINET.CLICODIGO (N:1)
Constraint: CLINET_CTATO
```

**Descrição**: Cada contato detalhado está vinculado a um contato base em CLINET através do cliente.

**Informações da Tabela CLINET:**
- **Total:** 2.868 contatos base
- **PK:** (CLICODIGO, NETCODIGO)
- **Colunas:** 5 campos

**Uso:** Associar contato detalhado a contato base.

---

#### 3. CLINET - Contatos Base (via NETCODIGO)
**Relacionamento:**
```
CTATO.CLICODIGO, CTATO.NETCODIGO → CLINET.CLICODIGO, CLINET.NETCODIGO (N:1)
Constraint: CLINET_CTATO
```

**Descrição**: Cada contato detalhado está vinculado a um contato base específico em CLINET através da chave composta.

**Uso:** Obter informações do contato base relacionado.

---

### CTATO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTATO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLICODIGO → CLIEN → Outras Operações do Cliente

**Fluxo:** CTATO → CLIEN → Operações

**Descrição:** Através do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de contatos por cliente.

---

### Via NETCODIGO → CLINET → Informações do Contato Base

**Fluxo:** CTATO → CLINET → Informações

**Descrição:** Através do contato base, é possível identificar informações relacionadas.

**Uso:** Análise de contatos detalhados por contato base.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Contato

**Objetivo:** Obter visão completa de um contato incluindo informações do cliente e contato base.

**Fluxo:**
```
CTATO (CLICODIGO, CTOCODIGO, NETCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
CLINET (CLICODIGO, NETCODIGO)
```

**Query SQL:**
```sql
SELECT
    ct.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ct.CTOCODIGO,
    ct.CTONOME AS NOME_CONTATO,
    ct.CTODTNASCTO AS DATA_NASCIMENTO,
    ct.CTOCARGO AS CARGO,
    ct.CTORAMAL AS RAMAL,
    ct.CTODDD AS DDD,
    ct.CTOFONE AS TELEFONE,
    cn.NETTIPO AS TIPO_CONTATO_BASE,
    cn.NETENDERECO AS ENDERECO_CONTATO_BASE
FROM CTATO ct
INNER JOIN CLIEN cl ON cl.CLICODIGO = ct.CLICODIGO
LEFT JOIN CLINET cn ON cn.CLICODIGO = ct.CLICODIGO
                  AND cn.NETCODIGO = ct.NETCODIGO
WHERE ct.CLICODIGO = ?
  AND ct.CTOCODIGO = ?;
```

---

### Exemplo 2: Análise de Contatos por Cliente

**Objetivo:** Obter todos os contatos detalhados de um cliente específico.

**Query SQL:**
```sql
SELECT
    CTOCODIGO,
    CTONOME AS NOME_CONTATO,
    CTODTNASCTO AS DATA_NASCIMENTO,
    CTOCARGO AS CARGO,
    CTORAMAL AS RAMAL,
    CTODDD AS DDD,
    CTOFONE AS TELEFONE,
    NETCODIGO AS CODIGO_CONTATO_BASE
FROM CTATO
WHERE CLICODIGO = ?
ORDER BY CTOCODIGO;
```

---

### Exemplo 3: Análise de Contatos por Cargo

**Objetivo:** Identificar contatos agrupados por cargo.

**Query SQL:**
```sql
SELECT
    CTOCARGO AS CARGO,
    COUNT(*) AS TOTAL_CONTATOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES
FROM CTATO
WHERE CTOCARGO IS NOT NULL
  AND CTOCARGO != ''
GROUP BY CTOCARGO
ORDER BY TOTAL_CONTATOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Contato

**Objetivo:** Obter informações de um contato específico.

```sql
SELECT
    CLICODIGO,
    CTOCODIGO,
    CTONOME AS NOME_CONTATO,
    CTODTNASCTO AS DATA_NASCIMENTO,
    CTOCARGO AS CARGO,
    CTORAMAL AS RAMAL,
    CTODDD AS DDD,
    CTOFONE AS TELEFONE,
    NETCODIGO AS CODIGO_CONTATO_BASE
FROM CTATO
WHERE CLICODIGO = ?
  AND CTOCODIGO = ?;
```

---

### 2. Listar Contatos de um Cliente

**Objetivo:** Obter todos os contatos detalhados de um cliente específico.

```sql
SELECT
    CTOCODIGO,
    CTONOME AS NOME_CONTATO,
    CTODTNASCTO AS DATA_NASCIMENTO,
    CTOCARGO AS CARGO,
    CTORAMAL AS RAMAL,
    CTODDD AS DDD,
    CTOFONE AS TELEFONE
FROM CTATO
WHERE CLICODIGO = ?
ORDER BY CTOCODIGO;
```

---

### 3. Buscar Contatos por Telefone

**Objetivo:** Encontrar contatos que tenham um telefone específico.

```sql
SELECT
    ct.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ct.CTOCODIGO,
    ct.CTONOME AS NOME_CONTATO,
    ct.CTODDD AS DDD,
    ct.CTOFONE AS TELEFONE
FROM CTATO ct
INNER JOIN CLIEN cl ON cl.CLICODIGO = ct.CLICODIGO
WHERE ct.CTODDD = ?
  AND ct.CTOFONE = ?;
```

---

### 4. Análise de Contatos por Cargo

**Objetivo:** Identificar distribuição de contatos por cargo.

```sql
SELECT
    CTOCARGO AS CARGO,
    COUNT(*) AS TOTAL_CONTATOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES
FROM CTATO
WHERE CTOCARGO IS NOT NULL
  AND CTOCARGO != ''
GROUP BY CTOCARGO
ORDER BY TOTAL_CONTATOS DESC;
```

---

### 5. Análise de Contatos com Data de Nascimento

**Objetivo:** Identificar contatos com data de nascimento cadastrada.

**Query SQL:**
```sql
SELECT
    ct.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ct.CTONOME AS NOME_CONTATO,
    ct.CTODTNASCTO AS DATA_NASCIMENTO,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM ct.CTODTNASCTO) AS IDADE
FROM CTATO ct
INNER JOIN CLIEN cl ON cl.CLICODIGO = ct.CLICODIGO
WHERE ct.CTODTNASCTO IS NOT NULL
ORDER BY ct.CTODTNASCTO DESC;
```

---

### 6. Análise de Contatos por Ramal

**Objetivo:** Identificar contatos que possuem ramal cadastrado.

**Query SQL:**
```sql
SELECT
    ct.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    ct.CTONOME AS NOME_CONTATO,
    ct.CTORAMAL AS RAMAL,
    ct.CTODDD AS DDD,
    ct.CTOFONE AS TELEFONE
FROM CTATO ct
INNER JOIN CLIEN cl ON cl.CLICODIGO = ct.CLICODIGO
WHERE ct.CTORAMAL IS NOT NULL
  AND ct.CTORAMAL != ''
ORDER BY ct.CLICODIGO, ct.CTOCODIGO;
```

---

### 7. Relatório Completo de Contatos

**Objetivo:** Analisar distribuição completa de contatos no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CONTATOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_COM_CONTATO,
    COUNT(CASE WHEN CTODTNASCTO IS NOT NULL THEN 1 END) AS CONTATOS_COM_DATA_NASCIMENTO,
    COUNT(CASE WHEN CTOCARGO IS NOT NULL AND CTOCARGO != '' THEN 1 END) AS CONTATOS_COM_CARGO,
    COUNT(CASE WHEN CTORAMAL IS NOT NULL AND CTORAMAL != '' THEN 1 END) AS CONTATOS_COM_RAMAL,
    COUNT(CASE WHEN CTOFONE IS NOT NULL AND CTOFONE != '' THEN 1 END) AS CONTATOS_COM_TELEFONE,
    COUNT(CASE WHEN NETCODIGO IS NOT NULL THEN 1 END) AS CONTATOS_VINCULADOS_CLINET
FROM CTATO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CTATO | Tipo |
|--------|-----------|-------------------|------|
| **CTATO** | 705 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | ~9.251 | 1:0.08 | Clientes (média de ~0.08 contatos detalhados por cliente) |
| CLINET | 2.868 | 1:0.25 | Contatos base (média de ~0.25 contatos detalhados por contato base) |

**Interpretação:**
- **705 contatos detalhados** cadastrados no sistema
- **Média de ~0.08 contatos detalhados por cliente** - indica uso seletivo desta tabela
- **Média de ~0.25 contatos detalhados por contato base** - indica que nem todos os contatos base têm detalhamento

---

## 🚀 Performance e Otimização

### Índices Existentes

Nenhum índice específico além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente (já coberto pela PK)
3. **Índice por contato base** - Para buscas por NETCODIGO
4. **Índice por telefone** - Para buscas por telefone
5. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por contato base (consultas frequentes)
CREATE INDEX IDX_CTATO_CONTATO_BASE ON CTATO(CLICODIGO, NETCODIGO)
    WHERE NETCODIGO IS NOT NULL;

-- Índice 2: Busca por telefone (consultas frequentes)
CREATE INDEX IDX_CTATO_TELEFONE ON CTATO(CTODDD, CTOFONE)
    WHERE CTOFONE IS NOT NULL AND CTOFONE != '';

-- Índice 3: Busca por cargo (consultas de análise)
CREATE INDEX IDX_CTATO_CARGO ON CTATO(CTOCARGO)
    WHERE CTOCARGO IS NOT NULL AND CTOCARGO != '';
```

### Observações sobre Volume

- **Tabela pequena** (705 registros) - Performance boa mesmo sem índices adicionais
- **Chave primária composta** - (CLICODIGO, CTOCODIGO) já fornece índice eficiente para buscas por cliente
- **Consultas frequentes** - Contatos são consultados durante operações com clientes
- **Índices opcionais** - Devido ao volume pequeno, índices adicionais são opcionais mas podem melhorar performance em consultas específicas

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar contatos sem cliente válido
SELECT ct.*
FROM CTATO ct
LEFT JOIN CLIEN cl ON cl.CLICODIGO = ct.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar contatos sem contato base válido (quando informado)
SELECT ct.*
FROM CTATO ct
WHERE ct.NETCODIGO IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM CLINET cn 
      WHERE cn.CLICODIGO = ct.CLICODIGO
        AND cn.NETCODIGO = ct.NETCODIGO
  );
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CTATO
WHERE CLICODIGO IS NULL
   OR CTOCODIGO IS NULL
   OR CTONOME IS NULL
   OR CTONOME = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, CTOCODIGO, COUNT(*) AS QTD
FROM CTATO
GROUP BY CLICODIGO, CTOCODIGO
HAVING COUNT(*) > 1;

-- Verificar datas inconsistentes
SELECT *
FROM CTATO
WHERE CTODTNASCTO IS NOT NULL
  AND CTODTNASCTO > CURRENT_DATE;
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

final class FirebirdCtato extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTATO';
    
    protected $primaryKey = ['CLICODIGO', 'CTOCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'CTOCODIGO' => 'integer',
        'NETCODIGO' => 'integer',
        'CTONOME' => 'string',
        'CTODTNASCTO' => 'date',
        'CTOCARGO' => 'string',
        'CTORAMAL' => 'string',
        'CTODDD' => 'string',
        'CTOFONE' => 'string',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com CLINET
    public function contatoBase(): BelongsTo
    {
        return $this->belongsTo(FirebirdClinet::class, ['CLICODIGO', 'NETCODIGO'], 
                               ['CLICODIGO', 'NETCODIGO']);
    }

    // Método para obter telefone completo
    public function getTelefoneCompletoAttribute(): string
    {
        $ddd = $this->CTODDD ? "({$this->CTODDD}) " : '';
        $fone = $this->CTOFONE ?? '';
        return trim($ddd . $fone);
    }

    // Método para calcular idade
    public function getIdadeAttribute(): ?int
    {
        if (!$this->CTODTNASCTO) {
            return null;
        }
        
        return (int)now()->diffInYears($this->CTODTNASCTO);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por cargo
    public function scopePorCargo($query, string $cargo)
    {
        return $query->where('CTOCARGO', $cargo);
    }

    // Scope para buscar por telefone
    public function scopePorTelefone($query, string $ddd, string $fone)
    {
        return $query->where('CTODDD', $ddd)
                     ->where('CTOFONE', $fone);
    }

    // Método estático para buscar próxima sequência para um cliente
    public static function proximaSequencia(int $clienteCodigo): int
    {
        $maxSeq = self::where('CLICODIGO', $clienteCodigo)->max('CTOCODIGO');
        return ($maxSeq ?? 0) + 1;
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - (CLICODIGO, CTOCODIGO) identifica unicamente cada contato detalhado
2. **Validação antes de inserir** - Verificar se cliente existe
3. **Evitar duplicatas** - PK composta previne duplicatas
4. **Validação de telefone** - Verificar formato de DDD e telefone
5. **Validação de datas** - Verificar que data de nascimento é válida

### Performance

1. **Tabela pequena** - 705 registros, performance boa mesmo sem índices adicionais
2. **Índices opcionais** - Devido ao volume pequeno, índices adicionais são opcionais
3. **Consultas frequentes** - Contatos são consultados durante operações com clientes
4. **Cache recomendado** - Tabela pequena, ideal para cache em memória

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cliente existe
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de telefone** - Verificar formato de DDD e telefone
5. **Validação de datas** - Verificar que datas são válidas

### Manutenção

1. **Revisão periódica** - Verificar contatos desatualizados
2. **Padronização** - Manter estrutura de dados consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela importante para gestão de clientes
5. **Limpeza** - Considerar arquivar contatos inativos

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

