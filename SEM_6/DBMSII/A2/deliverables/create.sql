CREATE DATABASE IMDb_G4;

CREATE TABLE public."Awards"
(
    award_id character varying NOT NULL,
    name character varying,
    category character varying,
    year integer,
    PRIMARY KEY (award_id)
);

CREATE TABLE public."Episode_Location"
(
    "Episodes_episode_id" character varying NOT NULL,
    "Location_country" character varying NOT NULL,
    release_title character varying,
    language character varying
);

CREATE TABLE public."Episodes"
(
    episode_id character varying NOT NULL,
    rating real,
    plot_outline character varying,
    "PG_rating" character varying,
    original_title character varying,
    series_id character varying,
    runtime bigint,
    season_number integer,
    episode_number integer,
    PRIMARY KEY (episode_id)
);

CREATE TABLE public."Generic_Media"
(
    "IMDB_id" character varying NOT NULL,
    rating real,
    original_title character varying,
    antisocial_elements character varying[],
    languages character varying[],
    genres character varying[],
    plot_outline character varying,
    "PG_rating" character varying,
    runtime bigint,
    websites character varying[],
    PRIMARY KEY ("IMDB_id")
);

CREATE TABLE public."Generic_Media_Location"
(
    "Generic_Media_IMDB_id" character varying NOT NULL,
    "Location_country" character varying NOT NULL,
    release_title character varying,
    language character varying,
    original boolean
);

CREATE TABLE public."Location"
(
    country character varying NOT NULL,
    PRIMARY KEY (country)
);

CREATE TABLE public."Movie"
(
    movie_id character varying NOT NULL,
    box_office_collection money,
    budget money,
    PRIMARY KEY (movie_id)
);

CREATE TABLE public."Person"
(
    person_id character varying NOT NULL,
    "primaryName" character varying,
    photos character varying[],
    "birthYear" bigint,
    popular_works character varying[],
    PRIMARY KEY (person_id)
);

CREATE TABLE public."Person_Episodes"
(
    "Person_person_id" character varying,
    "Episodes_episode_id" character varying,
    role character varying,
    character_name character varying[]
);

CREATE TABLE public."Person_Generic_Media"
(
    "Person_person_id" character varying NOT NULL,
    "Generic_Media_IMDB_id" character varying NOT NULL,
    role character varying,
    character_name character varying[]
);

CREATE TABLE public."Production Company"
(
    company_id character varying NOT NULL,
    name character varying,
    PRIMARY KEY (company_id)
);

CREATE TABLE public."Soundtrack"
(
    soundtrack_id character varying NOT NULL,
    name character varying,
    PRIMARY KEY (soundtrack_id)
);

CREATE TABLE public."TV_Series"
(
    series_id character varying NOT NULL,
    is_running boolean,
    PRIMARY KEY (series_id)
);

CREATE TABLE public."User"
(
    user_id character varying NOT NULL,
    email_id character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    PRIMARY KEY (user_id, email_id)
);

CREATE TABLE public."Website"
(
    website_id character varying NOT NULL,
    url character varying,
    name character varying,
    PRIMARY KEY (website_id)
);

CREATE TABLE public.extra_info
(
    "IMDB_id" character varying NOT NULL,
    websites character varying[],
    plot character varying,
    PRIMARY KEY ("IMDB_id")
);

CREATE TABLE public.name_basics
(
    nconst character varying NOT NULL,
    "primaryName" character varying,
    "birthYear" bigint,
    "deathYear" bigint,
    "primaryProfession" character varying[],
    "knownForTitles" character varying[],
    PRIMARY KEY (nconst)
);

CREATE TABLE public.title_akas
(
    title_id character varying,
    ordering integer,
    title character varying,
    region character varying,
    language character varying,
    types character varying,
    attributes character varying,
    "isOriginalTitle" boolean
);

CREATE TABLE public.title_basics
(
    tconst character varying NOT NULL,
    "titleType" character varying,
    "primaryTitle" character varying,
    "originalTitle" character varying,
    "isAdult" integer,
    "startYear" bigint,
    "endYear" bigint,
    "runtimeMinutes" integer,
    genres character varying[],
    PRIMARY KEY (tconst)
);

CREATE TABLE public.title_crew
(
    tconst character varying NOT NULL,
    directors character varying[],
    writers character varying[],
    PRIMARY KEY (tconst)
);

CREATE TABLE public.title_episodes
(
    tconst character varying NOT NULL,
    "tconstParent" character varying,
    "seasonNumber" integer,
    "episodeNumber" integer,
    PRIMARY KEY (tconst)
);

CREATE TABLE public.title_principals
(
    tconst character varying,
    ordering integer,
    nconst character varying,
    category character varying,
    job character varying,
    characters character varying[]
);

CREATE TABLE public.title_ratings
(
    tconst character varying NOT NULL,
    "averageRating" real,
    "numVotes" bigint,
    PRIMARY KEY (tconst)
);
