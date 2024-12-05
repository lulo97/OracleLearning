--Prove using CHAR is faster then VARCHAR2
--Test case: Insert 1000000 record of string 'A' in table using CHAR and another table using VARCHAR2

CREATE TABLE char_test (col1 CHAR(100));
CREATE TABLE varchar2_test (col1 VARCHAR2(100));

DECLARE
    v_start_time NUMBER;
    v_end_time NUMBER;
    v_char_value CHAR(100) := 'A';
    v_varchar_value VARCHAR2(100) := 'A';
BEGIN
    -- Insert into CHAR table
    v_start_time := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..100000 LOOP
        INSERT INTO char_test (col1) VALUES (v_char_value);
    END LOOP;
    COMMIT;
    v_end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Execution Time for CHAR: ' || (v_end_time - v_start_time) || ' centiseconds');

    -- Insert into VARCHAR2 table
    v_start_time := DBMS_UTILITY.GET_TIME;
    FOR i IN 1..100000 LOOP
        INSERT INTO varchar2_test (col1) VALUES (v_varchar_value);
    END LOOP;
    COMMIT;
    v_end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Execution Time for VARCHAR2: ' || (v_end_time - v_start_time) || ' centiseconds');
    
    -- Drop the tables after test
    EXECUTE IMMEDIATE 'DROP TABLE char_test';
    EXECUTE IMMEDIATE 'DROP TABLE varchar2_test';

    DBMS_OUTPUT.PUT_LINE('Tables dropped successfully.');
END;

/*
Execution Time for CHAR: 110 centiseconds
Execution Time for VARCHAR2: 308 centiseconds
Tables dropped successfully.
*/
