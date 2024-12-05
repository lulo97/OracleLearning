/* Formatted on 14-Sep-2024 16:29:12 (QP5 v5.336) */
--Logic operation

SET SERVEROUTPUT ON;

--CASE

DECLARE
    v_age   NUMBER := 44;
BEGIN
    CASE
        WHEN v_age < 18
        THEN
            DBMS_OUTPUT.put_line ('YOUNG');
        WHEN v_age > 18 AND v_age < 65
        THEN
            DBMS_OUTPUT.put_line ('MIDDLE AGE');
        ELSE
            DBMS_OUTPUT.put_line ('OLD');
    END CASE;
END;

--IF ELSE

DECLARE
    v_age   NUMBER := 10;
BEGIN
    IF v_age < 18
    THEN
        DBMS_OUTPUT.put_line ('YOUNG');
    ELSIF v_age < 65
    THEN
        DBMS_OUTPUT.put_line ('MIDDLE AGE');
    ELSE
        DBMS_OUTPUT.put_line ('OLD');
    END IF;
END;

--NVL

DECLARE
    v_age1    NUMBER;
    v_age2    NUMBER := 10;
    v_name1   VARCHAR2(100);  -- Must declaring size for VARCHAR2
    v_name2   VARCHAR2(100) := 'lulo';
BEGIN
    DBMS_OUTPUT.put_line (NVL (v_age1, 0));
    DBMS_OUTPUT.put_line (NVL (v_age2, 0));
    DBMS_OUTPUT.put_line (NVL (v_name1, 'Empty'));
    DBMS_OUTPUT.put_line (NVL (v_name2, 'Empty'));
END;

--COALESCE (return first non null value from a tuple)
DECLARE
    v_email    VARCHAR2(100) := 'lulo@gmail';
    v_phone  VARCHAR2(100);  
BEGIN
    DBMS_OUTPUT.put_line (COALESCE (v_phone, v_email, 'Age, name is both null'));
END;

--NULLIF(a: string, b: string) = NULL if a = b else a
DECLARE
    v_id1    VARCHAR2(100) := 'abc';
    v_id2    VARCHAR2(100) := 'abc';
    v_id3    VARCHAR2(100) := '123';  
BEGIN
    DBMS_OUTPUT.put_line (NULL); --No print if try to print only NULL
    DBMS_OUTPUT.put_line ('NULLIF: ' || NULLIF (v_id1, v_id2));
    DBMS_OUTPUT.put_line ('NULLIF: ' || NULLIF (v_id2, v_id3));
END;

--ALL, ANY
--Table users(id, username, age) have user with age 10, 20, 30

--Output: No row because 9 not larger than any in [10, 20, 30]
SELECT * 
FROM users
WHERE 9 > ANY (SELECT age FROM users);

--Output: All 3 row because 21 does larger then some (or one) element from [10, 20, 30] 
SELECT * 
FROM users
WHERE 21 > ANY (SELECT age FROM users);

--Output: No row because 29 is smaller than 30 which is not larger than all element from [10, 20, 30]
SELECT * 
FROM users
WHERE 29 > ALL (SELECT age FROM users);

--Output: All row of table because 31 does larger than 10 and 20 and 30
SELECT * 
FROM users
WHERE 31 > ALL (SELECT age FROM users);

--No row because:
/*
Row have age 10 not larger than all 10, 20, 30.
Row have age 20 not larger than all 10, 20, 30.
Row have age 30 not larger than all 10, 20, 30.
*/
SELECT * 
FROM users
WHERE age > ALL (SELECT age FROM users);

--No row
SELECT * 
FROM users
WHERE age < ALL (SELECT age FROM users);

--One row which is user age 30, because:
/*
Row have age 10 not >= than all 10, 20, 30.
Row have age 20 not >= than all 10, 20, 30.
Row have age 30 does >= than all 10, 20, 30.
*/
SELECT * 
FROM users
WHERE age >= ALL (SELECT age FROM users);

--One row which is user age 10, because:
/*
Row have age 10 does <= than all 10, 20, 30.
Row have age 20 not <= than all 10, 20, 30.
Row have age 30 not <= than all 10, 20, 30.
*/
SELECT * 
FROM users
WHERE age <= ALL (SELECT age FROM users);

--No row
SELECT * 
FROM users
WHERE age == ALL (SELECT age FROM users);

--No row
SELECT * 
FROM users
WHERE age <> ALL (SELECT age FROM users);

--///
--Output 2 row which is user age 20 and user age 30
/*
Row have age 10 not > any in 10, 20, 30.
Row have age 20 does > than 10 in 10, 20, 30.
Row have age 30 does > than 10 (and 20) in 10, 20, 30.
*/
SELECT * 
FROM users
WHERE age > ANY (SELECT age FROM users);

--Output 2 row which is user age 10 and user age 20
SELECT * 
FROM users
WHERE age < ANY (SELECT age FROM users);

--Output: all 3 row
SELECT * 
FROM users
WHERE age >= ANY (SELECT age FROM users);

--Output: all 3 row
SELECT * 
FROM users
WHERE age <= ANY (SELECT age FROM users);

--Output: all 3 row
SELECT * 
FROM users
WHERE age == ANY (SELECT age FROM users);

--Output: all 3 row
SELECT * 
FROM users
WHERE age <> ANY (SELECT age FROM users);




























