# CERTDIGITAL - Documentação Completa de Relacionamentos

## 📊 Informações Gerais

- **Nome da Tabela**: CERTDIGITAL (Certificado Digital)
- **Total de Registros**: 1
- **Total de Colunas**: 5
- **Chave Primária**: CDCODIGO
- **Chaves Estrangeiras**: 0
- **Índices**: 0
- **Tabelas Dependentes**: 1 (PIXCONTA)
- **Banco de Dados**: Firebird

## 📝 Descrição

**CERTDIGITAL** é uma tabela mestre que armazena informações sobre certificados digitais utilizados no sistema. Com **apenas 1 registro**, representa uma configuração única de certificado digital, provavelmente usado para autenticação em sistemas fiscais e integrações bancárias (PIX).

Esta tabela funciona como **repositório centralizado de certificados digitais** e permite:
- Armazenar certificados digitais para autenticação segura
- Gerenciar credenciais de certificados (senha, arquivo)
- Vincular certificados a contas PIX para transações seguras
- Centralizar configurações de certificados digitais
- Facilitar manutenção e atualização de certificados

Cada registro representa um certificado digital completo, contendo:
- Identificação única do certificado (CDCODIGO)
- Descrição do certificado (CDDESCRICAO)
- Nome do arquivo do certificado (CDNOMEARQUIVO)
- Senha do certificado (CDSENHA) - opcional
- Arquivo binário do certificado (CDARQUIVO) - opcional

O sistema utiliza esta tabela para autenticação segura em operações que requerem certificados digitais, especialmente em integrações com sistemas bancários e fiscais que exigem autenticação certificada.

**Observação Importante:** Com apenas 1 registro, esta tabela funciona como uma configuração singleton, sugerindo que o sistema utiliza um único certificado digital para todas as operações que requerem autenticação certificada.

---

## 🔑 Estrutura de Colunas

### Identificação
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CDCODIGO** 🔑 | INTEGER | ✓ | Código identificador único do certificado digital (PK) |

### Informações do Certificado
| Coluna | Tipo | Obrigatório | Descrição |
|--------|------|-------------|-----------|
| **CDDESCRICAO** | VARCHAR(37) | ✓ | Descrição ou nome identificador do certificado digital |
| **CDNOMEARQUIVO** | VARCHAR(37) | ✓ | Nome do arquivo do certificado digital |
| **CDSENHA** | VARCHAR(37) | | Senha do certificado digital (opcional, dados sensíveis) |
| **CDARQUIVO** | VARCHAR(261) | | Caminho ou conteúdo do arquivo do certificado digital (opcional) |

**Primary Key:** CDCODIGO

**Observações sobre Campos:**
- **CDSENHA**: Campo opcional que armazena a senha do certificado. **Dados sensíveis** - deve ser tratado com segurança.
- **CDARQUIVO**: Campo opcional que pode armazenar caminho do arquivo ou conteúdo binário do certificado. Tamanho máximo de 261 caracteres sugere caminho de arquivo.
- **CDNOMEARQUIVO**: Nome do arquivo do certificado, geralmente com extensão .pfx ou .p12 para certificados digitais brasileiros.

---

## 🔗 Relacionamentos - Nível 1 (Diretos)

### CERTDIGITAL é Referenciada Por (1 FK):

#### 1. PIXCONTA - Contas PIX
**Relacionamento:**
```
PIXCONTA.CDCODIGO → CERTDIGITAL.CDCODIGO (N:1)
Constraint: PIXCONTA_CERTDIGITAL
```

**Descrição**: Contas PIX podem referenciar um certificado digital para autenticação em transações PIX.

**Informações da Tabela PIXCONTA:**
- **Total:** 0 registros (tabela configurada mas não utilizada ainda)
- **PK:** CODIGO
- **Colunas:** 20 campos
- **FK Out:** 4 (CONTA - 3 FKs compostas, CERTDIGITAL - 1 FK)
- **FK In:** 0 tabelas

