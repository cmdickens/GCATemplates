#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J quast                  # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=1000]"     # reserves 1000MB memory per core
#BSUB -M 1000                   # sets to 1000MB per process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load QUAST/3.2-intel-2015B

<<README
    - QUAST manual: http://quast.bioinf.spbau.ru/manual.html
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
contigs='de_novo-contigs.fa'

######## PARAMETERS ########
threads=8                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# outputs written to default directory quast_results

################################### COMMANDS ###################################
#
quast.py -t $threads $contigs


<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - QUAST:
        Alexey Gurevich, Vladislav Saveliev, Nikolay Vyahhi and Glenn Tesler,
        QUAST: quality assessment tool for genome assemblies,
        Bioinformatics (2013) 29 (8): 1072-1075. doi: 10.1093/bioinformatics/btt086
CITATION
