# Time:  O(n^2)
# Space: O(n)
# 
# The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
# 
# +----+-------+--------+--------------+
# | Id | Name  | Salary | DepartmentId |
# +----+-------+--------+--------------+
# | 1  | Joe   | 70000  | 1            |
# | 2  | Henry | 80000  | 2            |
# | 3  | Sam   | 60000  | 2            |
# | 4  | Max   | 90000  | 1            |
# +----+-------+--------+--------------+
# The Department table holds all departments of the company.
# 
# +----+----------+
# | Id | Name     |
# +----+----------+
# | 1  | IT       |
# | 2  | Sales    |
# +----+----------+
# Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.
# 
# +------------+----------+--------+
# | Department | Employee | Salary |
# +------------+----------+--------+
# | IT         | Max      | 90000  |
# | Sales      | Henry    | 80000  |
# +------------+----------+--------+
# 
select
d.Name, e.Name, e.Salary
from
Department d,
Employee e,
(select MAX(Salary) as Salary,  DepartmentId as DepartmentId from Employee GROUP BY DepartmentId) h
where
e.Salary = h.Salary and
e.DepartmentId = h.DepartmentId and
e.DepartmentId = d.Id;

# Write your MySQL query statement below
SELECT d.Department AS Department, e.Name AS Employee, d.Salary AS Salary
FROM (SELECT Department.Id AS DepartmentId, Department.Name AS Department, emp.Salary AS Salary
        FROM Department JOIN (SELECT DepartmentId, MAX(Salary) AS Salary FROM Employee GROUP BY DepartmentId) emp
        ON Department.Id = emp.DepartmentId) d 
      JOIN Employee e 
      ON e.DepartmentId = d.DepartmentId and e.Salary = d.Salary

# Write your MySQL query statement below
SELECT Department.Name AS Department, Employee.Name AS Employee, Employee.Salary AS Salary
FROM Department JOIN Employee ON Employee.DepartmentId = Department.Id
WHERE Employee.Salary IN (SELECT MAX(e.Salary) FROM Employee e WHERE e.DepartmentId = Employee.DepartmentId)

# Write your MySQL query statement below
SELECT d.name Department, e.Name Employee, e.Salary
FROM Employee e
JOIN Department d ON e.DepartmentId = d.Id
WHERE e.Salary >= ALL (
  SELECT e2.Salary 
  FROM Employee e2 
  WHERE e.DepartmentId = e2.DepartmentId)
