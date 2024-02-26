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
