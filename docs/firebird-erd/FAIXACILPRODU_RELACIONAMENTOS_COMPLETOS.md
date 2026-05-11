# FAIXACILPRODU - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: FAIXACILPRODU (Faixa Cilíndrica de Produção)
- **Total de Registros**: 1
- **Total de Colunas**: 8
- **Chave Primária**: Composta (PROCODIGO, FXCPROSEQ)
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**FAIXACILPRODU** é uma tabela que armazena faixas cilíndricas de produção para produtos específicos. Com apenas **1 registro**, representa configurações de faixas cilíndricas que definem valores de produção baseados em intervalos de cilindro para produtos óticos.

Esta tabela funciona como **configuração de faixas cilíndricas de produção** e permite:
- Definir faixas de cilindro (inicial e final) para produtos
- Configurar valores de produção por faixa cilíndrica
- Controlar tipos de quantidade (fixa ou variável)
- Suportar processos específicos por faixa
- Facilitar cálculo de valores de produção baseados em cilindro
- Manter configurações específicas de produção por produto

Cada registro representa uma faixa cilíndrica específica para um produto, contendo:
- Código do produto (PROCODIGO) - parte da PK + FK → PRODU
- Sequencial da faixa (FXCPROSEQ) - parte da PK
- Cilindro inicial da faixa (FXCPROCILINI)
- Cilindro final da faixa (FXCPROCILFIM)
- Valor de produção da faixa (FXCPROVRPRODU)
- Tipo de quantidade (FXCPROTIPOQTD)
- Quantidade fixa (FXCPROQTDFIXA)
- Processo relacionado (FXCPROPROCESSO)

O sistema utiliza esta tabela para calcular valores de produção baseados em faixas cilíndricas, permitindo configurações específicas por produto e faixa de cilindro.

**Observação Importante:** FAIXACILPRODU é uma tabela de configuração específica para produtos óticos que utilizam cilindro como parâmetro de produção. Com apenas 1 registro, indica uso limitado desta funcionalidade no momento, mas pode ser expandida conforme necessário.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **PROCODIGO** 🔑 🔗 | VARCHAR(37) | ✓ | Código do produto (PK + FK → PRODU) |
| **FXCPROSEQ** 🔑 | INTEGER | ✓ | Sequencial da faixa (PK) |

### Informações da Faixa
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **FXCPROCILINI** | NUMERIC(16,2) | | Cilindro inicial da faixa |
| **FXCPROCILFIM** | NUMERIC(16,2) | | Cilindro final da faixa |
| **FXCPROVRPRODU** | NUMERIC(16,2) | | Valor de produção da faixa |
| **FXCPROTIPOQTD** | VARCHAR(37) | | Tipo de quantidade (fixa/variável) |
| **FXCPROQTDFIXA** | NUMERIC(16,2) | | Quantidade fixa (se aplicável) |
| **FXCPROPROCESSO** | VARCHAR(37) | | Processo relacionado à faixa |

**Primary Key:** (PROCODIGO, FXCPROSEQ)

**Foreign Keys:**
- `PROCODIGO` → `PRODU.PROCODIGO` (Constraint: FK_FAIXACILPRODU_PRODU)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### FAIXACILPRODU Referencia (1 FK):

#### 1. PRODU - Produtos
**Relacionamento:**
```
FAIXACILPRODU.PROCODIGO → PRODU.PROCODIGO (N:1)
Constraint: FK_FAIXACILPRODU_PRODU
```

**Descrição**: Cada faixa cilíndrica está vinculada a um produto específico.

**Informações da Tabela PRODU:**
- **Total:** 178.187 produtos
- **PK:** PROCODIGO
- **Colunas:** 134 campos

**Uso:** Identificar o produto ao qual a faixa cilíndrica pertence.

---

### FAIXACILPRODU é Referenciada Por (0 tabelas):

Nenhuma tabela referencia FAIXACILPRODU diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PRODU → Outras Operações de Produtos

**Fluxo:** FAIXACILPRODU → PRODU → Operações

**Descrição:** Através do produto, é possível identificar outras operações relacionadas.

**Uso:** Análise de faixas cilíndricas através de produtos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Faixa Cilíndrica

**Objetivo:** Obter visão completa de uma faixa cilíndrica incluindo informações do produto.

**Fluxo:**
```
FAIXACILPRODU (PROCODIGO, FXCPROSEQ)
  ↓
PRODU (PROCODIGO)
```

