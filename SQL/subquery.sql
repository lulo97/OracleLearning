--A sql query Q1 is nested inside sql query Q2 then we say Q1 is inner query and Q2 is outer query


--Nested subquery
/*
- Q1 (inner query) and Q2 is independent (outer query)
- Q1 excute first, then Q2 used output of Q1 to excute next
- Nested subquery is excute one
*/

--Select all employees that have salary higher than average salary
SELECT employee_id, first_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--Correlated subquery
/*
- Q1 (inner query) is depended on Q2 (outer query)
- Q1 excute first, then Q2 used output of Q1 to excute next
- Correlated subquery excute mutiple time, for each row in outer query then inner query will excute
*/

--Select all employees that have salary higher than average salary of each department
--Inner query depended on department_id of e1 which come from outer query
SELECT e1.employee_id, e1.first_name
FROM employees e1
WHERE e1.salary > (SELECT AVG(e2.salary)
                   FROM employees e2
                   WHERE e2.department_id = e1.department_id);
                   
--Rewrite correlated subquery by join to make it faster
--Step 1: Make a table e2 to caculate average salary based on department (GROUP BY department_id)
--Step 2: JOIN table e1 to e2 on condition department_id
--Step 3: Filter row have e1.salary > e2.avg_salary by WHERE keyword
SELECT e1.employee_id, e1.first_name, e1.salary
FROM employees e1
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) e2 ON e1.department_id = e2.department_id
WHERE e1.salary > e2.avg_salary;

--Example correlated subquery can more readable than JOIN

--Find Employees Whose Salary is Greater than All Others in Their Department
SELECT e1.employee_id, e1.first_name, e1.salary
FROM employees e1
WHERE e1.salary > ALL (
    SELECT e2.salary
    FROM employees e2
    WHERE e2.department_id = e1.department_id
      AND e2.employee_id != e1.employee_id
);

--JOIN version of above query is very complex and harder to read
SELECT e1.employee_id, e1.first_name, e1.salary
FROM employees e1
LEFT JOIN employees e2
  ON e1.department_id = e2.department_id
  AND e1.employee_id != e2.employee_id
WHERE e1.salary > COALESCE(e2.salary, 0)
GROUP BY e1.employee_id, e1.first_name, e1.salary
HAVING COUNT(e2.employee_id) = SUM(CASE WHEN e1.salary > e2.salary THEN 1 ELSE 0 END);

















