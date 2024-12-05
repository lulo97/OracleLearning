DECLARE
    TYPE animal_type IS
        VARRAY(3) OF VARCHAR2(1000);
    animals animal_type := animal_type('Dog', 'Cat', 'Fish');
BEGIN
    FOR i IN 1..3 LOOP
        dbms_output.put_line(animals(i));
    END LOOP;
END;