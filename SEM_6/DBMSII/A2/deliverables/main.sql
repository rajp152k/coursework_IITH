/*
Inserts all the media which has the type 'tvEpisode' into the Episodes table'
Time Taken = 46 secs
*/
INSERT INTO public."Episodes" (episode_id, original_title, runtime)
SELECT tconst, "originalTitle", "runtimeMinutes"
FROM public."title_basics" AS B
WHERE B."titleType" = 'tvEpisode';

/*
Inserts all the media other than 'tvEpisode' into the Generic_Media table'
Time Taken = 20 secs
*/
INSERT INTO public."Generic_Media" ("IMDB_id", original_title, genres, runtime)
SELECT tconst, "originalTitle", genres, "runtimeMinutes"
FROM 	
public."title_basics"
WHERE 
    "titleType" <> 'tvEpisode';

/*
Inserts all the media featured on TV into the TV_Series table'
Time Taken = 5 secs
*/
INSERT INTO public."TV_Series" (series_id)
SELECT tconst 
FROM public."title_basics"
WHERE 
	"titleType" = 'tvMiniSeries' OR 
	"titleType" = 'tvSpecial' OR 
	"titleType" = 'tvShort' OR 
	"titleType" = 'tvSeries' OR 
	"titleType" = 'tvMovie';

/*
Inserts all the media of the type 'movie' or 'short' into the Movie table'
Time Taken = 13 secs
*/
INSERT INTO public."Movie" (movie_id)
SELECT tconst 
FROM 
	public."title_basics"
WHERE 
	"titleType" = 'movie' OR 
	"titleType" = 'short';

/*
Inserts all the Person details from the file 'name_basics.tsv' into the Person table'
Time Taken = 1 min 52 secs
*/
INSERT INTO public."Person" (person_id, "primaryName", "birthYear", popular_works)
SELECT 
    nconst, "primaryName", "birthYear", "knownForTitles"
FROM 
    public."name_basics";

/*
The bottom two commnds create views for convenience
Time Taken = 1 sec
*/
CREATE VIEW ep_v AS 
SELECT * 
FROM 	
	public."title_basics"
WHERE 
	"titleType" = 'tvEpisode';

CREATE VIEW series_inter_media_v AS
SELECT series_id
FROM
	public."TV_Series" T
	INNER JOIN
	public."Generic_Media" M
	ON T.series_id = M."IMDB_id";

/*
Updating the series_id and other data such as season and episode numbers
corresponding to all the episode_id's in the Episodes table
Time Taken = 54 secs
*/
UPDATE 
	public."Episodes" 
SET 
	series_id = R."tconstParent", 
	season_number = R."seasonNumber",
	episode_number = R."episodeNumber"
FROM (
	SELECT 
		tconst, "tconstParent", "seasonNumber", "episodeNumber"
	FROM
		public."Episodes" AS E
		INNER JOIN
		public."title_episodes" AS R
		ON E.episode_id = R.tconst
	) AS R
WHERE episode_id = R.tconst;

/*
The table 'title_episodes' contains such episodes which are not present in 'title_baiscs' under the 'tvEpisode' title Type 
So, we need to insert these into Episodes as well
Time Taken = 13 secs
*/
INSERT INTO public."Episodes" (episode_id, series_id, season_number, episode_number)
SELECT tconst, "tconstParent", "seasonNumber", "episodeNumber"
FROM 
	public."title_episodes" 
WHERE tconst IN
(SELECT tconst FROM public."title_episodes"
EXCEPT 
SELECT tconst FROM public.ep_v);

/*
Now since we have added series_id's from 'title_episodes', there are certain series_id's which 
are not originally present in 'TV_Series' table.
So, in order to set up a valid foreign key, we add these extra series_id's to the 'TV_Series' table.
Time Taken = 3 secs
*/
INSERT INTO public."TV_Series" (series_id)
(SELECT series_id FROM public."Episodes" WHERE series_id IS NOT NULL
EXCEPT
SELECT series_id FROM public."TV_Series");

/*
Similarly to the above command, we now add the series_id's back to 'Generic_Media' table in order to satisfy
the foreign key contrainsts
Time Taken = 2 secs
*/
INSERT INTO public."Generic_Media" ("IMDB_id")
(SELECT series_id FROM public."TV_Series" WHERE series_id IS NOT NULL
EXCEPT 
SELECT series_id FROM public.series_inter_media_v);

/*
Looking at the end year of TV shows, we update the is_running field. 
Shows for which there is a non-null end year, is_running field is set as False, 
whereas for all the other shows it is set as True.
It might be the case that end year information might not be available for some shows which 
have ended but there is no way of knowing.
Time Taken = 13 secs
*/
UPDATE public."TV_Series" 
SET is_running = FALSE
WHERE series_id IN
(SELECT series_id 
FROM
	public."title_basics" B
	INNER JOIN 
	public."TV_Series" S
	ON S.series_id = B.tconst
WHERE 
	"endYear" IS NOT NULL);

UPDATE public."TV_Series" 
SET is_running = TRUE
WHERE series_id IN
(SELECT series_id 
FROM
	public."title_basics" B
	INNER JOIN 
	public."TV_Series" S
	ON S.series_id = B.tconst
WHERE 
	"endYear" IS NULL);

/*
Now we use the 'title_ratings' file to add the ratings of all the episodes and generic media into their
respective tables.
Time Taken = 35 secs
*/
UPDATE 
	public."Episodes" 
SET 
	rating = R."averageRating"
