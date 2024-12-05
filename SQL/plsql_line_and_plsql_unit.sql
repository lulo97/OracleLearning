--$$PLSQL_LINE = Current line in pl/sql block
--global line 2
--global line 3
BEGIN --block line 1
    --block line 2
    DBMS_OUTPUT.PUT_LINE($$PLSQL_LINE); --block line 3
    --block line 4
    --block line 5
    DBMS_OUTPUT.PUT_LINE($$PLSQL_LINE); --block line 5
    --global line 10
END;

--$$PLSQL_UNIT = Current unit name (procedure name...)
CREATE OR REPLACE PROCEDURE debug_test IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('In procedure: ' || $$PLSQL_UNIT);
    DBMS_OUTPUT.PUT_LINE('At line: ' || $$PLSQL_LINE);
    -- some more code
    DBMS_OUTPUT.PUT_LINE('At another line: ' || $$PLSQL_LINE);
END;

begin
debug_test();
end;

drop procedure debug_test; 

















