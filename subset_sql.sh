#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name subset_sqlite

module load bio

printf "SELECT action_date, generate_pragmatic_obligation, total_obligation, awarding_agency_id,
funding_agency_id, funding_subtier_agency_name
FROM agency
WHERE funding_subtier_agency_name = 'U.S. Customs and Border Protection'
OR funding_subtier_agency_name = 'U.S. Immigration and Customs Enforcement';\n" > select_agencies.sql

wget http://anson.ucdavis.edu/~clarkf/sta141c/usaspending.sqlite.zip |
  unzip -p > usaspending.sqlite

cat select_agencies.sql | sqlite3 -header -csv ~/data/usaspending.sqlite > selected_agencies.csv
