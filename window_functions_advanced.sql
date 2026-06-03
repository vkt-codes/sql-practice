-- ============================================================
-- Window functions: advanced
-- ============================================================
-- Window functions compute values across a set of rows ("window")
-- related to the current row, WITHOUT collapsing rows like GROUP BY does.
--
-- Ranking functions:
--   ROW_NUMBER()  -- unique sequential numbers, no ties
--   RANK()        -- ties share number, gaps follow (1, 1, 3, 4)
--   DENSE_RANK()  -- ties share number, no gaps (1, 1, 2, 3)
--
-- Offset functions:
--   LAG(col, n, default)   -- value from n rows before current
--   LEAD(col, n, default)  -- value from n rows after current
--   n defaults to 1, default is NULL
--
-- Aggregates as windows:
--   AVG/SUM/COUNT/MIN/MAX OVER (...)
--   attach an aggregate as a column without grouping
-- ============================================================


-- 1. Number employees inside each department, highest salary first.
-- ROW_NUMBER chosen because we want sequential ordering without ties:
-- not ranking on a podium, not grouping by salary level — just a position.
SELECT 
    name, 
    department, 
    salary, 
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
FROM employees;


-- 2. For each employee, show their salary and the next-lower salary
-- in the same department. NULL if they are the lowest paid.
-- LEAD chosen because rows are sorted by salary DESC, so the "next lower"
-- salary lives in the row below the current one.
SELECT 
    name, 
    department, 
    salary, 
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_lower_salary
FROM employees;


-- 3. For each employee: salary, department average, and the difference.
-- No GROUP BY — window aggregate attaches the average as a column
-- without collapsing rows.
SELECT 
    name, 
    department, 
    salary, 
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM employees;