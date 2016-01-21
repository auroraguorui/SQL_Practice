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
  
-- # 4. Music Actions. Assume we have a PostgreSQL database. Given two tables music_action and summary_table. 
--      Please answer in a single query and assume read only access to the database (i.e., do not use CREATE TABLE).
--      The music_action is a table recording daily music listened by clients.
--      The summary_table is an accumulative table, with each row the number of times each clientID listened to musicID up to endDate
# TABLE: music_action #            # TABLE: summary_table #
# +-------------+-----------+      +-------------+-----------+
# | Column Name | Data type |      | Column Name | Data type | 
# +-------------+-----------+      +-------------+-----------+ 
# | actionID    | Integer   |      | clientID    | Integer   |
# | clientID    | Integer   |      | numPlay     | Integer   |
# | musicID     | Integer   |      | musicID     | Integer   |
# | snapshotDay | Timestamp |      | endDate     | Timestamp |
# +-------------+-----------+      +-------------+-----------+ 
-- # 4a. Summarize that, for each client, how many pieces of music (including duplicate ones) do they listen to so far?
SELECT clientID, COUNT(actionID) as numPlay
FROM   music_action
GROUP BY clientID
-- # 4b. Write a function to update the summary_table using the music_action table with the latest snapshopDay.
WITH new_cient_music_summary AS (
  SELECT clientID AS clientID,
         musicID  AS musicID,
         COUNT(actionID) AS counts,
         MAX(snapshotDay) AS endDate
  FROM music_action
  GROUP BY clientID, musicID )
SELECT M.clientID,
       (m.counts + S.numPlay) AS numPlay,
       M.musicID,
       CASE WHEN (S.endDate IS NULL OR S.endDate < M.endDate) THEN M.endDate
            ELSE S.endDate END AS endDate
FROM new_client_music_summary M
LEFT JOIN summary_table S ON S.clientID = M.clientID AND S.musicID = M.musicID

-- # 5.  No Sles. 
-- # 5a. Create three tables a) accounts, which contains accountid b) dates, which contains dateid c) facts, which contains
--       three columns date, accountid and revenue. The facts table records the expense of an account every day if there is expense. 
CREATE TABLE accounts (accountid BIGINT);
CREATE TABLE dates    (dateid    DATE  );
CREATE TABLE facts    (accountid BIGINT, dateid DATE, revenue NUMERIC);
-- # 5b. If there is no expense then there won't be a record in the facts table. Given this scenario write a SQL query that generates
--       a list of all Accounts on every day in the last 30 days that had no expense.
SELECT d.dateid, a.accountid
FROM accounts a
CROSS JOIN dates d
LEFT JOIN (
  SELECT DISTINCT f.accountid, d.dateid AS dateid
  FROM facts f CROSS JOIN dates d
  WHERE (d.dateid - f.dateid) <= 30
  AND (d.dateid - f.dateid)   >=  0 ) active 
ON a.accountid = active.accountid AND d.dateid = active.dateid
WHERE active.dateid IS NULL

-- # 6. Second Highest Sale. Write a SQL query to find out the second highest sale from the Sales table. Please answer in a single query 
--      and assume read-only access to the database (i.e. do not use CREATE TABLE).
--      MySQL does not have DENSE_RANK but has LIMIT, offset. The offset defines how many rows are going to remove from the results; for
--      example, the offset of the first row is 0, not 1. 
SELECT sale      FROM sales ORDER BY sale DESC LIMIT 1 OFFSET 1; --MYSQL
SELECT MAX(sale) FROM sales WHERE sale NOT IN (SELECT MAX(sale) FROM sales);
SELECT MAX(sale) FROM sales WHERE sale < (SELECT MAX(sale) FROM sales);
SELECT DISTINCT sale FROM sales s WHERE 2 = (SELECT COUNT(DISTINCT sale) FROM sales s2 WHERE s.sale <= s2.sale);
SELECT sale FROM (select distinct SALE from SALES ORDER BY sale DESC LIMIT 2) AS s ORDER BY sale LIMIT 1; --Postgres, MYSQL

-- # 7. Given a corpus table with columns pageid, txt, for example, all Wikipedia documents keyed by pageid, write HIVE/MYSQL queries to
--      calculate the tfidf of each word.
CREATE OR REPLACE VIEW corpus_exploded AS
SELECT pageid, word
FROM corpus LATERAL VIEW explode(tokenize(text, true)) t as word;

CREATE OR REPLACE VIEW tf AS 
SELECT pageid, word, COUNT(word) AS freq
FROM corpus_exploded 
GROUP BY pageid, word;

CREATE OR REPLACE VIEW df AS
SELECT word, COUNT(DISTINCT pageid) ndoc
FROM corpus_exploded
GROUP BY words;

SELECT COUNT(DISTINCT pageid) FROM corpus;
SET hivevar:n_docs=10000000;

SELECT tf.pageid, tf.word,
       (1 + LOG(CAST(tf.freq AS FLOAT)) ) * LOG(CAST({n_docs} AS FLOAT) / df.ndoc) as TFIDF
FROM tf
JOIN df ON tf.word = df.word AND df.ndoct > 1
ORDER BY tfidf DESC;

-- # 8. A PostgreSQL database. Given schema Sales, which is a table with product and sales infomration. Write SQL queries to find out top
--      3 products for each category in terms of sales on a daily basis. Please answer in a single query.
# TABLE: Sales #
# +-------------+-----------+
# | Column Name | Data type |
# +-------------+-----------+
# | ProductID   | Integer   | 
# | ProductName | CHAR(50)  | 
# | Sales       | Numeric   | 
# | SalesDate   | Date      | 
# | Category    | CHAR(20)  | 
# +-------------+-----------+
WITH R AS (
  SELECT Category, ProductID, ProductName, SalesDate, Sales, 
         ROW_NUMBER() OVER (PARTITION BY Category, SalesDate ORDER BY Sales DESC) AS Sales_Rank
  FROM product_sales )
SELECT S.Category, S.SalesDate, S.ProductID, S.ProductName, R.Sales_Rank, R.Sales
FROM product_sales S 
JOIN R ON S.ProductID = R.ProductID AND S.SalesDate = R.SalesDate
WHERE R.Sales_Rank <= 3
ORDER BY S.Category, S.SalesDate, R.Sales_Rank
--      A better way is to get top products with top 3 distinct sales numbers, change the ROW_NUMBER() to DENSE_RANK(). 
