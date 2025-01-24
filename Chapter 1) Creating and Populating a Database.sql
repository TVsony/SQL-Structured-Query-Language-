-- Chapter 1) Creating and Populating a Database 

-- To Show Databases 
Show Databases;

-- You want to work with 
use sakila;

-- You want to know the current date & time 
SELECT now();

select now()
from dual;

-- To view the supported charector sets 

show character set;

-- To create Databases name New
create	database New;

-- To work with Database 
use New;

-- To create New Table & its columns with Datatype 

Create table Person(
person_id int,
fname varchar(20),
lname varchar(20),
birth_date DATE,
Stree varchar(20),
City varchar(20),
State varchar(20),
CONSTRAINT pk_person PRIMARY KEY (person_id)
);

-- To see Table Defination 
desc person;

-- Another eq of table create 
CREATE TABLE favorite_food (
    person_id INT,
    food VARCHAR(20),
    category VARCHAR(20),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) REFERENCES Person (person_id)
);

desc favorite_food;

-- Populating and Modifying Tables 

-- Exploring SQL data statements like insert, update, delete, and select 

-- inserting Data 

-- We know that person_id is just number we set it auto increment 
-- ALTER TABLE which is used to modify the defination of an exiting table 

ALTER TABLE Person
MODIFY person_id INT AUTO_INCREMENT;  

-- Above Query error occurs because person_id in the Person table is referenced by a foreign key in the favorite_food table, and MySQL does not allow modifying a column involved in a foreign key relationship directly.

ALTER TABLE favorite_food DROP FOREIGN KEY fk_fav_food_person_id;  

-- Now you can use same above query 

ALTER TABLE Person
MODIFY person_id INT AUTO_INCREMENT;


-- Now again you can Re-Add the Foreign Key Constraint

ALTER TABLE favorite_food
ADD CONSTRAINT fk_fav_food_person_id 
FOREIGN KEY (person_id) 
REFERENCES Person (person_id);

-- You can varify Table or schemma 

SHOW CREATE TABLE Person;

SHOW CREATE TABLE favorite_food;

-- The following Statement Creates a row in the person table 

INSERT INTO Person (Fname, Lname, birth_date)
			VALUES ('William', 'Turner', '1972-05-27');
            
-- In the above statement we do not provide person_id but its showing due auto increment 
            
-- To verify that the row has been inserted, 
select * from person;   

-- OR 

select person_id,fname,Lname,birth_date from person;

-- You can use where clause to retrive data from person table 

select person_id , Fname , Lname, birth_date from person 
WHERE person_id = 1 ;

select person_id , Fname , Lname, birth_date from person 
WHERE Lname = 'Turner';

select person_id , Fname , Lname, birth_date from person 
WHERE Fname = 'William' ;

select person_id , Fname , Lname, birth_date from person 
WHERE birth_date = '1972-05-27' ;

-- Insert values into the another table because Williams also provide information about his favorite food 

INSERT INTO favorite_food (person_id , food, category)
			VALUES ( 1, 'Pizza' ,'Veg');

INSERT INTO favorite_food (person_id, food, category)
				VALUES( 1,'Briyanee','Non-Veg');
                
INSERT INTO favorite_food(person_id, food, category)
				values(1,'Cookie','Beckry');
                
-- You can check William favorite food 

SELECT food from favorite_food;

SELECT food from favorite_food
where person_id = 1;

SELECT food from favorite_food 
where Fname = 'William';

SELECT ff.food
FROM favorite_food ff
JOIN Person p ON ff.person_id = p.person_id
WHERE p.Lname = 'Turner';

-- We can see Williams favorite food by alphabetical order 

SELECT food from favorite_food
WHERE person_id = 1 
ORDER BY food;

-- Add more records into person table 

INSERT INTO Person (person_id, Fname, Lname, birth_date, Stree, City, State)
VALUES (NULL, 'Susan', 'Smith', '1975-11-02', '23 Maple St', 'Arlington', 'VA');

-- You can check 

SELECT * from person;

SELECT person_id, Fname, Lname, birth_date from person;



-- UPDATEING DATA 

-- We can Update the Data into the person table 

UPDATE person
SET Stree = '1225 Tremont St', City = 'Boston', State = 'USA'
WHERE person_id = 1 ;


SELECT * from person;

-- DELETING DATA 

DELETE FROM person
WHERE person_id = 2;


SELECT * FROM person;

-- You can shift your work to another database 
USE Sakila;

SHOW TABLES;


desc customer;

use New;

desc favorite_food;

use Sakila;

-- Chapter 1st End  Happy Learning 



            
