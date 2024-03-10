--1
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN ordernumber TYPE numeric USING ordernumber::numeric
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN priceeach TYPE decimal USING priceeach::decimal
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN sales TYPE decimal USING sales::decimal
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN msrp TYPE decimal USING msrp::decimal
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)
--2
SELECT * FROM SALES_DATASET_RFM_PRJ
WHERE 
  (ORDERNUMBER IS NULL OR ORDERNUMBER = 0) 
  OR (QUANTITYORDERED IS NULL OR QUANTITYORDERED = 0)
  OR (PRICEEACH IS NULL OR PRICEEACH = 0)
  OR (ORDERLINENUMBER IS NULL OR ORDERLINENUMBER = 0)
  OR (SALES IS NULL OR SALES = 0)
  OR (ORDERDATE IS NULL OR ORDERDATE = '');
--3
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN contactlastname VARCHAR(50),
ADD COLUMN contactfirstname VARCHAR(50);

UPDATE SALES_DATASET_RFM_PRJ
SET 
  contactfirstname = SUBSTRING(contactfullname FROM 1 FOR POSITION('-' IN contactfullname) - 1),
  contactlastname = SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1);
--4
ALTER TABLE SALES_DATASET_RFM_PRJ
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER

UPDATE SALES_DATASET_RFM_PRJ
SET QTR_ID = EXTRACT(quarter FROM orderdate),
    MONTH_ID = EXTRACT(month FROM orderdate),
	YEAR_ID = EXTRACT(year FROM orderdate)
--5
WITH z_score_method AS (SELECT orderdate, quantityordered, 
(SELECT avg(quantityordered) FROM SALES_DATASET_RFM_PRJ) AS avg,
(SELECT stddev(quantityordered) FROM SALES_DATASET_RFM_PRJ) AS stddev
FROM SALES_DATASET_RFM_PRJ)
SELECT orderdate, quantityordered, (quantityordered-avg)/stddev AS result
FROM z_score_method
WHERE abs(quantityordered-avg)/stddev>=3 
UPDATE SALES_DATASET_RFM_PRJ
SET quantityordered = (SELECT avg(quantityordered) FROM SALES_DATASET_RFM_PRJ)
WHERE quantityordered IN (SELECT quantityordered FROM z_score_method)

--OR method 2
WITH min_max_method AS (SELECT Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value 
FROM (SELECT percentile_cont (0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1, 
percentile_cont (0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3, 
percentile_cont (0.75) WITHIN GROUP (ORDER BY quantityordered)-percentile_cont (0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
	  FROM SALES_DATASET_RFM_PRJ) AS define)
SELECT * FROM SALES_DATASET_RFM_PRJ				
WHERE quantityordered<(SELECT min_value FROM min_max_method)
OR  quantityordered>(SELECT max_value FROM min_max_method)				
