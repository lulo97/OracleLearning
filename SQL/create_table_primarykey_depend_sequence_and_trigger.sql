-- Create sequence for Users table
CREATE SEQUENCE Users_Seq
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Create Users table
CREATE TABLE Users (
    Id NUMBER PRIMARY KEY,
    Username VARCHAR2(50) NOT NULL UNIQUE,
    Email VARCHAR2(100) NOT NULL UNIQUE
);

-- Create trigger to auto-increment Id for Users
CREATE OR REPLACE TRIGGER Users_BI_Trigger
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        SELECT Users_Seq.NEXTVAL INTO :NEW.Id FROM dual;
    END IF;
END;

-- Create sequence for Todos table
CREATE SEQUENCE Todos_Seq
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Create Todos table
CREATE TABLE Todos (
    Id NUMBER PRIMARY KEY,
    UserId NUMBER NOT NULL,
    Name VARCHAR2(100) NOT NULL,
    Description VARCHAR2(255),
    Complete CHAR(1) DEFAULT 'N',
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

-- Create trigger to auto-increment Id for Todos
CREATE OR REPLACE TRIGGER Todos_BI_Trigger
BEFORE INSERT ON Todos
FOR EACH ROW
BEGIN
    IF :NEW.Id IS NULL THEN
        SELECT Todos_Seq.NEXTVAL INTO :NEW.Id FROM dual;
    END IF;
END;

