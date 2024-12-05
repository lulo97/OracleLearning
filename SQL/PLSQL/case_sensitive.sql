--In pl/sql, variable name is not case sensitive
--abc = aBc = ABC
DECLARE
  abc varchar2(10) := 'hello';
BEGIN
  DBMS_Output.Put_Line(aBc);
END;

--Using double quote to active case sensitive
--"abc" <> "aBc"
DECLARE
  "abc" varchar2(10) := 'abc';
  "aBc" varchar2(10) := 'aBc';
BEGIN
  DBMS_Output.Put_Line("abc");
  DBMS_Output.Put_Line("aBc");
END;
