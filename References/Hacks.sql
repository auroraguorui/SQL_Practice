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
  
-- # 3. 
