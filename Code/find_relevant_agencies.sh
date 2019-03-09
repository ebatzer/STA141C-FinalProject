#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findagencies

DATAFILE="/scratch/transaction.csv"

 grep -e customs and border protection \
   -e immigration and customs enforcement \
   -e executive office of immigration \
   --ignore-case \
   ${DATAFILE} \
   | cat > selected_agencies.csv
