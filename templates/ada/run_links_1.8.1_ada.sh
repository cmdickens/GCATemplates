#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J links                  # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load LINKS/1.8.6-intel-2017A-Python-2.7.12

<<README
    - LINKS manual: http://www.bcgsc.ca/platform/bioinfo/software/links
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
# file-of-filenames
file_of_filenames='nanodata.txt'

# Fasta file containing contig sequences used for scaffolding (REQUIRED)
fasta_contig_file='45per_malinche_discovar.fasta'

######## PARAMETERS ########
threads=10                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# use LINKS.pl output defaults

################################### COMMANDS ###################################
# 
LINKS.pl -f $fasta_contig_file -s $file_of_filenames -d 500,1000,2000,3000,4000,5000,7000,10000,12000,15000,18000,20000,25000,30000,40000

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - LINKS:
        René L. Warren, Chen Yang, Benjamin P. Vandervalk, Bahar Behsaz, Albert Lagman,Steven J. M. Jones and Inanç Birol. 2015.
        LINKS: Scalable, alignment-free scaffolding of draft genomes with long reads. GigaScience. 4:35
CITATION
