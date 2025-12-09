
--                                                                   PRATICANDO NO BANCO SAKILA

-- 1.Liste todos os clientes (customer) mostrando nome, sobrenome e email.
SELECT first_name, last_name, email FROM customer;
 
 -- 2.Mostre todos os filmes (film) que têm duração maior que 120 minutos.
SELECT * FROM film WHERE length > 120;

-- 3.Liste os 10 primeiros clientes cadastrados.
SELECT * FROM customer LIMIT 10;

-- 4.Mostre os filmes com classificação PG.
SELECT * FROM film WHERE rating = 'PG';

-- 5.Liste todos os atores cujo nome começa com a letra A.
SELECT first_name, last_name 
FROM actor
WHERE first_name LIKE 'A%';

-- 6.Mostre todos os clientes que moram no Brasil.
SELECT * FROM country WHERE country = 'Brazil' ;

-- 7.Liste os 20 filmes mais longos, em ordem decrescente de duração.
SELECT *, length, film_id 
FROM film 
ORDER BY length DESC
LIMIT 20;

-- 8.Liste os clientes em ordem alfabética pelo sobrenome.
SELECT *, last_name
FROM customer
ORDER BY last_name ASC;

-- 9.Insira um novo cliente fictício na tabela customer.
INSERT INTO customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date)
VALUES(600, 1, 'FELIPE', 'CUNHA', 'FELIPE.CUNHA@sakilacustomer.org', 5, 1, NOW());

-- 10.Insira um novo filme na tabela film.
INSERT INTO film(film_id, title, description , release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features)
VALUES(1001, 'KIMETSU NO YAIBA', 'CAÇADOR DE BESTAS', 2025, 1, 4, 4.99, 130, 19.99, 'PG', 'Trailers');

-- 11.Atualize o email de um cliente específico.
UPDATE customer
SET email = 'NOVOEMAIL@@sakilacustomer.org'
WHERE customer_id = 600;

-- 12.Altere o preço de locação de todos os filmes de 0.99 para 1.49.
UPDATE film
SET rental_rate = 1.49
WHERE rental_rate = 0.99;

-- 13.Conte quantos clientes existem na base.
SELECT COUNT(*) AS contagem FROM customer;

-- 14.Mostre a duração média dos filmes.
SELECT ROUND(AVG(length),2) AS media_de_duracao FROM film;

-- 15.Descubra o filme mais longo e o mais curto.
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 1;

SELECT title, length
FROM film
ORDER BY length ASC
LIMIT 1;

-- 16.Mostre o total de pagamentos recebidos.
SELECT SUM(amount) AS total_pagamento_recebido 
FROM payment;

-- 17.Mostre quantos filmes existem por categoria.
SELECT c.name AS categoria, COUNT(f.film_id) AS total_filmes
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY total_filmes DESC;

-- 18.Liste os 3 clientes com maior customer_id.
SELECT * FROM customer
ORDER BY customer_id DESC
LIMIT 3;

-- 19.Mostre o nome dos clientes em letras maiúsculas.
SELECT UPPER(first_name) AS nome 
FROM customer;

-- 20.Exiba os 10 primeiros caracteres do título de cada filme.
SELECT SUBSTRING(title, 1, 10) AS dez_primeiro
FROM film;

-- 21.Liste os sobrenomes dos clientes e quantos caracteres cada um tem.
SELECT last_name,
LENGTH(last_name) AS quantidade
FROM customer;

-- 22.Substitua todas as ocorrências da palavra "Action" na tabela category por "Ação".
SELECT REPLACE(name, 'Action', 'Ação') AS troca
FROM category;

-- 23.Liste todas as locações feitas no ano de 2005.
SELECT * FROM rental
WHERE YEAR(rental_date) = 2005;

-- 24.Mostre o dia da semana em que ocorreram os pagamentos (payment_date).
SELECT payment_id,
       customer_id,
       amount,
       payment_date,
       DAYNAME(payment_date) AS dia_da_semana
