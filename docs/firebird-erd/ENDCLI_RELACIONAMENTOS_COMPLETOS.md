# TABELA ENDCLI - Análise Completa de Relacionamentos

**Data da Análise:** 2025-11-28
**Banco de Dados:** Firebird (READ-ONLY)
**Modelo Eloquent:** `App\Models\Firebird\FirebirdEndcli`

---

## 1. VISÃO GERAL

A tabela **ENDCLI** (Endereços de Clientes/Fornecedores) armazena múltiplos endereços para cada cliente/fornecedor, incluindo dados completos de contato, localização e flags de uso (faturamento, cobrança, entrega).

### Características Principais
- **Chave Primária Composta:** CLICODIGO + ENDCODIGO
- **Total de Registros:** 9.355 endereços
- **Total de Colunas:** 53 colunas
- **Relacionada com:** 9.335 clientes (CLIEN)

### Propósito
Permite que um único cliente/fornecedor tenha múltiplos endereços para diferentes finalidades:
- Endereço de faturamento (ENDFAT)
- Endereço de cobrança (ENDCOB)
- Endereço de entrega (ENDENT)
- Endereço de trabalho (ENDTRAB)
- Endereço de fazenda (ENDFAZENDA)

---

## 2. ESTRUTURA DA TABELA

### 2.1 Chave Primária (Composta)

| Campo | Tipo | Tamanho | Descrição |
|-------|------|---------|-----------|
| **CLICODIGO** | INTEGER | 4 bytes | Código do cliente/fornecedor |
| **ENDCODIGO** | SMALLINT | 2 bytes | Código sequencial do endereço |

**Constraint:** `XPKENDCLI`

### 2.2 Categorização dos Campos (53 colunas)

#### A) Identificação e Relacionamentos (10 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| CLICODIGO | INTEGER | 4 | ✓ | FK → CLIEN.CLICODIGO |
| ENDCODIGO | SMALLINT | 2 | ✓ | Sequencial do endereço |
| CIDCODIGO | INTEGER | 4 | ✓ | FK → CIDADE.CIDCODIGO |
| SETCODIGO | SMALLINT | 2 | | FK → SETOR.SETCODIGO |
| DISCODIGO | SMALLINT | 2 | | FK → DISTRITO.DISCODIGO |
| ZOCODIGO | SMALLINT | 2 | | FK → ZONA.ZOCODIGO |
| RUACODIGO | INTEGER | 4 | | Código da rua |
| BAICODIGO | INTEGER | 4 | | Código do bairro |
| VUCCODIGO | SMALLINT | 2 | | Código de vinculação UC |
| EDICODIGO | INTEGER | 4 | | Código do edifício |

#### B) Endereço Físico (9 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDTPRUA | CHAR | 3 | ✓ | FK → TPRUA (tipo: RUA, AVE, etc.) |
| ENDENDERECO | VARCHAR | 40 | ✓ | Nome da rua/avenida |
| ENDNR | VARCHAR | 8 | | Número |
| ENDCOMPLE | VARCHAR | 60 | | Complemento |
| ENDBAIRRO | VARCHAR | 25 | | Bairro |
| ENDCEP | CHAR | 8 | ✓ | CEP (8 dígitos) |
| ENDCXPOSTAL | VARCHAR | 8 | | Caixa postal |
| ENDNOME | VARCHAR | 40 | | Nome do endereço |
| ENDCI | VARCHAR | 18 | | CI (campo específico) |

#### C) Contato - Telefones (9 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDDDD1 | CHAR | 4 | | DDD telefone 1 |
| ENDFONE1 | VARCHAR | 10 | | Telefone 1 |
| ENDDDD2 | CHAR | 4 | | DDD telefone 2 |
| ENDFONE2 | VARCHAR | 10 | | Telefone 2 |
| ENDDDD3 | CHAR | 4 | | DDD telefone 3 |
| ENDFONE3 | VARCHAR | 10 | | Telefone 3 |
| ENDDDDCEL | CHAR | 4 | | DDD celular |
| ENDCELULAR | VARCHAR | 10 | | Número celular |
| ENDDDDFAX | CHAR | 4 | | DDD fax |
| ENDFAX | VARCHAR | 10 | | Número fax |

