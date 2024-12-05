--Index variable don't need to be declare
--But access it outside will error
BEGIN
    FOR i IN 1 .. 3
    LOOP
        DBMS_OUTPUT.put_line ('Inside loop, i is ' || TO_CHAR (i));
    END LOOP;

    DBMS_OUTPUT.put_line ('Outside loop, i is ' || TO_CHAR (i));
END;