# SCAGs
Steps on how to run and obtain Structurally Convergent Antibody Groups (**SCAGs**)

## Step one : Sequence and Structural BCR feature generation
<ins> **Sequence based features (VJ3 features)**</ins>
1. To generate sequence VJ3 features, CDR3 sequences of equal lengths using the same V and J segment genes for our study cohorts were clustered using MMseq2 as indicated in the following scripts
 - '_lsf-jobs/do_stage_cluster_mmseq2.sh_'
 - '_lsf-jobs/do_stage_search_mmseq2.sh_'
3. For each cluster, consensus amino acid sequences of the CDR3's were calculated using the following script
    - '_analysis/parse_mmseq2cluster.py_'
   
<ins> **Structure based features (SACGs features)**</ins>
1. Heavy chain immunoglobulin sequence receptor repertoire for our study cohorts were processed with SAAB+([paper](https://pubmed.ncbi.nlm.nih.gov/20034110/)), using SCALOP to annotate non-CDR3 regions and FREAD to annotate CDR3 regions (SAAB+ code)
2. SCAGs features were further annotated as follows: sequences having the same HCDR1, HCDR2 canonical and HCDR3 loop structures as annotated by SAAB+ are binned into a SCAGs group. SCAGs were further binned into groups based on their respective isotype (details in feature matrix creation section).

## Step two : Disease/Phenotype prediction using BCR sequence and structural features
<ins> **Disease prediction using VJ3 features**</ins>
1. To create VJ3 isotype and non isotype feature matrices, use the follosing scripts and steps
    - '_analysis/MakeSearchMatrix_clusters.py_' and '_analysis/MakeSearchMatrix_EmptySignature.py_'
        - Compile and run both scripts above using the commands found in '_lsf-jobs/do_make_MakeSearchMatrix_vj3.sh_'
2. Next run logistic regression model to predict disease or phenotype of interest using the following script
    - '_analysis/logistic_regression_model_updated.py_'
         - Compile and run the python script above using the commands found in '_lsf-jobs/do_machine_learning_model.sh_'

<ins> **Disease prediction using SCAGs features**</ins>
1. To create SCAGs non isotype feature matrix, use the follosing scripts and steps listed below
     - '_analysis/MakeSearchMatrix_structure.py_'
          - Run python script using the commands found in '_lsf-jobs/do_MakeSearchMatrix_scags.sh_'
2. To create SCAGs isotype and class-switched isotype feature matrices, use the scripts and steps listed below
    - '_analysis/MakeSearchMatrix_scags_isotype.py_'
    - '_analysis/MakeSearchMatrix_nonaive_features.py_'
         - Compile and run both scripts using the commands found in '_lsf-jobs/do_MakeSearchMatrix_scags_isotype.sh_'
3. Next run logistic regression model to predict disease or phenotype of interest using the following script

   
