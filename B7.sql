--ex1
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID
--ex2
SELECT user_id , CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name, length(name)-1))) AS name 
FROM Users
ORDER BY user_id
--ex3
SELECT manufacturer, '$'||ROUND(sum(total_sales)/1000000)||' '||'million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) DESC,manufacturer;
--ex4
SELECT EXTRACT(month FROM submit_date) AS month, product_id, 
ROUND(AVG(stars),2) AS avg_stars	 
FROM reviews
GROUP BY EXTRACT(month FROM submit_date),product_id
ORDER BY EXTRACT(month FROM submit_date),product_id;
--ex5
SELECT sender_id, COUNT(message_id)	 
FROM messages
WHERE EXTRACT(month FROM sent_date)=08 
AND EXTRACT(year FROM sent_date)=2022
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2;
--ex6
SELECT  tweet_id
from Tweets
WHERE length(content)>15
--ex7
SELECT activity_date as day, COUNT(DISTINCT user_id) as active_users 
FROM Activity
WHERE  activity_date BETWEEN '2019-06-27' AND '2019-07-27'
GROUP BY activity_date
--ex8
select COUNT(*)
from employees
where EXTRACT(month FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(year FROM joining_date) =2022;
--ex9
select POSITION ('a' IN first_name) 
from worker
where first_name = 'Amitah';
--ex10
select title, SUBSTRING(title, length(winery)+2, 4) as year
from winemag_p2
where country = 'Macedonia';
