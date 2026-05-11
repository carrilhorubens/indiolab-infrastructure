# CONTA - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CONTA (Contas Bancárias)
- **Total de Registros**: 55
- **Total de Colunas**: 19
- **Chave Primária**: (BCOCODIGO, CTANRCONTA, EMPCCORR) - Composta
- **Chaves Estrangeiras**: 1
- **Índices**: 0
- **Tabelas Dependentes**: 27 (tabela central de contas bancárias)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CONTA** é uma tabela central que armazena informações sobre contas bancárias do sistema. Com **55 registros**, representa todas as contas bancárias cadastradas, permitindo gestão completa de contas por banco e empresa.

Esta tabela funciona como **cadastro central de contas bancárias** e permite:
- Cadastrar contas bancárias vinculadas a bancos específicos
- Suportar múltiplas contas por banco e empresa
- Controlar saldos iniciais e limites de contas
- Gerenciar informações de agência e gerente
- Controlar fluxo de caixa por conta
- Suportar contas particulares e empresariais
- Controlar fechamento e compensação de contas
- Integrar com sistemas de conciliação bancária

Cada registro representa uma conta bancária específica, contendo:
- Identificação do banco (BCOCODIGO)
- Número da conta (CTANRCONTA)
- Empresa proprietária (EMPCCORR)
- Informações bancárias (agência, gerente)
- Controles financeiros (saldo inicial, limite)
- Configurações de fluxo e fechamento

O sistema utiliza esta tabela como referência central para todas as operações bancárias, sendo referenciada por 27 tabelas diferentes que registram movimentações, extratos, cheques, PIX, e outras operações financeiras.

**Observação Importante:** CONTA é uma tabela central do sistema financeiro, sendo referenciada por 27 tabelas diferentes. Com apenas 55 contas cadastradas, indica uso controlado e organizado de contas bancárias, essencial para gestão financeira multi-empresa e multi-banco.

---

## 🔑 Estrutura de Colunas

### Chave Primária Composta
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **BCOCODIGO** 🔑🔗 | SMALLINT | ✓ | Código do banco (PK + FK → BANCO) |
| **CTANRCONTA** 🔑 | VARCHAR(37) | ✓ | Número da conta bancária (PK) |
| **EMPCCORR** 🔑 | SMALLINT | ✓ | Código da empresa proprietária (PK) |

### Informações Bancárias
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTAAGENCIA** | VARCHAR(37) | | Número da agência bancária |
| **CTAGERENTE** | VARCHAR(37) | | Nome do gerente da conta |
| **CTAORDEM** | SMALLINT | | Ordem de exibição da conta |

### Informações Financeiras
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTASALDOIMPL** | NUMERIC(16,2) | ✓ | Saldo inicial da conta |
| **CTAVRLIMITE** | NUMERIC(16,2) | | Valor limite da conta |
| **CTACODCTB** | VARCHAR(37) | | Código contábil da conta |

### Controle de Fluxo e Fechamento
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTADTIMPL** | DATE | ✓ | Data de implementação da conta |
| **CTADTFECHA** | DATE | ✓ | Data de fechamento da conta |
| **CTAIMPFLUXO** | VARCHAR(14) | ✓ | Flag indicando se importa fluxo de caixa |
| **CTALCCOMPENSADO** | VARCHAR(14) | ✓ | Flag indicando se lança compensado |
| **CTATPCAIXA** | VARCHAR(14) | | Tipo de caixa |
| **CTAAPURADTCAD** | VARCHAR(14) | | Flag de apuração de data de cadastro |
| **CTAHRENCERRAAUTO** | TIMESTAMP | | Hora de encerramento automático |

### Controle de Conta Particular
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTAPARTICULAR** | VARCHAR(14) | ✓ | Flag indicando se é conta particular |

### Validação de Conta e Agência
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CTANRCONTAVALIDA** | VARCHAR(37) | | Número de conta validado |
| **CTANRAGENCIAVALIDA** | VARCHAR(37) | | Número de agência validado |

**Primary Key:** (BCOCODIGO, CTANRCONTA, EMPCCORR)

