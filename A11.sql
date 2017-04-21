----------------------------------------
---------   Assignment 10   ------------
----------------------------------------
---------
--- 1 ---
DECLARE @avg decimal
SET @avg = (SELECT AVG(ListPrice) FROM PET..Merchandise)

SELECT * FROM PET..Merchandise PM
WHERE PM.ListPrice > @avg

---------
--- 2 ---
SELECT PSI.ItemID, AVG(PSI.SalePrice) AS "Avg Sale Price", AVG(POI.Cost) AS "Avg Purchase Price"
FROM PET..SaleItem PSI 
INNER JOIN PET..OrderItem POI ON PSI.ItemID = POI.ItemID
GROUP BY PSI.ItemID 
HAVING AVG(PSI.SalePrice) > (0.5 * (AVG(POI.Cost)))
ORDER BY PSI.ItemID

---------
--- 3 ---
ALTER VIEW TotalSales
AS
SELECT SUM(SalePrice * Quantity) AS "Total Sales"
FROM PET..SaleItem

CREATE VIEW IndividualSales
AS
SELECT PS.EmployeeID, SUM(PSI.SalePrice * PSI.Quantity) AS "Individual Sales"
FROM  PET..Sale PS INNER JOIN PET..SaleItem PSI ON PS.SaleID = PSI.SaleID
GROUP BY PS.EmployeeID

--SELECT EmployeeID FROM TotalSales

---------
--- 4 ---
SELECT SupplierID, AVG(PAOI.Cost / PAO.ShippingCost) FROM PET..AnimalOrder PAO
JOIN PET..AnimalOrderItem PAOI ON PAO.OrderID = PAOI.OrderID
GROUP BY PAO.SupplierID

---------
--- 5 ---
CREATE VIEW AnimalTotal
AS
SELECT PC.CustomerID, SUM(PSA.SalePrice) AS "Total Animal"
FROM PET..Customer PC 
INNER JOIN PET..Sale PS ON PC.CustomerID = PS.CustomerID
INNER JOIN PET..SaleAnimal PSA ON PS.SaleID = PSA.SaleID
GROUP BY PC.CustomerID

CREATE VIEW MerchandiseTotal
AS
SELECT PC.CustomerID, SUM(PSI.Quantity * PSI.SalePrice) AS "Total Merchandise"
FROM PET..Customer PC 
INNER JOIN PET..Sale S ON PC.CustomerID = S.CustomerID
INNER JOIN PET..SaleItem PSI ON S.SaleID = PSI.SaleID
GROUP BY PC.CustomerID

SELECT TOP 1 PC.CustomerID, MT.[Total Merchandise] + AT.[Total Animal] AS "Grand Total"
FROM PET..Customer PC 
INNER JOIN MerchandiseTotal MT ON PC.CustomerID = MT.CustomerID
INNER JOIN AnimalTotal AT ON MT.CustomerID = AT.CustomerID
GROUP BY PC.CustomerID, MT.[Total Merchandise] + AT.[Total Animal]
ORDER BY [Grand Total] DESC

---------
--- 6 ---
ALTER VIEW MaySales
AS
SELECT PC.CustomerID, MONTH(PS.SaleDate) AS "Month", SUM(PSI.Quantity * PSI.SalePrice) AS "May Merch"
FROM PET..Customer PC 
INNER JOIN PET..Sale PS ON PC.CustomerID = PS.CustomerID
INNER JOIN PET..SaleItem PSI ON PS.SaleID = PSI.SaleID
WHERE MONTH(PS.SaleDate) = 5
GROUP BY PC.CustomerID

ALTER VIEW OctSales
AS
SELECT PC.CustomerID, MONTH(PS.SaleDate) AS "Month", SUM(PSI.Quantity * PSI.SalePrice) AS "Oct Merch"
FROM PET..Customer PC 
INNER JOIN PET..Sale PS ON PC.CustomerID = PS.CustomerID
INNER JOIN PET..SaleItem PSI ON PS.SaleID = PSI.SaleID
WHERE MONTH(PS.SaleDate) = 10
GROUP BY PC.CustomerID

