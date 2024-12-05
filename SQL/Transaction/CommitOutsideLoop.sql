DROP TABLE users;

CREATE TABLE users (
    id   NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age  NUMBER
);

set serveroutput on;

BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        IF i = 7 THEN
            raise_application_error(-20001, 'Simulated error at i = 7');
        END IF;
        INSERT INTO users (
            id,
            name,
            age
        ) VALUES (
            i,
            'User ' || i,
            20 + i
        );

    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;

SELECT
    *
FROM
    users;

/*
When i = 7 error raised, rollback, exit loop
Commit is outside loop so all 7 row inserted is gone
*/