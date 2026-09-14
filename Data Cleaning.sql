-- Data Cleaning
-- 1. Check Data
-- 2. Remove Duplicates 
-- 3. Null Values or Missing Values 
-- 4. Standardize & Clean Strings
-- 5. Correct Data Types & Dates
-- 6. Outlier & Validation check 
-- 7. Final Validation

-- Check Data
SELECT 
    *
FROM
    amazon_sale_report;
-- The Data is messey 

-- Total Rows
SELECT 
    COUNT(*) AS total_rows
FROM
    amazon_sale_report;
-- total_rows = 128975

-- Remove Duplicates
SELECT 
    *, COUNT(*)
FROM
    amazon_sale_report
GROUP BY `index` , order_id , `date` , `status` , fulfilment , sales_channel , ship_service_level , style , sku , category , size , asin , courier_status , qty , currency , amount , ship_city , ship_state , ship_postal_code , ship_country , promotion_ids , b2b , fulfilled_by , unnamed_22
HAVING COUNT(*) > 1;
-- As of now no duplicates however we will check later after deleting unnecessary columns and rows.

-- Missing Values

-- Null Values 
SELECT 
    COUNT(*),
    SUM(`index` IS NULL) AS null_index,
    SUM(`order_id` IS NULL) AS null_order_id,
    SUM(`date` IS NULL) AS null_date,
    SUM(`status` IS NULL) AS null_status,
    SUM(`fulfilment` IS NULL) AS null_fulfilment,
    SUM(`sales_channel` IS NULL) AS null_sales_channel,
    SUM(`ship_service_level` IS NULL) AS null_ship_service_level,
    SUM(`style` IS NULL) AS null_style,
    SUM(`sku` IS NULL) AS null_sku,
    SUM(`category` IS NULL) AS null_category,
    SUM(`size` IS NULL) AS null_size,
    SUM(`asin` IS NULL) AS null_asin,
    SUM(`courier_status` IS NULL) AS null_courier_status,
    SUM(`amount` IS NULL) AS null_amount,
    SUM(`qty` IS NULL) AS null_qty,
    SUM(`currency` IS NULL) AS null_currency,
    SUM(`ship_city` IS NULL) AS null_ship_city,
    SUM(`ship_state` IS NULL) AS null_ship_state,
    SUM(`ship_postal_code` IS NULL) AS null_ship_postal_code,
    SUM(`ship_country` IS NULL) AS null_ship_country,
    SUM(`promotion_ids` IS NULL) AS null_promotion_ids,
    SUM(`b2b` IS NULL) AS null_b2b,
    SUM(`fulfilled_by` IS NULL) AS null_fulfilled_by,
    SUM(`unnamed_22` IS NULL) AS null_unnamed_22
FROM
    amazon_sale_report;
-- No Null Values

-- Blank Values
SELECT 
    COUNT(*),
    SUM(`index` = '') AS blank_index,
    SUM(`order_id` = '') AS blank_order_id,
    SUM(`date` = '') AS blank_date,
    SUM(`status` = '') AS blank_status,
    SUM(`fulfilment` = '') AS blank_fulfilment,
    SUM(`sales_channel` = '') AS blank_sales_channel,
    SUM(`ship_service_level` = '') AS blank_ship_service_level,
    SUM(`style` = '') AS blank_style,
    SUM(`sku` = '') AS blank_sku,
    SUM(`category` = '') AS blank_category,
    SUM(`size` = '') AS blank_size,
    SUM(`asin` = '') AS blank_asin,
    SUM(`courier_status` = '') AS blank_courier_status,
    SUM(`amount` = '') AS blank_amount,
    SUM(`qty` = '') AS blank_qty,
    SUM(`currency` = '') AS blank_currency,
    SUM(`ship_city` = '') AS blank_ship_city,
    SUM(`ship_state` = '') AS blank_ship_state,
    SUM(`ship_postal_code` = '') AS blank_ship_postal_code,
    SUM(`ship_country` = '') AS blank_ship_country,
    SUM(`promotion_ids` = '') AS blank_promotion_ids,
    SUM(`b2b` = '') AS blank_b2b,
    SUM(`fulfilled_by` = '') AS blank_fulfilled_by,
    SUM(`unnamed_22` = '') AS blank_unnamed_22
