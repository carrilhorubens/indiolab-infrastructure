# GRUPOCLI - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: GRUPOCLI (Grupo de Clientes)
- **Total de Registros**: 320
- **Total de Colunas**: 6
- **Chave Primária**: GCLCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (USUARIOWEB)
- **Banco de Dados**: Firebird

## 📝 Descrição

**GRUPOCLI** é uma tabela mestre que armazena grupos de clientes utilizados para controle de acesso e configurações específicas de usuários web. Com **320 registros**, representa diferentes grupos de clientes que permitem controle de limites de crédito, dias de atraso e outras configurações específicas por grupo.

Esta tabela funciona como **catálogo de grupos de clientes** e permite:
- Agrupar clientes em categorias específicas
- Controlar limites de crédito por grupo
- Definir dias de atraso permitidos por grupo
- Controlar situação de clientes por grupo
- Permitir ou bloquear empenho de clientes por grupo
- Facilitar gestão de acesso e permissões de usuários web

Cada registro representa um grupo de clientes específico, contendo:
- Código do grupo (GCLCODIGO)
- Nome do grupo (GCLNOME)
- Situação de cliente (GCLSITCLI)
- Limite de crédito de cliente (GCLLMTCREDCLI)
- Dias de atraso de cliente (GCLDIASATRASCLI)
- Empenho de cliente (GCLDEMPENCLI)

O sistema utiliza esta tabela para controlar configurações específicas de grupos de clientes, sendo referenciada por USUARIOWEB para definir grupos de acesso de usuários web.