**Campos importantes em PIXCONTA relacionados a certificados:**
- `CDCODIGO` - Referência ao certificado digital (FK → CERTDIGITAL)
- `PIXCERTDIGITAL` - Caminho ou conteúdo do certificado PIX específico (VARCHAR(261))
- `PIXCERTSENHA` - Senha do certificado PIX específico (VARCHAR(37))
- `PIXCERTNOME` - Nome do certificado PIX específico (VARCHAR(37))

**Observação:** PIXCONTA possui campos próprios para certificado (`PIXCERTDIGITAL`, `PIXCERTSENHA`, `PIXCERTNOME`) além da referência a CERTDIGITAL. Isso sugere que:
- CERTDIGITAL pode ser um certificado padrão/global
- PIXCONTA pode ter certificados específicos por conta PIX
- A referência a CERTDIGITAL pode ser opcional ou para fallback

**Uso:** Autenticação segura em transações PIX, validação de certificados em integrações bancárias.

---

### CERTDIGITAL Referencia

**Nenhuma tabela** é referenciada diretamente por CERTDIGITAL. Esta é uma tabela mestre sem dependências externas.

---

## 🔗 Relacionamentos - Nível 2 (Indiretos)

### Via PIXCONTA → CONTA (Contas Bancárias)

**Fluxo:** CERTDIGITAL → PIXCONTA → CONTA

**Descrição:** Através do relacionamento com PIXCONTA, é possível identificar as contas bancárias que utilizam o certificado digital.

**Campos de junção:**
- `CERTDIGITAL.CDCODIGO` → `PIXCONTA.CDCODIGO` → `PIXCONTA.BCOCODIGO + CTANRCONTA + EMPCCORR` → `CONTA.BCOCODIGO + CTANRCONTA + EMPCCORR`

**Uso:** Análises de certificados por conta bancária, auditoria de uso de certificados.

---

### Via PIXCONTA → CONTA → BANCO (Bancos)

**Fluxo:** CERTDIGITAL → PIXCONTA → CONTA → BANCO

**Descrição:** Através do relacionamento com PIXCONTA e CONTA, é possível identificar os bancos que utilizam o certificado digital.

**Campos de junção:**
- `CERTDIGITAL.CDCODIGO` → `PIXCONTA.CDCODIGO` → `PIXCONTA.BCOCODIGO` → `CONTA.BCOCODIGO` → `BANCO.BCOCODIGO`

**Uso:** Análises de certificados por banco, relatórios de integrações bancárias.

---

## 🔗 Relacionamentos - Nível 3 (Fluxo Completo)

### Exemplo 1: Análise Completa de Certificado Digital e Uso

**Objetivo:** Obter visão completa do certificado digital incluindo todas as contas PIX que o utilizam e suas contas bancárias relacionadas.

**Fluxo:**
```
CERTDIGITAL (CDCODIGO)
  ↓
PIXCONTA (CDCODIGO)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO AS CERTIFICADO,
    cd.CDNOMEARQUIVO AS ARQUIVO_CERTIFICADO,
    px.CODIGO AS CODIGO_PIX,
    px.DESCRICAO AS DESCRICAO_PIX,
    px.STATUS AS STATUS_PIX,
    c.CTANRCONTA AS NUMERO_CONTA,
    c.CTAAGENCIA AS AGENCIA,
    b.BCONOME AS BANCO,
    px.PIXCERTDIGITAL AS CERTIFICADO_PIX_ESPECIFICO,
    px.PIXCERTSENHA AS SENHA_PIX_ESPECIFICA,
    px.PIXCERTNOME AS NOME_CERTIFICADO_PIX
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
LEFT JOIN CONTA c ON c.BCOCODIGO = px.BCOCODIGO
    AND c.CTANRCONTA = px.CTANRCONTA
    AND c.EMPCCORR = px.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
WHERE cd.CDCODIGO = ?;
```

---