FROM
    amazon_sale_report; 
-- There are several columns contain blank values therefore we are going to check them.

SELECT 
    fulfilled_by
FROM
    amazon_sale_report
GROUP BY fulfilled_by;
-- Since the data is not important we can remove the column.

alter table amazon_sale_report
drop column fulfilled_by;
 
SELECT 
    unnamed_22
FROM
    amazon_sale_report
GROUP BY unnamed_22;
-- We have figured out the data has no relevance as we can remove the column.

alter table amazon_sale_report
drop column unnamed_22; 

SELECT 
    promotion_ids
FROM
    amazon_sale_report
GROUP BY promotion_ids;
-- The data is not important so we can remove the column.

alter table amazon_sale_report
drop column promotion_ids;

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    amount = '';

-- The 'amount' column is very important so we should handle blank values carefully.

select 
	distinct `status`
from
    amazon_sale_report
where
    amount = '';
    
-- There are 6 types of status.

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Cancelled' AND amount = '';

-- Sone orders are cancelled (status = cancelled) and 'Qty' is also '0', Hence there are a lot of blank rows in amount column therefore we are going to replace blank values with '0'.

UPDATE amazon_sale_report 
SET 
    amount = 0
WHERE
    status = 'Cancelled' AND amount = '';
    
SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipped' AND amount = '';

-- There are 208 rows where 'status' is 'Shipped' and 'Courier_Status' is 'Unshipped or Cancelled' therefore we should check them further.

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipped' AND courier_status = 'Cancelled' and amount = '';

-- There are 93 rows where 'status' is 'Shipped' and 'Courier_status' is 'Cancelled' and 'qty' is '0' so we will change 'amount' as 'null'.
 
UPDATE amazon_sale_report 
SET 
    amount = NULL
WHERE
    `status` = 'Shipped'
        AND courier_status = 'Cancelled' and amount = '';

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipped' AND courier_status = 'Unshipped' and amount = '';

-- There are 115 rows where 'status' is 'Shipped' and 'Courier_status' is 'Unshipped' and 'qty' is 'int' so we will change 'amount' as 'null'. 

UPDATE amazon_sale_report 
SET 
    amount = NULL
WHERE
    `status` = 'Shipped'
        AND courier_status = 'Unshipped'
        AND amount = '';

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipped - Delivered to Buyer' AND amount = '';
    
-- There are 8 rows where 'status' is 'Shipped - Delivered to Buyer' although 'Courier_Status' is '' and 'Qty' is '0' therefor we will change 'amount' as 'null'. 

UPDATE amazon_sale_report 
SET 
    amount = NULL
WHERE
    `status` = 'Shipped - Delivered to Buyer' and amount = '';

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipped - Returned to Seller' AND amount = '';

-- There are 3 rows where 'status' is 'Shipped - Returned to Seller' however 'Courier_Status' is '' and 'Qty' is '0' therefor we will change 'amount' as 'null'. 

UPDATE amazon_sale_report 
SET 
    amount = NULL
WHERE
    `status` = 'Shipped - Returned to Seller' and amount = '';

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Pending' AND amount = '';
    
-- There are tow rows where 'status' is 'Pending' and 'Courier_status' is 'Cancelled' , So we can change 'amount' as '0'. 

UPDATE amazon_sale_report 
SET 
    amount = 0
WHERE
    `status` = 'Pending' and amount = '';

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    status = 'Shipping' AND amount = '';
    
-- There 8 rows where 'status' is 'Shipping' and 'Courier_status' is 'Unshipped', So we will change 'amount' as 'null'.

UPDATE amazon_sale_report 
SET 
    amount = NULL
WHERE
    `status` = 'Shipping' and amount = '';

SELECT 
    *
FROM
    amazon_sale_report
