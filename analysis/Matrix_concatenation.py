#!/usr/bin/env python
import pandas as pd
import argparse
import sys
import numpy as np

#Read the matrices in from each vj3 cluster directory
def main():
    parser = argparse.ArgumentParser(description='', formatter_class= argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('Matrix_file', metavar = 'file', nargs = '+',  help= 'the matrix file containing  binary cluster information for each subject')
     
    args = parser.parse_args()
    frames = []
    counter = 0
    dictionary ={}

    #Read in matrix and transpose matrix to make subjects be rows and columns be probes/clusters
    for mat_file in args.Matrix_file:
        counter+=1
        matrix= pd.read_csv(mat_file, sep =',', index_col =0)
        matrix = matrix.transpose()
        frames.append(matrix)
    
    #concatenate newly read in matrix to old existing matrix
    concatenated_matrix=pd.concat(frames, axis='columns')
    concatenated_matrix=concatenated_matrix.fillna(0)
    
    concatenated_matrix.to_csv('Full_Matrix_vjs3.csv')
if __name__ == '__main__':
    sys.exit(main())
