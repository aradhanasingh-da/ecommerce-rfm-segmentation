CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10, 2),
    CustomerID NUMERIC(10, 0),
    Country VARCHAR(50)
);
SELECT * FROM online_retail LIMIT 10;


CREATE TABLE customer_summary AS
SELECT 
    CustomerID,
    -- Recency: Days between customer's last order and the snapshot date '2011-12-10'
    ('2011-12-10'::DATE - MAX(InvoiceDate)::DATE) AS RecencyDays,
    
    -- Frequency: Total distinct orders placed
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    
    -- Monetary: Total money spent
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalSpent

FROM online_retail
WHERE CustomerID IS NOT NULL 
  AND InvoiceNo NOT LIKE 'C%' 
  AND Quantity > 0
  AND UnitPrice > 0
GROUP BY CustomerID;


SELECT COUNT(*) FROM online_retail;



-- 1. Drop the table if it was created earlier
DROP TABLE IF EXISTS customer_summary;

-- 2. Create the customer summary table with RFM metrics
CREATE TABLE customer_summary AS
SELECT 
    CustomerID,
    ('2011-12-10'::DATE - MAX(InvoiceDate)::DATE) AS RecencyDays,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalSpent
FROM online_retail
WHERE CustomerID IS NOT NULL 
  AND InvoiceNo NOT LIKE 'C%' 
  AND Quantity > 0
  AND UnitPrice > 0
GROUP BY CustomerID;

-- 3. Run segmentation on the generated summary table
SELECT 
    CustomerID,
    RecencyDays,
    TotalOrders,
    TotalSpent,
    CASE 
        WHEN RecencyDays <= 30 AND TotalOrders >= 5 THEN 'Champions'
        WHEN TotalOrders >= 3 AND RecencyDays <= 90 THEN 'Loyal Customers'
        WHEN RecencyDays <= 30 AND TotalOrders < 3 THEN 'New / Recent Customers'
        WHEN RecencyDays BETWEEN 91 AND 180 THEN 'At Risk Customers'
        ELSE 'Lost / Inactive'
    END AS CustomerSegment
FROM customer_summary
ORDER BY TotalSpent DESC;




SELECT 
    CASE 
        WHEN RecencyDays <= 30 AND TotalOrders >= 5 THEN 'Champions'
        WHEN TotalOrders >= 3 AND RecencyDays <= 90 THEN 'Loyal Customers'
        WHEN RecencyDays <= 30 AND TotalOrders < 3 THEN 'New / Recent Customers'
        WHEN RecencyDays BETWEEN 91 AND 180 THEN 'At Risk Customers'
        ELSE 'Lost / Inactive'
    END AS CustomerSegment,
    COUNT(*) AS CustomerCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_summary), 2) AS PercentageOfTotal
FROM customer_summary
GROUP BY 1
ORDER BY CustomerCount DESC;



SELECT 
    CASE 
        WHEN RecencyDays <= 30 AND TotalOrders >= 5 THEN 'Champions'
        WHEN TotalOrders >= 3 AND RecencyDays <= 90 THEN 'Loyal Customers'
        WHEN RecencyDays <= 30 AND TotalOrders < 3 THEN 'New / Recent Customers'
        WHEN RecencyDays BETWEEN 91 AND 180 THEN 'At Risk Customers'
        ELSE 'Lost / Inactive'
    END AS CustomerSegment,
    ROUND(SUM(TotalSpent), 2) AS TotalRevenue,
    ROUND(AVG(TotalSpent), 2) AS AvgSpendPerCustomer
FROM customer_summary
GROUP BY 1
ORDER BY TotalRevenue DESC;


SELECT 
    CustomerID,
    RecencyDays,
    TotalOrders,
    TotalSpent,
    CASE 
        WHEN RecencyDays <= 30 AND TotalOrders >= 5 THEN 'Champions'
        WHEN TotalOrders >= 3 AND RecencyDays <= 90 THEN 'Loyal Customers'
        WHEN RecencyDays <= 30 AND TotalOrders < 3 THEN 'New / Recent Customers'
        WHEN RecencyDays BETWEEN 91 AND 180 THEN 'At Risk Customers'
        ELSE 'Lost / Inactive'
    END AS CustomerSegment
FROM customer_summary;


