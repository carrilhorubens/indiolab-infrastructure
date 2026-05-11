# PostgreSQL - Languages

## O que são Languages?

Languages (linguagens procedurais) são extensões que permitem escrever funções,
procedures, triggers e outros objetos programáveis no PostgreSQL usando
linguagens além do SQL puro. Cada linguagem fornece um ambiente de execução
dentro do servidor PostgreSQL, permitindo lógica imperativa, estruturas de
controle, manipulação de exceções e acesso a recursos do sistema.

O PostgreSQL suporta nativamente o SQL e o PL/pgSQL, e permite adicionar
diversas outras linguagens através de extensões.

---

## Categorias de Linguagens

### Linguagens Confiáveis (Trusted)
Executam em um ambiente restrito e seguro. Não têm acesso ao sistema de
arquivos, rede ou outros recursos do SO. Podem ser instaladas por qualquer
superuser e usadas por usuários comuns com permissão USAGE.

### Linguagens Não Confiáveis (Untrusted)
Têm acesso irrestrito ao sistema operacional. Identificadas pelo sufixo `u`
(ex: `plpython3u`, `plperlu`). Apenas superusers podem criar funções nestas
linguagens.

---

## Linguagens Disponíveis

| Linguagem | Tipo | Descrição |
|---|---|---|
| `sql` | Trusted | SQL puro — nativa, sempre disponível |
| `plpgsql` | Trusted | PL/pgSQL — linguagem procedural nativa do PostgreSQL |
| `plpython3u` | Untrusted | Python 3 |
| `plperlu` | Untrusted | Perl (irrestrito) |
| `plperl` | Trusted | Perl (restrito) |
| `pltclu` | Untrusted | Tcl (irrestrito) |
| `pltcl` | Trusted | Tcl (restrito) |
| `plv8` | Trusted | JavaScript (via V8 Engine) |
| `plr` | Untrusted | R (estatística) |
| `pljava` | Trusted | Java |
| `plsh` | Untrusted | Shell script |
| `plrust` | Trusted | Rust |

---

## Comandos Essenciais

### Listar linguagens instaladas no banco

```sql
SELECT
    lanname       AS linguagem,
    lanispl       AS eh_procedural,
    lanpltrusted  AS confiavel,
    lanplcallfoid::regproc AS handler,
    obj_description(oid, 'pg_language') AS descricao
FROM pg_language
ORDER BY lanname;
```

### Instalar uma linguagem

```sql
-- PL/pgSQL (geralmente já instalada)
CREATE EXTENSION IF NOT EXISTS plpgsql;

-- Python 3
CREATE EXTENSION IF NOT EXISTS plpython3u;

-- Perl
CREATE EXTENSION IF NOT EXISTS plperl;
CREATE EXTENSION IF NOT EXISTS plperlu;

-- Tcl
CREATE EXTENSION IF NOT EXISTS pltcl;

-- Forma alternativa (legada mas ainda funcional)
CREATE LANGUAGE plpgsql;
```

### Conceder permissão de uso

```sql
-- Permitir que um usuário use a linguagem
GRANT USAGE ON LANGUAGE plpgsql TO meu_usuario;

-- Revogar permissão
REVOKE USAGE ON LANGUAGE plpgsql FROM meu_usuario;
```

### Remover uma linguagem

```sql
DROP LANGUAGE IF EXISTS plpython3u;
DROP EXTENSION IF EXISTS plpython3u;
```

---

## PL/pgSQL — A Linguagem Principal

PL/pgSQL é a linguagem procedural nativa do PostgreSQL. É a escolha padrão
para funções, procedures e triggers pela sua integração nativa, performance
e facilidade de manutenção.

### Estrutura básica de uma função

```sql
CREATE OR REPLACE FUNCTION nome_funcao(param1 tipo1, param2 tipo2)
RETURNS tipo_retorno
LANGUAGE plpgsql AS $$
DECLARE
    variavel1 tipo;
    variavel2 tipo := valor_inicial;
BEGIN
    -- lógica aqui
    RETURN resultado;
EXCEPTION
    WHEN outros THEN
        RAISE NOTICE 'Erro: %', SQLERRM;
END;
$$;
```

### Estruturas de controle

```sql
CREATE OR REPLACE FUNCTION fn_classificar_pedido(p_valor NUMERIC)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_categoria TEXT;
BEGIN
    -- IF / ELSIF / ELSE
    IF p_valor < 100 THEN
        v_categoria := 'Pequeno';
    ELSIF p_valor < 1000 THEN
        v_categoria := 'Médio';
    ELSIF p_valor < 10000 THEN
        v_categoria := 'Grande';
    ELSE
        v_categoria := 'Corporativo';
    END IF;

    RETURN v_categoria;
END;
$$;

SELECT fn_classificar_pedido(500);
-- Resultado: Médio
```

### CASE expression

```sql
CREATE OR REPLACE FUNCTION fn_status_descricao(p_status TEXT)
RETURNS TEXT
LANGUAGE plpgsql AS $$
BEGIN
    RETURN CASE p_status
        WHEN 'P' THEN 'Pendente'
        WHEN 'A' THEN 'Aprovado'
        WHEN 'C' THEN 'Cancelado'
        WHEN 'E' THEN 'Entregue'
        ELSE 'Status desconhecido'
    END;
END;
$$;
```

