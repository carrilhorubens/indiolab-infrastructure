# DCTIPERC - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: DCTIPERC (Percentuais de Desconto de ICMS)
- **Total de Registros**: 338
- **Total de Colunas**: 28
- **Chave Primária**: Composta (DCTCODIGO, ICMCODIGO, ICMUF, EMPCODIGO)
- **Chaves Estrangeiras**: 4
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**DCTIPERC** é uma tabela que armazena percentuais e configurações detalhadas de desconto de ICMS por tipo de desconto, ICMS, UF e empresa. Com **338 registros**, representa configurações extensivas de percentuais de desconto de ICMS, permitindo cálculos fiscais precisos e personalizados por empresa e estado.

Esta tabela funciona como **configurador de percentuais de desconto de ICMS** e permite:
- Definir percentuais de desconto de ICMS por tipo de desconto, ICMS, UF e empresa
- Configurar percentuais para diferentes situações (inscrito, consumidor final)
- Controlar percentuais de base de cálculo de ICMS
- Configurar percentuais de substituição tributária
- Controlar percentuais de ICMS diferido
- Configurar percentuais de FCP (Fundo de Combate à Pobreza)
- Suportar percentuais de partilha interestadual e interna
- Controlar situações tributárias específicas

Cada registro representa uma configuração específica de percentuais de desconto de ICMS para uma combinação de tipo de desconto (DCTCODIGO), ICMS (ICMCODIGO), UF (ICMUF) e empresa (EMPCODIGO), contendo:
- Tipo de desconto (DCTCODIGO)
- Código ICMS (ICMCODIGO)
- UF (ICMUF)
- Empresa (EMPCODIGO)
- Percentuais de ICMS (DCPPCICMSINSC, DCPPCICMSCONS)
- Percentuais de base de cálculo (DCPPCBSICMS, DCPPCBSICMSSUB, DCPPCBSICMSCONS)
- Percentuais de substituição tributária (DCPPCICMSSUB, DCPPCIVAICMSSUB, DCPPCFCPSUB)
- Percentuais de ICMS diferido (DCPPCICMSDIFINSC, DCPPCICMSDIFCONS)
- Percentuais de partilha (DCPPCINTERESTPART, DCPPCINTERNAPART, DCPPCFCPPART)
- Situações tributárias (DCPSITTRIB, DCPSITTRIBISE, DCPSITTRIBOUT, DCPSITTRIBSUF)
- Situações tributárias para consumidor final (DCPSITTRIBCONS, DCPSITTRIBISECONS, DCPSITTRIBOUTCONS, DCPSITTRIBSUFCONS)
- Observações (OBSCODIGO, OBSCODIGOCONS)
- Substituição tributária (DCPSUBSTTRIB)

O sistema utiliza esta tabela para calcular descontos de ICMS precisos e personalizados, considerando tipo de desconto, configuração de ICMS, estado e empresa específica.

**Observação Importante:** DCTIPERC estende DCTICMS com percentuais e configurações detalhadas por ICMS, UF e empresa. Com 338 registros e chave primária composta, permite configurações muito específicas de descontos de ICMS.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCTCODIGO** 🔑 🔗 | INTEGER | ✓ | Código do tipo de desconto (PK + FK → DCTICMS) |
| **ICMCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código ICMS (PK + FK → TBICMS) |
| **ICMUF** 🔑 🔗 | VARCHAR(14) | ✓ | UF (PK + FK → TBICMS) |
| **EMPCODIGO** 🔑 🔗 | SMALLINT | ✓ | Código da empresa (PK + FK → TBICMS) |

### Percentuais de ICMS
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPPCICMSINSC** | NUMERIC(16,4) | | Percentual de ICMS para inscrito |
| **DCPPCICMSCONS** | NUMERIC(16,4) | | Percentual de ICMS para consumidor final |

### Percentuais de Base de Cálculo
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPPCBSICMS** | NUMERIC(16,4) | | Percentual de base de cálculo de ICMS |
| **DCPPCBSICMSSUB** | NUMERIC(16,4) | | Percentual de base de cálculo de ICMS substituição tributária |
| **DCPPCBSICMSCONS** | NUMERIC(16,4) | | Percentual de base de cálculo de ICMS para consumidor final |

