/* Formatted on 20-Oct-2024 03:56:59 (QP5 v5.336) */
DECLARE
    num1         NUMBER := 1;
    num2         NUMBER := 2;
    num_result   NUMBER := 0;

    PROCEDURE add (num IN OUT NUMBER, amount NUMBER)
    IS
    BEGIN
        num := num + amount;
    END;
BEGIN
    add (num_result, num1);
    add (num_result, num2);
    DBMS_OUTPUT.put_line (num_result);                                     --3
END;