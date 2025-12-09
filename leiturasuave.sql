CREATE DATABASE livraria_suave;

USE livraria_suave;

CREATE TABLE autores
(id_autor INT AUTO_INCREMENT PRIMARY KEY,
nome_autor VARCHAR(255));

CREATE TABLE editoras
(id_editora INT AUTO_INCREMENT PRIMARY KEY,
nome_editora VARCHAR(255));

CREATE TABLE clientes
(id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome_cliente VARCHAR(255),
email VARCHAR(255));

CREATE TABLE pedidos
  (id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  data_pedido DATE,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente));

CREATE TABLE livros
(id_livro INT AUTO_INCREMENT,
titulo VARCHAR(255),
id_autor INT ,
id_editora INT ,
preco FLOAT(10,2),
estoque INT,
PRIMARY KEY(id_livro),
FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
FOREIGN KEY (id_editora) REFERENCES editoras(id_editora));


CREATE TABLE itens_pedido 
  (id_pedido INT,
  id_livro INT,
  quantidade INT,
  PRIMARY KEY (id_pedido, id_livro),
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_livro) REFERENCES livros(id_livro));
  
  
  INSERT INTO autores (nome_autor) VALUES
('George Orwell'),
('J.K. Rowling'),
('Machado de Assis'),
('Agatha Christie'),
('Clarice Lispector'),
('Stephen King'),
('J.R.R. Tolkien'),
('Paulo Coelho'),
('Isaac Asimov'),
('Cecília Meireles');

  
  INSERT INTO editoras (nome_editora) VALUES
('Companhia das Letras'),
('Rocco'),
('HarperCollins'),
('Intrínseca'),
('Planeta'),
('Record'),
('Nova Fronteira'),
('DarkSide Books'),
('Sextante'),
('Aleph');

  
  INSERT INTO livros (titulo, id_autor, id_editora, preco, estoque) VALUES
('1984', 1, 1, 39.90, 15),
('Harry Potter e a Pedra Filosofal', 2, 2, 59.90, 10),
('Dom Casmurro', 3, 3, 29.90, 20),
('Assassinato no Expresso Oriente', 4, 4, 34.50, 12),
('A Hora da Estrela', 5, 5, 28.00, 25),
('O Iluminado', 6, 6, 49.90, 18),
('O Senhor dos Anéis', 7, 7, 89.90, 8),
('O Alquimista', 8, 8, 35.00, 30),
('Fundação', 9, 9, 45.00, 20),
('Ou Isto ou Aquilo', 10, 10, 22.90, 40);


INSERT INTO clientes (nome_cliente, email) VALUES
('Ana Souza', 'ana@email.com'),
('João Oliveira', 'joao@email.com'),
('Beatriz Lima', 'beatriz@email.com'),
('Carlos Mendes', 'carlos@email.com'),
('Fernanda Castro', 'fernanda@email.com');


INSERT INTO pedidos (id_cliente, data_pedido) VALUES
(1, '2025-05-20'),
(2, '2025-05-21'),
(3, '2025-05-22'),
(4, '2025-05-23'),
(5, '2025-05-24');


INSERT INTO itens_pedido (id_pedido, id_livro, quantidade) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(2, 4, 2),
(3, 5, 1),
(3, 6, 1),
(3, 7, 1),
(4, 1, 1),
(4, 8, 3),
(5, 9, 2),
(5, 10, 2);

  
  -- ---------------------------------------------------------------------------------------
  
										-- 📘 Exercício
  
  -- 1-----------------------
  
SELECT * FROM livros;

SELECT A.nome_cliente, B.id_pedido, B.data_pedido
FROM clientes A 
INNER JOIN pedidos B
ON A.id_cliente = B.id_cliente;

-- 2-----------------------

SELECT A.titulo, B.id_pedido, A.preco, B.quantidade,
(A.preco * B.quantidade) AS subtotal
FROM livros A 
INNER JOIN itens_pedido B
ON A.id_livro = B.id_livro;

-- 3-----------------------

SELECT A.nome_cliente, 
	SUM(D.preco * C.quantidade) AS total_gasto
FROM clientes A 
INNER JOIN pedidos B ON A.id_cliente = B.id_cliente
INNER JOIN itens_pedido C ON C.id_pedido = B.id_pedido 
INNER JOIN livros D ON D.id_livro = C.id_livro
GROUP BY A.nome_cliente;

-- 4-----------------------

SELECT 
  A.titulo, 
  A.estoque, 
  IFNULL(SUM(B.quantidade), 0) AS vendido,
  A.estoque - IFNULL(SUM(B.quantidade), 0) AS estoque_restante
FROM livros A 
LEFT JOIN itens_pedido B ON A.id_livro = B.id_livro
GROUP BY A.id_livro, A.titulo, A.estoque;



						-- ⚙️ Exercícios com PROCEDURE

