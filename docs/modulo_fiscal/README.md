# Módulo Fiscal — Documentação

Documentação de pesquisa para implementação do módulo Fiscal no OpticalCore ERP.

## Documentos

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| [MODULO-FISCAL-PESQUISA.md](MODULO-FISCAL-PESQUISA.md) | **Documento principal** — Entidades, campos, documentos fiscais eletrônicos (NF-e/NFC-e/NFS-e/CT-e/MDF-e), cálculos de impostos (ICMS, ST, DIFAL, IPI, PIS, COFINS, ISS), tabelas auxiliares (NCM, CFOP, CST, CEST), regimes tributários, obrigações acessórias (SPED), certificado digital, comunicação SEFAZ, integrações entre módulos, reforma tributária, multi-tenant, padrões arquiteturais, priorização | 18 seções |
| [PESQUISA-TRIBUTARIA-BRASIL.md](PESQUISA-TRIBUTARIA-BRASIL.md) | Pesquisa detalhada de cálculos tributários — Fórmulas completas com exemplos, tabelas de alíquotas por UF, CST/CSOSN completo, Simples Nacional (Anexos I-V com faixas), Lucro Presumido/Real, reforma tributária 2026-2033 | 9 seções |
| [PESQUISA-SPED-OBRIGACOES.md](PESQUISA-SPED-OBRIGACOES.md) | Pesquisa detalhada de obrigações acessórias — EFD-ICMS/IPI (blocos 0-9), EFD-Contribuições, ECD, ECF, EFD-Reinf (eventos R-1000 a R-9000), DCTFWeb/MIT, multas, prazos | 13 seções |
| [REFORMA-TRIBUTARIA-2026-2033.md](REFORMA-TRIBUTARIA-2026-2033.md) | **Reforma Tributária (LC 214/2025)** — IVA Dual (CBS + IBS), Imposto Seletivo (IS), cronograma 2026-2033, alíquotas de teste/transição, NF-e 5.0, cClassTrib, CST IBS/CBS/IS, princípio do destino, split payment, regimes favorecidos, Simples Nacional, Zona Franca, impacto no ERP | 31 seções |

## Resumo do Módulo

### Entidades Propostas: ~34 total
- **Configuração Tributária:** 7 entidades
- **Documentos Fiscais:** 9 entidades
- **Apuração de Impostos:** 6 entidades
- **Guias e Recolhimento:** 2 entidades
- **Auditoria:** 1 entidade
- **Domínios Public:** 9 tabelas

### Tabelas de Banco
- **Schema PUBLIC:** ~9 tabelas (NCM, CFOP, CEST, CST, alíquotas)
- **Schema TENANT:** ~22 tabelas (NF-e, impostos, apurações, guias)

### Priorização
1. **Fase 1 (MVP):** Config tributária, Tax Engine, NF-e/NFC-e, Certificado, Gateway
2. **Fase 2 (Operacional):** Eventos, inutilização, apuração ICMS/PIS/COFINS, guias, retenções, NFS-e
3. **Fase 3 (Avançado):** Simples Nacional, SPED, audit trail, contingência
4. **Fase 4 (Compliance):** ECD/ECF, Reinf, CT-e/MDF-e, reforma tributária

### Integrações com Módulos Existentes
- **Vendas** → Faturamento → NF-e (emissão)
- **Compras** → Recebimento → NF-e (escrituração entrada) + Créditos fiscais
- **Estoque** → Inventário → SPED Bloco H
- **Financeiro** → Contas a Pagar/Receber → Retenções + Guias de recolhimento
- **Contábil** → Lançamentos automáticos → ECD/ECF
