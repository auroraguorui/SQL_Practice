-- # 1. Subquery and JOIN
--      Here you are shown how to convert subqueries into JOIN functions this would be done as using subqueries that contain 
--      no aggregate functions unnecessarily causes the response speed of the query to slow down.
SELECT payment FROM salary WHERE rank =
 (SELECT rank FROM ranks WHERE title =
 (SELECT title FROM jobs 
   WHERE employee = 'Andrew Cumming'))
   
SELECT payment 
  FROM salary, ranks, jobs
  WHERE salary.rank = ranks.rank
    AND ranks.title = jobs.title
    AND jobs.employee = 'Andrew Cumming'
    
-- # 2. In this example you are shown how to convert subqueries containing aggregate functions into JOINs allowing for a more 
--      efficient response time from the query.
SELECT customer, whn, totalitems
FROM orders a
WHERE a.whn = (
 SELECT MAX(totalitems)
 FROM orders b
 WHERE a.customer = b.customer)
--      To make this query more efficient a HAVING clause can be used with a self join to replace the subquery.
SELECT a.customer, a.whn, a.totalitems
  FROM orders a JOIN orders b ON (a.customer = b.customer)
  GROUP BY a.customer, a.whn, a.totalitems
  HAVING a.whn = MAX(b.whn)
  
-- # 3. Combinations. A JOIN with no join conditions results in every row in one table being connected to every row in another table, 
--      forming all possible row combinations. Often this is done by mistake, but it can be useful. In this example we use this as an 
--      advantage to show the goals made for all games.
--      To get all possible values a CROSS JOIN is used. Conditions as well as a LEFT JOIN are then used to filter the query and make it more accurate.
SELECT home.teamname Home, away.teamname Away, tscores.homescore, tscores.awayscore
FROM teams home CROSS JOIN teams away LEFT JOIN tscores ON (home.teamname = tscores.hometeam
AND tscores.awayteam = away.teamname)
WHERE home.teamname != away.teamname

-- # 4. Normally a string can be searched for across many columns using the OR function but this is not efficient as this could lead to 
--      errors while using a CONCAT function ( || for oracle, + for sqlserver) could do the same task but can get rid of the risk of errors
SELECT name FROM bedrooms
 WHERE floorcolor = 'YELLOW'
    OR ceilingcolor = 'YELLOW'
    OR wallcolor = 'YELLOW'
--      Using OR increases the chances for careless mistakes instead CONCAT could be used to make the query more efficient. To avoid 
--      problems make sure to add in separators and if a value can be null make sure to use it is wrapped in COALESCE or NVL for example:
--      COALESCE(floorcolor,' ').
SELECT name 
FROM bedrooms
WHERE CONCAT (':',floorcolor,':',ceilingcolor,':',wallcolor,':')
LIKE '%:YELLOW:%'
--      Instead of COALESCE or NVL, IFNULL can be used.

-- # 5. Multiplying across a result set allows for interest rates to calculated correctly. In this example we get the interest after 4 
--      years imagine over the 4 years we have rates 5%, 4%, 5% and 3% adding these rates to get 17% (£117) isn't correct. To get the 
--      correct results you have to follow the steps given here.
--      We need to instead find the logarithm of the compound interest and then we need to sum that. SELECT SUM(LN((rate/100)+1)) FROM 
--      interest. Then we inverse or take the exponent of the logarithm with SELECT EXP(SUM(LN((rate/100)+1))) FROM interest and then finally 
--      to get the amount after 4 years we times this amount by 100 (£100).
SELECT EXP(SUM(LN((rate/100)+1)))*100
FROM interest
  
-- # 6. Running Total
--      In this example you are shown how to get a running total in a set of results. Table 1 shows the results without the running total and 
--      Table 2 shows what we get with the running total.
# Table 1 #
# +------------+---------------+--------+
# | whn       	| description	  | amount |
# +------------+---------------+--------+
# | 2006-11-01	| Wages	        |  50    |
# | 2006-11-02	| Company Store	| -10    |
# | 2006-11-03 |	Company Store	| -10    |
# | 2006-11-04	| Company Store	| -10    |
# | 2006-11-05	| Company Store	| -10    |
# | 2006-11-06	| Company Store	| -10    |
# +------------+---------------+--------+

