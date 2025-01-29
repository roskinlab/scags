#!/usr/bin/bash

COVERAGE=1.0
PERCENT=0.9

MMSEQ=/mmseqs2/latest/bin/mmseqs
count=$(ls set=train/ |wc -l)
USER=username

cat <<EOF

echo 'Part one: process inputs'
#### process inputs
###BSUB -R "rusage[tmp=30G]"
# make temp input file and input directory
#TMP_DIR=\$(mktemp -d /tmp/data_cluster_XXXXXXXXXXX)
TMP_DIR=\$(mktemp -d /scratch/${USER}/data_cluster_XXXXXXXXXXX)
echo temp directory is \${TMP_DIR} on host \${HOSTNAME}

# exit if temp directory wasn't created successfully
if [ ! -e \${TMP_DIR} ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi
# ensure temp. directory gets removed even if the script exits abnormally
trap "exit 1"     HUP INT PIPE QUIT TERM

echo 'Part two: do work'
#### do work
# check if the number of subjects pass a cutoff
if ((${count} < 5)); then
mkdir -p data/
echo > data/clusters
echo  > data/Consensus.fasta

else

${MMSEQ} createdb set=train/subject=*.fasta \${TMP_DIR}/seqDB --dbtype 1 --id-offset 1 --compressed 1
${MMSEQ} cluster \${TMP_DIR}/seqDB \${TMP_DIR}/clustDB \${TMP_DIR}/tmp --cov-mode 0 -c ${COVERAGE} --alignment-mode 3 --min-seq-id ${PERCENT} --mask 0 -e inf -s 7.5 --max-seqs 20 --comp-bias-corr 0 -k 5 --spaced-kmer-mode 0 --compressed 1 --max-seq-len 655366 
${MMSEQ} result2profile \${TMP_DIR}/seqDB \${TMP_DIR}/seqDB \${TMP_DIR}/clustDB \${TMP_DIR}/profileDB --compressed 1 --filter-msa 0 -e inf  --mask-profile 0  
${MMSEQ} profile2consensus \${TMP_DIR}/profileDB \${TMP_DIR}/consensusDB --compressed 1
${MMSEQ} createtsv \${TMP_DIR}/seqDB \${TMP_DIR}/seqDB \${TMP_DIR}/clustDB \${TMP_DIR}/clustTSV --compressed 1
${MMSEQ} convert2fasta \${TMP_DIR}/consensusDB \${TMP_DIR}/consensusDB.fasta

echo -n tmp is taking up " " ; du -h \${TMP_DIR}/tmp
echo 'Part three: process outputs'
#### process outputs
mkdir -p data/
/data/RoskinLab/team/kachi/project_dir_kachi/pipeline_module/python_scripts/parse_mmseq2cluster.py \${TMP_DIR} 
fi

echo 'Part four: clean up'
#### clean up
#rm -rv \${TMP_DIR}
trap 'rm -rv "\${TMP_DIR}"' EXIT
EOF