### Exemplo 2: Verificar Certificados Não Utilizados

**Objetivo:** Identificar certificados digitais que não estão sendo utilizados por nenhuma conta PIX.

**Fluxo:**
```
CERTDIGITAL (CDCODIGO)
  ↓
PIXCONTA (CDCODIGO) - LEFT JOIN para verificar ausência
```

**Query SQL:**
```sql
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO AS CERTIFICADO,
    cd.CDNOMEARQUIVO AS ARQUIVO_CERTIFICADO,
    COUNT(px.CODIGO) AS TOTAL_CONTAS_PIX
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO, cd.CDNOMEARQUIVO
HAVING COUNT(px.CODIGO) = 0;
```

---

### Exemplo 3: Análise de Certificados por Banco

**Objetivo:** Identificar quais bancos utilizam o certificado digital através de contas PIX.

**Fluxo:**
```
CERTDIGITAL (CDCODIGO)
  ↓
PIXCONTA (CDCODIGO)
  ↓
CONTA (BCOCODIGO, CTANRCONTA, EMPCCORR)
  ↓
BANCO (BCOCODIGO)
```

**Query SQL:**
```sql
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO AS CERTIFICADO,
    b.BCOCODIGO,
    b.BCONOME AS BANCO,
    COUNT(DISTINCT px.CODIGO) AS TOTAL_CONTAS_PIX,
    COUNT(DISTINCT c.CTANRCONTA) AS TOTAL_CONTAS_BANCARIAS
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
LEFT JOIN CONTA c ON c.BCOCODIGO = px.BCOCODIGO
    AND c.CTANRCONTA = px.CTANRCONTA
    AND c.EMPCCORR = px.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
WHERE cd.CDCODIGO = ?
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO, b.BCOCODIGO, b.BCONOME
ORDER BY TOTAL_CONTAS_PIX DESC;
```

---

## 💡 Casos de Uso Práticos

### 1. Buscar Certificado Digital

**Objetivo:** Obter informações completas de um certificado digital específico.

```sql
SELECT
    CDCODIGO,
    CDDESCRICAO AS DESCRICAO,
    CDNOMEARQUIVO AS ARQUIVO,
    CDSENHA AS SENHA,
    CDARQUIVO AS CAMINHO_ARQUIVO
FROM CERTDIGITAL
WHERE CDCODIGO = ?;
```

**Observação:** Devido ao volume de apenas 1 registro, esta query sempre retornará o único certificado disponível.

---

### 2. Listar Todas as Contas PIX que Utilizam o Certificado

**Objetivo:** Identificar todas as contas PIX que referenciam o certificado digital.

```sql
SELECT
    px.CODIGO AS CODIGO_PIX,
    px.DESCRICAO AS DESCRICAO_PIX,
    px.STATUS AS STATUS_PIX,
    px.CHAVE AS CHAVE_PIX,
    px.AMBIENTE AS AMBIENTE,
    c.CTANRCONTA AS NUMERO_CONTA,
    b.BCONOME AS BANCO
FROM CERTDIGITAL cd
INNER JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
LEFT JOIN CONTA c ON c.BCOCODIGO = px.BCOCODIGO
    AND c.CTANRCONTA = px.CTANRCONTA
    AND c.EMPCCORR = px.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
WHERE cd.CDCODIGO = ?;
```

---

### 3. Verificar Configuração de Certificado

**Objetivo:** Verificar se o certificado está configurado corretamente (descrição, arquivo, senha).

