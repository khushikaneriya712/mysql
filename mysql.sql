CREATE DATABASE ShopSphere;

USE ShopSphere;

-- STEP 1 : Create Customers Table

CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(20),
    Email VARCHAR(30),
    Address VARCHAR(30)
);

INSERT INTO Customers VALUES
(1,'khushi','khushi@gmail.com','Surat'),
(2,'krish','krish@gmail.com','Pune'),
(3,'nidhi','nidhi@gmail.com','Ahmedabad'),
(4,'manisha','manisha@gmail.com','Rajkot'),
(5,'kaushik','kaushik@gmail.com','Delhi'),
(6,'nisha','nisha@gmail.com','Mumbai'),
(7,'dipak','dipak@gmail.com','Vadodara'),
(8,'jeni','jeni@gmail.com','Jaipur'),
(9,'het','het@gmail.com','Indore'),
(10,'prushti','prushti@gmail.com','Chennai');

SELECT * FROM Customers;

UPDATE Customers
SET Address='Bangalore'
WHERE CustomerID=2;

DELETE FROM Customers
WHERE CustomerID=7;

SELECT * FROM Customers
WHERE Name='khushi';


-- STEP 2 : Create Orders Table

CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),

    FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(201,1,'2026-01-05',3500),
(202,2,'2026-01-10',4200),
(203,3,'2026-01-12',1800),
(204,1,'2026-01-18',2600),
(205,4,'2026-01-20',5000),
(206,5,'2026-01-22',3200),
(207,6,'2026-01-25',4100),
(208,3,'2026-01-27',1500),
(209,8,'2026-01-29',2800),
(210,2,'2026-01-30',4700);

SELECT * FROM Orders
WHERE CustomerID = 1;

UPDATE Orders
SET TotalAmount = 6000
WHERE OrderID = 203;

DELETE FROM Orders
WHERE OrderID = 205;

SELECT * FROM Orders
WHERE OrderDate >= CURDATE() - INTERVAL 30 DAY;

SELECT 
MAX(TotalAmount) AS Highest_Amount,
MIN(TotalAmount) AS Lowest_Amount,
AVG(TotalAmount) AS Average_Amount
FROM Orders;


-- STEP 3 : Create Products Table

CREATE TABLE Products
(
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2),
    Stock INT
);

INSERT INTO Products VALUES
(301,'Tablet',30000,12),
(302,'Smart Watch',7000,20),
(303,'Printer',12000,5),
(304,'Speaker',3500,0),
(305,'Camera',45000,7);

SELECT * FROM Products
ORDER BY Price DESC;

UPDATE Products
SET Price = 7500
WHERE ProductID = 302;

DELETE FROM Products
WHERE Stock = 0;

SELECT * FROM Products
WHERE Price BETWEEN 3000 AND 15000;

SELECT 
MAX(Price) AS Highest_Price,
MIN(Price) AS Lowest_Price
FROM Products;


-- STEP 4 : Create OrderDetails Table

CREATE TABLE OrderDetails
(
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    SubTotal DECIMAL(10,2),

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID),

    FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID)
);

INSERT INTO OrderDetails VALUES
(1,201,301,1,30000),
(2,202,302,2,14000),
(3,203,303,1,12000),
(4,204,305,1,45000),
(5,201,302,1,7000);

SELECT * FROM OrderDetails
WHERE OrderID = 201;

SELECT SUM(SubTotal) AS Total_Revenue
FROM OrderDetails;

SELECT ProductID,
SUM(Quantity) AS Total_Quantity
FROM OrderDetails
GROUP BY ProductID
ORDER BY Total_Quantity DESC
LIMIT 3;

SELECT ProductID,
COUNT(ProductID) AS Sold_Times
FROM OrderDetails
WHERE ProductID = 302
GROUP BY ProductID;

SELECT * FROM Customers;

SELECT * FROM Orders;

SELECT * FROM Products;

SELECT * FROM OrderDetails;