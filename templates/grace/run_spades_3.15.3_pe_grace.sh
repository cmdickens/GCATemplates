#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=spades           # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=24          # CPUs (threads) per command
#SBATCH --mem=180G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0 SPAdes/3.15.3

<<README
    - SPAdes manual: http://spades.bioinf.spbau.ru/release3.5.0/manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/m_tuberculosis/ERR551611_pe_2.fastq.gz'

######## PARAMETERS ########
threads=$SLURM_CPUS_PER_TASK
max_memory=180

########## OUTPUTS #########
output_dir='ERR551611_out'

################################### COMMANDS ###################################

spades.py -1 $pe1_1 -2 $pe1_2 --threads $threads --memory $max_memory -o $output_dir

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SPAdes:
        Bankevich A., et al. SPAdes: A New Genome Assembly Algorithm 
        and Its Applications to Single-Cell Sequencing.
        J Comput Biol. 2012 May; 19(5): 455–477. doi:  10.1089/cmb.2012.0021
CITATIONS
