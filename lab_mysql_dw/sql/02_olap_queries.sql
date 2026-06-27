-- OLAP Queries - Análises analíticas
USE dw_superstore;
-- Roll-Up: agrega de dia para trimestre e ano
SELECT
t.ano,
t.trimestre,
COUNT(DISTINCT f.nk_pedido) AS qtd_pedidos,
SUM(f.qtd) AS itens_vendidos,
ROUND(SUM(f.vlr_vendas), 2) AS receita_total,
ROUND(SUM(f.vlr_lucro), 2) AS lucro_total,
ROUND(AVG(f.vlr_vendas), 2) AS ticket_medio,
ROUND(SUM(f.vlr_lucro)
/ NULLIF(SUM(f.vlr_vendas),0) * 100, 1) AS margem_pct
FROM FATO_VENDAS f
JOIN DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
GROUP BY t.ano, t.trimestre
ORDER BY t.ano, t.trimestre;

SELECT
    p.categoria,
    p.subcategoria,
    COUNT(DISTINCT f.nk_pedido) AS qtd_pedidos,
    SUM(f.qtd) AS itens_vendidos,
    ROUND(SUM(f.vlr_vendas), 2) AS receita,
    ROUND(SUM(f.vlr_lucro), 2) AS lucro,
    ROUND(
        SUM(f.vlr_lucro) / NULLIF(SUM(f.vlr_vendas), 0) * 100, 
        1
    ) AS margem_pct
FROM 
    FATO_VENDAS f
JOIN 
    DIM_PRODUTO p ON f.sk_produto = p.sk_produto
JOIN 
    DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
WHERE 
    t.ano = 2014
GROUP BY 
    p.categoria, 
    p.subcategoria
ORDER BY 
    receita DESC
LIMIT 10;


SELECT
    c.regiao,
    c.estado,
    t.ano,
    COUNT(DISTINCT f.nk_pedido) AS pedidos,
    ROUND(SUM(f.vlr_vendas), 2) AS receita,
    ROUND(SUM(f.vlr_lucro), 2) AS lucro
FROM 
    FATO_VENDAS f
JOIN 
    DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
JOIN 
    DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
WHERE 
    c.segmento = 'Corporate'
GROUP BY 
    c.regiao, 
    c.estado, 
    t.ano;
    

SELECT
    t.ano,
    t.trimestre,
    p.subcategoria,
    c.regiao,
    COUNT(DISTINCT f.nk_pedido) AS pedidos,
    ROUND(SUM(f.vlr_vendas), 2) AS receita,
    ROUND(AVG(f.vlr_desconto) * 100, 1) AS desconto_medio_pct
FROM 
    FATO_VENDAS f
JOIN 
    DIM_PRODUTO p ON f.sk_produto = p.sk_produto
JOIN 
    DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
JOIN 
    DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
WHERE 
    p.categoria = 'Technology'
    AND c.regiao = 'West'
    AND t.ano IN (2013, 2014)
GROUP BY 
    t.ano, 
    t.trimestre, 
    p.subcategoria, 
    c.regiao
ORDER BY 
    t.ano, 
    t.trimestre, 
    receita DESC;

WITH vendas_mensais AS (
    SELECT
        t.ano, 
        t.mes, 
        t.nome_mes,
        c.regiao,
        ROUND(SUM(f.vlr_vendas), 2) AS receita
    FROM 
        FATO_VENDAS f
    JOIN 
        DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
    JOIN 
        DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
    GROUP BY 
        t.ano, 
        t.mes, 
        t.nome_mes, 
        c.regiao
),
com_rank AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY ano, mes ORDER BY receita DESC) AS rank_regiao,
        LAG(receita) OVER (PARTITION BY regiao ORDER BY ano, mes) AS receita_mes_ant
    FROM 
        vendas_mensais
)
SELECT
    ano, 
    mes, 
    nome_mes, 
    regiao, 
    receita, 
    rank_regiao,
    ROUND(
        (receita - receita_mes_ant) / NULLIF(receita_mes_ant, 0) * 100, 
        1
    ) AS crescimento_pct
FROM 
    com_rank
ORDER BY 
    ano, 
    mes, 
    rank_regiao;
    

-- ROLLUP: subtotais por categoria > região > total geral
SELECT
    COALESCE(p.categoria, 'TOTAL GERAL') AS categoria,
    COALESCE(c.regiao, '-- SUBTOTAL --') AS regiao,
    ROUND(SUM(f.vlr_vendas), 2) AS receita_total,
    ROUND(SUM(f.vlr_lucro), 2) AS lucro_total,
    COUNT(DISTINCT f.nk_pedido) AS pedidos
FROM 
    FATO_VENDAS f
JOIN 
    DIM_PRODUTO p ON f.sk_produto = p.sk_produto
JOIN 
    DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
GROUP BY 
    p.categoria, 
    c.regiao WITH ROLLUP;

-- Queries para BI e relatórios