#### D) Flags de Uso (5 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Valores | Descrição |
|-------|------|---------|----------|---------|-----------|
| ENDFAT | CHAR | 1 | ✓ | S/N | Endereço de faturamento |
| ENDCOB | CHAR | 1 | ✓ | S/N | Endereço de cobrança |
| ENDENT | CHAR | 1 | ✓ | S/N | Endereço de entrega |
| ENDTRAB | CHAR | 1 | ✓ | S/N | Endereço de trabalho |
| ENDFAZENDA | CHAR | 1 | ✓ | S/N | Endereço de fazenda |

**Distribuição das Flags:**
```
ENDFAT (Faturamento):
  - S: 9.326 (99,69%)
  - N: 29 (0,31%)

ENDCOB (Cobrança):
  - S: 9.326 (99,69%)
  - N: 29 (0,31%)

ENDENT (Entrega):
  - S: 9.328 (99,71%)
  - N: 27 (0,29%)
```

#### E) Dados Fiscais - SUFRAMA (6 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDNRSUFRAMA | VARCHAR | 15 | | Número SUFRAMA |
| ENDDTLIMSUFRAMA | TIMESTAMP | 8 | | Data limite SUFRAMA |
| ENDCALCSUFRAICMS | CHAR | 1 | | Calcula SUFRA ICMS (S/N) |
| ENDCALCSUFRAIPI | CHAR | 1 | | Calcula SUFRA IPI (S/N) |
| ENDCALCSUFRAPIS | CHAR | 1 | | Calcula SUFRA PIS (S/N) |
| ENDCALCSUFRACOFINS | CHAR | 1 | | Calcula SUFRA COFINS (S/N) |

#### F) Dados de Recebimento NFe (4 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDCPFCNPJRECEBIMENTO | VARCHAR | 14 | | CPF/CNPJ para recebimento |
| ENDNOMERECEBIMENTO | VARCHAR | 60 | | Nome para recebimento |
| ENDIERECEBIMENTO | VARCHAR | 14 | | IE para recebimento |
| ENDEMAILRECEBIMENTO | VARCHAR | 60 | | Email para recebimento NFe |

#### G) Geolocalização (2 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| LATITUDE | VARCHAR | 1000 | | Latitude GPS |
| LONGITUDE | VARCHAR | 1000 | | Longitude GPS |

#### H) Controle e Logística (8 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDDTENTRADA | TIMESTAMP | 8 | | Data de entrada |
| ENDDTCAD | TIMESTAMP | 8 | | Data de cadastro |
| ENDOBS | BLOB | 8 | | Observações (texto longo) |
| ENDKM | INTEGER | 4 | | Quilometragem |
| ENDETGHRENTRE | VARCHAR | 65 | | ETG hora entrega |
| ENDETGHRADC | INTEGER | 4 | | ETG hora adicional |
| ENDETGHROP1 | VARCHAR | 1 | | ETG hora opção 1 |
| PRACAPAGTO | VARCHAR | 30 | | Praça de pagamento |

#### I) Outros (2 colunas)
| Campo | Tipo | Tamanho | NOT NULL | Descrição |
|-------|------|---------|----------|-----------|
| ENDNRUC | VARCHAR | 10 | | Número UC |
| ENDDIAVENCTOUC | SMALLINT | 2 | | Dia vencimento UC |
| ENDEMITEETQ | CHAR | 1 | | Emite etiqueta (S/N) |

---

## 3. RELACIONAMENTOS - FK OUT (Referências que ENDCLI faz)

### 3.1 Tabelas Referenciadas (6 FKs)

