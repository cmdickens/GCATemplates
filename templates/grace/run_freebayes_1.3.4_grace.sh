#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=freebayes        # job name
#SBATCH --time=7-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load FreeBayes/1.3.4-linux-static-AMD64

<<README
    - FreeBayes manual: https://github.com/ekg/freebayes
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
reference_fasta='/scratch/data/bio/GCATemplates/e_coli/ref/GCF_000005845.2_ASM584v2_genomic.fna'
alignments_bam='/scratch/data/bio/GCATemplates/e_coli/aln/SRR10561103_sorted.bam'

######## PARAMETERS ########
sample_name='SRR10561103'

########## OUTPUTS #########
output_vcf="${sample_name}_freebayes_out.vcf"

################################### COMMANDS ###################################

freebayes --fasta-reference $reference_fasta --bam $alignments_bam > $output_vcf

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - FreeBayes:
        Garrison E, Marth G. Haplotype-based variant detection from short-read sequencing.
        arXiv preprint arXiv:1207.3907 [q-bio.GN] 2012
CITATIONS
