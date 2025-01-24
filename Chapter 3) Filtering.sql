-- Condition Evaluation 
-- A where clause may contain one or more conditions, separated by the oprations and or 
 
-- WHERE first_name = 'STEVEN' OR create_date > '2006-01-01'

-- Two condition evaluation using OR  

-- WHERE true OR true --> true
-- WHERE true OR false --> true 
-- WHERE false OR true --> true
-- WHERE fasle OR false --> false 

-- Using Parentheses 

-- WHERE (first_name = 'STEVEN' OR last_name = 'YOUNG') AND create_data > '2006-01-01' 

-- Three condition evaluation using AND , OR 

-- WHERE (true OR true) AND true --> true 
-- WHERE (true OR true) AND true --> true
-- Where (false OR True) AND true --> true 
-- WHERE (false OR false) AND true ---> false 
-- WHERE (true OR true) AND false --> false 
-- WHERE (true OR false ) AND false --> false 
-- WHERE (false OR ture ) AND false --> false 
-- WHERE (false OR false) AND false --> false 


-- Using the not Operator 

-- WHERE NOT (first_name = 'STEVEN' OR last_name ='YOUNG') AND create_date > '2006-01-01'

-- Three condition evaluation using AND , OR, NOT 

-- WHERE NOT (true OR true ) AND true --> false 
-- WHERE NOT (true OR false ) AND true --> false
-- WHERE NOT (false OR true ) AND true --> false 
-- WHERE NOT (false OR false) AND true --> true 
-- WHERE NOT (true OR ture ) AND false --> false 
-- WHERE NOT (true OR false) AND false --> false 
-- WHERE NOT (false OR true) AND false --> false
-- WHERE NOT (false OR false) AND false --> false 


-- Building a Condition

-- Operator such as  = ,!=, <, > ,<>, like , in, Between  
-- Arithmatic Operator + , -, *, and / 
-- Expresion or Equality conditions    title ='RIVER OUTLAW' , amount = 375.33 
-- Eg 

SELECT c.email
from customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

-- Inequality condition 

SELECT c.email
from customer c 
INNER JOIN rental r 
ON c.customer_id = r.customer_id
WHERE date(r.rental_date) <> '2005-06-14';

-- Your Task is to remove rows from the rental table where the rental data was in 2004 

DELETE FROM rental 
WHERE year(rental_date) = 2004;

-- Range Condition 

SELECT customer_id , rental_date 
from rental
where rental_date < '2005-05-25';

SELECT customer_id, rental_date 
from rental
WHERE rental_date <= '2005-06-16'
AND rental_date >= '2005-06-14';

-- Between Oprator 
-- When you have both an upper and lower limit for your range you may chose to use 
-- a single condition that utilizes the operator rather than using two separate condition.

SELECT customer_id , rental_date
from rental 
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

-- Keep in mind  You should alway specify the lower limit of range first (after BEETWEEN) 
-- and the upper limit of the range second (after AND) if you give upper limit first result show empty

SELECT customer_id , rental_date
FROM rental 
WHERE rental_date >= '2005-06-16'
AND rental_date <= '2005-06-14'; 

-- Numeric Range (lower limit first ) 
SELECT customer_id , payment_date, amount
FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;

-- String Range 
SELECT last_name, first_name 
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FR';

-- Above gives 18 records and Below provide 22 records 

SELECT last_name, first_name 
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FRB';

-- Membership conditions

SELECT title , rating 
FROM film 
where rating = 'G' OR rating = 'PG';

-- OR you can use in oprator and you can write many expresion no matter 

SELECT title , rating
from film
WHERE rating IN ('G','PG');  


-- Using Subquery 

SELECT title, rating
from film
WHERE rating IN ( SELECT rating FROM film WHERE title LIKE '%PET%');

-- Using NOT

SELECT title, rating 
FROM film
WHERE rating NOT IN ('PG-13','R', 'NC-17');

-- Matching Condition 
-- Question Find all the customer name whose last name start with Q. 
-- you could use the built in function strip off the first letter of the last name 

SELECT last_name , first_name 
FROM customer
WHERE left(last_name, 1) = 'Q';

-- left() function does the job , it doesn't give you much flexibility. You can use wildcard charector  

-- Using Wildcard 
--  1)  -      -->  Extract one Charector
--  2)  %      --> Any number of Charectors(including 0) 
--  3)  F%     --> String begining with F 
--  4)  %t     --> String Ending with t
--  5)  %bas%  --> Strings containing the substring 'bas'
--  6)   _ _ t_ --> Four charector strings with t in the third position 

-- Question A string containing an A in the 2nd position and T in the fourth postion followed by any 
-- number of charector and ending in S.

SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

-- You can use Multiple search expresions 

-- Finds all customers whose lasr name beging with Q and Y 

SELECT last_name , first_name 
FROM customer
WHERE last_name LIKE 'Q%' OR last_name like 'Y%';

-- Using the regular Expresion 

select last_name, first_name 
from customer 
where last_name REGEXP '^[QY]';

-- NULL --> Null is the absence of value

select rental_id ,customer_id
from rental 
WHERE return_date IS NULL;

-- If you want to see whether a value has been assigned to a column , you can use the is not null operator 

select rental_id , customer_id , return_date
from rental 
WHERE return_date IS NOT NULL;

-- dont use  WHERE return_date = NULL;   You have to Alway use WHERE return_date IS NOT NULL;

-- Question Finds all rentals that were not returned during the MAy throuh August of 2005 

select rental_id , customer_id , rental_date
from rental
where rental_date IS NULL 
OR rental_date NOT BETWEEN '2005-05-01' AND '2005-09-01';




 