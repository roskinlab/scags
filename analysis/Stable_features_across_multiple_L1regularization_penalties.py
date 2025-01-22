#!/usr/bin/env python
import pandas as pd
import numpy as np
from decimal import Decimal
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(description='Build random forest model',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('start', metavar='file',  help='the start position for range used')
    parser.add_argument('step', metavar='file',  help='the step position for range in use')
    parser.add_argument('stop', metavar='file',  help='the stop position for range in use')

    args = parser.parse_args()

    # loop through files from implementing multiple penalty terms
    df = []
    start = Decimal(args.start)
    stop = Decimal(args.step)
    step = Decimal(args.stop)

    for i in np.arange(start, stop, step):
        # load data
        data = pd.read_csv(str(i) + '/stability_analysis_for_lasso_features_repeatedstratified_10_22_24.csv', header=0)
        
        # cal. stats
        d = data.groupby(['Probes']).agg({'Coefficient': ['mean', 'std']})
        
        # cal. lower and uppwer CI
        d['ci_lower'] = d[('Coefficient', 'mean')] - 1.00*d[('Coefficient', 'std')]
        d['ci_upper'] = d[('Coefficient', 'mean')] + 1.00*d[('Coefficient', 'std')]
        d['C_value']  = i
        d['Probes']   = d.index
        
        # does it intersect 0.0
        d['present'] = ((d['ci_lower'] < 0.0) & (d['ci_upper'] < 0.0)) | ((d['ci_lower'] > 0.0) & (d['ci_upper'] > 0.0))
        df2 = d[d['present']]
        df2.columns = ['.'.join(c) for c in df2.columns]
        df2['Number_of_Features'] = df2.shape[0]
        df.append(df2)    
    all_df = pd.concat(df)   
    all_df.to_csv('stable_features_across_all_penalty_terms.csv', index= False)

if __name__ == '__main__':
    sys.exit(main())   
    
    
    