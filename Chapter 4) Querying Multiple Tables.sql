-- Here we learn how to perform two or more table queries with help of join 
-- Lets check tables customer and address 

desc customer;

desc address;


-- Cartesian Product 
-- Question retrives the customer's first and last name along with the street address 

select c.first_name , c.last_name, a.address
from customer c JOIN address a;

-- Hmmm there are only 599 customers and 603 rows in the address table , so how did the results set end up with 36,197 rows?
-- Looking more closely , you can see that many of the customers seem to have the same street address.
-- Because the query did not specify how the two tables should be joined , the database server generated the Cartesian Product , Which is every permutation combination of the two tables.
-- (599 customers * 603 addresses = 361,197 permutations) This type of join known as cross join and its not used 


-- INNER JOINS
-- If you are not specifying join type of join , then the server will do an inner join by default

select c.first_name , c.last_name , a. address 
from customer c JOIN address a 
ON c.address_id = a.address_id; 


-- By using inner join

SELECT c.first_name , c.last_name , a.address 
FROM customer c INNER JOIN address a 
ON c.address_id = a.address_id ;

-- USING 
-- Using is a shorthand operator notation that you can use in only a specific situation 

SELECT c.first_name , c.last_name , a.address 
from customer c , address a 
where c.address_id = a.address_id;

-- Question Written query which returns only the those customers whose postal code is 52137 

select c.first_name , c.last_name ,  a.address 
from customer c , address a 
where c.address_id = a.address_id 
AND a.postal_code = 52137;

SELECT c.first_name, c.last_name, a.address
from customer c INNER JOIN address a 
ON c.address_id = a.address_id
WHERE a.postal_code = 52137;

-- above query give more clearity to understand 

-- JOINING the THREE or more TABLES
-- Lets see table 

desc address;
desc city;

SELECT c.first_name, c.last_name, ct.city 
FROM customer c 
INNER JOIN address a 
    ON c.address_id = a.address_id 
INNER JOIN city ct 
    ON a.city_id = ct.city_id;
    
select c.first_name , c.last_name , ct.city 
from city ct 
INNER JOIN address a 
ON a.city_id = ct.city_id
INNER JOIN customer c 
on c.address_id = c.address_id;

-- You will see all first name and last name are same 

select c.first_name , c.last_name , ct.city 
from address a  
INNER JOIN city ct
ON a.city_id = ct.city_id
INNER JOIN customer c 
on c.address_id = c.address_id;


-- Using Subqueries as tables 

SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer c
INNER JOIN 
(
    SELECT a.address_id, a.address, ct.city
    FROM address a 
    INNER JOIN city ct
        ON a.city_id = ct.city_id
    WHERE a.district = 'California'
) addr
ON c.address_id = addr.address_id;

-- Results of subquery used in above query & subquery provide all nine city of califonia address 

    SELECT a.address_id, a.address, ct.city
    FROM address a 
    INNER JOIN city ct
        ON a.city_id = ct.city_id
    WHERE a.district = 'California';
    
    
-- Using the same table twice 
-- Question Finds all of the films in whichtwo specific actors appear.
-- You could write a query such as this one , which joins the film table to the film_actor table
SELECT f.title 
FROM film f 
INNER JOIN film_actor fa
    ON f.film_id = fa.film_id
INNER JOIN actor a 
    ON fa.actor_id = a.actor_id
WHERE 
    (
        (a.first_name = 'CATE' AND a.last_name = 'MCQEEN') 
        OR 
        (a.first_name = 'CUBA' AND a.last_name = 'BIRCH')
    );
    
-- Above query return all movies in which either Cate McQueen or Cuba Birch appeared.alter

-- Let's say that you want to retrive only those films in which both of these actors appeared 

SELECT f.title 
FROM film f 
INNER JOIN film_actor fa1 
    ON f.film_id = fa1.film_id
INNER JOIN actor a1 
    ON fa1.actor_id = a1.actor_id
INNER JOIN film_actor fa2
    ON f.film_id = fa2.film_id
INNER JOIN actor a2 
    ON fa2.actor_id = a2.actor_id
WHERE 
    (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
    AND 
    (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');
