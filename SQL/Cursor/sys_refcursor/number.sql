DECLARE
  cur SYS_REFCURSOR;
  v_number NUMBER;
BEGIN
  OPEN cur FOR SELECT 42 FROM dual;
  
  FETCH cur INTO v_number;
  DBMS_OUTPUT.PUT_LINE('Number: ' || v_number);
  
  CLOSE cur;
END;