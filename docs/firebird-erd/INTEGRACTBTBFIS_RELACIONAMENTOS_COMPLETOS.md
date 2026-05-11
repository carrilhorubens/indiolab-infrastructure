# INTEGRACTBTBFIS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: INTEGRACTBTBFIS (Tabelas Fiscais de Integração Contábil)
- **Total de Registros**: 17
- **Total de Colunas**: 3
- **Chave Primária**: Composta (ITCCODIGO, EMPCODIGO, FISCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**INTEGRACTBTBFIS** é uma tabela de relacionamento que vincula perfis de integração contábil a tabelas fiscais. Com **17 registros**, representa configurações de integração que permitem mapear tabelas fiscais específicas para cada perfil de integração.

Esta tabela funciona como **tabela de relacionamento** e permite:
- Vincular tabelas fiscais a perfis de integração contábil
- Configurar integração por empresa e perfil
- Facilitar gestão de integração contábil
- Suportar múltiplas tabelas fiscais por perfil
- Facilitar controle de integração fiscal

Cada registro representa uma vinculação específica entre um perfil de integração e uma tabela fiscal, contendo:
- Código do perfil de integração (ITCCODIGO) - FK → INTEGRACTBPERFIL (parte da PK)
- Código da empresa (EMPCODIGO) - FK → INTEGRACTBPERFIL (parte da PK)
- Código da tabela fiscal (FISCODIGO) - FK → TBFIS (parte da PK)

O sistema utiliza esta tabela para configurar quais tabelas fiscais estão vinculadas a cada perfil de integração contábil, permitindo controle de integração fiscal específico.

**Observação Importante:** INTEGRACTBTBFIS é uma tabela de relacionamento com chave primária composta. Com 17 registros, indica uso moderado desta funcionalidade. Possui relacionamentos com INTEGRACTBPERFIL e TBFIS.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ITCCODIGO** 🔑 🔗 | VARCHAR(37) | ✓ | Código do perfil de integração (PK + FK → INTEGRACTBPERFIL) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → INTEGRACTBPERFIL) |
| **FISCODIGO** 🔑 🔗 | VARCHAR(14) | ✓ | Código da tabela fiscal (PK + FK → TBFIS) |

**Primary Key:** (ITCCODIGO, EMPCODIGO, FISCODIGO)

**Foreign Keys:**
- `(ITCCODIGO, EMPCODIGO)` → `INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO)` (Constraint: FK_INTEGRACTBTBFIS_1)
- `FISCODIGO` → `TBFIS.FISCODIGO` (Constraint: FK_INTEGRACTBTBFIS_2)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### INTEGRACTBTBFIS Referencia (3 FKs):

#### 1. INTEGRACTBPERFIL - Perfil de Integração Contábil
**Relacionamento:**
```
INTEGRACTBTBFIS.(ITCCODIGO, EMPCODIGO) → INTEGRACTBPERFIL.(ITCCODIGO, EMPCODIGO) (N:1)
Constraint: FK_INTEGRACTBTBFIS_1
```

**Descrição**: Cada vinculação está relacionada a um perfil de integração específico de uma empresa.

**Informações da Tabela INTEGRACTBPERFIL:**
- **Total:** 2 perfis
- **PK:** (ITCCODIGO, EMPCODIGO)
- **Colunas:** 4 campos

**Uso:** Identificar o perfil de integração ao qual a tabela fiscal está vinculada.

---

#### 2. TBFIS - Tabelas Fiscais
**Relacionamento:**
```
INTEGRACTBTBFIS.FISCODIGO → TBFIS.FISCODIGO (N:1)
Constraint: FK_INTEGRACTBTBFIS_2
```

**Descrição**: Cada vinculação está relacionada a uma tabela fiscal específica.

**Informações da Tabela TBFIS:**
- **Total:** 311 tabelas fiscais
- **PK:** FISCODIGO
- **Colunas:** 81 campos

**Uso:** Identificar a tabela fiscal vinculada ao perfil de integração.

---

### INTEGRACTBTBFIS é Referenciada Por (0 tabelas):

Nenhuma tabela referencia INTEGRACTBTBFIS diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Tabelas Fiscais de um Perfil de Integração

**Objetivo:** Obter todas as tabelas fiscais vinculadas a um perfil de integração específico.

```sql
SELECT
    itf.FISCODIGO,
    tf.FISDESCRICAO AS TABELA_FISCAL
FROM INTEGRACTBTBFIS itf
INNER JOIN TBFIS tf ON tf.FISCODIGO = itf.FISCODIGO
WHERE itf.ITCCODIGO = ?
  AND itf.EMPCODIGO = ?
ORDER BY tf.FISDESCRICAO;
```

---

### 2. Análise de Perfis com Tabelas Fiscais

**Objetivo:** Identificar perfis e suas tabelas fiscais relacionadas.

**Query SQL:**
```sql
SELECT
    ip.ITCCODIGO,
    ip.EMPCODIGO,
    ip.ITCDESCRICAO AS PERFIL,
    COUNT(itf.FISCODIGO) AS TOTAL_TABELAS_FISCAIS
FROM INTEGRACTBPERFIL ip
LEFT JOIN INTEGRACTBTBFIS itf ON itf.ITCCODIGO = ip.ITCCODIGO 
                             AND itf.EMPCODIGO = ip.EMPCODIGO
GROUP BY ip.ITCCODIGO, ip.EMPCODIGO, ip.ITCDESCRICAO
ORDER BY TOTAL_TABELAS_FISCAIS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com INTEGRACTBTBFIS | Tipo |
|--------|-----------|----------------------------|------|
| **INTEGRACTBTBFIS** | 17 | 1:1 | **TABELA PRINCIPAL** |
| INTEGRACTBPERFIL | 2 | 1:8.5 | Perfis (média de 8.5 tabelas por perfil) |
| TBFIS | 311 | 1:0.05 | Tabelas fiscais (média de 0.05 integrações por tabela) |

**Interpretação:**
- **17 vinculações** entre perfis e tabelas fiscais
- **Média de 8.5 tabelas fiscais por perfil** - indica configuração detalhada

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por perfil e empresa (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBTBFIS_PERFIL ON INTEGRACTBTBFIS(ITCCODIGO, EMPCODIGO);

-- Índice 2: Busca por tabela fiscal (consultas frequentes)
CREATE INDEX IDX_INTEGRACTBTBFIS_TABELA_FISCAL ON INTEGRACTBTBFIS(FISCODIGO);
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

final class FirebirdIntegractbtbfis extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'INTEGRACTBTBFIS';
    
    protected $primaryKey = ['ITCCODIGO', 'EMPCODIGO', 'FISCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'ITCCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'FISCODIGO' => 'string',
    ];

    // Relacionamento com INTEGRACTBPERFIL
    public function perfil(): BelongsTo
    {
        return $this->belongsTo(FirebirdIntegractbperfil::class, ['ITCCODIGO', 'EMPCODIGO'], ['ITCCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com TBFIS
    public function tabelaFiscal(): BelongsTo
    {
        return $this->belongsTo(FirebirdTbfis::class, 'FISCODIGO', 'FISCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

