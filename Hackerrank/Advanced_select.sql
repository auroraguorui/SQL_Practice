# TABLE: OCCUPATIONS # Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

# +------------+--------+
# | Column     | Type   |
# +------------+--------+
# | Name       | String |
# | Occupation | String |
# +------------+--------+
Occupation String
-- # 1. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a
--      parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
--      sample output: Ashely(P)
--                     Christeen(P)
--                     Jane(A)
--                     Jenny(D)
SELECT CONCAT(Name,'(',SUBSTR(Occupation,1,1),')') AS Name
FROM occupations
ORDER BY Name;

-- # 2. Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the 
--      following format: 
--      sample output There are total 2 doctors.
--                    There are total 2 singers.
--                    There are total 3 actors.
SELECT CONCAT('There are total',' ',COUNT(occupation),' ',LOWER(occupation),'s.') AS total
FROM occupations
GROUP BY occupation
ORDER BY total;

-- # 3. Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding 
--      Occupation. The output column headers should Doctor, Professor, Singer, and Actor, respectively. Print NULL when there are no 
--      more names corresponding to an occupation.
--      Sample Output
--      Jenny    Ashley     Meera  Jane
--      Samantha Christeen  Priya  Julia
--      NULL     Ketty      NULL   Maria
With pivot_data AS ( 
  SELECT Occupation,Name, ROW_NUMBER() OVER(partition BY Occupation ORDER BY Name) rn 
  FROM Occupations
) 
SELECT [Doctor],[Professor],[Singer],[Actor] 
FROM pivot_data pivot ( MAX(Name) for Occupation in ([Doctor],[Professor],[Singer],[Actor]) ) AS p;
-- ONLY IN MS SQL SERVER

-- # 4. You are given a table, BST, containing two columns: N and P, where N represents the value of a node in BST, and P is the parent of N.
# TABLE: bst #
# +--------+---------+
# | Column | Type    |
# +--------+---------+
# | N      | Integer |
# | P      | Integer |
# +--------+---------+
--      Write a query to find the node type of BST ordered by the value of the node. Output one of the following for each node:
--      Root: If node is root node; Leaf: If node is leaf node; Inner: If node is neither root nor leaf node.
SELECT n, CASE 
  WHEN (p is null) then 'Root' 
  WHEN (n in (select p from bst)) then 'Inner'
  ELSE 'Leaf' END 
FROM bst ORDER BY n;

-- # 5. Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements 
--      for each record in the table:
# TABLE: TRIANGLES #
# +--------+---------+
# | Column | Type    |
# +--------+---------+
# | A      | Integer |
# | B      | Integer |
# | C      | Integer |
# +--------+---------+
--      Not A Triangle: The given values of A, B, and C don't form a triangle; Equilateral: It's a triangle with 3 sides of equal length.
--      Isosceles: It's a triangle with 2 sides of equal length              ; Scalene: It's a triangle with 3 sides of differing lengths.
SELECT CASE 
  WHEN ((A + B) <= C OR (B + C) <= A OR (C + A) <= B)           THEN 'Not A Triangle' 
  WHEN (A = B AND B = C AND A = C)                              THEN 'Equilateral' 
  WHEN (A = B AND B!=C) OR (A!=B AND B = C) OR (A!=B AND C = A) THEN 'Isosceles' 
  WHEN (A != B AND B != C AND C != A)                           THEN 'Scalene' END 
FROM triangles;

# TABLE: CITY #
# +-------------+--------------+
# | Field       | Type         |
# +-------------+--------------+
# | ID          | NUMBER       |
# | NAME        | VARCHAR2(21) | 
# | COUNTRYCODE | VARCHAR2(3)  |
# | DISTRICT    | VARCHAR2(20) | 
# | POPULATION  | NUMBER       |
# +-------------+--------------+
-- # 6. Query the average population for all cities in CITY, rounded down to the nearest integer.
SELECT FLOOR(AVG(POPULATION)) 
FROM CITY;

-- # 7. Query the difference between the maximum and minimum populations in CITY.
SELECT MAX(POPULATION) - MIN(POPULATION) FROM CITY;

-- # 8. Query the sum of LAT_N, followed by the sum of LONG_W, from STATION. The two results should be separated by a space and rounded 
--      to 2 decimal places.
SELECT ROUND(SUM(LAT_N),2), '', ROUND(SUM(LONG_W),2) FROM STATION;

-- # 9. Consider P1(a,b) and P2(c,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern 
--      Latitude (LAT_N) and (c,d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
--      Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.
SELECT round(SQRT(POWER(MAX(LAT_N)-MAX(LONG_W),2) + POWER(MIN(LAT_N)-MIN(LONG_W),2)),4) FROM STATION;

-- # 10. A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern 
--       Latitudes (LAT_N) from STATION and round your answer to 
SELECT round( x.LAT_N, 4 ) from STATION x, STATION y
GROUP BY x.LAT_N 
HAVING SUM( SIGN( 1-SIGN( y.LAT_N -x.LAT_N ) ) )/COUNT(*) > .5
LIMIT 1
