# CARGO - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CARGO
- **Total de Registros**: 10
- **Total de Colunas**: 4
- **Chave Primária**: CARCODIGO
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 2 (FUNCIO, PARTVENDEDOR)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CARGO** é uma tabela mestre que armazena informações sobre cargos/funções dentro da organização. Com apenas **10 registros**, representa os diferentes cargos disponíveis no sistema.

Esta tabela funciona como **catálogo de cargos** e permite:
- Definir cargos organizacionais padronizados
- Classificar funcionários por cargo
- Controlar permissões e responsabilidades por cargo
- Identificar cargos com características especiais (instrutor, internet)
- Relacionar cargos com vendedores em participações

Cada registro representa um cargo específico, contendo:
- Código único do cargo (CARCODIGO)
- Nome/descrição do cargo (CARNOME)
- Flag indicando se é cargo de instrutor (CARINSTRUTOR)
- Flag indicando se é cargo relacionado a internet (CARINTERNET)

O sistema utiliza esta tabela para organizar a estrutura hierárquica e funcional da empresa, permitindo análises por cargo e controle de acesso baseado em funções.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CARCODIGO** 🔑 | INTEGER | Código único do cargo (PK) |

### Dados do Cargo
| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **CARNOME** | VARCHAR(37) | Nome/descrição do cargo (obrigatório) |
| **CARINSTRUTOR** | VARCHAR(14) | Flag indicando se é cargo de instrutor (opcional) |
| **CARINTERNET** | VARCHAR(14) | Flag indicando se é cargo relacionado a internet (opcional) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CARGO é Referenciada Por (2 Tabelas):

#### 1. FUNCIO - Funcionários
**Relacionamento (FK no Schema):**
```
FUNCIO.CARCODIGO → CARGO.CARCODIGO (N:1)
Constraint: CARGO_FUNCIO
```

**Descrição**: Múltiplos funcionários podem ter o mesmo cargo. Cada funcionário possui um cargo atribuído através do campo CARCODIGO.

**Informações da Tabela FUNCIO:**
- **Total:** 435 funcionários
- **PK:** FUNCODIGO
- **Colunas:** 74 campos
- **FK Out:** 6 tabelas (incluindo CARGO)
- **FK In:** 23 tabelas

**Campos de junção:**
- `FUNCIO.CARCODIGO` → `CARGO.CARCODIGO`

**Uso:** Identificar funcionários por cargo, análises de distribuição de cargos, relatórios organizacionais.

---

#### 2. PARTVENDEDOR - Participações de Vendedores
**Relacionamento (FK no Schema):**
```
PARTVENDEDOR.CARCODIGO → CARGO.CARCODIGO (N:1)
Constraint: CARGO_PARTVENDEDOR
```

**Descrição**: Participações de vendedores podem estar vinculadas a cargos específicos, permitindo controle de comissões por cargo.

**Informações da Tabela PARTVENDEDOR:**
- **Total:** 802 registros
- **PK:** USRID
- **Colunas:** 3 campos
- **FK Out:** 3 tabelas (CARGO, CLIEN, PART)
- **FK In:** 0 tabelas

**Campos de junção:**
- `PARTVENDEDOR.CARCODIGO` → `CARGO.CARCODIGO`

**Uso:** Controlar participações de vendedores por cargo, análises de comissões por cargo.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos via FUNCIO)

### Via FUNCIO → USUARIO

**Fluxo:** CARGO → FUNCIO → USUARIO

**Descrição:** Através do relacionamento com FUNCIO, é possível identificar usuários do sistema por cargo.

**Campos de junção:**
- `CARGO.CARCODIGO` → `FUNCIO.CARCODIGO` → `FUNCIO.FUNCODIGO` → `USUARIO.FUNCODIGO`

**Uso:** Análises de acesso ao sistema por cargo, controle de permissões por cargo.

---

### Via FUNCIO → ALMOX (Células/Almoxarifados)

**Fluxo:** CARGO → FUNCIO → ALMOX

**Descrição:** Através do relacionamento com FUNCIO, é possível identificar células/almoxarifados onde funcionários de determinado cargo trabalham.

**Campos de junção:**
- `CARGO.CARCODIGO` → `FUNCIO.CARCODIGO` → `FUNCIO.ALXCODIGO + FUNCIO.ALXEMPCODIGO` → `ALMOX.ALXCODIGO + ALMOX.EMPCODIGO`

**Uso:** Análises de distribuição de cargos por célula de produção, planejamento de recursos humanos por área.

---

### Via FUNCIO → DEPTO (Departamentos)

