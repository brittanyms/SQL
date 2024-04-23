--1 Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals? 
SELECT DATE_PART('year', occurred_at) ord_year, SUM(total_amt_usd) total_spent
FROM orders 
GROUP BY 1
ORDER BY 2

--2 Which month did Parch & Posey have the greatest sales in terms of total dollars?
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--3 Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset? Return two columns - ord_year for the order year, and total_sales, the number of orders that occurred in that year.
SELECT DATE_PART('year', occurred_at) ord_year, COUNT(total) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC

--4 In which month of which year did Walmart spend the most on gloss paper in terms
-- of dollars? Return only one row, with two columns - the order_month and tot_spent(total spent on gloss in USD).
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

--5 We would like to understand 3 different branches of customers based on the amount
-- associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) 
-- greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 
-- 100,000 usd. Provide a table that includes the level associated with each account. You should provide a column called 
-- name (account name), total_spent, the total sales of all orders for the customer, and customer_level (the level categorization of the customer). 
-- Order with the top spending customers listed first.
SELECT a.name, SUM(o.total_amt_usd) total_spent,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
	WHEN SUM(o.total_amt_usd) > 100000 THEN 'middle'
	ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--6 We would now like to perform a similar calculation to the first, but we want to obtain the total amount
-- spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first. 
SELECT a.name, SUM(o.total_amt_usd) total_spent,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
	WHEN SUM(o.total_amt_usd) > 100000 THEN 'middle'
	ELSE 'low' END AS customer_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--7 We would like to identify top performing sales reps, which are sales reps associated with more than 200
-- orders. Create a table with the sales rep name, the total number of orders, and a column with top or
-- not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(*),
	CASE WHEN COUNT(*) > 200 THEN 'top'
	ELSE 'not' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--8 The previous query didn’t account for the middle, nor the dollar amount associated with the sales. Management decides 
-- they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are 
-- sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
-- Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. 
-- Place the top sales people based on dollar amount of sales first in your final table. There should be 4 columns - name, num_orders, total_spent, and sales_rep_level.
SELECT s.name, COUNT(*) num_orders, SUM(total_amt_usd) total_spent, 
	CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top'
	WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle'
	ELSE 'not' END AS sales_rep_level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5
