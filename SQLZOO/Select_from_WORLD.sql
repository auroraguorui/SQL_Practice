
# TABLE:  WORLD #
# +-------------+------------+---------+------------+--------------+
# | name        | continent  |    area | population | gdp          |
# +-------------+------------+---------+------------+--------------+
# | Afghanistan | Asia       |  652230 | 25500100   |  20343000000 |
# | Albania     | Europe     |   28748 |  2831741   |  12960000000 |
# | Algeria     | Africa     | 2381741 | 37100000   | 188681000000 |
# | Andorra     | Europe     |     468 |    78115   |   3712000000 |
# +-------------+------------+---------+------------+--------------+

-- # 1. Read the notes about this table. Observe the result of running
-- # a simple SQL command.
SELECT name, continent, population
FROM world;

-- # 2. Show the name for the countries that have a population of at
-- # least 200 million. (200 million is 200000000, there are eight
-- # zeros)
SELECT name
FROM world
WHERE population > 200000000;

-- # 3. Give the name and the per capita GDP for those countries with a
-- # population of at least 200 million.
SELECT name, gdp/population
FROM world
WHERE population > 200000000;

-- # 4. Show the name and population in millions for the countries of
-- # 'South America' Divide the population by 1000000 to get population
-- # in millions.
SELECT name, population/1000000
FROM world
WHERE continent = 'South America';

-- # 5. Show the name and population for 'France', 'Germany', 'Italy'
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- # 6. Identify the countries which have names including the word
-- # 'United'
SELECT name
FROM world
WHERE name LIKE 'United%';