**Fluxo:** CARGO → FUNCIO → DEPTO

**Descrição:** Através do relacionamento com FUNCIO, é possível identificar departamentos onde funcionários de determinado cargo estão alocados.

**Campos de junção:**
- `CARGO.CARCODIGO` → `FUNCIO.CARCODIGO` → `FUNCIO.DPTCODIGO` → `DEPTO.DPTCODIGO`

**Uso:** Análises organizacionais por departamento e cargo, relatórios de estrutura organizacional.

---

### Via FUNCIO → CIDADE

**Fluxo:** CARGO → FUNCIO → CIDADE

**Descrição:** Através do relacionamento com FUNCIO, é possível identificar a localização geográfica dos funcionários por cargo.

**Campos de junção:**
- `CARGO.CARCODIGO` → `FUNCIO.CARCODIGO` → `FUNCIO.CIDCODIGO` → `CIDADE.CIDCODIGO`

**Uso:** Análises geográficas de distribuição de cargos, planejamento de expansão.

---

### Via PARTVENDEDOR → CLIEN (Clientes)

**Fluxo:** CARGO → PARTVENDEDOR → CLIEN

**Descrição:** Através do relacionamento com PARTVENDEDOR, é possível identificar clientes relacionados a cargos específicos.

**Campos de junção:**
- `CARGO.CARCODIGO` → `PARTVENDEDOR.CARCODIGO` → `PARTVENDEDOR.CLICODIGO` → `CLIEN.CLICODIGO`

**Uso:** Análises de relacionamento cliente-cargo, controle de participações por cargo.

---

### Via PARTVENDEDOR → PART (Participações)

**Fluxo:** CARGO → PARTVENDEDOR → PART

**Descrição:** Através do relacionamento com PARTVENDEDOR, é possível identificar participações relacionadas a cargos específicos.

**Campos de junção:**
- `CARGO.CARCODIGO` → `PARTVENDEDOR.CARCODIGO` → `PARTVENDEDOR.USRID` → `PART.USRID`

**Uso:** Análises de participações por cargo, controle de comissões.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Cargo

**Objetivo:** Obter visão completa de um cargo incluindo funcionários, usuários, departamentos e células.

**Fluxo:**
```
CARGO (CARCODIGO, CARNOME)
  ↓
FUNCIO (CARCODIGO)
  ↓
USUARIO (FUNCODIGO)
  ↓
DEPTO (DPTCODIGO)
  ↓
ALMOX (ALXCODIGO, EMPCODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    c.CARINSTRUTOR AS EH_INSTRUTOR,
    c.CARINTERNET AS EH_INTERNET,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT u.USUCODIGO) AS TOTAL_USUARIOS,
    COUNT(DISTINCT f.DPTCODIGO) AS TOTAL_DEPARTAMENTOS,
    COUNT(DISTINCT f.ALXCODIGO) AS TOTAL_CELULAS,
    STRING_AGG(DISTINCT d.DPTNOME, ', ') AS DEPARTAMENTOS,
    STRING_AGG(DISTINCT a.ALXDESCRICAO, ', ') AS CELULAS
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
LEFT JOIN USUARIO u ON u.FUNCODIGO = f.FUNCODIGO
LEFT JOIN DEPTO d ON d.DPTCODIGO = f.DPTCODIGO
LEFT JOIN ALMOX a ON a.ALXCODIGO = f.ALXCODIGO AND a.EMPCODIGO = f.ALXEMPCODIGO
WHERE c.CARCODIGO = ?
GROUP BY c.CARCODIGO, c.CARNOME, c.CARINSTRUTOR, c.CARINTERNET;
```

---

### Exemplo 2: Análise de Funcionários por Cargo

**Objetivo:** Listar todos os funcionários de um cargo específico com informações completas.

**Fluxo:**
```
CARGO (CARCODIGO)
  ↓
FUNCIO (CARCODIGO)
  ↓
DEPTO (DPTCODIGO)
  ↓
CIDADE (CIDCODIGO)
```

