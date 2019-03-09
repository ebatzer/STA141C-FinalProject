#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findagencies

DATAFILE="/scratch/transaction.csv"

 grep -e u.s. customs and border protection \
   -e u.s. immigration and customs enforcement \
   -e executive office of immigration review \
   --ignore-case \
   ${DATAFILE} \
   | cat > selected_agencies.csv
