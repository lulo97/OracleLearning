DROP TABLE users;

CREATE TABLE users (
    id   NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age  NUMBER
);

set serveroutput on;

BEGIN
    FOR i IN 1..10 LOOP
            IF i = 5 THEN
                raise_application_error(-20001, 'Simulated error at i = 5');
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

            COMMIT;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;

SELECT
    *
FROM
    users;

/*
When i = 5 error raised, rollback and exit loop
Each step inside loop is committed so first 4 row still inserted

"ID","NAME","AGE"
1,"User 1",21
2,"User 2",22
3,"User 3",23
4,"User 4",24
*/