| FK Constraint | Campo Origem | Tabela Destino | Campo Destino | Volume Destino |
|---------------|--------------|----------------|---------------|----------------|
| **CLIEN_ENDCLI** | CLICODIGO | **CLIEN** | CLICODIGO | 9.335 registros |
| **CIDADE_ENDCLI** | CIDCODIGO | **CIDADE** | CIDCODIGO | 739 cidades |
| **TPRUA_ENDCLI** | ENDTPRUA | **TPRUA** | TPRCODIGO | 18 tipos |
| **SETOR_ENDCLI** | SETCODIGO | **SETOR** | SETCODIGO | 25 setores |
| **DISTRITO_ENDCLI** | DISCODIGO | **DISTRITO** | DISCODIGO | 7 distritos |
| **ZONA_ENDCLI** | ZOCODIGO | **ZONA** | ZOCODIGO | 17 zonas |

### 3.2 Descrição dos Relacionamentos

#### ENDCLI → CLIEN (Principal)
- **Tipo:** N:1 (Muitos endereços para um cliente)
- **Obrigatório:** Sim (CLICODIGO NOT NULL)
- **Descrição:** Cada endereço pertence a um cliente/fornecedor
- **Importância:** ⭐⭐⭐⭐⭐ CRÍTICO

#### ENDCLI → CIDADE
- **Tipo:** N:1
- **Obrigatório:** Sim (CIDCODIGO NOT NULL)
- **Descrição:** Cada endereço está em uma cidade
- **Importância:** ⭐⭐⭐⭐⭐ CRÍTICO

#### ENDCLI → TPRUA
- **Tipo:** N:1
- **Obrigatório:** Sim (ENDTPRUA NOT NULL)
- **Descrição:** Tipo de logradouro (RUA, AVE, PCA, etc.)
- **Importância:** ⭐⭐⭐ IMPORTANTE

#### ENDCLI → SETOR
- **Tipo:** N:1 (Opcional)
- **Obrigatório:** Não
- **Descrição:** Setor comercial/territorial
- **Importância:** ⭐⭐ SECUNDÁRIO

#### ENDCLI → DISTRITO
- **Tipo:** N:1 (Opcional)
- **Obrigatório:** Não
- **Descrição:** Distrito administrativo
- **Importância:** ⭐⭐ SECUNDÁRIO

#### ENDCLI → ZONA
- **Tipo:** N:1 (Opcional)
- **Obrigatório:** Não
- **Descrição:** Zona comercial/entrega
- **Importância:** ⭐⭐ SECUNDÁRIO

---

## 4. RELACIONAMENTOS - FK IN (Tabelas que referenciam ENDCLI)

### 4.1 Tabelas Dependentes

| Tabela Dependente | FK Constraint | Campos | Volume | Status |
|-------------------|---------------|--------|--------|--------|
| **PCTCLI** | Multiple FKs | CLICODIGO, ENDCOB, ENDFAT, ENDENT | 1.359 | ✓ ATIVA |
| **CUPOM** | Multiple FKs | CLICODIGO/2, ENDCOB/2, ENDFAT/2, ENDENT/2 | 0 | ✗ VAZIA |
| **EMPFILIAL** | Multiple FKs | CLICODIGO, ENDCOB, ENDCODIGO, ENDENT | 0 | ✗ VAZIA |
| **NOTAC** | Multiple FKs | CLICODIGO, ENDCOB, ENDFAT, ENDENT | 0 | ✗ VAZIA |
| **ORCAM** | Multiple FKs | CLICODIGO, ENDCOB, ENDCODIGO, ENDENT | 0 | ✗ VAZIA |
| **OSSERTERC** | ENDCLICOB_OSSERTERC | CLICODIGO, ENDCOB | 0 | ✗ VAZIA |

### 4.2 Análise Detalhada das Dependências

#### PCTCLI (Pontos de Cliente) - 1.359 registros ✓
```
Relacionamentos:
- PCTCLI.CLICODIGO → ENDCLI.CLICODIGO (FK: ENDCLIC_PCTCLI)
- PCTCLI.CLICODIGO → ENDCLI.CLICODIGO (FK: ENDCLIE_PCTCLI)
- PCTCLI.CLICODIGO → ENDCLI.CLICODIGO (FK: ENDCLIF_PCTCLI)
- PCTCLI.ENDCOB → ENDCLI.ENDCODIGO (FK: ENDCLIC_PCTCLI)
- PCTCLI.ENDFAT → ENDCLI.ENDCODIGO (FK: ENDCLIF_PCTCLI)
- PCTCLI.ENDENT → ENDCLI.ENDCODIGO (FK: ENDCLIE_PCTCLI)

Propósito: Pontos de fidelidade por cliente
Importância: ⭐⭐⭐ IMPORTANTE
```

