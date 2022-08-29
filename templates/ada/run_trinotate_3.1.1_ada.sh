#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J trinotate              # job name
#BSUB -n 10                     # assigns 10 cores for execution
#BSUB -R "span[ptile=10]"       # assigns 10 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2,500MB (~2.5GB) per process enforceable memory limit. (M * n)
#BSUB -W 96:00                  # sets to 96 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load Trinotate/3.1.1-intel-2017A-Python-2.7.12

<<README
    - Trinotate manual: https://trinotate.github.io/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
query_fasta='Trinity.fasta'     # your transcripts fasta input file

######## PARAMETERS ########
threads=10                      # make sure this is <= your BSUB -n value

########## OUTPUTS #########
map_file=`basename $query_fasta`.gene_to_trans_map  # no need to change map_file name

################################### COMMANDS ###################################
# the next three lines will copy the Trinotate.sqlite file if it doesn't exist already
if [ ! -f Trinotate.sqlite ]; then
    cp $EBROOTTRINOTATE/resources/Trinotate.sqlite ./
fi
chmod 755 Trinotate.sqlite

$TRINITY_HOME/util/support_scripts/get_Trinity_gene_to_trans_map.pl $query_fasta > $map_file

$TRINOTATE_HOME/auto/autoTrinotate.pl --transcripts $query_fasta --CPU $threads --Trinotate_sqlite Trinotate.sqlite --gene_to_trans_map $map_file

<<CITATION
    - Acknowledge TAMU HPRC: http://hprc.tamu.edu/research/citation.php

    - Trinotate citation: Trinotate has not been published
        - Accompanying programs citations found at the bottom of this page: https://trinotate.github.io/
CITATION
