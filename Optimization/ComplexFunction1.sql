CREATE OR REPLACE FUNCTION fn_get_employee_type(
    p_id IN NUMBER,
    p_epoch number := 2
) RETURN CHAR IS
    v_result CHAR(1);
    v_temp NUMBER := 0;
    v_char CHAR(1);
    v_dummy VARCHAR2(1000);

    -- Variables to hold employee data
    v_name employees_test.name%TYPE;
    v_salary employees_test.salary%TYPE;
    v_department_id employees_test.department_id%TYPE;
    v_hire_date employees_test.hire_date%TYPE;
BEGIN
    -- Get employee data from table
    SELECT name, salary, department_id, hire_date
    INTO v_name, v_salary, v_department_id, v_hire_date
    FROM employees_test
    WHERE id = p_id;

    -- Random transformation and hashing
    v_dummy := LOWER(v_name) || TO_CHAR(v_salary * DBMS_RANDOM.VALUE(1, 1000), '999999.99') ||
               TO_CHAR(v_hire_date, 'YYYYMMDD') || TO_CHAR(v_department_id);
    v_temp := LENGTH(v_dummy) + INSTR(v_dummy, 'a') + ASCII(SUBSTR(v_dummy, 1, 1));

    -- Expensive nested SELECTs
    SELECT COUNT(*) + SUM(ABS(MOD(LEVEL, 7)))
    INTO v_temp
    FROM dual
    CONNECT BY LEVEL <= 100;

    -- Simulate expensive string ops
    FOR i IN 1..10 LOOP
        v_dummy := REPLACE(v_dummy, CHR(65 + MOD(i, 26)), CHR(90 - MOD(i, 26)));
        v_temp := v_temp + LENGTH(REGEXP_REPLACE(v_dummy, '[^A-Z]', ''));
    END LOOP;

    -- Expensive selects
    FOR i IN 1..p_epoch LOOP
        DECLARE
            v_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_count
            FROM employees_test
            WHERE MOD(id, i + 1) = 0;
            v_temp := v_temp + v_count;
        END;
    END LOOP;

    -- More math for load
    v_temp := v_temp + ROUND(SQRT(v_salary) * POWER(v_department_id + 1, 2));
    v_temp := v_temp + LENGTH(TO_CHAR(SYSDATE, 'J')) + DBMS_RANDOM.VALUE(1, 999);

    -- Convert final number to letter A-F or S
    CASE MOD(v_temp, 7)
        WHEN 0 THEN v_char := 'A';
        WHEN 1 THEN v_char := 'B';
        WHEN 2 THEN v_char := 'C';
        WHEN 3 THEN v_char := 'D';
        WHEN 4 THEN v_char := 'E';
        WHEN 5 THEN v_char := 'F';
        ELSE    v_char := 'S';
    END CASE;

    RETURN v_char;
END;
/
