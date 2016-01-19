-- # 1. Get a list of all tables
SHOW TABLES;

-- # 2. What are the columns of the bbc table
SHOW COLUMNS FROM bbc;

-- # 3. Get the first 10 rows of the bbc table.
SELECT * FROM bbc LIMIT 10

-- # 4. Get the 11th to the 20th rows of the bbc table - by population.
SELECT * FROM bbc
ORDER BY population DESC
LIMIT 11, 10

-- # 5. What version of the software am I using?
SELECT version();

-- # 6. What is the syntax to view structure of table?
SHOW COLUMNS FROM bbc;

-- # 7. How can you determine the primary key using SQL?
CREATE TABLE cia (name VARCHAR(10) PRIMARY KEY,
                 population INTEGER)
CREATE TABLE casting(movieid INTEGER,
                    actorid INTEGER,
                    PRIMARY KEY (movieid, actorid)
                    )
DESCRIBE casting

-- # 8. Return a sequential record count for all records returned
DROP TABLE numbered_bbc;
CREATE TABLE numbered_bbc
  (counter INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
  ,name VARCHAR(50)
  ,region VARCHAR(60)
  ,area DECIMAL(10,0)
  ,population DECIMAL(11,0)
  ,gdp DECIMAL(14,0)
  );
INSERT INTO numbered_bbc (name, region, area, 
                          population,gdp)
SELECT name, region, area, population, gdp
  FROM gisq.bbc;
SELECT * FROM numbered_bbc
