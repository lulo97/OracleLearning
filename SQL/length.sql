select length('12345') as len from dual;

select length(12345) as len from dual;

select length(NULL) as len from dual; --Return null

SELECT LENGTHB('O') AS num_bytes FROM dual; --Number of byte 

select lengthb(12345) as len from dual;

select lengthb(NULL) as len from dual; --Return null
