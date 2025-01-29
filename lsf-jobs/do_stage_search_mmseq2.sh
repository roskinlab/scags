#!/usr/bin/bash

COVERAGE=1.0
PERCENT=0.9


MMSEQ=/data/RoskinLab/shared/programs/mmseqs2/latest/bin/mmseqs
USER=username
size=$(ls -l data/clusters|awk '{print $5;}')


cat <<EOF

#### process inputs
# make temp input file and input directory
#TMP_DIR=\$(mktemp -d /tmp/data_search_XXXXXXXXXXX)
TMP_DIR=\$(mktemp -d /scratch/${USER}/data_search_XXXXXXXXXXX)
echo temp directory is \${TMP_DIR} on host \${HOSTNAME}

# exit if temp directory wasn't created successfully
if [ ! -e \${TMP_DIR} ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi

# ensure temp. directory gets removed even if the script exits abnormally
trap "exit 1"           HUP INT PIPE QUIT TERM

#### do work
### check if the file is empty by looking at the size of the file
if ((${size} > 3 )); then

${MMSEQ} createdb set=all/subject=*.fasta \${TMP_DIR}/queryDB --dbtype 1 --id-offset 1 --compressed 1 
${MMSEQ} createdb data/Consensus.fasta \${TMP_DIR}/targetDB --dbtype 1 --compressed 1 
${MMSEQ} search \${TMP_DIR}/queryDB \${TMP_DIR}/targetDB \${TMP_DIR}/hitDB \${TMP_DIR}/tmp \\
    --cov-mode 0 -c ${COVERAGE} --alignment-mode 3 --min-seq-id ${PERCENT} \\
    --mask 0 -e inf -s 7.5 --max-seqs 20 --comp-bias-corr 0 -k 5 --spaced-kmer-mode 0 --compressed 1 --qsc -50

#### process outputs
${MMSEQ} convertalis \${TMP_DIR}/queryDB \${TMP_DIR}/targetDB \${TMP_DIR}/hitDB data/probe_clusters --compressed 1 
else
    echo > data/probe_clusters
fi
#### clean up
#rm -r \${TMP_DIR}
trap 'rm -rv "\${TMP_DIR}"' EXIT
EOF
