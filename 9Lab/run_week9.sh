#!/bin/bash

# Usage: ./fibonacci.pl <sequence length>
./fibonacci.pl 6

################

# Usage: ./findOrtholog.pl <input fasta file 1> <input fasta file 2> <output file name> n 
./findOrtholog.pl seq1 seq2 output1 n
#fasta files here are files with nucleotide sequences, the last option "n" stands for sequence type "nucleotide"

# Usage: ./findOrtholog.pl <input fasta file 1> <input fasta file 2> <output file name> p 
./findOrtholog.pl seq1 seq2 output2 p
#fasta files here are files with protein sequences, the last option "p" stands for sequence type "protein"

################

#Usage: ./coverage.pl <input bed file name> <output file name>
./coverage.pl input.bed output3

###############################################
##
## Your code should run with, BUT NOT LIMITED TO, the command(s) above.
## Please read the exercise instructions for more details on how your code should work.
##
###############################################