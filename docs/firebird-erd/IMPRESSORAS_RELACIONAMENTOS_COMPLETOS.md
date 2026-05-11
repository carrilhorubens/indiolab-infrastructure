# IMPRESSORAS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: IMPRESSORAS (Impressoras)
- **Total de Registros**: 9
- **Total de Colunas**: 11
- **Chave Primária**: IMPCODIGO (simples)
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 8 (IMPRALMOX, IMPRPCS, IMPRPEDIDORIGEM, IMPRPRODU, IMPRSERVI, IMPRSISEXT, IMPRTPLENTE, IMPRTPPED)
- **Banco de Dados**: Firebird

## 📝 Descrição

**IMPRESSORAS** é uma tabela mestre que armazena configurações de impressoras utilizadas no sistema para impressão de etiquetas, documentos e relatórios. Com **9 registros**, representa diferentes impressoras configuradas no sistema, cada uma com suas características específicas de impressão.

Esta tabela funciona como **catálogo de impressoras** e permite:
- Configurar impressoras do sistema
- Definir características de impressão por impressora
- Suportar diferentes tipos de impressão (texto, PDF, etiquetas)
- Configurar diretórios e localizações de arquivos
- Facilitar gestão de impressão em produção
- Suportar impressão por tipo de documento

Cada registro representa uma impressora específica, contendo:
- Código da impressora (IMPCODIGO)
- Descrição da impressora (IMPDESCRICAO)
- Nome da impressora no sistema (IMPIMPRESSORA)
- Terminal da impressora (IMPTERMINAL)
- Configuração de saldo (IMPSALDO)
- Modo texto (IMPMODOTEXTO)
- Prioridade (IMPPRIORIDADE)
- Tipo de impressão (IMPTIPOIMP)
- Configuração de PDF de pedido (IMPPEDIDPDF)
- Diretório PDF (IMPDIRPDF)
- Localização de pedido work (IMPLOCALIZAPEDIDWORK)

O sistema utiliza esta tabela para configurar e gerenciar impressoras, sendo referenciada por múltiplas tabelas para vincular impressoras a diferentes entidades (almoxarifados, tipos de pedido, produtos, serviços, etc.).

**Observação Importante:** IMPRESSORAS é uma tabela mestre de impressoras. Com 9 registros, indica uso moderado desta funcionalidade. É referenciada por 8 tabelas diferentes para configuração de impressão em diversos contextos.

---

## 🔑 Estrutura de Colunas

### Chave Primária
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IMPCODIGO** 🔑 | INTEGER | ✓ | Código da impressora (PK) |

### Informações da Impressora
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **IMPDESCRICAO** | VARCHAR(37) | ✓ | Descrição da impressora |
| **IMPIMPRESSORA** | VARCHAR(37) | ✓ | Nome da impressora no sistema |
| **IMPTERMINAL** | VARCHAR(14) | ✓ | Terminal da impressora |
| **IMPSALDO** | VARCHAR(14) | ✓ | Configuração de saldo |
| **IMPMODOTEXTO** | VARCHAR(14) | | Modo texto |
| **IMPPRIORIDADE** | NUMERIC(16,2) | | Prioridade da impressora |
| **IMPTIPOIMP** | VARCHAR(37) | | Tipo de impressão |
| **IMPPEDIDPDF** | VARCHAR(14) | | Configuração de PDF de pedido |
| **IMPDIRPDF** | VARCHAR(37) | | Diretório PDF |
| **IMPLOCALIZAPEDIDWORK** | VARCHAR(37) | | Localização de pedido work |

**Primary Key:** IMPCODIGO

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### IMPRESSORAS Referencia (0 FKs):

Nenhuma foreign key direta.

---

### IMPRESSORAS é Referenciada Por (8 tabelas):

#### 1. IMPRALMOX - Impressora x Almoxarifado
**Relacionamento:**
```
IMPRALMOX.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRALMOX
```

**Descrição**: Cada vinculação impressora-almoxarifado está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a almoxarifados para impressão em células de produção.

---

#### 2. IMPRPCS - Impressora x PCS
**Relacionamento:**
```
IMPRPCS.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRPCS
```

**Descrição**: Cada vinculação impressora-PCS está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a PCS para impressão específica.

---

#### 3. IMPRPEDIDORIGEM - Impressora x Pedido Origem
**Relacionamento:**
```
IMPRPEDIDORIGEM.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRPEDIDORIGEM
```

**Descrição**: Cada vinculação impressora-pedido origem está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a tipos de pedido origem para impressão específica.

---

