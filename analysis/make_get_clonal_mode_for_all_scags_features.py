#!/usr/bin/env python
import pandas as pd
import numpy as np
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(description='place CDRs into its canonical class',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('All_database_reads', metavar='parse-label', help='parse label to use')
    
    args = parser.parse_args()

    column_types = {'subject': str,'sample': str, 'isotype': str, 'lineage': str, 'v_j_in_frame': str, 'has_stop_codon': str, 'h1': str, 'h2': str, 'h3':str, 'cdr3_sequence':str, 'v_segment':str, 'j_segment':str }
    structure_database = pd.read_csv(args.All_database_reads, sep = ',', usecols=column_types.keys(), dtype=column_types)

    #remove nonproductive reads
    status = {'True': True, 'False': False}
    structure_database = structure_database[structure_database['v_j_in_frame'].notna()]
    structure_database = structure_database[structure_database['has_stop_codon'].notna()]
    structure_database['has_stop_codon'] = structure_database['has_stop_codon'].map(status)
    structure_database['v_j_in_frame'] = structure_database['v_j_in_frame'].map(status)
    structure_database = structure_database[(structure_database['v_j_in_frame'] == True) & (structure_database['has_stop_codon'] == False)]
    
    structure_database['Probes'] = structure_database['h1'] + ':' + structure_database['h2'] + ":" + structure_database['h3']

    #delete columns that are no longer needed
    del structure_database['v_j_in_frame']
    del structure_database['has_stop_codon']
    del structure_database['h1']
    del structure_database['h2']
    del structure_database['h3']

    #remove features missing any CDR classification and isotype information
    structure_database = structure_database[structure_database['Probes'].str.contains('None', na = False)==False]
    structure_database = structure_database[structure_database['isotype'].notna()]
    structure_database = structure_database[structure_database['Probes'].notna()]
    
    #get the mode clone for each probe (features)
    cdr3_clone_mode_data=structure_database.groupby(['isotype', 'lineage', 'Probes'])['v_segment', 'j_segment','cdr3_sequence'].agg(lambda x:pd.Series.mode(x)[0])
    cdr3_clone_mode_data_subject=structure_database.groupby(['subject','isotype', 'lineage', 'Probes'])['v_segment', 'j_segment','cdr3_sequence'].agg(lambda x:pd.Series.mode(x)[0])

    cdr3_clone_mode_data_subject.to_csv('All_structure_mode_clones.csv')

if __name__ == '__main__':
    sys.exit(main())