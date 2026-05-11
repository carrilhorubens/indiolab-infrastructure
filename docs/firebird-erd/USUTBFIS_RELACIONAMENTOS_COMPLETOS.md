# USUTBFIS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: USUTBFIS (Usuário Tabela Fiscal)
- **Total de Registros**: 10.407
- **Total de Colunas**: 2
- **Chave Primária**: USUCODIGO, FISCODIGO (composite)
- **Chaves Estrangeiras**: 2
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**USUTBFIS** é uma tabela intermediária de grande volume que associa usuários a códigos fiscais (TBFIS). Com **10.407 registros**, esta tabela registra quais códigos fiscais cada usuário tem permissão para utilizar.

Esta tabela é essencial para:
- **Permissões Fiscais**: Gerenciar permissões de códigos fiscais por usuário
- **Segurança**: Controlar acesso a códigos fiscais
- **Rastreamento**: Rastrear permissões fiscais por usuário
- **Relatórios**: Gerar relatórios de permissões fiscais

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **USUCODIGO** 🔑 🔗 | INT | Código do usuário (PK, FK → USUARIO) |
| **FISCODIGO** 🔑 🔗 | VARCHAR(14) | Código fiscal (PK, FK → TBFIS) |

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### USUARIO - Usuário (FK Obrigatória)
**Volume:** 297 registros

**Relacionamento:**
```
USUTBFIS.USUCODIGO → USUARIO.USUCODIGO (N:1)
Constraint: FK_USUTBFIS_USUARIO
```

### TBFIS - Tabela Fiscal (FK Obrigatória)
**Volume:** 311 registros

**Relacionamento:**
```
USUTBFIS.FISCODIGO → TBFIS.FISCODIGO (N:1)
Constraint: FK_USUTBFIS_TBFIS
```

**Proporção:** ~35 códigos fiscais por usuário em média (10.407 / 297)

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    USUTBFIS {
        INT USUCODIGO PK
        VARCHAR FISCODIGO PK
    }
    
    USUARIO {
        INT USUCODIGO PK
    }
    
    TBFIS {
        VARCHAR FISCODIGO PK
    }
    
    USUTBFIS }o--|| USUARIO : "USUCODIGO"
    USUTBFIS }o--|| TBFIS : "FISCODIGO"
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT USUCODIGO, FISCODIGO
FROM USUTBFIS
WHERE USUCODIGO = ?;
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

- **Total de Registros**: 10.407
- **Média por Usuário**: ~35 códigos fiscais por usuário

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

