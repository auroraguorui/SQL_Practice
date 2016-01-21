---------------------------------------------------------------------------------------------------------------------------------------------------
# TABLE: Students #        # TABLE: Grades #
# +--------+---------+     # +----------+---------+
# | Column | Type    |     # | Grade    | Integer |
# +--------+---------+     # +----------+---------+
# | Name   | String  |     # | Min_Mark | Integer |
# | Marks  | Integer |     # | Max_Mark | Integer |
# +--------+---------+     # +----------+---------+
-- # 1. Ketty gives Eve a task to generate a report containing three columns:  Name, Grade and Mark. Ketty doesn't want the NAMES of those
--      students who received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first.
--      If there is more than one student with the same grade (1-10) assigned to them, order those particular students by their name
--      alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their marks in ascending order.
SELECT IF(Grade < 8, 'NULL', STUDENTS.NAME) as Name, Grade, Marks 
FROM STUDENTS 
JOIN GRADES ON STUDENTS.Marks >= GRADES.MIN_MARK AND STUDENTS.Marks <= GRADES.MAX_MARK
ORDER BY Grade desc, Name, Marks;

---------------------------------------------------------------------------------------------------------------------------------------------------
# TABLE: Students #    # TABLE: Friends #        # TABLE: Packages #
# +--------+---------+ +-----------+---------+   +--------+---------+
# | Column | Type    | | Column    | Type    |   | Column | Type    |
# +--------+---------+ +-----------+---------+   +--------+---------+
# | ID     | Integer | | ID        | Integer |   | ID     | Integer |
# | Name   | String  | | Friend_ID | Integer |   | Salary | Float   |
# +--------+---------+ +-----------+---------+   +--------+---------+
-- # 2. Write a query to output the names of those students whose best friends got offered a higher salary than them. Names must be
--      ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.
SELECT DISTINCT s.Name FROM Students s 
JOIN Packages p1 ON s.ID = p1.ID
JOIN Friends f ON s.ID = f.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p1.Salary < p2.Salary
ORDER BY p2.Salary;

---------------------------------------------------------------------------------------------------------------------------------------------------
# TABLE: Functions #
# +----+----+
# | X  | Y  |
# +----+----+
# | 20 | 20 |
# | 20 | 20 |
# | 20 | 21 |
# | 23 | 22 |
# | 22 | 23 |
# | 21 | 20 |
# +----+----+
-- # 3. Functions contains X and Y. Y is the value of some function F at X, i.e. Y = F(X). Two pairs (X1, Y1) and (X2, Y2) are symmetric 
--      pairs if X1 = Y2 and X2 = Y1. Write a query to output all such symmetric pairs in ascending order by the value of X.
select x, y from functions f1 
    where exists(select * from functions f2 where f2.y=f1.x 
    and f2.x=f1.y and f2.x>f1.x) and (x!=y) 
union 
select x, y from functions f1 where x=y and 
    ((select count(*) from functions where x=f1.x and y=f1.x)>1)    
        order by x;

---------------------------------------------------------------------------------------------------------------------------------------------------
# TABLE: Projects #
# +---------+------------+------------+
# | Task_ID | Start_Date | End_Date   |
# +---------+------------+------------+
# | 1       | 2015-10-01 | 2015-10-02 | 
# | 2       | 2015-10-02 | 2015-10-03 | 
# | 3       | 2015-10-03 | 2015-10-04 | 
# | 4       | 2015-10-13 | 2015-10-14 | 
# | 5       | 2015-10-14 | 2015-10-15 | 
# | 6       | 2015-10-28 | 2015-10-29 | 
# | 7       | 2015-10-30 | 2015-10-21 | 
# +---------+------------+------------+
-- # 4. It is guaranteed that the difference between the End_Date and the Start_Date equals 1 day for each row in the table. If the End_Date
--      of the tasks are consecutive, then they are the same project. Samantha is interested in finding the total number of different projects 
--      completed. Output the start and end dates of projects listed by the number of days it took to complete the project in ascending order
--      If there is more than one project that have the same number of completion days, then order by the start date of the project.
SET @prev:='';  -- note this should be character instead of integer
SET @start:=NULL; 
SET @count:=0;
SELECT d.start_d, max(d.end_d) FROM (
   SELECT 
    @start:= IF(@prev = start_date, @start  , start_date) start_d,
    @count:= IF(@prev = start_date, @count+1, 0         ) cnt    ,  
    @prev := end_date                                     end_d  
   FROM (
     SELECT * FROM Projects ORDER BY start_date) s) d
GROUP BY d.start_d
ORDER BY max(d.cnt) ASC, d.start_d
;
