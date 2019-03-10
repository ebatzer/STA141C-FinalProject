#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name subset_sqlite
printf "SELECT toptier_agency_id, name FROM agency;\n" > first20.sql

cat first20.sql | sqlite3 -header -csv ~/data/usaspending.sqlite > first20.csv

wget http://anson.ucdavis.edu/~clarkf/sta141c/usaspending.sqlite.zip |
  unzip -p > usaspending.sqlite

cat first20.sql | sqlite3 -header -csv ~/data/usaspending.sqlite > first20.csv

rm usaspending.sqlite
