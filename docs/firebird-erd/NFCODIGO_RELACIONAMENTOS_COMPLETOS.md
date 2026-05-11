# NFCODIGO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: NFCODIGO (Códigos de Notas Fiscais)
- **Total de Registros**: 1.270.596
- **Total de Colunas**: 4
- **Chave Primária**: NFNUMERO, NFSERIE, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 0
- **Índices**: 1
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**NFCODIGO** é uma tabela que armazena códigos de notas fiscais. Com **1.270.596 registros**, representa códigos de notas fiscais cadastrados no sistema, incluindo informações sobre número, série, empresa e operação.

Esta tabela funciona como **controle de códigos de notas fiscais** e permite:
- Registrar todos os códigos de notas fiscais utilizados
- Armazenar informações sobre número, série e empresa
- Controlar operação realizada com o código
- Facilitar gestão de códigos de notas fiscais
- Manter histórico detalhado de códigos

Cada registro representa um código específico de nota fiscal, contendo:
- Número da nota fiscal (NFNUMERO)
- Série da nota fiscal (NFSERIE)
- Código da empresa (EMPCODIGO)
- Operação realizada (NFOPERACAO)

O sistema utiliza esta tabela para manter histórico completo de códigos de notas fiscais, permitindo controle e rastreamento de códigos utilizados.

**Observação Importante:** NFCODIGO é uma tabela de controle de códigos de notas fiscais. Com 1.270.596 registros, indica uso intenso desta funcionalidade. Possui chave primária composta (NFNUMERO, NFSERIE, EMPCODIGO) e não possui foreign keys diretas, mas pode ter relacionamentos lógicos com NOTAS através dos campos NFNUMERO, NFSERIE e EMPCODIGO. Possui 1 índice para otimização de consultas.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFNUMERO** 🔑 | VARCHAR(14) | ✓ | Número da nota fiscal (PK) |
| **NFSERIE** 🔑 | VARCHAR(14) | ✓ | Série da nota fiscal (PK) |
| **EMPCODIGO** 🔑 | INTEGER | ✓ | Código da empresa (PK) |

### Informações da Operação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFOPERACAO** | VARCHAR(14) | ✓ | Operação realizada com o código |

**Primary Key:** NFNUMERO, NFSERIE, EMPCODIGO (composta)

**Índices:**
- `IND_NFCODIGO_MAX` em `EMPCODIGO, NFSERIE, NFNUMERO` (não único)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### NFCODIGO Referencia (0 FKs):

Nenhuma foreign key direta.

---

### NFCODIGO é Referenciada Por (0 tabelas):

Nenhuma tabela referencia NFCODIGO diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via NFNUMERO, NFSERIE, EMPCODIGO → NOTAS

**Fluxo:** NFCODIGO → NOTAS → Operações

**Descrição:** Através do número, série e empresa, é possível identificar notas fiscais relacionadas.

**Uso:** Análise de códigos através de notas fiscais.

---

### Via EMPCODIGO → EMPRESA

**Fluxo:** NFCODIGO → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de códigos através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Código de Nota Fiscal

**Objetivo:** Obter informações de um código específico.

```sql
SELECT
    NFNUMERO,
    NFSERIE,
    EMPCODIGO,
    NFOPERACAO
FROM NFCODIGO
WHERE NFNUMERO = ? AND NFSERIE = ? AND EMPCODIGO = ?;
```

---

### 2. Listar Códigos de uma Empresa

**Objetivo:** Obter todos os códigos de uma empresa específica.

```sql
SELECT
    NFNUMERO,
    NFSERIE,
    NFOPERACAO
FROM NFCODIGO
WHERE EMPCODIGO = ?
ORDER BY NFSERIE, NFNUMERO;
```

---

### 3. Análise de Códigos por Operação

**Objetivo:** Identificar distribuição de códigos por operação.

**Query SQL:**
```sql
SELECT
    NFOPERACAO,
    COUNT(*) AS TOTAL_CODIGOS,
    COUNT(DISTINCT EMPCODIGO) AS TOTAL_EMPRESAS_AFETADAS
FROM NFCODIGO
WHERE NFOPERACAO IS NOT NULL
GROUP BY NFOPERACAO
ORDER BY TOTAL_CODIGOS DESC;
```

---

### 4. Buscar Próximo Número de Nota Fiscal

**Objetivo:** Obter próximo número disponível para uma série e empresa.

```sql
SELECT
    MAX(NFNUMERO) + 1 AS PROXIMO_NUMERO
FROM NFCODIGO
WHERE NFSERIE = ? AND EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com NFCODIGO | Tipo |
|--------|-----------|---------------------|------|
| **NFCODIGO** | 1.270.596 | 1:1 | **TABELA PRINCIPAL** |
| NOTAS | 1.206.013 | 1:1.05 | Notas fiscais (média de 1.05 códigos por nota) |

**Interpretação:**
- **1.270.596 códigos** registrados no sistema
- **Média de 1.05 códigos por nota** - indica que quase todas as notas possuem códigos registrados

---

## 🚀 Performance e Otimização

### Índices Existentes

```sql
-- Índice existente: Busca por empresa, série e número (consultas frequentes)
-- IND_NFCODIGO_MAX em EMPCODIGO, NFSERIE, NFNUMERO (não único)
```

### Índices Sugeridos Adicionais

```sql
-- Índice 1: Busca por operação (consultas frequentes)
CREATE INDEX IDX_NFCODIGO_OPERACAO ON NFCODIGO(NFOPERACAO)
    WHERE NFOPERACAO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdNfcodigo extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'NFCODIGO';
    
    protected $primaryKey = ['NFNUMERO', 'NFSERIE', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'NFNUMERO' => 'string',
        'NFSERIE' => 'string',
        'EMPCODIGO' => 'integer',
        'NFOPERACAO' => 'string',
    ];

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorSerie($query, string $serie)
    {
        return $query->where('NFSERIE', $serie);
    }

    public function scopePorOperacao($query, string $operacao)
    {
        return $query->where('NFOPERACAO', $operacao);
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('NFSERIE')->orderBy('NFNUMERO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

