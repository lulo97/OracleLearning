--Find element in a list with CONTINUE
declare
    value number := 5;
    i number := 0;
begin
    loop
        if i <> value then
            i := i + 1;
            continue;
        end if;
        
        --Below code only run once because continue skip it
        DBMS_OUTPUT.put_line('Found value!');
        exit;
        
    end loop;
end;