```sql
SELECT
    CDCODIGO,
    CDDESCRICAO AS DESCRICAO,
    CDNOMEARQUIVO AS ARQUIVO,
    CASE 
        WHEN CDSENHA IS NULL OR CDSENHA = '' THEN 'Não configurado'
        ELSE 'Configurado'
    END AS STATUS_SENHA,
    CASE 
        WHEN CDARQUIVO IS NULL OR CDARQUIVO = '' THEN 'Não configurado'
        ELSE 'Configurado'
    END AS STATUS_ARQUIVO,
    CASE 
        WHEN CDDESCRICAO IS NULL OR CDDESCRICAO = '' THEN 'Não configurado'
        WHEN CDNOMEARQUIVO IS NULL OR CDNOMEARQUIVO = '' THEN 'Não configurado'
        WHEN CDSENHA IS NULL OR CDSENHA = '' THEN 'Parcialmente configurado'
        WHEN CDARQUIVO IS NULL OR CDARQUIVO = '' THEN 'Parcialmente configurado'
        ELSE 'Totalmente configurado'
    END AS STATUS_GERAL
FROM CERTDIGITAL
WHERE CDCODIGO = ?;
```

---

### 4. Comparar Certificado Global vs Certificados Específicos PIX

**Objetivo:** Comparar o certificado digital global (CERTDIGITAL) com certificados específicos configurados em contas PIX.

```sql
SELECT
    cd.CDCODIGO AS CODIGO_CERTIFICADO_GLOBAL,
    cd.CDDESCRICAO AS DESCRICAO_GLOBAL,
    cd.CDNOMEARQUIVO AS ARQUIVO_GLOBAL,
    px.CODIGO AS CODIGO_PIX,
    px.DESCRICAO AS DESCRICAO_PIX,
    px.PIXCERTNOME AS CERTIFICADO_PIX_ESPECIFICO,
    CASE 
        WHEN px.PIXCERTDIGITAL IS NOT NULL AND px.PIXCERTDIGITAL <> '' THEN 'Usa certificado específico'
        WHEN px.CDCODIGO IS NOT NULL THEN 'Usa certificado global'
        ELSE 'Sem certificado configurado'
    END AS TIPO_CERTIFICADO
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
ORDER BY px.CODIGO;
```

---

### 5. Auditoria de Uso de Certificados

**Objetivo:** Verificar quantas contas PIX utilizam o certificado digital e em quais bancos.

```sql
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO AS CERTIFICADO,
    COUNT(DISTINCT px.CODIGO) AS TOTAL_CONTAS_PIX,
    COUNT(DISTINCT c.BCOCODIGO) AS TOTAL_BANCOS,
    STRING_AGG(DISTINCT b.BCONOME, ', ') AS BANCOS
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
LEFT JOIN CONTA c ON c.BCOCODIGO = px.BCOCODIGO
    AND c.CTANRCONTA = px.CTANRCONTA
    AND c.EMPCCORR = px.EMPCCORR
LEFT JOIN BANCO b ON b.BCOCODIGO = c.BCOCODIGO
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO;
```

---

### 6. Verificar Validade e Configuração de Certificado

**Objetivo:** Validar se o certificado digital está configurado corretamente para uso.

```sql
SELECT
    CDCODIGO,
    CDDESCRICAO,
    CDNOMEARQUIVO,
    CASE 
        WHEN CDDESCRICAO IS NULL OR CDDESCRICAO = '' THEN 'ERRO: Descrição não configurada'
        WHEN CDNOMEARQUIVO IS NULL OR CDNOMEARQUIVO = '' THEN 'ERRO: Arquivo não configurado'
        WHEN CDSENHA IS NULL OR CDSENHA = '' THEN 'AVISO: Senha não configurada'
        WHEN CDARQUIVO IS NULL OR CDARQUIVO = '' THEN 'AVISO: Caminho do arquivo não configurado'
        ELSE 'OK: Certificado configurado corretamente'
    END AS STATUS_VALIDACAO
FROM CERTDIGITAL
WHERE CDCODIGO = ?;
```

---

### 7. Relatório de Certificados e Contas PIX

**Objetivo:** Relatório completo de certificados digitais e suas associações com contas PIX.

