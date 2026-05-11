# MODARMACAOSISEXT - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODARMACAOSISEXT (Integração de Modelos de Armação com Sistemas Externos)
- **Total de Registros**: 62
- **Total de Colunas**: 3
- **Chave Primária**: MODCODIGO, MSENOME (composta)
- **Chaves Estrangeiras**: 2 (MODARMACAO, SISTEMAEXT)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODARMACAOSISEXT** é uma tabela que armazena mapeamentos de modelos de armação internos para códigos de sistemas externos. Com **62 registros**, representa integrações entre modelos de armação do sistema e sistemas externos, permitindo sincronização e comunicação entre sistemas.

Esta tabela funciona como **tabela de integração** e permite:
- Mapear modelos de armação internos para códigos externos
- Vincular modelos a sistemas externos específicos
- Facilitar sincronização entre sistemas
- Suportar comunicação com sistemas externos
- Manter histórico detalhado de integrações
- Permitir múltiplas integrações por modelo

Cada registro representa um mapeamento específico entre um modelo de armação interno e um código de sistema externo, contendo:
- Código externo (MSECODIGO)
- Código do modelo interno (MODCODIGO)
- Nome do sistema externo (MSENOME)

O sistema utiliza esta tabela para manter histórico completo de integrações de modelos de armação com sistemas externos, sendo referenciada por MODARMACAO através de MODCODIGO e por SISTEMAEXT através de MSENOME.

**Observação Importante:** MODARMACAOSISEXT é uma tabela de integração de modelos de armação com sistemas externos. Com 62 registros, indica uso moderado desta funcionalidade. Possui chave primária composta (MODCODIGO, MSENOME) e referencia MODARMACAO e SISTEMAEXT, indicando sua função de ponte entre sistemas.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MODCODIGO** 🔑 🔗 | INTEGER | ✓ | Código do modelo de armação (PK, FK) |
| **MSENOME** 🔑 🔗 | VARCHAR(37) | ✓ | Nome do sistema externo (PK, FK) |

### Informações da Integração
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **MSECODIGO** | VARCHAR(37) | ✓ | Código do modelo no sistema externo |

**Primary Key:** MODCODIGO, MSENOME (composta)

**Foreign Keys:**
- `MODARMACAO_MODARMACAOSISEXT`: MODCODIGO → MODARMACAO.MODCODIGO
- `SISTEMAEXT_MODARMACAOSISEXT`: MSENOME → SISTEMAEXT.SIENOME

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODARMACAOSISEXT Referencia (2 tabelas):

#### 1. MODARMACAO - Modelos de Armação
**Relacionamento:**
```
MODARMACAOSISEXT.MODCODIGO → MODARMACAO.MODCODIGO (N:1)
Constraint: MODARMACAO_MODARMACAOSISEXT
```

**Descrição**: Cada integração está vinculada a um modelo de armação específico.

**Informações da Tabela MODARMACAO:**
- **Total:** 31 modelos
- **PK:** MODCODIGO
- **Colunas:** 9 campos

**Uso:** Vincular integrações a modelos de armação internos.

---

#### 2. SISTEMAEXT - Sistemas Externos
**Relacionamento:**
```
MODARMACAOSISEXT.MSENOME → SISTEMAEXT.SIENOME (N:1)
Constraint: SISTEMAEXT_MODARMACAOSISEXT
```

**Descrição**: Cada integração está vinculada a um sistema externo específico.

**Informações da Tabela SISTEMAEXT:**
- **Total:** 26 sistemas
- **PK:** SIECODIGO
- **Colunas:** 5 campos

**Uso:** Vincular integrações a sistemas externos.

---

### MODARMACAOSISEXT é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MODARMACAOSISEXT diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via MODARMACAO → OCLENTE

**Fluxo:** MODARMACAOSISEXT → MODARMACAO → OCLENTE → Operações

**Descrição:** Através dos modelos de armação, é possível identificar orçamentos relacionados.

**Uso:** Análise de integrações através de orçamentos.

---

### Via SISTEMAEXT → Outras Integrações

**Fluxo:** MODARMACAOSISEXT → SISTEMAEXT → Outras Integrações → Operações

