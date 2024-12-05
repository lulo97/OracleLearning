DECLARE
    -- Declare variables
    v_str VARCHAR2(100) := 'Hello World'; -- Note: Use VARCHAR2 instead of VARCHAR in Oracle

BEGIN
    -- Statements
    DBMS_OUTPUT.PUT_LINE(v_str); -- Output the value of the variable

EXCEPTION
    -- Handling exceptions
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM); -- Print the error message
END;
