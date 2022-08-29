#BSUB -L /bin/bash              # uses the bash login shell to initialize the job's execution environment.
#BSUB -J transdecoder           # job name
#BSUB -n 4                      # assigns 4 cores for execution
#BSUB -R "span[ptile=4]"        # assigns 4 cores per node
#BSUB -R "rusage[mem=2500]"     # reserves 2500MB memory per core
#BSUB -M 2500                   # sets to 2500MB per process enforceable memory limit. (M * n)
#BSUB -W 24:00                  # sets to 24 hour the job's runtime wall-clock limit.
#BSUB -o stdout.%J              # directs the job's standard output to stdout.jobid
#BSUB -e stderr.%J              # directs the job's standard error to stderr.jobid

module load TransDecoder/3.0.1-intel-2015B-Perl-5.20.0

<<'README'
    - TransDecoder Manual: http://transdecoder.github.io/
README

################################### VARIABLES ##################################
# TODO Edit these variables as needed:
########## INPUTS ##########
transcripts_fasta='Trinity.fasta'

######## PARAMETERS ########
threads=4                       # make sure this is <= your BSUB -n value

########## OUTPUTS #########
# use output defaults

################################### COMMANDS ###################################
# 
TransDecoder.LongOrfs -t $transcripts_fasta
        
TransDecoder.Predict --cpu $threads -t $transcripts_fasta

<<'CITATION'
    - Acknowledge TAMU HPRC: https://hprc.tamu.edu/research/citations.html

    - TransDecoder: Haas & Papanicolaou et al., manuscript in prep.  http://transdecoder.github.io
CITATION
