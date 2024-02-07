USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
USE imdb;

SELECT Count(*) AS total_rows_in_director_mapping
FROM   director_mapping;

SELECT Count(*) AS total_rows_in_genre
FROM   genre;

SELECT Count(*) AS total_rows_in_movie
FROM   movie;

SELECT Count(*) AS total_rows_in_names
FROM   names;

SELECT Count(*) AS total_rows_in_ratings
FROM   ratings;

SELECT Count(*) AS total_rows_in_role_mapping
FROM   role_mapping; 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- We are finding the names of all coulumns from the movie table which has null_values in their records 
-- and we are using union to get the names of all columns
USE imdb;

SELECT DISTINCT column_with_null
FROM   (SELECT 'id' AS Column_With_Null
        FROM   movie
        WHERE  id IS NULL
        UNION ALL
        SELECT 'title' AS Column_With_Null
        FROM   movie
        WHERE  title IS NULL
        UNION ALL
        SELECT 'year' AS Column_With_Null
        FROM   movie
        WHERE  year IS NULL
        UNION ALL
        SELECT 'date_published' AS Column_With_Null
        FROM   movie
        WHERE  date_published IS NULL
        UNION ALL
        SELECT 'duration' AS Column_With_Null
        FROM   movie
        WHERE  duration IS NULL
        UNION ALL
        SELECT 'country' AS Column_With_Null
        FROM   movie
        WHERE  country IS NULL
        UNION ALL
        SELECT 'worlwide_gross_income' AS Column_With_Null
        FROM   movie
        WHERE  worlwide_gross_income IS NULL
        UNION ALL
        SELECT 'languages' AS Column_With_Null
        FROM   movie
        WHERE  languages IS NULL
        UNION ALL
        SELECT 'production_company' AS Column_With_Null
        FROM   movie
        WHERE  production_company IS NULL) AS Null_Columns; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
USE imdb;

SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

-- next part
USE imdb;

SELECT Extract(month FROM date_published) AS month_num,
       Count(id)                          AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
USE imdb;

SELECT year,
       Count(id)
FROM   movie
WHERE  ( country LIKE '%India%'
          OR country LIKE '%USA%' )
       AND year = '2019';

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
USE imdb;
SELECT DISTINCT(genre) FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
USE imdb;

SELECT g.genre,
       Count(g.movie_id) AS no_of_movies
FROM   genre AS g,
       movie AS m
WHERE  g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY no_of_movies DESC
LIMIT  1; 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
USE imdb;

SELECT Count(movie_id) AS no_of_movies
FROM   genre
WHERE  movie_id IN (SELECT movie_id
                    FROM   genre
                    GROUP  BY movie_id
                    HAVING Count(genre) = 1);

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
USE imdb;

SELECT g.genre,
       Avg(m.duration)
FROM   genre AS g,
       movie AS m
WHERE  g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY g.genre; 

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
USE imdb;

SELECT genre,
       Count(movie_id)                    AS movie_count,
       Rank()
         OVER (
           partition BY genre
           ORDER BY Count(movie_id) DESC) AS 'genre_rank'
FROM   genre
GROUP  BY genre
HAVING genre = 'thriller'; 

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
USE imdb;

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
USE imdb;

SELECT   m.title                                  AS title,
         r.avg_rating                             AS avg_rating,
         Rank() over (ORDER BY r.avg_rating DESC) AS movie_rank
FROM     movie                                    AS m,
         ratings                                  AS r
WHERE    m.id=r.movie_id
LIMIT    10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
USE imdb;

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
USE imdb;

SELECT production_company,
       movie_count,
       prod_company_rank
FROM   (SELECT m.production_company           AS production_company,
               Count(m.id)                    AS movie_count,
               Rank()
                 OVER (
                   ORDER BY Count(m.id) DESC) AS prod_company_rank
        FROM   movie AS m,
               ratings AS r
        WHERE  m.id = r.movie_id
               AND r.avg_rating > 8
               AND production_company IS NOT NULL
        GROUP  BY m.production_company)prod_house_details
WHERE  prod_company_rank = 1; 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

USE imdb;