where 
    currency = '';
    
-- Since the currency column is dependent on the amount column hence we should check the 'amount' column.

SELECT DISTINCT
    amount
FROM
    amazon_sale_report
WHERE
    currency = '';
    
-- Where amount is null currency should be null and where amount is 0, it means transaction didn't happen so we can change currency as null.

UPDATE amazon_sale_report 
SET 
    currency = NULL
WHERE
	amount is NULL or amount = 0; 

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    courier_status = '';
    
-- we should check the 'status' column. 
    
SELECT 
    distinct `status`
FROM
    amazon_sale_report
where 
    courier_status = '';
    
-- There are 3 types of status.

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    `status` = 'Cancelled'
        AND courier_status = '';
        
-- 'status' is 'Cancelled' so we will change'courier_status' as 'null'.

UPDATE amazon_sale_report 
SET 
    courier_status = NULL
WHERE
    `status` = 'Cancelled' and courier_status = '';  

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    `status` = 'Shipped - Delivered to Buyer'
        AND courier_status = '';
        
-- 'status' is 'Shipped- Delivered to Buyer' although 'qty' is '0' therfore we will change 'Courier_status' as null.


UPDATE amazon_sale_report 
SET 
    courier_status = NULL
WHERE
    `status` = 'Shipped - Delivered to Buyer' and courier_status = ''; 

SELECT 
    *
FROM
    amazon_sale_report
WHERE
    `status` = 'Shipped - Returned to Seller'
        AND courier_status = '';

-- 'status' is 'Shipped- Returned to Seller' although 'qty' is '0' therfore we will change 'Courier_status' as null.

UPDATE amazon_sale_report 
SET 
    courier_status = NULL
WHERE
    `status` = 'Shipped - Returned to Seller' and courier_status = ''; 

SELECT
    *
FROM
    amazon_sale_report
WHERE
    ship_city = '' OR ship_state = ''
        OR ship_postal_code = ''
        OR ship_country = '';

-- As ship_city, ship_state, ship_postal_code and ship_country have equal blank rows, perhaps the addresses are missing therefore we can replace all blank values with 'null'.

UPDATE amazon_sale_report 
SET 
    ship_city = NULL,
    ship_state = NULL,
    ship_postal_code = NULL,
    ship_country = NULL
WHERE
    ship_city = '' AND ship_state = ''
        AND ship_postal_code = ''
        AND ship_country = '';

-- Clean Strings 
-- Space (leading & traling space, extra middle space)
-- Two columns (category, ship_state) might have issues and we need them for analysis.
SELECT 
    category
FROM
    amazon_sale_report
WHERE
    category <> TRIM(category);
-- NO leading & traling space

SELECT 
    category
FROM
    amazon_sale_report
WHERE
    category LIKE '%  %';
-- No extra middle space

SELECT 
    ship_state
FROM
    amazon_sale_report
WHERE
    ship_state <> TRIM(ship_state);
-- NO leading & traling space

SELECT 
    ship_state
FROM
    amazon_sale_report
WHERE
    ship_state LIKE '%  %';
-- No extra middle space

-- Standardized

SELECT DISTINCT
    category
FROM
    amazon_sale_report;
    
-- Coloumn 'category' is well starndardized.

SELECT DISTINCT
    ship_state
FROM
    amazon_sale_report
ORDER BY 
    ship_state;

-- Coloumn ship_state contains state names, some short names and extra names so we will fix them.
    
SELECT 
    ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'punjab/mohali/zirakpur';

-- 'punjab/mohali/zirakpur' shoud be standardized as punjab
    
UPDATE amazon_sale_report 
SET 
    ship_state = 'PUNJAB'
WHERE
    ship_state = 'punjab/mohali/zirakpur';

SELECT 
    ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'new delhi';

-- 'new delhi' shoud be standardized as delhi

UPDATE amazon_sale_report 
SET 
    ship_state = 'DELHI'
WHERE
    ship_state = 'new delhi';

-- For the short names we can check other column such as ship_city so we can get idea what they are refering for.

