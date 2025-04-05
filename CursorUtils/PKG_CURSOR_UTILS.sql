CREATE OR REPLACE PACKAGE pkg_cursor_utils IS

    -- Constants for Oracle column types
    c_type_varchar2 CONSTANT PLS_INTEGER := 1;
    c_type_number CONSTANT PLS_INTEGER := 2;
    c_type_date CONSTANT PLS_INTEGER := 12;
    c_type_clob CONSTANT PLS_INTEGER := 112;
    c_type_timestamp CONSTANT PLS_INTEGER := 180;
    
    -- Date format
    c_date_format CONSTANT VARCHAR2(200) := 'DD-MM-YYYY';
    c_timestamp_format CONSTANT VARCHAR2(200) := 'DD-MON-YY HH.MI.SS.FF AM';
    --
    PROCEDURE prc_cursor_to_query (
        p_cursor    IN OUT SYS_REFCURSOR,
        p_sql_query OUT NCLOB
    );

    PROCEDURE prc_print (
        p_cursor IN OUT SYS_REFCURSOR
    );

    FUNCTION fn_format_column_value (
        p_value    VARCHAR2,
        p_col_name VARCHAR2,
        p_col_type PLS_INTEGER
    ) RETURN VARCHAR2;

END pkg_cursor_utils;
/


CREATE OR REPLACE PACKAGE BODY pkg_cursor_utils IS

    PROCEDURE prc_cursor_to_query (
        p_cursor    IN OUT SYS_REFCURSOR,
        p_sql_query OUT NCLOB
    ) AS

        l_cursor_number   INTEGER;
        l_total_column    INTEGER;
        v_desc_tab        dbms_sql.desc_tab;
        l_column_value    VARCHAR2(32000);
        l_query           NCLOB := '';
        l_current_row_idx INTEGER := 0;
    BEGIN
    -- Convert ref cursor to DBMS_SQL cursor number
        l_cursor_number := dbms_sql.to_cursor_number(p_cursor);

    -- Describe the columns in the cursor
        dbms_sql.describe_columns(l_cursor_number, l_total_column, v_desc_tab);

    -- Define columns for each column in the result set
        FOR i IN 1..l_total_column LOOP
            dbms_sql.define_column(l_cursor_number, i, l_column_value, 32000);
        END LOOP;

    -- Fetch and build the SELECT statements
        WHILE dbms_sql.fetch_rows(l_cursor_number) > 0 LOOP
            IF l_current_row_idx <> 0 THEN
                l_query := l_query || ' UNION ALL ';
            END IF;
            l_query := l_query || 'SELECT ';
            FOR i IN 1..l_total_column LOOP
                dbms_sql.column_value(l_cursor_number, i, l_column_value);
                IF i > 1 THEN
                    l_query := l_query || ', ';
                END IF;
                
                -- Detect column type and format accordingly
                l_query := l_query
                           || fn_format_column_value(l_column_value, v_desc_tab(i).col_name, v_desc_tab(i).col_type);

            END LOOP;

            l_query := l_query || ' FROM dual';
            l_current_row_idx := l_current_row_idx + 1;
        END LOOP;

    -- Return the constructed query
        p_sql_query := l_query;

    -- Close the cursor
        dbms_sql.close_cursor(l_cursor_number);
    EXCEPTION
        WHEN OTHERS THEN
            IF dbms_sql.is_open(l_cursor_number) THEN
                dbms_sql.close_cursor(l_cursor_number);
            END IF;
            RAISE;
    END;

    PROCEDURE prc_print (
        p_cursor IN OUT SYS_REFCURSOR
    ) AS

        l_cursor_number INTEGER;
        l_total_column  INTEGER;
        v_desc_tab      dbms_sql.desc_tab;
        l_column_value  VARCHAR2(32000); --Using varchar2 to work with any kind of data when do DBMS_SQL.DEFINE_COLUMN
        l_row_line      NCLOB;
        l_header_line   NCLOB;
    BEGIN
    -- Convert SYS_REFCURSOR to DBMS_SQL cursor number
        l_cursor_number := dbms_sql.to_cursor_number(p_cursor);

    -- Get column metadata
        dbms_sql.describe_columns(l_cursor_number, l_total_column, v_desc_tab);

    -- Define each column
        FOR i IN 1..l_total_column LOOP
            dbms_sql.define_column(l_cursor_number, i, l_column_value, 4000);
        END LOOP;

    -- Build and print the header line
        FOR i IN 1..l_total_column LOOP
            IF i > 1 THEN
                l_header_line := l_header_line || ', ';
            END IF;
            l_header_line := l_header_line || v_desc_tab(i).col_name;
        END LOOP;

        dbms_output.put_line(l_header_line);
            
    -- Loop over all rows and print
        WHILE dbms_sql.fetch_rows(l_cursor_number) > 0 LOOP
            l_row_line := '';
            FOR i IN 1..l_total_column LOOP
                dbms_sql.column_value(l_cursor_number, i, l_column_value);
                IF i > 1 THEN
                    l_row_line := l_row_line || ', ';
                END IF;

            -- Format value: quote strings, print numbers as-is
                l_row_line := l_row_line || l_column_value;
            END LOOP;

            dbms_output.put_line(l_row_line);
        END LOOP;

    -- Close cursor
        dbms_sql.close_cursor(l_cursor_number);
    EXCEPTION
        WHEN OTHERS THEN
            IF dbms_sql.is_open(l_cursor_number) THEN
                dbms_sql.close_cursor(l_cursor_number);
            END IF;
            RAISE;
    END;

    FUNCTION fn_format_column_value (
        p_value    VARCHAR2,
        p_col_name VARCHAR2,
        p_col_type PLS_INTEGER
    ) RETURN VARCHAR2 IS
    BEGIN
        CASE p_col_type
            WHEN c_type_number THEN
                RETURN 'TO_NUMBER('''
                       || replace(p_value, '''', '''''')
                       || ''') AS '
                       || p_col_name;
            WHEN c_type_date THEN
                RETURN 'TO_DATE('''
                       || replace(p_value, '''', '''''')
                       || ''', '''
                       || c_date_format
                       || ''') AS '
                       || p_col_name;
            WHEN c_type_timestamp THEN
                RETURN 'TO_TIMESTAMP('''
                       || replace(p_value, '''', '''''')
                       || ''', '''
                       || c_timestamp_format
                       || ''') AS '
                       || p_col_name;
            WHEN c_type_clob THEN
                RETURN 'TO_CLOB('''
                       || replace(p_value, '''', '''''')
                       || ''') AS '
                       || p_col_name;
            ELSE  -- VARCHAR2 and others
                RETURN ''''
                       || replace(p_value, '''', '''''')
                       || ''' AS '
                       || p_col_name;
        END CASE;
    END;

END pkg_cursor_utils;
/
