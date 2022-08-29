#!/bin/bash
#SBATCH --export=NONE               # do not export current env to the job
#SBATCH --job-name=trimmomatic      # job name
#SBATCH --time=1-00:00:00           # max job run time dd-hh:mm:ss
#SBATCH --ntasks-per-node=1         # tasks (commands) per compute node
#SBATCH --cpus-per-task=2           # CPUs (threads) per command
#SBATCH --mem=4G                    # total memory per node
#SBATCH --output=stdout.%x.%j       # save stdout to file
#SBATCH --error=stderr.%x.%j        # save stderr to file

module load Trimmomatic/0.39-Java-11

<<README
    - Trimmomatic manual:
        http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:

########## INPUTS ##########
pe1_1='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_1.fastq.gz'
pe1_2='/scratch/data/bio/GCATemplates/e_coli/rnaseq/SRR639782_2.fastq.gz'

######## PARAMETERS ########
cpus=$SLURM_CPUS_PER_TASK
min_length=30
quality_format='-phred33'       # -phred33, -phred64    # see https://en.wikipedia.org/wiki/FASTQ_format#Encoding 
adapter_file="$EBROOTTRIMMOMATIC/adapters/TruSeq3-PE.fa"
    # available adapter files:
    #   Nextera:      NexteraPE-PE.fa
    #   GAII:         TruSeq2-PE.fa,   TruSeq2-SE.fa
    #   HiSeq,MiSeq:  TruSeq3-PE-2.fa, TruSeq3-PE.fa, TruSeq3-SE.fa

########## OUTPUTS #########
prefix='SRR639782'

################################### COMMANDS ###################################

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar \
PE -threads $cpus $quality_format $pe1_1 $pe1_2 \
${prefix}_pe1_trimmo.fastq.gz ${prefix}_se1_trimmo.fastq.gz \
${prefix}_pe2_trimmo.fastq.gz ${prefix}_se2_trimmo.fastq.gz \
ILLUMINACLIP:$adapter_file:2:30:10 MINLEN:$min_length

################################################################################
<<CITATIONS
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - Trimmomatic:
        Anthony M. Bolger1,2, Marc Lohse1 and Bjoern Usadel. Trimmomatic: A flexible trimmer for Illumina Sequence Data.
        Bioinformatics. 2014 Aug 1;30(15):2114-20. doi: 10.1093/bioinformatics/btu170.
CITATIONS
