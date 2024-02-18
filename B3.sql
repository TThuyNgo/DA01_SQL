--Ex1
SELECT NAME FROM CITY
WHERE POPULATION >120000 AND COUNTRYCODE = 'USA';

--Ex2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN';

--Ex3
SELECT CITY, STATE FROM STATION
ORDER BY CITY;

--Ex4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' 
  OR CITY LIKE 'E%' 
  OR CITY LIKE 'I%' 
  OR CITY LIKE 'O%'
  OR CITY LIKE 'U%';

--EX5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a' 
OR CITY LIKE '%e' 
OR CITY LIKE '%i' 
OR CITY LIKE '%o'
OR CITY LIKE '%u';

--EX6
SELECT DISTINCT CITY FROM STATION
WHERE NOT (CITY LIKE 'A%' 
  OR CITY LIKE 'E%' 
  OR CITY LIKE 'I%' 
  OR CITY LIKE 'O%'
  OR CITY LIKE 'U%');

--EX7
SELECT name FROM Employee
ORDER BY name ASC;

--EX8
SELECT name FROM Employee
WHERE salary >2000 AND months <10
ORDER BY employee_id;

--EX9
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

--EX10
SELECT name FROM Customer 
WHERE referee_id IS NULL OR referee_id <> 2;

--EX11
SELECT name, population, area FROM World 
WHERE area >= 3000000 OR population >=25000000;

--EX12
SELECT DISTINCT V1.author_id AS id
FROM Views V1
JOIN Views V2 
ON V1.author_id = V2.viewer_id AND V1.article_id=V2.article_id
ORDER BY V1.author_id;

--EX13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

--EX14
select * from lyft_drivers
where yearly_salary<=30000 OR yearly_salary>=70000;

--EX15
select * from uber_advertising
where money_spent>100000 AND year = 2019;