SELECT PC.CustomerID, MS.[May Merch], OS.[Oct Merch]
FROM PET..CUSTOMER PC 
INNER JOIN MaySales MS ON PC.CustomerID = MS.CustomerID
INNER JOIN OctSales OS ON MS.CustomerID = OS.CustomerID
WHERE [May Merch] > 100 AND [Oct Merch] > 50

---------
--- 7 ---
DECLARE @sales decimal
SET @sales = (SELECT SUM(Quantity) FROM PET..SaleItem PSI
			JOIN PET..Sale PS ON PS.SaleID = PSI.SaleID
			WHERE PSI.ItemID = 16 AND (Month(PS.SaleDate) >= 1 AND DAY(PS.SaleDate) > 1) AND (MONTH(PS.SaleDate) < 7))

SELECT (SUM(Quantity) - @sales) AS "Net Quantity" FROM PET..OrderItem POI
JOIN PET..MerchandiseOrder PMO ON PMO.PONumber = POI.PONumber
WHERE POI.ItemID = 16 AND (Month(PMO.OrderDate) >= 1 AND DAY(PMO.OrderDate) > 1) AND (MONTH(PMO.OrderDate) < 7)

---------
--- 8 ---
SELECT PM.Description, PM.ListPrice, MONTH(PS.SaleDate) AS "Month"
FROM PET..Merchandise PM 
INNER JOIN PET..SaleItem PSI ON PM.ItemID = PSI.ItemID
INNER JOIN PET..Sale PS ON PSI.SaleID = PS.SaleID
WHERE PM.ListPrice > 50 AND PM.ItemID NOT IN (SELECT ItemID FROM PET..Sale PS
											INNER JOIN PET..SaleItem PSI ON PS.SaleID = PSI.SaleID
											WHERE MONTH(PS.SaleDate) = 7)
GROUP BY PM.ItemID, PM.Description, PM.Description, MONTH(PS.SaleDate)


---------
--- 9 ---
SELECT PM.ItemID
FROM PET..Merchandise PM
FULL OUTER JOIN PET..OrderItem POI ON PM.ItemID = POI.ItemID
FULL OUTER JOIN PET..MerchandiseOrder PMO ON POI.PONumber = PMO.PONumber
WHERE PM.QuantityOnHand > 100 AND PM.ItemID NOT IN (SELECT ItemID FROM PET..OrderItem POI 
												FULL OUTER JOIN PET..MerchandiseOrder PMO ON POI.PONumber = PMO.PONUMBER
												WHERE YEAR(PMO.OrderDate) = 2004)
GROUP BY PM.ItemID


---------
-- 10 ---
CREATE TABLE Category
(Category VARCHAR(50) NOT NULL,
Low int NOT NULL,
High int NOT NULL);
ALTER TABLE Category
	ADD PRIMARY KEY (Category);

INSERT INTO Category VALUES
('Weak', 0, 200),
('Good', 200, 800),
('Best', 800, 10000)

---------
-- 11 ---
SELECT PC.CustomerID, MT.[Total Merchandise] + AT.[Total Animal] AS "Grand Total", C.Category
FROM Category C, PET..Customer PC 
INNER JOIN MerchandiseTotal MT ON PC.CustomerID = MT.CustomerID
INNER JOIN AnimalTotal AT ON MT.CustomerID = AT.CustomerID
WHERE MT.[Total Merchandise] + AT.[Total Animal] BETWEEN C.Low AND C.High
GROUP BY PC.CustomerID, MT.[Total Merchandise] + AT.[Total Animal], C.Category

---------
-- 12 ---
SELECT SupplierID, 'Merchandise' AS "Type" FROM PET..MerchandiseOrder PMO
WHERE MONTH(PMO.OrderDate) = 6
UNION
SELECT SupplierID, 'Animal' AS "Type" FROM PET..AnimalOrder PAO
WHERE MONTH(PAO.OrderDate) = 6
