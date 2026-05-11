# Entidade: Tabelas de Preço

## Objetivo

Gerenciar múltiplas tabelas de preço com vigência, prioridade, tipos de aplicação e limites de desconto por produto, permitindo política de preços flexível.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/tabelas-preco/proximo-codigo` | Próximo código |
| `GET` | `/api/tabelas-preco` | Lista paginada |
| `GET` | `/api/tabelas-preco/{id}` | Detalhes com itens |
| `POST` | `/api/tabelas-preco` | Cria tabela com itens |
| `PUT` | `/api/tabelas-preco/{id}` | Atualiza (somente inativa) |
| `DELETE` | `/api/tabelas-preco/{id}` | Remove |
| `PATCH` | `/api/tabelas-preco/{id}/ativar` | Ativa a tabela |
| `PATCH` | `/api/tabelas-preco/{id}/desativar` | Desativa a tabela |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.TabelasPreco.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `nome` | string | Sim | Nome da tabela |
| `dataInicio` | DateTime | Sim | Início da vigência |
| `dataFim` | DateTime? | Não | Fim da vigência (nulo = vigente indefinidamente) |
| `ativa` | bool | Auto | Criada como inativa; ativar manualmente |
| `prioridade` | int | Sim | Desempate entre tabelas ativas (maior = prioridade) |
| `tipoAplicacao` | string | Sim | Geral, PorCliente, PorGrupoCliente, PorRegiao, PorCanalVenda |
| `acrescimoCondicaoPagamento` | decimal | Não | Acréscimo percentual por condição de pagamento |
| `observacoes` | string? | Não | Observações |

### Campos do Item (TabelaPrecoItem)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `tabelaPrecoId` | Guid | Auto | FK para tabela |
| `produtoId` | Guid | Sim | FK para produto |
| `precoUnitario` | decimal | Sim | Preço de venda |
| `descontoMaximoPercentual` | decimal | Não | Desconto máximo permitido ao vendedor (%) |
| `precoMinimo` | decimal | Não | Piso de preço |

---

## Regras

- Tabela ativa não pode ser editada (PUT); deve ser desativada primeiro
- Criada como inativa por padrão; ativar manualmente via `/ativar`
- `Prioridade` resolve conflito quando há múltiplas tabelas ativas
- `TipoAplicacao` define o escopo: Geral (todos), PorCliente, PorGrupoCliente, PorRegiao, PorCanalVenda
- `DescontoMaximoPercentual` é o limite que o vendedor pode conceder; acima disso, necessita aprovação especial (LogDescontoEspecial)
- `PrecoMinimo` é o piso absoluto — o preço final nunca pode ficar abaixo disso
- `AcrescimoCondicaoPagamento` permite cobrar um percentual a mais para pagamentos parcelados