# Table 2 #
# +------------+---------------+--------+---------+
# | whn	       | description	  | amount	| balance |
# +------------+---------------+--------+---------+
# | 2006-11-01	| Wages	        |  50    |	50      |
# | 2006-11-02	| Company Store	| -10    |	40      |
# | 2006-11-03	| Company Store	| -10	   | 30      |
# | 2006-11-04	| Company Store	| -10	   | 20      |
# | 2006-11-05	| Company Store	| -10	   | 10      |
# | 2006-11-06	| Company Store	| -10	   |  0      |
# +------------+---------------+--------+---------+

--      To calculate a running total a table needs to be joined to itself, each version can be called table x and table y.
SELECT x.whn, x.description, x.amount, SUM(y.amount) AS balance
FROM transact x
JOIN transact y ON (x.whn>=y.whn)
GROUP BY x.whn, x.description, x.amount

SELECT w AS dte, d AS description, a, balance
FROM (
  SELECT x.whn AS w, x.description AS d, x.amount AS a, SUM(y.amount) AS balance
  FROM transact x
  JOIN transact y ON (x.whn>=y.whn)
  GROUP BY x.whn, x.description, x.amount) t
 
--      In MySQL the following query also works:
SELECT whn, description, amount, @accumulator:=@accumulator+amount RunningTotal
FROM transact, (SELECT @accumulator := 0) var;
--      OR in MYSQL
SET @accumulator = 0;
SELECT whn, description, amount, @accumulator:=@accumulator+amount RunningTotal
FROM transact;

-- # 7. Credit debit. In this example you are shown how to split a single column into two separate columns and also below you are
--      told how to combine two tables into a single table. Here we are splitting cash amounts into credit and debit.
--      Table 1 shows the results without the split column and Table 2 shows what we get when the column is split into two.
# Table 1 #
# +------------+---------------+--------+
# | whn       	| description	  | amount |
# +------------+---------------+--------+
# | 2006-11-01	| Wages	        |  50    |
# | 2006-11-02	| Company Store	| -10    |
# | 2006-11-03 |	Company Store	| -10    |
# | 2006-11-04	| Company Store	| -10    |
# | 2006-11-05	| Company Store	| -10    |
# | 2006-11-06	| Company Store	| -10    |
# +------------+---------------+--------+

# Table 2 #
# +------------+---------------+--------+---------+
# | whn	       | description	  | cshIN 	| cshOUT  |
# +------------+---------------+--------+---------+
# | 2006-11-01	| Wages	        |  50    |	        |
# | 2006-11-02	| Company Store	|        |	10      |
# | 2006-11-03	| Company Store	|    	   | 10      |
# | 2006-11-04	| Company Store	|    	   | 10      |
# | 2006-11-05	| Company Store	|    	   | 10      |
# | 2006-11-06	| Company Store	|    	   | 10      |
# +------------+---------------+--------+---------+
--      To split a column into two you have to use a CASE function as shown in the example. The SUBSTRING used in the example is 
--      used to get rid of the negative sign infront of the number so that there are only positive numbers in the table.
--      To combine two columns into a single one you also use a CASE function to do this with this example you can use this code:
SELECT whn, description, 
   CASE WHEN (amount>=0) THEN amount ELSE NULL END AS cshIN,
   CASE WHEN (amount<0)  THEN SUBSTR(amount,2,10) ELSE NULL END AS cshOUT
FROM transact
  
-- # 8. Forgotten rows. In this example you are shown how to include the rows your JOIN function automatically leaves out as it does
--      not perform the join when one of the values is 0. This is done by adding a either a LEFT JOIN or a UNION making the join 
--      also to reveal the rows with a count of 0. Table 1 shows the results without a LEFT JOIN and table 2 shows the results we 
--      obtain with the LEFT JOIN
# Table 1 #
# +---------+---------------+
# | name	   | COUNT(custid) |
# +---------+---------------+
# | Betty  	| 2             |
# | Janette	| 1             |
# +---------+---------------+

# Table 2 #
# +---------+---------------+
# | name	   | COUNT(custid) |
# +---------+---------------+
# | Betty	  | 2             |
# | Janette	| 1             |
# | Robert	 | 0             |
# +---------+---------------+

