--------------------------
-- Table Creation --------
--------------------------

CREATE TABLE DETAILRENTALA
(Rent_Num int NOT NULL,
Vid_Num int,
Detail_Fee decimal(5,2),
Detail_DueDate datetime,
Detail_ReturnDate datetime,
Detail_DailyLateFee decimal(5,2));

CREATE TABLE MEMBERSHIPA
(Mem_Num int NOT NULL,
Mem_FName nvarchar(50),
Mem_LName nvarchar(50),
Mem_Street nvarchar(250),
Mem_City nvarchar(50),
Mem_State nvarchar(2),
Mem_Zip nvarchar(5),
Mem_Balance decimal(5,2));

CREATE TABLE MOVIEA
(Movie_Num int NOT NULL,
Movie_Title nvarchar(255),
Movie_Year smallint,
Movie_Cost decimal(5,2),
Movie_Genre nvarchar(12),
Price_Code smallint);

CREATE TABLE PRICEA
(Price_Code smallint NOT NULL,
Price_Description nvarchar(50),
Price_RentFee decimal(5,2),
Price_DailyLateFee decimal(5,2));

CREATE TABLE RENTALA
(Rent_Num int NOT NULL,
Rent_Date datetime,
Mem_Num int);

CREATE TABLE VIDEOA
(Vid_Num int NOT NULL,
Vid_InDate datetime,
Movie_Num int);

--------------------
-- Table Alteration 
--------------------
ALTER TABLE DETAILRENTALA
ADD PRIMARY KEY (Rent_Num)

ALTER TABLE MEMBERSHIPA
ADD PRIMARY KEY (Mem_Num)

ALTER TABLE MOVIEA
ADD PRIMARY KEY (Movie_Num)

ALTER TABLE PRICEA
ADD PRIMARY KEY (Price_Code)

ALTER TABLE RENTALA
ADD PRIMARY KEY (Rent_Num)

ALTER TABLE VIDEOA
ADD PRIMARY KEY (Vid_Num)

ALTER TABLE DETAILRENTALA
ADD FOREIGN KEY (Rent_Num)
REFERENCES RENTALA (Rent_Num)

ALTER TABLE MOVIEA
ADD FOREIGN KEY (Price_Code)
REFERENCES PRICEA (Price_Code)

ALTER TABLE RENTALA
ADD FOREIGN KEY (Mem_Num)
REFERENCES MEMBERSHIPA (Mem_Num)

ALTER TABLE VIDEOA
ADD FOREIGN KEY (Movie_Num)
REFERENCES MOVIEA (Movie_Num)