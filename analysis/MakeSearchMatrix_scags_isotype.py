#!/usr/bin/env python
import pandas as pd
import argparse
import sys

def main()
parser = argparse.ArgumentParser(description = 'Create feature matrix for scag features', formatter_class = argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('isotype_counts', metavar='file', help='file with isotype counts per feature')
args = parser.parse_args()

data = pd.read_csv(args.isotype_counts, sep = ',')

data= data[data['cluster_class'].str.contains('None', na = False)==False]
data = data[data['isotype'].notna()]
data = data[data['cluster_class'].notna()]

data['str_class'] = data['cluster_class'] +':'+ data['isotype']
data = data[['Subject', 'str_class', 'isotype', 'lineage_count']]

table = pd.pivot_table(data, values = 'lineage_count', index = 'Subject', columns = ['str_class'], fill_value = 0)
table.to_csv('/Matrix_with_Isotype.csv')

if __name__ == '__main__':
    sys.exit(main())