SELECT 
    ship_city, ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'rj';

-- it is rajasthan

UPDATE amazon_sale_report 
SET 
    ship_state = 'RAJASTHAN'
WHERE
    lower(ship_state) = 'rj';

SELECT 
    ship_city, ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'pb';

-- This is punjab

UPDATE amazon_sale_report 
SET 
    ship_state = 'PUNJAB'
WHERE
    lower(ship_state) = 'pb';

SELECT 
    ship_city, ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'ar';
-- it is arunachal pradesh

UPDATE amazon_sale_report 
SET 
    ship_state = 'ARUNACHAL PRADESH'
WHERE
    lower(ship_state) = 'ar';

SELECT 
    ship_city, ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'apo';
-- Nothing is clear what it is

UPDATE amazon_sale_report 
SET 
    ship_state = 'Unknown',
    ship_city = 'Unknown'
WHERE
    LOWER(ship_state) = 'apo'
        AND LOWER(ship_city) = 'apo';
    
SELECT 
    ship_city, ship_state
FROM
    amazon_sale_report
WHERE
    LOWER(ship_state) = 'nl';
-- ship_city is 'DIMAPUR' therefore 'nl' should be 'NAGALAND'.

UPDATE amazon_sale_report 
SET 
    ship_state = 'NAGALAND'
WHERE
    LOWER(ship_state) = 'nl';

SELECT DISTINCT
    ship_state
FROM
    amazon_sale_report;

-- We will standardized 'ship_state' all capital.

UPDATE amazon_sale_report 
SET 
    ship_state = UPPER(ship_state)
WHERE
    ship_state <> 'Unknown'
        AND ship_state IS NOT NULL; 

-- Correct data types & dates
-- Incorrect values
SELECT 
    *
FROM
    amazon_sale_report
WHERE
    amount < 0 OR qty < 0;
-- No value is less then zero 

-- Data types
describe amazon_sale_report;

SELECT 
    *
FROM
    amazon_sale_report;

-- Convert the date column from VARCHAR to DATE but first set dates accoding to mysql database(Y-m-d).

SELECT DISTINCT
    `date`
FROM
    amazon_sale_report;

UPDATE amazon_sale_report 
SET 
    `date` = DATE_FORMAT(`date`, '%Y-%m-%d')
WHERE
    `date` IS NOT NULL AND date <> '';
    
alter table amazon_sale_report
modify column `date` date;

-- Convert the qty column from VARCHAR to INT.

SELECT DISTINCT
    qty
FROM
    amazon_sale_report;

alter table amazon_sale_report
modify qty int;

-- Convert the amount column from VARCHAR to DECIMAL.

SELECT DISTINCT
    amount
FROM
    amazon_sale_report;

alter table amazon_sale_report
modify amount decimal(10,2);

-- Check outliers & validation check
-- Check outliers
SELECT 
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    MIN(qty) AS min_qty,
    MAX(qty) AS max_qty
FROM
    amazon_sale_report;

-- No outlier available

-- Validation check 

-- currency & amount 
SELECT 
    distinct currency
FROM
    amazon_sale_report
WHERE
    amount IS NULL OR amount = 0;

-- The 'currency' coloumn contains 'null'

SELECT 
    distinct amount
FROM
    amazon_sale_report
WHERE
    currency IS NULL;

-- The 'amount' coloumn contains 'null' and '0' 

-- Status & qty & amount 
SELECT DISTINCT
    status
FROM
    amazon_sale_report;

-- There are 13 different status, we can separate them into three groups ok , not ok and pending. 
-- OK ('Shipped', 'Shipped - Delivered to Buyer')
-- NOT OK ('Cancelled', 'Shipped - Returned to Seller', 'Shipped - Rejected by Buyer', 'Shipped - Lost in Transit', 'Shipped - Returning to Seller', 'Shipped - Damaged')
-- PENDING ('Shipped - Out for Delivery', 'Shipped - Picked Up', 'Pending', 'Pending - Waiting for Pick Up', 'Shipping')
 
