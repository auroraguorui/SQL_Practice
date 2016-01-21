-- # http://sqlzoo.net/wiki/Functions_Reference 
-- # http://a4academics.com/interview-questions/53-database-and-sql/397-top-100-database-sql-interview-questions-and-answers-examples-queries

-- # 1. Concatenate strings.
--      Concatenation means "stick strings together". In this example we concatenate three strings, name and region are string 
--      attributes of the table, ' is in ' is a string literal.
SELECT CONCAT(name, ' is in ', region)
FROM bbc
WHERE name LIKE 'D%'

-- # 2. Substring: Extracting part of a string.
--      We from position 1 (the beginning) we take two characters. 4.
--      'Afghanistan' -> 'Af'
--      'China'       -> 'Ch'
--      'Sri Lanka'   -> 'Sr'
SELECT name, SUBSTRING(name FROM 1 FOR 2)
FROM bbc

-- # 3. Lower cases. UPPER CASE is similar.
SELECT LOWER(name) FROM bbc
WHERE UPPER(region) = 'SOUTH AMERICA'

-- # 4. Finding a substring in a string. Here we extract the first word of a country name. INSTR gives this position of one string 
--      within another, we use this and substring to pick out the first few characters.
SELECT name,
  POSITION(' ' IN name),
  SUBSTRING(name FROM 1 FOR POSITION(' ' IN name))
FROM bbc
WHERE name LIKE '% %'

-- # 5. This rounds up or down
SELECT name, population, ROUND(population/1000000,2), ROUND(population,-6)
FROM bbc
WHERE region='North America'

-- # 6. Replace a NULL with a specific value. The SQL standard is COALESCE
SELECT code, name,
  COALESCE(leader, 'NO LEADER RECORDED!')
FROM party

-- # 7. Conditional values, The SQL Standard is the CASE statement
SELECT title, score,
    CASE WHEN score>8.5 THEN 'Excellent'
        ELSE 'OK'
    END
FROM movie
WHERE 10>id

-- The IF function is also available:
SELECT title, score, IF(score>8.5,'Excellent','OK')
FROM movie

-- # 8. Get the current date and/or time. SQL Standard specifies CURRENT_TIMESTAMP, CURRENT_DATE and CURRENT_TIME.
SELECT CURRENT_TIMESTAMP, CURRENT_DATE, CURRENT_TIME
FROM nix

-- # 9. Format a date and time. Many engines support the SQL standard - see Mimer for details.
SELECT DATE_FORMAT(wk,'%d/%m/%Y'), song
FROM totp
WHERE singer='Tom Jones'

-- # 10. ABS returns the absolute value. The output is positive even if the input is negative:
--       ABS(x) =  x if x >= 0
--       ABS(x) = -x if x <  0
--       ABS can be useful for testing values that are "close". For example this query shows each country that has area that 
--       is roughly 70 thousand. The value 70000 is the target value, 500 is the "tolerance" so the test ABS(area-70000)<500 
--       tests that the area is between 70000-500 and 70000+500. That is 69500 < area < 70500
SELECT name, area 
FROM bbc
WHERE ABS(area-70000) < 500

-- # 11. CAST allows you to convert from one type to another. If you concatenate a string with a number the number will 
--       be automatically changed to a string. However sometimes you need to make the CAST explicit.
--       CAST(expr TO type) 
--       In this example we get the population in millions by casting the floating point value to DECIMAL(8,1) 
--       this ensures one decimal place of accuracy. You can also CAST a date to a string to extract components using SUBSTRING 
--       or make up another date.
SELECT CAST(population/1000000 AS DECIMAL(8,1)) AS a, population/1000000 AS b
FROM bbc

-- # 12. CEIL
--       CEIL(f) is ceiling, it returns the integer that is equal to or just more than f
--       CEIL(f) give the integer that is equal to, or just higher than f. CEIL always rounds up.
--       CEIL(2.7)  ->  3
--       CEIL(-2.7) -> -2
--       FLOOR(f) returns the integer value of f
SELECT population/1000000 AS a,
  CEIL(population/1000000) AS b
FROM bbc

-- # 13. COS(f) returns the cosine of f where f is in Degrees.
--       COS(3.14159/3) -> -1.0 
SELECT id, angle, COS(angle)
FROM angle

-- # 14. CURRENT_DATE returns today's date.
SELECT CAST(CURRENT_DATE AS DATE), wk
FROM totp

