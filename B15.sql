--ex1
WITH twt_new_table AS(
SELECT EXTRACT(year FROM transaction_date) as year, product_id, 
SUM(spend) AS curr_year_spend
FROM user_transactions
GROUP BY product_id, year
ORDER BY year)
SELECT year,product_id, curr_year_spend, 
LAG(curr_year_spend) OVER( PARTITION BY product_id ORDER BY year) AS prev_year_spend,
ROUND((curr_year_spend-LAG(curr_year_spend) OVER( PARTITION BY product_id ORDER BY year))/
LAG(curr_year_spend) OVER( PARTITION BY product_id ORDER BY year)*100,2) AS yoy_rate
FROM twt_new_table
--ex2
WITH min_launch_date AS (SELECT 
  card_name,
  issued_amount,
  DATE(issue_year || '-' || issue_month || '-01') AS issue_date,
  MIN(DATE(issue_year || '-' || issue_month || '-01')) OVER (
    PARTITION BY card_name) AS launch_date
FROM monthly_cards_issued)
SELECT card_name, issued_amount
FROM min_launch_date
WHERE issue_date=launch_date
ORDER BY issued_amount DESC;
--ex3
SELECT user_id, spend, transaction_date 
FROM (SELECT user_id, spend, transaction_date,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rank
FROM transactions) AS rank_table
WHERE rank =3
--ex4
WITH count_table AS(
SELECT user_id,transaction_date, product_id,
Rank() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions)
SELECT transaction_date, user_id, COUNT(product_id) purchase_count 
FROM count_table 
WHERE rank = 1
GROUP BY user_id, transaction_date
ORDER BY transaction_date
--ex5
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;
--ex6
WITH time_diff_table AS( 
SELECT *, LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id,amount 
ORDER BY transaction_timestamp) AS prev_transaction_time, 
EXTRACT(EPOCH FROM transaction_timestamp-LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id,amount 
ORDER BY transaction_timestamp))/60 AS time_diff
FROM transactions)
SELECT count(merchant_id)
FROM time_diff_table
WHERE time_diff<=10
--ex7
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
--ex8
WITH rank_table AS (SELECT artist_name, 
DENSE_RANK () OVER( ORDER BY COUNT(s.song_id) DESC) AS artist_rank
FROM artists a 
JOIN songs  s ON s.artist_id=a.artist_id
JOIN global_song_rank g ON g.song_id=s.song_id
WHERE rank<=10
GROUP BY artist_name)
SELECT artist_name, artist_rank
FROM rank_table
WHERE artist_rank <=5