**Observações sobre Campos:**
- **BCOCODIGO**: Banco ao qual a conta pertence.
- **CTANRCONTA**: Número único da conta bancária.
- **EMPCCORR**: Empresa proprietária da conta.
- **CTASALDOIMPL**: Saldo inicial da conta ao ser cadastrada.
- **CTAVRLIMITE**: Limite de crédito ou saldo mínimo permitido.
- **CTAIMPFLUXO**: Flag que indica se a conta deve aparecer no fluxo de caixa.
- **CTAPARTICULAR**: Flag que indica se é uma conta particular (não empresarial).

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CONTA Referencia (1 FK):

#### 1. BANCO - Bancos
**Relacionamento:**
```
CONTA.BCOCODIGO → BANCO.BCOCODIGO (N:1)
Constraint: BANCO_CONTA
```

**Descrição**: Cada conta está vinculada a um banco específico.

**Informações da Tabela BANCO:**
- **Total:** 108 bancos
- **PK:** BCOCODIGO
- **Colunas:** 7 campos
- **FK Out:** 0
- **FK In:** 28 tabelas

**Uso:** Identificar o banco da conta, obter informações do banco.

---

### CONTA é Referenciada Por (27 tabelas):

#### Categoria 1: Movimentações Bancárias (3 tabelas)

##### 1. CCORR - Movimentações de Conta Corrente
**Volume:** 208.120 registros

**Relacionamento:**
```
CCORR.BCOCODIGO → CONTA.BCOCODIGO (N:1)
CCORR.CTANRCONTA → CONTA.CTANRCONTA (N:1)
CCORR.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_CCORR
```

**Descrição**: Cada movimentação está vinculada a uma conta bancária específica.

**Uso:** Registrar todas as movimentações financeiras da conta.

---

##### 2. BCOEXTRATO - Extratos Bancários
**Volume:** 100 registros

**Relacionamento:**
```
BCOEXTRATO.BCOCODIGO → CONTA.BCOCODIGO (N:1)
BCOEXTRATO.NRCONTA → CONTA.CTANRCONTA (N:1)
BCOEXTRATO.EMPCODIGO → CONTA.EMPCCORR (N:1)
Constraint: BCOEXTRATO_CONTA
```

**Descrição**: Extratos bancários importados estão vinculados a contas específicas.

**Uso:** Armazenar extratos bancários importados por conta.

---

##### 3. BCOCOB - Cobrança Bancária
**Volume:** 11 registros

**Relacionamento:**
```
BCOCOB.BCOCODIGO → CONTA.BCOCODIGO (N:1)
BCOCOB.CTANRCONTA → CONTA.CTANRCONTA (N:1)
BCOCOB.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_BCOCOB
```

**Descrição**: Configurações de cobrança bancária estão vinculadas a contas específicas.

**Uso:** Configurar cobrança bancária por conta.

---

#### Categoria 2: Cheques (2 tabelas)

##### 4. CHEQUE - Cheques
**Volume:** 14.537 registros

**Relacionamento:**
```
CHEQUE.BCOPORTADOR → CONTA.BCOCODIGO (N:1)
CHEQUE.CTANRCONTA → CONTA.CTANRCONTA (N:1)
CHEQUE.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_CHEQUE
```

**Descrição**: Cheques estão vinculados à conta do portador.

**Uso:** Registrar cheques emitidos ou recebidos por conta.

---

##### 5. CHEQUECUST - Cheques em Custódia
**Volume:** 0 registros

**Relacionamento:**
```
CHEQUECUST.BCOCODIGOREPASSE → CONTA.BCOCODIGO (N:1)
CHEQUECUST.BCOCONTAREPASSE → CONTA.CTANRCONTA (N:1)
CHEQUECUST.EMPCONTAREPASSE → CONTA.EMPCCORR (N:1)
Constraint: CHEQUECUST_CONTA
```

**Descrição**: Cheques em custódia podem estar vinculados a contas de repasse.

**Uso:** Registrar cheques em custódia com conta de repasse.

---

#### Categoria 3: Formas de Recebimento (1 tabela)

##### 6. CFORRECEBCONTA - Formas de Recebimento x Conta
**Volume:** 0 registros

**Relacionamento:**
```
CFORRECEBCONTA.BCOCODIGO → CONTA.BCOCODIGO (N:1)
CFORRECEBCONTA.CTANRCONTA → CONTA.CTANRCONTA (N:1)
CFORRECEBCONTA.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: FK_CFORRECEBCONTA_2
```

**Descrição**: Formas de recebimento podem estar vinculadas a contas específicas.

**Uso:** Configurar formas de recebimento por conta.

