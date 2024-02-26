--ex3
SELECT manufacturer, '$'||ROUND(sum(total_sales)/1000000)||' '||'million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) DESC,manufacturer;
--ex4
