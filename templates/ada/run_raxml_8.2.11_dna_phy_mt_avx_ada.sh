#BSUB -L /bin/bash              # use bash for job initialization
#BSUB -J raxml_mt_avx           # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load RAxML/8.2.11-intel-2017A-mt-avx

<<README
    - RAxML manual: https://github.com/stamatak/standard-RAxML/blob/master/manual/NewManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
input_dna_phy='/scratch/datasets/GCATemplates/data/raxml/1000_ARB'

######## PARAMETERS ########
model='GTRGAMMA'                # see manual for many available options
algorithm='a'                   # see manual for many available options
p_seed=12345                    # random seed for parsimony inferences
pthreads=20                     # number of threads per CPU core
num_runs=100                    # number of alternative runs on distinct starting trees

########## OUTPUTS #########
output_suffix="${model}_${algorithm}-mt-avx"

################################### COMMANDS ###################################
# 
raxmlHPC -T $pthreads -m $model -p $p_seed -s $input_dna_phy -N $num_runs -n $output_suffix


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML:
        A. Stamatakis: "RAxML Version 8: A tool for Phylogenetic Analysis and
        Post-Analysis of Large Phylogenies". In Bioinformatics, 2014
CITATION
