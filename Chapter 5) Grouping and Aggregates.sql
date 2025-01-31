-- GROUP BY clause use to the group the data 
use sakila;

SELECT customer_id
FROM rental
GROUP BY customer_id;

-- You Can use the aggregate function in the select clause to count the number of rows in each group 

SELECT customer_id, COUNT(*) 
FROM rental
GROUP BY customer_id;

-- We can give Alias to the count(*) column
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- The aggreagate function count() counts the number of rows in each group , and 
-- the asterisk tells the server to count every thing in the group 

-- Determine the which customers have rented the most films ,simply ass an order by clause 

select customer_id , COUNT(*) AS rental_most_film
from rental 
GROUP BY customer_id 
ORDER BY 2 DESC;

-- Filter out any customers who have rented fewer than 40 films

SELECT customer_id, COUNT(*) 
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 40;

-- Aggregate Functions 
-- Aggregate functions perform a specific opration over all rows in a group. 
-- 1) max() --> Returned the maximum value within a set or rows
-- 2) min() --> Returned the maximum value within a set or row 
-- 3) avg() --> Returned the value across a set 
-- 4) sum() --> Returned the sum of the values across ser or row 
-- 5) count() --> Returned the value counts of the rows or sets 



SELECT MAX(amount) max_amt,
	   MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       count(*) num_payments
FROM payment;

-- All Aggregate function used with the GROUP BY When you retriving the any columns 

SELECT customer_id, 
	MAX(amount) max_atm,
    MIN(amount) min_atm,
    AVG(amount) avg_atm,
    SUM(amount) tot_atm,
    COUNT(*) num_payments
FROM payment
GROUP BY customer_id;

-- COUNT() function
-- To Determine the number of members in each group, you have choise counting all members in the group or 
-- counting only the distinct values for a column across all members of the group.(remove all duplicate values using count(distinct) 
-- let's see 

SELECT 
    COUNT(customer_id) AS num_rows,
    COUNT(DISTINCT customer_id) AS num_customers
FROM payment;

-- Question Find the maximum number of days between when a film was rented and subsequently returned

SELECT MAX(datediff(return_date, rental_date))
FROM rental;

-- How NULLs Are Handled 
-- To understand the this concept let's create table and insert some values 

USE sakila;

drop table number_tbl;

CREATE TABLE number_tbl (val SMALLINT);
INSERT INTO number_tbl VALUES(1);
INSERT INTO number_tbl VALUES(3);
INSERT INTO number_tbl VALUES(5);

SELECT COUNT(*) num_rows,
count(val) num_vals,
sum(val) total,
MAX(val) Max_val,
Avg(val) avg_val
FROM number_tbl;

INSERT INTO number_tbl values (NULL);

SELECT COUNT(*) num_rows,
count(val) num_vals,
sum(val) total,
MAX(val) Max_val,
Avg(val) avg_val
FROM number_tbl;

SELECT * from number_tbl;

DROP table number_tbl;

-- The counts counts(*) the the number of rows whereas count(val) counts the number of values contained in the val 
-- column and ignores any null values encountered 

-- Single Column Grouping 
-- Single - column groups are the simplest and most-often-used type of gropping.
-- Question Find the number of films associated with each actor 

SELECT actor_id, count(*)
FROM film_actor
Group by actor_id ; 

-- Multi Column Grouping 
-- Question  Find the total number of films for each film rating (G , PG...)for each actor 

SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating 
ORDER BY 1, 2;

-- Grouping via Expressions 
-- EXTRACT function to return only the year portion of a date to group the rows in the rental table. 

SELECT extract(YEAR FROM rental_date) year,
count(*) how_many
from rental 
GROUP BY extract(year FROM rental_date);

-- Generating Rollups 
-- Using ROLLUP in the group by clause 
SELECT fa.actor_id, f.rating, count(*)
FROM film_actor fa 
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating WITH ROLLUP
ORDER BY 1, 2;

-- Group Filter condition 
select fa.actor_id , f.rating, count(*)
from film_actor fa 
INNER JOIN film f
ON fa.film_id = f.film_id
WHERE f.rating IN ('G','PG')
GROUP BY fa.actor_id, f.rating
HAVING count(*) > 9 ;


SELECT fa.actor_id, f.rating, COUNT(*) AS film_count
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id = f.film_id
WHERE f.rating IN ('G', 'PG')  -- Filter movies with rating 'G' or 'PG'
GROUP BY fa.actor_id, f.rating  -- Group by actor and rating
HAVING COUNT(*) > 9;  -- Filter groups where the actor has acted in more than 9 films


