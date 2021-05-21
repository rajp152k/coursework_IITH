/*
DBMS GROUP 4 : Assignment 3

RAJ PATIL       : CS18BTECH11039
VEDANT SINGH    : CS18BTECH11047
KARAN BHUKAR    : CS18BTECH11021
HIMANSHU BISHNOI: CS16BTECH11018
*/

--1. 

SELECT MOVIE_ID
FROM
   	 (SELECT MOVIE_ID,
   			 COUNT("Person_person_id") -- counting directors per movie
   		 FROM PUBLIC."Movie" M
   		 INNER JOIN PUBLIC."Person_Generic_Media" GM ON M.MOVIE_ID = GM."Generic_Media_IMDB_id"
   		 WHERE ROLE = 'director'
   		 GROUP BY MOVIE_ID) AS R -- directors for each movie
WHERE R.COUNT >= 2;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--

--2.

CREATE VIEW DIRECTOR_MOVIE_V AS
SELECT MOVIE_ID,
    "Person_person_id" DIRECTOR_ID
FROM PUBLIC."Movie" M
INNER JOIN PUBLIC."Person_Generic_Media" GM ON M.MOVIE_ID = GM."Generic_Media_IMDB_id"
WHERE ROLE = 'director'; -- convenience view for director movie info


CREATE VIEW ACTOR_MOVIE_V AS
SELECT MOVIE_ID,
    "Person_person_id" ACTOR_ID
FROM PUBLIC."Movie" M
INNER JOIN PUBLIC."Person_Generic_Media" GM ON M.MOVIE_ID = GM."Generic_Media_IMDB_id"
WHERE ROLE = 'actor'
   	 OR ROLE = 'actress'; -- convenience view for actor movie info


SELECT A.ACTOR_ID
FROM
   	 (SELECT 	MAX(C) OTHER_MAX, -- finding max movies with directors other than Zack
   			 			ACTOR_ID
   		 FROM
   				 (SELECT COUNT(A.MOVIE_ID) C,
   						 ACTOR_ID,
   						 DIRECTOR_ID
   					 FROM PUBLIC.ACTOR_MOVIE_V A
   					 INNER JOIN PUBLIC.DIRECTOR_MOVIE_V B
             ON A.MOVIE_ID = B.MOVIE_ID
   					 WHERE B.DIRECTOR_ID <> 'nm0811583'	
   					 GROUP BY 
            		ACTOR_ID,
   						 	DIRECTOR_ID) AS R -- grouping movies w.r.t actor, director pairs (other than Zack Snyder)
   		 GROUP BY ACTOR_ID) A, -- grouping directors w.r.t actors
       
       
       -- joining the two on actor_id

       (SELECT COUNT(A.MOVIE_ID) -- number of movies made with snyder
                ACTOR_ID 
   		 FROM PUBLIC.ACTOR_MOVIE_V A
   		 INNER JOIN PUBLIC.DIRECTOR_MOVIE_V B ON A.MOVIE_ID = B.MOVIE_ID
   		 WHERE B.DIRECTOR_ID = 'nm0811583'
   		 GROUP BY ACTOR_ID,
   			 DIRECTOR_ID) B
WHERE A.ACTOR_ID = B.ACTOR_ID
   	 AND A.OTHER_MAX < B.SNYDER; -- filtering for actors with more movies with Snyder





--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--3.
SELECT MOVIE_ID
FROM PUBLIC."Movies" -- all movies

EXCEPT
	
SELECT M.MOVIE_ID
FROM PUBLIC."Nominations" N
INNER JOIN PUBLIC."Movies" M ON M.MOVIE_ID = N."IMDB_id"
WHERE N.AWARDED = 1
GROUP BY M.MOVIE_ID
HAVING COUNT(AWARDED) >= 2; -- movies with more than two awards


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--4.

-- Using the same convenience view created in Q2

SELECT CNT,
    RATE,
    ACTOR_ID,
    DIRECTOR_ID
