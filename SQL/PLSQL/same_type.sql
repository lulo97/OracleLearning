/* Formatted on 20-Oct-2024 03:00:01 (QP5 v5.336) */
CREATE TABLE employees
(
    employee_id    NUMBER PRIMARY KEY,
    first_name     VARCHAR2 (50),
    last_name      VARCHAR2 (50),
    salary         NUMBER
);

DECLARE
    --Column type
    v_employee_id   employees.employee_id%TYPE;

    --Row type
    v_row           employees%ROWTYPE;

    --Variable type
    v_temp_salary   NUMBER := 75000;
    v_new_salary    v_temp_salary%TYPE;
BEGIN
    v_new_salary := v_temp_salary;
    DBMS_OUTPUT.put_line ('New Salary: ' || v_new_salary);

    v_employee_id := 101;                             

    INSERT INTO employees (employee_id,
                           first_name,
                           last_name,
                           salary)
    VALUES (v_employee_id,
            'John',
            'Doe',
            v_new_salary);

    SELECT *
    INTO v_row
    FROM employees
    WHERE employee_id = v_employee_id;

    DBMS_OUTPUT.put_line ('First Name: ' || v_row.first_name);
END;

DROP TABLE employees;