FROM payment;

-- 25.Calcule quantos dias se passaram entre a primeira e a última locação registrada.
SELECT rental_id, 
DATEDIFF(last_update, return_date) AS dias_que_passaram
FROM rental;

-- 26.Adicione 7 dias à data de cada pagamento e exiba como “data vencimento”.
SELECT payment_id, payment_date,
DATE_ADD(payment_date, INTERVAL 7 DAY) AS data_vencimento
FROM payment;

-- 27.Liste todos os filmes que têm duração maior que a duração média de todos os filmes.
SELECT title, length AS duracao_dos_filmes 
FROM film
WHERE length > (SELECT AVG(length)FROM film);

-- 28.Mostre os clientes que já realizaram mais de 30 pagamentos.
SELECT c.first_name, COUNT(p.customer_id) AS quantidade_de_pagamentos
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.first_name
HAVING COUNT(p.customer_id) > 30
ORDER BY quantidade_de_pagamentos DESC;

-- 29.Liste o(s) filme(s) mais caro(s) para alugar (maior rental_rate).
SELECT title, rental_rate AS preco_dos_filmes
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate)FROM film)
ORDER BY preco_dos_filmes;

-- 30.Mostre os clientes que moram na mesma cidade que o cliente de customer_id = 5.
SELECT c.customer_id, c.first_name AS nome, a.address_id, b.city_id
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN city b ON b.city_id = a.city_id
WHERE b.city_id = (
	SELECT b2.city_id
    FROM customer c2
    INNER JOIN address a2 ON a2.address_id = c2.address_id
    INNER JOIN city b2 ON b2.city_id = a2.city_id
    WHERE c2.customer_id = 5);

-- 31.Liste o nome dos clientes e o nome da cidade onde moram.
SELECT c.first_name AS nome, b.city AS cidade, c.customer_id, a.address_id
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN city b ON b.city_id = a.city_id;

-- 32.Mostre os títulos dos filmes alugados por cada cliente.
SELECT c.first_name AS nome, f.title AS titulo, i.inventory_id, r.rental_id
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id;

-- 33.Traga os pagamentos realizados, mostrando também o nome do cliente e o funcionário que processou.
SELECT c.first_name AS cliente, s.first_name AS funcionario, p.amount AS preco, p.payment_date AS data_pagamento
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
INNER JOIN staff s ON s.staff_id = p.staff_id;

-- 34.Liste todos os filmes e sua categoria.
SELECT f.title AS titulo_do_filme, c.name AS categoria, x.film_id
FROM film f
INNER JOIN film_category x ON x.film_id = f.film_id
INNER JOIN category c ON c.category_id = x.category_id
ORDER BY x.film_id ASC;

-- 35.Liste todos os clientes e mostre as locações que cada um fez (mesmo os que nunca alugaram).
SELECT c.first_name AS nome, c.customer_id, r.inventory_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id;

-- 36.Mostre todos os filmes e indique se já foram alugados ou não.
SELECT f.title AS titulo_do_filme, f.film_id,
	CASE
		WHEN COUNT(r.rental_id) > 0  THEN 'Já foi alugado'
        ELSE 'Nunca foi alugado'
	END AS status
from film f 
LEFT JOIN inventory i ON i.film_id = f.film_id 
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

-- 37.Liste todas as cidades e os clientes que moram nelas (mesmo cidades sem clientes).
SELECT c.first_name AS nome, b.city AS cidade
FROM city b
LEFT JOIN address a ON b.city_id = a.city_id
LEFT JOIN customer c ON a.address_id = c.address_id
ORDER BY b.city, c.first_name;

-- 38.Liste todos os endereços e mostre os clientes associados (mesmo endereços sem clientes).
SELECT a.address AS endereco, c.first_name AS nome
FROM customer c
RIGHT JOIN address a ON a.address_id = c.address_id;

