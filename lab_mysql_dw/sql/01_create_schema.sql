CREATE DATABASE IF NOT EXISTS dw_superstore
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE dw_superstore;
-- Confirmar criação
SHOW DATABASES LIKE 'dw_superstore';	

USE dw_superstore;

-- ── Dimensão Tempo ──────────────────────────────
CREATE TABLE IF NOT EXISTS DIM_TEMPO (
    sk_tempo INT NOT NULL AUTO_INCREMENT,
    data_completa DATE NOT NULL,
    dia TINYINT NOT NULL,
    mes TINYINT NOT NULL,
    nome_mes VARCHAR(255) NOT NULL,
    trimestre TINYINT NOT NULL,
    ano SMALLINT NOT NULL,
    semana_ano TINYINT NOT NULL,
    dia_semana TINYINT NOT NULL,
    nome_dia VARCHAR(255) NOT NULL,
    flag_fds TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (sk_tempo),
    UNIQUE KEY uq_data (data_completa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Dimensão Produto ─────────────────────────────
CREATE TABLE IF NOT EXISTS DIM_PRODUTO (
    sk_produto INT NOT NULL AUTO_INCREMENT,
    nk_produto VARCHAR(50) NOT NULL,
    nome_produto VARCHAR(255) NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    subcategoria VARCHAR(255) NOT NULL,
    PRIMARY KEY (sk_produto),
    UNIQUE KEY uq_nk_produto (nk_produto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Dimensão Cliente ─────────────────────────────	
CREATE TABLE IF NOT EXISTS DIM_CLIENTE (
    sk_cliente INT NOT NULL AUTO_INCREMENT,
    nk_cliente VARCHAR(20) NOT NULL,
    nome_cliente VARCHAR(80) NOT NULL,
    segmento VARCHAR(20) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    regiao VARCHAR(20) NOT NULL,
    pais VARCHAR(30) NOT NULL DEFAULT 'United States',
    PRIMARY KEY (sk_cliente),
    UNIQUE KEY uq_nk_cliente (nk_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Dimensão Envio ───────────────────────────────
CREATE TABLE IF NOT EXISTS DIM_ENVIO (
    sk_envio INT NOT NULL AUTO_INCREMENT,
    modalidade_envio VARCHAR(20) NOT NULL,
    prazo_medio_dias DECIMAL(4,1),
    PRIMARY KEY (sk_envio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Tabela Fato ──────────────────────────────────
CREATE TABLE IF NOT EXISTS FATO_VENDAS (
    id_fato INT NOT NULL AUTO_INCREMENT,
    nk_pedido VARCHAR(25) NOT NULL,
    sk_cliente INT NOT NULL,
    sk_produto INT NOT NULL,
    sk_tempo INT NOT NULL,
    sk_envio INT NOT NULL,
    vlr_vendas DECIMAL(10,4) NOT NULL,
    vlr_lucro DECIMAL(10,4) NOT NULL,
    vlr_desconto DECIMAL(6,4) NOT NULL DEFAULT 0,
    qtd SMALLINT NOT NULL,
    flag_retorno TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_fato),
    KEY fk_cliente (sk_cliente),
    KEY fk_produto (sk_produto),
    KEY fk_tempo (sk_tempo),
    KEY fk_envio (sk_envio),
    CONSTRAINT fk_fv_cliente FOREIGN KEY (sk_cliente) REFERENCES DIM_CLIENTE(sk_cliente),
    CONSTRAINT fk_fv_produto FOREIGN KEY (sk_produto) REFERENCES DIM_PRODUTO(sk_produto),
    CONSTRAINT fk_fv_tempo FOREIGN KEY (sk_tempo) REFERENCES DIM_TEMPO(sk_tempo),
    CONSTRAINT fk_fv_envio FOREIGN KEY (sk_envio) REFERENCES DIM_ENVIO(sk_envio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;