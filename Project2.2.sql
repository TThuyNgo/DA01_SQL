/*Tạo metric*/
WITH rev_table AS (
  SELECT
    year_month,
    TPV,
    TPO,
    LAG(TPV) OVER (ORDER BY year_month) AS previous_TPV,
    LAG(TPO) OVER (ORDER BY year_month) AS previous_TPO
  FROM (
    SELECT
      CAST(CONCAT(FORMAT_DATE('%Y-%m', created_at),'-01') AS DATE) AS year_month,
      SUM(sale_price) AS TPV,
      COUNT(DISTINCT order_id) AS TPO
    FROM bigquery-public-data.thelook_ecommerce.order_items
    GROUP BY year_month
    ORDER BY year_month
  ) AS sales_by_month
),
cost_table AS (
  SELECT
    CAST(CONCAT(FORMAT_DATE('%Y-%m', o.created_at),'-01') AS DATE) AS year_month,
    SUM(p.cost) AS Total_cost
  FROM `bigquery-public-data.thelook_ecommerce.products` AS p
  JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS o ON p.id = o.product_id
  GROUP BY year_month
  ORDER BY year_month
)

SELECT 
  r.year_month,
  EXTRACT(YEAR FROM r.year_month) AS year,
  TPV,
  TPO,
  CONCAT(ROUND((TPV-previous_TPV)/previous_TPV*100,2),'%') AS Revenue_growth,
  CONCAT(ROUND((TPO-previous_TPO)/previous_TPO*100,2),'%') AS Order_growth,
  Total_cost,
  TPV-Total_cost AS Total_profit,
  (TPV-Total_cost)/Total_cost AS Profit_to_cost_ratio
FROM rev_table r
JOIN cost_table c ON c.year_month = r.year_month
ORDER BY r.year_month

/*cohort analysis*/
WITH cohort AS (
SELECT
user_id,order_id,
FORMAT_DATE('%Y-%m', first_purchase_date) AS cohort_date,
created_at,
(EXTRACT(YEAR FROM created_at)-EXTRACT(YEAR FROM first_purchase_date))*12 + (EXTRACT(month FROM created_at) -EXTRACT(month FROM first_purchase_date)) +1 AS index
FROM(
SELECT 
    user_id,
    order_id,
    MIN(created_at) OVER (PARTITION BY user_id) AS first_purchase_date,
    created_at
FROM 
    bigquery-public-data.thelook_ecommerce.orders
GROUP BY 
    user_id, created_at,order_id) a)
, prep AS(SELECT
cohort_date, index,count(distinct user_id) AS cohort_size, count(order_id) total_orders
FROM cohort
GROUP BY cohort_date, index)
SELECT cohort_date,
SUM(CASE WHEN index = 1 THEN cohort_size ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN cohort_size ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN cohort_size ELSE 0 END) AS m3,

FROM prep
GROUP BY cohort_date
ORDER BY  cohort_date

/*visualization link*/
https://docs.google.com/spreadsheets/d/1251nYVxiJbEsjHf5svN4dqhjJtPsruHx1vyiuwV39lw/edit#gid=935230167
