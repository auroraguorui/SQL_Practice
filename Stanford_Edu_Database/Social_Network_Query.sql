/* Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/

/* Q1 Find the names of all students who are friends with someone named Gabriel. */
select distinct name from Highschooler
join friend on friend.ID1 = Highschooler.ID
where friend.ID2 in 
(select ID from Highschooler where name = 'Gabriel')

/* Q2 For every student who likes someone 2 or more grades younger than themselves, return that student's 
name and grade, and the name and grade of the student they like. */
select h1.name, h1.grade, h2.name, h2.grade
from 
highschooler h1
join likes l on l.ID1 = h1.ID
join highschooler h2 on l.ID2 = h2.ID
where h1.grade - h2.grade > 1

/* Q3 For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order. */
select h1.name, h1.grade, h2.name, h2.grade from
highschooler h1 join likes l1 on h1.ID = l1.ID1
join likes l2 on l1.ID2 = l2.ID1 and l1.ID1 = l2.ID2 
join highschooler h2 on h2.ID = l1.ID2
where h1.name < h2.name
order by 1,3

/* Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. 
*/
select name, grade from highschooler 
where ID not in 
  (
    select ID1 from likes 
    union 
    select ID2 from likes
  )
order by 2, 1

/* Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
*/
select h.name, h.grade, h2.name, h2.grade from 
highschooler h join
likes l1 on h.ID = l1.ID1
left join likes l2
on l1.ID2 = l2.ID1
join highschooler h2 
on h2.ID = l1.ID2
where l2.ID1 is null

/* Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
*/
select distinct name, grade from highschooler hh
join friend ll on hh.ID = ll.ID1
where ll.ID1 not in (
select l.ID1 from friend l
join highschooler h2 on l.ID2 = h2.ID
join highschooler h1 on l.ID1 = h1.ID
where h2.grade <> h1.grade)
order by 2,1

/* Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
*/
select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade from
likes l left join friend f on 
f.Id1 = l.Id1 and f.id2= l.id2 
join friend ff1 on
ff1.id1 = l.id1 
join friend ff2 on
ff1.id2 = ff2.id1 
join highschooler h1 on h1.id = l.id1 
join highschooler h2 on h2.id = l.id2
join highschooler h3 on h3.id = ff1.id2
where ff2.id2= l.id2 and f.id1 is null

/*Q8 Find the difference between the number of students in the school and the number of different first names. 
*/
select abs(count(id) - count( distinct name)) 
from highschooler

/* Q9 Find the name and grade of all students who are liked by more than one other student. 
*/
select name, grade from highschooler
join likes on likes.ID2 = highschooler.ID
group by likes.ID2
having count(likes.ID1) > 1

/* Q10 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
*/
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade 
from likes l1 join
likes l2 on l1.id2= l2.id1 and l2.id2<> l1.id1
join highschooler h1 on h1.id = l1.id1 
join highschooler h2 on h2.id = l1.id2
join highschooler h3 on h3.id = l2.id2

/* Q11 Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
*/
select distinct name, grade from highschooler
where id not in
( select f.id1 from friend f 
  join highschooler h1 on h1.id = f.id1
  join highschooler h2 on h2.id = f.id2
  where h1.grade = h2.grade)
  
/* Q12 What is the average number of friends per student? (Your result should be just one number.) 
*/
select count(id1)*1.0/count(distinct id1) from friend

/* Q13 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
*/
select count(distinct ss.cnt) from 
(select id2 cnt from friend f1 where id1=1709
union
select ff2.id2 from friend ff1 
join friend ff2 on ff1.id2 = ff2.id1 and ff2.id2<>ff1.id1
where ff1.id1=1709
) ss

/* Q14 Find the name and grade of the student(s) with the greatest number of friends. 
*/
select name, grade from friend
join highschooler h on h.id=friend.id1
group by friend.id1
having count(friend.id1) in 
(select max(ff.cnt) 
  from (select count(f.id1) cnt from friend f group by f.id1) ff)
  
/* Q15 It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
*/
delete from Highschooler
where grade = 12;

/* Q16 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
*/
DELETE FROM Likes
WHERE ID1 IN (SELECT L.ID1
                       FROM Friend F,Likes L
                       WHERE F.ID1 = L.ID1 AND F.ID2 = L.ID2
                       AND L.ID1 NOT IN (SELECT L.ID1
                                         FROM Likes l2
                                         WHERE l2.ID1=L.ID2 AND l2.ID2=L.ID1))
                                         
/* Q17 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) 
*/
insert into friend
select f1.id1, f2.id2 
from friend f1 join friend f2 
on f1.id2 = f2.id1 and f1.id1 <> f2.id2
except 
select * from friend f
