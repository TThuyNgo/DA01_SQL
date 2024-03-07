--ex1
WITH new_table AS (SELECT company_id,title, description,COUNT(job_id)
FROM job_listings 
GROUP BY company_id,title, description
HAVING COUNT(job_id)>=2)   
SELECT COUNT(company_id) AS duplicate_companies
FROM new_table;
--ex2
(SELECT category, product, SUM(spend) total_spend
FROM product_spend
WHERE EXTRACT(year FROM transaction_date)= 2022 AND category ='appliance'
GROUP BY category, product
ORDER BY SUM(spend) DESC
LIMIT 2)
UNION ALL
(SELECT category, product, SUM(spend) total_spend
FROM product_spend
WHERE EXTRACT(year FROM transaction_date)= 2022 AND category ='electronics'
GROUP BY category, product
ORDER BY SUM(spend) DESC
LIMIT 2)
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
SELECT EXTRACT(month FROM current_month.event_date) as month, count(DISTINCT current_month.user_id) AS monthly_active_users
FROM user_actions current_month
LEFT JOIN user_actions prev_month ON current_month.user_id = prev_month.user_id
WHERE EXTRACT(month FROM current_month.event_date) = 7
AND EXTRACT(month FROM prev_month.event_date) = 6
GROUP BY EXTRACT(month FROM current_month.event_date);
--ex6
SELECT
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY country, DATE_FORMAT(trans_date, '%Y-%m');
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

