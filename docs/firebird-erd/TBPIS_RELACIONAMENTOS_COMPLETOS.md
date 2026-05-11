# TBPIS - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: TBPIS (Tabela PIS)
- **Total de Registros**: 3
- **Total de Colunas**: 21
- **Chave Primária**: PISCODIGO
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 0
- **Banco de Dados**: Firebird

## 📝 Descrição

**TBPIS** é uma tabela mestre que armazena configurações de PIS (Programa de Integração Social). Com apenas **3 registros**, esta tabela define códigos de situação tributária para PIS, incluindo situações para entrada, saída, ISE (Isento), OUT (Outras), SUF (Suframa), devoluções e outras configurações fiscais.

Esta tabela é essencial para:
- **PIS**: Gerenciar configurações de PIS
- **Fiscal**: Armazenar configurações fiscais
- **Rastreamento**: Rastrear códigos de situação tributária
- **Relatórios**: Gerar relatórios fiscais

---

## 🔑 Estrutura de Colunas (Principais)

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| **PISCODIGO** 🔑 | INT | Código do PIS (PK) |
| **PISDESCRICAO** | VARCHAR(37) | Descrição do código |
| **PISSITTRIB** | CHAR(1) | Situação tributária |
| **PISSITTRIBISE** | CHAR(1) | Situação tributária ISE |
| **PISSITTRIBOUT** | CHAR(1) | Situação tributária OUT |
| **PISALIQUOTA** | DECIMAL(18,2) | Alíquota do PIS |
| **PISNATRECCST** | CHAR(1) | Natureza da receita CST |

---

## 🗺️ Diagrama de Relacionamentos

```mermaid
erDiagram
    TBPIS {
        INT PISCODIGO PK
        VARCHAR PISDESCRICAO
        CHAR PISSITTRIB
        CHAR PISSITTRIBISE
        CHAR PISSITTRIBOUT
        DECIMAL PISALIQUOTA
    }
```

---

## 💡 Exemplos de Uso

### Consulta Básica

```sql
SELECT PISCODIGO, PISDESCRICAO, PISSITTRIB, PISSITTRIBISE, PISSITTRIBOUT, PISALIQUOTA
FROM TBPIS
WHERE PISCODIGO = ?;
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

- **Total de Registros**: 3
- **Códigos PIS**: 3 códigos de situação tributária cadastrados

---

**Documentação gerada em**: 2025-01-27

**Banco de dados**: Firebird

