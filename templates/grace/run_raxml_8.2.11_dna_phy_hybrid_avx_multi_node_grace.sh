#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=raxmlHPC         # job name
#SBATCH --time=1-00:00:00           # max job run time
#SBATCH --nodes=5                   # total number of nodes for job
#SBATCH --ntasks-per-node=24        # tasks (commands) per compute node
#SBATCH --cpus-per-task=2           # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load iccifort/2019.5.281 impi/2018.5.288 RAxML/8.2.12-hybrid-avx2

<<README
    - RAxML manual: https://github.com/stamatak/standard-RAxML/blob/master/manual/NewManual.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
# sample data runtime with this script = 6 hrs
input_dna_phy='/scratch/data/bio/GCATemplates/data/raxml/1000_ARB'

######## PARAMETERS ########
model='GTRGAMMA'                # see manual for many available options
algorithm='a'                   # see manual for many available options
p_seed=12345                    # random seed for parsimony inferences
num_runs=100                    # number of alternative runs on distinct starting trees

mpi_threads=$(( $SLURM_JOB_NUM_NODES * $SLURM_NTASKS_PER_NODE ))    # number of raxmlHPC commands across all nodes
perhost=$SLURM_NTASKS_PER_NODE  # number of raxmlHPC commands per node
pthreads=$SLURM_CPUS_PER_TASK   # number of threads per raxmlHPC command

########## OUTPUTS #########
working_dir=`pwd`/working_multinode             # RAxML only accepts absolute path names, not relative ones
[ -d $working_dir ] || mkdir $working_dir       # make working_dir if it doesn't exist

output_suffix="${model}_${algorithm}-hybrid-avx-multinode"

################################### COMMANDS ###################################

mpiexec -perhost $perhost -np $mpi_threads raxmlHPC -T $pthreads -m $model -p $p_seed -s $input_dna_phy -N $num_runs -n $output_suffix -w $working_dir

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - RAxML:
        A. Stamatakis: "RAxML Version 8: A tool for Phylogenetic Analysis and
        Post-Analysis of Large Phylogenies". In Bioinformatics, 2014
CITATION
