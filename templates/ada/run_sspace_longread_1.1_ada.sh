#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J sspace-longread        # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load SSPACE-LongRead/1.1

<<README
    - SSPACE-LongRead manual: http://www.baseclear.com/genomics/bioinformatics/basetools/SSPACE-longread
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# File containing PacBio CLR sequences to be used scaffolding (REQUIRED)
pacbio_reads='16109Ros_all.fastq'

# Fasta file containing contig sequences used for scaffolding (REQUIRED)
fasta_contig_file='45per_malinche_discovar.fasta'

######## PARAMETERS ########
threads=10                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
# SSPACE-LongRead.pl may perform better by removing scaffolds < 3000 bp. 
perl $SSPACE_ROOT/SSPACE-LongRead.pl -c $fasta_contig_file -p $pacbio_reads -t $threads

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - SSPACE-LongRead:
        Boetzer M, Pirovano W: SSPACE-LongRead: scaffolding bacterial draft genomes using long read sequence information.
        BMC Bioinformatics 2014.
CITATION