SELECT g.genre           AS genre,
       Count(g.movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  r.total_votes > 1000
       AND m.country LIKE '%USA%'
       AND m.year = '2017'
GROUP  BY g.genre
ORDER  BY movie_count DESC; 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

USE imdb;

SELECT m.title      AS title,
       r.avg_rating AS avg_rating,
       g.genre      AS genre
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8
       AND m.title LIKE 'THE%'
ORDER  BY g.genre; 

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(id),
       median_rating
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  median_rating = 8
       AND ( date_published BETWEEN "2018-04-01" AND "2019-04-01" );  

-- OUTPUT -- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Compute the total number of votes for German and Italian movies.
-- Steps
-- 1: italian_votes : Get All languages which has string Italian and their total votes
-- 2: german_votes :  Get All languages which has string German and therir total votes
-- 3: Total_votes : Sum of all italian language vote and name them  as "Italian" in language_name column
-- 4: Total_votes : Sum of all german language vote and name them  as "German" in language_name column
/*
language_name | votes|
------------------------
Italian	      | 2559540
German	      | 4421525
------------------------
*/ 
-- 5: Order Total_votes rows by votes and limit row number to 1 to get first language with most votes
-- 6: Check if language is German or not and show output as 1 or 0 for question Do German movies get more votes than Italian movies?


WITH language_vote
AS
  (
  WITH Total_votes
AS
  (WITH italian_votes
AS
  (
             SELECT     languages,
                        sum(total_votes) AS votes
             FROM       movie            AS m
             INNER JOIN ratings          AS r
             ON         r.movie_id = m.id
             WHERE      languages LIKE '%Italian%'
             GROUP BY   languages),
  german_votes
AS
  (
             SELECT     languages,
                        sum(total_votes) AS votes
             FROM       movie            AS m
             INNER JOIN ratings          AS r
             ON         r.movie_id = m.id
             WHERE      languages LIKE '%German%'
             GROUP BY   languages)
  SELECT "Italian"  AS language_name,
         sum(votes) AS votes
  FROM   italian_votes
  UNION
  SELECT "German"   AS language_name,
         sum(votes) AS votes
  FROM   german_votes)
SELECT   language_name
FROM     Total_votes
ORDER BY votes DESC
LIMIT    1 )
SELECT IF (language_name LIKE 'GERMAN' , 'YES', 'NO') AS Answer
FROM   language_vote ;


-- Query to check if German votes > Italian votes using SELECT IF statement
-- Answer is YES if German votes > Italian votes
-- Answer is NO if German votes <= Italian votes

-- OUTPUT -- YES German languages movie has more votes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_nulls
FROM   names; 


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres
AS
  (
             SELECT     genre,
                        rank() over(ORDER BY count(m.id) DESC) AS genre_rank
             FROM       movie                                  AS m
             INNER JOIN genre                                  AS g
             ON         g.movie_id = m.id
             INNER JOIN ratings AS r
             ON         r.movie_id = m.id
             WHERE      avg_rating > 8
             GROUP BY   genre
             LIMIT      3 )
  SELECT     n.name            AS director_name ,
             count(d.movie_id) AS movie_count
  FROM       director_mapping  AS d
  INNER JOIN genre g
  USING      (movie_id)
  INNER JOIN names n
  ON         n.id = d.name_id
  INNER JOIN top_3_genres
  USING      (genre)
  INNER JOIN ratings
  USING      (movie_id)
  WHERE      avg_rating > 8
  GROUP BY   name
  ORDER BY   movie_count DESC
  LIMIT      3 ;

-- OUTPUT --
/*  director_name   movie_count
----------------------------------
	James Mangold	4
	Anthony Russo	3
	Soubin Shahir	3
----------------------------------
*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping rm
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r 
			   USING(movie_id)
       INNER JOIN names n
               ON n.id = rm.name_id
WHERE  r.median_rating >= 8
       AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;

-- OUTPUT -- 
/*  actor_name  movie_count
	Mammootty	8
	Mohanlal	5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Approach 1: Using select statement 
SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() over(ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS m
INNER JOIN ratings                                     AS r
ON         r.movie_id = m.id
GROUP BY   production_company
LIMIT      3;

-- Approach 2: using CTEs for prod_comp_ranking and taking top 3
WITH prod_comp_ranking
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON r.movie_id = m.id
         GROUP  BY production_company)
SELECT production_company,
       vote_count,
       prod_comp_rank
FROM   prod_comp_ranking
WHERE  prod_comp_rank <= 3; 

-- OUTPUT --
/*  
	production_company      vote_count  prod_comp_rank
----------------------------------------------------------
	Marvel Studios	        2656967	    1
	Twentieth Century Fox	2411163	    2
	Warner Bros.	        2396057	    3
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Ranking actors and taking top 3. 
SELECT     name                                                                             AS actor_name,
           Sum(total_votes)                                                                 AS total_votes,
           Count(m.id)                                                                      AS movie_count,
           Round(Sum(avg_rating * total_votes)/ Sum(total_votes),2)                         AS actor_avg_rating,
           Rank() over(ORDER BY round(sum(avg_rating*total_votes)/sum(total_votes),2) DESC) AS actor_rank
FROM       movie                                                                            AS m
INNER JOIN ratings                                                                          AS r
ON         m.id = r.movie_id
INNER JOIN role_mapping AS rm
ON         m.id=rm.movie_id
INNER JOIN names AS nm
ON         rm.name_id=nm.id
WHERE      category='actor'
AND        country= 'India'
GROUP BY   name
HAVING     movie_count>=5
LIMIT      3;

-- OUTPUT --
/*
	actor_name         total_votes 	movie_count 	actor_avg_rating 	actor_rank
    ----------------------------------------------------------------------
	Vijay Sethupathi   23114	   	5	       		8.42	            1
	Fahadh Faasil	   13557	   	5	       		7.99	            2
	Yogi Babu	       8500	       	11	       		7.83	            3
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH summary_actress
AS
  (
             SELECT     n.name                                                AS actress_name,
                        sum(total_votes)                                      AS total_votes,
                        count(r.movie_id)                                     AS movie_count,
                        round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating
             FROM       movie                                                 AS m
             INNER JOIN ratings                                               AS r
             ON         m.id=r.movie_id
             INNER JOIN role_mapping AS rm
             ON         m.id = rm.movie_id
             INNER JOIN names AS n
             ON         rm.name_id = n.id
             WHERE      category = 'ACTRESS'
             AND        country = "INDIA"
             AND        languages LIKE '%HINDI%'
             GROUP BY   name
             HAVING     movie_count>=3 )
  SELECT   *,
           rank() over(ORDER BY actress_avg_rating DESC) AS actress_rank
  FROM     summary_actress
  LIMIT    5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE '%THRILLER%')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies;  

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2)                         AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding)    AS running_total_duration,
       Round(Avg(Round(Avg(duration), 2))
               over(
                 ORDER BY genre ROWS 10 preceding), 2) AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 

-- Round is good to have and not a must have; Same thing applies to sorting
/*  genre       avg_duration running_total_duration moving_avg_duration
	Action	    112.88		 112.88					112.88
	Adventure	101.87		 214.75					107.38
	Comedy	    102.62		 317.37					105.79
	Crime	    107.05		 424.42					106.11
	Drama	    106.77		 531.19					106.24
	Family	    100.97		 632.16					105.36
	Fantasy	    105.14		 737.30					105.33
	Horror	    92.72		 830.02					103.75
	Mystery	    101.80		 931.82					103.54
	Others	    100.16		 1031.98				103.20
	Romance	    109.53		 1141.51				103.77
	Sci-Fi	    97.94		 1239.45				102.42
	Thriller	101.58		 1341.03				102.39
*/

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres
AS
  (
             SELECT     genre,
                        count(m.id)                            AS movie_count ,
                        rank() over(ORDER BY count(m.id) DESC) AS genre_rank
             FROM       movie                                  AS m
             INNER JOIN genre                                  AS g
             ON         g.movie_id = m.id
             GROUP BY   genre
             LIMIT      3 ), movie_summary
AS
  (
             SELECT     genre,
                        year,
                        title                                                                                                                                        AS movie_name,
                        worlwide_gross_income ,
                        dense_rank() over(partition BY year ORDER BY cast(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'%INR%',''),'$','') AS DECIMAL(10)) DESC ) AS movie_rank
             FROM       movie                                                                                                                                        AS m
             INNER JOIN genre                                                                                                                                        AS g
             ON         m.id = g.movie_id
             WHERE      genre IN
                        (
                               SELECT genre
                               FROM   top_genres) )
  SELECT   *
  FROM     movie_summary
  WHERE    movie_rank<=5
  ORDER BY year;

