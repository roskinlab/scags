#!/usr/bin/env python
import pandas as pd
import numpy as np
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(description = 'Create file with isotype counts for each feature', formatter_class = argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('All_structure_reads', metavar='file', help='file with isotype counts per feature')
    args = parser.parse_args()

    column_types = {'subject': str, 'isotype': str, 'lineage': str, 'v_j_in_frame': str, 'has_stop_codon': str, 'h1': str, 'h2': str, 'h3':str }
    structure_database = pd.read_csv(args.All_structure_reads, sep = ',', usecols=column_types.keys(), dtype=column_types)

    structure_database = structure_database[structure_database['v_j_in_frame'].notna()]
    structure_database = structure_database[structure_database['has_stop_codon'].notna()]

    status = {'True': True, 'False': False}
    structure_database['has_stop_codon'] = structure_database['has_stop_codon'].map(status)
    structure_database['v_j_in_frame'] = structure_database['v_j_in_frame'].map(status)

    structure_database = structure_database[(structure_database['v_j_in_frame'] == True) & (structure_database['has_stop_codon'] == False)]
    structure_database['cluster_class'] = structure_database['h1'] + ':' + structure_database['h2'] + ":" + structure_database['h3']

    del structure_database['v_j_in_frame']
    del structure_database['has_stop_codon']
    del structure_database['h1']
    del structure_database['h2']
    del structure_database['h3']

    structure_database = structure_database[structure_database['cluster_class'].str.contains('None', na = False)==False]
    structure_database = structure_database[structure_database['isotype'].notna()]
    structure_database = structure_database[structure_database['cluster_class'].notna()]

    data_isotype_lineage = structure_database.groupby(['subject', 'isotype', 'cluster_class'])['lineage'].nunique().to_csv('isotype_count_structure_all_data.csv')

if __name__ == '__main__':
    sys.exit(main())