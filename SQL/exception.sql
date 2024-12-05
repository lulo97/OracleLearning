/* Formatted on 14-Sep-2024 18:41:09 (QP5 v5.336) */
--Exception
DECLARE
    v_name   VARCHAR (200);
    p_id     VARCHAR2 (200) := '9';
    p_age    NUMBER := 30;
BEGIN
    /*    --Trigger NO_DATA_FOUND
        SELECT username
        INTO v_name
        FROM users
        WHERE id = p_id;

        --Trigger TOO_MANY_ROWS
        SELECT username
        INTO v_name
        FROM users
        WHERE age = p_age;*/

    --Trigger OTHERS
    p_age := p_age / 0;

    -- If no error occur
    DBMS_OUTPUT.put_line ('Success!');
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.put_line ('No user found!');
    WHEN TOO_MANY_ROWS
    THEN
        DBMS_OUTPUT.put_line ('More than one user found!');
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line ('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.put_line ('Error Message: ' || SQLERRM);
        DBMS_OUTPUT.put_line (
            'format_error_backtrace: ' || DBMS_UTILITY.format_error_backtrace);
        DBMS_OUTPUT.put_line (
            'format_error_stack: ' || DBMS_UTILITY.format_error_stack);
END;

/*
Best practise:
- Don't over user WHEN OTHERS
- Wrap each statement with catch exception (maybe make code longer)
- Create a error table to store error

Error Code: -1476
Error Message: ORA-01476: divisor is equal to zero

Error ORA-06512 is not an actually error, it come with DBMS_UTILITY.format_error_backtrace for showing line number error occur

The line number error occur does not depend on total line of file but depend on first line of pl/sql block
Example: DECLARE is on line 999 of file but DBMS_UTILITY.format_error_backtrace show error line is 19 (which is 19+999 in file and 19 count from DECLARE))
*/