/* Use COUNT and GROUP BY dept.name to show each department and the number of staff. 
Use a RIGHT JOIN to ensure that the Engineering department is listed.
*/
select d.name, count(t.name)
from dept d
left join teacher t on t.dept = d.id
group by d.id
