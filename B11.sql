--ex1
SELECT Co.CONTINENT,FLOOR(AVG(Ci.POPULATION))
FROM COUNTRY Co
JOIN CITY Ci ON Ci.COUNTRYCODE = Co.CODE
GROUP BY Co.CONTINENT
--ex2
SELECT ROUND(CAST(COUNT(texts.email_id) AS DECIMAL)/COUNT(emails.email_id),2) AS confirm_rate
FROM emails
LEFT JOIN texts ON texts.email_id=emails.email_id
AND signup_action = 'Confirmed';
--ex3
SELECT  b.	age_bucket, 
ROUND(SUM(a.time_spent) FILTER (WHERE a.activity_type = 'send')/SUM(a.time_spent)*100,2) AS send_perc,
ROUND(SUM(a.time_spent) FILTER (WHERE a.activity_type = 'open')/SUM(a.time_spent)*100,2) AS open_perc
FROM activities a
JOIN age_breakdown b ON a.user_id = b.user_id
WHERE activity_type	IN ('send', 'open')
GROUP BY b.	age_bucket;
--ex4
SELECT c.customer_id, COUNT(DISTINCT p.product_category) 
FROM customer_contracts c
LEFT JOIN products p ON p.product_id=c.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT p.product_category) =3
--ex5
SELECT employee_id, name, COUNT(reports_to) AS reports_count , FLOOR(AVG(age)) AS average_age 
FROM Employees
HAVING COUNT(reports_to)>=0
--ex6
SELECT product_name, SUM(unit) AS unit
FROM Products p
INNER JOIN Orders o ON p.product_id = o.product_id
WHERE EXTRACT(month FROM order_date)=02 AND EXTRACT(year FROM order_date)=2020
GROUP BY product_name
HAVING SUM(unit)>=100
--ex7
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE l.page_id IS NULL;
