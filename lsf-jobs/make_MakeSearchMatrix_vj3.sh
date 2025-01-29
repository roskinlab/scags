#!/bin/bash

size=$(ls -l data/clusters|awk '{print $5;}')

cat <<EOF

## check if the cluster file is empty by looking up the size of the file 
if ((${size} > 3 )); then
MakeSearchMatrix.py data/probe_clusters set\=all/subject=* 
else
/MakeSearchMatrix_EmptySignature.py set\=all/subject=* 

fi
EOF
