CREATE TABLE employees (
    id         NUMBER PRIMARY KEY,
    name       VARCHAR2(200 BYTE),
    salary     NUMBER(10, 2),
    hired_date DATE,
    birthdate  DATE,
    address    CLOB,
    joined_at  TIMESTAMP(6)
);

Insert into EMPLOYEES (ID,NAME,SALARY,HIRED_DATE,BIRTHDATE,ADDRESS,JOINED_AT) values (1,'John Doe',50000,to_date('01-MAR-22','DD-MON-RR'),to_date('15-JUN-90','DD-MON-RR'),'1234 Elm Street, City, Country',to_timestamp('05-APR-25 04.49.04.033000000 PM','DD-MON-RR HH.MI.SSXFF AM'));
Insert into EMPLOYEES (ID,NAME,SALARY,HIRED_DATE,BIRTHDATE,ADDRESS,JOINED_AT) values (2,'Jane Smith',60000,to_date('15-JUL-21','DD-MON-RR'),to_date('22-NOV-85','DD-MON-RR'),'5678 Oak Avenue, City, Country',to_timestamp('05-APR-25 04.49.04.062000000 PM','DD-MON-RR HH.MI.SSXFF AM'));
Insert into EMPLOYEES (ID,NAME,SALARY,HIRED_DATE,BIRTHDATE,ADDRESS,JOINED_AT) values (3,'Alice Johnson',55000,to_date('10-SEP-20','DD-MON-RR'),to_date('05-JAN-92','DD-MON-RR'),'9101 Pine Road, City, Country',to_timestamp('05-APR-25 04.49.04.076000000 PM','DD-MON-RR HH.MI.SSXFF AM'));