FROM (
	SELECT 
		tconst, "averageRating"
	FROM
		public."Episodes" AS E
		INNER JOIN
		public."title_ratings" AS R
		ON E.episode_id = R.tconst
	) AS R
WHERE episode_id = R.tconst;

UPDATE 
	public."Generic_Media" 
SET 
	rating = R."averageRating"
FROM (
	SELECT 
		tconst, "averageRating"
	FROM
		public."Generic_Media" AS M
		INNER JOIN
		public."title_ratings" AS R
		ON M."IMDB_id" = R.tconst
	) AS R
WHERE "IMDB_id" = R.tconst;

/*
Insert all the distinct locations into the Locations table
Time Taken = 10 secs
*/
INSERT INTO public."Location" (country)
SELECT DISTINCT region
FROM public."title_akas"
WHERE region IS NOT NULL;

/*
The file 'title_akas' is uses to populate Episodes_Location and Generic_Media_Location
Time Taken = 57 + 31 secs = 1 min 24 secs
*/
INSERT INTO public."Episode_Location" ("Episodes_episode_id", "Location_country", release_title, language)
SELECT title_id, region, title, language
FROM 
	public."Episodes" E
	INNER JOIN
	public."title_akas" A
	ON A.title_id = E.episode_id
WHERE region IS NOT NULL;

INSERT INTO public."Generic_Media_Location" ("Generic_Media_IMDB_id", "Location_country", release_title, language)
SELECT title_id, region, title, language
FROM 
	public."Generic_Media" G
	INNER JOIN
	public."title_akas" A
	ON A.title_id = G."IMDB_id"
WHERE region IS NOT NULL;

/*
'title_principals' is used to populate the tables corresponding to Episodes
and Generic Media which contain the information about the people who 
have worked in these episodes / movies / tv series.
Time Taken = 1 min 12 secs + 3 mins 50 secs = 5 mins 2 secs
*/
INSERT INTO public."Person_Generic_Media" ("Generic_Media_IMDB_id", "Person_person_id", role, character_name)
SELECT TC.tconst, TC.nconst, TC.category, TC.characters
FROM 
	public."title_principals" TC
	INNER JOIN
	public."Generic_Media" M
	ON M."IMDB_id" = TC.tconst;

INSERT INTO public."Person_Episodes" ("Episodes_episode_id", "Person_person_id", role, character_name)
SELECT TC.tconst, TC.nconst, TC.category, TC.characters
FROM 
	public."title_principals" TC
	INNER JOIN
	public."Episodes" E
	ON E.episode_id = TC.tconst;

/*
the table 'title_crew' contains information only about the writers and directors in array format
so we use unnest array operator to get individual pairs of media id and directors / writers
this data is then fed into the working relation 'Person_Generic_Media'
Time Taken = 14 + 17 + 32 + 37 secs = 1 min 40 secs
*/
INSERT INTO public."Person_Generic_Media" ("Generic_Media_IMDB_id", "Person_person_id", role)
SELECT TC.tconst, unnest(directors), 'director' AS role
FROM 
	public."title_crew" TC
	INNER JOIN
	public."Generic_Media" M
	ON M."IMDB_id" = TC.tconst;

INSERT INTO public."Person_Generic_Media" ("Generic_Media_IMDB_id", "Person_person_id", role)
SELECT TC.tconst, unnest(writers), 'writer' AS role
FROM 
	public."title_crew" TC
	INNER JOIN
	public."Generic_Media" M
	ON M."IMDB_id" = TC.tconst;

INSERT INTO public."Person_Episodes" ("Episodes_episode_id", "Person_person_id", role)
SELECT TC.tconst, unnest(directors), 'director' AS role
FROM 
	public."title_crew" TC
	INNER JOIN
	public."Episodes" E
	ON E.episode_id = TC.tconst;

INSERT INTO public."Person_Episodes" ("Episodes_episode_id", "Person_person_id", role)
SELECT TC.tconst, unnest(writers), 'writer' AS role
FROM 
	public."title_crew" TC
	INNER JOIN
	public."Episodes" E
	ON E.episode_id = TC.tconst;

/*
Finally, there are some people whose works have been mentioned in the 
principals and crew tables. So, to have a valid foreign key, we add these 
into the original Person table. 
Time Taken = 1 min 31 secs + 1 min 36 secs = 3 mins 7 secs
*/
INSERT INTO public."Person" (person_id)
SELECT DISTINCT "Person_person_id" FROM public."Person_Episodes"
EXCEPT 
SELECT person_id FROM public."Person";

INSERT INTO public."Person" (person_id)
SELECT DISTINCT "Person_person_id" FROM public."Person_Generic_Media"
EXCEPT 
SELECT person_id FROM public."Person";

/*
We use the extra scraped info to update the plots and websites 
in Episodes and Generic_Media Tables
*/
UPDATE public."Episodes" E
SET plot_outline = R.plot
FROM
	(
	SELECT INF."IMDB_id", INF.plot, INF.websites
	FROM 
		public."Episodes" E
		INNER JOIN 
		public.extra_info INF
		ON E.series_id = INF."IMDB_id"
	) AS R
WHERE 
	E.series_id = R."IMDB_id";

UPDATE public."Generic_Media" GM
SET plot_outline = R.plot, websites = R.websites
FROM
	(
	SELECT M."IMDB_id", INF.plot, INF.websites
	FROM 
		public."Generic_Media" M
		INNER JOIN 
		public.extra_info INF
		ON M."IMDB_id" = INF."IMDB_id"
	) AS R
WHERE 
	GM."IMDB_id" = R."IMDB_id";
