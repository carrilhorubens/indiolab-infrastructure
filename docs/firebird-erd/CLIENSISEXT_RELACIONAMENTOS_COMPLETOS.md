# CLIENSISEXT - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CLIENSISEXT (Cliente x Sistema Externo)
- **Total de Registros**: 2
- **Total de Colunas**: 3
- **Chave Primária**: (CLICODIGO, CSENOME) - Composta
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0 (tabela folha)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CLIENSISEXT** é uma tabela de mapeamento que associa clientes internos a códigos correspondentes em sistemas externos. Com apenas **2 registros**, representa integrações específicas de clientes com sistemas externos através de APIs ou web services.

Esta tabela funciona como **mapeador de integração cliente-sistema externo** e permite:
- Mapear clientes internos para códigos em sistemas externos
- Suportar múltiplas integrações por cliente (um cliente pode ter códigos em vários sistemas)
- Facilitar sincronização bidirecional de dados
- Permitir identificação de clientes em sistemas externos
- Suportar integrações via web services e APIs
- Manter rastreabilidade de mapeamentos cliente-sistema externo

Cada registro representa um mapeamento entre um cliente interno (CLICODIGO) e um código correspondente em um sistema externo específico (CSENOME), contendo:
- Identificação do cliente interno (CLICODIGO)
- Código do cliente no sistema externo (CSECODIGO)
- Nome do sistema externo (CSENOME)

O sistema utiliza esta tabela para realizar integrações com sistemas externos, permitindo que clientes sejam identificados e sincronizados entre o sistema interno e sistemas externos através de web services ou APIs.

**Observação Importante:** CLIENSISEXT segue o mesmo padrão de outras tabelas de integração como PRODUSISEXT (217 registros), MARCASISEXT (0 registros), SERVISISEXT (0 registros), etc. Com apenas 2 registros, indica uso muito limitado ou específico de integração de clientes com sistemas externos. A maioria dos clientes não possui integração com sistemas externos.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CLICODIGO** 🔑🔗 | INTEGER | ✓ | Código do cliente interno (PK + FK → CLIEN) |
| **CSENOME** 🔑🔗 | VARCHAR(14) | ✓ | Nome do sistema externo (PK + FK → SISTEMAEXT) |

### Código no Sistema Externo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CSECODIGO** | VARCHAR(37) | ✓ | Código do cliente no sistema externo |

**Primary Key:** (CLICODIGO, CSENOME)

**Observações sobre Campos:**
- **CLICODIGO**: Cliente interno do sistema que será mapeado para o sistema externo.
- **CSENOME**: Nome/código do sistema externo onde o cliente será identificado.
- **CSECODIGO**: Código usado no sistema externo para identificar o cliente. Este código pode ser diferente do CLICODIGO interno.

**Padrão de Mapeamento:**
- **Sistema Interno**: CLICODIGO (ex: 12345)
- **Sistema Externo**: CSECODIGO (ex: "CLI-2024-001" ou "EXT12345")
- **Identificação do Sistema**: CSENOME (ex: "API_LOGISTICA" ou "ERP_EXTERNO")

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CLIENSISEXT Referencia (2 FKs):

#### 1. CLIEN - Clientes
**Relacionamento:**
```
CLIENSISEXT.CLICODIGO → CLIEN.CLICODIGO (N:1)
Constraint: CLIEN_CLIENSISEXT
```

**Descrição**: Cada mapeamento está vinculado a um cliente específico do sistema interno.

**Informações da Tabela CLIEN:**
- **Total:** 9.251 clientes
- **PK:** CLICODIGO
- **Colunas:** 111 campos
- **FK Out:** 0
- **FK In:** 106 tabelas

**Campos importantes em CLIEN relacionados a CLIENSISEXT:**
- `CLICODIGO` - Código do cliente interno
- `CLINOMEFANT` - Nome fantasia
- `CLIRAZSOCIAL` - Razão social
- `CLICNPJCPF` - CNPJ/CPF (pode ser usado para matching em sistemas externos)

**Uso:** Identificar o cliente interno do mapeamento, relatórios de integração por cliente, análises de clientes integrados.

---

