#!/usr/bin/env python
import pandas as pd
from sklearn import linear_model
import argparse
import sys
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import RepeatedStratifiedKFold
import os


def main():
    parser = argparse.ArgumentParser(description='Build random forest model',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('matrix', metavar='file', default = 'Matrix.csv', help='the probe search matrix to be used')
    parser.add_argument('metadata', metavar='file',  help='meta data with sample phenotype information')
    parser.add_argument('Randomorest_features', metavar='file',  help='the csv file with filtered features after Random Forest permuation importance')
    parser.add_argument("output", help="Path to output file")
    parser.add_argument('c', metavar='file', nargs = 1, help= 'C to be used for l1')
  
    args = parser.parse_args()
    
    #Read in meta data 
    meta_data = pd.read_csv(args.metadata, sep =',').set_index('subject')
    meta_data.index = [subject.replace('mpaach:', '') for subject in meta_data.index]
    meta_data.index = meta_data.index.str.strip()
    
    #Read in matrix and feature permutation importance file
    mat = pd.read_csv(args.matrix, sep = ',', index_col=0)
    probe_list = pd.read_csv(args.Randomorest_features, sep =',')
    mat = mat[probe_list['Features']]
    
    mat = mat.drop('mpaach:MP00044')
    mat = mat.drop('mpaach:MP00076')
    mat = mat.drop('mpaach:MP00135')
    mat = mat.drop('mpaach:MP00187')
    mat = mat.drop('mpaach:MP00218')
    mat = mat.drop('mpaach:MP00313')
    mat = mat.drop('mpaach:MP00534')
    mat = mat.drop('mpaach:MP00548')
    mat = mat.drop('mpaach:MP00323')
    
    mat = (mat>=1).astype(int)
    mat = mat.loc[:,mat.sum(axis=0) > 10]
    
    #remove the first 7 characters from matrix
    mat.index = mat.index.str.strip('mpaach:')
    
    #Add target column to matrix (double check all subjects in mat and meta-data are in same order)
    meta_data = meta_data.reindex(index= mat.index)
    
    #make sure the index in meta data and the training/testing matrix are identical
    meta_data = meta_data.loc[list(mat.index),]
    assert (mat.index == meta_data.index).all()
    
    #save output of meta data target for train and test
    meta_data_copy = meta_data['group']
    
    #carry out cross-validated L1 regularization for varrying penalty terms
    for c in args.c:
        c= float(c)
    
    cv = RepeatedStratifiedKFold(n_splits=4, n_repeats=25, random_state=1 )  
    
    fold = 1
    df2 = pd.DataFrame()
    clf = LogisticRegression(penalty='l1' ,  C =c, solver='saga',  fit_intercept = False, max_iter =8000)
    for train_index, test_index in cv.split(mat, meta_data):
        clf.fit(mat.iloc[train_index], meta_data.iloc[train_index])
        
        df = pd.DataFrame()
        #get coefficients of model
        coef = []
        for i in clf.coef_.tolist():
            for p in i:
                coef.append(p)
                
        Probes = mat.columns
        
        df['Probes'] = Probes
        df['C_value'] = c
        df['Fold'] =  fold
        df['Coefficient']= coef
        df['Number_features'] = 0
        
        df = df.sort_values('Coefficient',ascending=False)
        df['Number_features'] = df[df['Coefficient'] != 0].shape[0]
        
        
        df2=df2.append(df, ignore_index=True)
        fold = fold +1
    
    for c in args.c:
        c= str(c)
        os.chdir(args.output + c)
    
    # save each regularized file in the appropriate folder
    df2.to_csv('stability_analysis_for_mpaach_lasso_nonnaivefeatures_repeatedstratified.csv')
    
if __name__ == '__main__':
    sys.exit(main())