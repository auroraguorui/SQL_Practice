# TABLE: OCCUPATIONS # Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

# +------------+--------+
# | Column     | Type   |
# +------------+--------+
# | Name       | String |
# | Occupation | String |
# +------------+--------+
Occupation String
-- # 1. Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a
--      parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
--      sample output: Ashely(P)
--                     Christeen(P)
--                     Jane(A)
--                     Jenny(D)
SELECT CONCAT(Name,'(',SUBSTR(Occupation,1,1),')') AS Name
FROM occupations
ORDER BY Name;

