-- Creating the user table
CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
);

-- Creating the todos table
CREATE TABLE todos (
    id NUMBER PRIMARY KEY,
    userid NUMBER,
    name VARCHAR2(100),
    complete NUMBER(1) -- 1 for complete, 0 for incomplete
);

-- Inserting into user table
INSERT INTO users (id, name) VALUES (1, 'John Doe');
INSERT INTO users (id, name) VALUES (2, 'Jane Smith');

-- Inserting into todos table
INSERT INTO todos (id, userid, name, complete) VALUES (1, 1, 'Task 1', 0);
INSERT INTO todos (id, userid, name, complete) VALUES (2, 1, 'Task 2', 1);
INSERT INTO todos (id, userid, name, complete) VALUES (3, 2, 'Task 3', 1);
INSERT INTO todos (id, userid, name, complete) VALUES (4, 2, 'Task 4', 0);

CREATE OR REPLACE PROCEDURE get_todos_by_user (
    p_userid IN NUMBER,
    p_todos_cursor IN OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_todos_cursor FOR
        SELECT t.id, t.name, t.complete
        FROM todos t
        WHERE t.userid = p_userid;
END;

SET SERVEROUTPUT ON;

DECLARE
    v_userid NUMBER := 1; -- The user ID you want to query
    v_todos_cursor SYS_REFCURSOR;
    v_todo_id NUMBER;
    v_todo_name VARCHAR2(100);
    v_complete NUMBER;
BEGIN
    -- Call the procedure
    get_todos_by_user(v_userid, v_todos_cursor);
    
    -- Fetch and display the results
    LOOP
        FETCH v_todos_cursor INTO v_todo_id, v_todo_name, v_complete;
        EXIT WHEN v_todos_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Todo ID: ' || v_todo_id || ', Name: ' || v_todo_name || ', Complete: ' || v_complete);
    END LOOP;
    
    -- Close the cursor
    CLOSE v_todos_cursor;
END;

CREATE OR REPLACE PACKAGE types_pkg IS
    TYPE todos_ref_cursor IS REF CURSOR;
END types_pkg;

CREATE OR REPLACE PROCEDURE get_todos_by_user_ref_cursor (
    p_userid IN NUMBER,
    p_todos_cursor IN OUT types_pkg.todos_ref_cursor
) AS
BEGIN
    OPEN p_todos_cursor FOR
        SELECT t.id, t.name, t.complete
        FROM todos t
        WHERE t.userid = p_userid;
END;

DECLARE
    v_userid NUMBER := 1; -- The user ID you want to query
    v_todo_id NUMBER;
    v_todo_name VARCHAR2(100);
    v_complete NUMBER;
    v_todos_cursor types_pkg.todos_ref_cursor; -- Use the REF CURSOR type defined in the package
BEGIN
    -- Call the procedure
    get_todos_by_user_ref_cursor(v_userid, v_todos_cursor);
    
    -- Fetch and display the results
    LOOP
        FETCH v_todos_cursor INTO v_todo_id, v_todo_name, v_complete;
        EXIT WHEN v_todos_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Todo ID: ' || v_todo_id || ', Name: ' || v_todo_name || ', Complete: ' || v_complete);
    END LOOP;
    
    -- Close the cursor
    CLOSE v_todos_cursor;
END;












