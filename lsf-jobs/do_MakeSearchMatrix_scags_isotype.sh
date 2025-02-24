JOB_LABEL=$(basename "${FILE}" )

#swith parser to 'MakeSearchMatrix_nonaive_features.py' to run code for nonnaive matrix
PARSER=/MakeSearchMatrix_scags_isotype.py

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 
#BSUB -J add_parse_${JOB_LABEL}
#BSUB -M 
#BSUB -o ${JOB_LABEL}_matrix%J.log

${PARSER} 
EOF