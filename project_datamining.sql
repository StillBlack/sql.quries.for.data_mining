-- create schema retailshop;

use retailshop;


-- Q_NO #1) Define meta data in mysql workbench or any other SQL tool?
select * from online_retail;


-- Q-NO #2) What is the distribution of order values across all customers in the datase?
SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM 
    online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID
ORDER BY 
    TotalOrderValue DESC;
    
    
    -- Q-NO #3) How many unique products has each customer purchased?
SELECT 
    CustomerID,
    COUNT(DISTINCT StockCode) AS UniqueProductsPurchased
FROM 
    online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID
ORDER BY 
    UniqueProductsPurchased DESC;
    
    
-- Q-NO #4) Which customers have only made a single purchase from the company?
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS NumberOfPurchases
FROM 
    online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID
HAVING 
    COUNT(DISTINCT InvoiceNo) = 1
ORDER BY 
    CustomerID;
    
    
-- Q-NO #5) Which products are most commonly purchased together by customers in the dataset?
SELECT 
    p1.StockCode AS Product1,
    p2.StockCode AS Product2,
    COUNT(*) AS Frequency
FROM 
   online_retail p1
JOIN 
    online_retail p2
ON 
    p1.InvoiceNo = p2.InvoiceNo  -- Same invoice
    AND p1.StockCode < p2.StockCode  -- Ensure distinct pairs and avoid duplicates
WHERE 
    p1.CustomerID IS NOT NULL
GROUP BY 
    p1.StockCode, p2.StockCode
ORDER BY 
    Frequency DESC
LIMIT 10;
-- To get the top 10 most frequent pairs


-- Q-NO #1) Customer Segmentation by Purchase Frequency
-- Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers.
-- This can help you identify your most loyal customers and those who need more attention.?
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency
FROM 
    online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID
ORDER BY 
    PurchaseFrequency DESC;


-- Q-NO #2). Average Order Value by Country
-- Calculate the average order value for each country to identify where your most valuable customers are located?
SELECT 
    Country,
    AVG(InvoiceTotal) AS AverageOrderValue
FROM 
    (SELECT 
         InvoiceNo,
         Country,
         SUM(Quantity * UnitPrice) AS InvoiceTotal
     FROM 
        online_retail
     WHERE 
         CustomerID IS NOT NULL
     GROUP BY 
         InvoiceNo, Country
    ) AS invoice_totals
GROUP BY 
    Country
ORDER BY 
    AverageOrderValue DESC;


-- Q-NO #3). Customer Churn Analysis
-- Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
SELECT 
    CustomerID,
    MAX(InvoiceDate) AS LastPurchaseDate
FROM 
    online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    CustomerID
HAVING 
    MAX(InvoiceDate) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY 
    LastPurchaseDate ASC;



-- Q-NO #4). Product Affinity Analysis
-- Determine which products are often purchased together by calculating the correlation between product purchases.
SELECT 
    p1.StockCode AS Product1,
    p2.StockCode AS Product2,
    COUNT(*) AS Frequency
FROM 
    online_retail p1
JOIN 
   online_retail p2
ON 
    p1.InvoiceNo = p2.InvoiceNo  -- Same invoice
    AND p1.StockCode < p2.StockCode  -- To avoid duplicate pairs (A-B vs B-A)
WHERE 
    p1.CustomerID IS NOT NULL
GROUP BY 
    p1.StockCode, p2.StockCode
ORDER BY 
    Frequency DESC;
    
    
-- Q-NO #5). Time-based Analysis
-- Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
SELECT 
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(Quantity * UnitPrice) AS TotalSales
FROM 
  online_retail
WHERE 
    CustomerID IS NOT NULL
GROUP BY 
    YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY 
    Year, Month;


















