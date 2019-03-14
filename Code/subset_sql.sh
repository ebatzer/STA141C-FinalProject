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
printf "SELECT award_id, action_date, fiscal_year, total_obligation,
generated_pragmatic_obligation, transaction_description, award_category,
pop_country_name, pop_state_code, pop_county_name, pop_zip5, naics_code,
awarding_subtier_agency_name, funding_subtier_agency_name, business_categories
FROM universal_transaction_matview
LEFT JOIN (SELECT DISTINCT name, subtier_agency_id FROM subtier_agency)
ON awarding_subtier_agency_name=name
WHERE subtier_agency_id = 778
OR subtier_agency_id = 776
OR subtier_agency_id = 257" > filter_rows_awarding.sql

# Join on meaningful columns
printf "SELECT award_id, action_date, fiscal_year, total_obligation,
generated_pragmatic_obligation, transaction_description, award_category,
pop_country_name, pop_state_code, pop_county_name, pop_zip5, naics_code,
awarding_subtier_agency_name, funding_subtier_agency_name, business_categories
FROM universal_transaction_matview
LEFT JOIN (SELECT DISTINCT name, subtier_agency_id FROM subtier_agency)
ON funding_subtier_agency_name=name
WHERE subtier_agency_id = 778
OR subtier_agency_id = 776
OR subtier_agency_id = 257" > filter_rows_funding.sql

# Find rows that match our subtier agency criteria
cat unique_subtiers.sql | sqlite3 -header -csv ${DATAFILE} > subtier_names.csv

# Run SQL command and produce subsetted dataset
cat filter_rows_awarding.sql | sqlite3 -header -csv ${DATAFILE} > filtered_data_awarding.csv

# Run SQL command and produce subsetted dataset
cat filter_rows_funding.sql | sqlite3 -header -csv ${DATAFILE} > filtered_data_funding.csv