### Percentuais de Substituição Tributária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPPCICMSSUB** | NUMERIC(16,4) | | Percentual de ICMS substituição tributária |
| **DCPPCIVAICMSSUB** | NUMERIC(16,4) | | Percentual de IVA de ICMS substituição tributária |
| **DCPPCFCPSUB** | NUMERIC(16,4) | | Percentual de FCP substituição tributária |
| **DCPSUBSTTRIB** | VARCHAR(14) | | Substituição tributária |

### Percentuais de ICMS Diferido
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPPCICMSDIFINSC** | NUMERIC(16,4) | | Percentual de ICMS diferido para inscrito |
| **DCPPCICMSDIFCONS** | NUMERIC(16,4) | | Percentual de ICMS diferido para consumidor final |

### Percentuais de Partilha
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPPCINTERESTPART** | NUMERIC(16,4) | | Percentual de partilha interestadual |
| **DCPPCINTERNAPART** | NUMERIC(16,4) | | Percentual de partilha interna |
| **DCPPCFCPPART** | NUMERIC(16,4) | | Percentual de FCP partilha |

### Situações Tributárias
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **DCPSITTRIB** | VARCHAR(14) | | Situação tributária |
| **DCPSITTRIBISE** | VARCHAR(14) | | Situação tributária ISE |
| **DCPSITTRIBOUT** | VARCHAR(14) | | Situação tributária OUT |
| **DCPSITTRIBSUF** | VARCHAR(14) | | Situação tributária SUF |
| **DCPSITTRIBCONS** | VARCHAR(14) | | Situação tributária consumidor final |
| **DCPSITTRIBISECONS** | VARCHAR(14) | | Situação tributária ISE consumidor final |
| **DCPSITTRIBOUTCONS** | VARCHAR(14) | | Situação tributária OUT consumidor final |
| **DCPSITTRIBSUFCONS** | VARCHAR(14) | | Situação tributária SUF consumidor final |

### Relacionamentos
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **OBSCODIGO** | INTEGER | | Código de observação (FK → OBSER) |
| **OBSCODIGOCONS** | INTEGER | | Código de observação consumidor final (FK → OBSER) |

**Primary Key:** (DCTCODIGO, ICMCODIGO, ICMUF, EMPCODIGO)

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### DCTIPERC Referencia (4 FKs):

#### 1. DCTICMS - Tipos de Desconto de ICMS
**Relacionamento:**
```
DCTIPERC.DCTCODIGO → DCTICMS.DCTCODIGO (N:1)
Constraint: DCTICMS_DCTIPERC
```

**Descrição**: Cada configuração está vinculada a um tipo de desconto específico.

---

#### 2. TBICMS - Tabela de ICMS (3 campos da FK composta)
**Relacionamento:**
```
DCTIPERC.ICMCODIGO, DCTIPERC.ICMUF, DCTIPERC.EMPCODIGO → TBICMS.ICMCODIGO, TBICMS.ICMUF, TBICMS.EMPCODIGO (N:1)
Constraint: TBICMS_DCTIPERC
```

**Descrição**: Cada configuração está vinculada a uma configuração específica de ICMS por UF e empresa.

---

### DCTIPERC é Referenciada Por (0 tabelas):

Nenhuma tabela referencia DCTIPERC diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Configuração de Desconto

```sql
SELECT
    DCTCODIGO,
    ICMCODIGO,
    ICMUF,
    EMPCODIGO,
    DCPPCICMSINSC AS PC_ICMS_INSC,
    DCPPCICMSCONS AS PC_ICMS_CONS,
    DCPPCBSICMS AS PC_BS_ICMS,
    DCPPCICMSSUB AS PC_ICMS_SUB
FROM DCTIPERC
WHERE DCTCODIGO = ?
  AND ICMCODIGO = ?
  AND ICMUF = ?
  AND EMPCODIGO = ?;
```

---

### 2. Análise de Descontos por Empresa

