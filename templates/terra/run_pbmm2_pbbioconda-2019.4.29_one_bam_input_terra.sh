#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=pbmm2            # job name
#SBATCH --time=06:00:00             # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=28          # CPUs (threads) per command
#SBATCH --mem=54G                   # total memory per node
#SBATCH --output=stdout.%j          # save stdout to file
#SBATCH --error=stderr.%j           # save stderr to file

module load Anaconda/2-5.0.1
module load BamTools/2.5.1-GCCcore-7.3.0
source activate pbbioconda-2019.4.29

<<README
    - pbmm2 manual: https://github.com/PacificBiosciences/pbmm2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
ref_fasta='/scratch/datasets/bio/GCATemplates/data/pacbio/arabidopsis_thaliana/hgap4_assembly/Arabidopsis_assembly.fasta'
pacbio_bam='/scratch/datasets/bio/GCATemplates/data/pacbio/arabidopsis_thaliana/A01_customer/m54113_160913_184949.subreads.bam'

######## PARAMETERS ########
cpus=$SLURM_CPUS_PER_TASK           # requesting all 28 cores uses 21 alignment cores and 7 sorting cores

########## OUTPUTS #########
pbmm2_out_bam='A01_customer_pbmm2.bam'
log_file='out_pbmm2.log'

################################### COMMANDS ###################################
# NOTE index genome only if not using an already indexed genome from /scratch/datasets/genome_indexes/ucsc/

if [ ! -f ${ref_genome}.mmi ]; then
  pbmm2 index $ref_fasta ${ref_fasta}.mmi
fi

pbmm2 align --alignment-threads $(($cpus-7)) ${ref_fasta}.mmi $pacbio_bam $pbmm2_out_bam --sort --sort-memory 2G

################################################################################
<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - pbbioconda: pbmm2:
        pacb.com
CITATION
