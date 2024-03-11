/*1.Số lượng đơn hàng và số lượng khách hàng mỗi tháng =>> tăng dần đều theo các tháng/năm, 
tuy nhiên vào T2 và T4 năm 20222, số lượng giảm không đáng kể so với 2 tháng trước đó*/
SELECT FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) AS month_year, COUNT(DISTINCT user_id) total_user, COUNT(order_id) total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE EXTRACT(YEAR FROM TIMESTAMP(created_at)) BETWEEN 2019 AND 2022
    AND EXTRACT(MONTH FROM TIMESTAMP(created_at)) <= 4
GROUP BY month_year
ORDER BY month_year;

/*2.Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
giá trị đơn hàng trung bình khá ổn định theo thời gian*/
SELECT FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) AS month_year, COUNT(DISTINCT user_id) distinct_users, sum(sale_price)/COUNT(DISTINCT order_id) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE EXTRACT(YEAR FROM TIMESTAMP(created_at)) BETWEEN 2019 AND 2022
    AND EXTRACT(MONTH FROM TIMESTAMP(created_at)) <= 4
GROUP BY month_year
ORDER BY month_year;

/*3.Khách hàng trẻ nhất là 12 tuổi cho cả F và M, khách hàng lớn tuổi nhất là 70 tuổi cho cả F và M*/
WITH ranked_users AS (
    SELECT first_name, last_name, gender, age,
      ROW_NUMBER() OVER (PARTITION BY gender ORDER BY age ASC) AS youngest_rank,
      ROW_NUMBER() OVER (PARTITION BY gender ORDER BY age DESC) AS oldest_rank
    FROM bigquery-public-data.thelook_ecommerce.users
    WHERE
      EXTRACT(YEAR FROM TIMESTAMP(created_at)) BETWEEN 2019 AND 2022
      AND EXTRACT(MONTH FROM TIMESTAMP(created_at)) <= 4
)
SELECT first_name,last_name, gender, age, 'youngest' AS tag
FROM ranked_users
WHERE youngest_rank = 1
UNION ALL
SELECT first_name, last_name, gender, age, 'oldest' AS tag
FROM ranked_users
WHERE oldest_rank = 1;

/*4.*/
WITH monthly_profit AS (
    SELECT 
        FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) AS month_year, 
        o.product_id, 
        p.name AS product_name, 
        p.cost, 
        SUM(p.retail_price - p.cost) AS profit,
        DENSE_RANK() OVER (PARTITION BY FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP(created_at)) ORDER BY SUM(p.retail_price - p.cost) DESC) AS rank_per_month
    FROM 
        bigquery-public-data.thelook_ecommerce.products p
    JOIN 
        bigquery-public-data.thelook_ecommerce.order_items o ON p.id = o.product_id
    GROUP BY 
        month_year, product_id, product_name, cost, o.created_at
)
SELECT
    month_year,
    product_id,
    product_name,
    cost,
    profit,
    rank_per_month
FROM
    monthly_profit
WHERE
    rank_per_month <= 5;

/*5.*/
SELECT DATE(created_at) AS dates, product_category, SUM(product_retail_price) as revenue
FROM bigquery-public-data.thelook_ecommerce.inventory_items
WHERE 
  DATE(created_at) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)
  AND DATE(created_at) <= CURRENT_DATE()
GROUP BY dates, product_category
