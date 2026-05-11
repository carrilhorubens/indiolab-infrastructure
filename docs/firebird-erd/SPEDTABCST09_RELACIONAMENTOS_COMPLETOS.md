# SPEDTABCST09 - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: SPEDTABCST09 (SPED Tabela CST 09)
- **Total de Registros**: 38
- **Total de Colunas**: 3
- **Chave Primária**: SEQ
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**SPEDTABCST09** é uma tabela mestre que armazena códigos CST (Código de Situação Tributária) para SPED Fiscal, especificamente para CST 09. Com **38 registros**, esta tabela define códigos e descrições de CST 09 utilizados na escrituração fiscal digital.

Esta tabela é essencial para:
- **SPED Fiscal**: Gerenciar códigos CST 09 para SPED
- **Fiscal**: Classificar operações fiscais por CST 09
- **Rastreamento**: Rastrear códigos CST 09 disponíveis
- **Relatórios**: Gerar relatórios SPED por CST 09

---

## 🔑 Estrutura de Colunas

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **SEQ** 🔑 | INT | Sequencial único (PK) |
| **CODIGO** | VARCHAR(37) | Código CST 09 |
| **DESCRICAO** | VARCHAR(14) | Descrição do código |

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    SPEDTABCST09 {
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
FROM SPEDTABCST09
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

- **Total de Registros**: 38
- **Códigos CST 09**: 38 códigos CST 09 cadastrados

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

