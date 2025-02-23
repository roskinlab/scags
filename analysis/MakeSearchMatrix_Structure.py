#!/usr/bin/env python
import pandas as pd
import os
import argparse
import sys
from pathlib import Path
from Bio import Seq, SeqRecord, SeqIO
from collections import Counter


#make dictionary to store subject and cdr3 class information using subject fasta files that has information on the CDR3 structural class
def make_subject_class_dict(subject_fasta_file):
    class_dict={}
    for seq_record in SeqIO.parse(str(subject_fasta_file), "fasta"):
        assert str("". join(subject_fasta_file)).endswith('fasta')
        record_id = seq_record.id.split(';')[0]
        cdr3_class = seq_record.seq
        if cdr3_class not in class_dict:
            class_dict[cdr3_class] = []
        class_dict[cdr3_class].append(record_id)
    return class_dict

def main():
    parser = argparse.ArgumentParser(description='', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('subject_file', metavar = 'file', nargs= '+', help ='each subject fasta file')
    parser.add_argument('meta_file', metavar = 'file',  help ='meta data file wit all subjects')
    
    args =  parser.parse_args()
            
    ## turn dictionary into a matrix
    cols =[]
    indices = set()

    meta = pd.read_csv(args.meta_file, sep =',').set_index('subject')
    for subject in meta.index:
        cols.append(subject)
        
    directory= os.getcwd().split('/')
    for subject_file in args.subject_file:
        assert subject_file.startswith('set=all/subject=') 
        assert subject_file.endswith('.fasta')
        i_dict=make_subject_class_dict(subject_file)
        for cdr3_name, subject in i_dict.items():
            probe = str(directory[7]) + ':'+ str(directory[8]) + ':'+ str(cdr3_name)
            indices.add(probe)
    record = pd.DataFrame(0, index=indices, columns=cols)   
    
    for subject_file in args.subject_file:
        assert subject_file.startswith('set=all/subject=') 
        assert subject_file.endswith('.fasta')
        s_dict=make_subject_class_dict(subject_file)
        for cdr3_name, subject in s_dict.items():
            probe = str(directory[7]) + ':'+ str(directory[8]) + ':'+ str(cdr3_name)
            counts = Counter(subject)
            for item in counts:
                new_subject = item
                s_count = counts[item]  
            record.at[probe, new_subject] = s_count  
            
    record.to_csv('mini_matrix2123.csv')

if __name__ == '__main__':
    sys.exit(main())



    