---

#### Categoria 4: PIX (1 tabela)

##### 7. PIXCONTA - Contas PIX
**Volume:** 0 registros

**Relacionamento:**
```
PIXCONTA.BCOCODIGO → CONTA.BCOCODIGO (N:1)
PIXCONTA.CTANRCONTA → CONTA.CTANRCONTA (N:1)
PIXCONTA.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_PIXCONTA
```

**Descrição**: Contas PIX estão vinculadas a contas bancárias específicas.

**Uso:** Configurar contas PIX por conta bancária.

---

#### Categoria 5: Usuários e Permissões (1 tabela)

##### 8. USUCONTA - Usuários x Contas
**Volume:** 248 registros

**Relacionamento:**
```
USUCONTA.BCOCODIGO → CONTA.BCOCODIGO (N:1)
USUCONTA.CTANRCONTA → CONTA.CTANRCONTA (N:1)
USUCONTA.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_USUCONTA
```

**Descrição**: Usuários podem ter acesso a contas específicas.

**Uso:** Controlar permissões de usuários por conta.

---

#### Categoria 6: Empresa (1 tabela)

##### 9. EMPRESA - Empresas
**Volume:** 6 registros

**Relacionamento:**
```
EMPRESA.BCOCODCTA → CONTA.BCOCODIGO (N:1)
EMPRESA.CTANRCONTA → CONTA.CTANRCONTA (N:1)
EMPRESA.EMPCCORR → CONTA.EMPCCORR (N:1)
Constraint: CONTA_EMPRESA
```

**Descrição**: Empresas podem ter uma conta bancária principal configurada.

**Uso:** Identificar conta bancária principal da empresa.

---

#### Outras Tabelas que Referenciam CONTA (18 tabelas adicionais)

As outras 18 tabelas que referenciam CONTA incluem tabelas relacionadas a:
- Baixas de recebimentos
- Transferências bancárias
- Conciliação bancária
- Outras operações financeiras

**Total de 27 tabelas** referenciam CONTA, demonstrando sua centralidade no sistema financeiro.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via BCOCODIGO → BANCO → Outras Operações Bancárias

**Fluxo:** CONTA → BANCO → Operações Bancárias

**Descrição:** Através do banco, é possível identificar outras operações relacionadas.

**Uso:** Análise de operações por banco.

---

### Via EMPCCORR → EMPRESA → Outras Operações da Empresa

**Fluxo:** CONTA → EMPRESA → Operações da Empresa

**Descrição:** Através da empresa, é possível identificar outras operações relacionadas.

**Uso:** Análise de operações por empresa.

---

### Via CCORR → Movimentações → Clientes e Fornecedores

**Fluxo:** CONTA → CCORR → CLIEN

**Descrição:** Através das movimentações, é possível identificar clientes e fornecedores relacionados.

**Uso:** Análise de movimentações por cliente/fornecedor.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Conta Bancária

**Objetivo:** Obter visão completa de uma conta bancária incluindo informações do banco, empresa e movimentações.

**Fluxo:**
```
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
  ↓
EMPRESA (EMPCCORR)
  ↓
CCORR (BCOCODIGO, CTANRCONTA, EMPCCORR)
```

**Query SQL:**
```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.CTAAGENCIA,
    ct.CTAGERENTE,
    ct.EMPCCORR,
    emp.EMPNOMEFANT AS EMPRESA,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    ct.CTAVRLIMITE AS LIMITE,
    ct.CTAIMPFLUXO AS IMPORTA_FLUXO,
    ct.CTAPARTICULAR AS CONTA_PARTICULAR,
    ct.CTADTIMPL AS DATA_IMPLEMENTACAO,
    ct.CTADTFECHA AS DATA_FECHAMENTO,
    COUNT(cc.CCONRLANCTO) AS TOTAL_MOVIMENTACOES,
    SUM(CASE WHEN cc.CCOENTSAI = 'E' THEN cc.CCOVALOR ELSE 0 END) AS TOTAL_ENTRADAS,
    SUM(CASE WHEN cc.CCOENTSAI = 'S' THEN cc.CCOVALOR ELSE 0 END) AS TOTAL_SAIDAS,
    ct.CTASALDOIMPL + 
        COALESCE(SUM(CASE WHEN cc.CCOENTSAI = 'E' THEN cc.CCOVALOR ELSE -cc.CCOVALOR END), 0) AS SALDO_ATUAL
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
LEFT JOIN CCORR cc ON cc.BCOCODIGO = ct.BCOCODIGO
  AND cc.CTANRCONTA = ct.CTANRCONTA
  AND cc.EMPCCORR = ct.EMPCCORR
WHERE ct.BCOCODIGO = ?
  AND ct.CTANRCONTA = ?
  AND ct.EMPCCORR = ?
GROUP BY ct.BCOCODIGO, bc.BCONOME, ct.CTANRCONTA, ct.CTAAGENCIA, ct.CTAGERENTE, 
         ct.EMPCCORR, emp.EMPNOMEFANT, ct.CTASALDOIMPL, ct.CTAVRLIMITE, 
         ct.CTAIMPFLUXO, ct.CTAPARTICULAR, ct.CTADTIMPL, ct.CTADTFECHA;
```

