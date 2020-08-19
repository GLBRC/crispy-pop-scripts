#!/home/mplace/anaconda3.7/bin/python
"""
@Program: countNoHits.py

@Purpose: Create a table counting the sgRNA generated for S288C that have zero 
          hits for all crispy results in directory.
        
@Input:  Directory w/ crispy results

@author: Mike Place

"""
import glob
import os
import sys

def main():
    """
    main() 
    """
    NoHits = []   # list of all sgRNAs with no hits in 1011 Genomes
    # loop through all crispy results files in directory
    for file in glob.glob('crispy-results*'):
        print(file)
        with open(file, 'r') as f:
            f.readline()        # skip header
            for line in f:
                numHit = line.rstrip().split('\t')[-1]  # get the num stains hit column
                if numHit == '0':
                    NoHits.append(line)
        f.close()
    
    # write counts to file 
    with open('S288C_sgRNAs_No_Hits_10111genomes_count.txt', 'w') as out:
        for sgRNA in NoHits:
            out.write('{}'.format(sgRNA))        

if __name__ == "__main__":
    main()
