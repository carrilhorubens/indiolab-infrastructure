# Entidade: Regiões de Venda

## Objetivo

Cadastrar regiões geográficas de venda com UFs associadas e vendedor responsável, permitindo segmentação territorial para relatórios e metas.

---

## Endpoint

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/api/regioes-venda/proximo-codigo` | Próximo código |
| `GET` | `/api/regioes-venda` | Lista paginada com filtro ativo |
| `GET` | `/api/regioes-venda/{id}` | Detalhes |
| `POST` | `/api/regioes-venda` | Cria região |
| `PUT` | `/api/regioes-venda/{id}` | Atualiza |
| `DELETE` | `/api/regioes-venda/{id}` | Remove |
| `PATCH` | `/api/regioes-venda/{id}/ativar` | Ativa |
| `PATCH` | `/api/regioes-venda/{id}/desativar` | Desativa |

**Autenticação:** Bearer Token (JWT)
**Permissão:** `Permissions.Vendas.RegioesVenda.*`

---

## Campos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|:-----------:|-----------:|
| `id` | Guid | Auto | Identificador único |
| `codigo` | int | Auto | Código auto-incremental |
| `nome` | string | Sim | Nome da região |
| `descricao` | string? | Não | Descrição detalhada |
| `uFs` | string? | Não | UFs separadas por vírgula (ex: SP,RJ,MG) |
| `ativa` | bool | Auto | Criada como ativa |
| `vendedorResponsavelId` | Guid? | Não | FK para funcionário responsável |

---

## Regras

- UFs são armazenadas como string separada por vírgula (ex: `SP,RJ,MG`)
- Criada como ativa por padrão
- O vendedor responsável é opcional — a região pode existir sem vendedor atribuído
- Usada nos relatórios "Vendas por Região" e nas metas de venda por região