---

### Exemplo 2: Análise de Contas por Banco

**Objetivo:** Obter todas as contas de um banco específico com informações completas.

**Query SQL:**
```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.CTAAGENCIA,
    ct.EMPCCORR,
    emp.EMPNOMEFANT AS EMPRESA,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    ct.CTAVRLIMITE AS LIMITE,
    ct.CTAIMPFLUXO AS IMPORTA_FLUXO
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
WHERE ct.BCOCODIGO = ?
ORDER BY ct.CTAORDEM, ct.CTANRCONTA;
```

---

### Exemplo 3: Análise de Contas por Empresa

**Objetivo:** Obter todas as contas de uma empresa específica.

**Query SQL:**
```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.CTAAGENCIA,
    ct.CTAGERENTE,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    ct.CTAVRLIMITE AS LIMITE,
    ct.CTAIMPFLUXO AS IMPORTA_FLUXO,
    ct.CTAPARTICULAR AS CONTA_PARTICULAR
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
WHERE ct.EMPCCORR = ?
ORDER BY bc.BCONOME, ct.CTANRCONTA;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Conta Bancária

**Objetivo:** Obter informações de uma conta bancária específica.

```sql
SELECT
    BCOCODIGO,
    CTANRCONTA,
    EMPCCORR,
    CTAAGENCIA,
    CTAGERENTE,
    CTASALDOIMPL AS SALDO_INICIAL,
    CTAVRLIMITE AS LIMITE,
    CTAIMPFLUXO AS IMPORTA_FLUXO,
    CTAPARTICULAR AS CONTA_PARTICULAR
FROM CONTA
WHERE BCOCODIGO = ?
  AND CTANRCONTA = ?
  AND EMPCCORR = ?;
```

---

### 2. Listar Todas as Contas

**Objetivo:** Obter todas as contas bancárias cadastradas.

```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.CTAAGENCIA,
    emp.EMPNOMEFANT AS EMPRESA,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    ct.CTAVRLIMITE AS LIMITE
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
ORDER BY bc.BCONOME, ct.CTANRCONTA;
```

---

### 3. Calcular Saldo Atual da Conta

**Objetivo:** Calcular saldo atual de uma conta considerando movimentações.

```sql
SELECT
    ct.BCOCODIGO,
    ct.CTANRCONTA,
    ct.EMPCCORR,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    COALESCE(SUM(CASE WHEN cc.CCOENTSAI = 'E' THEN cc.CCOVALOR ELSE -cc.CCOVALOR END), 0) AS VARIACAO_SALDO,
    ct.CTASALDOIMPL + 
        COALESCE(SUM(CASE WHEN cc.CCOENTSAI = 'E' THEN cc.CCOVALOR ELSE -cc.CCOVALOR END), 0) AS SALDO_ATUAL
FROM CONTA ct
LEFT JOIN CCORR cc ON cc.BCOCODIGO = ct.BCOCODIGO
  AND cc.CTANRCONTA = ct.CTANRCONTA
  AND cc.EMPCCORR = ct.EMPCCORR
WHERE ct.BCOCODIGO = ?
  AND ct.CTANRCONTA = ?
  AND ct.EMPCCORR = ?
