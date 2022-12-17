   
   CREATE DATABASE SALES_DWH
    GO
    
    USE SALES_DWH
    GO


    CREATE TABLE Dim_Customer
	(
	CustomerSK int identity (100 ,1) PRIMARY KEY,
	CustomerID int NOT NULL,
	CustomerName [nvarchar](150) NOT NULL,
	LocationSK [nvarchar](150) NULL,
	PriceListID int
	)


    CREATE TABLE Dim_Product 
	(
	PartSK int identity (100 , 1) PRIMARY KEY ,
	PartID  nvarchar(50),
	PartName  nvarchar(50) ,
	BrandDes nvarchar(50),
	Category nvarchar(50),
	SubCategory nvarchar(50),
	ProductCost Decimal(14,2),
	UnitsInCarton int
	)

	CREATE TABLE Dim_Location
	(
	LocationSK int identity (100 , 1) PRIMARY KEY,
	LocationID nvarchar(50),
	CityName nvarchar(50),
	Latitude nvarchar(50),
	Longitude nvarchar(50),
	Coordinate nvarchar(50),
	RegionName nvarchar(50),
	)

	CREATE TABLE Fact_sales
	(
	SalesSK int identity (100 , 1),
	SaleID nvarchar(50),
	[Date] date,
	PartSK nvarchar(50),
	CustomerSK nvarchar(50),
	Quantity_Carton nvarchar(50),
	PriceListSK int ,
	ProductPrice Decimal(14,2),
	ProductCost Decimal(14,2),
	UnitsInCarton int
	)
	GO

	---	CREATE PROCEDURE Replace_partname

		CREATE PROCEDURE Replace_partname 
		as 
		UPDATE Dim_Product 
        SET PartName = replace(replace(replace(replace(partname, '(', ''), ')', ''), '*', ''), '"', '')

		GO


	---	CREATE PROCEDURE Cat_Type

		CREATE PROCEDURE Cat_Type @PartID INT = NULL
	        
	            AS 
		          IF @PartID NOT IN (SELECT DISTINCT PartID FROM Fact_sales fs
			  		                INNER JOIN Dim_Product dp
			  					    ON fs.PartSK = dp.PartSK)
		                     PRINT 'PART ID IS NOT EXIST, TRY DIFFRENT'
		       ELSE
			     SELECT * FROM 
				 (
		          SELECT T.Category, T.PartID, 
		          COUNT(T.PartID)  OVER (PARTITION BY CATEGORY) PROD_IN_CAT ,
		          SUM(T.ProductCost) OVER (PARTITION BY CATEGORY) TOTALCOST_CAT,
				  		CASE
		           WHEN COUNT(T.PartID) OVER (PARTITION BY CATEGORY) > 100 and SUM(ProductCost) OVER (PARTITION BY CATEGORY) >1000  THEN 'Strong Cat'
			        WHEN COUNT(T.PartID) OVER (PARTITION BY CATEGORY) >= 40 and SUM(ProductCost) OVER (PARTITION BY CATEGORY) between 480 and 1000 THEN 'Medium Cat' 
			         WHEN COUNT(T.PartID) OVER (PARTITION BY CATEGORY) < 40 or category = 'UK' THEN 'Weak Cat' END AS 'Category type'
				  FROM
				   (SELECT 
				    Category, dp.PartID AS PartID , fs.ProductCost AS ProductCost
				      FROM Fact_sales fs
					  INNER JOIN Dim_Product dp
					  ON fs.PartSK = dp.PartSK
	  			      GROUP BY Category, dp.PartID, fs.ProductCost)
				      as T
			         GROUP BY Category, PartID , ProductCost ) AS AB
				     WHERE PartID = isnull(@PartID, PartID)
					 
					 GO

	
	   

	----TEST	 exec Cat_Type 13333
	----TEST	 exec Cat_Type 12155
	----TEST	 exec Cat_Type 
	----TEST	 exec Cat_Type 10722
	----TEST	 exec Cat_Type 160