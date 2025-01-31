-- Subqueries
-- Subqueries are a powerful tool that can e used to filter data , gererate values,and construct temporary data sets.
-- Subquery is a query contained within another SQL statement. 
-- Subquery is always encolsed within parentheses , and it is usually executed prior to the containing statement. 
-- Like any query , a subquery returns a results set that may consist of 1) Single row with a single column 2) Multiple rows with a single column
-- 3) Multiple rows having Multiple columns 
SELECT customer_id , first_name , last_name
FROM customer
WHERE customer_id =(SELECT MAX(customer_id) from customer);

SELECT MAX(customer_id) from customer;

SELECT customer_id , first_name , last_name
FROM customer
WHERE customer_id = 599;

-- Types of Subquery
-- Non correlated subqueries --> Subqueries are completely self-contained 

-- Correlated Subqueries --> Subqueries are other refrence columns from the containing Statement

-- Non Correlated Subqueries 
-- It may be excuted alone and does not refrence anything from the containing Statements 
-- Scalar subqueries may contain operator ( = , <> , <, >, <=, >=) 

--Question Return all Cities that are not in India 44 is India country code 

SELECT city_id , city
FROM city 
WHERE country_id <> (SELECT country_id from country WHERE country ='India');

SELECT country_id from country WHERE country ='India';

SELECT city_id , city
FROM city 
WHERE country_id <> 44;

-- Subqueries are more complex using the clauses (SELECT , FROM , WHERE , GROUP BY, HAVING , ORDER BY ) 

-- Multiple ROW , Single COlumn Subquery 
-- IF your subquery returns more than oe row , you will not be able to use it on one side of an equality condition as previous examples

-- Single Column single row and Multiple column 

SELECT country_id 
FROM country 
WHERE country IN ('Canada', 'Mexico');

SELECT	country_id 
FROM Country
WHERE country = 'Canada' OR country = 'Mexico';

-- IN OPREATOR 

SELECT city_id, city 
FROM city
WHERE country_id IN 
(SELECT country_id 
 FROM country
 WHERE country IN ('Canada', 'Mexico'));
 
-- Another version 

-- NOT IN Operator 

 SELECT city_id , city 
 FROM city
 WHERE country_id NOT IN 
 (SELECT country_id NOT_IN
 FROM country 
 WHERE country in ('Canada','Mexico'));

-- ALL operator 
-- Question Find all customers who have never gotten a free film rental 

SELECT first_name, last_name  
FROM customer 
WHERE customer_id != ALL
(SELECT customer_id 
 FROM payment
 WHERE amount = 0);
 
 
 SELECT first_name, last_name  
FROM customer 
WHERE customer_id NOT IN 
(SELECT customer_id 
 FROM payment
 WHERE amount = 0);
 
 SELECT customer_id , count(*) 
 FROM rental 
 group by customer_id 
 HAVING count(*) > ALL
 (SELECT count(*) 
 FROM rental r 
 INNER JOIN customer c 
 ON r.customer_id = c.customer_id
 INNER JOIN address a 
 ON c.address_id = a.address_id
 INNER JOIN CITY ct
 ON a.city_id = ct.city_id 
 INNER JOIN country co 
 ON ct.country_id = co.country_id 
 WHERE co.country IN ('United States' , 'Mexico','Canada')
 group by r.customer_id
 );
 
 
SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY 
(
    SELECT SUM(p.amount) 
    FROM payment p 
    INNER JOIN customer c 
        ON p.customer_id = c.customer_id
    INNER JOIN address a 
        ON c.address_id = a.address_id
    INNER JOIN city ct
        ON a.city_id = ct.city_id 
    INNER JOIN country co 
        ON ct.country_id = co.country_id 
    WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
    GROUP BY co.country
);

-- Multicolumn Subqueries 
-- Single column and One or More Rows. 

select fa.actor_id , fa.film_id 
FROM film_actor fa
WHERE fa.actor_id IN 
(SELECT actor_id FROM actor WHERE last_name ='MONROE')
AND fa.film_id IN 
(SELECT film_id FROM film WHERE rating ='PG');


SELECT actor_id , film_id
FROM film_actor
WHERE (actor_id , film_id) IN 
(SELECT a.actor_id , f.film_id
FROM actor a 
CROSS JOIN film f
WHERE a.last_name ='MONROE'
AND f.rating ='PG');


-- COrrelated Subqueries
SELECT c.first_name , c.last_name
FROM customer c
WHERE 20 = 
(SELECT count(*) FROM rental r
WHERE r.customer_id = c.customer_id);


SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 = (
    SELECT COUNT(*) 
    FROM rental 
    WHERE rental.customer_id = c.customer_id
);

-- Question Finds all customers whose total payments for all film rentals are between $ 180 and $ 240 

SELECT c.first_name, c.last_name
FROM customer c 
WHERE 
(SELECT sum(p.amount) FROM payment p 
WHERE p.customer_id = c.customer_id)
BETWEEN 180 AND 240;

-- The exist Operator 

-- Question Finds all the customer whose rented at least one film prior to May 25, 2005 without regard for how many films were rented.

SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1 
    FROM rental r 
    WHERE r.customer_id = c.customer_id 
    AND DATE(r.rental_date) < '2005-05-25'
);


SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS (
    SELECT 1 
    FROM rental r 
    WHERE r.customer_id = c.customer_id 
    AND DATE(r.rental_date) < '2005-05-25'
);


-- NOT EXISTS 


-- Question Find all actors who have never appeared in an R-rated film 

SELECT a.first_name, a.last_name 
FROM actor a 
WHERE NOT EXISTS (
    SELECT 1 
    FROM film_actor fa 
    INNER JOIN film f ON f.film_id = fa.film_id
    WHERE fa.actor_id = a.actor_id 
    AND f.rating = 'R'
);


-- Data Manipulation using  Correlated SubQueries 

SET SQL_SAFE_UPDATES = 0;  -- You can disable safe update mode for the current session by running

UPDATE customer c
INNER JOIN (
    SELECT customer_id, MAX(rental_date) AS latest_rental_date
    FROM rental
    GROUP BY customer_id
) r ON c.customer_id = r.customer_id
SET c.last_update = r.latest_rental_date;

UPDATE customer c 
SET c.last_update = (SELECT MAX(r.rental_date ) FROM rental r WHERE r.customer_id = c.customer_id) 
WHERE exists 
(SELECT 1 FROM rental r WHERE r.customer_id = c.customer_id);

DELETE FROM customer
WHERE 365 < ALL (
    SELECT DATEDIFF(NOW(), r.rental_date) AS days_since_last_rental
    FROM rental r
    WHERE r.customer_id = customer.customer_id
);

Use Sakila;

-- When to Use Subqueries 
-- 1) SubQueries as Data Sources
-- Subqueries generates a results set containing rows and columns of data 

-- Question Write a subquery generates a list of customer ID along with the number of film rentals and the total payments.

SELECT c.first_name, c.last_name,
pymnt.num_rentals, pymnt.tot_payments
FROM customer c 
INNER JOIN 
(SELECT Customer_id, 
count(*) num_rentals, sum(amount) tot_payments
FROM payment 
group by customer_id
) pymnt
on c.customer_id = pymnt.customer_id;


SELECT customer_id , count(*) num_rentals, sum(amount) tot_payments
FROM payment
GROUP BY customer_id;