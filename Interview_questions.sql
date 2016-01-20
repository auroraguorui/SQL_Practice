-- # 1. The following SQL practice exercises were actually taken from real interview tests with Google and Amazon. 
# TABLE1: Salesperson	#                         TABLE2: Customer #                               # TABLE3: Orders #
# +----+-------+-----+--------+  +----+----------+----------+---------------+  +--------+------------+---------+----------------+--------+
# | ID | Name	 | Age | Salary |  | ID | Name     | City     | Industry Type |  | Number | order_date	| cust_id	| salesperson_id | Amount |
# +----+-------+-----+--------+  +----+----------+----------+---------------+  | 10	   | 8/2/96	    | 4	      | 2		           | 540    | 
# | 1  | Abe	 | 61	 | 140000 |  | 4	 | Samsonic | pleasant | J             |  | 20     | 1/30/99    |	4	      |	8		           | 1800   |
# | 2  | Bob	 | 34	 | 44000  |  | 6	 | Panasung | oaktown	 | J             |  | 30     | 7/14/95	  | 9	      |	1		           | 460    |
# | 5  | Chris | 34	 | 40000  |  | 7	 | Samony   | jackson	 | B             |  | 40     | 1/29/98	  | 7	      |	2		           | 2400   |
# | 7  | Dan	 | 41	 | 52000  |  | 9	 | Orange	  | Jackson	 | B             |  | 50     | 2/3/98	    | 6	      |	7		           | 600    |
# | 8  | Ken	 | 57	 | 115000 |  +----+----------+----------+---------------+  | 60     | 3/2/98	    | 6	      |	7		           | 720    |
# | 11 | Joe	 | 38	 | 38000  |                                                | 70     | 5/6/98	    | 9	      |	7		           | 150    |
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
VALUES ()
