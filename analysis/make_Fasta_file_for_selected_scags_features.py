#!/usr/bin/env python
import pandas as pd
from Bio import Seq, SeqRecord, SeqIO
import os
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(description='make avro files for clusters',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('mode_lineage_database', metavar='file.avro',  help='the probe fastavro file to be used')
    parser.add_argument('features', metavar='parse-label', help='parse label to use')
    
    #read in file 
    database= pd.read_csv(args.mode_lineage_database, sep =',')
    selected_features = pd.read_csv(args.features, sep= ',')
    #rename feature column name if necessary
    selected_features=selected_features.rename(columns = {'Probes.':'Probes'})

    database['Probes2'] = database['Probes'] + ':' + database['isotype']
    keep = database['Probes2'].isin(selected_features['Probes'])    
    selected_features_clones = database[keep]
    h1h2h3_isotype = selected_features_clones.sort_values(by=['Probes2'])

    #save lineage mode file for specific features
    h1h2h3_isotype.to_csv('h1h2h3_Lasso_features_mode_lineage.csv')

    #create fasta file containing the mode CDR3 seq for each clone in each of the selected features
    directory =os.getcwd()

    my_records =[]
    
    for index, row in h1h2h3_isotype.iterrows():
        previous_probe = row['Probes2']
        break
    for index, row in h1h2h3_isotype.iterrows():
        if previous_probe != row['Probes2']:
            my_records =[]
            ID =  row['lineage'] + ':' + row['Probes2']
            sequence = row['cdr3_sequence']
            sequence = Seq.Seq(sequence)
            record = SeqRecord.SeqRecord(sequence, id=ID, description='')
            my_records.append(record)
        else:
            ID =  row['lineage'] + ':' + row['Probes2']
            sequence = row['cdr3_sequence']
            sequence = Seq.Seq(sequence)
            record = SeqRecord.SeqRecord(sequence, id=ID, description='')
            my_records.append(record) 
        previous_probe = row['Probes2'] 
        SeqIO.write(my_records, str(directory) + '/' + str(previous_probe) + '.fasta', 'fasta-2line')

if __name__ == '__main__':
    sys.exit(main())