**Query SQL:**
```sql
SELECT
    fcp.PROCODIGO,
    p.PRONOME AS PRODUTO,
    fcp.FXCPROSEQ AS SEQUENCIAL_FAIXA,
    fcp.FXCPROCILINI AS CILINDRO_INICIAL,
    fcp.FXCPROCILFIM AS CILINDRO_FINAL,
    fcp.FXCPROVRPRODU AS VALOR_PRODUCAO,
    fcp.FXCPROTIPOQTD AS TIPO_QUANTIDADE,
    fcp.FXCPROQTDFIXA AS QUANTIDADE_FIXA,
    fcp.FXCPROPROCESSO AS PROCESSO
FROM FAIXACILPRODU fcp
INNER JOIN PRODU p ON p.PROCODIGO = fcp.PROCODIGO
WHERE fcp.PROCODIGO = ?
  AND fcp.FXCPROSEQ = ?;
```

---

### Exemplo 2: Análise de Faixas Cilíndricas por Produto

**Objetivo:** Identificar todas as faixas cilíndricas de um produto específico.

**Query SQL:**
```sql
SELECT
    FXCPROSEQ AS SEQUENCIAL_FAIXA,
    FXCPROCILINI AS CILINDRO_INICIAL,
    FXCPROCILFIM AS CILINDRO_FINAL,
    FXCPROVRPRODU AS VALOR_PRODUCAO,
    FXCPROTIPOQTD AS TIPO_QUANTIDADE,
    FXCPROQTDFIXA AS QUANTIDADE_FIXA,
    FXCPROPROCESSO AS PROCESSO
FROM FAIXACILPRODU
WHERE PROCODIGO = ?
ORDER BY FXCPROCILINI;
```

---

### Exemplo 3: Análise de Faixas Cilíndricas por Intervalo

**Objetivo:** Identificar faixas cilíndricas que contêm um valor específico de cilindro.

**Query SQL:**
```sql
SELECT
    fcp.PROCODIGO,
    p.PRONOME AS PRODUTO,
    fcp.FXCPROSEQ AS SEQUENCIAL_FAIXA,
    fcp.FXCPROCILINI AS CILINDRO_INICIAL,
    fcp.FXCPROCILFIM AS CILINDRO_FINAL,
    fcp.FXCPROVRPRODU AS VALOR_PRODUCAO
FROM FAIXACILPRODU fcp
INNER JOIN PRODU p ON p.PROCODIGO = fcp.PROCODIGO
WHERE ? BETWEEN fcp.FXCPROCILINI AND fcp.FXCPROCILFIM
ORDER BY fcp.PROCODIGO, fcp.FXCPROCILINI;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Faixa Cilíndrica

**Objetivo:** Obter informações de uma faixa cilíndrica específica.

```sql
SELECT
    PROCODIGO,
    FXCPROSEQ AS SEQUENCIAL_FAIXA,
    FXCPROCILINI AS CILINDRO_INICIAL,
    FXCPROCILFIM AS CILINDRO_FINAL,
    FXCPROVRPRODU AS VALOR_PRODUCAO,
    FXCPROTIPOQTD AS TIPO_QUANTIDADE,
    FXCPROQTDFIXA AS QUANTIDADE_FIXA,
    FXCPROPROCESSO AS PROCESSO
FROM FAIXACILPRODU
WHERE PROCODIGO = ?
  AND FXCPROSEQ = ?;
```

---

### 2. Listar Faixas Cilíndricas de um Produto

**Objetivo:** Obter todas as faixas cilíndricas de um produto específico.

```sql
SELECT
    FXCPROSEQ AS SEQUENCIAL_FAIXA,
    FXCPROCILINI AS CILINDRO_INICIAL,
    FXCPROCILFIM AS CILINDRO_FINAL,
    FXCPROVRPRODU AS VALOR_PRODUCAO,
    FXCPROTIPOQTD AS TIPO_QUANTIDADE
FROM FAIXACILPRODU
WHERE PROCODIGO = ?
ORDER BY FXCPROCILINI;
```

---

### 3. Análise de Faixas Cilíndricas por Tipo de Quantidade

**Objetivo:** Identificar distribuição de faixas por tipo de quantidade.

**Query SQL:**
```sql
SELECT
    FXCPROTIPOQTD AS TIPO_QUANTIDADE,
    COUNT(*) AS TOTAL_FAIXAS,
    AVG(FXCPROVRPRODU) AS VALOR_MEDIO_PRODUCAO
FROM FAIXACILPRODU
WHERE FXCPROTIPOQTD IS NOT NULL
GROUP BY FXCPROTIPOQTD
ORDER BY TOTAL_FAIXAS DESC;
```

---

### 4. Análise de Faixas Cilíndricas por Processo

**Objetivo:** Identificar distribuição de faixas por processo.

**Query SQL:**
```sql
SELECT
    FXCPROPROCESSO AS PROCESSO,
    COUNT(*) AS TOTAL_FAIXAS,
    AVG(FXCPROVRPRODU) AS VALOR_MEDIO_PRODUCAO
