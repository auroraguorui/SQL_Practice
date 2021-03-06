# TABLE: #
# +-------+---------+
# | stops | ruote   | 
# +-------+---------+
# | id    | num     | 
# | name  | company |  
# | pos   | ord     |  
# | stop  |         |     
# +-------+---------+

-- # 1. How many stops are in the database.
SELECT COUNT(*)
FROM stops;

-- # 2. Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- # 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT stops.id, stops.name
FROM route
JOIN stops
ON route.stop = stops.id
WHERE route.num = 4
AND route.company = 'LRT';

-- # 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice
--      the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num
FROM route
WHERE stop IN (149, 53)
GROUP BY company, num
HAVING COUNT(*) = 2;

-- # 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart. Change the query so
--   that it shows the services from Craiglockhart to London Road.
SELECT r1.company, r1.num, r1.stop, r2.stop
FROM route AS r1
JOIN route AS r2
ON (r1.company = r2.company)
AND (r1.num = r2.num)
WHERE r1.stop = 53
AND r2.stop = 149;

-- # 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by
--   name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are
--   tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT r1.company, r1.num, s1.name, s2.name
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1
ON r1.stop = s1.id
JOIN stops AS s2
ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart'
AND s2.name = 'London Road';

-- # 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT r1.company, r2.num
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
WHERE r1.stop = 115
AND r2.stop = 137;

-- # 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT r1.company, r1.num, s1.name, s2.name
FROM route AS r1
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1
ON r1.stop = s1.id
JOIN stops AS s2
ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart'
AND s2.name = 'Tollcross';

-- # 9. Give a list of the stops which may be reached from 'Craiglockhart' by taking one bus. Include the details of the appropriate service.
select stops.name, route.company, route.num
from stops 
join route on stops.id = route.stop
join route b on route.company = b.company and route.num = b.num
where route.company = 'LRT' and b.stop = 53

-- # 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill. Show the bus no. and company for 
--       the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.
select distinct a.num, a.company, sb.name, c.num, c.company
from route a
join route b on a.company = b.company and a.num = b.num
join route c on b.stop = c.stop 
join route d on c.company = d.company and c.num = d.num
join stops sb on b.stop = sb.id
where a.stop = 53 and d.stop = 213

SELECT DISTINCT aaa.num, aaa.company, stops.name AS name, bbb.num, bbb.company FROM 
(SELECT a.company, a.num, a.stop, b.stop AS tran1 FROM route a JOIN route b ON a.num = b.num AND a.company = b.company) AS aaa
JOIN 
(select c.company, c.num, c.stop, d.stop AS tran2 FROM route c JOIN route d ON c.num = d.num AND c.company = d.company) AS bbb
ON aaa.tran1 = bbb.tran2
JOIN stops ON aaa.tran1 = stops.id
WHERE aaa.stop = 53 AND bbb.stop = 213
JOIN route AS r2
ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1
ON r1.stop = s1.id
JOIN stops AS s2
ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart';
