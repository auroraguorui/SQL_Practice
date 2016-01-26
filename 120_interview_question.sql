# 9. 
# Q. What are the different types of joins? What are the diffences between them?

# 10. 
# Q. Why might a join on a subquery be slow? How might you speed it up?

# 11. 
# Q. Describe the difference between primary keys and foreign keys in a SQL database.

# 12. 
# Q. Given a COURSES table with columns course_id and course_name, a FACULTY table with columns faculty_id and faculty_name, 
#    and a COURSE_FACULTY table with columns faculty_id and course_id, how would you return a list of faculty who teach a 
#    course given the name of a course?
# A. 
SELECT c.course_name, f.faculty_name
FROM COURSE_FACULTY 
JOIN FACULTY ON COURSE_FACULTY.faulty_id = FACULTY.faculty_id 
JOIN COURSES ON COURSE_FACULTY.course_id = COURSES.course_id

# 13. 
# Q. Given a IMPRESSIONS table with ad_id, click (an indicator that the ad was clicked), and date, write a SQL query 
#    that will tell me the click-through-rate of each ad by month.
# A. 
SELECT IF(click='YES',1,0)/COUNT(click) 
FROM IMPRESSIONS
GROUP BY MONTH(date)

# 14. 
# Q. Write a query that returns the name of each department and a count of the number of employees in each:
#    EMPLOYEES containing: Emp_ID (Primary key) and Emp_Name EMPLOYEE_DEPT containing: Emp_ID (Foreign key) and Dept_
#    ID (Foreign key). DEPTS containing: Dept_ID (Primary key) and Dept_Name
SELECT DEPTS.Dept_Name, COUNT(DISTINCT Emp_ID) 
FROM EMPLOYEE_DEPT 
JOIN DEPTS ON EMPLOYEE_DEPT.Dept_ID = DEPTS.Dept_ID
GROUP BY EMPLOYEE_DEPT.Dept_ID
