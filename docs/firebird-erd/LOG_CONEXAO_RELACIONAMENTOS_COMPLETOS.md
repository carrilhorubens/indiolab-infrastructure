# LOG_CONEXAO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: LOG_CONEXAO (Log de Conexões)
- **Total de Registros**: 2.010
- **Total de Colunas**: 6
- **Chave Primária**: ISEQ (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**LOG_CONEXAO** é uma tabela que armazena logs de conexões ao sistema. Com **2.010 registros**, representa um histórico de conexões de usuários, incluindo informações de origem, endereço IP, aplicação e usuário.

Esta tabela funciona como **log de conexões** e permite:
- Registrar todas as conexões ao sistema
- Armazenar informações de origem e endereço IP
- Identificar aplicação e usuário da conexão
- Facilitar auditoria de acesso ao sistema
- Manter histórico completo de conexões
- Suportar análise de segurança

Cada registro representa uma conexão específica ao sistema, contendo:
- Sequencial da conexão (ISEQ)
- Data da conexão (DATA)
- Origem da conexão (ORIGEM)
- Endereço IP da conexão (ENDERECO_IP)
- Aplicação utilizada (APLICACAO)
- Usuário da conexão (USUARIO)

O sistema utiliza esta tabela para manter histórico completo de conexões, permitindo auditoria de acesso e análise de segurança.

**Observação Importante:** LOG_CONEXAO é uma tabela de log de conexões. Com 2.010 registros, indica uso moderado desta funcionalidade de auditoria. Não possui relacionamentos diretos com outras tabelas, mas pode ter relacionamentos lógicos com tabelas de usuários através do campo USUARIO.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ISEQ** 🔑 | INTEGER | ✓ | Sequencial da conexão (PK) |

### Informações da Conexão
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DATA** | TIMESTAMP | | Data da conexão |
| **ORIGEM** | VARCHAR(37) | | Origem da conexão |
| **ENDERECO_IP** | VARCHAR(37) | | Endereço IP da conexão |
| **APLICACAO** | VARCHAR(37) | | Aplicação utilizada |
| **USUARIO** | VARCHAR(37) | | Usuário da conexão |

**Primary Key:** ISEQ

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### LOG_CONEXAO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### LOG_CONEXAO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia LOG_CONEXAO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via USUARIO → Tabelas de Usuários

**Fluxo:** LOG_CONEXAO → USUARIO → Operações

**Descrição:** Através do nome do usuário, é possível identificar outras operações relacionadas.

**Uso:** Análise de conexões através de operações de usuários.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Log de Conexão

**Objetivo:** Obter informações de uma conexão específica.

```sql
SELECT
    ISEQ,
    DATA,
    ORIGEM,
    ENDERECO_IP,
    APLICACAO,
    USUARIO
FROM LOG_CONEXAO
WHERE ISEQ = ?;
```

---

### 2. Listar Conexões de um Usuário

**Objetivo:** Obter todas as conexões de um usuário específico.

```sql
SELECT
    ISEQ,
    DATA,
    ORIGEM,
    ENDERECO_IP,
    APLICACAO
FROM LOG_CONEXAO
WHERE USUARIO = ?
ORDER BY DATA DESC;
```

---

### 3. Análise de Conexões por Período

**Objetivo:** Identificar distribuição de conexões ao longo do tempo.

**Query SQL:**
```sql
SELECT
    EXTRACT(YEAR FROM DATA) AS ANO,
    EXTRACT(MONTH FROM DATA) AS MES,
    COUNT(*) AS TOTAL_CONEXOES,
    COUNT(DISTINCT USUARIO) AS TOTAL_USUARIOS,
    COUNT(DISTINCT ENDERECO_IP) AS TOTAL_IPS_DIFERENTES
FROM LOG_CONEXAO
WHERE DATA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM DATA), EXTRACT(MONTH FROM DATA)
ORDER BY ANO DESC, MES DESC;
```

---

### 4. Análise de Conexões por Aplicação

**Objetivo:** Identificar distribuição de conexões por aplicação.

**Query SQL:**
```sql
SELECT
    APLICACAO,
    COUNT(*) AS TOTAL_CONEXOES,
    COUNT(DISTINCT USUARIO) AS TOTAL_USUARIOS,
    COUNT(DISTINCT ENDERECO_IP) AS TOTAL_IPS_DIFERENTES
FROM LOG_CONEXAO
WHERE APLICACAO IS NOT NULL
GROUP BY APLICACAO
ORDER BY TOTAL_CONEXOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com LOG_CONEXAO | Tipo |
|--------|-----------|------------------------|------|
| **LOG_CONEXAO** | 2.010 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **2.010 conexões** registradas no sistema
- Indica uso moderado desta funcionalidade de auditoria

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por data (consultas frequentes)
CREATE INDEX IDX_LOG_CONEXAO_DATA ON LOG_CONEXAO(DATA)
    WHERE DATA IS NOT NULL;

-- Índice 2: Busca por usuário (consultas frequentes)
CREATE INDEX IDX_LOG_CONEXAO_USUARIO ON LOG_CONEXAO(USUARIO)
    WHERE USUARIO IS NOT NULL;

-- Índice 3: Busca por endereço IP (consultas frequentes)
CREATE INDEX IDX_LOG_CONEXAO_IP ON LOG_CONEXAO(ENDERECO_IP)
    WHERE ENDERECO_IP IS NOT NULL;

-- Índice 4: Busca por aplicação (consultas frequentes)
CREATE INDEX IDX_LOG_CONEXAO_APLICACAO ON LOG_CONEXAO(APLICACAO)
    WHERE APLICACAO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdLogConexao extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'LOG_CONEXAO';
    
    protected $primaryKey = 'ISEQ';
    public $incrementing = true;

    protected $casts = [
        'ISEQ' => 'integer',
        'DATA' => 'datetime',
        'ORIGEM' => 'string',
        'ENDERECO_IP' => 'string',
        'APLICACAO' => 'string',
        'USUARIO' => 'string',
    ];

    public function scopePorUsuario($query, string $usuario)
    {
        return $query->where('USUARIO', $usuario);
    }

    public function scopePorIp($query, string $enderecoIp)
    {
        return $query->where('ENDERECO_IP', $enderecoIp);
    }

    public function scopePorAplicacao($query, string $aplicacao)
    {
        return $query->where('APLICACAO', $aplicacao);
    }

    public function scopePorPeriodo($query, $dataInicial, $dataFinal)
    {
        return $query->whereBetween('DATA', [$dataInicial, $dataFinal]);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('DATA', 'desc');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