SELECT 
    status, qty, amount
FROM
    amazon_sale_report
WHERE
    qty <> 0 AND amount <> 0
        AND status IN ('Cancelled' , 'Shipped - Returned to Seller',
        'Shipped - Rejected by Buyer',
        'Shipped - Lost in Transit',
        'Shipped - Returning to Seller',
        'Shipped - Damaged'); 
        
-- NOT OK group has qty and amount so we should keep this in mind during revenue and sales analysis.

SELECT 
    status, qty, amount
FROM
    amazon_sale_report
WHERE
    qty <> 0 AND amount <> 0
        AND status IN ('Shipped - Out for Delivery' , 'Shipped - Picked Up',
        'Pending',
        'Pending - Waiting for Pick Up',
        'Shipping'); 
        
-- PENDING group also has qty and amount although they are not done yet so we should not analysis them delivered orders.
 
-- amount & qty
SELECT DISTINCT
    qty
FROM
    amazon_sale_report
WHERE
    amount IS NULL OR amount = 0;
    
-- Where amount is null or amount = 0 and qty <> 0, these orders are not done. 

-- Final validation or recheck
SELECT 
    *
FROM
    amazon_sale_report; 
 
-- Row count
SELECT 
    COUNT(*)
FROM
    amazon_sale_report;
-- Total rows = 128975

-- Duplicates 
SELECT 
    *, COUNT(*)
FROM
    amazon_sale_report
GROUP BY `index` , order_id , `date` , `status` , fulfilment , sales_channel , ship_service_level , style , sku , category , size , asin , courier_status , qty , currency , amount , ship_city , ship_state , ship_postal_code , ship_country , b2b
HAVING COUNT(*) > 1;

-- No duplicates

-- missing value 
SELECT 
    COUNT(*),
    SUM(`index` IS NULL) AS null_index,
    SUM(`order_id` IS NULL) AS null_order_id,
    SUM(`date` IS NULL) AS null_date,
    SUM(`status` IS NULL) AS null_status,
    SUM(`fulfilment` IS NULL) AS null_fulfilment,
    SUM(`sales_channel` IS NULL) AS null_sales_channel,
    SUM(`ship_service_level` IS NULL) AS null_ship_service_level,
    SUM(`style` IS NULL) AS null_style,
    SUM(`sku` IS NULL) AS null_sku,
    SUM(`category` IS NULL) AS null_category,
    SUM(`size` IS NULL) AS null_size,
    SUM(`asin` IS NULL) AS null_asin,
    SUM(`courier_status` IS NULL) AS null_courier_status,
    SUM(`amount` IS NULL) AS null_amount,
    SUM(`qty` IS NULL) AS null_qty,
    SUM(`currency` IS NULL) AS null_currency,
    SUM(`ship_city` IS NULL) AS null_ship_city,
    SUM(`ship_state` IS NULL) AS null_ship_state,
    SUM(`ship_postal_code` IS NULL) AS null_ship_postal_code,
    SUM(`ship_country` IS NULL) AS null_ship_country,
    SUM(`b2b` IS NULL) AS null_b2b
FROM
    amazon_sale_report;
    
-- There a few columns contain null values because we have changed some values.
-- 'null_currency' = 10138, because amount is null or 0 so it means transactions are not done.
-- 'null_amount' = 227, issue with transaction or data.
-- 'null_courier_status' = 6872, because nothing is clear whether the data is not updated or other issue.
-- 'null_ship_city' and  'null_ship_state' and 'null_ship_postal_code' and 'null_ship_country' all are equal, because addresses are not available.

-- Data_types
describe amazon_sale_report;

-- Invalid values
SELECT 
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    MIN(qty) AS min_qty,
    MAX(qty) AS max_qty
FROM
    amazon_sale_report;

-- Standardized values
select distinct category
from amazon_sale_report;

-- There 'kurta' is not standardized.

update amazon_sale_report
set category = 'Kurta'
where category ='kurta';

select distinct ship_state
from amazon_sale_report;

-- Data cleaning is done