#### Tabelas VAZIA (Volume = 0)
As seguintes tabelas possuem FKs para ENDCLI mas estão vazias:
- **CUPOM:** Sistema de cupons fiscais (não utilizado)
- **EMPFILIAL:** Filiais da empresa (não utilizado)
- **NOTAC:** Notas de consumo (não utilizado)
- **ORCAM:** Orçamentos (não utilizado)
- **OSSERTERC:** Ordens de serviço terceiros (não utilizado)

---

## 5. RELACIONAMENTOS NÍVEL 2 (Via CLIEN)

### 5.1 Fluxo: ENDCLI → CLIEN → Outras Tabelas

A tabela **CLIEN** é o HUB central que conecta ENDCLI a todo o sistema.

#### CLIEN → Outras Tabelas (Top 20)

| Tabela Final | FK Constraint | Campo | Descrição |
|--------------|---------------|-------|-----------|
| **ACPCLI** | FK_CLIEN | CLICODIGO | Acompanhamento Cliente |
| **AGRECEB** | CLIEN_AGCLI | CLICODIGO | Agendamento Recebimento |
| **AGRECEBP** | CLIEN_AGRECEBP | CLICODIGO | Agendamento Recebimento Parcial |
| **ALNCLI** | CLIEN_ALNCLI | CLICODIGO | Alíneas Cliente |
| **APVCLITPLENTE** | FK_APVCLITPLENTE_CLIEN | CLICODIGO | Aprovação Cliente Tipo Lente |
| **ARMFOR** | CLIEN_ARMFOR | CLICODIGO | Armações Fornecedor |
| **ATVCLI** | CLIEN_ATVCLI | CLICODIGO | Atividades Cliente |
| **BENSCLI** | CLIEN_BENSCLI | CLICODIGO | Bens Cliente |
| **BLOCO1200** | CLIEN_BLOCO1200 | CLICODIGO | SPED Fiscal Bloco 1200 |
| **BLOCO1600** | FK_BLOCO1600_1 | CLICODIGO | SPED Fiscal Bloco 1600 |
| **BLOCO1601** | FK_BLOCO1601_1/2 | COD_PART_IP/IT | SPED Fiscal Bloco 1601 |
| **CAIXA** | CLIEN_CAIXA | CLICODIGO | Movimentos Caixa |
| **CAIXAP** | CLIEN_CAIXAP | CLICODIGO | Previsão Caixa |
| **CCORR** | CLIEN_CCORR | CLICODIGO | Conta Corrente |
| **CHEQUE** | CLIEN_CHEQUE | CLICODIGO | Cheques |
| **CLIALMOX** | CLIEN_CLIALMOX | CLICODIGO | Cliente Almoxarifado |
| **CLIAUTDOWNLOADXML** | CLIAUTDOWNLOADXML_CLIEN | CLICODIGO | Autorização Download XML |
| **CLICOMBPROPRO** | CLIEN_CLICOMBPROPRO | CLICODIGO | Combos Produto |
| **CLICOMBPROSER** | CLIEN_CLICOMBPROSER | CLICODIGO | Combos Serviço |

### 5.2 Exemplo de Navegação Nível 2

```
ENDCLI (endereço 1 do cliente 100)
  ↓ CLICODIGO = 100
CLIEN (cliente 100)
  ↓ CLICODIGO = 100
ACPCLI (acompanhamentos do cliente 100)
CAIXA (movimentos financeiros do cliente 100)
CHEQUE (cheques do cliente 100)
... etc
```

**Total estimado:** CLIEN possui FK_IN com mais de 50 tabelas do sistema.

---

## 6. ÍNDICES

### 6.1 Lista de Índices (7 índices)