GROUP BY ct.BCOCODIGO, ct.CTANRCONTA, ct.EMPCCORR, ct.CTASALDOIMPL;
```

---

### 4. Análise de Contas com Movimentações

**Objetivo:** Identificar contas com maior volume de movimentações.

```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.EMPCCORR,
    emp.EMPNOMEFANT AS EMPRESA,
    COUNT(cc.CCONRLANCTO) AS TOTAL_MOVIMENTACOES,
    SUM(CASE WHEN cc.CCOENTSAI = 'E' THEN cc.CCOVALOR ELSE 0 END) AS TOTAL_ENTRADAS,
    SUM(CASE WHEN cc.CCOENTSAI = 'S' THEN cc.CCOVALOR ELSE 0 END) AS TOTAL_SAIDAS
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
LEFT JOIN CCORR cc ON cc.BCOCODIGO = ct.BCOCODIGO
  AND cc.CTANRCONTA = ct.CTANRCONTA
  AND cc.EMPCCORR = ct.EMPCCORR
GROUP BY ct.BCOCODIGO, bc.BCONOME, ct.CTANRCONTA, ct.EMPCCORR, emp.EMPNOMEFANT
ORDER BY TOTAL_MOVIMENTACOES DESC;
```

---

### 5. Análise de Contas por Tipo

**Objetivo:** Identificar contas particulares vs empresariais.

```sql
SELECT
    CASE 
        WHEN CTAPARTICULAR = 'S' THEN 'PARTICULAR'
        ELSE 'EMPRESARIAL'
    END AS TIPO_CONTA,
    COUNT(*) AS TOTAL_CONTAS,
    SUM(CTASALDOIMPL) AS SALDO_INICIAL_TOTAL,
    SUM(CTAVRLIMITE) AS LIMITE_TOTAL
FROM CONTA
GROUP BY CASE 
    WHEN CTAPARTICULAR = 'S' THEN 'PARTICULAR'
    ELSE 'EMPRESARIAL'
END;
```

---

### 6. Análise de Contas com Limite

**Objetivo:** Identificar contas que têm limite configurado.

**Query SQL:**
```sql
SELECT
    ct.BCOCODIGO,
    bc.BCONOME AS BANCO,
    ct.CTANRCONTA,
    ct.EMPCCORR,
    emp.EMPNOMEFANT AS EMPRESA,
    ct.CTAVRLIMITE AS LIMITE,
    ct.CTASALDOIMPL AS SALDO_INICIAL,
    CASE 
        WHEN ct.CTASALDOIMPL > ct.CTAVRLIMITE THEN 'ACIMA_DO_LIMITE'
        WHEN ct.CTASALDOIMPL = ct.CTAVRLIMITE THEN 'NO_LIMITE'
        ELSE 'DENTRO_DO_LIMITE'
    END AS STATUS_LIMITE
FROM CONTA ct
INNER JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
INNER JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
WHERE ct.CTAVRLIMITE IS NOT NULL
  AND ct.CTAVRLIMITE > 0
ORDER BY ct.CTAVRLIMITE DESC;
```

---

### 7. Relatório de Contas Bancárias

**Objetivo:** Analisar distribuição completa de contas bancárias.

**Query SQL:**
```sql
SELECT
    COUNT(*) AS TOTAL_CONTAS,
    COUNT(DISTINCT BCOCODIGO) AS TOTAL_BANCOS,
    COUNT(DISTINCT EMPCCORR) AS TOTAL_EMPRESAS,
    SUM(CTASALDOIMPL) AS SALDO_INICIAL_TOTAL,
    SUM(CTAVRLIMITE) AS LIMITE_TOTAL,
    COUNT(CASE WHEN CTAIMPFLUXO = 'S' THEN 1 END) AS CONTAS_COM_FLUXO,
    COUNT(CASE WHEN CTAPARTICULAR = 'S' THEN 1 END) AS CONTAS_PARTICULARES,
    COUNT(CASE WHEN CTADTFECHA IS NOT NULL THEN 1 END) AS CONTAS_FECHADAS
FROM CONTA;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CONTA | Tipo |
|--------|-----------|---------------------|------|
| **CONTA** | 55 | 1:1 | **TABELA PRINCIPAL** |
| BANCO | 108 | 1.96:1 | Bancos (média de 0.51 contas por banco) |
| CCORR | 208.120 | 3.784:1 | Movimentações (média de 3.784 movimentações por conta) |
| CHEQUE | 14.537 | 264.31:1 | Cheques (média de 264 cheques por conta) |
| USUCONTA | 248 | 4.51:1 | Usuários x Contas (média de 4.51 usuários por conta) |
| EMPRESA | 6 | 0.11:1 | Empresas (média de 9.17 contas por empresa) |

