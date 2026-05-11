# Documentação Completa: Tabela CLIEN

**Fonte:** Schema do Banco de Dados Firebird
**Tabela:** CLIEN (Clientes/Fornecedores)
**Versão:** 1.0
**Data:** 2025-11-09

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura da Tabela](#estrutura-da-tabela)
3. [Relacionamentos Formais (Foreign Keys)](#relacionamentos-formais)
4. [Tabelas Dependentes por Categoria](#tabelas-dependentes-por-categoria)
5. [Fluxos de Relacionamento Multi-Nível](#fluxos-multi-nível)
6. [Exemplos de Consultas](#exemplos-de-consultas)
7. [Diagrama de Relacionamentos](#diagrama-de-relacionamentos)
8. [Observações Importantes](#observações-importantes)

---

## 📊 Visão Geral

A tabela **CLIEN** é a **tabela central mais importante** do sistema, armazenando informações completas de **Clientes e Fornecedores** (entidades podem ser ambos simultaneamente).

### Estatísticas

- **Total de Registros:** 9.251
- **Número de Colunas:** 119 (tabela extremamente complexa)
- **Primary Key:** CLICODIGO (simples)
- **Foreign Keys Out:** 0 (não possui FKs formais saindo)
- **Foreign Keys In:** 106 tabelas diferentes (hub central do sistema!)
- **Índices:** 3 (CNPJ/CPF, Nome Fantasia, Razão Social)

### Conceito: Entidade Central

CLIEN é o **coração do sistema**, conectando:
- Vendas (PEDID, NOTAS)
- Financeiro (duplicatas, pagamentos, créditos)
- Logística (endereços, contatos)
- Auditoria (histórico, situações)
- Configurações (preços, descontos, condições)

---

## 🏗️ Estrutura da Tabela

### Primary Key

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **CLICODIGO** | UNKNOWN(8) | Código único do cliente/fornecedor |

### Colunas Detalhadas (119 Total - Agrupadas por Função)

#### 1. Identificação Básica (6 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLICODIGO** | UNKNOWN(8) | ✓ | PK - Código único |
| **CLIRAZSOCIAL** | UNKNOWN(37) | ✓ | Razão Social (índice) |
| **CLINOMEFANT** | UNKNOWN(37) | ✓ | Nome Fantasia (índice) |
| **CLIAPELIDO** | UNKNOWN(37) | | Apelido/nome curto |
| **CLINIT** | UNKNOWN(37) | | NIT (Cadastro Nacional de Obras) |
| **IMPCLI** | UNKNOWN(37) | | Importação cliente |

#### 2. Documentação Fiscal (6 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLICNPJCPF** | UNKNOWN(37) | ✓ | CPF ou CNPJ (índice) |
| **CLIINSCEST** | UNKNOWN(37) | | Inscrição Estadual |
| **CLIINSCMUN** | UNKNOWN(37) | | Inscrição Municipal |
| **CLIRG** | UNKNOWN(37) | | RG (pessoa física) |
| **CLIORGEXP** | UNKNOWN(37) | | Órgão expedidor RG |
| **CLICNAE** | UNKNOWN(37) | | CNAE (atividade econômica) |

#### 3. Classificação (8 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLICLIENTE** | UNKNOWN(14) | ✓ | Flag: é cliente? (S/N) |
| **CLIFORNEC** | UNKNOWN(14) | ✓ | Flag: é fornecedor? (S/N) |
| **CLIFJ** | UNKNOWN(14) | ✓ | Tipo: Física (F) ou Jurídica (J) |
| **CLISTATUS** | UNKNOWN(14) | | Status/situação atual |
| **CLISEXO** | UNKNOWN(14) | | Sexo (pessoa física) |
| **CLIFAZENDA** | UNKNOWN(14) | | É fazenda/produtor rural? |
| **CLIREGFED** | UNKNOWN(14) | | Regime federal |
| **CLIINDFINAL** | UNKNOWN(37) | ✓ | Consumidor final (N) |

#### 4. Datas (5 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLIDTCAD** | UNKNOWN(35) | ✓ | Data de cadastro |
| **CLIDTNASCTO** | UNKNOWN(35) | | Data de nascimento |
| **CLIDTULTCONS** | UNKNOWN(35) | | Data última consulta |
| **CLIDTLIBVENDA** | UNKNOWN(35) | | Data liberação venda |
| **CLIULTALTERACAO** | UNKNOWN(35) | | Data última alteração |

#### 5. Financeiro - Crédito e Limites (5 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLILIMCRED** | UNKNOWN(27) | | Limite de crédito |
| **CLIRENDA** | UNKNOWN(27) | | Renda mensal |
| **CLIDIASATRASO** | UNKNOWN(7) | | Dias em atraso permitidos |
| **CLIPERCFATPROD** | UNKNOWN(16) | | % faturamento produtos |
| **CLIPERCFATSER** | UNKNOWN(16) | | % faturamento serviços |

#### 6. Financeiro - Descontos e Comissões (7 campos)

| Campo | Tipo | Not Null | Descrição |
|-------|------|----------|-----------|
| **CLIPCDESCTO** | UNKNOWN(27) | | % desconto geral |
| **CLIPCDESCTOSER** | UNKNOWN(27) | | % desconto serviços |
| **CLIPCDESCPRODU** | UNKNOWN(16) | | % desconto produtos |
| **CLIPCDESCSERVI** | UNKNOWN(16) | | % desconto serviços (alt) |
| **CLIPCOVENDAKG** | UNKNOWN(27) | | Preço venda por kg |
| **CLIPCCOMIS** | UNKNOWN(16) | | % comissão |
| **CLIPCSIMPLESNAC** | UNKNOWN(16) | | % Simples Nacional |

#### 7. Referências a Outras Tabelas (25 campos - implícitas)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **TBFCODIGO** | UNKNOWN(7) | Tabela de frete |
| **TRACODIGO** | UNKNOWN(8) | Transportadora |
| **FUNCODIGO** | UNKNOWN(8) | Vendedor/funcionário 1 |
| **FUNCODIGO2** | UNKNOWN(8) | Vendedor/funcionário 2 |
| **DESCODIGO** | UNKNOWN(7) | Desconto |
| **OBSCODIGO** | UNKNOWN(8) | Observação padrão |
| **OBSCODIGO_FORNE** | UNKNOWN(8) | Observação fornecedor |
| **PROCODIGO** | UNKNOWN(7) | Profissão |
| **ECVCODIGO** | UNKNOWN(7) | Estado civil |
| **PGTCODIGO** | UNKNOWN(7) | Pagamento |
| **BCOCODIGO** | UNKNOWN(7) | Banco |
| **BCOCODIGOCLA** | UNKNOWN(8) | Banco CLA |
| **FORCODIGO** | UNKNOWN(8) | Formulário |
| **CUSCODIGO** | UNKNOWN(14) | Custo |
| **COBCODIGO** | UNKNOWN(14) | Cobrança |
| **TBPCODIGO** | UNKNOWN(7) | Tabela de preço |
| **TPACODIGO** | UNKNOWN(7) | Tipo aprovação |
| **DCTCODIGO** | UNKNOWN(8) | Desconto entrada |
| **DCTCODIGOSAI** | UNKNOWN(8) | Desconto saída |
| **GCLCODIGO** | UNKNOWN(8) | Grupo cliente |
| **PCSCODIGO** | UNKNOWN(8) | ? |
| **PCFCODIGO** | UNKNOWN(8) | ? |
| **CATCODIGO** | UNKNOWN(7) | Categoria |
| **CLICODDEBFOR** | UNKNOWN(8) | Débito fornecedor |
| **CLIAGENCIA** | UNKNOWN(14) | Agência |

#### 8. Configurações de Frete e Logística (7 campos)

| Campo | Tipo | Not Null | Default | Descrição |
|-------|------|----------|---------|-----------|
| **CLITPFRETE** | UNKNOWN(14) | | | Tipo frete (CIF/FOB) |
| **CLITPFRETEENT** | UNKNOWN(14) | | | Tipo frete entrada |
| **CLINFECALCFRETE** | UNKNOWN(14) | ✓ | 'V' | NF-e calc frete |
| **CLINFCALCFRETE** | UNKNOWN(14) | ✓ | 'V' | NF calc frete |
| **CLINFECALCDESPESA** | UNKNOWN(14) | ✓ | 'V' | NF-e calc despesa |
| **CLINFCALCDESPESA** | UNKNOWN(14) | ✓ | 'V' | NF calc despesa |
| **CLINFECALCSEGURO** | UNKNOWN(14) | ✓ | 'V' | NF-e calc seguro |
| **CLINFCALCSEGURO** | UNKNOWN(14) | ✓ | 'V' | NF calc seguro |
| **CLIPARCELAFRETEENTRADA** | UNKNOWN(37) | | | Parcela frete entrada |

#### 9. Configurações de Nota Fiscal (10 campos)

| Campo | Tipo | Not Null | Default | Descrição |
|-------|------|----------|---------|-----------|
| **CLICALCNFE** | UNKNOWN(14) | ✓ | | Calcular NF-e |
| **CLIFATURA** | UNKNOWN(14) | ✓ | | Fatura |
| **CLITBPE** | UNKNOWN(14) | ✓ | | Tabela preço especial |
| **CLITBPEVENCTO** | UNKNOWN(14) | | | Tabela preço vencto |
| **CLINFECALCDESCONTO** | UNKNOWN(14) | | | NF-e calc desconto |
| **CLICALCDIFICMSST** | UNKNOWN(14) | | 'N' | Calc diferencial ICMS ST |
| **CLIOBRIGACONFXML** | UNKNOWN(14) | | | Obriga conf. XML |
| **CLIIMPCODORIGINAL** | UNKNOWN(14) | | | Imprime código original |
| **CLIDIFALBASEDUPLA** | UNKNOWN(14) | | 'N' | Dif. alíquota base dupla |
| **CLICALCISSRET** | UNKNOWN(14) | | | Calcular ISS retido |
| **CLICALCISSRETENT** | UNKNOWN(14) | | | Calc ISS ret entrada |

#### 10. Regras de Negócio (12 campos)

| Campo | Tipo | Default | Descrição |
|-------|------|---------|-----------|
| **CLIETIQUETA** | UNKNOWN(14) | | Imprime etiqueta |
| **CLISEPFATPROSER** | UNKNOWN(14) | | Separa fat. prod/serv |
| **CLIOBRIGAORDCOMPRA** | UNKNOWN(14) | | Obriga ordem compra |
| **CLIOBRIGAFATTODOSPD** | UNKNOWN(14) | 'N' | Obriga fat. todos PD |
| **CLIGERANFPORPD** | UNKNOWN(14) | 'N' | Gera NF por pedido |
| **CLIGRFATURA** | UNKNOWN(14) | 'N' | Gera fatura |
| **CLIREMTERCEIRO** | UNKNOWN(14) | | Remessa terceiros |
| **CLIBLOQPEDFOCONF** | UNKNOWN(14) | | Bloqueia ped. fora conf |
| **CLIPONTOVENDA** | UNKNOWN(14) | | Ponto de venda |
| **CLIABATECREDNF** | UNKNOWN(14) | | Abate créd. em NF |
| **CLIABATECREDREC** | UNKNOWN(14) | | Abate créd. recibo |
| **CLIAGRUPITEDEVCOMPRA** | UNKNOWN(14) | 'N' | Agrupar itens dev compra |

#### 11. Comunicação e Acesso (7 campos)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **CLIMAIL** | UNKNOWN(14) | Recebe email? |
| **CLISENHA** | UNKNOWN(37) | Senha acesso |
| **CLISENHACLA** | UNKNOWN(37) | Senha CLA |
| **CLIPERDESCLA** | UNKNOWN(16) | % desc CLA |
| **CLIEMIRECCLA** | UNKNOWN(14) | Emite recibo CLA |
| **CLIEMIDUPCLA** | UNKNOWN(14) | Emite duplicata CLA |
| **CLIPERDESCLAASS** | UNKNOWN(16) | % desc CLA assinatura |

#### 12. Pagamento Web/E-commerce (8 campos)

| Campo | Tipo | Default | Descrição |
|-------|------|---------|-----------|
| **CLIPAGWEBFECHAMENTO** | UNKNOWN(14) | 'S' | Pag web fechamento |
| **CLIPAGWEBCARTCREDITO** | UNKNOWN(14) | 'N' | Pag web cartão créd |
| **CLIPAGWEBCARTDEBITO** | UNKNOWN(14) | 'N' | Pag web cartão déb |
| **CLIPAGWEBBLU** | UNKNOWN(14) | 'N' | Pag web Blu |
| **CLIPAGWEBPIX** | UNKNOWN(14) | 'N' | Pag web PIX |
| **CLIPAGWEBCRED** | UNKNOWN(14) | | Pag web crédito |
| **CLIPAGWEBEXP** | UNKNOWN(37) | 'N' | Pag web express |

#### 13. Contabilidade e Impressões (4 campos)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| **CLICODCTB** | UNKNOWN(37) | Código contábil |
| **CLIIMPPRECO** | UNKNOWN(14) | Imprime preço |
| **CLIOBS** | UNKNOWN(261) | Observações gerais |

---

## 🔗 Relacionamentos Formais (Foreign Keys)

### FK Out: Tabelas Referenciadas por CLIEN

❌ **CLIEN NÃO possui Foreign Keys formais** saindo (design sem constraints).

**Observação:** CLIEN possui 25+ campos que LOGICAMENTE referenciam outras tabelas, mas SEM constraint FK formal no schema.

### FK In: Tabelas que Referenciam CLIEN

✅ **106 TABELAS** diferentes referenciam CLIEN formalmente!

---

## 📑 Tabelas Dependentes por Categoria

### Categoria 1: VENDAS E PEDIDOS (10 tabelas)

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| **PEDID** | 3.099.038 | **Pedidos de venda** |
| **ACOPED** | 3.049.954 | **Acompanhamento de pedidos** |
| **ORÇA** | ? | Orçamentos |
| **CLIPRO** | ? | Produtos por cliente |
| **CLICOMBPROPRO** | ? | Combos produto-produto |
| **CLICOMBPROSER** | ? | Combos produto-serviço |
| **CTPPRO** | ? | Cadastro tabela preço produto |
| **CTPCOMBPROPRO** | ? | Combos preço |
| **PRECO** | ? | Preços |
| **TABDES** | ? | Tabela descontos |

### Categoria 2: NOTAS FISCAIS E DOCUMENTOS FISCAIS (8 tabelas)

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| **NOTAS** | 1.205.926 | **Notas fiscais** |
| **BLOCO1200** | ? | Sped Fiscal - Bloco 1200 |
| **BLOCO1600** | ? | Sped Fiscal - Bloco 1600 |
| **BLOCO1601** | ? | Sped Fiscal - Bloco 1601 |
| **CAIXA** | ? | Caixa |
| **CAIXAP** | ? | Caixa parcelas |
| **CHEQUE** | ? | Cheques |
| **LTAR** | ? | Livro termos |

### Categoria 3: FINANCEIRO - CONTAS A RECEBER (12 tabelas)

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| **CCORR** | ? | Conta corrente |
| **CREDCLI** | ? | **Créditos de cliente** |
| **DVACLI** | ? | Devoluções |
| **BENSCLI** | ? | Bens do cliente |
| **PAGWEB** | ? | Pagamentos web |
| **RECIBOS** | ? | Recibos |
| **CLIFAIXAFAT** | 46 | Cliente x faixa faturamento |
| **ACGECLI** | ? | Agendamento cobrança cliente |
| **AGRECEBP** | ? | Agendamento recebimento |
| **DUPLACLI** | ? | Duplicatas |
| **TITDUPXCLI** | ? | Títulos duplicata x cliente |
| **TITRECXCLI** | ? | Títulos receber x cliente |

### Categoria 4: CADASTRO E INFORMAÇÕES (15 tabelas)

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| **ENDCLI** | ? | **Endereços do cliente** |
| **CLINET** | 2.868 | **Contatos** (telefone, email) |
| **CLIENINFO** | 6.679 | **Informações adicionais** (chave-valor) |
| **CLIENSISEXT** | 2 | Integração sistemas externos |
| **CLIENANEXOS** | 0 | Anexos/documentos |
| **CLIOBS** | ? | Observações |
| **CLICONV** | ? | Convênios |
| **CLICONVERSAO** | ? | Conversões |
| **CLIEMP** | ? | Cliente x empresa |
| **CLIEMPCMP** | ? | Cliente empresa complemento |
| **CLIFORCTB** | 12.901 | **Cliente x contabilidade** |
| **CLIALMOX** | ? | Cliente x almoxarifado |
| **ATVCLI** | ? | Atividades cliente |
| **ALNCLI** | ? | Alertas cliente |
| **ARMFOR** | ? | Armações fornecedor |

### Categoria 5: HISTÓRICO E AUDITORIA (5 tabelas)

| Tabela | Registros | Descrição |
|--------|-----------|-----------|
| **SITCLI** | 11.256 | **Histórico de situações** |
| **AGCLI** | ? | Agendamentos cliente |
| **ROTINA** | ? | Rotinas/processos |
| **CLILINK** | 32 | Links externos |
| **CLIAUTDOWNLOADXML** | ? | Download automático XML |

### Categoria 6: ESPECIALIDADES DO NEGÓCIO (10+ tabelas)

| Tabela | Descrição |
|--------|-----------|
| **APVCLITPLENTE** | Aprovação cliente tipo lente |
| **CARTCLA** | Cartão CLA |
| **LTEPCLI** | Lote pedido cliente |
| **MALADIRETA** | Mala direta |
| **MALXCLI** | Mala direta x cliente |
| **REFCLI** | Referências cliente |
| **TITCNFXCLI** | Título conf. NF x cliente |
| **Outras 50+ tabelas** | Funcionalidades específicas |

**Observação:** Devido ao grande número (106 tabelas), listamos as principais categorias. A tabela completa está disponível no schema do banco.

---

## 🌊 Fluxos de Relacionamento Multi-Nível

### Fluxo 1: Jornada Completa de Venda

```
1. CLIENTE CADASTRADO
   CLIEN (cadastro básico)
       ↓
   ENDCLI (endereços)
       ↓
   CLINET (contatos)
       ↓
   SITCLI (situação inicial: "Ativo")

2. VENDA REALIZADA
   CLIEN
       ↓ (CLICODIGO)
   PEDID (pedido de venda - 3,1M registros)
       ↓
   PDPRD (produtos do pedido)
       ↓
   ACOPED (acompanhamento do pedido - 3M registros)

3. FATURAMENTO
   PEDID
       ↓
   PDNF (pedido x nota fiscal)
       ↓
   NOTAS (nota fiscal - 1,2M registros)
       ↓
   NFEPRO (produtos da NF-e)

4. FINANCEIRO
   NOTAS
       ↓
   CCORR (conta corrente)
       ↓
   CREDCLI ou Duplicatas
```

### Fluxo 2: Gestão de Crédito

```
CLIEN
    ↓ (CLILIMCRED - limite)
CREDCLI (créditos disponíveis)
    ↓
PEDID (valida crédito antes de vender)
    ↓ (inadimplência?)
SITCLI (muda situação para "Bloqueado")
    ↓
CLIEN.CLISTATUS (atualizado)
```

### Fluxo 3: Histórico de Relacionamento

```
CLIEN (cliente)
    ↓
SITCLI (mudanças de situação ao longo do tempo)
    ↓
AGCLI (agendamentos e follow-ups)
    ↓
ATVCLI (atividades realizadas)
    ↓
CLIOBS (observações registradas)
```

### Fluxo 4: Precificação Personalizada

```
CLIEN
    ↓ (TBPCODIGO)
TABPRECLI (tabela de preço do cliente)
    ↓
CLIPRO (produtos específicos do cliente)
    ↓
PRECO (preços personalizados)
    ↓
PEDID (aplica preços ao fazer pedido)
```

### Fluxo 5: Integração Multi-Empresa

```
CLIEN (cadastro único)
    ↓
CLIEMP (cliente x empresa)
    ↓
CLIFORCTB (contabilidade por empresa)
    ↓
PEDID (pedidos por empresa - EMPCODIGO)
    ↓
NOTAS (notas por empresa)
```

---

## 💡 Exemplos de Consultas

### 1. Informações Completas de um Cliente

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLINOMEFANT,
    C.CLICNPJCPF,
    C.CLICLIENTE,
    C.CLIFORNEC,
    C.CLISTATUS,
    C.CLILIMCRED,
    C.CLIDTCAD,
    C.CLIDTULTCONS
FROM CLIEN C
WHERE C.CLICODIGO = 12345;
```

### 2. Clientes Ativos com Limite de Crédito

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLILIMCRED AS LIMITE_CREDITO,
    C.CLIPCDESCTO AS DESCONTO_PADRAO
FROM CLIEN C
WHERE C.CLICLIENTE = 'S'
  AND C.CLISTATUS = 'A'
  AND C.CLILIMCRED > 0
ORDER BY C.CLILIMCRED DESC
LIMIT 100;
```

### 3. Total de Vendas por Cliente (último ano)

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    COUNT(DISTINCT P.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(P.PEDVRTOTAL) AS FATURAMENTO_TOTAL,
    MAX(P.PEDDTEMIS) AS ULTIMA_COMPRA
FROM CLIEN C
INNER JOIN PEDID P
    ON C.CLICODIGO = P.CLICODIGO
WHERE P.PEDDTEMIS >= DATEADD(YEAR, -1, CURRENT_DATE)
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL
ORDER BY FATURAMENTO_TOTAL DESC
LIMIT 50;
```

### 4. Clientes com Situação e Histórico

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    S.SITDESCRICAO AS SITUACAO_ATUAL,
    SC.SITDATA AS DATA_ULTIMA_MUDANCA,
    SC.SITHISTO AS MOTIVO,
    U.USUNOME AS RESPONSAVEL
FROM CLIEN C
LEFT JOIN SITCLI SC
    ON C.CLICODIGO = SC.CLICODIGO
    AND SC.SITDATA = (
        SELECT MAX(SC2.SITDATA)
        FROM SITCLI SC2
        WHERE SC2.CLICODIGO = C.CLICODIGO
    )
LEFT JOIN SITUACAO S
    ON SC.SITCODIGO = S.SITCODIGO
LEFT JOIN USUARIO U
    ON SC.USUCODIGO = U.USUCODIGO
WHERE C.CLICLIENTE = 'S'
ORDER BY C.CLIRAZSOCIAL;
```

### 5. Clientes com Endereços e Contatos

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    E.ENDLOGRADOURO,
    E.ENDCIDADE,
    E.ENDESTADO,
    T.NETENDERECO AS TELEFONE,
    T.NETTIPO AS TIPO_CONTATO
FROM CLIEN C
LEFT JOIN ENDCLI E
    ON C.CLICODIGO = E.CLICODIGO
    AND E.ENDTIPO = 'P'  -- Principal
LEFT JOIN CLINET T
    ON C.CLICODIGO = T.CLICODIGO
WHERE C.CLICODIGO = 12345;
```

### 6. Análise de Inadimplência

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLIDIASATRASO AS DIAS_ATRASO_PERMITIDO,
    COUNT(D.ID_DUPLICATA) AS TOTAL_DUPLICATAS_ABERTAS,
    SUM(D.DUPVLRPENDENTE) AS VALOR_EM_ABERTO,
    MIN(D.DUPDTVENC) AS VENCIMENTO_MAIS_ANTIGO,
    DATEDIFF(DAY, MIN(D.DUPDTVENC), CURRENT_DATE) AS DIAS_VENCIDO
FROM CLIEN C
INNER JOIN DUPLACLI D
    ON C.CLICODIGO = D.CLICODIGO
WHERE D.DUPSITUACAO = 'A'  -- Aberta
  AND D.DUPDTVENC < CURRENT_DATE  -- Vencida
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL, C.CLIDIASATRASO
HAVING SUM(D.DUPVLRPENDENTE) > 1000
ORDER BY VALOR_EM_ABERTO DESC;
```

### 7. Top Clientes por Categoria

```sql
SELECT
    CAT.CATDESCRICAO AS CATEGORIA,
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    COUNT(P.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(P.PEDVRTOTAL) AS FATURAMENTO
FROM CLIEN C
LEFT JOIN CATEGORIA CAT
    ON C.CATCODIGO = CAT.CATCODIGO
INNER JOIN PEDID P
    ON C.CLICODIGO = P.CLICODIGO
WHERE P.PEDDTEMIS >= '2025-01-01'
GROUP BY CAT.CATDESCRICAO, C.CLICODIGO, C.CLIRAZSOCIAL
ORDER BY CAT.CATDESCRICAO, FATURAMENTO DESC;
```

### 8. Clientes Inativos (sem compras em 6 meses)

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLIDTULTCONS AS ULTIMA_CONSULTA,
    MAX(P.PEDDTEMIS) AS ULTIMA_COMPRA,
    DATEDIFF(MONTH, MAX(P.PEDDTEMIS), CURRENT_DATE) AS MESES_SEM_COMPRAR
FROM CLIEN C
LEFT JOIN PEDID P
    ON C.CLICODIGO = P.CLICODIGO
WHERE C.CLICLIENTE = 'S'
  AND C.CLISTATUS = 'A'
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL, C.CLIDTULTCONS
HAVING MAX(P.PEDDTEMIS) < DATEADD(MONTH, -6, CURRENT_DATE)
   OR MAX(P.PEDDTEMIS) IS NULL
ORDER BY ULTIMA_COMPRA DESC NULLS LAST;
```

### 9. Clientes com Notas Fiscais Emitidas

```sql
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    COUNT(DISTINCT N.NFCODIGO) AS TOTAL_NOTAS,
    SUM(N.NFVRTOTAL) AS VALOR_TOTAL_NF,
    MIN(N.NFDTEMIS) AS PRIMEIRA_NF,
    MAX(N.NFDTEMIS) AS ULTIMA_NF
FROM CLIEN C
INNER JOIN NOTAS N
    ON C.CLICODIGO = N.CLICODIGO
WHERE N.NFORIGEM = 'P'  -- Pedido
  AND N.NFSIT = 'N'  -- Normal (não cancelada)
  AND EXTRACT(YEAR FROM N.NFDTEMIS) = 2025
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL
ORDER BY VALOR_TOTAL_NF DESC
LIMIT 20;
```

### 10. Clientes Pessoa Física vs Jurídica

```sql
SELECT
    C.CLIFJ AS TIPO,
    CASE C.CLIFJ
        WHEN 'F' THEN 'Pessoa Física'
        WHEN 'J' THEN 'Pessoa Jurídica'
        ELSE 'Não Definido'
    END AS DESCRICAO,
    COUNT(*) AS TOTAL_CLIENTES,
    SUM(CASE WHEN C.CLICLIENTE = 'S' THEN 1 ELSE 0 END) AS SÃO_CLIENTES,
    SUM(CASE WHEN C.CLIFORNEC = 'S' THEN 1 ELSE 0 END) AS SÃO_FORNECEDORES
FROM CLIEN C
GROUP BY C.CLIFJ
ORDER BY TOTAL_CLIENTES DESC;
```

---

## 📊 Diagrama de Relacionamentos (Principais)

```mermaid
erDiagram
    CLIEN {
        UNKNOWN8 CLICODIGO PK
        UNKNOWN37 CLIRAZSOCIAL
        UNKNOWN37 CLINOMEFANT
        UNKNOWN37 CLICNPJCPF
        UNKNOWN14 CLICLIENTE
        UNKNOWN14 CLIFORNEC
        UNKNOWN14 CLISTATUS
        UNKNOWN27 CLILIMCRED
        UNKNOWN35 CLIDTCAD
        mais_109_campos string
    }

    PEDID {
        UNKNOWN8 ID_PEDIDO PK
        UNKNOWN8 CLICODIGO FK
        UNKNOWN27 PEDVRTOTAL
        UNKNOWN35 PEDDTEMIS
    }

    NOTAS {
        UNKNOWN14 NFCODIGO PK
        UNKNOWN8 CLICODIGO FK
        UNKNOWN27 NFVRTOTAL
        UNKNOWN35 NFDTEMIS
    }

    SITCLI {
        UNKNOWN8 CLICODIGO PK_FK
        UNKNOWN7 SITCODIGO FK
        UNKNOWN35 SITDATA PK
    }

    ENDCLI {
        UNKNOWN8 CLICODIGO FK
        UNKNOWN7 ENDCODIGO PK
        string endereco_completo
    }

    CLINET {
        UNKNOWN8 CLICODIGO PK_FK
        UNKNOWN7 NETCODIGO PK
        UNKNOWN37 NETENDERECO
    }

    CLIENINFO {
        UNKNOWN8 CLICODIGO PK_FK
        UNKNOWN37 CHAVE PK
        UNKNOWN37 VALOR
    }

    CREDCLI {
        UNKNOWN8 CLICODIGO FK
        UNKNOWN16 VALOR
    }

    ACOPED {
        UNKNOWN8 ID_PEDIDO FK
        string dados_acompanhamento
    }

    SITUACAO {
        UNKNOWN7 SITCODIGO PK
        UNKNOWN37 SITDESCRICAO
    }

    %% Relacionamentos Principais
    CLIEN ||--o{ PEDID : "CLICODIGO"
    CLIEN ||--o{ NOTAS : "CLICODIGO"
    CLIEN ||--o{ SITCLI : "CLICODIGO"
    CLIEN ||--o{ ENDCLI : "CLICODIGO"
    CLIEN ||--o{ CLINET : "CLICODIGO"
    CLIEN ||--o{ CLIENINFO : "CLICODIGO"
    CLIEN ||--o{ CREDCLI : "CLICODIGO"

    PEDID ||--o{ ACOPED : "ID_PEDIDO"
    SITCLI }o--|| SITUACAO : "SITCODIGO"

    %% Nota: Existem 100+ outras tabelas omitidas para clareza
```

---

## ⚠️ Observações Importantes

### 1. Tabela Central do Sistema

**CLIEN é o HUB mais importante:**

```
106 tabelas dependentes
119 colunas de dados
9.251 registros
```

**Implica:**
- Qualquer mudança em CLIEN afeta múltiplos módulos
- Performance crítica (índices essenciais)
- Integridade de dados vital

### 2. Ausência Total de Foreign Keys Saindo

```
CLIEN possui 0 FKs formais saindo
```

**Campos que DEVERIAM ter FK (mas não têm):**
- FUNCODIGO → FUNCIO
- TRACODIGO → TRANSP
- PGTCODIGO → PAGTO
- BCOCODIGO → BANCO
- E outros 20+ campos

**Razões possíveis:**
- Sistema legado sem constraints
- Performance (evitar overhead)
- Flexibilidade (dados órfãos permitidos)

**Riscos:**
- Dados inconsistentes
- Códigos inexistentes
- Manutenção manual de integridade

### 3. Duplicação: Cliente E Fornecedor

**Uma entidade pode ser AMBOS:**

```sql
SELECT
    COUNT(*) AS TOTAL,
    SUM(CASE WHEN CLICLIENTE = 'S' AND CLIFORNEC = 'S' THEN 1 ELSE 0 END) AS AMBOS,
    SUM(CASE WHEN CLICLIENTE = 'S' AND CLIFORNEC = 'N' THEN 1 ELSE 0 END) AS SÓ_CLIENTE,
    SUM(CASE WHEN CLICLIENTE = 'N' AND CLIFORNEC = 'S' THEN 1 ELSE 0 END) AS SÓ_FORNECEDOR
FROM CLIEN;
```

**Vantagem:** Cadastro único para relacionamento completo
**Desafio:** Lógica de negócio deve considerar ambos os papéis

### 4. Campos de Configuração Abundantes

**119 colunas incluem MUITAS configurações:**
- Cálculo de impostos (10+ campos)
- Frete e logística (7+ campos)
- Pagamento web (8+ campos)
- Regras de negócio (12+ campos)

**Implica:**
- Alta flexibilidade por cliente
- Complexidade de manutenção
- Documentação essencial

### 5. Índices Estratégicos

```
3 índices criados:
1. INDCLICNPJCPF (busca por documento)
2. INDCLINOMEFANT (busca por nome fantasia)
3. INDCLIRAZSOCIAL (busca por razão social)
```

**Buscas otimizadas:**
- ✅ Por CPF/CNPJ
- ✅ Por nome
- ❌ Por status (não otimizado)
- ❌ Por cidade (não otimizado)

**Recomendação:** Adicionar índices conforme padrões de uso.

### 6. Campos de Data Importantes

```
CLIDTCAD: Data cadastro (NOT NULL)
CLIDTULTCONS: Última consulta
CLIDTLIBVENDA: Liberação venda
CLIULTALTERACAO: Última alteração
```

**Uso:**
- Análise de churn (última consulta)
- Auditoria (última alteração)
- Controle de acesso (liberação venda)

### 7. Limite de Crédito vs Realidade

**CLILIMCRED define limite, mas:**
```sql
-- Verificar utilização do limite
SELECT
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLILIMCRED AS LIMITE,
    SUM(D.DUPVLRPENDENTE) AS EM_ABERTO,
    (C.CLILIMCRED - SUM(D.DUPVLRPENDENTE)) AS DISPONIVEL
FROM CLIEN C
LEFT JOIN DUPLACLI D ON C.CLICODIGO = D.CLICODIGO
WHERE D.DUPSITUACAO = 'A'
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL, C.CLILIMCRED
HAVING SUM(D.DUPVLRPENDENTE) > C.CLILIMCRED;
```

### 8. Informações Adicionais Flexíveis

**CLIENINFO (6.679 registros):**
- Padrão chave-valor
- Permite campos customizados
- Extensibilidade sem alterar schema

**Exemplo:**
```
CLICODIGO=12345, CHAVE="COR_PREFERIDA", VALOR="Azul"
CLICODIGO=12345, CHAVE="TAMANHO_PADRAO", VALOR="M"
```

### 9. Campos Default Interessantes

```
CLINFECALCFRETE = 'V' (DEFAULT)
CLIPAGWEBFECHAMENTO = 'S' (DEFAULT)
CLIPAGWEBCARTCREDITO = 'N' (DEFAULT)
CLIINDFINAL = 'N' (DEFAULT)
```

**Padrões conservadores:**
- Calcular frete: SIM
- Pag web fechamento: SIM
- Pag web cartão: NÃO (opt-in)

### 10. Integração Multi-Empresa

**Campos relacionados:**
- CLIEMP (cliente x empresa)
- CLIFORCTB (contabilidade por empresa)
- CLIFAIXAFAT (faixa fat por empresa)

**Permite:**
- Mesmo cliente em múltiplas filiais
- Configurações diferentes por empresa
- Contabilização separada

---

## 📚 Casos de Uso Complexos

### Caso 1: Análise 360º do Cliente

```sql
-- Visão completa: cadastro + vendas + financeiro + histórico
SELECT
    -- Dados básicos
    C.CLICODIGO,
    C.CLIRAZSOCIAL,
    C.CLIDTCAD,

    -- Situação atual
    S.SITDESCRICAO,

    -- Vendas
    COUNT(DISTINCT P.ID_PEDIDO) AS TOTAL_PEDIDOS,
    SUM(P.PEDVRTOTAL) AS FATURAMENTO_TOTAL,

    -- Financeiro
    COUNT(DISTINCT CR.CRECODIGO) AS CREDITOS_ATIVOS,
    SUM(CR.CREVALOR) AS VALOR_CREDITOS,

    -- Última atividade
    MAX(P.PEDDTEMIS) AS ULTIMA_COMPRA
FROM CLIEN C
LEFT JOIN SITCLI SC ON C.CLICODIGO = SC.CLICODIGO
LEFT JOIN SITUACAO S ON SC.SITCODIGO = S.SITCODIGO
LEFT JOIN PEDID P ON C.CLICODIGO = P.CLICODIGO
LEFT JOIN CREDCLI CR ON C.CLICODIGO = CR.CLICODIGO
WHERE C.CLICODIGO = 12345
GROUP BY C.CLICODIGO, C.CLIRAZSOCIAL, C.CLIDTCAD, S.SITDESCRICAO;
```

---

**Fim da Documentação**

*Esta documentação foi gerada exclusivamente a partir do schema do banco de dados Firebird, sem interpretações de código-fonte local.*

*Nota: Devido à complexidade de CLIEN (106 relacionamentos), esta documentação focou nas principais categorias e fluxos. Consulte database_documentation.md para lista completa de todas as 106 tabelas dependentes.*
