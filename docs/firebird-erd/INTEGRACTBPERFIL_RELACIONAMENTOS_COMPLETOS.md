# INTEGRACTBPERFIL - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INTEGRACTBPERFIL (Perfil de Integração Contábil)
- **Total de Registros**: 2
- **Total de Colunas**: 4
- **Chave Primária**: Composta (ITCCODIGO, EMPCODIGO)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (INTEGRACTBCONTAS, INTEGRACTBTBFIS)
- **Banco de Dados**: Firebird

## 📝 Descrição

**INTEGRACTBPERFIL** é uma tabela mestre que armazena perfis de integração contábil utilizados para configuração de integração com sistemas externos. Com apenas **2 registros**, representa diferentes perfis de integração que permitem agrupar configurações de contas e tabelas fiscais.

Esta tabela funciona como **catálogo de perfis de integração contábil** e permite:
- Agrupar configurações de integração contábil
- Definir perfis por empresa
- Facilitar gestão de integração contábil
- Suportar múltiplas origens de dados
- Facilitar configuração de integração

Cada registro representa um perfil de integração específico, contendo:
- Código do perfil (ITCCODIGO) - parte da PK
- Código da empresa (EMPCODIGO) - parte da PK
- Descrição do perfil (ITCDESCRICAO)
- Origem do perfil (ITCORIGEM)

O sistema utiliza esta tabela para organizar configurações de integração contábil, sendo referenciada por INTEGRACTBCONTAS (contas de integração) e INTEGRACTBTBFIS (tabelas fiscais de integração).

**Observação Importante:** INTEGRACTBPERFIL é uma tabela mestre de perfis de integração contábil. Com apenas 2 registros, indica uso muito limitado desta funcionalidade no momento. Possui chave primária composta e é referenciada por INTEGRACTBCONTAS e INTEGRACTBTBFIS.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITCCODIGO** 🔑 | VARCHAR(37) | ✓ | Código do perfil de integração (PK) |
| **EMPCODIGO** 🔑 | SMALLINT | ✓ | Código da empresa (PK) |

### Informações do Perfil
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITCDESCRICAO** | VARCHAR(37) | | Descrição do perfil de integração |
| **ITCORIGEM** | VARCHAR(37) | | Origem do perfil de integração |

**Primary Key:** (ITCCODIGO, EMPCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INTEGRACTBPERFIL Referencia (0 FKs):

Nenhuma foreign key direta.

---

### INTEGRACTBPERFIL é Referenciada Por (2 tabelas):

#### 1. INTEGRACTBCONTAS - Contas de Integração Contábil
**Relacionamento:**
```
INTEGRACTBCONTAS.(ITCCODIGO, EMPCODIGO) → INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO) (N:1)
Constraint: FK_INTEGRACTBCONTAS_1
```

**Descrição**: Cada conta de integração está vinculada a um perfil de integração específico.

**Informações da Tabela INTEGRACTBCONTAS:**
- **Total:** 24 contas
- **PK:** (ITCCODIGO, EMPCODIGO, CHAVE)
- **Colunas:** 13 campos

**Uso:** Vincular contas de integração a perfis de integração.

---

#### 2. INTEGRACTBTBFIS - Tabelas Fiscais de Integração Contábil
**Relacionamento:**
```
INTEGRACTBTBFIS.(ITCCODIGO, EMPCODIGO) → INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO) (N:1)
Constraint: FK_INTEGRACTBTBFIS_1
```

**Descrição**: Cada tabela fiscal de integração está vinculada a um perfil de integração específico.

**Informações da Tabela INTEGRACTBTBFIS:**
- **Total:** 17 tabelas fiscais
- **PK:** (ITCCODIGO, EMPCODIGO, FISCODIGO)
- **Colunas:** 3 campos

**Uso:** Vincular tabelas fiscais de integração a perfis de integração.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Perfil de Integração

**Objetivo:** Obter informações de um perfil de integração específico.

```sql
SELECT
    ITCCODIGO,
    EMPCODIGO,
    ITCDESCRICAO,
    ITCORIGEM
FROM INTEGRACTBPERFIL
WHERE ITCCODIGO = ?
  AND EMPCODIGO = ?;
```

---

### 2. Análise de Perfis com Contas e Tabelas Fiscais

**Objetivo:** Identificar perfis e suas configurações relacionadas.

**Query SQL:**
```sql
SELECT
    ip.ITCCODIGO,
    ip.EMPCODIGO,
    ip.ITCDESCRICAO,
    COUNT(DISTINCT icc.CHAVE) AS TOTAL_CONTAS,
    COUNT(DISTINCT itf.FISCODIGO) AS TOTAL_TABELAS_FISCAIS
FROM INTEGRACTBPERFIL ip
LEFT JOIN INTEGRACTBCONTAS icc ON icc.ITCCODIGO = ip.ITCCODIGO 
                              AND icc.EMPCODIGO = ip.EMPCODIGO
LEFT JOIN INTEGRACTBTBFIS itf ON itf.ITCCODIGO = ip.ITCCODIGO 
                             AND itf.EMPCODIGO = ip.EMPCODIGO
GROUP BY ip.ITCCODIGO, ip.EMPCODIGO, ip.ITCDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INTEGRACTBPERFIL | Tipo |
|--------|-----------|------------------------------|------|
| **INTEGRACTBPERFIL** | 2 | 1:1 | **TABELA PRINCIPAL** |
| INTEGRACTBCONTAS | 24 | 1:12 | Contas (média de 12 contas por perfil) |
| INTEGRACTBTBFIS | 17 | 1:8.5 | Tabelas fiscais (média de 8.5 tabelas por perfil) |

**Interpretação:**
- **2 perfis de integração** cadastrados no sistema
- **Média de 12 contas por perfil** - indica configuração detalhada
- **Média de 8.5 tabelas fiscais por perfil** - indica configuração detalhada

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBPERFIL_EMPRESA ON INTEGRACTBPERFIL(EMPCODIGO);
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

final class FirebirdIntegractbperfil extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INTEGRACTBPERFIL';
    
    protected $primaryKey = ['ITCCODIGO', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'ITCCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'ITCDESCRICAO' => 'string',
        'ITCORIGEM' => 'string',
    ];

    // Relacionamento com INTEGRACTBCONTAS
    public function contas(): HasMany
    {
        return $this->hasMany(FirebirdIntegractbcontas::class, ['ITCCODIGO', 'EMPCODIGO'], ['ITCCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com INTEGRACTBTBFIS
    public function tabelasFiscais(): HasMany
    {
        return $this->hasMany(FirebirdIntegractbtbfis::class, ['ITCCODIGO', 'EMPCODIGO'], ['ITCCODIGO', 'EMPCODIGO']);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

