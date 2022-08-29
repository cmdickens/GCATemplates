#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J cegma                  # job name
#BSUB -n 8                      # assigns 8 cores for execution
#BSUB -R "span[ptile=8]"        # assigns 8 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 8:00                   # sets to 8 hours the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load CEGMA/2.5-intel-2015B

<<README
    - CEGMA Manual: https://github.com/KorfLab/CEGMA_v2
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########

assembly='test.fa'

######## PARAMETERS ########
export CEGMATMP=$TMPDIR

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
#
cegma --genome $assembly

<<CITATION
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    CEGMA:
        Genis Parra, Keith Bradnam and Ian Korf. CEGMA: a pipeline to accurately annotate core genes in eukaryotic genomes.
        Bioinformatics, 23: 1061-1067 (2007).
CITATION
