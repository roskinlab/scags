#!/usr/bin/env python

from __future__ import print_function

import fastavro
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import argparse
from itertools import chain
import sys
import logging
from roskinlib.schemata.avro import SEQUENCE_RECORD
import pprint as pprint
import pathlib 
import glob
import os

#pushd /base/datasets/MPAACH 
# make dictionary to store each cluster members and their reads
path = pathlib.Path().absolute()

def cluster_dictionary (cluster_file):
    p_dictionary = {}
    for line in cluster_file:
        cluster_name, members = line.strip().split('\t', 1)
        members = members.split('\t')
        flattened_members = [k for i in members for k in i.split(',')]
        p_dictionary[cluster_name] = {}
        for i in flattened_members:
            subject, clone, read = i.split(';')

            if subject not in p_dictionary[cluster_name]:
                p_dictionary[cluster_name][subject] = set()
            p_dictionary[cluster_name][subject].add(read)
    return p_dictionary

# for each probe, get subject ID and open subject file
def get_clusters_as_avro_files(parse_label, dictionary_of_clusters, avro_file):
    avro_records = []
    #add cluster_signature to cluster_name
    for probe_name, value in dictionary_of_clusters.items():
        for subject, read_sets in value.items():
            #make list of all records
            os.chdir(str(path) + '/'+'subject='+ str(subject))
            logging.info('subject %s found',subject )
            for name in glob.glob(avro_file):
                with open(str(name), 'rb') as input_handle:
                    logging.info('name %s found',name )
                    reader = fastavro.reader(input_handle)
                    logging.info('working on subject %s', name)
                    #Scan avro file and Identify read
                    for record in reader:
                        assert parse_label in record['parses']
                        parse = record['parses'][parse_label]
                        name = record['name']
                        if name in read_sets:
                            record['parses'][parse_label]['annotations']['cluster_number'] = probe_name
                            avro_records.append(record)
    return avro_records


#make new avro file
def main():
    parser = argparse.ArgumentParser(description='make avro files for clusters',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('fastavro_file', metavar='file.avro',  help='the probe fastavro file to be used')
    parser.add_argument('parse_label', metavar='parse-label', help='parse label to use')
    parser.add_argument('cluster', metavar='cluster file', help='the cluster file to be used')

    args = parser.parse_args()
    

    with open(args.cluster) as f:
        probe_dictionary = cluster_dictionary(f)
        
    
    avro_clusters = get_clusters_as_avro_files(args.parse_label, probe_dictionary,args.fastavro_file)
    output_schema = fastavro.parse_schema(SEQUENCE_RECORD)
    
    #For all subjects in a probe, save read record to new avro file                   
    fastavro.writer(sys.stdout.buffer, output_schema, avro_clusters, codec='bzip2')
if __name__ == '__main__':
    sys.exit(main())




