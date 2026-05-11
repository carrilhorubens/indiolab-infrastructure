# Documentação da Tabela PEDFINALIDADE

> Documentação completa gerada automaticamente do banco de dados Firebird
> Data: 10/11/2025 08:22:46

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

**Tabela:** `PEDFINALIDADE`

**Total de Registros:** 34

**Total de Campos:** 12

**Relacionamentos Diretos (Nível 1):** 0

**Relacionamentos Indiretos (Nível 2):** 0

**Relacionamentos Nível 3:** 0

**Tabelas que Referenciam:** 2

---

## 🏗️ Estrutura da Tabela

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| `PDFCODIGO` | INTEGER   | 4 | ✅ Sim | - |
| `PDFDESCRICAO` | VARCHAR   | 60 | ✅ Sim | - |
| `FISCODIGO1` | CHAR      | 7 | ❌ Não | - |
| `FISCODIGO2` | CHAR      | 7 | ❌ Não | - |
| `FISCODIGO3` | CHAR      | 7 | ❌ Não | - |
| `PDFDESCPREFIS` | CHAR      | 1 | ❌ Não | - |
| `FISCODIGO1S` | CHAR      | 7 | ❌ Não | - |
| `FISCODIGO2S` | CHAR      | 7 | ❌ Não | - |
| `FISCODIGO3S` | CHAR      | 7 | ❌ Não | - |
| `PDFCOMP` | CHAR      | 1 | ❌ Não | - |
| `PDFINIPACIENTE` | CHAR      | 1 | ❌ Não | - |
| `IDADEPAC` | CHAR      | 1 | ❌ Não | - |

---

## 🔑 Índices

- **XPKPEDFINALIDADE** 🔒 UNIQUE
  - Campos: `PDFCODIGO`

---

## 🔗 Relacionamentos Nível 1

> Tabelas que `PEDFINALIDADE` referencia diretamente

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

> Tabelas que referenciam `PEDFINALIDADE`

- `PEDFINALIDADESISEXT` → `PEDFINALIDADE`
- `OBRIGAPARTTIPOFINALIDADE` → `PEDFINALIDADE`

---

## 📊 Diagrama de Relacionamentos

```mermaid
erDiagram
    PEDFINALIDADESISEXT ||--o{ PEDFINALIDADE : "referencia"
    OBRIGAPARTTIPOFINALIDADE ||--o{ PEDFINALIDADE : "referencia"
```

---

## 💻 Queries de Exemplo

### Consulta Básica

```sql
SELECT *
FROM PEDFINALIDADE
WHERE 1=1
ORDER BY 1
FETCH FIRST 100 ROWS ONLY
```

### Estatísticas

```sql
-- Total de registros
SELECT COUNT(*) AS TOTAL
FROM PEDFINALIDADE
```

---

## 📊 Análise Técnica Detalhada

### Resumo da Estrutura

- **Campos totais**: 12
- **Campos obrigatórios**: 2
- **Campos opcionais**: 10
- **Índices definidos**: 1
- **Volume de dados**: 34 registros

### Tipos de Dados

- **CHAR     **: 10 campo(s)
- **INTEGER  **: 1 campo(s)
- **VARCHAR  **: 1 campo(s)

### Complexidade de Relacionamentos

✅ **Baixa complexidade**: Poucos relacionamentos, estrutura simples.

---

## 📚 Informações Adicionais

### Metadados da Documentação

- **Banco de dados**: Firebird (replica.fb)
- **Servidor**: 10.1.10.55:3050
- **Data da análise**: 10/11/2025 08:22:46
- **Método**: Consulta direta às tabelas de sistema do Firebird
- **Tabelas consultadas**: RDB$RELATIONS, RDB$RELATION_FIELDS, RDB$INDICES, RDB$REF_CONSTRAINTS

---

*Documentação gerada automaticamente a partir do banco de dados Firebird*

*Para dúvidas ou sugestões sobre esta tabela, consulte a equipe de desenvolvimento ou DBA responsável.*
