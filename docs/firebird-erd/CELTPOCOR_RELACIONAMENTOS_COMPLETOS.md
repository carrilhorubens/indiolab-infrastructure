# CELTPOCOR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CELTPOCOR (Células x Tipos de Ocorrência)
- **Total de Registros**: 690
- **Total de Colunas**: 3
- **Chave Primária**: (ALXCODIGO, EMPCODIGO, TPOCCODIGO) - Composta
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela de relacionamento)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CELTPOCOR** é uma tabela de relacionamento que vincula células de produção (ALMOX) aos tipos de ocorrências (TPOCORRENCIA) que podem ocorrer em cada célula. Com **690 registros**, representa as configurações de quais tipos de ocorrências são permitidos ou rastreados em cada célula específica.

Esta tabela funciona como **matriz de permissões/configurações** e permite:
- Definir quais tipos de ocorrências podem ser registradas em cada célula
- Controlar o rastreamento de eventos específicos por célula
- Configurar regras de negócio por célula e tipo de ocorrência
- Integrar células com sistema de ocorrências de produção
- Permitir análises de ocorrências por célula

Cada registro representa uma configuração específica, contendo:
- Célula onde a ocorrência pode acontecer (ALXCODIGO + EMPCODIGO)
- Tipo de ocorrência permitido (TPOCCODIGO)

O sistema utiliza esta tabela para validar e controlar quais ocorrências podem ser registradas em cada célula de produção, garantindo que apenas eventos válidos sejam processados.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **ALXCODIGO** 🔑🔗 | INTEGER | Código da célula/almoxarifado (PK + FK → ALMOX) |
| **EMPCODIGO** 🔑🔗 | INTEGER | Código da empresa (PK + FK → ALMOX) |
| **TPOCCODIGO** 🔑🔗 | INTEGER | Código do tipo de ocorrência (PK + FK → TPOCORRENCIA) |

