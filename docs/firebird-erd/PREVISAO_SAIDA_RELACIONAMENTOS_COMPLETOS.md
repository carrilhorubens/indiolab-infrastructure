# PREVISAO_SAIDA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: PREVISAO_SAIDA (Previsão de Saída)
- **Total de Registros**: 1.068.822
- **Total de Colunas**: 3
- **Chave Primária**: PROCODIGO, EMPCODIGO (composite)
- **Chaves Estrangeiras**: 0 (relacionamentos lógicos)
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**PREVISAO_SAIDA** é uma tabela que armazena previsões de saída de produtos por empresa. Com **1.068.822 registros**, esta tabela registra valores previstos de saída de produtos, permitindo planejamento e controle de vendas futuras.

Esta tabela é essencial para:
- **Planejamento de Vendas**: Planejar saídas futuras de produtos
- **Controle**: Controlar previsões de saída por produto e empresa
- **Relatórios**: Gerar relatórios de previsões de saída
- **Análise**: Analisar tendências de vendas

**Contexto de Negócio:**
O sistema precisa planejar saídas futuras de produtos. Esta tabela armazena essas previsões, permitindo planejamento de vendas e controle de estoque futuro.

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **PROCODIGO** 🔑 | VARCHAR(14) | Código do produto (PK) |
| **EMPCODIGO** 🔑 | INT | Código da empresa (PK) |
| **PREPRVSAIDA** | NUMERIC(16,2) | Previsão de saída |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### Relacionamentos Lógicos

### PRODU - Produto (Relacionamento Lógico)
**Volume:** 178.187 registros

**Relacionamento Lógico:**
```
PREVISAO_SAIDA.PROCODIGO → PRODU.PROCODIGO (N:1)
```

**Descrição:** Cada registro está relacionado a um produto específico.

---

### EMPRESA - Empresa (Relacionamento Lógico)
**Volume:** 6 registros

**Relacionamento Lógico:**
```
PREVISAO_SAIDA.EMPCODIGO → EMPRESA.EMPCODIGO (N:1)
```

**Descrição:** Cada registro está relacionado a uma empresa específica.

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    PREVISAO_SAIDA {
        VARCHAR PROCODIGO PK
        INT EMPCODIGO PK
        NUMERIC PREPRVSAIDA
    }
    
    PRODU {
        VARCHAR PROCODIGO PK
        VARCHAR PRODESCRICAO
    }
    
    PREVISAO_SAIDA }o--|| PRODU : "PROCODIGO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT PROCODIGO, EMPCODIGO, PREPRVSAIDA
FROM PREVISAO_SAIDA
WHERE PROCODIGO = ? AND EMPCODIGO = ?;
```

### Consulta com Informações do Produto

```sql
SELECT 
    ps.*,
    pr.PRODESCRICAO
FROM PREVISAO_SAIDA ps
INNER JOIN PRODU pr
    ON ps.PROCODIGO = pr.PROCODIGO
WHERE ps.PROCODIGO = ? AND ps.EMPCODIGO = ?;
```

### Consulta de Previsões por Empresa

```sql
SELECT 
    ps.*,
    pr.PRODESCRICAO
FROM PREVISAO_SAIDA ps
INNER JOIN PRODU pr
    ON ps.PROCODIGO = pr.PROCODIGO
WHERE ps.EMPCODIGO = ?
ORDER BY ps.PREPRVSAIDA DESC;
```

### Consulta de Previsões com Estoque Atual

```sql
SELECT 
    ps.*,
    pi.PREESTOQUE,
    pr.PRODESCRICAO
FROM PREVISAO_SAIDA ps
INNER JOIN PRODU pr
    ON ps.PROCODIGO = pr.PROCODIGO
LEFT JOIN PREMP_INTERNA pi
    ON ps.PROCODIGO = pi.PROCODIGO
    AND ps.EMPCODIGO = pi.EMPCODIGO
WHERE ps.EMPCODIGO = ?
ORDER BY ps.PREPRVSAIDA DESC;
```

### Inserção de Previsão

```sql
INSERT INTO PREVISAO_SAIDA (PROCODIGO, EMPCODIGO, PREPRVSAIDA)
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
CREATE INDEX IDX_PREVISAO_SAIDA_EMPCODIGO 
ON PREVISAO_SAIDA (EMPCODIGO);
```

**Justificativa:** Facilita buscas por empresa (muito frequente devido ao volume).

---

## 📊 Estatísticas e Insights

### Volume de Dados

- **Total de Registros**: 1.068.822
- **Tamanho Médio Estimado**: ~30 bytes por registro
- **Tamanho Total Estimado**: ~32 MB

### Distribuição de Dados

- **Previsões**: 1.068.822 previsões de saída
- **Média por Produto**: ~6 previsões por produto

---

## 🔧 Integração com Código Laravel

### Model Eloquent

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

final class PrevisaoSaida extends Model
{
    protected $table = 'PREVISAO_SAIDA';
    public $incrementing = false;
    public $timestamps = false;

    protected $primaryKey = ['PROCODIGO', 'EMPCODIGO'];

    protected $fillable = [
        'PROCODIGO',
        'EMPCODIGO',
        'PREPRVSAIDA',
    ];

    protected $casts = [
        'PROCODIGO' => 'string',
        'EMPCODIGO' => 'integer',
        'PREPRVSAIDA' => 'decimal:2',
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
3. **Valores**: Validar que PREPRVSAIDA seja não negativo

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

