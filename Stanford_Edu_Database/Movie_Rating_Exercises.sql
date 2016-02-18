/* You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. 
# There's not much data yet, but you can still try out some interesting queries. Here's the schema: 

# Movie ( mID, title, year, director ) 
# English: There is a movie with ID number mID, a title, a release year, and a director. 

# Reviewer ( rID, name ) 
# English: The reviewer with ID number rID has a certain name. 

# Rating ( rID, mID, stars, ratingDate ) 
# English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 

# Your queries will run over a small data set conforming to the schema. View the database. (You can also download the schema and data.) 
*/

----------------------------------------------------------------------------------------------------------------------------------------
/* Q1 Find the titles of all movies directed by Steven Spielberg. */
SELECT title 
FROM Movie 
WHERE director = "Steven Spielberg";

/* Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. */
SELECT distinct year 
FROM Movie 
JOIN Rating ON Rating.Mid = Movie.Mid
WHERE stars > 3
ORDER BY year;

/* Q3 Find the titles of all movies that have no ratings. */
SELECT title 
FROM Movie 
LEFT JOIN Rating ON Movie.Mid = Rating.Mid
WHERE stars IS NULL;

/* Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers 
   who have ratings with a NULL value for the date. */
SELECT distinct name 
FROM Reviewer 
JOIN Rating ON Rating.rid = Reviewer.riD
WHERE Rating.ratingDate IS NULL;

/* Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, 
and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT Reviewer.name, title , stars, ratingDate 
FROM Reviewer JOIN Rating ON Rating.rid = reviewer.rid 
JOIN Movie ON Movie.mid = Rating.Mid
ORDER BY Reviewer.name, title, stars;

/* Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
return the reviewer's name and the title of the movie. */
SELECT reviewer.name, movie.title 
FROM rating r1 
JOIN rating r2 ON r1.rid = r2.rid AND r1.mid = r2.mid AND r1.ratingdate < r2.ratingdate AND r1.stars< r2.stars
JOIN reviewer ON reviewer.rid = r1.rid 
JOIN movie ON movie.mid = r1.mid;

/* Q7 For each movie that has at least one rating, find the highest number of stars that movie received. 
Return the movie title and number of stars. Sort by movie title. */
SELECT title, MAX(stars) 
FROM rating 
JOIN movie ON movie.mid = rating.mid
GROUP BY rating.mid 
HAVING COUNT(rating.mid) > 1
ORDER BY title;

/* Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest
ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
SELECT title, MAX(stars)-MIN(stars)
FROM rating JOIN movie ON
movie.mid = rating.mid
GROUP BY rating.mid
ORDER BY 2 DESC, title;

/* Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
 (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
  Don't just calculate the overall average rating before and after 1980.) */
SELECT abs(
  (SELECT AVG(a.av1) 
   FROM (
    SELECT AVG(stars) av1 
    FROM rating
    JOIN movie ON movie.mid = rating.mid
    WHERE year < 1980
    GROUP BY rating.mid 
    ) a
  )
  - 
  (SELECT avg(a2.av2) 
   FROM (
    SELECT AVG(stars) av2 
    FROM rating 
    JOIN movie ON movie.mid = rating.mid
    WHERE year > 1980
    GROUP BY rating.mid
    ) a2
  )
)

/* Q10 Find the names of all reviewers who rated Gone with the Wind. */
SELECT distinct r.name 
FROM reviewer r
JOIN rating ON rating.rid = r.rid
JOIN movie ON movie.mid = rating.mid

/* Q11 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, 
  movie title, and number of stars. where movie.title = "Gone with the Wind" */
SELECT r.name, m.title, ra.stars
FROM reviewer r 
JOIN rating ra ON r.rid = ra.rid
JOIN movie m ON m.mid = ra.mid
WHERE r.name = m.director

/* Q12 Return all reviewer names and movie names together in a single list, alphabetized. 
(Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing 
on last names or removing "The".) */
SELECT name 
FROM reviewer 
UNION 
SELECT title 
FROM movie 
ORDER BY name,title

