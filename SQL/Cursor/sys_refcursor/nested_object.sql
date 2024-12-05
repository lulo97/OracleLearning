-- Define a nested object type
CREATE OR REPLACE TYPE nested_obj AS OBJECT (
  a NUMBER,
  b num_list  -- List of numbers
);
/

-- PL/SQL block
DECLARE
  cur SYS_REFCURSOR;
  obj nested_obj;
BEGIN
  -- Return a nested object
  OPEN cur FOR
    SELECT nested_obj(1, num_list(1, 2, 3)) FROM dual;
  
  FETCH cur INTO obj;
  
  -- Output the nested object
  DBMS_OUTPUT.PUT_LINE('Nested object: a=' || obj.a);
  
  -- Output the list within the object
  FOR i IN 1..obj.b.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('List item in object: ' || obj.b(i));
  END LOOP;
  
  CLOSE cur;
END;
/
