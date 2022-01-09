/*

Challenge: https://docs.google.com/document/d/13VCtoyto9X1PZ74nPI4ZEDdb8hF8LAlcmLH1ZTHxKxE/edit#
SQL Dataset: https://www.w3schools.com/SQL/TRYSQL.ASP?FILENAME=TRYSQL_SELECT_ALL

*/

-- Question 2:


-- 2a. How many orders were shipped by Speedy Express in total?

-- 2a.1 Using nested SELECT
SELECT
	COUNT(*) AS TotalOrders
FROM
	Orders
WHERE
	ShipperID = (
		SELECT ShipperID
		FROM Shippers
		WHERE ShipperName = 'Speedy Express'
	);

-- 2a.2 Using INNER JOIN
SELECT
	COUNT(*) AS TotalOrders
FROM
	Orders
INNER JOIN
	Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE
	ShipperName = 'Speedy Express';


-- 2b. What is the last name of the employee with the most orders?

-- 2b.1 Using nested SELECT
SELECT
	LastName
FROM
	Employees
WHERE
	EmployeeID = (
		SELECT
			EmployeeID
		FROM (
			SELECT
				MAX(TotalOrders),
				EmployeeID
			FROM (
				SELECT
					COUNT(*) AS TotalOrders,
					EmployeeID
				FROM
					Orders
				GROUP BY
					EmployeeID
			)
		)
	);

--  2b.2 Using MAX() and INNER JOIN
/*
NB (1): 2b.2 returns an additional column (MaxTotalOrders).
NB (2): 2b.2 is faster than 2b.3 but is less useful if the intention is	to rank 
		employees by number	of orders.
*/
SELECT
	LastName
FROM (
	SELECT
		LastName,
		MAX(TotalOrders) AS MaxTotalOrders
	FROM (
		SELECT
			Employees.LastName,
			COUNT(*) AS TotalOrders
		FROM
			Employees
		INNER JOIN
			Orders ON Employees.EmployeeID = Orders.EmployeeID
		GROUP BY
			Employees.EmployeeID
		)
	);


-- 2b.3 Using ORDER BY and LIMIT
/*
NB (1): 2b.3 provides the exact answer requested.
NB (2): 2b.3 is slower than 2b.2 but makes it easier to get a table of employees
		ranked by number of orders.
*/
SELECT
	LastName
FROM (
	SELECT
		Employees.LastName,
		COUNT(*) AS TotalOrders
	FROM
		Employees
	INNER JOIN
		Orders ON Employees.EmployeeID = Orders.EmployeeID
	GROUP BY
		Employees.EmployeeID
	ORDER BY
		TotalOrders DESC
	)
LIMIT 1;



-- 2c. What product was ordered the most by customers in Germany?

-- 2c.1 Using nested SELECT
SELECT
	ProductName
FROM
	Products
WHERE
	ProductID = (
		SELECT
			ProductID
		FROM (
			SELECT
				ProductID,
				MAX(SumQty)
			FROM (
				SELECT
					ProductID,
					SUM(Quantity) AS SumQty
				FROM
					OrderDetails
				WHERE
					OrderID IN (
						SELECT
							OrderID
						FROM
							Orders
						WHERE
							CustomerID IN (
								SELECT
									CustomerID
								FROM
									Customers
								WHERE
									Country = 'Germany'
							)
					)
				GROUP BY
					ProductID
			)
		)
	);

--  2c.2 Using MAX() and INNER JOIN
/*
NB: 2c.2 is slower than 2c.3 but is less useful if the intention is to rank 
	the most popular products among German customers.
*/
SELECT
	ProductName
FROM (
	SELECT
		ProductName,
		MAX(SumQty) AS MaxSumQty
	FROM (
		SELECT
			Products.ProductName,
			SUM(OrderDetails.Quantity) AS SumQty
		FROM
			Products
		INNER JOIN
			OrderDetails ON Products.ProductID = OrderDetails.ProductID
		INNER JOIN
			Orders ON OrderDetails.OrderID = Orders.OrderID
		INNER JOIN
			Customers ON Orders.CustomerID = Customers.CustomerID
		WHERE
			Customers.Country = 'Germany'
		GROUP BY
			OrderDetails.ProductID
		)
	);

-- 2c.3 Using ORDER BY and LIMIT
/*
NB: 2c.3 is slower than 2c.2 but makes it easier to get a table of the most
	popular products among German customers.
*/
SELECT
	ProductName
FROM (
	SELECT
		Products.ProductName,
		SUM(OrderDetails.Quantity) AS SumQty
	FROM
		Products
	INNER JOIN
		OrderDetails ON Products.ProductID = OrderDetails.ProductID
	INNER JOIN
		Orders ON OrderDetails.OrderID = Orders.OrderID
	INNER JOIN
		Customers ON Orders.CustomerID = Customers.CustomerID
	WHERE
		Customers.Country = 'Germany'
	GROUP BY
		OrderDetails.ProductID
	ORDER BY
		SumQty DESC
	)
LIMIT 1;

