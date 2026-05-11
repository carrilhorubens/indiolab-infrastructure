# CLINET - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLINET (Contatos de Cliente)
- **Total de Registros**: 2.868
- **Total de Colunas**: 5
- **Chave Primária**: (CLICODIGO, NETCODIGO) - Composta
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 4 (CTATO, PARAMCLINET)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLINET** é uma tabela de contatos que armazena informações de contato (telefone, email, etc.) para clientes. Com **2.868 registros**, representa múltiplos contatos por cliente, permitindo que cada cliente tenha vários telefones, emails ou outros tipos de contato.

Esta tabela funciona como **cadastro de contatos por cliente** e permite:
- Armazenar múltiplos contatos por cliente
- Suportar diferentes tipos de contato (telefone, email, etc.)
- Manter histórico de atualizações de contatos
- Facilitar comunicação com clientes
- Suportar diferentes formatos de endereço de contato

Cada registro representa um contato específico de um cliente, contendo:
- Identificação do cliente (CLICODIGO)
- Código sequencial do contato (NETCODIGO)
- Tipo de contato (NETTIPO)
- Endereço do contato (NETENDERECO)
- Data de atualização (NETTDATUALIZACAO)

O sistema utiliza esta tabela para gerenciar todos os contatos de clientes, permitindo múltiplos telefones, emails ou outros tipos de contato por cliente.

**Observação Importante:** CLINET complementa CLIEN fornecendo múltiplos contatos por cliente. Com 2.868 registros para 9.251 clientes, indica que aproximadamente 31% dos clientes têm contatos cadastrados, com média de cerca de 0.31 contatos por cliente.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente (PK + FK → CLIEN) |
| **NETCODIGO** 🔑 | SMALLINT | ✓ | Código sequencial do contato (PK) |

### Informações do Contato
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NETTIPO** | VARCHAR(14) | ✓ | Tipo de contato (ex: "TELEFONE", "EMAIL", "CELULAR", etc.) |
| **NETENDERECO** | VARCHAR(37) | ✓ | Endereço do contato (telefone, email, etc.) |
| **NETTDATUALIZACAO** | DATE | | Data da última atualização do contato |

**Primary Key:** (CLICODIGO, NETCODIGO)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente ao qual o contato pertence.
- **NETCODIGO**: Código sequencial que identifica cada contato do cliente (1, 2, 3, etc.).
- **NETTIPO**: Tipo de contato (ex: "TELEFONE", "EMAIL", "CELULAR", "FAX", etc.).
- **NETENDERECO**: Valor do contato (número de telefone, endereço de email, etc.).
- **NETTDATUALIZACAO**: Data em que o contato foi atualizado pela última vez.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLINET Referencia (1 FK):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLINET.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLINET
```

**Descrição**: Cada contato está vinculado a um cliente específico.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Uso:** Identificar o cliente do contato, relatórios de contatos por cliente.

---

### CLINET é Referenciada Por (4 tabelas):

#### 1. CTATO - Contatos Adicionais
**Relacionamento:**
```
CTATO.CLICODIGO, CTATO.NETCODIGO → CLINET.CLICODIGO, CLINET.NETCODIGO (N:1)
Constraint: CLINET_CTATO
```

**Descrição**: CTATO referencia CLINET para obter informações de contato base.

**Uso:** CTATO estende informações de contatos de CLINET com dados adicionais.

---

#### 2. PARAMCLINET - Parâmetros de Contato
**Relacionamento:**
```
PARAMCLINET.CLICODIGO, PARAMCLINET.NETCODIGO → CLINET.CLICODIGO, CLINET.NETCODIGO (N:1)
Constraint: FK_PARAMCLINET_CLINET
```

**Descrição**: PARAMCLINET referencia CLINET para associar parâmetros específicos a contatos.

**Informações da Tabela PARAMCLINET:**
- **Total:** 15.663 registros
- **PK:** (CLICODIGO, NETCODIGO, PARNOME)
- **Colunas:** 4 campos

**Uso:** PARAMCLINET armazena parâmetros adicionais (chave-valor) para cada contato.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLINET → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados aos contatos.

**Uso:** Análises de pedidos considerando contatos do cliente, comunicação sobre pedidos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLINET → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas aos contatos.

**Uso:** Análises de notas fiscais considerando contatos do cliente, envio de notas por email.

---

### Via CLIEN → ENDCLI (Endereços)

**Fluxo:** CLINET → CLIEN → ENDCLI

**Descrição:** Através do cliente, é possível identificar endereços que podem estar relacionados aos contatos.

**Uso:** Análises de endereços considerando contatos do cliente.

---

### Via PARAMCLINET → Parâmetros de Contato

**Fluxo:** CLINET → PARAMCLINET

**Descrição:** Através de PARAMCLINET, é possível obter parâmetros adicionais de cada contato.

**Uso:** Obter configurações específicas de cada contato (ex: horário preferido, tipo de comunicação, etc.).

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Contatos de Cliente

**Objetivo:** Obter todos os contatos de um cliente com informações completas.

**Fluxo:**
```
CLIEN (CLICODIGO)
  ↓
