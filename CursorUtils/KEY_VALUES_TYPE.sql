create or replace TYPE key_value_obj AS OBJECT (
  key   VARCHAR2(32000),
  value VARCHAR2(32000)
);

create or replace TYPE key_value_table AS TABLE OF key_value_obj;