#!/bin/bash

#PARSER=/logistic_regression_model_updated.py

MATRIX=${1:?csv file with search matrix}
META_DATA=${2:?Cohort file with phenotype information}
TRAIN_FILE=${3:? path containing train subjects identifiers}
TEST_FILE=${4:? path containing test subjects identifiers}
SUBJECT_FILTER=${5:? the number for subject filter cutoff}
OUTPUT_FILE=${6:? csv file containing output Accuracy scores}

cat <<EOF

${PARSER} ${MATRIX} ${META_DATA}  ${TRAIN_FILE} ${TEST_FILE} ${SUBJECT_FILTER} > ${OUTPUT_FILE} 

 
EOF
