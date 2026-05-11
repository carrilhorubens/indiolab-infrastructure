# DESABILITA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DESABILITA (Desabilitar)
- **Total de Registros**: 25
- **Total de Colunas**: 3
- **Chave Primária**: DESSEQ (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**DESABILITA** é uma tabela de controle que armazena informações sobre tabelas e rotinas que foram desabilitadas no sistema. Com **25 registros**, representa funcionalidades que foram temporariamente ou permanentemente desativadas, permitindo controle de features e manutenção do sistema.

Esta tabela funciona como **registro de funcionalidades desabilitadas** e permite:
- Rastrear tabelas e rotinas desabilitadas
- Manter histórico de funcionalidades desativadas
- Controlar quais funcionalidades estão ativas ou inativas
- Suportar manutenção e troubleshooting
- Facilitar reativação de funcionalidades quando necessário

Cada registro representa uma funcionalidade desabilitada, contendo:
- Sequencial único do registro (DESSEQ)
- Nome da tabela desabilitada (DESTABELA)
- Nome da rotina desabilitada (DESROTINA)

O sistema utiliza esta tabela para controlar funcionalidades desabilitadas, permitindo que o sistema verifique quais tabelas e rotinas não devem ser utilizadas.

**Observação Importante:** DESABILITA é uma tabela de controle/auditoria que registra funcionalidades desabilitadas. Com 25 registros, indica uso moderado desta funcionalidade. Não possui foreign keys diretas, funcionando como tabela de configuração/controle.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DESSEQ** 🔑 | INTEGER | ✓ | Sequencial único do registro (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DESTABELA** | VARCHAR(37) | ✓ | Nome da tabela desabilitada |
| **DESROTINA** | VARCHAR(37) | ✓ | Nome da rotina desabilitada |

**Primary Key:** DESSEQ

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DESABILITA Referencia (0 FKs):

Nenhuma foreign key direta.

---

### DESABILITA é Referenciada Por (0 tabelas):

Nenhuma tabela referencia DESABILITA diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via DESTABELA → Tabelas do Sistema

**Fluxo:** DESABILITA → Tabelas do Sistema

**Descrição:** Através do nome da tabela, é possível identificar tabelas relacionadas no sistema.

**Uso:** Verificação de tabelas desabilitadas durante operações.

---

### Via DESROTINA → Rotinas do Sistema

**Fluxo:** DESABILITA → Rotinas do Sistema

**Descrição:** Através do nome da rotina, é possível identificar rotinas relacionadas no sistema.

**Uso:** Verificação de rotinas desabilitadas durante execução.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Registro de Desabilitação

**Objetivo:** Obter informações de um registro de desabilitação específico.

```sql
SELECT
    DESSEQ,
    DESTABELA AS TABELA,
    DESROTINA AS ROTINA
FROM DESABILITA
WHERE DESSEQ = ?;
```

---

### 2. Listar Todas as Funcionalidades Desabilitadas

**Objetivo:** Obter lista completa de funcionalidades desabilitadas.

```sql
SELECT
    DESSEQ,
    DESTABELA AS TABELA,
    DESROTINA AS ROTINA
FROM DESABILITA
ORDER BY DESTABELA, DESROTINA;
```

---

### 3. Verificar se Tabela Está Desabilitada

**Objetivo:** Verificar se uma tabela específica está desabilitada.

```sql
SELECT
    DESSEQ,
    DESTABELA AS TABELA,
    DESROTINA AS ROTINA
FROM DESABILITA
WHERE DESTABELA = ?;
```

---

### 4. Verificar se Rotina Está Desabilitada

**Objetivo:** Verificar se uma rotina específica está desabilitada.

```sql
SELECT
    DESSEQ,
    DESTABELA AS TABELA,
    DESROTINA AS ROTINA
FROM DESABILITA
WHERE DESROTINA = ?;
```

---

### 5. Análise de Funcionalidades Desabilitadas por Tabela

**Objetivo:** Identificar distribuição de funcionalidades desabilitadas por tabela.

**Query SQL:**
```sql
SELECT
    DESTABELA AS TABELA,
    COUNT(*) AS TOTAL_ROTINAS_DESABILITADAS,
    STRING_AGG(DESROTINA, ', ') AS ROTINAS
FROM DESABILITA
GROUP BY DESTABELA
ORDER BY TOTAL_ROTINAS_DESABILITADAS DESC;
```

---

### 6. Relatório Completo de Funcionalidades Desabilitadas

**Objetivo:** Analisar distribuição completa de funcionalidades desabilitadas no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_FUNCIONALIDADES_DESABILITADAS,
    COUNT(DISTINCT DESTABELA) AS TOTAL_TABELAS_AFETADAS,
    COUNT(DISTINCT DESROTINA) AS TOTAL_ROTINAS_AFETADAS
FROM DESABILITA;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com DESABILITA | Tipo |
|--------|-----------|------------------------|------|
| **DESABILITA** | 25 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **25 funcionalidades desabilitadas** registradas no sistema
- **Tabela de controle** - mantém registro de funcionalidades desativadas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por tabela (consultas frequentes)
CREATE INDEX IDX_DESABILITA_TABELA ON DESABILITA(DESTABELA);

-- Índice 2: Busca por rotina (consultas frequentes)
CREATE INDEX IDX_DESABILITA_ROTINA ON DESABILITA(DESROTINA);

-- Índice 3: Busca combinada (consultas frequentes)
CREATE INDEX IDX_DESABILITA_TABELA_ROTINA ON DESABILITA(DESTABELA, DESROTINA);
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdDesabilita extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DESABILITA';
    
    protected $primaryKey = 'DESSEQ';
    public $incrementing = true;

    protected $casts = [
        'DESSEQ' => 'integer',
        'DESTABELA' => 'string',
        'DESROTINA' => 'string',
    ];

    public function scopePorTabela($query, string $tabela)
    {
        return $query->where('DESTABELA', $tabela);
    }

    public function scopePorRotina($query, string $rotina)
    {
        return $query->where('DESROTINA', $rotina);
    }

    public function scopeTabelaDesabilitada($query, string $tabela)
    {
        return $query->where('DESTABELA', $tabela)->exists();
    }

    public function scopeRotinaDesabilitada($query, string $rotina)
    {
        return $query->where('DESROTINA', $rotina)->exists();
    }

    // Método estático para verificar se tabela está desabilitada
    public static function tabelaEstaDesabilitada(string $tabela): bool
    {
        return self::where('DESTABELA', $tabela)->exists();
    }

    // Método estático para verificar se rotina está desabilitada
    public static function rotinaEstaDesabilitada(string $rotina): bool
    {
        return self::where('DESROTINA', $rotina)->exists();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - DESSEQ identifica unicamente cada registro
2. **Validação antes de inserir** - Verificar se tabela/rotina já está desabilitada
3. **Evitar duplicatas** - PK previne duplicatas
4. **Manter nomes consistentes** - Garantir que nomes de tabelas e rotinas sejam consistentes
5. **Documentação clara** - Documentar motivo da desabilitação quando possível

### Performance

1. **Tabela pequena** - 25 registros, performance excelente
2. **Índices recomendados** - Índices em DESTABELA e DESROTINA para consultas frequentes
3. **Consultas frequentes** - Verificações de desabilitação são comuns durante operações
4. **Cache recomendado** - Tabela pequena e estável, ideal para cache em memória

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se tabela/rotina já está desabilitada
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que nomes de tabelas e rotinas sejam válidos
4. **Validação de nomes** - Garantir que nomes sejam preenchidos corretamente

### Manutenção

1. **Revisão periódica** - Verificar se funcionalidades desabilitadas ainda precisam estar desabilitadas
2. **Padronização** - Manter estrutura de dados consistente
3. **Documentação** - Documentar motivo da desabilitação quando possível
4. **Backup regular** - Tabela importante para controle do sistema
5. **Reativação controlada** - Processo claro para reativar funcionalidades quando necessário

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

