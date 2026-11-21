create database Coffee_Shop_Sales_Analysis;

use  Coffee_Shop_Sales_Analysis;

select *from transactions;

DESCRIBE transactions;

-- Convert transaction_date from text to a proper date format (DD-MM-YYYY to DATE)
ALTER TABLE Transactions
MODIFY COLUMN Transaction_time TIME(0);

-- Change the transaction_date column type to DATE
UPDATE Transactions
SET transaction_date = DATE_FORMAT(
    STR_TO_DATE(transaction_date, '%d-%m-%Y'),
    '%Y-%m-%d'
);
ALTER TABLE Transactions
MODIFY COLUMN transaction_date DATE;

-- Total Sales
SELECT SUM(transaction_qty * unit_price) AS total_sales
FROM Transactions;

-- Month-over-Month Sales

SELECT
    MONTH(transaction_date) AS month_number,
    -- MONTHNAME(transaction_date) AS month_name,
    SUM(transaction_qty * unit_price) AS total_sales,
    LAG(SUM(transaction_qty * unit_price))
        OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)) AS previous_month_sales,
    ROUND(
        (
            SUM(transaction_qty * unit_price) -
            LAG(SUM(transaction_qty * unit_price))
                OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date))
        ) /
        NULLIF(
            LAG(SUM(transaction_qty * unit_price))
                OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)),
            0
        ) * 100, 2
    ) AS mom_growth_percentage
FROM Transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date), MONTHNAME(transaction_date)
ORDER BY YEAR(transaction_date), MONTH(transaction_date);


-- Total Orders

SELECT COUNT(DISTINCT transaction_id) AS total_orders
FROM Transactions;

-- Way to find Total Orders and Month-over-Month Growth %

SELECT
    MONTH(transaction_date) AS monthno,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(DISTINCT transaction_id) AS total_orders,
    LAG(COUNT(DISTINCT transaction_id))
        OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date))
        AS previous_month_orders,
    ROUND(
        (COUNT(DISTINCT transaction_id) -
        LAG(COUNT(DISTINCT transaction_id))
            OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)))
        * 100.0 /
        NULLIF(
            LAG(COUNT(DISTINCT transaction_id))
                OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)),
            0
        ), 2
    ) AS mom_growth_percentage
FROM Transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date),
         MONTHNAME(transaction_date)
ORDER BY YEAR(transaction_date), MONTH(transaction_date);


-- Total Quantity Sold
SELECT SUM(transaction_qty) AS total_quantity_sold
FROM Transactions;

-- Way to find Total Quantity Sold and Month-over-Month Growth %

SELECT
    MONTH(transaction_date) AS monthno,
    MONTHNAME(transaction_date) AS month_name,
    SUM(transaction_qty) AS total_quantity_sold,

    LAG(SUM(transaction_qty))
        OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date))
        AS previous_month_quantity,

    ROUND(
        (
            SUM(transaction_qty) -
            LAG(SUM(transaction_qty))
                OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date))
        ) * 100.0 /
        NULLIF(
            LAG(SUM(transaction_qty))
                OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)),
            0
        ), 2
    ) AS mom_growth_percentage

FROM Transactions
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY
    YEAR(transaction_date),
    MONTH(transaction_date);
    
 -- Total Sales, Total Quantity Sold, and Total Orders for selected date.

SELECT
    
    SUM(transaction_qty * unit_price) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM Transactions
WHERE transaction_date = '2023-06-30';

-- Average daily sales trend for the selected month.

SELECT
    DAY(transaction_date) AS day,
    DATE(transaction_date) AS transaction_date,
    SUM(transaction_qty * unit_price) AS daily_sales,
    ROUND(AVG(SUM(transaction_qty * unit_price))
        OVER (), 2) AS average_daily_sales
FROM Transactions
WHERE MONTH(transaction_date) = 5
  AND YEAR(transaction_date) = 2023
GROUP BY transaction_date
ORDER BY transaction_date;

-- Way to find Month wise Day wise Sales

SELECT
    MONTH(transaction_date) AS monthno,
    DAY(transaction_date) AS dayno,
    SUM(unit_price * transaction_qty) AS total_sales
FROM Transactions
WHERE MONTH(transaction_date) = 6
  AND YEAR(transaction_date) = 2023
GROUP BY MONTH(transaction_date), DAY(transaction_date)
ORDER BY dayno;

-- Daily sales compared to the monthly average, labelled as "Above Average" or "Below Average" for each day.2