#### 2. SISTEMAEXT - Sistemas Externos
**Relacionamento:**
```
CLIENSISEXT.CSENOME → SISTEMAEXT.SIECODIGO (N:1)
Constraint: SISTEMAEXT_CLIENSISEXT
```

**Descrição**: Cada mapeamento está vinculado a um sistema externo específico.

**Informações da Tabela SISTEMAEXT:**
- **Total:** 26 sistemas externos
- **PK:** SIECODIGO
- **Colunas:** 5 campos
- **FK Out:** 0
- **FK In:** 21 tabelas

**Campos importantes em SISTEMAEXT relacionados a CLIENSISEXT:**
- `SIECODIGO` - Código do sistema externo (corresponde a CSENOME)
- `SIENOME` - Nome descritivo do sistema externo
- `SIEURLWEBSERVICE` - URL do web service para integração
- `SIEBUSCADEPARA` - Parâmetro de busca no sistema externo
- `SIEURLWEBSERVICEFORNEC` - URL do web service para fornecedores

**Uso:** Identificar o sistema externo da integração, obter URLs de web services, configurar integrações.

**Observação:** SISTEMAEXT armazena configurações de sistemas externos incluindo URLs de web services, permitindo integração via APIs.

---

### CLIENSISEXT é Referenciada Por

**Nenhuma tabela** referencia CLIENSISEXT diretamente. Esta é uma tabela folha utilizada para mapeamento e consulta de integrações.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via CLIEN → PEDID (Pedidos)

**Fluxo:** CLIENSISEXT → CLIEN → PEDID

**Descrição:** Através do cliente, é possível identificar pedidos que podem estar relacionados à integração com sistemas externos.

**Uso:** Análises de pedidos de clientes integrados, sincronização de pedidos com sistemas externos.

---

### Via CLIEN → NOTAS (Notas Fiscais)

**Fluxo:** CLIENSISEXT → CLIEN → NOTAS

**Descrição:** Através do cliente, é possível identificar notas fiscais que podem estar relacionadas à integração.

**Uso:** Análises de notas fiscais de clientes integrados, sincronização de notas com sistemas externos.

---

### Via SISTEMAEXT → Outras Tabelas de Integração

**Fluxo:** CLIENSISEXT → SISTEMAEXT → Outras *SISEXT

**Descrição:** Através do sistema externo, é possível identificar outras entidades integradas no mesmo sistema.

**Tabelas relacionadas:**
- PRODUSISEXT (217 registros) - Produtos integrados
- MARCASISEXT (0 registros) - Marcas integradas
- SERVISISEXT (0 registros) - Serviços integrados
- LOCALPEDSISEXT - Localizações integradas
- GRUPO1SISEXT, GRUPO2SISEXT, GRUPO3SISEXT, GRUPO4SISEXT - Grupos integrados
- E outras 15+ tabelas de integração

**Uso:** Análises de integrações completas por sistema externo, validação de consistência de integrações.

---

### Via CLIEN → ENDCLI (Endereços)

**Fluxo:** CLIENSISEXT → CLIEN → ENDCLI

**Descrição:** Através do cliente, é possível identificar endereços que podem ser sincronizados com sistemas externos.

**Uso:** Sincronização de endereços com sistemas externos.

---

### Via CLIEN → CLINET (Contatos)

**Fluxo:** CLIENSISEXT → CLIEN → CLINET

**Descrição:** Através do cliente, é possível identificar contatos que podem ser sincronizados com sistemas externos.

**Uso:** Sincronização de contatos com sistemas externos.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Integração por Cliente

**Objetivo:** Obter visão completa de uma integração incluindo informações do cliente e sistema externo.

**Fluxo:**
```
CLIENSISEXT (CLICODIGO, CSENOME, CSECODIGO)
  ↓
CLIEN (CLICODIGO)
  ↓
SISTEMAEXT (SIECODIGO = CSENOME)
```

**Query SQL:**
```sql
SELECT
    cse.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_INTERNO,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cl.CLICNPJCPF AS CNPJ_CPF,
    cse.CSENOME AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    sie.SIEURLWEBSERVICE AS URL_WEBSERVICE,
    cse.CSECODIGO AS CODIGO_EXTERNO
FROM CLIENSISEXT cse
INNER JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
INNER JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
WHERE cse.CLICODIGO = ?;
```

---

