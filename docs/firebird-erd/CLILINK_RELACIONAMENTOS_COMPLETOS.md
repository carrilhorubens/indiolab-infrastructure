# CLILINK - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLILINK (Links de Cliente)
- **Total de Registros**: 32
- **Total de Colunas**: 4
- **Chave Primária**: CLKCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLILINK** é uma tabela de armazenamento de links externos relacionados a clientes ou processos do sistema. Com **32 registros**, representa links para sites externos, rotinas ou processos específicos.

Esta tabela funciona como **armazenador de links externos** e permite:
- Armazenar links para sites externos relacionados a processos
- Associar rotinas a links específicos
- Armazenar valores-chave relacionados aos links
- Facilitar acesso a recursos externos
- Manter referências a processos externos

Cada registro representa um link externo específico, contendo:
- Código único do link (CLKCODIGO)
- Rotina ou processo associado (CLKROTINA)
- Valor-chave relacionado (CLKVLRCHAVE)
- Endereço do site (CLKENDSITE)

O sistema utiliza esta tabela para armazenar referências a links externos, permitindo acesso rápido a recursos relacionados a processos ou rotinas específicas.

**Observação Importante:** CLILINK não possui foreign keys formais, indicando que é uma tabela de referência independente. Com apenas 32 registros, indica uso específico para links externos relacionados a processos ou rotinas do sistema.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLKCODIGO** 🔑 | INTEGER | ✓ | Código único do link |

### Informações do Link
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLKROTINA** | VARCHAR(37) | | Rotina ou processo associado ao link |
| **CLKVLRCHAVE** | VARCHAR(37) | | Valor-chave relacionado ao link |
| **CLKENDSITE** | VARCHAR(37) | | Endereço do site externo |

**Primary Key:** CLKCODIGO

**Observações sobre Campos:**
- **CLKCODIGO**: Identificador único do link.
- **CLKROTINA**: Nome da rotina ou processo associado ao link.
- **CLKVLRCHAVE**: Valor-chave que pode ser usado para identificar ou filtrar o link.
- **CLKENDSITE**: URL ou endereço do site externo.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLILINK Referencia

**Nenhuma foreign key formal** está definida na tabela CLILINK.

**Relacionamentos Lógicos Possíveis:**
- **CLKROTINA** pode referenciar logicamente rotinas ou processos do sistema
- **CLKVLRCHAVE** pode conter códigos que referenciam outras entidades logicamente

---

### CLILINK é Referenciada Por

**Nenhuma tabela** referencia CLILINK diretamente. Esta é uma tabela folha utilizada para armazenamento e consulta.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLKROTINA → ROTINA (Rotinas do Sistema)

**Fluxo:** CLILINK → CLKROTINA (lógico) → ROTINA

**Descrição:** Através do nome da rotina, é possível identificar rotinas do sistema relacionadas.

**Uso:** Análises de links por rotina, identificação de rotinas com links externos.

---

### Via CLKVLRCHAVE → Entidades do Sistema

**Fluxo:** CLILINK → CLKVLRCHAVE (lógico) → Entidades

**Descrição:** Através do valor-chave, é possível identificar entidades relacionadas logicamente.

**Uso:** Análises de links por valor-chave, identificação de entidades com links externos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise de Links por Rotina

**Objetivo:** Obter todos os links associados a uma rotina específica.

**Query SQL:**
```sql
SELECT
    clk.CLKCODIGO,
    clk.CLKROTINA,
    clk.CLKVLRCHAVE,
    clk.CLKENDSITE
FROM CLILINK clk
WHERE clk.CLKROTINA = ?
ORDER BY clk.CLKCODIGO;
```

---

### Exemplo 2: Buscar Link por Valor-Chave

**Objetivo:** Identificar links através de valor-chave específico.

