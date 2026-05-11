# MOVINTEGRANFE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MOVINTEGRANFE (Movimentação de Integração de Notas Fiscais)
- **Total de Registros**: 1.316.929
- **Total de Colunas**: 27
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 4
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MOVINTEGRANFE** é uma tabela que armazena movimentações de integração de notas fiscais eletrônicas com sistemas externos. Com **1.316.929 registros**, representa um histórico extenso de movimentações de integração de NFes, incluindo informações sobre número, série, empresa, XML gerado/enviado, status, estado, motivo, solução e dados do emitente.

Esta tabela funciona como **log de integração de NFes** e permite:
- Registrar todas as movimentações de integração de NFes
- Armazenar informações sobre número, série e empresa
- Rastrear XML gerado e XML enviado
- Controlar status, estado e motivo da integração
- Armazenar solução e dados do emitente
- Rastrear chave da NFe e ação realizada
- Controlar homologação, tipo de nota e validação
- Rastrear envio de email e forma de pagamento
- Facilitar auditoria de integrações de NFes
- Manter histórico detalhado de movimentações

Cada registro representa uma movimentação específica de integração de NFe, contendo:
- ID da movimentação (ID)
- Número da nota (NUMERONOTA)
- Série da nota (SERIE)
- Chave da empresa (KEY_EMPRESA)
- XML gerado (XMLGERADO)
- XML enviado (XMLENVIADO)
- Data da movimentação (DATA)
- Hora da movimentação (HORA)
- Status da integração (STATUS)
- Estado da integração (ESTADO)
- Motivo da integração (MOTIVO)
- Solução da integração (SOLUCAO)
- Razão social do emitente (RAZAOSOCIAL)
- CNPJ do emitente (CNPJ)
- Inscrição estadual (INSCRICAOESTADUAL)
- Chave da NFe (CHAVENFE)
- Chave da nota (KEY_NOTA)
- Ação realizada (ACAO)
- Indicador de homologação (HOMOLOGACAO)
- Tipo de nota (TIPONOTA)
- Email do destinatário (EMAIL)
- Data de envio do email (DTENVIOEMAIL)
- Indicador de validação (VALIDADO)
- Forma de pagamento (FORMA)
- Modelo da nota (MODELO)
- Usuário responsável (USUARIO)
- Sessão SAT (SESSAO_SAT)

O sistema utiliza esta tabela para manter histórico completo de movimentações de integração de NFes, permitindo auditoria detalhada e rastreamento de integrações.

**Observação Importante:** MOVINTEGRANFE é uma tabela de log de integração de NFes. Com 1.316.929 registros, indica uso intenso desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com NOTAS através dos campos NUMERONOTA, SERIE e KEY_EMPRESA, e com EMPRESA através de KEY_EMPRESA. Possui 4 índices para otimização de consultas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID da movimentação de integração (PK) |

### Informações da Nota Fiscal
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NUMERONOTA** | VARCHAR(37) | ✓ | Número da nota fiscal |
| **SERIE** | VARCHAR(37) | | Série da nota fiscal |
| **KEY_EMPRESA** | INTEGER | ✓ | Chave da empresa |
| **KEY_NOTA** | VARCHAR(37) | ✓ | Chave da nota |

### Informações de XML
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **XMLGERADO** | VARCHAR(261) | | XML gerado da NFe |
| **XMLENVIADO** | VARCHAR(261) | | XML enviado na integração |

### Informações de Data/Hora
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATA** | TIMESTAMP | | Data da movimentação |
| **HORA** | TIMESTAMP | | Hora da movimentação |

### Informações de Status e Controle
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **STATUS** | VARCHAR(37) | | Status da integração |
| **ESTADO** | VARCHAR(37) | | Estado da integração |
| **MOTIVO** | VARCHAR(37) | | Motivo da integração |
| **SOLUCAO** | VARCHAR(37) | | Solução da integração |
| **ACAO** | VARCHAR(37) | | Ação realizada |
| **HOMOLOGACAO** | VARCHAR(14) | | Indicador de homologação |
| **VALIDADO** | VARCHAR(14) | | Indicador de validação |

### Informações do Emitente
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **RAZAOSOCIAL** | VARCHAR(37) | | Razão social do emitente |
| **CNPJ** | VARCHAR(37) | | CNPJ do emitente |
| **INSCRICAOESTADUAL** | VARCHAR(37) | | Inscrição estadual |

### Informações Adicionais
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CHAVENFE** | VARCHAR(37) | | Chave da NFe |
| **TIPONOTA** | VARCHAR(14) | | Tipo de nota |
| **EMAIL** | VARCHAR(261) | | Email do destinatário |
| **DTENVIOEMAIL** | TIMESTAMP | | Data de envio do email |
| **FORMA** | VARCHAR(37) | | Forma de pagamento |
| **MODELO** | VARCHAR(37) | | Modelo da nota |
| **USUARIO** | VARCHAR(37) | | Usuário responsável |
| **SESSAO_SAT** | VARCHAR(37) | | Sessão SAT |

**Primary Key:** ID

**Índices:**
- `IDXNRNOTA` em `KEY_NOTA` (não único)
- `MOVINTEGRANFE_IDXDATAHORA` em `DATA, HORA` (não único)
- `MOVINTEGRANFE_IDXNOTASERIE` em `NUMERONOTA, SERIE` (não único)
- `MOVINTEGRANFE_IDXSTATUS` em `STATUS` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MOVINTEGRANFE Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MOVINTEGRANFE é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MOVINTEGRANFE diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via NUMERONOTA, SERIE, KEY_EMPRESA → NOTAS