**Query SQL:**
```sql
SELECT
    c.CARNOME AS CARGO,
    f.FUNCODIGO,
    f.FUNNOME AS FUNCIONARIO,
    f.FUNATIVO AS ATIVO,
    d.DPTNOME AS DEPARTAMENTO,
    ci.CIDNOME AS CIDADE,
    ci.CIDUF AS UF,
    a.ALXDESCRICAO AS CELULA,
    COUNT(DISTINCT u.USUCODIGO) AS TOTAL_USUARIOS
FROM CARGO c
INNER JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
LEFT JOIN DEPTO d ON d.DPTCODIGO = f.DPTCODIGO
LEFT JOIN CIDADE ci ON ci.CIDCODIGO = f.CIDCODIGO
LEFT JOIN ALMOX a ON a.ALXCODIGO = f.ALXCODIGO AND a.EMPCODIGO = f.ALXEMPCODIGO
LEFT JOIN USUARIO u ON u.FUNCODIGO = f.FUNCODIGO
WHERE c.CARCODIGO = ?
GROUP BY c.CARNOME, f.FUNCODIGO, f.FUNNOME, f.FUNATIVO, d.DPTNOME, ci.CIDNOME, ci.CIDUF, a.ALXDESCRICAO
ORDER BY f.FUNNOME;
```

---

### Exemplo 3: Análise de Participações de Vendedores por Cargo

**Objetivo:** Identificar participações de vendedores relacionadas a cargos específicos.

**Fluxo:**
```
CARGO (CARCODIGO)
  ↓
PARTVENDEDOR (CARCODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
PART (USRID)
```

**Query SQL:**
```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(DISTINCT pv.USRID) AS TOTAL_PARTICIPACOES,
    COUNT(DISTINCT pv.CLICODIGO) AS TOTAL_CLIENTES,
    STRING_AGG(DISTINCT cl.CLINOME, ', ') AS CLIENTES
FROM CARGO c
LEFT JOIN PARTVENDEDOR pv ON pv.CARCODIGO = c.CARCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = pv.CLICODIGO
WHERE c.CARCODIGO = ?
GROUP BY c.CARCODIGO, c.CARNOME;
```

---

## 💡 Casos de Uso Práticos

### 1. Listar Todos os Cargos

**Objetivo:** Visualizar todos os cargos cadastrados no sistema.

```sql
SELECT
    CARCODIGO,
    CARNOME AS CARGO,
    CASE WHEN CARINSTRUTOR = 'S' THEN 'Sim' ELSE 'Não' END AS EH_INSTRUTOR,
    CASE WHEN CARINTERNET = 'S' THEN 'Sim' ELSE 'Não' END AS EH_INTERNET
FROM CARGO
ORDER BY CARNOME;
```

---

### 2. Buscar Cargo Específico

**Objetivo:** Obter detalhes completos de um cargo específico.

```sql
SELECT
    c.*,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT pv.USRID) AS TOTAL_PARTICIPACOES
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
LEFT JOIN PARTVENDEDOR pv ON pv.CARCODIGO = c.CARCODIGO
WHERE c.CARCODIGO = ?
GROUP BY c.CARCODIGO, c.CARNOME, c.CARINSTRUTOR, c.CARINTERNET;
```

---

### 3. Análise de Distribuição de Funcionários por Cargo

**Objetivo:** Identificar quantos funcionários existem em cada cargo.

```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(CASE WHEN f.FUNATIVO = 'S' THEN 1 END) AS FUNCIONARIOS_ATIVOS,
    COUNT(CASE WHEN f.FUNATIVO != 'S' THEN 1 END) AS FUNCIONARIOS_INATIVOS,
    ROUND(COUNT(f.FUNCODIGO) * 100.0 / NULLIF((SELECT COUNT(*) FROM FUNCIO), 0), 2) AS PERCENTUAL_TOTAL
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
GROUP BY c.CARCODIGO, c.CARNOME
ORDER BY TOTAL_FUNCIONARIOS DESC;
```

---

### 4. Relatório de Cargos com Usuários do Sistema

**Objetivo:** Identificar quais cargos têm funcionários com acesso ao sistema.

```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(DISTINCT f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    COUNT(DISTINCT u.USUCODIGO) AS TOTAL_USUARIOS,
    STRING_AGG(DISTINCT u.USUNOME, ', ') AS USUARIOS
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
LEFT JOIN USUARIO u ON u.FUNCODIGO = f.FUNCODIGO
GROUP BY c.CARCODIGO, c.CARNOME
HAVING COUNT(DISTINCT u.USUCODIGO) > 0
ORDER BY TOTAL_USUARIOS DESC;
```

---

### 5. Análise de Cargos por Departamento

**Objetivo:** Identificar distribuição de cargos por departamento.

```sql
SELECT
    d.DPTCODIGO,
    d.DPTNOME AS DEPARTAMENTO,
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(f.FUNCODIGO) AS TOTAL_FUNCIONARIOS
FROM DEPTO d
INNER JOIN FUNCIO f ON f.DPTCODIGO = d.DPTCODIGO
INNER JOIN CARGO c ON c.CARCODIGO = f.CARCODIGO
GROUP BY d.DPTCODIGO, d.DPTNOME, c.CARCODIGO, c.CARNOME
ORDER BY d.DPTNOME, c.CARNOME;
```