-- # 15. CURRENT_TIMESTAMP returns the current date and time.
SELECT CURRENT_TIMESTAMP, whn
FROM eclipse

-- # 16. DATEPART allows you to retrieve components of a date. You can extract also YEAR, MONTH, DAY, HOUR, MINUTE, SECOND.
--       DATEPART(YEAR,   d)  DATEPART(MONTH,  d)
--       DATEPART(DAY,    d)  DATEPART(HOUR,   d)
--       DATEPART(MINUTE, d)  DATEPART(SECOND, d)
SELECT whn
    ,EXTRACT(YEAR FROM td)  AS yr
    ,EXTRACT(MONTH FROM td) AS mnth
FROM eclipse

-- # 17. DAY allows you to retrieve the day from a date.
SELECT DAY(whn) AS v
      ,whn
      ,wht
FROM eclipse

-- # 18. a DIV b returns the integer value of a divided by b.
--       8 DIV 3 -> 2  
SELECT name, population DIV 1000000
FROM bbc

-- # 19. EXTRACT allows you to retrieve components of a date. You can extract also YEAR, MONTH, DAY, HOUR, MINUTE, SECOND.
--       EXTRACT(YEAR FROM d)    EXTRACT(MONTH FROM d)
--       EXTRACT(DAY FROM d)     EXTRACT(HOUR FROM d)
--       EXTRACT(MINUTE FROM d)  EXTRACT(SECOND FROM d)
SELECT whn
  ,EXTRACT(YEAR FROM td)  AS yr
  ,EXTRACT(HOUR FROM td)  AS hr
FROM eclipse

-- # 20. HOUR allows you to retrieve the hour from a datetime.
SELECT HOUR(whn) AS v, whn, wht
FROM eclipse

-- # 21. IFNULL takes two arguments and returns the first value that is not null.
--       IFNULL(x,y) = x if x is not NULL
--       IFNULL(x,y) = y if x is NULL
SELECT name, party,IFNULL(party,'None') AS aff
FROM msp WHERE name LIKE 'C%'

-- # 22. INSTR(s1, s2) returns the character position of the substring s2 within the larger string s1. 
--       The first character is in position 1. If s2 does not occur in s1 it returns 0.
--       INSTR('Hello world', 'll') -> 3 
SELECT name,
    INSTR(name, 'an')
FROM bbc

-- # 23. LEFT(s,n) allows you to extract n characters from the start of the string s.
--       LEFT('Hello world', 4) -> 'Hell'     
SELECT name,
    LEFT(name, 3)
FROM bbc

-- # 24. LEN(s) returns the number of characters in string s.
SELECT LENGTH(name), name
FROM bbc

-- # 25. LENGTH(s) returns the number of characters in string s. 
--       LENGTH('Hello') -> 5 
SELECT LENGTH(name), name
FROM bbc

-- # 26. MINUTE allows you to retrieve the minute from a date.
SELECT MINUTE(whn) AS v, whn, wht
FROM eclipse

-- # 27. MOD(a,b) returns the remainder when a is divied by b
--       If you use MOD(a, 2) you get 0 for even numbers and 1 for odd numbers.
--       If you use MOD(a, 10) you get the last digit of the number a.
--       MOD(27,2) ->  1
--       MOD(27,10) ->  7
SELECT MOD(yr,10), yr, city
FROM games

-- # 28. MONTH allows you to retrieve the month from a date.
SELECT MONTH(whn) AS v, whn, wht
FROM eclipse

-- # 29. NULLIF returns NULL if the two arguments are equal; otherwise NULLIF returns the first argument.
--       NULLIF(x,y) = NULL if x=y
--       NULLIF(x,y) = x if x != y  
SELECT name, party
  ,NULLIF(party,'Lab') AS aff
FROM msp 
WHERE name LIKE 'C%'

-- # 30. NVL takes two arguments and returns the first value that is not null. NVL can be useful when you want 
--      to replace a NULL value with some other value. In this example you show the name of the party for each MSP that has a party. 
--      For the MSP with no party (such as Canavan, Dennis) you show the string None.
--       NVL(x,y) = x if x is not NULL
--       NVL(x,y) = y if x is NULL
SELECT name, party
  ,COALESCE(party,'None') AS aff
FROM msp 
WHERE name LIKE 'C%'

