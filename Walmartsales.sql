-- Create the database
CREATE DATABASE WalmartSalesDB;

-- Use the created database
USE WalmartSalesDB;

-- Create the table
CREATE TABLE WalmartSales (
    InvoiceID VARCHAR(20),
    Branch CHAR(1),
    City VARCHAR(50),
    CustomerType VARCHAR(10),
    Gender VARCHAR(10),
    ProductLine VARCHAR(50),
    UnitPrice DECIMAL(10, 2),
    Quantity INT,
    Tax5 DECIMAL(10, 2),
    Total DECIMAL(10, 2),
    Date DATE,
    Time TIME,
    Payment VARCHAR(20),
    COGS DECIMAL(10, 2),
    GrossMarginPercentage DECIMAL(5, 2),
    GrossIncome DECIMAL(10, 2),
    Rating DECIMAL(3, 1)
);
LOAD DATA LOCAL INFILE 'C:\Users\Victory\Documents/WalmartSalesData.csv'
INTO TABLE WalmartSales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    InvoiceID, Branch, City, CustomerType, Gender, ProductLine, UnitPrice, Quantity, 
    Tax5, Total, Date, Time, Payment, COGS, GrossMarginPercentage, GrossIncome, Rating
);

SELECT *
FROM WalmartSales
WHERE InvoiceID IS NULL
   OR Branch IS NULL
   OR City IS NULL
   OR CustomerType IS NULL
   OR Gender IS NULL
   OR ProductLine IS NULL
   OR UnitPrice IS NULL
   OR Quantity IS NULL
   OR Tax5 IS NULL
   OR Total IS NULL
   OR Date IS NULL
   OR Time IS NULL
   OR Payment IS NULL
   OR COGS IS NULL
   OR GrossMarginPercentage IS NULL
   OR GrossIncome IS NULL
   OR Rating IS NULL;

ALTER TABLE WalmartSales ADD COLUMN time_of_day VARCHAR(10);

UPDATE WalmartSales
SET time_of_day = 
    CASE
        WHEN TIME(Time) BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN TIME(Time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN TIME(Time) BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END;
    
    SELECT time_of_day, COUNT(*) AS sales_count
FROM WalmartSales
GROUP BY time_of_day
ORDER BY sales_count DESC;

ALTER TABLE WalmartSales ADD COLUMN day_name VARCHAR(10);

UPDATE WalmartSales
SET day_name = DAYNAME(Date);

SELECT Branch, day_name, COUNT(*) AS sales_count
FROM WalmartSales
GROUP BY Branch, day_name
ORDER BY Branch, sales_count DESC;

ALTER TABLE WalmartSales ADD COLUMN month_name VARCHAR(10);

UPDATE WalmartSales
SET month_name = MONTHNAME(Date);

SELECT month_name, SUM(Total) AS total_sales
FROM WalmartSales
GROUP BY month_name
ORDER BY total_sales DESC;


SELECT month_name, SUM(gross_income) AS total_profit
FROM WalmartSales
GROUP BY month_name
ORDER BY total_profit DESC;

SELECT month_name, 
       SUM(Total) AS total_sales, 
       SUM(gross_income) AS total_profit
FROM WalmartSales
GROUP BY month_name
ORDER BY total_sales DESC, total_profit DESC;


SELECT 
    MIN(Total) AS min_sales, 
    MAX(Total) AS max_sales, 
    AVG(Total) AS avg_sales, 
    SUM(Total) AS total_sales, 
    COUNT(*) AS total_transactions
FROM WalmartSales;


SELECT Branch, SUM(Total) AS total_sales
FROM WalmartSales
GROUP BY Branch
ORDER BY total_sales DESC;


SELECT time_of_day, SUM(Total) AS total_sales
FROM WalmartSales
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT CustomerType, 
       SUM(Total) AS total_sales, 
       COUNT(*) AS transaction_count
FROM WalmartSales
GROUP BY CustomerType
ORDER BY total_sales DESC;
SELECT Payment, COUNT(*) AS transaction_count
FROM WalmartSales
GROUP BY Payment
ORDER BY transaction_count DESC;

SELECT month_name, 
       SUM(Total) AS total_sales, 
       SUM(GrossIncome) AS total_profit
FROM WalmartSales
GROUP BY month_name
ORDER BY total_sales DESC, total_profit DESC;


SELECT COUNT(DISTINCT City) AS unique_cities
FROM WalmartSales;









