create database amazonproductssales;

CREATE TABLE amazon_sale_report (
    `index` INT,
    Order_id VARCHAR(100),
    `date` VARCHAR(100),
    `Status` VARCHAR(100),
    Fulfilment VARCHAR(100),
    Sales_Channel VARCHAR(100),
    ship_service_level VARCHAR(100),
    Style VARCHAR(100),
    SKU VARCHAR(100),
    Category VARCHAR(100),
    Size VARCHAR(100),
    ASIN VARCHAR(100),
    Courier_Status VARCHAR(100),
    Qty VARCHAR(100),
    currency VARCHAR(100),
    Amount VARCHAR(100),
    Ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    Ship_postal_code VARCHAR(100),
    Ship_country VARCHAR(100),
    promotion_ids VARCHAR(1000),
    B2B VARCHAR(100),
    fulfilled_by VARCHAR(100),
    Unnamed_22 VARCHAR(100)
);

load data local infile 'C:/Users/admin/Desktop/amazon sales report project/Amazon Sale Report.csv'
into table amazon_sale_report
fields terminated by ','
enclosed by '"'
lines terminated by '\n' 
ignore 1 rows;
