-- Easy --- 

-- Q 1) Show first name, last name, and gender of patients whose gender is 'M'
select
  first_name,
  last_name,
  gender
from patients
WHERE gender = 'M';

-- Q2) Show first name and last name of patients who does not have allergies. (null)
select
  first_name,
  last_name
from patients
WHERE allergies IS NULL;

-- Q 3) Show first name of patients that start with the letter 'C'
select first_name
from patients
where first_name like 'C%';

-- Q 4) Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select
  first_name,
  last_name
from patients
where weight between 100 ANd 120;

-- Q5) Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients
set allergies = 'NKA'
WHere allergies IS NULL;

-- Q7) Show first name and last name concatinated into one column to show their full name.
select
  concat(first_name, ' ', last_name) AS full_name
from patients;

-- Q8) Show first name, last name, and the full province name of each patient.
select
  first_name,
  last_name,
  province_name
from patients
  JOIN province_names ON province_names.province_id = patients.province_id;

-- Q9) Show how many patients have a birth_date with 2010 as the birth year.
select count(*) AS total_patients
from patients
where year(birth_date) = 2010;

-- Q10) Show the first_name, last_name, and height of the patient with the greatest height.
select
  first_name,
  last_name,
  height
from patients
WHERE height = (
    select max(height)
    from patients
  );

-- Q11) Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select *
from patients
where
  patient_id IN(1, 45, 534, 879, 1000);

-- Q12) Show the total number of admissions
select count(*) AS total_addmissions
from admissions;

-- Q13) Show all the columns from admissions where the patient was admitted and discharged on the same day.
select *
from admissions
where admission_date = discharge_date;

-- Q14) Show the patient id and the total number of admissions for patient_id 579.
select
  patient_id,
  count(*) AS total_admissions
from admissions
where patient_id IN(579);

-- Q15) Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
select distinct(city) AS unique_cities
from patients
where province_id IN('NS');

-- Q16) Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
select first_name , last_name, birth_date 
from patients
where height > 160 and weight > 70;


-- Q17) Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  city = 'Hamilton'
  and allergies is not null;
  

-- MEDIUM -----

-- Q 18) Show unique birth years from patients and order them by ascending.
SELECT
  DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;


-- Q 19) Show unique first names from the patients table which only occurs once in the list.

SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1

-- Q 19) Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name 
FROM patients 
WHERE first_name LIKE 'S_____%s';


-- Q20) Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.

SELECT
  patients.patient_id,
  first_name,
  last_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
WHERE diagnosis = 'Dementia';

-- Q 21) Display every patient's first_name. Order the list by the length of each name and then by alphabetically.
SELECT first_name
FROM patients
order by
  len(first_name),
  first_name;
  
 -- Q 22) Show the total amount of male patients and the total amount of female patients in the patients table.Display the two results in the same row.
SELECT 
  (SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
  (SELECT count(*) FROM patients WHERE gender='F') AS female_count;

-- Q 23) Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'.
-- Show results ordered ascending by allergies then by first_name then by last_name.

SELECT
  first_name,
  last_name,
  allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY
  allergies,
  first_name,
  last_name;


-- Q 24) Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT
  patient_id,
  diagnosis
FROM admissions
GROUP BY
  patient_id,
  diagnosis
HAVING COUNT(*) > 1;


-- Q 25) Show the city and the total number of patients in the city.Order from most to least patients and then by city name ascending. 

SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY city
ORDER BY num_patients DESC, city asc;


-- Q 26) Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;


-- Q 27) Show all allergies ordered by popularity. Remove NULL values from query
SELECT
  allergies,
  COUNT(*) AS total_diagnosis
FROM patients
WHERE
  allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC

-- Q 28) Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

-- Q 29) We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, 
--  then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order

SELECT
  CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;


-- Q 30) Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
SELECT
  province_id,
  SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000

-- Q 31)Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT
  (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

-- Q 32) Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT
  DAY(admission_date) AS day_number,
  COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;

-- Q 33) Show all columns for patient_id 542's most recent admission_date.
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date);
  
  
 
-- Q 34) Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR 
  (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  )
  
  
  -- Q 35) Show first_name, last_name, and the total number of admissions attended for each doctor.Every admission has been attended by a doctor.
  SELECT
  first_name,
  last_name,
  count(*) as admissions_total
from admissions a
  join doctors ph on ph.doctor_id = a.attending_doctor_id
group by attending_doctor_id;


-- Q 36) For each doctor, display their id, full name, and the first and last admission date they attended.
select
  doctor_id,
  first_name || ' ' || last_name as full_name,
  min(admission_date) as first_admission_date,
  max(admission_date) as last_admission_date
from admissions a
  join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;

-- Q 37) Display the total amount of patients for each province. Order by descending.

SELECT
  province_name,
  COUNT(*) as patient_count
FROM patients pa
  join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;

-- Q 38) For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

SELECT
  CONCAT(patients.first_name, ' ', patients.last_name) as patient_name,
  diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;
  

-- Q 39) display the first name, last name and number of duplicate patients based on their first name and last name.

select
  first_name,
  last_name,
  count(*) as num_of_duplicates
from patients
group by
  first_name,
  last_name
having count(*) > 1

-- Q 40) Display patient's full name,height in the units feet rounded to 1 decimal,
-- weight in the unit pounds rounded to 0 decimals,birth_date,gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.
select
    concat(first_name, ' ', last_name) AS 'patient_name', 
    ROUND(height / 30.48, 1) as 'height "Feet"', 
    ROUND(weight * 2.205, 0) AS 'weight "Pounds"', birth_date,
CASE
	WHEN gender = 'M' THEN 'MALE' 
  ELSE 'FEMALE' 
END AS 'gender_type'
from patients; 



-- Q 41) Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
-- (Their patient_id does not exist in any admissions.patient_id rows.)

SELECT
  patients.patient_id,
  first_name,
  last_name
from patients
where patients.patient_id not in (
    select admissions.patient_id
    from admissions
  );
  
-- Q42) Display a single row with max_visits, min_visits, average_visits where the maximum, minimum and average number of admissions per day is calculated. 
-- Average is rounded to 2 decimal places.
select 
	max(number_of_visits) as max_visits, 
	min(number_of_visits) as min_visits, 
  round(avg(number_of_visits),2) as average_visits 
from (
  select admission_date, count(*) as number_of_visits
  from admissions 
  group by admission_date
);