-- 39.Liste todas as categorias e os filmes associados (mesmo categorias sem filmes).
SELECT c.name AS categoria, f.title AS filme
FROM film_category fc
RIGHT JOIN category c ON c.category_id = fc.category_id
RIGHT JOIN film f ON f.film_id = fc.film_id
ORDER BY c.name;

-- 40.Mostre todas as cidades e clientes, garantindo que aparecem tanto cidades sem clientes quanto clientes sem cidade cadastrada corretamente.
SELECT c.first_name AS nome, ci.city AS cidade
FROM city ci
LEFT JOIN address a ON ci.city_id = a.city_id
LEFT JOIN customer c ON a.address_id = c.address_id

UNION

SELECT c.first_name AS nome, ci.city AS cidade
FROM city ci
RIGHT JOIN address a ON ci.city_id = a.city_id
RIGHT JOIN customer c ON a.address_id = c.address_id
ORDER BY nome, cidade;

-- 41.Gere todas as combinações possíveis entre clientes e categorias de filmes.
SELECT c.first_name AS nome, ca.name AS categoria
FROM customer c
CROSS JOIN category ca
ORDER BY c.first_name, ca.name;

-- 42.Gere todas as combinações possíveis de funcionários e lojas.
SELECT s.first_name AS funcionario, st.store_id AS loja
FROM staff s
CROSS JOIN store st;

-- 43.Liste cada cliente com a quantidade total de filmes alugados.
SELECT c.customer_id, c.first_name AS nome, COUNT(r.rental_id) AS quantidade_alugada
FROM customer c 
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.first_name, c.customer_id
ORDER BY quantidade_alugada DESC;

-- 44.Liste todos os filmes que têm duração maior que a duração média dos filmes.
SELECT 
	f.title AS titulo, 
	f.length AS duracao, 
    (SELECT AVG(length) FROM film) AS duracao_media
FROM film f
WHERE f.length > (SELECT AVG(length)FROM film)
GROUP BY f.title, f.length
ORDER BY f.length DESC;

-- 45.Mostre os clientes que fizeram mais pagamentos do que a quantidade média de pagamentos por cliente.
SELECT 
    c.first_name AS nome,
    COUNT(r.rental_id) AS quantidade
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name
HAVING COUNT(r.rental_id) > (
    SELECT AVG(qtd_por_cliente)
    FROM (
        SELECT COUNT(r2.rental_id) AS qtd_por_cliente
        FROM rental r2
        GROUP BY r2.customer_id
    ) AS sub
)
ORDER BY quantidade DESC;

-- 46.Liste os filmes com valor de aluguel maior que o valor médio de aluguel da tabela film.
SELECT
    f.title AS titulo,
    f.replacement_cost AS preco,
    (SELECT ROUND(AVG(replacement_cost),2) FROM film) AS preco_medio
FROM film f
WHERE f.replacement_cost > (
    SELECT AVG(f2.replacement_cost)
    FROM film f2
)
ORDER BY preco DESC;

-- 47.Mostre o filme mais longo (length) da tabela film.
SELECT title AS titulo, MAX(length) AS tamanho_do_filme
FROM film
GROUP BY title, length
ORDER BY length DESC
LIMIT 1;

-- 48.Liste o cliente que fez o maior pagamento em uma única transação.
SELECT c.first_name AS nome, f.replacement_cost AS preco
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id
ORDER BY f.replacement_cost DESC
LIMIT 1;

-- 49.Mostre o funcionário que processou o maior número de pagamentos.
SELECT s.staff_id, s.first_name AS funcionario, COUNT(p.payment_id) AS total_pagamentos
FROM staff s
INNER JOIN payment p ON p.staff_id = s.staff_id
GROUP BY s.staff_id
LIMIT 1;

-- 50.Liste a quantidade de pagamentos por cliente, mas usando uma subquery no FROM (subquery como tabela derivada).
SELECT 
    c.customer_id,
    c.first_name AS nome,
    sub.qnt_pagamento
