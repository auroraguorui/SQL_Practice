# TABLE: STATION #
# +--------+--------------+
# | Field  | Type         |
# +--------+--------------+
# | ID     | NUMBER       |
# | CITY   | VARCHAR2(21) |
# | STATE  | VARCHAR2(21) |
# | LAT_N  | NUMBER       |
# | LONG_W | NUMBER       |
# +--------+--------------+

-- # 1. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of
--      characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY)     , CITY LIMIT 1 ; 
SELECT CITY, LENGTH(CITY) FROM STATION ORDER BY LENGTH(CITY) DESC, CITY LIMIT 1;

-- # 2. Query the list of CITY names starting with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY REGEXP '^[AEIOUaeiou]';

-- # 3. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY REGEXP  '[AEIOUaeiou]$';

-- # 4. Query the list of CITY names from STATION which have vowels as both their first and last characters. Your result cannot contain duplicates.
SELECT CITY 
FROM STATION 
WHERE CITY RLIKE '^[AEIOUaeiou].*[AEIOUaeiou]$';

-- # 5. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT distinct city 
FROM station 
WHERE city not rlike '^[AEIOUaeiou]';

-- # 6. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
SELECT distinct CITY 
FROM STATION 
WHERE CITY NOT RLIKE '[AEIOUaeiou]$';

-- # 7. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY 
FROM STATION 
WHERE NOT (CITY  RLIKE '^[AEIOUaeiou]' AND CITY  RLIKE '[AEIOUaeiou]$');

-- # 8. Query the list of CITY names from STATION that do not start and end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT city 
FROM station 
WHERE city NOT rLIKE '^[AEIOUaeiou]' AND city NOT rLIKE '[AEIOUaeiou]$';

-- # 9. Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT Name 
FROM STUDENTS
WHERE Marks > 75
ORDER BY SUBSTR(Name,-3,3),ID;