FROM
   	 (SELECT 
         COUNT(DISTINCT M.MOVIE_ID) CNT, -- movie count per pair
         MAX(GM.RATING) RATE, -- atleast one movie ("the" movie) crosses the bound
         M.ACTOR_ID,
         M.DIRECTOR_ID
   		 FROM
   				 (SELECT A.MOVIE_ID,
   						 ACTOR_ID,
   						 DIRECTOR_ID
   					 FROM PUBLIC.ACTOR_MOVIE_V A
   					 INNER JOIN PUBLIC.DIRECTOR_MOVIE_V B
            ON A.MOVIE_ID = B.MOVIE_ID) M -- finding actor director pairs
   		 	INNER JOIN PUBLIC."Generic_Media" GM 
      	ON GM."IMDB_id" = M.MOVIE_ID
   		 GROUP BY 
      		ACTOR_ID,
   			 	DIRECTOR_ID) R -- per pair aggregated movie info
WHERE CNT <= 2 AND RATE > 7; -- considering only pairs with atmost 2 movies and the movie with rating > 7



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--5 
	
SELECT SERIES_ID,
    ORIGINAL_TITLE,
    (END_YEAR - START_YEAR) DURATIONS
FROM PUBLIC."TV_Series" T
INNER JOIN PUBLIC."Generic_Media" GM 
ON GM."IMDB_id" = T.SERIES_ID -- assimilating per series duration info
ORDER BY DURATIONS DESC NULLS LAST
LIMIT 1;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--6 


SELECT IDS.PID,
	PERS."primaryName"
FROM
		(SELECT S."Person_person_id" PID
			FROM
					(SELECT R.MOVIE_ID
						FROM
								(SELECT 
                 		MOVIE_ID,
										DENSE_RANK() 
                 			OVER( ORDER BY RUNTIME ASC NULLS LAST) RUNTIME_RANK -- dense as only rank skips values
									FROM
											(SELECT MOVIE_ID
												FROM PUBLIC."Movie") M
									INNER JOIN
											(SELECT G."IMDB_id",
													G.RUNTIME
												FROM PUBLIC."Generic_Media" G
												WHERE G.START_YEAR = 2020) GM ON GM."IMDB_id" = M.MOVIE_ID) R
						WHERE R.RUNTIME_RANK = 2 ) Q -- second shortest movies in 2020
			INNER JOIN
					(SELECT P."Person_person_id",
							P."Generic_Media_IMDB_id"
						FROM PUBLIC."Person_Generic_Media" P
						WHERE P.ROLE = 'director' ) S -- movie directors
 	ON Q.MOVIE_ID = S."Generic_Media_IMDB_id")IDS -- directors of requested movies
INNER JOIN PUBLIC."Person" PERS -- extracting director names
ON PERS.PERSON_ID = IDS.PID ;





--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--7  
 (SELECT GM.RATING,
   			 GM."IMDB_id",
   			 GM.ORIGINAL_TITLE,
   			 'TV Series' AS TYPE
   		 FROM PUBLIC."Generic_Media" GM
   		 INNER JOIN PUBLIC."TV_Series" T ON T.SERIES_ID = GM."IMDB_id"
   		 WHERE IS_ADULT = 1
   				 AND RATING IS NOT NULL
   		 ORDER BY RATING ASC -- nulls last is not necessary with ASC
   		 LIMIT 1) -- worst adult TV Series
       -- no need to average over episodes
       -- ones with TV Series are already aggregated ratings
UNION
   	 (SELECT GM.RATING,
   			 GM."IMDB_id",
   			 GM.ORIGINAL_TITLE,
   			 'Movie' AS TYPE
   		 FROM PUBLIC."Generic_Media" GM
   		 INNER JOIN PUBLIC."Movie" M ON M.MOVIE_ID = GM."IMDB_id"
   		 WHERE IS_ADULT = 1
   				 AND RATING IS NOT NULL
   		 ORDER BY RATING ASC
   		 LIMIT 1); -- worst adult Movie
       

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--8
	
SELECT N."Person_person_id",
    AVG_RATING
