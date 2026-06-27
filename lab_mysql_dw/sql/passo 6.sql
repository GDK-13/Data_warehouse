-- Executar no MySQL Workbench
USE dw_superstore;

ALTER TABLE DIM_PRODUTO MODIFY COLUMN nome_produto VARCHAR(255) NOT NULL;


CREATE TABLE IF NOT EXISTS DIM_META (
sk_meta INT NOT NULL AUTO_INCREMENT,
regiao VARCHAR(20) NOT NULL,
categoria VARCHAR(30) NOT NULL,	
meta_vendas DECIMAL(12,2) NOT NULL,
meta_lucro DECIMAL(12,2) NOT NULL,
ano_referencia SMALLINT NOT NULL,
PRIMARY KEY (sk_meta),
UNIQUE KEY uq_meta (regiao, categoria, ano_referencia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;	


SELECT
p.categoria,
c.regiao,
m.meta_vendas,
ROUND(SUM(f.vlr_vendas), 2) AS realizado,
ROUND(SUM(f.vlr_vendas)
/ NULLIF(m.meta_vendas, 0) * 100, 1) AS atingimento_pct,
ROUND(SUM(f.vlr_vendas) - m.meta_vendas, 2) AS gap
FROM FATO_VENDAS f
JOIN DIM_PRODUTO p ON f.sk_produto = p.sk_produto
JOIN DIM_CLIENTE c ON f.sk_cliente = c.sk_cliente
JOIN DIM_TEMPO t ON f.sk_tempo = t.sk_tempo
JOIN DIM_META m ON m.regiao = c.regiao
AND m.categoria = p.categoria
AND m.ano_referencia = t.ano

WHERE t.ano = 2014
GROUP BY p.categoria, c.regiao, m.meta_vendas
ORDER BY atingimento_pct DESC;