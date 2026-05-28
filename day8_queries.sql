-- creating the table --
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INTEGER,
    city VARCHAR(50),
    hire_date DATE
);

-- filling in the table --
INSERT INTO employees (name, department, salary, city, hire_date) VALUES
('Anna', 'Engineering', 7000, 'Dubai', '2022-03-15'),
('Boris', 'Engineering', 9000, 'Dubai', '2021-01-10'),
('Clara', 'Marketing', 5500, 'Abu Dhabi', '2023-06-01'),
('David', 'Marketing', 6000, 'Dubai', '2022-11-20'),
('Elena', 'Sales', 5000, 'Sharjah', '2023-02-14'),
('Farid', 'Engineering', 8500, 'Abu Dhabi', '2020-09-05'),
('Gala', 'Sales', 7500, 'Dubai', '2021-07-30');

-- Basic selection with the condition
SELECT name, salary FROM employees WHERE salary > 6000;

-- Sorting
SELECT name, salary FROM employees ORDER BY salary DESC;

-- Filter by multiple conditions
SELECT name FROM employees WHERE department = 'Engineering' AND city = 'Dubai';

-- Aggregation: average salary
SELECT AVG(salary) FROM employees;

-- Grouping: average salary by department
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;

-- Grouping + Sorting + Rounding
SELECT department, 
       ROUND(AVG(salary)) AS avg_salary,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

-- HAVING — filter by aggregate (departments with an average salary > 6000)
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 6000;

-- Each employee + the average salary for the ENTIRE company is nearby
SELECT name, salary,
       ROUND(AVG(salary) OVER ()) AS company_avg
FROM employees;

-- Each employee + the average of HIS department
SELECT name, department, salary,
       ROUND(AVG(salary) OVER (PARTITION BY department)) AS dept_avg
FROM employees;

-- Salary ranking
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Rank within each department
SELECT name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;





SELECT name, city FROM employees WHERE city = 'Dubai'  ORDER BY salary DESC;

SELECT city, COUNT(*) AS employee_count FROM employees GROUP BY city;

SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department  HAVING COUNT(*) > 1;

SELECT * 
FROM (
    SELECT name, department, salary, RANK() OVER(PARTITION BY department ORDER BY salary DESC) 
    AS dept_rank FROM employees
) as subquery
WHERE dept_rank = 1;

