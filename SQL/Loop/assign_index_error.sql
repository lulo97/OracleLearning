/* Formatted on 20-Oct-2024 01:21:19 (QP5 v5.336) */
--Error for change index inside for loop

DECLARE
    i   NUMBER := 0;
BEGIN
    FOR i IN 1 .. 10
    LOOP
        i := i * 2; --PLS-00363: expression 'I' cannot be used as an assignment target
    END LOOP;
END;