### Loops

```sql
CREATE OR REPLACE FUNCTION fn_demo_loops()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
    i       INTEGER;
    v_rec   RECORD;
BEGIN
    -- Loop simples com EXIT
    i := 1;
    LOOP
        EXIT WHEN i > 5;
        RAISE NOTICE 'Loop simples: %', i;
        i := i + 1;
    END LOOP;

    -- FOR numérico
    FOR i IN 1..5 LOOP
        RAISE NOTICE 'FOR numérico: %', i;
    END LOOP;

    -- FOR reverso
    FOR i IN REVERSE 5..1 LOOP
        RAISE NOTICE 'FOR reverso: %', i;
    END LOOP;

    -- FOR em query
    FOR v_rec IN SELECT id, nome FROM clientes LIMIT 5 LOOP
        RAISE NOTICE 'Cliente: % - %', v_rec.id, v_rec.nome;
    END LOOP;

    -- WHILE
    i := 1;
    WHILE i <= 3 LOOP
        RAISE NOTICE 'WHILE: %', i;
        i := i + 1;
    END LOOP;
END;
$$;
```

### Tratamento de exceções

```sql
CREATE OR REPLACE FUNCTION fn_buscar_cliente(p_id BIGINT)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    v_nome TEXT;
BEGIN
    SELECT nome INTO STRICT v_nome
    FROM clientes
    WHERE id = p_id;

    RETURN v_nome;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE WARNING 'Cliente % não encontrado', p_id;
        RETURN NULL;
    WHEN TOO_MANY_ROWS THEN
        RAISE EXCEPTION 'Múltiplos clientes encontrados para id %', p_id;
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro inesperado: % — %', SQLSTATE, SQLERRM;
END;
$$;
```

### Procedure (PostgreSQL 11+)

```sql
CREATE OR REPLACE PROCEDURE proc_fechar_pedidos_expirados(p_dias INTEGER DEFAULT 30)
LANGUAGE plpgsql AS $$
DECLARE
    v_qtd INTEGER;
BEGIN
    UPDATE pedidos
    SET status = 'cancelado',
        cancelado_em = NOW()
    WHERE status = 'pendente'
      AND criado_em < NOW() - (p_dias || ' days')::interval;

    GET DIAGNOSTICS v_qtd = ROW_COUNT;

    RAISE NOTICE '% pedidos cancelados.', v_qtd;

    COMMIT;
END;
$$;

-- Chamar a procedure
CALL proc_fechar_pedidos_expirados(60);
```

### Função que retorna tabela

```sql
CREATE OR REPLACE FUNCTION fn_relatorio_vendas(
    p_inicio DATE,
    p_fim    DATE
)
RETURNS TABLE (
    mes         TEXT,
    qtd_pedidos BIGINT,
    faturamento NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT
        TO_CHAR(data_pedido, 'YYYY-MM')  AS mes,
        COUNT(*)::BIGINT                 AS qtd_pedidos,
        SUM(valor_total)                 AS faturamento
    FROM pedidos
    WHERE data_pedido BETWEEN p_inicio AND p_fim
    GROUP BY 1
    ORDER BY 1;
END;
$$;

SELECT * FROM fn_relatorio_vendas('2024-01-01', '2024-12-31');
```

---

## PL/Python — Python no PostgreSQL

### Instalação

```bash
# Ubuntu/Debian
apt install postgresql-plpython3-16
```

```sql
CREATE EXTENSION plpython3u;
```

### Exemplos PL/Python

```sql
-- Função simples em Python
CREATE OR REPLACE FUNCTION fn_py_hello(nome TEXT)
RETURNS TEXT
LANGUAGE plpython3u AS $$
return f"Olá, {nome}! Esta função foi escrita em Python."
$$;

SELECT fn_py_hello('Rubens');
```

```sql
-- Consultar o banco de dentro do Python
CREATE OR REPLACE FUNCTION fn_py_total_clientes()
RETURNS BIGINT
LANGUAGE plpython3u AS $$
result = plpy.execute("SELECT COUNT(*) AS total FROM clientes")
return result[0]['total']
$$;
```

```sql
-- Usar bibliotecas Python (requests, pandas, etc.)
CREATE OR REPLACE FUNCTION fn_py_processar_json(p_json TEXT)
RETURNS TEXT
LANGUAGE plpython3u AS $$
import json

dados = json.loads(p_json)
dados['processado'] = True
dados['total_campos'] = len(dados)
return json.dumps(dados, ensure_ascii=False)
$$;

SELECT fn_py_processar_json('{"nome": "Rubens", "cidade": "Maringá"}');
```