```sql
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO AS CERTIFICADO_DIGITAL,
    cd.CDNOMEARQUIVO AS ARQUIVO_CERTIFICADO,
    COUNT(px.CODIGO) AS TOTAL_CONTAS_PIX,
    COUNT(CASE WHEN px.STATUS = 'ATIVO' THEN 1 END) AS CONTAS_PIX_ATIVAS,
    COUNT(CASE WHEN px.STATUS = 'INATIVO' THEN 1 END) AS CONTAS_PIX_INATIVAS,
    COUNT(CASE WHEN px.PIXCERTDIGITAL IS NOT NULL AND px.PIXCERTDIGITAL <> '' THEN 1 END) AS CONTAS_COM_CERTIFICADO_ESPECIFICO,
    COUNT(CASE WHEN px.CDCODIGO IS NOT NULL AND (px.PIXCERTDIGITAL IS NULL OR px.PIXCERTDIGITAL = '') THEN 1 END) AS CONTAS_USANDO_CERTIFICADO_GLOBAL
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO, cd.CDNOMEARQUIVO;
```

---

## 📈 Estatísticas de Volume

| Tabela | Registros | Proporção com CERTDIGITAL | Tipo |
|--------|-----------|---------------------------|------|
| **CERTDIGITAL** | 1 | 1:1 | **TABELA PRINCIPAL** |
| PIXCONTA | 0 | 0:1 | Contas PIX (nenhuma configurada ainda) |

**Interpretação:**
- Tabela singleton com apenas **1 registro** - configuração única
- **Nenhuma conta PIX** configurada ainda (PIXCONTA vazia)
- Certificado digital está pronto para uso mas não está sendo utilizado
- Tabela de configuração preparada para futuro uso

**Observação:** O fato de PIXCONTA estar vazia sugere que:
- O sistema está preparado para integração PIX mas ainda não foi configurado
- O certificado digital está disponível para quando as contas PIX forem criadas
- Pode ser uma funcionalidade em desenvolvimento ou planejada

---

## 🎯 Principais Campos de Junção

| Campo | Presente em | Uso |
|-------|-------------|-----|
| **CDCODIGO** | CERTDIGITAL | Chave primária (PK) |
| **CDCODIGO** | PIXCONTA → CERTDIGITAL | Referência ao certificado digital (FK) |
| **CDDESCRICAO** | CERTDIGITAL | Descrição do certificado (exibição) |
| **CDNOMEARQUIVO** | CERTDIGITAL | Nome do arquivo (identificação) |
| **CDSENHA** | CERTDIGITAL | Senha do certificado (dados sensíveis) |
| **CDARQUIVO** | CERTDIGITAL | Caminho ou conteúdo do arquivo |

---

## 🚀 Performance e Otimização

### Índices Existentes

**Nenhum índice específico** está definido na tabela CERTDIGITAL.

### Recomendações de Performance

1. **Índice na chave primária** - Já existe implicitamente (PK)
2. **Tabela muito pequena** - Não requer otimização especial (apenas 1 registro)
3. **Cache útil** - Pode ser mantida em memória devido ao volume mínimo
4. **Índices nas tabelas relacionadas** - Mais críticos que índices em CERTDIGITAL

### Observações sobre Volume

- **Tabela mínima** (1 registro) - Performance não é crítica
- **Consultas são instantâneas** devido ao volume único
- **Cache pode ser útil** - Tabela pode ser mantida em memória permanentemente
- **Focar em índices nas tabelas relacionadas** - PIXCONTA quando tiver volume

### Exemplo de Query Otimizada

```sql
-- ✅ OTIMIZADO (tabela única, não precisa de otimização especial)
SELECT CDCODIGO, CDDESCRICAO, CDNOMEARQUIVO
FROM CERTDIGITAL
WHERE CDCODIGO = ?;

-- ✅ OTIMIZADO (JOIN com tabela pequena é instantâneo)
SELECT cd.*, COUNT(px.CODIGO) AS TOTAL_CONTAS_PIX
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO, cd.CDNOMEARQUIVO;
```

---

## 🔍 Validações e Integridade

### Verificar Integridade Referencial

