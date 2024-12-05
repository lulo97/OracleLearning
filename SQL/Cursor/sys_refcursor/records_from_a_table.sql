DECLARE
  cur SYS_REFCURSOR;
  v_id      NUMBER;
  v_userid  NUMBER;
  v_name    VARCHAR2(100);
  v_complete CHAR(1);
BEGIN
  OPEN cur FOR
    SELECT id, userid, name, complete FROM todo;
  
  LOOP
    FETCH cur INTO v_id, v_userid, v_name, v_complete;
    EXIT WHEN cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Record: ' || v_id || ', ' || v_userid || ', ' || v_name || ', ' || v_complete);
  END LOOP;
  
  CLOSE cur;
END;
