#!/usr/bin/env python

import pandas as pd

data = pd.read_csv('/MPAACH_h1h2h3/isotype_count_mpaach_structure_all_data_reads.csv', sep = ',')

data= data[data['cluster_class'].str.contains('None', na = False)==False]
data = data[data['isotype'].notna()]
data = data[data['cluster_class'].notna()]


data['str_class'] = data['cluster_class'] +':'+ data['isotype']
data = data[['Subject', 'str_class', 'isotype', 'read_count']]


table = pd.pivot_table(data, values = 'read_count', index = 'Subject', columns = ['str_class'], fill_value = 0)
table.to_csv('/MPAACH_h1h2h3/Matrix_with_Isotype_reads.csv')

