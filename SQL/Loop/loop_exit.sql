--While true and break = LOOP and EXIT
DECLARE
    i   NUMBER := 0;
BEGIN
    LOOP
        i := i + 1;

        IF i > 3
        THEN
            EXIT;
        END IF;
    END LOOP;

    DBMS_OUTPUT.put_line (x);
END;











