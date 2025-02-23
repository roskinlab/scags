# SCAGs
Steps on how to run and obtain Structurally Convergent Antibody Groups (**SCAGs**)

## Step one : Sequence and Structural BCR feature generation
<ins> **Sequence based features (VJ3 features)**</ins>
1. VJ3 sequence features: To generate sequence VJ3 features, CDR3 sequences of equal lengths using the same V and J segment genes for our study cohorts were clustered using MMseq2 as indicated in the following scripts ('_lsf-jobs/do_stage_cluster_mmseq2.sh_' and '_lsf-jobs/do_stage_search_mmseq2.sh_')
2. For each cluster, consensus amino acid sequences of the CDR3's were calculated using the following script ('_analysis/parse_mmseq2cluster.py_')
   
<ins> **Structure based features (SACGs features)**</ins>
1. Heavy chain immunoglobulin sequence receptor repertoire for our study cohorts were processed with SAAB+([paper](https://pubmed.ncbi.nlm.nih.gov/20034110/)), using SCALOP to annotate non-CDR3 regions and FREAD to annotate CDR3 regions
2. SCAGs features were further annotated as follows: sequences having the same HCDR1, HCDR2 canonical and HCDR3 loop structures as annotated by SAAB+ are binned into a SCAGs group. SCAGs were further binned into groups based on their respective isotype.