**Interpretação:**
- **55 contas bancárias** cadastradas no sistema
- **51% dos bancos** têm pelo menos uma conta cadastrada (55 de 108)
- **Média de 9.17 contas por empresa** - empresas têm múltiplas contas
- **Média de 3.784 movimentações por conta** - uso intensivo de contas
- **Uso extensivo** - indica gestão financeira completa

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CONTA além da chave primária composta.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK composta)
2. **Índice por banco** - Para buscas por banco
3. **Índice por empresa** - Para buscas por empresa
4. **Índice composto** - Para consultas combinadas

### Índices Sugeridos

```sql
-- Índice 1: Busca por banco (consultas frequentes)
CREATE INDEX IDX_CONTA_BANCO ON CONTA(BCOCODIGO);

-- Índice 2: Busca por empresa (consultas frequentes)
CREATE INDEX IDX_CONTA_EMPRESA ON CONTA(EMPCCORR);

-- Índice 3: Busca composta por banco e empresa (consultas frequentes)
CREATE INDEX IDX_CONTA_BANCO_EMP ON CONTA(BCOCODIGO, EMPCCORR);

-- Índice 4: Busca por conta (consultas de validação)
CREATE INDEX IDX_CONTA_NRCONTA ON CONTA(CTANRCONTA);
```

### Observações sobre Volume

- **Tabela pequena** (55 registros) - Performance excelente
- **Consultas frequentes** - Contas são consultadas em todas as operações financeiras
- **Índices úteis** - Em BCOCODIGO e EMPCCORR para buscas frequentes
- **Chave primária composta** - Garante unicidade e performance em buscas por conta completa

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar contas sem banco válido
SELECT ct.*
FROM CONTA ct
LEFT JOIN BANCO bc ON bc.BCOCODIGO = ct.BCOCODIGO
WHERE bc.BCOCODIGO IS NULL;

-- Verificar contas sem empresa válida
SELECT ct.*
FROM CONTA ct
LEFT JOIN EMPRESA emp ON emp.EMPCODIGO = ct.EMPCCORR
WHERE emp.EMPCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CONTA
WHERE BCOCODIGO IS NULL
   OR CTANRCONTA IS NULL
   OR CTANRCONTA = ''
   OR EMPCCORR IS NULL
   OR CTADTIMPL IS NULL
   OR CTASALDOIMPL IS NULL
   OR CTAIMPFLUXO IS NULL
   OR CTAPARTICULAR IS NULL
   OR CTADTFECHA IS NULL
   OR CTALCCOMPENSADO IS NULL;

-- Verificar duplicatas (não deveria existir devido à PK composta)
SELECT BCOCODIGO, CTANRCONTA, EMPCCORR, COUNT(*) AS QTD
FROM CONTA
GROUP BY BCOCODIGO, CTANRCONTA, EMPCCORR
HAVING COUNT(*) > 1;

-- Verificar saldos inválidos
SELECT *
FROM CONTA
WHERE CTASALDOIMPL < 0;

-- Verificar limites inválidos
SELECT *
FROM CONTA
WHERE CTAVRLIMITE < 0;

