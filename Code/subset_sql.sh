#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name subset_sqlite

# Send me an email when the job is completed!
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ebatzer@ucdavis.edu

# Loading in bio module for sqlite3
module load bio

# Setting location of SQL file
DATAFILE="/scratch/usaspending.sqlite"

# Generating SQL command to select relevant rows, filter data
printf "SELECT DISTINCT name, subtier_agency_id
FROM subtier_agency
ORDER BY name ASC;\n" > unique_subtiers.sql

# Join on meaningful columns
printf "SELECT award_id, total_obligation, generated_pragmatic_obligation,
pop_state_code, pop_county_code, pop_zip5, naics_code, awarding_subtier_agency_name
FROM universal_transaction_matview
LEFT JOIN (SELECT DISTINCT name, subtier_agency_id FROM subtier_agency)
ON awarding_subtier_agency_name=name
WHERE subtier_agency_id = 778
OR subtier_agency_id = 776
OR subtier_agency_id = 257" > filter_rows.sql

# Find rows that match our subtier agency criteria
cat unique_subtiers.sql | sqlite3 -header -csv ${DATAFILE} > subtier_names.csv

# Run SQL command and produce subsetted dataset
cat filter_rows.sql | sqlite3 -header -csv ${DATAFILE} > filtered_data.csv
