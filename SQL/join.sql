--Empty tables, reset water mark
truncate table users;
truncate table todos;

-- Insert into users
INSERT INTO users (id, username) VALUES (1, 'user1');
INSERT INTO users (id, username) VALUES (2, 'user2');
INSERT INTO users (id, username) VALUES (3, 'user3');

-- Insert into todos
INSERT INTO todos (id, userid, name, description, complete) VALUES (1, 1, 'Task1', 'Description1', 0);
INSERT INTO todos (id, userid, name, description, complete) VALUES (2, 1, 'Task2', 'Description2', 1);
INSERT INTO todos (id, userid, name, description, complete) VALUES (3, 2, 'Task3', 'Description3', 0);
INSERT INTO todos (id, userid, name, description, complete) VALUES (4, 4, 'Task4', 'Description4', 1);
INSERT INTO todos (id, userid, name, description, complete) VALUES (5, NULL, 'Task5', 'Description5', 0);

--Join without condition ON is just cascade product
--Cascade product between A and B is { (ai, bj) } for 0<=i<=|A| and 0<=j<=|B|
--Size of cascade product = |A|*|B*|
--Cross join (only cross join syntax worked in oracle without ON keywork)
--Output: 3*5 = 15 row
SELECT *
FROM users u
CROSS JOIN todos t;

--Inner join
--Step 1: From all record of Users, match with record of Todos (15 row)
--Step 2: Filter only row have userid same (user 1 have 2 task, user 2 have 1 task)
--Output: 3 row
SELECT u.username as Username, t.name as Todo
FROM users u
INNER JOIN todos t ON u.id = t.userid;

--Left join
--Step 1: From all record of Users, match with record of Todos (15 row)
--Step 2: Select row have userid same (user 1 have 2 task, user 2 have 1 task)
--Step 3: Select remaining row in Users table and let other column of row is NULL (user 3 have no task)
--Output: 2 + 1 = 3 row
SELECT u.username as Username, t.name as Todo
FROM users u
LEFT JOIN todos t ON u.id = t.userid;

--Right join
--Step 1: From all record of Users, match with record of Todos (15 row)
--Step 2: Select row have userid same (user 1 have 2 task, user 2 have 1 task)
--Step 3: Select remaining row in Todos table and let other column of row is NULL (task 4, task 5 have no user)
--Output: 3 + 2 = 5 row
SELECT u.username as Username, t.name as Todo
FROM users u
RIGHT JOIN todos t ON u.id = t.userid;

--Full join
--Right join
--Step 1: From all record of Users, match with record of Todos (15 row)
--Step 2: Select row have userid same (user 1 have 2 task, user 2 have 1 task)
--Step 3: Select remaining row in Users table and let other column of row is NULL (user 3 have no task)
--Step 4: Select remaining row in Todos table and let other column of row is NULL (task 4, task 5 have no user)
--Output: 3 + 1 + 2 = 6 row
SELECT u.username as Username, t.name as Todo
FROM users u
FULL JOIN todos t ON u.id = t.userid;

--OUTER syntax
/*
LEFT OUTER JOIN = LEFT JOIN
RIGHT OUTER JOIN = RIGHT JOIN
FULL OUTER JOIN = FULL JOIN

Old day, programmer user less characters to code fast, nowaday some programmer still do it for fast typing
- Ex: Remove white space, use variable name short, store year as 2 digit...
Modern day, add OUTER syntax just to make sure reader have intuitive understanding of JOIN. 
It not about performance anymore, it is about clean code, readable code.
*/

--Write join without JOIN syntax

--Cross join without JOIN syntax
SELECT * 
FROM users u, todos t;

--Inner join without JOIN syntax
SELECT * 
FROM users u, todos t where u.id = t.userid;

--Left join without JOIN syntax (+ sign is on the right)
SELECT * 
FROM users u, todos t where u.id = t.userid (+);

--Right join without JOIN syntax (+ sign is on the left)
SELECT * 
FROM users u, todos t where u.id (+) = t.userid;

--Full join without JOIN syntax
SELECT *
FROM users u, todos t
WHERE u.id = t.userid(+)
UNION
SELECT *
FROM users u, todos t
WHERE u.id(+) = t.userid;

--Self join: A table join to that table it self using INNER, LEFT, RIGHT, FULL JOIN.
--Usecase: Hierarchical data like comment section
CREATE TABLE Comments (
    Id NUMBER PRIMARY KEY,
    ParentId NUMBER,
    Content VARCHAR2(255)
);

INSERT INTO Comments (Id, ParentId, Content) VALUES (1, NULL, 'Root Comment 1');
INSERT INTO Comments (Id, ParentId, Content) VALUES (2, NULL, 'Root Comment 2');
INSERT INTO Comments (Id, ParentId, Content) VALUES (3, 1, 'Reply to Root Comment 1');
INSERT INTO Comments (Id, ParentId, Content) VALUES (4, 1, 'Another Reply to Root Comment 1');
INSERT INTO Comments (Id, ParentId, Content) VALUES (5, 3, 'Reply to the first reply of Root Comment 1');
INSERT INTO Comments (Id, ParentId, Content) VALUES (6, 2, 'Reply to Root Comment 2');

SELECT
    c1.Id AS Comment_Id,
    c1.Content AS CommentContent,
    c2.Id AS Parent_Comment_Id,
    c2.Content AS Parent_Comment
FROM
    Comments c1
LEFT JOIN
    Comments c2 ON c1.ParentId = c2.Id;


--Anti join: Find row on table A does not have matching condition on table B

-- Find users who have no tasks
SELECT u.username 
FROM users u
WHERE NOT EXISTS (
  SELECT 1 
  FROM todos t 
  WHERE t.userid = u.id
);

-- Find users who have no tasks
SELECT u.username
FROM users u
LEFT JOIN todos t ON u.id = t.userid
WHERE t.userid IS NULL;


--Semi join: Return rows from table A that have atleast one match contidition from table B
--Semi join focus on checking existance of data based on another piece of data

--Find users who have at least one task
--Using EXISTS keyword
--Output: user1, user2 (don't care user1 have 2 task or user have 1 task)
SELECT u.username
FROM users u
WHERE EXISTS (
  SELECT 1 
  FROM todos t 
  WHERE t.userid = u.id
);

--Find users who have at least one task
--Using DISTNCT with INNER JOIN
SELECT DISTINCT u.username
FROM users u
INNER JOIN todos t ON u.id = t.userid;

--Summary: Anti join is opposite to Semi join, Anti join is for checking related data not exist while Semi join is for checking related data does exist.


--Properties of JOIN
/*
LEFT, RIGHT JOIN does not communitive: A L/R JOIN B != B L/R JOIN A
LEFT, RIGHT JOIN does not associative: (A L/R JOIN B) L/R JOIN C != A L/R JOIN (B L/R JOIN C)

INNER JOIN hold for communitive and associative
*/