FROM
   	 (SELECT R."Person_person_id",
   			 AVG(RATING) AVG_RATING,
   			 RANK() OVER(ORDER BY AVG(RATING) DESC NULLS LAST) RANKING -- sparse ranking
   		 FROM
   				 (SELECT MOVIE_ID,
   						 "Person_person_id"
   					 FROM PUBLIC."Movie" M
   					 INNER JOIN PUBLIC."Person_Generic_Media" PG ON M.MOVIE_ID = PG."Generic_Media_IMDB_id"
   					 WHERE ROLE = 'director') R -- director movie pairs
      
   		 			INNER JOIN PUBLIC."Generic_Media" GM 
      			ON R.MOVIE_ID = GM."IMDB_id"
      
   		 			GROUP BY R."Person_person_id") N
WHERE N.RANKING <= 5; -- if more than 5 movies tie for top 5 ratings, only those will be printed 
-- due to sparse ranking



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--9
	
(SELECT T.SERIES_ID
   		 FROM PUBLIC."Generic_Media_Location" L
   		 INNER JOIN PUBLIC."TV_Series" T ON T.SERIES_ID = L."Generic_Media_IMDB_id"
   		 GROUP BY T.SERIES_ID
   		 HAVING COUNT("Location_country") >= 3) -- released in more than 3 countries
       
       INTERSECT
       
   	 (SELECT T.SERIES_ID
   		 FROM PUBLIC."Generic_Media_Production_Company" P
   		 INNER JOIN PUBLIC."TV_Series" T ON T.SERIES_ID = P."Generic_Media_IMDB_id"
   		 GROUP BY T.SERIES_ID
   		 HAVING COUNT("Production_Company_company_id") >= 2); -- atleast two production companies

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--10 

SELECT S.PERSON_ID,
    P."primaryName",
    S.YEAR
FROM
        (SELECT AP.PERSON_ID,
                R.YEAR
            FROM
                    (SELECT N.NOMINATION_ID,
                            A.YEAR
                        FROM PUBLIC."Nominations" N
                        INNER JOIN PUBLIC."Awards" A ON N.AWARD_ID = A.AWARD_ID
                        WHERE A.NAME = 'Oscar'
                                AND N.AWARDED = 1) R -- Oscar Awardees
            INNER JOIN PUBLIC."Award_Person_Association" AP ON AP.NOMINATION_ID = R.NOMINATION_ID) S
INNER JOIN PUBLIC."Person" P ON P.PERSON_ID = S.PERSON_ID -- extracting person info
ORDER BY S.YEAR DESC NULLS LAST;





--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--11.
SELECT RAT."Person_person_id",
   	0.7 * COALESCE(RAT.AVG_RATING,0) + 0.3 * COALESCE(EXP.XP,0) SCORE -- coalescing NULLS to 0 (if they exist)
FROM -- 
  (SELECT DIR."Person_person_id",
      	(0.8 * COALESCE(AVG_RATING_DIR,0) + 0.2 * COALESCE(AVG_RATING_ASST,0)) AVG_RATING -- coalescing NULLS to 0 (if they exist)
   FROM -- creating columns for ratings as Asst-Director and Director
 	(SELECT PG."Person_person_id",
         	AVG(GM.RATING) AVG_RATING_DIR
  	FROM PUBLIC."Generic_Media" GM,
       	PUBLIC."Movie" M,

    	(SELECT *
     	FROM PUBLIC."Person_Generic_Media" PG
     	WHERE ROLE = 'director') PG
  	WHERE GM."IMDB_id" = M.MOVIE_ID
    	AND M.MOVIE_ID = PG."Generic_Media_IMDB_id"
  	GROUP BY PG."Person_person_id") DIR -- per dir movie info with avg_ratings
   
   FULL OUTER JOIN -- a Person may not be both
   
 	(SELECT PG."Person_person_id",
         	AVG(GM.RATING) AVG_RATING_ASST
  	FROM PUBLIC."Generic_Media" GM,
       	PUBLIC."Movie" M,
          (SELECT *
          FROM PUBLIC."Person_Generic_Media" P
          WHERE ROLE = 'assistant_director')
   			PG -- assistant directors
  	WHERE GM."IMDB_id" = M.MOVIE_ID
    	AND M.MOVIE_ID = PG."Generic_Media_IMDB_id"
  	GROUP BY PG."Person_person_id") ASST -- per asst-dir movie info with avg_ratings
   
   ON DIR."Person_person_id" = ASST."Person_person_id") RAT -- ratings
    
