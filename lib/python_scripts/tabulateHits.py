#!/home/mplace/anaconda3.7/bin/python
"""
@Program: tabulateHits.py

@Purpose: Create a table counting the sgRNA hits for all crispy results in directory.
        
@Input:  Directory w/ crispy results

@author: Mike Place

plot in R:
library(ggplot)
library(ggthemes)
dat <- read.csv('1011_genomes_count.txt',sep = '\t', header=TRUE)
# basic histogram
ggplot(dat, aes(x=hits,y=count)) + geom_histogram(color="black", stat = "identity") +
 scale_x_continuous(name = "1011 Genomes\nHit by sgRNA", breaks = seq(0,1012,25))  + 
 scale_y_continuous(name='sgRNA Count') + ggtitle("sgRNA's Hits Per Strain ")

"""
import glob
import os
import sys

def main():
    """
    main() 
    """   
    counts = {}             # key = "NumStrainHits", value = count of occurance    
    processedFileCount = 0
    # process all results file in directory
    for file in glob.glob('crispy-results*'):
        print(file)
        processedFileCount += 1
        with open(file, 'r') as f:
            f.readline()        # skip header
            for line in f:
                numHit = line.rstrip().split('\t')[-1]
                if numHit in counts:
                    counts[numHit] += 1
                else:
                    counts[numHit] = 1
        f.close()
    
    # write counts to file 
    with open('1011_genomes_count.txt', 'w') as out:
        out.write('{}\t{}\n'.format('hits','count'))
        for hit in sorted(counts.keys(), key= lambda x: int(x)):
            out.write('{}\t{}\n'.format(hit, counts[hit]))
    
if __name__ == "__main__":
    main()
