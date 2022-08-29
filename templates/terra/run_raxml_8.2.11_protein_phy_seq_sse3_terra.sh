#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=raxmlprot        # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load RAxML/8.2.11-intel-2017b-hybrid-avx

<<README
    - RAxML manual: https://github.com/stamatak/standard-RAxML/blob/master/manual/NewManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
input_protein_phy='/scratch/data/bio/GCATemplates/raxml/protein.phy'

######## PARAMETERS ########
cpus=$SLURM_CPUS_PER_TASK
model='PROTGAMMALG'                 # see manual for many available options
algorithm='a'                       # see manual for many available options
p_seed=12345                        # random seed for parsimony inferences
x_seed=12345                        # random seed integer for bootstrapping
num_runs=100                        # number of alternative runs on distinct starting trees

########## OUTPUTS #########
output_suffix="${model}_${algorithm}"

################################### COMMANDS ###################################

raxmlHPC -f $algorithm -T $cpus -p $p_seed -x $x_seed -m $model -N $num_runs -s $input_protein_phy -n $output_suffix

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML:
        A. Stamatakis: "RAxML Version 8: A tool for Phylogenetic Analysis and
        Post-Analysis of Large Phylogenies". In Bioinformatics, 2014
CITATION
