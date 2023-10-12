#!/bin/tcsh

#$ -pe mpi-24 24    # Specify parallel environment and legal core size
#$ -q debug         # Specify queue, debug is up to 4 hours, long is 14 days
#$ -N big_boot      # Specify job name
#$ -M sberry5@nd.edu	 # Notification email
#$ -m abe 		# abort, begin, end

module load R 

mpirun -np $NSLOTS  Rscript crc_example.R > crc_test.out