**Primary Key:** (ALXCODIGO, EMPCODIGO, TPOCCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CELTPOCOR Referencia (3 FKs):

#### 1. ALMOX - Células/Almoxarifados (2 FKs Compostas)
**Relacionamentos:**
```
CELTPOCOR.ALXCODIGO → ALMOX.ALXCODIGO (N:1)
CELTPOCOR.EMPCODIGO → ALMOX.EMPCODIGO (N:1)
Constraint: INTEG_1755
```

**Descrição**: Cada registro está vinculado a uma célula específica através de chave composta (célula + empresa).

**Informações da Tabela ALMOX:**
- **Total:** 128 células
- **PK:** (ALXCODIGO, EMPCODIGO)
- **Colunas:** 72 campos
- **FK Out:** 1 (DEPTO)
- **FK In:** 15 tabelas (incluindo CELTPOCOR)

**Campos importantes em ALMOX:**
- `ALXDESCRICAO` - Nome da célula
- `ALXTIPOCEL` - Tipo da célula (PRODUCAO, EMBALAGEM, etc)
- `TEMPOMAXIMO` - Tempo máximo permitido na célula
- `DPTCODIGO` - Departamento relacionado

**Uso:** Identificar a célula onde ocorrências podem ser registradas, validar configurações por célula.

---

#### 2. TPOCORRENCIA - Tipos de Ocorrência
**Relacionamento:**
```
CELTPOCOR.TPOCCODIGO → TPOCORRENCIA.TPOCCODIGO (N:1)
Constraint: INTEG_1753
```

**Descrição**: Cada registro está vinculado a um tipo específico de ocorrência.

**Informações da Tabela TPOCORRENCIA:**
- **Total:** 132 tipos de ocorrência
- **PK:** TPOCCODIGO
- **Colunas:** 4 campos
- **FK Out:** 1 (LOCALPED)
- **FK In:** 5 tabelas (incluindo CELTPOCOR)

**Campos importantes em TPOCORRENCIA:**
- `TPOCDESCRICAO` - Descrição do tipo de ocorrência
- `LPCODIGO` - Local de pedido relacionado (FK → LOCALPED)
- `TPOLCPRODUTIVIDADE` - Flag de produtividade

**Uso:** Identificar o tipo de ocorrência permitido na célula, validar tipos válidos por célula.

---

### CELTPOCOR é Referenciada Por

**Nenhuma tabela** referencia CELTPOCOR diretamente. Esta é uma tabela de configuração/relacionamento que não possui tabelas dependentes.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via ALMOX → DEPTO (Departamentos)

**Fluxo:** CELTPOCOR → ALMOX → DEPTO

**Descrição:** Através do relacionamento com ALMOX, é possível identificar o departamento de cada célula.

**Campos de junção:**
- `CELTPOCOR.ALXCODIGO + EMPCODIGO` → `ALMOX.ALXCODIGO + EMPCODIGO` → `ALMOX.DPTCODIGO` → `DEPTO.DPTCODIGO`

**Uso:** Análises de ocorrências por departamento, relatórios organizacionais.

---

### Via TPOCORRENCIA → LOCALPED (Locais de Pedido)

**Fluxo:** CELTPOCOR → TPOCORRENCIA → LOCALPED

**Descrição:** Através do relacionamento com TPOCORRENCIA, é possível identificar o local de pedido relacionado a cada tipo de ocorrência.

**Campos de junção:**
- `CELTPOCOR.TPOCCODIGO` → `TPOCORRENCIA.TPOCCODIGO` → `TPOCORRENCIA.LPCODIGO` → `LOCALPED.LPCODIGO`

**Uso:** Análises de ocorrências por tipo de evento, rastreamento de eventos de produção.

---

### Via ALMOX → Outras Tabelas de Produção

**Fluxo:** CELTPOCOR → ALMOX → [Múltiplas tabelas]

**Descrição:** Através do relacionamento com ALMOX, é possível acessar informações de produção relacionadas à célula.

**Tabelas relacionadas via ALMOX:**
- PEDROTEIRO - Roteiros de pedidos por célula
- JBXROTEIRO - Roteiros de JitBox por célula
- PDCROTEIRO - Roteiros de ordens de produção por célula
- LPEDALX - Eventos de pedidos por célula
- ACOPED - Apontamentos de produção por célula

**Uso:** Análises de ocorrências em contexto de produção, rastreamento de eventos por célula.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Configuração Célula x Ocorrência

**Objetivo:** Obter visão completa de uma configuração incluindo informações da célula, tipo de ocorrência e local de pedido.

**Fluxo:**
```
CELTPOCOR (ALXCODIGO, EMPCODIGO, TPOCCODIGO)
  ↓
ALMOX (ALXCODIGO, EMPCODIGO)
  ↓
DEPTO (DPTCODIGO)
  ↓
TPOCORRENCIA (TPOCCODIGO)
  ↓
LOCALPED (LPCODIGO)
```

**Query SQL:**
```sql
SELECT
    ct.ALXCODIGO,
    ct.EMPCODIGO,
    ct.TPOCCODIGO,
    a.ALXDESCRICAO AS CELULA,
    a.ALXTIPOCEL AS TIPO_CELULA,
    d.DPTNOME AS DEPARTAMENTO,
    tp.TPOCDESCRICAO AS TIPO_OCORRENCIA,
    lp.LPDESCRICAO AS LOCAL_PEDIDO,
    lp.LPINIPROCESSO AS EH_INICIO,
    lp.LPFIMPROCESSO AS EH_FIM,
    tp.TPOLCPRODUTIVIDADE AS PRODUTIVIDADE
FROM CELTPOCOR ct
LEFT JOIN ALMOX a ON a.ALXCODIGO = ct.ALXCODIGO 
    AND a.EMPCODIGO = ct.EMPCODIGO
LEFT JOIN DEPTO d ON d.DPTCODIGO = a.DPTCODIGO
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
WHERE ct.ALXCODIGO = ?
  AND ct.EMPCODIGO = ?
ORDER BY tp.TPOCDESCRICAO;
```

---

### Exemplo 2: Análise de Tipos de Ocorrência por Célula

**Objetivo:** Identificar quais tipos de ocorrências estão configurados para cada célula.

**Fluxo:**
```
ALMOX (ALXCODIGO, EMPCODIGO)
  ↓
CELTPOCOR (ALXCODIGO, EMPCODIGO, TPOCCODIGO)
  ↓
TPOCORRENCIA (TPOCCODIGO)
```

**Query SQL:**
```sql
SELECT
    a.ALXCODIGO,
    a.ALXDESCRICAO AS CELULA,
    a.ALXTIPOCEL AS TIPO_CELULA,
    COUNT(ct.TPOCCODIGO) AS TOTAL_TIPOS_OCORRENCIA,
    STRING_AGG(tp.TPOCDESCRICAO, ', ') AS TIPOS_OCORRENCIA
FROM ALMOX a
LEFT JOIN CELTPOCOR ct ON ct.ALXCODIGO = a.ALXCODIGO 
    AND ct.EMPCODIGO = a.EMPCODIGO
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
WHERE a.ALXTIPOCEL = 'PRODUCAO'
GROUP BY a.ALXCODIGO, a.ALXDESCRICAO, a.ALXTIPOCEL
ORDER BY a.ALXCODIGO;
```

---

### Exemplo 3: Análise de Células por Tipo de Ocorrência

**Objetivo:** Identificar em quais células um tipo específico de ocorrência pode ser registrado.

**Fluxo:**
```
TPOCORRENCIA (TPOCCODIGO)
  ↓
CELTPOCOR (TPOCCODIGO, ALXCODIGO, EMPCODIGO)
  ↓
ALMOX (ALXCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    tp.TPOCCODIGO,
    tp.TPOCDESCRICAO AS TIPO_OCORRENCIA,
    lp.LPDESCRICAO AS LOCAL_PEDIDO,
    COUNT(ct.ALXCODIGO) AS TOTAL_CELULAS,
    STRING_AGG(a.ALXDESCRICAO, ', ') AS CELULAS
FROM TPOCORRENCIA tp
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
LEFT JOIN CELTPOCOR ct ON ct.TPOCCODIGO = tp.TPOCCODIGO
LEFT JOIN ALMOX a ON a.ALXCODIGO = ct.ALXCODIGO 
    AND a.EMPCODIGO = ct.EMPCODIGO
WHERE tp.TPOCCODIGO = ?
GROUP BY tp.TPOCCODIGO, tp.TPOCDESCRICAO, lp.LPDESCRICAO;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Todas as Configurações de uma Célula

**Objetivo:** Visualizar todos os tipos de ocorrência configurados para uma célula específica.

```sql
SELECT
    ct.TPOCCODIGO,
    tp.TPOCDESCRICAO AS TIPO_OCORRENCIA,
    lp.LPDESCRICAO AS LOCAL_PEDIDO,
    lp.LPINIPROCESSO AS EH_INICIO,
    lp.LPFIMPROCESSO AS EH_FIM
FROM CELTPOCOR ct
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
WHERE ct.ALXCODIGO = ?
  AND ct.EMPCODIGO = ?
ORDER BY tp.TPOCDESCRICAO;
```

---

### 2. Buscar Configuração Específica

**Objetivo:** Verificar se um tipo de ocorrência está configurado para uma célula específica.

```sql
SELECT
    ct.*,
    a.ALXDESCRICAO AS CELULA,
    tp.TPOCDESCRICAO AS TIPO_OCORRENCIA,
    lp.LPDESCRICAO AS LOCAL_PEDIDO
FROM CELTPOCOR ct
LEFT JOIN ALMOX a ON a.ALXCODIGO = ct.ALXCODIGO 
    AND a.EMPCODIGO = ct.EMPCODIGO
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
WHERE ct.ALXCODIGO = ?
  AND ct.EMPCODIGO = ?
  AND ct.TPOCCODIGO = ?;
```

---

### 3. Análise de Cobertura de Ocorrências por Célula

**Objetivo:** Identificar células com muitos ou poucos tipos de ocorrência configurados.

```sql
SELECT
    a.ALXCODIGO,
    a.ALXDESCRICAO AS CELULA,
    a.ALXTIPOCEL AS TIPO_CELULA,
    COUNT(ct.TPOCCODIGO) AS TOTAL_TIPOS_CONFIGURADOS,
    (SELECT COUNT(*) FROM TPOCORRENCIA) AS TOTAL_TIPOS_DISPONIVEIS,
    ROUND(COUNT(ct.TPOCCODIGO) * 100.0 / NULLIF((SELECT COUNT(*) FROM TPOCORRENCIA), 0), 2) AS PERCENTUAL_COBERTURA
FROM ALMOX a
LEFT JOIN CELTPOCOR ct ON ct.ALXCODIGO = a.ALXCODIGO 
    AND ct.EMPCODIGO = a.EMPCODIGO
WHERE a.ALXTIPOCEL = 'PRODUCAO'
GROUP BY a.ALXCODIGO, a.ALXDESCRICAO, a.ALXTIPOCEL
ORDER BY TOTAL_TIPOS_CONFIGURADOS DESC;
```

---

### 4. Relatório de Tipos de Ocorrência por Departamento

**Objetivo:** Análise de ocorrências agrupadas por departamento.

```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    COUNT(DISTINCT ct.TPOCCODIGO) AS TOTAL_TIPOS_OCORRENCIA,
    COUNT(DISTINCT ct.ALXCODIGO) AS TOTAL_CELULAS,
    STRING_AGG(DISTINCT tp.TPOCDESCRICAO, ', ') AS TIPOS_OCORRENCIA
FROM DEPTO d
INNER JOIN ALMOX a ON a.DPTCODIGO = d.DPTCODIGO
INNER JOIN CELTPOCOR ct ON ct.ALXCODIGO = a.ALXCODIGO 
    AND ct.EMPCODIGO = a.EMPCODIGO
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
GROUP BY d.DPTCODIGO, d.DPTNOME
ORDER BY TOTAL_TIPOS_OCORRENCIA DESC;
```

---

### 5. Verificar Tipos de Ocorrência Não Configurados

**Objetivo:** Identificar tipos de ocorrência que não estão configurados para nenhuma célula.

```sql
SELECT
    tp.TPOCCODIGO,
    tp.TPOCDESCRICAO AS TIPO_OCORRENCIA,
    lp.LPDESCRICAO AS LOCAL_PEDIDO
FROM TPOCORRENCIA tp
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
WHERE NOT EXISTS (
    SELECT 1 FROM CELTPOCOR ct 
    WHERE ct.TPOCCODIGO = tp.TPOCCODIGO
)
ORDER BY tp.TPOCDESCRICAO;
```

---

### 6. Análise de Células Sem Configuração de Ocorrências

**Objetivo:** Identificar células de produção que não possuem tipos de ocorrência configurados.

```sql
SELECT
    a.ALXCODIGO,
    a.ALXDESCRICAO AS CELULA,
    a.ALXTIPOCEL AS TIPO_CELULA,
    d.DPTNOME AS DEPARTAMENTO
FROM ALMOX a
LEFT JOIN DEPTO d ON d.DPTCODIGO = a.DPTCODIGO
WHERE a.ALXTIPOCEL = 'PRODUCAO'
  AND NOT EXISTS (
      SELECT 1 FROM CELTPOCOR ct 
      WHERE ct.ALXCODIGO = a.ALXCODIGO 
        AND ct.EMPCODIGO = a.EMPCODIGO
  )
ORDER BY a.ALXCODIGO;
```

---

### 7. Análise de Ocorrências de Início e Fim por Célula

**Objetivo:** Identificar quais células têm ocorrências de início e fim de processo configuradas.

```sql
SELECT
    a.ALXCODIGO,
    a.ALXDESCRICAO AS CELULA,
    COUNT(CASE WHEN lp.LPINIPROCESSO = 'S' THEN 1 END) AS TOTAL_INICIO,
    COUNT(CASE WHEN lp.LPFIMPROCESSO = 'S' THEN 1 END) AS TOTAL_FIM,
    STRING_AGG(
        CASE WHEN lp.LPINIPROCESSO = 'S' THEN tp.TPOCDESCRICAO END, 
        ', '
    ) AS OCORRENCIAS_INICIO,
    STRING_AGG(
        CASE WHEN lp.LPFIMPROCESSO = 'S' THEN tp.TPOCDESCRICAO END, 
        ', '
    ) AS OCORRENCIAS_FIM
FROM ALMOX a
LEFT JOIN CELTPOCOR ct ON ct.ALXCODIGO = a.ALXCODIGO 
    AND ct.EMPCODIGO = a.EMPCODIGO
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
LEFT JOIN LOCALPED lp ON lp.LPCODIGO = tp.LPCODIGO
WHERE a.ALXTIPOCEL = 'PRODUCAO'
GROUP BY a.ALXCODIGO, a.ALXDESCRICAO
HAVING COUNT(ct.TPOCCODIGO) > 0
ORDER BY a.ALXCODIGO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CELTPOCOR | Tipo |
|--------|-----------|-------------------------|------|
| **CELTPOCOR** | 690 | 1:1 | **TABELA PRINCIPAL** |
| ALMOX | 128 | 5.4:1 | Células (média de 5.4 tipos por célula) |
| TPOCORRENCIA | 132 | 5.2:1 | Tipos (média de 5.2 células por tipo) |
| LOCALPED | 142 | 4.9:1 | Locais (relacionados via TPOCORRENCIA) |

**Interpretação:**
- Cada célula possui em média **5.4 tipos de ocorrência** configurados (cobertura média)
- Cada tipo de ocorrência está configurado em média **5.2 células** (distribuição equilibrada)
- Tabela de configuração com volume médio
- Relacionamento muitos-para-muitos bem distribuído

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **ALXCODIGO, EMPCODIGO, TPOCCODIGO** | CELTPOCOR | Chave primária composta (PK) |
| **ALXCODIGO, EMPCODIGO** | CELTPOCOR → ALMOX | Referência à célula |
| **TPOCCODIGO** | CELTPOCOR → TPOCORRENCIA | Referência ao tipo de ocorrência |
| **ALXDESCRICAO** | ALMOX | Nome da célula (exibição) |
| **TPOCDESCRICAO** | TPOCORRENCIA | Descrição do tipo (exibição) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CELTPOCOR.

### Recomendações de Performance

1. **Índice composto na chave primária** - Já existe implicitamente (PK)
2. **Índice composto célula** - Para buscas por célula
3. **Índice em TPOCCODIGO** - Para buscas por tipo de ocorrência
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CELTPOCOR

### Índices Sugeridos

```sql
-- Índice 1: Busca por célula (consultas frequentes)
CREATE INDEX IDX_CELTPOCOR_CELULA ON CELTPOCOR(ALXCODIGO, EMPCODIGO);

-- Índice 2: Busca por tipo de ocorrência
CREATE INDEX IDX_CELTPOCOR_TIPO ON CELTPOCOR(TPOCCODIGO);

-- Índice 3: Busca reversa (tipo → células)
CREATE INDEX IDX_CELTPOCOR_TIPO_CELULA ON CELTPOCOR(TPOCCODIGO, ALXCODIGO, EMPCODIGO);
```

### Observações sobre Volume

- **Tabela média** (690 registros) - Performance não é crítica
- **Consultas com JOINs** são rápidas devido ao volume reduzido
- **Focar em índices nas tabelas relacionadas** - ALMOX e TPOCORRENCIA têm volumes maiores
- **Cache pode ser útil** - Tabela pequena pode ser mantida em memória

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (tabela pequena, não precisa de otimização especial)
SELECT TPOCCODIGO
FROM CELTPOCOR
WHERE ALXCODIGO = ?
  AND EMPCODIGO = ?;

-- ✅ OTIMIZADO (JOIN com tabelas pequenas é rápido)
SELECT ct.TPOCCODIGO, tp.TPOCDESCRICAO
FROM CELTPOCOR ct
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
WHERE ct.ALXCODIGO = ?
  AND ct.EMPCODIGO = ?;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar configurações sem célula válida
SELECT ct.*
FROM CELTPOCOR ct
LEFT JOIN ALMOX a ON a.ALXCODIGO = ct.ALXCODIGO 
    AND a.EMPCODIGO = ct.EMPCODIGO
WHERE a.ALXCODIGO IS NULL;

-- Verificar configurações sem tipo de ocorrência válido
SELECT ct.*
FROM CELTPOCOR ct
LEFT JOIN TPOCORRENCIA tp ON tp.TPOCCODIGO = ct.TPOCCODIGO
WHERE tp.TPOCCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CELTPOCOR
WHERE ALXCODIGO IS NULL
   OR EMPCODIGO IS NULL
   OR TPOCCODIGO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT ALXCODIGO, EMPCODIGO, TPOCCODIGO, COUNT(*) AS QTD
FROM CELTPOCOR
GROUP BY ALXCODIGO, EMPCODIGO, TPOCCODIGO
HAVING COUNT(*) > 1;
```

### Verificar Padrões de Uso

```sql
-- Verificar células sem configuração
SELECT a.*
FROM ALMOX a
WHERE a.ALXTIPOCEL = 'PRODUCAO'
  AND NOT EXISTS (
      SELECT 1 FROM CELTPOCOR ct 
      WHERE ct.ALXCODIGO = a.ALXCODIGO 
        AND ct.EMPCODIGO = a.EMPCODIGO
  );

-- Verificar tipos de ocorrência não utilizados
SELECT tp.*
FROM TPOCORRENCIA tp
WHERE NOT EXISTS (
    SELECT 1 FROM CELTPOCOR ct 
    WHERE ct.TPOCCODIGO = tp.TPOCCODIGO
);

-- Verificar distribuição de configurações
SELECT 
    COUNT(*) AS TOTAL_CONFIGURACOES,
    COUNT(DISTINCT ALXCODIGO) AS TOTAL_CELULAS,
    COUNT(DISTINCT TPOCCODIGO) AS TOTAL_TIPOS,
    ROUND(COUNT(*) * 1.0 / NULLIF(COUNT(DISTINCT ALXCODIGO), 0), 2) AS MEDIA_TIPOS_POR_CELULA,
    ROUND(COUNT(*) * 1.0 / NULLIF(COUNT(DISTINCT TPOCCODIGO), 0), 2) AS MEDIA_CELULAS_POR_TIPO
FROM CELTPOCOR;
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

final class FirebirdCeltpocor extends Model
{
    protected $connection = 'firebird';
    protected $table = 'CELTPOCOR';
    
    protected $primaryKey = ['ALXCODIGO', 'EMPCODIGO', 'TPOCCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'ALXCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'TPOCCODIGO' => 'integer',
    ];

    // Relacionamento com ALMOX (chave composta)
    public function celula(): BelongsTo
    {
        return $this->belongsTo(FirebirdAlmox::class, ['ALXCODIGO', 'EMPCODIGO'], ['ALXCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com TPOCORRENCIA
    public function tipoOcorrencia(): BelongsTo
    {
        return $this->belongsTo(FirebirdTpocorrencia::class, 'TPOCCODIGO', 'TPOCCODIGO');
    }

    // Scope para filtrar por célula
    public function scopePorCelula($query, int $alxCodigo, int $empCodigo)
    {
        return $query->where('ALXCODIGO', $alxCodigo)
            ->where('EMPCODIGO', $empCodigo);
    }

    // Scope para filtrar por tipo de ocorrência
    public function scopePorTipoOcorrencia($query, int $tpocCodigo)
    {
        return $query->where('TPOCCODIGO', $tpocCodigo);
    }

    // Scope para células de produção
    public function scopeCelulasProducao($query)
    {
        return $query->join('ALMOX', function($join) {
            $join->on('ALMOX.ALXCODIGO', '=', 'CELTPOCOR.ALXCODIGO')
                 ->on('ALMOX.EMPCODIGO', '=', 'CELTPOCOR.EMPCODIGO')
                 ->where('ALMOX.ALXTIPOCEL', '=', 'PRODUCAO');
        });
    }

    // Método estático para verificar se tipo está configurado
    public static function tipoConfigurado(int $alxCodigo, int $empCodigo, int $tpocCodigo): bool
    {
        return self::where('ALXCODIGO', $alxCodigo)
            ->where('EMPCODIGO', $empCodigo)
            ->where('TPOCCODIGO', $tpocCodigo)
            ->exists();
    }

    // Método estático para obter tipos configurados para célula
    public static function tiposPorCelula(int $alxCodigo, int $empCodigo): array
    {
        return self::where('ALXCODIGO', $alxCodigo)
            ->where('EMPCODIGO', $empCodigo)
            ->pluck('TPOCCODIGO')
            ->toArray();
    }

    // Método estático para obter células configuradas para tipo
    public static function celulasPorTipo(int $tpocCodigo): array
    {
        return self::where('TPOCCODIGO', $tpocCodigo)
            ->get()
            ->map(function($item) {
                return [
                    'ALXCODIGO' => $item->ALXCODIGO,
                    'EMPCODIGO' => $item->EMPCODIGO,
                ];
            })
            ->toArray();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 3 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se célula e tipo existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Manter consistência** - Garantir que dados referenciados existem

### Performance

1. **Tabela pequena** - Não requer otimização especial
2. **Cache útil** - Pode ser mantida em memória
3. **Índices nas tabelas relacionadas** - Mais importante que índices em CELTPOCOR
4. **Evitar SELECT *** - Especificar apenas colunas necessárias

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se célula e tipo existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Auditoria** - Registrar alterações em configurações críticas

### Manutenção

1. **Revisão periódica** - Verificar células sem configuração
2. **Padronização** - Manter configurações consistentes por tipo de célula
3. **Documentação** - Documentar regras de negócio por célula
4. **Backup regular** - Tabela crítica para controle de produção

### Regras de Negócio

1. **Configuração obrigatória** - Células de produção devem ter ocorrências configuradas
2. **Validação em tempo real** - Verificar se tipo está configurado antes de registrar ocorrência
3. **Consistência** - Tipos de ocorrência devem ser válidos para a célula
4. **Integridade referencial** - Não excluir célula ou tipo com configurações vinculadas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