FROM customer c
INNER JOIN (
    SELECT p.customer_id, COUNT(p.payment_id) AS qnt_pagamento
    FROM payment p
    GROUP BY p.customer_id
) AS sub ON c.customer_id = sub.customer_id
ORDER BY sub.qnt_pagamento DESC;

-- 2 formas diferentes com o mesmo resultado.

SELECT c.customer_id, c.first_name AS nome, COUNT(p.payment_id) AS qnt_pagamento
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY  c.customer_id, c.first_name
ORDER BY qnt_pagamento DESC;

-- 51.Crie uma subquery que traga os filmes e a quantidade de vezes que foram alugados, e no SELECT externo mostre apenas os que tiveram mais de 30 locações.

SELECT sub.title , sub.qtd_alugado
FROM (
	SELECT f.film_id, f.title, COUNT(r.rental_id) AS qtd_alugado
    FROM film f
    INNER JOIN inventory i ON i.film_id = f.film_id
    INNER JOIN rental r ON r.inventory_id  = i.inventory_id
    GROUP BY f.film_id, f.title
    ) AS sub
WHERE sub.qtd_alugado > 30
ORDER BY sub.qtd_alugado DESC;

-- 52.Monte uma tabela derivada que calcula a soma de pagamentos por cliente e depois liste apenas os clientes que pagaram mais de 100.
SELECT c.customer_id, c.first_name AS nome, sub.soma_pagamentos
FROM customer c
INNER JOIN (
	SELECT p.customer_id, SUM(p.amount) AS soma_pagamentos
    FROM payment p 
    GROUP BY p.customer_id
) AS sub ON c.customer_id = sub.customer_id	
WHERE sub.soma_pagamentos > 100
ORDER BY sub.soma_pagamentos DESC;

-- 55.Mostre os filmes que pertencem às mesmas categorias dos filmes com duração maior que 180 minutos.
SELECT f.title AS titulo, 
       c.name AS categoria, 
       f.length AS duracao
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.category_id IN (
    SELECT fc2.category_id
    FROM film f2
    INNER JOIN film_category fc2 ON f2.film_id = fc2.film_id
    WHERE f2.length > 180
)
ORDER BY c.name, f.title;

-- 56.Liste os clientes que já alugaram os mesmos filmes que o cliente com customer_id = 1
SELECT DISTINCT c.customer_id, 
       c.first_name AS nome, 
       f.title AS titulo
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id
WHERE f.film_id IN (
    SELECT i2.film_id
    FROM rental r2
    INNER JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    WHERE r2.customer_id = 1
) ORDER BY c.customer_id, f.title;

-- 57.Liste todos os clientes que já realizaram pelo menos um pagamento (EXISTS).
SELECT c.customer_id, c.first_name AS nome
FROM customer c
WHERE EXISTS ( 
	SELECT 1 
    FROM payment p
    WHERE p.customer_id = c.customer_id);

-- 58.Mostre todos os filmes que já foram alugados ao menos uma vez (EXISTS).
SELECT DISTINCT f.film_id, f.title AS titulo
FROM film f
INNER JOIN inventory i ON i.film_id	= f.film_id
WHERE EXISTS (
		SELECT 1
        FROM rental r
		WHERE r.inventory_id = i.inventory_id);

-- 59.Liste todas as cidades que não possuem clientes (NOT EXISTS).
SELECT c.city_id, c.city AS cidade
FROM city c
WHERE NOT EXISTS (
    SELECT 1
    FROM customer cli
    INNER JOIN address a ON cli.address_id = a.address_id
    WHERE a.city_id = c.city_id
);

-- 60.Inicie uma transação (BEGIN) para inserir um novo cliente, depois faça um ROLLBACK e verifique se o cliente foi realmente cancelado.
START TRANSACTION;

