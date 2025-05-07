-- SOLUTION 1
-- SQL query to transform the ProductDetail table into 1NF,
-- ensuring that each row represents a single product for an order.
-- This query splits the comma-separated Products column into individual rows.

SELECT 
    OrderID, 
    CustomerName, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY 
    OrderID, n.n;

-- SOLUTION 2
-- SQL statements to transform the OrderDetails table into 2NF,
-- by removing partial dependencies and ensuring all non-key attributes
-- fully depend on the entire primary key.
-- This is achieved by splitting the table into Orders and OrderItems tables.

-- Step 1: Create the Orders table to store OrderID and CustomerName,
-- where CustomerName depends only on OrderID.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create the OrderItems table to store individual products and quantities,
-- linked to Orders by OrderID.

CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert data into Orders table.

INSERT INTO Orders (OrderID, CustomerName)
VALUES 
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

-- Step 4: Insert data into OrderItems table.

INSERT INTO OrderItems (OrderID, Product, Quantity)
VALUES 
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);
