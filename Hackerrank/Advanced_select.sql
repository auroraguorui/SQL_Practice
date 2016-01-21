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
# | Field | Type |
-- # 6. Query the average population for all cities in CITY, rounded down to the nearest integer.
