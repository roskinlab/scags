#!/usr/bin/env python
import pandas as pd
from sklearn import linear_model
import argparse
import sys
import numpy as np
from sklearn.linear_model import LogisticRegression
import os


def main():
    parser = argparse.ArgumentParser(description='Build logistic regression model',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('matrix', metavar='file', default = 'Matrix.csv', help='the feaature matrix file to be used')
    parser.add_argument('metadata', metavar='file',  help='meta data with sample phenotype information')
    parser.add_argument('train', metavar='file', nargs = 1, help= 'list of train subjects')
    parser.add_argument('test', metavar='file', nargs = 1, help= 'list of test subjects')
    parser.add_argument('subject_filter', type=int, help= 'the least amount of subjects allowed in a feature')
    
    directory= os.getcwd()
    args = parser.parse_args()
    
    #Read in meta data and remove unwanted characters from subject names
    meta_data = pd.read_csv(args.metadata, sep =',').set_index('subject')
    meta_data.index = [subject.replace('mpaach:', '') for subject in meta_data.index]
    meta_data.index = meta_data.index.str.strip()
    
    #Read in feature matrix 
    mat = pd.read_csv(args.matrix, sep = ',', index_col=0)
    
    #Read in  train and test subject files
    train_file = args.train
    train_file = open("". join(args.train), 'r')

    test_file = args.test
    test_file = open("". join(args.test), 'r')
    
    #Remove unwanted characters from subject names in train and test files
    train = [subject.replace('mpaach:', '') for subject in train_file]
    train = [subject.strip() for subject in train]
    
    test = [subject.replace('mpaach:', '') for subject in test_file]
    test = [subject.strip() for subject in test]
    
    mat = (mat>=1).astype(int)
    
    
    #remove the first 7 characters (unwanted characters) from matrix
    mat.index = mat.index.str.strip('mpaach:')
    
    #Add target column to matrix (double check all subjects in feature matrix (mat) and meta-data are in same order)
    meta_data = meta_data.reindex(index= mat.index)
    
    #subset feature matrix into test and train sets
    mat_train = mat[mat.index.isin(train)]
    mat_test  = mat[mat.index.isin(test)]
    
    #subset meta data file into test and train sets
    meta_data_train = meta_data[meta_data.index.isin(train)]
    meta_data_test  = meta_data[meta_data.index.isin(test)]
    
    #filter out the train subset feature matrix on the amount of subjects 
    mat_train = mat_train.loc[:,mat_train.sum(axis=0) > args.subject_filter]
    cols = mat_train.columns
    
    #select the clusters that passed the subject filtering on the training subset for the test subset
    mat_test = mat_test[cols]
    
    #make sure the index in meta data and the training/testing matrix are identical
    meta_data_train = meta_data_train.loc[list(mat_train.index),]
    meta_data_test = meta_data_test.loc[list(mat_test.index),]
    assert (mat_train.index == meta_data_train.index).all()
    assert (mat_test.index == meta_data_test.index).all()
    
    #save disease target phenotype of meta data for train and test
    meta_data_train = meta_data_train['group']
    meta_data_test  = meta_data_test['group'] 
    
    #get subjects
    meta_data_train_subjects = meta_data_train.index
    meta_data_test_subjects = meta_data_test.index
    
    #run logistic regression model and carry out prediction on test subset 
    clf = LogisticRegression(penalty='none', fit_intercept = False, solver = 'saga', max_iter= 300000)
    clf.fit(mat_train, meta_data_train)
    pred=clf.predict_proba(mat_test)
    
    new_y_pred =[]
    for i in pred:
        if (i[0]) >= 0.5 :
            new_y_pred.append('non-sensit')
        else:
            if i[1] >= 0.5:
                new_y_pred.append('sensit')
                
    print('Predicted_proba', 'Actual_status', 'Predicted_Status', sep ='\t')
    for i in range(len(pred)):
        print(meta_data_test_subjects[i], pred[i][0],meta_data_test[i], new_y_pred[i], sep ='\t')
        
    testing_accuracy = sum(meta_data_test == new_y_pred) / len(pred)
    print('Testing accuracy is:',testing_accuracy)
    
    ### Optional steps
    fold = directory.split('/')[8]
    cols = mat_train.columns

    #get coefficients of model
    coef = []
    for i in clf.coef_.tolist():
        for p in i:
            coef.append(p)

    #make empty dataframe and store coefficients in it
    df = pd.DataFrame()
    df['Probes'] =cols
    df['Coefficient'] = coef
    df['folds'] = [fold] *len(cols)

    df = df.sort_values('Coefficient',ascending=False)
    df.to_csv(str(directory) + str(fold) + '/LR_prediction_coefficients.csv')
    
if __name__ == '__main__':
    sys.exit(main())
