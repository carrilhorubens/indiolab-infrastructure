# CTRREL - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CTRREL (Controle de Relatórios)
- **Total de Registros**: 278
- **Total de Colunas**: 2
- **Chave Primária**: CTRRELNOME (VARCHAR)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**CTRREL** é uma tabela simples que armazena informações de controle de relatórios, possivelmente contadores ou estatísticas de execução de relatórios. Com **278 registros**, representa diferentes relatórios ou métricas controladas pelo sistema.

Esta tabela funciona como **contador/estatística de relatórios** e permite:
- Armazenar nomes de relatórios ou métricas
- Manter contadores ou quantidades relacionadas
- Rastrear estatísticas de execução de relatórios
- Controlar métricas do sistema

Cada registro representa um relatório ou métrica específica, contendo:
- Nome do relatório/métrica (CTRRELNOME)
- Quantidade/contador (CTRRELQTDE)

O sistema utiliza esta tabela para controlar estatísticas ou contadores relacionados a relatórios ou métricas específicas.

**Observação Importante:** CTRREL é uma tabela simples sem foreign keys, possivelmente usada para armazenar contadores ou estatísticas de relatórios. Com 278 registros, indica múltiplos relatórios ou métricas controladas.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTRRELNOME** 🔑 | VARCHAR(37) | ✓ | Nome do relatório/métrica (PK) |

### Informações
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTRRELQTDE** | INTEGER | | Quantidade/contador |

**Primary Key:** CTRRELNOME

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CTRREL Referencia (0 FKs):

Nenhuma foreign key direta.

---

### CTRREL é Referenciada Por (0 tabelas):

Nenhuma tabela referencia CTRREL diretamente.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Contador de Relatório

```sql
SELECT
    CTRRELNOME AS NOME_RELATORIO,
    CTRRELQTDE AS QUANTIDADE
FROM CTRREL
WHERE CTRRELNOME = ?;
```

---

### 2. Listar Todos os Relatórios

```sql
SELECT
    CTRRELNOME AS NOME_RELATORIO,
    CTRRELQTDE AS QUANTIDADE
FROM CTRREL
ORDER BY CTRRELNOME;
```

---

### 3. Análise de Relatórios por Quantidade

```sql
SELECT
    CTRRELNOME AS NOME_RELATORIO,
    CTRRELQTDE AS QUANTIDADE
FROM CTRREL
WHERE CTRRELQTDE IS NOT NULL
ORDER BY CTRRELQTDE DESC;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção | Tipo |
|--------|-----------|-----------|------|
| **CTRREL** | 278 | 1:1 | **TABELA PRINCIPAL** |

**Interpretação:**
- **278 relatórios/métricas** cadastradas no sistema
- **Tabela independente** - sem relacionamentos formais

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por nome (já coberto pela PK)
-- A PK já fornece índice eficiente

-- Índice 2: Busca por quantidade (consultas de análise)
CREATE INDEX IDX_CTRREL_QUANTIDADE ON CTRREL(CTRRELQTDE)
    WHERE CTRRELQTDE IS NOT NULL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;

final class FirebirdCtrrel extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CTRREL';
    
    protected $primaryKey = 'CTRRELNOME';
    public $incrementing = false;

    protected $casts = [
        'CTRRELNOME' => 'string',
        'CTRRELQTDE' => 'integer',
    ];

    public function incrementar(): void
    {
        $this->CTRRELQTDE = ($this->CTRRELQTDE ?? 0) + 1;
        $this->save();
    }

    public function decrementar(): void
    {
        if ($this->CTRRELQTDE > 0) {
            $this->CTRRELQTDE = $this->CTRRELQTDE - 1;
            $this->save();
        }
    }

    public static function obterOuCriar(string $nomeRelatorio): self
    {
        return self::firstOrCreate(
            ['CTRRELNOME' => $nomeRelatorio],
            ['CTRRELQTDE' => 0]
        );
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

