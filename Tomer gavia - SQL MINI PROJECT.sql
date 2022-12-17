
-----  Student - Tomer Gavia 
-----  Teacher - Abed Nashef
-----  Course  - DA070422ER

USE AdventureWorks;

--------1

 SELECT
	DISTINCT pp.FirstName + ' ' + pp.LastName AS 'full name'
 FROM
	HumanResources.EmployeeDepartmentHistory AS hemd
	INNER JOIN	Person.Person AS pp ON 
	hemd.BusinessEntityID = pp.BusinessEntityID
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS hemd2 ON
	hemd.BusinessEntityID = hemd2.BusinessEntityID and
	hemd.DepartmentID <> hemd2.DepartmentID
 WHERE
	hemd.EndDate is null
 ORDER BY
	'full name';


--------2

 SELECT
 DISTINCT pp.FirstName + ' ' + pp.LastName AS 'full name',
 HD.Name AS 'Department name'
 FROM
	(HumanResources.EmployeeDepartmentHistory AS hemd
	INNER JOIN Person.Person AS pp
	ON hemd.BusinessEntityID = pp.BusinessEntityID)
	INNER JOIN HumanResources.Department AS HD 
	ON hd.DepartmentID = hemd.DepartmentID
	INNER JOIN HumanResources.EmployeeDepartmentHistory AS hemd2 ON
	hemd.BusinessEntityID = hemd2.BusinessEntityID and
	hemd.DepartmentID <> hemd2.DepartmentID
 WHERE
	 hemd.EndDate is null
 ORDER BY
	'full name';

 -------3

 SELECT
	TOP 1 pp.Name,
	SUM(sso.orderqty) AS orders
 FROM
	Sales.SalesOrderDetail AS sso INNER JOIN Production.Product AS pp
	ON sso.ProductID = pp.productid
 GROUP BY
	pp.Name, pp.ProductID
 ORDER BY
	'orders' DESC ;

 
------4 

 SELECT
	TOP 1 pp.Name, SUM(sso.LineTotal) AS 'product sales'
 FROM
	Sales.SalesOrderDetail AS sso inner join Production.Product AS pp
	ON sso.ProductID = pp.productid
 GROUP BY
	pp.Name
 ORDER BY
	'product sales' DESC


-------5

SELECT
	c.*
FROM
	Sales.Customer AS c LEFT OUTER JOIN sales.SalesOrderHeader AS ssh
	ON c.CustomerID = ssh.CustomerID
WHERE
	ssh.salesordernumber IS NULL;

-------6
 SELECT
	*
 FROM
	 Production.Product AS pp LEFT OUTER JOIN
	Sales.SalesOrderDetail AS ss
	ON pp.ProductID = ss.ProductID
 WHERE
	ss.ProductID IS NULL;


-------7

SELECT
	T.* 
FROM
 (
    SELECT
	    SalesOrderID,
	    YEAR(ModifiedDate) as 'year',
	    MONTH(ModifiedDate) as 'month',
	    SUM(LINETOTAL) as sumlinetotal,
        ROW_NUMBER() OVER (PARTITION BY year(ModifiedDate), month(ModifiedDate)
        ORDER BY
	    SUM(LINETOTAL) DESC) as rownum
	    FROM
	    Sales.SalesOrderDetail
	    GROUP BY
	    SalesOrderID, year(ModifiedDate), month(ModifiedDate) 
	    ) AS T
	WHERE
		T.rownum <=3
	ORDER BY
		T.year, T.month

----OPTION 2 (TASK 7)   האם קיימת דרך כדי לא להציג את הטבלאות הריקות שמופיעות בלולאה הבאה?

    DECLARE @y INT
	  SET @y = 2005
	   WHILE @y < 2009
	    BEGIN 
           DECLARE @m INT
	         SET @m = 1
	          WHILE @m < 13 
		      BEGIN
		      SELECT
				 TOP 3 ss.SalesOrderID, ss.ModifiedDate,   
				 SUM(ss.linetotal) AS 'total line' 
              FROM
				Sales.SalesOrderDetail AS ss
		      WHERE
				MONTH(ss.ModifiedDate) = @m and YEAR(ss.modifieddate) = @y
              GROUP BY
				ss.SalesOrderID, ss.ModifiedDate 
              ORDER BY
				'total line' DESC, ss.ModifiedDate
 
			SET @m = @m + 1
			
		END

  SET @y = @y + 1
END;



------8

SELECT
	ssh.SalesPersonID,
	pp.FirstName, pp.LastName,
	COUNT(ssh.SalesOrderID) AS 'orders in month',
	MONTH(ssh.ModifiedDate) AS 'month',
	YEAR(ssh.ModifiedDate) AS 'year',
	SUM(COUNT(ssh.SalesOrderID)) OVER (PARTITION BY ssh.SalesPersonID, YEAR(ssh.ModifiedDate)) AS 'orders in year'
