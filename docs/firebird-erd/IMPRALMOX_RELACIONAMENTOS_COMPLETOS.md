# IMPRALMOX - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPRALMOX (Impressora x Almoxarifado)
- **Total de Registros**: 66
- **Total de Colunas**: 3
- **Chave Primária**: Composta (ALXCODIGO, EMPCODIGO, IMPCODIGO)
- **Chaves Estrangeiras**: 3
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPRALMOX** é uma tabela de relacionamento que vincula impressoras a almoxarifados (células de produção). Com **66 registros**, representa configurações de impressão específicas por almoxarifado, permitindo que cada célula tenha impressoras configuradas para impressão de etiquetas e documentos.

Esta tabela funciona como **tabela de relacionamento N:N** e permite:
- Vincular impressoras a almoxarifados específicos
- Configurar impressoras por empresa e almoxarifado
- Facilitar gestão de impressão por célula de produção
- Suportar múltiplas impressoras por almoxarifado
- Facilitar controle de impressão em produção

Cada registro representa uma vinculação específica entre uma impressora e um almoxarifado, contendo:
- Código do almoxarifado (ALXCODIGO) - FK → ALMOX
- Código da empresa (EMPCODIGO) - FK → ALMOX
- Código da impressora (IMPCODIGO) - FK → IMPRESSORAS

O sistema utiliza esta tabela para configurar quais impressoras estão disponíveis em cada almoxarifado, permitindo controle de impressão por célula de produção.

**Observação Importante:** IMPRALMOX é uma tabela de relacionamento com chave primária composta. Com 66 registros, indica uso moderado desta funcionalidade. Possui relacionamentos com ALMOX (chave composta) e IMPRESSORAS.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ALXCODIGO** 🔑 🔗 | INTEGER | ✓ | Código do almoxarifado (PK + FK → ALMOX) |
| **EMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da empresa (PK + FK → ALMOX) |
| **IMPCODIGO** 🔑 🔗 | INTEGER | ✓ | Código da impressora (PK + FK → IMPRESSORAS) |

**Primary Key:** (ALXCODIGO, EMPCODIGO, IMPCODIGO)

**Foreign Keys:**
- `(ALXCODIGO, EMPCODIGO)` → `ALMOX.(ALXCODIGO, EMPCODIGO)` (Constraint: ALMOX_IMPRALMOX)
- `IMPCODIGO` → `IMPRESSORAS.IMPCODIGO` (Constraint: IMPRESSORAS_IMPRALMOX)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPRALMOX Referencia (3 FKs):

#### 1. ALMOX - Almoxarifados
**Relacionamento:**
```
IMPRALMOX.(ALXCODIGO, EMPCODIGO) → ALMOX.(ALXCODIGO, EMPCODIGO) (N:1)
Constraint: ALMOX_IMPRALMOX
```

**Descrição**: Cada vinculação está relacionada a um almoxarifado específico de uma empresa.

**Informações da Tabela ALMOX:**
- **Total:** 128 almoxarifados
- **PK:** (ALXCODIGO, EMPCODIGO)
- **Colunas:** 72 campos

**Uso:** Identificar o almoxarifado ao qual a impressora está vinculada.

---

#### 2. IMPRESSORAS - Impressoras
**Relacionamento:**
```
IMPRALMOX.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRALMOX
```

**Descrição**: Cada vinculação está relacionada a uma impressora específica.

**Informações da Tabela IMPRESSORAS:**
- **Total:** 9 impressoras
- **PK:** IMPCODIGO
- **Colunas:** 11 campos

**Uso:** Identificar a impressora vinculada ao almoxarifado.

---

### IMPRALMOX é Referenciada Por (0 tabelas):

Nenhuma tabela referencia IMPRALMOX diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Impressoras de um Almoxarifado

**Objetivo:** Obter todas as impressoras vinculadas a um almoxarifado específico.

```sql
SELECT
    imp.IMPCODIGO,
    imp.IMPDESCRICAO,
    imp.IMPIMPRESSORA,
    imp.IMPTERMINAL
FROM IMPRALMOX ial
INNER JOIN IMPRESSORAS imp ON imp.IMPCODIGO = ial.IMPCODIGO
WHERE ial.ALXCODIGO = ?
  AND ial.EMPCODIGO = ?;
```

---

### 2. Listar Almoxarifados de uma Impressora

**Objetivo:** Obter todos os almoxarifados vinculados a uma impressora específica.

```sql
SELECT
    a.ALXCODIGO,
    a.EMPCODIGO,
    a.ALXDESCRICAO
FROM IMPRALMOX ial
INNER JOIN ALMOX a ON a.ALXCODIGO = ial.ALXCODIGO 
                  AND a.EMPCODIGO = ial.EMPCODIGO
WHERE ial.IMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPRALMOX | Tipo |
|--------|-----------|------------------------|------|
| **IMPRALMOX** | 66 | 1:1 | **TABELA PRINCIPAL** |
| ALMOX | 128 | 1:0.52 | Almoxarifados (média de 0.52 impressoras por almoxarifado) |
| IMPRESSORAS | 9 | 1:7.33 | Impressoras (média de 7.33 almoxarifados por impressora) |

**Interpretação:**
- **66 vinculações** entre impressoras e almoxarifados
- **Média de 0.52 impressoras por almoxarifado** - indica que nem todos os almoxarifados possuem impressoras configuradas
- **Média de 7.33 almoxarifados por impressora** - indica que algumas impressoras são compartilhadas entre múltiplos almoxarifados

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por almoxarifado (consultas frequentes)
CREATE INDEX IDX_IMPRALMOX_ALMOX ON IMPRALMOX(ALXCODIGO, EMPCODIGO);

-- Índice 2: Busca por impressora (consultas frequentes)
CREATE INDEX IDX_IMPRALMOX_IMPRESSORA ON IMPRALMOX(IMPCODIGO);
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

final class FirebirdImpralmox extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPRALMOX';
    
    protected $primaryKey = ['ALXCODIGO', 'EMPCODIGO', 'IMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'ALXCODIGO' => 'integer',
        'EMPCODIGO' => 'integer',
        'IMPCODIGO' => 'integer',
    ];

    // Relacionamento com ALMOX
    public function almoxarifado(): BelongsTo
    {
        return $this->belongsTo(FirebirdAlmox::class, ['ALXCODIGO', 'EMPCODIGO'], ['ALXCODIGO', 'EMPCODIGO']);
    }

    // Relacionamento com IMPRESSORAS
    public function impressora(): BelongsTo
    {
        return $this->belongsTo(FirebirdImpressoras::class, 'IMPCODIGO', 'IMPCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

