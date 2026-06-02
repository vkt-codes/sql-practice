-- ============================================================
-- Subqueries basics
-- ============================================================
-- A subquery is a SELECT inside another SELECT.
-- Conceptually the same as a CTE, but inlined into the query.
--
-- Where they live:
--   WHERE x > (SELECT ...)      -- scalar (single value)
--   WHERE x IN (SELECT ...)     -- list of values
--   FROM (SELECT ...) AS sub    -- as a derived table
--
-- Subquery vs CTE:
--   - Used once and simple        → subquery (shorter, reads in place)
--   - Long or reused              → CTE (name + top-down structure)
--   - Multiple steps              → CTE (a ladder beats nested parens)
-- ============================================================


-- 1. Employees earning above the company average.
-- Scalar subquery: returns a single value, compared directly.
SELECT name, department, salary 
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


-- 2. Average salary per department, only for departments with budget >= 300000.
-- IN subquery: returns a list of department names used as a filter.
-- Could be done with a CTE or JOIN — here a subquery is shorter and clear.
SELECT department, AVG(salary) AS avg_salary
FROM employees
WHERE department IN (
    SELECT name FROM departments WHERE budget >= 300000
)
GROUP BY department;