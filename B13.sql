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
