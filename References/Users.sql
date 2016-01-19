-- # 1. Give the new user permission to connect and to create their own tables etc.
CREATE DATABASE scott;
GRANT SELECT, INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
   ON scott.* TO scott@localhost
   IDENTIFIED BY 'tiger';
FLUSH PRIVILEGES;

-- # 2. Read tables from another schema/database. A particular server may support a number of different sets of tables. 
--      In Oracle these are schemas in MySQL they are databases. In both cases each user normally has their own set of tables, 
--      other users tables may be accessed using a dot notation.
SELECT * FROM gisq.one

-- # 3. Change the default schema/database.
USE scott

-- # 4. Find another process and kill it. Sometimes users set off queries that may take a very long time to complete. We may 
--      want to find such long running processes and stop them. Some kind of administrative account is usually required.
SHOW PROCESSLIST;
KILL 16318

-- # 5. Set a timeout. Users may accidentally (or deliberately) start queries which would take a very long time to complete. 
--      We can set a 'timeout'; this means that the system gives up after a certain amount of time.

-- # 6. Change my own password.
--      Users should be able to change their own passwords. The administrator should be able to change other people's passwords.
SET password FOR scott@localhost=password('tiger')

-- # 7. Who am I - what is my user id?
SELECT USER()