--      The following query will only give two rows as the JOIN function automatically does not include rows with a count of 0.
--      In order to obtain the rows where the count from the query is 0 a LEFT JOIN or a UNION can be used.
SELECT name, COUNT(custid)
FROM customer 
LEFT JOIN invoice ON (id=custid)
GROUP BY name

-- # 9. In this example you are shows how to use the MAX or MIN functions to find the maximum or minimum over two fields instead of just one.
--      The function for using MAX over two fields is max(x,y) = (x + y + ABS(x-y))/2
--      The function for using MIN over two fields is min(x,y) = (x + y - ABS(x-y))/2
SELECT id, x, y, (x+y+ABS(x-y))/2 
FROM t
--      In MySQL you can also use the GREATEST or LEAST functions to do this.

-- # 10. Values and Subtotals. Get values and Subtotals in one shot. In this example you are shown how to obtain subtotals in your 
--       query, allowing you to easily see SUM results for different elements. Table 1 shows the result without the subtotals and 
--       Table 2 shows the result with subtotals.
# Table 1 #
# +------+--------------+-------+
# | item	| serialnumber	| price |
# +------+--------------+-------+
# | Awl	 | 1	           | 10    |
# | Awl	 | 3	           | 10    |
# | Bowl	| 2	           |	10    |
# | Bowl	| 5	           |	10    |
# | Bowl	| 6	           |	10    |
# | Cowl	| 4	           |	10    |
# +------+--------------+-------+

# Table 2 #
# +------+--------------+-------+
# | item	| serialnumber	| price |
# +------+--------------+-------+
# | Awl	 | 	 1          | 	10   |
# | Awl 	| 	 3          |	 10   |
# | Awl 	| 	            |  20   |
# | Bowl	| 	 2	         |  10   |
# | Bowl	| 	 5          | 	10   |
# | Bowl	| 	 6          | 	10   |
# | Bowl	| 	            |  30   |
# | Cowl	| 	 4          |	 10   |
# | Cowl	| 	            |  10   |
# +------+--------------+-------+
--       In this example a UNION is used to make the query show the subtotal results along with the price results and to 
--       ensure the subtotals come after the price a COALESCE function is also used.
SELECT item, serialnumber, price 
FROM serial
UNION
SELECT item, NULL, SUM(price)
FROM serial
GROUP BY item 
ORDER BY item, COALESCE(serialnumber, 1E9)
  
--       Grand total can also be obtained through ROLLUPS:
SELECT item, serialnumber, SUM(price)
FROM serial
GROUP BY item, serialnumber WITH ROLLUP

-- # 11. Combine tables containing different data. In this example you are shown how to take tables with different data and
--       put them into a single table that is more understandable allowing all the information from two or more tables to be 
--       seen. Table 1 and table 2 show the two tables you want to combine and table 3 is the table they are combined into.
# Table 1 #
# +---------+--------------+---------------+--------+
# | staffid	| email       	| name	         | salary |
# +---------+--------------+---------------+--------+
# | 0173    |	stan@bos.edu	| Stern, Stan  	| 99000  |
# | 0101	   | ali@bos.edu	 | Aloof, Alison	| 30000  |
# +---------+--------------+---------------+--------+

# Table 2 #
# +------+--------+---------+-----+
# | id	  | fname	 | lname	  | gpa |
# +------+--------+---------+-----+
# | 1007	| Peter	 | Perfect	| 590 |
# | 1008	| Donald	| Dunce	  | 220 |
# +------+--------+---------+-----+

# Table 3 #
# +-------+---------------+--------------+-------+---------+
# | id    |	name	         | email	salary	| gpa	  | species |
# +-------+---------------+--------------+-------+---------+
# | F173	 | Stern,Stan	   | stan@bos.edu	| 99000	|	Staff   |
# | F101	 | Aloof,Alison	 | ali@bos.edu	 | 30000	|	Staff   |
# | S1007	| Perfect,Peter	| 1007@bos.edu	|	590	  | Student |
# | S1008	| Dunce,Donald	 | 1008@bos.edu	|	220	  | Student |
# +-------+---------------+--------------+-------+---------+
--       You can use UNION when you have two tables you want to combine but that contain different data. You will have to 
--       make the two tables agree before you can do the UNION though, this is done by making the final table contain all 
--       information from all tables with NULL entries in the rows that don't have the data required. 
--       In this example a staff table and a student table are combined (Table 2 and Table 3).
SELECT CONCAT('F',staffid) id, name name, email email, salary salary, NULL gpa, 'Staff' species
FROM staff
UNION
SELECT CONCAT('S',id) id, CONCAT(lname,',',fname) name, CONCAT(id,'@bos.edu') email, NULL salary, gpa gpa, 'Student' species
FROM student

