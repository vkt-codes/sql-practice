SELECT name, salary, ROW_NUMBER() OVER (
    PARTITION BY department ORDER BY salary DESC
) AS rn
FROM employees;

SELECT name, department, salary, LEAD(salary, 1) OVER (
    PARTITION BY department ORDER BY salary DESC
)
FROM employees;

SELECT name,  salary, AVG(salary) OVER (PARTITION BY department) AS avg_salary, 
salary - AVG(salary) OVER (PARTITION BY department) AS difference
FROM employees;
