-- Data Analysis

-- How many orders were placed? 
SELECT 
    COUNT(DISTINCT order_id) AS total_order
FROM
    amazon_sale_report;
    
-- Total orders = 120378

-- What is the total revenue?
-- Gross revenue
SELECT 
    SUM(amount) AS gross_revenue
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL;
    
-- Gross revenue = 78592678.30 INR

-- Net revenue
SELECT 
    SUM(amount) AS net_revenue
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped');

-- Net revenue = 68975070.00 INR 

-- What is the average quantity per order?
SELECT 
    ROUND(SUM(qty) / COUNT(DISTINCT order_id), 2) AS avg_quantity_per_order
FROM
    amazon_sale_report
WHERE
    qty IS NOT NULL AND qty <> 0;

-- avg_quantity_per_order = 1.08 

-- What are the monthly sales trend?
SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS months,
    SUM(qty) AS monthly_quantity,
    SUM(amount) AS monthly_net_revenue
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL AND qty <> 0
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY DATE_FORMAT(`date`, '%Y-%m')
ORDER BY monthly_net_revenue DESC , monthly_quantity DESC;

-- '2022-04' (April) has highest monthly_net_revenue and monthly_quantity.

-- Which dates have the highest/lowest sales?
-- Highest sales date
SELECT 
    `date`, SUM(amount) highest_sales_date
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY `date`
ORDER BY highest_sales_date DESC
LIMIT 1;

-- 'date' = 2022-05-04, sales = 1094989.00

-- Lowest sales date
SELECT 
    `date`, SUM(amount) highest_sales_date
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY `date`
ORDER BY highest_sales_date
LIMIT 1;

-- 'date' = 2022-03-31, sales = 94183.00

-- Which dates have the highest order volume?
SELECT 
    `date`, COUNT(DISTINCT order_id) AS total_orders
FROM
    amazon_sale_report
GROUP BY `date`
ORDER BY total_orders DESC
LIMIT 3;

-- Top 3 dates along with total_orders (1. '2022-05-03' - 1941 , 2. '2022-05-02' - 1906 , 3. '2022-05-04' - 1896) [total orders, not only completed]

-- Which states generate the most revenue?
-- Top 5 revenue gererate states
SELECT 
    ship_state, SUM(amount) AS net_revenue
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL
        AND ship_state IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY ship_state
ORDER BY net_revenue desc
limit 5;

-- Top 5 states net_revenue(1. 'MAHARASHTRA', 2. 'KARNATAKA' , 3. 'TELANGANA', 4. 'UTTAR PRADESH', 5. 'TAMIL NADU')

-- Which states have the highest number of orders? 
SELECT 
    ship_state, COUNT(DISTINCT order_id) AS total_orders
FROM
    amazon_sale_report
GROUP BY ship_state
ORDER BY total_orders DESC
LIMIT 5;

-- Top 5 states total_orders(1. 'MAHARASHTRA', 2. 'KARNATAKA' , 3. 'TAMIL NADU', 4. 'TELANGANA', 5. 'UTTAR PRADESH') [total_orders, not only completed]

-- Which states have the highest cancellation rate?
SELECT 
    ship_state,
    ROUND(COUNT(DISTINCT CASE
                    WHEN `status` = 'Cancelled' THEN order_id
                END) * 100 / COUNT(DISTINCT order_id),
            2) AS cancellation_rate
FROM
    amazon_sale_report
WHERE ship_state <> 'unknown'
GROUP BY ship_state 
having count(distinct order_id) > 100
ORDER BY cancellation_rate DESC
LIMIT 5;

-- Top cancellation_rate states (1. 'HIMACHAL PRADESH' , 2. 'ANDAMAN & NICOBAR', 3. 'KERALA', 4. 'MEGHALAYA', 5. 'JAMMU & KASHMIR')

-- Which categories generate the highest revenue?
-- Top three categories 
SELECT 
    category, SUM(amount) AS net_revenue
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY category
ORDER BY net_revenue desc
limit 3;

-- Top 3 categories (1. 'Set', 2. 'Kurta', 3. 'Western Dress')

-- Which categories have the highest average selling value?
SELECT 
    category,
    ROUND(SUM(amount) / SUM(qty), 2) AS avg_selling_value
FROM
    amazon_sale_report
WHERE
    amount IS NOT NULL AND qty <> 0
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY category
ORDER BY avg_selling_value DESC;

-- Top 3 categories (1. 'Set', 2. 'Saree', 3. 'Western Dress')

-- Which category has the highest cancellation rate?
SELECT 
    category,
    ROUND(COUNT(DISTINCT CASE
                    WHEN `status` = 'Cancelled' THEN order_id
                END) * 100 / COUNT(DISTINCT order_id),
            2) AS cancellation_rate
FROM
    amazon_sale_report
GROUP BY category
ORDER BY cancellation_rate DESC
LIMIT 1;

-- Category 'Kurta' has the highest cancellation rate.

-- Which SKUs sell the most?
-- Top three categories 
SELECT 
    sku, SUM(qty) AS net_quantity
