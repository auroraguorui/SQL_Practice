/* Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema: 

Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
*/
