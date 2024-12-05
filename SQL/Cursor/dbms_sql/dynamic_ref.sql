DECLARE
    v_userid NUMBER := 1; -- The user ID you want to query
    v_todos_cursor SYS_REFCURSOR;
    v_column_count INTEGER;
    v_column_value VARCHAR2(4000);
    v_desc_t DBMS_SQL.DESC_TAB;
    v_cursor_id INTEGER;
    v_col_num INTEGER;
BEGIN
    -- Call the procedure to get the cursor
    get_todos_by_user(v_userid, v_todos_cursor);

    -- Convert REF CURSOR to DBMS_SQL cursor
    v_cursor_id := DBMS_SQL.TO_CURSOR_NUMBER(v_todos_cursor);

    -- Describe the columns of the result set
    DBMS_SQL.DESCRIBE_COLUMNS(v_cursor_id, v_column_count, v_desc_t);

    -- Print column headers
    FOR i IN 1..v_column_count LOOP
        DBMS_OUTPUT.PUT(v_desc_t(i).col_name || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    -- Define columns for the result set
    FOR i IN 1..v_column_count LOOP
        DBMS_SQL.DEFINE_COLUMN(v_cursor_id, i, v_column_value, 4000);
    END LOOP;

    -- Fetch each row and print values dynamically
    WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP
        FOR i IN 1..v_column_count LOOP
            DBMS_SQL.COLUMN_VALUE(v_cursor_id, i, v_column_value);
            DBMS_OUTPUT.PUT(v_column_value || ' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

    -- Close the cursor
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
END;