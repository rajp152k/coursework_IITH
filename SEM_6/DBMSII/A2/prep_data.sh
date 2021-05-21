mkdir -p data

cd data

wget https://datasets.imdbws.com/name.basics.tsv.gz
wget https://datasets.imdbws.com/title.akas.tsv.gz
wget https://datasets.imdbws.com/title.basics.tsv.gz
wget https://datasets.imdbws.com/title.crew.tsv.gz
wget https://datasets.imdbws.com/title.episode.tsv.gz
wget https://datasets.imdbws.com/title.principals.tsv.gz
wget https://datasets.imdbws.com/title.ratings.tsv.gz


tar -xvf name.basics.tsv.gz
tar -xvf title.akas.tsv.gz
tar -xvf title.basics.tsv.gz
tar -xvf title.crew.tsv.gz
tar -xvf title.episode.tsv.gz
tar -xvf title.principals.tsv.gz
tar -xvf title.ratings.tsv.gz

