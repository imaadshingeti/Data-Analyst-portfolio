USE adventure_works;
-- Union of sheets factinternetsales10_12 and factinternetsales13_14----------------------------------------------
CREATE TABLE internetsales AS
SELECT * FROM factinternetsales10_12
UNION
SELECT * FROM factinternetsales13_14;

SELECT * FROM internetsales;
SELECT COUNT(*) FROM internetsales;
-- ------------------------------------------------------------------------------------------------------------------
-- 1.Lookup the productname from the Product sheet to Sales sheet.
CREATE VIEW sales_view AS
SELECT s.*, p.EnglishProductName  AS ProductName
FROM internetsales s
JOIN dimproduct p ON s.ProductKey = p.ProductKey; 

SELECT * FROM sales_view;

-- ------------------------------------------------------------------------------------------------------------------

-- .Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet.

ALTER TABLE dimcustomer						 -- Adding  Column 
ADD CustomerFullName VARCHAR(255);

UPDATE dimcustomer							-- Updating Values in new column
SET CustomerFullName = 
    CASE 
        WHEN MiddleName IS NOT NULL THEN CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
        ELSE CONCAT(FirstName, ' ', LastName)
    END;
    SELECT * FROM dimcustomer;

CREATE VIEW sales1 AS
SELECT s.*, p.Unit_Price,c.CustomerFullName
FROM internetsales s
JOIN dimproduct p ON s.ProductKey = p.ProductKey
JOIN  dimcustomer c ON s.CustomerKey = C.CustomerKey;

SELECT * FROM sales1;

-- ------------------------------------------------------------------------------------------------------------------
-- Cacuating Date Field from Orderdatekey

ALTER TABLE internetsales ADD Order_Date Date;
Update internetsales SET Order_Date=CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE) ;

SELECT * FROM internetsales;


CREATE VIEW Date_View As
SELECT 
    OrderDateKey,
    CAST(CAST(OrderDateKey AS CHAR(8)) AS DATE) AS Order_Date
from internetsales;
select * from Date_View;
-- ----------------------------------------------------------------------------------------------------------------
-- Calcuating year

CREATE VIEW Year_View As
SELECT 
Order_Date,YEAR(Order_Date) AS YEAR
FROM internetsales;
select * FROM  Year_View;

-- -------------------------------------------------------------------------------------------------------------
--  Cacuating Monthumber

CREATE  VIEW monthno_view AS
SELECT 
Order_Date,MONTH(Order_Date) AS MonthNumber
FROM internetsales;
SELECT *  FROM monthno_view;

-- ------------------------------------------------------------------------------------------------------------
-- Caculating  Month Name

CREATE  VIEW monthname_view AS
SELECT 
Order_Date, MONTHNAME(Order_Date)
FROM internetsales;
SELECT *  FROM monthno_view;
-- -------------------------------------------------------------------------------------------------------------
-- Cacuating Quarter

CREATE  VIEW quarter_view AS
SELECT
Order_Date, concat("Q",QUARTER(Order_Date)) AS Quarter
FROM internetsales;
SELECT *  FROM quarter_view;
-- --------------------------------------------------------------------------------------------------------------
--  Calculating date in format YYYY-MM

CREATE  VIEW yyyy_mm AS
SELECT 
Order_Date,DATE_FORMAT(Order_Date, '%Y-%m') AS 'YYYY-MM'
FROM internetsales;
SELECT *  FROM yyyy_mm;
-- ----------------------------------------------------------------------------------------------------------
--  Calculating WeekayNo

CREATE VIEW weekdayNo AS
SELECT 
Order_Date,
weekday(Order_Date) + 1 AS DayNumber        -- Sunday is 1 and saturday 7
FROM internetsales;
SELECT * FROM weekdayNo;
-- ---------------------------------------------------------------------------------------------------------
--  Cacuating DayName

CREATE VIEW day_view AS
SELECT 
Order_Date,dayname(Order_Date)  As Day
FROM internetsales;
SELECT  * FROM day_view;
-- ----------------------------------------------------------------------------------------------------------
select * from dimdate;
-- calcuating financial month