**Descrição:** Através dos sistemas externos, é possível identificar outras integrações relacionadas.

**Uso:** Análise de integrações através de outras integrações.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Integração de Modelo

**Objetivo:** Obter informações de uma integração específica.

```sql
SELECT
    ms.MSECODIGO,
    ms.MODCODIGO,
    ms.MSENOME,
    m.MODDESCRICAO AS MODELO_DESCRICAO,
    s.SIENOME AS SISTEMA_NOME
FROM MODARMACAOSISEXT ms
INNER JOIN MODARMACAO m ON m.MODCODIGO = ms.MODCODIGO
INNER JOIN SISTEMAEXT s ON s.SIENOME = ms.MSENOME
WHERE ms.MODCODIGO = ? AND ms.MSENOME = ?;
```

---

### 2. Listar Integrações de um Modelo

**Objetivo:** Obter todas as integrações de um modelo específico.

```sql
SELECT
    ms.MSENOME AS SISTEMA_EXTERNO,
    ms.MSECODIGO AS CODIGO_EXTERNO,
    s.SIEURLWEBSERVICE AS URL_WEBSERVICE
FROM MODARMACAOSISEXT ms
INNER JOIN SISTEMAEXT s ON s.SIENOME = ms.MSENOME
WHERE ms.MODCODIGO = ?
ORDER BY ms.MSENOME;
```

---

### 3. Análise de Integrações por Sistema

**Objetivo:** Identificar distribuição de integrações por sistema externo.

**Query SQL:**
```sql
SELECT
    ms.MSENOME AS SISTEMA_EXTERNO,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT ms.MODCODIGO) AS TOTAL_MODELOS_AFETADOS
FROM MODARMACAOSISEXT ms
GROUP BY ms.MSENOME
ORDER BY TOTAL_INTEGRACOES DESC;
```

---

### 4. Buscar Código Externo de um Modelo

**Objetivo:** Obter código externo de um modelo em um sistema específico.

```sql
SELECT
    MSECODIGO AS CODIGO_EXTERNO
FROM MODARMACAOSISEXT
WHERE MODCODIGO = ? AND MSENOME = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODARMACAOSISEXT | Tipo |
|--------|-----------|------------------------------|------|
| **MODARMACAOSISEXT** | 62 | 1:1 | **TABELA PRINCIPAL** |
| MODARMACAO | 31 | 1:2 | Modelos (média de 2 integrações por modelo) |
| SISTEMAEXT | 26 | 1:2.4 | Sistemas (média de 2.4 integrações por sistema) |

**Interpretação:**
- **62 integrações** registradas no sistema
- **Média de 2 integrações por modelo** - indica uso extensivo de integração
- **Média de 2.4 integrações por sistema** - indica distribuição equilibrada entre sistemas

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por modelo (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MODARMACAOSISEXT_MODELO ON MODARMACAOSISEXT(MODCODIGO);

-- Índice 2: Busca por sistema (consultas frequentes)
CREATE INDEX IDX_MODARMACAOSISEXT_SISTEMA ON MODARMACAOSISEXT(MSENOME);
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

final class FirebirdModarmacaosisext extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODARMACAOSISEXT';
    
    protected $primaryKey = ['MODCODIGO', 'MSENOME'];
    public $incrementing = false;

    protected $casts = [
        'MSECODIGO' => 'string',
        'MODCODIGO' => 'integer',
        'MSENOME' => 'string',
    ];

    // Relacionamento com MODARMACAO
    public function modeloArmacao(): BelongsTo
    {
        return $this->belongsTo(FirebirdModarmacao::class, 'MODCODIGO', 'MODCODIGO');
    }

    // Relacionamento com SISTEMAEXT
    public function sistemaExterno(): BelongsTo
    {
        return $this->belongsTo(FirebirdSistemaext::class, 'MSENOME', 'SIENOME');
    }

    public function scopePorModelo($query, int $modCodigo)
    {
        return $query->where('MODCODIGO', $modCodigo);
    }

    public function scopePorSistema($query, string $msenome)
    {
        return $query->where('MSENOME', $msenome);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

