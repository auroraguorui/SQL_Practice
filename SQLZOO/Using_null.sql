/*
teacher
id	dept	name	phone	mobile
101	1	Shrivell	2753	07986 555 1234
102	1	Throd	2754	07122 555 1920
103	1	Splint	2293	
104		Spiregrain	3287	
105	2	Cutflower	3212	07996 555 6574
106		Deadyawn	3345	
...
dept
id	name
1	Computing
2	Design
3	Engineering
...
*/


/* Q1. Use COUNT and GROUP BY dept.name to show each department and the number of staff. 
Use a RIGHT JOIN to ensure that the Engineering department is listed.
*/
select d.name, count(t.name)
from dept d
left join teacher t on t.dept = d.id
group by d.id
/* Note: null is not accunted for count()
*/
