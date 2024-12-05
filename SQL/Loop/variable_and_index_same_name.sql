--If declare name of a variable same as index name
--Then for loop will not affect that variable

DECLARE
    i   NUMBER := 5;
BEGIN
    FOR i IN 1 .. 3
    LOOP
        DBMS_OUTPUT.put_line ('Inside loop, i is ' || TO_CHAR (i));
    END LOOP;

    DBMS_OUTPUT.put_line ('Outside loop, i is ' || TO_CHAR (i)); --i=5, still the same when declare
END;

--Access variable name inside for loop in same name situation
--Using label block
<<my_block>>
DECLARE
    i   NUMBER := 5;
BEGIN
    FOR i IN 1 .. 3
    LOOP
        DBMS_OUTPUT.put_line ('local i='||i);
        DBMS_OUTPUT.put_line ('global i='||my_block.i);
    END LOOP;
END;