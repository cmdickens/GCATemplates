#BSUB -L /bin/bash              # use bash for job initialization
#BSUB -J raxml_hybrid_avx       # job name
#BSUB -n 40                     # assigns 40 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 48:00                  # sets to 48 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load RAxML/8.2.11-intel-2017A-hybrid-avx

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
num_runs=100                    # number of alternative runs on distinct starting trees

mpi_threads=20                  # number of raxmlHPC commands across all nodes
perhost=10                      # number of raxmlHPC commands per node
pthreads=2                      # number of threads per raxmlHPC command

########## OUTPUTS #########
output_suffix="${model}_${algorithm}-hybrid-avx"

################################### COMMANDS ###################################
# 
# next line needed to override lsf and allow fewer than 20 mpi commands per host
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
mpiexec -perhost $perhost -np $mpi_threads raxmlHPC -T $pthreads -m $model -p $p_seed -s $input_dna_phy -N $num_runs -n $output_suffix


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML:
        A. Stamatakis: "RAxML Version 8: A tool for Phylogenetic Analysis and
        Post-Analysis of Large Phylogenies". In Bioinformatics, 2014
CITATION
