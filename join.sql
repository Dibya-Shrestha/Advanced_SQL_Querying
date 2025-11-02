use maven_advanced_sql

------------------------------------------------
-- Which products exist in one table and not other between orders and products?
------------------------------------------------
-- View the orders and product table
SELECT * FROM orders
SELECT * FROM products

SELECT COUNT(DISTINCT product_id) FROM orders
SELECT COUNT(DISTINCT product_id) FROM products

-- Join the tables using various join types and note the number of rows in the output
SELECT COUNT(*)
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id -- 8552

SELECT COUNT(*)
FROM products p
RIGHT JOIN orders o
ON p.product_id = o.product_id -- 8549

-- View the products that exist in one table, but not the other
SELECT *
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id 
WHERE o.product_id IS NULL

SELECT *
FROM products p
RIGHT JOIN orders o
ON p.product_id = o.product_id 
WHERE p.product_id IS NULL

-- Use a LEFT JOIN to know the result
SELECT p.product_id, p.product_name,
o.product_id as product_id_in_orders
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id 
WHERE o.product_id IS NULL

-----------------------------------------------------------
-- Which products are within 25 cents of each other in terms of unit price?
-----------------------------------------------------------
SELECT l.product_name, l.unit_price,
r.product_name, r.unit_price,
l.unit_price - r.unit_price AS price_diff
FROM dbo.products l
INNER JOIN dbo.products r
on l.product_id <> r.product_id
WHERE l.unit_price - r.unit_price BETWEEN -0.25 AND 0.25
ORDER BY price_diff DESC