| Nome do Índice | Tipo | Campo(s) | Ativo | Descrição |
|----------------|------|----------|-------|-----------|
| **XPKENDCLI** | UNIQUE | CLICODIGO, ENDCODIGO | ✓ | Chave primária |
| **CLIEN_ENDCLI** | INDEX | CLICODIGO | ✓ | Busca por cliente |
| **CIDADE_ENDCLI** | INDEX | CIDCODIGO | ✓ | Busca por cidade |
| **TPRUA_ENDCLI** | INDEX | ENDTPRUA | ✓ | Busca por tipo rua |
| **SETOR_ENDCLI** | INDEX | SETCODIGO | ✓ | Busca por setor |
| **DISTRITO_ENDCLI** | INDEX | DISCODIGO | ✓ | Busca por distrito |
| **ZONA_ENDCLI** | INDEX | ZOCODIGO | ✓ | Busca por zona |

### 6.2 Performance

**Índices Críticos:**
1. ✅ **XPKENDCLI** - Acesso direto por PK
2. ✅ **CLIEN_ENDCLI** - Busca endereços de um cliente (uso frequente)
3. ✅ **CIDADE_ENDCLI** - Filtros geográficos

**Índices Secundários:**
- SETOR, DISTRITO, ZONA: Úteis para relatórios territoriais/comerciais
- TPRUA: Raramente usado diretamente

---

## 7. VOLUME DE DADOS E DISTRIBUIÇÃO

### 7.1 Estatísticas Gerais
```
Total de Endereços:        9.355
Total de Clientes:         9.335
Média Endereços/Cliente:   1,00 (maioria tem 1 endereço)
Máximo Endereços/Cliente:  3
```

### 7.2 Clientes com Múltiplos Endereços (Top 10)

| CLICODIGO | Total Endereços |
|-----------|-----------------|
| 1592 | 3 |
| 4010 | 3 |
| 4011 | 3 |
| 6886 | 3 |
| 350 | 2 |
| 954 | 2 |
| 991 | 2 |
| 1584 | 2 |
| 1637 | 2 |
| 2253 | 2 |

**Observação:** 99% dos clientes possuem apenas 1 endereço cadastrado.

### 7.3 Exemplos de Registros

#### Exemplo 1: Cliente 1 (Maringá - PR)
```
CLICODIGO: 1
ENDCODIGO: 1
ENDTPRUA: AVE (Avenida)
CIDCODIGO: 1
ENDENDERECO: BRASIL
ENDNR: 4493
ENDCOMPLE: SOBRELOJA
ENDBAIRRO: ZONA 01
ENDCEP: 87013000
TELEFONE: (44) 3343-3423
FAX: (0800) 7233423
ENDFAT: S (Faturamento)
ENDCOB: S (Cobrança)
ENDENT: S (Entrega)
SETCODIGO: 5
ZOCODIGO: 1
```

#### Exemplo 2: Cliente 2 (Cascavel - PR) - COM GEOLOCALIZAÇÃO
```
CLICODIGO: 2
ENDCODIGO: 2
ENDTPRUA: RUA
CIDCODIGO: 2
ENDENDERECO: SETE DE SETEMBRO
ENDNR: 3194
ENDBAIRRO: CENTRO
ENDCEP: 85810090
TELEFONE: (45) 3225-3141
FAX: (0800) 0522003
LATITUDE: -24.9545759
LONGITUDE: -53.4601395
ENDFAT: S
ENDCOB: S
ENDENT: S
SETCODIGO: 20
```

---

## 8. CASOS DE USO IMPORTANTES

### 8.1 Buscar Endereço Principal do Cliente
```php
// Via Eloquent Model
$enderecoPrincipal = FirebirdEndcli::where('CLICODIGO', $clienteId)
    ->where('ENDFAT', 'S')
    ->first();

// Com city relationship
$endereco = FirebirdEndcli::with('city')
    ->where('CLICODIGO', $clienteId)
    ->main() // scope
    ->first();
```

### 8.2 Buscar Endereço de Entrega
```php
$enderecoEntrega = FirebirdEndcli::where('CLICODIGO', $clienteId)
    ->where('ENDENT', 'S')
    ->first();
```

