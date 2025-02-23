# scags
Steps on how to run and obtain Structurally Convergent Antibody Groups (**SCAGS**)

## Step one : Sequence and Structural BCR feature generation
<ins> **Sequence based features (VJ3 features)**</ins>
1. VJ3 sequence features: To generate sequence VJ3 features, CDR3 sequences for our study cohorts were clustered using MMseq2 as indicated in the following scripts ('_lsf-jobs/do_stage_cluster_mmseq2.sh_' and '_do_stage_search_mmseq2.sh_')
2. For each cluster, consensus amino acid sequences of the CDR3 were calculated using the following script ('_analysis/parse_mmseq2cluster.py_')
   
<ins> **Structure based features (SACGs features)**</ins>
