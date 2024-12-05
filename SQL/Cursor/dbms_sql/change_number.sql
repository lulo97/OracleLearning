SET SERVEROUTPUT ON;
DECLARE
   cursor_handle INTEGER;
   rows_processed INTEGER;
   v_value NUMBER;
BEGIN
   -- Step 1: Open a cursor
   cursor_handle := DBMS_SQL.OPEN_CURSOR;
   dbms_output.put_line('cursor_handle: ' || cursor_handle);

   -- Step 2: Parse the SQL statement
   DBMS_SQL.PARSE(cursor_handle, 'SELECT 10 FROM dual', DBMS_SQL.NATIVE);
   dbms_output.put_line('SQL parsed with cursor_handle: ' || cursor_handle);

   -- Step 3: Execute the SQL statement
   rows_processed := DBMS_SQL.EXECUTE(cursor_handle);
   dbms_output.put_line('rows_processed: ' || rows_processed);

   -- Step 4: Define the return column (must match the number of columns in the select)
   -- If change 1 to 2 will error: ORA-01007: variable not in select list
   DBMS_SQL.DEFINE_COLUMN(cursor_handle, 1, v_value);

   -- Step 5: Fetch the row
   IF DBMS_SQL.FETCH_ROWS(cursor_handle) > 0 THEN
      -- Retrieve the value from the first column
      DBMS_SQL.COLUMN_VALUE(cursor_handle, 1, v_value);
      dbms_output.put_line('Fetched value: ' || v_value);
   END IF;

   -- Step 6: Close the cursor
   DBMS_SQL.CLOSE_CURSOR(cursor_handle);
   dbms_output.put_line('Cursor closed');
END;
/
