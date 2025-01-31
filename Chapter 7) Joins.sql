-- Outer Joins 

-- Joining two tables 
SELECT f.film_id , f.title, count(*) num_copies
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;


-- above query return 958 rows 

SELECT f.film_id, f.title, count(i.inventory_id) num_copies
FROM film f
LEFT OUTER JOIN inventory i
ON f.film_id = i.film_id
GROUP BY f.film_id , f.title;

-- Now you can see 1000 rows from the film table 

-- Let's see inner join 
SELECT f.film_id , f.title, i.inventory_id
FROM film f 
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 and 15;


SELECT f.film_id , f.title, i.inventory_id
FROM film f 
Left OUTER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 and 15;


SELECT f.film_id , f.title, i.inventory_id
FROM film f 
RIGHT OUTER JOIN inventory i
ON f.film_id = i.film_id
WHERE f.film_id BETWEEN 13 and 15;

SELECT f.film_id, f.title, i.inventory_id, r.rental_date
FROM film f
LEFT OUTER JOIN inventory i ON f.film_id = i.film_id
LEFT OUTER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE f.film_id BETWEEN 13 AND 15;

-- Cross join 

SELECT c.name category_name , l.name language_name
FROM category c 
CROSS JOIN language l;

-- Natural JOIN 
SELECT c.first_name, c.last_name, date(r.rental_date)
FROM customer c 
NATURAL JOIN rental r;

-- Above query done empty join 

SELECT cust.first_name, cust.last_name , date(r.rental_date)
from
(SELECT customer_id , first_name , last_name
FROM customer
) cust 
NATURAL JOIN rental r;
