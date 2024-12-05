-- Create the user with password
-- By default, this user will have an empty schema and no additional privileges
CREATE USER lulo97 IDENTIFIED BY "123";

--CREATE SESSION: allow the user to log in as a session
GRANT CREATE SESSION TO lulo97;

--CONNECT: Allows the user to connect to the database.
GRANT CONNECT TO lulo97;

--RESOURCE: Provides privileges to create and manage database objects like tables and views.
GRANT RESOURCE TO lulo97;