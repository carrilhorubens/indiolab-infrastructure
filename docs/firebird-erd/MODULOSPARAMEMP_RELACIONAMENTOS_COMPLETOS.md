# MODULOSPARAMEMP - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: MODULOSPARAMEMP (Parâmetros de Módulos por Empresa)
- **Total de Registros**: 30
- **Total de Colunas**: 6
- **Chave Primária**: ID (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**MODULOSPARAMEMP** é uma tabela que armazena parâmetros de configuração de módulos por empresa. Com **30 registros**, representa parâmetros cadastrados para empresas específicas, incluindo informações sobre nome, valor, descrição e proposta.

Esta tabela funciona como **configuração de parâmetros de módulos por empresa** e permite:
- Registrar parâmetros de configuração de módulos por empresa
- Armazenar informações sobre nome, valor e descrição
- Vincular parâmetros a empresas específicas
- Suportar propostas de configuração
- Facilitar gestão de parâmetros de módulos por empresa
- Manter histórico detalhado de parâmetros

Cada registro representa um parâmetro específico de módulo para uma empresa, contendo:
- ID do parâmetro (ID)
- Código da empresa (EMPCODIGO)
- Nome do parâmetro (NOME)
- Valor do parâmetro (VALOR)
- Descrição do parâmetro (DESCRICAO)
- Proposta do parâmetro (PROPOSTA)

O sistema utiliza esta tabela para manter histórico completo de parâmetros de módulos por empresa, permitindo configurações específicas por empresa.

**Observação Importante:** MODULOSPARAMEMP é uma tabela de configuração de parâmetros de módulos por empresa. Com 30 registros, indica uso moderado desta funcionalidade. Não possui foreign keys diretas, mas pode ter relacionamentos lógicos com EMPRESA através do campo EMPCODIGO.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **ID** 🔑 | INTEGER | ✓ | ID do parâmetro (PK) |

### Informações do Parâmetro
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **EMPCODIGO** | INTEGER | ✓ | Código da empresa |
| **NOME** | VARCHAR(37) | ✓ | Nome do parâmetro |
| **VALOR** | VARCHAR(37) | | Valor do parâmetro |
| **DESCRICAO** | VARCHAR(37) | | Descrição do parâmetro |
| **PROPOSTA** | VARCHAR(37) | | Proposta do parâmetro |

**Primary Key:** ID

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### MODULOSPARAMEMP Referencia (0 FKs):

Nenhuma foreign key direta.

---

### MODULOSPARAMEMP é Referenciada Por (0 tabelas):

Nenhuma tabela referencia MODULOSPARAMEMP diretamente.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos - Lógicos)

### Via EMPCODIGO → EMPRESA

**Fluxo:** MODULOSPARAMEMP → EMPRESA → Operações

**Descrição:** Através do código da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de parâmetros através de operações de empresas.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Parâmetro de Módulo por Empresa

**Objetivo:** Obter informações de um parâmetro específico.

```sql
SELECT
    ID,
    EMPCODIGO,
    NOME,
    VALOR,
    DESCRICAO,
    PROPOSTA
FROM MODULOSPARAMEMP
WHERE ID = ?;
```

---

### 2. Listar Parâmetros de uma Empresa

**Objetivo:** Obter todos os parâmetros de uma empresa específica.

```sql
SELECT
    ID,
    NOME,
    VALOR,
    DESCRICAO,
    PROPOSTA
FROM MODULOSPARAMEMP
WHERE EMPCODIGO = ?
ORDER BY NOME;
```

---

### 3. Análise de Parâmetros por Empresa

**Objetivo:** Identificar distribuição de parâmetros por empresa.

**Query SQL:**
```sql
SELECT
    EMPCODIGO,
    COUNT(*) AS TOTAL_PARAMETROS,
    COUNT(VALOR) AS TOTAL_COM_VALOR,
    COUNT(PROPOSTA) AS TOTAL_COM_PROPOSTA
FROM MODULOSPARAMEMP
GROUP BY EMPCODIGO
ORDER BY TOTAL_PARAMETROS DESC;
```

---

### 4. Buscar Parâmetros com Proposta

**Objetivo:** Obter parâmetros que possuem proposta.

```sql
SELECT
    ID,
    EMPCODIGO,
    NOME,
    VALOR,
    PROPOSTA
FROM MODULOSPARAMEMP
WHERE PROPOSTA IS NOT NULL AND PROPOSTA != ''
ORDER BY EMPCODIGO, NOME;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com MODULOSPARAMEMP | Tipo |
|--------|-----------|----------------------------|------|
| **MODULOSPARAMEMP** | 30 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **30 parâmetros** registrados no sistema
- Indica uso moderado desta funcionalidade

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por empresa (consultas frequentes - CRÍTICO)
CREATE INDEX IDX_MODULOSPARAMEMP_EMPRESA ON MODULOSPARAMEMP(EMPCODIGO);

-- Índice 2: Busca por nome (consultas frequentes)
CREATE INDEX IDX_MODULOSPARAMEMP_NOME ON MODULOSPARAMEMP(NOME)
    WHERE NOME IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdModulosparamemp extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'MODULOSPARAMEMP';
    
    protected $primaryKey = 'ID';
    public $incrementing = true;

    protected $casts = [
        'ID' => 'integer',
        'EMPCODIGO' => 'integer',
        'NOME' => 'string',
        'VALOR' => 'string',
        'DESCRICAO' => 'string',
        'PROPOSTA' => 'string',
    ];

    public function scopePorEmpresa($query, int $empCodigo)
    {
        return $query->where('EMPCODIGO', $empCodigo);
    }

    public function scopeComProposta($query)
    {
        return $query->whereNotNull('PROPOSTA')
                     ->where('PROPOSTA', '!=', '');
    }

    public function scopeOrdenado($query)
    {
        return $query->orderBy('EMPCODIGO')->orderBy('NOME');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

