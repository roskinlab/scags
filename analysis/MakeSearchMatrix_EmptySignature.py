#!/usr/bin/env python
import pandas as pd
import os
import argparse
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description='', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('subject_file', metavar='file',  nargs= '+',help = 'a file containing a list of all subjects in study cohort')

    args = parser.parse_args()

    cols =[]  
    directory= os.getcwd().split('/')
    

    for subject_files in args.subject_file:
        assert subject_files.startswith('set=all/subject=') 
        assert subject_files.endswith('.fasta')
        subject_files = subject_files.split('/')
        cols.append(subject_files[-1])
        
    # make sure to remove subject= and .fasta from subject list
    cols    = [subject[len('subject='):-6] for subject in cols] 
    record = pd.DataFrame(columns=cols)     

    record.to_csv('cluster_matrix.csv')
    
if __name__ == '__main__':
    sys.exit(main())