FULL OUTER JOIN -- ratings might not be available for all movies
								-- employ Right Outer Join for increased semantic correctness

  (SELECT PG."Person_person_id",
      	COUNT(M.MOVIE_ID) XP
   FROM PUBLIC."Person_Generic_Media" PG
   INNER JOIN PUBLIC."Movie" M ON M.MOVIE_ID = PG."Generic_Media_IMDB_id"
   WHERE ROLE = 'director'
 	OR ROLE = 'assistant_director'
   GROUP BY PG."Person_person_id") EXP -- experience
   
   ON RAT."Person_person_id" = EXP."Person_person_id"
   
ORDER BY SCORE DESC NULLS LAST; -- computed requested score in select header and ordering






--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--12.
SELECT TOP5.GENRE,
   	TOP5.MOVIE_ID,
   	GM.ORIGINAL_TITLE,
   	P.PERSON_ID,
   	P."primaryName"
FROM
  (SELECT TB.GENRE,
      	UNNEST(TB.MOVIES[:5]) MOVIE_ID 	-- creating genre wise tuples for top 5 movies (ordered set)
   																			-- :5 is an inclusive slice

   FROM
 	(SELECT ARRAY_AGG(R.MOVIE_ID
                   	ORDER BY (R.BOX_OFFICE_COLLECTION - R.BUDGET) DESC NULLS LAST) MOVIES, -- ordered movie set by requested metric
   																																												 -- employing window function format specific 
   																																												 -- to Postgres
 UNNEST(R.GENRES) GENRE
  	FROM (PUBLIC."Generic_Media" GM
        	INNER JOIN PUBLIC."Movie" M ON M.MOVIE_ID = GM."IMDB_id") R -- movies info

  	GROUP BY GENRE) TB) TOP5,
 	PUBLIC."Generic_Media" GM,
 	PUBLIC."Person_Generic_Media" PG,
 	PUBLIC."Person" P
WHERE TOP5.MOVIE_ID = GM."IMDB_id"
  AND TOP5.MOVIE_ID = PG."Generic_Media_IMDB_id"
  AND PG."Person_person_id" = P.PERSON_ID
  AND PG.ROLE = 'director'
  
 	-- accumulating all auxiliary info
  
ORDER BY TOP5.GENRE; -- unnecessary: for the sake of displaying genre tuples together


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--13 

 (SELECT PG."Person_person_id"
   FROM PUBLIC."Person_Generic_Media" PG
   INNER JOIN PUBLIC."Movie" M ON PG."Generic_Media_IMDB_id" = M.MOVIE_ID
   WHERE ROLE = 'actor'
 	OR ROLE = 'actress') -- actors from Movies
  
INTERSECT

(
   (SELECT "Person_person_id"
	FROM PUBLIC."Person_Episodes"
	WHERE ROLE = 'actor'
  	OR ROLE = 'actress')
  
 UNION -- accumulating from Episode info and explicit Series info
  
   (SELECT PG."Person_person_id"
	FROM PUBLIC."Person_Generic_Media" PG
	INNER JOIN PUBLIC."TV_Series" T ON PG."Generic_Media_IMDB_id" = T.SERIES_ID
	WHERE ROLE = 'actor'
  	OR ROLE = 'actress')); -- actors from TV Series



--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--14
	
	
SELECT EPS_LIST[1], -- selecting the first (1-indexing in postgres)
   	START_YEAR
FROM
  (SELECT ARRAY_AGG(EPISODE_ID
                	ORDER BY RUNTIME ASC NULLS LAST) EPS_LIST, -- postgres window function primitives again
      	START_YEAR
   FROM PUBLIC."Episodes"
   GROUP BY START_YEAR) R; -- per year ordered episode sets




--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--15 
SELECT 
		MOVIE_LIST[:3], -- top 3 movies corresponding to a Genre
   	GENRE
