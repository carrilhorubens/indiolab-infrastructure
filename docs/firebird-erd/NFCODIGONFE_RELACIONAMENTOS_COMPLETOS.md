# NFCODIGONFE - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: NFCODIGONFE (Códigos de Notas Fiscais Eletrônicas)
- **Total de Registros**: 1.267.616
- **Total de Colunas**: 3
- **Chave Primária**: NFNUMERO, NFSERIE, EMPCODIGO (composta)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**NFCODIGONFE** é uma tabela que armazena códigos de notas fiscais eletrônicas. Com **1.267.616 registros**, representa códigos de NFes cadastrados no sistema, incluindo informações sobre número, série e empresa.

Esta tabela funciona como **controle de códigos de NFes** e permite:
- Registrar todos os códigos de NFes utilizados
- Armazenar informações sobre número, série e empresa
- Facilitar gestão de códigos de NFes
- Manter histórico detalhado de códigos
- Suportar controle de numeração de NFes

Cada registro representa um código específico de NFe, contendo:
- Número da nota fiscal (NFNUMERO)
- Série da nota fiscal (NFSERIE)
- Código da empresa (EMPCODIGO)

O sistema utiliza esta tabela para manter histórico completo de códigos de NFes, permitindo controle e rastreamento de códigos utilizados.

**Observação Importante:** NFCODIGONFE é uma tabela de controle de códigos de NFes. Com 1.267.616 registros, indica uso intenso desta funcionalidade. Possui chave primária composta (NFNUMERO, NFSERIE, EMPCODIGO) e não possui foreign keys diretas, mas pode ter relacionamentos lógicos com NOTAS através dos campos NFNUMERO, NFSERIE e EMPCODIGO. Esta tabela é similar a NFCODIGO, mas específica para NFes.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **NFNUMERO** 🔑 | VARCHAR(14) | ✓ | Número da nota fiscal (PK) |
| **NFSERIE** 🔑 | VARCHAR(14) | ✓ | Série da nota fiscal (PK) |
| **EMPCODIGO** 🔑 | INTEGER | ✓ | Código da empresa (PK) |

**Primary Key:** NFNUMERO, NFSERIE, EMPCODIGO (composta)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### NFCODIGONFE Referencia (0 FKs):

Nenhuma foreign key direta.

---

### NFCODIGONFE é Referenciada Por (0 tabelas):

Nenhuma tabela referencia NFCODIGONFE diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via NFNUMERO, NFSERIE, EMPCODIGO → NOTAS

**Fluxo:** NFCODIGONFE → NOTAS → Operações

**Descrição:** Através do número, série e empresa, é possível identificar notas fiscais relacionadas.

**Uso:** Análise de códigos através de notas fiscais.

---

### Via EMPCODIGO → EMPRESA

**Fluxo:** NFCODIGONFE → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de códigos através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Código de NFe

**Objetivo:** Obter informações de um código específico.

```sql
SELECT
    NFNUMERO,
    NFSERIE,
    EMPCODIGO
FROM NFCODIGONFE
WHERE NFNUMERO = ? AND NFSERIE = ? AND EMPCODIGO = ?;
```

---

### 2. Listar Códigos de uma Empresa

**Objetivo:** Obter todos os códigos de uma empresa específica.

```sql
SELECT
    NFNUMERO,
    NFSERIE
FROM NFCODIGONFE
WHERE EMPCODIGO = ?
ORDER BY NFSERIE, NFNUMERO;
```

---

### 3. Análise de Códigos por Série

**Objetivo:** Identificar distribuição de códigos por série.

**Query SQL:**
```sql
SELECT
    NFSERIE,
    COUNT(*) AS TOTAL_CODIGOS,
    MIN(NFNUMERO) AS MENOR_NUMERO,
    MAX(NFNUMERO) AS MAIOR_NUMERO
FROM NFCODIGONFE
WHERE NFSERIE IS NOT NULL
GROUP BY NFSERIE
ORDER BY TOTAL_CODIGOS DESC;
```

---

### 4. Buscar Próximo Número de NFe

**Objetivo:** Obter próximo número disponível para uma série e empresa.

```sql
SELECT
    MAX(NFNUMERO) + 1 AS PROXIMO_NUMERO
FROM NFCODIGONFE
WHERE NFSERIE = ? AND EMPCODIGO = ?;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com NFCODIGONFE | Tipo |
|--------|-----------|------------------------|------|
| **NFCODIGONFE** | 1.267.616 | 1:1 | **TABELA PRINCIPAL** |
| NOTAS | 1.206.013 | 1:1.05 | Notas fiscais (média de 1.05 códigos por nota) |

**Interpretação:**
- **1.267.616 códigos** registrados no sistema
- **Média de 1.05 códigos por nota** - indica que quase todas as notas possuem códigos registrados

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa e série (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_NFCODIGONFE_EMPRESA_SERIE ON NFCODIGONFE(EMPCODIGO, NFSERIE);

-- Índice 2: Busca por número (consultas frequentes)
CREATE INDEX IDX_NFCODIGONFE_NUMERO ON NFCODIGONFE(NFNUMERO)
    WHERE NFNUMERO IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdNfcodigonfe extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'NFCODIGONFE';
    
    protected $primaryKey = ['NFNUMERO', 'NFSERIE', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'NFNUMERO' => 'string',
        'NFSERIE' => 'string',
        'EMPCODIGO' => 'integer',
    ];

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopePorSerie($query, string $serie)
    {
        return $query->where('NFSERIE', $serie);
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

