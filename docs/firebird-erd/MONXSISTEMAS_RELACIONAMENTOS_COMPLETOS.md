# MONXSISTEMAS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MONXSISTEMAS (Monitoramento de Sistemas)
- **Total de Registros**: 6
- **Total de Colunas**: 2
- **Chave Primária**: SISTEMA (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MONXSISTEMAS** é uma tabela que armazena informações sobre sistemas monitorados no banco de dados Firebird. Com **6 registros**, representa sistemas cadastrados para monitoramento, incluindo informações sobre código e nome do sistema.

Esta tabela funciona como **mestre de sistemas monitorados** e permite:
- Registrar sistemas para monitoramento
- Armazenar informações sobre código e nome
- Facilitar gestão de sistemas monitorados
- Manter histórico detalhado de sistemas

Cada registro representa um sistema específico monitorado, contendo:
- Código do sistema (CODIGO)
- Nome do sistema (SISTEMA)

O sistema utiliza esta tabela para manter histórico completo de sistemas monitorados, permitindo organização e gestão de monitoramento.

**Observação Importante:** MONXSISTEMAS é uma tabela mestre de sistemas monitorados. Com apenas 6 registros, indica uso limitado desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com outras tabelas de monitoramento através do campo SISTEMA.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **SISTEMA** 🔑 | VARCHAR(37) | ✓ | Nome do sistema (PK) |

### Informações do Sistema
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CODIGO** | INTEGER | ✓ | Código do sistema |

**Primary Key:** SISTEMA

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MONXSISTEMAS Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MONXSISTEMAS é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MONXSISTEMAS diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via SISTEMA → Outras Operações

**Fluxo:** MONXSISTEMAS → Operações por Sistema

**Descrição:** Através do nome do sistema, é possível identificar outras operações relacionadas.

**Uso:** Análise de sistemas através de operações.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Sistema

**Objetivo:** Obter informações de um sistema específico.

```sql
SELECT
    CODIGO,
    SISTEMA
FROM MONXSISTEMAS
WHERE SISTEMA = ?;
```

---

### 2. Listar Todos os Sistemas

**Objetivo:** Obter todos os sistemas monitorados.

```sql
SELECT
    CODIGO,
    SISTEMA
FROM MONXSISTEMAS
ORDER BY SISTEMA;
```

---

### 3. Análise de Sistemas

**Objetivo:** Identificar distribuição de sistemas.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_SISTEMAS,
    MIN(CODIGO) AS MENOR_CODIGO,
    MAX(CODIGO) AS MAIOR_CODIGO
FROM MONXSISTEMAS;
```

---

### 4. Buscar Sistema por Código

**Objetivo:** Obter sistema por código.

```sql
SELECT
    CODIGO,
    SISTEMA
FROM MONXSISTEMAS
WHERE CODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MONXSISTEMAS | Tipo |
|--------|-----------|--------------------------|------|
| **MONXSISTEMAS** | 6 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **6 sistemas** registrados no sistema
- Indica uso limitado desta funcionalidade de monitoramento

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por código (consultas frequentes)
CREATE INDEX IDX_MONXSISTEMAS_CODIGO ON MONXSISTEMAS(CODIGO)
    WHERE CODIGO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdMonxsistemas extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MONXSISTEMAS';
    
    protected $primaryKey = 'SISTEMA';
    public $incrementing = false;

    protected $casts = [
        'CODIGO' => 'integer',
        'SISTEMA' => 'string',
    ];

    public function scopePorCodigo($query, int $codigo)
    {
        return $query->where('CODIGO', $codigo);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('SISTEMA');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

