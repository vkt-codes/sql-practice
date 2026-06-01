-- Employees whose salaries are above the company average 
WITH salary_avg AS (
    SELECT AVG(salary) AS avg_salary 
    FROM employees
) 
SELECT e.name, e.department, e.salary, e.salary - s.avg_salary AS difference_average 
FROM employees AS e 
CROSS JOIN salary_avg AS s 
WHERE e.salary > s.avg_salary;

-- For each department, find the top 2 highest paid employees 
WITH high_paid_emp AS (
    SELECT name, DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
    FROM employees
)
SELECT e.department, e.name, e.salary, h.dept_rank 
FROM employees AS e
INNER JOIN high_paid_emp AS h ON e.name = h.name
WHERE h.dept_rank <= 2;
-- I use DENSE_RANK because in the event of a tie I want to show everyone with the top 2 salary levels, and not cut them off arbitrarily 

-- departments whose average salary is higher than the average salary for the entire company 
WITH company_avg AS (
    SELECT AVG(salary) AS avg_comp_salary
    FROM employees
),
dept_avg AS (
    SELECT department, AVG(salary) AS avg_dept_salary
    FROM employees
    GROUP BY department
)
SELECT d.department, d.avg_dept_salary, c.avg_comp_salary, d.avg_dept_salary - c.avg_comp_salary  AS difference
FROM dept_avg AS d
CROSS JOIN company_avg AS c
WHERE d.avg_dept_salary > c.avg_comp_salary;

-- For each department, calculate: number of employees; total payroll; department budget (from departments); what percentage of the budget is consumed by salaries.
-- Show only those departments where salaries consume more than 50% of the budget. Sort by % descending.
WITH dept_info AS (
    SELECT department, COUNT(name) AS emp_count, SUM(salary) as dept_salary 
    FROM employees
    GROUP BY department    
),
dept_percent AS (
    SELECT 
        d.name, 
        d.budget, 
        d_i.emp_count, 
        d_i.dept_salary, 
        (d_i.dept_salary * 100.0) / d.budget AS percent
    FROM departments AS d
    INNER JOIN dept_info AS d_i 
        ON d_i.department = d.name
)
SELECT *
FROM dept_percent
WHERE percent > 50
ORDER BY percent DESC;