FROM 
	Sales.SalesOrderHeader as ssh
	inner join Person.Person as pp
	ON ssh.SalesPersonID = pp.BusinessEntityID
	inner join [Sales].[SalesOrderDetail]sod
	ON
	ssh.SalesOrderID = sod.SalesOrderID
GROUP BY 
	ssh.SalesPersonID ,
	MONTH(ssh.ModifiedDate),
	YEAR(ssh.ModifiedDate),
	pp.FirstName, pp.LastName
ORDER BY
    'orders in year' desc, 'orders in month' DESC, 'year','month';
	
-------9 

SELECT	ssh.SalesPersonID,
		pp.FirstName,
		pp.LastName,
		SUM(ssh.SubTotal)	AS 'Sales in month',
		MONTH(ssh.ModifiedDate) AS 'month',
		YEAR(ssh.ModifiedDate) AS 'year',
		SUM(SUM(ssh.SubTotal)) OVER (PARTITION BY ssh.SalesPersonID, YEAR(ssh.ModifiedDate)) AS 'sales in year'
FROM 
		Sales.SalesOrderHeader as ssh
		INNER JOIN person.Person as pp
		ON ssh.SalesPersonID = pp.BusinessEntityID
GROUP BY
		ssh.SalesPersonID, pp.FirstName, pp.LastName, ssh.ModifiedDate
ORDER BY
		ssh.SalesPersonID,YEAR(ssh.ModifiedDate), MONTH(ssh.ModifiedDate)  
	

------10
SELECT
		ssh.SalesPersonID,
		pp.FirstName,
		pp.LastName,
		SUM(ssh.SubTotal) AS 'Sales in month',
	    ssh.ModifiedDate,
		LAG(SUM(ssh.SubTotal),1,0)  OVER (PARTITION BY ssh.SalesPersonID  ORDER BY year(ssh.ModifiedDate), month(ssh.ModifiedDate)) AS 'sales last month',
		SUM(SUM(ssh.SubTotal)) OVER (PARTITION BY ssh.SalesPersonID, YEAR(ssh.ModifiedDate)) AS 'sales in year'
		
FROM 
		Sales.SalesOrderHeader as ssh
		INNER JOIN person.Person as pp
		ON ssh.SalesPersonID = pp.BusinessEntityID
GROUP BY
		ssh.SalesPersonID, pp.FirstName, pp.LastName, ssh.ModifiedDate
ORDER BY
		ssh.SalesPersonID,YEAR(ssh.ModifiedDate), MONTH(ssh.ModifiedDate);

-------11
	DROP PROCEDURE SALES_LAG1M;
	 CREATE PROCEDURE SALES_LAG1M @SalespersonID INT = NULL
		AS
			IF @SalespersonID NOT IN( 
				SELECT
				SalesPersonID
				FROM 
				(
				SELECT
					SalesPersonID,FirstName, LastName,
					SUM(subtotal) AS 'sales in month',
					MONTH(orderdate) AS M,
					YEAR(orderdate)AS Y,
					SUM(SUM(SubTotal)) OVER (PARTITION BY SalesPersonID, YEAR(orderdate)) AS 'sales in year'
				FROM Person.Person
					INNER JOIN Sales.SalesOrderHeader
					ON BusinessEntityID = SalesPersonID
				GROUP BY
					FirstName, LastName,SalesPersonID, MONTH(orderdate),YEAR(orderdate)
					) AS O)
					PRINT 'TASK 11 EX C - ID IS NOT CORRECT, TRY AGAIN.'
			ELSE
			SELECT
				SalesPersonID,
				FirstName,
				LastName,
				[sales in month],
				M,Y,
				LAG([sales in month],1,0) OVER (PARTITION BY SalesPersonID,  Y ORDER BY  Y,M) AS 'Last month sales',
				[sales in year]
				
			FROM 
				(
				SELECT
				SalesPersonID,FirstName, LastName,
				SUM(subtotal) AS 'sales in month',
				MONTH(orderdate) AS M,
				YEAR(orderdate)AS Y,
				SUM(SUM(SubTotal)) OVER (PARTITION BY SalesPersonID, YEAR(orderdate)) AS 'sales in year'
			FROM Person.Person
				INNER JOIN Sales.SalesOrderHeader
				ON BusinessEntityID = SalesPersonID
			GROUP BY
				FirstName, LastName,SalesPersonID, MONTH(orderdate),YEAR(orderdate)
		) AS O
	WHERE
		SalespersonID = ISNULL(@SalespersonID,SalespersonID)
 
	ORDER BY FirstName;

---- TEST 11

	EXEC SALES_LAG1M 282;
	EXEC SALES_LAG1M;
	EXEC SALES_LAG1M 3; 



