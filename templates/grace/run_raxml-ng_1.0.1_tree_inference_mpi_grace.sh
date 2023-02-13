#!/bin/bash
#SBATCH --job-name=raxml-ng         # job name
#SBATCH --time=1-00:00:00           # max job run time
#SBATCH --nodes=1                   # total number of nodes for job
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory
#SBATCH --output=stdout.%x.%j          # save stdout to file
#SBATCH --error=stderr.%x.%j           # save stderr to file

module load GCC/8.3.0  OpenMPI/3.1.4 RAxML-NG/1.0.1

<<README
    - RAxML manual: https://github.com/amkozlov/raxml-ng/wiki
README

######### SYNOPSIS #########
# Perform tree inference on DNA alignment

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# use example prim.phy
ln -s /scratch/data/bio/raxml-ng/ng-tutorial/prim.phy
input='prim.phy'

######## PARAMETERS ########
model='GTR+G'                   # see manual for many available options
threads=$SLURM_CPUS_PER_TASK   # number of threads per raxmlHPC command

########## OUTPUTS #########
# use defaults

################################### COMMANDS ###################################

raxml-ng-mpi --threads $threads --model $model --msa $input

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML-NG:
        A. Kozlov, D. Darriba, T. Flouri, B. Morel and A. Stamatakis: "RAxML-NG: a fast, scalable and user-friendly
        tool for maximum likelihood phylogenetic inference". Bioinformatics, 2019. (35)21
CITATION
