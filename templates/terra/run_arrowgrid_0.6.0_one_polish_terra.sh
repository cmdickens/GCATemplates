#!/bin/bash                                                        
#SBATCH --export=NONE               # do not export current env to the job                                       
#SBATCH --job-name=arrow_polish     # job name       
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command  
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load ArrowGrid_HPRC/0.6.0-iomkl-2017b
source activate pbbioconda

<<README
    - ArrowGrid: https://github.com/skoren/ArrowGrid
    - ArrowGrid_HPRC: https://hprc.tamu.edu/wiki/Ada:NGS:Genome_Assembly#ArrowGrid_HPRC
README

################################### VARIABLES ##################################
# TODO edit these variables as needed:

########## INPUTS ##########
genome='mygenome.fasta'

# you must create a file of file names called input.fofn with one subreads.bam entry per line

######## PARAMETERS ########
# run arrow.sh --help for additional options
# required SUs =~ (number_of_subreads.bam_files * 2000) + 7000

########## OUTPUTS #########
prefix='mygenome_arrow_out'

################################### COMMANDS ###################################

arrow.sh -p $prefix -g $genome

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - ArrowGrid: (cite both papers)
        Chin et al. Nonhybrid, finished microbial genome assemblies from long-read SMRT
        sequencing data. Nature Methods, 2013.

        Koren S et al. Canu: scalable and accurate long-read assembly via adaptive k-mer
        weighting and repeat separation. Genome Research. (2017).
CITATION
