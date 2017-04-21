
------------------------
--  1. Creates Table ---
------------------------
CREATE TABLE NONGAME
(
ITEM_NUM CHAR(4),
DESCRIPTION CHAR(30),
ON_HAND decimal(4,0),
CATEGORY CHAR(3),
PRICE DECIMAL(6,2)
);

-- Makes PK
ALTER TABLE NONGAME
ADD PRIMARY KEY (ITEM_NUM)

------------------------
-- 2. Adds Specific Rows
------------------------
INSERT INTO NONGAME
SELECT ITEM_NUM, DESCRIPTION, ON_HAND, CATEGORY, PRICE
FROM ITEM 
WHERE ITEM.CATEGORY <> 'GME'

------------------------
-- 3. Update Table -----
------------------------
UPDATE NONGAME
SET DESCRIPTION = 'Classic Train Set'
WHERE ITEM_NUM = 'DL51'

------------------------
-- 4. Update Table -----
------------------------
UPDATE NONGAME
SET PRICE = PRICE * 1.02
WHERE CATEGORY = 'TOY'

------------------------
-- 5. Insert Into Table
------------------------
INSERT INTO NONGAME
VALUES ('TL92', 'Dump Truck', 10, 'TOY', 59.95)

------------------------
-- 6. Delete Table Entry
------------------------
DELETE FROM NONGAME
WHERE CATEGORY = 'PZL'

------------------------
-- 7. Update Table
------------------------
UPDATE NONGAME
SET CATEGORY = NULL
WHERE ITEM_NUM = 'FD11'

------------------------
-- 8. Alter Table
------------------------
ALTER TABLE NONGAME
ADD ON_HAND_VALUE DECIMAL(7,2)

UPDATE NONGAME
SET ON_HAND_VALUE = ON_HAND * PRICE

------------------------
-- 9. Alter Table
------------------------
ALTER TABLE NONGAME
ALTER COLUMN DESCRIPTION CHAR(40)

------------------------
-- 10. Delete Table
------------------------
BEGIN TRAN
DROP TABLE NONGAME
--Rollback
--COMMIT