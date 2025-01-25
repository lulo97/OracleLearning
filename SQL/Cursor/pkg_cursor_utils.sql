CREATE OR REPLACE 
PACKAGE pkg_cursor_utils
/* Formatted on 25-Jan-2025 19:05:39 (QP5 v5.336) */
AS
    pi   NUMBER := 0;

    FUNCTION fn_get_column_names (p_cursor_id NUMBER)
        RETURN VARCHAR2;

    FUNCTION fn_cursor_to_json (p_cursor_id NUMBER)
        RETURN VARCHAR2;
END pkg_cursor_utils;
/


CREATE OR REPLACE 
PACKAGE BODY pkg_cursor_utils
/* Formatted on 25-Jan-2025 19:09:32 (QP5 v5.336) */
AS
    FUNCTION fn_get_column_names (p_cursor_id NUMBER)
        RETURN VARCHAR2
    IS
        l_output      NCLOB;
        l_col_count   NUMBER;
        l_col_desc    DBMS_SQL.desc_tab;
    BEGIN
        DBMS_SQL.describe_columns (p_cursor_id, l_col_count, l_col_desc);

        FOR i IN 1 .. l_col_count
        LOOP
            l_output := l_output || l_col_desc (i).col_name || ',';
        END LOOP;

        l_output := SUBSTR (l_output, 1, LENGTH (l_output) - 1);

        RETURN TO_CHAR (l_output);
    END;

    FUNCTION fn_cursor_to_json (p_cursor_id NUMBER)
        RETURN VARCHAR2
    IS
        l_output        NCLOB;
        l_col_count     NUMBER;
        l_col_desc      DBMS_SQL.desc_tab;
        l_col_value     VARCHAR2 (32767);
        l_current_row   NCLOB;
    BEGIN
        DBMS_SQL.describe_columns (p_cursor_id, l_col_count, l_col_desc);

        FOR i IN 1 .. l_col_count
        LOOP
            DBMS_SQL.define_column (p_cursor_id,
                                    i,
                                    l_col_value,
                                    4000);
        END LOOP;

        l_output := '[';

        WHILE DBMS_SQL.fetch_rows (p_cursor_id) > 0
        LOOP
            l_current_row := '{';

            FOR i IN 1 .. l_col_count
            LOOP
                DBMS_SQL.COLUMN_VALUE (p_cursor_id, i, l_col_value);
                l_current_row :=
                       l_current_row
                    || '"'
                    || l_col_desc (i).col_name
                    || '":"'
                    || l_col_value
                    || '",';
            END LOOP;

            l_current_row := RTRIM (l_current_row, ',') || '}';

            l_output := l_output || l_current_row || ',';
        END LOOP;

        IF LENGTH (l_output) > 1
        THEN
            l_output := RTRIM (l_output, ',') || ']';
        ELSE
            l_output := '[]';
        END IF;

        RETURN l_output;
    END;
END pkg_cursor_utils;
/

