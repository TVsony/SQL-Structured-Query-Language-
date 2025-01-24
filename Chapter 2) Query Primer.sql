-- Select the Data base were you want to work 
USE Sakila ;

select first_name , last_name from customer
WHERE last_name = 'ZIEGLER';

-- Above Query not showing results but executed it show Empty set 

SELECT * FROM customer;


-- This Query show 16 rows in set 

SELECT * from category;

-- Query Clauses 
-- 1) SELECT ---> Determines which columns to include in the query's result set 
-- 2) FROM ----> Identify the tables from which to retrive data and how the tables should be joined 
-- 3) WHERE ----> Filters out unwanted data 
-- 4) GROUP BY --->  Used to group rows together by common column values 
-- 5) HAVING ---> Filterout Unwanted groups 
-- 6) ORDER BY ---> Sorts the rows of the final result set by one or more column 


-- You can check the count tables in your Database 

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Sakila';

-- Lets see SELECT Statement 
-- SELECT Clause or Statement is DQL (Data Query Language ) 
-- Its is used to retrive the Data from tables with help of FROM Clause 
-- We can retrive all Data from trable by using * (asterisk) symbol or charector 
-- We can select perticular columns by providing columns name 

SELECT * 
FROM language ;

select * from customer;

select * 
from film;

select language_id , name, last_update 
from language;

select name 
from language;

select language_id, 'COMMON' language_usage,
language_id * 3.1415927 lang_pi_value,
upper(name) language_name
FROM language;


-- Column Aliases 

-- You will generate labels for the columns as per your conviness By using AS 

SELECT language_id, 
'COMMON' AS language_usage,
language_id * 3.1415927 AS lang_pi_value,
upper(name) AS language_name
FROM language;


-- Removing the Duplicates 

-- Check duplicate record  you will be see the actor ID Multiple times 5462 rows in set 
SELECT actor_id 
FROM film_actor 
ORDER BY actor_id;

-- You can retrive distinct (unique) record by using the distict keyword you will see 200 rows 

SELECT DISTINCT actor_id 
FROM film_actor 
ORDER BY actor_id;

-- types of Tables 
-- 1) Permanent Tables ( Using Create table Statement )
-- 2) Derived Tables ( Rows retured by subquery and held in memory)
-- 3) Temporary Tables ( Volatile data held in memory )
-- 4) Virtual Tables ( created using the create view Statements)

-- SUBQUERY Table 
-- Subquery is a query contained within another query. Subqueries are  surrounded by parenthesis and
-- Can be found various parts of select statements within from clause 
-- A Subuquery serves the role of generating a derived table that is visible from all other query clause 
-- and interact with other tables 


SELECT concat(cust.last_name, ',', cust.first_name) full_name 
FROM 
(SELECT first_name , last_name, email
FROM customer 
WHERE first_name ='JESSIE'
) cust;

-- Temporary Table or Volatile Table 

-- These tables look like just like permanent table but any data inserted into a temp table will disappear at some point
-- When database session closed 

-- Create the temporary table
CREATE TEMPORARY TABLE actors_j 
(
    actor_id SMALLINT(5),
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

-- Insert data into the temporary table
INSERT INTO actors_j (actor_id, first_name, last_name)
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'J%';

SELECT * FROM actors_j;


-- View 
-- Its also known as virtual table. 
-- A view is a query that is stored in the data dictionary.
-- Its looks and acts like table , but there is no data associated with a view 
-- When you issue a query against a view your query is merged with the view 
-- definition to create a final query to be excuted 

CREATE VIEW
cust_vws AS 
SELECT customer_id , first_name , last_name, active
FROM customer;

-- View is created to hidding data from the user 
select first_name , last_name from cust_vws
where active = 0;









