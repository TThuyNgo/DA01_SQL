--ex1
WITH new_table AS (SELECT company_id,title, description,COUNT(job_id)
FROM job_listings 
GROUP BY company_id,title, description
HAVING COUNT(job_id)>=2)   
SELECT COUNT(company_id) AS duplicate_companies
FROM new_table;
--ex2
--ex3
SELECT COUNT(policy_holder_id) AS member_count
FROM (SELECT policy_holder_id, COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3) AS first_query;
--ex4
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE liked_date IS NULL
ORDER BY p.page_id ASC;
--ex5
--ex6
--ex7
SELECT product_id, year as first_year ,quantity, price
FROM Sales
WHERE (product_id, year) IN (SELECT product_id, min(year) FROM Sales GROUP BY product_id)
--ex8
SELECT  customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key ) = (SELECT COUNT(*) FROM Product) 
--ex9
SELECT employee_id 
FROM Employees 
WHERE salary<30000 AND manager_id NOT IN (
    SELECT employee_id 
    FROM Employees)
ORDER BY employee_id
--ex10
WITH job_count_table AS(SELECT company_id, title, description, COUNT(job_id) as job_count
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_count_table
WHERE job_count > 1
--ex11
(SELECT name as results
FROM Users u
JOIN MovieRating m on m.user_id = u.user_id
GROUP BY name
ORDER BY COUNT(*) DESC,name LIMIT 1)
UNION ALL
(SELECT title AS results
FROM Movies m
JOIN MovieRating r ON r.movie_id = m.movie_id
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002
GROUP BY m.movie_id 
ORDER BY AVG(rating) DESC, title
LIMIT 1)
--ex12
WITH new_table AS (SELECT accepter_id AS id FROM RequestAccepted UNION ALL SELECT requester_id  AS id FROM RequestAccepted)
SELECT id, count(*) AS num 
FROM new_table 
GROUP BY id
ORDER BY num DESC
LIMIT 1

