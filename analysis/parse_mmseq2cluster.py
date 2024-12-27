#!/usr/bin/env python

import sys
import read_seqclust_3
from roskinlib.utils import open_compressed
import argparse
from Bio import SeqIO
from pathlib import Path
import os
import shutil
import pprint


def main():
    parser = argparse.ArgumentParser(description='', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('directory_path', metavar='directory', help='the direcotry that has the output of MMseq2')
    parser.add_argument('--cuttoff', metavar='N', type=int, default=5, help='minimum number of subjects in a cluster')
    
    
    args = parser.parse_args()
    cluster_file = args.directory_path + '/clustTSV'
    consensus_file = args.directory_path + '/consensusDB.fasta'

    # Process clustTSV file
    filtered_clusters ={}
    with open_compressed(cluster_file, 'rt') as cluster_handle, open('data/clusters', 'w', ) as output_handle:
        for cluster in read_seqclust_3.Mmseqs2TSVIterator(cluster_handle):
            cluster_subjects = set()
            cluster_members = set()
            for member in cluster:
                cluster_members.add(member.name)
                for read in member.name.split(","):
                    subject_id, clone_id, read_id = read.split(";")
                    cluster_subjects.add(subject_id)
            if len(cluster_subjects) >= args.cuttoff:
                print(cluster.name, *cluster_members, sep ='\t', file = output_handle)
                assert cluster.name not in filtered_clusters
                filtered_clusters[cluster.representative]= cluster.name

    #process consensus file and save into cluters and consensus.fasta files
    cluster_consensus = {}
    with open('data/Consensus.fasta', 'w') as output_handle2:
        with open_compressed(str(consensus_file),'rt') as consensus_handle:
            for fasta_rec in SeqIO.parse(consensus_handle, 'fasta'):
                name, consensus_seq = fasta_rec.id, str(fasta_rec.seq)
                consensus_rep = name.strip()
                cluster_consensus[consensus_rep] = consensus_seq
                for cluster_representitive,cluster_number in filtered_clusters.items():
                    if consensus_rep == cluster_representitive:
                        assert cluster_representitive in cluster_consensus, 'consensus not found for cluster' + str(cluster_number)
                        print('>'+ str(cluster_number),'\n'+consensus_seq,sep = '', file = output_handle2)
         
if __name__ == '__main__':
    sys.exit(main())