---

### 6. Verificar Cargos de Instrutores

**Objetivo:** Listar cargos que são de instrutores.

```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(f.FUNCODIGO) AS TOTAL_FUNCIONARIOS,
    STRING_AGG(f.FUNNOME, ', ') AS FUNCIONARIOS
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
WHERE c.CARINSTRUTOR = 'S'
GROUP BY c.CARCODIGO, c.CARNOME;
```

---

### 7. Análise de Cargos com Participações de Vendedores

**Objetivo:** Identificar cargos que têm participações de vendedores vinculadas.

```sql
SELECT
    c.CARCODIGO,
    c.CARNOME AS CARGO,
    COUNT(DISTINCT pv.USRID) AS TOTAL_PARTICIPACOES,
    COUNT(DISTINCT pv.CLICODIGO) AS TOTAL_CLIENTES,
    STRING_AGG(DISTINCT cl.CLINOME, ', ') AS CLIENTES
FROM CARGO c
INNER JOIN PARTVENDEDOR pv ON pv.CARCODIGO = c.CARCODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = pv.CLICODIGO
GROUP BY c.CARCODIGO, c.CARNOME
ORDER BY TOTAL_PARTICIPACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CARGO | Tipo |
|--------|-----------|---------------------|------|
| **CARGO** | 10 | 1:1 | **TABELA PRINCIPAL** |
| FUNCIO | 435 | 43.5:1 | Funcionários (média de 43.5 funcionários por cargo) |
| PARTVENDEDOR | 802 | 80.2:1 | Participações (média de 80.2 participações por cargo) |
| USUARIO | 297 | 29.7:1 | Usuários (média de 29.7 usuários por cargo) |

**Interpretação:**
- Cada cargo possui em média **43.5 funcionários** (distribuição concentrada)
- Cada cargo possui em média **80.2 participações de vendedores** (alta concentração)
- Cada cargo possui em média **29.7 usuários do sistema** (alta taxa de acesso)
- Tabela pequena mas crítica para organização

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CARCODIGO** | CARGO | Identificador único (PK) |
| **CARCODIGO** | FUNCIO → CARGO | Referência ao cargo do funcionário |
| **CARCODIGO** | PARTVENDEDOR → CARGO | Referência ao cargo na participação |
| **CARNOME** | CARGO | Nome do cargo (busca e exibição) |
| **CARINSTRUTOR** | CARGO | Flag de instrutor (filtro) |
| **CARINTERNET** | CARGO | Flag de internet (filtro) |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CARGO.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Índice em CARNOME** - Para buscas por nome (opcional, tabela pequena)
3. **Índices nas tabelas relacionadas** - Mais críticos que índices em CARGO

### Observações sobre Volume

- **Tabela muito pequena** (10 registros) - Performance não é crítica
- **Consultas com JOINs** são rápidas devido ao volume reduzido
- **Focar em índices nas tabelas relacionadas** - FUNCIO e PARTVENDEDOR têm volumes maiores
- **Cache pode ser útil** - Tabela pequena pode ser mantida em memória

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (tabela pequena, não precisa de otimização especial)
SELECT CARCODIGO, CARNOME
FROM CARGO
WHERE CARCODIGO = ?;

-- ✅ OTIMIZADO (JOIN com tabela pequena é rápido)
SELECT c.CARNOME, COUNT(f.FUNCODIGO) AS TOTAL
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
GROUP BY c.CARCODIGO, c.CARNOME;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar funcionários sem cargo válido
SELECT f.*
FROM FUNCIO f
LEFT JOIN CARGO c ON c.CARCODIGO = f.CARCODIGO
WHERE c.CARCODIGO IS NULL;

-- Verificar participações sem cargo válido
SELECT pv.*
FROM PARTVENDEDOR pv
LEFT JOIN CARGO c ON c.CARCODIGO = pv.CARCODIGO
WHERE pv.CARCODIGO IS NOT NULL AND c.CARCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CARGO
WHERE CARCODIGO IS NULL
   OR CARNOME IS NULL;

-- Verificar nomes duplicados
SELECT CARNOME, COUNT(*) AS QTD
FROM CARGO
GROUP BY CARNOME
HAVING COUNT(*) > 1;

-- Verificar flags de instrutor/internet
SELECT
    CARCODIGO,
    CARNOME,
    CARINSTRUTOR,
    CARINTERNET,
    CASE
        WHEN CARINSTRUTOR IS NOT NULL AND CARINSTRUTOR NOT IN ('S', 'N') THEN 'INVALIDO'
        ELSE 'OK'
    END AS STATUS_INSTRUTOR,
    CASE
        WHEN CARINTERNET IS NOT NULL AND CARINTERNET NOT IN ('S', 'N') THEN 'INVALIDO'
        ELSE 'OK'
    END AS STATUS_INTERNET
FROM CARGO;
```

