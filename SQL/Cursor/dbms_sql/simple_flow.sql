set serveroutput on;

DECLARE
    cursor_handle  INTEGER;
    rows_processed INTEGER;
BEGIN
    -- Step 1: Open a cursor
    -- cursor_handle now is a unique curser handle type integer, ex: 1206651651
    cursor_handle := dbms_sql.open_cursor;

    -- Step 2: Parse the SQL statement
    -- Parse SQL != Run SQL
    -- dbms_sql.native = 1 (integer type) is one of oracle SQL dialect (NATIVE, V6, V7)
    dbms_sql.parse(cursor_handle, 'select 10 from dual', dbms_sql.native);

    -- Step 3: Execute the SQL statement
    -- rows_processed = number of rows effected by sql when excute, ex: 0 meaning no row effected
    rows_processed := dbms_sql.execute(cursor_handle);

   -- Step 4: Close the cursor (release resource by cursor, cursor_handle = null now)
    dbms_sql.close_cursor(cursor_handle);
    dbms_output.put_line('cursor_handle' || cursor_handle);
END;
/