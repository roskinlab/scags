#!/bin/bash
JOB_LABEL=$(basename "${SIGNATURE_FILE}" )

cat <<EOF
#BSUB -L /bin/bash
#BSUB -W 2:00
#BSUB -J add_parse_${JOB_LABEL}
#BSUB -M 12000
#BSUB -o ${JOB_LABEL}_scags%J.log

/MakeSearchMatrix_Structure.py set\=all/subject=* /metadata.csv

EOF
