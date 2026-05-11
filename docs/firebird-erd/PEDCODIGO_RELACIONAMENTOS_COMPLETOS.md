# Documentação da Tabela PEDCODIGO

> Documentação completa gerada automaticamente do banco de dados Firebird
> Data: 10/11/2025 08:22:35

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura da Tabela](#estrutura-da-tabela)
3. [Índices](#índices)
4. [Relacionamentos Nível 1](#relacionamentos-nível-1)
5. [Relacionamentos Nível 2](#relacionamentos-nível-2)
6. [Relacionamentos Nível 3](#relacionamentos-nível-3)
7. [Relacionamentos Inversos](#relacionamentos-inversos)
8. [Diagrama de Relacionamentos](#diagrama-de-relacionamentos)
9. [Queries de Exemplo](#queries-de-exemplo)
10. [Análise Técnica Detalhada](#análise-técnica-detalhada)

---

## 📊 Visão Geral

**Tabela:** `PEDCODIGO`

**Total de Registros:** 8

**Total de Campos:** 4

**Relacionamentos Diretos (Nível 1):** 0

**Relacionamentos Indiretos (Nível 2):** 0

**Relacionamentos Nível 3:** 0

**Tabelas que Referenciam:** 0

---

## 🏗️ Estrutura da Tabela

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| `EMPCODIGO` | INTEGER   | 4 | ✅ Sim | - |
| `PEDDTEMIS` | TIMESTAMP | 8 | ✅ Sim | - |
| `PEDCODIGO` | INTEGER   | 4 | ✅ Sim | - |
| `PEDCONTADOR` | SMALLINT  | 2 | ❌ Não | - |

---

## 🔑 Índices

- **XPEDCODIGO** 🔒 UNIQUE
  - Campos: `PEDDTEMIS`, `EMPCODIGO`

---

## 🔗 Relacionamentos Nível 1

> Tabelas que `PEDCODIGO` referencia diretamente

Nenhum relacionamento direto encontrado.

---

## 🔗 Relacionamentos Nível 2

> Tabelas relacionadas através das tabelas de nível 1

Nenhum relacionamento de nível 2 encontrado.

---

## 🔗 Relacionamentos Nível 3

> Tabelas relacionadas através das tabelas de nível 2

Nenhum relacionamento de nível 3 encontrado.

---

## ⬅️ Relacionamentos Inversos

> Tabelas que referenciam `PEDCODIGO`

Nenhuma tabela referencia esta.

---

## 📊 Diagrama de Relacionamentos

```mermaid
erDiagram
```

---

## 💻 Queries de Exemplo

### Consulta Básica

```sql
SELECT *
FROM PEDCODIGO
WHERE 1=1
ORDER BY 1
FETCH FIRST 100 ROWS ONLY
```

### Estatísticas

```sql
-- Total de registros
SELECT COUNT(*) AS TOTAL
FROM PEDCODIGO
```

---

## 📊 Análise Técnica Detalhada

### Resumo da Estrutura

- **Campos totais**: 4
- **Campos obrigatórios**: 3
- **Campos opcionais**: 1
- **Índices definidos**: 1
- **Volume de dados**: 8 registros

### Tipos de Dados

- **INTEGER  **: 2 campo(s)
- **SMALLINT **: 1 campo(s)
- **TIMESTAMP**: 1 campo(s)

### Complexidade de Relacionamentos

⚠️ **Tabela isolada**: Não possui relacionamentos com outras tabelas.

---

## 📚 Informações Adicionais

### Metadados da Documentação

- **Banco de dados**: Firebird (replica.fb)
- **Servidor**: 10.1.10.55:3050
- **Data da análise**: 10/11/2025 08:22:35
- **Método**: Consulta direta às tabelas de sistema do Firebird
- **Tabelas consultadas**: RDB$RELATIONS, RDB$RELATION_FIELDS, RDB$INDICES, RDB$REF_CONSTRAINTS

---

*Documentação gerada automaticamente a partir do banco de dados Firebird*

*Para dúvidas ou sugestões sobre esta tabela, consulte a equipe de desenvolvimento ou DBA responsável.*