#### 4. IMPRPRODU - Impressora x Produto
**Relacionamento:**
```
IMPRPRODU.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRPRODU
```

**Descrição**: Cada vinculação impressora-produto está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a produtos para impressão de etiquetas específicas.

---

#### 5. IMPRSERVI - Impressora x Serviço
**Relacionamento:**
```
IMPRSERVI.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRSERVI
```

**Descrição**: Cada vinculação impressora-serviço está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a serviços para impressão específica.

---

#### 6. IMPRSISEXT - Impressora x Sistema Externo
**Relacionamento:**
```
IMPRSISEXT.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: FK_IMPRSISEXT_IMPRESSORA
```

**Descrição**: Cada vinculação impressora-sistema externo está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a sistemas externos para impressão específica.

---

#### 7. IMPRTPLENTE - Impressora x Template de Lente
**Relacionamento:**
```
IMPRTPLENTE.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRTPLENTE
```

**Descrição**: Cada vinculação impressora-template de lente está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a templates de lente para impressão específica.

---

#### 8. IMPRTPPED - Impressora x Tipo de Pedido
**Relacionamento:**
```
IMPRTPPED.IMPCODIGO → IMPRESSORAS.IMPCODIGO (N:1)
Constraint: IMPRESSORAS_IMPRTPPED
```

**Descrição**: Cada vinculação impressora-tipo de pedido está relacionada a uma impressora específica.

**Uso:** Vincular impressoras a tipos de pedido para impressão específica.

---

## 💡 Casos de Uso Práticos

### 1. Buscar Impressora

**Objetivo:** Obter informações de uma impressora específica.

```sql
SELECT
    IMPCODIGO,
    IMPDESCRICAO,
    IMPIMPRESSORA,
    IMPTERMINAL,
    IMPTIPOIMP
FROM IMPRESSORAS
WHERE IMPCODIGO = ?;
```

---

### 2. Listar Todas as Impressoras

**Objetivo:** Obter catálogo completo de impressoras.

```sql
SELECT
    IMPCODIGO,
    IMPDESCRICAO,
    IMPIMPRESSORA,
    IMPTIPOIMP
FROM IMPRESSORAS
ORDER BY IMPDESCRICAO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com IMPRESSORAS | Tipo |
|--------|-----------|-------------------------|------|
| **IMPRESSORAS** | 9 | 1:1 | **TABELA PRINCIPAL** |
| IMPRALMOX | 66 | 1:7.33 | Almoxarifados |
| IMPRTPPED | 1 | 1:0.11 | Tipos de pedido |
| IMPRPEDIDORIGEM | 1 | 1:0.11 | Pedidos origem |

**Interpretação:**
- **9 impressoras** cadastradas no sistema
- **Média de 7.33 almoxarifados por impressora** - indica compartilhamento de impressoras

---

## 🚀 Performance e Otimização

### Índices Sugeridos

```sql
-- Índice 1: Busca por descrição (consultas frequentes)
CREATE INDEX IDX_IMPRESSORAS_DESCRICAO ON IMPRESSORAS(IMPDESCRICAO)
    WHERE IMPDESCRICAO IS NOT NULL;

-- Índice 2: Busca por tipo (consultas frequentes)
CREATE INDEX IDX_IMPRESSORAS_TIPO ON IMPRESSORAS(IMPTIPOIMP)
    WHERE IMPTIPOIMP IS NOT NULL;
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

final class FirebirdImpressoras extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'IMPRESSORAS';
    
    protected $primaryKey = 'IMPCODIGO';
    public $incrementing = true;

    protected $casts = [
        'IMPCODIGO' => 'integer',
        'IMPDESCRICAO' => 'string',
        'IMPIMPRESSORA' => 'string',
        'IMPTERMINAL' => 'string',
        'IMPSALDO' => 'string',
        'IMPMODOTEXTO' => 'string',
        'IMPPRIORIDADE' => 'decimal:2',
        'IMPTIPOIMP' => 'string',
        'IMPPEDIDPDF' => 'string',
        'IMPDIRPDF' => 'string',
        'IMPLOCALIZAPEDIDWORK' => 'string',
    ];

    // Relacionamento com IMPRALMOX
    public function almoxarifados(): HasMany
    {
        return $this->hasMany(FirebirdImpralmox::class, 'IMPCODIGO', 'IMPCODIGO');
    }

    // Relacionamento com IMPRTPPED
    public function tiposPedido(): HasMany
    {
        return $this->hasMany(FirebirdImprtpped::class, 'IMPCODIGO', 'IMPCODIGO');
    }
}
```

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