FROM FAIXACILPRODU
WHERE FXCPROPROCESSO IS NOT NULL
GROUP BY FXCPROPROCESSO
ORDER BY TOTAL_FAIXAS DESC;
```

---

### 5. Validação de Faixas Cilíndricas Sobrepostas

**Objetivo:** Identificar faixas cilíndricas que se sobrepõem para o mesmo produto.

**Query SQL:**
```sql
SELECT
    f1.PROCODIGO,
    f1.FXCPROSEQ AS SEQ_FAIXA_1,
    f1.FXCPROCILINI AS CIL_INI_1,
    f1.FXCPROCILFIM AS CIL_FIM_1,
    f2.FXCPROSEQ AS SEQ_FAIXA_2,
    f2.FXCPROCILINI AS CIL_INI_2,
    f2.FXCPROCILFIM AS CIL_FIM_2
FROM FAIXACILPRODU f1
INNER JOIN FAIXACILPRODU f2 ON f2.PROCODIGO = f1.PROCODIGO
                            AND f2.FXCPROSEQ > f1.FXCPROSEQ
WHERE (f1.FXCPROCILINI BETWEEN f2.FXCPROCILINI AND f2.FXCPROCILFIM
   OR f1.FXCPROCILFIM BETWEEN f2.FXCPROCILINI AND f2.FXCPROCILFIM
   OR f2.FXCPROCILINI BETWEEN f1.FXCPROCILINI AND f1.FXCPROCILFIM
   OR f2.FXCPROCILFIM BETWEEN f1.FXCPROCILINI AND f1.FXCPROCILFIM)
ORDER BY f1.PROCODIGO, f1.FXCPROSEQ;
```

---

### 6. Relatório Completo de Faixas Cilíndricas

**Objetivo:** Analisar distribuição completa de faixas cilíndricas no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_FAIXAS,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_PRODUTOS,
    AVG(FXCPROVRPRODU) AS VALOR_MEDIO_PRODUCAO,
    MIN(FXCPROCILINI) AS MENOR_CILINDRO,
    MAX(FXCPROCILFIM) AS MAIOR_CILINDRO,
    COUNT(CASE WHEN FXCPROTIPOQTD IS NOT NULL THEN 1 END) AS COM_TIPO_QUANTIDADE,
    COUNT(CASE WHEN FXCPROPROCESSO IS NOT NULL THEN 1 END) AS COM_PROCESSO
FROM FAIXACILPRODU;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com FAIXACILPRODU | Tipo |
|--------|-----------|----------------------------|------|
| **FAIXACILPRODU** | 1 | 1:1 | **TABELA PRINCIPAL** |
| PRODU | 178.187 | 1:178187 | Produtos (média de 0.0000056 faixas por produto) |

**Interpretação:**
- **1 faixa cilíndrica** cadastrada no sistema
- **Média de 0.0000056 faixas por produto** - indica uso muito limitado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por produto (consultas frequentes)
CREATE INDEX IDX_FAIXACILPRODU_PRODUTO ON FAIXACILPRODU(PROCODIGO);

-- Índice 2: Busca por intervalo de cilindro (consultas frequentes)
CREATE INDEX IDX_FAIXACILPRODU_CILINDRO ON FAIXACILPRODU(PROCODIGO, FXCPROCILINI, FXCPROCILFIM);

-- Índice 3: Busca por processo (consultas frequentes)
CREATE INDEX IDX_FAIXACILPRODU_PROCESSO ON FAIXACILPRODU(FXCPROPROCESSO)
    WHERE FXCPROPROCESSO IS NOT NULL;
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

final class FirebirdFaixacilprodu extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'FAIXACILPRODU';
    
    protected $primaryKey = ['PROCODIGO', 'FXCPROSEQ'];
    public $incrementing = false;

    protected $casts = [
        'PROCODIGO' => 'string',
        'FXCPROSEQ' => 'integer',
        'FXCPROCILINI' => 'decimal:2',
        'FXCPROCILFIM' => 'decimal:2',
        'FXCPROVRPRODU' => 'decimal:2',
        'FXCPROTIPOQTD' => 'string',
        'FXCPROQTDFIXA' => 'decimal:2',
        'FXCPROPROCESSO' => 'string',
    ];

    // Relacionamento com PRODU
    public function produto(): BelongsTo
    {
        return $this->belongsTo(FirebirdProdu::class, 'PROCODIGO', 'PROCODIGO');
    }

    public function scopePorProduto($query, string $proCodigo)
    {
        return $query->where('PROCODIGO', $proCodigo);
    }

    public function scopePorCilindro($query, $cilindro)
    {
        return $query->where('FXCPROCILINI', '<=', $cilindro)
                    ->where('FXCPROCILFIM', '>=', $cilindro);
    }

    public function scopePorProcesso($query, string $processo)
    {
        return $query->where('FXCPROPROCESSO', $processo);
    }

    public function scopePorTipoQuantidade($query, string $tipo)
    {
        return $query->where('FXCPROTIPOQTD', $tipo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