### 8.3 Listar Todos os Endereços de um Cliente
```php
$enderecos = FirebirdEndcli::where('CLICODIGO', $clienteId)
    ->orderBy('ENDCODIGO')
    ->get();

foreach ($enderecos as $end) {
    echo "Endereço {$end->ENDCODIGO}: {$end->getFullAddress()}\n";
    echo "Faturamento: " . ($end->isMainAddress() ? 'SIM' : 'NÃO') . "\n";
    echo "Cobrança: " . ($end->isBillingAddress() ? 'SIM' : 'NÃO') . "\n";
    echo "Entrega: " . ($end->isDeliveryAddress() ? 'SIM' : 'NÃO') . "\n";
}
```

### 8.4 Buscar Endereços por Cidade
```php
$enderecos = FirebirdEndcli::where('CIDCODIGO', $cidadeId)
    ->with('city')
    ->get();
```

---

## 9. OBSERVAÇÕES ESPECIAIS

### 9.1 Flags de Uso (ENDFAT, ENDCOB, ENDENT)
- ⚠️ **99,7% dos endereços** têm todas as 3 flags = 'S'
- Isso indica que **na maioria dos casos, o mesmo endereço é usado para tudo**
- Apenas 29 endereços (0,3%) têm flags = 'N'

### 9.2 Campos Pouco Utilizados
Os seguintes campos raramente têm valores:
- ENDCXPOSTAL (Caixa Postal)
- ENDNOME (Nome do endereço)
- ENDCI
- ENDTRAB (98%+ = 'N')
- ENDFAZENDA (98%+ = 'N')
- ENDOBS (BLOB - observações)
- ENDNRSUFRAMA (SUFRAMA)
- LATITUDE/LONGITUDE (poucas localizações cadastradas)

### 9.3 Geolocalização
- Apenas **alguns endereços** possuem LATITUDE/LONGITUDE
- Campo VARCHAR(1000) - permite armazenar coordenadas com alta precisão
- Útil para: roteirização, cálculo de distâncias, mapas

### 9.4 Modelo Eloquent
O modelo `FirebirdEndcli` possui métodos úteis:
- `getFormattedPhone()` - Formata telefone com DDD
- `getFormattedCellPhone()` - Formata celular com DDD
- `getFormattedCep()` - Formata CEP (xxxxx-xxx)
- `getFullAddress()` - Retorna endereço completo
- `isMainAddress()` - Verifica se é endereço de faturamento
- `isBillingAddress()` - Verifica se é endereço de cobrança
- `isDeliveryAddress()` - Verifica se é endereço de entrega
- Scopes: `main()`, `billing()`, `delivery()`, `byClient()`

### 9.5 Diferença entre ENDCLI e ENDERECO
- **ENDCLI:** Endereços de clientes/fornecedores (tabela legada, completa)
- **ENDERECO:** Endereços genéricos (tabela nova, simplificada) - Ver doc separado

### 9.6 Integridade Referencial
- ✅ Todas as FKs estão ativas e validadas
- ⚠️ CLICODIGO NOT NULL - sempre deve ter cliente válido
- ⚠️ CIDCODIGO NOT NULL - sempre deve ter cidade válida
- ⚠️ ENDCEP NOT NULL - CEP obrigatório (mas pode ser '00000000')

---

## 10. DIAGRAMA DE RELACIONAMENTOS

```
                                    ┌─────────────────┐
                              ┌────▶│     CIDADE      │
                              │     │   (739 regs)    │
                              │     └─────────────────┘
                              │
                              │     ┌─────────────────┐
                              ├────▶│      TPRUA      │
                              │     │   (18 tipos)    │
                              │     └─────────────────┘
                              │
    ┌─────────────────┐       │     ┌─────────────────┐
    │     CLIEN       │       ├────▶│     SETOR       │
    │  (9.335 regs)   │◀──────┤     │   (25 regs)     │
    └─────────────────┘       │     └─────────────────┘
            ▲                 │
            │                 │     ┌─────────────────┐
            │                 ├────▶│    DISTRITO     │
            │                 │     │    (7 regs)     │
    ┌───────┴────────┐        │     └─────────────────┘
    │                │        │
    │    ENDCLI      │────────┤     ┌─────────────────┐
    │  (9.355 regs)  │        └────▶│      ZONA       │
    │                │              │   (17 regs)     │
    └───────┬────────┘              └─────────────────┘
            │
            │ (Referenciado por)
            │
    ┌───────┴────────┐
    │                │
    │    PCTCLI      │
    │  (1.359 regs)  │
    │                │
    └────────────────┘

LEGENDA:
─────▶  FK OUT (ENDCLI referencia)
◀─────  FK IN (referencia ENDCLI)
```

