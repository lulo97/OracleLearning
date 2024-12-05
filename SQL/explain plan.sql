EXPLAIN PLAN FOR
SELECT *
FROM employees;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
Plan hash value: 1445457117
 
-------------------------------------------------------------------------------
| Id  | Operation         | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |           |     3 |    51 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| EMPLOYEES |     3 |    51 |     2   (0)| 00:00:01 |
-------------------------------------------------------------------------------
*/
