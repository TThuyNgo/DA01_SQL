--ex1
SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;
--ex2
SELECT *,
CASE WHEN x+y>z AND x+z>y AND y+z>x THEN 'Yes'
ELSE 'No'
END AS triangle
FROM Triangle;
--ex3 ???
--ex4
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL
--ex5
select survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
from titanic
GROUP BY survived;
