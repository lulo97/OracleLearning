/* Formatted on 20-Oct-2024 01:19:59 (QP5 v5.336) */
--Simple for loop

DECLARE
    i   NUMBER := 0;
BEGIN
    FOR i IN 1 .. 10
    LOOP
        DBMS_OUTPUT.put_line (i);
    END LOOP;
END;

--Reverse for loop

DECLARE
    i   NUMBER := 0;
BEGIN
    FOR i IN REVERSE 1 .. 10
    LOOP
        DBMS_OUTPUT.put_line (i);
    END LOOP;
END;

--Simulate step inside for loop

DECLARE
    i      NUMBER := 0;
    step   NUMBER := 3;
BEGIN
    FOR i IN 1 .. 10
    LOOP
        DBMS_OUTPUT.put_line (i * step);
    END LOOP;
END;