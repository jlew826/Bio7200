#!/bin/bash

#error message for incorrect usage
usage() { echo "Usage: $0 [-n number files] [-m number sequences] [-v]" 1>&2; exit 1; }

#getopts with the 3 options: n,m,v
while getopts "n:m:v" OPTION; do
    case "${OPTION}" in
	n)
	    numfiles="${OPTARG}"
	    ;;
	m)
	    numseq="${OPTARG}"
	    ;;
	v)
	    set -v $(basename $0) 
	    ;;
	?)
	    usage
	    ;;
    esac
done

#if n or m options are not properly inputed, error message results
if [ -z "${numfiles}" ] || [ -z "${numseq}" ]; then
    usage
fi

#creates input number of seq.fasta files and creates input number of sequences in each fasta file.
for i in $(seq 1 $numfiles)    #loop that creates the files
do
    if [ -f "seq$i.fasta" ]
    then
	rm "seq$i.fasta"
	touch "seq$i.fasta"
    else
	touch "seq$i.fasta"
    fi
    
    for j in $(seq 1 $numseq)  #loop that creates and appends the number of sequences into the files 
    do
	echo ">seq${i}_${j}"| sed 's/\n/, /' >> "seq$i.fasta"
	cat /dev/urandom | LC_CTYPE=C tr -dc 'ACGT' | fold -w 50 | head >> "seq$i.fasta"
    done
    
done