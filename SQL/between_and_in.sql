--a BETWEEN b and c return TRUE if a inside [b, c] else return FALSE
SELECT CASE WHEN 5 BETWEEN 5 AND 15 THEN 1 ELSE 0 END AS low,
       CASE WHEN 10 BETWEEN 5 AND 15 THEN 1 ELSE 0 END AS mid,
       CASE WHEN 15 BETWEEN 5 AND 15 THEN 1 ELSE 0 END AS high
FROM DUAL;

--x in (x1, x2, x3..., xn) return TRUE if x = xi for i=1, 2,..., n else FALSE
SELECT CASE WHEN 10 IN (5, 10, 15) THEN 1 ELSE 0 END AS inresult FROM DUAL;

