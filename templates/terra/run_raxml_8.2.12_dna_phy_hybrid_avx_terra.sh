#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=raxml-hybrid     # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --nodes=2                   # number of compute nodes
#SBATCH --ntasks-per-node=14        # tasks (commands) per compute node
#SBATCH --cpus-per-task=2           # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load RAxML/8.2.12-iimpi-2019b-hybrid-avx2

<<README
    - RAxML manual: https://github.com/stamatak/standard-RAxML/blob/master/manual/NewManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
input_dna_phy='/scratch/data/bio/GCATemplates/raxml/1000_ARB'

######## PARAMETERS ########
model='GTRGAMMA'                    # see manual for many available options
algorithm='a'                       # see manual for many available options
p_seed=12345                        # random seed for parsimony inferences
num_runs=100                        # number of alternative runs on distinct starting trees

mpi_threads=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))   # number of raxmlHPC commands across all nodes
perhost=$SLURM_NTASKS_PER_NODE      # number of raxmlHPC commands per node
pthreads=$SLURM_CPUS_PER_TASK       # number of threads per raxmlHPC command

########## OUTPUTS #########
output_suffix="${model}_${algorithm}-${p_seed}-${num_runs}-hybrid-avx"

################################### COMMANDS ###################################

mpiexec -perhost $perhost -np $mpi_threads raxmlHPC -T $pthreads -m $model -p $p_seed -s $input_dna_phy -N $num_runs -n $output_suffix

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML:
        A. Stamatakis: "RAxML Version 8: A tool for Phylogenetic Analysis and
        Post-Analysis of Large Phylogenies". In Bioinformatics, 2014
CITATION
