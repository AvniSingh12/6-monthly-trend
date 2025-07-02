DROP DATABASE IF EXISTS online_sales;
CREATE DATABASE online_sales CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE online_sales;

CREATE TABLE sales_data (
    ORDERNUMBER       INT            NOT NULL,
    QUANTITYORDERED   SMALLINT       NOT NULL,
    PRICEEACH         DECIMAL(10,2)  NOT NULL,
    ORDERLINENUMBER   SMALLINT       NOT NULL,
    SALES             DECIMAL(12,2)  NOT NULL,
    ORDERDATE_RAW     VARCHAR(20)    NOT NULL,
    STATUS            VARCHAR(15)    NOT NULL,
    QTR_ID            TINYINT        NOT NULL,
    MONTH_ID          TINYINT        NOT NULL,
    YEAR_ID           SMALLINT       NOT NULL,
    PRODUCTLINE       VARCHAR(50)    NOT NULL,
    MSRP              INT            NOT NULL,
    PRODUCTCODE       VARCHAR(25)    NOT NULL,
    CUSTOMERNAME      VARCHAR(100)   NOT NULL,
    PHONE             VARCHAR(25),
    ADDRESSLINE1      VARCHAR(100),
    ADDRESSLINE2      VARCHAR(100),
    CITY              VARCHAR(50),
    STATE             VARCHAR(50),
    POSTALCODE        VARCHAR(15),
    COUNTRY           VARCHAR(50),
    TERRITORY         VARCHAR(25),
    CONTACTLASTNAME   VARCHAR(50),
    CONTACTFIRSTNAME  VARCHAR(50),
    DEALSIZE          VARCHAR(10),
    order_date        DATE,
    month_start       DATE,
    PRIMARY KEY (ORDERNUMBER, ORDERLINENUMBER)
);

LOAD DATA INFILE
  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_data_sample.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ORDERNUMBER,QUANTITYORDERED,PRICEEACH,ORDERLINENUMBER,SALES,ORDERDATE_RAW,
 STATUS,QTR_ID,MONTH_ID,YEAR_ID,PRODUCTLINE,MSRP,PRODUCTCODE,CUSTOMERNAME,
 PHONE,ADDRESSLINE1,ADDRESSLINE2,CITY,STATE,POSTALCODE,COUNTRY,TERRITORY,
 CONTACTLASTNAME,CONTACTFIRSTNAME,DEALSIZE);

UPDATE sales_data
SET order_date = STR_TO_DATE(ORDERDATE_RAW,'%c/%e/%Y %H:%i:%s'),
    month_start = DATE_FORMAT(STR_TO_DATE(ORDERDATE_RAW,'%c/%e/%Y %H:%i:%s'),
                              '%Y-%m-01');

ALTER TABLE sales_data
  ADD INDEX idx_order_date  (order_date),
  ADD INDEX idx_month_start (month_start);

SELECT
  YEAR(month_start) AS yr,
  MONTHNAME(month_start) AS mon,
  ROUND(SUM(SALES), 2) AS revenue,
  COUNT(DISTINCT ORDERNUMBER) AS orders
FROM sales_data
GROUP BY month_start
ORDER BY month_start;

SELECT
  YEAR(month_start) AS yr,
  ROUND(SUM(SALES), 2) AS revenue,
  ROUND(100 * (SUM(SALES) /
        LAG(SUM(SALES)) OVER (ORDER BY YEAR(month_start)) - 1), 2) AS YoY_Growth_Pct
FROM sales_data
GROUP BY YEAR(month_start)
ORDER BY yr;
