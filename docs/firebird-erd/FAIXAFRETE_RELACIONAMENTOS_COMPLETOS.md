# FAIXAFRETE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: FAIXAFRETE (Faixa de Frete)
- **Total de Registros**: 2
- **Total de Colunas**: 5
- **Chave Primária**: ID_FXF (simples)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 1 (FAIXAFRETEVR)
- **Banco de Dados**: Firebird

## 📝 Descrição

**FAIXAFRETE** é uma tabela que armazena faixas de peso para cálculo de frete por transportadora. Com apenas **2 registros**, representa configurações de faixas de peso que definem valores de frete baseados em intervalos de peso para diferentes transportadoras e empresas.

Esta tabela funciona como **configuração de faixas de peso para frete** e permite:
- Definir faixas de peso (inicial e final) para cálculo de frete
- Vincular faixas a transportadoras específicas
- Configurar faixas por empresa
- Suportar valores de frete por estado (através de FAIXAFRETEVR)
- Facilitar cálculo de frete baseado em peso
- Manter configurações específicas de frete por transportadora e empresa

Cada registro representa uma faixa de peso específica para uma transportadora e empresa, contendo:
- Identificador único da faixa (ID_FXF)
- Código da transportadora (TRACODIGO) - FK → TRANS
- Código da empresa (EMPCODIGO)
- Peso inicial da faixa (FXFPESOINI)
- Peso final da faixa (FXFPESOFIN)

O sistema utiliza esta tabela para calcular valores de frete baseados em faixas de peso, permitindo configurações específicas por transportadora, empresa e estado (através de FAIXAFRETEVR).

**Observação Importante:** FAIXAFRETE é uma tabela de configuração de frete por peso. Com apenas 2 registros, indica uso limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário. É referenciada por FAIXAFRETEVR que armazena valores de frete por estado.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_FXF** 🔑 | INTEGER | ✓ | Identificador único da faixa de frete (PK) |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **TRACODIGO** 🔗 | INTEGER | | Código da transportadora (FK → TRANS) |
| **EMPCODIGO** | INTEGER | | Código da empresa |

### Informações da Faixa
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FXFPESOINI** | NUMERIC(16,2) | | Peso inicial da faixa |
| **FXFPESOFIN** | NUMERIC(16,2) | | Peso final da faixa |

**Primary Key:** ID_FXF

**Foreign Keys:**
- `TRACODIGO` → `TRANS.TRACODIGO` (Constraint: FAIXAFRETE_TRANS)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### FAIXAFRETE Referencia (1 FK):

#### 1. TRANS - Transportadoras
**Relacionamento:**
```
FAIXAFRETE.TRACODIGO → TRANS.TRACODIGO (N:1)
Constraint: FAIXAFRETE_TRANS
```

**Descrição**: Cada faixa de frete está vinculada a uma transportadora específica.

**Informações da Tabela TRANS:**
- **Total:** Informação não disponível
- **PK:** TRACODIGO
- **Colunas:** Informação não disponível

**Uso:** Identificar a transportadora à qual a faixa de frete pertence.

---

### FAIXAFRETE é Referenciada Por (1 tabela):

#### 1. FAIXAFRETEVR - Valores de Frete por Estado
**Relacionamento:**
```
FAIXAFRETEVR.ID_FXFVR → FAIXAFRETE.ID_FXF (N:1)
Constraint: FAIXAFRETE_FAIXAFRETEVR
```

**Descrição**: Cada faixa de frete pode ter múltiplos valores por estado.

**Informações da Tabela FAIXAFRETEVR:**
- **Total:** 4 valores por estado
- **PK:** (ID_FXFVR, UF)
- **Colunas:** 3 campos

**Uso:** Armazenar valores de frete específicos por estado para cada faixa de peso.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via FAIXAFRETEVR → UF → Outras Operações Geográficas

**Fluxo:** FAIXAFRETE → FAIXAFRETEVR → UF → Operações

**Descrição:** Através dos valores por estado, é possível identificar outras operações relacionadas.

**Uso:** Análise de frete por estado através das faixas.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Faixa de Frete

**Objetivo:** Obter visão completa de uma faixa de frete incluindo transportadora e valores por estado.

**Fluxo:**
```
FAIXAFRETE (ID_FXF)
  ↓
TRANS (TRACODIGO)
  ↓
FAIXAFRETEVR (ID_FXFVR)
  ↓
UF (UFCODIGO)
```

