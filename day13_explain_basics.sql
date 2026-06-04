EXPLAIN ANALYZE SELECT * FROM employees WHERE department = 'Marketing';

--                                              QUERY PLAN
------------------------------------------------------------------------------------------------------
-- Seq Scan on employees  (cost=0.00..12.00 rows=1 width=466) (actual time=0.009..0.010 rows=2 loops=1)
--   Filter: ((department)::text = 'Marketing'::text)
--   Rows Removed by Filter: 5
-- Planning Time: 0.038 ms
-- Execution Time: 0.018 ms
-- (5 rows)

CREATE INDEX idx_employees_department ON employees(department);

-- After creating index
-- Seq Scan on employees  (cost=0.00..1.09 rows=1 width=466) (actual time=0.010..0.011 rows=2 loops=1)
--   Filter: ((department)::text = 'Marketing'::text)
--   Rows Removed by Filter: 5
-- Planning Time: 0.954 ms
-- Execution Time: 0.023 ms
-- (5 rows)

-- Planner chose Seq Scan even after index creation
-- and we can see that cost, Planning and Execution time have changed, because the statistics have been updated

-- we can disable Seq Scan and use our index for the scan
SET enable_seqscan = OFF;
EXPLAIN ANALYZE SELECT * FROM employees WHERE department = 'Marketing';
SET enable_seqscan = ON;

--  Index Scan using idx_employees_department on employees  (cost=0.13..8.15 rows=1 width=466) (actual time=0.009..0.010 rows=2 loops=1)
--   Index Cond: ((department)::text = 'Marketing'::text)
-- Planning Time: 0.150 ms
-- Execution Time: 0.027 ms
--(4 rows)

-- so we can see why the planner has chosen Seq Scan even after index creation
-- On 7 rows the index doesn't pay off, and the planner knows it.