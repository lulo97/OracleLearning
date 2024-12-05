--CONTINUE WHEN condition = Continue if condition true
--EXIT WHEN condition = Exit if condition true

DECLARE
    i   NUMBER := 0;
BEGIN
    LOOP
        i := i + 1;

        CONTINUE WHEN i < 5;

        EXIT WHEN i = 10;

        DBMS_OUTPUT.put_line ('This code will run if i >= 5, i=' || i);
    END LOOP;

    DBMS_OUTPUT.put_line ('End loop, i=' || i);
END;