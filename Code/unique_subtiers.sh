#!/bin/bash -l

# Use the staclass partition. Only applies if you are in STA141C
#SBATCH --partition staclass

# Give the job a name
#SBATCH --job-name findrows

DATAFILE="/scratch/transaction.csv"
AWARD_SUBTIER=55
FUND_SUBTIER=56

cut --fields ${AWARD_SUBTIER} --delimiter , ${DATAFILE} \
  | sort \
  | uniq \
  | cat > "unique_awarding_subtier.csv"

cut --fields ${FUND_SUBTIER} --delimiter , ${DATAFILE} \
    | sort \
    | uniq \
    | cat > "unique_funding_subtier.csv"
