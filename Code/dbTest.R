#!/usr/bin/env Rscript

library(DBI)
library(RSQLite)

conn = dbConnect(SQLite(), "/scratch/usaspending.sqlite")

# Read any query, this is an example
query = "select * from state_data limit 5;"

# Print results to stdout
dbGetQuery(conn, query)

dbDisconnect(conn)