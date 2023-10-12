#!/bin/bash

#$ -N test     		 # Specify job name
#$ -M sberry5@nd.edu	 # Notification email
#$ -m abe 		# abort, begin, end

module load R 

R CMD BATCH bootstrap_example.R  bootstrap.out
