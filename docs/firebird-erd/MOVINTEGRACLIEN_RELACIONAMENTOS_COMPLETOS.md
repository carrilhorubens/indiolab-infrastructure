# MOVINTEGRACLIEN - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOVINTEGRACLIEN (Movimentação de Integração de Clientes)
- **Total de Registros**: 7
- **Total de Colunas**: 7
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 1
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOVINTEGRACLIEN** é uma tabela que armazena movimentações de integração de clientes com sistemas externos. Com **7 registros**, representa movimentações de integração de clientes, incluindo informações sobre código do cliente, CNPJ/CPF, UF, XML enviado, motivo e status.

Esta tabela funciona como **log de integração de clientes** e permite:
- Registrar movimentações de integração de clientes
- Armazenar informações sobre código, CNPJ/CPF e UF
- Rastrear XML enviado e motivo da integração
- Controlar status da integração
- Facilitar auditoria de integrações de clientes
- Manter histórico detalhado de movimentações

Cada registro representa uma movimentação específica de integração de cliente, contendo:
- ID da movimentação (ID)
- Código do cliente (CLICODIGO)
- CNPJ/CPF do cliente (CLICNPJCPF)
- UF do cliente (CLIUF)
- XML enviado (XMLENVIADO)
- Motivo da integração (MOTIVO)
- Status da integração (STATUS)

O sistema utiliza esta tabela para manter histórico completo de movimentações de integração de clientes, permitindo auditoria detalhada e rastreamento de integrações.

**Observação Importante:** MOVINTEGRACLIEN é uma tabela de log de integração de clientes. Com apenas 7 registros, indica uso muito limitado desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com CLIEN através do campo CLICODIGO. Possui 1 índice em CLICODIGO para otimização de consultas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID da movimentação de integração (PK) |

### Informações da Integração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** | INTEGER | ✓ | Código do cliente |
| **CLICNPJCPF** | VARCHAR(37) | ✓ | CNPJ/CPF do cliente |
| **CLIUF** | VARCHAR(14) | ✓ | UF do cliente |
| **XMLENVIADO** | VARCHAR(261) | | XML enviado na integração |
| **MOTIVO** | VARCHAR(37) | | Motivo da integração |
| **STATUS** | VARCHAR(37) | | Status da integração |

**Primary Key:** ID

**Índices:**
- `INDMOVCLIENCLICODIGO` em `CLICODIGO` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOVINTEGRACLIEN Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MOVINTEGRACLIEN é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOVINTEGRACLIEN diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via CLICODIGO → CLIEN

**Fluxo:** MOVINTEGRACLIEN → CLIEN → Operações

**Descrição:** Através do código do cliente, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de clientes.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Movimentação de Integração

**Objetivo:** Obter informações de uma movimentação específica.

```sql
SELECT
    ID,
    CLICODIGO,
    CLICNPJCPF,
    CLIUF,
    XMLENVIADO,
    MOTIVO,
    STATUS
FROM MOVINTEGRACLIEN
WHERE ID = ?;
```

---

### 2. Listar Movimentações de um Cliente

**Objetivo:** Obter todas as movimentações de integração de um cliente específico.

```sql
SELECT
    ID,
    CLICNPJCPF,
    CLIUF,
    XMLENVIADO,
    MOTIVO,
    STATUS
FROM MOVINTEGRACLIEN
WHERE CLICODIGO = ?
ORDER BY ID DESC;
```

---

### 3. Análise de Movimentações por Status

**Objetivo:** Identificar distribuição de movimentações por status.

**Query SQL:**
```sql
SELECT
    STATUS,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_AFETADOS
FROM MOVINTEGRACLIEN
WHERE STATUS IS NOT NULL
GROUP BY STATUS
ORDER BY TOTAL_MOVIMENTACOES DESC;
```

---

### 4. Buscar Movimentações com Erro

**Objetivo:** Obter movimentações que possuem motivo de erro.

```sql
SELECT
    ID,
    CLICODIGO,
    CLICNPJCPF,
    MOTIVO,
    STATUS
FROM MOVINTEGRACLIEN
WHERE MOTIVO IS NOT NULL AND MOTIVO != ''
ORDER BY ID DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOVINTEGRACLIEN | Tipo |
|--------|-----------|----------------------------|------|
| **MOVINTEGRACLIEN** | 7 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **7 movimentações** de integração registradas no sistema
- Indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índice existente: Busca por cliente (consultas frequentes)
-- INDMOVCLIENCLICODIGO em CLICODIGO (não único)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por status (consultas frequentes)
CREATE INDEX IDX_MOVINTEGRACLIEN_STATUS ON MOVINTEGRACLIEN(STATUS)
    WHERE STATUS IS NOT NULL;

-- Índice 2: Busca por CNPJ/CPF (consultas frequentes)
CREATE INDEX IDX_MOVINTEGRACLIEN_CNPJCPF ON MOVINTEGRACLIEN(CLICNPJCPF)
    WHERE CLICNPJCPF IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMovintegraclien extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOVINTEGRACLIEN';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'CLICODIGO' => 'integer',
        'CLICNPJCPF' => 'string',
        'CLIUF' => 'string',
        'XMLENVIADO' => 'string',
        'MOTIVO' => 'string',
        'STATUS' => 'string',
    ];

    public function scopePorCliente($query, int $cliCodigo)
    {
        return $query->where('CLICODIGO', $cliCodigo);
    }

    public function scopePorStatus($query, string $status)
    {
        return $query->where('STATUS', $status);
    }

    public function scopeComErro($query)
    {
        return $query->whereNotNull('MOTIVO')
                     ->where('MOTIVO', '!=', '');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('ID', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

