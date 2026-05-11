# SPEDTABCST07 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: SPEDTABCST07 (SPED Tabela CST 07)
- **Total de Registros**: 13
- **Total de Colunas**: 3
- **Chave Primária**: SEQ
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**SPEDTABCST07** é uma tabela mestre que armazena informações sobre códigos de situação tributária (CST) 07 para o SPED Fiscal. Com **13 registros**, esta tabela registra códigos CST 07 com suas descrições para uso no SPED Fiscal.

Esta tabela é essencial para:
- **SPED**: Gerenciar códigos CST 07 para SPED Fiscal
- **Fiscal**: Controlar códigos de situação tributária
- **Rastreamento**: Rastrear códigos cadastrados
- **Relatórios**: Gerar relatórios de códigos CST

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **SEQ** 🔑 | INT | Sequencial (PK) |
| **CODIGO** | VARCHAR(37) | Código CST |
| **DESCRICAO** | VARCHAR(14) | Descrição do CST |

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    SPEDTABCST07 {
        INT SEQ PK
        VARCHAR CODIGO
        VARCHAR DESCRICAO
    }
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT SEQ, CODIGO, DESCRICAO
FROM SPEDTABCST07
WHERE SEQ = ?;
```

---

## ⚡ Performance e Otimização

### Índices Recomendados

#### 1. Índice na Chave Primária (Já existe implicitamente)
```sql
-- Índice primário já existe implicitamente
```

---

## 📊 Estatísticas e Insights

- **Total de Registros**: 13
- **Códigos CST 07**: 13 códigos CST 07 cadastrados

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird
