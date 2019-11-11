--				Simple Querying
--SELECT FROM
SELECT first_name FROM customer;
SELECT first_name, last_name, email FROM customer;
SELECT * FROM customer;
SELECT first_name || ' ' || last_name AS full_name, email FROM customer;
SELECT '12'|| '34' AS result;
--ORDER BY
SELECT first_name, last_name FROM customer ORDER BY first_name;-- ASC;
SELECT first_name, last_name FROM customer ORDER BY last_name DESC;
SELECT first_name, last_name FROM customer ORDER BY first_name, last_name DESC;
--LIMIT
SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 5;
SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 4 OFFSET 3;
SELECT film_id, title, rental_rate FROM film ORDER BY rental_rate DESC LIMIT 10;
--Alias
SELECT first_name || ' ' || last_name AS full_name FROM customer ORDER BY full_name;
--Paging
SELECT COUNT(*) FROM customer; --599
SELECT * FROM (
	SELECT ROW_NUMBER() OVER (ORDER BY customer_id) AS RowNum, * FROM customer
) AS RowResult
WHERE RowNum >= 21 AND RowNum <= 40 ORDER BY RowNum;
SELECT * FROM customer ORDER BY customer_id  LIMIT 20 OFFSET 20;

--				Filtering Results
--Simple Conditions
SELECT last_name, first_name FROM customer WHERE first_name = 'Jamie';
SELECT last_name, first_name FROM customer WHERE first_name = 'Jamie' AND last_name = 'Rice';
SELECT first_name, last_name FROM customer WHERE last_name = 'Rodriguez' OR first_name = 'Adam';
SELECT first_name, last_name FROM customer WHERE first_name IN ('Ann', 'Anne', 'Annie');
SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Ann%';

SELECT first_name, LENGTH(first_name) name_len 
FROM customer
WHERE first_name LIKE 'A%' AND LENGTH(first_name) BETWEEN 3 AND 5
ORDER BY name_len;

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'Bra%' AND last_name != 'Motley';
--BETWEEN vs < >
SELECT customer_id, payment_id, amount
FROM payment
WHERE amount NOT BETWEEN 8 AND 9;

SELECT customer_id, payment_id, amount, payment_date
FROM payment
WHERE payment_date BETWEEN '2007-02-07' AND '2007-02-15 23:59:59';
--IN + subqueries
SELECT customer_id, rental_id, return_date
FROM rental
WHERE customer_id NOT IN (1, 2)
ORDER BY return_date DESC;

SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	WHERE CAST(return_date AS DATE) = '2005-05-27'
);

SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (
	SELECT AVG(rental_rate)
	FROM film
);

SELECT i.film_id, return_date
FROM rental r
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30 23:59:59';

SELECT film_id, title
FROM film
WHERE film_id IN (
	SELECT i.film_id
	FROM rental r
	INNER JOIN inventory i ON i.inventory_id = r.inventory_id
	WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'
);
--EXISTS
SELECT first_name, last_name
FROM customer c
WHERE EXISTS(
	SELECT 1
	FROM payment p
	WHERE p.customer_id = c.customer_id AND amount > 11)
ORDER BY first_name, last_name;

SELECT first_name, last_name
FROM customer
WHERE EXISTS (SELECT NULL)
ORDER BY first_name, last_name;
--LIKE
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE 'Jen%';

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%er%';

SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '_her%';

SELECT first_name, last_name
FROM customer
WHERE first_name ILIKE 'BAR%';

SELECT first_name, last_name
FROM customer
WHERE first_name ~~ 'Jen%';

SELECT active, activebool
FROM customer
WHERE active IS DISTINCT FROM CAST(activebool AS INT);

--				Data Aggregation
--GROUP BY
SELECT customer_id
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount) total
FROM payment
GROUP BY customer_id
ORDER BY total DESC;

SELECT staff_id, COUNT(payment_id)
FROM payment
GROUP BY staff_id;

SELECT COUNT(payment_id) trancs_count
FROM payment;
--HAVING
SELECT customer_id, SUM(amount) total
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200;

SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;

SELECT customer_id, SUM(amount) total
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 180;