**Query SQL:**
```sql
SELECT
    ff.ID_FXF,
    ff.TRACODIGO,
    t.TRANOME AS TRANSPORTADORA,
    ff.EMPCODIGO,
    e.EMPNOMEFANT AS EMPRESA,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL,
    COUNT(fvr.UF) AS TOTAL_ESTADOS,
    AVG(fvr.FXFVRVALOR) AS VALOR_MEDIO_FRETE
FROM FAIXAFRETE ff
LEFT JOIN TRANS t ON t.TRACODIGO = ff.TRACODIGO
LEFT JOIN EMPRESA e ON e.EMPCODIGO = ff.EMPCODIGO
LEFT JOIN FAIXAFRETEVR fvr ON fvr.ID_FXFVR = ff.ID_FXF
WHERE ff.ID_FXF = ?
GROUP BY ff.ID_FXF, ff.TRACODIGO, t.TRANOME, ff.EMPCODIGO, e.EMPNOMEFANT,
         ff.FXFPESOINI, ff.FXFPESOFIN;
```

---

### Exemplo 2: Análise de Faixas de Frete por Transportadora

**Objetivo:** Identificar todas as faixas de frete de uma transportadora específica.

**Query SQL:**
```sql
SELECT
    ID_FXF,
    EMPCODIGO,
    FXFPESOINI AS PESO_INICIAL,
    FXFPESOFIN AS PESO_FINAL,
    COUNT(fvr.UF) AS TOTAL_ESTADOS
FROM FAIXAFRETE ff
LEFT JOIN FAIXAFRETEVR fvr ON fvr.ID_FXFVR = ff.ID_FXF
WHERE TRACODIGO = ?
GROUP BY ID_FXF, EMPCODIGO, FXFPESOINI, FXFPESOFIN
ORDER BY FXFPESOINI;
```

---

### Exemplo 3: Análise de Faixas de Frete por Peso

**Objetivo:** Identificar faixas de frete que contêm um peso específico.

**Query SQL:**
```sql
SELECT
    ff.ID_FXF,
    ff.TRACODIGO,
    t.TRANOME AS TRANSPORTADORA,
    ff.EMPCODIGO,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL
FROM FAIXAFRETE ff
LEFT JOIN TRANS t ON t.TRACODIGO = ff.TRACODIGO
WHERE ? BETWEEN ff.FXFPESOINI AND ff.FXFPESOFIN
ORDER BY ff.TRACODIGO, ff.FXFPESOINI;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Faixa de Frete

**Objetivo:** Obter informações de uma faixa de frete específica.

```sql
SELECT
    ID_FXF,
    TRACODIGO,
    EMPCODIGO,
    FXFPESOINI AS PESO_INICIAL,
    FXFPESOFIN AS PESO_FINAL
FROM FAIXAFRETE
WHERE ID_FXF = ?;
```

---

### 2. Listar Faixas de Frete por Transportadora

**Objetivo:** Obter todas as faixas de frete de uma transportadora específica.

```sql
SELECT
    ID_FXF,
    EMPCODIGO,
    FXFPESOINI AS PESO_INICIAL,
    FXFPESOFIN AS PESO_FINAL
FROM FAIXAFRETE
WHERE TRACODIGO = ?
ORDER BY FXFPESOINI;
```

---

### 3. Análise de Faixas de Frete por Empresa

**Objetivo:** Identificar distribuição de faixas por empresa.

**Query SQL:**
```sql
SELECT
    EMPCODIGO,
    COUNT(*) AS TOTAL_FAIXAS,
    MIN(FXFPESOINI) AS MENOR_PESO,
    MAX(FXFPESOFIN) AS MAIOR_PESO
FROM FAIXAFRETE
WHERE EMPCODIGO IS NOT NULL
GROUP BY EMPCODIGO
ORDER BY TOTAL_FAIXAS DESC;
```

---

### 4. Análise de Faixas de Frete com Valores por Estado

**Objetivo:** Identificar faixas que possuem valores configurados por estado.

**Query SQL:**
```sql
SELECT
    ff.ID_FXF,
    ff.TRACODIGO,
    ff.EMPCODIGO,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL,
    COUNT(fvr.UF) AS TOTAL_ESTADOS,
    AVG(fvr.FXFVRVALOR) AS VALOR_MEDIO_FRETE
