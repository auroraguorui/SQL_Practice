# TABLE: world #
# +-------------+------------+---------+------------+--------------+
# | name        | continent  |    area | population | gdp          |
# +-------------+------------+---------+------------+--------------+
# | Afghanistan | Asia       |  652230 | 25500100   |  20343000000 |
# | Albania     | Europe     |   28748 |  2831741   |  12960000000 |
# | Algeria     | Africa     | 2381741 | 37100000   | 188681000000 |
# | Andorra     | Europe     |     468 |    78115   |   3712000000 |
# +-------------+------------+---------+------------+--------------+

-- # 1. List each country name where the population is larger than 'Russia'.
SELECT name
FROM world
WHERE population > (
  SELECT population
  FROM world
  WHERE name = 'Russia');

-- # 2. List the name and continent of countries in the continents containing 'Belize', 'Belgium'.
SELECT name, continent
FROM world
WHERE continent IN (
  SELECT continent 
  FROM world
  WHERE name IN ('Belize', 'Belgium'));

-- # 3. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
WHERE continent = 'Europe'
AND gdp/population > (
  SELECT gdp/population
  FROM world
  WHERE name = 'United Kingdom');

-- # 4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
FROM world
WHERE population > (
  SELECT population
  FROM world
  WHERE name = 'Canada')
AND population < (
  SELECT population
  FROM world
  WHERE name = 'Poland');

-- # 5. Which countries have a GDP greater than any country in Europe? [Give the name only.]
SELECT name
FROM world
WHERE gdp > (
  SELECT MAX(gdp)
  FROM world
  WHERE continent = 'Europe');

-- # 6. Find the largest country (by area) in each continent, show the 
-- # continent, the name and the area.
SELECT x.continent, x.name, x.area
FROM world AS x
WHERE x.area = (
  SELECT MAX(y.area)
  FROM world AS y
  WHERE x.continent = y.continent)

-- # 7. Find each country that belongs to a continent where all populations are less than 25000000. Show name, continent and population.
SELECT name, continent, population 
FROM world
WHERE continent in (
  SELECT continent 
  FROM world
  GROUP BY continent
  HAVING max(population) <= 25000000)
  
SELECT x.name, x.continent, x.population
FROM world AS x
WHERE 25000000 > ALL (
  SELECT y.population
  FROM world AS y
  WHERE x.continent = y.continent);

-- # 8. Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT x.name, x.continent
FROM world AS x
WHERE x.population/3 > ALL (
  SELECT y.population
  FROM world AS y
  WHERE x.continent = y.continent
  AND x.name != y.name);
  
-- # 9. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. 
--      Show name, continent and population.
SELECT name, continent, population 
FROM world x
WHERE 25000000 >= all(
  SELECT population 
  FROM world y 
  WHERE x.continent = y.continent);
  
-- # 10. Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent 
FROM world x
WHERE population > all(
  SELECT 3*population FROM world y WHERE x.continent = y.continent AND x.name != y.name)