```sql
-- Verificar contas PIX sem certificado válido (quando PIXCONTA tiver registros)
SELECT px.*
FROM PIXCONTA px
LEFT JOIN CERTDIGITAL cd ON cd.CDCODIGO = px.CDCODIGO
WHERE px.CDCODIGO IS NOT NULL
  AND cd.CDCODIGO IS NULL;
```

### Verificar Consistência de Dados

```sql
-- Verificar valores obrigatórios nulos
SELECT *
FROM CERTDIGITAL
WHERE CDCODIGO IS NULL
   OR CDDESCRICAO IS NULL
   OR CDDESCRICAO = ''
   OR CDNOMEARQUIVO IS NULL
   OR CDNOMEARQUIVO = '';

-- Verificar duplicatas (não deveria existir devido à PK)
SELECT CDCODIGO, COUNT(*) AS QTD
FROM CERTDIGITAL
GROUP BY CDCODIGO
HAVING COUNT(*) > 1;
```

### Verificar Configuração Completa

```sql
-- Verificar se certificado está totalmente configurado
SELECT
    CDCODIGO,
    CDDESCRICAO,
    CDNOMEARQUIVO,
    CASE 
        WHEN CDDESCRICAO IS NULL OR CDDESCRICAO = '' THEN 'FALTA: Descrição'
        WHEN CDNOMEARQUIVO IS NULL OR CDNOMEARQUIVO = '' THEN 'FALTA: Nome do arquivo'
        WHEN CDSENHA IS NULL OR CDSENHA = '' THEN 'FALTA: Senha'
        WHEN CDARQUIVO IS NULL OR CDARQUIVO = '' THEN 'FALTA: Caminho do arquivo'
        ELSE 'OK: Totalmente configurado'
    END AS STATUS_CONFIGURACAO
FROM CERTDIGITAL;
```

### Verificar Uso do Certificado

```sql
-- Verificar quantas contas PIX utilizam o certificado
SELECT
    cd.CDCODIGO,
    cd.CDDESCRICAO,
    COUNT(px.CODIGO) AS TOTAL_CONTAS_PIX_USANDO,
    COUNT(CASE WHEN px.STATUS = 'ATIVO' THEN 1 END) AS CONTAS_ATIVAS_USANDO
FROM CERTDIGITAL cd
LEFT JOIN PIXCONTA px ON px.CDCODIGO = cd.CDCODIGO
GROUP BY cd.CDCODIGO, cd.CDDESCRICAO;
```

---

## 💻 Integração com Código da Aplicação

### Modelo Laravel Sugerido