SELECT
    DAY(transaction_date) AS dayno,
    SUM(unit_price * transaction_qty) AS total_sales,
    ROUND(AVG(SUM(unit_price * transaction_qty))
        OVER (), 2) AS monthly_avg_sales,
    CASE
        WHEN SUM(unit_price * transaction_qty) >
             AVG(SUM(unit_price * transaction_qty)) OVER ()
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS sales_status
FROM Transactions
WHERE MONTH(transaction_date) = 5
  AND YEAR(transaction_date) = 2023
GROUP BY DAY(transaction_date)
ORDER BY dayno;

-- Rounded/short-form values for cards, e.g. sales shown as "45.6K" instead of the full number.

SELECT
    SUM(transaction_qty * unit_price) AS total_sales,
    CASE
        WHEN SUM(transaction_qty * unit_price) >= 1000000
        THEN CONCAT(ROUND(SUM(transaction_qty * unit_price) / 1000000, 1), 'M')

        WHEN SUM(transaction_qty * unit_price) >= 1000
        THEN CONCAT(ROUND(SUM(transaction_qty * unit_price) / 1000, 1), 'K')

        ELSE CAST(SUM(transaction_qty * unit_price) AS CHAR)
    END AS short_form_sales
FROM Transactions;

-- Sales by Weekday / Weekend
SELECT
    CASE
        WHEN DAYOFWEEK(transaction_date) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(unit_price * transaction_qty) AS total_sales
FROM Transactions
GROUP BY day_type;

-- Sales by Day of Week

SELECT
    DAYNAME(transaction_date) AS day_name,
    SUM(unit_price * transaction_qty) AS total_sales
FROM Transactions
GROUP BY DAYOFWEEK(transaction_date), DAYNAME(transaction_date)
ORDER BY DAYOFWEEK(transaction_date);

-- Sales by Hour of Day

SELECT
    HOUR(transaction_time) AS hour,
    SUM(unit_price * transaction_qty) AS total_sales
FROM Transactions
GROUP BY HOUR(transaction_time)
ORDER BY hour;


-- Sales by Store Location

SELECT
    store_location,
    SUM(unit_price * transaction_qty) AS total_sales
FROM Transactions as ft join dim_stores as ds on ft.store_id=ds.store_id
GROUP BY store_location
ORDER BY total_sales DESC;

-- Sales by Product Category

SELECT
    dp.product_category,
    SUM(ft.unit_price * ft.transaction_qty) AS total_sales
FROM Transactions ft
INNER JOIN Dim_Products dp
    ON ft.product_id = dp.product_id
GROUP BY dp.product_category
ORDER BY total_sales DESC;

-- WAQ to find Category-wise Total Sales and Overall Sales

SELECT
    dp.product_category,
    SUM(ft.unit_price * ft.transaction_qty) AS total_sales,

    (SELECT SUM(unit_price * transaction_qty)
     FROM Transactions) AS overall_sales

FROM Transactions ft
INNER JOIN Dim_Products dp
    ON ft.product_id = dp.product_id

GROUP BY dp.product_category
ORDER BY total_sales DESC;

-- Top 10 Products by Total Sales

SELECT
    dp.product_category,
    dp.product_type,
    SUM(ft.unit_price * ft.transaction_qty) AS total_sales,
    SUM(ft.transaction_qty) AS total_quantity_sold
FROM Transactions ft
INNER JOIN Dim_Products dp
    ON ft.product_id = dp.product_id
GROUP BY
    dp.product_category,
    dp.product_type
ORDER BY total_sales DESC
LIMIT 10;

-- Sales by Day + Hour Combination

SELECT
    DAYNAME(transaction_date) AS day_name,
    HOUR(transaction_time) AS hour,
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(DISTINCT transaction_id) AS total_orders
FROM Transactions
WHERE DAYOFWEEK(transaction_date) = 4
  AND HOUR(transaction_time) = 8
GROUP BY
    DAYNAME(transaction_date),
    HOUR(transaction_time);

-- WAQ to find Category and Product Type-wise Total Sales, Total Unit Sold

SELECT
    product_category,
    product_type,
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_unit_sold
FROM Transactions as ft join dim_products as dp on ft.product_id = dp.product_id
GROUP BY product_category, product_type
ORDER BY total_sales DESC;


-- WAQ to find Store Location, Category and Product Type-wise Total Sales

SELECT
    store_location,
    product_category,
    product_type,
    SUM(unit_price * transaction_qty) AS total_sales
FROM dim_products as dp join transactions as ft on dp.product_id=ft.product_id 
join dim_stores as ds on ft.store_id =ds.store_id
GROUP BY
    store_location,
    product_category,
    product_type
ORDER BY total_sales DESC;

SELECT
    MIN(transaction_date) AS first_date,
    MAX(transaction_date) AS last_date
FROM Transactions;

