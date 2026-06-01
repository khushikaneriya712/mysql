CREATE DATABASE DataTransformer;

USE DataTransformer;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1,'John','Doe','john.doe@email.com','2022-03-15'),
(2,'Jane','Smith','jane.smith@email.com','2021-11-02');

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101,1,'2023-07-01',150.50),
(102,2,'2023-07-03',200.75);


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1,'Mark','Johnson','Sales','2020-01-15',50000),
(2,'Susan','Lee','HR','2021-03-20',55000);


-- querys
-- 1 
SELECT c.CustomerID,c.FirstName,c.LastName,
       o.OrderID,o.OrderDate,o.TotalAmount
FROM Customers c
INNER JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- 2
SELECT *
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- 3
SELECT *
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;

-- 4
SELECT *
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID=o.CustomerID

UNION

SELECT *
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID=o.CustomerID;

-- 5
SELECT *
FROM Customers
WHERE CustomerID IN
(
SELECT CustomerID
FROM Orders
WHERE TotalAmount >
(
SELECT AVG(TotalAmount)
FROM Orders
)
);


-- 6
SELECT *
FROM Employees
WHERE Salary >
(
SELECT AVG(Salary)
FROM Employees
);

-- 7
SELECT OrderID,
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month
FROM Orders;

-- 8
SELECT OrderID,
DATEDIFF(CURDATE(),OrderDate) AS Days_Difference
FROM Orders;

-- 9
SELECT OrderID,
DATE_FORMAT(OrderDate,'%d-%b-%Y') AS Formatted_Date
FROM Orders;

-- 10
SELECT CONCAT(FirstName,' ',LastName) AS FullName
FROM Customers;

-- 11
SELECT REPLACE(FirstName,'John','Jonathan')
FROM Customers;

-- 12
SELECT UPPER(FirstName) AS FirstName,
LOWER(LastName) AS LastName
FROM Customers;

-- 13
SELECT TRIM(Email)
FROM Customers;

-- 14
SELECT OrderID,
TotalAmount,
SUM(TotalAmount) OVER(ORDER BY OrderID) AS Running_Total
FROM Orders;

-- 15
SELECT OrderID,
TotalAmount,
RANK() OVER(ORDER BY TotalAmount DESC) AS Ranking
FROM Orders;

-- 16
SELECT OrderID,
TotalAmount,
CASE
WHEN TotalAmount > 1000 THEN '10% Discount'
WHEN TotalAmount > 500 THEN '5% Discount'
ELSE 'No Discount'
END AS Discount
FROM Orders;

-- 17
SELECT EmployeeID,
FirstName,
Salary,
CASE
WHEN Salary >= 55000 THEN 'High'
WHEN Salary >= 50000 THEN 'Medium'
ELSE 'Low'
END AS Salary_Category
FROM Employees;