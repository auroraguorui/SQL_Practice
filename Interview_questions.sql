-- # 1. The following SQL practice exercises were actually taken from real interview tests with Google and Amazon. 
# TABLE1: Salesperson	#
# +----+-------+-----+---------+
# | ID | Name	 | Age | Salary  | 
# +----+-------+-----+---------+
# | 1	 | Abe	 | 61	 | 140000  |
# | 2	 | Bob	 | 34	 | 44000   |
# | 5	 | Chris | 34	 | 40000   |
# | 7	 | Dan	 | 41	 | 52000   |
# | 8	 | Ken	 | 57	 | 115000  |
# | 11 | Joe	 | 38	 | 38000   |
# +----+-------+-----+---------+

# TABLE2: Customer #
# +----+----------+----------+---------------+
# | ID | Name     | City     | Industry Type |
# +----+----------+----------+---------------+
# | 4	 | Samsonic | pleasant | J             |
# | 6	 | Panasung | oaktown	 | J             |
# | 7	 | Samony   | jackson	 | B             |
# | 9	 | Orange	  | Jackson	 | B             |
# +----+----------+----------+---------------+

# TABLE3: Orders #
# +--------+------------+---------+----------------+--------+
# | Number | order_date	| cust_id	| salesperson_id | Amount |
# +--------+------------+---------+----------------+--------+
# | 10	   | 8/2/96	    | 4	      | 2		           | 540    | 
# | 20     | 1/30/99    |	4	      |	8		           | 1800   |
# | 30     | 7/14/95	  | 9	      |	1		           | 460    |
# | 40     | 1/29/98	  | 7	      |	2		           | 2400   | 
# | 50     | 2/3/98	    | 6	      |	7		           | 600    |
# | 60     | 3/2/98	    | 6	      |	7		           | 720    | 
# | 70     | 5/6/98	    | 9	      |	7		           | 150    |
# +--------+------------+---------+----------------+--------+

-- # 1a. The names of all salespeople that have an order with Samsonic.