-- Verificar datas inconsistentes
SELECT *
FROM CONTA
WHERE CTADTFECHA IS NOT NULL
  AND CTADTFECHA < CTADTIMPL;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdConta extends BaseFirebirdModel
{
    protected $connection = 'firebird';
    protected $table = 'CONTA';
    
    protected $primaryKey = ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR'];
    public $incrementing = false;
    protected $keyType = 'string';

    protected $casts = [
        'BCOCODIGO' => 'integer',
        'CTANRCONTA' => 'string',
        'EMPCCORR' => 'integer',
        'CTAAGENCIA' => 'string',
        'CTAGERENTE' => 'string',
        'CTAORDEM' => 'integer',
        'CTASALDOIMPL' => 'decimal:2',
        'CTAVRLIMITE' => 'decimal:2',
        'CTACODCTB' => 'string',
        'CTADTIMPL' => 'date',
        'CTADTFECHA' => 'date',
        'CTAIMPFLUXO' => 'string',
        'CTALCCOMPENSADO' => 'string',
        'CTATPCAIXA' => 'string',
        'CTAAPURADTCAD' => 'string',
        'CTAHRENCERRAAUTO' => 'datetime',
        'CTAPARTICULAR' => 'string',
        'CTANRCONTAVALIDA' => 'string',
        'CTANRAGENCIAVALIDA' => 'string',
    ];

    // Relacionamento com BANCO
    public function banco(): BelongsTo
    {
        return $this->belongsTo(FirebirdBanco::class, 'BCOCODIGO', 'BCOCODIGO');
    }

    // Relacionamento com EMPRESA
    public function empresa(): BelongsTo
    {
        return $this->belongsTo(FirebirdEmpresa::class, 'EMPCCORR', 'EMPCODIGO');
    }

    // Relacionamento com CCORR (movimentações)
    public function movimentacoes(): HasMany
    {
        return $this->hasMany(FirebirdCcorr::class, ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR'], ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR']);
    }

    // Relacionamento com CHEQUE
    public function cheques(): HasMany
    {
        return $this->hasMany(FirebirdCheque::class, ['BCOPORTADOR', 'CTANRCONTA', 'EMPCCORR'], ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR']);
    }

    // Relacionamento com USUCONTA
    public function usuarios(): HasMany
    {
        return $this->hasMany(FirebirdUsuconta::class, ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR'], ['BCOCODIGO', 'CTANRCONTA', 'EMPCCORR']);
    }

    // Método para verificar se importa fluxo
    public function importaFluxo(): bool
    {
        return !empty($this->CTAIMPFLUXO) && strtoupper($this->CTAIMPFLUXO) === 'S';
    }

    // Método para verificar se é conta particular
    public function isParticular(): bool
    {
        return !empty($this->CTAPARTICULAR) && strtoupper($this->CTAPARTICULAR) === 'S';
    }

    // Método para verificar se está fechada
    public function isFechada(): bool
    {
        return !empty($this->CTADTFECHA);
    }

    // Método para calcular saldo atual
    public function calcularSaldoAtual(): float
    {
        $saldoInicial = (float)$this->CTASALDOIMPL;
        
        $variacao = $this->movimentacoes()
            ->selectRaw('SUM(CASE WHEN CCOENTSAI = ? THEN CCOVALOR ELSE -CCOVALOR END) as variacao', ['E'])
            ->value('variacao') ?? 0;
        
        return $saldoInicial + (float)$variacao;
    }

    // Scope para filtrar por banco
    public function scopePorBanco($query, int $bancoCodigo)
    {
        return $query->where('BCOCODIGO', $bancoCodigo);
    }

    // Scope para filtrar por empresa
    public function scopePorEmpresa($query, int $empresaCodigo)
    {
        return $query->where('EMPCCORR', $empresaCodigo);
    }

    // Scope para filtrar contas que importam fluxo
    public function scopeComFluxo($query)
    {
        return $query->where('CTAIMPFLUXO', 'S');
    }

    // Método estático para buscar conta por chave completa
    public static function buscarPorChave(int $bancoCodigo, string $numeroConta, int $empresaCodigo): ?self
    {
        return self::where('BCOCODIGO', $bancoCodigo)
            ->where('CTANRCONTA', $numeroConta)
            ->where('EMPCCORR', $empresaCodigo)
            ->first();
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Chave primária composta** - Sempre usar os 3 campos para identificar unicamente
2. **Validação antes de inserir** - Verificar se banco e empresa existem
3. **Evitar duplicatas** - PK composta garante unicidade
4. **Validação de saldos** - Verificar valores válidos
5. **Validação de datas** - Verificar que data de fechamento é posterior à implementação

### Performance

1. **Tabela pequena** - 55 registros, performance excelente
2. **Índices úteis** - Em BCOCODIGO e EMPCCORR para buscas frequentes
3. **Chave primária composta** - Garante unicidade e performance
4. **Consultas frequentes** - Contas são consultadas em todas as operações financeiras

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se banco e empresa existem
2. **Verificar duplicatas** - PK composta previne duplicatas
3. **Manter consistência** - Garantir que dados referenciados existem
4. **Validação de saldos** - Verificar valores positivos quando apropriado

### Manutenção

1. **Revisão periódica** - Verificar contas não utilizadas
2. **Padronização** - Manter estrutura de números de conta consistente
3. **Documentação** - Documentar significado de cada campo
4. **Backup regular** - Tabela crítica para gestão financeira

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