FROM
    amazon_sale_report
WHERE
    qty IS NOT NULL
        AND `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY sku
ORDER BY net_quantity DESC
LIMIT 10; 

-- Top 10 SKUs (1. 'JNE3797-KR-L', 2. 'JNE3797-KR-M', 3. 'JNE3405-KR-L', 4. 'JNE3797-KR-S', 5. 'J0230-SKD-M', 6. 'J0230-SKD-S', 7. 'JNE3405-KR-S', 8. 'JNE3797-KR-XL', 9. 'JNE3797-KR-XS', 10. 'SET268-KR-NP-XL')

-- Which sizes are most frequently ordered?
SELECT 
    size, COUNT(DISTINCT order_id) AS total_orders
FROM
    amazon_sale_report
GROUP BY size
ORDER BY total_orders DESC
LIMIT 3;

-- Top 3 sizes (1. 'M' , 2. 'L' , 3. 'XL') (It only shows ordered size, not completed orders)

-- Which product styles perform best?
SELECT 
    style, SUM(amount) AS net_amount
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
        AND amount <> 0
GROUP BY style
ORDER BY net_amount DESC
LIMIT 10;

-- Top 10 style (1. JNE3797, 2. J0230, 3. SET268, 4. J0341, 5. J0003, 6. JNE3405, 7. J0008, 8. SET345, 9. SET278, 10. SET324)

-- How many orders are shipped?
SELECT 
    COUNT(DISTINCT order_id) AS total_shipped_orders
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Delivered to Buyer' , 'Shipped',
        'Shipped - Returned to Seller',
        'Shipped - Rejected by Buyer',
        'Shipped - Lost in Transit',
        'Shipped - Out for Delivery',
        'Shipped - Returning to Seller',
        'Shipped - Picked Up',
        'Shipped - Damaged',
        'Shipping');

-- Total Shipped Orders = 102347 (It includes which orders have been shipped, not includes 'Shipping' , 'Pending'  or 'Cancelled')

-- How many orders are cancelled?
SELECT 
    COUNT(DISTINCT order_id) AS total_shipped_orders
FROM
    amazon_sale_report
WHERE
    `status` = 'Cancelled';
    
-- Total Cancelled Orders = 17185  (Only cancelled )

-- What percentage of orders are cancelled?
SELECT 
    ROUND(((SELECT 
                    COUNT(DISTINCT order_id) AS cancelled_orders
                FROM
                    amazon_sale_report
                WHERE
                    `status` = 'Cancelled') / COUNT(DISTINCT order_id)) * 100,
            2) AS cancellation_percentage
FROM
    amazon_sale_report;
    
-- 'cancellation_percentage' = 14.28

-- How many orders were returned or rejected?
SELECT 
    COUNT(DISTINCT order_id) returned_rejected_orders
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Returned to Seller' , 'Shipped - Rejected by Buyer',
        'Shipped - Returning to Seller');
        
-- 'returned_rejected_orders' = 1992

-- How many orders were lost in transit?
SELECT 
    COUNT(DISTINCT order_id) lost_transit_orders
FROM
    amazon_sale_report
WHERE
    `status` = 'Shipped - Lost in Transit';

-- 'lost_transit_orders' = 4
        
-- How many orders were damaged?
SELECT 
    COUNT(DISTINCT order_id) damaged_orders
FROM
    amazon_sale_report
WHERE
    `status` = 'Shipped - Damaged';
    
-- 'damaged_orders' = 1

-- Which fulfilment method generates more revenue?
SELECT 
    fulfilment, SUM(amount) AS net_revenue
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY fulfilment
ORDER BY net_revenue DESC;

-- Fulfilment method 'Amazon' generates highest revenue.

-- Which fulfilment method has the highest successful delivery rate?
SELECT 
    fulfilment,
    ROUND((COUNT(DISTINCT order_id) / (SELECT 
            COUNT(DISTINCT order_id)
        FROM
            amazon_sale_report)) * 100, 2) AS successful_delivery_rate
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
GROUP BY fulfilment;

-- Fulfilment method Amazon has the highest successful delivery rate.

-- Which fulfiment method has more cancellations?
SELECT 
    fulfilment, COUNT(DISTINCT order_id) AS cancelled_orders
FROM
    amazon_sale_report
WHERE
    `status` = 'Cancelled'
GROUP BY fulfilment
ORDER BY cancelled_orders DESC;

-- Fulfilment method 'Amazon' has more cancellations. 

-- How does Amazon fulfilment compare with Merchant fulfilment?
SELECT 
    fulfilment,
    COUNT(DISTINCT order_id) AS orders,
    SUM(qty) AS quantity,
    SUM(amount) AS net_revenue
FROM
    amazon_sale_report
WHERE
    `status` IN ('Shipped - Delivered to Buyer' , 'Shipped')
        AND qty <> 0
        AND amount <> 0
GROUP BY fulfilment;

-- Amazon fulfilment has performed better compare to Merchant fulfilment.


