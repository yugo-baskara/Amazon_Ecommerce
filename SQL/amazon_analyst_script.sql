
-- ============================================ --
-- Project		: Amazon Ecommerce ETL Pipeline
-- Database		: MySQL 8
-- Author		: Y Baskara
-- Data Source	: Stable Space (kaggle)
-- Purpose		: -- Build an end-to-end ETL pipeline
				  -- Clean and transform raw ecommerce data
				  -- Perform data quality validation
				  -- Generate business KPIs
				  -- Produce analytical SQL queries
-- ============================================ --

-- ================ --
-- CREATE RAW TABLE --
-- ================ --

CREATE TABLE IF NOT EXISTS portofolio.ecommerce_amazon_raw
(
raw_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
user_id VARCHAR(50),
product_id VARCHAR(50),
category VARCHAR(100),
subcategory VARCHAR(100),
brand VARCHAR(100),
price VARCHAR(50),
discount VARCHAR(50),
final_price VARCHAR(50),
rating VARCHAR(20),
review_count VARCHAR(50),
stock VARCHAR(50),
seller_id VARCHAR(50),
seller_rating VARCHAR(20),
purchase_date VARCHAR(50),
shipping_time_days VARCHAR(50),
location VARCHAR(100),
device VARCHAR(50),
payment_method VARCHAR(50),
is_returned VARCHAR(20),
delivery_status VARCHAR(50),
source_file VARCHAR(150),
load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (raw_id)
)
;


-- ======================= --
-- Loading Data Into Table --
-- ======================= --

LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_ecommerce.csv'
INTO TABLE
portofolio.ecommerce_amazon_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
user_id,
product_id,
category,
subcategory,
brand,
price,
discount,
final_price,
rating,
review_count,
stock,
seller_id,
seller_rating,
purchase_date,
shipping_time_days,
location,
device,
payment_method,
is_returned,
delivery_status
)
SET source_file = 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_ecommerce.csv'
;

-- This configuration path depends on your Operating System and MySql Upload Directory 
-- Change this path according to your MySQL upload directory.


-- ================== --
-- Create Clean Table --
-- ================== --

CREATE TABLE IF NOT EXISTS portofolio.ecommerce_amazon_clean
(
order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
raw_id BIGINT UNSIGNED NOT NULL,
user_id VARCHAR(50) NOT NULL,
product_id VARCHAR(50) NOT NULL,
category VARCHAR(100) NOT NULL,
subcategory VARCHAR(100) NOT NULL,
brand VARCHAR(100) NOT NULL,
price_USD DECIMAL(12,2) NOT NULL,
discount_percentage decimal(5,2) NOT NULL,
final_price_USD DECIMAL(12,2) NOT NULL,
product_rating DECIMAL(3,1) NOT NULL,
review_count INT NOT NULL,
stock_level INT NOT NULL,
seller_id VARCHAR(50) NOT NULL,
seller_rating DECIMAL(3,1) NOT NULL,
purchase_date DATE NOT NULL,
shipping_time_days INT NOT NULL,
location_city VARCHAR(100) NOT NULL,
device_used VARCHAR(50) NOT NULL,
payment_method VARCHAR(50) NOT NULL,
is_returned_bool BOOLEAN NOT NULL,
delivery_status VARCHAR(50) NOT NULL,
load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (order_id),
KEY IDX_Clean_Purchase_Date (purchase_date),
KEY IDX_Clean_Brand (brand),
KEY IDX_perf_category_brand_revenue(category, brand, final_price_USD),
KEY IDX_perf_delivery_location(delivery_status, location_city)
)
;


-- =========================== --
-- Loading Data To Clean Table --
-- =========================== --

INSERT INTO	portofolio.ecommerce_amazon_clean
(
raw_id,
user_id,
product_id,
category,
subcategory,
brand,
price_USD,
discount_percentage,
final_price_USD,
product_rating,
review_count,
stock_level,
seller_id,
seller_rating,
purchase_date,
shipping_time_days,
location_city,
device_used,
payment_method,
is_returned_bool,
delivery_status
)
SELECT
r.raw_id,
trim(r.user_id),
trim(r.product_id),
trim(r.category),
trim(r.subcategory),
trim(r.brand),
CAST(nullif(trim(r.price), '') AS DECIMAL (12,2)),
CAST(trim(r.discount) AS DECIMAL (5,2)),
CAST(trim(r.final_price) AS DECIMAL (12,2)),
CAST(trim(r.rating) AS DECIMAL (3,1)),
CAST(trim(r.review_count) AS SIGNED),
CAST(trim(r.stock) AS SIGNED),
trim(r.seller_id),
CAST(trim(r.seller_rating) AS DECIMAL (3,1)),
str_to_date(trim(r.purchase_date), '%Y-%m-%d'),
CAST(trim(r.shipping_time_days) AS SIGNED),
trim(r.location),
trim(r.device),
trim(r.payment_method),
CASE WHEN lower(trim(r.is_returned)) = 'true' THEN 1 ELSE 0 END,
trim(r.delivery_status)
FROM
	portofolio.ecommerce_amazon_raw r