-- # 31. PATINDEX('%s1%', s2) returns the character position of the substring s1 within the larger string s2. 
--       The first character is in position 1. If s1 does not occur in s2 it returns 0. The match is case insensitive.
--       PATINDEX('%ll%' 'Hello world') -> 3  
SELECT name,
  POSITION('an' IN name)
FROM bbc

-- # 32. % (Modulo)
--       a % b returns the remainder when a is divied by b
--       If you use a % 2 you get 0 for even numbers and 1 for odd numbers.
--       If you use a % 10 you get the last digit of the number a.
--       27 % 2  ->  1
--       27 % 10 ->  7

-- # 33. + (dates)
--       d + i returns the date i days after the date d.
--       DATE '2006-05-20' + 7  -> DATE '2006-05-27'
SELECT whn, whn+7 
FROM eclipse

-- # 33. + INTERVAL. d + INTERVAL i DAY returns the date i days after the date d. 
--       You can also add YEAR, MONTH, DAY, HOUR, MINUTE, SECOND. You can also add a negative value.
--       DATE '2006-05-20' + INTERVAL 5 DAY   -> DATE '2006-05-25' 
--       DATE '2006-05-20' + INTERVAL 5 MONTH -> DATE '2006-10-20' 
--       DATE '2006-05-20' + INTERVAL 5 YEAR  -> DATE '2011-05-20' 
SELECT whn, whn + INTERVAL 7 DAY
FROM eclipse

-- # 34. + (strings). + allows you to stick two or more strings together. This operation is concatenation.
SELECT CONCAT(region,name)
FROM bbc  

-- # 35. POSITION(s1 IN s2) returns the character position of the substring s1 within the larger string s2. The first character is in position 1. If s1 does not occur in s2 it returns 0.
--       POSITION('ll' IN 'Hello world') -> 3 
SELECT name, POSITION('an' IN name)
FROM bbc

-- # 36. QUARTER allows you to retrieve the 3 month period from a date. 
SELECT wk, QUARTER(wk) AS Quarter, song
FROM totp
WHERE singer = 'Cliff Richard'
ORDER BY wk DESC

-- # 37. RANK() OVER (ORDER BY f DESC) returns the rank position relative to the expression f.
SELECT name, 
RANK() OVER (ORDER BY population DESC)
FROM world
WHERE population > 180000000
-- note: only sqlserver and oracle has this function

-- # 38. RIGHT(s,n) allows you to extract n characters from the end of the string s.
--       RIGHT('Hello world', 4) -> 'orld'      
SELECT name, RIGHT(name, 3)
FROM bbc

-- # 39. SECOND allows you to retrieve the second from a date.
SELECT SECOND(whn) AS v, whn, wht
FROM eclipse

-- # 40. SIN(f) returns the sine of f where f is in radians.
SELECT id, angle, SIN(angle)
FROM angle

-- # 41. SUBSTR allows you to extract part of a string. SUBSTRING the same
--       SUBSTR('Hello world', 2, 3) -> 'ell'    
SELECT name,
  SUBSTR(name, 2, 5)
FROM bbc

-- # 42. SUBSTRING allows you to extract part of a string.
--       SUBSTRING('Hello world' FROM 2 FOR 3) -> 'ell'    
SELECT name,
  SUBSTRING(name FROM 2 FOR 5)
FROM bbc

-- # 43. TAN(f) returns the tangent of f where f is in radians.
SELECT id, angle, TAN(angle)
FROM angle

-- # 44. TO_CHAR allows you to convert a date to a string using a variety of formats.
--       TO_CHAR(d, 'YYYY') -> Four digit year
--       TO_CHAR(d, 'MM')   -> Two digit month
--       TO_CHAR(d, 'DD')   -> Two digit day
--       TO_CHAR(d, 'HH24') -> Two digit hour
--       TO_CHAR(d, 'MI')   -> Two digit minutes
--       TO_CHAR(d, 'MON')  -> Three character month
SELECT EXTRACT(YEAR FROM whn) AS v, whn, wht
FROM eclipse

-- # 45. TRIM(s) returns the string with leading and trailing spaces removed.
--       TRIM('Hello world  ') -> 'Hello world'. This function is particularly useful when working with CHAR fields. Typically a CHAR field is paddded with spaces. In contrast a VARCHAR field does not require padding.
SELECT name, TRIM(name)
FROM bbc

-- # 46. YEAR allows you to retrieve the year from a date.
SELECT YEAR(whn) AS v, whn, wht
FROM eclipse




