# FAIXAFRETEVR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: FAIXAFRETEVR (Faixa de Frete Valor por Estado)
- **Total de Registros**: 4
- **Total de Colunas**: 3
- **Chave Primária**: Composta (ID_FXFVR, UF)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**FAIXAFRETEVR** é uma tabela que armazena valores de frete por estado para cada faixa de peso. Com **4 registros**, representa valores específicos de frete que variam conforme o estado de destino, permitindo cálculo diferenciado de frete baseado em localização geográfica.

Esta tabela funciona como **valores de frete por estado** e permite:
- Definir valores de frete específicos por estado para cada faixa de peso
- Suportar cálculo diferenciado de frete por localização
- Vincular valores a faixas de peso específicas
- Facilitar gestão de frete regionalizado
- Manter configurações específicas de frete por estado
- Suportar políticas de frete diferenciadas por região

Cada registro representa um valor de frete específico para um estado dentro de uma faixa de peso, contendo:
- Identificador da faixa de frete (ID_FXFVR) - parte da PK + FK → FAIXAFRETE
- Estado (UF) - parte da PK
- Valor do frete (FXFVRVALOR)

O sistema utiliza esta tabela para calcular valores de frete baseados em faixas de peso e estado de destino, permitindo configurações específicas por região geográfica.