WHERE
	r.raw_id IS NOT NULL
;


-- ================== --
-- Audit Data Quality --
-- ================== --

-- Create Audit Table --

CREATE TABLE IF NOT EXISTS portofolio.ecommerce_amazon_audit
(
	audit_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    audit_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    check_name VARCHAR(100) NOT NULL,
    status VARCHAR(10) NOT NULL,
    metric_value DECIMAL(18,4) NULL,
    notes VARCHAR(255) null,
    PRIMARY KEY (audit_id)
)
;


-- Rows Total Validation --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'row_count_validation',
    CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE 'FAIL' END,
	COUNT(*),
    'total data cleansing success'
FROM
	portofolio.ecommerce_amazon_clean
;

-- Date Anomaly Audit --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'null_date_check',
    CASE WHEN SUM(CASE WHEN purchase_date IS NULL THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END,	
	SUM(CASE WHEN purchase_date IS NULL THEN 1 ELSE 0 END),
    'Total records with failed date parsing'
FROM
	portofolio.ecommerce_amazon_clean
;


-- Negative Price Anomaly --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'negative_price_check',
    CASE WHEN SUM(CASE WHEN final_price_USD < 0 THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END,	
	SUM(CASE WHEN final_price_USD < 0 THEN 1 ELSE 0 END),
    'total negative price'
FROM
	portofolio.ecommerce_amazon_clean
;


-- Anomaly Rating Audit --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'anomaly_rating_check',
    CASE WHEN SUM(CASE WHEN seller_rating > 5 or seller_rating < 0 THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END,
    SUM(CASE WHEN seller_rating > 5 OR seller_rating < 0 THEN 1 ELSE 0 END),
    'total anomaly rating'
FROM
	portofolio.ecommerce_amazon_clean
;

-- Discount Anomaly --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'discount_anomaly',
    CASE WHEN SUM(CASE WHEN discount_percentage > 100 OR discount_percentage < 0 THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END,
    SUM(CASE WHEN discount_percentage > 100 OR discount_percentage < 0 THEN 1 ELSE 0 END),
    'total anomaly discount'
FROM    
	portofolio.ecommerce_amazon_clean
;

-- Audit Stock --

INSERT INTO portofolio.ecommerce_amazon_audit
(
check_name,
status,
metric_value,
notes
)
SELECT
	'stock_level_availability',
	CASE WHEN SUM(CASE WHEN stock_level < 0 THEN 1 ELSE 0 END) = 0 THEN 'PASS' ELSE 'FAIL' END,
    SUM(CASE WHEN stock_level < 0 THEN 1 ELSE 0 END),
    'total anomaly stock'
FROM
	portofolio.ecommerce_amazon_clean
;


-- =================== --
-- KPI and Performance --
-- =================== --

SELECT
	COUNT(*) AS Total_Order,
    SUM(final_price_USD) AS Total_Gross_Revenue,
    AVG(final_price_USD) AS Total_Average_Revenue,
    SUM(CASE WHEN is_returned_bool = 1 THEN 1 ELSE 0 END) AS Total_Returned_Items,
    round((SUM(CASE WHEN is_returned_bool = 1 THEN 1 ELSE 0 END)/ COUNT(*)) * 100, 2) AS Return_Rate_Percentage
FROM
	portofolio.ecommerce_amazon_clean
;


-- =============================== --
-- Monthly Growth Month Over Month --
-- =============================== --

WITH monthly_metrics AS
(
SELECT
	date_format(purchase_date, '%Y-%m-01') AS sales_month,
    SUM(final_price_USD) AS monthly_revenue
FROM
	portofolio.ecommerce_amazon_clean
GROUP BY
	1
)
SELECT
	sales_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY sales_month) AS previous_month_revenue,
    round(((monthly_revenue - lag(monthly_revenue) OVER (ORDER BY sales_month)) /
    NULLIF(LAG(monthly_revenue) OVER (ORDER BY sales_month), 0)) * 100, 2) AS MOM_Growth_PCT 
FROM
	monthly_metrics
;


-- ============================ --
-- Best Seller Product Category --
-- ============================ --

SELECT
	category,
    brand,
    SUM(final_price_USD) as total_sales,
    COUNT(*) AS total_units_sold,
    RANK() OVER(
    PARTITION BY category ORDER BY SUM(final_price_USD) DESC
    ) as brand_rank_category
FROM
	portofolio.ecommerce_amazon_clean
GROUP BY
	1,2
;


-- =========================================================== --
-- Logistic Performance Analyst by Return Rate, Delay and City --
-- =========================================================== --

SELECT
	location_city,
    COUNT(*) as total_shipment,
    round(
    SUM(CASE WHEN delivery_status = 'Returned' THEN 1 ELSE 0 END) /
    COUNT(*) * 100, 2) as return_rate_pct,
    round(
    SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) /
    COUNT(*) * 100, 2) as delay_rate_pct
FROM
	portofolio.ecommerce_amazon_clean
GROUP BY
	1
ORDER BY
	return_rate_pct DESC
;


-- ========================= --
-- Automation and Scheduling --
-- ========================= --

DROP PROCEDURE IF EXISTS sp_refresh_ecommerce_pipeline;

DELIMITER $$
CREATE PROCEDURE sp_refresh_ecommerce_pipeline()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		INSERT INTO portofolio.ecommerce_amazon_audit (check_name, status, notes)
		VALUES ('SP_Refresh', 'Fail', 'System Failure, Abort Transaction (Rollback)');
	END;

	START TRANSACTION;
		TRUNCATE TABLE portofolio.ecommerce_amazon_clean;
        
        INSERT INTO portofolio.ecommerce_amazon_clean
        (
			raw_id,
			user_id,
            product_id,
            category,
            subcategory,
            brand,
            price_USD,
            discount_percentage,
            final_price_USD,
            product_rating,
            review_count,
            stock_level,
            seller_id,
            seller_rating,
            purchase_date,
            shipping_time_days,
            location_city,
            device_used,
            payment_method,
            is_returned_bool,
            delivery_status
		)
        SELECT
			r.raw_id,
            trim(r.user_id),
            trim(r.product_id),
            trim(r.category),
            trim(r.subcategory),
            trim(r.brand),
            CAST(nullif(trim(r.price), '') AS DECIMAL (12,2)),
            CAST(trim(r.discount) AS DECIMAL (5,2)),
            CAST(trim(r.final_price) AS DECIMAL (12,2)),
            CAST(trim(r.rating) AS DECIMAL (3,1)),
            CAST(trim(r.review_count) AS SIGNED),
            CAST(trim(r.stock) AS SIGNED),
            trim(r.seller_id),
            CAST(trim(r.seller_rating) AS DECIMAL (3,1)),
            str_to_date(trim(r.purchase_date), '%Y-%m-%d'),
            CAST(trim(r.shipping_time_days) AS SIGNED),
            trim(r.location),
            trim(r.device),
            trim(r.payment_method),
            CASE WHEN lower(trim(r.is_returned)) = 'true' THEN 1 ELSE 0 END,
            trim(r.delivery_status)
		FROM
			portofolio.ecommerce_amazon_raw r;

		INSERT INTO portofolio.ecommerce_amazon_audit (check_name, status, metric_value, notes)
		SELECT 'SP_Refresh_Success', 'Pass', COUNT(*), 'Pipeline Success Updated By Automatization'
		FROM portofolio.ecommerce_amazon_clean;

	COMMIT;
END$$

DELIMITER ;


-- NOTE:
-- This procedure performs a full refresh of the clean table.
-- TRUNCATE is intentionally used for performance.
-- In MySQL, TRUNCATE causes an implicit COMMIT, so the rollback
-- handler only applies to subsequent DML operations.



-- ========================= --
-- Activate Global Scheduler --
-- ========================= --

SET GLOBAL event_Scheduler = ON;


-- ================================ --
-- Automation Daily Event Scheduler --
-- ================================ --

DROP EVENT IF EXISTS EV_Daily_Ecommerce_Refresh;

CREATE EVENT IF NOT EXISTS EV_Daily_Ecommerce_Refresh
ON SCHEDULE EVERY 1 DAY
STARTS '2026-06-26 00:00:00'
DO
	CALL portofolio.sp_refresh_ecommerce_pipeline()
;