### Verificar Padrões de Uso

```sql
-- Verificar cargos sem funcionários
SELECT c.*
FROM CARGO c
LEFT JOIN FUNCIO f ON f.CARCODIGO = c.CARCODIGO
WHERE f.FUNCODIGO IS NULL;

-- Verificar cargos sem participações
SELECT c.*
FROM CARGO c
LEFT JOIN PARTVENDEDOR pv ON pv.CARCODIGO = c.CARCODIGO
WHERE pv.USRID IS NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCargo extends Model
{
    protected $connection = 'firebird';
    protected $table = 'CARGO';
    protected $primaryKey = 'CARCODIGO';

    protected $casts = [
        'CARCODIGO' => 'integer',
        'CARNOME' => 'string',
        'CARINSTRUTOR' => 'string',
        'CARINTERNET' => 'string',
    ];

    // Relacionamento com FUNCIO
    public function funcionarios(): HasMany
    {
        return $this->hasMany(FirebirdFuncio::class, 'CARCODIGO', 'CARCODIGO');
    }

    // Relacionamento com PARTVENDEDOR
    public function participacoesVendedores(): HasMany
    {
        return $this->hasMany(FirebirdPartVendedor::class, 'CARCODIGO', 'CARCODIGO');
    }

    // Relacionamento indireto com USUARIO via FUNCIO
    public function usuarios()
    {
        return $this->hasManyThrough(
            FirebirdUsuario::class,
            FirebirdFuncio::class,
            'CARCODIGO', // Foreign key em FUNCIO
            'FUNCODIGO', // Foreign key em USUARIO
            'CARCODIGO', // Local key em CARGO
            'FUNCODIGO'  // Local key em FUNCIO
        );
    }

    // Scope para buscar por nome
    public function scopePorNome($query, string $nome)
    {
        return $query->whereRaw('UPPER(CARNOME) LIKE UPPER(?)', ['%' . $nome . '%']);
    }

    // Scope para cargos de instrutores
    public function scopeInstrutores($query)
    {
        return $query->where('CARINSTRUTOR', 'S');
    }

    // Scope para cargos de internet
    public function scopeInternet($query)
    {
        return $query->where('CARINTERNET', 'S');
    }

    // Método para verificar se é instrutor
    public function isInstrutor(): bool
    {
        return $this->CARINSTRUTOR === 'S';
    }

    // Método para verificar se é internet
    public function isInternet(): bool
    {
        return $this->CARINTERNET === 'S';
    }

    // Método para contar funcionários ativos
    public function contarFuncionariosAtivos(): int
    {
        return $this->funcionarios()
            ->where('FUNATIVO', 'S')
            ->count();
    }

    // Método para contar usuários
    public function contarUsuarios(): int
    {
        return $this->usuarios()->count();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Manter consistência** - CARNOME deve ser único e descritivo
2. **Flags claras** - CARINSTRUTOR e CARINTERNET devem ser 'S' ou 'N'
3. **Nomenclatura padronizada** - Usar nomes de cargos consistentes
4. **Documentação** - Documentar significado de cada cargo

### Performance

1. **Tabela pequena** - Não requer otimização especial
2. **Cache útil** - Pode ser mantida em memória
3. **Índices nas tabelas relacionadas** - Mais importante que índices em CARGO
4. **Evitar SELECT *** - Especificar apenas colunas necessárias

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se CARNOME não existe
2. **Verificar referências** - Antes de excluir, verificar se há funcionários
3. **Manter consistência** - Garantir que flags são válidas
4. **Auditoria** - Registrar alterações em cargos críticos

### Manutenção

1. **Revisão periódica** - Verificar cargos não utilizados
2. **Padronização** - Manter nomenclatura consistente
3. **Documentação** - Documentar significado de cada cargo
4. **Backup regular** - Tabela crítica para organização

### Regras de Negócio

1. **Cargos únicos** - Não devem existir cargos duplicados
2. **Referências obrigatórias** - FUNCIO deve sempre ter CARCODIGO válido
3. **Flags opcionais** - CARINSTRUTOR e CARINTERNET são opcionais
4. **Integridade referencial** - Não excluir cargo com funcionários vinculados

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

