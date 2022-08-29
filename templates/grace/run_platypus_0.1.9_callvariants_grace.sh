#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=platypus         # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=48          # CPUs (threads) per command
#SBATCH --mem=360G                  # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load GCC/10.2.0  OpenMPI/4.0.5  Platypus/0.8.1-Python-2.7.18

<<README
    - Platypus manual: https://www.rdm.ox.ac.uk/research/lunter-group/lunter-group/platypus-documentation
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
reference_fasta='/scratch/data/bio/GCATemplates/miseq/c_dubliniensis/C_dubliniensis_CD36_short_chromosomes.fasta'
alignments_bam='/scratch/data/bio/GCATemplates/miseq/c_dubliniensis/dr34_sorted.bam'

######## PARAMETERS ########
sample_name='DR34'

########## OUTPUTS #########
output_vcf="${sample_name}_platypus_out.vcf"

################################### COMMANDS ###################################

Platypus.py callVariants --nCPU=$SLURM_CPUS_PER_TASK --bamFiles=$alignments_bam --refFile=$reference_fasta --output=$output_vcf

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Platypus:
            Andy Rimmer, Hang Phan, Iain Mathieson, Zamin Iqbal, Stephen R. F. Twigg, WGS500 Consortium, Andrew O. M. Wilkie,
            Gil McVean, Gerton Lunter. Integrating mapping-, assembly- and haplotype-based approaches for calling variants
            in clinical sequencing applications. Nature Genetics (2014) doi:10.1038/ng.3036
CITATIONS
