
						-- 🟢 Iniciante (Básico de SQL e MySQL)
                        
                        

CREATE TABLE clientes
(ID INT AUTO_INCREMENT,
NOME VARCHAR(100),
EMAIL VARCHAR(100),
DATA_CADASTRO DATE,
PRIMARY KEY(ID));

ALTER TABLE clientes
ADD COLUMN TELEFONE varchar(20);

INSERT INTO clientes (nome, email, data_cadastro, telefone) VALUES
('João da Silva', 'joao.silva@email.com', '2025-05-01', '(11) 98765-4321'),
('Maria Oliveira', 'maria.oliveira@email.com', '2025-05-02', '(21) 98888-1234'),
('Carlos Souza', 'carlos.souza@email.com', '2025-05-03', '(31) 99999-4567'),
('Ana Lima', 'ana.lima@email.com', '2025-05-04', '(41) 97777-9876'),
('Fernanda Costa', 'fernanda.costa@email.com', '2025-05-05', '(51) 96666-6543');

-- 🔸 Consultas básicas (SELECT)

SELECT * FROM clientes;

SELECT nome, email FROM clientes;

SELECT * FROM CLIENTES ORDER BY NOME;

SELECT * FROM clientes limit 3;

SELECT * FROM clientes WHERE nome LIKE "%j%";



				-- 🟡 Intermediário (Relacionamentos e Funções)
                
                

-- 🔸 Chaves estrangeiras e JOINs

CREATE TABLE pedidos(
id INT AUTO_INCREMENT,
cliente_id INT,
data_pedido DATE,
valor_total DECIMAL(10,2),
PRIMARY KEY(ID, cliente_id));

ALTER TABLE pedidos ADD CONSTRAINT fk_cliente_pedido
FOREIGN KEY (cliente_id) REFERENCES clientes(ID);

INSERT INTO pedidos (cliente_id, data_pedido, valor_total) VALUES
(1, '2025-05-20', 150.00),
(2, '2025-05-21', 90.00),
(1, '2025-05-22', 200.00),
(3, '2025-05-23', 75.50);

SELECT * FROM clientes A
INNER JOIN pedidos B
ON a.id = b.cliente_id;

SELECT A.nome, B.data_pedido FROM clientes A
INNER JOIN pedidos B
ON A.id = B.cliente_id;

SELECT * FROM pedidos WHERE valor_total > 100;

SELECT A.nome, B.valor_total FROM clientes A
RIGHT JOIN pedidos B
ON A.id = B.cliente_id;

SELECT A.nome, B.data_pedido FROM clientes A
LEFT JOIN pedidos B
ON A.id = B.cliente_id;

-- 🔸 Funções agregadas


SELECT COUNT(*) FROM clientes;

SELECT A.nome, SUM(B.valor_total) AS soma_dos_produtos FROM clientes A
RIGHT JOIN pedidos B
ON A.id = B.cliente_id
GROUP BY A.nome;

SELECT A.nome, MAX(B.valor_total) AS valor_maximo FROM clientes A
RIGHT JOIN pedidos B
ON A.id = B.cliente_id
GROUP BY A.nome
LIMIT 1;

SELECT
	A.NOME,
	B.data_pedido,
	COUNT(B.id)pedidos,
	(SELECT COUNT(*) FROM pedidos) AS total_dos_pedidos FROM clientes A
INNER JOIN pedidos B
	ON A.id = B.cliente_id
GROUP BY A.nome, B.data_pedido;


					-- 🔴 Avançado (Subqueries, Views, Procedures, etc.)
                    
                    
	-- 🔸 Subqueries



SELECT DISTINCT A.nome
FROM clientes A
INNER JOIN pedidos B ON A.id = B.cliente_id
WHERE B.valor_total > (
	SELECT AVG(valor_total) FROM pedidos);
    
    
SELECT c.nome
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.data_pedido = (
  SELECT MIN(p2.data_pedido)
  FROM pedidos p2
  WHERE p2.cliente_id = p.cliente_id
)
AND p.valor_total > 100;


	-- 🔸 Views
    

CREATE VIEW `vw_relatorio_clientes` AS
SELECT
	A.NOME,
	COUNT(B.id) AS total_pedido,
    SUM(B.valor_total) AS soma_valores
	FROM clientes A
INNER JOIN pedidos B
	ON A.id = B.cliente_id
GROUP BY A.nome;

SELECT * FROM vw_relatorio_clientes;


  -- 🔸 Procedures e Funções Armazenadas
  
  
  USE `loja_virtual`;
DROP procedure IF EXISTS `inserir_pedido`;

DELIMITER $$
USE `loja_virtual`$$
CREATE PROCEDURE `inserir_pedido` 
(p_cliente_id INT,
p_data_pedido DATE,
p_valor_total DECIMAL(10,2))
BEGIN
	INSERT INTO pedidos (cliente_id , data_pedido, valor_total)
    VALUES (p_cliente_id, p_data_pedido, p_valor_total);
END$$

DELIMITER ;

CALL inserir_pedido('3', '2025-05-30', 250);

SELECT * FROM PEDIDOS;


DELIMITER //
CREATE FUNCTION aplicar_desconto(valor DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN valor * 0.9;
END //

DELIMITER ;

SELECT aplicar_desconto(200) AS desconto;



ALTER TABLE clientes ADD COLUMN data_modificacao DATETIME;


DELIMITER //

CREATE TRIGGER atualiza_data_modificacao
BEFORE UPDATE ON clientes
FOR EACH ROW
BEGIN
  SET NEW.data_modificacao = NOW();
END //

DELIMITER ;

UPDATE clientes
SET telefone = '(11) 91234-5678'
WHERE id = 1;

UPDATE clientes
SET email = 'maria.neto@email.com'
WHERE id = 2;


SELECT * FROM clientes;