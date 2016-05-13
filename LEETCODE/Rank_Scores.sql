# Time:  O(n^2)
# Space: O(n)
#
# Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.
#
# +----+-------+
# | Id | Score |
# +----+-------+
# | 1  | 3.50  |
# | 2  | 3.65  |
# | 3  | 4.00  |
# | 4  | 3.85  |
# | 5  | 4.00  |
# | 6  | 3.65  |
# +----+-------+
# For example, given the above Scores table, your query should generate the following report (order by highest score):
#
#    +-------+------+
#    | Score | Rank |
#    +-------+------+
#    | 4.00  | 1    |
#    | 4.00  | 1    |
#    | 3.85  | 2    |
#    | 3.65  | 3    |
#    | 3.65  | 3    |
#    | 3.50  | 4    |
#    +-------+------+
#
# --------------------------------------------------------------------------------
SELECT tmp.Score, tmp.Rank
FROM (
  SELECT SCORE, 
         @COUNT:= IF(@PREV > Score, @COUNT + 1, @COUNT) as Rank,
         @PREV:= Score
  FROM Scores, (SELECT @PREV:=NULL, @COUNT:=1) as vars
  ORDER BY Score desc ) tmp

# --------------------------------------------------------------------------------
# 800 ms Write your MySQL query statement below
SELECT
  Score,
  @rank := @rank + (@prev <> (@prev := Score)) Rank
FROM
  Scores,
  (SELECT @rank := 0, @prev := -1) init
ORDER BY Score desc

# 801 ms --------------------------------------------------------------------------------
SELECT Score, (
  SELECT count(*) 
  FROM (
    SELECT distinct Score s 
    FROM Scores) tmp 
  WHERE s >= Score) Rank
FROM Scores
ORDER BY Score desc

# --------------------------------------------------------------------------------
# Time:  O(n^3)
# Space: O(n)
SELECT Score, (
  SELECT COUNT(DISTINCT(Score)) 
  FROM  Scores b 
  WHERE b.Score > a.Score) + 1 AS Rank
FROM Scores a
ORDER by Score DESC

# --------------------------------------------------------------------------------
SELECT Score,
       Rank() Over (order by Score desc) as rank
FROM Scores

# --------------------------------------------------------------------------------
SELECT Ranks.Score, Ranks.Rank FROM Scores LEFT JOIN 
       ( SELECT r.Score, @curRow := @curRow + 1  Rank 
            FROM (SELECT DISTINCT(Score), (SELECT @curRow := 0) 
                      FROM Scores ORDER by Score DESC) r
       ) Ranks 
       ON Scores.Score = Ranks.Score
       ORDER by Score DESC
