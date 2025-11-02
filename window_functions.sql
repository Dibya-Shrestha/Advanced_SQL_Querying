use maven_advanced_sql

--------------------------------------------------------------
-- Window functions basics
--------------------------------------------------------------
SELECT country, year, happiness_score, 
ROW_NUMBER() OVER (PARTITION BY country ORDER BY happiness_score) AS row_num
FROM happiness_scores
ORDER BY country, row_num

--------------------------------------------------------------
-- customer, order and transaction ID with transaction number for each customer
--------------------------------------------------------------
SELECT * FROM orders

SELECT customer_id, order_id, order_date, transaction_id,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY transaction_id) as transaction_num
FROM orders
ORDER BY customer_id, transaction_id

---------------------------------------------------------------
-- Which products are most popular within each other
-- create a product rank field that returns 1 for the most popular in the order
-- 2 for second most and so on
----------------------------------------------------------------
SELECT * FROM orders

SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS rank
FROM orders
ORDER BY order_id, rank

-----------------------------------------------------------------
-- Value within a window
-- List of 2nd most popular product within wach order
----------------------------------------------------------------
SELECT * FROM orders

SELECT * FROM
(SELECT order_id, product_id, units,
DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS pr_rank
FROM orders) AS pr
WHERE pr_rank=2

----------------------------------------------------------------
-- Lead and Lag
----------------------------------------------------------------
WITH hs_prior AS
(SELECT country, year, happiness_score,
LAG(happiness_score) OVER(PARTITION BY country ORDER BY year)AS prior_happiness_score
FROM happiness_scores)
SELECT country, year,happiness_score,prior_happiness_score,
prior_happiness_score - happiness_score AS diff
FROM hs_prior

-----------------------------------------------------------------
-- customer and their orders, the number of units in each order and the change in units from order to order#
-----------------------------------------------------------------
SELECT customer_id, order_id, units, transaction_id, order_date FROM orders

-- Add transaction id to keep track of the order of the orders
SELECT customer_id, order_id, MIN(transaction_id) AS min_td, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id

-- Turning into CTE
WITH my_cte as 
(SELECT customer_id, order_id, MIN(transaction_id) AS min_td, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id)
SELECT * FROM my_cte

-- Create a prior units column
WITH my_cte AS 
(SELECT customer_id, order_id, MIN(transaction_id) AS min_td, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id)
SELECT customer_id, order_id, total_units,
LAG(total_units) OVER(PARTITION BY customer_id ORDER BY min_td) AS prior_units
FROM my_cte

-- Find the difference
WITH my_cte AS 
(SELECT customer_id, order_id, MIN(transaction_id) AS min_td, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id),
prior_cte AS 
(SELECT customer_id, order_id, total_units,
LAG(total_units) OVER(PARTITION BY customer_id ORDER BY min_td) AS prior_units
FROM my_cte)

SELECT customer_id, order_id, total_units, prior_units,
total_units - prior_units AS diff
FROM prior_cte