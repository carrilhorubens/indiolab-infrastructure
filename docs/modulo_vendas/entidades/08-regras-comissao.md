# Entidade: Regras de Comissão

## Objetivo

Definir as regras de cálculo de comissão de vendedores, com suporte a percentual fixo, faixas escalonadas, por produto, por categoria ou por margem.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/comissao-regras/proximo-codigo` | Próximo código |
| `GET` | `/api/comissao-regras` | Lista paginada |
| `GET` | `/api/comissao-regras/{id}` | Detalhes com faixas |
| `POST` | `/api/comissao-regras` | Cria regra com faixas |
| `PUT` | `/api/comissao-regras/{id}` | Atualiza regra |
| `DELETE` | `/api/comissao-regras/{id}` | Remove |
| `PATCH` | `/api/comissao-regras/{id}/ativar` | Ativa a regra |
| `PATCH` | `/api/comissao-regras/{id}/desativar` | Desativa a regra |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.Comissoes.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `nome` | string | Sim | Nome da regra |
| `tipoCalculo` | string | Sim | PercentualFixo, Escalonada, PorProduto, PorCategoria, PorMargem |
| `baseCalculo` | string | Sim | ReceitaBruta, ReceitaLiquida, MargemBruta, MargemLiquida |
| `percentualFixo` | decimal? | Cond | Usado quando TipoCalculo = PercentualFixo |
| `vendedorId` | Guid? | Não | Regra específica para vendedor (nulo = regra geral) |
| `dataInicio` | DateTime | Sim | Início da vigência |
| `dataFim` | DateTime? | Não | Fim da vigência |
| `ativa` | bool | Auto | Criada como inativa |

### Faixas (ComissaoRegraFaixa) — para tipo Escalonada

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `comissaoRegraId` | Guid | Auto | FK para regra |
| `faixaInicio` | decimal | Sim | Valor inicial da faixa |
| `faixaFim` | decimal | Sim | Valor final da faixa |
| `percentual` | decimal | Sim | Percentual de comissão nessa faixa |

---

## Regras

- Criada como inativa; ativar manualmente
- `TipoCalculo` define como a comissão é calculada:
  - **PercentualFixo:** aplica `percentualFixo` sobre a base
  - **Escalonada:** usa as faixas para determinar o percentual conforme o valor
  - **PorProduto:** percentual varia por produto
  - **PorCategoria:** percentual varia por categoria de produto
  - **PorMargem:** percentual varia conforme a margem da venda
- `BaseCalculo` define sobre qual valor o percentual incide
- Regra com `VendedorId` tem prioridade sobre regra geral (sem vendedor)
- Faixas devem ser contíguas e não sobrepostas
