# HISCOM - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: HISCOM (Histórico de Comissão)
- **Total de Registros**: 1
- **Total de Colunas**: 2
- **Chave Primária**: HCCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (COMISSAO)
- **Banco de Dados**: Firebird

## 📝 Descrição

**HISCOM** é uma tabela mestre que armazena tipos de histórico de comissão utilizados para categorização e controle de comissões. Com apenas **1 registro**, representa diferentes tipos de histórico que permitem classificação e rastreamento de comissões.

Esta tabela funciona como **catálogo de tipos de histórico de comissão** e permite:
- Categorizar comissões por tipo de histórico
- Facilitar rastreamento e controle de comissões
- Suportar classificação de comissões
- Facilitar gestão de histórico de comissões

Cada registro representa um tipo de histórico de comissão específico, contendo:
- Código do histórico (HCCODIGO)
- Descrição do histórico (HCDESCRICAO)

O sistema utiliza esta tabela para organizar comissões por tipo de histórico, sendo referenciada por COMISSAO (comissões) para vincular comissões a tipos de histórico específicos.

**Observação Importante:** HISCOM é uma tabela mestre de tipos de histórico de comissão. Com apenas 1 registro, indica uso muito limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HCCODIGO** 🔑 | INTEGER | ✓ | Código do histórico de comissão (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **HCDESCRICAO** | VARCHAR(37) | ✓ | Descrição do histórico de comissão |

**Primary Key:** HCCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### HISCOM Referencia (0 FKs):

Nenhuma foreign key direta.

---

### HISCOM é Referenciada Por (1 tabela):

#### 1. COMISSAO - Comissões
**Relacionamento:**
```
COMISSAO.HCCODIGO → HISCOM.HCCODIGO (N:1)
Constraint: HISCOM_COMISSAO
```

**Descrição**: Cada comissão pode estar vinculada a um tipo de histórico específico.

**Informações da Tabela COMISSAO:**
- **Total:** Informação não disponível
- **PK:** Informação não disponível
- **Colunas:** Informação não disponível

**Uso:** Vincular comissões a tipos de histórico para rastreamento e controle.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Histórico de Comissão

**Objetivo:** Obter informações de um histórico de comissão específico.

```sql
SELECT
    HCCODIGO,
    HCDESCRICAO AS HISTORICO_COMISSAO
FROM HISCOM
WHERE HCCODIGO = ?;
```

---

### 2. Listar Todos os Históricos de Comissão

**Objetivo:** Obter catálogo completo de históricos de comissão.

```sql
SELECT
    HCCODIGO,
    HCDESCRICAO AS HISTORICO_COMISSAO
FROM HISCOM
ORDER BY HCDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com HISCOM | Tipo |
|--------|-----------|---------------------|------|
| **HISCOM** | 1 | 1:1 | **TABELA PRINCIPAL** |
| COMISSAO | Informação não disponível | - | Comissões vinculadas |

**Interpretação:**
- **1 tipo de histórico de comissão** cadastrado no sistema

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_HISCOM_DESCRICAO ON HISCOM(HCDESCRICAO)
    WHERE HCDESCRICAO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdHiscom extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'HISCOM';
    
    protected $primaryKey = 'HCCODIGO';
    public $incrementing = true;

    protected $casts = [
        'HCCODIGO' => 'integer',
        'HCDESCRICAO' => 'string',
    ];

    // Relacionamento com COMISSAO
    public function comissoes(): HasMany
    {
        return $this->hasMany(FirebirdComissao::class, 'HCCODIGO', 'HCCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

