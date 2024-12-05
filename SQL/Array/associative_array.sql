--Make a key-value list
--Example: {name: population}[] with name VARCHAR2 and population NUMBER

DECLARE
    TYPE city_type IS TABLE OF NUMBER
        INDEX BY VARCHAR2 (64);

    citys   city_type;
    name    VARCHAR2 (64);
    idx     VARCHAR (64);
BEGIN
    --Set name=Smallville, population = 2000
    citys ('Smallville') := 2000;

    --Setting more elements
    citys ('Midland') := 750000;
    citys ('Megalopolis') := 1000000;


    --Print list
    idx := citys.FIRST;   
    WHILE idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.put_line ('Population of ' || idx || ' is ' || citys (idx));
        idx := citys.NEXT (idx);                
    END LOOP;
END;