### Exemplo 2: Análise de Integrações por Sistema Externo

**Objetivo:** Identificar todos os clientes integrados em um sistema externo específico.

**Fluxo:**
```
SISTEMAEXT (SIECODIGO)
  ↓
CLIENSISEXT (CSENOME = SIECODIGO)
  ↓
CLIEN (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    sie.SIECODIGO AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    sie.SIEURLWEBSERVICE AS URL_WEBSERVICE,
    COUNT(DISTINCT cse.CLICODIGO) AS TOTAL_CLIENTES_INTEGRADOS,
    COUNT(*) AS TOTAL_MAPEAMENTOS,
    STRING_AGG(cl.CLINOMEFANT || ' (' || cse.CSECODIGO || ')', ', ') AS CLIENTES_INTEGRADOS
FROM SISTEMAEXT sie
LEFT JOIN CLIENSISEXT cse ON cse.CSENOME = sie.SIECODIGO
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
WHERE sie.SIECODIGO = ?
GROUP BY sie.SIECODIGO, sie.SIENOME, sie.SIEURLWEBSERVICE;
```

---

### Exemplo 3: Análise de Integrações com Pedidos

**Objetivo:** Identificar pedidos de clientes integrados e analisar impacto das integrações.

**Fluxo:**
```
CLIENSISEXT (CLICODIGO, CSENOME)
  ↓
CLIEN (CLICODIGO)
  ↓
PEDID (CLICODIGO)
```

**Query SQL:**
```sql
SELECT
    cse.CSENOME AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    COUNT(DISTINCT cse.CLICODIGO) AS TOTAL_CLIENTES_INTEGRADOS,
    COUNT(DISTINCT pd.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(pd.PEDVRMERC) AS VALOR_TOTAL_PEDIDOS,
    AVG(pd.PEDVRMERC) AS VALOR_MEDIO_PEDIDOS
FROM CLIENSISEXT cse
INNER JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
INNER JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
LEFT JOIN PEDID pd ON pd.CLICODIGO = cse.CLICODIGO
GROUP BY cse.CSENOME, sie.SIENOME
ORDER BY TOTAL_PEDIDOS DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Mapeamento de Cliente

**Objetivo:** Obter o código de um cliente em um sistema externo específico.

```sql
SELECT
    cse.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_INTERNO,
    cse.CSENOME AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    cse.CSECODIGO AS CODIGO_EXTERNO
FROM CLIENSISEXT cse
INNER JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
INNER JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
WHERE cse.CLICODIGO = ?
  AND cse.CSENOME = ?;
```

---

### 2. Listar Todas as Integrações de um Cliente

**Objetivo:** Obter todos os sistemas externos onde um cliente está integrado.

```sql
SELECT
    cse.CSENOME AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    sie.SIEURLWEBSERVICE AS URL_WEBSERVICE,
    cse.CSECODIGO AS CODIGO_EXTERNO
FROM CLIENSISEXT cse
INNER JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
WHERE cse.CLICODIGO = ?
ORDER BY sie.SIENOME;
```

---

### 3. Buscar Cliente por Código Externo

**Objetivo:** Identificar cliente interno a partir do código em sistema externo.

```sql
SELECT
    cse.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE_INTERNO,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cl.CLICNPJCPF AS CNPJ_CPF,
    cse.CSENOME AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    cse.CSECODIGO AS CODIGO_EXTERNO
FROM CLIENSISEXT cse
INNER JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
INNER JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
WHERE cse.CSENOME = ?
  AND cse.CSECODIGO = ?;
```

---

### 4. Relatório de Integrações por Sistema Externo

**Objetivo:** Analisar distribuição de clientes integrados por sistema externo.

```sql
SELECT
    sie.SIECODIGO AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    sie.SIEURLWEBSERVICE AS URL_WEBSERVICE,
    COUNT(DISTINCT cse.CLICODIGO) AS TOTAL_CLIENTES_INTEGRADOS,
    COUNT(*) AS TOTAL_MAPEAMENTOS,
    ROUND(COUNT(DISTINCT cse.CLICODIGO) * 100.0 / (SELECT COUNT(*) FROM CLIEN WHERE CLICLIENTE = 'S'), 2) AS PERCENTUAL_CLIENTES_INTEGRADOS