CLINET (CLICODIGO, NETCODIGO)
  ↓
PARAMCLINET (CLICODIGO, NETCODIGO)
```

**Query SQL:**
```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cn.NETCODIGO,
    cn.NETTIPO AS TIPO_CONTATO,
    cn.NETENDERECO AS ENDERECO_CONTATO,
    cn.NETTDATUALIZACAO AS DATA_ATUALIZACAO,
    COUNT(pc.PARNOME) AS TOTAL_PARAMETROS
FROM CLIEN cl
INNER JOIN CLINET cn ON cn.CLICODIGO = cl.CLICODIGO
LEFT JOIN PARAMCLINET pc ON pc.CLICODIGO = cn.CLICODIGO
  AND pc.NETCODIGO = cn.NETCODIGO
WHERE cl.CLICODIGO = ?
GROUP BY cl.CLICODIGO, cl.CLINOMEFANT, cl.CLIRAZSOCIAL, cn.NETCODIGO, cn.NETTIPO, cn.NETENDERECO, cn.NETTDATUALIZACAO
ORDER BY cn.NETCODIGO;
```

---

### Exemplo 2: Análise de Contatos por Tipo

**Objetivo:** Identificar distribuição de contatos por tipo.

**Query SQL:**
```sql
SELECT
    NETTIPO AS TIPO_CONTATO,
    COUNT(*) AS TOTAL_CONTATOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CLINET), 2) AS PERCENTUAL
