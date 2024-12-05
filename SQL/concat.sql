/* Formatted on 14-Sep-2024 21:16:18 (QP5 v5.336) */
--CONCAT(str1: string, str2: string): string
--Return: str1 + str2

SELECT CONCAT ('Hello', ' World') AS greeting FROM DUAL;


--Using || can result the same as concat

SELECT 'Hello' || ' ' || 'World' || '!' AS greeting FROM DUAL;

--Error with concat
SET SERVEROUTPUT ON;

--Note
/*
- Catch exception only work with runtime error (compile time must work first)
- Using EXECUTE IMMEDIATE (dynamic excute) to excute sql inside runtime (by pass compile error checking)
- Using ''myvar'' to put string inside sql string '...'
*/

--ORA-00909: invalid number of arguments
BEGIN
    EXECUTE IMMEDIATE 'SELECT CONCAT(''1'', ''2'', ''3'') FROM dual';
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line (SQLERRM);
END;

--ORA-06502: PL/SQL: numeric or value error: character string buffer too small
BEGIN
    EXECUTE IMMEDIATE 'DECLARE name VARCHAR2(5); BEGIN name := ''Hello'' || ''World''; END;';
EXCEPTION
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line (SQLERRM);
END;

--ORA-01489: result of string concatenation is too long
DECLARE
    v_str varchar2(200);
BEGIN
    --Runtime error
    SELECT CONCAT(RPAD('A', 4000, 'A'), 'B') INTO v_str FROM dual;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(SQLERRM);
END;









