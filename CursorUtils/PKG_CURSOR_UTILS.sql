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
    
    --Seperator
    c_seperator_column CONSTANT VARCHAR2(200) := '~#~';
    c_seperator_value CONSTANT VARCHAR2(200) := '~$~';
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

    FUNCTION fn_total_row (
        p_cursor IN out SYS_REFCURSOR
    ) RETURN INTEGER;

    FUNCTION fn_cursor_to_table (
        p_cursor           IN OUT SYS_REFCURSOR
    ) RETURN key_value_table;

    FUNCTION fn_get_row_value (
        p_row_string IN VARCHAR2,
        p_column_name IN VARCHAR2
    ) RETURN VARCHAR2;

--    procedure prc_handle_no_record_cursor(
--        p_cursor           IN OUT SYS_REFCURSOR
--    );

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
        
        IF l_query IS NULL THEN
            l_query := 'SELECT ';
            
            FOR i IN 1..l_total_column LOOP
                l_query := l_query || 'NULL AS ' || v_desc_tab(i).col_name || ',';
            END LOOP;
            
            l_query := RTRIM(l_query, ',');
            
            l_query := l_query || ' FROM DUAL WHERE 1 = 0';
        END IF;

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
        l_query         NCLOB;
    BEGIN

        -- Extract query from cursor
        prc_cursor_to_query(p_cursor, l_query);
        
--        if l_query is null then
--            prc_handle_no_record_cursor(p_cursor);
--            return;
--        end if;
        
        OPEN p_cursor FOR l_query;
    
        -- Convert SYS_REFCURSOR to DBMS_SQL cursor number (cursor will now invalid)
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
        
        -- Reopen cursor to preserve data
        OPEN p_cursor FOR l_query;

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
    
    FUNCTION fn_total_row (
        p_cursor IN out SYS_REFCURSOR
    ) RETURN INTEGER
    AS
        l_query      NCLOB;
        l_count_query VARCHAR2(32000);
        l_count      INTEGER;
    BEGIN
        
        prc_cursor_to_query(p_cursor, l_query);
                
--        if l_query is null then
--            prc_handle_no_record_cursor(p_cursor);
--            return 0;
--        end if;
        
        l_count_query := 'SELECT COUNT(*) FROM (' || l_query || ')';
                        
        EXECUTE IMMEDIATE l_count_query INTO l_count;
        
        open p_cursor for l_query;
        
        RETURN l_count;
    END;

    FUNCTION fn_cursor_to_table (
        p_cursor           IN OUT SYS_REFCURSOR
    ) RETURN key_value_table IS
    
        -- Declare variables
        l_query nclob;
        l_current_row   NCLOB := '';
        l_table         key_value_table := key_value_table();
        l_cursor_number INTEGER;
        l_total_column  INTEGER;
        v_desc_tab      dbms_sql.desc_tab;
        l_column_value  VARCHAR2(32000);
    BEGIN
        prc_cursor_to_query(p_cursor, l_query);
    
--        if l_query is null then
--            prc_handle_no_record_cursor(p_cursor);
--            return l_table;
--        end if;
    
        OPEN p_cursor FOR l_query;
    
        l_cursor_number := dbms_sql.to_cursor_number(p_cursor);
    
        dbms_sql.describe_columns(l_cursor_number, l_total_column, v_desc_tab);
    
        FOR i IN 1..l_total_column LOOP
            dbms_sql.define_column(l_cursor_number, i, l_column_value, 32000);
        END LOOP;
    
        -- Fetch rows and build key_value_table
        WHILE dbms_sql.fetch_rows(l_cursor_number) > 0 LOOP
            l_table.extend;
            l_current_row := '';
            FOR i IN 1..l_total_column LOOP
                dbms_sql.column_value(l_cursor_number, i, l_column_value);
    
                -- Append name~$~value~#~ to string
                l_current_row := l_current_row
                                 || CASE WHEN i > 1 THEN c_seperator_column ELSE '' END
                                 || v_desc_tab(i).col_name
                                 || c_seperator_value
                                 || l_column_value;
    
            END LOOP;
    
            -- Add the current row to the key_value_table
            l_table(l_table.count) := key_value_obj(key => to_char(l_table.count), value => l_current_row);
    
        END LOOP;
    
        dbms_sql.close_cursor(l_cursor_number);
    
        OPEN p_cursor FOR l_query;
    
        -- Return the key_value_table
        RETURN l_table;
    END;

    FUNCTION fn_get_row_value (
        p_row_string IN VARCHAR2,
        p_column_name IN VARCHAR2
    ) RETURN VARCHAR2 IS
        l_pairs      VARCHAR2(4000);   -- To hold each pair in the string
        l_key        VARCHAR2(1000);
        l_val        VARCHAR2(4000);
        l_result     VARCHAR2(4000);
        l_idx        PLS_INTEGER;
        l_pair_idx   PLS_INTEGER;
        l_next_idx   PLS_INTEGER;
    BEGIN
        l_result := NULL;
    
        l_pair_idx := 1;
        LOOP
            -- Find the position of the next separator ~#~
            l_next_idx := INSTR(p_row_string, c_seperator_column, l_pair_idx);
    
            -- If no more separator found, handle the last pair
            IF l_next_idx = 0 THEN
                l_pairs := SUBSTR(p_row_string, l_pair_idx);
            ELSE
                l_pairs := SUBSTR(p_row_string, l_pair_idx, l_next_idx - l_pair_idx);
            END IF;
    
            -- Find the separator for key-value (~$~)
            l_idx := INSTR(l_pairs, c_seperator_value);
    
            IF l_idx > 0 THEN
                l_key := SUBSTR(l_pairs, 1, l_idx - 1);   -- Extract key
                l_val := SUBSTR(l_pairs, l_idx + LENGTH(c_seperator_value));  -- Extract value
    
                -- If the key matches the requested column name, return the value
                IF upper(l_key) = upper(p_column_name) THEN
                    RETURN l_val;
                END IF;
            END IF;
    
            -- Move to the next pair
            IF l_next_idx = 0 THEN
                EXIT;  -- No more pairs
            ELSE
                l_pair_idx := l_next_idx + LENGTH(c_seperator_column);  -- Move past the separator
            END IF;
        END LOOP;
    
        RETURN NULL;
    END;
    
--    PROCEDURE prc_handle_no_record_cursor(
--        p_cursor IN OUT SYS_REFCURSOR
--    ) AS 
--    BEGIN
--        dbms_output.put_line('Cursor has no records');
--    
--        IF p_cursor%ISOPEN THEN
--            CLOSE p_cursor;
--            p_cursor := NULL;
--        END IF;
--    
--        OPEN p_cursor FOR SELECT * FROM dual WHERE 1 = 0; 
--    
--    END prc_handle_no_record_cursor;

    
END pkg_cursor_utils;
/