FROM
  (SELECT ARRAY_AGG(MOVIE_ID
                	ORDER BY RATING DESC NULLS LAST) MOVIE_LIST, -- can't index the set in this subquery itself
   																														 -- even though that's intuitive
      	UNNEST(GENRES) GENRE -- decoupling sets into tuples 
   FROM PUBLIC."Movie" M
   INNER JOIN PUBLIC."Generic_Media" GM 
   ON M.MOVIE_ID = GM."IMDB_id" -- assimilating auxiliary info
   GROUP BY GENRE) R; -- ordered movies per Genre
   
   
   

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--16

  (SELECT DISTINCT SERIES_ID AS ID
   FROM
 	(SELECT *
  	FROM PUBLIC."Episode_Location"
  	WHERE "Location_country" = 'CH') A
   INNER JOIN
 	(SELECT *
  	FROM PUBLIC."Episodes") B
   ON A."Episodes_episode_id" = B.EPISODE_ID) -- TV Series via episodes
    
UNION 

SELECT "Generic_Media_IMDB_id"
FROM PUBLIC."Generic_Media_Location" -- Movies and TV Series(explicit record)
WHERE "Location_country" = 'CH';


--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--17 
SELECT ARRAY_AGG(R.MOVIE_ID), -- presenting as sets
   	GL."Location_country"
FROM
  (SELECT M.MOVIE_ID
   FROM PUBLIC."Movie" M
   INNER JOIN PUBLIC."Generic_Media" GM ON GM."IMDB_id" = M.MOVIE_ID
   WHERE GM.START_YEAR = 1995
 	AND GM.IS_ADULT = 1) R -- adult movies in the year 1995
INNER JOIN PUBLIC."Generic_Media_Location" GL 
ON GL."Generic_Media_IMDB_id" = R.MOVIE_ID -- obtaining location info
GROUP BY GL."Location_country" -- grouping by location

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--18 

SELECT PERSON_LIST[1], -- youngest person
   	P."primaryName",
   	P."birthYear",
   	PROF
FROM
  (SELECT ARRAY_AGG(PERSON_ID
                	ORDER BY P."birthYear" DESC NULLS LAST) PERSON_LIST, -- ordered set w.r.t birthYear
      	UNNEST(PRIMARY_PROFESSION) PROF
   FROM PUBLIC."Person" P
   GROUP BY PROF) R
INNER JOIN PUBLIC."Person" P  -- assimilating auxiliary info
ON R.PERSON_LIST[1] = P.PERSON_ID;

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--19
SELECT R.PERSON_ID,
   	COUNT(R."IMDB_id")
FROM PUBLIC."Movie" M
INNER JOIN
    (SELECT C.PERSON_ID,
          S."IMDB_id"
     FROM PUBLIC."Contributor" C
     INNER JOIN PUBLIC."Soundtrack_Use" S 
     ON C.SOUNDTRACK_ID = S.SOUNDTRACK_ID
     WHERE ROLE = 'soundtrack_producer') R -- movie, soundtrack producer pairs
   ON M.MOVIE_ID = R."IMDB_id" -- extracting movie info
GROUP BY R.PERSON_ID -- accumulating per person movie sets
HAVING COUNT(R."IMDB_id") >= 5; -- worked in atleast 5 movies

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--
--20
	
SELECT P."primaryName",
   	A."Person_person_id",
   	A.CNT
FROM PUBLIC."Person" P
INNER JOIN
  (SELECT COUNT(DISTINCT "Generic_Media_IMDB_id") CNT,
      	"Person_person_id"
   FROM PUBLIC."Person_Generic_Media"
   WHERE ROLE = 'actor'
 	 OR ROLE = 'actress'
   GROUP BY "Person_person_id"
   
   HAVING COUNT("Generic_Media_IMDB_id") in
   
        (SELECT COUNT(*)
          FROM
            (SELECT *
            FROM PUBLIC."Generic_Media"
            WHERE ORIGINAL_TITLE = 'Inception' -- INCEPTION By C Nolan(2010) ; NOT Danial Hajibarat et al(2014)
              AND ARRAY_POSITION(GENRES, 'Sci-Fi') IS NOT NULL) R  -- selected movie tuple
          INNER JOIN PUBLIC."Person_Generic_Media" GM 
          ON R."IMDB_id" = GM."Generic_Media_IMDB_id") -- crew strength for selected movie
   
 			 ) A -- person worked in the parametrized number of movies
    ON A."Person_person_id" = P.PERSON_ID -- extracting name
ORDER BY P."primaryName" NULLS LAST;
