#!/bin/bash
## Script runs in bash terminal
## 
## Usage:
## 
##  runCRISpy.sh -f genelist -s 1000 &
##
##  -f is a text file with gene names one per line
##  -s is an arbitary number, used to number crispy results files
##

while getopts f:s:  option
do
    case "${option}"
    in
    f) GENEFILE=${OPTARG};;    # text file containing a list of yeast gene names
    s) START=${OPTARG}         # Number to use for crispy output, i.e.  crispy_results-122.txt, if it exists will be overwritten
    esac
done

## CHANGE GENOME NAME using the -n flag  
## CHANGE PROJECT NAME  using the -pr flag, use either 1011GENOMES or GLBRC
while IFS= read -r g 
do 
    python lib/python_scripts/crispy.py  -g $g -r $START -n 03 -pr 1011GENOMES
    # other examples
    #python lib/python_scripts/crispy.py  -g $g -r $START -n S288C -pr 1011GENOMES
    #python lib/python_scripts/crispy.py  -g $g -r $START -n S288c -pr GLBRC
    (( START++ ))
done <"$GENEFILE"