FROM FAIXAFRETE ff
LEFT JOIN FAIXAFRETEVR fvr ON fvr.ID_FXFVR = ff.ID_FXF
GROUP BY ff.ID_FXF, ff.TRACODIGO, ff.EMPCODIGO, ff.FXFPESOINI, ff.FXFPESOFIN
HAVING COUNT(fvr.UF) > 0
ORDER BY TOTAL_ESTADOS DESC;
```

---

### 5. Validação de Faixas de Peso Sobrepostas

**Objetivo:** Identificar faixas de peso que se sobrepõem para a mesma transportadora e empresa.

**Query SQL:**
```sql
SELECT
    f1.ID_FXF AS ID_FAIXA_1,
    f1.TRACODIGO,
    f1.EMPCODIGO,
    f1.FXFPESOINI AS PESO_INI_1,
    f1.FXFPESOFIN AS PESO_FIM_1,
    f2.ID_FXF AS ID_FAIXA_2,
    f2.FXFPESOINI AS PESO_INI_2,
    f2.FXFPESOFIN AS PESO_FIM_2
FROM FAIXAFRETE f1
INNER JOIN FAIXAFRETE f2 ON f2.TRACODIGO = f1.TRACODIGO
                         AND f2.EMPCODIGO = f1.EMPCODIGO
                         AND f2.ID_FXF > f1.ID_FXF
WHERE (f1.FXFPESOINI BETWEEN f2.FXFPESOINI AND f2.FXFPESOFIN
   OR f1.FXFPESOFIN BETWEEN f2.FXFPESOINI AND f2.FXFPESOFIN
   OR f2.FXFPESOINI BETWEEN f1.FXFPESOINI AND f1.FXFPESOFIN
   OR f2.FXFPESOFIN BETWEEN f1.FXFPESOINI AND f1.FXFPESOFIN)
ORDER BY f1.TRACODIGO, f1.EMPCODIGO, f1.FXFPESOINI;
```

---

### 6. Relatório Completo de Faixas de Frete

**Objetivo:** Analisar distribuição completa de faixas de frete no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_FAIXAS,
    COUNT(DISTINCT TRACODIGO) AS TOTAL_TRANSPORTADORAS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS,
    MIN(FXFPESOINI) AS MENOR_PESO,
    MAX(FXFPESOFIN) AS MAIOR_PESO,
    (SELECT COUNT(*) FROM FAIXAFRETEVR) AS TOTAL_VALORES_ESTADO
FROM FAIXAFRETE;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com FAIXAFRETE | Tipo |
|--------|-----------|------------------------|------|
| **FAIXAFRETE** | 2 | 1:1 | **TABELA PRINCIPAL** |
| FAIXAFRETEVR | 4 | 1:2 | Valores por estado (média de 2 valores por faixa) |

**Interpretação:**
- **2 faixas de frete** cadastradas no sistema
- **Média de 2 valores por estado por faixa** - indica configuração de valores por estado

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por transportadora (consultas frequentes)
CREATE INDEX IDX_FAIXAFRETE_TRANSPORTADORA ON FAIXAFRETE(TRACODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_FAIXAFRETE_EMPRESA ON FAIXAFRETE(EMPCODIGO)
    WHERE EMPCODIGO IS NOT NULL;

-- Índice 3: Busca por intervalo de peso (consultas frequentes)
CREATE INDEX IDX_FAIXAFRETE_PESO ON FAIXAFRETE(TRACODIGO, EMPCODIGO, FXFPESOINI, FXFPESOFIN);
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

final class FirebirdFaixafrete extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'FAIXAFRETE';
    
    protected $primaryKey = 'ID_FXF';
    public $incrementing = true;

    protected $casts = [
        'ID_FXF' => 'integer',
        'TRACODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'FXFPESOINI' => 'decimal:2',
        'FXFPESOFIN' => 'decimal:2',
    ];

    // Relacionamento com TRANS
    public function transportadora(): BelongsTo
    {
        return $this->belongsTo(FirebirdTrans::class, 'TRACODIGO', 'TRACODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCODIGO', 'EMPCODIGO');
    }

    // Relacionamento com FAIXAFRETEVR
    public function valoresPorEstado(): HasMany
    {
        return $this->hasMany(FirebirdFaixafretevr::class, 'ID_FXFVR', 'ID_FXF');
    }

    public function scopePorTransportadora($query, int $traCodigo)
    {
        return $query->where('TRACODIGO', $traCodigo);
    }

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorPeso($query, $peso)
    {
        return $query->where('FXFPESOINI', '<=', $peso)
                    ->where('FXFPESOFIN', '>=', $peso);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

