#!/usr/bin/env python

import pandas as pd
def main():
    parser = argparse.ArgumentParser(description='Build random forest model',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('isotype_read_counts', metavar='file',  help='the file containiing the isotype counts per read for each subject')
    
    args = parser.parse_args()

    #data = pd.read_csv('/data/RoskinLab/team/kachi/project_dir_kachi/MPAACH_h1h2h3/isotype_count_mpaach_structure_all_data_reads.csv', sep = ',')
    data = pd.read_csv('/data/RoskinLab/team/kachi/project_dir_kachi/CHAVI_h1h2h3/isotype_count_chavi_structure_all_data.csv', sep =',')

    data= data[data['cluster_class'].str.contains('None', na = False)==False]
    data = data[data['isotype'].notna()]
    data = data[data['cluster_class'].notna()]



    #data = data[['Subject', 'cluster_class','isotype', 'read_count']]
    data = data[['subject', 'cluster_class','isotype', 'lineage']]
    data= data[data['isotype'].str.contains('IGHE|IGHG1|IGHG2|IGHG3|IGHG4|IGHA1|IGHA2')]

    data['str_class'] = data['cluster_class'] +':'+ data['isotype']

    #data = data[['Subject', 'str_class', 'isotype', 'read_count']]
    data = data[['subject', 'str_class', 'isotype', 'lineage']]
    #table = pd.pivot_table(data,  index = 'Subject',values = 'read_count', columns = 'str_class', fill_value = 0, aggfunc= 'sum')
    table = pd.pivot_table(data,  index = 'subject',values = 'lineage', columns = 'str_class', fill_value = 0, aggfunc= 'sum')


    #table.to_csv('/data/RoskinLab/team/kachi/project_dir_kachi/MPAACH_h1h2h3/Matrix_without_IgM_IgD_reads.csv')
    table.to_csv('/data/RoskinLab/team/kachi/project_dir_kachi/CHAVI_h1h2h3/Matrix_without_IgM_IgD_lineage.csv')

if __name__ == '__main__':
    sys.exit(main())