-- # 12. Display rows as columns. In this example you are shown how to display your rows as columns, and below you are told 
--       how to do the opposite by being able to display columns as rows. Table 1 displays the results as they are in the 
--       database and table 2 displays the results as how they should look when rows have been swapped with columns.
# Table 1 #
# +--------------+----------+-------+
# | student	     | course	  | grade |
# +--------------+----------+-------+
# | Gao Cong    	| Java	    | 80    |
# | Gao Cong	    | Database	| 77    |
# | Gao Cong	    | Algebra	 | 50    |
# | Dongyan Zhou	| Java     |	62    |
# | Dongyan Zhou | Database	| 95    |
# | Dongyan Zhou	| Algebra	 | 62    |
# +--------------+----------+-------+

# Table 2 #
# +--------------+------+----+---------+
# | name	        | java	| DB	| Algebra |
# +--------------+------+----+---------+
# | Gao Cong	    | 80	  | 77 |	50      |
# | Dongyan Zhou	| 62	  | 95 |	62      |
# +--------------+------+----+---------+
--       To swap rows into columns you could use either a self join(in the example) or you can use CASE
SELECT student, 
    max(CASE WHEN course='Java'         THEN grade ELSE NULL END) AS Java,
    max(CASE WHEN course='Database' THEN grade ELSE NULL END) AS DB,
    max(CASE WHEN course='Algebra'    THEN grade ELSE NULL END) AS Algebra
FROM courseGrade 
GROUP BY student
--       You can also do the opposite of this by displaying columns as rows. To do this you use a process that is the 
--       opposite of the swapping rows to columns one. The coding for this process is:
SELECT name as student, 'Java'     as course, Java     as grade FROM exam
UNION 
SELECT name as student, 'Database' as course, dbt      as grade FROM exam
UNION 
SELECT name as student, 'Algebra'  as course, Algebra  as grade FROM exam

-- # 13. Import someone else's data. In this example you are shown how to make a mimic which essentially makes a copy of 
--       the database table so it can be freely edited and then the newly fresh one when finished can be used to replace 
--       the out of date existing table. Table 1 and 2 show the two separate tables and table 3 displays the results that 
--       should be inside the mimic in this example.
# Table 1
# +-----+--------------+
# | id  |	parkingSpace |
# +-----+--------------+
# | E01	| F8           |
# | E02	| G22          |
# | E03	| F7           |
# +-----+--------------+

# Table 2 #
# +-----+---------+-------+
# | id  |	name	   | phone |
# +-----+---------+-------+
# | E01	| Harpo	  | 2753  |
# | E02	| Zeppo	  | 2754  |
# | E03	| Groucho	| 2755  |
# +-----+---------+-------+

# Table 3 #
# +-----+---------+-------+--------------+
# | id	 | name	   | phone	| parkingSpace |
# +-----+---------+-------+--------------+
# | E01	| Harpo   |	2753	 | F8           |
# | E02	| Zeppo	  | 2754	 | G22          | 
# | E03	| Groucho	| 2755	 | F7           |
# +-----+---------+-------+--------------+
--       To allow data to be imported into your system a mimic of your system can be made and then all that needs to be done is the rows 
--       from the old copy have to be deleted and then the table can be refilled with the fresh imported copy. This method is not 
--       completely ideal but is efficient as a temporary measure until an up to date version of the table is made.
CREATE VIEW mimic AS
  SELECT employeeParking.id, COALESCE(name, employeeParking.id) AS name,
  COALESCE(phone, 'Not Available') AS phone, parkingSpace
  FROM employeeParking 
  LEFT OUTER JOIN employeeCopy ON (employeeParking.id = employeeCopy.id);
SELECT * FROM mimic;

