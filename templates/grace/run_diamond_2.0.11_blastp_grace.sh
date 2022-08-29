#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=diamond          # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/9.3.0 DIAMOND/2.0.11

<<README
    - DIAMOND manual: https://github.com/bbuchfink/diamond/wiki
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
query_proteins='/scratch/data/bio/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_protein.faa'
diamond_db='/scratch/data/bio/diamond/nr.dmnd'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK

########## OUTPUTS #########
output='matches.tsv'

################################### COMMANDS ###################################

diamond blastp  --threads $threads --db $diamond_db --query $query_proteins --out $output

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - DIAMOND:
        Buchfink B, Reuter K, Drost HG, "Sensitive protein alignments at tree-of-life scale using DIAMOND",
        Nature Methods 18, 366–368 (2021). doi:10.1038/s41592-021-01101-x
CITATION
