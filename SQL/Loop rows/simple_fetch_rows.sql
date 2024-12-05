CREATE TABLE customers
(
    id      NUMBER PRIMARY KEY,
    name    VARCHAR2 (1000),
    age     NUMBER
);

INSERT INTO customers (id, name, age)
VALUES (1, 'lulo', 10);

INSERT INTO customers (id, name, age)
VALUES (2, 'Alice Smith', 25);

INSERT INTO customers (id, name, age)
VALUES (3, 'Bob Johnson', 30);

--For loop to access rows from a table

DECLARE
    v_row      customers%ROWTYPE;
    v_cursor   SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR SELECT * FROM customers;

    FOR i IN 1 .. 10
    LOOP
        FETCH v_cursor   INTO v_row;
        EXIT WHEN v_cursor%NOTFOUND;
        
        --Process data
        DBMS_OUTPUT.put_line ('Id=' || v_row.id);
    END LOOP;
END;


DROP TABLE customers;