```sql
SELECT
    dcp.EMPCODIGO,
    emp.EMPNOMEFANT AS EMPRESA,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(dcp.DCPPCICMSINSC) AS MEDIA_PC_ICMS_INSC,
    AVG(dcp.DCPPCICMSCONS) AS MEDIA_PC_ICMS_CONS
FROM DCTIPERC dcp
INNER JOIN DCTICMS dct ON dct.DCTCODIGO = dcp.DCTCODIGO
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = dcp.EMPCODIGO
WHERE dcp.EMPCODIGO = ?
GROUP BY dcp.EMPCODIGO, emp.EMPNOMEFANT, dct.DCTDESCRICAO
ORDER BY TOTAL_CONFIGURACOES DESC;
```

---

### 3. Análise de Descontos por UF

```sql
SELECT
    dcp.ICMUF,
    uf.UFDESCRICAO AS ESTADO,
    dct.DCTDESCRICAO AS TIPO_DESCONTO,
    COUNT(*) AS TOTAL_CONFIGURACOES,
    AVG(dcp.DCPPCICMSINSC) AS MEDIA_PC_ICMS_INSC
FROM DCTIPERC dcp
INNER JOIN DCTICMS dct ON dct.DCTCODIGO = dcp.DCTCODIGO
LEFT JOIN UF uf ON uf.UFCODIGO = dcp.ICMUF
GROUP BY dcp.ICMUF, uf.UFDESCRICAO, dct.DCTDESCRICAO
ORDER BY dcp.ICMUF, TOTAL_CONFIGURACOES DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **DCTIPERC** | 338 | 1:1 | **TABELA PRINCIPAL** |
| DCTICMS | 4 | 1:84.5 | Tipos de desconto |
| TBICMS | 1.216 | 1:0.28 | Configurações ICMS |

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
CREATE INDEX IDX_DCTIPERC_EMP ON DCTIPERC(EMPCODIGO);
CREATE INDEX IDX_DCTIPERC_UF ON DCTIPERC(ICMUF);
CREATE INDEX IDX_DCTIPERC_TIPO ON DCTIPERC(DCTCODIGO);
CREATE INDEX IDX_DCTIPERC_ICMS ON DCTIPERC(ICMCODIGO);
CREATE INDEX IDX_DCTIPERC_EMP_UF ON DCTIPERC(EMPCODIGO, ICMUF);
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

final class FirebirdDctiperc extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'DCTIPERC';
    
    protected $primaryKey = ['DCTCODIGO', 'ICMCODIGO', 'ICMUF', 'EMPCODIGO'];
    public $incrementing = false;

    protected $casts = [
        'DCTCODIGO' => 'integer',
        'ICMCODIGO' => 'integer',
        'ICMUF' => 'string',
        'EMPCODIGO' => 'integer',
        'DCPPCICMSINSC' => 'decimal:4',
        'DCPPCICMSCONS' => 'decimal:4',
        'DCPPCBSICMS' => 'decimal:4',
        'DCPPCBSICMSSUB' => 'decimal:4',
        'DCPPCICMSSUB' => 'decimal:4',
        'DCPPCIVAICMSSUB' => 'decimal:4',
        'DCPPCICMSDIFINSC' => 'decimal:4',
        'DCPPCICMSDIFCONS' => 'decimal:4',
        'DCPPCINTERESTPART' => 'decimal:4',
        'DCPPCINTERNAPART' => 'decimal:4',
        'DCPPCFCPPART' => 'decimal:4',
        'OBSCODIGO' => 'integer',
        'OBSCODIGOCONS' => 'integer',
    ];

    public function tipoDesconto(): BelongsTo
    {
        return $this->belongsTo(FirebirdDcticms::class, 'DCTCODIGO', 'DCTCODIGO');
    }

    public function tabelaIcms(): BelongsTo
    {
        return $this->belongsTo(FirebirdTbicms::class, ['ICMCODIGO', 'ICMUF', 'EMPCODIGO'], 
                               ['ICMCODIGO', 'ICMUF', 'EMPCODIGO']);
    }

    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCODIGO', $empresaCodigo);
    }

    public function scopePorUF($query, string $uf)
    {
        return $query->where('ICMUF', $uf);
    }

    public function scopePorTipoDesconto($query, int $tipoDescontoCodigo)
    {
        return $query->where('DCTCODIGO', $tipoDescontoCodigo);
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

