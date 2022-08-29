#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J provean                # job name
#BSUB -n 20                     # assigns 20 cores for execution
#BSUB -R "span[ptile=20]"       # assigns 20 cores per node
#BSUB -R "rusage[mem=2700]"     # reserves 2000MB memory per core
#BSUB -M 2700                   # sets to 2000MB process enforceable memory limit. (M * n)
#BSUB -W 1:00                   # sets to 1 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load PROVEAN/1.1.5-intel-2015B-Python-2.7.10

<<README
    - PROVEAN homepage: http://provean.jcvi.org/index.php
    - PROVEAN manual: http://provean.jcvi.org/help.php
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
query_file="$EBROOTPROVEAN/share/data/provean/examples/P04637.fasta"
variants_file="$EBROOTPROVEAN/share/data/provean/examples/P04637.var"

######## PARAMETERS ########
threads=20                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# outputs written to current directory

################################### COMMANDS ###################################
#
provean.sh --num_threads $threads -q $query_file -v $variants_file --tmp_dir $TMPDIR

<<CITATION
    - Acknowledge TAMU HPRC: http://sc.tamu.edu/research/citation.php

    - PROVEAN:
        Choi Y, Sims GE, Murphy S, Miller JR, Chan AP (2012) Predicting the Functional Effect of Amino Acid Substitutions and Indels.
        PLoS ONE 7(10): e46688.
CITATION