FROM CLINET
GROUP BY NETTIPO
ORDER BY TOTAL_CONTATOS DESC;
```

---

### Exemplo 3: Análise de Contatos com Pedidos

**Objetivo:** Obter contatos de clientes com informações de pedidos.

**Fluxo:**
```
CLINET (CLICODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cn.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cn.NETTIPO AS TIPO_CONTATO,
    cn.NETENDERECO AS ENDERECO_CONTATO,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS
FROM CLINET cn
INNER JOIN CLIEN cl ON cl.CLICODIGO = cn.CLICODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = cn.CLICODIGO
WHERE cn.NETTIPO = 'EMAIL'
GROUP BY cn.CLICODIGO, cl.CLINOMEFANT, cn.NETTIPO, cn.NETENDERECO
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Contatos de um Cliente

**Objetivo:** Obter todos os contatos de um cliente específico.

```sql
SELECT
    CLICODIGO,
    NETCODIGO,
    NETTIPO AS TIPO_CONTATO,
    NETENDERECO AS ENDERECO_CONTATO,
    NETTDATUALIZACAO AS DATA_ATUALIZACAO
FROM CLINET
WHERE CLICODIGO = ?
ORDER BY NETCODIGO;
```

---

### 2. Buscar Contato Específico por Tipo

**Objetivo:** Obter contato de um tipo específico de um cliente.

```sql
SELECT
    CLICODIGO,
    NETCODIGO,
    NETTIPO AS TIPO_CONTATO,
    NETENDERECO AS ENDERECO_CONTATO,
    NETTDATUALIZACAO AS DATA_ATUALIZACAO
FROM CLINET
WHERE CLICODIGO = ?
  AND NETTIPO = ?
ORDER BY NETCODIGO;
```

---

### 3. Listar Clientes com Contatos por Tipo

**Objetivo:** Identificar clientes que têm contatos de um tipo específico.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cn.NETTIPO AS TIPO_CONTATO,
    cn.NETENDERECO AS ENDERECO_CONTATO
FROM CLIEN cl
INNER JOIN CLINET cn ON cn.CLICODIGO = cl.CLICODIGO
WHERE cn.NETTIPO = ?
ORDER BY cl.CLINOMEFANT;
```

---

### 4. Análise de Clientes Sem Contatos

**Objetivo:** Identificar clientes que não têm contatos cadastrados.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL
FROM CLIEN cl
LEFT JOIN CLINET cn ON cn.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
  AND cn.CLICODIGO IS NULL
ORDER BY cl.CLINOMEFANT;
```

---

### 5. Análise de Contatos com Parâmetros

**Objetivo:** Obter contatos com seus parâmetros adicionais.

```sql
SELECT
    cn.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cn.NETCODIGO,
    cn.NETTIPO AS TIPO_CONTATO,
    cn.NETENDERECO AS ENDERECO_CONTATO,
    COUNT(pc.PARNOME) AS TOTAL_PARAMETROS,
    STRING_AGG(pc.PARNOME || '=' || pc.PARVALOR, ', ') AS PARAMETROS
FROM CLINET cn
INNER JOIN CLIEN cl ON cl.CLICODIGO = cn.CLICODIGO
LEFT JOIN PARAMCLINET pc ON pc.CLICODIGO = cn.CLICODIGO
  AND pc.NETCODIGO = cn.NETCODIGO
GROUP BY cn.CLICODIGO, cl.CLINOMEFANT, cn.NETCODIGO, cn.NETTIPO, cn.NETENDERECO
ORDER BY cn.CLICODIGO, cn.NETCODIGO;
```

---

### 6. Análise de Contatos Atualizados Recentemente

**Objetivo:** Identificar contatos atualizados em um período específico.

```sql
SELECT
    cn.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cn.NETCODIGO,
    cn.NETTIPO AS TIPO_CONTATO,
    cn.NETENDERECO AS ENDERECO_CONTATO,
    cn.NETTDATUALIZACAO AS DATA_ATUALIZACAO
FROM CLINET cn
INNER JOIN CLIEN cl ON cl.CLICODIGO = cn.CLICODIGO
WHERE cn.NETTDATUALIZACAO >= ?
  AND cn.NETTDATUALIZACAO <= ?
ORDER BY cn.NETTDATUALIZACAO DESC;
```

---

### 7. Relatório de Contatos por Tipo

**Objetivo:** Analisar distribuição de contatos por tipo e cliente.

```sql
SELECT
    NETTIPO AS TIPO_CONTATO,
    COUNT(*) AS TOTAL_CONTATOS,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CLINET), 2) AS PERCENTUAL_CONTATOS,
    ROUND(COUNT(DISTINCT CLICODIGO) * 100.0 / (SELECT COUNT(*) FROM CLIEN WHERE CLICLIENTE = 'S'), 2) AS PERCENTUAL_CLIENTES
FROM CLINET
GROUP BY NETTIPO
ORDER BY TOTAL_CONTATOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLINET | Tipo |
|--------|-----------|---------------------|------|
| **CLINET** | 2.868 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 3.23:1 | Clientes (média de 0.31 contatos por cliente) |
| PARAMCLINET | 15.663 | 5.46:1 | Parâmetros de contato (média de 5.46 parâmetros por contato) |
| CTATO | ? | ?:1 | Contatos adicionais |

**Interpretação:**
- **2.868 contatos** cadastrados no sistema
- **31% dos clientes** têm pelo menos um contato cadastrado (2.868 de 9.251)
- **Média de 0.31 contatos por cliente** - indica que a maioria dos clientes não tem contatos cadastrados ou tem apenas um
- **Média de 5.46 parâmetros por contato** - indica uso extensivo de parâmetros adicionais

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLINET.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por tipo** - Para buscas por tipo de contato
4. **Índice por endereço** - Para buscas por endereço de contato

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLINET_CLIENTE ON CLINET(CLICODIGO);

-- Índice 2: Busca por tipo de contato (consultas frequentes)
CREATE INDEX IDX_CLINET_TIPO ON CLINET(NETTIPO)
    WHERE NETTIPO IS NOT NULL AND NETTIPO != '';

-- Índice 3: Busca por cliente e tipo (consultas combinadas)
CREATE INDEX IDX_CLINET_CLI_TIPO ON CLINET(CLICODIGO, NETTIPO);

-- Índice 4: Busca por endereço (consultas específicas)
CREATE INDEX IDX_CLINET_ENDERECO ON CLINET(NETENDERECO)
    WHERE NETENDERECO IS NOT NULL AND NETENDERECO != '';
```

### Observações sobre Volume

- **Tabela média** (2.868 registros) - Performance boa com índices adequados
- **Consultas frequentes** - Contatos são consultados frequentemente
- **Índices essenciais** - Em CLICODIGO e NETTIPO para buscas frequentes
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e tipo

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar contatos sem cliente válido
SELECT cn.*
FROM CLINET cn
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cn.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar contatos com endereço vazio
SELECT *
FROM CLINET
WHERE NETENDERECO IS NULL
   OR NETENDERECO = '';

-- Verificar contatos com tipo vazio
SELECT *
FROM CLINET
WHERE NETTIPO IS NULL
   OR NETTIPO = '';
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLINET
WHERE CLICODIGO IS NULL
   OR NETCODIGO IS NULL
   OR NETTIPO IS NULL
   OR NETTIPO = ''
   OR NETENDERECO IS NULL
   OR NETENDERECO = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, NETCODIGO, COUNT(*) AS QTD
FROM CLINET
GROUP BY CLICODIGO, NETCODIGO
HAVING COUNT(*) > 1;

-- Verificar sequência de NETCODIGO por cliente
SELECT
    CLICODIGO,
    COUNT(*) AS TOTAL_CONTATOS,
    MIN(NETCODIGO) AS MIN_CODIGO,
    MAX(NETCODIGO) AS MAX_CODIGO,
    MAX(NETCODIGO) - COUNT(*) AS LACUNAS
FROM CLINET
GROUP BY CLICODIGO
HAVING MAX(NETCODIGO) - COUNT(*) > 0;
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
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdClinet extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLINET';
    
    protected $primaryKey = ['CLICODIGO', 'NETCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'CLICODIGO' => 'integer',
        'NETCODIGO' => 'integer',
        'NETTIPO' => 'string',
        'NETENDERECO' => 'string',
        'NETTDATUALIZACAO' => 'date',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com PARAMCLINET
    public function parametros(): HasMany
    {
        return $this->hasMany(FirebirdParamclinet::class, 'CLICODIGO', 'CLICODIGO')
            ->where('NETCODIGO', $this->NETCODIGO);
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por tipo de contato
    public function scopePorTipo($query, string $tipo)
    {
        return $query->where('NETTIPO', $tipo);
    }

    // Scope para filtrar por cliente e tipo
    public function scopePorClienteTipo($query, int $clienteCodigo, string $tipo)
    {
        return $query->where('CLICODIGO', $clienteCodigo)
            ->where('NETTIPO', $tipo);
    }

    // Método para verificar se é email
    public function isEmail(): bool
    {
        return strtoupper($this->NETTIPO) === 'EMAIL';
    }

    // Método para verificar se é telefone
    public function isTelefone(): bool
    {
        return in_array(strtoupper($this->NETTIPO), ['TELEFONE', 'CELULAR', 'FAX']);
    }

    // Método estático para buscar contatos de um cliente
    public static function buscarContatosCliente(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->orderBy('NETCODIGO')
            ->get();
    }

    // Método estático para buscar contato por tipo
    public static function buscarContatoPorTipo(int $clienteCodigo, string $tipo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('NETTIPO', $tipo)
            ->orderBy('NETCODIGO')
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente existe
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Padronização de tipos** - Manter valores de NETTIPO consistentes

### Performance

1. **Tabela média** - 2.868 registros, performance boa com índices adequados
2. **Índices essenciais** - Em CLICODIGO e NETTIPO para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + tipo)
4. **Consultas frequentes** - Contatos são consultados frequentemente

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se cliente existe
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de tipos** - Verificar valores válidos de NETTIPO
5. **Validação de endereços** - Verificar formato de emails e telefones

### Manutenção

1. **Revisão periódica** - Verificar contatos desatualizados ou inválidos
2. **Padronização** - Manter estrutura de tipos consistente
3. **Documentação** - Documentar significado de cada tipo de contato
4. **Backup regular** - Tabela importante para comunicação com clientes

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

