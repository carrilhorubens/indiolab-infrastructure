# REPARCPAGAR - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: REPARCPAGAR (Reparcelação Pagar)
- **Total de Registros**: 540
- **Total de Colunas**: 3
- **Chave Primária**: EMPCODIGO, PAGCODIGO, REPARCNRDOC (composite)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**REPARCPAGAR** é uma tabela intermediária que armazena informações sobre reparcelação de contas a pagar. Com **540 registros**, esta tabela registra documentos de reparcelação associados a contas a pagar, permitindo rastreamento de parcelas geradas a partir de contas originais.

Esta tabela é essencial para:
- **Reparcelação**: Gerenciar reparcelação de contas a pagar
- **Rastreamento**: Rastrear documentos de reparcelação
- **Relatórios**: Gerar relatórios de reparcelação

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **EMPCODIGO** 🔑 🔗 | INT | Código da empresa (PK, FK → PAGAR) |
| **PAGCODIGO** 🔑 🔗 | INT | Código da conta a pagar (PK, FK → PAGAR) |
| **REPARCNRDOC** 🔑 | VARCHAR(14) | Número do documento de reparcelação (PK) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### PAGAR - Contas a Pagar (FK Obrigatória)
**Volume:** Variável

**Relacionamento:**
```
REPARCPAGAR.PAGCODIGO → PAGAR.PAGCODIGO (N:1)
REPARCPAGAR.EMPCODIGO → PAGAR.EMPCODIGO (N:1)
Constraint: RECEB_REPARCPAGAR
```

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    REPARCPAGAR {
        INT EMPCODIGO PK
        INT PAGCODIGO PK
        VARCHAR REPARCNRDOC PK
    }
    
    PAGAR {
        INT PAGCODIGO PK
        INT EMPCODIGO PK
    }
    
    REPARCPAGAR }o--|| PAGAR : "PAGCODIGO, EMPCODIGO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT EMPCODIGO, PAGCODIGO, REPARCNRDOC
FROM REPARCPAGAR
WHERE EMPCODIGO = ? AND PAGCODIGO = ?;
```

---

## ⚡ Performance e Otimização

### Índices Recomendados

#### 1. Índice Composto na Chave Primária (Já existe implicitamente)
```sql
-- Índice primário já existe implicitamente
```

---

## 📊 Estatísticas e Insights

- **Total de Registros**: 540
- **Reparcelações**: 540 reparcelações de contas a pagar

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

