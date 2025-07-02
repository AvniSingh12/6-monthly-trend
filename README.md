# 6-monthly-trend

Objective
Compare month-wise revenue and order volume from sales data with SQL.

Dataset
Database: online_sales

Table: 
sales_data

Key columns:
order_date (parsed from raw CSV string)
SALES (amount per order line)
ORDERNUMBER (order ID)

Tools Used:
MySQL 8.0
MySQL Workbench

Steps Performed:
Setup the online_sales database and sales_data table with suitable data types.
Imported the sales CSV into sales_data with LOAD DATA INFILE.
Parsed the raw date string to MySQL DATE type and computed the first day of every order's month for grouping.
Added date field indexes to improve query performance.
Created an SQL aggregating query to calculate:
Monthly total revenue (SUM(SALES))
Distinct orders per month (COUNT(DISTINCT ORDERNUMBER))
Sorted results by chronological order (ORDER BY month_start).

Sample Query Used:

SELECT
  YEAR(month_start) AS yr,
  MONTHNAME(month_start) AS mon,
  ROUND(SUM(SALES), 2) AS revenue,
  COUNT(DISTINCT ORDERNUMBER) AS orders
FROM sales_data
GROUP BY month_start
ORDER BY month_start;

Result Summary:
The query produces monthly order counts and sales revenue.
Allows for trending of sales over a period.
Can be filtered to include a date range.

Notes:
The CSV file was initially in Latin1 encoding and was converted to UTF-8 to allow for easy import.
The date parsing includes date and time in the raw data column.