```sql
-- Função com tratamento de erro Python
CREATE OR REPLACE FUNCTION fn_py_calcular_juros(
    p_valor    NUMERIC,
    p_taxa     NUMERIC,
    p_meses    INTEGER
)
RETURNS NUMERIC
LANGUAGE plpython3u AS $$
try:
    if p_taxa <= 0 or p_meses <= 0:
        raise ValueError("Taxa e meses devem ser positivos")
    resultado = float(p_valor) * ((1 + float(p_taxa)/100) ** p_meses)
    return round(resultado, 2)
except Exception as e:
    plpy.error(f"Erro no cálculo: {str(e)}")
$$;

SELECT fn_py_calcular_juros(1000, 1.5, 12);
```

---

## PL/Perl — Perl no PostgreSQL

```sql
CREATE EXTENSION plperl;

-- Função em Perl trusted
CREATE OR REPLACE FUNCTION fn_perl_inverter(p_texto TEXT)
RETURNS TEXT
LANGUAGE plperl AS $$
my $texto = shift;
return scalar reverse $texto;
$$;

SELECT fn_perl_inverter('PostgreSQL');
-- Resultado: LQSertsoP
```

```sql
-- Processar array com Perl
CREATE OR REPLACE FUNCTION fn_perl_formatar_cpf(p_numeros TEXT)
RETURNS TEXT
LANGUAGE plperl AS $$
my $n = shift;
$n =~ s/\D//g;  # Remove não-dígitos
$n =~ s/(\d{3})(\d{3})(\d{3})(\d{2})/$1.$2.$3-$4/;
return $n;
$$;

SELECT fn_perl_formatar_cpf('12345678901');
-- Resultado: 123.456.789-01
```

---

## SQL — Funções SQL Puras

Para lógica simples, funções SQL puras são mais eficientes que PL/pgSQL
pois o otimizador pode fazer inline delas.

```sql
-- Função SQL simples (inlinável pelo otimizador)
CREATE OR REPLACE FUNCTION fn_preco_com_desconto(
    p_preco    NUMERIC,
    p_desconto NUMERIC
)
RETURNS NUMERIC
LANGUAGE sql
IMMUTABLE STRICT AS $$
    SELECT p_preco * (1 - p_desconto / 100);
$$;

-- Função SQL que retorna conjunto
CREATE OR REPLACE FUNCTION fn_clientes_por_estado(p_estado CHAR(2))
RETURNS SETOF clientes
LANGUAGE sql
STABLE AS $$
    SELECT * FROM clientes WHERE estado = p_estado ORDER BY nome;
$$;
```

---

## Atributos de Volatilidade

Importante declarar corretamente para otimização:

| Atributo | Significado | Uso |
|---|---|---|
| `VOLATILE` | Pode retornar resultados diferentes a cada chamada | Padrão — funções com efeitos colaterais |
| `STABLE` | Retorna o mesmo resultado para os mesmos parâmetros dentro da mesma transação | Funções que consultam o banco |
| `IMMUTABLE` | Sempre retorna o mesmo resultado para os mesmos parâmetros | Funções matemáticas/de formatação puras |

```sql
-- IMMUTABLE: cálculo puro, sem consulta ao banco
CREATE FUNCTION calcular_imc(peso NUMERIC, altura NUMERIC)
RETURNS NUMERIC LANGUAGE sql IMMUTABLE AS $$
    SELECT ROUND(peso / (altura * altura), 2);
$$;

-- STABLE: consulta banco mas não modifica
CREATE FUNCTION buscar_preco(p_produto_id INT)
RETURNS NUMERIC LANGUAGE sql STABLE AS $$
    SELECT preco FROM produtos WHERE id = p_produto_id;
$$;

-- VOLATILE: modifica dados ou usa NOW(), random(), etc.
CREATE FUNCTION registrar_acesso(p_usuario TEXT)
RETURNS void LANGUAGE sql VOLATILE AS $$
    INSERT INTO log_acessos (usuario, acessado_em)
    VALUES (p_usuario, NOW());
$$;
```

---

## Boas Práticas

| Prática | Recomendação |
|---|---|
| Linguagem padrão | Use PL/pgSQL para a maioria das funções |
| Funções simples | Prefira SQL puro para funções sem lógica complexa |
| Python/Perl | Use apenas quando necessitar de bibliotecas externas |
| Untrusted | Restrinja ao máximo o uso de linguagens `*u` (untrusted) |
| Volatilidade | Sempre declare IMMUTABLE ou STABLE quando aplicável |
| SECURITY DEFINER | Use com cautela — execute como dono da função |
| Documentação | Comente funções com `COMMENT ON FUNCTION` |

```sql
-- Documentar uma função
COMMENT ON FUNCTION fn_relatorio_vendas(DATE, DATE)
IS 'Retorna relatório de vendas agrupado por mês entre as datas fornecidas.';
```

---

## Referências

- [PostgreSQL Docs - PL/pgSQL](https://www.postgresql.org/docs/current/plpgsql.html)
- [PostgreSQL Docs - PL/Python](https://www.postgresql.org/docs/current/plpython.html)
- [PostgreSQL Docs - PL/Perl](https://www.postgresql.org/docs/current/plperl.html)
- [PostgreSQL Docs - SQL Functions](https://www.postgresql.org/docs/current/sql-createfunction.html)
- [PostgreSQL Docs - Procedural Languages](https://www.postgresql.org/docs/current/xplang.html)
