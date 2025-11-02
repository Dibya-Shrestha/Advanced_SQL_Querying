use maven_advanced_sql

--------------------------------------------------------------------
-- Subqueries in the SELECT clause
--------------------------------------------------------------------
SELECT 
year, country, happiness_score,
(SELECT AVG (happiness_score) FROM happiness_scores) as avg_hs
FROM happiness_scores

-------------------------------------------------------------------
-- List of products from most to least expensive and how much the product differes from the average unit price?
-------------------------------------------------------------------
SELECT * FROM products

SELECT product_id, product_name, unit_price,
(SELECT AVG(unit_price) FROM products) as avg,
unit_price - (SELECT AVG(unit_price) as avg FROM products) as diff
FROM products ORDER BY unit_price DESC

-------------------------------------------------------------------
-- Return a country happiness score for the year
-- as well as the average happiness score for the country across years
--------------------------------------------------------------------
SELECT hs.year, hs.country, hs.happiness_Score,
country_hs.avg_hs_by_country
FROM happiness_scores hs
LEFT JOIN 
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country) AS country_hs
ON hs.country = country_hs.country

--------------------------------------------------------------------
-- Multiple sub queries
---------------------------------------------------------------------

-- Return happiness scores from 2015 - 2024
SELECT DISTINCT year FROM happiness_scores
SELECT * FROM happiness_scores_current

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current

-- Return a  country's happiness score for the year as well as
-- the average happiness score for the country across years

SELECT hs.year, hs.country, hs.happiness_Score,
country_hs.avg_hs_by_country
FROM 
(SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current) AS hs
LEFT JOIN 
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country) AS country_hs
ON hs.country = country_hs.country

-- Return years where the happiness score is a whole point
-- greater than the country's average happiness score

SELECT * FROM
(SELECT hs.year, hs.country, hs.happiness_Score,
country_hs.avg_hs_by_country
FROM 
(SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current) AS hs
LEFT JOIN 
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country) AS country_hs
ON hs.country = country_hs.country) AS hs_country_hs
WHERE happiness_Score > avg_hs_by_country +1

------------------------------------------------------------------
-- List of factories along with the names of the products and numbers they produce
------------------------------------------------------------------
SELECT fp.factory, fp.product_name, fn.num_products
FROM
(SELECT factory,product_name
FROM products) fp
LEFT JOIN
(SELECT factory,COUNT(product_id) AS num_products
FROM products
GROUP BY factory) fn
ON fp.factory = fn.factory

-------------------------------------------------------------------
-- Sub queries in the WHERE and HAVING clauses
-------------------------------------------------------------------
-- Average Happiness score
SELECT AVG(happiness_score) FROM happiness_scores

-- Above average happiness scores
SELECT *
FROM happiness_scores
WHERE happiness_score > (SELECT AVG(happiness_score) FROM happiness_scores)

-- Above average happiness scores for each region
SELECT region, AVG(happiness_score) AS avg_hs
FROM happiness_scores
GROUP BY region
HAVING AVG(happiness_score) > (SELECT AVG(happiness_score) FROM happiness_scores)

----------------------------------------------------------------------
-- Products that have unit price less that the unit price of all products from Wicket Choccy,s
-- Include which factory is currently producing them as well
----------------------------------------------------------------------
SELECT * FROM products
SELECT DISTINCT factory FROM products
SELECT product_name, unit_price 
FROM products
WHERE factory LIKE 'Wicked%'

SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price < 
ALL (SELECT unit_price 
FROM products
WHERE factory LIKE 'Wicked%')

-------------------------------------------------------------------
-- CTE
-- Return the happiness scores along with the average happiness for each country
----------------------------------------------------------------------
WITH country_hs AS
(SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country)

SELECT hs.year, hs.country, hs.happiness_Score,
country_hs.avg_hs_by_country
FROM happiness_scores hs
LEFT JOIN country_hs
ON hs.country = country_hs.country

---------------------------------------------------------------------
-- Compare happiness scores within each region in 2023
----------------------------------------------------------------------
WITH hs AS (SELECT * FROM happiness_scores WHERE year = 2023)

SELECT hs1.region, hs1.country, hs1.happiness_score ,
hs2.country, hs2. happiness_score
FROM hs hs1 
INNER JOIN happiness_scores hs2
ON hs1.region = hs2.region
WHERE hs1.country < hs2.country

-----------------------------------------------------------------------
-- List of all orders over $200 and the numbers of orders
-----------------------------------------------------------------------
SELECT * FROM orders

SELECT * FROM products

WITH total AS (
SELECT o.order_id,
SUM(p.unit_price * o.units) AS total_amount_spent
FROM orders o
INNER JOIN 
products p
ON o.product_id = p.product_id
GROUP BY order_id
HAVING SUM(p.unit_price * o.units) > 200
)
SELECT COUNT(*) FROM total

----------------------------------------------------------------------
-- Multiple CTEs
----------------------------------------------------------------------
-- Compare 2023 vs 2024 happiness score side by side
WITH hs23 AS (SELECT * FROM happiness_scores WHERE year = 2023),
hs24 AS (SELECT * FROM happiness_scores_current)

SELECT hs23.country, hs23.happiness_score AS hs_2023, hs24.ladder_score AS hs_2024 
FROM hs23 LEFT JOIN hs24
ON hs23.country = hs24.country