---

## 11. QUERIES SQL ÚTEIS

### 11.1 Contar Endereços por Cliente
```sql
SELECT CLICODIGO, COUNT(*) AS TOTAL_ENDERECOS
FROM ENDCLI
GROUP BY CLICODIGO
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
```

### 11.2 Endereços com Geolocalização
```sql
SELECT CLICODIGO, ENDCODIGO, ENDENDERECO, LATITUDE, LONGITUDE
FROM ENDCLI
WHERE LATITUDE IS NOT NULL
  AND LATITUDE != ''
  AND LONGITUDE IS NOT NULL
  AND LONGITUDE != '';
```

### 11.3 Endereços por Cidade (com nome)
```sql
SELECT C.CIDNOME, COUNT(*) AS TOTAL_ENDERECOS
FROM ENDCLI E
JOIN CIDADE C ON C.CIDCODIGO = E.CIDCODIGO
GROUP BY C.CIDNOME
ORDER BY COUNT(*) DESC
ROWS 20;
```

### 11.4 Endereços Completos (Full Join)
```sql
SELECT
    E.CLICODIGO,
    E.ENDCODIGO,
    E.ENDTPRUA || ' ' || E.ENDENDERECO || ', ' || E.ENDNR AS ENDERECO,
    E.ENDBAIRRO,
    E.ENDCEP,
    C.CIDNOME,
    C.UFCODIGO,
    E.ENDFAT,
    E.ENDCOB,
    E.ENDENT
FROM ENDCLI E
JOIN CIDADE C ON C.CIDCODIGO = E.CIDCODIGO
WHERE E.CLICODIGO = ?;
```

---

## 12. CONCLUSÕES E RECOMENDAÇÕES

### 12.1 Pontos Fortes
✅ Estrutura completa e bem normalizada
✅ Suporta múltiplos endereços por cliente (embora pouco usado)
✅ Flags claras de uso (faturamento, cobrança, entrega)
✅ Índices adequados para consultas frequentes
✅ Integração forte com CLIEN (tabela central)

### 12.2 Pontos de Atenção
⚠️ 99% dos clientes têm apenas 1 endereço - campo ENDCODIGO quase sempre = 1
⚠️ Muitos campos opcionais com baixo uso (SUFRAMA, geolocalização, etc.)
⚠️ Tabelas dependentes (CUPOM, ORCAM, etc.) estão vazias - possível legado
⚠️ VARCHAR(1000) para LAT/LONG é exagerado - poderia ser VARCHAR(20)

### 12.3 Importância no Sistema
**Criticidade: ⭐⭐⭐⭐⭐ MUITO ALTA**

A tabela ENDCLI é **CRÍTICA** porque:
1. Conecta clientes à localização geográfica
2. Define endereços para faturamento, cobrança e entrega
3. É referenciada em processos fiscais e de entrega
4. Relacionamento 1:N com CLIEN (principal entidade do sistema)

### 12.4 Uso em Novos Desenvolvimentos
- ✅ **LEITURA:** Sempre que precisar de endereços de clientes
- ✅ **NAVEGAÇÃO:** Via CLIEN para acessar todo o ecossistema
- ❌ **ESCRITA:** NUNCA (banco Firebird é READ-ONLY)
- 🔄 **MIGRAÇÃO:** Considerar migrar para PostgreSQL mantendo estrutura similar

---

**Documentação gerada em:** 2025-11-28
**Última atualização:** 2025-11-28
**Responsável:** Análise automatizada via Laravel/Firebird
**Versão:** 1.0