-- # 14. Issue queries without using a table. This is done in different ways across different platforms but all of them will give a single
--       row of information. Only certain functions can be used without a table and these functions are called static functions. Static
--       functions can allow a user to obtain the current username, current date, current timestamp and also the version of the database
--       being used.
SELECT CURRENT_USER, CURRENT_DATE, CURRENT_TIMESTAMP, VERSION(), RAND(), UUID()

-- # 15. Generate rows without the use of tables. You can use single value SELECT to generate tables. You can use them when you need a 
--       small table for your query but you don't have permission to create tables in the database itself.
SELECT x centigrade, x*9/5+32 fahrenheit
FROM (
  SELECT 0 x 
  UNION 
  SELECT 10 
  UNION 
  SELECT 20
  UNION 
  SELECT 30 
  UNION 
  SELECT 40) t

-- # 16. Combine multiple queries. Both related and unrelated queries can be merged, if the queries are often used together then combining
--       them together can greatly improve performance. Table 1 and 2 show the two separate tables and Table 3 shows the result you would 
--       obtain from combining queries.
# Table 1 #
# +---------+---------------+
# | content	| Page name     |
# +---------+---------------+
# | chello	 | index.html    |
# | cHia	   | index.html    |
# | cpage2	 | p2.html       |
# | cIndex	 | contents.html |
# +---------+---------------+

# Table 2 #
# +----------------------------------+
# | Message                          |
# +----------------------------------+
# | The site will be down on Tuesday |
# +----------------------------------+

# Table 3 #
# +------------+---------+-----------------------------------+------+
# | pagename	  | content	| NULL                             	| page |
# +------------+---------+-----------------------------------+------+
# | index.html	| hello		 |                                   | page |
# | index.html	| Hia		   |                                   | page |
# |            |         | The site will be down on Tuesday	 | motd |
# +------------+---------+-----------------------------------+------+
--       In this example a typical approach to these tables could be:
-- SELECT pagename, content
--  FROM page
-- WHERE pagename = 'index.html'
--      or:
-- SELECT message FROM motd
--       These two queries can be combined using UNION and NULLs where necessary and therefore a single query can be run allowing a quicker response from the database.
SELECT pagename, content, NULL, 'page' FROM page WHERE pagename = 'index.html'
UNION 
SELECT NULL, NULL, message, 'motd' FROM motd

-- # 17. Here you are shown how to break your query down by range. In this example if you want to see how much different age groups spend
--       then you will have to group the individuals in specific ranges. First you use ROUND to group together the different age groups.
--       You then use the AVG function to find the average they spend. Finally you use a CONCAT function to make the age ranges more clear.
SELECT CONCAT(low-5,'-' ,low+4) AS the_range, avgSpend
FROM (
  SELECT ROUND(age,-1) AS low, AVG(spend) AS avgSpend
  FROM population
  GROUP BY ROUND(age,-1)) t
--       You can also use the FLOOR function:
SELECT age, 5*FLOOR(age/5) AS valueBucket,
       CONCAT(5*FLOOR(age/5),'-',5*FLOOR(age/5)+4) AS the_range
FROM population 

-- # 18. Test subquery. Here you are shown how to test two values from your subquery to ensure that it has run correctly.
# Table 1 #
# +----------+--------+-------+
# | Customer	| Item	  | Price |
# +----------+--------+-------+
# | Brian	   | Table	 | 100   |
# | Robert	  | Chair	 | 20    |
# | Robert	  | Carpet | 200   |
# | Janette	 | Statue | 300   |
# +----------+--------+-------+

# Table 2 #
# +----------+--------+-------+
# | Customer	| Item	  | Price |
# +----------+--------+-------+
# | Brian    |	Table	 | 100   |
# | Robert	  | Carpet	| 200   |
# | Janette	 | Statue	| 300   |
# +----------+--------+-------+
--       Suppose you have a table of customers and their orders, as shown in Table 1 and you want to produce a list of every customer and 
--       their biggest order, as shown in Table 2. This is easy enough to do with:
-- SELECT Customer, MAX(price)
-- FROM custItem
-- GROUP BY Customer
SELECT x.Customer, x.Item, x.Price
FROM custItem x JOIN (
  SELECT Customer, MAX(price) AS Price
  FROM custItem
  GROUP BY Customer) y
  ON (x.Customer = y.Customer AND x.Price = y.Price)
