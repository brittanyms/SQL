--1 List employees and the customers for whom they booked an order for. Provide the concatenated employee name and concatenated customer name.
SELECT DISTINCT CONCAT (e.empfirstname, ' ', e.emplastname) employeename, CONCAT (c.custfirstname, ' ', c.custlastname) customername
FROM customers c
JOIN orders o
ON c.customerid = o.customerid
JOIN employees e
ON o.employeeid = e.employeeid
ORDER BY employeename, customername
LIMIT 10

--2 Count the number of orders who are associated with the employee Kathryn Patterson. Return only the count.
SELECT COUNT(o.ordernumber)
FROM orders o 
JOIN employees e
ON o.employeeid = e.employeeid
WHERE e.empfirstname LIKE '%Kathryn%'

--3 Display all order details that have a total quoted value greater than 100, the products in each order, and the amount owed for each product. Provide the order number, product name, and amount owed.
SELECT od.ordernumber, p.productname, od.quotedprice * od.quantityordered amount_owed
FROM order_details od
JOIN products p
ON od.productnumber = p.productnumber
WHERE od.quotedprice * od.quantityordered * 1.0 > 100.0
LIMIT 10

--4 Display customers who have no sales rep (employees) in the same ZIP code. Provide the customer ID, zip code, and customer name. Have the customer name be in one column, first and last name concatenated. 
SELECT c.customerid, CONCAT (c.custfirstname, ' ', c.custlastname) customername, c.custzipcode
FROM customers c
LEFT JOIN employees e
ON c.custzipcode = e.empzipcode
WHERE e.empzipcode IS NULL
LIMIT 10

--5 Which products have more than 10 units on hand but have never been ordered? Output the product number, product name, and order number. 
SELECT p.productnumber, p.productname, od.ordernumber
FROM products p
LEFT JOIN order_details od
ON p.productnumber = od.productnumber
WHERE p.quantityonhand > 10 AND od.ordernumber IS NULL