**Query SQL:**
```sql
SELECT
    clk.CLKCODIGO,
    clk.CLKROTINA,
    clk.CLKVLRCHAVE,
    clk.CLKENDSITE
FROM CLILINK clk
WHERE clk.CLKVLRCHAVE = ?
ORDER BY clk.CLKCODIGO;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Link por Código

**Objetivo:** Obter informações completas de um link específico.

```sql
SELECT
    CLKCODIGO,
    CLKROTINA,
    CLKVLRCHAVE,
    CLKENDSITE
FROM CLILINK
WHERE CLKCODIGO = ?;
```

---

### 2. Listar Todos os Links

**Objetivo:** Obter todos os links cadastrados no sistema.

```sql
SELECT
    CLKCODIGO,
    CLKROTINA,
    CLKVLRCHAVE,
    CLKENDSITE
FROM CLILINK
ORDER BY CLKROTINA, CLKCODIGO;
```

---

### 3. Análise de Links por Rotina

**Objetivo:** Identificar distribuição de links por rotina.

```sql
SELECT
    CLKROTINA,
    COUNT(*) AS TOTAL_LINKS,
    STRING_AGG(CLKENDSITE, ', ') AS SITES
FROM CLILINK
WHERE CLKROTINA IS NOT NULL
GROUP BY CLKROTINA
ORDER BY TOTAL_LINKS DESC;
```

---

### 4. Buscar Links com Endereço Válido

**Objetivo:** Identificar links com endereços de site configurados.

```sql
SELECT
    CLKCODIGO,
    CLKROTINA,
    CLKVLRCHAVE,
    CLKENDSITE
FROM CLILINK
WHERE CLKENDSITE IS NOT NULL
  AND CLKENDSITE != ''
ORDER BY CLKROTINA, CLKCODIGO;
```

---

### 5. Análise de Links por Valor-Chave

**Objetivo:** Identificar distribuição de links por valor-chave.

```sql
SELECT
    CLKVLRCHAVE,
    COUNT(*) AS TOTAL_LINKS,
    STRING_AGG(CLKENDSITE, ', ') AS SITES
FROM CLILINK
WHERE CLKVLRCHAVE IS NOT NULL
GROUP BY CLKVLRCHAVE
ORDER BY TOTAL_LINKS DESC;
```

---

### 6. Verificar Links Duplicados

**Objetivo:** Identificar links com endereços duplicados.

```sql
SELECT
    CLKENDSITE,
    COUNT(*) AS TOTAL_OCORRENCIAS,
    STRING_AGG(CAST(CLKCODIGO AS VARCHAR), ', ') AS CODIGOS
FROM CLILINK
WHERE CLKENDSITE IS NOT NULL
  AND CLKENDSITE != ''
GROUP BY CLKENDSITE
HAVING COUNT(*) > 1
ORDER BY TOTAL_OCORRENCIAS DESC;
```

---

### 7. Análise Completa de Links

**Objetivo:** Obter visão completa de todos os links com estatísticas.

```sql
SELECT
    COUNT(*) AS TOTAL_LINKS,
    COUNT(DISTINCT CLKROTINA) AS TOTAL_ROTINAS,
    COUNT(DISTINCT CLKVLRCHAVE) AS TOTAL_VALORES_CHAVE,
    COUNT(CASE WHEN CLKENDSITE IS NOT NULL AND CLKENDSITE != '' THEN 1 END) AS LINKS_COM_SITE,
    COUNT(CASE WHEN CLKROTINA IS NOT NULL THEN 1 END) AS LINKS_COM_ROTINA,
    COUNT(CASE WHEN CLKVLRCHAVE IS NOT NULL THEN 1 END) AS LINKS_COM_VALOR_CHAVE
FROM CLILINK;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CLILINK** | 32 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **Apenas 32 links** cadastrados no sistema
- **Uso muito específico** - indica links para processos ou rotinas específicas
- **Tabela pequena** - performance excelente

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLILINK.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice por rotina** - Para buscas por rotina
3. **Índice por valor-chave** - Para buscas por valor-chave
4. **Índice por endereço** - Para buscas por endereço

