#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name subset_sqlite

DATAFILE = "/scratch/usaspending.sqlite"

# Loading in bio module for sqlite3
module load bio

printf "SELECT DISTINCT name, subtier_agency_id
FROM subtier_agency
ORDER BY name ASC;\n" > unique_subtiers.sql

# Join on meaningful columns
printf "SELECT name, subtier_agency_id
FROM subtier_agency
FULL JOIN (SELECT award_id, total_obligation, generated_pragmatic_obligation,
pop_state_code, pop_county_code, pop_zip5, naics_code, awarding_subtier_agency_name)
ON name=awarding_subtier_agency_name
WHERE subtier_agency_id = 778
OR subtier_agency_id = 776
OR subtier_agency_id = 257;\n" > column_join.sql

# Run SQL command and produce subsetted dataset
cat unique_subtiers.sql | sqlite3 -header -csv ${DATAFILE} > subtier_values.csv
