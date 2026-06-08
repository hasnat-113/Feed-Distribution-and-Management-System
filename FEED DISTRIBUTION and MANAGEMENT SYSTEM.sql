

DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS Deliveries CASCADE;
DROP TABLE IF EXISTS Order_Details CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Feed_Products CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Salesman CASCADE;



CREATE TABLE Salesman(
salesman_id SERIAL PRIMARY KEY,
salesman_name VARCHAR(100),
phone VARCHAR(20),
address VARCHAR(100)
);

CREATE TABLE Feed_Products(
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price_per_bag DECIMAL(10,2),
stock_quantity INT,
salesman_id INT REFERENCES Salesman(salesman_id)
);

CREATE TABLE Customers(
customer_id SERIAL PRIMARY KEY,
customer_name VARCHAR(100),
contact VARCHAR(20),
location VARCHAR(100)
);

CREATE TABLE Orders(
order_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES Customers(customer_id),
order_date DATE DEFAULT CURRENT_DATE,
total_amount DECIMAL(10,2),
status VARCHAR(50)
);

CREATE TABLE Order_Details(
order_detail_id SERIAL PRIMARY KEY,
order_id INT REFERENCES Orders(order_id),
product_id INT REFERENCES Feed_Products(product_id),
quantity INT
);

CREATE TABLE Deliveries(
delivery_id SERIAL PRIMARY KEY,
order_id INT REFERENCES Orders(order_id),
delivery_date DATE,
driver_name VARCHAR(100),
delivery_status VARCHAR(50)
);

CREATE TABLE Payments(
payment_id SERIAL PRIMARY KEY,
order_id INT REFERENCES Orders(order_id),
payment_date DATE,
amount_paid DECIMAL(10,2),
payment_method VARCHAR(50)
);



INSERT INTO Salesman
(salesman_name,phone,address)
VALUES
('Ali Khan','03001234567','Lahore'),
('Ahmed Raza','03111234567','Faisalabad');

INSERT INTO Feed_Products
(product_name,category,price_per_bag,stock_quantity,salesman_id)
VALUES
('Omega Feed','Poultry',2500,500,1),
('HS Feed','Fish',1800,300,1),
('NNF Feed','Cattle',3200,250,2);

INSERT INTO Customers
(customer_name,contact,location)
VALUES
('Usman Farms','03211234567','Multan'),
('Bilal Poultry','03331234567','Sahiwal');

INSERT INTO Orders
(customer_id,total_amount,status)
VALUES
(1,12500,'Confirmed'),
(2,6400,'Pending');

INSERT INTO Order_Details
(order_id,product_id,quantity)
VALUES
(1,1,5),
(2,3,2);

INSERT INTO Deliveries
(order_id,delivery_date,driver_name,delivery_status)
VALUES
(1,CURRENT_DATE,'Shahid','Delivered'),
(2,CURRENT_DATE,'Aslam','In Transit');

INSERT INTO Payments
(order_id,payment_date,amount_paid,payment_method)
VALUES
(1,CURRENT_DATE,12500,'Cash'),
(2,CURRENT_DATE,6400,'Bank Transfer');


-- Show All Products

SELECT * FROM Feed_Products;

-- Total Products

SELECT COUNT(*) AS total_products
FROM Feed_Products;

-- Total Customers

SELECT COUNT(*) AS total_customers
FROM Customers;

-- Total Orders

SELECT COUNT(*) AS total_orders
FROM Orders;

-- Total Sales

SELECT SUM(total_amount) AS total_sales
FROM Orders;

-- Customer Orders

SELECT
c.customer_name,
o.order_id,
o.total_amount,
o.status
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id;

-- Delivery Report

SELECT
d.delivery_id,
d.driver_name,
d.delivery_status
FROM Deliveries d;

-- Payment Report

SELECT
payment_id,
amount_paid,
payment_method
FROM Payments;

-- Calculate Order Amount Automatically

SELECT
o.order_id,
SUM(fp.price_per_bag * od.quantity) AS calculated_total
FROM Orders o
JOIN Order_Details od
ON o.order_id=od.order_id
JOIN Feed_Products fp
ON od.product_id=fp.product_id
GROUP BY o.order_id;

-- Best Selling Product

SELECT
fp.product_name,
SUM(od.quantity) AS total_quantity_sold
FROM Feed_Products fp
JOIN Order_Details od
ON fp.product_id=od.product_id
GROUP BY fp.product_name
ORDER BY total_quantity_sold DESC;

-- Remaining Stock

SELECT
product_name,
stock_quantity
FROM Feed_Products;
