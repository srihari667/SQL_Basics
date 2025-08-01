
/*
Section 1: SQL Basics - Theory & Query Writing
*/

/*
1. Create the employees table with constraints
*/
CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name TEXT NOT NULL,
    age INT CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL DEFAULT 30000
);

/*
2. Purpose of constraints
Constraints enforce rules at table level to maintain data integrity.
Examples include NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT.
*/

/*
3. Why use NOT NULL and can PRIMARY KEY be NULL?
NOT NULL ensures mandatory fields.
PRIMARY KEY cannot be NULL because it uniquely identifies each record.
*/

/*
4. Add and remove constraints on an existing table
*/
ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age >= 18);
/*
To remove (MySQL 8+):
ALTER TABLE employees DROP CHECK chk_age;
*/

/*
5. Consequences of violating constraints
E.g., inserting duplicate value in UNIQUE field gives an error:
ERROR 1062 (23000): Duplicate entry for key 'email'
*/

/*
6. Modify 'products' table
*/
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE products ALTER price SET DEFAULT 50.00;

/*
7. INNER JOIN student and class tables
*/
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN class c ON s.class_id = c.class_id;

/*
8. Show all orders and unmatched products
*/
SELECT o.order_id, c.customer_name, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

/*
9. Total sales per product
*/
SELECT p.product_name, SUM(o.amount) AS total_sales
FROM products p
INNER JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name;

/*
10. Order details
*/
SELECT o.order_id, c.customer_name, o.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON o.product_id = p.product_id;

/*
Section 2: SQL Commands on Mavenmovies DB
*/

/*
1. Primary vs Foreign keys
Primary: actor.actor_id, film.film_id, etc.
Foreign: customer.address_id → address.address_id, etc.
*/

/*
2. All actors
*/
SELECT * FROM actor;

/*
3. All customers
*/
SELECT * FROM customer;

/*
4. Different countries
*/
SELECT DISTINCT country FROM country;

/*
5. Active customers
*/
SELECT * FROM customer WHERE active = TRUE;

/*
6. Rentals by customer 1
*/
SELECT rental_id FROM rental WHERE customer_id = 1;

/*
7. Films with rental duration > 5
*/
SELECT * FROM film WHERE rental_duration > 5;

/*
8. Films with replacement cost between 15 and 20
*/
SELECT COUNT(*) FROM film WHERE replacement_cost > 15 AND replacement_cost < 20;

/*
9. Unique actor first names
*/
SELECT COUNT(DISTINCT first_name) FROM actor;

/*
10. First 10 customer records
*/
SELECT * FROM customer LIMIT 10;

/*
11. 3 customers whose names start with 'b'
*/
SELECT * FROM customer WHERE first_name LIKE 'b%' LIMIT 3;

/*
12. 5 'G' rated films
*/
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

/*
13. First names start with 'a'
*/
SELECT * FROM customer WHERE first_name LIKE 'a%';

/*
14. First names end with 'a'
*/
SELECT * FROM customer WHERE first_name LIKE '%a';

/*
15. Cities start and end with 'a'
*/
SELECT city FROM city WHERE city LIKE 'a%a' LIMIT 4;

/*
16. First name contains 'NI'
*/
SELECT * FROM customer WHERE first_name LIKE '%NI%';

/*
17. Second letter 'r'
*/
SELECT * FROM customer WHERE first_name LIKE '_r%';

/*
18. Names start with 'a' and length >= 5
*/
SELECT * FROM customer WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;

/*
19. Names start with 'a' and end with 'o'
*/
SELECT * FROM customer WHERE first_name LIKE 'a%o';

/*
20. PG and PG-13 films
*/
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

/*
21. Films between 50 and 100 mins
*/
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

/*
22. First 50 actors
*/
SELECT * FROM actor LIMIT 50;

/*
23. Distinct film IDs in inventory
*/
SELECT DISTINCT film_id FROM inventory;

/*
Section 3: Functions
*/

/*
1. Total rentals
*/
SELECT COUNT(*) AS total_rentals FROM rental;

/*
2. Avg rental duration
*/
SELECT AVG(DATEDIFF(return_date, rental_date)) FROM rental WHERE return_date IS NOT NULL;

/*
3. Uppercase customer names
*/
SELECT UPPER(first_name), UPPER(last_name) FROM customer;

/*
4. Extract month from rental date
*/
SELECT rental_id, MONTH(rental_date) FROM rental;

/*
5. Rentals per customer
*/
SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;

/*
6. Total revenue per store
*/
SELECT store_id, SUM(amount) FROM payment GROUP BY store_id;

/*
7. Rentals per category
*/
SELECT c.name, COUNT(r.rental_id)
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

/*
8. Avg rental rate per language
*/
SELECT l.name, AVG(f.rental_rate)
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

/*
Section 4: Joins
*/

/*
9. Movie title and customer who rented
*/
SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

/*
10. Actors in 'Gone with the Wind'
*/
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

/*
11. Total amount spent by customer
*/
SELECT c.first_name, c.last_name, SUM(p.amount)
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

/*
12. Movies rented by customers in London
*/
SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.customer_id, f.title;

/*
Section 5: Advanced Joins & Window Functions
*/

/*
1. Same movie multiple times
*/
SELECT customer_id, inventory_id, COUNT(*) 
FROM rental 
GROUP BY customer_id, inventory_id 
HAVING COUNT(*) > 1;

/*
2. Top 5 grossing movies
*/
SELECT f.title, SUM(p.amount)
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id
ORDER BY SUM(p.amount) DESC
LIMIT 5;

/*
3. Customer total, avg, and count of payments
*/
SELECT customer_id, SUM(amount), AVG(amount), COUNT(payment_id)
FROM payment
GROUP BY customer_id;

/*
4. 3 most rented movies
*/
SELECT f.title, COUNT(r.rental_id)
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC
LIMIT 3;

/*
5. Top 3 customers by payments using RANK()
*/
SELECT customer_id, total_amount, RANK() OVER (ORDER BY total_amount DESC) AS payment_rank
FROM (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id
) AS sub;

/*
6. Avg payment by staff
*/
SELECT staff_id, amount, AVG(amount) OVER (PARTITION BY staff_id)
FROM payment;

/*
Section 6: CTEs
*/

/*
1. Top 5 customers by payment
*/
WITH customer_payments AS (
    SELECT customer_id, SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
)
SELECT * FROM customer_payments ORDER BY total_paid DESC LIMIT 5;

/*
2. Film count by category
*/
WITH film_counts AS (
    SELECT c.name AS category_name, COUNT(fc.film_id) AS total_films
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    GROUP BY c.name
)
SELECT * FROM film_counts;

/*
3. Latest payment per customer
*/
WITH latest_payment AS (
    SELECT customer_id, MAX(payment_date) AS last_payment
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, lp.last_payment
FROM latest_payment lp
JOIN customer c ON lp.customer_id = c.customer_id;

/*
Section 7: Theory
*/

/*
What is Normalization?
Normalization is organizing data to reduce redundancy.
1NF: Atomic values
2NF: No partial dependencies
3NF: No transitive dependencies
Benefits: Data integrity, reduced duplication
*/