FROM SISTEMAEXT sie
LEFT JOIN CLIENSISEXT cse ON cse.CSENOME = sie.SIECODIGO
GROUP BY sie.SIECODIGO, sie.SIENOME, sie.SIEURLWEBSERVICE
ORDER BY TOTAL_CLIENTES_INTEGRADOS DESC;
```

---

### 5. Análise de Clientes Sem Integração

**Objetivo:** Identificar clientes que não estão integrados com nenhum sistema externo.

```sql
SELECT
    cl.CLICODIGO,
    cl.CLINOMEFANT AS CLIENTE,
    cl.CLIRAZSOCIAL AS RAZAO_SOCIAL,
    cl.CLICNPJCPF AS CNPJ_CPF
FROM CLIEN cl
LEFT JOIN CLIENSISEXT cse ON cse.CLICODIGO = cl.CLICODIGO
WHERE cl.CLICLIENTE = 'S'
  AND cse.CLICODIGO IS NULL
ORDER BY cl.CLINOMEFANT;
```

---

### 6. Comparação com Outras Integrações

**Objetivo:** Comparar integração de clientes com integração de produtos e outras entidades.

**Query SQL:**
```sql
SELECT
    'CLIENTES' AS TIPO_ENTIDADE,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT CLICODIGO) AS TOTAL_ENTIDADES_INTEGRADAS
FROM CLIENSISEXT
UNION ALL
SELECT
    'PRODUTOS' AS TIPO_ENTIDADE,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT PROCODIGO) AS TOTAL_ENTIDADES_INTEGRADAS
FROM PRODUSISEXT
UNION ALL
SELECT
    'MARCAS' AS TIPO_ENTIDADE,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT MARCODIGO) AS TOTAL_ENTIDADES_INTEGRADAS
FROM MARCASISEXT
UNION ALL
SELECT
    'SERVICOS' AS TIPO_ENTIDADE,
    COUNT(*) AS TOTAL_INTEGRACOES,
    COUNT(DISTINCT SERCODIGO) AS TOTAL_ENTIDADES_INTEGRADAS
FROM SERVISISEXT
ORDER BY TOTAL_INTEGRACOES DESC;
```

---

### 7. Análise de Integrações por Sistema com Web Service

**Objetivo:** Identificar sistemas externos com web service configurado e clientes integrados.

```sql
SELECT
    sie.SIECODIGO AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    sie.SIEURLWEBSERVICE AS URL_WEBSERVICE,
    CASE 
        WHEN sie.SIEURLWEBSERVICE IS NOT NULL AND sie.SIEURLWEBSERVICE != '' THEN 'SIM'
        ELSE 'NÃO'
    END AS TEM_WEBSERVICE,
    COUNT(DISTINCT cse.CLICODIGO) AS TOTAL_CLIENTES_INTEGRADOS,
    COUNT(*) AS TOTAL_MAPEAMENTOS
FROM SISTEMAEXT sie
LEFT JOIN CLIENSISEXT cse ON cse.CSENOME = sie.SIECODIGO
GROUP BY sie.SIECODIGO, sie.SIENOME, sie.SIEURLWEBSERVICE
ORDER BY TOTAL_CLIENTES_INTEGRADOS DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CLIENSISEXT | Tipo |
|--------|-----------|---------------------|------|
| **CLIENSISEXT** | 2 | 1:1 | **TABELA PRINCIPAL** |
| CLIEN | 9.251 | 4.625:1 | Clientes (média de 0.0002 integrações por cliente) |
| SISTEMAEXT | 26 | 13:1 | Sistemas externos (média de 0.077 clientes por sistema) |
| PRODUSISEXT | 217 | 108.5:1 | Produtos integrados (muito maior que clientes) |

**Interpretação:**
- **Apenas 2 integrações** de clientes cadastradas no sistema
- **0.02% dos clientes** têm integração com sistemas externos (2 de 9.251)
- **7.7% dos sistemas externos** têm pelo menos um cliente integrado (2 de 26)
- **Uso muito limitado** - indica integração específica ou em fase de implementação
- **Produtos têm muito mais integrações** - 217 produtos integrados vs 2 clientes

