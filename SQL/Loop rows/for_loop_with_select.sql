/* Formatted on 20-Oct-2024 02:43:14 (QP5 v5.336) */
CREATE TABLE employees
(
    employee_id    NUMBER PRIMARY KEY,
    first_name     VARCHAR2 (50),
    last_name      VARCHAR2 (50)
);


INSERT INTO employees (employee_id, first_name, last_name)
VALUES (101, 'John', 'Doe');

INSERT INTO employees (employee_id, first_name, last_name)
VALUES (102, 'Jane', 'Smith');

INSERT INTO employees (employee_id, first_name, last_name)
VALUES (103, 'Alice', 'Johnson');

INSERT INTO employees (employee_id, first_name, last_name)
VALUES (104, 'Bob', 'Brown');


-- Retrieve and display the employees

BEGIN
    FOR someone IN (SELECT *
                    FROM employees
                    WHERE employee_id < 120
                    ORDER BY employee_id)
    LOOP
        DBMS_OUTPUT.put_line (
               'First name = '
            || someone.first_name
            || ', Last name = '
            || someone.last_name);
    END LOOP;
END;

DROP TABLE employees