-- 1-----------------------
 
USE `livraria_suave`;
DROP procedure IF EXISTS `cadastrar_cliente`;

DELIMITER $$
USE `livraria_suave`$$
CREATE PROCEDURE `cadastrar_cliente` (nome_cliente VARCHAR(100), email VARCHAR(150))
BEGIN
	INSERT INTO clientes (nome_cliente, email)
    VALUES (nome_cliente, email);
END$$

DELIMITER ;

CALL cadastrar_cliente("Maria Fernanda dos Santos", "MariaFernanda@gmail.com");

SELECT * FROM clientes;

-- 2-----------------------

USE `livraria_suave`;
DROP procedure IF EXISTS `atualizar_preco_livro`;

DELIMITER $$
USE `livraria_suave`$$
CREATE PROCEDURE `atualizar_preco_livro` (p_id_livro INT, p_novo_preco FLOAT(10,2))
BEGIN
	UPDATE livros 
    SET preco = p_novo_preco
    WHERE id_livro = p_id_livro;
END$$

DELIMITER ;

SELECT * FROM livros;

CALL atualizar_preco_livro(5, 44.90);

-- 3-----------------------

USE `livraria_suave`;
DROP procedure IF EXISTS `verificar_estoque`;

DELIMITER $$
USE `livraria_suave`$$
CREATE PROCEDURE `verificar_estoque` (p_id_livro INT)
BEGIN
	SELECT titulo, estoque
    FROM LIVROS WHERE id_livro = p_id_livro;
END$$

DELIMITER ;

CALL verificar_estoque(3);

-- 4-----------------------

USE `livraria_suave`;
DROP procedure IF EXISTS `relatorio_pedidos_cliente`;

DELIMITER $$
USE `livraria_suave`$$
CREATE PROCEDURE `relatorio_pedidos_cliente` (id_cliente INT)
BEGIN
	SELECT B.id_pedido, C.data_pedido, A.titulo, B.quantidade, A.preco,
    (B.quantidade * A.preco) AS subTotal
    FROM livros A
    INNER JOIN itens_pedido B ON A.id_livro = B.id_livro
    INNER JOIN pedidos C ON C.id_pedido = B.id_pedido
     WHERE C.id_cliente = id_cliente;
END$$
DELIMITER ;

CALL relatorio_pedidos_cliente(2);  

-- 5-----------------------

USE `livraria_suave`;
DROP procedure IF EXISTS `baixar_estoque`;

DELIMITER $$
USE `livraria_suave`$$
CREATE PROCEDURE `baixar_estoque` (p_id_livro INT, quantidade_vendida INT)
BEGIN
	UPDATE livros 
    SET estoque = estoque - quantidade_vendida
    WHERE id_livro = p_id_livro;
END$$
DELIMITER ;

CALL baixar_estoque(2, 1);

SELECT * FROM LIVROS;


						-- ⚙️ Exercícios com TRIGGER


-- 1-----------------------

DELIMITER $$
CREATE TRIGGER tg_data_ultima_venda AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
	UPDATE livros
    SET data_ultima_venda = NOW()
    WHERE id_livro = NEW.id_livro;
END$$

DELIMITER ;

ALTER TABLE livros
ADD COLUMN data_ultima_venda DATETIME;


SELECT id_livro, titulo, data_ultima_venda
FROM livros
WHERE id_livro = 2;


-- 2-----------------------

DELIMITER $$
CREATE TRIGGER tg_bloquear_venda BEFORE INSERT ON itens_pedido
FOR EACH ROW
BEGIN
	DECLARE estoque_atual INT;
    
	SELECT estoque INTO estoque_atual
    FROM livros
    WHERE id_livro = NEW.id_livro;
		
		IF NEW.quantidade > estoque_atual THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para esta venda!';
		END IF;
END$$

DELIMITER ;

SELECT id_livro, titulo, estoque FROM livros WHERE id_livro = 2;

-- Valor com estoque maior para gerar o erro
INSERT INTO itens_pedido (id_pedido, id_livro, quantidade)
VALUES (5, 2, 20);  

 -- Valor dentro do estoque atual
INSERT INTO itens_pedido (id_pedido, id_livro, quantidade)
VALUES (5, 2, 2);  


-- 3-----------------------

DELIMITER $$
CREATE TRIGGER tg_atualizar_estoque_automatico AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
	UPDATE livros
    SET estoque = estoque - NEW.quantidade
    WHERE id_livro = NEW.id_livro;
END$$

DELIMITER ;

-- Vendo o estoque atual de um livro
SELECT id_livro, titulo, estoque FROM livros WHERE id_livro = 3;