**Fluxo:** MOVINTEGRANFE → NOTAS → Operações

**Descrição:** Através do número, série e empresa, é possível identificar notas fiscais relacionadas.

**Uso:** Análise de movimentações através de notas fiscais.

---

### Via KEY_EMPRESA → EMPRESA

**Fluxo:** MOVINTEGRANFE → EMPRESA → Operações

**Descrição:** Através da chave da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de movimentações através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Movimentação de Integração

**Objetivo:** Obter informações de uma movimentação específica.

```sql
SELECT
    ID,
    NUMERONOTA,
    SERIE,
    KEY_EMPRESA,
    STATUS,
    ESTADO,
    MOTIVO,
    CHAVENFE
FROM MOVINTEGRANFE
WHERE ID = ?;
```

---

### 2. Listar Movimentações de uma Nota

**Objetivo:** Obter todas as movimentações de integração de uma nota específica.

```sql
SELECT
    ID,
    DATA,
    HORA,
    STATUS,
    ESTADO,
    MOTIVO,
    SOLUCAO
FROM MOVINTEGRANFE
WHERE NUMERONOTA = ? AND SERIE = ? AND KEY_EMPRESA = ?
ORDER BY DATA DESC, HORA DESC;
```

---

### 3. Análise de Movimentações por Status

**Objetivo:** Identificar distribuição de movimentações por status.

**Query SQL:**
```sql
SELECT
    STATUS,
    COUNT(*) AS TOTAL_MOVIMENTACOES,
    COUNT(DISTINCT NUMERONOTA) AS TOTAL_NOTAS_AFETADAS
FROM MOVINTEGRANFE
WHERE STATUS IS NOT NULL
GROUP BY STATUS
ORDER BY TOTAL_MOVIMENTACOES DESC;
```

---

### 4. Análise de Movimentações com Erro

**Objetivo:** Identificar movimentações que possuem erro.

**Query SQL:**
```sql
SELECT
    STATUS,
    ESTADO,
    COUNT(*) AS TOTAL_COM_ERRO,
    COUNT(DISTINCT NUMERONOTA) AS TOTAL_NOTAS_AFETADAS
FROM MOVINTEGRANFE
WHERE MOTIVO IS NOT NULL AND MOTIVO != ''
GROUP BY STATUS, ESTADO
ORDER BY TOTAL_COM_ERRO DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MOVINTEGRANFE | Tipo |
|--------|-----------|---------------------------|------|
| **MOVINTEGRANFE** | 1.316.929 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **1.316.929 movimentações** de integração registradas no sistema
- Indica uso intenso desta funcionalidade de integração

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índices existentes: Otimização de consultas frequentes
-- IDXNRNOTA em KEY_NOTA (não único)
-- MOVINTEGRANFE_IDXDATAHORA em DATA, HORA (não único)
-- MOVINTEGRANFE_IDXNOTASERIE em NUMERONOTA, SERIE (não único)
-- MOVINTEGRANFE_IDXSTATUS em STATUS (não único)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_MOVINTEGRANFE_EMPRESA ON MOVINTEGRANFE(KEY_EMPRESA)
    WHERE KEY_EMPRESA IS NOT NULL;

-- Índice 2: Busca por estado (consultas frequentes)
CREATE INDEX IDX_MOVINTEGRANFE_ESTADO ON MOVINTEGRANFE(ESTADO)
    WHERE ESTADO IS NOT NULL;

-- Índice 3: Busca por chave NFe (consultas frequentes)
CREATE INDEX IDX_MOVINTEGRANFE_CHAVENFE ON MOVINTEGRANFE(CHAVENFE)
    WHERE CHAVENFE IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMovintegranfe extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MOVINTEGRANFE';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'NUMERONOTA' => 'string',
        'SERIE' => 'string',
        'KEY_EMPRESA' => 'integer',
        'XMLGERADO' => 'string',
        'XMLENVIADO' => 'string',
        'DATA' => 'datetime',
        'HORA' => 'datetime',
        'STATUS' => 'string',
        'ESTADO' => 'string',
        'MOTIVO' => 'string',
        'SOLUCAO' => 'string',
        'RAZAOSOCIAL' => 'string',
        'CNPJ' => 'string',
        'INSCRICAOESTADUAL' => 'string',
        'CHAVENFE' => 'string',
        'KEY_NOTA' => 'string',
        'ACAO' => 'string',
        'HOMOLOGACAO' => 'string',
        'TIPONOTA' => 'string',
        'EMAIL' => 'string',
        'DTENVIOEMAIL' => 'datetime',
        'VALIDADO' => 'string',
        'FORMA' => 'string',
        'MODELO' => 'string',
        'USUARIO' => 'string',
        'SESSAO_SAT' => 'string',
    ];

    public function scopePorNota($query, string $numeroNota, string $serie, int $keyEmpresa)
    {
        return $query->where('NUMERONOTA', $numeroNota)
                     ->where('SERIE', $serie)
                     ->where('KEY_EMPRESA', $keyEmpresa);
    }

    public function scopePorEmpresa($query, int $keyEmpresa)
    {
        return $query->where('KEY_EMPRESA', $keyEmpresa);
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

