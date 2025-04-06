SET SERVEROUTPUT ON
DECLARE
    v_start     INTEGER;
    v_end       INTEGER;
    v_elapsed   INTEGER;
    v_total1    INTEGER := 0;
    v_total2    INTEGER := 0;
    v_dummy     employees_test%ROWTYPE;

    CURSOR c1 IS
        SELECT * FROM (SELECT * FROM employees_test WHERE id < 20) e
        WHERE fn_get_employee_type(e.id, 2) = 'A'
          AND fn_get_employee_type(e.id, 5) = 'A';

    CURSOR c2 IS
        SELECT * FROM (SELECT * FROM employees_test WHERE id < 20) e
        WHERE fn_get_employee_type(e.id, 5) = 'A'
          AND fn_get_employee_type(e.id, 2) = 'A';
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Query 1: fn(id,2) then fn(id,5) ---');
    FOR i IN 1..5 LOOP
        v_start := DBMS_UTILITY.GET_TIME;

        FOR rec IN c1 LOOP
            NULL; -- simulate processing each row
        END LOOP;

        v_end := DBMS_UTILITY.GET_TIME;
        v_elapsed := v_end - v_start;
        v_total1 := v_total1 + v_elapsed;

        DBMS_OUTPUT.PUT_LINE('Run ' || i || ': ' || (v_elapsed / 100.0) || ' seconds');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Average Time (Query 1): ' || (v_total1 / 5.0 / 100) || ' seconds');

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Query 2: fn(id,5) then fn(id,2) ---');
    FOR i IN 1..5 LOOP
        v_start := DBMS_UTILITY.GET_TIME;

        FOR rec IN c2 LOOP
            NULL;
        END LOOP;

        v_end := DBMS_UTILITY.GET_TIME;
        v_elapsed := v_end - v_start;
        v_total2 := v_total2 + v_elapsed;

        DBMS_OUTPUT.PUT_LINE('Run ' || i || ': ' || (v_elapsed / 100.0) || ' seconds');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Average Time (Query 2): ' || (v_total2 / 5.0 / 100) || ' seconds');
END;
/



---------------------OUTPUT--------------------
--- Query 1: fn(id,2) then fn(id,5) ---
Run 1: 5.79 seconds
Run 2: 5.64 seconds
Run 3: 6.4 seconds
Run 4: 5.88 seconds
Run 5: 6.94 seconds
Average Time (Query 1): 6.13 seconds

--- Query 2: fn(id,5) then fn(id,2) ---
Run 1: 13.29 seconds
Run 2: 12.41 seconds
Run 3: 12.42 seconds
Run 4: 12.39 seconds
Run 5: 12.31 seconds
Average Time (Query 2): 12.564 seconds
