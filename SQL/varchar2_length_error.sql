set serveroutput on;

--PLS-00215: String length constraints must be in range (1 .. 32767)
declare 
v_str varchar2(32768): = 'Hello World!';
begin
    dbms_output.PUT_LINE(v_str);
end;

--PLS-00215: String length constraints must be in range (1 .. 32767)
declare 
v_str varchar2(0) := '';
begin
    dbms_output.PUT_LINE(v_str);
end;