SELECT *
FROM (
	SELECT customer_id, SUM(amount) total
	FROM payment
	GROUP BY customer_id
) t
WHERE total > 180;

--				JOINS
--INNER JOIN
SELECT c.customer_id, first_name, last_name, email, amount, payment_date
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT c.customer_id, first_name, last_name, email, amount, payment_date
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
WHERE c.customer_id = 2;

SELECT c.customer_id, c.first_name, c.last_name, c.email, s.first_name staff_fname, s.last_name staff_lname, amount, payment_date
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
INNER JOIN staff s ON p.staff_id = s.staff_id;
--LEFT JOIN
SELECT f.film_id, f.title, inventory_id
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE i.film_id IS NULL;
--Self JOIN
-- CREATE TABLE employee (
--    employee_id INT PRIMARY KEY,
--    first_name VARCHAR (255) NOT NULL,
--    last_name VARCHAR (255) NOT NULL,
--    manager_id INT,
--    FOREIGN KEY (manager_id) 
--    REFERENCES employee (employee_id) 
--    ON DELETE CASCADE
-- );
-- INSERT INTO employee (
--    employee_id,
--    first_name,
--    last_name,
--    manager_id
-- )
-- VALUES
--    (1, 'Windy', 'Hays', NULL),
--    (2, 'Ava', 'Christensen', 1),
--    (3, 'Hassan', 'Conner', 1),
--    (4, 'Anna', 'Reeves', 2),
--    (5, 'Sau', 'Norman', 2),
--    (6, 'Kelsie', 'Hays', 3),
--    (7, 'Tory', 'Goff', 3),
--    (8, 'Salley', 'Lester', 3);

SELECT e.first_name || ' ' || e.last_name employee, m.first_name || ' ' || m.last_name manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager;

SELECT f1.title, f2.title, f1.length, f1.film_id
FROM film f1
INNER JOIN film f2 ON f1.film_id <> f2.film_id AND f1.length = f2.length
WHERE f1.film_id = 8;
--CROSS JOIN
-- CREATE TABLE T1 (label CHAR(1) PRIMARY KEY);
 
-- CREATE TABLE T2 (score INT PRIMARY KEY);
 
-- INSERT INTO T1 (label)
-- VALUES
--    ('A'),
--    ('B');
 
-- INSERT INTO T2 (score)
-- VALUES
--    (1),
--    (2),
--    (3);
SELECT *
FROM T1
CROSS JOIN T2;

--				Subqueries
--General
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (
	SELECT AVG (rental_rate)
	FROM film
);

SELECT film_id, title
FROM film
WHERE film_id IN (
	SELECT i.film_id
	FROM rental
	INNER JOIN inventory i ON i.inventory_id = rental.inventory_id
	WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'
);

SELECT first_name, last_name
FROM customer
WHERE EXISTS (
	SELECT 1
	FROM payment
	WHERE payment.customer_id = customer.customer_id
);
--EXISTS
SELECT first_name, last_name
FROM customer c
WHERE EXISTS(
	SELECT 1
	FROM payment p
	WHERE p.customer_id = c.customer_id AND amount > 11)
ORDER BY first_name, last_name;

SELECT first_name, last_name
FROM customer
WHERE EXISTS (SELECT NULL)
ORDER BY first_name, last_name;
--ANY
SELECT MAX(length)
FROM film
INNER JOIN film_category USING(film_id)
GROUP BY category_id;

SELECT title, length
FROM film
WHERE length >= ANY (
	SELECT MAX(length)
	FROM film
	INNER JOIN film_category USING(film_id)
	GROUP BY category_id
);

SELECT title, category_id
FROM film
INNER JOIN film_category USING(film_id)
WHERE category_id = ANY (
	SELECT category_id
	FROM category
	WHERE name = 'Action' OR name = 'Drama'
);
--ALL
SELECT ROUND(AVG(length), 2) avg_len, rating
FROM film
GROUP BY rating
ORDER BY avg_len DESC;

SELECT film_id, title, length
FROM film
WHERE length > ALL (
	SELECT ROUND(AVG(length), 2)
	FROM film
	GROUP BY rating
)
ORDER BY length;










