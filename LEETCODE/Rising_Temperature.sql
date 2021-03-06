# Given a Weather table, write a SQL query to find all dates' 
# Ids with higher temperature compared to its previous (yesterday's) dates.
# 
# +---------+------------+------------------+
# | Id(INT) | Date(DATE) | Temperature(INT) |
# +---------+------------+------------------+
# |       1 | 2015-01-01 |               10 |
# |       2 | 2015-01-02 |               25 |
# |       3 | 2015-01-03 |               20 |
# |       4 | 2015-01-04 |               30 |
# +---------+------------+------------------+
# For example, return the following Ids for the above Weather table:
# +----+
# | Id |
# +----+
# |  2 |
# |  4 |
# +----+
#


# Write your MySQL query statement below
SELECT temp.Id
FROM (
  SELECT Id, CASE
      WHEN @prev < temperature AND DATEDIFF(Date, @date_prev) = 1 THEN 1 ELSE 0 END as booleen,
      @prev:= Temperature,
      @date_prev:=Date
  FROM Weather w, (SELECT @prev:=NULL, @date_prev:=NULL) vars
  ORDER BY Date
  ) temp 
WHERE temp.booleen = 1 


# Time:  O(n^2)
# Space: O(n)
# Write your MySQL query statement below
SELECT wt1.Id 
FROM Weather wt1, Weather wt2
WHERE wt1.Temperature > wt2.Temperature AND 
      TO_DAYS(wt1.DATE) - TO_DAYS(wt2.DATE) = 1;


# Write your MySQL query statement below
SELECT w1.Id
FROM Weather w1
JOIN Weather w2 ON DATEDIFF(w1.Date, w2.Date)=1 AND w1.temperature > w2.temperature
