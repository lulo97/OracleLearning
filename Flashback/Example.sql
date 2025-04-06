create table tbl_flashback_test(
    id number primary key,
    name varchar2(200)
);

truncate table tbl_flashback_test;

insert into tbl_flashback_test (id, name) values (1, 'A');
insert into tbl_flashback_test (id, name) values (2, 'B');
insert into tbl_flashback_test (id, name) values (3, 'C');

select * from tbl_flashback_test;
--1	A
--2	B
--3	C

update tbl_flashback_test set name = 'D';
--1	D
--2	D
--3	D

SELECT * FROM tbl_flashback_test
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' second);
--1	A
--2	B
--3	C

SELECT value FROM v$parameter WHERE name = 'undo_retention';
--900 second maximun for flashback
