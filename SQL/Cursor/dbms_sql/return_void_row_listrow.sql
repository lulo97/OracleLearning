--CREATE OR REPLACE don't work on table
declare
   c int;
begin
   select count(*) into c from user_tables where table_name = upper('employees');
   if c = 1 then
      execute immediate 'drop table employees';
   end if;
end;

CREATE TABLE employees (
    emp_id   NUMBER(5) PRIMARY KEY,
    emp_name VARCHAR2(50),
    salary   NUMBER(7, 2)
);
INSERT INTO employees (emp_id, emp_name, salary)
VALUES (1, 'John Doe', 5000);
INSERT INTO employees (emp_id, emp_name, salary)
VALUES (2, 'Jane Smith', 6000);
INSERT INTO employees (emp_id, emp_name, salary)
VALUES (3, 'Emily Davis', 7000);

set serveroutput on;

--Usecase: Excute a simple CRUD sql dynamically
--Flow: Define SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.EXECUTE --> DBMS_SQL.CLOSE_CURSOR
DECLARE
    v_cursor  NUMBER;
    v_sql     VARCHAR2(200);
    rows_processed NUMBER;
BEGIN
    -- Dynamic SQL to insert a record
    v_sql := 'INSERT INTO employees (emp_id, emp_name, salary) VALUES (4, ''Alex Johnson'', 8000)';
    
    -- Open the cursor and execute the dynamic SQL
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
    
    --PLS-00221: 'EXECUTE' is not a procedure or is undefined
    --Fix: Don't run DBMS_SQL.EXECUTE() alone, assign it to a variable
    --DBMS_SQL.EXECUTE() return total number of rows effected
    rows_processed := DBMS_SQL.EXECUTE(v_cursor); 
    
    -- Close the cursor
    DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;

--Usecase: Fetch a row from table, when already know column name
--Flow: Define SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.DEFINE_COLUMN --> 
--DBMS_SQL.EXECUTE_AND_FETCH --> DBMS_SQL.COLUMN_VALUE --> DBMS_SQL.CLOSE_CURSOR
--COLUMN_VALUE(cursor, index, var) = Assign value of cursor by index to var
--Ex: cursor = ('lulo', 22, 'male') then cursor(1) = 'lulo' assigned to var
DECLARE
    v_cursor  NUMBER;
    v_sql     VARCHAR2(200);
    v_emp_id  NUMBER(5);
    v_emp_name VARCHAR2(50);
    v_salary  NUMBER(7, 2);
BEGIN
    v_sql := 'SELECT emp_id, emp_name, salary FROM employees WHERE emp_id = 4';
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
    
    -- Define columns to fetch
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 1, v_emp_id);
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 2, v_emp_name, 50);
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 3, v_salary);
    
    -- Execute and fetch the result
    IF DBMS_SQL.EXECUTE_AND_FETCH(v_cursor) > 0 THEN
        DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_emp_id);
        DBMS_SQL.COLUMN_VALUE(v_cursor, 2, v_emp_name);
        DBMS_SQL.COLUMN_VALUE(v_cursor, 3, v_salary);
        DBMS_OUTPUT.PUT_LINE(v_emp_name || ', ' || v_emp_id || ', ' || v_salary);
    END IF;

    DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;

/*
EXCUTE = SQL query that don't return value but effect rows in table
EXCUTE_AND_FETCH = SQL query that return value (which is rows), need to defined columns of row return
*/

--USECASE: Fetch mutiple rows from a table
--Flow: Defined SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.DEFINE_COLUMN --> DBMS_SQL.EXECUTE 
--> LOOP (DBMS_SQL.FETCH_ROWS --> DBMS_SQL.COLUMN_VALUE) --> DBMS_SQL.CLOSE_CURSOR(v_cursor)
DECLARE
    v_cursor     NUMBER;
    v_sql        VARCHAR2(200);
    v_emp_id     NUMBER(5);
    v_emp_name   VARCHAR2(50);
    v_salary     NUMBER(7, 2);
    rows_fetched NUMBER;
BEGIN
    v_sql := 'SELECT emp_id, emp_name, salary FROM employees';
    v_cursor := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);
    
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 1, v_emp_id);
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 2, v_emp_name, 50);
    DBMS_SQL.DEFINE_COLUMN(v_cursor, 3, v_salary);
    
    -- Execute the SQL
    rows_fetched := DBMS_SQL.EXECUTE(v_cursor);
    
    -- Fetch and process each row in a loop
    LOOP
        -- Fetch the next row
        IF DBMS_SQL.FETCH_ROWS(v_cursor) > 0 THEN
            DBMS_SQL.COLUMN_VALUE(v_cursor, 1, v_emp_id);
            DBMS_SQL.COLUMN_VALUE(v_cursor, 2, v_emp_name);
            DBMS_SQL.COLUMN_VALUE(v_cursor, 3, v_salary);
            DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp_name || ', ID: ' || v_emp_id || ', Salary: ' || v_salary);
        ELSE
            -- Exit the loop when no more rows are available
            EXIT;
        END IF;
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(v_cursor);
END;

--SUMARY
/*
DBMS_SQL = Excute sql dynamically

Basic flow: Defined SQL query --> Open cursor --> Excute sql --> Other process... --> Close cursor

Void SQL Query: Define SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.EXECUTE --> DBMS_SQL.CLOSE_CURSOR

Row SQL Query: Define SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.DEFINE_COLUMN --> 
                --> DBMS_SQL.EXECUTE_AND_FETCH --> DBMS_SQL.COLUMN_VALUE --> DBMS_SQL.CLOSE_CURSOR
                
Row[] SQL Query: Defined SQL --> DBMS_SQL.OPEN_CURSOR --> DBMS_SQL.PARSE --> DBMS_SQL.DEFINE_COLUMN --> DBMS_SQL.EXECUTE 
                --> LOOP (DBMS_SQL.FETCH_ROWS --> DBMS_SQL.COLUMN_VALUE) --> DBMS_SQL.CLOSE_CURSOR(v_cursor)  
*/