**Distribuição Esperada:**
- Clientes integrados: clientes específicos que requerem sincronização com sistemas externos
- Sistemas externos com clientes: sistemas que realmente precisam de integração de clientes
- Maioria sem integração: a maioria dos clientes não requer integração com sistemas externos

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CLICODIGO, CSENOME** | CLIENSISEXT | Chave primária composta (PK) |
| **CLICODIGO** | CLIENSISEXT → CLIEN | Cliente interno do mapeamento |
| **CSENOME** | CLIENSISEXT → SISTEMAEXT | Sistema externo do mapeamento |
| **CSECODIGO** | CLIENSISEXT | Código do cliente no sistema externo |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CLIENSISEXT.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por cliente** - Para buscas por cliente
3. **Índice por sistema externo** - Para buscas por sistema
4. **Índices compostos** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por cliente (consultas frequentes)
CREATE INDEX IDX_CLIENSISEXT_CLIENTE ON CLIENSISEXT(CLICODIGO);

-- Índice 2: Busca por sistema externo (consultas frequentes)
CREATE INDEX IDX_CLIENSISEXT_SISTEMA ON CLIENSISEXT(CSENOME);

-- Índice 3: Busca composta por cliente e sistema (consultas de validação)
CREATE INDEX IDX_CLIENSISEXT_CLI_SIS ON CLIENSISEXT(CLICODIGO, CSENOME);

-- Índice 4: Busca por código externo (consultas específicas)
CREATE INDEX IDX_CLIENSISEXT_CODIGO_EXT ON CLIENSISEXT(CSECODIGO) 
    WHERE CSECODIGO IS NOT NULL AND CSECODIGO != '';
```

### Observações sobre Volume

- **Tabela muito pequena** (2 registros) - Performance excelente
- **Consultas são extremamente rápidas** devido ao volume muito pequeno
- **Índices úteis** para buscas por cliente e sistema externo
- **Focar em índices compostos** - Consultas geralmente filtram por cliente e sistema

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (usar índice na PK composta)
SELECT CLICODIGO, CSECODIGO, CSENOME
FROM CLIENSISEXT
WHERE CLICODIGO = ?
  AND CSENOME = ?;

-- ✅ OTIMIZADO (usar índice em CLICODIGO)
SELECT CLICODIGO, CSECODIGO, CSENOME
FROM CLIENSISEXT
WHERE CLICODIGO = ?
ORDER BY CSENOME;

-- ✅ OTIMIZADO (usar índice em CSENOME)
SELECT CLICODIGO, CSECODIGO, CSENOME
FROM CLIENSISEXT
WHERE CSENOME = ?
ORDER BY CLICODIGO;

-- ✅ OTIMIZADO (usar índices compostos)
SELECT CLICODIGO, CSECODIGO, CSENOME
FROM CLIENSISEXT
WHERE CLICODIGO = ?
  AND CSENOME = ?
ORDER BY CSECODIGO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar mapeamentos sem cliente válido
SELECT cse.*
FROM CLIENSISEXT cse
LEFT JOIN CLIEN cl ON cl.CLICODIGO = cse.CLICODIGO
WHERE cl.CLICODIGO IS NULL;

-- Verificar mapeamentos sem sistema externo válido
SELECT cse.*
FROM CLIENSISEXT cse
LEFT JOIN SISTEMAEXT sie ON sie.SIECODIGO = cse.CSENOME
WHERE sie.SIECODIGO IS NULL;

-- Verificar mapeamentos com código externo vazio
SELECT *
FROM CLIENSISEXT
WHERE CSECODIGO IS NULL
   OR CSECODIGO = '';
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CLIENSISEXT
WHERE CLICODIGO IS NULL
   OR CSENOME IS NULL
   OR CSENOME = ''
   OR CSECODIGO IS NULL
   OR CSECODIGO = '';

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT CLICODIGO, CSENOME, COUNT(*) AS QTD
FROM CLIENSISEXT
GROUP BY CLICODIGO, CSENOME
HAVING COUNT(*) > 1;

-- Verificar códigos externos duplicados no mesmo sistema
SELECT CSENOME, CSECODIGO, COUNT(*) AS QTD
FROM CLIENSISEXT
GROUP BY CSENOME, CSECODIGO
HAVING COUNT(*) > 1;
```