INSERT INTO customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date)
VALUES(601, 1, 'FELIPE', 'GAIO', 'FELIPE.GAIO@sakilacustomer.org', 5, 1, NOW());

ROLLBACK;

-- 61.Insira dois pagamentos em uma transação e finalize com COMMIT.

START TRANSACTION;

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 11000, 3.99, NOW());

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (2, 2, 11001, 5.99, NOW());

COMMIT;

-- 62.Use SAVEPOINT após inserir um pagamento, insira outro pagamento e depois faça ROLLBACK TO SAVEPOINT → só o primeiro deve permanecer.

START TRANSACTION;

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, 1, 19.99, NOW());
SAVEPOINT etapa1;

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (2, 2, 2, 7.99, NOW());
SAVEPOINT etapa2;

ROLLBACK TO etapa1;

COMMIT;

-- 63.Use GRANT para dar permissão de SELECT na tabela film a um usuário fictício.
CREATE USER 'Gabriel'@'%' IDENTIFIED BY 'senha123';

GRANT SELECT ON sakila.film TO 'Gabriel'@'%';

-- 64.Use REVOKE para retirar a permissão desse mesmo usuário.
REVOKE SELECT ON sakila.film FROM 'Gabriel'@'%';

-- 65.Crie uma CHECK constraint em uma tabela nova para validar que amount > 0.
CREATE TABLE pagamento_teste (
    pagamento_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    amount DECIMAL(10,2),
    CHECK (amount > 0)  -- Constraint para validar
);

INSERT INTO pagamento_teste 
    (pagamento_id,
    cliente_id,
    amount)
VALUES(1, 1, 0);

SELECT * FROM pagamento_teste;

DROP TABLE pagamento_teste;

-- 66.Crie um índice em payment(payment_date) e veja se a consulta para filtrar por data fica mais rápida.
CREATE INDEX idx_payment_date
ON payment (payment_date);

SELECT * FROM payment
WHERE payment_date BETWEEN '2005-05-01' AND '2005-06-01';

-- 67.Reescreva uma consulta com JOIN em vez de subquery, comparando desempenho.

SELECT first_name AS nome
FROM customer
WHERE customer_id IN (SELECT customer_id FROM payment);

-- 68.Liste apenas as colunas realmente necessárias em uma query com SELECT (projeção seletiva).

SELECT first_name AS nome, last_name AS sobrenome FROM customer;

-- 69.Compare uma query com COUNT(*) direto na tabela vs COUNT usando índice.
CREATE INDEX idx_pay_customer ON payment (customer_id);

EXPLAIN SELECT COUNT(*) AS total_pagamentos FROM payment;

EXPLAIN SELECT COUNT(customer_id) AS total_pagamentos FROM payment;

-- 70.Use ROW_NUMBER() para numerar todos os filmes por ordem de duração.
SELECT title, length,
	ROW_NUMBER() OVER(ORDER BY length DESC) AS posicao
FROM film;

-- 71.Use RANK() para listar os 5 filmes mais longos.
SELECT title, length,
	RANK() OVER(ORDER BY length DESC) AS ranking
FROM film
LIMIT 5;

-- 72.Use DENSE_RANK() para classificar clientes pelo total de pagamentos.
SELECT c.customer_id, c.first_name AS nome, SUM(p.amount) AS total_preco,
	DENSE_RANK() OVER (ORDER BY SUM(p.amount) DESC) posicao
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id;

