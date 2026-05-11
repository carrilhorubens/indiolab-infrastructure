# PREVISAO_ENTRADA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: PREVISAO_ENTRADA (Previsão de Entrada)
- **Total de Registros**: 1.068.822
- **Total de Colunas**: 3
- **Chave Primária**: PROCODIGO, EMPCODIGO (composite)
- **Chaves Estrangeiras**: 0 (relacionamentos lógicos)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**PREVISAO_ENTRADA** é uma tabela que armazena previsões de entrada de produtos por empresa. Com **1.068.822 registros**, esta tabela registra valores previstos de entrada de produtos, permitindo planejamento e controle de estoque futuro.

Esta tabela é essencial para:
- **Planejamento**: Planejar entradas futuras de produtos
- **Controle**: Controlar previsões de entrada por produto e empresa
- **Relatórios**: Gerar relatórios de previsões de entrada
- **Análise**: Analisar tendências de entrada

**Contexto de Negócio:**
O sistema precisa planejar entradas futuras de produtos. Esta tabela armazena essas previsões, permitindo planejamento de compras e controle de estoque futuro.

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **PROCODIGO** 🔑 | VARCHAR(14) | Código do produto (PK) |
| **EMPCODIGO** 🔑 | INT | Código da empresa (PK) |
| **PREPRVENTRADA** | NUMERIC(16,2) | Previsão de entrada |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### Relacionamentos Lógicos

### PRODU - Produto (Relacionamento Lógico)
**Volume:** 178.187 registros

**Relacionamento Lógico:**
```
PREVISAO_ENTRADA.PROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição:** Cada registro está relacionado a um produto específico.

---

### EMPRESA - Empresa (Relacionamento Lógico)
**Volume:** 6 registros

**Relacionamento Lógico:**
```
PREVISAO_ENTRADA.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
```

**Descrição:** Cada registro está relacionado a uma empresa específica.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### PRODU → PREMP_INTERNA (Produto x Empresa)
**Volume:** 1.068.822 registros

**Relacionamento:**
```
PREVISAO_ENTRADA → PRODU → PREMP_INTERNA
```

**Descrição:** Através de PRODU, é possível identificar configurações de produto por empresa relacionadas.

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    PREVISAO_ENTRADA {
        VARCHAR PROCODIGO PK
        INT EMPCODIGO PK
        NUMERIC PREPRVENTRADA
    }
    
    PRODU {
        VARCHAR PROCODIGO PK
        VARCHAR PRODESCRICAO
    }
    
    PREMP_INTERNA {
        VARCHAR PROCODIGO PK
        INT EMPCODIGO PK
        NUMERIC PREESTOQUE
    }
    
    PREVISAO_ENTRADA }o--|| PRODU : "PROCODIGO"
    PREVISAO_ENTRADA }o--|| PREMP_INTERNA : "PROCODIGO, EMPCODIGO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT PROCODIGO, EMPCODIGO, PREPRVENTRADA
FROM PREVISAO_ENTRADA
WHERE PROCODIGO = ? AND EMPCODIGO = ?;
```

### Consulta com Informações do Produto

```sql
SELECT 
    pe.*,
    pr.PRODESCRICAO
FROM PREVISAO_ENTRADA pe
INNER JOIN PRODU pr
    ON pe.PROCODIGO = pr.PROCODIGO
WHERE pe.PROCODIGO = ? AND pe.EMPCODIGO = ?;
```

### Consulta de Previsões por Empresa

```sql
SELECT 
    pe.*,
    pr.PRODESCRICAO
FROM PREVISAO_ENTRADA pe
INNER JOIN PRODU pr
    ON pe.PROCODIGO = pr.PROCODIGO
WHERE pe.EMPCODIGO = ?
ORDER BY pe.PREPRVENTRADA DESC;
```

### Consulta de Previsões com Estoque Atual

```sql
SELECT 
    pe.*,
    pi.PREESTOQUE,
    pr.PRODESCRICAO
FROM PREVISAO_ENTRADA pe
INNER JOIN PRODU pr
    ON pe.PROCODIGO = pr.PROCODIGO
LEFT JOIN PREMP_INTERNA pi
    ON pe.PROCODIGO = pi.PROCODIGO
    AND pe.EMPCODIGO = pi.EMPCODIGO
WHERE pe.EMPCODIGO = ?
ORDER BY pe.PREPRVENTRADA DESC;
```

### Inserção de Previsão

```sql
INSERT INTO PREVISAO_ENTRADA (PROCODIGO, EMPCODIGO, PREPRVENTRADA)
VALUES (?, ?, ?);
```

---

## ⚡ Performance e Otimização

### Índices Recomendados

#### 1. Índice Composto na Chave Primária (Já existe implicitamente)
```sql
-- Índice primário já existe implicitamente
```

#### 2. Índice em EMPCODIGO
```sql
CREATE INDEX IDX_PREVISAO_ENTRADA_EMPCODIGO 
ON PREVISAO_ENTRADA (EMPCODIGO);
```

**Justificativa:** Facilita buscas por empresa (muito frequente devido ao volume).

---

## 📊 Estatísticas e Insights

### Volume de Dados

- **Total de Registros**: 1.068.822
- **Tamanho Médio Estimado**: ~30 bytes por registro
- **Tamanho Total Estimado**: ~32 MB

### Distribuição de Dados

- **Previsões**: 1.068.822 previsões de entrada
- **Média por Produto**: ~6 previsões por produto

---

## 🔧 Integração com Código Laravel

### Model Eloquent

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class PrevisaoEntrada extends Model
{
    protected $table = 'PREVISAO_ENTRADA';
    public $incrementing = false;
    public $timestamps = false;

    protected $primaryKey = ['PROCODIGO', 'EMPCODIGO'];

    protected $fillable = [
        'PROCODIGO',
        'EMPCODIGO',
        'PREPRVENTRADA',
    ];

    protected $casts = [
        'PROCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'PREPRVENTRADA' => 'decimal:2',
    ];

    /**
     * Relacionamento com Produto
     */
    public function produto(): BelongsTo
    {
        return $this->belongsTo(Produ::class, 'PROCODIGO', 'PROCODIGO');
    }

    /**
     * Buscar previsão por produto e empresa
     */
    public static function porProdutoEmpresa(string $proCodigo, int $empCodigo)
    {
        return self::where('PROCODIGO', $proCodigo)
            ->where('EMPCODIGO', $empCodigo)
            ->with(['produto'])
            ->first();
    }
}
```

---

## ✅ Boas Práticas

### Design

1. **Chave Composta**: Manter integridade da chave composta
2. **Validação**: Validar PROCODIGO e EMPCODIGO antes de inserir
3. **Valores**: Validar que PREPRVENTRADA seja não negativo

### Performance

1. **Índices**: Usar índices para buscas frequentes (crítico devido ao volume)
2. **Consultas**: Usar eager loading para relacionamentos
3. **Volume**: Considerar particionamento devido ao grande volume

### Segurança

1. **Validação**: Validar valores antes de inserir
2. **Acesso**: Restringir acesso de escrita a usuários autorizados

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