SELECT Order_Date,
    CASE
        WHEN MONTH(Order_Date) < 7 THEN MONTH(Order_Date) +6               -- Financial month statrts from July
        ELSE MONTH(Order_Date) - 6
    END AS FinancialMonth
FROM internetsales;

-- ----------------------------------------------------------------------------------------------------------
-- Calcuating financial quarter

SELECT Order_Date,                                        						-- first quarter starts from july
    CASE
        WHEN MONTH(Order_Date) >= 4 AND MONTH(Order_Date) <= 6 THEN 4
        WHEN MONTH(Order_Date) >= 7 AND MONTH(Order_Date) <= 9 THEN 1
        WHEN MONTH(Order_Date) >= 10 AND MONTH(Order_Date) <= 12 THEN 2
        WHEN MONTH(Order_Date) >= 1 AND MONTH(Order_Date) <= 3 THEN 3
    END AS FinancialQuarter
FROM internetsales;

-- -------------------------------------------------------------------------------------------------------------
-- Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)alter

ALTER TABLE internetsales ADD Sales_Amount DECIMAL;
UPDATE internetsales 
SET Sales_Amount = UnitPrice * OrderQuantity - DiscountAmount;
SELECT * FROM internetsales;
---------------------------------------------------------------------------------------------------------    
-- Calculate the Productioncost uning the columns(unit cost ,order quantity)

ALTER TABLE internetsales ADD Productioncost DECIMAL;
UPDATE internetsales 
SET Productioncost = ProductStandardCost * OrderQuantity;
SELECT * FROM internetsales;
-- ------------------------------------------------------------------------------------------------------------
-- Calculate the profit.
ALTER TABLE internetsales ADD Profit DECIMAL;
UPDATE internetsales 
 SET Profit = SalesAmount - Productioncost ;
SELECT * FROM internetsales;
-- -------------------------------------------------------------------------------------------------------------
-- Month  Wise Sales

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT 
    MONTHNAME(Order_Date) AS Month,
    SUM(Sales_Amount) AS TotalSales
FROM 
internetsales
    GROUP BY monthname(Order_Date)
    ORDER BY 
    FIELD(MONTH(Order_Date), 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);

-- ----------------------------------------------------------------------------------------------------
-- Year Wise Sales----------------------------------------------------------------------------------
SELECT
	YEAR(Order_Date) AS Year,
	SUM(Sales_Amount) AS TotalSales
FROM internetsales
 
GROUP BY  YEAR(Order_Date)
ORDER BY  YEAR(Order_Date);
-- -----------------------------------------------------------------------------------------------------
--   Sales Vs ProductionCost
SELECT
YEAR(Order_Date) AS Year,
SUM(Sales_Amount) AS TotalSales,
Sum(ProductionCost) AS TotalProductionCost
FROM internetsales
 
GROUP BY  YEAR(Order_Date)
ORDER BY  YEAR(Order_Date);
-- ----------------------------------------------------------------------------------------------------------------
--  Quarterwise sales---------------------------------------------------------------------------------------------

SELECT
	Concat('Q',QUARTER(Order_Date)) AS Quarter,
	SUM(Sales_Amount) AS TotalSales
FROM internetsales
 
GROUP BY  Quarter(Order_Date)
ORDER BY  Quarter(Order_Date);
-- -----------------------------------------------------------------------------------------------------------------
--  Top 5 proucts  Sales wise-------
SELECT
    s.ProductKey,p.EnglishProductName AS ProductName,
    SUM(Sales_Amount) AS TotalSales
FROM internetsales s
Join dimproduct p 
on s.ProductKey=p.Productkey

GROUP BY
    ProductKey
ORDER BY
    TotalSales DESC
LIMIT 5;
-- -----------------------------------------------------------------------------------------------------------------
-- Region Wise Profit-------------------------------------------------------------------------------------

SELECT r.SalesTerritoryRegion AS Region,
sum(s.profit) As TotalProfit
FROM internetsales s
JOIN dimsalesterritory r
ON  s.SalesTerritoryKey =  r.SalesTerritoryKey
GROUP BY SalesTerritoryRegion
Order By TotalProfit DESC;







    
    





