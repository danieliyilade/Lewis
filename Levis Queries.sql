----- Query out all the tables

SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM propertyinfo;

---- 1. How much revenue did we generate from each product category after 
-----   considering a 10% discount for products that cost more than $100,
----- a 5% discount on products that cost between $50 and $100.

SELECT "ProductCategory" from products


SELECT "ProductCategory", 
       SUM( CASE 
	        WHEN "Price" > 100 THEN "Price" * 0.9 * "Quantity"
			WHEN "Price" BETWEEN 50 AND 100 THEN "Price" * 0.95 * "Quantity"
			ELSE "Price" * "Quantity"
			END) AS TotalRevenue
FROM orders 
JOIN products 
On products."ProductID" = orders."ProductID"
GROUP BY "ProductCategory";

--- 2. What is the total revenue generate, considering that products with a NULL price 
---    should be treated as having a default price of $10?

SELECT  SUM(COALESCE ("Price",10) * "Quantity") AS "Total revenue"
FROM orders
JOIN products 
On products."ProductID" = orders."ProductID";

---- 3. How many orders were placed in year 2015

SELECT min("OrderDate"),Max("OrderDate")
FROM orders

SELECT COUNT(DISTINCT("OrderID"))
FROm orders
WHERE "OrderDate" BETWEEN '2015-01-01' AND '2015-12-31';

--- 4. What is the name and category of the top-selling product in terms of quantity in year 2015

SELECT "ProductCategory","ProductName", SUM("Quantity") AS "Total Quantity"
FROM orders
JOIN products 
On products."ProductID" = orders."ProductID"
GROUP BY "ProductCategory","ProductName"
ORDER BY "Total Quantity" DESC
LIMIT 1;

---- 5. What is the average Price of the product that have never been ordered

SELECT COALESCE (AVG("Price"),0)
FROM products
WHERE "ProductID" NOT IN (SELECT DISTINCT "ProductID" FROM orders);


