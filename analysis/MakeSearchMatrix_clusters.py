#!/usr/bin/env python
import pandas as pd
import os
import argparse
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description='', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('probe_files',metavar= 'file', nargs= 1, help='cluster files in each fold')
    parser.add_argument('subject_file', metavar='file',  nargs= '+',help = 'a file containing a list of all subjects in study cohort')

    args = parser.parse_args()

    cols =[]  
    directory= os.getcwd().split('/')
    
    indices = set()
    with open("". join(args.probe_files)) as file1:
        assert str("". join(args.probe_files)).endswith('clusters')
        for line in file1:
            parsed_line = line.strip().split('\t')
            indices.add(parsed_line[0] +':' + directory[7] + ':'+ directory[8])
        
    
    for subject_files in args.subject_file:
        assert subject_files.startswith('set=all/subject=') 
        assert subject_files.endswith('.fasta')
        cols.append(subject_files[8:])
    
    # make sure to remove subject= and .fasta from subject list
    cols    = [subject[len('subject='):-6] for subject in cols] 
    
    record = pd.DataFrame(0, index=indices, columns=cols)
    #Step two
    with open("". join(args.probe_files)) as file1:
        for line in file1:
            parsed_line = line.strip().split('\t')
            subject_id = [ID.split(';')[0] for ID in parsed_line[1:] ]
            probe_name  = parsed_line[0] +':' + directory[7] + ':'+ directory[8]
            for i in subject_id:
                record.at[probe_name, i] += 1          

    record.to_csv('cluster_matrix.csv')
    
if __name__ == '__main__':
    sys.exit(main())
