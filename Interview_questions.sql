-- # 1. The following SQL practice exercises were actually taken from real interview tests with Google and Amazon. 
# TABLE1: Salesperson	#                         TABLE2: Customer #                               # TABLE3: Orders #
# +----+-------+-----+--------+  +----+----------+----------+---------------+  +--------+------------+---------+----------------+--------+
# | ID | Name  | Age | Salary |  | ID | Name     | City     | Industry Type |  | Number | order_date | cust_id | salesperson_id | Amount |
# +----+-------+-----+--------+  +----+----------+----------+---------------+  | 10     | 8/2/96     | 4       | 2              | 540    | 
# | 1  | Abe   | 61  | 140000 |  | 4  | Samsonic | pleasant | J             |  | 20     | 1/30/99    | 4       | 8              | 1800   |
# | 2  | Bob   | 34  | 44000  |  | 6  | Panasung | oaktown  | J             |  | 30     | 7/14/95    | 9       | 1              | 460    |
# | 5  | Chris | 34  | 40000  |  | 7  | Samony   | jackson  | B             |  | 40     | 1/29/98    | 7       | 2              | 2400   |
# | 7  | Dan   | 41  | 52000  |  | 9  | Orange   | Jackson  | B             |  | 50     | 2/3/98     | 6       | 7              | 600    |
# | 8  | Ken   | 57  | 115000 |  +----+----------+----------+---------------+  | 60     | 3/2/98     | 6       | 7              | 720    |
# | 11 | Joe   | 38  | 38000  |                                                | 70     | 5/6/98     | 9       | 7              | 150    |
# +----+-------+-----+--------+                                                +--------+------------+---------+----------------+--------+

-- # 1a. The names of all salespeople that have an order with Samsonic. If no NULL value
SELECT Salesperson.Name 
FROM   Salesperson 
WHERE  Salesperson.ID = '{SELECT Orders.salesperson_id FROM Orders, 
                   Customer WHERE Orders.cust_id = Customer.id
                   AND Customer.name = 'Samsonic'}';
-- # 1b. Find the names of all salespeople that do not have any orders with Samsonic.
SELECT Salesperson.Name 
FROM   Salesperson 
WHERE  Salesperson.ID NOT IN (
  SELECT Orders.salesperson_id 
  FROM Orders, Customer 
  WHERE  Orders.cust_id = Customer.ID AND Customer.Name = 'Samsonic')
-- # 1c. Find the names of salespeople that have 2 or more orders.
SELECT Salesperson.Name 
FROM   Salesperson, Orders
WHERE  Salesperson.salesperson_id = Salesperson.ID 
GROUP BY name, Orders.salesperson_id
HAVING COUNT(*) > 1
-- # 1d. Write a SQL statement to insert rows into a table called highAchiever(Name, Age), where a salesperson must have a salary of 
--       100,000 or greater to be included in the table.
INSERT INTO highAchiever(Name, Age)
VALUES ( 
  SELECT Name, Age 
  FROM   Salesperson
  WHERE  Salary >= 100000
)

-- # 2. This question was asked in a Google interview: Given the 2 tables below, User and UserHistory:
# +-----------+  +-------------+
# | User      |  | UserHistory |
# +-----------+  +-------------+
# | user_id   |  | user_id     |
# | name      |  | date        |
# | phone_num |  | action      |
# +-----------+  +-------------+
-- # 2a. Write a SQL query that returns the name, phone number and most recent date for any user that has logged in over the last 30 days 
--       (you can tell a user has logged in if the action field in UserHistory is set to "logged_on"). Every time a user logs in a new 
--       row is inserted into the UserHistory table with user_id, current date and action (where action = "logged_on").
SELECT name, phone_num, MAX(date)
FROM   User 
JOIN   UserHistory ON UserHistory.user = User.user_id
WHERE  UserHistory.action = 'logged_on' AND UserHistory.date > date_sub(curdate(), interval 30 day) 
GROUP BY User.user_id
-- # 2b. Write a SQL query to determine which user_ids in the User table are not contained in the UserHistory 
--       table (assume the UserHistory table has a subset of the user_ids in User table). Do not use the SQL MINUS statement. Note: the
--       UserHistory table can have multiple entries for each user_id.
SELECT DISTINCT User.user_id 
FROM   User
LEFT JOIN UserHistory ON User.user_id = UserHistory.user_id
WHERE  UserHistory.user_id = NULL

-- # 3. Let’s say that you are given a SQL table called “Compare” (the schema is shown below) with only one column called “Numbers”.
--      Write a SQL query that will return the maximum value from the “Numbers” column, without using a SQL aggregate like MAX or MIN.
SELECT Numbers 
FROM   Compare
ORDER BY Numbers DESC
LIMIT  1

SELECT DISTINCT Numbers
FROM   Compare
WHERE  Numbers NOT IN (
  SELECT Smaller.Numbers
  FROM   Compare AS Larger
  JOIN   Compare AS Smaller ON Smaller.Numbers < Larger.Numbers )
  
