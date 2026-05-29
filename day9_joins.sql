--- creating ---
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    budget INTEGER,
    location VARCHAR(50)
);

INSERT INTO departments (name, budget, location) VALUES
('Engineering', 500000, 'Dubai'),
('Marketing', 200000, 'Abu Dhabi'),
('Sales', 300000, 'Dubai'),
('HR', 150000, 'Sharjah');

-- INNER JOIN — only employees whose departments have a record
SELECT e.name, e.department, d.budget, d.location
FROM employees AS e
INNER JOIN departments AS d ON e.department = d.name;

-- LEFT JOIN — all employees (even if the department is not in departments)
SELECT e.name, e.department, d.budget
FROM employees AS e
LEFT JOIN departments AS d ON e.department = d.name;

-- And now, on the contrary, all departments, including HR (where there is no one)
SELECT d.name, d.budget, e.name AS employee
FROM departments AS d
LEFT JOIN employees AS e ON d.name = e.department;

-- The name of each employee and the location of his department (location from departments). Only those who have a department in departments.
SELECT e.name, d.location 
FROM employees AS e 
INNER JOIN departments AS d ON e.department = d.name;

-- The names of employees who work in departments with budgets over 250,000. Show me your name, department, and budget.
SELECT e.name, d.name, d.budget 
FROM employees AS e 
INNER JOIN departments AS d ON e.department = d.name 
WHERE d.budget > 250000;

-- The budget and how many employees work in the department
SELECT d.name, d.budget, COUNT(e.name) AS employees_count
FROM departments AS d 
LEFT JOIN employees AS e ON d.name = e.department
GROUP BY d.name, d.budget;

-- departments where no one works
SELECT d.name
FROM departments AS d
LEFT JOIN employees AS e ON d.name = e.department
WHERE e.name IS NULL;

SELECT location, SUM(budget) AS total_budget
FROM departments
GROUP BY location;

SELECT d.location, SUM(e.salary) AS total_salaries
FROM employees AS e
INNER JOIN departments AS d ON e.department = d.name
GROUP BY d.location;