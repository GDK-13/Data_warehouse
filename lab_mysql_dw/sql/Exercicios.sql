USE dw_superstore;

#Exercicio 1
CREATE TABLE IF NOT EXISTS DIM_GERENTE (
    sk_gerente INT NOT NULL AUTO_INCREMENT,
    nome_gerente VARCHAR(80) NOT NULL,
    regiao VARCHAR(20) NOT NULL,
    PRIMARY KEY (sk_gerente),
    UNIQUE KEY uq_regiao (regiao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Adiciona a coluna na Tabela Fato
ALTER TABLE FATO_VENDAS ADD COLUMN sk_gerente INT NOT NULL AFTER sk_envio;
ALTER TABLE FATO_VENDAS ADD CONSTRAINT fk_fv_gerente FOREIGN KEY (sk_gerente) REFERENCES DIM_GERENTE(sk_gerente);

-- Lucro total por gerente regional no ano de 2014
SELECT 
    g.nome_gerente,
    g.regiao,
    ROUND(SUM(f.vlr_lucro), 2) AS lucro_total
FROM FATO_VENDAS f
JOIN DIM_GERENTE g ON f.sk_gerente = g.sk_gerente
JOIN DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
WHERE t.ano = 2014
GROUP BY g.nome_gerente, g.regiao
ORDER BY lucro_total DESC;


#Exercicio 2

-- Taxa de devolução por subcategoria no segmento 'Home Office'
SELECT 
    p.subcategoria,
    COUNT(DISTINCT CASE WHEN f.flag_retorno = 1 THEN f.nk_pedido END) AS pedidos_devolvidos,
    COUNT(DISTINCT f.nk_pedido) AS total_pedidos,
    ROUND(
        COUNT(DISTINCT CASE WHEN f.flag_retorno = 1 THEN f.nk_pedido END) / 
        COUNT(DISTINCT f.nk_pedido) * 100, 2
    ) AS taxa_devolucao_pct
FROM FATO_VENDAS f
JOIN DIM_PRODUTO p ON f.sk_produto = p.sk_produto
JOIN DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
WHERE c.segmento = 'Home Office'
GROUP BY p.subcategoria
ORDER BY taxa_devolucao_pct DESC;


#Exercicio 3

-- Subtotais em 3 níveis: Ano > Trimestre > Mês
SELECT 
    COALESCE(CAST(t.ano AS CHAR), 'TOTAL GERAL') AS ano,
    COALESCE(CAST(t.trimestre AS CHAR), 'Subtotal Ano') AS trimestre,
    COALESCE(CAST(t.mes AS CHAR), 'Subtotal Trimestre') AS mes,
    COUNT(DISTINCT f.nk_pedido) AS volume_pedidos,
    ROUND(SUM(f.vlr_vendas), 2) AS receita_total
FROM FATO_VENDAS f
JOIN DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
GROUP BY t.ano, t.trimestre, t.mes WITH ROLLUP
ORDER BY 
    t.ano IS NULL, t.ano, 
    t.trimestre IS NULL, t.trimestre, 
    t.mes IS NULL, t.mes;
    
    
#Exercicio 4

-- Ticket Médio ponderado por Ship Mode e Segmento
SELECT 
    e.modalidade_envio,
    c.segmento,
    COUNT(DISTINCT f.nk_pedido) AS pedidos,
    ROUND(SUM(f.vlr_vendas), 2) AS receita,
    ROUND(SUM(f.vlr_vendas) / COUNT(DISTINCT f.nk_pedido), 2) AS ticket_medio
FROM FATO_VENDAS f
JOIN DIM_ENVIO e ON f.sk_envio = e.sk_envio
JOIN DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
GROUP BY e.modalidade_envio, c.segmento
ORDER BY ticket_medio DESC;

	