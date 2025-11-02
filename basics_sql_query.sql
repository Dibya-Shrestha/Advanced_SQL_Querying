-- Connect to database
USE maven_advanced_sql;

-- View from students table
SELECT * FROM students;

--------------------------------------------------------------------
-- The Big 6 clauses
--------------------------------------------------------------------
SELECT grade_level, AVG(gpa) AS avg_gpa
FROM students 
WHERE school_lunch = 'Yes'
GROUP BY grade_level
HAVING AVG(gpa) < 3.3
ORDER BY grade_level;

--------------------------------------------------------------
-- COMMON KEYWORDS
--------------------------------------------------------------
-- DISTINCT
SELECT DISTINCT grade_level
FROM students;

-- COUNT
SELECT COUNT( DISTINCT grade_level) as total_grade_level
FROM students;

-- MAX AND MIN
SELECT MAX(gpa) - MIN(gpa) as gpa_range
FROM students;

-- AND
SELECT *
FROM students
WHERE grade_level < 12 AND school_lunch = 'Yes';

-- IN
SELECT *
FROM students
WHERE grade_level IN (9, 10, 11);

-- IS NULL
SELECT *
FROM students
WHERE email is NULL;

-- LIKE
SELECT *
FROM students
WHERE email LIKE '%.edu';

-- ORDER BY
SELECT *
FROM students
ORDER BY gpa DESC

-- LIMIT
SELECT TOP 5 *
FROM students
ORDER BY gpa DESC

-- CASE statements
SELECT student_name, grade_level,
CASE 
WHEN grade_level = 9 THEN 'Freshmen'
WHEN grade_level = 10 THEN 'Sophomore'
WHEN grade_level = 11 THEN 'Junior'
ELSE 'Senior' 
END AS student_class
FROM students

------------------------------------------------
/* JOINS */
------------------------------------------------
-- Basic Joins
-- Inner Join
SELECT hs.year, hs.happiness_score,
cs.continent
FROM happiness_scores hs
INNER JOIN country_stats cs 
ON hs.country = cs.country

-------------------------------------------------
-- Join on multiple columns
-------------------------------------------------
SELECT * FROM happiness_scores
SELECT * FROM country_stats
SELECT * FROM inflation_rates

SELECT *
FROM happiness_scores hs
INNER JOIN inflation_rates ir
ON hs.country = ir.country_name
AND hs.year = ir.year

------------------------------------------------------
-- Join on multiple tables
------------------------------------------------------
SELECT * FROM happiness_scores
SELECT * FROM country_stats
SELECT * FROM inflation_rates

SELECT hs.year, hs.country, hs.happiness_score,
cs.continent,
ir.inflation_rate
FROM happiness_scores hs
LEFT JOIN country_stats cs
ON hs.country = cs.country
LEFT JOIN inflation_rates ir
ON hs.year = ir.year
AND hs.country = ir.country_name