**Observação Importante:** GRUPOCLI é uma tabela mestre de grupos de clientes. Com 320 registros, indica uso extensivo desta funcionalidade. É referenciada por USUARIOWEB para controle de acesso e permissões de usuários web.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GCLCODIGO** 🔑 | INTEGER | ✓ | Código do grupo de clientes (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **GCLNOME** | VARCHAR(37) | ✓ | Nome do grupo de clientes |
| **GCLSITCLI** | VARCHAR(14) | ✓ | Situação de cliente (S/N) |
| **GCLLMTCREDCLI** | VARCHAR(14) | ✓ | Limite de crédito de cliente (S/N) |
| **GCLDIASATRASCLI** | VARCHAR(14) | ✓ | Dias de atraso de cliente (S/N) |
| **GCLDEMPENCLI** | VARCHAR(14) | ✓ | Empenho de cliente (S/N) |

**Primary Key:** GCLCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### GRUPOCLI Referencia (0 FKs):

Nenhuma foreign key direta.

---

### GRUPOCLI é Referenciada Por (1 tabela):

#### 1. USUARIOWEB - Usuários Web
**Relacionamento:**
```
USUARIOWEB.GCLCODIGO → GRUPOCLI.GCLCODIGO (N:1)
Constraint: USUARIOWEB_GRUPOCLI
```

**Descrição**: Cada usuário web pode estar vinculado a um grupo de clientes específico.

**Informações da Tabela USUARIOWEB:**
- **Total:** Informação não disponível
- **PK:** Informação não disponível
- **Colunas:** Informação não disponível

**Uso:** Vincular usuários web a grupos de clientes para controle de acesso e permissões.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via USUARIOWEB → Outras Operações de Usuários

**Fluxo:** GRUPOCLI → USUARIOWEB → Operações

**Descrição:** Através dos usuários web, é possível identificar outras operações relacionadas.

**Uso:** Análise de grupos de clientes através de usuários web.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Grupo de Clientes

**Objetivo:** Obter visão completa de um grupo de clientes incluindo usuários web vinculados.

**Fluxo:**
```
GRUPOCLI (GCLCODIGO)
  ↓
USUARIOWEB (GCLCODIGO)
```

**Query SQL:**
```sql
SELECT
    gc.GCLCODIGO,
    gc.GCLNOME AS GRUPO_CLIENTES,
    gc.GCLSITCLI AS SITUACAO_CLIENTE,
    gc.GCLLMTCREDCLI AS LIMITE_CREDITO,
    gc.GCLDIASATRASCLI AS DIAS_ATRASO,
    gc.GCLDEMPENCLI AS EMPENHO,
    COUNT(uw.UWCODIGO) AS TOTAL_USUARIOS_WEB
FROM GRUPOCLI gc
LEFT JOIN USUARIOWEB uw ON uw.GCLCODIGO = gc.GCLCODIGO
WHERE gc.GCLCODIGO = ?
GROUP BY gc.GCLCODIGO, gc.GCLNOME, gc.GCLSITCLI, gc.GCLLMTCREDCLI,
         gc.GCLDIASATRASCLI, gc.GCLDEMPENCLI;
```

---

### Exemplo 2: Análise de Grupos por Configurações

**Objetivo:** Identificar distribuição de grupos por configurações específicas.

**Query SQL:**
```sql
SELECT
    GCLSITCLI AS SITUACAO_CLIENTE,
    GCLLMTCREDCLI AS LIMITE_CREDITO,
    GCLDIASATRASCLI AS DIAS_ATRASO,
    GCLDEMPENCLI AS EMPENHO,
    COUNT(*) AS TOTAL_GRUPOS
FROM GRUPOCLI
GROUP BY GCLSITCLI, GCLLMTCREDCLI, GCLDIASATRASCLI, GCLDEMPENCLI
ORDER BY TOTAL_GRUPOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Grupo de Clientes

**Objetivo:** Obter informações de um grupo de clientes específico.

```sql
SELECT
    GCLCODIGO,
    GCLNOME AS GRUPO_CLIENTES,
    GCLSITCLI AS SITUACAO_CLIENTE,
    GCLLMTCREDCLI AS LIMITE_CREDITO,
    GCLDIASATRASCLI AS DIAS_ATRASO,
    GCLDEMPENCLI AS EMPENHO
FROM GRUPOCLI
WHERE GCLCODIGO = ?;
```

---

### 2. Listar Todos os Grupos de Clientes

**Objetivo:** Obter catálogo completo de grupos de clientes.

```sql
SELECT
    GCLCODIGO,
    GCLNOME AS GRUPO_CLIENTES,
    GCLSITCLI AS SITUACAO_CLIENTE,
    GCLLMTCREDCLI AS LIMITE_CREDITO
FROM GRUPOCLI
ORDER BY GCLNOME;
```

---

### 3. Análise de Grupos com Usuários Web

**Objetivo:** Identificar grupos que possuem usuários web vinculados.

**Query SQL:**
```sql
SELECT
    gc.GCLCODIGO,
    gc.GCLNOME AS GRUPO_CLIENTES,
    COUNT(uw.UWCODIGO) AS TOTAL_USUARIOS_WEB
FROM GRUPOCLI gc
LEFT JOIN USUARIOWEB uw ON uw.GCLCODIGO = gc.GCLCODIGO
GROUP BY gc.GCLCODIGO, gc.GCLNOME
HAVING COUNT(uw.UWCODIGO) > 0
ORDER BY TOTAL_USUARIOS_WEB DESC;
```

---

### 4. Relatório Completo de Grupos de Clientes

**Objetivo:** Analisar distribuição completa de grupos de clientes no sistema.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_GRUPOS,
    COUNT(CASE WHEN GCLSITCLI = 'S' THEN 1 END) AS COM_SITUACAO_CLIENTE,
    COUNT(CASE WHEN GCLLMTCREDCLI = 'S' THEN 1 END) AS COM_LIMITE_CREDITO,
    COUNT(CASE WHEN GCLDIASATRASCLI = 'S' THEN 1 END) AS COM_DIAS_ATRASO,
    COUNT(CASE WHEN GCLDEMPENCLI = 'S' THEN 1 END) AS COM_EMPENHO,
    (SELECT COUNT(*) FROM USUARIOWEB WHERE GCLCODIGO IS NOT NULL) AS TOTAL_USUARIOS_WEB_VINCULADOS
FROM GRUPOCLI;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com GRUPOCLI | Tipo |
|--------|-----------|----------------------|------|
| **GRUPOCLI** | 320 | 1:1 | **TABELA PRINCIPAL** |
| USUARIOWEB | Informação não disponível | - | Usuários web vinculados |

**Interpretação:**
- **320 grupos de clientes** cadastrados no sistema
- Indica uso extensivo desta funcionalidade para controle de acesso

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (consultas frequentes)
CREATE INDEX IDX_GRUPOCLI_NOME ON GRUPOCLI(GCLNOME)
    WHERE GCLNOME IS NOT NULL;

-- Índice 2: Busca por situação cliente (consultas frequentes)
CREATE INDEX IDX_GRUPOCLI_SITUACAO ON GRUPOCLI(GCLSITCLI)
    WHERE GCLSITCLI = 'S';
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

final class FirebirdGrupocli extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'GRUPOCLI';
    
    protected $primaryKey = 'GCLCODIGO';
    public $incrementing = true;

    protected $casts = [
        'GCLCODIGO' => 'integer',
        'GCLNOME' => 'string',
        'GCLSITCLI' => 'string',
        'GCLLMTCREDCLI' => 'string',
        'GCLDIASATRASCLI' => 'string',
        'GCLDEMPENCLI' => 'string',
    ];

    // Relacionamento com USUARIOWEB
    public function usuariosWeb(): HasMany
    {
        return $this->hasMany(FirebirdUsuarioweb::class, 'GCLCODIGO', 'GCLCODIGO');
    }

    public function scopeComSituacaoCliente($query)
    {
        return $query->where('GCLSITCLI', 'S');
    }

    public function scopeComLimiteCredito($query)
    {
        return $query->where('GCLLMTCREDCLI', 'S');
    }

    public function scopeComDiasAtraso($query)
    {
        return $query->where('GCLDIASATRASCLI', 'S');
    }

    public function scopeComEmpenho($query)
    {
        return $query->where('GCLDEMPENCLI', 'S');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

