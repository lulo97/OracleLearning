--Top privileges user is sys account
--A user created by sys or other user can't delete sys account by any method

--When first create user, simple privileges is CREATE SESSION, CONNECT, RESOURCE
GRANT CREATE SESSION TO lulo97; --Create session
GRANT CONNECT TO lulo97; --Connect to database
GRANT RESOURCE TO lulo97; --CRUD database objects inside user scheme

--Grant CRUD user account
GRANT CREATE USER TO lulo97;
GRANT ALTER USER TO lulo97;
GRANT DROP USER TO lulo97;

--Grant CRUD Role
GRANT CREATE ROLE TO lulo97;
GRANT DROP ROLE TO lulo97;

--Grant privileges to change system setting
GRANT ALTER SYSTEM TO lulo97;

--Grant DBA (full control) to server database to user
GRANT DBA TO lulo97;

--Grant tablespaces storage
ALTER USER lulo97 QUOTA 100M ON users_tablespaces;
ALTER USER lulo97 QUOTA UNLIMITED ON users_tablespaces;

--Grant backup/recover table
GRANT BACKUP ANY TABLE TO lulo97;
GRANT RECOVER ANY TABLE TO lulo97;

--Grant permission to excute procedure of other user
GRANT EXECUTE ANY PROCEDURE TO lulo97;

--Grant CRUD table of server database
GRANT SELECT ANY TABLE TO lulo97;
GRANT INSERT ANY TABLE TO lulo97;
GRANT UPDATE ANY TABLE TO lulo97;
GRANT DELETE ANY TABLE TO lulo97;
GRANT SELECT, INSERT, UPDATE, DELETE ON schema_name.table_name TO lulo97; --Specific table on specific schema

--Grant transaction privilages
GRANT CREATE TRANSACTION TO lulo97;
GRANT MANAGE ANY TRANSACTION TO lulo97;

--Revoke is undo grant


























