-- Remove as tabelas antigas, se existirem
DROP TABLE IF EXISTS item_serviço;
DROP TABLE IF EXISTS ordem_serviço;
DROP TABLE IF EXISTS serviço;
DROP TABLE IF EXISTS veiculo;
DROP TABLE IF EXISTS cliente;

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(50),
    telefone VARCHAR(20)
);

CREATE TABLE veiculo (
    id_veiculo INT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE,
    modelo VARCHAR(20),
    ano INT,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE servico (
    id_servico INT PRIMARY KEY,
    descricao VARCHAR(50),
    preco DECIMAL(10,2)
);

CREATE TABLE ordem_servico (
    id_ordem INT PRIMARY KEY,
    data DATE,
    id_veiculo INT,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

CREATE TABLE item_servico (
    id_ordem INT,
    id_servico INT,
    quantidade INT,
    PRIMARY KEY (id_ordem, id_servico),
    FOREIGN KEY (id_ordem) REFERENCES ordem_servico(id_ordem),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

-- Clientes
INSERT INTO cliente VALUES (1, 'João Oliveira', '99999-1111');
INSERT INTO cliente VALUES (2, 'Maria Oliveira','98888-2222');

-- Veículos
INSERT INTO veiculo VALUES (1, 'ABC1234', 'Civic', 2018, 1);
INSERT INTO veiculo VALUES (2, 'XYZ5678', 'Corolla', 2020, 2);

-- Serviços
INSERT INTO servico VALUES (1, 'Troca de óleo', 150.00);
INSERT INTO servico VALUES (2, 'Revisão completa', 350.00);

-- Ordens de Serviço
INSERT INTO ordem_servico VALUES (1, '2025-11-01', 1);
INSERT INTO ordem_servico VALUES (2, '2025-11-02', 2);

-- Itens de Serviço
INSERT INTO item_servico VALUES (1,1,1);
INSERT INTO item_servico VALUES (1,2,1);
INSERT INTO item_servico VALUES (2,1,1);
INSERT INTO item_servico VALUES (2,2,2);

-- Recuperações simples com SELECT
SELECT * FROM cliente;
SELECT * FROM veiculo;
SELECT * FROM servico;
SELECT * FROM ordem_servico;
SELECT * FROM item_servico;

SELECT * FROM veiculo
WHERE modelo = 'Corolla';

SELECT 
    id_servico,
    descricao,
    preco,
    (preco * 1.1) AS preco_com_acrescimo
FROM servico;

SELECT * FROM servico
ORDER BY preco DESC;

SELECT 
    id_ordem,
    SUM(quantidade) AS total_itens
FROM item_servico
GROUP BY id_ordem
HAVING total_itens > 1;

SELECT 
    os.id_ordem,
    c.nome AS cliente,
    v.modelo AS veiculo,
    s.descricao AS servico,
    s.preco,
    isv.quantidade,
    (s.preco * isv.quantidade) AS valor_total
FROM ordem_servico os
JOIN veiculo v ON os.id_veiculo = v.id_veiculo
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN item_servico isv ON os.id_ordem = isv.id_ordem
JOIN servico s ON isv.id_servico = s.id_servico
ORDER BY os.id_ordem;

-- Perguntas que podem ser respondidas com as consultas:
-- 1) Quais são os serviços oferecidos, organizando do mais caro para o mais barato?
-- 2) Quais serviços foram realizados em cada ordem, incluindo o nome do cliente, modelo do veículo e valor total?