--1
SELECT PRODUCTLINE, YEAR_ID, DEALSIZE, SUM(quantityordered*priceeach) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
GROUP BY PRODUCTLINE, YEAR_ID, DEALSIZE
ORDER BY PRODUCTLINE, YEAR_ID, DEALSIZE

--2
WITH rev_rank AS(SELECT YEAR_ID, MONTH_ID, SUM(quantityordered*priceeach) REVENUE, COUNT(*) AS ORDER_NUMBER,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(quantityordered*priceeach) DESC) AS rank
FROM public.sales_dataset_rfm_prj_clean
GROUP BY YEAR_ID, MONTH_ID)
SELECT MONTH_ID,  REVENUE, ORDER_NUMBER
FROM rev_rank
WHERE rank=1

--3
SELECT MONTH_ID, PRODUCTLINE, SUM(quantityordered*priceeach) AS REVENUE, COUNT(*) AS ORDER_NUMBER
FROM public.sales_dataset_rfm_prj_clean
WHERE MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY REVENUE DESC
LIMIT 1;

--4
WITH UK_rev_rank AS(SELECT YEAR_ID, PRODUCTLINE,SUM(quantityordered * priceeach) AS REVENUE, 
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(quantityordered * priceeach) DESC) AS RANK
FROM SALES_DATASET_RFM_PRJ_CLEAN
WHERE country ='UK'
GROUP BY YEAR_ID, PRODUCTLINE)
SELECT YEAR_ID, PRODUCTLINE,REVENUE, RANK
FROM UK_rev_rank
WHERE rank =1

--5
with rfm_table AS(
SELECT customername, current_date-MAX(orderdate) AS R, count(distinct ordernumber) AS F, sum(sales) AS M
FROM sales_dataset_rfm_prj_clean
GROUP BY customername),
rfm_score AS(
SELECT customername,
ntile(5) OVER (ORDER BY R DESC) AS r_score,
ntile(5) OVER (ORDER BY F) AS f_score,
ntile(5) OVER (ORDER BY M DESC) AS m_score
FROM rfm_table),
rfm AS(
SELECT customername,
CAST (r_score AS VARCHAR)||CAST (f_score AS VARCHAR)||CAST(m_score AS VARCHAR) AS rfm_score 
FROM rfm_score)
SELECT segment, COUNT(*) FROM (SELECT customername, segment FROM rfm r
JOIN segment_score s ON s.scores=r.rfm_score) a
GROUP BY segment
