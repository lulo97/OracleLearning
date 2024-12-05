-- Define the object type
CREATE OR REPLACE TYPE my_object AS OBJECT (
  a NUMBER,
  b VARCHAR2(100),
  c DATE
);
/

-- PL/SQL block
DECLARE
  cur SYS_REFCURSOR;
  obj my_object;
BEGIN
  -- Return an object
  OPEN cur FOR
    SELECT my_object(1, 'Sample', SYSDATE) FROM dual;
  
  FETCH cur INTO obj;
  DBMS_OUTPUT.PUT_LINE('Object: a=' || obj.a || ', b=' || obj.b || ', c=' || TO_CHAR(obj.c, 'YYYY-MM-DD'));
  --Output: Object: a=1, b=Sample, c=2024-09-19

  CLOSE cur;
END;
