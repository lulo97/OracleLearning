DECLARE
    pi CONSTANT NUMBER := 3.14;

BEGIN
    pi := 4; --PLS-00363: expression 'PI' cannot be used as an assignment target
END;
