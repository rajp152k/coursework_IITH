ALTER TABLE public."Episode_Location"
    ADD FOREIGN KEY ("Episodes_episode_id")
    REFERENCES public."Episodes" (episode_id)
    NOT VALID;


ALTER TABLE public."Episode_Location"
    ADD FOREIGN KEY ("Location_country")
    REFERENCES public."Location" (country)
    NOT VALID;


ALTER TABLE public."Episodes"
    ADD FOREIGN KEY (series_id)
    REFERENCES public."TV_Series" (series_id)
    NOT VALID;


ALTER TABLE public."Generic_Media_Location"
    ADD FOREIGN KEY ("Generic_Media_IMDB_id")
    REFERENCES public."Generic_Media" ("IMDB_id")
    NOT VALID;


ALTER TABLE public."Generic_Media_Location"
    ADD FOREIGN KEY ("Location_country")
    REFERENCES public."Location" (country)
    NOT VALID;


ALTER TABLE public."Movie"
    ADD FOREIGN KEY (movie_id)
    REFERENCES public."Generic_Media" ("IMDB_id")
    NOT VALID;


ALTER TABLE public."Person_Episodes"
    ADD FOREIGN KEY ("Episodes_episode_id")
    REFERENCES public."Episodes" (episode_id)
    NOT VALID;


ALTER TABLE public."Person_Episodes"
    ADD FOREIGN KEY ("Person_person_id")
    REFERENCES public."Person" (person_id)
    NOT VALID;


ALTER TABLE public."Person_Generic_Media"
    ADD FOREIGN KEY ("Generic_Media_IMDB_id")
    REFERENCES public."Generic_Media" ("IMDB_id")
    NOT VALID;

ALTER TABLE public."Person_Generic_Media"
    ADD FOREIGN KEY ("Person_person_id")
    REFERENCES public."Person" (person_id)
    NOT VALID;

ALTER TABLE public."TV_Series"
    ADD FOREIGN KEY (series_id)
    REFERENCES public."Generic_Media" ("IMDB_id")
    NOT VALID;