**Observação Importante:** FAIXAFRETEVR complementa FAIXAFRETE, fornecendo valores específicos por estado. Com 4 registros e chave primária composta, indica uso limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID_FXFVR** 🔑 🔗 | INTEGER | ✓ | Identificador da faixa de frete (PK + FK → FAIXAFRETE) |
| **UF** 🔑 | VARCHAR(14) | ✓ | Estado (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FXFVRVALOR** | NUMERIC(16,2) | | Valor do frete para o estado |

**Primary Key:** (ID_FXFVR, UF)

**Foreign Keys:**
- `ID_FXFVR` → `FAIXAFRETE.ID_FXF` (Constraint: FAIXAFRETE_FAIXAFRETEVR)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### FAIXAFRETEVR Referencia (1 FK):

#### 1. FAIXAFRETE - Faixas de Frete
**Relacionamento:**
```
FAIXAFRETEVR.ID_FXFVR → FAIXAFRETE.ID_FXF (N:1)
Constraint: FAIXAFRETE_FAIXAFRETEVR
```

**Descrição**: Cada valor por estado está vinculado a uma faixa de frete específica.

**Informações da Tabela FAIXAFRETE:**
- **Total:** 2 faixas
- **PK:** ID_FXF
- **Colunas:** 5 campos

**Uso:** Identificar a faixa de frete à qual o valor por estado pertence.

---

### FAIXAFRETEVR é Referenciada Por (0 tabelas):

Nenhuma tabela referencia FAIXAFRETEVR diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via FAIXAFRETE → TRANS → Outras Operações de Transporte

**Fluxo:** FAIXAFRETEVR → FAIXAFRETE → TRANS → Operações

**Descrição:** Através da faixa de frete e transportadora, é possível identificar outras operações relacionadas.

**Uso:** Análise de valores de frete através de transportadoras.

---

### Via UF → Outras Operações Geográficas

**Fluxo:** FAIXAFRETEVR → UF → Operações

**Descrição:** Através do estado, é possível identificar outras operações relacionadas.

**Uso:** Análise de valores de frete por estado.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Valor de Frete por Estado

**Objetivo:** Obter visão completa de um valor de frete incluindo informações da faixa, transportadora e estado.

**Fluxo:**
```
FAIXAFRETEVR (ID_FXFVR, UF)
  ↓
FAIXAFRETE (ID_FXF)
  ↓
TRANS (TRACODIGO)
  ↓
UF (UFCODIGO)
```

**Query SQL:**
```sql
SELECT
    fvr.ID_FXFVR,
    ff.TRACODIGO,
    t.TRANOME AS TRANSPORTADORA,
    ff.EMPCODIGO,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL,
    fvr.UF,
    uf.UFNOME AS ESTADO,
    fvr.FXFVRVALOR AS VALOR_FRETE
FROM FAIXAFRETEVR fvr
INNER JOIN FAIXAFRETE ff ON ff.ID_FXF = fvr.ID_FXFVR
LEFT JOIN TRANS t ON t.TRACODIGO = ff.TRACODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = fvr.UF
WHERE fvr.ID_FXFVR = ?
  AND fvr.UF = ?;
```

---

### Exemplo 2: Análise de Valores de Frete por Faixa

**Objetivo:** Identificar todos os valores de frete de uma faixa específica.

**Query SQL:**
```sql
SELECT
    UF,
    FXFVRVALOR AS VALOR_FRETE
FROM FAIXAFRETEVR
WHERE ID_FXFVR = ?
ORDER BY UF;
```

---

### Exemplo 3: Análise de Valores de Frete por Estado

**Objetivo:** Identificar valores de frete para um estado específico em todas as faixas.

**Query SQL:**
```sql
SELECT
    fvr.ID_FXFVR,
    ff.TRACODIGO,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL,
    fvr.FXFVRVALOR AS VALOR_FRETE
FROM FAIXAFRETEVR fvr
INNER JOIN FAIXAFRETE ff ON ff.ID_FXF = fvr.ID_FXFVR
WHERE fvr.UF = ?
ORDER BY ff.FXFPESOINI;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Valor de Frete por Estado

**Objetivo:** Obter valor de frete para um estado específico em uma faixa.

```sql
SELECT
    ID_FXFVR,
    UF,
    FXFVRVALOR AS VALOR_FRETE
FROM FAIXAFRETEVR
WHERE ID_FXFVR = ?
  AND UF = ?;
```

---

### 2. Listar Valores de Frete de uma Faixa

**Objetivo:** Obter todos os valores de frete de uma faixa específica.

```sql
SELECT
    UF,
    FXFVRVALOR AS VALOR_FRETE
FROM FAIXAFRETEVR
WHERE ID_FXFVR = ?
ORDER BY UF;
```

---

### 3. Análise de Valores de Frete por Estado

**Objetivo:** Identificar distribuição de valores de frete por estado.

**Query SQL:**
```sql
SELECT
    UF,
    COUNT(*) AS TOTAL_FAIXAS,
    AVG(FXFVRVALOR) AS VALOR_MEDIO_FRETE,
    MIN(FXFVRVALOR) AS VALOR_MINIMO_FRETE,
    MAX(FXFVRVALOR) AS VALOR_MAXIMO_FRETE
FROM FAIXAFRETEVR
GROUP BY UF
ORDER BY VALOR_MEDIO_FRETE DESC;
```

---

### 4. Análise de Valores de Frete por Faixa

**Objetivo:** Identificar distribuição de valores de frete por faixa.

**Query SQL:**
```sql
SELECT
    fvr.ID_FXFVR,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL,
    COUNT(fvr.UF) AS TOTAL_ESTADOS,
    AVG(fvr.FXFVRVALOR) AS VALOR_MEDIO_FRETE,
    MIN(fvr.FXFVRVALOR) AS VALOR_MINIMO_FRETE,
    MAX(fvr.FXFVRVALOR) AS VALOR_MAXIMO_FRETE
FROM FAIXAFRETEVR fvr
INNER JOIN FAIXAFRETE ff ON ff.ID_FXF = fvr.ID_FXFVR
GROUP BY fvr.ID_FXFVR, ff.FXFPESOINI, ff.FXFPESOFIN
ORDER BY ff.FXFPESOINI;
```

---

### 5. Cálculo de Frete por Peso e Estado

**Objetivo:** Calcular valor de frete para um peso e estado específicos.

**Query SQL:**
```sql
SELECT
    fvr.UF,
    fvr.FXFVRVALOR AS VALOR_FRETE,
    ff.FXFPESOINI AS PESO_INICIAL,
    ff.FXFPESOFIN AS PESO_FINAL
FROM FAIXAFRETEVR fvr
INNER JOIN FAIXAFRETE ff ON ff.ID_FXF = fvr.ID_FXFVR
WHERE ? BETWEEN ff.FXFPESOINI AND ff.FXFPESOFIN
  AND fvr.UF = ?
ORDER BY ff.FXFPESOINI;
```

---

### 6. Relatório Completo de Valores de Frete

**Objetivo:** Analisar distribuição completa de valores de frete no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_VALORES,
    COUNT(DISTINCT ID_FXFVR) AS TOTAL_FAIXAS,
    COUNT(DISTINCT UF) AS TOTAL_ESTADOS,
    AVG(FXFVRVALOR) AS VALOR_MEDIO_FRETE,
    MIN(FXFVRVALOR) AS VALOR_MINIMO_FRETE,
    MAX(FXFVRVALOR) AS VALOR_MAXIMO_FRETE
FROM FAIXAFRETEVR;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com FAIXAFRETEVR | Tipo |
|--------|-----------|---------------------------|------|
| **FAIXAFRETEVR** | 4 | 1:1 | **TABELA PRINCIPAL** |
| FAIXAFRETE | 2 | 1:2 | Faixas (média de 2 valores por faixa) |

**Interpretação:**
- **4 valores de frete por estado** cadastrados no sistema
- **Média de 2 valores por faixa** - indica configuração de valores por estado para cada faixa

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por faixa de frete (consultas frequentes)
CREATE INDEX IDX_FAIXAFRETEVR_FAIXA ON FAIXAFRETEVR(ID_FXFVR);

-- Índice 2: Busca por estado (consultas frequentes)
CREATE INDEX IDX_FAIXAFRETEVR_ESTADO ON FAIXAFRETEVR(UF);

-- Índice 3: Busca combinada faixa + estado (já coberto pela PK)
-- A PK já fornece índice eficiente
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

final class FirebirdFaixafretevr extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'FAIXAFRETEVR';
    
    protected $primaryKey = ['ID_FXFVR', 'UF'];
    public $incrementing = false;

    protected $casts = [
        'ID_FXFVR' => 'integer',
        'UF' => 'string',
        'FXFVRVALOR' => 'decimal:2',
    ];

    // Relacionamento com FAIXAFRETE
    public function faixaFrete(): BelongsTo
    {
        return $this->belongsTo(FirebirdFaixafrete::class, 'ID_FXFVR', 'ID_FXF');
    }

    // Relacionamento lógico com UF
    public function estado()
    {
        return $this->belongsTo(FirebirdUf::class, 'UF', 'UFCODIGO');
    }

    public function scopePorFaixa($query, int $idFxfvr)
    {
        return $query->where('ID_FXFVR', $idFxfvr);
    }

    public function scopePorEstado($query, string $uf)
    {
        return $query->where('UF', $uf);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