/* Q13 Find the titles of all movies not reviewed by Chris Jackson. */
SELECT title 
FROM movie 
WHERE movie.mid not in
  (
   SELECT r.mid 
   FROM rating r
   JOIN reviewer ON reviewer.rid = r.rid
   WHERE reviewer.name = "Chris Jackson"
  )
  
/* Q14 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers.
Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, 
return the names in the pair in alphabetical order. */
SELECT distinct ra1.name, ra2.name 
FROM rating r1 
JOIN rating r2 ON r1.mid = r2.mid AND ra1.name < ra2.name
JOIN reviewer ra1 ON r1.rid = ra1.rid
JOIN reviewer ra2 ON r2.rid = ra2.rid
ORDER BY 1,2

/* Q15 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name,
movie title, and number of stars. */
SELECT name, title, stars 
FROM rating ra 
JOIN reviewer r ON r.rid = ra.rid
JOIN movie ON movie.mid = ra.mid
WHERE ra.stars in 
  (
   SELECT min(rr.stars) FROM rating rr 
  )

/* Q16 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the 
same average rating, list them in alphabetical order. */
SELECT title, AVG(stars) 
FROM rating ra 
JOIN movie m ON m.mid = ra.mid
GROUP BY ra.mid
ORDER BY 2 DESC, 1

/* Q17 Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT distinct name 
FROM reviewer 
JOIN rating ON reviewer.rid=rating.rid
GROUP BY rating.rid 
HAVING COUNT(rating.stars) > 2

/* Q18 Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) */
SELECT title, director 
FROM movie 
WHERE director in
  (
   SELECT distinct director 
   FROM movie 
   GROUP BY director 
   HAVING COUNT(title) > 1
  )
ORDER BY director, title

/* Q19 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
(Hint: This query is more difficult to write in SQLite than other systems; you might think of it as 
finding the highest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, AVG(ra.stars) 
FROM movie m 
JOIN rating ra ON ra.mid=m.mid
GROUP BY title
HAVING AVG(ra.stars) in
  (
   SELECT MAX(aa.av) 
   FROM 
   (
    SELECT AVG(ra2.stars) av 
    FROM rating ra2 
    GROUP BY ra2.mid
    ) aa
  )
  
/* Q20 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
(Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as 
finding the lowest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, AVG(ra.stars) 
FROM rating ra 
JOIN movie m ON m.mid = ra.mid
GROUP BY ra.mid
HAVING AVG(ra.stars) IN
  ( 
   SELECT MIN(ra2.av) 
   FROM 
   ( 
    SELECT AVG(stars) av 
    FROM rating 
    GROUP BY rating.mid
    ) ra2
  )

/* Q21 For each director, return the director's name together with the title(s) of the movie(s) 
they directed that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL. */
SELECT distinct director, title , ra.stars
FROM movie m 
JOIN rating ra ON  ra.mid=m.mid
WHERE ra.stars in 
  ( 
   SELECT MAX(ra2.stars) mm 
   FROM rating ra2 
   JOIN movie m2 ON m2.mid = ra2.mid
   WHERE m2.director = m.director 
  )
  
/* Q22 Add the reviewer Roger Ebert to your database, with an rID of 209. */
INSERT INTO reviewer values (209, "Roger Ebert")

/* Q23 Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into rating 
select r.rid, m.mid, 5, NULL
from movie m , rating r 
join reviewer re on re.rid=r.rid
where re.name = "James Cameron"

/* Q24 For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
(Update the existing tuples; don't insert new tuples.) */
update movie 
set year = year + 25
where mid in 
  (select r.mid from rating r group by r.mid having avg(r.stars) >= 4)
  
/* Q25 Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
delete from rating 
where mid in 
  (select m.mid from movie m 
   where m.year < 1970 or m.year > 2000 ) 
  and stars < 4