-- Inserindo um item ao pedido 
INSERT INTO itens_pedido (id_pedido, id_livro, quantidade)
VALUES (2, 2, 2);

-- Vendo o estoque atual de um livro novamente!
SELECT id_livro, titulo, estoque FROM livros WHERE id_livro = 2;


-- 4-----------------------

DELIMITER $$
CREATE TRIGGER tg_cancelar_e_devolver_pedido AFTER DELETE ON itens_pedido
FOR EACH ROW
BEGIN
  UPDATE livros
  SET estoque = estoque + OLD.quantidade
  WHERE id_livro = OLD.id_livro;
END$$

DELIMITER ;


-- Estoque atual
SELECT id_livro, titulo, estoque FROM livros WHERE id_livro = 3;

-- Deletando um item de pedido
DELETE FROM itens_pedido
WHERE id_pedido = 5 AND id_livro = 3;

-- Veja o estoque novamente. Ele deve aumentar com a quantidade devolvida.


-- 5-----------------------


CREATE TABLE log_estoque
(id_log INT AUTO_INCREMENT PRIMARY KEY,
 id_livro INT,
 quantidade INT,
 tipo_acao ENUM('VENDA', 'CANCELAMENTO'),
 data_log DATETIME DEFAULT CURRENT_TIMESTAMP)


DELIMITER $$

CREATE TRIGGER tg_log_venda AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
  INSERT INTO log_estoque (id_livro, quantidade, tipo_acao)
  VALUES (NEW.id_livro, NEW.quantidade, 'VENDA');
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER tg_log_cancelamento AFTER DELETE ON itens_pedido
FOR EACH ROW
BEGIN
  INSERT INTO log_estoque (id_livro, quantidade, tipo_acao)
  VALUES (OLD.id_livro, OLD.quantidade, 'CANCELAMENTO');
END$$

DELIMITER ;

-- Fazendo uma venda
INSERT INTO itens_pedido (id_pedido, id_livro, quantidade)
VALUES (5, 3, 1);

-- Cancelando o item
DELETE FROM itens_pedido
WHERE id_pedido = 5 AND id_livro = 3;

-- Verificando a Log
SELECT * FROM log_estoque;


						-- ⚙️ Exercícios com FUNCTION
                
-- 1-----------------------
		
DELIMITER $$

CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS FLOAT(10,2)
DETERMINISTIC
BEGIN
	DECLARE total FLOAT(10,2);

	SELECT SUM(B.quantidade * A.preco)
	INTO total
	FROM livros A
	INNER JOIN itens_pedido B ON A.id_livro = B.id_livro
	WHERE B.id_pedido = p_id_pedido;

	RETURN IFNULL(total, 0);
END$$

DELIMITER ;

-- Teste:
SELECT calcular_total_pedido(3) AS total_pedido;


-- 2-----------------------

DELIMITER $$

CREATE FUNCTION obter_autor_livro(p_id_livro INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE nome_autor VARCHAR(255);

  SELECT B.nome_autor
  INTO nome_autor
  FROM livros A
  INNER JOIN autores B ON A.id_autor = B.id_autor
  WHERE A.id_livro = p_id_livro;

  RETURN nome_autor;
END$$

DELIMITER ;

-- Teste:
SELECT obter_autor_livro(2) AS autor;


-- 3-----------------------

DELIMITER $$

CREATE FUNCTION verificar_estoque(p_id_livro INT, p_qtd INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
  DECLARE qtd_estoque INT;

  SELECT estoque INTO qtd_estoque
  FROM livros
  WHERE id_livro = p_id_livro;

  IF qtd_estoque >= p_qtd THEN
    RETURN 'OK';
  ELSE
    RETURN 'INSUFICIENTE';
  END IF;
END$$

DELIMITER ;

-- Teste:
SELECT verificar_estoque(2, 3) AS status_estoque;


-- 4-----------------------

DELIMITER $$

CREATE FUNCTION contar_livros_autor(p_id_autor INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;

  SELECT COUNT(*) INTO total
  FROM livros
  WHERE id_autor = p_id_autor;

  RETURN total;
END$$

DELIMITER ;

-- Teste:
SELECT contar_livros_autor(4) AS total_livros_autor;


-- 5-----------------------

DELIMITER $$

CREATE FUNCTION obter_editora_livro(p_id_livro INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
  DECLARE nome_editora VARCHAR(255);

  SELECT C.nome_editora
  INTO nome_editora
  FROM livros A
  INNER JOIN editoras C ON A.id_editora = C.id_editora
  WHERE A.id_livro = p_id_livro;

  RETURN nome_editora;
END$$

DELIMITER ;

-- Teste:
SELECT obter_editora_livro(2) AS editora;



--   ------------------------------------------------------------