### Índices Sugeridos

```sql
-- Índice 1: Busca por rotina (consultas frequentes)
CREATE INDEX IDX_CLILINK_ROTINA ON CLILINK(CLKROTINA)
    WHERE CLKROTINA IS NOT NULL AND CLKROTINA != '';

-- Índice 2: Busca por valor-chave (consultas frequentes)
CREATE INDEX IDX_CLILINK_VALOR_CHAVE ON CLILINK(CLKVLRCHAVE)
    WHERE CLKVLRCHAVE IS NOT NULL AND CLKVLRCHAVE != '';

-- Índice 3: Busca por endereço (consultas frequentes)
CREATE INDEX IDX_CLILINK_ENDERECO ON CLILINK(CLKENDSITE)
    WHERE CLKENDSITE IS NOT NULL AND CLKENDSITE != '';
```

### Observações sobre Volume

- **Tabela muito pequena** (32 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por rotina, valor-chave e endereço

---

## 🔍 Validações e Integridade

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLILINK
WHERE CLKCODIGO IS NULL;

-- Verificar links sem informações úteis
SELECT *
FROM CLILINK
WHERE (CLKROTINA IS NULL OR CLKROTINA = '')
  AND (CLKVLRCHAVE IS NULL OR CLKVLRCHAVE = '')
  AND (CLKENDSITE IS NULL OR CLKENDSITE = '');

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CLKCODIGO, COUNT(*) AS QTD
FROM CLILINK
GROUP BY CLKCODIGO
HAVING COUNT(*) > 1;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdClilink extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLILINK';
    
    protected $primaryKey = 'CLKCODIGO';
    public $incrementing = true;

    protected $casts = [
        'CLKCODIGO' => 'integer',
        'CLKROTINA' => 'string',
        'CLKVLRCHAVE' => 'string',
        'CLKENDSITE' => 'string',
    ];

    // Scope para filtrar por rotina
    public function scopePorRotina($query, string $rotina)
    {
        return $query->where('CLKROTINA', $rotina);
    }

    // Scope para filtrar por valor-chave
    public function scopePorValorChave($query, string $valorChave)
    {
        return $query->where('CLKVLRCHAVE', $valorChave);
    }

    // Scope para filtrar links com endereço válido
    public function scopeComEndereco($query)
    {
        return $query->whereNotNull('CLKENDSITE')
            ->where('CLKENDSITE', '!=', '');
    }

    // Método para verificar se tem endereço válido
    public function temEndereco(): bool
    {
        return !empty($this->CLKENDSITE);
    }

    // Método estático para buscar link por rotina
    public static function buscarPorRotina(string $rotina): \Illuminate\Support\Collection
    {
        return self::where('CLKROTINA', $rotina)->get();
    }

    // Método estático para buscar link por valor-chave
    public static function buscarPorValorChave(string $valorChave): \Illuminate\Support\Collection
    {
        return self::where('CLKVLRCHAVE', $valorChave)->get();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária simples** - CLKCODIGO identifica unicamente cada link
2. **Validação de endereços** - Verificar formato de URLs antes de inserir
3. **Padronização de rotinas** - Manter nomes de rotinas consistentes
4. **Validação de valores-chave** - Verificar formato e significado

### Performance

1. **Tabela muito pequena** - 32 registros, performance excelente
2. **Índices úteis** - Em CLKROTINA, CLKVLRCHAVE e CLKENDSITE para buscas frequentes
3. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação de endereços** - Verificar formato de URLs
2. **Verificar duplicatas** - PK previne duplicatas
3. **Manter consistência** - Garantir que rotinas e valores-chave sejam consistentes

### Manutenção

1. **Revisão periódica** - Verificar links quebrados ou não utilizados
2. **Padronização** - Manter estrutura de rotinas e valores-chave consistente
3. **Documentação** - Documentar significado de cada rotina e valor-chave
4. **Backup regular** - Tabela importante para referências externas

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