-- 73.Use LEAD() e LAG() para comparar valores de pagamento de um mesmo cliente.
SELECT customer_id, payment_date, amount,
	LAG(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS pagamento_anterior,
	LEAD(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS proximo_pagamento
from payment
WHERE customer_id = 1;

-- 74.Crie uma CTE que liste os filmes alugados mais de 30 vezes.
WITH filmes_alugados AS(
	SELECT f.title AS titulo, COUNT(r.rental_id) AS qtd_alugado
    FROM film f
    INNER JOIN inventory i ON i.film_id = f.film_id
    INNER JOIN rental r ON r.inventory_id = i.inventory_id
    GROUP BY f.film_id)
SELECT * 
FROM filmes_alugados
WHERE qtd_alugado > 30
ORDER BY qtd_alugado DESC;


-- 75.Crie uma CTE recursiva para listar hierarquia de categorias fictícias.
WITH RECURSIVE categorias(id, name, parent_id) AS(
	SELECT category_id, name, NULL FROM category WHERE category_id = 1
    UNION ALL
    SELECT c.category_id, c.name, categorias.id
    FROM category c
    INNER JOIN categorias ON c.category_id = categorias.parent_id
)
SELECT * FROM categorias;
 
-- 76.Use PIVOT (ou CASE WHEN) para mostrar quantidade de filmes por classificação (rating) em colunas.
SELECT 
    SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS qtd_G,
    SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS qtd_PG,
    SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS qtd_PG13,
    SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS qtd_R,
    SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS qtd_NC17
FROM film;

-- 77.Use UNPIVOT (ou UNION) para transformar colunas de totais em linhas.

SELECT 'G' AS classificacao, COUNT(*) AS qtd
FROM film WHERE rating = 'G'
UNION ALL
SELECT 'PG', COUNT(*) FROM film WHERE rating = 'PG'
UNION ALL
SELECT 'PG-13', COUNT(*) FROM film WHERE rating = 'PG-13'
UNION ALL
SELECT 'R', COUNT(*) FROM film WHERE rating = 'R'
UNION ALL
SELECT 'NC-17', COUNT(*) FROM film WHERE rating = 'NC-17';

-- 78.Crie uma procedure sp_lista_clientes que mostre todos os clientes da tabela customer.

DELIMITER //

CREATE PROCEDURE sp_lista_clientes()
BEGIN
    SELECT customer_id, first_name, last_name, email
    FROM customer;
END //

DELIMITER ;

CALL sp_lista_clientes();

-- 79.Crie uma procedure sp_filmes_categoria que receba o nome de uma categoria e liste todos os filmes dessa categoria.


DELIMITER //

CREATE PROCEDURE sp_filmes_categoria(IN cName VARCHAR(50))
BEGIN
    SELECT c.name AS categoria, f.title AS titulo
    FROM category c
    INNER JOIN film_category fc ON fc.category_id = c.category_id
    INNER JOIN film f ON f.film_id = fc.film_id
	WHERE c.name = cName;
END //

DELIMITER ;

CALL sp_filmes_categoria('Action');

-- 80.Crie uma procedure sp_total_pagamentos_cliente que receba um customer_id e retorne o total de pagamentos feitos por esse cliente.

DELIMITER //

CREATE PROCEDURE sp_total_pagamentos_cliente(IN p_customer_id INT)
BEGIN
	SELECT c.customer_id, c.first_name AS nome, SUM(p.amount) AS total_pagamento
    FROM customer c
    INNER JOIN payment p ON p.customer_id = c.customer_id
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id, c.first_name;
END //

DELIMITER ;

CALL sp_total_pagamentos_cliente(1);

-- 81.Crie uma procedure sp_inserir_pagamento que insira um novo pagamento na tabela payment com os parâmetros: customer_id, staff_id, rental_id e amount.

DELIMITER //

CREATE PROCEDURE sp_inserir_pagamento(
    IN p_customer_id INT,
    IN p_staff_id INT,
    IN p_rental_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
    VALUES (p_customer_id, p_staff_id, p_rental_id, p_amount, NOW());
END //

DELIMITER ;

CALL sp_inserir_pagamento(1, 1, 1000, 5.99);

SELECT * FROM payment WHERE rental_id = 1000;

-- 82.Crie uma procedure sp_filmes_por_duracao que receba um valor em minutos e mostre: filmes maiores que a duração se o valor for acima de 100, filmes menores que a duração se o valor for até 100.

DELIMITER //

CREATE PROCEDURE sp_filmes_por_duracao(IN p_length INT)
BEGIN
	IF p_length > 100 THEN
		SELECT f.title AS TITULO, f.length AS  duracao
        FROM film f
        WHERE f.length > p_length;
	ELSE
		SELECT f.title AS TITULO, f.length AS  duracao
        FROM film f
        WHERE f.length < p_length;
    END IF;
END //

DELIMITER ;

CALL sp_filmes_por_duracao(101)

-- 83.Crie uma procedure sp_listar_top_clientes que liste os 10 clientes que mais gastaram no Sakila.

DELIMITER //

CREATE PROCEDURE sp_listar_top_clientes()
BEGIN
	SELECT c.customer_id, c.first_name AS nome, SUM(p.amount) AS total_pagamento
    FROM customer c
    INNER JOIN payment p ON p.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name
    ORDER BY SUM(p.amount) DESC
    LIMIT 10;
END //

DELIMITER ;

CALL sp_listar_top_clientes();

-- 84.Crie uma função fn_total_filmes_categoria(cat_id INT) que retorne a quantidade de filmes em uma categoria.

DELIMITER $$
 
CREATE FUNCTION fn_total_filmes_categoria(cat_id INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE total_filmes INT;
    
	SELECT COUNT(f.film_id)
    INTO total_filmes
    FROM film f
    INNER JOIN film_category fc ON fc.film_id = f.film_id
    WHERE fc.category_id = cat_id;
    
    RETURN total_filmes;
END $$
DELIMITER ;

SELECT fn_total_filmes_categoria(4) AS qtd_filme;

-- 85.Crie uma função fn_total_pago_cliente(cliente_id INT) que retorne o valor total pago por um cliente.

DELIMITER $$
 
CREATE FUNCTION fn_total_pago_cliente(cliente_id INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	DECLARE total_pago  DECIMAL(10,2);
    
	SELECT ROUND(SUM(p.amount), 2)
    INTO total_pago
    FROM payment p
    INNER JOIN customer c ON c.customer_id = p.customer_id
    WHERE c.customer_id = cliente_id;
    
    RETURN total_pago;
END $$
DELIMITER ;

SELECT fn_total_pago_cliente(523) AS total_pago;

-- 86.Crie uma função fn_eh_filme_longo(film_id INT) que retorne 'SIM' se o filme tiver mais de 120 minutos, senão 'NÃO'.

DELIMITER $$
 
CREATE FUNCTION fn_eh_filme_longo(film_id INT)
RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
	DECLARE filme_longo VARCHAR(3);
    
	SELECT CASE
		WHEN f.length > 120 THEN 'Sim'
        ELSE 'Não'
	END
    INTO filme_longo
	FROM film f
	WHERE f.film_id = film_id;

	RETURN filme_longo;
END $$
DELIMITER ;

SELECT fn_eh_filme_longo(3) AS filme_longo;

-- 87.Crie uma função fn_classificacao_cliente(cliente_id INT) que retorne: 'ALTO' se ele gastou mais que 150, 'MÉDIO' se gastou entre 50 e 150, 'BAIXO' se gastou menos de 50.

DELIMITER $$
 
CREATE FUNCTION fn_classificacao_cliente(cliente_id INT)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
	DECLARE clasificacao VARCHAR(10);
    
	SELECT CASE
		WHEN SUM(p.amount) > 150 THEN 'Alto'
        WHEN SUM(p.amount) BETWEEN 50 AND 150 THEN 'Médio'
        ELSE 'Baixo'
	END
    INTO clasificacao
	FROM payment p
	WHERE p.customer_id = cliente_id;

	RETURN clasificacao;
END $$
DELIMITER ;

SELECT fn_classificacao_cliente(1) AS gasto;

SELECT SUM(amount) FROM payment WHERE customer_id = 1;


--                                                 =====================================FIM=====================================

SELECT * FROM payment;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM staff;
SELECT * FROM store;






