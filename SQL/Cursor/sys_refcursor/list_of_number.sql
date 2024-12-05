-- Define a collection type (run this first - do not run all at the same time)
CREATE OR REPLACE TYPE num_list IS
    TABLE OF NUMBER;

-- PL/SQL block (run this after - do not run all at the same time)
DECLARE
    cur  SYS_REFCURSOR;
    nums num_list;
BEGIN
  -- Return a list of numbers
    OPEN cur FOR SELECT
                     num_list(1, 2, 3, 4)
                 FROM
                     dual;

    FETCH cur INTO nums;
  
  -- Display each element in the list
    FOR i IN 1..nums.count LOOP
        dbms_output.put_line('List item: ' || nums(i));
    END LOOP;

    CLOSE cur;
END;