declare
v_char char(10) := 'abc   '; --3 empty character in the end
v_varchar2 varchar2(10) := 'abc   '; --3 empty character in the end
begin

DBMS_OUTPUT.PUT_LINE('*' || v_char || '*');
DBMS_OUTPUT.PUT_LINE('*' || v_varchar2 || '*');

end;

/*

CHAR type left padding with empty character to match declared length (10)
So information about 3 empty character in the end will be lose
*abc       *

Usecase: 
- Country code: EN, VN, US...
- Language code: en, vi, ja...
- Identify code: fixed 12 length character 
- Gender code: M, F
- Boolean: 1, 0 or Y, N or T, F
 

VARCHAR2 don't do padding or trimming
*abc   *

Usecase:
- Name, Address, Email...

*/