### Verificar Padrões de Uso

```sql
-- Verificar distribuição por cliente
SELECT
    COUNT(DISTINCT CLICODIGO) AS TOTAL_CLIENTES_INTEGRADOS,
    COUNT(*) AS TOTAL_INTEGRACOES,
    AVG(INTEGRACOES_POR_CLIENTE) AS MEDIA_INTEGRACOES_POR_CLIENTE,
    MAX(INTEGRACOES_POR_CLIENTE) AS MAX_INTEGRACOES_POR_CLIENTE,
    MIN(INTEGRACOES_POR_CLIENTE) AS MIN_INTEGRACOES_POR_CLIENTE
FROM (
    SELECT 
        CLICODIGO,
        COUNT(*) AS INTEGRACOES_POR_CLIENTE
    FROM CLIENSISEXT
    GROUP BY CLICODIGO
);

-- Verificar distribuição por sistema externo
SELECT
    COUNT(DISTINCT CSENOME) AS TOTAL_SISTEMAS_COM_CLIENTES,
    COUNT(*) AS TOTAL_INTEGRACOES,
    AVG(CLIENTES_POR_SISTEMA) AS MEDIA_CLIENTES_POR_SISTEMA,
    MAX(CLIENTES_POR_SISTEMA) AS MAX_CLIENTES_POR_SISTEMA,
    MIN(CLIENTES_POR_SISTEMA) AS MIN_CLIENTES_POR_SISTEMA
FROM (
    SELECT 
        CSENOME,
        COUNT(*) AS CLIENTES_POR_SISTEMA
    FROM CLIENSISEXT
    GROUP BY CSENOME
);

-- Verificar sistemas externos disponíveis vs utilizados
SELECT
    sie.SIECODIGO AS SISTEMA_EXTERNO,
    sie.SIENOME AS NOME_SISTEMA_EXTERNO,
    CASE 
        WHEN cse.CSENOME IS NOT NULL THEN 'SIM'
        ELSE 'NÃO'
    END AS TEM_CLIENTES_INTEGRADOS,
    COUNT(DISTINCT cse.CLICODIGO) AS TOTAL_CLIENTES
FROM SISTEMAEXT sie
LEFT JOIN CLIENSISEXT cse ON cse.CSENOME = sie.SIECODIGO
GROUP BY sie.SIECODIGO, sie.SIENOME, cse.CSENOME
ORDER BY TOTAL_CLIENTES DESC;
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

final class FirebirdCliensisext extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CLIENSISEXT';
    
    protected $primaryKey = ['CLICODIGO', 'CSENOME'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'CLICODIGO' => 'integer',
        'CSECODIGO' => 'string',
        'CSENOME' => 'string',
    ];

    // Relacionamento com CLIEN
    public function cliente(): BelongsTo
    {
        return $this->belongsTo(FirebirdClien::class, 'CLICODIGO', 'CLICODIGO');
    }

    // Relacionamento com SISTEMAEXT
    public function sistemaExterno(): BelongsTo
    {
        return $this->belongsTo(FirebirdSistemaext::class, 'CSENOME', 'SIECODIGO');
    }

    // Método para verificar se tem código externo configurado
    public function temCodigoExterno(): bool
    {
        return !empty($this->CSECODIGO);
    }

    // Método para obter URL do web service do sistema externo
    public function getUrlWebService(): ?string
    {
        return $this->sistemaExterno?->SIEURLWEBSERVICE;
    }

    // Scope para filtrar por cliente
    public function scopePorCliente($query, int $clienteCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo);
    }

    // Scope para filtrar por sistema externo
    public function scopePorSistemaExterno($query, string $sistemaCodigo)
    {
        return $query->where('CSENOME', $sistemaCodigo);
    }

    // Scope para filtrar por cliente e sistema externo
    public function scopePorClienteSistema($query, int $clienteCodigo, string $sistemaCodigo)
    {
        return $query->where('CLICODIGO', $clienteCodigo)
            ->where('CSENOME', $sistemaCodigo);
    }

    // Scope para filtrar por código externo
    public function scopePorCodigoExterno($query, string $codigoExterno)
    {
        return $query->where('CSECODIGO', $codigoExterno);
    }

    // Método estático para buscar mapeamento específico
    public static function buscarMapeamento(int $clienteCodigo, string $sistemaCodigo): ?self
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('CSENOME', $sistemaCodigo)
            ->first();
    }

    // Método estático para obter código externo de um cliente
    public static function obterCodigoExterno(int $clienteCodigo, string $sistemaCodigo): ?string
    {
        $mapeamento = self::buscarMapeamento($clienteCodigo, $sistemaCodigo);
        return $mapeamento?->CSECODIGO;
    }

    // Método estático para buscar cliente por código externo
    public static function buscarClientePorCodigoExterno(string $codigoExterno, string $sistemaCodigo): ?int
    {
        $mapeamento = self::where('CSECODIGO', $codigoExterno)
            ->where('CSENOME', $sistemaCodigo)
            ->first();
        return $mapeamento?->CLICODIGO;
    }

    // Método estático para definir mapeamento
    public static function definirMapeamento(int $clienteCodigo, string $sistemaCodigo, string $codigoExterno): bool
    {
        return self::updateOrCreate(
            ['CLICODIGO' => $clienteCodigo, 'CSENOME' => $sistemaCodigo],
            ['CSECODIGO' => $codigoExterno]
        ) !== null;
    }

    // Método estático para remover mapeamento
    public static function removerMapeamento(int $clienteCodigo, string $sistemaCodigo): bool
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('CSENOME', $sistemaCodigo)
            ->delete() > 0;
    }

    // Método estático para obter todos os sistemas externos de um cliente
    public static function getSistemasExternosDoCliente(int $clienteCodigo): \Illuminate\Support\Collection
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->with('sistemaExterno')
            ->get()
            ->pluck('sistemaExterno');
    }

    // Método estático para obter todos os clientes integrados em um sistema
    public static function getClientesDoSistemaExterno(string $sistemaCodigo): \Illuminate\Support\Collection
    {
        return self::where('CSENOME', $sistemaCodigo)
            ->with('cliente')
            ->get()
            ->pluck('cliente');
    }

    // Método estático para verificar se cliente está integrado
    public static function clienteEstaIntegrado(int $clienteCodigo, string $sistemaCodigo): bool
    {
        return self::where('CLICODIGO', $clienteCodigo)
            ->where('CSENOME', $sistemaCodigo)
            ->exists();
    }

    // Método estático para obter estatísticas gerais
    public static function getEstatisticasGerais(): array
    {
        return [
            'total_mapeamentos' => self::count(),
            'total_clientes_integrados' => self::distinct('CLICODIGO')->count(),
            'total_sistemas_com_clientes' => self::distinct('CSENOME')->count(),
            'total_sistemas_disponiveis' => \App\Models\Firebird\FirebirdSistemaext::count(),
        ];
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 2 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se cliente e sistema externo existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Padronização de códigos externos** - Manter formato consistente

### Performance

1. **Tabela muito pequena** - 2 registros, performance excelente
2. **Índices úteis** - Em CLICODIGO e CSENOME para buscas frequentes
3. **Índices compostos** - Para consultas combinadas (cliente + sistema)
4. **Consultas extremamente rápidas** - Volume muito pequeno permite consultas sem otimização complexa

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se entidades relacionadas existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de códigos externos** - Verificar formato e unicidade por sistema

### Manutenção

1. **Revisão periódica** - Verificar mapeamentos não utilizados
2. **Padronização** - Manter estrutura de códigos externos consistente
3. **Documentação** - Documentar significado de cada código externo
4. **Backup regular** - Tabela importante para integrações

### Regras de Negócio

1. **Validação em tempo real** - Verificar se mapeamento existe antes de usar
2. **Consistência** - Garantir que códigos externos estão corretos
3. **Sincronização** - Manter códigos sincronizados entre sistemas
4. **Rastreabilidade** - Manter histórico de mapeamentos

### Observações Especiais

1. **Uso muito limitado** - Apenas 2 registros indicam uso específico ou em fase de implementação
2. **Padrão de integração** - Segue mesmo padrão de outras tabelas *SISEXT
3. **Sincronização bidirecional** - Permite identificar clientes em ambos os sistemas
4. **Sem dependentes** - Tabela folha utilizada para mapeamento e consulta

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

