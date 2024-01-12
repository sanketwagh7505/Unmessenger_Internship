CREATE DATABASE ORG;
USE ORG;
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate DATE
);
CREATE TABLE Products(
ProductID INT PRIMARY KEY,
Name VARCHAR(255),
Category VARCHAR(255),
Price DECIMAL(10, 2)
);
CREATE TABLE Orders(
OrderID INT PRIMARY KEY,
CustomerID INT,
OrderDate DATE,
TotalAmount DECIMAL(10, 2),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails(
OrderDetailID INT PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
PricePerUnit DECIMAL(10, 2),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inserting Data into Tables Created. 

INSERT INTO Customers (CustomerID, Name , Email, JoinDate) VALUES 
(1, "John Doe", "johndoe@example.com", "2020-01-10"),
(2, "Jane Smith", "janesmith@example.com", "2020-01-15"),
(3, "Dwayne Johnson", "dwaynejohson@example.com", "2018-02-25"),
(4, "Chris Hemsworth", "chrishemsworth@example.com", "2018-03-20"),
(5, "Robert Pattinson", "robertpattinson@example.com", "2018-03-25"),
(6, "Scarlet Johnson", "scarletjohnson@example.com", "2018-04-10"),
(7, "Will Smith", "willsmith@example.com", "2018-04-18"),
(8, "Gal Gadot", "galgadot@example.com", "2018-04-30"),
(9, "Robert Downey Jr", "robertdowneyjr.com", "2018-05-12"),
(10, "Alice Johnson", "alicejohson@example.com", "2018-05-24");

INSERT INTO Products (ProductID, Name, Category, Price) VALUES 
(1, "Laptop", "Electronics", 49999.99),
(2, "Smartphone", "Electronics", 21999.99),
(3, "Tubelight", "Electrical", 499.99),
(4, "Speaker", "Electronics", 1000.00),
(5, "Fan", "Electrical", 3000.00),
(6, "Plants", "Home Decor", 600.00),
(7, "TV", "Electronics", 41999.99),
(8, "Photo Album", "Home Decor", 49999.99),
(9, "Statue", "Home Decor", 2500.10),
(10, "Desk Lamp", "Home Decor", 2000.00);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(1,1, "2024-01-05", 25000.00),
(2,3, "2023-12-30", 31700.10),
(3,9, "2023-12-21", 24500.99),
(4,8, "2020-02-16", 15200.00),
(5,2, "2020-02-22", 27500.99),
(6,10, "2020-03-02", 49999.99),
(7,7, "2020-03-08", 2500.10),
(8,5, "2020-03-15", 44999.99),
(9,4, "2020-03-25", 38800.99),
(10,6, "2020-04-05", 10500.10);


INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, PricePerUnit) VALUES
(1, 1, 3, 2, 22000.00),
(2, 5, 1, 1, 15000.10),
(3, 7, 7, 3, 24700.99),
(4, 2, 9, 5, 29800.99),
(5, 9, 5, 2, 17200.00),
(6, 8, 8, 4, 26400.10),
(7, 10, 6, 2, 31200.99),
(8, 3, 2, 1, 12000.00),
(9, 4, 4, 3, 22700.00),
(10, 6, 10, 2, 14300.99);

-- Answering the Query

## 1.Basic Queries

-- 1.1 List all Customers.
SELECT Name FROM Customers;  

-- 1.2 Show all products in the "Electronics" Category.
SELECT * FROM Products WHERE Category = "Electronics";

-- 1.3 Find the total number of order placed
SELECT COUNT(OrderID) COUNT FROM Orders;

-- 1.4 Display the details of the most recent order.
SELECT * FROM Orders ORDER BY OrderDate DESC LIMIT 1; 

## 2.Joins and Relationships:

-- 2.1 List all products along with the names of the customers who ordered them.

SELECT Products.ProductID, Products.Name AS ProductName, Customers.Name AS CustomerName FROM Products 
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- 2.2 Show orders that include more than one product.

SELECT Orders.OrderID, Customers.Name AS CustomerName, Orders.OrderDate, Orders.TotalAmount,
COUNT(OrderDetails.ProductID) AS ProductCount FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID, Customers.Name, Orders.OrderDate, Orders.TotalAmount
HAVING ProductCount > 1;

-- 2.3 Find the total sales amount for each customer.

SELECT Customers.CustomerID, Customers.Name AS CustomerName, SUM(Orders.TotalAmount) AS TotalSalesAmount
FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, CustomerName;

## 3. Aggregation and grouping 

-- 3.1 Calculate the total revenue generated by each product category.

SELECT Products.Category, SUM(OrderDetails.Quantity * OrderDetails.PricePerUnit) AS TotalRevenue FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.Category;

-- 3.2 Determine the average order value.

SELECT AVG(TotalAmount) AverageOrderValue FROM Orders;

-- 3.3 Find the month with the highest number of orders.

SELECT EXTRACT(MONTH FROM OrderDate) AS Month,COUNT(OrderID) AS OrderCount FROM Orders 
GROUP BY Month ORDER BY OrderCount DESC LIMIT 1;

## 4. Subqueries and Nested Queries.

-- 4.1 Indentify Customers who have not placed any orders.

SELECT Customers.CustomerID, Customers.Name AS CustomerName FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.CustomerID IS NULL;

-- 4.2 Find the products that have never been ordered.

SELECT Products.ProductID, Products.Name FROM Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
WHERE OrderDetails.ProductID IS NULL;

-- 4.3 Show the top 3 best-selling products.

SELECT Products.ProductID, Products.Name, Products.Category, SUM(OrderDetails.Quantity) TotalQuantity FROM Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductID, Products.Name
ORDER BY TotalQuantity DESC LIMIT 3;

## 5. Date and Time Function. 

 -- 5.1 List order placed int the last month. 
 
 SELECT OrderID, CustomerID, OrderDate, TotalAmount FROM Orders 
 WHERE OrderDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND OrderDate < CURRENT_DATE;

-- 5.2 Determine the oldest customer in terms of membership duration. 
SELECT CustomerID, Name AS CustomerName, JoinDate, TIMESTAMPDIFF(MONTH, JoinDate, CURRENT_TIME) AS DurationInMonths 
FROM Customers ORDER BY JoinDate LIMIT 1;

## 6. Advanced Queries

-- 6.1 Rank Customer Based on their total spending. 
SELECT Customers.CustomerID, Customers.Name AS CustomerName, SUM(TotalAmount) AS TotalSpending FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID GROUP BY CustomerID, CustomerName 
ORDER BY TotalSpending DESC;

-- 6.2 Identify the most popular product category  

SELECT Products.Category, COUNT(Orders.OrderID) AS OrderCount FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
GROUP BY Products.Category ORDER BY OrderCount DESC LIMIT 1;

-- 6.3 Calculate the month-over-month growth rate in sales. 

SELECT MONTH(OrderDate) AS month, SUM(TotalAmount) AS total_sales FROM Orders GROUP BY month ORDER BY month;

## 7. Data Manipulation & Updates. 

-- 7.1 Add a new customer to Customers Table. 

INSERT INTO Customers (CustomerID, Name, Email, JoinDate) VALUES 
(11, "Matthew Perry", "matthewperry@example.com", "2019-02-12");

-- 7.2 Update the Price of a Specific Product. 

UPDATE Products
SET Price = 1500.00
WHERE ProductID = 10;