-- NOTE: There are 3 rows which has worlwide_gross_income in INR so not considering them for getting rank based on worlwide_gross_income








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary
AS
  (
             SELECT     production_company,
                        count(*) AS movie_count
             FROM       movie    AS m
             INNER JOIN ratings  AS r
             ON         r.movie_id = m.id
             WHERE      median_rating >= 8
             AND        production_company IS NOT NULL
             AND        position(',' IN languages) > 0
             GROUP BY   production_company
             ORDER BY   movie_count DESC)
  SELECT   *,
           rank() over( ORDER BY movie_count DESC) AS prod_comp_rank
  FROM     production_company_summary
  LIMIT    2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary
AS
  (
             SELECT     n.name                                                AS actress_name,
                        sum(total_votes)                                      AS total_votes,
                        count(r.movie_id)                                     AS movie_count,
                        round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating
             FROM       movie                                                 AS m
             INNER JOIN ratings                                               AS r
             ON         m.id=r.movie_id
             INNER JOIN role_mapping AS rm
             ON         m.id = rm.movie_id
             INNER JOIN names AS n
             ON         rm.name_id = n.id
             INNER JOIN genre AS g
             ON         g.movie_id = m.id
             WHERE      category = 'ACTRESS'
             AND        avg_rating>8
             AND        genre = "Drama"
             GROUP BY   name )
  SELECT   *,
           row_number() over(ORDER BY movie_count DESC) AS actress_rank
  FROM     actress_summary
  LIMIT    3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;