```php
<?php

declare(strict_types=1);

namespace App\Models\Firebird;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class FirebirdCertdigital extends Model
{
    protected $connection = 'firebird';
    protected $table = 'CERTDIGITAL';
    
    protected $primaryKey = 'CDCODIGO';
    public $incrementing = true;

    protected $casts = [
        'CDCODIGO' => 'integer',
        'CDDESCRICAO' => 'string',
        'CDNOMEARQUIVO' => 'string',
        'CDSENHA' => 'string',
        'CDARQUIVO' => 'string',
    ];

    protected $hidden = [
        'CDSENHA', // Ocultar senha por padrão por segurança
    ];

    // Relacionamento com PIXCONTA
    public function contasPix(): HasMany
    {
        return $this->hasMany(FirebirdPixconta::class, 'CDCODIGO', 'CDCODIGO');
    }

    // Scope para certificado configurado
    public function scopeConfigurado($query)
    {
        return $query->whereNotNull('CDDESCRICAO')
            ->where('CDDESCRICAO', '<>', '')
            ->whereNotNull('CDNOMEARQUIVO')
            ->where('CDNOMEARQUIVO', '<>', '');
    }

    // Scope para certificado completo (com senha e arquivo)
    public function scopeCompleto($query)
    {
        return $query->whereNotNull('CDDESCRICAO')
            ->where('CDDESCRICAO', '<>', '')
            ->whereNotNull('CDNOMEARQUIVO')
            ->where('CDNOMEARQUIVO', '<>', '')
            ->whereNotNull('CDSENHA')
            ->where('CDSENHA', '<>', '')
            ->whereNotNull('CDARQUIVO')
            ->where('CDARQUIVO', '<>', '');
    }

    // Método estático para obter certificado único (singleton)
    public static function getCertificado(): ?self
    {
        return self::first();
    }

    // Método para verificar se está configurado
    public function estaConfigurado(): bool
    {
        return !empty($this->CDDESCRICAO) 
            && !empty($this->CDNOMEARQUIVO);
    }

    // Método para verificar se está completo
    public function estaCompleto(): bool
    {
        return $this->estaConfigurado()
            && !empty($this->CDSENHA)
            && !empty($this->CDARQUIVO);
    }

    // Método para obter total de contas PIX usando o certificado
    public function totalContasPix(): int
    {
        return $this->contasPix()->count();
    }

    // Método para obter contas PIX ativas usando o certificado
    public function contasPixAtivas(): int
    {
        return $this->contasPix()
            ->where('STATUS', 'ATIVO')
            ->count();
    }

    // Accessor para mascarar senha
    public function getCdsenhaMaskedAttribute(): string
    {
        if (empty($this->CDSENHA)) {
            return '';
        }
        return str_repeat('*', min(strlen($this->CDSENHA), 8));
    }
}
```

---

## 📋 Boas Práticas

### Design e Estrutura

1. **Tabela singleton** - Apenas 1 registro, funciona como configuração única
2. **Dados sensíveis** - Senha deve ser tratada com segurança (ocultar em logs, criptografar)
3. **Validação obrigatória** - Descrição e nome do arquivo são obrigatórios
4. **Campos opcionais** - Senha e arquivo podem ser opcionais dependendo do uso

### Segurança

1. **Senha sensível** - Nunca expor senha em logs ou respostas de API
2. **Criptografia** - Considerar criptografar senha antes de armazenar
3. **Acesso restrito** - Limitar acesso a esta tabela apenas a usuários autorizados
4. **Auditoria** - Registrar alterações em certificados digitais

### Performance

1. **Tabela pequena** - Não requer otimização especial (1 registro)
2. **Cache útil** - Pode ser mantida em memória permanentemente
3. **Consultas simples** - Queries são instantâneas devido ao volume único
4. **Índices desnecessários** - Não precisa de índices adicionais

### Integridade de Dados

1. **Validação antes de inserir** - Verificar se campos obrigatórios estão preenchidos
2. **Verificar duplicatas** - PK garante unicidade (mas não necessário com 1 registro)
3. **Manter consistência** - Garantir que certificado está configurado corretamente
4. **Backup regular** - Tabela crítica para segurança, fazer backup frequente

### Manutenção

1. **Revisão periódica** - Verificar validade do certificado digital
2. **Atualização de certificados** - Renovar certificados antes de expirar
3. **Documentação** - Documentar processo de atualização de certificados
4. **Testes** - Testar certificado após atualização

### Regras de Negócio

1. **Certificado único** - Sistema utiliza apenas 1 certificado digital
2. **Configuração obrigatória** - Certificado deve estar configurado para uso em PIX
3. **Validação em tempo real** - Verificar se certificado está válido antes de usar
4. **Fallback** - Contas PIX podem ter certificados específicos além do global

### Observações Especiais

1. **PIXCONTA vazia** - Nenhuma conta PIX configurada ainda, certificado está pronto para uso futuro
2. **Certificados específicos** - PIXCONTA pode ter certificados próprios além da referência a CERTDIGITAL
3. **Uso futuro** - Tabela preparada para quando integração PIX for configurada
4. **Singleton pattern** - Tabela funciona como configuração única do sistema

---

**Documentação gerada em:** 2025-01-27

**Banco de Dados:** Firebird

**Versão:** 1.0

